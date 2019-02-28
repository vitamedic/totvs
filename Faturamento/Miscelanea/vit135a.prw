#include "rwmake.ch"       

User Function VIT135a()     


SetPrvt("_CFILSA4,_CFILSD2,_CFILSF2,_CFILSA1")
SetPrvt("_CARQ,_LCONTINUA,_NHANDLE,_NITENS,_NVOLUMES")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT135A ³ Autor ³ Gardenia Ilany        ³ Data ³ 16/04/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao do Arquivo para Transmissao                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³ FTPSETTYPE,FTPPASV ³Autor³ Edson G.Barbosa ³Data³ 19/04/04 ³±±
±±³          ³ Tratamento e Exlusao do Arquivo no FTP.                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/


if msgbox("Confirma geracao do(s) arquivo(s) para transmissao?","Atencao","YESNO")
	processa({|| _geraarq()})
	msginfo("Arquivo(s) gerado(s) com sucesso!")
	sysrefresh()
endif
return


Static function _geraarq()
_cfilsa4:=xfilial("SA4")
_cfilsa1:=xfilial("SA1")
_cfilsd2:=xfilial("SD2")
_cfilsf2:=xfilial("SF2")
sa4->(dbsetorder(1))
sa1->(dbsetorder(1))
sd2->(dbsetorder(3))
sf2->(dbsetorder(1))
sx1->(dbseek("VIT135"+"06"))
_ano:=substr(strzero(year(ddatabase),4,0),3,2)
_narqseq:=val(substr(sx1->x1_cnt01,1,6))
_nitens:=0
procregua(tmp1->(lastrec()))
tmp1->(dbgotop())
_tot:=0
_narqseq:=strzero(_narqseq,6,0)
_narqseq2:=strzero(val(_narqseq)+1,6,0)
_carq:=mv_par08+"_"+_ano+_narqseq2+".txt"
if file(_carq)
	_lcontinua:=msgbox("O arquivo "+_carq+" ja existe! Sobrepor?","Atencao","YESNO")
	if _lcontinua
		ferase(_carq)
	endif
endif
while ! tmp1->(eof())
	_cliente:=tmp1->cliente
	_loja:=tmp1->loja
	_passou :=.t.  
	_totnota:=0
	while ! tmp1->(eof()) .and. _cliente==tmp1->cliente .and. _loja == tmp1->loja
		if tmp1->(marked("OK"))
			incproc("Gerando arquivo da nota fiscal "+tmp1->serie+tmp1->doc)
			_lcontinua:=.t.
//		if file(_carq)
//			_lcontinua:=msgbox("O arquivo "+_carq+" ja existe! Sobrepor?","Atencao","YESNO")
//			if _lcontinua
//				ferase(_carq)
//			endif
//		endif
			if _passou
				if _lcontinua
					_narqseq:=strzero(val(_narqseq)+1,6,0)
					_carq:=mv_par08+"_"+_ano+_narqseq+".txt"
					_nhandle:=fcreate(_carq,0)
					frename(_carq,"\passe\envio\"+_carq)
					if _nhandle<0
						msginfo("Erro na criacao do arquivo "+_carq)
						_lcontinua:=.f.
					endif
				endif
			  	_seq:=1
			  	_header()
			  	_passou:=.f.
			endif	
			if _lcontinua
				sa4->(dbseek(_cfilsa4+mv_par05))
				sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
				_totnota+=1
				_seq+=1
	  		   // REGISTRO DETALHE
				_demis:= strzero(day(tmp1->emissao),2,0)+strzero(month(tmp1->emissao),2,0)+strzero(year(tmp1->emissao),4,0)
				fwrite(_nhandle,"23")                    // COD-REGISTRO
				fwrite(_nhandle,"2")          	        // TIPO CLIENTE
				fwrite(_nhandle,sa1->a1_cgc)             // CNPJ CLIENTE
				fwrite(_nhandle,sa1->a1_est)			 	  // UF CLIENTE
				fwrite(_nhandle,_demis) 					  // DATA EMISSÃO DA NOTA
				fwrite(_nhandle,strzero(val(tmp1->doc),8,0))       // No. DA NOTA
				fwrite(_nhandle,strzero(int(tmp1->valbrut),14,0))  // VALOR DA NOTA
				fwrite(_nhandle,"00175")    				            // CODIGO PRODUTO FORNECIDO PELA SEFAZ
				fwrite(_nhandle,tmp1->serie)                       // SERIE DA NOTA FISCAL
				fwrite(_nhandle,"   ")                       // SERIE DA NOTA FISCAL
				fwrite(_nhandle,replicate(" ",60))                 // ESPAÇOS EM BRANCO
				fwrite(_nhandle,strzero(_seq,8,0))         			// VALOR-BRUTO-TOTAL
				fwrite(_nhandle,chr(13)+chr(10))                   // MUDANCA DE LINHA
				_tot+=int(tmp1->valbrut)
				if (_totnota/10)=1 
				  _passou :=.t.
				  _trailer()
  				  _envia()
				  _totnota:=0
				endif  
	      endif
		else
			incproc()
		endif
		tmp1->(dbskip())
	end	
	if _totnota <10
		_trailer()
	  	_envia()
	endif
end      
sx1->(reclock("SX1",.f.))
sx1->x1_cnt01:=_narqseq
sx1->(msunlock())

return


static function _header()
	// REGISTRO HEADER
	sa4->(dbseek(_cfilsa4+mv_par05))
	_dgera:= strzero(day(ddatabase),2,0)+strzero(month(ddatabase),2,0)+strzero(year(ddatabase),4,0)		             
	_hora:= substr(time(),1,2)+substr(time(),4,2)
	fwrite(_nhandle,"03")                          // COD-REGISTRO
	fwrite(_nhandle,_dgera)                        // DATA DA GERAÇÃOO DO ARQUIVO
	fwrite(_nhandle,_hora)                         // HORA DA GERAÇÃOO DO ARQUIVO
	fwrite(_nhandle,strzero(val(mv_par07),9,0))    // INSCRIÇÃO ESTADUAL DO REMETENTE
	fwrite(_nhandle,mv_par08)                      // No. DO CREDENCIAMENTO
	fwrite(_nhandle,strzero(val(sa4->a4_cgc),14,0))                  // CNPJ TRANSPORTADORA
	fwrite(_nhandle,sa4->a4_est)                   // ESTADO DA TRANPORTADORA
	fwrite(_nhandle,"1")                           // TIPO DO DOCUMENTO DO RESPONSÁVEL
	fwrite(_nhandle,strzero(val(sa4->a4_cpfmot),11,0))                  // CPF MOTORISTA
	fwrite(_nhandle,sa4->a4_estmot)                // ESTADO DO MOTORISTA
//	fwrite(_nhandle,strzero(val(mv_par09),11,0))   // No. DO DOCUMENTO DO RESPONSÁVEL
//	fwrite(_nhandle,mv_par10)                      // ÓRGÃO EMISSOR DO DOCUMENTO DO RESPONSÁVEL
	fwrite(_nhandle,_ano+_narqseq)                 // No. DO ARQUIVO
	fwrite(_nhandle,replicate(" ",54))             // NUMERO-PEDIDO-3
	fwrite(_nhandle,"00000001")                    // COD-EAN-COMPRADOR
	fwrite(_nhandle,chr(13)+chr(10))               // MUDANCA DE LINHA
return 

   
static function _trailer

	@ prow()+1,000 PSAY "99"
	@ prow(),002 PSAY strzero(_seq-1,6,0)
	@ prow(),008 PSAY strzero(int(_tot),14,0)
	@ prow(),120 PSAY strzero(_seq+1,8,0)  

	// REGISTRO TRAILER
	fwrite(_nhandle,"99")                         // COD-REGISTRO
	fwrite(_nhandle,strzero(_seq-1,6,0))          // QTDE. NOTAS FISCAIS ENVIADAS
	fwrite(_nhandle,strzero(int(_tot),14,0))		 // VALOR TOTAL DAS NF´S ENVIADAS
	fwrite(_nhandle,replicate(" ",98))           // NUM-TOTAL-ITENS-NOTA
	fwrite(_nhandle,strzero(_seq+1,8,0))           // NUM-TOTAL-ITENS-NOTA
	fwrite(_nhandle,chr(13)+chr(10))              // MUDANCA DE LINHA
	fclose(_nhandle)
	_tot:=0
//	tmp1->(dbdelete())
return

static function _envia()
local cserverftp,cuser,cpassword
cserverftp:="enviapasse.sefaz.go.gov.br"
cuser     :="43362"
cpassword :="43VI@%ta"
if ! ftpconnect(cserverftp,,cuser,cpassword)
	msgstop("Falha de conexao com o servidor "+cserverftp)
else
   FTPSetType(0)    //para definir o tipo de transferência...
                   //0 – ASCII, 1 – BINARY, 2-DEFAULT
   FTPSETPASV(.f.)  // .t. para ligar o modo passivo e .f. para desligar
	_nVezes := 0
	While .t.
		_nVezes++
   	msgrun("Aguarde, transferindo arquivo "+_carq,,{|| _lret:=ftpupload("\passe\envio\"+_carq,_carq)})
		if ! _lret 
		   If _nVezes == 3
			   If msgyesno("Falha na transferência do arquivo "+chr(13)+chr(10)+_carq+". Tenta Novamente?")
			      //msgstop("Falha na transferência do arquivo "+_carq)
				   _nVezes:= 0
				   Loop
			   Else
				   Exit
				Endif
			Endif
		Else
			Exit
		endif	
	End
	ftpdisconnect()
endif
return
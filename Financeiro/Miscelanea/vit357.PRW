/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT357 ³ Autor ³ Alex Júnio de Miranda   ³ Data ³ 04/05/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao do Arquivo Dados Cobranca para Importacao no       ³±±
±±³          ³ Software CredCob da Caixa Economica Federal                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"       
#include "topconn.ch"

User Function vit357()     


SetPrvt("_CARQ,_LCONTINUA,_HDL,")

Private _cperg := "PERGVIT357"

_pergsx1()

pergunte(_cPerg,.t.)

if msgbox("Confirma geracao do arquivo para importacao?","Atencao","YESNO")
	processa({|| _geraarq()})
	msginfo("Arquivo gerado com sucesso!")
	sysrefresh()
endif
return



Static function _geraarq()
_cfilsa1:=xfilial("SA1")
_cfilse1:=xfilial("SE1")
sa1->(dbsetorder(1))
se1->(dbsetorder(1))

lcontinua:= .t.

if mv_par06==1
	_carq:="C:\cobcx"+dtos(date())+".txt"
else
	_carq:="C:\cobcx"+alltrim(mv_par05)+".txt"
endif

if file(_carq)
	_lcontinua:=msgbox("O arquivo "+_carq+" ja existe! Sobrepor?","Atencao","YESNO")
	if _lcontinua
		ferase(_carq)
	endif
endif                                    

_hdl:=fcreate(_carq,0)
_cgc:=""    

if mv_par06==1  //  Arquivo Sacado

	processa({|| _querys()})
	procregua(tmp1->(lastrec()))
	tmp1->(dbgotop())

	while ! tmp1->(eof())
		fwrite(_hdl,tmp1->codsacado+space(7))				// CODIGO DO SACADO
		fwrite(_hdl,substr(tmp1->nome,1,40))   			    // NOME/RAZAO SOCIAL
		fwrite(_hdl,substr(tmp1->fantasia,1,40))			// NOME FANTASIA   		
		fwrite(_hdl,space(10))     							// CODIGO DO GRUPO		
		fwrite(_hdl,tmp1->pessoa)	 						// TIPO DE PESSOA  		
		_cgc:=alltrim(tmp1->cgc)
		_cgc:=replicate("0",20-len(_cgc))+_cgc		
		fwrite(_hdl,_cgc) 					   				// CPF/CGC		
		fwrite(_hdl,substr(tmp1->ender,1,40)) 				// ENDERECO        		
		fwrite(_hdl,substr(tmp1->bairro,1,15))				// BAIRRO 
		fwrite(_hdl,substr(tmp1->mun,1,15))					// CIDADE          	
		fwrite(_hdl,tmp1->uf)      							// UF		
		fwrite(_hdl,substr(tmp1->cep,1,8)) 					// CEP
		fwrite(_hdl,substr(tmp1->tel,1,20))					// FONE
		
		fwrite(_hdl,strzero(0,15)) 							// VALOR
		fwrite(_hdl,strzero(0,2))							// DIA
		fwrite(_hdl,strzero(0,10)) 							// SERIE

		fwrite(_hdl,chr(13)+chr(10))						// MUDANCA DE LINHA

		tmp1->(dbskip())
		incproc()       
		
	end

	tmp1->(dbclosearea())                                                                                           

else 				// ARQUIVO DE TÍTULOS

	processa({|| _query2()})
	procregua(tmp2->(lastrec()))
	tmp2->(dbgotop())

	while ! tmp2->(eof())
		_juros:=round((tmp2->valor*0.08)/30,2)

		fwrite(_hdl,tmp2->codsacado+space(7))				// CODIGO DO SACADO
		fwrite(_hdl,tmp2->seunum+space(5))					// SEU NUMERO - VITAPAN
		fwrite(_hdl,space(11))								// NOSSO NUMERO - CAIXA
		fwrite(_hdl,'0011')									// CODIGO CARTEIRA
		fwrite(_hdl,'S')									// ACEITE - "S"
		fwrite(_hdl,'02')									// CODIGO ESPÉCIE - "02" Dupl.Merc.
		fwrite(_hdl,'0')									// INSTRUÇÃO DE COBRANÇA - "0" Protesto
		fwrite(_hdl,'0005')									// PRAZO PROTESTO - "0005" para 5 dias
		fwrite(_hdl,'1')									// OPÇÃO DE VENCIMENTO
		fwrite(_hdl,tmp2->vencrea)							// DATA DE VENCIMENTO
		fwrite(_hdl,tmp2->emissao)							// DATA DE EMISSAO
		fwrite(_hdl,'09')									// MOEDA
		fwrite(_hdl,strzero(tmp2->valor,15))				// VALOR DO TÍTULO
//		fwrite(_hdl,strzero(tmp2->juros,15))				// VALOR DO JUROS
		fwrite(_hdl,strzero(_juros,15))			        	// VALOR DO JUROS
		fwrite(_hdl,tmp2->datadesc)							// DATA DO DESCONTO
		fwrite(_hdl,strzero(tmp2->desconto,15))				// VALOR DO DESCONTO
		fwrite(_hdl,strzero(tmp2->abatimento,15))			// VALOR DO ABATIMENTO
		fwrite(_hdl,tmp2->datamulta)						// DATA DA MULTA
		fwrite(_hdl,strzero(tmp2->multa,15))				// VALOR DA MULTA
		fwrite(_hdl,'1')									// TIPO BLOQUETO - "1" Único
		fwrite(_hdl,'S')									// COMPENSAÇÃO
		fwrite(_hdl,'000')									// FILLER
		fwrite(_hdl,space(20))								// AVALISTA
		fwrite(_hdl,space(1))								// TIPO PESSOA AVALISTA
		fwrite(_hdl,space(20))								// CPF/CNPJ AVALISTA
		fwrite(_hdl,space(40))								// MENSAGEM 1 - Recibo do Sacado
		fwrite(_hdl,space(40))								// MENSAGEM 2 - Recibo do Sacado
		fwrite(_hdl,space(40))								// MENSAGEM 3 - Recibo do Sacado
		fwrite(_hdl,space(40))								// MENSAGEM 4 - Recibo do Sacado
		fwrite(_hdl,space(40))								// MENSAGEM 5 - Ficha de Compensação
		fwrite(_hdl,space(40))								// MENSAGEM 6 - Ficha de Compensação

		fwrite(_hdl,chr(13)+chr(10))						// MUDANCA DE LINHA

		tmp2->(dbskip())
		
		incproc()
	end
	tmp2->(dbclosearea())
endif

fclose(_hdl)

return


//***********************************************************//
//                                                           //
//      INFORMAÇÕES DO SACADO - CADASTRO DE CLIENTES         //
//                                                           //
//***********************************************************//


static function _querys()

incproc("Selecionando dados do(s) sacado(s)...")

_cquery:=" SELECT"
_cquery+=" A1_COD||A1_LOJA CODSACADO,"
_cquery+=" REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(A1_NOME,'&','E'),'/',' OU '),'"+'"'+"',' '),Chr(39),''),'%',' '),'¿','') NOME,"
_cquery+=" REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(A1_NREDUZ,'&','E'),'/',' OU '),'"+'"'+"',' '),Chr(39),''),'%',' '),'¿','') FANTASIA,"
_cquery+=" '          ' CODGRUPO,"
_cquery+=" A1_PESSOA PESSOA,"
_cquery+=" A1_CGC CGC,"
_cquery+=" REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(A1_ENDCOB,'&','E'),'/',' OU '),'"+'"'+"',' '),Chr(39),''),'%',' '),'¿','') ENDER,"
_cquery+=" SubStr(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(A1_BAIRROC,'&','E'),'/',' OU '),'"+'"'+"',' '),Chr(39),''),'%',' '),'¿',''),1,15) BAIRRO,"
_cquery+=" REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(A1_MUNC,'&','E'),'/',' OU '),'"+'"'+"',' '),Chr(39),''),'%',' '),'¿','') MUN,"
_cquery+=" A1_ESTC UF,"
_cquery+=" A1_CEPC CEP,"
_cquery+=" A1_DDD||' '||A1_TEL||' ' TEL"
_cquery+=" FROM "
_cquery+=  retsqlname("SA1")+" SA1"
_cquery+=" WHERE"
_cquery+="     SA1.D_E_L_E_T_<>'*'"
_cquery+=" AND A1_FILIAL='"+_cfilsa1+"'"
_cquery+=" AND A1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par03+"'"
_cquery+=" AND A1_LOJA BETWEEN '"+mv_par02+"' AND '"+mv_par04+"'"  
_cquery+=" AND A1_MSBLQL<>'1'
_cquery+=" ORDER BY A1_COD, A1_LOJA"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
return




//******************************************************************//
//                                                                  //
//      INFORMAÇÕES DOS TITULOS  - CONFORME SELEÇÃO DE BORDERÔ      //
//                                                                  //
//******************************************************************//


static function _query2()

incproc("Selecionando titulos (conforme selecao bordero)...")

_cquery2:=" SELECT"
_cquery2+="   E1_CLIENTE||E1_LOJA CODSACADO,"
_cquery2+="   E1_PREFIXO||SubStr(E1_NUM,1,6)||E1_PARCELA SEUNUM,"
_cquery2+="   '           ' NOSSONUM,"
_cquery2+="   SubStr(E1_VENCREA,7,2)||SubStr(E1_VENCREA,5,2)||SubStr(E1_VENCREA,1,4) VENCREA,"
_cquery2+="   SubStr(E1_EMISSAO,7,2)||SubStr(E1_EMISSAO,5,2)||SubStr(E1_EMISSAO,1,4) EMISSAO,"
_cquery2+="   (E1_SALDO*100) VALOR,"  // Alterado para buscar o e1_saldo e não e1_valor 
_cquery2+="   (E1_JUROS*100) JUROS,"
_cquery2+="   SubStr(E1_VENCREA,7,2)||SubStr(E1_VENCREA,5,2)||SubStr(E1_VENCREA,1,4) DATADESC,"
_cquery2+="   (E1_DESCONT*100) DESCONTO,"
_cquery2+="   0 ABATIMENTO,"
_cquery2+="   SubStr(E1_VENCREA,7,2)||SubStr(E1_VENCREA,5,2)||SubStr(E1_VENCREA,1,4) DATAMULTA,"
_cquery2+="   (E1_MULTA*100) MULTA"
_cquery2+=" FROM "
_cquery2+=  retsqlname("SE1")+" SE1"
_cquery2+=" WHERE"
_cquery2+="     SE1.D_E_L_E_T_<>'*'"
_cquery2+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery2+=" AND E1_NUMBOR='"+mv_par05+"'"
_cquery2+=" AND E1_PORTADO='104'"
_cquery2+=" ORDER BY E1_PREFIXO||SubStr(E1_NUM,1,6)||E1_PARCELA"

_cquery2:=changequery(_cquery2)

tcquery _cquery2 new alias "TMP2"
tcsetfield("TMP2","VALOR","N",12,0)
tcsetfield("TMP2","JUROS","N",12,2)
tcsetfield("TMP2","DESCONTO","N",12,2)
tcsetfield("TMP2","ABATIMENTO","N",12,2)
tcsetfield("TMP2","MULTA","N",12,2)

return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Do cliente         ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{_cperg,"02","Da loja            ?","mv_ch2","C",02,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Ate o cliente      ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{_cperg,"04","Ate a loja         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","Do bordero         ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"06","Tipo arquivo       ?","mv_ch6","N",01,0,0,"C",space(60),"mv_par06"       ,"Sacado"         ,space(30),space(15),"Titulos"        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

for i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[i,1]+_agrpsx1[i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[i,01]
		sx1->x1_ordem  :=_agrpsx1[i,02]
		sx1->x1_pergunt:=_agrpsx1[i,03]
		sx1->x1_variavl:=_agrpsx1[i,04]
		sx1->x1_tipo   :=_agrpsx1[i,05]
		sx1->x1_tamanho:=_agrpsx1[i,06]
		sx1->x1_decimal:=_agrpsx1[i,07]
		sx1->x1_presel :=_agrpsx1[i,08]
		sx1->x1_gsc    :=_agrpsx1[i,09]
		sx1->x1_valid  :=_agrpsx1[i,10]
		sx1->x1_var01  :=_agrpsx1[i,11]
		sx1->x1_def01  :=_agrpsx1[i,12]
		sx1->x1_cnt01  :=_agrpsx1[i,13]
		sx1->x1_var02  :=_agrpsx1[i,14]
		sx1->x1_def02  :=_agrpsx1[i,15]
		sx1->x1_cnt02  :=_agrpsx1[i,16]
		sx1->x1_var03  :=_agrpsx1[i,17]
		sx1->x1_def03  :=_agrpsx1[i,18]
		sx1->x1_cnt03  :=_agrpsx1[i,19]
		sx1->x1_var04  :=_agrpsx1[i,20]
		sx1->x1_def04  :=_agrpsx1[i,21]
		sx1->x1_cnt04  :=_agrpsx1[i,22]
		sx1->x1_var05  :=_agrpsx1[i,23]
		sx1->x1_def05  :=_agrpsx1[i,24]
		sx1->x1_cnt05  :=_agrpsx1[i,25]
		sx1->x1_f3     :=_agrpsx1[i,26]
		sx1->(msunlock())
	endif
next
return

#include "rwmake.ch"       
#include "topconn.ch"

User Function VIT172()     


//SetPrvt("_CFILSA4,_CFILSD2,_CFILSF2,_CFILSA1")
SetPrvt("_CARQ,_LCONTINUA,_NHANDLE,")

Private _cperg := "PERGVIT172"

_pergsx1()

pergunte(_cPerg,.t.)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT172 ³ Autor ³ Gardenia Ilany        ³ Data ³ 20/11/03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao do Arquivo para Transmissao - Forca de Venda       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

if msgbox("Confirma geracao do(s) arquivo(s) para transmissao?","Atencao","YESNO")
	processa({|| _geraarq()})
	msginfo("Arquivo(s) gerado(s) com sucesso!")
	sysrefresh()
endif
return


Static function _geraarq()
_cfilsa3:=xfilial("SA3")
_cfilsa4:=xfilial("SA4")
_cfilsc5:=xfilial("SC5")
_cfilsf2:=xfilial("SF2")
_cfilsd2:=xfilial("SD2")
sa3->(dbsetorder(1))
sa4->(dbsetorder(1))
sc5->(dbsetorder(1))
sd2->(dbsetorder(1))
sf2->(dbsetorder(1))

_nitens:=0
_passou :=.t.  



processa({|| _querys()})
sa3->(dbgotop())
while ! sa3->(eof())
	_vend:=sa3->a3_cod
	tmp1->(dbgotop())
	while ! tmp1->(eof()) 
		if tmp1->vend1 <> _vend 
			tmp1->(dbskip())
			loop
		endif	
		sc5->(dbseek(_cfilsc5+tmp1->num))
//		if !_lpassou  
			_carq:=_vend+tmp1->pocket+strzero(val(tmp1->num),7,0)+".RET"
//			_carq2:=_vend+tmp1->pocket+strzero(val(tmp1->num),7,0)
			_nhandle:=fcreate(_carq,0)
			if _nhandle<0
				msginfo("Erro na criacao do arquivo "+_carq)
				_lcontinua:=.f.
			endif
//			_lpassou:=.t.
//      endif
		fwrite(_nhandle,tmp1->vend1)              
		fwrite(_nhandle,tmp1->pocket)              
		fwrite(_nhandle,tmp1->num)              
		fwrite(_nhandle,"PEDIDO FATURADO                                   ")             
		fwrite(_nhandle,chr(13)+chr(10))                   // MUDANCA DE LINHA
		tmp1->(dbskip())
//		if  tmp1->(eof())
			fclose(_nhandle)
//		endif	
	end           
//	_carq2:="\sigaadv"+_vend+tmp1->pocket+strzero(val(tmp1->num),7,0)+".RET"
//	frename(_carq,_carq2)
	sa3->(dbskip())
end               


processa({|| _querys2()})
sa3->(dbgotop())
while ! sa3->(eof())
	_vend:=sa3->a3_cod
	tmp2->(dbgotop())
	while ! tmp2->(eof()) 
		if tmp2->vend1 <> _vend 
			tmp2->(dbskip())
			loop
		endif	
		_lpassou:=.f. 
		sc5->(dbseek(_cfilsc5+tmp2->pedido))
		if !_lpassou  
			_carq:=_vend+sc5->c5_pocket+strzero(val(tmp2->doc),7,0)+".ITN"
//			_carq2:=_vend+tmp1->pocket+strzero(val(tmp1->doc),7,0)
			_nhandle:=fcreate(_carq,0)
			if _nhandle<0
				msginfo("Erro na criacao do arquivo "+_carq)
				_lcontinua:=.f.
			endif
			_lpassou:=.t.
      endif
		fwrite(_nhandle,"C")              
		fwrite(_nhandle,tmp2->vend1)              
		fwrite(_nhandle,tmp2->pedido)              
		fwrite(_nhandle,sc5->c5_pocket)              
		fwrite(_nhandle,tmp2->doc)             
		fwrite(_nhandle,tmp2->serie)             
		fwrite(_nhandle,chr(13)+chr(10))                   // MUDANCA DE LINHA
		_nota:=tmp2->doc
		while ! tmp2->(eof())  .and. _nota== tmp2->doc
			fwrite(_nhandle,"I")              
			fwrite(_nhandle,substr(tmp2->cod,1,6))              
			fwrite(_nhandle,strzero(round(tmp2->quant*100,0),14)) 
			fwrite(_nhandle,strzero(round(tmp2->prcven*1000000,0),18)) 
			fwrite(_nhandle,tmp2->doc)             
			fwrite(_nhandle,tmp2->serie)             
			fwrite(_nhandle,space(40))              
			fwrite(_nhandle,chr(13)+chr(10))                   // MUDANCA DE LINHA
			tmp2->(dbskip())
		end	
//		frename(_carq,_carq2+".RET")
//		if  tmp2->(eof())
			fclose(_nhandle)
//		endif	
	end
	sa3->(dbskip())
end               
return
      




static function _querys()
_cquery:=" SELECT"
_cquery+=" C5_NUM NUM,C5_CLIENTE CLIENTE,C5_LOJACLI LOJACLI,C5_VEND1 VEND1,C5_NOTA NOTA,C5_POCKET POCKET"
_cquery+=" FROM "
_cquery+=  retsqlname("SC5")+" SC5"
_cquery+=" WHERE"
_cquery+="     SC5.D_E_L_E_T_<>'*'"
_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
_cquery+=" AND C5_NOTA<>'      '"
//_cquery+=" AND C5_POCKET<>'         '"
_cquery+=" AND C5_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND C5_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
_cquery+=" AND C5_VEND1 BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY C5_VEND1,C5_NUM"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
return



static function _querys2()
_cquery:=" SELECT"
_cquery+=" F2_DOC DOC,F2_SERIE SERIE,F2_CLIENTE CLIENTE,F2_LOJA LOJA,F2_VEND1 VEND1,F2_EMISSAO EMISSAO,"
_cquery+=" F2_VALBRUT VALBRUT,F2_VOLUME1 VOLUME1,F2_TRANSP TRANSP,F2_COND COND,"
_cquery+=" D2_COD COD,D2_QUANT QUANT,D2_PEDIDO PEDIDO,D2_PRCVEN PRCVEN"
_cquery+=" FROM "
_cquery+=  retsqlname("SF2")+" SF2,"
_cquery+=  retsqlname("SD2")+" SD2"
_cquery+=" WHERE"
_cquery+="     SF2.D_E_L_E_T_<>'*'"
_cquery+=" AND SD2.D_E_L_E_T_<>'*'"
_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
_cquery+=" AND F2_DOC=D2_DOC"
_cquery+=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
_cquery+=" ORDER BY F2_VEND1,F2_DOC,D2_PEDIDO"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP2"
tcsetfield("TMP2","EMISSAO","D")
tcsetfield("TMP2","QUANT"  ,"N",14,2)
tcsetfield("TMP2","PRCVEN"  ,"N",18,6)
return





static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Do pedido          ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate o pedido       ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Da data Pedido     ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Ate a data Pedido  ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","Do vendedor        ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{_cperg,"06","Ate o vendedor     ?","mv_ch6","C",06,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{_cperg,"07","Da data nota Fatur.?","mv_ch7","D",08,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"08","Ate data nota Fat. ?","mv_ch8","D",08,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

                                        
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










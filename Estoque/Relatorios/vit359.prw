/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT359   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 25/11/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Saldo por Endereco - Excel                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"

user function vit359()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="RELATORIO DE SALDO POR ENDERECO - EXCEL
cdesc1  :="Este programa ira emitir uma planilha contendo uma lista"
cdesc2  :="de produtos por armazem, lote e endereco conforme parametros"
cdesc3  :="selecionados."
cstring :="SBF"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT359"
wnrel   :="VIT359"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.


_cperg:="PERGVIT359"
_pergsx1()
pergunte(_cperg,.f.)

wnrel:=setprint(cstring,wnrel,_cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

if nlastkey==27
	set filter to
	return
endif

rptstatus({|| rptdetail()})
return


static function rptdetail()
_cfilsbf:=xfilial("SBF")
_cfilsb1:=xfilial("SB1")

sbf->(dbsetorder(1))
sb1->(dbsetorder(1))

//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//

_aCabec := {}
_aDados := {}
_aSaldo := {}

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return
EndIf

_aCabec := {"CODIGO","DESCRICAO","LOTE","ENDERECO","LOCAL","QUANTIDADE","EMPENHO","SLD DISPONIVEL"}

processa({|| _querys()})
tmp1->(dbgotop())

While !tmp1->(Eof())         

	AAdd(_aDados, {tmp1->codigo, tmp1->descricao, tmp1->lote, tmp1->ender, tmp1->arm, cValToChar(tmp1->quant), cValToChar(tmp1->emp), cValToChar(tmp1->saldo_disp)})
	tmp1->(dbSkip())
End

DlgToExcel({ {"ARRAY", "SALDO POR ENDERECO", _aCabec, _aDados} })
tmp1->(dbclosearea())

set device to screen

ms_flush()
return

return


static function _querys()       

_cquery:="  SELECT"
_cquery+="    SBF.BF_PRODUTO CODIGO,"
_cquery+="    SB1.B1_DESC DESCRICAO, 
_cquery+="    SBF.BF_LOTECTL LOTE,"
_cquery+="    SBF.BF_LOCALIZ ENDER," 
_cquery+="    SBF.BF_LOCAL ARM,"
_cquery+="    SBF.BF_QUANT QUANT," 
_cquery+="    SBF.BF_EMPENHO EMP,"
_cquery+="    (SBF.BF_QUANT - SBF.BF_EMPENHO) SALDO_DISP"

_cquery+="  FROM "
_cquery+= retsqlname("SBF")+" SBF" 
_cquery+=" INNER JOIN "+retsqlname("SB1")+" SB1 ON (SB1.D_E_L_E_T_=' ' AND SBF.BF_PRODUTO=SB1.B1_COD AND SB1.B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"')"
_cquery+="  WHERE SBF.D_E_L_E_T_=' '"
_cquery+="  AND BF_QUANT>0"
_cquery+="  AND BF_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+="  AND BF_LOCAL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+="  AND BF_LOTECTL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+="  AND BF_LOCALIZ BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
_cquery+="  ORDER BY B1_DESC, BF_LOCAL, BF_LOTECTL, BF_LOCALIZ"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"    
tcsetfield("TMP1","QUANT","N",15,2)
tcsetfield("TMP1","EMP","N",15,2)
tcsetfield("TMP1","SALDO_DISP","N",15,2)

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Do produto              ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{_cperg,"02","Ate o produto           ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{_cperg,"03","Do tipo                 ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{_cperg,"04","Ate o tipo              ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{_cperg,"05","Do local                ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"06","Ate o local             ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"07","Do lote                 ?","mv_ch7","C",10,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"08","Ate o lote              ?","mv_ch8","C",10,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"09","Do endereco             ?","mv_ch9","C",15,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"10","Ate o endereco          ?","mv_chA","C",15,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

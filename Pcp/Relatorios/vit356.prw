/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT356   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 27/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Saldo em Processo Ordens de Producao -        ³±±
±±³          ³ Conferencia de Custos - Excel                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"

user function vit356()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="RELATORIO DE CONFERENCIA SALDO EM PROCESSO - EXCEL
cdesc1  :="Este programa ira emitir uma planilha contendo as ordens"
cdesc2  :="de producao que passaram em processo em uma determinada data e"
cdesc3  :="os seus apontamentos, requisicoes e devolucoes"
cstring :="SD3"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT356"
wnrel   :="VIT356"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.


_cperg:="PERGVIT356"
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
_cfilsd3:=xfilial("SD3")
_cfilsc2:=xfilial("SC2")

sd3->(dbsetorder(1))
sc2->(dbsetorder(1))

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

_aCabec := {"Codigo","OP","Emissao","Dt Fechamento","CF","Tipo","Quant","Custo"}

processa({|| _querys()})
tmp1->(dbgotop())

While !tmp1->(Eof())         

	AAdd(_aDados, {tmp1->cod, tmp1->op, tmp1->emis, tmp1->dt_enc, tmp1->cf, tmp1->tipo, tmp1->quant, tmp1->custo})

	tmp1->(dbSkip())
End

DlgToExcel({ {"ARRAY", "OP's em processo em "+dtoc(mv_par02), _aCabec, _aDados} })
tmp1->(dbclosearea())

set device to screen

ms_flush()
return

return


static function _querys()       

_cquery:="  SELECT"
_cquery+="    D3_COD COD,"
_cquery+="    D3_OP OP,"
_cquery+="    D3_EMISSAO EMIS,"
_cquery+="    C2_DATRF DT_ENC,"
_cquery+="    SubStr(D3_CF,1,2) CF,"
_cquery+="    D3_TIPO TIPO,"
_cquery+="    Sum(D3_QUANT) QUANT,"
_cquery+="    Sum(D3_CUSTO1) CUSTO"
_cquery+="  FROM "
_cquery+= retsqlname("SD3")+" SD3," 
_cquery+= retsqlname("SC2")+" SC2"
_cquery+="  WHERE SD3.D_E_L_E_T_=' ' AND SC2.D_E_L_E_T_=' '"
_cquery+="  AND D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+="  AND D3_OP<>' '"
_cquery+="  AND D3_ESTORNO<>'S'"
_cquery+="  AND D3_OP=C2_NUM||C2_ITEM||C2_SEQUEN||C2_IDENT"
_cquery+="  AND (C2_DATRF >'"+dtos(mv_par02)+"' OR C2_DATRF =' ')"
_cquery+="  GROUP BY D3_OP,D3_EMISSAO,C2_DATRF,D3_COD,D3_TIPO,SubStr(D3_CF,1,2)"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"    
tcsetfield("TMP1","EMIS","D")
tcsetfield("TMP1","DT_ENC","D")
tcsetfield("TMP1","QUANT","N",15,2)
tcsetfield("TMP1","CUSTO","N",15,5)

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Movimentos a partir de  ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Data de Referencia      ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

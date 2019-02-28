/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT352   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 14/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Quadro de Pessoal                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"

user function vit352()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="RELATORIO DE QUADRO DE PESSOAL"
cdesc1  :="Este programa ira emitir a relacao de colaboradores que"
cdesc2  :="formavam o quadro de pessoal em uma data de fechamento informada"
cdesc3  :=""
cstring :="SRA"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT352"
wnrel   :="VIT352"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.


_cperg:="PERGVIT352"
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
_cfilsra:=xfilial("SRA")
_cfilsre:=xfilial("SRE")
_cfilsr7:=xfilial("SR7")
_cfilsrj:=xfilial("SRJ")

sra->(dbsetorder(1))
sre->(dbsetorder(1))
sr7->(dbsetorder(1))
srj->(dbsetorder(1))

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

_aCabec := {"Matricula","Nome","CC Periodo","CC Atual","Func Periodo","Descricao Funcao Periodo","Funcao Atual","Descricao Funcao Atual","Admissao","Demissao"}

processa({|| _querys()})
tmp1->(dbgotop())

While !tmp1->(Eof())         

	AAdd(_aDados, {tmp1->mat, tmp1->nome, tmp1->cc_per, tmp1->cc_atual, tmp1->funcao_per, tmp1->desc_per_per, tmp1->func_atual, tmp1->desc_func_atual, tmp1->admissao, tmp1->demissao})

	tmp1->(dbSkip())
End

DlgToExcel({ {"ARRAY", "Quadro de Funcionarios em "+dtoc(mv_par01), _aCabec, _aDados} })
tmp1->(dbclosearea())

set device to screen

ms_flush()
return

return


static function _querys()       


_cquery:="  SELECT MAT, NOME, CC_PER, CC_ATUAL, FUNCAO_PER, SRJ2.RJ_DESC DESC_PER_PER, FUNC_ATUAL, DESC_FUNC_ATUAL, ADMISSAO, DEMISSAO"
_cquery+="  FROM ("
_cquery+="  SELECT"
_cquery+="    MAT,"
_cquery+="    NOME,"
_cquery+="    CASE"
_cquery+="      WHEN CC_PERIODO IS NULL THEN CC_ATUAL"
_cquery+="      ELSE CC_PERIODO"
_cquery+="    END CC_PER,"
_cquery+="    CC_ATUAL,"
_cquery+="    CASE"
_cquery+="      WHEN FUNC_PER IS NULL THEN FUNC_ATUAL"
_cquery+="      ELSE FUNC_PER"
_cquery+="    END FUNCAO_PER,"
_cquery+="    FUNC_ATUAL,"
_cquery+="    DESC_FUNC_ATUAL,"
_cquery+="    ADMISSAO,"
_cquery+="    DEMISSAO"
_cquery+="  FROM"
_cquery+="  (SELECT"
_cquery+="    SRA.RA_MAT MAT,"
_cquery+="    SRA.RA_NOME NOME,"
_cquery+="    SubStr((SELECT Max(SRE.RE_DATA||SRE.RE_CCP) FROM "+retsqlname("SRE")+" SRE"+" WHERE SRE.D_E_L_E_T_=' ' AND SRE.RE_MATP=SRA.RA_MAT AND SRE.RE_DATA<'"+dtos(mv_par01)+"'),9,10) CC_PERIODO,"
_cquery+="    SRA.RA_CC CC_ATUAL,"
_cquery+="    SUBSTR((SELECT Max(SR7.R7_DATA||SR7.R7_FUNCAO) FROM "+retsqlname("SR7")+" SR7"+" WHERE SR7.D_E_L_E_T_=' ' AND SR7.R7_MAT=SRA.RA_MAT AND SR7.R7_DATA<'"+dtos(mv_par01)+"' AND SR7.R7_TIPO IN ('001','004') ),9,4) FUNC_PER,"
_cquery+="    SRA.RA_CODFUNC FUNC_ATUAL,"
_cquery+="    SRJ.RJ_DESC DESC_FUNC_ATUAL,"
_cquery+="    SRA.RA_ADMISSA ADMISSAO,"
_cquery+="    SRA.RA_DEMISSA DEMISSAO"
_cquery+="  FROM "
_cquery+= retsqlname("SRA")+" SRA,"
_cquery+= retsqlname("SRJ")+" SRJ"
_cquery+="  WHERE SRA.D_E_L_E_T_=' ' AND SRJ.D_E_L_E_T_=' '"
_cquery+="  AND SRA.RA_ADMISSA<='"+dtos(mv_par01)+"'"
_cquery+="  AND (SRA.RA_SITFOLH<>'D' OR SRA.RA_DEMISSA>'"+dtos(mv_par01)+"')"
_cquery+="  AND SRA.RA_CODFUNC=SRJ.RJ_FUNCAO"
_cquery+="  ORDER BY SRA.RA_NOME)"
_cquery+="  ), "+ retsqlname("SRJ")+" SRJ2"
_cquery+="  WHERE SRJ2.D_E_L_E_T_=' '"
_cquery+="  AND FUNCAO_PER=SRJ2.RJ_FUNCAO"
_cquery+="  ORDER BY NOME"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"    
tcsetfield("TMP1","ADMISSAO","D")
tcsetfield("TMP1","DEMISSAO","D")

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Da Data Fechamento      ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

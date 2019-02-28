/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT440   ³ Autor ³ Guilherme Teodoro     ³ Data ³ 24/06/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Notas Fiscais Entrada de Insumos (MP) e Embalagens (EE/EN) ³±±
±±³          ³ por Periodo e Fornecedor - Para Qualificacao de Fornecedores³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit440()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="ENTRADAS MATERIAIS POR FORNECEDOR"
cdesc1  :="Este programa ira emitir uma lista de NFs lancadas por Periodo e Fornecedores"
cdesc2  :=""
cdesc3  :=""
cstring :="SF1"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT440"
wnrel   :="VIT440"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=220
cbtxt    :=space(10)

cperg:="PERGVIT440"
_pergsx1()
pergunte(cperg,.f.)


wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)

if nlastkey==27
	set filter to
	return
endif

rptstatus({|| rptdetail()})
return

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
_cfilsd1:=xfilial("SD1")
_cfilsa2:=xfilial("SA2")
_cfilsb1:=xfilial("SB1")
_cfilsf4:=xfilial("SF4")

sd1->(dbsetorder(6))
sa2->(dbsetorder(1))
sb1->(dbsetorder(1))
sf4->(dbsetorder(1))


processa({|| _querys()})

cabec1:="PERIODO DE "+dtoc(mv_par07)+" A "+dtoc(mv_par08)
cabec2:="CODIGO  PRODUTO                                       CGC/CNPJ      FORNECEDOR                               LT.FORNECEDOR      N.F.    ENTRADA  LT.VITAMEDIC FABRICANTE                       LT.FABRIC."

setprc(0,0)
@ 000,000 PSAY avalimp(220)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif
	
	@ prow()+1,000 PSAY substr(tmp1->cod,1,6)
	@ prow(),008   PSAY tmp1->descr
	//@ prow(),050   PSAY tmp1->quant picture "@E 999,999,999.99"
	@ prow(),050   PSAY tmp1->cgc 
	//@ prow(),066   PSAY tmp1->um
	@ prow(),070   PSAY tmp1->fornece
	@ prow(),111   PSAY tmp1->lotefor
	@ prow(),130   PSAY tmp1->doc
	@ prow(),138   PSAY dtoc(tmp1->dtdigit)
	@ prow(),148   PSAY tmp1->lote
	@ prow(),160   PSAY tmp1->fabric
	@ prow(),193   PSAY tmp1->lotfabr

	tmp1->(dbskip())

	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if prow()>0 .and. lcontinua
	roda(cbcont,cbtxt)
endif

tmp1->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

static function _querys()

_cquery:=" SELECT"
_cquery+=" D1_COD COD,"
_cquery+=" B1_DESC DESCR,"
_cquery+=" A2_CGC CGC,"
//_cquery+=" D1_UM UM,"
_cquery+=" A2_NOME FORNECE,"
_cquery+=" D1_LOTEFOR LOTEFOR,"
_cquery+=" D1_DOC DOC,"
_cquery+=" D1_DTDIGIT DTDIGIT,"
_cquery+=" D1_LOTECTL LOTE,"
_cquery+=" D1_FABRIC FABRIC,"
_cquery+=" D1_LOTFABR LOTFABR"

_cquery+=" FROM "
_cquery+=  retsqlname("SD1")+" SD1,"
_cquery+=  retsqlname("SA2")+" SA2,"
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SF4")+" SF4"
_cquery+=" WHERE"
_cquery+="     SD1.D_E_L_E_T_=' '"
_cquery+=" AND SA2.D_E_L_E_T_=' '"
_cquery+=" AND SB1.D_E_L_E_T_=' '"
_cquery+=" AND SF4.D_E_L_E_T_=' '"
_cquery+=" AND D1_FILIAL='"+_cfilsd1+"'"
_cquery+=" AND A2_FILIAL='"+_cfilsa2+"'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"

_cquery+=" AND D1_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND D1_DTDIGIT BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
_cquery+=" AND D1_QUANT>0"
_cquery+=" AND D1_FORNECE=A2_COD"
_cquery+=" AND A2_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND D1_LOJA=A2_LOJA"
_cquery+=" AND A2_LOJA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND D1_COD=B1_COD"
_cquery+=" AND B1_COD BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par13+"' AND '"+mv_par14+"'"
_cquery+=" AND D1_TES=F4_CODIGO"
_cquery+=" AND F4_ESTOQUE='S'"
_cquery+=" AND F4_CF NOT IN ('1124','2124','1202','1910','2910','1911','2911','1949','2949')"
_cquery+=" AND F4_ESTOQUE='S'"

_cquery+=" ORDER BY B1_DESC,A2_NOME,D1_EMISSAO"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","CGC","C")
tcsetfield("TMP1","DTDIGIT","D")

return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da nota fiscal   	   ?","mv_ch1","C",09,0,0,"C",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a nota fiscal       ?","mv_ch2","C",09,0,0,"C",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do fornecedor           ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"04","Ate o fornecedor        ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"05","Da loja                 ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"06","Ate a loja              ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"07","Da data digitacao       ?","mv_ch7","D",08,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate a data digitacao    ?","mv_ch8","D",08,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do produto              ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"10","Ate o produto           ?","mv_cha","C",06,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"11","Do tipo                 ?","mv_chb","C",02,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"12","Ate o tipo              ?","mv_chc","C",02,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"13","Do grupo                ?","mv_chd","C",04,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"14","Ate o grupo             ?","mv_che","C",04,0,0,"G",space(60),"mv_par14"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})

for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,04]
		sx1->x1_tipo   :=_agrpsx1[_i,05]
		sx1->x1_tamanho:=_agrpsx1[_i,06]
		sx1->x1_decimal:=_agrpsx1[_i,07]
		sx1->x1_presel :=_agrpsx1[_i,08]
		sx1->x1_gsc    :=_agrpsx1[_i,09]
		sx1->x1_valid  :=_agrpsx1[_i,10]
		sx1->x1_var01  :=_agrpsx1[_i,11]
		sx1->x1_def01  :=_agrpsx1[_i,12]
		sx1->x1_cnt01  :=_agrpsx1[_i,13]
		sx1->x1_var02  :=_agrpsx1[_i,14]
		sx1->x1_def02  :=_agrpsx1[_i,15]
		sx1->x1_cnt02  :=_agrpsx1[_i,16]
		sx1->x1_var03  :=_agrpsx1[_i,17]
		sx1->x1_def03  :=_agrpsx1[_i,18]
		sx1->x1_cnt03  :=_agrpsx1[_i,19]
		sx1->x1_var04  :=_agrpsx1[_i,20]
		sx1->x1_def04  :=_agrpsx1[_i,21]
		sx1->x1_cnt04  :=_agrpsx1[_i,22]
		sx1->x1_var05  :=_agrpsx1[_i,23]
		sx1->x1_def05  :=_agrpsx1[_i,24]
		sx1->x1_cnt05  :=_agrpsx1[_i,25]
		sx1->x1_f3     :=_agrpsx1[_i,26]
		sx1->(msunlock())
	endif
next
return



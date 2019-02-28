/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT317   ³ Autor ³ Alex Junio de Miranda ³ Data ³ 19/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao das Etiquetas de Liberacao/Reprovacao da Quaren- ³±±
±±³          ³ tena para Materiais/Materias-Primas por Lote               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function VIT317()
nordem   :=""
tamanho  :="P"
limite   :=080
titulo   :="ETIQUETA APROVACAO/REJEICAO MATERIAIS/MATERIA-PRIMA"
cdesc1   :="Este programa ira emitir as etiquetas de aprovacao/rejeicao de materiais"
cdesc2   :="e/ou materias-primas analisados pelo CQ por lote."
cdesc3   :=""
cstring  :="SD1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT317"
wnrel    :="VIT317"
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT317"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.t.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)

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
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:=""
cabec2:=""

_cfilsb1:=xfilial("SB1")
_cfilsd1:=xfilial("SD1")
_cfilsd7:=xfilial("SD7")
sb1->(dbsetorder(1))
sd1->(dbsetorder(6))
sd7->(dbsetorder(4))


processa({|| _querys()})

setprc(0,0)
@ 000,000    PSAY chr(18)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())

@ prow(),000    PSAY chr(18)

for _i:=1 to tmp1->numvol
	incregua()

	@ prow(),009    PSAY substr(tmp1->produto,1,6)+"-"+tmp1->descr
	@ prow()+4,007  PSAY dtoc(tmp1->datamov)
	@ prow(),029    PSAY tmp1->lotectl 

	@ prow()+2,000  PSAY " "  	

	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
next

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
_cquery+="   D1_COD PRODUTO,"
_cquery+="   B1_DESC DESCR,"
_cquery+="   D1_LOTECTL LOTECTL,"
_cquery+="   D1_NUMVOL NUMVOL,"
_cquery+="   (SELECT DISTINCT(SD7.D7_DATA)"
_cquery+="   	FROM "+retsqlname("SD7")+" SD7" 
_cquery+="   	WHERE SD7.D_E_L_E_T_=' '"
_cquery+="     AND SD7.D_E_L_E_T_=' '"
_cquery+="     AND SD7.D7_FILIAL='"+_cfilsd7+"'"
_cquery+="     AND SD7.D7_PRODUTO=SD1.D1_COD"
_cquery+="     AND SD7.D7_LOTECTL=SD1.D1_LOTECTL"
_cquery+="     AND SD7.D7_NUMERO=SD1.D1_NUMCQ"

if mv_par05==1 //Imprime Etiquetas de Aprovados
	_cquery+="     AND SD7.D7_TIPO='1') DATAMOV"
else
	_cquery+="     AND SD7.D7_TIPO='2') DATAMOV"
endif

_cquery+=" FROM "
_cquery+=  retsqlname("SD1")+" SD1,"
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE SD1.D_E_L_E_T_<>'*'"
_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND D1_FILIAL = '"+_cfilsd1+"'"
_cquery+=" AND B1_FILIAL = '"+_cfilsb1+"'"
_cquery+=" AND D1_COD = '"+mv_par01+"'"
_cquery+=" AND D1_LOTECTL = '"+mv_par02+"'"
_cquery+=" AND D1_DOC = '"+mv_par03+"'"
_cquery+=" AND D1_SERIE = '"+mv_par04+"'"
_cquery+=" AND D1_COD = B1_COD"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","NUMVOL","N",5,0)
tcsetfield("TMP1","DATAMOV","D")


return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Produto            ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Lote               ?","mv_ch2","C",10,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Nota Fiscal        ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Serie              ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Imprimir           ?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,"Aprovados"      ,space(30),space(15),"Reprovados"     ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

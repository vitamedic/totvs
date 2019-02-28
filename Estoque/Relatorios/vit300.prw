/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT300   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 19/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Lista de Movimentações de Transferência SD3 - Movmtos. Int.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit300()
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="MOVIMENTACOES INTERNAS DE TRANSFERENCIAS"
cdesc1  :="Este programa ira emitir uma lista de itens movimentados por transferencia"
cdesc2  :="pelas rotinas de Movimentos Internos - SD3"
cdesc3  :=""
cstring :="SD3"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT300"
wnrel   :="VIT300"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)

cperg:="PERGVIT300"
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
_cfilsd3:=xfilial("SD3")
_cfilsb1:=xfilial("SB1")

sd3->(dbsetorder(6))
sb1->(dbsetorder(1))

processa({|| _querys()})

cabec1:="PERIODO DE "+dtoc(mv_par07)+" A "+dtoc(mv_par08)
cabec2:="CODIGO   PRODUTO                            QUANTIDADE  UM ARM DOC       TM  EMISSAO   USUARIO          LOTE        ENDER.   ESTORNO"
setprc(0,0)
@ 000,000 PSAY avalimp(132)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif
//999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99,999,999.99  XX  99 999999999 999 99/99/99  XXXXXXXXXXXXXXX  XXXXXXXXXX  XXXXXXXXXX     X
	
	@ prow()+1,000 PSAY substr(tmp1->cod,1,6)
	@ prow(),009   PSAY substr(tmp1->descr,1,30)
	@ prow(),041   PSAY tmp1->quant picture "@E 99,999,999.99"
	@ prow(),056   PSAY tmp1->um
	@ prow(),060   PSAY tmp1->armazem
	@ prow(),063   PSAY tmp1->doc
	@ prow(),073   PSAY tmp1->tm 
	@ prow(),077   PSAY dtoc(tmp1->emissao)
	@ prow(),087   PSAY tmp1->usuario
	@ prow(),104   PSAY tmp1->lotectl
	@ prow(),116   PSAY tmp1->localiz
	@ prow(),131   PSAY tmp1->estorno

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
_cquery+=" D3_COD COD,"
_cquery+=" B1_DESC DESCR,"
_cquery+=" D3_QUANT QUANT,"
_cquery+=" D3_UM UM,"
_cquery+=" D3_LOCAL ARMAZEM,"
_cquery+=" D3_DOC DOC,"
_cquery+=" D3_TM TM,"
_cquery+=" D3_EMISSAO EMISSAO,"
_cquery+=" D3_USUARIO USUARIO,"
_cquery+=" D3_LOTECTL LOTECTL,"
_cquery+=" D3_LOCALIZ LOCALIZ,"
_cquery+=" D3_ESTORNO ESTORNO"

_cquery+=" FROM "
_cquery+=  retsqlname("SD3")+" SD3,"
_cquery+=  retsqlname("SB1")+" SB1"

_cquery+=" WHERE"
_cquery+="     SD3.D_E_L_E_T_=' '"
_cquery+=" AND SB1.D_E_L_E_T_=' '"
_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND D3_COD=B1_COD"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND D3_LOCAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND D3_CF IN ('RE4','DE4')"
_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"

if !empty(mv_par09) // Se considera ou não usuário no filtro
	_cquery+=" AND D3_USUARIO='"+ltrim(mv_par09)+"'"
endif

_cquery+=" ORDER BY D3_EMISSAO, D3_DOC, D3_TM DESC"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","QUANT","N",15,2)
tcsetfield("TMP1","EMISSAO","D")

return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto       	      ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto           ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do local                ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate o local             ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do tipo                 ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Ate o tipo              ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"07","Da data                 ?","mv_ch7","D",08,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate a data              ?","mv_ch8","D",08,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do usuario              ?","mv_ch9","C",15,0,0,"G",space(60),"mv_par09"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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



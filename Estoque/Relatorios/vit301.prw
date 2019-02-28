/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT301   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 18/02/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relação de Estoque / Endereço / Lote (SBF)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function vit301()
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="ESTOQUE POR ENDERECO POR LOTE"
cdesc1  :="Este programa ira emitir uma lista de produtos por endereco e por lote"
cdesc2  :=""
cdesc3  :=""
cstring :="SBF"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT301"
wnrel   :="VIT301"+Alltrim(cusername)
alinha  :={}
aordem  :={"Endereço","Codigo Produto","Alfabetica"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)

cperg:="PERGVIT301"
_pergsx1()
pergunte(cperg,.f.)


wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

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

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
_cfilsbf:=xfilial("SBF")
_cfilsb1:=xfilial("SB1")

sbf->(dbsetorder(2))
sb1->(dbsetorder(1))

processa({|| _querys()})

cabec1:="ENDERECO    CODIGO   DESCRICAO                                  LOCAL  LOTE                  SALDO         EMPENHO       DISPONIVEL"
cabec2:=""
//ENDERECO    CODIGO   DESCRICAO                                  LOCAL  LOTE                  SALDO         EMPENHO       DISPONIVEL"
//999999      999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99     XXXXXXXXXX   999.999.999,99  999.999.999,99   999.999.999,99"

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())

setprc(0,0)
@ 000,000 PSAY avalimp(132)

while ! tmp1->(eof()) .and.;
	lcontinua

	incregua()
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif
	
	@ prow()+1,000 PSAY substr(tmp1->localiz,1,6)
	@ prow(),012   PSAY substr(tmp1->produto,1,6)
	@ prow(),021   PSAY tmp1->descr
	@ prow(),064   PSAY tmp1->local
	@ prow(),071   PSAY tmp1->lotectl
	@ prow(),084   PSAY tmp1->quant      picture "@E 999,999,999.99"
	@ prow(),100   PSAY tmp1->empenho    picture "@E 999,999,999.99"
	@ prow(),117   PSAY tmp1->saldo_disp picture "@E 999,999,999.99"

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
	set printer to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

static function _querys()

_cquery:=" SELECT"
_cquery+=" BF_LOCALIZ LOCALIZ," 
_cquery+=" BF_PRODUTO PRODUTO,"
_cquery+=" B1_DESC DESCR,"
_cquery+=" BF_LOCAL LOCAL," 
_cquery+=" BF_LOTECTL LOTECTL," 
_cquery+=" BF_QUANT QUANT,"
_cquery+=" BF_EMPENHO EMPENHO," 
_cquery+=" (BF_QUANT-BF_EMPENHO) SALDO_DISP"

_cquery+=" FROM "
_cquery+=  retsqlname("SBF")+" SBF,"
_cquery+=  retsqlname("SB1")+" SB1"

_cquery+=" WHERE"
_cquery+="     SBF.D_E_L_E_T_=' '"
_cquery+=" AND SB1.D_E_L_E_T_=' '"
_cquery+=" AND BF_FILIAL='"+_cfilsbf+"'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND BF_QUANT>0"
_cquery+=" AND BF_PRODUTO=B1_COD"
_cquery+=" AND BF_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND BF_LOCAL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND BF_LOTECTL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND BF_LOCALIZ BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"

if nordem==1     // ENDERECO
	_cquery+=" ORDER BY BF_LOCALIZ, B1_DESC, BF_PRODUTO,BF_LOTECTL"
elseif nordem==2 // CODIGO DO PRODUTO
	_cquery+=" ORDER BY BF_PRODUTO,BF_LOTECTL, BF_LOCALIZ"
else             // DESCRICAO PRODUTO
	_cquery+=" ORDER BY B1_DESC, BF_LOTECTL, BF_LOCALIZ"
endif

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","QUANT"     ,"N",15,2)
tcsetfield("TMP1","EMPENHO"   ,"N",15,2)
tcsetfield("TMP1","SALDO_DISP","N",15,2)

return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto       	      ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto           ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo                 ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo              ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do local                ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate o local             ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do lote                 ?","mv_ch7","C",10,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o lote              ?","mv_ch8","C",10,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do endereco             ?","mv_ch9","C",15,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate o endereco          ?","mv_chA","C",15,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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



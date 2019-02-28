/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT255   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 05/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relação de Itens baixados do Ativo Fixo/Imobilizado com    ³±±
++³          ³ Nº de NFE                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit255()
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="ITENS BAIXADOS"
cdesc1  :="Este programa ira emitir a Lista de itens baixados do ativo"
cdesc2  :=""
cdesc3  :=""
cstring :="SN1"
areturn :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog:="VIT255"
wnrel   :="VIT255"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)

cperg:="PERGVIT255"
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
_cfilsn1:=xfilial("SN1")
_cfilsn3:=xfilial("SN3")
sn1->(dbsetorder(1))
sn3->(dbsetorder(1))


processa({|| _querys()})

cabec1:="PERIODO DE "+dtoc(mv_par09)+" A "+dtoc(mv_par10)
cabec2:="Conta          C.C.      Base       Item  Descricao                   Aquisic.  Dt.Baixa  NF/Serie          Valor      ICMS  CIAP"

setprc(0,0)
@ 000,000 PSAY avalimp(133)

setregua(tmp1->(lastrec()))

_valtotitem:=0
_valtot:=0
_qtitem:=0

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif
	
	@ prow()+1,000 PSAY substr(tmp1->conta,1,13)
	@ prow(),015   PSAY tmp1->ccusto
	@ prow(),025   PSAY tmp1->cbase
	@ prow(),036   PSAY tmp1->item
	@ prow(),042   PSAY substr(tmp1->descri,1,26)
	@ prow(),070   PSAY dtoc(tmp1->aquisic)
	@ prow(),080   PSAY dtoc(tmp1->baixa)
	@ prow(),090   PSAY tmp1->nfiscal
	@ prow(),096   PSAY "-"+tmp1->serie	
	@ prow(),101   PSAY tmp1->valor picture "@E 9,999,999.99"
	@ prow(),115   PSAY tmp1->icmsapr picture "@E 9,999.99"	
	@ prow(),125   PSAY tmp1->ciap
   _valtot+= tmp1->icmsapr 
   _valtotitem+= tmp1->valor
   _qtitem++

	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if prow()>60
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
endif
	
@ prow()+2,020 PSAY "Qtde. Itens: "
@ prow(),034 PSAY _qtitem
@ prow(),050 PSAY "Valor Total ICMS: "
@ prow(),068 PSAY _valtot picture "@E 999,999,999.99"
@ prow(),098 PSAY "Valor Total Itens: "
@ prow(),117 PSAY _valtotitem picture "@E 999,999,999.99"


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
_cquery+=" N1_CBASE CBASE,"
_cquery+=" N1_ITEM ITEM,"
_cquery+=" N1_DESCRIC DESCRI,"
_cquery+=" N1_AQUISIC AQUISIC,"
_cquery+=" N1_BAIXA BAIXA,
_cquery+=" N1_NFISCAL NFISCAL,"
_cquery+=" N1_NSERIE SERIE,"
_cquery+=" N1_ICMSAPR ICMSAPR,"
_cquery+=" N1_CODCIAP CIAP,"
_cquery+=" N3_CCONTAB CONTA,"
_cquery+=" N3_CUSTBEM CCUSTO,"
_cquery+=" N3_VORIG1 VALOR"
_cquery+=" FROM "
_cquery+=  retsqlname("SN1")+" SN1,"
_cquery+=  retsqlname("SN3")+" SN3"
_cquery+=" WHERE"                   
_cquery+="     SN1.D_E_L_E_T_<>'*'"
_cquery+=" AND SN3.D_E_L_E_T_<>'*'"
_cquery+=" AND N1_FILIAL='"+_cfilsn1+"'"
_cquery+=" AND N3_FILIAL='"+_cfilsn3+"'"
_cquery+=" AND N1_BAIXA BETWEEN '"+dtos(mv_par09)+"' AND '"+dtos(mv_par10)+"'"
_cquery+=" AND N1_CBASE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND N1_ITEM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND N1_CBASE=N3_CBASE"
_cquery+=" AND N1_ITEM=N3_ITEM"
_cquery+=" AND N3_CCONTAB BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND N3_CUSTBEM BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND N3_BAIXA='1'"

_cquery+=" ORDER BY N1_AQUISIC, N1_BAIXA, N1_CBASE, N1_ITEM"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","AQUISIC","D")
tcsetfield("TMP1","BAIXA","D")
tcsetfield("TMP1","VALOR","N",12,2)
tcsetfield("TMP1","ICMSAPR","N",12,2)
return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","De Cod. Bem        ?","mv_ch1","C",10,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SN1"})
aadd(_agrpsx1,{cperg,"02","Ate o Cod. Bem     ?","mv_ch2","C",10,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SN1"})
aadd(_agrpsx1,{cperg,"03","Do Item            ?","mv_ch3","C",04,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate o Item         ?","mv_ch4","C",04,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da Conta           ?","mv_ch5","C",20,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CT1"})
aadd(_agrpsx1,{cperg,"06","Ate Conta          ?","mv_ch6","C",20,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CT1"})
aadd(_agrpsx1,{cperg,"07","Do Centro de Custo ?","mv_ch7","C",09,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{cperg,"08","Ate Centro de Custo?","mv_ch8","C",09,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{cperg,"09","Da data            ?","mv_ch9","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate a data         ?","mv_cha","D",08,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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


/*
LAYOUT DO RELATÓRIO

Conta          C.C.      Base       Item  Descricao                   Aquisic.  Dt.Baixa  NF/Serie          Valor      ICMS CIAP  "
9999999999999  99999999  9999999999 9999  XXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99  99/99/99  999999-99  9.999.999,99  9.999,99 999999
*/

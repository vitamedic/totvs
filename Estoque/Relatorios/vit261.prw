/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT261   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 09/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Lista de Produtos Bloqueados / Liberados por período       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit261()
nordem  :=""
tamanho :="M"
limite  :=220
titulo  :="LISTA DE PROD.BLOQUEADOS/LIBERADOS"
cdesc1  :="Este programa ira emitir Lista de Produtos Bloqueados/Liberados por"
cdesc2  :="produtos, lotes e/ou periodo"
cdesc3  :=""
cstring :="SDD"
areturn :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog:="VIT261"
wnrel   :="VIT261"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)

cperg:="PERGVIT261"
_pergsx1()
pergunte(cperg,.f.)


wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

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
_cfilsdd:=xfilial("SDD")
_cfilsb1:=xfilial("SB1")
_cfilsx5:=xfilial("SX5")
sdd->(dbsetorder(2))
sb1->(dbsetorder(1))
sx5->(dbsetorder(1))

processa({|| _querys()})

if mv_par09==1
	cabec1:="Produtos Bloqueados em: "+dtoc(mv_par07)+" a "+dtoc(mv_par08)
elseif mv_par09==2                                                         
	cabec1:="Produtos Liberados em: "+dtoc(mv_par07)+" a "+dtoc(mv_par08)
else
	cabec1:="Liberações/Bloqueios em: "+dtoc(mv_par07)+" a "+dtoc(mv_par08)
endif 

if mv_par09==1 
  cabec2:="PRODUTO  DESCRICAO                       ARM  LOTE        QTDE. BLOQUEADA  MOTIVO           Nº DOC  DT. BLOQUEIO/USUARIO"
elseif mv_par09==2
  cabec2:="PRODUTO  DESCRICAO                       ARM  LOTE        QTDE. LIBERADA   MOTIVO           Nº DOC  DT.BLOQUEIO/USUARIO  DT.LIBER./USUARIO"
else
  cabec2:="PRODUTO  DESCRICAO                       ARM  LOTE        QTDE.BLOQ./LIB.  MOTIVO           Nº DOC  DT.BLOQUEIO/USUARIO  DT.LIBER./USUARIO"
endif

setprc(0,0)
@ 000,000 PSAY avalimp(133)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
   if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif

	@ prow()+1,000 PSAY SUBSTR(tmp1->produto,1,6)
	@ prow(),009   PSAY SUBSTR(tmp1->descr,1,30)
	@ prow(),041   PSAY tmp1->local
	@ prow(),046   PSAY tmp1->lote

	if mv_par09==1
		@ prow(),058   PSAY tmp1->quant picture "@E 999,999,999.999"  //quantidade Bloqueada
	else
		@ prow(),058   PSAY tmp1->qtdorig picture "@E 999,999,999.999"  //quantidade Liberada
	endif
		
	sx5->(dbseek(_cfilsx5+"E1"+tmp1->motivo))
	@ prow(),075   PSAY SUBSTR(sx5->x5_descri,1,15)
	@ prow(),091   PSAY tmp1->doc

	if mv_par09==1
	  	@ prow(),099   PSAY dtoc(tmp1->dtbloq)
	  	@ prow(),108   PSAY SUBSTR(embaralha(tmp1->userlgi,1),1,10)
	else
	  	@ prow(),099   PSAY dtoc(tmp1->dtbloq)
		@ prow(),108   PSAY SUBSTR(embaralha(tmp1->userlgi,1),1,10)
		@ prow(),120   PSAY dtoc(tmp1->dtlib)
		@ prow(),129   PSAY SUBSTR(embaralha(tmp1->userlga,1),1,10)
	endif

	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif

	tmp1->(dbskip())
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
_cquery+=" DD_PRODUTO PRODUTO,"
_cquery+=" B1_DESC DESCR,"
_cquery+=" DD_LOCAL LOCAL,"                  
_cquery+=" DD_LOTECTL LOTE,"
_cquery+=" DD_QUANT QUANT,"
_cquery+=" DD_QTDORIG QTDORIG,"
_cquery+=" DD_MOTIVO MOTIVO,"
_cquery+=" DD_DOC DOC,"
_cquery+=" DD_DTBLOQ DTBLOQ,"
_cquery+=" DD_DTLIB DTLIB,"
_cquery+=" DD_USERLGI USERLGI,"
_cquery+=" DD_USERLGA USERLGA"

_cquery+=" FROM "
_cquery+=  retsqlname("SDD")+" SDD,"
_cquery+=  retsqlname("SB1")+" SB1"

_cquery+=" WHERE"                   
_cquery+="     SDD.D_E_L_E_T_<>'*'"
_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND DD_FILIAL='"+_cfilsdd+"'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND DD_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND DD_LOCAL BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND DD_LOTECTL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND DD_PRODUTO=B1_COD"

if mv_par09==1 //BLOQUEADOS
	_cquery+=" AND DD_QUANT>0"
	_cquery+=" AND DD_DTBLOQ BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"	
elseif mv_par09==2 //LIBERADOS
	_cquery+=" AND DD_QUANT=0"
	_cquery+=" AND DD_DTLIB BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"	
else //AMBOS
	_cquery+=" AND DD_DTBLOQ>='"+dtos(mv_par07)+"'"
	_cquery+=" AND (DD_DTLIB<='"+dtos(mv_par08)+"' OR DD_DTLIB='        ')"
endif

_cquery+=" ORDER BY 1,3,4,5"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"    
tcsetfield("TMP1","DTBLOQ","D")
tcsetfield("TMP1","DTLIB","D")
tcsetfield("TMP1","QUANT","N",12,3)
tcsetfield("TMP1","QTDORIG","N",12,3)

return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Produto         ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o Produto      ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do Armazem         ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate o Armazem      ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do Lote            ?","mv_ch5","C",10,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate o Lote         ?","mv_ch6","C",10,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Da Data            ?","mv_ch7","D",08,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate a Data         ?","mv_ch8","D",08,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Listar             ?","mv_ch9","N",01,0,0,"C",space(60),"mv_par09"       ,"Bloqueios"      ,space(30),space(15),"Liberacoes"     ,space(30),space(15),"Ambos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
LAYOUT DO RELATORIO

PRODUTO  DESCRICAO                       ARM  LOTE        QTDE. BLOQUEADA  MOTIVO                Nº DOC  DT. BLOQUEIO/USUARIO      DT.LIBER./USUARIO
999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99   9999999999  999.999.999,999  XXXXXXXXXXXXXXXXXXXX  XXXXXX  99/99/99 XXXXXXXXXXXXXXX  99/99/99 XXXXXXXXXXXXXXX 
DD_PRODUTO  B1_DESC                             DD_LOCAL DD)LOTECTL  DD_QUANT        X5_DESCRI             DD_DOC  DD_DTBLOQ DD_USERLGI      DD_LIB   DD_USERLGA
*/

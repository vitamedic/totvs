/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT308   ³ Autor ³ Alex Junio de Miranda ³ Data ³ 12/02/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio para Emissao de Relacao de Solicitantes para     ³±±
±±³          ³ Emissao de Solicitacao de Compras                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit308()
nordem  :=""
tamanho :="P"
limite  :=80
titulo  :="RELACAO DE SOLICITANTES P/SOLIC.COMPRAS"
cdesc1  :="Este programa ira emitir a relacao de Solicitantes para"
cdesc2  :="emissao de Solicitacao de Compras"
cdesc3  :=""
cstring :="SAI"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT308"
wnrel   :="VIT308"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)

cperg:="PERGVIT308"
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
_cfilsai:=xfilial("SAI")
sai->(dbsetorder(1))

processa({|| _querys()})

cabec1:="CODIGO   LOGIN               USUARIO"
cabec2:=""

setprc(0,0)
@ 000,000 PSAY avalimp(limite)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())

if prow()==0
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
endif

while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	
	if prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif

	if UsrExist(tmp1->userid)
		_user:=UsrRetName(tmp1->userid)
		_nomeuser:=UsrFullName(tmp1->userid)
		@ prow()+1,000 PSAY tmp1->userid
		@ prow(),009   PSAY _user
		@ prow(),029   PSAY _nomeuser
	endif
			
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
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
_cquery+=" DISTINCT(AI_USER) USERID"
_cquery+=" FROM"
_cquery+=  retsqlname("SAI")+" SAI"
_cquery+=" WHERE"
_cquery+="     SAI.D_E_L_E_T_=' '"
_cquery+=" AND AI_FILIAL='"+_cfilsai+"'"
_cquery+=" ORDER BY AI_USER"

/*
SELECT DISTINCT(AI_USER)
FROM SAI010 
WHERE D_E_L_E_T_=' '
AND AI_FILIAL='01' 
ORDER BY AI_USER
*/

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do usuario         ?","mv_ch1","C",15,0,0,"G",space(60)   ,"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"USR"})
aadd(_agrpsx1,{cperg,"02","Ate o usuario      ?","mv_ch2","C",15,0,0,"G",space(60)   ,"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"USR"})

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

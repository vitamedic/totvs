/*                                                                                       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITSLDNEG  ³ Autor ³ Claudio Ferreira    ³ Data ³ 02/09/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Lista saldo negativo                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"                          
#include "rwmake.ch"

user function _vitsldng()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="SALDO NEGATIVO"
cdesc1   :="Este programa ira Listar saldos negativos "
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VITSLDNEG"
wnrel    :="VITSLDNEG"
aordem  :={}
alinha   :={}
nlastkey :=0
lcontinua:=.t.
                    

cperg:="PERGVITSNE"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
   set filter to
   return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)
nordem:=areturn[8]
if nlastkey==27
   set filter to
   return
endif
rptstatus({|| rptdetail()})
return

static function rptdetail()
qDiv:=0
qTot:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

dData:=mv_par03-1

titulo:="SALDO NEGATIVO"+dtoc(dData)
                                                                                                 
cabec1:="                                                                                                "
cabec2:="Codigo Descricao                                  Qtde             Valor         C.M            "

// SALDOS NO SB9
_cquery:=" SELECT * "
_cquery+=" FROM "
_cquery+=  retsqlname("SB9")+" A"
_cquery+=" WHERE"
_cquery+="     A.D_E_L_E_T_<>'*'"
_cquery+=" AND B9_FILIAL='"+xfilial("SB9")+"'"
_cquery+=" AND B9_DATA = '"+Dtos(dData)+"'"
_cquery+=" AND B9_COD  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" ORDER BY B9_COD "	
_cquery:=changequery(_cquery)
	
tcquery _cquery new alias "QSB9"

Cab:=.t. 
lcontinua:=.t.	
setprc(0,0)
QSB9->(dbgotop())
nTotReg:=0 
nTotAtu:=0
while ! QSB9->(eof())
  nTotReg ++
  QSB9->(dbskip())
enddo 
QSB9->(dbgotop())
SetRegua(nTotReg)
while ! QSB9->(eof()) .and. lcontinua 
    nTotAtu++
	incregua(nTotAtu)
	dData:=mv_par03
	while dData<= mv_par04
	  aSaldo := CalcEst( QSB9->B9_COD,QSB9->B9_LOCAL,dData+1,QSB9->B9_FILIAL ) 
	  nQtd := (aSaldo)[ 1 ] 
      nVlr := (aSaldo)[ 2 ]
	  if nQtd<0 .or. nVlr<0
	    if Cab
   	      cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
   	      Cab:=.f.
   	    endif  
	  	@ prow()+1,000 PSAY AllTrim(QSB9->B9_COD)
		@ prow(),pcol()+2   PSAY left(Posicione("SB1",1,xfilial("SB1")+QSB9->B9_COD,"B1_DESC"),27)+"-"+Posicione("SB1",1,xfilial("SB1")+QSB9->B9_COD,"B1_UM")+" "+QSB9->B9_LOCAL
		@ prow(),pcol()+2   PSAY nQtd   picture "@E 99,999,999.9999"
		@ prow(),pcol()+2   PSAY nVlr   picture "@E 99,999,999.9999"
		@ prow(),pcol()+2   PSAY nVlr/nQtd picture "@E 999.9999"
		@ prow(),pcol()+2   PSAY Dtoc(dData)
		If prow() > 60 // Salto de Página.     
          Cab:=.t.
        Endif
	  endif     
	  dData++
	enddo  
	QSB9->(dbskip())     
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end                                                         
	
	
QSB9->(dbclosearea())

set device to screen

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endIf
ms_flush()
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Data Inicio        ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Data Fim           ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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





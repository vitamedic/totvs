/*                                                                                       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITATUD3   ³ Autor ³ Claudio Ferreira    ³ Data ³ 04/09/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Lista/Atualiza divergencia SD3                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"                          
#include "rwmake.ch"

user function _vitatud3()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="ATUD3"
cdesc1   :="Este programa ira Listar divergencias SD3 "
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VITATUD3"
wnrel    :="VITATUD3"
aordem  :={}
alinha   :={}
nlastkey :=0
lcontinua:=.t.
                    

cperg:="PERGVITSD3"
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


titulo:="DIVERGENCIAS CM ENTRADA"
                                                                                                 
cabec1:="                                                                                 SD3         SD1         "
cabec2:="Codigo Descricao                                  Qtde             Valor         C.M         C.M         "

// MOVIMENTOS SD3 
_cquery:=" SELECT * "
_cquery+=" FROM "
_cquery+=  retsqlname("SD3")+" A"
_cquery+=" WHERE"
_cquery+="     A.D_E_L_E_T_<>'*'"
_cquery+=" AND D3_FILIAL='"+xfilial("SD3")+"'"
_cquery+=" AND D3_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
_cquery+=" AND D3_COD  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"     
_cquery+=" AND (D3_CF='RE6' OR D3_CF='DE6') "
_cquery+=" ORDER BY D3_COD,D3_IDENT "	
_cquery:=changequery(_cquery)
	
tcquery _cquery new alias "QSD3"
u_setfield("QSD3")

Cab:=.t. 
lcontinua:=.t.	
setprc(0,0)
QSD3->(dbgotop())
nTotReg:=0 
nTotAtu:=0
while ! QSD3->(eof())
  nTotReg ++
  QSD3->(dbskip())
enddo 
QSD3->(dbgotop())
SetRegua(nTotReg)
while !QSD3->(eof()) .and. lcontinua 
    nTotAtu++
	incregua(nTotAtu)
	//Posiciona SD7
	dbSelectArea('SD7')
	dbSetOrder(2)
	//Filial+Numero+Produto+Local+Numseq
	nCMD3:=QSD3->D3_CUSTO1/QSD3->D3_QUANT
	nCD3:=QSD3->D3_CUSTO1
	If dbSeek(xFilial('SD7')+QSD3->D3_DOC+QSD3->D3_COD+'98'+QSD3->D3_IDENT, .F.)
	  dbSelectArea('SD1')
	  IF QSD3->D3_QUANT>0
  	    dbSetOrder(2)
	    cChave:=xFilial('SD1')+SD7->D7_PRODUTO+SD7->D7_DOC+SD7->D7_SERIE+SD7->D7_FORNECE+SD7->D7_LOJA 
	  else	    
	    dbSetOrder(5)
	    cChave:=xFilial('SD1')+SD7->D7_PRODUTO+SD7->D7_LOCAL+SD7->D7_NUMSEQ
	  endif 	  
	  If dbSeek(cChave)
	    nCMD1:=SD1->D1_CUSTO/SD1->D1_QUANT
	    nCD1:=SD1->D1_CUSTO	
	    if nCMD1<>nCMD3 .or. nCD3<>nCD1 
	      if Cab
   	        cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
   	        Cab:=.f.
   	      endif  
	  	  @ prow()+1,000 PSAY AllTrim(QSD3->D3_COD)
		  @ prow(),pcol()+2   PSAY left(Posicione("SB1",1,xfilial("SB1")+QSD3->D3_COD,"B1_DESC"),27)+"-"+Posicione("SB1",1,xfilial("SB1")+QSD3->D3_COD,"B1_UM")+" "+QSD3->D3_LOCAL
	      @ prow(),pcol()+2   PSAY QSD3->D3_QUANT   picture "@E 99,999,999.9999"
 	      @ prow(),pcol()+2   PSAY QSD3->D3_CUSTO1   picture "@E 99,999,999.9999"	
 	      if QSD3->D3_QUANT=0
	   	    @ prow(),pcol()+2   PSAY nCD3 picture "@E 999.9999"
	      else
		    @ prow(),pcol()+2   PSAY nCMD3 picture "@E 999.9999"
		  endif	 
		  if QSD3->D3_QUANT=0
		    @ prow(),pcol()+2   PSAY nCD1 picture "@E 999.9999" 
	     else
	        @ prow(),pcol()+2   PSAY nCMD1 picture "@E 999.9999" 
		  endif
		  @ prow(),pcol()+2   PSAY DTOC(QSD3->D3_EMISSAO) + " " +QSD3->D3_DOC
	      If prow() > 60 // Salto de Página.     
            Cab:=.t.
          Endif  
          lGrv:=.t.   
          if lGrv
            DbSelectArea( "SD3" )
	        dbGoto(QSD3->R_E_C_N_O_)
	        Reclock("SD3")
	        if D3_QUANT=0
	          D3_CUSTO1:=nCD1
	        else
              D3_CUSTO1:=nCMD1*D3_QUANT
            endif  
	        msUnlock()
	      endif  
	    endif     
	  endif  
	endif  
	QSD3->(dbskip())     
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end                                                         
	
	
QSD3->(dbclosearea())

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





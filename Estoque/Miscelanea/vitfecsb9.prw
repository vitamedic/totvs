/*                                                                                       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITFECSB9  ³ Autor ³ Claudio Ferreira    ³ Data ³ 31/08/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Lista/Atualiza divergencias na virada de saldos            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"                          
#include "rwmake.ch"

user function vitfecsb9()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="AJUSTA VIRADA SB9"
cdesc1   :="Este programa ira Listar/Atualizar divergencias na virada de saldos"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VITFECSB9"
wnrel    :="VITFECSB9"
aordem  :={}
alinha   :={}
nlastkey :=0
lcontinua:=.t.
                    

cperg:="PERGVITSB9"
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

dData:=mv_par03

titulo:="DIVERGENCIAS VIRADA DE SALDO "+dtoc(dData)
                                                                                                 
cabec1:="                                                                   S B 9                                   CALCULADO   "
cabec2:="Codigo Descricao                                  Qtde             Valor         C.M            Qtde         Valor         C.M  "

// SALDOS NO SB9
_cquery:=" SELECT * "
_cquery+=" FROM "
_cquery+=  retsqlname("SB9")+" A"
_cquery+=" WHERE"
_cquery+="     A.D_E_L_E_T_<>'*'"
_cquery+=" AND B9_FILIAL='"+xfilial("SB9")+"'"
_cquery+=" AND B9_DATA =  '"+dtos(dData)+"' "
_cquery+=" AND B9_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
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
nVlrSB9:=0
nVlrCal:=0
cProAtu:=QSB9->B9_COD
nUltCusto:=0
while ! QSB9->(eof()) .and. lcontinua 
    nTotAtu++
	incregua(nTotAtu)
	//Altera a data do B9 para não influenciar na CalcEst
	DbSelectArea( "SB9" ) 
	Erro:=.f.
	if DbSeek( QSB9->B9_FILIAL+QSB9->B9_COD+QSB9->B9_LOCAL+DtoS( dData )) 
	  nRec:=Recno()
	  if Reclock("SB9")
	      B9_DATA	:= dData+1
		  msUnlock()
	  else 
	    Erro:=.t.	  
	  endif
	else
	  Erro:=.t.    
	endif
	
	aSaldo := CalcEst( QSB9->B9_COD,QSB9->B9_LOCAL,dData+1,QSB9->B9_FILIAL ) 
	
	//Restaura a data
	if !Erro
	  DbSelectArea( "SB9" )
	  dbGoto(nRec)
	  Reclock("SB9")
      B9_DATA	:= dData
	  msUnlock()
	else
	  @ prow()+3,10 PSAY "Erro produto " + QSB9->B9_COD + QSB9->B9_LOCAL   
	endif  
	DbSelectArea( "QSB9" )
	nQtd := (aSaldo)[ 1 ] 
    nVlr := (aSaldo)[ 2 ]
    nQtd2:= (aSaldo)[ 7 ]
    cAcao=' '  
	if (nQtd<>QSB9->B9_QINI) .or. (nVlr<>QSB9->B9_VINI1) //Divergencia 
	    if Cab
   	      cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
   	      Cab:=.f.
   	    endif  
	  	@ prow()+1,000 PSAY AllTrim(QSB9->B9_COD)
		@ prow(),pcol()+2   PSAY left(Posicione("SB1",1,xfilial("SB1")+QSB9->B9_COD,"B1_DESC"),27)+"-"+Posicione("SB1",1,xfilial("SB1")+QSB9->B9_COD,"B1_UM")+" "+QSB9->B9_LOCAL
		@ prow(),pcol()+2   PSAY QSB9->B9_QINI   picture "@E 99,999,999.9999"
		@ prow(),pcol()+2   PSAY QSB9->B9_VINI1 picture "@E 99,999,999.9999"
		@ prow(),pcol()+2   PSAY QSB9->B9_VINI1/QSB9->B9_QINI picture "@E 999.9999"
		@ prow(),pcol()+2   PSAY nQtd      picture "@E 99,999,999.9999" 
		aQtd:=nQtd
		aVlr:=nVlr           
		if nQtd<=0 .and. nVlr<>0
		  nVlr:=0
		  cAcao='Z'
		endif  
		if nQtd>0 .and. nVlr<=0
		  nVlr:=nUltCusto //Copia se o mesmo produto esta valorizado em outro armazem
		  Ult:=.f.
		  if nVlr=0  
		    nVlr:=UltCusto(QSB9->B9_COD,dData)  //Tenta buscar no D1
		    if nVlr>0
		      Ult:=.t.
		    endif
		  endif
		  if nVlr<=0		     
		    nVlr:=0
		    cAcao='V'
		  else
		    nVlr:=nVlr*nQtd
		    if Ult
		      cAcao='U'
		    else
		      cAcao='C'
		    endif  
		  endif  
		endif
		if cAcao<>'V'		
  		  @ prow(),pcol()+2   PSAY nVlr      picture "@E 99,999,999.9999" 
  		else
    	  @ prow(),pcol()+2   PSAY '***Valorizar***'
  		endif  
		@ prow(),pcol()     PSAY cAcao
		@ prow(),pcol()+1   PSAY nVlr/nQtd picture "@E 999.9999"
		if (nVlr/nQtd)>0 
		  nUltCusto:=nVlr/nQtd 
		endif  
		@ prow(),pcol()     PSAY ' '
		if (aQtd<>QSB9->B9_QINI)
		  @ prow(),pcol()   PSAY 'Q'
		endif
		if (aVlr<>QSB9->B9_VINI1)
		  @ prow(),pcol()   PSAY 'V'
		endif
		nQtdBJ:=CalcSBJ(QSB9->B9_COD,QSB9->B9_LOCAL,dData,QSB9->B9_FILIAL) 
		if nQtdBJ<>nQtd .and. nQtdBJ<>0 
		  @ prow()+1,20 PSAY "Divergencia SBJ => "  
    	  @ prow(),pcol()+2   PSAY nQtdBJ     picture "@E 99,999,999.9999"
		endif
		lGrv:=.f.
		if lGrv
	      DbSelectArea( "SB9" ) 
	      Erro:=.f.
	      if DbSeek( QSB9->B9_FILIAL+QSB9->B9_COD+QSB9->B9_LOCAL+DtoS( dData )) 
	        if Reclock("SB9")
	          if cAcao='Z'
	            B9_QINI:=0
	            B9_VINI1:=0
	            B9_QISEGUM:=0
	          else
	            B9_QINI:=nQtd
	            B9_VINI1:=nVlr
	            B9_QISEGUM:=nQtd2	              
	          endif
		      msUnlock()
	        else 
	          Erro:=.t.	  
	        endif
	      else
	        Erro:=.t.    
	      endif
	      if Erro
	        @ prow()+3,10 PSAY "Erro Grv produto " + QSB9->B9_COD + QSB9->B9_LOCAL   
	      endif	      		  
	      DbSelectArea( "QSB9" )
		endif
		nVlrSB9+=QSB9->B9_VINI1
        nVlrCal+=nVlr
		If prow() > 60 // Salto de Página.     
          Cab:=.t.
        Endif
        qDiv++
	endif     
	qTot++
	QSB9->(dbskip())     
	if QSB9->B9_COD<>cProAtu
	  cProAtu:=QSB9->B9_COD
	  nUltCusto:=0
	endif  
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end                                                         
if qTot>0 
	@ prow()+2,10 PSAY "Totais  " 
	@ prow(),pcol()+40   PSAY nVlrSB9 picture "@E 99,999,999.9999"
	@ prow(),pcol()+30   PSAY nVlrCal picture "@E 99,999,999.9999"
	@ prow()+3,10 PSAY "Total pesquisados "  
	@ prow(),pcol()+2   PSAY qTot picture "@E 999,999"
	@ prow()+2,10 PSAY "Total divergentes "  
	@ prow(),pcol()+2   PSAY qDiv picture "@E 999,999"	
endif	 
	
	
QSB9->(dbclosearea())

set device to screen

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endIf
ms_flush()
return

Static Function CalcSBJ(xProd,xDep,xData,xFilial)
LOCAL XAREA
Local _ret,cQuery
XAREA=ALIAS()
cQuery := "SELECT SUM(BJ_QINI) AS QTDPRO  "
cQuery += "FROM "+RetSqlName("SBJ")+" A"
cQuery += " WHERE A.D_E_L_E_T_<>'*'"
cQuery += " AND BJ_COD='"+xProd+"'"
cQuery += " AND BJ_LOCAL='"+xDep+"'"
cQuery += " AND BJ_DATA='"+DTOS(xData)+"'"
cQuery += " AND BJ_FILIAL='"+xFilial+"'"
TCQUERY cQuery NEW ALIAS "_PRO"
dbSelectArea("_PRO")
_ret:=0
if !eof()
  _Ret:=_PRO->QTDPRO
endif
dbCloseArea()
SELE &XAREA
RETURN _Ret 


Static Function UltCusto(xProd,xData)
LOCAL XAREA
Local _ret,cQuery
XAREA=ALIAS()
cQuery := "SELECT DISTINCT  D1_CUSTO/D1_QUANT AS CUS "
cQuery += "  FROM "+RetSqlName("SD1")+" A,"+RetSqlName("SB1")+" B,"+RetSqlName("SF4")+" D"
cQuery += " WHERE A.D_E_L_E_T_<>'*' AND B.D_E_L_E_T_ <> '*' AND D.D_E_L_E_T_ <> '*'"
cQuery += "   AND D1_FILIAL ='"+xFilial("SD1")+"'"
cQuery += "   AND F4_FILIAL ='"+xFilial("SF4")+"'"
cQuery += "   AND D1_COD = B1_COD and D1_COD='"+xProd+"' "
cQuery += "   AND D1_TIPO ='N'" 
cQuery += "   AND D1_TES=F4_CODIGO AND F4_DUPLIC='S'" 
cQuery += "   AND A.D1_EMISSAO IN  (SELECT DISTINCT MAX(D1_EMISSAO) FROM "+RetSqlName('SD1')+" E WHERE A.D1_COD = E.D1_COD AND D1_EMISSAO<='"+DTOS(xData)+"' AND D1_FILIAL = '"+xFilial("SD1")+"' AND D1_TIPO = 'N' AND E.D_E_L_E_T_ <> '*' GROUP BY D1_COD)
cQuery += " ORDER BY D1_COD"

TCQUERY cQuery NEW ALIAS "QSD1" 
	

dbSelectArea("QSD1")
dbGotop()
_ret:=0
if !eof()
  _Ret:=QSD1->CUS
endif
dbCloseArea()
SELE &XAREA
RETURN _Ret 


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Data Fechamento    ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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





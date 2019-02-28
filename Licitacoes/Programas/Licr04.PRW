#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LICR04    ³ Autor ³ Marcelo Myra Martins ³Data ³  24/10/02 ³±± 
±±³          ³           ³ Alteracao: Aline B.Pereira   ³Data ³  14/06/04 ³±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Relatório Mapa Comparativo de Preços                       ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±²Uso       ³ Controle de Licitacoes                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function LICR04()

nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="Mapa Comparativo de Precos"
cdesc1  :="Este programa ira emitir a relacao de mapa comparativos de Precos por produto"
cdesc2  :=""
cdesc3  :=""
cstring :="SZL"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="LICR04"
wnrel   :="LICR04"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGLICR04"
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

Return



static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)
Cabec1 :=  "Proposta Licitante                       Fornec Abertura Validade   Produto  Descricao                       UN    Qtde. % Variacao"
Cabec2 :=  "PERIODO DE "+dtoc(mv_par05)+" A "+dtoc(mv_par06)+"                     Colocacao                Concorrente                           Vl.Unit  Vl.Total"
_aCampos := {}

_acom  :={}
_i := 0

_aCampos := {{"NUMPRO","C",08,0},;
             {"PROPOS","C",08,0},;
				 {"DTPRO","D",08,0},;
				 {"DTABER","D",08,0},;
				 {"LICITA","C",06,0},;
				 {"DIASVAL","N",03,0},;
				 {"FORNEC","N",02,0},;				 
				 {"CODPRO","C",15,0},;
  	          {"DESCRI","C",40,0},;
   			 {"UM","C",2,0},;
				 {"QTDTOT","N",11,0},;
				 {"PRCUNI","N",8,4},;
				 {"COLOC","N",3,0},;
				 {"MENORP","N",8,4},;
				 {"NOMCON","C",20,0},;
				 {"VARIAC","N",8,2}}
				 

				
_aTMP := U_CriaTMP("TMP","NUMPRO+STRZERO(COLOC,3)",_aCampos)

_cfilszl:=xfilial("SZL")
_cfilsa3:=xfilial("SA3")
_cfilszm:=xfilial("SZM")
_cfilszp:=xfilial("SZP")
_cfilsa1:=xfilial("SA1")
_cfilszn:=xfilial("SZN")

sa3->(dbsetorder(1))
sa1->(dbsetorder(1))
szl->(dbsetorder(1))  
szm->(dbsetorder(1))                
szp->(dbsetorder(1))                
szn->(dbsetorder(3))                


dbSelectArea("SZL")
dbSetOrder(1)
dbGotop()
While !SZL->(EOF())
	if SZL->ZL_DATA < mv_par05 .or. SZL->ZL_DATA > mv_par06
		SZL->(dbSkip())
		Loop
	endif
	if SZL->ZL_PROPOS < mv_par07 .or. SZL->ZL_PROPOS > mv_par08
		SZL->(dbSkip())
		Loop
	endif
	szp->(dbseek(_cfilszp+szl->zl_licitan))
	sa1->(dbseek(_cfilsa1+szp->zp_codcli+szp->zp_ljcli)) 	
	if sa1->a1_tipo<>"F"
		SZL->(dbSkip())
		Loop
	endif
	dbSelectArea("SZM")
	dbSetOrder(1)
	dbSeek(xFilial("SZM")+SZL->ZL_NUMPRO)
	while !SZM->(Eof()) .and. SZL->ZL_NUMPRO==SZM->ZM_NUMPRO
		if SZM->ZM_CODPRO < mv_par01 .or. SZM->ZM_CODPRO > mv_par02
			SZM->(dbSkip())
			Loop
		endif		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SZM->ZM_CODPRO)	
		if SB1->B1_GRUPO < mv_par03 .or. SB1->B1_GRUPO > mv_par04
			SZM->(dbSkip())
			Loop
		endif		
		// Verifica nossa posicao
		dbSelectArea("SZN")
		dbSetOrder(2)
		if dbSeek(xFilial("SZN")+SZL->ZL_NUMPRO+SZM->ZM_CODPRO+GetNewPar("MV_LICONC","000001"))
			_nNossaPos := SZN->ZN_COLOC
		   _nNossoPrc := if(mv_par09<>1,xMoeda(SZN->ZN_PRECO,1,mv_par09,SZL->ZL_DATA,4),SZN->ZN_PRECO)
		else
			_nNossaPos := 0
		   _nNossoPrc := 0
		endif		
		// Verifica Vencedor
		dbSetOrder(3)
		if dbSeek(xFilial("SZN")+SZL->ZL_NUMPRO+SZM->ZM_CODPRO)
			_nMenorPrc 	:= if(mv_par09<>1,xMoeda(SZN->ZN_PRECO,1,mv_par09,SZL->ZL_DATA,4),SZN->ZN_PRECO)
		   _cNomeConc 	:= SZN->ZN_NOMCON
		else                 
			_nMenorPrc 	:= 0
		   _cNomeConc 	:= "N/D"
		endif		
		// Calcula Variação
		_nVariacao := Round((1 - (_nNossoPrc / _nMenorPrc)) * 100,2)	
		TMP->(RecLock("TMP",.t.))
		TMP->NUMPRO 	:= SZL->ZL_NUMPRO
		TMP->PROPOS 	:= SZL->ZL_PROPOS
		TMP->DTPRO 		:= SZL->ZL_DATA
		TMP->DTABER    := SZL->ZL_DTABER
		TMP->LICITA 	:= SZL->ZL_LICITAN
      TMP->DIASVAL	:=	SZL->ZL_DIASVAL
		TMP->FORNEC    := SZL->ZL_PERIODO
		TMP->CODPRO 	:= SZM->ZM_CODPRO
		TMP->DESCRI 	:= SZM->ZM_DESC
		TMP->UM		   := SZM->ZM_UM1
		TMP->QTDTOT		:= SZM->ZM_QTDE1
		TMP->PRCUNI		:= _nNossoPrc
		TMP->COLOC		:= _nNossaPos
		TMP->MENORP		:= _nMenorPrc
		TMP->NOMCON		:= _cNomeConc
		TMP->VARIAC		:= _nVariacao
		TMP->(MsUnlock())    
		SZM->(dbSkip())
	enddo
	SZL->(dbSkip())

enddo
if mv_par10==2	
	dbSelectArea("TMP")
	SetRegua(RecCount())
	_nNumAnt := ""
	TMP->(dbGoTop())
	_mc := .f.
	While !TMP->(EOF())
	  	if prow()==0 .or. prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif        
	          
	   if _nNumAnt <> TMP->NUMPRO
		 	if prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif                	
			szp->(dbseek(_cfilszp+TMP->LICITA))
		   @ prow()+2,00 PSAY TMP->PROPOS
		   @ prow(),010 PSAY TMP->LICITA+"-"+substr(szp->zp_nomlic,1,25)
	  		@ prow(),045 PSAY TMP->FORNEC
	  		@ prow(),048 PSAY TMP->DTABER
	  	   @ prow(),058 PSAY TMP->DTABER+TMP->DIASVAL
	 	   _nNumAnt := TMP->NUMPRO                   
	 	   _mc := .t.
		endif	      
		if _mc
		   @ prow(),069 PSAY SUBSTR(TMP->CODPRO,1,6)
		else
		   @ prow()+1,069 PSAY SUBSTR(TMP->CODPRO,1,6)	
		endif
	   @ prow(),077 PSAY substr(TMP->DESCRI,1,30)
	   @ prow(),109 PSAY TMP->UM  
	   @ prow(),111 PSAY TRANSFORM(TMP->QTDTOT, "@E 999,999,999")	     
	   @ prow(),123 PSAY TRANSFORM(TMP->VARIAC, "@E 9999.99%")	   
	   ImpConcs(TMP->NUMPRO,TMP->CODPRO,TMP->QTDTOT)
	   _mc := .f.
	   TMP->(dbSkip())  
	enddo
else

endif
TMP->(dbCloseArea())
U_ApagaTMP(_aTMP)

szl->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return




static function ImpConcs(_cProposta,_cProduto,_nqtde)
dbSelectArea("SZN")
dbSetOrder(3)
szn->(dbseek(_cfilszn+_cProposta+_cProduto,.t.)) 
while ! szn->(eof()) .and.;
			szn->zn_numpro==_cProposta .and.;
 			szn->zn_codpro==_cProduto
 	if prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif                	
   @ prow()+1,50 PSAY alltrim(str(SZN->ZN_COLOC))+"-"
   @ prow(),77 PSAY SZN->ZN_NOMCON
   @ prow(),111 PSAY TRANSFORM(SZN->ZN_PRECO, "@E 9,999.9999")
   @ prow(),123 PSAY TRANSFORM(_nqtde*SZN->ZN_PRECO, "@E 999,999.99")   
	szn->(dbSkip())
enddo
return()


static function _pergsx1()
_agrpsx1:={}    
//		         GRUPO 							          ESP       ING     VAR     TIPO             VALID     VAR01             DEF01     ESP      ING       CNT01     VAR02     DEF02     ESP      ING       CNT02      VAR03     DEF03       ESP      ING       CNT03     VAR04     DEF04       ESP      ING       CNT04   VAR05     DEF05       ESP      ING       CNT05    F3    GRPSXG
//               1    2            3                 4         5        6      7   8 9 10 11     12        13               14        15        16        17        18        19       20         21       22        23          24        25       26       27           28      29          30      31         32      33       34          35        36        37       38     39      
aadd(_agrpsx1,{cperg,"01","Do Produto         ?",space(20),space(20),"mv_ch1","C",15,0,0,"G",space(60),"mv_par01       ",space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"SB1",space(3)} )
aadd(_agrpsx1,{cperg,"02","Ate Produto        ?",space(20),space(20),"mv_ch2","C",15,0,0,"G",space(60),"mv_par02       ",space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"SB1",space(3)} )
aadd(_agrpsx1,{cperg,"03","Do Grupo           ?",space(20),space(20),"mv_ch3","C",04,0,0,"G",space(60),"mv_par03       ",space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"SBM",space(3)} )
aadd(_agrpsx1,{cperg,"04","Ate Grupo          ?",space(20),space(20),"mv_ch4","C",04,0,0,"G",space(60),"mv_par04       ",space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"SBM",space(3)} )
aadd(_agrpsx1,{cperg,"05","Data Inicial       ?",space(20),space(20),"mv_ch5","D",08,0,0,"G",space(60),"mv_par05       ",space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"   ",space(3)} )
aadd(_agrpsx1,{cperg,"06","Data Final         ?",space(20),space(20),"mv_ch6","D",08,0,0,"G",space(60),"mv_par06       ",space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"   ",space(3)} )
aadd(_agrpsx1,{cperg,"07","Proposta Inicial   ?",space(20),space(20),"mv_ch7","C",08,0,0,"G",space(60),"mv_par07       ",space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"SZL",space(3)} )
aadd(_agrpsx1,{cperg,"08","Proposta Final     ?",space(20),space(20),"mv_ch8","C",08,0,0,"G",space(60),"mv_par08       ",space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"SZL",space(3)} )
aadd(_agrpsx1,{cperg,"09","Moeda              ?",space(20),space(20),"mv_ch9","N",01,0,1,"C",space(60),"mv_par09       ","Moeda 1",space(15),space(15),space(40),space(15),"Moeda 2",space(15),space(15),space(40),space(15),"Moeda 3",space(15),space(15),space(40),space(15),"Moeda 4",space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"   ",space(3)} )
aadd(_agrpsx1,{cperg,"10","Detalhamento       ?",space(20),space(20),"mv_chA","N",01,0,1,"C",space(60),"mv_par10       ","Sintetico",space(15),space(15),space(40),space(15),"Analitico",space(15),space(15),space(40),space(15),"Moeda 3",space(15),space(15),space(40),space(15),"Moeda 4",space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"   ",space(3)} )
	
for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,06]
		sx1->x1_tipo   :=_agrpsx1[_i,07]
		sx1->x1_tamanho:=_agrpsx1[_i,08]
		sx1->x1_decimal:=_agrpsx1[_i,09]
		sx1->x1_presel :=_agrpsx1[_i,10]
		sx1->x1_gsc    :=_agrpsx1[_i,11]
		sx1->x1_valid  :=_agrpsx1[_i,12]
		sx1->x1_var01  :=_agrpsx1[_i,13]
		sx1->x1_def01  :=_agrpsx1[_i,14]
		sx1->x1_cnt01  :=_agrpsx1[_i,17]
		sx1->x1_var02  :=_agrpsx1[_i,18]
		sx1->x1_def02  :=_agrpsx1[_i,19]
		sx1->x1_cnt02  :=_agrpsx1[_i,22]
		sx1->x1_var03  :=_agrpsx1[_i,23]
		sx1->x1_def03  :=_agrpsx1[_i,24]
		sx1->x1_cnt03  :=_agrpsx1[_i,27]
		sx1->x1_var04  :=_agrpsx1[_i,28]
		sx1->x1_def04  :=_agrpsx1[_i,29]
		sx1->x1_cnt04  :=_agrpsx1[_i,32]
		sx1->x1_var05  :=_agrpsx1[_i,33]
		sx1->x1_def05  :=_agrpsx1[_i,34]
		sx1->x1_cnt05  :=_agrpsx1[_i,37]
		sx1->x1_f3     :=_agrpsx1[_i,38]
		sx1->x1_grpsxg :=_agrpsx1[_i,39]
		sx1->(msunlock())
	endif
next

Return


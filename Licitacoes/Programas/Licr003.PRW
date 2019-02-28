#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LICR003    º Autor ³ Marcelo Myra Martins Data ³  23/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de produtos cotados                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Controle de Licitacoes                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LICR003()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Produtos Cotados"
Local cPict          := ""
Local titulo       := "Produtos Cotados"
Local nLin         := 80   
//		      				          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        			
//	    				   	01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1       :=  "Cod.Produto      Descricao                                           Unid.    No.Propostas      Quantidade     ($)Unit.Médio"
Local Cabec2       :=  ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "LICR003"
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "LIC003"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "LICR003" 

Private cString := "SZM"

dbSelectArea("SZM")
dbSetOrder(4)

_pergsx1()

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  11/09/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local _aTMP
Local _aCampos := {}

_aCampos := {{"CODPRO","C",15,0},;
  	          {"DESCRI","C",40,0},;
   			 {"UM","C",9,0},;
	 			 {"QTDPRO","N",4,0},;
				 {"QTDTOT","N",11,0},;
				 {"PRCMED","N",8,4}}

if mv_par07==1
	_cChave := "QTDTOT"
	_cPar := 'D'
else
	_cChave := "DESCRI"
	_cPar := NIL
endif
				
_aTMP := U_CriaTMP("TMP",_cChave,_aCampos,_cPar)


dbSelectArea("SZM")
dbSetOrder(4)
dbGotop()
While !SZM->(EOF())
	
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
	
	_nNumPro 	:= 0
	_nQtdeTot	:= 0
	_nPrcTot   := 0
	_cProduto 	:= SZM->ZM_CODPRO
	_cDesc	   := SZM->ZM_DESC
	_cUM			:= Posicione("SAH",1,xFilial("SAH")+SZM->ZM_UM1,"AH_UMRES")
	while !SZM->(EOF()) .and. _cProduto==SZM->ZM_CODPRO
	
		dbSelectArea("SZL")
		dbSetOrder(1)
		dbSeek(xFilial("SZL")+SZM->ZM_NUMPRO)
	
		if SZL->ZL_DATA < mv_par05 .or. SZL->ZL_DATA > mv_par06
			SZM->(dbSkip())
			Loop
		endif
		
		if !Empty(mv_par08) .and. SZL->ZL_REPRES<>mv_par08
			SZM->(dbSkip())
			Loop
		endif			
		
		_nQtdeTot := _nQtdeTot + SZM->ZM_QTDE1
		_nPrcTot := _nPrcTot + if(mv_par09<>1,xMoeda(SZM->ZM_PRCUNI,1,mv_par09,SZL->ZL_DATA,4),SZM->ZM_PRCUNI)
   	_nNumPro++
		SZM->(dbSkip())
	enddo
	
	TMP->(RecLock("TMP",.t.))
	TMP->CODPRO 	:= _cProduto
	TMP->DESCRI 	:= _cDesc
	TMP->UM		   := _cUM
	TMP->QTDPRO    := _nNumPro
	TMP->QTDTOT		:= _nQtdeTot
	TMP->PRCMED		:= (_nPrcTot / _nNumPro)
	TMP->(MsUnlock())
	
enddo

if !Empty(mv_par08)
	Cabec2 := "Representante: " + Posicione("SA3",1,xFilial("SA3")+mv_par08,"A3_NOME")
endif
	
dbSelectArea("TMP")
SetRegua(RecCount())

TMP->(dbGoTop())
While !TMP->(EOF())

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //³ Impressao do cabecalho do relatorio. . .                            ³
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
	   @ nLin,00 PSAY " "
	   nLin := nLin + 1 // Avanca a linha de impressao
   Endif
 

   @ nLin,00 PSAY TMP->CODPRO
   @ nLin,17 PSAY TMP->DESCRI
   @ nLin,69 PSAY TMP->UM
   @ nLin,82 PSAY strzero(TMP->QTDPRO, 4)
   @ nLin,96 PSAY TRANSFORM(TMP->QTDTOT, "@E 999,999,999")
   @ nLin,113 PSAY TRANSFORM(TMP->PRCMED, "@E 999.9999")
   
   nLin := nLin + 1 // Avanca a linha de impressao
   
   TMP->(dbSkip()) 
   
enddo

TMP->(dbCloseArea())
U_ApagaTMP(_aTMP)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

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
aadd(_agrpsx1,{cperg,"07","Ordem              ?",space(20),space(20),"mv_ch7","N",01,0,1,"C",space(60),"mv_par07       ","Ranking",space(15),space(15),space(40),space(15),"Alfabética",space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"   ",space(3)} )
aadd(_agrpsx1,{cperg,"08","Representante      ?",space(20),space(20),"mv_ch8","C",06,0,0,"G",space(60),"mv_par08       ",space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"SA3",space(3)} )
aadd(_agrpsx1,{cperg,"09","Moeda              ?",space(20),space(20),"mv_ch9","N",01,0,1,"C",space(60),"mv_par07       ","Moeda 1",space(15),space(15),space(40),space(15),"Moeda 2",space(15),space(15),space(40),space(15),"Moeda 3",space(15),space(15),space(40),space(15),"Moeda 4",space(15),space(15),space(40),space(15),space(15),space(15),space(15),space(40),"   ",space(3)} )
	
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


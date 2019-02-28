#include "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"
#include "Ap5Mail.ch"
#include "totvs.ch"
#include "prtopdef.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LIC008    ³Autor  ³Marcelo Myra       ³Data ³  10/09/02    ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Desc.     ³ Atualização da Grade de Precos                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AP6                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function LIC008()

LOCAL aCORES  := {{'ZL_STATUS=="1" .and. !Empty(ZL_PROPOS)',"ENABLE" },; 	
            	  {'ZL_STATUS=="2" .and. !Empty(ZL_PROPOS)',"BR_AMARELO"},; 
            	  {'ZL_STATUS=="3" .and. !Empty(ZL_PROPOS)',"BR_AZUL"},;
            	  {'ZL_STATUS=="4" .and. !Empty(ZL_PROPOS)',"DISABLE"},;
            	  {'Empty(ZL_PROPOS)',"BR_CINZA"},; 	
            	  {'!Empty(ZL_PEDIDO)',"BR_PRETO"}}

PRIVATE cCADASTRO 	:= "Grade de Precos"
PRIVATE	aRotina	:= {{ "Pesquisar","AxPesqui", 0 , 1},;
{ "Incluir","U_Grade(1)", 0 , 3},;
{ "Atualizar","U_Grade(3)", 0 , 2},;
{ "Resultados","U_LIC012()", 0 , 2},;
{ "Gerar PV","U_Venc()", 0 , 2},;
{ "Legenda","U_Leg001()", 0 , 2}}
            	     
// executa a mBrowse
dbSelectArea("SZL")
dbSetOrder(3)
mBrowse(6,01,22,75,"SZL",,,,,,aCORES)

Return(.t.)


User Function Grade(_nOpcao)

PRIVATE _nOpc := _nOpcao

PRIVATE oGrade2,btnOk,btCancela,btnConc,oGrp6,lblTeste,oSay9,oSay13,oSay14,oSay29,oSay21,oSBtn22,oSay23,oSay25,oSay17
oGrade2 := MSDIALOG():Create()
oGrade2:cName := "oGrade2"
oGrade2:cCaption := "Atualização da Grade de Preços"
oGrade2:nLeft := 0
oGrade2:nTop := 0
oGrade2:nWidth := 602
oGrade2:nHeight := 436
oGrade2:lShowHint := .F.
oGrade2:lCentered := .T.

btnOk := SBUTTON():Create(oGrade2)
btnOk:cName := "btnOk"
btnOk:cCaption := "Ok"
btnOk:cMsg := "Ok"
btnOk:cToolTip := "Ok"
btnOk:nLeft := 471
btnOk:nTop := 374
btnOk:nWidth := 52
btnOk:nHeight := 22
btnOk:lShowHint := .T.
btnOk:lReadOnly := .F.
btnOk:Align := 0
btnOk:lVisibleControl := .T.
btnOk:nType := 1
btnOk:bLClicked := {|| Confirma() }

btCancela := SBUTTON():Create(oGrade2)
btCancela:cName := "btCancela"
btCancela:cCaption := "Cancela"
btCancela:cMsg := "Cancela"
btCancela:cToolTip := "Cancela"
btCancela:nLeft := 530
btCancela:nTop := 373
btCancela:nWidth := 51
btCancela:nHeight := 23
btCancela:lShowHint := .T.
btCancela:lReadOnly := .F.
btCancela:Align := 0
btCancela:lVisibleControl := .T.
btCancela:nType := 2
btCancela:bLClicked := {|| Cancela() }

btnConc := SBUTTON():Create(oGrade2)
btnConc:cName := "btnConc"
btnConc:cCaption := "Concorrentes"
btnConc:cToolTip := "Preços dos Concorrentes"
btnConc:nLeft := 21
btnConc:nTop := 372
btnConc:nWidth := 52
btnConc:nHeight := 23
btnConc:lShowHint := .T.
btnConc:lReadOnly := .F.
btnConc:Align := 0
btnConc:lVisibleControl := .T.
btnConc:nType := 23
btnConc:bLClicked := {|| U_LIC003() }

oGrp6 := TGROUP():Create(oGrade2)
oGrp6:cName := "oGrp6"
oGrp6:cCaption := "Informações da Proposta"
oGrp6:nLeft := 22
oGrp6:nTop := 8
oGrp6:nWidth := 562
oGrp6:nHeight := 114
oGrp6:lShowHint := .F.
oGrp6:lReadOnly := .F.
oGrp6:Align := 0
oGrp6:lVisibleControl := .T.

lblTeste := TSAY():Create(oGrade2)
lblTeste:cName := "lblTeste"
lblTeste:cCaption := "Nr.Proposta:"
lblTeste:nLeft := 38
lblTeste:nTop := 28
lblTeste:nWidth := 64
lblTeste:nHeight := 17
lblTeste:lShowHint := .F.
lblTeste:lReadOnly := .F.
lblTeste:Align := 0
lblTeste:lVisibleControl := .T.
lblTeste:lWordWrap := .F.
lblTeste:lTransparent := .T.

oSay9 := TSAY():Create(oGrade2)
oSay9:cName := "oSay9"
oSay9:cCaption := "Representante:"
oSay9:nLeft := 24
oSay9:nTop := 74
oSay9:nWidth := 74
oSay9:nHeight := 17
oSay9:lShowHint := .F.
oSay9:lReadOnly := .F.
oSay9:Align := 0
oSay9:lVisibleControl := .T.
oSay9:lWordWrap := .F.
oSay9:lTransparent := .T.

oSay13 := TSAY():Create(oGrade2)
oSay13:cName := "oSay13"
oSay13:cCaption := "Licitante:"
oSay13:nLeft := 52
oSay13:nTop := 51
oSay13:nWidth := 48
oSay13:nHeight := 17
oSay13:lShowHint := .F.
oSay13:lReadOnly := .F.
oSay13:Align := 0
oSay13:lVisibleControl := .T.
oSay13:lWordWrap := .F.
oSay13:lTransparent := .T.

oSay14 := TSAY():Create(oGrade2)
oSay14:cName := "oSay14"
oSay14:cCaption := "Dt.Abertura:"
oSay14:nLeft := 229
oSay14:nTop := 24
oSay14:nWidth := 61
oSay14:nHeight := 17
oSay14:lShowHint := .F.
oSay14:lReadOnly := .F.
oSay14:Align := 0
oSay14:lVisibleControl := .T.
oSay14:lWordWrap := .F.
oSay14:lTransparent := .T.

oSay29 := TSAY():Create(oGrade2)
oSay29:cName := "oSay29"
oSay29:cCaption := "Atualizar Preços"
oSay29:nLeft := 79
oSay29:nTop := 375
oSay29:nWidth := 86
oSay29:nHeight := 17
oSay29:lShowHint := .F.
oSay29:lReadOnly := .F.
oSay29:Align := 0
oSay29:lVisibleControl := .T.
oSay29:lWordWrap := .F.
oSay29:lTransparent := .T.

oSay21 := TSAY():Create(oGrade2)
oSay21:cName := "oSay21"
oSay21:cCaption := "Prazo Pagto:"
oSay21:nLeft := 223
oSay21:nTop := 74
oSay21:nWidth := 65
oSay21:nHeight := 17
oSay21:lShowHint := .F.
oSay21:lReadOnly := .F.
oSay21:Align := 0
oSay21:lVisibleControl := .T.
oSay21:lWordWrap := .F.
oSay21:lTransparent := .T.

oSBtn22 := SBUTTON():Create(oGrade2)
oSBtn22:cName := "oSBtn22"
oSBtn22:cCaption := "oSBtn22"
oSBtn22:nLeft := 187
oSBtn22:nTop := 372
oSBtn22:nWidth := 52
oSBtn22:nHeight := 22
oSBtn22:lShowHint := .F.
oSBtn22:lReadOnly := .F.
oSBtn22:Align := 0
oSBtn22:lVisibleControl := .T.
oSBtn22:nType := 15
oSBtn22:bLClicked := {|| U_LIC012() }

oSay23 := TSAY():Create(oGrade2)
oSay23:cName := "oSay23"
oSay23:cCaption := "Visualizar Grade"
oSay23:nLeft := 246
oSay23:nTop := 375
oSay23:nWidth := 84
oSay23:nHeight := 17
oSay23:lShowHint := .F.
oSay23:lReadOnly := .F.
oSay23:Align := 0
oSay23:lVisibleControl := .T.
oSay23:lWordWrap := .F.
oSay23:lTransparent := .T.

oSay25 := TSAY():Create(oGrade2)
oSay25:cName := "oSay25"
oSay25:cCaption := "Dias entrega:"
oSay25:nLeft := 34
oSay25:nTop := 98
oSay25:nWidth := 65
oSay25:nHeight := 17
oSay25:lShowHint := .F.
oSay25:lReadOnly := .F.
oSay25:Align := 0
oSay25:lVisibleControl := .T.
oSay25:lWordWrap := .F.
oSay25:lTransparent := .T.

oSay17 := TSAY():Create(oGrade2)
oSay17:cName := "oSay17"
oSay17:cCaption := "Dias validade:"
oSay17:nLeft := 219
oSay17:nTop := 99
oSay17:nWidth := 69
oSay17:nHeight := 17
oSay17:lShowHint := .F.
oSay17:lReadOnly := .F.
oSay17:Align := 0
oSay17:lVisibleControl := .T.
oSay17:lWordWrap := .F.
oSay17:lTransparent := .T.



/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ€¦ú¿
//³Inicio de definições Manuais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ€¦úÙ
ENDDOC*/                         

dbSelectArea("SZL")
RegtoMemory("SZL",_nOpc==1)

cNumPro := M->ZL_NUMPRO


if _nOpc<>1
  Descr()
endif

@ 12,55  GET M->ZL_NUMPRO 		SIZE 40,8 WHEN .f.
@ 12,150 GET M->ZL_DATA 		SIZE 40,8 WHEN empty(M->ZL_PROPOS)
@ 23,55  GET M->ZL_LICITAN 	SIZE 40,8 F3 "SZP" VALID Descr() WHEN empty(M->ZL_PROPOS)
@ 23,95  GET M->ZL_NOMLIC		SIZE 150,8 WHEN .F.
@ 34,55  GET M->ZL_REPRES   	SIZE 40,8 F3 "SA3" WHEN empty(M->ZL_PROPOS)
@ 34,150 GET M->ZL_PRAZO 		SIZE 40,8 F3 "SE4" WHEN empty(M->ZL_PROPOS)
@ 46,55  GET M->ZL_DIASENT		SIZE 40,8 PICTURE "99" WHEN empty(M->ZL_PROPOS)
@ 46,150 GET M->ZL_DIASVAL 	SIZE 40,8 PICTURE "99" WHEN empty(M->ZL_PROPOS)


aCampos := {"ZM_NUMITEM","ZM_CODPRO ","ZM_DESC   ","ZM_PRCUNI ","ZM_QTDE1  ","ZM_UM1    ","ZM_QTDE2   ","ZM_UM2    ","ZM_COLOC  ","ZM_OBS    " }

aHeader := U_CriaHeader("SZM",aCampos)          
aCols   := U_CriaCols("SZM",2,"ZM_NUMPRO",cNumPro,aHeader)

aCols := Asort(aCols,,,{|x,y|x[1]<y[1]})

nPosCODPRO 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_CODPRO"})
nPosNUMITEM	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_NUMITEM"})
nPosDESC 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_DESC"})
nPosQTDE1 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_QTDE1"})
nPosUM1		:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_UM1"})
nPosQTDE2 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_QTDE2"})
nPosUM2		:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_UM2"})
nPosPRCUNI 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_PRCUNI"})
nPosPRCUN2 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_PRCUN2"})
nPosCOLOC 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_COLOC"})

@ 75,15 TO 175,285 MULTILINE MODIFY DELETE VALID .t.

oGrade2:Activate()

Return(.t.)



Static Function Cancela()

Close(oGrade2)

Return(.t.)


Static Function Confirma()

if !empty(M->ZL_DATA) .and. !empty(M->ZL_LICITAN)

	if MsgYesNo("Confirmar Grade Atual?")
		dbSelectArea("SZL")
		RecLock("SZL",_nOpc==1)
		SZL->ZL_NUMPRO 	:= cNumPro
		SZL->ZL_DATA 		:= M->ZL_DATA
		SZL->ZL_LICITAN	:= M->ZL_LICITAN
		SZL->ZL_REPRES 	:= M->ZL_REPRES
		SZL->ZL_DIASENT	:= M->ZL_DIASENT
		SZL->ZL_DIASVAL 	:= M->ZL_DIASVAL
		SZL->ZL_AUTOR		:= M->ZL_AUTOR
		SZL->ZL_DTDIGIT 	:= M->ZL_DTDIGIT
		SZL->ZL_HRDIGIT 	:= M->ZL_HRDIGIT
		SZL->ZL_STATUS := "4"
		ConfirmSX8()
		MsUnlock()
	
		GravaCols()
	endif
	
	Close(oGrade2)
	
else

	MsgBox("Campos obrigatórios não preenchidos!")
	
endif


Return(.t.)

Static Function Modalidade(cCod)

cRet := " "
do case
	case cCod=="CV"
		cRet := "Carta Convite"
	case cCod=="TP"
		cRet := "Tomada de Precos"
	case cCod=="CP"
		cRet := "Concorrencia Publica"
	case cCod=="CH"
		cRet := "Concorrencia Hospitalar"
	case cCod=="RG"
		cRet := "Registro de Precos"
	case cCod=="CD"
		cRet := "Compra Direta"
endcase		

return(cRet)

Static Function GravaCols()
	dbSelectArea("SZM")
	dbSetOrder(1)
	for i := 1 to len(aCols)
		if aCols[i][len(aHeader)+1]==.t.
			if dbSeek(xFilial("SZM")+cNumPro+aCols[i][2])
				RecLock("SZM",.f.)
				dbDelete()				
				MsUnlock()
			endif
		else
			if dbSeek(xFilial("SZM")+cNumPro+aCols[i][2])
				RecLock("SZM",.f.)
				SZM->ZM_NUMITEM := aCols[i][nPosNUMITEM]
				SZM->ZM_DESC  	:= aCols[i][nPosDESC]
				SZM->ZM_QTDE1  	:= aCols[i][nPosQTDE1]
				SZM->ZM_UM1  	:= U_RetUMSB1(aCols[i][nPosCODPRO],"1")
//				SZM->ZM_QTDE2  	:= U_ConverteUM(aCols[i][nPosCODPRO],aCols[i][nPosQTDE2],"1")
				SZM->ZM_QTDE2  	:= aCols[i][nPosQTDE2]

				SZM->ZM_UM2  	:= U_RetUMSB1(aCols[i][nPosCODPRO],"2")
				SZM->ZM_PRCUNI	:= aCols[i][nPosPRCUNI]
				MsUnlock()
			else
				RecLock("SZM",.t.)
				SZM->ZM_FILIAL	:= xFilial("SZM")
				SZM->ZM_NUMPRO 	:= cNumPro
				SZM->ZM_NUMITEM := aCols[i][nPosNUMITEM]
				SZM->ZM_CODPRO 	:= aCols[i][nPosCODPRO]
				SZM->ZM_DESC  	:= aCols[i][nPosDESC]
				SZM->ZM_QTDE1  	:= aCols[i][nPosQTDE1]
				SZM->ZM_UM1  	:= U_RetUMSB1(aCols[i][nPosCODPRO],"1")
//				SZM->ZM_QTDE2  	:= U_ConverteUM(aCols[i][nPosCODPRO],aCols[i][nPosQTDE2],"1")
				SZM->ZM_QTDE2  	:= aCols[i][nPosQTDE2]
				SZM->ZM_UM2  	:= U_RetUMSB1(aCols[i][nPosCODPRO],"2")
				SZM->ZM_PRCUNI	:= aCols[i][nPosPRCUNI]
				MsUnlock()
			endif
		endif
    next i
return(.t.)

User Function leg001()

LOCAL cCadastro2 := "Grade de Preços"

LOCAL aCores2 := { { 'BR_CINZA'   , "Grade sem Proposta",},;
             { 'BR_VERDE' , "Proposta sem preços"   },;             
             { 'BR_AMARELO', "Proposta c/ preços"   },;             
             { 'BR_AZUL' 	, "Proposta enviada"},;
             { 'BR_VERMELHO' 	, "Proposta finalizada"}}            


BrwLegenda(cCadastro2,"Legenda do Browse",aCores2)

Return()

User Function leg002()

LOCAL cCadastro2 := "Situação da Proposta"

LOCAL aCores2 := {  { 'BR_VERDE' , "Proposta sem preços"   },;            
             { 'BR_AMARELO', "Proposta c/ preços"   },;             
             { 'BR_AZUL' 	, "Proposta enviada"},;
             { 'BR_VERMELHO' 	, "Proposta finalizada"}}            


BrwLegenda(cCadastro2,"Legenda do Browse",aCores2)

Return()

Static Function Descr()

Local _mArea     := {"SZL","SZM","SZN","SZP"}
Local _mAlias    := {}

_mAlias := U_SalvaAmbiente(_mArea)

dbSelectArea("SZP")
dbSetOrder(1)
dbSeek(xFilial("SZP")+M->ZL_LICITAN)

M->ZL_NOMLIC := SZP->ZP_NOMLIC

oGrade2:Refresh()

U_VoltaAmbiente(_mAlias)

Return(.t.)


// *************************************************************************************
// Sugere e seleciona produtos vencedores da proposta de acordo com os preços praticados 
// pela empresa x preços dos concorrentes
// *************************************************************************************

////
User Function Venc()

PRIVATE aHeader, aCols, aCampos, aCpoEnchoice
PRIVATE nPosCODPRO
PRIVATE nPosNUMITEM
PRIVATE nPosDESC 
PRIVATE nPosQTDE 
PRIVATE nPosUM1
PRIVATE nPosPRCUNI 
PRIVATE nPosPRCUN2 
PRIVATE nPosCOLOC 
PRIVATE	cAliasEnchoice	:=	"SZL"
PRIVATE	cAliasGetD		:=	"SZM"
PRIVATE	cLinOk			:=	"Alwaystrue()"
PRIVATE	cTudOk			:=	"Alwaystrue()"
PRIVATE	cFieldOk		:=	"U_ValCmpPV()"
PRIVATE nOpcE := 2
PRIVATE nOpcG := 2
PRIVATE _aSALDO := {}

// inicializa variaveis de memoria da Enchoice (Master)
dbSelectArea("SZL")
RegToMemory("SZL",.f.)

// monta array com campos da enchoice (Master) de acordo com o SX3
aCpoEnchoice := {}
dbSelectArea("SX3")
dbSeek("SZL")
While !Eof().And.(x3_arquivo=="SZL")
	If X3USO(x3_usado) .And.cNivel>=x3_nivel
		Aadd( aCpoEnchoice, x3_campo )
	endif
	dbSkip()
enddo

aCampos := {"ZM_GERAPV  ","ZM_NUMITEM","ZM_CODPRO ","ZM_DESC   ","ZM_QTDE    ", "ZM_SALDO  "}

if SZL->ZL_UMPROP=="1"
	AADD(aCampos,"ZM_QTDE1  ")
	AADD(aCampos,"ZM_UM1    ")
	AADD(aCampos,"ZM_PRCUNI ")
else
	AADD(aCampos,"ZM_QTDE2  ")
	AADD(aCampos,"ZM_UM2    ")
	AADD(aCampos,"ZM_PRCUN2 ")
endif
AADD(aCampos,"ZM_TOTITEM")
AADD(aCampos,"ZM_COLOC  ")

aHeader := U_CriaHeader("SZM",aCampos)
aCols   := U_CriaCols("SZM",2,"ZM_NUMPRO",SZL->ZL_NUMPRO,aHeader)

nPosCODPRO 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_CODPRO"})
nPosNUMITEM	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_NUMITEM"})
nPosDESC 		:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_DESC"})
nPosQTDE 		:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_QTDE"})
nPosQTDE1 		:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_QTDE1"})
nPosUM1		:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_UM1"})
nPosPRCUNI 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_PRCUNI"})
nPosPRCUN2 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_PRCUN2"})
nPosQTDE2 		:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_QTDE2"})
nPosUM2		:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_UM2"})
nPosPRCUN2 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_PRCUN2"})
nPosCOLOC 		:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_COLOC"})
nPosGERAPV 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_GERAPV"})
nPosSALDO  	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_SALDO"})
nPosTOTITEM	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_TOTITEM"})

aCols := Asort(aCols,,,{|x,y|x[nPosDESC]<y[nPosDESC]})

// INICIALIZA CAMPOS SE GERA OU NAO PV COM BASE NO RESULTADO DA GRADE
for _i := 1 to len(aCols)
	nPos := U_VerPos(SZL->ZL_NUMPRO, aCols[_i][nPosCODPRO], GetNewPar("MV_LICONC","000001"))
	if empty(aCols[_i][nPosGERAPV])
		if	nPos == 1
			aCols[_i][nPosGERAPV] := "S"
		else
			aCols[_i][nPosGERAPV] := "N"
		endif
	endif
	
	// Aproveita o loop e inicializa saldos em um array de controle
	AADD(_aSALDO, aCols[_i][nPosSALDO])
	
next _i

_lRet	:=	Modelo3("Geração de Pedido de Venda de Licitação",cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
			   
if _lRet
	GeraPV(aCols)
endif

Return(.t.)


// Gera Pedido de Venda baseado nos itens marcados
Static Function GeraPV(_aHist)

LOCAL _i, _cNumPed
LOCAL _aItemsPV := {}
LOCAL _aCabPV := {}

dbSelectArea("SZP")
dbSetOrder(1)
dbSeek(xFilial("SZP")+SZL->ZL_LICITAN)

if Empty(SZP->ZP_CODCLI)
	MsgBox("Este licitante não tem cadastro como cliente, favor atualizar o cadastro de licitantes para esta Proposta!")
	return(.f.)
endif

if !MsgYesNo("Confirma geração deste Pedido de Venda?")
	return(.f.)
endif

// Verifica se existe pelo menos um item para gerar o PV
_lItens := .f.
for _i := 1 to Len(_aHist)
	if _aHist[_i][nPosGERAPV] == "S" .and. _aHist[_i][nPosQTDE]<>0
		_lItens := .t.
	endif
next _i

if !_lItens
	MsgBox("Não existem itens selecionados para gerar o PV!")
	return(.f.)
endif
	

_cNumPed := GetSXENum("SC5","C5_NUM")


dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SZP->ZP_CODCLI+SZP->ZP_LJCLI)

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3")+SZL->ZL_REPRES)

dbSelectArea("SC5")
dbSetOrder(1)
SC5->(RecLock("SC5",.t.))


SC5->C5_FILIAL		:=	xFilial("SC5")
SC5->C5_NUM			:=	_cNumPed  // Numero do pedido
SC5->C5_TIPOCLI		:= SA1->A1_TIPO// "R"       // Tipo de Cliente
SC5->C5_GERAGNR		:=	"N" 		 // GNR
SC5->C5_LICITAC		:=	"S" 		 // Licitação
SC5->C5_NUMLIC 		:=	SZL->ZL_PROPOS // numero da Licitação
SC5->C5_NUMEMP 		:=	SZL->ZL_NUMEDI // numero da Licitação
SC5->C5_PROMOC		:=	"N" 		 // Promoção
SC5->C5_CLIENTE		:=	SZP->ZP_CODCLI 	// Codigo do cliente
SC5->C5_LOJAENT		:=	SZP->ZP_LJCLI      // Loja para entrega
SC5->C5_LOJACLI		:=	SZP->ZP_LJCLI      // Loja do cliente
SC5->C5_EMISSAO		:=	dDatabase // Data de emissao
SC5->C5_TIPO			:=	"N"       // Tipo de pedido
SC5->C5_TABELA		:=	SZL->ZL_TAB     // Codigo da Tabela de Preco
SC5->C5_CONDPAG		:=	SZL->ZL_PRAZO     // Codigo da condicao de pagamanto*
SC5->C5_DESC1			:=	0         // Percentual de Desconto
SC5->C5_INCISS		:=	"N"       // ISS Incluso
SC5->C5_TIPLIB		:=	"1"       // Tipo de Liberacao
SC5->C5_MOEDA			:=	1         // Moeda
SC5->C5_VEND1			:=	SZL->ZL_REPRES   // VENDEDOR1
SC5->C5_VEND2			:=	SA3->A3_SUPER    // VENDEDOR2
SC5->C5_VEND3			:=	SA3->A3_GEREN    // VENDEDOR3
SC5->C5_COMIS1		:=	SZL->ZL_COMIS1   // VENDEDOR1
SC5->C5_COMIS2    	:=	SZL->ZL_COMIS2    // VENDEDOR2
SC5->C5_COMIS3	   	:=	SZL->ZL_COMIS3    // VENDEDOR3
SC5->C5_TRANSP	   	:=	SA1->A1_TRANSP    // TRANSPORTADORA CLIENTE

SC5->(MsUnlock())

ConfirmSX8()

for _i := 1 to Len(_aHist)

	if _aHist[_i][nPosGERAPV] == "S" .and. _aHist[_i][nPosQTDE]<>0
		dbSelectArea("SZM")
		dbSetOrder(1)
		if dbSeek(xFilial("SZM")+SZL->ZL_NUMPRO+_aHist[_i][nPosCODPRO]) // localiza o item pelo codigo do produto
		
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+_aHist[_i][nPosCODPRO]) // Posiciona o produto
		
			_cTES := if(sb1->b1_categ="N",sa1->a1_tesneg,sa1->a1_tespos)
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4")+_cTES)
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			SC6->(RecLock("SC6",.t.))
			SC6->C6_FILIAL := xFilial("SC6")
			SC6->C6_NUM 		:= _cNumped          // Numero do Pedido
			SC6->C6_ITEM 		:= strzero(_i,2)     // Numero do Item no Pedido
			SC6->C6_PRODUTO 	:= SZM->ZM_CODPRO    // Codigo do Produto
			SC6->C6_DESCRI    := SZM->ZM_DESC      // Descricao do Produto
			if SZL->ZL_UMPROP == "2"   
			   _mqtde1 := U_Conv2To1(_aHist[_i][nPosCODPRO],_aHist[_i][nPosQTDE])
				SC6->C6_QTDVEN 	:= U_Conv2To1(_aHist[_i][nPosCODPRO],_aHist[_i][nPosQTDE]) // Quantidade Vendida
	   			SC6->C6_PRUNIT 	:= round((_aHist[_i][nPosQTDE]* SZM->ZM_PRCUN2)/_mqtde1,2)//SZM->ZM_PRCUNI //round((SZM->ZM_PRCUNI * SZM->ZM_QTDE2) / SZM->ZM_QTDE1,6) // PRECO DE LISTA
   				SC6->C6_PRCVEN 	:= round((_aHist[_i][nPosQTDE]* SZM->ZM_PRCUN2)/_mqtde1,2)//SZM->ZM_PRCUNI //round((SZM->ZM_PRCUNI * SZM->ZM_QTDE2) / SZM->ZM_QTDE1,6) // Preco Unitario Liquido
				SC6->C6_VALOR 		:= round(_aHist[_i][nPosQTDE]* SZM->ZM_PRCUN2,2) //round(SC6->C6_PRCVEN * _aHist[_i][nPosQTDE],2) // Valor Total do Item
				SC6->C6_UNSVEN  	:= round(_aHist[_i][nPosQTDE],2)//U_Conv1To2(_aHist[_i][nPosCODPRO],_aHist[_i][nPosQTDE])     // Qtde Segunda UM

			else
				SC6->C6_QTDVEN 	:= _aHist[_i][nPosQTDE]  // Quantidade Vendida
	   			SC6->C6_PRUNIT 	:= SZM->ZM_PRCUNI   // PRECO DE LISTA
   				SC6->C6_PRCVEN 	:= SZM->ZM_PRCUNI   // Preco Unitario Liquido		
				SC6->C6_VALOR 	 	:= SC6->C6_QTDVEN * SZM->ZM_PRCUNI // Valor Total do Item
				SC6->C6_UNSVEN  	:= U_Conv1To2(_aHist[_i][nPosCODPRO],_aHist[_i][nPosQTDE]) //U_Conv1To2(_aHist[_i][nPosCODPRO],_aHist[_i][nPosQTDE])     // Qtde Segunda UM
			endif
			SC6->C6_ENTREG 	:= dDataBase + SZL->ZL_DIASENT // Data da Entrega
			SC6->C6_UM 			:= SZM->ZM_UM1       // Unidade de Medida Primar.
			SC6->C6_PRSEGUM   	:= SZM->ZM_PRCUN2 //round(SC6->C6_VALOR / SC6->C6_UNSVEN,6) // Preço na segunda Unidade de Medida
			SC6->C6_SEGUM     	:= SZM->ZM_UM2       // Segunda UM
			SC6->C6_TES 		:= _cTES // Tipo de Entrada/Saida do Item
			SC6->C6_LOCAL 		:= sb1->b1_locpad     // Almoxarifado
			SC6->C6_CF        	:= SF4->F4_CF           // Cod.Classificacao Fiscal
			SC6->C6_DESCONT 	:= 0                 // Percentual de Desconto
			SC6->C6_COMIS1 		:= 0                 // Comissao Vendedor
			SC6->C6_CLI 		:= SZP->ZP_CODCLI    // Cliente
			SC6->C6_LOJA 		:= SZP->ZP_LJCLI     // Loja do Cliente
			SC6->(MsUnlock())
			dbSelectArea("SZM")
			dbSetOrder(1)
			SZM->(Reclock("SZM",.f.))
			SZM->ZM_GERAPV 	:= _aHist[_i][nPosGERAPV]
			SZM->ZM_QTDE 	:= _aHist[_i][nPosQTDE]
			SZM->ZM_SALDO	:= _aHist[_i][nPosSALDO]
			SZM->(MsUnlock())
		endif
   endif
next _i              

MsgBox("Pedido No."+_cNumped+" gerado!")


return(.t.)


User Function ValCmpPV()

LOCAL _lRet := .t.

if alltrim(__READVAR)=="M->ZM_QTDE" .and. !Empty(M->ZM_QTDE)

   aCols[n][nPosSALDO] 	:=  M->ZM_QTDE
	
	if aCols[n][nPosSALDO] < 0
		MsgBox("Quantidade Invalida!")
		return(.f.)
	endif
	if SZL->ZL_UMPROP=="1"
		aCols[n][nPosTOTITEM] 	:= M->ZM_QTDE * aCols[n][nPosPRCUNI]
	else
		aCols[n][nPosTOTITEM] 	:= M->ZM_QTDE * aCols[n][nPosPRCUN2]
	endif
endif
return(_lRet)

// Função para trocar sinal X do LISTABOX
Static Function AOperTroca(nIt,aArray)
	aArray[nIt,1] := !aArray[nIt,1]
Return aArray

// Gera Pedido de Venda baseado nos itens marcados
User Function GeraPV(_aHist)

LOCAL _i, _cNumPed
LOCAL _aItemsPV := {}
LOCAL _aCabPV := {}

if Empty(SZP->ZP_CODCLI)
	MsgBox("Este licitante não tem cadastro como cliente, favor atualizar o cadastro de licitantes para esta Proposta!")
	return(.f.)
endif

if !MsgYesNo("Confirma geração deste Pedido de Venda?")
	return(.f.)
endif

_cNumPed := GetSXENum("SC5","C5_NUM")

dbSelectArea("SZP")
dbSetOrder(1)
dbSeek(xFilial("SZP")+SZL->ZL_LICITAN)

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SZP->ZP_CODCLI+SZP->ZP_LJCLI)

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3")+SZL->ZL_REPRES)

dbSelectArea("SC5")
dbSetOrder(1)
SC5->(RecLock("SC5",.t.))


SC5->C5_FILIAL		:=	xFilial("SC5")
SC5->C5_NUM			:=	_cNumPed  // Numero do pedido
SC5->C5_TIPOCLI		:=	"R"       // Tipo de Cliente
SC5->C5_GERAGNR		:=	"N" 		 // GNR
SC5->C5_LICITAC		:=	"S" 		 // Licitação
SC5->C5_NUMLIC 		:=	SZL->ZL_PROPOS // numero da Licitação
SC5->C5_NUMEMP 		:=	SZL->ZL_NUMEDI // numero da Licitação
SC5->C5_PROMOC		:=	"N" 		 // Promoção
SC5->C5_CLIENTE		:=	SZP->ZP_CODCLI 	// Codigo do cliente
SC5->C5_LOJAENT		:=	SZP->ZP_LJCLI      // Loja para entrega
SC5->C5_LOJACLI		:=	SZP->ZP_LJCLI      // Loja do cliente
SC5->C5_EMISSAO		:=	dDatabase // Data de emissao
SC5->C5_TIPO			:=	"N"       // Tipo de pedido
SC5->C5_TABELA		:=	SZL->ZL_TAB     // Codigo da Tabela de Preco
SC5->C5_CONDPAG		:=	SZL->ZL_PRAZO     // Codigo da condicao de pagamanto*
SC5->C5_DESC1			:=	0         // Percentual de Desconto
SC5->C5_INCISS		:=	"N"       // ISS Incluso
SC5->C5_TIPLIB		:=	"1"       // Tipo de Liberacao
SC5->C5_MOEDA			:=	1         // Moeda
SC5->C5_VEND1			:=	SZL->ZL_REPRES   // VENDEDOR1
SC5->C5_VEND2			:=	SA3->A3_SUPER    // VENDEDOR2
SC5->C5_VEND3			:=	SA3->A3_GEREN    // VENDEDOR3
SC5->C5_COMIS1		:=	SZL->ZL_COMIS1   // VENDEDOR1
SC5->C5_COMIS2    	:=	SZL->ZL_COMIS2    // VENDEDOR2
SC5->C5_COMIS3	   	:=	SZL->ZL_COMIS3    // VENDEDOR3
SC5->C5_TRANSP	   	:=	SA1->A1_TRANSP    // TRANSPORTADORA CLIENTE

SC5->(MsUnlock())

ConfirmSX8()

for _i := 1 to Len(_aHist)

	if _aHist[_i][nPosGERAPV] == "S" .and. _aHist[_i][nPosQTDE]<>0
                                                                                                                                                                                                                                                                                                                                                                                             		
                                                                                                                                                                                                                                                                                                                                                                                             		
                                                                                                                                                                                                                                                                                                                                                                                             		
		dbSetOrder(1)
		if dbSeek(xFilial("SZM")+SZL->ZL_NUMPRO+_aHist[_i][nPosCODPRO]) // localiza o item pelo codigo do produto
		
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+_aHist[_i][nPosCODPRO]) // Posiciona o produto
		
			_cTES := if(sb1->b1_categ="N",sa1->a1_tesneg,sa1->a1_tespos)
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4")+_cTES)
			
			dbSelectArea("SC6")
			dbSetOrder(1)
			SC6->(RecLock("SC6",.t.))

			SC6->C6_FILIAL := xFilial("SC6")

			SC6->C6_NUM 		:= _cNumped          // Numero do Pedido
			SC6->C6_ITEM 		:= strzero(_i,2)     // Numero do Item no Pedido
			SC6->C6_PRODUTO 	:= SZM->ZM_CODPRO    // Codigo do Produto
			SC6->C6_DESCRI    := SZM->ZM_DESC      // Descricao do Produto
			msgstop(_aHist[_i][nPosQTDE])
			if SZL->ZL_UMPROP == "2" 	
				SC6->C6_QTDVEN 	:= _aHist[_i][nPosQTDE]  // Quantidade Vendida

	 			SC6->C6_PRUNIT := round((SZM->ZM_PRCUNI * SZM->ZM_QTDE2) / SZM->ZM_QTDE1,6) // PRECO DE LISTA
 				SC6->C6_PRCVEN := round((SZM->ZM_PRCUNI * SZM->ZM_QTDE2) / SZM->ZM_QTDE1,6) // Preco Unitario Liquido			
         		SC6->C6_VALOR 	:= round(SC6->C6_PRCVEN * _aHist[_i][nPosQTDE],2) // Valor Total do Item
				SC6->C6_VALOR 	:= round(SC6->C6_PRCVEN * _aHist[_i][nPosQTDE],2) // Valor Total do Item
			else
	   			SC6->C6_PRUNIT := SZM->ZM_PRCUNI   // PRECO DE LISTA
   				SC6->C6_PRCVEN := SZM->ZM_PRCUNI   // Preco Unitario Liquido		
				SC6->C6_VALOR 	:= _aHist[_i][nPosQTDE] * SZM->ZM_PRCUNI // Valor Total do Item
			endif
			SC6->C6_ENTREG 	:= dDataBase + SZL->ZL_DIASENT // Data da Entrega
			SC6->C6_UM 			:= SZM->ZM_UM1       // Unidade de Medida Primar.
			_nFatRed := _aHist[_i][nPosQTDE] / SZM->ZM_QTDE1
			SC6->C6_UNSVEN    := round(SZM->ZM_QTDE2 * _nFatRed,0) //U_Conv1To2(_aHist[_i][nPosCODPRO],_aHist[_i][nPosQTDE])     // Qtde Segunda UM
			SC6->C6_PRSEGUM   := round(SC6->C6_VALOR / SC6->C6_UNSVEN,6) // Preço na segunda Unidade de Medida
			SC6->C6_SEGUM     := SZM->ZM_UM2       // Segunda UM
			SC6->C6_TES 		:= _cTES // Tipo de Entrada/Saida do Item
			SC6->C6_LOCAL 		:= sb1->b1_locpad     // Almoxarifado
			SC6->C6_CF        := SF4->F4_CF           // Cod.Classificacao Fiscal
			SC6->C6_DESCONT 	:= 0                 // Percentual de Desconto
			SC6->C6_COMIS1 	:= 0                 // Comissao Vendedor
			SC6->C6_CLI 		:= SZP->ZP_CODCLI    // Cliente
			SC6->C6_LOJA 		:= SZP->ZP_LJCLI     // Loja do Cliente
		
			SC6->(MsUnlock())
			
			dbSelectArea("SZM")
			dbSetOrder(1)
			_nSaldo := _aHist[_i][nPosSALDO] - _aHist[_i][nPosQTDE]
			SZM->(Reclock("SZM",.f.))
			SZM->ZM_GERAPV := _aHist[_i][nPosGERAPV]
			SZM->ZM_QTDE 	:= iif( _nSaldo > 0, _nSaldo , 0)
			SZM->ZM_SALDO	:= _nSaldo
			SZM->(MsUnlock())
			
		endif

   endif
next _i              

/*dbSelectArea("SZL")
SZL->(Reclock("SZL",.f.))
SZL->ZL_PEDIDO := _cNumped
SZL->(MsUnlock())*/

MsgBox("Pedido No."+_cNumped+" gerado!")

Close(oDlg2)

return(.t.)

Static Function LineOk()

if Empty(aCols[n][1]) .and. !aCols[n][len(aHeader)+1]
	lret := .f.
else
	lret := .t.
endif       

return(lret)
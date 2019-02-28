#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

Static cX5RETCP		:= ""

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ Estrut2  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 04/02/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Faz a explosao de uma estrutura a partir do SG1            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ Estrut(ExpC1,ExpN1,ExpC2,ExpC3)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade a ser explodida                         ³±±
±±³          ³ ExpC2 = Alias do arquivo de trabalho                       ³±±
±±³          ³ ExpC3 = Nome do arquivo criado                             ³±±
±±³          ³ ExpL1 = Monta a Estrutura exatamente como se ve na tela    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observa‡„o³ Como e uma funcao recursiva precisa ser criada uma variavel³±±
±±³          ³ private nEstru com valor 0 antes da chamada da fun‡„o.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function Estrut2(cProduto,nQuant,cAliasEstru,cArqTrab,lAsShow,lPreEstru)
LOCAL nRegi:=0,nQuantItem:=0
LOCAL aCampos:={},aTamSX3:={},lAdd:=.F.
LOCAL nRecno
LOCAL cCodigo,cComponente,cTrt,cGrOpc,cOpc
DEFAULT lPreEstru := .F.
cAliasEstru:=IF(cAliasEstru == NIL,"ESTRUT",cAliasEstru)
nQuant:=IF(nQuant == NIL,1,nQuant)
lAsShow:=IF(lAsShow==NIL,.F.,lAsShow)

cAliasOri := If(lPreEstru,"SGG","SG1")

nEstru++
If nEstru == 1
	// Cria arquivo de Trabalho
	AADD(aCampos,{"NIVEL","C",6,0})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_COD","G1_COD"))
	AADD(aCampos,{"CODIGO","C",aTamSX3[1],0})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_COMP","G1_COMP"))
	AADD(aCampos,{"COMP","C",aTamSX3[1],0})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_QUANT","G1_QUANT"))
	AADD(aCampos,{"QUANT","N",Max(aTamSX3[1],18),aTamSX3[2]})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_TRT","G1_TRT"))
	AADD(aCampos,{"TRT","C",aTamSX3[1],0})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_GROPC","G1_GROPC"))
	AADD(aCampos,{"GROPC","C",aTamSX3[1],0})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_OPC","G1_OPC"))
	AADD(aCampos,{"OPC","C",aTamSX3[1],0})
	aTamSX3:=TamSX3(If(lPreEstru,"GG_POTENCI","G1_POTENCI"))
	AADD(aCampos,{"POTENCI","N",aTamSX3[1],aTamSX3[2]})
	aTamSX3:=TamSX3("B1_UM")
	AADD(aCampos,{"UM","C",aTamSX3[1],aTamSX3[2]})
	aTamSX3:=TamSX3("B1_DESC")
	AADD(aCampos,{"DESC","C",aTamSX3[1],aTamSX3[2]})
	aTamSX3:=TamSX3("G5_REVISAO")
	AADD(aCampos,{"REVISAO","C",aTamSX3[1],0})
	AADD(aCampos,{"DT_REVI","C",10,0})
	AADD(aCampos,{"DT_VALID","C",10,0})
	AADD(aCampos,{"CLASSE","C",01,0})
	// NUMERO DO REGISTRO ORIGINAL
	AADD(aCampos,{"REGISTRO","N",14,0})
	cArqTrab := CriaTrab(aCampos)
	If Select(cAliasEstru) > 0
		dbSelectArea(cAliasEstru)
		dbCloseArea()
	EndIf
	Use &cArqTrab NEW Exclusive Alias &(cAliasEstru)
	IndRegua(cAliasEstru,cArqTrab,"NIVEL+CODIGO+COMP+TRT",,,"Selecionando Registros...")
	dbSetIndex(cArqtrab+OrdBagExt())
EndIf

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SG5")
dbSetOrder(1)

dbSelectArea(cAliasOri)
dbSetOrder(1)
if dbSeek(xFilial()+cProduto)
	cRevisao := "000"
	cDTRevi  := ""
	If u_SG5(XFilial("SG5")+cProduto)
		cRevisao := SG5->G5_REVISAO
		cDTRevi  := DtoC(SG5->G5_DATAREV)
		cDTValid := DtoC(SG5->G5_DATAREV)
	EndIF

	dbSelectArea(cAliasOri)
	While !Eof() .And. AllTrim(If(lPreEstru,GG_FILIAL+GG_COD,G1_FILIAL+G1_COD)) == AllTrim(xFilial()+cProduto)
		nRegi		:= Recno()
		cCodigo     := If(lPreEstru,GG_COD,G1_COD)
		cComponente := If(lPreEstru,GG_COMP,G1_COMP)
		cTrt        := If(lPreEstru,GG_TRT,G1_TRT)
		cGrOpc      := If(lPreEstru,GG_GROPC,G1_GROPC)
		cOpc        := If(lPreEstru,GG_OPC,G1_OPC)
		nPotenci    := If(lPreEstru,GG_POTENCI,G1_POTENCI)
		cClasse     := If(lPreEstru," ",G1_CLASSE)
		cDTValid 	:= DtoC(If(lPreEstru,GG_FIM,G1_FIM))
		If cCodigo != cComponente
			SB1->(dbSeek(XFilial("SB1")+cComponente))
			lAdd:=.F.
			If !(&(cAliasEstru)->(dbSeek(StrZero(nEstru,6)+cCodigo+cComponente+cTrt))) .Or. (lAsShow)
				nQuantItem:=u_ExplEstr(nQuant,nil,nil,nil,nil,lPreEstru)
				RecLock(cAliasEstru,.T.)
				Replace NIVEL    With StrZero(nEstru,6)
				Replace CODIGO   With cCodigo
				Replace COMP     With cComponente
				Replace QUANT    With nQuantItem
				Replace TRT      With cTrt
				Replace GROPC    With cGrOpc
				Replace OPC      With cOpc
				Replace POTENCI  With nPotenci
				Replace CLASSE   With cClasse
				Replace UM  	 With SB1->B1_UM
				Replace DESC  	 With SB1->B1_DESC
				Replace REVISAO	 With cRevisao
				Replace DT_REVI	 With cDTRevi
				Replace DT_VALID With cDTValid
				Replace REGISTRO With If(lPreEstru,SGG->(Recno()),SG1->(Recno()))
				MsUnlock()
				lAdd:=.T.
				dbSelectArea(cAliasOri)
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe sub-estrutura                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nRecno:=Recno()
			IF dbSeek(xFilial()+cComponente)
				cCodigo:=If(lPreEstru,GG_COD,G1_COD)
				Estrut2(cCodigo,nQuantItem,cAliasEstru,cArqTrab,lAsShow,lPreEstru)
				nEstru --
			Else
				cRevisao := "000"
				cDTRevi  := ""
				cDTValid := ""
                If U_SG5(XFilial("SG5")+cComponente)
					cRevisao := SG5->G5_REVISAO
					cDTRevi  := DtoC(SG5->G5_DATAREV)
					cDTValid := DtoC(SG5->G5_DATAREV)
                EndIf
				(cAliasOri)->(dbGoto(nRecno))
				If !(&(cAliasEstru)->(dbSeek(StrZero(nEstru,6)+cCodigo+cComponente+cTrt))) .Or. (lAsShow.And.!lAdd)
					SB1->(dbSeek(XFilial("SB1")+cComponente))
					nQuantItem:=u_ExplEstr(nQuant,nil,nil,nil,nil,lPreEstru)
					RecLock(cAliasEstru,.T.)
					Replace NIVEL    With StrZero(nEstru,6)
					Replace CODIGO   With cCodigo
					Replace COMP     With cComponente
					Replace QUANT    With nQuantItem
					Replace TRT      With cTrt
					Replace GROPC    With cGrOpc
					Replace OPC      With cOpc
					Replace POTENCI  With nPotenci
					Replace CLASSE   With cClasse
					Replace UM  	 With SB1->B1_UM
					Replace DESC  	 With SB1->B1_DESC
					Replace REVISAO	 With cRevisao
					Replace DT_REVI	 With cDTRevi
					Replace DT_VALID With cDTValid
					Replace REGISTRO With If(lPreEstru,SGG->(Recno()),SG1->(Recno()))
					MsUnlock()
					dbSelectArea(cAliasOri)
				EndIf
			Endif
		EndIf
		dbGoto(nRegi)
		dbSkip()
	Enddo
endif
Return cArqTrab

User Function SG5(pFil_Cod)
Local lRet := .f.

	If ( lRet := SG5->(dbSeek(pFil_Cod)) )
		While SG5->(!Eof() .And. AllTrim(G5_FILIAL+G5_PRODUTO) == AllTrim(pFil_Cod))
			SG5->(dbSkip())
		EndDo
		SG5->(dbSkip(-1))
	EndIf

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ExplEstr ³ Autor ³ Eveli Morasco         ³ Data ³ 20/08/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula a quantidade usada de um componente da estrutura   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1 := ExplEstr(ExpN2,ExpD1,ExpC1,ExpC2)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade utilizada pelo componente               ³±±
±±³          ³ ExpD1 = Data para validacao do componente na estrutura     ³±±
±±³          ³ ExpC1 = String contendo os opcionais utilizados            ³±±
±±³          ³ ExpC2 = Revisao da estrutura utilizada                     ³±±
±±³          ³ ExpN2 = Variavel com valor numerico que justifica o motivo ³±±
±±³          ³         pelo qual a quantidade esta zerada.                ³±±
±±³          ³         1 - Componente fora das datas inicio / fim         ³±±
±±³          ³         2 - Componente fora dos grupos de opcionais        ³±±
±±³          ³         3 - Componente fora das revisoes                   ³±±
±±³          ³ ExpL1 = Indica se processa preestrutura                    ³±±
±±³          ³ ExpL2 = Indica se processa o tipo de decimais da OP        ³±±
±±³          ³ ExpC3 = Alias da tabela SG1                                ³±±
±±³          ³ ExpC4 = Alias da tabela SB1                                ³±±
±±³          ³ ExpL3 = Indica de foi chamado do MRP                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ExplEstr(nQuant,dDataStru,cOpcionais,cRevisao,nMotivo,lPreEstr,lTipoDec,cAliasSG1,cAliasSB1,lMRP)
LOCAL nQuantItem:=0,cUnidMod,nG1Quant:=0,nQBase:=0,nDecimal:=0,nBack:=0
LOCAL cAlias:=Alias(),nRecno:=Recno(),nOrder:=IndexOrd()
LOCAL lOk:=.T.
LOCAL nDecOrig:=Set(3,8)
LOCAL cCodigo
LOCAL cComponente
LOCAL cOpcArq
LOCAL dDataIni
LOCAL dDataFim
LOCAL nQtdCampo
LOCAL nQtdPerda
LOCAL cFixVar
LOCAL cTRT
LOCAL aVldEstr := {.T.,.T.,.T.} //na ordem, indica se valida datas, grupo de opc. e revisoes na estrutura
LOCAL aUsrVlEstr := {}
LOCAL nI := 0
LOCAL nAltPer := 0
LOCAL lAchouB1 := .F.

STATIC lUSRVLESTR := ExistBlock("USRVLESTR")
STATIC lMQTBASEST := ExistBlock('MQTBASEST')
STATIC lMQTDESTR  := ExistBlock('MQTDESTR')
STATIC nDecSGG    := TamSX3("GG_QUANT")[2]
STATIC nDecSG1    := TamSX3("G1_QUANT")[2]
STATIC lTemQBP    := TemQBP()

DEFAULT nMotivo	:= 0
DEFAULT lPreEstr	:= .F.
DEFAULT lTipoDec	:= .T.
DEFAULT cAliasSG1	:= "SG1"
DEFAULT cAliasSB1	:= "SB1"
DEFAULT lMRP		:= .F.

cCodigo    :=If(lPreEstr,SGG->GG_COD,(cAliasSG1)->G1_COD)
cComponente:=If(lPreEstr,SGG->GG_COMP,(cAliasSG1)->G1_COMP)
cOpcArq    :=If(lPreEstr,SGG->GG_GROPC+SGG->GG_OPC,(cAliasSG1)->G1_GROPC+(cAliasSG1)->G1_OPC)
nG1Quant   :=If(lPreEstr,SGG->GG_QUANT,(cAliasSG1)->G1_QUANT)
nQtdCampo  :=If(lPreEstr,SGG->GG_QUANT,(cAliasSG1)->G1_QUANT)
nQtdPerda  :=If(lPreEstr,SGG->GG_PERDA,(cAliasSG1)->G1_PERDA)
cFixVar    :=If(lPreEstr,SGG->GG_FIXVAR,(cAliasSG1)->G1_FIXVAR)
cTRT       :=If(lPreEstr,SGG->GG_TRT,(cAliasSG1)->G1_TRT)

If lMRP
	dDataIni   :=If(lPreEstr,SGG->GG_INI,Stod((cAliasSG1)->G1_INI))
	dDataFim   :=If(lPreEstr,SGG->GG_FIM,Stod((cAliasSG1)->G1_FIM))
Else
	dDataIni   :=If(lPreEstr,SGG->GG_INI,(cAliasSG1)->G1_INI)
	dDataFim   :=If(lPreEstr,SGG->GG_FIM,(cAliasSG1)->G1_FIM)
EndIf

If lPreEstr
	nDecimal:=nDecSGG
Else
	nDecimal:=nDecSG1
EndIf

//Verifica os opcionais cadastrados na Estrutura
cOpcionais:= If((cOpcionais == NIL),"",cOpcionais)

//Verifica a Revisao Atual do Componente
cRevisao:= If((cRevisao == NIL),"",cRevisao)

//Verifica a data de validade
dDataStru := If((dDataStru == NIL),dDataBase,dDataStru)

If lUSRVLESTR
	//Posiciona na SG1 para PE
	If lMRP
		dbSelectArea("SG1")
		MsSeek(xFilial("SG1")+cCodigo)
	EndIf

	aUsrVlEstr := ExecBlock("USRVLESTR",.F.,.F.,{cCodigo,cComponente,cTRT})

	For nI := 1 To 3
		If ValType(aUsrVlEstr[nI]) == "L"
			aVldEstr[nI] := aUsrVlEstr[nI]
		EndIf
	Next nI
EndIf

If lMRP
	lAchouB1 := .T.
Else
	dbSelectArea("SB1")
	dbSetOrder(1)
	lAchouB1 := MsSeek(xFilial("SB1")+cCodigo)
EndIf

If lAchouB1
	If Empty(cOpcionais) .And. !Empty(RetFldProd((cAliasSB1)->B1_COD,"B1_OPC",cAliasSB1))
		cOpcionais:=RetFldProd((cAliasSB1)->B1_COD,"B1_OPC",cAliasSB1)
	EndIf
	If Empty(cRevisao) .And. !Empty((cAliasSB1)->B1_REVATU)
		cRevisao:=(cAliasSB1)->B1_REVATU
	EndIf
	If aVldEstr[1] .And. !(dDataStru >= dDataIni .And. dDataStru <= dDataFim)
		nMotivo:=1 // Componente fora das datas inicio / fim
		lOk:=.F.
	EndIf
	If aVldEstr[2] .And. lOk .And. !Empty(cOpcionais) .And. !Empty(cOpcArq) .And. !(cOpcArq $ cOpcionais)
		nMotivo:=2  // Componente fora dos grupos de opcionais
		lOk:=.F.
	EndIf
	If aVldEstr[3] .And. lOk .And. !lPreEstr .And. !Empty(cRevisao) .And. ((cAliasSG1)->G1_REVINI > cRevisao .Or. (cAliasSG1)->G1_REVFIM < cRevisao)
		nMotivo:=3	// Componente fora das revisoes
		lOk:=.F.
	EndIf
EndIf

If !lMRP
	dbSelectArea(cAlias)
	dbSetOrder(nOrder)
	MsGoto(nRecno)
EndIf

If lOk
	cUnidMod := SuperGetMv("MV_UNIDMOD")
	If !lMRP
		SB1->(MsSeek(xFilial("SB1")+cCodigo))
	EndIf
	nQBase:=RetFldProd((cAliasSB1)->B1_COD,If(lPreEstr.And.lTemQBP,"B1_QBP","B1_QB"),cAliasSB1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada p/ alterar qtde. base da estrutura    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMQTBASEST
		nAltPer:=ExecBlock('MQTBASEST', .F., .F., {nQBase})
		IF Valtype(nAltPer) == 'N'
			nQBase := nAltPer
		EndIf
	EndIf

	If !lMRP
		SB1->(MsSeek(xFilial("SB1")+cComponente))
	EndIf

	If IsProdMod(cComponente)
		cTpHr := SuperGetMv("MV_TPHR")
		If cTpHr == "N"
			nG1Quant := Int(nG1Quant)
			nG1Quant += ((nQtdCampo-nG1Quant)/60)*100
		EndIf
	EndIf

	If cFixVar $ " V"
		If IsProdMod(cComponente) .And. cUnidMOD != "H"
			nQuantItem := ((nQuant / nG1Quant) / (100 - nQtdPerda)) * 100
		Else
			nQuantItem := ((nQuant * nG1Quant) / (100 - nQtdPerda)) * 100
		EndIf
		nQuantItem := nQuantItem / Iif(nQBase <= 0,1,nQBase)
	Else
		If IsProdMod(cComponente) .And. cUnidMOD != "H"
			nQuantItem := (nG1Quant / (100 - nQtdPerda)) * 100
		Else
			nQuantItem := (nG1Quant / (100 - nQtdPerda)) * 100
		EndIf
	Endif
	nQuantItem:=Round(nQuantitem,nDecimal)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada p/ alterar qtde. do componente        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMQTDESTR
	nAltPer:=ExecBlock('MQTDESTR', .F., .F., {nQuant})
	If Valtype (nAltPer) == 'N'
		nQuantItem:= nAltPer
	EndIf
EndIf

//vai ser calculado no proprio MATA712
If !lMRP
	Do Case
		Case (SB1->B1_TIPODEC == "A" .And. lTipoDec)
			nBack := Round( nQuantItem,0 )
		Case (SB1->B1_TIPODEC == "I" .And. lTipoDec)
			nBack := Int(nQuantItem)+If(((nQuantItem-Int(nQuantItem)) > 0),1,0)
		Case (SB1->B1_TIPODEC == "T" .And. lTipoDec)
			nBack := Int( nQuantItem )
		OtherWise
			nBack := nQuantItem
	EndCase
Else
	nBack := nQuantItem
EndIf

Set(3,nDecOrig)

Return( nBack )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³TemQBP     ³Autor ³Norberto M de Melo       ³Data  ³ 08/05/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Esta função tem como objetivo validar a existência da coluna ³±±
±±³          ³ SB1->B1_QBP                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T. ou .F.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGACUSA.PRX                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function TemQBP( )
Local lSB1ToClose	:= ( Select( 'SB1' ) > 0 )
Local lRet				:= ( FieldPos( "B1_QBP" ) > 0 )
//Local lRet				:= ( SB1->(FieldPos( "B1_QBP" )) > 0 )

// Restabelece a situação da tabela SB1
//If ( Select('SB1') > 0 ) //.and. lSB1ToClose
If lSB1ToClose
	SB1->(dbCloseArea( ))
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CountRegs º Autor ³ Henrique Aires    º Data ³  20/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao criar e contar número de registros da query.        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CountRegs(pQuery,pAlias,pCntRegs)
Local nRetRegs	:= 0

Default pCntRegs	:= .T.

If Select(pAlias) == 0
	TcQuery pQuery New Alias (pAlias)
Endif

If pCntRegs
	(pAlias)->( dbEval( {|| nRetRegs++},,{ || !Eof()} ))
	(pAlias)->( dbGoTop() )
Endif

Return(nRetRegs)

 /*

   *| Objetivo: Obter a diferenca em hora entre um periodo
   *|
   *|
   *| Retorno.: Array com 5 elementos
   *| Conteudo: 1o elemento: total da contagem no formato HH:MM:SS
   *|           2o elemento: total de ano(s)
   *|           3o elemento: total de mes(s)
   *|           4o elemento: total de dia(s)
   *|           5o elemento: total de horas restantes

*/

User Function UPeriodo(cHorI,cHorF,dDatI,dDatF)
   Local nDias		:= 0
   Local rHoras		:= 0
   Local rPeriodo	:= 0

   if dDatF>dDatI
   		nDias=dDatF-dDatI
   endif

   // se nDias for 0 faz a diferenca de horas
   if nDias=0

      if cHorI="00:00:00" .and. cHorF="24:00:00"
         rHoras:="24:00:00"
      else
         rHoras:=Elaptime(cHorI,cHorF)
      endif

   else //if nDias=1

      if cHorI="00:00:00".and.cHorF="24:00:00"
         // *--equivale a um dia
         rPeriodo=86400
           nDias+=1
      else
         //rPeriodo=TIMETOSEC(Elaptime(cHorI,"24:00:00"))+TIMETOSEC(Elaptime("00:00:00",cHorF))
         rPeriodo=HH2SS(Elaptime(cHorI,"24:00:00"))+HH2SS(Elaptime("00:00:00",cHorF))
      endif

      if rPeriodo<86400.and.cHorF="24:00:00"

         rPeriodo+=86400

      elseif rPeriodo=0.and.cHorI="00:00:00".and.cHorF="00:00:00"

         rPeriodo+=nDias*86400

      elseif rPeriodo<86400

         if nDias>1

            rPeriodo+=(nDias-1)*86400

            if cHorI!="00:00:00"
               nDias--
            endif

         else

            if cHorI="00:00:00".or.cHorI="24:00:00"

               rPeriodo+=86400

            endif

         endif

      endif

      if rPeriodo>=86400

         //rHoras=alltrim(str(nDias*24+val(substr(SECTOTIME(rPeriodo%86400),1,2))))+":"+substr(SECTOTIME(rPeriodo%86400),4)
         rHoras=alltrim(str(nDias*24+val(substr(SS2HH(rPeriodo%86400),1,2))))+":"+substr(SS2HH(rPeriodo%86400),4)

      else

         if rPeriodo<0

            //rHoras=alltrim(str(nDias*24-val(substr(SECTOTIME(-1*rPeriodo),1,2))))+":"+substr(SECTOTIME(-1*rPeriodo),4)
            rHoras=alltrim(str(nDias*24-val(substr(SS2HH(-1*rPeriodo),1,2))))+":"+substr(SS2HH(-1*rPeriodo),4)
         else
         //rHoras:=SECTOTIME(TIMETOSEC(Elaptime(cHorI,"24:00:00"))+TIMETOSEC(Elaptime("00:00:00",cHorF)))
         rHoras:=SS2HH(HH2SS(Elaptime(cHorI,"24:00:00"))+HH2SS(Elaptime("00:00:00",cHorF)))
         endif

      endif

   endif

   // criacao dos itens de cada elemento do array
   nTotdias=int(val(substr(rHoras,1,at(":",rHoras)-1)))
   nDias=int(val(substr(rHoras,1,at(":",rHoras)-1))/24)
   nHoras=alltrim(str(nTotdias-(24*nDias)))+substr(rHoras,at(":",rHoras))
   nMeses=int(nDias/30)

   if nMeses>0
      nDias=nDias-(30*nMeses)
   endif

   nAnos=int(nMeses/12)

   if nAnos>0
      nMeses=nMeses-(12*nAnos)
   endif

return({rHoras,alltrim(str(nAnos)),alltrim(str(nMeses)),alltrim(str(nDias)),nHoras})

 /*

   *| Objetivo: Obter a diferenca em segundos entre um periodo. Esta funcao substitui a funcao
   *|           TIMETOSEC() da CATOOLS
   *|
   *| objetivo: converte uma hora para segundos ideal para efetuar soma ou subtracao entre horas
   *| cHora   : HH:MM:SS onde HH nao tem limite, ou seja, nao precisa ser ate 23h, pode por exemplo
   *|           ser 1420. A funcao da CT.LIB timetosec() so aceita ate 23h
   *| retorno : numerico (quantidade de segundos)

 */

Static FUNCTION hh2ss(cHora)

   nSeg=val(substr(cHora,-2,02))
   nMin=val(substr(cHora,-5,02))*60
   nHor=val(left(cHora,at(":",cHora)-1))*60*60

return nHor+nMin+nSeg

 /*
   ***************************************************************************************
   *| Objetivo: Obter a diferenca em hora entre um periodo. Esta funcao substitui a funcao
   *|           SECTOTIME() da CATOOLS
   *|
   ***************************************************************************************
*/

Static FUNCTION ss2hh(cSeg)

   nHor =int(cSeg/3600)
   rest1=int(cSeg%3600)
   nMin =int(rest1/60)
   rest2=int(rest1%60)

return alltrim(str(nHor))+":"+padl(alltrim(str(nMin)),2,"0")+":"+padl(alltrim(str(rest2)),2,"0")

User Function HPreencheLinha(_aIts)
	//-------------------------------------------------------------------------------------------//
	//Distribui as celulas da linha para o excel formato *.csv os itens informados em _aIts      //
	//-------------------------------------------------------------------------------------------//
	Local i,x,y,_P1,_P2
	Local _cLin   := ""
	Local nTamLin := 0

	Private cEOL := CHR(13)+CHR(10)

   for i := 1 to Len(_aIts)
   	_aIts[i] += ";"
   	nTamLin += Len(_aIts[i])
   next

	nTamLin 	+= Len(cEOL)

	_cLin := Space(nTamLin) // Variavel para criacao da linha do registros para gravacao

	x 	:= y := 1

	for i := 1 to Len(_aIts)

		y += Len(_aIts[i])

		_cLin := Stuff(_cLin,x,y,_aIts[i])

		x := y+1

	next

	_P1   := nTamLin-Len(cEOL)
	_P2	:= nTamLin
  	_cLin := Stuff(_cLin,_P1,_P2,cEOL)

Return(_cLin)

User Function VazioSe(pValid)
Local lRet := (pValid == Nil)

Default pValid := &(ReadVar())

if !lRet
	if !( lRet := &(pValid)  )
		msgStop("Campo")
	endif
endif

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IdUser ºAutor  ³ Henrique Corrêa      º Data ³  01/07/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retornar o Código e Nome do Usuário     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IdUser(pUsuario)
Local _aUsu 	:= Pswret(1)
Local cCod  	:= ""
Local cNome  	:= ""

Default pUsuario := __cUserId

If ( "#@" $ pUsuario == '000000' )       // e usuario administrador.
	pUsuario := SubStr(pUsuario, At("#@", pUsuario), 6)
EndIf

PswOrder(1)
If ( PswSeek(pUsuario, .T.) )
	_aUsu 	:= Pswret(1)
	cCod  	:= _aUsu[1][1]
	cNome  	:= _aUsu[1][2]

	If ( Ascan(_aUsu[1][10],'000000') <> 0 )                   // O usuario corrente faz parte do grupo de administradores

	EndIf
EndIf

Return({cCod , cNome})

/*/{Protheus.doc} MultSel

@author Totvs GO
@since 10/04/2014
@version 1.0

@param _cTitulo, caracter, Titulo da tela a ser motada
@param _cAlias, caracter, Alias a ser usado para busca dos registros
@param _cColuna, caracter, Colunas a ser mostrada na grid
@param _cColOrd, caracter, Coluna a ser considerada para ordenação
@param _cCond, caracter, Condição para quando quiser ja trazer filtrados registros
@param _cInf, caracter, String de dados iniciais a ser marcados
@param _cSep, caracter, Separador a ser utilizado
@param _lSelObr, logico, define se será obrigado a selecionar pelo menos um registro

@return Lógico, .T. = Pode usar o abastecimento

@description
Monta tela de Multi-seleção de registros.

@example
//Campo com Botao
cGet6 := U_MultSel("Clientes","SA1","A1_COD,A1_NOME","A1_NOME","A1_MSBLQL = '2'",cGet6)
oGet6:Refresh()

//Consulta Especifica (F3)
Em Express?: Colocar .T.
Em Retorno: U_MultSel("Tipos de Titulo","SX5","X5_CHAVE,X5_DESCRI","X5_CHAVE","X5_TABELA = '05'",&(ReadVar()))
/*/
User Function MultSel(_cTitulo,_cAlias,_cColuna,_cColOrd,_cCond,_cInf,_cSep,_lSelObr)

	Local cQry			:= ""
	Local aColunas 		:= {}
	Local aInf			:= {}
	Local aDados		:= {}

	Local aCampos		:= {}
	Local aCampos2		:= {}

	Local oBut1, oBut2, oBut3
	Local nPosIt		:= 0

	if "X5Descri()" $ _cColuna
		_cColuna := StrTran( _cColuna, "X5Descri()", "X5_DESCRI" )
	endif

	Default _cSep		:= "/" //separador de retorno
	Default _lSelObr	:= .T. //obrigatorio selecionar pelo menos 1 registro

	aColunas 		:= StrTokArr(_cColuna,",")
	aCampos			:= {{"OK","C",002,0},{"COL1","C",TamSX3(aColunas[1])[1],0},{"COL2","C",TamSX3(aColunas[2])[1],0}}
	aCampos2		:= {{"OK","","",""},{"COL1","","Codigo",""},{"COL2","","Nome/Descricao",""}}


	aInf				:= IIF(!Empty(_cInf),StrTokArr(AllTrim(StrTran(_cInf,Chr(13)+Chr(10),"")),_cSep),{})

	Private cRet		:= ""
	Private cArqTrab	:= CriaTrab(aCampos) // Criando arquivo temporario

	Private oDlg
	Private oMark
	Private cMarca	 	:= "mk"
	Private lImpFechar	:= .F.

	Private oSay1, oSay2, oSay3, oSay4, oSay5
	Private oTexto
	Private cTexto		:= Space(40)
	Private oLoja
	Private cLoja		:= Space(2)
	Private nContSel	:= 0

	Private cInf := _cInf

	If _cAlias $ ";SA1;SA2;"
		aCampos		:= {{"OK","C",002,0},{"COL1","C",TamSX3(aColunas[1])[1],0},{"COL2","C",TamSX3(aColunas[2])[1],0},{"COL3","C",TamSX3(aColunas[3])[1],0}}
		aCampos2	:= {{"OK","","",""},{"COL1","","Codigo",""},{"COL2","","Loja",""},{"COL3","","Nome/Descricao",""}}
		cArqTrab	:= CriaTrab(aCampos) // Criando arquivo temporario
	Endif

	If Select("QRYAUX") > 0
		QRYAUX->(DbCloseArea())
	Endif

	cQry := "SELECT DISTINCT "+_cColuna+""
	cQry += " FROM "+RetSqlName(_cAlias)+""
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += " AND "+IIF(SubStr(_cAlias,1,1) == "S",SubStr(_cAlias,2,2),_cAlias)+"_FILIAL = '"+xFilial(_cAlias)+"'"

	If ValType(_cCond) <> "U" .AND. !empty(_cCond)
		cQry += " AND "+_cCond
	Endif

	cQry += " ORDER BY "+_cColOrd+""

	cQry := ChangeQuery(cQry)
	TcQuery cQry NEW Alias "QRYAUX"

	While QRYAUX->(!EOF())

		If _cAlias $ ";SA1;SA2;"
			aAdd(aDados,{&("QRYAUX->"+aColunas[1]),&("QRYAUX->"+aColunas[2]),&("QRYAUX->"+aColunas[3])})
		Else
			aAdd(aDados,{&("QRYAUX->"+aColunas[1]),&("QRYAUX->"+aColunas[2])})
		Endif

		QRYAUX->(dbSkip())
	EndDo

	If Select("QRYAUX") > 0
		QRYAUX->(DbCloseArea())
	Endif

	DBUseArea(.T.,,cArqTrab,"TRBAUX",If(.F. .OR. .F., !.F., NIL), .F.)  // Criando Alias para o arquivo temporario

	DbSelectArea("TRBAUX")

	If Len(aDados) > 0

		For nI := 1 to Len(aDados)

			TRBAUX->(RecLock("TRBAUX",.T.))

			If Len(aInf) > 0

				If _cAlias $ ";SA1;SA2;"
					nPosIt := aScan(aInf,{|x| AllTrim(SubStr(x,1,6)) == AllTrim(aDados[nI][1]) .And. AllTrim(SubStr(x,7,2)) == AllTrim(aDados[nI][2])})
				Else
					nPosIt := aScan(aInf,{|x| AllTrim(x) == AllTrim(aDados[nI][1])})
				Endif

				If nPosIt > 0
					TRBAUX->OK := "mk"
					nContSel++
				Else
					TRBAUX->OK := "  "
				Endif
			Else
				TRBAUX->OK := "  "
			Endif
			TRBAUX->COL1 := aDados[nI][1]
			TRBAUX->COL2 := aDados[nI][2]
			If _cAlias $ ";SA1;SA2;"
				TRBAUX->COL3 := aDados[nI][3]
			Endif
			TRBAUX->(MsUnlock())
		Next
	Else
		TRBAUX->(RecLock("TRBAUX",.T.))
		TRBAUX->OK		:= "  "
		TRBAUX->COL1	:= Space(6)
		If _cAlias $ ";SA1;SA2;"
			TRBAUX->COL2 	:= Space(2)
			TRBAUX->COL3 	:= Space(40)
		Else
			TRBAUX->COL2 	:= Space(40)
		Endif

		TRBAUX->(MsUnlock())
	Endif

	TRBAUX->(DbGoTop())

	DEFINE MSDIALOG oDlgSel TITLE "Selecao de Dados - " + _cTitulo From 000,000 TO 450,700 COLORS 0, 16777215 PIXEL

	@ 005, 005 SAY oSay1 PROMPT "Nome/Descricao:" SIZE 060, 007 OF oDlgSel COLORS 0, 16777215 PIXEL

	If _cAlias $ ";SA1;SA2;"
		@ 004, 050 MSGET oTexto VAR cTexto SIZE 160, 010 OF oDlgSel COLORS 0, 16777215 PIXEL Picture "@!"
		@ 005, 220 SAY oSay5 PROMPT "Loja:" SIZE 030, 007 OF oDlgSel COLORS 0, 16777215 PIXEL
		@ 004, 235 MSGET oLoja VAR cLoja SIZE 020, 010 OF oDlgSel COLORS 0, 16777215 PIXEL Picture "@!"
	Else
		@ 004, 050 MSGET oTexto VAR cTexto SIZE 200, 010 OF oDlgSel COLORS 0, 16777215 PIXEL Picture "@!"
	Endif

	@ 005, 272 BUTTON oBut1 PROMPT "Localizar" SIZE 040, 010 OF oDlgSel ACTION Localiza(_cAlias,cTexto,cLoja) PIXEL

	//Browse
	oMark := MsSelect():New("TRBAUX","OK","",aCampos2,,@cMarca,{020,005,190,348})
	oMark:bMark 				:= {||MarcaIt()}
	oMark:oBrowse:LCANALLMARK 	:= .T.
	oMark:oBrowse:LHASMARK    	:= .T.
	oMark:oBrowse:bAllMark 		:= {||MarcaT()}

	@ 193, 005 SAY oSay2 PROMPT "Total de registros selecionados:" SIZE 200, 007 OF oDlgSel COLORS 0, 16777215 PIXEL
	@ 193, 090 SAY oSay3 PROMPT cValToChar(nContSel) SIZE 040, 007 OF oDlgSel COLORS 0, 16777215 PIXEL

	//Linha horizontal
	@ 203, 005 SAY oSay4 PROMPT Repl("_",342) SIZE 342, 007 OF oDlgSel COLORS CLR_GRAY, 16777215 PIXEL

	@ 213, 272 BUTTON oBut2 PROMPT "Confirmar" SIZE 040, 010 OF oDlgSel ACTION Conf001(_cAlias,1,_cSep,_lSelObr) PIXEL  //Conf001(1,_cSep)
	@ 213, 317 BUTTON oBut3 PROMPT "Fechar" SIZE 030, 010 OF oDlgSel ACTION Fech001(1) PIXEL

	ACTIVATE MSDIALOG oDlgSel CENTERED VALID lImpFechar //impede o usuario fechar a janela atraves do [X]

Return cRet

/***********************************************************/
//SubFunção da MultSel - Conf001
/***********************************************************/
Static Function Conf001(_cAlias,_nOri,_cSep,_lSelObr)

	Local lAux 	:= .F.
	Local nAux	:= 0

	Default _cSep := "/"

	If nContSel == 0 .AND. _lSelObr
		MsgInfo("Nenhum registro selecionado!!","Atenção")
		Return
	Endif

	TRBAUX->(dbGoTop())

	While TRBAUX->(!EOF())
		If TRBAUX->OK == "mk"
			If !lAux
				If _cAlias $ ";SA1;SA2;"
					cRet += AllTrim(TRBAUX->COL1) + AllTrim(TRBAUX->COL2)
				Else
					cRet += AllTrim(TRBAUX->COL1)
				Endif
				lAux := .T.
			Else
				If _cAlias $ ";SA1;SA2;"
					cRet += _cSep + AllTrim(TRBAUX->COL1) + AllTrim(TRBAUX->COL2)
				Else
					cRet += _cSep + AllTrim(TRBAUX->COL1)
				Endif
			Endif
			nAux += Len(TRBAUX->COL1)
		Endif

		//Acrescentei para retornar o primeiro selecionado - Henrique
		if lAux
			exit
		endif

		/////////////////////////////////////////////////////

		If _nOri == 1
			If nAux >= 65
				cRet += Chr(13)+Chr(10)
				nAux := 0
			Endif
		Else
			If nAux >= 25
				cRet += Chr(13)+Chr(10)
				nAux := 0
			Endif
		Endif

		TRBAUX->(dbSkip())
	EndDo

	Fech001(2)

Return

/***********************************************************/
//SubFunção da MultSel - Fech001
/***********************************************************/
Static Function Fech001(_nOpc)

	lImpFechar := .T.

	If _nOpc == 1
		cRet := cInf
	Endif

	If Select("TRBAUX") > 0
		TRBAUX->(DbCloseArea())
	Endif

	//????????????????????????????????????
	//?Apagando arquivo temporario                                         ?
	//????????????????????????????????????

	FErase(cArqTrab + GetDBExtension())
	FErase(cArqTrab + OrdBagExt())

	oDlgSel:End()

Return

/***********************************************************/
//SubFunção da MultSel - LimpMemo
/***********************************************************/
User Function LimpMemo(_oObjeto,_cInf)

	_cInf := Space(200)
	_oObjeto:Refresh()

Return

/***********************************************************/
//SubFunção da MultSel - RetIn
/***********************************************************/
User Function RetIn(_cInf,_cSep)

	Local cRet := ""
	Local aAux := {}
	Default _cSep := "/"

	aAux := StrTokArr(_cInf,_cSep)

	For nI := 1 To Len(aAux)
		If nI <> Len(aAux)
			cRet += "'" + AllTrim(aAux[nI]) + "'" + ","
		Else
			cRet += "'" + AllTrim(aAux[nI]) + "'"
		Endif
	Next

Return cRet

/***********************************************************/
//SubFunção da MultSel - MarcaIt
/***********************************************************/
Static Function MarcaIt()

	If TRBAUX->OK == "mk"
		nContSel++
	Else
		--nContSel
	Endif

	oSay3:Refresh()

Return

/***********************************************************/
//SubFunção da MultSel - MarcaT
/***********************************************************/
Static Function MarcaT()

	Local lMarca 	:= .F.
	Local lNMARCA 	:= .F.

	nContSel := 0

	TRBAUX->(dbGoTop())

	While TRBAUX->(!EOF())
		If TRBAUX->OK == "mk" .And. !lMarca
			RecLock("TRBAUX",.F.)
			TRBAUX->OK := "  "
			TRBAUX->(MsUnlock())
			lNMarca := .T.
		Else
			If !lNMarca
				RecLock("TRBAUX",.F.)
				TRBAUX->OK := "mk"
				TRBAUX->(MsUnlock())
				nContSel++
				lMarca := .T.
			Endif
		Endif

	    TRBAUX->(dbSkip())
	EndDo

	TRBAUX->(dbGoTop())

	oSay3:Refresh()

Return

/***********************************************************/
//SubFunção da MultSel - Localiza
/***********************************************************/
Static Function Localiza(_cAlias,_cTexto, _cLoja)

	If _cAlias $ ";SA1;SA2;"

		If !Empty(_cTexto) .Or. !Empty(_cLoja)

			If !Empty(_cTexto) .And. !Empty(_cLoja)

				TRBAUX->(dbSkip())

				While TRBAUX->(!EOF())
					If AllTrim(_cTexto) $ TRBAUX->COL3 .And. AllTrim(_cLoja) $ TRBAUX->COL2
						Exit
					Endif

					TRBAUX->(dbSkip())
				EndDo

			ElseIf !Empty(_cTexto) .And. Empty(_cLoja)

				TRBAUX->(dbSkip())

				While TRBAUX->(!EOF())
					If AllTrim(_cTexto) $ TRBAUX->COL3
						Exit
					Endif

					TRBAUX->(dbSkip())
				EndDo

			Else
				TRBAUX->(dbSkip())

				While TRBAUX->(!EOF())
					If AllTrim(_cLoja) $ TRBAUX->COL2
						Exit
					Endif

					TRBAUX->(dbSkip())
				EndDo
			Endif

		Else
			TRBAUX->(dbGoTop())
		Endif
	Else

		If !Empty(_cTexto)

			TRBAUX->(dbSkip())

			While TRBAUX->(!EOF())
				If AllTrim(_cTexto) $ TRBAUX->COL2
					Exit
				Endif

				TRBAUX->(dbSkip())
			EndDo
		Else
			TRBAUX->(dbGoTop())
		Endif
	Endif

Return




/*/{Protheus.doc} CorLinha

@author Totvs GO
@since 10/04/2014
@version 1.0

@param oObj, Objeto MsNewGetDados
@param nCor1, numerico, cor da linha padarao
@param nCor2, numerico, cor da linha inversao

@return numerico, cor a ser usada na linha

@description
Funcao para colorir as linhas do MsNewGetDados

@example

/*/
User Function CorLinha(oObj,nCor1,nCor2) //U_CorLinha()

	Default nCor1 	:= RGB(152,152,152) // cinza escuro
	Default nCor2 	:= RGB(240,240,240) // cinza claro

	if oObj:nAt%2 == 0 // se a linha for par
		nRet := nCor1
	else // se a linha for impar
		nRet := nCor2
	endif

Return(nRet)


/*/{Protheus.doc} LotePI

@author Henrique Corrêa
@since 02/10/2017
@version 1.0

@param cOP,
@param cCodPI
@param cLoteSC2
@param cLoteCtl
@param dDtVldSC2
@param dDtValid

@return cLoteCtl

@description
Funcao para retornar o Lote e a data de validade do PI para a Ordem de Produção

Alterado por danilo. Vai retornar apenas o lote para a OP principal, sequenciando
/*/
User Function LotePI(cOP, cCodPI, cLoteCtl)

	Local aArea      := GetArea()
	Local aArSB8     := SB8->(GetArea())
	Local cAliasLote := GetNextAlias()

	Default cOP			:= ""
	Default cCodPI		:= U_RetPI(cOP) //SB1->B1_COD
	Default cLoteCtl 	:= ""

	if empty(cOP) .OR. empty(cCodPI)
		Return("")
	endif

   	cQry := " SELECT Max(SC2.C2_LOTECTL) LOTECTL"
	cQry += " FROM " + RetSqlName("SC2") + " SC2 "
    cQry += " WHERE SC2.D_E_L_E_T_  = ' ' "
    cQry += "   AND SC2.C2_FILIAL   = '" + xFilial("SC2") + "' "
    cQry += "   AND SC2.C2_PRODUTO <> '"+cCodPI+"' " //ignora OPs do PI
    cQry += "   AND SC2.C2_LOTECTL  Like '"+AllTrim(cLoteCtl)+"%' " //começa com o lote do PI
	cQry += "   AND (SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN)	<> '"+cOP+"' " //ignora a propria OP

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasLote,.T.,.T.)

	(cAliasLote)->(dbGoTop())

	if (cAliasLote)->(!Eof()) .And. !Empty((cAliasLote)->LOTECTL)
		cLoteCtl := Soma1(AllTrim((cAliasLote)->LOTECTL))
	else
		cLoteCtl := cLoteCtl + "A"
	endif

	(cAliasLote)->(dbCloseArea())

	RestArea(aArSB8)
	RestArea(aArea)

Return( cLoteCtl )

/*/{Protheus.doc} FabricPI

@author Henrique Corrêa
@since 02/10/2017
@version 1.0

@param cOP,
@param cCodPI
@param cLoteSC2
@param cLoteCtl
@param dDtVldSC2
@param dDtValid

@return cLoteCtl

@description
Funcao para retornar o data fabricaçao da OP, quando tem PI

/*/
User Function FabricPI(cCodPI, cLoteCtl, cDatPriOP)

	Local aArea      := GetArea()
	Local cAliasLote := GetNextAlias()
	Local dDatPri	 := stod("")

	Default cCodPI		:= ""
	Default cLoteCtl 	:= ""

	if empty(cCodPI)
		Return(cDatPriOP)
	endif

   	cQry := " SELECT SC2.C2_DATPRI "
	cQry += " FROM " + RetSqlName("SC2") + " SC2 "
    cQry += " WHERE SC2.D_E_L_E_T_  = ' ' "
    cQry += "   AND SC2.C2_FILIAL   = '" + xFilial("SC2") + "' "
    cQry += "   AND SC2.C2_PRODUTO = '"+cCodPI+"' " //produdo proprio PI
    cQry += "   AND SC2.C2_LOTECTL = '"+cLoteCtl+"' " //lote igual do PI

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasLote,.T.,.T.)

	if (cAliasLote)->(!Eof())
		dDatPri := STOD( (cAliasLote)->C2_DATPRI )

	else //se nao encontrar, deixa a propria data da OP
		dDatPri := cDatPriOP
	endif

	(cAliasLote)->(dbCloseArea())

	RestArea(aArea)

Return( dDatPri )

/*/{Protheus.doc} RetPI

@author Henrique Corrêa
@since 02/10/2017
@version 1.0

@param cOP,
@param cCodPI
@param cLoteSC2
@param cLoteCtl
@param dDtVldSC2
@param dDtValid

@return {cLoteCtl, dDtValid}

@description
Funcao para retornar o Lote e a data de validade do PI para a Ordem de Produção

/*/
User Function RetPI(cOP, cCodProd)
	Local aEstruct   	:= {}
	Local cCodPI        := ""

	Default cCodProd := Iif(Type("M->C2_PRODUTO") <> "U", M->C2_PRODUTO, Posicione("SC2", 1, xFilial("SC2")+cOP, "C2_PRODUTO"))
	aEstruct := u_fEstruct(cCodProd, 1)
	AEval(aEstruct, {|x| cCodPI := Iif(Posicione("SB1",1,xFilial("SB1")+x[6],"B1_TIPO") == 'PI', x[6], cCodPI ) })

Return(cCodPI)

/*/{Protheus.doc} fEstruct

@author Henrique Corrêa
@since 02/10/2017
@version 1.0

@param cOP,
@param cCodPI
@param cLoteSC2
@param cLoteCtl
@param dDtVldSC2
@param dDtValid

@return {cLoteCtl, dDtValid}

@description
Funcao para retornar o Lote e a data de validade do PI para a Ordem de Produção

/*/
User Function fEstruct(pCodProd, pQtdRequerida)
Local 	cNomeArq
Local   aEstruc  	:= {}
Local	cNomeAli 	:= GetNextAlias()

Private nEstru 		:= 0

cNomeArq := u_Estrut2(pCodProd, pQtdRequerida, cNomeAli)

dbSelectArea(cNomeAli)
(cNomeAli)->(dbGoTop())
do while (cNomeAli)->(!Eof())
    /*
	AAdd(aEstruc, { {'FILIAL'		, (cNomeAli)->NIVEL										},;
	                {'NUM_REV'		, (cNomeAli)->REVISAO									},;
	                {'NUM_VERSAO'	, (cNomeAli)->TRT										},;
	                {'COD_PROD'		, (cNomeAli)->CODIGO									},;
	                {'SEQ_ITEM'		, (cNomeAli)->TRT										},;
	                {'COD_ITEM'		, (cNomeAli)->COMP										},;
	                {'QTD_BASE'		, NoRound((cNomeAli)->QUANT,2) 							},;
	                {'UM_ITEM'	 	, (cNomeAli)->UM										},;
	                {'CLASSE'	 	, Iif((cNomeAli)->CLASSE="I", " ", (cNomeAli)->CLASSE)	},;
	                {'POTENCIA'		, NoRound((cNomeAli)->POTENCI,2)						},;
	                {'DESC_ITEM'	, (cNomeAli)->DESC										},;
	                {'OPC_GRUP'		, (cNomeAli)->GROPC										},;
	                {'OPC_ITEM'    	, (cNomeAli)->OPC										},;
	                {'STATUS_ESTRU'	, "Ativo"												}})

	*/

	AAdd(aEstruc, { (cNomeAli)->NIVEL										,;
	                (cNomeAli)->REVISAO										,;
	                (cNomeAli)->TRT											,;
	                (cNomeAli)->CODIGO										,;
	                (cNomeAli)->TRT											,;
	                (cNomeAli)->COMP										,;
	                NoRound((cNomeAli)->QUANT,2) 							,;
	                (cNomeAli)->UM											,;
	                Iif((cNomeAli)->CLASSE="I", " ", (cNomeAli)->CLASSE)	,;
	                NoRound((cNomeAli)->POTENCI,2)							,;
	                (cNomeAli)->DESC										,;
	                (cNomeAli)->GROPC										,;
	                (cNomeAli)->OPC											,;
	                "Ativo"													})

	(cNomeAli)->(DbSkip())
enddo

Return(aEstruc)

/*/{Protheus.doc} fVldLote

@author Henrique Corrêa
@since 02/10/2017
@version 1.0

@param pCodProduto (Código do PI)
@param pLote (se não informado, valida se existe algum lote par atender a produção do produto)

@return {cLoteCtl, dDtValid}

@description
Funcao para retornar o Lote e a data de validade do PI para a Ordem de Produção

/*/
User Function fVldLote(pCodProduto, pLote)
	Local cMsgErr 		:= ""
	Local nQtdProduz 	:= SC2->C2_QUANT
	Local aEstruct   	:= u_fEstruct(SC2->C2_PRODUTO, SC2->C2_QUANT)
	Local nQtdPI     	:= 0
	Local cCodPI        := ""
	Local codLOTE       := ""

	AEval(aEstruct, {|x| cCodPI := Iif(Posicione("SB1",1,xFilial("SB1")+x[6],"B1_TIPO") == 'PI', x[6], cCodPI	) 	,;
						 nQtdPI += Iif(Posicione("SB1",1,xFilial("SB1")+x[6],"B1_TIPO") == 'PI', x[7], 0		)	})

	if pCodProduto == cCodPI .and. !empty(pLote)

		if !empty( codLOTE := Posicione("SD4", 2, xFilial("SD4")+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)+cCodPI,"D4_LOTECTL") )

			if codLOTE <> pLote
				cMsgErr := "Já foi utilizado para essa ordem de produção o lote " + codLOTE
			endif

	    elseif nQtdPI > SB8->B8_SALDO

				cMsgErr := "Este lote não atende, não tem saldo suficiente para atender a Ordem de Produção."

		endif

    endif

Return cMsgErr


/*/{Protheus.doc} fVldLote

@author Henrique Corrêa
@since 02/10/2017
@version 1.0

@param pCodProduto (Código do PI)
@param pLote (se não informado, valida se existe algum lote par atender a produção do produto)

@return {cLoteCtl, dDtValid}

@description
Funcao para retornar o Lote e a data de validade do PI para a Ordem de Produção

/*/
User Function fVldSldPI(pCodProduto, pCodPI, pLote)
	Local cMsgErr 		:= ""
	Local nQtdProduz 	:= Iif(Type("M->C2_QUANT") <> 'U', M->C2_QUANT, SC2->C2_QUANT)
	Local aEstruct   	:= u_fEstruct(pCodProduto, nQtdProduz)
	Local nQtdPI     	:= 0
	Local cCodPI        := ""
	Local codLOTE       := ""
	Local aArSB8        := SB8->(GetArea())

	AEval(aEstruct, {|x| cCodPI := Iif(Posicione("SB1",1,xFilial("SB1")+x[6],"B1_TIPO") == 'PI', x[6], cCodPI	) 	,;
						 nQtdPI += Iif(Posicione("SB1",1,xFilial("SB1")+x[6],"B1_TIPO") == 'PI', x[7], 0		)	})

	if empty(cCodPI) .and. empty(pCodPI)
		return("") //Se não tem PI na estrutura, retorna vazio (sem erro)
	endif

	if !empty(pCodPI) .and. pCodPI <> cCodPI
		cMsgErr := "Código do PI consultado não corresponde ao PI da estrutura do produto "+AllTrim(pCodProduto)+"."
	endif

	if empty(cMsgErr) .and. !empty(cCodPI)
		dbSelectArea("SB8")
		dbSetOrder(5) //B8_FILIAL+B8_PRODUTO+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
		if !MSSeek(XFilial("SB8")+cCodPI)
			cMsgErr := "Não foi encontrado lote(s) do PI."
		endif

		if empty(cMsgErr)
			do while SB8->(!Eof() .and. B8_PRODUTO == cCodPI)
				if SB8->B8_DTVALID >= dDataBase .and. SB8->(B8_SALDO-B8_EMPENHO) >= nQtdPI .and. (empty(pLote) .or. pLote == SB8->B8_LOTECTL)
					codLOTE := SB8->B8_LOTECTL
					exit
				endif

				SB8->(dbSkip())
			enddo

			if empty(codLOTE)
				if !empty(pLote)
					cMsgErr := "Lote consultado não tem quantidade que atenda a produção do produto "+AllTrim(pCodProduto)+"."
				else
					cMsgErr := "Não foi encontrado nenhum lote que atenda a produção do produto "+AllTrim(pCodProduto)+""
				endif
			endif
		endif
    endif

    RestArea(aArSB8)
Return cMsgErr
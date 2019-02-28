//Bibliotecas
#Include "Protheus.ch"

//Constantes
#Define CLR_AZUL      RGB(058,074,119)									//Cor Azul

//Variaveis
Static COL_T1 	:= 001				//Primeira Coluna da tela
Static COL_T2 	:= 123				//Segunda Coluna da tela
Static COL_T3 	:= 245				//Terceira Coluna da tela
Static COL_T4 	:= 367				//Quarta Coluna da tela
Static ESP_CAMPO	:= 038				//Espa�amento do campo para coluna
Static TAM_FILIAL	:= FWSizeFilial()	//Tamanho do campo Filial

/*/{Protheus.doc} zCadSX6
Lista par�metros ao usu�rio com as op��es de incluir, alterar e excluir
@author Atilio
@since 14/11/2014
@version 1.0
	@param aParams, Array, Par�metros que ser�o listados ao usu�rio para edi��o
	@param lCombo, L�gico, Define se os par�metros ser�o mostrados em combo quando houver inclus�o
	@param lDelet, L�gico, Define se ser� poss�vel a exclus�o de par�metros
	@example
	aParams := { "MV_X_AMBOF","MV_X_USERS"}
	u_zCadSX6(aParams, .T., .T.)
/*/

User Function zCadSX6(aParams, lCombo, lDelet)
	Local aArea   := GetArea()
	Local aAreaX6 := SX6->(GetArea())
	Local nAtual  := 0
	Local nColuna := 6
	Default lCombo := .T.
	Default lDelet := .F.
	Default aParams := { "MV_DBLQMOV","MV_ULMES","MV_XTESDEV","MV_DEVCFOP"," MV_DATAFIN",;
	"MV_DATAFIS","MV_RECSTAC","MV_RECSTAC","MV_RECSTAL","MV_RECSTAM","MV_RECSTAP","MV_RECSTBA",;
	"MV_RECSTCE","MV_RECSTDF","MV_RECSTES","MV_RECSTGO","MV_RECSTMA","MV_RECSTMG","MV_RECSTMS",;
	"MV_RECSTMT","MV_RECSTPA","MV_RECSTPB","MV_RECSTPE","MV_RECSTPI","MV_RECSTPR","MV_RECSTRJ",;
	"MV_RECSTRN","MV_RECSTRO","MV_RECSTRR","MV_RECSTRS","MV_RECSTSC","MV_RECSTSE","MV_RECSTSP",;
	"MV_RECSTTO"}
	Private lComboPvt := lCombo
	Private aParamsPvt := {}
	Private cParamsPvt := ""
	//Tamanho da Janela
	Private aTamanho := MsAdvSize()
	Private nJanLarg := aTamanho[5]
	Private nJanAltu := aTamanho[6]
	Private nColMeio := (nJanLarg)/4
	Private nEspCols := ((nJanLarg/2)-12)/4
	COL_T1 	:= 003
	COL_T2 	:= COL_T1+nEspCols
	COL_T3 	:= COL_T2+nEspCols
	COL_T4 	:= COL_T3+nEspCOls
	//Objetos gr�ficos
	Private oDlgSX6
	//GetDados
	Private oMsGet
	Private aHeader 	:= {}
	Private aCols		:= {}
	//Bot�es
	Private aButtons	:= {}
	//aAdd(aButtons,{"Incluir",    "{|| fInclui()}", "oBtnInclui"})
	aAdd(aButtons,{"Alterar",    "{|| fAltera()}", "oBtnAltera"})
	aAdd(aButtons,{"Visualizar", "{|| fVisualiza()}", "oBtnVisual"})
	/*If lDelet
		aAdd(aButtons,{"Excluir",    "{|| fExclui()}", "oBtnExclui"})
	EndIf*/
	aAdd(aButtons,{"Sair", "{|| oDlgSX6:End()}", "oBtnSair"})
	
	//Se n�o tiver par�metros
	If Len(aParams) <= 0
		MsgStop("Par�metros devem ser informados!", "Aten��o")
		Return
	Else
		aParamsPvt := aParams
		cParamsPvt := ""
		
		//Percorrendo os par�metros e adicionando
		For nAtual := 1 To Len(aParamsPvt)
			cParamsPvt += aParamsPvt[nAtual]+";"
		Next
	EndIf
	
	//Adicionando cabe�alho
	aAdd(aHeader,{"Filial", 	"ZZ_FILIAL",	"@!",	TAM_FILIAL,	    0,	".F.",	".F.",	"C",	"",	""	,})
	aAdd(aHeader,{"Par�metro", 	"ZZ_PARAME",	"@!",	010,			0,	".F.",	".F.",	"C",	"",	""	,})
	aAdd(aHeader,{"Tipo",  		"ZZ_TIPO",		"@!",	001,			0,	".F.",	".F.",	"C",	"",	""	,})
	aAdd(aHeader,{"Descri��o",  "ZZ_DESCRI",	"@!",	150,			0,	".F.",	".F.",	"C",	"",	""	,})
	aAdd(aHeader,{"Conte�do",   "ZZ_CONTEU",	"@!",	250,			0,	".F.",	".F.",	"C",	"",	""	,})
	aAdd(aHeader,{"RecNo",      "ZZ_RECNUM",	"",		018,			0,	".F.",	".F.",	"N",	"",	""	,})
	
	//Atualizando o aCols
	fAtuaCols(.T.)
	
	//Criando a janela
	DEFINE MSDIALOG oDlgSX6 TITLE "Par�metros:" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
		oMsGet := MsNewGetDados():New(	3,;										//nTop
    										3,;										//nLeft
    										(nJanAltu/2)-33,;						//nBottom
    										(nJanLarg/2)-3,;						//nRight
    										GD_INSERT+GD_DELETE+GD_UPDATE,;		//nStyle
    										"AllwaysTrue()",;						//cLinhaOk
    										,;										//cTudoOk
    										"",;									//cIniCpos
    										,;										//aAlter
    										,;										//nFreeze
    										999999,;								//nMax
    										,;										//cFieldOK
    										,;										//cSuperDel
    										,;										//cDelOk
    										oDlgSX6,;								//oWnd
    										aHeader,;								//aHeader
    										aCols)									//aCols  
    	oMsGet:lActive := .F.
	
		//Grupo Legenda
		@ (nJanAltu/2)-30, 003 	GROUP oGrpLeg TO (nJanAltu/2)-3, (nJanLarg/2)-3 	PROMPT "A��es: " 		OF oDlgSX6 COLOR 0, 16777215 PIXEL
		//Adicionando bot�es
		For nAtual := 1 To Len(aButtons)
			@ (nJanAltu/2)-20, nColuna  BUTTON &(aButtons[nAtual][3]) PROMPT aButtons[nAtual][1]   SIZE 60, 014 OF oDlgSX6  PIXEL
			(&(aButtons[nAtual][3]+":bAction := "+aButtons[nAtual][2]))
			nColuna += 63
		Next
	ACTIVATE MSDIALOG oDlgSX6 CENTERED
	
	RestArea(aAreaX6)
	RestArea(aArea)
Return


/*---------------------------------------------------------------------*
 | Func:  fInclui                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  14/11/2014                                                   |
 | Desc:  Fun��o de inclus�o de par�metro                              |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------

Static Function fInclui()
	Local nAtual   := oMsGet:nAt
	Local aColsAux := oMsGet:aCols
	Local nPosRecNo:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ_RECNUM" })
	
	fMontaTela(3, 0)
Return
*/

/*---------------------------------------------------------------------*
 | Func:  fAltera                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  14/11/2014                                                   |
 | Desc:  Fun��o de altera��o de par�metro                             |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function fAltera()
	Local nAtual   := oMsGet:nAt
	Local aColsAux := oMsGet:aCols
	Local nPosRecNo:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ_RECNUM" })
	
	//Se tiver recno v�lido
	If aColsAux[nAtual][nPosRecNo] != 0
		fMontaTela(4, aColsAux[nAtual][nPosRecNo])
	EndIf
Return

/*---------------------------------------------------------------------*
 | Func:  fExclui                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  14/11/2014                                                   |
 | Desc:  Fun��o de exclus�o de par�metro                              |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------

Static Function fExclui()
	Local nAtual   := oMsGet:nAt
	Local aColsAux := oMsGet:aCols
	Local nPosRecNo:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ_RECNUM" })
	
	//Se tiver recno v�lido
	If aColsAux[nAtual][nPosRecNo] != 0
		fMontaTela(5, aColsAux[nAtual][nPosRecNo])
	EndIf
Return
*/
/*---------------------------------------------------------------------*
 | Func:  fVisualiza                                                   |
 | Autor: Daniel Atilio                                                |
 | Data:  14/11/2014                                                   |
 | Desc:  Fun��o de visualiza��o de par�metro                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function fVisualiza()
	Local nAtual   := oMsGet:nAt
	Local aColsAux := oMsGet:aCols
	Local nPosRecNo:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ_RECNUM" })
	
	//Se tiver recno v�lido
	If aColsAux[nAtual][nPosRecNo] != 0
		fMontaTela(2, aColsAux[nAtual][nPosRecNo])
	EndIf
Return

/*---------------------------------------------------------------------*
 | Func:  fAtuaCols                                                    |
 | Autor: Daniel Atilio                                                |
 | Data:  14/11/2014                                                   |
 | Desc:  Fun��o que atualiza o aCols com os par�metros                |
 | Obs.:  Como a inten��o � ter poucos par�metros, sempre ele ir�      |
 |        percorrer a SX6 e adicionar no aCols                         |
 *---------------------------------------------------------------------*/

Static Function fAtuaCols(lFirst)
	Local aAreaSX6 := SX6->(GetArea())
	aCols := {}
	
	//Selecionando a tabela de par�metros e indo ao topo
	DbSelectArea("SX6")
	SX6->(DbGoTop())
	
	//Percorrendo os par�metros, e adicionando somente os que est�o na filtragem
	While !SX6->(EoF())
		If Alltrim(SX6->X6_VAR) $ cParamsPvt
			aAdd( aCols, {	SX6->X6_FIL,;											//Filial
								SX6->X6_VAR,;											//Par�metro
								SX6->X6_TIPO,;										//Tipo
								SX6->X6_DESCRIC+SX6->X6_DESC1+SX6->X6_DESC2,;		//Descri��o
								SX6->X6_CONTEUD,;										//Conte�do
								SX6->(RecNo()),;										//RecNo
								.F.})													//Exclu�do?
		EndIf
	
		SX6->(DbSkip())
	EndDo

	//Se tiver zerada, adiciona conte�do em branco
	If Len(aCols) == 0
		aAdd( aCols, {	"",;		//Filial
							"",;		//Par�metro
							"",;		//Tipo
							"",;		//Descri��o
							"",;		//Conte�do
							0,;			//RecNo
							.F.})		//Exclu�do?
	EndIf

	//Sen�o for a primeira vez, atualiza grid
	If !lFirst
		oMsGet:setArray(aCols)
	EndIf

	RestArea(aAreaSX6)
Return

/*---------------------------------------------------------------------*
 | Func:  fMontaTela                                                   |
 | Autor: Daniel Atilio                                                |
 | Data:  14/11/2014                                                   |
 | Desc:  Fun��o que atualiza o aCols com os par�metros                |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function fMontaTela(nOpcP, nRecP)
	Local nColuna := 6
	Local nEsp := 15
	Private nOpcPvt := nOpcP
	Private nRecPvt := nRecP
	Private aOpcTip := {" ", "C - Caracter", "N - Num�rico", "L - L�gico", "D - Data", "M - Memo"}
	Private oFontNeg := TFont():New("Tahoma")
	Private oDlgEdit
	//Campos
	Private oGetFil, cGetFil
	Private oGetPar, cGetPar
	Private oGetTip, cGetTip
	Private oGetDes, cGetDes
	Private oGetCon, cGetCon
	Private oGetRec, nGetRec
	//Bot�es
	Private aBtnPar	:= {}
	aAdd(aBtnPar,{"Confirmar",   "{|| fBtnEdit(1)}", "oBtnConf"})
	aAdd(aBtnPar,{"Cancelar",    "{|| fBtnEdit(2)}", "oBtnCanc"})

	//Se n�o for inclus�o, pega os campos conforme array
	If nOpcP != 3
		aColsAux := oMsGet:aCols
		nLinAtu  := oMsGet:nAt
		nPosFil  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ_FILIAL" })
		nPosPar  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ_PARAME" })
		nPosTip  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ_TIPO" })
		nPosDes  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ_DESCRI" })
		nPosCon  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ_CONTEU" })
		nPosRec  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZ_RECNUM" })

		//Atualizando gets
		cGetFil := aColsAux[nLinAtu][nPosFil]
		cGetPar := aColsAux[nLinAtu][nPosPar]
		cGetTip := aColsAux[nLinAtu][nPosTip]
		cGetDes := aColsAux[nLinAtu][nPosDes]
		cGetCon := aColsAux[nLinAtu][nPosCon]
		nGetRec := aColsAux[nLinAtu][nPosRec]

		//Caracter
		If cGetTip == "C"
			cGetTip := aOpcTip[2]
		//Num�rico
		ElseIf cGetTip == "N"
			cGetTip := aOpcTip[3]
		//L�gico
		ElseIf cGetTip == "L"
			cGetTip := aOpcTip[4]
		//Data
		ElseIf cGetTip == "D"
			cGetTip := aOpcTip[5]
		//Memo
		ElseIf cGetTip == "M"
			cGetTip := aOpcTip[6]
		EndIf

	//Sen�o, deixa os campos zerados
	Else
	
		//Atualizando gets
		cGetFil := Space(TAM_FILIAL)
		cGetPar := Space(010)
		cGetTip := aOpcTip[1]
		cGetDes := Space(150)
		cGetCon := Space(250)
		nGetRec := 0
	EndIf

	oFontNeg:Bold := .T.

	//Criando a janela
	DEFINE MSDIALOG oDlgEdit TITLE "Dados:" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
		nLinAux := 6
			//Filial
			@ nLinAux    , COL_T1						SAY				oSayFil PROMPT	"Filial:"						SIZE 040, 007 OF oDlgEdit COLORS CLR_AZUL							PIXEL
			@ nLinAux-003, COL_T1+ESP_CAMPO				MSGET			oGetFil VAR		cGetFil						SIZE 060, 010 OF oDlgEdit COLORS 0, 16777215						PIXEL
			//Par�metro
			@ nLinAux    , COL_T2						SAY				oSayPar PROMPT	"Par�metro:"					SIZE 040, 007 OF oDlgEdit COLORS CLR_AZUL		FONT oFontNeg		PIXEL
			If lComboPvt
				@ nLinAux-003, COL_T2+ESP_CAMPO			MSCOMBOBOX		oGetPar VAR		cGetPar ITEMS aParamsPvt		SIZE 060, 010 OF oDlgEdit COLORS 0, 16777215						PIXEL
			Else
				@ nLinAux-003, COL_T2+ESP_CAMPO			MSGET			oGetPar VAR		cGetPar						SIZE 060, 010 OF oDlgEdit COLORS 0, 16777215	VALID (cGetPar $ cParamsPvt)	PIXEL
			EndIf
			//Tipo
			@ nLinAux    , COL_T3						SAY				oSayTip PROMPT	"Tipo:"						SIZE 040, 007 OF oDlgEdit COLORS CLR_AZUL		FONT oFontNeg		PIXEL
    		@ nLinAux-003, COL_T3+ESP_CAMPO				MSCOMBOBOX		oGetTip VAR		cGetTip ITEMS aOpcTip		SIZE 060, 010 OF oDlgEdit COLORS 0, 16777215						PIXEL
			//RecNo
			@ nLinAux    , COL_T4						SAY				oSayRec PROMPT	"RecNo:"						SIZE 040, 007 OF oDlgEdit COLORS CLR_AZUL							PIXEL
			@ nLinAux-003, COL_T4+ESP_CAMPO				MSGET			oGetRec VAR		nGetRec						SIZE 060, 010 OF oDlgEdit COLORS 0, 16777215						PIXEL
		nLinAux += nEsp
			//Descri��o
			@ nLinAux    , COL_T1						SAY				oSayDes PROMPT	"Descri��o:"					SIZE 040, 007 OF oDlgEdit COLORS CLR_AZUL		FONT oFontNeg		PIXEL
			@ nLinAux-003, COL_T1+ESP_CAMPO				MSGET			oGetDes VAR		cGetDes						SIZE 300, 010 OF oDlgEdit COLORS 0, 16777215						PIXEL
		nLinAux += nEsp
			//Conte�do
			@ nLinAux    , COL_T1						SAY				oSayCon PROMPT	"Conte�do:"					SIZE 040, 007 OF oDlgEdit COLORS CLR_AZUL		FONT oFontNeg		PIXEL
			@ nLinAux-003, COL_T1+ESP_CAMPO				MSGET			oGetCon VAR		cGetCon						SIZE 300, 010 OF oDlgEdit COLORS 0, 16777215						PIXEL
	
		//Grupo Legenda
		@ (nJanAltu/2)-30, 003 	GROUP oGrpLegEdit TO (nJanAltu/2)-3, (nJanLarg/2)-3 	PROMPT "A��es (Confirma��o): " 		OF oDlgEdit COLOR 0, 16777215 PIXEL
		//Adicionando bot�es
		For nAtual := 1 To Len(aBtnPar)
			@ (nJanAltu/2)-20, nColuna  BUTTON &(aBtnPar[nAtual][3]) PROMPT aBtnPar[nAtual][1]   SIZE 60, 014 OF oDlgEdit  PIXEL
			(&(aBtnPar[nAtual][3]+":bAction := "+aBtnPar[nAtual][2]))
			nColuna += 63
		Next
		
		//Se for visualiza��o ou exclus�o, todos os gets ser�o desabilitados
		If nOpcP == 2 .Or. nOpcP == 5
			oGetFil:lActive := .F.
			oGetPar:lActive := .F.
			oGetTip:lActive := .F.
			oGetDes:lActive := .F.
			oGetCon:lActive := .F.
		Else
			//Se for altera��o, desabilita a Filial, Par�metro e Tipo
			If nOpcP == 4
				oGetFil:lActive := .F.
				oGetPar:lActive := .F.
				oGetTip:lActive := .F.
			EndIf
		EndIf
		
		//Campo de RecNo sempre ser� desabilitado
		oGetRec:lActive := .F.
	ACTIVATE MSDIALOG oDlgEdit CENTERED
Return

/*---------------------------------------------------------------------*
 | Func:  fBtnEdit                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  16/12/2014                                                   |
 | Desc:  Fun��o que confirma a tela                                   |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function fBtnEdit(nConf)
	Local aAreaAux := GetArea()
	
	//Se for o Cancelar
	If nConf == 2
		oDlgEdit:End()
	//Se for o Confirmar
	ElseIf nConf == 1
		//Se for visualizar
		If nOpcPvt == 2
			oDlgEdit:End()
			
		//Sen�o for visualizar
		Else
			//Se for exclus�o
			If nOpcPvT == 5
				SX6->(DbGoTo(nRecPvt))
				RecLock("SX6", .F.)
					DbDelete()
				SX6->(MsUnlock())
				oDlgEdit:End()
			Else
				//Descri��o ou conte�do em branco?
				If Empty(cGetDes) .Or. Empty(cGetCon)
					If !MsgYesNo("O campo <b>Descri��o</b> e/ou <b>Conte�do</b> est�o com conte�do em branco!<br>Deseja continuar?", "Aten��o")
						Return
					EndIf
				EndIf
				
				//Se for inclus�o
				If nOpcPvt == 3
					//Tipo e par�metro em branco?
					If Empty(cGetTip) .Or. Empty(cGetPar)
						MsgAlert("O campo <b>Par�metro</b> e/ou <b>Tipo</b> est�o com conte�do em branco!", "Aten��o")
						Return
					EndIf
					
					//J� existe registro?
					SX6->(DbGoTop())
					If (SX6->(DbSeek(cGetFil+cGetPar)))
						MsgAlert("Filial e Par�metro j� existem!", "Aten��o")
						Return
					EndIf
					
					//Travando tabela para inclus�o
					RecLock("SX6", .T.)
					X6_FIL			:= cGetFil
					X6_VAR			:= cGetPar
					X6_TIPO		:= cGetTip
				//Se for altera��o, trava tabela para altera��o
				ElseIf nOpcPvt == 4
					SX6->(DbGoTo(nRecPvt))
					RecLock("SX6", .F.)
				EndIf
				
				//Gravando informa��es
				X6_DESCRIC		:= SubStr(cGetDes,001,50)
				X6_DESC1		:= SubStr(cGetDes,051,50)
				X6_DESC2		:= SubStr(cGetDes,101,50)
				X6_CONTEUD		:= cGetCon
				SX6->(MsUnlock())
				
				oDlgEdit:End()
			EndIf
		EndIf
		
		//Atualizando a grid
		fAtuaCols(.F.)
	EndIf
	
	RestArea(aAreaAux)
Return
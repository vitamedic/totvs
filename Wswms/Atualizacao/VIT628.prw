#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

#define CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} VIT628

- Tela para exibir os lotes incompletos

@author Guilherme Sampaio
@since 12/07/2017
@version undefined

@type function
/*/
User Function VIT628()	
	Local aArea	:= GetArea()
	Local oButton1
	Local oButton2
	Local oGroup1
	Local oSay1
	Local oSay2

	Private cCodPro		:= "" // Codigo do Produto
	Private cDescPro	:= "" // Descricao do Produto
	Private oWBrowse1
	Private aWBrowse1 	:= {}

	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Volumes Incompletos" FROM 000, 000  TO 400, 600 COLORS 0, 16777215 PIXEL

	@ 001, 000 GROUP oGroup1 TO 197, 297 PROMPT "Volumes Incompletos" OF oDlg COLOR 0, 16777215 PIXEL
	fWBrowse1()
	@ 178, 206 BUTTON oButton1 PROMPT "Selecionar" SIZE 037, 014 OF oDlg PIXEL ACTION ( fValida() )
	@ 178, 250 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 014 OF oDlg PIXEL ACTION ( oDlg:End() )
	@ 013, 012 SAY oSay1 PROMPT cCodPro SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 013, 074 SAY oSay2 PROMPT cDescPro SIZE 100, 007 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED
	
	RestArea( aArea )
	
Return .T.

//------------------------------------------------
Static Function fWBrowse1()
	//------------------------------------------------
	Local oOk := LoadBitmap( GetResources(), "LBOK")
	Local oNo := LoadBitmap( GetResources(), "LBNO")
	Local cAliasSB8	:= "TRBSB8"
	Local nPosProd	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_PRODUTO" }) 
	Local cProdSC6	:= aCols[n,nPosProd]

	// Verifico se o acols está preeenchido
	If !Empty( cProdSC6 ) .And. !aCols[n,Len(aHeader)+1]

		// codigo do produto
		cCodPro := cProdSC6

		// pego os itens do acols
		cDescPro := Posicione("SB1",1,xFilial("SB1")+cProdSC6,"B1_DESC")

		// monta a query
		fQrySB8( cAliasSB8, cProdSC6 )

		// caso o alias tenha sido preenchido com os resultados da query 
		If Select( cAliasSB8 ) > 0

			While ( cAliasSB8 )->( !Eof() )

				Aadd(aWBrowse1,{ .F. ,( cAliasSB8 )->B8_LOTECTL, StoD( ( cAliasSB8 )->B8_DTVALID ) , TransForm(( cAliasSB8 )->VOL_INCOMPLETOS, "@E 999,999,999.99"), TransForm(( cAliasSB8 )->QTD_VOLUMES, "@E 999,999,999.99") })

				( cAliasSB8 )->( DbSkip() )
			EndDo

		Else
			Aadd(aWBrowse1,{.F.,"","","",""})	
		EndIf
	Else
		Aadd(aWBrowse1,{.F.,"","","",""})	

	EndIf
	// Insert items here
	//Aadd(aWBrowse1,{"Produto","Desc.Produto","Lote","Dt.Validade","Saldo Disponivel","Saldo p/ Volume"})
	//Aadd(aWBrowse1,{"Produto","Desc.Produto","Lote","Dt.Validade","Saldo Disponivel","Saldo p/ Volume"})

	@ 028, 007 LISTBOX oWBrowse1 Fields HEADER "","Lote","Dt.Validade","Saldo Disponivel","Saldo p/ Volume" SIZE 280, 146 OF oDlg PIXEL ColSizes 50,50
	oWBrowse1:SetArray(aWBrowse1)
	oWBrowse1:bLine := {|| {;
	If(aWBrowse1[oWBrowse1:nAT,1],oOk,oNo),;
	aWBrowse1[oWBrowse1:nAt,2],;
	aWBrowse1[oWBrowse1:nAt,3],;
	aWBrowse1[oWBrowse1:nAt,4],;
	aWBrowse1[oWBrowse1:nAt,5];
	}}
	// DoubleClick event
	oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
	oWBrowse1:DrawSelect()}

Return

//-------------------------------------------------
Static Function fQrySB8( cAliasSB8, cProdSC6 )
	//-------------------------------------------------

	Local cQuery 		:= ""	
	Local cLote			:= fLoteC6()

	Default cAliasSB8	:= "TRBSB8"
	Default cProdSC6	:= ""

	If Select( cAliasSB8 ) > 0
		( cAliasSB8 )->( DbCloseArea() )
	EndIf

	cQuery := " SELECT SB1.B1_COD , SB1.B1_TIPO																												" + CRLF
	cQuery += "      , SB1.B1_DESC																															" + CRLF
	cQuery += "      , SB8.B8_LOTECTL																														" + CRLF
	cQuery += "      , SB8.B8_DTVALID																														" + CRLF
	cQuery += "      , SB8.B8_SALDO 																														" + CRLF
	cQuery += "      , SB8.B8_EMPENHO																														" + CRLF
	cQuery += "      , (SB8.B8_SALDO - SB8.B8_EMPENHO) DISPONIVEL 																							" + CRLF
	cQuery += "      , SB1.B1_CXPAD QTDE_VOLUME 																											" + CRLF
	cQuery += "      , ROUND((SB8.B8_SALDO - SB8.B8_EMPENHO) - Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD) /SB1.B1_CXPAD,1)  QTD_VOLUMES 				" + CRLF
	cQuery += "      , ((SB8.B8_SALDO - SB8.B8_EMPENHO) - Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD)) / SB1.B1_CXPAD        VOL_INTEIROS	 			" + CRLF	
	cQuery += "      , Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD)                                                           VOL_INCOMPLETOS 			" + CRLF
	cQuery += " FROM " + RetSqlName("SB8") + " SB8 																											" + CRLF
	cQuery += "    , " + RetSqlName("SB1") + " SB1																											" + CRLF
	cQuery += " WHERE SB1.B1_FILIAL 									= '"+xFilial("SB1")+"'																" + CRLF
	cQuery += "   AND SB1.B1_COD    									= SB8.B8_PRODUTO																	" + CRLF
	cQuery += "   AND SB1.D_E_L_E_T_ 									= ' ' 																				" + CRLF
	cQuery += "   AND SB8.B8_FILIAL 									= '"+xFilial("SB8")+"'																" + CRLF
	cQuery += "   AND (SB8.B8_SALDO - SB8.B8_EMPENHO) 					> 0																					" + CRLF
	cQuery += "   AND Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD) <> 0																					" + CRLF
	cQuery += "   AND SB8.D_E_L_E_T_ 									= ' ' 																				" + CRLF
	cQuery += "   AND SB1.B1_TIPO 										IN ('PA', 'PN')																		" + CRLF
	cQuery += "   AND SB1.B1_COD   										= '" + cProdSC6 + "'																" + CRLF

	If !Empty( cLote )
		cQuery += "   AND SB8.B8_LOTECTL 									NOT IN (" + cLote + ")															" + CRLF
	EndIf

	cQuery += " ORDER BY SB1.B1_COD																															" + CRLF
	cQuery += "        , SB8.B8_DTVALID ASC																													" + CRLF

	cQuery := ChangeQuery(cQuery)

	TcQuery cQuery New Alias ( cAliasSB8 )

Return

//=========================================
Static Function fValida()
	//=========================================

	fAcolsC6()

Return

//========================================
Static Function fAcolsC6()
	//========================================

	Local aColsAux 	:= {}
	Local nLin		:= {}
	Local nPLotectl	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_LOTECTL" })
	Local nPDtvalid	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_DTVALID" })
	Local nPQtdven	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_QTDVEN" })
	Local nPQtdlib	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_QTDLIB" })
	Local nPValor	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_VALOR" })
	Local nPPrcVen	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_PRCVEN" })
	Local nPUnsVen	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_UNSVEN" })	
	Local nPosProd	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_PRODUTO" }) 		
	Local nI		:= 0
	Local nQtd		:= 0
	Local nPrc		:= 0
	Local nSegum	:= 0

	// verifico se a linha esta deletada
	If !aCols[n,Len(aHeader)+1]		

		// verifico se o acols tem mais de uma linha
		If Len(aCols) > 1
			aColsAux := aCols
		EndIf

		For nI := 1 To Len(aWBrowse1)
			If aWBrowse1[nI,1] // verifico se o lote foi selecionado

				aadd(aColsAux,Array(Len(aHeader)+1))

				nLin 			:= Len(aColsAux)
				aColsAux[nLin]	:= aClone(aCols[n])

				nQtd 	:= Val( aWBrowse1[nI,4] )
				nPrc 	:= aColsAux[nLin][nPPrcVen]

				//Adiciona os itens do aCols
				aColsAux[ nLin, Len(aHeader)+1 ] 	:= .F.
				aColsAux[ nLin, nPQtdven ] 			:= Val( aWBrowse1[nI,4] )
				aColsAux[ nLin, nPQtdlib ] 			:= Val( aWBrowse1[nI,4] )	
				aColsAux[ nLin, nPUnsVen ] 			:= ConvUm(aCols[n,nPosProd],aColsAux[ nLin, nPQtdven ],aColsAux[ n, nPUnsVen ], 2)
				aColsAux[ nLin, nPLotectl] 			:= aWBrowse1[nI,2] 
				aColsAux[ nLin, nPDtvalid ] 		:= aWBrowse1[nI,3]
				aColsAux[ nLin, nPValor ] 			:= nQtd*nPrc

				nLin++
			EndIf
		Next nI

		aCols := aColsAux
		fRodaCols()
		oDlg:End()
	EndIf

Return

//========================================
Static Function fLoteC6()
	//========================================

	Local nPLotectl		:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_LOTECTL" })
	Local cLote			:= ""				

	// percorro o acols
	For nI := 1 To Len( aCols )

		// verifico se a linha nao esta deletada
		If !aCols[nI,Len(aHeader)+1]	

			// verifico se o lote esta preenchido
			If !Empty(aCols[nI,nPLotectl])	

				If Empty(cLote)
					cLote := "'" + aCols[nI,nPLotectl] + "'"
				Else
					cLote += ",'" + aCols[nI,nPLotectl] + "'"
				EndIf

			EndIf

		EndIf
	Next nI

Return cLote

//=========================================
Static Function fRodaCols()
	//=========================================

	Local cItem 	:= ""
	Local nI		:= 0
	Local nPItem	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_ITEM" }) 	

	For nI := 1 To Len( aCols )
		aCols[nI,nPItem] := StrZero(nI,TamSx3("C6_ITEM")[1])
	Next nI

Return
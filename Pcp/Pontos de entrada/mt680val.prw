#Include "rwmake.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "Ap5Mail.ch"
#Include "tbicode.ch"
#Include "dialog.ch"
#Include "protheus.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT680VAL ³Autor ³ Andre Almeida Alves    ³Data ³ 24/01/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada na Inclusao de Producao PCP(Mod.2)        ³±±
±±³          ³ para Validar se foi Realizado Todos Empenhos para a Op.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Em caso de retorno afirmativo (.T.), permite incluir o     ³±±
±±³          ³ Apontamento.                                               ³±±
±±³   lRet   ³ Em caso de retorno negativo (.F.), nao permite incluir     ³±±
±±³          ³ o Apontamento.                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function MT680VAL()

	Local aArea := GetArea()

	PRIVATE lRetDC := .T.
	PRIVATE lRetD4 := .T.

	lRet 	:= .t.
	_cfilsh6:= xfilial("SH6")

	//INICIO CUSTOMIZAÇÃO PROJETO 23/11/2016
	//Alteração do Ricardo .. Verificar se esta funcionando essas validaçoes anteriores.

	IF(SELECT("TMP7") > 0)
		TMP7->(DBCLOSEAREA())
	ENDIF

	_cQue 	:= " SELECT C2_ROTEIRO ROTEIRO, MAX(G2_OPERAC) OPERAC "
	_cQue   += " FROM " + retsqlname("SG2")+" SG2 "
	_cQue 	+= " INNER JOIN " + retsqlname("SC2")+ " SC2 ON SC2.C2_PRODUTO = SG2.G2_PRODUTO AND SC2.C2_ROTEIRO = SG2.G2_CODIGO "
	_cQue 	+= " AND SG2.D_E_L_E_T_ <> '*' "
	_cQue 	+= " AND SC2.D_E_L_E_T_ <> '*' "
	_cQue 	+= " AND G2_FILIAL = '"+_cfilsh6+"' "
	_cQue 	+= " AND C2_NUM = '"+Substr(m->h6_op,1,6)+"' "
	_cQue 	+= " AND G2_PRODUTO = '"+m->h6_produto+"' "
	_cQue 	+= " GROUP BY SC2.C2_ROTEIRO "

	_cQue :=changequery(_cQue)
	//MEMOWRIT("\sql\mt680val7.sql",_cQue)
	tcquery _cQue new alias "TMP7"

	IF(SELECT("TMP8") > 0)
		TMP8->(DBCLOSEAREA())
	ENDIF

	_cQue1 	:= " SELECT MAX(H6_OPERAC) OPERAC "
	_cQue1 	+= " FROM " + retsqlname("SH6")+" SH6 "
	_cQue1 	+= " WHERE SH6.D_E_L_E_T_ <> '*'  "
	_cQue1 	+= " AND H6_FILIAL = '"+_cfilsh6+"'"
	_cQue1 	+= " AND H6_OP = '"+M->H6_OP+"'"
	_cQue1 	+= " AND H6_PT = 'T'"

	_cQue1 :=changequery(_cQue1)
	//MEMOWRIT("\sql\mt680val8.sql",_cQue1)
	tcquery _cQue1 new alias "TMP8"

	If (!Empty(TMP8->OPERAC) .And. M->H6_OPERAC < TMP8->OPERAC) .OR. (!Empty(TMP7->OPERAC) .And. M->H6_OPERAC > TMP7->OPERAC)
		Alert("Fase de Apontamento Incorreta. Verifique a fase a ser Apontada!")
		lRet := .F.
		Return lRet
	Endif

	TMP8->(DBCLOSEAREA())
	TMP7->(DBCLOSEAREA())

	///GRAVA NA TABELA ZLG RICARDO MOREIRA

	IF(SELECT("TMP9") > 0)
		TMP9->(DBCLOSEAREA())
	ENDIF

	_cQue2 	:= " SELECT DISTINCT G2_OPERAC, C2_ROTEIRO "
	_cQue2  += " FROM " + retsqlname("SG2")+" SG2 "
	_cQue2 	+= " INNER JOIN " + retsqlname("SC2")+ " SC2 ON SC2.C2_PRODUTO = SG2.G2_PRODUTO AND SC2.C2_ROTEIRO = SG2.G2_CODIGO "
	_cQue2 	+= " INNER JOIN " + retsqlname("SH6")+ " SH6 ON SH6.H6_PRODUTO = SG2.G2_PRODUTO AND SH6.H6_OPERAC = SG2.G2_OPERAC "
	_cQue2 	+= " AND SH6.D_E_L_E_T_ <> '*' "
	_cQue2 	+= " AND SG2.D_E_L_E_T_ <> '*' "
	_cQue2 	+= " AND SC2.D_E_L_E_T_ <> '*' "
	_cQue2 	+= " AND G2_FILIAL = '"+_cfilsh6+"' "
	_cQue2 	+= " AND C2_NUM = '"+Substr(m->h6_op,1,6)+"' "
	_cQue2 	+= " AND G2_PRODUTO = '"+m->h6_produto+"' "
	_cQue2 	+= " AND G2_OPERAC  < '"+m->h6_operac+"' "
	_cQue2 	+= " ORDER BY G2_OPERAC "

	_cQue2 :=changequery(_cQue2)
	//MEMOWRIT("\sql\mt680val9.sql",_cQue2)
	tcquery _cQue2 new alias "TMP9"

	While !TMP9->(Eof())
		dbSelectArea("SH6")
		dbSetOrder(1)
		If !SH6->(DbSeek(xFilial("SH6")+M->H6_OP+M->H6_PRODUTO+TMP9->G2_OPERAC))
			ZLG->(reclock("ZLG",.T.))
			ZLG->ZLG_USER   := CUSERNAME
			ZLG->ZLG_DATA   := DDATABASE
			ZLG->ZLG_HORA   := SUBSTR(TIME(),1,5)
			ZLG->ZLG_ETPAPO := M->H6_OPERAC      // FASE QUE ESTA APONTANDO
			ZLG->ZLG_ETPPUL := TMP9->G2_OPERAC   // FASES QUE PULOU
			ZLG->ZLG_OP     := M->H6_OP          // NUMERO DA OP APONTADA
			ZLG->(msunlock())
		EndIf
		TMP9->(DbSkip())
	EndDo
	TMP9->(DBCLOSEAREA())
	//FIM CUSTOMIZAÇÃO RICARDO 24/11/2016

	lRetD4 := fValidSD4()  // Roberto Fiuza 07/02/2017 AMS ==> 87365-Melhoria nos pontos de entradas das rotinas MATA681 e MATA250
	IF lRetD4 = .F.
		Alert(;
		"Há produto(s) sem identificação de lote " + chr(13)  + chr(13) + Chr(10) + ;
		"Esta operação não sera finalizada " + chr(13)  + chr(13) + Chr(10) + ;
		"Favor procurar o Almoxarifado para correção ")
		lRet := .F.
	ENDIF

	IF lRetDC = .F.
		Alert(;
		"Há produto(s) sem endereçar " + chr(13)  + chr(13) + Chr(10) + ;
		"Esta operação não sera finalizada " + chr(13)  + chr(13) + Chr(10) + ;
		"Favor procurar o Almoxarifado para correção ")
		lRet := .F.
	ENDIF

	// Validação de Empenhos e Saldo
	/*If fValidSTR() = .F.
		lRet := .F.
	EndIf*/

	RestArea(aArea)

Return(lRet)

//*******************************************************************************
//* Funcao    | fValidSD4      | Autor | Roberto Fiuza  |  Data | 24/01/2017    *
//*******************************************************************************
//* Descricao | Validar se o componentes estao devidamente com a identificacao  *
//*           | do lote e endereco                                              *
//*****************************************************************************¹*
//* Uso       | VITAMEDIC                                                       *
//*******************************************************************************
Static function fValidSD4()

	Local _cQuery 	:= ""
	Local wRet      := .t.

	IF(SELECT("TMPD4") > 0)
		TMPD4->(DBCLOSEAREA())
	ENDIF

	_cQuery := " SELECT B1_COD,B1_RASTRO,B1_LOCALIZ,D4_LOTECTL,D4_DTVALID,D4_QTDEORI,D4_QUANT,D4_OP,D4_COD,D4_TRT "
	_cQuery += " FROM " + retsqlname("SD4")+" SD4 "
	_cQuery += " INNER JOIN " + retsqlname("SB1")+ " SB1 ON SB1.B1_FILIAL = SD4.D4_FILIAL AND SB1.B1_COD = SD4.D4_COD  "
	_cQuery += " WHERE SD4.D_E_L_E_T_ <> '*' "
	_cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
	_cQuery += " AND D4_ROTEIRO = '"+ SC2->C2_ROTEIRO 	+"' "
	_cQuery += " AND D4_OPERAC = '"	+ m->h6_operac		+"' "
	_cQuery += " AND D4_OP = '" 	+ m->h6_op 			+"' "
	_cQuery += " ORDER BY B1_COD "

	_cQuery :=changequery(_cQuery)
	tcquery _cQuery new alias "TMPD4"

	dbSelectArea("TMPD4")
	dbgotop()
	Do While !TMPD4->(Eof())
		IF B1_RASTRO = "L" .AND. D4_LOTECTL = "  "
			Alert("Produto " + alltrim(B1_COD) + " sem lote !!" )
			wRet	:= .F.
		ENDIF
		IF B1_RASTRO = "L" .AND. D4_DTVALID < dtos(dDataBase)
			Alert("Produto " + alltrim(B1_COD) + " lote vencido !!" )
			wRet	:= .F.
		ENDIF

		if B1_LOCALIZ = "S"
			fValidSDC()
		endif

		dbSelectArea("TMPD4")
		skip
	Enddo

Return wRet

//*******************************************************************************
//* Funcao    | fValidSDC      | Autor | Roberto Fiuza  |  Data | 14/03/2017    *
//*******************************************************************************
//* Descricao | Validar se o componentes estao devidamente com a identificacao  *
//*           | do lote e endereco                                              *
//*****************************************************************************¹*
//* Uso       | VITAMEDIC                                                       *
//*******************************************************************************
Static function fValidSDC()

	Local _cQuery 	:= ""

	IF(SELECT("TMPDC") > 0)
		TMPDC->(DBCLOSEAREA())
	ENDIF

	_cQuery := " SELECT DC_LOCALIZ,DC_LOTECTL,DC_QTDORIG,DC_QUANT "
	_cQuery += " FROM " + retsqlname("SDC")+" SDC "
	_cQuery += " WHERE DC_OP = '"    + TMPD4->D4_OP  + "' "
	_cQuery += " AND DC_PRODUTO = '" + TMPD4->D4_COD + "' "
	_cQuery += " AND DC_TRT = '"     + TMPD4->D4_TRT + "' "
	_cQuery += " AND D_E_L_E_T_ <> '*'

	_cQuery :=changequery(_cQuery)
	tcquery _cQuery new alias "TMPDC"

	dbSelectArea("TMPDC")
	dbgotop()

	IF empty(DC_LOCALIZ)
		Alert("Produto " + alltrim(TMPD4->D4_COD) + " sem endereço !!" )
		lRetDC	:= .F.
	ENDIF

	Do While !TMPDC->(Eof())
		IF empty(DC_LOCALIZ)
			Alert("Produto " + alltrim(TMPD4->D4_COD) + " sem endereço !!" )
			lRetDC	:= .F.
		ENDIF
		skip
	Enddo

Return lRetDC

//*******************************************************************************
//* Funcao    | fValidSTR      | Autor | Marcos Natã  |  Data | 17/10/2017      *
//*******************************************************************************
//* Descricao | Validar se todos os componentes da estrutura foram empenhados   *
//*           | e tem valor maior que zero.                                     *
//*****************************************************************************¹*
//* Uso       | VITAMEDIC                                                       *
//*******************************************************************************
Static Function fValidSTR()
	Local cRoteiro := Posicione("SC2", 9, xFilial("SC2") + SUBSTR(M->H6_OP, 1, 6) + SUBSTR(M->H6_OP, 7, 2) + M->H6_PRODUTO, "C2_ROTEIRO")
	Local cQry := ""
	Local lRet := .T.
	Local cProduto := ""
	Local cTRT := ""
	Local cComp := ""
	Local cGrupo := ""

	cQry =  "SELECT DISTINCT SG1.G1_COMP FROM SG1010 SG1 "
	cQry +=  "WHERE SG1.D_E_L_E_T_ <> '*' "
	cQry +=  "AND SG1.G1_COD = '"+M->H6_PRODUTO+"' "
	cQry +=  "AND SG1.G1_GROPC = ' ' " // Não avalia produtos opcionais
	cQry +=  "ORDER BY SG1.G1_COMP "
	cQry = ChangeQuery(cQry)

	If(Select("QRYG1") > 0)
		QRYG1->(DBCloseArea())
	EndIf

	TcQuery cQry New Alias "QRYG1"

	cQry =  "SELECT SD4.D4_COD, SD4.D4_QTDEORI FROM SD4010 SD4 "
	cQry +=  "WHERE SD4.D_E_L_E_T_ <> '*' "
	cQry +=  "AND SD4.D4_OP = '"+M->H6_OP+"' "
	cQry +=  "AND SD4.D4_ROTEIRO = '"+cRoteiro+"' "
	cQry +=  "ORDER BY SD4.D4_COD "
	cQry = ChangeQuery(cQry)

	If(Select("QRYD4") > 0)
		QRYD4->(DBCloseArea())
	EndIf

	TcQuery cQry New Alias "QRYD4"

	cQry =  "SELECT SG1.G1_COMP, SG1.G1_TRT, SG1.G1_GROPC FROM SG1010 SG1 "
	cQry +=  "WHERE SG1.D_E_L_E_T_ <> '*' "
	cQry +=  "AND SG1.G1_COD = '"+M->H6_PRODUTO+"' "
	cQry +=  "AND SG1.G1_GROPC <> ' ' "
	cQry +=  "ORDER BY SG1.G1_TRT, SG1.G1_GROPC "
	cQry = ChangeQuery(cQry)

	If(Select("QRYOPC") > 0)
		QRYOPC->(DBCloseArea())
	EndIf

	TcQuery cQry New Alias "QRYOPC"
	
	//--------------------------------------------------------------------
	//* Se não encontrar o produto nos empenhos não permite o apontamento.
	//--------------------------------------------------------------------
	QRYG1->(DbGoTop())
	While QRYG1->(!EOF()) // Estrutura do Produto
		If lRet
			lRet := .F.
			QRYD4->(DbGoTop())
			While QRYD4->(!EOF()) // Empenhos da O.P.
				If QRYD4->D4_COD = QRYG1->G1_COMP
					lRet := .T.
				EndIf
				QRYD4->(DbSkip())
			EndDo
		Else
			MsgAlert(AllTrim(cProduto) + " - " +;
			AllTrim(Posicione("SB1", 1, xFilial("SB1") + cProduto, "B1_DESC")) + " NÃO EMPENHADO.")
			Return .F.
		EndIf
		cProduto := QRYG1->G1_COMP
		QRYG1->(DbSkip())
	EndDo

	//-----------------------------------------------------------------------
	//* Se o produto tiver quantidade igual a zero não permite o apontamento.
	//-----------------------------------------------------------------------
	QRYD4->(DbGoTop())
	While QRYD4->(!EOF()) // Empenhos da O.P.
		If QRYD4->D4_QTDEORI = 0
			lRet := .F.
			MsgAlert(AllTrim(QRYD4->D4_COD) + " - " +;
			AllTrim(Posicione("SB1", 1, xFilial("SB1") + QRYD4->D4_COD, "B1_DESC")) + " SEM EMPENHO.")
			Exit
		EndIf
		QRYD4->(DbSkip())
	EndDo

	//----------------------------------------------------------
	//* Valida o empenho de um dos produtos dos grupos opcionais
	//* (Ao menos um produto do grupo deve ser empenhado)
	//----------------------------------------------------------
	QRYOPC->(DbGoTop())
	cTRT := QRYOPC->G1_TRT
	While QRYOPC->(!EOF()) // Estrutura do Produto
		If QRYOPC->G1_TRT = cTRT .And. Empty(cComp)
			QRYD4->(DbGoTop())
			While QRYD4->(!EOF()) // Empenhos da O.P.
				If QRYD4->D4_COD = QRYOPC->G1_COMP
					cComp := QRYOPC->G1_COMP
				EndIf
				QRYD4->(DbSkip())
			EndDo
		Else
			If Empty(cComp)
				MsgAlert("GRUPO OPCIONAL " + cGrupo + " DA ESTRUTURA NÃO EMPENHADO.")
				Return .F.
			EndIf
			cComp := ""
			QRYD4->(DbGoTop())
			While QRYD4->(!EOF()) // Empenhos da O.P.
				If QRYD4->D4_COD = QRYOPC->G1_COMP
					cComp := QRYOPC->G1_COMP
				EndIf
				QRYD4->(DbSkip())
			EndDo
		EndIf
		cProduto := QRYOPC->G1_COMP
		cTRT := QRYOPC->G1_TRT
		cGrupo := QRYOPC->G1_GROPC
		QRYOPC->(DbSkip())
		If QRYOPC->(EOF()) .And. Empty(cComp)
			MsgAlert("GRUPO OPCIONAL " + cGrupo + " DA ESTRUTURA NÃO EMPENHADO.")
			Return .F.
		EndIf
	EndDo

	QRYG1->(DBCloseArea())
	QRYD4->(DBCloseArea())
	QRYOPC->(DBCloseArea())

Return lRet
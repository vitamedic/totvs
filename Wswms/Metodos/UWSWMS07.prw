#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUWSWMS07  บAutor  ณMicrosiga           บ Data ณ  20/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para consulta de ORDEM DE PRODUวรO (ITENS)        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSWMS07(oFil, oRet)

	Local lOk := .T.
	Local cRet 		:= ""
	Local oXMLGet
	Local cMsgErr 	:= ""
	Local cMsgSuss 	:= ""
	Local cError   	:= ""
	Local cWarning 	:= ""
	Local cQry		:= ""
	Local nQtdReg	:= 0
	Local cDados	:= ""
	Local oNewItemOp
	Local cProdOP	:= ""
	Local lPI		:= .F.

	PRIVATE lMsErroAuto := .F.

	oRet:aRet    := {}
	oRet:lRet	 := .t.
	oRet:cErros  := ""
	oRet:nQtdReg := 0

	if empty(oFil:cEmpresa)
		oFil:cEmpresa := "01"
		oFil:cParFil  := "01"
	endif

	//se nใo foi configurado WS para ja vir logado na empresa e filial, fa็o cria็ใo do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U'
		RpcSetType(3)
		lConect := RpcSetEnv(oFil:cEmpresa, oFil:cFilial)
		if !lConect
			cMsgErr := "Nใo foi possํvel conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif

	if lOk .and. empty(oFil:cNumOp)
		cMsgErr := "Campo |cNumOp| nao preenchido. Campo obrigatorio."
		lOk := .F.
	endif
	
	//-----------------------------------------------------------------------
	// Verifica se existe PI na estrutura do produto (marcos.santos-20180316)
	//-----------------------------------------------------------------------

	cProdOP := Posicione("SC2", 1, xFilial("SC2") + oFil:cNumOp, "C2_PRODUTO")

	cQry :=        " SELECT G1_COMP "
	cQry += CRLF + " 	FROM "+ RetSqlName("SG1") +" "
	cQry += CRLF + " 	WHERE D_E_L_E_T_ <> '*' "
	cQry += CRLF + " 		AND G1_FILIAL = '"+ xFilial("SG1") +"' "
	cQry += CRLF + " 		AND G1_COD = '"+ cProdOP +"' "
	cQry += CRLF + " 		AND G1_COMP LIKE 'P%' "
	cQry := ChangeQuery(cQry)

	If Select("QRYG1") > 0
		QRYG1->(DbCloseArea())
	EndIf

	TcQuery cQry New Alias "QRYG1"

	QRYG1->(dbGoTop())
	While QRYG1->(!EOF())
		If Posicione("SB1", 1, xFilial("SB1") + QRYG1->G1_COMP, "B1_TIPO") == "PI"
			lPI := .T.
		EndIf
		QRYG1->(dbSkip())
	End

	if lOK
		//Consulta substituํda por causa dos PE`s - MTA650I e A650PROC
		/*
		cQry :=        " SELECT SC2.C2_LOTECTL, SC2.C2_EMISSAO, SC2.C2_STATUS, SC2.C2_REVI, SC2.C2_TPOP "
		cQry += CRLF + "      , SD4.*, B1F.B1_LOCPAD, B1E.B1_DESC DESC_ITEM, B1E.B1_UM UM_ITEM, B1E.B1_TIPO TIPO_ITEM "
		cQry += CRLF + "      , SG1.G1_CLASSE "
		cQry += CRLF + " FROM " + RetSqlName("SC2") + " SC2 "
		cQry += CRLF + " INNER JOIN " + RetSqlName("SB1") + " B1F "
		cQry += CRLF + "   ON ( B1F.B1_FILIAL      = '" + xFilial("SB1") + "'"
		cQry += CRLF + " 		AND B1F.B1_COD     = SC2.C2_PRODUTO"
		cQry += CRLF + " 		AND B1F.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "      ) "
		cQry += CRLF + " INNER JOIN " + RetSqlName("SD4") + " SD4 "
		cQry += CRLF + "   ON ( SD4.D4_FILIAL      = '" + xFilial("SD4") + "'"
		cQry += CRLF + " 		AND SD4.D4_OP      = (SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN)"
		cQry += CRLF + " 		AND SD4.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "      ) "
		cQry += CRLF + " INNER JOIN " + RetSqlName("SG1") + " SG1 "
		cQry += CRLF + "   ON ( SG1.G1_FILIAL      = '" + xFilial("SG1") + "'"
		cQry += CRLF + " 		AND SG1.G1_COD     = SC2.C2_PRODUTO"
		cQry += CRLF + " 		AND SG1.G1_COMP    = SD4.D4_COD"
		cQry += CRLF + " 		AND SG1.G1_TRT     = SD4.D4_TRT"
		cQry += CRLF + " 		AND SG1.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "      ) "
		cQry += CRLF + " INNER JOIN " + RetSqlName("SB1") + " B1E "
		cQry += CRLF + "   ON ( B1E.B1_FILIAL      = '" + xFilial("SB1") + "'"
		cQry += CRLF + " 		AND B1E.B1_COD     = SD4.D4_COD"
		cQry += CRLF + " 		AND B1E.D_E_L_E_T_ <> '*' "
		if !empty(oFil:cTpProd)
		cQry += CRLF + "        AND B1E.B1_TIPO = '"+oFil:cTpProd+"' "
		endif
		cQry += CRLF + "      ) "
		cQry += CRLF + " WHERE SC2.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "   AND SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
		cQry += CRLF + "   AND (SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN) = '"+oFil:cNumOp+"' "
		cQry += CRLF + " ORDER BY SD4.D4_OP, SD4.D4_COD, SD4.D4_TRT "
		*/

		If lPI
			//-------------------------------------------------------------------------------
			// Envia quantidades propocionais a emissใo da ordem (Para produto que cont้m PI)
			//-------------------------------------------------------------------------------
			cQry :=        " SELECT SC2.C2_LOTECTL, SC2.C2_EMISSAO, SC2.C2_STATUS, SC2.C2_REVI, SC2.C2_TPOP "
			cQry += CRLF + "      , Z50.*, B1F.B1_LOCPAD, B1E.B1_DESC DESC_ITEM, B1E.B1_UM UM_ITEM, B1E.B1_TIPO TIPO_ITEM "
			cQry += CRLF + "      , SG1.G1_CLASSE, B1E.B1_POTENCI "
			cQry += CRLF + " FROM " + RetSqlName("SC2") + " SC2 "
			cQry += CRLF + " INNER JOIN " + RetSqlName("SB1") + " B1F "
			cQry += CRLF + "   ON ( B1F.B1_FILIAL      = '" + xFilial("SB1") + "'"
			cQry += CRLF + " 		AND B1F.B1_COD     = SC2.C2_PRODUTO"
			cQry += CRLF + " 		AND B1F.D_E_L_E_T_ <> '*' "
			cQry += CRLF + "      ) "
			cQry += CRLF + " INNER JOIN " + RetSqlName("Z50") + " Z50 "
			cQry += CRLF + "   ON ( Z50.Z50_FILIAL      = '" + xFilial("Z50") + "'"
			cQry += CRLF + " 		AND Z50.Z50_OP      = (SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN)"
			cQry += CRLF + " 		AND Z50.D_E_L_E_T_ <> '*' "
			cQry += CRLF + "      ) "
			cQry += CRLF + " INNER JOIN " + RetSqlName("SG1") + " SG1 "
			cQry += CRLF + "   ON ( SG1.G1_FILIAL      = '" + xFilial("SG1") + "'"
			cQry += CRLF + " 		AND SG1.G1_COD     = SC2.C2_PRODUTO"
			cQry += CRLF + " 		AND SG1.G1_COMP    = Z50.Z50_COD"
			cQry += CRLF + " 		AND SG1.G1_TRT     = Z50.Z50_TRT"
			cQry += CRLF + " 		AND SG1.D_E_L_E_T_ <> '*' "
			cQry += CRLF + "      ) "
			cQry += CRLF + " INNER JOIN " + RetSqlName("SB1") + " B1E "
			cQry += CRLF + "   ON ( B1E.B1_FILIAL      = '" + xFilial("SB1") + "'"
			cQry += CRLF + " 		AND B1E.B1_COD     = Z50.Z50_COD"
			cQry += CRLF + " 		AND B1E.D_E_L_E_T_ <> '*' "
			if !empty(oFil:cTpProd)
			cQry += CRLF + "        AND B1E.B1_TIPO = '"+oFil:cTpProd+"' "
			endif
			cQry += CRLF + "      ) "
			cQry += CRLF + " WHERE SC2.D_E_L_E_T_ <> '*' "
			cQry += CRLF + "   AND SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
			cQry += CRLF + "   AND (SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN) = '"+oFil:cNumOp+"' "
			cQry += CRLF + " ORDER BY Z50.Z50_OP, Z50.Z50_COD, Z50.Z50_TRT "
		Else
			//--------------------------------------------------------------------------------
			// Envia quantidades baseada na estrutura do produto (Para ordens lineares sem PI)
			//--------------------------------------------------------------------------------
			cQry :=  "SELECT DISTINCT " + CRLF
			cQry +=  "  SC2.C2_LOTECTL, " + CRLF
			cQry +=  "  SC2.C2_EMISSAO, " + CRLF
			cQry +=  "  SC2.C2_STATUS, " + CRLF
			cQry +=  "  SC2.C2_REVI, " + CRLF
			cQry +=  "  SC2.C2_TPOP, " + CRLF
			cQry +=  "  Z50.Z50_FILIAL, " + CRLF
			cQry +=  "  Z50.Z50_OP, " + CRLF
			cQry +=  "  Z50.Z50_PRODUT, " + CRLF
			cQry +=  "  Z50.Z50_COD, " + CRLF
			cQry +=  "  Z50.Z50_OPERAC, " + CRLF
			cQry +=  "  SG1.G1_QUANT, " + CRLF
			cQry +=  "  SG1.G1_TRT, " + CRLF
			cQry +=  "  SG1.G1_CLASSE, " + CRLF
			cQry +=  "  SB1.B1_DESC DESC_ITEM, " + CRLF
			cQry +=  "  SB1.B1_UM   UM_ITEM, " + CRLF
			cQry +=  "  SB1.B1_TIPO TIPO_ITEM, " + CRLF
			cQry +=  "  SB1.B1_POTENCI " + CRLF
			cQry +=  "FROM Z50010 Z50 " + CRLF
			cQry +=  "  INNER JOIN " + RetSqlName("SG1") + " SG1 ON (SG1.G1_FILIAL = '" + xFilial("SG1") + "' " + CRLF
			cQry +=  "                            AND SG1.D_E_L_E_T_ <> '*' " + CRLF
			cQry +=  "                            AND SG1.G1_COD = Z50_PRODUT " + CRLF
			cQry +=  "                            AND SG1.G1_COMP = Z50.Z50_COD " + CRLF
			cQry +=  "                            AND SG1.G1_TRT = Z50.Z50_TRT) " + CRLF
			cQry +=  "  INNER JOIN " + RetSqlName("SC2") + " SC2 ON (SC2.C2_FILIAL = '" + xFilial("SC2") + "' " + CRLF
			cQry +=  "                            AND SC2.D_E_L_E_T_ <> '*' " + CRLF
			cQry +=  "                            AND (SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN) = Z50.Z50_OP) " + CRLF
			cQry +=  "  INNER JOIN " + RetSqlName("SB1") + " SB1 ON (SB1.B1_FILIAL = '" + xFilial("SB1") + "' " + CRLF
			cQry +=  "                            AND SB1.D_E_L_E_T_ <> '*' " + CRLF
			cQry +=  "                            AND SB1.B1_COD = Z50.Z50_COD " + CRLF
			If !Empty(oFil:cTpProd)
				cQry +=  "        AND SB1.B1_TIPO = '"+oFil:cTpProd+"' " + CRLF
			EndIf
			cQry +=  ") " + CRLF
			cQry +=  "WHERE Z50.Z50_FILIAL = '" + xFilial("Z50") + "' " + CRLF
			cQry +=  "      AND Z50.D_E_L_E_T_ <> '*' " + CRLF
			cQry +=  "      AND Z50.Z50_OP = '"+oFil:cNumOp+"' " + CRLF
			cQry +=  "ORDER BY SG1.G1_TRT "
		EndIf

		cQry := ChangeQuery(cQry)

		If Select("QRYWS7") > 0
			QRYWS7->(DbCloseArea())
		EndIf

		TcQuery cQry New Alias "QRYWS7" // Cria uma nova area com o resultado do query

		QRYWS7->(dbGoTop())

		while QRYWS7->(!Eof())

			oNewItemOp :=  WSClassNew( "WSItensOp" )

			oNewItemOp:FILIAL				:= QRYWS7->Z50_FILIAL
			oNewItemOp:NUM_OP				:= QRYWS7->Z50_OP
			oNewItemOp:SEQ_ESTRU	 		:= IIF(lPI, AllTrim(QRYWS7->Z50_TRT), AllTrim(QRYWS7->G1_TRT))
			oNewItemOp:COD_ITEM	 			:= AllTrim(QRYWS7->Z50_COD)
			oNewItemOp:QTD_REQ		 		:= IIF(lPI, NoRound(QRYWS7->Z50_QUANT,2), NoRound(QRYWS7->G1_QUANT,2))
			oNewItemOp:QTD_ALOCADA	 		:= 0
			oNewItemOp:LOTE_PREALOC 		:= ''
			oNewItemOp:LOCAL_LOTE_PREALOC 	:= ''
			oNewItemOp:DEP_LOTE_PREALOC 	:= ''
			oNewItemOp:QTD_ATEND	 		:= IIF(lPI, NoRound(QRYWS7->Z50_QUANT,2), NoRound(QRYWS7->G1_QUANT,2))
			oNewItemOp:FASE_OPER		 	:= AllTrim(QRYWS7->Z50_OPERAC)
			oNewItemOp:LINHA_DO_BOM	 		:= IIF(lPI, AllTrim(QRYWS7->Z50_TRT), AllTrim(QRYWS7->G1_TRT))
			oNewItemOp:DESC_ITEM	 		:= AllTrim(QRYWS7->DESC_ITEM)
			oNewItemOp:UM_ITEM			 	:= QRYWS7->UM_ITEM
			oNewItemOp:CLASSE_ITEM	 		:= QRYWS7->G1_CLASSE
			oNewItemOp:POTENC_ITEM	 		:= NoRound(QRYWS7->B1_POTENCI,2)
			oNewItemOp:STATUS_OP	 		:= QRYWS7->C2_STATUS
			oNewItemOp:UM_ESTQ_ITEM	 		:= QRYWS7->UM_ITEM
			oNewItemOp:TIPO_ITEM		 	:= QRYWS7->TIPO_ITEM

			AAdd( oRet:aRet, oNewItemOp )

			nQtdReg++

			QRYWS7->(DbSkip())

		enddo

		QRYWS7->(DbCloseArea())
	endif

	oRet:cErros	 := cMsgErr
	oRet:lRet	 := lOK
	oRet:nQtdReg := nQtdReg

Return(.t.)
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUWSWMS04  บAutor  ณMicrosiga           บ Data ณ  20/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para consulta de Lotes                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSWMS04(oFil, oRet)

	Local lOk 		:= .T.
	Local cMsgErr 	:= ""
	Local cError   	:= ""
	Local cWarning 	:= ""
	Local cQry		:= ""
	Local nQtdReg	:= 0
	Local cDados	:= ""
	Local MV_CQ     := GetMV("MV_CQ")
	Local oNewLote
	Local cDtFab, cDtValid
	Local lAltFab := .F.
	Local lAltVal := .F.

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

	if lOK

		cQry :=        " SELECT DISTINCT "
		cQry += CRLF + "        SB8.B8_LOTECTL "
		cQry += CRLF + "      , SB8.B8_DFABRIC "
		cQry += CRLF + "      , SB8.B8_DTVALID "
		cQry += CRLF + "      , SB8.B8_LOCAL "
		cQry += CRLF + "      , SB8.B8_PRODUTO "
		cQry += CRLF + "      , SB1.B1_DESC "
		cQry += CRLF + "      , SB8.B8_CLIFOR "
		cQry += CRLF + "      , SB8.B8_LOJA "
		cQry += CRLF + "      , SB8.B8_LOTEFOR "
		cQry += CRLF + "      , SB1.B1_LOCPAD "
		cQry += CRLF + "      , SB1.B1_DESC "
		cQry += CRLF + "      , SA2.A2_NOME "
		cQry += CRLF + " FROM " + RetSqlName("SB8") + " SB8 "
		cQry += CRLF + " INNER JOIN " + RetSqlName("SB1") + " SB1 "
		cQry += CRLF + "   ON ( SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
		cQry += CRLF + " 		 AND SB1.B1_COD = SB8.B8_PRODUTO"
		cQry += CRLF + " 		 AND SB1.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "      ) "
		cQry += CRLF + " LEFT JOIN " + RetSqlName("SA2") + " SA2 "
		cQry += CRLF + "   ON ( SA2.A2_FILIAL   = '" + xFilial("SA2") + "'"
		cQry += CRLF + " 		 AND SA2.A2_COD  = SB8.B8_CLIFOR"
		cQry += CRLF + " 		 AND SA2.A2_LOJA = SB8.B8_LOJA"
		cQry += CRLF + " 		 AND SA2.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "      ) "
		cQry += CRLF + " WHERE SB8.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "   AND SB8.B8_FILIAL  = '" + xFilial("SB8") + "' "
		cQry += CRLF + "   AND SB8.B8_PRODUTO = '"+Alltrim(oFil:cCodProd)+"' "
		if !empty(oFil:cLoteDe)
			cQry += CRLF + "   AND SB8.B8_LOTECTL >= '"+Alltrim(oFil:cLoteDe)+"' "
		endif
		if !empty(oFil:cLoteAte)
			cQry += CRLF + "   AND SB8.B8_LOTECTL <= '"+Alltrim(oFil:cLoteAte)+"' "
		endif
		cQry += CRLF + " ORDER BY SB8.B8_LOTECTL, SB8.B8_CLIFOR, SB8.B8_LOJA, SB8.B8_PRODUTO "

		cQry := ChangeQuery(cQry)

		If Select("QRYWS4") > 0
			QRYWS4->(DbCloseArea())
		EndIf

		TcQuery cQry New Alias "QRYWS4"
		
		QRYWS4->(DbGoTop())

		// Se nใo houver registros na SB8 serแ realizado uma busca na SC2 (Natใ Santos - 10/10/2017)
		If QRYWS4->(EOF())
			cQry :=  "SELECT "
			cQry +=  "  SC2.C2_LOTECTL, "
			cQry +=  "  SC2.C2_DATPRI, "
			cQry +=  "  SC2.C2_DTVALID, "
			cQry +=  "  SC2.C2_LOCAL, "
			cQry +=  "  SC2.C2_PRODUTO, "
			cQry +=  "  SB1.B1_DESC, "
			cQry +=  "  SB1.B1_LOCPAD "
			cQry +=  "FROM " + RetSqlName("SC2") + " SC2 "
			cQry +=  "  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_COD = SC2.C2_PRODUTO AND SB1.D_E_L_E_T_ = ' '"
			cQry +=  "WHERE SC2.D_E_L_E_T_ = ' ' "
			cQry +=  "      AND SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
			cQry +=  "      AND SC2.C2_PRODUTO = '"+Alltrim(oFil:cCodProd)+"' "
			if !empty(oFil:cLoteDe)
				cQry += "   AND SC2.C2_LOTECTL >= '"+Alltrim(oFil:cLoteDe)+"' "
			endif
			if !empty(oFil:cLoteAte)
				cQry += "   AND SC2.C2_LOTECTL <= '"+Alltrim(oFil:cLoteAte)+"' "
			endif
			cQry +=  "ORDER BY SC2.C2_LOTECTL, C2_PRODUTO "

			cQry := ChangeQuery(cQry)

			If Select("QRYWS4") > 0
				QRYWS4->(DbCloseArea())
			EndIf

			TcQuery cQry New Alias "QRYWS4"

			QRYWS4->(dbGoTop())

			While QRYWS4->(!Eof())

				oNewLote :=  WSClassNew( "WSLotes" )

				oNewLote:NUM_LOTE	 := Alltrim(QRYWS4->C2_LOTECTL)
				oNewLote:DATA_FAB	 := DtoC(StoD(QRYWS4->C2_DATPRI))
				oNewLote:DATA_VALID	 := DtoC(StoD(QRYWS4->C2_DTVALID))
				oNewLote:STATUS_LOTE := QRYWS4->(Iif(C2_LOCAL == MV_CQ, "Quarentena", Iif(B1_LOCPAD == MV_CQ, "Aprovado", "")))
				oNewLote:COD_PROD	 := AllTrim(QRYWS4->C2_PRODUTO)
				oNewLote:DESC_PROD	 := AllTrim(QRYWS4->B1_DESC)
				oNewLote:COD_FOR	 := SPACE(6)
				oNewLote:NOME_FOR 	 := SPACE(4)
				oNewLote:LOTE_FOR 	 := SPACE(10)

				AAdd( oRet:aRet, oNewLote )

				nQtdReg++

				QRYWS4->(DbSkip())
			EndDo

			QRYWS4->(DbCloseArea())
		Else
			QRYWS4->(dbGoTop())

			While QRYWS4->(!Eof())

				oNewLote :=  WSClassNew( "WSLotes" )

				// Altera็ใo Marcos Natใ 05/10/2017 - INICIO
				cDtFab := DtoC(StoD(""))
				cDtValid := DtoC(StoD(""))
				lAltFab := .F.
				lAltVal := .F.

				// Verifica็ใo se o lote tem origem na SC2 ou SD1 para pegar data fabri็ใo/data validade
				cQry := " SELECT 'SC2' TIPO, C2_DATPRI DTFAB, C2_DTVALID DTVALID FROM " + RetSqlName("SC2") + " SC2 "
				cQry += " WHERE SC2.D_E_L_E_T_ <> '*' AND C2_PRODUTO = '"+QRYWS4->B8_PRODUTO+"' "
				cQry += "   AND C2_LOTECTL = '"+QRYWS4->B8_LOTECTL+"' "
				cQry += " UNION "
				cQry += " SELECT 'SD1' TIPO, D1_DTFABR DTFAB, D1_DTVALID DTVALID FROM " + RetSqlName("SD1") + " SD1 "
				cQry += " WHERE SD1.D_E_L_E_T_ <> '*' AND D1_COD = '"+QRYWS4->B8_PRODUTO+"' "
				cQry += "   AND D1_LOTECTL = '"+QRYWS4->B8_LOTECTL+"' "
				cQry := ChangeQuery(cQry)
				If Select("QRYAUX") > 0
					QRYAUX->(DbCloseArea())
				EndIf
				TcQuery cQry New Alias "QRYAUX"
				QRYAUX->(dbGoTop())
				While QRYAUX->(!Eof())

					if !empty(QRYAUX->DTFAB) .AND. !lAltFab
						cDtFab := DtoC(StoD(QRYAUX->DTFAB))
						lAltFab := .T.
					endif
					if !empty(QRYAUX->DTVALID) .AND. !lAltVal
						cDtValid := DtoC(StoD(QRYAUX->DTVALID))
						lAltVal := .T.
					endif
					if lAltFab .AND. lAltVal //se preencheu as duas
						EXIT
					endif

					QRYAUX->(DbSkip())
				enddo
				QRYAUX->(DbCloseArea())
				// Altera็ใo Marcos Natใ 05/10/2017 - FIM

				oNewLote:NUM_LOTE	 := Alltrim(QRYWS4->B8_LOTECTL)
				oNewLote:DATA_FAB	 := cDtFab
				oNewLote:DATA_VALID	 := cDtValid
				oNewLote:STATUS_LOTE := QRYWS4->(Iif(B8_LOCAL == MV_CQ, "Quarentena", Iif(B1_LOCPAD == MV_CQ, "Aprovado", "")))
				oNewLote:COD_PROD	 := AllTrim(QRYWS4->B8_PRODUTO)
				oNewLote:DESC_PROD	 := AllTrim(QRYWS4->B1_DESC)
				oNewLote:COD_FOR	 := AllTrim(QRYWS4->(B8_CLIFOR+B8_LOJA))
				oNewLote:NOME_FOR 	 := AllTrim(QRYWS4->A2_NOME)
				oNewLote:LOTE_FOR 	 := AllTrim(QRYWS4->B8_LOTEFOR)

				AAdd( oRet:aRet, oNewLote )

				nQtdReg++

				QRYWS4->(DbSkip())
			enddo

			QRYWS4->(DbCloseArea())
		EndIf
	endif

	oRet:cErros	 := cMsgErr
	oRet:lRet	 := lOK
	oRet:nQtdReg := nQtdReg

Return(.t.)
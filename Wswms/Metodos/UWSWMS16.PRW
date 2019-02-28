#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUWSWMS16  บAutor  ณMicrosiga           บ Data ณ  19/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para consulta de Produto, lote e validade.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSWMS16(oFil, oRet)

	Local lOk        := .T.
	Local cMsgErr 	 := ""
	Local cQry		 := ""
	Local nQtdReg	 := 0
	Local cMv_CQ	 := Alltrim(SuperGetMv("MV_CQ",,""))
	Local cMv_Rep    := " IN ('"+ StrTran(AllTrim(SuperGetMv("MV_XLOCREP",, "")),";","','") +"')"
	Local cArmazens  := ""
	Local aEnderecos := {}
	Local oNewEstoque
	Local cDtFab, cDtValid
	Local lAltFab := .F.
	Local lAltVal := .F.

	PRIVATE lMsErroAuto := .F.

	oRet:aRet 	 := {}
	oRet:lRet	 := .t.
	oRet:cErros	 := ""
	oRet:nQtdReg := 0

	if empty(oFil:cEmpresa)
		oFil:cEmpresa := "01"
		oFil:cParFil  := "01"
	endif

	//se nใo foi configurado WS para ja vir logado na empresa e filial, fa็o cria็ใo do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U'
		RpcSetType(3)
		lConect := RpcSetEnv(Fil_TpProd:cEmpresa, Fil_TpProd:cFilial)
		if !lConect
			cMsgErr := "Nใo foi possํvel conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif

	cArmazens := ""
	for nX := 1 to len(oFil:aArmazens)
		if !empty(oFil:aArmazens[nX]:cFiltro) .and. oFil:aArmazens[nX]:cFiltro <> "?"
			if empty(cArmazens)
				cArmazens := " IN ("
			else
				cArmazens += ","
			endif
			cArmazens += "'"+oFil:aArmazens[nX]:cFiltro+"'"
		endif
	next nX
	if !empty(cArmazens)
		cArmazens += ")"
	endif

	aEnderecos := {}
	for nX := 1 to len(oFil:aEnderecos)
		if !empty(oFil:aEnderecos[nX]:cFiltro) .and. oFil:aEnderecos[nX]:cFiltro <> "?"
			AAdd(aEnderecos, oFil:aEnderecos[nX]:cFiltro)
		endif
	next nX

	if lOK
		cQry :=        " SELECT Q.FILIAL "
		cQry += CRLF + "      , Q.PRODUTO "
		cQry += CRLF + "      , Q.LOTECTL "
		cQry += CRLF + "      , Q.STATUS_LOTE "
		cQry += CRLF + "      , Q.ARMAZEM "
		cQry += CRLF + "      , Q.ENDERECO "
		cQry += CRLF + "      , Q.B1_DESC "
		cQry += CRLF + "      , Q.DFABRIC "
		cQry += CRLF + "      , Q.DTVALID "
		cQry += CRLF + "      , Q.POTENCI "
		cQry += CRLF + "      , Q.B1_UM "
		cQry += CRLF + "      , Q.B1_CONV "
		cQry += CRLF + "      , Q.LOTEFOR "
		cQry += CRLF + "      , Q.CLIFOR "
		cQry += CRLF + "      , Q.LOJA "
		cQry += CRLF + "      , Q.B1_LOCPAD "
		cQry += CRLF + "      , Q.FABRICANTE "
		cQry += CRLF + "      , Q.LOTFABR "
		cQry += CRLF + "      , Q.DTFABR "
		cQry += CRLF + "      , SUM(Q.QUANT)   QUANT "
		cQry += CRLF + "      , SUM(Q.EMPENHO) EMPENHO "
		cQry += CRLF + " FROM ( SELECT BF_FILIAL 				FILIAL 													"
		cQry += CRLF + "             , BF_PRODUTO 				PRODUTO													"
		cQry += CRLF + "             , BF_LOTECTL 				LOTECTL													"
		//cQry += CRLF + "             , Case When BF_LOCAL = " + cMv_CQ + " Then B1_LOCPAD Else BF_LOCAL End ARMAZEM 	"
		cQry += CRLF + "             , BF_LOCAL 				ARMAZEM 												"
		cQry += CRLF + "             , Case When BF_LOCAL = " + cMv_CQ + " Then '1' 									"
		cQry += CRLF + "                    When BF_LOCAL " + cMv_Rep + " Then '3' 										"
		cQry += CRLF + "                    Else '2' 																	"
		cQry += CRLF + "               End            			STATUS_LOTE 											"
		cQry += CRLF + "             , BF_LOCALIZ 				ENDERECO 												"
		cQry += CRLF + "             , B1_DESC 																			"
		cQry += CRLF + "             , B8_DFABRIC 				DFABRIC 												"
		cQry += CRLF + "             , B8_DTVALID 				DTVALID 												"
		cQry += CRLF + "             , B8_POTENCI 				POTENCI 												"
		cQry += CRLF + "             , BF_QUANT   				QUANT 													"
		//cQry += CRLF + "             , Case When SB1.B1_TIPO In 'PA' Then 0 Else BF_EMPENHO End EMPENHO 				"
		cQry += CRLF + "             , BF_EMPENHO 				EMPENHO 												"
		cQry += CRLF + "             , B1_UM 																			"
		cQry += CRLF + "             , B1_CONV 																			"
		cQry += CRLF + "             , SD1.D1_LOTEFOR 			LOTEFOR 												"
		cQry += CRLF + "             , SD1.D1_FORNECE  			CLIFOR 													"
		cQry += CRLF + "             , SD1.D1_LOJA 	 			LOJA 													"
		cQry += CRLF + "             , B1_LOCPAD 																		"
		cQry += CRLF + "             , SD1.D1_FABRIC			FABRICANTE 												"
		cQry += CRLF + "             , SD1.D1_LOTFABR			LOTFABR 												"
		cQry += CRLF + "             , SD1.D1_DTFABR			DTFABR 													"
		cQry += CRLF + "        FROM " + RetSqlName("SBF") + " SBF "
		cQry += CRLF + "        INNER JOIN " + RetSqlName("SBE") + " SBE "
		cQry += CRLF + "        ON (	SBE.D_E_L_E_T_ <> '*' AND "
		cQry += CRLF + " 	       SBE.BE_FILIAL  = SBF.BF_FILIAL AND "
		cQry += CRLF + " 	       SBE.BE_LOCAL   = SBF.BF_LOCAL AND "
		cQry += CRLF + " 	       SBE.BE_LOCALIZ = SBF.BF_LOCALIZ) "
		cQry += CRLF + "        INNER JOIN " + RetSqlName("SB8") + " SB8 "
		cQry += CRLF + "        ON (SB8.D_E_L_E_T_ <> '*' AND "
		cQry += CRLF + " 	       SB8.B8_FILIAL  = BF_FILIAL AND "
		cQry += CRLF + " 	       SB8.B8_PRODUTO = BF_PRODUTO AND "
		cQry += CRLF + " 	       SB8.B8_LOCAL   = BF_LOCAL AND "
		cQry += CRLF + " 	       SB8.B8_LOTECTL = BF_LOTECTL) "
		cQry += CRLF + "        LEFT JOIN " + RetSqlName("SD1") + " SD1 "
		cQry += CRLF + "        ON ( SD1.D1_FILIAL   = '" + xFilial("SD1") + "' AND "
		cQry += CRLF + " 	         SD1.D1_COD      = SB8.B8_PRODUTO AND "
		cQry += CRLF + " 	         SD1.D1_LOTECTL  = SB8.B8_LOTECTL AND "
		cQry += CRLF + " 	         SD1.D1_FABRIC   <> ' ' AND "
		cQry += CRLF + " 	         SD1.D_E_L_E_T_  <> '*' ) "
		cQry += CRLF + "        INNER JOIN " + RetSqlName("SB1") + " SB1 "
		cQry += CRLF + "        ON (	SB1.D_E_L_E_T_ <> '*' AND "
		cQry += CRLF + " 	       B1_FILIAL = '" + xFilial("SB1") + "' AND "
		cQry += CRLF + " 	       B1_COD = BF_PRODUTO ) "
		cQry += CRLF + "        WHERE SBF.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "        AND BF_FILIAL = '" + xFilial("SBF") + "' "
		//cQry += CRLF + "        AND (SBF.BF_QUANT-SBF.BF_EMPENHO) > 0 " //somente com saldo

		//cQry += CRLF + "        AND ((SB1.B1_TIPO = 'PA' AND SBF.BF_QUANT > 0) OR ((SBF.BF_QUANT-SBF.BF_EMPENHO) > 0)) " //somente com saldo

		if !empty(Alltrim(oFil:cProduto)) .and. Alltrim(oFil:cProduto) <> "?"
			cQry += CRLF + "        AND BF_PRODUTO = '" + Alltrim(oFil:cProduto) + "' "
		endif

		if !empty(oFil:cNumLote)
			cQry += CRLF + "        AND BF_LOTECTL = '" + Alltrim(oFil:cNumLote) + "' "
		endif

		if !empty(cArmazens)
			if cMv_CQ $ cArmazens //se armaz้m do CQ estiver dentro do filtro
				cQry += CRLF + "        AND (BF_LOCAL " + cArmazens + " OR BF_LOCAL = B1_LOCPAD) "
			else
				cQry += CRLF + "        AND (BF_LOCAL " + cArmazens + " "
				cQry += CRLF + "             OR (BF_LOCAL = '" + cMv_CQ + "' AND B1_LOCPAD " + cArmazens + ") "
				cQry += CRLF + "            )
			endif
		endif

		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "          SELECT B8_FILIAL 										FILIAL 		"
		cQry += CRLF + "               , B8_PRODUTO 									PRODUTO 	"
		cQry += CRLF + "               , B8_LOTECTL 									LOTECTL 	"
		cQry += CRLF + "               , B8_LOCAL   									ARMAZEM 	"
		cQry += CRLF + "               , Case When B8_LOCAL = " + cMv_CQ + " Then '1' 				"
		cQry += CRLF + "                      When B8_LOCAL " + cMv_Rep + " Then '3' 				"
		cQry += CRLF + "                      Else '2' 												"
		cQry += CRLF + "                 End            								STATUS_LOTE "
		cQry += CRLF + "               , 'PISO' 		ENDERECO 									"
		cQry += CRLF + "               , B1_DESC 													"
		cQry += CRLF + "               , B8_DFABRIC 	DFABRIC 									"
		cQry += CRLF + "               , B8_DTVALID 	DTVALID 									"
		cQry += CRLF + "               , B8_POTENCI 	POTENCI 									"
		cQry += CRLF + "               , B8_QACLASS 	QUANT 										"
		cQry += CRLF + "               , 0 				EMPENHO										"
		cQry += CRLF + "               , B1_UM 														"
		cQry += CRLF + "               , B1_CONV 													"
		cQry += CRLF + "               , SD1.D1_LOTEFOR	LOTEFOR 									"
		cQry += CRLF + "               , SD1.D1_FORNECE	CLIFOR 										"
		cQry += CRLF + "               , SD1.D1_LOJA	LOJA 										"
		cQry += CRLF + "               , B1_LOCPAD 		LOCPAD 										"
		cQry += CRLF + "               , SD1.D1_FABRIC	FABRICANTE 									"
		cQry += CRLF + "               , SD1.D1_LOTFABR	LOTFABR 									"
		cQry += CRLF + "               , SD1.D1_DTFABR	DTFABR 										"
		cQry += CRLF + "        FROM " + RetSqlName("SDA") + " SDA "
		cQry += CRLF + "        LEFT JOIN " + RetSqlName("SD1") + " SD1 "
		cQry += CRLF + "                ON ( SD1.D1_FILIAL   = '" + xFilial("SD1") + "' AND "
		cQry += CRLF + " 	                 SD1.D1_COD      = SDA.DA_PRODUTO AND "
		cQry += CRLF + " 	                 SD1.D1_LOTECTL  = SDA.DA_LOTECTL AND "
		cQry += CRLF + " 	                 SD1.D1_FABRIC   <> ' ' AND "
		cQry += CRLF + " 	                 SD1.D_E_L_E_T_  <> '*' ) "
		cQry += CRLF + "        INNER JOIN " + RetSqlName("SB8") + " SB8 "
		cQry += CRLF + "                ON ( SB8.D_E_L_E_T_ <> '*' AND "
		cQry += CRLF + " 	                 SB8.B8_FILIAL   = DA_FILIAL AND "
		cQry += CRLF + " 	                 SB8.B8_PRODUTO  = DA_PRODUTO AND "
		cQry += CRLF + " 	                 SB8.B8_LOCAL    = DA_LOCAL AND "
		cQry += CRLF + " 	                 SB8.B8_LOTECTL  = DA_LOTECTL) "
		cQry += CRLF + "        INNER JOIN " + RetSqlName("SB1") + " SB1 "
		cQry += CRLF + "                ON ( SB1.D_E_L_E_T_ <> '*' AND "
		cQry += CRLF + " 	                 SB1.B1_FILIAL   = '" + xFilial("SB1") + "' AND "
		cQry += CRLF + " 	                 SB1.B1_COD      = SDA.DA_PRODUTO ) "
		cQry += CRLF + "        WHERE SDA.D_E_L_E_T_ <> '*' "
		//cQry += CRLF + "          AND SDA.DA_XENDERE  = 'PISO'  "
		cQry += CRLF + "          AND SDA.DA_FILIAL   = '" + xFilial("SDA") + "' "
		//cQry += CRLF + "          AND SB8.B8_QACLASS  > 0 " //somente com saldo a endere็ar

		if !empty(Alltrim(oFil:cProduto)) .and. Alltrim(oFil:cProduto) <> "?"
			cQry += CRLF + "          AND SDA.DA_PRODUTO  = '" + Alltrim(oFil:cProduto) + "' "
		endif

		if !empty(oFil:cNumLote)
			cQry += CRLF + "        AND SDA.DA_LOTECTL = '" + Alltrim(oFil:cNumLote) + "' "
		endif

		cQry += CRLF + " ) Q "
		cQry += CRLF + " GROUP BY Q.FILIAL "
		cQry += CRLF + "        , Q.PRODUTO "
		cQry += CRLF + "        , Q.LOTECTL "
		cQry += CRLF + "        , Q.STATUS_LOTE "
		cQry += CRLF + "        , Q.ARMAZEM "
		cQry += CRLF + "        , Q.ENDERECO "
		cQry += CRLF + "        , Q.B1_DESC "
		cQry += CRLF + "        , Q.DFABRIC "
		cQry += CRLF + "        , Q.DTVALID "
		cQry += CRLF + "        , Q.POTENCI "
		cQry += CRLF + "        , Q.B1_UM "
		cQry += CRLF + "        , Q.B1_CONV "
		cQry += CRLF + "        , Q.LOTEFOR "
		cQry += CRLF + "        , Q.CLIFOR "
		cQry += CRLF + "        , Q.LOJA "
		cQry += CRLF + "        , Q.B1_LOCPAD "
		cQry += CRLF + "        , Q.FABRICANTE "
		cQry += CRLF + "        , Q.LOTFABR "
		cQry += CRLF + "        , Q.DTFABR "
		cQry += CRLF + " ORDER BY Q.FILIAL, Q.PRODUTO, Q.DTVALID, Q.LOTECTL, Q.ARMAZEM, Q.ENDERECO " //ORDEM FEFO

		cQry := ChangeQuery(cQry)

		If Select("QRYWS16") > 0
			QRYWS16->(DbCloseArea())
		EndIf

		TcQuery cQry New Alias "QRYWS16" // Cria uma nova area com o resultado do query

		QRYWS16->(dbGoTop())

		if QRYWS16->(Eof())
			cMsgErr := "Produto nใo localizado no Endere็o."
			lOK := .f.
			nQtdReg := 0
		else
			While QRYWS16->(!Eof())
				if len(aEnderecos) == 0 .or. AScan(aEnderecos, {|x| AllTrim(x) == AllTrim(QRYWS16->ENDERECO)}) > 0
					//1=Desocupado;2=Ocupado;3=Bloqueado
					cBE_STATUS := Posicione("SBE",1, QRYWS16->FILIAL+QRYWS16->ARMAZEM+QRYWS16->ENDERECO ,"BE_STATUS")
					if SBE->BE_MSBLQL == "1" .and. At("Endere็o (" + AllTrim(QRYWS16->ENDERECO) + ")", cMsgErr) == 0
						cMsgErr	+= iif(empty(cMsgErr), "", CRLF) + "Endere็o (" + AllTrim(QRYWS16->ENDERECO) + ") bloqueado."
						QRYWS16->(DbSkip())
						loop
					endif

					// Cria e alimenta uma nova instancia
					oNewEstoque :=  WSClassNew( "WSSldEstoque" )

					// Altera็ใo Marcos Natใ 05/10/2017 - INICIO
					cDtFab := DtoC(StoD(""))
					cDtValid := DtoC(StoD(""))
					lAltFab := .F.
					lAltVal := .F.

					// Verifica็ใo se o lote tem origem na SC2 ou SD1 para pegar data fabri็ใo
					cQry := " SELECT 'SC2' TIPO, C2_DATPRI DTFAB, C2_DTVALID DTVALID FROM " + RetSqlName("SC2") + " SC2 "
					cQry += " WHERE SC2.D_E_L_E_T_ <> '*' AND C2_PRODUTO = '"+QRYWS16->PRODUTO+"' "
					cQry += "   AND C2_LOTECTL = '"+QRYWS16->LOTECTL+"' "
					cQry += " UNION "
					cQry += " SELECT 'SD1' TIPO, D1_DTFABR DTFAB, D1_DTVALID DTVALID FROM " + RetSqlName("SD1") + " SD1 "
					cQry += " WHERE SD1.D_E_L_E_T_ <> '*' AND D1_COD = '"+QRYWS16->PRODUTO+"' "
					cQry += "   AND D1_LOTECTL = '"+QRYWS16->LOTECTL+"' "
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

					oNewEstoque:FILIAL 			:= Alltrim(QRYWS16->FILIAL)
					oNewEstoque:NUMLOTE 		:= Alltrim(QRYWS16->LOTECTL)
					oNewEstoque:PRODUTO 		:= Alltrim(QRYWS16->PRODUTO)
					oNewEstoque:DESC_PROD 		:= Alltrim(QRYWS16->B1_DESC)
					oNewEstoque:DATA_FAB 		:= cDtFab
					oNewEstoque:DATA_VALID 		:= cDtValid
					oNewEstoque:DATA_RETESTE 	:= DTOC(Iif(Empty(QRYWS16->DTVALID), "", STOD(QRYWS16->DTVALID) - 180))
					oNewEstoque:POTENCIA 		:= NoRound(QRYWS16->POTENCI,2)
					oNewEstoque:STATUS_LOTE 	:= QRYWS16->STATUS_LOTE //iif(QRYWS16->ARMAZEM == cMv_CQ, "1", "2") //1=QUARENTENA;2=APROVADO
					oNewEstoque:ARMAZEM 		:= QRYWS16->ARMAZEM
					oNewEstoque:ENDERECO 		:= Alltrim(QRYWS16->ENDERECO)
					oNewEstoque:QTD_DISP 		:= 0//NoRound(QRYWS16->(QUANT - EMPENHO),2)
					oNewEstoque:UNID_MED 		:= QRYWS16->B1_UM
					oNewEstoque:STATUS_ARMAZEM 	:= cBE_STATUS  //1=Desocupado;2=Ocupado;3=Bloqueado
					oNewEstoque:FAT_CONV 		:= QRYWS16->B1_CONV
					oNewEstoque:LOTE_FABRIC 	:= Alltrim(QRYWS16->LOTFABR)
					oNewEstoque:FABRICANTE 		:= ""
					oNewEstoque:DESC_FABRIC 	:= Alltrim(QRYWS16->FABRICANTE)
					oNewEstoque:FORNECEDOR 		:= QRYWS16->(CLIFOR+LOJA)
					oNewEstoque:NOME_FORNEC		:= Alltrim(Posicione("SA2",1,xFilial("SA2")+QRYWS16->(CLIFOR+LOJA), "A2_NOME"))
					oNewEstoque:LOTE_FORNEC		:= Alltrim(QRYWS16->LOTEFOR)

					AAdd( oRet:aRet, oNewEstoque )

					nQtdReg++
					lOK := .t.
				endif

				QRYWS16->(DbSkip())
			enddo

		endif

		QRYWS16->(DbCloseArea())

	endif

	oRet:lRet	 := lOK
	oRet:cErros	 := cMsgErr
	oRet:nQtdReg := nQtdReg

Return(.t.)
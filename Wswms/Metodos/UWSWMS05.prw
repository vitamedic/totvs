#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �UWSWMS05  �Autor  �Microsiga           � Data �  19/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Metodo WS para consulta de Saldo Estoque                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function UWSWMS05(oFil, oRet)

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

	//se n�o foi configurado WS para ja vir logado na empresa e filial, fa�o cria��o do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U'
		RpcSetType(3)
		lConect := RpcSetEnv(Fil_TpProd:cEmpresa, Fil_TpProd:cFilial)
		if !lConect
			cMsgErr := "N�o foi poss�vel conectar na Empresa/Filial informadas!"
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
		cQry += CRLF + "        AND (SBF.BF_QUANT-SBF.BF_EMPENHO) > 0 " //somente com saldo

		//cQry += CRLF + "        AND ((SB1.B1_TIPO = 'PA' AND SBF.BF_QUANT > 0) OR ((SBF.BF_QUANT-SBF.BF_EMPENHO) > 0)) " //somente com saldo

		if !empty(Alltrim(oFil:cProduto)) .and. Alltrim(oFil:cProduto) <> "?"
			cQry += CRLF + "        AND BF_PRODUTO = '" + Alltrim(oFil:cProduto) + "' "
		endif

		if !empty(oFil:cNumLote)
			cQry += CRLF + "        AND BF_LOTECTL = '" + Alltrim(oFil:cNumLote) + "' "
		endif

		if !empty(cArmazens)
			if cMv_CQ $ cArmazens //se armaz�m do CQ estiver dentro do filtro
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
		cQry += CRLF + "          AND SB8.B8_QACLASS  > 0 " //somente com saldo a endere�ar

		if !empty(Alltrim(oFil:cProduto)) .and. Alltrim(oFil:cProduto) <> "?"
			cQry += CRLF + "          AND SDA.DA_PRODUTO  = '" + Alltrim(oFil:cProduto) + "' "
		endif

		if !empty(oFil:cNumLote)
			cQry += CRLF + "        AND SDA.DA_LOTECTL = '" + Alltrim(oFil:cNumLote) + "' "
		endif

		//retirei porque a consulta precisa trazer todos os produtos � endere�ar, mesmo em armaz�m diferente do CQ
		//cQry += CRLF + "        AND DA_LOCAL = '" + cMv_CQ + "'"

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

		If Select("QRYWS5") > 0
			QRYWS5->(DbCloseArea())
		EndIf

		TcQuery cQry New Alias "QRYWS5" // Cria uma nova area com o resultado do query

		QRYWS5->(dbGoTop())

		if QRYWS5->(Eof())
			cMsgErr := "Produto n�o localizado no Endere�o."
			lOK := .f.
			nQtdReg := 0
		else
			While QRYWS5->(!Eof())
				if len(aEnderecos) == 0 .or. AScan(aEnderecos, {|x| AllTrim(x) == AllTrim(QRYWS5->ENDERECO)}) > 0
					//1=Desocupado;2=Ocupado;3=Bloqueado
					cBE_STATUS := Posicione("SBE",1, QRYWS5->FILIAL+QRYWS5->ARMAZEM+QRYWS5->ENDERECO ,"BE_STATUS")
					if SBE->BE_MSBLQL == "1" .and. At("Endere�o (" + AllTrim(QRYWS5->ENDERECO) + ")", cMsgErr) == 0
						cMsgErr	+= iif(empty(cMsgErr), "", CRLF) + "Endere�o (" + AllTrim(QRYWS5->ENDERECO) + ") bloqueado."
						QRYWS5->(DbSkip())
						loop
					elseif empty(NoRound(QRYWS5->(QUANT - EMPENHO),2))
						QRYWS5->(DbSkip())
						loop
					endif

					//Tratar Data de Re-teste
					/*
					cQry :=        " SELECT QEK.QEK_OBS"
					cQry += CRLF + " FROM " + RetSqlName("QEK") + " QEK "
					cQry += CRLF + " WHERE QEK.D_E_L_E_T_             <> '*' "
					cQry += CRLF + "   AND QEK.QEK_FILIAL             = '" + xFilial("QEK") + "' "
					cQry += CRLF + "   AND QEK.QEK_LOTE               = '"+Alltrim(QRYWS5->LOTECTL)+"'  "
					cQry += CRLF + "   AND QEK.QEK_PRODUT             = '"+Alltrim(QRYWS5->PRODUTO)+"'
					cQry += CRLF + "   AND SUBSTR(QEK.QEK_TIPDOC,1,2) = 'TR' "
					cQry += CRLF + "   AND QEK.QEK_SITENT             In ('2')  " // 1=Laudo Pendente;2=Laudo Aprovado;3=Laudo Reprovado;4=Liberacao Urgente;5=Laudo Condicional;6=Permissao de Uso
					cQry += CRLF + " ORDER BY QEK.R_E_C_N_O_"

					cQry := ChangeQuery(cQry)

					If Select("QRYRTST") > 0
					QRYRTST->(DbCloseArea())
					EndIf

					TcQuery cQry New Alias "QRYRTST" // Cria uma nova area com o resultado do query

					Do While QRYRTST->(!Eof())

					QRYRTST->(dbSkip())
					EndDo
					*/

					// Cria e alimenta uma nova instancia
					oNewEstoque :=  WSClassNew( "WSSldEstoque" )

					// Altera��o Marcos Nat� 05/10/2017 - INICIO
					cDtFab := DtoC(StoD(""))
					cDtValid := DtoC(StoD(""))
					lAltFab := .F.
					lAltVal := .F.

					// Verifica��o se o lote tem origem na SC2 ou SD1 para pegar data fabri��o
					cQry := " SELECT 'SC2' TIPO, C2_DATPRI DTFAB, C2_DTVALID DTVALID FROM " + RetSqlName("SC2") + " SC2 "
					cQry += " WHERE SC2.D_E_L_E_T_ <> '*' AND C2_PRODUTO = '"+QRYWS5->PRODUTO+"' "
					cQry += "   AND C2_LOTECTL = '"+QRYWS5->LOTECTL+"' "
					cQry += " UNION "
					cQry += " SELECT 'SD1' TIPO, D1_DTFABR DTFAB, D1_DTVALID DTVALID FROM " + RetSqlName("SD1") + " SD1 "
					cQry += " WHERE SD1.D_E_L_E_T_ <> '*' AND D1_COD = '"+QRYWS5->PRODUTO+"' "
					cQry += "   AND D1_LOTECTL = '"+QRYWS5->LOTECTL+"' "
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
					// Altera��o Marcos Nat� 05/10/2017 - FIM

					oNewEstoque:FILIAL 			:= Alltrim(QRYWS5->FILIAL)
					oNewEstoque:NUMLOTE 		:= Alltrim(QRYWS5->LOTECTL)
					oNewEstoque:PRODUTO 		:= Alltrim(QRYWS5->PRODUTO)
					oNewEstoque:DESC_PROD 		:= Alltrim(QRYWS5->B1_DESC)
					oNewEstoque:DATA_FAB 		:= cDtFab
					oNewEstoque:DATA_VALID 		:= cDtValid
					oNewEstoque:DATA_RETESTE 	:= DTOC(Iif(Empty(QRYWS5->DTVALID), "", STOD(QRYWS5->DTVALID) - 180))
					oNewEstoque:POTENCIA 		:= NoRound(QRYWS5->POTENCI,2)
					oNewEstoque:STATUS_LOTE 	:= QRYWS5->STATUS_LOTE //iif(QRYWS5->ARMAZEM == cMv_CQ, "1", "2") //1=QUARENTENA;2=APROVADO
					oNewEstoque:ARMAZEM 		:= QRYWS5->ARMAZEM
					oNewEstoque:ENDERECO 		:= Alltrim(QRYWS5->ENDERECO)
					oNewEstoque:QTD_DISP 		:= NoRound(QRYWS5->(QUANT - EMPENHO),2)
					oNewEstoque:UNID_MED 		:= QRYWS5->B1_UM
					oNewEstoque:STATUS_ARMAZEM 	:= cBE_STATUS  //1=Desocupado;2=Ocupado;3=Bloqueado
					oNewEstoque:FAT_CONV 		:= QRYWS5->B1_CONV
					oNewEstoque:LOTE_FABRIC 	:= Alltrim(QRYWS5->LOTFABR)
					oNewEstoque:FABRICANTE 		:= ""
					oNewEstoque:DESC_FABRIC 	:= Alltrim(QRYWS5->FABRICANTE)
					oNewEstoque:FORNECEDOR 		:= QRYWS5->(CLIFOR+LOJA)
					oNewEstoque:NOME_FORNEC		:= Alltrim(Posicione("SA2",1,xFilial("SA2")+QRYWS5->(CLIFOR+LOJA), "A2_NOME"))
					oNewEstoque:LOTE_FORNEC		:= Alltrim(QRYWS5->LOTEFOR)

					AAdd( oRet:aRet, oNewEstoque )

					nQtdReg++
					lOK := .t.
				endif

				QRYWS5->(DbSkip())
			enddo

		endif

		QRYWS5->(DbCloseArea())

	endif

	oRet:lRet	 := lOK
	oRet:cErros	 := cMsgErr
	oRet:nQtdReg := nQtdReg

Return(.t.)
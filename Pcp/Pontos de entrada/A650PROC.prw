#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A650PROC ºAutor  ³ Microsiga          º Data ³ 06/02/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Após a gravação das OP`s                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ WS WMS                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A650PROC()
	Local i
	Local cQry      	:= ""
	Local _cOps 		:= ""
	Local aOP			:= {}
	Local aArSC2 		:= SC2->(GetArea())
	Local aArSD4 		:= SD4->(GetArea())
	Local aArSDC 		:= SDC->(GetArea())
	Local aVetor 		:= {}
	Local aEmpen 		:= {}
	Local nOpc   		:= 5 //Exclusão
	Local cAliasTop 	:= GetNextAlias()
	Local MV_XESPOP     := SuperGetMV("MV_XESPOP", .f., "N") //Trata copia das OP´s na explosao para o Evolutio
	Local MV_XPI     	:= SuperGetMV("MV_XPI", .f., "N") //Trata Lote de PI`s nas OP`s
	Local lOk 			:= ( MV_XESPOP == "S" .and. Type("_aOPs") == "A" ) //Se a variável foi criada no PE : MTA650I
	Local cMsgErr   	:= ""
	Local cOP       	:= ""
	Local cCodPI 		:= ""
	Local cCodComp      := ""
	Local cTRT          := ""
	Local nQtdPI     	:= 0
	Local nQtdSegPI     := 0
	Local aPIs          := {} //PI´s selecionados pelo padrão para atender a OP (serão removidos e substituído pelo PI que atende o total da OP)
	Local aLoteCtl      := {}
	Local cLoteCtl      := ""
	Local dDtValid      := CtoD("//")
	Local dDtPri        := CtoD("//")
	Local MV_XPRDFAN    := SuperGetMV("MV_XPRDFAN", .f., "") //Integracao WMS, produtos que nao serao reportados no Empenho
	Local nRecSC2       := 0
	Local nRecSD4PI		:= 0
	Local nRecSDCPI		:= 0
	Local cMsgAgu	:= "Aguarde... atualizando empenhos WMS..."

	Private lMsErroAuto := .F.

	if lOk

		cQry := " SELECT SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN NUM_OP" +;
		" FROM " + RetSqlName("SC2") + " SC2 " +;
		" WHERE SC2.D_E_L_E_T_  = ' ' " +;
		"   AND SC2.C2_FILIAL   = '" + xFilial("SC2") + "' " +;
		"   AND SC2.C2_EMISSAO >= '"+GetMV("MV_XSC2COP")+"' " +;
		"   AND SC2.C2_XCOPIA  <> 'S' "

		cQry := ChangeQuery(cQry)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasTop,.T.,.T.)

		do while (cAliasTop)->(!Eof())
			if AScan(_aOPs, {|x| x == (cAliasTop)->NUM_OP}) == 0
				AAdd(_aOPs, (cAliasTop)->NUM_OP )
			endif

			(cAliasTop)->(DbSkip())
		enddo

		For i := 1 To Len(_aOPs)
			AAdd(aOP, _aOPs[i])
		Next

		(cAliasTop)->(dbCloseArea())

		For i := 1 to Len(_aOPs)
			if Empty(_cOps)
				_cOps := "("
			else
				_cOps += ","
			endif
			_cOps += "'"+_aOPs[i]+"'"
		Next i

		if ! Empty(_cOps)
			_cOps 	+= ")"
			lOk 	:= .t.
		endif

		if lOk
			//			BeginTran()
			BEGIN TRANSACTION

				cQry :=        " SELECT SC2.R_E_C_N_O_ RECSC2, SD4.R_E_C_N_O_ RECSD4, SDC.R_E_C_N_O_ RECSDC"
				cQry += CRLF + "      , SDC.DC_PRODUTO || SDC.DC_LOCAL || SDC.DC_OP || SDC.DC_TRT || SDC.DC_LOTECTL || SDC.DC_NUMLOTE CHAVE "
				cQry += CRLF + " FROM " + RetSqlName("SC2") + " SC2 "
				cQry += CRLF + " INNER JOIN " + RetSqlName("SD4") + " SD4 "
				cQry += CRLF + "   ON (     SD4.D4_FILIAL   = '" + xFilial("SD4") + "' "
				cQry += CRLF + "        AND SD4.D4_OP       = (SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN) "
				cQry += CRLF + "        AND SD4.D_E_L_E_T_  = ' ' "
				cQry += CRLF + "      ) "
				cQry += CRLF + " LEFT OUTER JOIN " + RetSqlName("SDC") + " SDC "
				//Ind2. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
				cQry += CRLF + "   ON (     SDC.DC_FILIAL   = '" + xFilial("SDC") + "' "
				cQry += CRLF + "        AND SDC.DC_PRODUTO  = SD4.D4_COD "
				cQry += CRLF + "        AND SDC.DC_LOCAL    = SD4.D4_LOCAL "
				cQry += CRLF + "        AND SDC.DC_OP       = SD4.D4_OP "
				cQry += CRLF + "        AND SDC.DC_TRT      = SD4.D4_TRT "
				cQry += CRLF + "        AND SDC.DC_LOTECTL  = SD4.D4_LOTECTL "
				cQry += CRLF + "        AND SDC.DC_NUMLOTE  = SD4.D4_NUMLOTE "
				cQry += CRLF + "        AND SDC.D_E_L_E_T_  = ' ' "
				cQry += CRLF + "      ) "
				cQry += CRLF + " WHERE SC2.C2_FILIAL  = '" + xFilial("SC2") + "' "
				cQry += CRLF + "   AND SC2.D_E_L_E_T_ = ' ' "
				cQry += CRLF + "   AND SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN In " + _cOps
				cQry += CRLF + " ORDER BY SDC.DC_TRT, SDC.DC_PRODUTO, SDC.DC_LOCAL, SDC.DC_OP, SDC.DC_LOTECTL, SDC.DC_NUMLOTE, SDC.DC_LOCALIZ, SDC.DC_NUMSERI "

				cQry := ChangeQuery(cQry)

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasTop,.T.,.T.)

				// Atualiza empenhos WMS
				AtuEmpWMS(aOP)

				do while (cAliasTop)->(!Eof())
					nRecSC2 := (cAliasTop)->RECSC2

					dbSelectArea("SC2")
					SC2->( dbGoTo((cAliasTop)->RECSC2) )

					dbSelectArea("SD4")
					dbGoTo((cAliasTop)->RECSD4)

					dbSelectArea("SDC")
					dbGoTo((cAliasTop)->RECSDC)

					cOP := SD4->D4_OP

					//ignorando itens do parametro
					if !( !empty(MV_XPRDFAN) .and. ( alltrim(SD4->D4_COD) $ MV_XPRDFAN ) )

						dbSelectArea("SB1")
						dbSetOrder(1)
						dbSeek(XFilial("SB1")+SD4->D4_COD)

						if SB1->B1_TIPO == 'PI' .AND. empty(cCodPI)
							cCodPI := SD4->D4_COD
							cTRT := SD4->D4_TRT
							nRecSD4PI := (cAliasTop)->RECSD4
							nRecSDCPI := (cAliasTop)->RECSDC
						endif

						if SB1->B1_TIPO <> 'PI' .OR. MV_XPI != "S"
							dbSelectArea("Z50")
							dbSetOrder(1)
							//Z50_FILIAL+Z50_COD+Z50_OP+Z50_TRT+Z50_LOTECT+Z50_NUMLOT+Z50_LOCAL+Z50_ORDEM+Z50_OPORIG+Z50_SEQ
							if Z50->( RecLock("Z50", !dbSeek(SD4->(D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE+D4_LOCAL+D4_ORDEM+D4_OPORIG+D4_SEQ) ) ) )

								Z50->Z50_FILIAL 	:= SD4->D4_FILIAL
								Z50->Z50_COD 		:= SD4->D4_COD
								Z50->Z50_LOCAL 		:= SD4->D4_LOCAL
								Z50->Z50_OP    		:= SD4->D4_OP
								Z50->Z50_DATA      	:= SD4->D4_DATA
								Z50->Z50_QSUSP     	:= SD4->D4_QSUSP
								Z50->Z50_SITUAC    	:= SD4->D4_SITUACA
								Z50->Z50_QTDEOR    	:= SD4->D4_QTDEORI
								Z50->Z50_TRT       	:= SD4->D4_TRT
								Z50->Z50_LOTECT    	:= SD4->D4_LOTECTL // Space(TamSX3("D4_LOTECTL")[1]) //
								Z50->Z50_NUMLOT    	:= SD4->D4_NUMLOTE
								Z50->Z50_DTVALI    	:= SD4->D4_DTVALID
								Z50->Z50_OPORIG    	:= SD4->D4_OPORIG
								Z50->Z50_POTENC    	:= SD4->D4_POTENCI //Iif(SD4->D4_POTENCI <> 0, 100, SD4->D4_POTENCI)
								Z50->Z50_QUANT     	:= SD4->D4_QUANT
								Z50->Z50_QTSEGU    	:= SD4->D4_QTSEGUM

								//							if Z50->Z50_POTENC <> 0
								//								dbSelectArea("SG1")
								//								dbSetOrder(1)
								//								if dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+SD4->D4_COD+SD4->D4_TRT)
								//									Z50->Z50_QTDEOR := SG1->G1_QUANT
								//									Z50->Z50_QUANT	:= SG1->G1_QUANT
								//									Z50->Z50_QTSEGU	:= ConvUM(SG1->G1_COMP,Z50->Z50_QUANT,0,2)
								//								endif
								//							endif

								Z50->Z50_ORDEM     	:= SD4->D4_ORDEM
								Z50->Z50_USERLI    	:= SD4->D4_USERLGI
								Z50->Z50_USERLA    	:= SD4->D4_USERLGA
								Z50->Z50_STATUS    	:= SD4->D4_STATUS
								Z50->Z50_SEQ       	:= SD4->D4_SEQ
								Z50->Z50_NUMPVB    	:= SD4->D4_NUMPVBN
								Z50->Z50_ITEPVB    	:= SD4->D4_ITEPVBN
								Z50->Z50_CODLAN    	:= SD4->D4_CODLAN
								Z50->Z50_SLDEMP    	:= SD4->D4_SLDEMP
								Z50->Z50_SLDEM2    	:= SD4->D4_SLDEMP2
								Z50->Z50_EMPROC    	:= SD4->D4_EMPROC
								Z50->Z50_CBTM      	:= SD4->D4_CBTM
								Z50->Z50_PRODUT    	:= SD4->D4_PRODUTO
								Z50->Z50_ROTEIR    	:= SD4->D4_ROTEIRO
								Z50->Z50_OPERAC    	:= SD4->D4_OPERAC

								Z50->( MsUnLock() )
							endif
						endif

						//monto vetor para exclusao dos empenhos SD4
						aEmpen  :=  {}
						aVetor	:=	{{"D4_COD"     , SD4->D4_COD	  ,Nil},; //COM O TAMANHO EXATO DO CAMPO
						{"D4_LOCAL"   , SD4->D4_LOCAL    ,Nil},;
						{"D4_OP"      , SD4->D4_OP 	  ,Nil},;
						{"D4_DATA"    , SD4->D4_DATA     ,Nil},;
						{"D4_QTDEORI" , SD4->D4_QTDEORI  ,Nil},;
						{"D4_QUANT"   , SD4->D4_QUANT    ,Nil},;
						{"D4_TRT"     , SD4->D4_TRT      ,Nil},;
						{"D4_QTSEGUM" , SD4->D4_QTSEGUM  ,Nil}}

						if !Empty( (cAliasTop)->CHAVE )

							cChave := (cAliasTop)->CHAVE

							do while (cAliasTop)->( !Eof() .and. CHAVE == cChave )
								dbSelectArea("SDC")
								dbGoTo((cAliasTop)->RECSDC)

								if SB1->B1_TIPO <> 'PI' .OR. MV_XPI != "S"

									dbSelectArea("Z51")
									dbSetOrder(1) //Z51_FILIAL+Z51_PRODUT+Z51_LOCAL+Z51_OP+Z51_TRT+Z51_LOTECT+Z51_NUMLOT+Z51_LOCALI+Z51_NUMSER
									if Z51->( RecLock("Z51", !dbSeek(SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI) ) ) )
										Z51->Z51_FILIAL 	:= SDC->DC_FILIAL
										Z51->Z51_ORIGEM    	:= SDC->DC_ORIGEM
										Z51->Z51_PRODUT		:= SDC->DC_PRODUTO
										Z51->Z51_LOCAL 		:= SDC->DC_LOCAL
										Z51->Z51_LOCALI    	:= SDC->DC_LOCALIZ
										Z51->Z51_NUMSER    	:= SDC->DC_NUMSERI
										Z51->Z51_LOTECT    	:= SDC->DC_LOTECTL
										Z51->Z51_NUMLOT    	:= SDC->DC_NUMLOTE
										Z51->Z51_QUANT     	:= SDC->DC_QUANT
										Z51->Z51_QTD     	:= SDC->DC_QUANT
										Z51->Z51_OP    		:= SDC->DC_OP
										Z51->Z51_TRT       	:= SDC->DC_TRT
										Z51->Z51_PEDIDO   	:= SDC->DC_PEDIDO
										Z51->Z51_ITEM      	:= SDC->DC_ITEM
										Z51->Z51_QTDORI    	:= SDC->DC_QTDORIG
										Z51->Z51_SEQ       	:= SDC->DC_SEQ
										Z51->Z51_QTSEGU    	:= SDC->DC_QTSEGUM
										Z51->Z51_ESTFIS    	:= SDC->DC_ESTFIS
										Z51->Z51_USERLI    	:= SDC->DC_USERLGI
										Z51->Z51_USERLA    	:= SDC->DC_USERLGA
										Z51->Z51_IDDCF    	:= SDC->DC_IDDCF

										Z51->( MsUnLock() )
									endif
								endif

								//monto vetor de endereços para exclusao SDC
								AADD(aEmpen,{ SDC->DC_QUANT 	,;  // SD4->D4_QUANT
								SDC->DC_LOCALIZ	,;  // DC_LOCALIZ
								SDC->DC_NUMSERI   ,;  // DC_NUMSERI
								SDC->DC_QTSEGUM  	,;  // D4_QTSEGUM
								.F.				})

								(cAliasTop)->( dbSkip() )
							enddo

						else
							(cAliasTop)->( dbSkip() )
						endif

						lMsErroAuto := .F.
						//faço exclusao dos empenhos SD4 e SDC
						MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,nOpc,aEmpen)

						if lMsErroAuto
							Alert("Erro")
							MostraErro()
							lOK := .f.
							Exit
						endif
					else
						(cAliasTop)->(DbSkip())
					endif

					//gravaçao da OP, se final de arquivo ou mudou a OP
					if (cAliasTop)->(Eof()) .OR. nRecSC2 <> (cAliasTop)->RECSC2

						if MV_XPI == "S" .AND. !empty(cCodPI)
							BuscaLotePI(cOP, cCodPI, cTRT, nRecSD4PI, nRecSDCPI) //cria espelhamento para os PI
						endif

						dbSelectArea("SC2")
						SC2->( dbGoTo(nRecSC2) )
						if SC2->( Recno() == nRecSC2 .and. SC2->C2_XCOPIA <> "S" )
							SC2->( Reclock("SC2", .f.) )
							SC2->C2_XCOPIA := "S"
							SC2->( MsUnLock() )
						endif

						cCodPI := ""
					endif
				enddo

				//atualizo empenhos WMS da SB2, SB8 e SBF
				//			if lOK
				//				LjMsgRun(cMsgAgu,"Saldos WMS",{|| lOk := U_ProcEmpenhoWMS(,,,.t., @cMsgErr) })
				//			endif

				if ! lOK
					DisarmTransaction()
				EndIf
				//			else
				//				EndTran()
				//			endif
			END TRANSACTION

			(cAliasTop)->(dbCloseArea())
		endif

		RestArea(aArSC2)
		RestArea(aArSD4)
		RestArea(aArSDC)
	endif

	If MV_XESPOP == "S" .AND. Type("__nCtrOps") <> "U" .AND. __nCtrOps > 0
		__nCtrOps := 0
	EndIf

Return()

//Faz tratamentos para lote de PI
Static Function BuscaLotePI(cOP, cCodPI, cTRT, nRecSD4PI, nRecSDCPI)

	Local nQtdPI := 0
	Local nQtdSegPI := 0
	Local aEstruct 	:= u_fEstruct(SC2->C2_PRODUTO, SC2->C2_QUANT)
	Local aLoteCtl := {}
	Local cChavZ50 := ""
	Local cChavZ51 := ""
	Local cAliasBF := GetNextAlias()
	Local nQtdBF := 0

	if !empty(cCodPI)

		AEval(aEstruct, {|x| nQtdPI += Iif(Posicione("SB1",1,xFilial("SB1")+x[6],"B1_TIPO") == 'PI', x[7], 0	) })

		dbSelectArea("SG1")
		dbSetOrder(1)
		if dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+cCodPI+cTRT)
			nQtdSegPI := ConvUM(SG1->G1_COMP,nQtdPI,0,2)
		endif

		dbSelectArea("SB8")
		dbSetOrder(1) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE
		MSSeek(XFilial("SB8")+cCodPI)
		do while SB8->(!Eof() .and. B8_PRODUTO == cCodPI)
			if SB8->B8_DTVALID >= dDataBase .and. SB8->(B8_SALDO-B8_EMPENHO) >= nQtdPI

				SET DELETED OFF //considero deletados

				//posiciono na SD4 deletada para pegar as informações
				SD4->(DbGoTo(nRecSD4PI))

				cChavZ50 := SD4->D4_FILIAL+SD4->D4_COD+SD4->D4_OP+SD4->D4_TRT+SB8->B8_LOTECTL+SB8->B8_NUMLOTE+SB8->B8_LOCAL+SD4->D4_ORDEM+SD4->D4_OPORIG+SD4->D4_SEQ

				//incluo a Z50 (espelho da SD4)
				dbSelectArea("Z50")
				dbSetOrder(1) //Z50_FILIAL+Z50_COD+Z50_OP+Z50_TRT+Z50_LOTECT+Z50_NUMLOT+Z50_LOCAL+Z50_ORDEM+Z50_OPORIG+Z50_SEQ
				if Z50->( RecLock("Z50", !dbSeek(cChavZ50) ) )

					if Z50->(Deleted())
						Z50->(DbRecall())
					endif

					Z50->Z50_FILIAL 	:= SD4->D4_FILIAL
					Z50->Z50_COD 		:= SD4->D4_COD
					Z50->Z50_LOCAL 		:= SD4->D4_LOCAL
					Z50->Z50_OP    		:= SD4->D4_OP
					Z50->Z50_DATA      	:= SD4->D4_DATA
					Z50->Z50_QSUSP     	:= SD4->D4_QSUSP
					Z50->Z50_SITUAC    	:= SD4->D4_SITUACA
					Z50->Z50_QTDEOR    	:= nQtdPI
					Z50->Z50_TRT       	:= SD4->D4_TRT
					Z50->Z50_LOTECT    	:= SB8->B8_LOTECTL
					Z50->Z50_NUMLOT    	:= SB8->B8_NUMLOTE
					Z50->Z50_DTVALI    	:= SB8->B8_DTVALID
					Z50->Z50_OPORIG    	:= SD4->D4_OPORIG
					Z50->Z50_POTENC    	:= SD4->D4_POTENCI //Iif(SD4->D4_POTENCI <> 0, 100, SD4->D4_POTENCI)
					Z50->Z50_QUANT     	:= nQtdPI
					Z50->Z50_QTSEGU    	:= ConvUM(SG1->G1_COMP, nQtdPI,0,2)

					//					if Z50->Z50_POTENC <> 0
					//						dbSelectArea("SG1")
					//						dbSetOrder(1)
					//						if dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+SD4->D4_COD+SD4->D4_TRT)
					//							Z50->Z50_QTDEOR := SG1->G1_QUANT
					//							Z50->Z50_QUANT	:= SG1->G1_QUANT
					//							Z50->Z50_QTSEGU	:= ConvUM(SG1->G1_COMP,Z50->Z50_QUANT,0,2)
					//						endif
					//					endif

					Z50->Z50_ORDEM     	:= SD4->D4_ORDEM
					Z50->Z50_USERLI    	:= SD4->D4_USERLGI
					Z50->Z50_USERLA    	:= SD4->D4_USERLGA
					Z50->Z50_STATUS    	:= SD4->D4_STATUS
					Z50->Z50_SEQ       	:= SD4->D4_SEQ
					Z50->Z50_NUMPVB    	:= SD4->D4_NUMPVBN
					Z50->Z50_ITEPVB    	:= SD4->D4_ITEPVBN
					Z50->Z50_CODLAN    	:= SD4->D4_CODLAN
					Z50->Z50_SLDEMP    	:= SD4->D4_SLDEMP
					Z50->Z50_SLDEM2    	:= SD4->D4_SLDEMP2
					Z50->Z50_EMPROC    	:= SD4->D4_EMPROC
					Z50->Z50_CBTM      	:= SD4->D4_CBTM
					Z50->Z50_PRODUT    	:= SD4->D4_PRODUTO
					Z50->Z50_ROTEIR    	:= SD4->D4_ROTEIRO
					Z50->Z50_OPERAC    	:= SD4->D4_OPERAC

					Z50->( MsUnLock() )
				endif

				nQtdBF := nQtdPI

				//Gravando a Z51 espelho da SDC
				//posiciono na SDC deletada para pegar as informações
				SDC->(DbGoTo(nRecSDCPI))

				cQry := " SELECT * FROM " + RETSQLNAME("SBF") + " SBF"
				cQry += " WHERE SBF.D_E_L_E_T_ = ' ' "
				cQry += " AND BF_FILIAL = '"+xFilial("SBF")+"' "
				cQry += " AND BF_PRODUTO = '"+Z50->Z50_COD+"' "
				cQry += " AND BF_LOCAL = '"+SB8->B8_LOCAL+"' "
				cQry += " AND BF_LOTECTL = '"+SB8->B8_LOTECTL+"' "
				cQry += " AND (BF_QUANT-BF_EMPENHO) > 0 "

				cQry := ChangeQuery(cQry)

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasBF,.T.,.T.)

				while (cAliasBF)->(!Eof()) .AND. nQtdBF > 0

					nQtdBF -= (cAliasBF)->(BF_QUANT-BF_EMPENHO)

					cChavZ51 := SDC->DC_FILIAL+SDC->DC_PRODUTO+SB8->B8_LOCAL+SD4->D4_OP+SD4->D4_TRT+SB8->B8_LOTECTL+SB8->B8_NUMLOTE+(cAliasBF)->BF_LOCALIZ+(cAliasBF)->BF_NUMSERI

					dbSelectArea("Z51")
					dbSetOrder(1) //Z51_FILIAL+Z51_PRODUT+Z51_LOCAL+Z51_OP+Z51_TRT+Z51_LOTECT+Z51_NUMLOT+Z51_LOCALI+Z51_NUMSER
					if Z51->( RecLock("Z51", !dbSeek( cChavZ51 ) ) )
						Z51->Z51_FILIAL 	:= SDC->DC_FILIAL
						Z51->Z51_ORIGEM    	:= SDC->DC_ORIGEM
						Z51->Z51_PRODUT		:= SDC->DC_PRODUTO
						Z51->Z51_LOCAL 		:= SB8->B8_LOCAL
						Z51->Z51_LOCALI    	:= (cAliasBF)->BF_LOCALIZ
						Z51->Z51_NUMSER    	:= (cAliasBF)->BF_NUMSERI
						Z51->Z51_LOTECT    	:= SB8->B8_LOTECTL
						Z51->Z51_NUMLOT    	:= SB8->B8_NUMLOTE
						Z51->Z51_QUANT     	:= (cAliasBF)->(BF_QUANT-BF_EMPENHO)
						Z51->Z51_QTD     	:= (cAliasBF)->(BF_QUANT-BF_EMPENHO)
						Z51->Z51_OP    		:= SD4->D4_OP
						Z51->Z51_TRT       	:= SD4->D4_TRT
						Z51->Z51_PEDIDO   	:= SDC->DC_PEDIDO
						Z51->Z51_ITEM      	:= SDC->DC_ITEM
						Z51->Z51_QTDORI    	:= (cAliasBF)->(BF_QUANT-BF_EMPENHO)
						Z51->Z51_SEQ       	:= SDC->DC_SEQ
						Z51->Z51_QTSEGU    	:= ConvUM(SDC->DC_PRODUTO, (cAliasBF)->(BF_QUANT-BF_EMPENHO),0,2)
						Z51->Z51_ESTFIS    	:= SDC->DC_ESTFIS
						Z51->Z51_USERLI    	:= SDC->DC_USERLGI
						Z51->Z51_USERLA    	:= SDC->DC_USERLGA
						Z51->Z51_IDDCF    	:= SDC->DC_IDDCF

						Z51->( MsUnLock() )
					endif

					(cAliasBF)->(DbSkip())
				enddo

				SET DELETED ON //desconsidera novamente os deletados

				Reclock("SC2", .F.)
				SC2->C2_LOTECTL := U_LotePI(cOP, cCodPI, SB8->B8_LOTECTL)
				SC2->C2_DTVALID := SB8->B8_DTVALID
				SC2->C2_DATPRI  := U_FabricPI(cCodPI, SB8->B8_LOTECTL, SC2->C2_DATPRI)
				SC2->(MsUnlock())

				exit //sai do laço SB8
			endif

			SB8->(dbSkip())
		enddo

	endif

Return

Static Function AtuEmpWMS(aOP)
	Local i
	Local aAreaSB2 := SB2->(GetArea())

	For i := 1 To Len(aOP)

		cQry :=  "SELECT "
		cQry +=  "  SD4.D4_COD        PRODUTO, "
		cQry +=  "  SD4.D4_LOCAL      LOCAL, "
		cQry +=  "  SUM(SD4.D4_QUANT) QUANT "
		cQry +=  "FROM " + RetSqlName("SD4") + " SD4 "
		cQry +=  "WHERE SD4.D_E_L_E_T_ <> '*' "
		cQry +=  "      AND SD4.D4_FILIAL = '" + xFilial("SD4") + "' "
		cQry +=  "      AND SD4.D4_OP = '" + aOP[i] + "' "
		cQry +=  "GROUP BY SD4.D4_COD, SD4.D4_LOCAL "
		cQry := ChangeQuery(cQry)

		If Select("QRYOP") > 0
			QRYOP->(dbCloseArea())
		EndIf

		TCQuery cQry New Alias "QRYOP"

		QRYOP->(dbGoTop())
		SB2->(dbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
		While QRYOP->(!EOF())
			If SB2->(dbSeek(xFilial("SB2")+QRYOP->PRODUTO+QRYOP->LOCAL))
				SB2->(RecLock("SB2", .F.))
				SB2->B2_XEMPWMS += QRYOP->QUANT
				SB2->(MsUnLock())
			EndIf

			QRYOP->(dbSkip())
		EndDo

		QRYOP->(dbCloseArea())

	Next

	RestArea(aAreaSB2)

Return
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UWSWMS05  ºAutor  ³Microsiga           º Data ³  19/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Metodo WS para processamento do Empenho de OP (SD4, e SDC)  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UWSWMS51(oDados, oRet)

	Local lOk 			:= .T.
	Local lExiste 		:= .F.
	Local cMsgErr 		:= ""
	Local aVetor 		:= {}
	Local aEmpen 		:= {}
	Local aEstornoCab  	:= {}
	Local aEstornoEnd  	:= {}
	Local aTravas 		:= {}
	Local cSequen		:= ""
	Local cCodComp 		:= ""
	Local cMsgPrd 		:= ""
	Local cArmazem 		:= ""
	Local cLoteCTL  	:= ""
	Local cOperacao 	:= ""
	Local cNumOP    	:= ""
	Local nQuant   		:= 0
	Local MV_XPRDFAN    := SuperGetMV("MV_XPRDFAN", .f., "")
	
	Local nX := nY := nfor := 0

	Local lConsVenc  := GetMV('MV_LOTVENC')=='S'

	Private	lMsErroAuto := .F.

	oRet:SITUACAO := .t.
	oRet:MENSAGEM := ""

	if empty(oDados:cEmpresa)
		oDados:cEmpresa := "01"
		oDados:cParFil  := "01"
	endif

	//se não foi configurado WS para ja vir logado na empresa e filial, faço criação do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U'
		RpcSetType(3)
		lConect := RpcSetEnv(Fil_TpProd:cEmpresa, Fil_TpProd:cFilial)
		if !lConect
			cMsgErr := "Não foi possível conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif

	if lOk .AND. empty(oDados:NUM_OP)
		cMsgErr := "Informe o número da Ordem de Produção."
		lOk := .F.
	elseif lOK .AND. empty(Posicione("SC2",1,xFilial("SC2")+alltrim(oDados:NUM_OP),"C2_NUM"))
		cMsgErr := "OP informada não foi localizada."
		lOk := .F.
	elseif lOK .AND. !empty(SC2->C2_DATRF)
		cMsgErr := "OP informada ja foi encerrada. Ação não permitida."
		lOk := .F.
	endif

	if lOk
		for nX := 1 to len(oDados:PRODUTOS)
			cMsgErr := VldProdutos(oDados:PRODUTOS[nX], PadR(oDados:NUM_OP,TamSx3("D4_OP")[1]), nX)
			if !empty(cMsgErr)
				lOk := .F.
				exit
			endif
		next nX
	endif

	//se tudo ok, faz execautos
	if lOK

		BEGIN TRANSACTION

			for nX := 1 to len(oDados:PRODUTOS)
				cNumOP      := PadR(oDados:NUM_OP, TamSx3("D4_OP")[1])
				cCodComp 	:= PadR(oDados:PRODUTOS[nX]:CODIGO,TamSx3("B1_COD")[1])
				cLoteCTL    := PadR(oDados:PRODUTOS[nX]:LOTE,TamSx3("B8_LOTECTL")[1])
				cSequen		:= PadR(ValDef(oDados:PRODUTOS[nX]:SEQUENCIA, "C"), TamSX3("D4_TRT")[1])
				cMsgPrd 	:= "Produto/Sequência ("+AllTrim(cCodComp)+"/"+AllTrim(cSequen)+"), "
				cArmazem 	:= PadR(oDados:PRODUTOS[nX]:ARMAZEM,2)
				cOperacao   := AllTrim(oDados:PRODUTOS[nX]:OPERACAO)
				nQuant    	:= oDados:PRODUTOS[nX]:QUANTIDADE
				nQuantOr    := oDados:PRODUTOS[nX]:QUANTIDADE
				aEstornoCab := {}
				aEstornoEnd := {}
				aEmpen 		:= {} //SDC - Endereços empenhados,
				
				if empty(cOperacao)
					cMsgErr := cMsgPrd + "informe a operação à ser realizada. Ação não permitida."
					lOk := .F.
					exit
				elseif ! ( cOperacao $ "I;E" )
					cMsgErr := cMsgPrd + "informe a operação correta (I ou E). Ação não permitida."
					lOk := .F.
					exit
				endif

				dbSelectArea("Z50")
				dbSetOrder(1)
				lExiste := dbSeek(XFilial("Z50")+cCodComp+cNumOP+cSequen)
				cErroSaldo := ""

				//Z50_FILIAL+Z50_COD+Z50_OP+Z50_TRT+Z50_LOTECT+Z50_NUMLOT+Z50_LOCAL+Z50_ORDEM+Z50_OPORIG+Z50_SEQ
				if ! empty(cSequen) .and. ! lExiste
					cMsgErr := cMsgPrd + "não foi localizado. Ação não permitida."
					lOk := .F.
					exit
				endif

				if lOk
					cQry :=        " SELECT R_E_C_N_O_ RECSD4, D4_QUANT "
					cQry += CRLF + " FROM " + RetSqlName("SD4")
					cQry += CRLF + " WHERE D_E_L_E_T_ <> '*' "
					cQry += CRLF + "   AND D4_FILIAL   = '"+xFilial("SD4")+"' "
					cQry += CRLF + "   AND D4_OP       = '"+cNumOP+"' "
					cQry += CRLF + "   AND D4_COD      = '"+cCodComp+"' "
					cQry += CRLF + "   AND D4_LOCAL    = '"+cArmazem+"' "
					cQry += CRLF + "   AND D4_TRT      = '"+cSequen+"' "
					cQry += CRLF + "   AND D4_LOTECTL  = '"+cLoteCTL+"' "

					if Select("QSD4") > 0
						QSD4->(dbCloseArea())
					endif

					TCQuery cQry New Alias "QSD4"

					if QSD4->( Eof() .or. RECSD4 == 0 ) .and. cOperacao = "E"
						cMsgErr := cMsgPrd + "não foi localizado para realizar operação. Ação não permitida."
						lOk := .F.
						exit

					elseif QSD4->( !Eof() .and. RECSD4 > 0 )
						nOpc 	:= 3 //Inclusão

						dbSelectArea("SD4")
						dbGoTo(QSD4->RECSD4)

						if SD4->( Recno() <> QSD4->RECSD4 )
							cMsgErr := cMsgPrd + "registro não encontrado na tabela de empenhos. Ação não permitida."
							lOk := .F.
							exit
						endif

						if cOperacao == "E" //Estorno
							if QSD4->D4_QUANT == nQuant //Excluir empenho se a quantidade for igual a empenhada
								nOpc := 5
							else
								cMsgErr := cMsgPrd + "quantidade à ser estornada é diferente que a empenhada. Ação não permitida."
								lOk := .F.
								exit
							endif
						endif

						cQry :=        " SELECT R_E_C_N_O_ RECSDC, SDC.* "
						cQry += CRLF + " FROM " + RetSqlName("SDC") + " SDC "
						cQry += CRLF + " WHERE SDC.D_E_L_E_T_ <> '*' "
						cQry += CRLF + "   AND SDC.DC_FILIAL   = '"+SD4->D4_FILIAL+"' "
						cQry += CRLF + "   AND SDC.DC_PRODUTO  = '"+SD4->D4_COD+"' "
						cQry += CRLF + "   AND SDC.DC_LOCAL    = '"+SD4->D4_LOCAL+"' "
						cQry += CRLF + "   AND SDC.DC_OP       = '"+SD4->D4_OP+"' "
						cQry += CRLF + "   AND SDC.DC_TRT      = '"+SD4->D4_TRT+"' "
						cQry += CRLF + "   AND SDC.DC_LOTECTL  = '"+SD4->D4_LOTECTL+"' "

						if Select("QSDC") > 0
							QSDC->(dbCloseArea())
						endif

						TCQuery cQry New Alias "QSDC"

						if QSDC->(!Eof())
							if cOperacao == "I"
								aEstornoCab := { {"D4_COD"     ,SD4->D4_COD 		,Nil},;
								{"D4_LOCAL"   ,SD4->D4_LOCAL		,Nil},;
								{"D4_OP"      ,SD4->D4_OP			,Nil},;
								{"D4_DATA"    ,SD4->D4_DATA        ,Nil},;
								{"D4_QTDEORI" ,SD4->D4_QTDEORI     ,Nil},;
								{"D4_QUANT"   ,SD4->D4_QUANT       ,Nil},;
								{"D4_TRT"     ,SD4->D4_TRT			,Nil},;
								{"D4_QTSEGUM" ,SD4->D4_QTSEGUM     ,Nil},;
								{"D4_LOTECTL" ,SD4->D4_LOTECTL 	,Nil},;
								{"D4_POTENCI" ,SD4->D4_POTENCI 	,Nil},;
								{"D4_PRODUTO" ,Z50->Z50_PRODUT 	,Nil},;
								{"D4_ROTEIRO" ,Z50->Z50_ROTEIR 	,Nil},;
								{"D4_OPERAC"  ,Z50->Z50_OPERAC 	,Nil};
								}
							endif

							do while QSDC->(!Eof())
								if cOperacao == "I"
									AADD(aEstornoEnd,{ QSDC->DC_QUANT  	,; // DC_QUANT
									QSDC->DC_LOCALIZ	,; // DC_LOCALIZ
									QSDC->DC_NUMSERI	,; // DC_NUMSERI
									0 /*QSDC->DC_QTSEGUM*/	,; // D4_QTSEGUM
									.F.} )
								endif

								AADD(aEmpen,{ QSDC->DC_QUANT  	,; // DC_QUANT
								QSDC->DC_LOCALIZ	,; // DC_LOCALIZ
								QSDC->DC_NUMSERI	,; // DC_NUMSERI
								0 /*QSDC->DC_QTSEGUM*/	,; // D4_QTSEGUM
								.F.} )

								QSDC->(dbSkip())
							enddo
						endif

						QSDC->(dbCloseArea())

					else

						nOpc 	:= 3 //Inclusão

					endif

					QSD4->(dbCloseArea())

					/*
					Verifica se o somatório da quantidade à ser empenhado ultrapassa o previso e não permite a operação.

					Tratamento retirado à pedido do Guilherme
					if cOperacao == "I" .and. ProblemaNoSaldo(cNumOP, cCodComp, cArmazem, cSequen, oDados:PRODUTOS[nX]:QUANTIDADE, @cErroSaldo)

					cMsgErr := cMsgPrd + cErroSaldo + " Ação não permitida."
					lOk := .f.
					exit

					endif
					*/

					if cOperacao == "E"
						aVetor := { {"D4_COD"     ,cCodComp 								,Nil},;
						{"D4_LOCAL"   ,cArmazem			            			,Nil},;
						{"D4_OP"      ,cNumOP									,Nil},;
						{"D4_DATA"    ,dDatabase        						,Nil},;
						{"D4_QUANT"   ,nQuant               					,Nil},;
						{"D4_QTDEORI" ,nQuant              						,Nil},;
						{"D4_TRT"     ,cSequen									,Nil},;
						{"D4_QTSEGUM" ,0                						,Nil},;
						{"D4_LOTECTL" ,cLoteCTL									,Nil},;						
						{"D4_POTENCI" ,ValDef(oDados:PRODUTOS[nX]:POTENCIA, "N"),Nil},;
						{"D4_PRODUTO" ,Z50->Z50_PRODUT 							,Nil},;
						{"D4_ROTEIRO" ,Z50->Z50_ROTEIR 							,Nil},;
						{"D4_OPERAC"  ,Z50->Z50_OPERAC 							,Nil};
						}
					else
						aVetor := { {"D4_COD"     ,cCodComp 								,Nil},;
						{"D4_LOCAL"   ,cArmazem			            			,Nil},;
						{"D4_OP"      ,cNumOP									,Nil},;
						{"D4_DATA"    ,dDatabase        						,Nil},;
						{"D4_QTDEORI" ,nQuant              						,Nil},;
						{"D4_QUANT"   ,nQuant               					,Nil},;
						{"D4_TRT"     ,cSequen									,Nil},;
						{"D4_QTSEGUM" ,0                						,Nil},;
						{"D4_LOTECTL" ,cLoteCTL									,Nil},;
						{"D4_POTENCI" ,ValDef(oDados:PRODUTOS[nX]:POTENCIA, "N"),Nil},;
						{"D4_PRODUTO" ,Z50->Z50_PRODUT 							,Nil},;
						{"D4_ROTEIRO" ,Z50->Z50_ROTEIR 							,Nil},;
						{"D4_OPERAC"  ,Z50->Z50_OPERAC 							,Nil};
						}
					endif

					//endereços
					for nY := 1 to len(oDados:PRODUTOS[nX]:ENDERECOS)
						if empty( cBlq := Posicione("SBE",1,xFilial("SBE")+cArmazem+PadR(oDados:PRODUTOS[nX]:ENDERECOS[nY]:CODIGO,TamSx3("BF_LOCALIZ")[1]),"BE_MSBLQL") )
							cMsgErr := "O Endereço " + PadR(oDados:PRODUTOS[nX]:ENDERECOS[nY]:CODIGO,TamSx3("BF_LOCALIZ")[1]) + " informado nao está cadastrado."
							lOk := .F.
							exit
						elseif cBlq == "1"
							cMsgErr := "Endereço (" + PadR(oDados:PRODUTOS[nX]:ENDERECOS[nY]:CODIGO,TamSx3("BF_LOCALIZ")[1]) + ") bloqueado ." + cSeq
							lOk := .F.
							exit
						endif

						if ( nI := AScan(aEmpen, {|x| AllTrim(x[2]) == AllTrim(oDados:PRODUTOS[nX]:ENDERECOS[nY]:CODIGO)}) ) > 0
							aEmpen[nI,1] += (oDados:PRODUTOS[nX]:ENDERECOS[nY]:QUANTIDADE * iif(cOperacao == "E", -1, 1))
						else
							AADD(aEmpen,{	oDados:PRODUTOS[nX]:ENDERECOS[nY]:QUANTIDADE    							,; // DC_QUANT
							PadR(oDados:PRODUTOS[nX]:ENDERECOS[nY]:CODIGO,TamSx3("BF_LOCALIZ")[1])		,; // DC_LOCALIZ
							""																			,; // DC_NUMSERI
							0                  															,; // D4_QTSEGUM
							.F.} )
						endif

					next nY

					//-- Ajusta o valor a ser empenhado na SD4
					If cOperacao == "I"
						aVetor[5][2] := 0
						aVetor[6][2] := 0
						For nI := 1 To Len(aEmpen)
							aVetor[5][2] += aEmpen[nI,1]
							aVetor[6][2] += aEmpen[nI,1]
						Next nI
					EndIf

					lMsErroAuto := .F.
					if lOk .and. cOperacao == "I" .and. len(aEstornoCab) > 0

						//Executa o estorno dos endereços anteriores
						MSExecAuto({|x,y,z| mata380(x,y,z)},aEstornoCab, 5, aEstornoEnd)
						if lMsErroAuto
							cMsgErr := MostraErro("\temp")
							cMsgErr := StrTran(cMsgErr, "<","|")
							cMsgErr := StrTran(cMsgErr, ">","|")
							cMsgErr := "Erro ao executar o estorno dos empenhos existentes." + CRLF + cMsgErr
							lOk 	:= .F.
							DisarmTransaction()
							exit
						else
							/*
							if !( lOk := U_CalcEmpenhoWMS("E", aEstornoCab, .t., @cMsgErr) )
							DisarmTransaction()
							exit
							endif
							*/

						endif
					endif

					if !lOk
						exit
					else
						//Executa o endereçamento do item
						lMsErroAuto := .F.
						MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor, nOpc, aEmpen)

						if lMsErroAuto
							cMsgErr := MostraErro("\temp")
							cMsgErr := StrTran(cMsgErr, "<","|")
							cMsgErr := StrTran(cMsgErr, ">","|")
							lOk := .F.
							DisarmTransaction()
							exit
						else
							//Tratamento para gravar a potência reportada, porque o Execauto não estava gravando a informação.
							dbSelectArea('SD4')
							dbSetOrder(1)

							if nOpc == 3 //somente na inclusao
								dbSelectArea("SC2")
								dbSetOrder(1)
								if dbSeek(xFilial("SC2")+cNumOP)
									dbSelectArea("SB1")
									dbSetOrder(1)
									if dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
										if SC2->C2_EMISSAO = SC2->C2_DATPRI
											RecLock("SC2", .F.)
											SC2->C2_DATPRI  := Date()
											SC2->C2_DTVALID := DaySum(Date(), SB1->B1_PRVALID)
											SC2->(MsUnlock())
										endif
									endif
								endif
								if dbSeek(XFilial('SD4')+cCodComp+cNumOP+cSequen+cLoteCTL)
									if RecLock("SD4", .f.)
										SD4->D4_POTENCI := ValDef(oDados:PRODUTOS[nX]:POTENCIA, "N")
										SD4->(MsUnLock())
									endif

									//tratamento para lote de PI na OP
									dbSelectArea("SB1")
									dbSetOrder(1)
									dbSeek(xFilial("SB1")+SD4->D4_COD)
									if SB1->B1_TIPO == 'PI'
										dbSelectArea("SC2")
										dbSetOrder(1)
										if dbSeek(xFilial("SC2")+SD4->D4_OP)

											dbSelectArea("SB8")
											dbSetOrder(3) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
											if dbSeek(xFilial("SB8")+SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_LOTECTL)
												Reclock("SC2", .F.)
												SC2->C2_LOTECTL := U_LotePI(SD4->D4_OP, SD4->D4_COD, SD4->D4_LOTECTL)
												SC2->C2_DTVALID := SB8->B8_DTVALID
												SC2->C2_DATPRI  := U_FabricPI(SD4->D4_COD, SD4->D4_LOTECTL, SC2->C2_DATPRI)
												SC2->(MsUnlock())
											endif
										endif
									endif
								endif
							endif

							//atualizo empenhos WMS da SB2
							//						if !( lOk := U_ProcEmpenhoWMS(,,,.t., @cMsgErr) )
							//							DisarmTransaction()
							//							exit
							//						endif
						endif
					endif
				endif

			next nX

		END TRANSACTION

		if lOk
			//			EndTran()

			//Controla empenhos na tabela Z51 e SB2
			BaixaEmp(aVetor[3][2], aVetor[1][2], aVetor[2][2], aVetor[6][2], cOperacao)

			if cOperacao == "E"
				cMsgErr := "Estorno do Empenho realizado com sucesso!."
			else
				cMsgErr := "Empenho realizado com sucesso!."
			endif
		endif

		SD4->(MSUnlockAll())
		SDC->(MSUnlockAll())
		SB2->(MSUnlockAll())
		SB8->(MSUnlockAll())
		SBF->(MSUnlockAll())

	endif

	oRet:SITUACAO := lOK
	oRet:MENSAGEM := cMsgErr

Return(.t.)

Static Function VldProdutos(oProduto, cOp, nSeq)

	Local cMsgErr 	:= ""
	Local cSeq 		:= "Seq.Prod.: " + cValToChar(nSeq)
	Local nQtdSoma 	:= 0
	Local cOperacao := AllTrim(oProduto:OPERACAO)
	Local nX

	if empty(oProduto:CODIGO)
		cMsgErr := "Informe o codigo do Produto." + cSeq
	elseif empty(Posicione("SB1",1,xFilial("SB1")+alltrim(oProduto:CODIGO),"B1_COD"))
		cMsgErr := "O Produto " + oProduto:CODIGO + " informado nao está cadastrado." + cSeq
	elseif empty(oProduto:ARMAZEM)
		cMsgErr := "Informe o Armazem."
	elseif empty(oProduto:LOTE)
		cMsgErr := "Informe o Lote do produto." + cSeq
	elseif empty(Posicione("SB8",3,xFilial("SB8")+PadR(oProduto:CODIGO,TamSx3("B1_COD")[1])+PadR(oProduto:ARMAZEM,2)+PadR(oProduto:LOTE,TamSx3("B8_LOTECTL")[1]),"B8_LOTECTL"))
		cMsgErr := "O Lote " + oProduto:LOTE + " informado nao está cadastrado no armazém "+oProduto:ARMAZEM+"." + cSeq
		//elseif !empty(Posicione("SD4",1,xFilial("SD4")+PadR(oProduto:CODIGO,TamSx3("B1_COD")[1])+cOp+PadR(ValDef(oProduto:SEQUENCIA, "C"),TamSx3("D4_TRT")[1])+PadR(oProduto:LOTE,TamSx3("B8_LOTECTL")[1]),"D4_COD"))
		//	cMsgErr := "Já existe um registro de empenho com mesma chave de produto+op+sequencia+lote. Ação não permitida." + cSeq

	elseif !empty(cMsgErr := u_fVldLote(oProduto:CODIGO, oProduto:LOTE))

	elseif empty(oProduto:QUANTIDADE)
		cMsgErr := "Informe a quantidade total para o produto " + oProduto:CODIGO + "." + cSeq
	else
		for nX := 1 to len(oProduto:ENDERECOS)
			cMsgErr := VldEndereco(oProduto:ENDERECOS[nX], nX, PadR(oProduto:ARMAZEM,2), @nQtdSoma, PadR(oProduto:LOTE,TamSx3("B8_LOTECTL")[1]), PadR(oProduto:CODIGO,TamSx3("B1_COD")[1]), cOperacao )
			if !empty(cMsgErr)
				exit
			endif
		next nX
	endif

	if empty(cMsgErr) .AND. nQtdSoma <> oProduto:QUANTIDADE
		cMsgErr := "Quantidade somada dos endereços deve ser igual a quantidade total informada do produto." + cSeq
	endif

Return cMsgErr

Static Function VldEndereco(oEndereco, nSeq, cArmazem, nQtdSoma, cLote, cProduto, cOperacao)

	Local cMsgErr := ""
	Local cSeq := "Seq.Ender.: " + cValToChar(nSeq)
	Local nX
	Local cEndereco := PadR(oEndereco:CODIGO,TamSx3("BF_LOCALIZA")[1])

	if empty(alltrim(cEndereco))
		cMsgErr := "Informe o codigo do endereco, " + cSeq
	elseif empty(Posicione("SBE",1,xFilial("SBE")+cArmazem+cEndereco,"BE_LOCALIZ"))
		cMsgErr := "O Endereço " + AllTrim(cEndereco) + " informado nao está cadastrado, " + cSeq
		//BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_LOCALIZ
	elseif empty(Posicione("SBF",7,xFilial("SBF")+cProduto+cArmazem+cLote+cEndereco,"BF_LOCALIZ"))
		cMsgErr := "O produto ("+ cProduto +") não está cadastrado no armazem/endereço (" + cArmazem+"/"+Alltrim(oEndereco:CODIGO) + "), " + cSeq
	elseif empty(oEndereco:QUANTIDADE)
		cMsgErr := "Informe a quantidade para o endereço " + oEndereco:CODIGO + ", " + cSeq
	elseif cOperacao <> "E" .and. ( SBF->( BF_QUANT - BF_EMPENHO ) - oEndereco:QUANTIDADE ) < 0
		cMsgErr := "Produto sem disponibilidade de estoque no endereço (" + oEndereco:CODIGO + "), " + cSeq
	else
		nQtdSoma += oEndereco:QUANTIDADE
	endif

Return cMsgErr

Static function ValDef(xValor, cTipo)

	Default xValor 	:= ""
	Default cTipo 	:= "C"

	if valtype(xValor) <> cTipo
		if cTipo == "N"
			xValor := 0
		elseif cTipo == "L"
			xValor := .F.
		endif
	endif

Return xValor

Static function ProblemaNoSaldo(cOP, cProduto, cLocal, cSequen, nQuant, cErro)
	Local lRet := .F.

	cQry :=        " SELECT Sum(QQ.D4_QUANT) D4_QUANT, Sum(U0_QUANT) U0_QUANT"
	cQry += CRLF + " FROM ( SELECT Sum(SD4.D4_QUANT) D4_QUANT, 0 U0_QUANT "
	cQry += CRLF + "        FROM " + RetSqlName("SD4") + " SD4 "
	cQry += CRLF + "        WHERE SD4.D_E_L_E_T_ <> '*' "
	cQry += CRLF + "        AND SD4.D4_OP         = '"+cOP+"' "
	cQry += CRLF + "        AND SD4.D4_COD        = '"+cProduto+"' "
	cQry += CRLF + "        AND SD4.D4_LOCAL      = '"+cLocal+"' "
	cQry += CRLF + "        AND SD4.D4_TRT        = '"+cSequen+"' "
	cQry += CRLF + "        UNION ALL "
	cQry += CRLF + "        SELECT 0 D4_QUANT, Sum(Z50_QUANT) U0_QUANT "
	cQry += CRLF + "        FROM " + RetSqlName("Z50") + " Z50 "
	cQry += CRLF + "        WHERE Z50.D_E_L_E_T_ <> '*' "
	cQry += CRLF + "          AND Z50.Z50_OP      = '"+cOP+"' "
	cQry += CRLF + "          AND Z50.Z50_COD     = '"+cProduto+"' "
	cQry += CRLF + "          AND Z50.Z50_LOCAL   = '"+cLocal+"' "
	cQry += CRLF + "          AND Z50.Z50_TRT     = '"+cSequen+"' "
	cQry += CRLF + "    ) QQ "

	if Select("QSUM") > 0
		QSUM->(dbCloseArea())
	endif

	TCQuery cQry New Alias "QSUM"

	if QSUM->( Eof() .or. U0_QUANT == 0 )
		cErro += "sem saldo nessa OP. "
		lRet := .T.

	elseif QSUM->( (D4_QUANT+nQuant) > U0_QUANT )
		cErro += "quantidade maior que o permitido à ser empenhado para essa OP. "
		lRet := .T.

	endif

	QSUM->(dbCloseArea())

Return(lRet)

/*/{Protheus.doc} BaixaEmp

Tratativa para controle de empenhos em processo

@author marcos.santos
@since 21/02/2018
@version 1.0

@type function
/*/
Static Function BaixaEmp(cOP, cProduto, cLocal, nBaixa, cOperacao)
	Local aAreaZ51 := Z51->(GetArea())
	Local aAreaSB2 := SB2->(GetArea())
	Local nQtd := 0

	cQry :=  "SELECT "
	cQry +=  "  Z51_PRODUT   PRODUTO, "
	cQry +=  "  SUM(Z51_QTD) QTD "
	cQry +=  "FROM " + RetSqlName("Z51") + " "
	cQry +=  "WHERE D_E_L_E_T_ <> '*' "
	cQry +=  "      AND Z51_FILIAL = '" + xFilial("Z51") + "' "
	cQry +=  "      AND Z51_OP = '" + cOp + "' "
	cQry +=  "      AND Z51_PRODUT = '" + cProduto + "' "
	cQry +=  "GROUP BY Z51_PRODUT "

	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf

	TCQuery cQry New Alias "QRY"

	// Baixa ou estorna quantidade empenhada
	nQtd := QRY->QTD
	If cOperacao == "I"
		nQtd -= nBaixa
	ElseIf cOperacao == "E"
		nQtd += nBaixa
	EndIf

	cQry :=  "SELECT R_E_C_N_O_ RECNO "
	cQry +=  "FROM " + RetSqlName("Z51") + " "
	cQry +=  "WHERE D_E_L_E_T_ <> '*' "
	cQry +=  "      AND Z51_FILIAL = '" + xFilial("Z51") + "' "
	cQry +=  "      AND Z51_OP = '" + cOp + "' "
	cQry +=  "      AND Z51_PRODUT = '" + cProduto + "' "

	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf

	TCQuery cQry New Alias "QRY"

	QRY->(dbGoTop())
	While QRY->(!EOF())
		Z51->(dbGoTo(QRY->RECNO))
		If Z51->(RecLock("Z51", .F.))
			Z51->Z51_QTD := 0
			Z51->(MsUnLock())
		endif

		QRY->(dbSkip())
	EndDo

	QRY->(dbGoTop())
	Z51->(dbGoTo(QRY->RECNO))
	If Z51->(RecLock("Z51", .F.))
		Z51->Z51_QTD := nQtd
		Z51->(MsUnLock())
	EndIf

	SB2->(dbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
	If SB2->(dbSeek(xFilial("SB2")+cProduto+cLocal))
		SB2->(RecLock("SB2", .F.))
		If cOperacao == "I"
			If SB2->B2_XEMPWMS >= nBaixa // Não permite saldo negativo
				SB2->B2_XEMPWMS -= nBaixa
			Else
				SB2->B2_XEMPWMS := 0
			EndIf
		ElseIf cOperacao == "E"
			SB2->B2_XEMPWMS += nBaixa
		EndIf
		SB2->(MsUnLock())
	EndIf

	RestArea(aAreaZ51)
	RestArea(aAreaSB2)
	QRY->(dbCloseArea())

Return
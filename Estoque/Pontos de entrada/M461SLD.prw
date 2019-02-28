#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*/{Protheus.doc} M461SLD
//TODO Ponto de Entrada na funcao A461Saldo 
utilizado para nao utilizar o calculo de saldo padrao.
history - Esse ponto de entrada sera utilizado para 
retirar os empenhos do pedido, assim liberando o faturamento
do item do pedido.
@author Raphael Martins
@since 26/12/2017
@version 1.0
@return lRet

@type function
/*/
User Function MTSLDORD() //M461SLD()

Local cRet			:= ""
Local cPulaLinha	:= chr(13) + chr(10)
Local aArea			:= GetArea()
Local aAreaSB8		:= SB8->(GetArea())
Local aAreaSBF		:= SBF->(GetArea())
Local aAreaSDC		:= SDC->(GetArea())
Local aAreaSC9		:= SC9->(GetArea())
	
	///////////////////////////////////////////////////////////
	////// CONSULTA OS EMPENHOS ATUAIS DO ITEM DO PEDIDO	///
	///////////////////////////////////////////////////////////
	
	//Executa apenas via documento de saida
	if IsInCallStack("Ma460Nota")
				
		cQry := " SELECT "                                          	   + cPulaLinha
		cQry += "   SB8.R_E_C_N_O_ RECSB8, "                        	   + cPulaLinha
		cQry += "   SDC.R_E_C_N_O_ RECSDC, "                        	   + cPulaLinha
		cQry += "   SBF.R_E_C_N_O_ RECSBF, "                        	   + cPulaLinha
		cQry += "   SC9.R_E_C_N_O_ RECSC9  "                        	   + cPulaLinha
		cQry += " FROM " + RetSQLName("SC9") + " SC9 "              	   + cPulaLinha
		cQry += "   INNER JOIN " + RetSQLName("SDC") + " SDC "      	   + cPulaLinha
		cQry += "     ON SDC.D_E_L_E_T_ = ' ' "                     	   + cPulaLinha
		cQry += "        AND SDC.DC_FILIAL = '" + xFilial("SDC") + "' "    + cPulaLinha	
		cQry += "        AND SDC.DC_PRODUTO = SC9.C9_PRODUTO "      	   + cPulaLinha
		cQry += "        AND SDC.DC_LOCAL = SC9.C9_LOCAL  "         	   + cPulaLinha
		cQry += "        AND SDC.DC_ORIGEM = 'SC6' "                	   + cPulaLinha
		cQry += "        AND SDC.DC_PEDIDO = SC9.C9_PEDIDO "        	   + cPulaLinha
		cQry += "        AND SDC.DC_ITEM = SC9.C9_ITEM "            	   + cPulaLinha
		cQry += "        AND SDC.DC_SEQ = SC9.C9_SEQUEN "           	   + cPulaLinha
		cQry += "        AND SDC.DC_LOTECTL = SC9.C9_LOTECTL "      	   + cPulaLinha
		cQry += "   INNER JOIN " + RetSQLName("SB8") + " SB8 "      	   + cPulaLinha
		cQry += "     ON SB8.D_E_L_E_T_ = ' ' "                     	   + cPulaLinha
		cQry += "        AND SB8.B8_FILIAL = '" + xFilial("SB8") + "' "    + cPulaLinha	
		cQry += "        AND SB8.B8_PRODUTO = SDC.DC_PRODUTO "      	   + cPulaLinha
		cQry += "        AND SB8.B8_LOCAL = SDC.DC_LOCAL "          	   + cPulaLinha
		cQry += "        AND SB8.B8_LOTECTL = SDC.DC_LOTECTL "      	   + cPulaLinha
		cQry += "   INNER JOIN " + RetSQLName("SBF") + " SBF "      	   + cPulaLinha
		cQry += "     ON SBF.D_E_L_E_T_ = ' ' "                     	   + cPulaLinha
		cQry += "        AND SBF.BF_FILIAL = '" + xFilial("SBF") + "' "    + cPulaLinha	
		cQry += "        AND SBF.BF_PRODUTO = SDC.DC_PRODUTO "      	   + cPulaLinha
		cQry += "        AND SBF.BF_LOCAL = SDC.DC_LOCAL "          	   + cPulaLinha
		cQry += "        AND SBF.BF_LOTECTL = SDC.DC_LOTECTL "      	   + cPulaLinha
		cQry += "        AND SBF.BF_LOCALIZ = SDC.DC_LOCALIZ "      	   + cPulaLinha
		cQry += " WHERE SC9.C9_FILIAL = '" + xFilial("SC9") + "' "         + cPulaLinha	
		cQry += "       AND SC9.C9_PEDIDO = '" + SC9->C9_PEDIDO + "' "     + cPulaLinha
		cQry += "       AND SC9.C9_BLEST = ' ' "                    	   + cPulaLinha
		cQry += "      	AND SC9.D_E_L_E_T_ = ' ' "                	       + cPulaLinha
		cQry += " 		AND SC9.C9_XREPEMP <> 'S' "						   + cPulaLinha 
		cQry := ChangeQuery(cQry)
				
		if Select("QRYREM") > 0
			QRYREM->(DbCloseArea())
		EndIf
				
		// Cria uma nova area com o resultado do query
		TcQuery cQry New Alias "QRYREM" 
		
		While QRYREM->(!Eof())
					
			dbSelectArea("SB8")
			DbGoTo(QRYREM->RECSB8)
	                
			DbSelectArea("SDC")
			DbGoTo(QRYREM->RECSDC)
	
			DbSelectArea("SBF")
			DbGoTo(QRYREM->RECSBF)
			
			SB8->(RecLock("SB8", .f.))
			SB8->B8_EMPENHO -= SDC->DC_QUANT
			SB8->B8_EMPENH2 -= SDC->DC_QTSEGUM
			SB8->(MsUnlock())
					
			SBF->(RecLock("SBF", .f.))
			SBF->BF_EMPENHO -= SDC->DC_QUANT
			SBF->BF_EMPEN2  -= SDC->DC_QTSEGUM
			SBF->(MsUnlock())
			
			
			DbSelectArea("SC9")
			DbGoTo(QRYREM->RECSC9)
			
			SC9->(RecLock("SC9", .f.))
			SC9->C9_XREPEMP  := "S"
			SC9->(MsUnlock())
			
					
			QRYREM->(DbSkip())
			
		EndDo
	
	endif
	
RestArea(aArea)
RestArea(aAreaSB8)
RestArea(aAreaSBF)
RestArea(aAreaSDC)
RestArea(aAreaSC9)

Return(cRet)
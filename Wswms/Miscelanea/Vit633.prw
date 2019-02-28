#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} Vit633
	Função para alterar o endereço dos itens selecionados para o endereço DOWNED (derrubada do evolutio para separação)
@author Microsiga
@since 13/06/2017
@version 1.0
@return ${return}, ${return_description}
@param cPedido, characters, descricao
@param cItem, characters, descricao
@param cSequencia, characters, descricao
@param cProduto, characters, descricao
@param cLote, characters, descricao
@type function
/*/
User Function Vit633(cPedido,cItem,cSequencia,cProduto,cLote)

Local nX     	 	:= 0
Local nY     	 	:= 0   
Local nI     	 	:= 0
Local nQtdEmp		:= 0
Local nQtdEmpSeg	:= 0
Local nQuantidade	:= 0
Local cDoc   	 	:= ""
Local cEndOrigem	:= ""
Local cPulaLinha	:= chr(13) + chr(10)
Local dDataValid	:= CTOD("")
Local lOk			:= .T.

PRIVATE lMsErroAuto := .F.

ConOut(Repl("-",80))
ConOut(PadC("Alteração do Pedido : " + cPedido,80))

	///////////////////////////////////////////////////////////
	////// CONSULTA OS EMPENHOS ATUAIS DO ITEM DO PEDIDO	///
	///////////////////////////////////////////////////////////
		
	cQry := " SELECT "                                          	   + cPulaLinha
	cQry += "   SB8.B8_LOTECTL, "                               	   + cPulaLinha
	cQry += "   SB8.B8_DFABRIC, "                               	   + cPulaLinha
	cQry += "   SB8.B8_DTVALID, "                               	   + cPulaLinha
	cQry += "   SB8.B8_LOCAL,   "                               	   + cPulaLinha
	cQry += "   SB8.B8_PRODUTO, "                               	   + cPulaLinha
	cQry += "   SB1.B1_DESC,    "                               	   + cPulaLinha
	cQry += "   SB8.B8_CLIFOR,  "                               	   + cPulaLinha
	cQry += "   SB8.B8_LOJA,    "                               	   + cPulaLinha
	cQry += "   SB8.B8_LOTEFOR, "                               	   + cPulaLinha
	cQry += "   SB8.R_E_C_N_O_ RECSB8, "                        	   + cPulaLinha
	cQry += "   SC9.R_E_C_N_O_ RECSC9, "                        	   + cPulaLinha
	cQry += "   SDC.R_E_C_N_O_ RECSDC, "                        	   + cPulaLinha
	cQry += "   SBF.R_E_C_N_O_ RECSBF, "                        	   + cPulaLinha
	cQry += "   SB1.R_E_C_N_O_ RECSB1  "                        	   + cPulaLinha
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
	cQry += "   INNER JOIN " + RetSQLName("SB1") + " SB1 "      	   + cPulaLinha
	cQry += "     ON SB1.D_E_L_E_T_ = ' ' "                     	   + cPulaLinha
	cQry += "        AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "    + cPulaLinha	
	cQry += "        AND SB1.B1_COD = SDC.DC_PRODUTO "          	   + cPulaLinha
	cQry += " WHERE SC9.C9_FILIAL = '" + xFilial("SC9") + "' "         + cPulaLinha	
	cQry += "       AND SC9.C9_PEDIDO = '" + cPedido + "' "            + cPulaLinha
	cQry += "       AND SC9.C9_ITEM = '" + cItem + "' "    			   + cPulaLinha
	cQry += "       AND SC9.C9_SEQUEN = '" + cSequencia + "' "         + cPulaLinha
	cQry += "       AND SC9.C9_BLEST = ' ' "                    	   + cPulaLinha
	cQry += "      	AND SC9.D_E_L_E_T_ = ' ' "                	       + cPulaLinha
	cQry += " 		AND SB8.B8_LOTECTL = '" + cLote + "' " 			   + cPulaLinha
	
	MemoWrite("C:\vit633.sql",cQry)
	
	cQry := ChangeQuery(cQry)
	
	If Select("QVIT633") > 0
		QVIT633->(DbCloseArea())
	EndIf
	
	TcQuery cQry New Alias "QVIT633" // Cria uma nova area com o resultado do query
		
	QVIT633->(dbGoTop())
	
	While QVIT633->(!Eof())
		
		dbSelectArea("SB8")
		dbGoTo(QVIT633->RECSB8)
	    
		dbSelectArea("SC9")
		dbGoTo(QVIT633->RECSC9)
	
		dbSelectArea("SDC")
		dbGoTo(QVIT633->RECSDC)
	
		dbSelectArea("SBF")
		dbGoTo(QVIT633->RECSBF)
		
		dbSelectArea("SB1")
		dbGoTo(QVIT633->RECSB1)
		
		cEndOrigem	:= SDC->DC_LOCALIZ	
		cEndDestino := Pad('DOWNED', TamSX3('BF_LOCALIZ')[1])
		cLote		:= SB8->B8_LOTECTL
		dDataValid	:= SB8->B8_DTVALID
		nQuantidade	:= SDC->DC_QUANT
		
		//se o item ja estiver no Downed nao realiza a transferencia 
		if cEndOrigem <> cEndDestino
			
			SB8->(RecLock("SB8", .f.))
			SB8->B8_EMPENHO -= SDC->DC_QUANT
			SB8->B8_EMPENH2 -= SDC->DC_QTSEGUM
			SB8->(MsUnlock())
		
			SBF->(RecLock("SBF", .f.))
			SBF->BF_EMPENHO -= SDC->DC_QUANT
			SBF->BF_EMPEN2  -= SDC->DC_QTSEGUM
			SBF->(MsUnlock())
		
			SDC->(RecLock("SDC", .f.))
			SDC->DC_LOCALIZ := 'DOWNED'
			SDC->(MsUnlock())
			
			//realizo a transferencia para o Downed
			if U_MVInternaMod2(3,SB1->B1_COD,SB1->B1_DESC,SB1->B1_UM,SC9->C9_LOCAL,cEndOrigem,SC9->C9_LOCAL,cEndDestino,cLote,dDataValid,nQuantidade)
				
				//volto o saldo para SBF - Saldos por Endereco
				SBF->(DbSetOrder(7)) //BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_LOCALIZ
				
				if !SBF->( DbSeek( xFilial("SBF") + SB1->B1_COD + SC9->C9_LOCAL + cLote + cEndDestino   ) )
				
					lOk	:= .F.
					Help( ,, 'Help',,"Não foi encontrou o endereço ("+Alltrim(cEndDestino)+") para transferir os empenhos do endereço (" + Alltrim(cEndOrigem) , 1, 0 )
					
				else
					
					SBF->(RecLock("SBF", .f.))
					SBF->BF_EMPENHO += nQuantidade
					SBF->BF_EMPEN2  += ConvUM(SB1->B1_COD,nQuantidade,0,2)
					SBF->(MsUnlock())
					
					//volto o empenho do lote, pois o ExecAuto nao realiza o reempenho							
					SB8->(RecLock("SB8", .f.))
							
					SB8->B8_EMPENHO += SDC->DC_QUANT
					SB8->B8_EMPENH2 += SDC->DC_QTSEGUM
							
					SB8->(MsUnlock())
							
				endif
			else
				lOk	:= .F.
				exit
			endif
		
		endif
				
		QVIT633->(dbSkip())
	
	EndDo
	
	QVIT633->(dbCloseArea())
    
Return(lOk)

/*/{Protheus.doc} MVInternaMod2
/@Description - Funcao para realizar a transferencia
do pedido para o endereco Downed
@author Raphael Martins
@since 27/12/2017
@version 1.0
@return lRet
@type function
/*/
User Function MVInternaMod2(nOpc, cProduto, cDescProd, cUM, cArmazOri, cEndOrigem, cArmazDst, cEndDestino, cLote, dDataVl, nQuant)
Local nX		:= 0
Local lOk 		:= .T.                             
Local cMsgErr 	:= ""
Local aMsgErr 	:= {}
Local aTransf	:= {}
Local aAreaSB8	:= SB8->(GetArea())
Local aArea		:= GetArea()
Local aAreaSDC	:= SDC->(GetArea())
Local aAreaSBF	:= SBF->(GetArea())
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSC9	:= SC9->(GetArea())
Local cDoc 		:= GetSxENum("SD3","D3_DOC",1)		
                  
Private	lMsErroAuto := .F.       

Default nOpc := 3 // Indica qual tipo de ação será tomada (Inclusão/Estorno), o default é 3=Inclusão
	
	aTransf := Array(2)  
	aTransf[1]:= {cDoc,dDataBase}    
		
	aTransf[2] := { {"D3_COD"		,cProduto						,NIL}} 			 //01.Produto Origem		
			
	aadd(aTransf[2],{"D3_DESCRI"	,cDescProd						,NIL}) 			 //02.Descricao			
	aadd(aTransf[2],{"D3_UM"		,cUM							,NIL}) 			 //03.Unidade de Medida		
	aadd(aTransf[2],{"D3_LOCAL"		,cArmazOri						,NIL}) 			 //04.Local Origem		
	aadd(aTransf[2],{"D3_LOCALIZ"	,cEndOrigem						,NIL}) 			 //05.Endereco Origem		
	aadd(aTransf[2],{"D3_COD"		,cProduto						,NIL}) 			 //06.Produto Destino		
	aadd(aTransf[2],{"D3_DESCRI"	,cDescProd						,NIL})			 //07.Descricao				
	aadd(aTransf[2],{"D3_UM"		,cUM							,NIL})			 //08.Unidade de Medida		
	aadd(aTransf[2],{"D3_LOCAL"		,cArmazDst						,NIL})		     //09.Armazem Destino 		
	aadd(aTransf[2],{"D3_LOCALIZ"	,cEndDestino					,NIL})		     //10.Endereco Destino		
	aadd(aTransf[2],{"D3_NUMSERI"	,Criavar("D3_NUMSERI")			,NIL}) 		   	 //11.Numero de Serie		
	aadd(aTransf[2],{"D3_LOTECTL"	,cLote							,NIL})			 //12.Lote Origem  		
	aadd(aTransf[2],{"D3_NUMLOTE"	,criavar("D3_NUMLOTE")			,NIL}) 		   	 //13.Sub-Lote		
	aadd(aTransf[2],{"D3_DTVALID"	,criavar("D3_DTVALID")			,NIL})		 	 //14.Data de Validade		
	aadd(aTransf[2],{"D3_POTENCI"	,criavar("D3_POTENCI")			,NIL})    		 //15.Potencia do Lote		
	aadd(aTransf[2],{"D3_QUANT"		,nQuant							,NIL}) 			 //16.Quantidade		
	aadd(aTransf[2],{"D3_QTSEGUM"	,ConvUM(cProduto,nQuant,0,2)	,NIL})		 	 //17.Quantidade na 2 UM		
	aadd(aTransf[2],{"D3_ESTORNO"	,Criavar("D3_ESTORNO")			,NIL}) 	 		 //18.Estorno		
	aadd(aTransf[2],{"D3_NUMSEQ"	,Criavar("D3_NUMSEQ")			,NIL})     		 //19.NumSeq 		
	aadd(aTransf[2],{"D3_LOTECTL"	,cLote							,NIL})	 		 //20.Lote Destino		
	aadd(aTransf[2],{"D3_DTVALID"	,dDataVl						,NIL})	 		 //21.Data de Validade Destino 

	lMsErroAuto	:= .F.
	
	MSExecAuto({|x,y| mata261(x,y)},aTransf,3)	
	
	if lMsErroAuto    
		lOk 	:= .F.
		MostraErro()
	
	    RollbackSx8()
	else
	 	ConfirmSx8()
	endif    
		
	RestArea(aAreaSB8)	
	RestArea(aArea)
	RestArea(aAreaSDC)
	RestArea(aAreaSBF)
	RestArea(aAreaSB1)
	RestArea(aAreaSC9)

Return(lOk)
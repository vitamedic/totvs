#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UWSWMS14 ºAutor  ³Microsiga           º Data ³  20/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Metodo WS para consulta de ordem de separação (PV) ITENS    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UWSWMS14(oFil, oRet)

	Local lOk 		:= .T.
	Local cMsgErr 	:= ""
	Local cQry		:= ""	
	Local nQtdReg	:= 0
	Local cPEDIDO 	:= ""
	Local cNUM_OS 	:= ""	

	Local oNewItensOS
	
	PRIVATE lMsErroAuto := .F.
	
	oRet:aRet 	 := {}
	oRet:lRet	 := .t.
	oRet:cErros	 := ""
	oRet:nQtdReg := 0   
	
	if empty(oFil:cEmpresa)
		oFil:cEmpresa := "01"
		oFil:cParFil  := "01"
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
	
	if lOk .AND. empty(oFil:cPedido)
		cMsgErr := "Ordem de separação não informada."
		lOk := .F.  
		
	elseif empty( cPEDIDO := Posicione("Z52", 2, XFilial("Z52")+Pad(oFil:cPedido, TamSX3("Z52_PEDIDO")[1]+TamSX3("Z52_NUMOS")[1],"x"), "Z52_PEDIDO") )
			cMsgErr := "Ordem de separação não localizada."
			lOk := .F.  
			
	elseif empty(cNUM_OS := Z52->Z52_NUMOS)
			cMsgErr := "Ordem de separação não localizada."
			lOk := .F.  
			
	endif
	
	if lOK
		cQry :=        "  SELECT Z52.Z52_PEDIDO "
		cQry += CRLF + "       , Z52_NUMOS "
		cQry += CRLF + "       , Z52.Z52_ITEM "
		cQry += CRLF + "       , Z52.Z52_SEQ "
		cQry += CRLF + "       , Z52.Z52_COD "
		cQry += CRLF + "       , Z52.Z52_QTDLIB "
		cQry += CRLF + "       , SC9.C9_PRCVEN "
		cQry += CRLF + "       , SB1.B1_DESC "
		cQry += CRLF + "       , SB1.B1_UM "
		cQry += CRLF + "       , Z52.Z52_CLIENT "
		cQry += CRLF + "       , Z52.Z52_LOJA "
		cQry += CRLF + "       , SA1.A1_NOME "
		cQry += CRLF + "       , SA1.A1_ESTE "
		cQry += CRLF + "       , SA1.A1_MUNE "
		cQry += CRLF + "       , SA1.A1_ENDENT "
		cQry += CRLF + "       , SA1.A1_BAIRROE "
		cQry += CRLF + "       , SA1.A1_CEPE "
		cQry += CRLF + "       , SA4.A4_COD "
		cQry += CRLF + "       , SA4.A4_NOME "
		cQry += CRLF + "       , SC5.C5_EMISSAO "
		cQry += CRLF + "       , Z52.Z52_DATALI "
		cQry += CRLF + "       , SF2.F2_VOLUME1 " 
		cQry += CRLF + "       , SF2.F2_ESPECI1 "
		cQry += CRLF + "       , SF2.F2_PLIQUI "
		cQry += CRLF + "       , SF2.F2_PBRUTO "
		cQry += CRLF + "       , SF2.F2_VALBRUT "
		cQry += CRLF + "       , SD2.D2_QUANT " 
		cQry += CRLF + "       , SD2.D2_PESO " 
		cQry += CRLF + "       , SD2.D2_PRCVEN " 
		cQry += CRLF + "       , SDB.DB_LOCALIZ ENDERECO " 
		cQry += CRLF + "       , CASE WHEN SDB.DB_LOCAL <> ' ' THEN SDB.DB_LOCAL ELSE Z52.Z52_LOCAL END Z52_LOCAL " 
		cQry += CRLF + "       , CASE WHEN SDB.DB_LOTECTL <> ' ' THEN SDB.DB_LOTECTL ELSE Z52.Z52_LOTECT END Z52_LOTECT " 
		cQry += CRLF + " FROM " + RetSqlName("Z52") + " Z52 "
		cQry += CRLF + "  INNER JOIN " + RetSqlName("SB1") + " SB1 ON (SB1.B1_FILIAL   = '" + xFilial("SB1") + "' "
		cQry += CRLF + "                                               AND SB1.B1_COD  = Z52.Z52_COD "
		cQry += CRLF + "                                              ) "
		cQry += CRLF + "  LEFT JOIN " + RetSqlName("SC9") + " SC9 ON (SC9.C9_FILIAL = '" + xFilial("SC9") + "' "
		cQry += CRLF + "                                              AND SC9.C9_PEDIDO  = Z52.Z52_PEDIDO "
		cQry += CRLF + "                                              AND SC9.C9_ITEM    = Z52.Z52_ITEM "
		cQry += CRLF + "                                              AND SC9.C9_SEQUEN  = Z52.Z52_SEQ "
		cQry += CRLF + "                                              AND SC9.D_E_L_E_T_ = ' ' "
		cQry += CRLF + "                                             ) "
		cQry += CRLF + "  LEFT JOIN " + RetSqlName("SDC") + " SDC ON (SDC.DC_FILIAL = '" + xFilial("SDC") + "' "
		cQry += CRLF + "                                              AND SDC.DC_PRODUTO = SC9.C9_PRODUTO "
		cQry += CRLF + "                                              AND SDC.DC_LOCAL   = SC9.C9_LOCAL "
		cQry += CRLF + "                                              AND SDC.DC_ORIGEM  = 'SC6' "
		cQry += CRLF + "                                              AND SDC.DC_PEDIDO  = SC9.C9_PEDIDO "
		cQry += CRLF + "                                              AND SDC.DC_ITEM    = SC9.C9_ITEM "
		cQry += CRLF + "                                              AND SDC.DC_SEQ     = SC9.C9_SEQUEN "
		cQry += CRLF + "                                              AND SDC.DC_LOTECTL = SC9.C9_LOTECTL "
		cQry += CRLF + "                                              AND SDC.DC_NUMLOTE = SC9.C9_NUMLOTE "
		cQry += CRLF + "                                              AND SDC.D_E_L_E_T_ = ' ' "
		cQry += CRLF + "                                             ) "
		cQry += CRLF + "  INNER JOIN " + RetSqlName("SA1") + " SA1 ON (SA1.A1_FILIAL   = '" + xFilial("SA1") + "' "
		cQry += CRLF + "                                               AND SA1.A1_COD  = Z52.Z52_CLIENT "
		cQry += CRLF + "                                               AND SA1.A1_LOJA = Z52.Z52_LOJA "
		cQry += CRLF + "                                              ) "
		cQry += CRLF + "  INNER JOIN " + RetSqlName("SC5") + " SC5 ON (SC5.D_E_L_E_T_    = ' ' "
		cQry += CRLF + "                           AND SC5.C5_FILIAL  = '" + xFilial("SC5") + "' "
		cQry += CRLF + "                           AND SC5.C5_NUM     = Z52.Z52_PEDIDO "
		cQry += CRLF + "                           ) "
		cQry += CRLF + "  LEFT JOIN " + RetSqlName("SD2") + " SD2 ON (SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
		cQry += CRLF + "                           AND SD2.D2_PEDIDO = Z52.Z52_PEDIDO "
		cQry += CRLF + "                           AND SD2.D2_ITEMPV = Z52.Z52_ITEM "
		cQry += CRLF + "                           AND SD2.D_E_L_E_T_      = ' ' "
		cQry += CRLF + "                         ) "                                
		cQry += CRLF + "  LEFT JOIN " + RetSqlName("SDB") + " SDB ON (SDB.DB_FILIAL  = '" + xFilial("SDB") + "' "
		cQry += CRLF + "                                          AND SDB.DB_PRODUTO = SD2.D2_COD "
		cQry += CRLF + "                                          AND SDB.DB_LOCAL   = SD2.D2_LOCAL "
		cQry += CRLF + "                                          AND SDB.DB_NUMSEQ  = SD2.D2_NUMSEQ "
		cQry += CRLF + "                                          AND SDB.DB_DOC     = SD2.D2_DOC "
		cQry += CRLF + "                                          AND SDB.DB_SERIE   = SD2.D2_SERIE "
		cQry += CRLF + "                                          AND SDB.DB_CLIFOR  = SD2.D2_CLIENTE "
		cQry += CRLF + "                                          AND SDB.DB_LOJA    = SD2.D2_LOJA "
		cQry += CRLF + "                                          AND SDB.DB_ITEM    = ('00'||SD2.D2_ITEM) "
		cQry += CRLF + "                                          AND SDB.D_E_L_E_T_ = ' ' "
		cQry += CRLF + "                         ) "
		cQry += CRLF + "  LEFT JOIN " + RetSqlName("SF2") + " SF2 ON (SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
		cQry += CRLF + "                           AND SF2.F2_DOC = SD2.D2_DOC "
		cQry += CRLF + "                           AND SF2.F2_SERIE = SD2.D2_SERIE "
		cQry += CRLF + "                           AND SF2.D_E_L_E_T_      = ' ' "
		cQry += CRLF + "                         ) "
		cQry += CRLF + "  LEFT JOIN " + RetSqlName("SA4") + " SA4 ON (SA4.A4_FILIAL       = '" + xFilial("SA4") + "' "
		cQry += CRLF + "                           AND SA4.A4_COD      = SF2.F2_TRANSP "
		cQry += CRLF + "                           AND SA4.D_E_L_E_T_  = ' ' "
		cQry += CRLF + "                         ) "
		cQry += CRLF + " "
		cQry += CRLF + " WHERE Z52.Z52_FILIAL  = '" + xFilial("Z52") + "' "
		cQry += CRLF + "   AND Z52.Z52_PEDIDO  = '" + cPEDIDO + "' "
		cQry += CRLF + "   AND Z52.Z52_NUMOS   = '" + cNUM_OS + "' "
		cQry += CRLF + "   AND Z52.Z52_STATUS  IN ('1', '2', '3', '5') "
		
		MemoWrite("c:\temp\UWSWMS14.sql", cQry)
		cQry := ChangeQuery(cQry)
		
		If Select("QRYWS1") > 0
			QRYWS1->(DbCloseArea())
		EndIf
		
		TcQuery cQry New Alias "QRYWS1" // Cria uma nova area com o resultado do query
		
		QRYWS1->(dbGoTop())
		
		if QRYWS1->(Eof())
		  	// Cria e alimenta uma nova instancia do consulta OS
		  	oNewItensOS :=  WSClassNew( "Ret_ItensOS" )
		  	
		  	oNewItensOS:NUM_OS 			:= ""
		  	oNewItensOS:NUM_ITEM 		:= ""
		  	oNewItensOS:COD_ITEM 		:= ""
		  	oNewItensOS:DESC_ITEM 		:= ""
		  	oNewItensOS:UM_ITEM 		:= ""
		  	oNewItensOS:ABREV_ITEM 		:= ""
		  	oNewItensOS:LOTE 			:= ""
		  	oNewItensOS:ARMAZEM 		:= "" //QRYWS1-> //Armazém (????)
		  	oNewItensOS:ENDERECO 		:= ""
		  	oNewItensOS:QUANT 			:= 0
		  	oNewItensOS:VLR_UNIT 		:= 0
		  	oNewItensOS:PESO_UNIT 		:= 0
	  	
		  	AAdd( oRet:aRet, oNewItensOS )
                                                                    
			lOK := .f.
		  	cMsgErr := "Itens da ordem de separação não encontrados"
		else
			While QRYWS1->(!Eof())
				
			  	// Cria e alimenta uma nova instancia 
			  	oNewItensOS :=  WSClassNew( "Ret_ItensOS" )
			  	
			  	oNewItensOS:NUM_OS 			:= QRYWS1->(Z52_PEDIDO + Z52_NUMOS)
			  	oNewItensOS:NUM_ITEM 		:= QRYWS1->(Z52_ITEM+Z52_SEQ)
			  	oNewItensOS:COD_ITEM 		:= QRYWS1->Z52_COD
			  	oNewItensOS:DESC_ITEM 		:= QRYWS1->B1_DESC
			  	oNewItensOS:UM_ITEM 		:= QRYWS1->B1_UM
			  	oNewItensOS:ABREV_ITEM 		:= "" //Abreviação 
			  	oNewItensOS:LOTE 			:= QRYWS1->Z52_LOTECT 
			  	oNewItensOS:ARMAZEM 		:= QRYWS1->Z52_LOCAL
			  	oNewItensOS:ENDERECO 		:= QRYWS1->ENDERECO
			  	oNewItensOS:QUANT 			:= QRYWS1->Z52_QTDLIB
			  	oNewItensOS:VLR_UNIT 		:= QRYWS1->C9_PRCVEN
			  	oNewItensOS:PESO_UNIT 		:= QRYWS1->D2_PESO

			  	AAdd( oRet:aRet, oNewItensOS )
			
				nQtdReg++
				lOK := .t.
			
				QRYWS1->(DbSkip())
			enddo
		endif
			
		QRYWS1->(DbCloseArea())
		
	endif                      
	
	oRet:lRet	 := lOK
	oRet:cErros	 := cMsgErr
	oRet:nQtdReg := nQtdReg

Return(.t.)
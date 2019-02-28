#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ UWSWMS11 บAutor  ณMicrosiga           บ Data ณ  20/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para consulta de transportadora por PV             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSWMS11(oFil, oRet)

	Local lOk := .T.
	Local cMsgErr 	:= ""
	Local cQry		:= ""	
	Local nQtdReg	:= 0
	Local oNewTransportadora
	
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
	
	if lOK
		
		cQry := " SELECT SA4.A4_COD, SA4.A4_NOME, COUNT(SD2.D2_ITEMPV) QTD_ITENS "
		cQry += " FROM " + RetSqlName("Z52") + " Z52 "
		cQry += " INNER JOIN " + RetSqlName("SD2") + " SD2 ON (SD2.D2_FILIAL   = '" + xFilial("SD2") + "' "
		cQry += "                                              AND SD2.D2_PEDIDO  = Z52.Z52_PEDIDO "
		cQry += "                                              AND SD2.D2_ITEMPV  = Z52.Z52_ITEM "
		cQry += "                                              AND SD2.D_E_L_E_T_ = ' ' "
		cQry += "                                             ) "
		cQry += " INNER JOIN " + RetSqlName("SF2") + " SF2 ON (SF2.F2_FILIAL      = '" + xFilial("SF2") + "' "
		cQry += "                                              AND SF2.F2_DOC     = SD2.D2_DOC "
		cQry += "                                              AND SF2.F2_SERIE   = SD2.D2_SERIE "
		cQry += "                                              AND SF2.D_E_L_E_T_ = ' ' "
		cQry += "                                             ) "
		cQry += " INNER JOIN " + RetSqlName("SA4") + " SA4 ON (SA4.A4_FILIAL   = '" + xFilial("SA4") + "' "
		cQry += "                                              AND SA4.A4_COD  = SF2.F2_TRANSP "
		cQry += "                                             ) "
		cQry += CRLF + " WHERE Z52.D_E_L_E_T_  = ' ' "
		cQry += CRLF + "   AND Z52.Z52_FILIAL  = '" + xFilial("Z52") + "' "
		
		if !empty(oFil:cCodigo) .and. oFil:cCodigo <> "?"
			cQry += CRLF + "   AND SA4.A4_COD = '" + Alltrim(oFil:cCodigo) + "' "
		endif
		
		cQry += CRLF + "   AND Z52.Z52_STATUS IN ('1', '3', '5') "
		cQry += " GROUP BY SA4.A4_COD, SA4.A4_NOME "
		
		cQry := ChangeQuery(cQry)
		
		If Select("QRYWS1") > 0
			QRYWS1->(DbCloseArea())
		EndIf
		
		TcQuery cQry New Alias "QRYWS1" // Cria uma nova area com o resultado do query
		
		QRYWS1->(dbGoTop())
		
		if QRYWS1->(Eof())
		  	// Cria e alimenta uma nova instancia do Transportadora
		  	oNewTransportadora :=  WSClassNew( "Arr_Transportadoras" )
		  	
		  	oNewTransportadora:CODIGO 		:= ""
		  	oNewTransportadora:RAZAOSOCIAL 	:= ""
		  	
		  	AAdd( oRet:aRet, oNewTransportadora )

			lOK := .f.
		  	cMsgErr := "Nใo tem ordens de separa็ใo faturadas, portanto nใo ้ possํvel retornar lista de transportadoras"
		else
			While QRYWS1->(!Eof())
				
			  	// Cria e alimenta uma nova instancia 
			  	oNewTransportadora :=  WSClassNew( "Arr_Transportadoras" )
			  	
			  	oNewTransportadora:CODIGO 		:= QRYWS1->A4_COD
			  	oNewTransportadora:RAZAOSOCIAL 	:= QRYWS1->A4_NOME
			  	
			  	AAdd( oRet:aRet, oNewTransportadora )
			
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
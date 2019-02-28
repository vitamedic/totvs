#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUWSWMS02  บAutor  ณMicrosiga           บ Data ณ  25/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para consulta de Tipos de Produtos                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSWMS02(oFil, oRet)

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
	Local oNewTpProd
	
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
		    	
		cQry := " SELECT * FROM " + RetSqlName("SX5") + " "
		cQry += " WHERE X5_FILIAL = '" + xFilial("SX5") + "' "
		cQry += " AND X5_TABELA = '02' "
		cQry += " AND D_E_L_E_T_ <> '*' "
		cQry += " ORDER BY X5_CHAVE " 
		
		cQry := ChangeQuery(cQry)
		
		If Select("QRYWS2") > 0
			QRYWS2->(DbCloseArea())
		EndIf
		
		TcQuery cQry New Alias "QRYWS2" // Cria uma nova area com o resultado do query
		
		QRYWS2->(dbGoTop())
		
		if QRYWS2->(Eof())
		  	// Cria e alimenta uma nova instancia do cliente
		  	oNewTpProd :=  WSClassNew( "WSTpProd" )
		  	
		  	oNewTpProd:cCodigo 		:= ""
		  	oNewTpProd:cDescricao 	:= ""
		  	
		  	AAdd( oRet:aRet, oNewTpProd )
		else
			While QRYWS2->(!Eof())
				
			  	// Cria e alimenta uma nova instancia do cliente
			  	oNewTpProd :=  WSClassNew( "WSTpProd" )
			  	
			  	oNewTpProd:cCodigo 		:= Alltrim(QRYWS2->X5_CHAVE)
			  	oNewTpProd:cDescricao 	:= AllTrim(QRYWS2->X5_DESCRI)
			  	
			  	AAdd( oRet:aRet, oNewTpProd )
			
				nQtdReg++
				lOK := .t.
			
				QRYWS2->(DbSkip())
			enddo
		endif
			
		QRYWS2->(DbCloseArea())
		
	endif                      
	
	oRet:lRet	 := lOK
	oRet:cErros	 := cMsgErr
	oRet:nQtdReg := nQtdReg

Return(.t.)
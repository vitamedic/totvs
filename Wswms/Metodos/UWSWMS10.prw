#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ UWSWMS10 บAutor  ณMicrosiga           บ Data ณ  20/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para consulta de clientes por pedido de venda     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSWMS10(oFil, oRet)

	Local lOk := .T.
	Local cMsgErr 	:= ""
	Local cQry		:= ""	
	Local nQtdReg	:= 0
	Local oNewCliente
	
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
		
		cQry :=        " SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, COUNT(Z52.Z52_PEDIDO) QTD_PEDIDOS "
		cQry += CRLF + " FROM " + RetSqlName("Z52") + " Z52 "
		cQry += CRLF + " INNER JOIN " + RetSqlName("SA1") + " SA1 ON (SA1.A1_FILIAL   = '" + xFilial("SA1") + "' "
		cQry += CRLF + "                                              AND SA1.A1_COD  = Z52.Z52_CLIENT "
		cQry += CRLF + "                                              AND SA1.A1_LOJA = Z52.Z52_LOJA "
		cQry += CRLF + "                                             ) "
		cQry += CRLF + " WHERE Z52.D_E_L_E_T_  = ' ' "
		cQry += CRLF + "   AND Z52.Z52_FILIAL  = '" + xFilial("Z52") + "' "
		
		if !empty(oFil:cCodigo) .and. oFil:cCodigo <> "?"
			cQry += CRLF + "   AND ( SA1.A1_COD || SA1.A1_LOJA ) = '" + Alltrim(oFil:cCodigo) + "' "
		endif
		
		cQry += CRLF + "   AND Z52.Z52_STATUS IN ('1', '3', '5') "
		cQry += CRLF + " GROUP BY SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME "
		cQry += CRLF + " ORDER BY SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME "
		
		cQry := ChangeQuery(cQry)
		
		If Select("QRYWS1") > 0
			QRYWS1->(DbCloseArea())
		EndIf
		
		TcQuery cQry New Alias "QRYWS1" // Cria uma nova area com o resultado do query
		
		QRYWS1->(dbGoTop())
		
		if QRYWS1->(Eof())
		  	// Cria e alimenta uma nova instancia do cliente
		  	oNewCliente :=  WSClassNew( "Ret_Clientes" )
		  	
		  	oNewCliente:CODIGO 		:= ""
		  	oNewCliente:RAZAOSOCIAL := ""
		  	
		  	AAdd( oRet:aRet, oNewCliente )
		  	
			lOK := .f.
		  	cMsgErr := "Nใo tem ordens de separa็ใo disponํveis, portanto nใo ้ possํvel retornar lista de clientes"
		else
			While QRYWS1->(!Eof())
				
			  	// Cria e alimenta uma nova instancia 
			  	oNewCliente :=  WSClassNew( "Ret_Clientes" )
			  	
			  	oNewCliente:CODIGO 		:= QRYWS1->(A1_COD+A1_LOJA)
			  	oNewCliente:RAZAOSOCIAL := QRYWS1->A1_NOME
			  	
			  	AAdd( oRet:aRet, oNewCliente )
			
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
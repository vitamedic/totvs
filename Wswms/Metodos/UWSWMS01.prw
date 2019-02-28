#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �UWSWMS01  �Autor  �Microsiga           � Data �  19/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Metodo WS para consulta de Endere�os                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function UWSWMS01(oFil, oRet)

	Local lOk := .T.
	Local cMsgErr 	:= ""
	Local cQry		:= ""	
	Local nQtdReg	:= 0
	Local oNewEndere
	
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
	
	if lOK
		
		cQry := " SELECT * FROM " + RetSqlName("SBE") + " "
		cQry += " WHERE D_E_L_E_T_ <> '*' "
		cQry += "   AND BE_FILIAL = '" + xFilial("SBE") + "' "
		cQry += "   AND BE_MSBLQL <> '1'"
		
		if !empty(oFil:cArmazem)
			cQry += "   AND BE_LOCAL = '"+Alltrim(oFil:cArmazem)+"' "
		endif
		if !empty(oFil:cEnderecoDe) .OR. !empty(oFil:cEnderecoAte)
			cQry += "   AND BE_LOCALIZ BETWEEN '"+oFil:cEnderecoDe+"' AND '"+oFil:cEnderecoAte+"' "
		endif
		cQry += " ORDER BY BE_LOCAL, BE_LOCALIZ " 		    		
		
		cQry := ChangeQuery(cQry)
		
		If Select("QRYWS1") > 0
			QRYWS1->(DbCloseArea())
		EndIf
		
		TcQuery cQry New Alias "QRYWS1" // Cria uma nova area com o resultado do query
		
		QRYWS1->(dbGoTop())
		
		if QRYWS1->(Eof())
		  	// Cria e alimenta uma nova instancia do cliente
		  	oNewEndere :=  WSClassNew( "WSEndereco" )
		  	
		  	oNewEndere:CODIGO 	:= ""
		  	oNewEndere:ARMAZEM 	:= ""
		  	oNewEndere:STATUS 	:= ""
		  	oNewEndere:TIPO 	:= ""
		  	oNewEndere:AREA 	:= ""
		  	
		  	AAdd( oRet:aRet, oNewEndere )
		else
			While QRYWS1->(!Eof())
				
			  	// Cria e alimenta uma nova instancia 
			  	oNewEndere :=  WSClassNew( "WSEndereco" )
			  	
			  	oNewEndere:CODIGO 	:= Alltrim(QRYWS1->BE_LOCALIZ)
			  	oNewEndere:ARMAZEM 	:= QRYWS1->BE_LOCAL
			  	oNewEndere:STATUS 	:= QRYWS1->BE_STATUS  //1=Desocupado;2=Ocupado;3=Bloqueado
			  	oNewEndere:TIPO 	:= QRYWS1->BE_ESTFIS
			  	oNewEndere:AREA 	:= QRYWS1->BE_CODZON
			  	
			  	AAdd( oRet:aRet, oNewEndere )
			
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
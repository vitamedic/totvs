#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � UWSWMS12 �Autor  �Microsiga           � Data �  20/04/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Metodo WS para consulta de fornecedores                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function UWSWMS12(oFil, oRet)

	Local lOk := .T.
	Local cMsgErr 	:= ""
	Local cQry		:= ""	
	Local nQtdReg	:= 0
	Local oNewFornecedor
	
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
		
		cQry := " SELECT SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NOME "
		cQry += " FROM " + RetSqlName("SA2") + " SA2 "
		cQry += " WHERE SA2.D_E_L_E_T_ = ' ' "
		cQry += "   AND SA2.A2_FILIAL  = '" + xFilial("SA2") + "' "
		
        if !empty(oFil:cCodigo) .and. oFil:cCodigo <> "?"
			cQry += "   AND ( SA2.A2_COD || SA2.A2_LOJA )    = '" + Alltrim(oFil:cCodigo) + "' "
		endif

		cQry += " ORDER BY SA2.A2_NOME "
		
		cQry := ChangeQuery(cQry)
		
		If Select("QRYWS1") > 0
			QRYWS1->(DbCloseArea())
		EndIf
		
		TcQuery cQry New Alias "QRYWS1" // Cria uma nova area com o resultado do query
		
		QRYWS1->(dbGoTop())
		
		if QRYWS1->(Eof())
		  	// Cria e alimenta uma nova instancia do Fornecedor
		  	oNewFornecedor :=  WSClassNew( "Arr_Fornecedores" )
		  	
		  	oNewFornecedor:CODIGO 		:= ""
		  	oNewFornecedor:RAZAOSOCIAL 	:= ""
		  	
		  	AAdd( oRet:aRet, oNewFornecedor )
			
			lOK := .f.
			cMsgErr := "N�o foram encontrados fornecedores cadastrados."
		else
			While QRYWS1->(!Eof())
				
			  	// Cria e alimenta uma nova instancia 
			  	oNewFornecedor :=  WSClassNew( "Arr_Fornecedores" )
			  	
			  	oNewFornecedor:CODIGO 		:= QRYWS1->(A2_COD+A2_LOJA)
			  	oNewFornecedor:RAZAOSOCIAL 	:= QRYWS1->A2_NOME
			  	
			  	AAdd( oRet:aRet, oNewFornecedor )
			
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
#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UWSWMS08  ºAutor  ³Microsiga           º Data ³  27/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Metodo WS para consulta de Estrutura de Produtos (Revisao)  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UWSWMS08(oFil, oRet)

	Local lOk 			:= .T.
	Local cMsgErr 		:= ""
	Local cError   		:= ""
	Local cWarning 		:= ""
	Local cQry			:= ""	
	Local nQtdReg		:= 0
	Local cDados		:= ""
	Local nQtdRequerida := 1
	Local MV_CQ     	:= GetMV("MV_CQ")
	Local aStruct   	:= {}
	Local oNewEstruct
	
	PRIVATE nEstru 		:= 0 
	PRIVATE lMsErroAuto := .F.
	
	oRet:aRet    := {}
	oRet:lRet	 := .t.
	oRet:cErros  := ""
	oRet:nQtdReg := 0   
	
	if empty(oFil:cEmpresa)
		oFil:cEmpresa := "01"
		oFil:cParFil  := "01"
	endif                

	//se não foi configurado WS para ja vir logado na empresa e filial, faço criação do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U' 
		RpcSetType(3)
		lConect := RpcSetEnv(oFil:cEmpresa, oFil:cFilial)
		if !lConect
			cMsgErr := "Não foi possível conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif
	
	if lOK
	
		If !Empty(oFil:nQtdRequerida)
			nQtdRequerida := oFil:nQtdRequerida
		EndIf

		cNomeAli := "QRYWS8" //"ES"+StrZero(nNAlias,3)
		cNomeArq := u_Estrut2(oFil:cCodProd, nQtdRequerida, cNomeAli)
		dbSelectArea(cNomeAli)
		dbGoTop()
		
		While (cNomeAli)->(!Eof())

		  	oNewEstruct :=  WSClassNew( "WSReviStru" )
			oNewEstruct:FILIAL	 	 := (cNomeAli)->NIVEL
			oNewEstruct:NUM_REV	 	 := (cNomeAli)->REVISAO
			oNewEstruct:NUM_VERSAO	 := (cNomeAli)->TRT
			oNewEstruct:COD_PROD	 := (cNomeAli)->CODIGO
			oNewEstruct:SEQ_ITEM	 := (cNomeAli)->TRT
			oNewEstruct:COD_ITEM	 := (cNomeAli)->COMP
			oNewEstruct:QTD_BASE	 := NoRound((cNomeAli)->QUANT,2)
			oNewEstruct:UM_ITEM	 	 := (cNomeAli)->UM
			oNewEstruct:CLASSE	 	 := Iif((cNomeAli)->CLASSE="I", " ", (cNomeAli)->CLASSE)
			oNewEstruct:POTENCIA	 := NoRound((cNomeAli)->POTENCI,2)
			oNewEstruct:DESC_ITEM	 := (cNomeAli)->DESC
			oNewEstruct:OPC_GRUP     := (cNomeAli)->GROPC
			oNewEstruct:OPC_ITEM     := (cNomeAli)->OPC
			oNewEstruct:STATUS_ESTRU := "Ativo"

		  	AAdd( oRet:aRet, oNewEstruct )
			
			nQtdReg++
			
			(cNomeAli)->(DbSkip())
		enddo
	endif
	
	FIMESTRUT2(cNomeAli, cNomeArq)
	
	oRet:cErros	 := cMsgErr
	oRet:lRet	 := lOK
	oRet:nQtdReg := nQtdReg

Return(.t.)
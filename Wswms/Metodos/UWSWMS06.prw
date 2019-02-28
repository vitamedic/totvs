#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUWSWMS06  บAutor  ณMicrosiga           บ Data ณ  20/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para consulta de ORDEM DE PRODUวรO (HEADER)       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSWMS06(oFil, oRet)

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
	Local oNewOp
	
	PRIVATE lMsErroAuto := .F.
	
	oRet:aRet    := {}
	oRet:lRet	 := .t.
	oRet:cErros  := ""
	oRet:nQtdReg := 0   
	
	if empty(oFil:cEmpresa)
		oFil:cEmpresa := "01"
		oFil:cParFil  := "01"
	endif                

	//se nใo foi configurado WS para ja vir logado na empresa e filial, fa็o cria็ใo do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U' 
		RpcSetType(3)
		lConect := RpcSetEnv(oFil:cEmpresa, oFil:cFilial)
		if !lConect
			cMsgErr := "Nใo foi possํvel conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif

	if lOk .and. empty(oFil:cNumOp) .and. (empty(oFil:cDataDe) .and. empty(oFil:cDataAte))
		cMsgErr := "Campo |cNumOp| nao preenchido. Campo obrigatorio."
		lOk := .F.
	endif   

	if lOK
		
		cQry :=        " SELECT SC2.*, SB1.B1_LOCPAD, SB1.B1_DESC "
		cQry += CRLF + " FROM " + RetSqlName("SC2") + " SC2 "
		cQry += CRLF + " INNER JOIN " + RetSqlName("SB1") + " SB1 "
		cQry += CRLF + "   ON ( SB1.B1_FILIAL   = '" + xFilial("SB1") + "'"
		cQry += CRLF + " 		 AND SB1.B1_COD = SC2.C2_PRODUTO"
		cQry += CRLF + " 		 AND SB1.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "      ) "
		cQry += CRLF + " WHERE SC2.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "   AND SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
		if !empty(oFil:cNumOp)
			cQry += CRLF + " AND (SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN) = '"+oFil:cNumOp+"' "
		endif
		if !empty(oFil:cDataDe)
			cQry += CRLF + " AND SC2.C2_EMISSAO >= '"+DtoS(CtoD(oFil:cDataDe))+"' "
		endif
		if !empty(oFil:cDataAte)
			cQry += CRLF + " AND SC2.C2_EMISSAO <= '"+DtoS(CtoD(oFil:cDataAte))+"' "
		endif
		if !empty(oFil:cCodProd)
			cQry += CRLF + " AND SC2.C2_PRODUTO = '"+oFil:cCodProd+"' "
		endif
		if !empty(oFil:cNumLote)
			cQry += CRLF + " AND SC2.C2_LOTECTL = '"+oFil:cNumLote+"' "
		endif
		cQry += CRLF + " ORDER BY SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_LOTECTL, SC2.C2_PRODUTO " 
		
		cQry := ChangeQuery(cQry)
		
		If Select("QRYWS6") > 0
			QRYWS6->(DbCloseArea())
		EndIf
		
		TcQuery cQry New Alias "QRYWS6" // Cria uma nova area com o resultado do query
		
		QRYWS6->(dbGoTop())
		
		While QRYWS6->(!Eof())
			
		  	oNewOp :=  WSClassNew( "WSOp" )
		  	
		  	oNewOp:FILIAL 	  := QRYWS6->C2_FILIAL
		  	oNewOp:NUM_OP 	  := QRYWS6->(C2_NUM + C2_ITEM + C2_SEQUEN)
		  	oNewOp:COD_PROD   := AllTrim(QRYWS6->C2_PRODUTO)
		  	oNewOp:DESC_PROD  := AllTrim(QRYWS6->B1_DESC)
		  	oNewOp:NUM_LOTE   := Alltrim(QRYWS6->C2_LOTECTL)
		  	oNewOp:QTD 		  := NoRound(QRYWS6->C2_QUANT,2)
		  	oNewOp:UM 		  := QRYWS6->C2_UM
		  	oNewOp:DATA_EMIS  := DtoC(StoD(QRYWS6->C2_EMISSAO))
		  	oNewOp:STATUS_OP  := QRYWS6->C2_STATUS
		  	oNewOp:NUM_REVIS1 := QRYWS6->C2_REVI
		  	oNewOp:TIPO_OP 	  := QRYWS6->C2_TPOP
		  	oNewOp:NUM_REVIS2 := QRYWS6->C2_REVI

		  	AAdd( oRet:aRet, oNewOp )

			nQtdReg++
			
			QRYWS6->(DbSkip())
		enddo
		
		QRYWS6->(DbCloseArea())
	endif

	oRet:cErros	 := cMsgErr
	oRet:lRet	 := lOK
	oRet:nQtdReg := nQtdReg

Return(.t.)
#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUWSWMS09  บAutor  ณMicrosiga           บ Data ณ  27/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para consulta de Estrutura de Produtos (Header)   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSWMS09(oFil, oRet)

	Local lOk 		:= .T.
	Local cMsgErr 	:= ""
	Local cError   	:= ""
	Local cWarning 	:= ""
	Local cQry		:= ""	
	Local nQtdReg	:= 0
	Local cDados	:= ""
	Local MV_CQ     := GetMV("MV_CQ")
	Local oNewEstruct
	
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
	
	if lOK

		cQry :=        " SELECT DISTINCT "
		cQry += CRLF + "        SG5.G5_FILIAL "
		cQry += CRLF + "      , SG5.G5_PRODUTO "
		cQry += CRLF + "      , SG5.G5_REVISAO "
		cQry += CRLF + "      , SB1.B1_QB "
		cQry += CRLF + "      , SB1.B1_UM "
		cQry += CRLF + "      , SG5.G5_DATAREV "
		cQry += CRLF + "      , SB1.B1_DESC "
		cQry += CRLF + " FROM ( SELECT MG5.G5_FILIAL, MG5.G5_PRODUTO, MAX(MG5.G5_REVISAO) ULT_REVISAO "
		cQry += CRLF + "        FROM " + RetSqlName("SG5") + " MG5 "
		cQry += CRLF + "        WHERE MG5.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "          AND MG5.G5_FILIAL  = '" + xFilial("SG5") + "' "
		cQry += CRLF + "          AND MG5.G5_PRODUTO = '"+Alltrim(oFil:cCodProd)+"' "
		cQry += CRLF + "        GROUP BY MG5.G5_FILIAL, MG5.G5_PRODUTO "
		cQry += CRLF + "      ) QG5 "
		cQry += CRLF + " INNER JOIN " + RetSqlName("SG5") + " SG5 "
		cQry += CRLF + "   ON ( SG5.G5_FILIAL      = QG5.G5_FILIAL"
		cQry += CRLF + " 		AND SG5.G5_PRODUTO = QG5.G5_PRODUTO"
		cQry += CRLF + " 		AND SG5.G5_REVISAO = QG5.ULT_REVISAO  "
		cQry += CRLF + "      ) "
		cQry += CRLF + " INNER JOIN " + RetSqlName("SB1") + " SB1 "
		cQry += CRLF + "   ON ( SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
		cQry += CRLF + " 		AND SB1.B1_COD = SG5.G5_PRODUTO"
		cQry += CRLF + " 		AND SB1.D_E_L_E_T_ <> '*' "
		cQry += CRLF + "      ) "
		
		cQry := ChangeQuery(cQry)
		
		If Select("QRYWS9") > 0
			QRYWS9->(DbCloseArea())
		EndIf
		
		TcQuery cQry New Alias "QRYWS9" // Cria uma nova area com o resultado do query
		
		QRYWS9->(dbGoTop())
		
		While QRYWS9->(!Eof())

		  	oNewEstruct :=  WSClassNew( "WSHeadEStru" )
		  	
			oNewEstruct:FILIAL	 	 := Alltrim(QRYWS9->G5_FILIAL)
			oNewEstruct:COD_PROD	 := Alltrim(QRYWS9->G5_PRODUTO)
			oNewEstruct:NUM_REV	 	 := Alltrim(QRYWS9->G5_REVISAO)
			oNewEstruct:NUM_VERSAO	 := Alltrim(QRYWS9->G5_REVISAO)
			oNewEstruct:DATA_CRIA 	 := DtoC(StoD(QRYWS9->G5_DATAREV))
			oNewEstruct:DATA_VALID 	 := ""
			oNewEstruct:QTD_BASE	 := NoRound(QRYWS9->B1_QB,2)
			oNewEstruct:UM_PROD	 	 := AllTrim(QRYWS9->B1_UM)
			oNewEstruct:DESC_PROD	 := AllTrim(QRYWS9->B1_DESC)
			oNewEstruct:STATUS_ESTRU := "Ativo"

		  	AAdd( oRet:aRet, oNewEstruct )
			
			nQtdReg++
			
			QRYWS9->(DbSkip())
		enddo
		
		QRYWS9->(DbCloseArea())
	endif

	oRet:cErros	 := cMsgErr
	oRet:lRet	 := lOK
	oRet:nQtdReg := nQtdReg

Return(.t.)
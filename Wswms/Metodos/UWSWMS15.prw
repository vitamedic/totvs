#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ UWSWMS15 บAutor  ณMicrosiga           บ Data ณ  23/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para consulta do c๓digo DUN14 dos Produtos        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSWMS15(oFil, oRet)

	Local lOk       := .T.
	Local cRet 		:= ""  
	Local cMsgErr 	:= ""
	Local cMsgSuss 	:= ""
	Local cError   	:= ""
	Local cWarning 	:= ""
	Local cQry		:= ""	
	Local nQtdReg	:= 0
	Local cDados	:= ""
	Local oNewDUN14
	
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
	
	//if empty(oFil:cNumOS)
	//	cMsgErr := "Informe o filtro cNumOS. Campo obrigatorio."
	//	lOk := .F.
	//endif
                                                                                              
	if empty(oFil:cItem)
		cMsgErr := "Informe o filtro cItem. Campo obrigatorio."
		lOk := .F.
	endif
	
	if empty(oFil:nVolume)
		cMsgErr := "Informe o filtro nVolume. Campo obrigatorio."
		lOk := .F.
	endif

	if lOK
		
		cQry := " SELECT SC2.C2_LOCAL, SC2.C2_LOTECTL, SC2.C2_NUM, SC2.C2_DTVALID, SC2.C2_QUANT, SB1.* "
		cQry += " FROM " + RetSqlName("Z52") + " Z52 "
		cQry += " INNER JOIN " + RetSqlName("SC2") + " SC2 ON (SC2.C2_FILIAL      = '" + xFilial("SC2") + "' "
		cQry += "                                              AND SC2.C2_PRODUTO = Z52.Z52_COD "
		cQry += "                                              AND SC2.C2_LOTECTL = Z52.Z52_LOTECT "
		cQry += "                                              AND SC2.D_E_L_E_T_ <> '*')"
		cQry += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON (SB1.B1_FILIAL      = '" + xFilial("SB1") + "' "
		cQry += "                                              AND SB1.B1_COD     = SC2.C2_PRODUTO "
		cQry += "                                              AND SB1.D_E_L_E_T_ <> '*' )"
		cQry += " WHERE Z52.Z52_FILIAL                    = '" + xFilial("Z52") + "' "
		cQry += "   AND (Z52.Z52_PEDIDO || Z52.Z52_NUMOS) = '"+Alltrim(oFil:cNumOS)+"' "
		cQry += "   AND (Z52.Z52_ITEM || Z52.Z52_SEQ)     = '"+Alltrim(oFil:cItem)+"' "
		cQry += "   AND Z52.D_E_L_E_T_                    <> '*' "
		
		cQry := " SELECT SB1.* "
		cQry += " FROM " + RetSqlName("SB1") + " SB1 "
		cQry += " WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
		cQry += "   AND SB1.B1_COD     = '"+Alltrim(oFil:cItem)+"' "
		cQry += "   AND SB1.D_E_L_E_T_ <> '*' "
		
		cQry := ChangeQuery(cQry)
		
		If Select("QRYWS15") > 0
			QRYWS15->(DbCloseArea())
		EndIf
		
		TcQuery cQry New Alias "QRYWS15" // Cria uma nova area com o resultado do query
		
		QRYWS15->(dbGoTop())
		
		if QRYWS15->(!Eof())
			_nVolume := 1
			
			/*
			_ccodbar:="01" // IDENTIFICA O TIPO DO CODIGO DE BARRAS (EAN-13)
			_ccodbar+="0"+AllTrim(QRYWS15->B1_CODBAR) // CODIGO DE BARRAS DO PRODUTO
			_ccodbar+="17" // IDENTIFICA A DATA DE VALIDADE
			_ccodbar+=SubStr(QRYWS15->C2_DTVALID,3,6)+"00" // DATA DE VALIDADE (AAMMDD)
			_ccodbar+="37" // IDENTIFICA A QUANTIDADE
			_ccodbar+=StrZero(_nVolume,4) // QUANTIDADE DA CAIXA
			_ccodbar+=">8" // IDENTIFICADOR DE FINALIZACAO DA QUANTIDADE
			_ccodbar+="10" // IDENTIFICA O LOTE
			_ccodbar+=QRYWS15->C2_NUM // NUMERO DO LOTE
			
			_ccodimp:="(01)" // IDENTIFICA O TIPO DO CODIGO DE BARRAS (EAN-13)
			_ccodimp+="0"+AllTrim(QRYWS15->B1_CODBAR) // CODIGO DE BARRAS DO PRODUTO
			_ccodimp+="(17)" // IDENTIFICA A DATA DE VALIDADE
			_ccodimp+=SubStr(QRYWS15->C2_DTVALID,3,6)+"00" // DATA DE VALIDADE (AAMMDD)
			_ccodimp+="(37)" // IDENTIFICA A QUANTIDADE
			_ccodimp+=StrZero(_nVolume,4) // QUANTIDADE DA CAIXA
			_ccodimp+="(10)" // IDENTIFICA O LOTE
			_ccodimp+=QRYWS15->C2_NUM // NUMERO DO LOTE
			*/
			
			_ccodimp:=StrZero(_nVolume,1) // QUANTIDADE DA CAIXA
			_ccodimp+=AllTrim(QRYWS15->B1_CODBAR) // CODIGO DE BARRAS DO PRODUTO
			
		  	oNewDUN14 := WSClassNew( "WSDUN14" )
		  	
		  	oNewDUN14:DUN14 	:= Alltrim(_ccodimp)
		  	oNewDUN14:CODIGO 	:= Alltrim(QRYWS15->B1_COD)
		  	oNewDUN14:CODBARRAS := AllTrim(QRYWS15->B1_CODBAR)
		  	oNewDUN14:UM 		:= QRYWS15->B1_UM
			oNewDUN14:LOTE  	:= "" //QRYWS15->C2_LOTECTL
		  	oNewDUN14:ARMAZEM 	:= "" //QRYWS15->C2_LOCAL
		  	oNewDUN14:ENDERECO 	:= ""
		  	oNewDUN14:VOLUME 	:= 0 //NoRound(QRYWS15->B1_QE,2)
		  	oNewDUN14:QUANT 	:= 0 //NoRound(QRYWS15->B1_QE,2)

		  	AAdd( oRet:aRet, oNewDUN14 )

			nQtdReg++
			
		endif
		
		QRYWS15->(DbCloseArea())
	endif
	
	oRet:cErros	 := cMsgErr
	oRet:lRet	 := lOK
	oRet:nQtdReg := nQtdReg

Return(.t.)
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUWSWMS03  บAutor  ณMicrosiga           บ Data ณ  20/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para consulta de Produtos                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSWMS03(oFil, oRet)

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
	Local oNewProdutos

	PRIVATE lMsErroAuto := .F.

	oRet:aRet    := {}
	oRet:lRet	   := .t.
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

	if empty(oFil:cCodigo) .and. empty(oFil:cDescricao) .and. empty(oFil:cBarras)
		cMsgErr := "Um dos filtros |cCodigo|cDescricao|cBarras| deve ser preenchido. Campo obrigatorio."
		lOk := .F.
	endif

	if lOK

		cQry :=  "SELECT "
		cQry +=  "  B1_COD, "
		cQry +=  "  B1_DESC, "
		cQry +=  "  B1_TIPO, "
		cQry +=  "  B1_CODBAR, "
		cQry +=  "  B1_QE, "
		cQry +=  "  B1_UM, "
		cQry +=  "  B1_DCB1, "
		cQry +=  "  B1_CODRES, "
		cQry +=  "  B1_XDCBTFA, "
		cQry +=  "  B1_XDCBTFZ, "
		cQry +=  "  B1_XDCBHFA, "
		cQry +=  "  B1_XDCBHFZ, "
		cQry +=  "  B1_XFORFAR "
		cQry +=  "FROM " + RetSqlName("SB1") + " "
		cQry +=  "WHERE D_E_L_E_T_ <> '*' "
		cQry += " AND B1_FILIAL = '" + xFilial("SB1") + "' "
		if !empty(oFil:cCodigo)
			cQry += " AND B1_COD = '"+Alltrim(oFil:cCodigo)+"' "
		endif
		if !empty(oFil:cDescricao)
			cQry += " AND B1_DESC LIKE '%"+oFil:cDescricao+"%' "
		endif
		if !empty(oFil:cBarras)
			cQry += " AND B1_CODBAR = '"+oFil:cBarras+"' "
		endif
		cQry += " ORDER BY B1_COD "

		cQry := ChangeQuery(cQry)

		If Select("QRYWS3") > 0
			QRYWS3->(DbCloseArea())
		EndIf

		TcQuery cQry New Alias "QRYWS3" // Cria uma nova area com o resultado do query

		QRYWS3->(dbGoTop())

		While QRYWS3->(!Eof())

			oNewProdutos :=  WSClassNew( "WSProdutos" )

			oNewProdutos:CODIGO 	  := Alltrim(QRYWS3->B1_COD)
			oNewProdutos:DESCRICAO 	  := AllTrim(QRYWS3->B1_DESC)
			oNewProdutos:TIPO 		  := AllTrim(QRYWS3->B1_TIPO)
			oNewProdutos:CODBARRAS 	  := AllTrim(QRYWS3->B1_CODBAR)
			oNewProdutos:QTDCX 		  := NoRound(QRYWS3->B1_QE,2)
			oNewProdutos:UM 		  := QRYWS3->B1_UM
			oNewProdutos:DCB 		  := AllTrim(QRYWS3->B1_DCB1)
			oNewProdutos:TEMPERATURA  := ""
			oNewProdutos:HUMIDADE 	  := ""
			oNewProdutos:FORMAFARM 	  := ""
			oNewProdutos:COD_RESUMIDO := AllTrim(QRYWS3->B1_CODRES)

			If QRYWS3->B1_XDCBTFA > 0
				oNewProdutos:TEMPERATURA := "Temperatura: " + AllTrim(Transform(QRYWS3->B1_XDCBTFA, "@E 999.9")) + " a " + AllTrim(Transform(QRYWS3->B1_XDCBTFZ, "@E 999.9")) + " Graus"
			EndIf

			If QRYWS3->B1_XDCBHFA > 0
				oNewProdutos:HUMIDADE := "Umidade: " + AllTrim(Transform(QRYWS3->B1_XDCBHFA, "@E 999.9")) + " a " + AllTrim(Transform(QRYWS3->B1_XDCBHFZ, "@E 999.9")) + " Porcento "
			EndIf

			oNewProdutos:FORMAFARM := AllTrim(QRYWS3->B1_XFORFAR)

			AAdd( oRet:aRet, oNewProdutos )

			nQtdReg++

			QRYWS3->(DbSkip())
		enddo

		QRYWS3->(DbCloseArea())
	endif

	oRet:cErros	 := cMsgErr
	oRet:lRet	 := lOK
	oRet:nQtdReg := nQtdReg

Return(.t.)
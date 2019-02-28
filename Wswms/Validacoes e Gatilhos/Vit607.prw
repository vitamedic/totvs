#INCLUDE "Protheus.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
//#INCLUDE "QIEA215.CH"

//---------------------------------------------------------------------------
/*/{Protheus.doc} Vit607

Valida a quantidade informada na liberação de material.

Validação: D7_QTDE

@author Henrique Corrêa
@since 24/05/2017
@version P11
@param Nao recebe parametros
@return lógido
/*/
//---------------------------------------------------------------------------

User Function Vit607(cProduto,cLoteCtl,lMensagem)
	Local aArea         := GetArea()
	Local _cCampo 		:= ReadVar()
	Local _nConteudo 	:= &(_cCampo)
	Local _LocRep       := GetMV("MV_XLOCRE2")
	Local _LocAmo       := GetMV("MV_XLOCAMO")
	Local _EndRep       := GetMV("MV_XENDREP")
	Local _EndAmo       := GetMV("MV_XENDAMO")
	Local lURetSD7      := .t.
	Local cRotina       := Upper(AllTrim(FunName()))
	Local cMsg			:= ""

	Default cProduto 	:= Iif(cRotina == "MATA175", SD7->D7_PRODUTO, M->QEK_PRODUT)
	Default cLoteCtl 	:= Iif(cRotina == "MATA175", SD7->D7_LOTECTL, M->QEK_LOTE)
	Default lMensagem   := .t.

	cQry :=        " SELECT SBF.BF_PRODUTO "
	cQry += CRLF + "      , SBF.BF_LOCAL "
	cQry += CRLF + "      , SBF.BF_LOCALIZ "
	cQry += CRLF + "      , (SBF.BF_QUANT-SBF.BF_EMPENHO) QTDE "
	cQry += CRLF + " FROM "+RetSqlName("SBF")+" SBF "
	cQry += CRLF + " WHERE SBF.D_E_L_E_T_                <> '*' "
	cQry += CRLF + "   AND SBF.BF_FILIAL                 = '"+XFilial("SBF")+"' "
	cQry += CRLF + "   AND SBF.BF_PRODUTO                = '"+cProduto+"' "
	cQry += CRLF + "   AND SBF.BF_LOTECTL                = '"+cLoteCtl+"' "
	cQry += CRLF + "   AND SBF.BF_LOCAL                  = '"+GetMV("MV_CQ")+"' "

	If Select("Q607") > 0
		Q607->(DbCloseArea())
	EndIf

	TCQuery cQry New Alias "Q607"

	cMsg += "Prod.: " + AllTrim(Posicione("SB1", 1, xFilial("SB1")+cProduto, "B1_DESC")) + CRLF + CRLF

	Q607->(DbGoTop())
	While Q607->(!EOF())
		cMsg += "End.: " + AllTrim(Q607->BF_LOCALIZ) + " Qtd.: " + AllTrim(cValToChar(Q607->QTDE)) + CRLF

		Q607->(DbSkip())
	EndDo

	cQry :=        " SELECT SBF.BF_PRODUTO "
	cQry += CRLF + "      , SBF.BF_LOCAL "
	cQry += CRLF + "      , SBF.BF_LOCALIZ "
	cQry += CRLF + "      , (SBF.BF_QUANT-SBF.BF_EMPENHO) QTDE "
	cQry += CRLF + " FROM "+RetSqlName("SBF")+" SBF "
	cQry += CRLF + " WHERE SBF.D_E_L_E_T_                <> '*' "
	cQry += CRLF + "   AND SBF.BF_FILIAL                 = '"+XFilial("SBF")+"' "
	cQry += CRLF + "   AND SBF.BF_PRODUTO                = '"+cProduto+"' "
	cQry += CRLF + "   AND SBF.BF_LOTECTL                = '"+cLoteCtl+"' "
	cQry += CRLF + "   AND SBF.BF_LOCAL                  = '"+GetMV("MV_CQ")+"' "
	cQry += CRLF + "   AND (SBF.BF_QUANT-SBF.BF_EMPENHO) = " + StrTran(AllTrim(Transform(_nConteudo, "@E 999999999.99999")), ",", ".")

	If Select("Q607") > 0
		Q607->(DbCloseArea())
	EndIf

	TCQuery cQry New Alias "Q607"

	if Q607->(Eof())
		lURetSD7 := .f.

		if lMensagem
			MsgAlert("Quantidade não localizada no endereçamento.")
			MsgInfo(cMsg, "Qtd. por Endereço Disponível")
		endif
	endif

	Q607->(DbCloseArea())

	RestArea(aArea)

	if ! lURetSD7
		M->D7_LOCDEST 	:= Space(TamSX3("D7_LOCDEST")[1])
		M->D7_LOCALIZ 	:= Space(TamSX3("D7_LOCALIZ")[1])
		M->D7_QTDE 		:= 0
		M->D7_QTSEGUM 	:= 0
	endif

Return lURetSD7
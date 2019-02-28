#INCLUDE "Protheus.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
//#INCLUDE "QIEA215.CH"

//---------------------------------------------------------------------------
/*/{Protheus.doc} Vit606

Retorna o armazém correto para liberação.

Gatilho: D7_QTDE

@author Henrique Corrêa
@since 24/05/2017
@version P11
@param Nao recebe parametros
@return lógido
/*/
//---------------------------------------------------------------------------

User Function Vit606(cProduto,cLoteCtl)
	Local aArea         := GetArea()
	Local _cCampo 		:= ReadVar()
	Local _nConteudo 	:= &(_cCampo)
	Local _LocRep       := GetMV("MV_XLOCRE2")
	Local _LocAmo       := GetMV("MV_XLOCAMO")
	Local _EndRep       := GetMV("MV_XENDREP")
	Local _EndAmo       := GetMV("MV_XENDAMO")
	Local lURetSD7      := .t.
	Local cRet          :=Space(TamSX3("D7_LOCDEST")[1])
	Local cRotina       := Upper(AllTrim(FunName()))

	Default cProduto 	:= Iif(cRotina == "MATA175", SD7->D7_PRODUTO, M->QEK_PRODUT)
	Default cLoteCtl 	:= Iif(cRotina == "MATA175", SD7->D7_LOTECTL, M->QEK_LOTE)

	cQry :=        " SELECT SBF.BF_PRODUTO "
	cQry += CRLF + "      , SBF.BF_LOCAL "
	cQry += CRLF + "      , SBF.BF_LOCALIZ "
	cQry += CRLF + "      , (SBF.BF_QUANT-SBF.BF_EMPENHO) QTDE "
	cQry += CRLF + " FROM "+RetSqlName("SBF")+" SBF "
	cQry += CRLF + " WHERE SBF.D_E_L_E_T_                <> '*' "
	cQry += CRLF + "   AND SBF.BF_FILIAL                 = '"+XFilial("SBF")+"' "
	cQry += CRLF + "   AND SBF.BF_PRODUTO                = '"+cProduto+"' "
	cQry += CRLF + "   AND SBF.BF_LOTECTL                = '"+cLoteCtl+"' "
	cQry += CRLF + "   AND SBF.BF_LOCAL                  = '"+GetMV("MV_CQ")+"' " // Acrescentado linha para aponstamentos Palete a Palete
	cQry += CRLF + "   AND (SBF.BF_QUANT-SBF.BF_EMPENHO) = " + StrTran(AllTrim(Transform(_nConteudo, "@E 999999999.99999")), ",", ".")

	If Select("Q606") > 0
		Q606->(DbCloseArea())
	EndIf

	TCQuery cQry New Alias "Q606"

	if Q606->(!Eof())
		if AllTrim(Q606->BF_LOCALIZ) <> AllTrim(_EndRep) .and. AllTrim(Q606->BF_LOCALIZ) <> AllTrim(_EndAmo)
			dbSelectArea("SB1")
			dbSetOrder(1)
			if dbSeek(XFilial("SB1")+Q606->BF_PRODUTO)
				cRet := SB1->B1_LOCPAD
			endif
		else
			cRet := Iif(AllTrim(Q606->BF_LOCALIZ) == AllTrim(_EndAmo), _LocAmo, _LocRep)
		endif
	endif

	Q606->(DbCloseArea())

	RestArea(aArea)

Return( cRet )
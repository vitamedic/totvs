#INCLUDE "Protheus.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
//#INCLUDE "QIEA215.CH"

//---------------------------------------------------------------------------
/*/{Protheus.doc} Vit608

Gatilha o endereço onde está localizado o produto/lote.

Gatilho: D7_QTDE

@author Henrique Corrêa
@since 24/05/2017
@version P11
@param Nao recebe parametros
@return lógido
/*/
//---------------------------------------------------------------------------

User Function Vit608(cProduto,cLoteCtl)
	Local aArea         := GetArea()
	Local _cCampo 		:= ReadVar()
	Local _nConteudo 	:= &(_cCampo)
	Local _LocRep       := GetMV("MV_XLOCRE2")
	Local _LocAmo       := GetMV("MV_XLOCAMO")
	Local _EndRep       := GetMV("MV_XENDREP")
	Local _EndAmo       := GetMV("MV_XENDAMO")
	Local lURetSD7      := .t.
	Local cRet 			:= Space(TamSX3("D7_LOCALIZ")[1])
	Local nPosQtde   	:= aScan(aHeader,{|x|UPPER(alltrim(x[2])) == "D7_QTDE"})
	Local nPosLocaliz   := aScan(aHeader,{|x|UPPER(alltrim(x[2])) == "D7_LOCALIZ"})
	Local nPosEstorno   := aScan(aHeader,{|x|UPPER(alltrim(x[2])) == "D7_ESTORNO"})
	Local nI            := 1
	Local lUsado        := .f.
	Local cRotina       := Upper(alltrim(FunName()))

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
	cQry += CRLF + "   AND (SBF.BF_QUANT-SBF.BF_EMPENHO) = " + StrTran(alltrim(Transform(_nConteudo, "@E 999999999.99999")), ",", ".")
	cQry += CRLF + " ORDER BY SBF.BF_PRODUTO "
	cQry += CRLF + "        , SBF.BF_LOCAL "
	cQry += CRLF + "        , SBF.BF_LOCALIZ "

	If Select("Q608") > 0
		Q608->(DbCloseArea())
	EndIf

	TCQuery cQry New Alias "Q608"

	if nPosQtde > 0 .and. nPosLocaliz > 0 .and. nPosEstorno > 0
		do while Q608->(!Eof())
			lUsado := .f.
			for nI := 1 to Len(aCols)
				if aCols[nI,nPosQtde] == _nConteudo .and. empty(alltrim(aCols[nI,nPosEstorno])) .and. alltrim(aCols[nI,nPosLocaliz]) == alltrim(Q608->BF_LOCALIZ)
					lUsado := .t.
					exit
				endif
			next nI

			if !lUsado
				cRet := Q608->BF_LOCALIZ
				exit
			endif

			Q608->(dbSkip())
		enddo
	endif

	Q608->(DbCloseArea())

	RestArea(aArea)

Return( cRet )
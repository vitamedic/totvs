#INCLUDE "Protheus.CH" 
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#INCLUDE "TBICONN.CH"
#INCLUDE "QIEA215.CH"

//---------------------------------------------------------------------------
/*/{Protheus.doc} Vit609
Rotina Vit609
Valida a quantidade infornada e gatilha o endereço correspondente
utilizado no gatilho do campo D7_QTDE na inspeção de entrada

@author Henrique Corrêa
@since 24/05/2017
@version P11
@param Nao recebe parametros
@return lógido 
@history
/*/
//---------------------------------------------------------------------------

User Function Vit609(cProduto,cLoteCtl)
Local aArea         := GetArea()
Local _cCampo 		:= ReadVar()
Local _nConteudo 	:= &(_cCampo)
Local _LocRep       := GetMV("MV_XLOCRE2")
Local _LocAmo       := GetMV("MV_XLOCAMO")
Local _EndRep       := GetMV("MV_XENDREP")
Local _EndAmo       := GetMV("MV_XENDAMO")
Local lURetSD7      := .t.
Local cRet          := Space(TamSX3("D7_LOCDEST")[1])

Default cProduto 	:= M->QEK_PRODUT
Default cLoteCtl 	:= M->QEK_LOTE

cQry :=        " SELECT SBF.BF_PRODUTO "
cQry += CRLF + "      , SBF.BF_LOCAL "
cQry += CRLF + "      , SBF.BF_LOCALIZ "
cQry += CRLF + "      , (SBF.BF_QUANT-SBF.BF_EMPENHO) QTDE "
cQry += CRLF + " FROM "+RetSqlName("SBF")+" SBF "
cQry += CRLF + " WHERE SBF.D_E_L_E_T_                <> '*' "
cQry += CRLF + "   AND SBF.BF_FILIAL                 = '"+XFilial("SBF")+"' "
cQry += CRLF + "   AND SBF.BF_PRODUTO                = '"+cProduto+"' "
cQry += CRLF + "   AND SBF.BF_LOTECTL                = '"+cLoteCtl+"' "
cQry += CRLF + "   AND (SBF.BF_QUANT-SBF.BF_EMPENHO) = " + StrTran(AllTrim(Transform(_nConteudo, "@E 999999999.99999")), ",", ".")

If Select("Q609") > 0
	Q609->(DbCloseArea())
EndIf

TCQuery cQry New Alias "Q609"

if Q609->(Eof())
	lURetSD7 		:= .f.
	M->D7_LOCDEST 	:= Space(TamSX3("D7_LOCDEST")[1])
	M->D7_LOCALIZ 	:= Space(TamSX3("D7_LOCALIZ")[1])
	MsgAlert("Quantidade não localizada no endereçamento.")
else
	if AllTrim(Q609->BF_LOCALIZ) <> AllTrim(_EndRep) .and. AllTrim(Q609->BF_LOCALIZ) <> AllTrim(_EndAmo)
        dbSelectArea("SB1")
        dbSetOrder(1)
        if dbSeek(XFilial("SB1")+Q609->BF_PRODUTO)
			M->D7_LOCDEST := SB1->B1_LOCPAD
		endif
	else
		M->D7_LOCDEST := Iif(AllTrim(Q609->BF_LOCALIZ) == AllTrim(_EndAmo), _LocAmo, _LocRep)
	endif
	
	M->D7_LOCALIZ := Q609->BF_LOCALIZ	
endif

Q609->(DbCloseArea())

RestArea(aArea)

Return( lURetSD7 )
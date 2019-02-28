#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MTA380E

Executado antes de deletar o empenho (SD4), ap�s a confirma��o.
Nao impede/valida a dele��o. Executado ap�s confirma��o e antes da dele��o.

@author danilo
@since 23/01/2018
@version 1.0
@return Nil

@type function
/*/
User function MTA380E()

	Local cMsgErr 	:= ""
	Local cMsgAgu	:= "Aguarde... atualizando empenhos WMS..."
	Local lOk := .T.

	if !IsBlind()
		//atualizo empenhos WMS da SB2, SB8 e SBF
		LjMsgRun(cMsgAgu,"Saldos WMS",{|| lOk := U_ProcEmpenhoWMS(,,,.t., @cMsgErr) })
	endif

Return
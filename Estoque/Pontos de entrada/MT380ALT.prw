#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT380ALT

Ap�s a grava��o de uma altera��o de empenho.
O Ponto de Entrada MT380ALT e utilizado para realizar opera��es complementares.

@author danilo
@since 23/01/2018
@version 1.0
@return Nil

@type function
/*/
User function MT380ALT()

	Local cMsgErr 	:= ""
	Local cMsgAgu	:= "Aguarde... atualizando empenhos WMS..."
	Local lOk := .T.

	if !IsBlind()
		//atualizo empenhos WMS da SB2, SB8 e SBF
		LjMsgRun(cMsgAgu,"Saldos WMS",{|| lOk := U_ProcEmpenhoWMS(,,,.t., @cMsgErr) })
	endif

Return
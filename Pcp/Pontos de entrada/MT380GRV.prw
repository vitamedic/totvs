#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT380GRV

O Ponto de entrada MT380GRV e utilizado para realizar operações
complementares após a inclusão de um item de ajuste de empenho.

@author danilo
@since 23/01/2018
@version 1.0
@return Nil

@type function
/*/
User function MT380GRV()

	Local cMsgErr 	:= ""
	Local cMsgAgu	:= "Aguarde... atualizando empenhos WMS..."
	Local lOk := .T.

	if !IsBlind()
		//atualizo empenhos WMS da SB2, SB8 e SBF
		LjMsgRun(cMsgAgu,"Saldos WMS",{|| lOk := U_ProcEmpenhoWMS(,,,.t., @cMsgErr) })
	endif

Return
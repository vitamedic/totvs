#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MTA381GRV

O Ponto de entrada MTA381GRV � utilizado para realizar opera��es complementares
ap�s a inclus�o, altera��o e exclus�o de um item de ajuste de empenho mod II.

@author danilo
@since 23/01/2018
@version 1.0
@return Nil

@type function
/*/
User function MTA381GRV()

	Local cMsgErr 	:= ""
	Local cMsgAgu	:= "Aguarde... atualizando empenhos WMS..."
	Local lOk := .T.

	if !IsBlind()
		//atualizo empenhos WMS da SB2, SB8 e SBF
		LjMsgRun(cMsgAgu,"Saldos WMS",{|| lOk := U_ProcEmpenhoWMS(,,,.t., @cMsgErr) })
	endif

Return
#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MGETMOED

	Análise e processamento de JOBs

@author Guilherme Sampaio
@since 14/07/2017
@version undefined

@type function
/*/
user function MGETMOED()

	Local aArea := GetArea()

	// JOB/WF Ajuste de Saldo com centesimais
	If ExistBlock("VIT061")
		U_VIT601()
	EndIf

	/*If ExistBlock("VIT629")
		U_VIT629()
	EndIf*/
	
	RestArea( aArea )

return
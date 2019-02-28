#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} ABREZ50
	AxCadastro da tabela de Backup dos empenhos
@author redes
@since 28/05/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function ABREZ50()

	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

	Private cString := "Z50"

	dbSelectArea("Z50")
	dbSetOrder(1)

	AxCadastro(cString,"Backup dos Empenhos - SD4",cVldExc,cVldAlt)

Return()
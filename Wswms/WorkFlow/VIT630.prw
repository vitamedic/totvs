#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} VIT630
	Chamada para Envio manual de posi��o Di�ria Lotes Incompletos
@author Guilherme Sampaio
@since 13/07/2017
@version undefined

@type function
/*/
user function VIT630()

	Processa( {|| U_VIT629() }, "Aguarde...", "Envio manual de posi��o Di�ria Lotes Incompletos  ",.F.)
	
return
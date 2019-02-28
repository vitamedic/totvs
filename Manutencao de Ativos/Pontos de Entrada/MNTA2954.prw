#include 'protheus.ch'
#include 'parmtype.ch'
 
//-------------------------------------------------------------------
/*/{Protheus.doc} MNTA2954
Inicializa��o de variaveis para inclus�o de campos em tela.
Permite carregar automaticamente o servi�o desejado.
 
@author  STEPHEN NOEL DE MELO RIBEIRO
@since   30/08/2018
@version P12
/*/
//-------------------------------------------------------------------
User Function MNTA2954()
 
    // Declara��o da Variavel utilizada na inser��o do campo em tela
    _SetOwnerPrvt("cDescri", Space(TamSx3("TJ_DESCRI")[1]))
  
ReturnST
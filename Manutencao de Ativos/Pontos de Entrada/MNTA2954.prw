#include 'protheus.ch'
#include 'parmtype.ch'
 
//-------------------------------------------------------------------
/*/{Protheus.doc} MNTA2954
Inicialização de variaveis para inclusão de campos em tela.
Permite carregar automaticamente o serviço desejado.
 
@author  STEPHEN NOEL DE MELO RIBEIRO
@since   30/08/2018
@version P12
/*/
//-------------------------------------------------------------------
User Function MNTA2954()
 
    // Declaração da Variavel utilizada na inserção do campo em tela
    _SetOwnerPrvt("cDescri", Space(TamSx3("TJ_DESCRI")[1]))
  
ReturnST
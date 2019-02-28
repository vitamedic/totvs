#include 'protheus.ch'
#include 'parmtype.ch'
 
//-------------------------------------------------------------------
/*/{Protheus.doc} MNTA2952
Grava informações dos campos inclusos pelo PE MNTA2955
 
@author  Stephen Noel de Melo Ribeiro
@since   30/08/2018
@version P12
/*/
//-------------------------------------------------------------------
User Function MNTA2952()
	Local cDescri  :=  TQB->TQB_DESCRITQ
 
    // Salva os campos inseridos em tela na tabela.
    RecLock("STJ",.F.)
    STJ->TJ_DESCRI := cDescri
    STJ->( MsUnlock() )
 
Return
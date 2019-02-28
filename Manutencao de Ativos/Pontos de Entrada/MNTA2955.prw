#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'totvs.ch'
 
//-------------------------------------------------------------------
/*/{Protheus.doc} MNTA2955
Adiçãoo de campos em tela na geração de O.S. via distribuição de S.S.
 
@author  Stephe Noel de Melo Ribeiro
@since   30/08/2018
@version P11/P12
/*/
//-------------------------------------------------------------------
User Function MNTA2955()
 
    Local oPnl1   := ParamIXB[1] // Objeto onde será criado o campo.
    Local cDescri  :=  TQB->TQB_DESCRI
    Local oSay1
    Local oSay2
    oPnl1:nHeight := 110
    // Define nome do Campos
    oSay1 := TSay():New( 001, 008, {|| GetSx3Cache("TJ_DESCRI", "X3_TITULO") }, oPnl1,,,,,,.T.,,,,)
 
    // Entrada de dados
    oGet1 := TGet():New( 001, 048, { | u | If( PCount() == 0, cDescri, cDescri := u ) }, oPnl1, 220,;
                        007,,, 0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cDescri",,,,.T. )
 
 
    oPnl1:Align := CONTROL_ALIGN_BOTTOM
 
Return
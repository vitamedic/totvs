#include "Protheus.ch"

/*
Funcao      : Cadastro de Estados
Objetivos   : AxCadastro da tabela ZUF
*/
*---------------------*
User Function CadZUF()  //U_CadZUF()
*---------------------*
Local   cOldArea := Select()
Local   cAlias    := "ZUF"
Private cCadastro := "Cadastro Estados"
Private aRotina   :=  { { "Pesquisar" ,"AxPesqui"                          ,0,1},;
                      { "Visualizar"  ,"AxVisual"                          ,0,2},;
                      { "Incluir"     ,"AxInclui"                          ,0,3},;
                      { "Altera"      ,"AxAltera"                          ,0,4},;
                      { "Excluir"     ,"AxDeleta"                          ,0,5}}


//abre a tela de manutenção
MBrowse(,,,,cAlias,,,,,,)   

//volta pra area inicial
dbSelectArea(cOldArea)     
//
Return 
#include "Protheus.ch"

/*
Funcao      : Cadastro de Log's de Apontamentos

Objetivos   : AxCadastro da tabela ZLG
*/
*---------------------*
User Function VIT472()  //U_VIT472()
*---------------------*
Local   cOldArea := Select()
Local   cAlias    := "ZLG"
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
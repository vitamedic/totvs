#Include "PROTHEUS.CH"
#include "topconn.ch"   
#INCLUDE 'FWMVCDEF.CH' 

/*/{Protheus.doc} VIT618
	Cadastro de Fabricantes Certificados
@author Henrique Correa
@since 23/06/2017 
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function VIT618()
Private cCadastro := "Cadastro de Fabricantes Certificados"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

Private cDelFunc := ".T." 

Private cString := "Z55"

dbSelectArea("Z55")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return(Nil)
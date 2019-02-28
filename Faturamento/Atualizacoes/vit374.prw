/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³ VIT374   º AUTOR ³ Ricardo Fiuza's    º DATA ³  02/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESCRICAO ³ Cadastro Nota de Debito de Transportadora		          º±±
±±º          ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ Vitapan                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"
#include "topconn.ch"

User Function vit374()
   //	SZ6->(dbsetorder(1))

	//axcadastro("SZ6","Notas de DÃ©bito - Transportadora")
//return()                    
Local cAlias := "SZ6"
Private cCadastro:= "Notas de Debito - Transportadora"
Private aRotina:= {}
 
AADD(aRotina,{"Pesquisar","AxPesqui",0,1})
AADD(aRotina,{"Visualizar","AxVisual",0,2})
AADD(aRotina,{"Incluir","AxInclui",0,3})
AADD(aRotina,{"Alterar","AxAltera",0,4})
AADD(aRotina,{"Excluir","AxDeleta",0,5})
AADD(aRotina,{"Legenda","U_LegZam()",0,6})
//AADD(aRotina,{"Imprimir","U_ImpMot()",0,7})
//AADD(aRotina,{"Contrata","U_ImpCont()",0,8})
 
Private aCores :=  {{'EMPTY(Z6_BAIXA)', 'BR_VERDE'},;
                   { 'Z6_TOTPARC == "T" ', 'BR_VERMELHO'},;
                   { 'Z6_TOTPARC == "P" ', 'BR_AMARELO' }}
 
dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6,1,22,75,cAlias,,,,,, aCores)
 
Return Nil 
 
/*/+-----------------------------------------------------------------------------|
Função| MBRWSA1 | Autor | RICARDO - FIUZAS | Data |  23/10/12
|+-----------------------------------------------------------------------------|
LEGENDA
*/
 
User function LegZam()
 
aLegenda := {{'BR_VERDE', "Aberto"},;
            {'BR_VERMELHO', "Baixado Total"},;
            {'BR_AMARELO', "Baixado Parcial"}}         
            BRWLEGENDA(cCadastro, "Legenda", aLegenda)
Return .T.                                                 


/*/+-----------------------------------------------------------------------------|
Função| ValND | Autor | RICARDO - FIUZAS | Data |  16/04/2015
|+-----------------------------------------------------------------------------|
*/

#include "rwmake.ch"

User Function ValNDBX                                                         
      MSGSTOP("Favor Preencher, Total/ Parcial e/ou Valor Baixado !!!!","ATENCAO")
Return .T.       

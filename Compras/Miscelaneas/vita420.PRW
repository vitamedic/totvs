/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPROGRAMA  ณ VIT420   บ AUTOR ณ Ricardo Fiuza's    บ DATA ณ  12/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDESCRICAO ณ Cadastro de Adiantamento							          บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUSO       ณ Vitapan                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

#include "rwmake.ch"
#include "topconn.ch"

User Function vit420()
                    
Local cAlias := "Z41"
Private cCadastro:= "Adiantamento"
Private aRotina:= {}
 
AADD(aRotina,{"Pesquisar","AxPesqui",0,1})
AADD(aRotina,{"Visualizar","AxVisual",0,2})
AADD(aRotina,{"Incluir","AxInclui",0,3})
AADD(aRotina,{"Alterar","AxAltera",0,4})
AADD(aRotina,{"Excluir","AxDeleta",0,5})
AADD(aRotina,{"Legenda","U_LegZ41()",0,6})  
AADD(aRotina,{"Impr PA","U_VIT421()",0,7})
 
Private aCores :=  {{'EMPTY(Z41_IMPR)', 'BR_VERDE'},;
                   { 'Z41_IMPR == "S" ', 'BR_VERMELHO'}}                   
 
dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6,1,22,75,cAlias,,,,,, aCores)
 
Return Nil 
 
/*/+-----------------------------------------------------------------------------|
Fun็ใo| MBRWSA1 | Autor | RICARDO - FIUZAS | Data |  23/10/12
|+-----------------------------------------------------------------------------|
LEGENDA
*/
 
User function LegZ41()
 
aLegenda := {{'BR_VERDE', "Nใo Impresso"},;
            {'BR_VERMELHO', "Impresso"}}
            BRWLEGENDA(cCadastro, "Legenda", aLegenda)
Return .T.                                                 


/*/+-----------------------------------------------------------------------------|
Fun็ใo| ValND | Autor | RICARDO - FIUZAS | Data |  16/04/2015
|+-----------------------------------------------------------------------------|


#include "rwmake.ch"

User Function ValNDBX                                                         
      MSGSTOP("Favor Preencher, Total/ Parcial e/ou Valor Baixado !!!!","ATENCAO")
Return .T.       
*/


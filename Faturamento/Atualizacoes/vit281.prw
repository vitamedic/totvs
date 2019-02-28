/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT281   � Autor 矨lex J鷑io de Miranda  � Data � 03/11/06 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Atualizacao das promocoes mensais do cadastro de produtos  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "protheus.ch"
#include "rwmake.ch"

user function vit281()
ccadastro:="Cadastro de Promocoes"
arotina  :={}
aadd(arotina,{'Pesquisar','PESQBRW()'  ,0,1})
aadd(arotina,{'Alterar'  ,'U_VIT281A()',0,2})

dbselectarea("SB1")
dbsetorder(1)
dbgotop()
_aindex :={}
_cfiltro:="B1_TIPO$'PA'"
filbrowse("SB1",_aindex,_cfiltro)
mbrowse(6,1,22,75,"SB1")
endfilbrw()
return()

user function vit281a()
Local oCombo, aItems:= {"M=Maximo","N=Normal","P=Promocao","F=Preco Final"}
_promoc:=sb1->b1_promoc
_descmax:=sb1->b1_descmax

@ 000,000 to 145,500 dialog odlg1 title "Promocoes de Vendas"

@ 010,010 say "Produto"
@ 010,055 say sb1->b1_cod
@ 020,010 say "Descricao"
@ 020,055 say sb1->b1_desc
@ 030,010 say "Promocao"

cCombo:=""

if _promoc="M"
	cCombo:= "M"
elseif _promoc="N"
	cCombo:= "N"
elseif _promoc="P"
	cCombo:= "P"
else
	cCombo:= "F"
endif

@ 030,055 MSCOMBOBOX oCombo VAR cCombo ITEMS aItems When .t. SIZE 100,20 OF odlg1 PIXEL 

@ 040,010 say "Desc. M醲imo"
@ 040,055 get _descmax size 35,8 picture "@E 999.99"

@ 050,055 bmpbutton type 1 action _grava()
@ 050,090 bmpbutton type 2 action close(odlg1)

activate dialog odlg1 centered
return()


static function _grava()
sb1->(reclock("SB1",.f.))
sb1->b1_promoc:=cCombo
sb1->b1_descmax:=_descmax
sb1->(msunlock())
close(odlg1)
return()

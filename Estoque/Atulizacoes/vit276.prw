/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT276   ³ Autor ³Alex Junio de Miranda  ³ Data ³ 31/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualizacao da revisao de arte do cadastro de produtos     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "protheus.ch"
#include "rwmake.ch"

user function vit276()
ccadastro:="Revisao de arte"
arotina  :={}
aadd(arotina,{'Pesquisar','PESQBRW()'  ,0,1})
aadd(arotina,{'Alterar'  ,'U_VIT276A()',0,2})

dbselectarea("SB1")
dbsetorder(1)
dbgotop()
_aindex :={}
_cfiltro:="B1_TIPO$'EE/EN'"
filbrowse("SB1",_aindex,_cfiltro)
mbrowse(6,1,22,75,"SB1")
endfilbrw()
return()

user function vit276a()
Local oCombo, aItems:= {"1=Sim","2=Nao"}
_crevarte:=sb1->b1_revarte
_gravrt:=sb1->b1_resptec

@ 000,000 to 145,500 dialog odlg1 title "Revisao de arte"

@ 010,010 say "Produto"
@ 010,055 say sb1->b1_cod
@ 020,010 say "Descricao"
@ 020,055 say sb1->b1_desc
@ 030,010 say "Revisao de arte"
@ 030,055 get _crevarte size 35,8
@ 040,010 say "Possui Grav. R.T."

cCombo:=""

if _gravrt="1"
	cCombo:= "1"
else 
	cCombo:= "2"
endif

@ 040,055 MSCOMBOBOX oCombo VAR cCombo ITEMS aItems When .t. SIZE 30,20 OF odlg1 PIXEL 

@ 060,055 bmpbutton type 1 action _grava()
@ 060,090 bmpbutton type 2 action close(odlg1)

activate dialog odlg1 centered
return()

static function _grava()
sb1->(reclock("SB1",.f.))
sb1->b1_revarte:=_crevarte
sb1->b1_resptec:=cCombo
sb1->(msunlock())
close(odlg1)
return()

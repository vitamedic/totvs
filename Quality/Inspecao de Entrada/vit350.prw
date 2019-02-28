/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT350   ³Autor ³Alex Junio de Miranda    ³Data ³ 09/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualizacao dos Dados de Reanalise na Tabela de Entradas   ³±±
±±³          ³ apos Transferência de Estoque para Quarentena              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "protheus.ch"
#include "rwmake.ch"

user function vit350()
ccadastro:="Informacoes para Laudo Reanalise"
arotina  :={}
aadd(arotina,{'Pesquisar','PESQBRW()'  ,0,1})
aadd(arotina,{'Alterar'  ,'U_VIT350A()',0,2})

dbselectarea("QEK")
dbsetorder(6)
dbgotop()
_aindex :={}
_cfiltro:="QEK_TIPDOC$'TR    '"
filbrowse("QEK",_aindex,_cfiltro)
mbrowse(6,1,22,75,"QEK")
endfilbrw()
return()

user function vit350a()      
Local oCombo, aItems:= {"1=Sim","2=Nao"}

_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))    

sb1->(dbseek(_cfilsb1+qek->qek_produt))
_item:=qek->qek_itemnf
_reanalise:=qek->qek_reanal
_numreanalise:=qek->qek_numrea

@ 000,000 to 170,500 dialog odlg1 title "Informações para Laudo de Reanalise"

@ 010,010 say "Produto"
@ 010,055 say qek->qek_produt
@ 010,085 say sb1->b1_desc
@ 020,010 say "Lote"
@ 020,055 say qek->qek_lote
@ 020,100 say "Nota Fiscal   "+qek->qek_ntfisc+"-"+qek->qek_serinf
@ 030,010 say "Item NF"
@ 030,055 get _item size 100,7
@ 040,010 say "Reanalise ?"

cCombo:=""

if _reanalise="1"
	cCombo:= "1"
else
	cCombo:= "2"
endif

@ 040,055 MSCOMBOBOX oCombo VAR cCombo ITEMS aItems When .t. SIZE 100,20 OF odlg1 PIXEL 

@ 050,010 say "Nº Reanalise"
@ 050,055 get _numreanalise size 35,7

@ 070,055 bmpbutton type 1 action _grava()
@ 070,090 bmpbutton type 2 action close(odlg1)

activate dialog odlg1 centered
return()

static function _grava()
qek->(reclock("QEK",.f.))
qek->qek_itemnf:=_item
qek->qek_reanal:=cCombo
qek->qek_numrea:=_numreanalise
qek->(msunlock())
close(odlg1)
return()

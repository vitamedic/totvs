/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT350   矨utor 矨lex Junio de Miranda    矰ata � 09/12/09 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Atualizacao dos Dados de Reanalise na Tabela de Entradas   潮�
北�          � apos Transfer阯cia de Estoque para Quarentena              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       �                                                            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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

@ 000,000 to 170,500 dialog odlg1 title "Informa珲es para Laudo de Reanalise"

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

@ 050,010 say "N� Reanalise"
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

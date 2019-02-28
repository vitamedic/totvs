/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT320   ³Autor ³Alex Junio de Miranda    ³Data ³ 08/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualizacao dos Dados de Fornecedor e Fabricante na        ³±±
±±³          ³ Entrada de Notas Fiscais - MP/EE/EN                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "protheus.ch"
#include "rwmake.ch"

user function vit320()
ccadastro:="Informacoes de Fabricante/Fornecedor por Lote"
arotina  :={}
aadd(arotina,{'Pesquisar','PESQBRW()'  ,0,1})
aadd(arotina,{'Alterar'  ,'U_VIT320A()',0,2})

dbselectarea("SD1")
dbsetorder(1)
dbgotop()
_aindex :={}
_cfiltro:="D1_TP$'MP/EE/EN'"
filbrowse("SD1",_aindex,_cfiltro)
mbrowse(6,1,22,75,"SD1")
endfilbrw()
return()

user function vit320a()
Local oCombo, aItems:= {"1=Sim","2=Nao"}
_fabric:=sd1->d1_fabric
_lotfabr:=sd1->d1_lotfabr
_dtfabr:=sd1->d1_dtfabr
_numvol:=sd1->d1_numvol
_lotefor:=sd1->d1_lotefor

@ 000,000 to 170,500 dialog odlg1 title "Informações de Fabricante/Fornecedor por Lote"

@ 010,010 say "Produto"
@ 010,055 say sd1->d1_cod
@ 010,085 say sd1->d1_descpro
@ 020,010 say "Lote Vitamedic"
@ 020,055 say sd1->d1_lotectl
@ 020,100 say "Nota Fiscal   "+sd1->d1_doc+"-"+sd1->d1_serie
@ 030,010 say "Fabricante"
@ 030,055 get _fabric size 100,7
@ 040,010 say "Lote Fabricante"
@ 040,055 get _lotfabr size 70,7
@ 040,160 say "Dt.Fabricacao"
@ 040,200 get _dtfabr size 35,7
@ 050,010 say "Lt.Fornecedor"
@ 050,055 get _lotefor size 100,7
@ 050,160 say "Nº Volumes"
@ 050,200 get _numvol picture "@E 9999" size 12,7

/*
cCombo:=""
if _gravrt="1"
	cCombo:= "1"
else 
	cCombo:= "2"
endif
@ 040,055 MSCOMBOBOX oCombo VAR cCombo ITEMS aItems When .t. SIZE 30,20 OF odlg1 PIXEL 
*/
@ 070,055 bmpbutton type 1 action _grava()
@ 070,090 bmpbutton type 2 action close(odlg1)

activate dialog odlg1 centered
return()

static function _grava()
sd1->(reclock("SD1",.f.))
sd1->d1_fabric:=_fabric
sd1->d1_lotfabr:=_lotfabr
sd1->d1_dtfabr:=_dtfabr
sd1->d1_numvol:=_numvol
sd1->d1_lotefor:=_lotefor
sd1->(msunlock())
close(odlg1)
return()

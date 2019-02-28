/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT332   ³ Autor ³Alex Junio de Miranda  ³ Data ³ 28/11/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualizacao das Informacoes de Embarque para Faturamento   ³±±
±±³          ³ de Exportacoes                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "protheus.ch"
#include "rwmake.ch"

user function vit332()
ccadastro:="Informacoes de Comercio Exterior"
arotina  :={}
aadd(arotina,{'Pesquisar','PESQBRW()'  ,0,1})
aadd(arotina,{'Alterar'  ,'U_VIT332A()',0,2})

dbselectarea("SF2")
dbsetorder(1)
dbgotop()
_aindex :={}
_cfiltro:="F2_EST$'EX'"
filbrowse("SF2",_aindex,_cfiltro)
mbrowse(6,1,22,75,"SF2")
endfilbrw()
return()

user function vit332a()
_ufembarque:=sf2->f2_ufembex
_locembex:=sf2->f2_lcembex

@ 000,000 to 145,500 dialog odlg1 title "Inform. Comercio Exterior"

@ 010,010 say "UF Embarque"
@ 010,055 get _ufembarque size 15,8
@ 020,010 say "Local Embarque:"
@ 020,055 get _locembex size 60,8

@ 060,055 bmpbutton type 1 action _grava()
@ 060,090 bmpbutton type 2 action close(odlg1)

activate dialog odlg1 centered
return()

static function _grava()
sf2->(reclock("SF2",.f.))
sf2->f2_ufembex:=_ufembarque
sf2->f2_lcembex:=_locembex
sf2->(msunlock())
close(odlg1)
return()

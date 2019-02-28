/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT295   ³Autor ³ Heraildo C. de Freitas ³Data ³ 30/04/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualizacao do Campo de Impressao da Op no Relatorio de    ³±±
±±³          ³ Controle de Estoque de Produtos Acabados                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vit295()
ccadastro:="Imprime relatorio"
arotina  :={}
aadd(arotina,{"Pesquisar","AXPESQUI"   ,0,1})
aadd(arotina,{"Atualizar","U_VIT295A()",0,2})
sc2->(dbsetorder(1))
sc2->(dbgotop())
mbrowse(6,1,22,75,"SC2")
return()

user function vit295a()
_cfilsb1:=xfilial("SB1")
_cfilsc2:=xfilial("SC2")

sb1->(dbsetorder(1))
sb1->(dbseek(_cfilsb1+sc2->c2_produto))

_cimprime:=sc2->c2_imprel

@ 000,000 to 150,450 dialog odlg title "Imprime relatorio"
@ 005,005 say "OP"
@ 005,045 say sc2->c2_num
@ 015,005 say "Produto"
@ 015,045 say alltrim(sb1->b1_cod)+" - "+alltrim(sb1->b1_desc)
@ 025,005 say "Emissao"
@ 025,045 say dtoc(sc2->c2_emissao)
@ 035,005 say "Imprime"
@ 035,045 get _cimprime picture "@!" valid pertence("SN")

@ 055,020 bmpbutton type 1 action _grava()
@ 055,055 bmpbutton type 2 action close(odlg)

activate dialog odlg centered
return()

static function _grava()
reclock("SC2",.f.)
sc2->c2_imprel:=_cimprime
msunlock()
close(odlg)
return()

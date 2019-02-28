/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LICV001  ³AUTOR ³ Heraildo C. de Freitas ³DATA ³ 29/09/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validacao no Licitante na Inclusao de Propostas para       ³±±
±±³          ³ Atualizar os Dados do Representante e Comissao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
user function licv001()       
_lok:=.t.    

_cfilsa3:=xfilial("SA3")
_cfilszp:=xfilial("SZP")

szp->(dbsetorder(1))
szp->(dbseek(_cfilszp+m->zl_licitan))
sa3->(dbsetorder(1))
sa3->(dbseek(_cfilsa3+szp->zp_codrep))
_nregsa3:=sa3->(recno())
m->zl_repres:=szp->zp_codrep
m->zl_comis1:=sa3->a3_comis
_csuper:=sa3->a3_super
_cgeren:=sa3->a3_geren
sa3->(dbseek(_cfilsa3+_csuper))
m->zl_comis2:=sa3->a3_comis
sa3->(dbseek(_cfilsa3+_cgeren))
m->zl_comis3:=sa3->a3_comis
sa3->(dbgoto(_nregsa3)) 
return(_lok)
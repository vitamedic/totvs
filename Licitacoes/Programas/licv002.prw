/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � LICV002  � Autor � Heraildo C. de Freitas� Data �29/09/2003潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Validacao no Representante na Inclusao de Propostas        潮�
北�          � para Atualizar os Dados de Comissao                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"
user function licv002()       
_lok:=.t.    

_cfilsa3:=xfilial("SA3")

sa3->(dbsetorder(1))
sa3->(dbseek(_cfilsa3+m->zl_repres))
_nregsa3:=sa3->(recno())
m->zl_comis1:=sa3->a3_comis
_csuper:=sa3->a3_super
_cgeren:=sa3->a3_geren
sa3->(dbseek(_cfilsa3+_csuper))
m->zl_comis2:=sa3->a3_comis
sa3->(dbseek(_cfilsa3+_cgeren))
m->zl_comis3:=sa3->a3_comis
sa3->(dbgoto(_nregsa3)) 
return(_lok)
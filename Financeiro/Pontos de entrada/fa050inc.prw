/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘
北砅rograma  � FA050INC � Autor � Heraildo C. de Freitas� Data � 03/09/03 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada para Exigir a Digitacao do Centro de Custo潮�
北�          � na Inclusao de Contas a Pagar                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function fa050inc()
_lok:=.t.
_cfilsed:=xfilial("SED")
sed->(dbsetorder(1))
sed->(dbseek(_cfilsed+m->e2_naturez))
if ! empty(sed->ed_codrat)
	if m->e2_rateio<>"S"
		_lok:=.f.
		msginfo("Favor informar o rateio!")
	endif
elseif sed->ed_ccobrig=="S" .and.;
	empty(m->e2_cc)
	_lok:=.f.
	msginfo("Favor informar o centro de custo!")
endif
return(_lok)
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT002   � Autor � Heraildo C. de Freitas� Data �18/12/01� 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Gatilho no Codigo do Cliente / Fornecedor nos Acertos      潮�
北�          � Fiscais para Retornar o Estado                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vit002()
if m->f3_cfo<"500  " .and. ! m->f3_tipo$"BD"
	_cfilsa2:=xfilial("SA2")
	sa2->(dbsetorder(1))
	if sa2->(dbseek(_cfilsa2+m->f3_cliefor+m->f3_loja))
		_cestado:=sa2->a2_est
	else
		_cestado:=space(2)
	endif
else
	_cfilsa1:=xfilial("SA1")
	sa1->(dbsetorder(1))
	if sa1->(dbseek(_cfilsa1+m->f3_cliefor+m->f3_loja))
		_cestado:=sa1->a1_est
	else
		_cestado:=space(2)
	endif
endif
return(_cestado)
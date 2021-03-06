/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VITLP13  � Autor 矵eraildo C. de Freitas � Data � 17/05/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna a Conta Contabil no Lancamento Padronizado de      潮�
北�          � Exclusao de Compensacao de Pagamentos Antecipados (589-01) 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vitlp13()
_nordse2:=se2->(indexord())
_nregse2:=se2->(recno())

_cfilse2:=xfilial("SE2")
_cfilsed:=xfilial("SED")
se2->(dbsetorder(1))

_cprefixo:=substr(se5->e5_documen,1,3)
_cnum:=substr(se5->e5_documen,4,6)
_cparcela:=substr(se5->e5_documen,10,1)
_ctipo:=substr(se5->e5_documen,11,3)
if se2->(dbseek(_cfilse2+_cprefixo+_cnum+_cparcela+_ctipo+se5->e5_clifor+se5->e5_loja))
	if sed->(dbseek(_cfilsed+se2->e2_naturez))
		if empty(sed->ed_conta)
			_cconta:="C.NATUR.BRANCO"
		else
			_cconta:=sed->ed_conta
		endif
	else
		_cconta:="NATUR.INEXISTENTE"
	endif
else
	_cconta:="PA NAO ENCONTRADO"
endif
se2->(dbsetorder(_nordse2))
se2->(dbgoto(_nregse2))
return(_cconta)
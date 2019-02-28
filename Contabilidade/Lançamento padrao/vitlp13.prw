/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITLP13  ³ Autor ³Heraildo C. de Freitas ³ Data ³ 17/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a Conta Contabil no Lancamento Padronizado de      ³±±
±±³          ³ Exclusao de Compensacao de Pagamentos Antecipados (589-01) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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
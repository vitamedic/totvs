/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITLP05  ³ Autor ³ Heraildo C. de Freitas³ Data ³ 10/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a Conta Contabil no Lancamento Padronizado de      ³±±
±±³          ³ Baixa de Titulos a Receber (520-01)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vitlp05()
sa1->(dbseek(xFilial("SA1")+se1->e1_cliente+se1->e1_loja))
_cconta:="INDEFINIDO"
if se1->e1_origem=="FINA040 "
	if sed->ed_status=="1"
		if empty(sed->ed_provis)
			if empty(sa1->a1_conta)
				_cconta:="C.CLIENTE BRANCO"
			else
				_cconta:=sa1->a1_conta
			endif
		else
			_cconta:=sed->ed_provis
		endif
	else
		if empty(sed->ed_conta)
			_cconta:="C.RECEITA BRANCO"
		else
			_cconta:=sed->ed_conta
		endif
	endif
else
	if empty(sa1->a1_conta)
		_cconta:="C.CLIENTE BRANCO"
	else
		_cconta:=sa1->a1_conta
	endif
endif
return(_cconta)
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITLP28    ³ Autor ³ Heraildo C. Freitas ³ Data ³ 05/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a Conta Contabil de Credito no Lancamento Padrao   ³±±
±±³          ³ de Compensacao de Contas a Pagar                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vitlp28()
if ! se2->e2_tipo$"NDF/PA "
	_aarease2:=se2->(getarea())
	
	se2->(dbsetorder(1))
	se2->(dbseek(xfilial("SE2")+left(se5->e5_documen,13)))
	_cnatureza:=se2->e2_naturez
	
	se2->(restarea(_aarease2))
else
	_cnatureza:=se2->e2_naturez
endif

_aareased:=sed->(getarea())

sed->(dbsetorder(1))
sed->(dbseek(xfilial("SED")+_cnatureza))

if empty(sed->ed_provis)
	_cconta:="ED_PROVIS"
else
	_cconta:=sed->ed_provis
endif

sed->(restarea(_aareased))
return(_cconta)

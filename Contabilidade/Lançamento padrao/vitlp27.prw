/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VITLP27    � Autor � Heraildo C. Freitas � Data � 05/10/06 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna o Valor do Lancamento Padrao de Compensacao de     潮�
北�          � Contas a Pagar                                             潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vitlp27()
_nvalor:=0
if ! se2->e2_tipo$"NDF/PA "
	_aarease2:=se2->(getarea())
	
	se2->(dbsetorder(1))
	se2->(dbseek(xfilial("SE2")+left(se5->e5_documen,13)))
	
	if se2->e2_origem<>"MATA460 "
		_nvalor:=se5->e5_valor
	endif
	
	se2->(restarea(_aarease2))
else
	if se2->e2_origem<>"MATA460 "
		_nvalor:=se5->e5_valor
	endif
endif
return(_nvalor)

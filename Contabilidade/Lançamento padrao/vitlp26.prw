/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VITLP26    � Autor � Heraildo C. Freitas � Data � 05/10/06 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna o Valor do Lancamento Padrao de Compensacao de     潮�
北�          � Contas a Receber                                           潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vitlp26()
_nvalor:=0
if ! se1->e1_tipo$"NCC/RA "
	_aarease1:=se1->(getarea())
	
	se1->(dbsetorder(1))
	se1->(dbseek(xfilial("SE1")+left(se5->e5_documen,13)))
	
	if se1->e1_origem<>"MATA100 "
		_nvalor:=se5->e5_valor
	endif
	
	se1->(restarea(_aarease1))
else
	if se1->e1_origem<>"MATA100 "
		_nvalor:=se5->e5_valor
	endif
endif
return(_nvalor)

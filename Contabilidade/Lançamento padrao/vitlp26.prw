/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VITLP26    � Autor � Heraildo C. Freitas � Data � 05/10/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna o Valor do Lancamento Padrao de Compensacao de     ���
���          � Contas a Receber                                           ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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

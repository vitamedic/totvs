/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VITLP27    � Autor � Heraildo C. Freitas � Data � 05/10/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna o Valor do Lancamento Padrao de Compensacao de     ���
���          � Contas a Pagar                                             ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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

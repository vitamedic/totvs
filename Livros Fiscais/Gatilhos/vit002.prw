/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT002   � Autor � Heraildo C. de Freitas� Data �18/12/01� ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gatilho no Codigo do Cliente / Fornecedor nos Acertos      ���
���          � Fiscais para Retornar o Estado                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VITLP05  � Autor � Heraildo C. de Freitas� Data � 10/05/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna a Conta Contabil no Lancamento Padronizado de      ���
���          � Baixa de Titulos a Receber (520-01)                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT014   � Autor � Heraildo C. de Freitas� Data �21/01/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao na Quantidade Vendida na Digitacao de Pedidos    ���
���          � de Venda para Alertar o Usuario Sobre Caixa Padrao         ���
���          � Incompleta.                                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vit014()
_lok:=.t.
if ! m->c5_tipo$"BD"
	if m->c6_qtdven%sb1->b1_cxpad>0
		_lok:=msgyesno("Caixa padrao incompleta! Confirma a digitacao?")
	endif
endif
return(_lok)
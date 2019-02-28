/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT022   �Autor � Heraildo C. de Freitas  �Data � 01/02/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao do Produto na Simulacao de Producao, nao         ���
���          � Permitindo Simulacao de Produtos em Lancamento             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

user function vit022()
_lok:=.f.
_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))
if ! sb1->(dbseek(_cfilsb1+m->z2_produto))
	_lok:=.f.
	msginfo("O codigo digitado nao esta cadastrado!")
elseif ! sb1->b1_tipo$"PA/PI/PN" //Guilherme 06/06/2016 - Inclus�o do tipo PN(NUTRAC�UTICOS).
	_lok:=.f.
	msginfo("Nao e permitida simulacao de producao para este produto!")
else
	_lok:=existchav("SZ2",m->z2_produto)
endif
return(_lok)

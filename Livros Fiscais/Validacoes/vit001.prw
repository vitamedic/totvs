/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT001   �Autor � Heraildo C. de Freitas  �Data �18/12/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao do Codigo do Cliente / Fornecedor nos Acertos    ���
���          � Fiscais                                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

// VALIDACAO DO CODIGO
user function vit001a()
if m->f3_cfo<"500  " .and. ! m->f3_tipo$"BD"
	_lok:=existcpo("SA2",m->f3_cliefor+alltrim(m->f3_loja))
else
	_lok:=existcpo("SA1",m->f3_cliefor+alltrim(m->f3_loja))
endif
return(_lok)

// VALIDACAO DA LOJA
user function vit001b()
if m->f3_cfo<"500  " .and. ! m->f3_tipo$"BD"
	_lok:=existcpo("SA2",m->f3_cliefor+m->f3_loja)
else
	_lok:=existcpo("SA1",m->f3_cliefor+m->f3_loja)
endif
return(_lok)
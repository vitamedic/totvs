/*
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
���Programa  � FA080DT  � Autor � Heraildo C. de Freitas� Data � 15/01/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Colocar o Nome do Cliente no Historico da Baixa a Pagar    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function fa080dt()
_nordsa2:=sa2->(indexord())
_nregsa2:=sa2->(recno())
_cfilsa2:=xfilial("SA2")
sa2->(dbsetorder(1))
sa2->(dbseek(_cfilsa2+se2->e2_fornece+se2->e2_loja))
chist070:=sa2->a2_nome
sa2->(dbsetorder(_nordsa2))
sa2->(dbgoto(_nregsa2))
return(.t.)
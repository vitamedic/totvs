/*
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
���Programa  � FA070MDB � Autor � Heraildo C. de Freitas� Data � 15/01/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Colocar o Nome do Cliente no Historico da Baixa a Receber  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function fa070mdb()
_nordsa1:=sa1->(indexord())
_nregsa1:=sa1->(recno())

_cfilsa1:=xfilial("SA1")
sa1->(dbsetorder(1))

sa1->(dbseek(_cfilsa1+se1->e1_cliente+se1->e1_loja))
chist070:=sa1->a1_nome

sa1->(dbsetorder(_nordsa1))
sa1->(dbgoto(_nregsa1))
return(.t.)
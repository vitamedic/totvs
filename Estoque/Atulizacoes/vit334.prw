/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT334   � Autor � Alex J�nio de Miranda � Data � 25/11/08 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � AXCADASTRO para Manutencao da Tabela de Complemento de     ���
���          � Importacao                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vit334()

cd5->(dbsetorder(1))
cd5->(dbgotop())
axcadastro("CD5","Complemento de Importacao")

return()

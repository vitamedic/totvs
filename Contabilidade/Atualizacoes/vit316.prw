/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT316   � Autor � Alex J�nio de Miranda � Data � 15/05/08 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � AXCADASTRO para Manutencao na Tabela de Gerencias dos      ���
���          � Centros de Custos para Orcamento                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vit316()

szt->(dbsetorder(1))
szt->(dbgotop())
axcadastro("SZT","Gerencias dos Centros de Custos")

return()


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT291   � Autor � Heraildo C. de Freitas� Data � 08/02/07 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � AXCADASTRO para Manutencao na Tabela de Regras de          ���
���          � Contabilizacao (SZQ)                                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vit291()
szq->(dbsetorder(1))
szq->(dbgotop())
    axcadastro("SZQ","Regras de contabilizacao")
return()
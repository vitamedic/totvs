/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT066   � Autor � HERAILDO C. DE FREITAS� Data � 17/05/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Utilizado para Atualizar a Data de Validade do Lote no     ���
���          � Browse da Baixa do CQ                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/


#include "rwmake.ch"

user function vit066()
_ddtvalid:=posicione("SB8",3,xfilial("SB8")+sd7->d7_produto+sd7->d7_local+sd7->d7_lotectl,"B8_DTVALID")
return(_ddtvalid)
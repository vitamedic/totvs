/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT286   � Autor � Heraildo C. Freitas   � Data � 07/12/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa para Verificacao da Data de Validade dos Lotes    ���
���          � Via Schedule                                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#include "tbiconn.ch"

user function vit286()
prepare environment empresa "01" filial "01" tables "SB8","SDD"

conout("Verificando data de validade dos lotes")
putmv("MV_DATALOT",ddatabase-1)
bloqdata(.t.,.t.)
putmv("MV_DATALOT",ctod("31/12/49"))

reset environment
return()

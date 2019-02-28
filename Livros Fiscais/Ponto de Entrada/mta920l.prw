#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MTA920L   �Autor � Edson Gomes Barbosa �Data �  26/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para Alteraco do SF3 Colocando na Coluna  ���
���          � Obs.                                                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � AP6 IDE                                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

User Function MTA920L


Private cString := ""

If !"CTR"$SF1->F1_ESPECIE
	Do Case
	   Case "104081"$SD1->D1_cod
	   		cString := "CONSTRUCAO - PORTARIA"
	   Case "104467"$SD1->D1_cod
	   		cString := "CONSTRUCAO - VESTIARIO"
	   Case "104427"$SD1->D1_cod
	   		cString := "CONSTRUCAO - ADM"
	   Case "103565"$SD1->D1_cod
	   		cString := "CONSTRUCAO - PRODUTO ACABADO"
	   Case "103850"$SD1->D1_cod
	   		cString := "CONSTRUCAO - SOLIDOS"
	   Case "104416"$SD1->D1_cod
	   		cString := "CONSTRUCAO - AMP. MANUTENCAO"
	   Case "104281"$SD1->D1_cod
	   		cString := "CONSTRUCAO - SEMI S./LIQUIDOS"
	End Case
Endif
If !Empty(cString)
	SF3->F3_OBSERV:=cString
Endif
Return()
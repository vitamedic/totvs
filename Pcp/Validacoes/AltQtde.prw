#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � AltQtde � Autor � Ricardo Moreira �          Data �28/07/16���
�������������������������������������������������������������������������Ĵ��
���Descricao � Valida��o para deixar editar o campo quantidade ou n�o     ���
���          � Entrada da OP.			                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

User Function AltQtde() //U_AltQtde()

Local _Cont  := " "
Local aArea  := GetArea()
Local _Ret   := " "

_cQuery 	:= " SELECT COUNT(*) Qtd FROM "
_cQuery 	+= retsqlname("SG1")+" SG1 "
_cQuery 	+= " WHERE SG1.D_E_L_E_T_ <> '*' "
_cQuery 	+= " AND SG1.G1_COMP LIKE 'PI%' "
_cQuery 	+= " AND SG1.G1_COD = '"+M->C2_PRODUTO+"' "

_cQuery :=changequery(_cQuery)

tcquery _cQuery new alias "TMP"
_Cont := TMP->Qtd
TMP->(DBCLOSEAREA())

If _Cont > 0
	_Ret := SB1->B1_TIPO$"MP/EE/EN/PA"	
Else
	_Ret := SB1->B1_TIPO$"MP/EE/EN"	
EndIf

RestArea(aArea)

return(_Ret)

#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � AltQtde � Autor � Ricardo Moreira �          Data �28/07/16潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Valida玢o para deixar editar o campo quantidade ou n鉶     潮�
北�          � Entrada da OP.			                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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

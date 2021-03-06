#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � Gat_SP2   矨utor � Lucia Valeria      矰ata �  07/11/02    潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Gatilho para Atualizar os Campos de Horario de Entradas e   北
北�          � Saida.         .                                           罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北砋so       � PONM010 - Leitura do  Ponto de Entrada.                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function Gat_SP2
Local _aArea  := GetArea() // Salva area atual
Local _cEntra1

DBSelectArea("SRA")
DBSetOrder(1)
DBSelectArea("SPJ")
DBSetOrder(1)

If SRA->(DBSeek(xFilial("SRA") + M->P2_MAT))
   If SPJ->(DBSeek(xFilial("SPJ") + SRA->RA_TNOTRAB + "01" + StrZero(Dow(M->P2_DATA),1)))
      _cEntra1      := SPJ->PJ_ENTRA1
      M->P2_SAIDA1  := SPJ->PJ_SAIDA1
      M->P2_ENTRA2  := SPJ->PJ_ENTRA2
      M->P2_SAIDA2  := SPJ->PJ_SAIDA2 
      M->P2_INTERV1 := SPJ->PJ_INTERV1 
   EndIf 
EndIf

RestArea(_aArea) // Restaura area
Return (_cEntra1)
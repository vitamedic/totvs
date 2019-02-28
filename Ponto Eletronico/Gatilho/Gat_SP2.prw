#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Gat_SP2   ³Autor ³ Lucia Valeria      ³Data ³  07/11/02    ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Gatilho para Atualizar os Campos de Horario de Entradas e   ±±
±±³          ³ Saida.         .                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ PONM010 - Leitura do  Ponto de Entrada.                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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
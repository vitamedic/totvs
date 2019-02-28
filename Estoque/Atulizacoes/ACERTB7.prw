#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ZROTA001  ³Autor  ³Andre Almeida       ³ Data ³  17/09/09   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Alimenta sz0(cadastro de setor) com contador               ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Alteracao ³ Andre Almeida                                              ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Sequencia ³ 1 - Primeira Rotina                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

USER FUNCTION ACERTB7()
DbSelectArea("SB7")
SB7->(dBgoTop())
                             
if msgyesno("Deseja atualizar o SB7")

while sb7->(!EOF())

	cquery:=" SELECT B8_DTVALID DTVALID FROM "
	cquery+=  " SB8010"
	cquery+="  WHERE D_E_L_E_T_=' '"
	cquery+="  AND B8_FILIAL='"+xfilial("SB8")+"'"
	cquery+="  AND B8_PRODUTO = '"+SB7->B7_COD+"'"
	cquery+="  AND B8_LOTECTL ='"+SB7->B7_LOTECTL+"'"
	cquery+="  AND B8_LOCAL = '"+SB7->B7_LOCAL+"'"
 
		
	MemoWrite("/sql/ACERTB7.sql",cquery)
	tcquery cquery new alias "TMP1"
	u_setfield("TMP1")
	
	TMP1->(DBGOTOP())
   	_lote := TMP1->DTVALID

	if !empty(_lote)
		Reclock("SB7",.F.)
		SB7->B7_DTVALID := STOD(_lote)
		MsUnlock()
	ENDIF

sb7->(dbskip())
TMP1->(DBCLOSEAREA())
enddo	          
endif
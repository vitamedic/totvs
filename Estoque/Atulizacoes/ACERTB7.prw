#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  砕ROTA001  矨utor  矨ndre Almeida       � Data �  17/09/09   潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Alimenta sz0(cadastro de setor) com contador               潮�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北矨lteracao � Andre Almeida                                              潮�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北砈equencia � 1 - Primeira Rotina                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
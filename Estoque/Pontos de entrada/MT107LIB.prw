/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT240   ³ Autor ³ André Almeida Alves   ³ Data ³ 08/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validação da Liberação da SA                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

User Function MT107LIB( )
Local lRet := .T.

if select("tmp1")>0
	TMP1->(dbclosearea())
endif
		
cquery:=" SELECT * FROM "
cquery+=  retsqlname("SZH")+" SZH"
cquery+="  WHERE D_E_L_E_T_=' '"
cquery+="  AND ZH_FILIAL='"+xfilial("SA3")+"'"
cquery+="  AND ZH_CODUSR = '"+__cuserid+"'"
cquery+="  AND ZH_CC = '"+SCP->CP_CC+"'"
cquery+="  AND ZH_TIPO IN ('A','L')"
cquery+="  order by zh_codusr"
	
MemoWrite("/sql/szh.sql",cquery)
tcquery cquery new alias "TMP1"

tmp1->(dbgotop())
	
if empty(tmp1->zh_codusr)
	msgalert("Usuario não autorizado a Liberar SA para este Centro de Custo.")
	lRet := .F.	
endif

RecLock("SCP", .F.)
	SCP->CP_DATALIB  := date()
	SCP->CP_USRLIB	 := __cuserid
MsUnlock()	

Return lRet

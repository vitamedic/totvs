/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT240   � Autor � Andr� Almeida Alves   � Data � 08/03/12 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Valida玢o da Libera玢o da SA                               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
	msgalert("Usuario n鉶 autorizado a Liberar SA para este Centro de Custo.")
	lRet := .F.	
endif

RecLock("SCP", .F.)
	SCP->CP_DATALIB  := date()
	SCP->CP_USRLIB	 := __cuserid
MsUnlock()	

Return lRet

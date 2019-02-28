/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT240   � Autor � Andr� Almeida Alves   � Data � 08/03/12 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Valida��o da Libera��o da SA                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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
	msgalert("Usuario n�o autorizado a Liberar SA para este Centro de Custo.")
	lRet := .F.	
endif

RecLock("SCP", .F.)
	SCP->CP_DATALIB  := date()
	SCP->CP_USRLIB	 := __cuserid
MsUnlock()	

Return lRet

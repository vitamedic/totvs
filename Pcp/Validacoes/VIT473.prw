/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT473 矨utor � Ricardo Moreira          矰ata � 24/01/13  潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Informa as fase de apontamentos da produ玢o, que n鉶 foram 潮�
北�          � apontadas na ordem no Produc鉶 PCP (MOD 2).				  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � N鉶 permite o apontamento de fase inv醠ida.                潮�
北�          � Campo: SH6->H6_OPERAC                                      潮�
北�   lRet   �											   				  潮�
北�          � 					                                          潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "Ap5Mail.ch"
#include "tbicode.ch"
#include "dialog.ch"
#INCLUDE "protheus.ch"


User Function VIT473()

	lRet 	:= .T.
	_fases  := ""

	_cfilsh6:= xfilial("SH6")   

	IF(SELECT("TMP1") > 0)
		TMP1->(DBCLOSEAREA())
	ENDIF
	
	_cQue2 	:= " SELECT DISTINCT G2_OPERAC, C2_ROTEIRO "
	_cQue2  += " FROM " + retsqlname("SG2")+" SG2 " 
	_cQue2 	+= " INNER JOIN " + retsqlname("SC2")+ " SC2 ON SC2.C2_PRODUTO = SG2.G2_PRODUTO AND SC2.C2_ROTEIRO = SG2.G2_CODIGO "  
	_cQue2 	+= " INNER JOIN " + retsqlname("SH6")+ " SH6 ON SH6.H6_PRODUTO = SG2.G2_PRODUTO AND SH6.H6_OPERAC = SG2.G2_OPERAC "
	_cQue2 	+= " AND SH6.D_E_L_E_T_ <> '*' "
	_cQue2 	+= " AND SG2.D_E_L_E_T_ <> '*' "
	_cQue2 	+= " AND SC2.D_E_L_E_T_ <> '*' "
	_cQue2 	+= " AND G2_FILIAL = '"+_cfilsh6+"' "
	_cQue2 	+= " AND C2_NUM = '"+Substr(m->h6_op,1,6)+"' "
	_cQue2 	+= " AND G2_PRODUTO = '"+m->h6_produto+"' "
	_cQue2 	+= " AND G2_OPERAC  < '"+m->h6_operac+"' "
	_cQue2 	+= " ORDER BY G2_OPERAC "

	_cQue2 :=changequery(_cQue2)
	//MEMOWRIT("\sql\mt680val9.sql",_cQue2)
	tcquery _cQue2 new alias "TMP1" 

	While !TMP1->(Eof())
         dbSelectArea("SH6")
	     dbSetOrder(1)
		 If !SH6->(DbSeek(xFilial("SH6")+M->H6_OP+M->H6_PRODUTO+TMP1->G2_OPERAC))		              
		   _fases += TMP1->G2_OPERAC + "/"
		   lRet := .F. 	                
		 EndIf  
		    TMP1->(DbSkip())		    
	EndDo
	If len(_fases) <> 0	  
   	   Msginfo("Aten玢o !! Etapas anteriores n鉶 apontadas:" +_fases)   
	EndIf
	TMP1->(DBCLOSEAREA())
 	
Return(lRet)


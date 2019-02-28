#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT377    �Autor � Andre Almeida          Data 17/05/12    ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilho para Cria��o do Codigo do bem                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

user function vit377()

	_cAbrevFam	:= posicione("ST6",1,xFilial("ST6")+m->t9_codfami,"T6_ABREV")
	_cSetor		:= m->t9_setor

    if select("TMP")<>0
    	tmp->(dbclosearea())
    endif

	cQuery 	:= " SELECT max(t9_codbem) max"
	cQuery 	+= " FROM "
	cQuery	+= retsqlname("ST9")+" ST9"
	cQuery 	+= " WHERE st9.d_e_l_e_t_ = ' '"
	cQuery 	+= " AND t9_codbem like '%"+Alltrim(_cAbrevFam)+"%'"
	cQuery 	+= " AND t9_codbem like '%"+Alltrim(_cSetor)+"%'"
	
	cQuery:=changequery(cQuery)
	MEMOWRIT("\sql\vit377.sql",cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"
	u_setfield("TMP")
	
	_cRet	:= soma1(tmp->max)

	if empty(tmp->max)
		_cRet := Alltrim(_cAbrevFam)+"-"+Alltrim(_cSetor)+"-001"
	endif
	
	if empty(_cAbrevFam)
		Alert("Falta preencher cadastro de abrevia��o na Familia de Bens!")
		_cRet	:= " "
	endif
   //	alert(_cret)
return(_cRet)
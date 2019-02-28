#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT377    矨utor � Andre Almeida          Data 17/05/12    潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Gatilho para Cria玢o do Codigo do bem                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       �                                                            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
		Alert("Falta preencher cadastro de abrevia玢o na Familia de Bens!")
		_cRet	:= " "
	endif
   //	alert(_cret)
return(_cRet)
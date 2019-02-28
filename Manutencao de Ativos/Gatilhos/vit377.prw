#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT377    ³Autor ³ Andre Almeida          Data 17/05/12    ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Gatilho para Criação do Codigo do bem                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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
		Alert("Falta preencher cadastro de abreviação na Familia de Bens!")
		_cRet	:= " "
	endif
   //	alert(_cret)
return(_cRet)
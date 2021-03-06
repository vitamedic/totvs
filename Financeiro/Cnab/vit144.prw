/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  砎it144  � Autor � Gardenia Ilany     � Data �  14/08/03     潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Trazer as Notas Referentes as Faturas                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

Function U_Vit144() // U_VIT144()

#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"

Local _vFat := "Notas: "
	Local _mFat := ""
	Local _cBordero := SE1->E1_NUMBOR
	Local _cFatura	:= SE1->E1_NUM


	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf

	_cQry := " "
	//_cQry += "SELECT SE5.E5_FILIAL, SE5.E5_NUMERO, SE5.E5_PARCELA, SE5.E5_DOCUMEN, SE1.E1_NUMBOR, SE1.E1_NUM"
	_cQry += "SELECT DISTINCT(SE5.E5_NUMERO) "
	_cQry += "FROM" + retsqlname("SE5") + " SE5 "
	_cQry += "INNER JOIN " + retsqlname("SE1") + " SE1 ON SE1.E1_FILIAL = '" + xFilial("SE1") + "'
	_cQry += "	AND SE1.D_E_L_E_T_ = ' '"
	_cQry += "	AND SE1.E1_NUMLIQ = SE5.E5_DOCUMEN "
	_cQry += "	AND SE1.E1_CLIENTE = SE5.E5_CLIENTE "
	//_cQry += "	AND SE1.E1_PARCELA = SE5.E5_PARCELA "
	_cQry += "	AND SE1.E1_LOJA = SE5.E5_LOJA "
	_cQry += "	AND SE1.E1_NUMBOR = '" + _cBordero + "'
	_cQry += "	AND SE1.E1_NUM = '" + _cFatura + "'
	_cQry += "WHERE SE5.D_E_L_E_T_ = ' '"
	_cQry += "AND SE5.E5_FILIAL = '" + xFilial("SE5") + "'
	_cQry += "AND SE5.E5_MOTBX = 'LIQ'"
	_cQry += "AND SE5.E5_ORIGEM = 'FINA460'" 

	_cQry := ChangeQuery(_cQry)
	TcQuery _cQry New Alias "TMP"

	dbselectarea("TMP")
	DBGOTOP()
	While !(TMP->(EOF()))    
		_vFat += TMP->E5_NUMERO + "/"
		TMP->(dbSkip())
	Enddo
	_mFat:= substr(_vFat,1,60)
Return _mFat 
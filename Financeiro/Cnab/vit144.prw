/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �Vit144  � Autor � Gardenia Ilany     � Data �  14/08/03     ���
�������������������������������������������������������������������������͹��
���Descricao � Trazer as Notas Referentes as Faturas                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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
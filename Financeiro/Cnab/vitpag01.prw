/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VitPag01  � Autor � Leonir Teodoro     � Data �  10/05/02  潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Fazer Check Horizontal para Cnab Unibanco.                 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

Function U_VitPag01(_cTipo)
Local _cRet

If _cTipo == "CHK"
	_cRet := Right(StrZero(5 * Val(Left(SE2->E2_CODBAR,3)+Space(14)) + Int(SE2->E2_SALDO*100),20),18)
ElseIf _cTipo == "TITULO"
	_cRet := SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + Tabela("17",SE2->E2_TIPO) + SE2->E2_FORNECE + SE2->E2_LOJA
ElseIf _cTipo == "TITULO2"
	_cRet := SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + Tabela("17",SE1->E1_TIPO) 
	
EndIf

Return (_cRet)

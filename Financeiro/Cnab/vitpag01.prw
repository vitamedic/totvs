/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VitPag01  � Autor � Leonir Teodoro     � Data �  10/05/02  ���
�������������������������������������������������������������������������͹��
���Descricao � Fazer Check Horizontal para Cnab Unibanco.                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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

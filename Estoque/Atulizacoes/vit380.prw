/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT380   � Autor � Andr� Almeida Alves   � Data �04/12/2012���
�������������������������������������������������������������������������Ď��
���Descricao � Gatilho para alimetar Situa��o Tribut�ria na NF de Entrada ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#Include 'Protheus.ch'

User Function vit380()
	_cF4Texto := Posicione("SF4",1,xFilial("SF4")+M->D1_TES,"F4_TEXTO")
	
	if Alltrim(_cF4Texto) = "IMPORTACAO"
		_cCalsFis := "1"+sf4->f4_sittrib
	else
		_cCalsFis := subs(sb1->b1_origem,1,1)+sf4->f4_sittrib
	endif
Return(_cCalsFis)
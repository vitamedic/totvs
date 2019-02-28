#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M650BCHOI �Autor  � Microsiga         � Data � 12/12/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � PE -  para montar array com bot�es a serem apresentados na ���
���          � tela de inclus�o                                           ���
�������������������������������������������������������������������������͹��
���Uso       � Vitamedic - Produ��o                                       ���
�������������������������������������������������������������������������ͼ��
���          � Foi adaptado para criar vari�vel que controla a qtd. de    ���
���          � garantir que somente uma OP seja inclu�da por vez, afim de ���
���          � garantir o saldo dos materiais para empenho                ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M650BCHOI()

	Local MV_XESPOP := SuperGetMV("MV_XESPOP", .f., "N") //Trata copia das OP�s na explosao para o Evolutio

	If MV_XESPOP == "S" .and. Type("__nCtrOps") == "U"
		Public __nCtrOps := 0
	EndIf

Return( {} )
#Include "Totvs.ch" 
#include "rwmake.ch" 
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH" 


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MATA410  � Autor �Stephen Noel de M R.�    DATA �06/02/2019���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada verificar se o pre�o lista est� igual ao  ���
���pre�o fabrica                                                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitamedic                                  ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/
User Function Ma440VLD() 

	Local lRet := .T.  
	Local cNum         := SC5->C5_NUM 
	Local tpnota		:= SC5->C5_TIPO

	If tpnota = 'N'  //tipo de venda normal 
		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(xFilial("SC6")+cNum))
		While SC6->(!EOF())
			If SC6->C6_NUM <> cNum
				Exit 
			EndIf
			If SC6->C6_PRCVEN >= SC6->C6_PRUNIT .AND.; 
			SC6->C6_CF $ "5101/5102/6101/6102/6107/6108/6109/6110/7101" //Verifica de CFOP � de venda.
				MSGALERT( "Item: " +SC6->C6_ITEM+" Est� compre�o de venda est� igual ao pre�o lista, favor verificar!" ,;
				 "Nao Libera" )
				lRet := .F.
			EndIf
			SC6->(DbSkip())
		EndDo
	EndIf
Return lRet 
#Include "Totvs.ch" 
#include "rwmake.ch" 
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH" 


/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MATA410  � Autor 砈tephen Noel de M R.�    DATA �06/02/2019潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada verificar se o pre鏾 lista est� igual ao  潮�
北硃re鏾 fabrica                                                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitamedic                                  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
				MSGALERT( "Item: " +SC6->C6_ITEM+" Est� compre鏾 de venda est� igual ao pre鏾 lista, favor verificar!" ,;
				 "Nao Libera" )
				lRet := .F.
			EndIf
			SC6->(DbSkip())
		EndDo
	EndIf
Return lRet 
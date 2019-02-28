#Include "Totvs.ch" 
#include "rwmake.ch" 
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH" 


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATA410  ³ Autor ³Stephen Noel de M R.³    DATA ³06/02/2019³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada verificar se o preço lista está igual ao  ³±±
±±³preço fabrica                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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
			SC6->C6_CF $ "5101/5102/6101/6102/6107/6108/6109/6110/7101" //Verifica de CFOP é de venda.
				MSGALERT( "Item: " +SC6->C6_ITEM+" Está compreço de venda está igual ao preço lista, favor verificar!" ,;
				 "Nao Libera" )
				lRet := .F.
			EndIf
			SC6->(DbSkip())
		EndDo
	EndIf
Return lRet 
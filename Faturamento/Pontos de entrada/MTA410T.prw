#INCLUDE "PROTHEUS.CH"  

#DEFINE CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} MTA410T
	Ponto de entrada para todos os itens do pedido. Liberaçao estoque.
@author Danilo Brito
@since 12/05/2017
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MTA410T()

	Local aArea := GetArea()
	Local aAreaSC9 := SC9->(GetArea())
	
	SC9->(DbSetOrder(1))
	SC9->(DbSeek(xFilial("SC9")+SC5->C5_NUM ))
	While SC9->(!Eof()) .AND. SC9->C9_FILIAL+SC9->C9_PEDIDO == xFilial("SC9")+SC5->C5_NUM
	
		if empty(SC9->C9_NFISCAL) //colocado para entrega parcial de pedidos			
			if !U_SHELFLIFE(SC9->C9_PRODUTO, SC9->C9_LOTECTL, SC9->C9_CLIENTE, SC9->C9_LOJA)
				
				MsgInfo("Pedido: " + SC5->C5_NUM + CRLF + CRLF + ;
						"Validade do item [" + Alltrim(SC9->C9_PRODUTO) + " - " + Alltrim(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_DESC")) +;
						"] no lote [" + alltrim(SC9->C9_LOTECTL) + "] não atende ao Shelf Life informado no cadastro do cliente.","Atenção!")
				
			endif
		endif
		
		SC9->(DbSkip())
	enddo
	
	RestArea(aAreaSC9)
	RestArea(aArea)
	
Return
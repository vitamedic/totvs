#include 'totvs.ch'
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MT410ALT  � Autor� Luiz Fernando Sacramento Data � 19/01/16潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada depois da grava鏰o do pedido de venda     潮�
北�          � 								                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
User Function MT410ALT()
Local lRet             := .T.				// Conteudo de retorno
 
sc9->(dbsetorder(1))   
/*SET DELETED OFF //Desabilita filtro do campo*/
sc9->(dbseek(sc5->c5_filial+sc5->c5_num))
while !sc9->(eof()) .and. sc9->c9_pedido==sc5->c5_num
   //msgalert("o item "+sc9->c9_item+" nao esta deletado")
   if empty(sc9->c9_nfiscal) .and. sc9->c9_pedido==sc5->c5_num
   		RECLOCK("SC9",.F.)
   		DbDelete()
		MsUnLock()
	endif
   sc9->(dbskip())
end


Return(lRet)

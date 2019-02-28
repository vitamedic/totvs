#include 'totvs.ch'
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT410ALT  � Autor� Luiz Fernando Sacramento Data � 19/01/16���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada depois da grava�ao do pedido de venda     ���
���          � 								                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT110GRV � Autor � Alex J�nio de Miranda � Data �21/01/2009���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada para alterar ou validar as informa��es    ���
���          � lan�adas na solicita��o de compras.                        ���
���          � Usado para bloquear as solicita��es.                       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function mt110grv()
local _aArea := GetArea()
                    
if inclui
	dbSelectArea("SC1")
    	reclock("SC1",.F.)
		sc1->c1_aprov := "B" 
/*		sc1->c1_dtlib1:= ctod("  /  /  ")
		sc1->c1_dtlib2:= ctod("  /  /  ")
		sc1->c1_dtlib2:= ctod("  /  /  ")
*/		
	MsUnlock()
elseif altera
	if sc1->c1_pedido=' '
	     dbSelectArea("SC1")
    	      reclock("SC1",.F.)
        	  sc1->c1_aprov := "B"                   
	     MsUnlock()
	endif
endif

RestArea(_aArea)
return(.t.)
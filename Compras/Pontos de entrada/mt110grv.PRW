/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MT110GRV � Autor � Alex J鷑io de Miranda � Data �21/01/2009潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de entrada para alterar ou validar as informa珲es    潮�
北�          � lan鏰das na solicita玢o de compras.                        潮�
北�          � Usado para bloquear as solicita珲es.                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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

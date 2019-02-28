
#include "rwmake.ch"

/*/{Protheus.doc} m410alok
//Ponto de Entrada para Retornar se Sera Permitida a Alteracao do Pedido de Venda.
@author redes
@since 16/06/03
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function m410alok()
Local aArZ52    
Local cMensagem := ""
Local cRotina   := Upper(AllTrim(FunName()))

_lok := .t.	      

if !empty(sc5->c5_tabela) .and. sc5->c5_tabela=="999" 
	_cfilda0:=xfilial("DA0")
	da0->(dbsetorder(1))
	da0->(dbseek(_cfilda0+sc5->c5_tabela))
	if da0->da0_status=="R" .and. empty(sc5->c5_licitac)
		_lok:=.f.
		msginfo("Tabela de precos invalida para alteração! liberada somente para pedidos de Licitações.")
	endif
endif

dbSelectArea("SX2")
dbSetOrder(1)
/*if _lok .and. ( ! cRotina $ "VIT612;VIT600"  .and. SX2->(dbSeek("Z52")) )
	aArZ52 := Z52->(GetArea())
	dbSelectArea("Z52")
	dbSetOrder(1)
	if dbSeek(XFilial("Z52")+sc5->c5_num)
		do while Z52->(!Eof() .and. Z52_PEDIDO == sc5->c5_num)
			if Z52->Z52_STATUS == '3'
				cMensagem := "Pedido com itens separados pelo WMS, solicite interação no painel de expedição..."
				exit
			elseif Z52->Z52_STATUS $ ';1;2;'
					cMensagem := "Pedido com itens em processo de separação no WMS, solicite interação no painel de expedição..."   
					exit
			endif
			
			Z52->(dbSkip())
		enddo
	endif
	RestArea(aArZ52)
	
	if !empty(cMensagem) 
		_lok := .f.
		MsgStop(cMensagem)
	endif
endif
*/	
return(_lok)
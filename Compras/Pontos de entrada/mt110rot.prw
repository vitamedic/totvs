/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MT110ROT � AUTOR � Alex J鷑io de Miranda � DATA �16/03/2009潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de entrada para incluir bot鉶 na tela de Solicita-   潮�
北�          � 珲es de Compras.                                           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function mt110rot()

	//Define Array contendo as Rotinas a executar do programa      
	// ----------- Elementos contidos por dimensao ------------     
	// 1. Nome a aparecer no cabecalho                              
	// 2. Nome da Rotina associada                                  
	// 3. Usado pela rotina                                         
	// 4. Tipo de Transa噭o a ser efetuada                          
	//    1 - Pesquisa e Posiciona em um Banco de Dados             
	//    2 - Simplesmente Mostra os Campos                         
	//    3 - Inclui registros no Bancos de Dados                   
	//    4 - Altera o registro corrente                            
	//    5 - Remove o registro corrente do Banco de Dados          
	//    6 - Altera determinados campos sem incluir novos Regs     
	_aRotinaAux:={}
	_aRotinaAux:=aRotina
	aRotina:={} 
	_j:=0
	
	for _i:=1 to (len(_aRotinaAux)+1)

		if _i==8
			aadd(aRotina, { "Bloq/Lib SC","U_VIT340('SC1',sc1->(recno()),4)" , 0 , 4}) 
		else    
			_j++
			aadd(aRotina, { _aRotinaAux[_j,1], _aRotinaAux[_j,2], _aRotinaAux[_j,3], _aRotinaAux[_j,4]})
		endif
	next

return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT110ROT ³ AUTOR ³ Alex Júnio de Miranda ³ DATA ³16/03/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada para incluir botão na tela de Solicita-   ³±±
±±³          ³ ções de Compras.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function mt110rot()

	//Define Array contendo as Rotinas a executar do programa      
	// ----------- Elementos contidos por dimensao ------------     
	// 1. Nome a aparecer no cabecalho                              
	// 2. Nome da Rotina associada                                  
	// 3. Usado pela rotina                                         
	// 4. Tipo de Transa‡„o a ser efetuada                          
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

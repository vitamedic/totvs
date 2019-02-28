/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT110ROT � AUTOR � Alex J�nio de Miranda � DATA �16/03/2009���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada para incluir bot�o na tela de Solicita-   ���
���          � ��es de Compras.                                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function mt110rot()

	//Define Array contendo as Rotinas a executar do programa      
	// ----------- Elementos contidos por dimensao ------------     
	// 1. Nome a aparecer no cabecalho                              
	// 2. Nome da Rotina associada                                  
	// 3. Usado pela rotina                                         
	// 4. Tipo de Transa��o a ser efetuada                          
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

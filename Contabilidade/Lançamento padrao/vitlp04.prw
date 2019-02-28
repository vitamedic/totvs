/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITLP04  ³ Autor ³ Heraildo C. de Freitas³ Data ³26/04/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa para retornar a conta contabil de credito no      ³±±
±±³          ³ lancamento padronizado 610/01 na saida de notas fiscais    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³ 08/03/04 - Revisao para novo plano de contas               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vitlp04()
_cconta:="INDEFINIDO"
if sf4->f4_tpmov=="8" // REMESSA PARA EMPRESTIMO
   _cconta:=If(Empty(sb1->b1_conta),"Conta Prod Branco",sb1->b1_conta)
elseif sf4->f4_tpmov=="C" // RETORNO DE EMPRESTIMO
   _cconta:=If(Empty(sb1->b1_conta),"Conta Prod Branco",sb1->b1_conta)
elseif sf4->f4_tpmov=="I" // REMESSA PARA INDUSTRIALIZACAO
	_cconta:="2301020522600"         
elseif sf4->f4_tpmov=="J" // RETORNO DE INDUSTRIALIZACAO
	_cconta:="1401010224201"
elseif sf4->f4_tpmov=="A" // REMESSA PARA CONSERTO - diversos
	_cconta:="2301020222323"
elseif sf4->f4_tpmov=="E" // RETORNO DE CONSERTO
	_cconta:="1401010324301"
elseif sf4->f4_tpmov=="K" // REMESSA PARA DEMONSTRACAO
	_cconta:="2301020422523"
elseif sf4->f4_tpmov=="N" // RETORNO DE DEMOSNTRACAO
	_cconta:="1401010524501"
elseif sf4->f4_tpmov=="1" // REMESSA PARA EXPOSICAO
	_cconta:="2301020622700"
elseif sf4->f4_tpmov=="4" // REMESSA PARA CONSERTO - ME/MP
   _cconta:=If(Empty(sb1->b1_conta),"Cta Prod "+sb1->b1_cod,sb1->b1_conta)  
elseif sf4->f4_tpmov="L" // REMESSA DE BEM COMODATO           
	_cconta:="2301020312423"
elseif sf4->f4_tpmov="M" // RETORNO DE BEM COMODATO           
	_cconta:="2301010421523"  //--
elseif sf4->f4_tpmov="F" // DESTRUICAO                        
   _cconta:=If(Empty(sb1->b1_conta),"Cta Prod "+sb1->b1_cod,sb1->b1_conta)  
elseif sf4->f4_tpmov="P" // REMESSA POR CONTA E ORDEM
	_cconta:= If(Empty(sb1->b1_conta),"Cta Prod branco",sb1->b1_conta)     
elseif sf4->f4_tpmov="X"  .and. sf4->f4_estoque == "S" // BONIFICAÇÃO
	_cconta:="1102120212864"
elseif sd2->d2_tipo=="D" // DEVOLUCAO 
	if empty(sb1->b1_conta)
		_cconta:="CONTA PRODUTO BRANCO"
	elseif sf4->f4_estoque=="S" .and.;
		left(sb1->b1_conta,6)<>"110212" .and.;
		sb1->b1_tipo<>"IN"
		_cconta:="ATUALIZA ESTOQUE"
	elseif sf4->f4_estoque=="N" .and.;
		left(sb1->b1_conta,6)=="110212"
		_cconta:="NAO ATUALIZA ESTOQUE"
	else
		_cconta:=sb1->b1_conta
	endif
elseif sf4->f4_duplic=="S"
	if sb1->b1_tipo=="PT"            // VENDA DE IMOBILIZADO
		_cconta:="4105010119102"
	elseif sb1->b1_tipo=="PA"        // VENDA DE PRODUTO ACABADO
		if (left(sb1->b1_categ,1))=="N" .and. sa1->a1_calcsuf<>"S" // LISTA NEGATIVA e NÃO É ZONA FRANCA
		   if sa1->a1_tpemp$"MEF" .and. sa1->a1_est<>"GO"   // É ORGÃO PUBLICO INTERESTADUAL                      
		  		_cconta:="3101010110106"  
		   else 	
 				_cconta:="3101010110101"                                                                                    // e não é orgão publico interestadual
 			endif		
		elseif sa1->a1_tpemp$"MEF" .and. sa1->a1_est<>"GO"  // LISTA POSITIVA É ORGÃO PUBLICO INTERESTADUAL                       
			_cconta:="3101010110107"                                                            
		else                          // LISTA POSITIVA
			_cconta:="3101010110102"                                                            
		endif
	elseif sb1->b1_tipo=="IN"        // SERVICO DE INDUSTRIALIZACAO
		_cconta:="3101010210202"                                                  
	else                             // VENDA DE MATERIAIS
		_cconta:="4105010119103"
	endif
else
   _cconta:=If(Empty(sb1->b1_conta),"Cta Prod ->"+sb1->b1_cod,sb1->b1_conta)
endif
return(_cconta)

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VITLP22  � Autor � Heraildo C. de Freitas� Data �07/11/2003潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Programa para retornar a conta contabil de credito no      潮�
北�          � lancamento padronizado 610/02 na saida de notas fiscais    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矨lteracao � 08/03/04 - Revisao para novo plano de contas               潮�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vitlp22()
_cconta:="INDEFINIDO"
if sd2->d2_tipo=="D" .or. sf4->f4_tpmov=="C" // DEVOLUCAO OU DEVOLUCAO DE EMPRESTIMO
	if empty(sb1->b1_conta)
		_cconta:="CONTA PRODUTO BRANCO"
	elseif sf4->f4_estoque=="S" .and.;
		left(sb1->b1_conta,6)<>"110212"
		_cconta:="ATUALIZA ESTOQUE"
	elseif sf4->f4_estoque=="N" .and.;
		left(sb1->b1_conta,6)=="110212"
		_cconta:="NAO ATUALIZA ESTOQUE"
	else
		_cconta:=sb1->b1_conta
	endif
elseif sf4->f4_tpmov=="F" // REMESSA DE RESIDUOS PARA INCINERACAO
	_cconta:="3501010116104"
elseif sb1->b1_tipo=="IN" // SERVICO DE INDUSTRIALIZACAO
	_cconta:="3101010210202"
else
	_cconta:="3102050112102"
endif
return(_cconta)

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT013   � Autor � Heraildo C. de Freitas� Data �21/01/2002潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Validacao no Codigo do Produto na Digitacao de Pedidos     潮�
北�          � de Venda para Alertar o Usuario Sobre a Digitacao de       潮�
北�          � Produtos Repetidos.                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vit013()
_lok:=.t.
if ! m->c5_tipo$"BD"
	_npproduto:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRODUTO"})
	_npdelete :=len(aheader)+1
	_cprodatu :=m->c6_produto
	for _i:=1 to len(acols)
		if ! acols[_i,_npdelete] .and.;
			_i<>n
			_cproduto:=acols[_i,_npproduto]
			if _cproduto==_cprodatu
				_lok:=msgyesno("Produto ja digitado neste pedido! Confirma a digitacao?")
			endif
		endif
	next
endif
return(_lok)
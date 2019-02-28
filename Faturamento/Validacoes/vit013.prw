/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT013   � Autor � Heraildo C. de Freitas� Data �21/01/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao no Codigo do Produto na Digitacao de Pedidos     ���
���          � de Venda para Alertar o Usuario Sobre a Digitacao de       ���
���          � Produtos Repetidos.                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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
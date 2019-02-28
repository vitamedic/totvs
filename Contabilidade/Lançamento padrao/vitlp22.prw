/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VITLP22  � Autor � Heraildo C. de Freitas� Data �07/11/2003���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa para retornar a conta contabil de credito no      ���
���          � lancamento padronizado 610/02 na saida de notas fiscais    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Alteracao � 08/03/04 - Revisao para novo plano de contas               ���
�������������������������������������������������������������������������Ŀ��
�����������������������������������������������������������������������������
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

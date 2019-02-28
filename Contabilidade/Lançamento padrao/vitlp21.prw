/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VITLP21  � Autor � Heraildo C. de Freitas� Data �07/11/2003���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa para retornar a conta contabil de credito no      ���
���          � lancamento padronizado 650/02 na entrada de notas fiscais  ���
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

user function vitlp21()
_cconta:="INDEFINIDO"
if sd1->d1_tipo=="D" .and.;
		 sf4->f4_duplic=="S" // DEVOLUCAO DE VENDA
	_cconta:="3102050112102"
elseif sb1->b1_tipo=="IN" // SERVICO DE INDUSTRIALIZACAO
	_cconta:="3102050212201"
elseif empty(sb1->b1_conta)
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
return(_cconta)
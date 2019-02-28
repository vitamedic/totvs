/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VITLP03  � Autor � Heraildo C. de Freitas� Data �26/04/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa para retornar a conta contabil de debito no       ���
���          � lancamento padronizado 610/01 na saida de notas fiscais    ���
�������������������������������������������������������������������������Ĵ��
���Alteracao � 08/03/04 - Revisao para novo plano de contas               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vitlp03()
_cconta:="INDEFINIDO"
if sf4->f4_tpmov=="8" // REMESSA PARA EMPRESTIMO
	_cconta:="1102130112901"
elseif sf4->f4_tpmov=="C" // RETORNO DE EMPRESTIMO
	_cconta:="2301010121223"
elseif sf4->f4_tpmov=="I" // REMESSA PARA INDUSTRIALIZACAO
	_cconta:="1401020525501"
elseif sf4->f4_tpmov=="J" // RETORNO DE INDUSTRIALIZACAO
	_cconta:="2301010221323"
elseif sf4->f4_tpmov=="A" // REMESSA PARA CONSERTO
	_cconta:="1401020225201"
elseif sf4->f4_tpmov=="E" // RETORNO DE CONSERTO
	_cconta:="2301010321423"
elseif sf4->f4_tpmov=="K" // REMESSA PARA DEMONSTRACAO
	_cconta:="1401020425401"
elseif sf4->f4_tpmov=="N" // RETORNO DE DEMONSTRACAO
	_cconta:="2301010521623"
elseif sf4->f4_tpmov=="1" // REMESSA PARA EXPOSICAO
	_cconta:="1401020625601"
elseif sf4->f4_tpmov=="4" // REMESSA PARA CONSERTO ME/MP
	_cconta:="1102130314102"
elseif sf4->f4_tpmov="L" // REMESSA DE BEM COMODATO           
	_cconta:="1401020325301"
elseif sf4->f4_tpmov="M" // RETORNO DE BEM COMODATO           
	_cconta:="1401010424401"
elseif sf4->f4_tpmov="X"  .and. sf4->f4_estoque == "S" // BONIFICA��O
	_cconta:="4102020616604"
elseif sf4->f4_tpmov="F" // DESTRUICAO                        
	If sb1->b1_tipo$"MP/EE/EN"
	   _cconta:="3501010116104"
	Else
	   _cconta:="4102029916707"
	Endif
elseif 	sd1->d1_tipo=="P" // REMESSA POR CONTA E ORDEM
 	_cconta:="3401010113101"
elseif sd2->d2_tipo=="D" // DEVOLUCAO
	if sf4->f4_duplic=="S" // DEVOLUCAO DE COMPRA
		if empty(sa2->a2_conta)
			_cconta:="CONTA FORNEC BRANCO"
		else
			_cconta:=sa2->a2_conta
		endif
	endif
elseif sf4->f4_duplic=="S" // GERA DUPLICATA
	if empty(sa1->a1_conta)
		_cconta:="CONTA CLIENTE BRANCO"
	else
		_cconta:=sa1->a1_conta
	endif
endif
return(_cconta)
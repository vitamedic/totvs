/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �VITLP25   �Autor  �Heraildo C. Freitas � Data �  09/12/03   ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna a conta contabil de debito no lancamento           ���
���          � padronizado do CMV                                         ���
�������������������������������������������������������������������������͹��
���Uso       � LP 678/001                                                 ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vitlp25()
_cconta:="INDEF. TES "+sf4->f4_codigo+"-"+sf4->f4_tpmov
if sf4->f4_tpmov=="O" .and.;
	sf4->f4_duplic=="S"
	if sb1->b1_tipo$"PA/PL"
		if left(sb1->b1_categ,1)=="N" // LISTA NEGATIVA
			_cconta:="3401010113101"
		else                          // LISTA POSITIVA
			_cconta:="3401011113301"                                                                   
		endif
	else
		_cconta:="3402010115101"
	endif
elseif sf4->f4_tpmov$"3/V/X" // AMOSTRA GRATIS/DOACAO
	_cconta:="4102020616604"
elseif sf4->f4_tpmov$"U/W"  // BRINDES/REMESSA DE MATERIAL PROMOCIONAL
	_cconta:="4102020616603"
endif
return(_cconta)
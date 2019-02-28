/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  砎ITLP25   矨utor  矵eraildo C. Freitas � Data �  09/12/03   潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna a conta contabil de debito no lancamento           潮�
北�          � padronizado do CMV                                         潮�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北砋so       � LP 678/001                                                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT022   矨utor � Heraildo C. de Freitas  矰ata � 01/02/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Validacao do Produto na Simulacao de Producao, nao         潮�
北�          � Permitindo Simulacao de Produtos em Lancamento             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
#include "rwmake.ch"

user function vit022()
_lok:=.f.
_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))
if ! sb1->(dbseek(_cfilsb1+m->z2_produto))
	_lok:=.f.
	msginfo("O codigo digitado nao esta cadastrado!")
elseif ! sb1->b1_tipo$"PA/PI/PN" //Guilherme 06/06/2016 - Inclus鉶 do tipo PN(NUTRAC蔝TICOS).
	_lok:=.f.
	msginfo("Nao e permitida simulacao de producao para este produto!")
else
	_lok:=existchav("SZ2",m->z2_produto)
endif
return(_lok)

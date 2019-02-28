/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT047   � Autor � Heraildo C. de Freitas    矰ata 02/04/02潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯屯屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Execblock no Parametro MV_AGREG para Atualizar o Campo     潮�
北�          � C9_AGREG na Liberacao de Pedidos de Venda                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
#include "rwmake.ch"

user function vit047()
_nordsb1:=sb1->(indexord())
_nordsc5:=sc5->(indexord())
_nregsb1:=sb1->(recno())
_nregsc5:=sc5->(recno())

_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
sb1->(dbsetorder(1))
sc5->(dbsetorder(1))

sb1->(dbseek(_cfilsb1+sc9->c9_produto))
sc5->(dbseek(_cfilsc5+sc9->c9_pedido))

if sc5->c5_tipocli =="X" .or. sc5->c5_pedint =="S"
	_ccateg:=" "
else
	_ccateg:=if(sc5->c5_percfat==100," ",left(sb1->b1_categ,1))
endif

sb1->(dbsetorder(_nordsb1))
sc5->(dbsetorder(_nordsc5))
sb1->(dbgoto(_nregsb1))
sc5->(dbgoto(_nregsc5))
return(_ccateg)
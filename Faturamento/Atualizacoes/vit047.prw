/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT047   ³ Autor ³ Heraildo C. de Freitas    ³Data 02/04/02³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Execblock no Parametro MV_AGREG para Atualizar o Campo     ³±±
±±³          ³ C9_AGREG na Liberacao de Pedidos de Venda                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT145   � Autor � Heraildo C. de Freitas� Data � 15/08/03 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Validacao na Digitacao do Lote no Lancamento do Inventario 潮�
北�          � para nao Permitir a Digitacao de Lotes Vencidos            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vit145()
_lok:=.t.
_nordsb8:=sb8->(indexord())
_nregsb8:=sb8->(recno())

_cfilsb8:=xfilial("SB8")
sb8->(dbsetorder(3))

sb8->(dbseek(_cfilsb8+m->b7_cod+m->b7_local+m->b7_lotectl))
if sb8->b8_dtvalid<m->b7_data
	_lok:=.f.
	msgstop("Lotes vencidos n鉶 podem ser inventariados!")
endif

sb8->(dbsetorder(_nordsb8))
sb8->(dbgoto(_nregsb8))
return(_lok)

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT139   � Autor � Heraildo C. de Freitas� Data �23/06/2003潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Verifica se o Nivel do Usuario Permite Alteracao da        潮�
北�          � Comissao do Pedido de Vendas                               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vit139()
_lok:=.t.
_cnome :=substr(cusuario,7,15)

psworder(2)

if pswseek(_cnome,.t.)
   _aret:=pswret(3)
   for _i:=1 to len(_aret[1])
	   _cmodulo:=substr(_aret[1,_i],1,2)
   	if _cmodulo=="05" // FATURAMENTO
		   _cnivel:=substr(_aret[1,_i],3,1)
		endif
	next
	if _cnivel<="5"
		_lok:=.f.
	endif
endif
return(_lok)
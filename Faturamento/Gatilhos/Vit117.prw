/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘北
北砅ROGRAMA  � VIT117   � AUTOR � Heraildo C. de Freitas� DATA �08/11/2002潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰ESCRICAO � Gatilho no Codigo do Produto na Digitacao de Pedidos de    潮�
北�          � Venda para Retornar o Tipo de Saida (TES)                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
#include "rwmake.ch"

user function vit117()
_cfilsf4:=xfilial("SF4")
sf4->(dbsetorder(1))
if ! m->c5_tipo$"BD"
	_cfilsa1:=xfilial("SA1")
	_cfilda0:=xfilial("DA0")
	_cfilsb1:=xfilial("SB1")
	sa1->(dbsetorder(1))
	sb1->(dbsetorder(1))
	da0->(dbsetorder(1))
	sa1->(dbseek(_cfilsa1+m->c5_cliente+m->c5_lojacli))
	da0->(dbseek(_cfilda0+m->c5_tabela))					
	sb1->(dbseek(_cfilsb1+m->c6_produto))
	if sb1->b1_categ=="N  " .and. da0->da0_status<>"Z" .and. empty(sa1->a1_codmun)
		_ctes:=sa1->a1_tesneg
	else
		_ctes:=sa1->a1_tespos
	endif
else
	_nptes:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_TES"})
	_ctes :=acols[n,_nptes]
endif
sf4->(dbseek(_cfilsf4+_ctes))
m->c6_clasfis:=""
m->c6_clasfis:=sf4->f4_origem+sf4->f4_sittrib

return(_ctes)
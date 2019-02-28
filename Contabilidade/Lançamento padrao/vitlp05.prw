/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VITLP05  � Autor � Heraildo C. de Freitas� Data � 10/05/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna a Conta Contabil no Lancamento Padronizado de      潮�
北�          � Baixa de Titulos a Receber (520-01)                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vitlp05()
sa1->(dbseek(xFilial("SA1")+se1->e1_cliente+se1->e1_loja))
_cconta:="INDEFINIDO"
if se1->e1_origem=="FINA040 "
	if sed->ed_status=="1"
		if empty(sed->ed_provis)
			if empty(sa1->a1_conta)
				_cconta:="C.CLIENTE BRANCO"
			else
				_cconta:=sa1->a1_conta
			endif
		else
			_cconta:=sed->ed_provis
		endif
	else
		if empty(sed->ed_conta)
			_cconta:="C.RECEITA BRANCO"
		else
			_cconta:=sed->ed_conta
		endif
	endif
else
	if empty(sa1->a1_conta)
		_cconta:="C.CLIENTE BRANCO"
	else
		_cconta:=sa1->a1_conta
	endif
endif
return(_cconta)
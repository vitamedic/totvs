/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VITLP06  � Autor � Heraildo C. de Freitas� Data � 17/05/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna a Conta Contabil no Lancamento Padronizado de Baixa潮�
北�          � de Titulos a Pagar (530-01)                                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vitlp06()
_cconta:="INDEFINIDO"
sed->(dbseek(xfilial("SED")+se2->e2_naturez))
if se2->e2_origem=="FINA050 " .or. empty(se2->e2_origem)
	if sed->ed_status=="1"
		if empty(sed->ed_provis)
			if empty(sa2->a2_conta)
				_cconta:="C.FORN.BRANCO"
			else
				_cconta:=sa2->a2_conta
			endif
		else
			_cconta:=sed->ed_provis
		endif
	else
		if empty(sed->ed_conta)
			_cconta:="C.DESP.BRANCO"
		else
			_cconta:=sed->ed_conta
		endif
	endif
else
	if empty(sa2->a2_conta) 
		if empty(sed->ed_conta)
		   _cconta:="C.FORN.BRANCO"
		else
			_cconta:=sed->ed_conta
		endif
	else
		_cconta:=sa2->a2_conta
	endif
endif
return(_cconta)
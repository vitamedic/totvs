/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VITLP19  � Autor � Heraildo C. de Freitas� Data � 17/05/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna o Valor da Multa no Lancamento Padronizado de      潮�
北�          � Geracao de Cheques (590-04)                                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vitlp19()
_nvalor:=0
if valor==0
	_lok:=.f.
	if se2->e2_origem=="FINA050 " .or. empty(se2->e2_origem)
		if sed->(dbseek(xfilial("SED")+se2->e2_naturez)) .and.;
			sed->ed_status$"13"
			_lok:=.t.
		endif
	else
		_lok:=.t.
	endif
	if _lok
		_nvalor:=se2->e2_multa
	endif
endif
return(_nvalor)
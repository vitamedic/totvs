/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT237   � Autor � Aline B. Pereira      � Data � 05/07/05 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Validacao no Centro de Custo da Requisicao ao Armazem      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vit237()
_cfilszh:=xfilial("SZH")
szh->(dbsetorder(1))
szh->(dbseek(_cfilszh+__cuserid))
_lok:=.f.
while ! szh->(eof()) .and.;
	szh->zh_filial==_cfilszh .and.;
	szh->zh_codusr==__cuserid .and.;
	!_lok
	
	_npos:=len(alltrim(szh->zh_cc))
	if alltrim(szh->zh_cc)==substr(m->cp_cc,1,_npos) .and.;
		szh->zh_tipo$"SA"
		_lok:=.t.
	endif
	szh->(dbskip())
end
if !_lok
	msginfo("Usuario sem autoriza玢o para efetuar requisi玢o deste centro de custo!")
endif
return(_lok)

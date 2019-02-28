/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    � VITQ015   矨utor � Programacao Quality   矰ata � 20/11/07  潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Valida Usuarios para Inclusao de Documentos no Modulo de   潮�
北           � Controle de Documentos Somente por Usuarios da Garantia    潮�
北           � da Qualidade.                                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       �                                                            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
#include "topconn.ch"
#include "rwmake.ch"    

User Function vitq015()

_lok := .f.
_nomeuser := substr(cusuario,7,15)
qaa->(dbsetorder(6))

if qaa->(dbseek(_nomeuser))
	if alltrim(qaa->qaa_cc) $"010128020000/010128020001"
		_lok:=.t.
	elseif (alltrim(qaa->qaa_cc)=='010128020002').and.(alltrim(m->qdh_codtp)=='PROT')
		_lok:=.t.
	else      
		msginfo('O Usuario(a): '+qaa->qaa_nome+', nao tem permissao para incluir documentos do tipo '+m->qdh_codtp)
		m->qdh_codtp:=""
		_lok:=.f.
	endif
endif
return(_lok)
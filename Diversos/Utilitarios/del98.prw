/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � DEL98    � Autor � Heraildo C. de Freitas� Data � 01/02/01 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Exclui as tabelas da empresa 98 no banco de dados          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Generico                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
//teste

#include "rwmake.ch"

user function del98()
if msgyesno("Confirma a exclusao das tabelas da empresa 98?")
	processa({|| _exclui()})
	msginfo("Exclusao completada com sucesso.")
endif
return

static function _exclui()
dbusearea(.t.,,"SX2980","NEW",.t.,.f.)
procregua(new->(lastrec()))
new->(dbgotop())
while ! new->(eof())
	incproc("Processando arquivo "+new->x2_arquivo)
	if tccanopen(new->x2_arquivo)
		tcdelfile(new->x2_arquivo)
	endif
	_cdeleta:='DELETE FROM TOP_FIELD WHERE FIELD_TABLE LIKE "%'+alltrim(new->x2_arquivo)+'%"'
	tcsqlexec(_cdeleta)
	new->(dbskip())
end
new->(dbclosearea())
return

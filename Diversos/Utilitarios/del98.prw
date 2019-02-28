/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DEL98    ³ Autor ³ Heraildo C. de Freitas³ Data ³ 01/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exclui as tabelas da empresa 98 no banco de dados          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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

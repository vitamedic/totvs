/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � Qg005   � Autor �                       � Data �           潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Reordenacao dos Codigos dos Bens do CIAP (SF9)             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       �                                                            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/


#include "rwmake.ch"

user function qg005()
if msgyesno("Confirma reordena玢o dos c骴igos do CIAP?")
	processa({|| _atualiza()})
	msginfo("Reordena玢o finalizada com sucesso!")
endif
return()

static function _atualiza()
_cfilsf9:=xfilial("SF9")

procregua(sf9->(lastrec()))

_ccodigo:="000001"

sf9->(dbsetorder(2))
sf9->(dbseek(_cfilsf9))
while ! sf9->(eof()) .and.;
	sf9->f9_filial==_cfilsf9
	
	incproc("Reordenando... "+dtoc(sf9->f9_dtentne))
	
	sf9->(reclock("SF9",.f.))
	sf9->f9_codigo:=_ccodigo
	sf9->(msunlock())
	
	_ccodigo:=soma1(_ccodigo,6)
	
	sf9->(dbskip())
end
return()
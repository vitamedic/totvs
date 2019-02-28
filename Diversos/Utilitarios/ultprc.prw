/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � ULTPRC  � Autor �                     � Data �             潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Atualiza o ultimo preco dos produtos                       潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/


#include "rwmake.ch"

user function ultprc()
if msgyesno("Confirma atualizacao do ultimo preco?")
	processa({|| _atualiza()})
	msginfo("Atualizacao finalizada com sucesso!")
endif
return

static function _atualiza()
_cfilsb1:=xfilial("SB1")
_cfilsd1:=xfilial("SD1")
_cfilsf4:=xfilial("SF4")
sb1->(dbsetorder(1))
sd1->(dbsetorder(7))
sf4->(dbsetorder(1))

procregua(sd1->(lastrec()))

sd1->(dbgotop())
while ! sd1->(eof())
	incproc()
	if sd1->d1_tipo=="N" .and.;
		sf4->(dbseek(_cfilsf4+sd1->d1_tes)) .and.;
		sf4->f4_uprc=="S" .and.;
		sb1->(dbseek(_cfilsb1+sd1->d1_cod))
		sb1->(reclock("SB1",.f.))
		sb1->b1_uprc:=sd1->d1_vunit
		sb1->(msunlock())
	endif
	sd1->(dbskip())
end
return

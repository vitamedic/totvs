/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ULTPRC  ³ Autor ³                     ³ Data ³             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza o ultimo preco dos produtos                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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

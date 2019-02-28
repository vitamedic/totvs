/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SF2520E  ³ Autor ³ Heraildo C. de Freitas³ Data ³ 25/01/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada na Exclusao de Notas Fiscais de Saida para³±±
±±³          ³ Excluir o Titulo a Pagar Referente a Gnr                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function sf2520e()
_nordsa1:=sa1->(indexord())
_nordsc5:=sc5->(indexord())
_nordsd2:=sd2->(indexord())
_nordse1:=se1->(indexord())
_nordse2:=se2->(indexord())
_nregsa1:=sa1->(recno())
_nregsc5:=sc5->(recno())
_nregsd2:=sd2->(recno())
_nregse1:=se1->(recno())
_nregse2:=se2->(recno())

_cfilsa1:=xfilial("SA1")
_cfilsc5:=xfilial("SC5")
_cfilsd2:=xfilial("SD2")
_cfilse1:=xfilial("SE1")
_cfilse2:=xfilial("SE2")
_cfilsz1:=xfilial("SZ1")
sa1->(dbsetorder(1))
sc5->(dbsetorder(1))
sd2->(dbsetorder(3))
se1->(dbsetorder(1))
se2->(dbsetorder(1))
sz1->(dbsetorder(1))

sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie))
sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
sz1->(dbseek(_cfilsz1+sa1->a1_est))

if sc5->c5_geragnr=="S"
	if se1->(dbseek(_cfilse1+sf2->f2_serie+sf2->f2_doc+"R"+"NF "))
		se1->(reclock("SE1",.f.))
		se1->(dbdelete())
		se1->(msunlock())
		writesx2("SE1")
	endif
	if se2->(dbseek(_cfilse2+sf2->f2_serie+sf2->f2_doc+"R"+"NF "+sz1->z1_fornece+sz1->z1_loja))
		se2->(reclock("SE2",.f.))
		se2->(dbdelete())
		se2->(msunlock())
		writesx2("SE2")
	endif
endif   

sa1->(dbsetorder(_nordsa1))
sc5->(dbsetorder(_nordsc5))
sd2->(dbsetorder(_nordsd2))
se1->(dbsetorder(_nordse1))
se2->(dbsetorder(_nordse2))
sa1->(dbgoto(_nregsa1))
sc5->(dbgoto(_nregsc5))
sd2->(dbgoto(_nregsd2))
se1->(dbgoto(_nregse1))
se2->(dbgoto(_nregse2))
return
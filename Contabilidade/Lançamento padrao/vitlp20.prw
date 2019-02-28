/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITLP20  ³ Autor ³ Heraildo C. de Freitas³ Data ³ 17/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna o Valor do Lancamento Padronizado de NF Saida      ³±±
±±³          ³ (620-01)                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vitlp20()
_nvalor:=0
if sf2->f2_valfat>0 .and.;
	! sf2->f2_tipo$"DB"
	_nordse1:=se1->(indexord())
	_nregse1:=se1->(recno())
	_cfilse1:=xfilial("SE1")
	se1->(dbsetorder(1))            
	if se1->(dbseek(_cfilse1+sf2->f2_serie+sf2->f2_doc+"R"+"NF "+sf2->f2_cliente+sf2->f2_loja))
      IF sf4->(dbseek(xFilial("SF4")+sd2->d2_tes)) .and. SF4->F4_CREDST=="1" .and. SF2->F2_ICMSRET > 0
         _nvalor:=0
		else
		   _nvalor:=se1->e1_valor
		Endif 
	endif
endif
return(_nvalor)
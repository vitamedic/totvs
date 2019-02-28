/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT388   ³Autor ³ André Almeida Alves     ³Data ³ 19/09/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gatilho chamado no campo e4_cond, para alimentar o prazo   ³±±
±±³          ³ medio, foi criado o campo E4_PRZMED para armazenar esta    ³±±
±±³          ³ informação.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include 'Protheus.ch'
#include "rwmake.ch"
#include "tbiconn.ch"
#include "topconn.ch"

User Function vit388(_cCond)
_nPrzMed	:= 0
_nQtdDias	:= 0	
_aCond		:= {}
_cDias		:= ""
_cPosAry	:= 1
		
for _i := 1 to len(_cCond)
	if substr(_cCond,_i,1)<>","
		_cDias	+= substr(_cCond,_i,1)
	endif

	if substr(_cCond,_i+1,1)=="," .or. _i == len(_cCond)
		AADD(_aCond,{_cDias})
		_cDias	:= ""
	endif	
next _i

for _nI := 1 to len(_aCond)
	_nQtdDias += val(_aCond[_nI][1])
next _nI
_nPrzMed	:= _nQtdDias/len(_aCond)
Return(_nPrzMed)
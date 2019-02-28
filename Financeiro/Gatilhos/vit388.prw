/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT388   矨utor � Andr� Almeida Alves     矰ata � 19/09/13 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Gatilho chamado no campo e4_cond, para alimentar o prazo   潮�
北�          � medio, foi criado o campo E4_PRZMED para armazenar esta    潮�
北�          � informa玢o.                                                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
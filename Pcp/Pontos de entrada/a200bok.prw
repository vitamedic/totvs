/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � A200BOK   矨utor � Heraildo C. de Freitas 矰ata � 30/01/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada na Alteracao das Estruturas para          潮�
北�          � Verificar se e Permitida a Alteracao Conforme o Campo      潮�
北�          � B1_ALTESTR do Cadastro de Produtos                         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function a200bok()
if inclui
	return .t.
endif	
_aregs:=paramixb[1]
_ccod :=paramixb[2]
_lok:=.t.
_nordsb1:=sb1->(indexord())
_nregsb1:=sb1->(recno())
_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))
sb1->(dbseek(_cfilsb1+_ccod))      
if sb1->b1_altestr=="N" .or. (sb1->b1_altestr=="S" .and. sb1->b1_valestr < dDatabase)
	_lok:=.f.
	msginfo("Nao e permitida alteracao da estrutura deste produto!")
endif
sb1->(dbsetorder(_nordsb1))
sb1->(dbgoto(_nregsb1))
return(_lok)
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VITLP20  � Autor � Heraildo C. de Freitas� Data � 17/05/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna o Valor do Lancamento Padronizado de NF Saida      潮�
北�          � (620-01)                                                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
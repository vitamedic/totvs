/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT001   矨utor � Heraildo C. de Freitas  矰ata �18/12/2001潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Validacao do Codigo do Cliente / Fornecedor nos Acertos    潮�
北�          � Fiscais                                                    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

// VALIDACAO DO CODIGO
user function vit001a()
if m->f3_cfo<"500  " .and. ! m->f3_tipo$"BD"
	_lok:=existcpo("SA2",m->f3_cliefor+alltrim(m->f3_loja))
else
	_lok:=existcpo("SA1",m->f3_cliefor+alltrim(m->f3_loja))
endif
return(_lok)

// VALIDACAO DA LOJA
user function vit001b()
if m->f3_cfo<"500  " .and. ! m->f3_tipo$"BD"
	_lok:=existcpo("SA2",m->f3_cliefor+m->f3_loja)
else
	_lok:=existcpo("SA1",m->f3_cliefor+m->f3_loja)
endif
return(_lok)
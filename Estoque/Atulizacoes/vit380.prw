/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT380   � Autor � Andr� Almeida Alves   � Data �04/12/2012潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幈�
北矰escricao � Gatilho para alimetar Situa玢o Tribut醨ia na NF de Entrada 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#Include 'Protheus.ch'

User Function vit380()
	_cF4Texto := Posicione("SF4",1,xFilial("SF4")+M->D1_TES,"F4_TEXTO")
	
	if Alltrim(_cF4Texto) = "IMPORTACAO"
		_cCalsFis := "1"+sf4->f4_sittrib
	else
		_cCalsFis := subs(sb1->b1_origem,1,1)+sf4->f4_sittrib
	endif
Return(_cCalsFis)
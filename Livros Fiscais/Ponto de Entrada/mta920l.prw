#INCLUDE "rwmake.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MTA920L   矨utor � Edson Gomes Barbosa 矰ata �  26/11/04   潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Ponto de Entrada para Alteraco do SF3 Colocando na Coluna  潮�
北�          � Obs.                                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � AP6 IDE                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function MTA920L


Private cString := ""

If !"CTR"$SF1->F1_ESPECIE
	Do Case
	   Case "104081"$SD1->D1_cod
	   		cString := "CONSTRUCAO - PORTARIA"
	   Case "104467"$SD1->D1_cod
	   		cString := "CONSTRUCAO - VESTIARIO"
	   Case "104427"$SD1->D1_cod
	   		cString := "CONSTRUCAO - ADM"
	   Case "103565"$SD1->D1_cod
	   		cString := "CONSTRUCAO - PRODUTO ACABADO"
	   Case "103850"$SD1->D1_cod
	   		cString := "CONSTRUCAO - SOLIDOS"
	   Case "104416"$SD1->D1_cod
	   		cString := "CONSTRUCAO - AMP. MANUTENCAO"
	   Case "104281"$SD1->D1_cod
	   		cString := "CONSTRUCAO - SEMI S./LIQUIDOS"
	End Case
Endif
If !Empty(cString)
	SF3->F3_OBSERV:=cString
Endif
Return()
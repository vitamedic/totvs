/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MTSELEOP  矨utor  矨ndr� Almeida Alves    � Data � 06/03/12潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Ponto de Entrada para n鉶 Abilitar a Escolha de Opcional   潮�
北�          � na Digita玢o do Pedido de Vendas.                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"
#include "topconn.ch"

User function MTSELEOP()

Local cRet 	 := ParamIxb[1]  //Conte鷇o a ser colocado no campo _OPC
Local cProd  := ParamIxb[2]  // C骴igo do produto que est� sendo utilizado
Local cProg  := ParamIxb[3]  // Nome do programa que chamou a fun玢o
Local lRet   := .T.

if cProg $ "MATA410"
	lRet := .f.
endif

Return lRet
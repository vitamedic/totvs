/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT285   � Autor 矨lex J鷑io de Miranda  � Data � 06/12/06 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Transfer阯cia do Arquivo de Leitura do Rel骻io de Ponto    潮�
北�          � Eletr鬾ico para o Diret髍io \SYSTEM  para Realiza玢o de    潮�
北�          � Leitura, Apontamento e Marca珲es.                          潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit285()
if msgyesno("Confirma Transferencia do arquivo de leitura do ponto para servidor?")
	
	processa({|| _copyarq()})
	msginfo("Arquivo transferido com sucesso!")
endif
return

static function _copyarq()
//copia um arquivo existente para uma vari醰el para ser criado posteriormente em outro local

_carq:="leitura.txt" 
if file(_carq)       // verifica se o arquivo leitura.txt j� existe
	_lcontinua:=msgbox("O arquivo "+_carq+" ja existe! Sobrepor?","Atencao","YESNO")
	if _lcontinua
		ferase(_carq)  //apaga o arquivo leitura.jpg
	endif
endif
Copy File c:\leitura.txt to leitura.txt //copiar o arquivo de de leitura do drive C: (local) para o diret髍io \system

set device to screen

ms_flush()
return

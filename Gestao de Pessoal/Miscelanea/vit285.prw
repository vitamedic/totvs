/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT285   ³ Autor ³Alex Júnio de Miranda  ³ Data ³ 06/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Transferência do Arquivo de Leitura do Relógio de Ponto    ³±±
±±³          ³ Eletrônico para o Diretório \SYSTEM  para Realização de    ³±±
±±³          ³ Leitura, Apontamento e Marcações.                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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
//copia um arquivo existente para uma variável para ser criado posteriormente em outro local

_carq:="leitura.txt" 
if file(_carq)       // verifica se o arquivo leitura.txt já existe
	_lcontinua:=msgbox("O arquivo "+_carq+" ja existe! Sobrepor?","Atencao","YESNO")
	if _lcontinua
		ferase(_carq)  //apaga o arquivo leitura.jpg
	endif
endif
Copy File c:\leitura.txt to leitura.txt //copiar o arquivo de de leitura do drive C: (local) para o diretório \system

set device to screen

ms_flush()
return

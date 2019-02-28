/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT285   � Autor �Alex J�nio de Miranda  � Data � 06/12/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Transfer�ncia do Arquivo de Leitura do Rel�gio de Ponto    ���
���          � Eletr�nico para o Diret�rio \SYSTEM  para Realiza��o de    ���
���          � Leitura, Apontamento e Marca��es.                          ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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
//copia um arquivo existente para uma vari�vel para ser criado posteriormente em outro local

_carq:="leitura.txt" 
if file(_carq)       // verifica se o arquivo leitura.txt j� existe
	_lcontinua:=msgbox("O arquivo "+_carq+" ja existe! Sobrepor?","Atencao","YESNO")
	if _lcontinua
		ferase(_carq)  //apaga o arquivo leitura.jpg
	endif
endif
Copy File c:\leitura.txt to leitura.txt //copiar o arquivo de de leitura do drive C: (local) para o diret�rio \system

set device to screen

ms_flush()
return

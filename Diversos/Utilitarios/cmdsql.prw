/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    � CMDSQL   � Autor � Heraildo C. de Freitas� Data � 19/04/00 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Executa comando SQL no banco de dados                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Generico                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"
#include "topconn.ch"

user function cmdsql()
_ccomando:=""
@ 000,000 to 300,600 dialog odlg title "Comando SQL no banco de dados"
@ 005,005 say "Comando"
@ 005,035 get _ccomando memo size 260,120
   
@ 130,035 bmpbutton type 01 action _executa()
@ 130,075 bmpbutton type 02 action close(odlg)

activate dialog odlg centered
return

static function _executa()
if ! empty(_ccomando) .and.;
	msgyesno("Confirma execucao do comando SQL no banco de dados?")
	nret:=tcsqlexec(_ccomando)
	if nret<0
		msgstop("Erro na execucao do comando!"+chr(13)+tcsqlerror())
	else
		msgstop("Comando executado com sucesso!")
	endif
end
return

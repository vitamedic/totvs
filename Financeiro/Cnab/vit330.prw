#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT330   � Autor � Alex J鷑io de Miranda � Data �04/11/2008潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna Numero Sequencial de Arquivo para Cnab Caixa       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/


user function vit330(_bco,_ag,_cta)

_cfilsee:=xfilial("SEE")
see->(dbsetorder(1))

see->(dbseek(_cfilsee+_bco+_ag+_cta+'002'))

_numseq:=val(see->ee_ultdsk)
_numseq++


see->(reclock("SEE",.f.))
see->ee_ultdsk:=strzero(_numseq,6)
see->(msunlock())

return(strzero(_numseq,6))
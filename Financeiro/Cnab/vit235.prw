/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � Vit235  � Autor � Gardenia Ilany     � Data �  14/08/03    潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Trazer Total do Border�                                    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

Function U_vit235(_bordero)

#include "rwmake.ch"
#include "topconn.ch"

Local _aarea:= getarea()
Local _saldo 

//msgstop(_bordero)
_cfilse1:=xfilial("SE1")
_cquery:=" SELECT"
_cquery+=" SUM(E1_SALDO) SALDO"
_cquery+=" FROM "
_cquery+=" SE1010 SE1"
_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_NUMBOR='"+_bordero+"'"


_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"

tmp1->(dbgotop())
_saldo:=tmp1->saldo

tmp1->(dbclosearea())
restarea(_aarea)             
Return (strzero(int(_saldo*100),15)                          )

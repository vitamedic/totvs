/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MTA450R  � Autor � Heraildo C. de Freitas    矰ata 05/02/02潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯屯屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Ponto de Entrada na Rejeicao da Liberacao de Credito do    潮�
北�          � Pedido de Venda para Rejeitar Todos os Itens               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
#include "rwmake.ch"

user function mta450r()
_nordsc9:=sc9->(indexord())
_nregsc9:=sc9->(recno())

_cpedido:=sc9->c9_pedido

_cfilsc9:=xfilial("SC9")
sc9->(dbsetorder(1))

sc9->(dbseek(_cfilsc9+_cpedido))
while ! sc9->(eof()) .and.;
		sc9->c9_filial==_cfilsc9 .and.;
		sc9->c9_pedido==_cpedido
	sc9->(reclock("SC9",.f.))
	sc9->c9_blcred:="09"
	sc9->(msunlock())
	sc9->(dbskip())
end
sc9->(dbsetorder(_nordsc9))
sc9->(dbgoto(_nregsc9))
return
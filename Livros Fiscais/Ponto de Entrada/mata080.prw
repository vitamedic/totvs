/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MATA080  矨utor � Heraildo C. de Freitas 矰ata � 29/06/06  潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada na Alteracao de Tipos de Entrada e Saida  潮�
北�          � para Envio de E-Mail com as Alteracoes Feitas              潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
#include "rwmake.ch"

user function mata080()
local ohtml

if sm0->m0_codigo=="01" .and.;
	altera
	
	_aalt:={}
	for _ni:=1 to sf4->(fcount())
		_ccampo:=sf4->(fieldname(_ni))
		_cvar:="M->"+_ccampo
		if valtype(&_cvar)<>"U" .and.;
			&_cvar<>sf4->(fieldget(_ni))
			
			sx3->(dbsetorder(2))
			sx3->(dbseek(_ccampo))
			sxa->(dbsetorder(1))
			if sxa->(dbseek(sx3->x3_arquivo+sx3->x3_folder))
				_cpasta:=sxa->xa_descric
			else
				_cpasta:="Outros"
			endif
			
			aadd(_aalt,{sx3->x3_titulo,_cpasta,sf4->(fieldget(_ni)),&_cvar})
		endif
	next
	
	if len(_aalt)>0
		_cpara:="gti@vitamedic.com.br"
		
		oprocess:=twfprocess():new("000006","Alteracao do cadastro de TES")
		oprocess:newtask("000001","\workflow\alteracao do cadastro de tes.htm" )
		oprocess:csubject:="Vitamedic - alteracao do cadastro de TES: "+alltrim(sf4->f4_codigo)
		oprocess:breturn:=""
		oprocess:cto:=_cpara
		ohtml:=oprocess:ohtml
		
		ohtml:valbyname("CODIGO"   ,sf4->f4_codigo)
		ohtml:valbyname("DESCRICAO",alltrim(sf4->f4_desc))
		ohtml:valbyname("USUARIO"  ,cusername)
		ohtml:valbyname("DATA"     ,dtoc(date()))
		ohtml:valbyname("HORA"     ,time())
		
		for _ni:=1 to len(_aalt)
			aadd((ohtml:valbyname("TB.CAMPO"   )),_aalt[_ni,1])
			aadd((ohtml:valbyname("TB.PASTA"   )),_aalt[_ni,2])
			aadd((ohtml:valbyname("TB.ANTERIOR")),_aalt[_ni,3])
			aadd((ohtml:valbyname("TB.ATUAL"   )),_aalt[_ni,4])
		next
		
		oprocess:start()
		wfsendmail()
	endif
endif
return()

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MATA080  �Autor � Heraildo C. de Freitas �Data � 29/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada na Alteracao de Tipos de Entrada e Saida  ���
���          � para Envio de E-Mail com as Alteracoes Feitas              ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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

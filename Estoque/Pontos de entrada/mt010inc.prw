/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT010INC � Autor � Heraildo C. de Freitas� Data � 29/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada apos a Inclusao do Produto para Envio de  ���
���          � E-Mail para Alguns Dptos. para Verificacao dos Dados       ���
���          � Cadastrais                                                 ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

user function mt010inc()
local ohtml

if sm0->m0_codigo=="01"
	_cpara:="report_custos@vitamedic.ind.br;report_contabilidade@vitamedic.ind.br;report_ti@vitamedic.ind.br"  // Tratar Recebimentos aqui
	
	_outros:=" "

	if (sb1->b1_tipo=="PA" .or. sb1->b1_tipo=="PL" .or. sb1->b1_tipo=="EE" .or.;
		 sb1->b1_tipo=="EN" .or. sb1->b1_tipo=="MP")
		_cpara+=";report_garantia@vitamedic.ind.br;report_desenvolvimento@vitamedic.ind.br"
		_cpara+=";report_cql@vitamedic.ind.br"		

		_outros:='<table border="0" width="892" id="AutoNumber1">'
		_outros+='<tr>'

		if (sb1->b1_tipo=="PA" .or. sb1->b1_tipo=="PL")
			_outros+='<td width="143"><b><font face="Arial" size="2">LISTA:</font></b></td>'

			if alltrim(sb1->b1_categ)=="N"
				_outros+='<td width="739"><font face="Arial" size="2">NEGATIVA</font></td></tr><tr>'
			else
				_outros+='<td width="739"><font face="Arial" size="2">POSITIVA</font></td></tr><tr>'
			endif
		endif

		_outros+='<td width="143"><b><font face="Arial" size="2">NOTA M�NIMA:</font></b></td>'
		_outros+='<td width="739"><font face="Arial" size="2">'+transform(sb1->b1_notamin,"@E 9")+'</font></td></tr>'
		_outros+='<tr><td width="143"><b><font face="Arial" size="2">&nbsp; </font></b></td>'
		_outros+='<td width="739"><font face="Arial" size="2">&nbsp; </font></td>'
		_outros+='</tr></table>'
	elseif (sb1->b1_tipo=="LA")
		_cpara+=";report_cql@vitamedic.ind.br"
	elseif (sb1->b1_tipo=="MA")
		_cpara+=";manutencao@vitamedic.ind.br"
	elseif (sb1->b1_tipo=="MK")
		_cpara+=";report_comercial@vitamedic.ind.br;report_marketing@vitamedic.ind.br"		
	endif

	
	oProcess:=TWFProcess():New("000003","Novo produto cadastrado")
	oProcess:NewTask("000001","\workflow\novo produto cadastrado.htm" )
	oProcess:cSubject:="Vitapan - novo produto cadastrado, codigo:  "+sb1->b1_cod
	oProcess:bReturn:=""
	oProcess:cTo:=_cpara
	oHTML:=oProcess:oHTML
	
	oHTML:ValByName("CODIGO"   ,sb1->b1_cod)
	oHTML:ValByName("DESCRICAO",sb1->b1_desc)
	oHTML:ValByName("TIPO"     ,sb1->b1_tipo)
	oHTML:ValByName("GRUPO"    ,sb1->b1_grupo)
	oHTML:ValByName("ARMAZEM"  ,sb1->b1_locpad)
	oHTML:ValByName("CONTA"    ,sb1->b1_conta)

	if alltrim(sb1->b1_estoque)=="S"
		oHTML:ValByName("ESTOQUE"  ,"SIM")
	else
		oHTML:ValByName("ESTOQUE"  ,"N�O")	
	endif
	
	if sb1->b1_rastro=="L"
		oHTML:ValByName("RASTRO"   ,"LOTE")
	else                                  
		oHTML:ValByName("RASTRO"   ,"N�O UTILIZA")	
	endif

	if sb1->b1_pcobrig=="S"
		oHTML:ValByName("PEDIDO"   ,"SIM")
	else
		oHTML:ValByName("PEDIDO"   ,"N�O")
	endif

	oHTML:ValByName("OUTROS"   ,_outros)
	oHTML:ValByName("USUARIO"  ,cusername)
	oHTML:ValByName("DATA"     ,dtoc(date()))
	oHTML:ValByName("HORA"     ,time())    
			
	oProcess:Start()
	wfsendmail()
endif
return()

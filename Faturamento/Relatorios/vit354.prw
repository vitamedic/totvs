/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT354   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 11/02/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ordem de Separacao Html                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "topconn.ch"
#include "rwmake.ch"

user function vit354()
tamanho  :="P"
titulo   :="ORDEM DE SEPARACAO"
cdesc1   :="Este programa ira emitir a ordem de separacao"
cdesc2   :="em formato html"
cdesc3   :=""
cstring  :="SC9"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT354"
wnrel    :="VIT354"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT354"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)

if nlastkey==27
	set filter to
	return
endif


rptstatus({|| rptdetail()})
return

static function rptdetail()

_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")
_cfilsa4:=xfilial("SA4")
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsc9:=xfilial("SC9")
_cfilsdc:=xfilial("SDC")
_cfilsb1:=xfilial("SB1")
sa1->(dbsetorder(1))
sa3->(dbsetorder(1))
sa4->(dbsetorder(1))
sb1->(dbsetorder(1))
sc5->(dbsetorder(1))
sc9->(dbsetorder(1))  
sdc->(dbsetorder(1))
sb1->(dbsetorder(1))

_carqtmp1:=""
_cindtmp11:=""
_cindtmp12:=""

processa({|| _geratmp()})

tmp1->(dbsetorder(2))

setregua(tmp1->(lastrec()))

_cMsg := ''
_cMsg += '<html>'
_cMsg += '<head>'
_cMsg += '<title>Pr&eacute; Nota</title>'
_cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
_cMsg += '</head>'
_cMsg += '<body>'         

_item:=0


tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	_ccliente:=tmp1->cliente
	_cloja   :=tmp1->loja
	_ctabela :=tmp1->tabela
	_ccateg  :=tmp1->categ
	_apedido :={}
	_nregtmp1:=tmp1->(recno())

	while ! tmp1->(eof()) .and.;
		tmp1->cliente==_ccliente .and.;
		tmp1->loja==_cloja .and.;
		tmp1->tabela==_ctabela .and.;
		tmp1->categ==_ccateg
		_i:=ascan(_apedido,tmp1->pedido)
		if _i==0
			aadd(_apedido,tmp1->pedido)
		endif
		tmp1->(dbskip())
	end
	_apedidos:=asort(_apedido)
	tmp1->(dbgoto(_nregtmp1))            
	
	while ! tmp1->(eof()) .and.;
		tmp1->cliente==_ccliente .and.;
		tmp1->loja==_cloja .and.;
		tmp1->tabela==_ctabela .and.;
		tmp1->categ==_ccateg
		sc5->(dbseek(_cfilsc5+tmp1->pedido))
		sa4->(dbseek(_cfilsa4+sc5->c5_transp))
		sa3->(dbseek(_cfilsa3+sc5->c5_vend1))
		sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))

		if _item > 0

			_cMsg += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
			_cMsg += "<br clear=all style='page-break-before:always'>"
			_cMsg += '</span>'			
			_item := 0
		endif
		
		_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse: collapse">'
		_cMsg += '<tr><td width="175" valign="top">'
		_cMsg += '<table width="175" border="0" cellpadding="0" cellspacing="0">'
		_cMsg += '<tr><td><img align="top" width=129 height=41 src="file:\\10.1.1.24\remote\figuras\logo.jpg"></td></tr></table></td>'
		_cMsg += '<td width="400" valign="top"><p><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font><br />'
		_cMsg += '<font face=arial,verdana size=3><b><center>ORDEM DE SEPARA&Ccedil;&Atilde;O</center></b></font></p></td>'
		
		_ped:=""
		for _i:=1 to len(_apedidos)
			if _i==1
				_ped:=_apedidos[_i]
			else
				_ped+="/"+_apedidos[_i]
			endif
		next                

		_cMsg += '<td width="187" valign="center"><font face=arial,verdana size=2><b><center>Pedido(s) nº '+_ped+' </center></b>'
		_cMsg += '<center>Emiss&atilde;o: '+dtoc(date())+' - '+left(time(),5)+'</center></font></td></tr></table><br />'
		
		_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" style="border-collapse:collapse" bordercolor="#000000">'
		_cMsg += '<tr height="30" valign="bottom">'
		//_cMsg += '	<td colspan="3"><p><font face="Arial, Verdana" size="2"><b>Transportadora: </b>'+sc5->c5_transp+' - '+sa4->a4_nome+'</font></p></td>' //Leandro 21/10/2016
		_cMsg += '	<td colspan="3"><p><font face="Arial, Verdana" size="2"><b>Transportadora:                         </font></p></td>'
		_cMsg += '<tr>'
		_cMsg += '	<td colspan="3"><p><font face="Arial, Verdana" size="2"><b>Vendedor: </b>'+sc5->c5_vend1+' - '+sa3->a3_nome+'</font></p></td>'
		_cMsg += '<tr>'
		_cMsg += '	<td colspan="3"><p><font face="Arial, Verdana" size="2"><b>Cidade/UF: </b>'+alltrim(sa1->a1_mun)+' - '+sa1->a1_est+'</font></p></td>'
		_cMsg += '<tr height="30" valign="bottom">'
		_cMsg += '	<td colspan="2"><p><font face="Arial, Verdana" size="2"><b>Volumes: </b></font></p></td>'
		_cMsg += '	<td width="258"><p><font face="Arial, Verdana" size="2"><b>Data Separa&ccedil;&atilde;o:'
		_cMsg += '    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/</b></font></p></td></tr>'
		_cMsg += '<tr height="30" valign="bottom">'
		_cMsg += '	<td width="256"><p><font face="Arial, Verdana" size="2"><b>Separador: </b></b></font></p></td>'
		_cMsg += '	<td width="256"><p><font face="Arial, Verdana" size="2"><b>Conferente: </b></font></p></td>'
		_cMsg += '	<td width="258"><p><font face="Arial, Verdana" size="2"><b>Respons&aacute;vel:</b></font></p></td></tr>'
		_cMsg += '<tr height="30" valign="middle">'
		_cMsg += '	<td width="256"><p><font face="Arial, Verdana" size="2"><b>Hor&aacute;rio:  </b>______:______&nbsp;&nbsp;&nbsp;______:______</font></p></td>'
		_cMsg += '	<td width="256"><p><font face="Arial, Verdana" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;______:______&nbsp;&nbsp;&nbsp;______:______</font></p></td>'
		_cMsg += '	<td width="258"><p><font face="Arial, Verdana" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;______:______&nbsp;&nbsp;&nbsp;______:______</font></p></td>'
		_cMsg += '</tr></table>'
		_cMsg += '<br />'

		_cMsg += '<table border=1 cellspacing=0 cellpadding=0 width=770 bordercolor="#000000" style="border-collapse:collapse">'
		_cMsg += '<tr height="25">'
		_cMsg += '	<td width="55"><p align="center"><font face="Arial, Verdana" size="1"><b>Endere&ccedil;o</b></font></p></td>'
		_cMsg += '	<td width="45"><p align="center"><font face="Arial, Verdana" size="1"><b>C&oacute;digo</b></font></p></td>'
		_cMsg += '    <td width="220"><p align="center"><font face="Arial, Verdana" size="1"><b>Produto</b></font></p></td>'
		_cMsg += '    <td width="45"><p align="center"><font face="Arial, Verdana" size="1"><b>Lote</b></font></p></td>'
		_cMsg += '    <td width="25"><p align="center"><font face="Arial, Verdana" size="1"><b>UM</b></font></p></td>'
		_cMsg += '    <td width="68"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Total</b></font></p></td>'
		_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Caixas</b></font></p></td>'
		_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>UN/Caixa</b></font></p></td>'
		_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Frac.</b></font></p></td>'
		_cMsg += '    <td width="30"><p align="center"><font face="Arial, Verdana" size="1"><b>Val.</b></font></p></td>'
		_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Sigla</b></font></p></td>'
		_cMsg += '    <td width="60"><p align="center"><font face="Arial, Verdana" size="1"><b>Separa&ccedil;&atilde;o</b></font></p></td>'

		_ntotqtd:=0
		_ntotcx :=0
		_ntotun :=0
		_npesobr :=0
		_npesolq :=0     

		while ! tmp1->(eof()) .and.;
			tmp1->cliente==_ccliente .and.;
			tmp1->loja==_cloja .and.;
			tmp1->tabela==_ctabela .and.;
			tmp1->categ==_ccateg
			_nqtd:=0
			_ncx :=0
			_nun :=0
			sb1->(dbseek(_cfilsb1+tmp1->produto))
			_cproduto:=tmp1->produto
			_clotectl:=tmp1->lotectl
			_clocaliz:=tmp1->localiz
			_dtvalid :=substr(dtoc(tmp1->dtvalid),4,2)+"/"+substr(dtoc(tmp1->dtvalid),7,4)

			while ! tmp1->(eof()) .and.;
				tmp1->cliente==_ccliente .and.;
				tmp1->loja==_cloja .and.;
				tmp1->tabela==_ctabela .and.;
				tmp1->categ==_ccateg .and.;
				tmp1->produto==_cproduto .and.;
				tmp1->lotectl==_clotectl .and.;
				tmp1->localiz==_clocaliz
				_nqtd+=tmp1->qtdlib
				tmp1->(dbskip())
			end

			if _item>35
				//Quebra página          
				_cMsg += '</table>'
				_cMsg += '<br />'
				
				_cMsg += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
				_cMsg += "<br clear=all style='page-break-before:always'>"
				_cMsg += '</span>'			
				_item := 0
					
				_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse: collapse">'
				_cMsg += '<tr><td width="175" valign="top">'
				_cMsg += '<table width="175" border="0" cellpadding="0" cellspacing="0">'
				_cMsg += '<tr><td><img align="top" width=129 height=41 src="file:\\srv-gti-24\remote\figuras\logo.jpg"></td></tr></table></td>'
				_cMsg += '<td width="400" valign="top"><p><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font><br />'
				_cMsg += '<font face=arial,verdana size=3><b><center>ORDEM DE SEPARA&Ccedil;&Atilde;O</center></b></font></p></td>'
				
				_ped:=""
				for _i:=1 to len(_apedidos)
					if _i==1
						_ped:=_apedidos[_i]
					else
						_ped+="/"+_apedidos[_i]
					endif
				next                
		
				_cMsg += '<td width="187" valign="center"><font face=arial,verdana size=2><b><center>Pedido(s) nº '+_ped+' </center></b>
				_cMsg += '<center>Emiss&atilde;o: '+dtoc(date())+' - '+left(time(),5)+'</center></font></td></tr></table><br />                
				
				_cMsg += '<table border=1 cellspacing=0 cellpadding=0 width=770 bordercolor="#000000" style="border-collapse:collapse">'
				_cMsg += '<tr height="25">'
				_cMsg += '	<td width="60"><p align="center"><font face="Arial, Verdana" size="1"><b>Endere&ccedil;o</b></font></p></td>'
				_cMsg += '	<td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>C&oacute;digo</b></font></p></td>'
				_cMsg += '    <td width="220"><p align="center"><font face="Arial, Verdana" size="1"><b>Produto</b></font></p></td>'
				_cMsg += '    <td width="45"><p align="center"><font face="Arial, Verdana" size="1"><b>Lote</b></font></p></td>'
				_cMsg += '    <td width="25"><p align="center"><font face="Arial, Verdana" size="1"><b>UM</b></font></p></td>'
				_cMsg += '    <td width="68"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Total</b></font></p></td>'
				_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Caixas</b></font></p></td>'
				_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>UN/Caixa</b></font></p></td>'
				_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Frac.</b></font></p></td>'
				_cMsg += '    <td width="30"><p align="center"><font face="Arial, Verdana" size="1"><b>Val.</b></font></p></td>'
				_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Sigla</b></font></p></td>'
				_cMsg += '    <td width="60"><p align="center"><font face="Arial, Verdana" size="1"><b>Separa&ccedil;&atilde;o</b></font></p></td>'
								
			endif

			if !empty(sb1->b1_cxpad) .or. (sb1->b1_cxpad > 0)
				_ncx+=int(_nqtd/sb1->b1_cxpad)
				_nun+=_nqtd%sb1->b1_cxpad
			else
				_ncx+=_nqtd
				_nun+=0
			endif

			_cMsg += '<tr height="20">'
			_cMsg += '	<td><p align="center"><font face="Arial, Verdana" size="1">'+left(_clocaliz,10)+'</font></p></td>'
			_cMsg += '	<td><p align="center"><font face="Arial, Verdana" size="1">'+left(_cproduto,6)+'</font></p></td>'
			_cMsg += '    <td><p align="left"><font face="Arial, Verdana" size="1">'+sb1->b1_desc+'</font></p></td>'
			_cMsg += '    <td><p align="center"><font face="Arial, Verdana" size="1">'+_clotectl+'</font></p></td>'
			_cMsg += '    <td><p align="center"><font face="Arial, Verdana" size="1">'+sb1->b1_um+'</font></p></td>'
			_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform((_nqtd),"@E 99,999,999.9999")+'&nbsp;</font></p></td>'
			_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform((_ncx),"@E 999,999")+'&nbsp;</font></p></td>'
			_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform((sb1->b1_cxpad),"@E 999")+'&nbsp;</font></p></td>'
			_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform((_nun),"@E 999,999")+'&nbsp;</font></p></td>'
			_cMsg += '    <td><p align="center"><font face="Arial, Verdana" size="1">'+_dtvalid+'</font></p></td>
			_cMsg += '    <td><p align="center"><font face="Arial, Verdana" size="1">'+sb1->b1_codres+'</font></p></td> 
			_cMsg += '    <td><p align="center"><font face="Arial, Verdana" size="1">&nbsp;</font></p></td>
			_cMsg += '</tr>

			_item++

			_npesobr += _ncx*(sb1->b1_pesbru*sb1->b1_cxpad)      
			_npesolq += _ncx*(sb1->b1_peso*sb1->b1_cxpad)      
			_ntotqtd+=_nqtd
			_ntotcx +=_ncx
			_ntotun +=_nun
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				eject
				lcontinua:=.f.
			endif
		end


		_cMsg += '<tr height="25">'
		_cMsg += '	<td colspan="5"><p align="left"><font face="Arial, Verdana" size="1"> TOTAL </font></p></td>'
		_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform(_ntotqtd,"@E 99,999,999.9999")+'&nbsp;</font></p></td>'
		_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform(_ntotcx,"@E 9,999,999")+'&nbsp;</font></p></td>'
		_cMsg += '    <td colspan="2"><p align="right"><font face="Arial, Verdana" size="1">'+Transform(_ntotun,"@E 9,999,999")+'&nbsp;</font></p></td>'
		_cMsg += '    <td colspan="3"><p align="right"><font face="Arial, Verdana" size="1">&nbsp;</font></p></td>'
		_cMsg += '</tr></table>'
		_cMsg += '<br />'

		/* Mensagens do Pedido */
		_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse:collapse">'
		_cMsg += '<tr>'
		_cMsg += '	<td width=769 valign="top">'
		_cMsg += '      <p><font face="Arial, Verdana" size="1"><b>Mensagens do Pedido</b></font>'
		_cMsg += '        <br />'
		_cMsg += '        <font face="Arial, Verdana" size="1">'+sc5->c5_menped+'</font>'
		_cMsg += '        <br />'
		_cMsg += '        <font face="Arial, Verdana" size="1">&nbsp;</font></p></td></tr></table>'
		_cMsg += '<br />'
		
        /* Totais Peso Bruto, Peso Líquido e Categoria */
		_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse:collapse">'
		_cMsg += '<tr>'
		_cMsg += '	<td width="256" bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="2">PESO BRUTO</font></b></center></td>'
		_cMsg += '    <td width="256" bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="2">PESO L&Iacute;QUIDO</font></b></center></td>'
		_cMsg += '    <td width="256" bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="2">CATEGORIA</font></b></center></td></tr>'
		_cMsg += '<tr height="30">'
		_cMsg += '    <td align="center"><font face="Arial, Verdana" size="2">'+Transform(_npesobr,"@E 999,999.9999")+'</font></td>'
		_cMsg += '    <td align="center"><font face="Arial, Verdana" size="2">'+Transform(_npesolq,"@E 999,999.9999")+'</font></td>'
		_cMsg += '    <td align="center"><font face="Arial, Verdana" size="2">'+if(alltrim(_ccateg)=="N","Negativa",if(empty(alltrim(_ccateg))," - ","Positiva"))+'</font></td></tr></table>'
	end
end                       

//³ ENCERRA O CÓDIGO HTML

_cMsg += '</body>'
_cMsg += '</html>'

//³ cria o arquivo em disco vit273.html e executa-o em seguida
_carquivo:="C:\WINDOWS\TEMP\SEPARACAO.HTML"
nHdl := fCreate(_carquivo)
fWrite(nHdl,_cMsg,Len(_cMsg))
fClose(nHdl)
ExecArq(_carquivo)

set device to screen

_cext=tmp1->(ordbagext())
tmp1->(dbclosearea())
ferase(_carqtmp1+getdbextension())

ferase(_cindtmp11+_cext)
ferase(_cindtmp12+_cext)

ms_flush()
return


static function _geratmp()
procregua(1)

incproc("Selecionando pedidos...")

_aestrut:={}
aadd(_aestrut,{"CLIENTE"  ,"C",06,0})
aadd(_aestrut,{"LOJA"     ,"C",02,0})
aadd(_aestrut,{"TABELA"   ,"C",03,0})
aadd(_aestrut,{"CATEG"    ,"C",01,0})
aadd(_aestrut,{"DESCRICAO","C",40,0})
aadd(_aestrut,{"PRODUTO"  ,"C",15,0})
aadd(_aestrut,{"LOTECTL"  ,"C",10,0})
aadd(_aestrut,{"LOCALIZ"  ,"C",15,0})
aadd(_aestrut,{"PEDIDO"   ,"C",06,0})
aadd(_aestrut,{"QTDLIB"   ,"N",16,6})
aadd(_aestrut,{"DTVALID"   ,"D",06,0})

_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)

_cindtmp11:=criatrab(,.f.)
_cchave :='CLIENTE+LOJA+TABELA+CATEG+DESCRICAO+PRODUTO+LOTECTL+PEDIDO'
tmp1->(indregua("TMP1",_cindtmp11,_cchave,,,"Selecionando registros..."))

_cindtmp12:=criatrab(,.f.)
_cchave  :="CLIENTE+LOJA+TABELA+CATEG+LOCALIZ+DESCRICAO+LOTECTL"
tmp1->(indregua("TMP1",_cindtmp12,_cchave))

tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetindex(_cindtmp12))

tmp1->(dbsetorder(1))

sc9->(dbseek(_cfilsc9+mv_par01,.t.))
while ! sc9->(eof()) .and.;
	sc9->c9_filial==_cfilsc9 .and.;
	sc9->c9_pedido<=mv_par02
	if sc9->c9_datalib>=mv_par03 .and.;
		sc9->c9_datalib<=mv_par04 .and.;
		sc9->c9_cliente>=mv_par05 .and.;
		sc9->c9_loja>=mv_par06 .and.;
		sc9->c9_cliente<=mv_par07 .and.;
		sc9->c9_loja<=mv_par08
		_cpedido:=sc9->c9_pedido
		sc5->(dbseek(_cfilsc5+_cpedido))
		if sc5->c5_tipo=="N"
			_nregsc9:=sc9->(recno())
			_lok:=.t.
			while ! sc9->(eof()) .and.;
				sc9->c9_filial==_cfilsc9 .and.;
				sc9->c9_pedido==_cpedido
				if empty(sc9->c9_nfiscal)
					if ! empty(sc9->c9_blcred) .or. ! empty(sc9->c9_blest)
						_lok:=.f.
					endif
				endif
				sc9->(dbskip())
			end
			if _lok
				sc9->(dbgoto(_nregsc9))
				while ! sc9->(eof()) .and.;
					sc9->c9_filial==_cfilsc9 .and.;
					sc9->c9_pedido==_cpedido
					if empty(sc9->c9_nfiscal) .and.;
						empty(sc9->c9_blcred) .and.;
						empty(sc9->c9_blest)
						
						sb1->(dbseek(_cfilsb1+sc9->c9_produto))

						if sb1->b1_localiz=='S'
	        				_cquery:= "SELECT "
	        				_cquery+= " DC_PRODUTO PRODUTO,"
	        				_cquery+= " DC_LOTECTL LOTECTL,"
	        				_cquery+= " DC_LOCALIZ LOCALIZ,"
	        				_cquery+= " DC_PEDIDO PEDIDO,"
	        				_cquery+= " DC_QUANT QUANT"
	        				_cquery+= " FROM "
	        				_cquery+= retsqlname("SDC")+" SDC"
	        				_cquery+= " WHERE"
//	        				_cquery+= " SDC.D_E_L_E_T_='*'"
	        				_cquery+= " SDC.D_E_L_E_T_=' '"
	        				_cquery+= " AND SDC.DC_PRODUTO='"+sc9->c9_produto+"'"
	        				_cquery+= " AND SDC.DC_PEDIDO='"+sc9->c9_pedido+"'"
	        				_cquery+= " AND SDC.DC_ITEM='"+sc9->c9_item+"'"
	        				_cquery+= " AND SDC.DC_LOTECTL='"+sc9->c9_lotectl+"'"
	        				_cquery+= " AND SDC.DC_QUANT>0"
	        				
							/* incluido para tratamento de diversos empenhos parciais para o mesmo lote num mesmo pedido e faturamento*/
	        				_cquery+= " AND SDC.DC_SEQ='"+sc9->c9_sequen+"'"
	        				_cquery+= " ORDER BY DC_PEDIDO, DC_PRODUTO, DC_LOTECTL, DC_LOCALIZ"
	
							_cquery:=changequery(_cquery)
		
							tcquery _cquery new alias "TMP3"
	
							tmp3->(dbgotop())
						  
							while ! tmp3->(eof())
								sb1->(dbseek(_cfilsb1+sc9->c9_produto))
								tmp1->(dbappend())
								tmp1->cliente  :=sc9->c9_cliente
								tmp1->loja     :=sc9->c9_loja
								tmp1->tabela   :=sc5->c5_tabela
								tmp1->categ    :=if(sc5->c5_percfat==100," ",left(sb1->b1_categ,1))
								tmp1->descricao:=sb1->b1_desc   
								tmp1->dtvalid  :=sc9->c9_dtvalid
								tmp1->produto  :=sc9->c9_produto
								tmp1->lotectl  :=sc9->c9_lotectl
								tmp1->pedido   :=sc9->c9_pedido
	//							tmp1->qtdlib   :=sc9->c9_qtdlib
								tmp1->qtdlib   :=tmp3->quant
								tmp1->localiz  :=tmp3->localiz
	
								tmp3->(dbskip())
								sc9->(reclock("SC9",.f.))
								sc9->c9_impsep :="S"
								sc9->c9_datasep:=ddatabase
								sc9->c9_horasep:=left(time(),5)
								sc9->c9_ususep :=cusername
								sc9->(msunlock())
		
							end
							tmp3->(dbclosearea())		
						else
							sb1->(dbseek(_cfilsb1+sc9->c9_produto))
							tmp1->(dbappend())
							tmp1->cliente  :=sc9->c9_cliente
							tmp1->loja     :=sc9->c9_loja
							tmp1->tabela   :=sc5->c5_tabela
							tmp1->categ    :=if(sc5->c5_percfat==100," ",left(sb1->b1_categ,1))
							tmp1->descricao:=sb1->b1_desc   
							tmp1->dtvalid  :=sc9->c9_dtvalid
							tmp1->produto  :=sc9->c9_produto
							tmp1->lotectl  :=sc9->c9_lotectl
							tmp1->pedido   :=sc9->c9_pedido
							tmp1->qtdlib   :=sc9->c9_qtdlib
							tmp1->localiz  :=""      

							sc9->(reclock("SC9",.f.))
							sc9->c9_impsep :="S"
							sc9->c9_datasep:=ddatabase
							sc9->c9_horasep:=left(time(),5)
							sc9->c9_ususep :=cusername
							sc9->(msunlock())					
						endif                
						
					endif
					sc9->(dbskip())
				end
			endif
		else
			sc9->(dbskip())
		endif
	else
		sc9->(dbskip())
	endif
end
return

//***********************************************************************
Static Function ExecArq(_carquivo)
//***********************************************************************
LOCAL cDrive     := ""
LOCAL cDir       := ""
LOCAL cPathFile  := ""
LOCAL cCompl     := ""
LOCAL nRet       := 0

//³ Retira a ultima barra invertida ( se houver )
cPathFile := _carquivo

SplitPath(cPathFile, @cDrive, @cDir )
cDir := Alltrim(cDrive) + Alltrim(cDir)

//³ Faz a chamada do aplicativo associado                                  ³
nRet := ShellExecute( "Open", cPathFile,"",cDir, 1)

If nRet <= 32
	cCompl := ""
	If nRet == 31
		cCompl := " Nao existe aplicativo associado a este tipo de arquivo!"
	EndIf
	Aviso( "Atencao !", "Nao foi possivel abrir o objeto '" + AllTrim(cPathFile) + "'!" + cCompl, { "Ok" }, 2 )
EndIf

Return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do pedido          ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o pedido       ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da data            ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a data         ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do cliente         ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"06","Da loja            ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Ate o cliente      ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"08","Ate a loja         ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,04]
		sx1->x1_tipo   :=_agrpsx1[_i,05]
		sx1->x1_tamanho:=_agrpsx1[_i,06]
		sx1->x1_decimal:=_agrpsx1[_i,07]
		sx1->x1_presel :=_agrpsx1[_i,08]
		sx1->x1_gsc    :=_agrpsx1[_i,09]
		sx1->x1_valid  :=_agrpsx1[_i,10]
		sx1->x1_var01  :=_agrpsx1[_i,11]
		sx1->x1_def01  :=_agrpsx1[_i,12]
		sx1->x1_cnt01  :=_agrpsx1[_i,13]
		sx1->x1_var02  :=_agrpsx1[_i,14]
		sx1->x1_def02  :=_agrpsx1[_i,15]
		sx1->x1_cnt02  :=_agrpsx1[_i,16]
		sx1->x1_var03  :=_agrpsx1[_i,17]
		sx1->x1_def03  :=_agrpsx1[_i,18]
		sx1->x1_cnt03  :=_agrpsx1[_i,19]
		sx1->x1_var04  :=_agrpsx1[_i,20]
		sx1->x1_def04  :=_agrpsx1[_i,21]
		sx1->x1_cnt04  :=_agrpsx1[_i,22]
		sx1->x1_var05  :=_agrpsx1[_i,23]
		sx1->x1_def05  :=_agrpsx1[_i,24]
		sx1->x1_cnt05  :=_agrpsx1[_i,25]
		sx1->x1_f3     :=_agrpsx1[_i,26]
		sx1->(msunlock())
	endif
next
return

/*
<html>
<head>
<title>Pr&eacute; Nota</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse: collapse">
<tr><td width="175" valign="top">
<table width="175" border="0" cellpadding="0" cellspacing="0">
<tr><td><img align="top" width=129 height=41 src="file:\\192.168.1.20\remote\figuras\logo.jpg"></td></tr></table></td>
<td width="400" valign="top"><p><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font><br />
<font face=arial,verdana size=3><b><center>ORDEM DE SEPARA&Ccedil;&Atilde;O</center></b></font></p></td>
<td width="187" valign="center"><font face=arial,verdana size=2><b><center>Pedido nº 40913 </center></b>
<center>Emiss&atilde;o: 11/02/10 - 11:25</center></font></td></tr></table><br />
<table border="1" cellspacing="0" cellpadding="0" width="770" style="border-collapse:collapse" bordercolor="#000000">
<tr>
	<td colspan="3"><p><font face="Arial, Verdana" size="2"><b>Transportadora: </b>000010 - INATIVA - REAL ENCOMENDAS E CARGAS LTDA</font></p></td>
<tr>
	<td colspan="3"><p><font face="Arial, Verdana" size="2"><b>Vendedor: </b>000065 - FLAMARLOY-REPRESENTACOES LTDA</font></p></td>
<tr>
	<td colspan="3"><p><font face="Arial, Verdana" size="2"><b>Cidade/UF: </b>GOVERNADOR VALADARES - MG</font></p></td>
<tr height="30" valign="bottom">
	<td colspan="2"><p><font face="Arial, Verdana" size="2"><b>Volumes: </b></font></p></td>
	<td width="258"><p><font face="Arial, Verdana" size="2"><b>Data Separa&ccedil;&atilde;o:
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/</b></font></p></td></tr>
<tr height="30" valign="bottom">
	<td width="256"><p><font face="Arial, Verdana" size="2"><b>Separador: </b></b></font></p></td>
	<td width="256"><p><font face="Arial, Verdana" size="2"><b>Conferente: </b></font></p></td>
	<td width="258"><p><font face="Arial, Verdana" size="2"><b>Respons&aacute;vel:</b></font></p></td></tr>
<tr height="30" valign="middle">
	<td width="256"><p><font face="Arial, Verdana" size="2"><b>Hor&aacute;rio:  </b>______:______&nbsp;&nbsp;&nbsp;______:______</font></p></td>
	<td width="256"><p><font face="Arial, Verdana" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;______:______&nbsp;&nbsp;&nbsp;______:______</font></p></td>
	<td width="258"><p><font face="Arial, Verdana" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;______:______&nbsp;&nbsp;&nbsp;______:______</font></p></td>
</tr></table>
<br />

<table border=1 cellspacing=0 cellpadding=0 width=770 bordercolor="#000000" style="border-collapse:collapse">
<tr height="25">
	<td width="60"><p align="center"><font face="Arial, Verdana" size="1"><b>Endere&ccedil;o</b></font></p></td>
	<td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>C&oacute;digo</b></font></p></td>
    <td width="220"><p align="center"><font face="Arial, Verdana" size="1"><b>Produto</b></font></p></td>
    <td width="53"><p align="center"><font face="Arial, Verdana" size="1"><b>Lote</b></font></p></td>
    <td width="29"><p align="center"><font face="Arial, Verdana" size="1"><b>UM</b></font></p></td>
    <td width="68"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Total</b></font></p></td>
    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Caixas</b></font></p></td>
    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>UN/Caixa</b></font></p></td>
    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Frac.</b></font></p></td>
    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Separa&ccedil;&atilde;o</b></font></p></td>
    <td width="66"><p align="center"><font face="Arial, Verdana" size="1"><b>Confer&ecirc;ncia</b></font></p></td>
<tr height="20">
	<td><p align="center"><font face="Arial, Verdana" size="1">01035</font></p></td>
	<td><p align="center"><font face="Arial, Verdana" size="1">000367</font></p></td>
    <td><p align="left"><font face="Arial, Verdana" size="1">AMLODIL 5MG COM C/ 1X20                 </font></p></td>
    <td><p align="center"><font face="Arial, Verdana" size="1">014223</font></p></td>
    <td><p align="center"><font face="Arial, Verdana" size="1">CX</font></p></td>
    <td><p align="right"><font face="Arial, Verdana" size="1">99.999.999,99</font></p></td>
    <td><p align="right"><font face="Arial, Verdana" size="1">999.999</font></p></td>
    <td><p align="right"><font face="Arial, Verdana" size="1">999</font></p></td>
    <td><p align="right"><font face="Arial, Verdana" size="1">999.999</font></p></td>
    <td><p align="center"><font face="Arial, Verdana" size="1">&nbsp;</font></p></td>
    <td><p align="center"><font face="Arial, Verdana" size="1">&nbsp;</font></p></td>
</tr>
<tr height="25">
	<td colspan="5"><p align="left"><font face="Arial, Verdana" size="1"> TOTAL </font></p></td>
    <td><p align="right"><font face="Arial, Verdana" size="1">99.999.999,99</font></p></td>
    <td><p align="right"><font face="Arial, Verdana" size="1">9.999.999</font></p></td>
    <td colspan="2"><p align="right"><font face="Arial, Verdana" size="1">9.999.999</font></p></td>
    <td colspan="2"><p align="right"><font face="Arial, Verdana" size="1">&nbsp;</font></p></td>
</tr></table>
<br />
<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse:collapse">
<tr>
	<td width=769 valign="top">
    	<p><font face="Arial, Verdana" size="1">&nbsp;</font>
        <br />
        <b><font face="Arial, Verdana" size="1">Mensagens do Pedido</font></b>
        <br />
        <font face="Arial, Verdana" size="1">PAGTO 7 DIAS. ** PODE FAT PEND ANTERIOR</font>
        <br />
        <font face="Arial, Verdana" size="1">&nbsp;</font></p></td></tr></table>
<br />
<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse:collapse">
<tr>
	<td width="256" bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="2">PESO BRUTO</font></b></center></td>
    <td width="256" bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="2">PESO L&Iacute;QUIDO</font></b></center></td>
    <td width="256" bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="2">CATEGORIA</font></b></center></td></tr>
<tr height="30">
    <td align="center"><font face="Arial, Verdana" size="2">72,13</font></td>
    <td align="center"><font face="Arial, Verdana" size="2">66,40</font></td>
    <td align="center"><font face="Arial, Verdana" size="2">Negativa</font></td></tr></table>
<!-- Quebra de página
<span style='font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'>
-->
</body>
</html>
*/

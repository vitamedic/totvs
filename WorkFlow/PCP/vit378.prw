/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT378   ³ Autor ³ André Almeida Alves   ³ Data ³ 26/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Workflow Avisar Diariamente sobre os Lotes que Vencerao em ³±±
±±³          ³ 30 dias.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#INCLUDE "protheus.ch"

user function vit378()
prepare environment empresa "01" filial "01" tables "SB8"

_dDataAtu	:= date()
_dDataLim	:= date()+GETMV("MV_VENCLOT")
                                            
_cde		:= "Vencimento de Lotes"
_cconta   	:=getmv("MV_WFACC")
_csenha   	:=getmv("MV_WFPASSW") 
_cpara		:= "controle@vitamedic.ind.br; controle2@vitamedic.ind.br; fisicoquimico@vitamedic.ind.br"
_ccc		:= " "
_ccco		:= "a.almeida@vitamedic.ind.br"
_lavisa		:= .t.
_cassunto	:= "Lotes que vencerão nos proximos 30 dias "
_cmensagem	:= "O relatório esta em anexo! "
_carq		:=	"lotesvenc.htm"
_cdirdocs	:=	msdocpath()   //M:\protheus_data\dirdoc\co01\shared
_canexos	:= 	_cdirdocs+"\"+_carq
ferase(_cdirdocs+"\"+_carq)

IF(SELECT("TMP") > 0)
	TMP->(DBCLOSEAREA())
ENDIF

cQuery 	:= " SELECT * FROM "
cQuery	+= retsqlname("SB8")+" SB8"
cQuery 	+= " WHERE sb8.d_e_l_e_t_ = ' '"
cQuery 	+= " AND b8_dtvalid between '"+dtos(_dDataAtu)+"' and '"+dtos(_dDataLim)+"'"
cQuery 	+= " AND b8_saldo > 0 "

cQuery:=changequery(cQuery)
MEMOWRIT("\sql\vit378.sql",cQuery)
TCQUERY cQuery NEW ALIAS "TMP"
u_setfield("TMP")

tmp->(dbgotop())
//*************************************** Cria cabeçalho principal **********************************************************************                                 
_nhandle:=fcreate(_cdirdocs+"\"+_carq,0)
fwrite(_nhandle,'<html>'+chr(13)+chr(10))
fwrite(_nhandle,'<head>'+chr(13)+chr(10))
fwrite(_nhandle,'<meta http-equiv="Content-Language" content="pt-br">'+chr(13)+chr(10))
fwrite(_nhandle,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'+chr(13)+chr(10))
fwrite(_nhandle,'<title>Relatorios de Lotes a vencer</title>'+chr(13)+chr(10))
fwrite(_nhandle,'</head>'+chr(13)+chr(10))
fwrite(_nhandle,'<body>'+chr(13)+chr(10))

fwrite(_nhandle,'<table border="1" width="100%" id="table1" style="border-collapse: collapse" bordercolor="#FFFFFF">'+chr(13)+chr(10))
fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
fwrite(_nhandle,'<td width="260"><p style="margin-top: 0; margin-bottom: 0"><img height="54" src="http://www.vitamedic.ind.br/wp-content/uploads/2016/03/logo.png" width="217"></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">Relação de Lotes a Vencer nos proximos 30 dias -> Hoje: '+dtoc(date())+' '+time()+'</font></b></p>'+chr(13)+chr(10))
fwrite(_nhandle,'</td>'+chr(13)+chr(10))
fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
fwrite(_nhandle,'</table>'+chr(13)+chr(10))


fwrite(_nhandle,'<p align="center" style="margin-top: 0; margin-bottom: 0">&nbsp;</p>'+chr(13)+chr(10))
fwrite(_nhandle,'<p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">Os lotes abaixo vencerão nos proximos 30 dias.</font></b></p>'+chr(13)+chr(10))
fwrite(_nhandle,'<table border="1" width="100%" id="table1" style="border-collapse: collapse" bordercolor="#FFFFFF">'+chr(13)+chr(10))
fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">PRODUTO</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">ARMAZEM</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">SALDO</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">EMPENHO</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">LOTE</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">DATA VENCIMENTO</font></b></td>'+chr(13)+chr(10))
fwrite(_nhandle,'</tr>'+chr(13)+chr(10))	

//*************************************** Alimenta corpo do grid **********************************************************************                                 

while !tmp->(eof())   // Percorre o select feito na tabela sb8          
    
    _dDataValid	:= dtoc(tmp->b8_dtvalid)
    _vSaldo		:= tmp->b8_saldo
    _vEmpenho	:= tmp->b8_empenho
    
	fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+Alltrim(tmp->b8_produto)+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+Alltrim(tmp->b8_local)+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_vSaldo,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_vEmpenho,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+alltrim(tmp->b8_lotectl)+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+_dDataValid+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
	
	tmp->(dbskip())
end

fwrite(_nhandle,'</body>'+chr(13)+chr(10))
fwrite(_nhandle,'</html>'+chr(13)+chr(10))
fclose(_nhandle)

u_maillt(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)
tmp->(dbclosearea())

reset environment
return()                

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MAILVEND  ³Autor ³ André Almeida Alves    ³Data ³ 28/05/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia E-Mail                                                ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Funcao para Criar o Cabecalho                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
user function maillt(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)
_cserver:=getmv("MV_WFSMTP")

_lconectou:=.f.
_lenviado :=.f.
_ldesconec:=.f.

connect smtp server _cserver account _cconta password _csenha result _lconectou

if _lconectou
	send mail from _cde to _cpara subject _cassunto body _cmensagem attachment _canexos result _lenviado
	if !_lenviado 
		_cerro:=""
		get mail error _cerro
		msginfo(_cerro)
	endif
	disconnect smtp server result _ldesconec
else
	msginfo("Problemas na conexao com servidor de E-Mail - "+_cserver)
endif
return()
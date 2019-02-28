/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT371   ³ Autor: André Almeida Alves     ³ Data: 27/02/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio Envio Títulos a Receber Representantes / Gerentes ±±
±±³  		  ³ Execução via JOB                                            ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "Ap5Mail.ch"
#include "tbicode.ch"
#include "dialog.ch"
#INCLUDE "protheus.ch"


user function vit371()
	
//	prepare environment empresa "01" filial "01" tables "SA3","WF1"
	
	mv_par01:=" "
	mv_par02:="zzz"
	mv_par03:=(ddatabase-360)
	mv_par04:=(ddatabase+360)
	mv_par05:="    "
	mv_par06:="zzzz" 

	_VlTitT	:= 0
	_VlrPagoT	:= 0
	_PgTituloT	:= 0
	_PgJurosT	:= 0
	_VlrDescT	:= 0
	_VlrRecebT	:= 0

	_cEmail	:= " "
	_cde		:= "Envio de E-mail"
	_cconta	:= getmv("MV_WFMAIL")
	_csenha	:= getmv("MV_WFPASSW")
	_cde		:= _cconta                                   //Incluido por Guilherme Teodoro - 29/04/2015
	_cpara		:= " "
	_ccc		:= "report@vitamedic.ind.br;k.pinheiro@vitamedic.ind.br"
	_ccco		:= " "                         
//	_cassunto	:= "Envio relatorio Finaceiro X Vendedor"    //comentado
//	_cmensagem	:= "Mensagem para teste -> "+_cEmail         //comentado
	_lavisa		:= .t.
//	_canexos 	:= _cdirdocs+"\"+_carq

	
	_cdirdocs:=msdocpath()
	
	IF(SELECT("TMP1") > 0)
		TMP1->(DBCLOSEAREA())
	ENDIF
	
		
	cquery:=" SELECT * FROM "
	cquery+=  retsqlname("SA3")+" SA3"
	cquery+="  WHERE D_E_L_E_T_=' '"
	cquery+="  AND A3_FILIAL='"+xfilial("SA3")+"'"
	cquery+="  AND A3_ATIVO = 'S'"
	cquery+="  order by a3_geren, a3_super"
		
	MemoWrite("/sql/vit146_sa3.sql",cquery)
	tcquery cquery new alias "TMP1"

	while !tmp1->(eof())   // Percorre tabela com o cadastro dos vendedores

//*************************************** Cria cabeçalho principal **********************************************************************                                 
		_cEmail		:=  alltrim(tmp1->a3_email)
		if empty(_cEmail)
			_cPara		:= "report@vitamedic.ind.br"
		else
			_cpara		:= _cEmail
		endif
		
		_cassunto	:= "Posição Contas a Receber - Vendedor -> "+Alltrim(tmp1->a3_nome)
		_cmensagem	:= "O relatório esta em anexo! enviado para o e-mail: "+_cEmail

		_carq		:=	"titulovenc"+alltrim(tmp1->a3_cod)+".htm"
		_cdirdocs	:=	msdocpath()   //M:\protheus_data\dirdoc\co01\shared
		_canexos	:= 	_cdirdocs+"\"+_carq

		if file(_cdirdocs+"\"+_carq)
			ferase(_cdirdocs+"\"+_carq)
		endif
		_nhandle:=fcreate(_cdirdocs+"\"+_carq,0)
		fwrite(_nhandle,'<html>'+chr(13)+chr(10))
		fwrite(_nhandle,'<head>'+chr(13)+chr(10))
		fwrite(_nhandle,'<meta http-equiv="Content-Language" content="pt-br">'+chr(13)+chr(10))
		fwrite(_nhandle,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'+chr(13)+chr(10))
		fwrite(_nhandle,'<title>Relatorios de Titulos Vencidos X Vendedor</title>'+chr(13)+chr(10))
		fwrite(_nhandle,'</head>'+chr(13)+chr(10))
		fwrite(_nhandle,'<body>'+chr(13)+chr(10))
		
		fwrite(_nhandle,'<table border="1" width="100%" id="table1" style="border-collapse: collapse" bordercolor="#FFFFFF">'+chr(13)+chr(10))
		fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
		fwrite(_nhandle,'<td width="260"><p style="margin-top: 0; margin-bottom: 0"><img height="54" src="http://www.vitamedic.ind.br/wp-content/uploads/2016/03/logo.png" width="217"></td>'+chr(13)+chr(10))
		fwrite(_nhandle,'<td align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">Relação de Títulos a Receber - '+dtoc(date())+' '+time()+'</font></b></p>'+chr(13)+chr(10))
		fwrite(_nhandle,'</td>'+chr(13)+chr(10))
		fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
		fwrite(_nhandle,'</table>'+chr(13)+chr(10))
	                                                               
//****************************************************************************************************************************************	
		
		
		IF(SELECT("TMP2") > 0)
			TMP2->(DBCLOSEAREA())
		ENDIF

		_cquery:=" SELECT * "
		_cquery+=" FROM "
		_cquery+=" "+RetSqlName("SA1")+" SA1,"
		_cquery+=" "+RetSqlName("SA3")+" SA3,"
		_cquery+=" "+RetSqlName("SE1")+" SE1"
		_cquery+=" WHERE"
		_cquery+="     SA1.D_E_L_E_T_ =' ' AND SA3.D_E_L_E_T_ =' ' AND SE1.D_E_L_E_T_ =' '"
		_cquery+=" AND A1_FILIAL='"+xfilial("SA1")+"'"
		_cquery+=" AND A3_FILIAL='"+xfilial("SA3")+"'"
		_cquery+=" AND E1_FILIAL='"+xfilial("SE1")+"'"
		_cQuery+=" AND E1_CLIENTE = A1_COD"
		_cQuery+=" AND E1_LOJA = A1_LOJA"
		_cQuery+=" AND E1_VEND1 = A3_COD"
		_cQuery+=" AND E1_SALDO    <> 0"
		_cQuery+=" AND E1_TIPO NOT IN ('RA ','AB-','NCC')"
		_cQuery+= " AND E1_VENCREA BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
		if tmp1->a3_geren = ' '
			_cQuery+= " AND E1_VEND1 BETWEEN ' ' AND 'zzzzzz'"
			_tipo := '1' // Tipo do relatorio 1 = Diretoria
		elseif tmp1->a3_geren <> ' ' .and. tmp1->a3_super = ' '
			_cQuery+= " AND E1_VEND1 IN (SELECT A3_COD FROM SA3010 WHERE D_E_L_E_T_ = ' ' AND A3_ATIVO = 'S' AND A3_SUPER = '"+tmp1->a3_cod+"')"
			_tipo := '2' // Tipo do relatorio 2 = Gerencia			
		else
			_cQuery+= " AND E1_VEND1 = '"+tmp1->a3_cod+"'"
			_tipo := '3' // Tipo do relatorio 3 = Vendedores
		endif
		_cquery+= " AND A3_EMAIL <> '"+space(30)+"'"
		_cQuery+= " ORDER BY E1_VEND1, A1_NOME, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"

		_cquery:=changequery(_cquery)      
		u_setfield("TMP2")
		memowrit("/sql/vit146_se1.sql",_cquery)
		tcquery _cquery new alias "TMP2"

		sa3->(dbsetorder(1))
		_NomeVend  := POSICIONE("SA3",1,xFILIAL("SA3")+tmp2->e1_vend1,"A3_NOME")
		_NomeSuper := POSICIONE("SA3",1,xFILIAL("SA3")+tmp2->a3_super,"A3_NOME")
		_NomeGeren := POSICIONE("SA3",1,xFILIAL("SA3")+tmp2->a3_geren,"A3_NOME")
	
		tmp2->(dbgotop())
		_NomeCli := tmp2->a1_nome
		_cvend   := tmp2->e1_vend1
		_ccli    := tmp2->a1_cod			
		u_CriaCabec()
	
		while !tmp2->(eof()) 
			_NomeCli := tmp2->a1_nome
			
			if _cvend <> tmp2->e1_vend1 .or. _ccli <> tmp2->a1_cod
				u_totaliza()
			endif
            
			
			_DiasAtraz	:= ddatabase - stod(tmp2->e1_vencrea)
			if _DiasAtraz > 0
				_PgJuros	:= ((tmp2->e1_valor * tmp2->e1_porcjur)/100)*_DiasAtraz
			else
				_PgJuros	:= 0
			endif
			
			_Numero  	:= tmp2->e1_prefixo+"-"+tmp2->e1_num
			_Parcela 	:= tmp2->e1_parcela+"-"+tmp2->e1_tipo
			_Emissao 	:= substr(tmp2->e1_emissao,7,2)+"/"+substr(tmp2->e1_emissao,5,2)+"/"+substr(tmp2->e1_emissao,1,4)
			_Vencimento := substr(tmp2->e1_vencto,7,2)+"/"+substr(tmp2->e1_vencto,5,2)+"/"+substr(tmp2->e1_vencto,1,4)
			_VlTit		:= tmp2->e1_valor
			_Banco		:= tmp2->e1_portado
			_VlrPago	:= tmp2->e1_valor - tmp2->e1_saldo
			_DtBaixa	:= substr(tmp2->e1_baixa,7,2)+"/"+substr(tmp2->e1_baixa,5,2)+"/"+substr(tmp2->e1_baixa,1,4)
			_VlrDesc	:= 0
			_VlrReceb	:= (tmp2->e1_valor + _PgJuros) - _VlrPago

			fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
			fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2" color="#000080">'+_Numero+'</font></td>'+chr(13)+chr(10))
			fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2" color="#000080">'+_Parcela+'</font></td>'+chr(13)+chr(10))
			fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+_Emissao+'</font></td>'+chr(13)+chr(10))
			fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+_Vencimento+'</font></td>'+chr(13)+chr(10))
			fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_VlTit,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
			fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2" color="#000080">'+_Banco+'</font></td>'+chr(13)+chr(10))					
			fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_VlrPago,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
			fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_PgJuros,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
			fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+_DtBaixa+'</font></td>'+chr(13)+chr(10))
    			fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_VlrDesc,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))					
  			fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_VlrReceb,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))					
			fwrite(_nhandle,'</tr>'+chr(13)+chr(10))

			// Totalizadores
			_VlTitT 	+= _VlTit
			_VlrPagoT	+= _VlrPago
			_PgJurosT	+= _PgJuros
			_VlrDescT	+= _VlrDesc
			_VlrRecebT	+= _VlrReceb
			
			_ccli  := tmp2->a1_cod
			_cvend := tmp2->e1_vend1
			tmp2->(dbskip())			
			
		end // final do while nos titulos de cada vendedor
		u_totaliza()
		
		fwrite(_nhandle,'</body>'+chr(13)+chr(10))
		fwrite(_nhandle,'</html>'+chr(13)+chr(10))
		fclose(_nhandle)
		u_envemail(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)
		tmp1->(dbskip())
	end  // final do while do cadastro do vendedor

	tmp1->(dbclosearea())
//	reset environment
	return
return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa: VIT371   ³ Autor: André Almeida Alves     ³ Data: 12/03/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao: Relatorio envio Títulos a receber Representantes / Gerentes ±±
±±³  			Execução via JOB                                           ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±        Fuñção para Criar o cabeçalho                                    ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function CriaCabec()

	fwrite(_nhandle,'<p align="center" style="margin-top: 0; margin-bottom: 0">&nbsp;</p>'+chr(13)+chr(10))
	fwrite(_nhandle,'<p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">****** Vendedor: '+_NomeVend+'</font></b></p>'+chr(13)+chr(10))
	fwrite(_nhandle,'<table border="1" width="100%" id="table1" style="border-collapse: collapse" bordercolor="#FFFFFF">'+chr(13)+chr(10))
	fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">'+alltrim(tmp2->a1_nome)+'</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'</tr>'+chr(13)+chr(10))	
	fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">NUMERO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">PARCELA/TIPO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">EMISSAO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">VENCIMENTO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">VALOR TITULO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">BANCO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">VALOR PAGO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">JUROS</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">DATA BAIXA</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">VALOR DESCONTO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">A RECEBER</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'</tr>'+chr(13)+chr(10))

	_Numero  	:= ""    
	_Parcela 	:= ""
	_Emissao 	:= ""
	_Vencimento := ""
	_VlTit 		:= 0
	_Banco		:= ""
	_VlrPago	:= 0
	_PgJuros	:= 0
	_DtBaixa	:= ""
	_VlrDesc	:= 0
	_VlrReceb	:= 0
	
	_VlTitT 	:= 0
	_VlrPagoT	:= 0
	_PgJurosT	:= 0
	_VlrDescT	:= 0
	_VlrRecebT	:= 0 

return()      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa: VIT371   ³ Autor: André Almeida Alves     ³ Data: 12/03/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao: Relatorio envio Títulos a receber Representantes / Gerentes ±±
±±³  			Execução via JOB                                           ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±        Fuñção para totalizar os valores e zeras as variaveis            ±±
±±        totalizadoras                                                    ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function totaliza()

	fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2" color="#000080">Total</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2" color="#000080">&nbsp;</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">&nbsp;</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">&nbsp;</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_VlTitT,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2" color="#000080">&nbsp;</font></td>'+chr(13)+chr(10))					
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_VlrPagoT,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_PgJurosT,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">&nbsp;</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_VlrDescT,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))					
	fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="right"><font face="Arial" size="2" color="#000080">'+alltrim(transform(_VlrRecebT,"@E 999,999,999.99"))+'</font></td>'+chr(13)+chr(10))					
	fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
	
	_VlTitT		:= 0
	_VlrPagoT	:= 0
	_PgJurosT	:= 0
	_VlrDescT	:= 0
	_VlrRecebT	:= 0 
	
	fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">'+alltrim(tmp2->a1_nome)+'</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'</tr>'+chr(13)+chr(10))	
	fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">NUMERO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">PARCELA/TIPO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">EMISSAO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">VENCIMENTO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">VALOR TITULO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">BANCO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">VALOR PAGO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">JUROS</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">DATA BAIXA</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">VALOR DESCONTO</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">A RECEBER</font></b></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'</tr>'+chr(13)+chr(10))

	_Numero  	:= ""    
	_Parcela 	:= ""
	_Emissao 	:= ""
	_Vencimento := ""
	_VlTit		:= 0
	_Banco		:= ""
	_VlrPago	:= 0
	_PgJuros	:= 0
	_DtBaixa	:= ""
	_VlrDesc	:= 0
	_VlrReceb	:= 0	
return()
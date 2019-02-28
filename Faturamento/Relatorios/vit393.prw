#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "Ap5Mail.ch"
#include "tbicode.ch"
#include "dialog.ch"
#INCLUDE "protheus.ch"


/*/{Protheus.doc} vit393

Relatorio Acompanhamento Venda X Meta

 

@author André Almeida Alves

@since 17/02/2014

@version P11

@description Relatorio Acompanhamento Venda X Meta
 

@param mv_par01, Data, Data Inicial

@param mv_par02, Data, Data Final

@param mv_par03, Caracter, Codigo do Gerente ou Representante

@param mv_par04, Numerico, Define se o parametro anterior fara o filtro por Gerente ou Representante

@param mv_par05, Numerico, Define se mostra representante inativo

@param mv_par06, Numerico, Se marcado como sim envia os relatorios para os representantes no momento de suga geracao 

@return numérico, Área calculada

/*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT393   ³ Autor: André Almeida Alves     ³ Data: 12/02/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio Acompanhamento Venda X Meta.                      ±±
±±³  		  ³                                                             ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function vit393()
	
	_cEmail	:= " "
	_cde		:= "Envio de E-mail"
	_cconta	:= getmv("MV_WFACC")
	_csenha	:= getmv("MV_WFPASSW")
	_cpara		:= " "
	_ccc		:= "a.almeida@vitamedic.ind.br"
	_ccco		:= " "
	_cassunto	:= "Envio relatorio Venda X Meta"
	_cmensagem	:= "Mensagem para teste -> "+_cEmail
	_lavisa		:= .t.
	_canexos 	:= _cdirdocs+"\"+_carq


	cperg:="PERGVIT393"
	_pergsx1()
	pergunte(cperg,.f.)


	_cdirdocs:=msdocpath()
	
	IF(SELECT("TMP1") > 0)
		TMP1->(DBCLOSEAREA())
	ENDIF

	cquery:=" SELECT * FROM "
	cquery+=  retsqlname("SCT")+" SCT"
	cquery+="  WHERE SCT.D_E_L_E_T_=' '"
	cquery+="  AND CT_FILIAL='"+xfilial("SA3")+"'"
	cquery+="  order by CT_"

	cquery:=" 	SELECT"
	cquery+="  	    CT_VEND                   AS COD_VEND,"
	cquery+="  	    RTRIM(A3_NOME)            AS NOME_VEND,"
	cquery+="  	    SA3.A3_SUPER              AS COD_GER,"
	cquery+="  	    RTRIM(SA3.A3_NOMEGER)     AS NOME_GERENTE,"
	cquery+="  	    SB1.B1_DESC               AS DESC_PROD,"
	cquery+="  	    CT_PRODUTO                AS COD_PRODUTO,"
	cquery+="  	    CT_GRUPO                  AS GRP_PRODUTO,"
	cquery+="  	    SUBSTR(SCT.CT_DATA,1,4)   AS ANO_META,"
	cquery+="  	    SUBSTR(SCT.CT_DATA,5,2)   AS MES_META,"
	cquery+="  	    CASE"
	cquery+="  	      WHEN A3_SUPER = '001013' THEN 'vanessa@vitamedic.ind.br'"
	cquery+="  	      WHEN A3_SUPER = '001012' THEN 'marcelo@vitamedic.ind.br'"
	cquery+="  	      WHEN A3_SUPER = '001006' THEN 'santiago@vitamedic.ind.br'"
	cquery+="  	      WHEN A3_SUPER = '001004' THEN 'l.pontes@vitamedic.ind.br'"
	cquery+="  	      ELSE '-'"
	cquery+="  	    END                       AS EMAILGER,"
	cquery+="  	    RTRIM(A3_EMAIL)           AS EMAILVEND,"
	cquery+="  	    CT_QUANT                  AS QTD_META,"
	cquery+="  	    COALESCE(SUM(C6_QTDVEN),0)             AS QTD_VENDA,"
	cquery+="  	    COALESCE(SUM(C6_QTDENT),0)             AS QTD_ENTREGUE"
	cquery+="  	FROM SCT010 SCT"
	cquery+="  	  INNER JOIN SC6010 SC6 ON  SC6.C6_FILIAL = SCT.CT_FILIAL AND SC6.C6_PRODUTO = SCT.CT_PRODUTO AND SC6.D_E_L_E_T_ = ' '"
	if mv_par04 = "1"
		cquery+="  	  INNER JOIN SA3010 SA3 ON  SA3.A3_COD = SCT.CT_VEND AND SA3.A3_SUPER ="+mv_par03+" AND SA3.D_E_L_E_T_ = ' ' "
	else
		cquery+="  	  INNER JOIN SA3010 SA3 ON  SA3.A3_COD = SCT.CT_VEND AND SA3.D_E_L_E_T_ = ' ' "
	endif
	cquery+="  	  INNER JOIN SB1010 SB1 ON  SCT.CT_PRODUTO = SB1.B1_COD AND  SB1.D_E_L_E_T_ = ' '"
	cquery+="  	WHERE "
	cquery+="  	 SCT.D_E_L_E_T_	= ' '"
	cquery+="  	AND SCT.CT_VALOR < 1"
	cquery+="  	AND SCT.CT_DATA >= '20140101'"
	if mv_par04 = "2"
		cquery+="  	AND SCT.CT_VEND BETWEEN '"+mv_par02+"' AND '"+mv_par02+"'"
	endif
	cquery+="  	AND SCT.CT_VEND IN (SELECT SC5.C5_VEND1 FROM SC5010 SC5"
	cquery+="  	                        WHERE SC6.C6_FILIAL  = SC5.C5_FILIAL"
	cquery+="  	                        AND SC6.C6_CLI = SC5.C5_CLIENTE"
	cquery+="  	                        AND SC6.C6_LOJA = SC5.C5_LOJACLI"
	cquery+="  	                        AND SC6.C6_NUM  = SC5.C5_NUM"
	cquery+="  	                        AND SUBSTR(SCT.CT_DATA,1,4) = SUBSTR(SC5.C5_EMISSAO,1,4)"
	cquery+="  	                        AND SUBSTR(SCT.CT_DATA,5,2) = SUBSTR(SC5.C5_EMISSAO,5,2)"
	cquery+="  	                        AND SC5.D_E_L_E_T_ = ' ')"
	cquery+="  	GROUP BY"
	cquery+="  	    CT_VEND                   ,"
	cquery+="  	    A3_NOME                   ,"
	cquery+="  	    SA3.A3_NOMEGER            ,"
	cquery+="  	    SB1.B1_DESC               ,"
	cquery+="  	    CT_PRODUTO                ,"
	cquery+="  	    CT_GRUPO                  ,"
	cquery+="  	    SUBSTR(SCT.CT_DATA,1,4)   ,"
	cquery+="  	    SUBSTR(SCT.CT_DATA,5,2)   ,"
	cquery+="  	    CT_QUANT                  ,"
	cquery+="  	    A3_SUPER                  ,"
	cquery+="  	    A3_EMAIL                  "
	
	cquery+="  	UNION ALL"
	
	cquery+="  	SELECT"
	cquery+="  	    CT_VEND                   AS COD_VEND,"
	cquery+="  RTRIM(A3_NOME)                   AS NOME_VEND,"
	cquery+="  	    SA3.A3_SUPER              AS COD_GER,"
	cquery+="  	    RTRIM(SA3.A3_NOMEGER)     AS NOME_GERENTE,"
	cquery+="  	    SB1.B1_DESC               AS DESC_PROD,"
	cquery+="  	    CT_PRODUTO                AS COD_PRODUTO,"
	cquery+="  	    CT_GRUPO                  AS GRP_PRODUTO,"
	cquery+="  	    SUBSTR(SCT.CT_DATA,1,4)   AS ANO_META,"
	cquery+="  	    SUBSTR(SCT.CT_DATA,5,2)   AS MES_META,"
	cquery+="  	    CASE"
	cquery+="  	      WHEN A3_SUPER = '001013' THEN 'vanessa@vitamedic.ind.br'"
	cquery+="  	      WHEN A3_SUPER = '001012' THEN 'marcelo@vitamedic.ind.br'"
	cquery+="  	      WHEN A3_SUPER = '001006' THEN 'santiago@vitamedic.ind.br'"
	cquery+="  	      WHEN A3_SUPER = '001004' THEN 'l.pontes@vitamedic.ind.br'"
	cquery+="  	      ELSE '-'"
	cquery+="  	    END                       AS EMAILGER,"
	cquery+="  	    RTRIM(A3_EMAIL)           AS EMAILVEND,"
	cquery+="  	    CT_QUANT                  AS QTD_META,"
	cquery+="  	    0             AS QTD_VENDA,"
	cquery+="  	    0             AS QTD_ENTREGUE"
	cquery+="  	FROM SCT010 SCT"
	if mv_par04 = "1"
		cquery+="  	  INNER JOIN SA3010 SA3 ON  SA3.A3_COD = SCT.CT_VEND AND SA3.A3_SUPER ="+mv_par03+" AND SA3.D_E_L_E_T_ = ' ' "
	else
		cquery+="  	  INNER JOIN SA3010 SA3 ON  SA3.A3_COD = SCT.CT_VEND AND SA3.D_E_L_E_T_ = ' ' "
	endif
	cquery+="  	  INNER JOIN SB1010 SB1 ON  SCT.CT_PRODUTO = SB1.B1_COD AND  SB1.D_E_L_E_T_ = ' '"
	cquery+="  	WHERE "
	cquery+="  	 SCT.D_E_L_E_T_	= ' '"
	cquery+="  	AND SCT.CT_VALOR < 1"
	cquery+="  	AND SCT.CT_DATA >= '20140101'"
	if mv_par04 = "2"
		cquery+="  	AND SCT.CT_VEND BETWEEN '"+mv_par02+"' AND '"+mv_par02+"'"
	endif
	cquery+="  	AND SCT.CT_VEND NOT IN (SELECT SC5.C5_VEND1 FROM SC5010 SC5, SC6010 SC6"
	cquery+="  	                        WHERE SC5.D_E_L_E_T_ = ' '"
	cquery+="  	                        AND SC6.D_E_L_E_T_ = ' '"
	cquery+="  	                        AND SC5.C5_NUM = SC6.C6_NUM"
	cquery+="  	                        AND SCT.CT_PRODUTO = SC6.C6_PRODUTO"
	cquery+="  	                        AND SUBSTR(SCT.CT_DATA,1,4) = SUBSTR(SC5.C5_EMISSAO,1,4)"
	cquery+="  	                        AND SUBSTR(SCT.CT_DATA,5,2) = SUBSTR(SC5.C5_EMISSAO,5,2))"
	
	cquery+="  	ORDER BY 1,5,7,8"

	MemoWrite("/sql/vit393_tmp1.sql",cquery)
	tcquery cquery new alias "TMP1"
	
	_cVend		:= " "
	_cProd		:= " "
	_cassunto	:= "Acompanhamento Venda X Meta - Produto "+Alltrim(tmp1->a3_nome)
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
	fwrite(_nhandle,'<td width="260"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="4">Vitapan</font></td>'+chr(13)+chr(10))
	fwrite(_nhandle,'<td align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">Acompanhamento Venda X Meta - Produto  '+dtoc(date())+' '+time()+'</font></b></p>'+chr(13)+chr(10))
	fwrite(_nhandle,'</td>'+chr(13)+chr(10))
	fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
	fwrite(_nhandle,'</table>'+chr(13)+chr(10))

	
	while !tmp1->(eof())   // Percorre tabela com as informações da query
		_cProd = tmp1->cod_produto
		
		if mv_par03 == "1"

		else
			if tmp1->cod_vend <> _cVend
				fwrite(_nhandle,'<p align="center" style="margin-top: 0; margin-bottom: 0">&nbsp;</p>'+chr(13)+chr(10))
				fwrite(_nhandle,'<p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#0000FF">****** Gerente Regional: '+tmp1->nome_gerente+'</font></b></p>'+chr(13)+chr(10))
				fwrite(_nhandle,'<table border="1" width="100%" id="table1" style="border-collapse: collapse" bordercolor="#FFFFFF">'+chr(13)+chr(10))
				
				fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
				fwrite(_nhandle,'<td bgcolor="#000080" align="center" colspan="3"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">'+alltrim(tmp1->nome_vend)+'</font></b></td>'+chr(13)+chr(10))
				for i=1 to month(ddatabase)
					fwrite(_nhandle,'<td bgcolor="#000080" align="center" colspan="3"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">'+strzero(i,2)+'</font></b></td>'+chr(13)+chr(10))
				Next				
				fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
				
				fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
				fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">PRODUTO</font></b></td>'+chr(13)+chr(10))
				for i=1 to month(ddatabase)
					fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">META</font></b></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">VENDA</font></b></td>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF">PERCENTUAL</font></b></td>'+chr(13)+chr(10))
				Next				
				fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
				
				if _cProd = tmp1->cod_produto			//imprimir os produtos	
					fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
					fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+Alltrim(tmp1->cod_produto)+" - "+Alltrim(tmp1->desc_pro)+'</font></b></td>'+chr(13)+chr(10))
					for i=1 to month(ddatabase)
						fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+alltrim(transform(tmp1->qtd_meta,"@E 999,999,999"))+'</font></b></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+alltrim(transform(tmp1->qtd_venda,"@E 999,999,999"))+'</font></b></td>'+chr(13)+chr(10))
						fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0" align="center"><font face="Arial" size="2" color="#000080">'+alltrim(transform((tmp1->qtd_venda*100)/tmp1->qtd_meta,"@E 999,999,999"))+'</font></b></td>'+chr(13)+chr(10))
					Next
					fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
					tmp1->(dbskip())
					_cProd := tmp1->cod_produto
				endif
				
				fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
				fwrite(_nhandle,'<td bgcolor="#000080" align="center"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2" color="#FFFFFF"></font></b></td>'+chr(13)+chr(10))
				fwrite(_nhandle,'</tr>'+chr(13)+chr(10))

				fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
				fwrite(_nhandle,'<td bgcolor="#CCCCCC"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2" color="#000080">'+tmp1->desc_prod+'</font></td>'+chr(13)+chr(10))
				fwrite(_nhandle,'<tr>'+chr(13)+chr(10))
				fwrite(_nhandle,'</tr>'+chr(13)+chr(10))
			endif
		endif	
		tmp1->(dbskip())
		_cVend	:= tmp1->cod_vend
	end  // final do while

	tmp1->(dbclosearea())
return
return()

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa: VIT393   ³ Autor: André Almeida Alves     ³ Data: 12/02/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao: Cria as perguntas do relatorio                              ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function _pergsx1()
	_agrpsx1:={}
	aadd(_agrpsx1,{cperg,"01","Da data                      ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   ",space(1),space(3),"help"})
	aadd(_agrpsx1,{cperg,"02","Ate a data                   ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   ",space(1),space(3),"help"})
	aadd(_agrpsx1,{cperg,"03","Cod Gerente / Representante  ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3",space(1),space(3),"help"})
	aadd(_agrpsx1,{cperg,"04","Tipo Gerente / Representante ?","mv_ch4","N",01,0,0,"C",space(60),"mv_par04"       ,"Gerente"        ,space(30),space(15),"Representante"  ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   ",space(1),space(3),"help"})
	aadd(_agrpsx1,{cperg,"05","Mostra representante inativo ?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   ",space(1),space(3),"help"})
	aadd(_agrpsx1,{cperg,"05","Envia E-mail aos Represent.  ?","mv_ch6","N",01,0,0,"C",space(60),"mv_par06"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   ",space(1),space(3),"help"})

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
return()

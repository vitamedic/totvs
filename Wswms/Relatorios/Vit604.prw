#INCLUDE "Protheus.CH" 
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#INCLUDE "TBICONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} Vit604
Rotina Vit604
WF Comunicado de Troca de Lotes

@author Henrique Corrêa
@since 13/05/2017
@version P11
@return Nil(nulo)
/*/
//------------------------------------------------------------  
User Function Vit604(_cFilial, _cDoc, _cSerie, _cCliente, _cLoja, _cNome, cNUM_OS, _cItemPV, _cSeq, _cProduto, _cDesc, _cLote, _cLocal, _nQtdLib, _aLotes)
	
	Local cMailsEnv //emails destino workflow
	Local cHtml		:= ""
	Local cLinIt 	:= ""
	Local cPict 	:= PesqPict("SC9","C9_QTDLIB")
	Local cCor1 	:= "#FFFFFF"
	Local cCor2 	:= "#EFEFEF"
	Local cCorTit 	:= "#ff9494"
	Local cCorTop   := "#f27676"
	Local nX 		:= 0     
	Local nY 		:= 0
	Local lOk 		:= .T.
	Local cDocSD3 	:= ""
	Local _PedidoOS := Left(cNUM_OS,6) + "/" + Right(cNUM_OS,2)
	
	//dados para envio de email
	Local cAccount  := 'chamados'
	Local cEnvia    := 'helpdesk@vitamedic.ind.br'
	Local cServer   := '10.1.1.34'
	Local cPassword := '6Y6GFDcf3h'
	Local cAssunto  := "WF Comunicado da Troca de Lote : Pedido/OS "+_PedidoOS+" "+DTOC(dDatabase)+" "+Time()+""
		
	Conout("==>>Vit604: INICIO WORKFLOW DA TROCA DE LOTES : "+DTOC(dDatabase)+" "+Time()+"  <== ")
	
	cMailsEnv := SuperGetMv("MV_XTRMAIL",.F.,"o.ricao@hotmail.com;ho.ricao@gmail.com;henrique.correa@totvs.com.br")   
	
	if empty(cMailsEnv)
		Conout("==>>Vit604: email nao configurado. Parametro MV_XTRMAIL.")
		Return
	endif 
	
	for nY := 1 to len(_aLotes)
        
		nX++
        
	  	cLinIt += '<tr bgcolor="' + iif(nX%2==0,cCor1,cCor2) + '">'
		cLinIt += '<td>'+Alltrim(_aLotes[nY][1])+'</td>'
		cLinIt += '<td>'+Alltrim(_aLotes[nY][3])+'</td>'
		cLinIt += '<td>'+Alltrim(DtoC(_aLotes[nY][7]))+'</td>'
		cLinIt += '<td>'+Alltrim(Transform(_aLotes[nY][5], cPict))+'</td>'
		cLinIt += '</tr>'
	  	
	  	lOk := .T.
		
	next nY
	
	if lOk
		
		cHtml += "<h3>Comunicado de Troca de Lotes Pedido/OS: "+_PedidoOS+"</h3>"
		cHtml += "<hr>"

		cHtml += "<p>Filial : "+_cFilial+"</p>"
		cHtml += "<p>Cliente : "+_cCliente+"/"+_cLoja+" - "+AllTrim(_cNome)+"</p>"
		cHtml += "<p>NF/Série : "+Iif(empty(_cDoc), "",_cDoc+"/"+_cSerie)+"</p>"
		cHtml += "<br />"
	
		cHtml += '<table width="100%" border="0" cellspacing="0" cellpadding="3">'

//		cHtml += '<td colspan="1" bgcolor="'+cCorTop+'"><b>Dados do Lote Trocado</b>'

		cHtml += '<thead>'
		cHtml += '<tr><td colspan="6" bgcolor="'+cCorTop+'" align="center"><b>Dados do Lote Trocado</b></td></tr>'
		cHtml += '</thead>'

		cHtml += '<tr bgcolor="'+cCorTit+'">'
		cHtml += '<td>Filial</td>'
		cHtml += '<td>Produto</td>'
		cHtml += '<td>Descricao</td>'
		cHtml += '<td>Armazem</td>'
		cHtml += '<td>Lote</td>'
		cHtml += '<td>Quantidade</td>'
		cHtml += '</tr>' 
	  	cHtml += '<tr bgcolor="' + iif(nX%2==0,cCor1,cCor2) + '">'
		cHtml += '<td>'+Alltrim(_cFilial)+'</td>'
		cHtml += '<td>'+Alltrim(_cProduto)+'</td>'
		cHtml += '<td>'+Alltrim(_cDesc)+'</td>'
		cHtml += '<td>'+Alltrim(_cLocal)+'</td>'
		cHtml += '<td>'+Alltrim(_cLote)+'</td>'
		cHtml += '<td>'+Alltrim(Transform(_nQtdLib, cPict))+'</td>'
		cHtml += '</tr>'
		cHtml += "</table>"
		
		//cHtml += "<p>Abaixo temos a rela&ccedil;&atilde;o dos lotes utilizados na troca.</p>"
		//cHtml += "<br>"
	
		cHtml += '<table width="100%" border="0" cellspacing="0" cellpadding="3">'

		cHtml += '<thead>'
		cHtml += '<tr><td colspan="4" bgcolor="'+cCorTop+'" align="center"><b>Rela&ccedil;&atilde;o dos lotes utilizados na troca</b></td></tr>'
		cHtml += '</thead>'
		
		//cHtml += '<td colspan="1" bgcolor="'+cCorTop+'"><b>Rela&ccedil;&atilde;o dos lotes utilizados na troca</b>'


		cHtml += '<tr bgcolor="'+cCorTit+'">'
		cHtml += '<td>Lote</td>'
		cHtml += '<td>Endere&ccedil;o</td>'
		cHtml += '<td>Validade</td>'
		cHtml += '<td>Quantidade</td>'
		cHtml += '</tr>' 
		cHtml += cLinIt
		cHtml += '</table>'

		cHtml += "<br>"
		cHtml += "<p><i>Favor n&atilde;o responder este email.</i></p>"
	    
	    //faz conexao servidor email 
	    CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lOK
	    
	    if lOK
			SEND MAIL FROM cEnvia TO cMailsEnv SUBJECT cAssunto BODY cHtml RESULT lOK
			if lOk
				Conout("==>>Vit604: Email enviado com sucesso.")
			else
				Conout("==>>Vit604: Falha no Envio do E-Mail.")
			endif
	    else
	    	Conout("==>>Vit604: Falha na Conexão com Servidor de E-Mail.")
		endif
		
		DISCONNECT SMTP SERVER
		
	endif
	
 	Conout("==>>Vit604: FIM WF TROCA DE LOTE : "+DTOC(dDatabase)+" "+Time()+"  <== ")
	
Return 
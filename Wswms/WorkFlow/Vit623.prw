#INCLUDE "Protheus.CH" 
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#INCLUDE "TBICONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} Vit623
Rotina Vit623
WF Comunicado de Fornecedor, Fabricante ou Transportador 

@author Henrique Corrêa
@since 27/06/2017
@version P11
@return Nil(nulo)
@history

/*/
//------------------------------------------------------------  
User Function Vit623(pNF, pSerie, pCodFor, pLoja, aItens)
	
	Local cMailsEnv //emails destino workflow
	Local cHtml		:= ""
	Local cLinIt 	:= ""
	Local cPict 	:= PesqPict("SD1","D1_QUANT")
	Local cCor1 	:= "#FFFFFF"
	Local cCor2 	:= "#EFEFEF"
	Local cCorTit 	:= "#ff9494"
	Local cCorTop   := "#f27676"
	Local nX 		:= 0     
	Local nY 		:= 0
	Local lOk 		:= .T.
 	Local cUserLgi  := ""
  	Local cUserLga  := ""
	
	//dados para envio de email
	Local cAccount  := 'chamados'
	Local cEnvia    := 'helpdesk@vitamedic.ind.br'
	Local cServer   := '10.1.1.34'
	Local cPassword := '6Y6GFDcf3h'
	Local cAssunto  := "Comunicado de Certificado(s) Vencido(s) NF: "+pNF+" Série: "+pSerie
		                              
	Default pNF     := ""		           
	Default pSerie  := ""                        
	Default pCodFor := ""                        
	Default pLoja  	:= ""                        
	Default aItens 	:= {}
	
	Conout("==>>Vit623: INICIO WORKFLOW Certificado(s) Vencido(s) NF: "+pNF+" Série: "+pSerie+"  <== ")
	
	cMailsEnv := SuperGetMv("MV_XCRMAIL",.F.,"vit623@vitamedic.ind.br")   
	
    if Len(aItens) == 0  //! SB1->B1_TIPO $ 'MP/EE/EN'
    	Return
    endif
    
	if empty(cMailsEnv)
		Conout("==>>Vit623: email nao configurado. Parametro MV_XCRMAIL.")
		Return
	endif  
	
	For nX := 1 to Len(aItens)
	 	cUserLgi := Alltrim(aItens[nX][14])
	  	cUserLga := Alltrim(aItens[nX][15])
		
	  	cLinIt += '<tr bgcolor="' + iif(nX%2==0,cCor1,cCor2) + '">'
		cLinIt += '<td>'+aItens[nX][01]+'</td>'
		cLinIt += '<td>'+aItens[nX][02]+'-'+Alltrim(aItens[nX][03])+'</td>'
		cLinIt += '<td>'+aItens[nX][04]+'</td>'
		cLinIt += '<td>'+Transform(aItens[nX][05], '@E 99,999,999.99999')+'</td>'
		cLinIt += '<td>'+aItens[nX][06]+'</td>'
		cLinIt += '<td>'+aItens[nX][07]+'</td>'
		cLinIt += '<td>'+aItens[nX][08]+'-'+Alltrim(aItens[nX][09])+'</td>'
		cLinIt += '<td>'+aItens[nX][10]+'-'+Alltrim(aItens[nX][11])+'</td>'
		cLinIt += '<td>'+aItens[nX][12]+'-'+Alltrim(aItens[nX][13])+'</td>'
		cLinIt += '</tr>'
    Next nX

	if lOk
		
		cHtml += "<h3>Comunicado de Certificado(s) Vencido(s) NF: "+pNF+" Série: "+pSerie+"</h3>"
		cHtml += "<hr>"

		cHtml += "<p>Filial 	  : "+XFilial("SD1")+"</p>"
		cHtml += "<p>Fornecedor   : "+SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+AllTrim(SA2->A2_NOME)+"</p>"
		cHtml += "<p>NF/Série 	  : "+Iif(empty(pNF), "",pNF+"/"+pSerie)+"</p>"
		cHtml += "<p>Usuário Inc. : "+cUserLgi+"</p>"
		cHtml += "<p>Usuário Alt. : "+cUserLga+"</p>"
		cHtml += "<br />"
		
	    /*
		cHtml += '<table width="100%" border="0" cellspacing="0" cellpadding="3">'

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
	  	
	  	if Upper(AllTrim(ReadVar())) & "D1_XTRANSP" 
	  	
			cHtml += '<td>'+Alltrim(XFilial("SD1"))+'</td>'
			cHtml += '<td>'+Alltrim(M->D1_COD)+'</td>'
			cHtml += '<td>'+Alltrim(M->D1_DESCPRO)+'</td>'
			cHtml += '<td>'+Alltrim(M->D1_LOCAL)+'</td>'
			cHtml += '<td>'+Alltrim(M->D1_LOTECTL)+'</td>'
			cHtml += '<td>'+Alltrim(Transform(M->D1_QUANT, cPict))+'</td>'
		
		endif
			
		cHtml += '</tr>'
		cHtml += "</table>"
		*/
		
		cHtml += '<table width="100%" border="0" cellspacing="0" cellpadding="3">'

		cHtml += '<thead>'
		cHtml += '<tr><td colspan="4" bgcolor="'+cCorTop+'" align="center"><b>Rela&ccedil;&atilde;o dos lotes utilizados na troca</b></td></tr>'
		cHtml += '</thead>'

		cHtml += '<tr bgcolor="'+cCorTit+'">'
		cHtml += '<td>Item</td>'
		cHtml += '<td>Produto</td>'
		cHtml += '<td>UM</td>'
		cHtml += '<td>Quantidade</td>'
		cHtml += '<td>Lote</td>'
		cHtml += '<td>Lote For</td>'
		cHtml += '<td>Pedido\Item</td>'
		cHtml += '<td>Transportadora</td>'
		cHtml += '<td>Fabricante</td>'
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
				Conout("==>>Vit623: Email enviado com sucesso.")
			else
				Conout("==>>Vit623: Falha no Envio do E-Mail.")
			endif
	    else
	    	Conout("==>>Vit623: Falha na Conexão com Servidor de E-Mail.")
		endif
		
		DISCONNECT SMTP SERVER
		
	endif
	
 	Conout("==>>Vit623: Certificado(s) Vencido(s) NF: "+pNF+" Série: "+pSerie+"  <== ")
	
Return 
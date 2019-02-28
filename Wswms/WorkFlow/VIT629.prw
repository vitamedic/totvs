	#INCLUDE "Protheus.CH" 
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#INCLUDE "TBICONN.CH"

#define CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} VIT629
	Workflow de posição Diária Lotes Incompletos
@author Guilherme Sampaio
@since 13/07/2017
@version undefined

@type function
/*/
User Function VIT629()

	Local cHtml		:= ""
	Local cCor1 	:= "#FFFFFF"
	Local cCor2 	:= "#EFEFEF"
	Local cCorTit 	:= "#ff9494"
	Local cCorTop   := "#f27676"
	Local nX 		:= 0     
	Local lOk 		:= .T.
	Local cDescProd	:= ""
	Local cInfoProd	:= ""

	//dados para envio de email
	Local cAccount  := SuperGetMV("ES_VITACC",.F.,'chamados')					// Conta no Servidor
	Local cEnvia    := SuperGetMV("ES_VITENV",.F.,'helpdesk@vitamedic.ind.br') 	// Conta de e-mail do Servidor
	Local cServer   := SuperGetMV("ES_VITSER",.F.,'10.1.1.34')					// Servidor de e-mail 
	Local cPassword := SuperGetMV("ES_VITPSW",.F.,'6Y6GFDcf3h')					// Senha do Servidor do e-mail
	Local cMailsEnv := SuperGetMv("ES_VITMAIL",.F.,"g.sampaio@outlook.com")		// e-mails para serem notificados 
	Local cAssunto  := "Comunicado de Posição diária de Volumes Incompletos"
	Local cAliasSB8	:= "QVIT629"

	Conout("==>>VIT629: INICIO WORKFLOW - Posicao diaria de Volumes Incompletos <== ")

	// monta o alias da consulta
	fQrySB8( cAliasSB8 )

	// verifico se o alias  esta preenchidog
	if !Select( cAliasSB8 ) > 0 
		Return
	endif

	// verifico se os emails estao sendo enviados
	if empty(cMailsEnv)
		Conout("==>>VIT629: email nao configurado. Parametro MV_XCRMAIL.")
		Return
	endif  

	if lOk
		cHtml += "<h3>Posição diária de Volumes Incompletos</h3>"
		cHtml += "<hr>"

		cHtml += "<p>Filial 	  : "+ cFilAnt + "</p>"
		cHtml += "<p>Data e Hora  : "+ DtoC(dDataBase) + " às " + Time() +"</p>"
		cHtml += "<br />"

		cHtml += '<table width="100%" border="0" cellspacing="0" cellpadding="3">'
		cHtml += '<thead>'
		cHtml += '<tr><td colspan="5" bgcolor="'+cCorTop+'" align="center"><b>Relação de Volumes Incompletos</b></td></tr>'
		cHtml += '</thead>'
		cHtml += '<tr bgcolor="'+cCorTit+'">'
		cHtml += '<td>Produto</td>'
		cHtml += '<td>Lote</td>'
		cHtml += '<td>Data de Validade</td>'
		cHtml += '<td>Saldo Disponivel</td>'
		cHtml += '<td>Saldo p/ Volume</td>'
		cHtml += '</tr>' 

		// percorro os registros	
		Do While ( cAliasSB8 )->(!Eof())			

			// descricao do produto
			cDescProd 	:= Posicione("SB1",1,xFilial("SB1")+( cAliasSB8 )->CODIGO,"B1_DESC")

			// codigo do produto + descricao do produto
			cInfoProd	:= ( cAliasSB8 )->CODIGO + " - " + cDescProd 

			cHtml += '<tr bgcolor="' + iif(nX%2==0,cCor1,cCor2) + '">'
			cHtml += '<td>' + cInfoProd + '</td>'
			cHtml += '<td>' + ( cAliasSB8 )->LOTECTL + '</td>'
			cHtml += '<td>' + DtoC( StoD( ( cAliasSB8 )->DTVALID ) ) + '</td>'
			cHtml += '<td>' + TransForm( ( cAliasSB8 )->VOL_INCOMPLETOS, "@E 999,999,999.99" ) + '</td>'
			cHtml += '<td>' + TransForm( ( cAliasSB8 )->QTD_VOLUMES , "@E 999,999,999.99" )+ '</td>'
			cHtml += '</tr>'

			nX++
			( cAliasSB8 )->(dbSkip())
		EndDo

		( cAliasSB8 )->( dbCloseArea() )

		cHtml += '</table>'
		cHtml += "<br>"

		cHtml += "<br>"
		cHtml += "<p><i>Favor n&atilde;o responder este email.</i></p>"

		//faz conexao servidor email 
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lOK

		if lOK
			SEND MAIL FROM cEnvia TO cMailsEnv SUBJECT cAssunto BODY cHtml RESULT lOK
			if lOk
				
				If FunName() $ "VIT630"
					MsgInfo("Email enviado com sucesso!")
				EndIf
				
				Conout("==>>VIT629: Email enviado com sucesso.")
			else
				
				If FunName() $ "VIT630"
					MsgAlert("Falha no Envio do E-Mail!")
				EndIf
				
				Conout("==>>VIT629: Falha no Envio do E-Mail.")
			endif
		else
			Conout("==>>VIT629: Falha na Conexão com Servidor de E-Mail.")
		endif

		DISCONNECT SMTP SERVER

	endif

	Conout("==>>VIT629: Fim Workflow de posição Diária Lotes Incompletos <== ")

Return 

//-------------------------------------------------
Static Function fQrySB8( cAliasSB8 )
	//-------------------------------------------------

	Local cQuery 		:= ""	

	Default cAliasSB8	:= "QVIT629"

	If Select( cAliasSB8 ) > 0
		( cAliasSB8 )->( DbCloseArea() )
	EndIf

	cQuery := " SELECT SB1.B1_COD CODIGO, SB1.B1_TIPO																												" + CRLF
	cQuery += "      , SB1.B1_DESC																															" + CRLF
	cQuery += "     , SB8.B8_LOTECTL LOTECTL																														" + CRLF
	cQuery += "     , SB8.B8_DTVALID DTVALID																													" + CRLF
	cQuery += "     , SB8.B8_SALDO 																															" + CRLF
	cQuery += "     , SB8.B8_EMPENHO																														" + CRLF
	cQuery += "     , (SB8.B8_SALDO - SB8.B8_EMPENHO) DISPONIVEL 																							" + CRLF
	cQuery += "     , SB1.B1_CXPAD QTDE_VOLUME 																												" + CRLF
	cQuery += "     , ROUND((SB8.B8_SALDO - SB8.B8_EMPENHO) - Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD) /SB1.B1_CXPAD,1)  QTD_VOLUMES 				" + CRLF
	cQuery += "     , ((SB8.B8_SALDO - SB8.B8_EMPENHO) - Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD)) / SB1.B1_CXPAD        VOL_INTEIROS	 			" + CRLF	
	cQuery += "     , Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD)                                                           VOL_INCOMPLETOS 			" + CRLF
	cQuery += " FROM " + RetSqlName("SB8") + " SB8 																											" + CRLF
	cQuery += "   , " + RetSqlName("SB1") + " SB1																											" + CRLF
	cQuery += " WHERE SB1.B1_FILIAL = '01'																													" + CRLF
	cQuery += "   AND SB1.B1_COD    = SB8.B8_PRODUTO																										" + CRLF
	cQuery += "   AND SB1.D_E_L_E_T_ = ' ' 																													" + CRLF
	cQuery += "   AND SB8.B8_FILIAL = '01'																													" + CRLF
	cQuery += "   AND (SB8.B8_SALDO - SB8.B8_EMPENHO) > 0																									" + CRLF
	cQuery += "   AND Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD) <> 0																					" + CRLF
	cQuery += "   AND SB8.D_E_L_E_T_ = ' ' 																													" + CRLF
	cQuery += "   AND SB1.B1_TIPO IN ('PA', 'PN')																											" + CRLF
	cQuery += " ORDER BY SB1.B1_COD																															" + CRLF
	cQuery += "      , SB8.B8_DTVALID ASC																													" + CRLF

	cQuery := ChangeQuery( cQuery )

	TcQuery cQuery New Alias ( cAliasSB8 )

Return

#INCLUDE "Protheus.CH" 
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#INCLUDE "TBICONN.CH"
#include "ap5mail.ch"
#include "TOTVS.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} Vit626
Rotina Vit626
WF Lista de Fornecedores, Fabricantes e Transportadoras que iram
vencer seus certificados nos proximos 60 dias

@author Henrique Corrêa
@since 03/07/2017
@version P11
@return Nil(nulo)
@history


/*/
//------------------------------------------------------------  
User Function Vit626()
	
	
	Local cMailsEnv //emails destino workflow
	Local cHtml		:= ""
	Local cCor1 
	Local cCor2 	
	Local cCorTit 
	Local cCorTop 
	Local nX 		  
	Local lOk 		

	Local cAccount 
	Local cEnvia 
	Local cServer 
	Local cPassword 
	Local cAssunto  
	Local nItens 	
	Local cEntid   
	Local cLinForn 
	Local cLinTran  
	Local cLinFabr 
	
	Prepare Environment EMPRESA '01' FILIAL '01' MODULO 'FAT'
	
	nItens 	:= u_Certif()
	 cHtml		:= ""
	 cCor1 	:= "#FFFFFF"
	 cCor2 	:= "#EFEFEF"
	 cCorTit 	:= "#ff9494"
	 cCorTop   := "#f27676"
	 nX 		:= 0     
	 lOk 		:= .T.
	 cAccount  := GetMv("MV_RELACNT")
	 cEnvia    := GetMv("MV_RELACNT")
	 cServer   := GetMv("MV_RELSERV")
	 cPassword := GetMv("MV_RELPSW")
	 cAssunto  := "Comunicado de Certificado(s) Próximos do Vencimento"
	 nItens 	:= u_Certif()
	 cEntid    := ""
	 cLinForn  := ""
	 cLinTran  := ""
	 cLinFabr  := ""
	
	Conout("==>>Vit626: INICIO WORKFLOW Certificado(s) próximos do vencimento  <== ")
	
	//o mesmo utilizado no comunicado de certificado vencido 
	cMailsEnv := "vit626@vitamedic.ind.br"   
	
    if nItens == 0 
    	Return
    endif
    
	if empty(cMailsEnv)
		Conout("==>>Vit626: email nao configurado. Parametro MV_WFACC.")
		Return
	endif  
	
//	SetRegua(nItens)
	
	Do While QVIT626->(!Eof())
   //		IncRegua()

		If cEntid <> QVIT626->ENTIDADE
			nX 		:= 1
			cEntid 	:= QVIT626->ENTIDADE
		EndIf
		
		If QVIT626->ENTIDADE == "SA2"
		  	cLinForn += '<tr bgcolor="' + iif(nX%2==0,cCor1,cCor2) + '">'
			cLinForn += '<td>'+QVIT626->CODIGO+'</td>'
			cLinForn += '<td>'+QVIT626->LOJA+'</td>'
			cLinForn += '<td>'+QVIT626->NOME+'</td>'
			cLinForn += '<td>'+QVIT626->CERTIFICADO+'</td>'
			cLinForn += '<td>'+DtoC(StoD(QVIT626->DTVENC))+'</td>'
			cLinForn += '</tr>'
		ElseIf QVIT626->ENTIDADE == "SA4"
		  	cLinTran += '<tr bgcolor="' + iif(nX%2==0,cCor1,cCor2) + '">'
			cLinTran += '<td>'+QVIT626->CODIGO+'</td>'
			cLinTran += '<td>'+QVIT626->LOJA+'</td>'
			cLinTran += '<td>'+QVIT626->NOME+'</td>'
			cLinTran += '<td>'+QVIT626->CERTIFICADO+'</td>'
			cLinTran += '<td>'+DtoC(StoD(QVIT626->DTVENC))+'</td>'
			cLinTran += '</tr>'
		Else
		  	cLinFabr += '<tr bgcolor="' + iif(nX%2==0,cCor1,cCor2) + '">'
			cLinFabr += '<td>'+QVIT626->CODIGO+'</td>'
			cLinFabr += '<td>'+QVIT626->LOJA+'</td>'
			cLinFabr += '<td>'+QVIT626->NOME+'</td>'
			cLinFabr += '<td>'+QVIT626->CERTIFICADO+'</td>'
			cLinFabr += '<td>'+DtoC(StoD(QVIT626->DTVENC))+'</td>'
			cLinFabr += '</tr>'
		EndIf
		
		nX++
		QVIT626->(dbSkip())
    EndDo
	
	QVIT626->(dbCloseArea())
	
	if lOk
		cHtml += "<h3>Comunicado de Certificado(s) Próximos do Vencimento</h3>"
		cHtml += "<hr>"

		cHtml += "<p>Filial 	  : "+ cFilAnt + "</p>"
		cHtml += "<p>Data e Hora  : "+ DtoC(dDataBase) + " às " + Time() +"</p>"
		cHtml += "<br />"
		
		if !empty(cLinForn)
			cHtml += '<table width="100%" border="0" cellspacing="0" cellpadding="3">'
			cHtml += '<thead>'
			cHtml += '<tr><td colspan="5" bgcolor="'+cCorTop+'" align="center"><b>Relação de Fornecedores</b></td></tr>'
			cHtml += '</thead>'
			cHtml += '<tr bgcolor="'+cCorTit+'">'
			cHtml += '<td>Código</td>'
			cHtml += '<td>Loja</td>'
			cHtml += '<td>Nome</td>'
			cHtml += '<td>Certificado</td>'
			cHtml += '<td>Vencimento</td>'
			cHtml += '</tr>' 
			cHtml += cLinForn
			cHtml += '</table>'
			cHtml += "<br>"
	    endif

		if !empty(cLinTran)
			cHtml += '<table width="100%" border="0" cellspacing="0" cellpadding="3">'
			cHtml += '<thead>'
			cHtml += '<tr><td colspan="5" bgcolor="'+cCorTop+'" align="center"><b>Relação de Transportadoras</b></td></tr>'
			cHtml += '</thead>'
			cHtml += '<tr bgcolor="'+cCorTit+'">'
			cHtml += '<td>Código</td>'
			cHtml += '<td>Loja</td>'
			cHtml += '<td>Nome</td>'
			cHtml += '<td>Certificado</td>'
			cHtml += '<td>Vencimento</td>'
			cHtml += '</tr>' 
			cHtml += cLinTran
			cHtml += '</table>'
			cHtml += "<br>"
	    endif

		if !empty(cLinFabr)
			cHtml += '<table width="100%" border="0" cellspacing="0" cellpadding="3">'
			cHtml += '<thead>'
			cHtml += '<tr><td colspan="5" bgcolor="'+cCorTop+'" align="center"><b>Relação de Fabricantes</b></td></tr>'
			cHtml += '</thead>'
			cHtml += '<tr bgcolor="'+cCorTit+'">'
			cHtml += '<td>Código</td>'
			cHtml += '<td>Loja</td>'
			cHtml += '<td>Nome</td>'
			cHtml += '<td>Certificado</td>'
			cHtml += '<td>Vencimento</td>'
			cHtml += '</tr>' 
			cHtml += cLinFabr
			cHtml += '</table>'
	    endif
	    
		cHtml += "<br>"
		cHtml += "<p><i>Favor n&atilde;o responder este email.</i></p>"
	    
	    //faz conexao servidor email 
	    CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lOK
	    MailAuth(cAccount, cPassword)
	    if lOK
	    
			SEND MAIL FROM cEnvia TO cMailsEnv SUBJECT cAssunto BODY cHtml RESULT lOK
			
			if lOk
				Conout("==>>Vit626: Email enviado com sucesso.")
			else
				Conout("==>>Vit626: Falha no Envio do E-Mail.")
			endif
	    else
	    	Conout("==>>Vit626: Falha na Conexão com Servidor de E-Mail.")
		endif
		
		DISCONNECT SMTP SERVER
		
	endif
	
 	Conout("==>>Vit626: Comunicado de Certificado(s) Próximos do Vencimento Fim <== ")
 	Reset Environment  	
Return 

User Function Certif(pData,pTab,pCodigo,pLoja)
Local cQry          
Local pRecnos
Local MV_VIT626D := SuperGetMV("MV_VIT626D", .f., 60)

Default pData 	 := DtoS(dDataBase + MV_VIT626D)  
Default pTab     := ""
Default pCodigo  := ""
Default pLoja    := ""
	
	IncProc("Solicitação de Compras...")

	cQry :=        " SELECT QQ.ENTIDADE "
	cQry += CRLF + "      , QQ.CODIGO "
	cQry += CRLF + "      , QQ.LOJA "
	cQry += CRLF + "      , QQ.NOME "
	cQry += CRLF + "      , QQ.CERTIFICADO "
	cQry += CRLF + "      , QQ.DTVENC "
	cQry += CRLF + "      , SUM(QQ.QTDPRODUTOS) QTDPRODUTOS "
	cQry += CRLF + " FROM ( "
	
	if empty(pTab) .or. pTab == "SA2"
		cQry += CRLF + "        SELECT 'SA2'                  ENTIDADE "
		cQry += CRLF + "             , SA5.A5_FORNECE         CODIGO "
		cQry += CRLF + "             , SA5.A5_LOJA            LOJA  "
		cQry += CRLF + "             , SA5.A5_NOMEFOR         NOME "
		cQry += CRLF + "             , Max(Case When SA5.A5_XCERT1 <> ' ' AND SA5.A5_VALFORN <= '" + pData + "' Then '1o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERT2 <> ' ' AND SA5.A5_XDTCER2 <= '" + pData + "' Then '2o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERT3 <> ' ' AND SA5.A5_XDTCER3 <= '" + pData + "' Then '3o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERT4 <> ' ' AND SA5.A5_XDTCER4 <= '" + pData + "' Then '4o Certificado' "
		cQry += CRLF + "                    Else '5o Certificado' End) CERTIFICADO "
		cQry += CRLF + "             , Max(Case When SA5.A5_XCERT1 <> ' ' AND SA5.A5_VALFORN <= '" + pData + "' Then SA5.A5_VALFORN "
		cQry += CRLF + "                    When SA5.A5_XCERT2 <> ' ' AND SA5.A5_XDTCER2 <= '" + pData + "' Then SA5.A5_XDTCER2 "
		cQry += CRLF + "                    When SA5.A5_XCERT3 <> ' ' AND SA5.A5_XDTCER3 <= '" + pData + "' Then SA5.A5_XDTCER3 "
		cQry += CRLF + "                    When SA5.A5_XCERT4 <> ' ' AND SA5.A5_XDTCER4 <= '" + pData + "' Then SA5.A5_XDTCER4 "
		cQry += CRLF + "                    Else SA5.A5_XDTCER5 End) DTVENC"
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO)  QTDPRODUTOS "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "
        
        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_COD     = '"+pCodigo+"' "
			cQry += CRLF + "          AND SA5.A5_LOJA    = '"+pLoja+"' "
		endif
		cQry += CRLF + "          AND SA5.A5_SITU     <> 'E' "	
		cQry += CRLF + "          AND ((SA5.A5_XCERT1 <> ' ' AND SA5.A5_VALFORN <= '" + pData + "') "
		cQry += CRLF + "               OR (SA5.A5_XCERT2 <> ' ' AND SA5.A5_XDTCER2 <= '" + pData + "')  "
		cQry += CRLF + "               OR (SA5.A5_XCERT3 <> ' ' AND SA5.A5_XDTCER3 <= '" + pData + "')  "
		cQry += CRLF + "               OR (SA5.A5_XCERT4 <> ' ' AND SA5.A5_XDTCER4 <= '" + pData + "')  "
		cQry += CRLF + "               OR (SA5.A5_XCERT5 <> ' ' AND SA5.A5_XDTCER5 <= '" + pData + "') ) "
		cQry += CRLF + "        GROUP BY SA5.A5_FORNECE  "
		cQry += CRLF + "               , SA5.A5_LOJA  "
		cQry += CRLF + "               , SA5.A5_NOMEFOR "
    endif         
    
    if empty(pTab)
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
    endif
    
	if empty(pTab) .or. pTab == "SA4"
		cQry += CRLF + "        SELECT 'SA4' 		ENTIDADE "
		cQry += CRLF + "             , SA4.A4_COD  	CODIGO "
		cQry += CRLF + "             , '' 			LOJA "
		cQry += CRLF + "             , SA4.A4_NOME 	NOME "
		cQry += CRLF + "             , Case When SA4.A4_XCERT1 <> ' ' AND SA4.A4_XDTCER1 <= '" + pData + "' Then '1o Certificado' "
		cQry += CRLF + "                    When SA4.A4_XCERT2 <> ' ' AND SA4.A4_XDTCER2 <= '" + pData + "' Then '2o Certificado' "
		cQry += CRLF + "                    When SA4.A4_XCERT3 <> ' ' AND SA4.A4_XDTCER3 <= '" + pData + "' Then '3o Certificado' "
		cQry += CRLF + "                    When SA4.A4_XCERT4 <> ' ' AND SA4.A4_XDTCER4 <= '" + pData + "' Then '4o Certificado' "
		cQry += CRLF + "                    Else '5o Certificado' End CERTIFICADO"
		cQry += CRLF + "             , Case When SA4.A4_XCERT1 <> ' ' AND SA4.A4_XDTCER1 <= '" + pData + "' Then SA4.A4_XDTCER1 "
		cQry += CRLF + "                    When SA4.A4_XCERT2 <> ' ' AND SA4.A4_XDTCER2 <= '" + pData + "' Then SA4.A4_XDTCER2 "
		cQry += CRLF + "                    When SA4.A4_XCERT3 <> ' ' AND SA4.A4_XDTCER3 <= '" + pData + "' Then SA4.A4_XDTCER3 "
		cQry += CRLF + "                    When SA4.A4_XCERT4 <> ' ' AND SA4.A4_XDTCER4 <= '" + pData + "' Then SA4.A4_XDTCER4 "
		cQry += CRLF + "                    Else SA4.A4_XDTCER5 End DTVENC"
		cQry += CRLF + "             , 1                     QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA4") + " SA4  "
		cQry += CRLF + "        WHERE SA4.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA4.A4_COD     = '"+pCodigo+"' "
		endif

		cQry += CRLF + "          AND SA4.A4_XTPPRDS <> ' ' "
		cQry += CRLF + "          AND ((SA4.A4_XCERT1 <> ' ' AND SA4.A4_XDTCER1 <= '" + pData + "') "
		cQry += CRLF + "               OR (SA4.A4_XCERT2 <> ' ' AND SA4.A4_XDTCER2 <= '" + pData + "')  "
		cQry += CRLF + "               OR (SA4.A4_XCERT3 <> ' ' AND SA4.A4_XDTCER3 <= '" + pData + "')  "
		cQry += CRLF + "               OR (SA4.A4_XCERT4 <> ' ' AND SA4.A4_XDTCER4 <= '" + pData + "')  "
		cQry += CRLF + "               OR (SA4.A4_XCERT5 <> ' ' AND SA4.A4_XDTCER5 <= '" + pData + "') ) "
	endif
	
	if empty(pTab)
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
	endif
	
	if empty(pTab) .or. pTab == "Z55"
		cQry += CRLF + "        SELECT 'Z55' 			ENTIDADE "
		cQry += CRLF + "             , Z55.Z55_CODIGO 	CODIGO "
		cQry += CRLF + "             , '' 				LOJA "
		cQry += CRLF + "             , Z55.Z55_NOME  	NOME "
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "' Then '1o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "' Then '2o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "' Then '3o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "' Then '4o Certificado' "
		cQry += CRLF + "                    Else '5o Certificado' End) CERTIFICADO"
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "' Then Z55.Z55_DTCER1 "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "' Then Z55.Z55_DTCER2 "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "' Then Z55.Z55_DTCER3 "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "' Then Z55.Z55_DTCER4 "
		cQry += CRLF + "                    Else Z55.Z55_DTCER5 End) DTVENC"
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO) QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        INNER JOIN " + retsqlname("Z55") + " Z55 ON (Z55.Z55_FILIAL = '"+XFilial("Z55")+"' "
		cQry += CRLF + "                                  AND Z55.Z55_CODIGO = SA5.A5_XFAB1 "
		cQry += CRLF + "                                  AND Z55.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_XFAB1    = '"+pCodigo+"' "
		endif

		cQry += CRLF + "          AND ((Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "') "
		cQry += CRLF + "               OR (Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + pData + "') ) "
		cQry += CRLF + "          AND SA5.A5_SITU     <> 'E' "
		cQry += CRLF + "        GROUP BY Z55.Z55_CODIGO "
		cQry += CRLF + "             , Z55.Z55_NOME  "
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
		cQry += CRLF + "        SELECT 'Z55' 			ENTIDADE "
		cQry += CRLF + "             , Z55.Z55_CODIGO 	CODIGO "
		cQry += CRLF + "             , '' 				LOJA "
		cQry += CRLF + "             , Z55.Z55_NOME  	NOME "
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "' Then '1o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "' Then '2o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "' Then '3o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "' Then '4o Certificado' "
		cQry += CRLF + "                    Else '5o Certificado' End) CERTIFICADO "
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "' Then Z55.Z55_DTCER1 "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "' Then Z55.Z55_DTCER2 "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "' Then Z55.Z55_DTCER3 "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "' Then Z55.Z55_DTCER4 "
		cQry += CRLF + "                    Else Z55.Z55_DTCER5 End) DTVENC "
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO) QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        INNER JOIN " + retsqlname("Z55") + " Z55 ON (Z55.Z55_FILIAL = '"+XFilial("Z55")+"' "
		cQry += CRLF + "                                  AND Z55.Z55_CODIGO = SA5.A5_XFAB2 "
		cQry += CRLF + "                                  AND Z55.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_XFAB2    = '"+pCodigo+"' "
		endif

		cQry += CRLF + "          AND ((Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "') "
		cQry += CRLF + "               OR (Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + pData + "') ) "
		cQry += CRLF + "          AND SA5.A5_SITU     <> 'E' "
		cQry += CRLF + "        GROUP BY Z55.Z55_CODIGO "
		cQry += CRLF + "             , Z55.Z55_NOME  "
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
		cQry += CRLF + "        SELECT 'Z55' ENTIDADE  "
		cQry += CRLF + "             , Z55.Z55_CODIGO "
		cQry += CRLF + "             , '' LOJA  "
		cQry += CRLF + "             , Z55.Z55_NOME  "
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "' Then '1o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "' Then '2o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "' Then '3o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "' Then '4o Certificado' "
		cQry += CRLF + "                    Else '5o Certificado' End) CERTIFICADO"
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "' Then Z55.Z55_DTCER1 "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "' Then Z55.Z55_DTCER2 "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "' Then Z55.Z55_DTCER3 "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "' Then Z55.Z55_DTCER4 "
		cQry += CRLF + "                    Else Z55.Z55_DTCER5 End) DTVENC"
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO) QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        INNER JOIN " + retsqlname("Z55") + " Z55 ON (Z55.Z55_FILIAL = '"+XFilial("Z55")+"' "
		cQry += CRLF + "                                  AND Z55.Z55_CODIGO = SA5.A5_XFAB3 "
		cQry += CRLF + "                                  AND Z55.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_XFAB3    = '"+pCodigo+"' "
		endif

		cQry += CRLF + "          AND ((Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "') "
		cQry += CRLF + "               OR (Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + pData + "') ) "
		cQry += CRLF + "          AND SA5.A5_SITU     <> 'E'"
		cQry += CRLF + "        GROUP BY Z55.Z55_CODIGO "
		cQry += CRLF + "             , Z55.Z55_NOME  "
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
		cQry += CRLF + "        SELECT 'Z55' ENTIDADE  "
		cQry += CRLF + "             , Z55.Z55_CODIGO "
		cQry += CRLF + "             , '' LOJA  "                                        
		cQry += CRLF + "             , Z55.Z55_NOME  "
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "' Then '1o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "' Then '2o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "' Then '3o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "' Then '4o Certificado' "
		cQry += CRLF + "                    Else '5o Certificado' End) CERTIFICADO"
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "' Then Z55.Z55_DTCER1 "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "' Then Z55.Z55_DTCER2 "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "' Then Z55.Z55_DTCER3 "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "' Then Z55.Z55_DTCER4 "
		cQry += CRLF + "                    Else Z55.Z55_DTCER5 End) DTVENC"
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO) QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        INNER JOIN " + retsqlname("Z55") + " Z55 ON (Z55.Z55_FILIAL = '"+XFilial("Z55")+"' "
		cQry += CRLF + "                                  AND Z55.Z55_CODIGO = SA5.A5_XFAB4 "
		cQry += CRLF + "                                  AND Z55.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_XFAB4    = '"+pCodigo+"' "
		endif

		cQry += CRLF + "          AND ((Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "') "
		cQry += CRLF + "               OR (Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + pData + "') ) "
		cQry += CRLF + "          AND SA5.A5_SITU     <> 'E' "
		cQry += CRLF + "        GROUP BY Z55.Z55_CODIGO "
		cQry += CRLF + "             , Z55.Z55_NOME  "
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
		cQry += CRLF + "        SELECT 'Z55' ENTIDADE  "
		cQry += CRLF + "             , Z55.Z55_CODIGO "
		cQry += CRLF + "             , '' LOJA  "
		cQry += CRLF + "             , Z55.Z55_NOME  "
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "' Then '1o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "' Then '2o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "' Then '3o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "' Then '4o Certificado' "
		cQry += CRLF + "                    Else '5o Certificado' End) CERTIFICADO"
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "' Then Z55.Z55_DTCER1 "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "' Then Z55.Z55_DTCER2 "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "' Then Z55.Z55_DTCER3 "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "' Then Z55.Z55_DTCER4 "
		cQry += CRLF + "                    Else Z55.Z55_DTCER5 End) DTVENC"
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO) QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        INNER JOIN " + retsqlname("Z55") + " Z55 ON (Z55.Z55_FILIAL = '"+XFilial("Z55")+"' "
		cQry += CRLF + "                                  AND Z55.Z55_CODIGO = SA5.A5_XFAB5 "
		cQry += CRLF + "                                  AND Z55.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_XFAB5    = '"+pCodigo+"' "
		endif

		cQry += CRLF + "          AND ((Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "') "
		cQry += CRLF + "               OR (Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "')  "
		cQry += CRLF + "               OR (Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + pData + "') ) "
		cQry += CRLF + "          AND SA5.A5_SITU     <> 'E' "
		cQry += CRLF + "        GROUP BY Z55.Z55_CODIGO "
		cQry += CRLF + "             , Z55.Z55_NOME "
	endif
	
	cQry += CRLF + " 	) QQ "
	cQry += CRLF + " GROUP BY QQ.ENTIDADE "
	cQry += CRLF + "      , QQ.CODIGO "
	cQry += CRLF + "      , QQ.LOJA "
	cQry += CRLF + "      , QQ.NOME "
	cQry += CRLF + "      , QQ.CERTIFICADO "
	cQry += CRLF + "      , QQ.DTVENC "
	cQry += CRLF + " ORDER BY QQ.ENTIDADE "
	cQry += CRLF + "      , QQ.CODIGO "

	if Select("QVIT626") > 0
		QVIT626->(dbCloseArea())
	endif

	MemoWrite("c:/stephen/Vit626.sql",cQry)
	
	pRecnos := u_CountRegs(cQry,"QVIT626")
	
//RESET ENVIRONMENT	
return(pRecnos)
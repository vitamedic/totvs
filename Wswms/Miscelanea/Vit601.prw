#INCLUDE "Protheus.CH" 
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#INCLUDE "TBICONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} Vit601
Rotina Vit601
JOB/WF Ajuste de Saldo com centesimais

@author Danilo Brito
@since 12/05/2017
@version P11
@param Nao recebe parametros
@return Nil(nulo)
/*/
//------------------------------------------------------------  
User Function Vit601(_cXEmp,_cXFil)  //U_VIT601()
	
	Local nDiasExec //dias para execução após verificação
	Local dUltVerif //data da ultima verificação
	Local nPerVerif //periodicidade de verificação
	Local cMailsEnv //emails destino workflow
	Local cTpMov //tipo de movimento
	Local cQry := ""
	Local cHtml	:= ""
	Local cLinIt := ""
	Local cPict := ""
	Local cCor1 := "#FFFFFF"
	Local cCor2 := "#EFEFEF"
	Local cCorTit := "#ff9494"
	Local nX := 0     
	Local lVerifica := .F.
	Local lExecuta := .F.
	Local lOk := .T.
	Local cDocSD3 := ""
	
	//dados para envio de email
	Local cAccount  := 'chamados'
	Local cEnvia    := 'helpdesk@vitamedic.ind.br'
	Local cServer   := '10.1.1.34'
	Local cPassword := '6Y6GFDcf3h'
	Local cAssunto  := "WF Ajuste Centesimais "+DTOC(dDataBase)+" "+Time()+""
		
	Default _cXEmp 		:= '01' //cEmpAnt
	Default _cXFil 		:= '01' //cFilAnt

	Conout("==>>VIT601: INICIO JOB, AJUSTE CENTESIMAIS DO SALDO : "+DTOC(dDataBase)+" "+Time()+"  <== ")
	
	//preparo ambiente
	If Select("SX2") == 0
		RpcSetType(3)
		Reset Environment
		RpcSetEnv(_cXEmp,_cXFil)
		lJob := .T.
	Endif
	
	nDiasExec := SuperGetMv("MV_XJSEXEC",.F.,1) //default 1 dia
	dUltVerif := SuperGetMv("MV_XJSULTV",.F.,stod(""))
	nPerVerif := SuperGetMv("MV_XJSVERI",.F.,15)   
	cMailsEnv := SuperGetMv("MV_XJSMAIL",.F.,"")   
	cTpMov	  := SuperGetMv("MV_XJSTMOV",.F.,"999") //SAIDA
	cCCMov	  := SuperGetMv("MV_XJSCC",.F.,"") //Centro de custo
	cPict 	  := PesqPict("SBF","BF_QUANT")
	
	if empty(cMailsEnv)
		Conout("==>>VIT601: email nao configurado. Parametro MV_XJSMAIL.")
		Conout("==>>VIT601: FIM JOB, AJUSTE CENTESIMAIS DO SALDO : "+DTOC(dDataBase)+" "+Time()+"  <== ")
		Return
	endif 
	
	if empty(cTpMov)
		Conout("==>>VIT601: tipo de movimento configurado. Parametro MV_XJSTMOV.")
		Conout("==>>VIT601: FIM JOB, AJUSTE CENTESIMAIS DO SALDO : "+DTOC(dDataBase)+" "+Time()+"  <== ")
		Return
	endif 	
	
	if empty(dUltVerif) .OR. (dUltVerif+nPerVerif) == dDataBase //se data vazia ou ultima verificaçao + periodicidade igual a database, deve verificar
		lVerifica := .T.		
	elseif (dUltVerif+nDiasExec) == dDataBase //se data ultima verificaçao + dias execuçao igual database, deve executar
		lExecuta := .T.
	endif	
	
	if !lVerifica .AND. !lExecuta
		Conout("==>>VIT601: Não é dia de alerta ou execução!")
		Conout("==>>VIT601: FIM JOB, AJUSTE CENTESIMAIS DO SALDO : "+DTOC(dDataBase)+" "+Time()+"  <== ")
		Return
	endif
	
	if lExecuta
		BeginTran()
	endif
	
	DbSelectArea("SBF")
	
	cQry := " SELECT * "
	cQry += " FROM " + RetSqlName("SBF") + " "
	cQry += " WHERE D_E_L_E_T_ <> '*' "
	cQry += "   AND BF_QUANT > 0.00 "
	cQry += "   AND BF_QUANT < 0.01 "
	cQry += " ORDER BY BF_FILIAL, BF_LOCAL, BF_LOCALIZ, BF_PRODUTO, BF_NUMSERI, BF_LOTECTL, BF_NUMLOTE " //indice 2
	
	cQry := ChangeQuery(cQry)
	
	if Select("VIT601") > 0
		VIT601->(dbCloseArea())
	endif

	TCQuery cQry New Alias "VIT601"
	
	VIT601->(dbGoTop())
	
	While VIT601->(!eof()) 
        
		nX++
        
		if lExecuta
	  		_aAutoSD3 := {}
			lMsHelpAuto := .F.
			lMsErroAuto := .F.
			
			if empty(cDocSD3)
				cDocSD3 := BuscaDoc()
			else
				cDocSD3 := Soma1(cDocSD3)
			endif
			
			Conout("==>>VIT601: Fazendo movimento interno do produto "+alltrim(VIT601->BF_PRODUTO)+", na quantidade: "+cValtoChar(VIT601->BF_QUANT)+" ...")
			
			aadd (_aAutoSD3, {"D3_TM"		, cTpMov , NIL})
			aadd (_aAutoSD3, {"D3_COD"		, VIT601->BF_PRODUTO , NIL})
            aadd (_aAutoSD3, {"D3_LOCAL"	, VIT601->BF_LOCAL, NIL})
            aadd (_aAutoSD3, {"D3_QUANT"	, VIT601->BF_QUANT, NIL})
            aadd (_aAutoSD3, {"D3_LOTECTL"	, VIT601->BF_LOTECTL, NIL})
            aadd (_aAutoSD3, {"D3_NUMLOTE"	, VIT601->BF_NUMLOTE, NIL})
            aadd (_aAutoSD3, {"D3_LOCALIZ"	, VIT601->BF_LOCALIZ, NIL})
            aadd (_aAutoSD3, {"D3_NUMSERI"	, VIT601->BF_NUMSERI, NIL})
            aadd (_aAutoSD3, {"D3_DOC"		, cDocSD3	, NIL})
            aadd (_aAutoSD3, {"D3_EMISSAO"	,dDataBase , NIL})
            if !empty(cCCMov)
	            aadd (_aAutoSD3, {"D3_CC"  		, cCCMov , NIL})
	  		endif
            aadd (_aAutoSD3, {"D3_OBS"		, "JOB ajuste de saldo centesimais.", NIL})
            
            MsExecAuto({|x,y,z|MATA240(x,y,z)}, _aAutoSD3, 3)
            
            If lMsErroAuto
            	lOk := .F.
            	Conout("==>>VIT601:" + MostraErro("\temp"))
            else
            	Conout("==>>VIT601: Movimento realizado com sucesso! ")
			endif
	  	endif
	  	
	  	cLinIt += '<tr bgcolor="' + iif(nX%2==0,cCor1,cCor2) + '">'
		cLinIt += '<td>'+Alltrim(VIT601->BF_FILIAL)+'</td>'
		cLinIt += '<td>'+Alltrim(VIT601->BF_PRODUTO)+'</td>'
		cLinIt += '<td>'+Alltrim(Posicione("SB1",1,xFilial("SB1")+VIT601->BF_PRODUTO,"B1_DESC"))+'</td>'
		cLinIt += '<td>'+Alltrim(VIT601->BF_LOCAL)+'</td>'
		cLinIt += '<td>'+Alltrim(VIT601->BF_LOCALIZ)+'</td>'
		cLinIt += '<td>'+Alltrim(VIT601->BF_LOTECTL)+'</td>'
		cLinIt += '<td>'+Alltrim(Transform(VIT601->BF_QUANT, cPict))+'</td>'
		if lExecuta
			cLinIt += '<td>'+iif(lOk,"OK","ERRO*")+'</td>'
		endif
		cLinIt += '</tr>'
	  	
	  	lOk := .T.
		VIT601->(dbskip())
	enddo
	
	VIT601->(dbCloseArea())
	
	if lOk
		
		if lVerifica
			cHtml += "<h3>Alerta Ajuste Saldos Centesimais</h3>"
			cHtml += "<hr>"
		else
			cHtml += "<h3>Saldos Centesimais Ajustados</h3>"
			cHtml += "<hr>"
		endif
		
		//imprimindo itens
		if empty(cLinIt)
			cHtml += "<br>"
			cHtml += "<p>N&atilde;o foram encontrados itens de saldo com necessidade de ajuste.</p>"
			cHtml += "<br>"
		else  
			if lVerifica
				cHtml += "<p>Abaixo temos a rela&ccedil;&atilde;o dos saldos que ser&atilde;o ajustados no dia "+DTOC(dDataBase+nDiasExec)+".</p>"
				cHtml += "<br>"
			else
				cHtml += "<p>Abaixo temos a rela&ccedil;&atilde;o dos saldos que foram ajustados no dia "+DTOC(dDataBase)+".</p>"
				cHtml += "<br>"
			endif
			
			cHtml += '<table width="100%" border="0" cellspacing="0" cellpadding="3">'
			cHtml += '<tr bgcolor="'+cCorTit+'">'
			cHtml += '<td>Filial</td>'
			cHtml += '<td>Produto</td>'
			cHtml += '<td>Descricao</td>'
			cHtml += '<td>Armazem</td>'
			cHtml += '<td>Endere&ccedil;o</td>'
			cHtml += '<td>Lote</td>'
			cHtml += '<td>Quantidade</td>'
			if lExecuta
				cHtml += '<td>Status</td>'
			endif
			cHtml += '</tr>' 
			cHtml += cLinIt
			cHtml += '</table>'
		endif  
		if lExecuta
			cHtml += "<br>"
			cHtml += "<p><i>* Quando há erros de execauto os itens são marcados com status de ERRO. Devem ser verificados manualmente.</i></p>"
		endif
		cHtml += "<br>"
		cHtml += "<p><i>Favor n&atilde;o responder este email.</i></p>"
	    
	    //faz conexao servidor email 
	    CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lOK
	    
	    if lOK
			SEND MAIL FROM cEnvia TO cMailsEnv SUBJECT cAssunto BODY cHtml RESULT lOK
			if lOk
				Conout("==>>VIT601: Email enviado com sucesso.")
			else
				Conout("==>>VIT601: Falha no Envio do E-Mail.")
		    	DisarmTransaction()
			endif
	    else
	    	Conout("==>>VIT601: Falha na Conexão com Servidor de E-Mail.")
	    	DisarmTransaction()
		endif
		
		DISCONNECT SMTP SERVER
		
	endif
	
	if lOk .AND. lVerifica
		DbSelectArea("SX6")
		SX6->(DbSetOrder(1)) //X6_FIL+X6_VAR
		if SX6->(dbseek(xFilial("SBF")+"MV_XJSULTV")) .OR. SX6->(dbseek(space(len(SX6->X6_FIL))+"MV_XJSULTV"))
			PUTMV("MV_XJSULTV", dDataBase )
		else
			Reclock("SX6", .T.)
				SX6->X6_FIL := xFilial("SBF")
				SX6->X6_VAR := "MV_XJSULTV"
				SX6->X6_TIPO := "D"
				SX6->X6_DESCRIC := "WF Ajuste Centesimais Saldo: Data da ultima"
				SX6->X6_DESC1 := "verificacao dos saldos por lote por endereco."
				SX6->X6_DESC2 := "Fonte VIT601.prw"
				SX6->X6_CONTEUD := dDataBase
				SX6->X6_PROPRI := "U"
			SX6->(MsUnlock())
		endif
	endif  
	
	if lOk .AND. lExecuta
		EndTran()
	endif
	
	Conout("==>>VIT601: FIM JOB, AJUSTE DECIMAIS DO SALDO : "+DTOC(dDataBase)+" "+Time()+"  <== ")

Return    


Static Function BuscaDoc()

	Local _cLocal	:= getarea()
	Local cCodSD3	:= ""
	Local cQry 		:= ""
	
	cQry := " SELECT MAX(D3_DOC) PROX "
	cQry += " FROM " + RetSqlName("SD3")
	cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"
	cQry += " AND D_E_L_E_T_ <> '*' "
	cQry += " AND D3_DOC LIKE 'JS%' "
	
	If Select("QAUX") > 0
		QAUX->(dbCloseArea())
	EndIf
	
	cQry := ChangeQuery(cQry)
	TcQuery cQry NEW Alias "QAUX" 
	
	If QAUX->(!Eof())
		If Empty(QAUX->PROX)
			cCodSD3 := "JS"+strzero(1, TamSX3("D3_DOC")[1]-2 )
		Else
			cCodSD3 := Soma1(QAUX->PROX)
		EndIf
	Else
		cCodSD3 := "JS"+strzero(1, TamSX3("D3_DOC")[1]-2 )
	EndIf
	
	If Select("QAUX") > 0
		QAUX->(dbCloseArea())
	EndIf
	
	restarea( _cLocal )

Return cCodSD3
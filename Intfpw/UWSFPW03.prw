#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUWSFPW03  บAutor  ณMicrosiga           บ Data ณ  12/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para inclusao de contas a pagar	                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSFPW03(cXml)

	Local lOk := .T.
	Local nX := 0
	Local cRet 		:= ""  
	Local oXMLGet
	Local cMsgErr 	:= ""
	Local cMsgSuss 	:= ""
	Local cError   	:= ""
	Local cWarning 	:= ""	
	Local aCab		:= {} 
	Local dEmissao	:= stod("")
	Local cParcel	:= ""
	PRIVATE lMsErroAuto := .F.
	PRIVATE lMsHelpAuto := .T.
	
	//Gera o Objeto XML para manipula็ใo das informa็๕es
	oXMLGet := XmlParser( cXml, "_", @cError, @cWarning )
	
	If (oXMLGet == NIL ) 
		cMsgErr := "Falha ao gerar Objeto XML: "+cError+" / "+cWarning
		lOk := .F.
	Endif
	
	//Verifica se XML tem a Tag FUNCIONARIO, e passa a trabalhar com ela
	if lOk .AND. (oXMLGet:=XmlChildEx(oXMLGet,"_CONTASPAGAR")) == Nil
		cMsgErr := "Xml com montagem incorreta! Falta tag principal |CONTASPAGAR|"
		lOk := .F.
	endif 
	
	//Verifica se XML tem a Tag ENVIO, e passa a trabalhar com ela
	if lOk .AND. (oXMLGet := XmlChildEx(oXMLGet,"_ENVIO")) == Nil
		cMsgErr := "Xml com montagem incorreta! Falta tag de dados |ENVIO|"
		lOk := .F.
	endif
	
	//Verifica se XML tem a Tag EMPRESA
	if lOk .AND. Type("cEmpAnt")=='U' .AND. (XmlChildEx(oXMLGet,"_EMPRESA")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |EMPRESA|"
		lOk := .F.
	elseif lOk .AND. Type("cEmpAnt")=='U'
		if empty(oXMLGet:_EMPRESA:TEXT)
			cMsgErr := "Campo |EMPRESA| nao preenchido. Campo obrigatorio."
			lOk := .F.
		endif
	endif
	
	//Verifica se XML tem a Tag FILIAL
	if lOk .AND. Type("cFilAnt")=='U' .AND. (XmlChildEx(oXMLGet,"_FILIAL")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |FILIAL|"
		lOk := .F.
	elseif lOk .AND. Type("cFilAnt")=='U'
		if empty(oXMLGet:_FILIAL:TEXT)
			cMsgErr := "Campo |FILIAL| nao preenchido. Campo obrigatorio."
			lOk := .F.
		endif
	endif 

	//se nใo foi configurado WS para ja vir logado na empresa e filial, fa็o cria็ใo do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U' 
		RpcSetType(3)
		lConect := RpcSetEnv(oXMLGet:_EMPRESA:TEXT, oXMLGet:_FILIAL:TEXT)
		if !lConect
			cMsgErr := "Nใo foi possํvel conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif
	
	//Verifica se XML tem a Tag FORNECEDOR
	if lOk .AND. (XmlChildEx(oXMLGet,"_FORNECEDOR")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |FORNECEDOR|"
		lOk := .F.
	elseif lOk
		if empty(oXMLGet:_FORNECEDOR:TEXT)
			cMsgErr := "Campo |FORNECEDOR| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif empty(Posicione("SA2",1,xFilial("SA2")+alltrim(oXMLGet:_FORNECEDOR:TEXT),"A2_COD"))
			cMsgErr := "Fonecedor informado nao foi encontrado no cadastro. "
			lOk := .F.
		endif
	endif
	
	//Verifica se XML tem a Tag LOJA
	if lOk .AND. (XmlChildEx(oXMLGet,"_LOJA")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |LOJA|"
		lOk := .F.
	elseif lOk
		if empty(oXMLGet:_LOJA:TEXT)
			cMsgErr := "Campo |LOJA| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif empty(Posicione("SA2",1,xFilial("SA2")+alltrim(oXMLGet:_FORNECEDOR:TEXT)+alltrim(oXMLGet:_LOJA:TEXT),"A2_COD"))
			cMsgErr := "Fonecedor informado nao foi encontrado no cadastro."
			lOk := .F.
		endif
	endif
	
	//Verifica se XML tem a Tag PREFIXO
	if lOk .AND. (XmlChildEx(oXMLGet,"_PREFIXO")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |PREFIXO|"
		lOk := .F.
	endif
	
	//Verifica se XML tem a Tag NUMERO
	if lOk .AND. (XmlChildEx(oXMLGet,"_NUMERO")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |NUMERO|"
		lOk := .F.
	elseif lOk
		if empty(oXMLGet:_NUMERO:TEXT)
			cMsgErr := "Campo |NUMERO| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif empty(Val(oXMLGet:_NUMERO:TEXT))
			cMsgErr := "Campo |NUMERO| no formato incorreto. Sintaxe: 999999999 (numerico) ."
			lOk := .F.
		endif
	endif
	
	//Verifica se XML tem a Tag TIPO
	if lOk .AND. (XmlChildEx(oXMLGet,"_TIPO")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |TIPO|"
		lOk := .F.
	elseif lOk
		if empty(oXMLGet:_TIPO:TEXT)
			cMsgErr := "Campo |TIPO| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif empty(Posicione("SX5",1,xFilial("SX5")+"05"+alltrim(oXMLGet:_TIPO:TEXT),"X5_CHAVE"))
			cMsgErr := "Tipo de titulo invalido. Consulte tabela de tipos disponiveis."
			lOk := .F.
		endif
	endif
	
	//Verifica se XML tem a Tag PARCELA
	if lOk .AND. (XmlChildEx(oXMLGet,"_PARCELA")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |PARCELA|"
		lOk := .F.
	endif
	
	//Verifica se XML tem a Tag EMISSAO
	if lOk .AND. (XmlChildEx(oXMLGet,"_EMISSAO")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |EMISSAO|"
		lOk := .F.
	elseif lOk
		if !empty(oXMLGet:_EMISSAO:TEXT) .AND. empty(STOD(oXMLGet:_EMISSAO:TEXT))
			cMsgErr := "Campo |EMISSAO| no formato incorreto. Sintaxe: AAAAMMDD."
			lOk := .F.
		endif
	endif   
	
	//Verifica se XML tem a Tag VENCIMENTO
	if lOk .AND. (XmlChildEx(oXMLGet,"_VENCIMENTO")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |VENCIMENTO|"
		lOk := .F.
	elseif lOk
		if empty(oXMLGet:_VENCIMENTO:TEXT)
			cMsgErr := "Campo |VENCIMENTO| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif empty(STOD(oXMLGet:_VENCIMENTO:TEXT))
			cMsgErr := "Campo |VENCIMENTO| no formato incorreto. Sintaxe: AAAAMMDD."
			lOk := .F.
		endif
	endif
	
	//verifica data de vencimento com data de emissao
	if lOk
		dEmissao := iif(empty(oXMLGet:_EMISSAO:TEXT), dDataBase, STOD(oXMLGet:_EMISSAO:TEXT))
		if STOD(oXMLGet:_VENCIMENTO:TEXT) < dEmissao
			cMsgErr := "Data de Vencimento deve ser superior a data de emissao."
			lOk := .F.
		endif
	endif  
	
	//Verifica se XML tem a Tag HISTORICO
	if lOk .AND. (XmlChildEx(oXMLGet,"_HISTORICO")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |HISTORICO|"
		lOk := .F.
	endif
	
	//Verifica se XML tem a Tag NATUREZA
	if lOk .AND. (XmlChildEx(oXMLGet,"_NATUREZA")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |NATUREZA|"
		lOk := .F.
	elseif lOk
		if empty(oXMLGet:_NATUREZA:TEXT)
			cMsgErr := "Campo |NATUREZA| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif empty(Posicione("SED",1,xFilial("SED")+Alltrim(oXMLGet:_NATUREZA:TEXT),"ED_CODIGO"))
			cMsgErr := "Natureza informada nao foi encontrada no cadastro."
			lOk := .F.
		endif
	endif
	
	//Verifica se XML tem a Tag CCUSTO
	if lOk .AND. (XmlChildEx(oXMLGet,"_CCUSTO")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |CCUSTO|"
		lOk := .F.
	elseif lOk .AND. !empty(oXMLGet:_CCUSTO:TEXT) .AND. empty(Posicione("CTT",1,xFilial("CTT")+Alltrim(oXMLGet:_CCUSTO:TEXT),"CTT_CUSTO"))
		cMsgErr := "Centro de Custo informado nao foi encontrado no cadastro."
		lOk := .F.
	endif
	
	//Verifica se XML tem a Tag VALOR
	if lOk .AND. (XmlChildEx(oXMLGet,"_VALOR")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |VALOR|"
		lOk := .F.
	elseif lOk
		if empty(oXMLGet:_VALOR:TEXT)
			cMsgErr := "Campo |VALOR| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif empty(Val(oXMLGet:_VALOR:TEXT))
			cMsgErr := "Campo |VALOR| nao preenchido corretamente. Sintaxe: 99999999.99 (numerico)."
			lOk := .F.
		endif
	endif
	
	//verifica se chave ja existe, e incrementa parcela caso necessario
	if lOk
		cParcel := Padr(oXMLGet:_PARCELA:TEXT,Len(SE2->E2_PARCELA))		
		
		dbSelectArea("SE2")
		dbSetOrder(1)
		lParcOK := .F.
		while !lParcOK 
			if SE2->(dbSeek(xFilial("SE2") +;
							Padr(oXMLGet:_PREFIXO:TEXT,Len(SE2->E2_PREFIXO)) +;
							StrZero(Val(oXMLGet:_NUMERO:TEXT),Len(SE2->E2_NUM)) +;
							cParcel +;
							Padr(oXMLGet:_TIPO:TEXT,Len(SE2->E2_TIPO)) +;
							Padr(oXMLGet:_FORNECEDOR:TEXT,Len(SE2->E2_FORNECE)) +;
							Padr(oXMLGet:_LOJA:TEXT,Len(SE2->E2_LOJA)) ))
							
				cParcel := Soma1(cParcel)
				
				if cParcel == 'Z'      
					cParcel    := Replicate(' ',(Len(SE2->E2_PARCELA)))
					if alltrim(oXMLGet:_PREFIXO:TEXT)='GPE' 
						oXMLGet:_PREFIXO:TEXT := 'GP1'
					else	    
						oXMLGet:_PREFIXO:TEXT := Soma1(oXMLGet:_PREFIXO:TEXT)
					endif 
				endif
			else 
			  lParcOK := .T.	
			endif	
		enddo
		
	endif
	
	if lOK
		
		DbSelectArea("SE2")
		
		aadd( aCab, {"E2_FILIAL"		, xFilial("SE2")      	   								,Nil} )
		aadd( aCab, {"E2_PREFIXO"		, Padr(oXMLGet:_PREFIXO:TEXT,Len(SE2->E2_PREFIXO))		,Nil} )
		aadd( aCab, {"E2_NUM"			, StrZero(Val(oXMLGet:_NUMERO:TEXT),Len(SE2->E2_NUM))	,Nil} )
		aadd( aCab, {"E2_PARCELA"		, cParcel				  								,Nil} )
		aadd( aCab, {"E2_TIPO"			, Padr(oXMLGet:_TIPO:TEXT,Len(SE2->E2_TIPO))			,Nil} )
		aadd( aCab, {"E2_FORNECE"		, Padr(oXMLGet:_FORNECEDOR:TEXT,Len(SE2->E2_FORNECE))	,Nil} )
		aadd( aCab, {"E2_LOJA"	   		, Padr(oXMLGet:_LOJA:TEXT,Len(SE2->E2_LOJA))			,Nil} )
		aadd( aCab, {"E2_NATUREZ"  		, Padr(oXMLGet:_NATUREZA:TEXT,Len(SE2->E2_NATUREZ))		,Nil} )
		aadd( aCab, {"E2_CCD"  	 		, Padr(oXMLGet:_CCUSTO:TEXT,Len(SE2->E2_CCD)) 			,Nil} )
		aadd( aCab, {"E2_EMISSAO"  	 	, dEmissao												,Nil} )
		aadd( aCab, {"E2_VENCTO"  	 	, DataValida(STOD(oXMLGet:_VENCIMENTO:TEXT))			,Nil} )
		aadd( aCab, {"E2_VENCREA"  	 	, DataValida(STOD(oXMLGet:_VENCIMENTO:TEXT))			,Nil} )
		aadd( aCab, {"E2_VALOR"  	 	, Val(oXMLGet:_VALOR:TEXT)								,Nil} )
		aadd( aCab, {"E2_HIST"  	 	, oXMLGet:_HISTORICO:TEXT								,Nil} )
		aadd( aCab, {"E2_MOEDA"	  		, 1														,Nil} )
		aadd( aCab, {"E2_FLUXO"	  		, "S"													,Nil} )
		aadd( aCab, {"E2_LA"  	  		, "S"													,Nil} )
		
		BeginTran()
		
		MSExecAuto( {|x,y| Fina050(x,y)} , aCab, 3) //Inclusao do SE2
		
		If lMsErroAuto 
			cMsgErr := MostraErro("\temp")
			cMsgErr := StrTran(cMsgErr, "<","|")
			cMsgErr := StrTran(cMsgErr, ">","|")
			lOk := .F.
			DisarmTransaction()
		EndIf 

		if lOk
			cMsgSuss := "Titulo a Pagar incluido com sucesso!"
			EndTran()
		endif
		
	endif

	cRet := U_UXmlTag("CONTASPAGAR", ;
				U_UXmlTag("RETORNO",  ;
					U_UXmlTag("SITUACAO", iif(lOk,"OK","ERRO")) + ;
					U_UXmlTag("MSG", iif(lOk,cMsgSuss,cMsgErr)) ;
				, .T.) ;
			, .T.)

Return cRet   



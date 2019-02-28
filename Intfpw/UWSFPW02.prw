#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUWSFPW02  บAutor  ณMicrosiga           บ Data ณ  12/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para contabiliza็ใo de lan็amentos                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSFPW02(oDados, oRet)

	Local lOk := .T.
	Local nX := 0
	Local cMsgErr 	:= ""
	Local cMsgSuss 	:= ""
	Local aCab		:= {}
	Local aItens  	:= {}
	PRIVATE lMsErroAuto := .F.
	
	oRet:SITUACAO 	:= ""
	oRet:MSG	 	:= "" 
	
	if lOk .AND. Type("cEmpAnt")=='U'
		if empty(oDados:EMPRESA)
			cMsgErr := "Campo |EMPRESA| nao preenchido. Campo obrigatorio."
			lOk := .F.
		endif
	endif
	
	//Verifica FILIAL
	if lOk .AND. Type("cFilAnt")=='U'
		if empty(oDados:FILIAL)
			cMsgErr := "Campo |FILIAL| nao preenchido. Campo obrigatorio."
			lOk := .F.
		endif
	endif 

	//se nใo foi configurado WS para ja vir logado na empresa e filial, fa็o cria็ใo do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U' 
		RpcSetType(3)
		lConect := RpcSetEnv(oDados:EMPRESA, oDados:FILIAL)
		if !lConect
			cMsgErr := "Nใo foi possํvel conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif
	
	if lOk
		For nX := 1 to len(oDados:REGISTROS)
			cMsgErr := VldData(oDados:REGISTROS[nX], nX)
			if !empty(cMsgErr)
				lOk := .F.
				exit
			endif
		next nX
	endif
	
	if lOK
		
		DbSelectArea("CT2")
		
		BeginTran()
		
		For nX := 1 to len(oDados:REGISTROS) 
			
			aCab		:= {}
			aItens  	:= {}
			MontaDados(oDados:REGISTROS[nX], @aCab, @aItens)
			
			MSExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)} ,aCab ,aItens, 3)	//inclusao
			
			If lMsErroAuto 
				cMsgErr := MostraErro("\temp")
				cMsgErr := StrTran(cMsgErr, "<","|")
				cMsgErr := StrTran(cMsgErr, ">","|")
				lOk := .F.
				DisarmTransaction()
			EndIf
			
		next nX

		if lOk
			cMsgSuss := "Lan็amentos contabilizados com sucesso!"
			EndTran()
		endif
		
	endif
	
	oRet:SITUACAO 	:= iif(lOk,"OK","ERRO")
	oRet:MSG	 	:= iif(lOk,cMsgSuss,cMsgErr)
	
Return    



//****************************************************************
// Fun็ใo para valida็ใo do objeto DATA do XML
//****************************************************************
Static Function VldData(oData, nSeq)
	
	Local nX
	Local cMsgErr 	:= ""
	Local cSeq 		:= ""
	Local lOk		:= .T.
	Local nTotCred	:= 0
	Local nTotDebt	:= 0
	Default nSeq 	:= 0
	
	cSeq := iif(nSeq>0," Seq.DATA: "+Alltrim(Str(nSeq)),"")
	
	if empty(oData:DATA_MOV)
		cMsgErr := "Campo |DATA_MOV| nao preenchido. Campo obrigatorio."
		lOk := .F.
	elseif empty(STOD(oData:DATA_MOV))
		cMsgErr := "Campo |DATA_MOV| no formato incorreto. Sintaxe: AAAAMMDD."
		lOk := .F.
	else
		cSeq += " DATA: " + oData:DATA_MOV
	endif

	//Verifica  ITEM
	if lOk
		For nX := 1 to len(oData:ITEM)
			cMsgErr := VldItem(oData:ITEM[nX], nX,@nTotCred, @nTotDebt) 
			if !empty(cMsgErr)
				lOk := .F.
				exit
			endif
		next nX	 
	endif
	
	//Valida totais de credito e debito
	if lOk .AND. nTotCred <> nTotDebt
		cMsgErr := "Valor Total Debito diferente do Valor Total Credito."
		lOk := .F.
	endif
	
Return cMsgErr + iif(!empty(cMsgErr),cSeq,"")


//****************************************************************
// Fun็ใo para valida็ใo do objeto ITEM do XML
//****************************************************************
Static Function VldItem(oItem, nSeq, nTotCred, nTotDebt)
	
	Local cMsgErr 	:= ""
	Local cSeq	 	:= ""
	Local cTipo 	:= ""
	Local lOk		:= .T.
	Default nSeq 	:= 0
	
	cSeq := iif(nSeq>0," Seq.ITEMCTB: "+Alltrim(Str(nSeq)),"")
	
	//verifica TIPO
	if empty(oItem:TIPO)
		cMsgErr := "Campo |TIPO| nao preenchido. Campo obrigatorio."
		lOk := .F.
	elseif !(Alltrim(oItem:TIPO) $ "1,2,3")
		cMsgErr := "Campo |TIPO| nao preenchido corretamente. Sintaxe: 1=Debito;2=Credito;3=Partida Dobrada."
		lOk := .F.
	else //tudo ok
		cTipo := Alltrim(oItem:TIPO)
	endif
	
	//Verifica CONTA_DEBITO
	if lOk .AND. cTipo $ '1,3'
		if empty(oItem:CONTA_DEBITO)
			cMsgErr := "Campo |CONTA_DEBITO| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif empty(Posicione("CT1",1,xFilial("CT1")+alltrim(oItem:CONTA_DEBITO),"CT1_CONTA"))
			cMsgErr := "Conta Debito informada nao foi encontrada no cadastro. Cod.Conta: ["+oItem:CONTA_DEBITO+"]"
			lOk := .F.
		endif
	endif 
	
	//Verifica CONTA_CREDITO
	if lOk .AND. cTipo $ '2,3'
		if empty(oItem:CONTA_CREDITO)
			cMsgErr := "Campo |CONTA_CREDITO| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif empty(Posicione("CT1",1,xFilial("CT1")+alltrim(oItem:CONTA_CREDITO),"CT1_CONTA"))
			cMsgErr := "Conta Credito informada nao foi encontrada no cadastro. Cod.Conta: ["+oItem:CONTA_CREDITO+"] "
			lOk := .F.
		endif
	endif
	
	//Verifica CC_DEBITO
	if lOk .AND. !empty(oItem:CC_DEBITO) .AND. empty(Posicione("CTT",1,xFilial("CTT")+Alltrim(oItem:CC_DEBITO),"CTT_CUSTO"))
		cMsgErr := "Centro de Custo Debito  informado nao foi encontrado no cadastro. C.Custo: ["+oItem:CC_DEBITO+"] "  
		lOk := .F.
	elseif lOk .AND. !empty(oItem:CC_DEBITO) .AND. Posicione("CT1",1,xFilial("CT1")+alltrim(oItem:CONTA_DEBITO),"CT1_ACCUST")='2'    //Caso a Conta nใo aceite a entidade, Zera Clแudio 24.01.16
		oItem:CC_DEBITO := ''
	endif 
	
	if lOk .AND. !empty(oItem:CC_CREDITO) .AND. empty(Posicione("CTT",1,xFilial("CTT")+Alltrim(oItem:CC_CREDITO),"CTT_CUSTO"))
		cMsgErr := "Centro de Custo Credito informado nao foi encontrado no cadastro. C.Custo: ["+oItem:CC_CREDITO+"]"
		lOk := .F.
	elseif lOk .AND. !empty(oItem:CC_CREDITO) .AND. Posicione("CT1",1,xFilial("CT1")+alltrim(oItem:CONTA_CREDITO),"CT1_ACCUST")='2'    //Caso a Conta nใo aceite a entidade, Zera Clแudio 24.01.16
		oItem:CC_CREDITO := ''
	endif    
	
	//Verifica  ITEM_CTB_DEBITO
	if lOk .AND. !empty(oItem:ITEM_CTB_DEBITO) .AND. empty(Posicione("CTD",1,xFilial("CTD")+Pad(oItem:ITEM_CTB_DEBITO, TamSX3("CTD_ITEM")[1]),"CTD_ITEM"))
		if !CadITEM_CTB(oItem:ITEM_CTB_DEBITO)
			cMsgErr := "Item Contabil Debito informado nao foi encontrado no cadastro. Item Ctb.: ["+oItem:ITEM_CTB_DEBITO+"]"
			lOk := .F.
		endif
	endif 
	
	//Verifica  ITEM_CTB_CREDITO
	if lOk .AND. !empty(oItem:ITEM_CTB_CREDITO) .AND. empty(Posicione("CTD",1,xFilial("CTD")+Pad(oItem:ITEM_CTB_CREDITO, TamSX3("CTD_ITEM")[1]),"CTD_ITEM"))
		if !CadITEM_CTB(oItem:ITEM_CTB_CREDITO)
			cMsgErr := "Item Contabil Credito informado nao foi encontrado no cadastro. Item Ctb.: ["+oItem:ITEM_CTB_CREDITO+"]"
			lOk := .F.
		endif
	endif
	
	//Verifica CLASSE_VALOR_DEBITO
	if lOk .AND. !empty(oItem:CLASSE_VALOR_DEBITO) .AND. empty(Posicione("CTH",1,xFilial("CTH")+Pad(oItem:CLASSE_VALOR_DEBITO, TamSX3("CTH_CLVL")[1]),"CTH_CLVL"))
		cMsgErr := "Classe Valor Debito informado nao foi encontrado no cadastro. Classe Valor.: ["+oItem:CLASSE_VALOR_DEBITO+"]"
		lOk := .F.
	endif 
	
	//Verifica CLASSE_VALOR_CREDITO
	if lOk .AND. !empty(oItem:CLASSE_VALOR_CREDITO) .AND. empty(Posicione("CTH",1,xFilial("CTH")+Pad(oItem:CLASSE_VALOR_CREDITO, TamSX3("CTH_CLVL")[1]),"CTH_CLVL"))
		cMsgErr := "Classe Valor Credito informado nao foi encontrado no cadastro. Classe Valor.: ["+oItem:CLASSE_VALOR_CREDITO+"]"
		lOk := .F.
	endif
	
	//Verifica HISTORICO
	if lOk .AND. empty(oItem:HISTORICO)
		cMsgErr := "Campo |HISTORICO| nao preenchido. Campo obrigatorio."
		lOk := .F.
	endif
	
	//Verifica VALOR
	if lOk
		if empty(oItem:VALOR)
			cMsgErr := "Campo |VALOR| nao preenchido. Campo obrigatorio."
			lOk := .F.
		else 
			if cTipo == '1' //debito
				nTotDebt += oItem:VALOR
			elseif cTipo == '2' //credito
				nTotCred += oItem:VALOR
			endif
		endif
	endif
	
Return cMsgErr + iif(!empty(cMsgErr),cSeq,"")


//****************************************************************
// Fun็ใo montagem dos arrays do execauto
//****************************************************************
Static Function MontaDados(oData, aCab, aItens)
	
	Local cLoteCtb := SuperGetMv("MV_XLTCBT",,"009090") //lote padrใo para esses lan็amentos

	aadd(aCab,{'DDATALANC' 		,STOD(oData:DATA_MOV) 		,NIL} )
	aadd(aCab,{'CLOTE' 			,cLoteCtb					,NIL} )
	aadd(aCab,{'CSUBLOTE' 		,'001' 						,NIL} )
//	aadd(aCab,{'CDOC' 			,''							,NIL} )
	aadd(aCab,{'CPADRAO' 		,'' 						,NIL} )
	aadd(aCab,{'NTOTINF' 		,0 							,NIL} )
	aadd(aCab,{'NTOTINFLOT' 	,0	 						,NIL} )
	cLinha:='000'	
	For nX := 1 to len(oData:ITEM)
		cLinha:=Soma1(cLinha)
		MontaIt(oData:ITEM[nX], @aItens, cLinha )
		
	next nX

Return     

//****************************************************************
// Fun็ใo montagem dos arrays do execauto (itens)
//****************************************************************
Static Function MontaIt(oItem, aItens, cLinha)
	aAdd(aItens,{	{'CT2_FILIAL'	,xFilial("CT2")  					, NIL},;
      				{'CT2_LINHA'	,cLinha   							, NIL},; 
					{'CT2_MOEDLC'	,'01'   							, NIL},; 
					{'CT2_DC'   	,oItem:TIPO			   				, NIL},;
					{'CT2_DEBITO'	,ValDef(oItem:CONTA_DEBITO)			, NIL},;
					{'CT2_CREDIT'	,ValDef(oItem:CONTA_CREDITO)		, NIL},;
					{'CT2_VALOR'	,oItem:VALOR						, NIL},; 
					{'CT2_CCD'		,ValDef(oItem:CC_DEBITO)			, NIL},; 
					{'CT2_CCC'		,ValDef(oItem:CC_CREDITO)			, NIL},; 
					{'CT2_ITEMD'	,ValDef(oItem:ITEM_CTB_DEBITO)		, NIL},; 
					{'CT2_ITEMC'	,ValDef(oItem:ITEM_CTB_CREDITO)		, NIL},; 
					{'CT2_CLVLDB'	,ValDef(oItem:CLASSE_VALOR_DEBITO)	, NIL},; 
					{'CT2_CLVLCR'	,ValDef(oItem:CLASSE_VALOR_CREDITO)	, NIL},; 
					{'CT2_ORIGEM'	,'WSFPWAUTO'			   			, NIL},;
					{'CT2_HP'		,''   					   			, NIL},;
					{'CT2_HIST'		,ValDef(oItem:HISTORICO)			, NIL} } )

Return  

Static function ValDef(xValor, cTipo)
	
	Default xValor := "" 
	Default cTipo := "C"
	
Return xValor            


Static Function CadITEM_CTB(cCodItem)

	Local lRet := .F.
	
	DbSelectArea("CTD")
	DbSetOrder(1)
	
	if Reclock("CTD", !dbSeek(xFilial("CTD")+Pad(cCodItem, TamSX3("CTD_ITEM")[1])))
	
		CTD->CTD_FILIAL := xFilial("CTD")
		CTD->CTD_ITEM   := cCodItem
		CTD->CTD_CLASSE := "2" //Analํtico
		CTD->CTD_DESC01 := "EVENTO NAO IDENTIFICADO"
		CTD->CTD_BLOQ   := "2" //nใo
		CTD->CTD_DTEXIS := CriaVar("CTD_DTEXIS")
		CTD->CTD_CLOBRG := CriaVar("CTD_CLOBRG")
		CTD->CTD_ACCLVL := CriaVar("CTD_ACCLVL")
	
		CTD->(MsUnlock())
		lRet := .T.
	endif
	
Return lRet

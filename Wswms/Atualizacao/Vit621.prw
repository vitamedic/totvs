#INCLUDE 'PROTHEUS.CH'
#INCLUDE "rwmake.ch"

/*/{Protheus.doc} Vit621
	Faz importação movimentos interno mod2 para ajuste
@author xxx
@since nda
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function Vit621()

    Local bOk 		:= {|| iif(ValidImp(),(oDlgFil:End(),Processa({|| ProcImp() })),) }  
	Local bCancel 	:= {|| oDlgFil:End() }    
	
    Static oDlgFil                    
	Private cTitulo := "Importa Movimentos Interno SD3 - Arquivo"
	Private oArq
	Private cArq	:= ""
	Private oDocSD3	
	Private cDocSD3	:= space(TamSX3("D3_DOC")[1])
	Private oTMSD3	
	Private cTMSD3	:= "508" //space(TamSX3("D3_TM")[1])
	Private oCCSD3	
	Private cCCSD3	:= "29050101 " //space(TamSX3("D3_CC")[1])
	Private oEmiSD3	
	Private dEmiSD3	:= ddatabase
		
	oDlgFil := TDialog():New(0,0,260,700,cTitulo,,,,,,,,,.T.)
		
		TGroup():New(10,10,100,340,'',oDlgFil,,,.T.)
		
		TSay():New( 20,20,{|| "Selecione o Arquivo:" }, oDlgFil,,,,,,.T.,CLR_BLACK,,100,9 )
		oArq := TGet():New( 30, 20, {|u| iif( PCount()==0,cArq,cArq:= u) },oDlgFil,180,9,,/*bValid*/,,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,/*bChange*/,.F.,.F.,,"cArq",,,,.T.,.F.)
		SButton():New( 30, 202, 14, {|| DoSelFile() } ,oDlgFil,.T.,,) 
		
		TSay():New( 60,20,{|| "Numero Documento:" }, oDlgFil,,,,,,.T.,CLR_BLACK,,100,9 )
		@ 70,20 MSGET oDocSD3 VAR cDocSD3 SIZE 80, 010 OF oDlgFil HASBUTTON COLORS 0, 16777215 PIXEL
		
		TSay():New( 60,110,{|| "TM:" }, oDlgFil,,,,,,.T.,CLR_BLACK,,100,9 )
		@ 70,110 MSGET oTMSD3 VAR cTMSD3 SIZE 30, 010 OF oDlgFil HASBUTTON COLORS 0, 16777215 PIXEL
		
		TSay():New( 60,150,{|| "Centro Custo:" }, oDlgFil,,,,,,.T.,CLR_BLACK,,100,9 )
		@ 70,150 MSGET oCCSD3 VAR cCCSD3 SIZE 70, 010 OF oDlgFil HASBUTTON COLORS 0, 16777215 PIXEL
		
		TSay():New( 60,230,{|| "Emissão:" }, oDlgFil,,,,,,.T.,CLR_BLACK,,100,9 )
		@ 70,230 MSGET oEmiSD3 VAR dEmiSD3 SIZE 60, 010 OF oDlgFil HASBUTTON COLORS 0, 16777215 PIXEL WHEN .F.
		
		SButton():New( 110,275,19,bOk,oDlgFil,.T.,,) //avançar
		SButton():New( 110,305,02,bCancel,oDlgFil,.T.,,) //cancelar
		
		oDlgFil:lCentered := .T.
	oDlgFil:Activate()
	

Return

//-------------------------------------------------------------------
// Busca arquivo para importação e valida-o
//-------------------------------------------------------------------
Static Function DoSelFile()

	
	Local cMaskFile := "Arquivos csv (*.csv) |*.CSV | "
	
	cArq := cGetFile(cMaskFile, OemToAnsi("Selecione o arquivo..."), 0, iif(empty(cArq),'C:\',cArq), .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T., .T.)
	
	if empty(cArq)
		cArq := space(300)
	elseif Right(upper(alltrim(cArq)),3) != "CSV"
		MsgStop("Selecione um arquivo do tipo CSV!","ATENCAO")
		cArq := space(300)
	endif
	
	oArq:Refresh()
	
Return

//-------------------------------------------------------------------
// Processa a importação dos dados
//-------------------------------------------------------------------
Static Function ValidImp()

	Local lRet := .T.
	
	if empty(cArq)
		MsgStop("Informe um arquivo para ser importado!","ATENCAO")
		lRet := .F.	
	elseif !File(cArq)
		MsgStop("O arquivo " +cArq + " não foi encontrado. Selecione um arquivo válido!","ATENCAO")
		lRet := .F.
	elseif empty(cDocSD3)
		MsgStop("Informe o Número de Documento","ATENCAO")
		lRet := .F. 
	elseif empty(cTMSD3)
		MsgStop("Informe o TM","ATENCAO")
		lRet := .F.
	elseif empty(cCCSD3)
		MsgStop("Informe o Centro Custo","ATENCAO")
		lRet := .F.
	elseif empty(dEmiSD3)
		MsgStop("Informe o Emissao","ATENCAO")
		lRet := .F.
	EndIf	
	
Return lRet

//-------------------------------------------------------------------
// Processa a importação dos dados
//-------------------------------------------------------------------
Static Function ProcImp()

	Local cLinha    := ''
	Local lPrim     := .T.
	Local aCampos   := {"D3_COD","D3_LOCAL","D3_LOTECTL","D3_LOCALIZ","D3_QUANT"}
	Local aTipos	:= {}
	Local aCpArq	:= {}
	Local aDados    := {}
	Local aExcluir	:= {}
	Local aLog		:= {}
	Local nCampos   := 0
	Local cSQL      := ''
	Local nI 		:= 0
	Local cTipo     := ''
	Local cItem		:= ''
	Local lProc		:= .T.
	Local lLinOK	:= .T.	
	Local aChaves	:= {}
	Local aVetor := {} 
	Local nTotal := 0
	Local nBloqu := 0
	Private lMsErroAuto := .F.  
		
	If !File(cArq)
		MsgStop("O arquivo " + cArq + " não foi encontrado. A importação será abortada!","ATENCAO")
		Return
	EndIf
	
	FT_FUSE(cArq)
	FT_FGOTOP()
	cLinha    := FT_FREADLN()
	aCpArq	  := Separa(cLinha,";",.T.)
	cTipo     := SUBSTR(aCpArq[1],1,2)

	IF !(cTIPO == 'D3')
		MsgAlert('Arquivo com sintaxe incorreta! Primeira linha deve conter o nome dos campos da tabela SD3!')
		Return
	ENDIF
	
	if len(aCpArq) < len(aCampos)
		MsgAlert('Sintaxe do arquivo Incorreta! Deve ter as colunas: D3_COD;D3_LOCAL;D3_LOTECTL;D3_LOCALIZ;D3_QUANT !"')
		Return
	endif
	
	dbSelectArea("SX3")
	DbSetOrder(2)
	For nI := 1 To Len(aCpArq)
		IF cTipo <> SUBSTR(aCpArq[nI],1,2)
			MsgAlert('Todos os campos devem pertencer a tabela SD3!')
			Return
		ENDIF
		IF !SX3->(dbSeek(Alltrim(aCpArq[nI])))
			MsgAlert('Campo não encontrado na tabela SX3: '+aCpArq[nI]+' !')
			Return
		ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
			MsgAlert('Campo marcado na tabela SX3 como visual: '+aCpArq[nI]+' ! Não necessita estar no arquivo de importação!')
			Return
		ELSE
			aadd(aTipos, SX3->X3_TIPO) //gravo o tipo do campo 
		ENDIF
	Next nI
	
	//lendo dados do arquivo, e preenchendo no vetor aDados
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	nI := 1
	While !FT_FEOF()
		IncProc("Lendo arquivo texto... linha: " + cValToChar(nI) )
		cLinha := FT_FREADLN()
		if !empty(cLinha)
			If lPrim
				aCampos := Separa(Upper(cLinha),";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
		endif
		nI++
		FT_FSKIP()
	EndDo
	
	FT_FUSE() //fecha arquivo
	
	aadd(aLog, "------------- Validando dados --------------------")
	
	ProcRegua(Len(aDados))
	For nI:=1 to  Len(aDados)
		lLinOK	:= .T.
		cLinha := 'Linha ' + cValToChar(nI+1) + ' >> '
		
		IncProc("Validando dados... linha: " + cValToChar(nI+1))
		
		if len(aCampos) <> len(aDados[nI])		
			lLinOK := .F.
			cLog := 'Linha não está estruturada corretamente.'
			aadd(aLog, cLinha+cLog)
		endif
		
		if lLinOK
			For nCampos := 1 To Len(aCampos)
				
				aDados[nI][nCampos] := AjustaVal(aDados[nI][nCampos], aTipos[nCampos], aCampos[nCampos] )
				
	   			//{"D3_COD","D3_LOCAL","D3_LOTECTL","D3_LOCALIZ","D3_QUANT"}
				if nCampos == aScan(aCampos,"D3_COD")
					if empty(Posicione("SB1",1,xFilial("SB1")+aDados[nI][nCampos],"B1_COD"))
						cLog := 'Inconsistência: Código Produto não cadastrado ['+aDados[nI][nCampos]+'] !'
						aadd(aLog, cLinha+cLog)
						lLinOK := .F.
					endif
				Endif
							
			Next nCampos
			
			//BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
			cChave := aDados[nI][aScan(aCampos,"D3_LOCAL")] + aDados[nI][aScan(aCampos,"D3_LOCALIZ")] + aDados[nI][aScan(aCampos,"D3_COD")] + Space(TamSx3("BF_NUMSERI")[1]) + aDados[nI][aScan(aCampos,"D3_LOTECTL")]
			
			//valida preenchimento dos dois campos (produto e grupo)
			if empty(Posicione("SBF",1,xFilial("SBF")+cChave,"BF_PRODUTO"))
				cLog := 'Inconsistência: Não localizada o saldo por endereço (SBF)!'
				aadd(aLog, cLinha+cLog)
				lLinOK := .F.
			endif
		endif
		
		aadd(aDados[nI], lLinOK)
		
	Next nI

	aadd(aLog, "------------- Iniciando Gravações dos Dados --------------------")
	
	//inicia gravação dos dados
	if lProc .AND. MsgYesNo("Confirma inicio gravação?")
				
		cLog := 'Iniciando Gravações dos Dados...'
		aadd(aLog, cLog)
		
		BeginTran()
		
		_aCab1 := { {"D3_DOC" 		,cDocSD3 , NIL},;
					{"D3_TM" 		,cTMSD3, NIL},;
					{"D3_CC" 		,cCCSD3, NIL},;
					{"D3_EMISSAO" 	,dEmiSD3, NIL} } 
		
		_atotitem := {}
		
		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)
			
			cLinha := 'Linha ' + cValToChar(nI+1) + ' >> '
			nTotal++
			
			if aDados[nI][len(aDados[nI])] //se linha ok
			
				IncProc("Processando Gravações...")
				
				if aDados[nI][aScan(aCampos,"D3_QUANT")] > 0
					
					_aItem:={ 	{"D3_COD" 	,aDados[nI][aScan(aCampos,"D3_COD")] ,NIL},;
								{"D3_QUANT" ,aDados[nI][aScan(aCampos,"D3_QUANT")],NIL},; 
								{"D3_LOCAL" ,aDados[nI][aScan(aCampos,"D3_LOCAL")] ,NIL},;
								{"D3_LOTECTL" ,aDados[nI][aScan(aCampos,"D3_LOTECTL")],NIL},;
								{"D3_LOCALIZ" ,aDados[nI][aScan(aCampos,"D3_LOCALIZ")],NIL} }
					
					aadd(_atotitem,_aitem)  
					
					aadd(aLog, cLinha + "Adicionado ao array execauto!") //com mensagem feita acima, no DbSeek
				else
					aadd(aLog, cLinha + "Não importado por Quantidade Negativa") //com mensagem feita acima, no DbSeek
				endif
			else 
				aadd(aLog, cLinha + "Linha ignorada, pois não passou na validação!") //com mensagem feita acima, no DbSeek
			endif
			
		Next nI	
		
		if !empty(_atotitem)
			
			MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
					
			if !lMsErroAuto
				cLog := "Importado movimentos COM SUCESSO >> Indice 1: " + SD3->(&(IndexKey(1))) 
				aadd(aLog,cLog )
			else
				MostraErro()
				aadd(aLog, "Erro execauto") //com mensagem feita acima, no DbSeek
			endif  
		endif
		 
		cLog := 'Processo finalizado com sucesso!'
		aadd(aLog, cLog)
		
		//cLog := 'Total Reg: ' + cvaltochar(nTotal) + "      Bloqueados Sucesso: " + cvaltochar(nBloqu) + "      Não Bloqueiados: " + cvaltochar(nTotal-nBloqu)
		//aadd(aLog, cLog)
		
		if MsgYesNo("Confirma transação?")
			EndTran() 
		else
			DisarmTransaction() 
			cLog := 'Processo desfeito pelo usuário!'
			aadd(aLog, cLog)
		endif
		
	endif
	
	if lProc
		if MsgYesNo('Arquivo processado! Deseja ver arquivo de LOG?')
			ShowLog(aLog)
		endif
	else
		if MsgYesNo('Arquivo não processado por erros! Deseja ver arquivo de LOG?')
			ShowLog(aLog)
		endif
	endif

Return 

//-------------------------------------------------------------------
// Faz ajustedo valor de acordo com tipo
//-------------------------------------------------------------------
Static Function AjustaVal(xValor, cTipo, cCampo)

	if cCampo == "D3_LOCAL"
		xValor := PadL(xValor, TamSx3(cCampo)[1], "0")
	elseif cTipo == "C"
		xValor := PadR(xValor, TamSx3(cCampo)[1])
	elseif cTipo == "N"
		xValor := Val(StrTran(StrTran(xValor,".",""),",","."))
	endif
	
Return xValor

//-------------------------------------------------------------------
// Relatório de impressão de log
//-------------------------------------------------------------------
Static Function ShowLog(aLog)

	Local oReport := TReport():New("RFINL003","Log de Importação de Arquivo Movimentos",/*SX1*/,{|oReport| PrintReport(oReport, aLog)},"Este relatorio ira imprimir a relacao de logs de importação de arquivo de Movimentos.") 
	Local oSection := TRSection():New(oReport,OemToAnsi("Log de Importação Arquivos"),{"TMP"})	
	
	TRCell():New(oSection,"ITEMLOG"	,"TMP", "Descricao do Log", ,200)
	
	//oReport:PrintDialog()
	oReport:Print()	

Return	

//-------------------------------------------------------------------
// Relatório de impressão de log
//-------------------------------------------------------------------	
Static Function PrintReport(oReport, aLog)

	Local oSection 	:= oReport:Section(1)
	Local nX 		:= 1
	
	oReport:SetMeter(len(aLog))
	
	oSection:Init()
	
	For nX := 1 to len(aLog)
		
		If oReport:Cancel()
			Exit
		EndIf
		
		oSection:Cell("ITEMLOG"):SetValue(aLog[nX])
		oSection:PrintLine()
		
		oReport:IncMeter()
	Next nX
	
	oSection:Finish()

Return

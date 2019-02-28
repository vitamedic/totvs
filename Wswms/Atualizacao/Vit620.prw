#INCLUDE 'PROTHEUS.CH'
#INCLUDE "rwmake.ch"

/*/{Protheus.doc} Vit620
	Faz importação dos dados de bloqueio de lotes por arquivo CSV
@author xxx
@since nda
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function Vit620()

    Local bOk 		:= {|| iif(ValidImp(),(oDlgFil:End(),Processa({|| ProcImp() })),) }  
	Local bCancel 	:= {|| oDlgFil:End() }    
	
    Static oDlgFil                    
	Private cTitulo := "Bloqueio Lotes - Arquivo"
	Private oArq
	Private cArq	:= ""
	Private oTipo	
	Private nTipo	:= 0
	Private aTipos	:= {}
		
	oDlgFil := TDialog():New(0,0,260,700,cTitulo,,,,,,,,,.T.)
		
		TGroup():New(10,10,100,340,'',oDlgFil,,,.T.)
		
		TSay():New( 20,20,{|| "Selecione o Arquivo:" }, oDlgFil,,,,,,.T.,CLR_BLACK,,100,9 )
		oArq := TGet():New( 30, 20, {|u| iif( PCount()==0,cArq,cArq:= u) },oDlgFil,180,9,,/*bValid*/,,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,/*bChange*/,.F.,.F.,,"cArq",,,,.T.,.F.)
		SButton():New( 30, 202, 14, {|| DoSelFile() } ,oDlgFil,.T.,,) //avançar
		
		TSay():New( 60,20,{|| "Tipo Execução:" }, oDlgFil,,,,,,.T.,CLR_BLACK,,100,9 )
		aadd(aTipos, "Bloqueio")
		aadd(aTipos, "Liberação")
		oTipo := TRadMenu():New(70,20,aTipos,{|u| iif( PCount()==0,nTipo,nTipo:= u) },oDlgFil,,,,,,,,300,12,,,,.T.)
		
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
	elseif empty(nTipo)
		MsgStop("Selecione o tipo de importação!","ATENCAO")
		lRet := .F.
	EndIf	
	
Return lRet

//-------------------------------------------------------------------
// Processa a importação dos dados
//-------------------------------------------------------------------
Static Function ProcImp()

	Local cLinha    := ''
	Local lPrim     := .T.
	Local aCampos   := {"DD_PRODUTO","DD_LOCAL","DD_LOTECTL","DD_LOCALIZ","DD_QUANT"}
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

	IF !(cTIPO == 'DD')
		MsgAlert('Arquivo com sintaxe incorreta! Primeira linha deve conter o nome dos campos da tabela SDD!')
		Return
	ENDIF
	
	if len(aCpArq) < len(aCampos)
		MsgAlert('Sintaxe do arquivo Incorreta! Deve ter as colunas: DD_PRODUTO;DD_LOCAL;DD_LOTECTL;DD_LOCALIZ;DD_QUANT !"')
		Return
	endif
	
	dbSelectArea("SX3")
	DbSetOrder(2)
	For nI := 1 To Len(aCpArq)
		IF cTipo <> SUBSTR(aCpArq[nI],1,2)
			MsgAlert('Todos os campos devem pertencer a tabela SDD!')
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
				
	                //{"DD_PRODUTO","DD_LOCAL","DD_LOTECTL","DD_LOCALIZ","DD_QUANT"}
				if nCampos == aScan(aCampos,"DD_PRODUTO")
					if empty(Posicione("SB1",1,xFilial("SB1")+aDados[nI][nCampos],"B1_COD"))
						cLog := 'Inconsistência: Código Produto não cadastrado ['+aDados[nI][nCampos]+'] !'
						aadd(aLog, cLinha+cLog)
						lLinOK := .F.
					endif
				Endif
							
			Next nCampos
			
			//BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
			cChave := aDados[nI][aScan(aCampos,"DD_LOCAL")] + aDados[nI][aScan(aCampos,"DD_LOCALIZ")] + aDados[nI][aScan(aCampos,"DD_PRODUTO")] + Space(TamSx3("BF_NUMSERI")[1]) + aDados[nI][aScan(aCampos,"DD_LOTECTL")]
			
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
		
		cPfxDoc := "LX"
		nTamPfx := 2 
		
		BeginTran()
		
		//processa exclusões
		if nTipo == 1 //Bloqueio
			
			cDocDD := cPfxDoc+StrZero(1, (6-nTamPfx))  //"BI0001"
			DbSelectArea("SDD")
			SDD->(dBSetOrder(1)) //DD_FILIAL+DD_DOC+DD_PRODUTO+DD_LOCAL+DD_LOTECTL+DD_NUMLOTE
			While Dbseek(xFilial("SDD")+cDocDD )
				cDocDD := Soma1(cDocDD)
			enddo
			
			ProcRegua(Len(aDados))
			For nI:=1 to  Len(aDados)
				
				cLinha := 'Linha ' + cValToChar(nI+1) + ' >> '
				nTotal++
				
				if aDados[nI][len(aDados[nI])] //se linha ok
				
					IncProc("Processando Gravações...")
					
					aVetor := {}          
					lMsErroAuto := .F. 
					cDocDD := Soma1(cDocDD) 
					
					if aDados[nI][aScan(aCampos,"DD_QUANT")] > 0
						DbSelectArea("SDD")
						SDD->(dBSetOrder(1)) //DD_FILIAL+DD_DOC+DD_PRODUTO+DD_LOCAL+DD_LOTECTL+DD_NUMLOTE
						While Dbseek(xFilial("SDD")+cDocDD )
							cDocDD := Soma1(cDocDD)
						enddo     
						
						aVetor := {;                
							{"DD_DOC"		,cDocDD 									,NIL},;
							{"DD_PRODUTO" 	,aDados[nI][aScan(aCampos,"DD_PRODUTO")]	,NIL},;
							{"DD_LOCAL" 	,aDados[nI][aScan(aCampos,"DD_LOCAL")] 		,NIL},;    
							{"DD_LOTECTL"	,aDados[nI][aScan(aCampos,"DD_LOTECTL")]	,NIL},;    
							{"DD_LOCALIZ"	,aDados[nI][aScan(aCampos,"DD_LOCALIZ")]	,NIL},;    
							{"DD_QUANT"		,aDados[nI][aScan(aCampos,"DD_QUANT")]		,NIL},;
							{"DD_MOTIVO"	,"ND"										,NIL},;
							{"DD_DTBLOQ"	,dDataBase									,NIL},;
							{"DD_OBSERVA"	,"ULTIMO EXECUTADO 26/6"			   				,Nil}}
						 
						MSExecAuto({|x, y| mata275(x, y)}, aVetor, 3)
						
						if !lMsErroAuto
							cLog := "BLOQUEADO COM SUCESSO >> Indice 1: " + SDD->(&(IndexKey(1))) 
							aadd(aLog, cLinha + cLog)
							nBloqu++
						else
							MostraErro()
							aadd(aLog, cLinha + "Erro execauto") //com mensagem feita acima, no DbSeek
						endif   
					else
						aadd(aLog, cLinha + "Não bloqueado por Quantidade Negativa") //com mensagem feita acima, no DbSeek
					endif
				else 
					aadd(aLog, cLinha + "Linha ignorada, pois não passou na validação!") //com mensagem feita acima, no DbSeek
				endif
				
			Next nI	
				
		endif
		 
		if nTipo == 2 //Libera 
			
			ProcRegua(Len(aDados))
			For nI:=1 to  Len(aDados)
				
				cLinha := 'Linha ' + cValToChar(nI+1) + ' >> '
				nTotal++
				lAchouDD := .F.
				
				if aDados[nI][len(aDados[nI])] //se linha ok
				
					IncProc("Processando Gravações...")
					
					aVetor := {} 
					lMsErroAuto := .F. 
                    
                    //Posicionando
                    SDD->(DbSetOrder(2)) //DD_FILIAL+DD_PRODUTO+DD_LOCAL+DD_LOTECTL+DD_NUMLOTE+DD_MOTIVO         
                    cChavDD := xFilial("SDD")+aDados[nI][aScan(aCampos,"DD_PRODUTO")]+aDados[nI][aScan(aCampos,"DD_LOCAL")]+aDados[nI][aScan(aCampos,"DD_LOTECTL")]
					if SDD->(DbSeek(cChavDD ))
						While SDD->(!Eof()) .AND. SDD->(DD_FILIAL+DD_PRODUTO+DD_LOCAL+DD_LOTECTL) == cChavDD
						
							if SDD->DD_MOTIVO == "ND" .AND. SDD->DD_LOCALIZ == aDados[nI][aScan(aCampos,"DD_LOCALIZ")] .AND. SubStr(SDD->DD_DOC,1,nTamPfx) $ "LX,BI,BDI" .AND. SDD->DD_SALDO > 0
                            	
                            	lAchouDD := .T.
                            	EXIT
                            	
							endif
							
							SDD->(DbSkip())
						enddo
					endif
					
					if lAchouDD
						
						aVetor := {;                
							{"DD_DOC"		,SDD->DD_DOC	,NIL},;
							{"DD_PRODUTO" 	,aDados[nI][aScan(aCampos,"DD_PRODUTO")]	,NIL},;
							{"DD_LOCAL" 	,aDados[nI][aScan(aCampos,"DD_LOCAL")] 		,NIL},;    
							{"DD_LOTECTL"	,aDados[nI][aScan(aCampos,"DD_LOTECTL")]	,NIL},;    
							{"DD_LOCALIZ"	,aDados[nI][aScan(aCampos,"DD_LOCALIZ")]	,NIL},;    
							{"DD_QUANT"		,aDados[nI][aScan(aCampos,"DD_QUANT")]		,NIL},;
							{"DD_MOTIVO"	,"ND"										,NIL}}
						 
						MSExecAuto({|x, y| mata275(x, y)}, aVetor, 4)
						
						if !lMsErroAuto
							cLog := "LIBERADO COM SUCESSO >> Indice 1: " + SDD->(&(IndexKey(1))) 
							aadd(aLog, cLinha + cLog)
							nBloqu++
						else
							MostraErro()
							aadd(aLog, cLinha + "Erro execauto") //com mensagem feita acima, no DbSeek
						endif   
					else
						aadd(aLog, cLinha + "Não encontrado item de bloqueio na SDD") //com mensagem feita acima, no DbSeek
					endif
				else 
					aadd(aLog, cLinha + "Linha ignorada, pois não passou na validação!") //com mensagem feita acima, no DbSeek
				endif
				
			Next nI
			
			
		endif
		
		cLog := 'Processo finalizado com sucesso!'
		aadd(aLog, cLog)
		
		cLog := 'Total Reg: ' + cvaltochar(nTotal) + "      Liberados Sucesso: " + cvaltochar(nBloqu) + "      Não Liberados: " + cvaltochar(nTotal-nBloqu)
		aadd(aLog, cLog)
		
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

	if cCampo == "DD_LOCAL"
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

	Local oReport := TReport():New("RFINL003","Log de Importação de Arquivo Bloqueio",/*SX1*/,{|oReport| PrintReport(oReport, aLog)},"Este relatorio ira imprimir a relacao de logs de importação de arquivo de bloqueio.") 
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

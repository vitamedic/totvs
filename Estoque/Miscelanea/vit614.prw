#Include 'Protheus.ch'
#INCLUDE "topconn.ch"

//compatibilizar campos numericos e tabelas
User Function VIT614() //U_VIT614()
	
	//dimensionamento de tela e componentes
	Local aSize 	:= MsAdvSize() // Retorna a área útil das janelas Protheus 
	Local aInfo 	:= {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
	Local aPObj 	:= MsObjSize(aInfo, {{ 100, 100, .T., .T.}, { 100, 000, .T., .F.}})
	
	Private cCadastro := "Ajuste Campos Numericos"
	Private nVendSel := 1
	
	Private oDlgSX3
	Private oListTab
	Private oGridCpo
	                    
	Private nInteiro := 16
	Private nDecimal := 5
	Private cMascara := "@E 9,999,999,999.99999                                "
	Private aTables := {"SB2","SB6","SB7","SB8","SB9","SBJ","SBK","SBC","SBF","SC1","SC2","SC5","SC6","SC7","SC8","SC9","SCP","SCQ","SD1","SD2","SD3","SD4","SD5","SD7","SDA","SDB","SDC","SDD","SB1"}
	
	DEFINE MSDIALOG oDlgSX3 TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] PIXEL 
	
	TSay():New( aPObj[1,1]+3,aPObj[1,2]+10,{|| "Tamanho" }, oDlgSX3,,,,,,.T.,CLR_BLACK,,100,9 )
	TGet():New( aPObj[1,1],aPObj[1,2]+50,{|u| iif( PCount()==0,nInteiro,nInteiro:= u) },oDlgSX3,40,12,,{|| VldMask() }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,/*bChange*/,.F.,.F.,,"",,,,.T.,.F.)
	
	TSay():New( aPObj[1,1]+3,aPObj[1,2]+110,{|| "Decimal" }, oDlgSX3,,,,,,.T.,CLR_BLACK,,100,9 )
	TGet():New( aPObj[1,1],aPObj[1,2]+150,{|u| iif( PCount()==0,nDecimal,nDecimal:= u) },oDlgSX3,40,12,,{|| VldMask() }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,/*bChange*/,.F.,.F.,,"",,,,.T.,.F.)
	
	TSay():New( aPObj[1,1]+3,aPObj[1,2]+210,{|| "Picture" }, oDlgSX3,,,,,,.T.,CLR_BLACK,,100,9 )
	TGet():New( aPObj[1,1],aPObj[1,2]+250,{|u| iif( PCount()==0,cMascara,cMascara:= u) },oDlgSX3,100,12,,{|| VldMask() }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,/*bChange*/,.F.,.F.,,"",,,,.T.,.F.)
	
	TSay():New( aPObj[1,1]+20,aPObj[1,2],{|| "Tabelas" }, oDlgSX3,,,,,,.T.,,,200,15 )
	TSay():New( aPObj[1,1]+20,aPObj[1,2],{|| Replicate("_",100) }, oDlgSX3,,,,,,.T.,,,100,15 )
	oListTab := TListBox():New(aPObj[1,1]+30, aPObj[1,2],{|u| iif(Pcount()>0,nVendSel:=u,nVendSel)},aTables,100,aPObj[1,3]-50,{|| CarregaGrid() },oDlgSX3,,,,.T.)
	
	TSay():New( aPObj[1,1]+20,aPObj[1,2]+110,{|| "Campos Numericos" }, oDlgSX3,,,,,,.T.,,,200,15 )
	TSay():New( aPObj[1,1]+20,aPObj[1,2]+110,{|| Replicate("_",aPObj[1,4]-110) }, oDlgSX3,,,,,,.T.,,,aPObj[1,4]-110,15 )
	oGridCpo := DoGridCpo(oDlgSX3, aPObj[1,1]+30, aPObj[1,2]+110, aPObj[1,3]-20, aPObj[1,4])	
	bSvblDb5 := oGridCpo:oBrowse:bLDblClick
	oGridCpo:oBrowse:bLDblClick := {|| if(oGridCpo:oBrowse:nColPos!=0, CLIQUE5(), GdRstDblClick(@oGridCpo, @bSvblDb5))}	
	
	nCol := 0
	nTam := 60 
	TButton():New( aPObj[1,3]-10, aPObj[1,2]+nCol, "Backup Tabela", oDlgSX3,{|| MsAguarde({|| DoBackup() },"Aguarde...","Fazendo backup...",.F.) }, nTam,14,,,.F.,.T.,.F.,,.F.,,,.F. )
	nCol += nTam+5
	nTam := 60
	TButton():New( aPObj[1,3]-10, aPObj[1,2]+nCol, "Compat. Tamanhos", oDlgSX3,{|| MsAguarde({|| CompatSX3(.F.) },"Aguarde...","Compatibilizando...",.F.) }, nTam,14,,,.F.,.T.,.F.,,.F.,,,.F. )	
	nCol += nTam+5 
	nTam := 60
	TButton():New( aPObj[1,3]-10, aPObj[1,2]+nCol, "Compat. Picture", oDlgSX3,{|| MsAguarde({|| CompatSX3(.T.) },"Aguarde...","Compatibilizando...",.F.) }, nTam,14,,,.F.,.T.,.F.,,.F.,,,.F. )
	nCol += nTam+5 
	nTam := 60
	TButton():New( aPObj[1,3]-10, aPObj[1,2]+nCol, "Drop Tabela", oDlgSX3,{|| MsAguarde({|| DoDrop() },"Aguarde...","Excluindo tabela...",.F.) }, nTam,14,,,.F.,.T.,.F.,,.F.,,,.F. )
	nCol += nTam+5 
	nTam := 60
	TButton():New( aPObj[1,3]-10, aPObj[1,2]+nCol, "Append Dados", oDlgSX3,{|| MsAguarde({|| DoAppend() },"Aguarde...","Fazendo Append dos dados...",.F.) }, nTam,14,,,.F.,.T.,.F.,,.F.,,,.F. )
	nCol += nTam+5 
	nTam := 60
	TButton():New( aPObj[1,3]-10, aPObj[1,2]+nCol, "Append Autom.", oDlgSX3,{|| DoAppAuto() }, nTam,14,,,.F.,.T.,.F.,,.F.,,,.F. )
	nCol += nTam+5 
	nTam := 40
	TButton():New( aPObj[1,3]-10, aPObj[1,2]+nCol, "Sair", oDlgSX3,{|| oDlgSX3:End() }, nTam,14,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	
	CarregaGrid(aTables[1])
	
	oDlgSX3:lCentered := .T.
	oDlgSX3:Activate()
	
Return lRet


//---------------------------------------------------------
// Monta Grid de Notas Fiscais
//---------------------------------------------------------
Static Function DoGridCpo(oDlg, nTop, nLeft, nBottom, nRight)

	Local aHeaderEx    := {}
	Local aColsEx      := {}
	Local aFieldFill   := {}
	Local aAlterFields := {}
	Local nLinMax 	   := 999  // Quantidade de linha na getdados
	
	Aadd(aHeaderEx,{'','MARK','@BMP',2,0,'','€€€€€€€€€€€€€€','C','','','',''})
	Aadd(aFieldFill,"LBNO")
	Aadd(aHeaderEx,{"CAMPO","CAMPO","@!",10,0,"","","C","","","",""})
	Aadd(aFieldFill, space(10)) 
	Aadd(aHeaderEx,{"TITULO","TITULO","",12,0,"","","C","","","",""})
	Aadd(aFieldFill, space(10)) 
	Aadd(aHeaderEx,{'','LEG1','@BMP',2,0,'','€€€€€€€€€€€€€€','C','','','',''})
	Aadd(aFieldFill,"BR_BRANCO")
	Aadd(aHeaderEx,{"TAMANHO","TAMANHO","@E 999",3,0,"","","N","","","",""})
	Aadd(aFieldFill,0) 
	Aadd(aHeaderEx,{'','LEG2','@BMP',2,0,'','€€€€€€€€€€€€€€','C','','','',''})
	Aadd(aFieldFill,"BR_BRANCO")
	Aadd(aHeaderEx,{"DECIMAL","DECIMAL","@E 9",1,0,"","","N","","","",""})
	Aadd(aFieldFill,0)  
	Aadd(aHeaderEx,{'','LEG3','@BMP',2,0,'','€€€€€€€€€€€€€€','C','','','',''})
	Aadd(aFieldFill,"BR_BRANCO") 
	Aadd(aHeaderEx,{"PICTURE ATUAL","PICTURE1","",45,0,"","","C","","","",""})
	Aadd(aFieldFill, space(45))
	Aadd(aHeaderEx,{"PICTURE CORRETA","PICTURE2","",45,0,"","","C","","","",""})
	Aadd(aFieldFill, space(45))
	
	Aadd(aFieldFill,.F.) //deletado
	
	Aadd(aColsEx, aFieldFill)	

Return MsNewGetDados():New( nTop, nLeft, nBottom, nRight, , "AllwaysTrue", "AllwaysTrue", "AllwaysTrue",;
							aAlterFields, , nLinMax, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)
    
//------------------------------------------------
Static Function clique5()

	If len(oGridCpo:aCols) == 0
		Return()
	Endif
	
	If oGridCpo:aCols[oGridCpo:NAT][aScan(oGridCpo:aHeader,{|x| AllTrim(x[2])=="MARK"})] == "LBOK"
		oGridCpo:aCols[oGridCpo:NAT][aScan(oGridCpo:aHeader,{|x| AllTrim(x[2])=="MARK"})] := "LBNO"
	Else
		oGridCpo:aCols[oGridCpo:NAT][aScan(oGridCpo:aHeader,{|x| AllTrim(x[2])=="MARK"})] := "LBOK"
	Endif
	
	oGridCpo:oBrowse:REFRESH()

Return

//---------------------------------------------------------
// Carrega Grid conforme vendedor selecionado
//---------------------------------------------------------
Static Function CarregaGrid(cTabAtu)

	Local nX
	Default cTabAtu := aTables[oListTab:nAt]
	
	oGridCpo:aCols := {}
	
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(Dbseek(cTabAtu))
	while SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == cTabAtu
		
		if SX3->X3_TIPO == "N" 

			aadd(oGridCpo:aCols, { ; 
				"LBNO",; 
				SX3->X3_CAMPO ,; 
				SX3->X3_TITULO ,;
				RetLegX3(1) ,; 
				SX3->X3_TAMANHO ,; 
				RetLegX3(2) ,; 
				SX3->X3_DECIMAL ,; 
				RetLegX3(3) ,; 
				SX3->X3_PICTURE ,; 
				Mascara(SX3->X3_TAMANHO, SX3->X3_DECIMAL) ,;
			.F.})
			
		endif
		
		SX3->(dbSkip())
	enddo
	
	oGridCpo:Refresh()
	oGridCpo:GoTo(1) //vai para primeira linha
	
Return

//---------------------------------------------------------
// verifica legenda. nTipo 1=TAMANHO; 2=DECIMAL; 3=PICTURE
//---------------------------------------------------------
Static Function RetLegX3(nTipo)
	
	Local cRet := "BR_VERDE"
	
	if nTipo==1 .AND. SX3->X3_TAMANHO <> nInteiro
		cRet := "BR_VERMELHO"
	endif 
	
	if nTipo==2 .AND. SX3->X3_DECIMAL <> nDecimal
		cRet := "BR_VERMELHO"
	endif
	
	if nTipo==3 .AND. !(Alltrim(SX3->X3_PICTURE)==alltrim(Mascara(SX3->X3_TAMANHO, SX3->X3_DECIMAL)))
		cRet := "BR_VERMELHO"
	endif
	
Return cRet

//---------------------------------------------------------
// compatibiliza SX3
//---------------------------------------------------------
Static Function CompatSX3(lSoMask)
      
	Local cTabAtu := aTables[oListTab:nAt] 
	Local nX := 0
	
	if MsgYesNo("Confirma atualização dos campos marcados da tabela "+cTabAtu+"")
		
		for nX := 1 to len(oGridCpo:aCols)
			
			if oGridCpo:aCols[nX][1] == "LBOK"
				
				dbSelectArea("SX3")
				SX3->(dbSetOrder(2))
				if SX3->(Dbseek(oGridCpo:aCols[nX][2]))
					Reclock("SX3", .F.) 
						if lSoMask
							SX3->X3_PICTURE := Mascara(SX3->X3_TAMANHO, SX3->X3_DECIMAL)
						else
							SX3->X3_TAMANHO := nInteiro
							SX3->X3_DECIMAL := nDecimal
							SX3->X3_PICTURE := Alltrim(cMascara)
						endif
					SX3->(MsUnlock())
				endif
					
			endif
			
		next nX
		
		MsgInfo("Finalizado!")
		
		VldMask() 
		
	endif
	
Return lRet


Static Function VldMask()  
    
	cMascara := Mascara(nInteiro, nDecimal)

	CarregaGrid()

	oDlgSX3:Refresh()

Return .T.


Static Function Mascara(pTamanho, pDecimal)

	Local i     := 0
	Local cMasc := ""
	Local nFor //:= (pTamanho - pDecimal - 1 )
	Local nAux := 0
	
	if pDecimal == 0
		nFor := pTamanho
	else
		nFor := (pTamanho - pDecimal - 1 )
	endif
	
	for i := 1 to nFor
		                  
		nAux++  //0
		
		if nAux > 3
			cMasc := ","+cMasc
			nAux := 1
		endif
		
		cMasc := "9"+cMasc

	next i

	if pDecimal == 0
		cMasc := "@E " + cMasc 
	else
		cMasc := "@E " + cMasc + "." + Repl("9",pDecimal)
	endif

Return(cMasc)  


Static Function DoBackup()
	
	Local cTabAtu := aTables[oListTab:nAt] 
	Local cFile := "\BACKUP\"+cTabAtu+"0101_BKP_"+DTOS(dDataBase)+".dtc" 
	
	if FILE(cFile)
		MsgInfo("Arquivo de backup ja existente: " + cFile)
		Return
	endif
	
	if MsgYesNo("Confirma backup da tabela "+cTabAtu +" ?")	
		
		SET DELETED OFF //Desabilita filtro do campo D_E_L_E_T_
		
		DbSelectArea(cTabAtu)
	
		Set Filter To
		
		COPY TO &cFile VIA "CTREECDX"
	    
	    MsgInfo("Finalizado! Arquivo: " + cFile)
		
		SET DELETED ON //Habilita filtro do campo D_E_L_E_T_
		
	endif
	
Return   


Static Function DoDrop()
	
	Local cTabAtu := aTables[oListTab:nAt] 
	Local cTabela
	
	if MsgYesNo("Confirma DROP da tabela "+cTabAtu+" ?")	
		
		//fecho a tabela
		DbSelectArea(cTabAtu)
		(cTabAtu)->(DBCloseArea())
		
		DbSelectArea("SX2")
		if SX2->(DbSeek(cTabAtu))
			cTabela := Alltrim(SX2->X2_ARQUIVO)
			If TcCanOpen(cTabela)
				lOk := TcDelFile(cTabela)  
				If lOk 
					MsgInfo("Tabela "+cTabela+" apagada.")  
				Else    
					MsgStop("Falha ao apagar "+cTabela+" : "+ TcSqlError())  
				Endif
			Else  
				MsgInfo("Talbela "+cTabela+" nao encontrada.")
			Endif
		else
			MsgInfo("Talbela "+cTabela+" nao encontrada.")
		endif
		
	endif

Return      
       


Static Function DoAppend(cTabAtu, lAuto)
	
	Local cFile 
	Local cPfx 
	Local aChave := {}
	Local cX2Unico 
	Local cChave := ""
	Local cFilDel := "X1" 
	
	Default cTabAtu := aTables[oListTab:nAt] 
	Default lAuto := .F.
	
	cFile := "\BACKUP\"+cTabAtu+"0101_BKP_"+DTOS(dDataBase)+".dtc" 
	cPfx := iif(Substr(cTabAtu,1,1)=="S", Substr(cTabAtu,2,2), cTabAtu)
	cX2Unico := Posicione("SX2",1,cTabAtu,"X2_UNICO")
	
	DbSelectArea(cTabAtu) //recria tabela
	
	if !FILE(cFile)
		if !lAuto
			MsgInfo("Arquivo de backup não encontrado: " + cFile)
		endif
		Return
	endif
	
	if lAuto .OR. MsgYesNo("Confirma append do arquivo na tabela "+cTabAtu +" ?")	
	    
	    SET DELETED OFF //Desabilita filtro do campo D_E_L_E_T_
	    
		dbUseArea(.F.,"CTREECDX",cFile,"TABBKP",.F.,.F.) 
		TABBKP->(DbGoTop())
		While TABBKP->(!Eof())
			
			if TABBKP->(Deleted())
				cChave := TABBKP->(&cX2Unico)
				if (nPos := aScan(aChave, {|x| x[1] == cChave})) == 0 
					cFilDel := "X1"
					aadd(aChave, {cChave, cFilDel})
			    else   
			    	cFilDel := Soma1(aChave[nPos][2])
			    endif
				Reclock("TABBKP", .F.)
					TABBKP->&(cPfx+"_FILIAL") := cFilDel
				TABBKP->(MsUnlock())
			endif
			
			TABBKP->(DbSkip())
		enddo
		
		if Alias() == "TABBKP"
			DbSelectArea(cTabAtu)
	
			Append From TABBKP
	    
		    TABBKP->(dbCloseArea())
	    	(cTabAtu)->(dbCloseArea())
	    	if !lAuto
		    	MsgInfo("Finalizado Append do Arquivo: " + cFile)
	    	endif
	    else
	    	if !lAuto
		    	MsgInfo("Falha ao abrir arquivo " + cFile)
	    	endif
		endif
		
		SET DELETED ON //Habilita filtro do campo D_E_L_E_T_
		
	endif
	
Return         

//faz append automatico
Static Function DoAppAuto()
	      
	//tabelas que ja foram
	//aTables       := {"SB2","SB6","SB7","SB8","SB9","SBJ","SBK","SBC","SBF","SC1","SC2","SC5","SC6","SC7","SC8","SC9","SCP","SCQ","SD1","SD2","SD3","SD4","SD5","SD7","SDA","SDB","SDC","SDD","SB1"}
	Local aTblNot := {"SB2","SB6","SB7","SB8","SB9","SBC","SC1","SC2","SC5","SC8","SCP","SCQ","SDA","SDD","SDC","SD7","SB1"}
	//Local aUpd    := {"SBJ","SBF","SC7","SD1","SD3","SD5",}
	Local aUpd    := {"SBK","SC6","SC9","SD2","SD4","SD7","SDB"}
	Local nX := 0
    /*
	For nX := 1 to len(aTables)
		
		if aScan(aTblNot, aTables[nX]) == 0 
			MsAguarde({|| DoAppend(aTables[nX], .T.) },"Aguarde...","Fazendo append tabela "+aTables[nX]+"...",.F.)
		endif
		
	next nX
	*/
	
	For nX := 1 to len(aUpd)
		
		MsAguarde({|| DoAppend(aUpd[nX], .T.) },"Aguarde...","Fazendo append tabela "+aUpd[nX]+"...",.F.)
		
	next nX
	
Return
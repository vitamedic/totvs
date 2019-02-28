#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*/{Protheus.doc} Vit615
	Função para corrigir dados das planilhas geradas para análise dos departamentos (regisrtros válidos)
@author Microsiga
@since 13/06/17
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function Vit615()

	Private cPerg := "Vit615    "

	If !ValidPerg() .or. Empty(mv_Par01)
		MsgStop("Informe os parâmetros para a importação do cadastro...", "Atenção")
		Return()
	EndIf
	
	If !( ".CSV" $ Upper(mv_Par01) )
		MsgStop("Selecione um arquivo válido (extensão .csv) para a importação do cadastro...", "Atenção")
		Return()
	EndIf
	
	Processa({|lEnd| ImpPlanilha()},"Executando atualização dos dados das planilhas...")
	
Return()

Static Function ImpPlanilha()
Local cDir 		:= Left(mv_par01,RAt("\", mv_par01)-1)
Local cLog		:= ""
Local aDados    := {}
Local aCampos   := {} 
Local nLin, nCtr

Local nPos   := 0
Local cAlias := ""
Local cChave     := ""
Local nPosOk     := 0
Local nPosRec    := 0
Local cError     := ""
Local oLastError := ErrorBlock({|e| cError := e:Description + e:ErrorStack})

Private lMsErroAuto := .F.

if ( nPos := At("_SC1", mv_Par01) ) > 0
	cAlias := "SC1"
Elseif ( nPos := At("_SC7", mv_Par01) )> 0
		cAlias := "SC7"
Elseif ( nPos := At("_SC2", mv_Par01) )> 0
		cAlias := "SC2"
Elseif ( nPos := At("_SDA", mv_Par01) )> 0
		cAlias := "SDA"
Elseif ( nPos := At("_SD4", mv_Par01) )> 0
		cAlias := "SD4"
Elseif ( nPos := At("_SDD", mv_Par01) )> 0
		cAlias := "SDD"
Elseif ( nPos := At("_SC9", mv_Par01) )> 0
		cAlias := "SC9"
Elseif ( nPos := At("_SC6", mv_Par01) )> 0
		cAlias := "SC6"
Else
	nPos   := 0
	cAlias := ""
EndIf

If nPos == 0
	MsgStop("O nome da planilha precisa constar a tabela precedida de '_', ex.: '_SC1'.", "Atenção")
	Return()
EndIf

u_UDadosImp(mv_Par01, @aDados, @aCampos, /*lComCabec*/ )

If Len( aDados ) == 0
	MsgStop("Não existe informação no arquivo para a importação do cadastro...", "Atenção")
	Return()
EndIf

nPosOk := AScan(aCampos, {|x| alltrim(x) == "OK"})

If nPosOk == 0
	msgStop('Não Existe a coluna "OK" na planilha')
	Return()
EndIf

nPosRec := AScan(aCampos, {|x| alltrim(x) == "RECNO"})

If nPosRec == 0
	msgStop('Não Existe a coluna "RECNO" na planilha')
	Return()
EndIf

if cAlias == "SDD"
	nPosDoc  := AScan(aCampos, {|x| alltrim(x) == "DOCUMENTO"})
	nPosPrd  := AScan(aCampos, {|x| alltrim(x) == "PRODUTO"})
	nPosArm  := AScan(aCampos, {|x| alltrim(x) == "ARMAZEM"})
	nPosLote := AScan(aCampos, {|x| alltrim(x) == "LOTE"})
	nPosEnd  := AScan(aCampos, {|x| alltrim(x) == "ENDERECO"})
elseif cAlias == "SD4"
		nPosDoc  := AScan(aCampos, {|x| alltrim(x) == "OP"})
		nPosItm  := AScan(aCampos, {|x| alltrim(x) == "TRT"})
		nPosPrd  := AScan(aCampos, {|x| alltrim(x) == "COMPONENTE"})
		nPosArm  := AScan(aCampos, {|x| alltrim(x) == "ARMAZEM"})
		nPosLote := AScan(aCampos, {|x| alltrim(x) == "LOTE"})
		nPosEnd  := 0
elseif cAlias == "SC9"
		nPosDoc  := AScan(aCampos, {|x| alltrim(x) == "PEDIDO"})
		nPosItm  := AScan(aCampos, {|x| alltrim(x) == "ITEM"})
		nPosSeq  := AScan(aCampos, {|x| alltrim(x) == "SEQUENCIA"})
		nPosPrd  := AScan(aCampos, {|x| alltrim(x) == "PRODUTO"})
		nPosArm  := AScan(aCampos, {|x| alltrim(x) == "ARMAZEM"})
		nPosLote := AScan(aCampos, {|x| alltrim(x) == "LOTE"})
		nPosEnd  := 0
endif

processa({|| Len(aDados) })

For nLin := 1 to Len(aDados)
	cLinErr := "Erro Linha: " + StrZero(nLin, Len(aDados)) +": "
	cOk     := iif(upper(Alltrim(aDados[nLin][nPosOk])) $ "SIM;S;", "N", "S")

	IncProc( "Atualizando registros..." )

	if cAlias == "SDD"
		cDoc     := Pad(Alltrim(aDados[nLin][nPosDoc]), TamSX3("DD_DOC")[1])
		cProd    := Pad(Alltrim(aDados[nLin][nPosPrd]), TamSX3("DD_PRODUTO")[1])
		cArmaz   := PadL(Alltrim(aDados[nLin][nPosArm]), TamSX3("DD_LOCAL")[1], '0')
		cLote    := Alltrim(aDados[nLin][nPosLote])
		cLote    := Pad(iif(len(alltrim(cLote)) < 6 .and. !empty(cLote), "0"+cLote, cLote), TamSX3("DD_LOTECTL")[1])
		cEnder   := Pad(Alltrim(aDados[nLin][nPosEnd]), TamSX3("DD_LOCALIZ")[1])

	    pQry :=        " DD_DOC = '" + cDoc + "' "
	    pQry += CRLF + " AND DD_PRODUTO = '" + cProd + "' "
	    pQry += CRLF + " AND DD_LOCAL   = '" + cArmaz + "' "
	    pQry += CRLF + " AND DD_LOTECTL = '" + cLote + "' "
	    pQry += CRLF + " AND DD_LOCALIZ = '" + cEnder + "' "
	    pQry += CRLF + " AND DD_XOK     = ' ' "

	elseif cAlias == "SD4"
			cDoc     := Alltrim(aDados[nLin][nPosDoc])
			cDoc     := Pad( iif(len(cDoc) < 11, "0"+cDoc, cDoc), TamSX3("D4_OP")[1])
			cItem    := Alltrim(aDados[nLin][nPosItm])
			cItem    := Pad(iif(len(alltrim(cItem)) < 2 .and. !empty(cItem), "0"+cItem, cItem), TamSX3("D4_TRT")[1])
			cProd    := Alltrim(aDados[nLin][nPosPrd])
			cProd    := iif(len(cProd) < 6 .and. !empty(cProd), PadL(cProd,6,'0'), cProd)
			cArmaz   := PadL(Alltrim(aDados[nLin][nPosArm]), TamSX3("D4_LOCAL")[1], '0')
			cLote    := Pad(Alltrim(aDados[nLin][nPosLote]), TamSX3("D4_LOTECTL")[1])
			//cLote    := Pad(iif(len(alltrim(cLote)) < 6 .and. !empty(cLote), "0"+cLote, cLote), TamSX3("D4_LOTECTL")[1])
			//cDoc     := iif(len(alltrim(cDoc)) < 6, "0"+cDoc+"01001", cDoc)
			
		    pQry :=        " D4_FILIAL      = '" + XFilial("SD4") + "' "
		    pQry += CRLF + " AND D4_OP      = '" + Pad(cDoc, TamSX3("D4_OP")[1]) + "' "
		    pQry += CRLF + " AND D4_COD     = '" + cProd + "' "
		    pQry += CRLF + " AND D4_TRT     = '" + cItem + "' "
		    pQry += CRLF + " AND D4_LOCAL   = '" + cArmaz + "' "
		    pQry += CRLF + " AND D4_LOTECTL = '" + cLote + "' "
	        pQry += CRLF + " AND D4_XOK     = ' ' "

	elseif cAlias == "SC9"
			cDoc     := Pad(Alltrim(aDados[nLin][nPosDoc]), TamSX3("C9_PEDIDO")[1])
			cItem    := Alltrim(aDados[nLin][nPosItm])
			cSeq     := PadL(Alltrim(aDados[nLin][nPosSeq]), TamSX3("C9_SEQUEN")[1], '0')
			cProd    := Pad(Alltrim(aDados[nLin][nPosPrd]), TamSX3("C9_PRODUTO")[1])
			cArmaz   := PadL(Alltrim(aDados[nLin][nPosArm]), TamSX3("C9_LOCAL")[1], '0')
			cLote    := Alltrim(aDados[nLin][nPosLote])
			cLote    := Pad(iif(len(alltrim(cLote)) < 6 .and. !empty(cLote), "0"+cLote, cLote), TamSX3("C9_LOTECTL")[1])
	
		    pQry :=        " C9_FILIAL      = '" + XFilial("SC9") + "' "
		    pQry += CRLF + " AND C9_PEDIDO  = '" + cDoc + "' "
		    pQry += CRLF + " AND C9_ITEM    = '" + cItem + "' "
		    pQry += CRLF + " AND C9_SEQUEN  = '" + cSeq + "' "
		    pQry += CRLF + " AND C9_PRODUTO = '" + cProd + "' "
		    pQry += CRLF + " AND C9_LOCAL   = '" + cArmaz + "' "
		    pQry += CRLF + " AND C9_LOTECTL = '" + cLote + "' "
	        pQry += CRLF + " AND C9_XOK     = ' ' "
	
	endif
    
	nRecno := RetRecno(cAlias, pQry)
	
	If Empty( nRecno )
		cLog += cLinErr + pQry + CRLF + "Recno não encontrado;" + CRLF
		Loop
	EndIf

	BeginTran()
	
	dbSelectArea(cAlias)
	&(cAlias)->(dbGoTo(nRecno))
	if &(cAlias)->(Recno()) == nRecno
		if ! &(cAlias)->(RecLock(cAlias, .f.))
			cLog += cLinErr + "Não foi possível bloquear o Recno "+Str(nRecno)+" para a atualização do registro na tabela;" + CRLF
			Loop
		else 
			if cAlias $ ";SC9;SD4;SDD;"
				dbSelectArea("SDC")
				
				if cAlias == "SC9"
					dbSetOrder(1)
					//DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
					dbSeek(cChave:=XFilial("SDC")+SC9->(C9_PRODUTO+C9_LOCAL+'SC6'+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_LOTECTL))
					do while SDC->(!Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL == cChave)
						if SDC->(RecLock("SDC", .f.))
							SDC->DC_XOK := cOk
							SDC->(dbDelete())
							SDC->(MsUnLock())
						endif
						SDC->(dbSkip())
					enddo
				elseif cAlias == "SD4"
					dbSetOrder(2)
					//DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
					dbSeek(cChave:=XFilial("SDC")+SD4->(D4_COD+D4_LOCAL+D4_OP+D4_TRT+D4_LOTECTL))
					do while SDC->(!Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL == cChave)
						if SDC->(RecLock("SDC", .f.))
							SDC->DC_XOK := cOk
							SDC->(dbDelete())
							SDC->(MsUnLock())
						endif
						SDC->(dbSkip())
					enddo
				elseif cAlias == "SDD"
					dbSetOrder(1)
					//DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
					dbSeek(cChave:=XFilial("SDC")+SDD->(DD_PRODUTO+DD_LOCAL+'SDD'+Pad(DD_DOC,TamSX3("DC_PEDIDO")[1])+Space(TamSX3("DC_ITEM")[1])+Space(TamSX3("DC_SEQ")[1])+DD_LOTECTL))
					do while SDC->(!Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL == cChave)
						if SDC->(RecLock("SDC", .f.))
							SDC->DC_XOK := cOk
							SDC->(dbDelete())
							SDC->(MsUnLock())
						endif
						SDC->(dbSkip())
					enddo
				endif
			endif
			
			dbSelectArea(cAlias)
			&(cAlias+"->"+Right(cAlias,2)+"_XOK") := cOk
			&(cAlias)->(dbDelete())
			&(cAlias)->(MsUnLock())
		endif
	endif
	
	EndTran()
	
Next nLin
	
MemoWrite("c:\log_planilhas"+DtoS(dDataBase)+"_"+Time()+".log", cLog)

Return()

Static Function ValidPerg()
Local aHelpPor := {}

PutSx1(cPerg,"01",OemToAnsi("Pasta\Arquivo .csv ?"),"","","mv_ch1","C",70,0,0,"G","","SELCSV","","S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,{},{})
putSx1(cPerg,"02",OemToAnsi("Regrava SB9?")        ,"","","mv_ch2","N",01,0,0,"C","","","","","mv_par02","Apaga","","","","Recupera","","","","","","","","","","","",aHelpPor,{},{})

//"Apaga","","","","Recupera,"","","","","","","","","","")

Return(Pergunte(cPerg,.T.))

Static Function SELDIR(cMascara)

Local cDir := ""        

Local MV_XDIR := SuperGetMV("MV_XDIR", .F., "c:\")

Default cMascara := ""

	cDir := cGetFile( cMascara, 'Selecione o diretório\Arquivo', 1, MV_XDIR, .T., GETF_LOCALHARD ,.T., .T. )
	
	PutMV("MV_XDIR", cDir)
	
Return(.T.)

Static Function UDadosImp(pArquivo, aDados, aCampos, lComCabec)

Local cLinha  := ""

Private aErro := {}

Default aCampos 	:= {}  //Campos da tabela, se for integrar a leitura do arquivo com o dicionário de dados.
Default aDados  	:= {}  //Dados a ser gravado na tabela.
Default lComCabec   := .T. //Primeira linha para nome dos campos.

If !File(pArquivo)
	MsgStop("O arquivo " + pArquivo + " não foi encontrado. A importação será abortada!","Atenção")
	Return
EndIf

FT_FUSE(pArquivo)

ProcRegua(FT_FLASTREC())

FT_FGOTOP()
While !FT_FEOF()
	
	IncProc("Lendo arquivo...")
	
	cLinha := FT_FREADLN()
	
	If lComCabec
		aCampos   := Separa(cLinha,";",.T.)
		lComCabec := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
	
	FT_FSKIP()
EndDo

FT_FUSE()

Return(aDados)

/*
Static Function ErrorBlockExample()

Local cError      := ""

Local oLastError := ErrorBlock({|e| cError := e:Description + e:ErrorStack})

Local uTemp        := Nil

uTemp := "A" + 1

ErrorBlock(oLastError)

// Anota o erro no console.

ConOut(cError)
*/

Static Function RetRecno(cAlias, pQry)
Local aArea     := GetArea()
Local cQry 		:= " SELECT Q.R_E_C_N_O_ FROM " + RetSqlName(cAlias) + " Q WHERE Q.D_E_L_E_T_ = ' ' AND " + pQry
Local nRecno 	:= 0

if select("QREC") > 0
	dbSelectArea("QREC")
	dbCloseArea()
endif

TCQuery cQry New Alias "QREC"

if QREC->(!Eof())
	nRecno := QREC->R_E_C_N_O_
endif
                              
QREC->(dbCloseArea())       

RestArea(aArea)

Return(nRecno)
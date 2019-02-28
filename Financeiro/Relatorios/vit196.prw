//#INCLUDE "FINR190.CH"
#INCLUDE "TOPCONN.CH"
//#Include "FIVEWIN.Ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT196   ³ Autor ³ Gardenia              ³ Data ³ 23.04.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Baixas Sintetico                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


user function vit196
wnrel    := "RELBAIXA"
aOrd     :={'Por Data','Por banco', 'Por Natureza'} // , 'Alfabetica','Por Representante'}
cDesc1   :="Este programa ir  emitir a rela‡„o dos titulos baixados.  "
cDesc2   :="Poder  ser emitido por data, banco, natureza ou alfab‚tica"
cDesc3   :="de cliente ou fornecedor e data da digita‡„o.				  "
tamanho  :="G"
limite   := 220
cString  :="SE5"
titulo   :="Relacao de Baixas sintetico"
cabec1   := cabec2:= cNomeArq := ""
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog :="VIT196"
aLinha   := { }
nLastKey := 0
cPerg    :="FIN190"
//_AjustaSx1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN190",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01            // da data da baixa                  ³
//³ mv_par02            // at‚ a data da baixa               ³
//³ mv_par03            // do banco                          ³
//³ mv_par04            // at‚ o banco                       ³
//³ mv_par05            // da natureza                       ³
//³ mv_par06            // at‚ a natureza                    ³
//³ mv_par07            // do c¢digo                         ³
//³ mv_par08            // at‚ o c¢digo                      ³
//³ mv_par09            // da data de digita‡„o              ³
//³ mv_par10            // ate a data de digita‡„o           ³
//³ mv_par11            // Tipo de Carteira (R/P)            ³
//³ mv_par12            // Moeda                             ³
//³ mv_par13            // Hist¢rico: Baixa ou Emiss„o       ³
//³ mv_par14            // Imprime Baixas Normais / Todas    ³
//³ mv_par15            // Situacao                          ³
//³ mv_par16            // Cons Mov Fin                      ³
//³ mv_par17            // Do Lote                           ³
//³ mv_par18            // Ate o Lote                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "VIT196"+Alltrim(cusername)            //Nome Default do relat¢rio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif
// RptStatus({||Execute(_Fa190Imp())})
rptstatus({|| rptdetail()})
Return

Static Function rptdetail()
nValor      := 0
nDesc       := 0
nJuros      := 0
nCM         := 0
nMulta      := 0
nTotValor   := 0
nTotDesc    := 0
nTotJuros   := 0
nTotMulta   := 0
nTotCm      := 0
nTotOrig    := 0
nTotBaixado := 0
nTotMovFin  := 0
nGerValor   := 0
nGerDesc    := 0
nGerJuros   := 0
nGerMulta   := 0
nGerCm      := 0
nGerOrig    := 0
nGerBaixado := 0
nGerMovFin  := 0
nCT         := 0
dData       := Ctod("  /  /  ")
dDigit      := Ctod("  /  /  ")
dDtMovFin   := Ctod("  /  /  ")
cBanco      := ""
Natureza    := ""
cAnterior   := ""
cCliFor     := ""
cLoja       := ""
cHistorico  := ""
lContinua   := .T.
lBxTit      := .F.
lManual     := .F.
aCampos     := {}
cNomArq1    := ""
lOriginal   := .T.
nAbat       := 0
nTotAbat    := 0
nGerAbat    := 0
cMotBxImp   := " "
cTipodoc    := ""
nRecSe5     := 0
nRecAtu     := 0
cRecPag     := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
nOrdem   := aReturn[8]
cSuf     := Str(mv_par12,1)
cMoeda   := MV_MOEDA&cSuf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par11 == 1
	titulo := "Relacao dos Titulos Recebidos em " + cMoeda
	cabec1 := "Prf Numero P TP Client Nome Cliente       Natureza    Vencto  Historico       Dt Baixa  Valor Original     Tx Permanen          Multa       Correcao      Descontos      Abatimentos     Total Rec. Bco Dt Digit. Mot. Baixa"
Else
	titulo := "Relacao dos Titulos Pagos em " + cMoeda
	cabec1 := "Prf Numero P TP Fornec Nome Fornecedor    Natureza    Vencto  Historico       Dt Baixa  Valor Original     Tx Permanen          Multa       Correcao      Descontos      Abatimentos     Total Pago Bco Dt Digit. Mot. Baixa"
Endif
cabec2 := ""

dbSelectArea("SE5")
cQry    := "SELECT E5_DATA, E5_RECPAG, E5_NATUREZ, E5_CLIFOR, E5_DTDIGIT, E5_VALOR, "
cQry    := cQry + "E5_MOTBX, E5_PREFIXO, E5_NUMERO "
cFilSE5 := 'E5_RECPAG == '+IIF(mv_par11 == 1,'"R"','"P"')+' .and. '
cFilSE5 := cFilSE5 + 'DTOS(E5_DATA) >= '+'"'+dtos(mv_par01)+'"'+' .and. DTOS(E5_DATA) <= '+'"'+dtos(mv_par02)+'" .and. '
cFilSE5 := cFilSE5 + 'E5_NATUREZ >= '+'"'+mv_par05+'"'+' .and. E5_NATUREZ <= '+'"'+mv_par06+'" .and. '
cFilSE5 := cFilSE5 + 'E5_CLIFOR >= '+'"'+mv_par07+'"'+' .and. E5_CLIFOR <= '+'"'+mv_par08+'" .and. '
cFilSE5 := cFilSE5 + 'DTOS(E5_DTDIGIT) >= '+'"'+dtos(mv_par09)+'"'+' .and. DTOS(E5_DTDIGIT) <= '+'"'+dtos(mv_par10)+'" .and.'
cFilSE5 := cFilSE5 + 'E5_LOTE >= '+'"'+mv_par20+'"'+' .and. E5_LOTE <= '+'"'+mv_par21+'"'

Set Softseek On
IF nOrdem == 1
	cCondicao:= "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
	cCond2   := "E5_DATA"
    titulo   := Titulo + " por data de pagamento"
	#IFDEF TOP
		MsFilter(cFilSE5)
	#ENDIF
	dbSetOrder(1)
	dbSeek(cFilial+Dtos(mv_par01))
	xFilial:=cFilial
Elseif nOrdem == 2
	cCondicao:= "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
	cCond2   := "E5_BANCO"
    titulo   := Titulo + " por Banco"
	#IFDEF TOP
		MsFilter(cFilSE5)
	#ENDIF
	dbSetOrder(3)
	dbSeek(cFilial+mv_par03)
	xFilial:=cFilial
Elseif nOrdem == 3
	cCondicao:= "E5_NATUREZ >= mv_par05 .and. E5_NATUREZ <= mv_par06"
	cCond2   := "E5_NATUREZ"
    titulo   := titulo + " por Natureza"
	#IFDEF TOP
		MsFilter(cFilSE5)
	#ENDIF
	dbSetOrder(4)
	dbSeek(cFilial+mv_par05)
	xFilial:=cFilial
Elseif nOrdem == 4
	cCondicao:=".T."
	cCond2   :="E5_CLIFOR"
    titulo   := titulo + " Alfabetica"
	cNomeArq:=CriaTrab("",.f.)
	dbSelectArea("SE5")
	xFilial:=cFilial
	dbSetOrder(0)
//	#IFNDEF TOP
		IndRegua("SE5",cNomeArq,"E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA",,,"Selecionando Registros...")  //"Selecionando Registros..."
//	#ELSE
//		IndRegua("SE5",cNomeArq,"E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA",,cFilSE5,OemToAnsi(STR0018))  //"Selecionando Registros..."	
//	#ENDIF
	dbSeek(xFilial,.T.)
Elseif nOrdem == 5
	cCondicao:=".T."
	cCond2   :="E5_NUMERO"
    titulo   := titulo + " Nro. dos Titulos"
	cNomeArq:=CriaTrab("",.f.)
	dbSelectArea("SE5")
	xFilial:=cFilial
	dbSetOrder(0)
//	#IFNDEF TOP
		IndRegua("SE5",cNomeArq,"E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)",,,"Selecionando Registros...")  //"Selecionando Registros..."
//	#ELSE
//		IndRegua("SE5",cNomeArq,"E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)",,cFilSE5,OemToAnsi(STR0018))  //"Selecionando Registros..."	
//	#ENDIF
	dbSeek(xFilial,.T.)
Elseif nOrdem == 6 	//Ordem 6 (Digitacao)
	cCondicao:=".T."
	cCond2   :="E5_DTDIGIT"
    titulo   := titulo + " Por Data de Digitacao"
    cNomeArq := CriaTrab("",.f.)
	dbSelectArea("SE5")
	xFilial:=cFilial
//	#IFNDEF TOP
		IndRegua("SE5",cNomeArq,"E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)",,,"Selecionando Registros...")  //"Selecionando Registros..."
//	#ELSE
//		IndRegua("SE5",cNomeArq,"E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)",,cFilSE5,OemToAnsi(STR0018))  //"Selecionando Registros..."
//	#ENDIF
	dbSeek(xFilial,.T.)
Else   // ordem 7 - Por Lote
	cCondicao:= "E5_LOTE  >= mv_par17 .and. E5_LOTE <= mv_par18"
	cCond2   := "E5_LOTE"
    titulo   := Titulo + " por Lote"
//	#IFDEF TOP
		MsFilter(cFilSE5)
//	#ENDIF
	dbSetOrder(5)
	dbSeek(cFilial+mv_par17)
	xFilial:=cFilial
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"LINHA","C",80,0 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq1 := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq1, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
//IndRegua("TRB",cNomArq1,"LINHA",,,OemToAnsi(STR0018))  //"Selecionando Registros..."
IndRegua("TRB",cNomArq1,"LINHA",,,"Selecionando registros")  //"Selecionando Registros..."

dbSelectArea("SE5")

cFilterUser:=aReturn[7]

SetRegua(RecCount())

While !Eof() .And. E5_FILIAL==xFilial .And. &cCondicao .and. lContinua
	
	#IFNDEF WINDOWS
		Inkey()
		If LastKey() = K_ALT_A
			lEnd := .t.
		Endif
	#ENDIF
	
	IF lEnd
//		@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
		lContinua:=.F.
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif

	IncRegua()
	
	IF E5_SITUACA == "C" .or. E5_TIPODOC == "TR" .or.;
		( SE5->E5_TIPODOC == "CD" .and. SE5->E5_VENCTO > SE5->E5_DATA ) // cheque pre
		dbSkip()
		Loop
	Endif
	
	IF mv_par11 == 1 .and. E5_RECPAG = "P"      //Nao ‚ recebimento
		dbSkip()
		Loop
	Endif
	
	IF mv_par11 == 2 .and. E5_RECPAG = "R"      //Nao ‚ pagamento
		dbSkip()
		Loop
	EndIF
	
	If Empty(SE5->E5_TIPODOC) .and. mv_par16 == 2
		dbSkip()
		Loop
	Endif
	
	If Empty(SE5->E5_NUMERO) .and. mv_par16 == 2
		dbSkip()
		Loop
	Endif
	
	If SE5->E5_RECPAG == "R"
		If SE5->E5_TIPO == "RA " .and. SE5->E5_MOTBX == "CMP"
			dbSkip()
			LOOP
		EndIF
	EndIF
	
	If SE5->E5_RECPAG == "P"
		If SE5->E5_TIPO == "PA " .and. SE5->E5_MOTBX == "CMP"
			dbSkip()
			LOOP
		EndIF
	EndIF
	
	cAnterior 	:= &cCond2
	nTotValor	:= 0
	nTotDesc		:= 0
	nTotJuros	:= 0
	nTotMulta	:= 0
	nTotCM		:= 0
	nCT			:= 0
	nTotOrig		:= 0
	nTotBaixado	:= 0
	nTotAbat  	:= 0
	nTotMovFin	:= 0

    While !EOF() .and. &cCond2 == cAnterior .and. E5_FILIAL == xFilial .and. lContinua
		
		lManual := .f.
		#IFNDEF WINDOWS
			Inkey()
			If LastKey() = K_ALT_A
				lEnd := .t.
			EndIF
		#ENDIF
		
		IF E5_SITUACA == "C" .or. E5_TIPODOC == "TR" .or. ;
			( SE5->E5_TIPODOC == "CD" .and. SE5->E5_VENCTO > SE5->E5_DATA ) // cheque pre
			dbSkip()
			Loop
		Endif
		
		IF lEnd
//			@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
			lContinua:=.F.
			Exit
		EndIF
		
		If Empty(SE5->E5_TIPODOC) .and. mv_par16 == 2
			dbSkip()
			Loop
		Endif
		
		If Empty(SE5->E5_NUMERO) .and. mv_par16 == 2
			dbSkip()
			Loop
		Endif
		
		If Empty(SE5->E5_TIPODOC) .And. mv_par16 == 1
			lManual := .t.
		Endif
		
		If Empty(SE5->E5_NUMERO) .And. mv_par16 == 1
			lManual := .t.
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cFilterUser).and.!(&cFilterUser)
			dbSkip()
			Loop
		Endif

		dbSelectArea("SE5")
		cNumero    := E5_NUMERO
		cPrefixo   := E5_PREFIXO
		cParcela   := E5_PARCELA
		dBaixa     := E5_DATA
		cBanco     := E5_BANCO
		cNatureza  := E5_NATUREZ
		cCliFor    := E5_BENEF
		cLoja      := E5_LOJA
		cSeq       := E5_SEQ
		cNumCheq   := E5_NUMCHEQ
		cRecPag    := E5_RECPAG
		If !Empty(E5_NUMERO)
			If SE5->E5_RECPAG == "R"
				dbSelectArea( "SA1")
				If dbSeek(xFilial("SA1")+SE5->E5_CLIFOR+SE5->E5_LOJA)
					cCliFor := SA1->A1_NREDUZ
				EndIF
			Else
				dbSelectArea( "SA2")
				If dbSeek(xFilial("SA2")+SE5->E5_CLIFOR+SE5->E5_LOJA)
					cCliFor := SA2->A2_NREDUZ
				EndIF
			EndIF
		EndIF
		dbSelectArea("SE5")
		cCheque    := E5_NUMCHEQ
		cTipo      := E5_TIPO
		cFornece   := E5_CLIFOR
		cLoja      := E5_LOJA
		dDigit     := E5_DTDIGIT
		lBxTit	  := .F.
		If mv_par11 == 1
			dbSelectArea("SE1")
			lBxTit := dbSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo)
			While !Eof() .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
				If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja	// Cliente igual, Ok
					dDtMovFin := IIF (lManual,CTOD("//"), SE1->E1_VENCREA)
					Exit
				Endif
				dbSkip()
			EndDo
			cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
			Store 0 To nDesc,nJuros,nValor,nMulta,nCM,nVlMovFin
		Else
			dbSelectArea("SE2")
			lBxTit := dbSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
			dDtMovFin := IIF(lManual,CTOD("//"),SE2->E2_VENCREA)
			cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
			Store 0 To nDesc,nJuros,nValor,nMulta,nCM,nVlMovFin
			cCheque    := Iif(Empty(SE5->E5_NUMCHEQ) .and. !lManual,SE2->E2_NUMBCO,SE5->E5_NUMCHEQ)
		Endif
		dbSelectArea("SE5")
		IncRegua()
		While !Eof() .and. &cCond3 .and. lContinua
			
			cMotBx     := Iif(Empty(E5_MOTBX),"NOR",SE5->E5_MOTBX)
			cTipodoc   := SE5->E5_TIPODOC
			
			cHistorico := Space(40)
			
			#IFNDEF WINDOWS
				Inkey()
				If LastKey() = K_ALT_A
					lEnd := .t.
				EndIF
			#ENDIF
			
			IF lEnd
//				@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
				lContinua:=.F.
				Exit
			EndIF
			
			IncRegua()
			
			If E5_SITUACA == "C" .or. E5_LOJA != cLoja
				dbSkip()
				Loop
			EndIF
			
			If Empty(SE5->E5_TIPODOC) .and. mv_par16 == 2
				dbSkip()
				Loop
			Endif
			
			If E5_TIPODOC == "TR"
				dbSkip()
				Loop
			Endif
			
			If mv_par11 == 1 .and. !lManual
				If !(SE1->E1_SITUACA $ mv_par15)
					dbSkip()
					Loop
				Endif
			Endif
			
			If mv_par11 == 1 .and. E5_RECPAG = "P"      //Nao ‚ recebimento
				dbSkip()
				Loop
			EndIF
			
			If SE5->E5_RECPAG == "R"
				If SE5->E5_TIPO == "RA " .and. SE5->E5_MOTBX == "CMP"
					dbSkip()
					LOOP
				EndIF
			EndIF
			
			If SE5->E5_RECPAG == "P"
				If SE5->E5_TIPO == "PA " .and. SE5->E5_MOTBX == "CMP"
					dbSkip()
					LOOP
				EndIF
			EndIF
			
			IF mv_par11 == 2 .and. E5_RECPAG = "R"      //Nao ‚ pagamento
				dbSkip()
				Loop
			EndIF
			
			If mv_par14 == 1 .And. !(cMotBx $ "NOR/DEB")         // S¢ imprime baixa normal e debitos em c/c
				dbSkip()
				Loop
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se est  dentro dos parƒmetros       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF E5_DATA   < mv_par01 .Or. E5_DATA    > MV_PAR02 .Or. ;
					E5_BANCO  < mv_par03 .Or. E5_BANCO   > MV_PAR04 .Or. ;
					E5_NATUREZ< mv_par05 .Or. E5_NATUREZ > MV_PAR06 .Or. ;
					E5_CLIFOR < mv_par07 .Or. E5_CLIFOR  > MV_PAR08 .Or. ;
					E5_DTDIGIT< mv_par09 .Or. E5_DTDIGIT > MV_PAR10 .or. ;
					E5_LOTE   < mv_par20 .or. E5_LOTE    > MV_PAR21
				dbSkip()
				Loop
			EndIF
			
			dbSelectArea("SM2")
			dbSeek(SE5->E5_DATA)
			dbSelectArea("SE5")
			nRecSe5:=Recno()

			Do Case
				Case E5_TIPODOC $ "DC/D2"
                    nDesc  := nDesc + Iif(mv_par12==1,E5_VALOR,xMoeda(E5_VALOR,1,mv_par12,E5_DATA))
				Case E5_TIPODOC $ "JR/J2/TL"
                    nJuros := nJuros + Iif(mv_par12==1,E5_VALOR,xMoeda(E5_VALOR,1,mv_par12,E5_DATA))
				Case E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
					cHistorico := E5_HISTOR
                    nValor := nValor + Iif(mv_par12==1,E5_VALOR,xMoeda(E5_VALOR,1,mv_par12,E5_DATA))
				Case E5_TIPODOC $ "MT/M2"
                    nMulta := nMulta + Iif(mv_par12==1,E5_VALOR,xMoeda(E5_VALOR,1,mv_par12,E5_DATA))
				Case E5_TIPODOC $ "CM/C2"
                    nCM := nCm + Iif(mv_par12==1,E5_VALOR,xMoeda(E5_VALOR,1,mv_par12,E5_DATA))
				OtherWise
                    nVlMovFin := nVlMovFin + Iif(mv_par12==1,E5_VALOR,xMoeda(E5_VALOR,1,mv_par12,E5_DATA))
					cHistorico := Iif(Empty(E5_HISTOR),"MOV FIN MANUAL",E5_HISTOR)
			EndCase
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o proximo tambem ‚ mov banc manu-³
			//³ al e caso positivo, deixa o la‡o.            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nRegAtu := RecNo()
			If Empty(E5_TIPODOC)
				dbSkip()
				If Empty(E5_TIPODOC)
					dbGoto(nRegAtu)
					Exit
				Endif
			Endif
			dbGoto(nRegAtu)
			dbSkip()
		EndDO
		
		If (nDesc+nValor+nJuros+nCM+nMulta+nVlMovFin) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ C lculo do Abatimento        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par11 == 1 .and. lBxTit
				dbSelectArea("SE1")
				nRecno := Recno()
				nAbat := SomaAbat(cPrefixo,cNumero,cParcela,"R",mv_par12,,cFornece,cLoja)
				dbSelectArea("SE1")
				dbGoTo(nRecno)
			ElseIf mv_par11 == 2 .and. lBxTit
				dbSelectArea("SE2")
				nRecno := Recno()
				nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par12,,cFornece,cLoja)
				dbSelectArea("SE2")
				dbGoTo(nRecno)
			EndIF
			
			If li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
			EndIF
		
//			@li, 0 PSAY cPrefixo
//			@li, 4 PSAY cNumero
//			@li,11 PSAY cParcela
//			@li,13 PSAY cTipo
			
			If !lManual
				dbSelectArea("TRB")
				dbSeek( cPrefixo+cNumero+cParcela+Iif(mv_par11==1,SE1->E1_CLIENTE+SE1->E1_LOJA,SE2->E2_FORNECE+SE2->E2_LOJA)+cTipo)
				lOriginal := .T.
				If Found()
					nVlr:=0
					nAbat:=0
					lOriginal := .F.
				Else
					nVlr:=Iif(mv_par11==1,SE1->E1_VLCRUZ,SE2->E2_VLCRUZ)
					If mv_par12 > 1
                        If mv_par11 == 1
							nVlr := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_EMISSAO)
						Else
							nVlr := xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_EMISSAO)
						EndIF
					EndIF
					nVlr:=NoRound(nVlr)
					RecLock("TRB",.T.)
					Replace linha With cPrefixo+cNumero+cParcela+Iif(mv_par11==1,SE1->E1_CLIENTE+SE1->E1_LOJA,SE2->E2_FORNECE+SE2->E2_LOJA)+cTipo
					MsUnlock()
				EndIF
			Else
				dbSelectArea("SE5")
				dbgoto(nRecSe5)
				nVlr := xMoeda(SE5->E5_VALOR,1,mv_par12,SE5->E5_DATA)
				nAbat:= 0
				lOriginal := .t.
				dbSkip()
				nRecSe5:=Recno()
				dbSelectArea("TRB")
			Endif
			IF mv_par11 == 1
				If ( !lManual )
					If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
						cHistorico := Iif(Empty(cHistorico), SE1->E1_HIST, cHistorico )
					Else
						cHistorico := Iif(Empty(SE1->E1_HIST), cHistorico, SE1->E1_HIST )
					Endif
				EndIf
				If lBxTit
//					@li, 16 PSAY SE1->E1_CLIENTE
				Endif
				If ( !lManual )
//					@li, 23 PSAY SubStr(cCliFor,1,18)
				EndIf
//				@li, 43 PSAY cNatureza
//				@li, 54 PSAY dDtMovFin
//				@li, 63 PSAY SubStr( cHistorico ,1,15)
//				@li, 79 PSAY dBaixa
				IF nVlr > 0
//					@li, 88 PSAY nVlr  Picture tm(nVlr,15)
				Endif
			Else
				If ( !lManual )
					If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
						cHistorico := Iif(Empty(cHistorico), SE2->E2_HIST, cHistorico )
					Else
						cHistorico := Iif(Empty(SE2->E2_HIST), cHistorico, SE2->E2_HIST )
					Endif
				EndIf
				If lBxTit .And. !lManual
//					@li, 16 PSAY SE2->E2_FORNECE
				Endif
				If ( !lManual )
//					@li, 23 PSAY SubStr(cCliFor,1,18)
				EndIf
//				@li, 43 PSAY cNatureza
//				@li, 54 PSAY dDtMovFin
				If !Empty(cCheque)
//					@li, 63 PSAY SubStr(ALLTRIM(cCheque)+"/"+Trim(cHistorico),1,15)
				Else
//					@li, 63 PSAY SubStr(ALLTRIM(cHistorico),1,15)
				EndIf
//				@li, 79 PSAY dBaixa
				IF nVlr > 0
//                  @li, 88 PSAY nVlr Picture tm(nVlr,15)
				Endif
			Endif
            nCT := nCT + 1
//			@li,104 PSAY nJuros     PicTure tm(nJuros,14)
//			@li,119 PSAY nMulta     PicTure tm(nMulta,14)
//			@li,134 PSAY nCM        PicTure tm(nCM ,14)
//			@li,149 PSAY nDesc      PicTure tm(nDesc,14)
			If nAbat > 0
//				@li,165 PSAY nAbat   Picture tm(nAbat,14)
			Endif
			If nVlMovFin > 0
//				@li,181 PSAY nVlMovFin     PicTure tm(nVlMovFin,15)
			Else 
//				@li,181 PSAY nValor			PicTure tm(nValor,15)
			Endif
//			@li,197 PSAY cBanco
//			@li,201 PSAY dDigit
			
//			If cMotBx == "NOR"
//				cMotBxImp := OemToAnsi(STR0022) //"NORMAL"
//			ElseIf cMotBx == "DEV"
//				cMotBxImp := OemToAnsi(STR0023)  //"DEVOLUCAO"
//			ElseIf cMotBx == "DAC"
//				cMotBxImp := OemToAnsi(STR0024)  //"DACAO"
//			ElseIf cMotBx == "VDR"
//				cMotBxImp := OemToAnsi(STR0025)  //"VENDOR"
//			ElseIf cMotBx == "CMP"
//				cMotBxImp := OemToAnsi(STR0026)  //"COMPENSAC"
//			ElseIf cMotBx == "CEC"
//				cMotBxImp := OemToAnsi(STR0027)  //"COMP CART"
//			ElseIf cMotBx == "DEB"
//				cMotBxImp := OemToAnsi(STR0034)  //"DEBITO CC"
//			ElseIf cMotBx == "LIQ"
//				cMotBxImp := OemToAnsi(STR0033)  //"LIQUIDAC."
//			Endif
  

			If cMotBx == "NOR"
				cMotBxImp := "NORMAL"
			ElseIf cMotBx == "DEV"
				cMotBxImp := "DEVOLUCAO"
			ElseIf cMotBx == "DAC"
				cMotBxImp := "DACAO"
			ElseIf cMotBx == "VDR"
				cMotBxImp := "VENDOR"
			ElseIf cMotBx == "CMP"
				cMotBxImp := "COMPENSAC"
			ElseIf cMotBx == "CEC"
				cMotBxImp := "COMP CART"
			ElseIf cMotBx == "DEB"
				cMotBxImp := "DEBITO CC"
			ElseIf cMotBx == "LIQ"
				cMotBxImp := "LIQUIDAC."
			Endif
		
		
					
//			@li,210 PSAY cMotBxImp
            nTotOrig    := nTotOrig    + Iif(lOriginal,nVlr,0)
            nTotBaixado := nTotBaixado + Iif(cTipodoc == "CP",0,nValor)        // n„o soma, j  somou no principal
            nTotDesc    := nTotDesc    + nDesc
            nTotJuros   := nTotJuros   + nJuros
            nTotMulta   := nTotMulta   + nMulta
            nTotCM      := nTotCM      + nCM
            nTotAbat    := nTotAbat    + nAbat
            nTotValor   := nTotValor   + IIF( nVlMovFin <> 0, nVlMovFin , Iif(cMotBx $ "NOR/DEB",nValor,0) )
            nTotMovFin  := nTotMovFin  + nVlMovFin
			Store 0 To nDesc,nJuros,nValor,nMulta,nCM,nAbat, nVlMovFin

//            li := li + 1
		Endif
		dbSelectArea("SE5")
	Enddo
	
	If (nTotValor+nDesc+nJuros+nCM+nTotMulta+nTotOrig+nTotMovFin)>0
        li := li + 1
		IF li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		If nCT > 0
			IF nOrdem == 1 .or. nOrdem == 6
				@li, 0 PSAY "Total : " + DTOC(cAnterior)
			Elseif nOrdem == 2 .or. nOrdem == 4 .or. nOrdem == 7
				@li, 0 PSAY "Total : "+cAnterior
				If nOrdem == 4
					if mv_par11 == 1
						dbSelectArea("SA1")
						dbSeek(cFilial+cAnterior)
						cLinha:=TRIM(A1_NOME)+"  "+A1_CGC
					Else
						dbSelectArea("SA2")
						dbSeek(cFilial+cAnterior)
						cLinha:=TRIM(A2_NOME)+"  "+A2_CGC
					Endif
					@li,20 PSAY cLinha
				Endif
			Elseif nOrdem == 3
				dbSelectArea("SED")
				dbSeek(cFilial+cAnterior)
				@li, 0 PSAY "SubTotal : " + cAnterior + " "+ED_DESCRIC
			Endif
			If nOrdem != 5
				@li, 88 PSAY nTotOrig     PicTure tm(nTotOrig,15)
				@li,104 PSAY nTotJuros    PicTure tm(nTotJuros,14)
				@li,119 PSAY nTotMulta    PicTure tm(nTotMulta,14)
				@li,134 PSAY nTotCM       PicTure tm(nTotCM ,14)
				@li,149 PSAY nTotDesc     PicTure tm(nTotDesc,14)
				@li,165 PSAY nTotAbat     Picture tm(nTotAbat,14)
				@li,181 PSAY nTotValor    PicTure tm(nTotValor,15)
				If (nTotValor != nTotBaixado) .or. (nTotMovFin > 0)
					@li,197 PSAY "Baixados" // OemToAnsi(STR0028)  //"Baixados"
					@li,206 PSAY nTotBaixado  PicTure tm(nTotBaixado,15)
                    li := li + 1
					@li,197 PSAY "Mov Fin" // OemToAnsi(STR0031)   //"Mov Fin."
					@li,206 PSAY nTotMovFin   PicTure tm(nTotMovFin,15)
				Endif
                li := li + 2
			Endif
			dbSelectArea("SE5")
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Incrementa Totais Gerais ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    nGerOrig    := nGerOrig    + nTotOrig
    nGerValor   := nGerValor   + nTotValor
    nGerDesc    := nGerDesc    + nTotDesc
    nGerJuros   := nGerJuros   + nTotJuros
    nGerCM      := nGerCM      + nTotCM
    nGerMulta   := nGerMulta   + nTotMulta
    nGerAbat    := nGerAbat    + nTotAbat
    nGerBaixado := nGerBaixado + nTotBaixado
    nGerMovFin  := nGerMovFin  + nTotMovFin
Enddo

If li != 80
    li := li + 1
    @li,  0 PSAY "Total Geral : "
	@li, 88 PSAY nGerOrig       PicTure tm(nGerOrig,15)
	@li,104 PSAY nGerJuros      PicTure tm(nGerJuros,14)
	@li,119 PSAY nGerMulta      PicTure tm(nGerMulta,14)
	@li,134 PSAY nGerCM         PicTure tm(nGerCM ,14)
	@li,149 PSAY nGerDesc       PicTure tm(nGerDesc,14)
	@li,165 PSAY nGerAbat       PicTure tm(nGerAbat,14)
	@li,181 PSAY nGerValor      PicTure tm(nGerValor,15)
	If (nGerValor != nGerBaixado) .or. (nGerMovFin != 0)
      @li,197 PSAY "Baixados"
      @li,206 PSAY nGerBaixado    PicTure tm(nGerBaixado,15)
      li := li + 1
      @li,197 PSAY "Mov Fin."
      @li,206 PSAY nGerMovFin   PicTure tm(nGerMovFin,15)
	Endif
	roda(cbcont,cbtxt,"G")
Endif


dbSelectArea("TRB")
dbCloseArea()
Ferase(cNomArq1+getdbextension())
dbSelectArea("SE5")
RetIndex("SE5")
Set Filter to
If nOrdem == 4 .or. nOrdem == 5 .or. nOrdem == 6
	Ferase(cNomeArq+OrdBagExt())
Endif
Set Filter to
dbSetOrder( 1 )
  

#ifndef WINDOWS
Set Device To Screen
#endif	

If aReturn[5] == 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
Endif

SET SOFTSEEK OFF

MS_FLUSH()

USER FUNCTION _AjustaSx1
cAlias := Alias()
aPerg  := {}

dbSelectArea("SX1")
If !dbSeek(cPerg+"17")
	RecLock("SX1",.T.)
	Replace X1_GRUPO   	with "FIN190"
	Replace X1_ORDEM   	with "17"
	Replace X1_PERGUNT 	with "Do Lote            ?"
	Replace X1_VARIAVL 	with "mv_chj"
	Replace X1_TIPO	 	with "C"
	Replace X1_TAMANHO 	with 4
	Replace X1_GSC	   	with "G"
	Replace X1_VAR01   	with "mv_par17"
	MsUnlock()
EndIf

dbSelectArea("SX1")
If !dbSeek(cPerg+"18")
	RecLock("SX1",.T.)
	Replace X1_GRUPO   	with "FIN190"
	Replace X1_ORDEM   	with "18"
	Replace X1_PERGUNT 	with "Ate o Lote         ?"
	Replace X1_VARIAVL 	with "mv_chk"
	Replace X1_TIPO	 	with "C"
	Replace X1_TAMANHO 	with 4
	Replace X1_GSC	   	with "G"
	Replace X1_VAR01   	with "mv_par18"
	MsUnlock()	
EndIf
dbSelectArea(cAlias)
Return


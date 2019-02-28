#Include "Protheus.Ch"
#include "vit270.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VIT270    ³ Autor ³ Eduardo Riera         ³ Data ³ 10.06.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Livro de Controle de Icms sobre Ativo Permanente³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MATR995(void)                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracoes³ BOPS ³ Data   ³ Descricao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user Function vit270
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local	Titulo	 :=	STR0001 //"Controle de Credito de ICMS do Ativo Permanente"
Local cDesc1	 :=	STR0002 //"Emissao dos Registros do CIAP"
Local cDesc2	 :=	STR0003 //"	Este programa ira imprimir os Registros referentes ao CIAP,"
Local cDesc3	 :=	STR0004 //"conforme os parametro solicitados."
Local NomeProg	 :=	"VIT270"
Local cPerg   	 :=	"PERGVIT270"
Local cString    :="SF9"
Local cEstado	:= Iif ((GetNewPar ("MV_ESTADO", "X")<>"X"), GetMv ("MV_ESTADO"), "")
Local nPagIni	 := 0
Local nQtFeixe	 := 0
Private aReturn  := { STR0005 , 1,STR0006, 2 , 2, 1, "",1 } //"Zebrado"###"Administracao"
Private Limite   := 132
Private Tamanho  := "M"
Private nLastKey := 0
Private lEnd 	  := .F.
Private cFiltro  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta grupo de perguntas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                             ³
//³ mv_par01             // Codigo De   ?                            ³
//³ mv_par02             // Codigo Ate  ?                            ³
//³ mv_par03             // Modelo A,B,C ou D                        ³
//³ mv_par04             // Data Fiscal de ?                         ³
//³ mv_par05             // Data Fiscal Ate?                         ³
//³ mv_par06             // Taxa da UFIR ?                           ³
//³ mv_par07             // Ac. Demonst. de Apuracao                 ³
//³ mv_par08             // Data Ativo De ?                          ³
//³ mv_par09             // Data Ativo Ate ?                         ³
//³ mv_par10             // Imprime ? (Livro/Termos/Livro e Termos)  ³
//³ mv_par11             // No. de Ordem ?                           ³
//³ mv_par12             // No. Pagina Inicial ?                     ³
//³ mv_par13             // Qtd. Paginas/Feixe ?                     ³
//³ mv_par14             // No. Junta Comercial ?                    ³
//³ mv_par15             // Observacoes                              ³
//³ mv_par16             // CRC do Contador ?                        ³
//³ mv_par17             // Ultimo Lancamento efetuado em ../../..   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel	:=	"VIT270"+Alltrim(cusername)   // nome default do relatorio em disco
wnrel	:=	SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)
If nLastKey==27
	Set Filter To
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey==27
	Set Filter To
	Return
Endif
cFiltro :=aReturn[7]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Termo de Abertura                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPagIni  := mv_par12	//Pagina Inicial
nQtFeixe := mv_par13	//Qtd. Paginas/Feixe

If MV_PAR10 == 2 .Or. MV_PAR10 == 3
	RptStatus({|| ImprimeTermo(nPagIni,nQtFeixe,"LCIAPA.TRM",220,cPerg)},Titulo)
Endif

If MV_PAR10 <> 2	
	If MV_PAR03 == 1
		If ("RJ"$AllTrim (cEstado)) .And. (MV_PAR08>=SToD ("20000801"))
			RptStatus({|lEnd| R995RjA(@lEnd,wnRel,cString,Tamanho,nPagIni, cEstado)},Titulo)
		Else
			RptStatus({|lEnd| R995LivroA(@lEnd,wnRel,cString,Tamanho,nPagIni)},Titulo)
		EndIf
	Elseif MV_PAR03 == 2
		RptStatus({|lEnd| R995LivroB(@lEnd,wnRel,cString,Tamanho)},Titulo)
	Elseif MV_PAR03 == 3
		If (AllTrim (cEstado)=="BA")
			RptStatus({|lEnd| R995BahiaC(@lEnd,wnRel,cString,Tamanho, cEstado,nPagIni)},Titulo)
		Else
			RptStatus({|lEnd| R995LivroC(@lEnd,wnRel,cString,Tamanho,nPagIni)},Titulo)
		EndIf
	Elseif MV_PAR03 == 4
		RptStatus({|lEnd| R995LivroD(@lEnd,wnRel,cString,Tamanho)},Titulo)
	EndIf
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Termo de Encerramento                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR10 == 2 .Or. MV_PAR10 == 3
    dbSelectArea("SF9")
	ImprimeTermo(nPagIni,nQtFeixe,"LCIAPE.TRM",220,cPerg,Titulo)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Ambiente                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF9")
dbSetOrder(1)
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	OurSpool(wnrel)
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R995Livro() ³ Autor ³Aline Correa do Vale³ Data ³ 24/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Livro Modelo A                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR995()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R995LivroA(lEnd,wnRel,cString,Tamanho,nPagIni)

Local aLay   	:= Array(59)
Local nLin   	:= 0
Local aLin   	:= Array(10)
Local nCntFor	:= 0
Local aResumo	:= Array(12,7)
Local nResumo	:= 0
Local dData	 	:= Ctod("")
Local nBaixa	:= 0
Local nFolha	:= nPagIni
Local dLei102 := GetMV("MV_DATCIAP")
Local nCol      := 0
Local nCol1     := 0
Local nSaldo    := 0
Local nEstorno  := 0
Local lQuadro2  :=.F.

For nCntFor := 1 To Len(aResumo)
	For nResumo := 1 To Len(aResumo[nCntFor])
		aResumo[nCntFor][nResumo] := 0
	Next nResumo
Next nCntFor

R995LayOut(@aLay)

dbSelectArea("SF9")
dbSetOrder(1)
dbSeek(xFilial("SF9")+MV_PAR01,.T.)

SetRegua(SF9->(LastRec()))

While ( !Eof() .And. xFilial("SF9")==SF9->F9_FILIAL .And.;
		SF9->F9_CODIGO <= MV_PAR02 )

	IF SF9->F9_DTENTNE >= dLei102
		SF9->(dbSkip())
		loop
	EndIf

	If Interrupcao(@lEnd)
		Exit
	EndIf

	If ( nLin > 60 .Or. nLin == 0 )
		If ( nLin == 60 )
			FmtLin(,aLay[17],,,@nLin)
		EndIf
		nLin := 0
		@ nLin,000 PSAY aValImp(Limite)
		nLin++
		nFolha ++
		FmtLin(,aLay[30],,,@nLin)
		FmtLin(,aLay[31],,,@nLin)
		FmtLin(,aLay[32],,,@nLin)
		FmtLin({StrZero(Year(MV_PAR04),4),StrZero(nFolha,4)},aLay[33],,,@nLin)
		FmtLin(,aLay[01],,,@nLin)
		FmtLin(,aLay[02],,,@nLin)
		FmtLin(,aLay[03],,,@nLin)
		FmtLin({SM0->M0_NOMECOM,Transf(SM0->M0_CGC,"@R 99.999.999/9999-99"),SM0->M0_INSC},aLay[04],,,@nLin)
		FmtLin({SM0->M0_ENDENT,SM0->M0_BAIRENT,SM0->M0_CIDENT},aLay[05],,,@nLin)
		FmtLin(,aLay[06],,,@nLin)
		FmtLin(,aLay[07],,,@nLin)
		FmtLin(,aLay[08],,,@nLin)
		FmtLin(,aLay[09],,,@nLin)
		FmtLin(,aLay[10],,,@nLin)
		FmtLin(,aLay[11],,,@nLin)
		FmtLin(,aLay[12],,,@nLin)
		FmtLin(,aLay[13],,,@nLin)
		FmtLin(,aLay[14],,,@nLin)
		FmtLin(,aLay[15],,,@nLin)
	EndIf

	dData := SF9->F9_DTENTNE
	nBaixa:= 0
	dbSelectArea("SFA")
	dbSetOrder(1)
	dbSeek(xFilial("SFA")+SF9->F9_CODIGO)
	While ( !Eof() .And. xFilial("SFA") == SFA->FA_FILIAL .And.;
			SF9->F9_CODIGO == SFA->FA_CODIGO )

		if SFA->FA_CREDIT == "1"
			dbSkip()
			loop
		EndIF

		If ( Year(MV_PAR04) == Year(SFA->FA_DATA) )
			nResumo := Month(SFA->FA_DATA)
			If ( SFA->FA_TIPO == "1" ) //Estorno Mensal
				aResumo[nResumo][5] += SFA->FA_VALOR
			Else								//Baixa
				dData := SFA->FA_DATA
				aResumo[nResumo][6] += SFA->FA_VALOR
			EndIf
			aResumo[nResumo][7] += SFA->FA_VALOR
			nBaixa	+= SFA->FA_VALOR
		EndIf
		dbSelectArea("SFA")
		dbSkip()
	EndDo
	FmtLin({ SF9->F9_CODIGO,;
		dData,;
		If(Empty(SF9->F9_DOCNFS),SF9->F9_DOCNFE,SF9->F9_DOCNFS),;
		SF9->F9_DESCRI,;
		SF9->F9_VALICMS,;
		nBaixa,;
		SF9->F9_VALICMS-nBaixa},aLay[16],,,@nLin)
	nResumo := Month(dData)
	lQuadro2 :=.T.
	dbSelectArea("SF9")
	aResumo[nResumo][4] += SF9->F9_VALICMS
	dbSkip()
	IncRegua()
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculando as movimentacoes do SF3                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF3")
dbSetOrder(1)
dbSeek(xFilial("SF3")+Dtos(MV_PAR04),.T.)
SetRegua(SF3->(LastRec()))
While ( !Eof() .And. xFilial("SF3") == SF3->F3_FILIAL .And.;
		MV_PAR04			<= SF3->F3_ENTRADA.And.;
		MV_PAR05			>= SF3->F3_ENTRADA )
	nResumo := Month(SF3->F3_ENTRADA)
	If !empty(SF3->F3_DTCANC)
		dbskip()
		loop
	EndIf	
	IF Substr(SF3->F3_CFO,1,1) >= '5'
		aResumo[nResumo][1] += SF3->F3_BASEICM+SF3->F3_ISENICM+SF3->F3_OUTRICM
		aResumo[nResumo][2] += SF3->F3_ISENICM
		aResumo[nResumo][3] := NoRound(aResumo[nResumo][2]/aResumo[nResumo][1],4)
	EndIf
	dbSelectArea("SF3")
	dbSkip()
	IncRegua()
EndDo
For nCol:= Len(aResumo) to 1 Step -1
	If aResumo[nCol][4] > 0 .Or. aResumo[nCol][7] > 0
		nSaldo   := aResumo[nCol][4]
		nEstorno := aResumo[nCol][7]
		For nCol1 := nCol-1 to 1 Step -1
			nSaldo   += aResumo[nCol1][4]
			nEstorno += aResumo[nCol1][7]
			If nCol1 == 1
				aResumo[nCol][4] := (nSaldo - nEstorno)
			EndIf
		Next
		If nCol == 1
			aResumo[nCol][4] := (nSaldo - nEstorno)
		EndIF
	EndIf
Next

IF lQuadro2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Impressao do Demonstrativo do Estorno de Credito                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( nLin > 40 )
		FmtLin(,aLay[17],,,@nLin)
		nLin := 0
		@ nLin,000 PSAY aValImp(Limite)
	Else
		FmtLin(,aLay[17],,,@nLin)
	EndIf
	FmtLin(,aLay[18],,,@nLin)
	FmtLin(,aLay[19],,,@nLin)
	FmtLin(,aLay[20],,,@nLin)
	FmtLin(,aLay[21],,,@nLin)
	FmtLin(,aLay[22],,,@nLin)
	FmtLin(,aLay[23],,,@nLin)
	FmtLin(,aLay[24],,,@nLin)
	FmtLin(,aLay[25],,,@nLin)
	FmtLin(,aLay[26],,,@nLin)
	FmtLin(,aLay[27],,,@nLin)

	For nCntFor := 1 To 12
		If ( nLin > 60 )
			FmtLin(,aLay[29],,,@nLin)
			nLin := 0
			@ nLin,000 PSAY aValImp(Limite)
			FmtLin(,aLay[18],,,@nLin)
			FmtLin(,aLay[19],,,@nLin)
			FmtLin(,aLay[20],,,@nLin)
			FmtLin(,aLay[21],,,@nLin)
			FmtLin(,aLay[22],,,@nLin)
			FmtLin(,aLay[23],,,@nLin)
			FmtLin(,aLay[24],,,@nLin)
			FmtLin(,aLay[25],,,@nLin)
			FmtLin(,aLay[26],,,@nLin)
			FmtLin(,aLay[27],,,@nLin)
		EndIf
		FmtLin({ MesExtenso(nCntFor),; 	//Mes
			aResumo[nCntFor,2],;	//Isentas ou N.Tributadas
			aResumo[nCntFor,1],;	//Total das Saidas
			TransForm(aResumo[nCntFor,3],Tm(aResumo[nCntFor,3],8,4)),;	//Coeficiente de Estorno
			aResumo[nCntFor,4],;	//Saldo aCumulado
			"1/60",;
			aResumo[nCntFor,5],;	// Estorno por Saidas isentas ou nao tributadas
			aResumo[nCntFor,6],;	// Estorno por Saida ou Perda
			aResumo[nCntFor,7],;	// Total do Estorno Mensal
			},aLay[28],,,@nLin)
	Next nCntFor
	If !(nLin > 60)
		FmtLin(,aLay[29],,,@nLin)
	EndIf
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R995LivroB()³ Autor ³ Eduardo Riera      ³ Data ³10/06/98  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Livro                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR995()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R995LivroB(lEnd,wnRel,cString,Tamanho)

Local aLay   := Array(59)
Local nLin   := 0
Local aLin   := Array(10)
Local nTotal1:= 0
Local nTotal2:= 0
Local nMes   := 0
Local nAno   := 0
Local aEstMes:= Array(5,12,2)
Local aEst   := Array(5,2)
Local nCntFor:= 0
Local dLei102 := GetMV("MV_DATCIAP")

R995LayOut(@aLay)

dbSelectArea("SF9")
dbSetOrder(1)
dbSeek(xFilial("SF9")+MV_PAR01,.T.)
nValIcm	:=SF9->F9_VALICMS
SetRegua(LastRec())

While ( !Eof() .And. xFilial("SF9")==SF9->F9_FILIAL .And.;
		SF9->F9_CODIGO <= MV_PAR02 )

	IF SF9->F9_DTENTNE >= dLei102
		SF9->(dbSkip())
		loop
	EndIf

	nLin := 0

	nTotal1 := 0
	nTotal2 := 0

	If Interrupcao(@lEnd)
		Exit
	Endif

	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+SF9->F9_FORNECE+SF9->F9_LOJAFOR)

	@ nLin,000 PSAY aValImp(Limite)
	nLin++
	FmtLin(,aLay[01],,,@nLin)
	FmtLin(,aLay[02],,,@nLin)
	FmtLin({SF9->F9_CODIGO},aLay[03],"@er 999999",,@nLin)
	FmtLin(,aLay[04],,,@nLin)
	FmtLin(,aLay[05],,,@nLin)
	FmtLin(,aLay[06],,,@nLin)
	FmtLin({SM0->M0_NOMECOM,SM0->M0_INSC},aLay[07],,,@nLin)
	FmtLin(,aLay[08],,,@nLin)
	FmtLin({SF9->F9_DESCRI},aLay[09],,,@nLin)
	FmtLin({},aLay[10],,,@nLin)
	FmtLin(,aLay[11],,,@nLin)
	FmtLin(,aLay[12],,,@nLin)
	FmtLin({SA2->A2_NOME,SF9->F9_DOCNFE},aLay[13],,,@nLin)
	FmtLin(,aLay[14],,,@nLin)
	FmtLin({ Transform(SF9->F9_NLRE,"@er9999"),;
		TransForm(SF9->F9_FLRE,"@er9999"),;
		Dtoc(SF9->F9_DTENTNE),;
		TransForm(SF9->F9_VALICMS,"@er 999,999,999.99")},aLay[15],,,@nLin)
	FmtLin(,aLay[16],,,@nLin)
	FmtLin(,aLay[17],,,@nLin)
	FmtLin(,aLay[18],,,@nLin)
	FmtLin({ SF9->F9_DOCNFS,SF9->F9_SERNFS,SF9->F9_DTEMINS},aLay[19],,,@nLin)
	FmtLin(,aLay[20],,,@nLin)
	FmtLin(,aLay[21],,,@nLin)
	FmtLin(,aLay[22],,,@nLin)
	FmtLin(,aLay[23],,,@nLin)
	FmtLin(,aLay[24],,,@nLin)

	For nCntFor := 1 To Len(aEstMes)
		For nCnt := 1 To Len(aEstMes[nCntFor])
			aEstMes[nCntFor,nCnt,1] := 0
			aEstMes[nCntFor,nCnt,2] := 0
		Next
	Next
	For nCntFor := 1 To Len(aEst)
		aEst[nCntfor,1] := 0
		aEst[nCntfor,2] := 0
	Next

	dbSelectArea("SFA")
	dbSetOrder(1)
	dbSeek(xFilial("SFA")+SF9->F9_CODIGO)
	While ( !Eof() .And. xFilial("SFA") == SFA->FA_FILIAL .And. ;
			SFA->FA_CODIGO == SF9->F9_CODIGO )

		if SFA->FA_CREDIT == "1"
			dbSkip()
			loop
		EndIf

		nAno := Year(SFA->FA_DATA)-Year(SF9->F9_DTENTNE)
		nMes := Month(SFA->FA_DATA)-Month(SF9->F9_DTENTNE)+1
		nMes += (12*nAno)
		nAno := Int(nMes/12)
		nMes := nMes % 12
		If ( nMes == 0 )
			nMes := 12
		Else
			nAno ++
		EndIf
		If ( SFA->FA_TIPO == "1" )
			aEstMes[nAno,nMes,1] := SFA->FA_FATOR
			aEstMes[nAno,nMes,2] := SFA->FA_VALOR
		Else
			aEst[nAno,1] := SFA->FA_FATOR
			aEst[nAno,2] := SF9->F9_BXICMS - SF9->F9_VLESTOR
		EndIf

		dbSelectArea("SFA")
		dbSkip()
	EndDo
	For nCntFor := 1 To 12
		aLin[1] := TransForm(aEstMes[1,nCntFor,1],PesqPict("SFA","FA_FATOR"))
		aLin[2] := TransForm(aEstMes[1,nCntFor,2],"@er 99,999,999.99")
		aLin[3] := TransForm(aEstMes[2,nCntFor,1],PesqPict("SFA","FA_FATOR"))
		aLin[4] := TransForm(aEstMes[2,nCntFor,2],"@er 99,999,999.99")
		aLin[5] := TransForm(aEstMes[3,nCntFor,1],PesqPict("SFA","FA_FATOR"))
		aLin[6] := TransForm(aEstMes[3,nCntFor,2],"@er 99,999,999.99")
		aLin[7] := TransForm(aEstMes[4,nCntFor,1],PesqPict("SFA","FA_FATOR"))
		aLin[8] := TransForm(aEstMes[4,nCntFor,2],"@er 9,999,999.99")
		aLin[9] := TransForm(aEstMes[5,nCntFor,1],PesqPict("SFA","FA_FATOR"))
		aLin[10]:= TransForm(aEstMes[5,nCntFor,2],"@er 9999,999.99")
		FmtLin(@aLin,aLay[23+nCntFor*2],,,@nLin)
		FmtLin(,aLay[24+nCntFor*2],,,@nLin)
	Next nCntFor
	FmtLin(,aLay[49],,,@nLin)
	FmtLin(,aLay[50],,,@nLin)
	FmtLin(,aLay[51],,,@nLin)
	For nCntFor := 1 To 5
		aLin[1] := TransForm(aEst[nCntFor,1],PesqPict("SFA","FA_FATOR"))
		aLin[2] := TransForm(aEst[nCntFor,2],"@er 999,999,9999.99")
		FmtLin(@aLin,aLay[51+nCntFor],,,@nLin)
		nTotal1 += aEst[nCntFor,1]
		nTotal2 += aEst[nCntFor,2]
	Next
	aLin[1] := TransForm(nTotal1,PesqPict("SFA","FA_FATOR"))
	aLin[2] := TransForm(nTotal2,"@er 999,999,9999.99")
	FmtLin(,aLay[57],,,@nLin)
	FmtLin(@aLin,aLay[58],,,@nLin)
	FmtLin(,aLay[59],,,@nLin)

	dbSelectArea("SF9")
	dbSkip()
	IncRegua()
EndDo
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R995LivroC()³ Autor ³Aline Correa do Vale³ Data ³ 24/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Livro Modelo C                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR995()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R995LivroC(lEnd,wnRel,cString,Tamanho,nPagIni)
	Local aLay   		:=	Array(59)
	Local aResumo		:= 	Array(12,7)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lay-Out do Array (aResumo)           ³
	//³ 01  Mes                              ³
	//³ 02  Saidas e Prestacoes Tributadas   ³
	//³ 03  Total das Saidas e Prestacoes    ³
	//³ 04  Coeficiente de Apropriacao       ³
	//³ 05  Total de Credito a Apropriar     ³
	//³ 06  Fracao Mensal                    ³
	//³ 07  Credito Mensal a Apropriar       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aStruSF9  	:= 	{}
	Local aStruSFA  	:= 	{}
	Local nLin   		:= 	0
	Local nCntFor		:= 	0
	Local nResumo		:= 	0
	Local nBaixa		:= 	0
	Local nFolha    	:= 	nPagIni
	Local nX        	:= 	0
	Local dLei102   	:= 	GetNewPar("MV_DATCIAP",ctod("01/01/2001"))
	Local dData	 		:= 	Ctod("")
	Local dDataNFS 		:= 	Ctod("")
	Local cQuery   	 	:= 	""
	Local cAliasSF9 	:= 	""
	Local cAliasSFA 	:= 	""
	Local lQuadro2  	:=	.F.
	Local lSd2      	:= 	.F.
	Local lIcmsDif  	:= 	.F.
	Local nSaldoAcu 	:= 	0
	Local nSalQdr2  	:= 	0
	Local cLnCiapMg 	:= 	GetNewPar("MV_FSNCIAP","1")
	Local cIndSF9		:= 	""
	Local cChave		:= 	""
	Local cFilSF9		:= 	""                                                                                           
	Local nIndex		:= 	0
	Local cCfopExp		:= 	GetNewPar("MV_CFOPEXP","")	//CFOPs com fins de exportacao. Tratamento deve ser o mesmo de exportacao.
	Local cAliasSd2		:= 	""
	Local aStruSD2		:= 	{}
	Local cArqD2		:=	""
	Local cNf			:=	""
	Local cSer			:=	""
	Local cCli			:=	""
	Local cLj			:=	""
	Local lCiapTot		:= 	GetNewPar("MV_CIAPTOT",.F.)
	Local lSkipSD2 	 	:= 	.F.
	Local cCfopVen		:= 	GetNewPar("MV_CIAPCFO","")
	Local cCfopExc		:= 	GetNewPar("MV_CFOPEXC","")
	Local cConcatena	:= 	"" 
	Local lUpf			:= 	(mv_par18>0) .And. GetNewPar("MV_ESTADO","")=="RS" 		//UPF-RS
	Local cUF			:= 	GetMv("MV_ESTADO")
	Local nLimite		:=	0
	Local nMesBx		:=	0
	Local nAnoBx		:=	0
	Local dUltDtSfa		:=	CToD ("//")
	Local nPosApr		:=	0
	Local aAprop		:=	{}
	//
	DbSelectArea ("SX6")
	SX6->(DbSeek (xFilial ("SX6")+"MV_CIAPX"))
	Do While !SX6->(Eof ()) .And. xFilial ("SX6")==SX6->X6_FIL .And. "MV_CIAPX"$SX6->X6_VAR
		cConcatena	:=	AllTrim (SX6->X6_CONTEUD)
		If !Empty (cConcatena)
			If SubStr (cCfopVen, Len (cCfopVen), 1)$"\/#*"
				If SubStr (cConcatena, 1, 1)$"\/#*"
					cCfopVen	+=	SubStr (cConcatena, 2)
				Else
					cCfopVen	+=	cConcatena
				EndIf
			Else
				If SubStr (cConcatena, 1, 1)$"\/#*"
					cCfopVen	+=	cConcatena
				Else
					cCfopVen	+=	"/"+cConcatena
				EndIf
			EndIf
		EndIf
		//
		SX6->(DbSkip ())
	EndDo
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calculando as movimentacoes do SF3                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cquery:=" SELECT"
	_cquery+=" SUBSTR(F3_ENTRADA,5,2) MES,"
	_cquery+=" SUM(F3_BASEICM) F3_BASEICM,"
	_cquery+=" SUM(F3_VALCONT) F3_VALCONT"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("SF3")+" SF3"
	
	_cquery+=" WHERE"
	_cquery+="     SF3.D_E_L_E_T_=' '"
	_cquery+=" AND F3_FILIAL='"+xfilial("SF3")+"'"
	_cquery+=" AND F3_ENTRADA BETWEEN '"+dtos(mv_par04)+"' AND '"+dtos(mv_par05)+"'"
	_cquery+=" AND F3_CFO>'5'"
	_cquery+=" AND F3_DTCANC='        '"
	
	_cquery+=" GROUP BY"
	_cquery+=" SUBSTR(F3_ENTRADA,5,2)"
	
	_cquery+=" ORDER BY"
	_cquery+=" 1"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP1"
	tcsetfield("TMP1","F3_BASEICM","N",15,2)
	tcsetfield("TMP1","F3_VALCONT","N",15,2)
	
	aaprop:={}
	
	tmp1->(dbgotop())
	while ! tmp1->(eof())
		aadd(aaprop,{tmp1->mes,tmp1->f3_baseicm,tmp1->f3_valcont,round(tmp1->f3_baseicm/tmp1->f3_valcont,4),})
		
		tmp1->(dbskip())
	end
	tmp1->(dbclosearea())
	
//	aAprop	:=	CoefApr (MV_PAR04, MV_PAR05)	//MATA906
	//
	For nCntFor := 1 To Len (aResumo)
		aResumo[nCntFor][01]	:=	MesExtenso(nCntFor)
		//
		For nResumo := 2 To Len (aResumo[nCntFor])
//			If (nPosApr := aScan (aAprop, {|aX| Val (SubStr (aX[1], 5, 2))==nCntFor}))<>0 .And. (nResumo==2 .Or. nResumo==3 .Or. nResumo==4)
			If (nPosApr := aScan (aAprop, {|aX| Val (aX[1])==nCntFor}))<>0 .And. (nResumo==2 .Or. nResumo==3 .Or. nResumo==4)
				aResumo[nCntFor][nResumo] := aAprop[nPosApr][nResumo]
			Else
				aResumo[nCntFor][nResumo] := 0
			EndIf			
		Next nResumo
	Next nCntFor
	//
	R995LayOut(@aLay)
	//
	DbSelectArea("SF9")
		DbSetOrder (1)
	//
	#IFDEF TOP
		cAliasSF9	:= 	"AliasSF9"
		aStruSF9 	:= 	SF9->(dbStruct())
		cQuery    	:= 	"SELECT * "
		cQuery    	+= 	"FROM "+RetSqlName("SF9")+" SF9 "
		cQuery    	+=	"WHERE SF9.F9_FILIAL='"+xFilial("SF9")+"' AND "
		cQuery    	+=	"SF9.F9_CODIGO >= '"+MV_PAR01+"' AND "
		cQuery    	+=	"SF9.F9_CODIGO <= '"+MV_PAR02+"' AND "
		//
		If !Empty (MV_PAR08)
			cQuery	+=	"SF9.F9_DTENTNE>'"+DtoS (dLei102)+"' AND "
			cQuery	+=	"SF9.F9_DTENTNE>='"+DtoS (Mv_Par08)+"' AND "
			cQuery	+=	"SF9.F9_DTENTNE<='"+DtoS (Mv_Par09)+"' AND "
		Endif
		cQuery	+=	"SF9.D_E_L_E_T_=' ' "
		cQuery	+=	"ORDER BY "+SqlOrder(SF9->(IndexKey()))
		//
		cQuery    := ChangeQuery(cQuery)
		//
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF9,.T.,.T.)
		//
		For nX := 1 To Len (aStruSF9)
			If (aStruSF9[nX][2]<>"C")
				TcSetField (cAliasSF9, aStruSF9[nX][1], aStruSF9[nX][2], aStruSF9[nX][3], aStruSF9[nX][4])
			EndIf
		Next (nX)
	#ELSE
		cAliasSF9	:= 	"SF9"
		cIndSF9		:= 	CriaTrab (NIL, .F.)
		cChave	  	:= 	IndexKey ()
		cFilSF9	  	:=	"F9_FILIAL=='"+xFilial("SF9")+"' .And. F9_CODIGO>='"+MV_PAR01+"' .And. F9_CODIGO<='"+MV_PAR02+"'"	
		If !Empty(mv_par08)
			cFilSF9	+=	" .And. Dtos(F9_DTENTNE)>='"+DtoS (MV_PAR08)+"' .And. DtoS (F9_DTENTNE)<='"+DtoS (MV_PAR09)+"'"	
			cFilSF9	+= 	" .And. Dtos(F9_DTENTNE)>'"+DtoS (dLei102)+"'"	
		Endif
		//
		IndRegua (cAliasSF9, cIndSF9, cChave,, cFilSF9)
		nIndex := RetIndex ("SF9")
		DbSelectArea ("SF9")
		DbSetIndex (cIndSF9+OrdBagExt ())
		DbSetOrder (nIndex+1)
		(cAliasSF9)->(DbGoTop ())
	#ENDIF
	//
	SetRegua (SF9->(LastRec ()))
	While !Eof()	
		If !Empty (cFiltro).And. !(cAliasSF9)->((&(cFiltro)))
			(cAliasSF9)->(DbSkip ())
			Loop
		Endif		
		//
		If (Interrupcao (@lEnd))
			Exit
		EndIf
		//
		//
		dUltDtSfa	:=	CToD ("//")
		dData   	:=	(cAliasSF9)->F9_DTENTNE
    	dDataNFS	:=	(cAliasSF9)->F9_DTEMINS
		nSaldoAcu	:=	0
		nBaixa		:=	0
		If (dData>=dLei102)
			nLimite  := 4
		Else
			nLimite  := 5
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao da Identificacao do Estabelecimento ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nLin>=60 .Or. nLin==0)
			If (nLin>=60)
				FmtLin (, aLay[18],,, @nLin)
			EndIf
			nLin := 0
			@ nLin, 000 PSAY aValImp (Limite)
			nLin++
			FmtLin (, aLay[30],,,@nLin)
			FmtLin (, aLay[31],,,@nLin)
			FmtLin (, aLay[32],,,@nLin)
			FmtLin ({StrZero (Year (MV_PAR04), 4),StrZero (nFolha, 4)}, aLay[33],,, @nLin)
			nFolha++
			FmtLin (, aLay[01],,,@nLin)
			FmtLin (, aLay[02],,,@nLin)
			FmtLin (, aLay[03],,,@nLin)
			FmtLin ({SM0->M0_NOMECOM, Transform (SM0->M0_CGC, "@R 99.999.999/9999-99"), SM0->M0_INSC}, aLay[04],,, @nLin)
			FmtLin ({SM0->M0_ENDENT, SM0->M0_BAIRENT, SM0->M0_CIDENT}, aLay[05],,, @nLin)
			FmtLin (, aLay[06],,, @nLin)
			FmtLin (, aLay[07],,, @nLin)
			FmtLin (, aLay[08],,, @nLin)
			FmtLin (, aLay[09],,, @nLin)
			FmtLin (, aLay[10],,, @nLin)
			FmtLin (, aLay[11],,, @nLin)
			FmtLin (, aLay[12],,, @nLin)
			FmtLin (, aLay[13],,, @nLin)
			FmtLin (, aLay[14],,, @nLin)
			FmtLin (, aLay[15],,, @nLin)
			//
			If (MV_PAR07==1)
				FmtLin (,aLay[16],,,@nLin)
			Endif
		EndIf
	
		DbSelectArea ("SFA")
			DbSetOrder (1)
		//
		#IFDEF TOP
			cAliasSFA 	:=	"AliasSFA"
			aStruSFA  	:=	SFA->(dbStruct())
			cQuery    	:= 	"SELECT * "
			cQuery    	+= 	"FROM "+RetSqlName("SFA")+" SFA "
			cQuery    	+= 	"WHERE "
			cQuery    	+= 	"SFA.FA_FILIAL='"+xFilial ("SFA")+"' AND "
			cQuery    	+= 	"SFA.FA_CODIGO='"+(cAliasSF9)->F9_CODIGO+"' AND "
			cQuery    	+= 	"SFA.FA_CREDIT<>'2' AND "
			cQuery    	+= 	"((SFA.FA_DATA>='"+StrZero (Year (MV_PAR04), 4)+"0101' AND "
			cQuery    	+= 	"SFA.FA_DATA <= '"+StrZero (Year (MV_PAR05), 4)+"1231') OR "
			cQuery    	+= 	"SFA.FA_TIPO='2') AND "
			cQuery    	+= 	"D_E_L_E_T_=' ' "
			cQuery    	+= 	"ORDER BY "+SqlOrder(SFA->(IndexKey ()))
			//
			cQuery    	:= ChangeQuery (cQuery)
			//
			DbUseArea (.T., "TOPCONN", TcGenQry (,,cQuery), cAliasSFA, .T., .T.)
			For nX := 1 To Len (aStruSFA)
				If (aStruSFA[nX][2]<>"C")
					TcSetField (cAliasSFA, aStruSFA[nX][1], aStruSFA[nX][2], aStruSFA[nX][3], aStruSFA[nX][4])
				EndIf
			Next (nX)
		#ELSE
			cAliasSFA	:=	"SFA"
			dbSeek(xFilial("SFA")+(cAliasSF9)->F9_CODIGO)
		#ENDIF
		//
		While (!Eof () .And. xFilial ("SFA")==(cAliasSFA)->FA_FILIAL .And. (cAliasSF9)->F9_CODIGO==(cAliasSFA)->FA_CODIGO)
			//
			#IFNDEF TOP
				If ! (DToS ((cAliasSFA)->FA_DATA)>=StrZero (Year (MV_PAR04), 4)+"0101" .And.;
						DToS ((cAliasSFA)->FA_DATA)<=StrZero (Year (MV_PAR05), 4)+"1231")
					DbSkip ()
					loop
				EndIf
			#ENDIF
			//
			If (Fieldpos ("FA_CREDIT")<>0)
				If ((cAliasSFA)->FA_CREDIT=="2")
					DbSkip()
					Loop
				EndIF
			EndIf
			//
			//O Ano da apropiracao deve ser o mesmo do solicitado atraves do parametro. Devo considerar indepenente do parametro o bem que tenha sofrido baixa.
			If (Year(MV_PAR04)==Year((cAliasSFA)->FA_DATA)) .Or. ((cAliasSFA)->FA_TIPO=="2")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se tiver havido baixa atraves da rotina e nao vencido as 48 ³
				//³parcelas, pois qdo vencer as 48 parcelas eh apresentado a   ³
				//³baixa automaticamente no livro. No calculo do estorno nao   ³
				//³eh mais considerado qdo vencer as 48 parcelas.              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ((cAliasSFA)->FA_TIPO=="2")
					nBaixa	+=	(cAliasSFA)->FA_VALOR             // Somatoria das Baixas
				Else
					nMes	:=	Month ((cAliasSFA)->FA_DATA)
					aResumo[nMes][7]	+=	(cAliasSFA)->FA_VALOR/Iif(lUPF .And. (cAliasSF9)->(FieldPos("F9_VALUPF"))>0,(cAliasSF9)->F9_VALUPF,1)  // Credito Mensal a Apropriar
				EndIf                                            
			EndIf                                             
			//
		   If (MV_PAR07==1)
			  	nSaldoAcu	:=	If(MV_PAR06>0, ((cAliasSF9)->F9_VALICMS/mv_par06)-(nBaixa/mv_par06), ((cAliasSF9)->F9_VALICMS-nBaixa))
			Else
				nSaldoAcu	:=	(cAliasSF9)->F9_VALICMS-nBaixa
			EndIf
			nResumo  :=	Month ((cAliasSFA)->FA_DATA)
			aResumo[nResumo][5]	+=	nSaldoAcu/Iif(lUPF .And. (cAliasSF9)->(FieldPos("F9_VALUPF"))>0,(cAliasSF9)->F9_VALUPF,1)
			//
			dUltDtSfa	:=	(cAliasSFA)->FA_DATA
			//
			DbSelectArea (cAliasSFA)
				DbSkip ()
		EndDo
		//		
		nMesBx		:=	Month (SToD (StrZero (Year (dData), 4)+StrZero (Month (dData), 2)+"01")-1)
		nAnoBx		:=	Year (SToD (StrZero (Year (dData), 4)+StrZero (Month (dData), 2)+"01")-1)+nLimite
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se a baixa foi pelo vencimento das 48 ou 60 parcelas,     ³
		//³caso tenha sido, verifico se a data ate do periodo fiscal          ³
		//³corresponde ao mes da baixa, pois se for no mes da baixa           ³
		//³devo apresentar somente o valor apropriado da ultima parcela       ³
		//³e a baixa no mes seguinte. Agora se for superior, apresento a baixa³
		//³e no quadro de movimentacoes apresento no mes seguinte ao da baixa.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (Year (dUltDtSfa)==nAnoBx) .And. (Month (dUltDtSfa)==nMesBx) .And. dUltDtSfa<LastDay (MV_PAR05)	
			nSaldoAcu	-=	(cAliasSF9)->F9_VALICMS
			nBaixa		:=	(cAliasSF9)->F9_VALICMS
		EndIf
		//
		#IFDEF TOP
			DbSelectArea (cAliasSFA)
			DbCloseArea ()
		#ENDIF
		//
		If (MV_PAR07==1)
			//
			nSalQdr2	+=	nSaldoAcu
			//
			If (lUpf)		//UPF-RS
				FmtLin ({If (cLnCiapMg=="2", Transform ((cAliasSF9)->F9_CODIGO, "@R 9999/99"), (cAliasSF9)->F9_CODIGO),;
				dData,;
				If (Empty ((cAliasSF9)->F9_DOCNFS), (cAliasSF9)->F9_DOCNFE, (cAliasSF9)->F9_DOCNFS),;
				(cAliasSF9)->F9_DESCRI,;
				((cAliasSF9)->F9_VALICMS/Iif((cAliasSF9)->(FieldPos("F9_VALUPF"))>0,(cAliasSF9)->F9_VALUPF,MV_PAR18)),;
				(nBaixa/Iif((cAliasSF9)->(FieldPos("F9_VALUPF"))>0,(cAliasSF9)->F9_VALUPF,MV_PAR18)),;
				(nSalQdr2/Iif((cAliasSF9)->(FieldPos("F9_VALUPF"))>0,(cAliasSF9)->F9_VALUPF,MV_PAR18))}, aLay[17],,, @nLin)
/*
			Elseif (AllTrim (cUF)=="GO")    //UF-GO
				FmtLin ({If (cLnCiapMg=="2", Transform ((cAliasSF9)->F9_CODIGO, "@R 9999/99"), (cAliasSF9)->F9_CODIGO),;
				dData,;
				(cAliasSF9)->F9_DOCNFE,;
				(cAliasSF9)->F9_DESCRI,;
				If (MV_PAR06>0, ((cAliasSF9)->F9_VALICMS/MV_PAR06), (cAliasSF9)->F9_VALICMS),;
				TransForm(0,"@e 99,999,999.99"),;
				If (MV_PAR06>0, ((cAliasSF9)->F9_VALICMS/MV_PAR06), (cAliasSF9)->F9_VALICMS)}, aLay[17],,, @nLin)
				
				If (!Empty ((cAliasSF9)->F9_DOCNFS)) .And. (dDataNFS <= (MV_PAR05))
					FmtLin ({If (cLnCiapMg=="2", Transform ((cAliasSF9)->F9_CODIGO, "@R 9999/99"), (cAliasSF9)->F9_CODIGO),;
					(cAliasSF9)->F9_DTEMINS,;
					(cAliasSF9)->F9_DOCNFS,;
					(cAliasSF9)->F9_DESCRI,;
					TransForm(0,"@e 99,999,999.99"),;
					If(MV_PAR06>0, (nBaixa/MV_PAR06), nBaixa),;
					TransForm(0,"@e 99,999,999.99")}, aLay[17],,, @nLin)
				Endif
*/
			Else
				FmtLin ({If (cLnCiapMg=="2", Transform ((cAliasSF9)->F9_CODIGO, "@R 9999/99"), (cAliasSF9)->F9_CODIGO),;
				dData,;
				(cAliasSF9)->F9_DOCNFE,;
				(cAliasSF9)->F9_DESCRI,;
				If (MV_PAR06>0, ((cAliasSF9)->F9_VALICMS/MV_PAR06), (cAliasSF9)->F9_VALICMS),0,;
				nSalQdr2}, aLay[17],,, @nLin)
				
				If (!Empty ((cAliasSF9)->F9_DOCNFS)) .And. (dDataNFS <= (MV_PAR05))
				
					nSalQdr2	-=	nSaldoAcu
					nbaixa:=(cAliasSF9)->F9_VALICMS
					
					FmtLin ({If (cLnCiapMg=="2", Transform ((cAliasSF9)->F9_CODIGO, "@R 9999/99"), (cAliasSF9)->F9_CODIGO),;
					(cAliasSF9)->F9_DTEMINS,;
					(cAliasSF9)->F9_DOCNFS,;
					(cAliasSF9)->F9_DESCRI,;
					0,If(MV_PAR06>0, (nBaixa/MV_PAR06), nBaixa),;
					nSalQdr2}, aLay[17],,, @nLin)
				Endif
/*			
				FmtLin ({If (cLnCiapMg=="2", Transform ((cAliasSF9)->F9_CODIGO, "@R 9999/99"), (cAliasSF9)->F9_CODIGO),;
				dData,;
				If (Empty ((cAliasSF9)->F9_DOCNFS), (cAliasSF9)->F9_DOCNFE, (cAliasSF9)->F9_DOCNFS),;
				(cAliasSF9)->F9_DESCRI,;
				If (MV_PAR06>0, ((cAliasSF9)->F9_VALICMS/MV_PAR06), (cAliasSF9)->F9_VALICMS),;
				If(MV_PAR06>0, (nBaixa/MV_PAR06), nBaixa),;
				nSalQdr2}, aLay[17],,, @nLin)
*/
			Endif
			//
			lQuadro2 :=.T.
		Else
			If (lUpf)		//UPF-RS
				FmtLin ({If (cLnCiapMg=="2", Transform ((cAliasSF9)->F9_CODIGO, "@R 9999/99"), (cAliasSF9)->F9_CODIGO),;
				dData,;
				If (Empty ((cAliasSF9)->F9_DOCNFS), (cAliasSF9)->F9_DOCNFE, (cAliasSF9)->F9_DOCNFS),;
				(cAliasSF9)->F9_DESCRI,;
				((cAliasSF9)->F9_VALICMS/Iif((cAliasSF9)->(FieldPos("F9_VALUPF"))>0,(cAliasSF9)->F9_VALUPF,MV_PAR18)),;
				(nBaixa/Iif((cAliasSF9)->(FieldPos("F9_VALUPF"))>0,(cAliasSF9)->F9_VALUPF,MV_PAR18)),;
				((cAliasSF9)->F9_VALICMS/Iif((cAliasSF9)->(FieldPos("F9_VALUPF"))>0,(cAliasSF9)->F9_VALUPF,MV_PAR18))-(nBaixa/Iif((cAliasSF9)->(FieldPos("F9_VALUPF"))>0,(cAliasSF9)->F9_VALUPF,MV_PAR18))}, aLay[16],,, @nLin)
/*
			Elseif (AllTrim (cUF)=="GO")    //UF-GO
				FmtLin ({If (cLnCiapMg=="2", Transform ((cAliasSF9)->F9_CODIGO, "@R 9999/99"), (cAliasSF9)->F9_CODIGO),;
				dData,;
				(cAliasSF9)->F9_DOCNFE,;
				(cAliasSF9)->F9_DESCRI,;
				Iif (MV_PAR06>0, ((cAliasSF9)->F9_VALICMS/MV_PAR06), (cAliasSF9)->F9_VALICMS),;
				TransForm(0,"@e 99,999,999.99"),;
				Iif (MV_PAR06>0, ((cAliasSF9)->F9_VALICMS/MV_PAR06), ((cAliasSF9)->F9_VALICMS))}, aLay[16],,, @nLin)
				
				If (!Empty ((cAliasSF9)->F9_DOCNFS)) .And. (dDataNFS <= (MV_PAR05))
					FmtLin ({If (cLnCiapMg=="2", Transform ((cAliasSF9)->F9_CODIGO, "@R 9999/99"), (cAliasSF9)->F9_CODIGO),;
					(cAliasSF9)->F9_DTEMINS,;
					(cAliasSF9)->F9_DOCNFS,;
					(cAliasSF9)->F9_DESCRI,;
					TransForm(0,"@e 99,999,999.99"),;
					Iif (MV_PAR06>0, (nBaixa/MV_PAR06), nBaixa),;
					TransForm(0,"@e 99,999,999.99")}, aLay[16],,, @nLin)
				Endif
*/
			Else				
				FmtLin ({If (cLnCiapMg=="2", Transform ((cAliasSF9)->F9_CODIGO, "@R 9999/99"), (cAliasSF9)->F9_CODIGO),;
				dData,;
				If (Empty ((cAliasSF9)->F9_DOCNFS), (cAliasSF9)->F9_DOCNFE, (cAliasSF9)->F9_DOCNFS),;
				(cAliasSF9)->F9_DESCRI,;
				Iif (MV_PAR06>0, ((cAliasSF9)->F9_VALICMS/MV_PAR06), (cAliasSF9)->F9_VALICMS),;
				Iif (MV_PAR06>0, (nBaixa/MV_PAR06), nBaixa),;
				Iif (MV_PAR06>0, ((cAliasSF9)->F9_VALICMS/MV_PAR06)-(nBaixa/MV_PAR06), ((cAliasSF9)->F9_VALICMS-nBaixa))}, aLay[16],,, @nLin)
			Endif
			//
			lQuadro2 :=.T.
		Endif
		//
		DbSelectArea (cAliasSF9)
			DbSkip ()
			IncRegua ()
	EndDo
	//
	If (lQuadro2)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Impressao do Demonstrativo da Apropriacao Mensal de Credito (R$)        ³
		// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (MV_PAR07==1)
			If (nLin>40)
				FmtLin (, aLay[18],,, @nLin)
				nLin := 0
				@nLin, 000 PSAY aValImp (Limite)
				nLin++			
				FmtLin (, aLay[30],,, @nLin)
				FmtLin (, aLay[31],,, @nLin)
				FmtLin (, aLay[32],,, @nLin)
				FmtLin ({StrZero (Year (MV_PAR04), 4), StrZero (nFolha, 4)}, aLay[33],,,@nLin)
				nFolha ++
				FmtLin (, aLay[01],,, @nLin)
				FmtLin (, aLay[02],,, @nLin)
				FmtLin (, aLay[03],,, @nLin)
				FmtLin ({SM0->M0_NOMECOM, Transform (SM0->M0_CGC, "@R 99.999.999/9999-99"), SM0->M0_INSC}, aLay[04],,, @nLin)
				FmtLin ({SM0->M0_ENDENT, SM0->M0_BAIRENT, SM0->M0_CIDENT}, aLay[05],,, @nLin)
				FmtLin (, aLay[06],,, @nLin)
			Else
				FmtLin (, aLay[18],,, @nLin)
			EndIf
			FmtLin (, aLay[19],,, @nLin)
			FmtLin (, aLay[20],,, @nLin)
			FmtLin (, aLay[21],,, @nLin)
			FmtLin (, aLay[22],,, @nLin)
			FmtLin (, aLay[23],,, @nLin)
			FmtLin (, aLay[24],,, @nLin)
			FmtLin (, aLay[25],,, @nLin)
			FmtLin (, aLay[26],,, @nLin)
			FmtLin (, aLay[27],,, @nLin)
			FmtLin (, aLay[28],,, @nLin)
	      	//
			For nCntFor := 1 To 12
				If (nLin>60)
					FmtLin (, aLay[30],,, @nLin)
					nLin := 0
					@nLin, 000 PSAY aValImp (Limite)
					//
					nLin++			
					FmtLin (, aLay[30],,, @nLin)
					FmtLin (, aLay[31],,, @nLin)
					FmtLin (, aLay[32],,, @nLin)
					FmtLin ({StrZero(Year(MV_PAR04),4),StrZero(nFolha,4)},aLay[33],,,@nLin)
					nFolha++
					FmtLin (, aLay[01],,, @nLin)
					FmtLin (, aLay[02],,, @nLin)
					FmtLin (, aLay[03],,, @nLin)
					FmtLin ({SM0->M0_NOMECOM, Transform (SM0->M0_CGC, "@R 99.999.999/9999-99"), SM0->M0_INSC}, aLay[04],,, @nLin)
					FmtLin ({SM0->M0_ENDENT, SM0->M0_BAIRENT, SM0->M0_CIDENT}, aLay[05],,, @nLin)
					FmtLin (, aLay[06],,, @nLin)
					//
					FmtLin (, aLay[19],,, @nLin)
					FmtLin (, aLay[20],,, @nLin)
					FmtLin (, aLay[21],,, @nLin)
					FmtLin (, aLay[22],,, @nLin)
					FmtLin (, aLay[23],,, @nLin)
					FmtLin (, aLay[24],,, @nLin)
					FmtLin (, aLay[25],,, @nLin)
					FmtLin (, aLay[26],,, @nLin)
					FmtLin (, aLay[27],,, @nLin)
					FmtLin (, aLay[28],,, @nLin)
				EndIf
				FmtLin ({ aResumo[nCntFor, 1],;                                      		// Mes
					aResumo[nCntFor, 2],;                                            		// Saidas e Prestacoes Tributadas
					aResumo[nCntFor, 3],;                                            		// Total das Saidas e Prestacoes
					Transform (aResumo[nCntFor, 4], Tm (aResumo[nCntFor, 4], 8, 4)),;   	// Coeficiente de Apropriacao
					aResumo[nCntFor, 5]*Iif(lUPF .And. (cAliasSF9)->(FieldPos("F9_VALUPF"))>0,MV_PAR18,1),; 	// Total de Credito a Apropriar
					"1/48",;                                                   				// Fracao Mensal
					Iif (aResumo[nCntFor, 4]==0 .Or. aResumo[nCntFor, 5]==0, 0, aResumo[nCntFor, 7]*Iif(lUPF .And. (cAliasSF9)->(FieldPos("F9_VALUPF"))>0,MV_PAR18,1)),;  // Credito Mensal a Apropriar
					}, aLay[29],,, @nLin)
			Next nCntFor
			//
			If !(nLin>60)
				FmtLin (, aLay[30],,, @nLin)
			EndIf
		Else
			If (nLin>40)
				FmtLin (, aLay[17],,, @nLin)
				nLin	:=	0
				@nLin, 000 PSAY aValImp (Limite)
				nLin++			
				FmtLin (, aLay[30],,, @nLin)
				FmtLin (, aLay[31],,, @nLin)
				FmtLin (, aLay[32],,, @nLin)
				FmtLin ({StrZero (Year (MV_PAR04), 4), StrZero (nFolha, 4)}, aLay[33],,, @nLin)
				nFolha++
				FmtLin (, aLay[01],,, @nLin)
				FmtLin (, aLay[02],,, @nLin)
				FmtLin (, aLay[03],,, @nLin)
				FmtLin ({SM0->M0_NOMECOM, Transform (SM0->M0_CGC, "@R 99.999.999/9999-99"), SM0->M0_INSC}, aLay[04],,, @nLin)
				FmtLin ({SM0->M0_ENDENT, SM0->M0_BAIRENT, SM0->M0_CIDENT}, aLay[05],,, @nLin)
				FmtLin (, aLay[06],,, @nLin)
				FmtLin (, aLay[07],,, @nLin)
				FmtLin (, aLay[08],,, @nLin)
				FmtLin (, aLay[09],,, @nLin)
				FmtLin (, aLay[10],,, @nLin)
				FmtLin (, aLay[11],,, @nLin)
				FmtLin (, aLay[12],,, @nLin)
				FmtLin (, aLay[13],,, @nLin)
				FmtLin (, aLay[14],,, @nLin)
				FmtLin (, aLay[15],,, @nLin)
				FmtLin (, aLay[16],,, @nLin)
			Else
				FmtLin (, aLay[17],,, @nLin)
			EndIf
			FmtLin (, aLay[18],,, @nLin)
			FmtLin (, aLay[19],,, @nLin)
			FmtLin (, aLay[20],,, @nLin)
			FmtLin (, aLay[21],,, @nLin)
			FmtLin (, aLay[22],,, @nLin)
			FmtLin (, aLay[23],,, @nLin)
			FmtLin (, aLay[24],,, @nLin)
			FmtLin (, aLay[25],,, @nLin)
			FmtLin (, aLay[26],,, @nLin)
			FmtLin (, aLay[27],,, @nLin)
	
			For nCntFor := 1 To 12
				If (nLin>60)
					FmtLin (, aLay[29],,, @nLin)
					nLin	:=	0
					@nLin, 000 PSAY aValImp (Limite)
					FmtLin (, aLay[18],,, @nLin)
					FmtLin (, aLay[19],,, @nLin)
					FmtLin (, aLay[20],,, @nLin)
					FmtLin (, aLay[21],,, @nLin)
					FmtLin (, aLay[22],,, @nLin)
					FmtLin (, aLay[23],,, @nLin)
					FmtLin (, aLay[24],,, @nLin)
					FmtLin (, aLay[25],,, @nLin)
					FmtLin (, aLay[26],,, @nLin)
					FmtLin (, aLay[27],,, @nLin)
				EndIf
				//
				FmtLin ({aResumo[nCntFor, 1],;                                       		// Mes
					aResumo[nCntFor, 2],;                                            		// Saidas e Prestacoes Tributadas
					aResumo[nCntFor, 3],;                                            		// Total das Saidas e Prestacoes
					Transform (aResumo[nCntFor, 4], Tm (aResumo[nCntFor, 4], 8, 4)),;   	// Coeficiente de Apropriacao
					aResumo[nCntFor, 5]*Iif(lUPF .And. (cAliasSF9)->(FieldPos("F9_VALUPF"))>0,MV_PAR18,1),; 							                        // Total de Credito a Apropriar
					"1/48",;                                                   				// Fracao Mensal
					Iif (aResumo[nCntFor, 4]==0 .Or. aResumo[nCntFor, 5]==0, 0, aResumo[nCntFor, 7]*Iif(lUPF .And. (cAliasSF9)->(FieldPos("F9_VALUPF"))>0,MV_PAR18,1)),;													//aResumo[nCntFor,7]*aResumo[nCntFor,4],;                         	// Credito Mensal a Apropriar
					}, aLay[28],,, @nLin)
			Next (nCntFor)
			//
			If !(nLin>60)
				FmtLin (, aLay[29],,, @nLin)
			EndIf
		Endif
	Endif
	//
	#IFDEF TOP
		DbSelectArea (cAliasSF9)
		DbCloseArea ()
	#ELSE
		RetIndex ("SF9")
		Ferase (cIndSF9+OrdBagExt ())
	#ENDIF
	//
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R995LivroD()³ Autor ³ Eduardo Riera      ³ Data ³10/06/98  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Livro D                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR995()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R995LivroD(lEnd,wnRel,cString,Tamanho)

Local aEstMes   := Array(48,3)
Local aLay      := IF(MV_PAR06>0,Array(79),Array(82))
Local aLin      := Array(06)
Local aStruSF9  := {}
Local aStruSFA  := {}
Local nLin      := 0
Local nTotal1   := 0
Local nTotal2   := 0
Local nMes      := 0
Local nAno      := 0
Local nCntFor   := 0
Local nLinha    := 1
Local dLei102   := GetNewPar("MV_DATCIAP",ctod("01/01/2001"))
Local cTipEven  := ""
Local dDatEven  := ""
Local cMesAno   := ""
Local cAliasSF9 := "SF9"
Local cAliasSFA := "SFA"
Local cIndSF9	:= ""
Local cChave	:= ""
Local cFilSF9	:= ""
Local nIndex	:= 0

R995LayOut(@aLay)

dbSelectArea("SF9")
dbSetOrder(1)
#IFDEF TOP
	cAliasSF9 := "R995Livro1"
	aStruSF9  := SF9->(dbStruct())
	cQuery    := "SELECT * "
	cQuery    += "FROM "+RetSqlName("SF9")+" SF9 "
	cQuery    += "WHERE SF9.F9_FILIAL='"+xFilial("SF9")+"' AND "
	cQuery    += "SF9.F9_CODIGO >= '"+MV_PAR01+"' AND "
	cQuery    += "SF9.F9_CODIGO <= '"+MV_PAR02+"' AND "
	If !Empty(mv_par08)
		cQuery    += "SF9.F9_DTENTNE > '"+Dtos(dLei102)+"' AND "
		cQuery    += "SF9.F9_DTENTNE >= '"+Dtos(Mv_Par08)+"' AND "
		cQuery    += "SF9.F9_DTENTNE <= '"+Dtos(Mv_Par09)+"' AND "
	Endif
	cQuery    += "SF9.D_E_L_E_T_=' ' "
	cQuery    += "ORDER BY "+SqlOrder(SF9->(IndexKey()))

	cQuery    := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF9,.T.,.T.)

	For nX := 1 To Len(aStruSF9)
		If ( aStruSF9[nX][2] <> "C" )
			TcSetField(cAliasSF9,aStruSF9[nX][1],aStruSF9[nX][2],aStruSF9[nX][3],aStruSF9[nX][4])
		EndIf
	Next nX
#ELSE
	cAliasSF9 := "SF9"
	cIndSF9	  := CriaTrab(NIL,.F.)
	cChave	  := IndexKey()
	cFilSF9	  := "F9_FILIAL=='"+xFilial("SF9")+"' .And. F9_CODIGO>='"+Mv_Par01+"' .And. F9_CODIGO<='"+Mv_Par02+"'"	
	If !Empty(mv_par08)
		cFilSF9   += " .And. Dtos(F9_DTENTNE)>='"+Dtos(Mv_Par08)+"' .And. Dtos(F9_DTENTNE)<='"+Dtos(Mv_Par09)+"'"	
		cFilSF9   += " .And. Dtos(F9_DTENTNE)>'"+Dtos(dLei102)+"'"	
	Endif

	IndRegua(cAliasSF9,cIndSF9,cChave,,cFilSF9)
	nIndex := RetIndex("SF9")
	dbSelectArea("SF9")
	dbSetIndex(cIndSF9+OrdBagExt())
	dbSetOrder(nIndex+1)
	(cAliasSF9)->(dbGoTop())
#ENDIF

SetRegua(LastRec())
While !Eof()

	If !Empty(cFiltro).And. ! (cAliasSF9)->((&(cFiltro)))
		(cAliasSF9)->(DbSkip())
		Loop
	Endif

	nLin      := 0
	nTotal1   := 0
	nTotal2   := 0
	cTipEven  := ""
	dDatEven  := ""

	If Interrupcao(@lEnd)
		Exit
	Endif

	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+(cAliasSF9)->F9_FORNECE+(cAliasSF9)->F9_LOJAFOR)

	@ nLin,000 PSAY aValImp(Limite)
	nLin++
	IF MV_PAR06>0
		FmtLin(,aLay[01],,,@nLin)
		FmtLin(,aLay[02],,,@nLin)
		FmtLin(,aLay[03],,,@nLin)
		FmtLin({(cAliasSF9)->F9_CODIGO},aLay[04],"@er 999999",,@nLin)
		FmtLin(,aLay[05],,,@nLin)
		FmtLin(,aLay[06],,,@nLin)
		FmtLin(,aLay[07],,,@nLin)
		FmtLin({SM0->M0_NOMECOM,SM0->M0_INSC,SM0->M0_CGC},aLay[08],,,@nLin)
		FmtLin({SM0->M0_ENDENT,SM0->M0_BAIRENT,SM0->M0_CIDENT},aLay[09],,,@nLin)
		FmtLin(,aLay[10],,,@nLin)
		FmtLin(,aLay[11],,,@nLin)
		FmtLin(,aLay[12],,,@nLin)
		FmtLin({(cAliasSF9)->F9_DESCRI},aLay[13],,,@nLin)
		FmtLin({SA2->A2_NOME,(cAliasSF9)->F9_DOCNFE},aLay[14],,,@nLin)
		FmtLin(,aLay[15],,,@nLin)
		FmtLin({ Transform((cAliasSF9)->F9_NLRE,"@er9999"),;
			TransForm((cAliasSF9)->F9_FLRE,"@er9999"),;
			Dtoc((cAliasSF9)->F9_DTENTNE),;
			TransForm((cAliasSF9)->F9_VALICMS/mv_par06,"@er 999,999,999.99")},aLay[16],,,@nLin)
		FmtLin(,aLay[17],,,@nLin)
		FmtLin(,aLay[18],,,@nLin)
		FmtLin(,aLay[19],,,@nLin)

		SF3->(dbsetorder(5))
		SF3->(dbseek(xFilial("SF9")+(cAliasSF9)->F9_SERNFS+(cAliasSF9)->F9_DOCNFS))
		FmtLin({ (cAliasSF9)->F9_DOCNFS,AModNot(SF3->F3_ESPECIE),(cAliasSF9)->F9_DTEMINS},aLay[20],,,@nLin)
		FmtLin(,aLay[21],,,@nLin)
		FmtLin(,aLay[22],,,@nLin)
		FmtLin(,aLay[23],,,@nLin)
		FmtLin(,aLay[24],,,@nLin)
		FmtLin(,aLay[25],,,@nLin)
		FmtLin(,aLay[26],,,@nLin)
		FmtLin(,aLay[27],,,@nLin)
	ELSE
		FmtLin(,aLay[01],,,@nLin)
		FmtLin(,aLay[02],,,@nLin)
		FmtLin(,aLay[03],,,@nLin)
		FmtLin({(cAliasSF9)->F9_CODIGO},aLay[04],"@er 999999",,@nLin)
		FmtLin(,aLay[05],,,@nLin)
		FmtLin(,aLay[06],,,@nLin)
		FmtLin(,aLay[07],,,@nLin)
		FmtLin({SM0->M0_NOMECOM,SM0->M0_INSC,SM0->M0_CGC},aLay[08],,,@nLin)
		FmtLin({(cAliasSF9)->F9_DESCRI},aLay[09],,,@nLin)
		FmtLin(,aLay[10],,,@nLin)
		FmtLin(,aLay[11],,,@nLin)
		FmtLin(,aLay[12],,,@nLin)
		FmtLin({SA2->A2_NOME,(cAliasSF9)->F9_DOCNFE},aLay[13],,,@nLin)
		FmtLin(,aLay[14],,,@nLin)	
		FmtLin({ Transform((cAliasSF9)->F9_NLRE,"@er9999"),;
			TransForm((cAliasSF9)->F9_FLRE,"@er9999"),;
			Dtoc((cAliasSF9)->F9_DTENTNE),;
			TransForm((cAliasSF9)->F9_VALICMS,"@er 999,999,999.99")},aLay[15],,,@nLin)
		FmtLin(,aLay[16],,,@nLin)
		FmtLin(,aLay[17],,,@nLin)
		FmtLin(,aLay[18],,,@nLin)
		SF3->(dbsetorder(5))
		SF3->(dbseek(xFilial("SF9")+(cAliasSF9)->F9_SERNFS+(cAliasSF9)->F9_DOCNFS))
		FmtLin({ (cAliasSF9)->F9_DOCNFS,AModNot(SF3->F3_ESPECIE),(cAliasSF9)->F9_DTEMINS},aLay[19],,,@nLin)
		FmtLin(,aLay[20],,,@nLin)
		FmtLin(,aLay[21],,,@nLin)
		FmtLin(,aLay[22],,,@nLin)
		SFA->(dbseek(xFilial("SF9")+(cAliasSF9)->F9_CODIGO))
		While !SFA->(EOF()) .AND. xFilial("SF9")+(cAliasSF9)->F9_CODIGO=xFilial("SFA")+SFA->FA_CODIGO
			IF SFA->(Fieldpos("FA_MOTIVO"))<>0
				IF SFA->FA_MOTIVO<>" "
					cTipEven  :=""
					If SFA->FA_MOTIVO="1"
					   cTipEven  :="Perda"
					ElseIf SFA->FA_MOTIVO="2"
					   cTipEven  :="Venda"
					ElseIf SFA->FA_MOTIVO="3"
						cTipEven  :="Transferencia"
                    Endif
					dDatEven  :=SFA->FA_DATA
				ENDIF
			ENDIF
			SFA->(DBSKIP())
		Enddo
		FmtLin({cTipEven,dDatEven},aLay[23],,,@nLin)
		FmtLin(,aLay[24],,,@nLin)
		FmtLin(,aLay[25],,,@nLin)
		FmtLin(,aLay[26],,,@nLin)
		FmtLin(,aLay[27],,,@nLin)
		FmtLin(,aLay[28],,,@nLin)
		FmtLin(,aLay[29],,,@nLin)
		FmtLin(,aLay[30],,,@nLin)
	ENDIF
	For nCntFor := 1 To Len(aEstMes)
		aEstMes[nCntFor,1] := ""
		aEstMes[nCntFor,2] := 0
		aEstMes[nCntFor,3] := 0
	Next

	dbSelectArea("SFA")
	dbSetOrder(1)
	#IFDEF TOP
		cAliasSFA := "R995Livro2"
		aStruSFA  := SFA->(dbStruct())
		cQuery    := "SELECT * "
		cQuery    += "FROM "+RetSqlName("SFA")+" SFA "
		cQuery    += "WHERE SFA.FA_FILIAL='"+xFilial("SFA")+"' AND "
		cQuery    += "SFA.FA_CODIGO = '"+(cAliasSF9)->F9_CODIGO+"' AND "
		cQuery    += "SFA.FA_CREDIT <> '2' AND "
		cQuery    += "SFA.D_E_L_E_T_=' ' "
		cQuery    += "ORDER BY "+SqlOrder(SFA->(IndexKey()))

		cQuery    := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSFA,.T.,.T.)		
		For nX := 1 To Len(aStruSFA)
			If ( aStruSFA[nX][2] <> "C" )
				TcSetField(cAliasSFA,aStruSFA[nX][1],aStruSFA[nX][2],aStruSFA[nX][3],aStruSFA[nX][4])
			EndIf
		Next nX	
	#ELSE
		cAliasSFA := "SFA"
		dbSeek(xFilial("SFA")+(cAliasSF9)->F9_CODIGO)
	#ENDIF

	While ( !Eof() .And. xFilial("SFA") == (cAliasSFA)->FA_FILIAL .And. ;
			(cAliasSFA)->FA_CODIGO == (cAliasSF9)->F9_CODIGO )

		If ! (DToS ((cAliasSFA)->FA_DATA)>=StrZero (Year (MV_PAR04), 4)+"0101" .And.;
				DToS ((cAliasSFA)->FA_DATA)<=StrZero (Year (MV_PAR05), 4)+"1231")
			DbSkip ()
			loop
		EndIf
				
		if Fieldpos("FA_CREDIT")<>0
			if (cAliasSFA)->FA_CREDIT == "2"
				(cAliasSFA)->(dbSkip())
				loop
			EndIF
		EndIf

		nAno    :=YEAR((cAliasSFA)->FA_DATA)
		nMes    :=MONTH((cAliasSFA)->FA_DATA)
		cMesAno :=STRZERO(nMes,2)+"/"+STRZERO(nAno,4)
		If ( (cAliasSFA)->FA_TIPO == "1" )
			aEstMes[nLinha,1] := cMesAno
			aEstMes[nLinha,2] := (cAliasSFA)->FA_FATOR
			aEstMes[nLinha,3] := (cAliasSFA)->FA_VALOR
		EndIf          		
		dbSelectArea(cAliasSFA)
		nLinha :=nLinha+1
		dbSkip()
	EndDo
	nLinha :=1
	#IFDEF TOP
		dbSelectArea(cAliasSFA)
		dbCloseArea()
	#ENDIF	

	For nCntFor := 1 To 12
		aLin[1] := aEstMes[nCntFor,1]
		aLin[2] := TransForm(aEstMes[nCntFor,2],PesqPict("SFA","FA_FATOR"))
		aLin[3] := TransForm(aEstMes[nCntFor,3],"@er 99,999,999.99")
		If (nCntFor+12)<=Len(aEstMes)
			aLin[4] := aEstMes[nCntFor+12,1]
			aLin[5] := TransForm(aEstMes[nCntFor+12,2],PesqPict("SFA","FA_FATOR"))
			aLin[6] := TransForm(aEstMes[nCntFor+12,3],"@er 99,999,999.99")
		Endif
		IF MV_PAR06>0
			FmtLin(@aLin,aLay[26+nCntFor*2],,,@nLin)
			FmtLin(,aLay[27+nCntFor*2],,,@nLin)
		ELSE
			FmtLin(@aLin,aLay[29+nCntFor*2],,,@nLin)
			FmtLin(,aLay[30+nCntFor*2],,,@nLin)
		ENDIF
	Next nCntFor

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quebra a pagina para poder imprimir os quadros do 3o. e 4o. ANO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nLin := 0
	@ nLin,000 PSAY aValImp(Limite)
	IF MV_PAR06>0
		FmtLin(,aLay[21],,,@nLin)
		FmtLin(,aLay[22],,,@nLin)
		FmtLin(,aLay[23],,,@nLin)
		FmtLin(,aLay[52],,,@nLin)
		FmtLin(,aLay[53],,,@nLin)
		FmtLin(,aLay[54],,,@nLin)
		FmtLin(,aLay[55],,,@nLin)	
	ELSE
		FmtLin(,aLay[24],,,@nLin)
		FmtLin(,aLay[25],,,@nLin)
		FmtLin(,aLay[26],,,@nLin)
		FmtLin(,aLay[55],,,@nLin)
		FmtLin(,aLay[56],,,@nLin)
		FmtLin(,aLay[57],,,@nLin)	
		FmtLin(,aLay[58],,,@nLin)	
	ENDIF

	For nCntFor := 25 To 36
		aLin[1] := aEstMes[nCntFor,1]
		aLin[2] := TransForm(aEstMes[nCntFor,2],PesqPict("SFA","FA_FATOR"))
		aLin[3] := TransForm(aEstMes[nCntFor,3],"@er 99,999,999.99")
		If (nCntFor+12)<=Len(aEstMes)
			aLin[4] := aEstMes[nCntFor+12,1]
			aLin[5] := TransForm(aEstMes[nCntFor+12,2],PesqPict("SFA","FA_FATOR"))
			aLin[6] := TransForm(aEstMes[nCntFor+12,3],"@er 99,999,999.99")
		Endif
		IF MV_PAR06>0
			FmtLin(@aLin,aLay[06+nCntFor*2],,,@nLin)
			FmtLin(,aLay[07+nCntFor*2],,,@nLin)
		ELSE
			FmtLin(@aLin,aLay[09+nCntFor*2],,,@nLin)
			FmtLin(,aLay[10+nCntFor*2],,,@nLin)
		ENDIF
	Next nCntFor
	dbSelectArea(cAliasSF9)
	dbSkip()
	IncRegua()
EndDo
#IFDEF TOP
	dbSelectArea(cAliasSF9)
	dbCloseArea()
#ELSE
	RetIndex("SF9")
	Ferase(cIndSF9+OrdBagExt())
#ENDIF
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R995LayOut()³ Autor ³ Eduardo Reira        ³ Data ³10/06/98³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Lay-Out do Relatorio Modelo A,B,C ou D                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR995                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R995LayOut(aLay, cEstado)
Default cEstado	:=	""
//
If MV_PAR03 = 1 //Modelo A
	If ("RJ"$AllTrim (cEstado))
		aLay[01] :=	STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[02] :=	STR0023 //"|                                      CONTROLE DE CREDITO DE ICMS DO ATIVO PERMANENTE - CIAP                                      |"
		aLay[03] :=	STR0024 //"|                                                          MODELO A                                                                |"
		aLay[04] :=	STR0077 //"| PARTE 1o - INVENTARIO DE BENS DO ATIVO PERMANENTE                                                    ANO: ####        No. ###### |"
		aLay[05] :=	STR0076	//"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[06] :=	STR0076	//"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[07] :=	STR0026 //"| 1 - IDENTIFICACAO DO CONTRIBUINTE                                                                                                |"
		aLay[08] :=	STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[09] :=	STR0078	//"|Nome: ######################################## C.N.P.J. No: ##################    Inscricao Estadual No: ######################## |"
		aLay[10] :=	STR0079	//"|Endereco: #################################### Bairro: #######################    Municipio: #################################### |"
		aLay[11] :=	STR0076	//"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[12] :=	STR0076	//"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[13] :=	STR0080	//"| 2 - IDENTIFICACAO DO BEM                                                                                                         |"
		aLay[14] :=	STR0081	//"+----------+--------------+--------------+--------------------------------------+--------------+--------------------+--------------+"
		aLay[15] :=	STR0082	//"|  CODIGO  |     DATA     |   NOTA       |  DESCRICAO RESUMIDA                  |    RE/FLS    |   ICMS DESTACADO   |  DATA SAIDA  |"
		aLay[16] :=	STR0083	//"|          |    ENTRADA   |  FISCAL      |                                      |              | NA NOTA FISCAL (1) |  OU BAIXA    |"
		aLay[17] :=	STR0081	//"+----------+--------------+--------------+--------------------------------------+--------------+--------------------+--------------+"
		aLay[18] :=	STR0084	//"|  ######  |  ##########  |  ##########  |  ##################################  |    #######   |  ################  |  ##########  |"
		aLay[19] :=	STR0081 //"+----------+--------------+--------------+--------------------------------------+--------------+--------------------+--------------+"
		aLay[20] :=	STR0076	//"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[21] :=	STR0023 //"|                                      CONTROLE DE CREDITO DE ICMS DO ATIVO PERMANENTE - CIAP                                      |"
		aLay[22] :=	STR0024 //"|                                                          MODELO A                                                                |"
		aLay[23] :=	STR0085	//"| PARTE 2o - DEMONSTRATIVO DE APROPRIACAO DE CREDITO                                            MES/ANO: #######        No. ###### |"
		aLay[24] :=	STR0076	//"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[25] :=	STR0076	//"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[26] :=	STR0026 //"| 1 - IDENTIFICACAO DO CONTRIBUINTE                                                                                                |"
		aLay[27] :=	STR0076	//"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[28] :=	STR0078	//"|Nome: ######################################## C.N.P.J. No: ##################    Inscricao Estadual No: ######################## |"
		aLay[29] :=	STR0079	//"|Endereco: #################################### Bairro: #######################    Municipio: #################################### |"
		aLay[30] :=	STR0076	//"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[31] :=	STR0076	//"+---------------------------------------------------------------------------------------------------------+------------------------+"
		aLay[32] :=	STR0086	//"|                                             BENS                                           |    PARCELA   |   BASE PARA CALCULO  |"
		aLay[33] :=	STR0087	//"|                                                                                            |              |    DO ICMS (1)/48    |"
		aLay[34] :=	STR0088	//"+--------------------------------------------------------------------------------------------+--------------+----------------------+"
		aLay[35] :=	STR0089	//"|  ######################################################################################### |  ##########  |  ##################  |"
		aLay[36] :=	STR0088	//"+--------------------------------------------------------------------------------------------+--------------+----------------------+"
		aLay[37] :=	STR0090	//"|                                                                              Total da Base de Calculo: (2)|  ##################  |"
		aLay[38] :=	STR0091	//"|                                                                                     Saidas Tributadas: (3)|  ##################  |"
		aLay[39] :=	STR0092	//"|                                                                                      Total das Saidas: (4)|  ##################  |"
		aLay[40] :=	STR0093	//"|                                                                                   Coeficiente: (5)=(3)/(4)|  ##################  |"
		aLay[41] :=	STR0094	//"|                                                                              Valor do Credito: (6)=(2)*(5)|  ##################  |"
		aLay[42] :=	STR0095	//"+-----------------------------------------------------------------------------------------------------------+----------------------+"
	Else
        aLay[30] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[31] :=STR0023 //"|                                      CONTROLE DE CREDITO DE ICMS DO ATIVO PERMANENTE - CIAP                                      |"
		aLay[32] :=STR0024 //"|                                                          MODELO A                                                                |"
		aLay[33] :=STR0025 //"| ANO: ####                                                                                                            No. ######  |"
		aLay[01] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[02] :=STR0026 //"| 1 - IDENTIFICACAO DO CONTRIBUINTE                                                                                                |"
		aLay[03] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[04] :=STR0027 //"|Nome: ######################################## C.N.P.J. No: ##################    Inscricao Estadual No: ######################## |"
		aLay[05] :=STR0028 //"|Endereco: ####################################   Bairro: #####################    Municipio: #################################### |"
		aLay[06] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[07] :=""
		aLay[08] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[09] :=STR0029 //"| 2 - DEMONSTRATIVO DA BASE DE ESTORNO DE CREDITO                                                                                  |"
		aLay[10] :=          "+-------------------------------------------------------------+--------------------------------------------------------------------+"
		aLay[11] :=STR0030 //"|         IDENTIFICACAO DO BEM ESTORNO DE CREDITO             |                                   VALOR DO ICMS                    |"
		aLay[12] :=          "+---------+----------+---------+------------------------------+------------------------+----------------------+--------------------+"
		aLay[13] :=STR0031 //"| No ou   |          |   Nota  |                              |         Entrada        |        Saida ou      |  Saldo Acumulado   |"
		aLay[14] :=STR0032 //"| Codigo  |   Data   |  Fiscal |      Descricao Resumida      |        (Credito)       |         Baixa        |  (Base do Estorno) |"
		aLay[15] :=          "+---------+----------+---------+------------------------------+------------------------+----------------------+--------------------+"
		aLay[16] :=          "| ######  | ######## | ####### | ###########################  | ###################### |   ################## | ################## |"
		aLay[17] :=          "+---------+----------+---------+------------------------------+------------------------+----------------------+--------------------+"
		aLay[18] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[19] :=STR0033 //"| 3 - DEMONSTRATIVO DO ESTORNO DE CREDITO                                                                                          |"
		aLay[20] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[21] :=STR0034 //"|         IDENTIFICACAO DO BEM ESTORNO DE CREDITO                                                                                  |"
		aLay[22] :=          "+----------+-----------------------------+--------------+-----------------+--------+---------------+---------------+---------------+"
		aLay[23] :=STR0035 //"|          |    OPERACOES E PRESTACOES   |              |                 |        |EST. POR SAIDAS|  ESTORNO POR  |   TOTAL DO    |"
		aLay[24] :=STR0036 //"|          +--------------+--------------+ COEFICIENTE  | SALDO ACUMULADO | FRACAO |  ISENTAS  OU  | SAIDAS/PERDAS | ESTORNO MENSAL|"
		aLay[25] :=STR0037 //"|    MES   |ISENTAS OU NAO|  TOTAL DAS   |  DE ESTORNO  |(BASE DO ESTORNO)| MENSAL | NAO TRIBUTADAS|    ( 7 )      | ( 8 = 6 + 7 ) |"
		aLay[26] :=STR0038 //"|          | TRIBUTADA (1)|  SAIDAS (2)  | (3 = 1 / 2)  |     ( 4 )       |   (5)  |(6 = 3 X 4 X 5)|               |               |"
		aLay[27] :=          "+----------+--------------+--------------+--------------+-----------------+--------+---------------+---------------+---------------+"
        aLay[28] :=          "| ######## |##############|##############|##############| ############### |  ####  |###############|###############|###############|"
		aLay[29] :=          "+----------+--------------+--------------+--------------+-----------------+--------+---------------+---------------+---------------+"
	EndIf
ELSEIF MV_PAR03 = 2 
    aLay[01] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[02] :=STR0007 //"|Controle de Credito de ICMS do Ativo                                                                                  N.de Ordem  |"
	aLay[03] :=STR0008 //"|Permanente - CIAP Modelo B                                                                                                ######  |"
	aLay[04] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[05] :=STR0009 //"|                                                         1 - Identificacao                                                        |"
	aLay[06] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[07] :=STR0010 //"| Contribuinte: ########################################                      Inscricao: ######################################### |"
	aLay[08] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[09] :=STR0011 //"| Bem: ########################################################################################################################### |"
	aLay[10] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[11] :=STR0012 //"|                                                             2 - Entradas                                                         |"
	aLay[12] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[13] :=STR0013 //"| Fornecedor: ##########################################                    Nota Fiscal: ######################################### |"
	aLay[14] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[15] :=STR0014 //"| N.do LRE: #####      Folha do LRE: #####          Data de Entrada: ##########          Valor do Credito: ####################### |"
	aLay[16] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[17] :=STR0015 //"|                                                               3 - Saida                                                          |"
	aLay[18] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[19] :=STR0016 //"| N. da Nota Fiscal: ##########                          Modelo: ################                   Data de Saida: ##############  |"
	aLay[20] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[21] :=STR0017 //"|                                                           4 - Estorno Mensal                                                     |"
	aLay[22] :=STR0018 //"| 1. Ano                    2. Ano                     3. Ano                     4. Ano                    5. Ano                 |"
	aLay[23] :=STR0019 //"|Mes    Fator         Valor Mes    Fator         Valor Mes    Fator         Valor Mes    Fator        Valor Mes   Fator       Valor|"
	aLay[24] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[25] :=          "| 01 #######% #############  01 #######% #############  01 #######% #############  01 #######% ############ 01 #######% ###########|"
	aLay[26] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[27] :=          "| 02 #######% #############  02 #######% #############  02 #######% #############  02 #######% ############ 02 #######% ###########|"
	aLay[28] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[29] :=          "| 03 #######% #############  03 #######% #############  03 #######% #############  03 #######% ############ 03 #######% ###########|"
	aLay[30] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[31] :=          "| 04 #######% #############  04 #######% #############  04 #######% #############  04 #######% ############ 04 #######% ###########|"
	aLay[32] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[33] :=          "| 05 #######% #############  05 #######% #############  05 #######% #############  05 #######% ############ 05 #######% ###########|"
	aLay[34] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[35] :=          "| 06 #######% #############  06 #######% #############  06 #######% #############  06 #######% ############ 06 #######% ###########|"
	aLay[36] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[37] :=          "| 07 #######% #############  07 #######% #############  07 #######% #############  07 #######% ############ 07 #######% ###########|"
	aLay[38] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[39] :=          "| 08 #######% #############  08 #######% #############  08 #######% #############  08 #######% ############ 08 #######% ###########|"
	aLay[40] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[41] :=          "| 09 #######% #############  09 #######% #############  09 #######% #############  09 #######% ############ 09 #######% ###########|"
	aLay[42] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[43] :=          "| 10 #######% #############  10 #######% #############  10 #######% #############  10 #######% ############ 10 #######% ###########|"
	aLay[44] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[45] :=          "| 11 #######% #############  11 #######% #############  11 #######% #############  11 #######% ############ 11 #######% ###########|"
	aLay[46] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[47] :=          "| 12 #######% #############  12 #######% #############  12 #######% #############  12 #######% ############ 12 #######% ###########|"
	aLay[48] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[49] :=STR0020 //"|                                                    5 - Estorno por Saida ou Perda                                                |"
	aLay[50] :=STR0021 //"|                                                       Ano            Fator             Valor                                     |"
	aLay[51] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[52] :=          "|                                                        1.         #######% #################                                     |"
	aLay[53] :=          "|                                                        2.         #######% #################                                     |"
	aLay[54] :=          "|                                                        3.         #######% #################                                     |"
	aLay[55] :=          "|                                                        4.         #######% #################                                     |"
	aLay[56] :=          "|                                                        5.         #######% #################                                     |"
	aLay[57] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
	aLay[58] :=STR0022 //"|                                                     Total         #######% #################                                     |"
	aLay[59] :=STR0076 //"+----------------------------------------------------------------------------------------------------------------------------------+"
ELSEIF MV_PAR03 = 3 //Modelo C
	If (AllTrim (cEstado)=="BA")
		aLay[01] 	:=	STR0039	//"+-------------------------------------------------------------------------------------------------------------------+--------------+"
		aLay[02] 	:=	STR0040	//"|                               CONTROLE DE CREDITO DE ICMS DO ATIVO PERMANENTE - CIAP                              |              |"
		aLay[03] 	:=	STR0041	//"|                                                     MODELO C                                                      |  No. ######  |"
		aLay[04] 	:=	STR0042	//"+-------------------------------------------------------------------------------------------------------------------+--------------+"
		aLay[05] 	:=	STR0043	//"1 - IDENTIFICACAO DO CONTRIBUINTE"
		aLay[06] 	:=	STR0044	//"+--------------------------------------------------------------------------------------+-------------------------------------------+"
		aLay[07] 	:=	STR0045	//"|Contribuinte: ########################################                                |Inscricao: ################################|"
		aLay[08] 	:=	STR0046	//"+--------------------------------------------------------------------------------------+-------------------------------------------+"
		aLay[09] 	:=	STR0047	//"|Bem: #############################################################################################################################|"
		aLay[10] 	:=	STR0048	//"+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[11] 	:=	STR0049	//"2 - ENTRADA"
		aLay[12] 	:=	STR0050	//"+----------------------------------------------------------------------------------------------------------+-----------------------+"
		aLay[13]	:=	STR0051	//"|Fornecedor: ########################################                                                      |  N. Nota: ######/###  |"
		aLay[14] 	:=	STR0052 //"+--------------------+------------------+------------------------+-----------------------------------------+-----------------------+"
		aLay[15] 	:=	STR0053	//"| N. LRE: ########## | Folha LRE: ##### | Data Entrada: ######## | Valor Credito R$ ################                               |"
		aLay[16] 	:=	STR0054	//"+--------------------+------------------+------------------------+-----------------------------------------------------------------+"
		aLay[17] 	:=	STR0055	//"3 - SAIDA"
		aLay[18] 	:=	STR0056	//"+-------------------------+--------------------+-----------------------------------------------------------------------------------+"
		aLay[19] 	:=	STR0057	//"| Nota Fiscal: ######/### | Modelo: ########## | Data Saida: ########                                                              |"
		aLay[20] 	:=	STR0058	//"+-------------------------+--------------------+-----------------------------------------------------------------------------------+"
		aLay[21]	:=	STR0059	//"4 - CONTROLE DE APROPRIACAO MENSAL DE CREDITO"
		aLay[22] 	:=	STR0060	//"+----------+-----------------------------+--------------+--------------+-----------------------+-----------------------------------+"
		aLay[23] 	:=	STR0061	//"|          |      Saidas/Prestacoes      | %Saida/Prest |   Credito    |  Quantidade de dias   |                Valor              |"
		aLay[24] 	:=	STR0062	//"+ Mes/Ano  +--------------+--------------+--------------+              +-----+-----------------+---------------+-------------------+"
		aLay[25] 	:=	STR0063	//"|          |   Totais     |  Tributadas  |  Tributadas  |   Possivel   | Mes |   Pro Rata Die  |  Credito/Mes  |    Saldo Credito  |"
		aLay[26] 	:=	STR0064	//"+----------+--------------+--------------+--------------+--------------+-----+-----------------+---------------+-------------------+"
		aLay[27]	:=	STR0065	//"| ###/#### | ############ | ############ | ############ | ############ | ### | ############### | ############# | ################# |"
		aLay[28] 	:=	STR0066	//"+----------+--------------+--------------+--------------+--------------+-----+-----------------+---------------+-------------------+"
		aLay[29]	:=	STR0067	//"5 - CANCELAMENTO DO SALDO"
		aLay[30]	:=	STR0068	//"+-----------+------------------+"
		aLay[31]	:=	STR0069	//"|    Ano    |      Valor       |
		aLay[32]	:=	STR0070	//"+-----------+------------------+"
		aLay[33]	:=	STR0071	//"+ ## - #### | ################ |"
		aLay[34]	:=	STR0072 //"+-----------+------------------+"
		aLay[35]	:=	STR0073 //"."
	Else
		If MV_PAR07==1
			aLay[30] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			aLay[31] :="|                                     CONTROLE DE CREDITO DE ICMS DO ATIVO PERMANENTE - CIAP                                       |"
			aLay[32] :="|                                                         MODELO C                                                                 |"
			aLay[33] :="| ANO: ####                                                                                                            No. ######  |"
			aLay[01] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			aLay[02] :="| 1 - IDENTIFICACAO DO CONTRIBUINTE                                                                                                |"
			aLay[03] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			aLay[04] :="|Nome: ######################################## C.N.P.J. No: ##################  Inscricao Estadual No. ###########################|"
			aLay[05] :="|Endereco: ####################################   Bairro: #####################  Municipio: #######################################|"
			aLay[06] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			aLay[07] :=""
			aLay[08] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			If Mv_Par18 > 0		//UPF - RS
				aLay[09] :="| 2 - DEMONSTRATIVO DA BASE PARA APROPRIACAO DE CREDITO (EM UPF-RS)                                                                |"
			Else			
				aLay[09] :="| 2 - DEMONSTRATIVO DA BASE DO CREDITO A SER APROPRIADO                                                                            |"
			Endif
			aLay[10] :="+-----------------------------------------------------------------------+----------------------------------------------------------+"
			aLay[11] :="|                   IDENTIFICACAO DO BEM                                |                         VALOR DO ICMS                    |"
			aLay[12] :="+---------+----------+---------+----------------------------------------+--------------------+------------------+------------------+"
			aLay[13] :="| No ou   |          |   Nota  |                                        |       Entrada      |  Saida,Baixa ou  | Saldo  Acumulado |"
			aLay[14] :="| Codigo  |   Data   |  Fiscal |             Descricao Resumida         | ( Credito Passivel |      Perda       |Base do Credito a |"
			aLay[15] :="|         |          |         |                                        |   de Apropriacao ) |Deducao de Credito|  ser Apropriado  |"
			aLay[16] :="+---------+----------+---------+----------------------------------------+--------------------+------------------+------------------+"
			aLay[17] :="| ######  | ######## | ####### |########################################|     ############## |   ############## |   ############## |"
			aLay[18] :="+---------+----------+---------+----------------------------------------+--------------------+------------------+------------------+"
			aLay[19] :=""
			aLay[20] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			aLay[21] :="| 3 - DEMONSTRATIVO DA APURACAO DO CREDITO A SER EFETIVAMENTE APROPRIADO                                                           |"
			aLay[22] :="+----------+---------------------------------------+-----------------------+---------------------+----------+----------------------+"
			aLay[23] :="|          |   OPERACOES E PRESTACOES ( SAIDAS )   |                       |   SALDO ACUMULADO   |          |     CREDITO A SER    |"
			aLay[24] :="|          +-------------------+-------------------+      COEFICIENTE      | (BASE DO CREDITO A  |  FRACAO  |                      |"
			aLay[25] :="|    MES   |   TRIBUTADAS E    |  TOTAL DAS SAIDAS |          DE           |        SER          |  MENSAL  |      APROPRIADO      |"
			aLay[26] :="|          |    EXPORTACAO     |        (2)        |      CREDITAMENTO     |     APROPRIADO)     |          |                      |"
			aLay[27] :="|          |        (1)        |                   |      (3 = 1 / 2)      |       ( 4 )         |   (5)    |   ( 6 = 3 X 4 X 5 )  |"
			aLay[28] :="+----------+-------------------+-------------------+-----------------------+---------------------+----------+----------------------+"
			aLay[29] :="| ######## |    ############## |    ############## |       ################|      ############## |   ####   |       ############## |"
			aLay[34] :="+----------+-------------------+-------------------+-----------------------+---------------------+----------+----------------------+"
		Else
			aLay[30] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			aLay[31] :="|                                       CONTROLE DE CREDITO DE ICMS DO ATIVO PERMANENTE - CIAP                                     |"
			aLay[32] :="|                                                           MODELO C                                                               |"
			aLay[33] :="| ANO: ####                                                                                                            No. ######  |"
			aLay[01] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			aLay[02] :="| 1 - IDENTIFICACAO DO ESTABELECIMENTO                                                                                             |"
			aLay[03] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			aLay[04] :="|Nome: ######################################## C.N.P.J. No: ##################  CGC/TE: ##########################################|"
			aLay[05] :="|Endereco: ####################################   Bairro: #####################  Municipio: #######################################|"
			aLay[06] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			aLay[07] :=""
			aLay[08] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			If Mv_Par06 > 0	
				aLay[09] :="| 2 - DEMONSTRATIVO DA BASE PARA APROPRIACAO DE CREDITO (EM UFIR)                                                                  |"
			Else
				If Mv_Par18 > 0		//UPF - RS
					aLay[09] :="| 2 - DEMONSTRATIVO DA BASE PARA APROPRIACAO DE CREDITO (EM UPF-RS)                                                                |"
				Else
					aLay[09] :="| 2 - DEMONSTRATIVO DA BASE PARA APROPRIACAO DE CREDITO                                                                            |"
				Endif
			Endif
			aLay[10] :="+-----------------------------------------------------------------------+----------------------------------------------------------+"
			aLay[11] :="|                   IDENTIFICACAO DO BEM                                |                         VALOR DO ICMS                    |"
			aLay[12] :="+---------+----------+---------+----------------------------------------+--------------------+------------------+------------------+"
			aLay[13] :="| No ou   |          |   Nota  |                                        |       Entrada      |      Saida ou    | Total de Credito |"
			aLay[14] :="| Codigo  |   Data   |  Fiscal |             Descricao Resumida         |      (Credito)     |       Baixa      |    a Apropriar   |"
			aLay[15] :="+---------+----------+---------+----------------------------------------+--------------------+------------------+------------------+"
			aLay[16] :="| ######  | ######## | ####### |########################################|     ############## |   ############## |   ############## |"
			aLay[17] :="+---------+----------+---------+----------------------------------------+--------------------+------------------+------------------+"
			aLay[18] :=""
			aLay[19] :="+----------------------------------------------------------------------------------------------------------------------------------+"
			aLay[20] :="| 3 - DEMONSTRATIVO DA APROPRIACAO MENSAL DE CREDITO (EM REAIS)                                                                    |"
			aLay[21] :="+----------+---------------------------------------+-----------------------+---------------------+----------+----------------------+"
			aLay[22] :="|          |         OPERACOES E PRESTACOES        |                       |                     |          |   CREDITO MENSAL A   |"
			aLay[23] :="|          +-------------------+-------------------+      COEFICIENTE      |  TOTAL DE CREDITO   |  FRACAO  |                      |"
			aLay[24] :="|    MES   |     SAIDAS E      |  TOTAL DAS SAIDAS |          DE           |         A           |  MENSAL  |      APROPRIAR       |"
			aLay[25] :="|          |    PRESTACOES     |         E         |      APROPRIACAO      |     APROPRIAR       |          |                      |"
			aLay[26] :="|          |   TRIBUTADAS (1)  |    PRESTACOES (2) |      (3 = 1 / 2)      |       ( 4 )         |   (5)    |   ( 6 = 3 X 4 X 5 )  |"
			aLay[27] :="+----------+-------------------+-------------------+-----------------------+---------------------+----------+----------------------+"
			aLay[28] :="| ######## |    ############## |    ############## |       ################|      ############## |   ####   |       ############## |"
			aLay[29] :="+----------+-------------------+-------------------+-----------------------+---------------------+----------+----------------------+"
		Endif
	EndIf
ELSEIF MV_PAR03 = 4  //Modelo D
	IF MV_PAR06>0
		aLay[01] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[02] :="|                                     CONTROLE DE CREDITO DE ICMS DO ATIVO PERMANENTE - CIAP                                       |"
		aLay[03] :="|                                                           MODELO D                                                               |"
		aLay[04] :="|                                                                                                                      No. ######  |"
		aLay[05] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[06] :="| 1 - IDENTIFICACAO DO ESTABELECIMENTO                                                                                             |"
		aLay[07] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[08] :="|Nome: ######################################## Insc.Estadual : ################## C.N.P.J.: ######################################|"
		aLay[09] :="|Endereco: ####################################   Bairro: #####################  Municipio: #######################################|"
		aLay[10] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[11] :="| 2 - ENTRADA DO BEM                                                                                                               |"
		aLay[12] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[13] :="| Descricao : ##########################################                                                                           |"
		aLay[14] :="| Fornecedor: ##########################################                         Nota Fiscal: #################################### |"
		aLay[15] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[16] :="| N.do LRE: #####    Folha do LRE: #####      Data de Entrada: ##########      Valor do Credito (em UFIR): ####################### |"
		aLay[17] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[18] :="| 3 - SAIDA DO BEM                                                                                                                 |"
		aLay[19] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[20] :="| N. da Nota Fiscal: ##########                          Modelo: ################                   Data de Saida: ##############  |"
		aLay[21] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[22] :="| 4 - DEMONSTRATIVO DA APROPRIACAO MENSAL DE CREDITO (EM REAIS)                                                                    |"
		aLay[23] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[24] :="|                                1o. ANO                            |                             2o. ANO                          |"
		aLay[25] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[26] :="|  Parcela  |   Mes/Ano   |      Fator      |         Valor         |  Parcela  |   Mes/Ano   |      Fator      |       Valor      |"
		aLay[27] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[28] :="|    1a.    |   #######   |     ##########  |         ############# |    1a.    |   #######   |     ##########  |    ############# |"
		aLay[29] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[30] :="|    2a.    |   #######   |     ##########  |         ############# |    2a.    |   #######   |     ##########  |    ############# |"
		aLay[31] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[32] :="|    3a.    |   #######   |     ##########  |         ############# |    3a.    |   #######   |     ##########  |    ############# |"
		aLay[33] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[34] :="|    4a.    |   #######   |     ##########  |         ############# |    4a.    |   #######   |     ##########  |    ############# |"
		aLay[35] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[36] :="|    5a.    |   #######   |     ##########  |         ############# |    5a.    |   #######   |     ##########  |    ############# |"
		aLay[37] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[38] :="|    6a.    |   #######   |     ##########  |         ############# |    6a.    |   #######   |     ##########  |    ############# |"
		aLay[39] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[40] :="|    7a.    |   #######   |     ##########  |         ############# |    7a.    |   #######   |     ##########  |    ############# |"
		aLay[41] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[42] :="|    8a.    |   #######   |     ##########  |         ############# |    8a.    |   #######   |     ##########  |    ############# |"
		aLay[43] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[44] :="|    9a.    |   #######   |     ##########  |         ############# |    9a.    |   #######   |     ##########  |    ############# |"
		aLay[45] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[46] :="|   10a.    |   #######   |     ##########  |         ############# |   10a.    |   #######   |     ##########  |    ############# |"
		aLay[47] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[48] :="|   11a.    |   #######   |     ##########  |         ############# |   11a.    |   #######   |     ##########  |    ############# |"
		aLay[49] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[50] :="|   12a.    |   #######   |     ##########  |         ############# |   12a.    |   #######   |     ##########  |    ############# |"
		aLay[51] :="+==================================================================================================================================+"
		aLay[52] :="|                                3o. ANO                            |                             4o. ANO                          |"
		aLay[53] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[54] :="|  Parcela  |   Mes/Ano   |      Fator      |         Valor         |  Parcela  |   Mes/Ano   |      Fator      |       Valor      |"
		aLay[55] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[56] :="|    1a.    |   #######   |     ##########  |         ############# |    1a.    |   #######   |     ##########  |    ############# |"
		aLay[57] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[58] :="|    2a.    |   #######   |     ##########  |         ############# |    2a.    |   #######   |     ##########  |    ############# |"
		aLay[59] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[60] :="|    3a.    |   #######   |     ##########  |         ############# |    3a.    |   #######   |     ##########  |    ############# |"
		aLay[61] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[62] :="|    4a.    |   #######   |     ##########  |         ############# |    4a.    |   #######   |     ##########  |    ############# |"
		aLay[63] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[64] :="|    5a.    |   #######   |     ##########  |         ############# |    5a.    |   #######   |     ##########  |    ############# |"
		aLay[65] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[66] :="|    6a.    |   #######   |     ##########  |         ############# |    6a.    |   #######   |     ##########  |    ############# |"
		aLay[67] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[68] :="|    7a.    |   #######   |     ##########  |         ############# |    7a.    |   #######   |     ##########  |    ############# |"
		aLay[69] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[70] :="|    8a.    |   #######   |     ##########  |         ############# |    8a.    |   #######   |     ##########  |    ############# |"
		aLay[71] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[72] :="|    9a.    |   #######   |     ##########  |         ############# |    9a.    |   #######   |     ##########  |    ############# |"
		aLay[73] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[74] :="|   10a.    |   #######   |     ##########  |         ############# |   10a.    |   #######   |     ##########  |    ############# |"
		aLay[75] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[76] :="|   11a.    |   #######   |     ##########  |         ############# |   11a.    |   #######   |     ##########  |    ############# |"
		aLay[77] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[78] :="|   12a.    |   #######   |     ##########  |         ############# |   12a.    |   #######   |     ##########  |    ############# |"
		aLay[79] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
	Else
		aLay[01] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[02] :="|                                     CONTROLE DE CREDITO DE ICMS DO ATIVO PERMANENTE - CIAP                                       |"
		aLay[03] :="|                                                          MODELO D                                                                |"
		aLay[04] :="|                                                                                                          Numero de Ordem ######  |"
		aLay[05] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[06] :="| 1 - IDENTIFICACAO                                                                                                                |"
		aLay[07] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[08] :="|Nome: ######################################## Insc.Estadual : ################## C.N.P.J.: ######################################|"
		aLay[09] :="|Bem : ########################################                                                                                    |"
		aLay[10] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[11] :="| 2 - ENTRADA                                                                                                                      |"
		aLay[12] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[13] :="| Fornecedor: ##########################################                         Nota Fiscal: #################################### |"
		aLay[14] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[15] :="| N.do LRE: #####    Folha do LRE: #####        Data de Entrada: ##########             Valor do Credito : ####################### |"
		aLay[16] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[17] :="| 3 - SAIDA                                                                                                                        |"
		aLay[18] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[19] :="| N. da Nota Fiscal: ##########                          Modelo: ################                   Data de Saida: ##############  |"
		aLay[20] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[21] :="| 4 - PERDA ou BAIXA                                                                                                               |"
		aLay[22] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[23] :="| Tipo do Evento : #######################################                                                  Data : ##############  |"
		aLay[24] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[25] :="| 5 - DEMONSTRATIVO DA APROPRIACAO MENSAL DE CREDITO                                                                               |"
		aLay[26] :="+----------------------------------------------------------------------------------------------------------------------------------+"
		aLay[27] :="|                                1o. ANO                            |                             2o. ANO                          |"
		aLay[28] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[29] :="|  Parcela  |   Mes/Ano   |      Fator      |         Valor         |  Parcela  |   Mes/Ano   |      Fator      |      Valor       |"
		aLay[30] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[31] :="|    1a.    |   #######   |     ##########  |         ############# |    1a.    |   #######   |     ##########  |    ############# |"
		aLay[32] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[33] :="|    2a.    |   #######   |     ##########  |         ############# |    2a.    |   #######   |     ##########  |    ############# |"
		aLay[34] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[35] :="|    3a.    |   #######   |     ##########  |         ############# |    3a.    |   #######   |     ##########  |    ############# |"
		aLay[36] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[37] :="|    4a.    |   #######   |     ##########  |         ############# |    4a.    |   #######   |     ##########  |    ############# |"
		aLay[38] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[39] :="|    5a.    |   #######   |     ##########  |         ############# |    5a.    |   #######   |     ##########  |    ############# |"
		aLay[40] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[41] :="|    6a.    |   #######   |     ##########  |         ############# |    6a.    |   #######   |     ##########  |    ############# |"
		aLay[42] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[43] :="|    7a.    |   #######   |     ##########  |         ############# |    7a.    |   #######   |     ##########  |    ############# |"
		aLay[44] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[45] :="|    8a.    |   #######   |     ##########  |         ############# |    8a.    |   #######   |     ##########  |    ############# |"
		aLay[46] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[47] :="|    9a.    |   #######   |     ##########  |         ############# |    9a.    |   #######   |     ##########  |    ############# |"
		aLay[48] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[49] :="|   10a.    |   #######   |     ##########  |         ############# |   10a.    |   #######   |     ##########  |    ############# |"
		aLay[50] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[51] :="|   11a.    |   #######   |     ##########  |         ############# |   11a.    |   #######   |     ##########  |    ############# |"
		aLay[52] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[53] :="|   12a.    |   #######   |     ##########  |         ############# |   12a.    |   #######   |     ##########  |    ############# |"
		aLay[54] :="+==================================================================================================================================+"
		aLay[55] :="|                                3o. ANO                            |                             4o. ANO                          |"
		aLay[56] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[57] :="|  Parcela  |   Mes/Ano   |      Fator      |         Valor         |  Parcela  |   Mes/Ano   |      Fator      |      Valor       |"
		aLay[58] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[59] :="|    1a.    |   #######   |     ##########  |         ############# |    1a.    |   #######   |     ##########  |    ############# |"
		aLay[60] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[61] :="|    2a.    |   #######   |     ##########  |         ############# |    2a.    |   #######   |     ##########  |    ############# |"
		aLay[62] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[63] :="|    3a.    |   #######   |     ##########  |         ############# |    3a.    |   #######   |     ##########  |    ############# |"
		aLay[64] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[65] :="|    4a.    |   #######   |     ##########  |         ############# |    4a.    |   #######   |     ##########  |    ############# |"
		aLay[66] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[67] :="|    5a.    |   #######   |     ##########  |         ############# |    5a.    |   #######   |     ##########  |    ############# |"
		aLay[68] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[69] :="|    6a.    |   #######   |     ##########  |         ############# |    6a.    |   #######   |     ##########  |    ############# |"
		aLay[70] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[71] :="|    7a.    |   #######   |     ##########  |         ############# |    7a.    |   #######   |     ##########  |    ############# |"
		aLay[72] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[73] :="|    8a.    |   #######   |     ##########  |         ############# |    8a.    |   #######   |     ##########  |    ############# |"
		aLay[74] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[75] :="|    9a.    |   #######   |     ##########  |         ############# |    9a.    |   #######   |     ##########  |    ############# |"
		aLay[76] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[77] :="|   10a.    |   #######   |     ##########  |         ############# |   10a.    |   #######   |     ##########  |    ############# |"
		aLay[78] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[79] :="|   11a.    |   #######   |     ##########  |         ############# |   11a.    |   #######   |     ##########  |    ############# |"
		aLay[80] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
		aLay[81] :="|   12a.    |   #######   |     ##########  |         ############# |   12a.    |   #######   |     ##########  |    ############# |"
		aLay[82] :="+-----------+-------------+-----------------+-----------------------+-----------+-------------+-----------------+------------------+"
	Endif
EndIf

Return(Nil)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³R995BahiaC³ Autor ³Gustavo G. Rueda       ³ Data ³24.09.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do livro modelo C do estado da bahia.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpL -> lEnd - Flag de cancelamento.                        ³±±
±±³          ³ExpC -> cString.                                            ³±±
±±³          ³ExpN -> Tamanho.                                            ³±±
±±³          ³ExpL -> cEstado = Retorna o conteudo do parametro MV_ESTADO.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R995BahiaC(lEnd,wnRel,cString,Tamanho, cEstado, nPagIni)
Local	aStruSFA  	:= 	{}
Local	aStruSF9  	:= 	{}
Local	aLay		:= 	Array (35)
Local	aPeriodos	:=	{}
Local	aQuadro4	:=	{}
Local	aAno		:=	{}
Local	aStruSF3  	:= 	{}
Local	nAno		:=	0
Local	nCtd		:=	0
Local	nX			:=	0
Local	nIndex		:=	0
Local	nAcVal9		:=	0
Local	nPos		:=	0
Local	nAcBaixa	:=	0
Local	nQtdLin		:=	65	//Define a qtd de linhas por folha.
Local	nLin		:=	999
Local	cDataScan	:=	""
Local	cDataEnt	:=	""
Local	cDataSai	:=	""
Local	cAliasSF3 	:= 	""
Local	cAliasSFA 	:= 	""
Local	cAliasSF9 	:= 	""
Local	cQuery    	:=	""
Local	cIndSF9	  	:= 	CriaTrab (Nil,.F.)
Local	cChave		:= 	IndexKey ()
Local	cFilSF9		:=	""
Local 	dLei102 	:= 	SuperGetMv ("MV_DATCIAP")
Local	dUltDiaMes	:=	CToD ("  /  /  ")
Local	dDataIni 	:=	CToD ("  /  /  ")
Local	dDataFim	:=	CToD ("  /  /  ")
Local	lProcSf3	:=	.T.
Local	aSaidPrest	:=	{} 
Local	nQtdAnos	:=	4	//Define a qtd de anos base para apropriacao.
Local	nQtdMeses	:=	48	//Define a qtd de meses base para apropriacao.
Local 	nOrdem		:= nPagIni
Local 	dDataBaixa	:=	CToD ("  /  /  ")
//
aSaidPrest	:=	CoefApr (MV_PAR04, MV_PAR05)//
//
R995LayOut (@aLay, cEstado)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Mantado base para os outros registros.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea ("SF9")
SF9->(DbSetOrder (1))
#IFDEF TOP
	cAliasSF9 := "AliasSF9"
	aStruSF9  := SF9->(dbStruct ())
	cQuery    := "SELECT * "
	cQuery    += "FROM "+RetSqlName ("SF9")+" SF9 "
	cQuery    += "WHERE SF9.F9_FILIAL='"+xFilial("SF9")+"' AND "
	cQuery    += "SF9.F9_CODIGO>='"+MV_PAR01+"' AND "
	cQuery    += "SF9.F9_CODIGO<='"+MV_PAR02+"' AND "
	cQuery    += "SF9.F9_DTENTNE>'"+DToS (dLei102)+"' AND "
	cQuery    += "SF9.F9_DTENTNE>='"+DToS (MV_PAR08)+"' AND "
	cQuery    += "SF9.F9_DTENTNE<='"+DToS (MV_PAR09)+"' AND "
	cQuery    += "SF9.D_E_L_E_T_=' ' "
	cQuery    += "ORDER BY "+SqlOrder (SF9->(IndexKey ()))
	//
	cQuery    := ChangeQuery (cQuery)
	//
	DbUseArea (.T., "TOPCONN", TcGenQry (,, cQuery), cAliasSF9, .T., .T.)
	//
	For nX := 1 To Len (aStruSF9)
		If (aStruSF9[nX][2]<>"C")
			TcSetField (cAliasSF9, aStruSF9[nX][1], aStruSF9[nX][2], aStruSF9[nX][3], aStruSF9[nX][4])
		EndIf
	Next nX
#ELSE
	cAliasSF9 := "SF9"
	cIndSF9	  := CriaTrab (NIL,.F.)
	cChave	  := IndexKey ()
	cFilSF9	  := "F9_FILIAL=='"+xFilial ("SF9")+"' .And. F9_CODIGO>='"+MV_PAR01+"' .And. F9_CODIGO<='"+MV_PAR02+"'"
	cFilSF9   += " .And. Dtos(F9_DTENTNE)>='"+DToS (MV_PAR08)+"' .And. Dtos(F9_DTENTNE)<='"+DToS (MV_PAR09)+"'"
	cFilSF9   += " .And. Dtos(F9_DTENTNE)>'"+DToS (dLei102)+"'"	
	//
	IndRegua (cAliasSF9, cIndSF9, cChave,, cFilSF9)
	nIndex := RetIndex ("SF9")
	DbSelectArea ("SF9")
	DbSetIndex (cIndSF9+OrdBagExt ())
	DbSetOrder (nIndex+1)
#ENDIF
//
SetRegua (SF9->(RecCount ()))
//
DbSelectArea (cAliasSf9)
(cAliasSF9)->(DbGoTop ())
//
Do While !(cAliasSF9)->(Eof ())
	//
	If !(Empty (cFiltro)).And. !((cAliasSF9)->(&(cFiltro)))
		(cAliasSF9)->(DbSkip ())
			IncRegua ()
		Loop
	Endif
	//
	If Interrupcao (@lEnd)
		Exit
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLin	:=	1
	@ nLin,000 PSAY aValImp (Limite)
	//
	FmtLin (, aLay[01],,, @nLin)
	FmtLin (, aLay[02],,, @nLin)
		FmtLin ({StrZero (nOrdem, 5)}, aLay[03],,, @nLin)
		nOrdem++
	FmtLin (, aLay[04],,, @nLin)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do registro 1-Identificacao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FmtLin (, aLay[05],,, @nLin)
	FmtLin (, aLay[06],,, @nLin)
	FmtLin ({SM0->M0_NOMECOM, SM0->M0_INSC},aLay[07],,, @nLin)
	FmtLin (, aLay[08],,, @nLin)
	FmtLin ({(cAliasSF9)->F9_DESCRI}, aLay[09],,, @nLin)
	FmtLin (, aLay[10],,, @nLin)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do registro 2-Entrada               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SA2->(DbSetOrder (1))
	SA2->(MsSeek (xFilial ("SA2")+(cAliasSF9)->F9_FORNECE+(cAliasSF9)->F9_LOJAFOR))
	//
	cDataEnt	:=	SubStr (DToS ((cAliasSF9)->F9_DTENTNE), 7, 2)+"/"+SubStr (DToS ((cAliasSF9)->F9_DTENTNE), 5, 2)+"/"+SubStr (DToS ((cAliasSF9)->F9_DTENTNE), 1, 4)
	//
	FmtLin (, aLay[11],,, @nLin)
	FmtLin (, aLay[12],,, @nLin)
	FmtLin ({SA2->A2_NOME, (cAliasSF9)->F9_DOCNFE, (cAliasSF9)->F9_SERNFE}, aLay[13],,, @nLin)
	FmtLin (, aLay[14],,, @nLin)
	FmtLin ({StrZero ((cAliasSF9)->F9_NLRE, 3), StrZero ((cAliasSF9)->F9_FLRE, 3), AllTrim (cDataEnt), Transform ((cAliasSF9)->F9_VALICMS, "@E 9,999,999,999.99")}, aLay[15],,, @nLin)
	FmtLin (, aLay[16],,, @nLin)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do registro 3-Saidas                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializando dados do registro 4. Pois alguns serão utilizados no registro 3.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aPeriodos	:=	sfRetPer ((cAliasSF9)->F9_DTENTNE, aSaidPrest, @aQuadro4, nQtdMeses)
	nAno		:=	Iif (Len (aPeriodos)>0, aPeriodos[1][2], 0)
	aAno		:=	Array (1)
	aAno[1]		:=	Iif (Len (aPeriodos)>0, {StrZero (aPeriodos[1][2], 4), 0}, {})
	cDataSai	:=	SubStr (DToS ((cAliasSF9)->F9_DTEMINS), 7, 2)+"/"+SubStr (DToS ((cAliasSF9)->F9_DTEMINS), 5, 2)+"/"+SubStr (DToS ((cAliasSF9)->F9_DTEMINS), 1, 4)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fixo a data de entrada do bem na variável dDataIni e o vencimento    ³
	//³ após os 48 meses, onde será armazenado na variavel dDataFim.        ³
	//³Este 48 meses esta definido na variavel nQtdAnos declarada no inicio ³
	//³ como 4, que he, (48/12) = 4.                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dDataIni	:=	(cAliasSF9)->F9_DTENTNE
	dDataFim	:=	SToD (StrZero ((Year ((cAliasSF9)->F9_DTENTNE)+4), 4)+SubStr (AllTrim (DToS ((cAliasSF9)->F9_DTENTNE)), 5,4))-1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializando campos do array aQaudro4 que nao estao preenchidos, com os 48 meses a partir da data de entrada do bem.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCtd := 1 To (Len (aQuadro4))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ano e valor para o quadro 5 - Cancelamento do saldo.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nAno<>aPeriodos[nCtd][2])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Estrutura do array aAno:³
			//³1-Ano(String)           ³
			//³2-Valor(Numerico)       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd (aAno, {StrZero (aPeriodos[nCtd][2], 4), 0})
			//
			nAno	:=	aPeriodos[nCtd][2]
		EndIf
		//
		aQuadro4[nCtd][01]	:=	MesExtenso (aPeriodos[nCtd][3])
		aQuadro4[nCtd][02]	:=	StrZero (aPeriodos[nCtd][2], 4)
		//
		For nX := 3 To Len (aQuadro4[nCtd])
			If (aQuadro4[nCtd][nX]==Nil)
				aQuadro4[nCtd][nX]	:=	0
			EndIf
		Next nX
		//
	Next nCtd
	//
	FmtLin (, aLay[17],,, @nLin)
	FmtLin (, aLay[18],,, @nLin)
	//
	SFA->(DbSetOrder (1))
	//
	If (SFA->(MsSeek (xFilial ("SFA")+(cAliasSF9)->F9_CODIGO)))
		//
		nAcVal9		:=	0
		nAcBaixa	:=	0
		//		
		Do While !SFA->(Eof ()) .And. ((cAliasSF9)->F9_CODIGO=SFA->FA_CODIGO) .And. ((cAliasSF9)->F9_FILIAL=xFilial("SF9"))
			//
			If (SFA->(Fieldpos ("FA_CREDIT"))<>0)
				If (SFA->FA_CREDIT=="2")
					SFA->(DbSkip ())
					Loop
				EndIf
			EndIf
			//
			nAcBaixa	+=	Iif (SFA->FA_TIPO=="2", SFA->FA_VALOR, 0)
			//
			If ((cAliasSF9)->F9_VALICMS-nAcBaixa>0)
				nPos				:=	aScan (aPeriodos, {|w| w[2]==Val (SubStr (AllTrim (DToS (SFA->FA_DATA)), 1, 4)) .And. w[3]==Val (SubStr (AllTrim (DToS (SFA->FA_DATA)), 5, 2))})
				//
				If (nPos>0)
					dUltDiaMes			:=	LastDay (CToD ("01/"+AllTrim (StrZero (aPeriodos[nPos][03], 2))+"/"+SubStr (AllTrim (aQuadro4[nPos][2]), 1, 4), "ddmmyy"))
					dDataBaixa			:=	Iif (SFA->FA_TIPO=="2", dUltDiaMes, SFA->FA_DATA)
					//
					aQuadro4[nPos][06]	+=	(SFA->FA_VALOR/Day (dDataBaixa))*Day (dUltDiaMes)
					aQuadro4[nPos][07]	:=	Day (dUltDiaMes)
					//
					//Calculo do pro rata die.
					//Caso o bem tenha entrada no ultimo dia do mes, o pro rata die eh 1
					If (cAliasSF9)->F9_DTENTNE==dUltDiaMes
						aQuadro4[nPos][08]	:=	1
					//
					//Caso o bem tenha entrada no meio do mes
					ElseIf Month ((cAliasSF9)->F9_DTENTNE)==Month (dUltDiaMes) .And. Year ((cAliasSF9)->F9_DTENTNE)==Year (dUltDiaMes)
						aQuadro4[nPos][08]	:=	(dUltDiaMes-(cAliasSF9)->F9_DTENTNE)
					//
					//Em nenhum situacao, o pro rata die eh o mes cheio.
					Else
						aQuadro4[nPos][08]	:=	Day (dUltDiaMes)
						
					EndIf
					//
					//Calculo Pro Rata para quando houver baixas no meio do mes.
					If (SFA->FA_DATA<>LastDay (SFA->FA_DATA))
						aQuadro4[nPos][08]	:=	Day (SFA->FA_DATA)
					EndIf
					//
					aQuadro4[nPos][09]	:=	(aQuadro4[nPos][06]/aQuadro4[nPos][07])*aQuadro4[nPos][08]
					nAcVal9				+=	aQuadro4[nPos][09]
					aQuadro4[nPos][10]	:=	If((cAliasSF9)->F9_VALICMS-nAcBaixa-nAcVal9>0,(cAliasSF9)->F9_VALICMS-nAcBaixa-nAcVal9,0)
				EndIf
			EndIf
			//
			If (SFA->FA_TIPO=="2")
				FmtLin ({(cAliasSF9)->F9_DOCNFS, (cAliasSF9)->F9_SERNFS, "01", cDataSai}, aLay[19],,, @nLin)
				//
				nPos	:=	aScan (aAno, {|y| y[1]==SubStr (Alltrim (DToS (SFA->FA_DATA)), 1, 4)})
			   	If (nPos>0)
				   	aAno[nPos][2]	+=	ABS(SF9->F9_VALICMS-nAcVal9)
				EndIf				
			EndIf
			//
			SFA->(DbSkip ())
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Este if imprime NF de saída caso nao seja impresso dentro do while acima. Pois e     |
		//|   necessario imprimir mesmo que for em branco.                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (aScan (aAno, {|k| k[2]<>0})==0)
			FmtLin ({"      ", "   ", "  ", "  /  /    "}, aLay[19],,, @nLin)			
		EndIf
	Else
		FmtLin ({"      ", "   ", "  ", "  /  /    "}, aLay[19],,, @nLin)
	EndIf
	FmtLin (, aLay[20],,, @nLin)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Quadro 4 - Controle de apropriacao mensal de credito.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FmtLin (, aLay[21],,, @nLin)
	FmtLin (, aLay[22],,, @nLin)
	FmtLin (, aLay[23],,, @nLin)
	FmtLin (, aLay[24],,, @nLin)
	FmtLin (, aLay[25],,, @nLin)
	FmtLin (, aLay[26],,, @nLin)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando base para o registro 4, colunas 1, 2, 3 e 4.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len (aQuadro4)
		//
		If (aQuadro4[nX][7]<>0)
			If (nLin>nQtdLin-1)
				FmtLin (, aLay[28],,, @nLin)
				nLin	:=	1
				FmtLin (, aLay[01],,, @nLin)
				FmtLin (, aLay[02],,, @nLin)
				nOrdem++
				FmtLin ({StrZero (nOrdem, 5)}, aLay[03],,, @nLin)
				FmtLin (, aLay[04],,, @nLin)
					//
				FmtLin (, aLay[21],,, @nLin)
				FmtLin (, aLay[22],,, @nLin)
				FmtLin (, aLay[23],,, @nLin)
				FmtLin (, aLay[24],,, @nLin)
				FmtLin (, aLay[25],,, @nLin)
				FmtLin (, aLay[26],,, @nLin)
			
			EndIf
			//
			FmtLin ({SubStr (AllTrim (aQuadro4[nX][1]), 1, 3),;			//Mes(1)
				SubStr (AllTrim (aQuadro4[nX][2]), 1, 4),;					//Ano(2)
				Transform (aQuadro4[nX][3], "@E 9,999,999,999.99"),;		//Saidas/Prestacoes - Totais(3)
				Transform (aQuadro4[nX][4], "@E 9,999,999,999.99"),;		//Saidas/Prestacoes - Tributadas(4)
				Transform (aQuadro4[nX][5], "@E 9,999,999,999.99"),;		//% Saidas/Prest. - Tributadas(5)
				Transform (aQuadro4[nX][6], "@E 9,999,999,999.99"),;		//Credito Possivel(6)
				StrZero   (aQuadro4[nX][7], 3),;							//Quantidade de dias - Mes(7)
				StrZero   (aQuadro4[nX][8], 3),;							//Quantidade de dias - Pro Rata die(8)
				Transform (aQuadro4[nX][9], "@E 9,999,999,999.99"),;		//Credito/Mes(9) = (6/7*8)
				Transform (aQuadro4[nX][10], "@E 9,999,999,999.99"),;		//saldo credito(10)
				},aLay[27],,, @nLin)
		EndIf
	Next nX
	FmtLin (,aLay[28],,, @nLin)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montando e imprimindo quadro 5 - Cancelamento do saldo.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nQtdLin-1)-nLin)>5
		FmtLin (,aLay[29],,, @nLin)
		FmtLin (,aLay[30],,, @nLin)
		FmtLin (,aLay[31],,, @nLin)
		FmtLin (,aLay[32],,, @nLin)
	Else
		nLin	:=	nQtdLin
	EndIf
	//
	For nX := 1 To (Len (aAno))
		If (nLin>nQtdLin-1)
			If nX>1
				FmtLin (, aLay[34],,, @nLin)
			EndIf
			nLin	:=	1
			FmtLin (, aLay[01],,, @nLin)
			FmtLin (, aLay[02],,, @nLin)
			nOrdem++
			FmtLin ({StrZero (nOrdem, 5)}, aLay[03],,, @nLin)
			FmtLin (, aLay[04],,, @nLin)
				//
			FmtLin (,aLay[29],,, @nLin)
			FmtLin (,aLay[30],,, @nLin)
			FmtLin (,aLay[31],,, @nLin)
			FmtLin (,aLay[32],,, @nLin)
		EndIf
		//
		FmtLin ({SubStr (AllTrim (Str (nX)), 1, 1)+".", AllTrim (aAno[nX][1]), Transform (aAno[nX][2], "@E 9,999,999,999.99")}, aLay[33],,, @nLin)
	Next nX
	FmtLin (, aLay[34],,, @nLin)
	FmtLin (, aLay[35],,, @nLin)
	//
	(cAliasSF9)->(DbSkip ())
	IncRegua()
EndDo
//
#IFDEF TOP
	(cAliasSF9)->(DbCloseArea ())
#ELSE
	RetIndex("SF9")
	Ferase (cIndSF9+OrdBagExt ())
#ENDIF
Return (.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RetPer    ³ Autor ³Gustavo G. Rueda       ³ Data ³24.09.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta  funcao monta 2 array's: 1-Array de periodos para cada ³±±
±±³          ³ data de entrada do bem, pois e feito um calculo de 48 meses³±±
±±³          ³ apos esta entrada. O formato deste array segue logo abaixo.³±±
±±³          ³ 2-Array aQuadro4, este array possui o conteudo a ser       ³±±
±±³          ³ impresso no quadro 4. Esta funcao alimenta a coluna 2, 3, 4³±±
±±³          ³ do quadro 4.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpD -> dDataIni - Data inicial.                            ³±±
±±³          ³ExpD -> dDataFim - Data inicial.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Estrutura do array aPeriodo:        ³     ³Estrutura do array aQuadro4:     ³
³1-Controle sequencial dos registros.³     ³1 - Mes extenso.                 ³
³2-Mes(Numerico)                     ³     ³2 - Ano.                         ³
³3-Ano(Numercio)                     ³     ³3 - Totais Saidas/Prestacoes.    ³
³4-AAAAMM(String)                    ³     ³4 - Tributados Saidas/Prestacoes.³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     ³5 - %Saidas/Prest Tributadas.    ³
                                           ³6 - Credito possivel.            ³
                                           ³7 - Quantidade de dias - Mes     ³
                                           ³8 - Pro Rata die                 ³
                                           ³9 - Valor credito mes.           ³
                                           ³10 - Saldo do credito.           ³
                                           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
Static Function sfRetPer (dDataEnt, aSaidPrest, aQuadro4, nMaxMeses)
Local	aRetMes		:=	{}
Local	nCtd		:=	1
Local	nMesEnt		:=	Val (SubStr (DToS (dDataEnt), 5, 2))
Local	nAnoEnt		:=	Val (SubStr (DToS (dDataEnt), 1, 4))
Local	nPos		:=	0
//
aQuadro4	:=	{}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Limito a qtd de registros a 48 que he exigido pelo layout.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCtd := 1 To nMaxMeses
		aAdd (aRetMes, {nCtd, nAnoEnt, nMesEnt, SubStr (AllTrim (Str (nAnoEnt))+AllTrim (StrZero (nMesEnt, 2)), 1, 6)})
		//
		nPos	:=	aScan (aSaidPrest, {|aSP| aSP[1]==AllTrim (Str (aRetMes[nCtd][2]))+AllTrim (StrZero (aRetMes[nCtd][3], 2))})
		//
		If (nPos>0)
			aAdd (aQuadro4, {Nil, Nil, aSaidPrest[nPos][3], aSaidPrest[nPos][2], aSaidPrest[nPos][4], Nil, Nil, Nil, Nil, Nil})
		Else
			aAdd (aQuadro4, {"", "", Nil, Nil, Nil, Nil, Nil, Nil, Nil, Nil})
		EndIf
		//
		If (nMesEnt/12==1)
			nMesEnt	:=	0
			nAnoEnt++
		EndIf
		//
	nMesEnt++
Next nCtd
Return (aRetMes)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³Edstron E. Correia     ³ Data ³06/08/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Acerta o arquivo de perguntas                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION AjustaSx1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

Aadd( aHelpPor, "Data Inicial Informada para que sejam" )
Aadd( aHelpPor, "exibidas no Livro CIAP Modelo 'C' as " )
Aadd( aHelpPor, "informacoes referentes aos Ativos    " )
Aadd( aHelpPor, "adquiridos a partir desta data.      " )
Aadd( aHelpEng, "Data Inicial Informada para que sejam" )
Aadd( aHelpEng, "exibidas no Livro CIAP Modelo 'C' as " )
Aadd( aHelpEng, "informacoes referentes aos Ativos    " )
Aadd( aHelpEng, "adquiridos a partir desta data.      " )
Aadd( aHelpSpa, "Data Inicial Informada para que sejam" )
Aadd( aHelpSpa, "exibidas no Livro CIAP Modelo 'C' as " )
Aadd( aHelpSpa, "informacoes referentes aos Ativos    " )
Aadd( aHelpSpa, "adquiridos a partir desta data.      " )
PutSX1Help("P.PERGVIT27008.",aHelpPor,aHelpEng,aHelpSpa)
//
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, "Data Final Informada para que sejam  " )
Aadd( aHelpPor, "exibidas no Livro CIAP Modelo 'C' as " )
Aadd( aHelpPor, "informacoes referentes aos Ativos    " )
Aadd( aHelpPor, "adquiridos ate esta data.            " )
Aadd( aHelpEng, "Data Final Informada para que sejam  " )
Aadd( aHelpEng, "exibidas no Livro CIAP Modelo 'C' as " )
Aadd( aHelpEng, "informacoes referentes aos Ativos    " )
Aadd( aHelpEng, "adquiridos ate esta data.            " )
Aadd( aHelpSpa, "Data Final Informada para que sejam  " )
Aadd( aHelpSpa, "exibidas no Livro CIAP Modelo 'C' as " )
Aadd( aHelpSpa, "informacoes referentes aos Ativos    " )
Aadd( aHelpSpa, "adquiridos ate esta data.            " )
PutSX1Help("P.PERGVIT27009.",aHelpPor,aHelpEng,aHelpSpa)
//
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, "Indica se dever ser impresso o Livro ou " )
Aadd( aHelpPor, "os Termos ou os Llivros e termos.       " )
Aadd( aHelpEng, "Indica se dever ser impresso o Livro ou " )
Aadd( aHelpEng, "os Termos ou os Llivros e termos.       " )
Aadd( aHelpSpa, "Indica se dever ser impresso o Livro ou " )
Aadd( aHelpSpa, "os Termos ou os Llivros e termos.       " )
PutSX1Help("P.PERGVIT27010.",aHelpPor,aHelpEng,aHelpSpa)
//
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, "Número de ordem do Livro." )
Aadd( aHelpEng, "Número de ordem do Livro." )
Aadd( aHelpSpa, "Número de ordem do Livro." )
PutSX1Help("P.PERGVIT27011.",aHelpPor,aHelpEng,aHelpSpa)
//
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, "Número inicial da 1ª página do Livro." )
Aadd( aHelpEng, "Número inicial da 1ª página do Livro." )
Aadd( aHelpSpa, "Número inicial da 1ª página do Livro." )
PutSX1Help("P.PERGVIT27012.",aHelpPor,aHelpEng,aHelpSpa)
//
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, "Quantidade de páginas contidas num feixe" )
Aadd( aHelpEng, "Quantidade de páginas contidas num feixe" )
Aadd( aHelpSpa, "Quantidade de páginas contidas num feixe" )
PutSX1Help("P.PERGVIT27013.",aHelpPor,aHelpEng,aHelpSpa)
//
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, "Nome da junta comercial do contribuinte." )
Aadd( aHelpEng, "Nome da junta comercial do contribuinte." )
Aadd( aHelpSpa, "Nome da junta comercial do contribuinte." )
PutSX1Help("P.PERGVIT27014.",aHelpPor,aHelpEng,aHelpSpa)
//
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, "Observação a ser destacada no Livro." )
Aadd( aHelpEng, "Observação a ser destacada no Livro." )
Aadd( aHelpSpa, "Observação a ser destacada no Livro." )
PutSX1Help("P.PERGVIT27015.",aHelpPor,aHelpEng,aHelpSpa)
//
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, "CRC do contador responsável pela ")
Aadd( aHelpPor, "escrituração do Livro." )
Aadd( aHelpEng, "CRC do contador responsável pela ")
Aadd( aHelpEng, "escrituração do Livro." )
Aadd( aHelpSpa, "CRC do contador responsável pela ")
Aadd( aHelpSpa, "escrituração do Livro." )
PutSX1Help("P.PERGVIT27016.",aHelpPor,aHelpEng,aHelpSpa)
//
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, "Data do ultimo lançamento para o período ")
Aadd( aHelpPor, "declarado no Livro." )
Aadd( aHelpEng, "Data do ultimo lançamento para o período ")
Aadd( aHelpEng, "declarado no Livro." )
Aadd( aHelpSpa, "Data do ultimo lançamento para o período ")
Aadd( aHelpSpa, "declarado no Livro." )
PutSX1Help("P.PERGVIT27017.",aHelpPor,aHelpEng,aHelpSpa)
//
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
Aadd( aHelpPor, "Informe a taxa de conversao em UPF-RS,  " )
Aadd( aHelpPor, "somente para o estado do RS             " )
Aadd( aHelpEng, "Informe a taxa de conversao em UPF-RS,  " )
Aadd( aHelpEng, "somente para o estado do RS             " )
Aadd( aHelpSpa, "Informe a taxa de conversao em UPF-RS,  " )
Aadd( aHelpSpa, "somente para o estado do RS             " )
PutSX1Help("P.PERGVIT27018.",aHelpPor,aHelpEng,aHelpSpa)

PutSx1("PERGVIT270","08","Data Ativo de      ?","Data Ativo de      ?","Data Ativo de      ?","mv_ch8","D",08,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","")
PutSx1("PERGVIT270","09","Data Ativo ate     ?","Data Ativo ate     ?","Data Ativo ate     ?","mv_ch9","D",08,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","")
PutSx1("PERGVIT270","10","Imprime            ?","Imprime            ?","Imprime            ?","mv_chA","N",01,0,1,"C","","","","","mv_par10","Livro","Livro","Livro","","Termos","Termos","Termos","Livro e Termos","Livro e Termos","Livro e Termos","","","","")
PutSx1("PERGVIT270","11","No. de Ordem       ?","No. de Ordem       ?","No. de Ordem       ?","mv_chB","C",10,0,0,"G","","","","","mv_par11","","","","","","","","","","","","","","")
PutSx1("PERGVIT270","12","No. Pagina Inicial ?","No. Pagina Inicial ?","No. Pagina Inicial ?","mv_chC","N",03,0,0,"G","","","","","mv_par12","","","","","","","","","","","","","","")
PutSx1("PERGVIT270","13","Qtd. Paginas/Feixe ?","Qtd. Paginas/Feixe ?","Qtd. Paginas/Feixe ?","mv_chD","N",03,0,0,"G","","","","","mv_par13","","","","","","","","","","","","","","")
PutSx1("PERGVIT270","14","Junta Comercial    ?","Junta Comercial    ?","Junta Comercial    ?","mv_chE","C",20,0,0,"G","","","","","mv_par14","","","","","","","","","","","","","","")
PutSx1("PERGVIT270","15","Observacoes        ?","Observacoes        ?","Observacoes        ?","mv_chF","C",50,0,0,"G","","","","","mv_par15","","","","","","","","","","","","","","")
PutSx1("PERGVIT270","16","CRC do Contador    ?","CRC do Contador    ?","CRC do Contador    ?","mv_chG","C",20,0,0,"G","","","","","mv_par16","","","","","","","","","","","","","","")
PutSx1("PERGVIT270","17","Ultimo Lancamento  ?","Ultimo Lancamento  ?","Ultimo Lancamento  ?","mv_chH","D",08,0,0,"G","","","","","mv_par17","","","","","","","","","","","","","","")
PutSx1("PERGVIT270","18","Taxa UPF-RS        ?","Taxa UPF-RS        ?","Taxa UPF-RS        ?","mv_chi","N",14,4,0,"G","","","","","mv_par18","","","","","","","","","","","","","","")

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R995Procf3³ Autor ³Gustavo G. Rueda       ³ Data ³24/11/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao monta um array baseado no SF3 com os valores    ³±±
±±³          ³   aglutinados mensalmente para um periodo determinado pelas³±±
±±³          ³   perguntas.A movimentacao contida neste array e consultada³±±
±±³          ³   a cada bem.                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA = aSf3 = Array com movimentacoes do SF3.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Formato do array aSaidPrest:     ³
³1 = Ano+Mes = Ex: "200301"       ³
³2 = Totais Saidas/Prestacoes     ³
³3 = Tributadas Saidas/Prestacoes ³
³4 = %Saidas/Prestacoes Tributadas³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
Static Function R995Procf3 ()
	Local	cQuery		:=	""
	Local	cAliasSf3	:=	""
	Local	aStruSf3	:=	{}
	Local	lSF3     	:= .F.
	Local	lIcmsDif 	:= .F.
	Local	cDataScan	:=	""
	Local	nPos		:=	0
	Local	lRet		:=	.F.
	Local	aSf3		:=	{}
	Local	cIndSf3		:=	""
	Local	nIndex		:=	0
	Local	cFilSf3		:=	""
	Local	cChave		:=	""
	//
	DbSelectArea ("SF3")
	DbSetOrder (1)
	#IFDEF TOP
		cAliasSF3 := "AliasSF3"
		aStruSF3  := SF3->(dbStruct())
		cQuery    := "SELECT * "
		cQuery    += "FROM "+RetSqlName("SF3")+" SF3 "
		cQuery    += "WHERE SF3.F3_FILIAL='"+xFilial("SF3")+"' AND "
		cQuery    += "SF3.F3_ENTRADA >= '"+DTOS(MV_PAR04)+"' AND "
		cQuery    += "SF3.F3_ENTRADA <= '"+DTOS(MV_PAR05)+"' AND "
		cQuery    += "(SF3.F3_CFO LIKE '5%' OR SF3.F3_CFO LIKE '6%' OR SF3.F3_CFO LIKE '7%') AND "
		cQuery    += "SF3.D_E_L_E_T_=' ' AND "
		cQuery    += "EXISTS ( SELECT * FROM "
		cQuery    += RetSqlName("SD2")+" SD2,"+RetSqlName("SF4")+" SF4 "
		cQuery    += "WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
		cQuery    += "SD2.D2_DOC=SF3.F3_NFISCAL AND "
		cQuery    += "SD2.D2_SERIE=SF3.F3_SERIE AND "
		cQuery    += "SD2.D2_CLIENTE=SF3.F3_CLIEFOR AND "
		cQuery    += "SD2.D2_LOJA=SF3.F3_LOJA AND "
		cQuery    += "SD2.D_E_L_E_T_=' ' AND "
		cQuery    += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
		cQuery    += "SF4.F4_CODIGO=SD2.D2_TES AND "
		//
		//Habilito Poder de 3. conforme parametro.
		If !(GetNewPar ("MV_P3CIAP", .F.))
			cQuery    += "SF4.F4_PODER3='N' AND "
		Endif
		
		cQuery    += "SF4.D_E_L_E_T_=' ') "
		cQuery    += "ORDER BY "+SqlOrder(SF3->(IndexKey()))
		cQuery 	  := ChangeQuery(cQuery)
		//
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.T.,.T.)
		//
		For nX := 1 To Len (aStruSF3)
			If (aStruSF3[nX][2]<>"C")
				TcSetField (cAliasSF3, aStruSF3[nX][1], aStruSF3[nX][2], aStruSF3[nX][3], aStruSF3[nX][4])
			EndIf
		Next nX
	#ELSE
		cAliasSF3 	:= 	"SF3"
		cIndSF3	  	:= 	CriaTrab (NIL,.F.)
		cChave	  	:= 	IndexKey()
		cFilSF3	  	:= 	"F3_FILIAL=='"+xFilial("SF3")+"' .And. DToS (F3_ENTRADA)>='"+DToS (MV_PAR04)+"' .And. DToS (F3_ENTRADA)<='"+DToS (MV_PAR05)+"' "
		cFilSf3		+=	".And. Left (F3_CFO, 1)>='5' "
        //
		IndRegua (cAliasSF3, cIndSF3, cChave,, cFilSF3)
		nIndex := RetIndex("SF3")
		//
		DbSelectArea("SF3")
		DbSetIndex (cIndSF3+OrdBagExt ())
		DbSetOrder (nIndex+1)
	#ENDIF
	//
	SetRegua(SF3->(RecCount ()))
	//
	DbSelectArea (cAliasSf3)
		(cAliasSF3)->(dbGoTop())
	//
	Do While !((cAliasSF3)->(Eof ()))
		//
		lSF3     := .F.
		lIcmsDif := .F.
		//
		If (cAliasSF3)->(FieldPos("F3_ICMSDIF"))>0
			//
			SD2->(DbSetOrder (3))
			SD2->(MsSeek (xFilial("SD2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))
			//
			Do While !SD2->(Eof ()) .And. ((cAliasSF3)->F3_NFISCAL==SD2->D2_DOC) .And. ((cAliasSF3)->F3_SERIE==SD2->D2_SERIE) .And.;
					((cAliasSF3)->F3_CLIEFOR==SD2->D2_CLIENTE) .And. ((cAliasSF3)->F3_LOJA==SD2->D2_LOJA)
				//
				SF4->(DbSetOrder (1))
				If (SF4->(MsSeek (xFilial ("SF4")+SD2->D2_TES)))
					If  (SF4->(FieldPos ("F4_ICMSDIF"))>0)
						lIcmsDif := Iif (SF4->F4_ICMSDIF=="1", .T., .F.)
					EndIf
					//
					If (SF4->F4_PODER3=="N") .Or. GetNewPar ("MV_P3CIAP", .F.)
						lSF3 := .T.
						Exit
					EndIf
				EndIf
				SD2->(DbSkip ())
			EndDo
		Else
			lSf3 := .T.
		EndIf
		//
		If (lSF3)
			cDataScan	:=	AllTrim (Str(year((cAliasSF3)->F3_ENTRADA)))+AllTrim (StrZero (Month ((cAliasSF3)->F3_ENTRADA), 2))
			//
			nPos	:=	aScan (aSf3, {|aQ4| AllTrim (aQ4[1])==cDataScan})
			//
			If (nPos==0)
				aAdd (aSf3, {cDataScan, 0, 0, 0})
				//
				nPos	:=	aScan (aSf3, {|aQ4| AllTrim (aQ4[1])==cDataScan})
				//
				aSf3[nPos][2] := (cAliasSF3)->F3_BASEICM+(cAliasSF3)->F3_ISENICM+(cAliasSF3)->F3_OUTRICM
				aSf3[nPos][3] := (cAliasSF3)->F3_BASEICM
				aSf3[nPos][4] := NoRound (aSf3[nPos][3]/aSf3[nPos][2],4)
			Else
				aSf3[nPos][2] += (cAliasSF3)->F3_BASEICM+(cAliasSF3)->F3_ISENICM+(cAliasSF3)->F3_OUTRICM
				aSf3[nPos][3] += (cAliasSF3)->F3_BASEICM
				aSf3[nPos][4] := NoRound (aSf3[nPos][3]/aSf3[nPos][2],4)
			EndIf
		EndIf
		(cAliasSF3)->(DbSkip ())
		IncRegua ()
	EndDo
	//
	#IFDEF TOP
		(cAliasSF3)->(DbCloseArea ())
	#ELSE
		RetIndex("SF3")
		(cAliasSF3)->(DbCloseArea ())
		Ferase (cIndSF3+OrdBagExt ())
	#ENDIF
Return (aSf3)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ImprimeTermo³Autor³ Sergio S. Fuzinaka    ³ Data ³17/05/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Imprime termos de abertura e encerramento dos livros fiscais³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImprimeTermo(nPagIni,nQuebra,cArqTerm,nLargMax,cPerg)

Local cSvAlias 	:= Alias()
Local cAcentos	:= "€ú\‡ú\ú\ú\…ú\†ú\„ú\ ú\ú\ˆú\Šú\‚ú\¡ú\“ú\”ú\•ú\¢ú\£ú"
Local cAcSubst 	:= "C,\c,\A~\A'\a`\a~\a~\a'\E'\e^\e`\e'\i'\o^\o~\o`\o'\U'"
Local aLayOut 	:= {}
Local aVariaveis:= {}
Local i			:= 0
Local w			:= 0
Local j			:= 0
Local cCaracter	:= ""
Local cLinha	:= ""
Local nPosAcento:= 0
Local cTexto	:= ""
Local cConteudo	:= ""
Local uConteudo

AADD(aVariaveis,{"VAR_IXB",VAR_IXB})
dbSelectArea("SM0")
For i:=1 to FCount()
	If FieldName(i)=="M0_CGC"
		AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
	ElseIf FieldName(i)=="M0_INSC"
		AADD(aVariaveis,{FieldName(i),InscrEst()})
	Else
		If FieldName(i)=="M0_NOME"
			Loop
		Endif
		AADD(aVariaveis,{FieldName(i),FieldGet(i)})
	Endif
Next

dbSelectArea("SX1")
dbSeek(cPerg+"01")
While SX1->X1_GRUPO==cPerg
	uConteudo	:=	&(X1_VAR01)
	If Valtype(uConteudo)=="N"
		cConteudo	:=	Alltrim(Str(uConteudo))
	Elseif Valtype(uConteudo)=="D"
		cConteudo	:=	Alltrim(dToc(uConteudo))
	Else
		cConteudo	:=	Alltrim(uConteudo)
	Endif
	AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),cConteudo})
	dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclusao de variaveis especificas                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aVariaveis,{"M_DIA",StrZero(Day(dDataBase),2)})
AADD(aVariaveis,{"M_MES",MesExtenso()})
AADD(aVariaveis,{"M_ANO",StrZero(Year(dDataBase),4)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena os arrays colocando primeiro a variavel de tamanho    ³
//³ maior para que a rotina nao pegue uma variavel menor         ³
//³ primeiro ( exemplo M0_TEL e M0_TEL_IMP )                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ASort( aVariaveis,,, { |x,y| Len( x[1] ) > Len( y[1] ) } ) 

cTexto:=MemoRead(cArqTerm)
For w:=1 to len(aVariaveis)
	cTexto	:=	StrTran(cTexto,aVariaveis[w,1],if(valtype(aVariaveis[w,2])<>"C" .and. valtype(aVariaveis[w,2])<>"U",if(valtype(avariaveis[w,2])="D",dtoc(aVariaveis[w,2]),str(aVariaveis[w,2])),aVariaveis[w,2]))
Next
@ 0,0 PSAY AvalImp(nLargMax)

For i:=1 to Mlcount(cTexto,nLargMax)
	SysRefresh()
	cLinha	:=	MemoLine(cTexto,nLargMax,i)
	cLinha	:=	Strtran(cLinha,chr(13)+chr(10))
	For j:=1 to Len(cLinha)
		cCaracter	:=	Substr(cLinha,j,1)
		nPosAcento	:=	Rat(cAcentos,cCaracter)
		If nPosAcento>0
			cCaracter:=Substr(AcSubst,nPosAcento,2)
			@ i,j PSAY Substr(cCaracter,1,1)
			@ i,j PSAY Substr(cCaracter,2,1)
		Else
			@ i,j PSAY cCaracter
		Endif
	Next j
Next i

dbSelectArea(cSvAlias)

Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³R995RjA   ³ Autor ³Gustavo G. Rueda       ³ Data ³24/11/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do livro CIAP do estado do Rio de Janeiro para    ³±±
±±³          ³  bens cuja entradaseja posteior ao dia 1 de agosto de 2000.³±±
±±³          ³Caso a data nao seja posteior ao mencionado acima, sera     ³±±
±±³          ³  assumido o layout modelo A                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|lEnd -> Flag de cancelamento de impressao.                  ³±±
±±³          |wnRel ->                                                    ³±±
±±³          |cString -> Tabela default aberta.                           ³±±
±±³          |Tamanho -> Tamanho do relatorio.                            ³±±
±±³          |nPagIni -> Numero da pagina incial conforme perguntas.      ³±±
±±³          |cEstado -> Conteudo do paramentro MV_ESTADO.                ³±±
±±³          |                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R995RjA (lEnd, wnRel, cString, Tamanho, nPagIni, cEstado)
	Local 	aLay   		:= 	Array (42)
	Local 	nLin   		:= 	99
	Local	nFolha		:=	nPagIni
	Local	aDados		:=	{}
	Local	dSaiBx		:=	CToD ("  /  /  ")
	Local	cSaiBx		:=	""
	Local	cData		:=	""
	Local	aStru		:=	{}
	Local	cArq		:=	""
	Local	nParc		:=	0
	Local	lFirst		:=	.F.
	Local	nAno		:=	0
	Local	nMes		:=	0
	Local	cAlias		:=	""
	Local	cQuery		:=	""
	Local	nIndex		:=	0
	Local	cChave		:=	""
	Local	cInd		:=	""
	Local	cFil		:=	""	
	Local	nTotal2		:=	0
	Local	nTotal3		:=	0
	Local	nTotal4		:=	0
	Local	nTotal5		:=	0
	Local	nTotal6		:=	0
	Local	nPos		:=	0
	Local	aSaidPrest	:=	R995Procf3 ()
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Formato do array aSaidPrest:     ³
	³1 = Ano+Mes = Ex: "200301"       ³
	³2 = Totais Saidas/Prestacoes     ³
	³3 = Tributadas Saidas/Prestacoes ³
	³4 = %Saidas/Prestacoes Tributadas³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	#IFDEF TOP
		Local	nX			:=	0
	#ENDIF
	//
	R995LayOut (@aLay, cEstado)
	//
	aAdd (aStru, {"TRB_COD",	"C",	006,	0})
	aAdd (aStru, {"TRB_DESC",	"C",	050,	0})
	aAdd (aStru, {"TRB_PARC",	"C",	010,	0})
	aAdd (aStru, {"TRB_BASE",	"N",	016,	2})
	aAdd (aStru, {"TRB_DATA",	"D",	008,	0})
	//
	cArq	  :=	CriaTrab (aStru)
	DbUseArea (.T., __LocalDriver, cArq, "TRB")
	IndRegua ("TRB", cArq, "DTOS(TRB_DATA)+TRB_COD+TRB_PARC")
	//
	DbSelectArea ("SF9")
	SF9->(DbSetOrder (1))
	#IFDEF TOP
		cAlias	:= 	"AliasSF9"
		aStru	:= 	SF9->(DbStruct ())
		cQuery	:= 	"SELECT * "
		cQuery	+= 	"FROM "+RetSqlName ("SF9")+" SF9 "
		cQuery	+= 	"WHERE SF9.F9_FILIAL='"+xFilial("SF9")+"' AND "
		cQuery	+= 	"SF9.F9_CODIGO>='"+MV_PAR01+"' AND "
		cQuery	+= 	"SF9.F9_CODIGO<='"+MV_PAR02+"' AND "
		cQuery	+= 	"SF9.F9_DTENTNE>='"+DToS (MV_PAR08)+"' AND "
		cQuery	+= 	"SF9.F9_DTENTNE<='"+DToS (MV_PAR09)+"' AND "
		cQuery	+= 	"SF9.D_E_L_E_T_=' ' "
		cQuery	+=	"ORDER BY "+SqlOrder (SF9->(IndexKey ()))
		//
		cQuery    := ChangeQuery (cQuery)
		//
		DbUseArea (.T., "TOPCONN", TcGenQry (,, cQuery), cAlias, .T., .T.)
		//
		For nX := 1 To Len (aStru)
			If (aStru[nX][2]<>"C")
				TcSetField (cAlias, aStru[nX][1], aStru[nX][2], aStru[nX][3], aStru[nX][4])
			EndIf
		Next nX
	#ELSE
		cAlias	:= 	"SF9"
		cInd  	:= 	CriaTrab (NIL,.F.)
		cChave 	:= 	IndexKey ()
		cFil  	:= 	"F9_FILIAL=='"+xFilial ("SF9")+"' .And. F9_CODIGO>='"+MV_PAR01+"' .And. F9_CODIGO<='"+MV_PAR02+"'"
		cFil   	+= 	" .And. Dtos(F9_DTENTNE)>='"+DToS (MV_PAR08)+"' .And. Dtos(F9_DTENTNE)<='"+DToS (MV_PAR09)+"' "
		//
		IndRegua (cAlias, cInd, cChave,, cFil)
		nIndex := RetIndex ("SF9")
		DbSelectArea ("SF9")
		DbSetIndex (cInd+OrdBagExt ())
		DbSetOrder (nIndex+1)
	#ENDIF
	//
	SetRegua (SF9->(LastRec ()))
	(cAlias)->(DbGoTop ())
	//
	Do While !(cAlias)->(Eof ())
		//
		If (Interrupcao (@lEnd))
			Exit
		EndIf
		//
		If (nLin>50)
			If (lFirst)
				FmtLin (, aLay[19],,, @nLin)
			EndIf
			lFirst	:=	.T.
			//
			nLin	:=	0
			@ nLin,000 PSAY aValImp(Limite)
			nLin++
			FmtLin (, aLay[01],,, @nLin)
			FmtLin (, aLay[02],,, @nLin)
			FmtLin (, aLay[03],,, @nLin)			
			aDados	:=	{StrZero (Year (MV_PAR08), 4), StrZero (nFolha, 4)}
			FmtLin (aDados, aLay[04],,, @nLin)
			FmtLin(,aLay[05],,,@nLin)
			nLin++
			FmtLin(,aLay[06],,,@nLin)
			FmtLin(,aLay[07],,,@nLin)
			FmtLin(,aLay[08],,,@nLin)
			aDados	:=	{SM0->M0_NOMECOM, Transform (SM0->M0_CGC, "@R 99.999.999/9999-99"), SM0->M0_INSC}
			FmtLin (aDados, aLay[09],,, @nLin)
			aDados	:=	{SM0->M0_ENDENT, SM0->M0_BAIRENT, SM0->M0_CIDENT}
			FmtLin (aDados, aLay[10],,, @nLin)
			FmtLin(,aLay[11],,,@nLin)
			nLin++		
			FmtLin(,aLay[12],,,@nLin)
			FmtLin(,aLay[13],,,@nLin)
			FmtLin(,aLay[14],,,@nLin)
			FmtLin(,aLay[15],,,@nLin)
			FmtLin(,aLay[16],,,@nLin)
			FmtLin(,aLay[17],,,@nLin)
			//
			nFolha++
		EndIf
		//		
		DbSelectArea ("SFA")
			SFA->(DbSetOrder (1))
		SFA->(DbSeek (xFilial ("SFA")+(cAlias)->F9_CODIGO))
		//
		dSaiBx	:=	CToD ("  /  /  ")
		nParc	:=	1
		Do While !SFA->(Eof ()) .And. SFA->FA_CODIGO=(cAlias)->F9_CODIGO
			//
			If ("2"$SFA->FA_TIPO)
				dSaiBx	:=	SFA->FA_DATA
				Exit
			EndIf
			//
			RecLock ("TRB", .T.)
				TRB->TRB_COD	:=	(cAlias)->F9_CODIGO
				TRB->TRB_DESC	:=	Substr((cAlias)->F9_DESCRI,1,36)
				TRB->TRB_PARC	:=	StrZero (nParc++, 10)
				TRB->TRB_BASE	:=	SFA->FA_VALOR
				TRB->TRB_DATA	:=	SFA->FA_DATA
			TRB->(MsUnLock ())
			//
			SFA->(DbSkip ())
		EndDo
		//
		cData	:=	StrZero (Day ((cAlias)->F9_DTENTNE), 2)+"/"+StrZero (Month ((cAlias)->F9_DTENTNE), 2)+"/"+StrZero (Year ((cAlias)->F9_DTENTNE), 4)
		cSaiBx	:=	StrZero (Day (dSaiBx), 2)+"/"+StrZero (Month (dSaiBx), 2)+"/"+StrZero (Year (dSaiBx), 4)
		cSaiBx	:=	Iif ("/00/"$cSaiBx, "", cSaiBx)		
		aDados	:=	{(cAlias)->F9_CODIGO,;
					cData,;
					(cAlias)->F9_DOCNFE+"/"+(cAlias)->F9_SERNFE,;
					Left ((cAlias)->F9_DESCRI, 36),;
					StrZero ((cAlias)->F9_NLRE, 3)+"/"+StrZero ((cAlias)->F9_FLRE, 3),;
					Transform ((cAlias)->F9_VALICMS, "@E 9,999,999,999.99"),;
					cSaiBx}
		//
		FmtLin (aDados, aLay[18],,, @nLin)	
		//
		(cAlias)->(DbSkip ())
		IncRegua()
	EndDo
	//
	If (lFirst)
		FmtLin (, aLay[19],,, @nLin)
		nLin++
	EndIf
	//
	nLin	:=	99
	lFirst	:=	.F.
	TRB->(DbGoTop ())
	//
	Do While !TRB->(Eof ())
		If !(Month (TRB->TRB_DATA)==nMes .And. Year (TRB->TRB_DATA)==nAno)
			If (lFirst) .And. (nLin<60)
				nPos	:=	aScan (aSaidPrest, {|aX| aX[1]==StrZero (nAno, 4)+StrZero (nMes, 2)})
				//
				FmtLin (, aLay[36],,, @nLin)
				aDados	:=	{Transform (nTotal2,"@E 999,999,999,999.99")}
				FmtLin (aDados, aLay[37],,, @nLin)
				//
				nTotal3	:=	Iif (nPos==0, 0, aSaidPrest[nPos][3])
				aDados	:=	{Transform (nTotal3,"@E 999,999,999,999.99")}
				FmtLin (aDados, aLay[38],,, @nLin)
				//
				nTotal4	:=	Iif (nPos==0, 0, aSaidPrest[nPos][2])
				aDados	:=	{Transform (nTotal4,"@E 999,999,999,999.99")}
				FmtLin (aDados, aLay[39],,, @nLin)
				//
				nTotal5	:=	nTotal3/nTotal4
				aDados	:=	{Transform (nTotal5,"@E 999,999,999,999.99")}
				FmtLin (aDados, aLay[40],,, @nLin)
				//
				nTotal6	:=	nTotal2*nTotal5
				aDados	:=	{Transform (nTotal6,"@E 999,999,999,999.99")}
				FmtLin (aDados, aLay[41],,, @nLin)
				FmtLin (aDados, aLay[42],,, @nLin)
				//
				nTotal2	:=	0
				nTotal3	:=	0
				nTotal4	:=	0
				nTotal5	:=	0
				nTotal6	:=	0
			ElseIf (lFirst)
				nLin	:=	0
				@ nLin,000 PSAY aValImp(Limite)
				nLin++
				//
				nPos	:=	aScan (aSaidPrest, {|aX| aX[1]==StrZero (nAno, 4)+StrZero (nMes, 2)})
				//
				FmtLin (, aLay[36],,, @nLin)
				aDados	:=	{Transform (nTotal2,"@E 999,999,999,999.99")}
				FmtLin (aDados, aLay[37],,, @nLin)
				//
				nTotal3	:=	Iif (nPos==0, 0, aSaidPrest[nPos][3])
				aDados	:=	{Transform (nTotal3,"@E 999,999,999,999.99")}
				FmtLin (aDados, aLay[38],,, @nLin)
				//
				nTotal4	:=	Iif (nPos==0, 0, aSaidPrest[nPos][2])
				aDados	:=	{Transform (nTotal4,"@E 999,999,999,999.99")}
				FmtLin (aDados, aLay[39],,, @nLin)
				//
				nTotal5	:=	nTotal3/nTotal4
				aDados	:=	{Transform (nTotal5,"@E 999,999,999,999.99")}
				FmtLin (aDados, aLay[40],,, @nLin)
				//
				nTotal6	:=	nTotal2*nTotal5
				aDados	:=	{Transform (nTotal6,"@E 999,999,999,999.99")}
				FmtLin (aDados, aLay[41],,, @nLin)
				FmtLin (aDados, aLay[42],,, @nLin)
				//
				nTotal2	:=	0
				nTotal3	:=	0
				nTotal4	:=	0
				nTotal5	:=	0
				nTotal6	:=	0
			EndIf
			//
			nMes	:=	Month (TRB->TRB_DATA)
			nAno	:=	Year (TRB->TRB_DATA)
			//
			nLin	:=	0
			@ nLin,000 PSAY aValImp(Limite)
			nLin++
			//
			lFirst	:=	.T.
			//
			FmtLin (, aLay[20],,, @nLin)
			FmtLin (, aLay[21],,, @nLin)
			FmtLin (, aLay[22],,, @nLin)
			aDados	:=	{StrZero (nMes, 2)+"/"+StrZero (nAno, 4), StrZero (nFolha, 4)}
			FmtLin (aDados, aLay[23],,, @nLin)
			FmtLin (, aLay[24],,, @nLin)
			nLin++
			FmtLin (, aLay[25],,, @nLin)
			FmtLin (, aLay[26],,, @nLin)
			FmtLin (, aLay[27],,, @nLin)
			aDados	:=	{SM0->M0_NOMECOM, Transform (SM0->M0_CGC, "@R 99.999.999/9999-99"), SM0->M0_INSC}
			FmtLin (aDados, aLay[28],,, @nLin)
			aDados	:=	{SM0->M0_ENDENT, SM0->M0_BAIRENT, SM0->M0_CIDENT}
			FmtLin (aDados, aLay[29],,, @nLin)
			FmtLin (, aLay[30],,, @nLin)
			nLin++
			FmtLin (, aLay[31],,, @nLin)
			FmtLin (, aLay[32],,, @nLin)
			FmtLin (, aLay[33],,, @nLin)
			FmtLin (, aLay[34],,, @nLin)
			nFolha++
		EndIf
		//
		If (nLin>50)
			FmtLin (, aLay[36],,, @nLin)
			nLin	:=	0
			@ nLin,000 PSAY aValImp(Limite)
			nLin++
			FmtLin (, aLay[31],,, @nLin)
			FmtLin (, aLay[32],,, @nLin)
			FmtLin (, aLay[33],,, @nLin)
			FmtLin (, aLay[34],,, @nLin)
		EndIf
		//
		aDados	:=	{TRB->TRB_COD+" - "+TRB->TRB_DESC, TRB->TRB_PARC, Transform (TRB->TRB_BASE, "@E 999,999,999,999.99")}
		FmtLin (aDados, aLay[35],,, @nLin)
		//
		nTotal2	+=	TRB->TRB_BASE
		//
		TRB->(DbSkip ())
	EndDo
	If (lFirst)
		nPos	:=	aScan (aSaidPrest, {|aX| aX[1]==StrZero (nAno, 4)+StrZero (nMes, 2)})
		//
		FmtLin (, aLay[36],,, @nLin)
		aDados	:=	{Transform (nTotal2,"@E 999,999,999,999.99")}
		FmtLin (aDados, aLay[37],,, @nLin)
		//
		nTotal3	:=	Iif (nPos==0, 0, aSaidPrest[nPos][3])
		aDados	:=	{Transform (nTotal3,"@E 999,999,999,999.99")}
		FmtLin (aDados, aLay[38],,, @nLin)
		//
		nTotal4	:=	Iif (nPos==0, 0, aSaidPrest[nPos][2])
		aDados	:=	{Transform (nTotal4,"@E 999,999,999,999.99")}
		FmtLin (aDados, aLay[39],,, @nLin)
		//
		nTotal5	:=	nTotal3/nTotal4
		aDados	:=	{Transform (nTotal5,"@E 999,999,999,999.99")}
		FmtLin (aDados, aLay[40],,, @nLin)
		//
		nTotal6	:=	nTotal2*nTotal5
		aDados	:=	{Transform (nTotal6,"@E 999,999,999,999.99")}
		FmtLin (aDados, aLay[41],,, @nLin)
		FmtLin (aDados, aLay[42],,, @nLin)
	EndIf
	//
	#IFDEF TOP
		(cAlias)->(DbCloseArea ())
	#ELSE
		RetIndex("SF9")
		(cAlias)->(DbCloseArea ())
		Ferase (cInd+OrdBagExt ())
	#ENDIF
	//
	DbSelectArea ("TRB")
	TRB->(DbCloseArea ())
	Ferase (cArq+GetDBExtension())
	Ferase (cArq+OrdBagExt())
Return

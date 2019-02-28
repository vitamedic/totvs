#Include "VIT133.CH"
#DEFINE REC_NAO_CONCILIADO 1                                 
#DEFINE REC_CONCILIADO		2
#DEFINE PAG_NAO_CONCILIADO 3
#DEFINE PAG_CONCILIADO		4

//#include "FiveWin.ch"  Tirei para compilar pois não veio


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	   ³ FINR470	³ Autor ³ Wagner Xavier   ³ Data ³ 20.10.92       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Extrato Bancario  											    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/




USER Function VIT133()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1 := STR0001  //"Este programa ir  emitir o relat¢rio de movimenta‡”es"
LOCAL cDesc2 := STR0002  //"banc rias em ordem de data. Poder  ser utilizado para"
LOCAL cDesc3 := STR0003  //"conferencia de extrato."
LOCAL cString:="SE5"
LOCAL Tamanho:="M"

PRIVATE titulo:=OemToAnsi(STR0004)  //"Extrato Bancario"
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="VIT133"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg	 :="PERGVIT133"
_pergsx1()
pergunte(cperg,.f.)




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//pergunte("FIN470",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								 ³
//³ mv_par01				// Banco 										 ³
//³ mv_par02				// Agencia										 ³
//³ mv_par03				// Conta 										 ³
//³ mv_par04				// a partir de 								 ³
//³ mv_par05				// ate											 ³
//³ mv_par06				// Qual Moeda									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT 							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "VIT133"+Alltrim(cusername)            //Nome Default do relatorio em Disco
WnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho,"")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao REPORTINI substituir as variaveis.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa470Imp(@lEnd,wnRel,cString)},titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA470IMP ³ Autor ³ Wagner Xavier 		  ³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Banc rio. 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA470Imp(lEnd,wnRel,cString)
LOCAL CbCont,CbTxt
LOCAL tamanho:="M"
LOCAL cBanco,cNomeBanco,cAgencia,cConta,nRec,cLimCred
LOCAL limite := 132
LOCAL nSaldoAtu:=0,nTipo,nEntradas:=0,nSaidas:=0,nSaldoIni:=0
LOCAL cDOC
LOCAL cFil	  :=""
LOCAL nOrdSE5 :=SE5->(IndexOrd())
LOCAL cChave
LOCAL cIndex
LOCAL aRecon := {}
Local nTxMoeda := 1
Local nValor := 0
Local aStru 	:= SE5->(dbStruct()), ni
Local nMoeda	:= GetMv("MV_CENT"+(IIF(mv_par06 > 1 , STR(mv_par06,1),"")))
Local nMoedaBco:=	1
LOCAL nSalIniStr := 0
LOCAL nSalIniCip := 0
LOCAL nSalIniComp := 0
LOCAL nSalStr := 0
LOCAL nSalCip := 0    
LOCAL nSalComp := 0
LOCAL lSpbInUse := SpbInUse()
LOCAL aStruct := {}
Local cFilterUser 

AAdd( aRecon, {0,0,0,0} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCondWhile, lAllFil :=.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

dbSelectArea("SA6")
dbSetOrder(1)
IF !(dbSeek(cFilial+mv_par01+mv_par02+mv_par03))
	Help(" ",1,"BCONAOEXIST")
	Return
EndIF

cBanco		:= A6_COD
cNomeBanco	:= A6_NREDUZ
cAgencia		:= A6_AGENCIA
cConta		:= A6_NUMCON
nLimCred		:= VAL(A6_TELEX) //LIMCRED
cContato    := A6_CONTATO
cTel		   := A6_TEL 
naoconc		:=0
If cPaisLoc	#	"BRA"
	nMoedaBco	:=	Max(A6_MOEDA,1)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi(STR0007)+DTOC(mv_par04) + " e " +Dtoc(mv_par05)  //"EXTRATO BANCARIO ENTRE "
cabec1 := OemToAnsi(STR0008)+ cBanco +" - " + ALLTRIM(cNomeBanco) + OemToAnsi(STR0009)+ cAgencia + OemToAnsi(STR0010)+ cConta   + "  FONE: "+cTel + "  CONTATO: "+cContato  //"BANCO "###"   AGENCIA "###"   CONTA "
cabec2 := OemToAnsi(STR0011)  //"DATA     OPERACAO                          DOCUMENTO         PREFIXO/TITULO          ENTRADAS           SAIDAS         SALDO ATUAL"
nTipo  :=IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Saldo de Partida 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SE8")
dbSetOrder(1)
dbSeek( cFilial+cBanco+cAgencia+cConta+Dtos(mv_par04),.T.)
dbSkip(-1)

IF E8_BANCO!=cBanco .or. E8_AGENCIA!=cAgencia .or. E8_CONTA!=cConta .or. BOF() .or. EOF()
	nSaldoAtu:=0
//	nSaldoIni:=0
Else
	nSaldoAtu:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
//	nSaldoIni:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
Endif

dbSelectArea("SE8")
dbSetOrder(1)
dbSeek( cFilial+cBanco+cAgencia+cConta+Dtos(mv_par05),.T.)
dbSkip(-1)
_dataant := E8_DTSALAT
IF E8_BANCO!=cBanco .or. E8_AGENCIA!=cAgencia .or. E8_CONTA!=cConta .or. BOF() .or. EOF()
//	nSaldoAtu:=0
	nSaldoIni:=0
Else
//	nSaldoAtu:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
	nSaldoIni:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT,nMoeda+1),nMoeda)
Endif



If lSpbInUse
	nSalIniStr := 0
	nSalIniCip := 0
	nSalIniComp := 0
Endif		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra o arquivo por tipo e vencimento							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(xFilial( "SA6")) .and. !Empty(xFilial("SE5"))
	cChave	:= "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
	lAllFil:= .T.
Else
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
EndIf

#IFNDEF TOP	
	dbSelectArea("SE5")
	dbSetOrder(1)
	cIndex	:= CriaTrab(nil,.f.)
	dbSelectArea("SE5")
	IndRegua("SE5",cIndex,cChave,,Nil,OemToAnsi(STR0012))  //"Selecionando Registros..."
	nIndex	:= RetIndex("SE5")
	dbSetIndex(cIndex+OrdBagExt())
	dbSetOrder(nIndex+1)
	cFil:= Iif(lAllFil,"",xFilial("SE5"))
	dbSeek(cFil+DtoS(mv_par04),.T.)
#ELSE
	If TcSrvType() == "AS/400"
		dbSelectArea("SE5")
		dbSetOrder(1)
		cIndex	:= CriaTrab(nil,.f.)
		dbSelectArea("SE5")
		IndRegua("SE5",cIndex,cChave,,Nil,OemToAnsi(STR0012))  //"Selecionando Registros..."
		nIndex	:= RetIndex("SE5")
		dbSetOrder(nIndex+1)
		cFil:= Iif(lAllFil,"",xFilial("SE5"))
		dbSeek(cFil+DtoS(mv_par04),.T.)
	EndIf	
#ENDIF

SetRegua(RecCount())

#IFNDEF TOP
	If  lAllFil
		cCondWhile := "!Eof() .And. E5_DTDISPO <= mv_par05"
	Else
		cCondWhile := "!Eof() .And. E5_FILIAL == xFilial('SE5') .And. E5_DTDISPO <= mv_par05"
	EndIf
#ELSE
	If TcSrvType() != "AS/400"
		DbSelectArea("SE5")
		DbSetOrder(1)
		cCondWhile := " !Eof() "
		If	lAllFil
			cChave  := "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
		Else
			cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
		EndIf
		cOrder := SqlOrder(cChave)
		cQuery := "SELECT * "
		cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
		If !lAllFil
			cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
		EndIf	
		cQuery += " D_E_L_E_T_ <> '*' "
		cQuery += " AND E5_DTDISPO >=  '"     + DTOS(mv_par04) + "'"
		If lSpbInuse
			cQuery += " AND ((E5_DTDISPO <=  '"+ DTOS(mv_par05) + "') OR "
			cQuery += " (E5_DTDISPO >=  '"     + DTOS(mv_par05) + "' AND "
		   cQuery += " (E5_DATA >=  '"  		  + DTOS(mv_par04) + "' AND " 
			cQuery += "  E5_DATA <=  '"     	  + DTOS(mv_par05) + "')))"			
		Else			
			cQuery += " AND E5_DTDISPO <=  '"     + DTOS(mv_par05) + "'"
		Endif
		cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','BA') "
		cQuery += " AND E5_BANCO = '"   + cBanco   + "'"
		cQuery += " AND E5_AGENCIA = '" + cAgencia + "'"
		cQuery += " AND E5_CONTA = '"   + cConta   + "'"
		cQuery += " AND E5_SITUACA <> 'C' "
		cQuery += " AND E5_VALOR <> 0 "
		cQuery += " AND E5_NUMCHEQ NOT LIKE '%*' "
		cQuery += " AND E5_VENCTO <= '" + DTOS(mv_par05)  + "'" 
		cQuery += " AND E5_VENCTO <= E5_DATA " 
		If mv_par07 == 2
			cQuery += " AND E5_RECONC <> ' ' "
		ElseIf mv_par07 == 3
			cQuery += " AND E5_RECONC = ' ' " 
		EndIf

		cQuery += " ORDER BY " + cOrder
	
		cQuery := ChangeQuery(cQuery)

		dbSelectAre("SE5")
		dbCloseArea()

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .T., .T.)
	
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	Else		// Se TOP-AS400
		If lAllFil
			cCondWhile := "!Eof() .And. E5_DTDISPO <= mv_par05"
		Else
			cCondWhile := "!Eof() .And. E5_FILIAL == xFilial('SE5') .And. E5_DTDISPO <= mv_par05"
		EndIf
	EndIf
#ENDIF

// Monta arquivo de trabalho (apenas quando usa SPB)
If lSpbInUse
	dbSelectArea("SE5")
	aStruct := SE5->(dbStruct())
	cNomeArq:= CriaTrab("",.F.)
	cIndex  := cNomeArq
	AAdd( aStruct, {"E5_BLOQ"	,"C", 01, 0} )
	dbCreate( cNomeArq, aStruct )
	USE &cNomeArq	Alias Trb  NEW
	dbSelectArea("TRB")
	IndRegua("TRB",cIndex,cChave,,,STR0012) //"Selecionando Registros..."
	dbSetIndex( cNomeArq +OrdBagExt())
	Fr470SPB(cChave, aStruct)
Endif

// Filtro do Usuario
cFilterUser := aReturn[7]

While &(cCondWhile)

	IF lEnd
		@PROW()+1,0 PSAY OemToAnsi(STR0013)  //"Cancelado pelo operador"
		EXIT
	Endif
	
	IncRegua()
	
	#IFNDEF TOP
		If !Fr470Skip(cBanco,cAgencia,cConta)
			dbSkip()
			Loop
		EndIf	
	#ELSE
		If TcSrvType() == "AS/400"
			If !Fr470Skip(cBanco,cAgencia,cConta)
				dbSkip()
				Loop
			EndIf	
		EndIf
	#ENDIF		

	IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Na transferencia somente considera nestes numerarios 		  ³
	//³ No Fina100 ‚ tratado desta forma.                    		  ³
	//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
	//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
   //³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
   //³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
   //³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
      If !(E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
			dbSkip()
			Loop
		Endif
	Endif
	If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
		.or. Substr(E5_DOCUMEN,1,1) == "*" )
		dbSkip()
		Loop
	Endif

	If E5_MOEDA == "CH" .and. IsCaixaLoja(E5_BANCO)		// Sangria
		dbSkip()
		Loop
	Endif

	If !Empty( E5_MOTBX )
		If !MovBcoBx( E5_MOTBX )
			dbSkip( )
			Loop
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif

	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
//		@li ++,113 PSAY nSaldoAtu   Picture tm(nSaldoAtu,16,nMoeda)
	EndIF
	
	If lSpbInUse	
		dbSelectArea("TRB")
	Else
		dbSelectArea("SE5")
	Endif
	If E5_RECONC <> "x" 
	@li, 0 PSAY E5_DTDISPO
	@li,12 PSAY SUBSTR(E5_HISTOR,1,30)
	Endif
	cDoc := E5_NUMCHEQ
	
	IF Empty( cDoc )
		cDoc := E5_DOCUMEN
	Endif
	
	IF Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) <= 19
		cDoc := Alltrim(E5_DOCUMEN) +if(!empty(Alltrim(E5_DOCUMEN)),"-"," ") + Alltrim(E5_NUMCHEQ )
	Endif
	
	If Substr( cDoc ,1, 1 ) == "*"
		dbSkip( )
		Loop
	Endif
	If E5_RECONC <> "x" 
	@li,043 PSAY IIF(AllTrim(cDoc) == ""," ",AllTrim(cDoc))	
	@li,061 PSAY E5_PREFIXO+IIF(EMPTY(E5_PREFIXO)," ","-")+E5_NUMERO+;
									 IIF(EMPTY(E5_PARCELA)," ","-")+E5_PARCELA
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³VerIfica se foi utilizada taxa contratada para moeda > 1          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par06 > 1 .and. !Empty(E5_VLMOED2)
		If  E5_VALOR != E5_VLMOED2
			IF Round(xMoeda(E5_VALOR,nMoedaBco,mv_par06,E5_DTDISPO,nMoeda+1),nMoeda) != E5_VLMOED2
				nTxMoeda := (E5_VALOR * RecMoeda(E5_DTDISPO,nMoedaBco)) / E5_VLMOED2
			Else
				nTxMoeda := RecMoeda(E5_DTDISPO,mv_par06)
			EndIf
			nTxMoeda :=if(nTxMoeda=0,1,nTxMoeda)
			nValor := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par06,,nMoeda+1,,nTxMoeda),nMoeda)
		Else
			nValor := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par06,E5_DTDISPO,nMoeda+1),nMoeda)
		EndIf
	Else
		nValor := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par06,E5_DTDISPO,nMoeda+1),nMoeda)
	Endif

	IF E5_RECPAG="R"
		If E5_RECONC <> "x" 
		@li,78 PSAY  nValor	Picture tm(nValor,15,nMoeda)
		Endif
		nSaldoAtu += nValor
		If Empty( E5_RECONC )
			aRecon[1][REC_NAO_CONCILIADO] += nValor
		Else
			aRecon[1][REC_CONCILIADO] += nValor
		EndIf
		If lSpbInUse
			//Adiantamentos sao sempre STR
			If E5_TIPO $ MVRECANT
					nSalSTR += nValor
			Else
				// Saldo STR ou transformados em STR
  				If E5_MODSPB $ " 1" .or. (E5_MODSPB $ "2/3" .AND. Empty(E5_BLOQ))
					nSalSTR += nValor
  				ElseIf E5_MODSPB == "2" //CIP
					nSalCIP += nValor
  				ElseIf E5_MODSPB == "3" //COMP
					nSalCOMP += nValor
			   Endif
			Endif
		Endif	
	Else    
		If E5_RECONC <> "x" 
		@li,94 PSAY nValor  Picture tm(nValor,15,nMoeda)
	
      Endif
		nSaldoAtu -= nValor
		If Empty( E5_RECONC )
			aRecon[1][PAG_NAO_CONCILIADO] += nValor
			If (E5_DATA== mv_par05) .or. (E5_DATA == _dataant)
				naoconc+=nValor
			Endif	
		Else
			aRecon[1][PAG_CONCILIADO] += nValor
		EndIf
		If lSpbInUse
			//Adiantamentos sao sempre STR
			If E5_TIPO $ MVPAGANT
				nSalSTR -= nValor
			Else
				// Saldo STR ou transformados em STR
  				If E5_MODSPB $ " 1" .or. (E5_MODSPB $ "2/3" .AND. Empty(E5_BLOQ))
					nSalSTR -= nValor
  				ElseIf E5_MODSPB == "2" //CIP
					nSalCIP -= nValor
  				ElseIf E5_MODSPB == "3" //COMP
					nSalCOMP -= nValor
			   Endif
			Endif
		Endif	
	Endif  
	If E5_RECONC <> "x" 
//	@li,113 PSAY nSaldoAtu Picture tm(nSaldoAtu,16,nMoeda)
	Endif
   If lSpbInUse
		If (E5_MODSPB $ "2/3" .AND. !Empty(E5_BLOQ))
			If E5_RECONC <> "x" 
			@li,pCol() + 1 PSAY E5_BLOQ
			Endif
		Endif	
	Endif                     
	If E5_RECONC <> "x" 
   @li++,pCol()PSAY Iif(Empty(E5_RECONC), " ", "x")
   Endif
	If Len(Alltrim(E5_HISTOR)) > 30
		If E5_RECONC <> "x" 
		@li ++,12 PSAY SUBSTR(E5_HISTOR,31,30)
		Endif
	Endif
	If lSpbInUse	
		dbSelectArea("TRB")
	Else
		dbSelectArea("SE5")
	Endif
	dbSkip()
EndDO

If li > 55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif

li+=2
@li,048 PSAY OemToAnsi(STR0014)  //"SALDO INICIAL VITAPAN...: "
@li,113 PSAY nSaldoIni	Picture tm(nSaldoIni,16,nMoeda)
li+=1
@li,048 PSAY  "SALDO INICIAL BANCO.....: "
@li,113 PSAY nSaldoIni+mv_par08 picture tm(nSaldoIni,16,nMoeda)


li+=2
If li > 55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li,078 PSAY OemToAnsi(STR0015)  //"NAO CONCILIADOS"
@li,098 PSAY OemToAnsi(STR0016)  //"    CONCILIADOS"
@li,124 PSAY OemToAnsi(STR0017)  //"          TOTAL"

li++
@li,048 PSAY OemToAnsi(STR0018)  //"ENTRADAS NO PERIODO.....: "
@li,078 PSAY aRecon[1][REC_NAO_CONCILIADO] PicTure tm(aRecon[1][1],15,nMoeda)
@li,094 PSAY aRecon[1][REC_CONCILIADO] PicTure tm(aRecon[1][2],15,nMoeda)
@li,113 PSAY aRecon[1][REC_CONCILIADO] + aRecon[1][REC_NAO_CONCILIADO] PicTure tm((aRecon[1][1]+aRecon[1][2]),16,nMoeda)

li++
If li > 55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li,048 PSAY OemToAnsi(STR0019)  //"SAIDAS NO PERIODO ......: "
@li,078 PSAY aRecon[1][PAG_NAO_CONCILIADO] PicTure tm(aRecon[1][3],15,nMoeda)
@li,094 PSAY aRecon[1][PAG_CONCILIADO] PicTure tm(aRecon[1][4],15,nMoeda)
@li,113 PSAY aRecon[1][PAG_CONCILIADO] + aRecon[1][PAG_NAO_CONCILIADO] PicTure tm((aRecon[1][3]+aRecon[1][4]),16,nMoeda)

If lSpbInUse

	nSalStr += nSaldoAtu - (nSalStr+nSalCIP+nSalCOMP)
	li+=2
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	@li, 48 PSAY STR0022 //"SALDO DISPONIVEL........: "
	@li,113 PSAY nSalSTR	Picture tm(nSalSTR,16,nMoeda)
	
	li++
	@li, 48 PSAY STR0023 //"SALDO BLOQUEADO CIP (2).: "
	@li,113 PSAY nSalCIP	Picture tm(nSalCIP,16,nMoeda)
	
	li++
	@li, 48 PSAY STR0024 //"SALDO BLOQUEADO COMP (3):"
	@li,113 PSAY nSalCOMP	Picture tm(nSalCOMP,16,nMoeda)
Endif

li++
If li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li, 48 PSAY OemToAnsi(STR0021)  //"LIMITE DE CREDITO ......: "
@li,113 PSAY nLimCred Picture tm(nLimCred,16,nMoeda)

li+=2
//nSaldoAtu += nLimCred
If li > 54
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
@li, 48 PSAY OemToAnsi(STR0020)  //"SALDO ATUAL ............: "
@li,113 PSAY nSaldoAtu	Picture tm(nSaldoAtu,16,nMoeda)
li+=2
@li, 48 PSAY "SALDO ATUAL BANCO.......: "
@li,113 PSAY nSaldoAtu+aRecon[1][PAG_NAO_CONCILIADO] 	Picture tm(nSaldoAtu,16,nMoeda)



IF li != 80
	roda(cbcont,cbtxt,Tamanho)
EndIF

Set Device To Screen

#IFNDEF TOP
	dbSelectArea("SE5")
	RetIndex( "SE5" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
   If TcSrvType() != "AS/400"
		dbSelectArea("SE5")
		dbCloseArea()
		ChKFile("SE5")
    	dbSelectArea("SE5")
		dbSetOrder(1)
	Else
		dbSelectArea("SE5")
		RetIndex( "SE5" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	Endif
#ENDIF

If lSpbInUse
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cNomeArq+GetDBExtension())
	Ferase(cNomeArq+OrdBagExt())
Endif
If aReturn[5] = 1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr470Skip ³ Autor ³ Pilar S. Albaladejo	  ³ Data ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR470.PRX																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr470Skip(cBanco,cAgencia,cConta)
Local lRet := .T.

IF E5_TIPODOC $ "DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL"  //Valores de Baixas
	lRet := .F.
ElseIF E5_BANCO+E5_AGENCIA+E5_CONTA!=cBanco+cAgencia+cConta
	lRet := .F.
ElseIF E5_SITUACA = "C"    //Cancelado
	lRet := .F.
ElseIF E5_VALOR = 0
	lRet := .F.
ElseIF E5_VENCTO > mv_par05 .or. E5_VENCTO > E5_DATA
	lRet := .F.
ElseIf SubStr(E5_NUMCHEQ,1,1)=="*" 
	lRet := .F.
ElseIf (mv_par07 == 2 .and. Empty(E5_RECONC)) .or. (mv_par07 == 3 .and. !Empty(E5_RECONC))
	lRet := .F.
ElseIF E5_TIPODOC = "BA"      //Baixa Automatica
	lRet := .F.
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr470Spb  ³ Autor ³ Mauricio Pequim Jro	  ³ Data ³ 23.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta arquivo de tranbalho para SPB                      )  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR470.PRX																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr470SPB(cChave, aStruct)

Local cCondTrb := iiF(lAllFil, ".T.",'E5_FILIAL == xFilial("SE5")')
DbselectArea("SE5")
While !Eof() .and. &(cCondTrb)
	If (E5_DATA >= mv_par04 .and. E5_DATA <= MV_PAR05 .AND.E5_DTDISPO > MV_PAR05) .OR. (E5_DTDISPO <= MV_PAR05)
		RecLock( "TRB", .T. )
		For nX := 1 to Len( aStruct )-1   // Até o campo anterior a TRB->E5_BLOQ
			dbSelectArea("SE5")
			xConteudo := FieldGet( nX )
			dbSelectArea("TRB")
			FieldPut( nX,	xConteudo )
		Next nX
		If (E5_DATA <= MV_PAR05 .AND.E5_DTDISPO > MV_PAR05 ) .or. ;
			(E5_DATA <= MV_PAR05 .AND.E5_MODSPB == "2" .and. E5_DTDISPO == MV_PAR05 .AND.;
			(dDataBase == E5_DTDISPO .and. ;
			((E5_RECPAG == "R" .and. E5_TIPODOC != "ES") .or. (E5_RECPAG == "P" .and. E5_TIPODOC == "ES"))) )
			TRB->E5_DTDISPO	:= TRB->E5_DATA
			TRB->E5_BLOQ		:= SE5->E5_MODSPB
		Endif	
		msUnlock()
   Endif                                                     
   DbselectArea("SE5")
   DBsKIP()
Enddo
dbselectArea("TRB")
dbGotop()
Return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Banco           ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA6"})
aadd(_agrpsx1,{cperg,"02","Da Agencia         ?","mv_ch2","C",05,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da Conta           ?","mv_ch3","C",10,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Da data            ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Ate a data         ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Qual moeda         ?","mv_ch6","N",01,0,0,"C",space(60),"mv_par06"       ,"Moeda 1"        ,space(30),space(15),"Moeda 2"        ,space(30),space(15),"Moeda 3"        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Conciliacao        ?","mv_ch7","N",01,0,0,"C",space(60),"mv_par07"       ,"Todos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Vl. nao Conc. ant. ?","mv_ch8","N",15,2,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),"Conciliados"    ,space(30),space(15),"Nao Conciliados",space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,04]
		sx1->x1_tipo   :=_agrpsx1[_i,05]
		sx1->x1_tamanho:=_agrpsx1[_i,06]
		sx1->x1_decimal:=_agrpsx1[_i,07]
		sx1->x1_presel :=_agrpsx1[_i,08]
		sx1->x1_gsc    :=_agrpsx1[_i,09]
		sx1->x1_valid  :=_agrpsx1[_i,10]
		sx1->x1_var01  :=_agrpsx1[_i,11]
		sx1->x1_def01  :=_agrpsx1[_i,12]
		sx1->x1_cnt01  :=_agrpsx1[_i,13]
		sx1->x1_var02  :=_agrpsx1[_i,14]
		sx1->x1_def02  :=_agrpsx1[_i,15]
		sx1->x1_cnt02  :=_agrpsx1[_i,16]
		sx1->x1_var03  :=_agrpsx1[_i,17]
		sx1->x1_def03  :=_agrpsx1[_i,18]
		sx1->x1_cnt03  :=_agrpsx1[_i,19]
		sx1->x1_var04  :=_agrpsx1[_i,20]
		sx1->x1_def04  :=_agrpsx1[_i,21]
		sx1->x1_cnt04  :=_agrpsx1[_i,22]
		sx1->x1_var05  :=_agrpsx1[_i,23]
		sx1->x1_def05  :=_agrpsx1[_i,24]
		sx1->x1_cnt05  :=_agrpsx1[_i,25]
		sx1->x1_f3     :=_agrpsx1[_i,26]
		sx1->(msunlock())
	endif
next
return


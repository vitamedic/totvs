#INCLUDE "VIT091.CH"
#INCLUDE "RWMAKE.CH"
#Include "Protheus.Ch"
#Include "TopConn.Ch"

STATIC aTamSxg

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MATR110  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao do Pedido de Compras                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Atualizacoes Sofridas Desde a Construcao Inicial.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function VIT091(cAlias,nReg,nOpcx)

	LOCAL wnrel		:= "VIT091"+Alltrim(cusername)
	LOCAL cDesc1	:= STR0001	//"Emissao dos pedidos de compras ou autorizacoes de entrega"
	LOCAL cDesc2	:= STR0002	//"cadastradados e que ainda nao foram impressos"
	LOCAL cDesc3	:= " "
	LOCAL cString	:= "SC7"

	PRIVATE lAuto		:= (nReg!=Nil)
	PRIVATE Tamanho		:= "M"
	PRIVATE titulo	 	:=STR0003										//"Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
	PRIVATE aReturn 	:= {STR0004, 1,STR0005, 2, 2, 1, "",0 }		//"Zebrado"###"Administracao"
	PRIVATE nomeprog	:="VIT091"
	PRIVATE nLastKey	:= 0
	PRIVATE nBegin		:= 0
	PRIVATE aLinha		:= {}
	PRIVATE aSenhas		:= {}
	PRIVATE aUsuarios	:= {}
	PRIVATE M_PAG	:= 1

	If Type("lPedido") != "L"
		lPedido := .F.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01               Do Pedido                             ³
	//³ mv_par02               Ate o Pedido                          ³
	//³ mv_par03               A partir da data de emissao           ³
	//³ mv_par04               Ate a data de emissao                 ³
	//³ mv_par05               Somente os Novos                      ³
	//³ mv_par06               Campo Descricao do Produto    	     ³
	//³ mv_par07               Unidade de Medida:Primaria ou Secund. ³
	//³ mv_par08               Imprime ? Pedido Compra ou Aut. Entreg³
	//³ mv_par09               Numero de vias                        ³
	//³ mv_par10               Pedidos ? Liberados Bloqueados Ambos  ³
	//³ mv_par11               Impr. SC's Firmes, Previstas ou Ambas ³
	//³ mv_par12               Qual a Moeda ?                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("PERGVIT091",.F.)

	wnrel:=SetPrint(cString,wnrel,If(lAuto,Nil,"PERGVIT091"),@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,!lAuto)

	If nLastKey == 27
		//	Set Filter To
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		//	Set Filter to
		Return
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verif. conteudo da variavel C. Custo (004) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTamSXG  := If(aTamSXG  == NIL, TamSXG("004"), aTamSXG)

	If lAuto
		mv_par08 := SC7->C7_TIPO
	EndIf

	If lPedido
		mv_par12 := SC7->C7_MOEDA
	Endif

	If mv_par08 == 1
		RptStatus({|lEnd| C110PC(@lEnd,wnRel,cString,nReg)},titulo)
	Else
		RptStatus({|lEnd| C110AE(@lEnd,wnRel,cString,nReg)},titulo)
	EndIf

	lPedido := .F.

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110PC   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C110PC(lEnd,WnRel,cString,nReg)
	Local nReem
	Local nOrder
	Local cCondBus
	Local nSavRec
	Local aSavRec := {}

	Private cCGCPict, cCepPict
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Definir as pictures                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCepPict:=PesqPict("SA2","A2_CEP")
	cCGCPict:=PesqPict("SA2","A2_CGC")

	limite   := 130
	li       := 80
	nDescProd:= 0
	nTotal   := 0
	NumPed   := Space(6)

	If lAuto
		dbSelectArea("SC7")
		dbGoto(nReg)
		SetRegua(1)
		mv_par01 := C7_NUM
		mv_par02 := C7_NUM
		mv_par03 := C7_EMISSAO
		mv_par04 := C7_EMISSAO
		mv_par05 := 2
		mv_par08 := C7_TIPO
		mv_par09 := 1
		mv_par10 := 3
		mv_par11 := 3
	EndIf

	If ( cPaisLoc$"ARG|POR|EUA" )
		cCondBus	:=	"1"+strzero(val(mv_par01),6)
		nOrder	:=	10
		nTipo		:= 1 
	Else
		cCondBus	:=mv_par01
		nOrder	:=	1
	EndIf

	dbSelectArea("SC7")
	dbSetOrder(nOrder)
	SetRegua(RecCount())
	dbSeek(xFilial("SC7")+cCondBus,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 0,0 PSay AvalImp(Limite+2)

	While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. ;
	C7_NUM <= mv_par02

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria as variaveis para armazenar os valores do pedido        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nOrdem   := 1
		nReem    := 0
		cObs01   := " "
		cObs02   := " "
		cObs03   := " "
		cObs04   := " "

		If C7_EMITIDO == "S" .And. mv_par05 == 1
			dbSkip()
			Loop
		Endif
		If (C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(C7_CONAPRO != "B" .And. mv_par10 == 2)
			dbSkip()
			Loop
		Endif
		If (C7_EMISSAO < mv_par03) .Or. (C7_EMISSAO > mv_par04)
			dbSkip()
			Loop
		Endif
		If C7_TIPO == 2
			dbSkip()
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !MtrAValOP(mv_par11, 'SC7')
			dbSkip()
			Loop
		EndIf

		MaFisEnd()
		//	MaFisIniPC(SC7->C7_NUM)
		R110FIniPC(SC7->C7_NUM) 

		For ncw := 1 To mv_par09		// Imprime o numero de vias informadas

			ImpCabec()

			nTotal   := 0
			nDescProd:= 0
			nReem    := SC7->C7_QTDREEM + 1
			nSavRec  := SC7->(Recno())
			NumPed   := SC7->C7_NUM
			While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM == NumPed
				If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
					AADD(aSavRec,Recno())
				Endif
				If lEnd
					@PROW()+1,001 PSAY STR0006	//"CANCELADO PELO OPERADOR"
					Goto Bottom
					Exit
				Endif

				IncRegua()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se havera salto de formulario                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If li > 56
					nOrdem++
					ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
					ImpCabec()
				Endif

				li++

				@ li,001 PSAY "|"
				@ li,002 PSAY SUBSTR(C7_ITEM,2,3)  		Picture PesqPict("SC7","c7_item")
				@ li,005 PSAY "|"
				@ li,006 PSAY SUBSTR(C7_PRODUTO,1,6)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Pesquisa Descricao do Produto                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ImpProd()

				If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
					nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
				Else
					nDescProd+=SC7->C7_VLDESC
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializacao da Observacao do Pedido.                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SC7->C7_ITEM < "05"
					cVar:="cObs"+SC7->C7_ITEM
					Eval(MemVarBlock(cVar),SC7->C7_OBS)
				Endif
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek( xFilial()+SC7->C7_PRODUTO )
				_mnota := .f.
				if B1_TIPO =="MP" .or.  B1_TIPO =="EE" .or. B1_TIPO =="EN" 
					_mnota := .t.
				endif

				dbSelectArea("SC7")			
				dbSkip()
			EndDo

			dbGoto(nSavRec)

			If li>38
				nOrdem++
				ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec()
			Endif

			FinalPed(nDescProd)		// Imprime os dados complementares do PC

		Next

		MaFisEnd()

		If Len(aSavRec)>0
			For i:=1 to Len(aSavRec)
				dbGoto(aSavRec[i])
				RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
				Replace C7_QTDREEM With (C7_QTDREEM+1)
				Replace C7_EMITIDO With "S"
				MsUnLock()
			Next
			dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
		Endif

		aSavRec := {}

		dbSkip()
	EndDo

	dbSelectArea("SC7")
	//Set Filter To
	dbSetOrder(1)

	dbSelectArea("SX3")
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se em disco, desvia para Spool                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110AE   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C110AE(lEnd,WnRel,cString,nReg)
	Local nReem
	Local nSavRec,aSavRec := {}

	Private cCGCPict, cCepPict
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Definir as pictures                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCepPict:=PesqPict("SA2","A2_CEP")
	cCGCPict:=PesqPict("SA2","A2_CGC")

	limite   := 130
	li       := 80
	nDescProd:= 0
	nTotal   := 0
	NumPed   := Space(6)

	If !lAuto
		dbSelectArea("SC7")
		dbSetOrder(10)
		dbSeek(xFilial("SC7")+"2"+mv_par01,.T.)
	Else
		dbSelectArea("SC7")
		dbGoto(nReg)
		mv_par01 := C7_NUM
		mv_par02 := C7_NUM
		mv_par03 := C7_EMISSAO
		mv_par04 := C7_EMISSAO
		mv_par05 := 2
		mv_par08 := C7_TIPO
		mv_par09 := 1
		mv_par10 := 3
		mv_par11 := 3
		dbSelectArea("SC7")
		dbSetOrder(10)
		dbSeek(xFilial("SC7")+"2"+mv_par01,.T.)
	EndIf

	SetRegua(Reccount())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 0,0 PSay AvalImp(Limite+2)

	While !Eof().And.C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. C7_NUM <= mv_par02
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria as variaveis para armazenar os valores do pedido        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nOrdem   := 1
		nReem    := 0
		cObs01   := " "
		cObs02   := " "
		cObs03   := " "
		cObs04   := " "

		If C7_EMITIDO == "S" .And. mv_par05 == 1
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
		If (C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(C7_CONAPRO != "B" .And. mv_par10 == 2)
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
		If (SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
		If SC7->C7_TIPO != 2
			dbSelectArea("SC7")
			dbSkip()
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !MtrAValOP(mv_par11, 'SC7')
			dbSelectArea("SC7")
			dbSkip()
			Loop
		EndIf

		MaFisEnd()
		R110FIniPC(SC7->C7_NUM)

		For ncw := 1 To mv_par09		// Imprime o numero de vias informadas

			ImpCabec()

			nTotal   := 0
			nDescProd:= 0
			nReem    := SC7->C7_QTDREEM + 1
			nSavRec  := SC7->(Recno())
			NumPed   := SC7->C7_NUM


			While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM == NumPed

				If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
					AADD(aSavRec,Recno())
				Endif

				If lEnd
					@PROW()+1,001 PSAY STR0006		//"CANCELADO PELO OPERADOR"
					Goto Bottom
					Exit
				Endif

				IncRegua()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se havera salto de formulario                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If li > 56
					nOrdem++
					ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
					ImpCabec()
				Endif
				li++
				@ li,001 PSAY "|"
				@ li,002 PSAY SUBSTR(SC7->C7_ITEM,2,3)  	Picture PesqPict("SC7","C7_ITEM")
				@ li,005 PSAY "|"
				@ li,006 PSAY SC7->C7_PRODUTO	Picture PesqPict("SC7","C7_PRODUTO")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Pesquisa Descricao do Produto                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ImpProd()		// Imprime dados do Produto

				If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
					nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
				Else
					nDescProd+=SC7->C7_VLDESC
				Endif		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializacao da Observacao do Pedido.                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SC7->C7_ITEM < "05"
					cVar:="cObs"+SC7->C7_ITEM
					Eval(MemVarBlock(cVar),SC7->C7_OBS)
				Endif
				dbSelectArea("SC7")
				dbSkip()
			EndDo

			dbGoto(nSavRec)
			If li>38
				nOrdem++
				ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec()
			Endif
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek( xFilial()+SC7->C7_PRODUTO )

			FinalAE(nDescProd)		// dados complementares da Autorizacao de Entrega
		Next

		MaFisEnd()

		If Len(aSavRec)>0
			dbGoto(aSavRec[Len(aSavRec)])
			For i:=1 to Len(aSavRec)
				dbGoto(aSavRec[i])
				RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
				Replace C7_EMITIDO With "S"
				Replace C7_QTDREEM With (C7_QTDREEM+1)
				MsUnLock()
			Next
		Endif
		aSavRec := {}
		dbSelectArea("SC7")
		dbSkip()
	End

	dbSelectArea("SC7")
	//Set Filter To
	dbSetOrder(1)

	dbSelectArea("SX3")
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se em disco, desvia para Spool                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
		Set Printer TO
		Commit
		ourspool(wnrel)
	Endif

	MS_FLUSH()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisar e imprimir  dados Cadastrais do Produto.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpProd()
	LOCAL cDesc, nLinRef := 1, nBegin := 0, cDescri := "", nLinha:=0,;
	nTamDesc := 28, aColuna := Array(10)
	//MSGSTOP(SC7->C7_PRODUTO+"-"+SC7->C7_NUM)
	If Empty(mv_par06)
		mv_par06 := "B1_DESC"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da descricao generica do Produto.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_querys()
	DbSelectArea("TMP1")
	If AllTrim(mv_par06) == "B1_DESC" 
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek( xFilial()+SC7->C7_PRODUTO )
		if !empty(SB1->b1_revarte)
			cDescri := Alltrim(SB1->B1_DESC)+"("+" Rev.: "+Alltrim(SB1->B1_REVARTE)+")" + " - Cons.Med.: " + cValtoChar(tmp1->CONSUMO) 
		else 
			cDescri := Alltrim(SB1->B1_DESC) + " - Cons.Med.: " + cValtoChar(tmp1->CONSUMO)
		endif
		dbSelectArea("SC7")    	   
	ELSE
		cDescri := Alltrim(SC7->C7_DESCRI) + " - Cons.Med.: " + cValtoChar(tmp1->CONSUMO) //+" ("+SUBSTR(SB1->B1_COD,1,6)+"-Rev.:"+Alltrim(SB1->B1_REVARTE)+")"
	EndIf
	TMP1->(DbCloseArea())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da descricao cientifica do Produto.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(mv_par06) == "B5_CEME"
		dbSelectArea("SB5")
		dbSetOrder(1)
		If dbSeek( xFilial()+SC7->C7_PRODUTO )
			cDescri := Alltrim(B5_CEME)
		EndIf
		dbSelectArea("SC7")
	EndIf
	/*
	dbSelectArea("SC7")
	If AllTrim(mv_par06) == "C7_DESCRI"
	if !empty(SB1->b1_revarte)
	cDescri := Alltrim(SC7->C7_DESCRI) +" ("+SUBSTR(SC7->C7_PRODUTO,1,6)+"-Rev.:"+Alltrim(SB1->B1_REVARTE)+")"
	else
	cDescri := Alltrim(SC7->C7_DESCRI)
	endif	
	EndIf*/
	/*
	dbSelectArea("SA5")
	dbSetOrder(1)
	If dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO).And. !Empty(SA5->A5_CODPRF)
	cDescri := cDescri + " ("+Alltrim(A5_CODPRF)+")"
	EndIf*/
	//|------------------------------------------------------------------------------------------------------------------------------------|
	//|Itm|  Codigo |Descricao do Material        |UM|   Quant.    |Valor Unitario|IPI|  Valor Total | Dt.Neces.|Lead Time| OBS/C.C | S.C. |
	//|---|---------|-----------------------------|--|-------------|--------------|---|--------------|----------|---------|---------|------|
	//|01 |05       |15                           |45|48           |62            |77 |81            |96        |105      |115      |125   |

	dbSelectArea("SC7")
	aColuna[1] :=  44
	aColuna[2] :=  47
	aColuna[3] :=  61
	aColuna[4] :=  76
	aColuna[5] :=  81
	aColuna[6] :=  96
	aColuna[7] := 105
	acoluna[8] := 115
	acoluna[9] := 125
	acoluna[10]:= 132
	/* Antes da Alteração de 14/05/2008
	aColuna[1] :=  51
	aColuna[2] :=  54
	aColuna[3] :=  68
	aColuna[4] :=  83
	aColuna[5] :=  87
	aColuna[6] := 104
	aColuna[7] := 115
	acoluna[8] := 132
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime da descricao selecionada                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aTamSxg[1] != aTamSxg[3]
		nTamDesc := 38
		aColuna[1] :=  54
		aColuna[2] :=  57
		aColuna[3] :=  71
		aColuna[4] :=  86
		aColuna[5] :=  90
		aColuna[6] := 105
		aColuna[7] := 116
		aColuna[8] := 132
	Endif	
	/* Antes da Alteração de 14/05/2008
	If aTamSxg[1] != aTamSxg[3]
	nTamDesc := 38
	aColuna[1] :=  61
	aColuna[2] :=  64
	aColuna[3] :=  78
	aColuna[4] :=  93
	aColuna[5] :=  97
	aColuna[6] := 114
	aColuna[7] := 125
	aColuna[8] := 132
	Endif	

	*/
	nLinha:= MLCount(cDescri,nTamDesc)

	// 2ª LINHA - PARA CAMPO MEMO COM MAIS DE 01 LINHA
	//|------------------------------------------------------------------------------------------------------------------------------------|
	//|Itm|  Codigo |Descricao do Material        |UM|   Quant.    |Valor Unitario|IPI|  Valor Total | Dt.Neces.|Lead Time| OBS/C.C | S.C. |
	//|---|---------|-----------------------------|--|-------------|--------------|---|--------------|----------|---------|---------|------|
	//|01 |05       |15                           |45|48           |62            |77 |81            |96        |105      |115      |125   |
	@ li,015 PSAY "|"
	@ li,016 PSAY MemoLine(cDescri,nTamDesc,1)

	ImpCampos()
	For nBegin := 2 To nLinha
		li++
		@ li,001 PSAY "|"
		@ li,005 PSAY "|"
		@ li,015 PSAY "|"
		@ li,016 PSAY Memoline(cDescri,nTamDesc,nBegin)
		@ li,aColuna[1] PSAY "|"
		@ li,acoluna[2] PSAY "|"
		@ li,acoluna[3] PSAY "|"
		@ li,aColuna[4] PSAY "|"
		@ li,aColuna[5] PSAY "|"
		If mv_par08 == 1
			@ li,aColuna[6] PSAY "|"
			If aTamSxg[1] == aTamSxg[3]
				@ li,105 PSAY "|"
			Else
				@ li,aColuna[7] PSAY "|"
			Endif	
			@ li,aColuna[8]  PSAY "|"
			@ li,aColuna[9]  PSAY "|"
			@ li,aColuna[10] PSAY "|"
		Else
			@ li,102 PSAY "|"
			@ li,111 PSAY "|"
			@ li,132 PSAY "|"
		EndIf
	Next nBegin

Return NIL
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCampos³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir dados Complementares do Produto no Pedido.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCampos(Void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCampos()

	LOCAL aColuna[10]
	dbSelectArea("SC7")

	// 2ª LINHA - PARA CAMPO MEMO COM MAIS DE 01 LINHA
	//|------------------------------------------------------------------------------------------------------------------------------------|
	//|Itm|  Codigo |Descricao do Material        |UM|   Quant.    |Valor Unitario|IPI|  Valor Total | Dt.Neces.|Lead Time| OBS/C.C | S.C. |
	//|---|---------|-----------------------------|--|-------------|--------------|---|--------------|----------|---------|---------|------|
	//|01 |05       |15                           |45|48           |62            |77 |81            |96        |106      |116      |126   |

	If aTamSxg[1] != aTamSxg[3]
		aColuna[1] :=  55
		aColuna[2] :=  58
		aColuna[3] :=  72
		aColuna[4] :=  87
		aColuna[5] :=  91
		aColuna[6] := 106
	Else
		aColuna[1] :=  44
		aColuna[2] :=  47
		aColuna[3] :=  61
		aColuna[4] :=  76
		aColuna[5] :=  80
		aColuna[6] :=  95
		aColuna[7] := 104
		aColuna[8] := 114
		aColuna[9] := 124
		aColuna[10]:= 132
	Endif	

	@ li,aColuna[1] PSAY "|"
	If MV_PAR07 == 2 .And. !Empty(SC7->C7_SEGUM)
		@ li,PCOL() PSAY SC7->C7_SEGUM Picture PesqPict("SC7","C7_UM")
	Else
		@ li,PCOL() PSAY SC7->C7_UM    Picture PesqPict("SC7","C7_UM")
	EndIf
	@ li,aColuna[2] PSAY "|"
	If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM) 
		@ li,PCOL()	PSAY SC7->C7_QTSEGUM Picture PesqPictQt("C7_QUANT",13)
	Else
		@ li,PCOL()	PSAY SC7->C7_QUANT   Picture PesqPictQt("C7_QUANT",13)
	EndIf
	@ li,aColuna[3] PSAY "|"   
	_ddata:=ctod("  /  /  ")
	_dtlead:=ctod("  /  /  ")
	_mcc := ""
	if sb1->b1_tipo$"MP#EE#EN"
		if (SC7->C7_DATPRF) <= date() 
			_ddata := SC7->C7_DATPRF
		else
			_ddata :=if(SC7->C7_DATPRF-3<=date(),SC7->C7_DATPRF,SC7->C7_DATPRF-3)
		endif                       
		if sb1->b1_tipo$ "EE#EN"
			_mcc := substr(c7_obs,1,08)
		endif  

		//LEAD TIME
		dbSelectArea("SA5")
		dbSetOrder(1)
		dbSeek(xFilial("SA5")+sc7->c7_fornece+sc7->c7_loja+sc7->c7_produto)	
		_dtlead:= (sc7->c7_emissao)+sa5->a5_leadtim 

	else
		_ddata := SC7->C7_DATPRF
	endif	
	If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM)  
		@ li,PCOL()	PSAY xMoeda((SC7->C7_TOTAL/SC7->C7_QTSEGUM),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture PesqPict("SC7","C7_PRECO",14, mv_par12)
	Else
		@ li,PCOL()	PSAY xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture PesqPict("SC7","C7_PRECO",14,mv_par12)
	EndIf
	@ li,aColuna[4] PSAY "|"

	If mv_par08 == 1
		If cPaisLoc == "BRA"
			@ li,    PCOL() PSAY SC7->C7_IPI     				 Picture "99"
			@ li,aColuna[5] PSAY "%"
			@ li,    PCOL() PSAY "|"
		Else
			@ li,    PCOL() PSAY "  "
			@ li,aColuna[5] PSAY " "
			@ li,    PCOL() PSAY " "
		EndIf
		@ li,    PCOL() PSAY xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture PesqPict("SC7","C7_TOTAL",14,mv_par12)
		@ li,aColuna[6] PSAY "|"
		@ li,    PCOL() PSAY _ddata Picture PesqPict("SC7","C7_DATPRF") 
		@ li,aColuna[7] PSAY "|"
		if mv_par15==1
			@ li,    PCOL() PSAY _dtlead Picture PesqPict("SC7","C7_DATPRF") 
		endif
		if !empty(_mcc)
			@ li,114 PSAY "|"
			@ li,115 PSAY _mcc
			@ li,124 PSAY "|"

		elseIf aTamSxg[1] == aTamSxg[3]
			@ li,114 PSAY "|"
			@ li,115 PSAY SC7->C7_CC      				 Picture PesqPict("SC7","C7_CC")
			@ li,124 PSAY "|"
		Else
			@ li,124 PSAY "|"
		Endif	
		@ li,  PCOL() PSAY SC7->C7_NUMSC
		@ li,     131 PSAY "|"
	Else
		@ li,  PCOL() PSAY xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture PesqPict("SC7","C7_TOTAL",16,mv_par12)

		@ li,     100 PSAY "|"
		@ li,  PCOL() PSAY _ddata  				 Picture PesqPict("SC7","C7_DATPRF")
		@ li,     111 PSAY "|"
		@ li,  PCOL() PSAY SC7->C7_OP
		@ li,     132 PSAY "|"
	EndIf

	nTotal  :=nTotal+SC7->C7_TOTAL

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalPed(nDescProd)
	Local nk 		:= 1,nG
	Local nQuebra	:= 0
	Local nTotDesc	:= nDescProd
	Local lNewAlc	:= .F.
	Local lLiber 	:= .F.
	Local lImpLeg	:= .T.
	Local cComprador:=""
	LOcal cAlter	:=""
	Local cAprov	:=""
	Local nTotIpi	:= MaFisRet(,'NF_VALIPI')
	Local nTotIcms	:= MaFisRet(,'NF_VALICM')
	Local nTotDesp	:= MaFisRet(,'NF_DESPESA')
	Local nTotFrete	:= MaFisRet(,'NF_FRETE')
	Local nTotalNF	:= MaFisRet(,'NF_TOTAL')
	Local nTotSeguro:= MaFisRet(,'NF_SEGURO')
	Local aValIVA   := MaFisRet(,"NF_VALIMP")
	Local nValIVA   :=0
	Local aColuna   := Array(10), nTotLinhas

	If cPaisLoc <> "BRA" .And. !Empty(aValIVA)
		For nG:=1 to Len(aValIVA)
			nValIVA+=aValIVA[nG]
		Next
	Endif

	cMensagem:= Formula(C7_MSG)

	If !Empty(cMensagem)
		li++
		@ li,001 PSAY "|"
		@ li,002 PSAY Padc(cMensagem,129)
		@ li,132 PSAY "|"
	Endif
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
	li++
	//|------------------------------------------------------------------------------------------------------------------------------------|
	//|Itm|  Codigo |Descricao do Material        |UM|   Quant.    |Valor Unitario|IPI|  Valor Total | Dt.Neces.|Lead Time| OBS/C.C | S.C. |
	//|---|---------|-----------------------------|--|-------------|--------------|---|--------------|----------|---------|---------|------|
	//|01 |05       |15                           |45|48           |62            |77 |81            |96        |105      |115      |125   |
	aColuna[1] :=  44
	aColuna[2] :=  47
	aColuna[3] :=  61
	aColuna[4] :=  76
	aColuna[5] :=  81
	aColuna[6] :=  96
	acoluna[7] := 105
	aColuna[8] := 115
	aColuna[9] := 125
	aColuna[10]:= 132
	nTotLinhas :=  39
	If aTamSxg[1] != aTamSxg[3]
		aColuna[1] :=  54
		aColuna[2] :=  57
		aColuna[3] :=  71
		aColuna[4] :=  86
		aColuna[5] :=  91
		aColuna[6] := 106
		aColuna[7] := 115
		aColuna[8] := 125
		aColuna[9] := 132
		nTotLinhas :=  49
	ENDIF	
	While li<nTotLinhas 
		if _mnota .and. li==35
			@ li,001 PSAY "|"
			@ li,003 PSAY "                                  POR GENTILEZA NOS INFORMAR PESO E VOLUME PARA EMBARQUE"
			@ li,132 PSAY "|"
			li++
			@ li,001 PSAY "|"
			//@ li,003 PSAY "O RECEBIMENTO DOS INSUMOS SOMENTE SERA FEITO MEDIANTE O LAUDO DE ANALISE DO PRODUTO EMITIDO PELO FABRICANTE E/OU FORNECEDOR"
			@ li,003 PSAY "O RECEBIMENTO DOS INSUMOS SOMENTE SERA FEITO MEDIANTE A ENTREGA DOS LAUDOS DE ANALISE EMITIDOS PELO FABRICANTE E PELO FORNECEDOR"
			@ li,132 PSAY "|"
			li++			
		endif

		@ li,001 PSAY "|"
		@ li,005 PSAY "|"
		@ li,015 PSAY "|"
		@ li,015 + nk PSAY "*"
		nk := IIf( nk == 42 , 1 , nk + 1 )
		@ li,aColuna[1] PSAY "|"
		@ li,aColuna[2] PSAY "|"
		@ li,aColuna[3] PSAY "|"
		@ li,aColuna[4] PSAY "|"
		@ li,aColuna[5] PSAY "|"
		@ li,aColuna[6] PSAY "|"
		@ li,aColuna[7] PSAY "|"
		@ li,aColuna[8] PSAY "|"

		if aTamSxg[1] != aTamSxg[3]
			@ li,aColuna[9]  PSAY "|"
		else
			@ li,aColuna[9]  PSAY "|"
			@ li,aColuna[10] PSAY "|"
		endif
		li++
	EndDo
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
	li++
	_ddata:=ctod("")
	_desenv :=.f. 
	if sb1->b1_tipo$ "MP/EE/EN)
		if SC7->C7_DATPRF > date() 
			_ddata := SC7->C7_DATPRF
		else
			_ddata :=if(SC7->C7_DATPRF-3<=date(),SC7->C7_DATPRF,SC7->C7_DATPRF-3)
		endif                       
		if sb1->b1_grupo="MP03"
			_desenv := .t.
		endif 
	else
		_ddata := SC7->C7_DATPRF
	endif	

	@ li,001 PSAY "|"
	@ li,015 PSAY STR0007		//"D E S C O N T O S -->"
	@ li,037 PSAY C7_DESC1 Picture "999.99"
	@ li,046 PSAY C7_DESC2 Picture "999.99"
	@ li,055 PSAY C7_DESC3 Picture "999.99"
	@ li,068 PSAY xMoeda(nTotDesc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture PesqPict("SC7","C7_VLDESC",14, mv_par12)

	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAlias := Alias()
	dbSelectArea("SM0")
	dbSetOrder(1)   // forca o indice na ordem certa
	nRegistro := Recno()
	dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0008 + SM0->M0_ENDENT		//"Local de Entrega  : "
	@ li,057 PSAY "-"
	@ li,061 PSAY SM0->M0_CIDENT
	@ li,083 PSAY "-"
	@ li,085 PSAY SM0->M0_ESTENT
	@ li,088 PSAY "-"
	@ li,090 PSAY STR0009	//"CEP :"
	@ li,096 PSAY Trans(Alltrim(SM0->M0_CEPENT),cCepPict)
	@ li,132 PSAY "|"
	dbGoto(nRegistro)

	dbSelectArea( cAlias )
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0010 + SM0->M0_ENDCOB		//"Local de Cobranca : "
	@ li,057 PSAY "-"
	@ li,061 PSAY SM0->M0_CIDCOB
	@ li,083 PSAY "-"
	@ li,085 PSAY SM0->M0_ESTCOB
	@ li,088 PSAY "-"
	@ li,090 PSAY STR0009	//"CEP :"
	@ li,096 PSAY Trans(Alltrim(SM0->M0_CEPCOB),cCepPict)
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"

	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial()+SC7->C7_COND)
	dbSelectArea("SC7")
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0011+SubStr(SE4->E4_COND,1,15)		//"Condicao de Pagto "
	@ li,038 PSAY STR0012		//"|Data de Emissao|"
	@ li,056 PSAY STR0013		//"Total das Mercadorias : "
	@ li,094 PSAY xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture tm(nTotal,14)
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
	@ li,038 PSAY "|"
	@ li,043 PSAY SC7->C7_EMISSAO
	@ li,054 PSAY "|"
	If cPaisLoc<>"BRA"
		@ li,056 PSAY OemtoAnsi(STR0063)
		@ li,094 PSAY xMoeda(nValIVA,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture tm(nValIVA,14)
	Endif
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",52)
	@ li,054 PSAY "|"
	@ li,055 PSAY Replicate("-",77)
	@ li,132 PSAY "|"
	li++
	dbSelectArea("SM4")
	dbSetOrder(1)
	dbSeek(xFilial()+SC7->C7_REAJUST)
	dbSelectArea("SC7")


	@ li,001 PSAY "|"
	//@ li,003 PSAY STR0014		//"Reajuste :"
	//@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust",,mv_par12)
	//@ li,018 PSAY SM4->M4_DESCR
	dbSelectArea("SA4")
	dbSetOrder(1)
	dbSeek(xFilial()+SC7->C7_TRANS)

	@ li,003	PSAY "Transp.: "+substr(SA4->A4_NOME,1,30)	          


	If cPaisLoc == "BRA"
		@ li,054 PSAY STR0015		//"| IPI   :"
		@ li,064 PSAY xMoeda(nTotIPI,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture tm(nTotIpi,14)
		@ li,088 PSAY "| ICMS   : "
		@ li,100 PSAY xMoeda(nTotIcms,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture tm(nTotIcms,14)
		@ li,132 PSAY "|"
	Else	
		@ li,054 PSAY "|"
		@ li,132 PSAY "|"
	EndIf

	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",52)
	@ li,054 PSAY (STR0049) //"| Frete :"
	@ li,064 PSAY xMoeda(nTotFrete,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture tm(nTotFrete,14)
	@ li,088 PSAY (STR0058) //"| Despesas :"
	@ li,100 PSAY xMoeda(nTotDesp,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture tm(nTotDesp,14)

	@ li,132 PSAY "|"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializar campos de Observacoes.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cObs02)
		If Len(cObs01) > 50
			cObs := cObs01
			cObs01 := Substr(cObs,1,50)
			For nX := 2 To 4
				cVar  := "cObs"+StrZero(nX,2)
				&cVar := Substr(cObs,(50*(nX-1))+1,50)
			Next
		EndIf
	Else
		cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
		cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
		cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
		cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
	EndIf

	dbSelectArea("SC7")
	If !Empty(C7_APROV)
		lNewAlc := .T.
		cComprador := UsrFullName(SC7->C7_USER)
		If C7_CONAPRO != "B"
			lLiber := .T.
		EndIf
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial()+"PC"+SC7->C7_NUM)
		While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SCR")+SC7->C7_NUM .And. SCR->CR_TIPO == "PC"
			cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["+;
			IF(SCR->CR_STATUS=="03","Ok",IF(SCR->CR_STATUS=="04","BLQ","??"))+"] - "
			dbSelectArea("SCR")
			dbSkip()
		Enddo
		If !Empty(SC7->C7_GRUPCOM)
			dbSelectArea("SAJ")
			dbSetOrder(1)
			dbSeek(xFilial()+SC7->C7_GRUPCOM)
			While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
				If SAJ->AJ_USER != SC7->C7_USER
					cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
				EndIf
				dbSelectArea("SAJ")
				dbSkip()
			EndDo
		EndIf
	EndIf

	li++
	@ li,001 PSAY STR0016		//"| Observacoes"
	@ li,054 PSAY STR0017		//"| Grupo :"
	@ li,088 PSAY STR0059      //"| SEGURO :"
	@ li,100 PSAY xMoeda(nTotSeguro,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture tm(nTotSeguro,14)
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs01
	@ li,054 PSAY "|"+Replicate("-",77)
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs02
	@ li,054 PSAY STR0018		//"| Total Geral : "

	If !lNewAlc
		@ li,084 PSAY xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture tm(nTotalNF,14)
	Else
		If lLiber
			@ li,084 PSAY xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture tm(nTotalNF,14)
		Else
			@ li,080 PSAY (STR0051)
		EndIf
	EndIf                   

	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs03
	@ li,054 PSAY "|"+Replicate("-",77)
	@ li,132 PSAY "|"
	li++

	If !lNewAlc
		@ li,001 PSAY "|"
		@ li,003 PSAY cObs04
		@ li,054 PSAY "|"
		@ li,061 PSAY STR0019		//"|           Liberacao do Pedido"
		@ li,102 PSAY STR0020		//"| Obs. do Frete: "
		@ li,119 PSAY IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
		@ li,132 PSAY "|"
		li++
		@ li,001 PSAY "|"+Replicate("-",59)
		@ li,061 PSAY "|"
		@ li,102 PSAY "|"
		@ li,132 PSAY "|"	
		li++
		cLiberador := ""
		nPosicao := 0
		@ li,001 PSAY "|"
		@ li,007 PSAY STR0021		//"Comprador"
		@ li,021 PSAY "|"
		@ li,028 PSAY STR0022		//"Gerencia"
		@ li,041 PSAY "|"
		@ li,046 PSAY STR0023		//"Diretoria"
		@ li,061 PSAY "|     ------------------------------"
		@ li,102 PSAY "|"
		@ li,132 PSAY "|"
		li++
		@ li,001 PSAY "|"
		@ li,021 PSAY "|"
		@ li,041 PSAY "|"
		@ li,061 PSAY "|     " + R110Center(cLiberador) // 30 posicoes
		@ li,102 PSAY "|"
		@ li,132 PSAY "|"
		li++
		@ li,001 PSAY "|"
		@ li,002 PSAY Replicate("-",limite)
		@ li,132 PSAY "|"
		li++
		@ li,001 PSAY STR0024		//"|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
		@ li,132 PSAY "|"
		if _desenv
			li++
			@ li,001 PSAY "|   PRODUTO PARA DESENVOLVIMENTO "
			@ li,132 PSAY "|"
		endif		

		li++
		@ li,001 PSAY "|"
		@ li,002 PSAY Replicate("-",limite)
		@ li,132 PSAY "|"
	Else
		@ li,001 PSAY "|"
		@ li,003 PSAY cObs04
		@ li,054 PSAY "|"
		@ li,059 PSAY IF(lLiber,STR0050,STR0051)		//"     P E D I D O   L I B E R A D O"#"|     P E D I D O   B L O Q U E A D O !!!"
		@ li,102 PSAY STR0020		//"| Obs. do Frete: "
		@ li,119 PSAY IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
		@ li,132 PSAY "|"
		li++
		@ li,001 PSAY "|"+Replicate("-",99)
		@ li,102 PSAY "|"
		@ li,132 PSAY "|"
		li++
		@ li,001 PSAY "|"
		@ li,003 PSAY STR0052		//"Comprador Responsavel :"
		@ li,027 PSAY Substr(cComprador,1,60)
		@ li,088 PSAY "|"
		@ li,089 PSAY STR0060      //"BLQ:Bloqueado"
		@ li,102 PSAY "|"
		@ li,132 PSAY "|"
		li++	
		nAuxLin := Len(cAlter)
		@ li,001 PSAY "|"
		@ li,003 PSAY STR0053		//"Compradores Alternativos :"
		While nAuxLin > 0 .oR. lImpLeg
			@ li,029 PSAY Substr(cAlter,Len(cAlter)-nAuxLin+1,60)
			@ li,088 PSAY "|"
			If lImpLeg 
				@ li,089 PSAY STR0061   //"Ok:Liberado"
				lImpLeg := .F.
			EndIf
			@ li,102 PSAY "|"
			@ li,132 PSAY "|"
			nAuxLin -= 60
			li++	
		EndDo		
		nAuxLin := Len(cAprov)
		lImpLeg := .T.
		@ li,001 PSAY "|"
		@ li,003 PSAY STR0054		//"Aprovador(es) :"
		While nAuxLin > 0	.Or. lImpLeg
			@ li,019 PSAY Substr(cAprov,Len(cAprov)-nAuxLin+1,70)
			@ li,088 PSAY "|"
			If lImpLeg
				@ li,089 PSAY STR0062  //"??:Aguar.Lib"
				lImpLeg := .F.
			EndIf
			@ li,102 PSAY "|"
			@ li,132 PSAY "|"
			nAUxLin -=70
			li++	
		EndDo
		If nAuxLin == 0
			li++
		EndIf
		@ li,001 PSAY "|"
		@ li,002 PSAY Replicate("-",limite)
		@ li,132 PSAY "|"
		li++
		@ li,001 PSAY STR0024		//"|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
		@ li,132 PSAY "|"
		if _desenv
			li++
			@ li,001 PSAY "|   PRODUTO PARA DESENVOLVIMENTO "
			@ li,132 PSAY "|"
		endif	

		li++
		@ li,001 PSAY "|"
		@ li,002 PSAY Replicate("-",limite)
		@ li,132 PSAY "|"	
	EndIf

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalAE  ³ Autor ³ Cristina Ogura        ³ Data ³ 05.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares da Autorizacao de Entrega  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalAE(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalAE(nDescProd)
	Local nk := 1
	Local nTotDesc:= nDescProd
	Local nTotNF	:= MaFisRet(,'NF_TOTAL')
	cMensagem:= Formula(C7_MSG)

	If !Empty(cMensagem)
		li++
		@ li,001 PSAY "|"
		@ li,002 PSAY Padc(cMensagem,129)
		@ li,132 PSAY "|"
	Endif
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
	li++
	While li<39
		@ li,001 PSAY "|"
		@ li,005 PSAY "|"
		@ li,021 PSAY "|"
		@ li,021 + nk PSAY "*"
		nk := IIf( nk == 32 , 1 , nk + 1 )
		@ li,051 PSAY "|"
		@ li,054 PSAY "|"
		@ li,068 PSAY "|"
		@ li,083 PSAY "|"
		@ li,100 PSAY "|"
		@ li,111 PSAY "|"
		@ li,132 PSAY "|"
		li++
	EndDo
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAlias := Alias()
	dbSelectArea("SM0")
	dbSetOrder(1)   // forca o indice na ordem certa
	nRegistro := Recno()
	dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0008 + SM0->M0_ENDENT		//"Local de Entrega  : "
	@ li,057 PSAY "-"
	@ li,061 PSAY SM0->M0_CIDENT
	@ li,083 PSAY "-"
	@ li,085 PSAY SM0->M0_ESTENT
	@ li,088 PSAY "-"
	@ li,090 PSAY STR0009	//"CEP :"
	@ li,096 PSAY Trans(Alltrim(SM0->M0_CEPENT),cCepPict)
	@ li,132 PSAY "|"
	dbGoto(nRegistro)

	dbSelectArea(cAlias)
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0010 + SM0->M0_ENDCOB		//"Local de Cobranca : "
	@ li,057 PSAY "-"
	@ li,061 PSAY SM0->M0_CIDCOB
	@ li,083 PSAY "-"
	@ li,085 PSAY SM0->M0_ESTCOB
	@ li,088 PSAY "-"
	@ li,090 PSAY STR0009	//"CEP :"
	@ li,096 PSAY Trans(Alltrim(SM0->M0_CEPCOB),cCepPict)
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"

	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial()+SC7->C7_COND)
	dbSelectArea("SC7")
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0011+SubStr(SE4->E4_COND,1,15)		//"Condicao de Pagto "
	@ li,038 PSAY STR0012		// "|Data de Emissao|"
	@ li,056 PSAY STR0013		// "Total das Mercadorias : "
	@ li,094 PSAY xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF) Picture tm(nTotal,14)

	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
	@ li,038 PSAY "|"
	@ li,043 PSAY SC7->C7_EMISSAO
	@ li,054 PSAY "|"
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",52)
	@ li,054 PSAY "|"
	@ li,055 PSAY Replicate("-",77)
	@ li,132 PSAY "|"
	li++
	dbSelectArea("SM4")
	dbSeek(xFilial()+SC7->C7_REAJUST)
	dbSelectArea("SC7")
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0014		//"Reajuste :"
	@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust",,mv_par12)
	@ li,018 PSAY SM4->M4_DESCR
	@ li,054 PSAY STR0018		//"| Total Geral : "

	@ li,094 PSAY xMoeda(nTotNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF)      Picture tm(nTotNF,14)
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializar campos de Observacoes.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cObs02)
		If Len(cObs01) > 50
			cObs 	:= cObs01
			cObs01:= Substr(cObs,1,50)
			For nX := 2 To 4
				cVar  := "cObs"+StrZero(nX,2)
				&cVar := Substr(cObs,(50*(nX-1))+1,50)
			Next
		EndIf
	Else
		cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
		cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
		cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
		cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
	EndIf

	li++
	@ li,001 PSAY STR0025	//"| Observacoes"
	@ li,054 PSAY STR0026	//"| Comprador    "
	@ li,070 PSAY STR0027	//"| Gerencia     "
	@ li,085 PSAY STR0028	//"| Diretoria    "
	@ li,132 PSAY "|"

	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs01
	@ li,054 PSAY "|"
	@ li,070 PSAY "|"
	@ li,085 PSAY "|"
	@ li,132 PSAY "|"

	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs02
	@ li,054 PSAY "|"
	@ li,070 PSAY "|"
	@ li,085 PSAY "|"
	@ li,132 PSAY "|"

	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs03
	@ li,054 PSAY "|"
	@ li,070 PSAY "|"
	@ li,085 PSAY "|"
	@ li,132 PSAY "|"

	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs04
	@ li,054 PSAY "|"
	@ li,070 PSAY "|"
	@ li,085 PSAY "|"
	@ li,132 PSAY "|"



	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY STR0029	//"|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega."
	@ li,132 PSAY "|"
	if _desenv
		li++
		@ li,001 PSAY STR0029	//"|   PRODUTO PARA DESENVOLVIMENTO "
		@ li,132 PSAY "|"
	endif	
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o rodape do formulario e salta para a proxima folha³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRodape(Void)   			         					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                     				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape()
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,070 PSAY STR0030		//"Continua ..."
	@ li,132 PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,132 PSAY "|"
	li:=0
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec()
	Local nOrden, cCGC
	LOCAL cMoeda

	cMoeda := Iif(mv_par12<10,Str(mv_par12,1),Str(mv_par12,2))

	@ 01,001 PSAY "|"
	@ 01,002 PSAY Replicate("-",limite)
	@ 01,132 PSAY "|"
	@ 02,001 PSAY "|"
	@ 02,029 PSAY IIf(nOrdem>1,(STR0033)," ")		//" - continuacao"

	If mv_par08 == 1 
		@ 02,045 PSAY (STR0031)+" - "+GetMV("MV_MOEDA"+cMoeda) 	//"| P E D I D O  D E  C O M P R A S"
	Else
		@ 02,045 PSAY (STR0032)+" - "+GetMV("MV_MOEDA"+cMoeda)  //"| A U T. D E  E N T R E G A     "
	EndIf

	If ( Mv_PAR08==2 )
		@ 02,090 PSAY "|"
		@ 02,093 PSAY SC7->C7_NUMSC + "/" + SC7->C7_NUM  //    Picture PesqPict("SC7","c7_num")	
	Else
		@ 02,096 PSAY "|"
		@ 02,101 PSAY SC7->C7_NUM      Picture PesqPict("SC7","c7_num")
	EndIf

	@ 02,107 PSAY "/"+Str(nOrdem,1)
	@ 02,112 PSAY IIf(SC7->C7_QTDREEM>0,Str(SC7->C7_QTDREEM+1,2)+STR0034+Str(ncw,2)+STR0035,"")		//"a.Emissao "###"a.VIA"
	@ 02,132 PSAY "|"
	@ 03,001 PSAY "|"
	@ 03,003 PSAY SM0->M0_NOMECOM
	@ 03,045 PSAY "|"+Replicate("-",86)
	@ 03,132 PSAY "|"
	@ 04,001 PSAY "|"
	//@ 04,003 PSAY SM0->M0_ENDENT
	@ 04,003 PSAY Substr(SM0->M0_ENDENT,1,42)
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
	@ 04,045 PSAY "|"
	If ( cPaisLoc$"ARG|POR|EUA" )
		@ 04,047 PSAY Substr(SA2->A2_NOME,1,35)+"-"+SA2->A2_COD
	Else
		@ 04,047 PSAY Substr(SA2->A2_NOME,1,35)+"-"+SA2->A2_COD+(STR0036)+" " + SA2->A2_INSCR		//" I.E.: "
	EndIf
	@ 04,132 PSAY "|"
	@ 05,001 PSAY "|"
	@ 05,003 PSAY (STR0009)+Trans(SM0->M0_CEPENT,cCepPict)+" - "+Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT		//"CEP :"
	@ 05,045 PSAY "|"
	@ 05,047 PSAY SA2->A2_END    		Picture PesqPict("SA2","A2_END")
	@ 05,089 PSAY "-  "+Trim(SA2->A2_BAIRRO)	Picture "@!"
	@ 05,132 PSAY "|"
	@ 06,001 PSAY "|"
	@ 06,003 PSAY STR0037+"(62)39026161/39026162"    // SM0->M0_TEL		//"TEL: "
	@ 06,029 PSAY STR0038+"(62)39026169" //SM0->M0_FAX		//"FAX: "
	@ 06,045 PSAY "|"
	@ 06,047 PSAY Trim(SA2->A2_MUN)  Picture "@!"
	@ 06,069 PSAY SA2->A2_EST    		Picture PesqPict("SA2","A2_EST")
	@ 06,074 PSAY STR0009	//"CEP :"
	@ 06,081 PSAY SA2->A2_CEP    		Picture PesqPict("SA2","A2_CEP")

	dbSelectArea("SX3")
	nOrden = IndexOrd()
	dbSetOrder(2)
	dbSeek("A2_CGC")
	cCGC := Alltrim(X3TITULO())
	@ 06,093 PSAY cCGC //"CGC: "
	dbSetOrder(nOrden)

	dbSelectArea("SA2")
	@ 06,103 PSAY SA2->A2_CGC    		Picture PesqPict("SA2","A2_CGC")
	@ 06,132 PSAY "|"
	@ 07,001 PSAY "|"
	@ 07,003 PSAY (cCGC) + " "+ Transform(SM0->M0_CGC,cCgcPict)		//"CGC: "
	If cPaisLoc == "BRA"
		@ 07,031 PSAY (STR0041)+ InscrEst()		//"IE:"
	EndIf
	@ 07,045 PSAY "|"
	@ 07,047 PSAY sUBSTR(SC7->C7_CONTATO,1,12) Picture PesqPict("SC7","C7_CONTATO")
	@ 07,065 PSAY STR0042	//"FONE: "
	@ 07,071 PSAY Substr(SA2->A2_TEL,1,15)
	@ 07,088 PSAY (STR0038)	//"FAX: "
	@ 07,094 PSAY SUBSTR(SA2->A2_FAX,1,15)  Picture PesqPict("SA2","A2_FAX")
	@ 07,132 PSAY "|"
	@ 08,001 PSAY "|"
	@ 08,002 PSAY Replicate("-",limite)
	@ 08,132 PSAY "|"

	//|------------------------------------------------------------------------------------------------------------------------------------|
	//|Itm|  Codigo |Descricao do Material        |UM|   Quant.    |Valor Unitario|IPI|  Valor Total | Dt.Neces.|Lead Time| OBS/C.C | S.C. |
	//|---|---------|-----------------------------|--|-------------|--------------|---|--------------|----------|---------|---------|------|
	//|01 |05       |15                           |45|48           |62            |77 |81            |96        |105      |115      |125   |

	If mv_par08 == 1
		@ 09,001 PSAY "|"
		@ 09,002 PSAY STR0043	//"Itm|"
		@ 09,007 PSAY STR0044	//"Codigo      "
		If aTamSxg[1] != aTamSxg[3]
			@ 09,015 PSAY STR0045+SPACE(7) // "|Descricao do Material          "
		Else
			@ 09,015 PSAY STR0045	//"|Descricao do Material"
		Endif	
		If aTamSxg[1] != aTamSxg[3] // Centro de custo maior que o tamanho minimo (9), nao
			// Imprime o C.Custo 
			@ 09,044 PSAY STR0046	//"|UM|  Quant."
			if cPaisLoc <> "BRA"
				if mv_par15==2
					@ 09,061 PSAY "|Valor Unitario|       Valor Total |Entrega |         | S.C.           |"
				else
					@ 09,061 PSAY STR0057	//"|Valor Unitario|       Valor Total |Entrega |Lead Time| S.C.           |"
				endif
			else
				if mv_par15==2
					@ 09,061 PSAY "|Valor Unitario|IPI |  Valor Total |Entrega |         | S.C.           |"
				else
					@ 09,061 PSAY STR0055	//"|Valor Unitario|IPI |  Valor Total |Entrega |Lead Time| S.C.           |"
				endif
			EndIf
		Else
			@ 09,044 PSAY STR0046	//"|UM|  Quant."
			if cPaisLoc <> "BRA"
				if mv_par15==2
					@ 09,061 PSAY "|Valor Unitario|       Valor Total |Entrega |         | OBS/C.C | S.C. |"
				else
					@ 09,061 PSAY STR0056	//"|Valor Unitario|       Valor Total |Entrega |Lead Time| OBS/C.C | S.C. |"
				endif
			else
				if mv_par15==2
					@ 09,061 PSAY "|Valor Unitario|IPI |  Valor Total |Entrega |         | OBS/C.C | S.C. |"
				else
					@ 09,061 PSAY STR0047	//"|Valor Unitario|IPI |  Valor Total |Entrega |Lead Time| OBS/C.C | S.C. |"
				endif
			EndIf
		Endif	
		@ 10,001 PSAY "|"
		@ 10,002 PSAY Replicate("-",limite)
		@ 10,132 PSAY "|"
	Else
		@ 09,001 PSAY "|"
		@ 09,002 PSAY STR0043	//"Itm|"
		@ 09,009 PSAY STR0044	//"Codigo      "
		@ 09,021 PSAY STR0045	//"|Descricao do Material"
		@ 09,051 PSAY STR0046	//"|UM|  Quant."
		@ 09,068 PSAY STR0048	//"|Valor Unitario|  Valor Total   |Entrega | Numero da OP  "
		@ 09,132 PSAY "|"
		@ 10,001 PSAY "|"
		@ 10,002 PSAY Replicate("-",limite)
		@ 10,132 PSAY "|"
	EndIf
	dbSelectArea("SC7")
	li := 10
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R110Center³ Autor ³ Jose Lucas            ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Centralizar o Nome do Liberador do Pedido.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC1 := R110CenteR(ExpC2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Nome do Liberador                                 ³±±
±±³Parametros³ ExpC2 := Nome do Liberador Centralizado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R110Center(cLiberador)
Return( Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador) )

Static Function R110FIniPC(cPedido,cItem,cSequen)

	Local aArea		:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
	Local cValid		:= ""
	Local nPosRef		:= 0
	Local nItem		:= 0
	Local cItemDe		:= IIf(cItem==Nil,"",cItem)
	Local cItemAte	:= IIf(cItem==Nil,Repl("Z",Len(SC7->C7_ITEM)),cItem)
	Local cRefCols	:= ""

	cSequen := If( cSequen == nil, "", cSequen ) ;
	//cFiltro := If( cFiltro == nil, "", cFiltro ) ;

	dbSelectArea("SC7")
	dbSetOrder(1)
	If dbSeek(xFilial("SC7")+cPedido+cItemDe+Alltrim(cSequen))
		MaFisEnd()
		MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})

		While !Eof() .AND.  SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido .AND.  SC7->C7_ITEM <= cItemAte .AND.  (Empty(cSequen) .OR.  cSequen == SC7->C7_SEQUEN)


			/*		If &cFiltro
			dbSelectArea("SC7")
			dbSkip()
			Loop
			EndIf*/


			nItem++
			MaFisIniLoad(nItem)
			dbSelectArea("SX3")
			dbSetOrder(1)
			dbSeek("SC7")
			While !EOF() .AND.  (X3_ARQUIVO == "SC7")
				cValid	:= StrTran(UPPER(SX3->X3_VALID)," ","")
				cValid	:= StrTran(cValid,"'",'"')
				If "MAFISREF" $ cValid
					nPosRef  := AT('MAFISREF("',cValid) + 10
					cRefCols := Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )

					MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
				EndIf
				dbSkip()
			End
			MaFisEndLoad(nItem,2)
			dbSelectArea("SC7")
			dbSkip()
		End
	EndIf

	RestArea(aAreaSC7)
	RestArea(aArea)

Return .T. 


static function Transportadora(cNum)
	cAlias := Alias()

	DbSelectArea("SZ1")

	if DbSeek(xFilial("SZ1")+cNum, .F. )
		cNumTransp := SZ1->Z1_TRANSP

		DbSelectArea("SA4")
		DbSeek(xFilial("SA4")+cNumTransp, .F. )

		cNomTransp := AllTrim(SA4->A4_NREDUZ)
	else
		cNomTransp := "E.T. MARTINS"
	endif

	DbSelectArea(cAlias)
return (cNomTransp)

//Stephen Noel de Melo - Solicitado Pelo Sr. Jailton 26/11/2018
static function _querys()

Local emiss := ''

emiss:= DtoS(MonthSub(Date(),6))
Alert(emiss)

	_cquery:=" SELECT" 
	_cquery+=" ROUND((SUM(SD3.D3_QUANT)/6),2) CONSUMO "
	_cquery+=" FROM SD3010 SD3"
	_cquery+=" WHERE SD3.D_E_L_E_T_ = ' '"
	_cquery+=" AND SD3.D3_COD = '"+SC7->C7_PRODUTO+"'"
	_cquery+=" AND SD3.D3_ESTORNO = ' '"
	_cquery+=" AND sd3.D3_TM >= '500'"
	_cquery+=" AND SD3.D3_CF >='RE0'"
	_cquery+=" AND SD3.D3_CF <= 'RE3'"
	_cquery+=" AND SD3.D3_EMISSAO >= '"+emiss+"'"

	_cquery:=changequery(_cquery)
	tcquery _cquery new alias "TMP1"
	Memowrite('C:\stephen\vit091.txt', _cquery)

return


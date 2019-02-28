#INCLUDE "VIT069.CH"
#INCLUDE "RWMAKE.CH"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT069   ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao da Relacao de Divergencias de Pedidos de Compras   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ VIT069 (void)                                              ³±±
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
±±³Programador   ³ Data   ³ BOPS ³  Motivo da Alteracao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos Simidu ³24/06/98³XXXXXX³Acerto lay-out nro. NFs p/12 bytes.     ³±±
±±³Edson  M.     ³04/11/98³XXXXXX³Acerto no lay-out p/ o ano 2000.        ³±±
±±³BRUNO         ³01/12/98³MELHOR³Inclusao das funcoes impr130loc e       |±±
±±³              ³        ³      ³ImprLinhaRem para o tratamento dos remi-|±±
±±³              ³        ³      ³tos da versao argentina.                |±±
±±³Edson   M.    ³30/03/99³XXXXXX³Passar o tamanho na SetPrint.           ³±±
±±³Patricia Sal. ³20/12/99³XXXXXX³Acerto LayOut,Fornec.c/20 pos. e Lj.c/ 4³±±
±±³              ³        ³      ³pos.;Troca da PesqPictQt() p/PesqPict().³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
user function vit069()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL titulo := OemToAnsi(STR0001)	//"Relacao de Divergencias de Pedidos de Compras"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Emissao da Relacao de Itens para Compras"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"com divergencias"
LOCAL cDesc3 := ""
LOCAL cString:= "SD1"
LOCAL cCond := ""
LOCAL Tamanho := "M"

Static aTamSXG, aTamSXG2

PRIVATE aReturn := { STR0004, 1,STR0005, 2, 2, 1, "",0 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="VIT069"
PRIVATE aLinha  := { } , nLastKey := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li       := 80
m_pag    := 1
wnrel    := "VIT069"+Alltrim(cusername)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cperg:="PERGVIT069"
_pergsx1()
pergunte(cperg,.f.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01	        // a partir da data de recebimento        ³
//³ mv_par02           // ate a data de recebimento              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

// Verif. conteudo das Variaveis Grupo de Fornec. (001) e Loja (002)
aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

RptStatus({|lEnd| R130Imp(@lEnd,wnrel,cString,Tamanho)},Titulo)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R130IMP  ³ Autor ³ Cristina M. Ogura     ³ Data ³ 10.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ VIT069                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R130Imp(lEnd,wnrel,cString,Tamanho)
Local cabec1,cabec2,cabec3
Local limite := 132
Local cbCont := 0

nTipo := IIF(aReturn[4]==1,15,18)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := STR0006	//"DIVERGENCIAS ENTRE NF DE COMPRAS E PEDIDOS"
cabec1 := STR0007	//" NOTA   EMISSAO CODIGO LJ  FORNECEDOR                    PRODUTO         UM    QUANTIDADE           VALOR UNITARIO  DT.ENTREGA COND."
cabec2 := STR0008	//"PEDIDO"

// Se nao for LayOut minimo, considerar o maximo
If aTamSXG[1] != aTamSXG[3]
	cabec1 := STR0012 //     "NOTA         EMISSAO    CODIGO               LJ   FORNECEDOR       PRODUTO         UM QUANTIDADE   VALOR UNITARIO   DT.ENTREGA COND."
	
	//                        xxxxxxxxxxxx xxxxxxxxxx xxxxxxxxxxxxxxxxxxxx xxxx 1234567890123456 xxxxxxxxxxxxxxx xx xxxxxxxxxxxx xxxxxxxxxxxxxxxx xxxxxxxxxx xxx
	//                        0         1         2         3         4         5         6         7         8         9        10        11       12        13
	//                        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345679012345678901234567890123
	
Else
	cabec1 := STR0007 //" NOTA         EMISSAO    CODIGO LJ FORNECEDOR                       PRODUTO         UM QUANTIDADE   VALOR UNITARIO   DT.ENTREGA COND."
	//                        xxxxxxxxxxxx xxxxxxxxxx xxxxxx xx 12345678901234567890123456789012 xxxxxxxxxxxxxxx xx xxxxxxxxxxxx xxxxxxxxxxxxxxxx xxxxxxxxxx xxx
	//                        0         1         2         3         4         5         6         7         8         9        10        11       12        13
	//                        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345679012345678901234567890123
	
Endif

If cPaisloc=="BRA"
	Impr130(titulo,cabec1,cabec2,nomeprog,nTipo,tamanho,lEnd)
Else
	Impr130Loc(titulo,cabec1,cabec2,nomeprog,nTipo,tamanho,lEnd)
	
EndIf

IF li !=80
	li++
	@li,000 PSAY Replicate("-",limite)
	roda(CbCont,"DIVERGENCIAS"," ")
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
Set Filter To
dbSetOrder(1)

dbSelectArea("SF1")
dbSetOrder(1)

dbSelectArea("SC7")
dbSetOrder(1)

dbSelectArea("SA2")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPR130  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatorio                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ VIT069                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impr130(titulo,cabec1,cabec2,nomeprog,nTipo,tamanho,lEnd)
LOCAL dDataSav
LOCAL lRet
LOCAL dData  := ctod("")

dbSelectArea("SD1")
dbGotop()
dbSetOrder(1)
dbSeek(xFilial(),.F.)

SetRegua(RecCount())

While !Eof() .and. D1_FILIAL == xFilial()
	
	If lEnd
		@PROW()+1,001 PSAY STR0009		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	
	If D1_TIPO $ "IDBCP"
		dbSkip()
		Loop
	Endif
	
	If D1_DTDIGIT < mv_par01 .Or. D1_DTDIGIT > mv_par02
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
		dData := SF1->F1_DTDIGIT
	Else
		dData := Ctod("")
	Endif
	
	cCond := ""
	dbSelectArea("SC7")
	dbSetOrder(4)
	If dbSeek(xFilial()+SD1->D1_COD+SD1->D1_PEDIDO+SD1->D1_ITEMPC,.F.)
		dDataSav  := dDataBase
		dDataBase := SD1->D1_DTDIGIT
		cCond		 := SC7->C7_COND
		If SD1->D1_ITEMPC != SC7->C7_ITEM
			While !Eof() .And. SC7->C7_PRODUTO == SD1->D1_COD .And.;
				SC7->C7_FORNECE == SD1->D1_FORNECE .And.;
				SC7->C7_LOJA == SD1->D1_LOJA .And.;
				SC7->C7_NUM == SD1->D1_PEDIDO .And.;
				SC7->C7_ITEM != SD1->D1_ITEMPC
				dbSelectArea("SC7")
				dbSkip()
				Loop
			End
		Endif
		
		lRet := .F.
		IF SD1->D1_QUANT == SC7->C7_QUANT .AND.;
			SD1->D1_VUNIT == IIf(Empty(SC7->C7_REAJUSTE),xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,1,SF1->F1_EMISSAO,,SC7->C7_TXMOEDA),Formula(SC7->C7_REAJUSTE)) .AND.;
			SD1->D1_DTDIGIT - SC7->C7_DATPRF<=mv_par03 .AND.;
			SF1->F1_COND == SC7->C7_COND
			If SD1->D1_LOJA == SC7->C7_LOJA
				lRet := .T.
			EndIf
			If lRet
		        dDataBase := dDataSav
				dbSelectArea("SD1")
				dbSkip()
				Loop
			EndIf
		Endif
		
		dDataBase := dDataSav
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		ImprLinha(1,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond)
	Else
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA)
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		ImprLinha(2,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData)
	Endif
	dbSelectArea("SD1")
	dbSkip()
End

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IMPRLINHA ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da Linha de Detalhe                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ VIT069                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImprLinha(nFlag,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond)
LOCAL dDataSav
LOCAL nPosLoja := 31
LOCAL nPosNome := 34
LOCAL nTamNome := 32

// Se Nao for LayOut minimo, considerar o maximo (Fornec. com 20 pos. e loja com 4 pos.)
If aTamSXG[1] != aTamSXG[3]
	nPosLoja += aTamSXG[4] - aTamSXG[3]
	nPosNome += ((aTamSXG[4] - aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
	nTamNome -= ((aTamSXG[4] - aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
Endif
If nFlag == 1
	@ li,000 PSAY SD1->D1_DOC
	@ li,013 PSAY SD1->D1_EMISSAO
	@ li,024 PSAY SD1->D1_FORNECE
	@ li,nPosLoja PSAY SD1->D1_LOJA
	@ li,nPosNome PSAY IIF(EMPTY(SA2->A2_NREDUZ),SUBS(SA2->A2_NOME,1,nTamNome),Subs(SA2->A2_NREDUZ,1,nTamNome))
	@ li,067 PSAY SD1->D1_COD
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+SD1->D1_COD)
	
	@ li,083 PSAY SB1->B1_UM
	@ li,086 PSAY SD1->D1_QUANT   Picture PesqPict("SD1","D1_QUANT",12)
	@ li,099 PSAY SD1->D1_VUNIT   Picture PesqPict("SD1","D1_VUNIT",16)
	@ li,116 PSAY IIF(!empty(dData), dData , "")
	@ li,129 PSAY SF1->F1_COND		Picture PesqPict("SF1","F1_COND",3)
	
	Li++
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	dDataSav  := dDataBase
	dDataBase := SD1->D1_DTDIGIT
	If cPaisLoc == "BRA"
		@ li,000 PSAY "PED.  " +SC7->C7_NUM
	Else
		@ li,000 PSAY SC7->C7_NUM
	EndIf
	@ li,013 PSAY SC7->C7_EMISSAO
	@ li,024 PSAY SC7->C7_FORNECE
	@ li,nPosLoja PSAY SC7->C7_LOJA
	@ li,nPosNome PSAY IIF(EMPTY(SA2->A2_NREDUZ),SUBS(SA2->A2_NOME,1,nTamNome),Subs(SA2->A2_NREDUZ,1,nTamNome))
	@ li,067 PSAY SC7->C7_PRODUTO
	@ li,083 PSAY SB1->B1_UM
	@ li,086 PSAY SC7->C7_QUANT     Picture PesqPict("SC7","C7_QUANT",12)
	@ li,099 PSAY IIf(Empty(SC7->C7_REAJUSTE),xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,1,SF1->F1_EMISSAO,,SC7->C7_TXMOEDA),Formula(SC7->C7_REAJUSTE))  Picture PesqPict("SC7","C7_PRECO",16)
	@ li,116 PSAY SC7->C7_DATPRF
	@ li,129 PSAY cCond				  Picture PesqPict("SC7","C7_COND",3)
	dDataBase := dDataSav
	If cPaisLoc <> "BRA"
		Li++
	Else
		Li+=2
	EndIf
Else
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	@ li,000 PSAY SD1->D1_DOC
	@ li,013 PSAY SD1->D1_DTDIGIT
	@ li,024 PSAY SD1->D1_FORNECE
	@ li,nPosLoja PSAY SD1->D1_LOJA
	@ li,nPosNome PSAY IIF(EMPTY(SA2->A2_NREDUZ),SUBS(SA2->A2_NOME,1,nTamNome),Subs(SA2->A2_NREDUZ,1,nTamNome))
	@ li,067 PSAY SD1->D1_COD
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+SD1->D1_COD)
	
	@ li,083 PSAY SB1->B1_UM
	@ li,086 PSAY SD1->D1_QUANT     Picture PesqPict("SD1","D1_QUANT",12)
	@ li,099 PSAY SD1->D1_VUNIT     Picture PesqPict("SD1","D1_VUNIT",16)
	@ li,116 PSAY IIF(!empty(dData), dData , "")
	
	Li++
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	@ li,000 PSAY STR0010	//"Nao ha' pedido de compra colocado"
	If cPaisLoc <> "BRA"
		Li++
	Else
		Li+=2
	EndIf
Endif

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ impr130loc Autor ³ Bruno Sobieski        ³ Data ³ 27.11.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatorio                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ VIT069                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impr130Loc(titulo,cabec1,cabec2,nomeprog,nTipo,tamanho,lEnd)
LOCAL dDataSav,lRet

LOCAL aRemped := array(8) 
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  [1]=indica se existe remito;[2]=numero do remito;[3]=item do remito;           ³
//³	 [4]=indica se existe pedido;[5]=numero do pedido;[6]=item do pedido³
//³	 [7]=produto no remito;[8]=produto no pedido                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

dbSelectArea("SD1")
dbGotop()
dbSetOrder(1)
dbSeek(xFilial(),.F.)

SetRegua(RecCount())

While !Eof() .and. D1_FILIAL == xFilial()
	
	If lEnd
		@PROW()+1,001 PSAY STR0009		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	
	If D1_TIPO $ "IDBCP"
		dbSkip()
		Loop
	Endif
	
	If D1_DTDIGIT < mv_par01 .Or. D1_DTDIGIT > mv_par02
		dbSkip()
		Loop
	Endif
	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
		dData := SF1->F1_DTDIGIT
	Endif
	
	cCond := ""
	
    //Verifica se existe remito e pedido retornando na area e indices selecionados
    aRemped := Existremped("SC7",4)
    //---

	If aRemped[4] // . . . se houver pedido
		dDataSav  := dDataBase
		dDataBase := SD1->D1_DTDIGIT
		cCond		 := SC7->C7_COND
		If aRemped[6] != SC7->C7_ITEM
			While !Eof() .And. SC7->C7_PRODUTO == SD1->D1_COD .And.;
				SC7->C7_FORNECE == SD1->D1_FORNECE .And.;
				SC7->C7_LOJA == SD1->D1_LOJA .And.;
				SC7->C7_NUM == aRemped[5] .And.;
				SC7->C7_ITEM != aRemped[6]
				dbSelectArea("SC7")
				dbSkip()
				Loop
			End
		Endif
		
		lRet := .F.
		IF SD1->D1_QUANT == SC7->C7_QUANT .AND.;
			SD1->D1_VUNIT == IIf(Empty(SC7->C7_REAJUSTE),SC7->C7_PRECO,Formula(SC7->C7_REAJUSTE)) .AND.;
			SD1->D1_DTDIGIT == SC7->C7_DATPRF .AND.;
			SF1->F1_COND == SC7->C7_COND
			If SD1->D1_LOJA == SC7->C7_LOJA
				lRet := .T.
			EndIf
			If lRet
		        dDataBase := dDataSav
				dbSelectArea("SD1")
				dbSkip()
				Loop
			EndIf
		Endif
		
		dDataBase := dDataSav
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		ImprLinha(1,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond)
	Else
		ImprLinha(2,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond)
	Endif
	dbSelectArea("SCM")
	dbSetOrder(1)
	If dbSeek(xFilial()+SD1->D1_REMITO+SD1->D1_ITEMREM,.F.)
		dDataSav  := dDataBase
		dDataBase := SD1->D1_DTDIGIT
		If SD1->D1_ITEMREM != SCM->CM_ITEM
			While !Eof() .And. SCM->CM_PRODUTO == SD1->D1_COD .And.;
				SCM->CM_FORNECE == SD1->D1_FORNECE .And.;
				SCM->CM_LOJA == SD1->D1_LOJA .And.;
				SCM->CM_REMITO == SD1->D1_REMITO .And.;
				SCM->CM_ITEM == SD1->D1_ITEMREM .And.;
				SD1->D1_QUANT == SCM->CM_QUANT .AND.;
				SD1->D1_DTDIGIT == SCM->CM_DTVALID
				dbSelectArea("SCM")
				dbSkip()
				Loop
			End
		Endif
		//lRet := .F.
		/*IF SD1->D1_QUANT == SCM->CM_QUANT .AND.;
		SD1->D1_DTDIGIT == SCM->CM_DTVALID
		
		If SD1->D1_LOJA == SCM->CM_LOJA
		lRet := .T.
		EndIf
		If lRet
		dbSelectArea("SD1")
		dbSkip()
		Loop
		EndIf
		Endif
		*/
		dDataBase := dDataSav
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SCM->CM_FORNECE+SCM->CM_LOJA)
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		ImprLinhaRem(1,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond)
	Else
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA)
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		ImprLinhaRem(2,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData)
	Endif
	dbSelectArea("SD1")
	dbSkip()
End
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³IMPRLINHARemAutor ³ Bruno Sobieski        ³ Data ³ 30.11.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da Linha de Detalhe do remito                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ VIT069                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImprLinhaRem(nFlag,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond)
LOCAL dDataSav
LOCAL nPosLoja := 29
LOCAL nPosNome := 32
LOCAL nTamNome := 24

// Se Nao for LayOut minimo, considerar o maximo (Fornec. com 20 pos. e loja com 4 pos.)
If aTamSXG[1] != aTamSXG[3]
	nPosLoja += aTamSXG[4] - aTamSXG[3]
	nPosNome += ((aTamSXG[4] - aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
	nTamNome -= ((aTamSXG[4] - aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
Endif


If nFlag == 1
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	dDataSav  := dDataBase
	dDataBase := SD1->D1_DTDIGIT
	@ li,000 PSAY "REM "+Subs(SCM->CM_REMITO,5,8)
	@ li,013 PSAY SCM->CM_EMISSAO
	@ li,022 PSAY SCM->CM_FORNECE
	@ li,nPosLoja PSAY SCM->CM_LOJA
	@ li,nPosNome PSAY IIF(EMPTY(SA2->A2_NREDUZ),SUBS(SA2->A2_NOME,1,nTamNome),Subs(SA2->A2_NREDUZ,1,nTamNome))
	@ li,067 PSAY SCM->CM_PRODUTO
	@ li,083 PSAY SB1->B1_UM
	@ li,086 PSAY SCM->CM_QUANT     Picture PesqPict("SCM","CM_QUANT",12)
	@ li,099 PSAY IIf(Empty(SC7->C7_REAJUSTE),SC7->C7_PRECO,Formula(SC7->C7_REAJUSTE))  Picture PesqPict("SC7","C7_PRECO",16)
	@ li,116 PSAY SCM->CM_DTvalid
	@ li,129 PSAY cCond				  Picture PesqPict("SC7","C7_COND",3)
	dDataBase := dDataSav
	Li+=2
Else
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	@ li,000 PSAY STR0011	//"No hay remito colocado          "
	Li+=2
Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ ËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExistrempedºAutor  ³Leandro cg          º Data ³  08/20/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍ ÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica existencia de remito e pedido de compra             º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ ¹±±
±±ºUso       ³ VIT069                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Existremped(cAlias,nIndex)
local aRet := array(8) 
              
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ - aRet                                                                                                     |
  |                                                                                                            |
  |	[1]=indica se existe remito;[2]=numero do remito;[3]=item do remito;                                       ³
//³ [4]=indica se existe pedido;[5]=numero do pedido;[6]=item do pedido                                        ³
//³ [7]=produto no remito;[8]=produto no pedido                                                                ³
//³                                                                                                            ³
//³ Esta funcao verifica a existencia de Remito e pedido para uma Nota Fiscal, setando e devolvendo a variavel ³
//³ aRet com o conteudo descrito acima                                                                         |
  |                                                                                                            ³
//³  - cAlias = area selecionada no momento em que a funcao e chamada                                          |
  |  - nIndex = indice utilizado no momento em que a funcao e chamada                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

    //Verifica se a Nota possui Remito             
    If SD1->D1_REMITO <> "" 
    	aRet[1] := .T.
    	aRet[2] := SD1->D1_REMITO
    	aRet[3] := SD1->D1_ITEMREM
    	aRet[7] := SD1->D1_COD
    	dbSelectArea("SCM")
        dbSetOrder(1)
        dbSeek(xFilial()+aRet[2]+aRet[3],.F.)
    Else
        aRet[1] := .F.
        aRet[2] := 0
        aret[3] := 0
        aRet[7] := ""
    Endif      
    //---

    //Se houver remito, verifica se existe pedido atraves do remito ...
  	dbSelectArea("SC7")
    dbSetOrder(4)
   	If dbSeek(xFilial()+SD1->D1_COD+SD1->D1_PEDIDO+SD1->D1_ITEMPC,.F.) .OR.;
   	   (aRet[1] .And. dbSeek(xFilial()+SCM->CM_PRODUTO+SCM->CM_PEDIDO+SCM->CM_ITEMPED,.F.))
       	aRet[4] := .T.
       	aRet[5] := C7_NUM
       	aRet[6] := C7_ITEM
       	aRet[8] := C7_PRODUTO
   	Else
   	  	aRet[4] := .F.
       	aRet[5] := 0
       	aRet[6] := 0    
       	aRet[8] := ""    
    Endif
    //--- (Isto e feito pelo fato de que nao e gravado o numero do pedido na nota quando a mesma possui remito)
         
    //Retorna area e indice
    dbSelectArea(cAlias)
    dbSelectArea(nIndex)
    //---

return(aRet)


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do data receb.     ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data receb.  ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Dias de tolerancia ?","mv_ch3","N",03,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

#INCLUDE "VIT072.CH"
#INCLUDE "RWMAKE.CH"
/*
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    Ё MATR540  Ё Autor Ё Claudinei M. Benzi    Ё Data Ё 13.04.92 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao Ё Relatorio de Comissoes                                     Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё Generico                                                   Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ЁVersao    Ё 1.0                                                        Ё╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
*/





user Function vit072()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LOCAL wnrel
LOCAL titulo := STR0001  //"Relatorio de ComissДes"
LOCAL cDesc1 := STR0002  //"Emiss└o do relatorio de ComissДes."
LOCAL tamanho:="G"
LOCAL limite :=220
LOCAL cString:="SE3"
LOCAL cExt 	 := ""
LOCAL cAliasAnt := Alias()
LOCAL cOrdemAnt := IndexOrd()
LOCAL nRegAnt   := Recno()
PRIVATE aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="VIT072"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="PERGVIT072"
_pergsx1()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica as perguntas selecionadas                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Pergunte(cperg,.F.)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para parametros                         Ё
//Ё mv_par01        	// Pela <E>missao,<B>aixa ou <A>mbos        Ё
//Ё mv_par02        	// A partir da data                         Ё
//Ё mv_par03        	// Ate a Data                               Ё
//Ё mv_par04 	    	// Do Vendedor                              Ё
//Ё mv_par05	     	// Ao Vendedor                              Ё
//Ё mv_par06	     	// Quais (a Pagar/Pagas/Ambas)              Ё
//Ё mv_par07	     	// Incluir Devolucao ?                      Ё
//Ё mv_par08	     	// Qual moeda                               Ё
//Ё mv_par09	     	// Comissao Zerada ?                        Ё
//Ё mv_par10	     	// Abate IR Comiss                          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia controle para a funcao SETPRINT                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
wnrel := "VIT072"+Alltrim(cusername)
wnrel := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,"","",.F.,"",.F.,Tamanho)

If nLastKey==27
	Set Filter to
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey ==27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C540Imp(@lEnd,wnRel,cString)},Titulo)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Retorna para area anterior, indice anterior e registro ant.  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea(caliasAnt)
DbSetOrder(cOrdemAnt)
DbGoto(nRegAnt)
Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё C540IMP  Ё Autor Ё Rosane Luciane Chene  Ё Data Ё 09.11.95 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Chamada do Relatorio                                       Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё MATR540			                                            Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function C540Imp(lEnd,WnRel,cString)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LOCAL CbCont,cabec1,cabec2
LOCAL tamanho := "G"
LOCAL limite  := 220
LOCAL nomeprog:= "VIT072"
LOCAL imprime := .T.
LOCAL cPict   := ""
LOCAL cTexto,j:=0,nTipo:=0
LOCAL cCodAnt,nCol:=0
LOCAL nAc1:=0,nAc2:=0,nAg1:=0,nAg2:=0,nAc3:=0,nAg3:=0,lFirstV:=.T.
LOCAL nTregs,nMult,nAnt,nAtu,nCnt,cSav20,cSav7
LOCAL lContinua:=.T.
LOCAL cNFiscal:=""
LOCAL aCampos :={}
LOCAL lImpDev := .f.
LOCAL cBase  := ""
LOCAL cNomArq, cCondicao, cFilialSE1, cFilialSE3, cChave, cFiltroUsu
Local nDecs  := GetMv("MV_CENT"+(IIF(mv_par08 > 1 , STR(mv_par08,1),"")))
Local	nBasePrt:=0, nComPrt:=0


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para Imporessao do Cabecalho e Rodape   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
imprime  := .T.

nTipo := IIF(aReturn[4]==1,15,18)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Definicao dos cabecalhos                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If mv_par01 == 1
	titulo := OemToAnsi(STR0005)+OemToAnsi(STR0006)+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1)) //"RELATORIO DE COMISSOES "###"(PGTO PELA EMISSAO)"
Elseif mv_par01 == 2
	titulo := OemToAnsi(STR0005)+OemToAnsi(STR0007)+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES "###"(PGTO PELA BAIXA)"
Else
	titulo := OemToAnsi(STR0008)+ " - " + GetMv("MV_MOEDA" + STR(mv_par08,1))  //"RELATORIO DE COMISSOES"
Endif

cabec1:=OemToAnsi(STR0009)	//"PRF NUMERO   PARC. CODIGO DO              LJ  NOME                                 DT.BASE     DATA        DATA        DATA       NUMERO          VALOR           VALOR      %           VALOR    TIPO"
cabec2:=OemToAnsi(STR0010)	//"    TITULO         CLIENTE                                                         COMISSAO    VENCTO      BAIXA       PAGTO      PEDIDO         TITULO            BASE               COMISSAO   COMISSAO"
									// XXX XXXXXXxxxxxx X XXXXXXxxxxxxxxxxxxxx   XX  012345678901234567890123456789012345 XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx  XX/XX/XXxx XXXXXX 12345678901,23  12345678901,23  99.99  12345678901,23     X       AJUSTE
									// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
									// 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta condicao para filtro do arquivo de trabalho            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

DbSelectArea("SE3")	// Posiciona no arquivo de comissoes
DbSetOrder(2)			// Por Vendedor
cFilialSE3 := xFilial()
cNomArq :=CriaTrab("",.F.)

cCondicao := "SE3->E3_FILIAL=='" + cFilialSE3 + "'"
cCondicao += ".And.SE3->E3_VEND>='" + mv_par04 + "'"
cCondicao += ".And.SE3->E3_VEND<='" + mv_par05 + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)>='" + DtoS(mv_par02) + "'"
cCondicao += ".And.DtoS(SE3->E3_EMISSAO)<='" + DtoS(mv_par03) + "'"
If mv_par01 == 1
	cCondicao += ".And.SE3->E3_BAIEMI!='B'"  // Baseado pela emissao da NF
Elseif mv_par01 == 2
	cCondicao += " .And.SE3->E3_BAIEMI=='B'"  // Baseado pela baixa do titulo
Endif
If mv_par06 == 1 		// Comissoes a pagar
	cCondicao += ".And.Dtos(SE3->E3_DATA)=='"+Dtos(Ctod(""))+"'"
ElseIf mv_par06 == 2 // Comissoes pagas
	cCondicao += ".And.Dtos(SE3->E3_DATA)!='"+Dtos(Ctod(""))+"'"
Endif
If mv_par09 == 2 		// Nao Inclui Comissoes Zeradas
   cCondicao += ".And.SE3->E3_COMIS<>0"
EndIf
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria expressao de filtro do usuario                          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If ( ! Empty(aReturn[7]) )
	cFiltroUsu := &("{ || " + aReturn[7] +  " }")
Else
	cFiltroUsu := { || .t. }
Endif
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria arquivo de trabalho                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cChave := IndexKey()
cNomArq :=CriaTrab("",.F.)
IndRegua("SE3",cNomArq,cChave,,cCondicao, OemToAnsi(STR0016)) //"Selecionando Registros..."
nIndex := RetIndex("SE3")
DbSelectArea("SE3")
#IFNDEF TOP
	DbSetIndex(cNomArq+OrdBagExT())
#ENDIF
DbSetOrder(nIndex+1)

nAg1 := nAg2 := 0

SetRegua(RecCount())		// Total de Elementos da regua
DbGotop()
While !Eof()
	IF lEnd
		@Prow()+1,001 PSAY OemToAnsi(STR0011)  //"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIF
	IncRegua()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Processa condicao do filtro do usuario                       Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If ! Eval(cFiltroUsu)
		Dbskip()
		Loop
	Endif
	
	nAc1   := nAc2 := nAc3 := 0
	lFirstV:= .T.
	cVend  := SE3->E3_VEND
	
	While !Eof() .AND. SE3->E3_VEND == cVend
		IncRegua()
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Processa condicao do filtro do usuario                       Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If ! Eval(cFiltroUsu)
			Dbskip()
			Loop
		Endif
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Seleciona o Codigo do Vendedor e Imprime o seu Nome          Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		IF lFirstV
			dbSelectArea("SA3")
			dbSeek(xFilial()+SE3->E3_VEND)
			@li, 00 PSAY OemToAnsi(STR0012) + SE3->E3_VEND + " " + A3_NOME //"Vendedor : "
			li+=2
			dbSelectArea("SE3")
			lFirstV := .F.
		EndIF
		
		@li, 00 PSAY SE3->E3_PREFIXO
		@li, 04 PSAY SE3->E3_NUM
		@li, 17 PSAY SE3->E3_PARCELA
		@li, 19 PSAY SE3->E3_CODCLI
		@li, 42 PSAY SE3->E3_LOJA
		dbSelectArea("SA1")
		dbSeek(xFilial()+SE3->E3_CODCLI+SE3->E3_LOJA)
		@li, 46 PSAY Substr(A1_NOME,1,35)
		dbSelectArea("SE3")
		@li, 83 PSAY SE3->E3_EMISSAO
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO)
		nVlrTitulo := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
		dVencto    := SE1->E1_VENCTO
		dBaixa     := SE1->E1_BAIXA
		If Eof()
			dbSelectArea("SF2")
			dbSetorder(1)
			dbSeek(xFilial()+SE3->E3_NUM+SE3->E3_PREFIXO)
			If ( cPaisLoc=="BRA" )
				nVlrTitulo := Round(xMoeda(F2_VALMERC+F2_VALIPI+F2_FRETE+F2_SEGURO,1,mv_par08,SF2->F2_EMISSAO,nDecs+1),nDecs)
			Else
				nVlrTitulo := Round(xMoeda(F2_VALFAT,SF2->F2_MOEDA,mv_par08,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA),nDecs)
			Endif
			dVencto    := " "
			dBaixa     := " "
			If Eof()
				nVlrTitulo := 0
				dbSelectArea("SE1")
				dbSetOrder(1)
				cFilialSE1 := xFilial()
				dbSeek(cFilialSE1+SE3->E3_PREFIXO+SE3->E3_NUM)
				While ( !Eof() .And. SE3->E3_PREFIXO == SE1->E1_PREFIXO .And.;
						SE3->E3_NUM == SE1->E1_NUM .And.;
						SE3->E3_FILIAL == cFilialSE1 )
					If ( SE1->E1_TIPO == SE3->E3_TIPO  .And. ;
						SE1->E1_CLIENTE == SE3->E3_CODCLI .And. ;
						SE1->E1_LOJA == SE3->E3_LOJA )
						nVlrTitulo += Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
						dVencto    := " "
						dBaixa     := " "
					EndIf
					dbSelectArea("SE1")
					dbSkip()
				EndDo
			EndIf
		Endif

		//Precisso destes valores para pasar como parametro na funcao TM(), e como 
		//usando a xmoeda direto na impressao afetaria a performance (deveria executar
		//duas vezes, uma para imprimir e outra para pasar para a picture), elas devem]
		//ser inicializadas aqui. Bruno.

		nBasePrt	:=	Round(xMoeda(SE3->E3_BASE ,1,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)
		nComPrt	:=	Round(xMoeda(SE3->E3_COMIS,1,MV_PAR08,SE1->E1_EMISSAO,nDecs+1),nDecs)

		@ li, 95 PSAY dVencto
		@ li,107 PSAY dBaixa
		dbSelectArea("SE3")
		@ li,119 PSAY SE3->E3_DATA
		@ li,130 PSAY SE3->E3_PEDIDO	Picture "@!"
		@ li,137 PSAY nVlrTitulo		Picture tm(nVlrTitulo,14,nDecs)
		@ li,153 PSAY nBasePrt 			Picture tm(nBasePrt,14,nDecs)
		@ li,169 PSAY SE3->E3_PORC		Picture tm(SE3->E3_PORC,6)
		@ li,176 PSAY nComPrt			Picture tm(nComPrt,14,nDecs)
		@ li,195 PSAY SE3->E3_BAIEMI

		nAc1 += nBasePrt
		nAc2 += nComPrt
		nAc3 += nVlrTitulo

		li++
		dbSkip()
	EndDo
	
	If (nAc1+nAc2+nAc3) != 0
		li++
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF


		@ li, 00  PSAY OemToAnsi(STR0013)  //"TOTAL DO VENDEDOR --> "
		@ li,137  PSAY nAc3 	PicTure tm(nAc3,15,nDecs)
		@ li,153  PSAY nAc1 	PicTure tm(nAc1,15,nDecs)
		If nAc1 != 0
			@ li, 169 PSAY (nAc2/nAc1)*100   PicTure "999.99"
		Endif
		@ li, 176  PSAY nAc2 PicTure tm(nAc2,14,nDecs)
		li++
		If mv_par10 > 0 .And. (nAc2 * mv_par10 / 100) > GetMV("MV_VLRETIR") //IR
			@ li, 00  PSAY OemToAnsi(STR0015)  //"TOTAL DO IR       --> "
			@ li, 176  PSAY (nAc2 * mv_par10 / 100) PicTure tm(nAc2 * mv_par10 / 100,14,nDecs)
			li ++                                        
			@ li,00 PSAY "TOTAL LIQUIDO     --> "   
			@ li, 176  PSAY nac2-(nAc2 * mv_par10 / 100)   PicTure tm((nAc2 * mv_par10 / 100),14,nDecs)
			li ++
		EndIf
		@ li, 00  PSAY __PrtThinLine()
		li := 60
	EndIF
	
	dbSelectArea("SE3")
	nAg1 += nAc1
	nAg2 += nAc2
	nAg3 += nAc3
EndDo

IF (nAg1+nAg2+nAg3) != 0
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)


	@li,  00 PSAY OemToAnsi(STR0014)  //"TOTAL  GERAL      --> "
	@li, 137 PSAY nAg3	Picture tm(nAg3,15,nDecs)
	@li, 153 PSAY nAg1	Picture tm(nAg1,15,nDecs)
	@li, 169 PSAY (nAg2/nAg1)*100														Picture "999.99"
	@li, 176 PSAY nAg2 Picture tm(nAg2,15,nDecs)
	If mv_par10 > 0 .And. (nAg2 * mv_par10 / 100) > GetMV("MV_VLRETIR")//IR
		li ++
		@ li, 00  PSAY OemToAnsi(STR0015)  //"TOTAL DO IR       --> "
		@ li, 176  PSAY (nAg2 * mv_par10 / 100)   PicTure tm((nAg2 * mv_par10 / 100),15,nDecs)
		li ++                                        
		@ li,00 PSAY "TOTAL LIQUIDO     --> "   
		@ li, 176  PSAY nag2-(nAg2 * mv_par10 / 100)   PicTure tm((nAg2 * mv_par10 / 100),15,nDecs)
	EndIf
	roda(cbcont,cbtxt,"G")
EndIF

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Restaura a integridade dos dados                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("SE3")
RetIndex("SE3")
DbSetOrder(2)
Set Filter To
cExt := OrdBagExt()
fErase(cNomArq+cExt)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Se em disco, desvia para Spool                               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Lista pela             ?","mv_ch1","N",01,0,2,"C",space(60),"mv_par01"       ,"Emissao"        ,space(30),space(15),"Baixa"          ,space(30),space(15),"Ambos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Considera da Data      ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Ate a Data             ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Do vendedor            ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"05","Ate o vendedor         ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"06","Considera quais        ?","mv_ch6","N",01,0,3,"C",space(60),"mv_par06"       ,"A Pagar"        ,space(30),space(15),"Pagas"          ,space(30),space(15),"Ambas"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Demonstra ajuste       ?","mv_ch7","N",01,0,1,"C",space(60),"mv_par07"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Qual moeda             ?","mv_ch8","N",01,0,1,"C",space(60),"mv_par08"       ,"Modea 1"        ,space(30),space(15),"Moeda 2"        ,space(30),space(15),"Moeda 3"        ,space(30),space(15),"Moeda 4"        ,space(30),space(15),"Moeda 5"        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Comissoes zeradas      ?","mv_ch9","N",01,0,1,"C",space(60),"mv_par09"       ,"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Aliquota de IR         ?","mv_chA","N",05,2,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Salta pag por vendedor ?","mv_chB","N",01,0,1,"C",space(60),"mv_par11"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Tipo de relatorio      ?","mv_chC","N",01,0,1,"C",space(60),"mv_par12"       ,"Analitico"      ,space(30),space(15),"Sintetico"      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"13","Imprime detalhes origem?","mv_chD","N",01,0,2,"C",space(60),"mv_par13"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"14","Nome cliente           ?","mv_chE","N",01,0,2,"C",space(60),"mv_par14"       ,"Nome reduzido"  ,space(30),space(15),"Razao social"   ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

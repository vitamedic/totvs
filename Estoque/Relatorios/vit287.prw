/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT287  ³ Autor ³ Eveli Morasco         ³ Data ³ 05/02/93  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Listagem dos itens inventariados                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Pim.³04/12/97³07906A³ Definir a moeda a ser utilizada(mv_par10)³±±
±±³Marcelo Pim.³09/12/97³07618A³ Ajuste no posicionamento inicial do B7 p/³±±
±±³            ³        ³      ³ nao utilizar o Local padrao.             ³±±
±±³Fernando J. ³23/09/98³06744A³ Incluir informa‡”oes de LOTE, SUB-LOTE e ³±±
±±³            ³        ³      ³ NUMERO DE SERIE.                         ³±±
±±³Rodrigo Sar.³17/11/98³18459A³ Acerto na impressao qdo almoxarifado CQ  ³±±
±±³Cesar       ³30/03/99³20706A³ Imprimir Numero do Lote                  ³±±
±±³Cesar       ³30/03/99³XXXXXX³ Manutencao na SetPrint()                 ³±±
±±³Fernando Jol³20/09/99³19581A³ Incluir pergunta "Imprime Lote/Sub-Lote?"³±±
±±³Patricia Sal³30/12/99³XXXXXX³ Acerto LayOut (Doc. 12 digitos);Troca da ³±±
±±³            ³        ³      ³ PesqPictQt() pela PesqPict().            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#INCLUDE "VIT287.CH"
#INCLUDE "RWMAKE.CH"

user function vit287()
//Function Matr285

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Tamanho 
Local Titulo  := STR0001 // 'Listagem dos Itens Inventariados'
Local cDesc1  := STR0002 // 'Emite uma relacao que mostra o saldo em estoque e todas as'
Local cDesc2  := STR0003 // 'contagens efetuadas no inventario. Baseado nestas duas in-'
Local cDesc3  := STR0004 // 'formacoes ele calcula a diferenca encontrada.'
Local cString := 'SB1'
Local nTipo   := 0
Local aOrd    := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009)}		//' Por Codigo    '###' Por Tipo      '###' Por Grupo   '###' Por Descricao '###' Por Local    '
Local wnRel   := 'vit287'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {OemToAnsi(STR0010), 1,OemToAnsi(STR0011), 2, 2, 1, '',1 }   //'Zebrado'###'Administracao'
Private nLastKey := 0
PRIVATE cPerg    :="PERGVIT287"       
PRIVATE NomeProg :="VIT287"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Produto de                           ³
//³ mv_par02             // Produto ate                          ³
//³ mv_par03             // Data de Selecao                      ³
//³ mv_par04             // De  Tipo                             ³
//³ mv_par05             // Ate Tipo                             ³
//³ mv_par06             // De  Local                            ³
//³ mv_par07             // Ate Local                            ³
//³ mv_par08             // De  Grupo                            ³
//³ mv_par09             // Ate Grupo                            ³
//³ mv_par10             // Qual Moeda (1 a 5)                   ³
//³ mv_par11             // Imprime Lote/Sub-Lote                ³
//³ mv_par12             // Custo Medio Atual/Ultimo Fechamento  ³
//³ mv_par13             // Imprime Localizacao ?                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
_pergsx1()
pergunte( "PERGVIT287",.F. ) 


//Pergunte(cPerg,.F.)

// Utiliza‡„o do aReturn[4] e do nTamanho
// aReturn[4] := 1=Comprimido 2=Normal
// nTamanho   := If(aReturn[4]==1,'G','P')

Tamanho := 'G'
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "VIT287"+Alltrim(cusername)
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho,"",.f.)
//wnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Set Filter to
	Return Nil
Endif

SetDefault(aReturn,cString)
           
If nLastKey == 27
	Set Filter to
	Return Nil
Endif


RptStatus({|lEnd| C285Imp(aOrd,@lEnd,wnRel,cString,titulo,Tamanho)},titulo)
//RptStatus({|lEnd| FR287Imp(@lEnd,wnRel,cString)},Titulo)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C285IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 12.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ vit287                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function C285Imp(aOrd,lEnd,WnRel,cString,titulo,Tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nSB7Cnt  := 0
Local i		   := 0
Local nTotal   := 0
Local nTotVal  := 0
Local nSubVal  := 0
Local nCntImpr := 0
Local cAnt     := '',cSeek:='',cCompara :='',cLocaliz:='',cNumSeri:='',cLoteCtl:='',cNumLote:=''
Local cRodaTxt := STR0012 // 'PRODUTO(S)'
Local aSaldo   := {}
Local aSalQtd  := {}
Local aCM      := {}
Local lQuery   := .F.
Local cQuery   := ""
Local aStruSB1 := {}
Local aStruSB2 := {}
Local aStruSB7 := {}
Local cAliasSB1:= "SB1"
Local cAliasSB2:= "SB2"
Local cAliasSB7:= "SB7"
Local cProduto := ""
Local cLocal   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas qdo almoxarifado do CQ                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local	cLocCQ	:= GetMV("MV_CQ")
Private	lLocCQ	:=.T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCondicao := '!Eof()'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Li    := 80
Private m_Pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona a ordem escolhida ao titulo do relatorio          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type('NewHead') # 'U'
	ewHead += ' (' + AllTrim(aOrd[aReturn[8]]) + ')'
Else
	Titulo += ' (' + AllTrim(aOrd[aReturn[8]]) + ')'
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par11 == 1
	If mv_par13 == 1
        Cabec1 := STR0023 // 'CODIGO          DESCRICAO                LOTE       SUB    LOCALIZACAO     NUMERO DE SERIE      TP GRP  UM AL DOCUMENTO            QUANTIDADE         QTD NA DATA   _____________DIFERENCA______________'
        Cabec2 := STR0024 // '                                                    LOTE                                                                         INVENTARIADA       DO INVENTARIO          QUANTIDADE              VALOR'
        //--                  123456789012345 123456789012345678901234 1234567890 123456 123456789012345 12345678901234567890 12 1234 12 12 123456789012 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
        //--                  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Else
        Cabec1 := STR0013 // 'CODIGO          DESCRICAO                LOTE       SUB    TP GRP  UM AL DOCUMENTO            QUANTIDADE         QTD NA DATA   _____________DIFERENCA______________'
        Cabec2 := STR0014 // '                                                    LOTE                                    INVENTARIADA       DO INVENTARIO          QUANTIDADE              VALOR'
        //--                  123456789012345 123456789012345678901234 1234567890 123456 12 1234 12 12 123456789012 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16   
        //--                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	EndIf	
Else
	If mv_par13 == 1
        Cabec1 := STR0025 // 'CODIGO          DESCRICAO                LOCALIZACAO     NUMERO DE SERIE      TP GRP  UM AL DOCUMENTO            QUANTIDADE         QTD NA DATA  _______________DIFERENCA_____________'
        Cabec2 := STR0026 // '                                                                                                               INVENTARIADA       DO INVENTARIO          QUANTIDADE              VALOR'
        //--                  123456789012345 123456789012345678901234 123456789012345 12345678901234567890 12 1234 12 12 123456789012 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14       15        16        17        18
        //--                  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456780123456789012345678901234567890123456789012
	Else
        Cabec1 := STR0021 // 'CODIGO          DESCRICAO                TP GRP  UM AL DOCUMENTO            QUANTIDADE         QTD NA DATA  _______________DIFERENCA_____________'
        Cabec2 := STR0022 // '                                                                          INVENTARIADA       DO INVENTARIO          QUANTIDADE              VALOR'
        //--                  123456789012345 123456789012345678901234 12 1234 12 12 123456789012 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
        //--                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678012345
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os Arquivos e Ordens a serem utilizados           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('SB2')
dbSetOrder(1)

dbSelectArea('SB7')
dbSetOrder(1)

dbSelectArea('SB1')
SetRegua(LastRec())

#IFDEF TOP
	If aReturn[8] == 2
		dbSetOrder(2) //-- Tipo
	ElseIf aReturn[8] == 3
		dbSetOrder(4) //-- Grupo
	ElseIf aReturn[8] == 4
		dbSetOrder(3) //-- Descricao
	ElseIf aReturn[8] == 5
		cNomArq := CriaTrab('', .F.) //-- Local
		cKey    := 'B1_FILIAL + B1_LOCPAD + B1_COD'
	Else
		dbSetOrder(1) //-- Codigo
	EndIf

	lQuery 	  := .T.
	aStruSB1  := SB1->(dbStruct())
	aStruSB2  := SB2->(dbStruct())
	aStruSB7  := SB7->(dbStruct())

	cAliasSB1 := "R287IMP"
	cAliasSB2 := "R287IMP"
	cAliasSB7 := "R287IMP"

	cQuery    := "SELECT "
	cQuery    += "SB1.R_E_C_N_O_ SB1REC, "
	cQuery    += "SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_LOCPAD, SB1.B1_TIPO, SB1.B1_GRUPO, SB1.B1_DESC, SB1.B1_UM , "
	cQuery    += "SB2.R_E_C_N_O_ SB2REC, "
	cQuery    += "SB2.B2_FILIAL, SB2.B2_COD, SB2.B2_LOCAL, SB2.B2_DINVENT, "
	cQuery    += "SB7.R_E_C_N_O_ SB7REC, "
	cQuery    += "SB7.B7_FILIAL, SB7.B7_COD, SB7.B7_LOCAL, SB7.B7_DATA, SB7.B7_LOCALIZ, SB7.B7_NUMSERI, SB7.B7_LOTECTL, SB7.B7_NUMLOTE, SB7.B7_DOC, SB7.B7_QUANT "

	cQuery    += "FROM "
	cQuery    += RetSqlName("SB1")+" SB1, "
	cQuery    += RetSqlName("SB2")+" SB2, "
	cQuery    += RetSqlName("SB7")+" SB7  "

	cQuery    += "WHERE "
	cQuery    += "SB1.B1_FILIAL = '"+xFilial("SB1")+"' And "

	If aReturn[8] == 2
		cQuery += "SB1.B1_TIPO  >= '"+mv_par04+"' And SB1.B1_TIPO  <= '"+mv_par05+"' And "
	ElseIf aReturn[8] == 3
		cQuery += "SB1.B1_GRUPO >= '"+mv_par08+"' And SB1.B1_GRUPO <= '"+mv_par09+"' And "
	ElseIf aReturn[8] == 5
		cQuery += "SB1.B1_LOCPAD>= '"+mv_par06+"' And SB1.B1_LOCPAD<= '"+mv_par07+"' And "
	Else	
		cQuery += "SB1.B1_COD   >= '"+mv_par01+"' And SB1.B1_COD   <= '"+mv_par02+"' And "
	EndIf	
			
	cQuery    += "SB1.D_E_L_E_T_ = ' ' And "

	cQuery    += "SB2.B2_FILIAL = '"+xFilial("SB2")+"' And "
	cQuery    += "SB2.B2_COD = SB1.B1_COD And "
	cQuery    += "SB2.B2_LOCAL = SB7.B7_LOCAL And "
	cQuery    += "SB2.B2_DINVENT <= '"+DtoS(mv_par03)+"' And "
	cQuery    += "SB2.D_E_L_E_T_ = ' ' And "
	cQuery    += "SB7.B7_FILIAL = '"+xFilial("SB7")+"' And "
	cQuery    += "SB7.B7_COD = SB1.B1_COD And "
	cQuery    += "SB7.B7_LOCAL >= '"+mv_par06+"' And SB7.B7_LOCAL <= '"+mv_par07+"' And "
	cQuery    += "SB7.B7_DATA   = '"+DtoS(mv_par03)+"' And "
	cQuery    += "SB7.D_E_L_E_T_ = ' ' "

	cQuery    += "ORDER BY "+SqlOrder(SB1->(IndexKey()))

	cQuery    := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)

	For nX := 1 To Len(aStruSB1)
		If ( aStruSB1[nX][2] <> "C" ) .And. FieldPos(aStruSB1[nX][1]) > 0
			TcSetField(cAliasSB1,aStruSB1[nX][1],aStruSB1[nX][2],aStruSB1[nX][3],aStruSB1[nX][4])
		EndIf
	Next nX

	For nX := 1 To Len(aStruSB2)
		If ( aStruSB2[nX][2] <> "C" ) .And. FieldPos(aStruSB2[nX][1]) > 0
			TcSetField(cAliasSB2,aStruSB2[nX][1],aStruSB2[nX][2],aStruSB2[nX][3],aStruSB2[nX][4])
		EndIf
	Next nX

	For nX := 1 To Len(aStruSB7)
		If ( aStruSB7[nX][2] <> "C" ) .And. FieldPos(aStruSB7[nX][1]) > 0
			TcSetField(cAliasSB7,aStruSB7[nX][1],aStruSB7[nX][2],aStruSB7[nX][3],aStruSB7[nX][4])
		EndIf
	Next nX
#ELSE	
	cCondicao += " B1_FILIAL == '" + xFilial('SB1') + "' .And. "
	If aReturn[8] == 2
		dbSetOrder(2) //-- Tipo
		dbSeek(cFilial + mv_par04, .T.)
		cCondicao += "B1_TIPO <= mv_par05"
		cAnt      := B1_TIPO
	ElseIf aReturn[8] == 3
		dbSetOrder(4) //-- Grupo
		dbSeek(cFilial + mv_par08, .T.)
		cCondicao += "B1_GRUPO <= mv_par09"
		cAnt      := B1_GRUPO
	ElseIf aReturn[8] == 4
		dbSetOrder(3) //-- Descricao
		dbSeek(cFilial)
	ElseIf aReturn[8] == 5
		cNomArq := CriaTrab('', .F.) //-- Local
		cKey    := "B1_FILIAL + B1_LOCPAD + B1_COD"
		IndRegua('SB1',cNomArq,cKey,,,STR0015) // 'Selecionando Registros...'
		dbSeek(cFilial + mv_par06, .T.)
		cCondicao += "B1_LOCPAD <= mv_par07"
	Else
		dbSetOrder(1) //-- Codigo
		dbSeek(cFilial + mv_par01, .T.)
		cCondicao += "B1_COD <= mv_par02"
	EndIf
#ENDIF

nTotVal := 0
nSubVal := 0

Do While &cCondicao

	#IFNDEF TOP
		If ((cAliasSB1)->B1_COD > mv_par02 .And. aReturn[8] == 1)
			Exit
		ElseIf ((cAliasSB1)->B1_GRUPO < mv_par08) .Or. ((cAliasSB1)->B1_GRUPO > mv_par09) .Or. ;
			   ((cAliasSB1)->B1_TIPO  < mv_par04) .Or. ((cAliasSB1)->B1_TIPO  > mv_par05) .Or. ;
			   ((cAliasSB1)->B1_COD   < mv_par01) .Or. ((cAliasSB1)->B1_COD   > mv_par02)
			(cAliasSB1)->(dbSkip())
			Loop
		EndIf
	#ENDIF
	
	If aReturn[8] == 2
		cAnt := (cAliasSB1)->B1_TIPO
	ElseIf aReturn[8] == 3
		cAnt := (cAliasSB1)->B1_GRUPO
	Endif
	
	If lEnd
		@ pRow()+1, 000 PSAY STR0016 // 'CANCELADO PELO OPERADOR'
		Exit
	EndIF
	
	IncRegua()

	#IFNDEF TOP
	(cAliasSB2)->(dbSeek(xFilial('SB2') + (cAliasSB1)->B1_COD, .T.))

	Do While !(cAliasSB2)->(Eof()) .And. ;
			(cAliasSB2)->B2_FILIAL+(cAliasSB2)->B2_COD == xFilial('SB2')+(cAliasSB1)->B1_COD

		If (cAliasSB2)->B2_DINVENT > mv_par03
			(cAliasSB2)->(dbSkip())
			Loop
		EndIf
		(cAliasSB7)->(dbSeek(xFilial('SB7') + DtoS(mv_par03) + (cAliasSB2)->B2_COD + (cAliasSB2)->B2_LOCAL, .T.))
	#ENDIF

		cProduto := (cAliasSB2)->B2_COD
		cLocal   := (cAliasSB2)->B2_LOCAL

		Do While !(cAliasSB7)->(Eof()) .And. ;
			(cAliasSB7)->(B7_FILIAL+DtoS(B7_DATA)+B7_COD+B7_LOCAL) == xFilial('SB7')+DtoS(mv_par03)+cProduto+cLocal
			
			#IFNDEF TOP
				If ((cAliasSB7)->B7_LOCAL < mv_par06) .Or. ((cAliasSB7)->B7_LOCAL > mv_par07)
					(cAliasSB7)->(dbSkip())
					Loop
				EndIf
			#ENDIF
			
			nTotal  := 0
			nSB7Cnt := 0
			cSeek   := xFilial('SB7')+DtoS(mv_par03)+(cAliasSB7)->B7_COD+(cAliasSB7)->B7_LOCAL+(cAliasSB7)->B7_LOCALIZ+(cAliasSB7)->B7_NUMSERI+(cAliasSB7)->B7_LOTECTL+(cAliasSB7)->B7_NUMLOTE
			cCompara:= "B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE"
			cLocaliz:= (cAliasSB7)->B7_LOCALIZ
			cNumSeri:= (cAliasSB7)->B7_NUMSERI
			cLoteCtl:= (cAliasSB7)->B7_LOTECTL
			cNumLote:= (cAliasSB7)->B7_NUMLOTE
			
			Do While !(cAliasSB7)->(Eof()) .And. cSeek == (cAliasSB7)->&(cCompara)
				
				#IFNDEF TOP
					If ((cAliasSB7)->B7_LOCAL < mv_par06) .Or. ((cAliasSB7)->B7_LOCAL > mv_par07)
						(cAliasSB7)->(dbSkip())
						Loop
					EndIf
				#ENDIF
				
				If Li > 55
					Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIF
				
				nSB7Cnt++
				
				If nSB7Cnt == 1
					@ Li, 000 PSAY Left((cAliasSB1)->B1_COD    ,15)
					@ Li, 016 PSAY Left((cAliasSB1)->B1_DESC   ,24)
				Endif
				
				If mv_par11 == 1  
					@ Li, 041 PSAY Left((cAliasSB7)->B7_LOTECTL,10)
					@ Li, 052 PSAY Left((cAliasSB7)->B7_NUMLOTE,06)
					If mv_par13 == 1                            
						@ Li, 059 PSAY Left((cAliasSB7)->B7_LOCALIZ,15)
						@ Li, 075 PSAY Left((cAliasSB7)->B7_NUMSERI,20)
					EndIf
					If nSB7Cnt == 1
						@ Li,If(mv_par13==1,096,059) PSAY Left((cAliasSB1)->B1_TIPO ,02)
						@ Li,If(mv_par13==1,099,062) PSAY Left((cAliasSB1)->B1_GRUPO,04)
						@ Li,If(mv_par13==1,104,067) PSAY Left((cAliasSB1)->B1_UM   ,02)
						@ Li,If(mv_par13==1,107,070) PSAY Left((cAliasSB2)->B2_LOCAL,02)
					Endif
					@ Li,If(mv_par13==1,110,073) PSAY (cAliasSB7)->B7_DOC
					@ Li,If(mv_par13==1,123,086) PSAY Transform((cAliasSB7)->B7_QUANT, (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
				Else
					If mv_par13 == 1
						@ Li, 041 PSAY Left((cAliasSB7)->B7_LOCALIZ,15)
						@ Li, 057 PSAY Left((cAliasSB7)->B7_NUMSERI,20)
					EndIf	
					If nSB7Cnt == 1
						@ Li,If(mv_par13==1,078,041) PSAY Left((cAliasSB1)->B1_TIPO   ,02)
						@ Li,If(mv_par13==1,081,044) PSAY Left((cAliasSB1)->B1_GRUPO  ,04)
						@ Li,If(mv_par13==1,086,049) PSAY Left((cAliasSB1)->B1_UM     ,02)
						@ Li,If(mv_par13==1,089,052) PSAY Left((cAliasSB2)->B2_LOCAL  ,02)
					Endif
					@ Li,If(mv_par13==1,092,055) PSAY (cAliasSB7)->B7_DOC
					@ Li,If(mv_par13==1,105,068) PSAY Transform((cAliasSB7)->B7_QUANT, (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
				EndIf
				
				Li++
				
				nTotal += (cAliasSB7)->B7_QUANT
				
				(cAliasSB7)->(dbSkip())
			EndDo
			
			If nSB7Cnt == 0
				(cAliasSB2)->(dbSkip())
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona 1 ao contador de registros impressos         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nCntImpr++
			
			If nSB7Cnt == 1
				Li--
			ElseIf nSB7Cnt > 1
				If mv_par11 == 1
					@ Li,If(mv_par13==1,100,063) PSAY STR0017 // 'TOTAL .................'
					@ Li,If(mv_par13==1,123,086) PSAY Transform(nTotal, (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
				Else
					@ Li,If(mv_par13==1,082,044) PSAY STR0017 // 'TOTAL .................'
					@ Li,If(mv_par13==1,105,068) PSAY Transform(nTotal, (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
				EndIf
			EndIf

			If (Localiza(cProduto) .And. !Empty(cLocaliz+cNumSeri)) .Or. (Rastro(cProduto) .And. !Empty(cLotectl+cNumLote))
				aSalQtd   := CalcEstL(cProduto,cLocal,mv_par03+1,cLoteCtl,cNumLote,cLocaliz,cNumSeri)
				aSaldo    := CalcEst(cProduto,cLocal,mv_par03+1)
				aSaldo[2] := (aSaldo[2] / aSaldo[1]) * aSalQtd[1]
				aSaldo[3] := (aSaldo[3] / aSaldo[1]) * aSalQtd[1]
				aSaldo[4] := (aSaldo[4] / aSaldo[1]) * aSalQtd[1]
				aSaldo[5] := (aSaldo[5] / aSaldo[1]) * aSalQtd[1]
				aSaldo[6] := (aSaldo[6] / aSaldo[1]) * aSalQtd[1]
				aSaldo[7] := aSalQtd[7]
				aSaldo[1] := aSalQtd[1]
			Else
				If cLocCQ == cLocal
					aSalQtd	  := A340QtdCQ(cProduto,cLocal,mv_par03+1,"")
					aSaldo	  := CalcEst(cProduto,cLocal,mv_par03+1)
					aSaldo[2] := (aSaldo[2] / aSaldo[1]) * aSalQtd[1]
					aSaldo[3] := (aSaldo[3] / aSaldo[1]) * aSalQtd[1]
					aSaldo[4] := (aSaldo[4] / aSaldo[1]) * aSalQtd[1]
					aSaldo[5] := (aSaldo[5] / aSaldo[1]) * aSalQtd[1]
					aSaldo[6] := (aSaldo[6] / aSaldo[1]) * aSalQtd[1]
					aSaldo[7] := aSalQtd[7]
					aSaldo[1] := aSalQtd[1]
				Else
					aSaldo := CalcEst(cProduto,cLocal,mv_par03+1)
				EndIf
			EndIf
			
			If mv_par11 == 1
				@ Li,If(mv_par13==1,143,106) PSAY Transform(aSaldo[1], (cAliasSB2)->(PesqPict("SB2",'B2_QATU', 15)))
			Else
				@ Li,If(mv_par13==1,125,088) PSAY Transform(aSaldo[1], (cAliasSB2)->(PesqPict("SB2",'B2_QATU', 15)))
			EndIf
			
			If nSB7Cnt > 0
				// Recupera custo medio na data do movimento
				// Alterado abaixo por Marcelo Iuspa em 03/05/2000 para
				// pegar o custo medio por PegaCMFim opcionalmente
				// Ref. BOPS 03757
				If mv_par12 == 1
					aCM:={}
					If QtdComp(aSaldo[1]) > QtdComp(0)
						For i:=2 to Len(aSaldo)
							AADD(aCM,aSaldo[i]/aSaldo[1])
						Next i
            		Else
						aCm := PegaCmAtu(cProduto,cLocal)
            		EndIf
                Else
                	aCM := PegaCMFim(cProduto,cLocal)
				Endif
            dbSelectArea(cAliasSB7)

				If mv_par11 == 1 
					@ Li,If(mv_par13==1,163,126) PSAY Transform(nTotal-aSaldo[1], (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
					@ Li,If(mv_par13==1,182,145) PSAY Transform((nTotal-aSaldo[1])*aCM[mv_par10], (cAliasSB2)->(PesqPict("SB2",'B2_VATU1', 15)))
				Else
					@ Li,If(mv_par13==1,146,108) PSAY Transform(nTotal-aSaldo[1], (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
					@ Li,If(mv_par13==1,165,127) PSAY Transform((nTotal-aSaldo[1])*aCM[mv_par10], (cAliasSB2)->(PesqPict("SB2",'B2_VATU1', 15)))
				EndIf
				nTotVal += (nTotal-aSaldo[1])*aCM[mv_par10]
				nSubVal += (nTotal-aSaldo[1])*aCM[mv_par10]
			EndIf
			Li++
		EndDo
		
	#IFNDEF TOP
		(cAliasSB2)->(dbSkip())
		
	EndDo

	dbSelectArea(cAliasSB1)
	dbSkip()
	#ENDIF
	
	If aReturn[8] == 2
		If cAnt # B1_TIPO .And. nSB7Cnt >= 1
			If mv_par11 == 1
				@ Li,If(mv_par13==1,152,114) PSAY STR0018 + Left(cAnt,2) + ' .............' // 'TOTAL DO TIPO '
				@ Li,If(mv_par13==1,182,145) PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QATU', 15)))
			Else     
				@ Li,If(mv_par13==1,136,092) PSAY STR0018 + Left(cAnt,2) + ' .............' // 'TOTAL DO TIPO '
				@ Li,If(mv_par13==1,165,127) PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QATU', 15)))
			EndIf
			cAnt    := B1_TIPO
			nSubVal := 0
			Li += 2
		EndIf
	ElseIf aReturn[8] == 3
		If cAnt # B1_GRUPO
			If mv_par11 == 1 
				@ Li,If(mv_par13==1,149,111) PSAY STR0019 + Left(cAnt,4) + ' .............' // 'TOTAL DO GRUPO '
				@ Li,If(mv_par13==1,182,145) PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QATU', 15)))
			Else
				@ Li,If(mv_par13==1,129,090) PSAY STR0019 + Left(cAnt,4) + ' .............' // 'TOTAL DO GRUPO '
				@ Li,If(mv_par13==1,165,127) PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QATU', 15)))
			EndIf
			cAnt    := B1_GRUPO
			nSubVal := 0
			Li += 2
		EndIf
	EndIf
	
EndDo

If nTotVal # 0
	Li++
	If mv_par11 == 1       
		@ Li,If(mv_par13==1,139,101) PSAY STR0020 // 'TOTAL DAS DIFERENCAS EM VALOR .............'
		@ Li,If(mv_par13==1,182,145) PSAY Transform(nTotVal, (cAliasSB2)->(PesqPict("SB2",'B2_VATU1', 15)))
	Else             
		@ Li,If(mv_par13==1,114,080) PSAY STR0020 // 'TOTAL DAS DIFERENCAS EM VALOR .............'
		@ Li,If(mv_par13==1,165,127) PSAY Transform(nTotVal, (cAliasSB2)->(PesqPict("SB2",'B2_VATU1', 15)))
	EndIf
EndIf

If Li # 80
	Roda(nCntImpr, cRodaTxt, Tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cString)
RetIndex(cString)
dbSetOrder(1)
Set Filter To

#IFNDEF TOP
	(cAliasSB2)->(dbSetOrder(1))
	(cAliasSB7)->(dbSetOrder(1))
	(cAliasSB1)->(dbSetOrder(1))
#ELSE	
	dbSelectArea(cAliasSB1)
	dbCloseArea()
#ENDIF

If aReturn[8] == 5
	If File(cNomArq + OrdBagExt())
		fErase(cNomArq + OrdBagExt())
	Endif
Endif

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return Nil                   




static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto                   ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto                ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Data da selecao              ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","De tipo                      ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Ate tipo                     ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Do armazem                   ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Ate o armazem                ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Do grupo                     ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"09","Ate o grupo                  ?","mv_ch9","C",04,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"10","Qual moeda                   ?","mv_chA","N",01,0,1,"C",space(60),"mv_par10"       ,"1a Moeda"       ,space(30),space(15),"2a Moeda"       ,space(30),space(15),"3a Moeda"       ,space(30),space(15),"4a Moeda"       ,space(30),space(15),"5a Moeda"       ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Imprime Lote/S.lote          ?","mv_chB","N",01,0,1,"C",space(60),"mv_par11"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Usar o custo medio           ?","mv_chC","N",01,0,1,"C",space(60),"mv_par12"       ,"Atual"          ,space(30),space(15),"Ult. Fechamento",space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"13","Imprime endereco             ?","mv_chD","C",01,0,2,"C",space(60),"mv_par13"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"14","Listar produtos              ?","mv_chE","N",01,0,3,"C",space(60),"mv_par14"       ,"Com diferencas" ,space(30),space(15),"Sem diferencas" ,space(30),space(15),"Todos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
return()

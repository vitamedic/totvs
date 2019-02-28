#INCLUDE "VIT109.CH"
#Include "RWMAKE.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MATR230  ³ Autor ³ Eveli Morasco         ³ Data ³ 02/03/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Requisicoes para consumo                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
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
±±³Marcelo Pim.³05/12/97³09882A³Incl.perg.(Dt.Emiss.,Cod.Prod.,Tipo,Grupo)³±±
±±³Cesar       ³30/03/99³XXXXXX³Manutencao na SetPrint()                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


user Function vit109
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL Tamanho  := "M"
LOCAL titulo   := STR0001 	//"Requisicoes para Consumo"
LOCAL cDesc1   := STR0002	//"Emite a relacao das requisicoes feitas para consumo , dividindo por"
LOCAL cDesc2   := STR0003	//"Centro de Custo requisitante ou Conta Contabil.Este relatorio e' um"
LOCAL cDesc3   := STR0004	//"pouco demorado porque ele cria o arquivo de indice na hora."
LOCAL cString  := "SD3"
LOCAL aOrd     := {OemToAnsi(STR0005),OemToAnsi(STR0006)}    //" Centro Custo "###" Cta.Contabil "
LOCAL wnrel    := "VIT109"+Alltrim(cusername)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn:= {OemToAnsi(STR0007),1,OemToAnsi(STR0008), 2, 2, 1, "",1}    //"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0 ,cPerg := "MTR230"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // De  Centro de Custo                          ³
//³ mv_par02     // Ate Centro de Custo                          ³
//³ mv_par03     // Moeda Selecionada ( 1 a 5 )                  ³
//³ mv_par04     // De  Local                                    ³
//³ mv_par05     // Ate Local                                    ³
//³ mv_par06     // Da  Data                                     ³
//³ mv_par07     // Ate Data                                     ³
//³ mv_par08     // Do  Produto                                  ³
//³ mv_par09     // Ate Produto                                  ³
//³ mv_par10     // Do  Tipo                                     ³
//³ mv_par11     // Ate Tipo                                     ³
//³ mv_par12     // Do  Grupo                                    ³
//³ mv_par13     // Ate Grupo                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C230Imp(aOrd,@lEnd,wnRel,titulo,Tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C230IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 07.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR230  			                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C230Imp(aOrd,lEnd,WnRel,titulo,Tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nTipo    	:= 0
LOCAL cRodaTxt 	:= OemToAnsi(STR0009)   //"REGISTRO(S)"
LOCAL nCntImpr 	:= 0
LOCAL nAc1:=0,nAc2:=0,nAg1:=0,nAg2:=0,nAt1:=0,nAt2:=0,nAp1:=0,nAp2:=0
LOCAL	lLista:=.F.
LOCAL dEmissao ,lImprime,nUnit:=0,cCcant,cGrupant,cProdant,cContant
LOCAL cCampoCus,lContinua,lPassou1,lPassou2,lPassou3
LOCAL cCond 	:= 'D3_FILIAL=="'+xFilial("SD3")+'"  .And. D3_CC >= "'+mv_par01+'"'
Local aEntCt    := If(CtbInUse(), { "CT1", "CTT" }, { "SI1", "SI3" })

cCond += '.And. D3_CC <= "'+mv_par02+'" .And. D3_LOCAL >= "'+mv_par04+'"'
cCond += '.And. D3_LOCAL <= "'+mv_par05+'"'
cCond += '.And. D3_COD >= "'+mv_par08+'" .And. D3_COD <= "'+mv_par09+'"'
cCond += '.And. D3_TIPO >= "'+mv_par10+'" .And. D3_TIPO <= "'+mv_par11+'"'
cCond += '.And. D3_ESTORNO == " "'
cCond += '.And. D3_CONTA >= "'+mv_par14+'" .And. D3_CONTA <= "'+mv_par15+'"'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cNomArq

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso seja TOPCONNECT, soma o filtro na condicao da IndRegua³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	If !Empty(aReturn[7])
		cCond+=".And."+aReturn[7]
	EndIf
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona a ordem escolhida ao titulo do relatorio          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("NewHead")#"U"
	NewHead += " (Por "+AllTrim(aOrd[aReturn[8]])+" ,em "+AllTrim(GetMv("MV_SIMB"+LTrim(Str(mv_par03))))+")"
Else
	Titulo  += " (Por "+AllTrim(aOrd[aReturn[8]])+" ,em "+AllTrim(GetMv("MV_SIMB"+LTrim(Str(mv_par03))))+")"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o campo a ser impresso no valor de acordo com a moeda selecionada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCampoCus := "SD3->D3_CUSTO"+Str(mv_par03,1)

lContinua := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis para controlar cursor de progressao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD3")
SetRegua(LastRec())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega o nome do arquivo de indice de trabalho             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := CriaTrab("",.F.)

If aReturn[8] == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o indice de trabalho                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IndRegua("SD3",cNomArq,"D3_FILIAL+D3_CC+D3_GRUPO+D3_COD",,cCond,OemToAnsi(STR0010))   //"Selecionando Registros..."
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o cabecalho de acordo com a ordem selecionada       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cabec1 :=OemToAnsi(STR0011)   //"C.C       DESCRICAO                 CODIGO PRODUTO  DESCRICAO                 UM       QUANTIDADE          CUSTO        C U S T O"
	cabec2 :=OemToAnsi(STR0012)   //"                                                                                                        UNITARIO        T O T A L"
	*****      123456789 1234567890123456789012345 123456789012345 1234567890123456789012345 12 9999999999999.99 99999999999.99 9999999999999.99
	*****      0         1         2         3         4         5         6         7         8         9        10        11        12        13
	*****      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	
	Store 0 To nAt1,nAt2
	lPassou3 := .F.                     
	_mal := .F.
	While lContinua .And. !EOF()
		cCcant := D3_CC
		Store 0 To nAc1,nAc2
		lImprime := .T.
		lPassou2 := .F.
		While lContinua .And. !EOF() .And. D3_FILIAL+D3_CC == cFilial+cCCAnt
			cGrupant := D3_GRUPO
			Store 0 To nAg1,nAg2,_ma
			lPassou1 := .F.
			While lContinua .And. !EOF() .And. D3_FILIAL+D3_CC+D3_GRUPO == cFilial+cCCAnt+cGrupAnt
				cProdant := D3_COD+D3_LOCAL
				Store 0 To nAp1,nAp2
				While lContinua .And. !EOF() .And. D3_FILIAL+D3_CC+D3_GRUPO+D3_COD+D3_LOCAL == cFilial+cCCAnt+cGrupAnt+cProdAnt
					If lEnd
						@ PROW()+1,001 PSay OemToAnsi(STR0013)    //"CANCELADO PELO OPERADOR"
						lContinua := .F.
						Exit
					EndIf
					IncRegua()
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ So' entra requisicao e devolucao                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SubStr(D3_CF,2,1) != "E"
						dbSkip()
						Loop
					EndIf
					
					IF D3_EMISSAO < mv_par06 .OR. D3_EMISSAO > mv_par07
						dbSkip()
						Loop
					ENDIF
					
					IF D3_GRUPO < mv_par12 .OR. D3_GRUPO > mv_par13
						dbSkip()
						Loop
					ENDIF
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se tiver numero de OP nao e' para consumo , portanto  ³
					//³ nao deve entrar                                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Substr(D3_OP,7,2) # "OS" .And. !Empty(D3_OP)
						dbSkip()
						Loop
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Eu estou somando as requisicoes e subtraindo as  devolucoes ³
					//³porque este mapa tem o objetivo de totalizar os movimentos  ³
					//³internos,nao tem sentido mostrar um monte de valores negati-³
					//³vos ,sendo que as requisicoes normalmente serao maiores  que³
					//³as devolucoes.                                              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If D3_TM <= "500"
						nAp1 -= D3_QUANT
						nAp2 -= &(cCampoCus)
					Else
						nAp1 += D3_QUANT
						nAp2 += &(cCampoCus)
					EndIf
					dbSkip()
				EndDo
				If nAp1 != 0 .Or. nAp2 != 0
					IF li > 58
						cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
						lImprime := .T. 
						_mal = .t.
					EndIf
					If lImprime
 					  if nCntImpr >1 .and. !_mal
						 cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
						 _mal := .f.
					  endif
						@ li,000 PSay cCcant
						dbSelectArea(aEntCt[2])
						dbSeek(cFilial+cCcant)
						@li,021 PSay 	Left(If(Alias() = "CTT", &("CTT_DESC" +;
										StrZero(mv_par03, 2)), I3_DESC), 23)
						lImprime := .F.
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Adiciona 1 ao contador de registros impressos         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nCntImpr++
					dbSelectArea("SB1")
					dbSeek(cFilial+cProdant)
					@li,045 PSay B1_COD
					@li,061 PSay Substr(B1_DESC,1,22)
					@li,084 PSay B1_UM
					@li,087 PSay nAp1 Picture PesqPictQt("D3_QUANT",16)
					dbSelectArea("SD3")
					IF nAp1 = 0
						nUnit := nAp2
					Else
						nUnit := nAp2/nAp1
					EndIf
					@li,100 PSay nUnit PicTure tm(nUnit,14)
					@li,114 PSay nAp2  PicTure tm(nAp2,16)
					li++
					nAg1 += nAp1
					nAg2 += nAp2
					lPassou1 := .T.
					dbSelectArea("SD3")
				EndIf
			EndDo
			If lPassou1
				Li++
				@li,049 PSay OemToAnsi(STR0014)+cGrupant+Replicate(".",19)    //"Total do Grupo "
				@li,087 PSay nAg1 Picture PesqPictQt("D3_QUANT",16)
				@li,114 PSay nAg2 PicTure tm(nAg2,16)
				li++;li++
				nAc1 += nAg1
				nAc2 += nAg2
				lPassou2 := .T.
			EndIf
		EndDo
		If lPassou2
			@li,049 PSay OemToAnsi(STR0015)+Padl(Alltrim(cCcant),20)+"."    //"Total Centro de Custo "
			@li,087 PSay nAc1 Picture PesqPictQt("D3_QUANT",16)
			@li,114 PSay nAc2 PicTure tm(nAc2,16)
			li++;li++
			nAt1 += nAc1
			nAt2 += nAc2
			lPassou3 := .T.
  			_mal := .f.
		EndIf
	EndDo
/*	If lPassou3
		@ li,049 PSay OemToAnsi(STR0016) //"TOTAL GERAL....................."
		@ li,087 PSay nAt1 Picture PesqPictQt("D3_QUANT",16)
		@ li,114 PSay nAt2 PicTure tm(nAt2,16)
		li++
	EndIf*/
ElseIf aReturn[8] == 2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o indice de trabalho                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IndRegua("SD3",cNomArq,"D3_FILIAL+D3_CONTA+D3_CC+D3_COD",,cCond,OemToAnsi(STR0010))   //"Selecionando Registros..."
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o cabecalho de acordo com a ordem selecionada       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cabec1 := OemToAnsi(STR0017)   //"  DATA  C E N T R O  D E   C U S T O        C O N T A   C O N T A B I L                             V A L O R"
	cabec2 := ""
	*****      123456789 1234567890123456789012345 123456789012345 1234567890123456789012345 12 9999999999999.99 99999999999.99 9999999999999.99
	*****      0         1         2         3         4         5         6         7         8         9        10        11        12        13
	*****      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	lPassou3 := .F.
	While lContinua .And. !EOF()
		cContant := D3_CONTA                                 		
		Store 0 To nAc1                                      
		lPassou2 := .F.					
		While lContinua .And. !EOF() .And. D3_FILIAL+D3_CONTA == cFilial+cContant
			cCcant := D3_CC
			Store 0 To nAc2
			lLista:=.F.                                      
			While lContinua .And. !EOF() .And. D3_FILIAL+D3_CONTA+D3_CC == cFilial+cContant+cCCAnt
				If lEnd
					@ PROW()+1,001 PSay OemToAnsi(STR0013)  //"CANCELADO PELO OPERADOR"
					lContinua := .F.
					Exit
				EndIf
				IncRegua()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ So' entra requisicao e devolucao                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SubStr(D3_CF,2,1) != "E"
					dbSkip()
					Loop
				EndIf
				
				IF D3_EMISSAO < mv_par06 .OR. D3_EMISSAO > mv_par07
					dbSkip()
					Loop
				ENDIF
				
				IF D3_GRUPO < mv_par12 .OR. D3_GRUPO > mv_par13
					dbSkip()
					Loop
				ENDIF
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se tiver numero de OP nao e' para consumo , portanto  ³
				//³ nao deve entrar                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Substr(D3_OP,7,2) # "OS" .And. !Empty(D3_OP)
					dbSkip()
					Loop
				EndIf
				lLista:=.T.
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Eu estou somando as requisicoes e subtraindo as  devolucoes ³
				//³porque este mapa tem o objetivo de totalizar os movimentos  ³
				//³internos,nao tem sentido mostrar um monte de valores negati-³
				//³vos ,sendo que as requisicoes normalmente serao maiores  que³
				//³as devolucoes.                                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If D3_TM <= "500"
					nAc2 -= &(cCampoCus)
				Else
					nAc2 += &(cCampoCus)
				EndIf
				dEmissao := D3_EMISSAO
				dbSkip()
			EndDo
			If lLista
				IF li > 58
					cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf
				dbSelectArea(aEntCt[2])
				dbSeek(cFilial+cCcant)
	
				dbSelectArea(aEntCt[1])
				dbSeek(cFilial+cContant)
				dbSelectArea("SD3")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Adiciona 1 ao contador de registros impressos         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nCntImpr++
				@ li,000 		PSay dEmissao
				@ li,Pcol()+1	PSay cCcant
				@ li,Pcol()+1	PSay SubStr(If(aEntCt[2] = "CTT", &("CTT->CTT_DESC" + StrZero(mv_par03, 2)), SI3->I3_DESC),1,35)
				@ li,057		PSay cContant
  			   @ li,Pcol()+1	PSay SubStr(If(aEntCt[1] = "CT1", &("CT1->CT1_DESC" + StrZero(mv_par03, 2)),AllTrim(SI1->I1_DESC)),1,30)
				@ li,110		PSay nAc2 Picture TM(nAc2,18)

				nAc1 += nAc2
				lPassou2 := .T.				
				li++
			EndIf
		EndDo
		If lPassou2
			@ li,000 PSay OemToAnsi(STR0018)+cContant   //"Total da Conta --> "
			@ li,110 PSay nAc1 PicTure TM(nAc1,18)
			li += 2
			nAg1 += nAc1
			lPassou3 := .T.
  		EndIf
	EndDo
	If lPassou3
		@ li,000 PSay OemToAnsi(STR0019)  //"T O T A L --->"
		@ li,110 PSay nAg1 PicTure TM(nAg1,18)
	EndIf
EndIf

/*IF li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve as ordens originais do arquivo                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SD3")
Set Filter to

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga indice de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq += OrdBagExt()
Delete File &(cNomArq)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

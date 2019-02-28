#Include "vit264.Ch"
#Include "PROTHEUS.Ch"

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA 			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_COLUNA1       	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_COLUNA2       	8
#DEFINE 	COL_SEPARA5			9
#DEFINE 	COL_COLUNA3       	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_COLUNA4   		12
#DEFINE 	COL_SEPARA7			13
#DEFINE 	COL_COLUNA5   		14
#DEFINE 	COL_SEPARA8			15
#DEFINE 	COL_COLUNA6   		16
#DEFINE 	COL_SEPARA9			17
#DEFINE 	COL_COLUNA7			18
#DEFINE 	COL_SEPARA10		19
#DEFINE 	COL_COLUNA8			20
#DEFINE 	COL_SEPARA11		21
#DEFINE 	COL_COLUNA9			22
#DEFINE 	COL_SEPARA12		23
#DEFINE 	COL_COLUNA10		24
#DEFINE 	COL_SEPARA13		25
#DEFINE 	COL_COLUNA11		26
#DEFINE 	COL_SEPARA14		27
#DEFINE 	COL_COLUNA12		28
#DEFINE 	COL_SEPARA15		29

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao	 ≥ Ctbr285	≥ Autor ≥ Simone Mie Sato   	≥ Data ≥ 29.04.04     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Balancete Comparativo de C.Custo x Cta  s/ 6 meses. 	     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso 	   ≥ SIGACTB      							  				        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±≥Versao    ≥ 1.0                                                        ≥±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

user Function vit264()

Local aSetOfBook
Local aCtbMoeda	:= {}
Local cSayCC		:= CtbSayApro("CTT")
Local cDesc1 		:= STR0001			//"Este programa ira imprimir o Balancete Comparativo "
Local cDesc2 		:= Upper(Alltrim(cSayCC)) +" / "+ STR0011	// " Conta "
Local cDesc3 		:= STR0002  //"de acordo com os parametros solicitados pelo Usuario"
Local cNomeArq
LOCAL wnrel
LOCAL cString		:= "CTT"
Local titulo 		:= STR0003+Upper(Alltrim(cSayCC))+" / "+ STR0011 	//"Comparativo de" " Conta "
Local lRet			:= .T.
Local nDivide		:= 1
Local cMensagem		:= ""
Local lAtSlComp		:= Iif(GETMV("MV_SLDCOMP") == "S",.T.,.F.)

PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "PERGVIT264"
PRIVATE aReturn 	:= { STR0015, 1,STR0016, 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "VIT264"
PRIVATE Tamanho		:="G"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

CTR285SX1()

li 		:= 80
m_pag		:= 1

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Mostra tela de aviso - Atualizacao de saldos				 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cMensagem := STR0021+chr(13)  		//"Caso nao atualize os saldos compostos na"
cMensagem += STR0022+chr(13)  		//"emissao dos relatorios(MV_SLDCOMP ='N'),"
cMensagem += STR0023+chr(13)  		//"rodar a rotina de atualizacao de saldos "

IF !lAtSlComp
	IF !MsgYesNo(cMensagem,STR0009)	//"ATENÄéO"
		Return
	Endif
EndIf

aPergs := { {	"Comparar ?","®Comparar ?","Compare ?",;
				"mv_chu","N",1,0,0,"C","","mv_par30","Mov. Periodo","Mov. Periodo","Period Mov.","","",;
				"Saldo Acumulado","Saldo Acumulado","Accumulated Balance","","","","","","","","","","",;
				"","","","","","","","","S",;
				"" } }
AjustaSx1("PERGVIT264", aPergs)

Pergunte("PERGVIT264",.F.)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Variaveis utilizadas para parametros					       ≥
//≥ mv_par01				// Data Inicial              	       ≥
//≥ mv_par02				// Data Final                          ≥
//≥ mv_par03				// C.C. Inicial         		       ≥
//≥ mv_par04				// C.C. Final   					   ≥
//≥ mv_par05				// Conta Inicial                       ≥
//≥ mv_par06				// Conta Final   					   ≥
//≥ mv_par07				// Imprime Contas:Sintet/Analit/Ambas  ≥
//≥ mv_par08				// Set Of Books				    	   ≥
//≥ mv_par09				// Saldos Zerados?			     	   ≥
//≥ mv_par10				// Moeda?          			     	   ≥
//≥ mv_par11				// Pagina Inicial  		     		   ≥
//≥ mv_par12				// Saldos? Reais / Orcados/Gerenciais  ≥
//≥ mv_par13				// Imprimir ate o Segmento?			   ≥
//≥ mv_par14				// Filtra Segmento?					   ≥
//≥ mv_par15				// Conteudo Inicial Segmento?		   ≥
//≥ mv_par16				// Conteudo Final Segmento?		       ≥
//≥ mv_par17				// Conteudo Contido em?				   ≥
//≥ mv_par18				// Pula Pagina                         ≥
//≥ mv_par19				// Imprime Cod. C.Custo? Normal/Red.   ≥
//≥ mv_par20				// Imprime Cod. Conta? Normal/Reduzido ≥
//≥ mv_par21				// Salta linha sintetica?              ≥
//≥ mv_par22 				// Imprime Valor 0.00?                 ≥
//≥ mv_par23 				// Divide por?                         ≥
//≥ mv_par24				// Posicao Ant. L/P? Sim / Nao         ≥
//≥ mv_par25				// Data Lucros/Perdas?                 ≥
//≥ mv_par26				// Totaliza periodo ?                  ≥
//≥ mv_par27				// Se Totalizar ?                  	   ≥
//≥ mv_par28				// Imprime C.C?Sintet/Analit/Ambas 	   ≥
//≥ mv_par29				// Imprime Totalizacao de C.C. Sintet. ≥
//≥ mv_par30				// Tipo de Comparativo?(Movimento/Acumulado)  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

wnrel	:= "VIT264"+Alltrim(cusername)            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano≥
//≥ Gerencial -> montagem especifica para impressao)			 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If !ct040Valid(mv_par08)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par08)
Endif

If mv_par23 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par23 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par23 == 4		// Divide por milhao
	nDivide := 1000000
EndIf

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par10,nDivide)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		lRet := .F.
	Endif
Endif

If !lRet
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR285Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,nDivide)})

Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Program   ≥CTR285IMP ≥ Autor ≥ Simone Mie Sato       ≥ Data ≥ 29.04.04 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Imprime relatorio -> Balancete C.Custo/Conta               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ CTR285Imp(lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,cSayCC)  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥ Nenhum                                                     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ SIGACTB                                                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ lEnd 		= Acao do CodeBlock                           ≥±±
±±≥			 ≥ WnRel 		= Titulo do Relatorio				          ≥±±
±±≥			 ≥ cString		= Mensagem						              ≥±±
±±≥			 ≥ aSetOfBook 	= Registro de Config. Livros   		          ≥±±
±±≥			 ≥ aCtbMoeda	= Registro ref. a moeda escolhida             ≥±±
±±≥			 ≥ cSayCC		= Descric.C.Custo utilizado pelo usuario. 	  ≥±±
±±≥			 ≥ nDivide		= Fator de div.dos valores a serem impressos. ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function CTR285Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,nDivide)

Local aColunas		:= {}
Local CbTxt			:= Space(10)
Local CbCont		:= 0
Local limite		:= 220
Local cabec1  		:= ""
Local cabec2		:= ""
Local cPicture
Local cDescMoeda
Local cCodMasc		:= ""
Local cMascara		:= ""
Local cMascCC		:= ""
Local cSepara1		:= ""
Local cSepara2		:= ""
Local cGrupo		:= ""
Local lFirstPage	:= .T.
Local nDecimais
Local cCustoAnt		:= ""
Local cCCResAnt		:= ""
Local l132			:= .T.
Local lImpConta		:= .F.
Local lImpCusto		:= .T.
Local nTamConta		:= Len(CriaVar("CT1_CONTA"))
Local cCtaIni		:= mv_par05
Local cCtaFim		:= mv_par06
Local nPosAte		:= 0
Local nDigitAte		:= 0
Local cSegAte   	:= mv_par13
Local cArqTmp   	:= ""
Local cCCSup		:= ""//Centro de Custo Superior do centro de custo atual
Local cAntCCSup		:= ""//Centro de Custo Superior do centro de custo anterior

Local lPula			:= Iif(mv_par21==1,.T.,.F.)
Local lPrintZero	:= Iif(mv_par22==1,.T.,.F.)
Local lImpAntLP		:= Iif(mv_par24 == 1,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par09==1,.T.,.F.)
Local dDataLP  		:= mv_par25
Local aMeses		:= {}
Local dDataFim 		:= mv_par02
Local lJaPulou		:= .F.
Local nMeses		:= 1
Local aTotCol		:= {0,0,0,0,0,0,0,0,0,0,0,0}
Local aTotCC		:= {0,0,0,0,0,0,0,0,0,0,0,0}
Local aTotCCSup		:= {}
Local aSupCC		:= {}
Local nTotLinha		:= 0
Local nCont			:= 0

Local lImpSint 		:= Iif(mv_par07 == 2,.F.,.T.)
Local lImpTotS		:= Iif(mv_par29 == 1,.T.,.F.)
Local lImpCCSint	:= .T.
Local lNivel1		:= .F. 

Local nPos 			:= 0
Local nDigitos 		:= 0
Local n				:= 0
Local nVezes		:= 0
Local nPosCC		:= 0 
Local nTamaTotCC	:= 0
Local nAtuTotCC		:= 0 

cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)

aPeriodos := ctbPeriodos(mv_par10, mv_par01, mv_par02, .T., .F.)

For nCont := 1 to len(aPeriodos)
	//Se a Data do periodo eh maior ou igual a data inicial solicitada no relatorio.
	If aPeriodos[nCont][1] >= mv_par01 .And. aPeriodos[nCont][2] <= mv_par02
		If nMeses <= 12
			AADD(aMeses,{StrZero(nMeses,2),aPeriodos[nCont][1],aPeriodos[nCont][2]})
		EndIf
		nMeses += 1
	EndIf
Next

//Mascara do Centro de Custo
If Empty(aSetOfBook[6])
	cMascCC :=  GetMv("MV_MASCCUS")
Else
	cMascCC := RetMasCtb(aSetOfBook[6],@cSepara1)
EndIf

// Mascara da Conta ontabil
If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara := RetMasCtb(aSetOfBook[2],@cSepara2)
EndIf

cPicture 		:= aSetOfBook[4]
cabec1 := STR0004  //"|CODIGO            |DESCRICAO          |  PERIODO 01  |  PERIODO 02  |  PERIODO 03  |  PERIODO 04  |  PERIODO 05  |  PERIODO 06  |  PERIODO 07  |  PERIODO 08  |  PERIODO 09  |  PERIODO 10  |  PERIODO 11  |  PERIODO 12  |
tamanho := "G"
limite	:= 220
l132	:= .F.

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Carrega titulo do relatorio: Analitico / Sintetico			 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
IF mv_par07 == 1
	Titulo:=	STR0005+ Upper(Alltrim(cSayCC)) + " / "+ STR0011 		//"COMPARATIVO ANALITICO DE  "
ElseIf mv_par07 == 2
	Titulo:=	STR0006 + Upper(Alltrim(cSayCC)) + " / "+ STR0011		//"COMPARATIVO SINTETICO DE  "
ElseIf mv_par07 == 3
	Titulo:=	STR0007 + Upper(Alltrim(cSayCC)) + " / "+ STR0011		//"COMPARATIVO DE  "
EndIf

Titulo += 	STR0008 + DTOC(mv_par01) + STR0009 + Dtoc(mv_par02) + 	STR0010 + cDescMoeda

If mv_par12 > "1"
	Titulo += " (" + Tabela("SL", mv_par12, .F.) + ")"
Endif

If mv_par30 = 2
	mv_par26 := 2
	Titulo := AllTrim(Titulo) + " - " + STR0029
EndIf

aColunas := { 000, 001, 019, 020, 039, 040, 054, 055, 069, 070, 084, 085, 099, 100, 114,  115, 129, 130, 144, 145, 159, 160, 174, 175, 189, 190 , 204, 205, 219}

cabec1 := STR0004  //"|CODIGO            |DESCRICAO          |  PERIODO 01  |  PERIODO 02  |  PERIODO 03  |  PERIODO 04  |  PERIODO 05  |  PERIODO 06  |  PERIODO 07  |  PERIODO 08  |  PERIODO 09  |  PERIODO 10  |  PERIODO 11  |  PERIODO 12  |

If mv_par26 = 1		// Com total, nao imprime descricao
	If mv_par27 = 2
		Cabec1 := Stuff(Cabec1, 2, 10, Subs(Cabec1, 21, 10))
	Endif
	Cabec1 := Stuff(Cabec1, 21, 20, "")
	If mv_par27 == 1
		Cabec1 += " "+STR0028+"     |"	// TOTAL PERIODO
	Else
		Cabec1 += " "+STR0028+"|"	// TOTAL PERIODO
	EndIf
	
	
	For nCont := 6 to (Len(aColunas)-1)
		If mv_par27 == 1 			//Se mostrar conta
			aColunas[nCont] -= 20
		ElseIf mv_par27 == 2		// Se mostrar a descricao
			aColunas[nCont] -= 15
		EndIf
	Next
	
	If mv_par27 = 2
		Cabec1 := Stuff(Cabec1, 19, 0, Space(5))
		cabec2 := "|                       |"
	Else
		cabec2 := "|                  |"
	Endif
Else
	If mv_par20 = 2
		Cabec1 := 	Left(Cabec1, 11) + "|" + Subs(Cabec1, 21, 15) + Space(12) + "|" +;
		Subs(Cabec1, 41)
		Cabec2 := 	"|          |                           |"
	Else
		cabec2 := "|                  |                   |"
	Endif
Endif
For nCont := 1 to Len(aMeses)
	cabec2 += SPACE(1)+Strzero(Day(aMeses[nCont][2]),2)+"/"+Strzero(Month(aMeses[nCont][2]),2)+ " - "
	cabec2 += Strzero(Day(aMeses[nCont][3]),2)+"/"+Strzero(Month(aMeses[nCont][3]),2)+"|"
Next

For nCont:= Len(aMeses) to 12
	If nCont == 12
		//Se totaliza a linha e mostra a conta
		If mv_par26 == 1  .And. mv_par27 == 1
			cabec2+=SPACE(19)+"|"
		Else
			cabec2+=SPACE(14)+"|"
		EndIf
	Else
		cabec2+=SPACE(14)+"|"
	EndIf
Next

m_pag := mv_par11

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	For n := 1 to Val(cSegAte)
		nDigitAte += Val(Subs(cMascara,n,1))
	Next
EndIf

If !Empty(mv_par14)			//// FILTRA O SEGMENTO N∫
	If Empty(mv_par08)		//// VALIDA SE O C”DIGO DE CONFIGURA«√O DE LIVROS EST¡ CONFIGURADO
		help("",1,"CTN_CODIGO")
		Return
	Else
		If !Empty(aSetOfBook[5])
			MsgInfo(STR0012+CHR(10)+STR0024,STR0025)
			Return
		Endif
	Endif
	dbSelectArea("CTM")
	dbSetOrder(1)
	If MsSeek(xFilial()+aSetOfBook[2])
		While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == aSetOfBook[2]
			nPos += Val(CTM->CTM_DIGITO)
			If CTM->CTM_SEGMEN == STRZERO(val(mv_par14),2)
				nPos -= Val(CTM->CTM_DIGITO)
				nPos ++
				nDigitos := Val(CTM->CTM_DIGITO)
				Exit
			EndIf
			dbSkip()
		EndDo
	Else
		help("",1,"CTM_CODIGO")
		Return
	EndIf
EndIf


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta Arquivo Temporario para Impressao							  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
CTGerComp(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
mv_par01,mv_par02,"CT3","",mv_par05,mv_par06,mv_par03,mv_par04,,,,,mv_par10,;
mv_par12,aSetOfBook,mv_par14,mv_par15,mv_par16,mv_par17,;
.F.,.F.,,"CTT",lImpAntLP,dDataLP,nDivide,"M",.F.,,.T.,aMeses,lVlrZerado,,,lImpSint,cString,aReturn[7],lImpTotS)},;
STR0013,;  //"Criando Arquivo Tempor†rio..."
STR0003+Upper(Alltrim(cSayCC)) +" / " +  STR0011 )     //"Balancete Verificacao C.CUSTO / CONTA

If Select("cArqTmp") == 0
	Return
EndIf          

If mv_par29 == 1	//Se totaliza centro de custo 
	dbSelectArea("cArqTmp")
	dbSetOrder(1)
	dbGotop()
	While!Eof()		       
		If !Empty(cArqTmp->CCSUP) 
			dbSelectArea("CTT")
			dbSetOrder(1)
			If MsSeek(xFilial()+cArqTmp->CCSUP)
				If Empty(CTT->CTT_CCSUP) 
					lNivel1	:= .T.
				Else
					lNivel1	:= .F.
				EndIf
			EndIf
			
			dbSelectArea("cArqTmp")  
//			If (( mv_par28 == 2 .And. TIPOCC == "2" ) .Or. (mv_par28 == 1 .And. TIPOCC == "1" .And. Empty(CCSUP)) .Or. (mv_par28 == 3 ) .Or. lNivel1) .And.;
			If (( mv_par28 == 2 .And. TIPOCC == "2" ) .Or. (mv_par28 == 1 .And. TIPOCC == "1" ) .Or. (mv_par28 == 3 ) .Or. lNivel1) .And.;
				(( mv_par07 == 2 .And. TIPOCONTA == "2" ) .Or. (mv_par07 <> 2 .And. TIPOCONTA == "1" .And. Empty(CTASUP)))                

		
				nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]==CCSUP})			
				If  nPosCC <= 0 				
	   		        aSupCC := {}
					For nVezes := 1 to Len(aMeses)	
		                aAdd(aSupCC,&("COLUNA"+Alltrim(Str(nVezes,2))))
					Next
					If Len(aMeses) < 12
						For nVezes := Len(aMeses)+1 to 12
		                	aAdd(aSupCC,0)				
						Next
					EndIf	                
					AADD(aTotCCSup,{CCSUP,aSupCC})
				Else     
					For nVezes := 1 to Len(aMeses)				
						aTotCCSup[nPosCC][2][nVezes]	+= 	&("COLUNA"+Alltrim(Str(nVezes,2)))
					Next										
				EndIf
			EndIf                
		EndIf
		dbSkip()
	End
EndIf

dbSelectArea("cArqTmp")
dbSetOrder(1)
dbGoTop()

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
	Return
Endif

SetRegua(RecCount())

//cCustoAnt := cArqTmp->CUSTO

While !Eof()
	
	If lEnd
		@Prow()+1,0 PSAY STR0016   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF
	
	IncRegua()
	
	******************** "FILTRAGEM" PARA IMPRESSAO *************************
	
	
	If mv_par28 == 1					// So imprime Sinteticas
		If TIPOCC == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par28 == 2				// So imprime Analiticas
		If TIPOCC == "1"
			dbSkip()
			Loop
		EndIf
	EndIf
	
	If mv_par07 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par07 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf
	
	//Filtragem ate o Segmento ( antigo nivel do SIGACON)
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf
	
	//Caso faca filtragem por segmento de Conta,verifico se esta dentro
	//da solicitacao feita pelo usuario.
	If !Empty(mv_par14)
		If Empty(mv_par15) .And. Empty(mv_par16) .And. !Empty(mv_par17)
			If  !(Substr(cArqTMP->CONTA,nPos,nDigitos) $ (mv_par17) )
				dbSkip()
				Loop
			EndIf
		Else
			If Substr(cArqTMP->CONTA,nPos,nDigitos) < Alltrim(mv_par15) .Or. Substr(cArqTMP->CONTA,nPos,nDigitos) > Alltrim(mv_par16)
				dbSkip()
				Loop
			EndIf
		Endif
	EndIf
	
	************************* ROTINA DE IMPRESSAO *************************
	If li > 58 
		If !lFirstPage 
			@ Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.				
	Endif                 

	If (cCustoAnt <> cArqTmp->CUSTO) .And. ! Empty(cCustoAnt)
		@li,00 PSAY	Replicate("-",limite)
		li++
		@li,aColunas[COL_SEPARA1] PSAY "|"
		
		If mv_par26 == 2
			@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(Alltrim(cSayCC))+ " : " //"T O T A I S  D O  "
			If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
				EntidadeCTB(cCCResAnt,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
			Else //Se Imprime cod. normal do Centro de Custo
				EntidadeCTB(cCustoAnt,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
			Endif
			@ li,aColunas[COL_SEPARA3] PSAY "|"
		Else
			@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: " 			
			If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
				@li,9 PSAY Subs(cCCResAnt,1,10)
			Else //Se Imprime cod. normal do Centro de Custo
				@li,9 PSAY Subs(cCustoAnt,1,10)			
			Endif			
			If mv_par27 == 1
				@li,aColunas[COL_SEPARA2] PSAY "|"
			Else
				@li,aColunas[COL_SEPARA2]+5 PSAY "|"
			EndIf
		EndIf
		
		dbSelectArea("CTT")
		dbSetOrder(1)
		If MsSeek(xFilial()+cArqTmp->CUSTO)
			cCCSup	:= CTT->CTT_CCSUP
		Else
			cCCSup	:= ""
		EndIf
		
		dbSelectArea("CTT")
		dbSetOrder(1)
		If MsSeek(xFilial()+cCustoAnt)
			cAntCCSup	:= CTT->CTT_CCSUP
		Else
			cAntCCSup	:= ""
		EndIf
		dbSelectArea("cArqTmp")			
		
		//Total da Linha
		nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
		For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
			nTotLinha	+= aTotCC[nVezes]
		Next
		
		ValorCTB(aTotCC[1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA4]		PSAY "|"
		ValorCTB(aTotCC[2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA5]		PSAY "|"
		ValorCTB(aTotCC[3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA6]		PSAY "|"
		ValorCTB(aTotCC[4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"
		ValorCTB(aTotCC[5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA8] PSAY "|"
		ValorCTB(aTotCC[6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA9] PSAY "|"
		ValorCTB(aTotCC[7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA10] PSAY "|"
		ValorCTB(aTotCC[8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA11] PSAY "|"
		ValorCTB(aTotCC[9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA12] PSAY "|"
		ValorCTB(aTotCC[10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA13] PSAY "|"
		ValorCTB(aTotCC[11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA14] PSAY "|"
		ValorCTB(aTotCC[12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		If mv_par26 = 1		// Imprime Total
			If mv_par27 == 1//Mostrar a conta
				@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
				ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
			ElseIf mv_par27 == 2	//Mostrar a descricao
				@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
				ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
			EndIf
		Endif
		@ li,aColunas[COL_SEPARA15] PSAY "|"
		aTotCC 	:= {0,0,0,0,0,0,0,0,0,0,0,0}
		
		If lImpTotS .And. cCCSup <> cAntCCSup .And. !Empty(cAntCCSup) //Se for centro de custo superior diferente
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			If mv_par26 == 2
				@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(Alltrim(cSayCC))+ " : " //"T O T A I S  D O  "
				If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
					EntidadeCTB(cCCResAnt,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
				Else //Se Imprime cod. normal do Centro de Custo
					EntidadeCTB(cAntCCSup,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
				Endif
				@ li,aColunas[COL_SEPARA3] PSAY "|"
			Else
				@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: "
				If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
					@li,9 PSAY Subs(cCCResAnt,1,10)
				Else //Se Imprime cod. normal do Centro de Custo
					@li,9 PSAY Subs(cAntCCSup,1,10)			
				Endif								
				If mv_par27 == 1
					@li,aColunas[COL_SEPARA2] PSAY "|"
				Else
					@li,aColunas[COL_SEPARA2]+5 PSAY "|"
				EndIf
			EndIf
			
			//Total da Linha
			nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
			
			nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })			
			If  nPosCC > 0 							
				For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
					nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
				Next
			
				ValorCTB(aTotCCSup[nPosCC][2][1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA4]		PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA5]		PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA6]		PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA7] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA8] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA9] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA10] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA11] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA12] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA13] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA14] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				If mv_par26 = 1		// Imprime Total
					If mv_par27 == 1//Mostrar a conta
						@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
						ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
					ElseIf mv_par27 == 2	//Mostrar a descricao
						@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
						ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
					EndIf
				Endif
				@ li,aColunas[COL_SEPARA15] PSAY "|"
				dbSelectArea("cArqTmp")
				nRegTmp	:= Recno()
				dbSelectArea("CTT")
				lImpCCSint	:= .T.
			EndIf
			While lImpCCSint
				dbSelectArea("CTT")
				If MsSeek(xFilial()+cAntCCSup) .And. !Empty(CTT->CTT_CCSUP)
					cAntCCSup	:= CTT->CTT_CCSUP
					li++
					@li,aColunas[COL_SEPARA1] PSAY "|"
					If mv_par26 == 2
						@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(Alltrim(cSayCC))+ " : " //"T O T A I S  D O  "
						EntidadeCTB(cAntCCSup,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
						@ li,aColunas[COL_SEPARA3] PSAY "|"
					Else
						@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: "
						@li,9 PSAY Subs(cAntCCSup,1,10)			

						If mv_par27 == 1
							@li,aColunas[COL_SEPARA2] PSAY "|"
						Else
							@li,aColunas[COL_SEPARA2]+5 PSAY "|"
						EndIf
					EndIf
					dbSelectArea("cArqTmp")
					
					//Total da Linha
					nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
					nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })			
					If  nPosCC > 0 							
						For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
							nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
						Next
					
						ValorCTB(aTotCCSup[nPosCC][2][1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						@ li,aColunas[COL_SEPARA4]		PSAY "|"
						ValorCTB(aTotCCSup[nPosCC][2][2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						@ li,aColunas[COL_SEPARA5]		PSAY "|"
						ValorCTB(aTotCCSup[nPosCC][2][3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						@ li,aColunas[COL_SEPARA6]		PSAY "|"
						ValorCTB(aTotCCSup[nPosCC][2][4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						@ li,aColunas[COL_SEPARA7] PSAY "|"
						ValorCTB(aTotCCSup[nPosCC][2][5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						@ li,aColunas[COL_SEPARA8] PSAY "|"
						ValorCTB(aTotCCSup[nPosCC][2][6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						@ li,aColunas[COL_SEPARA9] PSAY "|"
						ValorCTB(aTotCCSup[nPosCC][2][7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						@ li,aColunas[COL_SEPARA10] PSAY "|"
						ValorCTB(aTotCCSup[nPosCC][2][8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						@ li,aColunas[COL_SEPARA11] PSAY "|"
						ValorCTB(aTotCCSup[nPosCC][2][9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						@ li,aColunas[COL_SEPARA12] PSAY "|"
						ValorCTB(aTotCCSup[nPosCC][2][10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						@ li,aColunas[COL_SEPARA13] PSAY "|"
						ValorCTB(aTotCCSup[nPosCC][2][11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						@ li,aColunas[COL_SEPARA14] PSAY "|"
						ValorCTB(aTotCCSup[nPosCC][2][12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
						If mv_par26 = 1		// Imprime Total
							If mv_par27 == 1//Mostrar a conta
								@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
								ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
							ElseIf mv_par27 == 2	//Mostrar a descricao
								@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
								ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
							EndIf
						Endif
						@ li,aColunas[COL_SEPARA15] PSAY "|"
						li++
						lImpCCSint	:= .T. 
					EndIF
				Else
					lImpCCSint	:= .F.
				EndIf
			End
			cAntCCSup		:= ""
			cCCSup			:= ""
			dbSelectArea("cArqTmp")
			dbGoto(nRegTmp)
		EndIf
		
	Endif
	If mv_par18 == 1 .And. ! Empty(cCustoAnt)
		If cCustoAnt <> cArqTmp->CUSTO //Se o CC atual for diferente do CC anterior
			li 	:= 60
		EndIf
	Endif
	
	If li > 58
		If !lFirstPage
			@ Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.
	Endif
	
	//Se mudar de centro de custo
	If CUSTO <> cCustoAnt 
		//Imprime titulo do centro de custo
		li++	
		@li,00 PSAY REPLICATE("-",limite)
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		@ li,aColunas[COL_CONTA]+4 PSAY Upper(cSayCC)
		If mv_par19 == 2 .And. cArqTmp->TIPOCC == '2'//Se Imprime Cod Reduzido do C.Custo e eh analitico
			EntidadeCTB(CCRES,li,aColunas[COL_CONTA]+20,20,.F.,cMascCC,cSepara1)
		Else //Se Imprime Cod. Normal do C.Custo
			EntidadeCTB(CUSTO,li,aColunas[COL_CONTA]+20,20,.F.,cMascCC,cSepara1)
		Endif
		@ li,aColunas[COL_CONTA]+ Len(CriaVar("CTT_DESC01")) PSAY " - " +cArqTMP->DESCCC
		@ li,aColunas[COL_SEPARA15] PSAY "|"
		li++
		@li,00 PSAY REPLICATE("-",limite)
		li++
	Endif
	
	//Total da Linha
	nTotLinha	:= COLUNA1+COLUNA2+COLUNA3+COLUNA4+COLUNA5+COLUNA6+COLUNA7+COLUNA8+COLUNA9+COLUNA10+COLUNA11+COLUNA12
	
	@ li,aColunas[COL_SEPARA1] PSAY "|"
	//Se totaliza e mostra a descricao
	If mv_par26 = 1 .And. mv_par27 = 2
		@ li,aColunas[COL_CONTA] PSAY Left(DESCCTA,18)
		@ li,aColunas[COL_SEPARA2]+5 PSAY "|"
	Else
		If mv_par20 == 1       //Codigo Normal
			@ li,aColunas[COL_CONTA] PSAY alltrim(mascara(conta))
//			EntidadeCTB(Subs(CONTA,1,18),li,aColunas[COL_CONTA],18,.F.,cMascara,cSepara2)
		Else //Codigo Reduzido
			EntidadeCTB(CTARES,li,aColunas[COL_CONTA],16,.F.,cMascara,cSepara2)
		Endif
		@ li,aColunas[COL_SEPARA2] PSAY "|"
	Endif
	
	// Se nao totalizar ou se totalizar e mostrar a descricao da conta
	If mv_par26 == 2
		@ li,aColunas[COL_DESCRICAO] PSAY Left(DESCCTA,19)
		@ li,aColunas[COL_SEPARA3] PSAY "|"
	Endif
              
	If mv_par30 == 2
		COLUNA2 += COLUNA1
		COLUNA3 += COLUNA2
		COLUNA4 += COLUNA3
		COLUNA5 += COLUNA4
		COLUNA6 += COLUNA5
		COLUNA7 += COLUNA6
		COLUNA8 += COLUNA7
		COLUNA9 += COLUNA8
		COLUNA10 += COLUNA9
		COLUNA11 += COLUNA10
		COLUNA12 += COLUNA11
	Endif
	
	ValorCTB(COLUNA1,li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(COLUNA2,li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(COLUNA3,li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	ValorCTB(COLUNA4,li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA7] PSAY "|"
	ValorCTB(COLUNA5,li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	ValorCTB(COLUNA6,li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA9] PSAY "|"
	ValorCTB(COLUNA7,li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA10] PSAY "|"
	ValorCTB(COLUNA8,li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA11] PSAY "|"
	ValorCTB(COLUNA9,li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA12] PSAY "|"
	ValorCTB(COLUNA10,li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA13] PSAY "|"
	ValorCTB(COLUNA11,li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA14] PSAY "|"
	ValorCTB(COLUNA12,li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	If mv_par26 == 1
		If mv_par27 == 1
			@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
			ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
		ElseIf mv_par27 == 2	//Mostrar a descricao
			@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
			ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
		EndIf
	EndIf
	@ li,aColunas[COL_SEPARA15] PSAY "|"
	lJaPulou := .F.
	If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		//Se totaliza e mostra a descricao da conta
		If mv_par26 == 1 .And. mv_par27 == 2
			@ li,aColunas[COL_SEPARA2]+5 PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA2] PSAY "|"
		EndIf
		//Se nao totaliza periodo
		If mv_par26 == 2
			@ li,aColunas[COL_SEPARA3] PSAY "|"
		EndIf
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		@ li,aColunas[COL_SEPARA7] PSAY "|"
		@ li,aColunas[COL_SEPARA8] PSAY "|"
		@ li,aColunas[COL_SEPARA9] PSAY "|"
		@ li,aColunas[COL_SEPARA10] PSAY "|"
		@ li,aColunas[COL_SEPARA11] PSAY "|"
		@ li,aColunas[COL_SEPARA12] PSAY "|"
		@ li,aColunas[COL_SEPARA13] PSAY "|"
		@ li,aColunas[COL_SEPARA14] PSAY "|"
		If mv_par26 == 1
			If mv_par27 == 1
				@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
			Endif
		EndIf
		@ li,aColunas[COL_SEPARA15] PSAY "|"
		li++
		lJaPulou := .T.
	Else
		li++
	EndIf
	
	************************* FIM   DA  IMPRESSAO *************************

	If mv_par07 != 1					// Imprime Analiticas ou Ambas
		If TIPOCONTA == "2"
			If (mv_par28 != 1 .And. TIPOCC == "2")
				For nVezes := 1 to Len(aMeses)
					aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))					
				Next
			ElseIf (mv_par28 == 1 .And. cArqTmp->TIPOCC != "2"	)	//Imprime centro de custo sintetico
				If mv_par07 == 2 	//Imprime contas analiticas
					For nVezes := 1 to Len(aMeses)            
						If Empty(CCSUP)
							aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))					
						EndIf
					Next         
				ElseIf mv_par07 == 3	//Imprime contas sinteticas e analiticas
					If Empty(CCSUP)      //Somar somente o centro de custo sintetico
						For nVezes := 1 to Len(aMeses)
							aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))											
						Next         					
					EndIf				
				EndIf
			EndIf	
			For nVezes := 1 to Len(aMeses)
				aTotCC[nVezes] 		+=&("COLUNA"+Alltrim(Str(nVezes,2)))									
			Next	
		Endif
	Else
		If (TIPOCONTA == "1" .And. Empty(CTASUP))
			If (mv_par28 != 1 .And. cArqTmp->TIPOCC == "2")
				For nVezes := 1 to Len(aMeses)
					aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))					
				Next
			ElseIf (mv_par28 == 1 .And. cArqTmp->TIPOCC != "2"	)
				If Empty(CCSUP)
					For nVezes := 1 to Len(aMeses)
						aTotCol[nVezes] 	+=&("COLUNA"+Alltrim(Str(nVezes,2)))			
					Next
				EndIf
			EndIf	
			For nVezes := 1 to Len(aMeses)
				aTotCC[nVezes] 		+=&("COLUNA"+Alltrim(Str(nVezes,2)))					
			Next
		EndIf		
	Endif

	cCustoAnt := cArqTmp->CUSTO
	cCCResAnt := cArqTmp->CCRES
	

	dbSelectarea("cArqTmp")
	dbSkip()
	
	If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			//Se totaliza e mostra a descricao da conta
			If mv_par26 == 1 .And. mv_par27 == 2
				@ li,aColunas[COL_SEPARA2]+5 PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA2] PSAY "|"
			EndIf
			//Se nao totaliza periodo
			If mv_par26 == 2
				@ li,aColunas[COL_SEPARA3] PSAY "|"
			EndIf
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			@ li,aColunas[COL_SEPARA8] PSAY "|"
			@ li,aColunas[COL_SEPARA9] PSAY "|"
			@ li,aColunas[COL_SEPARA10] PSAY "|"
			@ li,aColunas[COL_SEPARA11] PSAY "|"
			@ li,aColunas[COL_SEPARA12] PSAY "|"
			@ li,aColunas[COL_SEPARA13] PSAY "|"
			@ li,aColunas[COL_SEPARA14] PSAY "|"
			//Se totaliza linha
			If mv_par26 == 1
				If mv_par27 == 1
					@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
				Else
					@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
				EndIf
			EndIf
			
			@ li,aColunas[COL_SEPARA15] PSAY "|"
			li++
		EndIf
	EndIf
End

If li > 50
	If !lFirstPage
		@ Prow()+1,00 PSAY	Replicate("-",limite)
	EndIf
	CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
Endif

//Imprime o total do ultimo Conta a ser impresso.
@li,00 PSAY	Replicate("-",limite)
li++
@li,aColunas[COL_SEPARA1] PSAY "|"

dbSelectArea("CTT")
dbSetOrder(1)
If MsSeek(xFilial("CTT")+cArqTmp->CUSTO)
	cCCSup	:= CTT->CTT_CCSUP	//Centro de Custo Superior
Else
	cCCSup	:= ""
EndIf

If MsSeek(xFilial("CTT")+cCustoAnt)
	cAntCCSup := CTT->CTT_CCSUP	//Centro de Custo Superior do Centro de custo anterior.
	cCCRes	  := CTT->CTT_RES
Else
	cAntCCSup := ""
EndIf

dbSelectArea("cArqTmp")

If mv_par26 == 2
	@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(cSayCC)+ " : " //"T O T A I S  D O  "
	If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
		EntidadeCTB(cCCResAnt,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
	Else //Se Imprime cod. normal do Centro de Custo
		EntidadeCTB(cCustoAnt,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
	Endif
	@ li,aColunas[COL_SEPARA3] PSAY "|"
Else
	@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: "
	If mv_par27 == 1
		If mv_par19 == 2	.And. cArqTmp->TIPOCC == '2'//Se Imprime cod. reduzido do centro de Custo e eh analitico
			@li,9 PSAY Subs(cCCResAnt,1,10)
		Else //Se Imprime cod. normal do Centro de Custo
			@li,9 PSAY Subs(cCustoAnt,1,10)			
		Endif				
		@ li,aColunas[COL_SEPARA2] PSAY "|"
	Else
		@ li,aColunas[COL_SEPARA2]+5 PSAY "|"
	EndIf
EndIf

ValorCTB(aTotCC[1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA4]		PSAY "|"
ValorCTB(aTotCC[2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA5]		PSAY "|"
ValorCTB(aTotCC[3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA6]		PSAY "|"
ValorCTB(aTotCC[4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA7] PSAY "|"
ValorCTB(aTotCC[5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA8] PSAY "|"
ValorCTB(aTotCC[6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA9] PSAY "|"
ValorCTB(aTotCC[7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA10] PSAY "|"
ValorCTB(aTotCC[8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA11] PSAY "|"
ValorCTB(aTotCC[9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA12] PSAY "|"
ValorCTB(aTotCC[10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA13] PSAY "|"
ValorCTB(aTotCC[11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA14] PSAY "|"
ValorCTB(aTotCC[12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)

//Total da Linha
nTotLinha	:= 0
For nVezes := 1 to Len(aMeses)
	nTotLinha	+= aTotCC[nVezes]
Next

If mv_par26 == 1
	If mv_par27 == 1	//Mostrar a conta
		@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
		ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	ElseIf mv_par27 == 2	//Mostrar a descricao
		@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
		ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
	EndIf
EndIf
@ li,aColunas[COL_SEPARA15] PSAY "|"
If (cArqTmp->TIPOCC == "1" .And. !Empty(cArqTmp->CCSUP)) .Or. (cArqTmp->TIPOCC == "2")	
	aTotCC 	:= {0,0,0,0,0,0,0,0,0,0,0,0}
EndIf
li++

If lImpTotS .And. cCCSup <> cAntCCSup .And. !Empty(cAntCCSup) //Se for centro de custo superior diferente

	@li,aColunas[COL_SEPARA1] PSAY "|"
	If mv_par26 == 2
		@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(Alltrim(cSayCC))+ " : " //"T O T A I S  D O  "
		EntidadeCTB(cAntCCSup,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
		@ li,aColunas[COL_SEPARA3] PSAY "|"
	Else
		@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: "
		@li,9 PSAY Subs(cAntCCSup,1,10)			

		If mv_par27 == 1
			@li,aColunas[COL_SEPARA2] PSAY "|"
		Else
			@li,aColunas[COL_SEPARA2]+5 PSAY "|"
		EndIf
	EndIf
	
	//Total da Linha
	nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
	nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })			
	If  nPosCC > 0 							
		For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
			nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
		Next
	
		ValorCTB(aTotCCSup[nPosCC][2][1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA4]		PSAY "|"
		ValorCTB(aTotCCSup[nPosCC][2][2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA5]		PSAY "|"
		ValorCTB(aTotCCSup[nPosCC][2][3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA6]		PSAY "|"
		ValorCTB(aTotCCSup[nPosCC][2][4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"
		ValorCTB(aTotCCSup[nPosCC][2][5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA8] PSAY "|"
		ValorCTB(aTotCCSup[nPosCC][2][6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA9] PSAY "|"
		ValorCTB(aTotCCSup[nPosCC][2][7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA10] PSAY "|"
		ValorCTB(aTotCCSup[nPosCC][2][8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA11] PSAY "|"
		ValorCTB(aTotCCSup[nPosCC][2][9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA12] PSAY "|"
		ValorCTB(aTotCCSup[nPosCC][2][10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA13] PSAY "|"
		ValorCTB(aTotCCSup[nPosCC][2][11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA14] PSAY "|"
		ValorCTB(aTotCCSup[nPosCC][2][12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
		If mv_par26 = 1		// Imprime Total
			If mv_par27 == 1//Mostrar a conta
				@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
				ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
			ElseIf mv_par27 == 2	//Mostrar a descricao
				@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
				ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
			EndIf
		Endif
		@ li,aColunas[COL_SEPARA15] PSAY "|"
		li++
		dbSelectArea("CTT")
		lImpCCSint	:= .T.
    EndIf
		
	While lImpCCSint
		dbSelectArea("CTT")
		If MsSeek(xFilial()+cAntCCSup) .And. !Empty(CTT->CTT_CCSUP)
			cAntCCSup	:= CTT->CTT_CCSUP
			@li,aColunas[COL_SEPARA1] PSAY "|"
			If mv_par26 == 2
				@li,aColunas[COL_CONTA] PSAY STR0018+ Upper(Alltrim(cSayCC))+ " : " //"T O T A I S  D O  "
				EntidadeCTB(cAntCCSup,li,aColunas[COL_CONTA]+23,15,.F.,cMascCC,cSepara1)
				@ li,aColunas[COL_SEPARA3] PSAY "|"
			Else
				@li,aColunas[COL_CONTA] PSAY STR0026 //"TOTAIS: "
				@li,9 PSAY Subs(cAntCCSup,1,10)			

				If mv_par27 == 1
					@li,aColunas[COL_SEPARA2] PSAY "|"
				Else
					@li,aColunas[COL_SEPARA2]+5 PSAY "|"
				EndIf
			EndIf
			dbSelectArea("cArqTmp")
			
			//Total da Linha
			nTotLinha	:= 0     			// Incluso esta linha para impressao dos totais
			nPosCC	:= ASCAN(aTotCCSup,{|x| x[1]== cAntCCSup })			
			If  nPosCC > 0 							
				For nVezes := 1 to Len(aMeses)	// por periodo em 09/06/2004 por Otacilio
					nTotLinha	+= aTotCCSup[nPosCC][2][nVezes]
				Next
				
				ValorCTB(aTotCCSup[nPosCC][2][1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA4]		PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA5]		PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA6]		PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA7] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA8] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA9] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA10] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA11] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA12] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA13] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA14] PSAY "|"
				ValorCTB(aTotCCSup[nPosCC][2][12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
				If mv_par26 = 1		// Imprime Total
					If mv_par27 == 1//Mostrar a conta
						@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
						ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
					ElseIf mv_par27 == 2	//Mostrar a descricao
						@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
						ValorCTB(nTotLinha,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
					EndIf
				Endif
				@ li,aColunas[COL_SEPARA15] PSAY "|"
				li++ 
				lImpCCSint	:= .T.
			EndIf
		Else
			lImpCCSint	:= .F.
		EndIf
	End
	cAntCCSup		:= ""
	cCCSup			:= ""
	dbSelectArea("cArqTmp")
EndIf

IF li != 80 .And. !lEnd
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] PSAY "|"
	If mv_par26 == 2
		@li,aColunas[COL_CONTA]   PSAY STR0017  		//"T O T A I S  D O  P E R I O D O : "
		@ li,aColunas[COL_SEPARA3]		PSAY "|"
	Else
		@li,aColunas[COL_CONTA]   PSAY STR0027  		//"TOTAIS  DO  PERIODO: "
		If mv_par27 == 1
			@ li,aColunas[COL_SEPARA2]		PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA2]+4   PSAY "|"
		EndIf
	EndIf
	ValorCTB(aTotCol[1],li,aColunas[COL_COLUNA1],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(aTotCol[2],li,aColunas[COL_COLUNA2],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(aTotCol[3],li,aColunas[COL_COLUNA3],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	ValorCTB(aTotCol[4],li,aColunas[COL_COLUNA4],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA7] PSAY "|"
	ValorCTB(aTotCol[5],li,aColunas[COL_COLUNA5],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	ValorCTB(aTotCol[6],li,aColunas[COL_COLUNA6],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA9] PSAY "|"
	ValorCTB(aTotCol[7],li,aColunas[COL_COLUNA7],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA10] PSAY "|"
	ValorCTB(aTotCol[8],li,aColunas[COL_COLUNA8],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA11] PSAY "|"
	ValorCTB(aTotCol[9],li,aColunas[COL_COLUNA9],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA12] PSAY "|"
	ValorCTB(aTotCol[10],li,aColunas[COL_COLUNA10],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA13] PSAY "|"
	ValorCTB(aTotCol[11],li,aColunas[COL_COLUNA11],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA14] PSAY "|"
	ValorCTB(aTotCol[12],li,aColunas[COL_COLUNA12],12,nDecimais,CtbSinalMov(),cPicture,, , , , , ,lPrintZero)
	
	//TOTAL GERAL
	nTotGeral	:= aTotCol[1]+aTotCol[2]+aTotCol[3]+aTotCol[4]+aTotCol[5]+aTotCol[6]+aTotCol[7]
	nTotGeral 	+= aTotCol[8]+aTotCol[9]+aTotCol[10]+aTotCol[11]+aTotCol[12]
	
	If mv_par26 = 1		// Imprime Total
		If mv_par27 == 1//Mostrar a conta
			@ li,aColunas[COL_SEPARA15]-20 PSAY "|"
			ValorCTB(nTotGeral,li,aColunas[COL_SEPARA15]-18,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
		ElseIf mv_par27 == 2	//Mostrar a descricao
			@ li,aColunas[COL_SEPARA15]-15 PSAY "|"
			ValorCTB(nTotGeral,li,aColunas[COL_SEPARA15]-14,12,nDecimais,CtbSinalMov(),cPicture, NORMAL, , , , , ,lPrintZero)
		EndIf
	Endif
	
	nTotGeral	:= 0
	@ li,aColunas[COL_SEPARA15] PSAY "|"
	
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY " "
	roda(cbcont,cbtxt,"M")
	Set Filter To
EndIF

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
Ferase(cArqTmp+GetDBExtension())
Ferase("cArqInd"+OrdBagExt())
dbselectArea("CT2")

MS_FLUSH()

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ CTR285SX1    ≥Autor ≥Simone Mie Sato       ≥Data≥ 30/04/04 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Cria as perguntas do relatÛrio                             ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function CTR285SX1()

Local aPergs 		:= {}
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCusto		:= TAMSX3("CTT_CUSTO")

aAdd(aPergs,{	"Data Inicial       ?","®Fecha Inicial     ?","Initial Date       ?","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","S",".CTR04001."})
aAdd(aPergs,{	"Data Final         ?","®Fecha Final       ?","Final Date         ?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","S",".CTR04002."})
aAdd(aPergs,{	"Do Centro de Custo ?","®De Centro de Costo?","From Cost Center   ?","mv_ch3","C",aTamCusto[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT","004","S",".CTR18005."})
aAdd(aPergs,{	"Ate o C.Custo		?","®A Centro de Costo ?","To Cost Center     ?","mv_ch4","C",aTamCusto[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT","004","S",".CTR18006."})
aAdd(aPergs,{	"Conta Inicial      ?","®Cuenta Inicial    ?","Initial Account    ?","mv_ch5","C",aTamConta[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CT1","003","S",".CTR04003."})
aAdd(aPergs,{	"Conta Final        ?","®Cuenta Final      ?","Final Account      ?","mv_ch6","C",aTamConta[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CT1","003","S",".CTR04004."})
Aadd(aPergs,{	"Imprime Contas     ?","®Imprime Cuentas   ?","Print Accounts     ?","mv_ch7","N",1,0,0,"C","","mv_par07","Sinteticas","Sinteticas","Summarized","","","Analiticas","Analiticas","Detailed","","","Ambas","Ambas","Both","","","","","","","","","","","","","","S",".CTR18007."})
aAdd(aPergs,{	"Cod.Config.Livros	?","®Cod. Config.Libros?","Books Setup Code   ?","mv_ch8","C",3,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTN","","S",".CTR04006."})
Aadd(aPergs,{	"Saldos Zerados     ?","®Saldos en Cero    ?","Zeroed Balances    ?","mv_ch9","N",1,0,0,"C","","mv_par09","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S",".CTR18009."})
aAdd(aPergs,{	"Moeda              ?","®Que Moneda        ?","Currency           ?","mv_cha","C",2,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","CTO","","S",".CTR04008."})
Aadd(aPergs,{	"Folha Inicial      ?","®Pagina Inicial    ?","Initial Page       ?","mv_chb","N",3,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","S",".CTR18011."})
aAdd(aPergs,{	"Tipo de Saldo      ?","®Tipo de Saldo     ?","Balance Type       ?","mv_chc","C",1,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","S",".CTR04010."})
Aadd(aPergs,{	"Imprime ate o seg. ?","®Imprim. hasta sig.?","Print Until Segment?","mv_chd","C",2,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","","S",".CTR18014."})
Aadd(aPergs,{	"Filtra segmento No.?","®Filtra Segmento No?","Filter Segment Nr. ?","mv_che","C",2,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","","S",".CTR18015."})
Aadd(aPergs,{	"Conteudo Ini Segmen?","®Conten.Ini Segment?","Segm.Init.Contents ?","mv_chf","C",20,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","","","S",".CTR18016."})
Aadd(aPergs,{	"Conteudo Fim Segmen?","®Conten.Fin Segment?","Segm.Final Contents?","mv_chg","C",20,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","","","S",".CTR18017."})
Aadd(aPergs,{	"Conteudo Contido em?","®Contenido de      ?","Enclosed In        ?","mv_chh","C",30,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","","","S",".CTR18018."})
Aadd(aPergs,{	"Pula Pagina        ?","®Salta Pagina      ?","Skip Page          ?","mv_chi","N",1,0,0,"C","","mv_par18","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S",".CTR44020."})
Aadd(aPergs,{	"Imprime Cod. C.C   ?","®Imprime Cod. C.C. ?","Print Code C.C.    ?","mv_chj","N",1,0,0,"C","","mv_par19","Normal","Normal","Normal","","","Reduzido","Reducido","Reduced","","","","","","","","","","","","","","","","","","","S",".CTR18024."})
aAdd(aPergs,{	"Imprime Cod. Conta ?","®Impr Cod Cuenta   ?","Print Account Code ?","mv_chk","N",1,0,0,"C","","mv_par20","Normal","Normal","Normal","","","Reduzido","Reducido","Reduced","","","","","","","","","","","","","","","","","","","S",".CTR18026."})
Aadd(aPergs,{  "Salta Linha Sintet.?","®Salta Linea Sintet?","Skip Line Summary  ?","mv_chl","N",1,0,1,"C","","mv_par21","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S",".CTR18022."})
Aadd(aPergs,{  "Imprime Valor O,OO ?","®Imprime Valor O,OO?","Print Value   O,OO ?","mv_chm","N",1,0,1,"C","","mv_par22","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S",".CTR18023."})
Aadd(aPergs,{  "Divide Por         ?","®Divide Por        ?","Divide By          ?","mv_chn","N",1,0,1,"C","","mv_par23","Nao Aplica","No Aplica","Do not Apply","","","Cem     ","Cien    ","One Hundred","","",	"Mil     ",	"Mil    ","Thousand","","","Milhao  ","Millon ","Million ","","","","","","","","","S",".CTR18025."})
aAdd(aPergs,{ 	"Posicao Ant. L/P   ?","Posicao Ant. L/P   ?","P/L Last Position  ?","mv_cho","N",1,0,2,"C","","mv_par24","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S",".CTR18027."})
aAdd(aPergs,{ 	"Data Lucros/Perdas ?","Fech.Gananc/Perdid.?","Profit/Losses Date ?","mv_chp","D",8,0,0,"G","","mv_par25","","","","","","","","","","","","","","","","","","","","","","","","","","","S",".CTR18028."})
aAdd(aPergs,{	"Totaliza Periodo    ?","®Totaliza Periodo  ?","Totalize Period   ?","mv_chq","N",1,0,0,"C","","mv_par26","Sim","Si","Yes","","","N„o","No","No","","","","","","","","","","","","","","","","","","","S",".CTR26523."})
aAdd(aPergs,{	"Se totalizar mostra ?","®Totalizar mostra  ?","Totalize included  ?","mv_chr","N",1,0,0,"C","","mv_par27","Conta","Cuenta","Account","","","Descricao","Descripcion","Description","","","","","","","","","","","","","","","","","","","S",".CTR26524."})
aAdd(aPergs,{	"Imprime C.Custo     ?","®Imprime C.Custo   ?","Print Cost Center  ?","mv_chs","N",1,0,0,"C","","mv_par28","Sinteticos","Sinteticos","Summarized","","","Analiticos","Analiticos","Detailed","","","Ambos","Ambos","Both","","","","","","","","","","","","","","S",".CTR18034."})
aAdd(aPergs,{	"Imprime Tot.Sintet. ?","®Impr.Total Sint.  ?","Print Summ. Total  ?","mv_cht","N",1,0,0,"C","","mv_par29","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S",".CTR18020."})

AjustaSx1("PERGVIT264",aPergs)

Return

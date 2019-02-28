#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ VIT422	³ Autor ³ Roberto Fiuza  	    ³ Data ³ 20/05/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Bordero de Pagamento 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fiuza's Informatica                               		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VIT422()
Private cPerg   := "FIN710"


Private w_PORTADO := ""
Private w_AGEDEP  := ""
Private w_NUMCON  := ""


IF !pergunte(cPerg,.T.,"Parâmetros - Borderos de Pagamentos")
	Return
ENDIF


mv_par02 := mv_par01  // apenas 1 bordero

processa( {|| TVCom01Imp()},"Aguarde...","Emissao de Borderos de Pagamentos...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³TVCom01Imp³ Autor ³ Roberto Fiuza         ³ Data ³14/09/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Relatorio                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TVCom01Imp()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fiuza's                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TVCom01Imp()
// FONT <oFont>
//1[ NAME <cName> ] ;
//2[ SIZE <nWidth>, <nHeight> ] ;
//3[ <from:FROM USER> ] ;
//4[ <bold: BOLD> ] ;
//5[ <italic: ITALIC> ] ;
//6[ <underline: UNDERLINE> ] ;
//[ WEIGHT <nWeight> ] ;
//[ OF <oDevice> ] ;
//[ NESCAPEMENT <nEscapement> ] ;
//<oFont> := TFont():New( <cName>, <nWidth>, <nHeight>, <.from.>,;
//[<.bold.>],<nEscapement>,,<nWeight>, [<.italic.>],;
//[<.underline.>],,,,,, [<oDevice>] )
//Exemplo: oFont8cn:= TFont():New("Courier New",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)

Private oPrn
Private Li           := 2130
Private nPag         := 0
Private nX           := 1
Private oFtPeq       := tFont():new("Arial"      ,09,09,   ,.F., ,   , ,.T.,.F.)
Private oFtPeqNeg    := tFont():new("Arial"      ,09,09,   ,.T., ,   , ,.T.,.F.)

Private oFtGrandeNeg := tFont():new("Arial"      ,09,16,   ,.T., ,   , ,.T.,.F.)

Private oFtGraNegIta := tFont():new("Arial"      ,09,16,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFtNegrito   := tFont():new("Arial"      ,09,10,   ,.T., ,   , ,.T.,.F.)
Private oFtNormal    := tFont():new("Arial"      ,09,10,   ,.F., ,   , ,.T.,.F.)
Private oFtGrande    := tFont():new("Arial"      ,09,14,   ,.T., ,   , ,.T.,.F.)
Private oFtGigante   := tFont():new("Arial"      ,09,16,   ,.T., ,   , ,.T.,.F.)
Private oFtMedia     := tFont():new("Arial"      ,09,12,   ,.F., ,   , ,.T.,.F.)

Private oFtMediaNeg  := tFont():new("Arial"      ,09,12,   ,.T., ,   , ,.T.,.F.)

Private oFtItem1     := tFont():new("Courier New",09,11,   ,.T., ,   , ,.T.,.F.)
Private oFtItem2     := tFont():new("Courier New",09,10,   ,.T., ,   , ,.T.,.F.)

Private wGerTit      := 0

Private wQtdPorPg    := 27
Private wTotPg       := 0
Private wQtdTit      := 0
Private wSeqTit      := 0

oPrn:=TMSPrinter():New( "Emissao de Borderos de Pagamentos" )
oPrn:SetPortrait()
oPrn:Setup()
oPrn:StartPage()

fQuery()

DbSelectArea("SEA2")
dbgotop()
DO WHILE !SEA2->( EOF() )
	wQtdTit := wQtdTit + 1
	SKIP
ENDDO

wTotPg := wQtdTit / wQtdPorPg
if wTotPg > int(wTotPg)
	wTotPg := wTotPg + 1
endif

wTotPg := int(wTotPg)


TVCom01Cab()

DbSelectArea("SEA2")
dbgotop()

DO WHILE !SEA2->( EOF() )
	
	
	IF wSeqTit > 27
		oPrn:EndPage()
		oPrn:StartPage()
		wSeqTit := 0
		TVCom01Cab()
	ENDIF
	
	w_PORTADO := EA_PORTADO
	w_AGEDEP  := EA_AGEDEP
	w_NUMCON  := EA_NUMCON
	
	
	DbSelectArea("SE2")
	dbSetOrder(1)
	MsSeek( xFilial("SE2") + SEA2->EA_PREFIXO + SEA2->EA_NUM + SEA2->EA_PARCELA + SEA2->EA_TIPO + SEA2->EA_FORNECE + SEA2->EA_LOJA)
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	MsSeek(xFilial("SD1") + SEA2->EA_NUM + SEA2->EA_PREFIXO + SEA2->EA_FORNECE + SEA2->EA_LOJA )
	
	dbSelectArea( "SA2" )
	dbSeek( xFilial("SA2") + SEA2->EA_FORNECE + SEA2->EA_LOJA )
	
	if mv_par07 = 1 .and. SE2->E2_SALDO > 0 // Saldo atual
		wVlTit := (SE2->E2_SALDO + SE2->E2_ACRESC) - SE2->E2_DECRESC
	else            // valor original
		wVlTit := SE2->E2_VALOR
	endif
	
	oPrn:Say(li, 0060,SEA2->EA_FORNECE+"-"+SEA2->EA_LOJA 									, oFtNegrito,,,, )
	oPrn:Say(li, 0270,SA2->A2_NOME															, oFtNegrito,,,, )
	oPrn:Say(li, 1270,SEA2->EA_NUM + iif(empty(SEA2->EA_PREFIXO)," ","-"+ SEA2->EA_PREFIXO)	, oFtNegrito,,,, )
	oPrn:Say(li, 1600,SD1->D1_PEDIDO														, oFtNegrito,,,, )
	oPrn:Say(li, 1800,DTOC(SE2->E2_VENCREA)													, oFtNegrito,,,, )
	oPrn:Say(li, 2350,Transform(wVlTit,'@E 9,999,999,999.99')						        , oFtNegrito,,,,1)    // 1-alinha direita 2-Esquerda)
	
	wGerTit := wGerTit + wVlTit
	
	// Box Cod For
	wColIni := 50
	wColFim := 245
	oPrn:Box(Li-10 , wColIni ,  Li + 50 , wColFim )
	
	// Box Descri For
	wColIni := 245
	wColFim := 1250
	oPrn:Box(Li-10 , wColIni ,  Li + 50 , wColFim )
	
	// Box titulo
	wColIni := 1250
	wColFim := 1550
	oPrn:Box(Li-10 , wColIni ,  Li + 50 , wColFim )
	
	// Box pedido
	wColIni := 1550
	wColFim := 1780
	oPrn:Box(Li-10 , wColIni ,  Li + 50 , wColFim )
	
	// Box vecto
	wColIni := 1780
	wColFim := 2000
	oPrn:Box(Li-10 , wColIni ,  Li + 50 , wColFim )
	
	// Box Valor
	wColIni := 2000
	wColFim := 2400
	oPrn:Box(Li-10 , wColIni ,  Li + 50 , wColFim )
	
	li+=60
	wSeqTit+=1
	
	DbSelectArea("SEA2")
	dbSkip()
ENDDO

oPrn:Say(li, 1270,"Nº TITULOS"                                                 	, oFtNegrito,,,, )
oPrn:Say(li, 1600,Transform(wQtdTit,'@E 99999')		 							, oFtNegrito,,,, )
oPrn:Say(li, 1800," TOTAL"   													, oFtNegrito,,,, )
oPrn:Say(li, 2350,Transform(wGerTit,'@E 9,999,999,999.99')						, oFtNegrito,,,,1)    // 1-alinha direita 2-Esquerda)

// Box titulo
wColIni := 1250
wColFim := 1550
oPrn:Box(Li-10 , wColIni ,  Li + 50 , wColFim )

// Box pedido
wColIni := 1550
wColFim := 1780
oPrn:Box(Li-10 , wColIni ,  Li + 50 , wColFim )

// Box vecto
wColIni := 1780
wColFim := 2000
oPrn:Box(Li-10 , wColIni ,  Li + 50 , wColFim )

// Box Valor
wColIni := 2000
wColFim := 2400
oPrn:Box(Li-10 , wColIni ,  Li + 50 , wColFim )


Li += 60
//oPrn:Say(Li ,    60, "Valor total dos titulos: "  , oFtGrande,,,, )
//oPrn:Say(Li ,   500, wVlTit                       , oFtGrande,,,, )
//Li += 60


li := 2200

dbSelectArea( "SA6" )
dbSeek( xFilial("SA6") + w_PORTADO + w_AGEDEP + w_NUMCON )

//oPrn:Say(Li , 60, "Autorizamos os pagamentos acima através de débito em nossa conta corrente: " , oFtMediaNeg,,,, )

li += 50

//oPrn:Say(Li , 60, "Banco: " +w_PORTADO + " Agência: " + w_AGEDEP + " Conta: " + ALLTRIM(w_NUMCON)+ iif(empty(SA6->A6_DVCTA),"","-"+SA6->A6_DVCTA) , oFtMediaNeg,,,, )

li += 150

oPrn:Say(Li , 700, "________________________________________" , oFtGrande,,,, )
Li+= 90
oPrn:Say(Li , 700, "VITAMEDIC INDÚSTRIA FARMACÊUTICA LTDA."/*SM0->M0_NOMECOM*/ , oFtGrande,,,, )

li += 100

oPrn:Box(Li , 100 ,  Li + 600 , 2400 )

li += 50
oPrn:Say(Li , 150, "Acusamos o recebimento do borderô acima e comprometemo-nos a realizar os  pagamentos para os"	, oFtMediaNeg,,,, )
li += 50
oPrn:Say(Li , 150, "respectivos fornecedores, sob pena de nos responsabilizarmos por qualquer pagamento indevido."	, oFtMediaNeg,,,, )
li += 100
oPrn:Say(Li , 150, "ANÁPOLIS"/*alltrim(SM0->M0_CIDCOB)*/ + " - " + "GO"/*SM0->M0_ESTCOB*/  + ",  _______/_______/_______"	, oFtMediaNeg,,,, )
oPrn:Say(Li ,1300, "Data da compensação: " + DtoC( mv_par03 ) , oFtMediaNeg,,,, )
li += 150
oPrn:Say(Li , 700, "________________________________________" , oFtMediaNeg,,,, )
li += 100
oPrn:Say(Li , 700, SA6->A6_NOME	, oFtMediaNeg,,,, )



oPrn:EndPage()
oPrn:Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³TVCom01Cab³ Autor ³ Roberto Fiuza         ³ Data ³15/08/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cabecalho do Relatorio                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TVCom01Cab()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fiuza's                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TVCom01Cab()

Local cStartPath	:= GetSrvProfString("Startpath","")


Li   := 30

nPag ++

cLogo := cStartPath + "LGRLM" + SM0->M0_CODIGO + SM0->M0_CODFIL + ".BMP" 	// Empresa+Filial

If !File( cLogo )
	cLogo := cStartPath + "LGRLM" + SM0->M0_CODIGO + ".BMP" 						// Empresa
endif


oPrn:Box(Li+10 , 50,  Li +150 , 2400)

oPrn:SayBitmap(Li+20,  70, cLogo ,246,122)  // Logo
oPrn:Say(Li+ 50,  800, "BORDERÔ DE PAGAMENTO " + mv_par01         			, oFtGrandeNeg,,,,0)



Li += 200

oPrn:Say(3100, 2270, "Página: " + strzero(nPag,2,0) + "/" + strzero(wTotPg,2,0)	, oFtGrandeNeg,,,,1 )

Li += 200

oPrn:Say(li, 0060,"FORNEC."             , oFtNegrito,,,, )
oPrn:Say(li, 0270,"NOME FORNECEDOR"		, oFtNegrito,,,, )
oPrn:Say(li, 1270,"      NF"            , oFtNegrito,,,, )
oPrn:Say(li, 1600,"PEDIDO"          	, oFtNegrito,,,, )
oPrn:Say(li, 1800,"  VCTO"          	, oFtNegrito,,,, )
oPrn:Say(li, 2070,"MONTANTE R$ "       	, oFtNegrito,,,, )    // 1-alinha direita 2-Esquerda)

// Box Cod For
wColIni := 50
wColFim := 245
oPrn:Box(Li-20 , wColIni ,  Li + 60 , wColFim )

// Box Descri For
wColIni := 245
wColFim := 1250
oPrn:Box(Li-20 , wColIni ,  Li + 60 , wColFim )

// Box titulo
wColIni := 1250
wColFim := 1550
oPrn:Box(Li-20 , wColIni ,  Li + 60 , wColFim )

// Box pedido
wColIni := 1550
wColFim := 1780
oPrn:Box(Li-20 , wColIni ,  Li + 60 , wColFim )

// Box vecto
wColIni := 1780
wColFim := 2000
oPrn:Box(Li-20 , wColIni ,  Li + 60 , wColFim )

// Box Valor
wColIni := 2000
wColFim := 2400
oPrn:Box(Li-20 , wColIni ,  Li + 60 , wColFim )


Li += 70


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fQuery       ³ Autor ³ Roberto Fiuza      ³ Data ³14/08/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Query                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fiuza's                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fQuery()


If Select("SEA2") > 0
	dbSelectArea("SEA2")
	dbCloseArea()
EndIf


cChave := SEA->(IndexKey())

cAliasSea := GetNextAlias()
cChave 	  := SqlOrder(cChave)


_cQrySUM := " SELECT SEA.EA_FILIAL, SEA.EA_FILORIG, SEA.EA_NUMBOR, SEA.EA_CART, SEA.EA_FILORIG, SEA.EA_PREFIXO, SEA.EA_NUM,
_cQrySUM += " SEA.EA_PARCELA, SEA.EA_TIPO, SEA.EA_FORNECE, SEA.EA_LOJA, SEA.EA_MODELO , SEA.EA_PORTADO, SEA.EA_AGEDEP,
_cQrySUM += " SEA.EA_NUMCON, SEA.EA_DATABOR
_cQrySUM += " FROM "+RetSQLName('SEA')+" SEA"
_cQrySUM += " WHERE "
_cQrySUM += " SEA.EA_FILIAL >= '" + mv_par09 +"' AND " //%Exp:mv_par09% AND
_cQrySUM += " SEA.EA_FILIAL <= '" + mv_par10 +"' AND " //%Exp:mv_par10% AND
_cQrySUM += " SEA.EA_NUMBOR >= '" + mv_par01 +"' AND " //%Exp:mv_par01% AND
_cQrySUM += " SEA.EA_NUMBOR <= '" + mv_par02 +"' AND " //%Exp:mv_par02% AND
_cQrySUM += " SEA.EA_CART = 'P' AND "                  //AND
_cQrySUM += " SEA.D_E_L_E_T_ <> '*'" 	               //SEA.%notDel%
_cQrySUM += " ORDER BY " + cChave                      //ORDER BY %Exp:cChave%

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQrySUM),'SEA2',.T.,.T.)

Return .t.

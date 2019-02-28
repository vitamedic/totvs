#INCLUDE "MATR480V.CH" 
#INCLUDE "PROTHEUS.CH"  
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VIT469   ³ Autor ³ Nereu Humberto Junior ³ Data ³ 16.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de Controle de Materiais de Terceiros em nosso po-³±±
±±³          ³der e nosso Material em poder de Terceiros.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR480(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VIT469()   //U_VIT469()
Local oReport 
Private _ident := " "

If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	U_MATR480R3()
EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³16.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef(nReg)

Local oReport 
Local oSection1
Local oSection2 
Local oSection3 
Local oCell         
Local aOrdem := {}
Local cTamVal:= TamSX3('B6_CUSTO1' )[1]
Local cTamQtd:= TamSX3('B6_QUANT' )[1]

AjustaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= TReport():New("MATR480",STR0009,"MTR480", {|oReport| ReportPrint(oReport)},STR0001+" "+STR0002+" "+STR0003) //"Relacao de materiais de Terceiros e em Terceiros"##"Este programa ira emitir o Relatorio de Materiais"##"de Terceiros em nosso poder e/ou nosso Material em"##"poder de Terceiros."
oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)

Pergunte("MTR480",.F.)

Aadd( aOrdem, STR0004 ) //" Produto/Local " 
Aadd( aOrdem, STR0005 ) //" Cliente/Fornecedor " 
Aadd( aOrdem, STR0006 ) //" Dt. Mov/Produto " 

oSection1 := TRSection():New(oReport,STR0052,{"SB6"},aOrdem) //"Relacao de materiais de Terceiros e em Terceiros"
oSection1 :SetTotalInLine(.F.)

TRCell():New(oSection1,"B1_COD"		,"SB1"	,/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_DESC"	,"SB1"	,/*Titulo*/	,/*Picture*/,30				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B6_LOCAL"	,"SB6"	,/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"cCliFor"	,"   "	,/*Titulo*/	,/*Picture*/,6				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"cLoja"		,"   "	,/*Titulo*/	,/*Picture*/,2				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"cNome"		,"   "	,/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("cNome"):GetFieldInfo("A2_NOME")
TRCell():New(oSection1,"B6_EMISSAO"	,"SB6"	,STR0038	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/) //"DATA DE MOVIMENTACAO : "

oSection2 := TRSection():New(oSection1,STR0053,{"SB6"}) //"Relacao de materiais de Terceiros e em Terceiros" RetLote()
oSection2 :SetTotalInLine(.F.)
oSection2 :SetHeaderPage()
//IIf((cAliasSB6)->B6_TPCF == "C",substr(POSICIONE("SA1",1,XFILIAL("SA1")+(cAliasSB6)->B6_CLIFOR+(cAliasSB6)->B6_LOJA,"A1_NOME"),1,25),substr(POSICIONE("SA2",1,XFILIAL("SA2")+(cAliasSB6)->B6_CLIFOR+(cAliasSB6)->B6_LOJA,"A2_NOME"),1,25))
TRCell():New(oSection2,"B6_PRODUTO"	,"SB6",/*Titulo*/			,/*Picture*/				,15			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_TPCF"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,{|| IIf(SB6->B6_TPCF == "C","C","F") })  //((cAliasSB6)->B6_TPCF == "C","C","F")  IIf(SB6->B6_TPCF == "C",STR0018,STR0019)
TRCell():New(oSection2,"B6_CLIFOR"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,{|| IIf(SB6->B6_TPCF == "C",substr(POSICIONE("SA1",1,XFILIAL("SA1")+SB6->B6_CLIFOR+SB6->B6_LOJA,"A1_NOME"),1,25),substr(POSICIONE("SA2",1,XFILIAL("SA2")+SB6->B6_CLIFOR+SB6->B6_LOJA,"A2_NOME"),1,25)) })
//TRCell():New(oSection2,"B6_LOJA"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_DOC"		,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"B6_SERIE"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_EMISSAO"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_UM"		,"SB6",STR0061				,/*Picture*/				,/*Tamanho*/,/*lPixel*/,{|| If(mv_par15==1,SB6->B6_SEGUM,SB6->B6_UM) })
TRCell():New(oSection2,"B6_QUANT"	,"SB6",STR0042+CRLF+STR0043	,/*Picture*/				,/*Tamanho*/,/*lPixel*/,{|| If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,SB6->B6_QUANT,0,2),SB6->B6_QUANT) }) //"Quantidade"##"Original"
TRCell():New(oSection2,"nQuJe"		,"   ",STR0042+CRLF+STR0044	,PesqPict("SB6","B6_QUANT")	,cTamQtd	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Quantidade"##"Ja entregue"				
TRCell():New(oSection2,"nSaldo"		,"   ","|"+space(cTamQtd-len(STR0045)-2)+STR0045+CRLF+"|"+space(ctamqtd),         							 PesqPict("SB6", "B6_QUANT"),cTamQtd	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Saldo"
TRCell():New(oSection2,"nTotNF"		,"   ","|"+space(cTamVal-len(STR0046)-2)+STR0046+CRLF+"|"+space(cTamVal-len(STR0047)-2)+STR0047,			 '@E 99,999,999,999.99'		,cTamVal	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"N.Fiscal"
TRCell():New(oSection2,"nTotDev"	,"   ","|"+space(cTamVal-len(STR0046)-2)+STR0046+CRLF+"|"+space(cTamVal-len(STR0048)-2)+STR0048,			 '@E 99,999,999,999.99'		,cTamVal	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"Devolvido"
TRCell():New(oSection2,"B8_LOTECTL"	,"SB8",/*Titulo*/           , PesqPict("SB8","B8_LOTECTL"),/*Tamanho*/,/*lPixel*/,{|| RetLote() })//"Custo"##"Prod."
//TRCell():New(oSection2,"nCusto"		,"   ","|"+space(cTamVal-len(STR0049)-2)+STR0049+"  |"+CRLF+"|"+space(cTamVal-len(STR0050)-2)+STR0050+"  |"	,'@E 999,999,999.99'		,cTamVal	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Custo"##"Prod."
//TRCell():New(oSection2,"B6_TIPO"	,"SB6",STR0051				,/*Picture*/				,/*Tamanho*/,/*lPixel*/,{|| IIF(SB6->B6_TIPO=="D","D","E") }) //"TM"
//TRCell():New(oSection2,"B6_SEGUM"	,"SB6",STR0062				,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D2_DTVALID"	,"SD2",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_DTDIGIT"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)				
TRCell():New(oSection2,"B6_UENT"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oSection2:Cell("B6_QUANT")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/				,/*uFormula*/,.T.,.T.,,oSection1) 
TRFunction():New(oSection2:Cell("nQuJe")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,PesqPict("SB6","B6_QUANT")	,/*uFormula*/,.T.,.T.,,oSection1)
TRFunction():New(oSection2:Cell("nSaldo")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,PesqPict("SB6","B6_QUANT")	,/*uFormula*/,.T.,.T.,,oSection1)
TRFunction():New(oSection2:Cell("nTotNF")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 99,999,999,999.99'		,/*uFormula*/,.T.,.T.,,oSection1)
TRFunction():New(oSection2:Cell("nTotDev")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 99,999,999,999.99'		,/*uFormula*/,.T.,.T.,,oSection1)
//TRFunction():New(oSection2:Cell("nCusto")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 999,999,999.99'		,/*uFormula*/,.T.,.T.,,oSection1)

oSection3 := TRSection():New(oSection2,STR0054,{"SB6"}) //"Relacao de materiais de Terceiros e em Terceiros"
oSection3 :SetTotalInLine(.F.)

TRCell():New(oSection3,"B6_PRODUTO"	,"SB6",/*Titulo*/			,/*Picture*/					,15				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_TPCF"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,{|| IIf(SB6->B6_TPCF == "C","C","F") })
TRCell():New(oSection3,"B6_CLIFOR"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,{|| IIf(SB6->B6_TPCF == "C",substr(POSICIONE("SA1",1,XFILIAL("SA1")+SB6->B6_CLIFOR+SB6->B6_LOJA,"A1_NOME"),1,25),substr(POSICIONE("SA2",1,XFILIAL("SA2")+SB6->B6_CLIFOR+SB6->B6_LOJA,"A2_NOME"),1,25)) })
//TRCell():New(oSection3,"B6_LOJA"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_DOC"		,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection3,"B6_SERIE"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_EMISSAO"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_UM"		,"SB6",STR0061				,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,{|| If(mv_par15==1,SB6->B6_SEGUM,SB6->B6_UM) })
TRCell():New(oSection3,"B6_QUANT"	,"SB6",STR0042+CRLF+STR0043	,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,{|| If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,SB6->B6_QUANT,0,2),SB6->B6_QUANT) }) //"Quantidade"##"Original"
TRCell():New(oSection3,"nQuJe"		,"   ",STR0042+CRLF+STR0044	,PesqPict("SB6","B6_QUANT")		,cTamQtd		,/*lPixel*/,/*{|| code-block de impressao }*/) //"Quantidade"##"Ja entregue"				
TRCell():New(oSection3,"nSaldo"		,"   ","|"+space(cTamQtd-len(STR0045)-2)+STR0045+CRLF+"|"+space(ctamqtd)									,PesqPict("SB6", "B6_QUANT")	,cTamQtd		,/*lPixel*/,/*{|| code-block de impressao }*/) //"Saldo"
TRCell():New(oSection3,"nTotNF"		,"   ","|"+space(cTamVal-len(STR0046)-2)+STR0046+CRLF+"|"+space(cTamVal-len(STR0047)-2)+STR0047,			'@E 99,999,999,999.99'			,cTamVal		,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"N.Fiscal"
TRCell():New(oSection3,"nTotDev"	,"   ","|"+space(cTamVal-len(STR0046)-2)+STR0046+CRLF+"|"+space(cTamVal-len(STR0048)-2)+STR0048,			'@E 99,999,999,999.99'			,cTamVal		,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"Devolvido"
TRCell():New(oSection3,"B8_LOTECTL"	,"SB8",/*Titulo*/           , PesqPict("SB8","B8_LOTECTL"),/*Tamanho*/,/*lPixel*/,{|| RetLote() })//"Custo"##"Prod."
//TRCell():New(oSection3,"nCusto"		,"   ","|"+space(cTamVal-len(STR0049)-2)+STR0049+"  |"+CRLF+"|"+space(cTamVal-len(STR0050)-2)+STR0050+"  |"	,'@E 999,999,999.99'			,cTamVal		,/*lPixel*/,/*{|| code-block de impressao }*/) //"Custo"##"Prod."
//TRCell():New(oSection3,"B6_TIPO"	,"SB6",STR0051				,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,{|| IIF(SB6->B6_TIPO=="D","D","E") }) //"TM"
//TRCell():New(oSection3,"B6_SEGUM"	,"SB6",STR0062				,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"D2_DTVALID"	,"SD2",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_DTDIGIT"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)				
TRCell():New(oSection3,"B6_UENT"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Nereu Humberto Junior  ³ Data ³16.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1)  
Local oSection3 := oReport:Section(1):Section(1):Section(1)  
//Local nOrdem    := oReport:Section(1):GetOrder()  
Local nOrdem    := oReport:GetOrder() 
Local lListCustM:= .T.
Local lCusFIFO  := GetMV('MV_CUSFIFO')
Local cProdLOCAL:= ""
Local cCliFor   := ""
Local cCliForAnt:= ""
Local lImprime  := .F. 
Private aDados[02]
lListCustM := (mv_par16==1)

dbSelectArea("SB6")
dbSetOrder(nOrdem)

If nOrdem == 1
	oSection1 :SetTotalText(STR0020) //"TOTAL DESTE PRODUTO / LOCAL ------ >"
	If mv_par10 == 1
		oReport:SetTitle(STR0010) //"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - PRODUTO / LOCAL"
	ElseIf mv_par10 == 2
		oReport:SetTitle(STR0011) //"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - PRODUTO / LOCAL"
	Else
		oReport:SetTitle(STR0012) //"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - PRODUTO / LOCAL"
	EndIf
ElseIf nOrdem == 2
	oSection1 :SetTotalText(STR0032) //"TOTAL DO PRODUTO NO "
	If mv_par10 == 1
		oReport:SetTitle(STR0023) //"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - CLIENTE / FORNECEDOR"
	ElseIf mv_par10 == 2
		oReport:SetTitle(STR0024) //"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - CLIENTE / FORNECEDOR"
	Else
		oReport:SetTitle(STR0025) //"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - CLIENTE / FORNECEDOR"
	EndIf
ElseIf nOrdem == 3
	oSection2:Cell("B6_DOC"):SetSize(12)
	oSection3:Cell("B6_DOC"):SetSize(12)
	oSection2:Cell("B6_DOC"):SetLineBreak() 
	oSection3:Cell("B6_DOC"):SetLineBreak() 
	oSection1 :SetTotalText(STR0040) //"TOTAL DO PRODUTO NA DATA --------- >"
	If mv_par10 == 1
		oReport:SetTitle(STR0033) //"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - DATA DO MOVIMENTO"
	ElseIf mv_par10 == 2
		oReport:SetTitle(STR0034) //"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - DATA DO MOVIMENTO"
	Else
		oReport:SetTitle(STR0035) //"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - DATA DO MOVIMENTO"
	EndIf
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatorio                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter(SB6->(LastRec()))

Do Case
		Case nOrdem == 1
			dbSelectArea("SB6")
			dbSeek(xFilial()+mv_par05,.T.)		    
			cCond := 'SB6->B6_FILIAL == xFilial("SB6")'

			oSection1:Cell("cCliFor"):Disable()
			oSection1:Cell("cLoja"):Disable()
			oSection1:Cell("cNome"):Disable()
			oSection1:Cell("B6_EMISSAO"):Disable()

			oSection2:Cell("B6_PRODUTO"):Disable()

			oSection3:Cell("B6_PRODUTO"):Disable()
		Case nOrdem == 2
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria arquivo de trabalho usando indice condicional.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB6")
			cIndex  := CriaTrab(NIL,.F.)
			cKey    := 'B6_FILIAL+B6_TPCF+B6_CLIFOR+B6_LOJA+B6_PRODUTO'
			cFilter := SB6->(DbFilter())
			If Empty( cFilter )
				cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'"'
			Else
				cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'" .And. ' + cFilter
			EndIf
			
			IndRegua("SB6",cIndex,cKey,,cFilter,STR0022)		//" Criando Indice ...    "
			nIndex := RetIndex("SB6")
			#IFNDEF TOP
				dbSetIndex(cIndex+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndex+1)
			dbGoTop()
			cCond := '.T.'
			
		    oSection1:Cell("B1_COD"):Disable()
		    oSection1:Cell("B1_DESC"):Disable()
		    oSection1:Cell("B6_LOCAL"):Disable()
		    oSection1:Cell("B6_EMISSAO"):Disable()
		    
			oSection2:Cell("B6_TPCF"):Disable()
			oSection2:Cell("B6_CLIFOR"):Disable()
			oSection2:Cell("B6_LOJA"):Disable()		    
			
			oSection3:Cell("B6_TPCF"):Disable()
			oSection3:Cell("B6_CLIFOR"):Disable()
			oSection3:Cell("B6_LOJA"):Disable()

		Case nOrdem == 3
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria arquivo de trabalho usando indice condicional.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB6")
			cIndex  := CriaTrab(NIL,.F.)
			cKey    := "B6_FILIAL+DTOS(B6_DTDIGIT)+B6_PRODUTO+B6_CLIFOR+B6_LOJA"
			cFilter := SB6->(DbFilter())
			If Empty( cFilter )
				cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'"'
			Else
				cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'" .And. ' + cFilter
			EndIf
			IndRegua("SB6",cIndex,cKey,,cFilter,STR0022)		//" Criando Indice ...    "
			nIndex := RetIndex("SB6")
			#IFNDEF TOP
				dbSetIndex(cIndex+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndex+1)
			dbGoTop()
			cCond := '.T.'

		    oSection1:Cell("B1_COD"):Disable()
		    oSection1:Cell("B1_DESC"):Disable()
		    oSection1:Cell("B6_LOCAL"):Disable()
			oSection1:Cell("cCliFor"):Disable()
			oSection1:Cell("cLoja"):Disable()
			oSection1:Cell("cNome"):Disable()
EndCase			

While !oReport:Cancel() .And. !SB6->(Eof()) .And. &(cCond)

	If oReport:Cancel()
		Exit
	EndIf
	
	oReport:IncMeter()
	
	
	SF4->(dbSeek(xFilial("SF4")+SB6->B6_TES))
	If SF4->F4_PODER3 == "D"
		SB6->(dbSkip())
		Loop
	EndIf
	
	If SB6->B6_TPCF == "C"
		If SB6->B6_CLIFOR   < mv_par01 .Or. SB6->B6_CLIFOR  > mv_par02
			SB6->(dbSkip())
			Loop
		EndIf
	Else
		If SB6->B6_CLIFOR   < mv_par03 .Or. SB6->B6_CLIFOR  > mv_par04
			SB6->(dbSkip())
			Loop
		EndIf
	Endif	
	
	If	SB6->B6_PRODUTO < mv_par05 .Or. SB6->B6_PRODUTO > mv_par06 .Or.;
	    SB6->B6_DTDIGIT < mv_par07 .Or. SB6->B6_DTDIGIT > mv_par08 .Or.;
		SB6->B6_QUANT == 0 
		SB6->(dbSkip())
		Loop
	Endif	

	aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par07,mv_par08)
	nSaldo  := aSaldo[1]
	nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])
	
	If mv_par09 == 2 .And. nSaldo <= 0
		SB6->(dbSkip())
		Loop
	EndIf
	
	If mv_par10 == 1 .And. SB6->B6_TIPO != "D"
		SB6->(dbSkip())
		Loop
	ElseIf mv_par10 == 2 .And. SB6->B6_TIPO != "E"
		SB6->(dbSkip())
		Loop
	EndIf

	If nOrdem == 1
		cQuebra := SB6->B6_PRODUTO+SB6->B6_LOCAL
	ElseIf nOrdem == 2
		cQuebra := SB6->B6_CLIFOR+SB6->B6_LOJA+SB6->B6_PRODUTO+SB6->B6_TPCF
	ElseIf nOrdem == 3
		cQuebra := Dtos(SB6->B6_EMISSAO)+SB6->B6_PRODUTO
		lImprime := .T.
	Endif
	
	While !oReport:Cancel() .And. !SB6->(Eof()) .And. xFilial("SB6") == SB6->B6_FILIAL ;
	      .And. Iif(nOrdem==1,cQuebra == SB6->B6_PRODUTO+SB6->B6_LOCAL,If(nOrdem==2,cQuebra == SB6->B6_CLIFOR+SB6->B6_LOJA+SB6->B6_PRODUTO+SB6->B6_TPCF,cQuebra == dTos(SB6->B6_EMISSAO)+SB6->B6_PRODUTO))

		If oReport:Cancel()
			Exit
		EndIf
		
		oReport:IncMeter()
		
		_ident := SB6->B6_IDENT 
		SF4->(dbSeek(xFilial("SF4")+SB6->B6_TES))
		If SF4->F4_PODER3 == "D"
			SB6->(dbSkip())
			Loop
		EndIf
		
		If SB6->B6_TPCF == "C"
			If SB6->B6_CLIFOR   < mv_par01 .Or. SB6->B6_CLIFOR  > mv_par02
				SB6->(dbSkip())
				Loop
			EndIf
		Else
			If SB6->B6_CLIFOR   < mv_par03 .Or. SB6->B6_CLIFOR  > mv_par04
				SB6->(dbSkip())
				Loop
			EndIf
		Endif	
		
		If	SB6->B6_PRODUTO < mv_par05 .Or. SB6->B6_PRODUTO > mv_par06 .Or.;
		    SB6->B6_DTDIGIT < mv_par07 .Or. SB6->B6_DTDIGIT > mv_par08 .Or.;
			SB6->B6_QUANT == 0 
			SB6->(dbSkip())
			Loop
		Endif	

		aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par07,mv_par08)
		nSaldo  := aSaldo[1]
		nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])
		
		If mv_par09 == 2 .And. nSaldo <= 0
			SB6->(dbSkip())
			Loop
		EndIf
		
		If mv_par10 == 1 .And. SB6->B6_TIPO != "D"
			SB6->(dbSkip())
			Loop
		ElseIf mv_par10 == 2 .And. SB6->B6_TIPO != "E"
			SB6->(dbSkip())
			Loop
		EndIf

		oSection1:Init()
		If nOrdem == 1
			If cProdLOCAL != SB6->B6_PRODUTO+SB6->B6_LOCAL
				If SB1->(dbSeek(xFilial("SB1")+SB6->B6_PRODUTO))
					oSection1:PrintLine()			
					cProdLOCAL := SB6->B6_PRODUTO+SB6->B6_LOCAL
				Else
					Help(" ",1,"R480PRODUT")
					dbSelectArea("SB6")
					Return .F.
				EndIf
			EndIf
			If !Empty(cProdLocal)
				oSection2:Init()
				
				oSection2:Cell("nQuJe"):SetValue(If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,(SB6->B6_QUANT - nSaldo),0,2),(SB6->B6_QUANT - nSaldo)))
				oSection2:Cell("nSaldo"):SetValue(If(mv_par15==1,ConvUm(SB6->B6_PRODUTO,nSaldo,0,2),nSaldo))
				oSection2:Cell("nTotNF"):SetValue(aSaldo[5])
				oSection2:Cell("nTotDev"):SetValue((B6_QUANT - nSaldo) * nPrUnit)
				// Custo na Moeda
				aDados[01] := RetLote() 
				aDados[02] := stod(DatVal())
				//nCusto := RetLote()//(&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / SB6->B6_QUANT) * nSaldo	
				//oSection2:Cell("nCusto"):SetValue(nCusto)// Ricardo Moreira 13/10/16
				oSection2:Cell("B8_LOTECTL"):SetBlock( { || aDados[01]})// Ricardo Moreira 13/10/16
				oSection2:Cell("D2_DTVALID"):SetBlock( { || aDados[02]})// Ricardo Moreira 13/10/16
			
				oSection2:PrintLine()
			Endif	
		ElseIf nOrdem == 2
			If cCliForAnt != SB6->B6_TPCF .Or. cNomeCliFor != SB6->B6_CLIFOR+SB6->B6_LOJA
				If SB6->B6_TPCF == "C" 
					dbSelectArea("SA1")
					dbSeek(xFilial("SA1")+SB6->B6_CLIFOR+SB6->B6_LOJA)
					oSection1 :SetTotalText(STR0032+STR0030) //"TOTAL DO PRODUTO NO "##"CLIENTE ---->"###"FORNECEDOR --->"
				Else
					dbSelectArea("SA2")
					dbSeek(xFilial("SA2")+SB6->B6_CLIFOR+SB6->B6_LOJA)
					oSection1 :SetTotalText(STR0032+STR0031) //"TOTAL DO PRODUTO NO "##"FORNECEDOR --->"
				Endif	
				If Found()
					dbSelectArea("SB6")
				  
					oSection1:Cell("cCliFor"):SetTitle(IIf(SB6->B6_TPCF == "C",STR0028,STR0029)) //"CLIENTE / LOJA: "###"FORNECEDOR / LOJA: "
					oSection1:Cell("cCliFor"):SetValue(Iif(SB6->B6_TPCF == "C",SA1->A1_COD,SA2->A2_COD))
					
					oSection1:Cell("cLoja"):SetValue(Iif(SB6->B6_TPCF == "C",SA1->A1_LOJA,SA2->A2_LOJA))
					oSection1:Cell("cNome"):SetValue(Iif(SB6->B6_TPCF == "C",SA1->A1_NOME,SA2->A2_NOME))
				
					oSection1:PrintLine()			

					cNomeCliFor := SB6->B6_CLIFOR+SB6->B6_LOJA
					cCliForAnt 	:= SB6->B6_TPCF
				Else
					Help(" ",1,"R480CLIFOR")
					RetIndex("SB6")
					dbSelectArea("SB6")
					dbSetOrder(1)
					cIndex += OrdBagExt()
					Ferase(cIndex)
					Return .F.
				EndIf
			EndIf
			If Len(cNomeCliFor) != 0
				oSection2:Init()

				oSection2:Cell("nQuJe"):SetValue(If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,(SB6->B6_QUANT - nSaldo),0,2),(SB6->B6_QUANT - nSaldo)))
				oSection2:Cell("nSaldo"):SetValue(If(mv_par15==1,ConvUm(SB6->B6_PRODUTO,nSaldo,0,2),nSaldo))
				oSection2:Cell("nTotNF"):SetValue(aSaldo[5])
				oSection2:Cell("nTotDev"):SetValue((B6_QUANT - nSaldo) * nPrUnit)
				// Custo na Moeda
		   		aDados[01] := RetLote() 
				aDados[02] := stod(DatVal())
				//nCusto := RetLote()//(&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / SB6->B6_QUANT) * nSaldo	
				//oSection2:Cell("nCusto"):SetValue(nCusto)// Ricardo Moreira 13/10/16
				oSection2:Cell("B8_LOTECTL"):SetBlock( { || aDados[01]})// Ricardo Moreira 13/10/16
				oSection2:Cell("D2_DTVALID"):SetBlock( { || aDados[02]})// Ricardo Moreira 13/10/16
				
				oSection2:PrintLine()
			Endif
		ElseIf nOrdem == 3
			If lImprime
				oSection1:PrintLine()			
				lImprime := .F.
			Endif	

			oSection2:Init()
			
			oSection2:Cell("nQuJe"):SetValue(If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,(SB6->B6_QUANT - nSaldo),0,2),(SB6->B6_QUANT - nSaldo)))
			oSection2:Cell("nSaldo"):SetValue(If(mv_par15==1,ConvUm(SB6->B6_PRODUTO,nSaldo,0,2),nSaldo))
			oSection2:Cell("nTotNF"):SetValue(aSaldo[5])
			oSection2:Cell("nTotDev"):SetValue((B6_QUANT - nSaldo) * nPrUnit)
			// Custo na Moeda
			aDados[01] := RetLote() 
			aDados[02] := stod(DatVal())
			//nCusto := RetLote()//(&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / SB6->B6_QUANT) * nSaldo	
			//oSection2:Cell("nCusto"):SetValue(nCusto)// Ricardo Moreira 13/10/16
			oSection2:Cell("B8_LOTECTL"):SetBlock( { || aDados[01]})// Ricardo Moreira 13/10/16
			oSection2:Cell("D2_DTVALID"):SetBlock( { || aDados[02]})// Ricardo Moreira 13/10/16
		
			oSection2:PrintLine()				
		Endif	
		// Lista as devolucoes da remessa
		If mv_par12 == 1 .And. ((SB6->B6_QUANT - nSaldo) > 0)
			aAreaSB6 := SB6->(GetArea())
			SB6->(dbSetOrder(3))
			cSeek:=xFilial("SB6")+SB6->B6_IDENT+SB6->B6_PRODUTO+"D"
			If dbSeek(cSeek)
				oReport:PrintText(STR0041) //"Notas Fiscais de Retorno"
				Do While !Eof() .And. SB6->B6_FILIAL+SB6->B6_IDENT+SB6->B6_PRODUTO+SB6->B6_PODER3 == cSeek
					If SB6->B6_DTDIGIT < mv_par13 .Or. SB6->B6_DTDIGIT > mv_par14
						SB6->(dbSkip())
						Loop
					Endif
					oSection3:Init(.F.)
					If nOrdem == 2
						oSection3:Cell("B6_PRODUTO"):Hide()
					Endif	
					oSection3:Cell("nQuJe"):Hide()
					oSection3:Cell("nSaldo"):Hide()
					oSection3:Cell("nTotDev"):Hide()
					//oSection3:Cell("nCusto"):Hide()
					
					oSection3:Cell("nTotNF"):SetValue(SB6->B6_QUANT * nPrUnit)
					oSection3:PrintLine()
					dbSkip()
				EndDo
				oSection3:Finish()
			EndIf
			RestArea(aAreaSB6)
		EndIf					
        dbSelectArea("SB6")    
		dbSkip()
	EndDo
	oSection1:Finish()
	oSection2:Finish()
EndDo
		
Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATR480R3 ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 12.05.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de Controle de Materiais de Terceiros em nosso po-³±±
±±³          ³der e nosso Material em poder de Terceiros. (Antigo)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR480(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rodrigo     ³23/06/98³XXXXXX³Acerto no tamanho do documento para 12    ³±±
±±³            ³        ³      ³posicoes                                  ³±±
±±³Fernando J. ³08.12.98³3781A ³Substituir PesqPictQt por PescPict        ³±±
±±³CesarValadao³30/03/99³XXXXXX³Manutencao na SetPrint()                  ³±±
±±³CesarValadao³04/05/99³21554A³Manutencao Lay-Out P Imprimir Quant c/ 17 ³±±
±±³CesarValadao³12/08/99³21421A³Manutencao Lay-Out P Imprimir NF Retorno  ³±±
±±³            ³        ³      ³Alinhada a NF de Origem                   ³±±
±±³Patricia Sal³13/12/99³14655A³Validacao p/Data Digitacao nas Devolucoes ³±±
±±³            ³        ³      ³Incl. Param Dt.Inicial/Final na CalcTerc()³±±
±±³Patricia Sal³20/12/99³XXXXXX³Conversao dos Campos Fornec./Cliente p/   ³±±
±±³            ³        ³      ³(20 posicoes) e Loja p/ 4 posicoes.       ³±±
±±³Iuspa       ³06/12/00³      ³Data de/ate para devolucoes               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Matr480R3()
LOCAL wnrel, nOrdem
LOCAL Tamanho := "G"
LOCAL cDesc1  := STR0001	//"Este programa ira emitir o Relatorio de Materiais"
LOCAL cDesc2  := STR0002	//"de Terceiros em nosso poder e/ou nosso Material em"
LOCAL cDesc3  := STR0003	//"poder de Terceiros."
LOCAL cString := "SB6"
LOCAL aOrd    := {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006)}	//" Produto/Local "###" Cliente/Fornecedor "###" Dt. Mov/Produto "

PRIVATE cCondCli, cCondFor
PRIVATE aReturn := {OemToAnsi(STR0007), 1,OemToAnsi(STR0008), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:= "MATR480"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "MTR480"
PRIVATE Titulo  := OemToAnsi(STR0009)	//"Relacao de materiais de Terceiros e em Terceiros"
PRIVATE cabec1, cabec2, nTipo, CbTxt, CbCont
PRIVATE lListCustM := .T.
PRIVATE lCusFIFO   := GetMV('MV_CUSFIFO')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza variaveis static p/ Grupo de Fornec/Clientes(001) e de Loja(002)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static aTamSXG, aTamSXG2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt := SPACE(10)
CbCont:= 00
li	  := 80
m_pag := 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria a Pergunta Nova no Sx1                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSx1("MTR480","15","QTDE. na 2a. U.M. ?","CTD. EN 2a. U.M. ?","QTTY. in 2a. U.M. ?", "mv_chf", "N", 1, 0, 2,"C", "", "", "", "","mv_par15","Sim","Si","Yes", "","Nao","No","No", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSX1Help("P.MTR48015.",{'Imprime as Quantidades na 2a UM?        ', 'Sim=Utiliza a 2aUM na impressao         ', 'Nao=Utiliza a 1aUM na impressao(padrao) '}, {'Print the quantities at 2nd MU?         ', 'Yes=Uses 2nd MU at the print            ',  'No=Uses 1st MU at the print (defaut)    '}, {'¿Imprime las cantidades en la 2a UM?    ', 'Si=Utiliza la 2aUM en la impresion      ', 'No=Utiliza la 1aUM en la impresion(est.)'})

PutSx1('MTR480','16','Lista Custo        ?','¿Lista Costo       ?','List Cost          ?','mv_chg','N',01,0,1,'C','','','','','mv_par16','Medio','Promedio','Average','','FIFO/PEPS','FIFO/PEPS','FIFO','','','','','','','','','', {'Informe o tipo de custo a ser listado:  ', '1. Custo Medio                          ', '2. Custo FIFO/PEPS(p/"MV_CUSFIFO" ativo)'}, {'Inform the kind of cost to be listed:   ', '1. Average Cost                         ', '2. FIFO Cost (with "MV_CUSFIFO" active) '}, {'Informe el tipo de costo a ser listado: ', '1. Costo Promedio                       ', '2. Costo FIFO/PEPS(p/"MV_CUSFIFO"activo)'})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica conteudo da variavel p/ Grupo de Clientes/Forneced.(001) e Loja(002) ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR480",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                  ³
//³ mv_par01   		// Cliente Inicial                		              ³
//³ mv_par02        // Cliente Final                       	              ³
//³ mv_par03        // Fornecedor Inicial                     	          ³
//³ mv_par04        // Fornecedor Final                          	      ³
//³ mv_par05        // Produto Inicial                              	  ³
//³ mv_par06        // Produto Final                         		      ³
//³ mv_par07        // Data Inicial                              	      ³
//³ mv_par08        // Data Final                                   	  ³
//³ mv_par09        // Situacao   (Todos / Em aberto)                     ³
//³ mv_par10        // Tipo   (De Terceiros / Em Terceiros / Ambos)		  ³
//³ mv_par11        // Custo em Qual Moeda  (1/2/3/4/5)             	  ³
//³ mv_par12        // Lista NF Devolucao  (Sim) (Nao)              	  ³
//³ mv_par13        // Devolucao data de                            	  ³
//³ mv_par14        // Devolucao data ate                           	  ³
//³ mv_par15        // QTDE. na 2a. U.M.? Sim / Nao                       ³
//³ mv_par16        // Lista Custo? Medio / Fifo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis p/ filtrar arquivo.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCondCli := "B6_CLIFOR   <= mv_par02 .And. B6_CLIFOR  >= mv_par01 .And."+;
			" B6_PRODUTO <= mv_par06 .And. B6_PRODUTO >= mv_par05 .And."+;
			" B6_DTDIGIT <= mv_par08 .And. B6_DTDIGIT >= mv_par07 .And."+;
			" B6_QUANT   <> 0 "
			
cCondFor := "B6_CLIFOR   <= mv_par04 .And. B6_CLIFOR  >= mv_par03 .And."+;
			" B6_PRODUTO <= mv_par06 .And. B6_PRODUTO >= mv_par05 .And."+;
			" B6_DTDIGIT <= mv_par08 .And. B6_DTDIGIT >= mv_par07 .And."+;
			" B6_QUANT   <> 0 "
			
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SetPrint                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "MATR480"

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho)

If nLastKey == 27
	Return .T.
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return .T.
Endif

RptStatus({|lEnd| R480Imp(@lEnd,wnRel,cString,Tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R480IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 16.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR480			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R480Imp(lEnd,WnRel,cString,Tamanho)

nTipo:=IIF(aReturn[4]==1,15,18)

nOrdem := aReturn[8]

lListCustM := (mv_par16==1)

dbSelectArea("SB6")

If nOrdem == 1
	R480Prod(lEnd,Tamanho)
ElseIf nOrdem == 2
	R480CliFor(lEnd,Tamanho)
ElseIf nOrdem == 3
	R480Data(lEnd,Tamanho)
EndIf

dbSelectArea("SB6")
Set Filter To
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R480Prod ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 12/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Por Ordem de Produto / LOCAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR480                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R480Prod(lEnd,Tamanho)
LOCAL cCliFor   := ""
LOCAL cProdLOCAL:= ""
LOCAL cQuebra   := ""
LOCAL cSeek     := ""
LOCAL cQuery    := ""
LOCAL cAliasSB6 := "SB6"
LOCAL aSaldo    := {}
LOCAL aStrucSB6 := {}
LOCAL aAreaSB6  := {}
LOCAL nCusTot   := nQuant := nQuJe := nTotal := nTotDev := nTotQuant := nTotQuJe := nTotSaldo := 0
LOCAL nGerTot   := nGerTotDev:=nGerCusTot:=0
LOCAL nIncCol   := If(cPaisLoc == "MEX",7,0)
LOCAL cTamB6Qt  := PesqPict("SB6","B6_QUANT",17)
LOCAL cTamB6Q2  := PesqPict("SB6", "B6_QTSEGUM",12)
LOCAL nRegs     := SB6->(LastRec())
LOCAL nSaldo    := 0
LOCAL nCusto    := 0
LOCAL nPrUnit   := 0
LOCAL nX        := 0
LOCAL lQuery    := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par10 == 1
	titulo := STR0010		//"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - PRODUTO / LOCAL"
ElseIf mv_par10 == 2
	titulo := STR0011		//"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - PRODUTO / LOCAL"
Else
	titulo := STR0012		//"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - PRODUTO / LOCAL"
EndIf

cabec1 := If( cPaisLoc == "MEX",STR0055,STR0013 )		//"            Cliente /        Loja  -  Documento  - Data de  Unid.de ---------------------- Quantidade ------------------- --------------- Valores -----------   Custo Prod. TM  Segunda    Quantidade      Data    Dt Ult.
cabec2 := If( cPaisLoc == "MEX",STR0056+Str(mv_par11,1,0)+STR0066,STR0014+Str(mv_par11,1,0))		//"            Fornecedor              Numero  Serie  Emissao   Medida          Original      Ja' entregue             Saldo Total Nota Fiscal   Total Devolvido    na Moeda X     Un.Med.       Seg. UM    Lancto    Entrega
 						  	//  Cliente:XXXXXXXXXXXXXXXXXXXX XX    999999   XXX  99/99/9999   XX   99999999999999999 99999999999999999 99999999999999999 99999999999999999 99999999999999999 9999999999999  X    XX     999999999999  99/99/9999 99/99/9999
						  	//            1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
						  	//  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
dbSelectArea("SB6")
dbSetOrder(1)
#IFDEF TOP
	lQuery 	  := .T.
	cAliasSB6 := GetNextAlias()
	aStrucSB6 := SB6->(dbStruct())      
	cQuery	  := " SELECT SB6.* "
	cQuery	  +=   " FROM " + RetSqlName("SB6") + " SB6"
	cQuery    +=  " WHERE SB6.B6_FILIAL = '"   + xFilial("SB6") + "' "
	cQuery    +=    " AND SB6.B6_PRODUTO >= '" + mv_par05 + "' "
	cQuery    +=    " AND SB6.B6_PRODUTO <= '" + mv_par06 + "' "
	cQuery    +=    " AND SB6.D_E_L_E_T_ = ' ' "
	cQuery    +=    " ORDER BY B6_FILIAL, B6_PRODUTO, B6_LOCAL "
	cQuery:=ChangeQuery(cQuery)
	MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSB6,.F.,.T.)},STR0069) //"Processando ..."
	dbSelectArea(cAliasSB6)
   	For nX := 1 To Len(aStrucSB6)
   		If ( aStrucSB6[nX][2] <> "C" .And. FieldPos(aStrucSB6[nX][1])<>0 )
   			TcSetField(cAliasSB6,aStrucSB6[nX][1],aStrucSB6[nX][2],aStrucSB6[nX][3],aStrucSB6[nX][4])
  		EndIf
  	Next
#ELSE
	dbSeek(xFilial("SB6")+mv_par05,.T.)
#ENDIF

SetRegua(nRegs)

While !Eof() .And. IIf(lQuery,.T.,B6_FILIAL == xFilial("SB6"))
	
	IncRegua()
	
	If lEnd
		@Prow()+1,001 PSay STR0016		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	If !Empty(aReturn[7])
		If !&(aReturn[7])
			dbSkip()
			Loop
		EndIf
	EndIf	

	dbSelectArea("SF4")
	MsSeek(xFilial("SF4")+(cAliasSB6)->B6_TES)
	If SF4->F4_PODER3 == "D"
		dbselectArea(cAliasSB6)
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea(cAliasSB6)
	
	IF	IIf((cAliasSB6)->B6_TPCF == "C" , &cCondCli , &cCondFor )
		aSaldo:=CalcTerc((cAliasSB6)->B6_PRODUTO,(cAliasSB6)->B6_CLIFOR,(cAliasSB6)->B6_LOJA,(cAliasSB6)->B6_IDENT,(cAliasSB6)->B6_TES,,mv_par07,mv_par08)
		dbSelectArea(cAliasSB6)
		nSaldo  := aSaldo[1]
		nPrUnit := IIF(aSaldo[3]==0,(cAliasSB6)->B6_PRUNIT,aSaldo[3])
	Else
		dbSkip()
		Loop
	Endif
	
	If mv_par09 == 2 .And. nSaldo <= 0
		dbSkip()
		Loop
	EndIf
	If mv_par10 == 1 .And. B6_TIPO != "D"
		dbSkip()
		Loop
	ElseIf mv_par10 == 2 .And. B6_TIPO != "E"
		dbSkip()
		Loop
	EndIf
	
	nCusTot:=0
	nQuant :=0
	nQuJe  :=0
	nTotal :=0
	nTotDev:=0
	nSaldo :=0
	aSaldo :={}
	nCusto :=0
	cQuebra:= (cAliasSB6)->B6_PRODUTO+(cAliasSB6)->B6_LOCAL
	
	While !Eof() .And. xFilial("SB6") == (cAliasSB6)->B6_FILIAL .And. cQuebra == (cAliasSB6)->B6_PRODUTO+(cAliasSB6)->B6_LOCAL
		
		IncRegua()
		
		If li > 55
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
		EndIf
		
		If !Empty(aReturn[7])
			If !&(aReturn[7])
				dbSkip()
				Loop
			EndIf
		EndIf	

		dbSelectArea("SF4")
		MsSeek(xFilial("SF4")+(cAliasSB6)->B6_TES)
		If SF4->F4_PODER3 == "D"
			dbselectArea(cAliasSB6)
			dbSkip()
			loop
		Endif
		
		dbSelectArea(cAliasSB6)
		
		IF	IIf(B6_TPCF == "C" , &cCondCli , &cCondFor )
			aSaldo:=CalcTerc((cAliasSB6)->B6_PRODUTO,(cAliasSB6)->B6_CLIFOR,(cAliasSB6)->B6_LOJA,(cAliasSB6)->B6_IDENT,(cAliasSB6)->B6_TES,,mv_par07,mv_par08)
			dbSelectArea(cAliasSB6)
			nSaldo  := aSaldo[1]
			nPrUnit := IIF(aSaldo[3]==0,(cAliasSB6)->B6_PRUNIT,aSaldo[3])
			If mv_par09 == 2 .And. nSaldo <= 0
				dbSkip()
				Loop
			EndIf
			If mv_par10 == 1 .And. (cAliasSB6)->B6_TIPO != "D"
				dbSkip()
				Loop
			ElseIf mv_par10 == 2 .And. (cAliasSB6)->B6_TIPO != "E"
				dbSkip()
				Loop
			EndIf
			If cProdLOCAL != (cAliasSB6)->B6_PRODUTO+(cAliasSB6)->B6_LOCAL
				dbSelectArea("SB1")
				If MsSeek(xFilial("SB1")+(cAliasSB6)->B6_PRODUTO)
					If !Empty(cProdLOCAL)
						li += 2
					EndIf
					If li > 55
						Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
					EndIf
					@ li,000 PSay STR0017+B1_COD+" - "+Trim(Substr(B1_DESC,1,30))+" / "+(cAliasSB6)->B6_LOCAL		//"PRODUTO / LOCAL: "
					cProdLOCAL := (cAliasSB6)->B6_PRODUTO+(cAliasSB6)->B6_LOCAL
				Else
					Help(" ",1,"R480PRODUT")
					// Fecha a query
					If lQuery .And. Select(cAliasSB6) > 0 
						(cAliasSB6)->(dbCloseArea())
					EndIf
					dbSelectArea("SB6")
					dbSetOrder(1)
					Return .F.
				EndIf
			EndIf
			dbSelectArea(cAliasSB6)
			
			If li > 55
				Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
			EndIf
			
			If !Empty(cProdLocal)
				
				li++
				@ li,000 PSay IIf((cAliasSB6)->B6_TPCF == "C","C","F")	//@ li,000 PSay IIf((cAliasSB6)->B6_TPCF == "C",STR0018,STR0019)		//"Clie:"###"Forn:"
				@ li,004 PSay IIf((cAliasSB6)->B6_TPCF == "C",substr(POSICIONE("SA1",1,XFILIAL("SA1")+(cAliasSB6)->B6_CLIFOR+(cAliasSB6)->B6_LOJA,"A1_NOME"),1,25),substr(POSICIONE("SA2",1,XFILIAL("SA2")+(cAliasSB6)->B6_CLIFOR+(cAliasSB6)->B6_LOJA,"A2_NOME"),1,25))          //(Substr((cAliasSB6)->B6_CLIFOR,1,15))    //RICARDO MOREIRA // 06/10/2016
			   //	@ li,025 PSay (cAliasSB6)->B6_LOJA
				@ li,030 PSay (cAliasSB6)->B6_DOC
				@ li,045+nIncCol PSay (cAliasSB6)->B6_SERIE
				@ li,050+nIncCol PSay Dtoc((cAliasSB6)->B6_EMISSAO)
				@ li,062+nIncCol PSay If(mv_par15==1,(cAliasSB6)->B6_SEGUM,(cAliasSB6)->B6_UM)
				
				// Quantidade Original
			    @ li,068+nIncCol PSay If(mv_par15==1,ConvUM((cAliasSB6)->B6_PRODUTO,(cAliasSB6)->B6_QUANT,0,2),(cAliasSB6)->B6_QUANT) Picture cTamB6Qt
				nQuant += If(mv_par15==1,ConvUM((cAliasSB6)->B6_PRODUTO,(cAliasSB6)->B6_QUANT,0,2),(cAliasSB6)->B6_QUANT)
				
				// Quantidade Ja Entregue
				@ li,086+nIncCol PSay If(mv_par15==1,ConvUM((cAliasSB6)->B6_PRODUTO,((cAliasSB6)->B6_QUANT - nSaldo),0,2),((cAliasSB6)->B6_QUANT - nSaldo)) Picture cTamB6Qt
				nQuJe += If(mv_par15==1,ConvUM((cAliasSB6)->B6_PRODUTO,((cAliasSB6)->B6_QUANT - nSaldo),0,2),((cAliasSB6)->B6_QUANT - nSaldo))
				
				// Saldo
				@ li,104+nIncCol PSay If(mv_par15==1,ConvUm((cAliasSB6)->B6_PRODUTO,nSaldo,0,2),nSaldo) Picture cTamB6Qt
				
				// Total Nota Fiscal
			    @ li,122+nIncCol PSay Transform((cAliasSB6)->B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
			    nTotal += (cAliasSB6)->B6_QUANT * nPrUnit
			    nGerTot+= (cAliasSB6)->B6_QUANT * nPrUnit
				
				// Total Nota Fiscal Devolvido
				@ li,140+nIncCol PSay Transform(((cAliasSB6)->B6_QUANT - nSaldo) * nPrUnit,'@E 99,999,999,999.99')
				nTotDev    += ((cAliasSB6)->B6_QUANT - nSaldo) * nPrUnit
				nGerTotDev += ((cAliasSB6)->B6_QUANT - nSaldo) * nPrUnit
				
				// Custo na Moeda

				nCusto := (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / (cAliasSB6)->B6_QUANT) * nSaldo
				nCusTot+= nCusto
				nGerCusTot+=nCusto
				
				_ident := (cAliasSB6)->B6_IDENT 		
				//POSICIONE("SA1",1,XFILIAL("SA1")+(cAliasSB6)->B6_CLIFOR+(cAliasSB6)->B6_LOJA,"A1_NOME")  // D1_FILIAL+D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD+D1_LOTECTL                                                                                              
		    	@ li,165+nIncCol PSay RetLote()	//@ li,158+nIncCol PSay Transform(nCusto,'@E 999,999,999.99')   RICARDO MOREIRA 12/10/16
				@ li,180+nIncCol PSay stod(DatVal()) //@ li,173+nIncCol PSay (cAliasSB6)->B6_TIPO
				//@ li,177+nIncCol PSay (cAliasSB6)->B6_SEGUM
		     	//@ li,184 PSay (cAliasSB6)->B6_QTSEGUM Picture cTamB6Q2
				@ li,199 PSay Dtoc((cAliasSB6)->B6_DTDIGIT)
				@ li,210 PSay Dtoc((cAliasSB6)->B6_UENT)
				
				// Lista as devolucoes da remessa
				If mv_par12 == 1 .And. (((cAliasSB6)->B6_QUANT - nSaldo) > 0)
					aAreaSB6 := (cAliasSB6)->(GetArea())
					SB6->(dbSetOrder(3))
					cSeek:=xFilial("SB6")+(cAliasSB6)->B6_IDENT+(cAliasSB6)->B6_PRODUTO+"D"
					If SB6->(dbSeek(cSeek))
						li++
						@ li,000 PSay STR0041	//"Notas Fiscais de Retorno"
						Do While !SB6->(Eof()) .And. SB6->B6_FILIAL+SB6->B6_IDENT+SB6->B6_PRODUTO+SB6->B6_PODER3 == cSeek
							If SB6->B6_DTDIGIT < mv_par13 .Or. SB6->B6_DTDIGIT > mv_par14
								DbSelectArea("SB6")
								DbSkip()
								Loop
							Endif
							If li > 55
								Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
							EndIf									
							li++
							@ li,000 PSay IIf(SB6->B6_TPCF == "C",STR0018,STR0019)		//"Clie:"###"Forn:"
							@ li,008 PSay (Substr(SB6->B6_CLIFOR,1,15))
							@ li,025 PSay SB6->B6_LOJA
							@ li,030 PSay SB6->B6_DOC
							@ li,045+nIncCol PSay SB6->B6_SERIE
							@ li,050+nIncCol PSay Dtoc(SB6->B6_EMISSAO)
							@ li,062+nIncCol PSay If(mv_par15==1,SB6->B6_SEGUM,SB6->B6_UM)
							// Quantidade Original
							@ li,068+nIncCol PSay If(mv_par15==1,ConvUm(SB6->B6_PRODUTO,SB6->B6_QUANT,0,2),SB6->B6_QUANT) Picture cTamB6Qt
							
							// Total Nota Fiscal
							@ li,122+nIncCol PSay Transform(SB6->B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
							@ li,173+nIncCol PSay SB6->B6_TIPO
							@ li,177+nIncCol PSay SB6->B6_SEGUM
							@ li,184 PSay SB6->B6_QTSEGUM Picture cTamB6Q2
							@ li,199 PSay Dtoc(SB6->B6_DTDIGIT)
							@ li,210 PSay Dtoc(SB6->B6_UENT)
							SB6->(dbSkip())
						EndDo
						li++
					EndIf
					RestArea(aAreaSB6)
					dbSelectArea(cAliasSB6)
				EndIf
			EndIf
		EndIf
		dbSkip()
	EndDo
	If nQuant > 0
		li++
		@ li,000 PSay STR0020		//"TOTAL DESTE PRODUTO / LOCAL ------ >"
		@ li,068+nIncCol PSay nQuant        		Picture PesqPict("SB6", "B6_QUANT",17)
		@ li,086+nIncCol PSay nQuje             	Picture PesqPict("SB6", "B6_QUANT",17)
		@ li,104+nIncCol PSay (nQuant - nQuJe)  	Picture PesqPict("SB6", "B6_QUANT",17)
		@ li,122+nIncCol PSay Transform(nTotal, '@E 99,999,999,999.99')
		@ li,140+nIncCol PSay Transform(nTotDev,'@E 99,999,999,999.99')
		//@ li,158+nIncCol PSay Transform(nCusTot,'@E 999,999,999.99')  Ricardo Moreira Inibido 11/10/2016
	    nTotQuant += nQuant
		nTotQuje  += nQuje
    	nTotSaldo += (nQuant - nQuJe)
	Endif
End

If nQuant > 0 .Or. nTotal > 0
	li++;li++
	@ li,000 PSay STR0021			//"T O T A L    G E R A L  ---------- >"
    @ li,068+nIncCol PSay nTotQuant Picture PesqPict("SB6","B6_QUANT",17)
    @ li,086+nIncCol PSay nTotQuJe  Picture PesqPict("SB6","B6_QUANT",17)
    @ li,104+nIncCol PSay nTotSaldo Picture PesqPict("SB6","B6_QUANT",17)
	@ li,122+nIncCol PSay Transform(nGerTot	  ,'@E 99,999,999,999.99')
	@ li,140+nIncCol PSay Transform(nGerTotDev,'@E 99,999,999,999.99')
	//@ li,158+nIncCol PSay Transform(nGerCusTot,'@E 999,999,999.99') Ricardo Moreira Inibido 11/10/2016
	Roda(CbCont,CbTxt,Tamanho)
EndIf

// Fecha a query
If lQuery .And. Select(cAliasSB6) > 0 
	(cAliasSB6)->(dbCloseArea())
EndIf
dbSelectArea("SB6")
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R480CliFor³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 12/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Por Ordem de Cliente / Fornecedor.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR480                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R480CliFor(lEnd,Tamanho)
LOCAL cCliFor     := ""
LOCAL cCliForAnt  := ""
LOCAL cQuebra     := ""
LOCAL cIndex      := ""
LOCAL cKey        := ""
LOCAL cNomeCliFor := ""
LOCAL cDescCliFor := ""
LOCAL cAliasSB6   := "SB6"
LOCAL nIncCol     := If(cPaisLoc == "MEX",7,0)
LOCAL nRegs       := SB6->(LastRec())
LOCAL lQuery      := .F.
LOCAL nGerTot     := 0
LOCAL nGerTotDev  := 0 
LOCAL nGerCusTot  := 0
LOCAL nCusTot     := 0
LOCAL nQuant      := 0
LOCAL nQuJe       := 0 
LOCAL nTotal      := 0 
LOCAL nTotDev     := 0
LOCAL nTotQuant   := 0
LOCAL nTotQuJe    := 0 
LOCAL nTotSaldo   := 0
LOCAL nIndex      := 0
LOCAL nSaldo      := 0
LOCAL nCusto      := 0
LOCAL nPrUnit     := 0
LOCAL nX          := 0
LOCAL aAreaSB6    := {}
LOCAL aStrucSB6   := {}
LOCAL aSaldo      := {}
LOCAL cVar,cFilter


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da Query para Performance do relatorio              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB6")
dbSetOrder(1)
#IFDEF TOP
	lQuery 	  := .T.
	cAliasSB6 := GetNextAlias()
	aStrucSB6 := SB6->(dbStruct())      
	cQuery	  := " SELECT SB6.*, R_E_C_N_O_ RECNOSB6 "
	cQuery	  +=   " FROM " + RetSqlName("SB6") + " SB6"
	cQuery    +=  " WHERE SB6.B6_FILIAL = '" + xFilial("SB6") + "' "
	cQuery    +=    " AND SB6.B6_PRODUTO >= '" + mv_par05 + "' "
	cQuery    +=    " AND SB6.B6_PRODUTO <= '" + mv_par06 + "' "
	cQuery    +=    " AND SB6.D_E_L_E_T_ = ' ' "
	cQuery    +=    " AND SB6.D_E_L_E_T_ = ' ' "
	cQuery    +=  " ORDER BY B6_FILIAL,B6_TPCF,B6_CLIFOR,B6_LOJA,B6_PRODUTO "
	cQuery:=ChangeQuery(cQuery)
	MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSB6,.F.,.T.)},STR0069) //"Processando ..."
	dbSelectArea(cAliasSB6)
   	For nX := 1 To Len(aStrucSB6)
   		If ( aStrucSB6[nX][2] <> "C" .And. FieldPos(aStrucSB6[nX][1])<>0 )
   			TcSetField(cAliasSB6,aStrucSB6[nX][1],aStrucSB6[nX][2],aStrucSB6[nX][3],aStrucSB6[nX][4])
  		EndIf
  	Next
#ELSE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho usando indice condicional.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB6")
	cIndex  := CriaTrab(NIL,.F.)
	cKey    := 'B6_FILIAL+B6_TPCF+B6_CLIFOR+B6_LOJA+B6_PRODUTO'
	cFilter := SB6->(DbFilter())
	If Empty( cFilter )
		cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'"'
	Else
		cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'" .And. ' + cFilter
	EndIf
	
	IndRegua("SB6",cIndex,cKey,,cFilter,STR0022)		//" Criando Indice ...    "
	nIndex := RetIndex("SB6")
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	dbGoTop()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par10 == 1
	titulo := STR0023		//"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - CLIENTE / FORNECEDOR"
ElseIf mv_par10 == 2
	titulo := STR0024		//"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - CLIENTE / FORNECEDOR"
Else
	titulo := STR0025		//"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - CLIENTE / FORNECEDOR"
EndIf
cabec1 := If( cPaisLoc == "MEX",STR0057,STR0026 )		//"                 -    Documento    -  Data de         Unid. de ---------------------- Quantidade ---------------------  ------------ Valores --------------  Custo do Prod. TM  Segunda   Quantidade     Data   Data da Ult.
cabec2 := If( cPaisLoc == "MEX",STR0058+Str(mv_par11,1,0)+STR0067,STR0027+Str(mv_par11,1,0)+STR0064 )		//"Produto          Numero        Serie  Emissao  Almox.  Medida        Original        Ja' entregue           Saldo       Total Nota Fiscal   Total Devolvido    na Moeda X       Unid. Med.   Seg. UM  Lancamento  Entrega
                        	// XXXXXXXXXXXXXXX  999999999999    XXX  99/99/9999 XX      XX    99999999999999999  99999999999999999  99999999999999999  99999999999999999 99999999999999999 99999999999999  X   XX      999999999999   99/99/99   99/99/99
                        	//           1         2         3         4         5         6         7         8         9         C         1         2         3         4         5         6         7         8         9         D       & 1         2
                        	// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
SetRegua(nRegs)

While !(cAliasSB6)->(Eof())
	
	IncRegua()
	
	If lEnd
		@Prow()+1,001 PSay STR0016		//"CANCELADO PELO OPERADOR"
		Exit
	EndIf   
	
	If !Empty(aReturn[7])
		If !&(aReturn[7])
			dbSkip()
			Loop
		EndIf
	EndIf
	
	dbSelectArea("SF4")
	dbSeek(xFilial("SF4")+(cAliasSB6)->B6_TES)
	If SF4->F4_PODER3 == "D"
		dbselectArea(cAliasSB6)
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea(cAliasSB6)
	
	IF	IIf((cAliasSB6)->B6_TPCF == "C" , &cCondCli , &cCondFor )
		aSaldo:=CalcTerc((cAliasSB6)->B6_PRODUTO,(cAliasSB6)->B6_CLIFOR,(cAliasSB6)->B6_LOJA,(cAliasSB6)->B6_IDENT,(cAliasSB6)->B6_TES,,mv_par07,mv_par08)
		dbSelectArea(cAliasSB6)
		nSaldo:= aSaldo[1]
		nPrUnit := IIF(aSaldo[3]==0,(cAliasSB6)->B6_PRUNIT,aSaldo[3])
	Else
		dbSkip()
		Loop
	EndIf
	
	If mv_par09 == 2 .And. nSaldo <= 0
		dbSkip()
		Loop
	EndIf
	If mv_par10 == 1 .And. (cAliasSB6)->B6_TIPO != "D"
		dbSkip()
		Loop
	ElseIf mv_par10 == 2 .And. (cAliasSB6)->B6_TIPO != "E"
		dbSkip()
		Loop
	EndIf
	
    cQuebra  := (cAliasSB6)->B6_CLIFOR+(cAliasSB6)->B6_LOJA+(cAliasSB6)->B6_PRODUTO+(cAliasSB6)->B6_TPCF
	nCusTot  := 0
	nQuant	 := 0
	nQuJe	 := 0
	nTotal	 := 0
	nTotDev	 := 0
	
	Do While (cAliasSB6)->B6_CLIFOR+(cAliasSB6)->B6_LOJA+(cAliasSB6)->B6_PRODUTO+(cAliasSB6)->B6_TPCF == cQuebra

		IncRegua()		

		If	!(If((cAliasSB6)->B6_TPCF == "C" , &cCondCli , &cCondFor ))
			dbSkip()
			Loop
		EndIf    
		
		If !Empty(aReturn[7])
			If !&(aReturn[7])
				dbSkip()  
				Loop
			EndIf
		EndIf
		
		dbSelectArea("SF4")
		dbSeek(xFilial("SF4")+(cAliasSB6)->B6_TES)
		If SF4->F4_PODER3 == "D"
			dbSelectArea(cAliasSB6)
			dbSkip()
			Loop
		Endif
		
		dbSelectArea(cAliasSB6)
		aSaldo:=CalcTerc((cAliasSB6)->B6_PRODUTO,(cAliasSB6)->B6_CLIFOR,(cAliasSB6)->B6_LOJA,(cAliasSB6)->B6_IDENT,(cAliasSB6)->B6_TES,,mv_par07,mv_par08)
		dbSelectArea(cAliasSB6)
		nSaldo:= aSaldo[1]
		
		If mv_par09 == 2 .And. nSaldo <= 0
			dbSkip()
			Loop
		EndIf
		
		If mv_par10 == 1 .And. (cAliasSB6)->B6_TIPO != "D"
			dbSkip()
			Loop
		ElseIf mv_par10 == 2 .And. (cAliasSB6)->B6_TIPO != "E"
			dbSkip()
			Loop
		EndIf
		
		If Li > 55
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
		EndIf
		
		If cCliForAnt != (cAliasSB6)->B6_TPCF .Or. cNomeCliFor != (cAliasSB6)->B6_CLIFOR+(cAliasSB6)->B6_LOJA
			dbSelectArea(IIf((cAliasSB6)->B6_TPCF == "C" , "SA1" , "SA2" ) )
			dbSeek(xFilial(IIf((cAliasSB6)->B6_TPCF == "C" , "SA1" , "SA2" ))+(cAliasSB6)->B6_CLIFOR+(cAliasSB6)->B6_LOJA)
			If Found()
				If !Empty(cDescCliFor)
					li++
				EndIf
				cDescCliFor	:= IIf((cAliasSB6)->B6_TPCF == "C" , STR0028 , STR0029)		//"CLIENTE / LOJA: "###"FORNECEDOR / LOJA: "
				@ li,000 PSay cDescCliFor+Trim( IIf((cAliasSB6)->B6_TPCF == "C" ,A1_COD+" - "+A1_NOME , A2_COD+" - "+A2_NOME )  )+" / "+IIf((cAliasSB6)->B6_TPCF == "C" , A1_LOJA , A2_LOJA )
				cNomeCliFor := (cAliasSB6)->B6_CLIFOR+(cAliasSB6)->B6_LOJA
				cCliForAnt 	:= (cAliasSB6)->B6_TPCF
			Else
				Help(" ",1,"R480CLIFOR")
				If lQuery 
					If Select(cAliasSB6) > 0 
						(cAliasSB6)->(dbCloseArea())
					EndIf
					dbSelectArea("SB6")
				Else
					RetIndex("SB6")
					dbSelectArea("SB6")
					dbSetOrder(1)
					cIndex += OrdBagExt()
					Ferase(cIndex)
				EndIf	
				Return .F.
			EndIf
			dbSelectArea(cAliasSB6)
		EndIf
		
		If Li > 55
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
		EndIf
		
		If Len(cNomeCliFor) != 0
			li++
			@ li,000 PSay (cAliasSB6)->B6_PRODUTO
			@ li,017 PSay (cAliasSB6)->B6_DOC
			@ li,033+nIncCol PSay (cAliasSB6)->B6_SERIE
			@ li,038+nIncCol PSay Dtoc((cAliasSB6)->B6_EMISSAO)
			@ li,049+nIncCol PSay (cAliasSB6)->B6_LOCAL
			@ li,057+nIncCol PSay If(mv_par15==1,(cAliasSB6)->B6_SEGUM,(cAliasSB6)->B6_UM)
			
			// Quantidade Original
		    @ li,063+nIncCol PSay If(mv_par15==1,ConvUm((cAliasSB6)->B6_PRODUTO,(cAliasSB6)->B6_QUANT,0,2),(cAliasSB6)->B6_QUANT) Picture PesqPict("SB6", "B6_QUANT",17)
		    nQuant     += If(mv_par15==1,ConvUm((cAliasSB6)->B6_PRODUTO,(cAliasSB6)->B6_QUANT,0,2),(cAliasSB6)->B6_QUANT)
			
			// localiza Saldo
			aSaldo:=CalcTerc((cAliasSB6)->B6_PRODUTO,(cAliasSB6)->B6_CLIFOR,(cAliasSB6)->B6_LOJA,(cAliasSB6)->B6_IDENT,(cAliasSB6)->B6_TES,,mv_par07,mv_par08)
			dbSelectArea(cAliasSB6)
			nSaldo  := aSaldo[1]
			nPrUnit := IIF(aSaldo[3]==0,(cAliasSB6)->B6_PRUNIT,aSaldo[3])
			
			// Quantidade Ja Entregue
		    @ li,082+nIncCol PSay If(mv_par15==1,ConvUm((cAliasSB6)->B6_PRODUTO,((cAliasSB6)->B6_QUANT - nSaldo),0,2),((cAliasSB6)->B6_QUANT - nSaldo)) Picture PesqPict("SB6", "B6_QUANT",17)
		    nQuJe     +=  If(mv_par15==1,ConvUm((cAliasSB6)->B6_PRODUTO,((cAliasSB6)->B6_QUANT - nSaldo),0,2),((cAliasSB6)->B6_QUANT - nSaldo))
			
			// Saldo
			@ li,101+nIncCol PSay If(mv_par15==1,ConvUm((cAliasSB6)->B6_PRODUTO,nSaldo,0,2),nSaldo) Picture PesqPict("SB6", "B6_QUANT",17)
			
			// Total da Nota Fiscal
			@ li,120+nIncCol PSay Transform((cAliasSB6)->B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
			nTotal	+= (cAliasSB6)->B6_QUANT * nPrUnit
			nGerTot	+= (cAliasSB6)->B6_QUANT * nPrUnit
			
			// Total da Nota Fiscal Devolvido
			@ li,138+nIncCol PSay Transform(((cAliasSB6)->B6_QUANT - nSaldo) * nPrUnit,'@E 99,999,999,999.99')
			nTotDev		+= ((cAliasSB6)->B6_QUANT - nSaldo) * nPrUnit
			nGerTotDev	+= ((cAliasSB6)->B6_QUANT - nSaldo) * nPrUnit
			nCusto 		:= (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / (cAliasSB6)->B6_QUANT) * nSaldo
			nCusTot 	+= nCusto
			nGerCusTot 	+= nCusto
			
			@ li,156+nIncCol PSay Transform(nCusto,'@E 999,999,999.99')
			@ li,172+nIncCol PSay (cAliasSB6)->B6_TIPO
			@ li,176+nIncCol PSay (cAliasSB6)->B6_SEGUM
			@ li,184 PSay (cAliasSB6)->B6_QTSEGUM Picture PesqPict("SB6", "B6_QTSEGUM",12)
			@ li,199 PSay Dtoc((cAliasSB6)->B6_DTDIGIT)
			@ li,210 PSay Dtoc((cAliasSB6)->B6_UENT)
		EndIf
		
		// Lista as devolucoes da remessa
		If mv_par12 == 1 .And. (((cAliasSB6)->B6_QUANT - nSaldo) > 0)
			aAreaSB6 := (cAliasSB6)->(GetArea())
			SB6->(dbSetOrder(3))
			cSeek:=xFilial("SB6")+(cAliasSB6)->B6_IDENT+(cAliasSB6)->B6_PRODUTO+"D"
			If SB6->(dbSeek(cSeek))
				li++
				@ li,000 PSay STR0041	//"Notas Fiscais de Retorno"
				Do While !SB6->(Eof()) .And. SB6->B6_FILIAL+SB6->B6_IDENT+SB6->B6_PRODUTO+SB6->B6_PODER3 == cSeek
					If SB6->B6_DTDIGIT < mv_par13 .Or. SB6->B6_DTDIGIT > mv_par14
						DbSelectArea("SB6")
						DbSkip()
						Loop
					EndIf
					If li > 55
						Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
					EndIf					
					li++
					@ li,017 PSay SB6->B6_DOC
					@ li,033+nIncCol PSay SB6->B6_SERIE
					@ li,038+nIncCol PSay Dtoc(SB6->B6_EMISSAO)
					@ li,049+nIncCol PSay SB6->B6_LOCAL
					@ li,057+nIncCol PSay If(mv_par15==1,SB6->B6_SEGUM,SB6->B6_UM)
					// Quantidade Original
					@ li,063+nIncCol PSay If(mv_par15==1,ConvUm(SB6->B6_PRODUTO,SB6->B6_QUANT,0,2),SB6->B6_QUANT) Picture PesqPict("SB6", "B6_QUANT",17)
					// Total da Nota Fiscal
					@ li,120+nIncCol PSay Transform(SB6->B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
					// Total da Nota Fiscal Devolvido
					@ li,172+nIncCol PSay SB6->B6_TIPO
					@ li,176+nIncCol PSay SB6->B6_SEGUM
					@ li,184 PSay SB6->B6_QTSEGUM Picture PesqPict("SB6", "B6_QTSEGUM",12)
					@ li,199 PSay Dtoc(SB6->B6_DTDIGIT)
					@ li,210 PSay Dtoc(SB6->B6_UENT)
					SB6->(dbSkip())
				EndDo
				li++
			EndIf
			RestArea(aAreaSB6)
			If lQuery
				dbSelectArea(cAliasSB6)
        	Else
				dbSetOrder(nIndex+1)
			EndIf	
		EndIf
		dbSkip()
	EndDo
	If nQuant > 0
		li++
		If !lQuery
			dbSkip(-1)
		EndIf	
		cVar:=IIF(B6_TPCF == "C" ,STR0030,STR0031)	//"CLIENTE ---->"###"FORNECEDOR --->"
		If !lQuery
			dbSkip()
		EndIf	
		IncRegua()
		If li > 55
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
		EndIf
		@ li,000 PSay STR0032 +cVar		//"TOTAL DO PRODUTO NO "
		@ li,063+nIncCol PSay nQuant			Picture PesqPict("SB6", "B6_QUANT",17)
		@ li,082+nIncCol PSay nQuje				Picture PesqPict("SB6", "B6_QUANT",17)
		@ li,101+nIncCol PSay (nQuant - nQuJe)	Picture PesqPict("SB6", "B6_QUANT",17)
		@ li,119+nIncCol PSay Transform(nTotal ,'@E 999,999,999,999.99')
		@ li,137+nIncCol PSay Transform(nTotDev,'@E 999,999,999,999.99')
		@ li,156+nIncCol PSay Transform(nCusTot,'@E 999,999,999.99')
		li++
		nTotQuant += nQuant
		nTotQuJe  += nQuje
		nTotSaldo += (nQuant - nQuJe)
	Endif
End
If Len(cNomeCliFor) != 0
	li++
	@ li,000 PSay STR0021		//"T O T A L    G E R A L  ---------- >"
    @ li,063+nIncCol PSay nTotQuant Picture PesqPict("SB6", "B6_QUANT",17)
    @ li,082+nIncCol PSay nTotQuJe  Picture PesqPict("SB6", "B6_QUANT",17)
    @ li,101+nIncCol PSay nTotSaldo Picture PesqPict("SB6", "B6_QUANT",17)
	@ li,119+nIncCol PSay Transform(nGerTot	 ,'@E 999,999,999,999.99')
	@ li,137+nIncCol PSay Transform(nGerTotDev,'@E 999,999,999,999.99')
	@ li,156+nIncCol PSay Transform(nGerCusTot,'@E 999,999,999.99')
	Roda(CbCont,CbTxt,Tamanho)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve condicao original ao SB6 e apaga arquivo de trabalho.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuery
	If Select(cAliasSB6) > 0 
		(cAliasSB6)->(dbCloseArea())
	EndIf
	dbSelectArea("SB6")
Else
	RetIndex("SB6")
	dbSelectArea("SB6")
	dbSetOrder(1)
	cIndex += OrdBagExt()
	Ferase(cIndex)
EndIf
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R480Data ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Por Ordem de Data do Movimento (B6_DTDIGIT).       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR480                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R480Data(lEnd,Tamanho)
LOCAL nCusTot := nQuant := nQuJe := nTotal := nTotDev := 0
LOCAL	nGerTot:=nGerTotDev:=nGerCusTot:=0
LOCAL cIndex, cKey, nIndex, cFilter
LOCAL cCondFiltr:=""
LOCAL aSaldo  := {}
Local nSaldo  := 0
Local nCusto  := 0
Local nPrUnit := 0
LOCAL cQuebra, lImprime:=.F.
LOCAL aAreaSB6:= {}
LOCAL nTotQuant := nTotQuJe := nTotSaldo := 0
LOCAL nIncCol := If(cPaisLoc == "MEX",7,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho usando indice condicional.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB6")
cIndex  := CriaTrab(NIL,.F.)
cKey    := "B6_FILIAL+DTOS(B6_DTDIGIT)+B6_PRODUTO+B6_CLIFOR+B6_LOJA"
cFilter := SB6->(DbFilter())
If Empty( cFilter )
	cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'"'
Else
	cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'" .And. ' + cFilter
EndIf
IndRegua("SB6",cIndex,cKey,,cFilter,STR0022)		//" Criando Indice ...    "
nIndex := RetIndex("SB6")
#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par10 == 1
	titulo := STR0033		//"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - DATA DO MOVIMENTO"
ElseIf mv_par10 == 2
	titulo := STR0034		//"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - DATA DO MOVIMENTO"
Else
	titulo := STR0035		//"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - DATA DO MOVIMENTO"
EndIf

cabec1 := If( cPaisLoc == "MEX",STR0059,STR0036 )		//"         Cliente /                             -   Documento   - Data de       UM --------------------- Quantidade ----------------- ------------ Valores ------------ Custo Produto TM Seg. Quantidade -       Data       -
cabec2 := If( cPaisLoc == "MEX",STR0060+Str(mv_par11,1,0)+STR0068,STR0037+Str(mv_par11,1,0)+STR0065 )		//"         Fornec.          Loja Produto         Numero      Serie Emissao  Almox           Original     Ja' entregue            Saldo Total Nota Fiscal Total Devolvido  na Moeda X      UM    Seg. UM   Lancamento   Entrega
                        // Forn:XXXXXXXXXXXXXXXXXXXX XXXX XXXXXXXXXXXXXXX 999999999999 xxx 99/99/9999 XX  XX 9999999999999999  999999999999999 9999999999999999 99999999999999999 999999999999999 99999999999999 X XX 99999999999 99/99/9999 99/99/9999
                        // Clie:     1         2         3         4         5         6         7         8         9         C         1         2         3         4         5         6         7         8         9         D         1         2
                        // 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
SetRegua(LastRec())

While !Eof()
	
	IncRegua()
	
	If lEnd
		@Prow()+1,001 PSay STR0016		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IF	!(Iif(B6_TPCF == "C" , &cCondCli , &cCondFor ))
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SF4")
	dbSeek(cFilial+SB6->B6_TES)
	If SF4->F4_PODER3 == "D"
		dbselectArea("SB6")
		dbSkip()
		loop
	Endif
	
	dbSelectArea("SB6")
	aSaldo  := CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par07,mv_par08)
	dbSelectArea("SB6")
	nSaldo  := aSaldo[1]
	nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])
	
	If mv_par09 == 2 .And. nSaldo <= 0
		dbSkip()
		Loop
	ElseIf mv_par10 == 1 .And. B6_TIPO != "D"
		dbSkip()
		Loop
	ElseIf mv_par10 == 2 .And. B6_TIPO != "E"
		dbSkip()
		Loop
	Endif
	nCusTot  := 0
	nQuant   := 0
	nQuJe    := 0
	nTotal   := 0
	nTotDev  := 0
	cQuebra  := dTos(B6_EMISSAO)+B6_PRODUTO
	lImprime := .T.
	While !Eof() .And. cQuebra == dTos(B6_EMISSAO)+B6_PRODUTO .And. B6_Filial == xFilial()
		
		IncRegua()
		
		If li > 55
			Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
		EndIf
		
		IF	!(Iif(B6_TPCF == "C" , &cCondCli , &cCondFor ))
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("SF4")
		dbSeek(cFilial+SB6->B6_TES)
		If SF4->F4_PODER3 == "D"
			dbselectArea("SB6")
			dbSkip()
			loop
		Endif
		
		dbSelectArea("SB6")
		aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par07,mv_par08)
		dbSelectArea("SB6")
		nSaldo  := aSaldo[1]
		nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])
		
		If mv_par09 == 2 .And. nSaldo <= 0
			dbSkip()
			Loop
		ElseIf mv_par10 == 1 .And. B6_TIPO != "D"
			dbSkip()
			Loop
		ElseIf mv_par10 == 2 .And. B6_TIPO != "E"
			dbSkip()
			Loop
		Endif
		
		If lImprime
			li++
			@ li,000 PSay STR0038 + dToc(B6_EMISSAO)		//"DATA DE MOVIMENTACAO : "
			lImprime := .F.
		Endif
		
		li++
		@ li,000 PSay IIf(B6_TPCF == "C" , STR0018, STR0039 )		//"Clie:"###"Forn:"
		@ li,005 PSay (Substr(B6_CLIFOR,1,15))
		@ li,023 PSay B6_LOJA
		If cPaisLoc == "MEX"
			li++
		EndIf
		@ li,028-nIncCol PSay B6_PRODUTO
		@ li,045-nIncCol PSay B6_DOC
		@ li,060 PSay B6_SERIE
		@ li,064 PSay Dtoc(B6_EMISSAO)
		@ li,075 PSay B6_LOCAL
		@ li,079 PSay If(mv_par15==1,B6_SEGUM,B6_UM)
		
		// Quantidade Original
		@ li,082 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT) Picture PesqPict("SB6", "B6_QUANT",16)
		nQuant += If(mv_par15==1,ConvUm(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT)
		
		// Localiza o Saldo
		aSaldo:=CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par07,mv_par08)
		dbSelectArea("SB6")
		nSaldo  := aSaldo[1]
		nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])
		
		// Quantidade Ja Entregue
		@ li,100 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,(B6_QUANT - nSaldo),0,2),(B6_QUANT - nSaldo)) Picture PesqPict("SB6", "B6_QUANT",15)
		nQuJe += If(mv_par15==1,ConvUm(B6_PRODUTO,(B6_QUANT - nSaldo),0,2),(B6_QUANT - nSaldo))
		
		// Saldo
		@ li,116 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,nSaldo,0,2),nSaldo) Picture PesqPict("SB6", "B6_QUANT",16)
		
		// Total da Nota Fiscal
		@ li,133 PSay Transform(B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
		nTotal += B6_QUANT * nPrUnit
		nGerTot+= B6_QUANT * nPrUnit
		
		// Total da Nota Fiscal Devolvido
		@ li,151 PSay Transform((B6_QUANT - nSaldo) * nPrUnit,'@E 999,999,999.99')
		nTotDev 	+= (B6_QUANT - nSaldo) * nPrUnit
		nGerTotDev	+= (B6_QUANT - nSaldo) * nPrUnit
		nCusto := (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / B6_QUANT) * nSaldo
		nCusTot+= nCusto
		nGerCusTot+= nCusto
		
		@ li,167 PSay Transform(nCusto,'@E 999,999,999.99')
		@ li,182 PSay B6_TIPO
		@ li,184 PSay B6_SEGUM
		@ li,187 PSay B6_QTSEGUM Picture PesqPict("SB6", "B6_QTSEGUM",11)
		@ li,199 PSay Dtoc(B6_DTDIGIT)
		@ li,210 PSay Dtoc(B6_UENT)
		
		// Lista as devolucoes da remessa
		If mv_par12 == 1 .And. ((B6_QUANT - nSaldo) > 0)
			aAreaSB6 := SB6->(GetArea())
			dbSetOrder(3)
			cSeek:=xFilial()+B6_IDENT+B6_PRODUTO+"D"
			If dbSeek(cSeek)
				li++
				@ li,000 PSay STR0041	//"Notas Fiscais de Retorno"
				Do While !Eof() .And. B6_FILIAL+B6_IDENT+B6_PRODUTO+B6_PODER3 == cSeek
					If SB6->B6_DTDIGIT < mv_par13 .Or. SB6->B6_DTDIGIT > mv_par14
						DbSelectArea("SB6")
						DbSkip()
						Loop
					Endif
					If li > 55
						Cabec(titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
					EndIf		
					li++					
					@ li,000 PSay IIf(B6_TPCF == "C" , STR0018, STR0039 )		//"Clie:"###"Forn:"
					@ li,005 PSay (Substr(B6_CLIFOR,1,15))
					@ li,023 PSay B6_LOJA
					If cPaisLoc == "MEX"
						li++
					EndIf
					@ li,027-nIncCol PSay B6_PRODUTO
					@ li,045-nIncCol PSay B6_DOC
					@ li,060 PSay B6_SERIE
					@ li,064 PSay Dtoc(B6_EMISSAO)
					@ li,075 PSay B6_LOCAL
					@ li,079 PSay If(mv_par15==1,B6_SEGUM,B6_UM)
					// Quantidade Original
					@ li,082 PSay If(mv_par15==1,ConvUm(B6_PRODUTO,B6_QUANT,0,2),B6_QUANT) Picture PesqPict("SB6", "B6_QUANT",16)
					// Total da Nota Fiscal
					@ li,133 PSay Transform(B6_QUANT * nPrUnit,'@E 99,999,999,999.99')
					@ li,182 PSay B6_TIPO
					@ li,184 PSay B6_SEGUM
					@ li,187 PSay B6_QTSEGUM Picture PesqPict("SB6", "B6_QTSEGUM",11)
					@ li,199 PSay Dtoc(B6_DTDIGIT)
					@ li,210 PSay Dtoc(B6_UENT)
					dbSkip()
				EndDo
				li++
			EndIf
			RestArea(aAreaSB6)
			dbSetOrder(nIndex+1)
		EndIf
		
		dbSkip()
	EndDo
	If nQuant > 0
		li++
		@ li,000 PSay STR0040		//"TOTAL DO PRODUTO NA DATA --------- >"
		@ li,082 PSay nQuant 			 Picture PesqPict("SB6", "B6_QUANT",16)
		@ li,100 PSay nQuJe  			 Picture PesqPict("SB6", "B6_QUANT",15)
		@ li,116 PSay (nQuant - nQuJe) Picture PesqPict("SB6", "B6_QUANT",16)
		@ li,133 PSay Transform(nTotal, '@E 99,999,999,999.99')
		@ li,151 PSay Transform(nTotDev,'@E 999,999,999.99')
		@ li,167 PSay Transform(nCusTot,'@E 999,999,999.99')
		nTotQuant += nQuant
		nTotQuJe  += nQuJe
		nTotSaldo += (nQuant - nQuJe)
		li++
	Endif
End

If nQuant > 0 .Or. nTotal > 0
	li++;li++
	@ li,000 PSay STR0021		//"T O T A L    G E R A L  ---------- >"
    @ li,082 PSay nTotQuant Picture PesqPict("SB6", "B6_QUANT",16)
    @ li,100 PSay nTotQuJe  Picture PesqPict("SB6", "B6_QUANT",16)
    @ li,116 PSay nTotSaldo Picture PesqPict("SB6", "B6_QUANT",16)
	@ li,133 PSay Transform(nGerTot	 ,'@E 99,999,999,999.99')
	@ li,151 PSay Transform(nGerTotDev,'@E 999,999,999.99')
	@ li,167 PSay Transform(nGerCusTot,'@E 999,999,999.99')
	Roda(CbCont,CbTxt,Tamanho)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve condicao original ao SB6 e apaga arquivo de trabalho.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SB6")
dbSelectArea("SB6")
dbSetOrder(1)
cIndex += OrdBagExt()
Ferase(cIndex)

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor³Nereu Humberto Junior º Data ³ 16/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR480                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1()

PutSx1("MTR480","15","QTDE. na 2a. U.M. ?","CTD. EN 2a. U.M. ?","QTTY. in 2a. U.M. ?", "mv_chf", "N", 1, 0, 2,"C", "", "", "", "","mv_par15","Sim","Si","Yes", "","Nao","No","No", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSX1Help("P.MTR48015.",{'Imprime as Quantidades na 2a UM?        ', 'Sim=Utiliza a 2aUM na impressao         ', 'Nao=Utiliza a 1aUM na impressao(padrao) '}, {'Print the quantities at 2nd MU?         ', 'Yes=Uses 2nd MU at the print            ',  'No=Uses 1st MU at the print (defaut)    '}, {'¿Imprime las cantidades en la 2a UM?    ', 'Si=Utiliza la 2aUM en la impresion      ', 'No=Utiliza la 1aUM en la impresion(est.)'})

PutSx1('MTR480','16','Lista Custo        ?','¿Lista Costo       ?','List Cost          ?','mv_chg','N',01,0,1,'C','','','','','mv_par16','Medio','Promedio','Average','','FIFO/PEPS','FIFO/PEPS','FIFO','','','','','','','','','', {'Informe o tipo de custo a ser listado:  ', '1. Custo Medio                          ', '2. Custo FIFO/PEPS(p/"MV_CUSFIFO" ativo)'}, {'Inform the kind of cost to be listed:   ', '1. Average Cost                         ', '2. FIFO Cost (with "MV_CUSFIFO" active) '}, {'Informe el tipo de costo a ser listado: ', '1. Costo Promedio                       ', '2. Costo FIFO/PEPS(p/"MV_CUSFIFO"activo)'})

Return Nil      





/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Ret Data ³ Autor ³ Ricardo Moreira ³         Data ³11/10/16³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna da Data validade				      					      ³±±
±±³          ³ 			                                  				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function DatVal() //U_DatVal()      //(cAliasSB6)->B6_DOC+(cAliasSB6)->B6_SERIE+(cAliasSB6)->B6_CLIFOR+(cAliasSB6)->B6_LOJA

Local _DTVALID  := " " 
Local aArea  := GetArea()
                          //D1_FILIAL+D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD+D1_LOTECTL  
_cQuery 	:= " SELECT D2_DTVALID "
_cQuery 	+= " FROM " + retsqlname("SD2")+" SD2 "
_cQuery 	+= " WHERE SD2.D_E_L_E_T_ <> '*' "
_cQuery 	+= " AND SD2.D2_IDENTB6 = '"+_ident+"'"

_cQuery :=changequery(_cQuery)

tcquery _cQuery new alias "TMP1"
_DTVALID := TMP1->D2_DTVALID
TMP1->(DBCLOSEAREA())

RestArea(aArea)

return(_DTVALID)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Ret Data ³ Autor ³ Ricardo Moreira ³         Data ³11/10/16³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna o Lote				      					      ³±±
±±³          ³ 			                                  				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function RetLote() //U_RetLote()

Local _LOTE  := " " 
Local aArea  := GetArea() //D1_FILIAL+D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD+D1_LOTECTL  

_cQuery 	:= " SELECT D2_LOTECTL "
_cQuery 	+= " FROM " + retsqlname("SD2")+" SD2 "
_cQuery 	+= " WHERE SD2.D_E_L_E_T_ <> '*' "
_cQuery 	+= " AND SD2.D2_IDENTB6 = '"+_ident+"'"

_cQuery :=changequery(_cQuery)

tcquery _cQuery new alias "TMP1"
_LOTE := TMP1->D2_LOTECTL
TMP1->(DBCLOSEAREA())

RestArea(aArea)

return(_LOTE)




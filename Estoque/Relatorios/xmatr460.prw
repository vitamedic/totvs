#INCLUDE "MATR460.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE TT	Chr(254)+Chr(254)	// Substituido p/ "TT"   
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MATR460 � Autor � Nereu Humberto Junior � Data � 31/07/06  潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Relatorio do Inventario, Registro Modelo P7                潮�
北�          � Plano de Melhoria Continua                                 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/


/*
北矷TEM PMC  � Responsavel              � Data          |BOPS             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪拍哪哪哪哪哪哪哪拍哪哪哪哪哪哪哪哪幢�
北�      01  � Marcos V. Ferreira       � 24/01/2006    |                 潮�
北�      02  � Erike Yuri da Silva      � 21/12/2005    |                 潮�
北�      03  � Marcos V. Ferreira       � 20/12/2005    |                 潮�
北�      04  � Rodrigo de A Sartorio    � 30/12/2005    |                 潮�
北�      05  � Rodrigo de A Sartorio    � 30/12/2005    |                 潮�
北�      06  � Marcos V. Ferreira       � 24/01/2006    |                 潮�
北�      07  � Marcos V. Ferreira       � 20/12/2005    |                 潮�
北�      08  � Flavio Luiz Vicco        � 06/04/2006    | 00000096610     潮�
北�      09  � Flavio Luiz Vicco        � 06/04/2006    | 00000096610     潮�
北�      10  � Erike Yuri da Silva      � 21/12/2005    |                 潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪聊哪哪哪哪哪哪哪聊哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function XMATR460()
Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矷nterface de impressao                                                  �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	XMATR460R3()
EndIf

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  砇eportDef � Autor 砃ereu Humberto Junior  � Data �31.07.2006潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矨 funcao estatica ReportDef devera ser criada para todos os 潮�
北�          硆elatorios que poderao ser agendados pelo usuario.          潮�
北�          �                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   矱xpO1: Objeto do relatorio                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砃enhum                                                      潮�
北�          �                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�   DATA   � Programador   矼anutencao efetuada                         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�          �               �                                            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function ReportDef()

Local oReport 
Local oCell         
Local oSection1
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Verifica se utiliza custo unificado por Empresa/Filial       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Funcao utilizada para verificar a ultima versao do fonte        �
//� SIGACUSA.PRX aplicados no rpo do cliente, assim verificando     |
//| a necessidade de uma atualizacao nestes fontes. NAO REMOVER !!!	�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
If !(FindFunction("SIGACUS_V") .And. SIGACUS_V() >= 20060810)
    Final(STR0040 + " SIGACUS.PRW !!!") // "Atualizar SIGACUS.PRW"
EndIf
If !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20060321)
    Final(STR0040 + " SIGACUSA.PRX !!!") // "Atualizar SIGACUSA.PRX"
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Ajusta as Perguntas do SX1				                     �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
AjustaSX1()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Ajusta perguntas no SX1 a fim de preparar o relatorio p/     �
//� custo unificado por empresa                                  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lCusUnif
	MTR460CUnf(lCusUnif)
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//矯riacao do componente de impressao                                      �
//�                                                                        �
//砊Report():New                                                           �
//矱xpC1 : Nome do relatorio                                               �
//矱xpC2 : Titulo                                                          �
//矱xpC3 : Pergunte                                                        �
//矱xpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//矱xpC5 : Descricao                                                       �
//�                                                                        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
oReport:= TReport():New("MATR460",STR0001,"MTR460", {|oReport| ReportPrint(oReport)},STR0002) //"Registro de Invent爎io - Modelo P7"##"Emiss刼 do Registro de Invent爎io.Os Valores Totais serao impressos conforme Modelo Legal"
oReport:SetTotalInLine(.F.)
oReport:SetEdit(.T.)
oReport:HideHeader() 
oReport:HideFooter()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//砈ecao criada para evitar error log no botao Personalizar     �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
oSection1 := TRSection():New(oReport,STR0042,{"SB1"}) //"Saldos em Estoque"
oSection1:SetReadOnly()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Verifica as perguntas selecionadas                           �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Saldo em Processo (Sim) (Nao)                �
//� mv_par02     // Saldo em Poder 3� (Sim) (Nao)                �
//� mv_par03     // Almox. de                                    �
//� mv_par04     // Almox. ate                                   �
//� mv_par05     // Produto de                                   �
//� mv_par06     // Produto ate                                  �
//� mv_par07     // Lista Produtos sem Movimentacao   (Sim)(Nao) �
//� mv_par08     // Lista Produtos com Saldo Negativo (Sim)(Nao) �
//� mv_par09     // Lista Produtos com Saldo Zerado   (Sim)(Nao) �
//� mv_par10     // Pagina Inicial                               �
//� mv_par11     // Quantidade de Paginas                        �
//� mv_par12     // Numero do Livro                              �
//� mv_par13     // Livro/Termos                                 �
//� mv_par14     // Data de Fechamento do Relatorio              �
//� mv_par15     // Quanto a Descricao (Normal) (Inclui Codigo)  �
//� mv_par16     // Lista Produtos com Custo Zero ?   (Sim)(Nao) �
//� mv_par17     // Lista Custo Medio / Fifo                     �
//� mv_par18     // Verifica Sld Processo Dt Emissao Seq Calculo �
//� mv_par19     // Quanto a quebra por aliquota (Nao)(Icms)(Red)�
//| mv_par20	 // Lista MOD Processo? (Sim) (Nao) 			 |
//| mv_par21	 // Seleciona Filial? (Sim) (Nao)                |
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Pergunte("MTR460",.F.)

Return(oReport)

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  砇eportPrin� Autor 砃ereu Humberto Junior  � Data �21.06.2006潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矨 funcao estatica ReportDef devera ser criada para todos os 潮�
北�          硆elatorios que poderao ser agendados pelo usuario.          潮�
北�          �                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砃enhum                                                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros矱xpO1: Objeto Report do Relatorio                           潮�
北�          �                                                            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function ReportPrint(oReport)

Static lCalcUni := Nil

Local cArqTemp  := ""
Local cIndTemp1 := ""
Local cIndTemp2 := ""
Local i         := 0
Local aArqTemp	:= {}
Local aL		:= R460LayOut()
Local nLin		:= 80
Local nPagina	:= mv_par10
Local aTotal	:= {}
Local lEmBranco	:= .F.
Local nPos      := 0
Local lImpSit, lImpTipo
Local lImpResumo:= .F.
Local lImpAliq	:= .F.
Local cPosIpi	:= ""
Local aImp		:= {}
Local nTotIpi	:= 0
Local cQuery 	:= ''
Local cChave 	:= ''
Local cKeyInd	:= ''
Local lQuery	:= .F.
Local lCusFIFO	:= SuperGetMV("MV_CUSFIFO",.F.,.F.)                                                          	
Local cLocTerc	:= SuperGetMV("MV_ALMTERC",.F.,"")
Local lFirst	:= .T.
Local aSalAtu	:= {}
Local nX		:= 0
Local aSaldo	:= {0,0}
Local cAliasTop := 'SB2'
Local aCampos   := {}
Local lAgregOP  := SB1->(FieldPos("B1_AGREGCU")) > 0 

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Verifica se utiliza custo unificado por Empresa/Filial       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local lCusUnif  := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Quantidade e custo na 1a moeda para movimentos do SD3 com D3_CF RE9 ou DE9 |
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local aDadosCF9 := {0,0}

Local cSeekUnif  := ""
Local nValTotUnif:= 0
Local nQtdTotUnif:= 0
Local aSeek      := {}
Local cSelect    := "%%"
Local cJoin      := ""
Local cArqAbert  := ""
Local cArqEncer  := ""
Local aDriver    := ReadDriver()
Local nTamSX1    := Len(SX1->X1_GRUPO)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis utilizadas no processamento por Filiais                          |
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local cFilBack  := cFilAnt
Local nForFilial:= 0
Local aFilsCalc := MatFilCalc( mv_par21 == 1 )

Private cIndSB6    := ''
Private nIndSB6	   := 0
Private cKeyQbr	   := ''
Private cPerg      := "MTR460"
Private aSaldoTerD := {}
Private aSaldoTerT := {}
Private	nDecVal    := TamSX3("B2_CM1")[2] // Retorna o numero de decimais usado no SX3

//-- Variaveis utilizadas como parametros
lSaldProcess:=(mv_par01==1)
lSaldTerceir:=(mv_par02==1)
cAlmoxIni	:=IIf(mv_par03=="**",Space(02),mv_par03)
cAlmoxFim	:=IIf(mv_par04=="**","ZZ",mv_par04)
cProdIni	:= mv_par05
cProdFim	:= mv_par06
lListProdMov:=(mv_par07==1)
lListProdNeg:=(mv_par08==1)
lListProdZer:=(mv_par09==1)
nPagIni	    := mv_par10
nQtdPag	    := mv_par11
cNrLivro    := mv_par12
lLivro	    :=(mv_par13!=2)
dDtFech	    := mv_par14
lDescrNormal:=(mv_par15==1)
lListCustZer:=(mv_par16==1)
lListCustMed:=(mv_par17==1)
lCalcProcDt :=(mv_par18==1)
nQuebraAliq := mv_par19
		
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� A460UNIT - Ponto de Entrada utilizado para regravar os campos :            |
//|            TOTAL, VALOR_UNIT e QUANTIDADE                                  |
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
lCalcUni := If(lCalcUni == NIL, ExistBlock("A460UNIT"),lCalcUni)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Cria Arquivo Temporario                                                    �
//� SITUACAO: 1=ESTOQUE,2=PROCESSO,3=SEM SALDO,4=DE TERCEIROS,5=EM TERCEIROS,  �
//�           6=DE TERCEIROS USADO EM ORDENS DE PRODUCAO                       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
AADD(aArqTemp,{"SITUACAO"	,"C",01,0})
AADD(aArqTemp,{"TIPO"		,"C",02,0})
AADD(aArqTemp,{"POSIPI"		,"C",10,0})
AADD(aArqTemp,{"PRODUTO"	,"C",15,0})
AADD(aArqTemp,{"DESCRICAO"	,"C",35,0})
AADD(aArqTemp,{"UM"			,"C",02,0})
AADD(aArqTemp,{"QUANTIDADE"	,"N",14,TamSX3("B2_QFIM")[2]})
AADD(aArqTemp,{"VALOR_UNIT"	,"N",21,nDecVal})
AADD(aArqTemp,{"TOTAL"		,"N",21,nDecVal})
If nQuebraAliq <> 1
	AADD(aArqTemp,{"ALIQ"	,"N",5,2})
EndIf

//-- Chave do Indice de Trabalho
If nQuebraAliq == 1
	cKeyInd:= "SITUACAO+TIPO+POSIPI+PRODUTO"
Else
	cKeyInd:= "SITUACAO+TIPO+STR(ALIQ,5,2)+PRODUTO"
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Processando Relatorio por Filiais                                          �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If !Empty(aFilsCalc)

	For nForFilial := 1 To Len( aFilsCalc )
	
		If aFilsCalc[ nForFilial, 1 ]
		
			//-- Muda Filial para processamento
			cFilAnt := aFilsCalc[ nForFilial, 2 ]
	
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//| Impressao dos Livros                                                       |
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If lLivro

				//-- Cria Indice de Trabalho para Poder de Terceiros
				If lSaldTerceir
					#IFNDEF TOP
						dbSelectArea("SB6")
						cIndSB6:=Substr(CriaTrab(NIL,.F.),1,7)+"T"
						cChave := "B6_FILIAL+B6_PRODUTO+B6_TIPO+DTOS(B6_DTDIGIT)"
						cQuery := 'DtoS(B6_DTDIGIT)<="'+DtoS(mv_par14)+'".And.B6_PRODUTO>="'+mv_par05+'".And.B6_PRODUTO<="'+mv_par06+'".And.B6_LOCAL>="'+cAlmoxIni+'".And.B6_LOCAL<="'+cAlmoxFim+'"'
						IndRegua("SB6",cIndSB6,cChave,,cQuery,STR0013)		//"Selecionando Poder Terceiros..."
						nIndSB6:=RetIndex("SB6")
						dbSetIndex(cIndSB6+OrdBagExt())
						dbSetOrder(nIndSB6 + 1)
						dbGoTop()
					#ENDIF
				EndIf
		
				//-- Cria Indice de Trabalho
				cArqTemp :=CriaTrab(aArqTemp)
				cIndTemp1:=Substr(CriaTrab(NIL,.F.),1,7)+"1"
				cIndTemp2:=Substr(CriaTrab(NIL,.F.),1,7)+"2"

				//-- Criando Indice Temporario
				dbUseArea(.T.,,cArqTemp,cArqTemp,.T.,.F.)
				IndRegua(cArqTemp,cIndTemp1,cKeyInd,,,STR0014)				//"Indice Tempor爎io..."
				IndRegua(cArqTemp,cIndTemp2,"PRODUTO+SITUACAO",,,STR0014)	//"Indice Tempor爎io..."
				
				Set Cursor Off
				DbClearIndex()
				DbSetIndex(cIndTemp1+OrdBagExt())
				DbSetIndex(cIndTemp2+OrdBagExt())

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矲iltragem do relatorio                                                  �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				#IFDEF TOP
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//砊ransforma parametros Range em expressao SQL                            �	
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					MakeSqlExpr(oReport:uParam)
					
					cAliasTop := GetNextAlias()
					lQuery    := .T.
				
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//砆uery do relatorio da secao 1                                           �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					oReport:Section(1):BeginQuery()	

						cSelect := "%"+IIf(lAgregOP,"SB1.B1_AGREGCU, ","")+"%"
						
					   	cJoin := "%"
						cJoin += IIf(mv_par07==1,"LEFT","")+" JOIN " + RetSqlName("SB2") + " SB2 ON "
						cJoin += "%"
					   
						BeginSql Alias cAliasTop
					
							SELECT SB1.B1_FILIAL, 
								   SB1.B1_COD, 
							       SB1.B1_TIPO, 
							       SB1.B1_POSIPI, 
						 	       SB1.B1_DESC, 
							       SB1.B1_UM, 
							       SB1.B1_PICM, 
							       SB2.B2_LOCAL,
								   %Exp:cSelect%
							       SB2.B2_COD
								   
							FROM %table:SB1% SB1
							
							%Exp:cJoin%		
									SB1.B1_FILIAL  =  %xFilial:SB1%	 	AND
									SB2.B2_FILIAL  =  %xFilial:SB2%	 	AND
									SB1.B1_COD     =  SB2.B2_COD       	AND 
									SB1.B1_COD     >= %Exp:mv_par05% 	AND
									SB1.B1_COD     <= %Exp:mv_par06% 	AND
									SB2.B2_LOCAL   >= %Exp:cAlmoxIni% 	AND
									SB2.B2_LOCAL   <= %Exp:cAlmoxFim% 	AND
									SB2.%NotDel%                     	         
							
							WHERE   SB1.B1_FILIAL  =  %xFilial:SB1%	 	AND
                                    SB1.%NotDel%
					
							ORDER BY 1,2,8 //-- FILIAL+PRODUTO+LOCAL
							
						EndSql 
		
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//矼etodo EndQuery ( Classe TRSection )                                    �
					//�                                                                        �
					//砅repara o relatorio para executar o Embedded SQL.                       �
					//�                                                                        �
					//矱xpA1 : Array com os parametros do tipo Range                           �
					//�                                                                        �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
					
				#ELSE

					dbSelectArea("SB1")
					dbSetOrder(1)
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//砊ransforma parametros Range em expressao Advpl                          �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					MakeAdvplExpr(oReport:uParam)
				
					cCondicao := 'B1_FILIAL == "'+xFilial("SB1")+'".And.' 
					cCondicao += 'B1_COD >= "'+mv_par05+'".And.B1_COD <="'+mv_par06+'"'
					
					oReport:Section(1):SetFilter(cCondicao,IndexKey())
				
				#ENDIF		
		
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矷nicio da impressao do fluxo do relatorio                               �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				oReport:SetMeter(SB1->(LastRec()))
	
				While !oReport:Cancel() .And. !Eof() 
				
					If oReport:Cancel()
						Exit
					EndIf	
				    
					oReport:IncMeter()	
					
					lEnd:= oReport:Cancel()
					
					#IFDEF TOP
						//-- aCampos - Array utilizado como tabela auxiliar SB1
						aCampos:= {	(cAliasTop)->B1_FILIAL,;					//01 - FILIAL
									(cAliasTop)->B1_COD,;						//02 - PRODUTO
									(cAliasTop)->B1_TIPO,;						//03 - TIPO
									(cAliasTop)->B1_POSIPI,;					//04 - POSIPI
									(cAliasTop)->B1_DESC,;						//05 - DESCRICAO
									(cAliasTop)->B1_UM,;						//06 - UM
									(cAliasTop)->B1_PICM,;						//07 - PICM
									IIf(lAgregOp,(cAliasTop)->B1_AGREGCU,"") }	//08 - AGREGCU 
					#ENDIF

					// Avalia se o Produto nao entrara no processamento
					If !Empty(mv_par06) .And. B1_COD > mv_par06
						Exit
					EndIf
	
					// Avalia se o Produto nao entrara no processamento
					If !R460AvalProd(B1_COD)
						dbSkip()
						Loop
					EndIf

					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Alimenta Array com Saldo D = De Terceiros/ T = Em Terceiros  �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					If lSaldTerceir
						aSaldoTerD   := SaldoTerc(If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),cAlmoxIni,"D",dDtFech,cAlmoxFim,,If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),lSaldTerceir,lCusFIFO)
						aSaldoTerT   := SaldoTerc(If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),cAlmoxIni,"T",dDtFech,cAlmoxFim,,If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),lSaldTerceir,lCusFIFO)
					EndIf
							
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Busca Saldo em Estoque  					                 �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					lFirst	  := .T.
					aSalAtu	  :={}
					aSaldo    :={0,0}
				
					//-- Posiciona na tabela de Saldos SB2
					If !lQuery
						dbSelectArea("SB2")
						dbSeek(xFilial("SB2")+SB1->B1_COD+If(Empty(cAlmoxIni), "", cAlmoxIni),.T.)
					EndIf
				
					If If(lQuery,Empty((cAliasTop)->B2_COD),Eof() .Or. !(SB1->B1_COD == SB2->B2_COD))
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//� Lista produtos sem movimentacao de estoque                   �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						If lListProdMov
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� TIPO 3 - PRODUTOS SEM SALDO                              �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							dbSelectArea(cArqTemp)
							RecLock(cArqTemp,.T.)
							Replace SITUACAO	with "3"
							Replace TIPO		with If(lQuery,aCampos[3],SB1->B1_TIPO)
							Replace PRODUTO		with If(lQuery,aCampos[2],SB1->B1_COD)
							Replace POSIPI		with If(lQuery,aCampos[4],SB1->B1_POSIPI)
							Replace DESCRICAO	with If(lQuery,aCampos[5],SB1->B1_DESC)
							Replace UM		   	with If(lQuery,aCampos[6],SB1->B1_UM)
							If nQuebraAliq <> 1
								If nQuebraAliq == 2
									Replace ALIQ with If(lQuery,aCampos[7],SB1->B1_PICM)
								Else
									Replace ALIQ with IIf(SB0->(MsSeek(xFilial("SB0")+If(lQuery,aCampos[2],SB1->B1_COD))),SB0->B0_ALIQRED,0)
								EndIf
							EndIf
							MsUnLock()
						EndIf

						If lQuery
							dbSelectArea(cAliasTop)
							dbSkip()
						EndIf

					Else
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//� Lista produtos com movimentacao de estoque                   �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						While !oReport:Cancel() .And. !Eof() .And. If(lQuery,(cAliasTop)->B2_COD == aCampos[2],SB2->B2_FILIAL==xFilial("SB2") .And. SB2->B2_COD==SB1->B1_COD .And. SB2->B2_LOCAL <= cAlmoxFim)
				
							If !lQuery
								If !R460Local(SB2->B2_LOCAL)
									dbSkip()
									Loop
								EndIf
							EndIf
				
							If oReport:Cancel()
								Exit
							EndIf	

							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� Desconsidera almoxarifado de saldo em processo de mat.indiret�
							//� ou saldo em armazem de terceiros                             �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							If (cAliasTop)->B2_LOCAL==GetMv("MV_LOCPROC") .Or. (cAliasTop)->B2_LOCAL $ cLocTerc
								dbSkip()
								Loop
							EndIf
							                            
                            //-- Retorna o Saldo Atual
							If lListCustMed .Or. (!lListCustMed .And. !lCusfifo)
								aSalatu:=CalcEst(If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech+1,nil)
							Else
								aSalAtu:=CalcEstFF(If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech+1,nil)		
							EndIf

							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� TIPO 1 - EM ESTOQUE                                      �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							dbSelectArea(cArqTemp)
							dbSetOrder(2)
							If dbSeek(If(lQuery,aCampos[2],SB1->B1_COD)+"1")
								RecLock(cArqTemp,.F.)
							Else
								RecLock(cArqTemp,.T.)
								lFirst:=.F.
								Replace SITUACAO	with "1"
								Replace TIPO		with If(lQuery,aCampos[3],SB1->B1_TIPO)
								Replace POSIPI		with If(lQuery,aCampos[4],SB1->B1_POSIPI)
								Replace PRODUTO		with If(lQuery,aCampos[2],SB1->B1_COD)
								Replace DESCRICAO	with If(lQuery,aCampos[5],SB1->B1_DESC)
								Replace UM			with If(lQuery,aCampos[6],SB1->B1_UM)
								If nQuebraAliq <> 1
									If nQuebraAliq == 2
										Replace ALIQ with If(lQuery,aCampos[7],SB1->B1_PICM)
									Else
										Replace ALIQ with IIf(SB0->(MsSeek(xFilial("SB0")+If(lQuery,aCampos[2],SB1->B1_COD))),SB0->B0_ALIQRED,0)
									EndIf
								EndIf
							EndIf
							Replace QUANTIDADE 	With QUANTIDADE+aSalAtu[01]
							Replace TOTAL		With TOTAL+aSalAtu[02]
							If aSalAtu[1]>0
								Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
							EndIf
							
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
							//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
							If lCalcUni
								ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
							EndIf
							
							MsUnLock()
							dbSelectArea(cAliasTop)
							dbSkip()
						EndDo

						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						//� Pesquisa os valores de material de terceiros requisitados para OP         �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
						aDadosCF9 := {0,0} // Quantidade e custo na 1a moeda para movimentos do SD3 com D3_CF RE9 ou DE9
						If lAgregOP .And. If(lQuery,aCampos[8] == "1",SB1->B1_AGREGCU == "1")
							aDadosCF9:=SaldoD3CF9(If(lQuery,aCampos[2],SB1->B1_COD),NIL,mv_par14,cAlmoxIni,cAlmoxFim)				
							If (QtdComp(aDadosCF9[1]) > QtdComp(0)) .Or. (QtdComp(aDadosCF9[2]) > QtdComp(0))
								dbSelectArea(cArqTemp)
								dbSetOrder(2)
								If dbSeek(If(lQuery,aCampos[2],SB1->B1_COD)+"6")
									RecLock(cArqTemp,.F.)
								Else
									RecLock(cArqTemp,.T.)
									lFirst:=.F.
									Replace SITUACAO	with "6"
									Replace TIPO		with If(lQuery,aCampos[3],SB1->B1_TIPO)
									Replace POSIPI		with If(lQuery,aCampos[4],SB1->B1_POSIPI)
									Replace PRODUTO		with If(lQuery,aCampos[2],SB1->B1_COD)
									Replace DESCRICAO	with If(lQuery,aCampos[5],SB1->B1_DESC)
									Replace UM			with If(lQuery,aCampos[6],SB1->B1_UM)
									If nQuebraAliq <> 1
										If nQuebraAliq == 2
											Replace ALIQ with If(lQuery,aCampos[7],SB1->B1_PICM)
										Else
											Replace ALIQ with IIf(SB0->(MsSeek(xFilial("SB0")+If(lQuery,aCampos[2],SB1->B1_COD))),SB0->B0_ALIQRED,0)
										EndIf
									EndIf
								EndIf
								Replace QUANTIDADE 	With aDadosCF9[1]
								Replace TOTAL		With aDadosCF9[2]
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
								//� Recalcula valor unitario                                                  �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
								If QUANTIDADE>0
									Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
								EndIf

								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
								//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
								If lCalcUni
									ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
								EndIf

								MsUnLock()				                 				
							EndIf
						EndIf
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						//� Tratamento de poder de terceiros                                          �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
						If lSaldTerceir .And. If(lQuery,.T.,SB1->B1_FILIAL==xFilial("SB1"))
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
							//� Pesquisa os valores D = De Terceiros na array aSaldoTerD                  �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
							nX := aScan(aSaldoTerD,{|x| x[1] == xFilial("SB6")+If(lQuery,aCampos[2],SB1->B1_COD)})
							If !(nX == 0)
								aSaldo[1] := aSaldoTerD[nX][3]
								aSaldo[2] := aSaldoTerD[nX][4]
							EndIf
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
							//� Manipula arquivo de trabalho subtraindo do saldo em estoque saldo de terceiros      �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
							dbSelectArea(cArqTemp)
							dbSetOrder(2)
							If dbSeek(If(lQuery,aCampos[2],SB1->B1_COD)+"1")
								RecLock(cArqTemp,.F.)
							Else
								RecLock(cArqTemp,.T.)
								lFirst:=.F.
								Replace SITUACAO	with "1"
								Replace TIPO		with If(lQuery,aCampos[3],SB1->B1_TIPO)
								Replace POSIPI		with If(lQuery,aCampos[4],SB1->B1_POSIPI)
								Replace PRODUTO		with If(lQuery,aCampos[2],SB1->B1_COD)
								Replace DESCRICAO	with If(lQuery,aCampos[5],SB1->B1_DESC)
								Replace UM			with If(lQuery,aCampos[6],SB1->B1_UM)
								If nQuebraAliq <> 1
									If nQuebraAliq == 2
										Replace ALIQ with If(lQuery,aCampos[7],SB1->B1_PICM)
									Else
										Replace ALIQ with IIf(SB0->(MsSeek(xFilial("SB0")+If(lQuery,aCampos[2],SB1->B1_COD))),SB0->B0_ALIQRED,0)
									EndIf
								EndIf
							EndIf
							Replace QUANTIDADE 	With QUANTIDADE-aSaldo[01]
							Replace TOTAL		With TOTAL-aSaldo[02]
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
							//� Pesquisa os valores de material de terceiros requisitados para OP         �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
							If lAgregOP .And. If(lQuery,aCampos[8] == "1",SB1->B1_AGREGCU == "1")
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
								//� Desconsidera do calculo do saldo em estoque movimentos RE9 e DE9          �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
								If (QtdComp(aDadosCF9[1]) > QtdComp(0)) .Or. (QtdComp(aDadosCF9[2]) > QtdComp(0))
									Replace QUANTIDADE 	With QUANTIDADE+aDadosCF9[1]
									Replace TOTAL		With TOTAL+aDadosCF9[2]
								EndIf
							EndIf
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
							//� Recalcula valor unitario                                                  �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
							If QUANTIDADE>0
								Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
							EndIf
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
							//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
							If lCalcUni
								ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
							EndIf
							MsUnLock()				                 				
						EndIf
					EndIf

					If !lQuery
						dbSelectArea("SB1")
					EndIf
				
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					//� Processa Saldo De Terceiro TIPO 4 - SALDO DE TERCEIROS                    �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
					R460Terceiros(@lEnd,cArqTemp,"4",lQuery,aCampos,aDadosCF9) // Saldos de Terceiros

					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					//� Processa Saldo Em Terceiro TIPO 5 - SALDO EM TERCEIROS                    �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
					R460Terceiros(@lEnd,cArqTemp,"5",lQuery,aCampos,NIL)		// Saldos em Terceiros
				
					If lQuery
						dbSelectArea(cAliasTop)
					Else
						dbSelectArea("SB1")
						dbSkip()
					EndIf
				
				EndDo
				
				lEnd:= oReport:Cancel()
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� Processa Saldo Em Processo TIPO 2 - SALDO EM PROCESSO                     �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
				If lSaldProcess
					XR460EmProcesso(@lEnd,cArqTemp,.T.,cProdIni,cProdFim,cAlmoxIni,cAlmoxFim,mv_par20==1,dDtFech,lCalcProcDt,nQuebraAliq,lListCustMed)
				EndIf
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� CUSTO UNIFICADO - Realiza acerto dos valores para todos tipos             �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				If lCusUnif
					dbSelectArea(cArqTemp)
					dbSetOrder(2)
					dbGotop()
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Percorre arquivo                                             �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					While !Eof()
						cSeekUnif   :=PRODUTO
						aSeek       :={}
						nValTotUnif :=0
						nQtdTotUnif :=0
						While !Eof() .And. cSeekUnif == PRODUTO
				
							If oReport:Cancel()
								Exit
							EndIf	
				
							oReport:IncMeter()	
				
							If (!lListProdNeg .And. QUANTIDADE<0) .Or. (!lListProdZer .And. QUANTIDADE==0) .Or. (!lListCustZer .And. TOTAL==0)
								dbSkip()
								Loop
				    		EndIf
				  			
				  			AADD(aSeek,Recno())
							nValTotUnif+=TOTAL
							nQtdTotUnif+=QUANTIDADE
							dbSkip()
						End 
						                          
						If Len(aSeek) > 0
							// Calcula novo valor unitario
						  	For nx:=1 to Len(aSeek)
								dbGoto(aSeek[nx])
								Reclock(cArqTemp,.f.)
								Replace VALOR_UNIT With NoRound(nValTotUnif/nQtdTotUnif,nDecVal)
								Replace TOTAL      With QUANTIDADE*(nValTotUnif/nQtdTotUnif)
								MsUnlock()
							Next nx 
							dbSkip()
						EndIf
					End
				EndIf
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Imprime Modelo P7                                            �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				dbSelectArea(cArqTemp)
				dbSetOrder(1)
				dbGotop()

				oReport:SetMeter((cArqTemp)->(LastRec()))
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Flags de Impressao                                           �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				cSitAnt	:="X"
				aSituacao:={STR0015,STR0016,STR0017,STR0018,STR0019,STR0034}		//" EM ESTOQUE "###" EM PROCESSO "###" SEM MOVIMENTACAO "###" DE TERCEIROS "###" EM TERCEIROS "
				cTipoAnt:="XX"
				cQuebra := ""
				
				While !oReport:Cancel() .And. !Eof() 
				
					nLin    := 80
					cSitAnt := SITUACAO
					lImpSit := .T.
				
					While !oReport:Cancel() .And. !Eof() .And. cSitAnt == SITUACAO
				
						cTipoAnt := TIPO
						lImpTipo := .T.
				
						While !oReport:Cancel() .And. !Eof() .And. cSitAnt+cTipoAnt == SITUACAO+TIPO
				
							cPosIpi:=POSIPI
							nTotIpi:=0
							If nQuebraAliq <> 1
								nAliq    := ALIQ
								lImpAliq := .T.
							EndIf	
							cQuebra := IIf( nQuebraAliq == 1,cSitAnt+cTipoAnt+cPosIpi,cSitAnt+cTipoAnt+Str(nAliq,5,2))
							cKeyQbr := IIf( nQuebraAliq == 1,'SITUACAO+TIPO+POSIPI','SITUACAO+TIPO+Str(ALIQ,5,2)')
				
							While !oReport:Cancel() .And. !Eof() .And. cQuebra==&(cKeyQbr)
	
								If oReport:Cancel()
									Exit
								EndIf	
							    
								oReport:IncMeter()	
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
								//� Controla impressao de Produtos com saldo negativo ou zerado  �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
								If (!lListProdNeg.And.QUANTIDADE<0).Or.(!lListProdZer.And.QUANTIDADE==0).Or.(!lListCustZer.And.TOTAL==0)
									dbSkip()
									Loop
								Else
									nTotIpi+=TOTAL
									R460Acumula(aTotal)
								EndIf
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
								//� Inicializa array com itens de impressao de acordo com MV_PAR15  �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				
								If lDescrNormal
									aImp:={	Alltrim(POSIPI),;
											DESCRICAO,;
											UM,;
											Transform(QUANTIDADE,PesqPict("SB2", "B2_QFIM",14)),;
											Transform(NoRound(TOTAL/QUANTIDADE,nDecVal),PesqPict("SB2", "B2_CM1",18)),;
											Transform(TOTAL,"@E 999,999,999,999.99" ),;
											Nil}
								Else
									aImp:={	Alltrim(POSIPI),;
											Padr(Alltrim(PRODUTO)+" - "+DESCRICAO,35),;
											UM,;
											Transform(QUANTIDADE,PesqPict("SB2", "B2_QFIM",14)),;
											Transform(NoRound(TOTAL/QUANTIDADE,nDecVal),PesqPict("SB2", "B2_CM1",18)),;
											Transform(TOTAL,"@E 999,999,999,999.99"),;
											Nil}
								EndIf
								dbSelectArea(cArqTemp)
								dbSkip()
				
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
								//� Salta registros Zerados ou Negativos Conforme Parametros        �
								//� Necessario Ajustar Posicao p/ Totalizacao de Grupos (POSIPI)    �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
								While !oReport:Cancel() .And. !Eof() .And. ((!lListProdNeg.And.QUANTIDADE<0).Or.(!lListProdZer.And.QUANTIDADE==0).Or.(!lListCustZer.And.TOTAL==0))
									dbSkip()
								EndDo
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
								//� Verifica se imprime total por POSIPI.                        �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
								If !(cSitAnt+cTipoAnt+cPosIpi==SITUACAO+TIPO+POSIPI) .And. nQuebraAliq == 1
									aImp[07] := Transform(nTotIPI,"@E 999,999,999,999.99")
								EndIf
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
								//� Imprime cabecalho                                            �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
								If nLin>55
									R460Cabec( @nLin, @nPagina, .T., oReport, aFilsCalc[ nForFilial, 3 ] )
								EndIf
				
								If lImpSit
									FmtLinR4(oReport,{"",Padc(aSituacao[Val(cSitAnt)],35,"*"),"","","","",""},aL[15],,,@nLin)
									lImpSit := .F.
								EndIf
				
								If lImpTipo
									SX5->(dbSeek(xFilial("SX5")+"02"+cTipoAnt))
									FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
									FmtLinR4(oReport,{"",Padc(" "+Trim(X5Descri())+" ",35,"*"),"","","","",""},aL[15],,,@nLin)
									FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
									lImpTipo := .F.
								EndIf
								If nQuebraAliq <> 1
									If lImpAliq
										FmtLinR4(oReport,{"",Padc(" "+STR0031+Transform(nAliq,"@E 99.99%")+" ",35,"*"),"","","","",""},aL[15],,,@nLin)
										FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
										lImpAliq := .F.
									EndIf	
								EndIf	
								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
								//� Imprime linhas de detalhe de acordo com parametro (mv_par15) �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
								FmtLinR4(oReport,aImp,aL[15],,,@nLin)
				
								If nQuebraAliq <> 1 .And. cQuebra <> &(cKeyQbr)
									FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
									nPos:=Ascan(aTotal,{|x|x[1]==cSitAnt.And.x[2]==cTipoAnt.And.x[6]==nAliq})
									FmtLinR4(oReport,{,STR0021+STR0031+Transform(nAliq,"@E 99.99%")+" ===>",,,,,Transform(aTotal[nPos,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)			//"TOTAL "
									FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
								EndIf
				
								If nLin>=55
									R460EmBranco(@nLin,.T.,oReport)
								EndIf
							EndDo
						EndDo
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//� Impressao de Totais                                          �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						nPos := Ascan(aTotal,{|x|x[1]==cSitAnt.And.x[2]==cTipoAnt})
						If nPos # 0
							If nLin>55
								R460Cabec( @nLin, @nPagina, .T., oReport, aFilsCalc[ nForFilial, 3 ] )
							EndIf
							R460Total( @nLin, aTotal, cSitAnt, cTipoAnt, aSituacao, @nPagina, .T., oReport, aFilsCalc[ nForFilial, 3 ] )
						EndIf
					EndDo
				
					nPos := Ascan(aTotal,{|x|x[1]==cSitAnt.And.x[2]==TT})
					If nPos # 0
						R460Total( @nLin, aTotal, cSitAnt, TT, aSituacao, @nPagina, .T., oReport, aFilsCalc[ nForFilial, 3 ] )
						R460EmBranco(@nLin,.T.,oReport)
						lImpResumo:=.T.
					EndIf
				EndDo
				
				R460Cabec( @nLin, @nPagina, .T., oReport, aFilsCalc[ nForFilial, 3 ] )
				
				If lImpResumo
					R460Total( @nLin, aTotal, "T", TT, aSituacao, @nPagina, .T., oReport, aFilsCalc[ nForFilial, 3 ] )
				Else
					R460SemEst( @nLin, @nPagina, .T., oReport )
				EndIf
				
				R460EmBranco(@nLin,.T.,oReport)
			
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Apaga Arquivos Temporarios                                   �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				dbSelectArea(cArqTemp)
				dbCloseArea()
				Ferase(cArqTemp+GetDBExtension())
				Ferase(cIndTemp1+OrdBagExt())
				Ferase(cIndTemp2+OrdBagExt())
	
				If lSaldTerceir
					#IFNDEF TOP
						dbSelectArea("SB6")
						RetIndex("SB6")
						dbClearFilter()
						Ferase(cIndSB6+OrdBagExt())
					#ENDIF
				EndIf

				If lQuery
					dbSelectArea(cAliasTop)
					dbCloseArea()
				Else
					dbSelectArea("SB1")
					dbCloseArea()
				EndIf
				
				dbSelectArea("SB1")
				dbSetOrder(1)
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//| Impressao dos Termos                                                       |
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			Else

				cArqAbert:=GetMv("MV_LMOD7AB")
				cArqEncer:=GetMv("MV_LMOD7EN")
			
				//-- Posiciona na Empresa/Filial 
				dbSelectArea("SM0")
				dbSetOrder(1)
				dbSeek(cEmpAnt+cFilAnt)

				aVariaveis:={}
			
				For i:=1 to FCount()
					If FieldName(i)=="M0_CGC"
						AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
					Else
						If FieldName(i)=="M0_NOME"
							Loop
						EndIf
						AADD(aVariaveis,{FieldName(i),FieldGet(i)})
					EndIf
				Next
			
				dbSelectArea("SX1")
				dbSeek(PADR("MTR470",nTamSX1)+"01")
			
				While SX1->X1_GRUPO==PADR("MTR910",nTamSX1)
					AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)})
					dbSkip()
				EndDo

				If AliasIndic( "CVB" )
					dbSelectArea( "CVB" )
					CVB->(dbSeek( xFilial( "CVB" ) ))
					For i:=1 to FCount()
						If FieldName(i)=="CVB_CGC"
							AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
						ElseIf FieldName(i)=="CVB_CPF"
							AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 999.999.999-99")})
						Else
							AADD(aVariaveis,{FieldName(i),FieldGet(i)})
						Endif
					Next
				EndIf
			
				AADD(aVariaveis,{"M_DIA",StrZero(Day(dDataBase),2)})
				AADD(aVariaveis,{"M_MES",MesExtenso()})
				AADD(aVariaveis,{"M_ANO",StrZero(Year(dDataBase),4)})
			
				cDriver:=aDriver[4]
			    oReport:HideHeader()
				If cArqAbert#NIL
					oReport:EndPage()
					ImpTerm(cArqAbert,aVariaveis,&cDriver,,,.T.,oReport)
				EndIf
			
				If cArqEncer#NIL
					oReport:EndPage()
					ImpTerm(cArqEncer,aVariaveis,&cDriver,,,.T.,oReport)
				EndIf
			EndIf
		
		EndIf
	
	Next nForFilial
	
EndIf

cFilAnt := cFilBack

Return()
/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    矼ATR460R3 � Autor � Juan Jose Pereira     � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Relatorio do Inventario, Registro Modelo P7                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico                                                   潮�
北媚哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             潮�
北媚哪哪哪哪哪穆哪哪哪哪履哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅rogramador � Data   � BOPS �  Motivo da Alteracao                     潮�
北媚哪哪哪哪哪呐哪哪哪哪拍哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�            �        �      �                                          潮�
北滥哪哪哪哪哪牧哪哪哪哪聊哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function XMATR460R3()
Local wnrel
Local Titulo	:= STR0001	//"Registro de Invent爎io - Modelo P7"
Local cDesc1	:= STR0002	//"Emiss刼 do Registro de Invent爎io.Os Valores Totais serao impressos conforme Modelo Legal"
Local cDesc2	:= ""
Local cDesc3	:= ""
Local cString	:= "SB1"
Local NomeProg	:= "MATR460"
Local aSave		:= {Alias(),IndexOrd(),Recno()}
Local Tamanho	:= "M"
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis utilizadas no processamento por Filiais                          |
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local cFilBack  := cFilAnt
Local nForFilial:= 0
Local aFilsCalc := {}

Private aReturn	 := {STR0005,1,STR0006,2,2,1,"",1}	//"Zebrado"###"Administra噭o"
Private nLastKey := 0
Private cPerg    := "MTR460"
Private nTipo    := 0
Private	nDecVal  := TamSX3("B2_CM1")[2] // Retorna o numero de decimais usado no SX3
Private lImpSX1  := .T.

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Verifica se utiliza custo unificado por Empresa/Filial       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Private lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Funcao utilizada para verificar a ultima versao do fonte        �
//� SIGACUSA.PRX aplicados no rpo do cliente, assim verificando     |
//| a necessidade de uma atualizacao nestes fontes. NAO REMOVER !!!	�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
If !(FindFunction("SIGACUS_V") .And. SIGACUS_V() >= 20060810)
    Final(STR0040 + " SIGACUS.PRW !!!") // "Atualizar SIGACUS.PRW"
EndIf
If !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20060321)
    Final(STR0040 + " SIGACUSA.PRX !!!") // "Atualizar SIGACUSA.PRX"
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Ajusta as Perguntas do SX1				                     �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
AjustaSX1()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Ajusta perguntas no SX1 a fim de preparar o relatorio p/     �
//� custo unificado por empresa                                  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lCusUnif
	MTR460CUnf(lCusUnif)
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Envia controle para a funcao SETPRINT                        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey <> 27
	SetDefault(aReturn,cString)
	If nLastKey <> 27
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Verifica as perguntas selecionadas                           �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Variaveis utilizadas para parametros                         �
		//� mv_par01     // Saldo em Processo (Sim) (Nao)                �
		//� mv_par02     // Saldo em Poder 3� (Sim) (Nao)                �
		//� mv_par03     // Almox. de                                    �
		//� mv_par04     // Almox. ate                                   �
		//� mv_par05     // Produto de                                   �
		//� mv_par06     // Produto ate                                  �
		//� mv_par07     // Lista Produtos sem Movimentacao   (Sim)(Nao) �
		//� mv_par08     // Lista Produtos com Saldo Negativo (Sim)(Nao) �
		//� mv_par09     // Lista Produtos com Saldo Zerado   (Sim)(Nao) �
		//� mv_par10     // Pagina Inicial                               �
		//� mv_par11     // Quantidade de Paginas                        �
		//� mv_par12     // Numero do Livro                              �
		//� mv_par13     // Livro/Termos                                 �
		//� mv_par14     // Data de Fechamento do Relatorio              �
		//� mv_par15     // Quanto a Descricao (Normal) (Inclui Codigo)  �
		//� mv_par16     // Lista Produtos com Custo Zero ?   (Sim)(Nao) �
		//� mv_par17     // Lista Custo Medio / Fifo                     �
		//� mv_par18     // Verifica Sld Processo Dt Emissao Seq Calculo �
		//� mv_par19     // Quanto a quebra por aliquota (Nao)(Icms)(Red)�
		//| mv_par20	 // Lista MOD Processo? (Sim) (Nao) 			 |
		//| mv_par21	 // Seleciona Filial? (Sim) (Nao)                |
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		Pergunte(cPerg,.F.)

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Recebe parametros das perguntas                              �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		lSaldProcess:=(mv_par01==1)
		lSaldTerceir:=(mv_par02==1)
		cAlmoxIni	:=IIf(mv_par03=="**",Space(02),mv_par03)
		cAlmoxFim	:=IIf(mv_par04=="**","ZZ",mv_par04)
		cProdIni	:= mv_par05
		cProdFim	:= mv_par06
		lListProdMov:=(mv_par07==1)
		lListProdNeg:=(mv_par08==1)
		lListProdZer:=(mv_par09==1)
		nPagIni		:= mv_par10
		nQtdPag		:= mv_par11
		cNrLivro	:= mv_par12
		lLivro		:=(mv_par13!=2)
		dDtFech		:= mv_par14
		lDescrNormal:=(mv_par15==1)
		lListCustZer:=(mv_par16==1)
		lListCustMed:=(mv_par17==1)
		lCalcProcDt	:=(mv_par18==1)
		nQuebraAliq	:= mv_par19

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Janela de Selecao de Filiais                                               �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		aFilsCalc := MatFilCalc( mv_par21 == 1 )
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Processando Relatorio por Filiais                                          �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If !Empty(aFilsCalc)
		
			For nForFilial := 1 To Len( aFilsCalc )
			
				If aFilsCalc[ nForFilial, 1 ]
				
					//-- Muda Filial para processamento
					cFilAnt  := aFilsCalc[ nForFilial, 2 ]
		
					If lLivro
						RptStatus( { |lEnd| R460Imp(@lEnd,wnRel,cString,Tamanho,aFilsCalc[ nForFilial,3])}, Titulo  , STR0041 + aFilsCalc[ nForFilial,2 ] + " - " + aFilsCalc[ nForFilial,3])
					Else
						RptStatus( { |lEnd| R460Term(@lEnd,wnRel,cString,Tamanho) }, Titulo, STR0041 + aFilsCalc[ nForFilial,2 ] + " - " + aFilsCalc[ nForFilial,3])
					EndIf
		
					lImpSX1  := .F. //-- Imprimir Somente um vez o grupo de perguntas

				EndIf
				
			Next nForFilial

			If aReturn[5]==1
				Set Printer To
				dbCommitAll()
				OurSpool(wnrel)
			EndIf
				
			MS_FLUSH()
	
		EndIf   
		
		//-- Restaura Filial Original
		cFilAnt := cFilBack
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Restaura ambiente                                            �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dbSelectArea(aSave[1])
		dbSetOrder(aSave[2])
		dbGoto(aSave[3])
	EndIf
EndIf	
Return Nil

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    砇460LayOut� Autor � Juan Jose Pereira     � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矻ay-Out do Modelo P7                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  砤L - Array com layout do cabecalho do relatorio             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � MATR460                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function R460LayOut()
Local aL:=Array(16)
aL[01]:=				  "+----------------------------------------------------------------------------------------------------------------------------------+"
aL[02]:=STR0007	//"|                                                     REGISTRO DE INVENTARIO                                                       |"
aL[03]:=				  "|                                                                                                                                  |"
aL[04]:=STR0039 //"| FIRMA:#########################################     FILIAL: ###############                                                      |"
aL[05]:=				  "|                                                                                                                                  |"
If cPaisLoc == "CHI"
	aL[06]:=STR0029	//"| INSC.EST.: ################   C.G.C.(MF): ################################                                                       |"
Else
	aL[06]:=STR0009	//"| INSC.EST.: ################   C.G.C.(MF): ################################                                                       |"
EndIf
aL[07]:=				  "|                                                                                                                                  |"
aL[08]:=STR0010	//"| FOLHA: #######                ESTOQUES EXISTENTES EM: ##########                                                                 |"
aL[09]:=				  "|                                                                                                                                  |"
aL[10]:=				  "|----------------------------------------------------------------------------------------------------------------------------------|"
If ( cPaisLoc=="BRA" )
	aL[11]:=STR0025	//"|             |                                      |    |              |                        VALORES                          |"
	aL[12]:=STR0011	//"|CLASSIFICACAO|                                      |    |              |-------------------------------------+-------------------|"
	aL[13]:=STR0012	//"|    FISCAL   |     D I S C R I M I N A C A O        |UNID|  QUANTIDADE  |     UNITARIO     |     PARCIAL      |      TOTAL        |"
	aL[14]:=				  "|-------------+--------------------------------------+----+--------------+------------------+------------------+-------------------|"
	aL[15]:=				  "|#############| #####################################| ## |##############|##################|##################|###################|"
Else
	aL[11]:=STR0028//"|                                                    |    |              |                        VALORES                          |"
	aL[12]:=STR0026//"|                                                    |    |              |-------------------------------------+-------------------|"
	aL[13]:=STR0027//"|                   DESCRICAO                        |UNID|  QUANTIDADE  |     UNITARIO     |     PARCIAL      |      TOTAL        |"
	aL[14]:=			  "|----------------------------------------------------+----+--------------+------------------+------------------+-------------------|"
	aL[15]:=			  "| # ################################################ | ## |##############|##################|##################|###################|"
EndIf
aL[16]:=				  "+----------------------------------------------------------------------------------------------------------------------------------+"

//		 			      123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123
//    	            1         2         3         4         5         6         7         8         9         10        11        12        13
Return (aL)
/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    � R460Imp  � Autor � Juan Jose Pereira     � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Impressao do Modelo P7                                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� lEnd    - variavel que indica se processo foi interrompido 潮�
北�          � wnrel   - nome do arquivo a ser impresso                   潮�
北�          � cString - tabela sobre a qual o filtro do relatorio sera   潮�
北�          � executado                                                  潮�
北�          � tamanho - tamanho configurado para o relatorio             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  � Nenhum                                                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � MATR460                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function R460Imp(lEnd,wnRel,cString,tamanho, cNomFilial)
Static lCalcUni := Nil

Local cArqTemp  := ""
Local cIndTemp1 := ""
Local cIndTemp2 := ""
Local aArqTemp	:= {}
Local aL		:= R460LayOut()
Local nLin		:= 80
Local nPagina	:= nPagIni
Local aTotal	:= {}
Local lEmBranco	:= .F.
Local nPos      := 0
Local lImpSit, lImpTipo
Local lImpResumo:= .F.
Local lImpAliq	:= .F.
Local cPosIpi	:= ""
Local aImp		:= {}
Local nTotIpi	:= 0
Local cQuery 	:= ''
Local cChave 	:= ''
Local cKeyInd	:= ''
Local cLeft     := ''
Local lQuery	:= .F.
Local lCusFIFO	:= SuperGetMV("MV_CUSFIFO",.F.,.F.)                                                          	
Local cLocTerc	:= SuperGetMV("MV_ALMTERC",.F.,"")
Local lFirst	:= .T.
Local aSalAtu	:= {}
Local nX		:= 0
Local aSaldo	:= {0,0}
Local cAliasTop := 'SB2'
Local aCampos   := {}
Local lAgregOP  := SB1->(FieldPos("B1_AGREGCU")) > 0 

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Quantidade e custo na 1a moeda para movimentos do SD3 com D3_CF RE9 ou DE9 |
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local aDadosCF9 := {0,0}

Local cSeekUnif   := ""
Local aSeek       := {}
Local nValTotUnif := 0
Local nQtdTotUnif := 0

Private aSaldoTerD := {}
Private aSaldoTerT := {}
Private cIndSB6    := ""
Private nIndSB6	   := 0
Private cKeyQbr    := ''
Private m_pag 	   := 1  // Controla impressao manual do cabecalho 

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� A460UNIT - Ponto de Entrada utilizado para regravar os campos :            |
//|            TOTAL, VALOR_UNIT e QUANTIDADE                                  |
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
lCalcUni := If(lCalcUni == Nil, ExistBlock("A460UNIT"),lCalcUni)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Cria Arquivo Temporario                                                    �
//� SITUACAO: 1=ESTOQUE,2=PROCESSO,3=SEM SALDO,4=DE TERCEIROS,5=EM TERCEIROS,  �
//�           6=DE TERCEIROS USADO EM ORDENS DE PRODUCAO                       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
AADD(aArqTemp,{"SITUACAO"	,"C",01,0})
AADD(aArqTemp,{"TIPO"		,"C",02,0})
AADD(aArqTemp,{"POSIPI"		,"C",10,0})
AADD(aArqTemp,{"PRODUTO"	,"C",15,0})
AADD(aArqTemp,{"DESCRICAO"	,"C",35,0})
AADD(aArqTemp,{"UM"			,"C",02,0})
AADD(aArqTemp,{"QUANTIDADE"	,"N",14,TamSX3("B2_QFIM")[2]})
AADD(aArqTemp,{"VALOR_UNIT"	,"N",21,nDecVal})
AADD(aArqTemp,{"TOTAL"		,"N",21,nDecVal})
If nQuebraAliq <> 1
	AADD(aArqTemp,{"ALIQ"	,"N",5,2})
EndIf

//-- Chave do Arquivo de Trabalho
If nQuebraAliq == 1
	cKeyInd:= "SITUACAO+TIPO+POSIPI+PRODUTO"
Else
	cKeyInd:= "SITUACAO+TIPO+STR(ALIQ,5,2)+PRODUTO"
EndIf	

//-- Cria Indice de Trabalho para Poder de Terceiros
#IFNDEF TOP
	If lSaldTerceir
		dbSelectArea("SB6")
		cIndSB6:=Substr(CriaTrab(Nil,.F.),1,7)+"T"
		cChave := "B6_FILIAL+B6_PRODUTO+B6_TIPO+DTOS(B6_DTDIGIT)"
		cQuery := 'DtoS(B6_DTDIGIT)<="'+DtoS(mv_par14)+'".And.B6_PRODUTO>="'+mv_par05+'".And.B6_PRODUTO<="'+mv_par06+'".And.B6_LOCAL>="'+cAlmoxIni+'".And.B6_LOCAL<="'+cAlmoxFim+'"'
		IndRegua("SB6",cIndSB6,cChave,,cQuery,STR0013)		//"Selecionando Poder Terceiros..."
		nIndSB6:=RetIndex("SB6")
		dbSetIndex(cIndSB6+OrdBagExt())
		dbSetOrder(nIndSB6 + 1)
		dbGoTop()
	EndIf
#ENDIF

//-- Cria Arquivo de Trabalho
cArqTemp :=CriaTrab(aArqTemp)
cIndTemp1:=Substr(CriaTrab(NIL,.F.),1,7)+"1"
cIndTemp2:=Substr(CriaTrab(NIL,.F.),1,7)+"2"

dbUseArea(.T.,,cArqTemp,cArqTemp,.T.,.F.)
IndRegua(cArqTemp,cIndTemp1,cKeyInd,,,STR0014)				//"Indice Tempor爎io..."
IndRegua(cArqTemp,cIndTemp2,"PRODUTO+SITUACAO",,,STR0014)	//"Indice Tempor爎io..."

Set Cursor Off
DbClearIndex()
DbSetIndex(cIndTemp1+OrdBagExt())
DbSetIndex(cIndTemp2+OrdBagExt())

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Alimenta Arquivo de Trabalho                                 �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
#IFDEF TOP
	cAliasTop := CriaTrab(Nil,.F.)
	lQuery    := .T.                                            
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Tratamento especial feito para ORACLE versao 8 ou inferior, pois nestas  |
	//| versoes, nao sao aceitas clausulas como 'LEFT JOIN', 'JOIN', etc ...     |
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If ( Upper(TcGetDB()) == "ORACLE" .And. GetOracleVersion() <= 8 )
		cLeft := ""
		If mv_par07 == 1 // Lista produtos sem movimentacao
		   cLeft := "(+)"
		EndIf		 

		cQuery := "SELECT "
		cQuery += "SB1.B1_FILIAL, "
		cQuery += "SB1.B1_COD, "
		cQuery += "SB1.B1_TIPO, "
		cQuery += "SB1.B1_POSIPI, "
		cQuery += "SB1.B1_DESC, "
		cQuery += "SB1.B1_UM, "
		cQuery += "SB1.B1_PICM, "
		cQuery += "SB2.B2_LOCAL, "
	    cQuery += IIf(lAgregOP,"SB1.B1_AGREGCU, ","")
		cQuery += A285QryFil("SB1",cQuery,aReturn[7])
		cQuery += "SB2.B2_COD "
		
		cQuery += "FROM " + RetSqlName("SB1") + " SB1, "                   
		cQuery +=  RetSqlName("SB2") + " SB2 "                   
	
		cQuery += "WHERE SB1.B1_COD >= '"  + mv_par05 +"' AND SB1.B1_COD <= '"  +mv_par06+"' ""
		cQuery += "AND SB1.B1_FILIAL = '" + xFilial("SB1") +"' AND SB2.B2_FILIAL" + cLeft + " = '"+xFilial("SB2")+"' "
		cQuery += "AND SB1.B1_COD >= '" + mv_par05 + "' AND SB1.B1_COD <= '"  + mv_par06 +"' "
		cQuery += "AND SB2.B2_LOCAL" + cLeft + " >= '"+ cAlmoxIni +"' AND SB2.B2_LOCAL" + cLeft + "  <= '"+ cAlmoxFim +"' "
		cQuery += "AND SB1.B1_COD = SB2.B2_COD" + cLeft + " AND SB1.D_E_L_E_T_ = ' ' AND SB2.D_E_L_E_T_ = ' ' "

		cQuery += "ORDER BY 1,2,8"	//FILIAL+PRODUTO+LOCAL

	Else

		cQuery := "SELECT "
		cQuery += "SB1.B1_FILIAL, "
		cQuery += "SB1.B1_COD, "
		cQuery += "SB1.B1_TIPO, "
		cQuery += "SB1.B1_POSIPI, "
		cQuery += "SB1.B1_DESC, "
		cQuery += "SB1.B1_UM, "
		cQuery += "SB1.B1_PICM, "
		cQuery += "SB2.B2_LOCAL, "
	    cQuery += IIf(lAgregOP,"SB1.B1_AGREGCU, ","")
		cQuery += A285QryFil("SB1",cQuery,aReturn[7])
		cQuery += "SB2.B2_COD "
		cQuery += "FROM " + RetSqlName("SB1") + " SB1 "
		cQuery += IIf(mv_par07==1,"LEFT","")+" JOIN " + RetSqlName("SB2") + " SB2 ON "
		cQuery += "SB1.B1_FILIAL = '"     + xFilial("SB1")+"' "
		cQuery += "AND SB2.B2_FILIAL = '" + xFilial("SB2")+"' "
		cQuery += "AND SB1.B1_COD = SB2.B2_COD "
		cQuery += "AND SB1.B1_COD >= '"   + mv_par05  + "' "
		cQuery += "AND SB1.B1_COD <= '"   + mv_par06  + "' "
		cQuery += "AND SB2.B2_LOCAL >= '" + cAlmoxIni + "' "
		cQuery += "AND SB2.B2_LOCAL <= '" + cAlmoxFim + "' "
		cQuery += "AND SB2.D_E_L_E_T_ = ' ' "
		cQuery += "WHERE SB1.B1_FILIAL = '" + xFilial("SB1")+"' AND SB1.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY 1,2,8"	//FILIAL+PRODUTO+LOCAL
	EndIf	

	cQuery := ChangeQuery(cQuery)
	MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasTop,.F.,.T.)},STR0033)

	dbSelectArea(cAliasTop)	
	SetRegua( SB1->(LastRec()) )
	dbGoTop()
#ELSE
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1") + mv_par05, .T.)
	SetRegua(LastRec())
#ENDIF

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Processando Arquivo de Trabalho                                            |
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
While !EOF() .And. !lEnd .And. If(lQuery,.T.,xFilial("SB1")==SB1->B1_FILIAL)

	IncRegua()

	If Interrupcao(@lEnd)
		Exit
	EndIf

	// aCampos - Array utilizado como tabela auxiliar SB1
	If lQuery
		aCampos:= {	(cAliasTop)->B1_FILIAL,;					//01 - FILIAL
					(cAliasTop)->B1_COD,;						//02 - PRODUTO
					(cAliasTop)->B1_TIPO,;						//03 - TIPO
					(cAliasTop)->B1_POSIPI,;					//04 - POSIPI
					(cAliasTop)->B1_DESC,;						//05 - DESCRICAO
					(cAliasTop)->B1_UM,;						//06 - UM
					(cAliasTop)->B1_PICM,;						//07 - PICM
					IIf(lAgregOp,(cAliasTop)->B1_AGREGCU,"") }	//08 - AGREGCU 
	EndIf

	// Avalia se o Produto nao entrara no processamento
	If !Empty(mv_par06) .And. B1_COD > mv_par06
		Exit
	EndIf

	// Avalia se o Produto nao entrara no processamento
	If !R460AvalProd(B1_COD)
		dbSkip()
		Loop
	EndIf

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Validacao do Filtro de Usuario                               |
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If !Empty(aReturn[7])
		If !&(aReturn[7])
			dbSkip()
			Loop
		EndIf	
	EndIf

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Alimenta Array com Saldo D = De Terceiros/ T = Em Terceiros  �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If lSaldTerceir
		aSaldoTerD   := SaldoTerc(If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),cAlmoxIni,"D",dDtFech,cAlmoxFim,,If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),lSaldTerceir,lCusFIFO)
		aSaldoTerT   := SaldoTerc(If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),cAlmoxIni,"T",dDtFech,cAlmoxFim,,If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),lSaldTerceir,lCusFIFO)
	EndIf

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Busca Saldo em Estoque  					                 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	lFirst	  := .T.
	aSalAtu	  := {}
	aSaldo    := {0,0}

	If !lQuery
		dbSelectArea("SB2")
		dbSeek(xFilial("SB2")+SB1->B1_COD+If(Empty(cAlmoxIni), "", cAlmoxIni),.T.)
	EndIf

	If If(lQuery, Empty((cAliasTop)->B2_COD) , EOF() .Or. !(SB1->B1_COD == SB2->B2_COD))

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Lista produtos sem movimentacao de estoque                   �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If lListProdMov
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� TIPO 3 - SEM SALDO                                       �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea(cArqTemp)
			RecLock(cArqTemp,.T.)
			Replace SITUACAO	with "3" 
			Replace TIPO		with If(lQuery,aCampos[3],SB1->B1_TIPO)		
			Replace PRODUTO		with If(lQuery,aCampos[2],SB1->B1_COD)
			Replace POSIPI		with If(lQuery,aCampos[4],SB1->B1_POSIPI)
			Replace DESCRICAO	with If(lQuery,aCampos[5],SB1->B1_DESC)
			Replace UM		   	with If(lQuery,aCampos[6],SB1->B1_UM)
			If nQuebraAliq <> 1
				If nQuebraAliq == 2
					Replace ALIQ with If(lQuery,aCampos[7],SB1->B1_PICM)
				Else
					Replace ALIQ with IIf(SB0->(MsSeek(xFilial("SB0")+If(lQuery,aCampos[2],SB1->B1_COD))),SB0->B0_ALIQRED,0)
				EndIf
			EndIf
			MsUnLock()
		EndIf
		If lQuery
			dbSelectArea(cAliasTop)
			dbSkip()
		EndIf
	Else
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Lista produtos com movimentacao de estoque                   �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		While !EOF() .And. !lEnd .And. If(lQuery,(cAliasTop)->B2_COD == aCampos[2],SB2->B2_FILIAL==xFilial("SB2") .And. SB2->B2_COD==SB1->B1_COD .And. SB2->B2_LOCAL <= cAlmoxFim)

			If !lQuery
				If !R460Local(SB2->B2_LOCAL)
					dbSkip()
					Loop
				EndIf
			EndIf

			If Interrupcao(@lEnd)
				Exit
			EndIf

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Desconsidera almoxarifado de saldo em processo de material   �
			//� indireto ou saldo em armazem de terceiros                    �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If (cAliasTop)->B2_LOCAL==GetMv("MV_LOCPROC") .Or. (cAliasTop)->B2_LOCAL $ cLocTerc
				dbSkip()
				Loop
			EndIf

			If lListCustMed .Or. (!lListCustMed .And. !lCusfifo)
				aSalatu:=CalcEst(If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech+1,Nil)
			Else
				aSalAtu:=CalcEstFF(If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech+1,Nil)	
			EndIf

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� TIPO 1 - EM ESTOQUE                                      �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea(cArqTemp)
			dbSetOrder(2)
			If dbSeek(If(lQuery,aCampos[2],SB1->B1_COD)+"1")
				RecLock(cArqTemp,.F.)
			Else
				RecLock(cArqTemp,.T.)
				lFirst:=.F.
				Replace SITUACAO	With "1"
				Replace TIPO		With If(lQuery,aCampos[3],SB1->B1_TIPO)
				Replace POSIPI		With If(lQuery,aCampos[4],SB1->B1_POSIPI)
				Replace PRODUTO		With If(lQuery,aCampos[2],SB1->B1_COD)
				Replace DESCRICAO	With If(lQuery,aCampos[5],SB1->B1_DESC)
				Replace UM			With If(lQuery,aCampos[6],SB1->B1_UM)
				If nQuebraAliq <> 1
					If nQuebraAliq == 2
						Replace ALIQ With If(lQuery,aCampos[7],SB1->B1_PICM)
					Else
						Replace ALIQ With IIf(SB0->(MsSeek(xFilial("SB0")+If(lQuery,aCampos[2],SB1->B1_COD))),SB0->B0_ALIQRED,0)
					EndIf
				EndIf
			EndIf
			Replace QUANTIDADE   	With QUANTIDADE+aSalAtu[01]
			Replace TOTAL		    With TOTAL+aSalAtu[02]
			If aSalAtu[1]>0
				Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
			EndIf

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
			If lCalcUni
				ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
			EndIf
			
			MsUnLock()
			dbSelectArea(cAliasTop)
			dbSkip()
		EndDo

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		//� Pesquisa valores de materiais de terceiros requisitados para OP / TIPO 6  �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
		aDadosCF9 := {0,0}

		If lAgregOP .And. If(lQuery,aCampos[8] == "1",SB1->B1_AGREGCU == "1")
			aDadosCF9:=SaldoD3CF9(If(lQuery,aCampos[2],SB1->B1_COD),NIL,mv_par14,cAlmoxIni,cAlmoxFim)				
			If (QtdComp(aDadosCF9[1]) > QtdComp(0)) .Or. (QtdComp(aDadosCF9[2]) > QtdComp(0))
				dbSelectArea(cArqTemp)
				dbSetOrder(2)
				If dbSeek(If(lQuery,aCampos[2],SB1->B1_COD)+"6")
					RecLock(cArqTemp,.F.)
				Else
					RecLock(cArqTemp,.T.)
					lFirst:=.F.
					Replace SITUACAO	with "6"
					Replace TIPO		with If(lQuery,aCampos[3],SB1->B1_TIPO)
					Replace POSIPI		with If(lQuery,aCampos[4],SB1->B1_POSIPI)
					Replace PRODUTO		with If(lQuery,aCampos[2],SB1->B1_COD)
					Replace DESCRICAO	with If(lQuery,aCampos[5],SB1->B1_DESC)
					Replace UM			with If(lQuery,aCampos[6],SB1->B1_UM)
					If nQuebraAliq <> 1
						If nQuebraAliq == 2
							Replace ALIQ with If(lQuery,aCampos[7],SB1->B1_PICM)
						Else
							Replace ALIQ with IIf(SB0->(MsSeek(xFilial("SB0")+If(lQuery,aCampos[2],SB1->B1_COD))),SB0->B0_ALIQRED,0)
						EndIf
					EndIf
				EndIf
				Replace QUANTIDADE 	With aDadosCF9[1]
				Replace TOTAL		With aDadosCF9[2]
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� Recalcula valor unitario                                                  �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
				If QUANTIDADE>0
					Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
				If lCalcUni
					ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
				EndIf
				MsUnLock()				                 				
			EndIf
		EndIf

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		//� Tratamento de poder de terceiros                                          �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
		If lSaldTerceir .And. If(lQuery,.T.,SB1->B1_FILIAL==xFilial("SB1"))
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� Pesquisa os valores D = De Terceiros na array aSaldoTerD                  �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
			nX := aScan(aSaldoTerD,{|x| x[1] == xFilial("SB6")+If(lQuery,aCampos[2],SB1->B1_COD)})
			If !(nX == 0)
				aSaldo[1] := aSaldoTerD[nX][3]
				aSaldo[2] := aSaldoTerD[nX][4]
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� Manipula arquivo de trabalho subtraindo do saldo em estoque saldo de terceiros      �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
			dbSelectArea(cArqTemp)
			dbSetOrder(2)
			If dbSeek(If(lQuery,aCampos[2],SB1->B1_COD)+"1")
				RecLock(cArqTemp,.F.)
			Else
				RecLock(cArqTemp,.T.)
				lFirst:=.F.
				Replace SITUACAO	with "1"
				Replace TIPO		with If(lQuery,aCampos[3],SB1->B1_TIPO)
				Replace POSIPI		with If(lQuery,aCampos[4],SB1->B1_POSIPI)
				Replace PRODUTO		with If(lQuery,aCampos[2],SB1->B1_COD)
				Replace DESCRICAO	with If(lQuery,aCampos[5],SB1->B1_DESC)
				Replace UM			with If(lQuery,aCampos[6],SB1->B1_UM)
				If nQuebraAliq <> 1
					If nQuebraAliq == 2
						Replace ALIQ with If(lQuery,aCampos[7],SB1->B1_PICM)
					Else
						Replace ALIQ with IIf(SB0->(MsSeek(xFilial("SB0")+If(lQuery,aCampos[2],SB1->B1_COD))),SB0->B0_ALIQRED,0)
					EndIf
				EndIf
			EndIf
			Replace QUANTIDADE 	With QUANTIDADE-aSaldo[01]
			Replace TOTAL		With TOTAL-aSaldo[02]
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� Pesquisa os valores de material de terceiros requisitados para OP         �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
			If lAgregOP .And. If(lQuery,aCampos[8] == "1",SB1->B1_AGREGCU == "1")
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� Desconsidera do calculo do saldo em estoque movimentos RE9 e DE9          �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
				If (QtdComp(aDadosCF9[1]) > QtdComp(0)) .Or. (QtdComp(aDadosCF9[2]) > QtdComp(0))
					Replace QUANTIDADE 	With QUANTIDADE+aDadosCF9[1]
					Replace TOTAL		With TOTAL+aDadosCF9[2]
				EndIf
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� Recalcula valor unitario                                                  �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
			If QUANTIDADE>0
				Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
			EndIf
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
			If lCalcUni
				ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
			EndIf
			MsUnLock()
		EndIf
	EndIf

	If !lQuery
		dbSelectArea("SB1")
	EndIf

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//� Processa Saldo De Terceiro TIPO 4 - SALDO DE TERCEIROS                    �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
	R460Terceiros(@lEnd,cArqTemp,"4",lQuery,aCampos,aDadosCF9)

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//� Processa Saldo Em Terceiro TIPO 5 - SALDO EM TERCEIROS                    �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
	R460Terceiros(@lEnd,cArqTemp,"5",lQuery,aCampos,NIL)

	If lQuery
		dbSelectArea(cAliasTop)
	Else
		dbSelectArea("SB1")
		dbSkip()
	EndIf
	
EndDo

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Processa Saldo Em Processo TIPO 2 - SALDO EM PROCESSO                     �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
If lSaldProcess
	XR460EmProcesso(@lEnd,cArqTemp,Nil,cProdIni,cProdFim,cAlmoxIni,cAlmoxFim,mv_par20==1,dDtFech,lCalcProcDt,nQuebraAliq,lListCustMed)
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� CUSTO UNIFICADO - Realiza acerto dos valores para todos tipos             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
If lCusUnif
	dbSelectArea(cArqTemp)
	dbSetOrder(2)
	dbGotop()
	SetRegua(LastRec())
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Percorre arquivo de Trabalho                                 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	While !Eof()
		cSeekUnif  :=PRODUTO
		aSeek      :={}
		nValTotUnif:=0
		nQtdTotUnif:=0
		While !Eof() .And. cSeekUnif == PRODUTO

  			IncRegua()

			If (!lListProdNeg .And. QUANTIDADE<0) .Or. (!lListProdZer .And. QUANTIDADE==0) .Or. (!lListCustZer .And. TOTAL==0)
				dbSkip()
				Loop
    		EndIf
  			AADD(aSeek,Recno())
			nValTotUnif+=TOTAL
			nQtdTotUnif+=QUANTIDADE
			dbSkip()
		End                           
		If Len(aSeek) > 0
			// Calcula novo valor unitario
		  	For nx:=1 to Len(aSeek)
				dbGoto(aSeek[nx])
				Reclock(cArqTemp,.F.)
				Replace VALOR_UNIT With NoRound(nValTotUnif/nQtdTotUnif,nDecVal)
				Replace TOTAL      With QUANTIDADE*(nValTotUnif/nQtdTotUnif)
				MsUnlock()
			Next nx 
			dbSkip()
		EndIf
	End
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Imprime Modelo P7                                            �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
dbSelectArea(cArqTemp)
dbSetOrder(1)
dbGotop()
SetRegua(LastRec())

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Flags de Impressao                                           �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
cSitAnt	:="X"
aSituacao:={STR0015,STR0016,STR0017,STR0018,STR0019,STR0034}		//" EM ESTOQUE "###" EM PROCESSO "###" SEM MOVIMENTACAO "###" DE TERCEIROS "###" EM TERCEIROS "
cTipoAnt:="XX"
cQuebra := ""

If lImpSX1
	XImpListSX1(STR0001,"MATR460",Tamanho,,.T.)
EndIf	

While !Eof()

	nLin    := 80
	cSitAnt := SITUACAO
	lImpSit := .T.

	While !Eof() .And. cSitAnt == SITUACAO

		cTipoAnt := TIPO
		lImpTipo := .T.

		While !Eof() .And. cSitAnt+cTipoAnt == SITUACAO+TIPO

			cPosIpi:=POSIPI
			nTotIpi:=0
			If nQuebraAliq <> 1
				nAliq    := ALIQ
				lImpAliq := .T.
			EndIf	
			cQuebra := IIf( nQuebraAliq == 1,cSitAnt+cTipoAnt+cPosIpi,cSitAnt+cTipoAnt+Str(nAliq,5,2))
			cKeyQbr := IIf( nQuebraAliq == 1,'SITUACAO+TIPO+POSIPI','SITUACAO+TIPO+Str(ALIQ,5,2)')

			While !Eof() .And. cQuebra==&(cKeyQbr)

				IncRegua()

				If Interrupcao(@lEnd)
					Exit
				EndIf

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Controla impressao de Produtos com saldo negativo ou zerado  �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If (!lListProdNeg .And. QUANTIDADE<0) .Or. (!lListProdZer .And. QUANTIDADE==0) .Or. (!lListCustZer .And. TOTAL==0)
					dbSkip()
					Loop
				Else
					nTotIpi+=TOTAL
					R460Acumula(aTotal)
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� Inicializa array com itens de impressao de acordo com MV_PAR15  �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�

				If lDescrNormal
					aImp:={	Alltrim(POSIPI),;
							DESCRICAO,;
							UM,;
							Transform(QUANTIDADE,PesqPict("SB2", "B2_QFIM",14)),;
							Transform(NoRound(TOTAL/QUANTIDADE,nDecVal),PesqPict("SB2", "B2_CM1",18)),;
							Transform(TOTAL,"@E 999,999,999,999.99" ),;
							Nil}
				Else
					aImp:={	Alltrim(POSIPI),;
							Padr(Alltrim(PRODUTO)+" - "+DESCRICAO,35),;
							UM,;
							Transform(QUANTIDADE,PesqPict("SB2", "B2_QFIM",14)),;
							Transform(NoRound(TOTAL/QUANTIDADE,nDecVal),PesqPict("SB2", "B2_CM1",18)),;
							Transform(TOTAL,"@E 999,999,999,999.99"),;
							Nil}
				EndIf
				dbSelectArea(cArqTemp)
				dbSkip()

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� Salta registros Zerados ou Negativos Conforme Parametros        �
				//� Necessario Ajustar Posicao p/ Totalizacao de Grupos (POSIPI)    �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				While !Eof() .And. ((!lListProdNeg.And.QUANTIDADE<0).Or.(!lListProdZer.And.QUANTIDADE==0).Or.(!lListCustZer.And.TOTAL==0))
					dbSkip()
				EndDo
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Verifica se imprime total por POSIPI.                        �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If !(cSitAnt+cTipoAnt+cPosIpi==SITUACAO+TIPO+POSIPI) .And. nQuebraAliq == 1
					aImp[07] := Transform(nTotIPI,"@E 999,999,999,999.99")
				EndIf
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Imprime cabecalho                                            �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If nLin>55
					R460Cabec( @nLin, @nPagina, .F., Nil, cNomFilial )
				EndIf

				If lImpSit
					FmtLin({"",Padc(aSituacao[Val(cSitAnt)],35,"*"),"","","","",""},aL[15],,,@nLin)
					lImpSit := .F.
				EndIf

				If lImpTipo
					SX5->(dbSeek(xFilial("SX5")+"02"+cTipoAnt))
					FmtLin(Array(7),aL[15],,,@nLin)
					FmtLin({"",Padc(" "+Trim(X5Descri())+" ",35,"*"),"","","","",""},aL[15],,,@nLin)
					FmtLin(Array(7),aL[15],,,@nLin)
					lImpTipo := .F.
				EndIf
				If nQuebraAliq <> 1
					If lImpAliq
						FmtLin({"",Padc(" "+STR0031+Transform(nAliq,"@E 99.99%")+" ",35,"*"),"","","","",""},aL[15],,,@nLin)
						FmtLin(Array(7),aL[15],,,@nLin)
						lImpAliq := .F.
					EndIf	
				EndIf	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Imprime linhas de detalhe de acordo com parametro (mv_par15) �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				FmtLin(aImp,aL[15],,,@nLin)

				If nQuebraAliq <> 1 .And. cQuebra <> &(cKeyQbr)
					FmtLin(Array(7),aL[15],,,@nLin)
					nPos:=Ascan(aTotal,{|x|x[1]==cSitAnt.And.x[2]==cTipoAnt.And.x[6]==nAliq})
					FmtLin({,STR0021+STR0031+Transform(nAliq,"@E 99.99%")+" ===>",,,,,Transform(aTotal[nPos,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)			//"TOTAL "
					FmtLin(Array(7),aL[15],,,@nLin)
				EndIf

				If nLin>=55
					R460EmBranco(@nLin)
				EndIf
			End
		End
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Impressao de Totais                                          �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		nPos := Ascan(aTotal,{|x|x[1]==cSitAnt.And.x[2]==cTipoAnt})
		If nPos # 0
			If nLin>55
				R460Cabec( @nLin, @nPagina, .F., Nil, cNomFilial )
			EndIf
			R460Total( @nLin, aTotal, cSitAnt, cTipoAnt, aSituacao, @nPagina, .F., Nil, cNomFilial )
		EndIf
	End

	nPos := Ascan(aTotal,{|x|x[1]==cSitAnt .And. x[2]==TT})
	If nPos # 0
		R460Total( @nLin, aTotal, cSitAnt, TT, aSituacao, @nPagina, .F., Nil, cNomFilial )
		R460EmBranco(@nLin)
		lImpResumo:=.T.
	EndIf
End

R460Cabec( @nLin, @nPagina, .F., Nil, cNomFilial )

If lImpResumo
	R460Total( @nLin, aTotal, "T", TT, aSituacao, @nPagina, .F., Nil, cNomFilial )
Else
	R460SemEst(@nLin,@nPagina)
EndIf

R460EmBranco(@nLin)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Apaga Arquivos Temporarios                                   �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
dbSelectArea(cArqTemp)
dbCloseArea()
Ferase(cArqTemp+GetDBExtension())
Ferase(cIndTemp1+OrdBagExt())
Ferase(cIndTemp2+OrdBagExt())

If lQuery
	dbSelectArea(cAliasTop)
	dbCloseArea()
EndIf

If lSaldTerceir
	#IFNDEF TOP
		dbSelectArea("SB6")
		RetIndex("SB6")
		dbClearFilter()
		Ferase(cIndSB6+OrdBagExt())
	#ENDIF
EndIf

	
Return Nil

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    � R460Term � Autor � Juan Jose Pereira     � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矷mpressao dos Termos de Abertura e Encerramento do Modelo P7潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� lEnd    - variavel que indica se processo foi interrompido 潮�
北�          � wnrel   - nome do arquivo a ser impresso                   潮�
北�          � cString - tabela sobre a qual o filtro do relatorio sera   潮�
北�          � executado                                                  潮�
北�          � tamanho - tamanho configurado para o relatorio             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  � Nenhum                                                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � MATR460                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function R460Term(lEnd,wnRel,cString,Tamanho)

Local cArqAbert, cArqEncer,aDriver:=ReadDriver()
Local aAreaSM0 := SM0->(GetArea())

cArqAbert:=GetMv("MV_LMOD7AB")
cArqEncer:=GetMv("MV_LMOD7EN")

dbSelectArea("SM0")
dbSetOrder(1)
dbSeek(cEmpAnt+cFilAnt)

XFIS_IMPTERM(cArqAbert,cArqEncer,cPerg,IIF(aReturn[4] == 1, aDriver[3],aDriver[4]))

RestArea(aAreaSM0)	
Return Nil

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪穆哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    砇460Terceiros  矨utor矹uan Jose Pereira   � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪牧哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矪usca Saldo em poder de Terceiros (T) ou de Terceiros (D)   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� lEnd    - variavel que indica se processo foi interrompido 潮�
北�          � cArqTemp- nome do arquivo de trabalho criado para impressao潮�
北�          � do relatorio                                               潮�
北�          � cEmdeTerc-String indicando se esta processando saldo de    潮�
北�          � terceiros ou saldo em terceiros                            潮�
北�          � executado                                                  潮�
北�          � lQuery - Indica se esta processando com query ou nao       潮�
北�          � aCampos- Array com os dados do cursor posicionado quando   潮�
北�          � utiliza query                                              潮�
北�          � aDadosCF9- Array com informacaoes relacionadas a movimentos潮�
北�          � internos RE9/DE9                                           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  � Nenhum                                                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � MATR460                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function R460Terceiros(lEnd,cArqTemp,cEmDeTerc,lQuery,aCampos,aDadosCF9)
Local aSaldo  	:= {0,0}
Local nX	  	:= 0
Local lCusFifo	:= SuperGetMV("MV_CUSFIFO",.F.,.F.)                                                          	
Local cLocTerc	:= SuperGetMv("MV_ALMTERC",.F.,"")
Local aSalAtu 	:= {}
Local cAlmTerc	:= ""

Default lQuery    := .F.
Default aCampos   := {}   
Default aDadosCF9 := {0,0} // Quantidade e custo na 1a moeda para movimentos do SD3 com D3_CF RE9 ou DE9

If lSaldTerceir .And. !lEnd .And. If(lQuery,.T.,SB1->B1_FILIAL==xFilial("SB1"))
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//� Pesquisa os valores D == De Terceiros / T == Em Terceiros                 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
	nX := aScan(If(cEmDeTerc=="4",aSaldoTerD,aSaldoTerT),{|x| x[1] == xFilial("SB6")+If(lQuery,aCampos[2],SB1->B1_COD)})
	If !(nX == 0)
		aSaldo[1] := If(cEmDeTerc=="4",aSaldoTerD[nX][3],aSaldoTerT[nX][3])
		aSaldo[2] := If(cEmDeTerc=="4",aSaldoTerD[nX][4],aSaldoTerT[nX][4])
	EndIf
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//� Considera o saldo do armazem do parametro como saldo em terceiros         �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	If !Empty(cLocTerc) .And. cEmDeTerc == "5"
		While !Empty(cLocTerc)
			cAlmTerc := SubStr(cLocTerc,1,At("/",cLocTerc)-1)
			cLocTerc := SubStr(cLocTerc,At("/",cLocTerc)+1)
			If !Empty(cAlmTerc)
				If lCusFifo
					aSalatu:=CalcEstFF(If(lQuery,aCampos[2],SB1->B1_COD),cAlmTerc,dDtFech+1,Nil)
				Else
					aSalatu:=CalcEst(If(lQuery,aCampos[2],SB1->B1_COD),cAlmTerc,dDtFech+1,Nil)		
				EndIf
				aSaldo[1] +=aSalAtu[01]
				aSaldo[2] +=aSalAtu[02]		
			Else
				Exit
			EndIf	
		EndDo
	EndIf
	If aSaldo[1]+aSaldo[2] # 0
		dbSelectArea(cArqTemp)
		dbSetOrder(2)
		If dbSeek(If(lQuery,aCampos[2],SB1->B1_COD)+cEmDeTerc)
			RecLock(cArqTemp,.F.)
		Else
			RecLock(cArqTemp,.T.)
			Replace SITUACAO 	with cEmDeTerc
			Replace TIPO		with If(lQuery,aCampos[3],SB1->B1_TIPO)
			Replace POSIPI		with If(lQuery,aCampos[4],SB1->B1_POSIPI)
			Replace PRODUTO		with If(lQuery,aCampos[2],SB1->B1_COD)
			Replace DESCRICAO	with If(lQuery,aCampos[5],SB1->B1_DESC)
			Replace UM			with If(lQuery,aCampos[6],SB1->B1_UM)
			If nQuebraAliq <> 1
				If nQuebraAliq == 2
					Replace ALIQ with If(lQuery,aCampos[7],SB1->B1_PICM)
				Else
					Replace ALIQ with IIf(SB0->(MsSeek(xFilial("SB0")+If(lQuery,aCampos[2],SB1->B1_COD))),SB0->B0_ALIQRED,0)
				EndIf
			EndIf
		EndIf
		Replace QUANTIDADE	 with QUANTIDADE+aSaldo[01]
		Replace TOTAL		 with TOTAL+aSaldo[02]
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Desconsidera do calculo do saldo do material de terceiros movimentos RE9 e DE9 �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁			
		If (QtdComp(aDadosCF9[1]) > QtdComp(0)) .Or. (QtdComp(aDadosCF9[2]) > QtdComp(0))
			Replace QUANTIDADE	With QUANTIDADE-aDadosCF9[1]
			Replace TOTAL		With TOTAL-aDadosCF9[2]
		EndIf
		If aSaldo[01]>0
			Replace VALOR_UNIT 	with NoRound(TOTAL/QUANTIDADE,nDecVal)
		EndIf
		MsUnLock()
	EndIf
EndIf
Return Nil

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪穆哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    砇460EmProcesso 矨utor矹uan Jose Pereira   � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪牧哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矪usca saldo em Processo                                     潮�
北�          矨tualiza aqruivo de trab. c/ Saldo em Processo dos Produtos.潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� lEnd         - Var. que indica se proc. foi interrompido   潮�
北�          � cArqTemp     - Nome do arquivo de trabalho                 潮�
北�          � lGraph       - Nao atualiza regua de progressao            潮�
北�          � cProdIni     - Produto Inicial                             潮�
北�          � cProdFim     - Produto Final                               潮�
北�          � cAlmoxIni    - Armazem Inicial                             潮�
北�          � cAlmoxFim    - Armazem Final                               潮�
北�          � lModProces   - Considera Mao de Obra em Processo           潮�
北�          � dDtFech      - Data de Fechamento cons. p/ o calculo       潮�
北�          � lCalcProcDt  - Cons. => Dt. Emissao(.T.) / Sec. Calc.(.F.) 潮�
北�          � nQuebraAliq  - Opcao de Quebra por Aliquota                潮�
北�          � (1)Nao Quebra / (2) Icms produto (3) Icms reducao          潮�
北�          � lListCustMed - Lista Custo Medio                           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  � Nenhum                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function XR460EmProcesso(lEnd,cArqTemp,lGraph, cProdIni, cProdFim, cAlmoxIni, cAlmoxFim, lModProces, dDtFech, lCalcProcDt, nQuebraAliq, lListCustMed)
Local aCampos   := {}
Local aEmAnalise:= {}
Local aSalAtu   := {}
Local aProducao := {}
Local cArqTemp2 := ""
Local cArqTemp3 := CriaTrab(Nil,.F.)
Local lCusFIFO  := GetMV("MV_CUSFIFO")
Local lQuery    := .F.
Local lEmProcess:= .F.
Local cAliasTop := "SD3"
Local cAliasSD3 := "SD3"
Local nQtMedia  := 0
Local nQtNeces  := 0
Local nQtde     := 0
Local nCusto    := 0
Local nPos      := 0
Local nX        := 0
#IFDEF TOP
	Local cQuery   := ""
#ELSE
	Local cFiltro   := ""
	Local nIndex    := 0
#ENDIF

Default lModProces   := .F.
Default lGraph       := .F.
Default dDtFech      := CtoD('31/12/49')
Default lCalcProcDt  := .T.
Default nQuebraAliq  := 1
Default lListCustMed := .T.

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� SALDO EM PROCESSO                                            �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If !lEnd
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Cria arquivo de Trabalho para armazenar as OPs               �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	AADD(aCampos,{"OP"		,"C",TamSX3("D3_OP")[1]			,0}) // 01 - OP
	AADD(aCampos,{"SEQCALC"	,"C",TamSX3("D3_SEQCALC")[1]	,0}) // 02 - SEQCALC
	AADD(aCampos,{"DATA1"	,"D",8							,0}) // 03 - DATA1
	cArqTemp2:=CriaTrab(aCampos)

	dbUseArea(.T.,,cArqTemp2,cArqTemp2,.T.,.F.)
	IndRegua(cArqTemp2,cArqTemp2,"OP+SEQCALC+DTOS(DATA1)",,,STR0020)	//"Criando Indice..."

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Busca saldo em processo                                      �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	dbSelectArea("SD3")
	dbSetOrder(1) // D3_FILIAL+D3_OP+D3_COD+D3_LOCAL

	#IFDEF TOP
		cAliasTop := cArqTemp3
		cQuery := "SELECT D3_FILIAL, D3_OP, D3_COD, D3_LOCAL, D3_CF, D3_EMISSAO, D3_SEQCALC "
		cQuery += "FROM "+RetSqlName("SD3")+" SD3 "
		cQuery += "WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' "
		cQuery += "AND SD3.D3_OP <> '" + Criavar("D3_OP",.F.)+ "' "
		cQuery += "AND (SD3.D3_CF ='PR0' OR SD3.D3_CF = 'PR1') "
		cQuery += "AND SD3.D3_EMISSAO <= '" + DTOS(dDtFech) + "' "
		cQuery += "AND SD3.D3_ESTORNO = ' ' "
		cQuery += "AND SD3.D_E_L_E_T_ = ' ' 
		cQuery += "UNION "
		cQuery += "SELECT D3_FILIAL, D3_OP, D3_COD, D3_LOCAL, D3_CF, D3_EMISSAO, D3_SEQCALC "
		cQuery += "FROM "+RetSqlName("SD3")+" SD3 "
		cQuery += "WHERE SD3.D3_FILIAL='" + xFilial("SD3") + "' "
		cQuery += "AND SD3.D3_OP <> '" + Criavar("D3_OP",.F.) + "' "
		cQuery += "AND SD3.D3_COD >= '"+cProdIni+"' "
		cQuery += "AND SD3.D3_COD <= '"+cProdFim+"' "
		cQuery += "AND SD3.D3_CF <>'PR0' AND SD3.D3_CF <>'PR1' "
		cQuery += "AND SD3.D3_EMISSAO <= '" + DTOS(dDtFech) + "' "
		cQuery += "AND SD3.D3_ESTORNO = ' ' "
		cQuery += "AND SD3.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY "+SqlOrder(SD3->(IndexKey()))
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqTemp3,.T.,.T.)

		TcSetField(cAliasTop,"D3_EMISSAO","D",8,0)
	#ELSE
		cFiltro:="D3_FILIAL == '"+xFilial("SD3")+"' .And. DTOS(D3_EMISSAO) <= '"+DTOS(dDtFech)+"' .And. !Empty(D3_OP) .And. D3_ESTORNO == ' ' "
		IndRegua("SD3",cArqTemp3,SD3->(IndexKey()),,cFiltro,STR0020)		//"Criando Indice..."
		nIndex:=RetIndex("SD3")
		dbSetIndex(cArqTemp3+OrdBagExt())
		dbSetOrder(nIndex+1)
		dbSeek(xFilial("SD3") + cProdIni, .T.)
	#ENDIF

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Armazena OPs e data de emissao no Arquivo de Trabalho        �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	While !Eof() .And. !lEnd

		If Interrupcao(@lEnd)
			Exit
		EndIf

		// Verifica se o Produto e Valido
		If !Empty(cProdFim) .And. (cAliasTop)->D3_COD > cProdFim .And.;
			SubStr((cAliasTop)->D3_CF,1,2) != "PR"
			Exit
		EndIf	

		If ( (cAliasTop)->D3_COD < cProdIni .Or. (cAliasTop)->D3_COD > cProdFim .Or. IIf(lModProces,.T.,IsProdMod(D3_COD)) ) .And. ;
			SubStr((cAliasTop)->D3_CF,1,2) != "PR"
			dbSkip()
			Loop
		EndIf

		//-- Posiciona tabela SC2
		SC2->(dbSetOrder(1))
		If SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)#(xFilial("SC2")+(cAliasTop)->D3_OP)
			SC2->(MsSeek(xFilial("SC2")+(cAliasTop)->D3_OP))
		EndIf

		// Verifica Data de Encerramento da OP
		If !Empty(SC2->C2_DATRF) .And. SC2->C2_DATRF <= dDtFech
			dbSkip()
			Loop
		EndIf

		// Armazena OPs e Data de Emissao
		dbSelectArea(cArqTemp2)
		If dbSeek((cAliasTop)->D3_OP)
			RecLock(cArqTemp2,.F.)
		Else
			RecLock(cArqTemp2,.T.)
			Replace OP with (cAliasTop)->D3_OP
		EndIf
		If SubStr((cAliasTop)->D3_CF,1,2) == "PR"
			Replace DATA1 with Max((cAliasTop)->D3_EMISSAO,DATA1)
			If !lCalcProcDt .And. ((cAliasTop)->D3_SEQCALC > SEQCALC)
				Replace SEQCALC With (cAliasTop)->D3_SEQCALC
			EndIf
		EndIf
		MsUnlock()
		dbSelectArea(cAliasTop)
		dbSkip()
	EndDo

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Restaura ambiente e apaga arquivo temporario                 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	#IFDEF TOP
		dbSelectArea(cAliasTop)
		dbCloseArea()
		dbSelectArea("SD3")
	#ELSE
		dbSelectArea("SD3")
		dbClearFilter()
		RetIndex("SD3")
		Ferase(cArqTemp3+OrdBagExt())
	#ENDIF

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Gravacao do Saldo em Processo                                �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	dbSelectArea(cArqTemp2)
	dbGotop()
	While !Eof() .And. !lEnd

		If Interrupcao(@lEnd)
			Exit
		EndIf

		aProducao := {}
		aEmAnalise:= {}

		dbSelectArea("SD3")
		dbSetOrder(1)
  		#IFDEF TOP
			lQuery    := .T.
			cAliasSD3 := GetNextAlias()
			cQuery := "SELECT SD3.D3_FILIAL, SD3.D3_OP, SD3.D3_COD, SD3.D3_LOCAL, SD3.D3_CF, SD3.D3_EMISSAO, "
			cQuery += "SD3.D3_SEQCALC, SD3.D3_CUSTO1, SD3.D3_SEQCALC, SD3.D3_QUANT, SD3.D3_ESTORNO, SD3.R_E_C_N_O_ RECNOSD3 "
			cQuery += "FROM "+RetSqlName("SD3")+" SD3 "
			cQuery += "WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' "
			cQuery += "AND SD3.D3_OP = '" + (cArqTemp2)->OP + "' "
			cQuery += "AND SD3.D3_ESTORNO = ' ' "
			cQuery += "AND SD3.D_E_L_E_T_ = ' ' "
			cQuery += "ORDER BY " + SqlOrder(SD3->(IndexKey()))

			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD3,.T.,.T.)

			TcSetField(cAliasSD3,"D3_EMISSAO","D",8,0)
			TcSetField(cAliasSD3,"D3_QUANT","N",TamSX3("D3_QUANT")[1],TamSX3("D3_QUANT")[2])
			TcSetField(cAliasSD3,"D3_CUSTO1","N",TamSX3("D3_CUSTO1")[1],TamSX3("D3_CUSTO1")[2])

		#ELSE
			dbSeek(xFilial("SD3")+(cArqTemp2)->OP)
		#ENDIF
		
		If IIf( lQuery, .T. , SD3->(Found()) )

			While !Eof() .And. !lEnd .And. If(lQuery,.T.,(cAliasSD3)->D3_OP==(cArqTemp2)->OP)

				If Interrupcao(@lEnd)
					Exit
				EndIf

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Validacao para nao permitir movimento com a data maior que a data de �
				//| encerramento do relatorio.                                           |  
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁			
				If (cAliasSD3)->D3_EMISSAO > dDtFech .Or. (cAliasSD3)->D3_ESTORNO == "S"
					dbSkip()
					Loop
				EndIf
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Realiza a somatoria de todas as producoes para esta OP               �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁			
				If SubStr((cAliasSD3)->D3_CF,1,2) == "PR"
					nPos:=Ascan(aProducao,{|x|x[1]==(cAliasSD3)->D3_COD})
					If nPos==0
						AADD(aProducao,{(cAliasSD3)->D3_COD,(cAliasSD3)->D3_QUANT,(cAliasSD3)->D3_CUSTO1})
					Else
						aProducao[nPos,2] += (cAliasSD3)->D3_QUANT
						aProducao[nPos,3] += (cAliasSD3)->D3_CUSTO1
					EndIf
				EndIf

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Validacao para o Produto                                             �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁			
				If (cAliasSD3)->D3_COD < cProdIni .Or. (cAliasSD3)->D3_COD > cProdFim .Or.;
					If(lModProces,.T.,IsProdMod((cAliasSD3)->D3_COD))
					dbSkip()
					Loop
				EndIf

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Validacao para o local                                               �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁			
				If (cAliasSD3)->D3_LOCAL < cAlmoxIni .Or. (cAliasSD3)->D3_LOCAL > cAlmoxFim
					dbSkip()
					Loop
				EndIf
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Filtra produtos que nao estao em Processo                            �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If (lCalcProcDt .And. (cAliasSD3)->D3_EMISSAO <= (cArqTemp2)->DATA1) .Or. (!lCalcProcDt .And. (cAliasSD3)->D3_SEQCALC <= (cArqTemp2)->SEQCALC)
				
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					//� Realiza a somatoria de todas as requisicoes que serao analisada para  |
					//| verificar se deverao entrar como saldo em processo ou nao.            �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
					If SubStr((cAliasSD3)->D3_CF,1,2) == "RE"
						nPos:=Ascan(aEmAnalise,{|x|x[1]==(cAliasSD3)->D3_COD})
						If nPos==0
							AADD(aEmAnalise,{(cAliasSD3)->D3_COD,(cAliasSD3)->D3_LOCAL,(cAliasSD3)->D3_QUANT,(cAliasSD3)->D3_CUSTO1,(cAliasSD3)->RECNOSD3})
						Else
							aEmAnalise[nPos,3] += (cAliasSD3)->D3_QUANT
							aEmAnalise[nPos,4] += (cAliasSD3)->D3_CUSTO1
						EndIf
					// Devolucao para OP
					ElseIf SubStr((cAliasSD3)->D3_CF,1,2) == "DE"
						nPos:=Ascan(aEmAnalise,{|x|x[1]==(cAliasSD3)->D3_COD})
						If nPos <> 0
							aEmAnalise[nPos,3] -= (cAliasSD3)->D3_QUANT
							aEmAnalise[nPos,4] -= (cAliasSD3)->D3_CUSTO1
						EndIf
					EndIf
				
                Else
				
					// Posiciona tabela SB1
					If SB1->B1_COD!=(cAliasSD3)->D3_COD
						SB1->(dbSeek(xFilial("SB1")+(cAliasSD3)->D3_COD))
					EndIf
				
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					//� GRAVA SALDO EM PROCESSO                                               �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
					If SB1->B1_COD==(cAliasSD3)->D3_COD
						dbSelectArea(cArqTemp)
						dbSetOrder(2)
						RecLock(cArqTemp,!dbSeek(SB1->B1_COD+"2"))
						Replace SITUACAO 	with "2"
						Replace TIPO		with SB1->B1_TIPO
						Replace POSIPI		with SB1->B1_POSIPI
						Replace PRODUTO		with SB1->B1_COD
						Replace DESCRICAO	with SB1->B1_DESC
						Replace UM			with SB1->B1_UM
						Do Case
							Case Substr((cAliasSD3)->D3_CF,1,2)=="RE"
								Replace QUANTIDADE 	with QUANTIDADE + (cAliasSD3)->D3_QUANT
								Replace TOTAL		with TOTAL 		+ (cAliasSD3)->D3_CUSTO1
							Case Substr((cAliasSD3)->D3_CF,1,2)=="DE"
								Replace QUANTIDADE 	with QUANTIDADE - (cAliasSD3)->D3_QUANT
								Replace TOTAL		with TOTAL 		- (cAliasSD3)->D3_CUSTO1
						EndCase
						If QUANTIDADE>0
							Replace VALOR_UNIT	with NoRound(TOTAL/QUANTIDADE,nDecVal)
						EndIf
						If nQuebraAliq <> 1
							If nQuebraAliq == 2
								Replace ALIQ with SB1->B1_PICM
							Else
								Replace ALIQ with IIf(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
							EndIf
						EndIf
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
						If lCalcUni
							//-- Posiciona na tabela SD3
							dbSelectArea("SD3")
							dbGoto((cAliasSD3)->RECNOSD3)
	
							ExecBlock("A460UNIT",.F.,.F.,{(cAliasSD3)->D3_COD,(cAliasSD3)->D3_LOCAL,dDtFech,cArqTemp})
	
							dbSelectArea(cAliasSD3)
						EndIf
						MsUnLock()
					EndIf
                EndIf

				dbSelectArea(cAliasSD3)
				dbSkip()

			EndDo

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� ANALISE DE SALDO EM PROCESSO EM ABERTO                                    �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
			If Len(aEmAnalise) > 0 .And. Len(aProducao) > 0
				//-- Posiciona tabela SC2
				SC2->(dbSetOrder(1))
				If SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)#(xFilial("SC2")+(cArqTemp2)->OP)
					SC2->(MsSeek(xFilial("SC2")+(cArqTemp2)->OP))
				EndIf

				If SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)==(xFilial("SC2")+(cArqTemp2)->OP)
					For nX := 1 To Len(aEmAnalise)
						dbSelectArea("SD4")
						dbSetOrder(2)
						If dbSeek(xFilial("SD4")+(cArqTemp2)->OP+aEmAnalise[nX,1]+aEmAnalise[nX,2])
   							// Flag utilizado para gravar saldo em processo
							lEmProcess := .F.
							// Quantidade Media por Producao
							nQtMedia  := SD4->D4_QTDEORI / SC2->C2_QUANT
                            // Quantidade necessaria para producao da quantidade apontada
    						nQtNeces  := aProducao[1,2] * nQtMedia
    						// Avalia quantidade em processo
    						If (aEmAnalise[nX,3]) > nQtNeces
    							lEmProcess := .T.
    							// Proporciona saldo em processo desta requisicao
	    						nQtde  := aEmAnalise[nX,3] - nQtNeces
								// Custo em processo
	    						nCusto := (aEmAnalise[nX,4] / aEmAnalise[nX,3]) * nQtde
							EndIf	
							
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
							//� GRAVA SALDO EM PROCESSO                                               �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						 	If lEmProcess
								// Posiciona tabela SB1
								If SB1->B1_COD!=aEmAnalise[nX,1]
									SB1->(dbSeek(xFilial("SB1")+aEmAnalise[nX,1]))
								EndIf
		
								If SB1->B1_COD==aEmAnalise[nX,1]
									dbSelectArea(cArqTemp)
									dbSetOrder(2)
									RecLock(cArqTemp,!dbSeek(aEmAnalise[nX,1]+"2"))
									Replace SITUACAO 	with "2"
									Replace TIPO		with SB1->B1_TIPO
									Replace POSIPI		with SB1->B1_POSIPI
									Replace PRODUTO		with SB1->B1_COD
									Replace DESCRICAO	with SB1->B1_DESC
									Replace UM			with SB1->B1_UM
									Replace QUANTIDADE 	with QUANTIDADE + nQtde
									Replace TOTAL		with TOTAL 		+ nCusto
									If QUANTIDADE > 0
										Replace VALOR_UNIT	with NoRound(TOTAL/QUANTIDADE,nDecVal)
									EndIf
									If nQuebraAliq <> 1
										If nQuebraAliq == 2
											Replace ALIQ with SB1->B1_PICM
										Else
											Replace ALIQ with IIf(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
										EndIf
									EndIf
									//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
									//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
									//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
									If lCalcUni
										//-- Posiciona na tabela SD3
										dbSelectArea("SD3")
										dbGoto(aEmAnalise[nX,5])
				
										ExecBlock("A460UNIT",.F.,.F.,{aEmAnalise[nX,1],aEmAnalise[nX,2],dDtFech,cArqTemp})
				
										dbSelectArea(cAliasSD3)
									EndIf
									MsUnLock()
								EndIf
						 	EndIf
						EndIf
					Next aEmAnalise
				EndIf

			EndIf
			
		EndIf

		// Finaliza a Query para esta OP
		If lQuery
			dbSelectArea(cAliasSD3)
			dbCloseArea()
		EndIf

		dbSelectArea(cArqTemp2)
		dbSkip()
	EndDo
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Apaga arquivos temporarios                                   �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	dbSelectArea(cArqTemp2)
	dbCloseArea()
	Ferase(cArqTemp2+GetDBExtension())
	Ferase(cArqTemp2+OrdBagExt())
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Busca saldo em processo dos materiais de uso indireto        �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1"))

	If !lGraph
		SetRegua(LastRec())
	EndIf	

	While !Eof() .And. !lEnd .And. xFilial("SB1")==B1_FILIAL
		If !lGraph
			IncRegua()
			If Interrupcao(@lEnd)
				Exit
			EndIf
		EndIf	
		If !SB1->( B1_COD>=cProdIni .And. B1_COD<=cProdFim .And. IIf(lModProces,.T.,!IsProdMod(B1_COD)) )
			dbSkip()
			Loop
		EndIf
		If !(SB1->B1_APROPRI == "I")
			dbSkip()
			Loop
		EndIf

		dbSelectArea("SB2")
		If lListCustMed .Or. (!lListCustMed .And. !lCusfifo)
			aSalatu:=CalcEst(SB1->B1_COD,GetMv("MV_LOCPROC"),dDtFech+1,nil)
		Else
			aSalatu:=CalcEstFF(SB1->B1_COD,GetMv("MV_LOCPROC"),dDtFech+1,nil)
		EndIf

		dbSelectArea(cArqTemp)
		dbSetOrder(2)
		RecLock(cArqTemp,!dbSeek(SB1->B1_COD+"2"))
		Replace SITUACAO 	with "2"
		Replace TIPO		with SB1->B1_TIPO
		Replace POSIPI		with SB1->B1_POSIPI
		Replace PRODUTO		with SB1->B1_COD
		Replace DESCRICAO	with SB1->B1_DESC
		Replace UM			with SB1->B1_UM
		Replace QUANTIDADE 	with QUANTIDADE + aSalAtu[1]
		Replace TOTAL		with TOTAL + aSalAtu[2]
		If QUANTIDADE>0
			Replace VALOR_UNIT with NoRound(TOTAL/QUANTIDADE,nDecVal)
		EndIf
		If nQuebraAliq <> 1
			If nQuebraAliq == 2
				Replace ALIQ with SB1->B1_PICM
			Else
				Replace ALIQ with IIf(SB0->(MsSeek(xFilial("SB0")+SB1->B1_COD)),SB0->B0_ALIQRED,0)
			EndIf
		EndIf
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
		If lCalcUni
			ExecBlock("A460UNIT",.F.,.F.,{SB1->B1_COD,GetMv("MV_LOCPROC"),dDtFech,cArqTemp})
		EndIf
		MsUnlock()			                      					
		dbSelectArea("SB1")
		dbSkip()
	EndDo
EndIf

Return Nil

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪穆哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    砇460Cabec()    矨utor矹uan Jose Pereira   � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪牧哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矯abecalho do Modelo P7                                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� nLin - Numero da linha corrente                            潮�
北�          � nPagina - Numero da pagina corrente                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  � Nenhum                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function R460Cabec( nLin, nPagina, lGraph, oReport, cFilNome )
Local aL:=R460LayOut()
Local cPicCgc

Default lGraph := .F.
Default cFilNome := ""

If  cPaisLoc=="ARG"
	cPicCgc	:="@R 99-99.999.999-9"
ElseIf cPaisLoc == "CHI"
	cPicCgc	:="@R XX.999.999-X"
ElseIf cPaisLoc $ "POR|EUA"
	cPicCgc	:=PesqPict("SA2","A2_CGC")
Else
	cPicCgc	:="@R 99.999.999/9999-99"
EndIf

//-- Posiciona na Empresa/Filial a ser processada
If mv_par21 == 1
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt+cFilAnt))
EndIf

nLin:=1
If !lGraph
	@ 00,00 PSAY AvalImp(132)
	FmtLin(,aL[01],,,@nLin)
	FmtLin(,aL[02],,,@nLin)
	FmtLin(,aL[03],,,@nLin)
	If cFilNome != ""
		FmtLin({SM0->M0_NOMECOM,cFilNome},aL[04],,,@nLin)
	Else
		FmtLin({SM0->M0_NOMECOM},aL[04],,,@nLin)
	EndIf
	FmtLin(,aL[05],,,@nLin)
	If cPaisLoc == "CHI"
		FmtLin({,Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@nLin)
	Else
		FmtLin({InscrEst(),Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@nLin)
	EndIf
	
	FmtLin(,aL[07],,,@nLin)
	FmtLin({Transform(StrZero(nPagina,6),"@R 999.999"),DTOC(dDtFech)},aL[08],,,@nLin)
	FmtLin(,aL[09],,,@nLin)
	FmtLin(,aL[10],,,@nLin)
	FmtLin(,aL[11],,,@nLin)
	FmtLin(,aL[12],,,@nLin)
	FmtLin(,aL[13],,,@nLin)
	FmtLin(,aL[14],,,@nLin)
Else
	//-- Reinicia Paginas
	oReport:EndPage()

	FmtLinR4(oReport,,aL[01],,,@nLin)
	FmtLinR4(oReport,,aL[02],,,@nLin)
	FmtLinR4(oReport,,aL[03],,,@nLin)
	If cFilNome != ""
		FmtLinR4(oReport,{SM0->M0_NOMECOM,cFilNome},aL[04],,,@nLin)
	Else
		FmtLinR4(oReport,{SM0->M0_NOMECOM},aL[04],,,@nLin)
	EndIf
	FmtLinR4(oReport,,aL[05],,,@nLin)
	If cPaisLoc == "CHI"
		FmtLinR4(oReport,{,Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@nLin)
	Else
		FmtLinR4(oReport,{InscrEst(),Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@nLin)
	EndIf
	
	FmtLinR4(oReport,,aL[07],,,@nLin)
	FmtLinR4(oReport,{Transform(StrZero(nPagina,6),"@R 999.999"),DTOC(dDtFech)},aL[08],,,@nLin)
	FmtLinR4(oReport,,aL[09],,,@nLin)
	FmtLinR4(oReport,,aL[10],,,@nLin)
	FmtLinR4(oReport,,aL[11],,,@nLin)
	FmtLinR4(oReport,,aL[12],,,@nLin)
	FmtLinR4(oReport,,aL[13],,,@nLin)
	FmtLinR4(oReport,,aL[14],,,@nLin)
EndIf	

nPagina:=nPagina+1

Return Nil

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪穆哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    砇460EmBranco() 矨utor矹uan Jose Pereira   � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪牧哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 砅reenche o resto da pagina em branco                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� nLin - Numero da linha corrente                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  � Nenhum                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function R460EmBranco(nLin,lGraph,oReport)

Local aL:=R460Layout()
Default lGraph := .F.

If !lGraph
	While nLin<=55
		FmtLin(Array(7),aL[15],,,@nLin)
	End
	FmtLin(,aL[16],,,@nLin)
Else
	While nLin<=55
		FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
	End
	FmtLinR4(oReport,,aL[16],,,@nLin)
	oReport:EndPage()
EndIf	

Return Nil

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪穆哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    砇460AvalProd() 矨utor矹uan Jose Pereira   � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪牧哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矨valia se produto deve ser listado                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� cProduto - Codigo do produto avaliado                      潮�
北�          � lConsMod - Flag que indica se devem ser considerados       潮�
北�          � produtos MOD                                               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  � LOGICO indicando se o produto deve ser listado             潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function R460AvalProd(cProduto,lConsMod)
Default lConsMod := .F.
Return(cProduto>=cProdIni.And.cProduto<=cProdFim) .And. IIf(lConsMod,.T.,!IsProdMod(cProduto))

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪穆哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    砇460Local()    矨utor矹uan Jose Pereira   � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪牧哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矨valia se Local deve ser listado                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� cLocal - Codigo do armazem avaliado                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  � LOGICO indicando se o armazem deve ser listado             潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function R460Local(cLocal)
Return (cLocal>=cAlmoxIni.And.cLocal<=cAlmoxFim)

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪穆哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    砇460Acumula()  矨utor矹uan Jose Pereira   � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪牧哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矨cumulador de totais                                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� aTotal - Array com totalizadores do relatorio              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  � Nenhum                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function R460Acumula(aTotal)
Local nPos:=0
If nQuebraAliq == 1
	nPos:=Ascan(aTotal,{|x|x[1]==SITUACAO.And.x[2]==TIPO})
Else
	nPos:=Ascan(aTotal,{|x|x[1]==SITUACAO.And.x[2]==TIPO.And.x[6]==ALIQ})
EndIf	
If nPos==0
	If nQuebraAliq == 1
		AADD(aTotal,{SITUACAO,TIPO,QUANTIDADE,VALOR_UNIT,TOTAL})
	Else
		AADD(aTotal,{SITUACAO,TIPO,QUANTIDADE,VALOR_UNIT,TOTAL,ALIQ})
	EndIf	
Else
	aTotal[nPos,3]+=QUANTIDADE
	aTotal[nPos,4]+=VALOR_UNIT
	aTotal[nPos,5]+=TOTAL
EndIf
nPos:=Ascan(aTotal,{|x|x[1]==SITUACAO.And.x[2]==TT})
If nPos==0
	AADD(aTotal,{SITUACAO,TT,QUANTIDADE,VALOR_UNIT,TOTAL})
Else
	aTotal[nPos,3]+=QUANTIDADE
	aTotal[nPos,4]+=VALOR_UNIT
	aTotal[nPos,5]+=TOTAL
EndIf

nPos:=Ascan(aTotal,{|x|x[1]=="T".And.x[2]==TT})
If nPos==0
	AADD(aTotal,{"T",TT,QUANTIDADE,VALOR_UNIT,TOTAL})
Else
	aTotal[nPos,3]+=QUANTIDADE
	aTotal[nPos,4]+=VALOR_UNIT
	aTotal[nPos,5]+=TOTAL
EndIf
Return Nil

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪穆哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    砇460Total()    矨utor矹uan Jose Pereira   � Data � 07.11.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪牧哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矷mprime totais                                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� nLin  - Numero da linha corrente                           潮�
北�          � aTotal- Array com totalizadores do relatorio               潮�
北�          � cSituacao- Indica se deve imprimir total geral ou do grupo 潮�
北�          � cTipo - Tipo que esta sendo totalizado                     潮�
北�          � aSituacao - Array com descricao da situacao totalizada     潮�
北�          � nPagina - Numero da pagina corrente                        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  � LOGICO indicando se o armazem deve ser listado             潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function R460Total( nLin, aTotal, cSituacao, cTipo, aSituacao, nPagina, lGraph, oReport, cFilNome )

Local aL:=R460LayOut(),nPos:=0,i:=0,cSitAnt:="X",cSubtitulo,cTipAnt:="X",	nTotal:=0,nStart:=1

Default lGraph := .F.

If !lGraph
	FmtLin(Array(7),aL[15],,,@nLin)
Else
	FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
EndIf	

If cSituacao!="T"
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Imprime totais dos grupos                                    �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If cTipo!=TT
		nPos:=Ascan(aTotal,{|x|x[1]==cSituacao.And.x[2]==cTipo})
		SX5->(dbSeek(xFilial("SX5")+"02"+cTipo))
		If nQuebraAliq == 1
			If !lGraph
				FmtLin({,STR0021+TRIM(X5Descri())+" ===>",,,,,Transform(aTotal[nPos,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)			//"TOTAL "
			Else
				FmtLinR4(oReport,{,STR0021+TRIM(X5Descri())+" ===>",,,,,Transform(aTotal[nPos,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)			//"TOTAL "
			EndIf	
		Else
			nTotal:=0
			nStart:=Ascan(aTotal,{|x|x[1]==cSituacao.And.x[2]==cTipo})
			Do While (nPos := Ascan(aTotal,{|x|x[1]==cSituacao.And.x[2]==cTipo},nStart)) > 0
				If nPos > 0
					nTotal+=aTotal[nPos,5]
				EndIf	
				If (nStart := ++nPos) > Len(aTotal)
					Exit
				EndIf
			EndDo
			If !lGraph
				FmtLin({,STR0021+TRIM(X5Descri())+" ===>",,,,,Transform(nTotal, "@E 999,999,999,999.99")},aL[15],,,@nLin)			//"TOTAL "
			Else
				FmtLinR4(oReport,{,STR0021+TRIM(X5Descri())+" ===>",,,,,Transform(nTotal, "@E 999,999,999,999.99")},aL[15],,,@nLin)			//"TOTAL "
			EndIf	
		EndIf	
	Else
		nPos:=Ascan(aTotal,{|x|x[1]==cSituacao.And.x[2]==TT})
		If !lGraph
			FmtLin({,STR0021+aSituacao[Val(cSituacao)]+" ===>",,,,,Transform(aTotal[nPos,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)	//"TOTAL "
		Else 
			FmtLinR4(oReport,{,STR0021+aSituacao[Val(cSituacao)]+" ===>",,,,,Transform(aTotal[nPos,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)	//"TOTAL "
		EndIf	
	EndIf
	If nLin>=55
		R460EmBranco(@nLin,If(!lGraph,.F.,.T.),If(lGraph,oReport,))
	EndIf
Else
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Imprime resumo final                                         �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	aTotal:=Asort(aTotal,,,{|x,y|x[1]+x[2]<y[1]+y[2]})
	If !lGraph
		FmtLin(Array(7),aL[15],,,@nLin)
		FmtLin({,STR0022,,,,,},aL[15],,,@nLin)		//"R E S U M O"
		FmtLin({,"***********",,,,,},aL[15],,,@nLin)
	Else
		FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
		FmtLinR4(oReport,{,STR0022,,,,,},aL[15],,,@nLin)		//"R E S U M O"
		FmtLinR4(oReport,{,"***********",,,,,},aL[15],,,@nLin)
	EndIf	
	For i:=1 to Len(aTotal)
		If nLin>55
			If !lGraph
				R460Cabec( @nLin, @nPagina, .F., nil, cFilNome )
				FmtLin(Array(7),aL[15],,,@nLin)
			Else
				R460Cabec( @nLin, @nPagina, .T., oReport, cFilNome )
				FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
			EndIf
		EndIf
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Nao imprime produtos sem movimentacao                        �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If aTotal[i,1]=="3"
			Loop
		EndIf
		If cSitAnt!=aTotal[i,1]
			cSitAnt:=aTotal[i,1]
			If aTotal[i,1]!="T"
				If !lGraph
					FmtLin(Array(7),aL[15],,,@nLin)
					cSubTitulo:=Alltrim(aSituacao[Val(aTotal[i,1])])
					FmtLin({,cSubtitulo,,,,,},aL[15],,,@nLin)
					FmtLin({,Replic("*",Len(cSubtitulo)),,,,,},aL[15],,,@nLin)
				Else 
					FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
					cSubTitulo:=Alltrim(aSituacao[Val(aTotal[i,1])])
					FmtLinR4(oReport,{,cSubtitulo,,,,,},aL[15],,,@nLin)
					FmtLinR4(oReport,{,Replic("*",Len(cSubtitulo)),,,,,},aL[15],,,@nLin)				
				EndIf	
			Else
				If !lGraph
					FmtLin(Array(7),aL[15],,,@nLin)
					FmtLin({,STR0023,,,,,Transform(aTotal[i,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)		//"TOTAL GERAL ====>"
				Else
					FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
					FmtLinR4(oReport,{,STR0023,,,,,Transform(aTotal[i,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)		//"TOTAL GERAL ====>"
				EndIf	
			EndIf
		EndIf
		If aTotal[i,1]!="T"
			If aTotal[i,2]!=TT
				If cTipAnt != aTotal[i,2] .And. cSitAnt == aTotal[i,1]
					cTipAnt:= aTotal[i,2]
					SX5->(dbSeek(xFilial("SX5")+"02"+aTotal[i,2]))
					If nQuebraAliq == 1
						If !lGraph
							FmtLin({,TRIM(X5Descri()),,,,,Transform(aTotal[i,5],"@E 999,999,999,999.99")},aL[15],,,@nLin)
						Else
							FmtLinR4(oReport,{,TRIM(X5Descri()),,,,,Transform(aTotal[i,5],"@E 999,999,999,999.99")},aL[15],,,@nLin)
						EndIf	
					Else
						nTotal:=0
						nStart:=Ascan(aTotal,{|x|x[1]==cSitAnt.And.x[2]==cTipAnt})
						Do While (nPos := Ascan(aTotal,{|x|x[1]==cSitAnt.And.x[2]==cTipAnt},nStart)) > 0
							If nPos > 0
								nTotal+=aTotal[nPos,5]
							EndIf	
							If (nStart := ++nPos) > Len(aTotal)
								Exit
							EndIf
						EndDo
						If i<>1
							If !lGraph
								FmtLin(Array(7),aL[15],,,@nLin)
							Else
								FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
							EndIf	
						EndIf	
						If !lGraph
							FmtLin({,TRIM(X5Descri()),,,,,Transform(nTotal,"@E 999,999,999,999.99")},aL[15],,,@nLin)
						Else 
							FmtLinR4(oReport,{,TRIM(X5Descri()),,,,,Transform(nTotal,"@E 999,999,999,999.99")},aL[15],,,@nLin)
						EndIf	
					EndIf
				EndIf
				If nQuebraAliq <> 1	
					If !lGraph
						FmtLin({,STR0031+Transform(aTotal[i,6],"@E 99.99%"),,,,,Transform(aTotal[i,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)			
					Else
						FmtLinR4(oReport,{,STR0031+Transform(aTotal[i,6],"@E 99.99%"),,,,,Transform(aTotal[i,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)			
					EndIf	
				EndIf
			Else
				If !lGraph
					FmtLin({,STR0024,,,,,Transform(aTotal[i,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)			//"TOTAL ====>"
				Else
					FmtLinR4(oReport,{,STR0024,,,,,Transform(aTotal[i,5], "@E 999,999,999,999.99")},aL[15],,,@nLin)			//"TOTAL ====>"
				EndIf	
				cTipAnt:="X"
			EndIf
		EndIf
		If nLin>=55
			R460EmBranco(@nLin,If(!lGraph,.F.,.T.),If(lGraph,oReport,))
		EndIf
	Next
EndIf

Return Nil

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪穆哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    砇460SemEst()   矨utor砇odrigo A Sartorio  � Data � 31.10.02 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪牧哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矷mprime informacao sem estoque                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� nLin - Numero da linha corrente                            潮�
北�          � nPagina - Numero da pagina corrente                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function R460SemEst(nLin,nPagina,lGraph,oReport)
Local aL:=R460LayOut()

Default lGraph := .F.

If !lGraph
	FmtLin(Array(7),aL[15],,,@nLin)
	FmtLin({,STR0030,,,,,},aL[15],,,@nLin) //"ESTOQUE INEXISTENTE"
Else
	FmtLinR4(oReport,Array(7),aL[15],,,@nLin)
	FmtLinR4(oReport,{,STR0030,,,,,},aL[15],,,@nLin) //"ESTOQUE INEXISTENTE"
EndIf	
Return Nil

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    矨justaSX1 � Autor � Nereu Humberto Jr     � Data �21.03.2005潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 矯ria as perguntas necesarias para o programa                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砃enhum                                                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砃enhum                                                      潮�
北�          �                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�   DATA   � Programador   矼anutencao Efetuada                         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�          �               �                                            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function AjustaSX1()

Local aHelpPor :={}
Local aHelpEng :={}
Local aHelpSpa :={}
Local nTamSX1  :=Len(SX1->X1_GRUPO)

//---- Remove pergunta referente a poder de terceiros -----------------------
dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(PADR("MTR460",nTamSX1)+"19") .And. Upper(Left(SX1->X1_PERGUNT,6)) <> "QUANTO"
	RecLock("SX1",.F.)
	dbDelete()
	MsUnlock()
EndIf

//------------------------------- mv_par19 -----------------------------------
Aadd( aHelpPor, "Informe o tipo de quebra por Aliquota   " )
Aadd( aHelpEng, "                                        " )
Aadd( aHelpSpa, "                                        " )

PutSx1( "MTR460","19","Quanto a quebra por aliquota ?","≧ef. a quiebra por alicuota ?","Skip per tax rate?","mv_chj",;
	"N",1,0,1,"C","","","","","mv_par19","Nao quebrar","No quebrar","Not skip","",;
	"Icms produto","Icms producto","Prod.ICMS","Icms reducao","Icms reduccion","Red.ICMS","","","","","","",;
	aHelpPor,aHelpEng,aHelpSpa)

//------------------------------- mv_par20 -----------------------------------
aHelpPor :={"Pergunta utilizada para verificar se","devera imprimir as requisicoes para","MOD com saldo em processo.","Somente utilizada em conjunto com ","a pergunta 'Saldo em Processo'"}
aHelpEng :={}
aHelpSpa :={}
PutSx1( "MTR460", "20","Lista MOD Processo?","↙ista MOD Processo?","Lista MOD Processo?","mv_chk","N",1,0,2,"C","","","","","mv_par20","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//------------------------------- mv_par21 -----------------------------------
aHelpPor := {'Seleciona as filiais desejadas. Se NAO',;
              'apenas a filial corrente sera afetada.',;
              '' }
aHelpSpa := {'Selecciona las sucursales deseadas. Si',;
              'NO solamente la sucursal actual es',;
              'afectado.' }
aHelpEng := {'Select desired branch offices. If NO',;
              'only current branch office will be',;
              'affected.' }

PutSx1(	'MTR460',;               	//-- 01 - X1_GRUPO
	    '21',;                      //-- 02 - X1_ORDEM
	    'Seleciona filiais?',;      //-- 03 - X1_PERGUNT
    	'縎elecciona sucursales?',; //-- 04 - X1_PERSPA
	    'Select branch offices?',;  //-- 05 - X1_PERENG
    	'mv_chl',;                  //-- 06 - X1_VARIAVL
	    'N',;                       //-- 07 - X1_TIPO
    	1,;                         //-- 08 - X1_TAMANHO
	    0,;                         //-- 09 - X1_DECIMAL
	    2,;                         //-- 10 - X1_PRESEL
    	'C',;                       //-- 11 - X1_GSC
	    '',;                        //-- 12 - X1_VALID
    	'',;                        //-- 13 - X1_F3
	    '',;                        //-- 14 - X1_GRPSXG
    	'',;                        //-- 15 - X1_PYME
	    'mv_par21',;                //-- 16 - X1_VAR01
    	'Sim',;                     //-- 17 - X1_DEF01
	    'Si',;                      //-- 18 - X1_DEFSPA1
    	'Yes',;                     //-- 19 - X1_DEFENG1
	    '',;                        //-- 20 - X1_CNT01
    	'Nao',;                     //-- 21 - X1_DEF02
	    'No',;                      //-- 22 - X1_DEFSPA2
    	'No',;                      //-- 23 - X1_DEFENG2
	    '',;                        //-- 24 - X1_DEF03
    	'',;                        //-- 25 - X1_DEFSPA3
	    '',;                        //-- 26 - X1_DEFENG3
    	'',;                        //-- 27 - X1_DEF04
	    '',;                        //-- 28 - X1_DEFSPA4
    	'',;                        //-- 29 - X1_DEFENG4
	    '',;                        //-- 30 - X1_DEF05
    	'',;                        //-- 31 - X1_DEFSPA5
	    '',;                        //-- 32 - X1_DEFENG5
    	aHelpPor,;                  //-- 33 - HelpPor
	    aHelpSpa,;                  //-- 34 - HelpSpa
    	aHelpEng,;                  //-- 35 - HelpEng
	    '')                         //-- 36 - X1_HELP
    	
dbSelectArea("SX1")
If dbSeek(PADR("MTR460",nTamSX1)+"03",.F.)
	If !("MTR460VAlm" $ X1_VALID)
		RecLock("SX1",.F.)
		If Empty(X1_VALID) .Or. "MTR900VAlm" $ X1_VALID
			Replace X1_VALID With "MTR460VAlm"
		Else
			Replace X1_VALID With X1_VALID+".And.MTR460VAlm"
		EndIf
		MsUnlock()
	EndIf
EndIf
If dbSeek(PADR("MTR460",nTamSX1)+"04",.F.)
	If !("MTR460VAlm" $ X1_VALID)
		RecLock("SX1",.F.)
		If Empty(X1_VALID) .Or. "MTR900VAlm" $ X1_VALID
			Replace X1_VALID With "MTR460VAlm"
		Else
			Replace X1_VALID With X1_VALID+".And.MTR460VAlm"
		EndIf
		MsUnlock()
	EndIf
EndIf

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    矷mpListSX1� Autor � Nereu Humberto Junior � Data � 01.08.05 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Rotina de impressao da lista de parametros do SX1 sem cabec潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   � ImpListSX1(titulo,nomeprog,tamanho,char,lFirstPage)        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� cTitulo - Titulo                                           潮�
北�          � cNomPrg - Nome do programa                                 潮�
北�          � nTamanho- Tamanho                                          潮�
北�          � nchar   - Codigo de caracter                               潮�
北�          � lFirstpage - Flag que indica se esta na primeira pagina    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function XImpListSX1(cTitulo,cNomPrg,nTamanho,nChar,lFirstPage)

Local cAlias,nLargura,nLin:=0, aDriver := ReadDriver(),nCont:= 0, cVar
Local lWin:=.F.
Local nTamSX1 := Len(SX1->X1_GRUPO)

PRIVATE cSuf:=""

If TYPE("__DRIVER") == "C"
	If "DEFAULT"$__DRIVER
		lWin := .T.
	EndIf		
EndIf

nLargura   :=IIf(nTamanho=="P",80,IIf(nTamanho=="G",220,132))
cTitulo    :=IIf(TYPE("NewHead")!="U",NewHead,cTitulo)
lFirstPage :=IIf(lFirstPage==Nil,.F.,lFirstPage)

If lFirstPage
	If GetMv("MV_SALTPAG",,"S") == "N"
		Setprc(0,0)
	EndIf	
	If nChar == NIL
		@ 0,0 PSAY AvalImp(132)
	Else
		If nChar == 15
			@ 0,0 PSAY &(if(nTamanho=="P",aDriver[1],if(nTamanho=="G",aDriver[5],aDriver[3])))
		Else
			@ 0,0 PSAY &(if(nTamanho=="P",aDriver[2],if(nTamanho=="G",aDriver[6],aDriver[4])))
		EndIf
	EndIf
EndIf	

cFileLogo := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial
If !File( cFileLogo )
	cFileLogo := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
EndIf

__ChkBmpRlt( cFileLogo ) // Seta o bitmap, mesmo que seja o padr鉶 da microsiga

If GetMv("MV_IMPSX1") == "S"  // Imprime pergunta no cabecalho
	If m_pag == 1
		nLin   := 0
		nLin   := SendCabec(lWin, nLargura, cNomPrg, RptParam+" - "+Alltrim(cTitulo), "", "", .F.)
		cAlias := Alias()
		dbSelectArea("SX1")
		dbSeek(PADR(cPerg,nTamSX1))
		While !EOF() .And. X1_GRUPO = PADR(cPerg,nTamSX1)
			cVar := "MV_PAR"+StrZero(Val(X1_ORDEM),2,0)
			nLin += 1
			@ nLin,5 PSAY RptPerg+" "+ X1_ORDEM + " : "+ ALLTRIM(X1_PERGUNTA)
			If X1_GSC == "C"
				xStr:=StrZero(&(cVar),2)
			EndIf
			@ nLin,Pcol()+3 PSAY IIF(X1_GSC!='C',&(cVar),IIF(&(cVar)>0,X1_DEF&xStr,""))
			dbSkip()
		EndDo

		cFiltro := IIF(!Empty(aReturn[7]),MontDescr(cAlias,aReturn[7]),"")
		nCont := 1
		If !Empty(cFiltro)
			nLin += 2
			@ nLin,5  PSAY OemToAnsi(STR0032) + Substr(cFiltro,nCont,nLargura-19)  // "Filtro      : "
			While Len(Alltrim(Substr(cFiltro,nCont))) > (nLargura-19)
				nCont += nLargura - 19
				nLin++
				@ nLin,19  PSAY  Substr(cFiltro,nCont,nLargura-19)
			End	
			nLin++
		EndIf
		nLin++
		@ nLin,00  PSAY REPLI("*",nLargura)
		dbSelectArea(cAlias)
	EndIf
EndIf

m_pag++

If Subs(__cLogSiga,4,1) == "S"
	__LogPages()
EndIf

Return Nil

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪勘�
北矲un噮o    矼TR460CUnf � Autor 砃ereu Humberto Junior  � Data �29/08/05 潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪幢�
北矰escri噮o 矨justa grupo de perguntas p/ Custo Unificado                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � MATR460                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function MTR460CUnf(lCusUnif)
Local aSvAlias:=GetArea()
Local nTamSX1 :=Len(SX1->X1_GRUPO)

dbSelectArea("SX1")
If dbSeek(PADR("MTR460",nTamSX1)+"03",.F.)
	If lCusUnif .And. X1_CNT01 != "**"
		RecLock("SX1",.F.)
		Replace X1_CNT01 With "**"
		MsUnlock()
	EndIf
EndIf
If dbSeek(PADR("MTR460",nTamSX1)+"04",.F.)
	If lCusUnif .And. X1_CNT01 != "**"
		RecLock("SX1",.F.)
		Replace X1_CNT01 With "**"
		MsUnlock()
	EndIf
EndIf
RestArea(aSvAlias)
Return Nil

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪勘�
北矲un噮o    砈aldoD3CF9 � Autor 砇odrigo de A Sartorio  � Data �30/12/05 潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪幢�
北矰escri噮o 砇etorna saldo dos movimentos RE9/DE9 relacionados ao produto潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砪Produto - Codigo do produto a ter os movimentos pesquisados潮�
北�          砫DataIni - Data inicial para pesquisa dos movimentos        潮�
北�          砫DataFim - Data final para pesquisa dos movimentos          潮�
北�          砪AlmoxIni- Armazem inicial para pesquisa dos movimentos     潮�
北�          砪AlmoxFim- Armazem final para pesquisa dos movimentos       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  砤DadosCF9- Array com quantidade e valor requisitado atraves 潮�
北�          砫e movimentos RE9 / DE9                                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � MATR460                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function SaldoD3CF9(cProduto,dDataini,dDataFim,cAlmoxIni,cAlmoxFim)
Local aArea     := GetArea()
Local cIndSD3   := ''
Local cQuery 	:= ''
Local aDadosCF9 := {0,0} // Quantidade e custo na 1a moeda para movimentos do SD3 com D3_CF RE9 ou DE9

Default dDataIni :=GETMV("MV_ULMES")+1

dbSelectArea("SD3")
#IFNDEF TOP
   	cIndSD3:=Substr(CriaTrab(NIL,.F.),1,7)+"T"
	cQuery := 'D3_FILIAL =="'+xFilial('SD3')+'".And.D3_ESTORNO=="'+Space(Len(SD3->D3_ESTORNO))+'".And.(D3_CF == "RE9" .Or. D3_CF == "DE9").And.DtoS(D3_EMISSAO)>="'+DtoS(dDataIni)+'".And.DtoS(D3_EMISSAO)<="'+DtoS(dDataFim)+'".And.D3_COD=="'+cProduto+'".And.D3_LOCAL>="'+cAlmoxIni+'".And.D3_LOCAL<="'+cAlmoxFim+'"'
	IndRegua("SD3",cIndSD3,"D3_FILIAL+D3_COD+D3_LOCAL",,cQuery)
	nIndSD3:=RetIndex("SD3")
	dbSetIndex(cIndSD3+OrdBagExt())
	dbSetOrder(nIndSD3+1)
	dbGoTop()
#ELSE
	cIndSD3:= GetNextAlias()
	cQuery := "SELECT D3_CF,D3_QUANT,D3_CUSTO1 FROM "+RetSqlName("SD3")+" SD3 "
	cQuery += "WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' AND SD3.D3_ESTORNO ='"+Space(Len(SD3->D3_ESTORNO))+"' "
	cQuery += "AND SD3.D3_CF IN ('RE9','DE9') "
	cQuery += "AND SD3.D3_EMISSAO >= '" + DTOS(dDataIni) + "' "
	cQuery += "AND SD3.D3_EMISSAO <= '" + DTOS(dDataFim) + "' "
	cQuery += "AND SD3.D3_COD = '" +cProduto+ "' "
	cQuery += "AND SD3.D3_LOCAL >= '" +cAlmoxIni+ "' "
	cQuery += "AND SD3.D3_LOCAL <= '" +cAlmoxFim+ "' "
	cQuery += "AND SD3.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY D3_FILIAL+D3_COD+D3_LOCAL"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cIndSD3,.T.,.T.)
	aEval(SD3->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cIndSD3,x[1],x[2],x[3],x[4]),Nil)})
#ENDIF
While !Eof()
	If D3_CF == "RE9"
		aDadosCF9[1]+=D3_QUANT
		aDadosCF9[2]+=D3_CUSTO1
	ElseIf D3_CF == "DE9"
		aDadosCF9[1]-=D3_QUANT
		aDadosCF9[2]-=D3_CUSTO1
	EndIf				 
	dbSkip()
End
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Restaura ambiente e apaga arquivo temporario                 �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
#IFDEF TOP
	dbSelectArea(cIndSD3)
	dbCloseArea()
	dbSelectArea("SD3")
#ELSE
	dbSelectArea("SD3")
	dbClearFilter()
	RetIndex("SD3")
	Ferase(cIndSD3+OrdBagExt())
#ENDIF         
RestArea(aArea)
Return aDadosCF9
               
/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪勘�
北矲un噮o    矴etOracleVe� Autor 矴uilherme C.L.Oliveira � Data �25/05/05 潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪幢�
北矰escri噮o 砄btem a Versao do ORACLE                                    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砃enhum                                                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Retorno  砎ersao do Oracle                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � MATR460                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function GetOracleVersion()
Local cArea := Alias()
Local cQuery := "select * from v$version"
Local cAlias := "_Oracle_version"
Local nVersion := 0
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
nVersion := Val(SubString((cAlias)->BANNER,At("Release",(cAlias)->BANNER)+8,1))
dbCloseArea()
DbSelectArea(cArea)

Return nVersion

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o  	 矲mtLinR4()� Autor � Nereu Humberto Junior � Data � 31.07.06 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Formata linha para impressao                               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function FmtLinR4(oReport,aValores,cFundo,cPictN,cPictC,nLin,lImprime,bCabec,nTamLin)
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis da funcao                                          �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local cConteudo:=''
Local cLetra   :=''
Local nPos     :=0
Local i        :=0
Local j        :=0
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Sets para a Funcao, mudar se necessario                      �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local cPictNPad :='@E 999,999,999.99'
Local cPictCPad :='@!'
Local cCharOld  :='#'
Local cCharBusca:='�'
Local cTipoFundo:=ValType(cFundo)
Local nFor      :=1
Local cAlias    := Alias()
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Troca # por cCharBusca pois existem dados com # que devem    �
//� ser impressos corretamente.                                  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If cTipoFundo == "C"
	cFundo:=StrTran(cFundo,cCharOld,cCharBusca)
ElseIf cTipoFundo == "A"
	For i:=1 To Len(cFundo)
		cFundo[i]:=StrTran(cFundo[i],cCharOld,cCharBusca)
	Next i
EndIf

aValores:=IIf(Empty(aValores),{},aValores)
aValores:=IIf(cTipoFundo=="C",aValores,{})
lImprime:=IIf(lImprime==NIL,.t.,lImprime)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Substitue o caracter cCharBusca por "_" nas strings          �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
For nFor:=1 To Len(aValores)
	If ValType(aValores[nFor])=="C"
		If At(cCharBusca,aValores[nFor]) > 0
			aValores[nFor]:=StrTran(aValores[nFor],cCharBusca,"_")
		EndIf
	EndIf
Next
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Efetua quebra de pagina com impressao de cabecalho           �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If bCabec!=NIL .And. nLin>55
	nTamLin:=Iif(nTamLin==NIL,220,nTamLin)
	nLin++
	oReport:PrintText("+"+Replic("-",nTamLin-2)+"+")
	Eval(bCabec)
EndIf
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Rotina de substituicao                                       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
For i:=1 to Len(aValores)
	If ValType(aValores[i])=='A'
		If !Empty(aValores[i,2])
			cConteudo:=Transform(aValores[i,1],aValores[i,2])
		Else
			If Type(aValores[i,1])=='N'
				cConteudo:=Str(aValores[i,1])
			Else
				cConteudo:=aValores[i,1]
			EndIf
		EndIf
	Else
		cPictN:=Iif(Empty(cPictN),cPictNPad,cPictN)
		cPictC:=Iif(Empty(cPictC),cPictCPad,cPictC)
		aValores[i]:=Iif(aValores[i]==NIL,"",aValores[i])
		If ValType(aValores[i])=='N'
			cConteudo:=Transform(aValores[i],cPictN)
		Else
			cConteudo:=Transform(aValores[i],cPictC)
		EndIf
	EndIf
	nPos:=0
	cFormato:=""
	nPos:=At(cCharBusca,cFundo)
	If nPos>0
		cLetra:=cCharBusca
		j:=nPos
		While cLetra==cCharBusca
			cLetra:=Substr(cFundo,j,1)
			If cLetra==cCharBusca
				cFormato+=cLetra
			EndIf
			j++
		End
		If Len(cFormato)>Len(cConteudo)
			If ValType(aValores[i]) <> 'N'
				cConteudo+=Space(Len(cFormato)-Len(cConteudo))
			Else
				cConteudo := Space(Len(cFormato)-Len(cConteudo))+ cConteudo	
			EndIf
		EndIf
		cFundo:=Stuff(cFundo,nPos,Len(cConteudo),cConteudo)
	EndIf
Next
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Imprime linha formatada                         �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lImprime
	If cTipoFundo=="C"
		nLin++
		oReport:PrintText(cFundo)
	Else
		For i:=1 to Len(cFundo)
			nLin++
			oReport:PrintText(cFundo[i])
		Next
	EndIf
EndIf
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Devolve array de dados com mesmo tamanho mas vazio           �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If Len(aValores)>0
	aValores:=Array(Len(aValores))
EndIf
DbSelectArea(cAlias)
Return cFundo

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪勘�
北矲un噮o    矼TR460VAlm � Autor 砃ereu Humberto Junior  � Data �01/08/06 潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪幢�
北矰escri噮o 砎alida Almoxarifado do KARDEX com relacao a custo unificado 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � MATR460                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function MTR460VAlm()
Local lRet:=.T.
Local cConteudo:=&(ReadVar())
Local nOpc:=2
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Verifica se utiliza custo unificado por Empresa/Filial       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))

If lCusUnif .And. cConteudo != "**"
	nOpc := Aviso(STR0035,STR0036,{STR0037,STR0038})	//"Aten噭o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
	If nOpc == 2
		lRet:=.F.
	EndIf
EndIf
Return lRet

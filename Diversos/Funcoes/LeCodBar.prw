#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "TBICONN.CH" 
#DEFINE CRLF ( chr(13)+chr(10) )       


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณLeCodBar  ณ Autor ณ Edi Nei Goetz         ณ Data ณ11/01/2006ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ CSA - MBC - GO   ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณRealiza a leitura do codigo de barras                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณArray contendo os dados do titulo posicionado               ณฑฑ
ฑฑณ          ณ[1] - Prefixo                                               ณฑฑ
ฑฑณ          ณ[2] - Numero                                                ณฑฑ
ฑฑณ          ณ[3] - Parcela                                               ณฑฑ
ฑฑณ          ณ[4] - Vencimento                                            ณฑฑ
ฑฑณ          ณ[5] - Valor                                                 ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณGrava o resultado obtido na Tabela SE2                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณSIGACOM / SIGAFIN                                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Dat"a  ณ Bops ณ Manutencao Efetuada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ      ณ                                        ณฑฑ
ฑฑณ              ณ  /  /  ณ      ณ                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Codigo de Barras: 39997000000000000002676095000000000109100002 ณ
//ณ                                                                ณ
//ณ Posicoes da Linha digitavel:                                   ณ
//ณ 1 - 3   4-4    33 -  47         5 - 9     11 - 20   22 - 31    ณ
//ณ 399      9    700000000000000   26760   9500000000  109100002  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


User Function LeCodBar(_aTitulo)
// Variaveis Locais da Funcao
Local cPrefixo	 := _aTitulo[1]
Local cNumero	 := _aTitulo[2]
Local cParcela	 := _aTitulo[3]
Local cVencto	 := _aTitulo[4]
Local oAcres
Local oDecres
Local oCodBar
Local oForma
Local oLinDig
Local oNumero
Local oParcela
Local oPrefixo
Local oValor
Local oVencto
Local lForma
Local lFina		:= Upper(FunName())$'FINA750,FINA050'

// Variaveis utilizadas para formacao do codigo de barras
// quando preenchido Linha Digitavel
Local cNosNum	:= ''
Local cBanco	:= ''
Local cAgencia	:= ''
Local cConta	:= ''
Local cCarteira	:= ''
Local nTipo		:= 1

// Variaveis da Funcao de Controle e GertArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}  

// Variaveis Private da Funcao
Local oConces	
Private _oDlgBar				// Dialog Principal
Private cCodBar	 := Space(48)
Private cForma	 := Space(4)
Private cLinDig	 := Space(48)
Private lConces := .F.

// Variaveis para modificar o valor do tํtulo
Private nValor	 := _aTitulo[5]
Private nAcres	 := 0
Private nDecres	 := 0
Private nSaldo	 := _aTitulo[5]
Private oSaldo

If !lFina
	If Type('__cForma') == 'U'
		Public __cForma := Space(4)
	EndIf
	
	If Type('__cChvForma') == 'U'
		Public __cChvForma := cPrefixo+cNumero
		lForma := .T.
		__cForma := Space(4)
	Else
		If __cChvForma == cPrefixo+cNumero
			lForma := .F.
		Else
			__cChvForma := cPrefixo+cNumero
			lForma := .T.
			__cForma := Space(4)
		EndIf
	EndIf
EndIf

DEFINE MSDIALOG _oDlgBar TITLE "Codigo de Barras" FROM 178,181 TO 490,775 PIXEL

// Cria as Groups do Sistema
@ 003,003 TO 072,297 LABEL " Dados do Titulo " PIXEL OF _oDlgBar
@ 074,003 TO 107,297 LABEL " Linha Digitavel " PIXEL OF _oDlgBar
@ 110,003 TO 140,297 LABEL " Codigo de Barra via Leitor ou Impostos/Concessionarias" PIXEL OF _oDlgBar

// Cria Componentes Padroes do Sistema
@ 011,045 MsGet oPrefixo 		Var cPrefixo Size 037,007 When .F. COLOR CLR_BLUE PIXEL OF _oDlgBar
@ 014,007 Say "Prefixo" 		Size 018,008 COLOR CLR_BLUE PIXEL OF _oDlgBar
@ 011,225 MsGet oValor 			Var nValor Size 060,007 Picture '@E 999,999,999.99' When .F. COLOR CLR_BLUE PIXEL OF _oDlgBar
@ 014,181 Say "Valor Original" 	Size  033, 008 COLOR CLR_BLUE PIXEL OF _oDlgBar

@ 022,045 MsGet oNumero 		Var cNumero Size 060,007 When .F. COLOR CLR_BLUE PIXEL OF _oDlgBar
@ 024,007 Say "Numero" 			Size 020,008 COLOR CLR_BLUE PIXEL OF _oDlgBar
@ 022,225 MsGet oAcres 			Var nAcres Size 030,007 Picture '@E 999.99' When !lFina Valid AtuValor() COLOR CLR_BLUE PIXEL OF _oDlgBar
@ 024,181 Say "+ Acr้scimo" 	Size  037,008 COLOR CLR_BLUE PIXEL OF _oDlgBar

@ 033,045 MsGet CParcela 		Var cParcela Size 023,007 When .F. COLOR CLR_BLUE PIXEL OF _oDlgBar
@ 035,007 Say "Parcela" 		Size 020,008 COLOR CLR_BLUE PIXEL OF _oDlgBar
@ 033,225 MsGet oDecres 		Var nDecres Size 030,007 Picture '@E 999.99' When !lFina Valid AtuValor() COLOR CLR_RED PIXEL OF _oDlgBar
@ 035,181 Say "- Decr้scimo"	Size 039,008 COLOR CLR_RED PIXEL OF _oDlgBar

@ 044,045 MsGet oVencto			Var cVencto Size 060,007 When .F. COLOR CLR_BLUE PIXEL OF _oDlgBar
@ 046,007 Say "Vencimento"		Size 030,008 COLOR CLR_BLUE PIXEL OF _oDlgBar
@ 044,225 MsGet oSaldo 			Var nSaldo Size 060,007 Picture '@E 999,999,999.99' When .F. COLOR CLR_BLUE PIXEL OF _oDlgBar
@ 046,181 Say "= Saldo" 		Size 030,008 COLOR CLR_BLUE PIXEL OF _oDlgBar

@ 060,007 CHECKBOX oConces VAR lConces PROMPT "Concessionแria" SIZE 048, 008 OF _oDlgBar PIXEL
 
//If !lFina
//	@ 055,045 MsGet oForma 		Var __cForma F3 "24" Size 060,007 When lForma COLOR CLR_BLUE PIXEL OF _oDlgBar
//	@ 057,007 Say "Forma Pagto" Size 032,008 COLOR CLR_BLUE PIXEL OF _oDlgBar
//EndIf

@ 086,007 MsGet oLinDig Var cLinDig Picture "@R 99999.99999  99999.999999  99999.999999  9  99999999999999" Valid VldLinDig() Size 281,009 COLOR CLR_BLACK PIXEL OF _oDlgBar
@ 121,007 MsGet oCodBar Var cCodBar Size 281,009 COLOR CLR_BLACK PIXEL OF _oDlgBar



DEFINE SBUTTON FROM 143,268 TYPE 1 ENABLE OF _oDlgBar ACTION (_oDlgBar:End())

ACTIVATE MSDIALOG _oDlgBar CENTERED


// Caso nao tenha sido preenchido o codigo de barras
// ira ler a Linha digitavel
If Empty(cCodBar) .or.;
   len(AllTrim(cCodBar))=47//Se a barra tiver confeccionada igual a linha digitavel de boletos de fornecedores
	
	M->E2_XCONCES := 'N'
	
	If !Empty(cLinDig)
		cCodBar := CodBar(AllTrim(cLinDig))
	else
		cCodBar := CodBar(cCodBar)
	EndIf                  
ElseIf Empty(cCodBar) .Or. lConces //concessionarias e impostos  
	M->E2_XCONCES := iif(lConces,'S','N')
	Return(cCodBar)
EndIf

If lFina //SE FOR ROTINA DE INCLUSAO DE TITULO, OU
	
	M->E2_XCONCES := 'N'
	Return(cCodBar)
Else
	If RecLock('SE2',.F.)
		//SE2->E2_IDCNAB  := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO // TAMANHO 14
		SE2->E2_CODBAR  := cCodBar
		//SE2->E2_NATUREZ := IF(EMPTY(SE2->E2_NATUREZ),POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_NATUREZ"),SE2->E2_NATUREZ)
		//SE2->E2_FORMA	 := __cForma
		SE2->E2_ACRESC	 := nAcres
		SE2->E2_SDACRES += nAcres
		SE2->E2_DECRESC := nDecres
		SE2->E2_SDDECRE += nDecres
		MSUnlock()
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCodBar    บAutor  ณEdi Nei Goetz       บ Data ณ  09/02/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza conversao da Linha Digitavel em Codigo de Barras    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณLeCodBar                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Layout da Linha Digitavel                             ณ
//ณ                                                       ณ
//ณ 39992.67606 95000.000000 01091.000024 7 00000000000000ณ
//ณ ----+------ -----+------ -----+------ + ------+-------ณ
//ณ     |            |            |       |       |       ณ
//ณ     Cpo 1        Cpo 2        Cpo 3   DC      Cpo 4   ณ
//ณ                                                       ณ
//ณ Cpo 1 = 39992.67606                                   ณ
//ณ 399    - banco                                        ณ
//ณ 9      - moeda 9 (real)                               ณ
//ณ 2.6760 - nosso numero                                 ณ
//ณ 6      - digito verificador                           ณ
//ณ                                                       ณ
//ณ Cpo 2 = 95000.000000                                  ณ
//ณ 95000.0 - nosso numero (6 ultimos digitos)            ณ
//ณ 0000    - agencia                                     ณ
//ณ 0       - digito verificador                          ณ
//ณ                                                       ณ
//ณ Cpo 3 = 01091.000024                                  ณ
//ณ 01091.000 - conta corrente                            ณ
//ณ 02        - carteira                                  ณ
//ณ 4         - digito verificador                        ณ
//ณ                                                       ณ
//ณ Cpo 4 = 00000000000000                                ณ
//ณ 0000       - fator de vencimento                      ณ
//ณ 0000000000 - valor do documento                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function CodBar(cLinDig)
Local cRet 		:= ''
Local cParte1	:= ''
Local cParte2	:= ''
Local cParte3	:= ''
Local cParte4	:= ''
Local cParte5	:= ''
Local cParte6	:= ''

/*
Local aPos		:= {	{ 1, 3},;	// [1] Parte 1 -  1 |  3 BANCO
{ 4, 1},;	// [2] Parte 2 -  4 |  4 MOEDA
{33,len(cLinDig) - 33},;	// [3] Parte 3 - 33 | 47 DIGITO CODIGO BARRAS+VALOR
{ 5, 5},;	// [4] Parte 4 -  5 |  9
{11,10},;	// [5] Parte 5 - 11 | 20
{22,10}}	// [6] Parte 6 - 22 | 31
*/

Local aPos		:= {	{ 1, 3},;	// [1] Parte 1 -  1 |  3 BANCO
						{ 4, 1},;	// [2] Parte 2 -  4 |  4 MOEDA
						{33,15},;	// [3] Parte 3 - 33 | 47 DIGITO CODIGO BARRAS+VALOR
						{ 5, 5},;	// [4] Parte 4 -  5 |  9  
						{11,10},;	// [5] Parte 5 - 11 | 20
						{22,10}}	// [6] Parte 6 - 22 | 31


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Codigo de Barras: 39997000000000000002676095000000000109100002 ณ
//ณ                                                                ณ
//ณ Posicoes da Linha digitavel:                                   ณ
//ณ 1 - 3   4-4    33 -  47         5 - 9     11 - 20   22 - 31    ณ
//ณ 399      9    700000000000000   26760   9500000000  109100002  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// |---0----|----1----|----2----|----3----|----4----|
// 12345678901234567890123456789012345678901234567
// 39992676069500000000001091000024700000000000000 <-- linha digitavel
cParte1	:= Substr(cLinDig,aPos[1][1],aPos[1][2])
cParte2	:= Substr(cLinDig,aPos[2][1],aPos[2][2])
cParte3	:= Substr(cLinDig,aPos[3][1],aPos[3][2])
cParte4	:= Substr(cLinDig,aPos[4][1],aPos[4][2])
cParte5	:= Substr(cLinDig,aPos[5][1],aPos[5][2])
cParte6	:= Substr(cLinDig,aPos[6][1],aPos[6][2])

cRet 	:= cParte1+cParte2+cParte3+cParte4+cParte5+cParte6+SPACE(04)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxLeCodBar บAutor  ณEdi Nei Goetz       บ Data ณ  09/02/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณUtilizado para execucao pelo campo X3_WHEN da Tabela SE2    บฑฑ
ฑฑบ          ณcampo E2_CODBAR.                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFinanceiro                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xLeCodBar()
Local cCodbarras 	:= ""
Local cQuery 		:= ""
Local cMsg 	   		:= ""  
Local nValTit  		:= 0
If IsBlind()
	Return(.t.)
EndIf 
//ADICIONADO POR JONATAS PARA VALIDAวรO SE ESTE BOLETO Jม FOI UTILIZADO.
If Alltrim(ReadVar())= "M->E2_CODBAR"
	If Empty(M->E2_CODBAR)
		cCodbarras := U_LeCodBar({M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_VENCREA,M->E2_VALOR}) 
		
		if !vldcodbar(cCodbarras)
			Return(.T.)
		endif
		
		//verifica se estแ vencido
		if SUBSTR(cCodbarras,6,4) <> "0000" .AND. M->E2_XCONCES == 'N'   
			if DateDiffDay( date(),ctod("07/10/1997 ")) > val(SUBSTR(cCodbarras,6,4)) 
				cMsg := "Boleto jแ estแ vencido. "
				Aviso('Aten็ใo!',cMsg,{'Ok'}) 
		    	Return(.T.)		
			endif
		endif  
		
		// Comentado por Wellington Gon็alves dia 08/01/2015
		// Nใo serแ preciso validar se a data de vencimento do boleto ้ igual เ data de vencimento do tํtulo
		/*
		//valida data digitada com a data do codigo de barras
		if !EMPTY(M->E2_VENCTO)
			if SUBSTR(cCodbarras,6,4) <> "0000"
				IF CVALTOCHAR(DateDiffDay( M->E2_VENCTO,ctod("07/10/1997 "))) <> SUBSTR(cCodbarras,6,4)
					cMsg := "Data de Vencimento estแ diferente do codigo de barras. "
					Aviso('Aten็ใo!',cMsg,{'Ok'}) 
			    	Return(.T.)
				ENDIF
			endif
		Else 
			cMsg := "Preencher o campo vencimento primeiro"
			Aviso('Aten็ใo!',cMsg,{'Ok'}) 
	    	Return(.T.)	
		endif
		*/
		
		//valida valores digitados com a linha do codigo de barras
		if !empty(M->E2_VALOR)
		    
		    // se o tํtulo nใo for de cartใo de cr้dito e concessionaria valido o valor
		    if M->E2_XCARTAO <> 'S'  .AND. 	M->E2_XCONCES == 'N' 
			
				// Alterado por Wellington Gon็alves dia 08/01/2015 para considerar o valor de acr้scimo e decr้simo do tํtulo
				nValTit := (M->E2_VALOR + M->E2_ACRESC) - M->E2_DECRESC
				 
				if strzero(val(str(int(nValTit))+iif(AT(".",str(nValTit)) > 0,;
				iif(len(SUBSTR(str(nValTit), AT(".",str(nValTit)) +1,2)) == 1,SUBSTR(str(nValTit);
				, AT(".",str(nValTit)) +1,2)+"0",SUBSTR(str(nValTit), AT(".",str(nValTit)) +1,2)),"00")),10) <> substr(cCodbarras,10,10) 
					cMsg := "Valor do Titulo estแ diferente do c๓digo de barras."
					Aviso('Aten็ใo!',cMsg,{'Ok'}) 
			    	Return(.T.)
				endif    
			
			endif
			
		ELSE
			cMsg := "Preencher o campo Vlr. Titulo"
			Aviso('Aten็ใo!',cMsg,{'Ok'}) 
	    	Return(.T.)	
		ENDIF 
		
		cQuery := " Select *
		cQuery += " From "+RetSqlName("SE2")
		cQuery += " WHERE D_E_L_E_T_ = ''
		cQuery += " AND E2_CODBAR LIKE '%"+cCodbarras+"%'
		
		cQuery := Changequery(cQuery)           
 
		TCQUERY cQuery NEW ALIAS "QAux"
		DbSelectArea("QAux") 
		QAUX->(DbGoTop())
		
		if Empty(QAux->E2_CODBAR)
		      M->E2_CODBAR := cCodbarras
		else 
			cMsg := "Este C๓digo de barras jแ foi utilizado no seguinte titulo: "+CRLF
			cMsg +=  QAux->E2_NUM+IIF(empty(QAux->E2_PARCELA)," ","/"+QAux->E2_PARCELA)+" "+TRANSFORM( QAux->E2_VALOR,'@E 9999,999,999,999.99' ) +CRLF //"+STOD(DTOC(QAux->E2_VENCREA))+" 
			cMsg += ALLTRIM(QAux->E2_NOMFOR)
			Aviso('Aten็ใo!',cMsg,{'Ok'})
		ENDIF
		QAux->(dbclosearea())
	EndIf
EndIf

//COMENTANDO POR JONATAS
/*
If Alltrim(ReadVar())= "M->E2_CODBAR"
	If Empty(M->E2_CODBAR)
		M->E2_CODBAR := U_LeCodBar({M->E2_PREFIXO,M->E2_NUM,M->E2_PARCELA,M->E2_VENCREA,M->E2_VALOR})
	EndIf
EndIf
*/
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldLinDig บAutor  ณEdi Nei Goetz       บ Data ณ  22/02/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que realiza a validacao do conteudo da Linha Digita- บฑฑ
ฑฑบ          ณvel.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFinanceiro                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldLinDig()
Local lRet := .T.
Local nTam := 47

If Empty(cLinDig)
	Return(.T.)
EndIf

//If Len(AllTrim(cLinDig)) < nTam
//	lRet := .F.
//	Aviso('Aten็ใo!','Linha digitแvel estแ incompleta',{'<< Voltar'})
//EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuValor  บAutor  ณEdi Nei Goetz       บ Data ณ  25/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que realiza o calculo de acrescimo e decrescimo do   บฑฑ
ฑฑบ          ณvalor original do titulo.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFinanceiro                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuValor()
Local lRet := .T.

nSaldo := ( nValor + nAcres ) - nDecres

Return(lRet)
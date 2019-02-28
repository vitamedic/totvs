#include 'protheus.ch'
#INCLUDE "UFINR190.CH"
/*/{Protheus.doc} vit456
(long_description)
@author    stephen.ribeiro
@since     29/06/2018
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
Static lFWCodFil := FindFunction("FWCodFil")
STATIC lUnidNeg	:= Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR190  � Autor � Adrianne Furtado      � Data � 02.09.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o das baixas                                         ���
�������������������������������������������������������������������������Ĵ��       
���Sintaxe   � FINR190(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������                                        
/*/
User Function UFinR190()

Local oReport:= Nil   
Private cChaveInterFun := ""

/* GESTAO - inicio */
Private aSelFil	:= {}
/* GESTAO - fim */

//������������������������������������������������������������������������Ŀ
//�Atualizar o as perguntas "Codigo de" e "Codigo At�" para n�o estavam no �
//�grupo SXG do codigo de Cliente/Fornecedor s� retirar na proxima vers�o  �
//��������������������������������������������������������������������������

FR190ATSX1()

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	u_FinR190R3()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Nereu Humberto Junior  � Data �16.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport	:= Nil
Local oSection	:= Nil
Local oCell		:= Nil        
Local nPlus		:= 0  
Local oBaixas	:= Nil
//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New("FINR190",STR0009,"FIN190", {|oReport| ReportPrint(oReport)},STR0006+" "+STR0007+" "+STR0008) //"Relacao de Amarracao Grupo x Fornecedor"##"Este programa tem como objetivo , relacionar os Grupos e seus"##"respectivos Fornecedores."

AjustaSX1()

Pergunte("FIN190",.F.)

oReport:SetLandScape()

/* GESTAO - inicio */
oReport:SetUseGC(.F.) 
oReport:SetGCVPerg( .F. )
/* GESTAO - fim */ 

oBaixas := TRSection():New(oReport,STR0072,{"SE5","SED"},{STR0001,STR0002,STR0003,STR0004,STR0032,STR0005,STR0036,STR0048}) //"Baixas"
// ORDEM:
/*"Por Data" "Por Banco" "Por Natureza" "Alfabetica"
"Nro. Titulo" "Dt.Digitacao" " Por Lote" "Por Data de Credito"*/

oBaixas:SetTotalInLine(.F.)

TRCell():New(oBaixas,"E5_PREFIXO"	,, STR0049,,TamSx3("E5_PREFIXO")[1], .F.)	//"Prf"

If "PTG/MEX" $ cPaisLoc
	TRCell():New(oBaixas,"E5_NUMERO" 	,, STR0050,,TamSx3("E5_NUMERO")[1]+18,.F.)	//"Numero"
Else
	TRCell():New(oBaixas,"E5_NUMERO" 	,, STR0050,,TamSx3("E5_NUMERO")[1]+2,.F.)	//"Numero"
Endif

If cPaisLoc == "BRA"
	nPlus := 5
Else
	nPlus := 3
Endif
TRCell():New(oBaixas,"E5_PARCELA"	,, STR0051,,TamSx3("E5_PARCELA")[1], .F.)	//"Prc"
TRCell():New(oBaixas,"E5_TIPODOC"	,, STR0052,,TamSx3("E5_TIPODOC")[1], .F.)	//"TP"
TRCell():New(oBaixas,"E5_CLIFOR"	,, STR0053,,TamSx3("E5_CLIFOR")[1] + 1, .F.)	//"Cli/For"
TRCell():New(oBaixas,"NOME CLI/FOR"	,, STR0054,,15, .F.)	//"Nome Cli/For"
TRCell():New(oBaixas,"E5_NATUREZ"	,, STR0055,,11, .F.)	//"Natureza"
TRCell():New(oBaixas,"E5_VENCTO"	,, STR0056,,TamSx3("E5_VENCTO")[1] + 2, .F.)	//"Vencto"
TRCell():New(oBaixas,"E5_HISTOR"	,, STR0057,, TamSx3("E5_HISTOR")[1]/2+1, .F.,,,.T.)	//"Historico"
TRCell():New(oBaixas,"E5_DATA"		,, STR0058,,TamSx3("E5_DATA")[1] + 2, .F.)	//"Dt Baixa"
TRCell():New(oBaixas,"E5_VALOR"		,, STR0059,, TamSX3("E5_VALOR")[1]+nPlus	,/*[lPixel]*/,,"RIGHT",,"RIGHT")	//"Valor Original"
TRCell():New(oBaixas,"JUROS/MULTA"	,, STR0060,, TamSX3("E5_VLJUROS")[1],/*[lPixel]*/,,"RIGHT",,"RIGHT")//"Jur/Multa"
TRCell():New(oBaixas,"CORRECAO"		,, STR0061,, TamSX3("E5_VLCORRE")[1],/*[lPixel]*/,,"RIGHT",,"RIGHT")//"Correcao"
TRCell():New(oBaixas,"DESCONTO"		,, STR0062,, TamSX3("E5_VLDESCO")[1],/*[lPixel]*/,,"RIGHT",,"RIGHT")//"Descontos"
TRCell():New(oBaixas,"ABATIMENTO"	,, STR0063,, TamSX3("E5_VLDESCO")[1],/*[lPixel]*/,,"RIGHT",,"RIGHT")//"Abatim."
TRCell():New(oBaixas,"IMPOSTOS"		,, STR0064,, TamSX3("E5_VALOR")[1]	,/*[lPixel]*/,,"RIGHT",,"RIGHT")	//"Impostos"
TRCell():New(oBaixas,"E5_VALORPG"	,, STR0065,, TamSX3("E5_VALOR")[1]+nPlus,/*[lPixel]*/,,"RIGHT",,"RIGHT")//"Total Baixado"
TRCell():New(oBaixas,"E5_BANCO"		,, STR0066,, TamSX3("E5_BANCO")[1]+1,.f.)	//"Bco"
TRCell():New(oBaixas,"E5_DTDIGIT"	,, STR0067,,10, .f.)	//"Dt Dig."
TRCell():New(oBaixas,"E5_MOTBX"		,, STR0068,,3, .f.)	//"Mot"
TRCell():New(oBaixas,"E5_ORIG"		,, STR0069,,FWSizeFilial()+2, .f.)	//"Orig"

oBaixas:SetNoFilter({"SED"})

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Nereu Humberto Junior  � Data �16.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)
Local oBaixas	:= oReport:Section(1)
Local nOrdem	:= oReport:Section(1):GetOrder() 
Local cAliasSE5	:= "SE5"
Local cTitulo 	:= "" 
Local cSuf		:= LTrim(Str(mv_par12))
Local cMoeda	:= GetMv("MV_MOEDA"+cSuf)     
Local cCondicao	:= "" 
Local cCond1 	:= ""
Local cChave 	:= ""
Local bFirst
Local oBreak1, oBreak2  := Nil
Local nDecs	   	:= GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local cAnterior, cAnt     
Local aRelat	:={}	   
Local nI  := 1           
Local lVarFil	:= (mv_par17 == 1 .and. SM0->(Reccount()) > 1	) // Cons filiais abaixo
Local nTotBaixado := 0                 
Local aTotais	:={}
Local cTotText	:=	""    
Local nGerOrig	:= 0
Local nRegSM0 := SM0->(Recno())
Local nRegSE5 := SE5->(Recno())
Local nJ		:= 1
Local lMultiNat := .F.
Private cNomeArq

cFilterUser := ""       
AjustaSx1() 

/* GESTAO - inicio */
If MV_PAR40 == 1
	If Empty(aSelFil)
	aSelFil := AdmGetFil(.F.,.F.,"SE5")
		If Empty(aSelFil)
		   Aadd(aSelFil,cFilAnt)
		Endif
	Endif
Else
	Aadd(aSelFil,cFilAnt)
Endif

lVarFil := Len(aSelFil) > 1

/* GESTAO - fim */

//��������������������������������Ŀ
//� Defini��o dos cabe�alhos       �
//����������������������������������
If mv_par11 == 1
	cTitulo := STR0011 + cMoeda  //"Relacao dos Titulos Recebidos em "
Else
	cTitulo := STR0013 + cMoeda  //"Relacao dos Titulos Pagos em "
EndIf

/*���������������������������������Ŀ
//�aRelat[x][01]: Prefixo			�
//�         [02]: Numero 			�
//�         [03]: Parcela			�
//�         [04]: Tipo do Documento	�
//�         [05]: Cod Cliente/Fornec�
//�         [06]: Nome Cli/Fornec	�
//�         [07]: Natureza         	�
//�         [08]: Vencimento       	�
//�         [09]: Historico       	�
//�         [10]: Data de Baixa    	�
//�         [11]: Valor Original   	�
//�         [12]: Jur/Multa        	�
//�         [13]: Correcao         	�
//�         [14]: Descontos        	�
//�         [15]: Abatimento       	�
//�         [16]: Impostos         	�
//�         [17]: Total Pago       	�
//�         [18]: Banco            	�
//�         [19]: Data Digitacao   	�
//�         [20]: Motivo           	�
//�         [21]: Filial de Origem 	�
//�         [22]: Filial            �      
//�         [23]: E5_BENEF - cCliFor�
//�         [24]: E5_LOTE          	� 
//�         [25]: E5_DTDISPO        � 
//�         [29]: R_E_C_N_O_SE5     � 
//�����������������������������������*/

aRelat := FA190ImpR4(nOrdem,@aTotais,oReport,@nGerOrig,@lMultiNat)

If Len(aRelat) = 0
	Return Nil
EndIf

Do Case
Case nOrdem == 1
	nCond1  := 10
	cTitulo += STR0015  //" por data de pagamento"
Case nOrdem == 2
	nCond1  := 18
	cTitulo += STR0016 // " por Banco"
Case nOrdem == 3
	nCond1  := 7
	cTitulo += STR0017  //" por Natureza"
Case nOrdem == 4
	nCond1  := 23 //E5_BENEF   
	cTitulo += STR0020  //" Alfabetica"
Case nOrdem == 5
	nCond1  := 2
	cTitulo += STR0035 //" Nro. dos Titulos"
Case nOrdem == 6	//Ordem 6 (Digitacao)
	nCond1  := 19
	cTitulo += STR0019  //" Por Data de Digitacao"
Case nOrdem == 7 // por Lote
	nCond1  := 24	//"E5_LOTE"
	cTitulo += STR0036  //" por Lote"
OtherWise						// Data de Cr�dito (dtdispo)
	nCond1  := 25	//"E5_DTDISPO"
	cTitulo += STR0015  //" por data de pagamento"
EndCase

If !Empty(mv_par28) .And. ! ";" $ mv_par28 .And. Len(AllTrim(mv_par28)) > 3
	ApMsgAlert(STR0073)//"Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres"
	Return(Nil)
Endif	
If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert(STR0074)//"Separe os tipos que n�o deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres"
	Return(Nil)
Endif	

//Validacao no array para que seus tipos nao gerem error log
//no exec block em TrPosition()
aEval(aRelat, {|e| Iif( e[5] == Nil, e[5] := "", .T. )} )
//������������������������������������������������������������������������Ŀ
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento ser�     �
//�realizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//�                                                                        �				
//��������������������������������������������������������������������������
TRPosition():New(oBaixas,"SED",1,{|| xFilial("SED")+SE5->E5_NATUREZ })
//**************************************************
// Bloco comentado pela chave do SE5 utilizada n�o *
// esta completa. Este sendo utilizado o nRecSe5.  *
//**************************************************
//If !((MV_MULNATR .and. mv_par11 = 1 .and. mv_par38 = 2 .and. !mv_par39 == 2) .or. (MV_MULNATP .and. mv_par11 = 2 .and. mv_par38 = 2 .and. !mv_par39 == 2) )
//	TRPosition():New(oBaixas,"SE5",7,{|| xFilial("SE5") + aRelat[nI,01]+ aRelat[nI,02]+ aRelat[nI,03]+ aRelat[nI,04]+ aRelat[nI,05]})
//EndIf	
//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
oBaixas:Cell("E5_PREFIXO")	:SetBlock( { || aRelat[nI,01] } )
oBaixas:Cell("E5_NUMERO")	:SetBlock( { || aRelat[nI,02] } )
oBaixas:Cell("E5_PARCELA")	:SetBlock( { || aRelat[nI,03] } )
oBaixas:Cell("E5_TIPODOC")	:SetBlock( { || aRelat[nI,04] } )
oBaixas:Cell("E5_CLIFOR")	:SetBlock( { || aRelat[nI,05] } )
oBaixas:Cell("NOME CLI/FOR"):SetBlock( { || aRelat[nI,06] } )
oBaixas:Cell("E5_NATUREZ")	:SetBlock( { || aRelat[nI,07] } )
oBaixas:Cell("E5_VENCTO")	:SetBlock( { || aRelat[nI,08] } )
oBaixas:Cell("E5_HISTOR")	:SetBlock( { || aRelat[nI,09] } )
oBaixas:Cell("E5_DATA")		:SetBlock( { || aRelat[nI,10] } )
oBaixas:Cell("E5_VALOR")    :SetBlock( { || aRelat[nI,11] } )
oBaixas:Cell("JUROS/MULTA") :SetBlock( { || aRelat[nI,12] } )
oBaixas:Cell("CORRECAO")    :SetBlock( { || aRelat[nI,13] } )
oBaixas:Cell("DESCONTO")    :SetBlock( { || aRelat[nI,14] } )
oBaixas:Cell("ABATIMENTO")  :SetBlock( { || aRelat[nI,15] } )
oBaixas:Cell("IMPOSTOS")    :SetBlock( { || aRelat[nI,16] } )
oBaixas:Cell("E5_VALORPG")  :SetBlock( { || aRelat[nI,17] } )
oBaixas:Cell("E5_BANCO")    :SetBlock( { || aRelat[nI,18] } )
oBaixas:Cell("E5_DTDIGIT")  :SetBlock( { || aRelat[nI,19] } )
oBaixas:Cell("E5_MOTBX")    :SetBlock( { || aRelat[nI,20] } )
oBaixas:Cell("E5_ORIG")     :SetBlock( { || aRelat[nI,21] } )

oBaixas:SetHeaderPage()    

	If (nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8)
		oBreak1 := TRBreak():New( oBaixas, { || aRelat[nI][22]+DToS(aRelat[nI][nCond1]) }, STR0071) //"Sub Total"
		oBreak1:SetTotalText({ || cTotText })	 //"Sub Total"             
	Else //nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 4 .or. nOrdem == 5 .or. nOrdem == 7
		oBreak1 := TRBreak():New( oBaixas, { || aRelat[nI][22]+aRelat[nI][nCond1] }, STR0071) //"Sub Total"
		oBreak1:SetTotalText({ || cTotText })	 //"Sub Total"
	EndIf
	
	
//             New(<oParent>                       , [cID], <cFunction>, [oBreak], [cTitle], [cPicture], [uFormula], [lEndSection], [lEndReport]) --> NIL
TRFunction():New(oBaixas:Cell("E5_VALOR")	 	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("E5_VALOR")  :nSize,nDecs), {|| aRelat[nI,11]}/*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("JUROS/MULTA")	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA") :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("CORRECAO")	 	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("CORRECAO")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("DESCONTO")	 	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("DESCONTO")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("ABATIMENTO") 	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("IMPOSTOS")	 	,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("IMPOSTOS")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"
TRFunction():New(oBaixas:Cell("E5_VALORPG")	    ,/*[cID*/, "SUM", oBreak1  , STR0071, tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs), {|| aRelat[nI][27]}/*[ uFormula ]*/ , .F., .F.,.F.) //"Sub Total"


//����������������������������������������Ŀ
//� Imprimir TOTAL por filial somente quan-�
//� do houver mais do que 1 filial.        �
//������������������������������������������
If lVarFil .And. !Empty(FWFilial("SE5"))
	oBreak2 := TRBreak():New( oBaixas, { || aRelat[nI][22] }, STR0070) //"FILIAL"
	TRFunction():New(oBaixas:Cell("E5_VALOR")	 	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("E5_VALOR")  :nSize,nDecs), {|| aRelat[nI,11]}/*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("JUROS/MULTA")	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA") :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("CORRECAO")	 	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("CORRECAO")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("DESCONTO")	 	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("DESCONTO")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("ABATIMENTO") 	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs), /*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("IMPOSTOS")	 	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("IMPOSTOS")  :nSize,nDecs), /*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	TRFunction():New(oBaixas:Cell("E5_VALORPG")	,/*[cID*/, "SUM", oBreak2  , STR0070, tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs), {|| aRelat[nI][27]}/*[ uFormula ]*/ , .F., .F.) //"FILIAL"
	oBreak2:SetTotalText({ || STR0070 + " : " + cTxtFil })	 //"FILIAL"
EndIf

oBaixas:Cell("E5_VALOR")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("E5_VALOR")  :nSize,nDecs))
oBaixas:Cell("JUROS/MULTA"):SetPicture(tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA"):nSize,nDecs))
oBaixas:Cell("CORRECAO")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("CORRECAO")  :nSize,nDecs))
oBaixas:Cell("DESCONTO")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("DESCONTO")  :nSize,nDecs))
oBaixas:Cell("ABATIMENTO")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("ABATIMENTO"):nSize,nDecs))
oBaixas:Cell("IMPOSTOS")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("IMPOSTOS")  :nSize,nDecs))
oBaixas:Cell("E5_VALORPG")	:SetPicture(tm(E5_VALOR,oBaixas:Cell("E5_VALORPG"):nSize,nDecs))


//����������������������������������������Ŀ
//Total Geral
//����������������������������������������Ŀ
oBreak3 := TRBreak():New( oBaixas, { || }, STR0029) //"Total Geral"
TRFunction():New(oBaixas:Cell("E5_VALOR")		,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("E5_VALOR")		:nSize,nDecs), {|| If(aRelat[nI,26],aRelat[nI,11],0) }/*[ uFormula ]*/ , .F., .F.,.F.)
TRFunction():New(oBaixas:Cell("JUROS/MULTA")	,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("JUROS/MULTA")	:nSize,nDecs), {|| aRelat[nI,12]}/*[ uFormula ]*/ , .F., .F.,.F.)
TRFunction():New(oBaixas:Cell("CORRECAO")		,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("CORRECAO")  	:nSize,nDecs), {|| If(aRelat[nI,26],aRelat[nI,13],0) }/*[ uFormula ]*/ , .F., .F.,.F.) 
TRFunction():New(oBaixas:Cell("DESCONTO")	 	,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("DESCONTO")  	:nSize,nDecs), {|| If(aRelat[nI,26] .Or. aRelat[nI,14] > 0,aRelat[nI,14],0) }/*[ uFormula ]*/ , .F., .F.,.F.) 
TRFunction():New(oBaixas:Cell("ABATIMENTO")	,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("ABATIMENTO")	:nSize,nDecs), {|| If(aRelat[nI,26],aRelat[nI,15],0) }/*[ uFormula ]*/ , .F., .F.,.F.)
TRFunction():New(oBaixas:Cell("IMPOSTOS")	 	,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("IMPOSTOS")  	:nSize,nDecs), {|| If(aRelat[nI,26],aRelat[nI,16],0) }/*[ uFormula ]*/ , .F., .F.,.F.) 
TRFunction():New(oBaixas:Cell("E5_VALORPG")	,/*[cID*/, "SUM", oBreak3  , "", tm(E5_VALOR,oBaixas:Cell("E5_VALORPG")  	:nSize,nDecs), {|| aRelat[nI,27] }/*[ uFormula ]*/ , .F., .F.,.F.)

If !Empty(cFilterUser)
	oBaixas:SetFilter(cFilterUser)
EndIf
                        
oReport:SetTitle(cTitulo)
oReport:SetMeter(Len(aRelat))  

oBaixas:Init()                  	
nI := 1
While nI <= Len(aRelat)

	If oReport:Cancel()
		nI++
		Exit
	EndIf

	//Retirada tratativa pois o RECNO da SE5 a partir da vers�o 10 � gravado somente na posi��o 29 independente do t�tulo ser multinatureza
	If !Empty(aRelat[nI,29])
		SE5->(dbGoto(aRelat[nI,29]))
	EndIf
	  
	//�����������������������������������������������Ŀ
	//�Posiciona na Filial do Movimento a ser impresso�
	//�������������������������������������������������
  	//cFilAnt := SE5->E5_FILIAL
   oReport:IncMeter()
	oBaixas:PrintLine()

	If (nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8)
		cTotText := STR0071 + " : " + DToC(aRelat[nI][nCond1]) //"Sub Total"
	Else //nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 4 .or. nOrdem == 5 .or. nOrdem == 7
		cTotText := STR0071 + " : " + aRelat[nI][nCond1]       //"Sub Total"
		If nOrdem == 2 //Banco
			SA6->(DbSetOrder(1))
			SA6->(MsSeek(xFilial("SA6")+aRelat[nI][nCond1] + aRelat[nI][30]+aRelat[nI][31] ))
			cTotText += " " + TRIM(SA6->A6_NOME)
		ElseIf nOrdem == 3 //Natureza
			SED->(DbSetOrder(1))
			SED->(MsSeek(xFilial("SED")+ StrTran (aRelat[nI][nCond1],".","")))
			cTotText += SED->ED_DESCRIC
		EndIf
	EndIf
	
	If lVarFil
		cTxtFil := aRelat[nI][22]
	EndIf               

	nI++

EndDo
SE5->(dbGoto(nRegSE5))
SM0->(dbGoTo(nRegSM0))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//nao retirar "nI--" pois eh utilizado na impressao do ultimo TRFunction
nI--

oBaixas:Finish()
PRINTTOT(aTotais,oReport,.F.,3,@nJ)

Return NIL


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PRINTTOT � Autor � Daniel Tadashi Batori � Data � 10.10.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime os totais "Baixados", "Mov Fin.", "Compens."       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � PRINTTOT(aTotal,oReport,lFil)                              ���
���          � aTotais -> array a ser utilizado para impressao            ���
���          � oReport -> objeto TReport                                  ���
���          � lFil -> .F. se for total da secao ou .T. se for da filial  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PRINTTOT(aTotais,oReport,lFil,nBreak,nJ)
Local nDecs := GetMv("MV_CENT"+(If(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local cAnt := ""
Local nAscan := 0 
Local cGeral := OemToAnsi(STR0075)
Local nTamAnt:= 0
Default nJ 	 := 1

If lFil == .T.
	oReport:SkipLine(2)
EndIf

nAscan := Ascan(aTotais , {|e| Alltrim(e[1]) ==  cGeral } )

If nBreak <> 3
	If Len(aTotais)>0
		If (MV_MULNATP .Or. MV_MULNATR) .And. !(aTotais[nJ][1] $ "/") .And. Len(aTotais[nJ]) > 3
			cAnt := aTotais[nJ][4]      
		Else
			cAnt := aTotais[nJ][1]
		EndIf
	EndIf

	While (( Iif(( ValType(cAnt) <> ValType(aTotais[nJ][1]) .And. Len(aTotais[nJ] ) == 3 ), "" , cAnt ) ) == ( Iif((( MV_MULNATP .Or. MV_MULNATR) .And. !(aTotais[nJ][1] $ "/") .And. Len(aTotais[nJ]) > 3 ), aTotais[nJ][4], aTotais[nJ][1] ) ) .and. (nJ < nAscan) )
        nTamAnt := Len(aTotais[nJ] )
		oReport:PrintText( PadR(aTotais[nJ][2],12," ") + Transform(aTotais[nJ][3], tm(aTotais[nJ][3],20,nDecs) ) )
		nJ++
		If nTamAnt < Len(aTotais[nJ]) 
		// significa quebra de filial. Antes, com print de total de filial, o tamanho � 3, com este proximo total de outra filial, tamanho ser� 4
			Exit
		Endif
	EndDo
Else    
	oReport:PrintText( '' )	
	While nAscan > 0 
		oReport:PrintText( PadR(aTotais[nAscan][2],12," ") + Transform(aTotais[nAscan][3], tm(aTotais[nAscan][3],20,nDecs) ) )
		nAscan := If( (nAscan+1)<=Len(aTotais) .and. aTotais[nAscan+1][1] == cGeral,nAscan+1,0)
	EndDo
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR190  � Autor � Wagner Xavier         � Data � 05.10.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o das baixas                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FINR190(void)                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FinR190R3()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������

Local wnrel
Local aOrd:={OemToAnsi(STR0001),OemToAnsi(STR0002),OemToAnsi(STR0003),OemToAnsi(STR0004),OemToAnsi(STR0032),OemToAnsi(STR0005),OemToAnsi(STR0036),STR0048}  //"Por Data"###"Por Banco"###"Por Natureza"###"Alfabetica"###"Nro. Titulo"###"Dt.Digitacao"###"Por Lote" //"Por Data de Credito"
Local cDesc1 := STR0006  //"Este programa ir� emitir a rela��o dos titulos baixados."
Local cDesc2 := STR0007  //"Poder� ser emitido por data, banco, natureza ou alfab�tica"
Local cDesc3 := STR0008  //"de cliente ou fornecedor e data da digita��o."
Local tamanho:="G"
Local cString:="SE5"

Private titulo:=OemToAnsi(STR0009)  //"Relacao de Baixas"
Private cabec1
Private cabec2
Private cNomeArq
Private aReturn := { OemToAnsi(STR0010), 1,OemToAnsi(STR0030), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog:="FINR190"
Private aLinha  := { },nLastKey := 0
Private cPerg   :="FIN190"

ajustasx1()
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("FIN190",.F.)

//����������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                     �
//� mv_par01            // da data da baixa                  �
//� mv_par02            // at� a data da baixa               �
//� mv_par03            // do banco                          �
//� mv_par04            // at� o banco                       �
//� mv_par05            // da natureza                       �
//� mv_par06            // at� a natureza                    �
//� mv_par07            // do c�digo                         �
//� mv_par08            // at� o c�digo                      �
//� mv_par09            // da data de digita��o              �
//� mv_par10            // ate a data de digita��o           �
//� mv_par11            // Tipo de Carteira (R/P)            �
//� mv_par12            // Moeda                             �
//� mv_par13            // Hist�rico: Baixa ou Emiss�o       �
//� mv_par14            // Imprime Baixas Normais / Todas    �
//� mv_par15            // Situacao                          �
//� mv_par16            // Cons Mov Fin                      �
//� mv_par17            // Cons filiais abaixo               �
//� mv_par18            // da filial                         �
//� mv_par19            // ate a filial                      �
//� mv_par20            // Do Lote                           �
//� mv_par21            // Ate o Lote                        �
//� mv_par22            // da loja                           �
//� mv_par23            // Ate a loja                        � 
//� mv_par24            // NCC Compensados                   �
//� mv_par25            // Outras Moedas                     � 
//� mv_par26            // do prefixo                        �
//� mv_par27            // at� o prefixo                     �
//� mv_par28            // Imprimir os Tipos                 �
//� mv_par29            // Nao Imprimir Tipos			       �
//� mv_par30            // Imprime nome (Normal ou reduzido) �
//� mv_par31            // da data da vencto. do tit         �
//� mv_par32            // at� a data de vencto do tit.      �
//� mv_par33            // da filial origem                  �
//� mv_par34            // ate filial origem                 �
//� mv_par35            // Impr.Incl. Adiantamentos ?Sim/Nao �
//� mv_par36            // Imprime Titulos em Carteira ?     |
//� mv_par37            // Imp. mov. cheque aglutinado?Cheque/Baixa/Ambos�
//� mv_par38            // Cons. Nat. Aglutinadas? Sim/Nao   |
//| mv_par39            // Filtrar Natureza Por?             |
//|                                  - Padrao                |
//|                                  - Nat.Principal         |
//|                                  - Mult.Naturezas        |
//������������������������������������������������������������
//����������������������������������������������������������Ŀ
//� Envia controle para a fun��o SETPRINT                    �
//������������������������������������������������������������
wnrel := "FINR190"            //Nome Default do relat�rio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return(Nil)
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return(Nil)
EndIf

cFilterUser := aReturn[7]

RptStatus({|lEnd| Fa190Imp(@lEnd,wnRel,cString)},Titulo)
Return(Nil)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA190Imp � Autor � Wagner Xavier         � Data � 05.10.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o das baixas                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA190Imp(lEnd,wnRel,cString)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd    - A��o do Codeblock                                ���
���          � wnRel   - T�tulo do relat�rio                              ���
���          � cString - Mensagem                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Gen�rico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FA190Imp(lEnd,wnRel,cString)

Local cExp 			:= ""
Local CbTxt,CbCont
Local nValor:=0,nDesc:=0,nJuros:=0,nMulta:=0,nJurMul:=0,nCM:=0,dData,nVlMovFin:=0
Local nTotValor:=0,nTotDesc:=0,nTotJurMul:=0,nTotCm:=0,nTotOrig:=0,nTotBaixado:=0,nTotMovFin:=0,nTotComp:=0,nTotFat:=0,nTotPOrig:=0
Local nGerValor:=0,nGerDesc:=0,nGerJurMul:=0,nGerCm:=0,nGerOrig:=0,nGerBaixado:=0,nGerMovFin:=0,nGerComp:=0,nGerFat:=0
Local nFilOrig:=0,nFilJurMul:=0,nFilCM:=0,nFilDesc:=0
Local nFilAbLiq:=0,nFilAbImp:=0,nFilValor:=0,nFilBaixado:=0,nFilMovFin:=0,nFilComp:=0, nFilFat:=0
Local nAbatLiq := 0,nTotAbImp := 0,nTotImp := 0,nTotAbLiq := 0,nGerAbLiq := 0,nGerAbImp := 0
Local cBanco,cNatureza,cAnterior,cCliFor,nCT:=0,dDigit,cLoja
Local lContinua		:=.T.
Local lBxTit		:=.F.
Local lBxLoja		:=.F.			//Verifica se o titulo foi baixado pelo loja e tem a excecao do MV_LJTROCO = .T.
Local tamanho		:="G"
Local aCampos:= {},cNomArq1:="",nVlr,cLinha,lOriginal:=.T.
Local nAbat 		:= 0
Local cHistorico
Local lManual 		:= .f.
Local cTipodoc
Local nRecSe5 		:= 0
Local dDtMovFin
Local cRecPag
Local nRecEmp 		:= SM0->(Recno())
Local cMotBaixa		:= CRIAVAR("E5_MOTBX")
Local cFilNome 		:= Space(15)
Local cCliFor190	:= ""
Local aTam 			:= IIF(mv_par11 == 1,TamSX3("E1_CLIENTE"),TamSX3("E2_FORNECE"))
Local aColu 		:= {}
Local nDecs	   		:= GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local nMoedaBco		:= 1
Local cCarteira
#IFDEF TOP
	Local aStru		:= SE5->(DbStruct()), nI
	Local cQuery
#ENDIF	
Local cFilTrb
Local lAsTop		:= .F.
Local cFilSe5		:= ".T."
Local cChave, bFirst
Local cFilOrig
Local lAchou		:= .F.
Local lF190Qry		:= ExistBlock("F190QRY")
Local cQueryAdd		:= ""
Local lAjuPar15		:= Len(AllTrim(mv_par15))==Len(mv_par15)
Local lAchouEmp		:= .T.                                
Local lAchouEst		:= .F.                                
Local nTamEH		:= TamSx3("EH_NUMERO")[1]
Local nTamEI		:= TamSx3("EI_NUMERO")[1]+TamSx3("EI_REVISAO")[1]+TamSx3("EI_SEQ")[1]
Local cCodUlt		:= SM0->M0_CODIGO
Local cFilUlt		:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Local nRecno  
Local nSavOrd 
Local aAreaSE5 
Local cChaveNSE5	:= ""
Local nRecSE2		:= 0
Local aAreaSE2
Local aAreabk

Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local nTaxa:= 0 
Local lUltBaixa := .F.
Local cChaveSE1 := ""
Local cChaveSE5 := ""
Local cSeqSE5 := ""
Local cBancoAnt, cAgAnt, cContaAnt
Local lNaturez := .F.

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emiss�o(default))
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nPccBxCr := 0 
//Controla o Pis Cofins e Csll na RA (1 = Controla reten��o de impostos no RA; ou 2 = N�o controla reten��o de impostos no RA(default))
Local lRaRtImp  := If (FindFunction("FRaRtImp"),FRaRtImp(),.F.)
Local lConsImp := .T.

If R190Perg41()
	If MV_PAR41 == 2   
		lConsImp := .F.
	EndIf
EndIf

Private nIndexSE5	:= 0

//��������������������������������������������������������������Ŀ
//� Vari�veis utilizadas para Impress�o do Cabe�alho e Rodap�    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
nOrdem 	:= aReturn[8]
cSuf	:= LTrim(Str(mv_par12))
cMoeda	:= GetMv("MV_MOEDA"+cSuf)
cCond3	:= ".T."


//��������������������������������Ŀ
//� Defini��o dos cabe�alhos       �
//����������������������������������
If mv_par11 == 1
	titulo := OemToAnsi(STR0011)  + cMoeda  //"Relacao dos Titulos Recebidos em "
	cabec1 := iif(aTam[1] > 6 , OemToAnsi(STR0039),OemToAnsi(STR0012))  //"Cliente-Nome Cliente "###"Prf Numero       P TP Client Nome Cliente       Natureza    Vencto  Historico       Dt Baixa  Valor Original    Tx Permanen         Multa      Correcao     Descontos     Abatimentos    Total Rec. Bco Dt Digit. Mot. Baixa"
	cabec2 := iif(aTam[1] > 6 , OemToAnsi(STR0040),"")  //"                       Prf Numero       P TP     Natureza   Vencto     Historico          Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa"
Else
	titulo := OemToAnsi(STR0013)  + cMoeda  //"Relacao dos Titulos Pagos em "
	cabec1 := iif(aTam[1] > 6 , OemToAnsi(STR0041),OemToAnsi(STR0014))  //"Prf Numero       P TP Fornec Nome Fornecedor    Natureza    Vencto  Historico       Dt Baixa  Valor Original    Tx Permanen         Multa      Correcao     Descontos     Abatimentos    Total Pago Bco Dt Digit. Mot. Baixa"
	cabec2 := iif(aTam[1] > 6 , OemToAnsi(STR0040),"")  //"                       Prf Numero       P TP     Natureza   Vencto     Historico          Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa"
EndIf

//�����������������������������������������������������������Ŀ
//� Atribui valores as variaveis ref a filiais                �
//�������������������������������������������������������������
If mv_par17 == 2
	cFilDe := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilAte:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Else
	cFilDe := mv_par18	// Todas as filiais
	cFilAte:= mv_par19
EndIf
// Definicao das condicoes e ordem de impressao, de acordo com a ordem escolhida pelo
// usuario.
DbSelectArea("SE5")
Do Case
Case nOrdem == 1
	cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
	cCond2 := "E5_DATA"
	cChave := IndexKey(1)
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0015)  //" por data de pagamento"
	bFirst := {|| MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
Case nOrdem == 2
	cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
	cCond2 := "E5_BANCO"
	cChave := IndexKey(3)
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0016) // " por Banco"
	bFirst := {||MsSeek(xFilial("SE5")+mv_par03,.T.)}
Case nOrdem == 3
	cCondicao := "E5_MULTNAT = '1' .Or. (E5_NATUREZ >= mv_par05 .and. E5_NATUREZ <= mv_par06)"
	cCond2 := "E5_NATUREZ"
	cChave := IndexKey(4)
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0017)  //" por Natureza"
	bFirst := {||MsSeek(xFilial("SE5")+mv_par05,.T.)}
Case nOrdem == 4
	cCondicao := ".T."
	cCond2 := "E5_BENEF"
	cChave := "E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0020)  //" Alfabetica"
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 5
	cCondicao := ".T."
	cCond2 := "E5_NUMERO"
	cChave := "E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0035) //" Nro. dos Titulos"
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 6	//Ordem 6 (Digitacao)
	cCondicao := ".T."
	cCond2 := "E5_DTDIGIT"
	cChave := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0019)  //" Por Data de Digitacao"
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 7 // por Lote
	cCondicao := "E5_LOTE >= mv_par20 .and. E5_LOTE <= mv_par21"
	cCond2 := "E5_LOTE"
	cChave := IndexKey(5)
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0036)  //" por Lote"
	bFirst := {||MsSeek(xFilial("SE5")+mv_par20,.T.)}
OtherWise						// Data de Cr�dito (dtdispo)
	cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
	cCond2 := "E5_DTDISPO"
	cChave := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
	cChaveInterFun := cChave
	titulo += OemToAnsi(STR0015)  //" por data de pagamento"
	bFirst := {||MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
EndCase

If !Empty(mv_par28) .And. ! ";" $ mv_par28 .And. Len(AllTrim(mv_par28)) > 3
	ApMsgAlert(STR0073)//"Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	
If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert(STR0074)//"Separe os tipos que n�o deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	

#IFDEF TOP
	If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
		lAsTop := .T.
		cCondicao := ".T."
		DbSelectArea("SE5")
		cQuery := ""
		aEval(DbStruct(),{|e| cQuery += ",SE5."+AllTrim(e[1])})
		// Obtem os registros a serem processados
		cQuery := "SELECT " +SubStr(cQuery,2)
		cQuery +=         ",SE5.R_E_C_N_O_ SE5RECNO, "
		cQuery += " ( SELECT MAX(SE52.E5_SEQ)"
		cQuery +=      "FROM "+RetSqlName("SE5")+ " SE52 "
        cQuery +=     "WHERE SE52.E5_FILIAL  = SE5.E5_FILIAL " 
        cQuery +=      "AND SE52.E5_RECPAG  = SE5.E5_RECPAG "
        cQuery +=      "AND SE52.E5_CLIFOR  = SE5.E5_CLIFOR "
        cQuery +=      "AND SE52.E5_LOJA    = SE5.E5_LOJA "
        cQuery +=      "AND SE52.E5_PREFIXO = SE5.E5_PREFIXO "
        cQuery +=      "AND SE52.E5_NUMERO  = SE5.E5_NUMERO "
        cQuery +=      "AND SE52.E5_PARCELA = SE5.E5_PARCELA "
        cQuery +=      "AND SE52.E5_TIPO    = SE5.E5_TIPO "
        cQuery +=      "AND SE52.E5_SITUACA = SE5.E5_SITUACA "
        cQuery +=      "AND SE52.E5_NATUREZ = SE5.E5_NATUREZ "
        cQuery +=      "AND SE52.D_E_L_E_T_ = ' ' "
        cQuery +=      "AND NOT EXISTS ( "
        cQuery +=      "SELECT A.E5_NUMERO" 
        cQuery +=           "FROM "+RetSqlName("SE5")+ " A" 
        cQuery +=           "WHERE A.E5_FILIAL  = SE52.E5_FILIAL "  
        cQuery +=             "AND A.E5_PREFIXO = SE52.E5_PREFIXO "
        cQuery +=             "AND A.E5_NUMERO  = SE52.E5_NUMERO " 
        cQuery +=             "AND A.E5_PARCELA = SE52.E5_PARCELA " 
        cQuery +=             "AND A.E5_TIPO    = SE52.E5_TIPO " 
        cQuery +=             "AND A.E5_CLIFOR  = SE52.E5_CLIFOR " 
        cQuery +=             "AND A.E5_LOJA    = SE52.E5_LOJA " 
        cQuery +=             "AND A.E5_SEQ     = SE52.E5_SEQ " 
        cQuery +=             "AND A.E5_TIPODOC = 'ES' )  ) MAXSEQ "  //Coluna maxseq	
		cQuery += "FROM " + RetSqlName("SE5")+" SE5 "
		cQuery += "WHERE SE5.E5_RECPAG = '" + IIF( mv_par11 == 1, "R","P") + "' AND "
		cQuery +=       "SE5.E5_DATA    between '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' AND "
		cQuery +=       "SE5.E5_DATA    <= '" + DTOS(dDataBase) + "' AND "

		If cPaisLoc == "ARG" .and. mv_par03 == mv_par04
			cQuery += "      (SE5.E5_BANCO = '" + mv_par03 + "' OR SE5.E5_BANCO = '" + Space(TamSX3("A6_COD")[1]) + "') AND "
		Else
			cQuery += "      SE5.E5_BANCO   between '" + mv_par03       + "' AND '" + mv_par04       + "' AND "		
		EndIf
		If cPaisLoc == "ARG" .and. mv_par11 == 2 // pagar
			cQuery += " (SE5.E5_DOCUMEN != ' ' AND SE5.E5_TIPO != 'CH') AND "
		Endif
		//-- Realiza filtragem pela natureza principal
		If mv_par39 == 2
			cQuery +=  " SE5.E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06     	+ "' AND "
		Else
			cQuery +=  " (SE5.E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06     	+ "' OR "
			cQuery +=  " EXISTS (SELECT SEV.EV_FILIAL, SEV.EV_PREFIXO, SEV.EV_NUM, SEV.EV_PARCELA, SEV.EV_CLIFOR, SEV.EV_LOJA "
			cQuery +=            " FROM "+RetSqlName("SEV")+" SEV "
			cQuery +=           " WHERE SE5.E5_FILIAL  = SEV.EV_FILIAL  AND "
			cQuery +=                  "SE5.E5_PREFIXO = SEV.EV_PREFIXO AND "
			cQuery +=                  "SE5.E5_NUMERO  = SEV.EV_NUM     AND "
			cQuery +=                  "SE5.E5_PARCELA = SEV.EV_PARCELA AND "
			cQuery +=                  "SE5.E5_TIPO    = SEV.EV_TIPO    AND "
			cQuery +=                  "SE5.E5_CLIFOR  = SEV.EV_CLIFOR  AND "
			cQuery +=                  "SE5.E5_LOJA    = SEV.EV_LOJA    AND "
			cQuery +=                  "SEV.EV_NATUREZ between '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
			cQuery +=                  "SEV.D_E_L_E_T_ = ' ')) AND "
		EndIf	
		cQuery += "      SE5.E5_CLIFOR  between '" + mv_par07       + "' AND '" + mv_par08       + "' AND "
		cQuery += "      SE5.E5_DTDIGIT between '" + DTOS(mv_par09) + "' AND '" + DTOS(mv_par10) + "' AND "
		cQuery += "      SE5.E5_LOTE    between '" + mv_par20       + "' AND '" + mv_par21       + "' AND "
		cQuery += "      SE5.E5_LOJA    between '" + mv_par22       + "' AND '" + mv_par23 	    + "' AND "
		cQuery += "      SE5.E5_PREFIXO between '" + mv_par26       + "' AND '" + mv_par27 	    + "' AND "
		cQuery += "      SE5.D_E_L_E_T_ = ' '  AND "
		cQuery += " 	  SE5.E5_SITUACA NOT IN ('C','E','X') AND "
		cQuery += "      ((SE5.E5_TIPODOC = 'CD' AND SE5.E5_VENCTO <= E5_DATA) OR "
		cQuery += "      (SE5.E5_TIPODOC != 'CD')) "
		cQuery += "		  AND SE5.E5_HISTOR NOT LIKE '%"+STR0077+"%'"
		cQuery += "		  AND SE5.E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','ES'"
		If mv_par11 == 2
			cQuery += " ,'E2'"
		EndIf
		If mv_par16 == 2
			cQuery += " ,' '"
			cQuery += " ,'CH'"  
			cQuery += " ,'TR'"  
			cQuery += " ,'TE'"
		endif
		cQuery += " )"
		If mv_par16 == 2
			cQuery += " AND SE5.E5_NUMERO  != '" + SPACE(LEN(E5_NUMERO)) + "'"
		Endif	
		If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
			cQuery += " AND SE5.E5_TIPO IN "+FormatIn(mv_par28,";")
		ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
			cQuery += " AND SE5.E5_TIPO NOT IN "+FormatIn(mv_par29,";")
		EndIf
		
		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"
		
		If mv_par17 == 2
			cQuery += " AND SE5.E5_FILIAL = '" + FwxFilial("SE5") + "'"
		Else
			If Empty( xFilial("SE5") )
				cQuery += " AND SE5.E5_FILORIG between '" + mv_par18 + "' AND '" + mv_par19 + "'"
			Else
				cQuery += " AND SE5.E5_FILIAL between '" + mv_par18 + "' AND '" + mv_par19 + "'"
			EndIf
		Endif
		
		If lF190Qry
			cQueryAdd := ExecBlock("F190QRY", .F., .F., {aReturn[7]})
			If ValType(cQueryAdd) == "C"
				cQuery += " AND (" + cQueryAdd + ")"
			EndIf
		EndIf
		
		// seta a ordem de acordo com a opcao do usuario
		cQuery += " ORDER BY " + STRTRAN(SqlOrder(cChave),"E5_", "SE5.E5_")
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "NEWSE5", .F., .T.)
		For nI := 1 TO LEN(aStru)
			If aStru[nI][2] != "C"
				TCSetField("NEWSE5", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
			EndIf
		Next
		DbGoTop()
	Else
#ENDIF
		//�������������������������������������������������������������Ŀ
		//� Abre o SE5 com outro alias para ser filtrado porque a funcao�
		//� TemBxCanc() utilizara o SE5 sem filtro.							 �
		//���������������������������������������������������������������
		If Select("NEWSE5") == 0 .And. !( ChkFile("SE5",.F.,"NEWSE5") )
			Return(Nil)
		EndIf		
		lAsTop := .F.
		DbSelectArea("NEWSE5")
		cFilSE5 := 'E5_RECPAG=='+IIF(mv_par11 == 1,'"R"','"P"')+'.and.'
		cFilSE5 += 'DTOS(E5_DATA)>='+'"'+dtos(mv_par01)+'"'+'.and.DTOS(E5_DATA)<='+'"'+dtos(mv_par02)+'".and.'
		cFilSE5 += 'DTOS(E5_DATA)<='+'"'+dtos(dDataBase)+'".and.'
		If nOrdem == 3
   			cFilSE5 += '(E5_MULTNAT = "1" .Or. (E5_NATUREZ>='+'"'+mv_par05+'"'+'.and.E5_NATUREZ<='+'"'+mv_par06+'")).and.'
		Else
			cFilSE5 += '(E5_NATUREZ>='+'"'+mv_par05+'"'+'.and.E5_NATUREZ<='+'"'+mv_par06+'").and.'
		Endif		
		cFilSE5 += 'E5_CLIFOR>='+'"'+mv_par07+'"'+'.and.E5_CLIFOR<='+'"'+mv_par08+'".and.'
		cFilSE5 += 'DTOS(E5_DTDIGIT)>='+'"'+dtos(mv_par09)+'"'+'.and.DTOS(E5_DTDIGIT)<='+'"'+dtos(mv_par10)+'".and.'
		cFilSE5 += 'E5_LOTE>='+'"'+mv_par20+'"'+'.and.E5_LOTE<='+'"'+mv_par21+'".and.'
		cFilSE5 += 'E5_LOJA>='+'"'+mv_par22+'"'+'.and.E5_LOJA<='+'"'+mv_par23+'".and.'
		cFilSe5 += 'E5_PREFIXO>='+'"'+mv_par26+'"'+'.And.E5_PREFIXO<='+'"'+mv_par27+'"'
		If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
			cFilSe5 += '.And.E5_TIPO $'+'"'+ALLTRIM(mv_par28)+Space(1)+'"'
		ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
			cFilSe5 += '.And.!(E5_TIPO $'+'"'+ALLTRIM(mv_par29)+Space(1)+'")'
		EndIf

		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"
		
		If mv_par17 == 2
			cFilSe5 +=  " .AND. E5_FILIAL = '" + xFilial("SE5") + "'"
		Else
			If Empty( xFilial("SE5") )
				cFilSe5 += " .AND. E5_FILORIG >= '" + mv_par18 + "' .AND. E5_FILORIG <= '" + mv_par19 + "'"
			Else
				cFilSe5 +=" .AND. E5_FILIAL >= '" + mv_par18 + "' .AND. E5_FILIAL <= '" + mv_par19 + "'"
			EndIf
		Endif
#IFDEF TOP
	Endif
#ENDIF	
// Se nao for TOP, ou se for TOP e for AS400, cria Filtro com IndRegua
// Pois em SQL os registros ja estao filtrados em uma Query
If !lAsTop
	cNomeArq := CriaTrab(Nil,.F.)
	IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi(STR0018))  //"Selecionando Registros..."
Endif

//������������������������������������������Ŀ
//� Define array para arquivo de trabalho    �
//��������������������������������������������
AADD(aCampos,{"LINHA","C",80,0 } )

//����������������������������Ŀ
//� Cria arquivo de Trabalho   �
//������������������������������
cNomArq1 := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq1, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq1,"LINHA",,,OemToAnsi(STR0018))  //"Selecionando Registros..."

aColu := Iif(aTam[1] > 6,{023,027,TamParcela("E1_PARCELA",40,39,38),042,000,022},{000,004,TamParcela("E1_PARCELA",17,16,15),019,023,030})

If MV_PAR16 == 1

	dbSelectArea("SE5")
	dbSetOrder(17) //"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+E5_TIPODOC+E5_SEQ"
	dbGoTop()

Endif

DbSelectArea("SM0")
DbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilNome:= SM0->M0_FILIAL
	DbSelectArea("NEWSE5")
	SetRegua(RecCount())
	// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
	// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
	If !lAsTop
		Eval(bFirst) // Posiciona no primeiro registro a ser processado
	Endif

	If ((MV_MULNATR .and. mv_par11 = 1 .and. mv_par38 = 2 .and. !mv_par39 == 2) .or. (MV_MULNATP .and. mv_par11 = 2 .and. mv_par38 = 2 .and. !mv_par39 == 2) )
	
		Finr199R3(	@nGerOrig,@nGerValor,@nGerDesc,@nGerJurMul,@nGerCM,@nGerAbLiq,@nGerAbImp,@nGerBaixado,@nGerMovFin,@nGerComp,;
					@nFilOrig,@nFilValor,@nFilDesc,@nFilJurMul,@nFilCM,@nFilAbLiq,@nFilAbImp,@nFilBaixado,@nFilMovFin,@nFilComp,;
					lEnd,cCondicao,cCond2,aColu,lContinua,cFilSe5,lAsTop,Tamanho,nOrdem, @nGerFat, @nFilFat)

		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
				dbSelectArea("SE5")
				dbCloseArea()
				ChKFile("SE5")
				dbSelectArea("SE5")
				dbSetOrder(1)
			Endif
		#ENDIF
		If Empty(xFilial("SE5"))
			Exit
		Endif
		dbSelectArea("SM0")
		cCodUlt := SM0->M0_CODIGO
		cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		dbSkip()
		Loop

	Else

		While NEWSE5->(!Eof()) .And. &cCondFil .And. &cCondicao .and. lContinua
			If lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
				lContinua:=.F.
				Exit
			EndIf
			
			IncRegua()
			DbSelectArea("NEWSE5")
			// Testa condicoes de filtro	
			If !u_Fr190TstCond(cFilSe5,.F.)
				NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
				Loop
			Endif						
								 	
			// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
			// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
			If !lAsTop
				SE2->(dbSetOrder(1))
				SE2->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
				If SE2->E2_MULTNAT == '1'
					lNaturez := .F.
					SEV->(dbSetOrder(1))
					SEV->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
					While NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) .and. !lNaturez
						If SEV->EV_NATUREZ >= mv_par05 .and. SEV->EV_NATUREZ <= mv_par06
							lNaturez := .T.
						EndIf
						SEV->(DbSkip())
					EndDo
					If !lNaturez
						NEWSE5->(dbSkip())
						Loop
					EndIf
				Else
					If !(NEWSE5->E5_NATUREZ >= mv_par05 .and. NEWSE5->E5_NATUREZ <= mv_par06)
						NEWSE5->(dbSkip())
						Loop
					EndIf
				EndIf
			EndIf			
					 	
			If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
				(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
				cCarteira := "R"
			Else
				cCarteira := "P"
			Endif
	
			dbSelectArea("NEWSE5")
			cAnterior 	:= &cCond2
			cBancoAnt	:= NEWSE5->E5_BANCO
			cAgAnt		:= NEWSE5->E5_AGENCIA
			cContaAnt	:= NEWSE5->E5_CONTA
			
			nTotValor	:= 0
			nTotDesc	:= 0
			nTotJurMul  := 0
			nTotCM		:= 0
			nCT			:= 0
			nTotOrig	:= 0
			nTotBaixado	:= 0
			nTotAbLiq  	:= 0
			nTotImp		:= 0
			nTotMovFin	:= 0
			nTotComp	:= 0
			nTotFat	    := 0
			nTotPOrig	:= 0
	
			While NEWSE5->(!EOF()) .and. &cCond2=cAnterior .and. &cCondFil .and. lContinua
	
				lManual := .f.
				dbSelectArea("NEWSE5")
				
				IF lEnd
					@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
					lContinua:=.F.
					Exit
				EndIF
	
				If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
					(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
					lManual := .t.
				EndIf
				
				// Testa condicoes de filtro	
				If !u_Fr190TstCond(cFilSe5,.T.)
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
					Loop
				Endif	               											
				
				// Imprime somente cheques
				If mv_par37 == 1 .And. NEWSE5->E5_TIPODOC == "BA"

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.

					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura o cheque aglutinado, se encontrar, marca lAchou := .T. e despreza 
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC == "CH"
							lAchou := .T.
							Exit
						Endif
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif  	

				ElseIf mv_par37 == 2 .And. NEWSE5->E5_TIPODOC == "CH" //somente baixas

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.
					
					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura a baixa aglutinada, se encontrar despreza o movimento bancario
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC $ "BA"
							lAchou := .T.
							Exit
						Endif	
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif
				Endif	

				cNumero    	:= NEWSE5->E5_NUMERO
				cPrefixo   	:= NEWSE5->E5_PREFIXO
				cParcela   	:= NEWSE5->E5_PARCELA
				dBaixa     	:= NEWSE5->E5_DATA
				cBanco     	:= NEWSE5->E5_BANCO
				cNatureza  	:= NEWSE5->E5_NATUREZ
				cCliFor    	:= NEWSE5->E5_BENEF
				cLoja      	:= NEWSE5->E5_LOJA
				cSeq       	:= NEWSE5->E5_SEQ
				cNumCheq   	:= NEWSE5->E5_NUMCHEQ
				cRecPag 	:= NEWSE5->E5_RECPAG
				cTipodoc   	:= NEWSE5->E5_TIPODOC
				cMotBaixa	:= NEWSE5->E5_MOTBX
				cCheque    	:= NEWSE5->E5_NUMCHEQ
				cTipo      	:= NEWSE5->E5_TIPO
				cFornece   	:= NEWSE5->E5_CLIFOR
				cLoja      	:= NEWSE5->E5_LOJA
				dDigit     	:= NEWSE5->E5_DTDIGIT
				lBxTit	  	:= .F.
				cFilorig    := NEWSE5->E5_FILORIG
				
				If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
					(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
					dbSelectArea("SE1")
					dbSetOrder(1)
					//Procuro SE1 pela filial origem	
					lBxTit := MsSeek(xFilial("SE1",cFilorig)+cPrefixo+cNumero+cParcela+cTipo)
					
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo)
					Endif				
					cCarteira := "R"
					dDtMovFin := IIF (lManual,CTOD("//"), DataValida(SE1->E1_VENCTO,.T.))
					While SE1->(!Eof()) .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
						If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja	// Cliente igual, Ok
							Exit
						Endif                                
						SE1->( dbSkip() )
					EndDo
					If !SE1->(EOF()) .And. mv_par11 == 1 .and. !lManual .and.  ;
						(NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
						If SE5->(FieldPos("E5_SITCOB")) > 0
							cExp := "NEWSE5->E5_SITCOB"
						Else
							cExp := "SE1->E1_SITUACA"
						Endif 
						
						If mv_par36 == 2 // Nao imprime titulos em carteira 
							// Retira da comparacao as situacoes branco, 0, F e G
							mv_par15 := AllTrim(mv_par15)       
							mv_par15 := StrTran(mv_par15,"0","")
							mv_par15 := StrTran(mv_par15,"F","")
							mv_par15 := StrTran(mv_par15,"G","")
						Else
							If (NEWSE5->E5_RECPAG == "R") .And. lAjuPar15
								mv_par15  += " "
							Endif
						EndIf	
				
						cExp += " $ mv_par15" 
						If !(&cExp)
							dbSelectArea("NEWSE5")
							NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
							Loop
						Endif
					Endif
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
				Else
					dbSelectArea("SE2")
					DbSetOrder(1)
					cCarteira := "P"
					// Procuro SE2 pela filial origem
				    lBxTit 	:= MsSeek(xFilial("SE2",cFilorig)+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
				    
				    Iif(lBxTit, nRecSE2	:= SE2->(Recno()), nRecSE2 := 0 )
				    
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
					Endif				
					dDtMovFin := IIF(lManual,CTOD("//"),DataValida(SE2->E2_VENCTO,.T.))
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
					cCheque    := Iif(Empty(NEWSE5->E5_NUMCHEQ),SE2->E2_NUMBCO,NEWSE5->E5_NUMCHEQ)
				Endif
				dbSelectArea("NEWSE5")
				IncRegua()
				cHistorico := Space(40)
				While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .And. &cCondFil
					
					IncRegua()
					dbSelectArea("NEWSE5")
					cTipodoc   := NEWSE5->E5_TIPODOC
					cCheque    := NEWSE5->E5_NUMCHEQ
	
					lAchouEmp := .T.
					lAchouEst := .F.
	
					IF lEnd
						@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
						lContinua:=.F.
						Exit
					EndIF	                																		
	
					// Testa condicoes de filtro	
					If !u_Fr190TstCond(cFilSe5,.T.)
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
						Loop
					Endif  								
										
					If NEWSE5->E5_SITUACA $ "C/E/X" 
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					EndIF
					
					If NEWSE5->E5_LOJA != cLoja
						Exit
					Endif
	
					If NEWSE5->E5_FILORIG < mv_par33 .or. NEWSE5->E5_FILORIG > mv_par34
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					Endif
	
					//���������������������������������������������������Ŀ
					//� Nao imprime os registros de emprestimos excluidos �
					//�����������������������������������������������������					
					If NEWSE5->E5_TIPODOC == "EP"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEH")
						dbSetOrder(1)
						lAchouEmp := MsSeek(xFilial("SEH")+Substr(NEWSE5->E5_DOCUMEN,1,nTamEH))
						RestArea(aAreaSE5)
						If !lAchouEmp
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	
					//�����������������������������������������������������������������Ŀ
					//� Nao imprime os registros de pagamento de emprestimos estornados �
					//�������������������������������������������������������������������					
					If NEWSE5->E5_TIPODOC == "PE"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEI")
						dbSetOrder(1)
						If	MsSeek(xFilial("SEI")+"EMP"+Substr(NEWSE5->E5_DOCUMEN,1,nTamEI))
							If SEI->EI_STATUS == "C"
								lAchouEst := .T.
							EndIf
						EndIf
						RestArea(aAreaSE5)
						If lAchouEst
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	  
					//�����������������������������Ŀ
					//� Verifica o vencto do Titulo �
					//�������������������������������
					cFilTrb := If(mv_par11==1,"SE1","SE2")
					cCmpVct	:= IIF(MV_PAR42	== 1 , "_VENCREA" , "_VENCTO")
					If (cFilTrb)->(!Eof()) .And.;
						((cFilTrb)->&(Right(cFilTrb,2)+cCmpVct) < mv_par31 .Or. (!Empty(mv_par32) .And. (cFilTrb)->&(Right(cFilTrb,2)+cCmpVct) > mv_par32))
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())
						Loop
					Endif
	            
					dBaixa     	:= NEWSE5->E5_DATA
					cBanco     	:= NEWSE5->E5_BANCO
					cNatureza  	:= NEWSE5->E5_NATUREZ
					cCliFor    	:= NEWSE5->E5_BENEF
					cSeq       	:= NEWSE5->E5_SEQ
					cNumCheq   	:= NEWSE5->E5_NUMCHEQ
					cRecPag		:= NEWSE5->E5_RECPAG
					cMotBaixa	:= NEWSE5->E5_MOTBX
					cTipo190	:= NEWSE5->E5_TIPO
					cFilorig    := NEWSE5->E5_FILORIG
					//��������������������������������������������������������������Ŀ
					//� Obter moeda da conta no Banco.                               �
					//����������������������������������������������������������������
					If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. ( FindFunction( "FXMultSld" ) .AND. FXMultSld() )
						SA6->(DbSetOrder(1))
						SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
						nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
					Else
						nMoedaBco	:=	1
					Endif
	
					If !Empty(NEWSE5->E5_NUMERO)
						If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
							(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG) .Or.;
							(NEWSE5->E5_RECPAG == "P" .And. NEWSE5->E5_TIPODOC $ "DB#OD")
							dbSelectArea( "SA1")
							dbSetOrder(1)
							lAchou := .F.							
							If dbSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								lAchou := .T.
							Endif
							If !lAchou
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA1 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA1 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA1 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA1->A1_NREDUZ,SA1->A1_NOME)
							Endif
						Else
							dbSelectArea( "SA2")
							dbSetOrder(1)
							lAchou := .F.							
							If dbSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								lAchou := .T.
							Endif
							If !lAchou
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA2 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA2 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA2 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA2->A2_NREDUZ,SA2->A2_NOME)
							Endif
						EndIf
					EndIf
					dbSelectArea("SM2")
					dbSetOrder(1)
					dbSeek(NEWSE5->E5_DATA)
					dbSelectArea("NEWSE5")
					nTaxa:= 0
					If cPaisLoc=="BRA"
						If !Empty(NEWSE5->E5_TXMOEDA)
							nTaxa:=NEWSE5->E5_TXMOEDA
						Else
							If nMoedaBco == 1
								nTaxa := NEWSE5->E5_VALOR / NEWSE5->E5_VLMOED2
							Else
								nTaxa := NEWSE5->E5_VLMOED2 / NEWSE5->E5_VALOR
							EndIf
						EndIf
					EndIf
					nRecSe5:=If(lAsTop,NEWSE5->SE5RECNO,Recno())
					nDesc+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLDESCO,Round(xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))
					nJuros+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLJUROS,Round(xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))
					nMulta+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLMULTA,Round(xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))
					nJurMul+= nJuros + nMulta
					nCM+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLCORRE,Round(xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))
										
					If cCarteira == "R" .and. mv_par12 == SE1->E1_MOEDA					
					   nCM := 0
					
					ElseIf cCarteira == "P" .and. mv_par12 == SE2->E2_MOEDA
					   nCM := 0					   
					   
					Endif					
										
					If lPccBaixa .and. Empty(NEWSE5->E5_PRETPIS) .And. Empty(NEWSE5->E5_PRETCOF) .And. Empty(NEWSE5->E5_PRETCSL) .And. cCarteira == "P"
						If nRecSE2 > 0 
						
							aAreabk  := Getarea()
							aAreaSE2 := SE2->(Getarea())
							SE2->(DbGoto(nRecSE2))
						
							nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)+;
										SE2->E2_INSS+ SE2->E2_ISS+ SE2->E2_IRRF
										
							Restarea(aAreaSE2)
							Restarea(aAreabk)
						Else
							nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)
						Endif
					Endif				
					If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"

						cHistorico := SubStr(NEWSE5->E5_HISTOR,1,12)

						If mv_par11 == 2
							If cPaisLoc == "ARG" .and. !EMPTY(NEWSE5->E5_ORDREC)
								nValor += Iif(VAL(NEWSE5->E5_MOEDA)==mv_par12,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,VAL(NEWSE5->E5_MOEDA),mv_par12,NEWSE5->E5_DATA,nDecs+1,NEWSE5->E5_TXMOEDA),nDecs+1))
							Else
							 	nValor += Iif(mv_par12==nMoedaBco,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VLMOED2,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0))+nJurMul-nDesc,nDecs+1))
							Endif
						Else 
						  	nValor+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VLMOED2,SE1->E1_MOEDA,mv_par12,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDecs+1))						
						EndIf

						//Pcc Baixa CR
						If cCarteira == "R" .and. lPccBxCr .and. cPaisLoc == "BRA" .And. (IiF(lRaRtImp,NEWSE5->E5_TIPO $ MVRECANT,.T.) .OR. lPccBaixa)
							If Empty(NEWSE5->E5_PRETPIS) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETPIS,Round(xMoeda(NEWSE5->E5_VRETPIS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCOF) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCOF,Round(xMoeda(NEWSE5->E5_VRETCOF,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCSL) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCSL,Round(xMoeda(NEWSE5->E5_VRETCSL,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif											
						Endif

					Else
						nVlMovFin+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
						cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",substr(NEWSE5->E5_HISTOR,1,12))
						cNatureza  	:= NEWSE5->E5_NATUREZ
					Endif	
					dbSkip()
					If lManual		// forca a saida do looping se for mov manual
						Exit
					Endif
				EndDO
	
				If (nDesc+nValor+nJurMul+nCM+nVlMovFin) > 0
					//������������������������������Ŀ
					//� C�lculo do Abatimento        �
					//��������������������������������
					If cCarteira == "R" .and. !lManual
						dbSelectArea("SE1")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0
						//�����������������������������������������������������������������������Ŀ
						//� Entra no if abaixo se titulo totalmente baixado e se for a maior
						// sequnecia de baixa no SE5 
						//�������������������������������������������������������������������������												
						If !SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. Empty(SE1->E1_SALDO) .and.;
						    Iif(lAsTop, NEWSE5->MAXSEQ == NEWSE5->E5_SEQ, FSEQMAX(NEWSE5->E5_RECPAG,NEWSE5->E5_PREFIXO,NEWSE5->E5_NUMERO,NEWSE5->E5_PARCELA,NEWSE5->E5_TIPO,NEWSE5->E5_CLIFOR,NEWSE5->E5_LOJA) == NEWSE5->E5_SEQ )
                                                         
							//��������������������������������������������������������������������Ŀ
							//� Calcula o valor total de abatimento do titulo e impostos se houver �
							//����������������������������������������������������������������������
							nTotAbImp := 0
							nAbat := SumAbatRec(cPrefixo,cNumero,cParcela,SE1->E1_MOEDA,"V",dBaixa,@nTotAbImp)
							nAbatLiq := nAbat - nTotAbImp
						EndIf
						dbSelectArea("SE1")
						dbGoTo(nRecno)
						
						cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
                                                                      
						SA1->(DBSetOrder(1))
						If SA1->(DBSeek(xFilial("SA1")+cCliFor190) )
							lCalcIRF := SA1->A1_RECIRRF == "1" .and. SA1->A1_IRBAX == "1" // se for na baixa 
						Else
							lCalcIRF := .F.	
						EndIf	
						If lCalcIRF							
							nTotAbImp += SE1->E1_IRRF
						EndIf	
					Elseif !lManual
						dbSelectArea("SE2")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0						
						If !SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. Empty(SE2->E2_SALDO) .and.;
     					    Iif(lAsTop, NEWSE5->MAXSEQ == NEWSE5->E5_SEQ, FSEQMAX(NEWSE5->E5_RECPAG,NEWSE5->E5_PREFIXO,NEWSE5->E5_NUMERO,NEWSE5->E5_PARCELA,NEWSE5->E5_TIPO,NEWSE5->E5_CLIFOR,NEWSE5->E5_LOJA) == NEWSE5->E5_SEQ )
							nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par12,,cFornece,cLoja)
							nAbatLiq := nAbat	
						EndIf			
						dbSelectArea("SE2")
						dbGoTo(nRecno)
					EndIF
	
					If li > 55
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					EndIF
	
					IF mv_par11 == 1 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							@li, aColu[05] PSAY SE1->E1_CLIENTE						
						Endif
						@li, aColu[06] PSAY SubStr(cCliFor,1,18)
						li++
					Elseif mv_par11 == 2 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							@li, aColu[05] PSAY SE2->E2_FORNECE
						Endif
						@li, aColu[06] PSAY SubStr(cCliFor,1,18)
						li++
					Endif
	
					@li, aColu[01] PSAY cPrefixo
					@li, aColu[02] PSAY cNumero
					
					If cPaisLoc	$ "MEX|PTG"
					   li++
					Endif					
					
					@li, aColu[03] PSAY cParcela
					@li, aColu[04] PSAY cTipo		
	
					If !lManual
						dbSelectArea("TRB")
						lOriginal := .T.
						//������������������������������Ŀ
						//� Baixas a Receber             �
						//��������������������������������
						If cCarteira == "R"
							cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
							nVlr:= SE1->E1_VLCRUZ
							If mv_par12 > 1
								nVlr := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDecs+1)
							EndIF
							//������������������������������Ŀ
							//� Baixa de PA                  �
							//��������������������������������
						Else
							cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
							
							If cPaisLoc=="BRA"
								lCalcIRF:= Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == "1" .Or.;//1-Normal, 2-Baixa
								           Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == " "
							Else 
								lCalcIRF:=.f.
							EndIf
										
							// MV_MRETISS "1" retencao do ISS na Emissao, "2" retencao na Baixa.
					   		nVlr:= SE2->E2_VLCRUZ
							
							If lConsImp   //default soma os impostos no valor original
								nVlr += SE2->E2_INSS+ Iif(GetNewPar('MV_MRETISS',"1")=="1",SE2->E2_ISS,0) +;
									   	Iif(lCalcIRF,SE2->E2_IRRF,0)
								If ! lPccBaixa  // SE PCC NA EMISSAO SOMA PCC
									nVlr += SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL
								EndIf
							EndIf
							
							If mv_par12 > 1
								nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1)
							Endif
						Endif
						cFilTrb := If(cCarteira=="R","SE1","SE2")
						IF DbSeek( xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo)
							nAbat:=0
							lOriginal := .F.
						Else
							nVlr:=NoRound(nVlr)
							RecLock("TRB",.T.)
							Replace linha With xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo
							MsUnlock()
						EndIF
					Else
						If lAsTop
							dbSelectArea("SE5")
						Else
							dbSelectArea("NEWSE5")
						Endif
						dbgoto(nRecSe5)
						nVlr := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par12,E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",E5_TXMOEDA,0)),nDecs+1)
						nAbat:= 0
						lOriginal := .t.
						If lAsTop
							nRecSe5:=NEWSE5->SE5RECNO
						Else
							nRecSe5:=Recno()
							NEWSE5->( dbSkip() )
						Endif
						dbSelectArea("TRB")
					Endif
					IF cCarteira == "R"
						If ( !lManual )
							If mv_par13 == 1  // Utilizar o Hist�rico da Baixa ou Emiss�o
								cHistorico := Iif(Empty(cHistorico), substr(SE1->E1_HIST,1,12), substr(cHistorico,1,12) )
							Else
								cHistorico := Iif(Empty(SE1->E1_HIST), substr(cHistorico,1,12), substr(SE1->E1_HIST,1,12) )
							Endif
						EndIf
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								@li, aColu[05] PSAY SE1->E1_CLIENTE
							Endif
							@li, aColu[06] PSAY SubStr(cCliFor,1,18)
						Endif
						@li, 49 PSAY cNatureza
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						@li, 60 PSAY IIf(lManual,dDtMovFin,DataValida(SE1->E1_VENCTO,.T.))
						@li, 71 PSAY SubStr( cHistorico ,1,12)
						@li, 93 PSAY dBaixa
						IF nVlr > 0
							@li,103 PSAY nVlr  Picture tm(nVlr,14,nDecs)
						Endif
					Else
						If mv_par13 == 1  // Utilizar o Hist�rico da Baixa ou Emiss�o
							cHistorico := Iif(Empty(cHistorico), substr(SE2->E2_HIST,1,12), substr(cHistorico,1,12) )
						Else
							cHistorico := Iif(Empty(SE2->E2_HIST), substr(cHistorico,1,12), substr(SE2->E2_HIST,1,12) )
						Endif
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								@li, aColu[05] PSAY SE2->E2_FORNECE
							Endif
							@li, aColu[06] PSAY SubStr(cCliFor,1,18)
						Endif
						@li, 49 PSAY cNatureza
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						@li, 60 PSAY IIf(lManual,dDtMovFin,DataValida(SE2->E2_VENCTO,.T.))
						If !Empty(cCheque)
							@li, 71 PSAY SubStr(ALLTRIM(cCheque)+"/"+Trim(cHistorico),1,12)
						Else
							@li, 71 PSAY SubStr(cHistorico,1,12)
						EndIf
						@li, 93 PSAY dBaixa
						IF nVlr > 0
							@li,103 PSAY nVlr Picture tm(nVlr,14,nDecs)
						Endif
					Endif
					nCT++
					
					//PCC Baixa CR
					//Somo aos abatimentos de impostos, os impostos PCC na baixa.
					//Caso o calculo do PCC CR seja pela emissao, esta variavel estara zerada
					nTotAbImp := nTotAbImp + nPccBxCr

					@li,118 PSAY nJurMul    PicTure tm(nJurMul,11,nDecs)
					@li,130 PSAY nCM        PicTure tm(nCM ,11,nDecs)
					@li,142 PSAY nDesc      PicTure tm(nDesc,11,nDecs)
					@li,154 PSAY nAbatLiq  	Picture tm(nAbatLiq,11,nDecs)
					@li,166 PSAY nTotAbImp 	Picture tm(nTotAbImp,11,nDecs)
					If (nVlr <= IIf(nVlMovFin > 0 , nVlMovFin , nValor)) .AND. ;
						(Substr(AllTrim(cHistorico),1,At("-",AllTrim(cHistorico))-1) == "LOJ")
						//---------------------------------------------------------------------------------
						//Quando o recebimento de titulos � efetuado pelo SIGALOJA e o parametro 
						//MV_LJTROCO == .T., o valor de total gravado no E5_VALOR � gravado com o valor do 
						// titulo (E1_VALOR) + valor do troco portanto deve-se mostrar o valor do E1_VALOR
						// e assim desconsidera-se o par�metro.
						//---------------------------------------------------------------------------------
						@li,178 PSAY nVlr			PicTure tm(nVlr,15,nDecs)
						lBxLoja	:=	.T.
					ElseIf nVlMovFin > 0
						@li,178 PSAY nVlMovFin     PicTure tm(nVlMovFin,15,nDecs)
					Else
						@li,178 PSAY nValor			PicTure tm(nValor,15,nDecs)
					Endif
					@li,196 PSAY cBanco
					If Len(DtoC(dDigit)) <= 8
						@li,202 PSAY dDigit
					Else                   
						@li,200 PSAY dDigit
					EndIf
	
					If empty(cMotBaixa)
						cMotBaixa := "NOR"  //NORMAL
					Endif
	
					@li,211 PSAY Substr(cMotBaixa,1,3)
					@li,215 PSAY cFilorig
					
					nTotOrig   += Iif(lOriginal,nVlr,0)
					nTotPOrig 	+= nVlr
					nTotBaixado+= If(cTipodoc $ "CP/BA" .AND. cMotBaixa $ "CMP/FAT",0,IIF(lBxLoja,nVlr,nValor))		// n�o soma, j� somou no principal					
					nTotDesc   += nDesc
					nTotJurMul += nJurMul
					nTotCM     += nCM
					nTotAbLiq  += nAbatLiq
					nTotImp    += nTotAbImp
					nTotValor  += IIF( lBxLoja , nVlr, IIF(nVlMovFin <> 0, nVlMovFin , Iif(MovBcoBx(cMotBaixa),nValor,0)))
					nTotMovFin += nVlMovFin
					nTotComp   += Iif(cTipodoc == "CP",IIF(lBxLoja,nVlr,nValor),0)
					nTotFat	   += Iif(cMotBaixa $ "FAT",IIF(lBxLoja,nVlr,nValor), 0)									
					nDesc := nJurMul := nValor := nCM := nAbat := nTotAbImp := nAbatLiq := nVlMovFin := 0
					nPccBxCr	 := 0			//PCC Baixa
					lBxLoja		 := .F.
					li++
				Endif
				dbSelectArea("NEWSE5")
			Enddo
	
			If (nTotValor+nDesc+nJurMul+nCM+nTotOrig+nTotMovFin+nTotComp+nTotBaixado)>0
				li++
				IF li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				Endif
				If nCT > 0
					IF nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8
						@li, 0 PSAY "Sub Total : " + DTOC(cAnterior)
					Elseif nOrdem == 2 .or. nOrdem == 4 .or. nOrdem == 7
						cLinha := "Sub Total : "+cAnterior+" "
						If nOrdem == 4
							If (mv_par11 == 1 .and. (cRecpag == "R" .and. !(cTipo190 $ MVPAGANT+"/"+MV_CPNEG))) .or. ;
								(cRecpag == "P" .and. cTipo190 $ MVRECANT+"/"+MV_CRNEG) .Or.;
								(cRecPag == "P" .And. cTipoDoc $ "DB#OD")
	
								dbSelectArea("SA1")
								DbSetOrder(1)
								If !Empty(cAnterior)
									MsSeek(cFilial+cFornece+cLoja)
									cLinha+=" "+A1_CGC
								Else
									cLinha+= OemToAnsi(STR0038)  //"Moviment. Financeiras Manuais "
								Endif
							ElseIF (mv_par11 == 2 .and. (cRecpag == "P" .and. !(cTipo190 $ MVRECANT+"/"+MV_CRNEG))) .or.;
									(cRecpag == "R" .and. cTipo190 $ MVPAGANT+"/"+MV_CPNEG)
								dbSelectArea("SA2")
								DbSetOrder(1)
								If !Empty(cAnterior)
									MsSeek(cFilial+cFornece+cLoja)
									cLinha+=TRIM(A2_NOME)+"  "+A2_CGC
								Else
									cLinha+= OemToAnsi(STR0038)  //"Moviment. Financeiras Manuais "
								Endif
							Endif
						Elseif nOrdem == 2
							dbSelectArea("SA6")
							DbSetOrder(1)
							MsSeek(xFilial("SA6")+cBancoAnt+cAgAnt+cContaAnt)
							cLinha+=TRIM(A6_NOME)
						Endif
						@li,0 PSAY cLinha
					Elseif nOrdem == 3
						dbSelectArea("SED")
						DbSetOrder(1)
						MsSeek(cFilial+cAnterior)
						@li, 0 PSAY "SubTotal : " + cAnterior + " "+ED_DESCRIC
					Endif
					If nOrdem != 5
						@li,102 PSAY nTotPOrig     PicTure tm(nTotOrig,15,nDecs)
						@li,118 PSAY nTotJurMul   PicTure tm(nTotJurMul,11,nDecs)
  						@li,130 PSAY nTotCM       PicTure tm(nTotCM ,11,nDecs)
						@li,142 PSAY nTotDesc     PicTure tm(nTotDesc,11,nDecs)
						@li,154 PSAY nTotAbLiq    Picture tm(nTotAbLiq,11,nDecs)
						@li,166 PSAY nTotImp      Picture tm(nTotImp,11,nDecs)  
						@li,178 PSAY nTotValor    PicTure tm(nTotValor,15,nDecs)
						If nTotBaixado > 0
							@li,195 PSAY STR0028  //"Baixados"
							@li,204 PSAY nTotBaixado  PicTure tm(nTotBaixado,15,nDecs)
						Endif	
						If nTotMovFin > 0
							li++
							@li,195 PSAY STR0031   //"Mov Fin."
							@li,204 PSAY nTotMovFin   PicTure tm(nTotMovFin,15,nDecs)
						Endif
						If nTotComp > 0
							li++
							@li,195 PSAY STR0037  //"Compens."
							@li,204 PSAY nTotComp     PicTure tm(nTotComp,15,nDecs)
						Endif
						If nTotFat > 0
							li++
							@li,195 PSAY STR0076  //"Bx.Fatura"
							@li,204 PSAY nTotFat     PicTure tm(nTotFat,15,nDecs)
						Endif						
						li+=2
						nTotPOrig := 0 //zerando o total parcial
					Endif
					dbSelectArea("NEWSE5")
				Endif
			Endif
	
			//�������������������������Ŀ
			//�Incrementa Totais Gerais �
			//���������������������������
			nGerOrig	   += nTotOrig
			nGerValor	+= nTotValor 
			nGerDesc	   += nTotDesc
			nGerJurMul	+= nTotJurMul
			nGerCM		+= nTotCM                        
			nGerAbLiq	+= nTotAbLiq                                    
			nGerAbImp	+= nTotImp
			nGerBaixado += nTotBaixado
			nGerMovFin	+= nTotMovFin
			nGerComp	+= nTotComp
			nGerFat     += nTotFat			
			//�������������������������Ŀ                                                   
			//�Incrementa Totais Filial �                                  
			//���������������������������
			nFilOrig	+= nTotOrig               
			nFilValor	+=  nTotValor  
			nFilDesc	+= nTotDesc
			nFilJurMul	+= nTotJurMul
			nFilCM		+= nTotCM
			nFilAbLiq	+= nTotAbLiq 
			nFilAbImp	+= nTotImp 		
			nFilBaixado += nTotBaixado
			nFilMovFin	+= nTotMovFin
			nFilComp	+= nTotComp
			nFilFat	    += nTotFat
		Enddo
	Endif	
	//����������������������������������������Ŀ
	//� Imprimir TOTAL por filial somente quan-�
	//� do houver mais do que 1 filial.        �
	//������������������������������������������
	if mv_par17 == 1 .and. SM0->(Reccount()) > 1 .And. li != 80 .And. !Empty(FWFilial("SE5"))            
		@li,  0 PSAY "FILIAL : " +  cFilAnt + " - " + cFilNome
		@li,102 PSAY nFilOrig       PicTure tm(nFilOrig,15,nDecs)
		@li,118 PSAY nFilJurMul     PicTure tm(nFilJurMul,11,nDecs)
		@li,130 PSAY nFilCM         PicTure tm(nFilCM ,11,nDecs)
		@li,142 PSAY nFilDesc       PicTure tm(nFilDesc,11,nDecs)                                       
		@li,154 PSAY nFilAbLiq       PicTure tm(nFilAbLiq,11,nDecs)
		@li,166 PSAY nFilAbImp       PicTure tm(nFilAbImp,11,nDecs)
		@li,178 PSAY nFilValor      PicTure tm(nFilValor,15,nDecs)
		If nFilBaixado > 0 
			@li,195 PSAY STR0028 // "Baixados"
			@li,204 PSAY nFilBaixado    PicTure tm(nFilBaixado,15,nDecs)
		Endif
		If nFilMovFin > 0
			li++
			@li,195 PSAY STR0031   //"Mov Fin."
			@li,204 PSAY nFilMovFin   PicTure tm(nFilMovFin,15,nDecs)
		Endif
		If nFilComp > 0
			li++
			@li,195 PSAY STR0037  //"Compens."
			@li,204 PSAY nFilComp     PicTure tm(nFilComp,15,nDecs)
		Endif
		If nFilFat > 0
			li++
			@li,195 PSAY STR0076  //"Bx.Fatura"
			@li,204 PSAY nFilFat     PicTure tm(nFilFat,15,nDecs)
		Endif
		li+=2
		If Empty(xFilial("SE5")) .And. mv_par17 == 2
			Exit
		Endif	

		nFilOrig:=nFilJurMul:=nFilCM:=nFilDesc:=nFilAbLiq:=nFilAbImp:=nFilValor:=0
		nFilBaixado:=nFilMovFin:=nFilComp:=nFilFat:=0
	Endif
	dbSelectArea("SM0")
	cCodUlt := SM0->M0_CODIGO
	cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	dbSkip()
Enddo

If li != 80
	// Imprime o cabecalho, caso nao tenha espaco suficiente para impressao do total geral
	If (li+4)>=60
		SM0->(MsSeek(cCodUlt+cFilUlt))		
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	li+=2
	@li,  0 PSAY OemToAnsi(STR0029)  //"Total Geral : "
	@li,102 PSAY nGerOrig       PicTure tm(nGerOrig,15,nDecs)
	@li,118 PSAY nGerJurMul     PicTure tm(nGerJurMul,11,nDecs)
	@li,130 PSAY nGerCM         PicTure tm(nGerCM ,11,nDecs)
	@li,142 PSAY nGerDesc       PicTure tm(nGerDesc,11,nDecs)
	@li,154 PSAY nGerAbLiq       PicTure tm(nGerAbLiq,11,nDecs)
	@li,166 PSAY nGerAbImp       PicTure tm(nGerAbImp,11,nDecs)	
	@li,178 PSAY nGerValor      PicTure tm(nGerValor,15,nDecs)
	If nGerBaixado > 0 
		@li,195 PSAY OemToAnsi(STR0028) // "Baixados"
		@li,204 PSAY nGerBaixado    PicTure tm(nGerBaixado,15,nDecs)
	Endif
	If nGerMovFin > 0
		li++
		@li,195 PSAY OemToAnsi(STR0031)   //"Mov Fin."
		@li,204 PSAY nGerMovFin   PicTure tm(nGerMovFin,15,nDecs)
	Endif
	If nGerComp > 0
		li++
		@li,195 PSAY STR0037  //"Compens."
		@li,204 PSAY nGerComp     PicTure tm(nGerComp,15,nDecs)
	Endif
	If nGerFat > 0
		li++
		@li,195 PSAY STR0076  //"Bx.Fatura"
		@li,204 PSAY nGerFat     PicTure tm(nGerFat,15,nDecs)
	Endif
	li++
	roda(cbcont,cbtxt,"G")
Endif

SM0->(dbgoto(nRecEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
dbSelectArea("TRB")
dbCloseArea()
Ferase(cNomArq1+GetDBExtension())
dbSelectArea("NEWSE5")
dbCloseArea()
If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif
dbSelectArea("SE5")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
Endif

MS_FLUSH()
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Fr190TstCo� Autor � Claudio D. de Souza   � Data � 22.08.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Testa as condicoes do registro do SE5 para permitir a impr.���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � Fr190TstCon(cFilSe5)													  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cFilSe5 - Filtro em CodBase										  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINR190																	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Fr190TstCond(cFilSe5,lInterno)
Local lRet := .T.
Local nMoedaBco
Local lManual := .F.

If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
	(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
	lManual := .t.
EndIf

Do Case
Case !&(cFilSe5)           		// Verifico filtro CODEBASE tambem para TOP
	lRet := .F.
Case NEWSE5->E5_TIPODOC $ "DC/D2/JR/J2/TL/MT/M2/CM/C2" 
	lRet := .F.
Case NEWSE5->E5_SITUACA $ "C/E/X" .or.;
	(NEWSE5->E5_TIPODOC == "CD" .and. NEWSE5->E5_VENCTO > NEWSE5->E5_DATA)
	lRet := .F.
Case NEWSE5->E5_TIPODOC == "E2" .and. mv_par11 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_NUMERO) .and. mv_par16 == 2
	lRet := .F. 
Case mv_par16 == 2 .and. NEWSE5->E5_TIPODOC $ "CH" 
	lRet := .F. 
Case NEWSE5->E5_MOTBX == "DSD"
	lRet := .F.
Case mv_par11 = 1 .And. E5_TIPODOC $ "E2#CB"
	lRet := .F.
Case IIf(mv_par03 == mv_par04,NEWSE5->E5_BANCO != mv_par03 .And. !Empty(NEWSE5->E5_BANCO),NEWSE5->E5_BANCO < mv_par03 .Or. NEWSE5->E5_BANCO > MV_PAR04)
	lRet := .F.
	//���������������������������������������������������������������������Ŀ
	//�Se escolhido o par�metro "baixas normais", apenas imprime as baixas  �
	//�que gerarem movimenta��o banc�ria e as movimenta��es financeiras     �
	//�manuais, se consideradas.                                            �
	//�����������������������������������������������������������������������
Case mv_par14 == 1 .and. !MovBcoBx(NEWSE5->E5_MOTBX) .and. !lManual	
	lRet := .F.
	//��������������������������������������������������������������Ŀ
	//� Considera filtro do usuario                                  �
	//����������������������������������������������������������������
Case !Empty(cFilterUser).and.!(&cFilterUser)
	lRet := .F.	
	//������������������������������������������������������������������������Ŀ
	//� Verifica se existe estorno para esta baixa, somente no nivel de quebra �
	//� mais interno, para melhorar a performance 										�
	//��������������������������������������������������������������������������
Case	lInterno .And.;
		!Empty(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)) .And.;
		TemBxCanc(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)) .And.;
		(!Empty(NEWSE5->(E5_NUMERO))) 	
		lRet := .F.
EndCase

If lRet .And. NEWSE5->E5_RECPAG == "R"
	If ( NEWSE5->E5_TIPODOC = "RA" .And. mv_par35 = 2 ) .Or.;
		(NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG.and. mv_par24 == 2 .and.;
		NEWSE5->E5_MOTBX == "CMP")
		lRet := .F.
	EndIf
Endif
If lRet .And. NEWSE5->E5_RECPAG == "P"
	If ( NEWSE5->E5_TIPODOC = "PA" .And. mv_par35 = 2 ) .Or.;
		(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par24 == 2 .and.;
		 NEWSE5->E5_MOTBX == "CMP")
		lRet := .F.
	EndIf
Endif	

If lRet .And. mv_par25 == 2
	If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. ( FindFunction( "FXMultSld" ) .AND. FXMultSld() )
	   SA6->(DbSetOrder(1))
	   SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
	   nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
	ElseIf !Empty(NEWSE5->E5_ORDREC)
		nMoedaBco:= Val(NEWSE5->E5_MOEDA)
	Else
	   nMoedaBco	:=	1
	Endif
	If nMoedaBco <> mv_par12
		lRet := .F.
	EndIf
EndIf 

If lRet
	// Testar se considerar mov bancario e se o cancelamento da baixa tiver sido realizado, n�o imprimir o mov.						
	If MV_PAR16 == 1			   
		If u_Fr190MovCan(17,"NEWSE5")
		   lRet := .F.
		Endif   
	Endif
Endif

If lRet
	// Se for um recebimento de Titulo pago em dinheiro originado pelo SIGALOJA, nao imprime o mov.
	If NEWSE5->E5_TIPODOC == "BA" .and. NEWSE5->E5_MOTBX == "LOJ" .And. IsMoney(NEWSE5->E5_MOEDA)
		lRet := .F.	
	EndIf
EndIf

//Tratamento p/ � imp t�t aglutinador quando o mesmo n�o estiver sofrido baixa.
If Empty(NEWSE5->(E5_TIPO+E5_DOCUMEN+Iif(SE5->(FieldPos("E5_IDMOVI")) >0 , E5_IDMOVI,"")+E5_FILORIG+E5_MOEDA))
	lRet := .F.	
	//Cheque avulso gerado c/ o param mv_libcheq = N e liberado pelo Fina190"gera� de cheque"
	If AllTrim(E5_TIPODOC) == "CH" .And. AllTrim(E5_MOTBX) == "NOR" .And. Empty(E5_SEQ) 
		lRet := .T.
	EndIf
EndIf

Return lRet     

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1� Autor � Claudio D. de Souza   � Data � 26/09/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � FINR190                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSX1()

Local aArea 	:= GetArea()
Local aHelpPor  := {}
Local aHelpEng  := {}
Local aHelpSpa  := {}

/*------------------ MV_PAR38 -----------------------------*/
PutSx1(	"FIN190",;
		"38",;
		"Cons. Nat. Aglutinadas?",;
		"Cons. Nat. Aglutinadas?",;
		"Cons. Nat. Aglutinadas?",;
		"mv_ch38",;
		"N",;
		01,;
		0,;
		0,;
		"C",;
		"",;
		"",;
		"",;
		"",;
		"mv_par38",;
		"Sim",;
		"Si",;
		"Yes",;
		"",;
		"Nao",;
		"No",;
		"No",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		, , , )        

aHelpPor := {	"SIM - apresentar� as naturezas do "	,;
				"relat�rio em formato Sint�tico e "		,;
				"Aglutinado. Caso o t�tulo possua "		,;
				"rateio m�ltiplas naturezas, ele "		,;
				"ser� apresentado em uma s� linha,"		,;
				"constando a sua natureza principal,"	,;
				"ou seja, do SE5."						,;
				"N�O - apresentar� as naturezas do"		,;
				"relat�rio em formato Sint�tico."		,;
				"Caso o t�tulo possua rateio "			,;
				"m�ltiplas naturezas, ele ser�"			,;
				"apresentado no formato do rateio"		,;
				"efetuado, ou seja, conforme consta"	,;
				"no SEV. Somente t�tulos que n�o "		,;
				"possuam m�ltiplas naturezas,"			,;
				"apresenta��o a informa��o"				,;
				"existente no SE5."						,;
				"ATEN��O: Independente da resposta"		,;
				"escolhida para essa pergunta, o"		,;
				"relat�rio sempre levar� em "			,;
				"considera��o, tanto a natureza"		,;
				"do SE5 (baixa do t�tulo) quanto"		,;
				"do SEV (m�ltiplas naturezas do"		,;
				"t�tulo), para filtragem das "			,;
				"naturezas."							}

PutHelp("P.FIN19038.",aHelpPor,aHelpEng,aHelpSpa,.T.)

/*------------------ MV_PAR39 -----------------------------*/
aHelpPor := {	"Indica qual o metodo utilizado para"	,;
				"filtragem das naturezas. Os metodos"	,;
				"abaixo se baseiam nos parametros "		,;
				"'Da Natureza' e 'Ate a Natureza' "		,;
				"para realiza��o do filtro."			,;
				"METODOS UTILIZADOS:"					,;
				"-PADR�O: Este metodo se baseia na"		,;
				" pergunta 'Cons. Nat. Aglutinadas?'"	,;
				" para aplicar a filtragem."			,;				
				"-NAT.PRINCIPAL: Este metodo se "		,;
				" baseia somente na natureza princi-"	,;
				" pal informada na baixa do titulo"		,;
				" (Tabela SE5) para aplicar a fil-"		,;
				" tragem por naturezas."				,;
				"-MULT.NATUREZAS:Este metodo se "		,;
				" baseia somente nas multiplas natu-"	,;
				" rezas geradas na baixa do titulo"		,;
				" (Tabela SEV)."						,;
				" Nesta op��o as baixas ser�o"			,;
				" apresentadas no formato do rateio"	,;
				" efetuado, ou seja, conforme consta"	,;
				" na tabela SEV. "						}

aHelpEng := {}
aHelpSpa := {}

PutSX1("FIN190",;
 	   "39",;
 	   "Filtrar Natureza Por?",;
 	   "Filtrar Natureza Por?",;
 	   "Filtrar Natureza Por?",;
 	   "mv_chz"			,;
 	   "N"				,;
 	   1				,;
 	   0				,;
 	   1				,;
 	   "C"				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   "S"				,;
 	   "mv_par39"		,;
 	   "Padr�o"			,;
 	   "Padr�o"			,;
 	   "Padr�o"			,;
 	   ""				,;
 	   "Nat.Principal"	,;
 	   "Nat.Principal"	,;
 	   "Nat.Principal"	,;
 	   "Mult.Naturezas"	,;
 	   "Mult.Naturezas"	,;
 	   "Mult.Naturezas"	,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   aHelpPor,;
 	   aHelpEng,;
 	   aHelpSpa)
 	   
aHelpEng := {}
aHelpSpa := {}

/*---------------------- MV_PAR41 -------------------------*/
aHelpPor := {"Informa se na coluna Valor Original ",;
				  "se deve somar os impostos ou nao.   ",;
				  "V�lido somente para o Contas a Papar."}
	aHelpSpa := {"Informes sobre la columna Valor     ",;
				  "original hay que a�adir los impuestos o no."}
	aHelpEng := {"Reports on the Original Value column",;
				  "must be added taxes or not."}

PutHelp("P.FIN19041.",aHelpPor,aHelpEng,aHelpSpa,.T.)

/*------------------ MV_PAR42 -----------------------------*/
PutSx1(	"FIN190",;
		"42",;
		"considera vencto/vencto real? ",;
		"considera vencto/vencto real? ",;
		"considera vencto/vencto real? ",;
		"mv_ch42",;
		"N",;
		01,;
		0,;
		0,;
		"C",;
		"",;
		"",;
		"",;
		"",;
		"mv_par42",;
		"Vencto Real",;
		"Fecha Real",;
		"Real Bill",;
		"",;
		"Vencto",;
		"Fecha",;
		"Bill",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		, , , )        

aHelpPor := {	"Define que o vencimento usado nos "	,;
				"parametros a cima ser� o vencimen"		,;
				"to titulo(_vencto) ou sera o venci"	,;
				"mento real (_vencrea)"}
				
PutHelp("P.FIN19042.",aHelpPor,aHelpEng,aHelpSpa,.T.)

RestArea(aArea)
Return

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � FA190ImpR4 � Autor � Adrianne Furtado      � Data � 05.09.06 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o das baixas                                           ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA190ImpR4(nOrdem,aTotais)                                   ���
���������������������������������������������������������������������������Ĵ��
���Parametros� nOrdem    - Ordem que sera utilizada na emissao do relatorio ���
���          � aTotais   - Array que retorna o totalizador especifico de    ���
���          � 			   cada quebra de secao                             ���
���          � oReport   - objeto da classe TReport                         ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Gen�rico                                                     ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function FA190ImpR4(nOrdem,aTotais,oReport,nGerOrig,lMultiNat)
Local oBaixas	:= oReport:Section(1)
Local cExp 			:= ""
Local CbTxt,CbCont
Local nValor:=0,nDesc:=0,nJuros:=0,nMulta:=0,nJurMul:=0,nCM:=0,dData,nVlMovFin:=0
Local nTotValor:=0,nTotDesc:=0,nTotJurMul:=0,nTotCm:=0,nTotOrig:=0,nTotBaixado:=0,nTotMovFin:=0,nTotComp:=0,nTotFat:=0
Local nGerValor:=0,nGerDesc:=0,nGerJurMul:=0,nGerCm:=0,nGerBaixado:=0,nGerMovFin:=0,nGerComp:=0,nGerFat:=0
Local nFilOrig:=0,nFilJurMul:=0,nFilCM:=0,nFilDesc:=0
Local nFilAbLiq:=0,nFilAbImp:=0,nFilValor:=0,nFilBaixado:=0,nFilMovFin:=0,nFilComp:=0,nFilFat:=0
Local nAbatLiq := 0,nTotAbImp := 0,nTotImp := 0,nTotAbLiq := 0,nGerAbLiq := 0,nGerAbImp := 0
Local cBanco,cNatureza,cAnterior,cCliFor,nCT:=0,dDigit,cLoja
Local lContinua		:=.T.
Local lBxTit		:=.F.
Local tamanho		:="G"
Local aCampos:= {},cNomArq1:="",nVlr,cLinha,lOriginal:=.T.
Local nAbat 		:= 0
Local cHistorico
Local lManual 		:= .f.
Local cTipodoc
Local nRecSe5 		:= 0
Local dDtMovFin
Local cRecPag
Local nRecEmp 		:= SM0->(Recno())
Local cMotBaixa		:= CRIAVAR("E5_MOTBX")
Local cFilNome 		:= Space(15)
Local cCliFor190	:= ""
Local aTam 			:= IIF(mv_par11 == 1,TamSX3("E1_CLIENTE"),TamSX3("E2_FORNECE"))
Local aColu 		:= {}
Local nDecs	   		:= GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),""))) 
Local nMoedaBco		:= 1
Local cCarteira
#IFDEF TOP
	Local aStru		:= SE5->(DbStruct()), nI
	Local cQuery
#ENDIF	
Local cFilTrb
Local lAsTop		:= .F.
Local cFilSe5		:= ".T."
Local cChave, bFirst
Local cFilOrig
Local lAchou		:= .F.
Local lF190Qry		:= ExistBlock("F190QRY")
Local cQueryAdd		:= ""
Local lAjuPar15		:= Len(AllTrim(mv_par15))==Len(mv_par15)
Local lAchouEmp		:= .T.                                
Local lAchouEst		:= .F.                                
Local nTamEH		:= TamSx3("EH_NUMERO")[1]
Local nTamEI		:= TamSx3("EI_NUMERO")[1]+TamSx3("EI_REVISAO")[1]+TamSx3("EI_SEQ")[1]
Local cCodUlt		:= SM0->M0_CODIGO
Local cFilUlt		:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Local nRecno  
Local nSavOrd 
Local aAreaSE5 
Local cChaveNSE5	:= ""           
Local nRecSE2		:= 0
Local aAreaSE2
Local aAreabk

Local aRet 			:= {}
Local cAuxFilNome
Local cAuxCliFor
Local cAuxLote
Local dAuxDtDispo
Local cFilUser	 	:= ""

Local lPCCBaixa 	:= SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local nTaxa			:= 0   
Local lUltBaixa 	:= .F.
Local cChaveSE1 	:= ""
Local cChaveSE5 	:= ""
Local cSeqSE5 		:= ""
Local lNaturez 		:= .F.  
Local lMVLjTroco	:= SuperGetMV("MV_LJTROCO", ,.F.)				
Local nRecnoSE5		:= 0
Local nValTroco 	:= 0
Local lTroco 		:= .F.

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emiss�o(default))
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nPccBxCr := 0
//Controla o Pis Cofins e Csll na RA (1 = Controla reten��o de impostos no RA; ou 2 = N�o controla reten��o de impostos no RA(default))
Local lRaRtImp  := If (FindFunction("FRaRtImp"),FRaRtImp(),.F.)

Local cEmpresa		:= IIF(lUnidNeg,FWCodEmp(),"")
Local cAge, cContaBco
Local cMascNat := ""
Local lConsImp := .T.

/* GESTAO - inicio */
Local cTmpSE5Fil	:= ""
Local lNovaGestao	:= .F.
Local nSelFil		:= 0
Local nLenSelFil	:= 0
Local lGestao	    := Iif( lFWCodFil, ( "E" $ FWSM0Layout() .And. "U" $ FWSM0Layout() ), .F. )	// Indica se usa Gestao Corporativa
Local lExclusivo 	:= .F.
Local aModoComp 	:= {}

/* GESTAO - fim */

Default lMultiNat := .F. 

/* GESTAO - inicio */ 
#IFDEF TOP
	lNovaGestao := .T.
#ELSE
	lNovaGestao := .F.
#ENDIF
/* GESTAO - fim */

If lFWCodFil .And. lGestao
	aAdd(aModoComp, FWModeAccess("SE5",1) )
	aAdd(aModoComp, FWModeAccess("SE5",2) )
	aAdd(aModoComp, FWModeAccess("SE5",3) )
	lExclusivo := Ascan(aModoComp, 'E') > 0
Else
	dbSelectArea("SE5")
	lExclusivo := !Empty(xFilial("SE5"))
EndIf

/*If R190Perg41()
	If MV_PAR41 == 2   
		lConsImp := .F.
	EndIf
EndIf*/

nGerOrig :=0

li := 1

//�����������������������������������������������������������Ŀ
//� Atribui valores as variaveis ref a filiais                �
//�������������������������������������������������������������
/* GESTAO - inicio */
If lNovaGestao
	nLenSelFil := Len(aSelFil)
	If mv_Par40 == 1
		If nLenSelFil > 0
			cFilDe 	:= aSelFil[1]
			cFilAte := aSelFil[nLenSelFil]
		Endif
	Else
		If mv_par17 == 2 // Cons filiais abaixo
			cFilDe := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
			cFilAte:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		Else
			cFilDe := mv_par18	// Todas as filiais
			cFilAte:= mv_par19
		EndIf
	EndIf
Else
	If mv_par17 == 2 // Cons filiais abaixo
		cFilDe := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		cFilAte:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	Else
		cFilDe := mv_par18	// Todas as filiais
		cFilAte:= mv_par19
	EndIf
Endif
/* GESTAO - fim */

// Definicao das condicoes e ordem de impressao, de acordo com a ordem escolhida pelo
// usuario.
DbSelectArea("SE5")
Do Case
Case nOrdem == 1
	cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
	cCond2 := "E5_DATA"
	cChave := IndexKey(1)
	cChaveInterFun := cChave
	bFirst := {|| MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
Case nOrdem == 2
	cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
	cCond2 := "E5_BANCO"
	cChave := IndexKey(3)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par03,.T.)}
Case nOrdem == 3
	cCondicao := "E5_MULTNAT = '1' .Or. (E5_NATUREZ >= mv_par05 .and. E5_NATUREZ <= mv_par06)"
	cCond2 := "E5_NATUREZ"
	cChave := IndexKey(4)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par05,.T.)}
Case nOrdem == 4
	cCondicao := ".T."
	cCond2 := "E5_BENEF"
	cChave := "E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 5
	cCondicao := ".T."
	cCond2 := "E5_NUMERO"
	cChave := "E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 6	//Ordem 6 (Digitacao)
	cCondicao := ".T."
	cCond2 := "E5_DTDIGIT"
	cChave := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5"),.T.)}
Case nOrdem == 7 // por Lote
	cCondicao := "E5_LOTE >= '"+mv_par20+"' .and. E5_LOTE <= '"+mv_par21+"'"
	cCond2 := "E5_LOTE"
	cChave := IndexKey(5)
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+mv_par20,.T.)}
OtherWise						// Data de Cr�dito (dtdispo)
	cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
	cCond2 := "E5_DTDISPO"
	cChave := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
	cChaveInterFun := cChave
	bFirst := {||MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
EndCase

If !Empty(mv_par28) .And. ! ";" $ mv_par28 .And. Len(AllTrim(mv_par28)) > 3
	ApMsgAlert(STR0073)//"Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	
If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert(STR0074)//"Separe os tipos que n�o deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif	

#IFDEF TOP
	If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
		
		lAsTop := .T.
		cCondicao := ".T."
		DbSelectArea("SE5")
		cQuery := ""
		aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})
		// Obtem os registros a serem processados
		cQuery := "SELECT " +SubStr(cQuery,2)
		cQuery +=         ",SE5.R_E_C_N_O_ SE5RECNO, "
		cQuery += " ( SELECT MAX(E5_SEQ)"
		cQuery += "     FROM "+RetSqlName("SE5")+ " SE52 "
        cQuery += "   WHERE SE52.E5_FILIAL  = SE5.E5_FILIAL " 
        cQuery += "     AND SE52.E5_RECPAG  = SE5.E5_RECPAG "
        cQuery += "     AND SE52.E5_CLIFOR  = SE5.E5_CLIFOR "
        cQuery += "     AND SE52.E5_LOJA    = SE5.E5_LOJA "
        cQuery += "     AND SE52.E5_PREFIXO = SE5.E5_PREFIXO "
        cQuery += "     AND SE52.E5_NUMERO  = SE5.E5_NUMERO "
        cQuery += "     AND SE52.E5_PARCELA = SE5.E5_PARCELA "
        cQuery += "     AND SE52.E5_TIPO    = SE5.E5_TIPO "
        cQuery += "     AND SE52.E5_SITUACA = SE5.E5_SITUACA "
        cQuery += "     AND SE52.E5_NATUREZ = SE5.E5_NATUREZ "
        cQuery += "     AND SE52.D_E_L_E_T_ = ' ' "
		cQuery += "     AND NOT EXISTS ( "
        cQuery += "         SELECT A.E5_NUMERO" 
        cQuery += "           FROM "+RetSqlName("SE5")+ " A" 
        cQuery += "          WHERE A.E5_FILIAL  = SE52.E5_FILIAL "  
        cQuery += "            AND A.E5_PREFIXO = SE52.E5_PREFIXO "
        cQuery += "            AND A.E5_NUMERO  = SE52.E5_NUMERO " 
        cQuery += "            AND A.E5_PARCELA = SE52.E5_PARCELA " 
        cQuery += "            AND A.E5_TIPO    = SE52.E5_TIPO " 
        cQuery += "            AND A.E5_CLIFOR  = SE52.E5_CLIFOR " 
        cQuery += "            AND A.E5_LOJA    = SE52.E5_LOJA " 
        cQuery += "            AND A.E5_SEQ     = SE52.E5_SEQ " 
        cQuery += "            AND A.E5_TIPODOC = 'ES' )  ) MAXSEQ "  //Coluna maxseq	 
		cQuery += "FROM " + RetSqlName("SE5")+" SE5 "
		cQuery += "WHERE E5_RECPAG = '" + IIF( mv_par11 == 1, "R","P") + "' AND "
		cQuery += "      E5_DATA    between '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' AND "
		cQuery += "      E5_DATA    <= '" + DTOS(dDataBase) + "' AND "

		If cPaisLoc == "ARG" .and. mv_par03 == mv_par04
			cQuery += "      (E5_BANCO = '" + mv_par03 + "' OR E5_BANCO = '" + Space(TamSX3("A6_COD")[1]) + "') AND "
		Else
			cQuery += "      E5_BANCO   between '" + mv_par03       + "' AND '" + mv_par04       + "' AND "		
		EndIf
		
		If cPaisLoc == "ARG" .and. mv_par11 == 2 // pagar
			cQuery += " (E5_DOCUMEN != ' ' AND E5_TIPO != 'CH') AND "
		Endif
		//-- Realiza filtragem pela natureza principal
		If mv_par39 == 2
			cQuery +=  " E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06     	+ "' AND "
		Else
			cQuery +=       " (E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06       + "' OR "
			cQuery +=       " EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA "
			cQuery +=                 " FROM "+RetSqlName("SEV")+" SEV "
			cQuery +=                " WHERE E5_FILIAL  = EV_FILIAL AND "
			cQuery +=                       "E5_PREFIXO = EV_PREFIXO AND "
			cQuery +=                       "E5_NUMERO  = EV_NUM AND "
			cQuery +=                       "E5_PARCELA = EV_PARCELA AND "
			cQuery +=                       "E5_TIPO    = EV_TIPO AND "		
			cQuery +=                       "E5_CLIFOR  = EV_CLIFOR AND "
			cQuery +=                       "E5_LOJA    = EV_LOJA AND " 
			cQuery +=                       "EV_NATUREZ between '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
			cQuery +=                       "SEV.D_E_L_E_T_ = ' ')) AND "
		EndIf
		cQuery += "      E5_CLIFOR  between '" + mv_par07       + "' AND '" + mv_par08       + "' AND "
		cQuery += "      E5_DTDIGIT between '" + DTOS(mv_par09) + "' AND '" + DTOS(mv_par10) + "' AND "
		cQuery += "      E5_LOTE    between '" + mv_par20       + "' AND '" + mv_par21       + "' AND "
		cQuery += "      E5_LOJA    between '" + mv_par22       + "' AND '" + mv_par23 	    + "' AND "
		cQuery += "      E5_PREFIXO between '" + mv_par26       + "' AND '" + mv_par27 	    + "' AND "
		cQuery += "      SE5.D_E_L_E_T_ = ' '  AND "
		cQuery += " 	  E5_SITUACA NOT IN ('C','E','X') AND "
		cQuery += "      ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR "
		cQuery += "      (E5_TIPODOC != 'CD')) "
		cQuery += "		  AND E5_HISTOR NOT LIKE '%"+STR0077+"%'"
		cQuery += "		  AND E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','ES'"
		If mv_par11 == 2
			cQuery += " ,'E2'"
		EndIf
		If mv_par16 == 2
			cQuery += " ,' '"
			cQuery += " ,'CH'" 
			cQuery += " ,'TR'" 
			cQuery += " ,'TE'"
		Endif
		cQuery += " )"
		If mv_par16 == 2
			cQuery += " AND E5_NUMERO  != '" + SPACE(LEN(E5_NUMERO)) + "'"
		Endif
		If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
			cQuery += " AND E5_TIPO IN "+FormatIn(mv_par28,";")
		ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
			cQuery += " AND E5_TIPO NOT IN "+FormatIn(mv_par29,";")
		EndIf
		
		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"		
				
		/* GESTAO - inicio */                            
		If mv_par40 == 1 .and. !Empty(aSelFil)
			If lExclusivo
				cQuery += " AND E5_FILIAL " + GetRngFil( aSelFil, "SE5", .T., @cTmpSE5Fil)
			Else
				cQuery += " AND E5_FILORIG " + FR190InFilial()
			Endif
		Else
			If mv_par17 == 2
				cQuery += " AND E5_FILIAL = '" + FwxFilial("SE5") + "'"
			Else
				If !lExclusivo
					cQuery += " AND E5_FILORIG between '" + cFilDe + "' AND '" + cFilAte + "'"
				Else
					cQuery += " AND E5_FILIAL between '" + cFilDe + "' AND '" + cFilAte + "'"
				EndIf
			Endif
		EndIf
		/* GESTAO - fim */
		
		cFilUser := oBaixas:GetSqlExp('SE5')

		If lF190Qry
			cQueryAdd := ExecBlock("F190QRY", .F., .F., {cFilUser})
			If ValType(cQueryAdd) == "C"
				cQuery += " AND (" + cQueryAdd + ")"
			EndIf
		EndIf

		If !Empty(cFilUser)
			cQuery += " AND (" + cFilUser + ") "
		EndIf
		
		// seta a ordem de acordo com a opcao do usuario
		cQuery += " ORDER BY " + SqlOrder(cChave) 
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "NEWSE5", .F., .T.)
		For nI := 1 TO LEN(aStru)
			If aStru[nI][2] != "C"
				TCSetField("NEWSE5", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
			EndIf
		Next
		DbGoTop()
	Else
#ENDIF
		//�������������������������������������������������������������Ŀ
		//� Abre o SE5 com outro alias para ser filtrado porque a funcao�        
		//� TemBxCanc() utilizara o SE5 sem filtro.							 �
		//���������������������������������������������������������������
		If Select("NEWSE5") == 0 .And. !( ChkFile("SE5",.F.,"NEWSE5") )
			Return(Nil)
		EndIf		
		lAsTop := .F.
		DbSelectArea("NEWSE5")
		cFilSE5 := 'E5_RECPAG=='+IIF(mv_par11 == 1,'"R"','"P"')+'.and.'
		cFilSE5 += 'DTOS(E5_DATA)>='+'"'+dtos(mv_par01)+'"'+'.and.DTOS(E5_DATA)<='+'"'+dtos(mv_par02)+'".and.'
		cFilSE5 += 'DTOS(E5_DATA)<='+'"'+dtos(dDataBase)+'".and.'
		If nOrdem == 3
			cFilSE5 += '(E5_MULTNAT = "1" .Or. (E5_NATUREZ>='+'"'+mv_par05+'"'+'.and.E5_NATUREZ<='+'"'+mv_par06+'")).and.'
		Else
			cFilSE5 += '(E5_NATUREZ>='+'"'+mv_par05+'"'+'.and.E5_NATUREZ<='+'"'+mv_par06+'").and.'
		Endif		
		cFilSE5 += 'E5_CLIFOR>='+'"'+mv_par07+'"'+'.and.E5_CLIFOR<='+'"'+mv_par08+'".and.'
		cFilSE5 += 'DTOS(E5_DTDIGIT)>='+'"'+dtos(mv_par09)+'"'+'.and.DTOS(E5_DTDIGIT)<='+'"'+dtos(mv_par10)+'".and.'
		cFilSE5 += 'E5_LOTE>='+'"'+mv_par20+'"'+'.and.E5_LOTE<='+'"'+mv_par21+'".and.'
		cFilSE5 += 'E5_LOJA>='+'"'+mv_par22+'"'+'.and.E5_LOJA<='+'"'+mv_par23+'".and.'
		cFilSe5 += 'E5_PREFIXO>='+'"'+mv_par26+'"'+'.And.E5_PREFIXO<='+'"'+mv_par27+'"'

		If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
			cFilSe5 += '.And.E5_TIPO $'+'"'+ALLTRIM(mv_par28)+Space(1)+'"'
		ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
			cFilSe5 += '.And.!(E5_TIPO $'+'"'+ALLTRIM(mv_par29)+Space(1)+'")'
		EndIf

		cFilUser := oBaixas:GetAdvPlExp('SE5')
		If !Empty(cFilUser)
			cFilSe5 += '.And. (' + cFilUser + ')'		
		Endif
		
		cCondFil := "NEWSE5->E5_FILIAL==xFilial('SE5')"
		
		If mv_par17 == 2
			cFilSe5 += " .AND. E5_FILIAL = '" + xFilial("SE5") + "'"
		Else
			If Empty( xFilial("SE5") )
				cFilSe5 += " .AND. E5_FILORIG >= '" + mv_par18 + "' .AND. E5_FILORIG <= '" + mv_par19 + "'"
			Else
				cFilSe5 +=" .AND. E5_FILIAL >= '" + mv_par18 + "' .AND. E5_FILIAL <= '" + mv_par19 + "'"
			EndIf
		Endif
#IFDEF TOP
	Endif
#ENDIF	
// Se nao for TOP, ou se for TOP e for AS400, cria Filtro com IndRegua
// Pois em SQL os registros ja estao filtrados em uma Query
If !lAsTop
	cNomeArq := CriaTrab(Nil,.F.)
	IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi(STR0018))  //"Selecionando Registros..."
Endif

//������������������������������������������Ŀ
//� Define array para arquivo de trabalho    �
//��������������������������������������������
AADD(aCampos,{"LINHA","C",80,0 } )

//����������������������������Ŀ
//� Cria arquivo de Trabalho   �
//������������������������������
cNomArq1 := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq1, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq1,"LINHA",,,OemToAnsi(STR0018))  //"Selecionando Registros..."

aColu := Iif(aTam[1] > 6,{023,027,TamParcela("E1_PARCELA",40,39,38),042,000,022},{000,004,TamParcela("E1_PARCELA",17,16,15),019,023,030})


If MV_PAR16 == 1

	dbSelectArea("SE5")
	dbSetOrder(17) //"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+E5_TIPODOC+E5_SEQ"
	dbGoTop()

Endif



DbSelectArea("SM0")
/* GESTAO - inicio */
If mv_par40 == 1 .and. lNovaGestao
	nSelFil := 0
Else
	DbSeek(cEmpAnt+If(Empty(cFilDe),"",cFilDe),.T.)
Endif

While !Eof() .and. SM0->M0_CODIGO == cEmpAnt .and.  If(mv_par40 ==1 .And. lNovaGestao,(nSelFil < nLenSelFil) .and. cFilDe <= cFilAte , SM0->M0_CODFIL <= cFilAte)
	If mv_par40 ==1 .and. lNovaGEstao
		nSelFil++
		DbSeek(cEmpAnt+aSelFil[nSelFil],.T.)
	Endif
/* GESTAO - fim */
	
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilNome:= SM0->M0_FILIAL
	DbSelectArea("NEWSE5")

	// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo
	// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
	/* GESTAO - inicio */
	IF !lNovaGestao
		If !lAsTop
			Eval(bFirst) // Posiciona no primeiro registro a ser processado
		Endif

		If lUnidNeg .and. (cEmpresa	<> FWCodEmp())
			SM0->(DbSkip())
			Loop
		Endif
	Endif
	/* GESTAO - fim */

	lMultiNat := .F.//inicializa variavel
	If mv_par11 = 2  //Pagar
		If mv_par39 != 3  //diferente de multinatureza verifica no SE2 se o campo esta preenchido
			SE2->(dbSetOrder(1))
			SE2->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
			lMultiNat := ( SE2->E2_MULTNAT == '1' ) //pq se o campo nao estiver preenchido nao desvia para FINR199
			lMultiNat := ( lMultiNat .And. MV_MULNATP .and. mv_par38 = 2 .and. mv_par39 != 2)
		Else
			lMultiNat := ( MV_MULNATP .and. mv_par38 = 2 .and. mv_par39 != 2)
		EndIf
	ElseIf mv_par11 = 1  //Receber
		lMultiNat := ( MV_MULNATR .and. mv_par38 = 2 .and. mv_par39 != 2 )
	EndIf
	
	If lMultiNat
	
		Finr199(	@nGerOrig,@nGerValor,@nGerDesc,@nGerJurMul,@nGerCM,@nGerAbLiq,@nGerAbImp,@nGerBaixado,@nGerMovFin,@nGerComp,;
					@nFilOrig,@nFilValor,@nFilDesc,@nFilJurMul,@nFilCM,@nFilAbLiq,@nFilAbImp,@nFilBaixado,@nFilMovFin,@nFilComp,;
					.F.,cCondicao,cCond2,aColu,lContinua,cFilSe5,lAsTop,Tamanho, @aRet, @aTotais, nOrdem, @nGerFat, @nFilFat,lNovaGestao)

		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
				dbSelectArea("SE5")
				dbCloseArea()
				ChKFile("SE5")
				dbSelectArea("SE5")
				dbSetOrder(1)
			Endif
		#ENDIF
		If Empty(xFilial("SE5"))
			Exit
		Endif
		dbSelectArea("SM0")
		cCodUlt := SM0->M0_CODIGO
 		cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		dbSkip()
		Loop

	Else

		While NEWSE5->(!Eof()) .And. &cCondFil .And. &cCondicao .and. lContinua
			
			DbSelectArea("NEWSE5")
			// Testa condicoes de filtro	
			If !u_Fr190TstCond(cFilSe5,.F.)
				NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
				Loop
			Endif							
						
			// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
			// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
			If !lAsTop 
				SE2->(dbSetOrder(1))
				SE2->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
				If SE2->E2_MULTNAT == '1'
					lNaturez := .F.					
					SEV->(dbSetOrder(1))
					SEV->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
					While NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) .and. !lNaturez
						If SEV->EV_NATUREZ >= mv_par05 .and. SEV->EV_NATUREZ <= mv_par06
							lNaturez := .T.
						EndIf
						SEV->(DbSkip())
					EndDo
					If !lNaturez
						NEWSE5->(dbSkip())
						Loop
					EndIf
				Else
					If !(NEWSE5->E5_NATUREZ >= mv_par05 .and. NEWSE5->E5_NATUREZ <= mv_par06)
						NEWSE5->(dbSkip())
						Loop
					EndIf					
				EndIf
			EndIf		 	
			If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
				(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
				cCarteira := "R"
			Else
				cCarteira := "P"
			Endif
	
			dbSelectArea("NEWSE5")
			cAnterior 	:= &cCond2
			nTotValor	:= 0
			nTotDesc	   := 0
			nTotJurMul  := 0
			nTotCM		:= 0
			nCT			:= 0
			nTotOrig	   := 0
			nTotBaixado	:= 0
			nTotAbLiq  	:= 0
			nTotImp		:= 0
			nTotMovFin	:= 0
			nTotComp		:= 0
			nTotFat		:= 0
	
			While NEWSE5->(!EOF()) .and. &cCond2=cAnterior .and. &cCondFil .and. lContinua
	
				lManual := .f.
				dbSelectArea("NEWSE5")
				
				If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
					(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
					lManual := .t.
				EndIf
				
				// Testa condicoes de filtro	
				If !u_Fr190TstCond(cFilSe5,.T.)
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
					Loop
				Endif	 						
					
				// Imprime somente cheques
				If mv_par37 == 1 .And. NEWSE5->E5_TIPODOC == "BA"

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.

					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura o cheque aglutinado, se encontrar, marca lAchou := .T. e despreza 
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC == "CH"
							lAchou := .T.
							Exit
						Endif
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif  	

				ElseIf mv_par37 == 2 .And. NEWSE5->E5_TIPODOC == "CH" //somente baixas

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.
					
					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(xFilial("SE5")+cChaveNSE5))					
               
					// Procura a baixa aglutinada, se encontrar despreza o movimento bancario
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC $ "BA"
							lAchou := .T.
							Exit
						Endif	
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif
				Endif	

				cNumero    	:= NEWSE5->E5_NUMERO
				cPrefixo   	:= NEWSE5->E5_PREFIXO
				cParcela   	:= NEWSE5->E5_PARCELA
				dBaixa     	:= NEWSE5->E5_DATA
				cBanco     	:= NEWSE5->E5_BANCO
				cAge			:= NEWSE5->E5_AGENCIA
				cContaBco		:= NEWSE5->E5_CONTA
				cNatureza  	:= NEWSE5->E5_NATUREZ
				cCliFor    	:= NEWSE5->E5_BENEF
				cLoja      	:= NEWSE5->E5_LOJA
				cSeq       	:= NEWSE5->E5_SEQ
				cNumCheq   	:= NEWSE5->E5_NUMCHEQ
				cRecPag     := NEWSE5->E5_RECPAG
				cTipodoc   	:= NEWSE5->E5_TIPODOC
				cMotBaixa	:= NEWSE5->E5_MOTBX
				cCheque    	:= NEWSE5->E5_NUMCHEQ
				cTipo      	:= NEWSE5->E5_TIPO
				cFornece   	:= NEWSE5->E5_CLIFOR
				cLoja      	:= NEWSE5->E5_LOJA
				dDigit     	:= NEWSE5->E5_DTDIGIT
				lBxTit	  	:= .F.
				cFilorig    := NEWSE5->E5_FILORIG
				
				If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
					(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
					dbSelectArea("SE1")
					dbSetOrder(1)
					// Procuro SE1 pela filial origem
					lBxTit := MsSeek(xFilial("SE1",cFilorig)+cPrefixo+cNumero+cParcela+cTipo)
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo)
					Endif				
					cCarteira := "R"
					dDtMovFin := IIF (lManual,CTOD("//"), DataValida(SE1->E1_VENCTO,.T.))
					While SE1->(!Eof()) .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
						If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja	// Cliente igual, Ok
							Exit
						Endif                                
						SE1->( dbSkip() )
					EndDo
					If !SE1->(EOF()) .And. mv_par11 == 1 .and. !lManual .and.  ;
						(NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
						If SE5->(FieldPos("E5_SITCOB")) > 0
							cExp := "NEWSE5->E5_SITCOB"
						Else
							cExp := "SE1->E1_SITUACA"
						Endif 
						
						If mv_par36 == 2 // Nao imprime titulos em carteira 
							// Retira da comparacao as situacoes branco, 0, F e G
							mv_par15 := AllTrim(mv_par15)       
							mv_par15 := StrTran(mv_par15,"0","")
							mv_par15 := StrTran(mv_par15,"F","")
							mv_par15 := StrTran(mv_par15,"G","")
						Else
							If (NEWSE5->E5_RECPAG == "R") .And. lAjuPar15
								mv_par15  += " "
							Endif
						EndIf	
				
						cExp += " $ mv_par15" 
						If !(&cExp)
							dbSelectArea("NEWSE5")
							NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
							Loop
						Endif
					Endif
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
				Else
					dbSelectArea("SE2")
					DbSetOrder(1)
					cCarteira := "P"
					// Procuro SE2 pela filial origem
				    lBxTit 	:= MsSeek(xFilial("SE2",cFilorig)+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
				    
				    Iif(lBxTit, nRecSE2	:= SE2->(Recno()), nRecSE2 := 0 )
				    
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
					Endif				
					dDtMovFin := IIF(lManual,CTOD("//"),DataValida(SE2->E2_VENCTO,.T.))
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
					cCheque    := Iif(Empty(NEWSE5->E5_NUMCHEQ),SE2->E2_NUMBCO,NEWSE5->E5_NUMCHEQ)
				Endif
				dbSelectArea("NEWSE5")
				cHistorico := Space(40)
				While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .And. &cCondFil
					
					dbSelectArea("NEWSE5")
					cTipodoc   := NEWSE5->E5_TIPODOC
					cCheque    := NEWSE5->E5_NUMCHEQ
					lAchouEmp := .T.
					lAchouEst := .F.
	
					// Testa condicoes de filtro	
					If !u_Fr190TstCond(cFilSe5,.T.)
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
						Loop
					Endif	  								
												
					If NEWSE5->E5_SITUACA $ "C/E/X" 
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					EndIF
					
					If NEWSE5->E5_LOJA != cLoja
						Exit
					Endif
	
					If NEWSE5->E5_FILORIG < mv_par33 .or. NEWSE5->E5_FILORIG > mv_par34
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					Endif
	
					//���������������������������������������������������Ŀ
					//� Nao imprime os registros de emprestimos excluidos �
					//�����������������������������������������������������					
					If NEWSE5->E5_TIPODOC == "EP"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEH")
						dbSetOrder(1)
						lAchouEmp := MsSeek(xFilial("SEH")+Substr(NEWSE5->E5_DOCUMEN,1,nTamEH))
						RestArea(aAreaSE5)
						If !lAchouEmp
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	
					//�����������������������������������������������������������������Ŀ
					//� Nao imprime os registros de pagamento de emprestimos estornados �
					//�������������������������������������������������������������������					
					If NEWSE5->E5_TIPODOC == "PE"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEI")
						dbSetOrder(1)
						If	MsSeek(xFilial("SEI")+"EMP"+Substr(NEWSE5->E5_DOCUMEN,1,nTamEI))
							If SEI->EI_STATUS == "C"
								lAchouEst := .T.
							EndIf
						EndIf
						RestArea(aAreaSE5)
						If lAchouEst
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	  
					//�����������������������������Ŀ
					//� Verifica o vencto do Titulo �
					//�������������������������������
					cFilTrb := If(mv_par11==1,"SE1","SE2")
					//cCmpVct	:= IIF(MV_PAR42	== 1 , "_VENCREA" , "_VENCTO")
					cCmpVct	:= "_VENCREA"
					If (cFilTrb)->(!Eof()) .And.;
						((cFilTrb)->&(Right(cFilTrb,2)+cCmpVct) < mv_par31 .Or. (!Empty(mv_par32) .And. (cFilTrb)->&(Right(cFilTrb,2)+cCmpVct) > mv_par32))
						Exit
					Endif
	            
					dBaixa     	:= NEWSE5->E5_DATA
					cBanco     	:= NEWSE5->E5_BANCO
					cAge			:= NEWSE5->E5_AGENCIA
					cContaBco		:= NEWSE5->E5_CONTA
					cNatureza  	:= NEWSE5->E5_NATUREZ
					cCliFor    	:= NEWSE5->E5_BENEF
					cSeq       	:= NEWSE5->E5_SEQ
					cNumCheq   	:= NEWSE5->E5_NUMCHEQ
					cRecPag		:= NEWSE5->E5_RECPAG
					cMotBaixa	:= NEWSE5->E5_MOTBX
					cTipo190		:= NEWSE5->E5_TIPO
					cFilorig    := NEWSE5->E5_FILORIG
					//��������������������������������������������������������������Ŀ
					//� Obter moeda da conta no Banco.                               �
					//����������������������������������������������������������������
					If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. ( FindFunction( "FXMultSld" ) .AND. FXMultSld() )
						SA6->(DbSetOrder(1))
						SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
						nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
					Else
						nMoedaBco	:=	1
					Endif
	
					If !Empty(NEWSE5->E5_NUMERO)
						If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
							(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG) .Or.;
							(NEWSE5->E5_RECPAG == "P" .And. NEWSE5->E5_TIPODOC $ "DB#OD")
							dbSelectArea( "SA1")
							dbSetOrder(1)
							lAchou := .F.
							If dbSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA) //SA1 pode est� comp s� por filial.
								lAchou := .T.
							Endif								
							If !lAchou
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA1 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA1 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA1 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA1->A1_NREDUZ,SA1->A1_NOME)
							Else
								cCliFor	:= 	Upper(Alltrim(NEWSE5->E5_BENEF))
							Endif
						Else
							dbSelectArea( "SA2")
							dbSetOrder(1)
							lAchou := .F.
							If dbSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								lAchou := .T.
							Endif							
							If !lAchou
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA2 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA2 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA2 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA2->A2_NREDUZ,SA2->A2_NOME)
							Else
								cCliFor	:= 	Upper(Alltrim(NEWSE5->E5_BENEF))
							Endif
						EndIf
					EndIf
					dbSelectArea("SM2")
					dbSetOrder(1)
					dbSeek(NEWSE5->E5_DATA)
					dbSelectArea("NEWSE5") 
					nTaxa:= 0

					If cPaisLoc=="BRA"
						If !Empty(NEWSE5->E5_TXMOEDA)
							nTaxa:=NEWSE5->E5_TXMOEDA
						Else
							If nMoedaBco == 1
								nTaxa := NEWSE5->E5_VALOR / NEWSE5->E5_VLMOED2
							Else
								nTaxa := NEWSE5->E5_VLMOED2 / NEWSE5->E5_VALOR
							EndIf																
						EndIf
					EndIf
					nRecSe5:=If(lAsTop,NEWSE5->SE5RECNO,Recno())
					nDesc+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLDESCO,Round(xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))
					nJuros+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLJUROS,Round(xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))
					nMulta+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLMULTA,Round(xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))
					nJurMul+= nJuros + nMulta
					nCM+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLCORRE,Round(xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,nTaxa),nDecs+1))

					If lPccBaixa .and. Empty(NEWSE5->E5_PRETPIS) .And. Empty(NEWSE5->E5_PRETCOF) .And. Empty(NEWSE5->E5_PRETCSL) .And. cCarteira == "P"
						If nRecSE2 > 0 
						
							aAreabk  := Getarea()
							aAreaSE2 := SE2->(Getarea())
							SE2->(DbGoto(nRecSE2))
						
							nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)+;
										SE2->E2_INSS+ SE2->E2_ISS+ SE2->E2_IRRF
										
							Restarea(aAreaSE2)
							Restarea(aAreabk)
						Else
							nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL) 
						Endif
					Endif				

					If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
						nValTroco := 0                                          					
						cHistorico := substr(NEWSE5->E5_HISTOR,1,12)

						If mv_par11 == 2
							If cPaisLoc == "ARG" .and. !EMPTY(NEWSE5->E5_ORDREC)
								nValor += Iif(VAL(NEWSE5->E5_MOEDA)==mv_par12,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,VAL(NEWSE5->E5_MOEDA),mv_par12,NEWSE5->E5_DATA,nDecs+1,NEWSE5->E5_TXMOEDA),nDecs+1))
							Else
							 	nValor += Iif(mv_par12==nMoedaBco,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VLMOED2,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0))+nJurMul-nDesc,nDecs+1))
							Endif
						Else
						 	nValor+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VLMOED2,SE1->E1_MOEDA,mv_par12,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDecs+1))
						EndIf						

						If lMVLjTroco
							lTroco := If(Substr(NEWSE5->E5_HISTOR,1,3)=="LOJ",.T.,.F.)
							If lTroco
								nRecnoSE5 := SE5->(Recno())
								DbSelectArea("SE5")
								DbSetOrder(7)
								If dbSeek(xFilial("SE5")+NEWSE5->E5_PREFIXO+NEWSE5->E5_NUMERO+NEWSE5->E5_PARCELA+Space(TamSX3("E5_TIPO")[1])+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									While !Eof() .AND. xFilial("SE5") == SE5->E5_FILIAL .AND. NEWSE5->E5_PREFIXO+NEWSE5->E5_NUMERO+NEWSE5->E5_PARCELA+Space(TamSX3("E5_TIPO")[1])+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA == SE5->E5_PREFIXO+;
														SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA
										
										If SE5->E5_MOEDA = "TC" .AND. SE5->E5_TIPODOC = "VL" .AND.;
											SE5->E5_RECPAG = "P" 
											nValTroco := SE5->E5_VALOR
										EndIf  
										SE5->(DbSkip())				    					
									EndDo
								EndIf
								SE5->(DbGoTo(nRecnoSE5)) 			   
							Endif
                        Endif                                                              
                        
						dbSelectArea("NEWSE5") 										
						
						nValor -= nValTroco

						//Pcc Baixa CR
						If cCarteira == "R" .and. lPccBxCr .and. cPaisLoc == "BRA" .And. (IiF(lRaRtImp,NEWSE5->E5_TIPO $ MVRECANT,.T.) .OR. lPccBaixa)
							If Empty(NEWSE5->E5_PRETPIS) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETPIS,Round(xMoeda(NEWSE5->E5_VRETPIS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCOF) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCOF,Round(xMoeda(NEWSE5->E5_VRETCOF,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCSL) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCSL,Round(xMoeda(NEWSE5->E5_VRETCSL,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif											
						Endif

					Else
						nVlMovFin+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
						cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",substr(NEWSE5->E5_HISTOR,1,12))
						cNatureza  	:= NEWSE5->E5_NATUREZ
					Endif	

					cAuxFilNome := cFilAnt + " - "+ cFilNome
					cAuxCliFor  := cCliFor					    
					cAuxLote    := E5_LOTE
					dAuxDtDispo := E5_DTDISPO

					Exit
				EndDO
	
				If (nDesc+nValor+nJurMul+nVlMovFin) > 0    
					AAdd(aRet, Array(31))

					// Defaults >>>
					aRet[Li][01] := ""
					aRet[Li][02] := ""
					aRet[Li][03] := ""
					aRet[Li][04] := ""
					aRet[Li][05] := ""
					// <<< Defaults
					
					aRet[Li][22] := cAuxFilNome
					aRet[Li][23] := cAuxCliFor
					aRet[Li][24] := cAuxLote
					aRet[Li][25] := dAuxDtDispo
					//������������������������������Ŀ
					//� C�lculo do Abatimento        �
					//��������������������������������
					If cCarteira == "R" .and. !lManual
						dbSelectArea("SE1")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0
						//�����������������������������������������������������������������������Ŀ
						//� Entra no if abaixo se titulo totalmente baixado e se for a maior
						// sequnecia de baixa no SE5 
						//�������������������������������������������������������������������������																		
						If !SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. Empty(SE1->E1_SALDO) .and.;
						    Iif(lAsTop, NEWSE5->MAXSEQ == NEWSE5->E5_SEQ, FSEQMAX(NEWSE5->E5_RECPAG,NEWSE5->E5_PREFIXO,NEWSE5->E5_NUMERO,NEWSE5->E5_PARCELA,NEWSE5->E5_TIPO,NEWSE5->E5_CLIFOR,NEWSE5->E5_LOJA) == NEWSE5->E5_SEQ ) 
							//��������������������������������������������������������������������Ŀ
							//� Calcula o valor total de abatimento do titulo e impostos se houver �
							//����������������������������������������������������������������������
							nTotAbImp  := 0  
							nAbat := SumAbatRec(cPrefixo,cNumero,cParcela,SE1->E1_MOEDA,"V",dBaixa,@nTotAbImp)
							nAbatLiq := nAbat - nTotAbImp
							cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
                                                                      
							SA1->(DBSetOrder(1))
							If SA1->(DBSeek(xFilial("SA1")+cCliFor190) )
								lCalcIRF := SA1->A1_RECIRRF == "1" .and. SA1->A1_IRBAX == "1" // se for na baixa 
							Else
								lCalcIRF := .F.	
							EndIf	
							If lCalcIRF							
								nTotAbImp += Iif(NEWSE5->E5_VRETIRF < SE1->E1_IRRF, NEWSE5->E5_VRETIRF, SE1->E1_IRRF)
							EndIf	
						ElseIf !SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. Empty(SE1->E1_SALDO) // Se n�o for maior seq, soma IR se na baixa 
							SA1->(DBSetOrder(1))
							If SA1->(DBSeek(xFilial("SA1")+cCliFor190) )
								lCalcIRF := SA1->A1_RECIRRF == "1" .and. SA1->A1_IRBAX == "1" // se for na baixa 
							Else
								lCalcIRF := .F.	
							EndIf	
							If lCalcIRF
								If lAsTop
									nTotAbImp += Iif(NEWSE5->MAXSEQ > "01", NEWSE5->E5_VRETIRF, SE1->E1_IRRF)
								Else
									nTotAbImp += Iif(FSEQMAX(NEWSE5->E5_RECPAG,NEWSE5->E5_PREFIXO,NEWSE5->E5_NUMERO,NEWSE5->E5_PARCELA,NEWSE5->E5_TIPO,NEWSE5->E5_CLIFOR,NEWSE5->E5_LOJA) > "01", NEWSE5->E5_VRETIRF, SE1->E1_IRRF)
								EndIF	
							EndIf	
						EndIf			
						dbSelectArea("SE1")
						dbGoTo(nRecno)
					Elseif !lManual
						dbSelectArea("SE2")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0						
						If !SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. Empty(SE2->E2_SALDO) .and.;
						    Iif(lAsTop, NEWSE5->MAXSEQ == NEWSE5->E5_SEQ, FSEQMAX(NEWSE5->E5_RECPAG,NEWSE5->E5_PREFIXO,NEWSE5->E5_NUMERO,NEWSE5->E5_PARCELA,NEWSE5->E5_TIPO,NEWSE5->E5_CLIFOR,NEWSE5->E5_LOJA) == NEWSE5->E5_SEQ )
							nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par12,,cFornece,cLoja)
							nAbatLiq := nAbat	
						EndIf			
						dbSelectArea("SE2")
						dbGoTo(nRecno)
					EndIF
					aRet[li][05]:= " "
					IF mv_par11 == 1 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							aRet[li][05] := SE1->E1_CLIENTE						
						Endif
						aRet[li][06] := AllTrim(cCliFor)
					Elseif mv_par11 == 2 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							aRet[li][05] := SE2->E2_FORNECE
						Endif
						aRet[li][06] := AllTrim(cCliFor)
					Endif
	
					aRet[li][01] := cPrefixo
					aRet[li][02] := cNumero
					aRet[li][03] := cParcela
					aRet[li][04] := cTipo		
	
					If !lManual
						dbSelectArea("TRB")
						lOriginal := .T.
						//������������������������������Ŀ
						//� Baixas a Receber             �
						//��������������������������������
						If cCarteira == "R"
							cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
							nVlr:= SE1->E1_VLCRUZ
							If mv_par12 > 1
								nVlr := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDecs+1)
							EndIF
							//������������������������������Ŀ
							//� Baixa de PA                  �
							//��������������������������������
						Else
							cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
                                                                      
							If cPaisLoc=="BRA"
								lCalcIRF:= Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == "1" .Or.;//1-Normal, 2-Baixa
								    	   Posicione("SA2",1,xFilial("SA2")+cCliFor190,"A2_CALCIRF") == " "
							Else 
								lCalcIRF:=.f.
							EndIf

							// MV_MRETISS "1" retencao do ISS na Emissao, "2" retencao na Baixa.
					   		nVlr:= SE2->E2_VLCRUZ
							If lConsImp   //default soma os impostos no valor original
								nVlr += SE2->E2_INSS+ Iif(GetNewPar('MV_MRETISS',"1")=="1",SE2->E2_ISS,0) +;
									   	Iif(lCalcIRF,SE2->E2_IRRF,0)
								If ! lPccBaixa  // SE PCC NA EMISSAO SOMA PCC
									nVlr += SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL
								EndIf
							EndIf

							If mv_par12 > 1
								nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1)
							Endif
						Endif
						aRet[li,29] := nRecSE5
						dbgoto(nRecSe5)
						cFilTrb := If(cCarteira=="R","SE1","SE2")
						IF DbSeek( xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo)
							nAbat:=0
							lOriginal := .F.
						Else
							nVlr:=NoRound(nVlr)
							RecLock("TRB",.T.)
							Replace linha With xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo
							MsUnlock()
						EndIF
					Else
						If lAsTop
							dbSelectArea("SE5")
						Else
							dbSelectArea("NEWSE5")
						Endif         
						aRet[li,29] := nRecSE5
						dbgoto(nRecSe5)
						nVlr := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par12,E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",E5_TXMOEDA,0)),nDecs+1)
						nAbat:= 0
						lOriginal := .t.
						If lAsTop
							nRecSe5:=NEWSE5->SE5RECNO
						Else
							nRecSe5:=Recno()
							NEWSE5->( dbSkip() )
						Endif
						dbSelectArea("TRB")
					Endif
					IF cCarteira == "R"
						If ( !lManual )
							If mv_par13 == 1  // Utilizar o Hist�rico da Baixa ou Emiss�o
								cHistorico := Iif(Empty(cHistorico), substr(SE1->E1_HIST,1,12), substr(cHistorico,1,12) )
							Else
								cHistorico := Iif(Empty(SE1->E1_HIST), substr(cHistorico,1,12), substr(SE1->E1_HIST,1,12) )
							Endif
						EndIf
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								aRet[li][05] := SE1->E1_CLIENTE
							Endif
							aRet[li][06] := AllTrim(cCliFor)
						Endif
						cMascNat := MascNat(cNatureza)
						aRet[li][07] := If(Len(Alltrim(cNatureza))>8, cNatureza, cMascNat)  
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						aRet[li][08] := IIf(lManual,dDtMovFin,DataValida(SE1->E1_VENCTO,.T.)) //Vencto
						aRet[li][09] := AllTrim(cHistorico)
						aRet[li][10] := dBaixa
						IF nVlr > 0
							aRet[li][11] := nVlr // Picture tm(nVlr,14,nDecs)
						Endif
					Else
						If mv_par13 == 1  // Utilizar o Hist�rico da Baixa ou Emiss�o
							cHistorico := Iif(Empty(cHistorico), substr(SE2->E2_HIST,1,12), substr(cHistorico,1,12) )
						Else
							cHistorico := Iif(Empty(SE2->E2_HIST), substr(cHistorico,1,12), substr(SE2->E2_HIST,1,12) )
						Endif
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								aRet[li][05] := SE2->E2_FORNECE
							Endif
							aRet[li][06] := AllTrim(cCliFor)
						Endif
						cMascNat := MascNat(cNatureza)
						aRet[li][07] := If(Len(Alltrim(cNatureza))>8, cNatureza, cMascNat)  
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						aRet[li][08] := IIf(lManual,dDtMovFin,DataValida(SE2->E2_VENCTO,.T.))
						If !Empty(cCheque)
							aRet[li][09] := ALLTRIM(cCheque)+"/"+Trim(cHistorico)
						Else
							aRet[li][09] := ALLTRIM(cHistorico)
						EndIf
						aRet[li][10] := dBaixa
						IF nVlr > 0
							aRet[li][11] := nVlr //Picture tm(nVlr,14,nDecs)
						Endif
					Endif
					nCT++
					aRet[li][12] := nJurMul    //PicTure tm(nJurMul,11,nDecs)
										
					If cCarteira == "R" .and. mv_par12 == SE1->E1_MOEDA					
					   aRet[li][13] := 0
					
					ElseIf cCarteira == "P" .and. mv_par12 == SE2->E2_MOEDA
					   aRet[li][13] := 0
					   
					Else					   
					   aRet[li][13] := nCM        //PicTure tm(nCM ,11,nDecs)
					   
					Endif

					//PCC Baixa CR
					//Somo aos abatimentos de impostos, os impostos PCC na baixa.
					//Caso o calculo do PCC CR seja pela emissao, esta variavel estara zerada
					nTotAbImp := nTotAbImp + nPccBxCr
					   
					aRet[li][14] := nDesc      //PicTure tm(nDesc,11,nDecs)
					aRet[li][15] := nAbatLiq  	//Picture tm(nAbatLiq,11,nDecs)
					aRet[li][16] := nTotAbImp 	//Picture tm(nTotAbImp,11,nDecs)
					If nVlMovFin > 0
						aRet[li][17] := nVlMovFin     //PicTure tm(nVlMovFin,15,nDecs)
					Else
						aRet[li][17] := nValor			//PicTure tm(nValor,15,nDecs)
					Endif
					aRet[li][18] := cBanco
					aRet[li][30] := cAge
					aRet[li][31] := cContaBco
					If Len(DtoC(dDigit)) <= 8
						aRet[li][19] := dDigit
					Else                   
						aRet[li][19] := dDigit
					EndIf
	
					If empty(cMotBaixa)
						cMotBaixa := "NOR"  //NORMAL
					Endif
	
					aRet[li][20] := Substr(cMotBaixa,1,3)
					aRet[li][21] := cFilorig
					
					aRet[li][26] := lOriginal
					aRet[li][27] := If( nVlMovFin <> 0, nVlMovFin , If(MovBcoBx(cMotBaixa),nValor,0))
					nTotOrig   += If(lOriginal,nVlr,0)
					nTotBaixado+= If(cTipodoc $ "CP/BA" .AND. cMotBaixa $ "CMP/FAT",0,nValor)		// n�o soma, j� somou no principal
					nTotDesc   += nDesc
					nTotJurMul += nJurMul
					nTotCM     += nCM
					nTotAbLiq  += nAbatLiq
					nTotImp    += nTotAbImp
					nTotValor  += If( nVlMovFin <> 0, nVlMovFin , If(MovBcoBx(cMotBaixa),nValor,0) )
					nTotMovFin += nVlMovFin
					nTotComp   += If(cTipodoc == "CP",nValor,0)
					nTotFat    += If(cMotBaixa $ "FAT",nValor,0)
					nDesc := nJurMul := nValor := nCM := nAbat := nTotAbImp := nAbatLiq := nVlMovFin := 0
					nPccBxCr	:= 0		//PCC Baixa CR
					li++
				Endif
				dbSelectArea("NEWSE5")
				DbSkip() //@@
				If lManual
					Exit
				EndIf
				
			Enddo

			If (nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8)
				cQuebra := DtoS(cAnterior)
			Else //nOrdem == 2 .or. nOrdem == 3 .or. nOrdem == 4 .or. nOrdem == 5 .or. nOrdem == 7
				cQuebra := cAnterior
			EndIf

			If (nTotValor+nDesc+nJurMul+nCM+nTotOrig+nTotMovFin+nTotComp+nTotFat)>0
				If nCT > 0
						If nTotBaixado > 0
							AAdd(aTotais,{cQuebra,STR0028,nTotBaixado})  //"Baixados"
						Endif	
						If nTotMovFin > 0
							AAdd(aTotais,{cQuebra,STR0031,nTotMovFin})  //"Mov Fin."
						Endif
						If nTotComp > 0
							AAdd(aTotais,{cQuebra,STR0037,nTotComp})  //"Compens."
						Endif
						If nTotFat > 0
							AAdd(aTotais,{cQuebra,STR0076,nTotFat})  //"Bx.Fatura"
						Endif						
				Endif
			Endif      
	
			//�������������������������Ŀ
			//�Incrementa Totais Gerais �
			//���������������������������
			nGerBaixado += nTotBaixado
			nGerMovFin	+= nTotMovFin
			nGerComp	+= nTotComp
			nGerFat		+= nTotFat

			//�������������������������Ŀ
			//�Incrementa Totais Filial �
			//���������������������������
			nFilOrig	+= nTotOrig
			nFilValor	+= nTotValor
			nFilDesc	+= nTotDesc
			nFilJurMul	+= nTotJurMul
			nFilCM		+= nTotCM
			nFilAbLiq	+= nTotAbLiq 
			nFilAbImp	+= nTotImp 		
			nFilBaixado += nTotBaixado
			nFilMovFin	+= nTotMovFin
			nFilComp	+= nTotComp 
			nFilFat     += nTotFat
		Enddo
	Endif	
	//����������������������������������������Ŀ
	//� Imprimir TOTAL por filial somente quan-�
	//� do houver mais do que 1 filial.        �
	//������������������������������������������
	if mv_par17 == 1 .and. SM0->(Reccount()) > 1
		If nFilBaixado > 0 
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0028, nFilBaixado } )  //"Baixados"
		Endif
		If nFilMovFin > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0031, nFilMovFin } )  //"Mov Fin."
		Endif
		If nFilComp > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0037, nFilComp } )  //"Compens."
		Endif
		If nFilFat > 0
			AAdd( aTotais,{ IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ), STR0076, nFilFat } )  //"Compens."
		Endif
		
		If Empty(xFilial("SE5")) .And. mv_par17 == 2
			Exit
		Endif	

		nFilOrig:=nFilJurMul:=nFilCM:=nFilDesc:=nFilAbLiq:=nFilAbImp:=nFilValor:=0
		nFilBaixado:=nFilMovFin:=nFilComp:=nFilFat:=0
	Endif
	dbSelectArea("SM0")
	cCodUlt := SM0->M0_CODIGO
	cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	dbSkip()
Enddo

If nGerBaixado > 0
	AAdd(aTotais,{STR0075,STR0028,nGerBaixado})  //"Baixados"
Endif	
If nGerMovFin > 0
	AAdd(aTotais,{STR0075,STR0031,nGerMovFin})  //"Mov Fin."
Endif
If nGerComp > 0
	AAdd(aTotais,{STR0075,STR0037,nGerComp})  //"Compens."
EndIf                             
If nGerFat > 0
	AAdd(aTotais,{STR0075,STR0076,nGerFat})  //"Bx.Fatura"
EndIf                             

SM0->(dbgoto(nRecEmp))                                                                            
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
dbSelectArea("TRB")
dbCloseArea()
Ferase(cNomArq1+GetDBExtension())
dbSelectArea("NEWSE5")
dbCloseArea() 

/* GESTAO - inicio */
If !Empty(cTmpSE5Fil)
	CtbTmpErase(cTmpSE5Fil)
Endif
/* GESTAO - fim */

If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif
dbSelectArea("SE5")
dbSetOrder(1)

Return aRet


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FR190MovCan� Autor � Marcelo Celi Marques � Data � 05.10.09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se o registro selecionado pertente a um titulo    ��� 
���          � cuja baixa foi cancelada, mas, que gerou mov bancario      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FR190MovCan(nIndexSE5,_SE5)								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nIndexSE5 - Filtro provis�rio criado no inicio da rotina	  ��� 
���          � E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ    >>	  ��� 
���          � +E5_TIPODOC+E5_SEQ                                   	  ���
���          � 															  ��� 
���          � _SE5 - Nome da tabela tempor�ria do SE5 gerada       	  ���
���          � no inicio da rotina										  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINR190/FINR199											  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FR190MovCan(nIndexSE5,_SE5)
	Local lRet := .F.
	Local aAreaSE5 := (_SE5)->(GetArea())
	
	If Empty((_SE5)->E5_MOTBX)
		dbSelectArea("SE5")
		dbSetOrder(nIndexSE5)
		If dbSeek((_SE5)->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+"EC"+E5_SEQ))
			lRet := .T.
		Endif
		dbSelectArea(_SE5)
		RestArea(aAreaSE5)
	Endif	
Return lRet

 /*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FR190ATSX1� Autor � Alexandre Circenis     � Data � 30/07/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza o grupo de campos das perguntas Codigo de e Codigo��� 
���          � at� com o mesmo grupo campos do Codigo Cliente/Fornecedor  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FR190ATSX1               								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ��� 
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINR190       											  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function FR190ATSX1()
Local aSavArea := GetArea()
Local aSavAreaSXG := SXG->(GetArea())
Local aSavAreaSX1 := SX1->(GetArea())
Local cGrupo := Padr("FIN190", Len(SX1->X1_GRUPO))
Local aPergs, aHelpPor, aHelpSpa, aHelpEng

SXG->(DbSeek('001'))

dbSelectArea("SX1")
dbSetOrder(1)

If dbSeek(cGrupo+"07") // Pergunta "Codigo de"
	// Verificar se ter� que alterar o Grupo ou o tamanho
	If SX1->X1_GRPSXG <> '001' .or. SX1->X1_TAMANHO <> SXG->XG_SIZE
		RecLock("SX1",.F.)
		SX1->X1_GRPSXG := "001"
		SX1->X1_TAMANHO := SXG->XG_SIZE
		MsUnlock()
	Endif
Endif
	
If dbSeek(cGrupo+"08") // Pergunta "Codigo at�"                   
	// Verificar se ter� que alterar o Grupo ou o tamanho
	If SX1->X1_GRPSXG <> '001' .or. SX1->X1_TAMANHO <> SXG->XG_SIZE
		RecLock("SX1",.F.)
		SX1->X1_GRPSXG := "001"
		SX1->X1_TAMANHO := SXG->XG_SIZE
		MsUnlock()
	Endif	
Endif

/* GESTAO - inicio */
If MsSeek(PadR("FIN190",Len(SX1->X1_GRUPO))+"17")
	aHelpPor := {'Selecione a op��o "Sim" para que a','gera��o do relat�rio considere as','filiais a serem informadas nos campos','a seguir, ou "N�o", caso deseja imprimir',' as baixas apenas da filial atual.',' Esta pergunta n�o ter� efeito em',' ambiente TOPCONNECT / TOTVSDBACCESS.'}       
	aHelpSpa := {'Elija la opcion "Si" para que la','generacion del informe considere las','sucursales que se deben informar en los','campos a seguir, o "No", cuando desee','imprimir las bajas apenas de la sucursal','actual. Esta pregunta no tendra efecto en','el entorno TOPCONNECT / TOTVSDBACCES.'} 
	aHelpEng := {'Select the option "Yes" for the report','generation to consider the branches to','be entered in the following fields. For','the opposite, select "No". This question',' does not work in TOPCONNECT / TOTVSDBACCESS environments.'}
	PutSX1Help("P.FIN19017.",aHelpPor,aHelpEng,aHelpSpa,.T.)
Endif
/*-*/
If MsSeek(PadR("FIN190",Len(SX1->X1_GRUPO))+"18")
	aHelpPor := {'Caso a resposta do par�metro anterior,','"Considera Filiais Abaixo?" seja igual','a "Sim", Informe o c�digo inicial do','intervalo de n�meros de filiais da sua','empresa, a serem considerados na gera��o',' do relat�rio. Esta pergunta n�o ter�','  efeito em ambiente TOPCONNECT /','  TOTVSDBACCESS.'}     
	aHelpSpa := {'Cuando la respuesta del parametro','anterior "�Considera Sucursales Abajo?"','sea igual a "Si", digite el codigo','inicial del intervalo de numeros de','sucursales de su empresa que se deben','considerar en la generacion del','informe. Esta pregunta no','tendra','efecto en el entorno TOPCONNECT /','TOTVSDBACCES.'}  
	aHelpEng := {'In case the answer given to the previous',' parameter ("Cons. Branches Below?") is',' "Yes", enter in this field the initial',' code of the interval related to your',' company�s branches number to be',' considered when generating the report.',' This question does not work in',' TOPCONNECT / TOTVSDBACCESS',' environments.'}
	PutSX1Help("P.FIN19018.",aHelpPor,aHelpEng,aHelpSpa,.T.)
Endif
/*-*/
If MsSeek(PadR("FIN190",Len(SX1->X1_GRUPO))+"19")
	aHelpPor := {'Caso a resposta do par�metro anterior,','"Considera Filiais Abaixo?" seja igual','a "Sim", Informe o c�digo final do','intervalo de n�meros de filiais da sua','empresa, a serem considerados na gera��o',' do relat�rio. Esta pergunta n�o ter�','  efeito em ambiente TOPCONNECT /','  TOTVSDBACCESS.'}     
	aHelpSpa := {'Cuando la respuesta del parametro','anterior "�Considera Sucursales Abajo?"','sea igual a "Si", digite el codigo','final del intervalo de numeros de','sucursales de su empresa que se deben','considerar en la generacion del','informe. Esta pregunta no','tendra','efecto en el entorno TOPCONNECT /','TOTVSDBACCES.'}  
	aHelpEng := {'In case the answer given to the previous',' parameter ("Cons. Branches Below?") is',' "Yes", enter in this field the final',' code of the interval related to your',' company�s branches number to be',' considered when generating the report.',' This question does not work in',' TOPCONNECT / TOTVSDBACCESS',' environments.'}
	PutSX1Help("P.FIN19019.",aHelpPor,aHelpEng,aHelpSpa,.T.)
Endif
/*-*/
If MsSeek(PadR("FIN190",Len(SX1->X1_GRUPO))+"40").And. SX1->X1_PERGUNT!="Seleciona Filiais?"
	RecLock( "SX1", .F. )
	SX1->( DbDelete() )
	MsUnLock() 
EndIf

If !MsSeek(PadR("FIN190",Len(SX1->X1_GRUPO))+"40") 
	aHelpPor := {"Escolha Sim se deseja selecionar ","as filiais. ","Esta pergunta somente ter� efeito em","ambiente TOTVSDBACCESS (TOPCONNECT) / ","TReport."}			
	aHelpEng := {"Enter Yes if you want to select ","the branches.","This question affects TOTVSDBACCESS","(TOPCONNECT) / TReport environment only."}
	aHelpSpa := {"La opci�n S�, permite seleccionar ","las sucursales.","Esta pregunta solo tendra efecto en el ","entorno TOTVSDBACCESS (TOPCONNECT) / ","TReport."}

	PutSx1( "FIN190", "40", "Seleciona Filiais?" ,"�Selecciona sucursales?" ,"Select Branches?","mv_chy","N",1,0,2,"C","","","","S","mv_par40","Sim","Si ","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

	PutSX1Help("P.FIN19040.",aHelpPor,aHelpEng,aHelpSpa,.T.)
Endif
// GESTO - fim 

If !dbSeek(cGrupo+"41")  //se nao existir cria a pergunta Col.Vlr.Original ? Soma Impostos - Nao Soma Impostos

	aHelpPor := {"Informa se na coluna Valor Original ",;
				  "se deve somar os impostos ou nao.   "}
	aHelpSpa := {"Informes sobre la columna Valor     ",;
				  "original hay que a�adir los impuestos o no."}
	aHelpEng := {"Reports on the Original Value column",;
				  "must be added taxes or not." }
	// faz o ajuste no sx1 dos arquivos
	PutSx1( cGrupo, "41","Coluna Valor Original ? " , "Col.Vlr.Original ? "       , "Orig.Value column?"    , "mv_ch_","N", 1	,0	,0	,"C", ""                                                            , ""   , ""   , "S", "mv_par41","Soma Impostos"                  ,"Sum impuestos"     		       ,"sum Taxes"      	           ,"","N�o Soma Impost"                 ,"No Sum impuest"               ,"Not sum Taxes"                   , ""                                                   			, ""     , ""     , ""               , ""                                                            , ""               , ""               , ""               , ""                                                            , aHelpPor, aHelpEng, aHelpSpa, "")

EndIf

RestArea(aSavAreaSXG)
RestArea(aSavAreaSX1)

RestArea(aSavArea)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �R190Perg41�Autor  �Microsiga           � Data �  19/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se tem a pergunta                                 ���
���          �  Col.Vlr.Original ? Soma Imposto / Nao Soma Imposto        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function R190Perg41()
Local lRet := .F.
SX1->( dbSetOrder(1) )
If SX1->( dbSeek( PadR( "FIN190", Len(SX1->X1_GRUPO) )+"41" ) )
	lRet := .T.
EndIf
Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} FR190InFilial

Formata uma string com todas as filiais selecionadas pelo usuario,
para que seja usada no parametro "IN" da query

@author daniel.mendes

@since 05/05/2014
@version P1180
 
@return Retorna uma string com as filiais selecionadas
/*/
//-------------------------------------------------------------------
Static Function FR190InFilial()
Local cRetornoIn := ""
Local nFor := 0

	For nFor := 1 To Len(aSelFil)
		cRetornoIn += aSelFil[nFor] + '|' 
	Next nFor

Return " IN " + FormatIn( SubStr( cRetornoIn , 1 , Len( cRetornoIn ) -1 ) , '|' )

//-------------------------------------------------------------------
/*/{Protheus.doc} FSEQMAX

Funcao para base codebase para buscar a ultima sequencia da SE5 da baixa

@author karen honda

@since 21/02/2017
@version P1180
 
@return Retorna a ultima sequencia da SE5 do titulo
/*/
//-------------------------------------------------------------------
Static Function FSEQMAX(cRecPag,cPrefixo,cNum,cParcela,cTipo,cCliente,cLoja)
Local cSeqMax := ""
Local aAreaSE5 := SE5->(GetArea())

	SE5->(DBSetOrder(7)) //E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ, R_E_C_N_O_, D_E_L_E_T_
	SE5->(DBSEEK(xFilial("SE5") + cPrefixo + cNum + cParcela + cTipo + cCliente + cLoja))
	While SE5->(!Eof()) .and. SE5->(E5_FILIAL+ E5_PREFIXO+ E5_NUMERO+ E5_PARCELA+ E5_TIPO+ E5_CLIFOR+ E5_LOJA) == xFilial("SE5") + cPrefixo + cNum + cParcela + cTipo + cCliente + cLoja
		If SE5->E5_RECPAG = cRecPag .AND. SE5->E5_TIPODOC != 'ES'
			cSeqMax := SE5->E5_SEQ
		EndIf	
		SE5->(DbSkip())
	EndDo

RestArea(aAreaSE5)	
Return cSeqMax 	


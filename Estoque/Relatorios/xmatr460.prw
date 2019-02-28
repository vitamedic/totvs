#INCLUDE "MATR460.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE TT	Chr(254)+Chr(254)	// Substituido p/ "TT"   
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MATR460 � Autor � Nereu Humberto Junior � Data � 31/07/06  ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Relatorio do Inventario, Registro Modelo P7                ���
���          � Plano de Melhoria Continua                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/


/*
���ITEM PMC  � Responsavel              � Data          |BOPS             ���
�������������������������������������������������������������������������Ĵ��
���      01  � Marcos V. Ferreira       � 24/01/2006    |                 ���
���      02  � Erike Yuri da Silva      � 21/12/2005    |                 ���
���      03  � Marcos V. Ferreira       � 20/12/2005    |                 ���
���      04  � Rodrigo de A Sartorio    � 30/12/2005    |                 ���
���      05  � Rodrigo de A Sartorio    � 30/12/2005    |                 ���
���      06  � Marcos V. Ferreira       � 24/01/2006    |                 ���
���      07  � Marcos V. Ferreira       � 20/12/2005    |                 ���
���      08  � Flavio Luiz Vicco        � 06/04/2006    | 00000096610     ���
���      09  � Flavio Luiz Vicco        � 06/04/2006    | 00000096610     ���
���      10  � Erike Yuri da Silva      � 21/12/2005    |                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function XMATR460()
Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	XMATR460R3()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Nereu Humberto Junior  � Data �31.07.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relatorio                                  ���
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

Local oReport 
Local oCell         
Local oSection1
//��������������������������������������������������������������Ŀ
//� Verifica se utiliza custo unificado por Empresa/Filial       �
//����������������������������������������������������������������
Local lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao do fonte        �
//� SIGACUSA.PRX aplicados no rpo do cliente, assim verificando     |
//| a necessidade de uma atualizacao nestes fontes. NAO REMOVER !!!	�
//�������������������������������������������������������������������
If !(FindFunction("SIGACUS_V") .And. SIGACUS_V() >= 20060810)
    Final(STR0040 + " SIGACUS.PRW !!!") // "Atualizar SIGACUS.PRW"
EndIf
If !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20060321)
    Final(STR0040 + " SIGACUSA.PRX !!!") // "Atualizar SIGACUSA.PRX"
EndIf

//��������������������������������������������������������������Ŀ
//� Ajusta as Perguntas do SX1				                     �
//����������������������������������������������������������������
AjustaSX1()

//��������������������������������������������������������������Ŀ
//� Ajusta perguntas no SX1 a fim de preparar o relatorio p/     �
//� custo unificado por empresa                                  �
//����������������������������������������������������������������
If lCusUnif
	MTR460CUnf(lCusUnif)
EndIf

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
oReport:= TReport():New("MATR460",STR0001,"MTR460", {|oReport| ReportPrint(oReport)},STR0002) //"Registro de Invent�rio - Modelo P7"##"Emiss�o do Registro de Invent�rio.Os Valores Totais serao impressos conforme Modelo Legal"
oReport:SetTotalInLine(.F.)
oReport:SetEdit(.T.)
oReport:HideHeader() 
oReport:HideFooter()

//���������������������������������������������������������������
//�Secao criada para evitar error log no botao Personalizar     �
//���������������������������������������������������������������
oSection1 := TRSection():New(oReport,STR0042,{"SB1"}) //"Saldos em Estoque"
oSection1:SetReadOnly()

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
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
//����������������������������������������������������������������
Pergunte("MTR460",.F.)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Nereu Humberto Junior  � Data �21.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Verifica se utiliza custo unificado por Empresa/Filial       �
//����������������������������������������������������������������
Local lCusUnif  := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))

//����������������������������������������������������������������������������Ŀ
//� Quantidade e custo na 1a moeda para movimentos do SD3 com D3_CF RE9 ou DE9 |
//������������������������������������������������������������������������������
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

//����������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas no processamento por Filiais                          |
//������������������������������������������������������������������������������
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
		
//����������������������������������������������������������������������������Ŀ
//� A460UNIT - Ponto de Entrada utilizado para regravar os campos :            |
//|            TOTAL, VALOR_UNIT e QUANTIDADE                                  |
//������������������������������������������������������������������������������
lCalcUni := If(lCalcUni == NIL, ExistBlock("A460UNIT"),lCalcUni)

//����������������������������������������������������������������������������Ŀ
//� Cria Arquivo Temporario                                                    �
//� SITUACAO: 1=ESTOQUE,2=PROCESSO,3=SEM SALDO,4=DE TERCEIROS,5=EM TERCEIROS,  �
//�           6=DE TERCEIROS USADO EM ORDENS DE PRODUCAO                       �
//������������������������������������������������������������������������������
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

//����������������������������������������������������������������������������Ŀ
//� Processando Relatorio por Filiais                                          �
//������������������������������������������������������������������������������
If !Empty(aFilsCalc)

	For nForFilial := 1 To Len( aFilsCalc )
	
		If aFilsCalc[ nForFilial, 1 ]
		
			//-- Muda Filial para processamento
			cFilAnt := aFilsCalc[ nForFilial, 2 ]
	
			//����������������������������������������������������������������������������Ŀ
			//| Impressao dos Livros                                                       |
			//������������������������������������������������������������������������������
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
				IndRegua(cArqTemp,cIndTemp1,cKeyInd,,,STR0014)				//"Indice Tempor�rio..."
				IndRegua(cArqTemp,cIndTemp2,"PRODUTO+SITUACAO",,,STR0014)	//"Indice Tempor�rio..."
				
				Set Cursor Off
				DbClearIndex()
				DbSetIndex(cIndTemp1+OrdBagExt())
				DbSetIndex(cIndTemp2+OrdBagExt())

				//������������������������������������������������������������������������Ŀ
				//�Filtragem do relatorio                                                  �
				//��������������������������������������������������������������������������
				#IFDEF TOP
					//������������������������������������������������������������������������Ŀ
					//�Transforma parametros Range em expressao SQL                            �	
					//��������������������������������������������������������������������������
					MakeSqlExpr(oReport:uParam)
					
					cAliasTop := GetNextAlias()
					lQuery    := .T.
				
					//������������������������������������������������������������������������Ŀ
					//�Query do relatorio da secao 1                                           �
					//��������������������������������������������������������������������������
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
		
					//������������������������������������������������������������������������Ŀ
					//�Metodo EndQuery ( Classe TRSection )                                    �
					//�                                                                        �
					//�Prepara o relatorio para executar o Embedded SQL.                       �
					//�                                                                        �
					//�ExpA1 : Array com os parametros do tipo Range                           �
					//�                                                                        �
					//��������������������������������������������������������������������������
					oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
					
				#ELSE

					dbSelectArea("SB1")
					dbSetOrder(1)
					//������������������������������������������������������������������������Ŀ
					//�Transforma parametros Range em expressao Advpl                          �
					//��������������������������������������������������������������������������
					MakeAdvplExpr(oReport:uParam)
				
					cCondicao := 'B1_FILIAL == "'+xFilial("SB1")+'".And.' 
					cCondicao += 'B1_COD >= "'+mv_par05+'".And.B1_COD <="'+mv_par06+'"'
					
					oReport:Section(1):SetFilter(cCondicao,IndexKey())
				
				#ENDIF		
		
				//������������������������������������������������������������������������Ŀ
				//�Inicio da impressao do fluxo do relatorio                               �
				//��������������������������������������������������������������������������
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

					//��������������������������������������������������������������Ŀ
					//� Alimenta Array com Saldo D = De Terceiros/ T = Em Terceiros  �
					//����������������������������������������������������������������
					If lSaldTerceir
						aSaldoTerD   := SaldoTerc(If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),cAlmoxIni,"D",dDtFech,cAlmoxFim,,If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),lSaldTerceir,lCusFIFO)
						aSaldoTerT   := SaldoTerc(If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),cAlmoxIni,"T",dDtFech,cAlmoxFim,,If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),lSaldTerceir,lCusFIFO)
					EndIf
							
					//��������������������������������������������������������������Ŀ
					//� Busca Saldo em Estoque  					                 �
					//����������������������������������������������������������������
					lFirst	  := .T.
					aSalAtu	  :={}
					aSaldo    :={0,0}
				
					//-- Posiciona na tabela de Saldos SB2
					If !lQuery
						dbSelectArea("SB2")
						dbSeek(xFilial("SB2")+SB1->B1_COD+If(Empty(cAlmoxIni), "", cAlmoxIni),.T.)
					EndIf
				
					If If(lQuery,Empty((cAliasTop)->B2_COD),Eof() .Or. !(SB1->B1_COD == SB2->B2_COD))
						//��������������������������������������������������������������Ŀ
						//� Lista produtos sem movimentacao de estoque                   �
						//����������������������������������������������������������������
						If lListProdMov
							//����������������������������������������������������������Ŀ
							//� TIPO 3 - PRODUTOS SEM SALDO                              �
							//������������������������������������������������������������
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
						//��������������������������������������������������������������Ŀ
						//� Lista produtos com movimentacao de estoque                   �
						//����������������������������������������������������������������
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

							//��������������������������������������������������������������Ŀ
							//� Desconsidera almoxarifado de saldo em processo de mat.indiret�
							//� ou saldo em armazem de terceiros                             �
							//����������������������������������������������������������������
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

							//����������������������������������������������������������Ŀ
							//� TIPO 1 - EM ESTOQUE                                      �
							//������������������������������������������������������������
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
							
							//���������������������������������������������������������������������������Ŀ
							//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
							//�����������������������������������������������������������������������������			
							If lCalcUni
								ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
							EndIf
							
							MsUnLock()
							dbSelectArea(cAliasTop)
							dbSkip()
						EndDo

						//���������������������������������������������������������������������������Ŀ
						//� Pesquisa os valores de material de terceiros requisitados para OP         �
						//�����������������������������������������������������������������������������			
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
								//���������������������������������������������������������������������������Ŀ
								//� Recalcula valor unitario                                                  �
								//�����������������������������������������������������������������������������			
								If QUANTIDADE>0
									Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
								EndIf

								//���������������������������������������������������������������������������Ŀ
								//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
								//�����������������������������������������������������������������������������			
								If lCalcUni
									ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
								EndIf

								MsUnLock()				                 				
							EndIf
						EndIf
						//���������������������������������������������������������������������������Ŀ
						//� Tratamento de poder de terceiros                                          �
						//�����������������������������������������������������������������������������			
						If lSaldTerceir .And. If(lQuery,.T.,SB1->B1_FILIAL==xFilial("SB1"))
							//���������������������������������������������������������������������������Ŀ
							//� Pesquisa os valores D = De Terceiros na array aSaldoTerD                  �
							//�����������������������������������������������������������������������������			
							nX := aScan(aSaldoTerD,{|x| x[1] == xFilial("SB6")+If(lQuery,aCampos[2],SB1->B1_COD)})
							If !(nX == 0)
								aSaldo[1] := aSaldoTerD[nX][3]
								aSaldo[2] := aSaldoTerD[nX][4]
							EndIf
							//�������������������������������������������������������������������������������������Ŀ
							//� Manipula arquivo de trabalho subtraindo do saldo em estoque saldo de terceiros      �
							//���������������������������������������������������������������������������������������			
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
							//���������������������������������������������������������������������������Ŀ
							//� Pesquisa os valores de material de terceiros requisitados para OP         �
							//�����������������������������������������������������������������������������			
							If lAgregOP .And. If(lQuery,aCampos[8] == "1",SB1->B1_AGREGCU == "1")
								//���������������������������������������������������������������������������Ŀ
								//� Desconsidera do calculo do saldo em estoque movimentos RE9 e DE9          �
								//�����������������������������������������������������������������������������			
								If (QtdComp(aDadosCF9[1]) > QtdComp(0)) .Or. (QtdComp(aDadosCF9[2]) > QtdComp(0))
									Replace QUANTIDADE 	With QUANTIDADE+aDadosCF9[1]
									Replace TOTAL		With TOTAL+aDadosCF9[2]
								EndIf
							EndIf
							//���������������������������������������������������������������������������Ŀ
							//� Recalcula valor unitario                                                  �
							//�����������������������������������������������������������������������������			
							If QUANTIDADE>0
								Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
							EndIf
							//���������������������������������������������������������������������������Ŀ
							//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
							//�����������������������������������������������������������������������������			
							If lCalcUni
								ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
							EndIf
							MsUnLock()				                 				
						EndIf
					EndIf

					If !lQuery
						dbSelectArea("SB1")
					EndIf
				
					//���������������������������������������������������������������������������Ŀ
					//� Processa Saldo De Terceiro TIPO 4 - SALDO DE TERCEIROS                    �
					//�����������������������������������������������������������������������������			
					R460Terceiros(@lEnd,cArqTemp,"4",lQuery,aCampos,aDadosCF9) // Saldos de Terceiros

					//���������������������������������������������������������������������������Ŀ
					//� Processa Saldo Em Terceiro TIPO 5 - SALDO EM TERCEIROS                    �
					//�����������������������������������������������������������������������������			
					R460Terceiros(@lEnd,cArqTemp,"5",lQuery,aCampos,NIL)		// Saldos em Terceiros
				
					If lQuery
						dbSelectArea(cAliasTop)
					Else
						dbSelectArea("SB1")
						dbSkip()
					EndIf
				
				EndDo
				
				lEnd:= oReport:Cancel()
				
				//���������������������������������������������������������������������������Ŀ
				//� Processa Saldo Em Processo TIPO 2 - SALDO EM PROCESSO                     �
				//�����������������������������������������������������������������������������			
				If lSaldProcess
					XR460EmProcesso(@lEnd,cArqTemp,.T.,cProdIni,cProdFim,cAlmoxIni,cAlmoxFim,mv_par20==1,dDtFech,lCalcProcDt,nQuebraAliq,lListCustMed)
				EndIf
				
				//���������������������������������������������������������������������������Ŀ
				//� CUSTO UNIFICADO - Realiza acerto dos valores para todos tipos             �
				//�����������������������������������������������������������������������������
				If lCusUnif
					dbSelectArea(cArqTemp)
					dbSetOrder(2)
					dbGotop()
					//��������������������������������������������������������������Ŀ
					//� Percorre arquivo                                             �
					//����������������������������������������������������������������
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
				
				//��������������������������������������������������������������Ŀ
				//� Imprime Modelo P7                                            �
				//����������������������������������������������������������������
				dbSelectArea(cArqTemp)
				dbSetOrder(1)
				dbGotop()

				oReport:SetMeter((cArqTemp)->(LastRec()))
				
				//��������������������������������������������������������������Ŀ
				//� Flags de Impressao                                           �
				//����������������������������������������������������������������
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
								//��������������������������������������������������������������Ŀ
								//� Controla impressao de Produtos com saldo negativo ou zerado  �
								//����������������������������������������������������������������
								If (!lListProdNeg.And.QUANTIDADE<0).Or.(!lListProdZer.And.QUANTIDADE==0).Or.(!lListCustZer.And.TOTAL==0)
									dbSkip()
									Loop
								Else
									nTotIpi+=TOTAL
									R460Acumula(aTotal)
								EndIf
								//�����������������������������������������������������������������Ŀ
								//� Inicializa array com itens de impressao de acordo com MV_PAR15  �
								//�������������������������������������������������������������������
				
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
				
								//�����������������������������������������������������������������Ŀ
								//� Salta registros Zerados ou Negativos Conforme Parametros        �
								//� Necessario Ajustar Posicao p/ Totalizacao de Grupos (POSIPI)    �
								//�������������������������������������������������������������������
								While !oReport:Cancel() .And. !Eof() .And. ((!lListProdNeg.And.QUANTIDADE<0).Or.(!lListProdZer.And.QUANTIDADE==0).Or.(!lListCustZer.And.TOTAL==0))
									dbSkip()
								EndDo
								//��������������������������������������������������������������Ŀ
								//� Verifica se imprime total por POSIPI.                        �
								//����������������������������������������������������������������
								If !(cSitAnt+cTipoAnt+cPosIpi==SITUACAO+TIPO+POSIPI) .And. nQuebraAliq == 1
									aImp[07] := Transform(nTotIPI,"@E 999,999,999,999.99")
								EndIf
								//��������������������������������������������������������������Ŀ
								//� Imprime cabecalho                                            �
								//����������������������������������������������������������������
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
								//��������������������������������������������������������������Ŀ
								//� Imprime linhas de detalhe de acordo com parametro (mv_par15) �
								//����������������������������������������������������������������
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
						//��������������������������������������������������������������Ŀ
						//� Impressao de Totais                                          �
						//����������������������������������������������������������������
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
			
				//��������������������������������������������������������������Ŀ
				//� Apaga Arquivos Temporarios                                   �
				//����������������������������������������������������������������
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
			
			//����������������������������������������������������������������������������Ŀ
			//| Impressao dos Termos                                                       |
			//������������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MATR460R3 � Autor � Juan Jose Pereira     � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio do Inventario, Registro Modelo P7                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function XMATR460R3()
Local wnrel
Local Titulo	:= STR0001	//"Registro de Invent�rio - Modelo P7"
Local cDesc1	:= STR0002	//"Emiss�o do Registro de Invent�rio.Os Valores Totais serao impressos conforme Modelo Legal"
Local cDesc2	:= ""
Local cDesc3	:= ""
Local cString	:= "SB1"
Local NomeProg	:= "MATR460"
Local aSave		:= {Alias(),IndexOrd(),Recno()}
Local Tamanho	:= "M"
//����������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas no processamento por Filiais                          |
//������������������������������������������������������������������������������
Local cFilBack  := cFilAnt
Local nForFilial:= 0
Local aFilsCalc := {}

Private aReturn	 := {STR0005,1,STR0006,2,2,1,"",1}	//"Zebrado"###"Administra��o"
Private nLastKey := 0
Private cPerg    := "MTR460"
Private nTipo    := 0
Private	nDecVal  := TamSX3("B2_CM1")[2] // Retorna o numero de decimais usado no SX3
Private lImpSX1  := .T.

//��������������������������������������������������������������Ŀ
//� Verifica se utiliza custo unificado por Empresa/Filial       �
//����������������������������������������������������������������
Private lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao do fonte        �
//� SIGACUSA.PRX aplicados no rpo do cliente, assim verificando     |
//| a necessidade de uma atualizacao nestes fontes. NAO REMOVER !!!	�
//�������������������������������������������������������������������
If !(FindFunction("SIGACUS_V") .And. SIGACUS_V() >= 20060810)
    Final(STR0040 + " SIGACUS.PRW !!!") // "Atualizar SIGACUS.PRW"
EndIf
If !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20060321)
    Final(STR0040 + " SIGACUSA.PRX !!!") // "Atualizar SIGACUSA.PRX"
EndIf

//��������������������������������������������������������������Ŀ
//� Ajusta as Perguntas do SX1				                     �
//����������������������������������������������������������������
AjustaSX1()

//��������������������������������������������������������������Ŀ
//� Ajusta perguntas no SX1 a fim de preparar o relatorio p/     �
//� custo unificado por empresa                                  �
//����������������������������������������������������������������
If lCusUnif
	MTR460CUnf(lCusUnif)
EndIf

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastKey <> 27
	SetDefault(aReturn,cString)
	If nLastKey <> 27
		//��������������������������������������������������������������Ŀ
		//� Verifica as perguntas selecionadas                           �
		//����������������������������������������������������������������
		//��������������������������������������������������������������Ŀ
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
		//����������������������������������������������������������������
		Pergunte(cPerg,.F.)

		//��������������������������������������������������������������Ŀ
		//� Recebe parametros das perguntas                              �
		//����������������������������������������������������������������
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

		//����������������������������������������������������������������������������Ŀ
		//� Janela de Selecao de Filiais                                               �
		//������������������������������������������������������������������������������
		aFilsCalc := MatFilCalc( mv_par21 == 1 )
		
		//����������������������������������������������������������������������������Ŀ
		//� Processando Relatorio por Filiais                                          �
		//������������������������������������������������������������������������������
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
		
		//��������������������������������������������������������������Ŀ
		//� Restaura ambiente                                            �
		//����������������������������������������������������������������
		dbSelectArea(aSave[1])
		dbSetOrder(aSave[2])
		dbGoto(aSave[3])
	EndIf
EndIf	
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R460LayOut� Autor � Juan Jose Pereira     � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Lay-Out do Modelo P7                                        ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  �aL - Array com layout do cabecalho do relatorio             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR460                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R460Imp  � Autor � Juan Jose Pereira     � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Modelo P7                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd    - variavel que indica se processo foi interrompido ���
���          � wnrel   - nome do arquivo a ser impresso                   ���
���          � cString - tabela sobre a qual o filtro do relatorio sera   ���
���          � executado                                                  ���
���          � tamanho - tamanho configurado para o relatorio             ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR460                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//����������������������������������������������������������������������������Ŀ
//� Quantidade e custo na 1a moeda para movimentos do SD3 com D3_CF RE9 ou DE9 |
//������������������������������������������������������������������������������
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

//����������������������������������������������������������������������������Ŀ
//� A460UNIT - Ponto de Entrada utilizado para regravar os campos :            |
//|            TOTAL, VALOR_UNIT e QUANTIDADE                                  |
//������������������������������������������������������������������������������
lCalcUni := If(lCalcUni == Nil, ExistBlock("A460UNIT"),lCalcUni)

//����������������������������������������������������������������������������Ŀ
//� Cria Arquivo Temporario                                                    �
//� SITUACAO: 1=ESTOQUE,2=PROCESSO,3=SEM SALDO,4=DE TERCEIROS,5=EM TERCEIROS,  �
//�           6=DE TERCEIROS USADO EM ORDENS DE PRODUCAO                       �
//������������������������������������������������������������������������������
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
IndRegua(cArqTemp,cIndTemp1,cKeyInd,,,STR0014)				//"Indice Tempor�rio..."
IndRegua(cArqTemp,cIndTemp2,"PRODUTO+SITUACAO",,,STR0014)	//"Indice Tempor�rio..."

Set Cursor Off
DbClearIndex()
DbSetIndex(cIndTemp1+OrdBagExt())
DbSetIndex(cIndTemp2+OrdBagExt())

//��������������������������������������������������������������Ŀ
//� Alimenta Arquivo de Trabalho                                 �
//����������������������������������������������������������������
#IFDEF TOP
	cAliasTop := CriaTrab(Nil,.F.)
	lQuery    := .T.                                            
	//��������������������������������������������������������������������������Ŀ
	//� Tratamento especial feito para ORACLE versao 8 ou inferior, pois nestas  |
	//| versoes, nao sao aceitas clausulas como 'LEFT JOIN', 'JOIN', etc ...     |
	//����������������������������������������������������������������������������
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

//����������������������������������������������������������������������������Ŀ
//� Processando Arquivo de Trabalho                                            |
//������������������������������������������������������������������������������
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

	//��������������������������������������������������������������Ŀ
	//� Validacao do Filtro de Usuario                               |
	//����������������������������������������������������������������
	If !Empty(aReturn[7])
		If !&(aReturn[7])
			dbSkip()
			Loop
		EndIf	
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Alimenta Array com Saldo D = De Terceiros/ T = Em Terceiros  �
	//����������������������������������������������������������������
	If lSaldTerceir
		aSaldoTerD   := SaldoTerc(If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),cAlmoxIni,"D",dDtFech,cAlmoxFim,,If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),lSaldTerceir,lCusFIFO)
		aSaldoTerT   := SaldoTerc(If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),cAlmoxIni,"T",dDtFech,cAlmoxFim,,If(lQuery,(cAliasTop)->B1_COD,SB1->B1_COD),lSaldTerceir,lCusFIFO)
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Busca Saldo em Estoque  					                 �
	//����������������������������������������������������������������
	lFirst	  := .T.
	aSalAtu	  := {}
	aSaldo    := {0,0}

	If !lQuery
		dbSelectArea("SB2")
		dbSeek(xFilial("SB2")+SB1->B1_COD+If(Empty(cAlmoxIni), "", cAlmoxIni),.T.)
	EndIf

	If If(lQuery, Empty((cAliasTop)->B2_COD) , EOF() .Or. !(SB1->B1_COD == SB2->B2_COD))

		//��������������������������������������������������������������Ŀ
		//� Lista produtos sem movimentacao de estoque                   �
		//����������������������������������������������������������������
		If lListProdMov
			//����������������������������������������������������������Ŀ
			//� TIPO 3 - SEM SALDO                                       �
			//������������������������������������������������������������
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
		//��������������������������������������������������������������Ŀ
		//� Lista produtos com movimentacao de estoque                   �
		//����������������������������������������������������������������
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

			//��������������������������������������������������������������Ŀ
			//� Desconsidera almoxarifado de saldo em processo de material   �
			//� indireto ou saldo em armazem de terceiros                    �
			//����������������������������������������������������������������
			If (cAliasTop)->B2_LOCAL==GetMv("MV_LOCPROC") .Or. (cAliasTop)->B2_LOCAL $ cLocTerc
				dbSkip()
				Loop
			EndIf

			If lListCustMed .Or. (!lListCustMed .And. !lCusfifo)
				aSalatu:=CalcEst(If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech+1,Nil)
			Else
				aSalAtu:=CalcEstFF(If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech+1,Nil)	
			EndIf

			//����������������������������������������������������������Ŀ
			//� TIPO 1 - EM ESTOQUE                                      �
			//������������������������������������������������������������
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

			//���������������������������������������������������������������������������Ŀ
			//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
			//�����������������������������������������������������������������������������			
			If lCalcUni
				ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
			EndIf
			
			MsUnLock()
			dbSelectArea(cAliasTop)
			dbSkip()
		EndDo

		//���������������������������������������������������������������������������Ŀ
		//� Pesquisa valores de materiais de terceiros requisitados para OP / TIPO 6  �
		//�����������������������������������������������������������������������������			
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
				//���������������������������������������������������������������������������Ŀ
				//� Recalcula valor unitario                                                  �
				//�����������������������������������������������������������������������������			
				If QUANTIDADE>0
					Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
				EndIf
				//���������������������������������������������������������������������������Ŀ
				//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
				//�����������������������������������������������������������������������������			
				If lCalcUni
					ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
				EndIf
				MsUnLock()				                 				
			EndIf
		EndIf

		//���������������������������������������������������������������������������Ŀ
		//� Tratamento de poder de terceiros                                          �
		//�����������������������������������������������������������������������������			
		If lSaldTerceir .And. If(lQuery,.T.,SB1->B1_FILIAL==xFilial("SB1"))
			//���������������������������������������������������������������������������Ŀ
			//� Pesquisa os valores D = De Terceiros na array aSaldoTerD                  �
			//�����������������������������������������������������������������������������			
			nX := aScan(aSaldoTerD,{|x| x[1] == xFilial("SB6")+If(lQuery,aCampos[2],SB1->B1_COD)})
			If !(nX == 0)
				aSaldo[1] := aSaldoTerD[nX][3]
				aSaldo[2] := aSaldoTerD[nX][4]
			EndIf
			//�������������������������������������������������������������������������������������Ŀ
			//� Manipula arquivo de trabalho subtraindo do saldo em estoque saldo de terceiros      �
			//���������������������������������������������������������������������������������������			
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
			//���������������������������������������������������������������������������Ŀ
			//� Pesquisa os valores de material de terceiros requisitados para OP         �
			//�����������������������������������������������������������������������������			
			If lAgregOP .And. If(lQuery,aCampos[8] == "1",SB1->B1_AGREGCU == "1")
				//���������������������������������������������������������������������������Ŀ
				//� Desconsidera do calculo do saldo em estoque movimentos RE9 e DE9          �
				//�����������������������������������������������������������������������������			
				If (QtdComp(aDadosCF9[1]) > QtdComp(0)) .Or. (QtdComp(aDadosCF9[2]) > QtdComp(0))
					Replace QUANTIDADE 	With QUANTIDADE+aDadosCF9[1]
					Replace TOTAL		With TOTAL+aDadosCF9[2]
				EndIf
			EndIf
			//���������������������������������������������������������������������������Ŀ
			//� Recalcula valor unitario                                                  �
			//�����������������������������������������������������������������������������			
			If QUANTIDADE>0
				Replace VALOR_UNIT 	With NoRound(TOTAL/QUANTIDADE,nDecVal)
			EndIf
			//���������������������������������������������������������������������������Ŀ
			//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
			//�����������������������������������������������������������������������������			
			If lCalcUni
				ExecBlock("A460UNIT",.F.,.F.,{If(lQuery,aCampos[2],SB1->B1_COD),(cAliasTop)->B2_LOCAL,dDtFech,cArqTemp})
			EndIf
			MsUnLock()
		EndIf
	EndIf

	If !lQuery
		dbSelectArea("SB1")
	EndIf

	//���������������������������������������������������������������������������Ŀ
	//� Processa Saldo De Terceiro TIPO 4 - SALDO DE TERCEIROS                    �
	//�����������������������������������������������������������������������������			
	R460Terceiros(@lEnd,cArqTemp,"4",lQuery,aCampos,aDadosCF9)

	//���������������������������������������������������������������������������Ŀ
	//� Processa Saldo Em Terceiro TIPO 5 - SALDO EM TERCEIROS                    �
	//�����������������������������������������������������������������������������			
	R460Terceiros(@lEnd,cArqTemp,"5",lQuery,aCampos,NIL)

	If lQuery
		dbSelectArea(cAliasTop)
	Else
		dbSelectArea("SB1")
		dbSkip()
	EndIf
	
EndDo

//���������������������������������������������������������������������������Ŀ
//� Processa Saldo Em Processo TIPO 2 - SALDO EM PROCESSO                     �
//�����������������������������������������������������������������������������			
If lSaldProcess
	XR460EmProcesso(@lEnd,cArqTemp,Nil,cProdIni,cProdFim,cAlmoxIni,cAlmoxFim,mv_par20==1,dDtFech,lCalcProcDt,nQuebraAliq,lListCustMed)
EndIf

//���������������������������������������������������������������������������Ŀ
//� CUSTO UNIFICADO - Realiza acerto dos valores para todos tipos             �
//�����������������������������������������������������������������������������
If lCusUnif
	dbSelectArea(cArqTemp)
	dbSetOrder(2)
	dbGotop()
	SetRegua(LastRec())
	//��������������������������������������������������������������Ŀ
	//� Percorre arquivo de Trabalho                                 �
	//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Imprime Modelo P7                                            �
//����������������������������������������������������������������
dbSelectArea(cArqTemp)
dbSetOrder(1)
dbGotop()
SetRegua(LastRec())

//��������������������������������������������������������������Ŀ
//� Flags de Impressao                                           �
//����������������������������������������������������������������
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

				//��������������������������������������������������������������Ŀ
				//� Controla impressao de Produtos com saldo negativo ou zerado  �
				//����������������������������������������������������������������
				If (!lListProdNeg .And. QUANTIDADE<0) .Or. (!lListProdZer .And. QUANTIDADE==0) .Or. (!lListCustZer .And. TOTAL==0)
					dbSkip()
					Loop
				Else
					nTotIpi+=TOTAL
					R460Acumula(aTotal)
				EndIf
				//�����������������������������������������������������������������Ŀ
				//� Inicializa array com itens de impressao de acordo com MV_PAR15  �
				//�������������������������������������������������������������������

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

				//�����������������������������������������������������������������Ŀ
				//� Salta registros Zerados ou Negativos Conforme Parametros        �
				//� Necessario Ajustar Posicao p/ Totalizacao de Grupos (POSIPI)    �
				//�������������������������������������������������������������������
				While !Eof() .And. ((!lListProdNeg.And.QUANTIDADE<0).Or.(!lListProdZer.And.QUANTIDADE==0).Or.(!lListCustZer.And.TOTAL==0))
					dbSkip()
				EndDo
				//��������������������������������������������������������������Ŀ
				//� Verifica se imprime total por POSIPI.                        �
				//����������������������������������������������������������������
				If !(cSitAnt+cTipoAnt+cPosIpi==SITUACAO+TIPO+POSIPI) .And. nQuebraAliq == 1
					aImp[07] := Transform(nTotIPI,"@E 999,999,999,999.99")
				EndIf
				//��������������������������������������������������������������Ŀ
				//� Imprime cabecalho                                            �
				//����������������������������������������������������������������
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
				//��������������������������������������������������������������Ŀ
				//� Imprime linhas de detalhe de acordo com parametro (mv_par15) �
				//����������������������������������������������������������������
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
		//��������������������������������������������������������������Ŀ
		//� Impressao de Totais                                          �
		//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Apaga Arquivos Temporarios                                   �
//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R460Term � Autor � Juan Jose Pereira     � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao dos Termos de Abertura e Encerramento do Modelo P7���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd    - variavel que indica se processo foi interrompido ���
���          � wnrel   - nome do arquivo a ser impresso                   ���
���          � cString - tabela sobre a qual o filtro do relatorio sera   ���
���          � executado                                                  ���
���          � tamanho - tamanho configurado para o relatorio             ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR460                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R460Terceiros  �Autor�Juan Jose Pereira   � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Busca Saldo em poder de Terceiros (T) ou de Terceiros (D)   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd    - variavel que indica se processo foi interrompido ���
���          � cArqTemp- nome do arquivo de trabalho criado para impressao���
���          � do relatorio                                               ���
���          � cEmdeTerc-String indicando se esta processando saldo de    ���
���          � terceiros ou saldo em terceiros                            ���
���          � executado                                                  ���
���          � lQuery - Indica se esta processando com query ou nao       ���
���          � aCampos- Array com os dados do cursor posicionado quando   ���
���          � utiliza query                                              ���
���          � aDadosCF9- Array com informacaoes relacionadas a movimentos���
���          � internos RE9/DE9                                           ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR460                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	//���������������������������������������������������������������������������Ŀ
	//� Pesquisa os valores D == De Terceiros / T == Em Terceiros                 �
	//�����������������������������������������������������������������������������			
	nX := aScan(If(cEmDeTerc=="4",aSaldoTerD,aSaldoTerT),{|x| x[1] == xFilial("SB6")+If(lQuery,aCampos[2],SB1->B1_COD)})
	If !(nX == 0)
		aSaldo[1] := If(cEmDeTerc=="4",aSaldoTerD[nX][3],aSaldoTerT[nX][3])
		aSaldo[2] := If(cEmDeTerc=="4",aSaldoTerD[nX][4],aSaldoTerT[nX][4])
	EndIf
	//���������������������������������������������������������������������������Ŀ
	//� Considera o saldo do armazem do parametro como saldo em terceiros         �
	//�����������������������������������������������������������������������������
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
		//��������������������������������������������������������������������������������Ŀ
		//� Desconsidera do calculo do saldo do material de terceiros movimentos RE9 e DE9 �
		//����������������������������������������������������������������������������������			
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R460EmProcesso �Autor�Juan Jose Pereira   � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Busca saldo em Processo                                     ���
���          �Atualiza aqruivo de trab. c/ Saldo em Processo dos Produtos.���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd         - Var. que indica se proc. foi interrompido   ���
���          � cArqTemp     - Nome do arquivo de trabalho                 ���
���          � lGraph       - Nao atualiza regua de progressao            ���
���          � cProdIni     - Produto Inicial                             ���
���          � cProdFim     - Produto Final                               ���
���          � cAlmoxIni    - Armazem Inicial                             ���
���          � cAlmoxFim    - Armazem Final                               ���
���          � lModProces   - Considera Mao de Obra em Processo           ���
���          � dDtFech      - Data de Fechamento cons. p/ o calculo       ���
���          � lCalcProcDt  - Cons. => Dt. Emissao(.T.) / Sec. Calc.(.F.) ���
���          � nQuebraAliq  - Opcao de Quebra por Aliquota                ���
���          � (1)Nao Quebra / (2) Icms produto (3) Icms reducao          ���
���          � lListCustMed - Lista Custo Medio                           ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� SALDO EM PROCESSO                                            �
//����������������������������������������������������������������
If !lEnd
	//��������������������������������������������������������������Ŀ
	//� Cria arquivo de Trabalho para armazenar as OPs               �
	//����������������������������������������������������������������
	AADD(aCampos,{"OP"		,"C",TamSX3("D3_OP")[1]			,0}) // 01 - OP
	AADD(aCampos,{"SEQCALC"	,"C",TamSX3("D3_SEQCALC")[1]	,0}) // 02 - SEQCALC
	AADD(aCampos,{"DATA1"	,"D",8							,0}) // 03 - DATA1
	cArqTemp2:=CriaTrab(aCampos)

	dbUseArea(.T.,,cArqTemp2,cArqTemp2,.T.,.F.)
	IndRegua(cArqTemp2,cArqTemp2,"OP+SEQCALC+DTOS(DATA1)",,,STR0020)	//"Criando Indice..."

	//��������������������������������������������������������������Ŀ
	//� Busca saldo em processo                                      �
	//����������������������������������������������������������������
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

	//��������������������������������������������������������������Ŀ
	//� Armazena OPs e data de emissao no Arquivo de Trabalho        �
	//����������������������������������������������������������������
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

	//��������������������������������������������������������������Ŀ
	//� Restaura ambiente e apaga arquivo temporario                 �
	//����������������������������������������������������������������
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

	//��������������������������������������������������������������Ŀ
	//� Gravacao do Saldo em Processo                                �
	//����������������������������������������������������������������
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

				//����������������������������������������������������������������������Ŀ
				//� Validacao para nao permitir movimento com a data maior que a data de �
				//| encerramento do relatorio.                                           |  
				//������������������������������������������������������������������������			
				If (cAliasSD3)->D3_EMISSAO > dDtFech .Or. (cAliasSD3)->D3_ESTORNO == "S"
					dbSkip()
					Loop
				EndIf
				
				//����������������������������������������������������������������������Ŀ
				//� Realiza a somatoria de todas as producoes para esta OP               �
				//������������������������������������������������������������������������			
				If SubStr((cAliasSD3)->D3_CF,1,2) == "PR"
					nPos:=Ascan(aProducao,{|x|x[1]==(cAliasSD3)->D3_COD})
					If nPos==0
						AADD(aProducao,{(cAliasSD3)->D3_COD,(cAliasSD3)->D3_QUANT,(cAliasSD3)->D3_CUSTO1})
					Else
						aProducao[nPos,2] += (cAliasSD3)->D3_QUANT
						aProducao[nPos,3] += (cAliasSD3)->D3_CUSTO1
					EndIf
				EndIf

				//����������������������������������������������������������������������Ŀ
				//� Validacao para o Produto                                             �
				//������������������������������������������������������������������������			
				If (cAliasSD3)->D3_COD < cProdIni .Or. (cAliasSD3)->D3_COD > cProdFim .Or.;
					If(lModProces,.T.,IsProdMod((cAliasSD3)->D3_COD))
					dbSkip()
					Loop
				EndIf

				//����������������������������������������������������������������������Ŀ
				//� Validacao para o local                                               �
				//������������������������������������������������������������������������			
				If (cAliasSD3)->D3_LOCAL < cAlmoxIni .Or. (cAliasSD3)->D3_LOCAL > cAlmoxFim
					dbSkip()
					Loop
				EndIf
				
				//����������������������������������������������������������������������Ŀ
				//� Filtra produtos que nao estao em Processo                            �
				//������������������������������������������������������������������������
				If (lCalcProcDt .And. (cAliasSD3)->D3_EMISSAO <= (cArqTemp2)->DATA1) .Or. (!lCalcProcDt .And. (cAliasSD3)->D3_SEQCALC <= (cArqTemp2)->SEQCALC)
				
					//�����������������������������������������������������������������������Ŀ
					//� Realiza a somatoria de todas as requisicoes que serao analisada para  |
					//| verificar se deverao entrar como saldo em processo ou nao.            �
					//�������������������������������������������������������������������������			
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
				
					//�����������������������������������������������������������������������Ŀ
					//� GRAVA SALDO EM PROCESSO                                               �
					//�������������������������������������������������������������������������			
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
						//���������������������������������������������������������������������������Ŀ
						//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
						//�����������������������������������������������������������������������������			
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

			//���������������������������������������������������������������������������Ŀ
			//� ANALISE DE SALDO EM PROCESSO EM ABERTO                                    �
			//�����������������������������������������������������������������������������			
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
							
							//�����������������������������������������������������������������������Ŀ
							//� GRAVA SALDO EM PROCESSO                                               �
							//�������������������������������������������������������������������������
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
									//���������������������������������������������������������������������������Ŀ
									//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
									//�����������������������������������������������������������������������������			
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
	//��������������������������������������������������������������Ŀ
	//� Apaga arquivos temporarios                                   �
	//����������������������������������������������������������������
	dbSelectArea(cArqTemp2)
	dbCloseArea()
	Ferase(cArqTemp2+GetDBExtension())
	Ferase(cArqTemp2+OrdBagExt())
	//��������������������������������������������������������������Ŀ
	//� Busca saldo em processo dos materiais de uso indireto        �
	//����������������������������������������������������������������
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
		//���������������������������������������������������������������������������Ŀ
		//� Este Ponto de Entrada foi criado para recalcular o Valor Unitario / Total �
		//�����������������������������������������������������������������������������			
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R460Cabec()    �Autor�Juan Jose Pereira   � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cabecalho do Modelo P7                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nLin - Numero da linha corrente                            ���
���          � nPagina - Numero da pagina corrente                        ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R460EmBranco() �Autor�Juan Jose Pereira   � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Preenche o resto da pagina em branco                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nLin - Numero da linha corrente                            ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R460AvalProd() �Autor�Juan Jose Pereira   � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Avalia se produto deve ser listado                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cProduto - Codigo do produto avaliado                      ���
���          � lConsMod - Flag que indica se devem ser considerados       ���
���          � produtos MOD                                               ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � LOGICO indicando se o produto deve ser listado             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R460AvalProd(cProduto,lConsMod)
Default lConsMod := .F.
Return(cProduto>=cProdIni.And.cProduto<=cProdFim) .And. IIf(lConsMod,.T.,!IsProdMod(cProduto))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R460Local()    �Autor�Juan Jose Pereira   � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Avalia se Local deve ser listado                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cLocal - Codigo do armazem avaliado                        ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � LOGICO indicando se o armazem deve ser listado             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R460Local(cLocal)
Return (cLocal>=cAlmoxIni.And.cLocal<=cAlmoxFim)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R460Acumula()  �Autor�Juan Jose Pereira   � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Acumulador de totais                                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� aTotal - Array com totalizadores do relatorio              ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R460Total()    �Autor�Juan Jose Pereira   � Data � 07.11.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime totais                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nLin  - Numero da linha corrente                           ���
���          � aTotal- Array com totalizadores do relatorio               ���
���          � cSituacao- Indica se deve imprimir total geral ou do grupo ���
���          � cTipo - Tipo que esta sendo totalizado                     ���
���          � aSituacao - Array com descricao da situacao totalizada     ���
���          � nPagina - Numero da pagina corrente                        ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � LOGICO indicando se o armazem deve ser listado             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	//��������������������������������������������������������������Ŀ
	//� Imprime totais dos grupos                                    �
	//����������������������������������������������������������������
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
	//��������������������������������������������������������������Ŀ
	//� Imprime resumo final                                         �
	//����������������������������������������������������������������
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
		//��������������������������������������������������������������Ŀ
		//� Nao imprime produtos sem movimentacao                        �
		//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R460SemEst()   �Autor�Rodrigo A Sartorio  � Data � 31.10.02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime informacao sem estoque                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nLin - Numero da linha corrente                            ���
���          � nPagina - Numero da pagina corrente                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Nereu Humberto Jr     � Data �21.03.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria as perguntas necesarias para o programa                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

PutSx1( "MTR460","19","Quanto a quebra por aliquota ?","�Ref. a quiebra por alicuota ?","Skip per tax rate?","mv_chj",;
	"N",1,0,1,"C","","","","","mv_par19","Nao quebrar","No quebrar","Not skip","",;
	"Icms produto","Icms producto","Prod.ICMS","Icms reducao","Icms reduccion","Red.ICMS","","","","","","",;
	aHelpPor,aHelpEng,aHelpSpa)

//------------------------------- mv_par20 -----------------------------------
aHelpPor :={"Pergunta utilizada para verificar se","devera imprimir as requisicoes para","MOD com saldo em processo.","Somente utilizada em conjunto com ","a pergunta 'Saldo em Processo'"}
aHelpEng :={}
aHelpSpa :={}
PutSx1( "MTR460", "20","Lista MOD Processo?","�Lista MOD Processo?","Lista MOD Processo?","mv_chk","N",1,0,2,"C","","","","","mv_par20","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

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
    	'�Selecciona sucursales?',; //-- 04 - X1_PERSPA
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ImpListSX1� Autor � Nereu Humberto Junior � Data � 01.08.05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de impressao da lista de parametros do SX1 sem cabec���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpListSX1(titulo,nomeprog,tamanho,char,lFirstPage)        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cTitulo - Titulo                                           ���
���          � cNomPrg - Nome do programa                                 ���
���          � nTamanho- Tamanho                                          ���
���          � nchar   - Codigo de caracter                               ���
���          � lFirstpage - Flag que indica se esta na primeira pagina    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

__ChkBmpRlt( cFileLogo ) // Seta o bitmap, mesmo que seja o padr�o da microsiga

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTR460CUnf � Autor �Nereu Humberto Junior  � Data �29/08/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ajusta grupo de perguntas p/ Custo Unificado                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR460                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SaldoD3CF9 � Autor �Rodrigo de A Sartorio  � Data �30/12/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retorna saldo dos movimentos RE9/DE9 relacionados ao produto���
�������������������������������������������������������������������������Ĵ��
���Parametros�cProduto - Codigo do produto a ter os movimentos pesquisados���
���          �dDataIni - Data inicial para pesquisa dos movimentos        ���
���          �dDataFim - Data final para pesquisa dos movimentos          ���
���          �cAlmoxIni- Armazem inicial para pesquisa dos movimentos     ���
���          �cAlmoxFim- Armazem final para pesquisa dos movimentos       ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  �aDadosCF9- Array com quantidade e valor requisitado atraves ���
���          �de movimentos RE9 / DE9                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR460                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
//��������������������������������������������������������������Ŀ
//� Restaura ambiente e apaga arquivo temporario                 �
//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GetOracleVe� Autor �Guilherme C.L.Oliveira � Data �25/05/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Obtem a Versao do ORACLE                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  �Versao do Oracle                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR460                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o  	 �FmtLinR4()� Autor � Nereu Humberto Junior � Data � 31.07.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Formata linha para impressao                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FmtLinR4(oReport,aValores,cFundo,cPictN,cPictC,nLin,lImprime,bCabec,nTamLin)
//��������������������������������������������������������������Ŀ
//� Variaveis da funcao                                          �
//����������������������������������������������������������������
Local cConteudo:=''
Local cLetra   :=''
Local nPos     :=0
Local i        :=0
Local j        :=0
//��������������������������������������������������������������Ŀ
//� Sets para a Funcao, mudar se necessario                      �
//����������������������������������������������������������������
Local cPictNPad :='@E 999,999,999.99'
Local cPictCPad :='@!'
Local cCharOld  :='#'
Local cCharBusca:='�'
Local cTipoFundo:=ValType(cFundo)
Local nFor      :=1
Local cAlias    := Alias()
//��������������������������������������������������������������Ŀ
//� Troca # por cCharBusca pois existem dados com # que devem    �
//� ser impressos corretamente.                                  �
//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Substitue o caracter cCharBusca por "_" nas strings          �
//����������������������������������������������������������������
For nFor:=1 To Len(aValores)
	If ValType(aValores[nFor])=="C"
		If At(cCharBusca,aValores[nFor]) > 0
			aValores[nFor]:=StrTran(aValores[nFor],cCharBusca,"_")
		EndIf
	EndIf
Next
//��������������������������������������������������������������Ŀ
//� Efetua quebra de pagina com impressao de cabecalho           �
//����������������������������������������������������������������
If bCabec!=NIL .And. nLin>55
	nTamLin:=Iif(nTamLin==NIL,220,nTamLin)
	nLin++
	oReport:PrintText("+"+Replic("-",nTamLin-2)+"+")
	Eval(bCabec)
EndIf
//��������������������������������������������������������������Ŀ
//� Rotina de substituicao                                       �
//����������������������������������������������������������������
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
//��������������������������������������������������������������Ŀ
//� Imprime linha formatada                         �
//����������������������������������������������������������������
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
//��������������������������������������������������������������Ŀ
//� Devolve array de dados com mesmo tamanho mas vazio           �
//����������������������������������������������������������������
If Len(aValores)>0
	aValores:=Array(Len(aValores))
EndIf
DbSelectArea(cAlias)
Return cFundo

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTR460VAlm � Autor �Nereu Humberto Junior  � Data �01/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida Almoxarifado do KARDEX com relacao a custo unificado ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR460                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MTR460VAlm()
Local lRet:=.T.
Local cConteudo:=&(ReadVar())
Local nOpc:=2
//��������������������������������������������������������������Ŀ
//� Verifica se utiliza custo unificado por Empresa/Filial       �
//����������������������������������������������������������������
Local lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))

If lCusUnif .And. cConteudo != "**"
	nOpc := Aviso(STR0035,STR0036,{STR0037,STR0038})	//"Aten��o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
	If nOpc == 2
		lRet:=.F.
	EndIf
EndIf
Return lRet

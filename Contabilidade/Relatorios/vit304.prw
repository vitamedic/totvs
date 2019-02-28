#Include "VIT304.Ch"
/*#Include "PROTHEUS.Ch"*/
#include "topconn.ch"
#include "rwmake.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT304  ³ Autor ³ Simone Mie Sato        ³ Data ³ 07.04.04 ³±±
±±³Atualizado³ VIT304   ³ Autor ³ Reuber Abdias de M. Jr³ Data ³ 19.02.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao do Relat. Lancamentos por Centro de Custo          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ vit304()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


user Function VIT304()                                   
Local aCtbMoeda		:= {}
Local aSetOfBook	:= {}
Local WnRel			:= "VIT304"+Alltrim(cusername)
Local cSayCusto		:= CtbSayApro("CTT")
Local cDesc1		:= STR0001+Alltrim(cSayCusto) 	//"Este programa ira imprimir o Relatorio de Lancamentos por "
Local cDesc2		:= STR0002	//" de acordo com os parametros sugeridos "
Local cDesc3		:= STR0003	//"pelo usuario"
Local cString		:= "CT2"
Local titulo		:= STR0006 + Alltrim(cSayCusto)	//"Emissao do Relatorio de Lançamentos por "
Local lRet			:= .T.
Local nTamLinha		:= 220

Private aReturn		:= { STR0004, 1,STR0005, 2, 2, 1, "", 1 }  //"Zebrado"###"Administracao"
//areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
Private nomeprog	:= "VIT304"
Private aLinha		:= {}
Private nLastKey	:= 0
Private cPerg		:= "PERGVIT304"
Private Tamanho		:= "G"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

VIT304SX1()

If ! Pergunte("PERGVIT304", .T. )
	Return
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // da data                               ³
//³ mv_par02            // Ate a data                            ³
//³ mv_par03            // da Gerencia                           ³
//³ mv_par04            // Ate a Gerência                        ³
//³ mv_par05            // Da Conta                              ³
//³ mv_par06            // Ate a Conta                           ³
//³ mv_par07            // Moeda			                     ³   
//³ mv_par08            // Saldos		                         ³   
//³ mv_par09            // Configuracao de Livros                ³
//³ mv_par10            // Imprime Cod. CCusto(Normal/Reduzido)  ³
//³ mv_par11            // Imprime Cod Cta(Normal / Reduzida)    ³
//³ mv_par12            // Totaliza tb por Conta?                ³
//³ mv_par13            // Salta folha por c.c.?                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books -> Conf. da Mascara / Valores   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Ct040Valid(mv_par09)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par09)
EndIf

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par07)
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

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| VIT304Imp(@lEnd,wnRel,cString,aSetOfBook,Titulo,nTamlinha,aCtbMoeda,cSayCusto)})
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³VIT304Imp ³ Autor ³ Simone Mie Sato       ³ Data ³ 07/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao do Relatorio de Lancam. por Centro de Custo      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³VIT304Imp(lEnd,WnRel,cString,aSetOfBook,Titulo,nTamlinha,   ³±±
±±³			  ³	aCtbMoeda,cSayCusto)									   ³±±
±±³           ³          												   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd       - A‡ao do Codeblock                             ³±±
±±³           ³ wnRel      - Nome do Relatorio                             ³±±
±±³           ³ cString    - Mensagem                                      ³±±
±±³           ³ aSetOfBook - Array de configuracao set of book             ³±±
±±³           ³ Titulo     - Titulo do Relatorio                           ³±±
±±³           ³ nTamLinha  - Tamanho da linha a ser impressa               ³±±
±±³           ³ aCtbMoeda  - Array ref. a moeda solicitada                 ³±±
±±³           ³ cSayCusto  - Nomenclatura utilizada para o Centro de Custo ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static Function VIT304Imp(lEnd,WnRel,cString,aSetOfBook,Titulo,nTamlinha,	aCtbMoeda,cSayCusto)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt
Local cbcont
Local cArqTmp		:= ""
Local Cabec1		:= ""
Local Cabec2		:= ""
Local cMascara1		:= ""
Local cMascara2		:= ""
Local cSepara1		:= ""
Local cSepara2		:= ""
Local cPicture		:= ""
Local cDescMoeda	:= ""
Local cResCC		:= ""      
Local cCustoAnt		:= ""
Local cCodRes		:= ""
Local cNormal		:= ""
Local cGerenIni		:= mv_par03
Local cGerenFim		:= mv_par04
Local cContaIni		:= mv_par05
Local cContaFIm		:= mv_par06
Local cMoeda		:= mv_par07
Local cSaldo		:= mv_par08

Local nDecimais		:= 0 
Local nTotCta		:= 0
Local nTotCC		:= 0 
Local nSaldoCC		:= 0 
Local nSldCCCta	:= 0 
Local nSaldoGer	:= 0 
Local nTotalGeral	:= 0
Local nSaldoTotal	:= 0 

Local dDataIni		:= mv_par01
Local dDataFim		:= mv_par02

Local lSalto		:= Iif(mv_par13==1,.T.,.F.)
Local lImpCCRes		:= Iif(mv_par10==2,.T.,.F.)
Local lImpCtaRes	:= Iif(mv_par11==2,.T.,.F.)
Local lFirstCta		:= .T.

Local aSaldoCC		:= {}
Local aSldCCCta		:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt				:= SPACE(10)
cbcont				:= 0
li       			:= 80
m_pag    			:= 1

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,cMoeda)

// Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := GetMv("MV_MASCARA")
Else
	cMascara1	:= RetMasCtb(aSetOfBook[2],@cSepara1)
EndIf
 
// Mascara do Centro de Custo
If Empty(aSetOfBook[6])
	cMascara2 := GetMv("MV_MASCCUS")
Else
	cMascara2	:= RetMasCtb(aSetOfBook[6],@cSepara2)
EndIf                                                

cPicture 	:= aSetOfBook[4]


// PESQUISA CODIGO DO GERENTE CONECTADO. SE BRANCO INFORMA TODOS OS CC
_cfilszt:=xfilial("SZT")
szt->(dbsetorder(3))

if szt->(dbseek(_cfilszt+__cuserid))                                       
	cGerenIni :=szt->zt_codigo // parâmetro MV_PAR03
	cGerenFim :=szt->zt_codigo // parâmetro MV_PAR04
endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Relatorio                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo	:=	STR0007	+ Upper(Alltrim(cSayCusto))//"RAZAO POR "
Titulo  += 	Space(01)+cDescMoeda + space(01)+STR0009 + space(01)+DTOC(dDataIni) +;	// "DE"
			space(01)+STR0010 + space(01)+ DTOC(dDataFim)							// "ATE"
	
If mv_par06 > "1"
	Titulo += " (" + Tabela("SL", mv_par06, .F.) + ")"
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabe‡alho                                   							     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// C.CUSTO 					- DESCRICAO DO CENTRO DE CUSTO
// CONTA                	  D E S C R I C A O                      		C/PARTIDA				TIPO	NUMERO				DATA		HISTORICO	 				            VALOR DO LANCAMENTO         	SALDO ATUAL"
// XXXXXXXXXXXXXXXXXXXX       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     
// XXXXXXXXXXXXXXXXXXXX 	  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 	XXXXXXXXXXXXXXXXXXXX	  X  	XXXXXXXXXXXXXXXXX  	99/99/99 	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	999,999,999,999.99 	   99,999,999,999,999.99 
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16         17        18        19        20       21        22

#DEFINE 	COL_CONTA  				1
#DEFINE 	COL_DESC				2
#DEFINE 	COL_CONTRA_PARTIDA		3
#DEFINE 	COL_TIPO				4
#DEFINE 	COL_NUMERO			  	5 
#DEFINE 	COL_DATA      			6
#DEFINE 	COL_HISTORICO			7
#DEFINE 	COL_VALORLANC	  		8
#DEFINE 	COL_VLRSALDO 			9
#DEFINE 	TAMANHO_TM       		10           

aColunas := { 000, 027, 073, 099, 105, 125, 137, 177,200,017}

Cabec1 := Iif (cPaisLoc<>"MEX" ,STR0013,STR0027)					// "CONTA                	  D E S C R I C A O                      		C/PARTIDA				TIPO	NUMERO				DATA		HISTORICO	 				            VALOR DO LANCAMENTO         	 SALDO ATUAL"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
			CTBGerLanc(oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cGerenIni,cGerenFim,;
			cMoeda,dDataIni,dDataFim,aSetOfBook,cSaldo)},;
			STR0018,;		// "Criando Arquivo Temporario..."
			STR0006 + Alltrim(cSayCusto))						// "Emissao do Razao"

dbSelectArea("cArqTmp")
dbSetOrder(1)
SetRegua(RecCount())
dbGoTop()

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])                                       
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())	
	Return
Endif

While !Eof()

	IF lEnd
		@Prow()+1,0 PSAY STR0015  //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()



	// Calcula o saldo anterior do centro de custo atual
	aSaldoCC	:= SaldTotCT3(cArqTmp->CCUSTO,cArqTmp->CCUSTO,cContaIni,cContaFim,dDataIni,cMoeda,cSaldo)

	If li > 56 .Or. lSalto              
		CtCGCCabec(.F.,.T.,.F.,Cabec1,Cabec2,dDataFim,Titulo,.T.,"1",Tamanho)
	EndIf

//	@li, 00 PSAY Replicate("=",nTamLinha)
/*	li++
	@li,011 PSAY Upper(Alltrim(cSayCusto)) + " - "  		//"CENTRO DE CUSTO - "
*/	
	dbSelectArea("CTT")
	dbSetOrder(1)
	MsSeek(xFilial()+cArqTMP->CCUSTO)  
	cResCC := CTT->CTT_RES
	
/*	If lImpCCRes // Imprime Codigo Reduzido de Centro de Custo
		EntidadeCTB(cResCC,li,pcol()+2,20,.F.,cMascara2,cSepara2)
	Else                                                                     
		EntidadeCTB(STRZERO(cArqTmp->CCUSTO,3)+" - "+cArqTmp->CCUSTO,li,pcol()+2,20,.F.,cMascara2,cSepara2)	
	Endif
*/	
/*	@ li, pCol()+2 PSAY "- " + CtbDescMoeda("CTT->CTT_DESC"+cMoeda)*/

	//Saldo anterior do centro de custo => todas as contas do intervalo Conta De / Conta Ate
 /*	ValorCTB(aSaldoCC[6],li,aColunas[COL_VLRSALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture)*/

/*i++
		
	@li, 00 PSAY Replicate("=",nTamLinha)

	nSaldoCC := aSaldoCC[6]                                           	
	*/
	li ++
	
	@li, 00 PSAY Replicate("=",nTamLinha)
	
	dbSelectArea("cArqTmp")		
	
	cGerencAnt:=cArqTmp->GERENC
	nTotGer   :=0       
	nSaldoCC  :=0
	cNomeGeren:=""
	_gerente:=""
	
	li ++
	//buscando o nome da gerência
	dbselectarea("SZT")
	dbSetOrder(1)
	if dbSeek(xFilial()+cGerencAnt) 
	   cNomeGeren:= szt->zt_desc
	endif

	// Valida se gerência tem permissão de visualizar a Gerência
	@ li, 00 Psay "GERENCIA: "+cArqTmp->GERENC+"->"+cNomeGeren
	li++
	While cArqTmp->(!Eof()) .And. cArqTmp->GERENC == cGerencAnt
		dbSelectArea("CTT")
		dbSetOrder(1)
		MsSeek(xFilial()+cArqTMP->CCUSTO)  
		li++
		@li, 00 PSAY Replicate("=",nTamLinha)
		li++
		@ li, 00 Psay cArqTmp->CCUSTO+"->"+CTT->CTT_DESC01
		li++
	   
   		dbSelectArea("cArqTmp")		
   		cGerencAnt:=cArqTmp->GERENC
		cCustoAnt := cArqTmp->CCUSTO

		While cArqTmp->(!Eof()) .And. cArqTmp->CCUSTO == cCustoAnt
		
			cContaAnt	:= cArqTmp->CONTA
			dDataAnt	:= cArqTmp->DATAL		
			
	        lFirstCta	:= .T.
	        
			While cArqTmp->(!Eof()) .And. cArqTmp->CCUSTO == cCustoAnt .And. cArqTmp->CONTA == cContaAnt
			
				If li > 56  
					CtCGCCabec(.F.,.T.,.F.,Cabec1,Cabec2,dDataFim,Titulo,.T.,"1",Tamanho)
					li++
				EndIf        
				
				//Se for a primeira conta e totaliza por conta, imprime o saldo anterior do centro 
				//de custo x conta. 
				If mv_par12 == 1 .And. lFirstCta
				   /*
					@li, 00 PSAY Replicate("-",nTamLinha)
					li++			
					*/
					aSldCCCta	:= SaldoCT3(cArqTmp->CONTA,cArqTmp->CCUSTO,dDataIni,cMoeda,cSaldo,,.F.)				
					/*
					@li,aColunas[COL_CONTA] PSAY STR0021  //"S a l d o  a n t e r i o r  d a  C o n t a  => " 				
					ValorCTB(aSldCCCta[6],li,aColunas[COL_VLRSALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture)						
					li++
					@li, 00 PSAY Replicate("-",nTamLinha)				
					lFirstCta	:= .F.						
					li++	                                              				
					
					nSldCCCta	:= aSldCCCta[6]*/
					
	            EndIf       
	
				dbSelectArea("CT1")
				dbSetOrder(1)
				MsSeek(xFilial()+cArqTmp->CONTA)
				vdescconta:=CT1->CT1_DESC01
				
				if mv_par14 = 2 // analitico
				
					If lImpCtaRes
						cCodRes := CT1->CT1_RES			
						EntidadeCTB(cCodRes,li,aColunas[COL_CONTA],20,.F.,cMascara1,cSepara1)											
					Else
						EntidadeCTB(cArqTmp->CONTA,li,aColunas[COL_CONTA],20,.F.,cMascara1,cSepara1)							
					Endif                                       
					
					@li,aColunas[COL_DESC] PSAY CtbDescMoeda("CT1->CT1_DESC"+cMoeda)	
		
					If lImpCtaRes
						dbSelectArea("CT1")
						dbSetOrder(1)
						MsSeek(xFilial()+cArqTmp->XPARTIDA)
						cCodRes := CT1->CT1_RES
						EntidadeCTB(cCodRes,li,aColunas[COL_CONTRA_PARTIDA],20,.F.,;
									cMascara1,cSepara1)				                                     
		    		Else
						EntidadeCTB(cArqTmp->XPARTIDA,li,aColunas[COL_CONTRA_PARTIDA],;
									20,.F.,cMascara1,cSepara1)
					EndIf                              
	         
		
					@li,aColunas[COL_TIPO] PSAY cArqTmp->TIPO		
					@li,aColunas[COL_NUMERO] PSAY cArqTmp->LOTE+cArqTmp->SUBLOTE+cArqTmp->DOC+cArqTmp->LINHA			
					@li,aColunas[COL_DATA] PSAY cArqTmp->DATAL						
					@li,aColunas[COL_HISTORICO] PSAY cArqTmp->HISTORICO                        		
					ValorCTB(cArqTmp->VALORLANC,li,aColunas[COL_VALORLANC],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture)
				endif	
				If cArqTmp->TIPO == "1"
		            nSaldoCC 	-= cArqTmp->VALORLANC
		            nSldCCCta	-= cArqTmp->VALORLANC 
		            nSaldoGer	-= cArqTmp->VALORLANC
		            nSaldoTotal	-= cArqTmp->VALORLANC
		  		Else
		            nSaldoCC	   += cArqTmp->VALORLANC
		            nSldCCCta	+= cArqTmp->VALORLANC 	            
		            nSaldoGer	+= cArqTmp->VALORLANC
		            nSaldoTotal	+= cArqTmp->VALORLANC
		        EndIf
	                            
				//Se totaliza tambem por conta, imprime o saldo CC x Cta.
				if mv_par14 = 2 // analitico
					If mv_par12	== 1			
						ValorCTB(nSldCCCta,li,aColunas[COL_VLRSALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture)			
					Else			                    
						ValorCTB(nSaldoCC,li,aColunas[COL_VLRSALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture)			
					EndIf    
				endif	
								
				// Procura pelo complemento de historico
				dbSelectArea("CT2")
				dbSetOrder(10)
				If MsSeek(xFilial()+DTOS(cArqTMP->DATAL)+cArqTmp->LOTE+cArqTmp->SUBLOTE+cArqTmp->DOC+cArqTmp->SEQLAN)			
					dbSkip()
					If CT2->CT2_DC == "4"
						While !Eof() .And. CT2->CT2_FILIAL == xFilial() .And.;
							CT2->CT2_LOTE == cArqTMP->LOTE .And. CT2->CT2_DOC == cArqTmp->DOC .And.;
							CT2->CT2_SEQLAN == cArqTmp->SEQLAN .And. CT2->CT2_DC == "4" .And.;
							DTOS(CT2->CT2_DATA) == DTOS(cArqTmp->DATAL)                        
							if mv_par14 = 2 // analitico
								li++
								@li,aColunas[COL_NUMERO] 	 PSAY CT2->CT2_LOTE+ CT2->CT2_SBLOTE+ CT2->CT2_DOC+CT2->CT2_LINHA
  								@li,aColunas[COL_HISTORICO] PSAY CT2->CT2_HIST
  							endif	
							dbSkip()
						EndDo	
					EndIf	
				EndIf	
				if mv_par14 = 2 // analitico
					li ++
				endif
														
				dbSelectArea("cArqTmp")			
	
				If li > 56
					CtCGCCabec(.F.,.T.,.F.,Cabec1,Cabec2,dDataFim,Titulo,.T.,"1",Tamanho)
					li++
				EndIf   
				        
				If cArqTmp->TIPO == "1"
					nTotCta		-=	cArqTmp->VALORLANC
					nTotCC		-=	cArqTmp->VALORLANC
					nTotGer		-=	cArqTmp->VALORLANC
					nTotalGeral -=	cArqTmp->VALORLANC 
				Else
					nTotCta		+=  cArqTmp->VALORLANC			
					nTotCC		+=	cArqTmp->VALORLANC	   
					nTotGer		+=	cArqTmp->VALORLANC
					nTotalGeral +=	cArqTmp->VALORLANC 							
				EndIf
				
				dbSelectArea("cArqTmp")
				dDataAnt := cArqTmp->DATAL		
				dbSkip()
			EndDo      	
	   
			if mv_par14 = 2 // analitico
				If mv_par12 == 1	// Totaliza tb por Conta
					@li, 00 PSAY Replicate("-",nTamLinha)
					li++			
					@li,aColunas[COL_CONTA] PSAY STR0020  //"T o t a l  d a  C o n t a  ==> " 
					ValorCTB(nTotCta,li,aColunas[COL_VALORLANC],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,"1")			
					ValorCTB(nSldCCCta,li,aColunas[COL_VLRSALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,"1")						
					nTotCta		:= 0
					nSldCCCta   := 0 
					li++           			
					@li, 00 PSAY Replicate("-",nTamLinha)
					li++           			
				EndIf	
			else // sintetico	
				@li,aColunas[COL_CONTA] psay vdescconta
				ValorCTB(nTotCta,li,aColunas[COL_VALORLANC],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,"1")			
				ValorCTB(nSldCCCta,li,aColunas[COL_VLRSALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,"1")						
				nTotCta		:= 0
				nSldCCCta   := 0 
				li++           			
//				@li, 00 PSAY Replicate("-",nTamLinha)
			endif	
			dbSelectArea("cArqTmp")
		EndDo	
      //li++
	
		If li > 56
			CtCGCCabec(.F.,.T.,.F.,Cabec1,Cabec2,dDataFim,Titulo,.T.,"1",Tamanho)					
			li++
		EndIf   
		
		li++			
		
		@li, 00 PSAY Replicate("=",nTamLinha)
		
		li++	
		
		@li,aColunas[COL_CONTA] PSAY STR0017 + Upper(Alltrim(cSayCusto)) + " ==>    ( "  //"T o t a l  d o  C e n t r o  d e  C u s t o  ==> "     
		
		If lImpCCRes // Se imprime cod. reduzido de Centro de Custo
			dbSelectArea("CTT")
			dbSetOrder(1)
			dbSeek(xFilial()+cCustoAnt)  
			cResCC := CTT->CTT_RES
			EntidadeCTB(Alltrim(cResCC),li,pcol()+2,20,.F.,cMascara2,cSepara2)		
		Else
			EntidadeCTB(Alltrim(cCustoAnt),li,pcol()+2,20,.F.,cMascara2,cSepara2)	
		Endif
		@li,aColunas[COL_CONTRA_PARTIDA] PSAY " )"
		
		ValorCTB(nTotCC,li,aColunas[COL_VALORLANC],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,"1")			
		
		ValorCTB(nSaldoCC,li,aColunas[COL_VLRSALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,"1")				
		
		nSaldoCC	:= 0 			
		nTotCC	:= 0
			
		li++
		@li, 00 PSAY Replicate("=",nTamLinha)
		If lSalto	
			li++
		Else
			li+=2
		EndIf
		
		dbSelectArea("cArqTmp")
	EndDo	
	If li > 56
		CtCGCCabec(.F.,.T.,.F.,Cabec1,Cabec2,dDataFim,Titulo,.T.,"1",Tamanho)					
		li++
	EndIf   
	
	li++			
	
	@li, 00 PSAY Replicate("=",nTamLinha)
	
	li++	
	
	@li,aColunas[COL_CONTA] PSAY "T o t a l  d a  G e r e n c i a       ==> " 
/*li,aColunas[COL_CONTA] PSAY STR0017 + Upper(Alltrim(cSayCusto)) + " ==>    ( "  //"T o t a l  d a  G e r e n c i a              ==> "     */
                                  
	ValorCTB(nTotGer,li,aColunas[COL_VALORLANC],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,"1")			
	
	ValorCTB(nSaldoGer,li,aColunas[COL_VLRSALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,"1")				
	
	nSaldoCC	:= 0 			
	nTotCC	:= 0   
	nTotGer  := 0
	nSaldoGer:= 0
		
	li++
	@li, 00 PSAY Replicate("=",nTamLinha)
	If lSalto	
		li++
	Else
		li+=2
	EndIf

EndDo	

//IMPRESSAO DO TOTAL GERAL 
li++		                                     
@li, 00 PSAY Replicate("=",nTamLinha)
li++
@li,aColunas[COL_CONTA] PSAY STR0022 + " ==> "  //"T O T A L   G E R A L  ==> " 

ValorCTB(nTotalGeral,li,aColunas[COL_VALORLANC],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,"1")			

ValorCTB(nSaldoTotal,li,aColunas[COL_VLRSALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,"1")				

nTotalGeral := 0
nSaldoTotal := 0

li++
@li, 00 PSAY Replicate("=",nTamLinha)
li++

If li!= 80 
	roda(cbcont,cbtxt,Tamanho)
EndIf								

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
End

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIf	

dbselectArea("CT2")

MS_FLUSH()          
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGerLanc³ Autor ³ Simone Mie Sato       ³ Data ³ 08/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Cria Arquivo Temporario para imprimir o Rel. Lanc. C.Custo  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³CtbGerLanc(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,		   ³±±
±±³			  ³cContaFim,cGerenIni,cGerenFim,cMoeda,dDataIni,dDataFim,	   ³±±
±±³			  ³aSetOfBook)						                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nome do arquivo temporario                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC1 = Arquivo temporario                                 ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpC7 = Tipo de Saldo                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static Function CTBGerLanc(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim,cGerenIni,cGerenFim,;
					cMoeda,dDataIni,dDataFim,aSetOfBook,cSaldo)
			
Local aTamConta	:= TAMSX3("CT1_CONTA")
Local aTamCusto	:= TAMSX3("CT3_CUSTO")
Local aCtbMoeda	:= {}
Local aSaveArea := GetArea()
Local aCampos

Local cChave
Local nTamHist	:= Len(CriaVar("CT2_HIST"))
Local nDecimais	:= 0
Local cMensagem		:= STR0030// O plano gerencial nao esta disponivel nesse relatorio. 

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]

aCampos :={	{ "CCUSTO"		, "C", aTamCusto[1], 0 },;			// Centro de Custo
			{ "CONTA"		, "C", aTamConta[1], 0 },;  		// Codigo da Conta
			{ "XPARTIDA"   , "C", aTamConta[1] , 0 },;			// Contra Partida			
			{ "TIPO"       , "C", 01			, 0 },;			// Tipo do Registro (Debito/Credito/Continuacao)
			{ "VALORLANC"	, "N", 17			, nDecimais },; // Valor do Lancamento
			{ "SALDOSCR"	, "N", 17, nDecimais },; 			// Saldo
			{ "HISTORICO"	, "C", nTamHist   	, 0 },;			// Historico			
			{ "DATAL"		, "D", 10			, 0 },;			// Data do Lancamento
			{ "LOTE" 		, "C", 06			, 0 },;			// Lote
			{ "SUBLOTE" 	, "C", 03			, 0 },;			// Sub-Lote
			{ "DOC" 		   , "C", 06			, 0 },;			// Documento
			{ "LINHA"		, "C", 03			, 0 },;			// Linha
			{ "SEQLAN"		, "C", 03			, 0 },;			// Sequencia do Lancamento
			{ "SEQHIST"		, "C", 03			, 0 },;			// Seq do Historico
			{ "EMPORI"		, "C", 02			, 0 },;			// Empresa Original
			{ "GERENC"		, "C", 03			, 0 },;			// Gerência
			{ "FILORI"		, "C", 02			, 0 }}			// Filial Original


If cPaisLoc = "CHI"
	Aadd(aCampos,{"SEGOFI","C",TamSx3("CT2_SEGOFI")[1],0})
EndIf

																	
cArqTmp := CriaTrab(aCampos, .T.)

dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cChave 	:= "GERENC+CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"


IndRegua("cArqTmp",cArqTmp,cChave,,,STR0017)  //"Selecionando Registros..."
dbSelectArea("cArqTmp")
dbSetIndex(cArqTmp+OrdBagExt())
dbSetOrder(1)

If !Empty(aSetOfBook[5])
	MsgAlert(cMensagem)	
	Return
EndIf

CtbGeraLan(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cGerenIni,cGerenFim,;
			cMoeda,dDataIni,dDataFim,aSetOfBook,cSaldo)        				
			
RestArea(aSaveArea)

Return cArqTmp

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGeraLan³ Autor ³ Simone Mie Sato       ³ Data ³ 08/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arq temporario                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbGeraLan(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,	   ³±±
±±³			  ³	cGerenIni,cGerenFim,cMoeda,dDataIni,dDataFim,aSetOfBook,   ³±±
±±³			  ³	cSaldo)                             				   	   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC1 = Arquivo temporario                                 ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpC7 = Tipo de Saldo                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static Function CtbGeraLan(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cGerenIni,cGerenFim,;
				cMoeda,dDataIni,dDataFim,aSetOfBook,cSaldo)        								
				
Local aSaveArea := GetArea()
Local nMoeda	:= Val(cMoeda)
Local cChave	:= ""
Local cGerencF	:= cGerenFim
Local cContaF 	:= cContaFim

oMeter:nTotal := CT1->(RecCount())

dbSelectArea("CTT")
dbSetOrder(6)
MSSeek(xFilial()+"2"+cGerenIni+"",.F.)
cChave := 'CTT->CTT_FILIAL == xFilial() .And. CTT->CTT_GERENC <= "'+ cGerencF +'" .And. CTT->CTT_CLASSE == "2"'
	
While !Eof() .And. &(cChave)
   
   cGerenc   := CTT->CTT_GERENC
   cCustoat  := CTT->CTT_CUSTO
   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   // ³ Obt‚m os d‚bitos ³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CT2")
	dbSetOrder(4)
	MsSeek(xFilial()+CTT->CTT_CUSTO+ DTOS(dDataIni),.t.)
	cValid := "CT2->CT2_CCD == CTT->CTT_CUSTO"
		
	While !Eof() .and. CT2->CT2_FILIAL == xFilial() .And. ;
		&(cValid) .And.	;
		CT2->CT2_DATA >= dDataIni .And. CT2->CT2_DATA <= dDataFim 

		If 	CT2->CT2_VALOR == 0 .Or. CT2->CT2_TPSALD != cSaldo .Or. ;
			CT2->CT2_MOEDLC <> cMoeda		
			dbSkip()
			Loop
		EndIf

		If (CT2->CT2_DEBITO < cContaIni 	.Or. CT2->CT2_DEBITO > cContaFim) 	.Or.;
			(CT2->CT2_CCD <> cCustoat) 	
			dbSkip()
			Loop
		Endif

		CtbGrvLanc(cMoeda,cSaldo,"1")

		dbSelectArea("CT2")
		dbSetOrder(4)		        
		dbSkip()
	Enddo
	
   nRegistro:= recno()

	
   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   // ³ Obt‚m os creditos³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CT2")
	dbSetOrder(5)
	MsSeek(xFilial()+CTT->CTT_CUSTO+ DTOS(dDataIni),.t.)
	cValid := "CT2->CT2_CCC == CTT->CTT_CUSTO"

	While !Eof() .and. CT2->CT2_FILIAL == xFilial() .And. ;
		&(cValid) .And.	;
		CT2->CT2_DATA >= dDataIni .And. CT2->CT2_DATA <= dDataFim 
		If 	CT2->CT2_VALOR == 0 .Or. CT2->CT2_TPSALD != cSaldo .Or. ;
			CT2->CT2_MOEDLC <> cMoeda				
			dbSkip()
			Loop
		EndIf
          
		If (CT2->CT2_CREDITO < cContaIni .Or. CT2->CT2_CREDITO > cContaFim) .Or.;
			(CT2->CT2_CCC <> cCustoat)
			dbSkip()
			Loop
		Endif

		CtbGrvLanc(cMoeda,cSaldo,"2")
		
		DbSelectArea("CT2")
		dbSetOrder(5)		   
		dbSkip()		
	Enddo

	dbSelectArea("CTT")
	dbSetOrder(6)  
   dbSkip()
EndDo

Return                        

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGrvLanc³ Autor ³ Simone Mie Sato       ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arquivo temporario.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³CtbGrvLanc(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,		   ³±±
±±³			  ³cContaFim,cGerenIni,cGerenFim,cMoeda,dDataIni,dDataFim,	   ³±±
±±³			  ³aSetOfBook)						                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nome do arquivo temporario                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC1 = Arquivo temporario                                 ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpC7 = Tipo de Saldo                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static Function CtbGrvLanc(cMoeda,cSaldo,cTipo)		


Local cConta
Local cContra
Local cCusto

If cTipo == "1"
	cConta 	:= CT2->CT2_DEBITO
	cContra	:= CT2->CT2_CREDIT
	cCusto	:= CT2->CT2_CCD
EndIf	

If cTipo == "2"
	cConta 	:= CT2->CT2_CREDIT
	cContra := CT2->CT2_DEBITO
	cCusto	:= CT2->CT2_CCC
EndIf		           

/*ALERT("VOU GRAVAR")*/
              
/*LOCALIZANDO A GERENCIA DO CENTRO DE CUSTO 
dbSelectArea("CTT")
dbSetOrder(1)
MsSeek(xFilial()+cCusto)  
cGerenc := CTT->GERENC
*/

dbSelectArea("cArqTmp")
dbSetOrder(1)	
RecLock("cArqTmp",.T.)

Replace DATAL		With CT2->CT2_DATA
Replace TIPO		With cTipo
Replace LOTE		With CT2->CT2_LOTE
Replace SUBLOTE	With CT2->CT2_SBLOTE
Replace DOC			With CT2->CT2_DOC
Replace LINHA		With CT2->CT2_LINHA
Replace CONTA		With cConta
Replace XPARTIDA	With cContra
Replace CCUSTO		With cCusto
Replace HISTORICO	With CT2->CT2_HIST
Replace EMPORI		With CT2->CT2_EMPORI
Replace FILORI		With CT2->CT2_FILORI
Replace SEQHIST	With CT2->CT2_SEQHIST
Replace SEQLAN		With CT2->CT2_SEQLAN   
Replace GERENC    with cGerenc
Replace VALORLANC	With CT2->CT2_VALOR

If cPaisLoc == "CHI"
	Replace SEGOFI With CT2->CT2_SEGOFI// Correlativo para Chile
EndIf

If CT2->CT2_DC == "3"
	Replace TIPO	With cTipo
Else
	Replace TIPO 	With CT2->CT2_DC
EndIf		
MsUnlock()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VIT304SX1    ³Autor ³Simone Mie Sato       ³Data³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria as perguntas do relatório                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VIT304SX1()

Local aPergs 		:= {}
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCusto		:= TAMSX3("CTT_CUSTO")

aAdd(aPergs,{	"Data Inicial       ?","¨Fecha Inicial     ?","Initial Date       ?","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","S",".CTR04001."})
aAdd(aPergs,{	"Data Final         ?","¨Fecha Final       ?","Final Date         ?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","S",".CTR04002."})
aAdd(aPergs,{	"Da Gerência        ?","¨Da Gerência       ?","Da Gerência        ?","mv_ch3","C",3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SZT","","","   "})
aAdd(aPergs,{	"Ate a Gerência     ?","¨Ate a Gerência    ?","Ate a Gerência     ?","mv_ch4","C",3,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SZT","","","   "})
aAdd(aPergs,{	"Conta Inicial      ?","¨Cuenta Inicial    ?","Initial Account    ?","mv_ch5","C",aTamConta[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CT1","003","S",".CTR04003."})
aAdd(aPergs,{	"Conta Final        ?","¨Cuenta Final      ?","Final Account      ?","mv_ch6","C",aTamConta[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CT1","003","S",".CTR04004."})
aAdd(aPergs,{	"Moeda              ?","¨Que Moneda        ?","Currency           ?","mv_ch7","C",2,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTO","","S",".CTR04008."})
aAdd(aPergs,{	"Tipo de Saldo      ?","¨Tipo de Saldo     ?","Balance Type       ?","mv_ch8","C",1,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SLD","","S",".CTR04010."})
aAdd(aPergs,{	"Cod.Config.Livros  ?","¨Cod. Config.Libros?","Books Setup Code   ?","mv_ch9","C",3,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","CTN","","S",".CTR04006."})
Aadd(aPergs,{	"Imprime Cod. C.C   ?","¨Imprime Cod. C.C. ?","Print Code C.C.    ?","mv_cha","N",1,0,0,"C","","mv_par10","Normal","Normal","Normal","","","Reduzido","Reducido","Reduced","","","","","","","","","","","","","","","","","","","S",".CTR40025."})
aAdd(aPergs,{	"Imprime Cod. Conta ?","¨Impr Cod Cuenta   ?","Print Account Code ?","mv_chb","N",1,0,0,"C","","mv_par11","Normal","Normal","Normal","","","Reduzido","Reducido","Reduced","","","","","","","","","","","","","","","","","","","S",".CTR04019."})
aAdd(aPergs,{	"Totaliza tb por Cta?","¨Totaliza Cuenta   ?","Totalize Account   ?","mv_chc","N",1,0,0,"C","","mv_par12","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S",".CTR44011."})
aAdd(aPergs,{	"Salta Folha Gerenc.?","¨Salta Pag. Gerenc ?","Skip Page          ?","mv_chd","N",1,0,0,"C","","mv_par13","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S"," "})
aAdd(aPergs,{	"Tipo de Relatório  ?","¨Tipo de Relatório ?","Tipo de Relatório  ?","mv_chd","N",1,0,0,"C","","mv_par14","Sintético","Sintético","Sintético","","","Analítico","Analítico","Analítico","","","","","","","","","","","","","","","","","","","S"," "})

AjustaSx1("PERGVIT304",aPergs)   

Return
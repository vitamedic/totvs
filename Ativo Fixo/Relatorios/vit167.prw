#INCLUDE "VIT167.CH"
#include "rwmake.ch"
//#include "FiveWin.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ATFR150  ³ Autor ³ Cesar C S Prado       ³ Data ³ 10.02.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Movimentos                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ATFR150                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAATF                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function vit167()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cString  :="SN3"
LOCAL cDesc1	:=OemToAnsi(STR0001) // "Este relatorio ira' imprimir a movimentac„o de"
LOCAL cDesc2	:=OemToAnsi(STR0002) // "um bem em um determinado periodo."
LOCAL cDesc3	:=""
LOCAL wnrel

Private aOrd := { OemtoAnsi(STR0035), OemtoAnsi(STR0036) } //" Por Bem"," Por Conta"," } 
PRIVATE aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
PRIVATE aLinha   := { }
PRIVATE NomeProg :="VIT167"
PRIVATE nLastKey := 0

PRIVATE titulo:=OemToAnsi(STR0003) // "MOVIMENTOS"
PRIVATE cabec1
PRIVATE cabec2
PRIVATE tamanho:="M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cPerg    :="PERGVIT167"        //"AFR150"
_pergsx1()
pergunte( _cperg,.F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01        	// Do Bem                                ³
//³ mv_par02        	// Ate o Bem                             ³
//³ mv_par03        	// A partir da data                      ³
//³ mv_par04        	// Ate a Data                            ³
//³ mv_par05        	// A partir da conta                     ³
//³ mv_par06        	// Ate a conta                           ³
//³ mv_par07        	// Qual a Moeda                          ³
//³ mv_par08        	// Do Centro de Custo                    ³
//³ mv_par09        	// Ate o Centro de Custo                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "VIT167"+Alltrim(cusername)
wnrel := SetPrint(cString,wnrel,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho,"",.f.)

If	nLastKey == 27
	Return
End

SetDefault( aReturn,cString )

If nLastKey == 27
	Return
End

RptStatus({|lEnd| FR150Imp(@lEnd,wnRel,cString)},Titulo)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FR150Imp ³ Autor ³ Cesar C S Prado       ³ Data ³ 10.02.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimeir Movimento                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³   FR150(lEnd,WnRel,Titulo)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FR150Imp(lEnd,WnRel,cString)

LOCAL cbTxt
LOCAL cbCont
LOCAL cMoeda1
LOCAL cMoeda2
LOCAL nLen
LOCAL aTotMov:={}, aTotGeral := {}, aMovimento:={}  //Totais na moeda corrente (REAL)
LOCAL aMotivo  := {}
Local aTipoOco := {}
Local cMotivo
Local cContaAnt := cCustoAnt := " "
Local nOrdem := 0
Local cSeq   := Criavar("N3_SEQ")
Local cSeqReav:= Criavar("N3_SEQREAV")
Local cOcorre
Local aCodigo := { }, nPosicao
Local lTransfDe := .F., lTransfPa := .F.
Local lImp := .F.                        // Imprime se tiver vlr difer de zero
Local cConta := cCusto := " "
Local i
Local cCodigo
Local lFirst  := .T.
Local lImprimiu := .F.

Private cMoedaAux := StrZero(mv_par07+1,1)
Private cCond1 := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica tabela de motivos para baixa 									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSeek(cFilial+"16")
While SX5->X5_FILIAL+SX5->X5_TABELA == cFilial+"16"
	cCapital := Capital(X5Descri())
	AAdd( aMotivo, SubStr(SX5->X5_CHAVE,1,2 ) + "-" + SubStr(cCapital,1,12 ) )
	dbSkip()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := SPACE( 10 )
cbcont := 0
li     :=80
m_pag  :=1

cMoeda1:= GetMV( "MV_MOEDA1" )
cMoeda2:= GetMV( "MV_MOEDA" + cMoedaAux )
nLen   := Len( PesqPict( "SN4","N4_VLROC1",14 ) ) - Len( AllTrim( cMoeda1 ))
cMoeda1:= IIf( nLen > 0, Space(nLen) + cMoeda1, cMoeda1 )
nLen   := Len( PesqPict("SN4","N4_VLROC"+cMoedaAux,14) ) - Len(AllTrim(cMoeda2))-3
cMoeda2:= IIf( nLen > 0, Space(nLen) + cMoeda2, cMoeda2 )

nOrdem := aReturn[8]

titulo += 	OemToAnsi(STR0004)+; // " entre "
				DTOC(mv_par03) + OemToAnsi(STR0005)+; //" a " 
				DTOC(mv_par04) + aOrd[nOrdem]
cabec1 := OemToAnsi(STR0006)     // "Codigo do Bem       Descricao sintetica "
cabec2 := OemToAnsi(STR0007) +	cMoeda1+" "+cMoeda2+" "+OemToAnsi(STR0008) // "     Quantidade   Taxa Media Tx.Depr"
//"Dt.Movim   Tipo Movimentacao CtaTranf            Motivo Movim."  cMoeda1(REAIS) cMoeda2       "Quantidade Taxa Media Tx.Depr"
// 99/99/9999 XXXXXXXXXXXXXXXX+cccccccccccccccccccc xxxxxxxxxxxxxxx 999.999.999,99 999.999.999,99 9999,99999 99999,9999 99999999
// 01234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234
//           1         2         3         4         5         6         7         8         9         0         1         2    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza registro inicial                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SN3")
If nOrdem == 1
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01,.T.)
	cCond1 := "N3_CBASE <= mv_par02"
	cChave := N3_CBASE
ElseIf nOrdem == 2
	dbSetOrder(2)
	dbSeek(xFilial()+mv_par05,.T.)
	cCond1 := "N3_CCONTAB <= mv_par06"
	cChave := N3_CCONTAB
EndIf
                             
For i := 1 to 14
	AADD( aMovimento, {0,0,Nil })  // { Vlr em R$, Vlr M Forte, Desc Movimento}
	AADD( aTotMov, {0,0})          // { Total na M1, Total M Forte }
	AADD( aTotGeral, {0,0})        // { Total Geral na Moeda1, Total Geral na Moeda Forte }
Next

SetRegua(SN3->(RecCount()))
cCodigo := " "
While !Eof() .And. SN3->N3_FILIAL == xFilial("SN3") .And. &cCond1
	cConta := SN3->N3_CCONTAB
	cCusto := SN3->N3_CCUSTO 
	lFirst  := .T.
	lImprimiu := .F.
	IF lEnd
		@PROW()+1,001 PSAY OemToAnsi(STR0009) // "CANCELADO PELO OPERADOR"
		Exit
	EndIf
		
	IncRegua()
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Guardo o registro for do tipo ="02", guardo o registro com a ³
	//³ mesma seq de reav para que nao processe o mesmo registro.    ³
	//³ Isto ocorre em reg com reav e baixas parciais. EX:           ³
	//³ CBASE  - ITEM - TIPO - SEQ - SEQ REAV                        ³
	//³ IMOB001- 0001 - 01   - 001 -                                 ³
	//³ IMOB001- 0001 - 02   - 002 - 01                              ³
	//³ IMOB001- 0001 - 02   - 003 - 02                              ³
	//³ Apos uma baixa parcial                                       ³	
	//³ CBASE  - ITEM - TIPO - SEQ - SEQ REAV                        ³
	//³ IMOB001- 0001 - 01   - 004 -                                 ³
	//³ IMOB001- 0001 - 02   - 005 - 01                              ³
	//³ IMOB001- 0001 - 02   - 006 - 02                              ³	
	//³ Os regs de bxs parciais com a mesma seq de reav sao do mesmo ³
	//³ reg que originaram a baixa, portanto nao posso passar por ele³
	//³ mais de uma vez.                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nOrdem == 2 .And. cContaAnt!= SN3->N3_CCONTAB
		For i := 1 to Len(aTotMov)
			If aTotMov[i][1] != 0
				lImp := .T.
				Exit
			Endif
		Next
		
		If lImp 
			@ li,65 PSAY "-------------- --------------"	
			lImp := .F.
		Endif
		
		For i := 1 to Len(aTotMov)
			If aTotMov[i][1] != 0
				IF	li > 58
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
				EndIf
				li++	
				@ li, 00 PSAY OemToAnsi(STR0027)  //"Tot. da Conta"
				@ li, 15 PSAY aMovimento[i][3] //OemToAnsi(STR0027) // "TOTAIS DA DEPRECIACAO"
				@ li, 65 PSAY aTotMov[i][1] PICTURE PesqPict("SN4","N4_VLROC1",14)
				@ li, 80 PSAY aTotMov[i][2] PICTURE PesqPict("SN4","N4_VLROC"+cMoedaAux,14)
				aTotGeral[i][1]+= aTotMov[i][1]
				aTotGeral[i][2]+= aTotMov[i][2]
				aTotMov[i][1] := 0
				aTotMov[i][2] := 0
			Endif
		Next i
		li+=2
	EndIf   


	If cCodigo == SN3->N3_CBASE+SN3->N3_ITEM+SN3->N3_TIPO
		If SN3->N3_TIPO =="02"
			nPosicao := Ascan(aCodigo,{|x| x=SN3->N3_CBASE+SN3->N3_ITEM+SN3->N3_TIPO+SN3->N3_SEQREAV})
			If nPosicao > 0
				cCodigo := SN3->N3_CBASE+SN3->N3_ITEM+SN3->N3_TIPO
				dbSkip()
				Loop
			EndIf
		Endif
	EndIf
	
	If SN3->N3_TIPO =="02"
		AADD(aCodigo,N3_CBASE+N3_ITEM+N3_TIPO+N3_SEQREAV)
	Endif
	
	If SN3->N3_CBASE < MV_PAR01 .Or. SN3->N3_CBASE > MV_PAR02
		dbSkip()
		Loop
	EndIf

	If	SN3->N3_CCONTAB < MV_PAR05 .Or. SN3->N3_CCONTAB > MV_PAR06
		dbSkip()
		Loop
	EndIf
	
  	If	SN3->N3_CCUSTO  < MV_PAR08 .Or. SN3->N3_CCUSTO  > MV_PAR09
  		dbSkip()
  		Loop
  	EndIf

	IF	Val(SN3->N3_BAIXA) # 0 .And. (Dtos(SN3->N3_DTBAIXA) < Dtos(MV_PAR03))// .Or.;
//		Dtos(SN3->N3_DTBAIXA) > Dtos(MV_PAR04))
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza item no SN1                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SN1")
	dbSetOrder(1)
	dbSeek(xFilial("SN1")+SN3->N3_CBASE+SN3->N3_ITEM)

	dbSelectArea("SN4")
	dbSetOrder(1)
	cBase    := SN3->N3_CBASE+SN3->N3_ITEM+SN3->N3_TIPO
	cSeq     := SN3->N3_SEQ
	cSeqReav := SN3->N3_SEQREAV
	dbSeek(xFilial()+cBase)
	lTransfDe := .F.
	lTransfPa := .F.
	While	!Eof() .And. SN4->N4_FILIAL	== xFilial("SN4") .And.;
			SN3->N3_CBASE+SN3->N3_ITEM+SN3->N3_TIPO == SN4->N4_CBASE+SN4->N4_ITEM+SN4->N4_TIPO
		IF	lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0009) // "CANCELADO PELO OPERADOR"
			Exit
		EndIf
		
		If cSeqReav != SN4->N4_SEQREAV
			dbSkip()
			Loop
		EndIf
	
		If	SN4->N4_SEQ # SN3->N3_SEQ
			SN4->(dbSkip())
			Loop
		End

		If	Dtos(SN4->N4_DATA) < Dtos(MV_PAR03) .Or. Dtos(SN4->N4_DATA) > Dtos(MV_PAR04)
			dbSkip()
			Loop
		EndIf
		
		If SN4->N4_CBASE < MV_PAR01 .Or. SN4->N4_CBASE > MV_PAR02
			dbSkip()
			Loop
		EndIf
/*
		If	SN4->N4_CONTA < MV_PAR05 .Or. SN4->N4_CONTA > MV_PAR06
			dbSkip()
			Loop
		EndIf
*/
		IF	li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		EndIf		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TIPOS DE MOVIMENTOS ( N4_OCORR )         ³
		//³ 01 - Baixa                               ³
		//³ 02 - Substituicao                        ³
		//³ 03 - Tranferencia de                     ³
		//³ 04 - Tranferencia para                   ³
		//³ 05 - Implantacao                         ³
		//³ 06 - Depreciacao                         ³
		//³ 07 - Correcao                            ³
		//³ 08 - Correcao da Depreciacao             ³
		//³ 09 - Ampliacao                           ³
		//³ 10 - Aceleracao Positiva ( Espec - SBPS )³
		//³ 11 - Aceleracao Negativa ( Espec - SBPS )³
		//³ 13 - Inventario                          ³
		//³ 15 - Baixa por Transferencia             ³
		//³ 16 - Aquisicao por Transferencia         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aTipoOco:={ OemToAnsi(STR0010),; // "Baixa           "  1  - 01
						OemToAnsi(STR0011),; // "Substituicao    "   2  - 02
						OemToAnsi(STR0012),; // "Transf. de "        3  - 03
					 	OemToAnsi(STR0013),; // "Transf. p/ "        4  - 04
					 	OemToAnsi(STR0014),; // "Implantac no mes"   5  - 05
					 	OemToAnsi(STR0015),; // "Depreciac no mes"   6  - 06
					 	OemToAnsi(STR0016),; // "Correcao no mes "   7  - 07
						OemToAnsi(STR0017),; // "Corr Monet Depre"   8  - 08
						OemToAnsi(STR0018),; // "Ampliacao "         9  - 09
						OemToAnsi(STR0029),; // "Acel. Positiva"    10  - 10
						OemToAnsi(STR0030),; // "Acel. Negativa"    11  - 11
						OemToAnsi(STR0032),; // "Invent rio"        12  - 13
						OemToAnsi(STR0033),; // "Baixa por Transf"  13  - 15
						OemToAnsi(STR0034) } // "Aquis por Transf"  14  - 16

		cMotivo:=IIf(Empty(N4_Motivo)," ",aMotivo[Val(SN4->N4_MOTIVO)])

      lImprime := .T.
		If SN4->N4_OCORR = "06" .And. SN4->N4_TIPOCNT = "4"		// Depreciacao
			lImprime := .F.
		Endif

		If SN4->N4_OCORR = "07" .And. SN4->N4_TIPOCNT = "1"		// Correcao
			lImprime := .F.
		Endif
		
		If SN4->N4_OCORR = "08" .And. SN4->N4_TIPOCNT = "4"		// Correcao Depreciacao
			lImprime := .F.
		Endif
		
		If SN4->N4_OCORR = "13" .And. SN4->N4_TIPOCNT = "4"		// Inventario 
			lImprime := .F.
		Endif

		If SN4->N4_OCORR $ "10,11" .And. SN4->N4_TIPOCNT = "4"		// Depreciacao Acelerada
			lImprime := .F.
		Endif

		If lImprime
			lImprimiu := .T.
			IF	li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
			EndIf
		   If lFirst
		   	lFirst := .F.
				If nOrdem == 2
					If cConta != cContaAnt
						li++
						cContaAnt := cConta 
						@li, 0 PSAY "Conta :	" + SN3->N3_CCONTAB
						li++
					Endif
				Endif
				
				@ li,  0	PSAY	SN1->N1_CBASE + "-" + SN1->N1_ITEM + "-" + SN3->N3_TIPO 
				@ li, 20	PSAY	SN1->N1_DESCRIC
				li++
			Endif	
			
			@ li, 000 PSAY	SN4->N4_DATA
			If Val(SN4->N4_OCORR) >= 13
				If SN4->N4_OCORR == "13"
					cOcorre :=aTipoOco[12]
					@ li, 011 PSAY	cOcorre
				ElseIf SN4->N4_OCORR == "15"
					cOcorre :=aTipoOco[13]
					@ li, 011 PSAY	cOcorre
				ElseIf SN4->N4_OCORR=="16"
					cOcorre :=aTipoOco[14] + " " + IIF(SN4->N4_OCORR $"03/04",Subst(SN4->N4_CONTA,1,20)," ")
					@ li, 011 PSAY	cOcorre
				Else
					cOcorre :=aTipoOco[15] + " " + IIF(SN4->N4_OCORR $"03/04",Subst(SN4->N4_CONTA,1,20)," ")
					@ li, 011 PSAY	cOcorre				
				Endif
			Else
				cOcorre :=aTipoOco[Val(SN4->N4_OCORR)] + " " + IIF(SN4->N4_OCORR $"03/04",Subst(SN4->N4_CONTA,1,20)," ")
				@ li, 011 PSAY	cOcorre
			Endif
			@ li, 049 PSAY	cMotivo
			@ li, 065 PSAY	 SN4->N4_VLROC1  PICTURE PesqPict("SN4","N4_VLROC1",14) 
			@ li, 080 PSAY &('SN4->N4_VLROC'+cMoedaAux) PICTURE PesqPict("SN4","N4_VLROC"+cMoedaAux,14)
			@ li, 095 PSAY	SN4->N4_QUANTD  PICTURE PesqPict("SN4","N4_QUANTD" ,10) 
			@ li, 106 PSAY	SN4->N4_TXMEDIA PICTURE PesqPict("SN4","N4_TXMEDIA",11) 
			@ li, 118 PSAY	SN4->N4_TXDEPR  PICTURE PesqPict("SN4","N4_TXDEPR", 10)
			li++
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TIPOS DE MOVIMENTOS ( N4_OCORR )         ³
		//³ 01 - Baixa                               ³
		//³ 02 - Substituicao                        ³
		//³ 03 - Tranferencia de                     ³
		//³ 04 - Tranferencia para                   ³
		//³ 05 - Implantacao                         ³
		//³ 06 - Depreciacao                         ³
		//³ 07 - Correcao                            ³
		//³ 08 - Correcao da Depreciacao             ³
		//³ 09 - Ampliacao                           ³
		//³ 10 - Aceleracao Positiva ( Espec - SBPS )³
		//³ 11 - Aceleracao Negativa ( Espec - SBPS )³
		//³ 13 - Inventario                          ³
		//³ 15 - Baixa por Transferencia             ³
		//³ 16 - Aquisicao por Transferencia         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		If SN4->N4_OCORR=="01" .And. SN4->N4_TIPOCNT=="1"  //Baixa
			aMovimento[1][1]+= SN4->N4_VLROC1
			aMovimento[1][2]+= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[1][3]:= aTipoOco[1] //" BAIXA"
		ElseIf SN4->N4_OCORR=="02" .And. SN4->N4_TIPOCNT=="1"  //Substitu
			aMovimento[2][1]+= SN4->N4_VLROC1
			aMovimento[2][2]+= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[2][3]:= aTipoOco[2]  //"SUBSTITUICAO"
		ElseIf SN4->N4_OCORR=="03" .And. SN4->N4_TIPOCNT=="1" .And. !lTransfDe //Transf de 
			lTransfDe := .T.
			aMovimento[3][1]+= SN4->N4_VLROC1
			aMovimento[3][2]+= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[3][3]:= aTipoOco[3]  //" DEPRECIACAO"
		ElseIf SN4->N4_OCORR=="04" .And. SN4->N4_TIPOCNT=="1" .And. !lTransfPa  //Transf para
			lTransfPa := .T.
			aMovimento[4][1]+= SN4->N4_VLROC1
			aMovimento[4][2]+= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[4][3]:= aTipoOco[4] //"Transfer para"
		ElseIf SN4->N4_OCORR=="05" .And. SN4->N4_TIPOCNT="1"  //Implantac
			aMovimento[5][1]:= SN4->N4_VLROC1
			aMovimento[5][2]:= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[5][3]:= aTipoOco[5]  //"Implantacao"
		ElseIf SN4->N4_OCORR=="06" .And. SN4->N4_TIPOCNT=="3"  //Depreciac
			aMovimento[6][1]+= SN4->N4_VLROC1
			aMovimento[6][2]+= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[6][3]:= aTipoOco[6]   //"DEPRECIACAO"
		ElseIf SN4->N4_OCORR=="07" .And. SN4->N4_TIPOCNT=="2" //Corre Bem
			aMovimento[7][1]+= SN4->N4_VLROC1
			aMovimento[7][3]:= aTipoOco[7] //"Correcao Bem"
		ElseIf SN4->N4_OCORR=="08" .And. SN4->N4_TIPOCNT=="5"  //Corre Depr
			aMovimento[8][1]+= SN4->N4_VLROC1
			aMovimento[8][3]:= aTipoOco[8] //"Correcao da Depr"
		ElseIf SN4->N4_OCORR=="09" .And. SN4->N4_TIPOCNT=="1"  //Ampliacao
			aMovimento[9][1]+= SN4->N4_VLROC1
			aMovimento[9][2]+= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[9][3]:= aTipoOco[9]  //"Ampliacao"
		ElseIf SN4->N4_OCORR=="10" .And. SN4->N4_TIPOCNT=="3"  //Dep Acel  esp SBPS
			aMovimento[10][1]+= SN4->N4_VLROC1
			aMovimento[10][2]+= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[10][3]:= aTipoOco[10]   //"Acelera positiva"
		ElseIf SN4->N4_OCORR=="11" .And. SN4->N4_TIPOCNT=="3" //Dep Acel Espe SBPS
			aMovimento[11][1]+= SN4->N4_VLROC1
			aMovimento[11][2]+= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[11][3]:= aTipoOco[11]  //"Aceleracao Negativa"
		ElseIf SN4->N4_OCORR=="13" .And. SN4->N4_TIPOCNT=="4" //Ajuste inv
			aMovimento[12][1]+= SN4->N4_VLROC1
			aMovimento[12][2]+= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[12][3]:= aTipoOco[12]  //"Ajuste Invent"
		ElseIf SN4->N4_OCORR=="15" .And. SN4->N4_TIPOCNT=="1"  //Baixa Transf
			aMovimento[13][1]+= SN4->N4_VLROC1
			aMovimento[13][2]+= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[13][3]:= aTipoOco[13]   //"Baixa Transf"
		ElseIf SN4->N4_OCORR=="16" .And. SN4->N4_TIPOCNT=="1"  //Aquis Trans
			aMovimento[14][1]+= SN4->N4_VLROC1
			aMovimento[14][2]+= &('SN4->N4_VLROC'+cMoedaAux)
			aMovimento[14][3]:= aTipoOco[14]  //"Aquis Transf"
		EndIf
		dbSelectArea("SN4")
		dbSkip()		
	EndDo

	If lImprimiu
		@ li,65 PSAY "-------------- --------------"	
	Endif	
	For i := 1 to 14
		If aMovimento[i][1] != 0
			IF	li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
			EndIf
			li++
			@ li, 15 PSAY aMovimento[i][3] //OemToAnsi(STR0027)
			@ li, 65 PSAY aMovimento[i][1] PICTURE PesqPict("SN4","N4_VLROC1",14)
			@ li, 80 PSAY aMovimento[i][2] PICTURE PesqPict("SN4","N4_VLROC"+cMoedaAux,14)
			aTotMov[i][1]+= aMovimento[i][1]
			aTotMov[i][2]+= aMovimento[i][2]
			aMovimento[i][1]:=0
			aMovimento[i][2]:=0
		Endif
	Next i
	li+=2
				
	dbSelectArea("SN3")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ cContab e utilizada qdo a ordem for 2 ( CONTA )    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCodigo    := SN3->N3_CBASE+SN3->N3_ITEM+SN3->N3_TIPO
	cContaAnt  := SN3->N3_CCONTAB
   cCustoAnt  := SN3->N3_CCUSTO
	dbSkip()
   //despresa os registros que nao satisfazem a condicao do centro de custo
  	While !eof() .and. (SN3->N3_CCUSTO  < MV_PAR08 .Or. SN3->N3_CCUSTO  > MV_PAR09)
  		dbSkip()
  	End
	

	lImp := .F.
	If nOrdem == 2 .And. cContaAnt!= SN3->N3_CCONTAB
		For i := 1 to Len(aTotMov)
			If aTotMov[i][1] != 0			
				lImp := .T.
				Exit
			Endif
		Next
		
		If lImp 
			@ li,65 PSAY "-------------- --------------"	
			lImp := .F.
		Endif

		For i := 1 to Len(aTotMov)
			If aTotMov[i][1] != 0
				IF	li > 58
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
				EndIf
				li++	
				@ li, 00 PSAY OemToAnsi(STR0027)  //"Tot. da Conta"
				@ li, 15 PSAY aMovimento[i][3] //OemToAnsi(STR0027) // "TOTAIS DA DEPRECIACAO"
				@ li, 65 PSAY aTotMov[i][1] PICTURE PesqPict("SN4","N4_VLROC1",14)
				@ li, 80 PSAY aTotMov[i][2] PICTURE PesqPict("SN4","N4_VLROC"+cMoedaAux,14)
				aTotGeral[i][1]+= aTotMov[i][1]
				aTotGeral[i][2]+= aTotMov[i][2]
				aTotMov[i][1] := 0
				aTotMov[i][2] := 0
			Endif
		Next i
		LI+=2
	ElseIf nOrdem ==1 
		For i := 1 to Len(aTotMov)
			aTotGeral[i][1]+= aTotMov[i][1]
			aTotGeral[i][2]+= aTotMov[i][2]
			aTotMov[i][1] := 0
			aTotMov[i][2] := 0
		Next
	Endif	
EndDo

If lImprimiu
	@ li++,65 PSAY "-------------- --------------"	
Endif	
For i := 1 to Len(aTotGeral)
	If aTotGeral[i][1] != 0
		IF	li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		EndIf
		@ li, 00 PSAY OemtoAnsi(STR0028)  //"010101Total Geral "
		@ li, 15 PSAY aMovimento[i][3] //OemToAnsi(STR0027) // "TOTAIS DA DEPRECIACAO"
		@ li, 65 PSAY aTotGeral[i][1] PICTURE PesqPict("SN4","N4_VLROC1",14) 
		@ li, 80 PSAY aTotGeral[i][2] PICTURE PesqPict("SN4","N4_VLROC"+cMoedaAux,14)
		aTotGeral[i][1]:=0
		aTotGeral[i][2]:=0
		li++
	Endif
Next i

If !empty(mv_par08)
		li++
		@ li, 00 PSAY "Centro de Custos Selecionados: "+mv_par08+" a "+mv_par09
Endif

If lImprimiu
	roda(cbcont,cbtxt,Tamanho)
Endif	

DbClearFilter( NIL )

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	Ourspool(wnrel)
End
MS_FLUSH()



//³ mv_par01        	// Do Bem                                  ³
//³ mv_par02        	// Ate o Bem                               ³
//³ mv_par03        	// A partir da data                        ³
//³ mv_par04        	// Ate a Data                              ³
//³ mv_par05        	// A partir da conta                       ³
//³ mv_par06        	// Ate a conta                             ³
//³ mv_par07        	// Qual a Moeda                            ³
//³ mv_par08        	// Do Centro de Custo                      ³
//³ mv_par09        	// Ate o Centro de Custo                   ³
static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Do Bem                ?","mv_ch1","C",10,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SN1"})
aadd(_agrpsx1,{_cperg,"02","Ate o Bem             ?","mv_ch2","C",10,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SN1"})
aadd(_agrpsx1,{_cperg,"03","A partir da data      ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Ate a Data            ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","A partir da conta     ?","mv_ch5","C",20,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CT1"})
aadd(_agrpsx1,{_cperg,"06","Ate a conta           ?","mv_ch6","C",20,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CT1"})
aadd(_agrpsx1,{_cperg,"07","Qual a Moeda          ?","mv_ch7","N",01,0,2,"C",space(60),"mv_par07"       ,"Moeda 2"        ,space(30),space(15),"Moeda 3"        ,space(30),space(15),"Moeda 4"        ,space(30),space(15),"Moeda 5"        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"08","Do Centro de Custo    ?","mv_ch8","C",09,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{_cperg,"09","Ate o Centro de Custo ?","mv_ch9","C",09,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
	
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
return


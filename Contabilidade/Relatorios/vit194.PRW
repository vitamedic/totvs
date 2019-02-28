/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VIT194    ³ Autor ³ Edson G. Barbosa   ³ Data ³  20/04/04   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³Emitir as movimentacao de contabilizacao de consumo/producao³±±
±±³          ³LP 666 e 668                                                ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ AP6 IDE                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#INCLUDE "rwmake.ch"
#Include "topconn.ch"

User Function VIT194
//666-002 Transferência para Custo
//666-003 Transferência para Produção
//668-002 Devolução de Transferência para Custo
//668-003 Devolução de Transferência para Produção
//668-004 Produção Produto Acabado

Local cDesc1      := "Impressao de Movimentos Internos de Inventario,    "
Local cDesc2      := "Consumo e Producao conforme selecao do usuario.    "
Local cDesc3      := "Para os Mov. Internos Contabilizados."
Local cPict       := ""
Local titulo      := "Contab. Mvtos Int."
Local nLin        := 80

Local Cabec1      := "Emissao   Dcto  TM  Produto Descricao                 Grupo Ord. Prod.         Quantidade         Valor TP"
Local Cabec2      := ""
Local Cabec3      := ""

Local   imprime   := .T.
Private aOrd      := {}
Private lEnd      := .F.
Private lAbortPrint  := .F.
Private CbTxt     := ""
Private limite    := 132
Private tamanho   := "M"
Private nomeprog  := "VIT194" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo     := 18
Private aReturn   := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey  := 0
Private cPerg     := "PERGVIT194"
Private cbtxt     := Space(10)
Private cbcont    := 00
Private CONTFL    := 01
Private m_pag     := 01
Private wnrel     := "VIT194" // Coloque aqui o nome do arquivo usado para impressao em disco
Private _cnomarq  := _cindex1 := ""
//Variáveis do Rodapé.
nCntImpr := 0
cRodaTxt := ''

Private cString := "SF2"

dbSelectArea("SF2")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

processa({|| _querys()})
processa({|| _geratrb()})

//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
SetRegua(RecCount())

Do Case
	Case mv_par03 == 1
	     _cTit := "Consumo"			
	Case mv_par03 == 2
	     _cTit := "Inventario"			
	Case mv_par03 == 3
	     _cTit := "Producao"			
End Case
titulo := Trim(titulo)+" ("+_cTit+")"

trb->(dbgotop())
_nTotal   := 0
_nTotGer  := 0
_cConta   :=""
_cCOld    :=""
While !(trb->(EOF()))
	
	IncRegua()
	//³ Verifica o cancelamento pelo usuario...                             ³
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//³ Impressao do cabecalho do relatorio. . .                            ³
	
	If nLin > 54 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	if _cConta # TRB->CONTA+TRB->CONTAC+TRB->CC
		If _nTotal > 0
	      @nLin,00  PSAY _cCold
	      @nLin,93  PSAY Transform(_nTotal,"@E 999,999,999.99")
			nLin++
			nLin++
	     _nTotGer += _nTotal
        _nTotal  := 0
      Endif
      @nLin,00  PSAY "CONTAS: "+trim(TRB->CONTA)+" - "+trim(TRB->CONTAC)+" CC: "+TRB->CC
	   nLin++
		_cCold := "TOTAL DAS CONTAS: "+trim(TRB->CONTA)+" - "+trim(TRB->CONTAC)+" CC: "+TRB->CC
		_cConta:= TRB->CONTA+TRB->CONTAC+TRB->CC
	Endif
	@nLin,00  PSAY TRB->EMISSAO
	@nLin,10  PSAY TRB->DOC
	@nLin,17  PSAY TRB->TM
	@nLin,21  PSAY substr(TRB->COD,1,6)
	@nLin,29  PSAY substr(TRB->DESCRIC,1,29)
	@nLin,59  PSAY TRB->GRUPO
	@nLin,65  PSAY TRB->OP   
	@nLin,80  PSAY Transform(TRB->QUANT,"@E 999,999.999")
	@nLin,93  PSAY Transform(TRB->CUSTO1,"@E 999,999,999.99")
	@nLin,108  PSAY TRB->TIPO 
	_nTotal += TRB->CUSTO1
	nLin := nLin + 1 // Avanca a linha de impressao
   If nLin > 54
      Roda(nCntImpr, cRodaTxt, Tamanho)
   Endif
 	TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo)
EndDo
   
If _nTotal > 0
	@nLin,00  PSAY _cCold
   @nLin,93  PSAY Transform(_nTotal,"@E 999,999,999.99")
   nLin++
	nLin++
   _nTotGer += _nTotal
   _nTotal  := 0
Endif

nLin := nLin + 2
@nLin,00 PSAY replicate("_",limite)
nLin := nLin + 1
@nLin,40  PSAY "TOTAL GERAL...:"
@nLin,93  PSAY Transform(_nTotGer,"@E 999,999,999.99")
nLin := nLin + 1
@nLin,00 PSAY replicate("_",limite)

If nLin > 50 // Salto de Página. Neste caso o formulario tem 55 linhas...
   Roda(nCntImpr, cRodaTxt, Tamanho)
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif
nLin := nLin + 2
//@nLin,00  PSAY "                              Legenda para TP:                             "
@nlin,00 PSAY vit194c("Legenda para TP:")
nLin++
@nLin,00 PSAY vit194c("DC - Dev. Transf. Custo                          DP - Dev. Transf. Producao")
nLin++
@nLin,00 PSAY vit194c("IG - Inventario Ganho                            IP - Inventario Perda     ")
nLin++
@nLin,00 PSAY vit194c("MD - Mat. Cons. Dev.                             MR - Mat. Cons. Ret.      ")
nLin++
@nLin,00 PSAY vit194c("PR - Producao                                    TC - Transf. Custo        ")
nLin++
@nLin,00 PSAY vit194c("TP - Transf. Producao																		 .")

Roda(nCntImpr, cRodaTxt, Tamanho)

      
//³ Finaliza a execucao do relatorio...                                 ³
SET DEVICE TO SCREEN

//Fechar Area aberta
tmp1->(dbclosearea())
trb->(dbclosearea())
ferase(_cnomarq+getdbextension())
ferase(_cindex1)

//³ Se impressao em disco, chama o gerenciador de impressao...          ³
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ValidPerg
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs:={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Emissao de         ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","       ","","","","","          ","","","","","        ","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Emissao Ate        ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","       ","","","","","          ","","","","","        ","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cperg,"03","Imprime            ?","","","mv_ch3","N",01,0,0,"C","","mv_par03","Consumo","","","","","Inventario","","","","","Producao","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

dbSelectArea(_sAlias)

Return

static function _geratrb()

Procregua(5000)
aCampos := {}
AADD(aCampos,{ "TM"     , "C" , 03 , 0 } )
AADD(aCampos,{ "QUANT"  , "N" , 15 , 3 } )
AADD(aCampos,{ "EMISSAO", "D" , 08 , 0 } )
AADD(aCampos,{ "GRUPO"  , "C" , 04 , 0 } )
AADD(aCampos,{ "CUSTO1" , "N" , 14 , 2 } )
AADD(aCampos,{ "COD"    , "C" , 15 , 0 } )
AADD(aCampos,{ "DOC"    , "C" , 06 , 0 } )
AADD(aCampos,{ "CONTA"  , "C" , 20 , 0 } )
AADD(aCampos,{ "CONTAC" , "C" , 20 , 0 } )
AADD(aCampos,{ "CC"     , "C" ,  9 , 0 } )
AADD(aCampos,{ "OP"     , "C" , 13 , 0 } )
AADD(aCampos,{ "TIPO"   , "C" , 02 , 0 } )
AADD(aCampos,{ "DESCRIC", "C" , 40 , 0 } )

_cnomarq := CriaTrab(aCampos,.T.)
_index1  := CriaTrab(NIL,.f.)

DbUseArea(.t.,,_cnomarq,"TRB",.f.)
IndRegua( "TRB", _index1, "CONTA+CONTAC+CC+DTOS(EMISSAO)",,,  "Criando Arquivo de Indice..." )
//Set Index To &(_index1+OrdBagExt())
//DbSetOrder(1)

DbSelectArea("TRB")

DbSelectArea("SD3")

DbSelectArea("SB1")
DbSetOrder(1)
DbSelectArea("CT5")
DbSetOrder(1)
_cTipo:=""
If mv_par03 == 1  //Consumo
   CT5->(DBSEEK(xFilial("CT5")+"666001"))
   _cSconta := ct5->ct5_debito
   _cScontac:= ct5->ct5_credit
   _cSregra := ct5->ct5_vlr01
   CT5->(DBSEEK(xFilial("CT5")+"668001"))
   _cEcontac:= ct5->ct5_credit
   _cEconta := ct5->ct5_debito
   _cEregra := ct5->ct5_vlr01
   _cTipo:="MC"
Elseif mv_par03 == 2  //Inventario
   CT5->(DBSEEK(xFilial("CT5")+"666004"))
   _cSconta := ct5->ct5_debito
   _cScontac:= ct5->ct5_credit
   _cSregra := ct5->ct5_vlr01
   CT5->(DBSEEK(xFilial("CT5")+"668005"))
   _cEcontac:= ct5->ct5_credit
   _cEconta := ct5->ct5_debito
   _cEregra := ct5->ct5_vlr01
Else // Producao
//666-002 Transferência para Custo
//666-003 Transferência para Produção
//668-002 Devolução de Transferência para Custo
//668-003 Devolução de Transferência para Produção
//668-004 Produção Produto Acabado
   CT5->(DBSEEK(xFilial("CT5")+"666002"))//Transferencia Custo   
   _cTCconta := ct5->ct5_debito
   _cTCcontac:= ct5->ct5_credit
   _cTCregra := ct5->ct5_vlr01
   CT5->(DBSEEK(xFilial("CT5")+"666002"))//Devolucao Transferencia Custo   
   _cDCconta := ct5->ct5_debito
   _cDCcontac:= ct5->ct5_credit
   _cDCregra := ct5->ct5_vlr01
   CT5->(DBSEEK(xFilial("CT5")+"666003"))//Transferencia Producao
   _cSconta := ct5->ct5_debito
   _cScontac:= ct5->ct5_credit
   _cSregra := ct5->ct5_vlr01
   CT5->(DBSEEK(xFilial("CT5")+"668003"))//devolucao Transferencia Producao
   _cEcontac:= ct5->ct5_credit
   _cEconta := ct5->ct5_debito
   _cEregra := ct5->ct5_vlr01
   CT5->(DBSEEK(xFilial("CT5")+"668004")) //produto acabado
   _cPcontac:= ct5->ct5_credit
   _cPconta := ct5->ct5_debito
   _cPregra := ct5->ct5_vlr01
Endif
TMP1->(DbGoTop())
While !tmp1->(eof())
	IncProc("Processando-> "+dtoc(tmp1->d3_emissao))
   sb1->(DBSEEK(xFilial("SB1")+tmp1->d3_cod))
	SD3->(dBgoTo(TMP1->D3_REG))
	_lCtb   := .f.
	_cConta :=""
	_cContac:=""
	_nValor := 0
	If tmp1->d3_tm <="499"  //entrada
      //668-002 Devolução de Transferência para Custo
      //668-003 Devolução de Transferência para Produção
      //668-004 Produção Produto Acabado
		_nTipo:=9       //0=producao; 1= devolucao de custo; 2=Dev.Transf. Producao
		If mv_par03==3 //producao
          _nValor := &_cDCregra 
			 If _nValor > 0
			 	 _nTipo:=1	
				 _cTipo:="DC"
   		 Else
				 _nValor := &_cPregra
				 If _nValor > 0
         		 _nTipo:=0
				    _cTipo:="PR"
				 Else
	      		 _nValor := &_cEregra		 	
         		 If _nValor > 0
         		    _nTipo:=2
				       _cTipo:="DP"
					 Endif
				 Endif
			 Endif
    	Else
			 _nValor := &_cEregra	
		Endif
		If _nValor > 0
			If mv_par03==3 //producao
				Do Case
					Case _nTipo == 0 //Producao
							_cConta  := &_cPconta                   
							_cContacc:= &_cPcontac		
					Case _nTipo == 1 //devolucao de custo
							_cConta  := &_cDCconta                   
							_cContacc:= &_cDCcontac		
					Case _nTipo == 2 //transf. producao
							_cConta  := &_cEconta                   
							_cContacc:= &_cEcontac		
				End Case
				_lCtb:=.t.
   		Else
				_cConta  := &_cEconta                   
				_cContacc:= &_cEcontac		
				_lCtb:=.t.
				If mv_par03==2
				   _cTipo:="IG"
				Else
				   _cTipo:="MD"
				Endif
			Endif
	   Endif
	Else //Saida
      //666-002 Transferência para Custo
      //666-003 Transferência para Produção
		If mv_par03==3 //producao
		    _nTipo:=9       //0=Transf. Custo; 1=Transf. Producao
          _nValor := &_cTCregra 
			 If _nValor > 0
				 _nTipo := 0
				 _cTipo:="TC"
			 Else
	         _nValor := &_cSregra
				If _nValor > 0
					_nTipo := 1
				   _cTipo:="TP"
				Endif			 	 
			 Endif	
    	Else
	       _nValor := &_cSregra
		Endif
		If _nValor > 0
			If mv_par03 == 3
				Do Case
					Case _nTipo == 0 //Transf. Producao
							_cConta  := &_cSconta                   
							_cContacc:= &_cScontac		
					Case _nTipo == 1 //Transferencia custo
							_cConta  := &_cTCconta                   
							_cContacc:= &_cTCcontac		
				End Case
				_lCtb:=.t.
			Else
				_cConta  := &_cSconta
				_cContacc:= &_cScontac		
				_lCtb:=.t.
				If mv_par03==2
				   _cTipo:="IP"
				Else
				   _cTipo:="MR"
				Endif
			Endif
	   Endif
	Endif
	If _lCtb   //monta trb
		trb->(reclock("TRB",.t.))
		Replace trb->TM      with tmp1->d3_tm      ,;
		        trb->quant   with tmp1->d3_quant   ,;
		        trb->emissao with tmp1->d3_emissao ,;
		        trb->grupo   with tmp1->d3_grupo   ,;
		        trb->custo1  with _nValor          ,;
		        trb->cod     with tmp1->d3_cod     ,;
		        trb->descric  with sb1->b1_desc     ,;
		        trb->doc     with tmp1->d3_doc     ,;
		        trb->conta   with _cConta          ,;
		        trb->contac  with _cContacc        ,;
		        trb->tipo    with _cTipo           ,;
		        trb->op      with tmp1->d3_op      ,;
		        trb->cc      with tmp1->d3_cc      		        
      TRB->(MSUNLOCK())
   Endif
	tmp1->(dbskip())
End
Return


static function _querys()
procregua(4)
incproc("Preparando Query....")
_cquery1:=" SELECT "
_cquery1+=" D3_TM, D3_QUANT, D3_EMISSAO, D3_GRUPO, D3_CUSTO1, D3_COD, D3_DOC, "
_cquery1+=" D3_CC, R_E_C_N_O_  D3_REG, D3_OP"
_cquery1+=" FROM "
_cquery1+=retsqlname("SD3")+" SD3 "
_cquery1+=" WHERE "
_cquery1+="     SD3.D_E_L_E_T_<>'*'"
_cquery1+=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery1+=" ORDER BY 3 "
_cquery1:=changequery(_cquery1)

MEMOWRITE("C:\WINDOWS\TEMP\VIT194.SQL",_CQUERY1)
incproc("Selecionando Movimento...")
tcquery _cquery1 new alias "TMP1"

incproc("Preparando Arquivo Temporario...")
tcsetfield("TMP1","D3_QUANT"  ,"N",15,3)
tcsetfield("TMP1","D3_CUSTO1" ,"N",14,2)
tcsetfield("TMP1","D3_EMISSAO","D")
return

Static Function vit194c(cTexto)
Return( Space((limite-Len(ctexto))/2)+ctexto )
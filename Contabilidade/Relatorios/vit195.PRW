/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VIT195    ³ Autor ³ Edson G. Barbosa   ³ Data ³  12/02/04   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³Emitir as NF participantes do CMV conforme o criterio do    ³±±
±±³          ³LP 678                                                      ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ AP6 IDE                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#INCLUDE "rwmake.ch"
#Include "topconn.ch"

User Function VIT195

Local cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2      := "de acordo com os parametros informados pelo usuario."
Local cDesc3      := "NF participantes do CMV."
Local cPict       := ""
Local titulo      := "CMV"
Local nLin        := 80

Local Cabec1      :="EMISSAO     NF - SERIE                   CMV            Valor NF.          %"
Local Cabec2      :="Produto                               Qtde.  Cst.unit  Cst.total "
Local Cabec3      := ""

Local   imprime   := .T.
Private aOrd      := {}
Private lEnd      := .F.
Private lAbortPrint  := .F.
Private CbTxt     := ""
Private limite    := 80
Private tamanho   := "P"
Private nomeprog  := "VIT195" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo     := 18
Private aReturn   := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey  := 0
Private cPerg     := "PERGVIT195"
Private cbtxt     := Space(10)
Private cbcont    := 00
Private CONTFL    := 01
Private m_pag     := 01
Private wnrel     := "VIT195" // Coloque aqui o nome do arquivo usado para impressao em disco
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

titulo := Trim(titulo)+" de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)


trb->(dbgotop())
_nTotal := _nTotGer := 0
_cConta:=""
_cnota :=""
_cserie :=""
_ntval := 0
_ntot :=0
While !(trb->(EOF()))
	_acom    :={}
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
	if _cConta # TRB->CONTA+TRB->CONTAC
		If _nTotal > 0
			@nLin,12  PSAY "Total das Contas"
	      @nLin,30  PSAY Transform(_nTotal,"@E 999,999,999.99")
	      @nLin,50  PSAY Transform(_nTval,"@E 999,999,999.99")
	      @nLin,70  PSAY Transform((_nTotal/_ntval)*100,"@E 999.99%")
			nLin++
			nLin++
	     _nTotGer += _nTotal
        _nTotal := 0 
	     _nTot += _ntval
        _ntval := 0
      Endif
      @nLin,00  PSAY "CONTAS: "+trim(TRB->CONTA)+" - "+trim(TRB->CONTAC)
	   nLin++
		_cConta:= TRB->CONTA+TRB->CONTAC
	Endif
	_cCondNF := "TRB->F2_DOC+TRB->F2_SERIE == '"+TRB->F2_DOC+TRB->F2_SERIE+"'"	
	_nCusto  := 0
	_cDoc    := trb->F2_DOC+"-"+trb->F2_SERIE
	_dEmissao:= trb-> F2_EMISSAO
	_nvalor:= trb->F2_VALMERC
	While !trb->(eof()) .and. &_cCondNF
	  _nCusto += TRB->D2_CUSTO1     
  		aadd(_acom,{trb->d2_cod,trb->desc,trb->d2_qtde,trb->d2_custo1})
 	  TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo)
	End
	@nLin,00  PSAY _dEmissao
	@nLin,12  PSAY _cDoc
	@nLin,30  PSAY Transform(_nCusto,"@E 999,999,999.99")
	@nLin,50  PSAY Transform(_nValor,"@E 999,999,999.99")
	@nLin,70  PSAY Transform((_nCusto/_nvalor)*100,"@E 999.99%")
	_nTotal += _nCusto
	_ntval += _nvalor
	nLin := nLin + 1 // Avanca a linha de impressao
  	if mv_par03 =="S"                 
  		for _i:=1 to len(_acom) 
  			If nLin > 54 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			@ nLin,000 PSAY left(_acom[_i,1],6)
			@ nLin,007   PSAY left(_acom[_i,2],27)
			@ nLin,035   PSAY _acom[_i,3] picture "@E 9999,999"	
			@ nLin,044   PSAY _acom[_i,4]/_acom[_i,3] picture "@E 999.99999"
			@ nLin,055   PSAY _acom[_i,4] picture "@E 999,999.99"
			nLin := nLin + 1 // Avanca a linha de impressao
		next	
		nLin := nLin + 1 // Avanca a linha de impressao
	endif

   If nLin > 54
      Roda(nCntImpr, cRodaTxt, Tamanho)
   Endif
   
EndDo
If _nTotal > 0
//   nLin := nLin + 1
	@nLin,12  PSAY "Total das Contas"
   @nLin,30  PSAY Transform(_nTotal,"@E 999,999,999.99")
   @nLin,50  PSAY Transform(_nTval,"@E 999,999,999.99")
   @nLin,70  PSAY Transform((_nTotal/_ntval)*100,"@E 999.99%")
   nLin++
	nLin++
   _nTotGer += _nTotal
   _ntot += _ntval
   _ntval := 0
   _nTotal := 0
Endif
   
nLin := nLin + 2
@nLin,00 PSAY replicate("_",limite)
nLin := nLin + 1
@nLin,02  PSAY "TOTAL GERAL...:"
@nLin,30  PSAY Transform(_nTotger,"@E 999,999,999.99")
@nLin,50  PSAY Transform(_nTot,"@E 999,999,999.99")
@nLin,70  PSAY Transform((_nTotger/_ntot)*100,"@E 999.99%")

nLin := nLin + 1
@nLin,00 PSAY replicate("_",limite)
Roda(nCntImpr, cRodaTxt, Tamanho)
      
//³ Finaliza a execucao do relatorio...                                 ³
SET DEVICE TO SCREEN

//Fechar Area aberta
TRB->(dbclosearea())
TMP1->(dbclosearea())
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
AADD(aRegs,{cPerg,"01","Emissao de         ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Emissao Ate        ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Analitico          ?","","","mv_ch3","C",01,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

static function _querys()
procregua(3)
incproc("Preparando Query...")
_cquery1:=" SELECT "
_cquery1+=" F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALMERC,D2_CUSTO1 CMV, SD2.R_E_C_N_O_ D2REG, "
_cquery1+=" SF4.R_E_C_N_O_ F4REG, SB1.R_E_C_N_O_ B1REG "
_cquery1+=" FROM "
_cquery1+=retsqlname("SD2")+" SD2 ,"
_cquery1+=retsqlname("SF2")+" SF2 ,"
_cquery1+=retsqlname("SB1")+" SB1 ,"
_cquery1+=retsqlname("SF4")+" SF4"
_cquery1+=" WHERE "
_cquery1+="     SD2.D_E_L_E_T_<>'*'"
_cquery1+=" AND SF2.D_E_L_E_T_<>'*'"
_cquery1+=" AND SF4.D_E_L_E_T_<>'*'"
_cquery1+=" AND SB1.D_E_L_E_T_<>'*'"
//_cquery1+=" AND D2_FILIAL='"+xFILIAL("SD2")+"'"
//_cquery1+=" AND F2_FILIAL='"+xFILIAL("SF2")+"'"
//_cquery1+=" AND F4_FILIAL='"+xFILIAL("SF4")+"'"
_cquery1+=" AND D2_COD     = B1_COD"
_cquery1+=" AND D2_TES     = F4_CODIGO"
_cquery1+=" AND D2_DOC     = F2_DOC"
_cquery1+=" AND D2_SERIE   = F2_SERIE"
_cquery1+=" AND F2_CLIENTE = D2_CLIENTE"
_cquery1+=" AND F2_LOJA    = D2_LOJA"
_cquery1+=" AND F2_TIPO    = 'N' "
_cquery1+=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
//_cquery1+=" AND F4_TPOPER NOT IN ('B','D','F','G','L','M','N','T')"
_cquery1+=" AND F4_ESTOQUE = 'S' "
_cquery1+=" ORDER BY 3, 1, 2"
_cquery1:=changequery(_cquery1)
incproc("Checando Sintaxe...")

MEMOWRITE("C:\WINDOWS\TEMP\VIT195.SQL",_CQUERY1)

tcquery _cquery1 new alias "TMP1"
incproc("Selecionando itens das Notas Fiscais...")
tcsetfield("TMP1","CMV" ,"N",15,3)
tcsetfield("TMP1","F2_EMISSAO","D")
return

static function _geratrb()

Procregua(tmp1->(reccount())+500)
aCampos := {}
AADD(aCampos,{ "F2_DOC"     , "C" , 06 , 0 } )
AADD(aCampos,{ "F2_SERIE"   , "C" , 03 , 0 } )
AADD(aCampos,{ "F2_EMISSAO" , "D" , 08 , 0 } )
AADD(aCampos,{ "F2_VALMERC" , "N" , 14 , 2 } )
AADD(aCampos,{ "D2_CUSTO1"  , "N" , 14 , 2 } )
AADD(aCampos,{ "D2REG"      , "N" , 15 , 0 } )
AADD(aCampos,{ "F4REG"      , "N" , 15 , 0 } )
AADD(aCampos,{ "B1REG"      , "N" , 15 , 0 } )
AADD(aCampos,{ "CONTA"      , "C" , 20 , 0 } )
AADD(aCampos,{ "CONTAC"     , "C" , 20 , 0 } )
AADD(aCampos,{ "D2_Qtde"   , "N" , 15 , 0 } )
AADD(aCampos,{ "D2_COD"     , "C" , 15 , 0 } )
AADD(aCampos,{ "DESC"     , "C" , 40 , 0 } )

_cnomarq := CriaTrab(aCampos,.T.)
_index1  := CriaTrab(NIL,.f.)

DbUseArea(.t.,,_cnomarq,"TRB",.f.)
IndRegua( "TRB", _index1, "CONTA+CONTAC+DTOS(F2_EMISSAO)",,,  "Criando Arquivo de Indice..." )

DbSelectArea("TRB")

DbSelectArea("SD2")

DbSelectArea("SF4")

DbSelectArea("SB1")
DbSetOrder(1)
DbSelectArea("CT5")
DbSetOrder(1)

CT5->(DBSEEK(xFilial("CT5")+"678001"))
_cRconta := ct5->ct5_debito
_cRcontac:= ct5->ct5_credit
_cRValor := ct5->ct5_vlr01

TMP1->(DbGoTop())
While !tmp1->(eof())
	IncProc()
   sb1->(dBgoTo(TMP1->B1REG))
	SD2->(dBgoTo(TMP1->D2REG))
	SF4->(dBgoTo(TMP1->F4REG))
	_lCtb   := .f.
	_cConta :=""
	_cContac:=""
	_nValor := 0
   _nValor := &_cRvalor
	If _nValor > 0
			_cConta := &_cRconta                   
			_cContac:= &_cRcontac		
			_lCtb:=.t.
   Endif
	If _lCtb   //monta trb
		trb->(reclock("TRB",.t.))
		Replace trb->F2_DOC     with tmp1->F2_DOC,;
		        trb->F2_SERIE   with tmp1->F2_SERIE,;
		        trb->F2_EMISSAO with tmp1->F2_EMISSAO,;
		        trb->F2_VALMERC with tmp1->F2_VALMERC,;
		        trb->D2_CUSTO1  with _nValor         ,;		        
		        trb->D2_qtde    with sd2->d2_quant,;		        
				  trb->D2_COD    with sd2->d2_COD,;		        	  
				  TRB->DESC	     with sb1->b1_desc,;      
		        trb->conta      with _cConta         ,;
		        trb->contac     with _cContac        
      TRB->(MSUNLOCK())
   Endif
	tmp1->(dbskip())
End
Return


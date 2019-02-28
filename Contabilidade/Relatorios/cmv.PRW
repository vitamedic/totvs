/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CMV       ³ Autor ³ Edson G. Barbosa   ³ Data ³  18/06/04   ³±±
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

User Function CMV

Local cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2      := "de acordo com os parametros informados pelo usuario."
Local cDesc3      := "NF participantes do CMV."
Local cPict       := ""
Local titulo      := "NF COM CMV"
Local nLin        := 80

Local Cabec1      := "EMISSAO     NF - SERIE                                              CMV"
Local Cabec2      := ""
Local Cabec3      := ""

Local   imprime   := .T.
Private aOrd      := {}
Private lEnd      := .F.
Private lAbortPrint  := .F.
Private CbTxt     := ""
Private limite    := 80
Private tamanho   := "P"
Private nomeprog  := "CMV" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo     := 18
Private aReturn   := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey  := 0
Private cPerg     := "CMV"
Private cbtxt     := Space(10)
Private cbcont    := 00
Private CONTFL    := 01
Private m_pag     := 01
Private wnrel     := "CMV" // Coloque aqui o nome do arquivo usado para impressao em disco

//Variáveis do Rodapé.
nCntImpr := 0
cRodaTxt := ''

Private cString := "SF2"

dbSelectArea("SD2")
dbSetOrder(1)

dbSelectArea("CT5")
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

//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
SetRegua(tmp1->(RecCount()))

titulo := Trim(titulo)+" Periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)


tmp1->(dbgotop())
_nTotal := 0
While !(TMP1->(EOF()))
	
	IncRegua()
	//³ Verifica o cancelamento pelo usuario...                             ³
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	
	//³ Impressao do cabecalho do relatorio. . .                            ³
	
	If nLin > 54 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 08
	Endif
	
	cConta:=Trim(TMP1->DEBITO)+"-"+Trim(TMP1->CREDITO)
	@nLin,00  PSAY "Conta: " + cConta
	nLin++
	_nTconta:=0
	While tmp1->(!eof()) .and. Trim(TMP1->DEBITO)+"-"+Trim(TMP1->CREDITO)==cConta
		@nLin,00  PSAY TMP1->D2_EMISSAO
		@nLin,12  PSAY TMP1->D2_DOC+"-"+TMP1-> D2_SERIE
		@nLin,60  PSAY Transform(TMP1->CMV,"@E 999,999,999.99")
		_nTotal += TMP1->CMV
		_nTconta+= TMP1->CMV
		nLin++
		TMP1->(dbSkip()) // Avanca o ponteiro do registro no arquivo)
		If nLin > 54
			Roda(nCntImpr, cRodaTxt, Tamanho)
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   nLin := 08
		Endif
	End
	@nLin,00 PSAY replicate("_",limite)
	nLin++
	@nLin,00  PSAY "TOTAL CONTA: "+cConta
	@nLin,60  PSAY Transform(_nTconta,"@E 999,999,999.99")
	nLin := nLin + 2
	
EndDo

nLin := nLin + 2
@nLin,00 PSAY replicate("_",limite)
nLin++
@nLin,40  PSAY "TOTAL GERAL...:"
@nLin,60  PSAY Transform(_nTotal,"@E 999,999,999.99")
nLin++
@nLin,00 PSAY replicate("_",limite)
Roda(nCntImpr, cRodaTxt, Tamanho)

//³ Finaliza a execucao do relatorio...                                 ³
SET DEVICE TO SCREEN

//Fechar Area aberta
tmp1->(dbclosearea())

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
procregua(1)
ct5->(dbseek(xFilial("CT5")+"678001")) //CMV venda
_cDebCMV:= CT5->CT5_DEBITO
_cCreCMV:= CT5->CT5_CREDITO
_cVlrCMV:= CT5->CT5_VLR01

dbSelectArea("SF4")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)


#IFDEF TOP
	incproc("Selecionando itens das Notas Fiscais...")
	_cquery1:=" SELECT "
	_cquery1+=" F2_DOC,F2_SERIE,F2_EMISSAO,D2_CUSTO1, SD2.R_E_C_N_O_ REG"
	_cquery1+=" FROM "
	_cquery1+=retsqlname("SD2")+" SD2 ,"
	_cquery1+=retsqlname("SF2")+" SF2 ,"
	_cquery1+=retsqlname("SF4")+" SF4"
	_cquery1+=" WHERE "
	_cquery1+="     SD2.D_E_L_E_T_<>'*'"
	_cquery1+=" AND SF2.D_E_L_E_T_<>'*'"
	_cquery1+=" AND SF4.D_E_L_E_T_<>'*'"
	_cquery1+=" AND D2_TES     = F4_CODIGO"
	_cquery1+=" AND D2_DOC     = F2_DOC"
	_cquery1+=" AND D2_SERIE   = F2_SERIE"
	_cquery1+=" AND F2_CLIENTE = D2_CLIENTE"
	_cquery1+=" AND F2_LOJA    = D2_LOJA"
	_cquery1+=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	_cquery1+=" ORDER BY 1, 2 "
	_cquery1:=changequery(_cquery1)
	
	MEMOWRITE("C:\WINDOWS\TEMP\DRCUS007.SQL",_CQUERY1)
	
	tcquery _cquery1 new alias "TMP"
	
	tcsetfield("TMP","D2_CUSTO1" ,"N",15,3)
	tcsetfield("TMP","F2_EMISSAO","D")
	
	Criatmp()
	
	procregua(5000)
	dbGotop()
	
	While !tmp->(eof())
		incproc()
		_nCmv := 0
		_cDeb :=""
		_cCre :=""
		cCondtmp := "tmp->F2_DOC+tmp->F2_SERIE=='"+TMP->F2_DOC+TMP->F2_SERIE+"'"
		//While !tmp->(eof()) .and. &cCondtmp
		SD2->(DBGOTO(tmp->reg))
		SF4->(dbseek(xFilial("SF4")+SD2->D2_TES))
		SB1->(dbseek(xFilial("SB1")+SD2->D2_COD))
		_nValor := &_cVlrCMV
		If _nValor > 0
			_cDeb := &_cDebCMV
			_cCre := &_cCreCMV
			_nCmv+= tmp->D2_CUSTO1
			//			tmp->(DbSkip())
		Endif
		// 		End
		If _nCmv > 0
			_cDeb   := If(ValType(_cDeb) == "N",AllTrim(Str(_cDeb)),_cDeb)
			_cCre   := If(ValType(_cCre) == "N",AllTrim(Str(_cCre)),_cCre)
			_cDeb   := _cDeb + space(20-len(_cDeb))			
			_cCre   := _cCre + space(20-len(_cCre))			
			If tmp1->(Dbseek(_cDeb+_cCre+DTOS(tmp->F2_EMISSAO)+tmp->F2_DOC+tmp->F2_SERIE))
				RECLOCK("TMP1",.F.)
				Replace 	tmp1->CMV        with 		tmp1->cmv+=_nCmv
			Else
				RECLOCK("TMP1",.T.)
				Replace tmp1->D2_DOC     with 		tmp->F2_DOC,;
				tmp1->D2_SERIE   with 		tmp->F2_SERIE, ;
				tmp1->D2_EMISSAO with 		tmp->F2_EMISSAO, ;
				tmp1->CMV        with 		_nCmv, ;
				tmp1->DEBITO     with			_cDeb,;
				tmp1->CREDITO    with			_cCre
			Endif
			MSUNLOCK()
			
		Endif
		tmp->(DbSkip())
	End
	
   tmp->(dbclosearea())
	
#ELSE
	
	CriaTmp()
	
	cNomArq := Criatrab(NIL,.F.)
	cKey:="D2_FILIAL+DTOS(D2_EMISSAO)+D2_DOC+D2_SERIE"
	cFiltro :="D2_FILIAL=='"+xFilial("SD2")+"'"
	cFiltro += " .and. dtos(D2_EMISSAO)>='"+dtos(mv_par01)+"'.And.dtos(D2_EMISSAO)<='"+dtos(mv_par02)+"'"
	
	IndRegua("SD2",cNomArq,cKey,,cFiltro,"Selecionando Registros...")	//"Selecionando Registros..."
	nIndex:=RetIndex("SD2")
	dbSetIndex(cNomArq+OrdBagExt())
	dbSetOrder(nIndex+1)
	procregua(SD2->(RECCOUNT()))
	dbGotop()
	
	While !SD2->(eof())
		incproc()
		_nCmv := 0
		_cDeb :=""
		_cCre :=""
		cCondSD2 := "SD2->D2_DOC+SD2->D2_SERIE=='"+SD2->D2_DOC+SD2->D2_SERIE+"'"
		While !SD2->(eof()) .and. &cCondSD2
			_nValor := &_cVlrCMV
			If _nValor > 0
				_cDeb := &_cDebCMV
				_cCre := &_cCreCMV
				_nCmv+= SD2->D2_CUSTO1
			Else
				_nValor := &_cVlrBON
				If _nValor > 0
					_cDeb   := &_cDebBON
					_cCre   := &_cCreBON
					_nCmv+= SD2->D2_CUSTO1
				Endif
			Endif
			SD2->(DbSkip())
		End
		If _nCmv > 0
			_cDeb   := If(ValType(_cDeb) == "N",AllTrim(Str(_cDeb)),_cDeb)
			_cCre   := If(ValType(_cCre) == "N",AllTrim(Str(_cCre)),_cCre)
			
			SD2->(DbSkip(-1))
			RECLOCK("TMP1",.T.)
			Replace tmp1->D2_DOC     with 		SD2->D2_DOC,;
			tmp1->D2_SERIE   with 		SD2->D2_SERIE, ;
			tmp1->D2_EMISSAO with 		SD2->D2_EMISSAO, ;
			tmp1->CMV        with 		_nCmv, ;
			tmp1->DEBITO     with			_cDeb,;
			tmp1->CREDITO    with			_cCre
			MSUNLOCK()
			SD2->(DbSkip())
		Endif
	End
	If File(cNomArq+OrdBagExt())
		Ferase(cNomArq+OrdBagExt())
	Endif
	dbSelectArea("SD2")
	RetIndex("SD2")
	Set Filter To
	dbSetOrder(1)
#ENDIF
return

Static Function CriaTmp
aCampos := {}
AADD(aCampos,{ "DEBITO"    , "C" , 20 , 0 } )
AADD(aCampos,{ "CREDITO"   , "C" , 20 , 0 } )
AADD(aCampos,{ "D2_DOC"    , "C" , 06 , 0 } )
AADD(aCampos,{ "D2_SERIE"  , "C" , 03 , 0 } )
AADD(aCampos,{ "D2_EMISSAO", "D" , 08 , 0 } )
AADD(aCampos,{ "CMV"       , "N" , 17 , 2 } )

_cnomarq1 := CriaTrab(aCampos,.T.)
_index1  := CriaTrab(NIL,.f.)

DbUseArea(.t.,,_cnomarq1,"TMP1",.f.)
IndRegua( "TMP1", _index1, "DEBITO+CREDITO+DTOS(D2_EMISSAO)+D2_DOC+D2_SERIE",,,  "Criando Arquivo de Indice..." )

Return

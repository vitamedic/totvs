#INCLUDE "VIT075.CH"
#Include "RWMAKE.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MATR650  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Notas Fiscais por Transportadora                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR650(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Verificar Indexacao Dentro de Programa (Provisoria)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes Sofridas Desde a Construcao Incial.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ Bops ³  Motivo da Alteracao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Viviani       ³09/11/98³Melhor³ Conversao Utilizando xMoeda            ³±±
±±³Viviani       ³23/12/98³18923 ³Acerto do Calculo do Valor Total da Nota³±±
±±³              ³        ³      ³para Aceitar Produto Negativo(Desconto) ³±±
±±³ Edson   M.   ³30/03/99³XXXXXX³Passar o Tamanho na SetPrint.           ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
user Function vit075()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt,titulo
LOCAL cDesc1 :=OemToAnsi(STR0001)	//"Este programa ira emitir a relacao de notas fiscais por"
LOCAL cDesc2 :=OemToAnsi(STR0002)	//"ordem de Transportadora."
LOCAL cDesc3 :=""
LOCAL CbCont,wnrel
LOCAL tamanho:="M"
LOCAL limite :=132
LOCAL cString:="SF2"

PRIVATE aReturn := { STR0003, 1,STR0004, 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="VIT075"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="MTR650"
PRIVATE cVolPict:=PesqPict("SF2","F2_VOLUME1",8)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta cabecalhos e verifica tipo de impressao                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi(STR0005)	//"Relacao das Notas Fiscais para as Transportadoras"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR650",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Da Transportadora                        ³
//³ mv_par02        	// Ate a Transportadora                     ³
//³ mv_par03        	// Da Nota                                  ³
//³ mv_par04        	// Ate a Nota                               ³
//³ mv_par05        	// Qual moeda                               ³
//³ mv_par06        	// Da Emissao                               ³
//³ mv_par07        	// Ate Emissao                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="VIT075"+Alltrim(cusername)            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey==27
	Set Filter to
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
   Return
Endif

RptStatus({|lEnd| C650Imp(@lEnd,wnRel,cString)},Titulo)

Return 

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ C650IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR650			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function C650Imp(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt,titulo
LOCAL cDesc1 :=OemToAnsi(STR0001)	//"Este programa ira emitir a relacao de notas fiscais por"
LOCAL cDesc2 :=OemToAnsi(STR0002)	//"ordem de Transportadora."
LOCAL cDesc3 :=""
LOCAL CbCont,cabec1,cabec2
LOCAL tamanho:="M"
LOCAL limite :=132
LOCAL nNumNota,nTotVol,nTotQtde,nTotPeso,nTotVal,nQuant,lContinua:=.T.
LOCAL nTamNF := TamSX3("F2_DOC")[1]
Local cCond  := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta cabecalhos e verifica tipo de impressao                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := STR0006 + " - " + GetMv("MV_MOEDA" + STR(MV_PAR05,1))//"RELACAO DAS NOTAS FISCAIS PARA AS TRANSPORTADORAS - MOEDA"
cabec1 := STR0007	//"REC.DEP  |EMPRESA N.FISCAL          VOLUME  N O M E  D O  C L I E N T E    QUANTIDADE        VALOR  MUNICIPIO        UF  PESO BRUTO "
*****      				012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*****      				0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
cabec2 := STR0008	//"DATA HORA|"

nTipo  := IIF(aReturn[4]==1,15,18)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

dbSelectArea("SF2")
cIndice := criatrab("",.f.)
cCond   := "Dtos(F2_EMISSAO)>='"+Dtos(mv_par06)+"'.And.Dtos(F2_EMISSAO)<='"+Dtos(mv_par07)+"'"
IndRegua("SF2",cIndice,"F2_FILIAL+F2_TRANSP+F2_DOC+F2_SERIE",,cCond,STR0009)		//"Selecionando Registros..."
	
dbSeek(cFilial+mv_par01,.T.)
SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. cFilial=F2_FILIAL .And. F2_TRANSP >= mv_par01 .And. F2_TRANSP <= mv_par02 .And. lContinua

/*	If AT(F2_TIPO,"DB") != 0
		DbSkip()
		Loop
	EndIf*/

	IF lEnd
		@PROW()+1,001 Psay STR0010	//"CANCELADO PELO OPERADOR"
		EXIT
	ENDIF
	IncRegua()

	IF F2_DOC < mv_par03 .OR. F2_DOC > mv_par04
		dbSkip()
		Loop
	EndIF
	li := 80
	nNumNota:=nTotVol:=nTotQtde:=nTotPeso:=nTotVal:=nQuant:=0
	cTransp := F2_TRANSP
	dbSelectArea("SA4")
	dbSeek(cFilial+cTransp)
	dbSelectArea("SF2")
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	@ li,04 Psay '|    | ' + F2_TRANSP + ' - ' + SA4->A4_NOME
	li++
	@ li,04 Psay '|    | '
	
	While !EOF() .AND. cFilial=F2_FILIAL .And. F2_TRANSP=cTransp 

		IF lEnd
			@PROW()+1,001 Psay STR0010		//"CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		IncRegua()

		IF (F2_DOC < mv_par03 .OR. F2_DOC > mv_par04) /* .Or. At(F2_TIPO,"DB") != 0*/
			dbSkip()
			Loop
		EndIF
		dbSelectArea("SD2")
		dbSetorder(3)
		dbSeek(cFilial+SF2->F2_DOC+SF2->F2_SERIE)
		cNota := SF2->F2_DOC+SF2->F2_SERIE
		While cFilial=D2_FILIAL .And. !Eof() .And. D2_DOC+D2_SERIE == cNota
			nQuant += D2_QUANT
			dbSkip()
		End

		IF li > 53
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		li++
		@ li,004 Psay '|    | '
		@ li,018 Psay Substr(cNota,1,ntamNF) +"-"+Substr(cNota,nTamNF+1,3)
		dbSelectArea("SF2")
		@ li,035 Psay F2_VOLUME1   PicTure cVolPict 
		if sf2->f2_tipo $ "BD"
	     sa2->(dbseek(cFilial+sf2->f2_cliente+sf2->f2_loja))
   	  _cnome := sa2->a2_nome
	     _munic := SUBSTR(SA2->A2_MUN,1,20)
	     _mest := SA2->A2_EST  
		else
    	  sa1->(dbseek(cFilial+sf2->f2_cliente+sf2->f2_loja))
	     _cnome := sa1->a1_nome              
	     _munic := SUBSTR(SA1->A1_MUN,1,20)
	     _mest := SA1->A1_EST
 	  endif  
		@ li,044 Psay SUBSTR(_cnome,1,25)
		dbSelectArea("SF2")
		@ li,070 Psay nQuant		PicTure tm(nQuant,11)
		@ li,083 Psay xMoeda(F2_VALBRUT,1,mv_par05,F2_EMISSAO) PicTure TM(F2_VALBRUT,12)
		@ li,096 Psay _munic
		@ li,117 Psay _mest
		@ li,122 Psay F2_PBRUTO	Picture TM(F2_PBRUTO,9)
		nNumNota++
		nTotVol += F2_VOLUME1
		nTotQtde+= nQuant
		nTotVal += F2_VALBRUT
		nTotPeso+= F2_PBRUTO
		nQuant := 0
		dbSkip()
	End
	li++
	@ li,04 Psay '|    |'
	li++
	@ li,00 Psay __PrtFatLine()
	li++
	@ li,002 Psay STR0011	//"TOTAL ------->"
	@ li,018 Psay nNumNota	PicTure '999'
	@ li,029 Psay nTotVol   PicTure cVolPict
	@ li,074 Psay nTotQtde	PicTure tm(nTotQtde,11)
	@ li,086 Psay xMoeda(nTotVal,1,mv_par05,F2_EMISSAO)	PicTure tm(nTotVal,12)
	@ li,122 Psay nTotPeso	PicTure tm(nTotPeso,9)
	li++
	@ li,00 Psay __PrtFatLine()
	dbSelectArea("SF2")
	nNumNota := 0
	nTotVol := 0
	nTotQtde := 0
	nTotVal := 0
	nTotPeso := 0
End
li:=li+2

@ li,00 psay "DATA COLETA ______/_____/_____                HORARIO: ______:______ "
li:=li+2

@ li,00 psay "PLACA: ____________________________________   MOTORISTA:______________________________   ASS.:_____________________________"


If li != 80
roda(cbcont,cbtxt)
Endif

RetIndex("SF2")
Set Filter to
fErase(cIndice+OrdBagExt())

dbSelectArea("SD2")
dbSetOrder(1)


If aReturn[5] = 1
	Set Printer TO 
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

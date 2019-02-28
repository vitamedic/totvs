/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³DRCUS008  ³ Autor ³ Edson G. Barbosa   ³ Data ³  27/06/04   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³Emitir as OP com valores de RE`s e OP`s permitindo listar   ³±±
±±³          ³somente divetgentes conforme parametro                      ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ Conferencia de custos                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#INCLUDE "rwmake.ch"
#Include "topconn.ch"

User Function vit212

Local cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2      := "de acordo com os parametros informados pelo usuario."
Local cDesc3      := "divergencias de OP."
Local cPict       := ""
Local titulo      := "CONTABILIZACAO DE OP "
Local nLin        := 80

Local Cabec1      := "OP                  PERDA        DEBITO             CREDITO           DIFERENCA"                       
Local Cabec2      := ""
Local Cabec3      := ""

Local   imprime   := .T.
Private aOrd      := {}
Private lEnd      := .F.
Private lAbortPrint  := .F.
Private CbTxt     := ""
Private limite    := 80
Private tamanho   := "P"
Private nomeprog  := "VIT212" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo     := 18
Private aReturn   := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey  := 0
Private cPerg     := "PERGVIT212"
Private cbtxt     := Space(10)
Private cbcont    := 00
Private CONTFL    := 01
Private m_pag     := 01
Private wnrel     := "VIT212" // Coloque aqui o nome do arquivo usado para impressao em disco

//Variáveis do Rodapé.
nCntImpr := 0
cRodaTxt := ''

Private cString := "SD3"

dbSelectArea("SC2")
dbSetOrder(1)


_pergsx1()
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

//titulo := Trim(titulo)+" Periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)


tmp1->(dbgotop())
_nTPer:= 0
_nTDeb:= 0
_nTCre:= 0
_nTGPer:= 0
_nTGDeb:= 0
_nTGCre:= 0
_nOP   := 0
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
	_cCond:= "tmp1->D3_OP=='"+TMP1->D3_OP+"'"
	_cOP  := TMP1->D3_OP	
	While !(TMP1->(EOF())) .and. &_cCond
		Do Case
		   Case TMP1->D3_CF == "D"
	           _nTCre+=TMP1->D3_CUSTO1						
		   Case TMP1->D3_CF == "R"
	           _nTDeb+=TMP1->D3_CUSTO1
		   Case TMP1->D3_CF == "P"
	           _nTCre+=TMP1->D3_CUSTO1
		End
		_nTPer+=TMP1->D3_PERDA
		TMP1->(dbSkip()) // Avanca o ponteiro do registro no arquivo)
	End
	If mv_par03 == 1 .or. (mv_par03==2 .and. _nTdeb <> _nTCre)
		@nLin,00  PSAY _cOP                                      
		@nLin,12 PSAY Transform(_nTper,"@E 9,999,999.99")
		@nLin,25  PSAY Transform(_nTdeb,"@E 999,999,999.99")
		@nLin,45  PSAY Transform(_nTcre,"@E 999,999,999.99")
		@nLin,65  PSAY Transform(_nTdeb-_nTcre,"@E 999,999,999.99")
		_nTGPer+=_nTPer
		_nTGCre+=_nTCre
		_nTGDeb+=_nTDeb
		
		_nTGPer+=_nTPer
		_nTPer:= 0
		_nTDeb:= 0
		_nTCre:= 0
		_nOP++
		nLin++
	Endif	
EndDo

If _nTGper+_nTGCre+_ntGDeb > 0
	nLin := nLin + 2
	@nLin,00 PSAY replicate("_",limite)
	nLin++
	@nLin,00  PSAY "TOTAL GERAL...:"
   @nLin,12  PSAY Transform(_nTGper,"@E 9,999,999.99")
	@nLin,25  PSAY Transform(_nTGdeb,"@E 999,999,999.99")
	@nLin,45  PSAY Transform(_nTGcre,"@E 999,999,999.99")
	@nLin,65  PSAY Transform(_nTGdeb-_nTGcre,"@E 999,999,999.99")
	nLin++
	@nLin,00 PSAY replicate("_",limite)
Endif
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

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Emissao de         ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Emissao Ate        ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Lista              ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03"       ,"Todos"          ,space(30),space(15),"Divergentes"    ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

static function _querys()
procregua(1)


incproc("Selecionando itens das Notas Fiscais...")
	_cquery1:=" SELECT "
	_cquery1+=" D3_OP,SUBSTR(D3_CF,1,1) D3_CF,SUM(D3_CUSTO1) D3_CUSTO1, SUM(D3_PERDA) D3_PERDA"
	_cquery1+=" FROM "
	_cquery1+=retsqlname("SD3")+" SD3 "
	_cquery1+=" WHERE "
	_cquery1+="     SD3.D_E_L_E_T_<>'*'"
	_cquery1+=" AND D3_FILIAL = '"+xfilial("SD3")+"'" 
	_cquery1+=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	_cquery1+=" AND D3_OP <> '             '"
	_cquery1+=" GROUP BY D3_OP,SUBSTR(D3_CF,1,1)"
	_cquery1+=" ORDER BY 1, 2 "


	_cquery1:=changequery(_cquery1)
	
	MEMOWRITE("C:\WINDOWS\TEMP\vit212.SQL",_CQUERY1)
	
	tcquery _cquery1 new alias "TMP1"
	
	tcsetfield("TMP1","D3_CUSTO1" ,"N",15,3)
	tcsetfield("TMP1","D3_PERDA" ,"N",15,3)
	
return


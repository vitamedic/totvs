//-------------------------------------------------------------------------------------------------------

// Este exemplo � para demonstrar a cria��o de um arquivo tempor�rio
// carregar com dados e por fim apresendar em uma MBrowse com op��o de pesquisar e visualizar dados.

//-------------------------------------------------------------------------------------------------------

#Include "Protheus.ch"
#Include "MSMGADD.CH"

#DEFINE nTRB  1
#DEFINE nIND1 2
#DEFINE nIND2 3

User Function Vit613()

Local aTRB := {}
Local aHeadMBrow := {}


cCadastro := "Cadastro de Orcamentos"
aRotina := {{"Pesquisar","AxPesqui",0,1},;
{"Incluir","ExecBlock('DEMOA',.F.)",0,3},;
{"Altera","ExecBlock('DEMOB')",0,4},;
{"Excluir","ExecBlock('DEMOC',.F.)",0,5}}
MBrowse(6, 1, 22, 75, "SA1") 
return

Private cCadastro := "Exemplo da MBrowse com arquivo tempor�rio"
Private aRotina := {}

//aTRB[1] -> Nome f�sico do arquivo
//aTRB[2] -> Nome do �ndice 1
//aTRB[3] -> Nome do �ndice 2
MsgRun("Criando estrutura e carregando dados no arquivo tempor�rio...",,{|| aTRB := FileTRB() } )

//aHeadMBrow[1] -> T�tulo
//aHeadMBrow[2] -> Campo
//aHeadMBRow[3] -> Tipo
//aHeadMBrow[4] -> Tamanho
//aHeadMBRow[5] -> Decimal
//aHeadMBrow[6] -> Picture
MsgRun("Criando coluna para MBrowse...",,{|| aHeadMBrow := HeadBrow() } )

AAdd( aRotina, { "Pesquisar", "U_MBrowPesq", 0, 1 } )
AAdd( aRotina, { "Visualizar","U_MBrowVisu", 0, 2 } )

dbSelectArea("TRB")
dbSetOrder(1)
MBrowse(,,,,"TRB",aHeadMBrow,,,,,,"","")
//Fecha a �rea
TRB->(dbCloseArea())
//Apaga o arquivo fisicamente
FErase( aTRB[ nTRB ] + GetDbExtension())
//Apaga os arquivos de �ndices fisicamente
FErase( aTRB[ nIND1 ] + OrdBagExt())
FErase( aTRB[ nIND2 ] + OrdBagExt())
Return

/*****
*
* Fun��o para criar os t�tulos do Browse (header).
*
*/
Static Function HeadBrow()
Local aHead := {}
//Campos que aparecer�o na MBrowse, como n�o � baseado no SX3 deve ser criado.
//Sequ�ncia do vetor: T�tulo, Campo, Tipo, Tamanho, Decimal, Picture
AAdd( aHead, { "Prefixo"     , {|| TRB->XA_ALIAS }   ,"C", Len( SXA->XA_ALIAS )  , 0, "" } )
AAdd( aHead, { "Ordem"       , {|| TRB->XA_ORDEM }   ,"C", Len( SXA->XA_ORDEM )  , 0, "" } )
AAdd( aHead, { "Descri��o"   , {|| TRB->XA_DESCRIC } ,"C", Len( SXA->XA_DESCRIC ), 0, "" } )
AAdd( aHead, { "Des.Espanhol", {|| TRB->XA_DESCSPA } ,"C", Len( SXA->XA_DESCSPA ), 0, "" } )
AAdd( aHead, { "Desc.Ingl�s" , {|| TRB->XA_DESCENG } ,"C", Len( SXA->XA_DESCENG ), 0, "" } )
AAdd( aHead, { "Pr�prio"     , {|| TRB->XA_PROPRI  } ,"C", Len( SXA->XA_PROPRI ) , 0, "" } )

Return( aHead )

/*****
*
* Fun��o para criar o arquivo tempor�rio e seus �ndices e gravar dados neste.
* 
*/
Static Function FileTRB()
Local aStruct := {}

Local cArqTRB := ""
Local cInd1 := ""
Local cInd2 := ""

Local nI := 0

Local nVez := SXA->( FCount() )
//Pode ser feito de duas maneiras a cria��o do arquivo tempor�rio, por�m como isto ser�
//feito com base em um arquivo que j� existe ser� mais f�cil utilizar a primeira maneira.

//Primeira maneira
aStruct := SXA->( dbStruct() )
//Segunda maneira
//AAdd( aStruct, { "XA_ALIAS"  , "C", 3, 0 } )
//AAdd( aStruct, { "XA_ORDEM"  , "C", 1, 0 } )
//AAdd( aStruct, { "XA_DESCRIC", "C",30, 0 } )
//AAdd( aStruct, { "XA_DESCSPA", "C",30, 0 } )
//AAdd( aStruct, { "XA_DESCENG", "C",30, 0 } )
//AAdd( aStruct, { "XA_PROPRI" , "C", 1, 0 } )

// Ambas as maneiras devem proceder estes comandos abaixo:
// Criar fisicamente o arquivo.
cArqTRB := CriaTrab( aStruct, .T. )
cInd1 := Left( cArqTRB, 7 ) + "1"
cInd2 := Left( cArqTRB, 7 ) + "2"
// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
dbUseArea( .T., __LocalDriver, cArqTRB, "TRB", .F., .F. )
// Criar os �ndices.
IndRegua( "TRB", cInd1, "XA_ALIAS+XA_ORDEM", , , "Criando �ndices (Prefixo + Ordem)...")
IndRegua( "TRB", cInd2, "XA_DESCRIC", , , "Criando �ndices (Descri��o)...")
// Libera os �ndices.
dbClearIndex()
// Agrega a lista dos �ndices da tabela (arquivo).
dbSetIndex( cInd1 + OrdBagExt() )
dbSetIndex( cInd2 + OrdBagExt() )

// Carregar os dados de SXA em TRB.
SXA->( dbSetOrder(1) )
SXA->( dbGoTop() )
While ! SXA->( EOF() )
  TRB->(RecLock("TRB",.T.))
  For nI := 1 To nVez
   TRB->( FieldPut( nI, SXA->(FieldGet( nI ) ) ) )
  Next nI
  TRB->(MsUnLock())
  SXA->( dbSkip() )
End
Return({cArqTRB,cInd1,cInd2})

/*****
*
* Fun��o para pesquisar dados no arquivo tempor�rio.
*
*/
User Function MBrowPesq()
local oDlgPesq, oOrdem, oChave, oBtOk, oBtCan, oBtPar
Local cOrdem
Local cChave := Space(255)
Local aOrdens := {}
Local nOrdem := 1
Local nOpcao := 0

AAdd( aOrdens, "Prefixo + Ordem" )
AAdd( aOrdens, "Descri��o" )

DEFINE MSDIALOG oDlgPesq TITLE "Pesquisa" FROM 00,00 TO 100,500 PIXEL
  @ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
  @ 020, 005 MSGET oChave VAR cChave SIZE 210,08 OF oDlgPesq PIXEL
  DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
  DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
  DEFINE SBUTTON oBtPar FROM 35,218 TYPE 5 WHEN .F. OF oDlgPesq PIXEL
ACTIVATE MSDIALOG oDlgPesq CENTER

If nOpcao == 1
  cChave := AllTrim(cChave)
  TRB->(dbSetOrder(nOrdem))
  TRB->(dbSeek(cChave))
Endif
Return

/*****
*
* Fun��o para visualizar dados do registro do arquivo tempor�rio.
*
*/
User Function MBrowVisu()
Local nI := 0
Local nRec := TRB->(RecNo())
Local nTop := 0
Local nLeft := 0
Local nBottom := 0
Local nRight := 0

Local aInfo := {}
Local aHead := {}
Local aStruct := {}
Local oDlg
Local oEnchoice

// Carregar o vetor com os t�tulos dos campos.
aHead := HeadBrow()
// Buscar a estrutura da �rea de trabalho.
aStruct := TRB->( dbStruct() )
// Montar os SAY e GET da Enchoice.
For nI := 1 To Len( aHead ) //Len( aStruct )
  ADD FIELD aInfo TITULO aHead[nI,1] CAMPO aStruct[nI,1] TIPO aStruct[nI,2] TAMANHO aStruct[nI,3] DECIMAL aStruct[nI,4] NIVEL 1
  cField := aInfo[nI][2]
  M->&(cField) := TRB->&(cField)
Next nI
// Definir as coordenadas para a janela.
If SetMDIChild()
  oMainWnd:ReadClientCoors()
  nTop := 40
  nLeft := 30
  nBottom := oMainWnd:nBottom-80
  nRight := oMainWnd:nRight-70 
Else
  nTop := 135
  nLeft := 0
  nBottom := TranslateBottom(.T.,28)
  nRight := 632
Endif
// Apresentar os dados para visualiza��o no objeto.
DEFINE MSDIALOG oDlg TITLE cCadastro FROM nTop,nLeft TO nBottom,nRight PIXEL
  oEnchoice := MsMGet():New("TRB",nRec,2,,,,,{0,0,0,0},,,,,,oDlg,,,.F.,,,,aInfo)
  oEnchoice:oBox:Align := CONTROL_ALIGN_ALLCLIENT
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() }, {|| oDlg:End() })
Return

//Read more: http://www.blacktdn.com.br/2012/05/e-ai-galera-beleza-entao.html#ixzz4jWzacgkj

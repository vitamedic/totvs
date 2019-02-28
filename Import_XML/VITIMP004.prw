#include 'Protheus.ch'
#include 'TOPConn.ch'
#include 'Rwmake.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"
#define ENTER Chr(13)+Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |ACOMP004    ³Autor ³ Totvs                       |Data ³ 28/11/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Esse arquivo contém funçoes responsáveis pelo funcionamento da   ³±±
±±³          | opção de importação de XML de Nota Fiscal Eletronica             ³±±
±±³			 |                                                  				³±±
±±³			 | ATENCAO: NA SA5 DEVERA SER ACRESCENTADO O CODIGO DO FORNCEDOR	³±±
±±³			 |       SENAO GERA ERRO DE DUPLICIDADE                				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³  Nil                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

/*/{Protheus.doc} VITIMP004
//TODO Descrição auto-gerada.
@author andre.alves
@since 13/09/2018
@version 1.0
@return Esse arquivo contém funçoes responsáveis pelo funcionamento da opção de importação de XML de Nota Fiscal Eletronica 
@return ATENCAO: NA SA5 DEVERA SER ACRESCENTADO O CODIGO DO FORNCEDOR
@return SENAO GERA ERRO DE DUPLICIDADE 
@type function
/*/
User Function VITIM004()
Local clPar     := "MTA140I"
Local cIniFile	:= GetADV97()

Private cStartPath 	:= alltrim( GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile ) ) //start path
Private cStartLido	:= alltrim(cStartPath)  + iif(IsSrvUnix(),'xml/inbox','xml\inbox') //arquivos de entrada
Private cStartError	:= alltrim(cStartPath)  + iif(IsSrvUnix(),'xml/erro','xml\erro') //path dos erros
Private cStartBKP	:= alltrim(cStartPath)  + iif(IsSrvUnix(),'xml/backup','xml\backup') //path dos backup

//Validação da Empresa INICIO NOME DA EMPRESA LOGADA
cCNPJ := alltrim(SM0->M0_CGC)
if !U_ALIBE001('000003 - IMPORTACAO XML',cCNPJ,"Processo de Importação de XML!")
	Return
endif
	
//CRIA DIRETORIOS
MakeDir( cStartPath + iif(IsSrvUnix(),'xml','xml') )
MakeDir( cStartLido )       // CRIA DIRETOTIO ENTRADA
MakeDir( cStartError )		// CRIA DIRETORIO ERRO
MakeDir( cStartBKP )		// CRIA DIRETORIO BACKUP

ajustasx1()

if Pergunte(clPar,.T.,"")
	MsgRun(("Aguarde..."+Space(1)+"Criando Interface"),"Aguarde...",{|| MontaBrw() } )
endif

//Restaura grupo de perguntas da rotina MATA140.
Pergunte("MTA140",.F.)
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | SelCor     ³Autor  ³Totvs            ³Data  ³30/01/12      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o |Funcao retorna objeto com cor do farol                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³clStatus = Status do registro (SDT->DT_STATUS)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³olCor = LoadBitmap(GetResources(),'COR')                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³	MontaBrw                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function SelCor(clStatus)
Local olCor := NIL

Do Case
	// STATUS = PROCESSADA PELO PROTHEUS
	Case clStatus == 'P'
		olCor:=LoadBitmap(GetResources(),'BR_VERMELHO')
	Case clStatus == 'R' //REJEITADO NA RECEITA
		olCor:=LoadBitmap(GetResources(),'BR_PRETO')
		// STATUS = LIBERADO PARA PRE-NOTA
	OtherWise
		olCor:=LoadBitmap(GetResources(),'BR_VERDE')
EndCase
Return olCor

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ otesteW
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | MontHdr    ³Autor  ³Totvs            |Data  ³30/01/12      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o |Funcao monta o aHeader do browse principal com os itens da SDS    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alHdRet = Array com o nome dos campos selecionados no dicionario ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MontaBrw	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function MontHdr()
Local alHdRet := {}

aAdd(alHdRet,"DS_STATUS")

SX3->( DbSetOrder(1) )
SX3->( DbSeek("SDS") )
While !SX3->( EOF() ) .and. SX3->X3_ARQUIVO == "SDS"
	
	If (SX3->X3_BROWSE=="S") .and. (cNivel>=SX3->X3_NIVEL) .and. (!(ALLTRIM(SX3->X3_CAMPO) $ "DS_FILIAL/DS_STATUS"))
		Aadd(alHdRet,SX3->X3_CAMPO)
	EndIf
	SX3->( DbSkip() )
	
EndDo
aAdd(alHdRet,"DS_CHAVENF")
aAdd(alHdRet,"")
aIns(alHdRet,4)
alHdRet[4] := "DS_EMISSA"
Return alHdRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | CarItens(alHdr,alParam)³Autor|Totvs         |Data³ 30/01/12³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o | Funcao verifica os itens a carregar no browse perante os campos  ³±±
±±³          | e parametro.							                            ³±±
±±³          | Adciona os registro em um array (alRet) que e usado como retorno ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³alHdr   := Array com os campos do browse                          ³±±
±±³          |alParam := Array com os possiveis parametros, sendo as posicoes   ³±±
±±³          | [1]-{1 , " " } // 1 - Liberado para pre-nota      			    ³±±
±±³          | [2]-{2 , "P" } // 2 - Processada pelo Protheus				    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alRet = Array contendo os registros                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AtuBrw	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function CarItens(alHdr,alParam)
Local alRet     := {}
Local cArqInd   := ""
Local cChaveInd := ""
Local cQuery	:= ""
Local nlK       := 0
Local nIndice	:= 0

Pergunte("MTA140I",.f.)

dbSelectArea("SDS")
SDS->( dbSetOrder(1) )

cArqInd   := CriaTrab(, .F.)
//cChaveInd := SDS->( IndexKey() )
cChaveInd := "DS_FILIAL,DS_EMISSA,DS_FORNEC,DS_DOC,DS_SERIE"

cQuery := 'DS_FILIAL ="'+xFilial("SDS")+'" .And.'
cQuery += 'DS_DOC     >="' + mv_par01 +'" .And. DS_DOC     <="' + mv_par02 +'" .And. '
cQuery += 'DS_SERIE   >="' + mv_par03 +'" .And. DS_SERIE   <="' + mv_par04 +'" .And. '
cQuery += 'DS_FORNEC  >="' + mv_par05 +'" .And. DS_FORNEC  <="' + mv_par06 +'" '

if !Empty(mv_par07) .and. !Empty(mv_par08)
	cQuery += ' .and. dtos(DS_EMISSA) >="' + dtos(mv_par07) +'" .And. dtos(DS_EMISSA)  <="' + dtos(mv_par08) +'"  '
endif

if !Empty(mv_par09) .and. !Empty(mv_par10)
	cQuery += ' .and. dtos(DS_DATAIMP) >="' + dtos(mv_par09) +'" .And. dtos(DS_DATAIMP) <="' + dtos(mv_par10) +'" '
endif

if MV_PAR11 == 2 //Filtra
	cQuery += " .and. (DS_STATUS == ' ' .or. DS_STATUS == 'R') "
endif

//cQuery += " ORDER BY DS_EMISSA "

IndRegua("SDS", cArqInd, cChaveInd, , cQuery,"Criando indice de trabalho" ) //"Criando indice de trabalho"

nIndice := RetIndex("SDS") + 1
#IFNDEF TOP
	SDS->( dbSetIndex(cArqInd + OrdBagExt()) )
#ENDIF

SDS->( dbSetOrder(nIndice) )
SDS->( MsSeek(xFilial("SDS")) )

while !SDS->( Eof() )
	
	AADD(alRet,Array(Len(alHdr)))
	
	For nlk:=1 to Len(alHdr)
		If alHdr[nlk,4]=="V"
			alRet[Len(alRet),nlk]:=CriaVar(alHdr[nlk,2])
		Else
			alRet[Len(alRet),nlk]:=FieldGet(FieldPos(alHdr[nlk,2]))
		EndIf
	Next nlk
	SDS->( dbSKip() )
	
enddo

SDS->( DbClearFil() )
RetIndex("SDS")
Return alRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | MontaBrw   ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Monta o Browse principal que exibi os schemas importados         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clRaiz = Diretorio/Local arquivos raiz                           ³±±
±±³          | clDest = Diretorio/Local arquivos lidos                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ A140XMLNFe	                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function MontaBrw()
Local alSize    	:= MsAdvSize()
Local alHdCps 		:= {}
Local alHdSize      := {}
Local alCpos        := {}
Local alItBx        := {}
Local alParam       := {}
Local alCpHd        := MontHdr()
Local clLine        := ""
Local clLegenda     := ""
Local clFilBrw 		:= ""
Local cTCFilterEX	:= "TCFilterEX"
Local nlTl1     	:= alSize[1]
Local nlTl2    		:= alSize[2]
Local nlTl3    		:= alSize[1]+450
Local nlTl4     	:= alSize[2]+790
Local nlCont        := 0
Local nlPosCFor     := 0
Local nlPosLoja     := 0
Local nlPosNum      := 0
Local nlPosSer      := 0
Local nlPosCHNF		:= 0
Local olLBox    	:= NIL
Local olBtLeg       := NIL
Local olBtFiltro    := NIL
Local olBtImpM		:= NIL
Local oChkBoxClass
Local oGetChvNfe
Local cGetChvNfe := space( len(SF2->F2_CHVNFE) )
Local oSayChvNFe

Private _opDlgPcp	:= NIL
Private opBtVis     := NIL
Private opBtImp     := NIL
Private opBtPed     := NIL
Private opBtEst		:= NIL
Private cIdEnt
Private cNivelUser	:= GetNewPar("MV_XNVCLAS",1)
Private lChkBoxClass

if cNivelUser <= cNivel
	lChkBoxClass := SuperGetMV("MV_XCLASS",.F.,.T.)
else
	lChkBoxClass := .F.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array alParam recebe parametros para filtro           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(alParam,{1 , " " }) // 1 - Liberado para pre-nota
aAdd(alParam,{2 , "P" }) // 2 - Processada pelo Protheus

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Header com os titulos do TWBrowse             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX3->( dbSetOrder(2) )
For nlCont	:= 1 to Len(alCpHd)
	
	If SX3->( MsSeek(alCpHd[nlCont]) )
		
		If alCpHd[nlCont] == "DS_STATUS"
			AADD(alHdCps," ")
			AADD(alHdSize,1)
		Else
			AADD(alHdCps,AllTrim(X3Titulo()))
			AADD(alHdSize,Iif(nlCont==1,200,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo())))
		EndIf
		AADD(alCpos,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
		
	EndIf
	
Next nlCont

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as posicoes/ordens dos campos no array       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nlPosCFor := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_FORNEC"})
nlPosLoja := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_LOJA"})
nlPosNum  := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_DOC"})
nlPosSer  := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_SERIE"})
nlPosCHNF := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_CHAVENF"})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Colunas da ListBox/TWBrowse                                				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
clLine := "{|| {SelCor(alItBx[olLBox:nAt,1]) ,"
For nlCont:=2 To Len(alCpos)
	If AllTrim(alCpos[nlCont][2]) $ ("DS_CNPJ/DS_HORAEMI")
		clLine += "Transform(alItBx[olLBox:nAt,"+AllTrim(Str(nlCont))+"], '"+AllTrim(alCpos[nlCont][5])+"')"+IIf(nlCont<Len(alCpos),",","")
	Else	
		clLine += "alItBx[olLBox:nAt,"+AllTrim(Str(nlCont))+"]"+IIf(nlCont<Len(alCpos),",","")
	EndIf	
Next nX
clLine += "}}"


// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | Monta Legenda  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
clLegenda := "BrwLegenda('Nf-e Disponíveis','Legenda' ,{{'BR_VERDE'    ,'Apto a gerar Pré nota'}";
+" ,{'BR_VERMELHO' ,'Documento Gerado'}";
+" ,{'BR_PRETO' ,'Cancelado Receita'}";
+" })"

//cIdEnt := GetIdEnt()
cIdEnt := U_VITIM006()

nlTl1 := 0.00
nlTl2 := 0.00
nlTl3 := 500
nlTl4 := 1200

DEFINE MSDIALOG _opDlgPcp TITLE "Nf-e Disponíveis" From nlTl1,nlTl2 to nlTl3,nlTl4 PIXEL

// Label Vincular Pedido de Compra / Gerar Pré-Nota
@ nlTl1+198,alSize[2]+005 To nlTl1+230,alSize[2] + 175 LABEL " Vincular Pedido de Compra / Gerar Pré-Nota " OF _opDlgPcp PIXEL

// Importação do XML
@ nlTl1+198,alSize[2]+180 To nlTl1+230,alSize[2] + 460 LABEL " Importação do XML " OF _opDlgPcp PIXEL

// ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  BOTOES    |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Selec. Pedido
opBtPed := TButton():New(nlTl1+210,alSize[2]+010,"Pedido de Compra",_opDlgPcp,{|| SelePed(	alItBx[olLBox:nAt,nlPosCFor] ,;		// | Cod. Fornecedor
alItBx[olLBox:nAt,nlPosLoja] ,;			// | Loja
alItBx[olLBox:nAt,nlPosNum ] ,;			// | Numero Doc.
alItBx[olLBox:nAt,nlPosSer])} ;			// | Serie
,050,014,,,,.T.  )

// Gerar Pre Nota
opBtImp := TButton():New(nlTl1+210,alSize[2]+065,"Gerar Pre Nota",_opDlgPcp,{|| (ExecTela(	3, ;								// | Opcao
alItBx[olLBox:nAt,nlPosCFor],;     		// | Cod. Fornec./Cli.
alItBx[olLBox:nAt,nlPosLoja],;   		// | Loja
alItBx[olLBox:nAt,nlPosNum],;    	   	// | Num. Nota Fiscal
alItBx[olLBox:nAt,nlPosSer]) ,; 		// | Serie
(olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)),;
(olLBox:Refresh()),(olLBox:bGoTop),;
(Iif(!Empty(olLBox:aArray),AtuBtn(olLBox:aArray[olLBox:nAt,1]),)))};
,050,014,,,,.T.  )

// Excluir Pre Nota (Estornar)
opBtEst := TButton():New(nlTl1+210,alSize[2]+120,"Estornar",_opDlgPcp,{|| (ExclDocEntrada(olLBox,alCpos),(olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)),(olLBox:Refresh()),(olLBox:bGoTop),(Iif(!Empty(olLBox:aArray),AtuBtn(olLBox:aArray[olLBox:nAt,1]),)))},050,014,,,,.T.  )

//  Importa XML via SEFAZ
//@ (nlTl1+210),alSize[2]+185 BUTTON "DownLoad XML" SIZE 50,14 OF _opDlgPcp PIXEL ACTION DownLoadXML()

// Importação manual
olBtImpM := TButton():New(nlTl1+210,alSize[2]+240,"Imp. Manual",_opDlgPcp, {|| ImpManual(),(olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)) } ,050,014,,,,.T.  )

//  Consulta NF-e
@ (nlTl1+210),(alSize[2]+295) BUTTON "Cons.NFE" SIZE 050,14 OF _opDlgPcp PIXEL ACTION (iif(!Empty(olLBox:aArray),ConsNFeChave(alItBx[olLBox:nAt,nlPosCHNF],cIdEnt),))

//  Consulta Amarração
@ (nlTl1+210),(alSize[2]+350) BUTTON "Cons.Amar" SIZE 050,14 OF _opDlgPcp PIXEL ACTION MATA060()//MATA370()

// Atualizar tela
olBtLeg := TButton():New(nlTl1+210,alSize[2]+405,"Atualizar Tela",_opDlgPcp, {|| (olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)) } ,050,014,,,,.T.  )

// Visualizar
opBtVis := TButton():New(nlTl1+200,alSize[2]+465,"Visualizar",_opDlgPcp,{|| (ExecTela(	2,; 								// | Opcao
alItBx[olLBox:nAt,nlPosCFor],;			// | Cod. Fornec./Cli.
alItBx[olLBox:nAt,nlPosLoja],;	  		// | Loja
alItBx[olLBox:nAt,nlPosNum],;	   		// | Num. Nota Fiscal
alItBx[olLBox:nAt,nlPosSer])   ) };		// | Serie
,060,014,,,,.T.  )

// Filtro
olBtFiltro := TButton():New(nlTl1+200,alSize[2]+535,"Filtrar",_opDlgPcp, {|| FiltraBrw(olLBox,alItBx,clLine,alCpos,alParam, @clFilBrw) } ,060,014,,,,.T.  )

// Legenda
olBtLeg := TButton():New(nlTl1+218,alSize[2]+465,"Legenda",_opDlgPcp, {|| &clLegenda } ,060,014,,,,.T.  )

// Sair / Fechar
@ (nlTl1+218),(alSize[2]+535) BUTTON "Sair" SIZE 60,14 OF _opDlgPcp PIXEL ACTION Eval({|| DbSelectArea("SDS"), &cTCFilterEX.("",1), _opDlgPcp:END()})

// Auto Classificação Pré-Nota
if cNivelUser <= cNivel
	@ (nlTl1+235), alSize[2]+005 CHECKBOX oChkBoxClass VAR lChkBoxClass PROMPT "Classifica NF-e?" SIZE 050, 015 OF _opDlgPcp COLORS 0, 16777215 MESSAGE "Permite classificar, após geração da Pré-Nota" PIXEL
endif

//Consulta Rápida da Chave / Numero do Documento
@ (nlTl1+235), alSize[2]+180 SAY oSayChvNFe PROMPT "Filtrar pela Chave NF-e:" 	SIZE 070, 007 OF _opDlgPcp COLORS 0, 16777215 PIXEL
@ (nlTl1+233), alSize[2]+240 MSGET oGetChvNfe VAR cGetChvNfe 		SIZE 171, 010 OF _opDlgPcp PICTURE "@X" VALID vChvNfe(@cGetChvNFe,olLBox,alItBx,clLine,alCpos,alParam, @clFilBrw) COLORS 0, 16777215 PIXEL

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | TW BROWSE - NOTAS  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
&cTCFilterEX.("",1)
olLBox := TwBrowse():New(nlTl1+05,nlTl2+05,nlTl3+093,nlTl4-1010,,alHdCps,alHdSize,_opDlgPcp,,,,,{|| Iif(!Empty(olLBox:aArray),Eval(opBtVis:BACTION),) } ,,,,,,,.F.,,.T.,,.F.,,,)
olLBox := AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
olLBox:BChange:= Iif(!Empty(olLBox:aArray), {|| AtuBtn(olLBox:aArray[olLBox:nAt,1]) } , {|| olLBox:Refresh()  } )

ACTIVATE DIALOG _opDlgPcp CENTERED

Return NIL



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | ImpManual  ³Autor ³ Totvs 				   |Data ³ 30/01/12     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Realiza a importacao manual do arquivo selecionado pelo usuario  ³±±
±±³          | utilizando a rotina automatica de importacao da NF-e		        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MontaBrw		                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function ImpManual()  

Local cPathR := cGetFile("*.xml","XML File",1,"C:\",.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.,.T.)
Local cFile  := cPathR
Local cIniFile	:= GetADV97()

If !Empty(cPathR)
	
	while At("\",cFile) > 0
		cFile := Substr(cFile,At("\",cFile)+1)
	enddo
	
	if !":\" $ cPathR //-- Arquivo do servidor
		Copy File &(cPathR) TO &(/*cDestFile*/cStartLido + iif(IsSrvUnix(),"/", "\") + cFile)
	else //-- Arquivo do client
		CpyT2S(cPathR,/*cDestFile*/cStartLido + iif(IsSrvUnix(),"/", "\"))
	endif
	
	cStartLido := /*cDestFile*/cStartLido
	
	//-- Chama funcao de import
	MsAguarde({|| U_VITIM005()(cFile,.F.)},"Aguarde","Importando dados do arquivo XML...",.F.)
	
EndIf
Return( Nil )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | FiltraBrw  ³Autor ³Totvs                  |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Atualiza botoes na mudanca de registro. Se o status for          ³±±
±±³          | P = Processada Desabilita os botoes de Selecionar Pedido, 		³±±
±±³			 | Ver. Schema e Importar.											³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clStatus = Status do registro selecioado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MontaBrw	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function FiltraBrw(olLBox,alItBx,clLine,alCpos,alParam,clFilBrw )
Local cTCFilterEX 	:= "TCFilterEX"
Local aArea			:= GetArea()

clFilBrw := BuildExpr("SDS",,clFilBrw)

DbSelectArea("SDS")
&cTCFilterEX.(clFilBrw,1)

AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)

RestArea(aArea)
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | AtuBtn     ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Atualiza botoes na mudanca de registro. Se o status for          ³±±
±±³          | P = Processada Desabilita os botoes de Selecionar Pedido, 		³±±
±±³			 | Ver. Schema e Importar.											³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clStatus = Status do registro selecioado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MontaBrw	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function AtuBtn(clStatus)

If (clStatus$"P")
	opBtPed:Disable()
	opBtImp:Disable()
	//opBtEst:Enable()
Else
	opBtPed:Enable()
	opBtImp:Enable()
	//opBtEst:Disable()
EndIf
Return Nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | AtuBrw     ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Atualiza a tela apos gerar pre nota                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ olLBox  = Objeto do TwBrowse (ListBOx)                           ³±±
±±³          | alItBx  = Array contendo os itens do ListBox                     ³±±
±±³          | clLine  = String do BLoco de Codigo bLine                        ³±±
±±³          | alCpos  = Campos exibidos no ListBox                             ³±±
±±³          | alParam = Array com informacoes do filtro                        ³±±
±±³          |           [ 1 ] - Parametro escolhido                            ³±±
±±³          |           [ 2 ] - String para sua representacao Exemplo: "T"     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ olLBox = ListBox atualizado                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FiltraBrw, MontaBrw                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o array com as informacoes dos registros      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
alItBx := CarItens(alCpos, alParam)
olLBox:SetArray(alItBx)
olLBox:bLine := Iif(!Empty(alItBx),&clLine, {|| Array(Len(alCpos))} )
If EmpTy(olLBox:aArray)
	opBtPed:Disable()
	opBtVis:Disable()
	opBtImp:Disable()
else
	opBtPed:Enable()
	opBtVis:Enable()
	opBtImp:Enable()
EndIf
Return olLBox

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | SelePed    ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Monta tela para selecao do pedido de compra                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor  = Cod. Fornec./Cli.                                    ³±±
±±³          | clLoja    = Loja                                                 ³±±
±±³          | clNota    = Num. Nota                                            ³±±
±±³          | clSerie   = Serie da Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MontaBrw	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function SelePed(clCodFor,clLoja,clNota,clSerie)

Local oBtnPed
Local oBtnProd
Local oBtnOk
Local oLegenda1
Local oLegenda2
Local olFont := TFont ():New(,,-11,.T.,.T.,5,.T.,5,.F.,.F.)
Private oDlgAmarra

SDS->( DbSetOrder(1) )
if SDS->( dbSeek(xFilial("SDS")+clNota+clSerie+clCodFor+clLoja) )
	
	If SDS->DS_TIPO <> 'N'
		Aviso("Atenção","Tipo de Nota Fiscal não permitida",{"Ok"})
		Return()
	EndIf
	
else
	Aviso("Atenção","XML não encontrato!",{"Ok"})
	Return()
endif

DEFINE DIALOG oDlgAmarra TITLE " Amarração dos itens da NFe " FROM 0,0 TO 407,721 PIXEL STYLE DS_MODALFRAME

oDlgAmarra:lEscClose := .F.
oGet1 := MsNewoGet1(clCodFor,clLoja,clNota,clSerie)
@ 005,005 TO 35,358 LABEL "" OF oDlgAmarra PIXEL
@ 010,010 Say "Nota Fiscal: " + clNota Font olFont Pixel Of oDlgAmarra
@ 010,100 Say "Serie: " + clSerie Font olFont Pixel Of oDlgAmarra
@ 025,010 Say "Fornecedor: " + clCodFor + " - " + Posicione("SA2",1,(xFilial("SA2") + clCodFor + clLoja ),"A2_NOME") Font olFont Pixel Of oDlgAmarra
@ 008,245 TO 32,355 LABEL "" OF oDlgAmarra PIXEL
@ 012,250 BITMAP oLegenda1 ResName "BR_VERDE" OF oDlgAmarra Size 10,10 NoBorder When .F. Pixel
@ 012,260 Say "NÃO TEM PEDIDO DE COMPRA" Font olFont Pixel Of oDlgAmarra
@ 021,250 BITMAP oLegenda1 ResName "BR_VERMELHO" OF oDlgAmarra Size 10,10 NoBorder When .F. Pixel
@ 021,260 Say "TEM PEDIDO DE COMPRA" Font olFont Pixel Of oDlgAmarra
@ 185,005 BUTTON oBtnPed PROMPT "Pedidos de Compra" SIZE 080, 015 OF oDlgAmarra PIXEL ACTION (MsgRun("Aguarde!","Selecionando Registros..." ,{|| ProcPCxNFe(clCodFor,clLoja,clNota,clSerie,oGet1:ACOLS,oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})], SDS->DS_TIPO)}) )

@ 185,090 BUTTON oBtnProd PROMPT "Produto X Fornecedor" SIZE 080, 015 OF oDlgAmarra PIXEL ACTION ( Iif(Aviso("Deseja desfazer a amarraÇâo Prod x Prod.Fornec.?",("Ao clicar em <SIM> "+CRLF+"a seleção do pedido será excluída"),{"Sim","Nâo"}) == 1 , ;
(DelSDV(clCodFor+clLoja+clNota+clSerie+oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]) , ;
alRetRef:=RPrdxPrdF(clCodFor,clLoja,clNota,clSerie,oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_PRODFOR"})],,SDS->DS_TIPO,oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})] ) , ;
oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_COD"})] := alRetRef[1] , oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="B1_DESC"})] := alRetRef[2] , ;
GPrdxPrdF(clCodFor,clLoja,clNota,clSerie,oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_PRODFOR"})],oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_COD"})],SDS->DS_TIPO,oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]) , ;
oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_PEDIDO"})] := "" , ;
oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_ITEMPC"})] := "" , ;
oGet1:ACOLS[oGet1:NAT][1] := "BR_VERDE" , ;
oGet1:oBrowse:Refresh() ) , ) )

@ 185,318 BUTTON oBtnOk PROMPT "Fechar" SIZE 040, 015 OF oDlgAmarra PIXEL ACTION (oDlgAmarra:End())

ACTIVATE DIALOG oDlgAmarra CENTERED

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    | MsNewoGet1  ³Autor ³ Totvs              		   |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Cria o MsNewGetDados dos itens da NFe		                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor  = Cod. Fornec./Cli.                                    ³±±
±±³          | clLoja    = Loja                                                 ³±±
±±³          | clNota    = Num. Nota                                            ³±±
±±³          | clSerie   = Serie da Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SelePed	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function MsNewoGet1(clCodFor,clLoja,clNota,clSerie)

Local nX
Local aHeaderEx 	:= {}
Local aColsEx 		:= {}
Local aFieldFill 	:= {}
Local aFields 		:= {"","DT_ITEM","DT_PEDIDO","DT_ITEMPC","DT_COD","DT_PRODFOR","B1_DESC"}
Local aAlterFields 	:= {}
Local cQuery   		:= ""
Local cPulaLinha	:= chr(13)+chr(10)

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		DO CASE
			CASE NX == 1
				Aadd(aHeaderEx,{'','LEGENDA','@BMP',1,0,'','€€€€€€€€€€€€€€','C','','','',''})
			OTHERWISE
				Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		ENDCASE
	Endif
Next nX

cQuery := " SELECT " 																	+ cPulaLinha
cQuery += " SDT.DT_ITEM ITEM, "                                                 		+ cPulaLinha
cQuery += " SDT.DT_COD PROD_SISTEMA, "                                             		+ cPulaLinha
cQuery += " SDT.DT_PRODFOR PROD_FORNECE, "                                     			+ cPulaLinha
cQuery += " SDT.DT_DESCFOR DESC_FORNECE, "                                     			+ cPulaLinha
cQuery += " SDT.DT_PEDIDO PEDIDO, "         	                            			+ cPulaLinha
cQuery += " SDT.DT_ITEMPC ITEM_PEDIDO, "	                                   			+ cPulaLinha
cQuery += " SB1.B1_DESC DESC_SISTEMA "                                            		+ cPulaLinha
cQuery += " FROM " + RetSqlName("SDT") + " SDT"                                   		+ cPulaLinha
cQuery += " LEFT JOIN " + RetSqlName("SB1") + " SB1 "                              		+ cPulaLinha
cQuery += " ON SB1.B1_COD = SDT.DT_COD "                                           		+ cPulaLinha
cQuery += " AND SB1.D_E_L_E_T_ <> '*' "                                            		+ cPulaLinha
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "'"                           	+ cPulaLinha
cQuery += " WHERE SDT.D_E_L_E_T_ <> '*' "                                        		+ cPulaLinha
cQuery += " AND SDT.DT_FILIAL 	= '" + xFilial('SDT') + "'"                         	+ cPulaLinha
cQuery += " AND SDT.DT_FORNEC 	= '" + PadR(clCodFor,TamSx3("DT_FORNEC")[1]) + "'"		+ cPulaLinha
cQuery += " AND SDT.DT_LOJA 	= '" + PadR(clLoja,TamSx3("DT_LOJA")[1]) + "'"   		+ cPulaLinha
cQuery += " AND SDT.DT_DOC 		= '" + PadR(clNota,TamSx3("DT_DOC")[1]) + "'"     		+ cPulaLinha
cQuery += " AND SDT.DT_SERIE 	= '" + PadR(clSerie,TamSx3("DT_SERIE")[1]) + "'"    	+ cPulaLinha
cQuery += " ORDER BY SDT.DT_ITEM , SDT.DT_COD"                               			+ cPulaLinha

cQuery := ChangeQuery(cQuery)
TcQuery cQuery New Alias "QRYSDT" // Cria uma nova area com o resultado do query

While  QRYSDT->(!Eof())
	
	aFieldFill 	:= {}
	aAdd(aFieldFill , iif(Empty(QRYSDT->PEDIDO),"BR_VERDE","BR_VERMELHO")	)
	aAdd(aFieldFill , QRYSDT->ITEM 	 										)
	aAdd(aFieldFill , QRYSDT->PEDIDO										)
	aAdd(aFieldFill , QRYSDT->ITEM_PEDIDO									)
	aAdd(aFieldFill , QRYSDT->PROD_SISTEMA 									)
	aAdd(aFieldFill , QRYSDT->PROD_FORNECE 							   		)
	aAdd(aFieldFill , iif( Empty(QRYSDT->DESC_SISTEMA) , QRYSDT->DESC_FORNECE , QRYSDT->DESC_SISTEMA))
	Aadd(aFieldFill , .F.)
	Aadd(aColsEx, aFieldFill)
	
	QRYSDT->( DbSkip() )
	
EndDo

QRYSDT->(DbCloseArea())

if Empty(aColsEx)
	Aadd(aColsEx, {"","","","","","","",.F.})
endif

Return MsNewGetDados():New( 040 ,  005 , 180 , 358 , GD_UPDATE , "AllwaysTrue" , "AllwaysTrue" , "" , aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgAmarra, aHeaderEx, aColsEx)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | DelSDV     ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Deleta os registros na tabela de relação de pedidos quando o     ³±±
±±³          | amarracao do produto e' desfeita                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clChave  = Forn.+Loja+Nota+Serie.                                ³±±
±±³          ³ clProd   = Codigo do produto                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SelePed                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function DelSDV(clChave)
Local alArea := GetArea()

SDV->( dbSetOrder(1) )
SDV->( dbSeek(xFilial("SDV")+clChave) )

While SDV->(!EOF()) .AND. SDV->DV_FILIAL == xFilial("SDV") .AND. (clChave == (SDV->DV_FORNEC+SDV->DV_LOJA+SDV->DV_DOC+SDV->DV_SERIE+SDV->DV_ITEMXML))
	If  RecLock("SDV",.F.)
		SDV->(DbDelete())
		SDV->( DbUnLock() )
	EndIf
	SDV->(dbSkip())
EndDo
RestArea(alArea)
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | RPrdxPrdF  ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Refaz a amarracao de produto X prod. fornecedor                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor  = Cod. Fornec./Cli.                                    ³±±
±±³          | clLoja    = Loja                                                 ³±±
±±³          | clNota    = Num. Nota                                            ³±±
±±³          | clSerie   = Serie da Nota                                        ³±±
±±³          | clProdFor = cod. produto identificacao do fornecedor / cliente   ³±±
±±³          | clPar     = NIL                                                  ³±±
±±³          | cTipo     = Tipo da nota - Entrada ou devolucao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alRet  = [1] - Cod. produto  / [2] - Descricao do produto        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SelePed                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function RPrdxPrdF(clCodFor,clLoja,clNota,clSerie,clProdFor,clPar,cTipo,cItem)

Local llRetCons := .F.
Local alRet     := {"",""}
Local alArea    := GetArea()

If (llRetCons:=ConPad1(,,,"SB1",,,.F.)) // Consulta Padrao 

	alRet[1] := SB1->B1_COD
	alRet[2] := SB1->B1_DESC
	
 	if SDS->DS_TIPO != "N" // sangelles 13/11/2013 
 	
 		// Verifica se existe amarração com o antigo produto, se existir deleta
 		SA7->(DbSetOrder(1))
    	if SA7->(Dbseek(xFilial("SA7") + clCodFor + clLoja + oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_COD"})]))					
			RecLock("SA7",.F.) // Se achar altera
			SA7->(DbDelete())
			SA7->(MsUnLock())
		endif
		
		// se já existir amarração com o novo produto informado faço alteração, senão, incluo novo registro
		if !SA7->(Dbseek(xFilial("SA7") + clCodFor + clLoja + alRet[1]))					
			RecLock("SA7",.T.) //Se não achar inclui
		else
			RecLock("SA7",.F.) //Se achar altera
		endif  
   
		SA7->A7_FILIAL 	:= xFilial("SA7")
		SA7->A7_CLIENTE	:= clCodFor
		SA7->A7_LOJA 	:= clLoja
		SA7->A7_CODCLI  := oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_PRODFOR"})]
		SA7->A7_PRODUTO := alRet[1]
		SA7->(MsUnlock())
				
   else  
   
   		// Verifica se existe amarração com o antigo produto, se existir deleta
 		SA5->(DbSetOrder(1))
    	if SA5->(Dbseek(xFilial("SA5") + clCodFor + clLoja + oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_COD"})]))					
			RecLock("SA5",.F.) // Se achar altera
			SA5->(DbDelete())
			SA5->(MsUnLock())
		endif
	    
		if !SA5->(Dbseek(xFilial("SA5") + clCodFor + clLoja + alRet[1]))					
			RecLock("SA5",.T.) //Se não achar inclui
		else
			RecLock("SA5",.F.) //Se achar altera
		endif  
		
		SA5->A5_FILIAL 	:= xFilial("SA5")
		SA5->A5_FORNECE := clCodFor
		SA5->A5_LOJA 	:= clLoja
		SA5->A5_NOMEFOR	:= Posicione("SA2",1,xFilial("SA2")+SDS->DS_FORNEC+SDS->DS_LOJA,"A2_NOME")
		SA5->A5_CODPRF	:= oGet1:ACOLS[oGet1:NAT][aScan(oGet1:aHeader,{|x| AllTrim(x[2])=="DT_PRODFOR"})]
		SA5->A5_PRODUTO := alRet[1]	//cProduto2
		SA5->A5_NOMPROD := Posicione("SB1",1,xFilial("SB1")+alRet[1],"B1_DESC")
		SA5->( MsUnlock() )
	
	endif
													
Else
	alRet[2] := Posicione("SDT",4,(xFilial("SDT")+clCodFor+clLoja+clNota+clSerie+cItem),"DT_DESCFOR")
EndIf

RestArea(alArea)

Return alRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | ProcPCxNFe ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao procura possiveis pedidos de compra relacionados a NF     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor  = Cod. Fornec./Cli.                                    ³±±
±±³          | clLoja    = Loja                                                 ³±±
±±³          | clNota    = Num. Nota                                            ³±±
±±³          | clSerie   = Serie da Nota                                        ³±±
±±³          | alItens   = array contendo os itens da nota fiscal               ³±±
±±³          | clItem    = Item selecionado                                     ³±±
±±³          | cTipo     = Tipo da nota - Entrada ou devolucao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alItens  = array com os itens atualizados                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SelePed	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function ProcPCxNFe(clCodFor,clLoja,clNota,clSerie,alItens,clItem,cTipo)

Local oFont		 	:= TFont():New('Courier New',,-14,.T.,.T.)
Local oFont2 		:= TFont():New(				,,-14,.T.)
Local oFont3 		:= TFont():New(				,,-12,.T.)
Local nlPos    		:= Ascan(alItens,{|x|X[1]==clItem})
Local alItem1  		:= {}
Local llretCons 	:= .F.
Local nlVarVal  	:= 0.01 // Variacao de valores para busca do pedido
Local clArqSQL  	:= GetNextAlias()
Local clQuery 		:= ""
Local cCodProdEmp	:= ""
Local lParEmpG  	:= GetNewPar("MV_XCODGRP",.F.) //Utiliza o mesmo Código de Produto do Grupo de Empresas .T. = Sim / .F. = Não
Local lEmpGrupo 	:= .F. //forndecedor faz parte do grupo de empresas do sigamat?
Local nPos			:= 0
Private oQuantProd
Private oQuantPed
Private oDlgPed
Private nQuantProd	:= 0
Private nQuantPed	:= 0
Private cArq

// Foi necessario criar essas variaveis para que fosse possivel usar a funcao padrao do sistema A120Pedido()
Private INCLUI      := .F.
Private ALTERA      := .F.
Private nTipoPed    := 1
Private cCadastro   := "Seleção dos Pedidos de Compra"
Private l120Auto    := .F.

DEFINE DIALOG oDlgPed TITLE " Pedidos de Compra " FROM 0,0 TO 470,700 PIXEL STYLE DS_MODALFRAME

oGet2 := MsNewoGet2(clCodFor,clLoja,clNota,clSerie)
oGet3 := MsNewoGet3(clCodFor,clLoja,clNota,clSerie)

oGet2:oBROWSE:bChange := {|| RefreshoGet3() }

@ 020, 005 TO 133,348 LABEL "   Itens da NFe   " OF oDlgPed PIXEL
@ 135, 005 TO 210,348 LABEL "   Pedidos de Compra   " OF oDlgPed PIXEL

@ 003, 142 TO 021,253 LABEL "" OF oDlgPed PIXEL
@ 003, 257 TO 021,348 LABEL "" OF oDlgPed PIXEL

@ 008,145 Say "Qtd XML:  " Size 80,007 Font oFont2 Pixel Of oDlgPed
@ 008,185 Say oQuantProd VAR nQuantProd Size 80,007 Font oFont COLOR CLR_BLACK Picture "@E 99,999,999." + Replicate("9",TamSx3("DV_QUANT")[2]) PIXEL OF oDlgPed
@ 008,260 Say "Qtd P.C:  " Font oFont2 Size 80,007 Pixel Of oDlgPed
@ 008,280 Say oQuantPed VAR nQuantPed Size 80,007 Font oFont COLOR IIF(nQuantPed >= oGet2:ACOLS[oGet2:NAT][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_QUANT"})],CLR_GREEN,CLR_RED) Picture "@E 99,999,999."+Replicate("9",TamSx3("DV_QUANT")[2]) PIXEL OF oDlgPed
@ 215, 005 BUTTON oButton1 PROMPT "Visualizar Pedido" SIZE 080, 015 OF oDlgPed PIXEL ACTION ( iif( Empty(oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="C7_NUM"})]) , Alert("Selecione um Pedido!") , MsgRun("Pedido sendo Localizado","Aguarde...", {|| A120Pedido("SC7",PosSC7( oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="C7_NUM"})] ),2) }) ))
@ 215, 308 BUTTON oButton1 PROMPT "Confirmar" SIZE 040, 015 OF oDlgPed PIXEL ACTION (iif(MsgYesNo("Deseja confirmar as amarrações com os Pedidos de Compra?"),(PedidoOK(clCodFor,clLoja,clNota,clSerie),ALS_PEDIDO->(DbCloseArea()),fErase(cArq + "1" + OrdBagExt()),fErase(cArq + "2" + OrdBagExt()),oDlgPed:End()),))
@ 215, 263 BUTTON oButton2 PROMPT "Cancelar" SIZE 040, 015 OF oDlgPed PIXEL ACTION (ALS_PEDIDO->(DbCloseArea()),fErase(cArq + "1" + OrdBagExt()),fErase(cArq + "2" + OrdBagExt()),oDlgPed:End())

ACTIVATE DIALOG oDlgPed CENTERED

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    | MsNewoGet2  ³Autor ³ Totvs              		   |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Cria o MsNewGetDados dos itens da NFe		                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor  = Cod. Fornec./Cli.                                    ³±±
±±³          | clLoja    = Loja                                                 ³±±
±±³          | clNota    = Num. Nota                                            ³±±
±±³          | clSerie   = Serie da Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SelePed	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function MsNewoGet2(clCodFor,clLoja,clNota,clSerie)

Local nX
Local aHeaderEx 	:= {}
Local aColsEx 		:= {}
Local aFieldFill 	:= {}
Local aFields 		:= {"DT_ITEM","DT_COD","DT_XUM","DT_PRODFOR","B1_DESC","DT_QUANT","DT_VUNIT","DT_TOTAL","DT_PEDIDO","DT_ITEMPC"}
Local aAlterFields 	:= {}
Local cQuery   		:= ""
Local cPulaLinha	:= chr(13)+chr(10)

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

If Select("QRYSDT") > 0
	dbSelectArea( "QRYSDT" )
	QRYSDT->(dbCloseArea())
EndIf

cQuery := " SELECT " 																	+ cPulaLinha
cQuery += " SDT.DT_ITEM ITEM, "                                                 		+ cPulaLinha
cQuery += " SDT.DT_COD PROD_SISTEMA, "                                             		+ cPulaLinha
cQuery += " SDT.DT_XUM UM_XML, "	                                             		+ cPulaLinha
cQuery += " SDT.DT_PRODFOR PROD_FORNECE, "                                     			+ cPulaLinha
cQuery += " SDT.DT_DESCFOR DESC_FORNECE, "                                     			+ cPulaLinha
cQuery += " SDT.DT_QUANT QUANTIDADE, "                                            		+ cPulaLinha
cQuery += " SDT.DT_VUNIT VALOR, "	                                            		+ cPulaLinha
cQuery += " SDT.DT_TOTAL TOTAL, "	                                            		+ cPulaLinha
cQuery += " SDT.DT_PEDIDO PEDIDO, "		                                           		+ cPulaLinha
cQuery += " SDT.DT_ITEMPC ITEM_PEDIDO, "                                           		+ cPulaLinha
cQuery += " SB1.B1_DESC DESC_SISTEMA "                                            		+ cPulaLinha
cQuery += " FROM " + RetSqlName("SDT") + " SDT"                                   		+ cPulaLinha
cQuery += " LEFT JOIN " + RetSqlName("SB1") + " SB1 "                              		+ cPulaLinha
cQuery += " ON SB1.B1_COD = SDT.DT_COD "                                           		+ cPulaLinha
cQuery += " AND SB1.D_E_L_E_T_ <> '*' "                                            		+ cPulaLinha
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "'"                           	+ cPulaLinha
cQuery += " WHERE SDT.D_E_L_E_T_ <> '*' "                                        		+ cPulaLinha
cQuery += " AND SDT.DT_FILIAL 	= '" + xFilial('SDT') + "'"                         	+ cPulaLinha
cQuery += " AND SDT.DT_FORNEC 	= '" + PadR(clCodFor,TamSx3("DT_FORNEC")[1]) + "'"		+ cPulaLinha
cQuery += " AND SDT.DT_LOJA 	= '" + PadR(clLoja,TamSx3("DT_LOJA")[1]) + "'"   		+ cPulaLinha
cQuery += " AND SDT.DT_DOC 		= '" + PadR(clNota,TamSx3("DT_DOC")[1]) + "'"     		+ cPulaLinha
cQuery += " AND SDT.DT_SERIE 	= '" + PadR(clSerie,TamSx3("DT_SERIE")[1]) + "'"    	+ cPulaLinha
cQuery += " ORDER BY SDT.DT_ITEM , SDT.DT_COD"                               			+ cPulaLinha

cQuery := ChangeQuery(cQuery)
TcQuery cQuery New Alias "QRYSDT" // Cria uma nova area com o resultado do query

While  QRYSDT->(!Eof())
	
	aFieldFill 	:= {}
	aAdd(aFieldFill , QRYSDT->ITEM 	 		)
	aAdd(aFieldFill , QRYSDT->PROD_SISTEMA	)
	aAdd(aFieldFill , QRYSDT->UM_XML 		)
	aAdd(aFieldFill , QRYSDT->PROD_FORNECE 	)
	aAdd(aFieldFill , iif( Empty(QRYSDT->DESC_SISTEMA) , QRYSDT->DESC_FORNECE , QRYSDT->DESC_SISTEMA))
	aAdd(aFieldFill , QRYSDT->QUANTIDADE 	)
	aAdd(aFieldFill , QRYSDT->VALOR 		)
	aAdd(aFieldFill , QRYSDT->TOTAL		 	)
	aAdd(aFieldFill , QRYSDT->PEDIDO		)
	aAdd(aFieldFill , QRYSDT->ITEM_PEDIDO	)
	Aadd(aFieldFill , .F.)
	Aadd(aColsEx, aFieldFill)
	
	QRYSDT->( DbSkip() )
	
EndDo

QRYSDT->(DbCloseArea())

if Empty(aColsEx)
	Aadd(aColsEx, {"","","","","",0,0,0,.F.})
endif

Return MsNewGetDados():New( 030, 010, 128, 342, GD_UPDATE , "AllwaysTrue" , "AllwaysTrue" , "" , aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgPed, aHeaderEx, aColsEx)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    | MsNewoGet3  ³Autor ³ Totvs              		   |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Cria o MsNewGetDados dos itens da NFe		                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor  = Cod. Fornec./Cli.                                    ³±±
±±³          | clLoja    = Loja                                                 ³±±
±±³          | clNota    = Num. Nota                                            ³±±
±±³          | clSerie   = Serie da Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SelePed	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function MsNewoGet3(clCodFor,clLoja,clNota,clSerie)

Local nX
Local aHeaderEx 	:= {}
Local aColsEx 		:= {}
Local aFieldFill 	:= {}
Local aFields 		:= {"C7_NUM","C7_ITEM","C7_PRODUTO","B1_DESC","C7_UM","C7_QUANT","INFORMADA","C7_PRECO","C7_TOTAL"}
Local aAlterFields 	:= {"INFORMADA"}
Local cQuery   		:= ""
Local cPulaLinha	:= chr(13)+chr(10)
Local cProdutos		:= ""
Local nContSDV		:= 0
Local nContador		:= 0
Local nQuantSC7		:= 0
Local lConsLoja		:= SuperGetMv("MV_XACP004",.F.,.F.)

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	if aFields[nX] == "INFORMADA"
		Aadd(aHeaderEx,{'Qtd Utilizada','INFORMADA','@E 999,999.99',TamSx3("DV_QUANT")[1],TamSx3("DV_QUANT")[2],'','€€€€€€€€€€€€€€','N','','','',''})
	else
		If SX3->(DbSeek(aFields[nX]))
			Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	endif
Next nX

// crio um alias temporário para gravar os pedidos de compra
CriaAliasTemp("ALS_PEDIDO",{{"ITEMXML","C",TamSx3("DT_ITEM")[1],0} , {"PEDIDO","C",TamSx3("C7_NUM")[1],0} , {"ITEM","C",TamSx3("C7_ITEM")[1],0} , {"PRODUTO","C",TamSx3("C7_PRODUTO")[1],0} , {"DESCRICAO","C",TamSx3("B1_DESC")[1],0} , {"UM","C",TamSx3("C7_UM")[1],0} , {"QUANTIDADE","N",TamSx3("C7_QUANT")[1],TamSx3("C7_QUANT")[2]} , {"DISPONIVEL","N",TamSx3("C7_QUANT")[1],TamSx3("C7_QUANT")[2]} , {"PRECO","N",TamSx3("C7_PRECO")[1],TamSx3("C7_PRECO")[2]} , {"TOTAL","N",TamSx3("C7_TOTAL")[1],TamSx3("C7_TOTAL")[2]}},{"PEDIDO+ITEM","ITEMXML+PEDIDO+ITEM"})

// faço um loop no acols dos itens do XML para pegar o código de todos os produtos
For nW := 1 To Len(oGet2:ACOLS)
	
	nContador		:= 0
	
	If Select("QRYSC7") > 0
		dbSelectArea( "QRYSC7" )
		QRYSC7->(dbCloseArea())
	EndIf
	
	cQuery := " SELECT " 																   			+ cPulaLinha
	cQuery += " SC7.C7_ITEM ITEM, "                                                 	  			+ cPulaLinha
	cQuery += " SC7.C7_PRODUTO PRODUTO, "                                             	  			+ cPulaLinha
	cQuery += " SC7.C7_NUM PEDIDO, "		                                     		   			+ cPulaLinha
	cQuery += " SC7.C7_PRECO PRECO, "                                     	 			  			+ cPulaLinha
	cQuery += " SC7.C7_TOTAL TOTAL, "            	                                	 			+ cPulaLinha
	cQuery += " SC7.C7_UM UM, "		            	                                	 			+ cPulaLinha
	cQuery += " SC7.C7_QUANT QUANTIDADE, "         	                                	 			+ cPulaLinha
	cQuery += " SB1.B1_DESC DESCRICAO "                            	                	  			+ cPulaLinha
	cQuery += " FROM " + RetSqlName("SC7") + " SC7"                                   	 			+ cPulaLinha
	cQuery += " LEFT JOIN " + RetSqlName("SB1") + " SB1 "                              	 			+ cPulaLinha
	cQuery += " ON SB1.B1_COD = SC7.C7_PRODUTO "                                       	 			+ cPulaLinha
	cQuery += " AND SB1.D_E_L_E_T_ <> '*' "                                            	 			+ cPulaLinha
	cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "'"                            			+ cPulaLinha
	cQuery += " WHERE SC7.D_E_L_E_T_ <> '*' "                                        				+ cPulaLinha
	cQuery += " AND SC7.C7_FILIAL 	= '" + xFilial('SC7') + "'"                            			+ cPulaLinha
	cQuery += " AND SC7.C7_PRODUTO = '" + oGet2:ACOLS[nW][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_COD"})]  + "' "	+ cPulaLinha
	cQuery += " AND SC7.C7_QTDACLA < C7_QUANT "                                         		    + cPulaLinha
	cQuery += " AND SC7.C7_ENCER = ' '  "                                                			+ cPulaLinha
	cQuery += " AND SC7.C7_QUJE < SC7.C7_QUANT "                                            		+ cPulaLinha
	cQuery += " AND SC7.C7_FORNECE 	= '" + PadR(AllTrim(clCodFor),TamSx3("C7_FORNECE")[1]) + "'"	+ cPulaLinha

	if lConsLoja //solicitacao do 
		cQuery += " AND SC7.C7_LOJA 	= '" + PadR(AllTrim(clLoja),TamSx3("C7_LOJA")[1]) + "'"   	  	+ cPulaLinha
	ENDIF
	
	cQuery += " ORDER BY SC7.C7_NUM , SC7.C7_ITEM"                               		   			+ cPulaLinha
	
	cQuery := ChangeQuery(cQuery)
	TcQuery cQuery New Alias "QRYSC7" // Cria uma nova area com o resultado do query
	
	ALS_PEDIDO->(DbSetOrder(1))
	
	While  QRYSC7->(!Eof())
		
		nQuantSC7		:= 0
		
		DbSelectArea("ALS_PEDIDO")
		Reclock("ALS_PEDIDO",.T.)
		ALS_PEDIDO->ITEMXML		:= oGet2:ACOLS[nW][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]
		ALS_PEDIDO->PEDIDO		:= QRYSC7->PEDIDO
		ALS_PEDIDO->ITEM		:= QRYSC7->ITEM
		ALS_PEDIDO->PRODUTO		:= QRYSC7->PRODUTO
		ALS_PEDIDO->DESCRICAO	:= QRYSC7->DESCRICAO
		ALS_PEDIDO->UM			:= QRYSC7->UM
		ALS_PEDIDO->QUANTIDADE	:= QRYSC7->QUANTIDADE
		
		SDV->(DbSetOrder(1))
		if SDV->(DbSeek(xFilial("SDV") + clCodFor + clLoja + clNota + clSerie + oGet2:ACOLS[nW][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})] + QRYSC7->PRODUTO + QRYSC7->PEDIDO + QRYSC7->ITEM))
			ALS_PEDIDO->DISPONIVEL	:= SDV->DV_QUANT
			nContador 				+= SDV->DV_QUANT
		endif
		
		ALS_PEDIDO->PRECO		:= QRYSC7->PRECO
		ALS_PEDIDO->TOTAL		:= QRYSC7->TOTAL
		ALS_PEDIDO->(MsUnlock())
		
		QRYSC7->( DbSkip() )
		
	EndDo
	
	QRYSC7->(DbCloseArea())
	
	if nContador < oGet2:ACOLS[nW][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_QUANT"})] 
		
		ALS_PEDIDO->(DbSetOrder(2)) // ITEMXML + PEDIDO + ITEM
		
		if ALS_PEDIDO->(DbSeek(oGet2:ACOLS[nW][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})])) 
			
			While ALS_PEDIDO->(!Eof()) .AND. ALS_PEDIDO->ITEMXML == oGet2:ACOLS[nW][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]
				
				// significa que este item do pedido de compra já está vinculado à este item do XML
				if ALS_PEDIDO->DISPONIVEL > 0
					ALS_PEDIDO->(DbSkip())
					Loop
				endif 
				
				nQuantSC7 := 0     
				nTotalPed := 0    
								
				aAreaPedido := ALS_PEDIDO->(GetArea())  
				
				cPedidoIni 	:= ALS_PEDIDO->PEDIDO
				cItemIni	:= ALS_PEDIDO->ITEM  
				
				// faço a contagem dos itens do XML que estão utilizando este pedido de compra
				ALS_PEDIDO->(DbSetOrder(1)) // PEDIDO + ITEM
				if ALS_PEDIDO->(DbSeek(cPedidoIni + cItemIni))
					
					While ALS_PEDIDO->(!Eof()) .AND. ALS_PEDIDO->PEDIDO == cPedidoIni .AND. ALS_PEDIDO->ITEM ==  cItemIni
						nTotalPed += ALS_PEDIDO->DISPONIVEL
						ALS_PEDIDO->(DbSkip())
					EndDo
					
				endif  
				
				RestArea(aAreaPedido)  
				
				if ALS_PEDIDO->QUANTIDADE <= nTotalPed  
					ALS_PEDIDO->(DbSkip())
					Loop
				endif
				
				if (ALS_PEDIDO->QUANTIDADE - nTotalPed) >= (oGet2:ACOLS[nW][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_QUANT"})] - nContador)
					nQuantSC7 := oGet2:ACOLS[nW][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_QUANT"})] - nContador
				else 
					nQuantSC7 := ALS_PEDIDO->QUANTIDADE - nTotalPed //- nContador
				endif  

				Reclock("ALS_PEDIDO",.F.)
				ALS_PEDIDO->DISPONIVEL	:= nQuantSC7
				ALS_PEDIDO->(MsUnlock())
				nContador += nQuantSC7
				
				ALS_PEDIDO->(DbSkip())
				
			EndDo
			
		endif
		
	endif
	
Next nW

// preencho a primeira linha do acols oget3
ALS_PEDIDO->(DbSetOrder(2)) // ITEMXML + PEDIDO + ITEM

if ALS_PEDIDO->(DbSeek(oGet2:ACOLS[oGet2:NAT][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]))
	
	While ALS_PEDIDO->(!Eof()) .AND. ALS_PEDIDO->ITEMXML == oGet2:ACOLS[oGet2:NAT][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]
		
		aFieldFill 	:= {}
		aAdd(aFieldFill , ALS_PEDIDO->PEDIDO 		)
		aAdd(aFieldFill , ALS_PEDIDO->ITEM 	 		)
		aAdd(aFieldFill , ALS_PEDIDO->PRODUTO		)
		aAdd(aFieldFill , ALS_PEDIDO->DESCRICAO 	)
		aAdd(aFieldFill , ALS_PEDIDO->UM		 	)
		aAdd(aFieldFill , ALS_PEDIDO->QUANTIDADE	)
		aAdd(aFieldFill , ALS_PEDIDO->DISPONIVEL	)
		aAdd(aFieldFill , ALS_PEDIDO->PRECO  		)
		aAdd(aFieldFill , ALS_PEDIDO->TOTAL 		)
		Aadd(aFieldFill , .F.)
		Aadd(aColsEx, aFieldFill)
		
		ALS_PEDIDO->(DbSkip())
		
	EndDo
	
else
	Aadd(aColsEx, {"","","","","",0,0,0,0,.F.})
endif

Return MsNewGetDados():New( 145, 010, 205, 342, GD_UPDATE , "AllwaysTrue" , "AllwaysTrue" , "" , aAlterFields,, 999, "U_VLDOGET3", "", "AllwaysTrue", oDlgPed, aHeaderEx, aColsEx)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDOGET3	  ºAutor  ³Totvs			 º Data ³  22/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função chamada na validação dos campos no oGet3		      º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 				                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VLDOGET3()

Local nTotalProd 	:= 0
Local nQuantProd	:= 0
Local lRet			:= .F.
Local aAreaTMP		:= ALS_PEDIDO->(GetArea())

// faço a contagem da quantidade distribuida entre os pedidos deste produto
ALS_PEDIDO->(DbSetOrder(2)) // ITEMXML
if ALS_PEDIDO->(DbSeek(oGet2:ACOLS[oGet2:NAT][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]))
	
	While ALS_PEDIDO->(!Eof()) .AND. ALS_PEDIDO->ITEMXML == oGet2:ACOLS[oGet2:NAT][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]
		nQuantProd += ALS_PEDIDO->DISPONIVEL
		ALS_PEDIDO->(DbSkip())
	EndDo
	
endif

// faço a contagem dos itens do XML que estão utilizando este pedido de compra
ALS_PEDIDO->(DbSetOrder(1)) // PEDIDO + ITEM
if ALS_PEDIDO->(DbSeek(oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="C7_NUM"})] + oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="C7_ITEM"})]))
	
	While ALS_PEDIDO->(!Eof()) .AND. ALS_PEDIDO->PEDIDO == oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="C7_NUM"})] .AND. ALS_PEDIDO->ITEM ==  oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="C7_ITEM"})]
		nTotalProd += ALS_PEDIDO->DISPONIVEL
		ALS_PEDIDO->(DbSkip())
	EndDo
	
endif

if (nQuantProd - oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="INFORMADA"})] + M->INFORMADA) > oGet2:ACOLS[oGet2:NAT][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_QUANT"})]
	Alert("A quantidade informada é superior a quantidade do item do XML!")
	lRet := .F.
elseif (nTotalProd - oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="INFORMADA"})] + M->INFORMADA) > oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="C7_QUANT"})]
	Alert("Quantidade não disponível para este item do pedido de compra!")
	lRet := .F.
else
	
	ALS_PEDIDO->(DbSetOrder(2)) // ITEMXML + PEDIDO + ITEM
	if ALS_PEDIDO->(DbSeek(oGet2:ACOLS[oGet2:NAT][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})] + oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="C7_NUM"})] + oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="C7_ITEM"})] ))
		
		Reclock("ALS_PEDIDO",.F.)
		ALS_PEDIDO->DISPONIVEL := M->INFORMADA
		ALS_PEDIDO->(MsUnlock())
		
	endif
	
	nQuantPed := (nQuantPed - oGet3:ACOLS[oGet3:NAT][aScan(oGet3:aHeader,{|x| AllTrim(x[2])=="INFORMADA"})] + M->INFORMADA)
	lRet := .T.
	
endif

RestArea(aAreaTMP)

oQuantProd:Refresh()
oQuantPed:Refresh()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RefreshoGet3  ºAutor  ³Totvs			 º Data ³  22/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função chamada na mudança de linha do oGet2			      º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 				                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RefreshoGet3()

oGet3:aCols := {}
nQuantPed	:= 0

// preencho a primeira linha do acols oget3
ALS_PEDIDO->(DbSetOrder(2)) // ITEMXML
if ALS_PEDIDO->(DbSeek(oGet2:ACOLS[oGet2:NAT][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]))
	
	While ALS_PEDIDO->(!Eof()) .AND. ALS_PEDIDO->ITEMXML == oGet2:ACOLS[oGet2:NAT][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]
		
		aFieldFill := {}
		aAdd(aFieldFill , ALS_PEDIDO->PEDIDO 		)
		aAdd(aFieldFill , ALS_PEDIDO->ITEM 	 		)
		aAdd(aFieldFill , ALS_PEDIDO->PRODUTO		)
		aAdd(aFieldFill , ALS_PEDIDO->DESCRICAO 	)
		aAdd(aFieldFill , ALS_PEDIDO->UM		 	)
		aAdd(aFieldFill , ALS_PEDIDO->QUANTIDADE	)
		aAdd(aFieldFill , ALS_PEDIDO->DISPONIVEL	)
		aAdd(aFieldFill , ALS_PEDIDO->PRECO  		)
		aAdd(aFieldFill , ALS_PEDIDO->TOTAL 		)
		aAdd(aFieldFill , .F.)
		aAdd(oGet3:acols,aFieldFill)
		
		nQuantPed += ALS_PEDIDO->DISPONIVEL
		
		ALS_PEDIDO->(DbSkip())
		
	EndDo
	
else
	Aadd(oGet3:acols , {"","","","","",0,0,0,0,.F.})
endif

nQuantProd 	:= oGet2:ACOLS[oGet2:NAT][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_QUANT"})]

oGet3:oBrowse:Refresh()
oQuantProd:Refresh()
oQuantPed:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuGet1	  ºAutor  ³Totvs			 º Data ³  29/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que atualiza o acols oGet1 					      º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 				                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AtuGet1(clCodFor,clLoja,clNota,clSerie)

Local cQuery		:= ""
Local cPulaLinha	:= chr(13)+chr(10)

oGet1:aCols := {}

cQuery := " SELECT " 																	+ cPulaLinha
cQuery += " SDT.DT_ITEM ITEM, "                                                 		+ cPulaLinha
cQuery += " SDT.DT_COD PROD_SISTEMA, "                                             		+ cPulaLinha
cQuery += " SDT.DT_PRODFOR PROD_FORNECE, "                                     			+ cPulaLinha
cQuery += " SDT.DT_DESCFOR DESC_FORNECE, "                                     			+ cPulaLinha
cQuery += " SDT.DT_PEDIDO PEDIDO, "         	                            			+ cPulaLinha
cQuery += " SDT.DT_ITEMPC ITEM_PEDIDO, "	                                   			+ cPulaLinha
cQuery += " SB1.B1_DESC DESC_SISTEMA "                                            		+ cPulaLinha
cQuery += " FROM " + RetSqlName("SDT") + " SDT"                                   		+ cPulaLinha
cQuery += " LEFT JOIN " + RetSqlName("SB1") + " SB1 "                              		+ cPulaLinha
cQuery += " ON SB1.B1_COD = SDT.DT_COD "                                           		+ cPulaLinha
cQuery += " AND SB1.D_E_L_E_T_ <> '*' "                                            		+ cPulaLinha
cQuery += " AND SB1.B1_FILIAL = '" + xFilial('SB1') + "'"                           	+ cPulaLinha
cQuery += " WHERE SDT.D_E_L_E_T_ <> '*' "                                        		+ cPulaLinha
cQuery += " AND SDT.DT_FILIAL 	= '" + xFilial('SDT') + "'"                         	+ cPulaLinha
cQuery += " AND SDT.DT_FORNEC 	= '" + PadR(clCodFor,TamSx3("DT_FORNEC")[1]) + "'"		+ cPulaLinha
cQuery += " AND SDT.DT_LOJA 	= '" + PadR(clLoja,TamSx3("DT_LOJA")[1]) + "'"   		+ cPulaLinha
cQuery += " AND SDT.DT_DOC 		= '" + PadR(clNota,TamSx3("DT_DOC")[1]) + "'"     		+ cPulaLinha
cQuery += " AND SDT.DT_SERIE 	= '" + PadR(clSerie,TamSx3("DT_SERIE")[1]) + "'"    	+ cPulaLinha
cQuery += " ORDER BY SDT.DT_ITEM , SDT.DT_COD"                               			+ cPulaLinha

cQuery := ChangeQuery(cQuery)
TcQuery cQuery New Alias "QRYSDT" // Cria uma nova area com o resultado do query

While  QRYSDT->(!Eof())
	
	aFieldFill 	:= {}
	aAdd(aFieldFill , iif(Empty(QRYSDT->PEDIDO),"BR_VERDE","BR_VERMELHO")	)
	aAdd(aFieldFill , QRYSDT->ITEM 	 										)
	aAdd(aFieldFill , QRYSDT->PEDIDO										)
	aAdd(aFieldFill , QRYSDT->ITEM_PEDIDO									)
	aAdd(aFieldFill , QRYSDT->PROD_SISTEMA 									)
	aAdd(aFieldFill , QRYSDT->PROD_FORNECE 							   		)
	aAdd(aFieldFill , iif( Empty(QRYSDT->DESC_SISTEMA) , QRYSDT->DESC_FORNECE , QRYSDT->DESC_SISTEMA))
	Aadd(aFieldFill , .F.)
	aAdd(oGet1:acols,aFieldFill)
	
	QRYSDT->( DbSkip() )
	
EndDo

QRYSDT->(DbCloseArea())

if Empty(oGet1:acols)
	Aadd(oGet1:acols, {"","","","","","","",.F.})
endif

oGet1:oBrowse:Refresh()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PedidoOK  ºAutor  ³Totvs	 			 º Data ³  22/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função chamada na confirmação da amarração dos itens do    º±±
±±º          ³ XML com os pedidos de compra								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 				                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PedidoOK(clCodFor,clLoja,clNota,clSerie)
Local nX 			:= 1
Local nZ			:= 1
Local aQuantItens 	:= {}
Local cUM			:= ""
Local cCnpj 		:= ""
Local cCod			:= ""
Local cProdFor 		:= ""
Local cDescFor		:= ""
Local nQuant		:= 0
Local nVUnit		:= 0
Local nTotal		:= 0
Local cItemXML		:= ""
Local nContador		:= 0
Local nDescUnit		:= 0
Local cItenXMAux	:= ""
// faço a exclusão de todas as amarrações dos itens do XML com pedidos de compra
SDV->(DbSetOrder(1))
if SDV->(DbSeek(xFilial("SDV") + clCodFor + clLoja + clNota + clSerie))
	
	While SDV->(!EOF()) .AND. SDV->DV_FILIAL == xFilial("SDV") .AND. SDV->DV_FORNEC == clCodFor;
		.AND. SDV->DV_LOJA == clLoja .AND. SDV->DV_DOC == clNota .AND. SDV->DV_SERIE == clSerie
		
		Reclock("SDV",.F.)
		SDV->(DbDelete())
		SDV->(DbSkip())
		
	EndDo
	
endif

SDT->(DbSetOrder(4))// DT_FILIAL + DT_FORNEC + DT_LOJA + DT_DOC + DT_SERIE + DT_ITEM
if SDT->(DbSeek(xFilial("SDT") + clCodFor + clLoja + clNota + clSerie))
	
	While SDT->(!EOF()) .AND. SDT->DT_FILIAL == xFilial("SDT") .AND. SDT->DT_FORNEC == clCodFor ;
		.AND. SDT->DT_LOJA == clLoja .AND. SDT->DT_DOC == clNota .AND. SDT->DT_SERIE == clSerie
		
		RecLock("SDT",.F.)
		SDT->DT_PEDIDO := ""
		SDT->DT_ITEMPC := ""
		SDT->(MsUnLock())
		
		SDT->(DbSkip())
		
	EndDo
	
endif

// faço um loop no acols dos itens do XML procurando no Alias Temporario os pedidos de compra que foram selecionados
For nX := 1 To Len(oGet2:ACOLS)
	
	aQuantItens := {}
	nContador	:= 0
	
	ALS_PEDIDO->(DbSetOrder(2)) // ITEMXML
	if ALS_PEDIDO->(DbSeek(oGet2:ACOLS[nX][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]))
		
		While ALS_PEDIDO->(!Eof()) .AND. ALS_PEDIDO->ITEMXML == oGet2:ACOLS[nX][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})]
			
			if ALS_PEDIDO->DISPONIVEL > 0
				aadd(aQuantItens,{ALS_PEDIDO->PEDIDO,ALS_PEDIDO->ITEM,ALS_PEDIDO->DISPONIVEL,""})
			endif
			ALS_PEDIDO->(DbSkip())
			
		EndDo
		
		For nZ := 1 To Len(aQuantItens)
			
			if nZ == 1
				
				SDT->(DbSetOrder(4))// DT_FILIAL + DT_FORNEC + DT_LOJA + DT_COD + DT_SERIE + DT_ITEM
				if SDT->(DbSeek(xFilial("SDT") + clCodFor + clLoja + clNota + clSerie + oGet2:ACOLS[nX][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_ITEM"})] ))
					nDescUnit := SDT->DT_VALDESC/SDT->DT_QUANT
					aCamposSDT := {}
					
					SX3->(DbSetOrder(1))
					if SX3->(Dbseek("SDT"))
						
						While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == "SDT"
							
							if SX3->X3_CONTEXT <> "V"
								
								cCampoSDT := SX3->X3_CAMPO
								aadd(aCamposSDT, {cCampoSDT,SDT->&(cCampoSDT)})
								
							endif
							
							SX3->(DbSkip())
							
						EndDo
						
					else
						Exit
					endif
					
					nQuant := SDT->DT_QUANT
					
					RecLock("SDT",.F.)
					SDT->DT_PEDIDO := aQuantItens[nZ][1]
					SDT->DT_ITEMPC := aQuantItens[nZ][2]
					
					if Len(aQuantItens) > 1
						SDT->DT_QUANT 	:= aQuantItens[nZ][3]
						SDT->DT_TOTAL 	:= SDT->DT_QUANT * SDT->DT_VUNIT
						SDT->DT_VALDESC := Round((SDT->DT_QUANT * nDescUnit),3)
						nContador 		+= aQuantItens[nZ][3]
					endif
					
					SDT->(MsUnLock())
					
					aQuantItens[nZ][4] := SDT->DT_ITEM
					
				endif
				
			else
				
				// pego o proximo item da SDT
				cItemXML := StrZero(Len(oGet2:ACOLS)+nZ-1,TAMSX3("DT_ITEM")[1])
				SDT->(DbSetOrder(4))// DT_FILIAL + DT_FORNEC + DT_LOJA + DT_COD + DT_SERIE + DT_ITEM
				While SDT->(DbSeek(xFilial("SDT") + clCodFor + clLoja + clNota + clSerie + cItemXML ))
					cItemXML := Soma1(cItemXML)
				EndDo
				Begin Transaction
				if RecLock("SDT",.T.)
					
					For nW := 1 To Len(aCamposSDT)
						SDT->&(aCamposSDT[nW,1]) := aCamposSDT[nW,2]
					Next nW
					
					if nZ < Len(aQuantItens)
						SDT->DT_QUANT 	:= aQuantItens[nZ][3]
						nContador 		+= aQuantItens[nZ][3]
					else
						SDT->DT_QUANT 	:= nQuant - nContador
					endif
					
					SDT->DT_ITEM 	:= cItemXML
					SDT->DT_TOTAL	:= SDT->DT_QUANT * SDT->DT_VUNIT
					SDT->DT_PEDIDO 	:= aQuantItens[nZ][1]
					SDT->DT_ITEMPC 	:= aQuantItens[nZ][2]
					SDT->DT_VALDESC := Round((SDT->DT_QUANT * nDescUnit),3)
					aQuantItens[nZ][4] := SDT->DT_ITEM
					
					SDT->( dbCommit() )
					SDT->( MsUnlock() )
				endif
				End Transaction
				
			endif
			
			Begin Transaction
			If RecLock("SDV",.T.)
				
				SDV->DV_FILIAL     	:= xFilial("SDV")
				SDV->DV_DOC        	:= clNota
				SDV->DV_SERIE      	:= clSerie
				SDV->DV_FORNEC      := clCodFor
				SDV->DV_LOJA   	    := clLoja
				SDV->DV_PROD  	    := oGet2:ACOLS[nX][aScan(oGet2:aHeader,{|x| AllTrim(x[2])=="DT_COD"})]
				SDV->DV_NUMPED     	:= aQuantItens[nZ][1]
				SDV->DV_ITEMPC		:= aQuantItens[nZ][2]
				SDV->DV_QUANT		:= aQuantItens[nZ][3]
				SDV->DV_ITEMXML		:= aQuantItens[nZ][4]
				
				SDV->( dbCommit() )
				SDV->( MsUnlock() )
				
			EndIf
			
			End Transaction
			
		Next nZ
		
	endif
	
Next nX

// Função que atualiza o oGet1
AtuGet1(clCodFor,clLoja,clNota,clSerie)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaAliasTempºAutor ³Totvsº Data ³ 10/09/12			      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função genérica para criar Alias temporário		          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParâmetros³Função para criar Alias temporário				          º±±
±±º          ³1- Nome do Alias : "ALIAS_TESTE"							  º±±
±±º          ³2- Array Bidimensional com os campos do alias :		 	  º±±
±±º          ³{{"OK","C",2,0} , {"COD","C"	,6,0}} , onde a primeira	  º±±
±±º          ³posição é o nome do campo, a segunda é o tipo, C = Caracter º±±
±±º          ³N = inteiro, D = Data e L = Lógico, a terceira é o tamanho  º±±
±±º          ³do campo e quarta é Default 0.							  º±±
±±º          ³3- Nome do campo que será o Índice para o alias: "COD"	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 				                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaAliasTemp(cAlias,aCampos,aIndice)

Local cQry
Local aIndTemp		:= aIndice
Local cAliasTemp	:= cAlias
Local _stru	   		:= aClone(aCampos)
Local lInverte		:= .F.
Local nIndex

cArq := Criatrab(_stru,.T.)
USE &cArq ALIAS &cAliasTemp NEW

For nZ := 1 To Len(aIndTemp)
	IndRegua(cAliasTemp, cArq+cValToChar(nZ), aIndTemp[nZ],,)
Next nZ

DbClearIndex()

For nZ := 1 To Len(aIndTemp)
	DbSetIndex(cArq + cValToChar(nZ) + OrdBagExt())
Next nZ

/*
AAdd( aCampos,{"TRB_NOME","C",10,0} )
AAdd( aCampos,{"TRB_NREDUZ","C",10,0} )
AAdd( aCampos,{"TRB_END","C",10,0} )

cArqTrb := CriaTrab( aCampos,.T. )

USE &cArqTrb ALIAS "TRB"

IndRegua( "TRB",cArqTrb+"1", "TRB_NOME" )
IndRegua( "TRB",cArqTrb+"2", "TRB_NREDUZ" )
IndRegua( "TRB",cArqTrb+"3", "TRB_END" )

dbClearIndex()

dbSetIndex( cArqTrb+"1"+OrdBagExt() )
dbSetIndex( cArqTrb+"2"+OrdBagExt() )
dbSetIndex( cArqTrb+"3"+OrdBagExt() )
*/

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | MarkBrwPC  ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao responsavel por criar MsSelect/MarkBrowse para que o      ³±±
±±³          | usuario escolha os pedidos de compra referentes aos itens na NF  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clArqSQL  = String com o nome da Tabela SQL                      ³±±
±±³          | alItem1   = Dados do item da nota fiscal                         ³±±
±±³          |          [1] - Cod. Produto                                      ³±±
±±³          |          [2] - Cod. Produto FOrnecedor                           ³±±
±±³          |          [3] - Quant. do item na Nf                              ³±±
±±³          |          [4] - Valor unitario                                    ³±±
±±³          | clCodFor  = Cod. Fornec./Cli.                                    ³±±
±±³          | clLoja    = Loja                                                 ³±±
±±³          | clNota    = Num. Nota                                            ³±±
±±³          | clSerie   = Serie da Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ProcPCxNFe                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function MarkBrwPC(clArqSQL,alItem1,clCodFor,clLoja,clNota,clSerie)
Local clQZ4         := 0
Local olFont        := TFont ():New(,,-11,.T.,.T.,5,.T.,5,.F.,.F.)
Local alSize    	:= MsAdvSize()
Local nlTl1     	:= alSize[1]
Local nlTl2    		:= alSize[2]
Local nlTl3    		:= alSize[1]+300
Local nlTl4     	:= alSize[2]+520
Local clPed         := ""
Local clItmPC       := ""
Local alEstru       := {}
Local llInvert      := .F.
Local alCampos      := {}
Local clTabTmp      := ""
Local clTMPMark     := ""
Local clTMPQtd      := 0
Local alTamSDV      := {TAMSX3("DV_FORNEC")[1],TAMSX3("DV_LOJA")[1],TAMSX3("DV_DOC")[1],TAMSX3("DV_SERIE")[1],TAMSX3("	PROD")[1],TAMSX3("DV_NUMPED")[1],TAMSX3("DV_ITEMPC")[1]}
Local olSayQtd      := NIL
Local olMsSel01     := NIL
Local clMarca       := GetMark() // Essa variável não pode ter outro conteudo
Private opDlgMPed   := NIL

// Foi necessario criar essas variaveis para que fosse possivel usar a funcao padrao do sistema A120Pedido()
Private INCLUI      := .F.
Private ALTERA      := .F.
Private nTipoPed    := 1
Private cCadastro   := "Seleção dos Pedidos de Compra"
Private l120Auto    := .F.
Private lPassou		:= .F.

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  VERIFICA SE ALGUMA NOTA JA PREENCHE QUANTIDADE DESSE PRODUTO  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbselectArea("SDV")
SDV->( dbSetOrder(1) )
SDV->( dbGoTop() )

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  ESTRUTURA PARA TABELA TEMPORARIA  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
alEstru := {}
aadd(alEstru,{"MMARK",     "C",  LEn(clMarca),           0                     })
aadd(alEstru,{"PED ",      "C",  TamSx3("C7_NUM")[1],    0                     })
aadd(alEstru,{"ITEM",      "C",  TamSx3("C7_ITEM")[1],   0                     })
aadd(alEstru,{"DDATA",     "D",  8                   ,   0                     })
aadd(alEstru,{"QTDDISP" ,  "N",  TamSx3("C7_QUANT")[1],  TamSx3("C7_QUANT")[2] })
aadd(alEstru,{"QTDREF" ,   "N",  TamSx3("C7_QUANT")[1],  TamSx3("C7_QUANT")[2] })

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  CAMPOS PARA MSSELECT  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
alCampos := {}
aAdd(alCampos,{"MMARK"    , , ""   	      ,""                      	})
aAdd(alCampos,{"PED"      , , "Pedido"    ,PesqPict("SC7","C7_NUM")  	})
aAdd(alCampos,{"ITEM"     , , "Item"      ,PesqPict("SC7","C7_ITEM")   })
aAdd(alCampos,{"DDATA"    , , "Data"      ,                            })
aAdd(alCampos,{"QTDDISP"  , , "Qtd.Disp." ,PesqPict("SC7","C7_QUANT")  })
aAdd(alCampos,{"QTDREF"   , , "Qtd.Infor" ,PesqPict("SC7","C7_QUANT")  })

// Cria e seleciona a tabela temporária
clTabTmp := CriaTrab(alEstru,.T.)
dbUseArea(.T.,,clTabTmp,"TMP",.F.,.F.)
dbSelectArea("TMP")

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  TRANSFERE OS DADOS PARA A TABELA TEMPORARIA  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(clArqSql)
&(clArqSql+"->(dbGoTop())")
While &(clArqSql+"->(!EOF())")
	clPed 			:= &(clArqSql+"->C7_NUM")
	clItmPc 		:= &(clArqSql+"->C7_ITEM")
	clTMPMark       := ""
	clTMPQtd        := 0
	
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// |  VERIFICA REGISTRO NA TABELA SDV E TRAZ PREENCHIDA CASO ENCONTRE  |
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbselectArea("SDV")
	SDV->( dbSetOrder(1) )
	SDV->( dbGoTop() )
	If SDV->( dbSeek(xFilial("SDV") + clCodFor + clLoja + clNota + clSerie + alItem1[1] + clPed + clItmPc) )
		clTMPMark     := clMarca
		clTMPQtd      := SDV->DV_QUANT
	EndIf
	
	If RecLock("TMP",.T.)
		TMP->PED     	:= clPed
		TMP->ITEM    	:= clItmPc
		TMP->DDATA  	:= StoD(&(clArqSql+"->C7_EMISSAO"))
		TMP->QTDDISP 	:= (&(clArqSql+"->C7_QUANT") - (&(clArqSql+"->C7_QTDACLA")+ clQZ4))
		TMP->MMARK   	:= clTMPMark
		TMP->QTDREF    	:= clTMPQtd
		TMP->( MsUnLock() )
	EndIf
	
	dbSelectArea(clArqSql)
	&(clArqSql)->(dbSkip())
EndDo

TMP->(dbGoTop())

DEFINE MSDIALOG opDlgMPed TITLE "Seleção dos Pedidos de Compra" From nlTl1,nlTl2 to nlTl3,nlTl4 PIXEL

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  CABECALHO DA TELA  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@(nlTl1+10),nlTl2 + 005 to (nlTl1+35),(nlTl2+255) PIXEL OF opDlgMPed
@(nlTl1+14),(nlTl2+010) Say AllTrim(alItem1[2]) + " / " + AllTrim(alItem1[1]) + " - " + Posicione("SB1",1,(xFilial("SB1")+PadR(alItem1[1],TamSX3("B1_COD")[1])),"B1_DESC")   Font olFont Pixel Of opDlgMPed
@(nlTl1+23),(nlTl2+010) Say "Item "   + AllTrim(STR(alItem1[3]))      Font olFont Pixel Of opDlgMPed

olSayQtd := tSay():New((nlTl1+23),(nlTl2+130),{|| "Qtd.Nota Fiscal " + AllTrim(STR(DigQtdeIt(0,alItem1[3],"C")[1])) },opDlgMPed,,olFont,,,,.T.,,,100,20)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  MARKBROWSE / MSSELECT |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
olMsSel01 :=  MsSelect():New('TMP','MMARK',"",alCampos,@llInvert,@clMarca,{(nlTl1+40),(nlTl2 + 005),(nlTl3-175),(nlTl4-265)},,opDlgMPed)
olMsSel01:oBrowse:lColDrag    := .T.
olMsSel01:bMark := {|| (MarcaReg(clMarca,alItem1[3]), olMsSel01:oBrowse:Refresh(), opDlgMPed:Refresh(), olSayQtd:cCaption:= "Qtd. Sem Pedido de Compra " + AllTrim(STR(DigQtdeIt(0,alItem1[3],"C")[1])) )  }

// ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  BOTOES    |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
obTVisPe := TButton():New(nlTl1+132,nlTl2 + 005,"Visualizar Pedido",opDlgMPed,{|| MsgRun("Pedido "+Space(1)+TMP->PED+"Sendo Localizado","Aguarde...", {|| A120Pedido("SC7",PosSC7( TMP->PED ),2) })   } ,055,012,,,,.T.  )
DEFINE SBUTTON FROM nlTl1+134,nlTl2+188 TYPE 1 ACTION(eVal( {|| iif(DigQtdeIt(0,alItem1[3],"C")[1] <> 0 .AND. GetMV("MV_PCNFE") , Alert("Não foi informado a quantidade total da nota!") ,(MarkBrwOk(clCodFor,clLoja,clNota,clSerie,alItem1[1],alTamSDV))) , iif(DigQtdeIt(0,alItem1[3],"C")[1] <> 0 .AND. GetMV("MV_PCNFE") , , opDlgMPed:End())  } )) ENABLE Of opDlgMPed
DEFINE SBUTTON FROM nlTl1+134,nlTl2+222 TYPE 2 ACTION(opDlgMPed:End()) ENABLE Of opDlgMPed

ACTIVATE DIALOG opDlgMPed CENTERED

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | FECHA E DELETA ARQ. TAB. TEMP.     |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TMP->(dbCloseArea())
If File( AllTrim(clTabTmp)+GetDBExtension())
	Ferase(AllTrim(clTabTmp)+GetDBExtension())
EndIf
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | MarkBrwOk  ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Executada no botao "OK" do MarkBrowse de selecao de ped. Comp.   ³±±
±±³          | deleta e/ou grava os registros na tabelza PED. COMP. X NFE (SDV) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor   = Cod. Fornec./Cli.                                   ³±±
±±³          | clLoja     = Loja                                                ³±±
±±³          | clNota     = Num. Nota                                           ³±±
±±³          | clSerie    = Serie da Nota                                       ³±±
±±³          | clCodProd  = Codigo do produto                                   ³±±
±±³          | alTamSDV   = Array com os tamanhos dos campos usados no dbSeek   ³±±
±±³          |              [1] - Tam. Campo DV_FORNEC                          ³±±
±±³          |              [2] - Tam. Campo DV_LOJA                            ³±±
±±³          |              [3] - Tam. Campo DV_DOC                             ³±±
±±³          |              [4] - Tam. Campo DV_SERIE                           ³±±
±±³          |              [5] - Tam. Campo DV_PROD                            ³±±
±±³          |              [6] - Tam. Campo DV_NUMPED                          ³±±
±±³          |              [7] - Tam. Campo DV_ITEMPC                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MarkBrwPC	                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function MarkBrwOk(clCodFor,clLoja,clNota,clSerie,clCodProd,alTamSDV)
Local aArea := GetArea()
Local clNumPed := ""
Local clItemPc := ""

dbSelectArea("SDV")
SDV->( dbSetOrder(1) )

TMP->( dbGoTop() )
While TMP->(!EOF())
	
	SDV->(dbGoTop())
	clNumPed  := PadR(TMP->PED,TamSX3("C7_NUM")[1])
	clItemPC  := PadR(TMP->ITEM,TamSX3("C7_ITEM")[1])
	dbSelectArea("SDV")
	SDV->( dbSetOrder(1) )
	
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// | EXCLUI O REGISTRO DA TABELA   |
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SDV->( dbSeek( xFilial("SDV")+PadR(clCodFor,alTamSDV[1])+PadR(clLoja,alTamSDV[2])+PadR(clNota,alTamSDV[3])+PadR(clSerie,alTamSDV[4])+PadR(clCodProd,alTamSDV[5])+PadR(clNumPed,alTamSDV[6])+PadR(clItemPC,alTamSDV[7])) )
		
		SDT->(dbSetOrder(3)) //DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE+DT_COD
		If (SDT->(dbSeek( xFilial("SDT") + clCodFor + clLoja + clNota + clSerie + clCodProd)))
			RecLock("SDT",.F.)
			SDT->DT_PEDIDO := ""
			SDT->DT_ITEMPC := ""
			SDT->(MsUnLock())
		Endif
		If RecLock("SDV")
			SDV->( DbDelete() )
			SDV->(MsUnlock())
		EndIf
		
	EndIf
	
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// | GRAVA NA SDV SE ESTIVER MARCADO  |
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(TMP->MMARK)
		
		Begin Transaction
		
		If RecLock("SDV",.T.)
			SDV->DV_FILIAL     	:= xFilial("SDV")
			SDV->DV_DOC        	:= clNota
			SDV->DV_SERIE      	:= clSerie
			SDV->DV_FORNEC      := clCodFor
			SDV->DV_LOJA   	    := clLoja
			SDV->DV_PROD  	    := clCodProd
			SDV->DV_NUMPED     	:= TMP->PED
			SDV->DV_ITEMPC		:= TMP->ITEM
			SDV->DV_QUANT		:= TMP->QTDREF
			
			SDV->( dbCommit() )
			SDV->( MsUnlock() )
		EndIf
		
		End Transaction
		
		SDT->(dbSetOrder(3)) //DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE+DT_COD
		If (SDT->(dbSeek( xFilial("SDT") + clCodFor + clLoja + clNota + clSerie + clCodProd)))
			RecLock("SDT",.F.)
			SDT->DT_PEDIDO := TMP->PED
			SDT->DT_ITEMPC := TMP->ITEM
			SDT->(MsUnLock())
		Endif
	EndIf
	
	dbSelectArea("TMP")
	TMP->( dbSkip() )
	
Enddo

SDV->(dbCloseArea())
RestArea(aArea)
Return NIL


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | MarcaReg	  ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Executada quando o registro e marcado                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clMarca   = String retornada do GETMark()                        ³±±
±±³          | nlQtdTot  = Qtd. total / maxima permitida                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MarkBrwPC                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function MarcaReg(clMarca,nlQtdTot)

Local nlReg 	:= TMP->(Recno())
lPassou		 	:= .F.

// valido se não foi informado quantidade para mais de um pedido de compra
if !Empty(TMP->MMARK)
	
	TMP->( dbGoTop() )
	while TMP->(!EOF())
		if TMP->QTDREF > 0
			lPassou := .T.
			Exit
		endif
		TMP->( dbSkip() )
	EndDo
	TMP->( dbGoTo(nlReg) )
	
	if lPassou
		Aviso("Atenção","Selecione apenas um Pedido de Compra por produto!" ,{"Ok"})
		RecLock("TMP",.F.)
		TMP->MMARK := ""
		TMP->( MsUnLock() )
		Return()
	endif
	
endif

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | PREENCHE COM VALOR DIGITADO PELO USUARIO  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If RecLock("TMP",.F.)
	TMP->QTDREF := DigValIt(TMP->QTDREF,TMP->QTDDISP,nlQtdTot)
	TMP->( MsUnLock() )
EndIf

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | VERIFICA SE O VALOR E ZERO. SE SIM DESMARCA REGISTRO  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(TMP->QTDREF) .and. RecLock("TMP")
	TMP->MMARK := ""
	TMP->( MsUnLock() )
Elseif RecLock("TMP")
	TMP->MMARK := clMarca
	TMP->( MsUnLock() )
EndIf
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |DigValIt	  ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao cria telinha para que o usuario digite numa get o valor   ³±±
±±³          | (unidades) do item da nota fiscal correspondente ao pedido selec.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nlValGet   = quantidade ja preenchido                            ³±±
±±³          | nlValDisp  = quantidade maxima disponivel                        ³±±
±±³          | nlQtdTot   = quantidade total                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Se variavel llOk == .T., retorna valor digitado 'nlValGet'       ³±±
±±³          | senao retorna  nlValAnt = valor anterior                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MarcaReg		                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function DigValIt(nlValGet,nlValDisp,nlQtdTot)
Local nlValAnt  	:= nlValGet
Local alSize   		:= MsAdvSize()
Local llOk     		:= .F.
Local olGetVal  	:= Nil
Private _opdlgGet 	:= Nil

DEFINE MSDIALOG _opdlgGet TITLE "Quantidade" From alSize[1],alSize[2] to (alSize[1]+080),(alSize[2]+195) PIXEL

olGetVal :=TGet():New((alSize[1]+10),(alSize[2]+15),{|u| if(PCount()>0,nlValGet:=u,nlValGet)}, _opdlgGet ,50,10,PesqPict("SC7","C7_QUANT") , {|| ValorNFxPC(nlValGet, nlValDisp, nlQtdTot ) },,,,,,.T.,,,,,,,.F.,,,"nlValGet")
DEFINE SBUTTON FROM (alSize[1]+28),(alSize[2]+57) TYPE 1 ACTION(eVal( {|| ( (llOk:=.T.),_opdlgGet:End())  } )) ENABLE Of _opdlgGet

ACTIVATE DIALOG _opdlgGet CENTERED
Return ( Iif(llOk,nlValGet,nlValAnt) )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |ValorNFxPC    ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Valida o valor informado do item da nota fiscal correspondente     ³±±
±±³          | ao pedido selecionado. 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nlValGet   = quantidade ja preenchido                              ³±±
±±³          | nlValDisp  = quantidade maxima disponivel                          ³±±
±±³          | nlQtdTot   = quantidade total                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Lógico	 														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DigValIt		                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function ValorNFxPC(nlValGet, nlValDisp, nlQtdTot )
Local lRet := .F.

If (nlValGet<=nlValDisp) .And. Positivo(nlValGet) // .AND. (DigQtdeIt(nlValGet,nlQtdTot,"V")[2] )
	lRet := .T.
Else
	Aviso("Atenção","O valor informado do Item da nota" + CHR(13)+CHR(10) + "não corresponde ao pedido selecionado" ,{"Ok"})
	lRet := .F.
EndIf

Return lRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | DigQtdeIt  ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao cria telinha para que o usuario digite numa get o valor   ³±±
±±³          | (unidades) do item da nota fiscal correspondente ao pedido selec.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nlValGet   = quantidade ja preenchido                            ³±±
±±³          | nlQtdTot   = quantidade total                                    ³±±
±±³          | clFin      = Finalidade da funcao. Podendo receber "C" ou "V"    ³±±
±±³          | Se recebe "V" (verificar), valida se ainda é possivel selecionar ³±±
±±³          | valores referente ao item da nota. Valida o maximo.              ³±±
±±³          | Se "C" apenas calcula a quant. ja informada ( alRet[1] )         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alRet = array 2 posicoes                                         ³±±
±±³          |         [1] - soma dos valores jah preenchidos para o iten       ³±±
±±³          |         [2] - booleana - Se .F., nao possivel mais indicar valor ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MarkBrwPC, ValorNFxPC                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function DigQtdeIt(nlValGet,nlQtdTot,clFin)
Local alRet 	:= {0,.T.}
Local nlReg 	:= TMP->(Recno())

TMP->( dbGoTop() )
while TMP->(!EOF())
	
	If clFin=="V" .and. TMP->(Recno()) <> nlReg
		alRet[1]+=TMP->QTDREF
	Else
		alRet[1]+=TMP->QTDREF
	EndIf
	
	TMP->( dbSkip() )
	
EndDo

TMP->( dbGoTo(nlReg) )

If (clFin=="V") .and. ((alRet[1]+nlValGet) > nlQtdTot)
	alRet[2] := !alRet[2]
Else
	alRet[1] := (nlQtdTot-alRet[1])
EndIf

Return alRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |  PosSC7    ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao para posicionar a Tabela SC7 no pedido escolhido          ³±±
±±³          | retorna o recno que sera passado como parametro na funcao padrao ³±±
±±³          | do sistema A120Pedido()                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clPed = Numero do pedido de compra                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ nlRet = SC7->(Recno())                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MarkBrwPC	                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function PosSC7(clPed)
Local nlRet := 0

//dbSelectArea("SC7")
SC7->( dbSetOrder(1) )
If SC7->( dbSeek( xFilial("SC7")+PadR(clPed,TamSx3("C7_NUM")[1]) ) )
	nlRet := SC7->( Recno() )
EndIf
Return nlRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | ExecTela   ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao que monta aCols, aHeader para tela e executa rotina aut.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nlOpc     := Opcao escolhida (2-Visu / 3-Gerar)                  ³±±
±±³          | clCodFor  := Cod. Fornecedor/Cliente                             ³±±
±±³          | clLoja    := Loja                                                ³±±
±±³          | clNota    := Num. Nota                                           ³±±
±±³          | clSerie   := Serie                                               ³±±
±±³          | olLBox    := Objeto                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MontaBrw	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function ExecTela(nlOpc,clCodFor,clLoja,clNota,clSerie,olLBox)
Local nlUsado       := 0
Local alDTVirt      := {}
Local alDTVisu      := {}
Local alRecDT       := {}
Local alSF1         := {}
Local alSD1         := {}
Local alSize        := MsAdvSize(.T.)
Local clKey         := ""
Local clTab1	    := "SDS"
Local clTab2	    := "SDT"
Local clAwysT       := "AllwaysTrue()"
Local alCpoEnch     := {}
Local alHeaderDT    := {}
Local llPedCom      := .F.
Local llD1Imp       := .F.
Local nX					:= 0, nPos := 0 
Local lClass        := .F.

Private lMsErroAuto := .F.
Private aCols 	    := {}
Private aHeader     := GdMontaHeader(	@nlUsado     	 ,; //01 -> Por Referencia contera o numero de campos em Uso
@alDTVirt                ,; //02 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Virtuais
@alDTVisu                ,; //03 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Visuais
clTab2                   ,; //04 -> Opcional, Alias do Arquivo Para Montagem do aHeader
{"DT_FILIAL"} 			 ,; //05 -> Opcional, Campos que nao Deverao constar no aHeader
.F.                      ,; //06 -> Opcional, Carregar Todos os Campos
.F.                      ,; //07 -> Nao Carrega os Campos Virtuais
.F.                      ,; //08 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
NIL                      ,; //09 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
.T.                      ,; //10 -> Verifica se Deve Checar se o campo eh usado
.T.                      ,;
.F.                      ,;
.F.                      ,;
)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ POSICIONA A TABELA SDS / CARREGA VARIAVEIS DE MEMORIA   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(clTab1)
(clTab1)->( dbSetOrder(1) )
(clTab1)->( dbGoTop() )
(clTab1)->( dbSeek(xFilial(clTab1)+clNota+clSerie+clCodFor+clLoja) )
RegToMemory("SDS",.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CAMPOS USADOS PARA ENCHOICE   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//dbSelectArea("SX3")
SX3->( dbSetOrder(1) )
SX3->( dbSeek("SDS") )

alCpoEnch:={}
while !Eof().And.(SX3->X3_ARQUIVO=="SDS")
	
	V_CPO:=ALLTRIM(SX3->X3_CAMPO)
	If X3USO(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
		Aadd(alCpoEnch,V_CPO)
	Endif
	SX3->( DbSkip() )
	
enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA ACOLS   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SDT")
SDT->( dbSetOrder(1) )
SDT->( dbGoTop() )

alRecDT := {}
alHeaderDT:=aClone(aHeader)
clKey := xFilial("SDS")+M->DS_CNPJ+clCodFor+clLoja+clNota+clSerie
aCols := GdMontaCols(	@alHeaderDT		,; 	//01 -> Array com os Campos do Cabecalho da GetDados
@nlUsado		,;	//02 -> Numero de Campos em Uso
@alDTVirt		,;	//03 -> [@]Array com os Campos Virtuais
@alDTVisu   	,;	//04 -> [@]Array com os Campos Visuais
clTab2			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
NIL				,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
@alRecDT		,;	//07 -> [@]Array unidimensional contendo os Recnos
clTab1			,;	//08 -> Alias do Arquivo Pai
clKey  			,;	//09 -> Chave para o Posicionamento no Alias Filho
NIL				,;	//10 -> Bloco para condicao de Loop While
NIL				,;	//11 -> Bloco para Skip no Loop While
.F.				,;	//12 -> Se Havera o Elemento de Delecao no aCols
.F.				,;	//13 -> Se cria variaveis Publicas
.T.				,;	//14 -> Se Sera considerado o Inicializador Padrao
NIL				,;	//15 -> Lado para o inicializador padrao
NIL				,;	//16 -> Opcional, Carregar Todos os Campos
.F.				,;	//17 -> Opcional, Nao Carregar os Campos Virtuais
NIL				,;	//18 -> Opcional, Utilizacao de Query para Selecao de Dados
NIL				,;	//19 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
NIL				,;	//20 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
.F.				,;	//21 -> Carregar Coluna Fantasma
NIL				,;	//22 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
.T.				,;	//23 -> Verifica se Deve Checar se o campo eh usado
.T.				,;	//24 -> Verifica se Deve Checar o nivel do usuario
NIL				,;	//25 -> Verifica se Deve Carregar o Elemento Vazio no aCols
NIL				,;	//26 -> [@]Array que contera as chaves conforme recnos
NIL				,;	//27 -> [@]Se devera efetuar o Lock dos Registros
NIL				,;	//28 -> [@]Se devera obter a Exclusividade nas chaves dos registros
NIL				,;	//29 -> Numero maximo de Locks a ser efetuado
.F.				,;	//30 -> Utiliza Numeracao na GhostCol
NIL				,;	//31
2		    	 ;	//32 -> nOpc
)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MONTA TELA MODELO 3   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Mod3XML(	nlOpc,;            								  		// 01 -> Opcao
	"Visualiza Nf-e",;         								  		// 02 -> Titulo da Tela
	clTab1,;                  								  		// 03 -> Tabela para Enchoice
	clTab2,;               									 		// 04 -> Tabela para GetDados
	alCpoEnch,;                 							  		// 05 -> Campos Enchoice
	clAwysT,;                 								  		// 06 -> CampoOk
	clAwysT,;                  								 		// 07 -> LinhaOk
	nlOpc,;                 										// 08 -> Opcao Enchoice
	nlOpc,;                  										// 09 -> Opcao GetDados
	clAwysT,;                  										// 10 -> TdOk
	.T.,;                  											// 11 -> Se carrega Campos Virtuais
	alCpoEnch,;                  									// 12 -> Campos alterar
	GetRodape(clCodFor,clLoja,clNota,clSerie,clTab1) )  ;   		// 13 -> Array com as informacoes do Radape
	.AND. VldCpoProd(clCodFor,clLoja,clNota,clSerie,SDS->DS_TIPO)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICA AMARRAÇÕES  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgRun("Aguarde verificando amarrações...",,{|| CheckAmar(clCodFor,clLoja,clNota,clSerie) })	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ GERA A PRE-NOTA   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Begin Transaction
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ALIMENTA VETORES PARA A ROTINA AUTOMATICA (MSExecAuto)   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	alSF1:=F1Imp(clCodFor,clLoja,clNota,clSerie,clTab1)
	
	MsgRun("Aguarde...",,{|| iif(!Empty(alSD1:=D1Imp(clCodFor,clLoja,clNota,clSerie,clTab2)),llD1Imp:=.T.,llD1Imp:=.F.  ) } )
	MsgRun("Aguarde...",,{|| llPedCom := VldQtdPC(alSD1) } )
	
	If llD1Imp .AND. llPedCom
		
		lMsErroAuto := .F.
		MsgRun("Aguarde gerando Pré-Nota de Entrada...",,{|| MSExecAuto({|x,y,z| MATA140(x,y,z)},alSF1,alSD1,3 )})
		
		if !lMsErroAuto
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ APOS EXECUTADA A ROTINA AUTOMATICA                 ³
			//³ ATUALIZA REGISTRO ( STATUS, DATA IMPORTACAO ...)   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea(clTab1)
			(clTab1)->( dbSetOrder(1) )
			(clTab1)->( dbGoTop() )
			if (clTab1)->( dbSeek(xFilial(clTab1)+clNota+clSerie+clCodFor+clLoja) ) .and. RecLock(clTab1)
				
				(clTab1)->DS_USERPRE  := cUserName
				(clTab1)->DS_DATAPRE  := dDataBase
				(clTab1)->DS_HORAPRE  := Time()
				(clTab1)->DS_STATUS   := 'P' // P = PROCESSADA PELO PROTHEUS
				(clTab1)->( MsUnLock() )
				
				// Verifica se a classificação será realizar de imediato
			   	if lChkBoxClass
					lClass := .T. //SF1->(A103NFiscal("SF1", SF1->( Recno() ) , 4 ))
				else
					Aviso("Atenção", "Pré-Nota gerada com Sucesso!" ,{"Ok"})
				endif
				
			endIf
			
			//****************************************
			// SANGELLES VAI FICAR ESSE PT PRA VC
			// TEM QUE VER PQ O SISTEMA TA IGNORANDO 
			// O VALOR DE DESCONTO NO ITEM
			//****************************************
	
			_aSD1 := SD1->( GetArea() )

		

			SD1->( DbSetOrder(1) )
			SD1->( DbSeek( xFilial("SD1") + clNota + clSerie + clCodFor + clLoja ) )

			while !SD1->( Eof() ) .and. (xFilial("SD1") + clNota + clSerie + clCodFor + clLoja) == (xFilial("SD1") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA)

				RecLock("SD1",.F.)
				
				If !EMPTY(SDS->DS_TES)
					SD1->D1_TESACLA := SDS->DS_TES
				EndIf	
				SD1->D1_DFABRIC := POSICIONE("SDT",4,xFilial("SDT")+SD1->(D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE+D1_ITEM),"DT_XDFABRI")
				MSUNLOCK()
					
				SD1->( DbSkip() )
		
			enddo	
			
			RestArea(_aSD1) 
			
			
		else
			
			DisarmTransaction()
			lMsErroAuto := .F.
			MostraErro()
			
		endIf
		
	endif
	if lClass
		INCLUI := .F.  // Aluisio Gomes
		ALTERA := .T.
		SF1->(A103NFiscal("SF1", SF1->( Recno() ) , 4 ))
	Endif
	End Transaction 
EndIf
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | VldQtdPC   ³Autor ³ Totvs                       |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Essa funcao executada quando gera pre nota. Se retornar True     ³±±
±±³          | gera a rotina automatica.                                        ³±±
±±³          | Funcao verifica se a quant. do pedido de compra escolhido condiz ³±±
±±³          | com a quant. disponivel do pedido de compra (SC7) atualizado     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ alItns := Array com os itens (D1) para rotina automatica         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ llRet = Se .T. = OK                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ExecTela                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function VldQtdPC(alItns)
Local llRet     := .T.
Local nlK       := 0
Local llErro    := .F.
Local nlPedPos  := 0
Local nlItnPos  := 0
Local nlQtdPos  := 0
Local nlForPos  := 0
Local nlLojPos  := 0
Local nlNotPos  := 0
Local nlSerPos  := 0
Local nlCodPos  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ LACO PERCORRE O ARRAY DOS ITENS E FAZ VERIFICACAO SE O ITEM TIVER PED. DE COMPRA PREENCHIDO  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nlK:=1 to Len(alItns)
	
	If ((nlPedPos:=Ascan(alItns[nlK],{|x|X[1]=="D1_PEDIDO"}))>0) .AND. ((nlItnPos:=Ascan(alItns[nlK],{|x|X[1]=="D1_ITEMPC"}))>0)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VERIFICA AS POSICOES DOS CAMPOS NO ARRAY  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nlQtdPos := Ascan(alItns[nlK],{|x|X[1]=="D1_QUANT"})
		nlForPos := Ascan(alItns[nlK],{|x|X[1]=="D1_FORNECE"})
		nlLojPos := Ascan(alItns[nlK],{|x|X[1]=="D1_LOJA"})
		nlNotPos := Ascan(alItns[nlK],{|x|X[1]=="D1_DOC"})
		nlSerPos := Ascan(alItns[nlK],{|x|X[1]=="D1_SERIE"})
		nlCodPos := Ascan(alItns[nlK],{|x|X[1]=="D1_COD"})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VERIFICA SE NA TABELA DE PED. DE COMPRAS EXISTE REALMENTE A QUANT. DISPONIVEL ³
		//³ SE FOR TIVER DIFERENCA PARA MAIS, EXCLUI DA SDV                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC7")
		SC7->( dbSetOrder(1) )
		SC7->( dbGoTop() )
		If SC7->( dbSeek(xFilial("SC7")+PadR(alItns[nlK,nlPedPos,2],TamSx3("C7_NUM")[1])+ PadR(alItns[nlK,nlItnPos,2],TamSx3("C7_ITEM")[1])) )
			
			If nlQtdPos <> 0 .and. (alItns[nlK,nlQtdPos,2] > (SC7->C7_QUANT-SC7->C7_QTDACLA) )
				dbSelectArea("SDV")
				SDV->( dbSetOrder(1) )
				If SDV->( dbSeek( xFilial("SDV")+alItns[nlK,nlForPos,2]+alItns[nlK,nlLojPos,2]+alItns[nlK,nlNotPos,2]+alItns[nlK,nlSerPos,2]+alItns[nlK,nlCodPos,2]+alItns[nlK,nlPedPos,2]+alItns[nlK,nlItnPos,2] ) ) .and. RecLock("SDV")
					SDV->(DbDelete())
					SDV->( MsUnlock() )
					llErro:=.T.
					
				EndIf
				
			EndIf
			
		EndIf
		
	EndIf
	
Next nlK

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EXIBE MENSAGEM DE ERRO  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If llErro
	Aviso("Atenção","Erro ao importar a Pré-Nota",{"Ok"})
	llRet:=.F.
EndIf
Return llRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | VldCpoProd ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Verifica se o campo Produto esta preenchido. Caso nao esteja exec³±±
±±³          | funcao para que o usuario escolha qual produto se corresponde    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor  := Cod. Fornecedor/Cliente                             ³±±
±±³          | clLoja    := Loja                                                ³±±
±±³          | clNota    := Num. Nota                                           ³±±
±±³          | clSerie   := Serie                                               ³±±
±±³          | clTipo    := N = Nota fiscal Normal / B ou D = Benef./Devolucao  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ llRet = Se .T. = OK                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ExecTela                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function VldCpoProd(clCodFor,clLoja,clNota,clSerie, clTipo)
Local llRet     := .T.
Local nlK       := 0
Local nlPosCmp  := Ascan(aHeader,{|x|Alltrim(X[2])=="DT_COD"})
Local nlPosItem := Ascan(aHeader,{|x|Alltrim(X[2])=="DT_ITEM"})

For nlK:=1 to Len(aCols)
	If Empty(aCols[nlK,nlPosCmp])
		llRet:=EscolhaPrd(clCodFor,clLoja,clNota,clSerie,clTipo,nlK,nlPosCmp)
		Exit
	EndIf
Next nlK

Return llRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | EscolhaPrd ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Monta a tela com os produtos sem cod. para que usuario escolha   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor  := Cod. Fornecedor/Cliente                             ³±±
±±³          | clLoja    := Loja                                                ³±±
±±³          | clNota    := Num. Nota                                           ³±±
±±³          | clSerie   := Serie                                               ³±±
±±³          | clTipo    := N = Nota fiscal Normal / B ou D = Benef./Devolucao  ³±±
±±³          | nlK       := Primeira posicao do acols encontrada sem Cod. Prod. ³±±
±±³          | nlPosCmp  := Posicao no aHeader do campo "DT_COD"                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ llProcPrd = Se .T. = OK                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ VldCpoProd                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function EscolhaPrd(clCodFor,clLoja,clNota,clSerie, clTipo, nlK, nlPosCmp)

Local llProcPrd     :=.F.
Local alSize    	:= MsAdvSize()
Local nlTl1     	:= alSize[1]
Local nlTl2    		:= alSize[2]
Local nlTl3    		:= alSize[1]+300
Local nlTl4     	:= alSize[2]+520
Local olFont        := TFont ():New(,,-11,.T.,.T.,5,.T.,5,.F.,.F.)
Local llRetCons     := .F.
Local alHeaderTw    := {("Escolha produto"+Iif(AllTrim(clTipo)=="N","Fornecdor","Cliente" )),"Produto","Descrição"}
Local alTamHeader   := {60,60,100}
Local alRegs        := {}
Local olLisBox      := NIL
Local olBtInf       := NIL
Local alAlias       := Iif(AllTrim(clTipo)=="N",{"SA2","A2_NOME"},{"SA1","A1_NOME"})
Local nlCodPos      := Ascan(aHeader,{|x|Alltrim(X[2])=="DT_PRODFOR"})
Local nlPosItem     := Ascan(aHeader,{|x|Alltrim(X[2])=="DT_ITEM"})
Local nlCont        := 0
Private _opPPrDlg  	:= NIL
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | SELECIONA REGISTROS  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nlCont := nlK to Len(aCols)
	If Empty(aCols[nlCont,nlPosCmp])
		aAdd(alRegs,{aCols[nlCont,nlCodPos],"","",nlCont,aCols[nlCont,nlPosItem]})
	EndIf
Next nlCont

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | TELA - INTERFACE   |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DEFINE MSDIALOG _opPPrDlg TITLE "Seleção Produtos" From nlTl1,nlTl2 to nlTl3,nlTl4 PIXEL

// Box
@005,005 TO 35,257 LABEL "" OF _opPPrDlg PIXEL
//@(nlTl1+10),nlTl2 to (nlTl1+35),(nlTl2+237) PIXEL OF _opPPrDlg
@010,010 Say "Fornecedor: " + clCodFor + " - " + Posicione(alAlias[1],1,(xFilial(alAlias[1])+clCodFor+clLoja),alAlias[2])   Font olFont Pixel Of _opPPrDlg
@025,010 Say "Itens sem Còdigo:" Font olFont Pixel Of _opPPrDlg

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | TW BROWSE - ITENS DA NOTA |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	     //larg       //alt
olLisBox := TwBrowse():New(040,005,252,88,,alHeaderTw,alTamHeader,_opPPrDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
olLisBox:SetArray(alRegs)
olLisBox:bLine := {|| {alRegs[olLisBox:nAt,1],alRegs[olLisBox:nAt,2],alRegs[olLisBox:nAt,3]} }

// ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  BOTOES    |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
olBtInf  := TButton():New(133,005,"Selecionar Produto" ,_opPPrDlg,{|| (llRetCons:=ConPad1(,,,"SB1",,,.F.)),(Iif(llRetCons, ((alRegs[olLisBox:nAt,2]:=SB1->B1_COD),(alRegs[olLisBox:nAt,3]:=SB1->B1_DESC)) ,  ) )    } ,065,012,,,,.T.  )
DEFINE SBUTTON FROM 133,200 TYPE 1 ACTION (eVal( {|| llProcPrd:=PrcPrdOK(alRegs),  Iif((llProcPrd==.T.),(AtuSDT(alRegs,nlPosCmp,clCodFor,clLoja,clNota,clSerie, clTipo),_opPPrDlg:End()),Aviso("Atenção" ,"Produto não encontrado" ,{"Ok" }))   } )) ENABLE Of _opPPrDlg
DEFINE SBUTTON FROM 133,230 TYPE 2 ACTION (eVal( {|| Iif(MsgyESnO("Deseja sair?"),_opPPrDlg:End(),) } )) ENABLE Of _opPPrDlg

ACTIVATE DIALOG _opPPrDlg CENTERED

Return llProcPrd


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |AtuSDT	  ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao atualiza aCols e tabela SDT pela escolha do usuario       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ alRegs    := Array com os registros                              ³±±
±±³          | nlPosCmp  := Posicao no aHeader do Campo DT_COD                  ³±±
±±³          | clCodFor  := Cod. Fornecedor/Cliente                             ³±±
±±³          | clLoja    := Loja                                                ³±±
±±³          | clNota    := Num. Nota                                           ³±±
±±³          | clSerie   := Serie                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ EscolhaPrd                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function AtuSDT(alRegs,nlPosCmp,clCodForCli,clLoja,clNota,clSerie, clTipo)

Local nlK         := 0
Local nlPosDes 	  := Ascan(aHeader,{|x|Alltrim(X[2])=="DT_DESC"})
Local cProdForCli := ""
Local aArea		  := GetArea()
Local cItem		  := ""

For nlK:=1 to Len(alRegs)
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// | ATUALIZA ACOLS     |
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols[alRegs[nlK,Len(alRegs[nlK])-1],nlPosCmp] := alRegs[nlK,2]
	aCols[alRegs[nlK,Len(alRegs[nlK])-1],nlPosDes] := alRegs[nlK,3]
	
	cProdForCli := PadR(AllTrim(alRegs[nlK,1]),TamSx3("DT_PRODFOR")[1])
	cProdEmp	:= PadR(AllTrim(alRegs[nlK,2]),TamSX3("B1_COD")[1]		)
	cItem		:= alRegs[nlK,5]
	
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// | ATUALIZA RELACIONAMENTO PRODUTO X FORNECEDOR E TABELA SDT|
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GPrdxPrdF(clCodForCli, clLoja, clNota, clSerie, cProdForCli, cProdEmp, clTipo,cItem)
	
Next nlK

RestArea(aArea)
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | PrcPrdOK   ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Validacao do botao OK na tela de selecao de prod. correspondente ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ alRegs     := Array com os itens                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ EscolhaPrd                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function PrcPrdOK(alRegs)

Local llPrcPrdOk := .T.
Local nlT        := 0

For nlT:=1 to Len(alRegs)
	If Empty(alRegs[nlT,2])
		llPrcPrdOk := !llPrcPrdOk
		Exit
	EndIf
Next nlT
Return llPrcPrdOk


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |  GetRodape ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao que busca as inforamcoes do rodape da tela mod. 3         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor  := Cod. Fornecedor/Cliente                             ³±±
±±³          | clLoja    := Loja                                                ³±±
±±³          | clNota    := Num. Nota                                           ³±±
±±³          | clSerie   := Serie                                               ³±±
±±³          | clTab1    := Tabela SDS                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Array alNFe				                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ExecTela	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function GetRodape(clCodFor,clLoja,clNota,clSerie,clTab1)

Local alNFe 	:= {}

dbSelectArea(clTab1)
dbSetOrder(1)
&(clTab1)->(dbGoTop())
If dbSeek(xFilial(clTab1)+clNota+clSerie+clCodFor+clLoja)
	aAdd(alNFe, &(clTab1+"->DS_STATUS"  ))
	aAdd(alNFe, &(clTab1+"->DS_ARQUIVO" ))
	aAdd(alNFe, &(clTab1+"->DS_USERIMP" ))
	aAdd(alNFe, &(clTab1+"->DS_DATAIMP" ))
	aAdd(alNFe, &(clTab1+"->DS_HORAIMP" ))
EndIf


Return alNFe



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |  Mod3XML   ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Rotina principal para importar Schema XML                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nlOpc       := Opcao do Uusario (2-Visualizar/3-Gerar Pre Nota)  ³±±
±±³          | clTitle     := Titulo da Tela                                    ³±±
±±³          | clTab1      := Alias da Enchoice                                 ³±±
±±³          | clTab2      := Alias da GetDados                                 ³±±
±±³          | alCpoEnch   := Cmpos da Enchoice                                 ³±±
±±³          | clAwysT     := cLinhaOk                                          ³±±
±±³          | clAwysT     := cTudoOk                                           ³±±
±±³          | nlOpc1      := Opcao Enchoice                                    ³±±
±±³          | nlOpc2      := Opcao GetDados                                    ³±±
±±³          | clAwysT     := cFieldOk                                          ³±±
±±³          | llVirtual   := llVirtual (Campos Virtuais)                       ³±±
±±³          | alCpoEnch   := Campos Alteracao enchoice                         ³±±
±±³          | alInfRod    := Array com as informacoes do radpe 			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ llRet                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ExecTela	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function Mod3XML(nlOpc,clTitle,clTab1,clTab2,alCpoEnch,clAwysT,clAwysT,nlOpc1,nlOpc2,clAwysT,llVirtual,alAltEnch,alInfRod)

Local alAdvSz    := MsAdvSize()
Local alRNfe     := alInfRod
Local olFld      := NIL
Local llRet 	 := .F.
Local olFont     := TFont ():New(,,-11,.T.,.F.,5,.T.,5,.F.,.F.)
Local olFont2    := TFont ():New(,,-11,.T.,.T.,5,.T.,5,.F.,.F.)
Local clPicture  := "@E 999,999,999.99"
Local olEnch     := NIL
Local olGetDd    := NIL
Local olGetStats := NIL
Local olGetArq   := NIL
Local olGetUser  := NIL
Local olGetData  := NIL
Local olGetHora  := NIL
Local clGStatus  := Iif( Empty(Upper(alRNfe[1])),"???",Upper(alRNfe[1]))
Local clGNomArq  := Upper(alRNfe[2])
Local clGUser    := alRNfe[3]
Local dlGData    := alRNfe[4]
Local clGHora    := alRNfe[5]
Local nPosDesc	 := 0
Local nPosProd	 := 0
Local cDescProd	 := ""
Local nLoop
Local nLoops
Local aButtons	:= { {"VERNOTA" , {|| VisDocEntrada() }, 'Vis.Doc.Entrada','Vis.Doc.Entrada', {|| .T.}} }

Private aTrocaF3  := {}
Private _opMoD3lg := NIL

DEFINE MSDIALOG _opMoD3lg TITLE clTitle From alAdvSz[1],alAdvSz[2] to (alAdvSz[1]+450),(alAdvSz[2]+690) PIXEL

olFld := TFolder():New((alAdvSz[1]+151),(alAdvSz[2] + 005),{"Arquivos XML carregados"},{},_opMoD3lg,,,,.T.,.F., 334 , 068  )

// AJUSTA TELA PARA TEMA P10
If (Alltrim(GetTheme()) == "TEMAP10") .Or. SetMdiChild()
	_opMoD3lg:nHeight+=025
EndIf


// Muda Consulta padrao do cmapo DS_FORNEC para tabela de Clientes - SA1
IF AllTrim(SDS->DS_TIPO)<>"N"
	Aadd(aTrocaF3,{"DS_FORNEC", "SA1"} )
EndIf

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Monta enchoice e getDados 			  				  ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory(clTab1,.F.)
olEnch := Msmget():New(clTab1,&(clTab1)->(Recno()),3,,,,alCpoEnch,{15,5,80,340},{"DS_TES"},3,,,,_opMoD3lg,,.T.,,,,,,,,.T.)

If !(Type("aHeader") == "U") .AND. !(Type("aCols") == "U") .AND. ((nPosDesc := GDFieldPos("DT_DESC", aHeader))>0) .AND. ((nPosProd := GDFieldPos("DT_COD", aHeader))>0)
	
	nLoops := Len( aCols  )
	For nLoop := 1 To nLoops
		cDescProd := Posicione("SB1",1,xFilial("SB1")+aCols[nLoop][nPosProd],"B1_DESC")
		GdFieldPut( "DT_DESC" , cDescProd , nLoop , aHeader , aCols )
	Next nLoop
	
EndIf

olGetDd := MsGetDados():New(84,5,150,340,2,clAwysT,clAwysT,"",.T.,,,,,clAwysT)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Monta Rodape         ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// ---- NOTA FISCAL ELETRONICA
// Status
@(alAdvSz[1]+010),(alAdvSz[2]+5) Say "Status" Font olFont Pixel Of olFld:aDialogs[1]
olGetStats := TGet():New((alAdvSz[1]+08),(alAdvSz[2]+045),{|u| if(PCount()>0,clGStatus:=u,clGStatus)}, olFld:aDialogs[1] ,110,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"clGStatus")
// Arquivo
@(alAdvSz[1]+025),(alAdvSz[2]+5) Say "Arquivo" Font olFont Pixel Of olFld:aDialogs[1]
olGetArq := TGet():New((alAdvSz[1]+23),(alAdvSz[2]+045),{|u| if(PCount()>0,clGNomArq:=u,clGNomArq)}, olFld:aDialogs[1] ,110,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"clGNomArq")
// Usuario Import
@(alAdvSz[1]+010),(alAdvSz[2]+170) Say "Usuario Import" Font olFont Pixel Of olFld:aDialogs[1]
olGetUser := TGet():New((alAdvSz[1]+08),(alAdvSz[2]+240),{|u| if(PCount()>0,clGUser:=u,clGUser)}, olFld:aDialogs[1] ,70,10,,,,,,,,.T.,,,,,,,.T.,,,"clGUser")
// Data Import
@(alAdvSz[1]+025),(alAdvSz[2]+170) Say "Data Import" Font olFont Pixel Of olFld:aDialogs[1]
olGetData := TGet():New((alAdvSz[1]+23),(alAdvSz[2]+240),{|u| if(PCount()>0,dlGData:=u,dlGData)}, olFld:aDialogs[1] ,50,10,,,,,,,,.T.,,,,,,,.T.,,,"dlGData")
// Hora Import
@(alAdvSz[1]+040),(alAdvSz[2]+170) Say "Hora Import" Font olFont Pixel Of olFld:aDialogs[1]
olGetHora := TGet():New((alAdvSz[1]+38),(alAdvSz[2]+240),{|u| if(PCount()>0,clGHora:=u,clGHora)}, olFld:aDialogs[1] ,40,10,,,,,,,,.T.,,,,,,,.T.,,,"clGHora")

ACTIVATE DIALOG _opMoD3lg ON INIT (EnchoiceBar(_opMoD3lg,  {|| (Iif((nlOpc==3),llRet:=.T.,),_opMoD3lg:End()) } , {|| _opMoD3lg:End()},  , @aButtons )) CENTERED
If M->DS_TES <> SDS->DS_TES .AND. llRet
	RECLOCK("SDS",.F.)
	SDS->DS_TES := M->DS_TES
	SDS->(MSUNLOCK())
EndIf
Return llRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |  D1Imp     ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Carrega Array com os itens da nota fiscal para rotina automatica ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor = Cod. Fornecedor                                       ³±±
±±³          | clLoja   = Loja                                                  ³±±
±±³          | clNota   = Num. NOta                                             ³±±
±±³          | clSerie  = Serie                                                 ³±±
±±³          | clTab    = Tabela de itens - SDT                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alRet = array com os dados para execucao da rotina automatica    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ExecTela	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function D1Imp(clCodFor,clLoja,clNota,clSerie,clTab)
Local alItens	 := {}
Local alRet    := {}
Local nlQtd    := 0
Local nlCont	 := 0
Local alBaseImp:= {}
Local alAliqImp:= {}
Local cTesProd := " "
Local _nOpc		 := 0
Local alTamSDV   := {TAMSX3("DV_FORNEC")[1],TAMSX3("DV_LOJA")[1],TAMSX3("DV_DOC")[1],TAMSX3("DV_SERIE")[1],TAMSX3("DV_PROD")[1],TAMSX3("DV_NUMPED")[1],TAMSX3("DV_ITEMPC")[1],TAMSX3("DV_ITEMXML")[1]}
Local nlPosProd  := Ascan(aHeader,{|x|Alltrim(X[2])=="DT_COD"})
Local nlPosItem  := Ascan(aHeader,{|x|Alltrim(X[2])=="DT_ITEM"})
local cUM		 := ""
Local cUM2		 := ""
Local _nSDT		 := 0

SDT->( DbSetOrder(1), dbSeek( xFilial("SDT")+clCodFor+clLoja+clNota+clSerie ) )

for nlCont:=1 to Len(aCols)
	
	alBaseImp := {}
	alAliqImp := {}
	
	SDT->(DbSetOrder(4))
	SDT->(DbGoTop())

	if SDT->(DbSeek(xFilial("SDT")+clCodFor+clLoja+clNota+clSerie+aCols[nlCont,nlPosItem]))

		_nSDT := SDT->( RecNo() )
		cTesProd := Posicione("SB1",1,xFilial("SB1")+Alltrim(aCols[nlCont,nlPosProd]),"B1_TE")
		cUM := Posicione("SB1",1,xFilial("SB1")+Alltrim(aCols[nlCont,nlPosProd]),"B1_UM")
		cUM2 := Posicione("SB1",1,xFilial("SB1")+Alltrim(aCols[nlCont,nlPosProd]),"B1_SEGUM")		
		alItens:={}

		aAdd(alItens,{"D1_FILIAL"   , SDT->DT_FILIAL         	,NIL})
		aAdd(alItens,{"D1_DOC"      , SDT->DT_DOC            	,NIL})
		aAdd(alItens,{"D1_SERIE"    , SDT->DT_SERIE				,NIL})
		aAdd(alItens,{"D1_FORNECE"  , SDT->DT_FORNEC         	,NIL})
		aAdd(alItens,{"D1_LOJA"     , SDT->DT_LOJA           	,NIL})
		aAdd(alItens,{"D1_ITEM"     , StrZero(Len(alRet)+1,4),NIL})
		aAdd(alItens,{"D1_COD"      , SDT->DT_COD            	,NIL})

		SDV->(DbSetOrder(1))		
		aAdd(alItens,{"D1_VUNIT"    , SDT->DT_VUNIT     	    ,NIL})
        IF UPPER(Alltrim(cUM))== UPPER(AllTrim(SDT->DT_XUM))// Verifica unidade de media -- Aluisio Gomes        	
			aAdd(alItens,{"D1_QUANT"    , SDT->DT_QUANT		       	,NIL})
        ElseIf UPPER(Alltrim(cUM2))== UPPER(AllTrim(SDT->DT_XUM))
			aAdd(alItens,{"D1_QTSEGUM"  , SDT->DT_QUANT		       	,NIL})
		Else				         
			_nOpc := aviso("Erro UM","Unidade de medida '"+SDT->DT_XUM+"', do XML  não encontrado no cadastro de produtos, selecione a unidade correspondente",{cUM,cUM2,"Cancelar"})
			IF _nOpc == 1
				aAdd(alItens,{"D1_QUANT"    , SDT->DT_QUANT		       	,NIL})
			ElseIf _nOpc == 2
				aAdd(alItens,{"D1_QTSEGUM"  , SDT->DT_QUANT		       	,NIL})
			Else
				alRet:= {}
				Return alRet
			EndIf 				
		EndIf	
		aAdd(alItens,{"D1_TOTAL"    , SDT->DT_TOTAL			    ,NIL}) 
	   	aAdd(alItens,{"D1_VALDESC"  , SDT->DT_VALDESC		    ,NIL})  
	   	if SDV->(DbSeek(xFilial("SDV") + PadR(clCodFor,alTamSDV[1]) + PadR(clLoja,alTamSDV[2]) + PadR(clNota,alTamSDV[3]) + PadR(clSerie,alTamSDV[4]) + PadR(SDT->DT_ITEM,alTamSDV[8])) )		
			aAdd(alItens,{"D1_PEDIDO"  	, SDV->DV_NUMPED      	,NIL})
			aAdd(alItens,{"D1_ITEMPC"  	, SDV->DV_ITEMPC      	,NIL})
		else
			//aAdd(alItens,{"D1_PEDIDO"  	, ""       	  			,NIL})
			//aAdd(alItens,{"D1_ITEMPC"  	, ""      	  			,NIL})
		endIf                      
	   	aAdd(alItens,{"D1_TES"  , IIF(!EMPTY(SDS->DS_TES),SDS->DS_TES,cTesProd)   ,NIL})
	   	aAdd(alItens,{"D1_DFABRIC"    , SDT->DT_XDFABRI    ,NIL})
		aAdd(alItens,{"D1_LOTECTL"    , SDT->DT_XLOTECT    ,NIL})
		aAdd(alItens,{"D1_DTVALID"    , SDT->DT_XDTVLD    ,NIL})  
								
		aParx := {alItens}
	
		IF ExistBlock("PCOMP001")
			aParx 	 := ExecBlock("PCOMP001",.F.,.F.,aParx )
			alItens := aParx[1]
		endif
		
		//Sangelles Moraes 20/12/2013 Ponto de Entrada - 		
		aAdd(alRet,alItens)  
		
		SDT->( DbGoTo(_nSDT) )
		
	EndIf
	
Next nlCont
Return alRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | F1Imp   	  ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Carrega Array com o cabecalho da nota fiscal para rotina automat.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor = Cod. Fornecedor                                       ³±±
±±³          | clLoja   = Loja                                                  ³±±
±±³          | clNota   = Num. NOta                                             ³±±
±±³          | clSerie  = Serie                                                 ³±±
±±³          | clTab    = Tabela de cabecalho - SDS                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alCabec = array com os dados para execucao da rotina automatica  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ExecTela	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function F1Imp(clCodFor,clLoja,clNota,clSerie,clTab)
Local alCabec:={}

dbSelectArea(clTab)
(clTab)->( dbSetOrder(1) )
(clTab)->( dbGoTop() )
If (clTab)->( dbSeek(xFilial(clTab)+clNota+clSerie+clCodFor+clLoja) )
	aAdd(alCabec,{"F1_FILIAL"      ,SDS->DS_FILIAL         ,Nil})
	aAdd(alCabec,{"F1_TIPO"        ,SDS->DS_TIPO           ,Nil})
	aAdd(alCabec,{"F1_FORMUL"      ,SDS->DS_FORMUL         ,Nil})
	aAdd(alCabec,{"F1_DOC"         ,SDS->DS_DOC            ,Nil})
	aAdd(alCabec,{"F1_SERIE"       ,SDS->DS_SERIE          ,Nil})
	aAdd(alCabec,{"F1_EMISSAO"     ,SDS->DS_EMISSA		 			,Nil})
	aAdd(alCabec,{"F1_FORNECE"     ,SDS->DS_FORNEC         ,Nil})
	aAdd(alCabec,{"F1_LOJA"        ,SDS->DS_LOJA           ,Nil})
	aAdd(alCabec,{"F1_ESPECIE"     ,SDS->DS_ESPECI         ,Nil})
	aAdd(alCabec,{"F1_DTDIGIT"     ,SDS->DS_DATAIMP			,Nil})
	aAdd(alCabec,{"F1_EST"         ,SDS->DS_EST				,Nil})
	aAdd(alCabec,{"F1_HORA"        ,SubStr(Time(),1,5)			,Nil})
	aAdd(alCabec,{"F1_CHVNFE"      ,SDS->DS_CHAVENF					,Nil})
	aAdd(alCabec,{"F1_CODNFE"	   ,SDS->DS_CHAVENF					,Nil})
	
	aAdd(alCabec,{"F1_FRETE"   	   ,SDS->DS_FRETE					,Nil})
	aAdd(alCabec,{"F1_SEGURO "     ,SDS->DS_SEGURO					,Nil})
	aAdd(alCabec,{"F1_DESPESA"     ,SDS->DS_DESPESA					,Nil})
	aAdd(alCabec,{"F1_DESCONT"     ,SDS->DS_DESCONT					,Nil})	// ANDERSON

EndIf
// (clTab)->(dbCloseArea())
Return alCabec

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    | XmlRetNome ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Rotina chamada no inicializador padrão do campo DS_NOME (virtual)³±±
±±³          | posiciona na tabela correta (Fornecedor/Cliente) e retorna nome  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor = Cod. Fornecedor                                       ³±±
±±³          | clLoja   = Loja                                                  ³±±
±±³          | clTipo   = Tipo da Nota (NORMAL/DEVOLUCAO/BENEFICIAMNETO)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ clNomeRet = Nome do fornecedor ou cliente                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO		                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function XmlRetNome(clForCli,clLoja,clTipo)
Local clNomeRet := ""
Local clAlias   := Iif((AllTrim(clTipo)<>"N"),"SA1","SA2")
clNomeRet := POSICIONE(clAlias,1,(XFILIAL(clAlias)+clForCli+clLoja),(Right(clAlias,2)+"_NOME") )
Return clNomeRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    |GPrdxPrdF   ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Grava relacinamento Produto x Produto do Pornecedor				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Cod. Fornecedor|Cliente                                  ³±±
±±³			 ³ ExpC2 = Loja Fornecedor|Cliente                                  ³±±
±±³			 ³ ExpC3 = Nota Fiscal		                                        ³±±
±±³			 ³ ExpC4 = Serie da Nota                                            ³±±
±±³			 ³ ExpC5 = Produto Clinte/Fornecedor                                ³±±
±±³			 ³ ExpC6 = Cod. Produto		                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil										                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SelePed, RPrdxPrdF, ProcPCxNFe, AtuSDT							³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function GPrdxPrdF(clCodForCli, clLoja, clNota, clSerie, cProdForCli, cProdEmp , cTipo , cItem)

Local aArea		:= GetArea()
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | GRAVA RELACIONAMENTO PARA PROXIMA IMPORTACAO |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SDT")
SDT->(dbSetOrder(4))
If SDT->(dbSeek(xFilial("SDT")+clCodForCli+clLoja+clNota+clSerie+cItem))
	If RecLock("SDT",.F.)
		SDT->DT_COD 	:= cProdEmp
		SDT->DT_PEDIDO	:= ""
		SDT->DT_ITEMPC	:= ""
		SDT->(MsUnLock())
	EndIf
EndIf

RestArea(aArea)
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rotina    | PrdxForCli		   ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Valida se existe amarração entre Produto x Fornecedor/Cliente	   	     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Cod. Fornecedor|Cliente                                 			 ³±±
±±³			 ³ ExpC2 = Loja Fornecedor|Cliente                                    		 ³±±
±±³			 ³ ExpC3 = Cod. Produto		                                          		 ³±±
±±³			 ³ ExpC4 = Tipo da Nota		                                          		 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cProdEmp = Produto relacionado ao Forncedor/Cliente                		 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ProcPCxNFe                                                        	     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function PrdxForCli(clCodForCli, clLoja, clCodProd,clTipo)

Local cWAlias 	:= ""
Local cProdEmp	:= ""
Local nOrd		:= 1

If clTipo<>"N"
	cWAlias := "SA7"
	nOrd := RetOrder("SA7", "A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO")
Else
	cWAlias := "SA5"
	nOrd	:= RetOrder("SA5", "A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO")
EndIf

DbSelectArea(cWAlias)
(cWAlias)->(DbSetOrder( nOrd ))

If ( (cWAlias)->(dbSeek(xFilial(cWAlias)+clCodForCli+clLoja+clCodProd )) )
	If cWAlias == "SA5"
		cProdEmp := SA5->A5_PRODUTO
	Else
		cProdEmp := SA7->A7_PRODUTO
	EndIf
EndIf

Return cProdEmp

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |  PesqCGC   ³Autor ³ Totvs                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao pesquisa no SM0 para qual empresa/filial é destinado a NFe³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCGC = CNPJ informado no arquivo XML                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alRet = Array de 2 posicoes                                      ³±±
±±³          | 		[ 1 ] = COD. EMPRESA                                        ³±±
±±³          | 		[ 2 ] = COD. FILIAL                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function PesqCGC(clCGC)
Local alAreaSM0 := SM0->( GetArea() )
Local aCodEmpFil:= {}

SM0->( dbGoTop() )
while !SM0->( eof() ) .and. !Empty(clCGC)
	
	If SM0->M0_CGC = clCGC
		aAdd(aCodEmpFil, {SM0->M0_CODIGO, SM0->M0_CODFIL})
		exit
	Endif
	SM0->( dbSkip() )
	
Enddo
RestArea(alAreaSM0)
Return aCodEmpFil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³READXML  ºAutor  ³Totvs                 º Data ³  28/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ConsNFeChave(cChaveNFe,cIdEnt,lWeb)

Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cMensagem:= ""
Local oWS
Local lErro := .F.
Local lValidaSefaz	:= GetNewPar("MV_XVALNFE",.T.)  

/*
//tratamento para não gerar erro, quando o array vazio
if Empty(oDados:aArray)
Return .F.
endif
*/

if !lValidaSefaz
	Return .F.
endif

If ValType(lWeb) == 'U'
	lWeb := .F.
EndIf

oWs:= WsNFeSBra():New()
oWs:cUserToken  := "TOTVS"
oWs:cID_ENT    	:= cIdEnt
ows:cCHVNFE		:= cChaveNFe
oWs:_URL        := AllTrim(cURL)+"/NFeSBRA.apw"

If oWs:ConsultaChaveNFE()
	cMensagem := ""
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
		cMensagem += "Versão da Mensagem"+": "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
	EndIf
	cMensagem += "Ambiente"+": "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,"Produção","Homologação")+CRLF //"Produção"###"Homologação"
	cMensagem += "Cod.Ret.NFe"+": "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
	cMensagem += "Msg.Ret.NFe"+": "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
	
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
		cMensagem += "Protocolo"+": "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF
		cProtocolo := oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO
	EndIf
	
	//QUANDO NAO ESTIVER OK NAO IMPORTA, CODIGO DIFERENTE DE 100
	If oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE # "100"
		lErro := .T.
	EndIf
	
	if !lWeb
		Aviso("Consulta NF",cMensagem,{"Ok"},3)
	else
		Return( lErro )	//,cMensagem} )
	endIf
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
EndIf
if oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE == "REJEIÇÃO: NF-E NÃO CONSTA NA BASE DE DADOS DA SEFAZ" .AND. oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE == 2
	
	if MsgYesNo("Por se tratar de um ambiente Homologação deseja fazer a importação da Nota?") 
		lErro := .F.                                                                               
	endif
endif
Return(lErro)

//**********************************************************************
// Descrição: Verifica se o método / ação para o serviço Existe. 133:
// Retorna Handle do Método. Caso não exista , retorna 0
//**********************************************************************
Static Function XMLFind(oObj,cFind)
Local ixy:=1, lRet := .F.

for ixy:=1 to 100
	
	if ValType( XmlGetChild(oObj,ixy) ) == "U"
		Exit
	elseif cFind $ XmlGetChild(oObj,ixy):Text
		Return .T.
	endif
	
next ixy
Return lRet

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ EnviarEmail ¦ Autor ¦                    ¦ Data ¦ 29/08/02 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Funcao para enviar email                                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Geral                                                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
//Funcao....: ENVIAREMAIL()
//Parametros: cArquivo: Dir\Nome         (C)
//            cTitulo : Titulo da Tela   (C)
//            cSubject: Titulo do E-Mail (C)
//            cBody   : Corpo do E-Mail  (C)
//            lShedule: Se for Shedulado (L)
//            cTo     : E-Mail destino   (C)
//            cCc     : E-Mail Copia     (C)
//Retorno...: .T./.F.
Static Function AXMLEnvMai(cArquivo,cTitulo,cSubject,cBody,lShedule,cTo,cCC)
*-----------------------------------------------------------------------------------------*
LOCAL cServer, cAccount, cPassword, lAutentica, cUserAut, cPassAut
LOCAL cUser,lMens:=.T.,nOp:=0,oDlg
DEFAULT cArquivo := ""
DEFAULT cTitulo  := ""
DEFAULT cSubject := ""
DEFAULT cBody    := ""
DEFAULT lShedule := .F.
DEFAULT cTo      := ""
DEFAULT cCc      := ""

if Empty((cServer:=AllTrim(GetNewPar("MV_RELSERV",""))))
	
	if !lShedule
		MSGINFO("Nome do Servidor de Envio de E-mail nao definido no 'MV_RELSERV' (Importação de XML) Data: "+dtoc(ddatabase)+ "Hora: "+time())
	else
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Nome do Servidor de Envio de E-mail nao definido no 'MV_RELSERV' ")
	endif
	Return .F.
	
endif

if Empty( (cAccount:=AllTrim(GetNewPar("MV_RELACNT",""))) )
	
	if !lShedule
		MSGINFO("Conta para acesso ao Servidor de E-mail nao definida no 'MV_RELACNT'(Importação de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time())
	else
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Conta para acesso ao Servidor de E-mail nao definida no 'MV_RELACNT' ")
	endif
	Return .F.
	
endif

if	lShedule .AND. EMPTY(cTo)
	
	ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " E-mail para envio, nao informado.")
	Return .F.
	
endif

if !lShedule
	cFrom:= UsrRetMail( RetCodUsr() )
	cUser:= UsrRetName( RetCodUsr() )
else
	cFrom:= cAccount
	cUser:= "NF-e Importador"
endif

cCC  := cCC + SPACE(200)
cTo  := cTo + SPACE(200)
cSubject:=cSubject+SPACE(100)

if empty(cFrom)
	
	if !lShedule
		MsgInfo("E-mail do remetente nao definido no cad. do usuario: "+cUser +" (Importação de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time())
	else
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " E-mail do remetente nao definido no cad. do usuario: "+cUser)
	endif
	Return .F.
	
endif

while !lShedule
	
	nOp  :=0
	nCol1:=8
	nCol2:=33
	nSize:=225
	nLinha:=15
	
	DEFINE MSDIALOG oDlg OF oMainWnd FROM 0,0 TO 350,544 PIXEL TITLE "Envio de E-mail"
	
	@ nLinha,nCol1 Say "Titulo:"  Size 12,8              OF oDlg PIXEL
	@ nLinha,nCol2 MSGET cTitulo  SIZE nSize,10 WHEN .F. OF oDlg PIXEL
	nLinha+=15
	
	@ nLinha,nCol1 Say "Usuario:" Size 20,8              OF oDlg PIXEL
	@ nLinha,nCol2 MSGET cUser    SIZE nSize,10 WHEN .F. OF oDlg PIXEL
	nLinha+=20
	
	@ 000005,nCol1-4 To nLinha   ,268 LABEL " Informacoes " OF oDlg PIXEL
	nLinha+=05
	nLinAux:=nLinha
	nLinha+=10
	
	@ nLinha,nCol1 Say   "De:"      Size 012,08             OF oDlg PIXEL
	@ nLinha,nCol2 MSGET cFrom      Size nSize,10 WHEN .F.  OF oDlg PIXEL
	nLinha+=15
	
	@ nLinha,nCol1 Say   "Para:"    Size 016,08             OF oDlg PIXEL
	@ nLinha,nCol2 MSGET cTo        Size nSize,10  F3 "_EM" OF oDlg PIXEL
	nLinha+=15
	
	@ nLinha,nCol1 Say   "CC:"      Size 016,08             OF oDlg PIXEL
	@ nLinha,nCol2 MSGET cCC        Size nSize,10  F3 "_EM" OF oDlg PIXEL
	nLinha+=15
	
	@ nLinha,nCol1 Say   "Assunto:" Size 021,08             OF oDlg PIXEL
	@ nLinha,nCol2 MSGET cSubject   Size nSize,10           OF oDlg PIXEL
	nLinha+=15
	
	@ nLinha,nCol1 Say   "Corpo:"   Size 016,08             OF oDlg PIXEL
	@ nLinha,nCol2 Get   cBody      Size nSize,20  MEMO     OF oDlg PIXEL HSCROLL
	
	@ nLinAux,nCol1-4 To nLinha+28,268 LABEL " Dados de Envio " OF oDlg PIXEL
	nLinha+=35
	
	DEFINE SBUTTON FROM nLinha,(oDlg:nClientWidth-4)/2-90 TYPE 1 ACTION (If(Empty(cTo),Help("",1,"AVG0001054"),(oDlg:End(),nOp:=1))) ENABLE OF oDlg PIXEL
	DEFINE SBUTTON FROM nLinha,(oDlg:nClientWidth-4)/2-45 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	if nOp = 0
		Return .T.
	endif
	
	Exit
	
enddo

cAttachment:= cArquivo
cPassword  := AllTrim(GetNewPar("MV_RELPSW"," "))
lAutentica := GetMv("MV_RELAUTH",,.F.)          	//Determina se o Servidor de Email necessita de Autenticação
cUserAut   := Alltrim(GetMv("MV_RELAUSR",," "))		//Usuário para Autenticação no Servidor de Email
cPassAut   := Alltrim(GetMv("MV_RELAPSW",," "))		//Senha para Autenticação no Servidor de Email
//cTo := AvLeGrupoEMail(cTo)
//cCC := AvLeGrupoEMail(cCC)

if Empty(cUserAut)
	cUserAut := cAccount
endif

if Empty(cPassAut)
	cPassAut := cPassword
endif

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lOK

If !lOK
	if !lShedule
		MsgInfo("Falha na Conexão com Servidor de E-Mail(Importação de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time())
	else
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Falha na Conexão com Servidor de E-Mail ")
	endif
	
else
	if lAutentica .and. !MailAuth(cUserAut,cPassAut)
		MSGINFO("Falha na Autenticacao do Usuario")
		DISCONNECT SMTP SERVER RESULT lOk
	endif
	
	if !EMPTY(cCC)
		SEND MAIL FROM cFrom TO cTo CC cCC SUBJECT cSubject BODY cBody ATTACHMENT cAttachment RESULT lOK
	else
		SEND MAIL FROM cFrom TO cTo SUBJECT cSubject BODY cBody ATTACHMENT cAttachment RESULT lOK
	endif
	
	if !lOK
		
		if !lShedule
			MsgInfo("Falha no Envio do E-Mail: "+ALLTRIM(cTo)+"(Importação de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time())
		else
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Falha no Envio do E-Mail")
		endif
		
	endif
	
endif

DISCONNECT SMTP SERVER

if lOk
	
	if !lShedule
		MsgInfo("E-mail enviado com sucesso: "+ALLTRIM(cTo)+"(Importação de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time())
	else
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " E-mail enviado com sucesso: "+ALLTRIM(cTo))
	endif
	
endif

Return .T.





////////////////////////////////////////////////////////////////////////////////
// inserido/alterado por: #toya:27/03/2012:07:35
////////////////////////////////////////////////////////////////////////////////
User function LerNFePortal(_cChave, _nPortal)
local oWndAux

private oOle, oOleDoc:=Array(2)

DEFAULT _cChave := "52120701425693000127550010000148211003068875"
DEFAULT _nPortal:=1

DEFINE WINDOW oWndAux TITLE "iNFexHB - Consultar NFe Completa"
ACTIVATE WINDOW oWndAux MAXIMIZED ON INIT LerNFePortalGet(oWndAux, _cChave, _nPortal)
return .t.


#define SW_RESTORE    9

////////////////////////////////////////////////////////////////////////////////
// inserido/alterado por: #toya:27/03/2012:10:19
////////////////////////////////////////////////////////////////////////////////
static function LerNFePortalGet(oWndAux, _cChave, _nPortal)
local cUrl:=""
local oDados, oOleDoc := Array(2)
local hWnd

oOle:= CreateObject("InternetExplorer.Application")
oOle:Visible:=.T.   // Apresenta o Browser
oOle:ToolBar:=.F.   // Desativa a barra de ferramentas
oOle:StatusBar:=.f. // Desativa a barra de status
oOle:MenuBar:=.f.   // desativa a barra de menu
oOle:top:=GetSysMetrics(06)+GetSysMetrics(04)
oOle:left:=GetSysMetrics(5)
oOle:Width(oWndAux:nWidth - GetSysMetrics(5)*2)
oOle:Height(oWndAux:nHeight - (oOle:top + GetSysMetrics(6)+10))
hWnd:=oOle:HWND
BringWindowToTop(hWnd)
ShowWindow(hWnd, SW_RESTORE)
If _nPortal == 1
	cUrl:="http://www.nfe.fazenda.gov.br/portal/consulta.aspx?tipoConsulta=completa&tipoConteudo=XbSeqxE8pl8="
Else
	cUrl:="http://nfe.fazenda.sp.gov.br/ConsultaNFe/consulta/publica/ConsultarNFe.aspx" // SAO PAULO
EndIf
oOle:Navigate2(cUrl)
WHILE oOle:Busy
	syswait(.5)
END
oDados := oOle:Document()
if _nPortal == 1
	oDados:All:Item("ctl00$ContentPlaceHolder1$txtChaveAcessoCompleta",0):Value := _cChave
	oDados:All:Item("ctl00$ContentPlaceHolder1$txtCaptcha",0):Focus()
else
	oDados:All:Item("ctl00$ContentMain$tbxIdNFe"):Value := _cChave
	oDados:All:Item("ctl00$ContentMain$tbxCaptcha",0):Focus()
endif
oDados:=Nil
SysRefresh()
return nil



Static Function vChvNfe(cGetChvNFe,olLBox,alItBx,clLine,alCpos,alParam, clFilBrw)
Local cTCFilterEX 	:= "TCFilterEX"
Local aArea			:= GetArea()

do case
	case Empty(cGetChvNFe) .or. Len( AllTrim(cGetChvNFe) ) < 44
		cGetChvNFe := space( len(SF2->F2_CHVNFE) )
		Return .T.
endcase

clFilBrw := " DS_CHAVENF == '" + cGetChvNFe + "' "

DbSelectArea("SDS")
&cTCFilterEX.(clFilBrw,1)

AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
olLBox:Refresh()

RestArea(aArea)
Return .T.


Static Function DownLoadXML()

Local cIniName:= GetRemoteIniName()
Local lUnix:= IsSrvUnix()
Local nPos:= Rat( IIf(lUnix,"/","\"),cIniName )
Local cPathRmt
if nPos!=0
	cPathRmt:= Substr( cIniName,1,nPos-1 )
endif

WinExec(cPathRmt + "\xml\DanfeToXML.exe")
Return .T.


Static Function VisDocEntrada()
if SF1->( DbSetOrder(1), DbSeek( xFilial("SF1") + SDS->DS_DOC + SDS->DS_SERIE + SDS->DS_FORNEC + SDS->DS_LOJA ) )
	SF1->( A103NFiscal("SF1", SF1->( Recno() ) , 2 ) )
endif
Return .T.


Static Function ExclDocEntrada(oDados, alCpos)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as posicoes/ordens dos campos no array       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nlPosCFor := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_FORNEC"})
Local nlPosLoja := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_LOJA"})
Local nlPosNum  := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_DOC"})
Local nlPosSer  := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_SERIE"})
Local nlPosCHNF := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_CHAVENF"})
Local nPos 		:= oDados:nAt

PRIVATE L140EXCLUI := .T.
PRIVATE aRotina	:= {	{,"AxPesqui"		, 0 , 1, 0, .F.},; //
{ "Visualizar","A140NFiscal"	, 0 , 2, 0, .F.},; //
{ "Incluir"	,"A140NFiscal"	, 0 , 3, 0, nil},; //
{ "Alterar"	,"A140NFiscal"	, 0 , 4, 0, nil},; //
{ "Excluir"	,"A140NFiscal"	, 0 , 5, 0, nil},; //
{ "Imprimir","A140Impri"  	, 0 , 4, 0, nil},; //
{ "Estorna Classificacao"	,"A140EstCla" 	, 0 , 5, 0, nil},; //
{ "Legenda"	,"A103Legenda"	, 0 , 2, 0, .F.}} 	//

//tratamento para não gerar erro, quando o array vazio
if Empty(oDados:aArray)
	return .T.
endif

SDS->( DbSetOrder(1), DbSeek( xFilial("SDS") + ;
oDados:aArray[nPos][nlPosNum] + ;
oDados:aArray[nPos][nlPosSer] + ;
oDados:aArray[nPos][nlPosCFor] + ;
oDados:aArray[nPos][nlPosLoja] ) )


Pergunte("MTA140",.F.)

if SF1->( DbSetOrder(1), DbSeek( xFilial("SF1") + SDS->DS_DOC + SDS->DS_SERIE + SDS->DS_FORNEC + SDS->DS_LOJA ) )
	
	SD1->( DbSetOrder(1), DbSeek( xFilial("SD1") + SDS->DS_DOC + SDS->DS_SERIE + SDS->DS_FORNEC + SDS->DS_LOJA ) )
	SA2->( DbSetOrder(1), DbSeek( xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA ) )
	SF1->( A140NFiscal("SF1", SF1->( Recno() ), 5, ,.T. ) )	//Nota Já Classificada
	
elseif Aviso("XML","Deseja excluir o XML importado?",{"Sim","Não"}) == 1	// Entao e para excluir o XML importado?
	dbSelectArea("SDV")
	SDV->( dbSetOrder(1) )
	SDV->( dbSeek(xFilial("SDV") + PadR(oDados:aArray[nPos][nlPosCFor],TamSX3("DV_FORNEC")[1]) + PadR(oDados:aArray[nPos][nlPosLoja],TamSx3("DV_LOJA")[1]) + oDados:aArray[nPos][nlPosNum]  + oDados:aArray[nPos][nlPosSer] ) )
	
	while SDV->(DV_FILIAL+DV_FORNEC+DV_LOJA+DV_DOC+DV_SERIE) == (xFilial("SDV") + PadR(oDados:aArray[nPos][nlPosCFor],TamSX3("DV_FORNEC")[1]) + PadR(oDados:aArray[nPos][nlPosLoja],TamSx3("DV_LOJA")[1]) + oDados:aArray[nPos][nlPosNum]  + oDados:aArray[nPos][nlPosSer])
		
		RecLock("SDV")
		SDV->( DbDelete() )
		SDV->( DbUnLock() )
		
		SDV->( DbSkip() )
		
	enddo
	
	SDT->( DbSetOrder(3)) //DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE
	SDT->( DbSeek(xFilial("SDT") + oDados:aArray[nPos][nlPosCFor] + oDados:aArray[nPos][nlPosLoja] + oDados:aArray[nPos][nlPosNum]  + oDados:aArray[nPos][nlPosSer] ))
	
	While SDT->(!Eof()) .AND. SDT->(DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE) == (xFilial("SDT") + oDados:aArray[nPos][nlPosCFor] + oDados:aArray[nPos][nlPosLoja] + oDados:aArray[nPos][nlPosNum]  + oDados:aArray[nPos][nlPosSer])
		
		RecLock("SDT",.F.)
		SDT->( DbDelete() )
		SDT->( DbUnLock() )
		
		SDT->( DbSkip() )
		
	enddo
	
	RecLock("SDS",.F.)
	SDS->( DbDelete() )
	SDS->( DbUnLock() )
	
endif

Return .T.



Static Function CheckAmar(clCodFor,clLoja,clNota,clSerie)
Local alTamSDV   := {TAMSX3("DV_FORNEC")[1],TAMSX3("DV_LOJA")[1],TAMSX3("DV_DOC")[1],TAMSX3("DV_SERIE")[1],TAMSX3("DV_PROD")[1],TAMSX3("DV_NUMPED")[1],TAMSX3("DV_ITEMPC")[1]}
Local cProduto2 := "", clWhere := ""
Local oDlg := {}

//****************************************************************************
// Valida produto existente para evitar erro ao tentar executar o msexecauto
//****************************************************************************
SDS->( DbSetOrder(1) )
if !SDS->( dbSeek( xFilial("SDS")+clNota+clSerie+clCodFor+clLoja) )
	Return .T.
endif

SDT->( DbSetOrder(2) )
if !SDT->( dbSeek( xFilial("SDT")+PadR(clCodFor,alTamSDV[1])+PadR(clLoja,alTamSDV[2])+PadR(clNota,alTamSDV[3])+PadR(clSerie,alTamSDV[4]) ) ) //+PadR(SDT->DT_COD,alTamSDV[5])
	Return .T.
endif

while SDT->(!EOF()) .and. (SDS->DS_FORNEC==SDT->DT_FORNEC) .and. (SDS->DS_LOJA==SDT->DT_LOJA) .and. ;
	(SDS->DS_DOC==SDT->DT_DOC) .and. (SDS->DS_SERIE==SDT->DT_SERIE)
	
	//**********************************************
	// Verifica se Existe Amarração Produto x SA5
	//**********************************************
	clWhere:=""
	clWhere += "SELECT count(*) nTOTAL "
	clWhere += "FROM " + RetSqlName("SA5") + " SA5, " + RetSqlName("SDT") + " SDT, " + RetSqlName("SB1") + " SB1 "
	clWhere += "WHERE A5_FILIAL = '" + xFilial("SA5") + "' AND SA5.D_E_L_E_T_ = ' ' AND "
	clWhere += " DT_FILIAL = '" + xFilial("SDT") + "' AND SDT.D_E_L_E_T_ = ' ' AND "
	clWhere += " B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ' ' AND "
	clWhere += " A5_FORNECE = DT_FORNEC AND A5_PRODUTO = DT_COD AND A5_CODPRF = DT_PRODFOR AND A5_LOJA = DT_LOJA AND "
	clWhere += " A5_PRODUTO = B1_COD AND "
	clWhere += " A5_FORNECE = '" + SDT->DT_FORNEC  + "' AND A5_LOJA = '" + SDT->DT_LOJA  + "' AND ""
	clWhere += " A5_CODPRF = '"  + SDT->DT_PRODFOR + "' "
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,clWhere),"QRYSA5",.T.,.T.)
	if QRYSA5->nTOTAL > 0
		QRYSA5->( DbCloseArea() )
		SDT->( DbSkip() )
		Loop
	endif
	QRYSA5->( DbCloseArea() )
	
	//****************************************************************
	// Verifica se o Produto Existe, caso ja tenha na SA5, cadastre
	//****************************************************************
	if SB1->( DbSetOrder(1), DBSeek( xFilial("SB1") + SDT->DT_COD ) )
		
		if SDS->DS_TIPO # "N"
			dbselectarea("SA7")
			if !SA7->( DbSetOrder(1), DBSeek( xFilial("SA7") + SDT->DT_FORNEC + SDT->DT_LOJA + SDT->DT_COD ) )
				RecLock("SA7",.T.)
				SA7->A7_FILIAL 	:= xFilial("SA7")
				SA7->A7_CLIENTE	:= SDS->DS_FORNEC
				SA7->A7_LOJA 	:= SDS->DS_LOJA
				SA7->A7_CODCLI  := SDT->DT_PRODFOR
				SA7->A7_PRODUTO := SDT->DT_COD	//cProduto2
				SA7->( MsUnlock() )
			endif
		else
			dbselectarea("SA5")
			if !SA5->( DbSetOrder(1), DBSeek( xFilial("SA5") + SDT->DT_FORNEC + SDT->DT_LOJA + SDT->DT_COD ) )
				RecLock("SA5",.T.)
				SA5->A5_FILIAL 	:= xFilial("SA5")
				SA5->A5_FORNECE := SDT->DT_FORNEC
				SA5->A5_LOJA 	:= SDT->DT_LOJA
				SA5->A5_NOMEFOR	:= Posicione("SA2",1,xFilial("SA2")+SDS->DS_FORNEC+SDS->DS_LOJA,"A2_NOME")
				SA5->A5_CODPRF	:= SDT->DT_PRODFOR
				SA5->A5_PRODUTO := SDT->DT_COD	//cProduto2
				SA5->A5_NOMPROD := Posicione("SB1",1,xFilial("SB1")+cProduto2,"B1_DESC")
				SA5->( MsUnlock() )
			endif
			
		endif
		
		SDT->( DbSkip() )
		Loop
		
	endif
	
	cProduto2	:= space( len(SDT->DT_COD) )
	
	@ 65,153 To 229,435 Dialog oDlg Title OemToAnsi("Inclusão Amarração")
	
	@ 09,009 Say OemToAnsi("Produto") Size 99,8
	@ 15,009 Say OemToAnsi( AllTrim(SDT->DT_PRODFOR) + "-" + AllTrim(SDT->DT_DESCFOR)) Size 99,8
	@ 28,009 Get cProduto2 Picture "@!" F3 "SB1" VALID Existcpo("SB1",cProduto2) Size 59,10
	@ 62,039 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	Activate Dialog oDlg Centered
	
	if Empty(cProduto2)
		SDT->( DbSkip() )
		Loop
	endif
	
	RecLock("SDT")
	SDT->DT_COD := cProduto2
	SDT->( DbUnLock() )
	
	if SDS->DS_TIPO # "N"
		
		if !SA7->( DbSetOrder(1), DBSeek( xFilial("SA7") + SDT->DT_FORNEC + SDT->DT_LOJA + cProduto2 ) )
			
			RecLock("SA7",.T.)
			SA7->A7_FILIAL 	:= xFilial("SA7")
			SA7->A7_CLIENTE	:= SDS->DS_FORNEC
			SA7->A7_LOJA 	:= SDS->DS_LOJA
			SA7->A7_CODCLI  := SDT->DT_PRODFOR
			SA7->A7_PRODUTO := cProduto2
			SA7->( MsUnlock() )
			
		endif
		
	else
		clWhere:=""
		clWhere += "SELECT count(*) nTOTAL "
		clWhere += "FROM " + RetSqlName("SA5") + " SA5, " + RetSqlName("SDT") + " SDT "
		clWhere += "WHERE A5_FILIAL = '" + xFilial("SA5") + "' AND SA5.D_E_L_E_T_ = ' ' AND "
		clWhere += " DT_FILIAL = '" + xFilial("SDT") + "' AND SDT.D_E_L_E_T_ = ' ' AND "
		clWhere += " A5_FORNECE = DT_FORNEC AND A5_PRODUTO = DT_COD AND A5_CODPRF = DT_PRODFOR AND A5_LOJA = DT_LOJA AND "
		clWhere += " A5_FORNECE = '" + SDT->DT_FORNEC  + "' AND "
		clWhere += " A5_LOJA = '" + SDT->DT_LOJA  + "' AND "
		clWhere += " A5_CODPRF = '"  + SDT->DT_PRODFOR + "' "
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,,clWhere),"QRYSA5",.T.,.T.)
		
		if QRYSA5->nTOTAL == 0
			
			if !SA5->( DbSetOrder(1), DBSeek( xFilial("SA5") + SDT->DT_FORNEC + SDT->DT_LOJA + cProduto2 ) )
				
				RecLock("SA5",.T.)
				SA5->A5_FILIAL 	:= xFilial("SA5")
				SA5->A5_FORNECE := SDT->DT_FORNEC
				SA5->A5_LOJA 	:= SDT->DT_LOJA
				SA5->A5_NOMEFOR	:= Posicione("SA2",1,xFilial("SA2")+SDS->DS_FORNEC+SDS->DS_LOJA,"A2_NOME")
				SA5->A5_CODPRF	:= SDT->DT_PRODFOR
				SA5->A5_PRODUTO := cProduto2
				SA5->A5_NOMPROD := Posicione("SB1",1,xFilial("SB1")+cProduto2,"B1_DESC")
				SA5->( MsUnlock() )
				
			endif
			
		endif
		QRYSA5->( DbCloseArea() )
		
	endif
	
	SDT->( DbSkip() )
	
enddo
Return .T.



Static Function ajustasx1()       

	putSx1("MTA140I","11","Mostra Gerados?"      ,"Mostra Gerados?"      ,"Mostra Gerados?"      ,"MV_CHC","C",1,0,0,"C","","","","","MV_PAR12","Sim","Si","Yes",""        ,"","Nao","No","No","","","","","","","","")

Return
User Function VALDSTES()
local lRet := .F.

lRet := MsgYesNo("Caso nao seja informada a TES no campo 'Tipo Entrada' a TES será preenchida conforme cadastro de produtos";
				+"Caso seja informada será essa a TES utilizada em todos os itens da NF, deseja continuar?","Atenção")

Return lRet

#include "RWMAKE.CH"
#INCLUDE "COLORS.CH"


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LIC002    ³Autor  ³ Marcelo Myra      ³ Data ³  08/19/02   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Formação de Preços para Propostas                          ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ Controle de Licitações                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function LIC002()

LOCAL aCORES  := {{'ZL_STATUS=="1"',"ENABLE" },; 	
            	  {'ZL_STATUS=="2"',"BR_AMARELO"},; 
            	  {'ZL_STATUS=="3"',"BR_AZUL"},; 
            	  {'ZL_STATUS=="4"',"DISABLE"}} 	

PRIVATE cCADASTRO 	:= "Formacao de Precos para Propostas"
PRIVATE	aRotina	:= {{ "Pesquisar","AxPesqui", 0 , 1},;
{ "Atualizar","U_FormPreco()", 0 , 2},;
{ "Legenda","U_leg002()", 0 , 2}}
            	     

dbselectarea("SZL")
SZL->(DbSetFilter({|| SZL->ZL_PROPOS<>space(8)},"szl->zl_propos<>'        '"))
dbSetOrder(3)

mBrowse(6,01,22,75,"SZL",,,,,,aCORES)

dbselectarea("SZL")
szl->(dbclearfil())

Return(.t.)


User Function FormPreco()

Local _mArea     := {"SB1","SZL","SZM","SZN","SZP","SA3"}
Local _mAlias    := {}

PRIVATE oGrade,btnOk,btCancela,btnCus,btnVisual,oGrp6,lblTeste,oSay9,oSay13,oSay14,btnHist,btnEst,btnProp,btnSalva,lblProp,lblLicit,lblDtAbe,lblValid,lblQtdeTot,lblValTot,oGrp27,oGrp28,oGrp29,oSay25,oSay26,oSay27,oSay28,oSay30,oSay31,lblModal,oSay33,lblFornec

_mAlias := U_SalvaAmbiente(_mArea)

oGrade := MSDIALOG():Create()
oGrade:cName := "oGrade"
oGrade:cCaption := "Formação de Preços para Propostas"
oGrade:nLeft := 0
oGrade:nTop := 0
oGrade:nWidth := 602
oGrade:nHeight := 436
oGrade:lShowHint := .F.
oGrade:lCentered := .T.

btnOk := SBUTTON():Create(oGrade)
btnOk:cName := "btnOk"
btnOk:cCaption := "Ok"
btnOk:cMsg := "Ok"
btnOk:cToolTip := "Ok"
btnOk:nLeft := 471
btnOk:nTop := 374
btnOk:nWidth := 52
btnOk:nHeight := 22
btnOk:lShowHint := .T.
btnOk:lReadOnly := .F.
btnOk:Align := 0
btnOk:lVisibleControl := .T.
btnOk:nType := 1
btnOk:bLClicked := {|| Confirma() }

btCancela := SBUTTON():Create(oGrade)
btCancela:cName := "btCancela"
btCancela:cCaption := "Cancela"
btCancela:cMsg := "Cancela"
btCancela:cToolTip := "Cancela"
btCancela:nLeft := 530
btCancela:nTop := 373
btCancela:nWidth := 51
btCancela:nHeight := 23
btCancela:lShowHint := .T.
btCancela:lReadOnly := .F.
btCancela:Align := 0
btCancela:lVisibleControl := .T.
btCancela:nType := 2
btCancela:bLClicked := {|| Cancela() }

btnCus := SBUTTON():Create(oGrade)
btnCus:cName := "btnCus"
btnCus:cCaption := "Custos"
btnCus:cToolTip := "Custos"
btnCus:nLeft := 33
btnCus:nTop := 213
btnCus:nWidth := 52
btnCus:nHeight := 22
btnCus:lShowHint := .T.
btnCus:lReadOnly := .F.
btnCus:Align := 0
btnCus:lVisibleControl := .T.
btnCus:nType := 18

btnVisual := SBUTTON():Create(oGrade)
btnVisual:cName := "btnVisual"
btnVisual:cCaption := "Visualizar"
btnVisual:cToolTip := "Visualizar Cadastro do Produto"
btnVisual:nLeft := 32
btnVisual:nTop := 158
btnVisual:nWidth := 52
btnVisual:nHeight := 22
btnVisual:lShowHint := .T.
btnVisual:lReadOnly := .F.
btnVisual:Align := 0
btnVisual:lVisibleControl := .T.
btnVisual:nType := 15
btnVisual:bLClicked := {|| Visual() }

oGrp6 := TGROUP():Create(oGrade)
oGrp6:cName := "oGrp6"
oGrp6:cCaption := "Informações da Proposta"
oGrp6:nLeft := 22
oGrp6:nTop := 8
oGrp6:nWidth := 562
oGrp6:nHeight := 114
oGrp6:lShowHint := .F.
oGrp6:lReadOnly := .F.
oGrp6:Align := 0
oGrp6:lVisibleControl := .T.

lblTeste := TSAY():Create(oGrade)
lblTeste:cName := "lblTeste"
lblTeste:cCaption := "Nr.Proposta:"
lblTeste:nLeft := 35
lblTeste:nTop := 28
lblTeste:nWidth := 64
lblTeste:nHeight := 17
lblTeste:lShowHint := .F.
lblTeste:lReadOnly := .F.
lblTeste:Align := 0
lblTeste:lVisibleControl := .T.
lblTeste:lWordWrap := .F.
lblTeste:lTransparent := .T.

oSay9 := TSAY():Create(oGrade)
oSay9:cName := "oSay9"
oSay9:cCaption := "Validade:"
oSay9:nLeft := 230
oSay9:nTop := 70
oSay9:nWidth := 46
oSay9:nHeight := 17
oSay9:lShowHint := .F.
oSay9:lReadOnly := .F.
oSay9:Align := 0
oSay9:lVisibleControl := .T.
oSay9:lWordWrap := .F.
oSay9:lTransparent := .T.

oSay13 := TSAY():Create(oGrade)
oSay13:cName := "oSay13"
oSay13:cCaption := "Licitante:"
oSay13:nLeft := 49
oSay13:nTop := 50
oSay13:nWidth := 48
oSay13:nHeight := 17
oSay13:lShowHint := .F.
oSay13:lReadOnly := .F.
oSay13:Align := 0
oSay13:lVisibleControl := .T.
oSay13:lWordWrap := .F.
oSay13:lTransparent := .T.

oSay14 := TSAY():Create(oGrade)
oSay14:cName := "oSay14"
oSay14:cCaption := "Dt.Abertura:"
oSay14:nLeft := 36
oSay14:nTop := 71
oSay14:nWidth := 61
oSay14:nHeight := 17
oSay14:lShowHint := .F.
oSay14:lReadOnly := .F.
oSay14:Align := 0
oSay14:lVisibleControl := .T.
oSay14:lWordWrap := .F.
oSay14:lTransparent := .T.

btnHist := SBUTTON():Create(oGrade)
btnHist:cName := "btnHist"
btnHist:cCaption := "Histórico"
btnHist:cToolTip := "Histórico"
btnHist:nLeft := 34
btnHist:nTop := 241
btnHist:nWidth := 52
btnHist:nHeight := 22
btnHist:lShowHint := .T.
btnHist:lReadOnly := .F.
btnHist:Align := 0
btnHist:lVisibleControl := .T.
btnHist:nType := 14
btnHist:bLClicked := {|| U_LIC006() }

btnEst := SBUTTON():Create(oGrade)
btnEst:cName := "btnEst"
btnEst:cCaption := "Estoque"
btnEst:cToolTip := "Informações do Produto"
btnEst:nLeft := 32
btnEst:nTop := 186
btnEst:nWidth := 52
btnEst:nHeight := 22
btnEst:lShowHint := .T.
btnEst:lReadOnly := .F.
btnEst:Align := 0
btnEst:lVisibleControl := .T.
btnEst:nType := 5
btnEst:bLClicked := {|| U_LIC004() }

btnProp := SBUTTON():Create(oGrade)
btnProp:cName := "btnProp"
btnProp:cCaption := "Proposta"
btnProp:cToolTip := "Abrir Proposta"
btnProp:nLeft := 34
btnProp:nTop := 267
btnProp:nWidth := 52
btnProp:nHeight := 22
btnProp:lShowHint := .T.
btnProp:lReadOnly := .F.
btnProp:Align := 0
btnProp:lVisibleControl := .T.
btnProp:nType := 11
btnProp:bLClicked := {|| Proposta() }

btnSalva := SBUTTON():Create(oGrade)
btnSalva:cName := "btnSalva"
btnSalva:cCaption := "Salvar Dados"
btnSalva:cMsg := "Salvar Dados"
btnSalva:cToolTip := "Salvar Dados"
btnSalva:nLeft := 410
btnSalva:nTop := 374
btnSalva:nWidth := 52
btnSalva:nHeight := 22
btnSalva:lShowHint := .T.
btnSalva:lReadOnly := .F.
btnSalva:Align := 0
btnSalva:lVisibleControl := .T.
btnSalva:nType := 13
btnSalva:bLClicked := {|| Grava() }

lblProp := TSAY():Create(oGrade)
lblProp:cName := "lblProp"
lblProp:cCaption := "lblProp"
lblProp:nLeft := 102
lblProp:nTop := 28
lblProp:nWidth := 94
lblProp:nHeight := 17
lblProp:lShowHint := .F.
lblProp:lReadOnly := .F.
lblProp:Align := 0
lblProp:lVisibleControl := .T.
lblProp:lWordWrap := .F.
lblProp:lTransparent := .T.

lblLicit := TSAY():Create(oGrade)
lblLicit:cName := "lblLicit"
lblLicit:cCaption := "lblLicit"
lblLicit:nLeft := 102
lblLicit:nTop := 51
lblLicit:nWidth := 317
lblLicit:nHeight := 17
lblLicit:lShowHint := .F.
lblLicit:lReadOnly := .F.
lblLicit:Align := 0
lblLicit:lVisibleControl := .T.
lblLicit:lWordWrap := .F.
lblLicit:lTransparent := .T.

lblDtAbe := TSAY():Create(oGrade)
lblDtAbe:cName := "lblDtAbe"
lblDtAbe:cCaption := "lblDtAbe"
lblDtAbe:nLeft := 102
lblDtAbe:nTop := 71
lblDtAbe:nWidth := 94
lblDtAbe:nHeight := 17
lblDtAbe:lShowHint := .F.
lblDtAbe:lReadOnly := .F.
lblDtAbe:Align := 0
lblDtAbe:lVisibleControl := .T.
lblDtAbe:lWordWrap := .F.
lblDtAbe:lTransparent := .T.

lblValid := TSAY():Create(oGrade)
lblValid:cName := "lblValid"
lblValid:cCaption := "lblValid"
lblValid:nLeft := 283
lblValid:nTop := 70
lblValid:nWidth := 94
lblValid:nHeight := 17
lblValid:lShowHint := .F.
lblValid:lReadOnly := .F.
lblValid:Align := 0
lblValid:lVisibleControl := .T.
lblValid:lWordWrap := .F.
lblValid:lTransparent := .T.

lblQtdeTot := TSAY():Create(oGrade)
lblQtdeTot:cName := "lblQtdeTot"
lblQtdeTot:cCaption := "oSay24"
lblQtdeTot:nLeft := 46
lblQtdeTot:nTop := 378
lblQtdeTot:nWidth := 85
lblQtdeTot:nHeight := 17
lblQtdeTot:lShowHint := .F.
lblQtdeTot:lReadOnly := .F.
lblQtdeTot:Align := 0
lblQtdeTot:lVisibleControl := .T.
lblQtdeTot:lWordWrap := .F.
lblQtdeTot:lTransparent := .T.

lblValTot := TSAY():Create(oGrade)
lblValTot:cName := "lblValTot"
lblValTot:cCaption := "oSay25"
lblValTot:nLeft := 239
lblValTot:nTop := 377
lblValTot:nWidth := 83
lblValTot:nHeight := 17
lblValTot:lShowHint := .F.
lblValTot:lReadOnly := .F.
lblValTot:Align := 0
lblValTot:lVisibleControl := .T.
lblValTot:lWordWrap := .F.
lblValTot:lTransparent := .T.

oGrp27 := TGROUP():Create(oGrade)
oGrp27:cName := "oGrp27"
oGrp27:cCaption := "Produto Selecionado"
oGrp27:nLeft := 20
oGrp27:nTop := 138
oGrp27:nWidth := 177
oGrp27:nHeight := 167
oGrp27:lShowHint := .F.
oGrp27:lReadOnly := .F.
oGrp27:Align := 0
oGrp27:lVisibleControl := .T.

oGrp28 := TGROUP():Create(oGrade)
oGrp28:cName := "oGrp28"
oGrp28:cCaption := "Qtde Total de Itens"
oGrp28:nLeft := 20
oGrp28:nTop := 361
oGrp28:nWidth := 185
oGrp28:nHeight := 41
oGrp28:lShowHint := .F.
oGrp28:lReadOnly := .F.
oGrp28:Align := 0
oGrp28:lVisibleControl := .T.

oGrp29 := TGROUP():Create(oGrade)
oGrp29:cName := "oGrp29"
oGrp29:cCaption := "Valor Total da Proposta"
oGrp29:nLeft := 213
oGrp29:nTop := 360
oGrp29:nWidth := 185
oGrp29:nHeight := 41
oGrp29:lShowHint := .F.
oGrp29:lReadOnly := .F.
oGrp29:Align := 0
oGrp29:lVisibleControl := .T.

oSay25 := TSAY():Create(oGrade)
oSay25:cName := "oSay25"
oSay25:cCaption := "Visualizar Proposta"
oSay25:nLeft := 92
oSay25:nTop := 272
oSay25:nWidth := 96
oSay25:nHeight := 17
oSay25:lShowHint := .F.
oSay25:lReadOnly := .F.
oSay25:Align := 0
oSay25:lVisibleControl := .T.
oSay25:lWordWrap := .F.
oSay25:lTransparent := .T.

oSay26 := TSAY():Create(oGrade)
oSay26:cName := "oSay26"
oSay26:cCaption := "Detalhes do Produto"
oSay26:nLeft := 91
oSay26:nTop := 162
oSay26:nWidth := 100
oSay26:nHeight := 17
oSay26:lShowHint := .F.
oSay26:lReadOnly := .F.
oSay26:Align := 0
oSay26:lVisibleControl := .T.
oSay26:lWordWrap := .F.
oSay26:lTransparent := .T.

oSay27 := TSAY():Create(oGrade)
oSay27:cName := "oSay27"
oSay27:cCaption := "Consulta Estoque"
oSay27:nLeft := 90
oSay27:nTop := 191
oSay27:nWidth := 96
oSay27:nHeight := 17
oSay27:lShowHint := .F.
oSay27:lReadOnly := .F.
oSay27:Align := 0
oSay27:lVisibleControl := .T.
oSay27:lWordWrap := .F.
oSay27:lTransparent := .T.

oSay28 := TSAY():Create(oGrade)
oSay28:cName := "oSay28"
oSay28:cCaption := "Custos"
oSay28:nLeft := 92
oSay28:nTop := 218
oSay28:nWidth := 65
oSay28:nHeight := 17
oSay28:lShowHint := .F.
oSay28:lReadOnly := .F.
oSay28:Align := 0
oSay28:lVisibleControl := .T.
oSay28:lWordWrap := .F.
oSay28:lTransparent := .T.

oSay30 := TSAY():Create(oGrade)
oSay30:cName := "oSay30"
oSay30:cCaption := "Histórico Licitações"
oSay30:nLeft := 92
oSay30:nTop := 245
oSay30:nWidth := 99
oSay30:nHeight := 17
oSay30:lShowHint := .F.
oSay30:lReadOnly := .F.
oSay30:Align := 0
oSay30:lVisibleControl := .T.
oSay30:lWordWrap := .F.
oSay30:lTransparent := .T.

oSay31 := TSAY():Create(oGrade)
oSay31:cName := "oSay31"
oSay31:cCaption := "Modalidade:"
oSay31:nLeft := 36
oSay31:nTop := 91
oSay31:nWidth := 60
oSay31:nHeight := 17
oSay31:lShowHint := .F.
oSay31:lReadOnly := .F.
oSay31:Align := 0
oSay31:lVisibleControl := .T.
oSay31:lWordWrap := .F.
oSay31:lTransparent := .T.

lblModal := TSAY():Create(oGrade)
lblModal:cName := "lblModal"
lblModal:cCaption := "oSay32"
lblModal:nLeft := 102
lblModal:nTop := 90
lblModal:nWidth := 94
lblModal:nHeight := 17
lblModal:lShowHint := .F.
lblModal:lReadOnly := .F.
lblModal:Align := 0
lblModal:lVisibleControl := .T.
lblModal:lWordWrap := .F.
lblModal:lTransparent := .T.

oSay33 := TSAY():Create(oGrade)
oSay33:cName := "oSay33"
oSay33:cCaption := "Fornecimento:"
oSay33:nLeft := 207
oSay33:nTop := 90
oSay33:nWidth := 76
oSay33:nHeight := 17
oSay33:lShowHint := .F.
oSay33:lReadOnly := .F.
oSay33:Align := 0
oSay33:lVisibleControl := .T.
oSay33:lWordWrap := .F.
oSay33:lTransparent := .T.

lblFornec := TSAY():Create(oGrade)
lblFornec:cName := "lblFornec"
lblFornec:cCaption := "oSay34"
lblFornec:nLeft := 284
lblFornec:nTop := 89
lblFornec:nWidth := 90
lblFornec:nHeight := 17
lblFornec:lShowHint := .F.
lblFornec:lReadOnly := .F.
lblFornec:Align := 0
lblFornec:lVisibleControl := .T.
lblFornec:lWordWrap := .F.
lblFornec:lTransparent := .T.

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ€¦ú¿
//³Inicio de definições Manuais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ€¦úÙ
ENDDOC*/                         

cNumPro := SZL->ZL_NUMPRO
dbSelectArea("SZP")
dbSetOrder(1)
dbSeek(xFilial("SZP")+SZL->ZL_LICITAN)

lblProp:cCaption 	:= cNumPro 
lblLicit:cCaption 	:= SZP->ZP_NOMLIC
lblDtAbe:cCaption 	:= DTOC(SZL->ZL_DTABER)
lblValid:cCaption 	:= ALLTRIM(STR(SZL->ZL_DIASVAL)) + " dia(s)"
lblModal:cCaption 	:= Modalidade(SZL->ZL_MODAL)
lblFornec:cCaption 	:= iif(SZL->ZL_TIPOFOR=="U","Unico","Parcelado")


aCampos := {"ZM_NUMITEM","ZM_CODPRO  ","ZM_DESC   "}

if SZL->ZL_UMPROP=="1"
	AADD(aCampos,"ZM_QTDE1  ")
	AADD(aCampos,"ZM_UM1    ")
	AADD(aCampos,"ZM_PRCUNI ")
else
	AADD(aCampos,"ZM_QTDE2  ")
	AADD(aCampos,"ZM_UM2    ")
	AADD(aCampos,"ZM_PRCUN2 ")
endif

AADD(aCampos,"ZM_TOTITEM")

aHeader := U_CriaHeader("SZM",aCampos)
aCols   := U_CriaCols("SZM",2,"ZM_NUMPRO",cNumPro,aHeader,"SZM->ZM_FORMA=='S'")

aCols := Asort(aCols,,,{|x,y|x[1]<y[1]})

                                                    
nPosCODPRO 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_CODPRO"})
nPosTotItem := ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_TOTITEM"})
nPosCOLOC 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_COLOC"})
if SZL->ZL_UMPROP=="1"                              
	nPosQTDE 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_QTDE1"})
	nPosPRCUNI 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_PRCUNI"})
else
	nPosQTDE 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_QTDE2"})
	nPosPRCUNI 	:= ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_PRCUN2"})

endif

//AtuPrcTab() // Atualiza preco de tabela para produtos sem preco


lblQtdeTot:cCaption 	:= 	TRANSFORM(CalcQtdeTot(),"@E 999,999,999.999")
lblValTot:cCaption 	:= 	TRANSFORM(CalcValTot(),"@E 999,999,999.99")

@ 75,105 TO 175,285 MULTILINE MODIFY VALID LineOk() //FREEZE 1

oGrade:Activate()

U_VoltaAmbiente(_mAlias)

Return(.t.)


// Valida linha do browse
Static Function LineOk()

	LOCAL nLinShow := 1

	lblQtdeTot:cCaption 	:= 	TRANSFORM(CalcQtdeTot(),"@E 999,999,999.999")
	lblValTot:cCaption 		:= 	TRANSFORM(CalcValTot(),"@E 999,999,999.99")
	
	oGrade:Refresh()

Return(.t.)

Static Function Proposta()

	PRIVATE _cMaster,_cDetail,_cCpoMas,_cCpoDet, _cCpoKey, _cTitulo
	PRIVATE 	aRotina	:= {{ "Pesquisar","AxPesqui", 0 , 1},;
	{ "Visualizar","U_Mod3Exec(2)", 0 , 2},;
	{ "Incluir","U_Mod3Exec(1)", 0 , 3},;
	{ "Alterar","U_Mod3Exec(3)", 0 , 4, 20 },;
	{ "Excluir","U_Mod3Exec(4)", 0 , 5, 21 },;
	{ "Legenda","U_leg002()", 0 , 2}}
	
	_cMaster := "SZL"
	_cDetail := "SZM"
	_cCpoMas := "ZL_NUMPRO"
	_cCpoDet := "ZM_NUMPRO"
	_cCpoKey := "ZM_CODPRO"
	_cTitulo := "Cadastro de Propostas"
	
	dbSelectArea("SZL")

	U_Mod3Exec(2)

Return(NIL)



Static Function Visual()

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+aCols[n][nPosCODPRO])
AxVisual("SB1",recno(),2)

Return(.t.)

Static Function CalcQtdeTot()

nRet := 0
for i := 1 to len(aCols)
	nRet := nRet + aCols[i][nPosQTDE]
next i

Return(nRet)

Static Function CalcValTot()

nRet := 0
for i := 1 to len(aCols)
	nRet := nRet + aCols[i][nPosQTDE]*aCols[i][nPosPRCUNI]
	aCols[i][nPosTotItem] := aCols[i][nPosQTDE]*aCols[i][nPosPRCUNI]
next i

Return(nRet)


Static Function Cancela()

Close(oGrade)

Return(.t.)

Static Function Grava()

if MsgYesNo("Salvar preços?")

	dbSelectArea("SZM")
	dbSetOrder(1)

	For i := 1 to Len(aCols)
		dbSeek(xFilial("SZM")+SZL->ZL_NUMPRO+aCols[i][nPosCODPRO])
		RecLock("SZM",.f.)
		if SZL->ZL_UMPROP=="1"                              
			SZM->ZM_PRCUNI := aCols[i][nPosPRCUNI]
			SZM->ZM_PRCUN2 := (SZM->ZM_PRCUNI * SZM->ZM_QTDE1) / SZM->ZM_QTDE2 
		else
			SZM->ZM_PRCUN2 := aCols[i][nPosPRCUNI]
			SZM->ZM_PRCUNI := (SZM->ZM_PRCUN2 * SZM->ZM_QTDE2) / SZM->ZM_QTDE1 
		endif
		MsUnlock()
	next i
		
endif

Return(.t.)


Static Function Confirma()

if !ValidaDec()
	MsgBox("Numero de casas decimais deve ser menor que ("+alltrim(str(SZL->ZL_CASASD))+")")
	return()
endif

if MsgYesNo("Finalizar Lançamento da Grade?")

	dbSelectArea("SZM")
	dbSetOrder(1)

	For i := 1 to Len(aCols)
		dbSeek(xFilial("SZM")+SZL->ZL_NUMPRO+aCols[i][nPosCODPRO])
		RecLock("SZM",.f.)
		if SZL->ZL_UMPROP=="1"                              
			SZM->ZM_PRCUNI := aCols[i][nPosPRCUNI]
			SZM->ZM_PRCUN2 := (SZM->ZM_PRCUNI * SZM->ZM_QTDE1) / SZM->ZM_QTDE2 
		else
			SZM->ZM_PRCUN2 := aCols[i][nPosPRCUNI]
			SZM->ZM_PRCUNI := (SZM->ZM_PRCUN2 * SZM->ZM_QTDE2) / SZM->ZM_QTDE1 
		endif
		MsUnlock()
	next i

	dbSelectArea("SZL")
	RecLock("SZL",.f.)
	SZL->ZL_STATUS := "2"
	MsUnlock()
endif

Close(oGrade)

Return(.t.)

Static Function Modalidade(cCod)

cRet := " "
do case
	case cCod=="CV"
		cRet := "Carta Convite"
	case cCod=="TP"
		cRet := "Tomada de Precos"
	case cCod=="CP"
		cRet := "Concorrencia Publica"
	case cCod=="CH"
		cRet := "Concorrencia Hospitalar"
	case cCod=="RG"
		cRet := "Registro de Precos"
	case cCod=="CD"
		cRet := "Compra Direta"
endcase		

return(cRet)



Static Function ValidaDec()
_lret := .t.
for i := 1 to len(aCols)
	cValTxt := alltrim(str(aCols[i][nPosPRCUNI]))
	nPos := RAT(".",cValTxt)
	if nPos<>0
		if Len(cValTxt)-nPos > SZL->ZL_CASASD
			_lRet := .f.
		endif
	endif
next i

return(_lret)

/*	
Static Function AtuPrcTab()

LOCAL i

for i := 1 to len(aCols)
	if aCols[i][nPosPrcUni]==0
		if SZL->ZL_UMPROP=="1"
		    aCols[i][nPosPrcUni] := U_PrecoTab(SZL->ZL_TAB,aCols[i][2])
		else
		    aCols[i][nPosPrcUni] := ConvUM(U_PrecoTab(SZL->ZL_TAB,aCols[i][2]),aCols[i][2])
		endif		
	endif
next i

Return()

*/

Static Function ConvUM(nVal,cProd)

dbSelectArea("SB1")
dbSetOrder(1)
if dbSeek(xFilial("SB1")+cProd)
	if SB1->B1_TIPCONV=="M"	
		nRet := nVal / SB1->B1_CONV
	elseif SB1->B1_TIPCONV=="D"	
		nRet := nVal * SB1->B1_CONV
	else
		nRet := 0
	endif	
else
	nRet := 0
endif

Return(nRet)
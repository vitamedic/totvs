#include "RWMAKE.CH"


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LIC003    ³Autor  ³ Marcelo Myra      ³ Data ³  08/19/02   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Grade de Precos (Concorrentes)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AP6                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function LIC003()

Local _mArea     := {"SB1","SZL","SZM","SZN","SZP"}
Local _mAlias    := {}
Private _LCPROPOS := M->ZL_NUMPRO
Private _LCPRODUT := aCols[n][nPosCODPRO]     
Private _LCPreco  := aCols[n][nPosPRCUNI]  


_mAlias := U_SalvaAmbiente(_mArea)


nPosCODPRO := ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_CODPRO"})
nPosPRCUNI := ASCAN(aHeader,{|x|alltrim(x[2])=="ZM_PRCUNI"})


Private oConc,btnOk,btnCancela,oGrp4,lblCod,lblDescr,oSay7,oSay8,oSay9
oConc := MSDIALOG():Create()
oConc:cName := "oConc"
oConc:cCaption := "Resultados"
oConc:nLeft := 0
oConc:nTop := 0
oConc:nWidth := 425
oConc:nHeight := 368
oConc:lShowHint := .F.
oConc:lCentered := .T.

btnOk := SBUTTON():Create(oConc)
btnOk:cName := "btnOk"
btnOk:cCaption := "oSBtn1"
btnOk:nLeft := 352
btnOk:nTop := 87
btnOk:nWidth := 52
btnOk:nHeight := 22
btnOk:lShowHint := .F.
btnOk:lReadOnly := .F.
btnOk:Align := 0
btnOk:lVisibleControl := .T.
btnOk:nType := 1
btnOk:bLClicked := {|| Confirma() }

btnCancela := SBUTTON():Create(oConc)
btnCancela:cName := "btnCancela"
btnCancela:cCaption := "oSBtn2"
btnCancela:nLeft := 351
btnCancela:nTop := 113
btnCancela:nWidth := 52
btnCancela:nHeight := 22
btnCancela:lShowHint := .F.
btnCancela:lReadOnly := .F.
btnCancela:Align := 0
btnCancela:lVisibleControl := .T.
btnCancela:nType := 2
btnCancela:bLClicked := {|| Cancela() }

oGrp4 := TGROUP():Create(oConc)
oGrp4:cName := "oGrp4"
oGrp4:cCaption := "Produto Selecionado"
oGrp4:nLeft := 15
oGrp4:nTop := 5
oGrp4:nWidth := 392
oGrp4:nHeight := 74
oGrp4:lShowHint := .F.
oGrp4:lReadOnly := .F.
oGrp4:Align := 0
oGrp4:lVisibleControl := .T.

lblCod := TSAY():Create(oConc)
lblCod:cName := "lblCod"
lblCod:cCaption := "oSay5"
lblCod:nLeft := 88
lblCod:nTop := 23
lblCod:nWidth := 101
lblCod:nHeight := 17
lblCod:lShowHint := .F.
lblCod:lReadOnly := .F.
lblCod:Align := 0
lblCod:lVisibleControl := .T.
lblCod:lWordWrap := .F.
lblCod:lTransparent := .T.

lblDescr := TSAY():Create(oConc)
lblDescr:cName := "lblDescr"
lblDescr:cCaption := "oSay6"
lblDescr:nLeft := 87
lblDescr:nTop := 46
lblDescr:nWidth := 306
lblDescr:nHeight := 17
lblDescr:lShowHint := .F.
lblDescr:lReadOnly := .F.
lblDescr:Align := 0
lblDescr:lVisibleControl := .T.
lblDescr:lWordWrap := .F.
lblDescr:lTransparent := .T.

oSay7 := TSAY():Create(oConc)
oSay7:cName := "oSay7"
oSay7:cCaption := "Código:"
oSay7:nLeft := 44
oSay7:nTop := 24
oSay7:nWidth := 42
oSay7:nHeight := 17
oSay7:lShowHint := .F.
oSay7:lReadOnly := .F.
oSay7:Align := 0
oSay7:lVisibleControl := .T.
oSay7:lWordWrap := .F.
oSay7:lTransparent := .F.

oSay8 := TSAY():Create(oConc)
oSay8:cName := "oSay8"
oSay8:cCaption := "Descrição:"
oSay8:nLeft := 28
oSay8:nTop := 46
oSay8:nWidth := 57
oSay8:nHeight := 17
oSay8:lShowHint := .F.
oSay8:lReadOnly := .F.
oSay8:Align := 0
oSay8:lVisibleControl := .T.
oSay8:lWordWrap := .F.
oSay8:lTransparent := .F.

oSay9 := TSAY():Create(oConc)
oSay9:cName := "oSay9"
oSay9:cCaption := "Preços dos concorrentes:"
oSay9:nLeft := 15
oSay9:nTop := 88
oSay9:nWidth := 127
oSay9:nHeight := 17
oSay9:lShowHint := .F.
oSay9:lReadOnly := .F.
oSay9:Align := 0
oSay9:lVisibleControl := .T.
oSay9:lWordWrap := .F.
oSay9:lTransparent := .T.


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ€¦ú¿
//³Inicio de definições Manuais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ€¦úÙ
ENDDOC*/                         

aCampos := {"ZN_CODCON ","ZN_NOMCON ","ZN_PRECO  ","ZN_COLOC  "}

cAliasAnt := Alias()
nIndAnt := IndexOrd()

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+_LCPRODUT)

lblCod:cCaption 	:= _LCPRODUT
lblDescr:cCaption 	:= SB1->B1_DESC

aHAnt := aHeader
aCAnt := aCols
nLinAnt := n

aHeader := U_CriaHeader("SZN",aCampos)
aCols   := U_CriaCols("SZN",1,"ZN_NUMPRO+ZN_CODPRO",_LCPROPOS+_LCPRODUT,aHeader)

nPosCODCON := ASCAN(aHeader,{|x|alltrim(x[2])=="ZN_CODCON"})
nPosNOMCON := ASCAN(aHeader,{|x|alltrim(x[2])=="ZN_NOMCON"})
nPosPRECO := ASCAN(aHeader,{|x|alltrim(x[2])=="ZN_PRECO"})
nPosCOLOC := ASCAN(aHeader,{|x|alltrim(x[2])=="ZN_COLOC"})

nPosDELETE := len(aHeader)+1

n := 1

@ 60,05 TO 160,170 MULTILINE DELETE MODIFY   VALID LineOk() FREEZE 5

oConc:Activate()         

U_VoltaAmbiente(_mAlias)

Return(.t.)


// Valida linha do browse
Static Function LineOk()

lRet := .t.

if !aCols[n][nPosDELETE]

	if Empty(aCols[n][nPosCODCON]) .and. lRet
		lRet := .f.
		MsgBox("Concorrente vazio!")		
	endif
   
	if lRet
		dbSelectArea("AC3")
		dbSetOrder(1)
		dbSeek(xFilial("AC3")+aCols[n][nPosCODCON])
		if Empty(aCols[n][nPosCODCON])
			lRet := .f.
			MsgBox("Concorrente inválido!")		
		endif
	endif
	if lRet
		if Empty(aCols[n][nPosPRECO]) .and. (aCols[n][nPosCODCON]<>GetNewPar("MV_LICONC","000001"))
			lRet := .f.
			MsgBox("Preço do concorrente inválido!")
		endif
	endif

	if lRet
		for i := 1 to len(aCols)
			if aCols[n][nPosCODCON]==aCols[i][nPosCODCON] .and. n<>i
				lRet := .f.
				MsgBox("Este concorrente já existe!")
			endif
		next i
	endif
/*
	if lRet
		if aCols[n][nPosCODCON]==GetNewPar("MV_LICONC","000001") .and. aCols[n][nPosPRECO]<>_LCPreco
				aCols[n][nPosPRECO] := _LCPreco
				MsgBox("Preço Corrigido para => $"+TRANSFORM(_LCPreco,"@E999.9999") )		
		endif	
	endif
*/	
endif

/*
if lRet
	aRank := {}
	for i := 1 to len(aCols)
		AADD(aRank, {aCols[i][nPosCODCON],aCols[i][nPosPRECO]})
	next i

	aRank	:=	Asort(aRank	,,,{|x,y|x[2]<y[2]})

	for i := 1 to Len(aCols)
		for j := 1 to len(aRank)
			if aCols[i][nPosCODCON]==aRank[j][1]
				aCols[i][nPosCOLOC] := j
			endif
		next j
	next i
	
	oConc:Refresh()
endif
*/	
Return(lRet)

Static Function Cancela()

aHeader:= aHAnt
aCols := aCAnt
n := nLinAnt

dbSelectArea(cAliasAnt)
dbSetOrder(nIndAnt)

Close(oConc)

Return(.t.)


Static Function Confirma()

if MsgYesNo("Confirma preços dos concorrentes?") .and. LineOk()


	aCols := Asort(aCols,,,{|x,y|x[nPosPRECO]<y[nPosPRECO]})
	
	dbSelectArea("SZN")
	dbSetOrder(2)
	
	for i := 1 to len(aCols)
		if aCols[i][len(aHeader)+1]==.t.
			if dbSeek(xFilial("SZN")+_LCPROPOS+_LCPRODUT+aCols[i][nPosCODCON])
				RecLock("SZN",.f.)
				dbDelete()				
				MsUnlock()
			endif
		else
			if dbSeek(xFilial("SZN")+_LCPROPOS+_LCPRODUT+aCols[i][nPosCODCON])
				RecLock("SZN",.f.)
				SZN->ZN_NOMCON := aCols[i][nPosNOMCON]
				SZN->ZN_PRECO := aCols[i][nPosPRECO]
				SZN->ZN_COLOC  := Coloc(aCols,i)
				MsUnlock()
			else
				RecLock("SZN",.t.)
				SZN->ZN_FILIAL := xFilial("SZN")
				SZN->ZN_NUMPRO := _LCPROPOS
				SZN->ZN_CODPRO := _LCPRODUT
				SZN->ZN_CODCON := aCols[i][nPosCODCON]
				SZN->ZN_NOMCON := aCols[i][nPosNOMCON]
				SZN->ZN_PRECO  := aCols[i][nPOsPRECO]
				SZN->ZN_COLOC  :=Coloc(aCols,i)
				MsUnlock()
			endif
		endif
    next i
endif


aHeader:= aHAnt
aCols := aCAnt
n := nLinAnt  

dbSelectArea(cAliasAnt)
dbSetOrder(nIndAnt)

Close(oConc)        

Return(.t.)


Static Function Coloc(_aCols,_i)

LOCAL _nRet

if (_aCols[_i][nPosPreco]==_aCols[1][nPosPreco]) .and. _i<>1
	_nRet := 0
elseif (_i==1) .and. Len(_aCols)==1
	_nRet := 1
elseif (_i==1) .and. Len(_aCols)>1
	if (_aCols[1][nPosPreco]==_aCols[2][nPosPreco])
		_nRet := 0
	else
		_nRet := _i
	endif
else
	_nRet := _i
endif
                                                           
Return(_nRet)

User Function LICExistCon()

	dbSelectArea("AC3")
	dbSetOrder(1)
	if dbSeek(xFilial("AC3")+M->ZN_CODCON)
		lRet := .t.
		aCols[n][2] := AC3->AC3_NREDUZ
	else
		lRet := .f.
	endif

return(lret)

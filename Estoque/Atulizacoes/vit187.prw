#INCLUDE "rwmake.ch"


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VIT187    º Autor ³ Gardenia Ilany     º Data ³  03/05/04   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Cadastro modelo 2  para relacionar transpostador com os    ³±±
±±³          ³ documentos                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function VIT187


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Documentos /transportadora"

Private aRotina := { {"Pesquisar", "AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir",   "U_VIT187A",0,6} }

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar",'ExecBlock("VIT187A",.F.,.F.,"Visualizar")',0,2} ,;
{"Incluir",'ExecBlock("VIT187A",.F.,.F.,"Incluir")',0,3} ,;
{"Alterar",'ExecBlock("VIT187A",.F.,.F.,"Alterar")',0,4} ,;
{"Excluir",'ExecBlock("VIT187A",.F.,.F.,"Excluir")',0,5} }


dbSelectArea("SZD")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SZD")

Return

User Function VIT187A

Local aArea := GetArea()
Private _npITEM
Private _npDELETE

lViz := lInc := lAlt := lExc := .F.
SZD->(dbSetOrder(1))
SA2->(dbSetOrder(1))
SZC->(dbSetOrder(1))
SX5->(dbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcao de acesso para o Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
If ParamIxb = "Visualizar"
	lViz := .T.
ElseIf ParamIxb = "Incluir"
	lInc := .T.
ElseIf ParamIxb = "Alterar"
	lAlt := .T.
Else
	lExc := .T.
EndIf


If lInc .OR. lAlt
	nOpcx:=3
Else
	nOpcx:=1
EndIf

If lInc
	MZD_TRANSP := CriaVar("ZD_TRANSP")
	MZD_NMTRAN := Space(30)
	MZD_DOCUMEN := CriaVar("ZD_DOCUMEN")
Else
	MZD_TRANSP := SZD->ZD_TRANSP
	MZD_NMTRAN := Posicione("SA2",1,xFilial("SA2")+SZD->ZD_TRANSP,"A2_NOME")
	MZD_DOCUMEN := SZD->ZD_DOCUMEN
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("Sx3")
SX3->(dbSetOrder(1))
dbSeek("SZD")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SZD")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .AND.;
		!(ALLTRIM(SX3->X3_CAMPO) $ ("ZD_TRANSP/ZD_DOCUMEN"))
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_valid,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	dbSkip()
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If lInc
	aCols:=Array(1,Len(aHeader)+1)
	For I := 1 To Len(aHeader)
		aCOLS[1][I] := CriaVar(aHeader[I][2])
	Next
	aCOLS[1][nUsado+1] := .F.
Else
	SZD->(dbGotop())
	SZD->(dbSeek(xFilial()+MZD_TRANSP+MZD_DOCUMEN,.T.))
	_npITEM    :=ascan(aheader,{|x| alltrim(x[2])=="ZD_ITEM"})
	_npDELETE  :=len(aheader)+1
	aCols:={}
	While SZD->ZD_FILIAL == xFilial("SZD") .AND.;
		SZD->ZD_TRANSP == MZD_TRANSP .AND.;
		SZD->ZD_DOCUMEN == MZD_DOCUMEN
		aAdd(aCols,Array(Len(aHeader)+1))
		nLin := Len(aCols)
		For I := 1 To Len(aHeader)
			aCOLS[nLin][I] := SZD->(FieldGet(FieldPos(aHeader[I][2])))
		Next
		aCols[nLin][_npDELETE]  := .F.
		SZD->(dbSkip())
	EndDo
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTitulo:="Transportadora X documento"
aCGD:={44,5,118,315}
cLinhaOk:=".T."
cTudoOk:='ExecBlock("_ValTudo",.F.,.F.)'
aR:=aC:={}
AADD(aC,{"MZD_TRANSP"	,{15,10} ,"Transportadora"	,"@!"	,'ExecBlock("_vTransp",.F.,.F.)',"SA2",IF(lInc,.T.,.F.)})
AADD(aC,{"MZD_NMTRAN"	,{15,90},""	,"@!",,,.F.})
AADD(aC,{"MZD_DOCUMEN"	,{30,10} ,"Documento"	,"@!"	,'ExecBlock("_vdocumen",.F.,.F.)',"SZC",IF(lInc,.T.,.F.)})

//AADD(aC,{"MZD_DOCUMEN"	,{30,10} ,"Documento","@!"	,,"12",IF(lInc,.T.,.F.)})
//AADD(aC,{"MZJ_CAPINT"	,{30,60} ,"Capital/Interior","@!",,,IF(lInc,.T.,.F.)})
lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

If lRetMod2
	IF lInc .OR. lAlt
		_Grava()
	ElseIf lExc
		_Exclui()
	EndIf
Endif
RestArea(aArea)
Return

//*******************************************************************

Static Function _Grava()
Local nDel := 0
For I := 1 To Len(Acols)
	If !aCols[I][Len(aHeader)+1]
		If lAlt .AND. SZD->(dbSeek(xFilial()+MZD_TRANSP+MZD_DOCUMEN+;
			ACOLS[I][_npITEM]))
			RecLock("SZD",.F.)
		Else
			RecLock("SZD",.T.)
		EndIf
		//Grava Cabecalho
		Replace;
		SZD->ZD_FILIAL  With xFilial("SZD"),;
		SZD->ZD_TRANSP With MZD_TRANSP,;
		SZD->ZD_DOCUMEN With MZD_DOCUMEN
		//Grava Detalhe
		For J := 1 To Len(aHeader)
			If AllTrim(aHeader[J][2]) == "ZD_ITEM"
				Replace SZD->ZD_ITEM With StrZero(Len(aCols)-nDel,2)
			Else
				Replace &("SZD->"+aHeader[J][2]) With ACOLS[I][J]
			EndIf
		Next
		MsUnlock()
	ElseIf lAlt .AND. SZD->(dbSeek(xFilial()+MZD_TRANSP+MZD_DOCUMEN+;
		ACOLS[I][_npITEM]))
		RecLock("SZD",.F.)
		SZD->(dbDelete())
		MsUnlock()
		nDel ++
	EndIf
Next
Return

//*******************************************************************

Static Function _Exclui()
SZD->(dbGotop())
SZD->(dbSeek(xFilial()+MZD_TRANSP+MZD_DOCUMEN))
While SZD->ZD_FILIAL == xFilial("SZD") .AND.;
	SZD->ZD_TRANSP == MZD_TRANSP .AND.;
	SZD->ZD_DOCUMEN == MZD_DOCUMEN
	RecLock("SZD",.F.)
	SZD->(dbDelete())
	MsUnLock()
	SZD->(dbSkip())
End
Return

//*******************************************************************

User Function _vTransp()
MZD_NMTRAN := Posicione("SA2",1,xFilial("SA2")+MZD_TRANSP,"A2_NOME")
Return(.T.)

User Function _vdocumen()
MZD_NMTRAN := Posicione("SZC",1,xFilial("SZC")+MZD_TRANSP,"ZC_DESC")
Return(.T.)


//*******************************************************************
User Function _ValTudo
lRet := .T.
If !lInc
	Return(.T.)
EndIf
If SZD->(dbSeek(xFilial()+MZD_TRANSP+MZD_DOCUMEN)) .and. lRet
	MsgStop("Relacionamento Ja Existente!!!")
	lRet := .F.
EndIf
If !SA2->(dbSeek(xFilial()+MZD_TRANSP)) .and. lRet
	MsgStop("Transportadora Invalida!!!")
	lRet := .F.
EndIf

//If !SX5->(dbSeek(xFilial()+"12"+MZJ_ESTADO)) .and. lRet
//	MsgStop("Estado Invalido!!!")
//	lRet := .F.
//EndIf

//If !(MZJ_CAPINT $ "CI") .and. lRet
//	MsgStop("Informacao Invalida!!!"+chr(10)+"C - Capital"+chr(10)+"I - Interior")
//	lRet := .F.
//EndIf

//If aCols[1][2] == 0 .and. lRet
//	MsgStop("Informe ao menos um limite!!!")
//	lRet := .F.
//EndIf

Return(lRet)

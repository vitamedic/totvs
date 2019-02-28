#include "rwmake.ch"
#include "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITQ009   ³Autor  ³Gardenia ILany      ³Data ³  18/08/04   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Formula Mestre                                       	    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function VITQ009()

SetPrvt("_cOP")
Private nRadio := 1
Private _cFilDoc :="" //Incluido por Gleyb Eurestes.

_cprod := space(15)
@ 023,090 To 250,500 Dialog oQcr Title OemToAnsi("Emissao da Formula Mestre")
@ 015,010 SAY OemToAnsi("Produto:")
@ 015,030 GET _cprod SIZE 45,10 F3 "SB1"
@ 009,160 BmpButton Type 1 ACTION ImprOP(_cprod, nRadio) // Define os botões de ação
@ 025,160 BmpButton Type 2 ACTION CLOSE(oQcr)
Activate Dialog oQcr Centered

Return (.t.)

Static Function ImprOP(cprod, nRadio)
SetPrvt("_aCodB,_aNSer,lFlagSeek,nRadio")

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+cprod))
_lotepad:=sb1->b1_le
_um:=sb1->b1_um

_cfilsah:=xfilial("SAH")
sah->(dbsetorder(1))

sah->(dbseek(_cfilsah+sb1->b1_segum))
if sb1->b1_tipconv=="M"
	_qtsegum := sb1->b1_le * sb1->b1_conv
	_umsegum := upper(sah->ah_descpo)
else
	_qtsegum := sb1->b1_le/sb1->b1_conv
	_umsegum := upper(sah->ah_descpo)
endif

if SB1->(Eof()) .or. Empty(cprod)
	MsgAlert("Produto  Não encontrado!")
	Return()
endif

lOk := .t.

QZ1->(dbSetOrder(1))
QZ1->(DBSeek(xFilial("QZ1") + cProd ))
While QZ1->QZ1_PROD == cProd .and. lOk
	cTipo := Alltrim(Posicione("QDH",1,xfilial("QDH") + QZ1->QZ1_DOCTO,"QDH_CODTP"))
	If cTipo $ "OP/OE" // Guilherme Teodoro - 19/05/2016 - Melhoria para contemplar outros tipos de documentos - Projeto P.I.
		lOk := .f.
		_cFilDoc := xFilial("QDH")+QZ1->QZ1_DOCTO //Formula de Documento
	Else
		QZ1->(DbSkip())
	EndIf
EndDo

QDH->(dbSetOrder(1))
QDH->(dbSeek(_cFilDoc))
While (QDH->QDH_FILIAL + QDH->QDH_DOCTO == _cFilDoc .and. QDH->QDH_OBSOL == "S" .and. !Empty(QDH->QDH_DTVIG)) .and. !QDH->(EOF())
	QDH->(DBSkip())
EndDo
_dData := QDH->QDH_DTVIG
_cRev  := QDH->QDH_RV

If QDH->(!Eof()) .and. QDH->QDH_FILIAL + QDH->QDH_DOCTO == _cFilDoc .and. QDH->QDH_OBSOL == "N"
	cQArqTmp := GetNewPar("MV_QPATHWT","C:\WINDOWS\TEMP\") + Alltrim(QDH->QDH_NOMDOC)
	cArquivo := GetNewPar("MV_QPATHW","\DADOSADV\DOCS\")   + "\" + Alltrim(QDH->QDH_NOMDOC)
	__CopyFile(cArquivo,cQArqTmp)
	
	// Inicializa o Ole com o MS-Word 97 ( 8.0 )
	oWord := OLE_CreateLink('TMsOleWord97')
	OLE_OpenFile( oWord, cQArqTmP, .f. , "CELEWIN400" , "CELEWIN400" )
	
	OLE_SetDocumentVar( oWord, "Adv_Lote" , "999999")
	OLE_SetDocumentVar( oWord, "Adv_DtFab", "99/9999")
	OLE_SetDocumentVar( oWord, "Adv_DtVal", "99/9999")
	OLE_SetDocumentVar( oWord, "Adv_PsDtFab", "99/99/99")
	OLE_SetDocumentVar( oWord, "Adv_PsDtVal", "99/99/99")
	OLE_SetDocumentVar( oWord, "Adv_QtdeProduzida", _lotepad)
	OLE_SetDocumentVar( oWord, "Adv_UN", _um)
	OLE_SetDocumentVar( oWord, "Adv_QtdeLtPadrao", Transform(_lotepad, "@E 999,999,999.99") )
	OLE_SetDocumentVar( oWord, "Adv_QtdeProduzida2", Transform(_qtsegum, "@E 999,999,999.99") )
	OLE_SetDocumentVar( oWord, "Adv_UN2", _umsegum)
	OLE_SetDocumentVar( oWord, "Adv_TipoOP","FORMULA MESTRE")
		
	_cquery := " SELECT"
	_cquery += " G1_COD, G1_COMP, G1_TRT, G1_QUANT, G1_POTENCI"
	_cquery += " FROM "
	_cquery +=  retsqlname("SG1")+" SG1, "
	_cquery += " WHERE"
	_cquery += "     SG1.D_E_L_E_T_ <> '*'"
	_cquery += " AND G1_FILIAL = '"+xFilial("SG1") + "'"
	_cquery += " AND G1_COD  = '" + cprod + "'"
	_cQuery += " ORDER BY G1_TRT, G1_COMP "
	
	_cquery := changequery(_cquery)
		
	tcquery _cquery new alias "TMP1"
	tcsetfield("TMP1","G1_QUANT","N",12,2)
	tcsetfield("TMP1","G1_POTENCI","N",5,2)
		
	dbSelectArea("TMP1")
	dbGoTop()
	cLtSG1 := 0
	cQtde  := ""
	cPotencia  := ""
	cPSG1  := TMP1->G1_COMP

	While !TMP1->(EOF())
		cQtde  := Transform(tmp1->g1_quant,"@E 999,999,999.99")
		cPotencia := Transform(tmp1->g1_potenci,"@E 999.99") +"%"
		cVarLt := Alltrim("Adv_Pos"  + tmp1->g1_trt)
		cVarQd := Alltrim("Adv_Qtde" + tmp1->g1_trt)
		cVarPot := Alltrim("Adv_Pot" + tmp1->g1_trt)
		OLE_SetDocumentVar( oWord, cVarLt, Space(1) ) // Lote
		OLE_SetDocumentVar( oWord, cVarQd, cQtde )  // Quantidade
		OLE_SetDocumentVar( oWord, cVarPot, cPotencia )  // Potencia de Lote
		TMP1->(DBSkip())
	Enddo

	tmp1->(dbclosearea())
		
	// colocar execute macro	 		
	// OLE_ExecuteMacro(oWord, "CorRed")

	OLE_UpDateFields( oWord )
	OLE_SaveFile( oWord )
		
	MsgINFO("Clique em Ok assim que terminar a impressão do documento...")
		
	OLE_CloseFile( oWord )
	OLE_CloseLink( oWord )
else
	MsgAlert("O documento (Técnica de fabricação) deste produto não foi encontrado!")
endif

CLOSE(oQcr)
Return
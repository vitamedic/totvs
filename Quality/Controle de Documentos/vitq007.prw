#include "rwmake.ch"
#include "topconn.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITQ007   ³Autor  ³Lúcia Valéria      ³Data ³  14/04/04    ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Desc.     ³ Ordem de Produção Específica para Laboratorio Vitapan	    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function Vitq007()

SetPrvt("_cOP")
Private aRadio := {"Todos","Ordem de Pesagem","Técnica de Fabricação"}
Private nRadio := 1
Private _cFilDoc :="" //Incluido por Gleyb Eurestes.

_cOP := space(13)
@ 023,090 To 250,500 Dialog oQcr Title OemToAnsi("Emissao da Ordem de Producao")
@ 015,010 SAY OemToAnsi("Numero da OP:")
@ 015,030 GET _cOP SIZE 45,10 F3 "SC2"
@ 050,010 TO 100,200 TITLE OemToAnsi("Opcoes de Impressao")
@ 060,030 RADIO aRadio VAR nRadio
@ 009,160 BmpButton Type 1 ACTION ImprOP(_cOP, nRadio) // Define os botões de ação
@ 025,160 BmpButton Type 2 ACTION CLOSE(oQcr)
Activate Dialog oQcr Centered

Return (.t.)

Static Function ImprOP(cNumOP, nRadio)
SetPrvt("_aCodB,_aNSer,lFlagSeek,nRadio")

SC2->(dbSetOrder(1))
SC2->(dbSeek(xFilial("SC2")+cNumOP ))
if SC2->(Eof()) .or. Empty(cNumOP)
	MsgAlert("OP Não encontrada!")
	Return()
endif

lOk := .t.
cProd := SC2->C2_PRODUTO
QZ1->(dbSetOrder(1))
QZ1->(DBSeek(xFilial("QZ1") + cProd ))

While QZ1->QZ1_PROD == cProd .and. lOk
	cTipo := Alltrim(Posicione("QDH",1,xfilial("QDH") + QZ1->QZ1_DOCTO,"QDH_CODTP"))
	If cTipo $ "OP/OE"  // Guilherme Teodoro - 19/05/2016 - Melhoria para contemplar outros tipos de documentos - Projeto P.I. 
		lOk := .f.
		_cFilDoc := xFilial("QDH")+QZ1->QZ1_DOCTO //Formula de Documento
	Else
		QZ1->(DbSkip())
	EndIf
EndDo

_reimprime:= .f.
_dtvig:=ctod("  /  /  ")
 
QDH->(dbSetOrder(1))
QDH->(dbSeek(_cFilDoc))


//¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
//¹¹
//¹¹   Teste para verificar se OP emitida é anterior à data de vigência da Revisão 000
//¹¹
//¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹

if (sc2->c2_emissao < qdh->qdh_dtvig) .and.;
	(nRadio <> 2) .and.;
	(qdh->qdh_filial + qdh->qdh_docto == _cFilDoc)
	MsgAlert("A Técnica de Fabricação deste produto/lote foi emitida fora do Celerina! Entre em contato com a Garantia da Qualidade")
	return()
endif                              

While (QDH->QDH_FILIAL + QDH->QDH_DOCTO == _cFilDoc .and.;
		 QDH->QDH_OBSOL == "S" .and.;
		 !Empty(QDH->QDH_DTVIG)) .and.;
		!QDH->(EOF()) .and.;
		!(_reimprime)

	_dtvig:=qdh->qdh_dtvig
	QDH->(DBSkip())
	
	if sc2->c2_emissao >= _dtvig .and.;
		sc2->c2_emissao < qdh->qdh_dtvig

		if msgyesno("Fórmula-Mestra já revisada pela Garantia da Qualidade. Deseja reimprimir documento?")
			qdh->(dbskip(-1))
			_reimprime:= .t.
		else
			return()
		endif	
	endif		
EndDo                    

_dData := QDH->QDH_DTVIG
_cRev  := QDH->QDH_RV

_cfilsb1:=xfilial("SB1")
SB1->(dbsetorder(1))
SB1->(dbSeek(_cfilsb1+cProd))

If nRadio <> 3
   _aArea := SC2->(GetArea())
	cOp   := SubStr(cNumOP,1,6)
	cItem := SubStr(cNumOP,7,2)
	U_Vit016p(cOp,cItem)
	RestArea(_aArea)
EndIf

If nRadio <> 2 // Imprime o Documento de Tecnica de Fabricação
	If (QDH->(!Eof()) .and. QDH->QDH_FILIAL + QDH->QDH_DOCTO == _cFilDoc) .and.;
		((QDH->QDH_OBSOL == "N" .and. !Empty(QDH->QDH_DTVIG)) .or. _reimprime)
		cQArqTmp := GetNewPar("MV_QPATHWT","C:\WINDOWS\TEMP\") + Alltrim(QDH->QDH_NOMDOC)
		cArquivo := GetNewPar("MV_QPATHW","\DADOSADV\DOCS\")   + "\" + Alltrim(QDH->QDH_NOMDOC)
		__CopyFile(cArquivo,cQArqTmp)
		
		// Inicializa o Ole com o MS-Word 97 ( 8.0 )
		oWord := OLE_CreateLink('TMsOleWord97')  
		OLE_OpenFile( oWord, cQArqTmP, .f. , "CELEWIN400", "CELEWIN400" )
		OLE_SetDocumentVar( oWord, "Adv_Lote", SC2->C2_LOTECTL)
		OLE_SetDocumentVar( oWord, "Adv_CodProduto", SB1->B1_COD)
		OLE_SetDocumentVar( oWord, "Adv_Produto", SB1->B1_DESC)
		OLE_SetDocumentVar( oWord, "Adv_DtFab", StrZero(month(SC2->C2_DATPRF ),2) + "/" + SubStr(StrZero(year(SC2->C2_DATPRF ),4),3,2) )
		OLE_SetDocumentVar( oWord, "Adv_DtVal", StrZero(month(SC2->C2_DTVALID),2) + "/" + SubStr(StrZero(year(SC2->C2_DTVALID),4),3,2) )
		OLE_SetDocumentVar( oWord, "Adv_PsDtFab",StrZero(day(SC2->C2_DATPRF ),2) +"/" +StrZero(month(SC2->C2_DATPRF ),2) + "/" + SubStr(StrZero(year(SC2->C2_DATPRF ),2),3,2) )
		OLE_SetDocumentVar( oWord, "Adv_PsDtVal", StrZero(day(SC2->C2_DATPRF ),2) +"/" +StrZero(month(SC2->C2_DTVALID),2) + "/" + SubStr(StrZero(year(SC2->C2_DTVALID),2),3,2) )
		OLE_SetDocumentVar( oWord, "Adv_QtdeProduzida", Transform(SC2->C2_QUANT, "@E 999,999,999.99") )
		OLE_SetDocumentVar( oWord, "Adv_QtdeLtPadrao", Transform(SB1->B1_LE, "@E 999,999,999.99") )
		OLE_SetDocumentVar( oWord, "Adv_UN", SC2->C2_UM)
		OLE_SetDocumentVar( oWord, "Adv_TipoOP","ORDEM DE PRODUÇÃO")
		
		_cquery := " SELECT"
		_cquery += " D4_OP, D4_COD, D4_TRT, D4_LOTECTL, D4_QTDEORI"
		_cquery += " FROM "
		_cquery +=  retsqlname("SD4")+" SD4, "
		_cquery += " WHERE"
		_cquery += "     SD4.D_E_L_E_T_ <> '*'"
		_cquery += " AND D4_FILIAL = '"+xFilial("SD4") + "'"
		_cquery += " AND D4_OP  = '" + cNumOP + "'"
		_cquery += " AND D4_TRT <> '"+space(3)+ "'"
//		_cQuery += " ORDER BY D4_TRT, D4_COD, D4_LOTECTL "
   	_cQuery += " ORDER BY D4_TRT"
		_cquery := changequery(_cquery)
		
		tcquery _cquery new alias "TMP1"
		tcsetfield("TMP1","D4_QTDEORI","N",12,2)
		
		dbSelectArea("TMP1")
		dbGoTop()
		cLtSD4 := ""
		cQtde  := ""
		cPSd4  := TMP1->D4_COD

		While !TMP1->(EOF())
      	_trt := tmp1->d4_trt
			cLtSD4 := ""
			cQtde  := ""
			While !TMP1->(EOF()) .and. _trt == tmp1->d4_trt
//				cLtSD4 := TMP1->D4_LOTECTL
//				cQtde  := Transform(TMP1->D4_QTDEORI,"@E 999,999,999.99")
				cVarLt := Alltrim("Adv_Pos"  + TMP1->D4_TRT)
				cVarQd := Alltrim("Adv_Qtde" + TMP1->D4_TRT)
				cLtSD4 += "  " + TMP1->D4_LOTECTL
				cQtde  += "  " + Transform(TMP1->D4_QTDEORI,"@E 999,999,999.99")
				TMP1->(DBSkip())
			enddo	
			OLE_SetDocumentVar( oWord, cVarLt, cLtSD4 ) // Lote
			OLE_SetDocumentVar( oWord, cVarQd, cQtde )  // Quantidade
		Enddo



		tmp1->(dbclosearea())

		OLE_UpDateFields( oWord )
		OLE_SaveFile( oWord )
		// colocar execute macro	 		
		OLE_ExecuteMacro(oWord, "ProtOP")
		
		MsgINFO("Clique em Ok assim que terminar a impressão do documento...")
		
		OLE_CloseFile( oWord )
		OLE_CloseLink( oWord )
	else
		MsgAlert("O documento (Técnica de fabricação) deste produto não foi encontrado! Entre em contato com a Garantia da Qualidade")
	endif
EndIf

CLOSE(oQcr)
Return
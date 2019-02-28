#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/06/00
#include "topconn.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QDOM601   ³Autor ³ Programacao Quality   ³ Data ³ 14/09/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Transfere os Valores das Var. de Memoria para Var. do Word ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 			                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function qdom710()        // incluido pelo assistente de conversao do AP5 IDE em 26/06/00
Local dDtImp := Ctod("  /  /  ")
Local cRef   := ""
Local cMacro := GetMV("MV_QNMAC")
Local cProduto  := Space(1)
Local cDescProd := Space(1)
Local cApresent := Space(1)

// Busca codigo do produto e descricao
If Alltrim(M->QDH_CODTP) $ "OP/OE" // Guilherme Teodoro - 19/05/2016 - Melhoria para contemplar outros tipos de documentos - Projeto P.I.
	cProduto  := Posicione("QZ1",2,xFilial("QZ1") + M->QDH_DOCTO,"QZ1_PROD")
	If SB1->(DBSeek(xFilial("SB1") + cProduto))
		cApresent := SB1->B1_APRES
		cDescProd := SB1->B1_DESC
	endIf	
EndIf

//Busca data de Implantacao
_aArea := GetArea()
If QDH->(DbSeek(xFilial("QDH") + M->QDH_DOCTO))
	If !Empty(QDH->QDH_DTIMPL)
		dDtImp := QDH->QDH_DTIMPL
	EndIf
Else
	dDtImp := M->QDH_DTIMPL
EndIf
RestArea(_aArea)

// Busca Referencias:
_aArea := GetArea()
If QDB->(DbSeek(xFilial("QDB") + M->QDH_DOCTO + M->QDH_RV))
	While !QDB->(EOF()) .and. M->QDH_DOCTO == QDB->QDB_DOCTO .and. M->QDH_RV == QDB->QDB_RV
		If cRef == ""
			cRef := "- " + AllTrim(QDB->QDB_DESC)
		Else
			cRef += ";" + chr(13) + "- " + AllTrim(QDB->QDB_DESC)
		EndIf
		QDB->(DBSkip())
	End
EndIf
cRef += "."


// Buscar os Elaboradores, Revisores e Aprovadores
//msgstop(aQD0Doc[1,1]) //Array com os responsáveis antes da confirmação do cadastro.

if alltrim(M->qdh_codtp)="PROT"
	
	_cfilqaa:=xfilial("QAA")
	qaa->(dbsetorder(1))
	
	_elab:=0
	_revi:=0
	_apro:=0
	_homo:=0
	
	if !empty(aQD0Doc)
		
		for _i:=1 to len(aQD0Doc)
			if aQD0Doc[_i,1]="E"
				_elab++
				qaa->(dbseek(_cfilqaa+aQD0Doc[_i,4]))
				_cvar:="_cElabora"+strzero(_elab,1)
				&_cvar:=RetNome(qaa->qaa_login)
				
			elseif aQD0Doc[_i,1]="R"
				_revi++
				qaa->(dbseek(_cfilqaa+aQD0Doc[_i,4]))
				_cvar:="_cRevisor"+strzero(_revi,1)
				&_cvar:=RetNome(qaa->qaa_login)
				
			elseif aQD0Doc[_i,1]="A"
				_apro++
				qaa->(dbseek(_cfilqaa+aQD0Doc[_i,4]))
				_cvar:="_cAprovad"+strzero(_apro,1)
				&_cvar:=RetNome(qaa->qaa_login)
				
			elseif aQD0Doc[_i,1]="H"
				_homo++
				qaa->(dbseek(_cfilqaa+aQD0Doc[_i,4]))
				_cvar:="_cHomolog"+strzero(_homo,1)
				&_cvar:=RetNome(qaa->qaa_login)
			endif
		next
	end
	
else
	cElabora := RetNome(cApElabo)
	cRevisor := RetNome(cApRevis)
	cAprovad := RetNome(cApAprov)
	cHomolog := RetNome(cApHomol)
endif
RestArea(_aArea)


//Identifica o tipo de cópia
cTpCopia := "CÓPIA NÃO CONTROLADA"

//Variaveis do .DOT Padrao
OLE_SetDocumentVar( oWord, "Adv_CodProduto" , Alltrim(cProduto ) )
OLE_SetDocumentVar( oWord, "Adv_Produto"   , Alltrim(cDescProd) )
OLE_SetDocumentVar( oWord, "Adv_Apresenta"  , Alltrim(cApresent) )
OLE_SetDocumentVar( oWord, "Adv_Lote" ,    Space(1) )
OLE_SetDocumentVar( oWord, "Adv_DtFab",    Space(1) )
OLE_SetDocumentVar( oWord, "Adv_DtVal",    Space(1) )
OLE_SetDocumentVar( oWord, "Adv_PsDtFab",    Space(1) )
OLE_SetDocumentVar( oWord, "Adv_PsDtVal",    Space(1) )
OLE_SetDocumentVar( oWord, "Adv_QtdeProduzida", Space(1) )
OLE_SetDocumentVar( oWord, "Adv_QtdeLtPadrao",  Space(1) )

OLE_SetDocumentVar( oWord, "Adv_UN",       Space(1) )

OLE_SetDocumentVar( oWord, "Adv_NomeFilial"        , cNomFilial )                                            	//01 - Filial do Sistema
OLE_SetDocumentVar( oWord, "Adv_Copia"   , cTpCopia )                                              	//02 - Copia Controlada
//OLE_SetDocumentVar( oWord, "Adv_CopiaControlada"   , cTpCopia )                                              	//02 - Copia Controlada
OLE_SetDocumentVar( oWord, "Adv_Cancel"            , If( M->QDH_CANCEL == 'S','Documento Cancelado',' ' ) ) //03 - Cancelado
OLE_SetDocumentVar( oWord, "Adv_Obsoleto"          , If( M->QDH_OBSOL  == 'S','Documento Obsoleto' ,' ' ) )	//04 - Obsoleto
OLE_SetDocumentVar( oWord, "Adv_DTpDoc"            , QDXFNANTPD( M->QDH_CODTP, .t. ) )                     	//05 - Tipo
OLE_SetDocumentVar( oWord, "Adv_DataVigencia"      , DtoC( M->QDH_DTVIG ) )                                 	//06 - Data de Vigencia
OLE_SetDocumentVar( oWord, "Adv_Titulo"            , M->QDH_TITULO )                                  	     	//07 - Titulo
OLE_SetDocumentVar( oWord, "Adv_Objetivo"          , cObjetivo )                        								//08 - Objetivo
OLE_SetDocumentVar( oWord, "Adv_MotivoRevisao"     , cMotRevi )                                             	//13 - Motivo da Revisao
OLE_SetDocumentVar( oWord, "Adv_Referencia"        , cRef )                                             	//13 - Motivo da Revisao
OLE_SetDocumentVar( oWord, "Adv_NUsrR"             , cNomRece )                                             	//09 - Destinatario

If Empty( cNomRece )
	OLE_SetDocumentVar( oWord, "Adv_NDeptoR"        , " " )
Else                                                                                                        	//10 - Departamento do Destinatario ( Nome )
	OLE_SetDocumentVar( oWord, "Adv_NDeptoR"        , QA_NDEPT( QDG->QDG_DEPTO,.T.,QDG->QDG_FILMAT) )
Endif
OLE_SetDocumentVar( oWord, "Adv_NDeptoD"           , QA_nDeptos( M->QDH_FILIAL, M->QDH_DOCTO, M->QDH_RV ) )	//11 - Departamento Recebedores - Distribuicao ( Nome )
OLE_SetDocumentVar( oWord, "Adv_Sumario"           , cSumario )                                            	//12 - Sumario
OLE_SetDocumentVar( oWord, "Adv_Docto"             , Alltrim( M->QDH_DOCTO ) )                              	//18 - Codigo do Documento
OLE_SetDocumentVar( oWord, "Adv_Rv"                , M->QDH_RV )                                            	//19 - Numero da Revisao
OLE_SetDocumentVar( oWord, "Adv_Rodape"            , cRodape )                                              	//20 - Rodape

OLE_SetDocumentVar( oWord, "Adv_MdpCodigo",             cCodAtu )
OLE_SetDocumentVar( oWord, "Adv_MdpNovCod",             cCodNov )
OLE_SetDocumentVar( oWord, "Adv_MdsDescr",              cDescr  )
OLE_SetDocumentVar( oWord, "Adv_MdpDe",                 cDe )
OLE_SetDocumentVar( oWord, "Adv_MdpPara",               cPara )
OLE_SetDocumentVar( oWord, "Adv_MdpRaz",                cMdpRaz )
OLE_SetDocumentVar( oWord, "Adv_MdpObs",                cMdpObs )
OLE_SetDocumentVar( oWord, "Adv_MdsRaz",                cMdsRaz )
OLE_SetDocumentVar( oWord, "Adv_MdsObs",                cMdsObs )

OLE_SetDocumentVar( oWord, "Adv_DataImplantacao",       dDtImp )//DtoC( M->QDH_DTIMPL ) )                                //44 - Data de Implantacao
OLE_SetDocumentVar( oWord, "Adv_DataRevisao",           DtoC( M->QDH_DTVIG  ) )                                //44 - Data de Implantacao

OLE_SetDocumentVar( oWord, "Adv_ApelidoElaborador" , cApElabo )                                             	//14 - Elaboradores( Apelido )
OLE_SetDocumentVar( oWord, "Adv_ApelidoRevisor"    , cApRevis )                                             	//15 - Revisores( Apelido )
OLE_SetDocumentVar( oWord, "Adv_ApelidoAprovador"  , cApAprov )                                             	//16 - Aprovadores( Apelido )
OLE_SetDocumentVar( oWord, "Adv_ApelidoHomologador", cApHomol )                                             	//17 - Homologador ( Apelido )

if alltrim(M->qdh_codtp)=="PROT"
	for _i:=1 to _elab
		_cvar:="Adv_Elaborador"+strzero(_i,1)
		_cvar2:="_cElabora"+strzero(_i,1)
		OLE_SetDocumentVar( oWord, _cvar , &_cvar2 )                                   							//22 - Elaborador ( Nome )
	next
	for _i:=1 to _revi
		_cvar:="Adv_Revisor"+strzero(_i,1)
		_cvar2:="_cRevisor"+strzero(_i,1)
		OLE_SetDocumentVar( oWord, _cvar , &_cvar2 )                                      						//23 - Revisor ( Nome )
	next
	for _i:=1 to _apro
		_cvar:="Adv_Aprovador"+strzero(_i,1)
		_cvar2:="_cAprovad"+strzero(_i,1)
		OLE_SetDocumentVar( oWord, _cvar , &_cvar2 )                                    							//24 - Aprovador ( Nome )
	next
	for _i:=1 to _homo
		_cvar:="Adv_Homologador"+strzero(_i,1)
		_cvar2:="_cHomolog"+strzero(_i,1)
		OLE_SetDocumentVar( oWord, _cvar , &_cvar2 )                                  								//25 - Homologador ( Nome )
	next
	
else
	OLE_SetDocumentVar( oWord, "Adv_Elaborador"        , cElabora )                                             //22 - Elaborador ( Nome )
	OLE_SetDocumentVar( oWord, "Adv_Revisor"           , cRevisor )                                             //23 - Revisor ( Nome )
	OLE_SetDocumentVar( oWord, "Adv_Aprovador"         , cAprovad )                                             //24 - Aprovador ( Nome )
	OLE_SetDocumentVar( oWord, "Adv_Homologador"       , cHomolog )                                             //25 - Homologador ( Nome )
endif

// Atualiza dados da OP
If Alltrim(M->QDH_CODTP) $ "OP/OE" // Guilherme Teodoro - 19/05/2016 - Melhoria para contemplar outros tipos de documentos - Projeto P.I.
	OLE_ExecuteMacro(oWord, "ProtOP")
	u_vitq011(cProduto)
EndIf

for i:= 1 to 30
	cVar := "Adv_Pos" + StrZero(i,2)
	OLE_SetDocumentVar( oWord, cVar, Space(1) )                                             //25 - Homologador ( Nome )
next

If  !(Alltrim(M->QDH_CODTP) $ cMacro )
	OLE_ExecuteMacro(oWord, "CorGreen")
EndIf

Return

Static Function RetNome(cApelido)

Local _daduser  := {}
Local _nomeuser := Alltrim(cApelido) // substr(cusuario,7,15)
Local _cNome := ""

psworder(2)

if pswseek(_nomeuser,.t.)
	_daduser:=pswret(1)
	_cNome  := _daduser[1,4]
endif

Return (_cNome)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³VITQ011   ³ Autor ³ Programacao Quality   ³ Data ³ 14/09/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Transfere os valores das var. de memoria para var. do word  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ 			                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function vitq011(cProduto)
_lotepad:= sb1->b1_le
_um     := sb1->b1_um

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

OLE_SetDocumentVar( oWord, "Adv_Lote" , "999999")
OLE_SetDocumentVar( oWord, "Adv_DtFab", "99/9999")
OLE_SetDocumentVar( oWord, "Adv_DtVal", "99/9999")
OLE_SetDocumentVar( oWord, "Adv_PsDtFab", "99/99/99")
OLE_SetDocumentVar( oWord, "Adv_PsDtVal", "99/99/99")

OLE_SetDocumentVar( oWord, "Adv_QtdeProduzida", _lotepad)
OLE_SetDocumentVar( oWord, "Adv_QtdeLtPadrao", _lotepad)
OLE_SetDocumentVar( oWord, "Adv_UN", _um)
OLE_SetDocumentVar( oWord, "Adv_TipoOP","FORMULA MESTRE")

OLE_SetDocumentVar( oWord, "Adv_QtdeProduzida2", Transform(_qtsegum, "@E 999,999,999") )
OLE_SetDocumentVar( oWord, "Adv_UN2", _umsegum)

_cquery := " SELECT"
_cquery += " G1_COD, G1_COMP, G1_TRT, G1_QUANT, G1_POTENCI"
_cquery += " FROM "
_cquery +=  retsqlname("SG1")+" SG1, "
_cquery += " WHERE"
_cquery += "     SG1.D_E_L_E_T_ <> '*'"
_cquery += " AND G1_FILIAL = '"+xFilial("SG1") + "'"
_cquery += " AND G1_COD  = '" + cProduto + "'"
_cquery += " AND G1_TRT <>'   '"
_cquery += " AND SUBSTR(G1_COMP,1,3) <>'MOD'"
//	_cquery += " ORDER BY G1_TRT, G1_COMP "
_cquery += " ORDER BY G1_TRT"

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

While !tmp1->(EOF())
	cQtde  := Transform(tmp1->g1_quant,"@E 999,999,999.99")
	cPotencia := Transform(tmp1->g1_potenci,"@E 999.99") +"%"
	cVarLt := Alltrim("Adv_Pos"  + tmp1->g1_trt)
	cVarQd := Alltrim("Adv_Qtde" + TMP1->g1_trt)
	cVarPot := Alltrim("Adv_Pot" + tmp1->g1_trt)
	OLE_SetDocumentVar( oWord, cVarLt, Space(1) ) // Lote
	OLE_SetDocumentVar( oWord, cVarQd, cQtde )  // Quantidade
	OLE_SetDocumentVar( oWord, cVarPot, cPotencia )  // Potencia de Lote
	tmp1->(dbskip())
Enddo


tmp1->(dbclosearea())
Return
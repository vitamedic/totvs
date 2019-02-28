#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/06/00
#include "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QDOM720   ³Autor ³ Newton R. Ghiraldelli ³Data ³ 14/09/99  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Transfere os Valores das Var. de Memoria para Var. do Word ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ 			                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function qdom720()        // incluido pelo assistente de conversao do AP5 IDE em 26/06/00
Local dDtImp := Ctod("  /  /  ")
Local cRef   := ""
Local cDocto := M->QDH_DOCTO
Local	cRevi := StrZero(Val(M->QDH_RV),2) // Codigo da Revisão da Especificacaod de Entrada
Local cMacro := GetMV("MV_QNMAC")
Local cProduto  := ""
Local cDescProd := ""
Local cApresent := ""

// Busca codigo do produto e descricao
If Alltrim(M->QDH_CODTP) $ "OP/OE" // Guilherme Teodoro - 19/05/2016 - Melhoria para contemplar outros tipos de documentos - Projeto P.I.
	cProduto  := Posicione("QZ1",2,xFilial("QZ1") + M->QDH_DOCTO,"QZ1_PROD")
	cDescProd := Posicione("SB1",1,xFilial("SB1") + cproduto,"B1_DESC" )
	cApresent := Posicione("SB1",1,xFilial("SB1") + cproduto,"B1_APRES")
EndIf

//Busca data de Implantacao
_aArea := GetArea()
_cArq := "qdh"+SM0->M0_CODIGO+"0"
dbusearea(.t.,"TOPCONN",_carq,"TMP1",.t.,.f.)
dbsetindex(_carq+"1")
TMP1->(DBGoTop())
If TMP1->(DbSeek(xFilial("QDH") + cDocto))
	If !Empty(TMP1->QDH_DTIMPL)
		dDtImp := TMP1->QDH_DTIMPL
	EndIf
Else
	dDtImp := M->QDH_DTIMPL
EndIf
TMP1->(dbCloseArea())
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
RestArea(_aArea)
// Buscar os Elaboradores, Revisores e Aprovadores

if alltrim(M->qdh_codtp)=="PROT"
	_cfilqd0:=xfilial("QD0")
	_cfilqaa:=xfilial("QAA")

	_aArea:= GetArea()
	qd0->(dbsetorder(1))
	qaa->(dbsetorder(1))
	
	_cquery:=" SELECT"
	_cquery+=" QD0_DOCTO DOCTO,"
	_cquery+=" QD0_RV RV,"
	_cquery+=" QD0_AUT AUT,"
	_cquery+=" QD0_ORDEM ORDEM,"
	_cquery+=" QAA_APELID APELID,"
	_cquery+=" QAA_LOGIN LOGIN"
	_cquery+=" FROM "
	
	_cquery+=  retsqlname("QD0")+" QD0,"
	_cquery+=  retsqlname("QAA")+" QAA"
	
	_cquery+=" WHERE"
	_cquery+="     QD0.D_E_L_E_T_<>'*'"
	_cquery+=" AND QAA.D_E_L_E_T_<>'*'"
	_cquery+=" AND QD0_FILIAL='"+_cfilqd0+"'"
	_cquery+=" AND QAA_FILIAL='"+_cfilqaa+"'"
	_cquery+=" AND QD0_DOCTO='"+M->QDH_DOCTO+"'"
	_cquery+=" AND QD0_RV='"+M->QDH_RV+"'"
	_cquery+=" AND QD0_FLAG<>'I'"
	_cquery+=" AND QD0_MAT=QAA_MAT"
	_cquery+=" ORDER BY QD0_ORDEM, QD0_AUT"
	
	_cquery:=changequery(_cquery)
	tcquery _cquery alias "TMP2" new
	
	tmp2->(dbgotop())
	
	while ! tmp2->(eof())
		if tmp2->aut="E"
			_elab:=0
			while ! tmp2->(eof()) .and.;
				tmp2->aut=="E"
				_elab++
				_cvar:="_cElabora"+strzero(_elab,1)
				&_cvar:=RetNome(tmp2->login)
				tmp2->(dbskip())
			end
		elseif tmp2->aut="R"
			_revi:=0
			while ! tmp2->(eof()) .and.;
				tmp2->aut=="R"
				_revi++
				_cvar:="_cRevisor"+strzero(_revi,1)
				&_cvar:=RetNome(tmp2->login)
				tmp2->(dbskip())
			end
		elseif tmp2->aut="A"
			_apro:=0
			while ! tmp2->(eof()) .and.;
				tmp2->aut=="A"
				_apro++
				_cvar:="_cAprovad"+strzero(_apro,1)
				&_cvar:=RetNome(tmp2->login)
				tmp2->(dbskip())
			end
		elseif tmp2->aut="H"
			_homo:=0
			while ! tmp2->(eof()) .and.;
				tmp2->aut=="H"
				_homo++
				_cvar:="_cHomolog"+strzero(_homo,1)
				&_cvar:=RetNome(tmp2->login)
				tmp2->(dbskip())
			end
		endif
	end
	tmp2->(dbCloseArea())
	RestArea(_aArea)
	
else
	cElabora := RetNome(cApElabo)
	cRevisor := RetNome(cApRevis)
	cAprovad := RetNome(cApAprov)
	cHomolog := RetNome(cApHomol)
endif

//Identifica o tipo de cópia
If (funname() == "QDOA110"  .or. PROCNAME(12) == "QDOA110") .and. AllTrim(QDG->QDG_CODMAN) == "GQL"
	cTpCopia := Space(02)
elseIf funname() $ "QDOA110/QDOR200"  .or. PROCNAME(12) == "QDOA110"
	cTpCopia := "CÓPIA CONTROLADA"
Else
	cTpCopia := "CÓPIA NÃO CONTROLADA"
EndIf

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
OLE_SetDocumentVar( oWord, "Adv_QtdeLtPadrao", Space(1) )
OLE_SetDocumentVar( oWord, "Adv_UN",       Space(1) )
OLE_SetDocumentVar( oWord, "Adv_NomeFilial"   , cNomFilial )                                            	//01 - Filial do Sistema
OLE_SetDocumentVar( oWord, "Adv_Copia"        , cTpCopia )                                              	//02 - Copia Controlada
OLE_SetDocumentVar( oWord, "Adv_Cancel"       , If( M->QDH_CANCEL == 'S','Documento Cancelado',' ' ) ) //03 - Cancelado
OLE_SetDocumentVar( oWord, "Adv_Obsoleto"     , If( M->QDH_OBSOL  == 'S','Documento Obsoleto' ,' ' ) )	//04 - Obsoleto
OLE_SetDocumentVar( oWord, "Adv_DTpDoc"       , QDXFNANTPD( M->QDH_CODTP, .t. ) )                     	//05 - Tipo
OLE_SetDocumentVar( oWord, "Adv_DataVigencia" , DtoC( M->QDH_DTVIG ) )                                 	//06 - Data de Vigencia
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

// Executar Macros
If  !(Alltrim(M->QDH_CODTP) $ cMacro )
	If funname() == "QDOA110" .or. PROCNAME(12) == "QDOA110"
		OLE_ExecuteMacro(oWord, "CorRed")
	Else
		OLE_ExecuteMacro(oWord, "CorGreen")
	EndIf
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

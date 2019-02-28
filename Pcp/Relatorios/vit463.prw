#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} vit463
	ORDEM DE PRODUCAO - HTML 
@author Guilherme Teodoro
@since 11/07/17
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function vit463()

SetPrvt("_cOP")
Private aRadio := {"Técnica de Fabricação"}
Private nRadio := 1
Private _cFilDoc :=""

_cOP := space(13)
@ 023,090 To 250,500 Dialog _oQcr Title OemToAnsi("Emissao da Ordem de Producao")
@ 015,010 SAY OemToAnsi("Numero da OP:")
@ 015,030 GET _cOP SIZE 45,10 F3 "SC2"
@ 050,010 TO 100,200 TITLE OemToAnsi("Opcoes de Impressao")
@ 060,030 RADIO aRadio VAR nRadio
@ 009,160 BmpButton Type 1 ACTION vit318a(_cOP, nRadio) // Define os botões de ação
@ 025,160 BmpButton Type 2 ACTION CLOSE(_oQcr)
Activate Dialog _oQcr Centered

Return (.t.)

Static Function vit318a(cNumOP, nRadio)
nRadio := 3
SetPrvt("_aCodB,_aNSer,lFlagSeek,nRadio")

_cfilsah:=xfilial("SAH")
_cfilqaa:=xfilial("QAA")
sah->(dbsetorder(1))
qaa->(dbsetorder(6))

sc2->(dbSetOrder(1))
sc2->(dbSeek(xFilial("SC2")+cNumOP ))
if sc2->(Eof()) .or. Empty(cNumOP)
	MsgAlert("OP Não encontrada!")
	Return()
endif

lOk := .t.
_cprod := sc2->c2_produto
qz1->(dbSetOrder(1))
qz1->(DBSeek(xFilial("QZ1") + _cprod ))

While qz1->qz1_prod == _cprod .and. lOk
	cTipo := Alltrim(Posicione("QDH",1,xfilial("QDH") + qz1->qz1_docto,"QDH_CODTP"))
	If cTipo $ "OP/OE" // Guilherme Teodoro - 19/05/2016 - Melhoria para contemplar outros tipos de documentos - Projeto P.I.
		lOk := .f.
		_cFilDoc := xFilial("QDH")+qz1->qz1_docto //Formula de Documento
	Else
		qz1->(DbSkip())
	EndIf
EndDo

_reimprime:= .f.
_dtvig:=ctod("  /  /  ")

qdh->(dbSetOrder(1))
qdh->(dbSeek(_cFilDoc))


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
       

While (qdh->qdh_filial + qdh->qdh_docto == _cFilDoc .and.;
	qdh->qdh_obsol == "S" .and.;
	!Empty(qdh->qdh_dtvig)) .and.;
	!qdh->(EOF()) .and.;
	!(_reimprime)
	
	_dtvig:=qdh->qdh_dtvig
	qdh->(DBSkip())
	
	if sc2->c2_emissao >= _dtvig .and.;
		sc2->c2_emissao < qdh->qdh_dtvig
		
		if msgyesno("Fórmula-Mestra já revisada pela Garantia da Qualidade. Deseja reimprimir documento?")
			qdh->(dbskip(-1))
			_reimprime:= .t.
		else
			return()
		endif
	endif
end

_dData := qdh->qdh_dtvig
_cRev  := qdh->qdh_rv

//¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
//¹¹
//¹¹   Verificação de tentativa de reimpressão da Ordem de Produção                       
//¹¹
//¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹

                        
_login:= substr(cUsuario,7,15)
qaa->(dbseek(_login))

_dUsuario     := PSWRET()
_dptUsuario	  := Alltrim(_dUsuario[1][12])

//if !(sc2->c2_emissao >= (date()-3)) // Permite reimpressão de qualquer usuário com acesso, até 03 dias após data de emissão da OP
//	if !_dptUsuario $ "GTI - Tecnologia da Informacao"
//		if !alltrim(qaa->qaa_cc)$"010128020000/010128020001/010128020002/010128020003"
//			msgstop("Usuário nao autorizado a reimpressao deste documento! Contactar Garantia da Qualidade! ")
//			return()
//		endif       
//	endif
//endif

if !(sc2->c2_emissao >= (date()-3)) // Permite reimpressão de qualquer usuário com acesso, até 03 dias após data de emissão da OP
	if !_dptUsuario $ "GTI - Tecnologia da Informacao"
		if !_dptUsuario $ "GQL - Garantia da Qualidade/GQL VAL - Gerencia Garantia da Qualidade/GQL - Sistema da Qualidade/VAL - Depto. Validacao"
			msgstop("Usuário nao autorizado a reimpressao deste documento! Contactar Garantia da Qualidade! ")
			return()
		endif       
	endif
endif

_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))
sb1->(dbSeek(_cfilsb1+_cprod))

If nRadio <> 3
	_aArea := sc2->(getarea())
	_cOp   := cNumOP
	
	impemp(_cOp,_cprod)
	restarea(_aArea)
endif

If nRadio <> 2 // Imprime o Documento de Tecnica de Fabricação
	If (qdh->(!Eof()) .and. qdh->qdh_filial + qdh->qdh_docto == _cFilDoc) .and.;
		((qdh->qdh_obsol == "N" .and. !Empty(qdh->qdh_dtvig)) .or. _reimprime)
		cQArqTmp := GetNewPar("MV_QPATHWT","C:\WINDOWS\TEMP\") + Alltrim(qdh->qdh_nomdoc)
		cArquivo := GetNewPar("MV_QPATHW","\DADOSADV\DOCS\")   + "\" + Alltrim(qdh->qdh_nomdoc)
		__CopyFile(cArquivo,cQArqTmp)
		
		sah->(dbseek(_cfilsah+sb1->b1_segum))
		if sb1->b1_tipconv=="M"
			_qtsegum := sc2->c2_quant * sb1->b1_conv
			_umsegum := upper(sah->ah_descpo)
		else
			_qtsegum := sc2->c2_quant/sb1->b1_conv
			_umsegum := upper(sah->ah_descpo)
		endif
		
		// Inicializa o Ole com o MS-Word 97 ( 8.0 )
		oWord := OLE_CreateLink('TMsOleWord97')
		OLE_OpenFile( oWord, cQArqTmP, .f. , "CELEWIN400", "CELEWIN400" )
		OLE_SetDocumentVar( oWord, "Adv_Lote", sc2->c2_lotectl)
		OLE_SetDocumentVar( oWord, "Adv_CodProduto", sb1->b1_cod)
		OLE_SetDocumentVar( oWord, "Adv_Produto", sb1->b1_desc)
		OLE_SetDocumentVar( oWord, "Adv_Apresenta", sb1->b1_apres)
		OLE_SetDocumentVar( oWord, "Adv_DtFab", StrZero(month(sc2->c2_datpri ),2) + "/" + SubStr(StrZero(year(sc2->c2_datpri ),4),3,2) )
		OLE_SetDocumentVar( oWord, "Adv_DtVal", StrZero(month(sc2->c2_dtvalid),2) + "/" + SubStr(StrZero(year(sc2->c2_dtvalid),4),3,2) )
		OLE_SetDocumentVar( oWord, "Adv_PsDtFab",StrZero(day(sc2->c2_datpri ),2) +"/" +StrZero(month(sc2->c2_datpri ),2) + "/" + SubStr(StrZero(year(sc2->c2_datpri ),2),3,2) )
		OLE_SetDocumentVar( oWord, "Adv_PsDtVal", StrZero(day(sc2->c2_datpri ),2) +"/" +StrZero(month(sc2->c2_dtvalid),2) + "/" + SubStr(StrZero(year(sc2->c2_dtvalid),2),3,2) )
		OLE_SetDocumentVar( oWord, "Adv_QtdeProduzida", Transform(sc2->c2_quant, "@E 999,999,999") )
		OLE_SetDocumentVar( oWord, "Adv_QtdeLtPadrao", Transform(sb1->b1_le, "@E 999,999,999") )
		OLE_SetDocumentVar( oWord, "Adv_UN", sc2->c2_um)
		OLE_SetDocumentVar( oWord, "Adv_QtdeProduzida2", Transform(_qtsegum, "@E 999,999,999") )
		OLE_SetDocumentVar( oWord, "Adv_UN2", _umsegum)
		OLE_SetDocumentVar( oWord, "Adv_TipoOP","ORDEM DE PRODUÇÃO")
		
		_cquery := " SELECT"
		_cquery += " D4_OP, D4_COD, D4_TRT, D4_LOTECTL, D4_QTDEORI, D4_POTENCI"
		_cquery += " FROM "
		_cquery +=  retsqlname("SD4")+" SD4 "
		_cquery += " WHERE"
		_cquery += "     SD4.D_E_L_E_T_ <> '*'"
		_cquery += " AND D4_FILIAL = '"+xFilial("SD4") + "'"
		_cquery += " AND D4_OP  = '" + _cOp + "'"
		_cquery += " AND D4_TRT <> '"+space(3)+ "'"
		_cQuery += " ORDER BY D4_TRT"
		_cquery := changequery(_cquery)
		
		tcquery _cquery new alias "TMP1"
		tcsetfield("TMP1","D4_QTDEORI","N",12,2)
		tcsetfield("TMP1","D4_POTENCI","N",5,2)
		
		dbSelectArea("TMP1")
		dbGoTop()
		cLtSD4 := ""
		cQtde  := ""
		cQtdeCor:=""
		cPotencia:=""
		cPSd4  := tmp1->d4_cod
		
		While !tmp1->(EOF())
			_trt := tmp1->d4_trt
			cLtSD4 := ""
			cQtde  := ""
			cPotencia:=""
			While !TMP1->(EOF()) .and. _trt == tmp1->d4_trt
				cVarLt    := Alltrim("Adv_Pos"  + tmp1->d4_trt)
				cVarQd    := Alltrim("Adv_Qtde" + tmp1->d4_trt)
				CVarPot   :=Alltrim("Adv_Pot" + tmp1->d4_trt)
				
				cLtSD4 += "  " + tmp1->d4_lotectl
				cQtde  += "  " + Transform(tmp1->d4_qtdeori,"@E 999,999,999.99")
				cPotencia += "    " + Transform(tmp1->d4_potenci,"@E 999.99") +"%"
				
				tmp1->(DBSkip())
			enddo
			OLE_SetDocumentVar( oWord, cVarLt, cLtSD4 )    // Lote
			OLE_SetDocumentVar( oWord, cVarQd, cQtde )     // Quantidade
			OLE_SetDocumentVar( oWord, cVarPot, cPotencia )     // Potencia do Lote
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

close(_oQcr)
Return


//******************************************************//
//                                                      //
// Imprime Ordem de Pesagem MP e Ordem Separação ME     //
//                                                      //
//******************************************************//
Static Function impemp(_cop,_cprod)

//   Primeira pagina da OP
_cfilsc2:=xfilial("SC2")
_cfilsd4:=xfilial("SD4")
_cfilsdc:=xfilial("SDC")
_cfilsb1:=xfilial("SB1")
_cfilsg1:=xfilial("SG1")
sc2->(dbsetorder(1))
sd4->(dbsetorder(2))
sdc->(dbsetorder(2))
sah->(dbsetorder(1))
sb1->(dbsetorder(1))
sg1->(dbsetorder(1))

_mfirst := .t.
_mpag:=0
_cMsg:=""

_aestrut:={}
aadd(_aestrut,{"OP"       ,"C",13,0})
aadd(_aestrut,{"COD"      ,"C",15,0})
aadd(_aestrut,{"DESCRI"   ,"C",40,0})
aadd(_aestrut,{"ARM"      ,"C",02,0})
aadd(_aestrut,{"QTDEORI"  ,"N",11,2})
aadd(_aestrut,{"UM"       ,"C",02,0})
aadd(_aestrut,{"LOTECTL"  ,"C",10,0})
aadd(_aestrut,{"LOCALIZ"  ,"C",15,0})

_carqtmp4:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp4,"TMP4",.f.)
_cindtmp41:=criatrab(,.f.)
_cchave   :="op+cod+lotectl+localiz"
tmp4->(indregua("TMP4",_cindtmp41,_cchave))

_cindtmp42:=criatrab(,.f.)
_cchave   :="descri+lotectl+localiz"
tmp4->(indregua("TMP4",_cindtmp42,_cchave))

tmp4->(dbclearind())
tmp4->(dbsetindex(_cindtmp41))
tmp4->(dbsetindex(_cindtmp42))

tmp4->(dbsetorder(1))
tmp4->(dbgotop())

processa({|| _query2(_cop)})

processa({|| _query3(_cop)})

tmp2->(dbgotop())
tmp3->(dbgotop())

sb1->(dbseek(_cfilsb1+_cprod))

if sb1->b1_tipo$"EE/EN" // OP´s BENEFICIAMENTO ME E/OU GRAVACAO ALUMINIO
	// Requisição ME
	_cMsg += cabecalho(_cop,_cprod,2) // GERA CÓDIGO DO CABEÇALHO - MP
	_cMsg += requis_me(_cop,_cprod)
	
	// Requisição Adicional de ME
	_cMsg += cabecalho(_cop,_cprod,2) // GERA CÓDIGO DO CABEÇALHO - MP
	_cMsg += req_ad_me(_cop,_cprod)

	// Devolução de Materiais
//	_cMsg += cabecalho(_cop,_cprod,2) // GERA CÓDIGO DO CABEÇALHO - MP
	_cMsg += devol_me(_cop,_cprod)
		
elseif sb1->b1_tipo$"MP"
	// CadernoMP
	_cMsg += cabecalho(_cop,_cprod,1) // GERA CÓDIGO DO CABEÇALHO - MP
	_cMsg += pesagem(_cop,_cprod)
	
	// Pick-list MP
	_cMsg += pickmp(_cop,_cprod)
else
	// CadernoMP
	_cMsg += cabecalho(_cop,_cprod,1) // GERA CÓDIGO DO CABEÇALHO - MP
	_cMsg += pesagem(_cop,_cprod)
	
	// Pick-list MP
	_cMsg += pickmp(_cop,_cprod)
	
	// Requisição ME
	_cMsg += cabecalho(_cop,_cprod,2) // GERA CÓDIGO DO CABEÇALHO - ME
	_cMsg += requis_me(_cop,_cprod)
	
	// Requisição Adicional de ME
	_cMsg += cabecalho(_cop,_cprod,2) // GERA CÓDIGO DO CABEÇALHO - ME
	_cMsg += req_ad_me(_cop,_cprod)
	
	// Devolução de Materiais
//	_cMsg += cabecalho(_cop,_cprod,2) // GERA CÓDIGO DO CABEÇALHO - ME
	_cMsg += devol_me(_cop,_cprod)
	
	// O código abaixo foi retirado por solicitação da GQL - 02/2012 - Chamado Ocomon nº 1569.
	// Pick-list ME
	//_cMsg += pickme(_cop,_cprod)
	
endif

_cMsg += '</body>'
_cMsg += '</html>'

//Incluir aqui STRTRAN(<STRING>,<texto a ser substituido>,<novo texto>)
_cMsg := StrTran(_cMsg,"TOTALPAG",transform(_mpag,'@ 99'))

tmp2->(dbclosearea())
tmp3->(dbclosearea())

_cindtmp41+=tmp4->(ordbagext())
_cindtmp42+=tmp4->(ordbagext())

tmp4->(dbclosearea())

ferase(_carqtmp4+getdbextension())
ferase(_cindtmp41)
ferase(_cindtmp42)

//³ cria o arquivo em disco vit273.html e executa-o em seguida
_carquivo:="C:\WINDOWS\TEMP\OP.HTML"
nHdl := fCreate(_carquivo)
fWrite(nHdl,_cMsg,Len(_cMsg))
fClose(nHdl)
ExecArq(_carquivo)

set device to screen

ms_flush()
return


//********************************************
// Cabeçalho das Páginas numeradas
//********************************************


Static function cabecalho(_cop,_cprod,_tpcabec)

sb1->(dbseek(_cfilsb1+_cprod))
sc2->(dbseek(_cfilsc2+_cop))
sah->(dbseek(_cfilsah+sb1->b1_segum))

_cMsg3:=''

if _mfirst
	_mpag:=1
	_mfirst:=.f.
	_cMsg3 := ''
	_cMsg3 += '<html xmlns="http://www.w3.org/1999/xhtml">'
	_cMsg3 += '<head>'
	_cMsg3 += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
	//_cMsg3 += '<title>FICHA PESAGEM MP E SEPARA&Ccedil;&Atilde;O DE ME</title>' //Leandro 08/12/2016
	_cMsg3 += '<style type="text/css">'
	_cMsg3 += '<!--'
	_cMsg3 += '.style2 {font-family: Arial, Helvetica, sans-serif}'
	_cMsg3 += '.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 10px; }'
	_cMsg3 += '.style4 {font-family: Arial, Helvetica, sans-serif; font-size: 12px}'
	_cMsg3 += '.style6 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }'
	_cMsg3 += '-->'
	_cMsg3 += '</style>'
	_cMsg3 += '</head>'
	_cMsg3 += '<body>'
else
	_mpag++
endif

//³ IN�CIO DO CÓDIGO HTML
_cMsg3 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr><td>'
_cMsg3 += '<table width="1054" border="0" cellpadding="0" cellspacing="0"><tr>'
//_cMsg3 += '<td width="141" rowspan="5" class="style2"><p align="center"><img width="106" height="29" src="http://10.1.1.50/logovitapan.png" align="left" hspace="12" alt="logo.jpg" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </p></td>'
//_cMsg3 += '<td width="141" rowspan="5" class="style2"><p align="center"><img width="106" height="29" src=""http://10.1.1.40/laudo0101.png" align="left" hspace="12" alt="logo.jpg" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </p></td>' //Guilherme 21/08/15//Para que o endereço seja reolvido pelo named.
_cMsg3 += '<td width="141" rowspan="5" class="style2"><p align="center"><img width="106" height="29" src="https://drive.google.com/uc?id=1uN6KBQwMYScNoqqe1omuv-vd3KFvm-xc" align="left" hspace="12" alt="logo.jpg" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </p></td>' //MARCIO DAVID 06/08/18//Para que o endere�o seja reolvido pelo google drive.
_cMsg3 += '<td width="624" colspan="2" class="style2"><p>Produto: <strong>'+sb1->b1_cod+' &ndash; '+sb1->b1_desc+'</strong></p></td>'
_cMsg3 += '<td width="289" class="style2"><p align="right">P&aacute;gina '+transform(_mpag,'@ 99')+' de TOTALPAG</p></td></tr><tr>'
_cMsg3 += '<td width="624" colspan="2" class="style2"><p>Apresenta&ccedil;&atilde;o: '+sb1->b1_apres+'</p></td>'
_cMsg3 += '<td width="289"><p>&nbsp;</p></td></tr><tr>'

//_cMsg3 += '<td width="298" class="style2"><p>Lote: <strong>'+sc2->c2_num+'</strong></p></td>'

/*Inicio Leandro 08/12/2016*/
If sb1->b1_tipo == "PN"
_cMsg3 += '<td width="298" class="style2"><p>Lote: <strong>'+sc2->c2_lotectl+'</strong></p></td>'
Else 
_cMsg3 += '<td width="298" class="style2"><p>Lote: <strong>'+sc2->c2_num+'</strong></p></td>'
EndIf
/*Fim */

_cMsg3 += '<td width="326" class="style2"><p>Fab.: <strong>'+substr(dtos(sc2->c2_datpri),5,2)+'/'+substr(dtos(sc2->c2_datpri),1,4)+'</strong></p></td>'
_cMsg3 += '<td width="289" class="style2"><p>Val.: <strong>'+substr(dtos(sc2->c2_dtvalid),5,2)+'/'+substr(dtos(sc2->c2_dtvalid),1,4)+'</strong></p></td></tr><tr>'
_cMsg3 += '<td width="298" class="style2"><p>Qtde. Te&oacute;rica: <strong>'+Transform((sc2->c2_quant),'@E 9,999,999')+' '+sc2->c2_um+'</strong></p></td>'

if sb1->b1_tipconv=="M"
	_cMsg3 += '<td width="615" colspan="2" class="style2"><p>Qt. Te&oacute;rica 2&ordf; UM: <strong>'+Transform((sc2->c2_quant*sb1->b1_conv),'@E 9,999,999')+' '+upper(sah->ah_descpo)+'</strong></p></td></tr>'
else
	_cMsg3 += '<td width="615" colspan="2" class="style2"><p>Qt. Te&oacute;rica 2&ordf; UM: <strong>'+Transform((sc2->c2_quant/sb1->b1_conv),'@E 9,999,999')+' '+upper(sah->ah_descpo)+'</strong></p></td></tr>'
endif

if _tpcabec==1
	_cMsg3 += '<tr><td width="913" colspan="3" class="style2"><p align="center"><strong>ORDEM DE PESAGEM DE MAT&Eacute;RIA-PRIMA</strong></p></td></tr>'
else
	_cMsg3 += '<tr><td width="913" colspan="3" class="style2"><p align="center"><strong>ORDEM DE SEPARA&Ccedil;&Atilde;O DE  MATERIAL DE EMBALAGEM</strong></p></td></tr>'
endif
_cMsg3 += '</table></td></tr></table><br />'

return(_cMsg3)



//********************************************
// Rodapé da Primeira Página
//********************************************

Static function rodape(_cop,_cprod)

sb1->(dbseek(_cfilsb1+_cprod))
sc2->(dbseek(_cfilsc2+_cop))
sah->(dbseek(_cfilsah+sb1->b1_segum))

_cMsg4:=''

_cMsg4 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">' //1054
_cMsg4 += '<tr><td width="550">' //690
_cMsg4 += '<table width="550" cellpadding="0" cellspacing="0" border="0">' //690
_cMsg4 += '<tr><td width="550" colspan="3"><p class="style4"><b>1- Documento Impresso por:</b></p></td></tr>' //690
_cMsg4 += '<tr><td width="113"><p class="style4">PCP:</p></td>' //113
_cMsg4 += '<td width="352" align="center"><p class="style4">___________________________________________</p></td>' //352
_cMsg4 += '<td width="225"><p class="style4">Data: _____/_____/_____</p></td></tr>'  //225
//_cMsg4 += '<tr><td width="690" colspan="3">&nbsp;</td></tr></table></td>'
_cMsg4 += '</table></td>'
_cMsg4 += '<td width="364" bgcolor="#BFBFBF">' //364
//_cMsg4 += '<td rowspan="2" width="364" bgcolor="#BFBFBF">'
//_cMsg4 += '<td width="364" bgcolor="#BFBFBF">'
_cMsg4 += '<p class="style4" align="center"><b>&nbsp; LIBERACAO PELA GARANTIA DA QUALIDADE:</b></p>' //requisitado por GQL em 25/03/2015
//_cMsg4 += '<span class="style4">&nbsp; </span><br />'
//_cMsg4 += '<span class="style4">&nbsp; </span><br />'
//_cMsg4 += '<span class="style4">&nbsp; </span><br />'
//_cMsg4 += '<span class="style4">&nbsp; Encerramento:__________________________________</span><br/>'
//_cMsg4 += '<span class="style4">&nbsp; </span>'
_cMsg4 += '</td></tr>'
_cMsg4 += '<tr><td width="550">' //690
_cMsg4 += '<table width="550" cellpadding="0" cellspacing="0" border="0">' //690
_cMsg4 += '<tr><td width="550" colspan="3"><p class="style4"><b>2- Recebimento do Material:</b></p></td></tr>' //690
_cMsg4 += '<tr><td width="113"><p class="style4">Recebido por:</p></td>' //113
_cMsg4 += '<td width="352" align="center"><p class="style4">___________________________________________</p></td>' //352
_cMsg4 += '<td width="225"><p class="style4">Data: _____/_____/_____</p></td></tr>' //225
_cMsg4 += '</table></td>

_cMsg4 += '<td width="364">' //364
_cMsg4 += '<span class="style4">&nbsp; </span><br />'
_cMsg4 += '<span class="style4">&nbsp; Responsavel:______________________________ Data: ____/____/____</span><br/>' //requisitado por GQL em 25/03/2015
_cMsg4 += '<span class="style4">&nbsp; </span>'

_cMsg4 += '</td></tr></table>'
_cMsg4 += '<br />'

// quebra a pagina
_cMsg4 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
_cMsg4 += "<br clear=all style='page-break-before:always'>"
_cMsg4 += '</span>'

return(_cMsg4)

//********************************************
// Ordem de Pesagem de MP
//********************************************

Static function pesagem(_cop,_cprod)

sb1->(dbseek(_cfilsb1+_cprod))
sc2->(dbseek(_cfilsc2+_cop))
sah->(dbseek(_cfilsah+sb1->b1_segum))

_cMsg2:=''

_cMsg2 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
_cMsg2 += '<tr><td width="1054" colspan="12" height="25"><p align="center" class="style2"><strong>REQUISI&Ccedil;&Atilde;O DE MAT&Eacute;RIA-PRIMA</strong></p></td></tr>'
_cMsg2 += '<tr>'
_cMsg2 += '<td width="44" height="25"><p align="center" class="style6">C&oacute;digo </p></td>'
_cMsg2 += '<td width="259" height="25"><p align="center" class="style6">Mat&eacute;ria-Prima </p></td>'
_cMsg2 += '<td width="45" height="25"><p align="center" class="style6">DCB </p></td>'
_cMsg2 += '<td width="76" height="25"><p align="center" class="style6">Endere&ccedil;o </p></td>'
_cMsg2 += '<td width="90" height="25"><p align="center" class="style6">Peso</p></td>'
_cMsg2 += '<td width="96" height="25"><p align="center" class="style6">Pot&ecirc;ncia</p></td>'
_cMsg2 += '<td width="30" height="25"><p align="center" class="style6">UM </p></td>'
_cMsg2 += '<td width="76" height="25"><p align="center" class="style6">Lote </p></td>'
_cMsg2 += '<td width="104" height="25"><p align="center" class="style6">Peso Balan&ccedil;a </p></td>'
_cMsg2 += '<td width="81" height="25"><p align="center" class="style6">Pesador </p></td>'
_cMsg2 += '<td width="81" height="25"><p align="center" class="style6">Conferente </p></td>'
_cMsg2 += '<td width="72" height="25"><p align="center" class="style6">Data </p></td>'
_cMsg2 += '</tr>'
_linha:=1

_evapora:=.f.        
_txtevap:=.f.
while ! tmp2->(eof())
	
	if  (tmp2->arm == "02") .or.;
		(tmp2->arm == "01") .or.;
		(tmp2->arm == "91")
		
		sdc->(dbseek(_cfilsdc+tmp2->cod+tmp2->arm+tmp2->op+tmp2->trt+tmp2->lotectl))
		sg1->(dbseek(_cfilsg1+_cprod+tmp2->cod+tmp2->trt))

		if sg1->g1_evapora=="S"
			_evapora:=.t.  
			_txtevap:=.t.
		else
			_evapora:=.f.
		endif
		
		if !empty(tmp2->lotectl)
			
			while ! sdc->(eof()) .and.;
				_cfilsdc = sdc->dc_filial .and.;
				tmp2->cod = sdc->dc_produto .and.;
				tmp2->arm = sdc->dc_local .and.;
				tmp2->op = sdc->dc_op .and.;
				tmp2->trt = sdc->dc_trt .and.;
				tmp2->lotectl = sdc->dc_lotectl
				
				if _linha>=27
					_cMsg2 += '</table>'
					// quebra a pagina
					_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
					_cMsg2 += "<br clear=all style='page-break-before:always'>"
					_cMsg2 += '</span>'
					
					_linha:=1
					
					_cMsg2 +=cabecalho(_cop,_cprod,1)
					_cMsg2 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
					_cMsg2 += '<tr><td width="1054" colspan="12" height="25"><p align="center" class="style2"><strong>REQUISI&Ccedil;&Atilde;O DE MAT&Eacute;RIA-PRIMA</strong></p></td></tr>'
					_cMsg2 += '<tr>'
					_cMsg2 += '<td width="44" height="25"><p align="center" class="style6">C&oacute;digo </p></td>'
					_cMsg2 += '<td width="259" height="25"><p align="center" class="style6">Mat&eacute;ria-Prima </p></td>'
					_cMsg2 += '<td width="45" height="25"><p align="center" class="style6">DCB </p></td>'
					_cMsg2 += '<td width="76" height="25"><p align="center" class="style6">Endere&ccedil;o </p></td>'
					_cMsg2 += '<td width="90" height="25"><p align="center" class="style6">Peso</p></td>'
					_cMsg2 += '<td width="96" height="25"><p align="center" class="style6">Pot&ecirc;ncia</p></td>'
					_cMsg2 += '<td width="30" height="25"><p align="center" class="style6">UM </p></td>'
					_cMsg2 += '<td width="76" height="25"><p align="center" class="style6">Lote </p></td>'
					_cMsg2 += '<td width="104" height="25"><p align="center" class="style6">Peso Balan&ccedil;a </p></td>'
					_cMsg2 += '<td width="81" height="25"><p align="center" class="style6">Pesador </p></td>'
					_cMsg2 += '<td width="81" height="25"><p align="center" class="style6">Conferente </p></td>'
					_cMsg2 += '<td width="72" height="25"><p align="center" class="style6">Data </p></td>'
					_cMsg2 += '</tr>'
				endif
				
				_cMsg2 += '<tr>'
				_cMsg2 += '<td width="44" height="20"><p class="style3">&nbsp;'+left(tmp2->cod,6)+'</p></td>'

				if _evapora
					_cMsg2 += '<td width="259" height="20"><p class="style3">&nbsp;'+tmp2->descri+'*</p></td>'
				else
					_cMsg2 += '<td width="259" height="20"><p class="style3">&nbsp;'+tmp2->descri+'</p></td>'
				endif
				
				
				if !empty(tmp2->dcb1)
					_cMsg2 += '<td width="45" height="20"><p align="center" class="style3">'+tmp2->dcb1+'</p></td>'
				else
					_cMsg2 += '<td width="45" height="20"><p align="center" class="style3">&nbsp;</p></td>'
				endif
				
				_cMsg2 += '<td width="76" height="20"><p align="center" class="style3">'+substr(sdc->dc_localiz,1,11)+'</p></td>'
				_cMsg2 += '<td width="90" height="20"><p align="right" class="style3">'+transform((sdc->dc_qtdorig),'@E 99,999,999.99')+'</p></td>'
//				_cMsg2 += '<td width="90" height="20"><p align="right" class="style3">'+transform((sdc->dc_qtdorig),'@E 99,999,999.99999')+'</p></td>'

				if tmp2->potencia>0
					_cMsg2 += '<td width="96" height="20"><p align="center" class="style3">'+transform(tmp2->potencia,'@E 999.99')+'%</p></td>'
				else
					_cMsg2 += '<td width="96" height="20"><p align="center" class="style3">-</p></td>'
				endif
	
				_cMsg2 += '<td width="30" height="20"><p align="center" class="style3">'+tmp2->um+'</p></td>'
				_cMsg2 += '<td width="76" height="20"><p class="style3">&nbsp;'+tmp2->lotectl+'</p></td>'
				_cMsg2 += '<td width="104" height="20"><p>&nbsp;</p></td>
				_cMsg2 += '<td width="81" height="20"><p>&nbsp;</p></td>
				_cMsg2 += '<td width="81" height="20"><p>&nbsp;</p></td>
				_cMsg2 += '<td width="72" height="20"><p>&nbsp;</p></td>
				_cMsg2 += '</tr>
				
				// gera temporário para Pick-List MP
				if !tmp4->(dbseek(tmp2->op+tmp2->cod+tmp2->lotectl+sdc->dc_localiz))
					tmp4->(dbappend())
					tmp4->op	  := tmp2->op
					tmp4->cod	  := tmp2->cod
					tmp4->descri  := tmp2->descri
					tmp4->arm	  := tmp2->arm
					tmp4->qtdeori := sdc->dc_qtdorig
					tmp4->um	  := tmp2->um
					tmp4->lotectl := tmp2->lotectl
					tmp4->localiz := sdc->dc_localiz
				else
					tmp4->qtdeori += sdc->dc_qtdorig
				endif
				
				_linha++
				sdc->(dbskip())
			end
			
		else    // sem lote
			
			if _linha>=27
				_cMsg2 += '</table>'
				
				// quebra a pagina
				_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
				_cMsg2 += "<br clear=all style='page-break-before:always'>"
				_cMsg2 += '</span>'
				
				_linha:=1
				
				_cMsg2 +=cabecalho(_cop,_cprod,1)
				_cMsg2 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
				_cMsg2 += '<tr><td width="1054" colspan="12" height="25"><p align="center" class="style2"><strong>REQUISI&Ccedil;&Atilde;O DE MAT&Eacute;RIA-PRIMA</strong></p></td></tr>'
				_cMsg2 += '<tr>'
				_cMsg2 += '<td width="44" height="25"><p align="center" class="style6">C&oacute;digo </p></td>'
				_cMsg2 += '<td width="259" height="25"><p align="center" class="style6">Mat&eacute;ria-Prima </p></td>'
				_cMsg2 += '<td width="45" height="25"><p align="center" class="style6">DCB </p></td>'
				_cMsg2 += '<td width="76" height="25"><p align="center" class="style6">Endere&ccedil;o </p></td>'
				_cMsg2 += '<td width="90" height="25"><p align="center" class="style6">Peso</p></td>'
				_cMsg2 += '<td width="96" height="25"><p align="center" class="style6">Pot&ecirc;ncia</p></td>'
				_cMsg2 += '<td width="30" height="25"><p align="center" class="style6">UM </p></td>'
				_cMsg2 += '<td width="76" height="25"><p align="center" class="style6">Lote </p></td>'
				_cMsg2 += '<td width="104" height="25"><p align="center" class="style6">Peso Balan&ccedil;a </p></td>'
				_cMsg2 += '<td width="81" height="25"><p align="center" class="style6">Pesador </p></td>'
				_cMsg2 += '<td width="81" height="25"><p align="center" class="style6">Conferente </p></td>'
				_cMsg2 += '<td width="72" height="25"><p align="center" class="style6">Data </p></td>'
				_cMsg2 += '</tr>'
			endif
			
			_cMsg2 += '<tr>'
			_cMsg2 += '<td width="44" height="20"><p class="style3">&nbsp;'+left(tmp2->cod,6)+'</p></td>'

			if _evapora
				_cMsg2 += '<td width="259" height="20"><p class="style3">&nbsp;'+tmp2->descri+'*</p></td>'
			else
				_cMsg2 += '<td width="259" height="20"><p class="style3">&nbsp;'+tmp2->descri+'</p></td>'
			endif
			
			if !empty(tmp2->dcb1)
				_cMsg2 += '<td width="45" height="20"><p align="center" class="style3">'+tmp2->dcb1+'</p></td>'
			else
				_cMsg2 += '<td width="45" height="20"><p align="center" class="style3">&nbsp;</p></td>'
			endif
			
			_cMsg2 += '<td width="76" height="20"><p align="center" class="style3">&nbsp;</p></td>'
			_cMsg2 += '<td width="90" height="20"><p align="right" class="style3">'+transform((tmp2->qtdeori),'@E 99,999,999.99')+'</p></td>'
//			_cMsg2 += '<td width="90" height="20"><p align="right" class="style3">'+transform((tmp2->qtdeori),'@E 99,999,999.999999')+'</p></td>'
			
			if tmp2->potencia>0
				_cMsg2 += '<td width="96" height="20"><p align="center" class="style3">'+transform(tmp2->potencia,'@E 999.99')+'%</p></td>'
			else
				_cMsg2 += '<td width="96" height="20"><p align="center" class="style3">-</p></td>'
			endif
			
			_cMsg2 += '<td width="30" height="20"><p align="center" class="style3">'+tmp2->um+'</p></td>'
			_cMsg2 += '<td width="76" height="20"><p class="style3">&nbsp;'+tmp2->lotectl+'</p></td>'
			_cMsg2 += '<td width="104" height="20"><p>&nbsp;</p></td>
			_cMsg2 += '<td width="81" height="20"><p>&nbsp;</p></td>
			_cMsg2 += '<td width="81" height="20"><p>&nbsp;</p></td>
			_cMsg2 += '<td width="72" height="20"><p>&nbsp;</p></td>
			_cMsg2 += '</tr>
			_linha++
		endif
	endif
	
	tmp2->(dbskip())
end
if _txtevap
	_cMsg2 += '<tr>'  
	_cMsg2 += '<td width="1054" colspan=12 height="20"><p align="left" class="style3">* Subst&acirc;ncia desaparece no decorrer do processo.</p></td>'
	_cMsg2 += '</tr>'
endif

//if _linha >15
if _linha >23
	
	_cMsg2 += '</table>'
	
	// quebra a pagina
	_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
	_cMsg2 += "<br clear=all style='page-break-before:always'>"
	_cMsg2 += '</span>'
	
	_linha:=1
	
	_cMsg2 +=cabecalho(_cop,_cprod,1)
else
	_cMsg2 += '</table><br />'
endif

_cMsg2 += rodape(_cop,_cprod)


/* FICHA DE CONTROLE DOS LACRES
// Código removido em 10/06/2010 a pedido da Garantia da Qualidade - Alex

sb1->(dbseek(_cfilsb1+_cprod))

if !sb1->b1_tipo$"MP"

	_cMsg2 +=cabecalho(_cop,_cprod,1)
	_cMsg2 += '<table width="1055" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
	_cMsg2 += '<tr><td width="1055" colspan="4">'
	_cMsg2 += '<p class="style4" align="center"><b>RECIPIENTES DE ACONDICIONAMENTO DE INSUMOS E SEUS RESPECTIVOS N&Uacute;MEROS DOS LACRES</b></p></td></tr>'
	_cMsg2 += '<tr><td width="131" bgcolor="#E5E5E5"><p class="style3" align="center"><b>N&uacute;mero(s) de <br />Recipiente(s)<br />'
	_cMsg2 += '(ex.: 1/3, 2/3, 3/3, etc.)</b></p></td>'
	_cMsg2 += '<td width="421" bgcolor="#E5E5E5"><p class="style3" align="center"><b>N&uacute;mero(s) do(s) lacre(s) do(s)<br /> Recipiente(s)</b></p></td>'
	_cMsg2 += '<td width="255" bgcolor="#E5E5E5"><p class="style3" align="center"><b>Visto/Respons&aacute;vel<br /> pela entrega do material lacrado<br />'
	_cMsg2 += '(Central de Pesagem)</b></p></td>'
	_cMsg2 += '<td width="248" bgcolor="#E5E5E5"><p class="style3" align="center"><b>Visto/ Respons&aacute;vel<br />'
	_cMsg2 += 'pelo Recebimento e confer&ecirc;ncia do material e n&uacute;meros de lacres <br />(Produ&ccedil;&atilde;o)</b></p></td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr height="25">'
	_cMsg2 += '<td width="131" valign="bottom"> <p class="style3" align="center">/</p> </td>'
	_cMsg2 += '<td width="421">&nbsp;</td>'
	_cMsg2 += '<td width="255">&nbsp;</td>'
	_cMsg2 += '<td width="248">&nbsp;</td></tr>'
	_cMsg2 += '<tr><td colspan="4" height="60">'
	_cMsg2 += '<p class="style4"><strong>NOTA 02: </strong>'
	_cMsg2 += 'Caso seja verificada no recebimento do material pesado qualquer diverg&ecirc;ncia no(s)'
	_cMsg2 += 'n&uacute;mero(s) de lacre(s), o colaborador da Produ&ccedil;&atilde;o deve chamar imediatamente'
	_cMsg2 += 'seu Respons&aacute;vel para verifica&ccedil;&atilde;o do fato e tomada das devidas provid&ecirc;ncias,'
	_cMsg2 += 'que por sua vez devem ser relatadas no campo abaixo. Seguidamente, comunique'
	_cMsg2 += '&agrave; Garantia de Qualidade para avalia&ccedil;&atilde;o e ci&ecirc;ncia do fato ocorrido. Somente'
	_cMsg2 += 'ap&oacute;s a verifica&ccedil;&atilde;o do fato o processo poder&aacute; ser prosseguido.</p></td></tr>'
	_cMsg2 += '<tr><td colspan="4" valign="top" height="35"><p class="style3">Coment&aacute;rios/Observa&ccedil;&otilde;es</p></td></tr>'
	_cMsg2 += '<tr><td colspan="4" valign="top" height="35">&nbsp;</td></tr>'
	_cMsg2 += '<tr><td colspan="4" valign="top" height="35">&nbsp;</td></tr>'
	_cMsg2 += '</table>'
endif	
*/

return(_cMsg2)



//*****************************************//
// PICK-LIST MATÉRIA-PRIMA                 //
//*****************************************//
Static function pickmp(_cop,_cprod)

sb1->(dbseek(_cfilsb1+_cprod))
sc2->(dbseek(_cfilsc2+_cop))
sah->(dbseek(_cfilsah+sb1->b1_segum))

_cMsg2:=''

// quebra a pagina

//_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
//_cMsg2 += "<br clear=all style='page-break-before:always'>"
//_cMsg2 += '</span>'

_cMsg2 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr><td>'
_cMsg2 += '<table width="1054" border="0" cellpadding="0" cellspacing="0"><tr>'
_cMsg2 += '<td width="754" class="style2"><br />Produto: <strong>'+sb1->b1_cod+' &ndash; '+sb1->b1_desc+'</strong></td>'
//_cMsg2 += '<td width="300" class="style2"><br />Lote: <strong>'+sc2->c2_num+'</strong></td></tr><tr>'

/*Inicio Leandro 08/12/2016*/
If sb1->b1_tipo == "PN"
_cMsg2 += '<td width="300" class="style2"><br />Lote: <strong>'+sc2->c2_lotectl+'</strong></td></tr><tr>'
Else 
_cMsg2 += '<td width="300" class="style2"><br />Lote: <strong>'+sc2->c2_num+'</strong></td></tr><tr>'
EndIf
/*Fim */

_cMsg2 += '<td width="754" class="style2">Apresenta&ccedil;&atilde;o: '+sb1->b1_apres+'<br /></td>'
_cMsg2 += '<td width="300" class="style2">Qtde. Te&oacute;rica: <strong>'+Transform((sc2->c2_quant),'@E 9,999,999')+' '+sc2->c2_um+'</strong><br /></td>'
_cMsg2 += '</tr></table></td></tr></table><br />'

_cMsg2 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr>'
_cMsg2 += '<td width="1054" colspan="5"  height="25"><p align="center" class="style2"><strong>PICK-LIST DE MAT&Eacute;RIAS-PRIMAS</strong></p></td></tr>'

_cMsg2 += '<tr><td width="70" height="25"><p align="center" class="style6">C&oacute;digo</p></td>'
_cMsg2 += '<td width="440" height="25"><p align="center" class="style6">Mat&eacute;ria-Prima </p></td>'
_cMsg2 += '<td width="120" height="25"><p align="center" class="style6">Endere&ccedil;o </p></td>'
_cMsg2 += '<td width="120" height="25"><p align="center" class="style6">Lote </p></td>'
_cMsg2 += '<td width="120" height="25"><p align="center" class="style6">Quantidade </p></td></tr>'

tmp4->(dbsetorder(2))
tmp4->(dbgotop())

while ! tmp4->(eof())
	_cMsg2 += '<tr><td width="70" height="25"><p class="style3">&nbsp;'+tmp4->cod+'</p></td>'
	_cMsg2 += '<td width="440" height="25"><p class="style3">&nbsp;'+tmp4->descri+'</p></td>'
	_cMsg2 += '<td width="120" height="25"><p align="center" class="style3">'+substr(tmp4->localiz,1,11)+'</p></td>'
	_cMsg2 += '<td width="120" height="25"><p align="center" class="style3">'+tmp4->lotectl+'</p></td>'
	_cMsg2 += '<td width="120" height="25"><p align="right" class="style3">'+Transform((tmp4->qtdeori),'@E 99,999,999.99')+' '+tmp4->um+'</p></td></tr>'
//	_cMsg2 += '<td width="120" height="25"><p align="right" class="style3">'+Transform((tmp4->qtdeori),'@E 99,999,999.999999')+' '+tmp4->um+'</p></td></tr>'
	
	tmp4->(dbskip())
end

_cMsg2 += '</table>'
_cMsg2 += '<br /><br />'
_cMsg2 += '<table width="750" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr>'
_cMsg2 += '<td width="750" height="25"><p class="style2"><br />&nbsp;Respons&aacute;vel pelo Endere&ccedil;amento: ____________________________________________<br /><br />'
_cMsg2 += '&nbsp;Data: _____/_____/_____<br/><br /></p></td></tr></table>'

// quebra a pagina
_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
_cMsg2 += "<br clear=all style='page-break-before:always'>"
_cMsg2 += '</span>'

return(_cMsg2)



//********************************************
// Requisição de Material de Embalagem
//********************************************
Static function requis_me(_cop,_cprod)

sb1->(dbseek(_cfilsb1+_cprod))
sc2->(dbseek(_cfilsc2+_cop))
sah->(dbseek(_cfilsah+sb1->b1_segum))

_cMsg2:=''

tmp2->(dbgotop())

_cMsg2 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
_cMsg2 += '<tr><td colspan="10" height="25"><p align="center" class="style2"><strong>REQUISI&Ccedil;&Atilde;O DE MATERIAL DE EMBALAGEM</strong></p></td></tr>'
_cMsg2 += '<tr class="style2">'
_cMsg2 += '<td width="63" height="25"><p align="center" class="style6">C&oacute;digo</p></td>'
_cMsg2 += '<td width="319" height="25"><p align="center" class="style6">Material</p></td>'
_cMsg2 += '<td width="88" height="25"><p align="center" class="style6">Endere&ccedil;o</p></td>'
_cMsg2 += '<td width="119" height="25"><p align="center" class="style6">Requerido</p></td>'
_cMsg2 += '<td width="35" height="25"><p align="center" class="style6">UM</p></td>'
_cMsg2 += '<td width="88" height="25"><p align="center" class="style6">Lote</p></td>'
_cMsg2 += '<td width="99" height="25"><p align="center" class="style6">Qtde.<br />Separada</p></td>'
_cMsg2 += '<td width="80" height="25"><p align="center" class="style6">Separador</p></td>'
_cMsg2 += '<td width="91" height="25"><p align="center" class="style6">Conferente</p></td>'
_cMsg2 += '<td width="72" height="25"><p align="center" class="style6">Data</p></td></tr>'
_linha:=1

while ! tmp2->(eof())
	
	if  (tmp2->arm <> "02") .and.;
		(tmp2->arm <> "01") .and.;
		(tmp2->arm <> "91") .and.;
		(tmp2->arm <> "80")
		
		
		sdc->(dbseek(_cfilsdc+tmp2->cod+tmp2->arm+tmp2->op+tmp2->trt+tmp2->lotectl))
		
		if !empty(tmp2->lotectl)
			
			while ! sdc->(eof()) .and.;
				_cfilsdc = sdc->dc_filial .and.;
				tmp2->cod = sdc->dc_produto .and.;
				tmp2->arm = sdc->dc_local .and.;
				tmp2->op = sdc->dc_op .and.;
				tmp2->trt = sdc->dc_trt .and.;
				tmp2->lotectl = sdc->dc_lotectl
				
				if _linha>=27
					// quebra a pagina
					_cMsg2 += "</table>"
					_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
					_cMsg2 += "<br clear=all style='page-break-before:always'>"
					_cMsg2 += '</span>'
					
					_linha:=1
					_cMsg2 +=cabecalho(_cop,_cprod,2)
					
					_cMsg2 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
					_cMsg2 += '<tr><td colspan="10" height="25"><p align="center" class="style2"><strong>REQUISI&Ccedil;&Atilde;O DE MATERIAL DE EMBALAGEM</strong></p></td></tr>'
					_cMsg2 += '<tr class="style2">'
					_cMsg2 += '<td width="63" height="25"><p align="center" class="style6">C&oacute;digo</p></td>'
					_cMsg2 += '<td width="319" height="25"><p align="center" class="style6">Material</p></td>'
					_cMsg2 += '<td width="88" height="25"><p align="center" class="style6">Endere&ccedil;o</p></td>'
					_cMsg2 += '<td width="119" height="25"><p align="center" class="style6">Requerido</p></td>'
					_cMsg2 += '<td width="35" height="25"><p align="center" class="style6">UM</p></td>'
					_cMsg2 += '<td width="88" height="25"><p align="center" class="style6">Lote</p></td>'
					_cMsg2 += '<td width="99" height="25"><p align="center" class="style6">Qtde.<br />Separada</p></td>'
					_cMsg2 += '<td width="80" height="25"><p align="center" class="style6">Separador</p></td>'
					_cMsg2 += '<td width="91" height="25"><p align="center" class="style6">Conferente</p></td>'
					_cMsg2 += '<td width="72" height="25"><p align="center" class="style6">Data</p></td></tr>'
					_linha:=1
				endif
				
				_cMsg2 += '<tr><td width="63" height="20"><p class="style3">&nbsp;'+left(tmp2->cod,6)+'</p></td>'
				_cMsg2 += '<td width="319" height="20"><p class="style3">&nbsp;'+tmp2->descri+'</p></td>'
				_cMsg2 += '<td width="88" height="20"><p align="center" class="style3">'+substr(sdc->dc_localiz,1,8)+'</p></td>'
				_cMsg2 += '<td width="119" height="20"><p align="right" class="style3">'+transform((sdc->dc_qtdorig),"@E 999,999,999.99")+'</p></td>'
//				_cMsg2 += '<td width="119" height="20"><p align="right" class="style3">'+transform((sdc->dc_qtdorig),"@E 999,999,999.999999")+'</p></td>'
				_cMsg2 += '<td width="35" height="20"><p align="center" class="style3">'+tmp2->um+'</p></td>'
				_cMsg2 += '<td width="88" height="20"><p class="style3">&nbsp;'+tmp2->lotectl+'</p></td>'
				_cMsg2 += '<td width="99" height="20">&nbsp;</td>'
				_cMsg2 += '<td width="80" height="20">&nbsp;</td>'
				_cMsg2 += '<td width="91" height="20">&nbsp;</td>'
				_cMsg2 += '<td width="72" height="20">&nbsp;</td></tr>'
				
				_linha++
				sdc->(dbskip())
			end
		else // sem lote
			if _linha>=27
				// quebra a pagina
				_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
				_cMsg2 += "<br clear=all style='page-break-before:always'>"
				_cMsg2 += '</span>'
				
				_linha:=1
				_cMsg2 +=cabecalho(_cop,_cprod,2)
			endif
			
			_cMsg2 += '<tr><td width="63" height="20"><p class="style3">&nbsp;'+left(tmp2->cod,6)+'</p></td>'
			_cMsg2 += '<td width="319" height="20"><p class="style3">&nbsp;'+tmp2->descri+'</p></td>'
			_cMsg2 += '<td width="88" height="20"><p align="center" class="style3">&nbsp;</p></td>'
			_cMsg2 += '<td width="119" height="20"><p align="right" class="style3">'+transform((tmp2->qtdeori),"@E 999,999,999.99")+'</p></td>'
//			_cMsg2 += '<td width="119" height="20"><p align="right" class="style3">'+transform((tmp2->qtdeori),"@E 999,999,999.999999")+'</p></td>'
			_cMsg2 += '<td width="35" height="20"><p align="center" class="style3">'+tmp2->um+'</p></td>'
			_cMsg2 += '<td width="88" height="20"><p class="style3">&nbsp;'+tmp2->lotectl+'</p></td>'
			_cMsg2 += '<td width="99" height="20">&nbsp;</td>'
			_cMsg2 += '<td width="80" height="20">&nbsp;</td>'
			_cMsg2 += '<td width="91" height="20">&nbsp;</td>'
			_cMsg2 += '<td width="72" height="20">&nbsp;</td></tr>'
		endif
	endif
	tmp2->(dbskip())
end

_cMsg2 += '</table>'

sb1->(dbseek(_cfilsb1+_cprod))

if sb1->b1_tipo$"EE/EN"
	_cMsg2 += '<br />'
	_cMsg2 += rodape(_cop,_cprod)
else
	// quebra a pagina
	_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
	_cMsg2 += "<br clear=all style='page-break-before:always'>"
	_cMsg2 += '</span>'
endif

return(_cMsg2)




//********************************************
// Requisição Adicional de Embalagem
//********************************************

Static function req_ad_me(_cop,_cprod)

sb1->(dbseek(_cfilsb1+_cprod))
sc2->(dbseek(_cfilsc2+_cop))
sah->(dbseek(_cfilsah+sb1->b1_segum))

_cMsg2:=''

_cMsg2 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
_cMsg2 += '<tr><td colspan="11" height="25"><p align="center" class="style2"><strong>REQUISI&Ccedil;&Atilde;O DE MATERIAIS ADICIONAIS</strong></p></td>'
_cMsg2 += '</tr><tr class="style2">'
_cMsg2 += '<td width="55" height="25"><p align="center" class="style6">C&otilde;digo</p></td>'
_cMsg2 += '<td width="300" height="25"><p align="center" class="style6">Material</p></td>'
_cMsg2 += '<td width="70" height="25"><p align="center" class="style6">Endere&ccedil;o</p></td>'
_cMsg2 += '<td width="90" height="25"><p align="center" class="style6">Qtde. <br />Requerida</p></td>'
_cMsg2 += '<td width="84" height="25"><p align="center" class="style6">Requerido <br />por</p></td>'
_cMsg2 += '<td width="35" height="25"><p align="center" class="style6">UM</p></td>'
_cMsg2 += '<td width="80" height="25"><p align="center" class="style6">Lote</p></td>'
_cMsg2 += '<td width="90" height="25"><p align="center" class="style6">Qtde.<br />Separada</p></td>'
_cMsg2 += '<td width="75" height="25"><p align="center" class="style6">Separador</p></td>'
_cMsg2 += '<td width="75" height="25"><p align="center" class="style6">Conferente</p></td>'
_cMsg2 += '<td width="76" height="25"><p align="center" class="style6">Data</p></td></tr>'

_linha:=1

tmp3->(dbgotop())

while ! tmp3->(eof())
	_cMsg2 += '<tr><td width="55" height="20"><p class="style3">&nbsp;'+tmp3->cod+'</p></td>'
	_cMsg2 += '<td width="300" height="20"><p class="style3">&nbsp;'+tmp3->descri+'</p></td>'
	_cMsg2 += '<td width="70" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="90" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="84" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="35" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="80" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="90" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="75" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="75" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="76" height="20">&nbsp;</td></tr>'
	_linha++
	
	tmp3->(dbskip())
end

//_final:= (_linha-1)*2
_final:= _linha+int((_linha-1)/2)

for _i:=_linha to _final
	_cMsg2 += '<tr><td width="55" height="20"><p class="style3">&nbsp;</p></td>'
	_cMsg2 += '<td width="300" height="20"><p class="style3">&nbsp;</p></td>'
	_cMsg2 += '<td width="70" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="90" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="84" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="35" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="80" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="90" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="75" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="75" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="76" height="20">&nbsp;</td></tr>'
next

_cMsg2 += '</table>'

// Código abaixo foi retirado por solicitação da GQL - Chamado Ocomon nº 1569
// quebra a pagina
/*
_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
_cMsg2 += "<br clear=all style='page-break-before:always'>"
_cMsg2 += '</span>'
*/
_cMsg2 += '<br /><br />'  

return(_cMsg2)



//********************************************
// Devolução de Materiais
//********************************************
Static function devol_me(_cop,_cprod)

sb1->(dbseek(_cfilsb1+_cprod))
sc2->(dbseek(_cfilsc2+_cop))
sah->(dbseek(_cfilsah+sb1->b1_segum))

_cMsg2:=''

_cMsg2 += '<table width="1054" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse">'
_cMsg2 += '<tr><td colspan="11" height="25"><p align="center" class="style2"><strong>DEVOLU&Ccedil;&Atilde;O DE MATERIAIS</strong></p></td>'
_cMsg2 += '</tr><tr class="style2">'
_cMsg2 += '<td width="63" height="25"><p align="center" class="style6">C&oacute;digo</p></td>'
_cMsg2 += '<td width="319" height="25"><p align="center" class="style6">Material</p></td>'
_cMsg2 += '<td width="119" height="25"><p align="center" class="style6">Quantidade <br />Devolvida</p></td>'
_cMsg2 += '<td width="35" height="25"><p align="center" class="style6">UM</p></td>'
_cMsg2 += '<td width="88" height="25"><p align="center" class="style6">Lote</p></td>'
_cMsg2 += '<td width="139" height="25"><p align="center" class="style6">Devolvido por:</p></td>'
_cMsg2 += '<td width="131" height="25"><p align="center" class="style6">Recebido por:</p></td>'
_cMsg2 += '<td width="88" height="25"><p align="center" class="style6">Endere&ccedil;o</p></td>'
_cMsg2 += '<td width="72" height="25"><p align="center" class="style6">Data</p></td></tr>'

_linha:=1

tmp3->(dbgotop())

while ! tmp3->(eof())
	
	_cMsg2 += '<tr><td width="63" height="20"><p class="style3">&nbsp;'+tmp3->cod+'</p></td>'
	_cMsg2 += '<td width="319" height="20"><p class="style3">&nbsp;'+tmp3->descri+'</p></td>'
	_cMsg2 += '<td width="119" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="35" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="88" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="139" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="131" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="88" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="72" height="20">&nbsp;</td></tr>'
	_linha++
	
	tmp3->(dbskip())
end

//_final:= (_linha-1)*2
_final:= _linha+int((_linha-1)/2)

for _i:=_linha to _final
	_cMsg2 += '<tr><td width="63" height="20"><p class="style3">&nbsp;</p></td>'
	_cMsg2 += '<td width="319" height="20"><p class="style3">&nbsp;</p></td>'
	_cMsg2 += '<td width="119" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="35" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="88" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="139" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="131" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="88" height="20">&nbsp;</td>'
	_cMsg2 += '<td width="72" height="20">&nbsp;</td></tr>'
next

_cMsg2 += '</table>'

return(_cMsg2)



//*****************************************//
// PICK-LIST MATERIAL DE EMBALAGEM         //
//*****************************************//

Static function pickme(_cop,_cprod)

sb1->(dbseek(_cfilsb1+_cprod))
sc2->(dbseek(_cfilsc2+_cop))
sah->(dbseek(_cfilsah+sb1->b1_segum))

_cMsg2:=''

// quebra a pagina
_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
_cMsg2 += "<br clear=all style='page-break-before:always'>"
_cMsg2 += '</span>'

_linha:=1

tmp2->(dbgotop())

while ! tmp2->(eof())
	
	if  (tmp2->arm <> "02") .and.;
		(tmp2->arm <> "01") .and.;
		(tmp2->arm <> "91") .and.;
		(tmp2->arm <> "80")
		
		sdc->(dbseek(_cfilsdc+tmp2->cod+tmp2->arm+tmp2->op+tmp2->trt+tmp2->lotectl))
		
		if !empty(tmp2->lotectl)
			
			if _linha==1
				_cMsg2 += '<table width="950" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr><td>'
				_cMsg2 += '<table width="950" border="0" cellpadding="0" cellspacing="0"><tr>'
				_cMsg2 += '<td width="600" class="style2"><br />Produto: <strong>'+sb1->b1_cod+' &ndash; '+sb1->b1_desc+'</strong></td>'
				//_cMsg2 += '<td width="350" class="style2"><br />Lote: <strong>'+sc2->c2_num+'</strong></td></tr><tr>'
				
				/*Inicio Leandro 08/12/2016*/
				If sb1->b1_tipo == "PN"
				_cMsg2 += '<td width="350" class="style2"><br />Lote: <strong>'+sc2->c2_lotectl+'</strong></td></tr><tr>'
				Else 
				_cMsg2 += '<td width="350" class="style2"><br />Lote: <strong>'+sc2->c2_num+'</strong></td></tr><tr>'
				EndIf
				/*Fim */
				 
				_cMsg2 += '<td width="600" class="style2">Apresenta&ccedil;&atilde;o: '+sb1->b1_apres+'<br /></td>'
				_cMsg2 += '<td width="350" class="style2">Qtde. Te&oacute;rica: <strong>'+Transform((sc2->c2_quant),'@E 9,999,999')+' '+sc2->c2_um+'</strong><br /></td>'
				_cMsg2 += '</tr></table></td></tr></table><br />'
				
				_cMsg2 += '<table width="950" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000" style="border-collapse: collapse"><tr>'
				_cMsg2 += '<td width="950" colspan="6"  height="25"><p align="center" class="style2"><strong>PICK-LIST DE MATERIAIS DE EMBALAGEM</strong></p></td></tr>'
				_cMsg2 += '<tr><td width="70" height="25"><p align="center" class="style6">C&oacute;digo</p></td>'
				_cMsg2 += '<td width="440" height="25"><p align="center" class="style6">Mat&eacute;ria-Prima </p></td>'
				_cMsg2 += '<td width="120" height="25"><p align="center" class="style6">Lote </p></td>'
				_cMsg2 += '<td width="120" height="25"><p align="center" class="style6">Endere&ccedil;o </p></td>'
				_cMsg2 += '<td width="100" height="25"><p align="center" class="style6">Endere&ccedil;amento </p></td>'
				_cMsg2 += '<td width="100" height="25"><p align="center" class="style6">Data </p></td></tr>'
				
			endif
			
			_cMsg2 += '<tr><td width="70" height="25"><p class="style3">&nbsp;'+tmp2->cod+'</p></td>'
			_cMsg2 += '<td width="440" height="25"><p class="style3">&nbsp;'+tmp2->descri+'</p></td>'
			_cMsg2 += '<td width="120" height="25"><p align="center" class="style3">'+tmp2->lotectl+'</p></td>'
			_cMsg2 += '<td width="120" height="25"><p align="center" class="style3">'+substr(sdc->dc_localiz,1,11)+'</p></td>'
			_cMsg2 += '<td width="100" height="25">&nbsp;</td>'
			_cMsg2 += '<td width="100" height="25">&nbsp;</td></tr>'
			_linha++
			
			_localiz:=sdc->dc_localiz
			
			while ! sdc->(eof()) .and.;
				_cfilsdc = sdc->dc_filial .and.;
				tmp2->cod = sdc->dc_produto .and.;
				tmp2->arm = sdc->dc_local .and.;
				tmp2->op = sdc->dc_op .and.;
				tmp2->lotectl = sdc->dc_lotectl
				
				if _localiz <> sdc->dc_localiz
					_localiz:=sdc->dc_localiz
					_cMsg2 += '<tr><td width="70" height="25"><p class="style3">&nbsp;'+tmp2->cod+'</p></td>'
					_cMsg2 += '<td width="440" height="25"><p class="style3">&nbsp;'+tmp2->descri+'</p></td>'
					_cMsg2 += '<td width="120" height="25"><p align="center" class="style3">'+tmp2->lotectl+'</p></td>'
					_cMsg2 += '<td width="120" height="25"><p align="center" class="style3">'+substr(sdc->dc_localiz,1,11)+'</p></td>'
					_cMsg2 += '<td width="100" height="25">&nbsp;</td>'
					_cMsg2 += '<td width="100" height="25">&nbsp;</td></tr>'
					_linha++
					
				endif
				
				sdc->(dbskip())
			end
		endif
	endif
	
	if _linha > 20
		// quebra a pagina
		_cMsg2 += '</table>'
		_cMsg2 += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
		_cMsg2 += "<br clear=all style='page-break-before:always'>"
		_cMsg2 += '</span>'
		
		_linha:=1
	endif
	
	tmp2->(dbskip())
end
_cMsg2 += '</table>'

return(_cMsg2)




//******************************************
static function _query2(_cop)
//******************************************
_cquer2:=" SELECT"
_cquer2+=" D4_OP OP,"
_cquer2+=" D4_COD COD,"
_cquer2+=" B1_DESC DESCRI,"
_cquer2+=" D4_LOCAL ARM,"
_cquer2+=" D4_QTDEORI QTDEORI,"
_cquer2+=" B1_UM UM,"
_cquer2+=" D4_TRT TRT,"
_cquer2+=" D4_LOTECTL LOTECTL,"
_cquer2+=" D4_POTENCI POTENCIA,"
_cquer2+=" B1_DCB1 DCB1"
_cquer2+=" FROM "
_cquer2+=  retsqlname("SD4")+" SD4,"
_cquer2+=  retsqlname("SB1")+" SB1"
_cquer2+=" WHERE SD4.D_E_L_E_T_=' '"
_cquer2+=" AND SB1.D_E_L_E_T_=' '"
_cquer2+=" AND D4_OP='"+_cop+"'"
_cquer2+=" AND D4_COD=B1_COD"
_cquer2+=" ORDER BY D4_LOCAL, B1_DESC, D4_LOTECTL"

_cquer2:=changequery(_cquer2)

tcquery _cquer2 new alias "TMP2"
tcsetfield("TMP2","QTDEORI","N",15,2)
tcsetfield("TMP2","POTENCIA","N",8,2)

return


//******************************************
static function _query3(_cop)
//******************************************

_cquer3:=" SELECT"
_cquer3+=" DISTINCT(D4_COD) COD,"
_cquer3+=" B1_DESC DESCRI"
_cquer3+=" FROM "
_cquer3+=  retsqlname("SD4")+" SD4,"
_cquer3+=  retsqlname("SB1")+" SB1"
_cquer3+=" WHERE SD4.D_E_L_E_T_=' '"
_cquer3+=" AND SB1.D_E_L_E_T_=' '"
_cquer3+=" AND D4_OP='"+_cop+"'"
_cquer3+=" AND D4_COD=B1_COD"
_cquer3+=" AND D4_LOCAL='03'"
_cquer3+=" ORDER BY B1_DESC"

_cquer3:=changequery(_cquer3)

tcquery _cquer3 new alias "TMP3"

return


//***********************************************************************
Static Function ExecArq(_carquivo)
//***********************************************************************
LOCAL cDrive     := ""
LOCAL cDir       := ""
LOCAL cPathFile  := ""
LOCAL cCompl     := ""
LOCAL nRet       := 0

//³ Retira a ultima barra invertida ( se houver )
cPathFile := _carquivo

SplitPath(cPathFile, @cDrive, @cDir )
cDir := Alltrim(cDrive) + Alltrim(cDir)

//³ Faz a chamada do aplicativo associado                                  ³
nRet := ShellExecute( "Open", cPathFile,"",cDir, 1)

If nRet <= 32
	cCompl := ""
	If nRet == 31
		cCompl := " Nao existe aplicativo associado a este tipo de arquivo!"
	EndIf
	Aviso( "Atencao !", "Nao foi possivel abrir o objeto '" + AllTrim(cPathFile) + "'!" + cCompl, { "Ok" }, 2 )
EndIf

Return

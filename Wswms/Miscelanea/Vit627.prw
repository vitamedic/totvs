#include 'Protheus.ch'
#include 'TOPConn.ch'
#include 'Rwmake.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE 'FWMVCDEF.CH' 

/*/{Protheus.doc} Vit627
	compatibilizar campos numericos e tabelas
@author xxx
@since nda
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function Vit627() //U_Vit627()
	
	//dimensionamento de tela e componentes
	Local aSize 	 := MsAdvSize() // Retorna a área útil das janelas Protheus 
	Local aInfo 	 := {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
	Local aPObj 	 := MsObjSize(aInfo, {{ 100, 100, .T., .T.}, { 100, 000, .T., .F.}})
	Local lHasButton := .T.	

	Private oDlgSX3, oListTab, oGridCpo,oGroup1, oBtnCons1, oBtnCons2
	Private oCodigo, oLoja, oNome, oCert1, oDtCer1, oCert2, oDtCer2, oCert3, oDtCer3, oCert4, oDtCer4, oCert5, oDtCer5
	Private oCert6, oDtCer6, oCert7, oDtCer7, oCert8, oDtCer8, oCert9, oDtCer9, oCertA, oDtCerA, oCertB, oDtCerB

    Private oOk       := LoadBitmap( GetResources(), "LBOK")
	Private oNo       := LoadBitmap( GetResources(), "LBNO")	
	Private cCadastro := "Manutenção de Certificados Vencidos"
	Private nVendSel  := 1
	
	Private nInteiro := 16
	Private nDecimal := 5
	Private cMascara := "@E 9,999,999,999.99999                                "
	Private aItens   := {"Produto x Fornecedor","Fabricante"}

	Private cCodigo  := Space(TamSX3("A2_COD")[1])
	Private cLoja 	 := Space(TamSX3("A2_LOJA")[1])
	Private cNome 	 := Space(TamSX3("A2_NOME")[1]+20)

	Private cCert1 	 := Space(TamSX3("A5_XCERT1")[1])
	Private dDtCer1	 := CtoD("")
    
	Private cCert2 	 := Space(TamSX3("A5_XCERT2")[1])
	Private dDtCer2	 := CtoD("")

	Private cCert3 	 := Space(TamSX3("A5_XCERT3")[1])
	Private dDtCer3	 := CtoD("")

	Private cCert4 	 := Space(TamSX3("A5_XCERT4")[1])
	Private dDtCer4	 := CtoD("")

	Private cCert5 	 := Space(TamSX3("A5_XCERT5")[1])
	Private dDtCer5	 := CtoD("")

	Private cCert6 	 := Space(TamSX3("A5_XCERT6")[1])
	Private dDtCer6	 := CtoD("")

	Private cCert7 	 := Space(TamSX3("A5_XCERT7")[1])
	Private dDtCer7	 := CtoD("")

	Private cCert8 	 := Space(TamSX3("A5_XCERT8")[1])
	Private dDtCer8	 := CtoD("")

	Private cCert9 	 := Space(TamSX3("A5_XCERT9")[1])
	Private dDtCer9	 := CtoD("")

	Private cCertA 	 := Space(TamSX3("A5_XCERTA")[1])
	Private dDtCerA	 := CtoD("")

	Private cCertB 	 := Space(TamSX3("A5_XCERTB")[1])
	Private dDtCerB	 := CtoD("")

	Private oCombo
	Private cCombo   := "Produto x Fornecedor"
	
	DEFINE MSDIALOG oDlgSX3 TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] PIXEL 
	
	oCombo := TComboBox():New(aPObj[1,1]+3, aPObj[1,2]/*+010*/,{|u|if(PCount()>0,cCombo:=u,cCombo)}, aItens,100,20,oDlgSX3,, {|| CarregaGrid(cCombo) },,,,.T.,,,,,,,,,'cCombo')                                                                  
 	
	TSay():New( aPObj[1,1]+3,aPObj[1,2]+180,{|| "Código" }, oDlgSX3,,,,,,.T.,CLR_BLACK,,100,9 )
	oCodigo := TGet():New( aPObj[1,1],aPObj[1,2]+200,{ | u | If( PCount() == 0, cCodigo, cCodigo := u ) },oDlgSX3,40,12,, {|| VldEntidade() },,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,{|| VldEntidade() }/*bChange*/,.F.,.F.,,"cCodigo",,,,.T.,.F.)
	oCodigo:cF3 := "SA2X"
	
  	//oBtnCons1 := TBTNPDV():New(aPObj[1,1]+3, aPObj[1,2]+200+042, 010, 010, oDlgSX3, "CONSULTA1.PNG", {|| ConsEntidade() }, "Consulta cadastro...")
	
	TSay():New( aPObj[1,1]+3,aPObj[1,2]+260,{|| "Loja" }, oDlgSX3,,,,,,.T.,CLR_BLACK,,100,9 )
	oLoja := TGet():New( aPObj[1,1],aPObj[1,2]+270,{ | u | If( PCount() == 0, cLoja, cLoja := u ) },oDlgSX3,15,12,,{|| VldEntidade() }/*bValid*/,,,,.F.,,.T.,,.F., {|| cCombo = "Produto x Fornecedor"},.F.,.F.,/*bChange*/,.F.,.F.,,"cLoja",,,,.T.,.F.)
	
	TSay():New( aPObj[1,1]+3,aPObj[1,2]+310,{|| "Nome" }, oDlgSX3,,,,,,.T.,CLR_BLACK,,100,9 )
	oNome := TGet():New( aPObj[1,1],aPObj[1,2]+325,{|| cNome },oDlgSX3,200,12,,{|| VldMask() }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F.,/*bChange*/,.F.,.F.,,"cNome",,,,.T.,.F.)
	
	_Lin := aPObj[1,1]+17
	oGroup1 := TGroup():New( _Lin+3, aPObj[1,2], aPObj[1,1]+77, aPObj[1,4], '', oDlgSX3, /*CLR_BLACK*/, , , )
	TSay():New( _Lin,aPObj[1,2],{|| "Certificados" }, oDlgSX3,,,,,,.T.,,,aPObj[1,4]-110,15 )
	TSay():New( _Lin,aPObj[1,2],{|| Replicate("_",aPObj[1,4]) }, oDlgSX3,,,,,,.T.,,,aPObj[1,4],15 )
	
	_Lin += 5
	TSay():New( _Lin+3,aPObj[1,2],{|| "1o. Certificado" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oCert1 := TGet():New( _Lin+10,aPObj[1,2],{ | u | If( PCount() == 0, cCert1, cCert1 := u ) },oGroup1,150,12,, {|| .t. }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,/*bChange*/,.F.,.F.,,"cCert1",,,,.T.,.F.)
	
	TSay():New( _Lin+3,aPObj[1,2]+150,{|| "1a. Validade" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oDtCer1 := TGet():New( _Lin+10, aPObj[1,2]+150, { |u| If( PCount() == 0, dDtCer1, dDtCer1 := u ) }, oGroup1, 060, 012, "@D", {|| VldData() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtCer1",,,,lHasButton  )
	
	TSay():New( _Lin+3,aPObj[1,2]+220,{|| "2o. Certificado" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oCert2 := TGet():New( _Lin+10,aPObj[1,2]+220,{ | u | If( PCount() == 0, cCert2, cCert2 := u ) },oGroup1,150,12,, {|| .T. }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,/*bChange*/,.F.,.F.,,"cCert2",,,,.T.,.F.)
	
	TSay():New( _Lin+3,aPObj[1,2]+370,{|| "2a. Validade" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oDtCer2 := TGet():New( _Lin+10, aPObj[1,2]+370, { |u| If( PCount() == 0, dDtCer2, dDtCer2 := u ) }, oGroup1, 060, 012, "@D", {|| VldData() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtCer2",,,,lHasButton  )
	
	TSay():New( _Lin+3,aPObj[1,2]+440,{|| "3o. Certificado" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oCert3 := TGet():New( _Lin+10,aPObj[1,2]+440,{ | u | If( PCount() == 0, cCert3, cCert3 := u ) },oGroup1,150,12,, {||  .T. }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,/*bChange*/,.F.,.F.,,"cCert3",,,,.T.,.F.)
	
	TSay():New( _Lin+3,aPObj[1,2]+590,{|| "3a. Validade" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oDtCer3 := TGet():New( _Lin+10, aPObj[1,2]+590, { |u| If( PCount() == 0, dDtCer3, dDtCer3 := u ) }, oGroup1, 060, 012, "@D", {|| VldData() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtCer3",,,,lHasButton  )
	
	_Lin += 23
	TSay():New( _Lin+3,aPObj[1,2],{|| "4o. Certificado" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oCert4 := TGet():New( _Lin+10,aPObj[1,2],{ | u | If( PCount() == 0, cCert4, cCert4 := u ) },oGroup1,150,12,, {|| .T. }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,/*bChange*/,.F.,.F.,,"cCert4",,,,.T.,.F.)
	
	TSay():New( _Lin+3,aPObj[1,2]+150,{|| "4a. Validade" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oDtCer4 := TGet():New( _Lin+10, aPObj[1,2]+150, { |u| If( PCount() == 0, dDtCer4, dDtCer4 := u ) }, oGroup1, 060, 012, "@D", {|| VldData() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtCer4",,,,lHasButton  )
	
	TSay():New( _Lin+3,aPObj[1,2]+220,{|| "5o. Certificado" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oCert5 := TGet():New( _Lin+10,aPObj[1,2]+220,{ | u | If( PCount() == 0, cCert5, cCert5 := u ) },oGroup1,150,12,, {||  .T. }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,/*bChange*/,.F.,.F.,,"cCert5",,,,.T.,.F.)
	
	TSay():New( _Lin+3,aPObj[1,2]+370,{|| "5a. Validade" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oDtCer5 := TGet():New( _Lin+10, aPObj[1,2]+370, { |u| If( PCount() == 0, dDtCer5, dDtCer5 := u ) }, oGroup1, 060, 012, "@D", {|| VldData() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtCer5",,,,lHasButton  )
	
	TSay():New( _Lin+3,aPObj[1,2]+440,{|| "6o. Certificado" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oCert6 := TGet():New( _Lin+10,aPObj[1,2]+440,{ | u | If( PCount() == 0, cCert6, cCert6 := u ) },oGroup1,150,12,, {||  .T. }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,/*bChange*/,.F.,.F.,,"cCert6",,,,.T.,.F.)
 	
	TSay():New( _Lin+3,aPObj[1,2]+590,{|| "6a. Validade" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oDtCer6 := TGet():New( _Lin+10, aPObj[1,2]+590, { |u| If( PCount() == 0, dDtCer6, dDtCer6 := u ) }, oGroup1, 060, 012, "@D", {|| VldData() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtCer6",,,,lHasButton  )

	_Lin += 23
	TSay():New( _Lin+3,aPObj[1,2],{|| "7o. Certificado" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oCert7 := TGet():New( _Lin+10,aPObj[1,2],{ | u | If( PCount() == 0, cCert7, cCert7 := u ) },oGroup1,150,12,, {||  .T. }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,/*bChange*/,.F.,.F.,,"cCert7",,,,.T.,.F.)

	TSay():New( _Lin+3,aPObj[1,2]+150,{|| "7a. Validade" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oDtCer7 := TGet():New( _Lin+10, aPObj[1,2]+150, { |u| If( PCount() == 0, dDtCer7, dDtCer7 := u ) }, oGroup1, 060, 012, "@D", {|| VldData() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtCer7",,,,lHasButton  )

	TSay():New( _Lin+3,aPObj[1,2]+220,{|| "8o. Certificado" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oCert8 := TGet():New( _Lin+10,aPObj[1,2]+220,{ | u | If( PCount() == 0, cCert8, cCert8 := u ) },oGroup1,150,12,, {|| .T. }/*bValid*/,,,,.F.,,.T.,,.F.,{|| .T.},.F.,.F.,/*bChange*/,.F.,.F.,,"cCert8",,,,.T.,.F.)

	TSay():New( _Lin+3,aPObj[1,2]+370,{|| "8a. Validade" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oDtCer8 := TGet():New( _Lin+10, aPObj[1,2]+370, { |u| If( PCount() == 0, dDtCer8, dDtCer8 := u ) }, oGroup1, 060, 012, "@D", {|| VldData() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtCer8",,,,lHasButton  )

	TSay():New( _Lin+3,aPObj[1,2]+440,{|| "9o. Certificado" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oCert9 := TGet():New( _Lin+10,aPObj[1,2]+440,{ | u | If( PCount() == 0, cCert9, cCert9 := u ) },oGroup1,150,12,, {|| .T.}/*bValid*/,,,,.F.,,.T.,,.F.,{|| cCombo = "Produto x Fornecedor"},.F.,.F.,/*bChange*/,.F.,.F.,,"cCert9",,,,.T.,.F.)

	TSay():New( _Lin+3,aPObj[1,2]+590,{|| "9a. Validade" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oDtCer9 := TGet():New( _Lin+10, aPObj[1,2]+590, { |u| If( PCount() == 0, dDtCer9, dDtCer9 := u ) }, oGroup1, 060, 012, "@D", {|| VldData() }, 0, 16777215,,.F.,,.T.,,.F.,{|| cCombo = "Produto x Fornecedor"},.F.,.F.,,.F.,.F. ,,"dDtCer9",,,,lHasButton  )

	_Lin += 23
	TSay():New( _Lin+3,aPObj[1,2],{|| "10o. Certificado" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oCertA := TGet():New( _Lin+10,aPObj[1,2],{ | u | If( PCount() == 0, cCertA, cCertA := u ) },oGroup1,150,12,, {||  .T. }/*bValid*/,,,,.F.,,.T.,,.F.,{|| cCombo = "Produto x Fornecedor"},.F.,.F.,/*bChange*/,.F.,.F.,,"cCertA",,,,.T.,.F.)

	TSay():New( _Lin+3,aPObj[1,2]+150,{|| "10a. Validade" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oDtCerA := TGet():New( _Lin+10, aPObj[1,2]+150, { |u| If( PCount() == 0, dDtCerA, dDtCerA := u ) }, oGroup1, 060, 012, "@D", {|| VldData() }, 0, 16777215,,.F.,,.T.,,.F.,{|| cCombo = "Produto x Fornecedor"},.F.,.F.,,.F.,.F. ,,"dDtCerA",,,,lHasButton  )

	TSay():New( _Lin+3,aPObj[1,2]+220,{|| "11o. Certificado" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oCertB := TGet():New( _Lin+10,aPObj[1,2]+220,{ | u | If( PCount() == 0, cCertB, cCertB := u ) },oGroup1,150,12,, {|| .T. }/*bValid*/,,,,.F.,,.T.,,.F.,{|| cCombo = "Produto x Fornecedor"},.F.,.F.,/*bChange*/,.F.,.F.,,"cCertB",,,,.T.,.F.)

	TSay():New( _Lin+3,aPObj[1,2]+370,{|| "11a. Validade" }, oGroup1,,,,,,.T.,CLR_BLACK,,100,9 )
	oDtCerB := TGet():New( _Lin+10, aPObj[1,2]+370, { |u| If( PCount() == 0, dDtCerB, dDtCerB := u ) }, oGroup1, 060, 012, "@D", {|| VldData() }, 0, 16777215,,.F.,,.T.,,.F.,{|| cCombo = "Produto x Fornecedor"},.F.,.F.,,.F.,.F. ,,"dDtCerB",,,,lHasButton  )

	TSay():New( aPObj[1,1]+120,aPObj[1,2]/*+110*/,{|| "Produtos Relacionados" }, oDlgSX3,,,,,,.T.,,,aPObj[1,4],15 )
	TSay():New( aPObj[1,1]+120,aPObj[1,2]/*+110*/,{|| Replicate("_",aPObj[1,4]) }, oDlgSX3,,,,,,.T.,,,aPObj[1,4],15 )
	oGridCpo := DoGridCpo(oDlgSX3, aPObj[1,1]+130, aPObj[1,2]/*+110*/, aPObj[1,3]-20, aPObj[1,4])	
	bSvblDb5 := oGridCpo:oBrowse:bLDblClick
	oGridCpo:oBrowse:bLDblClick := {|| if(oGridCpo:oBrowse:nColPos!=0, CLIQUE5(), GdRstDblClick(@oGridCpo, @bSvblDb5))}	

	nCol := 0
	nTam := 40
	TButton():New( aPObj[1,3]-10, aPObj[1,2]+nCol, "Gravar", oDlgSX3,{|| MsAguarde({|| AtuCerts() }, "Aguarde...", "Atualizando...", .F.) }, nTam,14,,,.F.,.T.,.F.,,.F.,,,.F. )
	nCol += nTam+5
	nTam := 40
	TButton():New( aPObj[1,3]-10, aPObj[1,2]+nCol, "Sair", oDlgSX3,{|| oDlgSX3:End() }, nTam,14,,,.F.,.T.,.F.,,.F.,,,.F. )	
	
	CarregaGrid(aItens[1])
	
	oDlgSX3:lCentered := .T.
	oDlgSX3:Activate()
	
Return()

Static Function AtuCerts()
Local nX 		:= 0
Local cQry    	:= ""
Local cTabAtu 	:= AllTrim(cCombo)
Local lRet      := .f.

	if !MsgYesNo("Confirma atualização dos certificados para os produtos ?")
		Return(lRet)
	endif

	If empty(cCert1)
   		msgStop("Informe o 1o. certificado, essa informação é obrigatória!!!")
	ElseIf dDtCer1 < dDatabase
	   		msgStop("Validade do 1o. certificado está vencida!!!")
	ElseIf !empty(cCert2) .and. dDtCer2 < dDatabase
	   		msgStop("Validade do 2o. certificado está vencida!!!")
	ElseIf !empty(cCert3) .and. dDtCer3 < dDatabase
	   		msgStop("Validade do 3o. certificado está vencida!!!")
	ElseIf !empty(cCert4) .and. dDtCer4 < dDatabase
	   		msgStop("Validade do 4o. certificado está vencida!!!")
	ElseIf !empty(cCert5) .and. dDtCer5 < dDatabase
	   		msgStop("Validade do 5o. certificado está vencida!!!")
	ElseIf !empty(cCert6) .and. dDtCer6 < dDatabase
	   		msgStop("Validade do 6o. certificado está vencida!!!")
	ElseIf !empty(cCert7) .and. dDtCer7 < dDatabase
	   		msgStop("Validade do 7o. certificado está vencida!!!")
	ElseIf !empty(cCert8) .and. dDtCer8 < dDatabase
	   		msgStop("Validade do 8o. certificado está vencida!!!")
	ElseIf !empty(cCert9) .and. dDtCer9 < dDatabase
	   		msgStop("Validade do 9o. certificado está vencida!!!")
	ElseIf !empty(cCertA) .and. dDtCerA < dDatabase
	   		msgStop("Validade do 10o. certificado está vencida!!!")
	ElseIf !empty(cCertB) .and. dDtCerB < dDatabase
	   		msgStop("Validade do 11o. certificado está vencida!!!")
	Else
		lRet := .t.
	EndIf

    if !lRet
    	Return(lRet)
    endif

	cTab := Iif(cTabAtu = "Todos" .or. cTabAtu = "" , "", Iif(cTabAtu = "Produto x Fornecedor" .or. cTabAtu = "SA2", "SA2", Iif(cTabAtu = "Transportadora" .or. cTabAtu = "SA4", "SA4", "Z55")))
	
	if cTab == "Z55"
	
		dbSelectArea("Z55")
		dbSetOrder(1)
		if !dbSeek(XFilial("Z55")+cCodigo)
			msgStop("Fabricante não localizado para atualização do certificado.", "A t e n ç ã o")
		elseif !RecLock("Z55", .f.)
				msgStop("Não foi possível reservar o registro do Fabricante para a atualização do certificado.", "A t e n ç ã o")
		else                 
			Z55->Z55_CERT1 		:= cCert1
			Z55->Z55_DTCERT1	:= dDtCer1
			Z55->Z55_CERT2 		:= cCert2
			Z55->Z55_DTCERT2	:= dDtCer2
			Z55->Z55_CERT3 		:= cCert3
			Z55->Z55_DTCERT3	:= dDtCer3
			Z55->Z55_CERT4 		:= cCert4
			Z55->Z55_DTCERT4	:= dDtCer4
			Z55->Z55_CERT5 		:= cCert5
			Z55->Z55_DTCERT5	:= dDtCer5
			Z55->Z55_CERT6 		:= cCert6
			Z55->Z55_DTCERT6	:= dDtCer6
			Z55->Z55_CERT7 		:= cCert7
			Z55->Z55_DTCERT7	:= dDtCer7
			Z55->Z55_CERT8 		:= cCert8
			Z55->Z55_DTCERT8	:= dDtCer8
			
			Z55->(MsUnLock())
			
			msgAlert("Certificado(s) do Fabricante atualizado(s) com sucesso.", "A t e n ç ã o")
		endif
	
	else
		
		for nX := 1 to len(oGridCpo:aCols)
			
			if oGridCpo:aCols[nX][1] == "LBOK"
				
				dbSelectArea("SA5")
				dbGoTo( oGridCpo:aCols[nX][8] )
				
				if Recno() == oGridCpo:aCols[nX][8] .and. Reclock("SA5", .F.) 
					SA5->A5_XCERT1 	:= cCert1
					SA5->A5_VALFORN	:= dDtCer1
					SA5->A5_XCERT2 	:= cCert2
					SA5->A5_XDTCER2	:= dDtCer2
					SA5->A5_XCERT3 	:= cCert3
					SA5->A5_XDTCER3	:= dDtCer3
					SA5->A5_XCERT4 	:= cCert4
					SA5->A5_XDTCER4	:= dDtCer4
					SA5->A5_XCERT5 	:= cCert5
					SA5->A5_XDTCER5	:= dDtCer5
					SA5->A5_XCERT6 	:= cCert6
					SA5->A5_XDTCER6	:= dDtCer6
					SA5->A5_XCERT7 	:= cCert7
					SA5->A5_XDTCER7	:= dDtCer7
					SA5->A5_XCERT8	:= cCert8
					SA5->A5_XDTCER8	:= dDtCer8
					SA5->A5_XCERT9	:= cCert9
					SA5->A5_XDTCER9	:= dDtCer9
					SA5->A5_XCERTA	:= cCertA
					SA5->A5_XDTCERA	:= dDtCerA
					SA5->A5_XCERTB	:= cCertB
					SA5->A5_XDTCERB	:= dDtCerB
		
					SA5->(MsUnlock())
				endif
				
			endif
			
		next nX
		
	endif
	
	msgAlert("Certificado(s) do(s) atualizado(s) com sucesso.", "A t e n ç ã o")
	
	CarregaGrid(,.f.)
	
Return

Static Function VldData()
Local lRet 	  := .t.
Local cGetDt  := Upper(AllTrim(ReadVar()))
Local cGetCer := "cCert" + Right(cGetDt,1)

if empty( &cGetDt ) .and. !empty( &cGetCer )
	lRet := .f.
	msgAlert("Data obrigatória se o certificado foi informado.", "A t e n ç ã o")
	
elseif !empty( &cGetDt ) .and. empty( &cGetCer )
		lRet := .f.
		msgAlert("Informe o certificado antes de informar a data de validade.", "A t e n ç ã o")

elseif !empty( &cGetDt ) .and. !empty( &cGetCer )
		if &cGetDt < dDataBase
			lRet := msgYesNo("Validade vencida, a informação está correta?", "A t e n ç ã o")
		endif
		
endif

Return( lRet )

//---------------------------------------------------------
// Monta Grid de Notas Fiscais
//---------------------------------------------------------
Static Function DoGridCpo(oDlg, nTop, nLeft, nBottom, nRight)

	Local aHeaderEx    := {}
	Local aColsEx      := {}
	Local aFieldFill   := {}
	Local aAlterFields := {}
	Local nLinMax 	   := 999  // Quantidade de linha na getdados
	
	Aadd(aHeaderEx,{'','MARK','@BMP',2,0,'','€€€€€€€€€€€€€€','C','','','',''})
	Aadd(aFieldFill,"LBNO")
	Aadd(aHeaderEx,{"CODIGO","CODIGO","@!",15,0,"","","C","","","",""})
	Aadd(aFieldFill, space(6)) 
	Aadd(aHeaderEx,{"DESCRICAO","DESCRICAO","",50,0,"","","C","","","",""})
	Aadd(aFieldFill, space(50)) 
	Aadd(aHeaderEx,{"UM","UM","@!",02,0,"","","C","","","",""})
	Aadd(aFieldFill, space(02)) 
	Aadd(aHeaderEx,{"TIPO","TIPO","@!",02,0,"","","C","","","",""})
	Aadd(aFieldFill, space(02)) 
	Aadd(aHeaderEx,{"CERTIFICADO","CERTIFICADO","@!",40,0,"","","N","","","",""})
	Aadd(aFieldFill, space(40)) 
	Aadd(aHeaderEx,{"VENCIMENTO","VENCIMENTO","@!",10,0,"","","N","","","",""})
	Aadd(aFieldFill, space(10)) 
	Aadd(aHeaderEx,{"Recno WT","Recno WT","@E 9999999999",10,0,"","","N","","","",""})
	Aadd(aFieldFill, 0) 
	Aadd(aFieldFill,.F.) //deletado
	
	Aadd(aColsEx, aFieldFill)	

	//Aadd(aAlterFields, "CODIGO")	

//MsNewGetDados(): 
//New ( [ nTop], [ nLeft], [ nBottom], [ nRight ], [ nStyle], [ cLinhaOk], [ cTudoOk], [ cIniCpos], [ aAlter], [ nFreeze], [ nMax], [ cFieldOk], [ cSuperDel], [ cDelOk], [ oWnd], [ aPartHeader], [ aParCols], [ uChange], [ cTela] ) --> Objeto
//Return MsNewGetDados():New( nTop, nLeft, nBottom, nRight, GD_INSERT + GD_UPDATE + GD_DELETE, "u_Vit627Ln()", "u_Vit627Ok()", "AllwaysTrue", aAlterFields, , nLinMax, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return MsNewGetDados():New( nTop, nLeft, nBottom, nRight, , "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aAlterFields, , nLinMax, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

//------------------------------------------------
User Function Vit627Ln(a,b,c)
Local lRet := .t.

Return(lRet)
//------------------------------------------------

//------------------------------------------------
User Function Vit627Ok(a,b,c) 
Local lRet 		:= .t.
Local nI   		:= 1
Local nPrdCod 	:= AScan(aHeader, {|x| Upper(AllTrim(x[2])) == "CODIGO"})
Local nPrdDesc 	:= AScan(aHeader, {|x| Upper(AllTrim(x[2])) == "DESCRICAO"})
Local lExiste   := .f.

for nI := 1 to len(aCols)
	dbSelectArea("SA5")
	dbSetOrder(1)
	lExiste := dbSeek(XFilial("SA5")+cCodigo+cLoja+aCols[nI][nPrdCod])
	
	if ! aCols[nI][len(aHeader)+1]
		if lExiste .and. RecLock("SA5", .f.)
			SA5->(dbDelete())
			SA5->(MSUnLock())
		endif
	else                 
		if RecLock("SA5", !lExiste)
			SA5->A5_FILIAL  := XFilial("SA5")
			SA5->A5_FORNECE := cCodigo
			SA5->A5_LOJA 	:= cLoja
			SA5->A5_NOMEFOR	:= cNome
			SA5->A5_PRODUTO := aCols[nI][nPrdCod]
			SA5->A5_NOMPROD := aCols[nI][nPrdDesc]
			SA5->A5_XCERT1 	:= cCert1
			SA5->A5_VALFORN	:= dDtCer1
			SA5->A5_XCERT2 	:= cCert2
			SA5->A5_XDTCER2	:= dDtCer2
			SA5->A5_XCERT3 	:= cCert3
			SA5->A5_XDTCER3	:= dDtCer3
			SA5->A5_XCERT4 	:= cCert4
			SA5->A5_XDTCER4	:= dDtCer4
			SA5->A5_XCERT5 	:= cCert5
			SA5->A5_XDTCER5	:= dDtCer5
			SA5->A5_XCERT6 	:= cCert6
			SA5->A5_XDTCER6	:= dDtCer6
			SA5->A5_XCERT7 	:= cCert7
			SA5->A5_XDTCER7	:= dDtCer7
			SA5->A5_XCERT8	:= cCert8
			SA5->A5_XDTCER8	:= dDtCer8
			SA5->A5_XCERT9	:= cCert9
			SA5->A5_XDTCER9	:= dDtCer9
			SA5->A5_XCERTA	:= cCertA
			SA5->A5_XDTCERA	:= dDtCerA
			SA5->A5_XCERTB	:= cCertB
			SA5->A5_XDTCERB	:= dDtCerB
			SA5->A5_MSBLQL	:= '2'
			SA5->(MSUnLock())
		endif
	endif
next nI

Return(lRet)
//------------------------------------------------

//------------------------------------------------
Static Function clique5()

	If len(oGridCpo:aCols) == 0
		Return()
	Endif
	
	If oGridCpo:aCols[oGridCpo:NAT][aScan(oGridCpo:aHeader,{|x| AllTrim(x[2])=="MARK"})] == "LBOK"
		oGridCpo:aCols[oGridCpo:NAT][aScan(oGridCpo:aHeader,{|x| AllTrim(x[2])=="MARK"})] := "LBNO"
	Else
		oGridCpo:aCols[oGridCpo:NAT][aScan(oGridCpo:aHeader,{|x| AllTrim(x[2])=="MARK"})] := "LBOK"
	Endif
	
	oGridCpo:oBrowse:REFRESH()

Return

//---------------------------------------------------------
// Carrega Grid conforme vendedor selecionado
//---------------------------------------------------------
Static Function CarregaGrid(cTabAtu,lMensagem)

	Local nItens, nX, cTab := ""
	
	Default cTabAtu 	:= cCombo //aItens[oListTab:nAt]
	Default lMensagem 	:= .t.

	oGridCpo:aCols := {}
	
	cTab := Iif(cTabAtu = "Todos" .or. cTabAtu = "" , "", Iif(cTabAtu = "Produto x Fornecedor" .or. cTabAtu = "SA2", "SA2", Iif(cTabAtu = "Transportadora" .or. cTabAtu = "SA4", "SA4", "Z55")))

	if cTab == "SA2"
		oCodigo:cF3 := "SA2X"
	else
		oCodigo:cF3 := "Z552"
	endif                  
	
	if !empty(cCodigo)
		if ( nItens := U_CertsVencidos(, cTab, cCodigo, cLoja) ) == 0
			if lMensagem
				msgAlert("Não existem produtos relacionados ao " + Iif(cTab == "SA2", "Fornecedor", "Fabricante"), "A t e n ç ã o")
			endif
		endif
	else
		nItens 	:= U_CertsVencidos(, cTab)
	endif
	
	Do While QVIT627->(!Eof())
		aadd(oGridCpo:aCols, { 	"LBOK",;
								QVIT627->CODPRODUTO ,; 
								QVIT627->B1_DESC ,;
								QVIT627->B1_UM ,; 
								QVIT627->B1_TIPO ,; 
								QVIT627->CERTIFICADO ,; 
								DtoC(StoD(QVIT627->DTVENC)) ,;
								QVIT627->RECSA5 ,;
								.F.})
		
		QVIT627->(dbSkip())
	EndDo
	QVIT627->(dbGoTop())
	
	if nItens > 0
		dbSelectArea("SA5")
		dbSetOrder(1)
		dbGoTop()    
		dbGoTo(QVIT627->RECSA5)
	endif

	//cCodigo := Space(TamSX3("A2_COD")[1])
	//cLoja 	:= Space(TamSX3("A2_LOJA")[1])
	//cNome 	:= Space(TamSX3("A2_NOME")[1]+20)
	
	cCert1   := Iif( nItens == 0, Space(TamSX3("A5_XCERT1")[1])	, SA5->A5_XCERT1)
	dDtCer1	 := Iif( nItens == 0, CtoD("")						, SA5->A5_VALFORN)
	cCert2 	 := Iif( nItens == 0, Space(TamSX3("A5_XCERT2")[1]) , SA5->A5_XCERT2)
	dDtCer2	 := Iif( nItens == 0, CtoD("")						, SA5->A5_XDTCER2)
	cCert3 	 := Iif( nItens == 0, Space(TamSX3("A5_XCERT3")[1])	, SA5->A5_XCERT3)
	dDtCer3	 := Iif( nItens == 0, CtoD("")						, SA5->A5_XDTCER3)
	cCert4 	 := Iif( nItens == 0, Space(TamSX3("A5_XCERT4")[1])	, SA5->A5_XCERT4)
	dDtCer4	 := Iif( nItens == 0, CtoD("")						, SA5->A5_XDTCER4)
	cCert5 	 := Iif( nItens == 0, Space(TamSX3("A5_XCERT5")[1])	, SA5->A5_XCERT5)
	dDtCer5	 := Iif( nItens == 0, CtoD("")						, SA5->A5_XDTCER5)
	cCert6 	 := Iif( nItens == 0, Space(TamSX3("A5_XCERT6")[1])	, SA5->A5_XCERT6)
	dDtCer6	 := Iif( nItens == 0, CtoD("")						, SA5->A5_XDTCER6)
	cCert7 	 := Iif( nItens == 0, Space(TamSX3("A5_XCERT7")[1])	, SA5->A5_XCERT7)
	dDtCer7	 := Iif( nItens == 0, CtoD("")						, SA5->A5_XDTCER7)
	cCert8 	 := Iif( nItens == 0, Space(TamSX3("A5_XCERT8")[1])	, SA5->A5_XCERT8)
	dDtCer8	 := Iif( nItens == 0, CtoD("")						, SA5->A5_XDTCER8)
	cCert9 	 := Iif( nItens == 0, Space(TamSX3("A5_XCERT9")[1])	, SA5->A5_XCERT9)
	dDtCer9	 := Iif( nItens == 0, CtoD("")						, SA5->A5_XDTCER9)
	cCertA 	 := Iif( nItens == 0, Space(TamSX3("A5_XCERTA")[1])	, SA5->A5_XCERTA)
	dDtCerA	 := Iif( nItens == 0, CtoD("")						, SA5->A5_XDTCERA)
	cCertB 	 := Iif( nItens == 0, Space(TamSX3("A5_XCERTB")[1])	, SA5->A5_XCERTB)
	dDtCerB	 := Iif( nItens == 0, CtoD("")						, SA5->A5_XDTCERB)
	
	if cTab == "SA2"
		oLoja:Enable()
		oCert9:Enable()
		oCertA:Enable()
		oCertB:Enable()
	else
		oLoja:Disable()
		oCert9:Disable()
		oCertA:Disable()
		oCertB:Disable()
	endif

	oGridCpo:Refresh()
	oGridCpo:GoTo(1) //vai para primeira linha
	
	oCodigo:SetFocus() //vai para primeira linha
	
Return

//---------------------------------------------------------
// verifica legenda. nTipo 1=TAMANHO; 2=DECIMAL; 3=PICTURE
//---------------------------------------------------------
Static Function RetLegX3(nTipo)
	
	Local cRet := "BR_VERDE"
	
	if nTipo==1 .AND. SX3->X3_TAMANHO <> nInteiro
		cRet := "BR_VERMELHO"
	endif 
	
	if nTipo==2 .AND. SX3->X3_DECIMAL <> nDecimal
		cRet := "BR_VERMELHO"
	endif
	
	if nTipo==3 .AND. !(Alltrim(SX3->X3_PICTURE)==alltrim(Mascara(SX3->X3_TAMANHO, SX3->X3_DECIMAL)))
		cRet := "BR_VERMELHO"
	endif
	
Return cRet

//---------------------------------------------------------
// compatibiliza SX3
//---------------------------------------------------------
Static Function CompatSX3(lSoMask)
      
	Local cTabAtu := aItens[oListTab:nAt] 
	Local nX := 0
	
	if MsgYesNo("Confirma atualização dos campos marcados da tabela "+cTabAtu+"")
		
		for nX := 1 to len(oGridCpo:aCols)
			
			if oGridCpo:aCols[nX][1] == "LBOK"
				
				dbSelectArea("SX3")
				SX3->(dbSetOrder(2))
				if SX3->(Dbseek(oGridCpo:aCols[nX][2]))
					Reclock("SX3", .F.) 
						if lSoMask
							SX3->X3_PICTURE := Mascara(SX3->X3_TAMANHO, SX3->X3_DECIMAL)
						else
							SX3->X3_TAMANHO := nInteiro
							SX3->X3_DECIMAL := nDecimal
							SX3->X3_PICTURE := Alltrim(cMascara)
						endif
					SX3->(MsUnlock())
				endif
					
			endif
			
		next nX
		
		MsgInfo("Finalizado!")
		
		VldMask() 
		
	endif
	
Return lRet


Static Function VldMask()  
    
	cMascara := Mascara(nInteiro, nDecimal)

	CarregaGrid()

	oDlgSX3:Refresh()

Return .T.

Static Function VldEntidade()  
Local lRet 		:= .f.
Local cAlias 	:= "Z55"
Local cEntidade := "Fabricante"
Local cCampo    := Upper(AllTrim(ReadVar()))

 	//If Lastkey() <> 13 .or. empty( &cCampo )
 	// 	Return(.t.)
 	//EndIf
 	///////////////////////////////////////////////
 	
    If cCombo == "Produto x Fornecedor"
    	cAlias := "SA2"
    	cEntidade := "Fornecedor"
    ElseIf cCombo == "Transportadora"
    		cAlias := "SA4"     
    		cEntidade := "Transportadora"
    EndIf
    
    dbSelectArea(cAlias)
    dbSetOrder(1)
    
	if !( lRet := MSSeek(XFilial(cAlias)+AllTrim(cCodigo+cLoja), .t.) )
		cLoja 	:= ""
		cNome   := ""

		//msgAlert(cEntidade + " não localizado...")

	elseif cAlias = "SA2"
	        cCodigo := SA2->A2_COD
			cLoja 	:= SA2->A2_LOJA
			cNome   := SA2->A2_NOME

	elseif cAlias = "SA4"
	        cCodigo := SA4->A4_COD
			cLoja 	:= Space(TamSX3("A2_LOJA")[1])
			cNome   := SA4->A4_NOME

	else
        cCodigo := Z55->Z55_CODIGO
		cLoja 	:= Space(TamSX3("A2_LOJA")[1])
		cNome   := Z55->Z55_NOME
	endif

	CarregaGrid()

	oDlgSX3:Refresh()
	
	if lRet
		oCert1:SetFocus()
	else 
		if cCampo == "CCODIGO"
			oCodigo:SetFocus()
		elseif cCampo == "CLOJA"
				oLoja:SetFocus()
		endif
	endif

Return lRet
           
Static Function AtuEntidade()  
Local lRet 		:= .f.
Local cAlias 	:= "Z55"
Local cEntidade := "Fabricante"

    If cCombo == "Produto x Fornecedor"
    	cAlias := "SA2"
    	cEntidade := "Fornecedor"
    ElseIf cCombo == "Transportadora"
    		cAlias := "SA4"     
    		cEntidade := "Transportadora"
    EndIf
    
    dbSelectArea(cAlias)
    dbSetOrder(1)
    
	if !( lRet := MSSeek(XFilial(cAlias)+cCodigo, .t.) )
		cLoja 	:= ""
		cNome   := ""

	elseif cAlias = "SA2"
	        cCodigo := SA2->A2_COD
			cLoja 	:= SA2->A2_LOJA
			cNome   := SA2->A2_NOME

	elseif cAlias = "SA4"
	        cCodigo := SA4->A4_COD
			cLoja 	:= Space(TamSX3("A2_LOJA")[1])
			cNome   := SA4->A4_NOME

	else
        cCodigo := Z55->Z55_CODIGO
		cLoja 	:= Space(TamSX3("A2_LOJA")[1])
		cNome   := Z55->Z55_NOME
	endif

Return(.t.)

Static Function Mascara(pTamanho, pDecimal)

	Local i     := 0
	Local cMasc := ""
	Local nFor //:= (pTamanho - pDecimal - 1 )
	Local nAux := 0
	
	if pDecimal == 0
		nFor := pTamanho
	else
		nFor := (pTamanho - pDecimal - 1 )
	endif
	
	for i := 1 to nFor
		                  
		nAux++  //0
		
		if nAux > 3
			cMasc := ","+cMasc
			nAux := 1
		endif
		
		cMasc := "9"+cMasc

	next i

	if pDecimal == 0
		cMasc := "@E " + cMasc 
	else
		cMasc := "@E " + cMasc + "." + Repl("9",pDecimal)
	endif

Return(cMasc)  


Static Function DoBackup()
	
	Local cTabAtu := aItens[oListTab:nAt] 
	Local cFile := "\BACKUP\"+cTabAtu+"0101_BKP_"+DTOS(dDataBase)+".dtc" 
	
	if FILE(cFile)
		MsgInfo("Arquivo de backup ja existente: " + cFile)
		Return
	endif
	
	if MsgYesNo("Confirma backup da tabela "+cTabAtu +" ?")	
		
		SET DELETED OFF //Desabilita filtro do campo D_E_L_E_T_
		
		DbSelectArea(cTabAtu)
	
		Set Filter To
		
		COPY TO &cFile VIA "CTREECDX"
	    
	    MsgInfo("Finalizado! Arquivo: " + cFile)
		
		SET DELETED ON //Habilita filtro do campo D_E_L_E_T_
		
	endif
	
Return   


Static Function DoDrop()
	
	Local cTabAtu := aItens[oListTab:nAt] 
	Local cTabela
	
	if MsgYesNo("Confirma DROP da tabela "+cTabAtu+" ?")	
		
		//fecho a tabela
		DbSelectArea(cTabAtu)
		(cTabAtu)->(DBCloseArea())
		
		DbSelectArea("SX2")
		if SX2->(DbSeek(cTabAtu))
			cTabela := Alltrim(SX2->X2_ARQUIVO)
			If TcCanOpen(cTabela)
				lOk := TcDelFile(cTabela)  
				If lOk 
					MsgInfo("Tabela "+cTabela+" apagada.")  
				Else    
					MsgStop("Falha ao apagar "+cTabela+" : "+ TcSqlError())  
				Endif
			Else  
				MsgInfo("Talbela "+cTabela+" nao encontrada.")
			Endif
		else
			MsgInfo("Talbela "+cTabela+" nao encontrada.")
		endif
		
	endif

Return      

Static Function DoAppend(cTabAtu, lAuto)
	
	Local cFile 
	Local cPfx 
	Local aChave := {}
	Local cX2Unico 
	Local cChave := ""
	Local cFilDel := "X1" 
	
	Default cTabAtu := aItens[oListTab:nAt] 
	Default lAuto := .F.
	
	cFile := "\BACKUP\"+cTabAtu+"0101_BKP_"+DTOS(dDataBase)+".dtc" 
	cPfx := iif(Substr(cTabAtu,1,1)=="S", Substr(cTabAtu,2,2), cTabAtu)
	cX2Unico := Posicione("SX2",1,cTabAtu,"X2_UNICO")
	
	DbSelectArea(cTabAtu) //recria tabela
	
	if !FILE(cFile)
		if !lAuto
			MsgInfo("Arquivo de backup não encontrado: " + cFile)
		endif
		Return
	endif
	
	if lAuto .OR. MsgYesNo("Confirma append do arquivo na tabela "+cTabAtu +" ?")	
	    
	    SET DELETED OFF //Desabilita filtro do campo D_E_L_E_T_
	    
		dbUseArea(.F.,"CTREECDX",cFile,"TABBKP",.F.,.F.) 
		TABBKP->(DbGoTop())
		While TABBKP->(!Eof())
			
			if TABBKP->(Deleted())
				cChave := TABBKP->(&cX2Unico)
				if (nPos := aScan(aChave, {|x| x[1] == cChave})) == 0 
					cFilDel := "X1"
					aadd(aChave, {cChave, cFilDel})
			    else   
			    	cFilDel := Soma1(aChave[nPos][2])
			    endif
				Reclock("TABBKP", .F.)
					TABBKP->&(cPfx+"_FILIAL") := cFilDel
				TABBKP->(MsUnlock())
			endif
			
			TABBKP->(DbSkip())
		enddo
		
		if Alias() == "TABBKP"
			DbSelectArea(cTabAtu)
	
			Append From TABBKP
	    
		    TABBKP->(dbCloseArea())
	    	(cTabAtu)->(dbCloseArea())
	    	if !lAuto
		    	MsgInfo("Finalizado Append do Arquivo: " + cFile)
	    	endif
	    else
	    	if !lAuto
		    	MsgInfo("Falha ao abrir arquivo " + cFile)
	    	endif
		endif
		
		SET DELETED ON //Habilita filtro do campo D_E_L_E_T_
		
	endif
	
Return         

//faz append automatico
Static Function DoAppAuto()
	      
	//tabelas que ja foram
	//aItens       := {"SB2","SB6","SB7","SB8","SB9","SBJ","SBK","SBC","SBF","SC1","SC2","SC5","SC6","SC7","SC8","SC9","SCP","SCQ","SD1","SD2","SD3","SD4","SD5","SD7","SDA","SDB","SDC","SDD","SB1"}
	Local aTblNot := {"SB2","SB6","SB7","SB8","SB9","SBC","SC1","SC2","SC5","SC8","SCP","SCQ","SDA","SDD","SDC","SD7","SB1"}
	//Local aUpd    := {"SBJ","SBF","SC7","SD1","SD3","SD5",}
	//Local aUpd    := {"SBK","SC6","SC9","SD2","SD4","SD7","SDB"}
	Local aUpd    := {"SD5"}
	Local nX := 0
    /*
	For nX := 1 to len(aItens)
		
		if aScan(aTblNot, aItens[nX]) == 0 
			MsAguarde({|| DoAppend(aItens[nX], .T.) },"Aguarde...","Fazendo append tabela "+aItens[nX]+"...",.F.)
		endif
		
	next nX
	*/
	
	For nX := 1 to len(aUpd)
		
		MsAguarde({|| DoAppend(aUpd[nX], .T.) },"Aguarde...","Fazendo append tabela "+aUpd[nX]+"...",.F.)
		
	next nX
	
Return

User Function HVit627()
Local oBrowse
Private aRotina := {}
        
MsgRun("Criando estrutura e carregando dados no arquivo temporário...",,{|| GeraTemp() } )

// crio o objeto do Browser
oBrowse := FWmBrowse():New()

// defino o Alias
oBrowse:SetAlias("VT627A")

// informo a descrição
oBrowse:SetDescription("Layout de Importação de Prospect")  

// crio as legendas 
oBrowse:AddLegend("STATUS == 'A'", "GREEN"	,	"Ativo")
oBrowse:AddLegend("STATUS == 'I'", "RED"	,	"Inativo")  

// ativo o browser
oBrowse:Activate()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MenuDef º Autor ³ Henrique Corrêa º Data ³ 31/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que cria os menus									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitamedic                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MenuDef() 

Local aRotina := {}

ADD OPTION aRotina Title 'Pesquisar'   	Action 'PesqBrw'          	OPERATION 01 ACCESS 0
ADD OPTION aRotina Title 'Visualizar'  	Action 'VIEWDEF.UVIT627' 	OPERATION 02 ACCESS 0
ADD OPTION aRotina Title 'Incluir'     	Action 'VIEWDEF.UVIT627' 	OPERATION 03 ACCESS 0
ADD OPTION aRotina Title 'Alterar'     	Action 'VIEWDEF.UVIT627' 	OPERATION 04 ACCESS 0
ADD OPTION aRotina Title 'Excluir'     	Action 'VIEWDEF.UVIT627' 	OPERATION 05 ACCESS 0
ADD OPTION aRotina Title 'Imprimir'    	Action 'VIEWDEF.UVIT627' 	OPERATION 08 ACCESS 0
ADD OPTION aRotina Title 'Copiar'      	Action 'VIEWDEF.UVIT627' 	OPERATION 09 ACCESS 0  
ADD OPTION aRotina Title 'Legenda'     	Action 'U_UVIT627L()'  		OPERATION 10 ACCESS 0    
ADD OPTION aRotina Title 'Importar'    	Action 'U_UCOM019()'  		OPERATION 11 ACCESS 0    

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ModelDef º Autor ³ Henrique Corrêa º Data ³31/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que cria o objeto model							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitamedic                             		                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ModelDef()

Local oStruVT627A := FWFormStruct( 1, 'VT627A', /*bAvalCampo*/, /*lViewUsado*/ )
Local oStruVT627B := FWFormStruct( 1, 'VT627B', /*bAvalCampo*/, /*lViewUsado*/ ) 
Local oStruVT627C := FWFormStruct( 1, 'VT627C', /*bAvalCampo*/, /*lViewUsado*/ ) 
Local oModel

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'PCOM018', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

/////////////////////////  CABEÇALHO - DADOS DO LAYOUT  ////////////////////////////

// Crio a Enchoice
oModel:AddFields( 'VT627AMASTER', /*cOwner*/, oStruVT627A )

// Adiciona a chave primaria da tabela principal
oModel:SetPrimaryKey({ "VT627A_FILIAL" , "VT627A_CODIGO" })    

// Preencho a descrição da entidade
oModel:GetModel('VT627AMASTER'):SetDescription('Dados do Layout:')

///////////////////////////  ITENS - CAMPOS DO PROSPECT  //////////////////////////////

// Crio o grid
oModel:AddGrid( 'VT627BDETAIL', 'VT627AMASTER', oStruVT627B, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )    

// Faço o relaciomaneto entre o cabeçalho e os itens
oModel:SetRelation( 'VT627BDETAIL', { { 'VT627B_FILIAL', 'xFilial( "VT627B" )' } , { 'VT627B_CODIGO', 'VT627A_CODIGO' } } , VT627B->(IndexKey(1)) )  

// Seto a propriedade de não obrigatoriedade do preenchimento do grid
oModel:GetModel('VT627BDETAIL'):SetOptional( .F. )     

// Preencho a descrição da entidade
oModel:GetModel('VT627BDETAIL'):SetDescription('Detalhamento do Prospect:')      

///////////////////////////  ITENS - CAMPOS DA OAB  //////////////////////////////

// Crio o grid
oModel:AddGrid( 'VT627CDETAIL', 'VT627AMASTER', oStruVT627C, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )    

// Faço o relaciomaneto entre o cabeçalho e os itens
oModel:SetRelation( 'VT627CDETAIL', { { 'TIPO', 'xFilial( "VT627C" )' } , { 'VT627C_CODIGO', 'VT627A_CODIGO' } } , VT627C->(IndexKey(1)) )  

// Seto a propriedade de não obrigatoriedade do preenchimento do grid
oModel:GetModel('VT627CDETAIL'):SetOptional( .T. )     

// Preencho a descrição da entidade
oModel:GetModel('VT627CDETAIL'):SetDescription('Detalhamento da OAB:') 

Return(oModel)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ViewDef º Autor ³ Henrique Corrêa º Data ³ 31/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que cria o objeto View							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitamedic                                                 	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ViewDef()

Local oStruVT627A 	:= FWFormStruct(2,'VT627A')
Local oStruVT627B 	:= FWFormStruct(2,'VT627B') 
Local oStruVT627C 	:= FWFormStruct(2,'VT627C') 
Local oModel   	:= FWLoadModel('UVIT627')
Local oView

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel(oModel)

oView:AddField('VIEW_VT627A'	, oStruVT627A, 'VT627AMASTER') // cria o cabeçalho
oView:AddGrid('VIEW_VT627B'	, oStruVT627B, 'VT627BDETAIL') // Cria o grid
oView:AddGrid('VIEW_VT627C'	, oStruVT627C, 'VT627CDETAIL') // Cria o grid

// Crio os Panel's horizontais 
oView:CreateHorizontalBox('PANEL_CABECALHO' , 30)
oView:CreateHorizontalBox('PANEL_ITENS'		, 70) 

oView:CreateVerticalBox( 'ESQUERDA'		, 49 , 'PANEL_ITENS' )
oView:CreateVerticalBox( 'SEPARADOR1'	, 02 , 'PANEL_ITENS' )
oView:CreateVerticalBox( 'DIREITA'		, 49 , 'PANEL_ITENS' )   

// Relaciona o ID da View com os panel's
oView:SetOwnerView('VIEW_VT627A' , 'PANEL_CABECALHO')
oView:SetOwnerView('VIEW_VT627B' , 'ESQUERDA')  
oView:SetOwnerView('VIEW_VT627C' , 'DIREITA')   

// Ligo a identificacao do componente
oView:EnableTitleView('VIEW_VT627A')
oView:EnableTitleView('VIEW_VT627B') 
oView:EnableTitleView('VIEW_VT627C') 

// Define fechamento da tela ao confirmar a operação
oView:SetCloseOnOk({||.T.})

Return(oView)                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UVIT627L º Autor ³ Henrique Corrêa      º Data³ 31/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Legenda do browser										  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitamedic      	                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UVIT627L()

BrwLegenda("Status do Layout","Legenda",{ {"BR_VERDE","Ativo"},{"BR_VERMELHO","Inativo"} })  

Return()                     

Static Function GeraTemp()
Local cQry   	:= ""
Local aStru  	:= {}
Local _cStatus 	:= ""

//-------------------------------------------------------------------------------------------------------------------------------------------//
if Select("VT627A") > 0
	FechaArqTemp()
endif

//ª Estrutura da tabela temporaria
AADD(aStru,{"27A_TIPO"		,"C", 01, 0})
AADD(aStru,{"27A_CODIGO"	,"C", 06, 0})
AADD(aStru,{"27A_LOJA"		,"C", 02, 0})
AADD(aStru,{"27A_NOME"		,"C", 50, 0})
AADD(aStru,{"27A_STATUS"	,"C", 01, 0})

// Crio o arquivo de trabalho e os índices
cArqVT627A := CriaTrab( aStru, .T. )
cInd1 := Left( cArqVT627A, 7 ) + "1"

// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
dbUseArea( .T., __LocalDriver, cArqVT627A, "VT627A", .F., .F. )

// Criar os índices.
IndRegua( "VT627A", cInd1, "27A_TIPO+27A_CODIGO+27A_LOJA", , , "Criando índices (Tipo + Codigo + Loja)...")

// Libera os índices.
dbClearIndex()

// Agrega a lista dos índices da tabela (arquivo).
dbSetIndex( cInd1 + OrdBagExt() )
dbSetOrder(1)

//-------------------------------------------------------------------------------------------------------------------------------------------//
if Select("VT6272") > 0
	FechaArqTemp()
endif

//ª Estrutura da tabela temporaria
AADD(aStru,{"27B_TIPO"		,"C", 01, 0})
AADD(aStru,{"27B_CODIGO"	,"C", 06, 0})
AADD(aStru,{"27B_LOJA"		,"C", 02, 0})
AADD(aStru,{"27B_NOME"		,"C", 50, 0})
AADD(aStru,{"27B_CERT01"	,"C", 40, 0})
AADD(aStru,{"27B_DTCER01"	,"D", 08, 0})
AADD(aStru,{"27B_CERT02"	,"C", 40, 0})
AADD(aStru,{"27B_DTCER02"	,"D", 08, 0})
AADD(aStru,{"27B_CERT03"	,"C", 40, 0})
AADD(aStru,{"27B_DTCER03"	,"D", 08, 0})
AADD(aStru,{"27B_CERT04"	,"C", 40, 0})
AADD(aStru,{"27B_DTCER04"	,"D", 08, 0})
AADD(aStru,{"27B_CERT05"	,"C", 40, 0})
AADD(aStru,{"27B_DTCER05"	,"D", 08, 0})
AADD(aStru,{"27B_CERT06"	,"C", 40, 0})
AADD(aStru,{"27B_DTCER06"	,"D", 08, 0})
AADD(aStru,{"27B_CERT07"	,"C", 40, 0})
AADD(aStru,{"27B_DTCER07"	,"D", 08, 0})
AADD(aStru,{"27B_CERT08"	,"C", 40, 0})
AADD(aStru,{"27B_DTCER08"	,"D", 08, 0})
AADD(aStru,{"27B_CERT09"	,"C", 40, 0})
AADD(aStru,{"27B_DTCER09"	,"D", 08, 0})
AADD(aStru,{"27B_CERT10"	,"C", 40, 0})
AADD(aStru,{"27B_DTCER10"	,"D", 08, 0})
AADD(aStru,{"27B_CERT11"	,"C", 40, 0})
AADD(aStru,{"27B_DTCER11"	,"D", 08, 0})

// Crio o arquivo de trabalho e os índices
cArqVT6272 := CriaTrab( aStru, .T. )
cInd2 := Left( cArqVT6272, 7 ) + "2"

// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
dbUseArea( .T., __LocalDriver, cArqVT6272, "VT6272", .F., .F. )

// Criar os índices.
IndRegua( "VT6272", cInd1, "27B_TIPO+27B_CODIGO+27B_LOJA", , , "Criando índices (Tipo + Codigo + Loja)...")

// Libera os índices.
dbClearIndex()

// Agrega a lista dos índices da tabela (arquivo).
dbSetIndex( cInd2 + OrdBagExt() )
dbSetOrder(1)

//-------------------------------------------------------------------------------------------------------------------------------------------//

if Select("VT627C") > 0
	FechaArqTemp()
endif

//ª Estrutura da tabela temporaria
AADD(aStru,{"27C_OK"		,"C", 02, 0})
AADD(aStru,{"27C_TIPO"		,"C", 01, 0})
AADD(aStru,{"27C_CODIGO"	,"C", 06, 0})
AADD(aStru,{"27C_LOJA"		,"C", 02, 0})
AADD(aStru,{"27C_COD"	    ,"C", 15, 0})
AADD(aStru,{"27C_DESC"		,"C", 50, 0})
AADD(aStru,{"27C_UM"		,"C", 02, 0})
AADD(aStru,{"27C_TP"		,"C", 02, 0})

// Crio o arquivo de trabalho e os índices
cArqVT627C := CriaTrab( aStru, .T. )
cInd1 := Left( cArqVT627C, 7 ) + "1"

// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
dbUseArea( .T., __LocalDriver, cArqVT627C, "VT627C", .F., .F. )

// Criar os índices.
IndRegua( "VT627C", cInd1, "27C_TIPO+27C_CODIGO+27C_LOJA+27C_COD", , , "Criando índices (Tipo + Codigo + Loja + Cod. Produto)...")

// Libera os índices.
dbClearIndex()

// Agrega a lista dos índices da tabela (arquivo).
dbSetIndex( cInd1 + OrdBagExt() )

dbSetOrder(1)

/*
if !u_Vt600AtuZ52()
	msgAlert("Erro ao tentar limpar pedidos com liberação cancalada do painel de expedição.", "A t e n ç ã o")

else
	if mv_par07 == 2 
		_cStatus := "'4'"
	elseif mv_par07 > 2 
			_cStatus := "'1'"
	endif
	
	cQry :=        " SELECT Z52.Z52_PEDIDO "
	cQry += CRLF + "      , Z52.Z52_ITEM "
	cQry += CRLF + "      , Z52.Z52_SEQ "
	cQry += CRLF + "      , Z52.Z52_Local "
	cQry += CRLF + "      , Z52.Z52_COD "
	cQry += CRLF + "      , SB1.B1_DESC  "
	cQry += CRLF + "      , SB1.B1_UM "
	cQry += CRLF + "      , Z52.Z52_QTDLIB "
	cQry += CRLF + "      , Z52.Z52_CLIENT "
	cQry += CRLF + "      , Z52.Z52_LOJA "
	cQry += CRLF + "      , SA1.A1_NOME "
	cQry += CRLF + "      , Z52.Z52_STATUS "
	cQry += CRLF + "      , Z52.Z52_DATALI "
	cQry += CRLF + "      , Z52.Z52_BLEST "
	cQry += CRLF + "      , Z52.Z52_BLCRED "
	cQry += CRLF + "      , Z52.Z52_NUMOS "
	cQry += CRLF + "      , Z52.Z52_LOTECT "
	cQry += CRLF + "      , Z52.Z52_DTVALI "
	cQry += CRLF + " FROM "+RetSqlName("Z52")+" Z52  "
	cQry += CRLF + " INNER JOIN "+RetSqlName("SA1")+" SA1 ON (SA1.A1_FILIAL       = '"+XFilial("SA1")+"' "
	cQry += CRLF + "                           AND SA1.A1_COD      = Z52.Z52_CLIENT "
	cQry += CRLF + "                           AND SA1.A1_LOJA     = Z52.Z52_LOJA "
	cQry += CRLF + "                           AND SA1.D_E_L_E_T_  = ' '  "
	cQry += CRLF + "                          ) "
	cQry += CRLF + " INNER JOIN "+RetSqlName("SB1")+" SB1 ON (SB1.B1_FILIAL       = '"+XFilial("SB1")+"' "
	cQry += CRLF + "                           AND SB1.B1_COD      = Z52.Z52_COD "
	cQry += CRLF + "                           AND SB1.D_E_L_E_T_  = ' '  "
	cQry += CRLF + "                          ) "
	cQry += CRLF + " WHERE Z52.Z52_FILIAL  = '"+XFilial("Z52")+"' "
	cQry += CRLF + "   AND Z52.D_E_L_E_T_  = ' ' "
	cQry += CRLF + "   AND Z52.Z52_BLEST   IN (' ', '10') "
	cQry += CRLF + "   AND Z52.Z52_BLCRED  IN (' ', '10') "

	if !empty(mv_par01) .and. !empty(mv_par02)
		cQry += CRLF + "   AND Z52.Z52_DATALI BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
	endif
	
	if !empty(_cStatus)
		cQry += CRLF + "   AND ( Z52.Z52_STATUS = ' ' 
		cQry += CRLF + "       OR Z52.Z52_STATUS IN ("+_cStatus+") "
		cQry += CRLF + "       ) "
	endif

	cQry += CRLF + " ORDER BY Z52.Z52_FILIAL "
	cQry += CRLF + "        , Z52.Z52_PEDIDO "
	cQry += CRLF + "        , Z52.Z52_NUMOS "
	cQry += CRLF + "        , Z52.Z52_ITEM  "
	cQry += CRLF + "        , Z52.Z52_SEQ  "
	cQry += CRLF + " "
	
	if Select("QZ52") > 0
		dbSelectArea("QZ52")
		dbCloseArea()
	endif

	TCQuery cQry New Alias "QZ52"
	
	do while QZ52->( !Eof() )
		dbSelectArea("VT627C")
		if RecLock("VT627C", .t.)

			VT627C->NUMOS 		:= QZ52->Z52_NUMOS
			VT627C->PEDIDO 	:= QZ52->Z52_PEDIDO
			VT627C->ITEM 		:= QZ52->Z52_ITEM
			VT627C->SEQ 		:= QZ52->Z52_SEQ
			VT627C->Local 		:= QZ52->Z52_LOCAL
			VT627C->COD 		:= QZ52->Z52_COD
			VT627C->DESC 		:= QZ52->B1_DESC
			VT627C->UM 		:= QZ52->B1_UM
			VT627C->LOTE 		:= QZ52->Z52_LOTECT
			VT627C->DATAVAL	:= DtoC(StoD(QZ52->Z52_DTVALI))
			VT627C->DATALIB	:= DtoC(StoD(QZ52->Z52_DATALI))
			VT627C->QTDLIB		:= QZ52->Z52_QTDLIB
			VT627C->CLIENTE	:= QZ52->Z52_CLIENT
			VT627C->LOJA 		:= QZ52->Z52_LOJA
			VT627C->NOME 		:= QZ52->A1_NOME
			VT627C->STATUS 	:= QZ52->Z52_STATUS
			VT627C->BLEST 		:= QZ52->Z52_BLEST
			VT627C->BLCRED 	:= QZ52->Z52_BLCRED
			
			VT627C->( MsUnLock() )
	    endif
	    
		QZ52->( dbSkip() )
	enddo
	        
	QZ52->( dbCloseArea() )
	
endif
*/

Return()

Static Function FechaArqTemp()

	//Fecha a área
	VT627C->(dbCloseArea())
	
	//Apaga o arquivo fisicamente
	FErase( aVT627C[ nVT627C ] + GetDbExtension())
	
	//Apaga os arquivos de índices fisicamente
	FErase( aVT627C[ nIND1 ] + OrdBagExt())
	FErase( aVT627C[ nIND2 ] + OrdBagExt())
	FErase( aVT627C[ nIND3 ] + OrdBagExt())

Return()

User Function CertsVencidos(pData,pTab,pCodigo,pLoja)
Local cQry          
Local pRecnos
Local MV_VIT626D := SuperGetMV("MV_VIT626D", .f., 60)

//Default pData 	 := DtoS(dDataBase + MV_VIT626D)  
Default pData    := ""
Default pTab     := ""
Default pCodigo  := "XXXXXX"
Default pLoja    := "XX"
	
	IncProc("Solicitação de Compras...")

	cQry :=        " SELECT QQ.ENTIDADE "
	cQry += CRLF + "      , QQ.CODIGO "
	cQry += CRLF + "      , QQ.LOJA "
	cQry += CRLF + "      , QQ.NOME "
	cQry += CRLF + "      , QQ.CERTIFICADO "
	cQry += CRLF + "      , QQ.DTVENC "
	cQry += CRLF + "      , QQ.CODPRODUTO "
	cQry += CRLF + "      , QQ.RECSA5 "
	cQry += CRLF + "      , QB1.B1_DESC "
	cQry += CRLF + "      , QB1.B1_UM "
	cQry += CRLF + "      , QB1.B1_TIPO "
	cQry += CRLF + "      , SUM(QQ.QTDPRODUTOS) QTDPRODUTOS "
	cQry += CRLF + " FROM ( "
	
	if empty(pTab) .or. pTab == "SA2"
		cQry += CRLF + "        SELECT 'SA2'                  																			ENTIDADE "
		cQry += CRLF + "             , SA5.A5_FORNECE         																			CODIGO "
		cQry += CRLF + "             , SA5.A5_LOJA            																			LOJA "
		cQry += CRLF + "             , SA5.A5_NOMEFOR         																			NOME "
		cQry += CRLF + "             , Max(Case When SA5.A5_VALFORN <= '" + DtoS(dDataBase) + "' Then '1o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERT2 <> ' ' AND SA5.A5_XDTCER2 <= '" + DtoS(dDataBase) + "' Then '2o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERT3 <> ' ' AND SA5.A5_XDTCER3 <= '" + DtoS(dDataBase) + "' Then '3o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERT4 <> ' ' AND SA5.A5_XDTCER4 <= '" + DtoS(dDataBase) + "' Then '4o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERT5 <> ' ' AND SA5.A5_XDTCER5 <= '" + DtoS(dDataBase) + "' Then '5o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERT6 <> ' ' AND SA5.A5_XDTCER6 <= '" + DtoS(dDataBase) + "' Then '6o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERT7 <> ' ' AND SA5.A5_XDTCER7 <= '" + DtoS(dDataBase) + "' Then '7o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERT8 <> ' ' AND SA5.A5_XDTCER8 <= '" + DtoS(dDataBase) + "' Then '8o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERT9 <> ' ' AND SA5.A5_XDTCER9 <= '" + DtoS(dDataBase) + "' Then '9o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERTA <> ' ' AND SA5.A5_XDTCERA <= '" + DtoS(dDataBase) + "' Then '10o Certificado' "
		cQry += CRLF + "                    When SA5.A5_XCERTB <> ' ' AND SA5.A5_XDTCERB <= '" + DtoS(dDataBase) + "' Then '11o Certificado' "
		cQry += CRLF + "                    Else '' End) 																	CERTIFICADO "
		cQry += CRLF + "             , Max(Case When SA5.A5_VALFORN <= '" + DtoS(dDataBase) + "' Then SA5.A5_VALFORN "
		cQry += CRLF + "                    When SA5.A5_XCERT2 <> ' ' AND SA5.A5_XDTCER2 <= '" + DtoS(dDataBase) + "' Then SA5.A5_XDTCER2 "
		cQry += CRLF + "                    When SA5.A5_XCERT3 <> ' ' AND SA5.A5_XDTCER3 <= '" + DtoS(dDataBase) + "' Then SA5.A5_XDTCER3 "
		cQry += CRLF + "                    When SA5.A5_XCERT4 <> ' ' AND SA5.A5_XDTCER4 <= '" + DtoS(dDataBase) + "' Then SA5.A5_XDTCER4 "
		cQry += CRLF + "                    When SA5.A5_XCERT5 <> ' ' AND SA5.A5_XDTCER5 <= '" + DtoS(dDataBase) + "' Then SA5.A5_XDTCER5 "
		cQry += CRLF + "                    When SA5.A5_XCERT6 <> ' ' AND SA5.A5_XDTCER6 <= '" + DtoS(dDataBase) + "' Then SA5.A5_XDTCER6 "
		cQry += CRLF + "                    When SA5.A5_XCERT7 <> ' ' AND SA5.A5_XDTCER7 <= '" + DtoS(dDataBase) + "' Then SA5.A5_XDTCER7 "
		cQry += CRLF + "                    When SA5.A5_XCERT8 <> ' ' AND SA5.A5_XDTCER8 <= '" + DtoS(dDataBase) + "' Then SA5.A5_XDTCER8 "
		cQry += CRLF + "                    When SA5.A5_XCERT9 <> ' ' AND SA5.A5_XDTCER9 <= '" + DtoS(dDataBase) + "' Then SA5.A5_XDTCER9 "
		cQry += CRLF + "                    When SA5.A5_XCERTA <> ' ' AND SA5.A5_XDTCERA <= '" + DtoS(dDataBase) + "' Then SA5.A5_XDTCERA "
		cQry += CRLF + "                    When SA5.A5_XCERTB <> ' ' AND SA5.A5_XDTCERB <= '" + DtoS(dDataBase) + "' Then SA5.A5_XDTCERB "
		cQry += CRLF + "                    Else '' End) 																	            DTVENC "
		cQry += CRLF + "             , SA5.A5_PRODUTO  																					CODPRODUTO "
		cQry += CRLF + "             , Min(SA5.R_E_C_N_O_) 																				RECSA5 "
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO)  																			QTDPRODUTOS "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "
        
        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_FORNECE = '"+pCodigo+"' "
			cQry += CRLF + "          AND SA5.A5_LOJA    = '"+pLoja+"' "
		endif
		
		if !empty(pData)	
			cQry += CRLF + "          AND ((SA5.A5_VALFORN <= '" + pData + "') "
			cQry += CRLF + "               OR (SA5.A5_XCERT2 <> ' ' AND SA5.A5_XDTCER2 <= '" + pData + "')  "
			cQry += CRLF + "               OR (SA5.A5_XCERT3 <> ' ' AND SA5.A5_XDTCER3 <= '" + pData + "')  "
			cQry += CRLF + "               OR (SA5.A5_XCERT4 <> ' ' AND SA5.A5_XDTCER4 <= '" + pData + "')  "
			cQry += CRLF + "               OR (SA5.A5_XCERT5 <> ' ' AND SA5.A5_XDTCER5 <= '" + pData + "') ) "
	    endif
	    
		cQry += CRLF + "        GROUP BY SA5.A5_FORNECE  "
		cQry += CRLF + "               , SA5.A5_LOJA  "
		cQry += CRLF + "               , SA5.A5_NOMEFOR "
		cQry += CRLF + "               , SA5.A5_PRODUTO "
    endif         
    
    if empty(pTab)
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
    endif
    
	if empty(pTab) .or. pTab == "SA4"
		cQry += CRLF + "        SELECT 'SA4' 																						ENTIDADE "
		cQry += CRLF + "             , SA4.A4_COD  																					CODIGO "
		cQry += CRLF + "             , '' 																							LOJA "
		cQry += CRLF + "             , SA4.A4_NOME 																					NOME "
		cQry += CRLF + "             , Case When SA4.A4_XCERT1 <> ' ' AND SA4.A4_XDTCER1 <= '" + DtoS(dDataBase) + "' Then '1o Certificado' "
		cQry += CRLF + "                    When SA4.A4_XCERT2 <> ' ' AND SA4.A4_XDTCER2 <= '" + DtoS(dDataBase) + "' Then '2o Certificado' "
		cQry += CRLF + "                    When SA4.A4_XCERT3 <> ' ' AND SA4.A4_XDTCER3 <= '" + DtoS(dDataBase) + "' Then '3o Certificado' "
		cQry += CRLF + "                    When SA4.A4_XCERT4 <> ' ' AND SA4.A4_XDTCER4 <= '" + DtoS(dDataBase) + "' Then '4o Certificado' "
		cQry += CRLF + "                    When SA4.A4_XCERT5 <> ' ' AND SA4.A4_XDTCER5 <= '" + DtoS(dDataBase) + "' Then '5o Certificado' "
		cQry += CRLF + "                    When SA4.A4_XCERT6 <> ' ' AND SA4.A4_XDTCER6 <= '" + DtoS(dDataBase) + "' Then '6o Certificado' "
		cQry += CRLF + "                    When SA4.A4_XCERT7 <> ' ' AND SA4.A4_XDTCER7 <= '" + DtoS(dDataBase) + "' Then '7o Certificado' "
		cQry += CRLF + "                    When SA4.A4_XCERT8 <> ' ' AND SA4.A4_XDTCER8 <= '" + DtoS(dDataBase) + "' Then '8o Certificado' "
		cQry += CRLF + "                    Else ' ' End CERTIFICADO"
		cQry += CRLF + "             , Case When SA4.A4_XCERT1 <> ' ' AND SA4.A4_XDTCER1 <= '" + DtoS(dDataBase) + "' Then SA4.A4_XDTCER1 "
		cQry += CRLF + "                    When SA4.A4_XCERT2 <> ' ' AND SA4.A4_XDTCER2 <= '" + DtoS(dDataBase) + "' Then SA4.A4_XDTCER2 "
		cQry += CRLF + "                    When SA4.A4_XCERT3 <> ' ' AND SA4.A4_XDTCER3 <= '" + DtoS(dDataBase) + "' Then SA4.A4_XDTCER3 "
		cQry += CRLF + "                    When SA4.A4_XCERT4 <> ' ' AND SA4.A4_XDTCER4 <= '" + DtoS(dDataBase) + "' Then SA4.A4_XDTCER4 "
		cQry += CRLF + "                    When SA4.A4_XCERT5 <> ' ' AND SA4.A4_XDTCER5 <= '" + DtoS(dDataBase) + "' Then SA4.A4_XDTCER5 "
		cQry += CRLF + "                    When SA4.A4_XCERT6 <> ' ' AND SA4.A4_XDTCER6 <= '" + DtoS(dDataBase) + "' Then SA4.A4_XDTCER6 "
		cQry += CRLF + "                    When SA4.A4_XCERT7 <> ' ' AND SA4.A4_XDTCER7 <= '" + DtoS(dDataBase) + "' Then SA4.A4_XDTCER7 "
		cQry += CRLF + "                    When SA4.A4_XCERT8 <> ' ' AND SA4.A4_XDTCER8 <= '" + DtoS(dDataBase) + "' Then SA4.A4_XDTCER8 "
		cQry += CRLF + "                    Else ' ' End DTVENC"
		cQry += CRLF + "             , '"+Space(TamSX3("B1_COD")[1])+"'              												CODPRODUTO "
		cQry += CRLF + "             , Min(SA4.R_E_C_N_O_) 																			RECSA4 "
		cQry += CRLF + "             , 1                     																		QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA4") + " SA4  "
		cQry += CRLF + "        WHERE SA4.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA4.A4_COD     = '"+pCodigo+"' "
		endif

		cQry += CRLF + "          AND SA4.A4_XTPPRDS <> ' ' "

		if !empty(pData)	
			cQry += CRLF + "          AND ((SA4.A4_XCERT1 <> ' ' AND SA4.A4_XDTCER1 <= '" + pData + "') "
			cQry += CRLF + "               OR (SA4.A4_XCERT2 <> ' ' AND SA4.A4_XDTCER2 <= '" + pData + "')  "
			cQry += CRLF + "               OR (SA4.A4_XCERT3 <> ' ' AND SA4.A4_XDTCER3 <= '" + pData + "')  "
			cQry += CRLF + "               OR (SA4.A4_XCERT4 <> ' ' AND SA4.A4_XDTCER4 <= '" + pData + "')  "
			cQry += CRLF + "               OR (SA4.A4_XCERT5 <> ' ' AND SA4.A4_XDTCER5 <= '" + pData + "') ) "
		endif
	endif
	
	if empty(pTab)
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
	endif
	
	if empty(pTab) .or. pTab == "Z55"
		cQry += CRLF + "        SELECT 'Z55' 																									ENTIDADE "
		cQry += CRLF + "             , Z55.Z55_CODIGO 																							CODIGO "
		cQry += CRLF + "             , '' 																										LOJA "
		cQry += CRLF + "             , Z55.Z55_NOME  																							NOME "
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + DtoS(dDataBase) + "' Then '1o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + DtoS(dDataBase) + "' Then '2o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + DtoS(dDataBase) + "' Then '3o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + DtoS(dDataBase) + "' Then '4o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + DtoS(dDataBase) + "' Then '5o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT6 <> ' ' AND Z55.Z55_DTCER6 <= '" + DtoS(dDataBase) + "' Then '6o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT7 <> ' ' AND Z55.Z55_DTCER7 <= '" + DtoS(dDataBase) + "' Then '7o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT8 <> ' ' AND Z55.Z55_DTCER8 <= '" + DtoS(dDataBase) + "' Then '8o Certificado' "
		cQry += CRLF + "                    Else ' ' End) 																						CERTIFICADO"
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER1 "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER2 "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER3 "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER4 "
		cQry += CRLF + "                    When Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER5 "
		cQry += CRLF + "                    When Z55.Z55_CERT6 <> ' ' AND Z55.Z55_DTCER6 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER6 "
		cQry += CRLF + "                    When Z55.Z55_CERT7 <> ' ' AND Z55.Z55_DTCER7 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER7 "
		cQry += CRLF + "                    When Z55.Z55_CERT8 <> ' ' AND Z55.Z55_DTCER8 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER8 "
		cQry += CRLF + "                    Else ' ' End) 																						DTVENC"
		cQry += CRLF + "             , SA5.A5_PRODUTO  																							CODPRODUTO "
		cQry += CRLF + "             , Min(SA5.R_E_C_N_O_) 																						RECSA5 "
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO) QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        INNER JOIN " + retsqlname("Z55") + " Z55 ON (Z55.Z55_FILIAL = '"+XFilial("Z55")+"' "
		cQry += CRLF + "                                  AND Z55.Z55_CODIGO = SA5.A5_XFAB1 "
		cQry += CRLF + "                                  AND Z55.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_XFAB1    = '"+pCodigo+"' "
		endif

		if !empty(pData)	
			cQry += CRLF + "          AND ((Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "') "
			cQry += CRLF + "               OR (Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + pData + "') ) "
		endif
		
		cQry += CRLF + "        GROUP BY Z55.Z55_CODIGO "
		cQry += CRLF + "             , Z55.Z55_NOME  "
		cQry += CRLF + "             , SA5.A5_PRODUTO "
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
		cQry += CRLF + "        SELECT 'Z55' 																									ENTIDADE "
		cQry += CRLF + "             , Z55.Z55_CODIGO 																							CODIGO "
		cQry += CRLF + "             , '' 																										LOJA "
		cQry += CRLF + "             , Z55.Z55_NOME  																							NOME "
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + DtoS(dDataBase) + "' Then '1o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + DtoS(dDataBase) + "' Then '2o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + DtoS(dDataBase) + "' Then '3o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + DtoS(dDataBase) + "' Then '4o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + DtoS(dDataBase) + "' Then '5o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT6 <> ' ' AND Z55.Z55_DTCER6 <= '" + DtoS(dDataBase) + "' Then '6o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT7 <> ' ' AND Z55.Z55_DTCER7 <= '" + DtoS(dDataBase) + "' Then '7o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT8 <> ' ' AND Z55.Z55_DTCER8 <= '" + DtoS(dDataBase) + "' Then '8o Certificado' "
		cQry += CRLF + "                    Else ' ' End) 																						CERTIFICADO"
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER1 "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER2 "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER3 "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER4 "
		cQry += CRLF + "                    When Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER5 "
		cQry += CRLF + "                    When Z55.Z55_CERT6 <> ' ' AND Z55.Z55_DTCER6 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER6 "
		cQry += CRLF + "                    When Z55.Z55_CERT7 <> ' ' AND Z55.Z55_DTCER7 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER7 "
		cQry += CRLF + "                    When Z55.Z55_CERT8 <> ' ' AND Z55.Z55_DTCER8 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER8 "
		cQry += CRLF + "                    Else ' ' End) 																						DTVENC"
		cQry += CRLF + "             , SA5.A5_PRODUTO  																							CODPRODUTO "
		cQry += CRLF + "             , Min(SA5.R_E_C_N_O_) 																						RECSA5 "
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO) QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        INNER JOIN " + retsqlname("Z55") + " Z55 ON (Z55.Z55_FILIAL = '"+XFilial("Z55")+"' "
		cQry += CRLF + "                                  AND Z55.Z55_CODIGO = SA5.A5_XFAB2 "
		cQry += CRLF + "                                  AND Z55.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_XFAB2    = '"+pCodigo+"' "
		endif

		if !empty(pData)	
			cQry += CRLF + "          AND ((Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "') "
			cQry += CRLF + "               OR (Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + pData + "') ) "
		endif
		
		cQry += CRLF + "        GROUP BY Z55.Z55_CODIGO "
		cQry += CRLF + "             , Z55.Z55_NOME  "
		cQry += CRLF + "             , SA5.A5_PRODUTO "
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
		cQry += CRLF + "        SELECT 'Z55' 																									ENTIDADE "
		cQry += CRLF + "             , Z55.Z55_CODIGO 																							CODIGO "
		cQry += CRLF + "             , '' 																										LOJA "
		cQry += CRLF + "             , Z55.Z55_NOME  																							NOME "
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + DtoS(dDataBase) + "' Then '1o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + DtoS(dDataBase) + "' Then '2o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + DtoS(dDataBase) + "' Then '3o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + DtoS(dDataBase) + "' Then '4o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + DtoS(dDataBase) + "' Then '5o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT6 <> ' ' AND Z55.Z55_DTCER6 <= '" + DtoS(dDataBase) + "' Then '6o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT7 <> ' ' AND Z55.Z55_DTCER7 <= '" + DtoS(dDataBase) + "' Then '7o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT8 <> ' ' AND Z55.Z55_DTCER8 <= '" + DtoS(dDataBase) + "' Then '8o Certificado' "
		cQry += CRLF + "                    Else ' ' End) 																						CERTIFICADO"
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER1 "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER2 "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER3 "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER4 "
		cQry += CRLF + "                    When Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER5 "
		cQry += CRLF + "                    When Z55.Z55_CERT6 <> ' ' AND Z55.Z55_DTCER6 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER6 "
		cQry += CRLF + "                    When Z55.Z55_CERT7 <> ' ' AND Z55.Z55_DTCER7 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER7 "
		cQry += CRLF + "                    When Z55.Z55_CERT8 <> ' ' AND Z55.Z55_DTCER8 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER8 "
		cQry += CRLF + "                    Else ' ' End) 																						DTVENC"
		cQry += CRLF + "             , SA5.A5_PRODUTO  																							CODPRODUTO "
		cQry += CRLF + "             , Min(SA5.R_E_C_N_O_) 																						RECSA5 "
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO) QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        INNER JOIN " + retsqlname("Z55") + " Z55 ON (Z55.Z55_FILIAL = '"+XFilial("Z55")+"' "
		cQry += CRLF + "                                  AND Z55.Z55_CODIGO = SA5.A5_XFAB3 "
		cQry += CRLF + "                                  AND Z55.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_XFAB3    = '"+pCodigo+"' "
		endif

		if !empty(pData)	
			cQry += CRLF + "          AND ((Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "') "
			cQry += CRLF + "               OR (Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + pData + "') ) "
		endif
		
		cQry += CRLF + "        GROUP BY Z55.Z55_CODIGO "
		cQry += CRLF + "             , Z55.Z55_NOME "
		cQry += CRLF + "             , SA5.A5_PRODUTO "
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
		cQry += CRLF + "        SELECT 'Z55' 																									ENTIDADE "
		cQry += CRLF + "             , Z55.Z55_CODIGO 																							CODIGO "
		cQry += CRLF + "             , '' 																										LOJA "
		cQry += CRLF + "             , Z55.Z55_NOME  																							NOME "
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + DtoS(dDataBase) + "' Then '1o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + DtoS(dDataBase) + "' Then '2o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + DtoS(dDataBase) + "' Then '3o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + DtoS(dDataBase) + "' Then '4o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + DtoS(dDataBase) + "' Then '5o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT6 <> ' ' AND Z55.Z55_DTCER6 <= '" + DtoS(dDataBase) + "' Then '6o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT7 <> ' ' AND Z55.Z55_DTCER7 <= '" + DtoS(dDataBase) + "' Then '7o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT8 <> ' ' AND Z55.Z55_DTCER8 <= '" + DtoS(dDataBase) + "' Then '8o Certificado' "
		cQry += CRLF + "                    Else ' ' End) 																						CERTIFICADO"
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER1 "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER2 "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER3 "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER4 "
		cQry += CRLF + "                    When Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER5 "
		cQry += CRLF + "                    When Z55.Z55_CERT6 <> ' ' AND Z55.Z55_DTCER6 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER6 "
		cQry += CRLF + "                    When Z55.Z55_CERT7 <> ' ' AND Z55.Z55_DTCER7 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER7 "
		cQry += CRLF + "                    When Z55.Z55_CERT8 <> ' ' AND Z55.Z55_DTCER8 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER8 "
		cQry += CRLF + "                    Else ' ' End) 																						DTVENC"
		cQry += CRLF + "             , SA5.A5_PRODUTO  																							CODPRODUTO "
		cQry += CRLF + "             , Min(SA5.R_E_C_N_O_) 																						RECSA5 "
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO) QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        INNER JOIN " + retsqlname("Z55") + " Z55 ON (Z55.Z55_FILIAL = '"+XFilial("Z55")+"' "
		cQry += CRLF + "                                  AND Z55.Z55_CODIGO = SA5.A5_XFAB4 "
		cQry += CRLF + "                                  AND Z55.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_XFAB4    = '"+pCodigo+"' "
		endif

		if !empty(pData)	
			cQry += CRLF + "          AND ((Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "') "
			cQry += CRLF + "               OR (Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + pData + "') ) "
		endif
		
		cQry += CRLF + "        GROUP BY Z55.Z55_CODIGO "
		cQry += CRLF + "             , Z55.Z55_NOME "
		cQry += CRLF + "             , SA5.A5_PRODUTO "
		cQry += CRLF + "  "
		cQry += CRLF + "        UNION ALL "
		cQry += CRLF + "  "
		cQry += CRLF + "        SELECT 'Z55' 																									ENTIDADE "
		cQry += CRLF + "             , Z55.Z55_CODIGO 																							CODIGO "
		cQry += CRLF + "             , '' 																										LOJA "
		cQry += CRLF + "             , Z55.Z55_NOME  																							NOME "
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + DtoS(dDataBase) + "' Then '1o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + DtoS(dDataBase) + "' Then '2o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + DtoS(dDataBase) + "' Then '3o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + DtoS(dDataBase) + "' Then '4o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + DtoS(dDataBase) + "' Then '5o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT6 <> ' ' AND Z55.Z55_DTCER6 <= '" + DtoS(dDataBase) + "' Then '6o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT7 <> ' ' AND Z55.Z55_DTCER7 <= '" + DtoS(dDataBase) + "' Then '7o Certificado' "
		cQry += CRLF + "                    When Z55.Z55_CERT8 <> ' ' AND Z55.Z55_DTCER8 <= '" + DtoS(dDataBase) + "' Then '8o Certificado' "
		cQry += CRLF + "                    Else ' ' End) 																						CERTIFICADO"
		cQry += CRLF + "             , Max(Case When Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER1 "
		cQry += CRLF + "                    When Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER2 "
		cQry += CRLF + "                    When Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER3 "
		cQry += CRLF + "                    When Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER4 "
		cQry += CRLF + "                    When Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER5 "
		cQry += CRLF + "                    When Z55.Z55_CERT6 <> ' ' AND Z55.Z55_DTCER6 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER6 "
		cQry += CRLF + "                    When Z55.Z55_CERT7 <> ' ' AND Z55.Z55_DTCER7 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER7 "
		cQry += CRLF + "                    When Z55.Z55_CERT8 <> ' ' AND Z55.Z55_DTCER8 <= '" + DtoS(dDataBase) + "' Then Z55.Z55_DTCER8 "
		cQry += CRLF + "                    Else ' ' End) 																						DTVENC"
		cQry += CRLF + "             , SA5.A5_PRODUTO  																							CODPRODUTO "
		cQry += CRLF + "             , Min(SA5.R_E_C_N_O_) 																						RECSA5 "
		cQry += CRLF + "             , Count(SA5.A5_PRODUTO) QtdProdutos "
		cQry += CRLF + "        FROM " + retsqlname("SA5") + " SA5  "
		cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                                  AND SB1.B1_COD = SA5.A5_PRODUTO "
		cQry += CRLF + "                                  AND SB1.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        INNER JOIN " + retsqlname("Z55") + " Z55 ON (Z55.Z55_FILIAL = '"+XFilial("Z55")+"' "
		cQry += CRLF + "                                  AND Z55.Z55_CODIGO = SA5.A5_XFAB5 "
		cQry += CRLF + "                                  AND Z55.D_E_L_E_T_ = ' ') "
		cQry += CRLF + "        WHERE SA5.D_E_L_E_T_ = ' ' "

        if !empty(pCodigo)
			cQry += CRLF + "          AND SA5.A5_XFAB5    = '"+pCodigo+"' "
		endif

		if !empty(pData)	
			cQry += CRLF + "          AND ((Z55.Z55_CERT1 <> ' ' AND Z55.Z55_DTCER1 <= '" + pData + "') "
			cQry += CRLF + "               OR (Z55.Z55_CERT2 <> ' ' AND Z55.Z55_DTCER2 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT3 <> ' ' AND Z55.Z55_DTCER3 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT4 <> ' ' AND Z55.Z55_DTCER4 <= '" + pData + "')  "
			cQry += CRLF + "               OR (Z55.Z55_CERT5 <> ' ' AND Z55.Z55_DTCER5 <= '" + pData + "') ) "
        endif
        
		cQry += CRLF + "        GROUP BY Z55.Z55_CODIGO "
		cQry += CRLF + "             , Z55.Z55_NOME "
		cQry += CRLF + "             , SA5.A5_PRODUTO "
	endif
	
	cQry += CRLF + " 	) QQ "
	cQry += CRLF + "        INNER JOIN " + retsqlname("SB1") + " QB1 ON (QB1.B1_FILIAL = '"+XFilial("SB1")+"' "
	cQry += CRLF + "                                  AND QB1.B1_COD = QQ.CODPRODUTO "
	cQry += CRLF + "                                  AND QB1.D_E_L_E_T_ = ' ') "
	cQry += CRLF + " GROUP BY QQ.ENTIDADE "
	cQry += CRLF + "      , QQ.CODIGO "
	cQry += CRLF + "      , QQ.LOJA "
	cQry += CRLF + "      , QQ.NOME "
	cQry += CRLF + "      , QQ.CERTIFICADO "
	cQry += CRLF + "      , QQ.DTVENC "
	cQry += CRLF + "      , QQ.CODPRODUTO "
	cQry += CRLF + "      , QQ.RECSA5 "
	cQry += CRLF + "      , QB1.B1_DESC "
	cQry += CRLF + "      , QB1.B1_UM "
	cQry += CRLF + "      , QB1.B1_TIPO "
	cQry += CRLF + " ORDER BY QQ.ENTIDADE "
	cQry += CRLF + "      , QQ.CODIGO "
	cQry += CRLF + "      , QQ.CODPRODUTO "

	if Select("QVIT627") > 0
		QVIT627->(dbCloseArea())
	endif

	MemoWrite("c:\temp\Vit627.sql",cQry)
	
	pRecnos := u_CountRegs(cQry,"QVIT627")
	
return(pRecnos)

Static Function ConsEntidade() 

cCodigo := Space(TamSX3("A2_COD")[1])
cLoja 	:= Space(TamSX3("A2_LOJA")[1])
cNome 	:= Space(TamSX3("A2_NOME")[1]+20)

if cCombo = "Fabricante"
	MsgRun("Selecionando registros...","Aguarde",{|| cCodigo := U_MultSel("Fabricantes","Z55","Z55_CODIGO,Z55_NOME","Z55_NOME,Z55_CODIGO","Z55_CODIGO <> ' ' ",cCodigo)})
    dbSelectArea("Z55")
    dbSetOrder(1)
    if dbSeek(XFilial("Z55")+cCodigo)
		cNome := Z55->Z55_NOME
	endif
else
	MsgRun("Selecionando registros...","Aguarde",{|| cCodigo := U_MultSel("Fornecedores","SA2","A2_COD,A2_LOJA,A2_NOME","A2_NOME,A2_COD,A2_LOJA","A2_COD <> ' ' ",cCodigo)})
    dbSelectArea("SA2")
    dbSetOrder(1)
    if dbSeek(XFilial("SA2")+cCodigo)
		cCodigo := SA2->A2_COD
		cLoja 	:= SA2->A2_LOJA
		cNome 	:= SA2->A2_NOME
	endif
endif

oCodigo:Refresh()
oLoja:Refresh()
oNome:Refresh()

CarregaGrid()

oDlgSX3:Refresh()

Return  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UWSWMS60 ºAutor  ³Microsiga           º Data ³  19/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Metodo WS para Movimentos Internos e Inventários            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UWSWMS60(oDados, oRet)

	Local lOk 		:= .T.
	Local lExiste 	:= .F.
	Local cMsgErr 	:= ""
	Local cCodProd 	:= ""
	Local cMsgPrd 	:= ""
	Local cArmazem 	:= ""
	Local cLoteCTL  := ""
	Local cOperacao := ""
	Local nQuant    := 0

	Local cTipoMov		:= ""
	Local cDocumento	:= ""
	Local cDocInvR   	:= ""
	Local cDocInvD   	:= ""

	Local nX := nY := nfor := 0

	Local lConsVenc := GetMV('MV_LOTVENC')=='S'

	Local cReport	:= "RELATÓRIO DE INCONSISTÊNCIAS " + CRLF + CRLF
	Local lReport	:= .F.

	Local _cDe		:= GetMv("MV_WFMAIL")
	Local _cConta	:= GetMv("MV_WFACC")
	Local _cSenha	:= GetMv("MV_WFPASSW")
	Local _cPara	:= GetMv("MV_WFWMS60")
	Local _cCc		:= ""
	Local _cCco		:= ""
	Local _cAssunto	:= ""
	Local _cAnexos  := ""
	Local _lAvisa 	:= .F.

	Private	lMsErroAuto := .F.

	oRet:SITUACAO := .t.
	oRet:MENSAGEM := ""

	if empty(oDados:cEmpresa)
		oDados:cEmpresa := "01"
		oDados:cParFil  := "01"
	endif

	//se não foi configurado WS para ja vir logado na empresa e filial, faço criação do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U'
		RpcSetType(3)
		lConect := RpcSetEnv(Fil_TpProd:cEmpresa, Fil_TpProd:cFilial)
		if !lConect
			cMsgErr := "Não foi possível conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif

	if lOk .AND. empty(oDados:TIPO_MOV)
		cMsgErr := "Informe o tipo de movimentação desejada." + CRLF + "(M)-Movimento interno ou (I)-Inventário"
		lOk := .F.

	elseif lOk .AND. !(oDados:TIPO_MOV $ ";M;I;")
		cMsgErr := "Informe o tipo de movimentação correto." + CRLF + "(M)-Movimento interno ou (I)-Inventário"
		lOk := .F.
	else
		cTipoMov  := oDados:TIPO_MOV
	endif

	if lOk .AND. cTipoMov == "M" .AND. !empty(oDados:NUM_OP)
		if empty(Posicione("SC2",1,xFilial("SC2")+alltrim(oDados:NUM_OP),"C2_NUM"))
			cMsgErr := "OP informada não foi localizada."
			lOk := .F.
		elseif !empty(SC2->C2_DATRF)
			cMsgErr := "OP informada ja foi encerrada. Ação não permitida."
			lOk := .F.
		endif
	endif

	if lOk .AND. cTipoMov == "M" .AND. !empty(oDados:CC)
		if empty(Posicione("CTT",1,xFilial("CTT")+alltrim(oDados:CC),"CTT_CUSTO"))
			cMsgErr := "Centro de Custo informado não foi localizado."
			lOk := .F.
		elseif alltrim(CTT->CTT_BLOQ) == "1"
			cMsgErr := "Centro de Custo bloqueado. Ação não permitida."
			lOk := .F.
		endif
	endif

	if lOk
		for nX := 1 to len(oDados:PRODUTOS)
			cMsgErr := VldProdutos(oDados:PRODUTOS[nX], nX)
			if !empty(cMsgErr)
				lOk := .F.
				exit
			endif
		next nX
	endif

	If cTipoMov == "I"
		_cAssunto := "Inventário -> Workflow de Inconsistências " + DTOC(Date())
	Else
		_cAssunto := "Movimento Interno -> Workflow de Inconsistências " + DTOC(Date())
	EndIf

	//se tudo ok, faz execautos
	if lOK

		BeginTran()

		dbSelectArea("SD3")
		if cTipoMov == "I"
			cDocumento  := "INVEN" + SubStr(DtoS(dDataBase),3)
		else
			cDocumento	:= IIf(Empty(cDocumento),NextNumero("SD3",2,"D3_DOC",.T.),cDocumento)
			cDocumento	:= A261RetINV(cDocumento)
		endif

		//Tratamento do sequencial para a codificação do documento do inventário
		//INV + MM + DD + Seq
		//INV   04   26   01
		cSeq := "00"
		if cTipoMov == "I"
			dbSelectArea("SD3")
			dbSetOrder(2)
			dbSeek(XFilial("SD3")+"INV" + Right(DtoS(dDataBase),4))
			do while SD3->( !Eof()  .and. D3_FILIAL = XFilial("SD3") .and. Left(D3_DOC,7) = "INV" + Right(DtoS(dDataBase),4) )
				cSeq := Right(SD3->D3_DOC,2)
				SD3->(dbSkip())
			enddo
		endif

		for nX := 1 to len(oDados:PRODUTOS)
			aMovs 		:= {}
			nQuant    	:= oDados:PRODUTOS[nX]:QTD_DIF
			cCodProd 	:= PadR(oDados:PRODUTOS[nX]:CODIGO,TamSx3("B1_COD")[1])
			cUM         := Posicione("SB1", 1, XFilial("SB1")+cCodProd, "B1_UM")
			cArmazem 	:= PadR(oDados:PRODUTOS[nX]:ARMAZEM,2)
			cLoteCTL    := PadR(oDados:PRODUTOS[nX]:LOTE,TamSx3("B8_LOTECTL")[1])
			cEndereco   := PadR(oDados:PRODUTOS[nX]:ENDERECO,TamSx3("B7_LOCALIZ")[1])
			cMsgPrd 	:= "Produto/Sequência ("+AllTrim(cCodProd)+"/"+StrZero(nX,4)+"), "

			//-- Marcos Natã | 22-12-2017
			//--------------------------------------------------------------------------------//
			//-- Pré-Validação: Se não passar na pré-validação pula para o próximo registro --//
			//--------------------------------------------------------------------------------//
			If !PreValid(cCodProd,cArmazem,cLoteCTL,cEndereco,@cReport)
				lOk 	:= .T.
				lReport := .T.
				Loop
			EndIf

			cSeq := Soma1(cSeq)

			if nQuant == 0
				loop

			elseif cTipoMov == "M"
				cOperacao   := "R"
				cCodTM      := SuperGetMV("MV_XWMSMVR", .f., "999") //514

			elseif nQuant < 0
				cOperacao   := "R"
				cCodTM      := SuperGetMV("MV_XWMSIVR", .f., "999") //113
				cDocumento  += "R"
			else
				cOperacao   := "D"
				cCodTM      := SuperGetMV("MV_XWMSIVD", .f., "499") //513
				cDocumento  += "D"
			endif

			ExpA1 := {}
			ExpN2 := 3
			cNumDoc := ""
			aadd(ExpA1,{"D3_TM",cCodTM,})
			if cTipoMov == "I"
				cNumDoc := "INV" + Right(DtoS(dDataBase),4) + cSeq
				aadd(ExpA1,{"D3_DOC",cNumDoc ,})
			endif
			aadd(ExpA1,{"D3_COD",cCodProd,})
			aadd(ExpA1,{"D3_UM",cUM,})
			aadd(ExpA1,{"D3_CC",oDados:CC,})
			aadd(ExpA1,{"D3_LOCAL",cArmazem,})
			aadd(ExpA1,{"D3_LOTECTL",cLoteCTL,})
			aadd(ExpA1,{"D3_LOCALIZ",cEndereco,})
			aadd(ExpA1,{"D3_QUANT",ABS(nQuant),})
			aadd(ExpA1,{"D3_EMISSAO",dDataBase,})
			aadd(ExpA1,{"D3_OBS",Pad(oDados:PRODUTOS[nX]:OBSERVACAO,TamSX3("D3_OBS")[1]),})

			MSExecAuto({|x,y| mata240(x,y)},ExpA1,ExpN2)

			if lMsErroAuto
				cMsgErr := MostraErro("\temp")
				cMsgErr := StrTran(cMsgErr, "<","|")
				cMsgErr := StrTran(cMsgErr, ">","|")

				cMsgErr := "Err. "+Iif(cTipoMov == "I","Inv.","Mov.")+" Produto:"+cCodProd+", Lote:"+cLoteCTL+", End:"+cEndereco

				lOk := .F.
				DisarmTransaction()
				exit
			elseif cTipoMov == "I" .and. !empty(cNumDoc) .and. cCodTM == SuperGetMV("MV_XWMSIVD", .f., "499")
				//Se for uma devolução, o sistema colocará o produto à endereçar, portanto, iremos automatizar o processo
				//de endereçamento pelo execauto

				cNumSeq :=  SD3->D3_NUMSEQ //U_USeqSDA(cCodProd, cArmazem, cLoteCTL)

				//Cabeçalho com a informação do item e NumSeq que sera endereçado.
				aCabSDA := {{"DA_PRODUTO" , cCodProd	,Nil},;
				{"DA_NUMSEQ"  , cNumSeq		,Nil}}

				if lOk .AND. Posicione("SDA", 1, xFilial("SDA")+cCodProd+cArmazem+cNumSeq, "DA_SALDO") <= 0
					cMsgErr := "Não existe saldo a endereçar na Sequencia ("+cNumSeq+")."
					lOk := .F.
					exit
				endif

				if lOk
					//achando sequencia inicial
					cSeq := StrZero(0,TamSX3("DB_ITEM")[1])
					DbSelectArea("SDB")
					SDB->(DbSetOrder(1))
					SDB->(DbSeek(SDA->(DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA)))
					do while SDB->(!Eof()) .AND. SDB->(DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA) == SDA->(DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA)
						cSeq := SDB->DB_ITEM

						SDB->(DbSkip())
					enddo

					cSeq := soma1(cSeq)
					_aItensSDB := {}

					//Dados do item que será endereçado
					aItSDB := {{"DB_ITEM"	  ,cSeq			,Nil},;
					{"DB_ESTORNO"  ," "	      	,Nil},;
					{"DB_LOCALIZ"  ,cEndereco    ,Nil},;
					{"DB_DATA"	  ,dDataBase    ,Nil},;
					{"DB_QUANT"    ,nQuant  		,Nil}}

					aadd(_aItensSDB, aClone(aitSDB) )

					//Executa o endereçamento do item
					MSExecAuto({|x,y,z| mata265(x,y,z)},aCabSDA,_aItensSDB,3)

					if lMsErroAuto
						cMsgErr := MostraErro("\temp")
						cMsgErr := StrTran(cMsgErr, "<","|")
						cMsgErr := StrTran(cMsgErr, ">","|")
						cMsgErr := "Err. Ender., Seq:"+cNumSeq+" (Prod:"+cCodProd+", Lote:"+cLoteCTL+", End:"+cEndereco+")"
						lOk := .F.
						DisarmTransaction()
						exit
					endif
				endif
			endif

		next nX

		//----------------------------------------------//
		//-- Se houver inconsistências envia workflow --//
		//----------------------------------------------//
		If lReport
			U_EnvEmail(_cDe,_cConta,_cSenha,_cPara,_cCc,_cCco,_cAssunto,cReport,_cAnexos,_lAvisa)
		EndIf

		if lOk
			EndTran()

			If cTipoMov == "I"
				If lReport
					cMsgErr := "Inventário realizado com inconsistências! Verificar itens no workflow!."
				Else
					cMsgErr := "Inventário realizado com sucesso!."
				EndIf
			Else
				If lReport
					cMsgErr := "Movimento interno realizado com inconsistências! Verificar itens no workflow!."
				Else
					cMsgErr := "Movimento interno realizado com sucesso!."
				EndIf
			EndIf
		endif

	endif

	oRet:SITUACAO := lOK
	oRet:MENSAGEM := cMsgErr

Return(.t.)

Static Function VldProdutos(oProduto, nSeq)

	Local cMsgErr 	:= ""
	Local cSeq 		:= "Seq.Prod.: " + cValToChar(nSeq)
	Local nQtdSoma 	:= 0
	Local cArmazem 	:= PadR(oProduto:ARMAZEM,TamSx3("BF_LOCAL")[1])
	Local cEndereco := PadR(oProduto:ENDERECO,TamSx3("BF_LOCALIZA")[1])
	Local nX

	if empty(oProduto:CODIGO)
		cMsgErr := "Informe o codigo do Produto." + cSeq
	elseif empty(Posicione("SB1",1,xFilial("SB1")+alltrim(oProduto:CODIGO),"B1_COD"))
		cMsgErr := "O Produto " + oProduto:CODIGO + " informado nao está cadastrado." + cSeq
	elseif empty(cArmazem)
		cMsgErr := "Informe o Armazem."
	elseif empty(oProduto:LOTE)
		cMsgErr := "Informe o Lote do produto." + cSeq
	elseif empty(Posicione("SB8",3,xFilial("SB8")+PadR(oProduto:CODIGO,TamSx3("B1_COD")[1])+cArmazem+PadR(oProduto:LOTE,TamSx3("B8_LOTECTL")[1]),"B8_LOTECTL"))
		cMsgErr := "O Lote " + oProduto:LOTE + " informado nao está cadastrado no armazém "+cArmazem+"." + cSeq
	elseif empty(alltrim(cEndereco))
		cMsgErr := "Informe o codigo do endereco, " + cSeq
	elseif empty(Posicione("SBE",1,xFilial("SBE")+cArmazem+cEndereco,"BE_LOCALIZ"))
		cMsgErr := "O Endereço " + AllTrim(cEndereco) + " informado nao está cadastrado, " + cSeq
	elseif SBE->BE_MSBLQL == '1'
		cMsgErr	+= "O Endereço (" + AllTrim(cEndereco) + ") está bloqueado."
		//elseif empty(oProduto:OPERACAO)
		//	cMsgErr := "Informe a operação (Devolução ou Requisição) à realizar para o produto." + cSeq
		//elseif !( oProduto:OPERACAO $ ";D;R;" )
		//	cMsgErr := "Código de operação errada, utilize (Devolução ou Requisição)." + cSeq
	elseif empty(oProduto:QTD_DIF)
		cMsgErr := "Informe a quantidade total para o produto " + oProduto:CODIGO + "." + cSeq
	endif

Return cMsgErr

Static function ValDef(xValor, cTipo)

	Default xValor 	:= ""
	Default cTipo 	:= "C"

	if valtype(xValor) <> cTipo
		if cTipo == "N"
			xValor := 0
		elseif cTipo == "L"
			xValor := .F.
		endif
	endif

Return xValor

Static Function PreValid(cCodProd,cArmazem,cLoteCTL,cEndereco,cReport)
	Local lOK 		:= .T.
	Local cBlqProd	:= ""
	Local nBlqLote	:= 0
	Local dVldLote	:= STOD(Space(8))
	Local cBlqEnd	:= ""
	Local aAreaSBE	:= {}
	
	cBlqProd	:= Posicione("SB1",1/*B1_FILIAL+B1_COD*/,xFilial("SB1")+cCodProd,"B1_MSBLQL")
	nBlqLote	:= Posicione("SDD",4/*DD_FILIAL+DD_PRODUTO+DD_LOCAL+DD_LOTECTL*/,xFilial("SDD")+cCodProd+cArmazem+cLoteCTL,"DD_SALDO")
	dVldLote	:= Posicione("SB8",6/*B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL*/,xFilial("SB8")+cCodProd+cArmazem+cLoteCTL,"B8_DTVALID")
	cBlqEnd		:= Posicione("SBE",1/*BE_FILIAL+BE_CODPRO+BE_LOCAL+BE_LOCALIZ*/,xFilial("SBE")+cCodProd+cArmazem+cEndereco,"BE_MSBLQL")

	If cBlqProd = "1"
		cReport += AllTrim(cCodProd) + "-" + AllTrim(Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC"));
		 + "/" + AllTrim(cLoteCTL) + "/" + AllTrim(cEndereco) + " -> PRODUTO BLOQUEADO PARA USO" + CRLF
		lOK 	:= .F.
	EndIf

	If nBlqLote > 0
		cReport += AllTrim(cCodProd) + "-" + AllTrim(Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC"));
		 + "/" + AllTrim(cLoteCTL) + "/" + AllTrim(cEndereco) + " -> LOTE BLOQUEADO" + CRLF
		lOK 	:= .F.
	EndIf

	If dVldLote < Date()
		cReport += AllTrim(cCodProd) + "-" + AllTrim(Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC"));
		 + "/" + AllTrim(cLoteCTL) + "/" + AllTrim(cEndereco) + " -> LOTE VENCIDO" + CRLF
		lOK 	:= .F.
	EndIf

	If cBlqEnd = "1"
		cReport += AllTrim(cCodProd) + "-" + AllTrim(Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC"));
		 + "/" + AllTrim(cLoteCTL) + "/" + AllTrim(cEndereco) + " -> ENDEREÇO BLOQUEADO" + CRLF
		lOK 	:= .F.
	EndIf

	aAreaSBE 	:= SBE->(GetArea())
	SBE->(DbSetOrder(9)) //-- BE_FILIAL+BE_LOCALIZ
	If !SBE->(DbSeek(xFilial("SBE")+cEndereco))
		cReport += AllTrim(cCodProd) + "-" + AllTrim(Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC"));
		 + "/" + AllTrim(cLoteCTL) + "/" + AllTrim(cEndereco) + " -> ENDEREÇO INVÁLIDO" + CRLF
		lOK 	:= .F.
	EndIf
	RestArea(aAreaSBE)
	
Return lOK
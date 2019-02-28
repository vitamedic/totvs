#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUWSWMS05  บAutor  ณMicrosiga           บ Data ณ  19/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMetodo WS para processamento do Endere็amento               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UWSWMS50(oDados, oRet)
	
	Local nQtdProc    := 0
	Local lOk 			:= .T.
	Local cMsgErr 		:= ""
	Local cProduto 		:= ""
	Local cArmazem 		:= ""
	Local cArmCQ    	:= GetMv("MV_CQ")
	Local cArmPad       := ""
	Local cTipo         := ""
	Local cLote	   		:= ""
	Local cNumSeq		:= ""
	Local nSaldo        := 0
	Local aCabSDA    	:= {}
	Local aItSDB     	:= {}
	Local _aItensSDB 	:= {}
	Local cSeq			:= ""
	Local nRecSDA		:= 0

	Private	lMsErroAuto := .F.

	oRet:SITUACAO := .t.
	oRet:MENSAGEM := ""

	if empty(oDados:cEmpresa)
		oDados:cEmpresa := "01"
		oDados:cParFil  := "01"
	endif

	//se nใo foi configurado WS para ja vir logado na empresa e filial, fa็o cria็ใo do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U'
		RpcSetType(3)
		lConect := RpcSetEnv(Fil_TpProd:cEmpresa, Fil_TpProd:cFilial)
		if !lConect
			cMsgErr := "Nใo foi possํvel conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif

	if lOk .AND. empty(oDados:PRODUTO)
		cMsgErr := "Informe o Produto."
		lOk := .F.
	elseif lOK .AND. empty(Posicione("SB1",1,xFilial("SB1")+alltrim(oDados:PRODUTO),"B1_COD"))
		cMsgErr := "Produto informado nใo cadastrado."
		lOk := .F.
	else
		cProduto := PadR(oDados:PRODUTO,TamSx3("B1_COD")[1])
		cArmPad  := SB1->B1_LOCPAD
		cTipo    := SB1->B1_TIPO
	endif

	if lOk .AND. empty(oDados:ARMAZEM)
		cMsgErr := "Informe o Armazem."
		lOk := .F.
	else
		cArmazem := PadR(oDados:ARMAZEM,2)
	endif

	//B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
	if lOk .AND. empty(oDados:LOTE)
		cMsgErr := "Informe o Lote."
		lOk := .F.
	else
		cLote := PadR(oDados:LOTE,TamSx3("B8_LOTECTL")[1])
	endif

	/*
	if lOK
	cChave := xFilial("SB8")+cProduto+cArmazem+PadR(oDados:LOTE, TamSx3("B8_LOTECTL")[1])

	dbSelectArea("SB8")
	dbSetOrder (3)
	//B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
	if !dbSeek(cChave)
	cMsgErr := "Lote informado nใo cadastrado."
	lOk := .F.
	else
	cLote := PadR(oDados:LOTE,TamSx3("B8_LOTECTL")[1])
	endif
	endif
	*/

	if lOK
		For nX := 1 to len(oDados:ENDERECOS)
			cMsgErr := VldEnderecos(oDados:ENDERECOS[nX], nX, cArmazem, @nQtdProc)
			if !empty(cMsgErr)
				lOk := .F.
				exit
			endif
		next nX
	endif
	
	nQatu := nQtdProc

		cNumSeq := U_USeqSDA(cProduto, cArmazem, cLote, @nSaldo,cTipo,,,,@nRecSDA,cTipo,nQtdProc)

	if (nSaldo == 0 .or. nSaldo < nQtdProc).and. cArmazem == cArmPad .and. cTipo $ "PA/MP/EN/ED" //ALTERADO PARA O PROCESSO DO AMOST RETIRANDO DO PISO.
		cArmazem := cArmCQ
		cNumSeq  := U_USeqSDA(cProduto, cArmazem, cLote, @nSaldo,,,,,@nRecSDA,cTipo,nQtdProc)
	endif
	
	//posiciono na SDA e verificso se estแ realmente a endere็ar
	if lOk .AND. nSaldo <= 0
		cMsgErr := "Nใo existe saldo a endere็ar na Sequencia ("+cNumSeq+")."
		lOk := .F.
	endif

	if lOK .and. nQtdProc > nSaldo
		cMsgErr := "Quantidade total informada ้ superior ao saldo a endere็ar."
		lOk := .F.
	endif

	//se tudo ok, faz execautos
	if lOK

		SDA->(DbGoTo(nRecSDA))

		//Cabe็alho com a informa็ใo do item e NumSeq que sera endere็ado.
		aCabSDA := {{"DA_PRODUTO" , cProduto	,Nil},;
		{"DA_NUMSEQ"  , cNumSeq		,Nil}}

		//achando sequencia inicial
		cSeq := StrZero(0,TamSX3("DB_ITEM")[1])
		DbSelectArea("SDB")
		SDB->(DbSetOrder(1))
		SDB->(DbSeek(SDA->(DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA)))
		while SDB->(!Eof()) .AND. SDB->(DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA) == SDA->(DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA)

			cSeq := SDB->DB_ITEM

			SDB->(DbSkip())
		enddo

		BeginTran()

		For nX := 1 to len(oDados:ENDERECOS)
			cSeq := soma1(cSeq)
			_aItensSDB := {}

			//Dados do item que serแ endere็ado
			aItSDB := {{"DB_ITEM"	  ,cSeq								,Nil},;
			{"DB_ESTORNO"  ," "	      						,Nil},;
			{"DB_LOCALIZ"  ,oDados:ENDERECOS[nX]:CODIGO    	,Nil},;
			{"DB_NUMSERI"  ,Space(TamSX3("DB_NUMSERI")[1])   ,Nil},;
			{"DB_DATA"	  ,dDataBase    					,Nil},;
			{"DB_QUANT"    ,oDados:ENDERECOS[nX]:QUANTIDADE  ,Nil}}

			aadd(_aItensSDB, aClone(aItSDB) )

			//Executa o endere็amento do item
			//MATA265( aCabSDA, _aItensSDB, 3)
			MSExecAuto({|x,y,z| mata265(x,y,z)},aCabSDA,_aItensSDB,3)

			If lMsErroAuto
				cMsgErr := MostraErro("\temp")
				cMsgErr := StrTran(cMsgErr, "<","|")
				cMsgErr := StrTran(cMsgErr, ">","|")
				lOk := .F.
				DisarmTransaction()
				exit
			Endif

		next nX

		if lOk
			EndTran()
			cMsgErr := "Saldo endere็ado com sucesso."
		endif

		SDA->(MSUnlockAll())
		SDB->(MSUnlockAll())

	endif

	oRet:SITUACAO := lOK
	oRet:MENSAGEM := cMsgErr
Return(.t.)


Static Function VldEnderecos(oEndereco, nSeq, cArmazem, nQtdProc)

	Local cMsgErr 	:= ""
	Local cSeq 		:= "Seq.: " + cValToChar(nSeq)
	Local cBlq 		:= ""

	if empty(oEndereco:CODIGO)
		cMsgErr := "Informe o codigo do endereco." + cSeq
	elseif empty( cBlq := Posicione("SBE",1,xFilial("SBE")+cArmazem+Pad(oEndereco:CODIGO, TamSX3("BE_LOCALIZ")[1]),"BE_LOCALIZ") )
		cMsgErr := "O Endere็o " + oEndereco:CODIGO + " informado nao estแ cadastrado no armaz้m ("+cArmazem+")." + cSeq
	elseif /*cBlq == "1"*/ SBE->BE_MSBLQL == "1"
		cMsgErr := "Endere็o bloqueado " + oEndereco:CODIGO + "." + cSeq
	elseif empty(oEndereco:QUANTIDADE)
		cMsgErr := "Informe a quantidade para o endere็o " + oEndereco:CODIGO + "." + cSeq
	else
		nQtdProc += oEndereco:QUANTIDADE
	endif

Return cMsgErr

User Function USeqSDA(cProduto, cArmazem, cLote, nSaldo, cDoc, cSerie, cCliFor, cLoja, nRecSDA, cTipo,nQtdProc)
	Local  aArea   := GetArea()
	Local  cNumSeq := ""
	Local  cQry    := ""
	Local  c2Num  := ""

	Default nSaldo	:= 0
	Default cDoc   	:= Space(TamSX3("DA_DOC")[1])
	Default cSerie 	:= Space(TamSX3("DA_SERIE")[1])
	Default cCliFor := Space(TamSX3("DA_CLIFOR")[1])
	Default cLoja   := Space(TamSX3("DA_LOJA")[1])
	Default nRecSDA := 0

	c2Num := POSICIONE("SC2", 12, xFilial("SC2") + cProduto + cLote, "C2_NUM")

	cQry := "        SELECT * "
	cQry += CRLF + " FROM " + RetSqlName("SDA") + ""
	cQry += CRLF + " WHERE D_E_L_E_T_  <> '*'"
	cQry += CRLF + "   AND DA_FILIAL   = '"+xFilial("SDA")+"'"
	cQry += CRLF + "   AND DA_PRODUTO  = '"+cProduto+"'"
	cQry += CRLF + "   AND DA_LOCAL    = '"+cArmazem+"'"
	cQry += CRLF + "   AND DA_LOTECTL  = '"+cLote+"'"
	cQry += CRLF + "   AND DA_SALDO > 0 "
	If ctipo = "PA" .AND. !Empty(c2Num)
		cQry += CRLF + "   AND DA_SALDO = '"+cValtochar(nQtdProc)+"' "
	EndIf
	TCQuery cQry New Alias "QSEQ"
	MemoWrite("c:/stephen/wms50.sql",cQry)
	If QSEQ->(!Eof())
		cNumSeq := QSEQ->DA_NUMSEQ
		//	nSaldo  := QSEQ->DA_SALDO  Stephen Noel
		cDoc    := QSEQ->DA_DOC
		cSerie  := QSEQ->DA_SERIE
		cCliFor := QSEQ->DA_CLIFOR
		cLoja   := QSEQ->DA_LOJA
		nRecSDA := QSEQ->R_E_C_N_O_
	EndIf
//Stephen Noel 
	QSEQ->(DbGoTop())
	While QSEQ->(!Eof())
		nSaldo := QSEQ->DA_SALDO + nSaldo
		QSEQ->(dbSkip())
	End
//Fim Stephen Noel	
	QSEQ->(dbCloseArea())
	RestArea(aArea)

Return(cNumSeq)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUWSWMS05  บAutor  ณStephen Noel de M. R. Data ณ  25/10/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para bucar o Nunseq. da SDA para valida็ใo do fonte บฑฑ
ฑฑบ          ณ UWSWMS52 Solicitado Por Marcio David                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function USeqTR(cProduto, cArmazem, cLote, nSaldo, cDoc, cSerie, cCliFor, cLoja, nRecSDA)
	Local  aArea   := GetArea()
	Local  cNumSeq := ""
	Local  cQry    := ""

	Default nSaldo	:= 0
	Default cDoc   	:= Space(TamSX3("DA_DOC")[1])
	Default cSerie 	:= Space(TamSX3("DA_SERIE")[1])
	Default cCliFor := Space(TamSX3("DA_CLIFOR")[1])
	Default cLoja   := Space(TamSX3("DA_LOJA")[1])
	Default nRecSDA := 0

	cQry := "        SELECT * "
	cQry += CRLF + " FROM " + RetSqlName("SDA") + ""
	cQry += CRLF + " WHERE D_E_L_E_T_  <> '*'"
	cQry += CRLF + "   AND DA_FILIAL   = '"+xFilial("SDA")+"'"
	cQry += CRLF + "   AND DA_PRODUTO  = '"+cProduto+"'"
	cQry += CRLF + "   AND DA_LOCAL    = '"+cArmazem+"'"
	cQry += CRLF + "   AND DA_LOTECTL  = '"+cLote+"'"

	TCQuery cQry New Alias "QSEQTR"

	If QSEQTR->(!Eof())
		cNumSeq := QSEQTR->DA_NUMSEQ
		nSaldo  := QSEQTR->DA_SALDO
		cDoc    := QSEQTR->DA_DOC
		cSerie  := QSEQTR->DA_SERIE
		cCliFor := QSEQTR->DA_CLIFOR
		cLoja   := QSEQTR->DA_LOJA
		nRecSDA := QSEQTR->R_E_C_N_O_
	EndIf
	
	QSEQTR->(dbCloseArea())
	RestArea(aArea)

Return(cNumSeq)
#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UWSWMS52 ºAutor  ³Microsiga           º Data ³  19/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Metodo WS para processamento de Transferências de Estoque  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UWSWMS52(oDados, oRet)

	Local lOk        := .T.
	Local cMsgErr 	 := ""
	Local nQtdProc	 := 0 
	Local cProduto 	 := ""
	Local cDescProd  := ""
	Local cUM        := ""
	Local cArmCQ 	 := GetMV("MV_CQ")
	Local cArmazOri	 := ""
	Local cArmazDst	 := ""
	Local cLocPadB1  := ""
	Local cLote 	 := ""
	Local cLoteOri 	 := ""
	Local cLoteDst 	 := ""                                 
	Local cNumSeq	 := ""
	Local cEndOrigem := ""
	Local cEndDestino := ""
	Local cBlqOri    := ""
	Local cBlqDst    := ""
	Local dDataVl	 := CtoD("")
	Local aCab    	 := {}
	Local aItem      := {}
	Local cSeq		 := ""
	Local nOpcAuto	 := 3 // Indica qual tipo de ação será tomada (Inclusão/Exclusão)
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

	if lOk .AND. empty(oDados:PRODUTO)
		cMsgErr := "Informe o Produto."
		lOk := .F.
	elseif lOK .AND. empty( Posicione("SB1",1,xFilial("SB1")+PadR(oDados:PRODUTO,TamSx3("B1_COD")[1]),"B1_COD") )	
		cMsgErr := "Produto informado não cadastrado."
		lOk := .F.
	else
		cProduto 	:= PadR(oDados:PRODUTO,TamSx3("B1_COD")[1])
		cDescProd 	:= SB1->B1_DESC
		cUM      	:= SB1->B1_UM
	endif

	if lOk .AND. empty(oDados:ARMAZEMORI)
		cMsgErr := "Informe o Armazém de Origem."
		lOk := .F.
	else
		cArmazOri := PadR(oDados:ARMAZEMORI,2)
	endif

	if lOk .AND. empty(oDados:ARMAZEMDST)
		cMsgErr := "Informe o Armazém de Destino."
		lOk := .F.
	else
		cArmazDst := PadR(oDados:ARMAZEMDST,2)
	endif

	if cArmazOri == cArmCQ .and. cArmazDst <> cArmCQ
		cArmazDst := cArmCQ

		//	cMsgErr := "Movimentação dentro do CQ exige que origem e destino seja o próprio CQ."
		//	lOk := .F.
		//elseif cArmazDst == cArmCQ .and. cArmazOri <> cArmCQ 
		//		cMsgErr := "Movimentação dentro do CQ exige que origem e destino seja o próprio CQ."
		//		lOk := .F.

	endif

	if lOk .AND. empty(oDados:LOTE)
		cMsgErr := "Informe o Lote."
		lOk := .F.
	else
		cLote := PadR(AllTrim(oDados:LOTE),TamSx3("B8_LOTECTL")[1])		
	endif

	if lOk .AND. empty(oDados:LOTE)
		cMsgErr := "Informe o Lote."
		lOk := .F.
	elseif lOK .AND. empty(Posicione("SB8",3,xFilial("SB8")+cProduto+cArmazOri+alltrim(oDados:LOTE),"B8_LOTECTL"))
		cMsgErr := "Lote informado não tem no armazém de origem informado."
		lOk := .F.
	endif 

	if lOk .AND. empty(oDados:ENDERECORI)
		cMsgErr := "Informe o Endereço de Origem."
		lOk := .F.
	elseif lOK .AND. empty( cBlqOri := Posicione("SBE",1,xFilial("SBE")+cArmazOri+alltrim(oDados:ENDERECORI),"BE_MSBLQL") )
		cMsgErr := "O Endereço " + oDados:ENDERECORI + " informado nao está cadastrado."
		lOk := .F.
	elseif cBlqOri == "1"
		cMsgErr := "Endereço de origem bloqueado (" + oDados:ENDERECORI + ")." + cSeq
		lOk := .F.
	else
		cEndOrigem := PadR(oDados:ENDERECORI, TamSx3("BF_LOCALIZ")[1]) 
	endIf

	if lOk .AND. empty(oDados:ENDERECDST)
		cMsgErr := "Informe o Destino de Destino."
		lOk := .F.
	elseif lOK .AND. empty( cBlqDst := Posicione("SBE",1,xFilial("SBE")+cArmazDst+alltrim(oDados:ENDERECDST),"BE_MSBLQL") )
		cMsgErr := "O Endereço " + oDados:ENDERECDST + " informado nao está cadastrado."
		lOk := .F.
	elseif cBlqDst == "1"
		cMsgErr := "Endereço de destino bloqueado (" + oDados:ENDERECDST + ")." + cSeq
		lOk := .F.
	else
		cEndDestino := PadR(oDados:ENDERECDST, TamSx3("BF_LOCALIZ")[1])		
	endif

	if lOk .AND. empty(oDados:QUANT)
		cMsgErr := "Informe a Quantidade à ser transferida."
		lOk := .F.
	endif

	DbSelectArea("SD5")
	DbSetOrder(2)
	If !SD5->(MsSeek(xFilial("SD5")+cProduto+cArmazOri+cLote ))	
		lOk := .F.	
		ConOut(OemToAnsi("Cadastrar lote: " + cLote ))
	Else	        
		dDataVl	:= SD5->D5_DTVALID        
	EndIf

	//se tudo ok, faz execautos
	if lOK

		BeginTran()  

		if cArmazOri == cArmCQ
//			if empty( cNumSeq := U_USeqSDA(cProduto, cArmCQ, cLote) ) //Alteração solicitada Pelo Marcio David 25/10/2018
			if empty( cNumSeq := U_USeqTR(cProduto, cArmCQ, cLote) )
				lOk 	:= .f.
				cMsgErr := "Numeração Sequencial de controle do CQ não encontrado para transferência."
			endif

			if lOk .AND. !( lOk := TrocaCQ() )
				cMsgErr := "Erro ao tentar reservar o parâmetro MV_CQ."
			endif
		endif

		//if lOk .and. (cEndOrigem <> "DOWNED" .and. cEndDestino <> "DOWNED")
		if lOk 
			cDoc := GetSxENum("SD3","D3_DOC",1)		
			aCab  := {}		
			aItem := {}

			//Cabecalho a Incluir 
			aadd(aCab,{cDoc,dDataBase}) //Cabecalho

			//aadd(aItem,{"ITEM"			,'001',Nil}) 
			aadd(aItem,{"D3_COD"		, padr(cProduto,tamsx3("D3_COD")[1]), Nil}) //cod produto origem 
			aadd(aItem,{"D3_DESCRI"		, padr(cDescProd,tamsx3("D3_DESCRI")[1]), Nil}) //descr produto origem 
			aadd(aItem,{"D3_UM"			, padr(cUM,tamsx3("D3_UM")[1]), Nil}) //unidade medida origem 
			aadd(aItem,{"D3_LOCAL"		, padr(cArmazOri,tamsx3("D3_LOCAL")[1]), Nil}) //armazem origem 
			aadd(aItem,{"D3_LOCALIZ"	, padr(cEndOrigem,tamsx3("D3_LOCALIZ")[1]), Nil}) //endereço origem

			aadd(aItem,{"D3_COD"		, padr(cProduto,tamsx3("D3_COD")[1]), Nil}) //cod produto destino 
			aadd(aItem,{"D3_DESCRI"		, padr(cDescProd,tamsx3("D3_DESCRI")[1]), Nil}) //descr produto destino 
			aadd(aItem,{"D3_UM"			, padr(cUM,tamsx3("D3_UM")[1]), Nil}) //unidade medida destino 
			aadd(aItem,{"D3_LOCAL"		, padr(cArmazDst,tamsx3("D3_LOCAL")[1]), Nil}) //armazem destino 
			aadd(aItem,{"D3_LOCALIZ"	, padr(cEndDestino,tamsx3("D3_LOCALIZ")[1]), Nil}) //endereço destino

			aadd(aItem,{"D3_NUMSERI"	, "", Nil}) //Numero serie

			aadd(aItem,{"D3_LOTECTL"	, padr(cLote,tamsx3("D3_LOTECTL")[1]), Nil}) //Lote Origem
			aadd(aItem,{"D3_NUMLOTE"	, "", Nil}) //sublote origem
			aadd(aItem,{"D3_DTVALID"	, dDataVl, Nil}) //data validade 

			aadd(aItem,{"D3_POTENCI"	, 0, Nil}) // Potencia
			aadd(aItem,{"D3_QUANT"		, oDados:QUANT, Nil}) //Quantidade
			aadd(aItem,{"D3_QTSEGUM"	, 0, Nil}) //Seg unidade medida
			aadd(aItem,{"D3_ESTORNO"	, "", Nil}) //Estorno 
			aadd(aItem,{"D3_NUMSEQ"		, "", Nil}) // Numero sequencia D3_NUMSEQ

			aadd(aItem,{"D3_LOTECTL"	, padr(cLote,tamsx3("D3_LOTECTL")[1]), Nil}) //Lote destino
			aadd(aItem,{"D3_NUMLOTE"	, "", Nil}) //sublote destino 
			aadd(aItem,{"D3_DTVALID"	, dDataVl, Nil}) //validade lote destino

			aadd(aItem,{"D3_ITEMGRD"	, "", Nil}) //Item Grade
			//aadd(aItem,{"D3_OBSERVA"	, "", Nil}) //Item Grade  

			aadd(aCab,aItem)

			for nX := 1 to len(aCab)
				if nx == 1
					for nY := 1 to len(aCab[nx])
						
						if nY == 1
							conout("[UWSWMS52] D3_COD - " + aCab[nx][nY]  )
						elseif nY == 2
							conout("[UWSWMS52] D3_DATA - " + dtoc(aCab[nx][nY])   )
						endIf
						
					next nY 
				else
					for nY := 1 to len(aCab[nx])

						if valtype(aCab[nx][nY][2]) == "C"
							conout("[UWSWMS52] " + aCab[nx][nY][1] + " - " + aCab[nx][nY][2] )
						elseIf valtype(aCab[nx][nY][2]) == "D"
							conout("[UWSWMS52] " + aCab[nx][nY][1] + " - " + dtoc(aCab[nx][nY][2]) )
						elseIf valtype(aCab[nx][nY][2]) == "N"
							conout("[UWSWMS52] " + aCab[nx][nY][1] + " - " + cValToChar( aCab[nx][nY][2]) )
						endIf
						 
					next nY
				endIf
			next nX

			//			aadd(aCab,{cDoc,dDataBase})  //Cabecalho		
			//			aadd(aItem,cProduto)			//D3_COD		
			//			aadd(aItem,cDescProd) 			//D3_DESCRI				
			//			aadd(aItem,cUM)  				//D3_UM		
			//			aadd(aItem,cArmazOri)  			//D3_LOCAL		
			//			aadd(aItem,cEndOrigem)			//D3_LOCALIZ		
			//			aadd(aItem,cProduto)  	   		//D3_COD		
			//			aadd(aItem,cDescProd)  			//D3_DESCRI				
			//			aadd(aItem,cUM)  				//D3_UM		
			//			aadd(aItem,cArmazDst)    		//D3_LOCAL		
			//			aadd(aItem,cEndDestino)			//D3_LOCALIZ		
			//			aadd(aItem,"")      			//D3_NUMSERI		
			//			aadd(aItem,cLote)				//D3_LOTECTL  		
			//			aadd(aItem,"")      			//D3_NUMLOTE		
			//			aadd(aItem,dDataVl)				//D3_DTVALID		
			//			aadd(aItem,0)					//D3_POTENCI		
			//			aadd(aItem,oDados:QUANT) 		//D3_QUANT		
			//			aadd(aItem,0 )					//D3_QTSEGUM		
			//			aadd(aItem,"")   				//D3_ESTORNO		
			//			aadd(aItem,''/*cNumSeq*/)    	//D3_NUMSEQ 		
			//			aadd(aItem,cLote)				//D3_LOTECTL		
			//			aadd(aItem,dDataVl)				//D3_DTVALID		
			//			aadd(aItem,"")					//D3_ITEMGRD						
			//			aadd(aItem,"")					//D3_OBSERVA - g.sampaio 12/06/2018
			//			aadd(aCab,aItem)	

			nModAux := nModulo

			nModulo := 10

			SD3->( MSExecAuto({|x,y| mata261(x,y)},aCab,nOpcAuto) )	

			if lMsErroAuto    
				cMsgErr := MostraErro("\temp")
				cMsgErr := StrTran(cMsgErr, "<","|")
				cMsgErr := StrTran(cMsgErr, ">","|")
				lOk := .F.

				if cArmazOri == cArmCQ
					if !( TrocaCQ() )
						cMsgErr += "Erro ao tentar reservar o parâmetro MV_CQ."
					endif
				endif

				DisarmTransaction()
			else
				if cArmazOri == cArmCQ
					if !( lOk := TrocaCQ() )
						cMsgErr += "Erro ao tentar reservar o parâmetro MV_CQ."
					endif
				endif    

				//se origem é B1_LOCPAD, e destino MV_CQ, transfere saldo restante do mesmo lote
				cLocPadB1 := Posicione("SB1", 1, xFilial("SB1")+cProduto, "B1_LOCPAD")
				if cLocPadB1 == cArmazOri .AND. cArmCQ == cArmazDst
					if !TransfLoteCQ(cProduto, cDescProd, cUM, cLote, cArmazOri, cArmazDst, dDataVl, @cMsgErr)
						cMsgErr += "Falha ao transferir saldo restante do lote para armazem destino."
						lOk := .F.
						DisarmTransaction()
					endif
				endif
			endif

			nModulo := nModAux

		else
			DisarmTransaction()
		endif

		if lOk
			EndTran()
			cMsgErr := "Saldo transferido com sucesso."
			conout("[UWSWMS52] D3_COD - " + SD3->D3_COD )
			conout("[UWSWMS52] D3_DOC - " + SD3->D3_DOC )
			conout("[UWSWMS52] D3_LOTECTL - " + SD3->D3_LOTECTL )
		endif

	endif

	oRet:SITUACAO := lOK
	oRet:MENSAGEM := cMsgErr

Return(.t.)


Static Function VldEnderecos(oEndereco, nSeq, cArmazem, nQtdProc)

	Local cMsgErr := ""
	Local cSeq := "Seq.: " + cValToChar(nSeq)

	if empty(oEndereco:CODIGO)
		cMsgErr := "Informe o codigo do endereco." + cSeq
	elseif empty(Posicione("SBE",1,xFilial("SBE")+cArmazem+alltrim(oEndereco:CODIGO),"BE_LOCALIZ"))
		cMsgErr := "O Endereço " + oEndereco:CODIGO + " informado nao está cadastrado." + cSeq
	elseif empty(oEndereco:QUANTIDADE)
		cMsgErr := "Informe a quantidade para o endereço " + oEndereco:CODIGO + "." + cSeq
	else
		nQtdProc += oEndereco:QUANTIDADE
	endif

Return cMsgErr

Static Function TrocaCQ()
	Local lOk 		:= .t.
	Local cArmCQ 	:= Iif(GetMV("MV_CQ") == "80", "98", "80")

	dbSelectArea("SX6")
	dbSetOrder(1)
	if !( dbSeek(XFilial("SX6")+"MV_XLOCKCQ") .and. RecLock("SX6", .f.) )
		lOk := .f.
	else
		SX6->X6_CONTEUD := Iif(cArmCQ == '98', 'B', 'L')
		SX6->X6_CONTSPA := Iif(cArmCQ == '98', 'B', 'L')
		SX6->X6_CONTENG := Iif(cArmCQ == '98', 'B', 'L')
		SX6->(MsUnLock())       
	endif

	if !( dbSeek(XFilial("SX6")+"MV_CQ") .and. RecLock("SX6", .f.) )
		lOk := .f.
	else
		SX6->X6_CONTEUD := cArmCQ
		SX6->X6_CONTSPA := cArmCQ
		SX6->X6_CONTENG := cArmCQ
		SX6->(MsUnLock())       
	endif

Return(lOk)

Static Function BuscaDoc()

	Local _cLocal	:= getarea()
	Local cCodSD3	:= ""
	Local cQry 		:= ""

	cQry := " SELECT MAX(D3_DOC) PROX "
	cQry += " FROM " + RetSqlName("SD3")
	cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"
	cQry += " AND D_E_L_E_T_ <> '*' "
	cQry += " AND D3_DOC LIKE 'TR%' "

	If Select("QAUX") > 0
		QAUX->(dbCloseArea())
	EndIf

	cQry := ChangeQuery(cQry)
	TcQuery cQry NEW Alias "QAUX" 

	If QAUX->(!Eof())
		If Empty(QAUX->PROX)
			cCodSD3 := "TR"+strzero(1, TamSX3("D3_DOC")[1]-2 )
		Else
			cCodSD3 := Soma1(QAUX->PROX)
		EndIf
	Else
		cCodSD3 := "TR"+strzero(1, TamSX3("D3_DOC")[1]-2 )
	EndIf

	If Select("QAUX") > 0
		QAUX->(dbCloseArea())
	EndIf

	restarea( _cLocal )

Return cCodSD3

Static Function TransfLoteCQ(cProduto, cDescProd, cUM, cLote, cArmazOri, cArmazDst, dDataVl, cMsgErr)

	Local lRet 		:= .T.
	Local aCab 		:= {} 
	Local aItem 	:= {}	
	Local nOpcAuto	:= 3 // Indica qual tipo de ação será tomada (Inclusão/Exclusão)
	Local cNumSeq	:= ""
	Local cDoc 		:= ""
	Local _cErro    := ""

	DbSelectArea("SBF")
	SBF->(DbSetOrder(2)) //BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI
	if SBF->(DbSeek(xFilial("SBF")+cProduto+cArmazOri+cLote))
		While SBF->(!Eof()) .AND. SBF->(BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL) == xFilial("SBF")+cProduto+cArmazOri+cLote
			if (SBF->BF_QUANT - SBF->BF_EMPENHO) > 0
				if !AutMata015(cArmazOri, cArmazDst, SBF->BF_LOCALIZ, @cMsgErr)
					lRet := .F.
					exit
				endif

				cDoc := GetSxENum("SD3","D3_DOC",1)		

				/*if empty( cNumSeq := U_USeqSDA(cProduto, cArmCQ, cLote) )
				lRet := .F.
				EXIT
				endif*/

				aCab := {}		
				aadd(aCab,{cDoc,dDataBase})  //Cabecalho 

				//Itens a Incluir				
				aItem := {}
				aadd(aItem,cProduto)			//D3_COD		
				aadd(aItem,cDescProd) 			//D3_DESCRI				
				aadd(aItem,cUM)  				//D3_UM		
				aadd(aItem,cArmazOri)  			//D3_LOCAL		
				aadd(aItem,SBF->BF_LOCALIZ)		//D3_LOCALIZ		
				aadd(aItem,cProduto)  	   		//D3_COD		
				aadd(aItem,cDescProd)  			//D3_DESCRI				
				aadd(aItem,cUM)  				//D3_UM		
				aadd(aItem,cArmazDst)    		//D3_LOCAL		
				aadd(aItem,SBF->BF_LOCALIZ)		//D3_LOCALIZ		
				aadd(aItem,"")      			//D3_NUMSERI		
				aadd(aItem,cLote)				//D3_LOTECTL  		
				aadd(aItem,"")      			//D3_NUMLOTE		
				aadd(aItem,dDataVl)				//D3_DTVALID		
				aadd(aItem,0)					//D3_POTENCI		
				aadd(aItem,(SBF->BF_QUANT - SBF->BF_EMPENHO)) //D3_QUANT		
				aadd(aItem,0)					//D3_QTSEGUM		
				aadd(aItem,"")   				//D3_ESTORNO		
				aadd(aItem,cNumSeq)    			//D3_NUMSEQ 		
				aadd(aItem,cLote)				//D3_LOTECTL		
				aadd(aItem,dDataVl)				//D3_DTVALID		
				aadd(aItem,"")					//D3_ITEMGRD						

				aadd(aCab,aItem) 

				MSExecAuto({|x,y| mata261(x,y)},aCab,nOpcAuto)	

				if lMsErroAuto
					_cErro 	:= MostraErro("\temp")
					_cErro 	:= AllTrim(_cErro)
					_cErro 	:= StrTran(_cErro, "<","|")
					_cErro 	:= StrTran(_cErro, ">","|")
					cMsgErr += AllTrim(_cErro)
					lRet 	:= .F.
					exit
				endif
			endif

			SBF->(DbSkip())
		enddo
	endif

Return lRet

Static Function AutMata015(pArmOri, pArmazem, pLocaliz, cMsgErr)
	Local aVetor	:= {}
	Local nOpc 		:= 0 
	Local lRet 		:= .t.                   
	Local cEndDst   := ""    
	Local _cErro    := ""

	Private lMsErroAuto := .F.  

	if ! empty(Posicione("SBE",1,xFilial("SBE")+pArmazem+alltrim(pLocaliz),"BE_LOCALIZ"))
		Return(.t.)
	elseif empty(cEndDst := Posicione("SBE",1,xFilial("SBE")+pArmOri+alltrim(pLocaliz),"BE_LOCALIZ"))
		cMsgErr += CRLF + "Endereço não cadastrado no armazém de orígem ( " + alltrim(pLocaliz) + " )."
		Return(.f.)
	endif

	aVetor := {	{"BE_LOCAL"  	,pArmazem		 	,Nil},;				
	{"BE_LOCALIZ"	,pLocaliz		 	,NIL},;				
	{"BE_DESCRIC"	,SBE->BE_DESCRIC 	,NIL},;				
	{"BE_CAPACID"	,SBE->BE_CAPACID 	,NIL},;				
	{"BE_PRIOR"		,SBE->BE_PRIOR 		,NIL},;				
	{"BE_ALTURLC"	,SBE->BE_ALTURLC 	,NIL},;				
	{"BE_LARGLC"	,SBE->BE_LARGLC 	,NIL},;				
	{"BE_COMPRLC"	,SBE->BE_COMPRLC 	,NIL},; 				
	{"BE_PERDA"		,SBE->BE_PERDA 		,NIL},;				
	{"BE_STATUS"	,SBE->BE_STATUS 	,NIL} }			

	nOpc := 3

	MSExecAuto({|x,y| MATA015(x,y)},aVetor, nOpc)     

	If lMsErroAuto	
		_cErro 	:= MostraErro("\temp")
		_cErro 	:= AllTrim(_cErro)
		_cErro 	:= StrTran(_cErro, "<","|")
		_cErro 	:= StrTran(_cErro, ">","|")
		cMsgErr += AllTrim(_cErro)
		lRet 	:= .F.
	Else	
		ConOut("Endereço " + alltrim(pLocaliz) + " criado no Armazém " + alltrim(pArmazem) + ".")		
	EndIf     

Return lRet
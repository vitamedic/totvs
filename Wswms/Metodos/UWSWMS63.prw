#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UWSWMS63 ºAutor  ³ Microsiga          º Data ³  24/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Metodo WS processamento da troca de lotes  	  			  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UWSWMS63(oDados, oRet)

	Local lOk 			:= .T.     
	Local lExisteSC9	:= .F.
	Local cMsgErr 		:= ""
	Local nI 			:= 0
	Local cPEDIDO   	:= ""
	Local cNUM_ITEM 	:= ""
	Local cNUM_OS   	:= ""
	Local cITEM         := ""
	Local cSEQ          := ""
	Local _cDoc   		:= ""
	Local _cSerie 		:= ""
	Local _cCliente		:= ""
	Local _cLoja      	:= ""
	Local _cNome		:= ""
	Local _cNumPV       := ""
	Local _cNumOS       := ""
	Local _cItemPV		:= ""
	Local _cSeq			:= ""
	Local _cSeqIt       := "" //Utilizado para criar sequencial para o item com mais de um lote na Z52
	Local _cProduto   	:= ""
	Local _cDesc   		:= ""
	Local _cLote      	:= ""
	Local _cLocal      	:= ""
	Local _nQtdLib      := 0
	Local _dDatLib      := CtoD("")

	Local aSaldos 		:= {}
	Local cDocSD3 		:= ""
	Local _MV_DEVTROCA 	:= SuperGetMV("MV_XTRTPMD", .f., "499")
	Local _MV_REQTROCA 	:= SuperGetMV("MV_XTRTPMR", .f., "999")
	Local nTamChave     := TamSX3("Z52_PEDIDO")[1]+TamSX3("Z52_NUMOS")[1]+TamSX3("Z52_ITEM")[1]+TamSX3("Z52_SEQ")[1]

	Private _aUsu  		:= PswRet(1)	
	Private aNumOS 		:= {}
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
	
	if lOk .AND. empty(oDados:NUM_OS)
		cMsgErr := "Ordem de separação não informada."
		lOk := .F.  
	
	elseif empty( cPEDIDO := Posicione("Z52", 2, XFilial("Z52")+Pad(oDados:NUM_OS, TamSX3("Z52_PEDIDO")[1]+TamSX3("Z52_NUMOS")[1],"x"), "Z52_PEDIDO") )
			cMsgErr := "Ordem de separação não localizada."
			lOk := .F.  
			
	elseif empty( cPEDIDO := Posicione("Z52", 2, XFilial("Z52")+Pad(oDados:NUM_OS+oDados:cItem, nTamChave,"x"), "Z52_PEDIDO") )
			cMsgErr := "Item da Ordem de separação não localizada."
			lOk := .F.  

	elseif empty(cNUM_OS := Z52->Z52_NUMOS)
			cMsgErr := "Ordem de separação não localizada."
			lOk := .F.  

	elseif empty(cITEM := Z52->Z52_ITEM)
			cMsgErr := "Item da Ordem de separação não localizada."
			lOk := .F.  

	elseif empty(cSEQ := Z52->Z52_SEQ)
			cMsgErr := "Sequencial do Item da Ordem de separação não localizada."
			lOk := .F.  

	endif

	if Len(oDados:aLotes) == 0
		cMsgErr := "Nenhum lote reportado para troca."
		lOk := .F.  
	endif
	
	//se tudo ok, atualiza o status do item
	if lOK
		BeginTran()

		dbSelectArea("Z52")
		dbSetOrder(2)
  		do while Z52->( Z52_FILIAL = XFilial("Z52") .and. Z52_PEDIDO = cPEDIDO .and. Z52_NUMOS = cNUM_OS .and. Z52_ITEM = cITEM .and. Z52_SEQ = cSEQ)
			_cNumOS := Z52->Z52_NUMOS
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Registros                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC6")
			dbSetOrder(1)
			if !MsSeek(xFilial("SC6")+Z52->Z52_PEDIDO+Z52->Z52_ITEM+Z52->Z52_COD)
				cMsgErr := "Item "+Z52->Z52_ITEM+" do Pedido "+Z52->Z52_PEDIDO+" não localizado."
    			lOk 	:= .F.
    			
    			exit
    		else 
				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(xFilial("SF4")+SC6->C6_TES)
				dbSelectArea("SC5")
				dbSetOrder(1)
				if ! MsSeek(xFilial("SC5")+Z52->Z52_PEDIDO)
					cMsgErr := "Pedido "+Z52->Z52_PEDIDO+" não localizado."
					lOk 	:= .F.
					
					exit
                endif
    		endif

			if lOk
				dbSelectArea("SC9")
				dbSetOrder(1)
				if !dbSeek(XFilial("SC9")+Z52->Z52_PEDIDO+Z52->Z52_ITEM+Z52->Z52_SEQ+Z52->Z52_COD)
					lExisteSC9	:= .F.	
					_cFilial    := Z52->Z52_FILIAL
					_cDoc   	:= ""
					_cSerie 	:= ""
					_cCliente	:= Z52->Z52_CLIENT
					_cLoja      := Z52->Z52_LOJA
					_cNome		:= Posicione("SA1", 1, XFilial("SA1")+_cCliente+_cLoja, "A1_NOME")
					_cNumPV     := Z52->Z52_PEDIDO
					_cItemPV	:= Z52->Z52_ITEM
					_cSeq		:= Z52->Z52_SEQ
					_cProduto   := Pad(Z52->Z52_COD, TamSX3("B8_PRODUTO")[1])
					_cDesc   	:= Posicione("SB1", 1, XFilial("SB1")+Z52->Z52_COD, "B1_DESC")
					_cLote      := Pad(Z52->Z52_LOTECT, TamSX3("B8_LOTECTL")[1])
					_cLocal		:= Z52->Z52_LOCAL
					_nQtdLib    := Z52->Z52_QTDLIB
					_dDatLib    := Z52->Z52_DATALI
					_nQtdTroca  := 0
					cDocSD3 	:= ""
					_cValid     := Z52->Z52_DTVALI
					aSaldos 	:= {}
				else
					lExisteSC9	:= .T.
					_cFilial    := SC9->C9_FILIAL
					_cDoc   	:= AllTrim(SC9->C9_NFISCAL)
					_cSerie 	:= AllTrim(SC9->C9_SERIENF)
					_cCliente	:= AllTrim(SC9->C9_CLIENTE)
					_cLoja      := AllTrim(SC9->C9_LOJA)
					_cNome		:= Posicione("SA1", 1, XFilial("SA1")+_cCliente+_cLoja, "A1_NOME")
					_cNumPV     := SC9->C9_PEDIDO
					_cItemPV	:= SC9->C9_ITEM
					_cSeq		:= SC9->C9_SEQUEN
					_cProduto   := Pad(SC9->C9_PRODUTO, TamSX3("B8_PRODUTO")[1])
					_cDesc   	:= Posicione("SB1", 1, XFilial("SB1")+SC9->C9_PRODUTO, "B1_DESC")
					_cLote      := Pad(SC9->C9_LOTECTL, TamSX3("B8_LOTECTL")[1])
					_cLocal		:= SC9->C9_LOCAL
					_nQtdLib    := SC9->C9_QTDLIB
					_dDatLib    := SC9->C9_DATALIB
					_nQtdTroca  := 0
					cDocSD3 	:= ""
					_cValid     := SC9->C9_DTVALID
					aSaldos 	:= {}
				endif
					
				for nI := 1 to Len(oDados:aLotes)      
					dbSelectArea("SB8")
					dbSetOrder(3)
					if !MSSeek(XFilial("SB8")+_cProduto+_cLocal+oDados:aLotes[nI]:cLote)
						cMsgErr := "Lote "+oDados:aLotes[nI]:cLote+" não localizado no armazém "+_cLocal
						lOk 	:= .F.
						exit
					else
						_cValid := SB8->B8_DTVALID
					endif
					
					for nY := 1 to Len(oDados:aLotes[nI]:aEnderecos)
						_nQtdTroca += oDados:aLotes[nI]:aEnderecos[nY]:nQuant
						
						AAdd(aSaldos, { oDados:aLotes[nI]:cLote,;
						                "",; 
						                oDados:aLotes[nI]:aEnderecos[nY]:cEndereco,;
						                "",;
						                oDados:aLotes[nI]:aEnderecos[nY]:nQuant,;
						                0,;
						                _cValid;
						               };
						    )
					next nY           
				next nI
				
				if lOk .and. _nQtdTroca <> _nQtdLib
					cMsgErr := "A quantidade reportada para troca do Lote não bate com o total do item\sequencia ("+_cItemPV+"\"+_cSeq+") do pedido de vendas."
					lOk 	:= .F.
				endif
				
				if lOk .and. Len(aSaldos) > 0
					//Registra o histórico 
					dbSelectArea("Z53")
					dbSetOrder(1)
					if ! RecLock( "Z53", !dbSeek(Z52->Z52_FILIAL+Z52->Z52_PEDIDO+Z52->Z52_ITEM+Z52->Z52_SEQ+DtoS(dDataBase)) )
						cMsgErr := "Erro acesso arquivo Z53, Item "+AllTrim(Z52->Z52_ITEM)+" Sequencial "+AllTrim(Z52->Z52_SEQ)+" do Pedido "+Alltrim(Z52->Z52_PEDIDO)+"."
						lOk 	:= .F.
						
						exit
					else
						Z53->Z53_FILIAL := Z52->Z52_FILIAL 
						Z53->Z53_PEDIDO := Z52->Z52_PEDIDO 
						Z53->Z53_ITEM 	:= Z52->Z52_ITEM 
						Z53->Z53_SEQ 	:= Z52->Z52_SEQ 
						Z53->Z53_DTINC	:= dDataBase 
						Z53->Z53_LOTECT := Z52->Z52_LOTECT 
						Z53->Z53_QUANT  := Z52->Z52_QTDLIB 
						Z53->Z53_USUI	:= _aUsu[1][2] 
						
						Z53->( MSUnlock() )
					endif
					
					if !lExisteSC9
					    //Crio o sequencial para o item do pedido para registrar os lotes 
						_cSeqIt := BuscaSeqIt()					    
					else                                            
						_cSeqIt := Z52->Z52_SEQ
					endif
					
					for nI := 1 to len(aSaldos)
						dbSelectArea("Z52")
						dbSetOrder(1)            
						lNovoRec := !dbSeek(XFilial("Z52")+_cNumPV+_cItemPV+_cSeqIt)
						
						if !RecLock("Z52", lNovoRec)
							lOk     := .f.
							cMsgErr := "Erro ao tentar reservar registro da tabela Z52!"
						else
							Z52->Z52_FILIAL 	:= XFilial("Z52")
							Z52->Z52_PEDIDO 	:= _cNumPV
							Z52->Z52_ITEM 		:= _cItemPV
							Z52->Z52_SEQ 		:= _cSeqIt
							Z52->Z52_LOCAL 		:= _cLocal
							Z52->Z52_COD 		:= _cProduto
							Z52->Z52_CLIENT		:= _cCliente
							Z52->Z52_LOJA 		:= _cLoja
							Z52->Z52_DATALI		:= _dDatLib
							Z52->Z52_BLEST 		:= "  "
							Z52->Z52_BLCRED		:= "  "
							Z52->Z52_NUMOS      := _cNumOS
							Z52->Z52_STATUS 	:= '4'
							Z52->Z52_LOTECT		:= aSaldos[nI,1]
							Z52->Z52_QTDLIB		:= aSaldos[nI,5]
							Z52->Z52_DTVALI		:= aSaldos[nI,7]
							
							if lNovoRec
								Z52->Z52_USUI		:= _aUsu[1][2]
								Z52->Z52_DTINC		:= DDataBase
							else
								Z52->Z52_USUA	:= _aUsu[1][2]
								Z52->Z52_DTALT 	:= DDataBase
							endif
							
							Z52->( MSUnlock() )
						endif
						
						if lExisteSC9
							exit
						else
							_cSeqIt := Soma1(_cSeqIt)
						endif
					next nI
					
					if lExisteSC9 .and. lOk
						if empty(_cDoc) //Se não foi faturado 
							/*/
							±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
							±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
							±±³Fun‡„o    ³A450Grava ³ Rev.  ³ Eduardo Riera         ³ Data ³02.02.2002 ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³          ³Rotina de atualizacao da liberacao de credito                ³±±
							±±³          ³                                                             ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Parametros³ExpN1: 1 - Liberacao                                         ³±±
							±±³          ³       2 - Rejeicao                                          ³±±
							±±³          ³ExpL2: Indica uma Liberacao de Credito                       ³±±
							±±³          ³ExpL3: Indica uma liberacao de Estoque                       ³±±
							±±³          ³ExpL4: Indica se exibira o help da liberacao                 ³±±
							±±³          ³ExpA5: Saldo dos lotes a liberar                             ³±±
							±±³          ³ExpA6: Forca analise da liberacao de estoque                 ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Retorno   ³Nenhum                                                       ³±±
							±±³          ³                                                             ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Descri‡„o ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
							±±³          ³venda com base na tabela SC9.                                ³±±
							±±³          ³                                                             ³±±
							±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
							±±³Uso       ³ Materiais                                                   ³±±
							±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
							±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
							ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
							a450Grava(nOpc,lAtuCred,lAtuEst,lHelp,aSaldos,lAvEst)
							/*/
							a450Grava(2,.f.,.t.,.f.,aSaldos,.t.)
							lOk := u_Vt600AtuZ52(Z52->Z52_PEDIDO, Z52->Z52_ITEM, Z52->Z52_SEQ, Z52->Z52_NUMOS, "4" )
							if ! lOk
								cMsgErr := "Erro ao processar a rotina de liberação de pedidos a450Grava para a troca dos lotes."
							endif
							
						else
					  		_aAutoSD3   := {}
							lMsHelpAuto := .F.
							lMsErroAuto := .F.
							
							if empty(cDocSD3)
								cDocSD3 := BuscaDoc()
							else
								cDocSD3 := Soma1(cDocSD3)
							endif
							
							Conout("==>>UWSWMS63: Fazendo movimento interno do produto "+alltrim(SC9->C9_PRODUTO)+", na quantidade: "+cValtoChar(SC9->C9_QTDLIB)+" ...")
							
							aadd (_aAutoSD3, {"D3_TM"		, _MV_DEVTROCA 		 								 						, NIL})
							aadd (_aAutoSD3, {"D3_COD"		, SC9->C9_PRODUTO 								 	 						, NIL})
				            aadd (_aAutoSD3, {"D3_LOCAL"	, SC9->C9_LOCAL	 								 	 						, NIL})
				            aadd (_aAutoSD3, {"D3_QUANT"	, SC9->C9_QTDLIB	 								 						, NIL})
				            aadd (_aAutoSD3, {"D3_LOTECTL"	, SC9->C9_LOTECTL 								 	 						, NIL})
				            aadd (_aAutoSD3, {"D3_NUMLOTE"	, SC9->C9_NUMLOTE 								 	 						, NIL})
				            aadd (_aAutoSD3, {"D3_NUMSERI"	, SC9->C9_NUMSERI 								 	 						, NIL})
				            aadd (_aAutoSD3, {"D3_DOC"		, cDocSD3			 								 						, NIL})
				            aadd (_aAutoSD3, {"D3_EMISSAO"	, dDataBase 		 								 						, NIL})
				            aadd (_aAutoSD3, {"D3_OBS"		, "Troca de Lote, Pedido/OS: " + transform(cPEDIDO+cNUM_OS, "@R !!!!!/!!")	, NIL})
				            
				            MsExecAuto({|x,y,z| MATA240(x,y,z)}, _aAutoSD3, 3)
				            
				            if lMsErroAuto
								cMsgErr := MostraErro("\temp")
								cMsgErr := StrTran(cMsgErr, "<","|")
								cMsgErr := StrTran(cMsgErr, ">","|")

				            	lOk := .F.
				            	Conout(cMsgErr)
				            	DisarmTransaction()
				            	exit
				            else
				            	Conout("==>>UWSWMS63: Movimento de devolução realizado com sucesso! ")
							endif

							for nY := 1 to Len(aSaldos)
						  		_aAutoSD3   := {}
								lMsHelpAuto := .F.
								lMsErroAuto := .F.
								
								if empty(cDocSD3)
									cDocSD3 := BuscaDoc()
								else
									cDocSD3 := Soma1(cDocSD3)
								endif
								
								Conout("==>>UWSWMS63: Fazendo movimento interno de requisição do produto "+alltrim(SC9->C9_PRODUTO)+", na quantidade: "+cValtoChar(aSaldos[nY][5])+" ...")
								
								aadd (_aAutoSD3, {"D3_TM"		, _MV_REQTROCA 		 								 						, NIL})
								aadd (_aAutoSD3, {"D3_COD"		, SC9->C9_PRODUTO 								 	 						, NIL})
					            aadd (_aAutoSD3, {"D3_LOCAL"	, SC9->C9_LOCAL	 								 	 						, NIL})
					            aadd (_aAutoSD3, {"D3_QUANT"	, aSaldos[nY][5]		 	 						 						, NIL})
					            aadd (_aAutoSD3, {"D3_LOTECTL"	, aSaldos[nY][1]					 	 			 						, NIL})
					            aadd (_aAutoSD3, {"D3_NUMLOTE"	, SC9->C9_NUMLOTE 								 	 						, NIL})
					            aadd (_aAutoSD3, {"D3_NUMSERI"	, SC9->C9_NUMSERI 								 	 						, NIL})
					            aadd (_aAutoSD3, {"D3_LOCALIZ"	, aSaldos[nY][3]	 	 							 						, NIL})
					            aadd (_aAutoSD3, {"D3_DOC"		, cDocSD3			 								 						, NIL})
					            aadd (_aAutoSD3, {"D3_EMISSAO"	, dDataBase 		 								 						, NIL})
					            aadd (_aAutoSD3, {"D3_OBS"		, "Troca de Lote, Pedido/OS: " + transform(cPEDIDO+cNUM_OS, "@R !!!!!/!!")	, NIL})
					            
					            MsExecAuto({|x,y,z| MATA240(x,y,z)}, _aAutoSD3, 3)
					            
					            if lMsErroAuto
									cMsgErr := MostraErro("\temp")
									cMsgErr := StrTran(cMsgErr, "<","|")
									cMsgErr := StrTran(cMsgErr, ">","|")

					            	lOk := .F.
					            	Conout(cMsgErr)
					            	DisarmTransaction()
					            	exit
					            else
					            	Conout("==>>UWSWMS63: Movimento de devolução realizado com sucesso! ")
								endif
								    
							next nY           
							
							if ! lOk 
								exit
							endif
							
						endif
						
						if lOk
							u_VIT604(_cFilial, _cDoc, _cSerie, _cCliente, _cLoja, _cNome, cPEDIDO+cNUM_OS, _cItemPV, _cSeq, _cProduto, _cDesc, _cLote, _cLocal, _nQtdLib, aSaldos)
						endif
						
					endif
					
		        endif
            	
            endif
            
			Z52->(dbSkip())
		enddo
        
		if !lOk
			DisarmTransaction()
		else
			EndTran()
			cMsgErr := "Troca dos lotes realizada com sucesso."
		endif
		
	endif
	
	oRet:SITUACAO := lOK
	oRet:MENSAGEM := cMsgErr

Return(.t.)

Static Function BuscaDoc()

	Local _cLocal	:= GetArea()
	Local cCodSD3	:= ""
	Local cQry 		:= ""
	
	cQry := " SELECT MAX(D3_DOC) PROX "
	cQry += " FROM " + RetSqlName("SD3")
	cQry += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"
	cQry += " AND D_E_L_E_T_ <> '*' "
	cQry += " AND D3_DOC LIKE 'JS%' "
	
	If Select("QAUX") > 0
		QAUX->(dbCloseArea())
	EndIf
	
	cQry := ChangeQuery(cQry)
	TcQuery cQry NEW Alias "QAUX" 
	
	If QAUX->(!Eof())
		If Empty(QAUX->PROX)
			cCodSD3 := "JS"+strzero(1, TamSX3("D3_DOC")[1]-2 )
		Else
			cCodSD3 := Soma1(QAUX->PROX)
		EndIf
	Else
		cCodSD3 := "JS"+strzero(1, TamSX3("D3_DOC")[1]-2 )
	EndIf
	
	If Select("QAUX") > 0
		QAUX->(dbCloseArea())
	EndIf
	
	RestArea( _cLocal )

Return cCodSD3

Static Function BuscaSeqIt(pPedido, pItem)

	Local _cLocal	:= GetArea()
	Local cSeqIt	:= ""
	Local cQry 		:= ""
	
	Default pPedido := Z52->Z52_PEDIDO
	Default pItem   := Z52->Z52_ITEM
	
	cQry := " SELECT MAX(Z52_SEQ) PROX "
	cQry += " FROM " + RetSqlName("Z52")
	cQry += " WHERE Z52_FILIAL = '"+xFilial("Z52")+"'"
	cQry += "   AND D_E_L_E_T_ <> '*' "
	cQry += "   AND Z52_PEDIDO = '"+pPedido+"' "
	cQry += "   AND Z52_ITEM   = '"+pPedido+"' "
	
	If Select("QSQIT") > 0
		QSQIT->(dbCloseArea())
	EndIf
	
	cQry := ChangeQuery(cQry)
	TcQuery cQry NEW Alias "QSQIT" 
	
	If QSQIT->(!Eof())
		If Empty(QSQIT->PROX)
			cSeqIt := "01"
		Else
			cSeqIt := Soma1(QSQIT->PROX)
		EndIf
	Else
		cSeqIt := "01"
	EndIf
	
	If Select("QSQIT") > 0
		QSQIT->(dbCloseArea())
	EndIf
	
	RestArea( _cLocal )

Return cSeqIt
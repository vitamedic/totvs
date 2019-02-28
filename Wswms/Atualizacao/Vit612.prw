#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} Vit612
	Função para abrir os pedidos de venda e controlar o empenho no painel de expedição 
@author Microsiga
@since 13/06/17
@version 1.0
@return ${return}, ${return_description}
@param pPedido, , descricao
@param pItens, , descricao
@type function
/*/
User Function Vit612(pPedido, pItens)

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local nY     := 0
Local cDoc   := ""
Local lOk    := .T.

PRIVATE lMsErroAuto := .F.

ConOut(Repl("-",80))
ConOut(PadC("Alteração do Pedido : " + pPedido,80))

dbSelectArea("SC5")
dbSetOrder(1)
if ! SC5->(MsSeek(xFilial("SC5")+pPedido))
	 lOk := .F.
	 ConOut("Pedido não localizado")
endif

if lOk
	
	_aCampos := {}
	for nY := 1 to 2
		cAlias := Iif(nY == 1, "SC5", "SC6")
		
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek(cAlias)
		do while !EOF() .and. X3_ARQUIVO == cAlias
			if X3Uso(X3_USADO) .and. cNivel >= X3_NIVEL .and. X3_BROWSE = "S"
				AADD( _aCampos, { cAlias, X3_CAMPO })
			endif
			dbSkip()
		enddo
	next nY

endif

if lOk .and. len(_aCampos) > 0
	ConOut("Inicio: "+Time())

	aCabec := {}
	aItens := {}
	cAlias := "SC5"    
		
	dbSelectArea(cAlias)
	AEval(_aCampos, {|x| Iif( x[1]==cAlias .and. Type(cAlias+"->"+x[2]) <> "U", AAdd(aCabec, {x[2], &(cAlias+"->"+x[2]), Nil} ), .t.)} )
		
	For nX := 1 to Len(pItens)
		cAlias := "SC6"    
		dbSelectArea(cAlias)
		dbSetOrder(1)
		if !SC6->(MsSeek( xFilial(cAlias)+pPedido+pItens[nX][1] ))
			lOk := .F.
			ConOut("Cadastrar produto: PA001")
			Exit
		else
			dbSelectArea("SB2")
			dbSetOrder(1)
			if MSSeek(XFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)
				SB2->(RecLock("SB2", .f.))
				SB2->B2_XEMPWMS += pItens[nX][3]
				SB2->(MsUnlock())
			endif
            
			/*
			dbSelectArea("SB8")
			dbSetOrder(3)    
			//B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
			if MSSeek(XFilial("SB8")+SC6->C6_PRODUTO+SC6->C6_LOCAL+pItens[nX][2])
				SB8->(RecLock("SB8", .f.))
				SB8->B8_XEMPWMS += pItens[nX][3]
				SB8->(MsUnlock())
			endif

			dbSelectArea("SC9")
			dbSetOrder(1)    
			MSSeek(XFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
            do while SC9->(!Eof() .and. C9_FILIAL = XFilial("SC9") .and. C9_PEDIDO = SC6->C6_NUM .and. C9_ITEM = SC6->C6_ITEM)
            	if !empty(alltrim(SC9->C9_BLEST))
            		SC9->(dbSkip())
            		loop
            	endif
            	
				dbSelectArea("SDC")
				dbSetOrder(1)    
				//DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
				MSSeek(cChave:=XFilial("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+'SC6'+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQ+pItens[nX][2])
				do while SDC->(!Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL = cChave)
					dbSelectArea("SBF")
					dbOrderNickName("SBFVIT01") //NICKNAME(SBFVIT01)
					//BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_LOCALIZ
                    if MSSeek(XFilial("SBF")+SDC->DC_PRODUTO+SDC->DC_LOCAL+SDC->DC_LOTECTL+SDC->DC_LOCALIZ)
						SBF->(RecLock("SBF", .f.))
						SBF->BF_XEMPWMS += pItens[nX][3]
						SBF->(MsUnlock())
					endif

					dbSelectArea("Z51")
					dbSetOrder(2)
					//Z51_FILIAL+Z51_PRODUT+Z51_LOCAL+Z51_ORIGEM+Z51_PEDIDO+Z51_ITEM+Z51_SEQ+Z51_LOTECT+Z51_NUMLOT+Z51_LOCALI+Z51_NUMSER
					if Z51->( RecLock("Z51", !dbSeek(SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI) ) ) )
						Z51->Z51_FILIAL 	:= SDC->DC_FILIAL
						Z51->Z51_ORIGEM    	:= SDC->DC_ORIGEM
						Z51->Z51_PRODUT		:= SDC->DC_PRODUTO
						Z51->Z51_LOCAL 		:= SDC->DC_LOCAL
						Z51->Z51_LOCALI    	:= SDC->DC_LOCALIZ
						Z51->Z51_NUMSER    	:= SDC->DC_NUMSERI
						Z51->Z51_LOTECT    	:= SDC->DC_LOTECTL
						Z51->Z51_NUMLOT    	:= SDC->DC_NUMLOTE
						Z51->Z51_QUANT     	:= SDC->DC_QUANT
						Z51->Z51_OP    		:= SDC->DC_OP
						Z51->Z51_TRT       	:= SDC->DC_TRT
						Z51->Z51_PEDIDO   	:= SDC->DC_PEDIDO
						Z51->Z51_ITEM      	:= SDC->DC_ITEM
						Z51->Z51_QTDORI    	:= SDC->DC_QTDORIG
						Z51->Z51_SEQ       	:= SDC->DC_SEQ
						Z51->Z51_QTSEGU    	:= SDC->DC_QTSEGUM
						Z51->Z51_ESTFIS    	:= SDC->DC_ESTFIS
						Z51->Z51_USERLI    	:= SDC->DC_USERLGI                                
						Z51->Z51_USERLA    	:= SDC->DC_USERLGA
						Z51->Z51_IDDCF    	:= SDC->DC_IDDCF
		
						Z51->( MsUnLock() )
					endif
						
					SDC->(dbSkip())
	            enddo
			
				SC9->(dbSkip())
	        enddo
			*/
			
			aLinha := {}
			aadd(aLinha,{"LINPOS","C6_ITEM",pItens[nX,1]})
			aadd(aLinha,{"AUTDELETA","N",Nil})

			AEval(_aCampos, {|x| Iif(x[1]==cAlias .and. x[2]<>"C6_ITEM" .and. Type(cAlias+"->"+x[2]) <> "U", AAdd(aLinha, {x[2], &(cAlias+"->"+x[2]), Nil} ), .t.)} )
			aadd(aItens,aLinha)
		endif
	Next nX 
	
	if lOk
		ConOut(PadC("Teste de alteracao",80))
		ConOut("Inicio: "+Time())
		MATA410(aCabec,aItens,4)
		ConOut("Fim  : "+Time())
		ConOut(Repl("-",80))
		
  		if lMsErroAuto
			cMsgErr := MostraErro("\temp")
			cMsgErr := StrTran(cMsgErr, "<","|")
			cMsgErr := StrTran(cMsgErr, ">","|")

			lOk := .F.
   			Conout(cMsgErr)     

   			msgAlert(cMsgErr)
      		DisarmTransaction()
        else
        	Conout("Alteração Executada com sucesso! ")
		endif

	endif
endif

Return(lOk)
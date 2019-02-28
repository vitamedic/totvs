#INCLUDE "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "XMLXFUN.CH"
#include "Ap5Mail.ch"
#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "APWEBSRV.CH" 
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} WS_FOCOPDV
(long_description)
@type function
@author André Almeida Alves
@since 25/09/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

User Function WS_INTFOCO()

	Local aArea			:= GetArea()	// variavel para salvar o ambiente ativo
	Local oWsdl						    // objeto a ser alimentado pelo TWsdlManager
	Local lRet			:= .F.			// variavel de retorno logico
	Local aOper			:= {}			// array a ser preenchidos com os metodos
	Local aParam		:= {}			// array a ser preenchidos com os parametros para os metodos
	Local nI			:= 0			// variavel contadora
	Private _axEmp		:= {}			// variavel para carregar as empresas do sigamat
	Private cUrlWS		:= ""			// parametro com a do WebService
	//Default lJob		:= .t.
	ConOut( Replicate("-",150) )
	Conout( "[WS] PREPARO O AMBIENTE PARA INTEGRACAO" )
	ConOut( Replicate("-",150) )

	//==============================================================
	//   CARREGA EMPRESAS
	//==============================================================098

	OpenSm0()
	SM0->( DbGoTop() )
	while !SM0->( Eof() )

		aAdd( _axEmp, { AllTrim( SM0->M0_CODIGO ),AllTrim( SM0->M0_CODFIL ),SM0->M0_FILIAL,SM0->M0_CGC} )

		SM0->( DbSkip() )

	enddo
	SM0->( DbGoTop() )

	conout( "[WS_INTFOCO] "+ OemtoAnsi( " Entrando no RpcSetEnv: Empresa: "+_axEmp[1][1]+" Filial: "+ _axEmp[1][2]  ) )

	//==============================================================
	// criando o ambiente para as empresas
	//==============================================================

	RpcSetType(3)
	Reset Environment
	RpcSetEnv(_axEmp[1][1],_axEmp[1][2]) //Vai preparar na primeira empresa

	//==============================================================
	// parametro com a do WebService
	//==============================================================
	cUrlWS		:= SuperGetMV( "ES_URLWSJ",,"http://focopdv.vitamedic.ind.br/vitamedic/WSrv_ListaPedidos/ListaPedidos.asmx?WSDL" )

	//Teste
	//cUrlWS		:= SuperGetMV( "ES_URLWSJ",,"http://www.pdvmanager.com.br/vitamedic/WSrv_ListaPedidos/ListaPedidos.asmx?WSDL" )

	//==============================================================
	// crio o objeto da classe
	//==============================================================

	oWsdl := TWsdlManager():New()

	//==============================================================
	// faco a conexao com o link do WSDL
	//==============================================================

	lRet := oWsdl:ParseURL( cUrlWS )

	//==============================================================
	// De acordo com o retorno da Conexao executa as operacoes
	//==============================================================

	if lRet

		ConOut( Replicate("-",150) )
		Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Conexao com o FocoPDV realizada com sucesso!" )
		ConOut( Replicate("-",150) )

		//==============================================================
		// Solicito os metodos disponiveis do WebServices
		//==============================================================

		aOper := oWsdl:ListOperations()

		//==============================================================
		// Vou listar os operacoes apenas para visualizar em console
		//==============================================================

		For nI := 1 To Len( aOper )

			//==============================================================
			// Verifico se existem pedidos para serem integrados
			//==============================================================

			If AllTrim( aOper[nI][1] ) == "RetornaListaPedidos"

				ConOut( Replicate("-",80) )
				Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Executa a funcao fPegaPV()" )
				ConOut( Replicate("-",80) )

				fPegaPV( oWSDL )
			EndIf

		Next nI
		//		fRetoPV(oWSDL)
		fPegaRP( oWsdl )
	else
		ConOut( Replicate("-",150) )
		Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Ocorreu um erro de conexao com o FocoPDV!" )
		ConOut( Replicate("-",150) )

		ConOut( Replicate("-",150) )
		Conout( "Erro: " + oWsdl:cError )
		ConOut( Replicate("-",150) )
	endif

	ConOut( Replicate("-",150) )
	Conout( "[WS_INTFOCO] FIM DA INTEGRACAO VIA WEBSERVICE COM A FOCOPDV Data:"+dtoc(ddatabase)+ " Hora: "+time()+ "" )
	ConOut( Replicate("-",150) )


	RestArea( aArea )

Return(lRet)

//STEPHEN NOEL DE MELO RIBEIRO
//===========================================
Static Function fPegaRP( oWsdl)
	//===========================================
	Local aInput	:= {}
	Local aParam	:= {}
	Local aPedidos	:= {}
	Local cSoap		:= ""
	Local cError	:= ""
	Local cWarning	:= ""
	Local lRet		:= .F.
	Local oXML
	Local cMsg		:= ""
	Local _npedido  := ""
	Local _nproduto := ""
	Local _nquant   := ""
	Local _nnota    := ""
	Local _nitem    := ""
	Local _serie    := ""
	Local _cliente  := ""
	Local _loja     := ""
	Local _pedprot  := ""
	Local nQtdReg   

	ConOut( Replicate("-",150) )
	Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Execulta a função fPegaRP " )
	ConOut( Replicate("-",150) )
	criatmp1()
	//	DbSelectArea("tmp1")
	tmp1->(DbGoTop())
	COUNT TO nQtdReg
	tmp1->(DbGoTop())
	If nQtdReg > 0
		While tmp1->(!EOF())

			_npedido:= tmp1->pedido
			_nproduto:= tmp1->produto
			_nquant:= tmp1->quant
			_nnota:= tmp1->nota
			_serie:= tmp1->serie
			_cliente:= tmp1->cli
			_loja:= tmp1->loja
			_pedprot:= tmp1->pedprot
			//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM                                                                                                     
			fRetoPV( _npedido, _nproduto, _nquant, _nnota, _serie,_cliente,_loja )

			tmp1->(DbSkip())
		End
	EndIf
	tmp1->(DbCloseArea())
Return
//===========================================
Static Function fPegaPV( oWsdl)
	//===========================================

	Local aInput	:= {}
	Local aParam	:= {}
	Local aPedidos	:= {}
	Local cSoap		:= ""
	Local cError	:= ""
	Local cWarning	:= ""
	Local lRet		:= .F.
	Local oXML
	Local cMsg		:= ""
	Local _npedido
	Local _nproduto
	Local _nquant
	Local _nnota
	//	Local _nitem

	xRet := oWsdl:SetOperation( "RetornaListaPedidos" ) 
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	//==============================================================
	// Defino a variável necessaria para o parametro
	//==============================================================

	xRet := oWsdl:SetValue( 0, "true" )
	//xRet := oWsdl:SetValue( 0, "false" )
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	//==============================================================
	// Envia a mensagem SOAP ao servidor
	//==============================================================

	xRet := oWsdl:SendSoapMsg()
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	//==============================================================
	// Pega a mensagem de resposta
	//==============================================================

	cSoap		:= oWsdl:GetSoapResponse()
	aInput 		:= oWsdl:SimpleInput()
	oXML 		:= XmlParser( cSoap, "_", @cError, @cWarning )	
	aPedFoco	:= XmlChildEx(oxml:_SOAP_ENVELOPE:_SOAP_BODY:_RETORNALISTAPEDIDOSRESPONSE:_RETORNALISTAPEDIDOSRESULT, "_PEDIDO") 

	if aPedFoco == nil
		ConOut( Replicate("-",150) )
		Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Não Existe pedido a importar!" )
		ConOut( Replicate("-",150) )
	Else
		aPedidos 	:= oxml:_SOAP_ENVELOPE:_SOAP_BODY:_RETORNALISTAPEDIDOSRESPONSE:_RETORNALISTAPEDIDOSRESULT:_PEDIDO
	EndIf

	If ValType( oXML ) == "O"
		//==============================================================
		// Chama função de inclusão do Pedido
		//==============================================================

		ConOut( Replicate("-",150) )
		Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Chama a função de inclusão do pedido fIncPV()" )
		ConOut( Replicate("-",150) )

		fIncPV( oWSDL, oXML, aPedidos, cSoap )

	Else 
		ConOut( Replicate("-",150) )
		Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Não conseguiu montar o Objeto." )
		ConOut( Replicate("-",150) )
	EndIf


Return lRet

//==============================================
Static Function fIncPV( oWSDL, oXML, aPedidos, cSoap )
	//==============================================

	Local aCabTemp		:= {}
	Local aIteTemp		:= {}
	Local aCabec		:= {}
	Local aItens		:= {}
	Local aItePV		:= {}
	Local cCliente		:= ""
	Local cLojaCli		:= ""
	Local cProduto		:= ""
	Local cCodMun		:= ""
	Local cCodUF		:= ""
	Local cCondPag		:= ""
	Local cMsgPed		:= ""
	Local cMsgNF		:= ""
	Local nI			:= 0
	Local nJ			:= 0
	Local cBonifica     := "false"
	Local cTipoCli		:= ""
	Local pedipok 		:= ""
//	Local ItemCli		:= ""
	PRIVATE lMsErroAuto := .F.
	Private	lEnvMail	:= .F.

	cMsgMail			:= ""

	Default aPedidos	:= {}
	Default cSoap		:= ""



	ConOut( Replicate("-",150) )
	Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Funcao 'fIncPV'" )
	ConOut( Replicate("-",150) )

	//==============================================================
	// Vou percorrer os pedidos a serem importados
	//==============================================================
	If ValType(aPedidos) == "A"

		For nI := 1 To Len(aPedidos)

			aCabTemp 		:= {}
			aIteTemp 		:= {}
			cNumPed			:= StrZero( Val( aPedidos[nI]:_CODIGOPEDIDO:TEXT ), TamSX3("C5_NUM")[1] )

			//==============================================================
			// Vou pegar o codigo e loja no cadastro do sistema
			//==============================================================

			cCGC			:= aPedidos[nI]:_CNPJ:TEXT
			cCondPgWS		:= aPedidos[nI]:_CODIGOCONDICAOPAGAMENTO:TEXT
			cCliente 		:= ""
			cLojaCli		:= ""
			cCodMun			:= ""
			cCodUF			:= ""
			cCondPag		:= ""
			cMsgPed			:= aPedidos[nI]:_OBSERVACAOPEDIDO:TEXT
			cMsgNF			:= aPedidos[nI]:_OBSERVACAONF:TEXT
			nMargem			:= val(aPedidos[nI]:_MARGEM:TEXT)
			cCodRep			:= aPedidos[nI]:_CODIGOREPRESENTANTE:TEXT
			cCodPedCli		:= aPedidos[nI]:_CODIGOPEDIDOCLIENTE:TEXT
			cBonifica		:= aPedidos[nI]:_BONIFICADO:TEXT
			cMsgMail		:= ""
			cPath   		:= "temp/"
			cNomeArq  		:= "Erro_MsExecAuto_MATA410.txt"   
			cAnexo			:= "temp/Erro_MsExecAuto_MATA410" 
			If empty(cMsgNF)
				cMsgNF			:= " "
			Else 
				cMsgNF			:= "Pedido Cliente -> " + cCodPedCli + "/ " + cMsgNF
			EndIf

			DbSelectArea("SA1")
			SA1->( DbSetOrder( 3 ) )
			If SA1->( DbSeek( xFilial("SA1")+StrZero( Val(cCGC), TamSX3( "A1_CGC" )[1] ) ) )

				cCliente 	:= SA1->A1_COD
				cLojaCli	:= SA1->A1_LOJA
				cCodMun		:= SA1->A1_COD_MUN
				cCodUF		:= SA1->A1_EST
				cTipoCli	:= Alltrim(SA1->A1_CATEG)
				iF cCodRep = "0"
					cCodRep	:= SA1->A1_VEND
					cMsgMail += "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Codigo do vendedor veio com valor 0, atribuido o vendedor do cadastro do Cliente! cod -> " + cCodRep + Chr(13) + Chr(10)
					lEnvMail	:= .T.
				EndIf

			Else 
				ConOut( Replicate("-",150) )
				Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Nao foi encontrado o cliente! cod -> " + cCGC)
				ConOut( Replicate("-",150) )
				cMsgMail += "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Nao foi encontrado o cliente! cod -> " + cCGC + Chr(13) + Chr(10)
				lEnvMail	:= .T.
			EndIf
			nComissao		:= calcMarg(nMargem, cTipoCli)
			DbSelectArea("SE4")
			SE4->( DbSetOrder(1) )
			If SE4->( DbSeek( xFilial("SE4")+cCondPgWS ) )
				cCondPag := SE4->E4_CODIGO
				If cCondPag == "001"
					cCondPag := "609"
					cMsgMail += "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Nao foi encontrado a condição de pagamento! Foi atribuido o Cod -> " + cCondPag + Chr(13) + Chr(10)
					lEnvMail	:= .T.
				EndIf
			EndIf
			//cCondPag := "501"

			//==============================================================
			// Prencho os itens do pedido de venda do WS
			//==============================================================

			aItePV		:= aPedidos[nI]:_ITENS:_PEDIDOITEM

			cDoc := GetSxeNum("SC5","C5_NUM")
			RollBAckSx8()

			aCabec := {}
			aItens := {}

			aadd(aCabec,{"C5_FILIAL"   		,"01"    			,Nil })
			aadd(aCabec,{"C5_NUM"   		,cDoc				,Nil })
			aadd(aCabec,{"C5_TIPO" 			,"N"				,Nil })
			aadd(aCabec,{"C5_CLIENTE"		,cCliente			,Nil })
			aadd(aCabec,{"C5_LOJACLI"		,cLojaCli			,Nil })
			aadd(aCabec,{"C5_LOJAENT"		,cLojaCli			,Nil })
			aadd(aCabec,{"C5_CONDPAG"		,cCondPag			,Nil })
			aadd(aCabec,{"C5_POCKET"		,cNumPed			,Nil })
			aadd(aCabec,{"C5_MARGEM"		,nMargem			,Nil })
			aadd(aCabec,{"C5_COMIS1"		,nComissao			,Nil })
			aadd(aCabec,{"C5_MENPED"		,cMsgPed			,Nil })
			aadd(aCabec,{"C5_MENNOTA"		,cMsgNF				,Nil })
			If !empty(cCodPedCli) 
				aadd(aCabec,{"C5_NUMPCO"		,cCodPedCli			,Nil })
			EndIf
			//==============================================================
			// Vou percorrer todos os arrays de pedido
			//==============================================================

			If ValType( aItePV ) == "A"
				For nJ := 1 To Len( aItePV )

					//==============================================================
					// Prencho os itens do pedido de venda do WS
					//==============================================================

					cProduto	:= aItePV[nJ]:_codigoproduto:text
					nQtd		:= Val(aItePV[nJ]:_qtdpedida:text)
					nPrcVend	:= Round(Val(aItePV[nJ]:_valorunitarioliquido:text),2)
					nPrcLista	:= Round(Val(aItePV[nJ]:_valorunitariobruto:text),2)
					nValDesc	:= Val(aItePV[nJ]:_valordescontounitario:text)
					nPerDesc	:= Val(aItePV[nJ]:_PercentualDesconto:text)
					ItemCli     := aItePV[nJ]:_NumeroItemPedidoCliente:text

					aLinha := {}
					aadd(aLinha,{"C6_ITEM"			,StrZero(nJ,2)					, Nil})
					aadd(aLinha,{"C6_PRODUTO"		,StrZero(val(cProduto),6)		, Nil})
					aadd(aLinha,{"C6_QTDVEN"		,nQtd							, Nil})
					aadd(aLinha,{"C6_PRCVEN"		,nPrcVend						, Nil})
					aadd(aLinha,{"C6_VALOR"			,nQtd*nPrcVend					, Nil})
					If cbonifica = "true"
						aadd(aLinha,{"C6_OPER"			,"04"							, Nil})
					Else
						aadd(aLinha,{"C6_OPER"			,"01"							, Nil})
					EndIf
					aadd(aLinha,{"C6_DESCPR"		,nPerDesc						, Nil})  //Percentual de desconto comercial
					//aadd(aLinha,{"C6_VALDESC"		,nValDesc						, Nil})  //valor desconto comercial
					aadd(aLinha,{"C6_DESCVL"		,nValDesc						, Nil})
					aadd(aLinha,{"C6_PRUNIT"		,nPrcLista						, Nil})
					If !empty(ItemCli)
						aadd(aLinha,{"C6_ITEMPC"	,ItemCli						, Nil})
					EndIf
					If !empty(cCodPedCli)
						aadd(aLinha,{"C6_NUMPCOM"	,cCodPedCli 					, Nil})
					EndIf
					aadd(aItens,aLinha)

				Next nJ

			Else
				//==============================================================
				// Prencho os itens do pedido de venda do WS
				//==============================================================

				cProduto	:= aItePV:_codigoproduto:text
				nQtd		:= Val(aItePV:_qtdpedida:text)
				nPrcVend	:= Val(aItePV:_valorunitarioliquido:text)
				nValDesc	:= Val(aItePV:_valordescontounitario:text)
				nPrcLista	:= Round(Val(aItePV:_valorunitariobruto:text),2)
				nValDesc	:= Val(aItePV:_valordescontounitario:text)
				nPerDesc	:= Val(aItePV:_PercentualDesconto:text)
				ItemCli     := aItePV:_NumeroItemPedidoCliente:text

				aLinha := {}
				aadd(aLinha,{"C6_ITEM"			,StrZero(nJ,2)					, Nil})
				aadd(aLinha,{"C6_PRODUTO"		,StrZero(val(cProduto),6)		, Nil})
				aadd(aLinha,{"C6_QTDVEN"		,nQtd							, Nil})
				aadd(aLinha,{"C6_PRCVEN"		,nPrcVend						, Nil})
				aadd(aLinha,{"C6_VALOR"			,nQtd*nPrcVend					, Nil})
					If cbonifica = "true"
						aadd(aLinha,{"C6_OPER"			,"04"							, Nil})
					Else
						aadd(aLinha,{"C6_OPER"			,"01"							, Nil})
					EndIf
				aadd(aLinha,{"C6_DESCPR"		,nPerDesc						, Nil})  //Percentual de desconto comercial
				//aadd(aLinha,{"C6_VALDESC"		,nValDesc						, Nil})  //valor desconto comercial
				aadd(aLinha,{"C6_DESCVL"		,nValDesc						, Nil})
				aadd(aLinha,{"C6_PRUNIT"		,nPrcLista						, Nil})
				If !empty(ItemCli)
					aadd(aLinha,{"C6_ITEMPC"	,ItemCli						, Nil})
				EndIf
				If !empty(cCodPedCli)
					aadd(aLinha,{"C6_NUMPCOM"	,cCodPedCli 					, Nil})
				EndIf				
				aadd(aItens,aLinha)

			EndIf
			DbSelectArea("SC5")
			SC5->(DbSetOrder(10))
			If sc5->(dbseek("01"+cNumPed))
				pedipok := cNumPed
				fRetPT(oWsdl, pedipok)
			Else
				BEGIN TRANSACTION
					//MATA410(aCabec,aItens,3) //Inclui Pedido de vendas.
					msexecauto({|x,y,z| mata410(x,y,z)},aCabec,aItens,3)
				END TRANSACTION

				If !lMsErroAuto
					ConOut( Replicate("-",150) )
					Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Pedido Incluido com Sucesso!! " + cDoc)
					ConOut( Replicate("-",150) )
					fRetPV(oWsdl, cNumPed) //Marca pedido como importado
				Else
					ConOut( Replicate("-",150) )
					Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Erro na Inclusão!! " + MostraErro())
					ConOut( Replicate("-",150) )
					Mostraerro(cPath, cNomeArq) 
					email()
				EndIf
			EndIf
			SC5->(DbCloseArea())
		Next nI
	Else
		aCabTemp 		:= {}
		aIteTemp 		:= {}
		cNumPed			:= StrZero( Val( aPedidos:_CODIGOPEDIDO:TEXT ), TamSX3("C5_NUM")[1] )

		//==============================================================
		// Vou pegar o codigo e loja no cadastro do sistema
		//==============================================================

		cCGC			:= aPedidos:_CNPJ:TEXT
		cCondPgWS		:= aPedidos:_CODIGOCONDICAOPAGAMENTO:TEXT
		cCliente 		:= ""
		cLojaCli		:= ""
		cCodMun			:= ""
		cCodUF			:= ""
		cCondPag		:= ""
		cMsgPed			:= aPedidos:_OBSERVACAOPEDIDO:TEXT
		cMsgNF			:= aPedidos:_OBSERVACAONF:TEXT
		nMargem			:= val(aPedidos:_MARGEM:TEXT)
		cCodRep			:= aPedidos:_CODIGOREPRESENTANTE:TEXT
		cMsgMail		:= ""
		cPath   		:= "temp/"
		cNomeArq  		:= "Erro_MsExecAuto_MATA410.txt"   
		cAnexo			:= "temp/Erro_MsExecAuto_MATA410" 
		cCodPedCli		:= aPedidos:_CODIGOPEDIDOCLIENTE:TEXT
		cMsgNF			:= "Pedido Cliente -> " + cCodPedCli + "/ " + cMsgNF

		DbSelectArea("SA1")
		SA1->( DbSetOrder( 3 ) )
		If SA1->( DbSeek( xFilial("SA1")+StrZero( Val(cCGC), TamSX3( "A1_CGC" )[1] ) ) )

			cCliente 	:= SA1->A1_COD
			cLojaCli	:= SA1->A1_LOJA
			cCodMun		:= SA1->A1_COD_MUN
			cCodUF		:= SA1->A1_EST
			cTipoCli	:= Alltrim(SA1->A1_CATEG)
			iF cCodRep = "0"
				cCodRep	:= SA1->A1_VEND
				cMsgMail += "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Codigo do vendedor veio com valor 0, atribuido o vendedor do cadastro do Cliente! cod -> " + cCodRep + Chr(13) + Chr(10)
				lEnvMail	:= .T.
			EndIf

		Else 
			ConOut( Replicate("-",150) )
			Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Nao foi encontrado o cliente! cod -> " + cCGC)
			ConOut( Replicate("-",150) )
			cMsgMail += "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Nao foi encontrado o cliente! cod -> " + cCGC + Chr(13) + Chr(10)
			lEnvMail	:= .T.
		EndIf
		nComissao		:= calcMarg(nMargem, cTipoCli)
		DbSelectArea("SE4")
		SE4->( DbSetOrder(1) )
		If SE4->( DbSeek( xFilial("SE4")+cCondPgWS ) )
			cCondPag := SE4->E4_CODIGO
			If cCondPag == "001"
				cCondPag := "609"
				cMsgMail += "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Nao foi encontrado a condição de pagamento! Foi atribuido o Cod -> " + cCondPag + Chr(13) + Chr(10)
				lEnvMail	:= .T.
			EndIf
		EndIf

		//==============================================================
		// Prencho os itens do pedido de venda do WS
		//==============================================================

		aItePV		:= aPedidos:_ITENS:_PEDIDOITEM

		cDoc := GetSxeNum("SC5","C5_NUM")
		RollBAckSx8()

		aCabec := {}
		aItens := {}

		aadd(aCabec,{"C5_FILIAL"   		,"01"    			,Nil })
		aadd(aCabec,{"C5_NUM"   		,cDoc				,Nil })
		aadd(aCabec,{"C5_TIPO" 			,"N"				,Nil })
		aadd(aCabec,{"C5_CLIENTE"		,cCliente			,Nil })
		aadd(aCabec,{"C5_LOJACLI"		,cLojaCli			,Nil })
		aadd(aCabec,{"C5_LOJAENT"		,cLojaCli			,Nil })
		aadd(aCabec,{"C5_CONDPAG"		,cCondPag			,Nil })
		aadd(aCabec,{"C5_POCKET"		,cNumPed			,Nil })
		aadd(aCabec,{"C5_MARGEM"		,nMargem			,Nil })
		aadd(aCabec,{"C5_COMIS1"		,nComissao			,Nil })
		aadd(aCabec,{"C5_MENPED"		,cMsgPed			,Nil })
		aadd(aCabec,{"C5_MENNOTA"		,cMsgNF				,Nil })
		If !empty(cCodPedCli) 
			aadd(aCabec,{"C5_NUMPCO"		,cCodPedCli			,Nil })
		EndIf

		//==============================================================
		// Vou percorrer todos os arrays de pedido
		//==============================================================

		If ValType( aItePV ) == "A"
			For nJ := 1 To Len( aItePV )

				//==============================================================
				// Prencho os itens do pedido de venda do WS
				//==============================================================

				cProduto	:= aItePV[nJ]:_codigoproduto:text
				nQtd		:= Val(aItePV[nJ]:_qtdpedida:text)
				nPrcVend	:= Round(Val(aItePV[nJ]:_valorunitarioliquido:text),2)
				nPrcLista	:= Round(Val(aItePV[nJ]:_valorunitariobruto:text),2)
				nValDesc	:= Val(aItePV[nJ]:_valordescontounitario:text)
				nPerDesc	:= Val(aItePV[nJ]:_PercentualDesconto:text)
				ItemCli     := aItePV[nJ]:_NumeroItemPedidoCliente:text

				aLinha := {}
				aadd(aLinha,{"C6_ITEM"			,StrZero(nJ,2)					, Nil})
				aadd(aLinha,{"C6_PRODUTO"		,StrZero(val(cProduto),6)		, Nil})
				aadd(aLinha,{"C6_QTDVEN"		,nQtd							, Nil})
				aadd(aLinha,{"C6_PRCVEN"		,nPrcVend						, Nil})
				aadd(aLinha,{"C6_VALOR"			,nQtd*nPrcVend					, Nil})
					If cbonifica = "true"
						aadd(aLinha,{"C6_OPER"			,"04"							, Nil})
					Else
						aadd(aLinha,{"C6_OPER"			,"01"							, Nil})
					EndIf
				aadd(aLinha,{"C6_DESCPR"		,nPerDesc						, Nil})  //Percentual de desconto comercial
				//aadd(aLinha,{"C6_VALDESC"		,nValDesc						, Nil})  //valor desconto comercial
				aadd(aLinha,{"C6_DESCVL"		,nValDesc						, Nil})
				aadd(aLinha,{"C6_PRUNIT"		,nPrcLista						, Nil})
				If !empty(ItemCli)
					aadd(aLinha,{"C6_ITEMPC"	,ItemCli						, Nil})
				EndIf				
				aadd(aItens,aLinha)
			Next nJ

		Else
			//==============================================================
			// Prencho os itens do pedido de venda do WS
			//==============================================================

			cProduto	:= aItePV:_codigoproduto:text
			nQtd		:= Val(aItePV:_qtdpedida:text)
			nPrcVend	:= Val(aItePV:_valorunitarioliquido:text)
			nValDesc	:= Val(aItePV:_valordescontounitario:text)
			nPrcLista	:= Round(Val(aItePV:_valorunitariobruto:text),2)
			nValDesc	:= Val(aItePV:_valordescontounitario:text)
			nPerDesc	:= Val(aItePV:_PercentualDesconto:text)
			ItemCli     := aItePV:_NumeroItemPedidoCliente:text

			aLinha := {}
			aadd(aLinha,{"C6_ITEM"			,"01"							, Nil})
			aadd(aLinha,{"C6_PRODUTO"		,StrZero(val(cProduto),6)		, Nil})
			aadd(aLinha,{"C6_QTDVEN"		,nQtd							, Nil})
			aadd(aLinha,{"C6_PRCVEN"		,nPrcVend						, Nil})
			aadd(aLinha,{"C6_VALOR"			,nQtd*nPrcVend					, Nil})
			If cbonifica == "true"
				aadd(aLinha,{"C6_OPER"			,"04"							, Nil})
			Else
				aadd(aLinha,{"C6_OPER"			,"01"							, Nil})
			EndIf							, Nil})
			aadd(aLinha,{"C6_DESCPR"		,nPerDesc						, Nil})  //Percentual de desconto comercial
			aadd(aLinha,{"C6_DESCVL"		,nValDesc						, Nil})
			//aadd(aLinha,{"C6_VALDESC"		,nValDesc						, Nil})  //valor desconto comercial
			aadd(aLinha,{"C6_PRUNIT"		,nPrcLista						, Nil})
			If !empty(ItemCli)
				aadd(aLinha,{"C6_ITEMPC"	,ItemCli						, Nil})
			EndIf
			aadd(aItens,aLinha)

		EndIf
		DbSelectArea("SC5")
		SC5->(DbSetOrder(10))
		If sc5->(dbseek("01"+cNumPed))
			pedipok := cNumPed
			fRetPT(oWsdl, pedipok)
		Else
			BEGIN TRANSACTION

				//MATA410(aCabec,aItens,3) //Inclui Pedido de vendas.
				msexecauto({|x,y,z| mata410(x,y,z)},aCabec,aItens,3)

			END TRANSACTION

			If !lMsErroAuto
				ConOut( Replicate("-",150) )
				Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Pedido Incluido com Sucesso!! " + cDoc)
				ConOut( Replicate("-",150) )
				fRetPV(oWsdl, cNumPed) //Marca pedido como importado
			Else
				ConOut( Replicate("-",150) )
				Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Erro na Inclusão!! " + MostraErro())
				ConOut( Replicate("-",150) )
				Mostraerro(cPath, cNomeArq) 
				cMsgMail += "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Erro na Inclusão! " + Chr(13) + Chr(10)
				email()
			EndIf
		EndIf
		sc5->(DbCloseArea())
	EndIf
Return

//===========================================
Static Function fRetPV(oWsdl, cNumPed)
	//===========================================

	Local aInput	:= {}
	Local aParam	:= {}
	Local aPedidos	:= {}
	Local cSoap		:= ""
	Local cError	:= ""
	Local cWarning	:= ""
	Local lRet		:= .F.
	Local oXML
	Local cMsg		:= ""

	xRet := oWsdl:SetOperation( "AtualizaPendenciaPedido" ) 
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif
//===========================================
Static Function fRetPT(oWsdl, pedipok)
	//===========================================

	Local aInput	:= {}
	Local aParam	:= {}
	Local aPedidos	:= {}
	Local cSoap		:= ""
	Local cError	:= ""
	Local cWarning	:= ""
	Local lRet		:= .F.
	Local oXML
	Local cMsg		:= ""

	xRet := oWsdl:SetOperation( "AtualizaPendenciaPedido" ) 
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	//==============================================================
	// Defino a variável necessaria para o parametro
	//==============================================================

	xRet := oWsdl:SetValue( 0, cNumPed )
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	//==============================================================
	// Envia a mensagem SOAP ao servidor
	//==============================================================

	xRet := oWsdl:SendSoapMsg()
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError )
		Return
	endif

	//==============================================================
	// Pega a mensagem de resposta
	//==============================================================

	cSoap		:= oWsdl:GetSoapResponse()
	aInput 		:= oWsdl:SimpleInput()
	oXML 		:= XmlParser( cSoap, "_", @cError, @cWarning )
	cRetWS  	:= oxml:_SOAP_ENVELOPE:_SOAP_BODY:_ATUALIZAPENDENCIAPEDIDORESPONSE:_ATUALIZAPENDENCIAPEDIDORESULT:TEXT

	ConOut( Replicate("-",150) )
	Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ "| Pedido -> " + cNumPed + " | Retorno do WS -> "+ cRetWS )
	ConOut( Replicate("-",150) )

	cMsgMail += "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Retorno do status de atualizar a pendencia dos pedido -> " + cNumPed + "   Retorno -> " + cRetWS + Chr(13) + Chr(10)

Return lRet


Static Function email()


	Local cAccount    := GetMv("MV_RELACNT")
	Local cServer   := GetMv("MV_RELSERV")
	Local cPassword := GetMv("MV_RELPSW")
	Local cAssunto := "Informação sobre importação de pedidos do FocoPDV Pedido -> " + cNumPed
	cPara := "importacaofocopdv@vitamedic.ind.br"

	_cMsg := '</table>'
	_cMsg += '<br><br>'
	_cMsg += '<font face="Arial Black" size="4">  '+SM0->M0_NOME+ '</font> <br>'
	_cMsg += '<br>'
	_cMsg += '<font face="Arial" size="2"> Importação dos Pedidos: em '+dtoc(date())+ " às " + Time() +'</font> <br>'
	_cMsg += '<br>'
	_cMsg += '<font face="Arial" size="2"> Segue em anexo o LOG com as informações do processo de imoprtação de Pedido</font> <br>'
	_cMsg += '<br>'
	_cMsg += '<table border=1 width=700>'
	_cMsg += '<tr>'
	_cMsg += '<td rowspan=2 width=80>'+cMsgMail+'</td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '</table>'
	_cMsg += '<br>'
	_cMsg += '<font face="Arial" size="1"> Este e-mail foi gerado automaticamente pelo sistema, favor não responder.</b></font> <br>'
	_cMsg += '</body>'
	_cMsg += '</html>'

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	MailAuth(cAccount,cPassword) 
	SEND MAIL FROM cAccount TO cPara SUBJECT cAssunto BODY _cMsg ATTACHMENT cAnexo RESULT lEnviado

	If lEnviado
		ConOut( Replicate("-",150) )
		Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ "| Pedido -> " + cNumPed + " | E-mail com erros enviado com sucesso -> ")
		ConOut( Replicate("-",150) )		
	EndIf

return()

Static Function calcMarg(nMargem, cTipoCli)
	Local nValor := 0

	If cTipoCli = "F"
		If nMargem <= 29.99
			nValor	:= 1
		ElseIf nMargem >= 30 .and. nMargem <= 34.99
			nValor	:= 2
		ElseIf nMargem >= 35 .and. nMargem <= 39.99
			nValor	:= 3
		ElseIf nMargem >= 40 .and. nMargem <= 44.99
			nValor	:= 4
		ElseIf nMargem >= 45 .and. nMargem <= 49.99
			nValor	:= 5
		ElseIf nMargem >= 50 .and. nMargem <= 54.99
			nValor	:= 6
		ElseIf nMargem > 55
			nValor	:= 7
		Else
			nValor	:= 0
		EndIf
	ElseIf cTipoCli = "H"
		If nMargem >= 0 .and. nMargem <= 29.99
			nValor	:= 1
		ElseIf nMargem >= 30 .and. nMargem <= 34.99
			nValor	:= 2
		ElseIf nMargem >= 35 .and. nMargem <= 39.99
			nValor	:= 3
		ElseIf nMargem >= 40 .and. nMargem <= 44.99
			nValor	:= 4
		ElseIf nMargem >= 45 .and. nMargem <= 49.99
			nValor	:= 5
		ElseIf nMargem > 50
			nValor	:= 6
		Else
			nValor	:= 0
		EndIf
	Else
		cMsgMail += "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Nao foi encontrado Tipo de Cliente para atribuir % de comissão, o valor ficou zerado, Tipo do Cliente -> " + cTipoCli + Chr(13) + Chr(10)
	EndIf

Return(nValor)


// Stephen Noel de Melo Ribeiro 18/12/2018
//==============================================================//
Static Function fRetoPV( _npedido, _nproduto, _nquant, _nnota,_serie,_cliente,_loja )
	//==============================================================//
	Local oWsdl
	Local xRet
	Local cSoap		:= ""
	Local cError	:= ""
	Local cWarning	:= ""
	Local lRet		:= .F.
	Local oXML 		//:= XmlParser( cM, "_", @cError, @cWarning )
	Local cMsg		:= ""
	Local nQtdReg   := 0
	Local aComplex	:= {}

	ConOut( Replicate("-",150) )
	Conout( "[WS_INTFOCO] Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " | Execulta a função fRetoPV " )
	ConOut( Replicate("-",150) )

	oWSDL := tWSDLManager():New()
	// Faz o parse de uma URL
	xRet := oWsdl:ParseURL( "http://focopdv.vitamedic.ind.br/vitamedic/WSrv_ListaPedidos/ListaPedidos.asmx?WSDL" )
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError, procline() )
		Return
	endif

	xRet := oWsdl:SetOperation( "AtualizaRetornoPedido" ) 
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError, procline() )
		Return
	EndIf
	cMsg := "<soap:Envelope xmlns:soap='http://www.w3.org/2003/05/soap-envelope' xmlns:pdv='http://www.pdvlink.com.br/'> "+ CRLF
	cMsg += "<soap:Header/> "+ CRLF
	cMsg += "<soap:Body> "+ CRLF
	cMsg += "  <pdv:AtualizaRetornoPedido> "+ CRLF
	cMsg += "     <!--Optional:--> "+ CRLF
	cMsg += "     <pdv:retornoPedido> "+ CRLF
	cMsg += "       <pdv:CodigoPedido> "+ alltrim(_npedido) +" </pdv:CodigoPedido> "+ CRLF
	cMsg += "        <!--Optional:--> "+ CRLF
	cMsg += "        <pdv:Itens> "+ CRLF
	cMsg += "           <!--Zero or more repetitions:--> "+ CRLF
	cMsg += "           <pdv:RetornoPedidoItem> "+ CRLF
	cMsg += "              <pdv:CodigoProduto>"+ alltrim(_nproduto) +"</pdv:CodigoProduto> "+ CRLF
	cMsg += "              <pdv:QtdFaturada>"+ cvaltochar(_nquant) +"</pdv:QtdFaturada> "+ CRLF
	cMsg += "              <!--Optional:--> "+ CRLF
	cMsg += "              <pdv:MotivoNaoAtendimento>?</pdv:MotivoNaoAtendimento> "+ CRLF
	cMsg += "           </pdv:RetornoPedidoItem> "+ CRLF
	cMsg += "        </pdv:Itens> "+ CRLF
	cMsg += "     </pdv:retornoPedido> "+ CRLF
	cMsg += "  </pdv:AtualizaRetornoPedido> "+ CRLF
	cMsg += "</soap:Body> "+ CRLF
	cMsg += "</soap:Envelope> "+ CRLF

	// Envia uma mensagem SOAP personalizada ao servidor
	xRet := oWsdl:SendSoapMsg(cMsg)
	if xRet == .F.
		conout( "Erro: " + oWsdl:cError,procline() )
		Return
	EndIf
	If xRet == .T.
		DbSelectArea("SD2") 
		SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM                                                                                                     
		if SD2->(DbSeek(xFilial("SD2")+_nnota+_serie+_cliente+_loja+_nproduto ))
			While sd2->d2_doc = _nnota .and. sd2->d2_serie = _serie .and. sd2->d2_cod = _nproduto
				RECLOCK("SD2", .F.)  
				SD2->D2_NRECAGR:= "OK"
				MSUNLOCK()
				If sd2->d2_cod <> _nproduto
					Exit
				EndIf
				sd2->(DbSkip())
			EndDo
		EndIf
		SD2->(DbCloseArea())
	endif
	//==============================================================
	// Pega a mensagem de resposta
	//==============================================================
	conout(oWsdl:GetSoapResponse())
	//	cSoap		:= oWsdl:GetSoapResponse()
	//	aInput 		:= oWsdl:SimpleInput()
	//	oXML 		:= XmlParser( cSoap, "_", @cError, @cWarning )
	//	cRetWS  	:= oxml:_SOAP_ENVELOPE:_SOAP_BODY:_AtualizaRetornoPedidoResponse:_AtualizaRetornoPedidoResult:TEXT

Return
//==============================================================//
static function criatmp1()
	//==============================================================//
	_cquery := " SELECT "
	_cquery += " C5_NUM PEDPROT,SC5.C5_POCKET PEDIDO,SD2.D2_DOC NOTA, SD2.D2_COD PRODUTO, SD2.D2_CLIENTE CLI, D2_LOJA LOJA, SD2.D2_SERIE SERIE, "
	_cquery += " SUM(SD2.D2_QUANT + NVL((SELECT SUM(D2_QUANT) FROM SD2010 SD22 WHERE SD22.D2_PEDIDO = SC5.C5_NUM AND SD2.D2_COD = SD22.D2_COD AND SD22.D_E_L_E_T_ = ' '  AND SD22.D2_NRECAGR <> ' '),0)) QUANT "
	_cquery += " FROM SC5010 SC5 " 
	_cquery += " INNER JOIN SD2010 SD2 ON SD2.D2_PEDIDO = SC5.C5_NUM  AND SD2.D_E_L_E_T_ = ' '  AND SD2.D2_NRECAGR = ' ' "  
	_cquery += " WHERE SC5.D_E_L_E_T_ = ' ' "
	_cquery += " AND LENGTH(TRIM(SC5.C5_POCKET)) = 6 "
	_cquery += " GROUP BY C5_NUM ,SC5.C5_POCKET ,SD2.D2_DOC ,SD2.D2_COD ,SD2.D2_CLIENTE ,D2_LOJA ,SD2.D2_SERIE,SD2.D2_NRECAGR "
	_cquery += " ORDER BY SD2.D2_DOC, SD2.D2_COD,SD2.D2_NRECAGR "

	_cquery:=changequery(_cquery)
	TcQuery _cquery New Alias "TMP1"
	memowrite("C:/Stephen/ws_intfoco.txt",_cquery)

Return
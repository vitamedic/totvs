#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "apwebex.ch"


//----------------------------------------------------------------------------
// Defini��o dos metodos e Cria��o do WS Integra�ao fom FPW
//----------------------------------------------------------------------------
WSSERVICE WS_INTWMS2 DESCRIPTION " Fun��es para integra��o Protheus  x WSM Evolutio" 
/*
	WSDATA 	Fil_Endereco		as WSFilEndereco 
	WSDATA  Ret_Endereco		as WSRet_Endereco

	WSDATA 	Fil_TpProd			as WSFilEmp 
	WSDATA  Ret_TpProd			as WSRet_TpProd

	WSDATA 	Fil_Produtos		as WSFilProdutos
	WSDATA  Ret_Produtos		as WSRet_Produtos

	WSDATA 	Fil_Lotes			as WSFilLotes
	WSDATA  Ret_Lotes			as WSRet_Lotes
	
	WSDATA 	Fil_Estoque			as WSFilEstoque
	WSDATA  Ret_Estoque			as WSRet_Estoque

	WSDATA 	Fil_OP				as WSFilOp
	WSDATA  Ret_OP				as WSRet_Op

	WSDATA 	Fil_ItensOP			as WSFilItensOp
	WSDATA  Ret_ItensOP			as WSRet_ItensOp

	WSDATA 	Fil_HeadEStru		as WSFilHeadEStru
	WSDATA  Ret_HeadEStru		as WSRet_HeadEStru

	WSDATA 	Fil_ReviStru		as WSFilRevEStru
	WSDATA  Ret_ReviStru		as WSRet_ReviStru
	
	WSDATA 	Fil_Cliente			as WSFilCliente 
	WSDATA  Ret_Cliente			as WSRet_Cliente 

	WSDATA 	Fil_Transportadora	as WSFilTransportadora
	WSDATA  Ret_Transportadora	as WSRet_Transportadora 

	WSDATA 	Fil_Fornecedor		as WSFilFornecedor
	WSDATA  Ret_Fornecedor		as WSRet_Fornecedor

	WSDATA 	Fil_OS				as WSFilOS
	WSDATA  Ret_OS				as WSRet_OSHead

	WSDATA 	Fil_ItensOS			as WSFilItensOS
	WSDATA  Ret_ItensOS			as WSRet_ItensOS

	WSDATA 	Fil_DUN14			as WSFil_DUN14
	WSDATA  Ret_DUN14			as WSRet_DUN14

	WSDATA 	Env_Enderecar		as WSEnderecamento

	WSDATA 	Env_Empenho 		as WSEmpenhos

	WSDATA 	Env_Transferir		as WSTransferir

	WSDATA 	RetProcWS			as WSProcRet

	WSDATA  Env_MovInterno		as WSMovInterno

	WSDATA  Env_ApontaOP		as WSApontaOP

	WSDATA  Env_StatusOS		as WSStatusOs

	WSDATA  Env_TrocaLote		as WSTrocaLote

	WSMETHOD CONSULTA_ENDERECO  		DESCRIPTION "Metodo para consultar endere�os de um armaz�m." 
	WSMETHOD CONSULTA_TIPOPROD			DESCRIPTION "Metodo para consultar tipos de produtos." 
	WSMETHOD CONSULTA_PRODUTOS			DESCRIPTION "Metodo para consultar cadastro de produtos." 
	WSMETHOD CONSULTA_LOTES				DESCRIPTION "Metodo para consultar cadastro de lotes." 
	WSMETHOD CONSULTA_ESTOQUE			DESCRIPTION "Metodo para consultar saldos em estoque por produto, armaz�m e endereco." 
	WSMETHOD CONSULTA_OP				DESCRIPTION "Metodo para consultar cabe�alho da ordem de produ��o." 
	WSMETHOD CONSULTA_ITENSOP			DESCRIPTION "Metodo para consultar itens da estrutura da ordem de produ��o." 
	WSMETHOD CONSULTA_REVISAO			DESCRIPTION "Metodo para consultar revis�es de estruturas de produtos." 
	WSMETHOD CONSULTA_ESTRUTURA			DESCRIPTION "Metodo para consultar estrutura de um produto na ultima revis�o." 

	WSMETHOD CONSULTA_CLIENTE  			DESCRIPTION "Metodo para consultar cliente do pedido." 
	WSMETHOD CONSULTA_TRANSPORTADORA	DESCRIPTION "Metodo para consultar cliente do pedido." 
	WSMETHOD CONSULTA_FORNECEDOR		DESCRIPTION "Metodo para consultar fornecedor." 
	WSMETHOD CONSULTA_OS_CAB			DESCRIPTION "Metodo para consultar cabe�alho da ordem de separa��o." 
	WSMETHOD CONSULTA_OS_ITENS			DESCRIPTION "Metodo para consultar itens da ordem de separa��o." 
	WSMETHOD CONSULTA_DUN14				DESCRIPTION "Metodo para consultar c�digo DUN14 dos produtos expedidos." 

	WSMETHOD ENDERECAMENTO				DESCRIPTION "Metodo para processar o endere�amento de produtos com saldo a endere�ar." 
	WSMETHOD EMPENHOS_OP				DESCRIPTION "Metodo para processar a inclusao de empenho de uma ordem de produ��o." 
	WSMETHOD TRANSFERENCIA				DESCRIPTION "Metodo para processar transferencia de saldo de um endere�o/armazem para outro." 

	WSMETHOD MV_INTERNO_INVENTARIO		DESCRIPTION "Metodo para processar movimenta��es internas e ajuste de invet�rio." 
	WSMETHOD APONTAMENTO_OP				DESCRIPTION "Metodo para processar o apontamento da pesagem das ordens de produ��o." 
	WSMETHOD STATUS_OS					DESCRIPTION "Metodo para processar o status da ordem de serapa��o." 
	WSMETHOD TROCA_LOTE					DESCRIPTION "Metodo para processar a troca de lotes das ordens de separa��o." 
 
ENDWSSERVICE

WSSTRUCT WSFilEmp
	WSDATA 	cEmpresa	as String Optional
	WSDATA 	cParFil		as String Optional	 
ENDWSSTRUCT 

WSSTRUCT WSProcRet
	WSDATA 	SITUACAO	as Boolean	 
	WSDATA 	MENSAGEM	as String	
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_ENDERECO WSRECEIVE Fil_Endereco  WSSEND Ret_Endereco WSSERVICE WS_INTWMS2
	conout("CONSULTA_ENDERECO In:" ) 
	
	U_UWSWMS01(@::Fil_Endereco, @::Ret_Endereco)
	    
	conout("CONSULTA_ENDERECO Out:" +::Ret_Endereco:cErros) 

Return(.T.)

WSSTRUCT WSFilEndereco
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	cArmazem		as String Optional
	WSDATA 	cEnderecoDe		as String Optional	
	WSDATA 	cEnderecoAte	as String Optional	
ENDWSSTRUCT

WSSTRUCT WSEndereco
	WSDATA 	CODIGO		as String	 
	WSDATA 	ARMAZEM		as String	
	WSDATA 	STATUS		as String	
	WSDATA 	TIPO		as String	
	WSDATA 	AREA		as String	
ENDWSSTRUCT

WSSTRUCT WSRet_Endereco
	WSDATA 	aRet			as Array of WSEndereco Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_TIPOPROD WSRECEIVE Fil_TpProd  WSSEND Ret_TpProd WSSERVICE WS_INTWMS2
	conout("CONSULTA_TIPOSPR In:" ) 
	
	U_UWSWMS02(@::Fil_TpProd, @::Ret_TpProd)
	    
	conout("CONSULTA_TIPOSPR Out:" +::Ret_TpProd:cErros) 

Return(.T.) 

WSSTRUCT WSTpProd
	WSDATA 	cCodigo		as String	 
	WSDATA 	cDescricao	as String	
ENDWSSTRUCT

WSSTRUCT WSRet_TpProd
	WSDATA 	aRet			as Array of WSTpProd Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String 
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT  

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_PRODUTOS WSRECEIVE Fil_Produtos  WSSEND Ret_Produtos WSSERVICE WS_INTWMS2

	conout("CONSULTA_PRODUTOS In:" ) 
	
	U_UWSWMS03(@::Fil_Produtos, @::Ret_Produtos)
	    
	conout("CONSULTA_PRODUTOS Out:" +::Ret_Produtos:cErros) 

Return(.T.) 

WSSTRUCT WSFilProdutos
	WSDATA 	cEmpresa	as String Optional
	WSDATA 	cParFil		as String Optional
	WSDATA 	cCodigo		as String Optional
	WSDATA 	cDescricao	as String Optional	
	WSDATA 	cBarras		as String Optional	
ENDWSSTRUCT

WSSTRUCT WSProdutos
	WSDATA 	CODIGO		 as String	 
	WSDATA 	DESCRICAO	 as String	
	WSDATA 	TIPO		 as String	
	WSDATA 	CODBARRAS	 as String	
	WSDATA 	QTDCX		 as Float 
	WSDATA 	UM			 as String	
	WSDATA 	DCB			 as String	
	WSDATA 	TEMPERATURA	 as String
	WSDATA 	HUMIDADE	 as String
	WSDATA 	FORMAFARM	 as String
	WSDATA  COD_RESUMIDO as String 
	
ENDWSSTRUCT

WSSTRUCT WSRet_Produtos
	WSDATA 	aRet			as Array of WSProdutos Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_LOTES WSRECEIVE Fil_Lotes  WSSEND Ret_Lotes WSSERVICE WS_INTWMS2

	conout("CONSULTA_LOTES In:" ) 
	
	U_UWSWMS04(@::Fil_Lotes, @::Ret_Lotes)
	    
	conout("CONSULTA_LOTES Out:" +::Ret_Lotes:cErros) 

Return(.T.)

WSSTRUCT WSFilLotes
	WSDATA 	cEmpresa	as String Optional
	WSDATA 	cParFil		as String Optional
	WSDATA 	cLoteDe		as String Optional	
	WSDATA 	cLoteAte	as String Optional	
	WSDATA 	cCodProd	as String 	
ENDWSSTRUCT

WSSTRUCT WSLotes
	WSDATA 	NUM_LOTE	as String	 
	WSDATA 	DATA_FAB	as String	
	WSDATA 	DATA_VALID	as String	
	WSDATA 	STATUS_LOTE	as String	
	WSDATA 	COD_PROD	as String	
	WSDATA 	DESC_PROD	as String	
	WSDATA 	COD_FOR		as String	
	WSDATA 	NOME_FOR	as String	
	WSDATA 	LOTE_FOR	as String	
ENDWSSTRUCT

WSSTRUCT WSRet_Lotes
	WSDATA 	aRet			as Array of WSLotes Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_ESTOQUE WSRECEIVE Fil_Estoque  WSSEND Ret_Estoque WSSERVICE WS_INTWMS2

	conout("CONSULTA_ESTOQUE In:" ) 
	
	U_UWSWMS05(@::Fil_Estoque, @::Ret_Estoque)
	    
	conout("CONSULTA_ESTOQUE Out:" +::Ret_Estoque:cErros) 

Return(.T.) 

WSSTRUCT WSFilArray
	WSDATA 	cFiltro	as String 
ENDWSSTRUCT

WSSTRUCT WSFilEstoque
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	cProduto		as String Optional
	WSDATA 	cNumLote		as String Optional	
	//WSDATA 	cArmazem		as String Optional	
	//WSDATA 	cEndereco		as String Optional	

	WSDATA 	aArmazens		as Array Of WSFilArray Optional	
	WSDATA 	aEnderecos		as Array Of WSFilArray Optional	

ENDWSSTRUCT

WSSTRUCT WSSldEstoque
	WSDATA 	FILIAL		as String	 
	WSDATA 	NUMLOTE		as String	
	WSDATA 	PRODUTO		as String	
	WSDATA 	DESC_PROD	as String	
	WSDATA 	DATA_FAB	as String	
	WSDATA 	DATA_VALID	as String	
	WSDATA 	DATA_RETESTE as String	
	WSDATA 	POTENCIA	as Float	
	WSDATA 	STATUS_LOTE	as String	
	WSDATA 	ARMAZEM		as String	
	WSDATA 	ENDERECO	as String	
	WSDATA 	QTD_DISP	as Float	
	WSDATA 	UNID_MED	as String	
	WSDATA 	STATUS_ARMAZEM	as String	
	WSDATA 	FAT_CONV	as Float	
	WSDATA 	FORNECEDOR	as String	
	WSDATA 	NOME_FORNEC	as String	
	WSDATA 	LOTE_FORNEC	as String	
	WSDATA 	LOTE_FABRIC	as String	
	WSDATA 	FABRICANTE	as String	
	WSDATA 	DESC_FABRIC	as String	
ENDWSSTRUCT

WSSTRUCT WSRet_Estoque
	WSDATA 	aRet			as Array of WSSldEstoque Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_OP WSRECEIVE Fil_OP  WSSEND Ret_OP WSSERVICE WS_INTWMS2

	conout("CONSULTA_OP In:" ) 
	
	U_UWSWMS06(@::Fil_OP, @::Ret_OP)
	    
	conout("CONSULTA_OP Out:" +::Ret_OP:cErros) 

Return(.T.)

WSSTRUCT WSFilOp
	WSDATA 	cEmpresa	as String Optional
	WSDATA 	cParFil		as String Optional
	WSDATA 	cNumOp		as String Optional
	WSDATA 	cDataDe		as String Optional	
	WSDATA 	cDataAte	as String Optional	
	WSDATA 	cCodProd	as String Optional	
	WSDATA 	cNumLote	as String Optional	
ENDWSSTRUCT

WSSTRUCT WSOp
	WSDATA 	FILIAL		as String	 
	WSDATA 	NUM_OP		as String	 
	WSDATA 	COD_PROD	as String	 
	WSDATA 	DESC_PROD	as String	
	WSDATA 	NUM_LOTE	as String	
	WSDATA 	QTD			as Float 
	WSDATA 	UM			as String	
	WSDATA 	DATA_EMIS	as String	
	WSDATA 	STATUS_OP	as String	
	WSDATA 	NUM_REVIS1	as String	
	WSDATA 	TIPO_OP		as String	
	WSDATA 	NUM_REVIS2	as String	
ENDWSSTRUCT

WSSTRUCT WSRet_Op
	WSDATA 	aRet			as Array of WSOp Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_ITENSOP WSRECEIVE Fil_ItensOP  WSSEND Ret_ItensOP WSSERVICE WS_INTWMS2

	conout("CONSULTA_ITENSOP In:" ) 
	
	U_UWSWMS07(@::Fil_ItensOP, @::Ret_ItensOP)
	    
	conout("CONSULTA_ITENSOP Out:" +::Ret_ItensOP:cErros)

Return(.T.)

WSSTRUCT WSFilItensOp
	WSDATA 	cEmpresa	as String Optional
	WSDATA 	cParFil		as String Optional
	WSDATA 	cNumOp		as String Optional
	WSDATA 	cTpProd		as String Optional
ENDWSSTRUCT

WSSTRUCT WSItensOp
	WSDATA 	FILIAL		 		as String	 
	WSDATA 	NUM_OP		 		as String	 
	WSDATA 	SEQ_ESTRU	 		as String	 
	WSDATA 	COD_ITEM	 		as String	 
	WSDATA 	QTD_REQ		 		as Float 
	WSDATA 	QTD_ALOCADA	 		as Float 
	WSDATA 	LOTE_PREALOC 		as String	
	WSDATA 	LOCAL_LOTE_PREALOC 	as String	
	WSDATA 	DEP_LOTE_PREALOC 	as String	
	WSDATA 	QTD_ATEND	 		as Float  
	WSDATA 	FASE_OPER		 	as String	
	WSDATA 	LINHA_DO_BOM	 	as String	
	WSDATA 	DESC_ITEM	 		as String	
	WSDATA 	UM_ITEM			 	as String	
	WSDATA 	CLASSE_ITEM	 		as String	
	WSDATA 	POTENC_ITEM	 		as Float
	WSDATA 	STATUS_OP	 		as String	
	WSDATA 	UM_ESTQ_ITEM	 	as String	
	WSDATA 	TIPO_ITEM		 	as String	
ENDWSSTRUCT

WSSTRUCT WSRet_ItensOp
	WSDATA 	aRet			as Array of WSItensOp Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_REVISAO WSRECEIVE Fil_ReviStru  WSSEND Ret_ReviStru WSSERVICE WS_INTWMS2

	conout("CONSULTA_REVISAO In:" ) 
	
	U_UWSWMS08(@::Fil_ReviStru, @::Ret_ReviStru)
	    
	conout("CONSULTA_REVISAO Out:" +::Ret_ReviStru:cErros) 

Return(.T.)  

WSSTRUCT WSReviStru
	WSDATA 	FILIAL			as String	Optional 
	WSDATA 	COD_PROD		as String	Optional 
	WSDATA 	COD_ITEM		as String	Optional 
	WSDATA 	UM_ITEM			as String	Optional 
	WSDATA 	DESC_ITEM		as String	Optional 
	WSDATA 	SEQ_ITEM		as String	Optional
	WSDATA 	OPC_GRUP		as String	Optional
	WSDATA 	OPC_ITEM		as String	Optional
	WSDATA 	NUM_REV			as String	Optional
	WSDATA 	NUM_VERSAO		as String	Optional 
	WSDATA 	QTD_BASE		as Float	Optional 
	WSDATA 	POTENCIA		as Float	Optional 
	WSDATA 	STATUS_ESTRU	as String	Optional 
	WSDATA 	CLASSE			as String	Optional 
ENDWSSTRUCT

WSSTRUCT WSFilRevEStru
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	cCodProd		as String 
	WSDATA 	nQtdRequerida	as Float Optional
ENDWSSTRUCT

WSSTRUCT WSRet_ReviStru
	WSDATA 	aRet			as Array of WSReviStru Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_ESTRUTURA WSRECEIVE Fil_HeadEStru  WSSEND Ret_HeadEStru WSSERVICE WS_INTWMS2

	conout("CONSULTA_ESTRUTURA In:" ) 
	
	U_UWSWMS09(@::Fil_HeadEStru, @::Ret_HeadEStru)
	    
	conout("CONSULTA_ESTRUTURA Out:" +::Ret_HeadEStru:cErros) 

Return(.T.) 

WSSTRUCT WSFilHeadEStru
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	cCodProd		as String 
ENDWSSTRUCT

WSSTRUCT WSHeadEStru
	WSDATA 	FILIAL			as String	 
	WSDATA 	COD_PROD		as String	
	WSDATA 	NUM_REV			as String	 
	WSDATA 	NUM_VERSAO		as String	 
	WSDATA 	QTD_BASE		as Float
	WSDATA 	UM_PROD			as String	
	WSDATA 	STATUS_ESTRU	as String	
	WSDATA 	DATA_CRIA		as String	
	WSDATA 	DATA_VALID		as String	
	WSDATA 	DESC_PROD		as String	
ENDWSSTRUCT

WSSTRUCT WSRet_HeadEStru
	WSDATA 	aRet			as Array of WSHeadEStru Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_CLIENTE WSRECEIVE Fil_Cliente  WSSEND Ret_Cliente WSSERVICE WS_INTWMS2
	conout("CONSULTA_CLIENTE In:" ) 
	
	U_UWSWMS10(@::Fil_Cliente, @::Ret_Cliente)
	    
	conout("CONSULTA_CLIENTE Out:" +::Ret_Cliente:cErros) 

Return(.T.)

WSSTRUCT WSFilCliente
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	cCodigo			as String Optional
ENDWSSTRUCT

WSSTRUCT Ret_Clientes
	WSDATA 	CODIGO		as String	 
	WSDATA 	RAZAOSOCIAL	as String	
ENDWSSTRUCT

WSSTRUCT WSRet_Cliente 
	WSDATA 	aRet			as Array of Ret_Clientes Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_TRANSPORTADORA WSRECEIVE Fil_Transportadora  WSSEND Ret_Transportadora WSSERVICE WS_INTWMS2
	conout("CONSULTA_TRANSPORTADORA In:" ) 
	
	U_UWSWMS11(@::Fil_Transportadora, @::Ret_Transportadora)
	    
	conout("CONSULTA_TRANSPORTADORA Out:" +::Ret_Transportadora:cErros) 

Return(.T.)

WSSTRUCT WSFilTransportadora
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	cCodigo			as String Optional
ENDWSSTRUCT

WSSTRUCT Arr_Transportadoras
	WSDATA 	CODIGO		as String	 
	WSDATA 	RAZAOSOCIAL	as String	
ENDWSSTRUCT

WSSTRUCT WSRet_Transportadora
	WSDATA 	aRet			as Array of Arr_Transportadoras Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_FORNECEDOR WSRECEIVE Fil_Fornecedor  WSSEND Ret_Fornecedor WSSERVICE WS_INTWMS2
	conout("CONSULTA_FORNECEDOR In:" ) 
	
	U_UWSWMS12(@::Fil_Fornecedor, @::Ret_Fornecedor)
	    
	conout("CONSULTA_FORNECEDOR Out:" +::Ret_Fornecedor:cErros) 

Return(.T.)

WSSTRUCT WSFilFornecedor
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	cCodigo			as String Optional
ENDWSSTRUCT

WSSTRUCT Arr_Fornecedores
	WSDATA 	CODIGO		as String	 
	WSDATA 	RAZAOSOCIAL	as String	
ENDWSSTRUCT

WSSTRUCT WSRet_Fornecedor
	WSDATA 	aRet			as Array of Arr_Fornecedores Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_OS_CAB WSRECEIVE Fil_OS WSSEND Ret_OS WSSERVICE WS_INTWMS2
	conout("CONSULTA_OS In:" ) 
	
	U_UWSWMS13(@::Fil_OS, @::Ret_OS)
	    
	conout("CONSULTA_OS Out:" +::Ret_OS:cErros) 

Return(.T.)

WSSTRUCT WSFilOS
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	cPedido			as String 
ENDWSSTRUCT

WSSTRUCT WSRet_OS
	WSDATA 	NUM_OS			as String	 
	WSDATA 	TIPO_OS			as String	 
	WSDATA 	COD_CLIENTE		as String	 
	WSDATA 	NOME_CLIENTE	as String	 
	WSDATA 	ENTREGA_UF		as String	 
	WSDATA 	ENTREGA_CID		as String	 
	WSDATA 	ENTREGA_ENDER	as String	 
	WSDATA 	ENTREGA_BAIR	as String	 
	WSDATA 	ENTREGA_CEP		as String	 
	WSDATA 	COD_TRANSP		as String	 
	WSDATA 	NOME_TRANSP		as String	 
	WSDATA 	CAMINHAO		as String	 
	WSDATA 	VLR_TOTAL		as Float 
	WSDATA 	PESO_TOTAL		as Float 
	WSDATA 	NR_ITENS		as Float 
	WSDATA 	NR_VOLUMES		as Float 
	WSDATA 	ALOCACAO		as String
	WSDATA 	ARMAZEM			as String
	WSDATA 	DT_EMISSAO		as String
	WSDATA 	DT_LIBERACAO	as String
	
ENDWSSTRUCT

WSSTRUCT WSRet_OSHead
	WSDATA 	aRet			as Array of WSRet_OS Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_OS_ITENS WSRECEIVE Fil_ItensOS WSSEND Ret_ItensOS WSSERVICE WS_INTWMS2
	conout("CONSULTA_OS_ITENS In:" ) 
	
	U_UWSWMS14(@::Fil_ItensOS, @::Ret_ItensOS)
	    
	conout("CONSULTA_OS_ITENS Out:" +::Ret_ItensOS:cErros) 

Return(.T.)

WSSTRUCT WSFilItensOS
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	cPedido			as String 
ENDWSSTRUCT

WSSTRUCT Ret_ItensOS
	WSDATA 	NUM_OS			as String	 
	WSDATA 	NUM_ITEM		as String	 
	WSDATA 	COD_ITEM		as String	 
	WSDATA 	DESC_ITEM		as String	 
	WSDATA 	UM_ITEM			as String	 
	WSDATA 	ABREV_ITEM		as String	 
	WSDATA 	LOTE			as String	 
	WSDATA 	ARMAZEM			as String
	WSDATA 	ENDERECO		as String
	WSDATA 	QUANT			as Float 
	WSDATA 	VLR_UNIT		as Float 
	WSDATA 	PESO_UNIT		as Float 
ENDWSSTRUCT

WSSTRUCT WSRet_ItensOS
	WSDATA 	aRet			as Array of Ret_ItensOS Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONSULTA_DUN14 WSRECEIVE Fil_DUN14 WSSEND Ret_DUN14 WSSERVICE WS_INTWMS2
	conout("CONSULTA_DUN14 In:" ) 
	
	U_UWSWMS15(@::Fil_DUN14, @::Ret_DUN14)
	    
	conout("CONSULTA_DUN14 Out:" +::Ret_DUN14:cErros) 

Return(.T.)

WSSTRUCT WSFil_DUN14
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	cCodigo			as String 
ENDWSSTRUCT

WSSTRUCT WSDUN14
	WSDATA 	DUN14		 	as String	 
	WSDATA 	CODIGO		 	as String	 
	WSDATA 	CODBARRAS	 	as String	
	WSDATA 	UM			 	as String	
	WSDATA 	LOTE		 	as String	
	WSDATA 	ARMAZEM	 		as String
	WSDATA 	ENDERECO	 	as String
	WSDATA 	VOLUME		 	as Float 
	WSDATA 	QUANT		 	as Float 
ENDWSSTRUCT

WSSTRUCT WSRet_DUN14
	WSDATA 	aRet			as Array of WSDUN14 Optional
	WSDATA 	lRet			as Boolean
	WSDATA 	cErros			as String
	WSDATA 	nQtdReg			as Integer
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD ENDERECAMENTO WSRECEIVE Env_Enderecar  WSSEND RetProcWS WSSERVICE WS_INTWMS2

	U_UWSWMS50(@::Env_Enderecar, @::RetProcWS)
	    
Return(.T.) 

WSSTRUCT WSEnderecamento
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	PRODUTO			as String 
	WSDATA 	LOTE			as String 
	WSDATA 	ARMAZEM			as String 
	WSDATA 	ENDERECOS		as Array of ENDERECO
ENDWSSTRUCT

WSSTRUCT ENDERECO
	WSDATA 	CODIGO		as String	 
	WSDATA 	QUANTIDADE	as Float	
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD EMPENHOS_OP WSRECEIVE Env_Empenho  WSSEND RetProcWS WSSERVICE WS_INTWMS2

	U_UWSWMS51(@::Env_Empenho, @::RetProcWS)

Return(.T.) 

WSSTRUCT WSEmpenhos
	WSDATA 	cEmpresa		as String Optional
	WSDATA 	cParFil			as String Optional
	WSDATA 	NUM_OP			as String 
	WSDATA 	PRODUTOS		as Array of PRODUTO_OP
ENDWSSTRUCT

WSSTRUCT PRODUTO_OP
	WSDATA 	CODIGO		as String	 
	WSDATA 	LOTE		as String
	WSDATA 	QUANTIDADE	as Float	
	WSDATA 	SEQUENCIA	as String Optional
	WSDATA 	ARMAZEM		as String
	WSDATA  OPERACAO    as String
	WSDATA  ENDERECOS	as Array of ENDERECO
	WSDATA 	POTENCIA	as Float Optional	
ENDWSSTRUCT 

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD TRANSFERENCIA WSRECEIVE Env_Transferir  WSSEND RetProcWS WSSERVICE WS_INTWMS2

	U_UWSWMS52(@::Env_Transferir, @::RetProcWS)

Return(.T.)

WSSTRUCT WSTransferir
	WSDATA 	cEmpresa		as String Optional 
	WSDATA 	cParFil			as String Optional 
	WSDATA 	PRODUTO			as String 
	WSDATA 	LOTE			as String 
	WSDATA 	QUANT			as Float 
	WSDATA 	ARMAZEMORI		as String 
	WSDATA 	ARMAZEMDST		as String 
	WSDATA 	ENDERECORI		as String 
	WSDATA 	ENDERECDST		as String 
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD MV_INTERNO_INVENTARIO WSRECEIVE Env_MovInterno  WSSEND RetProcWS WSSERVICE WS_INTWMS2

	U_UWSWMS60(@::Env_MovInterno, @::RetProcWS)

Return(.T.) 

WSSTRUCT WSMovInterno
	WSDATA 	cEmpresa		as String Optional 
	WSDATA 	cParFil			as String Optional 
	WSDATA 	NUM_OP			as String Optional
	WSDATA 	CC				as String 
	WSDATA  TIPO_MOV    	as String //(M)-Movimento interno ou (I)-Invent�rio 
	WSDATA 	PRODUTOS		as Array of PRODUTOS_MOV
ENDWSSTRUCT 

WSSTRUCT PRODUTOS_MOV
	WSDATA 	CODIGO		as String	 
	WSDATA 	ARMAZEM		as String
	WSDATA 	LOTE		as String
	WSDATA 	ENDERECO	as String
	WSDATA 	OBSERVACAO	as String
	WSDATA 	QTD_REAL	as Float	
	WSDATA 	QTD_CONT	as Float	
	WSDATA 	QTD_DIF		as Float	
ENDWSSTRUCT 

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD APONTAMENTO_OP WSRECEIVE Env_ApontaOP  WSSEND RetProcWS WSSERVICE WS_INTWMS2

	U_UWSWMS62(@::Env_ApontaOP, @::RetProcWS)

Return(.T.) 

WSSTRUCT WSApontaOP
	WSDATA 	cEmpresa		as String Optional 
	WSDATA 	cParFil			as String Optional 
	WSDATA 	NUM_OP			as String 
	WSDATA 	DT_INI			as String 
	WSDATA 	HR_INI			as String 
	WSDATA 	DT_FIM			as String 
	WSDATA 	HR_FIM			as String 
ENDWSSTRUCT 

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD STATUS_OS WSRECEIVE Env_StatusOS  WSSEND RetProcWS WSSERVICE WS_INTWMS2

	U_UWSWMS61(@::Env_StatusOS, @::RetProcWS)

Return(.T.) 

WSSTRUCT WSStatusOs
	WSDATA 	cEmpresa		as String Optional 
	WSDATA 	cParFil			as String Optional 
	WSDATA 	NUM_OS			as String 
	WSDATA  STATUS_OS    	as String //(C)-Cancelada ou (S)-Selecionada
ENDWSSTRUCT 

//----------------------------------------------------------------------------
// chama fun��o que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD TROCA_LOTE WSRECEIVE Env_TrocaLote  WSSEND RetProcWS WSSERVICE WS_INTWMS2

	U_UWSWMS63(@::Env_TrocaLote, @::RetProcWS)

Return(.T.) 

WSSTRUCT WSTrocaLote
	WSDATA 	cEmpresa		as String Optional 
	WSDATA 	cParFil			as String Optional 
	WSDATA 	NUM_OS			as String 
	WSDATA 	aLotes			as Array of ListaLotes
ENDWSSTRUCT 

WSSTRUCT ListaLotes
	WSDATA 	cItem			as String
	WSDATA 	cLote			as String
	WSDATA 	cValid			as String	
	WSDATA 	aEnderecos		as Array of ListaEnderecos
ENDWSSTRUCT 

WSSTRUCT ListaEnderecos
	WSDATA 	cEndereco		as String
	WSDATA 	nQuant			as Float 
ENDWSSTRUCT */
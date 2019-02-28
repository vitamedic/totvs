#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#include "apwebex.ch"

//----------------------------------------------------------------------------
// Definição dos metodos e Criação do WS Integraçao fom FPW
//----------------------------------------------------------------------------
WSSERVICE WS_INTFPW DESCRIPTION " Funções para integração Protheus  x FPW " 

	WSDATA cXml   as String 
	WSDATA cRet   as String 
	
	WSDATA 	FUNENVIO	as STRU_FUN
	WSDATA  FUNRETORNO  as RET_FUN
	
	WSDATA 	CTBENVIO	as STRU_CTB 
	WSDATA  CTBRETORNO	as RET_CTB

	WSMETHOD CADFUNC  		DESCRIPTION "Metodo para CRUD de cadastro de funcionario." 
	WSMETHOD CADFUNC_NEW	DESCRIPTION "Metodo para CRUD de cadastro de funcionario novo." 
	WSMETHOD CONTABILIZ		DESCRIPTION "Metodo para contabilização diaria de lançamentos." 
	WSMETHOD FINACP			DESCRIPTION "Metodo para inclusão de titulos financeiro contas a pagar." 
 
ENDWSSERVICE

//----------------------------------------------------------------------------
// chama função que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CADFUNC WSRECEIVE cXml  WSSEND cRet WSSERVICE WS_INTFPW

	conout("CADFUNC In:" +::cXml) 
	
	::cRet := TrataRetorno(U_UWSFPW01(::cXml))
	    
	conout("CADFUNC Out:" +::cRet) 

Return(.T.)

//----------------------------------------------------------------------------
// chama função que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CADFUNC_NEW WSRECEIVE FUNENVIO  WSSEND FUNRETORNO WSSERVICE WS_INTFPW
	
	conout("CADFUNC_NEW Inicio") 
	
	U_UWSFPW1N(@::FUNENVIO, @::FUNRETORNO)

	conout("CADFUNC_NEW FIM") 
	
Return(.T.) 

WSSTRUCT STRU_FUN
	WSDATA 	EMPRESA		as String Optional
	WSDATA 	FILIAL		as String Optional	 
	WSDATA 	MATRICULA	as String 
	WSDATA 	NOME		as String Optional
	WSDATA 	NASCIMENTO	as String Optional
	WSDATA 	CCUSTO		as String Optional
	WSDATA 	CPF			as String Optional
	WSDATA 	PIS			as String Optional
	WSDATA 	RG			as String Optional
	WSDATA 	RGUF		as String Optional
	WSDATA 	RGORG		as String Optional
	WSDATA 	ADMISSAO	as String Optional
	WSDATA 	DEMISSAO	as String Optional
	WSDATA 	TURNO		as String Optional
	WSDATA 	HMES		as String Optional
	WSDATA 	HSEM		as String Optional
	WSDATA 	CARGO		as String Optional
	WSDATA 	DCARGO		as String Optional
	WSDATA 	FUNCAO		as String Optional
	WSDATA 	DFUNCAO		as String Optional
	WSDATA 	CBO			as String Optional
	WSDATA 	TPPAG		as String Optional
	WSDATA 	CATEGORIA	as String Optional
	WSDATA 	SITUACAO	as String Optional
	WSDATA 	BLOQUEADO	as String Optional
	WSDATA 	MODO		as String 
ENDWSSTRUCT

WSSTRUCT RET_FUN 
	WSDATA  MATRICULA	as String
	WSDATA 	SITUACAO	as String
	WSDATA 	MSG			as String
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama função que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD CONTABILIZ WSRECEIVE CTBENVIO  WSSEND CTBRETORNO WSSERVICE WS_INTFPW

	ConOut("CONTABILIZ Inicio " + Time())
	
	U_UWSFPW02(@::CTBENVIO, @::CTBRETORNO)
	
	ConOut("SITUACAO >> " + ::CTBRETORNO:SITUACAO)
	ConOut("MSG >> " + ::CTBRETORNO:MSG)
	ConOut("CONTABILIZ Fim " + Time())

Return(.T.) 

WSSTRUCT STRU_CTB
	WSDATA 	EMPRESA		as String Optional
	WSDATA 	FILIAL		as String Optional	 
	WSDATA 	REGISTROS	as Array of DATA 
ENDWSSTRUCT

WSSTRUCT DATA
	WSDATA 	DATA_MOV	as String  
	WSDATA 	ITEM		as Array of ITEMCTB 
ENDWSSTRUCT 

WSSTRUCT ITEMCTB
	WSDATA 	TIPO				as String 
	WSDATA 	CONTA_DEBITO		as String Optional	 
	WSDATA 	CONTA_CREDITO		as String Optional	 
	WSDATA 	CC_DEBITO	 		as String Optional	 
	WSDATA 	CC_CREDITO			as String Optional	 
	WSDATA 	ITEM_CTB_DEBITO		as String Optional	 
	WSDATA 	ITEM_CTB_CREDITO	as String Optional	 
	WSDATA 	CLASSE_VALOR_DEBITO	as String Optional	 
	WSDATA  CLASSE_VALOR_CREDITO as String Optional	 
	WSDATA 	HISTORICO			as String
	WSDATA 	VALOR				as Float 
ENDWSSTRUCT   

WSSTRUCT RET_CTB
	WSDATA 	SITUACAO		as String
	WSDATA 	MSG				as String
ENDWSSTRUCT

//----------------------------------------------------------------------------
// chama função que faz o processamento e monta string xml de retorno
//----------------------------------------------------------------------------
WSMETHOD FINACP WSRECEIVE cXml  WSSEND cRet WSSERVICE WS_INTFPW

	conout("FINACP In:" +::cXml) 
	
	::cRet := TrataRetorno(U_UWSFPW03(::cXml))
	    
	conout("FINACP Out:" +::cRet) 

Return(.T.)

//----------------------------------------------------------------------------
// monta string xml de retorno, adicionando o cabeçalho
//----------------------------------------------------------------------------
Static Function TrataRetorno(_cRetorno)
	
	Local cCabXml  := '' //'<?xml version="1.0" encoding="UTF-8"?>' + chr(13)+chr(10) 

Return cCabXml + _cRetorno

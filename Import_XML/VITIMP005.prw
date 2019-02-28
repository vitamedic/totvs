#INCLUDE "TOTVS.CH"
#include 'Protheus.ch'                 
#include 'TOPConn.ch'
#include 'Rwmake.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"    
#INCLUDE "XMLXFUN.CH"

#define ENTER Chr(13)+Chr(10)

/*/{Protheus.doc} VITIMP005
//TODO Descrição auto-gerada.
@author andre.alves
@since 13/09/2018
@version 1.0
@return Funcao para leitura de XMLs de NFe no diretorio de download e geracao da pre-nota de entrada.
@param cFile2, characters, descricao
@param lJob, logical, descricao
@type function
/*/
User Function VITIM005(cFile2,lJob)
Local aArea		:= GetArea()
Local cProduto	:= ""
Local cXML      := ""
Local cError    := ""
Local cWarning  := ""
Local cCGC	    := ""
Local cTabEmit  := ""
Local cDoc	    := ""
Local cSerie    := ""
Local cCodigo   := ""
Local cLoja	    := ""
Local cCampo1   := ""
Local cCampo2   := ""
Local cCampo3   := ""
Local cCampo4   := ""
Local cCampo5   := ""
Local cQuery    := ""
Local lFound    := .F.
Local lProces   := .T.
Local lCFOPEsp  := .T.
Local nX		:= 0
Local nY		:= 0
Local oFullXML  := NIL
Local oAuxXML   := NIL
Local oXML	    := NIL
Local aItens    := {}
Local aHeadSDS  := {}
Local aItemSDT  := {}
Local oDlg
Local lStatus 	:= .F.
Local cProduto2 := ""
Local ixIni 	:= ""
Local xCNPJ 	:= "" 
Local vDesconto := 0, vDespesa := 0, vSeguro := 0, vFrete := 0
Local cVersao 	:= "" 
Local nValUniCte	:= 0
Local nValtotCte	:= 0    
Local oVdesc 
Local oMed

Private cFile		:= cFile2
Private cEmailAdm 	:= SuperGetMv("MV_XEMAADM", .F.,"") //email destinatário para recebimento de erros
Private cEmailErro  := ""	// Variavel para gerar a menssagem de erro
Private lMsErroAuto	:= .F.
Private cStatus		:= ""
Private cTipoNF   := ""

Default lJob := .T.
 
Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Vai tentar achar o aquivo "+ cStartLido )
		
if !File( cStartLido + iif(IsSrvUnix(),"/","\") + cFile)
	 
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Não ACHOU o aquivo "+ cStartLido )
	if lJob
		ConOut(Replicate("=",80))
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " ReadXML Error:")
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Arquivo: " +cFile)
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Ocorrencia: Arquivo inexistente.")
		ConOut(Replicate("=",80))
	else
		Aviso("Error","Arquivo " +cFile +" inexistente.",{"OK"},2,"ReadXML")
	endIf
	
	RestArea(aArea)
	Return(.F.)
else
		Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ACHOU o aquivo "+ cStartLido )	
endif

cXML := MemoRead(cStartLido + iif(IsSrvUnix(),"/","\") + cFile)

/* INICIO POR SANGELLES 17/12/2013
//-- Nao processa conhecimentos de transporte
If "</CTE>" $ Upper(cXML)
	//FErase(cStartPath + iif(IsSrvUnix(),"/","\") + cFile)
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Conhecimento de transporte não vou processsar!")	
	FErase(cXML)
	lProces := .F.
EndIf                      
  FIM POR SANGELLES 17/12/2013 */
 
Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Verifica se Nao processa XML de outra empresa/filial!")	
	
//-- Nao processa XML de outra empresa/filial
If "</CTE>" $ Upper(cXML)
	ixIni := At("<rem><CNPJ>",cXML) +11
else
	ixIni := At("<dest><CNPJ>",cXML) +12
endif
if !Substr(SM0->M0_CGC,0,8) $ AllTrim( Substr(cXML, ixIni, 14 ) )
 	ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " O arquivo XML " + cFile + " não pertence a empresa logada!")
	ConOut(Replicate("=",80))
	if lJob
		ConOut(Replicate("=",80))
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Error:")
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " O arquivo XML " + cFile + " não pertence a empresa logada!")
		ConOut(Replicate("=",80))
	else
		Aviso("Error","O arquivo XML " + cFile + " não pertence a empresa logada!",{"OK"},2,"ReadXML")
	endif
	//-- Move arquivo para pasta dos erros
	cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Movendo o arquivo para a pasta de erros!")	

	//copia o arquivo antes da transacao
	cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
	
	If MsErase(cNomNovArq)
		__CopyFile(cArqTXT,cNomNovArq)
		FErase(cArqTXT)
	EndIf
	
	RestArea(aArea)
	Return(.F.)
	
endif

if !lProces
	Return(.F.)
endif


oFullXML := XmlParserFile(cStartLido + iif(IsSrvUnix(),"/","\") + cFile,"_",@cError,@cWarning)

//********************************
//-- Erro na sintaxe do XML
//********************************
if Empty(oFullXML) .Or. !Empty(cError)

	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Erro do XML - > Ocorrencia: " +cError)	

	If lJob
		ConOut(Replicate("=",80))
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Error:")
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Arquivo: " +cFile)
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Ocorrencia: " +cError)
		ConOut(Replicate("=",80))
	Else
		Aviso("Erro",cError,{"OK"},2,"ReadXML")
	EndIf
	
	//-- Move arquivo para pasta dos erros
	cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Move para pasta de ERROS!")	
	
	//copia o arquivo antes da transacao
	cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
	
	If MsErase(cNomNovArq)
		__CopyFile(cArqTXT,cNomNovArq)
		FErase(cArqTXT)
	EndIf
	
	RestArea(aArea)
	Return(.F.)
	
Endif

oXML    := oFullXML
oAuxXML := oXML
  
Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Resgata o no inicial da NF-e!")	
	
//************************************
//-- Resgata o no inicial da NF-e
//************************************
while !lFound
	
	oAuxXML := XmlChildEx(oAuxXML,"_NFE")
	if !(lFound := (ValType(oAuxXML)) == 'O')
		
		for nX := 1 To XmlChildCount(oXML)
			
			If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013
				oAuxXML  := XmlChildEx(XmlGetchild(oXML,nX),"_CTE") 
				lFound := ValType(oAuxXML:_InfCTe) == 'O' 
			else
				oAuxXML  := XmlChildEx(XmlGetchild(oXML,nX),"_NFE")  
				lFound := ValType(oAuxXML:_InfNfe) == 'O'	//oAuxXML:_InfNfe # Nil
			endif
			
			if lFound
				oXML := oAuxXML
				Exit
			endif
			
		next nX
		
	endif
	
	if lFound
		oXML := oAuxXML
		Exit
	endIf
	
enddo

Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" VERIFICAR PARA QUAL FILIAL SERA IMPORTADO!")	

//*******************************************
//VERIFICAR PARA QUAL FILIAL SERA IMPORTADO
//*******************************************

If "</CTE>" $ Upper(cXML) //Desativado temporariamente -- Aluisio Gomes

	If lJob
		ConOut(Replicate("=",80))
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Importação CTE Não Configurado")
	Else
		MsgStop("Importação CTE Não Configurado","Atenção - READXML")
	Endif
	
	RestArea(aArea)
	Return(.F.)
   /*	If !"<DEST><CPF>" $ Upper(cXML) 
		If "</EXPED>" $ Upper(cXML)
	   		cCNPJInf := oXML:_INFCTE:_DEST:_CNPJ:TEXT + " \ " + oXML:_INFCTE:_EXPED:_CNPJ:TEXT
	   	Else
	   		cCNPJInf := oXML:_INFCTE:_DEST:_CNPJ:TEXT + " \ " + oXML:_INFCTE:_REM:_CNPJ:TEXT
	   	EndIf
	Else
		If "</EXPED>" $ Upper(cXML)
	   		cCNPJInf := oXML:_INFCTE:_EXPED:_CNPJ:TEXT
	   	Else
	   		cCNPJInf := oXML:_INFCTE:_REM:_CNPJ:TEXT
	   	EndIf   	
	EndIf  */ 				
else
	cCNPJInf := oXML:_INFNFE:_DEST:_CNPJ:TEXT
endif


//*******************************
// Ja esta aberto e posicionado
//*******************************
if !SM0->M0_CGC $ cCNPJInf
	If lJob
		ConOut(Replicate("=",80))
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Error:")
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Arquivo: " +cFile)
		ConOut("Ocorrencia: " +"Este arquivo não pertence a esta Filial! - " + SM0->M0_CODFIL + AllTrim(SM0->M0_FILIAL)+" (Importação de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time())
		ConOut(Replicate("=",80))
	Else
		MsgStop("Este arquivo não pertence a esta Filial! - " + SM0->M0_CODFIL + AllTrim(SM0->M0_FILIAL),"Atenção - READXML")
	Endif
	
	RestArea(aArea)
	Return(.F.)
	
endIf

//******************************************
//-- Verifica se este ID ja foi processado
//******************************************
Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Verifica se este ID ja foi processado!")	

SDS->( DbSetOrder(2) )
If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013
	lFound := SDS->( DbSeek(xFilial("SDS")+Right(AllTrim(oXML:_InfCTE:_Id:Text),44)) )	//Filial + Chave de acesso
else
	lFound := SDS->( DbSeek(xFilial("SDS")+Right(AllTrim(oXML:_InfNfe:_Id:Text),44)) )	//Filial + Chave de acesso
endif


//**************
//PEGA A IDENT
//**************
If lJob
	cIdEnt := U_VITIM006()
EndIf

Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" VERIFICA O STATUS NA RECEITA FEDERAL E EM CASO DE REJEICAO NAO IMPORTA!")	

//************************************************************************
// VERIFICA O STATUS NA RECEITA FEDERAL E EM CASO DE REJEICAO NAO IMPORTA
//************************************************************************
If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013
	lStatus := StaticCall(ACOMP004,ConsNFeChave,Right(AllTrim(oXML:_InfCTE:_Id:Text),44),cIdEnt,lJob)
else
	lStatus := StaticCall(ACOMP004,ConsNFeChave,Right(AllTrim(oXML:_InfNfe:_Id:Text),44),cIdEnt,lJob)
endif

Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" VERIFICADO O STATUS NA RECEITA FEDERAL E EM CASO DE REJEICAO NAO IMPORTA!")	

if lStatus
	lStatus	:= GetNewPar("MV_XVALNFE",.T.) //Alteração Sangelles data 10/10/2013
	if !GetNewPar("MV_XVALNFE",.T.)
			Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Nota com problemas, porém o parametro MV_XVALNFE esta como .F. será importada!")	
	endif
endif


if lStatus
	
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" NFe com problemas, Verifique o Status do SEFAZ ou se a Nota Fiscal esta cancelada!")	
  

	If !lJob
		MsgStop("NFe com problemas, rotina Cancelada!","READXML")
	else
		
		cEmailErro :="ReadXML Error:"+ENTER
		cEmailErro +="Arquivo: " +cFile+ENTER
		cEmailErro +="Ocorrencia: Erro na validação da chave da NFe na Receita Federal."+ENTER
		//***************
		//ENVIA E-MAIL
		//***************
		StaticCall(ACOMP004,EnviarEmail,'','Inconsistencia Importação NF-e','Nota Não Autorizada na SEFAZ',cEmailErro, .T., cEmailAdm,'')
		
	EndIf 
	
	//-- Move arquivo para pasta dos erros
	cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
	
	//copia o arquivo antes da transacao
	cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
	
	If MsErase(cNomNovArq)
		__CopyFile(cArqTXT,cNomNovArq)
		FErase(cArqTXT)
	EndIf
	
	RestArea(aArea)
	Return()
	
EndIf

if lFound
	
	If lJob
		cEmailErro :="ReadXML Error:"+ENTER
		cEmailErro +="Arquivo: " +cFile+ENTER
		cEmailErro +="Ocorrencia: ID de NFe ja registrado na NF " +SDS->(DS_DOC+"/"+DS_SERIE)+" do fornecedor " +SDS->(DS_FORNEC+"/"+DS_LOJA) +"."+ENTER
		
		//******************
		//ENVIA E-MAIL
		//******************
		StaticCall(ACOMP004,EnviarEmail,'','Inconsistencia Importação NF-e',"ID de NFe ja registrado na NF " + SDS->(DS_DOC+"/"+DS_SERIE),cEmailErro, .T., cEmailAdm,'')
		
		ConOut(Replicate("=",80))
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Error:")
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Arquivo: " +cFile)
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Ocorrencia: ID de NFe ja registrado na NF " +SDS->(DS_DOC+"/"+DS_SERIE);
		+" do fornecedor " +SDS->(DS_FORNEC+"/"+DS_LOJA) +".")
		ConOut(Replicate("=",80))
	Else
		Aviso("Erro","ID de NFe ja registrado na NF " +SDS->(DS_DOC+"/"+DS_SERIE);
		+" do fornecedor " +SDS->(DS_FORNEC+"/"+DS_LOJA) +".",{"OK"},2,"ReadXML")
	EndIf
	
	//-- Move arquivo para pasta dos erros
	cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
	
	//copia o arquivo antes da transacao
	cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
	
	if MsErase(cNomNovArq)
		__CopyFile(cArqTXT,cNomNovArq)
		FErase(cArqTXT)
	EndIf
	
	RestArea(aArea)
	Return(.F.)
	
EndIf

If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013
	
	//-- Se ID valido
	//-- Extrai tag _InfNfe:_Det
	if ValType(oXML:_InfCTE:_vPrest) $ "A"
		aItens := oXML:_InfCTE:_vPrest
		
	elseif ValType(oXML:_InfCTE:_vPrest) $ "O"
		aItens := {oXML:_InfCTE:_vPrest}
		
	elseif ValType(oXML:_InfCTE:_vPrest) == "U"
		
		if lJob
			cEmailErro :="ReadXML Error:" + ENTER
			cEmailErro +="Arquivo: " +cFile + ENTER
			cEmailErro +="Ocorrencia: tag _InfNfe:_Det não localizada."+ENTER
			
			//****************
			//ENVIA E-MAIL
			//****************
			StaticCall(ACOMP004,EnviarEmail,'','Importacao XML NFe entrada com Erros','Informações do Emitente Ausentes no XML (oXML:_InfCTE:_vPrest)',cEmailErro, .T., cEmailAdm,'')
			
			ConOut(Replicate("=",80))
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Error:")
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Arquivo: " +cFile)
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Ocorrencia: oXML:_InfCTE:_vPrest não localizada.")
			ConOut(Replicate("=",80))
		else
			Aviso("Erro","Tag oXML:_InfCTE:_vPrest não localizada.",{"OK"},2,"ReadXML")
		endIf
		
		//-- Move arquivo para pasta dos erros
		cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
		
		//copia o arquivo antes da transacao
		cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
		if MsErase(cNomNovArq)
			__CopyFile(cArqTXT,cNomNovArq)
			FErase(cArqTXT)
		endIf
		
		RestArea(aArea)
		Return(.F.)	//lProces := .F.
		
	endif
else

	//-- Se ID valido
	//-- Extrai tag _InfNfe:_Det
	if ValType(oXML:_InfNfe:_Det) $ "A"
		aItens := oXML:_InfNfe:_Det
		
	elseif ValType(oXML:_InfNfe:_Det) $ "O"
		aItens := {oXML:_InfNfe:_Det}
		
	elseif ValType(oXML:_InfNfe:_Det) == "U"
		
		if lJob
			cEmailErro :="ReadXML Error:" + ENTER
			cEmailErro +="Arquivo: " +cFile + ENTER
			cEmailErro +="Ocorrencia: tag _InfNfe:_Det não localizada."+ENTER
			
			//****************
			//ENVIA E-MAIL
			//****************
			StaticCall(ACOMP004,EnviarEmail,'','Importacao XML NFe entrada com Erros','Informações do Emitente Ausentes no XML (_DET)',cEmailErro, .T., cEmailAdm,'')
			
			ConOut(Replicate("=",80))
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Error:")
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Arquivo: " +cFile)
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Ocorrencia: tag _InfNfe:_Det não localizada.")
			ConOut(Replicate("=",80))
		else
			Aviso("Erro","Tag _InfNfe:_Det não localizada.",{"OK"},2,"ReadXML")
		endIf
		
		//-- Move arquivo para pasta dos erros
		cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
		
		//copia o arquivo antes da transacao
		cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
		if MsErase(cNomNovArq)
			__CopyFile(cArqTXT,cNomNovArq)
			FErase(cArqTXT)
		endIf
		
		RestArea(aArea)
		Return(.F.)	//lProces := .F.
		
	endif
	
endif

Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Extrai CGC do fornecedor/cliente!")	

//***************************************
//-- Se tag _InfNfe:_Det valida
//-- Extrai CGC do fornecedor/cliente
//***************************************         
If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013
	cTipoNF := "N"	
else
	if AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "1"
		cTipoNF := "N"
	elseIf AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "2"
		cTipoNF := "D"
	else
		cTipoNF := "B"
	endIf
endif

If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013

	If ValType(oXML:_INFCTE:_EMIT:_CNPJ) <> "U"
		cCGC := oXML:_INFCTE:_EMIT:_CNPJ:Text
		
	Elseif ValType(oXML:_INFCTE:_EMIT:_CPF) <> "U"
		cCGC := oXML:_INFCTE:_EMIT:_CPF:Text
	Else
		
		If lJob
			cEmailErro :="ReadXML Error:"+ENTER
			cEmailErro +="Arquivo: " +cFile+ENTER
			cEmailErro +="Ocorrencia: tag _CNPJ/_CPF ausente."+ENTER
			
			//********************
			//ENVIA E-MAIL
			//********************
			StaticCall(ACOMP004,EnviarEmail,'','Inconsistencia Importação NF-e',"Ocorrencia: tag _CNPJ/_CPF ausente.",cEmailErro, .T., cEmailAdm,'')
			
			ConOut(Replicate("=",80))
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Error:")
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Arquivo: " +cFile)
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Ocorrencia: tag _CNPJ/_CPF ausente.")
			ConOut(Replicate("=",80))
			
		Else
			Aviso("Erro","Tag _CNPJ/_CPF ausente.",{"OK"},2,"ReadXML")
			
		EndIf
		
		//-- Move arquivo para pasta dos erros
		cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
		
		//copia o arquivo antes da transacao
		cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
		
		If MsErase(cNomNovArq)
			__CopyFile(cArqTXT,cNomNovArq)
			FErase(cArqTXT)
		EndIf
		
		RestArea(aArea)
		Return(.F.)
		
	Endif                   
	
else
	If ValType(oXML:_INFNFE:_EMIT:_CNPJ) <> "U"
		cCGC := oXML:_INFNFE:_EMIT:_CNPJ:Text
		
	Elseif ValType(oXML:_INFNFE:_EMIT:_CPF) <> "U"
		cCGC := oXML:_INFNFE:_EMIT:_CPF:Text
	Else
		
		If lJob
			cEmailErro :="ReadXML Error:"+ENTER
			cEmailErro +="Arquivo: " +cFile+ENTER
			cEmailErro +="Ocorrencia: tag _CNPJ/_CPF ausente."+ENTER
			
			//********************
			//ENVIA E-MAIL
			//********************
			StaticCall(ACOMP004,EnviarEmail,'','Inconsistencia Importação NF-e',"Ocorrencia: tag _CNPJ/_CPF ausente.",cEmailErro, .T., cEmailAdm,'')
			
			ConOut(Replicate("=",80))
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Error:")
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Arquivo: " +cFile)
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Ocorrencia: tag _CNPJ/_CPF ausente.")
			ConOut(Replicate("=",80))
			
		Else
			Aviso("Erro","Tag _CNPJ/_CPF ausente.",{"OK"},2,"ReadXML")
			
		EndIf
		
		//-- Move arquivo para pasta dos erros
		cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
		
		//copia o arquivo antes da transacao
		cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
		
		If MsErase(cNomNovArq)
			__CopyFile(cArqTXT,cNomNovArq)
			FErase(cArqTXT)
		EndIf
		
		RestArea(aArea)
		Return(.F.)
		
	Endif
endif
conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Busca fornecedor/cliente na base")	


//******************************************
//-- Se tag CGC valida
//-- Busca fornecedor/cliente na base
//******************************************
cTabEmit := If(cTipoNF == "N" .OR. cTipoNF == "C" ,"SA2","SA1")
(cTabEmit)->( dbSetOrder(3) )

If (cTabEmit)->(dbSeek(xFilial(cTabEmit)+cCGC))
	cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
	cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
else
	
	if lJob
		cEmailErro :="ReadXML Error:" + ENTER
		cEmailErro +="Arquivo: " + cFile + ENTER
		cEmailErro +="Ocorrencia: " + iif(cTipoNF == "N","fornecedor","cliente") + " de CNJP/CPF numero " +cCGC + " inexistente na base." + ENTER
		
		//****************
		//ENVIA E-MAIL
		//****************
		
		//StaticCall(ACOMP004,EnviarEmail,'',If(cTipoNF == "N","Fornecedor","Cliente") +" de CNJP/CPF numero " +cCGC +" inexistente na base.","",/*cEmailErro*/"ERRO",.T., cEmailAdm,'')
		
		//ConOut(Replicate("=",80))
		//ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Error:")
		//ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Arquivo: " + cFile)
		ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Ocorrencia: " + If(cTipoNF == "N","fornecedor","cliente") + " de CNJP/CPF numero " + cCGC + " inexistente na base.")
		//onOut(Replicate("=",80))
	else 
		Aviso("Erro",If(cTipoNF == "N" .OR. cTipoNF == "C" ,"Fornecedor","Cliente") +" de CNJP/CPF numero " +cCGC +" inexistente na base.",{"OK"},2,"ReadXML")
	endIf
	
	if (cTipoNF == "N" .OR. cTipoNF == "C")
		//**************************************************************
		// Realiza o cadastro do Fornecedor, caso não exista na base
		// se o Parametor estiver ativado, senão continua, mas será
		// gravado com pendencias.
		//**************************************************************
		if SuperGetMV("MV_XCDFOR", .F., .F.)	// Alterado 27-05-2014
			lProces := CadFornec(oXML,lJob, cXML)
			
			cCodigo := SA2->A2_COD
			cLoja   := SA2->A2_LOJA
		endif
	else
		//**************************************************************
		// Realiza o cadastro do Cliente, caso não exista na base
		// se o Parametor estiver ativado, senão continua, mas será
		// gravado com pendencias.
		//**************************************************************
		if GetNewPar("MV_XCADCLI", .T.)
			lProces := CadClient(oXML,lJob,cXML)
			
			cCodigo := SA1->A1_COD
			cLoja   := SA1->A1_LOJA
		endif
	endif
	
endif

conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Processa cabeçalho e itens")	

//**************************************
//-- Se fornecedor/cliente validado
//-- Processa cabeçalho e itens
//**************************************
cCampo1 := If(cTipoNF # "N","A7_PRODUTO","A5_PRODUTO")
cCampo2 := If(cTipoNF # "N","A7_FILIAL","A5_FILIAL")
cCampo3 := If(cTipoNF # "N","A7_CLIENTE","A5_FORNECE")
cCampo4 := If(cTipoNF # "N","A7_LOJA","A5_LOJA")
cCampo5 := If(cTipoNF # "N","A7_CODCLI","A5_CODPRF")
 
If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013
	cDoc   		:= StrZero(Val(AllTrim(oXML:_InfCTE:_Ide:_CCT:Text)),TamSx3("F1_DOC")[1])
	cSerie 		:= PadR(oXML:_InfCTE:_Ide:_Serie:Text,TamSX3("F1_SERIE")[1])
	cStatus 	:= Posicione("SF1",1,xFilial("SF1") + cDoc + cSerie + cCodigo +  cLoja,"F1_DOC") 
else
	cDoc   		:= StrZero(Val(AllTrim(oXML:_InfNfe:_Ide:_nNF:Text)),TamSx3("F1_DOC")[1])
	cSerie 		:= PadR(oXML:_InfNfe:_Ide:_Serie:Text,TamSX3("F1_SERIE")[1])//PadR(oXML:_InfNfe:_Ide:_Serie:Text,TamSX3("F1_SERIE")[1])             
	cStatus 	:= Posicione("SF1",1,xFilial("SF1") + cDoc + cSerie + cCodigo +  cLoja,"F1_DOC") 
    
	If	(XmlChildEx (oFullXml, "_N0_NFEPROC")<>Nil)// Tratamento exceção para o cliente Termopot
		vDesconto	:= Val(oFullXml:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:Text)
		vDespesa	:= Val(oFullXml:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:Text)
		vSeguro		:= Val(oFullXml:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VSEG:Text)
		vFrete		:= Val(oFullXml:_N0_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:Text)
	Else
		vDesconto	:= Val(oFullXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:Text)
		vDespesa	:= Val(oFullXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:Text)
		vSeguro		:= Val(oFullXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VSEG:Text)
		vFrete		:= Val(oFullXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:Text)	
	EndIf	

endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava os Dados do Cabecalho - SDS  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Grava os Dados do Cabecalho - SDS")	

if type("cProtocolo") == "U"
	cProtocolo := ""	
endif  

If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013
	AADD(aHeadSDS,{{"DS_FILIAL"	,xFilial("SDS")														     	},; //Filial
			{"DS_CNPJ"		,cCGC																				},; //CGC
			{"DS_DOC"		,cDoc 																				},; //Numero do Documento
			{"DS_SERIE"		,cSerie 																			},; //Serie
			{"DS_FORNEC"	,cCodigo																			},; //Fornecedor
			{"DS_LOJA"		,cLoja 																				},; //Loja do Fornecedor
			{"DS_EMISSA"	,StoD(StrTran(AllTrim(oXML:_InfCTE:_Ide:_DhEmi:Text),"-",""))			   			},; //Data de Emissão
			{"DS_EST"		,oXML:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT												},; //Estado de emissao da NF
			{"DS_TIPO"		,cTipoNF 																	 		},; //Tipo da Nota
			{"DS_FORMUL"	,"N" 																		 		},; //Formulario proprio
			{"DS_DTDIGI"	,dDataBase 																	 		},; //Dtda de digitaçao
			{"DS_ESPECI"	,"CTE"																		  		},; //Especie
			{"DS_ARQUIVO"	,AllTrim(cFile)																   		},; //Arquivo importado
			{"DS_STATUS"	,iif(Empty(cStatus)," ","P")												   		},; //Status
			{"DS_CHAVENF"	,Iif(ValType("opNF:_InfNfe:_Id")<>"U",Right(AllTrim(oXML:_InfCTE:_Id:Text),44),"")},; //Chave de Acesso da NF
			{"DS_VERSAO"	,Iif(ValType("opNF:_InfNfe:_versao")<>"U",oXML:_InfCTE:_versao:text ,"")			},; //Versão
			{"DS_USERIMP"	,Iif(!Empty(cUserName),cUserName,"JOB" ) 											},; //Usuario na importacao
			{"DS_DATAIMP"	,dDataBase																			},; //Data importacao do XML
			{"DS_NPROTOC"	,cProtocolo																			},; //Numero de Protocolo de Autorização
			{"DS_HORAIMP"	,SubStr(Time(),1,5)																	}}) //Hora importacao XML

else  
    cVersao := Iif(ValType("opNF:_InfNfe:_versao")<>"U",oXML:_InfNfe:_versao:text ,"")
	AADD(aHeadSDS,{{"DS_FILIAL"	,xFilial("SDS")																						     	},; //Filial
			{"DS_CNPJ"		,cCGC																											},; //CGC
			{"DS_DOC"		,cDoc 																											},; //Numero do Documento
			{"DS_SERIE"		,cSerie 																										},; //Serie
			{"DS_FORNEC"	,cCodigo																										},; //Fornecedor
			{"DS_LOJA"		,cLoja 																											},; //Loja do Fornecedor
			{"DS_EMISSA"	,StoD(StrTran(AllTrim(IIF(cVersao $ "3.10",oXML:_InfNfe:_Ide:_DhEmi:Text,oXML:_InfNfe:_Ide:_DhEmi:Text)),"-",""))},; //Data de Emissão
			{"DS_EST"		,oXML:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT																			},; //Estado de emissao da NF
			{"DS_TIPO"		,cTipoNF 																	 									},; //Tipo da Nota
			{"DS_FORMUL"	,"N" 																		 									},; //Formulario proprio
			{"DS_DTDIGI"	,dDataBase 																	 									},; //Dtda de digitaçao
			{"DS_ESPECI"	,"SPED"																		  									},; //Especie
			{"DS_ARQUIVO"	,AllTrim(cFile)																   									},; //Arquivo importado
			{"DS_STATUS"	,iif(Empty(cStatus)," ","P")												   									},; //Status
			{"DS_CHAVENF"	,Iif(ValType("opNF:_InfNfe:_Id")<>"U",Right(AllTrim(oXML:_InfNfe:_Id:Text),44),"")  							},; //Chave de Acesso da NF
			{"DS_VERSAO"	,Alltrim(cVersao)																								},; //Versão
			{"DS_USERIMP"	,Iif(!Empty(cUserName),cUserName,"JOB" ) 																		},; //Usuario na importacao
			{"DS_DATAIMP"	,dDataBase																										},; //Data importacao do XML
			{"DS_NPROTOC"	,cProtocolo																										},; //Numero de Protocolo de Autorização
			{"DS_HORAIMP"	,SubStr(Time(),1,5)																								},;
			{"DS_FRETE"  	,vFrete																											},;
			{"DS_SEGURO"	,vSeguro																										},;
			{"DS_DESPESA"	,vDespesa																										},;
			{"DS_HORAEMI"	,StrTran(Alltrim(IIF(cVersao $ "3.10",IIF( "</DHSAIENT>" $ UPPER (CXML) ,SUBSTR(oXML:_InfNfe:_Ide:_DHSAIENT:TEXT,12,8),"000000"),;
							 IIF( "</HSAIENT>" $ UPPER (CXML), oXML:_InfNfe:_Ide:_HSAIENT:TEXT,"000000"))),":","") },;			            // Hora Emissao
			{"DS_DESCONT"	,vDesconto																										} } )

endif


If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013
	    
	For nX := 1 To Len(aItens)
		
		cProduto := "FRETE" //AllTrim(aItens[nX]:_Prod:_cProd:Text)
		
		cQuery := "SELECT " +cCampo1 +" FROM " +RetSqlName(If(cTipoNF # "N","SA7","SA5"))
		cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
		cQuery += cCampo2 +" = '" +xFilial(If(cTipoNF # "N","SA7","SA5")) +"' AND "
		cQuery += cCampo3 +" = '" +cCodigo +"' AND "
		cQuery += cCampo4 +" = '" +cLoja +"' AND "
		cQuery += cCampo5 +" = '" +cProduto +"'"
		
		TcQuery cQuery new Alias "TRB"
		
		If !TRB->( Eof() )
			cProduto2 := TRB->(&cCampo1)
		else
			
			If lJob
				ConOut(Replicate("=",80))
				ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Error:")
				ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Arquivo: " +cFile)
				ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Ocorrencia: " +If(cTipoNF == "N","fornecedor ","cliente ") +cCodigo +"/" +cLoja;
				+" sem cadastro de Produto X " +If(cTipoNF == "N","Fornecedor","Cliente");
				+" para o codigo " +cProduto +"-" + "FRETE" + ".")
				ConOut(Replicate("=",80))
				
				cEmailErro :="ReadXML Error:"+ENTER
				cEmailErro +="Arquivo: " +cFile+ENTER
				cEmailErro +="Ocorrencia: " +If(cTipoNF == "N","fornecedor ","cliente ") +cCodigo +"/" +cLoja;
				+" sem cadastro de Produto X " +If(cTipoNF == "N","Fornecedor","Cliente");
				+" para o codigo " +cProduto +"-" + "FRETE" + "."+ENTER
				
				//********************
				//ENVIA E-MAIL
				//********************
				//EnviarEmail('','Inconsistencia Importação NF-e',"Arquivo: " +cFile, cEmailErro, .T. ,cEmailAdm,'')
				
			else
				
				nOpc := Aviso("XML", 'Atenção Produto '+ cProduto + ': '+ cProduto + ;
				' Não Encontrado na Amarraçâo Prod. x Fornecedor, Deseja incluir?', {"Sim","Não","Cancelar"})
				
				if nOpc == 1
					//MsgYesNo('Atencao Produto '+ cProduto + ': '+ AllTrim(aItens[nX]:_PROD:_XPROD:TEXT) +' Não Encontrado na Amarraçâo Prod. x Fornecedor, Deseja incluir?' )
					
					cProduto2	:= cProduto+Space(15-Len(cProduto))
					
					@ 65,153 To 229,435 Dialog oDlg Title OemToAnsi("Inclusão Amarração")
					@ 09,009 Say OemToAnsi("Produto") Size 99,8
					@ 15,009 Say OemToAnsi( "FRETE" + "-" + "FRETE PESO") Size 99,8
					@ 28,009 Get cProduto2 Picture "@!" F3 "SB1" VALID Existcpo("SB1",cProduto2) Size 59,10
					@ 62,039 BMPBUTTON TYPE 1 ACTION Close(oDlg)
					Activate Dialog oDlg Centered
					
					If !Empty(cProduto2)
						
						If cTipoNF # "N"
							dbselectarea("SA7")
							SA7->(DbSetOrder(1))
							if !SA7->(Dbseek(xFilial("SA7") + cCodigo + cLoja + cProduto2))
								
								RecLock("SA7",.T.)
								SA7->A7_FILIAL 	:= xFilial("SA7")
								SA7->A7_CLIENTE	:= cCodigo
								SA7->A7_LOJA 	:= cLoja
								SA7->A7_CODCLI  := cProduto
								SA7->A7_PRODUTO := cProduto2
								SA7->( MsUnlock() )
								
							endif
						else
							dbselectarea("SA5")
							SA5->(DbSetOrder(1))
							if !SA5->(Dbseek(xFilial("SA5") + cCodigo + cLoja + cProduto2))
								
								RecLock("SA5",.T.)
								SA5->A5_FILIAL 	:= xFilial("SA5")
								SA5->A5_FORNECE := cCodigo
								SA5->A5_LOJA 	:= cLoja
								SA5->A5_NOMEFOR	:= Posicione("SA2",1,xFilial("SA2")+cCodigo,"A2_NOME")
								SA5->A5_CODPRF	:= cProduto
								SA5->A5_PRODUTO := cProduto2
								SA5->A5_NOMPROD := Posicione("SB1",1,xFilial("SB1")+cProduto2,"B1_DESC")
								SA5->( MsUnlock() )
								
							endif
							
						Endif
						
					Else
						//-- Move arquivo para pasta dos erros
						cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
						
						//copia o arquivo antes da transacao
						cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
						
						If MsErase(cNomNovArq)
							__CopyFile(cArqTXT,cNomNovArq)
							FErase(cArqTXT)
						EndIf
						
						lProces := .F.
						Exit
						
					endif
					
				elseif nOpc == 3
					
					TRB->( dbCloseArea() )
					RestArea(aArea)
					Return(.F.)
					
				else
					
					cProduto2 := ""
					
				endIf
				
			endif
			
		endif
		
		TRB->( dbCloseArea() )
		
		conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Grava os Dados dos Itens - SDT")	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dados dos Itens - SDT	   ³
		//³  DADOS DO PRODUTO      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		 
		aParx := {aItemSDT, aItens, nX, cCGC, cProduto2, cCodigo,cLoja, cDoc, cSerie }
		
	   /*	IF ExistBlock("PCOMP002")     	 
			aParx 	   := ExecBlock("PCOMP002",.F.,.F.,aParx )
			aItemSDT2  := aParx[1]
			aItens     := aParx[2]
			aAdd(aItemSDT, aItemSDT2) 
		else*/
		   If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013
	             
	            If ValType(aItens[nX]:_COMP) == 'A'   //Aluisio Gomes
	                For nI := 1 to Len(aItens[nX]:_COMP)
	            		nValUniCte += Val(aItens[nX]:_COMP[nI]:_VCOMP:TEXT)
	            	Next nI
	            	nValTotCte := nValUniCte
	            Else 
	            	nValUniCte := Val(aItens[nX]:_COMP:_VCOMP:TEXT)
	            	nValTotCte := nValUniCte
	            EndIf		                         
				cXUM := "UN"
	           	AADD(aItemSDT,{{"DT_FILIAL" 	,xFilial("SDT")													},; //Filial
							{"DT_CNPJ"		,cCGC																},; //CGC
							{"DT_COD"		,cProduto2															},; //Codigo do produto
							{"DT_PRODFOR"	,"FRETE"															},; //Cdgo do pduto do Fornecedor
							{"DT_DESCFOR"	,IIf(ValType(aItens[nX]:_COMP) == 'A',;
											aItens[nX]:_COMP[nX]:_XNOME:TEXT,aItens[nX]:_COMP:_XNOME:TEXT)		},; //Dcao do pduto do Fornecedor
							{"DT_ITEM"   	,PadL(nX,TamSX3("D1_ITEM")[1],"0")									},; //Item
							{"DT_QUANT"  	,1																	},; //Qtde
							{"DT_VUNIT"		,Round(nValUniCte,TamSX3("C7_PRECO")[2])		},; //Vlor Unitário
							{"DT_FORNEC"	,cCodigo															},; //Forncedor
							{"DT_LOJA"   	,cLoja																},; //Lja
							{"DT_DOC"    	,cDoc																},; //DocmTo
							{"DT_SERIE"		,cSerie							   									},; //Serie
							{"DT_TOTAL"		,Round(nValTotCte,TamSX3("C7_PRECO")[2])	},; //Vlor Total   
							{"DT_XUM"		,cXUM																}}) //Unidade de Medida	
           else
				AADD(aItemSDT,{{"DT_FILIAL" 	,xFilial("SDT")													},; //Filial
							{"DT_CNPJ"		,cCGC																},; //CGC
							{"DT_COD"		,cProduto2															},; //Codigo do produto
							{"DT_PRODFOR"	,aItens[nX]:_PROD:_CPROD:TEXT										},; //Cdgo do pduto do Fornecedor
							{"DT_DESCFOR"	,aItens[nX]:_PROD:_XPROD:TEXT										},; //Dcao do pduto do Fornecedor
							{"DT_ITEM"   	,PadL(aItens[nX]:_nItem:Text,TamSX3("D1_ITEM")[1],"0")				},; //Item
							{"DT_QUANT"  	,Val(aItens[nX]:_Prod:_qCom:Text)									},; //Qtde
							{"DT_VUNIT"		,Round(Val(aItens[nX]:_Prod:_vUnCom:Text),TamSX3("DT_VUNIT")[2])	},; //Vlor Unitário
							{"DT_FORNEC"	,cCodigo															},; //Forncedor
							{"DT_LOJA"   	,cLoja																},; //Lja
							{"DT_DOC"    	,cDoc																},; //DocmTo
							{"DT_SERIE"		,cSerie							   									},; //Serie
							{"DT_TOTAL"		,Val(aItens[nX]:_Prod:_vProd:Text)									},; //Vlor Total 
							{"DT_VALDESC"	,Round(Val(IIF(ValType(aItens[nX]:_PROD:_VDESC) <> "U",; 
						 						aItens[nX]:_PROD:_VDESC:TEXT,"0")),TamSX3("C7_VLDESC")[2])		},; //Vlor Desc  Aluisio
							{"DT_XUM"		,aItens[nX]:_PROD:_UCOM:TEXT										}}) //Unidade de Medida	
		   endif					
		//endif
		    	
	Next nX
else
	
	For nX := 1 To Len(aItens)
	
	cProduto := AllTrim(aItens[nX]:_Prod:_cProd:Text)
	
	cQuery := "SELECT " +cCampo1 +" FROM " +RetSqlName(If(cTipoNF # "N","SA7","SA5"))
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
	cQuery += cCampo2 +" = '" +xFilial(If(cTipoNF # "N","SA7","SA5")) +"' AND "
	cQuery += cCampo3 +" = '" +cCodigo +"' AND "
	cQuery += cCampo4 +" = '" +cLoja +"' AND "
	cQuery += cCampo5 +" = '" +cProduto +"'"
	
	TcQuery cQuery new Alias "TRB"
	
	If !TRB->( Eof() )
		cProduto2 := TRB->(&cCampo1)
	else
		
		If lJob
			ConOut(Replicate("=",80))
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" ReadXML Error:")
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Arquivo: " +cFile)
			ConOut("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Ocorrencia: " +If(cTipoNF == "N","fornecedor ","cliente ") +cCodigo +"/" +cLoja;
			+" sem cadastro de Produto X " +If(cTipoNF == "N","Fornecedor","Cliente");
			+" para o codigo " +cProduto +"-" + AllTrim(aItens[nX]:_PROD:_XPROD:TEXT) + ".")
			ConOut(Replicate("=",80))
			
			cEmailErro :="ReadXML Error:"+ENTER
			cEmailErro +="Arquivo: " +cFile+ENTER
			cEmailErro +="Ocorrencia: " +If(cTipoNF == "N","fornecedor ","cliente ") +cCodigo +"/" +cLoja;
			+" sem cadastro de Produto X " +If(cTipoNF == "N","Fornecedor","Cliente");
			+" para o codigo " +cProduto +"-" + AllTrim(aItens[nX]:_PROD:_XPROD:TEXT) + "."+ENTER
			
			//********************
			//ENVIA E-MAIL
			//********************
			//EnviarEmail('','Inconsistencia Importação NF-e',"Arquivo: " +cFile, cEmailErro, .T. ,cEmailAdm,'')
			
		else
			
			nOpc := Aviso("XML", 'Atenção Produto '+ cProduto + ': '+ AllTrim(aItens[nX]:_PROD:_XPROD:TEXT) + ;
			' Não Encontrado na Amarraçâo Prod. x Fornecedor, Deseja incluir?', {"Sim","Não","Cancelar"})
			
			if nOpc == 1
				//MsgYesNo('Atencao Produto '+ cProduto + ': '+ AllTrim(aItens[nX]:_PROD:_XPROD:TEXT) +' Não Encontrado na Amarraçâo Prod. x Fornecedor, Deseja incluir?' )
				
				cProduto2	:= cProduto+Space(15-Len(cProduto))
				
				@ 65,153 To 229,435 Dialog oDlg Title OemToAnsi("Inclusão Amarração")
				@ 09,009 Say OemToAnsi("Produto") Size 99,8
				@ 15,009 Say OemToAnsi( AllTrim(aItens[nX]:_Prod:_cProd:Text) + "-" + aItens[nX]:_PROD:_XPROD:TEXT) Size 99,8
				@ 28,009 Get cProduto2 Picture "@!" F3 "SB1" VALID Existcpo("SB1",cProduto2) Size 59,10
				@ 62,039 BMPBUTTON TYPE 1 ACTION Close(oDlg)
				Activate Dialog oDlg Centered
				
				If !Empty(cProduto2)
					
					If cTipoNF # "N"
						dbselectarea("SA7")
						SA7->(DbSetOrder(1))
						if !SA7->(Dbseek(xFilial("SA7") + cCodigo + cLoja + cProduto2))
							
							RecLock("SA7",.T.)
							SA7->A7_FILIAL 	:= xFilial("SA7")
							SA7->A7_CLIENTE	:= cCodigo
							SA7->A7_LOJA 	:= cLoja
							SA7->A7_CODCLI  := cProduto
							SA7->A7_PRODUTO := cProduto2
							SA7->( MsUnlock() )
							
						endif
					else
						dbselectarea("SA5")
						SA5->(DbSetOrder(1))
						if !SA5->(Dbseek(xFilial("SA5") + cCodigo + cLoja + cProduto2))
							
							RecLock("SA5",.T.)
							SA5->A5_FILIAL 	:= xFilial("SA5")
							SA5->A5_FORNECE := cCodigo
							SA5->A5_LOJA 	:= cLoja
							SA5->A5_NOMEFOR	:= Posicione("SA2",1,xFilial("SA2")+cCodigo,"A2_NOME")
							SA5->A5_CODPRF	:= cProduto
							SA5->A5_PRODUTO := cProduto2
							SA5->A5_NOMPROD := Posicione("SB1",1,xFilial("SB1")+cProduto2,"B1_DESC")
							SA5->( MsUnlock() )
							
						endif
						
					Endif
					
				Else
					//-- Move arquivo para pasta dos erros
					cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
					
					//copia o arquivo antes da transacao
					cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
					
					If MsErase(cNomNovArq)
						__CopyFile(cArqTXT,cNomNovArq)
						FErase(cArqTXT)
					EndIf
					
					lProces := .F.
					Exit
					
				endif
				
			elseif nOpc == 3
				
				TRB->( dbCloseArea() )
				RestArea(aArea)
				Return(.F.)
				
			else
				
				cProduto2 := ""
				
			endIf
			
		endif
		
	endif
	
	TRB->( dbCloseArea() )
	
	conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Grava os Dados dos Itens - SDT")	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados dos Itens - SDT	   ³
	//³  DADOS DO PRODUTO      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMed := XmlChildEx(aItens[nX]:_PROD, "_MED")
	oVdesc := XmlChildEx(aItens[nX]:_PROD,"_VDESC")// Caso não exista o Objeto _VDESC no XML retorna NIL   -- Aluisio Gomes  
	aParx := {aItemSDT, aItens, (Len(aItemSDT)+1), cCGC, cProduto2, cCodigo,cLoja, cDoc, cSerie}
	If oMed <> NIL .and. ValType(aItens[nX]:_PROD:_MED) == "A"
	   
		For nY := 1  to len(aItens[nX]:_PROD:_MED)
			aParx := {aItemSDT, aItens, (Len(aItemSDT)+1), cCGC, cProduto2, cCodigo,cLoja, cDoc, cSerie}
			cDLote := aItens[nX]:_PROD:_MED[nY]:_DFAB:TEXT
			dLote  := stod( Substr(cDLote,1,4) + Substr(cDLote,6,2) + Substr(cDLote,9,2) ) 
			cLote := aItens[nX]:_PROD:_MED[nY]:_NLOTE:TEXT
			dVLote := aItens[nX]:_PROD:_MED[nY]:_DVAL:TEXT
			dVLote  := stod( Substr(dVLote,1,4) + Substr(dVLote,6,2) + Substr(dVLote,9,2) )
	
			AADD(aItemSDT,{	{"DT_FILIAL" 	,xFilial("SDT")														},; //Filial
				{"DT_CNPJ"		,cCGC																},; //CGC
				{"DT_COD"		,cProduto2															},; //Codigo do produto
				{"DT_PRODFOR"	,aItens[nX]:_PROD:_CPROD:TEXT										},; //Cdgo do pduto do Fornecedor
				{"DT_DESCFOR"	,aItens[nX]:_PROD:_XPROD:TEXT										},; //Dcao do pduto do Fornecedor
				{"DT_ITEM"   	,PadL(len(aItemSDT)+1,TamSX3("D1_ITEM")[1],"0")						},; //Item
				{"DT_QUANT"  	,Val(aItens[nX]:_Prod:_MED[nY]:_QLOTE:Text)						},; //Qtde
				{"DT_VUNIT"		,Round(Val(aItens[nX]:_Prod:_vUnCom:Text),TamSX3("DT_VUNIT")[2])	},; //Vlor Unitário
				{"DT_FORNEC"	,cCodigo															},; //Forncedor
				{"DT_LOJA"   	,cLoja																},; //Lja
				{"DT_DOC"    	,cDoc																},; //DocmTo
				{"DT_SERIE"		,cSerie							   									},; //Serie
				{"DT_TOTAL"		,Val(aItens[nX]:_Prod:_vProd:Text)/Val(aItens[nX]:_Prod:_qCom:Text);
								*Val(aItens[nX]:_Prod:_MED[nY]:_QLOTE:Text)						},; //Vlor Total 
				{"DT_VALDESC"	,Round(IIF(ValType(oVdesc) <> "U",; 
				 						RatDesc(oVdesc,aItens,nX,nY),0),TamSX3("C7_VLDESC")[2])	},; //Vlor Desc  Aluisio						  
				{"DT_XUM"		,aItens[nX]:_PROD:_UCOM:TEXT										},;//Unidade de Medida
			 	{"DT_XDFABRI"	,dLote																},;//Data Fabricação lote
				{"DT_XLOTECT"	,cLote																},;//Nº do lote
			 	{"DT_XDTVLD"	,dVLote																}})//Data Vencimento Lote
			 	
			if ExistBlock("PCOMP002")     	 
				aParx 	   := ExecBlock("PCOMP002",.F.,.F.,aParx )
		
				aItemSDT  := aClone(aParx[1])
				aItens    := aClone(aParx[2])
			endif			
	
	    Next nY					
	    
	ElseIf oMed <> NIL .and. ValType(aItens[nX]:_PROD:_MED:_DFAB:TEXT)=="C" 
	      
		cDLote := aItens[nX]:_PROD:_MED:_DFAB:TEXT
		dLote  := stod( Substr(cDLote,1,4) + Substr(cDLote,6,2) + Substr(cDLote,9,2) ) 
		cLote := aItens[nX]:_PROD:_MED:_NLOTE:TEXT
		dVLote := aItens[nX]:_PROD:_MED:_DVAL:TEXT
		dVLote  := stod( Substr(dVLote,1,4) + Substr(dVLote,6,2) + Substr(dVLote,9,2) )
		AADD(aItemSDT,{	{"DT_FILIAL" 	,xFilial("SDT")														},; //Filial
						{"DT_CNPJ"		,cCGC																},; //CGC
						{"DT_COD"		,cProduto2															},; //Codigo do produto
						{"DT_PRODFOR"	,aItens[nX]:_PROD:_CPROD:TEXT										},; //Cdgo do pduto do Fornecedor
						{"DT_DESCFOR"	,aItens[nX]:_PROD:_XPROD:TEXT										},; //Dcao do pduto do Fornecedor
						{"DT_ITEM"   	,PadL(len(aItemSDT)+1,TamSX3("D1_ITEM")[1],"0")/*PadL(aItens[nX]:_nItem:Text,TamSX3("D1_ITEM")[1],"0")*/ },; //Item
						{"DT_QUANT"  	,Val(aItens[nX]:_Prod:_qCom:Text)									},; //Qtde
						{"DT_VUNIT"		,Round(Val(aItens[nX]:_Prod:_vUnCom:Text),TamSX3("DT_VUNIT")[2])	},; //Vlor Unitário
						{"DT_FORNEC"	,cCodigo															},; //Forncedor
						{"DT_LOJA"   	,cLoja																},; //Lja
						{"DT_DOC"    	,cDoc																},; //DocmTo
						{"DT_SERIE"		,cSerie							   									},; //Serie
						{"DT_TOTAL"		,Val(aItens[nX]:_Prod:_vProd:Text)									},; //Vlor Total 
						{"DT_VALDESC"	,Round(Val(IIF(ValType(oVdesc) <> "U",; 
						 						aItens[nX]:_PROD:_VDESC:TEXT,"0")),TamSX3("C7_VLDESC")[2])	},;//Vlor Desc  Aluisio						  
				 		{"DT_XUM"		,aItens[nX]:_PROD:_UCOM:TEXT										},;//Unidade de Medida
			  			{"DT_XDFABRI"	,dLote																},;//Data Fabricação lote
						{"DT_XLOTECT"	,cLote																},;//Nº do lote
			   			{"DT_XDTVLD"	,dVLote																}})//Data Vencimento Lote 
			   			
		if ExistBlock("PCOMP002")     	 
			aParx 	   := ExecBlock("PCOMP002",.F.,.F.,aParx )

			aItemSDT  := aClone(aParx[1])
			aItens    := aClone(aParx[2])
		endif  
			   			 
	Else
		AADD(aItemSDT,{	{"DT_FILIAL" 	,xFilial("SDT")														},; //Filial
					{"DT_CNPJ"		,cCGC																},; //CGC
					{"DT_COD"		,cProduto2															},; //Codigo do produto
					{"DT_PRODFOR"	,aItens[nX]:_PROD:_CPROD:TEXT										},; //Cdgo do pduto do Fornecedor
					{"DT_DESCFOR"	,aItens[nX]:_PROD:_XPROD:TEXT										},; //Dcao do pduto do Fornecedor
					{"DT_ITEM"   	,PadL(len(aItemSDT)+1,TamSX3("D1_ITEM")[1],"0")/*PadL(aItens[nX]:_nItem:Text,TamSX3("D1_ITEM")[1],"0")*/ },; //Item
					{"DT_QUANT"  	,Val(aItens[nX]:_Prod:_qCom:Text)									},; //Qtde
					{"DT_VUNIT"		,Round(Val(aItens[nX]:_Prod:_vUnCom:Text),TamSX3("DT_VUNIT")[2])	},; //Vlor Unitário
					{"DT_FORNEC"	,cCodigo															},; //Forncedor
					{"DT_LOJA"   	,cLoja																},; //Lja
					{"DT_DOC"    	,cDoc																},; //DocmTo
					{"DT_SERIE"		,cSerie							   									},; //Serie
					{"DT_TOTAL"		,Val(aItens[nX]:_Prod:_vProd:Text)									},; //Vlor Total 
					{"DT_VALDESC"	,Round(Val(IIF(ValType(oVdesc) <> "U",; 
					 						aItens[nX]:_PROD:_VDESC:TEXT,"0")),TamSX3("C7_VLDESC")[2])	},; //Vlor Desc  Aluisio						  
			 		{"DT_XUM"		,aItens[nX]:_PROD:_UCOM:TEXT										}})	
	   
		if ExistBlock("PCOMP002")     	 
			aParx 	   := ExecBlock("PCOMP002",.F.,.F.,aParx )

			aItemSDT  := aClone(aParx[1])
			aItens    := aClone(aParx[2])
		endif	 			   			

	EndIf

/******************************	
	if ExistBlock("PCOMP002")     	 
		aParx 	   := ExecBlock("PCOMP002",.F.,.F.,aParx )
		aItemSDT2  := aParx[1]
		aItens     := aParx[2]
		aAdd(aItemSDT, aItemSDT2) 
	else
		AADD(aItemSDT,{{"DT_FILIAL" 	,xFilial("SDT")														},; //Filial
						{"DT_CNPJ"		,cCGC																},; //CGC
						{"DT_COD"		,cProduto2															},; //Codigo do produto
						{"DT_PRODFOR"	,aItens[nX]:_PROD:_CPROD:TEXT										},; //Cdgo do pduto do Fornecedor
						{"DT_DESCFOR"	,aItens[nX]:_PROD:_XPROD:TEXT										},; //Dcao do pduto do Fornecedor
						{"DT_ITEM"   	,PadL(aItens[nX]:_nItem:Text,TamSX3("D1_ITEM")[1],"0")				},; //Item
						{"DT_QUANT"  	,Val(aItens[nX]:_Prod:_qCom:Text)									},; //Qtde
						{"DT_VUNIT"		,Round(Val(aItens[nX]:_Prod:_vUnCom:Text),TamSX3("C7_PRECO")[2])	},; //Vlor Unitário
						{"DT_FORNEC"	,cCodigo															},; //Forncedor
						{"DT_LOJA"   	,cLoja																},; //Lja
						{"DT_DOC"    	,cDoc																},; //DocmTo
						{"DT_SERIE"		,cSerie							   									},; //Serie
						{"DT_TOTAL"		,Val(aItens[nX]:_Prod:_vProd:Text)									},; //Vlor Total   
						{"DT_XUM"		,aItens[nX]:_PROD:_UCOM:TEXT										}}) //Unidade de Medida	
	endif
*********************************/
	    	
Next nX

endif


if Select("TRB") > 0
	TRB->( dbCloseArea() )
endif

if !Empty(aItemSDT) .And. !Empty(aHeadSDS)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava os dados do cabeçalho e itens da nota importada do XML³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Grava os dados do cabeçalho e itens da nota importada do XML")	
	Begin Transaction
	
	aHeadSDS:=aHeadSDS[1]
	
	//********************
	//--Grava cabeçalho
	//********************
	
	SDS->(DbSetOrder(1))
	if SDS->(DbSeek(xFilial("SDS") + aHeadSDS[3][2] + aHeadSDS[4][2] + aHeadSDS[5][2] + aHeadSDS[6][2] ))
		RecLock("SDS",.F.)
	else
		RecLock("SDS",.T.)
	endif
	
	For nX:=1 To Len(aHeadSDS)
		
		SDS->&(aHeadSDS[nX][1]):= aHeadSDS[nX][2]
		
	Next nX
	
	SDS->( MsUnlock() )
  	conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Gravou SDS")	
	
	//*****************
	//--Grava Itens
	//*****************   
	if SELECT("SDT") > 0 
		SDT->(DBCLOSEAREA())
	endif                  
	DBSELECTAREA("SDT")	
	
	For nZ:=1 To Len(aItemSDT)
		
		if !ExistBlock("PCOMP002")
			SDT->(DbSetOrder(4)) // DT_FILIAL + DT_FORNEC + DT_LOJA + DT_DOC + DT_SERIE + DT_ITEM
			if SDT->(DbSeek(aItemSDT[nZ][1][2] + aItemSDT[nZ][9][2] + aItemSDT[nZ][10][2] + aItemSDT[nZ][11][2] + aItemSDT[nZ][12][2] + aItemSDT[nZ][6][2]))
				RecLock("SDT",.F.)
			else
				RecLock("SDT",.T.)
			endif
			For nW:=1 To Len(aItemSDT[nZ])
				SDT->&(aItemSDT[nZ][nW][1]):= aItemSDT[nZ][nW][2]
			Next nW
		else
			SDT->(DbSetOrder(4)) // DT_FILIAL + DT_FORNEC + DT_LOJA + DT_DOC + DT_SERIE + DT_ITEM
// ANDERSON ESTAVA COM UMA DIMENSAO A MAIS
			if SDT->(DbSeek(aItemSDT[nZ][1][2] + aItemSDT[nZ][9][2] + aItemSDT[nZ][10][2] + aItemSDT[nZ][11][2] + aItemSDT[nZ][12][2] + aItemSDT[nZ][6][2]))
				RecLock("SDT",.F.)
			else
				RecLock("SDT",.T.)
			endif
			For nW:=1 To Len(aItemSDT[nZ])
// ANDERSON 1 DIMENSAO A MAIS TAMBEM
				SDT->&(aItemSDT[nZ][nW][1]):= aItemSDT[nZ][nW][2]
			Next nW
		endif
		//SDT->( dbCommit() )
		SDT->( MsUnlock() )
  	conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Gravou SDT")	
		
	Next nZ
	
	cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
	
	//copia o arquivo antes da transacao
	cNomNovArq  := cStartBkp + iif(IsSrvUnix(),"/","\") + cFile
	
	If MsErase(cNomNovArq)
		__CopyFile(cArqTXT,cNomNovArq)
		FErase(cArqTXT)
	EndIf
	
	End Transaction
	
else    

	//-- Move arquivo para pasta dos erros
	cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
	cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
	
	If MsErase(cNomNovArq)
		__CopyFile(cArqTXT,cNomNovArq)
		FErase(cArqTXT)
	EndIf
	
endIf    

RestArea(aArea)

Return(lProces)

//************************************
//     CADASTRO DE FORNECEDORES
//************************************
Static Function CadFornec(oXML, lJob, cXML)
Local aCab:={}, cCodigo := ""
Local aCodBlock := {}, cLoja := "" //Alterado 27-05-2014

Private lMSErroAuto := .F.
Private lMsHelpAuto := .T.

//******************************
// Alterado 27-05-2014
//******************************
if ExistBlock("U_ACMPFOR")
	aCodBlock := U_ACMPFOR()
	cCodigo := aCodBlock[01]
	cLoja	:= aCodBlock[02]
else
	cCodigo := GetSXENum("SA2","A2_COD")
	cLoja 	:= "01"
endif
//******************************
// //Alterado 27-05-2014 - FIM
//******************************


If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013
 cNome   := oXML:_INFCTE:_EMIT:_XNOME:TEXT 
 cNomRed := oXML:_INFCTE:_EMIT:_XNOME:TEXT
 cEnd    := AllTrim(oXML:_INFCTE:_EMIT:_ENDEREMIT:_XLGR:TEXT) + "," + AllTrim(oXML:_INFCTE:_DEST:_ENDERDEST:_NRO:TEXT)
 cBairro := oXML:_INFCTE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT                                                                
 cEstad  := oXML:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT
 cCodMun := Substr(oXML:_INFCTE:_EMIT:_ENDEREMIT:_CMUN:TEXT,3,5)
 cMun    := oXML:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT 
 cCep    := oXML:_INFCTE:_EMIT:_ENDEREMIT:_CEP:TEXT
 cPessoa := iif( len(oXML:_INFCTE:_EMIT:_CNPJ:TEXT) == 14 .and. (!Empty(oXML:_INFCTE:_DEST:_IE:TEXT) .or. AllTrim(oXML:_INFCTE:_DEST:_IE:TEXT)<>"ISENTO"),"J","F")
 cCNPJ	 := oXML:_INFCTE:_EMIT:_CNPJ:TEXT   
 cTel    := iif( StaticCall(ACOMP004,XMLFind,oXML:_INFCTE:_EMIT:_ENDEREMIT,"_FONE"),oXML:_INFCTE:_EMIT:_ENDEREMIT:_FONE:TEXT,"999999999")
 cINSCR  := iif( Empty(oXML:_INFCTE:_EMIT:_IE:TEXT),"ISENTO",oXML:_INFCTE:_EMIT:_IE:TEXT)
 cEmail  := iif( StaticCall(ACOMP004,XMLFind,oXML:_INFCTE:_EMIT:_ENDEREMIT,"_EMAIL"),oXML:_INFCTE:_EMIT:_EMAIL:TEXT,".")
 cTipoUs := iif( len(oXML:_INFCTE:_EMIT:_CNPJ:TEXT) == 14, "J","F" )
else
 cNome   := oXML:_INFNFE:_EMIT:_XNOME:TEXT 
 cNomRed := oXML:_INFNFE:_EMIT:_XNOME:TEXT
 cEnd    := AllTrim(oXML:_INFNFE:_EMIT:_ENDEREMIT:_XLGR:TEXT) + "," + AllTrim(oXML:_INFNFE:_DEST:_ENDERDEST:_NRO:TEXT)
 cBairro := oXML:_INFNFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT                                                                
 cEstad  := oXML:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT
 cCodMun := Substr(oXML:_INFNFE:_EMIT:_ENDEREMIT:_CMUN:TEXT,3,5)
 cMun    := oXML:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT 
 cCep    := oXML:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT
 cPessoa := iif( len(oXML:_INFNFE:_EMIT:_CNPJ:TEXT) == 14 .and. (!Empty(oXML:_INFNFE:_DEST:_IE:TEXT) .or. AllTrim(oXML:_INFNFE:_DEST:_IE:TEXT)<>"ISENTO"),"J","F")
 cCNPJ	 := oXML:_INFNFE:_EMIT:_CNPJ:TEXT   
 cTel    := iif( StaticCall(ACOMP004,XMLFind,oXML:_INFNFE:_EMIT:_ENDEREMIT,"_FONE"),oXML:_INFNFE:_EMIT:_ENDEREMIT:_FONE:TEXT,"999999999")
 cINSCR  := iif( Empty(oXML:_INFNFE:_EMIT:_IE:TEXT),"ISENTO",oXML:_INFNFE:_EMIT:_IE:TEXT)
 cEmail  := iif( StaticCall(ACOMP004,XMLFind,oXML:_INFNFE:_EMIT:_ENDEREMIT,"_EMAIL"),oXML:_INFNFE:_EMIT:_EMAIL:TEXT,".")
 cTipoUs := iif( len(oXML:_INFNFE:_EMIT:_CNPJ:TEXT) == 14, "J","F" ) 
endif

aFornecedor :={;
{"A2_COD"    	, cCodigo                               ,Nil},; 
{"A2_LOJA"   	, cLoja									,Nil},; 
{"A2_NOME"   	, cNome                                	,Nil},; 
{"A2_NREDUZ" 	, cNomRed                              	,Nil},; 
{"A2_END"    	, cEnd									,Nil},; 
{"A2_BAIRRO" 	, cBairro					 			,Nil},;
{"A2_EST"    	, cEstad                         		,Nil},; 
{"A2_COD_MUN"	, cCodMun			 					,Nil},;
{"A2_MUN"    	, cMun                       			,Nil},;
{"A2_CEP"    	, cCep		 							,Nil},; 
{"A2_TIPO"   	, cPessoa								,Nil},; 
{"A2_CGC"    	, cCNPJ									,Nil},; 
{"A2_TEL"    	, cTel	   								,Nil},; 
{"A2_INSCR"  	, cINSCR								,Nil},; 
{"A2_PAIS"   	, "105"                                 ,Nil},; 
{"A2_EMAIL"  	, cEmail								,Nil},; 
{"A2_TIPORUR"	, cTipoUs       												,Nil},; 
{"A2_CODPAIS"	, "01058"                                                        												,Nil} } 

Begin Transaction

conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Incluindo Fornecedor....Antes: MSExecAuto({|x,y| Mata020(x,y)},aFornecedor,3) //Inclusao")	

MSExecAuto({|x,y| Mata020(x,y)},aFornecedor,3) //Inclusao 

conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Forncedor Incluso.... Depois: MSExecAuto({|x,y| Mata020(x,y)},aFornecedor,3) //Inclusao")	

End Transaction

If lMsErroAuto
	if lJob      
	
		//-- Move arquivo para pasta dos erros
		cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
		cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
	
		If MsErase(cNomNovArq)
			__CopyFile(cArqTXT,cNomNovArq)
			FErase(cArqTXT)
		EndIf     		
		Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Erro ao tentar incluir o fornecedor!")
		
	else
		MostraErro()
	endif  
	
	//Break
	Return(.F.) 
	
else
	ConfirmSX8()
Endif

Return(.T.)

//************************************
//     CADASTRO DE CLIENTES
//************************************
Static Function CadClient(oXML, lJob, cXML)

Local aCab:={}, cCodigo := ""

Private lMSErroAuto := .F.
Private lMsHelpAuto := .T.

cCodigo     := GetSXENum("SA1","A1_COD")
       
If "</CTE>" $ Upper(cXML) //sangelles sousa moraees 17/12/2013
 cNome   := oXML:_INFCTE:_EMIT:_XNOME:TEXT 
 cNomRed := oXML:_INFCTE:_EMIT:_XNOME:TEXT
 cEnd    := AllTrim(oXML:_INFCTE:_EMIT:_ENDEREMIT:_XLGR:TEXT) + "," + AllTrim(oXML:_INFCTE:_DEST:_ENDERDEST:_NRO:TEXT)
 cBairro := oXML:_INFCTE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT                                                                
 cEstad  := oXML:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT
 cCodMun := Substr(oXML:_INFCTE:_EMIT:_ENDEREMIT:_CMUN:TEXT,3,5)
 cMun    := oXML:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT 
 cCep    := oXML:_INFCTE:_EMIT:_ENDEREMIT:_CEP:TEXT
 cPessoa := iif( len(oXML:_INFCTE:_EMIT:_CNPJ:TEXT) == 14 .and. (!Empty(oXML:_INFCTE:_DEST:_IE:TEXT) .or. AllTrim(oXML:_INFCTE:_DEST:_IE:TEXT)<>"ISENTO"),"J","F")
 cCNPJ	 := oXML:_INFCTE:_EMIT:_CNPJ:TEXT   
 cTel    := iif( StaticCall(ACOMP004,XMLFind,oXML:_INFCTE:_EMIT:_ENDEREMIT,"_FONE"),oXML:_INFCTE:_EMIT:_ENDEREMIT:_FONE:TEXT,"999999999")
 cINSCR  := iif( Empty(oXML:_INFCTE:_EMIT:_IE:TEXT),"ISENTO",oXML:_INFCTE:_EMIT:_IE:TEXT)
 cEmail  := iif( StaticCall(ACOMP004,XMLFind,oXML:_INFCTE:_EMIT:_ENDEREMIT,"_EMAIL"),oXML:_INFCTE:_EMIT:_EMAIL:TEXT,".")
else
 cNome   := oXML:_INFNFE:_EMIT:_XNOME:TEXT 
 cNomRed := oXML:_INFNFE:_EMIT:_XNOME:TEXT
 cEnd    := AllTrim(oXML:_INFNFE:_EMIT:_ENDEREMIT:_XLGR:TEXT) + "," + AllTrim(oXML:_INFNFE:_DEST:_ENDERDEST:_NRO:TEXT)
 cBairro := oXML:_INFNFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT                                                                
 cEstad  := oXML:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT
 cCodMun := Substr(oXML:_INFNFE:_EMIT:_ENDEREMIT:_CMUN:TEXT,3,5)
 cMun    := oXML:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT 
 cCep    := oXML:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT
 cPessoa := iif( len(oXML:_INFNFE:_EMIT:_CNPJ:TEXT) == 14 .and. (!Empty(oXML:_INFNFE:_DEST:_IE:TEXT) .or. AllTrim(oXML:_INFNFE:_DEST:_IE:TEXT)<>"ISENTO"),"J","F")
 cCNPJ	 := oXML:_INFNFE:_EMIT:_CNPJ:TEXT   
 cTel    := iif( StaticCall(ACOMP004,XMLFind,oXML:_INFNFE:_EMIT:_ENDEREMIT,"_FONE"),oXML:_INFNFE:_EMIT:_ENDEREMIT:_FONE:TEXT,"999999999")
 cINSCR  := iif( Empty(oXML:_INFNFE:_EMIT:_IE:TEXT),"ISENTO",oXML:_INFNFE:_EMIT:_IE:TEXT)
 cEmail  := iif( StaticCall(ACOMP004,XMLFind,oXML:_INFNFE:_EMIT:_ENDEREMIT,"_EMAIL"),oXML:_INFNFE:_EMIT:_EMAIL:TEXT,".")
endif

aCliente :={;
{"A1_COD"    	, cCodigo                                                                		,Nil},; //Codigo     -C-06
{"A1_LOJA"   	, "01"                                                           				,Nil},; //Loja       -C-02
{"A1_NOME"   	, cNome				            			                     				,Nil},; //Nome       -C-40
{"A1_NREDUZ" 	, cNomRed						                                 				,Nil},; //Nome Reduz.-C-20
{"A1_END"    	, cEnd																			,Nil},; //Logradouro -C-40
{"A1_BAIRRO" 	, cBairro														 				,Nil},; //Bairro     -C-30
{"A1_EST"    	, cEstad								                         				,Nil},; //Estado     -C-02
{"A1_COD_MUN"	, cCodMun														 				,Nil},; //Cod.Munic. -C-05
{"A1_MUN"    	, cMun										                       				,Nil},; //Cidade     -C-25
{"A1_CEP"    	, cCep															 				,Nil},; //CEP        -C-08
{"A1_PESSOA"  	, cPessoa																		,Nil},; //Tipo       -C-01 //F Final
{"A1_CGC"    	, cCNPJ															 				,Nil},; //CPF-CNPJ   -C-14
{"A1_TEL"    	, cTel																			,Nil},; //Telefone   -C-15
{"A1_INSCR"  	, cINSCR																		,Nil},; //Insc.Est. -C-18
{"A1_PAIS"   	, "105"                                                          				,Nil},; //Cod.País   -C-05
{"A1_EMAIL"  	, cEmail																		,Nil},; //ContaCont. -C-20
{"A1_TIPO"   	, "F"                                                            				,Nil},; //Tipo = F - Cons.Final
{"A1_CODPAIS"	, "01058"                                                        				,Nil} } //Cod.País   -C-05

Begin Transaction

MSExecAuto({|x,y| Mata030(x,y)},aCliente,3) //Inclusao   

End Transaction 

If lMsErroAuto
	if lJob         
	
		//-- Move arquivo para pasta dos erros
		cArqTXT := cStartLido + iif(IsSrvUnix(),"/","\") + cFile
		cNomNovArq  := cStartError + iif(IsSrvUnix(),"/","\") + cFile
	
		If MsErase(cNomNovArq)
			__CopyFile(cArqTXT,cNomNovArq)
			FErase(cArqTXT)
		EndIf
		Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Erro ao tentar incluir o cliente!")   
		
	else
		MostraErro()
	endif 
	
	Break
	Return(.F.)
	
else
	ConfirmSX8()
Endif

Return (.T.) 



Static Function RatDesc(oVdesc,aItens,nX,nY)

Local nValDesc := 0
                                         //Desconto do produto/Qtd total*Qtd Lote
nValDesc := IIF(ValType(oVdesc) <> "U",((val(aItens[nX]:_PROD:_VDESC:TEXT)/Val(aItens[nX]:_Prod:_qCom:Text))*Val(aItens[nX]:_Prod:_MED[nY]:_QLOTE:Text)),0)



Return nValDesc
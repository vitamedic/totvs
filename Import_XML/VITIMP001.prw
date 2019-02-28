#INCLUDE "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "XMLXFUN.CH"
#include "Ap5Mail.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} VITIMP001
//TODO Descrição auto-gerada.
@author andre.alves
@since 13/09/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User Function VITIM001()

Local aArea			:= GetArea()
Local aFileAtch 	:= {}
Local cServer 		:= ""
Local cSenhaa 		:= ""
Local cFrom 		:= ""
Local cConta   		:= ""
Local cStrAtch		:= ""
Local xCnpj			:= ""
Local xCaminho 		:= ""
Local lRelauth		:= .F., lResult := .F., lRet := .F., lWeb := .F.
Local ixIni 		:= 0, ixFim := 0, _opx := 0
Local oXml			:= {}
Local cIniFile 		:= GetADV97()
Local nMessages		:= 0
Local zX 			:= 0, nXml := 0, nX := 0
Local aResult   	:= Array(8)
Local cStartPath 	:= "", cNovoNome := ""
Local __nHdlPOP 	:= 1
Local lTLS 			:= .F.
Local lSSL 			:= .F.
Local _axEmp 		:= {}
Local cEmpAtu		:= ""
Local cErro			:= ""
Local nResultDel   
Private cProtocolo  := ""

OpenSm0()
SM0->( DbGoTop() )
While SM0->(!EOF()) .and. Empty(SM0->M0_CGC) .OR. SM0->(Deleted()) // nao considerar a empresa 99 (teste)
	SM0->(DbSkip())
EndDo 

cCNPJ := alltrim(SM0->M0_CGC)
if !U_ALIBE001('000003 - IMPORTACAO XML',cCNPJ,"Processo de Importação de XML!")
	Return
endif


//*****************************
// CRIA DIRETORIOS RAIZ
//*****************************
cRootPath := GetPvProfString(GetEnvServer(),"RootPath","",GetADV97())
cStartPath 	:= Alltrim( GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile ) ) //start path

MakeDir( cStartPath + "xml" )
MakeDir( cStartPath + iif(IsSrvUnix(),"xml/inbox","xml\inbox") ) //CRIA DIRETOTIO ENTRADA
MakeDir( cStartPath + iif(IsSrvUnix(),"xml/temp","xml\temp") ) //CRIA DIRETOTIO ENTRADA

//*************************
//   CARREGA EMPRESAS
//*************************

while !SM0->( Eof() )
	
	aadd(_axEmp, { AllTrim(SM0->M0_CODIGO),AllTrim(SM0->M0_CODFIL),SM0->M0_FILIAL,SM0->M0_CGC} )
	
	//****************************************
	// CRIA DIRETORIOS DAS EMPRESAS E FILIAIS
	//****************************************
	if SM0->M0_CODIGO <> cEmpAtu
		MakeDir( cStartPath + iif(IsSrvUnix(),"xml/inbox" + "/" + "E " + SM0->M0_CODIGO ,"xml\inbox" + "\" + "E " + SM0->M0_CODIGO) )
		cEmpAtu := SM0->M0_CODIGO
	endif
	MakeDir( cStartPath + iif(IsSrvUnix(),"xml/inbox" + "/" + "E " + SM0->M0_CODIGO + "/" + "F " + SM0->M0_CODFIL ,"xml\inbox" + "\" + "E " + SM0->M0_CODIGO + "\" + "F " + SM0->M0_CODFIL) )
	
	SM0->( DbSkip() )
	
enddo
SM0->( DbGoTop() )

conout("(Importacao de XML) "+ OemtoAnsi(" Entrando no RpcSetEnv: Empresa: "+_axEmp[1][1]+" Filial: "+ _axEmp[1][2]))
RpcSetType(3)
Reset Environment
RpcSetEnv(_axEmp[1][1],_axEmp[1][2]) //Vai preparar na primeira empresa
conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ OemtoAnsi(" Passou no RpcSetEnv: Empresa: "+_axEmp[1][1]+" Filial: "+ _axEmp[1][2]))

conout(Replicate("=",85))
Conout("INICIO DO JOB DE IMPORTACAO DO XML( Importação de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time())
conout(Replicate("=",85))


//Sangelles 05/11/2013******For nContEmp:= 1 To Len (_axEmp)

lWeb := .T.
//Sangelles 05/11/2013******RpcSetType(3)
//Sangelles 05/11/2013******Reset Environment
//Sangelles 05/11/2013******RpcSetEnv(_axEmp[nContEmp][1],_axEmp[nContEmp][2])


if Empty(GetNewPar("MV_XCCML",""))
	conout(" ")
	conout(Replicate("=",80))
	conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ OemtoAnsi(" Não existe email cadatrado para importaçaõ do XML." ))
	conout(Replicate("=",80))
	return
elseif Empty(GetNewPar("MV_XSERV",""))
	conout(" ")
	conout(Replicate("=",80))
	conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ OemtoAnsi(" Não existe email do servidor cadatrado para importaçaõ do XML."))
	conout(Replicate("=",80))
	return
endif

cPopServer        := AllTrim( SuperGetMV("MV_XSERV") )	// Endereco do servidor de e-mail
cAccount          := AllTrim( SuperGetMV("MV_XCCML"))  //Conta de E-mail
cPwd              := AllTrim( SuperGetMV("MV_XPSW"))	// Senha da conta de e-mail
nPortPop          := 		  SuperGetMV("MV_XPORT")    //Porta de Recebimento


if empty(cPopServer)
	conout(" ")
	conout(Replicate("=",80))
	conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ OemtoAnsi(" Não existe email do servidor cadastrado para importaçaõ do XML. (Parametro: MV_XSERV)"))
	conout(Replicate("=",80))
	return
endif

if empty(cAccount)
	conout(" ")
	conout(Replicate("=",80))
	conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ OemtoAnsi(" Não existe contda do email cadastrado para importaçaõ do XML. (Parametro: MV_XCCML)"))
	conout(Replicate("=",80))
	return
endif

if empty(cPwd)
	conout(" ")
	conout(Replicate("=",80))
	conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ OemtoAnsi(" Não existe senha de email cadastrado para importaçaõ do XML. (Parametro: MV_XPORT)"))
	conout(Replicate("=",80))
	return
endif

if empty(nPortPop)
	conout(" ")
	conout(Replicate("=",80))
	conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ OemtoAnsi(" Não existe Porta de email cadastrado para importaçaõ do XML. (Parametro: MV_XPSW)"))
	conout(Replicate("=",80))
	return
endif


nMessages := 0

Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Iniciando a conexão om o servidor de E-Mail! ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CONECTA NO SERVIDOR			                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cServer	 := "pop.gmail.com"  //GETMV("MV_XSERV")	// Endereco do servidor de e-mail
//cContaa	 := "nfe@redemarajo.com.br"      //GETMV("MV_XCCML")
//cSenhaa  := "nfe10101099"
conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ OemtoAnsi(" Conectando no e-mail: MV_XSERV: "+cPopServer+" MV_XCCML: "+cAccount+" MV_XPSW: "+cPwd+" MV_XPORT: "+ str(nPortPop)))


oPopServer := TMailManager():New()
oPopServer:SetUseSSL(SuperGetMV("MV_XUSESSL",.f., .t.))  
oPopServer:SetUseTLS(SuperGetMV("MV_XUSETLS",.F., .T.))


nPopResult := oPopServer:Init(cPopServer ,"", cAccount, cPwd, nPortPop)

If nPopResult != 0
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " retorno init:  "+cValtochar(nPopResult))
	cErro := oPopServer:GetErrorString(nPopResult)
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Erro:  "+cErro)
	Return
EndIf

nPopResult := oPopServer:PopConnect()

If nPopResult != 0
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " retorno PopConnect:  "+cValtochar(nPopResult))
	cErro := oPopServer:GetErrorString(nPopResult)
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Erro:  "+cErro)
	Return
Else //CONECTOU COM SUCESSO
	
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Conexão om o servidor de E-Mail efetuada com sucesso! ")
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Foi conectado na conta: " + cAccount + " servidor: " + cPopServer)
	
	
	oPopServer:GetNumMsgs(@nMessages) //Parametro para verificar quantos e-mails tem!
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " E-mails encontrados para importação: " + cValToChar(nMessages))
	
	
	If nMessages > 0
		
		oMessage := TMailMessage():New()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Recebe as mensagens e grava os arquivos XML           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nXml := 0
		
		For nX := 1 to nMessages
			
			Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Iniciando o processo... Email " + cValToChar(nX) + " de " + cValToChar(nMessages))
			
			If nXml == 500
				Exit
			EndIf
			Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Lendo e-mail -->" +cValToChar(nX))
			aFileAtch := {}
			cCaminho := cStartPath+ iif(IsSrvUnix(),"xml/temp","xml\temp") //Vou baixar tudo para o TEMP primeiro.
			oMessage:clear()
			nPopResult := oMessage:Receive( oPopServer, nx)
			
			if (nPopResult == 0 ) //Recebido com sucesso?
				
				nTotalAtt := oMessage:getAttachCount()
				
				Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Total de Anexo... Email " + cValToChar(nX) + " de " + cValToChar(nMessages)+" anexos "+ cValToChar(nTotalAtt))
				
				
				For nY := 1 to nTotalAtt
					
					Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Antes do aAttInfo:= oMessage:getAttachInfo(ny)")
					
					aAttInfo:= oMessage:getAttachInfo(nY)
					
					Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Depois do aAttInfo:= oMessage:getAttachInfo(nY)")
					
					
					Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Antes: cfile2save := aAttInfo[1]")
					Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Nme do anexo: aAttInfo[1]: "+AllTrim(aAttInfo[1]))
					cfile2save := StrTran(AllTrim(aAttInfo[1]), '"', '',,)//AllTrim(aAttInfo[1])                                                  
					Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Nme do anexo: cfile2save: "+cfile2save)
					//cNewString := strTran(<cString>, <cSearch>, [<cReplace>], [<nStart>], [<nCount>])
					Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Depois: cfile2save := aAttInfo[1]")
					
					
					if empty(cfile2save)
						cfile2save := StrTran(AllTrim(aAttInfo[4]), '"', '',,)
					Endif 
					
					if empty(cfile2save)
						cfile2save := "untitled-"+cvaltochar(nY)
					Endif
					
					Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Antes: If .XML $ Upper(cfile2save)")
					
					If ".XML" $ Upper(cfile2save)
						
						Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Antes: lSave := oMessage:SaveAttach(nY, cRootPath + cCaminho +'\'+ cfile2save)")
						
						Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Caminho: "+cRootPath + cCaminho +'\'+ cfile2save )
						
						lSave := oMessage:SaveAttach(nY, cRootPath + cCaminho +'\'+ cfile2save)  //VOU JOGAR NO TEMP PRIMEIRO
						
						Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Depois do lSave := oMessage:SaveAttach(ny, cRootPath + cCaminho +'\'+ cfile2save) " )
						
						if !lSave
							Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " 1->ERRO NA GRAVACAO DO ARQUIVO NO CAMINHO: "+ cRootPath + cCaminho +'\'+ cfile2save )
							loop
						endif
						Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Antes: cStrAtch := Memoread(cRootPath + cCaminho +'\'+ cfile2save)" )
						Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Caminho:= "+cCaminho +'\'+ cfile2save )
						cStrAtch := Memoread( cCaminho +'\'+ cfile2save)
						Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> cCaminho"+cCaminho )
						Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> cfile2save"+cfile2save )
						//Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> cfile2save"+cStrAtch )
						Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+  " >>> Antes: CREATE oXML XMLSTRING cStrAtch" )
						If "RETENVEVENTO" $ Upper(cStrAtch)// Se XML de evento ignora
							Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " 1->ARQUIVO XML DE EVENTO: "+ cRootPath + cCaminho +'\'+ cfile2save ) 
							loop
						Else
							FreeObj(oXML) 
							CREATE oXML XMLSTRING cStrAtch
						EndIf
						Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " PASSEI POR: 	CREATE oXML XMLSTRING cStrAtch")
						
						
						ixIni := At("<dest><CNPJ>",cStrAtch)
						xCNPJ := AllTrim( Substr(cStrAtch, ixIni+12, 14) )
						
						Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ ;
						" Verifica se o XML é de uma das empresas cadastradas. Total de Empresas: "+ alltrim(str(Len(_axEmp))))
						
						For nContEmp:= 1 To Len(_axEmp)
							
							Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+" Lendo Empresa de "+ alltrim(str(nContEmp))+" ate "+ alltrim(str(Len(_axEmp)))) ;
							
							if _axEmp[nContEmp][4] == xCNPJ
								
								
								cCamDest := (cStartPath + iif(IsSrvUnix(),"xml/inbox" + "/" + "E " + _axEmp[nContEmp][1] + "/" + "F " + _axEmp[nContEmp][2] ,"xml\inbox" + "\" + "E " + _axEmp[nContEmp][1] + "\" + "F " + _axEmp[nContEmp][2]))
								
								lSave := oMessage:SaveAttach(ny, cRootPath + cCamDest +'\'+ cfile2save)  //VOU JOGAR NO TEMP PRIMEIRO
								
								if !lSave
									Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " 2->ERRO NA GRAVACAO DO ARQUIVO NO CAMINHO: "+ cRootPath + cCamDest +'\'+ cfile2save )
									return
								else
									Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Copiando o arquivo XML: "+ cRootPath + cCaminho +'\'+ cfile2save)
								endif
								
								Ferase(cRootPath + cCaminho +'\'+ cfile2save) //EXCLUINDO O ARQUIVO DO TEMP
								
								Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Removendo o XML: "+ cRootPath + cCaminho +'\'+ cfile2save)
								exit
							endif
						Next nContEmp
						
					endif
				Next nY
			else
				conout(" ")
				conout(Replicate("=",80))
				conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ OemtoAnsi(" ERRO AO TENTAR LER O E-MAIL.....COMANDO: nPopResult := oMessage:Receive( oPopServer, nMessage) "))
				conout(Replicate("=",80))
				loop
			endif
			if SuperGetMv("MV_XDELEMA") //PARAMETRO SE E PARA EXCLUIR EMAIL DO SERVIDOR DE EMAIL.
				Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Deletando e-mail: "+cValToChar(nX))
				nResultDel := oPopServer:DeleteMsg(nX)
				If nResultDel == 0
					Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Parametro MV_XDELEMA marcado, foi excluso o e-mail do Servidor.")
				Else	
					Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Erro ao deletar e-mail --> "+cValToChar(nX)+" Código do erro => "+cValToChar(nResultDel))
				EndIf	
			endif
		Next nX
	Endif
	//else
	//	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Erro ao conectar no servidor de E-MAIL, verifique o MOTIVO! ")
	//	return
endif


Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " DISCONNECT POP SERVER" )
oPopServer:PopDisconnect()

//Sangelles 05/11/2013******Next nContEmp

Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Ira entrar no U_ACOMA002" )

U_VITIMP002()

RestArea(aArea)

conout(Replicate("=",85))
Conout("FIM DO JOB DE IMPORTACAO DO XML (Importação de XML) Data: "+Iif(Type('ddatabase')<>'U',dtoc(ddatabase),"")+ " Hora: "+time())
conout(Replicate("=",85))
RpcClearEnv()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VITIMP002  º Autor ³ Totvs              º Data ³  28/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importa os arquivos XML para a tabela temporarias SDS e SDTº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VITIMP002()

Local aArea			:= GetArea()
Local aFiles 		:= {}
Local _axEmp 		:= {}
Local nContEmp		:= 1
Local nX 			:= 0
Local nxEmp 		:= 0
Local cCodEmp 		:= ""
Local cCodFil		:= ""
Private aContas		:= {}
Private cIniFile	:= GetADV97()
Private cRootPath	:= ""
Private cStartPath	:= ""
Private cStartLido	:= ""
Private cStartError	:= ""
Private cStartBKP	:= ""

Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Iniciando a Importação dos arquivos XML para a tabela temporarias SDS e SDT" )

cStartPath 	:= alltrim( GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile ) ) //start path
cStartLido	:= alltrim(cStartPath)  + iif(IsSrvUnix(),'xml/inbox','xml\inbox') //arquivos de entrada
cStartError	:= alltrim(cStartPath)  + iif(IsSrvUnix(),'xml/erro','xml\erro') //path dos erros
cStartBKP	:= alltrim(cStartPath)  + iif(IsSrvUnix(),'xml/backup','xml\backup') //path dos erros

Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Diretórios: ")
Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " cStartPath: "+cStartPath)
Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " cStartLido: "+cStartLido)
Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " cStartError: "+cStartError)
Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " cStartBKP: "+cStartBKP)

//CRIA DIRETORIOS
MakeDir( cStartPath + iif(IsSrvUnix(),'xml','xml') )
MakeDir( cStartLido )       // CRIA DIRETOTIO ENTRADA
MakeDir( cStartError )		// CRIA DIRETORIO ERRO
MakeDir( cStartBKP )		// CRIA DIRETORIO BACKUP

//*************************
//   CARREGA EMPRESAS
//*************************

Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Carregando as empresas SMO")
OpenSm0()
SM0->( DbGoTop() )
while !SM0->( Eof() )
	
	aadd(_axEmp,{ AllTrim(SM0->M0_CODIGO),AllTrim(SM0->M0_CODFIL),SM0->M0_FILIAL,SM0->M0_CGC} )
	SM0->( DbSkip() )
	
enddo
SM0->( DbGoTop() )
Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Carregou as empresas SMO")

nExmp := Len(_axEmp)
nContEmp:= 1
Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Quantidade de empresas: "+cValtoChar(nExmp))
while nContEmp <= nExmp
	
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Entrou no For: For nContEmp:= 1 To Len (_axEmp)")
	
	aFiles := Directory( cStartLido + iif(IsSrvUnix(), "/" + "E " + _axEmp[nContEmp][1] + "/" + "F " + _axEmp[nContEmp][2] , "\" + "E " + _axEmp[nContEmp][1] + "\" + "F " + _axEmp[nContEmp][2]) + iif(IsSrvUnix(),"/","\") + "*.xml" )
	
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Passou aFiles")
	aFiles := aSort( aFiles, , , {|x,y| x[1] > y[1]} )
	
	nXml   := 0
	
	Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Qtde de arquivos: "+ alltrim(str(len(aFiles))))
	
	For nX:=1 To Len(aFiles)
		
		Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Qtde de arquivos de: "+ alltrim(str(nX)) +" Até: "+alltrim(str(len(aFiles))))
		
		cStrAtch := Memoread( cStartLido + iif(IsSrvUnix(), "/" + "E " + _axEmp[nContEmp][1] + "/" + "F " + _axEmp[nContEmp][2] , "\" + "E " + _axEmp[nContEmp][1] + "\" + "F " + _axEmp[nContEmp][2]) + iif(IsSrvUnix(),"/","\") + aFiles[nX][1] )
		FreeObj(oXML)
		CREATE oXML XMLSTRING cStrAtch
		
		//QUANDO TIVER 500 XML SAI DA ROTINA, SENAO ESTOURA O ARRAY DO XML
		If nXml == 500
			Loop
		EndIf
		
		//***********************************************************
		// Localiza o Destinatario se é uma das empresas do SIGAMAT
		//***********************************************************
		ixIni := At("<dest><CNPJ>",cStrAtch)
		xCNPJ := AllTrim( Substr(cStrAtch, ixIni+12, 14 ) )
		
		Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Localiza o Destinatario se é uma das empresas do SIGAMAT" )
		
		if _axEmp[nContEmp][4] <> xCNPJ		// Verifica se XML e de uma das empresas cadastradas, senão descarta arquivo
			
			Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " DESCARTOU" )
			
			Ferase(cStartLido + iif(IsSrvUnix(), "/" + "E " + _axEmp[nContEmp][1] + "/" + "F " + _axEmp[nContEmp][2] , "\" + "E " + _axEmp[nContEmp][1] + "\" + "F " + _axEmp[nContEmp][2]) + iif(IsSrvUnix(),"/","\") + aFiles[nX][1])	// Em caso do arquivo ja existir substituir
			Loop
			
		endif
		
		if (cCodEmp + cCodFil) <> (_axEmp[nContEmp][01] + _axEmp[nContEmp][02])
			
			RpcSetType(3)
			
			cCodEmp  := _axEmp[nContEmp][01]
			cCodFil  := _axEmp[nContEmp][02]
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Preparo o ambiente na qual sera executada a rotina de negocio      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Preparo o ambiente na qual sera executada a rotina de negocio" )
			
			RpcClearEnv()
			PREPARE ENVIRONMENT EMPRESA cCodEmp FILIAL cCodFil MODULO "COM"
			
		endif
		
		nXml++
		
		cFirstStart := cStartLido
		cStartLido	:= cStartLido + iif(IsSrvUnix(), "/" + "E " + _axEmp[nContEmp][1] + "/" + "F " + _axEmp[nContEmp][2] , "\" + "E " + _axEmp[nContEmp][1] + "\" + "F " + _axEmp[nContEmp][2])
		
		Conout("(Importacao de XML) Data: "+dtoc(ddatabase)+ " Hora: "+time()+ " Chamado U_ACOMP005" )
		
		U_VITIM005(aFiles[nX,1],.T.)
		
		cStartLido := cFirstStart
		
	Next nX
	
	nContEmp := nContEmp + 1
	
enddo //Next nContEmp

RestArea(aArea)

Return


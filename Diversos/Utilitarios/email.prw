/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ EMail    ³ Autor: André Almeida Alves     ³ Data: 28/01/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para envio de e-mail                                 ±±
±±³  			 Execução via JOB                                            ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "TOTVS.CH"

user Function EMail(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)

local oServer  := Nil
local oMessage := Nil
local nErr     := 0

local cPopAddr   := "10.1.1.34"
local cSMTPAddr  := "10.1.1.34"	 // Endereco do servidor SMTP
local cPOPPort   := 110 // Porta do servidor POP
local cSMTPPort  := 25 // Porta do servidor SMTP
local cUser      := AllTrim(GetMV("MV_WFMAIL")) // Usuario que ira realizar a autenticacao
local cPass      := AllTrim(GETMV("MV_WFPASSW")) // Senha do usuario
local nSMTPTime  := 60 // Timeout SMTP

// Instancia um novo TMailManager
oServer := tMailManager():New()

// Usa SSL na conexao
oServer:setUseSSL(GetMv("MV_RELAUTH",,.F.))

//	 oServer:SetUseTLS(.t.)

// Inicializa
oServer:init(cPopAddr, cSMTPAddr, cUser, cPass, cPOPPort, cSMTPPort)

// Define o Timeout SMTP
if oServer:SetSMTPTimeout(nSMTPTime) != 0
	Alert("[ERROR]Falha ao definir timeout")
	return .F.
endif

// Conecta ao servidor
nErr := oServer:smtpConnect()
if nErr <> 0
	Alert("[ERROR]Falha ao conectar: " + oServer:getErrorString(nErr))
	oServer:smtpDisconnect()
	return .F.
endif

// Realiza autenticacao no servidor
/*
nErr := oServer:smtpAuth(cUser, cPass)
if nErr <> 0
	Alert("[ERROR]Falha ao autenticar: " + oServer:getErrorString(nErr))
	oServer:smtpDisconnect()
	return .F.
endif*/

// Cria uma nova mensagem (TMailMessage)
oMessage 				:= tMailMessage():new()
oMessage:clear()
oMessage:cFrom 		:= cUser
oMessage:cTo 			:= _cpara
oMessage:cCC 			:= _ccc
oMessage:cSubject 	:= _cassunto 
oMessage:cBody 		:= _cmensagem 
oMessage:AttachFile(_canexos)

// Envia a mensagem
nErr := oMessage:send(oServer)
if nErr <> 0
	Alert("[ERROR]Falha ao enviar: " + oServer:getErrorString(nErr))
	oServer:smtpDisconnect()
	return .F.
endif

// Disconecta do Servidor
oServer:smtpDisconnect()

return .T.
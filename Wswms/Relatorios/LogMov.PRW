#include 'rwmake.ch'
#include 'ap5mail.ch'

/*/{Protheus.doc} LogMov
Log de movimentação de saldos

@since 01/12/2017
@version 1.0

@type function
/*/
User Function LogMov()
Local cRelServ := GetMv('MV_RELSERV', .f., "10.1.1.34")   //-- Nome do servidor de envio de e-mail
Local cRelAcnt := SuperGetMv('MV_RELACNT', .f., "relatorios@vitamedic.ind.br")   //-- Conta a ser utilizada no envio de e-mail
Local cRelPsw  := GetMv('MV_RELPSW', .f., "vitaddsql")   //-- Indica qual a senha da conta utilizada para envio de e-mail
Local cRelMails := SuperGetMv('MV_XMVSALD',.F., "report_ti@vitamedic.ind.br") //-- Parametro para emails (Natã 01-12-2017)
Local cErro    := ''
Local cArqLog  := PARAMIXB[1]
Local lOk      := .F.

Local cPath := GetSrvProfString('StartPath','')
If right(cPath,1)$'/\'
    cPath := left(cPath,len(cPath)-1)
Endif                      
If Empty(cRelServ) .or. Empty(cRelAcnt) .or. Empty(cRelPsw)
    Return
EndIf   

If ! File(cPath+'\'+cArqLog) 
    Return
EndIf
    
CONNECT SMTP SERVER cRelServ ACCOUNT cRelAcnt PASSWORD cRelPsw RESULT lOk
If  ! lOk                                 
    conout('Erro de conexao ')                        
    Return
EndIf    

If GetMv("MV_RELAUTH") 
    If ! mailAuth(cRelAcnt,cRelPsw)
        conout('erro de autenticacao')                        
        Return
    EndIf
EndIf

SEND MAIL FROM cRelAcnt ;       
TO cRelMails; // informe os emails que receberão os logs
SUBJECT dtos(date())+" - Protheus - LogMov ERRO - ATENCAO" ;
BODY "ANEXO Log de movimentacao de saldos." ;
ATTACHMENT cPath+'\'+cArqLog ;   //     AUTHENTIC cRelAcnt cRelPsw
RESULT lOk                       
If  !lOk
    GET MAIL ERROR cErro
    conout('Erro de envio: '+cErro)                        
EndIf

DISCONNECT SMTP SERVER RESULT lOk
If  !lOk
    GET MAIL ERROR cErro
    conout('Erro de Desconexao :'+ cErro)                        
EndIf

Return NIL

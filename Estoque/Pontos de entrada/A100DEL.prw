#Include "PROTHEUS.CH"
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MS520VLD � AUTOR � Ricardo Moreira � Data � 14/10/2015     潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de entrada apos a gravacao da nota fiscal de entrada 潮�
北�          � para solicitar a data de recebimento da nota fiscal        潮�
北�          � e preencher tabela CD7 para emissao NFe para Devolu玢o     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/


User Function A100DEL()
Private URET := .T.

	ExEnt() 
	
Return URET

/* ##################################################################
Fun玢o:ValExc()      Data : 14/10/2015
Autor: Ricardo Fiuza's
Uso: Tela de Digita玢o do Motivo da Exclus鉶
#####################################################################*/ 

Static Function ExEnt()
Local lblCodExc
Local lblDesExc
Local oSay1
Local oSButton1
Local oSButton2  
Private cblCodExc  := space(02)
Private cblDescExc := space(30)  
Static oDlg
 
  DEFINE MSDIALOG oDlg TITLE "Motivo de Exclusao Nota de Entrada" FROM 000, 000  TO 170, 500 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME
 
    @ 034, 024 SAY oSay1 PROMPT "Motivo:" SIZE 019, 007 OF oDlg COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 065, 164 TYPE 01 OF oDlg ENABLE ACTION GravEx() 
    DEFINE SBUTTON oSButton2 FROM 065, 205 TYPE 02 OF oDlg ENABLE ACTION CanCe() 
              
    @ 033, 046 MSGET lblCodExc VAR cblCodExc SIZE 020, 010 OF oDlg COLORS 0, 16777215 F3 "XEC" PIXEL valid naovazio()
    @ 033, 081 MSGET lblDesExc VAR cblDescExc SIZE 150, 010 OF oDlg COLORS 0, 16777215 PIXEL  
 
  ACTIVATE MSDIALOG oDlg CENTERED
 
Return

/* ##################################################################
Fun玢o:GravMt()      Data : 14/10/2015
Autor: Ricardo Fiuza's
Uso: Gravar o Codigo do Motivo da Exclusao na Tabela SF2
#####################################################################*/ 

Static Function GravEx()  

   If !empty(cblCodExc)
	 RecLock( "SF1" , .F. )		
	 	SF1->F1_MOTEXCL := cblCodExc
		SF1->F1_DTCANCE := dDatabase
	 	SF1->F1_USERCAN := cUsername
 		SF1->F1_DESCAN  := cblDescExc
	 MsUnLock()	
	 oDlg:End()
   Else
     Msginfo("Nota n鉶 Cancelada, por favor Digitar o Motivo do Cancelamento !!!!")
     URET := .F.
   Endif 
   
Return 
 
/* ##################################################################
Fun玢o:GravMt()      Data : 14/10/2015
Autor: Ricardo Fiuza's
Uso: Gravar o Codigo do Motivo da Exclusao na Tabela SF2
#####################################################################*/ 

Static Function CanCe() 
 
If empty(cblCodExc)
	URET := .F.
	Msginfo("Nota n鉶 Cancelada, por favor Digitar o Motivo do Cancelamento !!!!") 
	oDlg:End()
Else
	URET := .F.	
	Msginfo("Nota n鉶 Cancelada")
	oDlg:End()
EndIf
Return 

#Include "PROTHEUS.CH"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MS520VLD ³ AUTOR ³ Ricardo Moreira ³ Data ³ 14/10/2015     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada apos a gravacao da nota fiscal de entrada ³±±
±±³          ³ para solicitar a data de recebimento da nota fiscal        ³±±
±±³          ³ e preencher tabela CD7 para emissao NFe para Devolução     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


User Function A100DEL()
Private URET := .T.

	ExEnt() 
	
Return URET

/* ##################################################################
Função:ValExc()      Data : 14/10/2015
Autor: Ricardo Fiuza's
Uso: Tela de Digitação do Motivo da Exclusão
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
Função:GravMt()      Data : 14/10/2015
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
     Msginfo("Nota não Cancelada, por favor Digitar o Motivo do Cancelamento !!!!")
     URET := .F.
   Endif 
   
Return 
 
/* ##################################################################
Função:GravMt()      Data : 14/10/2015
Autor: Ricardo Fiuza's
Uso: Gravar o Codigo do Motivo da Exclusao na Tabela SF2
#####################################################################*/ 

Static Function CanCe() 
 
If empty(cblCodExc)
	URET := .F.
	Msginfo("Nota não Cancelada, por favor Digitar o Motivo do Cancelamento !!!!") 
	oDlg:End()
Else
	URET := .F.	
	Msginfo("Nota não Cancelada")
	oDlg:End()
EndIf
Return 

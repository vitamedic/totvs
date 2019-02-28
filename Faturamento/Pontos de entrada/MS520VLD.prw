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


User Function MS520VLD()
Private lValido := .T.

	ValExc()

Return lValido

/* ##################################################################
Função:ValExc()      Data : 14/10/2015
Autor: Ricardo Fiuza's
Uso: Tela de Digitação do Motivo da Exclusão
#####################################################################*/ 

Static Function ValExc()
Local lblCodMot
Local lblDesMot
Local oSay1
Local oSButton1
Local oSButton2  
Private cblCodMot  := space(02)
Private cblDescMot := space(30)  
Static oDlg
 
  DEFINE MSDIALOG oDlg TITLE "Motivo de Exclusao Nota de Saída" FROM 000, 000  TO 170, 500 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME
 
    @ 034, 024 SAY oSay1 PROMPT "Motivo:" SIZE 019, 007 OF oDlg COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 065, 164 TYPE 01 OF oDlg ENABLE ACTION GravMt() 
    DEFINE SBUTTON oSButton2 FROM 065, 205 TYPE 02 OF oDlg ENABLE ACTION Canc() //oDlg:End()//Close()
              
    @ 033, 046 MSGET lblCodMot VAR cblCodMot SIZE 020, 010 OF oDlg COLORS 0, 16777215 F3 "XSC" PIXEL valid naovazio()// .and. VMotExSF2(cblOp)
    @ 033, 081 MSGET lblDesMot VAR cblDescMot SIZE 150, 010 OF oDlg COLORS 0, 16777215 PIXEL  
 
  ACTIVATE MSDIALOG oDlg CENTERED
 
Return

/* ##################################################################
Função:GravMt()      Data : 14/10/2015
Autor: Ricardo Fiuza's
Uso: Gravar o Codigo do Motivo da Exclusao na Tabela SF2
#####################################################################*/ 

Static Function GravMt()  

   If !empty(cblCodMot)
	 RecLock( "SF2" , .F. )		
	 	SF2->F2_MOTEXCL := cblCodMot
	 	SF2->F2_DTCANCE := dDatabase
	 	SF2->F2_USERCAN := cUsername 
	 	SF2->F2_DESCAN  := cblDescMot
	 MsUnLock()	
	 oDlg:End()
   Else
     Msginfo("Nota não Cancelada, por favor Digitar o Motivo do Cancelamento !!!!")
     lValido := .F.
   Endif 
   
Return 
 
/* ##################################################################
Função:GravMt()      Data : 14/10/2015
Autor: Ricardo Fiuza's
Uso: Gravar o Codigo do Motivo da Exclusao na Tabela SF2
#####################################################################*/ 

Static Function Canc() 
 
If empty(cblCodMot)
	lValido := .F.
	Msginfo("Nota não Cancelada, por favor Digitar o Motivo do Cancelamento !!!!")
EndIf
	lValido := .F.	
	Msginfo("Nota não Cancelada")
	oDlg:End()
Return 

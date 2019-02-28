#Include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MS520VLD � AUTOR � Ricardo Moreira � Data � 14/10/2015     ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada apos a gravacao da nota fiscal de entrada ���
���          � para solicitar a data de recebimento da nota fiscal        ���
���          � e preencher tabela CD7 para emissao NFe para Devolu��o     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/


User Function MS520VLD()
Private lValido := .T.

	ValExc()

Return lValido

/* ##################################################################
Fun��o:ValExc()      Data : 14/10/2015
Autor: Ricardo Fiuza's
Uso: Tela de Digita��o do Motivo da Exclus�o
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
 
  DEFINE MSDIALOG oDlg TITLE "Motivo de Exclusao Nota de Sa�da" FROM 000, 000  TO 170, 500 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME
 
    @ 034, 024 SAY oSay1 PROMPT "Motivo:" SIZE 019, 007 OF oDlg COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 065, 164 TYPE 01 OF oDlg ENABLE ACTION GravMt() 
    DEFINE SBUTTON oSButton2 FROM 065, 205 TYPE 02 OF oDlg ENABLE ACTION Canc() //oDlg:End()//Close()
              
    @ 033, 046 MSGET lblCodMot VAR cblCodMot SIZE 020, 010 OF oDlg COLORS 0, 16777215 F3 "XSC" PIXEL valid naovazio()// .and. VMotExSF2(cblOp)
    @ 033, 081 MSGET lblDesMot VAR cblDescMot SIZE 150, 010 OF oDlg COLORS 0, 16777215 PIXEL  
 
  ACTIVATE MSDIALOG oDlg CENTERED
 
Return

/* ##################################################################
Fun��o:GravMt()      Data : 14/10/2015
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
     Msginfo("Nota n�o Cancelada, por favor Digitar o Motivo do Cancelamento !!!!")
     lValido := .F.
   Endif 
   
Return 
 
/* ##################################################################
Fun��o:GravMt()      Data : 14/10/2015
Autor: Ricardo Fiuza's
Uso: Gravar o Codigo do Motivo da Exclusao na Tabela SF2
#####################################################################*/ 

Static Function Canc() 
 
If empty(cblCodMot)
	lValido := .F.
	Msginfo("Nota n�o Cancelada, por favor Digitar o Motivo do Cancelamento !!!!")
EndIf
	lValido := .F.	
	Msginfo("Nota n�o Cancelada")
	oDlg:End()
Return 

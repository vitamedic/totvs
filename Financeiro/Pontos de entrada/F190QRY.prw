#Include "Protheus.ch"
#Include "TopConn.ch"

User Function F190QRY ()
Local cQRY
Local oGet1
Local cGet1 := "          "
Local oGet2
Local cGet2 := "          "
Local oSay1
Local oSay2
Local oButton1
Local par1
Local par2
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Data Disponibilização" FROM 000, 000  TO 150, 300 COLORS 0, 16777215 PIXEL

    @ 007, 007 SAY oSay1 PROMPT "Disponibilização de:" SIZE 055, 006 OF oDlg COLORS 0, 16777215 PIXEL
    @ 006, 077 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg Picture "99/99/9999" COLORS 0, 16777215 PIXEL
    @ 025, 007 SAY oSay2 PROMPT "Disponibilização até:" SIZE 054, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 025, 076 MSGET oGet2 VAR cGet2 SIZE 060, 010 OF oDlg Picture "99/99/9999" COLORS 0, 16777215 PIXEL
    @ 050, 049 BUTTON oButton1 PROMPT "OK" ACTION (oDlg:End()) SIZE 028, 012 OF oDlg PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

par1:= substr(cGet1,7,4)+substr(cGet1,4,2)+substr(cGet1,1,2) 
Par2:= substr(cGet2,7,4)+substr(cGet2,4,2)+substr(cGet2,1,2)  

If !empty(cGet1) .and. !empty(cGet2)
cQry := "E5_DTDISPO  BETWEEN '"+par1+"' AND '"+par2+"'"
Elseif !empty(cGet1) .and. empty(cGet2)
cQry := "E5_DTDISPO >= '"+par1+"'
ElseIf empty(cGet1) .and. !empty(cGet2)
cQry := "E5_DTDISPO <= '"+par2+"'
EndIf
RETURN cQry
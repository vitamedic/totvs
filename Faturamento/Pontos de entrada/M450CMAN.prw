//Valida para não deixar rejeitar o pedido 
//31/10/2016
//Ricardo Moreira // Vitamedic

User Function M450CMAN

Local lRet := .T.

If Paramixb[1] == 3  
    lRet := .F.
	MSGINFO("Desabilitado")
EndIf

Return lRet
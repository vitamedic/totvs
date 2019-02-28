//Vitamedic
//Data: 18/02/2016
//Retorna a Mesangem do VAlor de Juros por dia no CNAB PARA BANCOS
//Autor: Ricardo Moreira  
/*
_cTipo - "J104" = JUROS CAIXA
_cTipo - "J237" = JUROS BRADESCO 
_cTipo - "J212" = JUROS ORIGINAL 
_cTipo - "J756" = JUROS SICOOB 
_cTipo - "J107" = JUROS BBM
*/                                      
/*
User Function VIT445() // U_VIT445()                                                       
Local _vMens

_vMens := "Juros Dia de Atraso R$ "
_vMens += alltrim(Transform(round((SE1->E1_SALDO-SE1->E1_DECRESC)*(SE1->E1_PORCJUR/100),2), "@ze 9,999,999,999,999.99"))

Return _vMens
*/
User Function VIT445(_cTipo) // U_VIT445("J107")

	Local _vMens := "Juros Dia de Atraso R$ "
	If _cTipo == "J104"
		_vMens += alltrim(Transform(round((SE1->E1_SALDO-SE1->E1_DECRESC)*(SE1->E1_PORCJUR/100),2), "@ze 9,999,999,999,999.99")) 
	ElseIf _cTipo == "J237"
		_vMens += alltrim(Transform(round((SE1->E1_SALDO-SE1->E1_DECRESC)*(SE1->E1_PORCJUR/100),2), "@ze 9,999,999,999,999.99")) 
	ElseIf _cTipo == "J212"
		_vMens += alltrim(Transform(round((SE1->E1_SALDO-SE1->E1_DECRESC)*(SE1->E1_PORCJUR/100),2), "@ze 9,999,999,999,999.99"))
	ElseIf _cTipo == "J756"
		_vMens += alltrim(Transform(round((SE1->E1_SALDO-SE1->E1_DECRESC)*(SE1->E1_PORCJUR/100),2), "@ze 9,999,999,999,999.99"))
	ElseIf _cTipo == "J107"
		_vMens += alltrim(Transform(round((SE1->E1_SALDO-SE1->E1_DECRESC)*(SE1->E1_PORCJUR/100),2), "@ze 9,999,999,999,999.99"))

	EndIf

Return (_vMens)

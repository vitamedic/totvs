//Vitamedic
//Data: 18/02/2016
//Retorna o VAlor de Juros por dia no CNAB 
//Autor: Ricardo Moreira  

/*
_cTipo - "J104" = JUROS CAIXA
_cTipo - "J237" = JUROS BRADESCO 
_cTipo - "J212" = JUROS ORIGINAL 
_cTipo - "J756" = JUROS SICOOB 
_cTipo - "J107" = JUROS BBM
*/                                      

User Function VIT444(_cTipo) //U_VIT444("J104")                                                      
	Local _vJur

	If _cTipo == "J104"
		_vJur :=STRZERO((ROUND((SE1->E1_SALDO-SE1->E1_DECRESC)*(SE1->E1_PORCJUR/100),2)*100),13) 
	ElseIf _cTipo == "J237"
		_vJur :=STRZERO((ROUND((SE1->E1_SALDO-SE1->E1_DECRESC)*(SE1->E1_PORCJUR/100),2)*100),13) 
	ElseIf _cTipo == "J212"
		_vJur :=STRZERO((ROUND((SE1->E1_SALDO-SE1->E1_DECRESC)*(SE1->E1_PORCJUR/100),2)*100),13)
	ElseIf _cTipo == "J756"
		_vJur :=STRZERO((ROUND((SE1->E1_SALDO-SE1->E1_DECRESC)*(SE1->E1_PORCJUR/100),2)*100),13)
	ElseIf _cTipo == "J107"
		_vJur :=STRZERO((ROUND((SE1->E1_SALDO-SE1->E1_DECRESC)*(SE1->E1_PORCJUR/100),2)*100),13)
	EndIf

Return (_vJur) 
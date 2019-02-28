//Valida a digitação de contas no SOPAG
User Function VALCT1SP //U_VALCT1SP()  

/* modelo

for i:=1 to FCount()
	if upper(fieldname(i))=='D3_QUANT'
	qdtmod:=fieldget(i)
	endif
next
*/

Local  _lRet := .T.  

If !ExistCpo("CT1",M->Z42_DEBITO)
 MsgInfo("Não existe conta desejada")
 _lRet := .F.
EndIF

IF CT1->CT1_BLOQ <> "2"  
  MsgInfo("Conta Bloqueada")  
  _lRet := .F.                
EndIF

If LEN(ALLTRIM(CT1->CT1_CONTA)) <> 13                              
   MsgInfo("Conta diferente de 13 digitos")
  _lRet := .F.
EndIf
Return  _lRet 


//Valida a digitação de centro de custos no SOPAG       

User Function VALCTTSP //U_VALCTTSP()

Local  _lRet := .T.  

If !ExistCpo("CTT",M->Z42_CCUSTO)
 MsgInfo("Não existe Centro de Custo desejado")
 _lRet := .F.
EndIF

IF CTT->CTT_BLOQ <> "2"  
  MsgInfo("Centro de Custo Bloqueado")  
  _lRet := .F.                
EndIF

If LEN(ALLTRIM(CTT->CTT_CUSTO)) <> 8                              
   MsgInfo("Centro de Custo diferente de 8 digitos")
  _lRet := .F.
EndIf
Return  _lRet  



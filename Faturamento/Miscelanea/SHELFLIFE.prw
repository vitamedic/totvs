#INCLUDE "PROTHEUS.CH"  

//--------------------------------------------------------------
/*/{Protheus.doc}  SHELFLIFE
Rotina SHELFLIFE
Verificação do Shelf Life de clientes

@author Danilo Brito
@since 12/05/2017
@version P11
@param Nao recebe parametros
@return Nil(nulo)
@history
/*/
//------------------------------------------------------------  
User Function SHELFLIFE(cProduto, cLote, cCliente, cLoja, dDtAtu)

	Local aArea := GetArea()
	Local aAreaSA1 := SA1->(GetArea())
	Local aAreaSB1 := SB1->(GetArea())
	Local lRet := .T.
	Local nDiasMin := 0
	Local nDiasVenc := 0
	Default dDtAtu := dDatabase
	
	if !empty(cLote)
		SA1->(DbSetOrder(1))
		if SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja))
			
			if !empty(SA1->A1_XSHELIF)
				
				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial("SB1")+cProduto))
				
				SB8->(DbSetOrder(3)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
				if SB8->(DbSeek(xFilial("SB8")+SC9->C9_PRODUTO+SC9->C9_LOCAL+Alltrim(cLote)))
					                                                                                           
					//arredonda sempre pra cima
					nDiasMin := Ceiling((DateDiffDay(SB8->B8_DFABRIC,SB8->B8_DTVALID) * SA1->A1_XSHELIF / 100 )) 
					nDiasVenc := SB8->B8_DTVALID - dDtAtu
					
					if nDiasVenc < nDiasMin
						lRet := .F.
					endif
					
				endif
				
			endif
			
		endif
	endif
	
	RestArea(aAreaSB1)
	RestArea(aAreaSA1)
	RestArea(aArea)
	
Return lRet
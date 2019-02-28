#INCLUDE "PROTHEUS.CH" 
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"  

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ TBTNPDV     ¦ Autor ¦ Totvs            ¦ Data ¦ 05/11/2013 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Classe genérica que monta botão com imagem com foco e ação.¦¦¦
¦¦¦          ¦ 			                                                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TOTVS - GO		                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
CLASS TBTNPDV

	DATA oImg //objeto REPOSITORY
	DATA oLink //objeto THButton
	DATA bAction

	//Método Construtor da Classe
	METHOD New(nRow, nCol, nWidth, nHeight, oWnd, cBmp, bAction, cToolTip, bWhen) CONSTRUCTOR 
	METHOD SetFocus() 
	METHOD LoadBmp(cBmp) 
	METHOD Hide()
	METHOD Show()
	METHOD bLeft(nLeft)
	METHOD bRight(nRight)
   
ENDCLASS

//---------------------------------------------------------------
// Método Construtor da Classe. 
//---------------------------------------------------------------
METHOD New(nRow, nCol, nWidth, nHeight, oWnd, cBmp, bAction, cToolTip, bWhen) CLASS TBTNPDV
	
	//@ nRow, nCol REPOSITORY ::oImg SIZE nWidth, nHeight OF oWnd PIXEL NOBORDER
	//::oImg:LoadBmp(cBmp)
	@ nRow, nCol BITMAP ::oImg ResName cBmp SIZE nWidth, nHeight OF oWnd PIXEL NOBORDER
	
	::bAction := bAction
	
	if bAction <> Nil
 		::oLink := THButton():New(nRow + 1, nCol + 1, "", oWnd, bAction, nWidth - 2, nHeight - 2,,cToolTip, bWhen)
	endif
	
Return Self   	            

METHOD SetFocus() CLASS TBTNPDV
Return iif(::bAction<>Nil, ::oLink:SetFocus(), Nil)

METHOD LoadBmp(cBmp) CLASS TBTNPDV
//::oImg:LoadBmp(cBmp)
	::oImg:SetBmp(cBmp)
	::oImg:Refresh()
Return 
                               
METHOD Hide() CLASS TBTNPDV
	::oImg:Hide()
	if ::bAction <> Nil
		::oLink:Hide()
	endif
Return 

METHOD Show() CLASS TBTNPDV
	::oImg:Show()
	if ::bAction <> Nil
		::oLink:Show()
	endif
Return   

METHOD bLeft(nLeft) CLASS TBTNPDV 

	::oImg:nLeft 	:= nLeft 
	::oLink:nLeft 	:= nLeft  
	
Return     

METHOD bRight(nRight) CLASS TBTNPDV 

	::oImg:nRight 	:= nRight 
	::oLink:nRight 	:= nRight  
	
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author redes

@since 29/05/2018
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

oView := FWFormView():New()

oView:SetModel(oModel)

Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author redes

@since 29/05/2018
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

oModel := MPFormModel():New('ModelName')

Return oModel
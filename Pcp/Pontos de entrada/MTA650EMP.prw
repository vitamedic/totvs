#INCLUDE "TOPCONN.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MTA650EMP
	PE - Valida a OP para a exclusão
@author Microsiga
@since 16/04/2017 
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MTA650EMP()
Local lOk := .t.

DbSelectArea('U00')
DbSetOrder(1)
If ( lOk := ( DbSeek(xFilial('U00')+U00->U00_COD+U00->U00_OP+U00->U00_TRT) .and. RecLock('U00',.F.) ) )
	U00->(dbDelete())
	U00->(MsUnLock())
EndIf

If lOk
	dbSelectArea("U01")
	dbSetOrder(1)
	If dbSeek(XFilial("U01")+U00->U00_COD+U00->U00_LOCAL+U00->U00_TRT)
		Do While U01->(!Eof()) .and. U01->U01_FILIAL = XFilial("U01") .and. U01->U01_PRODUT = U00->U00_COD .and. U01->U01_LOCAL = U00->U00_LOCAL .and. U01->U01_TRT = U00->U00_TRT
			If U01->( RecLock("U01", .f. ) )
				U01->( dbDelete() )
				U01->( MsUnLock() )
			EndIf
		
		    U01->(dbSkip())
		EndDo
	EndIf	
EndIf

Return NIL
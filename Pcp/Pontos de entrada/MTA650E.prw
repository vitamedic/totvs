#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MTA650E
	Valida a OP para a exclusão
@author Microsiga
@since 29/03/2017
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MTA650E()

	Local cNum  		:= Pad(SC2->C2_NUM, TamSx3("C2_NUM")[1]) + Pad(SC2->C2_ITEM, TamSx3("C2_ITEM")[1]) + Pad(SC2->C2_SEQUEN, TamSx3("C2_SEQUEN")[1])
	Local lOk   		:= .t.
	Local MV_XPRDFAN    := SuperGetMV("MV_XPRDFAN", .f., "") //Integracao WMS, produtos que nao serao reportados no Empenho
	Local aArZ50        := Z50->(GetArea())
	Local aArSD4        := SD4->(GetArea())

	DbSelectArea('Z50')
	DbSetOrder(2)
	If DbSeek(xFilial('Z50')+cNum)
		DbSelectArea('SD4')
		DbSetOrder(2)
		If DbSeek(xFilial('SD4')+cNum)
			Do While SD4->(!Eof() .and. D4_FILIAL = xFilial('SD4') .and. D4_OP = cNum)
				if !empty(MV_XPRDFAN) .and. ( alltrim(SD4->D4_COD) $ MV_XPRDFAN )
					SD4->(dbSkip())
					loop
				endif

				msgStop("Operação não permitida, Ordem de Produção com empenho parcial.", "A t e n ç ã o")
				lOk := .f.
				Exit
			EndDo
		EndIf
	EndIf

	RestArea(aArZ50)
	RestArea(aArSD4)

Return lOk

#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MTA650AE
	PE - Executado na exclusão da OP
@author Microsiga
@since 29/03/2017
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MTA650AE()

	Local cNum  	:= PARAMIXB[1]
	Local cItem 	:= PARAMIXB[2]
	Local cSeq  	:= PARAMIXB[3]
	Local lOk   	:= .f.
	Local aAreaSB2  := SB2->(GetArea())
	Local cMsgErr 	:= ""
	Local cMsgAgu	:= "Aguarde... atualizando empenhos WMS..."

	DbSelectArea('Z50')
	DbSetOrder(2) //Z50_FILIAL+Z50_OP+Z50_COD+Z50_TRT
	If DbSeek(xFilial('Z50')+cNum)
		Do While Z50->(!Eof()) .and. Z50->Z50_FILIAL = xFilial('Z50') .and. Z50->Z50_OP = cNum
			if RecLock('Z50',.F.)
				Z50->(dbDelete())
				Z50->(MsUnLock())
			endif

			Z50->(dbSkip())
		enddo
	endif

	DbSelectArea('Z51')
	DbSetOrder(2)
	SB2->(dbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
	If DbSeek(xFilial('Z51')+cNum)
		Do While Z51->(!Eof()) .and. Z51->Z51_FILIAL = xFilial('Z51') .and. Z51->Z51_OP = cNum
			If Z51->Z51_QTD > 0 // Se houver saldos limpar na SB2
				If SB2->(dbSeek(xFilial("Z51")+Z51->Z51_PRODUT+Z51->Z51_LOCAL))
					SB2->(RecLock("SB2", .F.))
					If SB2->B2_XEMPWMS >= Z51->Z51_QTD // Não permite saldo negativo
						SB2->B2_XEMPWMS -= Z51->Z51_QTD
					Else
						SB2->B2_XEMPWMS := 0
					EndIf
					SB2->(MsUnLock())
				EndIf
			EndIf
			if RecLock('Z51',.F.)
				Z51->(dbDelete())
				Z51->(MsUnLock())
			endif
			Z51->(dbSkip())
		enddo
	endif

	//atualizo empenhos WMS da SB2, SB8 e SBF
//	LjMsgRun(cMsgAgu,"Saldos WMS",{|| lOk := U_ProcEmpenhoWMS(,,,.t., @cMsgErr) })

//	if !lOk
//		MsgAlert(cMsgErr)
//	endif
	
	RestArea(aAreaSB2)

Return NIL
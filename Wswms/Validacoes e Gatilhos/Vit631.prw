/*/{Protheus.doc} Vit631
	Validação no cadastro de Endereços.
@author xxx
@since nda
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function Vit631()
Local lRet 		:= .t.
Local _Localiz 	:= &(ReadVar())
Local cArmCQ 	:= GetMV("MV_CQ")
Local aArSBE    := SBE->(GetArea())

dbSetOrder(9)
if dbSeek(XFilial("SBE")+_Localiz)
	do while SBE->( !Eof() .and. AllTrim(BE_LOCALIZ) == AllTrim(_Localiz) )
		if SBE->BE_LOCAL <> cArmCQ
        	lRet := .f.
			msgStop("Endereço já cadastrado no armazén (" + SBE->BE_LOCAL + ")", "A t e n ç ã o")
			exit
		endif
		SBE->(dbSkip())
	enddo
endif           

RestArea(aArSBE)
Return(lRet)
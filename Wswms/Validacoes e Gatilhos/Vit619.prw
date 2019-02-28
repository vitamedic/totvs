#Include "Protheus.Ch"
#Include "TopConn.Ch"


/*/{Protheus.doc} Vit619
Valida no Documento de Entrada produto x fornecedor
@author Marcos Natã Santos
@since 03/10/2017
@version 1.0
@return ${return}, ${return_description}
@param _Campo, , descricao
@param _Conteudo, , descricao
@type function
/*/
User Function Vit619(_Campo, _Conteudo)
	Local _aSA2   		:= SA2->(GetArea())
	Local _Prod   		:= aCols[n][AScan(aHeader, {|x| alltrim(x[2]) == 'D1_COD'})]
	Local _NumPC 		:= aCols[n][AScan(aHeader, {|x| alltrim(x[2]) == 'D1_PEDIDO'})]
	Local _ItemPC 		:= aCols[n][AScan(aHeader, {|x| alltrim(x[2]) == 'D1_ITEMPC'})]
	Local _TES 			:= aCols[n][AScan(aHeader, {|x| alltrim(x[2]) == 'D1_TES'})]
	Local _Tiponf	//	:= aCols[n][AScan(aHeader, {|x| alltrim(x[2]) == 'D1_TIPO'})]
	Local MV_XVALCER 	:= SuperGetMV("MV_XVALCER", .f., "N")
	Local pUsuario      := Embaralha(SD1->D1_USERLGI,1)
	Local MV_XTESDEV 	:= GetMV("MV_XTESDEV")

	Default _Campo  	:= Upper(AllTrim(ReadVar()))
	Default _Conteudo  	:= &(_Campo)

	If MV_XVALCER == "N" .or. !(SB1->B1_TIPO $ "/EE/EN/MP/PA/SL/EM/PN/IS/ES/PD/ED/ID/") .Or. _TES $ MV_XTESDEV
		Return( .t. )
	EndIf

	DbSelectArea("SA5")
	DbSetOrder(1)
	If !dbSeek(xFilial("SA5")+CA100FOR+CLOJA+_Prod)  //A5
		msgStop("Fornecedor sem Amarração com o Produto, Entre em contato com a Garantia da Qualidade !!! ")
		Return(.f.)
	Else
		If MV_XVALCER == "S"
			_Validade := .f.
			If empty(SA5->A5_XCERT1) .or. empty(SA5->A5_VALFORN)
				msgStop("Informe o certificado ou a data de validade do fornecedor!!!")
			ElseIf SA5->A5_VALFORN < dDatabase
				msgStop("Validade do 1o. certificado do fornecedor está vencida!!!")
			ElseIf !empty(SA5->A5_XCERT2) .and. SA5->A5_XDTCER2 < dDatabase
				msgStop("Validade do 2o. certificado do fornecedor está vencida!!!")
			ElseIf !empty(SA5->A5_XCERT3) .and. SA5->A5_XDTCER3 < dDatabase
				msgStop("Validade do 3o. certificado do fornecedor está vencida!!!")
			ElseIf !empty(SA5->A5_XCERT4) .and. SA5->A5_XDTCER4 < dDatabase
				msgStop("Validade do 4o. certificado do fornecedor está vencida!!!")
			ElseIf !empty(SA5->A5_XCERT5) .and. SA5->A5_XDTCER5 < dDatabase
				msgStop("Validade do 5o. certificado do fornecedor está vencida!!!")
			ElseIf !empty(SA5->A5_XCERT6) .and. SA5->A5_XDTCER6 < dDatabase
				msgStop("Validade do 6o. certificado do fornecedor está vencida!!!")
			ElseIf !empty(SA5->A5_XCERT7) .and. SA5->A5_XDTCER7 < dDatabase
				msgStop("Validade do 7o. certificado do fornecedor está vencida!!!")
			ElseIf !empty(SA5->A5_XCERT8) .and. SA5->A5_XDTCER8 < dDatabase
				msgStop("Validade do 8o. certificado do fornecedor está vencida!!!")
			ElseIf !empty(SA5->A5_XCERT9) .and. SA5->A5_XDTCER9 < dDatabase
				msgStop("Validade do 9o. certificado do fornecedor está vencida!!!")
			ElseIf !empty(SA5->A5_XCERTA) .and. SA5->A5_XDTCERA < dDatabase
				msgStop("Validade do 10o. certificado do fornecedor está vencida!!!")
			ElseIf !empty(SA5->A5_XCERTB) .and. SA5->A5_XDTCERB < dDatabase
				msgStop("Validade do 11o. certificado do fornecedor está vencida!!!")
			Else
				_Validade := .t.
			EndIf

			if ! _Validade
				SA5->(reclock("SA5",.F.))
				SA5->A5_SITU:="E"
				SA5->(msunlock())
				Return(.f.)
			EndIf

			dbSelectArea("SC7")
			SC7->(dbSetOrder(1))
			//C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
			//Stephen Noel - 31/10/2018 - A pedido da Raquel notas do tipo I - ICMS, C- Preço e P - IPI , nao solicitar Pedido.
//			Alert(M->F1_TIPO)
//			If !(M->F1_TIPO $ "CIP")   
				if !dbSeek(xFilial("SC7")+_NumPC+_ItemPC)
					msgStop("Pedido de compra não localizado!!!")
					Return(.f.)
				endif
//			EndIf
			dbSelectArea("SA2")
			dbSetOrder(1)
			if !dbSeek(XFilial("SA2")+CA100FOR+CLOJA)
				msgStop("Fornecedor não localizado!!!")
				Return(.f.)
			endif

			If "D1_XTRANSP" $ _Campo
				If empty(_Conteudo)
					msgStop("Informe a transportadora!!!")
					Return(.f.)
				EndIf

//				If Alltrim(SC7->C7_XTRANSP) <> Alltrim(_Conteudo)
//					msgStop("Transportadora diferente da informada no Pedido de Compras!!!")
//					Return(.f.)
//				EndIf

				dbSelectArea("SA4")
				dbSetOrder(1)
				If !dbSeek(XFilial("SA4")+_Conteudo)
					msgStop("Transportadora não cadastrada!!!")
					Return(.f.)
				ElseIf ! SB1->B1_TIPO $ SA4->A4_XTPPRDS
					msgStop("Para esse tipo de produto não é necessário informar um Transportador Certificado!!!")
					Return(.f.)
				ElseIf empty(SA4->A4_XCERT1)
					msgStop("Informe o 1o. certificado no cadastro da Transportadora!!!")
					Return(.f.)
				ElseIf SA4->A4_XDTCER1 < dDataBase
					msgStop("1o. Certificado da Transportadora está vencido!!!")
					Return(.f.)
				ElseIf !empty(SA4->A4_XCERT2) .and. SA4->A4_XDTCER2 < dDataBase
					msgStop("2o. Certificado da Transportadora está vencido!!!")
					Return(.f.)
				ElseIf !empty(SA4->A4_XCERT3) .and. SA4->A4_XDTCER3 < dDataBase
					msgStop("3o. Certificado da Transportadora está vencido!!!")
					Return(.f.)
				ElseIf !empty(SA4->A4_XCERT4) .and. SA4->A4_XDTCER4 < dDataBase
					msgStop("4o. Certificado da Transportadora está vencido!!!")
					Return(.f.)
				ElseIf !empty(SA4->A4_XCERT5) .and. SA4->A4_XDTCER5 < dDataBase
					msgStop("5o. Certificado da Transportadora está vencido!!!")
					Return(.f.)
				ElseIf !empty(SA4->A4_XCERT6) .and. SA4->A4_XDTCER6 < dDataBase
					msgStop("6o. Certificado da Transportadora está vencido!!!")
					Return(.f.)
				ElseIf !empty(SA4->A4_XCERT7) .and. SA4->A4_XDTCER7 < dDataBase
					msgStop("7o. Certificado da Transportadora está vencido!!!")
					Return(.f.)
				ElseIf !empty(SA4->A4_XCERT8) .and. SA4->A4_XDTCER8 < dDataBase
					msgStop("8o. Certificado da Transportadora está vencido!!!")
					Return(.f.)
				EndIf
			EndIf

			If "D1_XFABRIC" $ _Campo .and. SA2->A2_XMILITA <> "S"
				If SB1->B1_TIPO $ "/EE/EN/MP/PA/SL/EM/PN/IS/ES/PD/ED/ID/" .and. empty(_Conteudo)
					msgStop("Para esse tipo de produto é obrigatório informar um Fabricante Certificado!!!")
					Return(.f.)
				EndIf

				If empty(alltrim(SA5->A5_XFAB1))
					msgStop("Informe o fabricante no cadastro de ProdutosxFornecedores!!!")
					Return(.f.)

//				ElseIf Alltrim(SC7->C7_XFABRIC) <> Alltrim(_Conteudo)
//					msgStop("Fabricante diferente do informado no Pedido de Compras!!!")
//					Return(.f.)

				ElseIf _Conteudo <> SA5->A5_XFAB1 .and. ;
				_Conteudo <> SA5->A5_XFAB2 .and. ;
				_Conteudo <> SA5->A5_XFAB3 .and. ;
				_Conteudo <> SA5->A5_XFAB4 .and. ;
				_Conteudo <> SA5->A5_XFAB5

//					msgStop("Fabricante não relacionado no cadastro de ProdutosxFornecedores!!!")
//					Return(.f.)
				EndIf

				dbSelectArea("Z55")
				dbSetOrder(1)
				If !dbSeek(XFilial("Z55")+_Conteudo)
					msgStop("Fabricante não cadastrado!!!")
					Return(.f.)
				ElseIf Z55->Z55_BLQ == "S"
					msgStop("Cadastro do Fabricante bloqueado!!!")
					Return(.f.)
				ElseIf empty(Z55->Z55_CERT1)
					msgStop("Informe o 1o. certificado no cadastro do Fabricante!!!")
					Return(.f.)
				ElseIf Z55->Z55_DTCER1 < dDataBase
					msgStop("1o. Certificado do Fabricante está vencido!!!")
					Return(.f.)
				ElseIf !empty(Z55->Z55_CERT2) .and. Z55->Z55_DTCER2 < dDataBase
					msgStop("2o. Certificado do Fabricante está vencido!!!")
					Return(.f.)
				ElseIf !empty(Z55->Z55_CERT3) .and. Z55->Z55_DTCER3 < dDataBase
					msgStop("3o. Certificado do Fabricante está vencido!!!")
					Return(.f.)
				ElseIf !empty(Z55->Z55_CERT4) .and. Z55->Z55_DTCER4 < dDataBase
					msgStop("4o. Certificado do Fabricante está vencido!!!")
					Return(.f.)
				ElseIf !empty(Z55->Z55_CERT5) .and. Z55->Z55_DTCER5 < dDataBase
					msgStop("5o. Certificado do Fabricante está vencido!!!")
					Return(.f.)
				ElseIf !empty(Z55->Z55_CERT6) .and. Z55->Z55_DTCER6 < dDataBase
					msgStop("6o. Certificado do Fabricante está vencido!!!")
					Return(.f.)
				ElseIf !empty(Z55->Z55_CERT7) .and. Z55->Z55_DTCER7 < dDataBase
					msgStop("7o. Certificado do Fabricante está vencido!!!")
					Return(.f.)
				ElseIf !empty(Z55->Z55_CERT8) .and. Z55->Z55_DTCER8 < dDataBase
					msgStop("8o. Certificado do Fabricante está vencido!!!")
					Return(.f.)
				EndIf
			EndIf
		EndIf

		If SA5->A5_SITU <> "C" .OR. SA5->A5_VALFORN < DDATABASE //C-Pre qualificado
			If SB1->B1_TIPO $ "/EE/EN/MP/PA/SL/EM/PN/IS/ES/PD/ED/ID/"
				msgStop("Fornecedor NÃ£o Qualificado, Entre em contato com a Garantia da Qualidade !!!! ")
				SA5->(reclock("SA5",.F.))
				SA5->A5_SITU:="E"
				SA5->(msunlock())
				Return(.f.)
			EndIf
		EndIF
	EndIf

	RestArea(_aSA2)

Return( .t. )
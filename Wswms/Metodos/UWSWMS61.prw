#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UWSWMS61 ºAutor  ³Microsiga           º Data ³  19/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Metodo WS processamento do Status da Ordem de Separação  	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UWSWMS61(oDados, oRet)

	Local lOk 		:= .T.
	Local cMsgErr 	:= ""

	Local cPEDIDO    := ""
	Local cNUM_OS    := ""
	Local cStatusOS  := ""

	oRet:SITUACAO := .t.
	oRet:MENSAGEM := ""

	if empty(oDados:cEmpresa)
		oDados:cEmpresa := "01"
		oDados:cParFil  := "01"
	endif

	//se não foi configurado WS para ja vir logado na empresa e filial, faço criação do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U'
		RpcSetType(3)
		lConect := RpcSetEnv(Fil_TpProd:cEmpresa, Fil_TpProd:cFilial)
		if !lConect
			cMsgErr := "Não foi possível conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif

	if lOk .AND. empty(oDados:STATUS_OS)
		cMsgErr := "Informe o status da ordem de separação desejada." + CRLF + "(C)-Cancelada, (S)-Selecionada ou (F)-Finalizada"
		lOk := .F.

	elseif lOk .AND. !(oDados:STATUS_OS $ ";C;S;F;")
		cMsgErr := "Informe o status da ordem de separação correto." + CRLF + "(C)-Cancelada, (S)-Selecionada ou (F)-Finalizada"
		lOk := .F.
	else
		cStatusOS  := oDados:STATUS_OS
	endif

	if lOk .AND. empty(oDados:NUM_OS)
		cMsgErr := "Ordem de separação não informada."
		lOk := .F.

	elseif empty( cPEDIDO := Posicione("Z52", 2, XFilial("Z52")+Pad(oDados:NUM_OS, TamSX3("Z52_PEDIDO")[1]+TamSX3("Z52_NUMOS")[1]), "Z52_PEDIDO") )
		cMsgErr := "Pedido de venda não localizado."
		lOk := .F.

	elseif empty(cNUM_OS := Z52->Z52_NUMOS)
		cMsgErr := "Ordem de separação não localizada."
		lOk := .F.

	endif

	//se tudo ok, atualiza o status do item
	if lOK
		BeginTran()

		dbSelectArea("Z52")
		Z52->(dbSetOrder(2)) //Z52_FILIAL+Z52_PEDIDO+Z52_ITEM+Z52_SEQ+Z52_COD
		if Z52->(dbSeek(XFilial("Z52")+cPEDIDO+cNUM_OS))

			//validaçoes de segurança para ver pedido
			if cStatusOS == "F"
				//³Posiciona Registros para liberar o pedido                               ³
				dbSelectArea("SC6")
				dbSetOrder(1)
				if !MsSeek(xFilial("SC6")+Z52->Z52_PEDIDO+Z52->Z52_ITEM+Z52->Z52_COD)
					cMsgErr := "Item "+Z52->Z52_ITEM+" do Pedido "+Z52->Z52_PEDIDO+" não localizado."
					lOk 	:= .F.
				else
					dbSelectArea("SC5")
					dbSetOrder(1)
					if ! MsSeek(xFilial("SC5")+Z52->Z52_PEDIDO)
						cMsgErr := "Pedido "+Z52->Z52_PEDIDO+" não localizado."
						lOk 	:= .F.
					endif
				endif
			endif

			if lOk
				dbSelectArea("Z52")
				While Z52->( Z52_FILIAL = XFilial("Z52") .and. Z52_PEDIDO = cPEDIDO .and. Z52_NUMOS = cNUM_OS )

					if !RecLock("Z52", .f.)
						cMsgErr := "Problema ao tentar bloquear o registro (Z52)."
						lOk := .f.
						exit
					else

						SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
						if SC9->(DbSeek(xFilial("SC9")+Z52->Z52_PEDIDO+Z52->Z52_ITEM+Z52->Z52_SEQ))

							if !SC9->(RecLock("SC9",.F.))
								cMsgErr := "Problema ao tentar bloquear o registro (SC9)."
								lOk 	:= .f.
								exit //sai do laço SC9
							else
								if cStatusOS == "F" //se finalizado
									SC9->C9_XSTATUS := '1' //apto a faturar
								else
									SC9->C9_XSTATUS := ' ' //limpo pra nao deixar faturar
								endif
								SC9->(MsUnlock())
							endif

						else
							cMsgErr := "Item "+Z52->Z52_ITEM+" do Pedido "+Z52->Z52_PEDIDO+" não localizado na SC9."
							lOk := .f.
							exit
						endif

						if cStatusOS == "F" //se finalizado
							Z52->Z52_STATUS := "3" //separado
						elseif cStatusOS == "C" //se cancelado
							Z52->Z52_STATUS := "1" //volto para apto a separar
						else
							Z52->Z52_STATUS := "2" //em separaçao
						endif

						Z52->( MsUnLock() )
					endif

					Z52->(dbSkip())
				enddo
			endif

		else
			cMsgErr := "Ordem de Separação não localizada."
			lOk := .F.
		endif

		if !lOk
			DisarmTransaction()
		else
			EndTran()
			cMsgErr := "Status atualizado com sucesso!."
		endif

	endif

	oRet:SITUACAO := lOK
	oRet:MENSAGEM := cMsgErr

Return(.t.)
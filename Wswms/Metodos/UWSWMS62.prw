#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UWSWMS62 ºAutor  ³Microsiga           º Data ³  24/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Metodo WS para apontar o processo de pesagem da OP          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UWSWMS62(oDados, oRet)

	Local lOk 		:= .T.
	Local lExiste 	:= .F.
	Local cMsgErr 	:= ""
	Local cOperacao := "01"
	Local cHorI 	:= ""
	Local cHorF 	:= ""
	Local dDatI 	:= CtoD("//")
	Local dDatF 	:= CtoD("//")
	Local aPeriodo 	:= {}
	Local aVetor	:= {}

	Private	lMsErroAuto := .F.

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

	if empty(oDados:DT_INI)
		cMsgErr := "Data de inicio não informada!"
		lOk := .F.
	elseif empty(oDados:HR_INI)
		cMsgErr := "Hora de inicio não informada!"
		lOk := .F.
	elseif empty(oDados:DT_FIM)
		cMsgErr := "Data final não informada!"
		lOk := .F.
	elseif empty(oDados:HR_FIM)
		cMsgErr := "Hora final não informada!"
		lOk := .F.
	endif

	cHorI := Left(oDados:HR_INI,2) + ":" + Right(oDados:HR_INI,2) + ":00"
	cHorF := Left(oDados:HR_FIM,2) + ":" + Right(oDados:HR_FIM,2) + ":00"
	dDatI := StoD(oDados:DT_INI)
	dDatF := StoD(oDados:DT_FIM)
	aPeriodo := U_UPeriodo(cHorI,cHorF,dDatI,dDatF)

	if val(left(aPeriodo[1],2)) > 23
		dDatI := dDatF
		cHorI := "00:00"
		cHorF := "23:59"
	elseif dDatI <> dDatF
		dDatI := dDatF
		cHorI := "00:00"
		cHorF := Left(aPeriodo[5],5)
	else
		cHorI := Left(cHorI,5)
		cHorF := Left(cHorF,5)
	endif

	if lOK .and. empty(Posicione("SC2",1,XFilial("SC2")+oDados:NUM_OP, "C2_NUM"))
		cMsgErr := "Order de produção não encontrada!"
		lOk := .F.
	endif

	//se tudo ok, faz execautos
	if lOK

		BEGIN TRANSACTION

			cQry :=        " SELECT SC2.* "
			cQry += CRLF + "      , SG2.G2_RECURSO "
			cQry += CRLF + "      , SG2.G2_LOTEPAD "
			cQry += CRLF + "      , SC2.R_E_C_N_O_ RECSC2 "
			cQry += CRLF + " FROM "+RetSqlName("SC2")+" SC2  "
			cQry += CRLF + " INNER JOIN "+RetSqlName("SG2")+" SG2 ON (SG2.G2_FILIAL      = '"+XFilial("SG1")+"' "
			cQry += CRLF + "                           AND SG2.G2_PRODUTO = SC2.C2_PRODUTO "
			cQry += CRLF + "                           AND SG2.G2_CODIGO  = SC2.C2_ROTEIRO "
			cQry += CRLF + "                           AND SG2.G2_OPERAC  = '"+cOperacao+"' "
			cQry += CRLF + "                           AND SG2.D_E_L_E_T_ = ' '  "
			cQry += CRLF + "                          ) "
			cQry += CRLF + " WHERE SC2.C2_FILIAL  = '"+XFilial("SC2")+"'  "
			cQry += CRLF + "   AND ( SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN )= '"+oDados:NUM_OP+"' "
			cQry += CRLF + "   AND SC2.D_E_L_E_T_ = ' '  "

			cQry := ChangeQuery(cQry)

			If Select("QRYWS62") > 0
				QRYWS62->(DbCloseArea())
			EndIf

			TcQuery cQry New Alias "QRYWS62" // Cria uma nova area com o resultado do query

			QRYWS62->(dbGoTop())

			if QRYWS62->(Eof())
				lOK := .f.
				cMsgErr := "Não tem ordens de produção..."
			else
				aVetor := { {"H6_OP"		, oDados:NUM_OP  							, NIL},;
				{"H6_PRODUTO" 	, QRYWS62->C2_PRODUTO						, NIL},;
				{"H6_OPERAC" 	, cOperacao     							, NIL},;
				{"H6_RECURSO" 	, QRYWS62->G2_RECURSO						, NIL},;
				{"H6_DTAPONT"  	, dDataBase									, NIL},;
				{"H6_DATAINI" 	, dDatI    									, NIL},;
				{"H6_HORAINI"	, cHorI  									, NIL},;
				{"H6_DATAFIN"	, dDatF 									, NIL},;
				{"H6_HORAFIN"	, cHorF  									, NIL},;
				{"H6_PT"     	, 'T'      									, NIL},; //P-parcial T-total
				{"H6_LOTECTL"  	, Left(oDados:NUM_OP,TamSX3("C2_NUM")[1])	, NIL},;
				{"H6_LOCAL"  	, QRYWS62->C2_LOCAL							, NIL},;
				{"H6_QTDPROD"	, QRYWS62->G2_LOTEPAD						, NIL}}

				MSExecAuto({|x| mata681(x)}, aVetor)

				if lMsErroAuto
					cMsgErr := MostraErro("\temp")
					cMsgErr := StrTran(cMsgErr, "<","|")
					cMsgErr := StrTran(cMsgErr, ">","|")
					lOk := .F.
				else
					dbSelectArea("SB1")
					dbSetOrder(1)
					if !dbSeek(XFilial("SB1")+QRYWS62->C2_PRODUTO)
						lOk := .f.

						cMsgErr := "Produto não localizado no cadastro para atualizar a data de validade do lote!."
					else
						dbSelectArea("SC2")
						dbGoTo(QRYWS62->RECSC2)
						if !(SC2->(Recno()) == QRYWS62->RECSC2 .and. RecLock("SC2", .f.))
							lOk := .f.

							cMsgErr := "Não foi possível reservar o registro da Ordem de Produção para atualizar a data de validade do lote!."
						else
							SC2->C2_DTVALID := dDatF + SB1->B1_PRVALID
							SC2->C2_DATPRI  := dDatF
							//SC2->C2_DATPRF  := dDatF + SB1->B1_PRVALID (18/07/17)

							SC2->(MsUnLock())
						endif
					endif
				endif
			endif

			QRYWS62->(dbCloseArea())

			if !lOk
				DisarmTransaction()
			EndIf

		END TRANSACTION

		If lOk
			//			EndTran()
			// Baixa empenhos na tabela Z51
			//BaixaEmp(oDados:NUM_OP)

			cMsgErr := "Apontamento da pesagem da OP executado com sucesso!."
		EndIf

	endif

	oRet:SITUACAO := lOK
	oRet:MENSAGEM := cMsgErr

Return(.t.)

Static function ValDef(xValor, cTipo)

	Default xValor 	:= ""
	Default cTipo 	:= "C"

	if valtype(xValor) <> cTipo
		if cTipo == "N"
			xValor := 0
		elseif cTipo == "L"
			xValor := .F.
		endif
	endif

Return xValor

/*/{Protheus.doc} BaixaPM12

Tratativa para controle de empenhos em processo

@author marcos.santos
@since 21/02/2018
@version 1.0

@type function
/*/
User Function BaixaPM12(cOp) // U_BaixaPM12(cOp)
	Local aAreaZ51 := Z51->(GetArea())
	Local aAreaSB2 := SB2->(GetArea())
	Local aAreaSC2 := SC2->(GetArea())

	cQry :=  "SELECT R_E_C_N_O_ RECNO "
	cQry +=  "FROM " + RetSqlName("Z51") + " "
	cQry +=  "WHERE D_E_L_E_T_ <> '*' "
	cQry +=  "      AND Z51_FILIAL = '" + xFilial("Z51") + "' "
	cQry +=  "      AND Z51_OP = '" + cOp + "' "
	cQry +=  "      AND Z51_LOCAL = '02' " // Matéria Prima
	cQry +=  "      AND Z51_QTD <> 0 "

	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf

	TCQuery cQry New Alias "QRY"

	QRY->(dbGoTop())
	SB2->(dbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
	While QRY->(!EOF())
		Z51->(dbGoTo(QRY->RECNO))
		If Z51->Z51_QTD > 0 // Se sobrar saldo após o checkout será ajustado na SB2
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
		If Z51->(RecLock("Z51", .F.))
			Z51->Z51_QTD := 0
			Z51->(MsUnLock())
		endif

		QRY->(dbSkip())
	EndDo

	SC2->(dbSetOrder(1)) // C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
	if SC2->(dbSeek(xFilial("SC2")+SubStr(cOp,1,6)+SubStr(cOp,7,2)+SubStr(cOp,9,3)))
		SC2->(RecLock("SC2", .F.))
		SC2->C2_XFIMEVO := "S"
		SC2->(MsUnLock())
	endif

	RestArea(aAreaZ51)
	RestArea(aAreaSB2)
	RestArea(aAreaSC2)
	QRY->(dbCloseArea())

Return
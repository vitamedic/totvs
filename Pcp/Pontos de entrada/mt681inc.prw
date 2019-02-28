#include "rwmake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} MT681INC
Ponto de Entrada no Apontamento de Producao para Retornar
Parametro MV_DISTAUT, para Gerar Enderecamento Automatico
nas Entradas apos Entrada de O.P.

@author Ricardo Fiuza
@since 22/09/14
@version 1.0

@type function
/*/
User Function MT681INC()

	Local lWF_Embal := .F.
	Local cMails := SuperGetMv('MV_X681INC',.F., "report_ti@vitamedic.ind.br") //-- Parametro para emails (Natã 01-12-2017)

	//	putmv("MV_DISTAUT","98QUARENTENA")

	If SD3->D3_CF == "PR0" .AND.  SD3->D3_QUANT > 0
		_cde_pa      :=Alltrim(getmv("MV_WFMAIL"))
		_cconta_pa   :=Alltrim(getmv("MV_WFMAIL"))
		_csenha_pa   :=Alltrim(getmv("MV_WFPASSW"))

		_cpara_pa    := cMails
		_ccc_pa      :=" " //"report@vitamedic.ind.br"  com copia
		_ccco_pa     :=" " // com copia oculta
		_cassunto_pa :="Apontamento de Producao : "+alltrim(sh6->h6_produto)+" Lote: "+sh6->h6_lotectl
		cDescProd    := Posicione("SB1",1,xFilial("SB1")+sh6->h6_produto,'B1_DESC')
		_cmensagem_pa:="Produto: "+alltrim(sh6->h6_produto)+" - "+cDescProd+"<P>"
		_cmensagem_pa+="Quantidade Apontada: "+transform(sh6->h6_qtdprod,"@E 999,999,999.99")+"<P>"
		_cmensagem_pa+="Quantidade Perda: "+transform(sh6->h6_qtdperd,"@E 999,999,999.99")+"<P>"
		_cmensagem_pa+="Armazem destino: "+sh6->h6_local+"<P>"
		If sh6->h6_pt = 'T'
			_cmensagem_pa+="Total/Parcial: Total "+"<P>"
		Else
			_cmensagem_pa+="Total/Parcial: Parcial "+"<P>"
		EndIf
		_cmensagem_pa+="Documento: "+sh6->h6_ident+"<P>"
		_cmensagem_pa+="Data base: "+dtoc(sh6->h6_dtapont)+"<P>"
		_cmensagem_pa+="Lote: "+sh6->h6_lotectl+"<P>"
		_cmensagem_pa+="Usuario: "+cusername+"<P>"
		_cmensagem_pa+="Data: "+dtoc(date())+"<P>"
		_cmensagem_pa+="Hora: "+time()+"<P>"

		_canexos_pa  :="" // caminho completo dos arquivos a serem anexados, separados por ;
		_lavisa_pa   :=.f.

		u_envemail(_cde_pa,_cconta_pa,_csenha_pa,_cpara_pa,_ccc_pa,_ccco_pa,_cassunto_pa,_cmensagem_pa,_canexos_pa,_lavisa_pa)

	EndIf

	//tratametno WorkFlow aviso embalagem
	if SG2->(FieldPos("G2_XEMBALA")) > 0

		cCodSG2 := POSICIONE("SC2",1,xFilial("SC2")+SH6->H6_OP,'C2_ROTEIRO')
		lWF_Embal := Posicione("SG2",1,xFilial("SG2")+SH6->H6_PRODUTO+cCodSG2+SH6->H6_OPERAC,"G2_XEMBALA") == "S"

		if lWF_Embal

			_cde_pa      :=Alltrim(getmv("MV_WFMAIL"))
			_cconta_pa   :=Alltrim(getmv("MV_WFMAIL"))
			_csenha_pa   :=Alltrim(getmv("MV_WFPASSW"))

			_cpara_pa    := cMails
			_ccc_pa      :=" " //"report@vitamedic.ind.br"  com copia
			_ccco_pa     :=" " // com copia oculta
			_cassunto_pa :="Apont. Producao Embalagem : "+alltrim(sh6->h6_produto)+" Lote: "+sh6->h6_lotectl
			cDescProd    := Posicione("SB1",1,xFilial("SB1")+sh6->h6_produto,'B1_DESC')

			_cmensagem_pa:="<p><b>Apontamento de Embalagem Realizado no Sistema!</b></p>"
			_cmensagem_pa+="Produto: "+alltrim(sh6->h6_produto)+" - "+cDescProd+"<br>"
			_cmensagem_pa+="Quantidade Apontada: "+transform(sh6->h6_qtdprod,"@E 999,999,999.99")+"<br>"
			_cmensagem_pa+="Quantidade Perda: "+transform(sh6->h6_qtdperd,"@E 999,999,999.99")+"<br>"
			_cmensagem_pa+="Armazem destino: "+sh6->h6_local+"<br>"
			If sh6->h6_pt = 'T'
				_cmensagem_pa+="Total/Parcial: Total "+"<br>"
			Else
				_cmensagem_pa+="Total/Parcial: Parcial "+"<br>"
			EndIf
			_cmensagem_pa+="Documento: "+sh6->h6_ident+"<br>"
			_cmensagem_pa+="Data base: "+dtoc(sh6->h6_dtapont)+"<br>"
			_cmensagem_pa+="Lote: "+sh6->h6_lotectl+"<br>"
			_cmensagem_pa+="Usuario: "+cusername+"<br>"
			_cmensagem_pa+="Data: "+dtoc(date())+"<br>"
			_cmensagem_pa+="Hora: "+time()+"<br>"

			_canexos_pa  :="" // caminho completo dos arquivos a serem anexados, separados por ;
			_lavisa_pa   :=.f.

			u_envemail(_cde_pa,_cconta_pa,_csenha_pa,_cpara_pa,_ccc_pa,_ccco_pa,_cassunto_pa,_cmensagem_pa,_canexos_pa,_lavisa_pa)

		endif
	endif

	// Tratativa para controle de empenhos em processo
	If SH6->H6_OPERAC <> "01"
		BEGIN TRANSACTION
			BaixaEmp(SH6->H6_OP)
		END TRANSACTION
	EndIf

return

/*/{Protheus.doc} BaixaEmp

Tratativa para controle de empenhos em processo

@author marcos.santos
@since 21/02/2018
@version 1.0

@type function
/*/
Static Function BaixaEmp(cOp)
	Local aAreaZ51 := Z51->(GetArea())
	Local aAreaSB2 := SB2->(GetArea())

	cQry :=  "SELECT R_E_C_N_O_ RECNO "
	cQry +=  "FROM " + RetSqlName("Z51") + " "
	cQry +=  "WHERE D_E_L_E_T_ <> '*' "
	cQry +=  "      AND Z51_FILIAL = '" + xFilial("Z51") + "' "
	cQry +=  "      AND Z51_OP = '" + cOp + "' "
	cQry +=  "      AND Z51_LOCAL = '03' " // Material de Embalagem
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

	RestArea(aAreaZ51)
	RestArea(aAreaSB2)
	QRY->(dbCloseArea())

Return

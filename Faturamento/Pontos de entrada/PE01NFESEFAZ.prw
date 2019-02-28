#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'
#INCLUDE "TBICONN.CH" 

#DEFINE CRLF Chr(13)+Chr(10)

/*/{Protheus.doc} PE01NFESEFAZ
//TODO Descrição auto-gerada.

Ponto de entrada localizado na função XmlNfeSef do rdmake NFESEFAZ. 
Através deste ponto é possível realizar manipulações nos dados do produto, 
mensagens adicionais, destinatário, dados da nota, pedido de venda ou compra, 
antes da montagem do XML, no momento da transmissão da NFe.

http://tdn.totvs.com/pages/releaseview.action?pageId=274327446

@author gsamp
@since 24/05/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function PE01NFESEFAZ()

	local aArea			:= getArea()
	local aAreaSD2		:= SD2->( getArea() )
	local aAreaSF2		:= SF2->( getArea() )
	local aAreaSD1		:= SD1->( getArea() )
	//aParam := {aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque,aNfVincRur,aEspVol,aNfVinc,aDetPag,aObsCont}
	Local aProd			:= PARAMIXB[1]
	Local cMensCli		:= PARAMIXB[2]
	Local cMensFis		:= PARAMIXB[3]
	Local aDest			:= PARAMIXB[4]
	Local aNota   		:= PARAMIXB[5]
	Local aInfoItem		:= PARAMIXB[6]
	Local aDupl			:= PARAMIXB[7]
	Local aTransp		:= PARAMIXB[8]
	Local aEntrega		:= PARAMIXB[9]
	Local aRetirada		:= PARAMIXB[10]
	Local aVeiculo		:= PARAMIXB[11]
	Local aReboque		:= PARAMIXB[12]
	local aNfVincRur	:= PARAMIXB[13]
	local aEspVol    	:= PARAMIXB[14]
	local aNfVinc		:= PARAMIXB[15]
	local aDetPag		:= PARAMIXB[16]
	local aObsCont		:= PARAMIXB[17]
	Local lInfAdZF   	:= GetNewPar("MV_INFADZF",.F.)
	local nX			:= 0

	local lMed			:= .F.
	local cLoteCD7		:= "" // lote do medicamento
	local dFabrCD7		:= "" // data de fabricacao do medicamento
	local dValiCD7		:= "" // data de valida do medicamento
	local cPMCCD7		:= "" // PMC do medicamento 
	local cLoteF0A		:= "" // lote do medicamento
	local dFabrF0A		:= "" // data de fabricacao do medicamento
	local dValiF0A		:= "" // data de valida do medicamento
	local cPMCF0A		:= "" // PMC do medicamento 
	local nPMC			:= 0
	local cAux			:= ""
	local cMensAux		:= ""
	local nDescZFM		:= 0
	local _nValCofZF	:= 0
	local _nValPisZF	:= 0
	Local aRetorno		:= {}
	Private tpnf        := ""	

	// adiciono o F2_HORA e F2_HORAEMB no array aNota 
	aadd(aNota,SF2->F2_HORA)    //posição 06  Ricardo Fiuza's 
	aadd(aNota,SF2->F2_HORAEMB)   //posicao 07

	if aNota[4] == "0" // entrada
		for nx := 1 to len(aProd)

			// posiciono na SD1
			//			SD1->( DbgoTop() )
			//			SD1->( dbSetOrder(1) )//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     
			//			SD1->( dbSeek( xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+strzero(aProd[nx,1],tamsx3("D2_ITEM")[1])+aProd[nx,2] ) ) 
			tpnf        := "E"
			cLoteCD7 	:= ""
			dFabrCD7 	:= ""
			dValiCD7 	:= ""
			cPMCCD7		:= ""
			nPMC		:= 0
			cAux		:= ""
			cLoteF0A 	:= ""
			dFabrF0A 	:= ""
			dValiF0A 	:= ""
			cPMCF0A		:= ""

			fDadosF0A(@cLoteF0A, @dFabrF0A, @dValiF0A, @cPMCF0A, @nPMC, aProd[nx,1], SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA) // pego as informacoes da F0A

			If !empty(cLoteF0A)
				cAux += " Lt:"+alltrim(cLoteF0A)
				cAux +=	" Fab:"+alltrim(dFabrF0A)
				if substr(cLoteF0A,1,4)=="AUTO"
					cAux +=	"             "+AllTrim("Val:"+dValiF0A)
				else
					cAux +=	" "+AllTrim("Val:"+dValiF0A)
				endif
			EndIf
			cAux +=	" "+AllTrim("Qtd:"+AllTrim(TransForm(aProd[nx,9],pesqPict("SD1","D1_QUANT"))))	
			If nPMC > 0
				cAux +=	" "+AllTrim("PMC:"+cPMCF0A)
			EndIf
			// adiciono as informacoes auxiliares ao produto
			if !Empty(cAux)
				aProd[nX][04] := allTrim(aProd[nX][04]) + " " + cAux
			endif
			// customizacao especifica vitamedic
			//aProd[nX][16] := IIF(SD2->D2_TIPO$"DNB" .And. SD2->D2_DESCON > 0 ,SD2->D2_PRCVEN+(SD2->D2_DESCON/SD2->D2_QUANT)+(SD2->D2_DESCZFR/SD2->D2_QUANT), IIF(SD2->D2_TIPO == "N" .And. SD2->D2_DESCZFR > 0,SD2->D2_PRCVEN+(SD2->D2_DESCZFR/SD2->D2_QUANT),SD2->D2_PRCVEN)) //CUSTOMIZAÇÃO 16	Ricardo Fiuza's				RetPrvUnit(SD2,nDesconto),; 	IIF(SD2->D2_TIPO == "D",SD2->D2_PRCVEN+(SD2->D2_DESCON/SD2->D2_QUANT), IIF(SD2->D2_TIPO == "N" .And. SD2->D2_DESCZFR > 0,SD2->D2_PRCVEN+(SD2->D2_DESCZFR/SD2->D2_QUANT),SD2->D2_PRCVEN)),;
			If SF1->(FieldPos("F1_MENNF2"))>0
				If !AllTrim(SF1->F1_MENNF2) $ cMensCli
					If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
						cMensCli += " "
					EndIf
					cMensCli += AllTrim(SF1->F1_MENNF2)
				EndIf
			EndIf
		next nX
	else	
		for nx := 1 to len(aProd)

			tpnf        := "S"
			lMed 		:= .F.
			cLoteCD7 	:= ""
			dFabrCD7 	:= ""
			dValiCD7 	:= ""
			cPMCCD7		:= ""
			nPMC		:= 0
			cAux		:= ""
			cLoteF0A 	:= ""
			dFabrF0A 	:= ""
			dValiF0A 	:= ""
			cPMCF0A		:= ""

			fDadosF0A(@cLoteF0A, @dFabrF0A, @dValiF0A, @cPMCF0A, @nPMC, aProd[nx,1], SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA) // pego as informacoes da F0A
			If !empty(cLoteF0A)
				cAux += " Lt:"+alltrim(cLoteF0A)
				cAux +=	 " "+alltrim("Fab:"+dFabrF0A)
				if substr(cLoteF0A,1,4)=="AUTO"
					cAux +=	" "+AllTrim("Val:"+dValiF0A)
				else
					cAux +=	" "+AllTrim("Val:"+dValiF0A)
				endif
			EndIf
			cAux +=	" "+AllTrim("Qtd:"+AllTrim(TransForm(aProd[nx,9],pesqPict("SD2","D2_QUANT"))))
			If nPMC > 0
				cAux +=	" "+AllTrim("PMC:"+cPMCF0A)
			EndIf
			// adiciono as informacoes auxiliares ao produto
			if !Empty(cAux)
				aProd[nX][04] := allTrim(aProd[nX][04]) + " " + cAux
			endif

			// customizacao especifica vitamedic
			aProd[nX][16] := IIF(SD2->D2_TIPO$"DNB" .And. SD2->D2_DESCON > 0 ,SD2->D2_PRCVEN+(SD2->D2_DESCON/SD2->D2_QUANT)+(SD2->D2_DESCZFR/SD2->D2_QUANT), IIF(SD2->D2_TIPO == "N" .And. SD2->D2_DESCZFR > 0,SD2->D2_PRCVEN+(SD2->D2_DESCZFR/SD2->D2_QUANT),SD2->D2_PRCVEN)) //CUSTOMIZAÇÃO 16	Ricardo Fiuza's				RetPrvUnit(SD2,nDesconto),; 	IIF(SD2->D2_TIPO == "D",SD2->D2_PRCVEN+(SD2->D2_DESCON/SD2->D2_QUANT), IIF(SD2->D2_TIPO == "N" .And. SD2->D2_DESCZFR > 0,SD2->D2_PRCVEN+(SD2->D2_DESCZFR/SD2->D2_QUANT),SD2->D2_PRCVEN)),;
		next nX

		cD2Tes	:= SD2->D2_TES

		//***************************************************//
		// mensagens para nota
		//***************************************************//
		dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)

		// Msg Zona Franca de Manaus / ALC
		dbSelectArea("SF3")
		dbSetOrder(4)

		If !Empty(aDest[15]) .And. !SubStr(SD2->D2_CLASFIS,1,1)$"12"

			If MsSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE)

				//-------------------------------------------------
				// Soma os descontos por haver várias linhas na SF3
				// devido a TES's diferentes no mesmo pedido
				// marcos.santos - 29/03/2018
				//-------------------------------------------------
				cQry := "SELECT F3_DESCZFR DESCZFR "
				cQry += "FROM "+ RetSqlName("SF3") +" "
				cQry += "WHERE D_E_L_E_T_ <> '*' "
				cQry += "	AND F3_FILIAL = '"+ xFilial("SF3") +"' "
				cQry += "	AND F3_NFISCAL = '"+ SF2->F2_DOC +"' "
				cQry += "	AND F3_SERIE = '"+ SF2->F2_SERIE +"' "
				cQry := ChangeQuery(cQry)

				If Select("QF3") > 0
					QF3->(DbCloseArea())
				EndIf

				TCQuery cQry New Alias "QF3"

				QF3->(DBGoTop())
				nDescZFM := 0
				While QF3->(!EOF() .And. !Empty(QF3->DESCZFR))
					nDescZFM += QF3->DESCZFR
					QF3->(DBSkip())
				End

				//Desconto Zona Franca PIS e COFINS 
				If	SD2->(FieldPos("D2_DESCZFC"))<>0 .AND. SD2->(FieldPos("D2_DESCZFP"))<>0
					If SD2->D2_DESCZFC > 0	
						__nValCofZF += SD2->D2_DESCZFC
					EndIf
					If SD2->D2_DESCZFP > 0	
						__nValPisZF += SD2->D2_DESCZFP
					EndIf
				EndIf 


				If nDescZFM > 0
					If !AllTrim("Codigo Suframa: "+AllTrim(SA1->A1_SUFRAMA)) $ cMensCli
						cMensCli += iif(!empty(cMensCli),"#","")+"Codigo Suframa: "+AllTrim(SA1->A1_SUFRAMA) // # - Pula linha
					EndIf

					If lInfAdZF .And. (_nValPisZF > 0 .Or. _nValCofZF > 0)
						If !AllTrim("Descontos Ref. a Z.Fr.Manaus / ALC. ICMS - R$ "+AllTrim(str(nDescZFM-SF2->F2_DESCONT-_nValPisZF-_nValCofZF,13,2))+", PIS - R$ "+ AllTrim(str(_nValPisZF,13,2)) +"e COFINS - R$ " +AllTrim(str(_nValCofZF,13,2))) $ cMensFis
							cMensFis += "Descontos Ref. a Z.Fr.Manaus / ALC. ICMS - R$ "+AllTrim(str(nDescZFM-SF2->F2_DESCONT-_nValPisZF-_nValCofZF,13,2))+", PIS - R$ "+ AllTrim(str(_nValPisZF,13,2)) +"e COFINS - R$ " +AllTrim(str(_nValCofZF,13,2))
							cMensFis += iif(!empty(cMensFis),"#","")+"DESC.ICMS/SUFRAMA ART.VI INC.XVII ANEXO IX DO RCTE DEC.4852/97 - COD.AGENFA ORIGEM 912/0012-1"
						Endif
					ElseIF !lInfAdZF .And. (_nValPisZF > 0 .Or. _nValCofZF > 0)
						If !AllTrim("Desconto Ref. ao ICMS - Zona Franca de Manaus / ALC. R$ "+AllTrim(str(nDescZFM-SF2->F2_DESCONT-_nValPisZF-_nValCofZF,13,2))) $ cMensFis
							cMensFis += "Desconto Ref. ao ICMS - Zona Franca de Manaus / ALC. R$ "+AllTrim(str(nDescZFM-SF2->F2_DESCONT-_nValPisZF-_nValCofZF,13,2))
							cMensFis += iif(!empty(cMensFis),"#","")+"DESC.ICMS/SUFRAMA ART.VI INC.XVII ANEXO IX DO RCTE DEC.4852/97 - COD.AGENFA ORIGEM 912/0012-1"
						EndIf
					Else
						If !AllTrim(" Total do desconto ICMS 12% ref. a Z.Fr.Manaus/ALC. R$ "+AllTrim(str(nDescZFM-SF2->F2_DESCONT,13,2))) $ cMensFis
							cMensFis += " Total do desconto ICMS 12% ref. a Z.Fr.Manaus/ALC. R$ "+AllTrim(str(nDescZFM-SF2->F2_DESCONT,13,2))
							cMensFis += iif(!empty(cMensFis),"#","")+" DESC.ICMS/SUFRAMA ART.VI INC.XVII ANEXO IX DO RCTE DEC.4852/97 - COD.AGENFA ORIGEM 912/0012-1"
						EndIf
					EndIF

					// Mensagem Zona Franca de Manaus - Lista Negativa equiparada à Positiva
					If AliasIndic("CD7")
						If Alltrim(CD7->CD7_REFBAS)=="2" .And.;
						!AllTrim("FATURADO CONFORME ART.2o DA LEI 10.996, DE 15 DE DEZEMBRO DE 2004(COMUNICADO DA ANVISA No.12, DE 02 DE JUNHO DE 2005)") $ cMensCli
							cMensCli += iif(!Empty(cMensCli),"#","")+"FATURADO CONFORME ART.2o DA LEI 10.996, DE 15 DE DEZEMBRO DE 2004(COMUNICADO DA ANVISA No.12, DE 02 DE JUNHO DE 2005)"
						Endif
					EndIf
				EndIF
			EndIf
		Endif

		dbSelectArea("SC5")
		dbSetOrder(1)
		MsSeek(xFilial("SC5")+SD2->D2_PEDIDO)

		// Mensagem Licitações
		dbSelectArea("SZL")
		dbSetOrder(3)
		MsSeek(xFilial("SZL")+SC5->C5_NUMLIC)

		dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)

		dbSelectArea("SF4")
		dbSetOrder(1)
		MsSeek(xFilial("SF4")+cD2Tes)

		/////////////////////////////////////
		/* Incluir Mensagens customizadas  */
		/////////////////////////////////////

		/* Mensagem para NF Saída para MT, criadas conforme e-mail recebido em 18/07/2008, enviado pela Contabilidade */
		If (SA1->A1_EST=="MT")
			// A linha abaixo foi removida por solicitação da Contabilidade, CI enviada em 05/11/09 (nº 59/09)
			//_cMensAux:="Regime de Substituicao Tributaria, com responsabilidade de Recolhimento do ICMS pelo Destinatario, Conforme Anexo XIV, Art.3o., do Decreto 1944/89"
			cMensAux:="Medicamentos GENERICOS E/OU SIMILARES, conforme Art. 37 do Anexo VIII do RICMS, paragrafos 2o. e 3o., introduzido pelo Decreto 1388/2008"
			If !AllTrim(cMensAux) $ cMensCli
				cMensCli += iif(!empty(cMensCli),"#","")+AllTrim(cMensAux)
			Endif
		EndIf

		/* Mensagem para Órgão Público - Consumidor Final e Tipo Cliente igual a M(municipal),E(estadual),F(federal) */
		If (SB1->B1_TIPO=="PA") .And. !Empty(SA1->A1_TPEMP) .And. (SA1->A1_TIPO=="F") .And. (SF4->F4_DUPLIC=="S") .And.;
		!AllTrim("BASE DE CALCULO REDUZIDA CONF.ART.8o INC.VIII, ANEXO IX RCTE-GO") $ cMensFis
			cMensFis += iif(!empty(cMensFis),"#","")+AllTrim("BASE DE CALCULO REDUZIDA CONF.ART.8o INC.VIII, ANEXO IX RCTE-GO")
		EndIf

		/* Mensagem para Distribuidores do Estado de Goiás */
		If (SB1->B1_TIPO=="PA") .And. (SA1->A1_TIPO=="R") .And. (SA1->A1_EST=="GO") .And. (SF4->F4_DUPLIC=="S") .And. (SF4->F4_BASEICM>0) .And.;
		!AllTrim("BASE DE CALCULO REDUZIDA CONF.ART.8o INC.VIII, ANEXO IX RCTE-GO") $ cMensFis
			cMensFis += iif(!empty(cMensFis),"#","")+AllTrim("BASE DE CALCULO REDUZIDA CONF.ART.8o INC.VIII, ANEXO IX RCTE-GO")
		EndIf

		/* Mensagem da Fórmula no TES */
		If !Empty(SF4->F4_FORMULA) .And. !AllTrim(FORMULA(SF4->F4_FORMULA)) $ cMensFis
			cMensFis += iif(!empty(cMensFis),"#","")+AllTrim(FORMULA(SF4->F4_FORMULA))
		EndIf

		/* Mensagem cadastro cliente */
		If !Empty(SA1->A1_LIMINAR) .And. !AllTrim(SA1->A1_LIMINAR) $ cMensCli
			cMensCli += iif(!empty(cMensCli),"#","")+AllTrim(SA1->A1_LIMINAR)
		Endif

		/* Desconto Sobre a Nota */
		If SC5->C5_DESCONT > 0 .And. !AllTrim("Desconto Extra R$ "+AllTrim(str(SC5->C5_DESCONT,13,2))) $ cMensCli
			cMensCli += iif(!empty(cMensCli),"#","")+"Desconto Extra R$ "+AllTrim(str(SC5->C5_DESCONT,13,2)) // # - Pula linha
		EndIf

		/* Mensagem do Pedido */
		If !Empty(SC5->C5_MENNOTA) .And. !AllTrim(SC5->C5_MENNOTA) $ cMensCli
			cMensCli += iif(!empty(cMensCli),"#","")+AllTrim(SC5->C5_MENNOTA) // # - Pula linha
		EndIf

		/* Mensagem com o Nº do Pedido de Venda*/
		If !Empty(SC5->C5_NUM) .And. !AllTrim(SC5->C5_NUM) $ cMensCli .And. (SF4->F4_DUPLIC == "S" .And. Empty(SA1->A1_TPEMP))
			cMensCli += iif(!empty(cMensCli),"#","")+"N.Pedido: "+AllTrim(SC5->C5_NUM) // # - Pula linha
		EndIf    

		/* Mensagem de nota com Desconto Financeiro*/     //Ricardo Moreira   Fiuza's Informatica 24/09/2015
		If SC5->C5_PDESCAB > 0 .And. !AllTrim("Desconto Comercial de "+AllTrim(str(SC5->C5_PDESCAB))+"%"+ " no valor total de R$ "+ AllTrim(str(SF2->F2_DESCONT,13,2))) $ cMensCli 
			cMensCli += iif(!empty(cMensCli),"#","")+"Desconto Comercial de "+AllTrim(str(SC5->C5_PDESCAB))+"%"+ " no valor total de R$ "+ AllTrim(str(SF2->F2_DESCONT,13,2))// # - Pula linha
		EndIf    

		//"Desconto Comercial de ____% no valor total de R$______." Pedido Karla

		/*If !AllTrim(SC5->C5_MENNOTA) $ cMensCli
		If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
		cMensCli += " "
		EndIf
		cMensCli += AllTrim(SC5->C5_MENNOTA)
		EndIf
		If !Empty(SC5->C5_MENPAD) .And. !AllTrim(FORMULA(SC5->C5_MENPAD)) $ cMensFis
		If Len(cMensFis) > 0 .And. SubStr(cMensFis, Len(cMensFis), 1) <> " "
		cMensFis += " "
		EndIf
		cMensFis += AllTrim(FORMULA(SC5->C5_MENPAD))
		EndIf
		*/

		/* Licitações */
		If  (SC5->C5_LICITAC =="S") .And. (aNota[4] == "1") .And.;
		(SC5->C5_TIPO<>"D")
			If !Empty(SZL->ZL_NUMEDI) .And. !AllTrim(SZL->ZL_NUMEDI) $ cMensCli
				cMensCli += iif(!Empty(cMensCli),"#","")+"Edital: "+AllTrim(SZL->ZL_NUMEDI)
			EndIf
			If !Empty(SZL->ZL_OBSNF) .And. !AllTrim(SZL->ZL_OBSNF) $ cMensCli
				cMensCli += iif(!Empty(cMensCli),"#","")+AllTrim(SZL->ZL_OBSNF)
			EndIf
			If !Empty(SA1->A1_TPEMP)
				If !AllTrim("DADOS BANCARIOS: BANCO DO BRASIL - AGENCIA: 3388-X C/C: 6040-2") $ cMensCli .And. SF4->F4_DUPLIC == "S"
					cMensCli += iif(!Empty(cMensCli),"#","")+AllTrim("DADOS BANCARIOS: BANCO DO BRASIL - AGENCIA: 3388-X C/C: 6040-2")
				EndIf
			Endif
			If SA1->A1_EST<>"EX"
				If !AllTrim("VENDA PROIBIDA AO COMERCIO VAREJISTA") $ cMensCli
					cMensCli += iif(!Empty(cMensCli),"#","")+AllTrim("VENDA PROIBIDA AO COMERCIO VAREJISTA")
				EndIf
			EndIf
		EndIf

		/* Mensagem NF Original */
		If !Empty(SD2->D2_NFORI) .And. !AllTrim(SD2->D2_NFORI) $ cMensCli
			cMensCli += iif(!empty(cMensCli),"#","")+"N.F. Original: "+AllTrim(SD2->D2_NFORI)
		Endif

		/* Mensagem de Conferencia de Mercadoria*/
		If !AllTrim("Favor Conferir a Mercadoria, Nao aceitamos reclamacoes posteriores") $ cMensCli
			cMensCli += iif(!empty(cMensCli),"#","")+"Favor Conferir a Mercadoria, Nao aceitamos reclamacoes posteriores"
		Endif                                   

		//Ricardo Moreira Mensagem do valor do IPI na danfe Inicio 05/06/14
		If Alltrim(SD2->D2_CF) $ "5556/6556/5553/6553/5949/6949" .And. SD2->D2_DESPESA > 0
			cMensCli += iif(!Empty(cMensCli),"#","")+"Valor do IPI: "+AllTrim(str(SD2->D2_DESPESA,13,2))	  // valor do IPI ou despesas acessoriais. 					
		EndIf

	EndIf

	aadd(aRetorno,aProd)    	//1
	aadd(aRetorno,cMensCli) 	//2
	aadd(aRetorno,cMensFis) 	//3
	aadd(aRetorno,aDest)    	//4
	aadd(aRetorno,aNota)    	//5
	aadd(aRetorno,aInfoItem)	//6
	aadd(aRetorno,aDupl)    	//7
	aadd(aRetorno,aTransp)  	//8
	aadd(aRetorno,aEntrega) 	//9
	aadd(aRetorno,aRetirada)	//10
	aadd(aRetorno,aVeiculo) 	//11
	aadd(aRetorno,aReboque) 	//12
	aadd(aRetorno,aNfVincRur)	//13
	aadd(aRetorno,aEspVol)		//14 
	aadd(aRetorno,aNfVinc)		//15
	aadd(aRetorno,aDetPag)		//16
	aadd(aRetorno,aObsCont)		//17

	restArea( aAreaSD1 )
	restArea( aAreaSF2 )
	restArea( aAreaSD2 )
	restArea( aArea )

Return aRetorno
// pego os dados da F0A - Rastreio notas
//================================
static function fDadosF0A(cLoteF0A, dFabrF0A, dValiF0A, cPMCF0A, nPMC, nItem, cNota0A, cSerie0A, cCliente0A, cLoja0A)
	//                    cLoteF0A, dFabrF0A, dValiF0A, @cPMCF0A, @nPMC,aProd[nx,1], SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA
	//================================

	local cQuery 		:= ""
	local cItSD2		:= ""

	default cLoteF0A	:= ""
	default dFabrF0A	:= ""
	default dValiF0A	:= ""
	default cPMCF0A		:= ""
	default nPMC		:= ""
	default nItem		:= 0
	default cNota0A		:= ""
	default cSerie0A	:= ""
	default cCliente0A	:= ""
	default cLoja0A		:= ""

	If tpnf = "S"
		cItSD2 := strZero(nItem,len(SD2->D2_ITEM))
	Elseif tpnf = "E"
		cItSD2 := strZero(nItem,len(SD1->D1_ITEM))
	EndIf
	if select("TRBCD7") > 0 
		TRBCD7->(dbCloseArea())		
	endIf

	if select("TRBF0A") > 0 
		TRBF0A->(dbCloseArea())		
	endIf

	//( SD2 )->( D2_SERIE + D2_DOC + D2_CLIENTE + D2_LOJA + D2_ITEM )	
	cQuery := " SELECT * FROM " + retSqlName("F0A") + " F0A 		" + CRLF
	cQuery += " WHERE F0A.D_E_L_E_T_ = ' '							" + CRLF
	cQuery += " AND F0A.F0A_TPMOV 	= '" + tpnf + "'				" + CRLF	
	cQuery += " AND F0A.F0A_SERIE 	= '" + cSerie0A + "'	    	" + CRLF
	cQuery += " AND F0A.F0A_DOC 	= '" + cNota0A + "'		    	" + CRLF
	cQuery += " AND F0A.F0A_CLIFOR 	= '" + cCliente0A + "'	    	" + CRLF
	cQuery += " AND F0A.F0A_LOJA 	= '" + cLoja0A + "'		        " + CRLF
	cQuery += " AND F0A.F0A_ITEM 	= '" + cItSD2 + "'				" + CRLF

	tcQuery cQuery new alias "TRBF0A"

	//aadd(aMed,{CD7->CD7_LOTE,CD7->CD7_QTDLOT,CD7->CD7_FABRIC,CD7->CD7_VALID,CD7->CD7_PRECO,IIf(CD7->(ColumnPos("CD7_CODANV")) > 0,CD7->CD7_CODANV,"")})
	if TRBF0A->(!eof())

		cLoteF0A	:= TRBF0A->F0A_LOTE
		dFabrF0A	:= dtoc(stod(TRBF0A->F0A_FABRIC))
		dValiF0A	:= dtoc(stod(TRBF0A->F0A_VALID))
		cPMCF0A		:= AllTrim(TransForm(TRBF0A->F0A_PRECO,TM(TRBF0A->F0A_PRECO,TamSX3("D2_TOTAL")[1],TamSX3("D2_TOTAL")[2])))
		nPMC		:= TRBF0A->F0A_PRECO
	endIf

return
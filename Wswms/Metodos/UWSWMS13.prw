#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UWSWMS13 ºAutor  ³Microsiga           º Data ³  20/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Metodo WS para consulta de ordem de separação (PV) HEADER   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UWSWMS13(oFil, oRet)

	Local lOk := .T.
	Local cMsgErr 	:= ""
	Local cQry		:= ""	
	Local nQtdReg	:= 0

    Local cOSDe := cOSAte := cCliDe := cCliAte := ""

	Local oNewOS
	
	PRIVATE lMsErroAuto := .F.
	
	oRet:aRet 	 := {}
	oRet:lRet	 := .t.
	oRet:cErros	 := ""
	oRet:nQtdReg := 0   
	
	if empty(oFil:cEmpresa)
		oFil:cEmpresa := "01"
		oFil:cParFil  := "01"
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

	if !empty(oFil:cOSDe) .or. !empty(oFil:cOSAte)
		cOSDe 	:= Pad(oFil:cOSDe, TamSX3("Z52_PEDIDO")[1]+TamSX3("Z52_NUMOS")[1])
		cOSAte 	:= Pad(oFil:cOSAte, TamSX3("Z52_PEDIDO")[1]+TamSX3("Z52_NUMOS")[1])
	endif

	if !empty(oFil:cCliDe) .or. !empty(oFil:cCliAte)
		cCliDe 	:= Pad(oFil:cCliDe, TamSX3("C5_CLIENTE")[1])
		cCliAte := Pad(oFil:cCliAte, TamSX3("C5_CLIENTE")[1])
	endif
	
	if lOK
		cQry :=        "  SELECT Z52.Z52_PEDIDO "
		cQry += CRLF + "       , Z52.Z52_NUMOS "
		cQry += CRLF + "       , SC5.C5_NUM "
		cQry += CRLF + "       , Z52.Z52_CLIENT "
		cQry += CRLF + "       , Z52.Z52_LOJA "
		cQry += CRLF + "       , SA1.A1_NOME "
		cQry += CRLF + "       , SA1.A1_ESTE "
		cQry += CRLF + "       , SA1.A1_MUNE "
		cQry += CRLF + "       , SA1.A1_ENDENT "
		cQry += CRLF + "       , SA1.A1_BAIRROE "
		cQry += CRLF + "       , SA1.A1_CEPE "
		cQry += CRLF + "       , SA1.A1_XOBSEX1 "
		cQry += CRLF + "       , SA1.A1_XOBSEX2 "
		cQry += CRLF + "       , SA1.A1_XOBSEX3 "
		cQry += CRLF + "       , SA1.A1_XOBSEX4 "
		cQry += CRLF + "       , SA1.A1_XOBSEX5 "
		cQry += CRLF + "       , SA4.A4_COD "
		cQry += CRLF + "       , SA4.A4_NOME "
		cQry += CRLF + "       , SC5.C5_EMISSAO "
		cQry += CRLF + "       , Min(Z52.Z52_DATALI) Z52_DATALI "
		cQry += CRLF + "       , SF2.F2_DOC "
		cQry += CRLF + "       , SF2.F2_VOLUME1 " 
		cQry += CRLF + "       , SF2.F2_ESPECI1 "
		cQry += CRLF + "       , SF2.F2_PLIQUI "
		cQry += CRLF + "       , SF2.F2_PBRUTO "
		cQry += CRLF + "       , SF2.F2_VALBRUT "
		cQry += CRLF + "       , COUNT(Z52.Z52_PEDIDO) QTD_ITENS "
		cQry += CRLF + " FROM " + RetSqlName("Z52") + " Z52 "
		cQry += CRLF + "  INNER JOIN " + RetSqlName("SA1") + " SA1 ON (SA1.A1_FILIAL   = '" + xFilial("SA1") + "' "
		cQry += CRLF + "                                               AND SA1.A1_COD  = Z52.Z52_CLIENT "
		cQry += CRLF + "                                               AND SA1.A1_LOJA = Z52.Z52_LOJA "
		cQry += CRLF + "                                              ) "
		cQry += CRLF + "  INNER JOIN " + RetSqlName("SC5") + " SC5 ON (SC5.D_E_L_E_T_    = ' ' "
		cQry += CRLF + "                           AND SC5.C5_FILIAL  = '" + xFilial("SC5") + "' "
		cQry += CRLF + "                           AND SC5.C5_NUM     = Z52.Z52_PEDIDO "
		cQry += CRLF + "                           ) "
		cQry += CRLF + "  LEFT JOIN " + RetSqlName("SD2") + " SD2 ON (SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
		cQry += CRLF + "                           AND SD2.D2_PEDIDO  = Z52.Z52_PEDIDO "
		cQry += CRLF + "                           AND SD2.D2_ITEMPV  = Z52.Z52_ITEM "
		cQry += CRLF + "                           AND SD2.D_E_L_E_T_ = ' ' "
		cQry += CRLF + "                         ) "
		cQry += CRLF + "  LEFT JOIN " + RetSqlName("SF2") + " SF2 ON (SF2.F2_FILIAL = '" + xFilial("SF2") + "' "
		cQry += CRLF + "                           AND SF2.F2_DOC      = SD2.D2_DOC "
		cQry += CRLF + "                           AND SF2.F2_SERIE    = SD2.D2_SERIE "
		cQry += CRLF + "                           AND SF2.D_E_L_E_T_  = ' ' "
		cQry += CRLF + "                         ) "
		cQry += CRLF + "  LEFT JOIN " + RetSqlName("SA4") + " SA4 ON (SA4.A4_FILIAL       = '" + xFilial("SA4") + "' "
		cQry += CRLF + "                           AND SA4.A4_COD      = SF2.F2_TRANSP "
		cQry += CRLF + "                           AND SA4.D_E_L_E_T_  = ' ' "
		cQry += CRLF + "                         ) "
		cQry += CRLF + " "
		cQry += CRLF + " WHERE Z52.Z52_FILIAL  = '" + xFilial("Z52") + "' "

		if !empty(cOSDe) .or. !empty(cOSAte)
			cQry += CRLF + "   AND (Z52.Z52_PEDIDO || Z52.Z52_NUMOS) >= '" + cOSDe + "' "
			cQry += CRLF + "   AND (Z52.Z52_PEDIDO || Z52.Z52_NUMOS) <= '" + cOSAte + "' "
		endif

		if !empty(oFil:cEmisDe) .or. !empty(oFil:cEmisAte)
			cQry += CRLF + "   AND SC5.C5_EMISSAO >= '" + oFil:cEmisDe + "' "
			cQry += CRLF + "   AND SC5.C5_EMISSAO <= '" + oFil:cEmisAte + "' "
		endif

		if !empty(cCliDe) .or. !empty(cCliAte)
			cQry += CRLF + "   AND SC5.C5_CLIENTE >= '" + cCliDe + "' "
			cQry += CRLF + "   AND SC5.C5_CLIENTE <= '" + cCliAte + "' "
		endif

		cQry += CRLF + "   AND Z52.Z52_STATUS  IN ('1', '3', '5') "
		cQry += CRLF + " GROUP BY Z52.Z52_PEDIDO "
		cQry += CRLF + "        , Z52.Z52_NUMOS "
		cQry += CRLF + "        , SC5.C5_NUM "
		cQry += CRLF + "        , Z52.Z52_CLIENT "
		cQry += CRLF + "        , Z52.Z52_LOJA "
		cQry += CRLF + "        , SA1.A1_NOME "
		cQry += CRLF + "        , SA1.A1_ESTE "
		cQry += CRLF + "        , SA1.A1_MUNE "
		cQry += CRLF + "        , SA1.A1_ENDENT "
		cQry += CRLF + "        , SA1.A1_BAIRROE "
		cQry += CRLF + "        , SA1.A1_CEPE "
		cQry += CRLF + "        , SA1.A1_XOBSEX1 "
		cQry += CRLF + "        , SA1.A1_XOBSEX2 "
		cQry += CRLF + "        , SA1.A1_XOBSEX3 "
		cQry += CRLF + "        , SA1.A1_XOBSEX4 "
		cQry += CRLF + "        , SA1.A1_XOBSEX5 "
		cQry += CRLF + "        , SA4.A4_COD "
		cQry += CRLF + "        , SA4.A4_NOME "
		cQry += CRLF + "        , SC5.C5_EMISSAO "
		cQry += CRLF + "        , SF2.F2_DOC "
		cQry += CRLF + "        , SF2.F2_VOLUME1 "
		cQry += CRLF + "        , SF2.F2_ESPECI1 "
		cQry += CRLF + "        , SF2.F2_PLIQUI "
		cQry += CRLF + "        , SF2.F2_PBRUTO "
		cQry += CRLF + "        , SF2.F2_VALBRUT "
		
		MemoWrite("c:\temp\UWSWMS13.sql", cQry)
		
		cQry := ChangeQuery(cQry)
		
		If Select("QRYWS1") > 0
			QRYWS1->(DbCloseArea())
		EndIf
		
		TcQuery cQry New Alias "QRYWS1" // Cria uma nova area com o resultado do query
		
		QRYWS1->(dbGoTop())
		
		if QRYWS1->(Eof())
		  	// Cria e alimenta uma nova instancia do consulta OS
		  	oNewOS :=  WSClassNew( "WSRet_OS" )
		  	
		  	oNewOS:NUM_OS 			:= ""
		  	oNewOS:TIPO_OS 			:= ""
		  	oNewOS:COD_CLIENTE 		:= ""
		  	oNewOS:NOME_CLIENTE 	:= ""
		  	oNewOS:ENTREGA_UF 		:= ""
		  	oNewOS:ENTREGA_CID 		:= ""
		  	oNewOS:ENTREGA_ENDER 	:= ""
		  	oNewOS:ENTREGA_BAIR 	:= ""
		  	oNewOS:ENTREGA_CEP 		:= ""
		  	oNewOS:COD_TRANSP 		:= ""
		  	oNewOS:NOME_TRANSP 		:= ""
		  	oNewOS:CAMINHAO 		:= ""
		  	oNewOS:NOTAFISCAL 		:= ""
		  	oNewOS:FATURADO 		:= ""
		  	oNewOS:VLR_TOTAL 		:= 0
		  	oNewOS:PESO_TOTAL 		:= 0
		  	oNewOS:NR_ITENS 		:= 0
		  	oNewOS:NR_VOLUMES 		:= 0
		  	oNewOS:ALOCACAO 		:= ""
		  	oNewOS:ARMAZEM 			:= ""
		  	oNewOS:DT_EMISSAO 		:= ""
		  	oNewOS:DT_LIBERACAO 	:= ""
		  	oNewOS:OBS_CLIENTE 	  	:= ""
		  	
		  	AAdd( oRet:aRet, oNewOS )
		  	
		  	lOk := .f.
		  	cMsgErr := "Ordem de separação não encontrada"
		else
			While QRYWS1->(!Eof())
				
			  	// Cria e alimenta uma nova instancia 
			  	oNewOS :=  WSClassNew( "WSRet_OS" )

			  	oNewOS:NUM_OS 			  := QRYWS1->(Z52_PEDIDO + Z52_NUMOS)
			  	oNewOS:TIPO_OS 			  := "" //Tipo da Ordem (Branco) utilizada pelo Evolutio para classificar a O.S.
			  	oNewOS:COD_CLIENTE 		  := QRYWS1->(Z52_CLIENT+Z52_LOJA)
			  	oNewOS:NOME_CLIENTE 	  := QRYWS1->A1_NOME
			  	oNewOS:ENTREGA_UF 		  := QRYWS1->A1_ESTE
			  	oNewOS:ENTREGA_CID 		  := QRYWS1->A1_MUNE
			  	oNewOS:ENTREGA_ENDER 	  := QRYWS1->A1_ENDENT
			  	oNewOS:ENTREGA_BAIR 	  := QRYWS1->A1_BAIRROE
			  	oNewOS:ENTREGA_CEP 		  := QRYWS1->A1_CEPE
			  	oNewOS:COD_TRANSP 		  := QRYWS1->A4_COD
			  	oNewOS:NOME_TRANSP 		  := QRYWS1->A4_NOME
			  	oNewOS:CAMINHAO 		  := "" //Caminhão (em branco)
			  	oNewOS:NOTAFISCAL 		  := alltrim(QRYWS1->F2_DOC) 
			  	oNewOS:FATURADO 		  := iif(empty(alltrim(QRYWS1->F2_DOC)), "N", "S")
			  	oNewOS:VLR_TOTAL 		  := QRYWS1->F2_VALBRUT
			  	oNewOS:PESO_TOTAL 		  := QRYWS1->F2_PBRUTO
			  	oNewOS:NR_ITENS 		  := QRYWS1->QTD_ITENS
			  	oNewOS:NR_VOLUMES 		  := QRYWS1->F2_VOLUME1
			  	oNewOS:ALOCACAO 		  := "" //QRYWS1-> //Alocado (????)
			  	oNewOS:ARMAZEM 			  := "" //QRYWS1-> //Armazém (????)
			  	oNewOS:DT_EMISSAO 		  := DtoC(StoD(QRYWS1->C5_EMISSAO))
			  	oNewOS:DT_LIBERACAO 	  := DtoC(StoD(QRYWS1->Z52_DATALI))
			  	oNewOS:OBS_CLIENTE 	  	  := AllTrim(QRYWS1->A1_XOBSEX1)
                
                /*
			  	oNewOS:OBS_CLIENTE 	  	  := Iif(empty(AllTrim(QRYWS1->A1_XOBSEX1)), "", AllTrim(QRYWS1->A1_XOBSEX1)) + ;
			  	                             Iif(empty(AllTrim(QRYWS1->A1_XOBSEX2)), "", CRLF+AllTrim(QRYWS1->A1_XOBSEX2)) + ;
			  	                             Iif(empty(AllTrim(QRYWS1->A1_XOBSEX3)), "", CRLF+AllTrim(QRYWS1->A1_XOBSEX3)) + ;
			  	                             Iif(empty(AllTrim(QRYWS1->A1_XOBSEX4)), "", CRLF+AllTrim(QRYWS1->A1_XOBSEX4)) + ;
			  	                             Iif(empty(AllTrim(QRYWS1->A1_XOBSEX5)), "", CRLF+AllTrim(QRYWS1->A1_XOBSEX5)) 
				*/
				
			  	AAdd( oRet:aRet, oNewOS )
			
				nQtdReg++
				lOK := .t.
			
				QRYWS1->(DbSkip())
			enddo
		endif
			
		QRYWS1->(DbCloseArea())
		
	endif                      
	
	oRet:lRet	 := lOK
	oRet:cErros	 := cMsgErr
	oRet:nQtdReg := nQtdReg

Return(.t.)
/*/{Protheus.doc} MTA450I
	Executado apos atualizacao da liberacao de pedido.
	Utilizado para reservar somente os volumes completos dos lotes.
@author Henrique Corrêa 
@since 18/07/17
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
#Include 'Protheus.ch'
#Include 'Topconn.ch'

#define CRLF CHR(13)+CHR(10)	


User Function MTA450I()    
RETURN(.T.)
/*
Local nI 				:= 0
Local nY                := 0 
Local lRet				:= .t.
Local cQry				:= ""
Local aSaldos         	:= {}
Local nQtdLib           := 0
Local nQtdVnd       	:= 0
Local aArea             := GetArea()
Local aArSC5            := SC5->(GetArea())
Local aArSC6            := SC6->(GetArea())
Local aArSC9            := SC9->(GetArea())
Local aArSF4            := SF4->(GetArea())
dbSelectArea("SC6")
dbSetOrder(1)
if !MSSeek(XFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)
	lRet := .f.   
 	RestArea(aArSC6	)
 	return(lRet)
endif

dbSelectArea("SF4")
dbSetOrder(1)
MsSeek(xFilial("SF4")+SC6->C6_TES)

cQry := " SELECT SB1.B1_COD CODIGO, SB1.B1_TIPO                            " + CRLF
cQry += "      , SB1.B1_DESC                               " + CRLF
cQry += "      , SB8.B8_LOTECTL LOTECTL                              " + CRLF
cQry += "      , SB8.B8_DTVALID DTVALID                             " + CRLF
cQry += "      , SB8.B8_SALDO                                " + CRLF
cQry += "      , SB8.B8_EMPENHO                              " + CRLF
cQry += "      , (SB8.B8_SALDO - SB8.B8_EMPENHO) DISPONIVEL                        " + CRLF
cQry += "      , SB1.B1_CXPAD QTDE_VOLUME                             " + CRLF
cQry += "      , ROUND((SB8.B8_SALDO - SB8.B8_EMPENHO) - Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD) /SB1.B1_CXPAD,1)  QTD_VOLUMES     " + CRLF
cQry += "      , ((SB8.B8_SALDO - SB8.B8_EMPENHO) - Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD)) / SB1.B1_CXPAD        VOL_INTEIROS     " + CRLF 
cQry += "      , Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD)                                                           VOL_INCOMPLETOS    " + CRLF
cQry += " FROM " + RetSqlName("SB8") + " SB8 " + CRLF
cQry += "    , " + RetSqlName("SB1") + " SB1 " + CRLF
cQry += " WHERE SB1.B1_FILIAL 										= '"+XFilial("SB1")+"' " + CRLF
cQry += "   AND SB1.B1_COD    										= SB8.B8_PRODUTO " + CRLF
cQry += "   AND SB1.D_E_L_E_T_ 										= ' ' " + CRLF
cQry += "   AND SB8.B8_FILIAL 										= '"+XFilial("SB8")+"'                             " + CRLF
cQry += "   AND (SB8.B8_SALDO - SB8.B8_EMPENHO) 					> 0 " + CRLF
cQry += "   AND Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, SB1.B1_CXPAD)   <> 0 " + CRLF
cQry += "   AND SB8.D_E_L_E_T_ 										= ' ' " + CRLF
cQry += "   AND SB1.B1_TIPO 										IN ('PA', 'PN') " + CRLF
cQry += "   AND SB8.B8_PRODUTO 										= '"+SC9->C9_PRODUTO+"' " + CRLF
cQry += " ORDER BY SB1.B1_COD " + CRLF
cQry += "      , SB8.B8_DTVALID ASC " + CRLF

if Select("QSELOT") > 0
	QSELOT->( dbCloseArea() )
endif	

pRecnos := u_CountRegs(cQry,"QSELOT")

if QSELOT->(!Eof()) .and. nQtdLib > 0
	if QSELOT->QTDE_VOLUME > 0
		nQtdVol := QSELOT->QTDE_VOLUME
	else
		nQtdVol := 1
	endif
	
	aSaldos  := {}
	nQtdDisp := QSELOT->DISPONIVEL
	
	do while QSELOT->(!Eof()) .and. nQtdLib > 0
	
		nY := AScan(aSaldos, {|x| x[1] == QSELOT->LOTECTL})
		
		if nQtdDisp >= nQtdLib
			
			if nY > 0
				aSaldos[nY,5] += nQtdLib
			else
				AAdd(aSaldos, { QSELOT->LOTECTL, "", "", "", nQtdLib, 0, StoD(QSELOT->DTVALID) })
			endif	
			
			exit
		
		elseif nQtdDisp >= nQtdVol
				
				nQtdDisp -= nQtdVol
				nQtdLib  -= nQtdVol
				
				if nY > 0
					aSaldos[nY,5] += nQtdVol
				else
					AAdd(aSaldos, { QSELOT->LOTECTL, "", "", "", nQtdVol, 0, StoD(QSELOT->DTVALID) })
				endif	

		else
			QSELOT->(dbSkip())
			
			if QSELOT->(!Eof())
				nQtdDisp := QSELOT->DISPONIVEL
			endif

		endif
	
	enddo
	
    if Len(aSaldos) > 0
		a450Grava(1,.t.,.t.,.f.,aSaldos,.t.)
    endif
endif

QSELOT->( dbCloseArea() )

RestArea(aArSF4)
RestArea(aArSC9)
RestArea(aArSC6)
RestArea(aArSC5)
RestArea(aArea)
*/
Return( lRet )
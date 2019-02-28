#INCLUDE "TOPCONN.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} Vit632
	Gatilho para atualizar a data de fabricacao no browse da SD2.
@author Microsiga
@since 24/07/2017
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function Vit632()
Local cQry   	:= ""                           
Local dDtFab 	:= CtoD("")
Local cCampo    := Upper(AllTrim(ReadVar()))
Local cLoteCtl 	:= &(ReadVar())                      

if !("LOTECTL" $ cCampo) .and. Type("M->D2_LOTECTL") == "C"
	cLoteCtl := M->D2_LOTECTL
endif

cQry := CRLF + " SELECT MIN(Q.D1_DTFABR) DTFABR "
cQry += CRLF + " FROM "+RetSqlName("SD1")+" Q "
cQry += CRLF + " WHERE Q.D1_FILIAL     = SD2010.D2_FILIAL "
cQry += CRLF + "   AND Q.D1_COD        = SD2010.D2_COD     "
cQry += CRLF + "   AND Q.D1_LOCAL      = '98' "
cQry += CRLF + "   AND Q.D1_LOTECTL    = '"+cLoteCtl+"'  "
cQry += CRLF + "   AND Q.D1_DTFABR     <> ' ' "
cQry += CRLF + "   AND Q.D_E_L_E_T_    = ' ' "
cQry += CRLF + " GROUP BY Q.D1_LOTECTL "

if Select("QDTFAB") > 0
	QDTFAB->( dbCloseArea() )
endif	

pRecnos := u_CountRegs(cQry,"QDTFAB")

if QDTFAB->(!Eof()) .and. !empty(QDTFAB->DTFABR)
	dDtFab := StoD(QDTFAB->DTFABR)
else
	cQry := CRLF + " SELECT MIN(Q.C2_DATRF) DTFABR "
	cQry += CRLF + " FROM "+RetSqlName("SC2")+" Q "
	cQry += CRLF + " WHERE Q.C2_FILIAL     = SD2010.D2_FILIAL "
	cQry += CRLF + "   AND Q.C2_PRODUTO    = SD2010.D2_COD     "
	//cQry += CRLF + "   AND Q.C2_LOCAL      = '98' "
	cQry += CRLF + "   AND Q.C2_LOTECTL    = '"+cLoteCtl+"'  "
	cQry += CRLF + "   AND Q.D_E_L_E_T_    = ' ' "
	cQry += CRLF + " GROUP BY Q.C2_LOTECTL "
	
	if Select("QDTFAB") > 0
		QDTFAB->( dbCloseArea() )
	endif	
	
	pRecnos := u_CountRegs(cQry,"QDTFAB")
	
	if QDTFAB->(!Eof()) .and. !empty(QDTFAB->DTFABR)
		dDtFab := StoD(QDTFAB->DTFABR)
	endif
endif

QDTFAB->( dbCloseArea() )

Return( dDtFab )
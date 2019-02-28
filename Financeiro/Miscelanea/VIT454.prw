#INCLUDE "PROTHEUS.CH"
#INCLUDE "AVPRINT.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VIT454     º Autor ³ Ricardo Moreira   º Data ³  12/07/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Altera %  de comissão                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitamedic			                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VIT454  //U_VIT454() 
PRIVATE cPerg      := "VIT454"

fValidPerg()

if msgyesno("Manutençao de Comissao de Gerentes Regionais " + chr(13) + " Essa Rotina deve ser Executada apos o Relcalculo das Comissoes !" + chr(13) + "Continuar ?","VIT454 -  **Atençao**")
	iif(pergunte(cPerg,.T.),processa({|| fGeraCom()}),.f.) 
endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGeraCom  º Autor ³ Ricardo Moreira   º Data ³  11/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Altera a Porcentagem de Comissão nas TAbelas SC5/SE1/SD2   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fGeraCom()  
Local cCont := 0
Local aNotas := {}

FechaAlias("TSF2")

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerySF2()),'TSF2',.T.,.T.)

dbSelectArea("TSF2")
dbgotop()
DO WHILE ! EOF()
	///ATUALIZA ITEM DAS NOTAS FISCAIS SD2
	FechaAlias("TSD2")
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerySD2()),'TSD2',.T.,.T.)                                 
	dbSelectArea("TSD2")
	dbgotop()	
	DO WHILE ! EOF()
		INCPROC("Processando Tabela SD2 - Vendedor..." + Cvaltochar(mv_par03))
		Dbselectarea("SD2")
    	Dbsetorder(3)
    	If Dbseek(xFilial("SD2")+TSD2->D2_DOC+TSD2->D2_SERIE+TSD2->D2_CLIENTE+TSD2->D2_LOJA+TSD2->D2_COD+TSD2->D2_ITEM)
    		Reclock("SD2",.F.)
	   		SD2->D2_COMIS2 := MV_PAR04
	   		MSUNLOCK("SD2")
		EndIF
		TSD2->(DbSkip())
	ENDDO
	
	//FIM ATUALIZA ITEM SD2
	
	//ATUALIZA PEDIDO DE VENDA
	bAtuPed := .F. // verdadeiro se e para atualizar o pedido de venda da nota fiscal
	dbSelectArea("TSD2")
	dbgotop()	
	DO WHILE ! EOF() .and. bAtuPed
		   FechaAlias("TSC5")
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerySC5()),'TSC5',.T.,.T.)                                 
			dbSelectArea("TSC5")
			dbgotop()	
			DO WHILE ! EOF()
				INCPROC("Processando Tabela SC5 - Vendedor..." + Cvaltochar(mv_par03))
				Dbselectarea("SC5")
    			Dbsetorder(1)
    			If Dbseek(xFilial("SC5")+TSC5->C5_NUM)
   					Reclock("SC5",.F.)
					SC5->C5_COMIS2   := MV_PAR04
					SC5->C5_FLAGCOM  := "S"
					MSUNLOCK("SC5")
					bAtuPed := .f. // Pedido ja Atualizado
				Endif
				TSC5->(DbSkip ())
			ENDDO   
		TSD2->(DbSkip())
	ENDDO
	FechaAlias("TSC5")//Fecha se tiver aberta
	FechaAlias("TSD2") //Fecha se tiver aberta
	
	//FIM ATUALIZA PEDIDO DE VENDA   
	
	//Corrigir a Tabela SE1 Buscando na FI7
	
	FechaAlias("TFI7")
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryFI7()),'TFI7',.T.,.T.)
	dbSelectArea("TFI7")
	dbgotop()
	DO WHILE ! EOF()
		INCPROC("Processando Tabela SE1 - Vendedor..." + Cvaltochar(mv_par03))
		Dbselectarea("SE1")
    	Dbsetorder(1)
    	If Dbseek(xFilial("SE1")+TFI7->FI7_PRFDES+TFI7->FI7_NUMDES+TFI7->FI7_PARDES+TFI7->FI7_TIPDES) // CORRIGI O TITULO DESTINO DA FI7
    
       	Reclock("SE1",.F.)
	   		SE1->E1_COMIS2   := MV_PAR04
	   		MSUNLOCK("SE1")
	   		
	   		//TSE1->(DbSkip ())
		EndIf
		IF	Dbseek(xFilial("SE1")+TFI7->FI7_PRFORI+TFI7->FI7_NUMORI+TFI7->FI7_PARORI+TFI7->FI7_TIPORI) //CORRIGE O TITULO ORIGEM DA FI7
	   		
	   			Reclock("SE1",.F.)
	   			SE1->E1_COMIS2   := MV_PAR04
	   			MSUNLOCK("SE1")
	   		
	   	ENDIF
		TFI7->(DbSkip ())
	ENDDO
	//dbclosearea()//fecha FI7
		
	//Corrigir a Tabela SE3

	FechaAlias("TSE3")
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerySE3()),'TSE3',.T.,.T.)

	dbSelectArea("TSE3")
	dbgotop()
	DO WHILE ! EOF()
	
		INCPROC("Processando Tabela SE3 - Vendedor..." + Cvaltochar(mv_par03))
		Dbselectarea("SE3")
    	Dbsetorder(3)
    	If Dbseek(xFilial("SE3")+TSE3->E3_VEND+TSE3->E3_CODCLI+TSE3->E3_LOJA+TSE3->E3_PREFIXO+TSE3->E3_NUM+TSE3->E3_PARCELA)
    
       	Reclock("SE3",.F.)
	   		SE3->E3_PORC     := MV_PAR04
	   		SE3->E3_COMIS    := ROUND(((TSE3->E3_BASE*MV_PAR04)/100),2)
	   	   
	   		MSUNLOCK("SE3")
	
		EndIf
	   TSE3->(DbSkip())	
	ENDDO
	FechaAlias("TSE3")
	FechaAlias("TFI7")
	
	//FIM SE3*************************************************************
	dbSelectArea("TSF2")
	 TSF2->(DbSkip())			
ENDDO
//FechaAlias("TSF2")	

FINAL([Processo de Atualizacao de Porcentagem de Comissao.],[Finalizado])	
		
Return

	
	
		
	
	/*
	If Select("TSE1") > 0
		dbSelectArea("TSE1")
		dbCloseArea()
	EndIf
	cQuery := " SELECT * "
	cQuery += " FROM " + RetSQLName('SE1') + " SE1"
	cQuery += " WHERE SE1.D_E_L_E_T_ <> '*'"
	cQuery += " AND SE1.E1_EMISSAO  BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
	cQuery += " AND SE1.E1_VEND2 = '" + mv_par03 + "' "
	cQuery += " ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TSE1',.T.,.T.)

	dbSelectArea("TSE1")
	dbgotop()
	DO WHILE ! EOF()
		INCPROC("Processando Tabela SE1 - Vendedor..." + Cvaltochar(mv_par03))
		Dbselectarea("SE1")
    	Dbsetorder(1)
    	If Dbseek(xFilial("SE1")+TSE1->E1_PREFIXO+TSE1->E1_NUM+TSE1->E1_PARCELA)
    
       	Reclock("SE1",.F.)
	   		SE1->E1_COMIS2   := MV_PAR04
	   		MSUNLOCK("SE1")
	
	   		TSE1->(DbSkip ())
		EndIf
	ENDDO	
	//FIM ATUALIZA SE1
ENDDO



//Corrigir a Tabela SC5

If Select("TSC5") > 0
	dbSelectArea("TSC5")
	dbCloseArea()
EndIf

cQuery := " SELECT * "
cQuery += " FROM " + RetSQLName('SC5') + " SC5"
cQuery += " WHERE SC5.D_E_L_E_T_ <> '*'"
cQuery += " AND SC5.C5_EMISSAO  BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
cQuery += " AND SC5.C5_VEND2 = '" + mv_par03 + "' "
cQuery += " ORDER BY C5_FILIAL, C5_NUM "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TSC5',.T.,.T.)


dbSelectArea("TSC5")
dbgotop()
DO WHILE ! EOF()
	
	INCPROC("Processando Tabela SC5 - Vendedor..." + Cvaltochar(mv_par03))
    
    IF TSC5->C5_FLAGCOM = 'S' .and. cCont = 0  
        cCont := cCont +1
		If MsgYesNo(" Registro ja Calculado !! Deseja Continuar ? ","ATENÇÃO")	
	       MSGINFO("Calculo irá continuar!!!")
	    Else
	       MSGINFO("Calculo Finalizado !!!")
           Return
	    EndIf	
	EndIf		
    	
	Dbselectarea("SC5")
    Dbsetorder(1)
    If Dbseek(xFilial("SC5")+TSC5->C5_NUM)
    
	Reclock("SC5",.F.)
	SC5->C5_COMIS2   := MV_PAR04
	SC5->C5_FLAGCOM  := "S"
	MSUNLOCK("SC5")
	
	
	TSC5->(DbSkip ())
	Endif
ENDDO	


//Corrigir a Tabela SE1

If Select("TSE1") > 0
	dbSelectArea("TSE1")
	dbCloseArea()
EndIf

cQuery := " SELECT * "
cQuery += " FROM " + RetSQLName('SE1') + " SE1"
cQuery += " WHERE SE1.D_E_L_E_T_ <> '*'"
cQuery += " AND SE1.E1_EMISSAO  BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
cQuery += " AND SE1.E1_VEND2 = '" + mv_par03 + "' "
cQuery += " ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TSE1',.T.,.T.)

dbSelectArea("TSE1")
dbgotop()
DO WHILE ! EOF()
	
	INCPROC("Processando Tabela SE1 - Vendedor..." + Cvaltochar(mv_par03))
	
	Dbselectarea("SE1")
    Dbsetorder(1)
    If Dbseek(xFilial("SE1")+TSE1->E1_PREFIXO+TSE1->E1_NUM+TSE1->E1_PARCELA)
    
       Reclock("SE1",.F.)
	   SE1->E1_COMIS2   := MV_PAR04
	   MSUNLOCK("SE1")
	
	   TSE1->(DbSkip ())
	EndIf
ENDDO	

//Corrigir a Tabela SD2

If Select("TSD2") > 0
	dbSelectArea("TSD2")
	dbCloseArea()
EndIf

cQuery := " SELECT * "
cQuery += " FROM " + RetSQLName('SF2') + " SF2" 
cQuery += " INNER JOIN " + retsqlname("SD2")+ " SD2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE " 
cQuery += " WHERE SD2.D_E_L_E_T_ <> '*'"   
cQuery += " AND SF2.D_E_L_E_T_ <> '*'"   
cQuery += " AND SD2.D2_EMISSAO  BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
cQuery += " AND SF2.F2_VEND2 = '" + mv_par03 + "' "
cQuery += " ORDER BY D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TSD2',.T.,.T.)                                 

dbSelectArea("TSD2")
dbgotop()
DO WHILE ! EOF()
	
	INCPROC("Processando Tabela SD2 - Vendedor..." + Cvaltochar(mv_par03))
	
	Dbselectarea("SD2")
    Dbsetorder(3)
    If Dbseek(xFilial("SD2")+TSD2->D2_DOC+TSD2->D2_SERIE+TSD2->D2_CLIENTE+TSD2->D2_LOJA+TSD2->D2_COD+TSD2->D2_ITEM)
    
       Reclock("SD2",.F.)
	   SD2->D2_COMIS2 := MV_PAR04
	   MSUNLOCK("SD2")
	
	   TSD2->(DbSkip ())
	EndIF
ENDDO   


//Corrigir a Tabela SE3

If Select("TSE3") > 0
	dbSelectArea("TSE3")
	dbCloseArea()
EndIf

cQuery := " SELECT * "
cQuery += " FROM " + RetSQLName('SE3') + " SE3"
cQuery += " WHERE SE3.D_E_L_E_T_ <> '*'"
cQuery += " AND SE3.E3_EMISSAO  BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
cQuery += " AND SE3.E3_VEND = '" + mv_par03 + "' "
cQuery += " ORDER BY E3_FILIAL, E3_VEND, E3_CODCLI, E3_LOJA, E3_PREFIXO, E3_NUM, E3_PARCELA "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TSE3',.T.,.T.)

dbSelectArea("TSE3")
dbgotop()
DO WHILE ! EOF()
	
	INCPROC("Processando Tabela SE3 - Vendedor..." + Cvaltochar(mv_par03))
	
	Dbselectarea("SE3")
    Dbsetorder(3)
    If Dbseek(xFilial("SE3")+TSE3->E3_VEND+TSE3->E3_CODCLI+TSE3->E3_LOJA+TSE3->E3_PREFIXO+TSE3->E3_NUM+TSE3->E3_PARCELA)
    
       Reclock("SE3",.F.)
	   SE3->E3_PORC     := MV_PAR04
	   SE3->E3_COMIS    := ROUND(((TSE3->E3_BASE*MV_PAR04)/100),2)
	   	   
	   MSUNLOCK("SE3")
	
	   TSE3->(DbSkip ())
	EndIf
ENDDO	

FINAL([Processo de Atualizacao de Porcentagem de Comissao.],[Finalizado])	
		
Return

*/


//QUERY 
static function cQuerySF2()

cRet := " SELECT * "
cRet += " FROM " + RetSQLName('SF2') + " SF2"
cRet += " WHERE SF2.D_E_L_E_T_ <> '*'"
cRet += " AND SF2.F2_EMISSAO  BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
cRet += " AND SF2.F2_VEND2 = '" + mv_par03 + "' "
cRet += " ORDER BY F2_FILIAL, F2_DOC "

Return cRet

static function cQuerySD2()

cRet := " SELECT * "
cRet += " FROM " + RetSQLName('SD2') + " SD2" 
cRet += " WHERE SD2.D_E_L_E_T_ <> '*'"   
cRet += " AND SD2.D2_FILIAL = '"+TSF2->F2_FILIAL +"'" 
cRet += " AND SD2.D2_DOC = '"+TSF2->F2_DOC +"'" 
cRet += " AND SD2.D2_SERIE = '"+TSF2->F2_SERIE +"'" 
cRet += " AND SD2.D2_CLIENTE = '"+TSF2->F2_CLIENTE+"'" 
cRet += " AND SD2.D2_LOJA = '"+TSF2->F2_LOJA+"'" 
cRet += " AND SD2.D2_EMISSAO BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
cRet += " ORDER BY SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_ITEM "

Return cRet

static function cQuerySC5()

cRet := " SELECT * "
cRet += " FROM " + RetSQLName('SC5') + " SC5" 
cRet += " WHERE SC5.D_E_L_E_T_ <> '*'"   
cRet += " AND SC5.C5_NUM = '"+TSD2->D2_PEDIDO +"'" 
cRet += " AND SC5.C5_CLIENTE = '"+TSD2->D2_CLIENTE+"'" 
cRet += " AND SC5.C5_LOJACLI = '"+TSD2->D2_LOJA+"'" 
cRet += " AND SC5.C5_VEND2 = '" + mv_par03 + "' "
cRet += " ORDER BY SC5.C5_FILIAL, SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_LOJACLI , SC5.C5_VEND2"

Return cRet

static function cQueryFI7()

cRet := " SELECT * "
cRet += " FROM " + RetSQLName('FI7') + " FI7"
cRet += " WHERE FI7.D_E_L_E_T_ <> '*'"
cRet += " AND FI7.FI7_NUMORI = '"+TSF2->F2_DOC +"'" 
cRet += " AND FI7.FI7_TIPORI = 'NF'"
cRet += " AND FI7.FI7_CLIORI = '"+TSF2->F2_CLIENTE+"'"
cRet += " AND FI7.FI7_LOJORI = '"+TSF2->F2_LOJA+"'"
cRet += " ORDER BY FI7_FILIAL, FI7_NUMORI,FI7_PARORI"
	
Return cRet


static function cQuerySE3()

cRet := " SELECT * "
cRet += " FROM " + RetSQLName('SE3') + " SE3"
cRet += " WHERE SE3.D_E_L_E_T_ <> '*'"
cRet += " AND SE3.E3_NUM = '"+FI7->FI7_NUMDES+"'"
cRet += " AND SE3.E3_CODCLI = '"+FI7->FI7_CLIDES+"'"
cRet += " AND SE3.E3_LOJA = '"+FI7->FI7_LOJDES+"'"
cRet += " AND SE3.E3_EMISSAO  BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
cRet += " AND SE3.E3_VEND = '" + mv_par03 + "' "
cRet += " ORDER BY E3_FILIAL, E3_VEND, E3_CODCLI, E3_LOJA, E3_PREFIXO, E3_NUM, E3_PARCELA "

Return cRet

//Funçao para finalizar o Alias Aberto 
Static Function FechaAlias(_cALias)
	If Select(_cALias) > 0
		dbSelectArea(_cALias)
		dbCloseArea()
	EndIf
Return


*****************************************************
Static Function fValidPerg()
*****************************************************

local _ni

cPerg := PADR(cPerg,10)

_agrpsx1:={}

aadd(_agrpsx1,{cperg,"01","Periodo De         ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),""})
aadd(_agrpsx1,{cperg,"02","Periodo Ate        ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),""})
aadd(_agrpsx1,{cperg,"03","Do Vendedor2       ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"04","Porcentagem %      ?","mv_ch4","N",14,2,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

for _ni:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_ni,1]+_agrpsx1[_ni,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_ni,01]
		sx1->x1_ordem  :=_agrpsx1[_ni,02]
		sx1->x1_pergunt:=_agrpsx1[_ni,03]
		sx1->x1_variavl:=_agrpsx1[_ni,04]
		sx1->x1_tipo   :=_agrpsx1[_ni,05]
		sx1->x1_tamanho:=_agrpsx1[_ni,06]
		sx1->x1_decimal:=_agrpsx1[_ni,07]
		sx1->x1_presel :=_agrpsx1[_ni,08]
		sx1->x1_gsc    :=_agrpsx1[_ni,09]
		sx1->x1_valid  :=_agrpsx1[_ni,10]
		sx1->x1_var01  :=_agrpsx1[_ni,11]
		sx1->x1_def01  :=_agrpsx1[_ni,12]
		sx1->x1_cnt01  :=_agrpsx1[_ni,13]
		sx1->x1_var02  :=_agrpsx1[_ni,14]
		sx1->x1_def02  :=_agrpsx1[_ni,15]
		sx1->x1_cnt02  :=_agrpsx1[_ni,16]
		sx1->x1_var03  :=_agrpsx1[_ni,17]
		sx1->x1_def03  :=_agrpsx1[_ni,18]
		sx1->x1_cnt03  :=_agrpsx1[_ni,19]
		sx1->x1_var04  :=_agrpsx1[_ni,20]
		sx1->x1_def04  :=_agrpsx1[_ni,21]
		sx1->x1_cnt04  :=_agrpsx1[_ni,22]
		sx1->x1_var05  :=_agrpsx1[_ni,23]
		sx1->x1_def05  :=_agrpsx1[_ni,24]
		sx1->x1_cnt05  :=_agrpsx1[_ni,25]
		sx1->x1_f3     :=_agrpsx1[_ni,26]
		sx1->(msunlock())
	endif
next
//return()

Return

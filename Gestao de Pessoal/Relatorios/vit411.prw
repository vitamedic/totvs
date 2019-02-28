#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

// ****************************************************************************************************
// | Programa  | VIT411   |  Autor |  Roberto Fiuza      |  Data |   04/11/14  |                      |
// |**************************************************************************************************|
// | Descricao |  Indicadores de horas - Absente�smo                                                  |
// |           |                                                                                      |
// |**************************************************************************************************|
// | Uso       | Fiuza's Informatica x                                                                |
// ****************************************************************************************************

User Function VIT411


Private cPerg     := PADR("VIT411A",Len(SX1->X1_GRUPO))
Private aDetalhe  := {}
Private wyDet     := 0
Private wArqTemp  := ""
Private wIndTemp  := ""
Private aAfastmto := {}
Private aQtMat    := {}
Private aCCQtMat  := {}


ValidPerg()
pergunte(cPerg,.F.)    // sem tela de pergunta

oReport := ReportDef() // Chama a funcao personalizado onde deve buscar as informacoes

oReport:PrintDialog()  // Cria a tela de parametros no modo personalizado apos buscar as informacoes

tmp4->(dbclosearea())
ferase(wArqTemp+getdbextension())
ferase(wIndTemp)



Return


// ****************************************************************************************************
// | Funcao    | ReportDef   |  Autor |  Roberto Fiuza      |  Data |   04/11/14  |                   |
// |**************************************************************************************************|
// | Descricao |  Funcao para o cabecalho                                                             |
// |           |                                                                                      |
// |**************************************************************************************************|
// | Uso       | Fiuza's Informatica                                                                  |
// ****************************************************************************************************


Static Function ReportDef() //Cria o Cabecalho em excel

Local oReport, oSection, oBreak

cTitulo := "Indicadores de horas"

// Parametros do TReport
// 1-Arquivo para impressao em disco
// 2-Texto cabecalho da tela
// 3-Nome Grupo SX1 para os parametros
// 4-Funcao para impressao
// 5-Texto Rodape da tela


oReport  := TReport():New("VIT411",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem
oSection := TRSection():New(oReport,"Indicadores de horas",{""})

TRCell():New(oSection, "CEL01_AAMM"      , "SRC", "MATRICULA"          ,""                           ,50,,,"LEFT")
TRCell():New(oSection, "CEL02_CC"        , "CTT", "CC"                 ,"@!"                         ,15                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_DESCC"     , "CTT", "CC DESCRICAO"       ,PesqPict("CTT","CTT_DESC01" ),TamSX3("CTT_DESC01")[1] , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_TURNO"     , "   ", "TURNO"              ,"@!"                         ,15                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_DESTU"     , "   ", "DESCRICAO TURNO"    ,"@!"                         ,50                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_QTDFU"     , "SRV", "QTD FUNC"           ,"@E 999,999"                 ,10                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_PREVI"     , "SRC", "PREVISTAS"          ,"@E 999,999,999"             ,20                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_FALTA"     , "SRC", "FALTAS INTEGRAIS"   ,"@E 999,999,999"             ,20                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_ATRAS"     , "SRC", "ATRASO S/ANTECIP."  ,"@E 999,999,999"             ,20                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_ATEST"     , "SRC", "ATESTADO"           ,"@E 999,999,999"             ,20                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_AFAST"     , "SRV", "AFASTAMENTO"        ,"@E 999,999,999"             ,20                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL12_TRABA"     , "SRV", "TRABALHADAS"        ,"@E 999,999,999"             ,20                      , /*lPixel*/, /* Formula*/)


Return oReport


// ****************************************************************************************************
// | Funcao    | PrintReport |  Autor |  Roberto Fiuza      |  Data |   04/11/14  |                   |
// |**************************************************************************************************|
// | Descricao |  A funcao estatica PrintReport realiza a impressao do relatorio                      |
// |           |                                                                                      |
// |**************************************************************************************************|
// | Uso       | Fiuza's Informatica                                                                  |
// ****************************************************************************************************


Static Function PrintReport(oReport)

Local oSection    := oReport:Section(1)

Private aDados[12]
Private wQtdFunc  := 0
Private nCount    := 0


oSection:Cell("CEL01_AAMM"  ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_CC"    ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_DESCC" ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_TURNO" ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_DESTU" ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_QTDFU" ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_PREVI" ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_FALTA" ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_ATRAS" ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_ATEST" ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_AFAST" ):SetBlock( { || aDados[11]})
oSection:Cell("CEL12_TRABA" ):SetBlock( { || aDados[12]})

// PARA TOTALIZAR PELO objeto
oBreak := TRBreak():New(oSection,oSection:Cell("CEL02_CC"),"Sub Total CC")  // imprime total do CC cada quebra do CC

TRFunction():New(oSection:Cell("CEL06_QTDFU" ),NIL,"SUM"  ,oBreak)
TRFunction():New(oSection:Cell("CEL07_PREVI" ),NIL,"SUM"  ,oBreak)
TRFunction():New(oSection:Cell("CEL08_FALTA" ),NIL,"SUM"  ,oBreak)
TRFunction():New(oSection:Cell("CEL09_ATRAS" ),NIL,"SUM"  ,oBreak)
TRFunction():New(oSection:Cell("CEL10_ATEST" ),NIL,"SUM"  ,oBreak)
TRFunction():New(oSection:Cell("CEL11_AFAST" ),NIL,"SUM"  ,oBreak)
TRFunction():New(oSection:Cell("CEL12_TRABA" ),NIL,"SUM"  ,oBreak)



//oBreak:SetPageBreak(.T.) // Define se salta a página na quebra de seção // Se verdadeiro, aponta que salta página na quebra de seção


oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()


aFill(aDados,nil)

IncProc("Selecionando dados....")

fMatriculas()

DbSelectArea("TMP4")
DbGotop()
Do While ! eof()
	fHorasPrev() //  Horas prevista
	If oReport:Cancel()
		Exit
	EndIf
	DbSelectArea("TMP4")
	skip
Enddo

fFaltas()    //  Faltas
fAtraos()    //  Atrasos
fAtestado()  //  Atestado
fAfastmto()  //  Afastamento

aFill(aDados,nil)

IF mv_par09 = 1 // Analitico
	aDetalhe := aSort(aDetalhe,,,{|x,y| x[3] < y[3] } )
ELSE
	aDetalhe := aSort(aDetalhe,,,{|x,y| x[1] < y[1] } )
ENDIF

For wyDet := 1 to Len(	aDetalhe )
	
	IncProc("Centro de custo " + aDetalhe[wyDet][3] )
	nCount++
	oReport:IncMeter(nCount)
	
	IF mv_par09 = 1 // Analitico
		dbselectarea("SRA")
		dbsetorder(1)
		dbSeek( xFilial("SRA") + aDetalhe[wyDet][2] )
		wMatricula :=  aDetalhe[wyDet][2] + "-" + SRA->RA_NOME
	ELSE
		wMatricula := " "
		wyDety := aScan(aCCQtMat, {|x| x[1] == aDetalhe[wyDet][3] + aDetalhe[wyDet][4]  })
		if wyDety = 0
			aDados[06] := 0
		else
			aDados[06] := aCCQtMat[wyDety][2]
		endif
	ENDIF
	
	dbselectarea("CTT")
	dbsetorder(1)
	dbSeek( xFilial("CTT") + aDetalhe[wyDet][3] )
	
	dbselectarea("SR6")    // Cadastro de turno
	dbsetorder(1) // PJ_FILIAL + PJ_TURNO  + PJ_SEMANA + PJ_DIA
	dbSeek( xFilial("SR6") + aDetalhe[wyDet][4]  )
	
	
	
	
	aDados[01] := wMatricula
	aDados[02] := aDetalhe[wyDet][3]
	aDados[03] := CTT->CTT_DESC01
	aDados[04] := aDetalhe[wyDet][4]
	aDados[05] := SR6->R6_DESC
	aDados[07] := aDetalhe[wyDet][5]
	aDados[08] := aDetalhe[wyDet][6]
	aDados[09] := aDetalhe[wyDet][7]
	aDados[10] := aDetalhe[wyDet][8]
	aDados[11] := aDetalhe[wyDet][9]
	aDados[12] := aDetalhe[wyDet][5] - ( aDetalhe[wyDet][6] + aDetalhe[wyDet][7] + aDetalhe[wyDet][8] + aDetalhe[wyDet][9] )
	
	
	oSection:PrintLine()  // Imprime linha de detalhe
	aFill(aDados,nil)     // Limpa o array a dados
	
Next

oSection:Finish()


Return

//FIM FUNCOES PARA IMPRESSAO - EXCEL




// ****************************************************************************************************
// | Funcao    | fMatriculas |  Autor |  Roberto Fiuza      |  Data |   04/11/14  |                   |
// |**************************************************************************************************|
// | Descricao |  A funcao para selecionar as matriculas                                              |
// |           |                                                                                      |
// |**************************************************************************************************|
// | Uso       | Fiuza's Informatica                                                                  |
// ****************************************************************************************************

Static Function fMatriculas()

Local _cQry      := ""
Local wTurno     := ""
Local wDiaSemana := 0
Local wHoAfasmto := 0

If Select("TPSPG") > 0
	TPSPG->(dbCloseArea())
EndIf

_cQry := " SELECT PG_MAT,PG_DATAAPO,PG_CC,PG_TURNO,SUM(PG_HORA) PG_HORA "
_cQry += " FROM " + RetSqlName("SPG")
_cQry += " WHERE D_E_L_E_T_ = ' '"
_cQry += " AND PG_FILIAL  BETWEEN '" + mv_par01       + "' AND '" + mv_par02       + "'"
_cQry += " AND PG_CC      BETWEEN '" + mv_par03       + "' AND '" + mv_par04       + "'"
_cQry += " AND PG_MAT     BETWEEN '" + mv_par05       + "' AND '" + mv_par06       + "'"
_cQry += " AND PG_DATAAPO BETWEEN '" + DTOS(mv_par07) + "' AND '" + DTOS(mv_par08) + "'"
_cQry += " group by PG_MAT,PG_DATAAPO,PG_CC,PG_TURNO "
_cQry += " order by PG_MAT,PG_DATAAPO,PG_CC,PG_TURNO "
_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TPSPG"

wArqTemp:=criatrab(,.f.)
copy to &wArqTemp
TPSPG->(dbclosearea())

dbusearea(.t.,,wArqTemp,"TMP4",.f.,.f.)
wIndTemp:=criatrab(,.f.)
_cchave  :="PG_MAT+PG_DATAAPO"
tmp4->(indregua("TMP4",wIndTemp,_cchave,,,"Selecionando registros..."))

// *************************************************************************************

If Select("TPSR8") > 0
	TPSR8->(dbCloseArea())
EndIf
_cQry := " SELECT R8_MAT,R8_DATAINI,R8_DATAFIM,R8_TIPO "
_cQry += " FROM " + RetSqlName("SR8")
_cQry += " WHERE D_E_L_E_T_ = ' '"
_cQry += " AND R8_FILIAL  BETWEEN '" + mv_par01       + "' AND '" + mv_par02       + "'"
_cQry += " AND R8_MAT     BETWEEN '" + mv_par05       + "' AND '" + mv_par06       + "'"
_cQry += " AND R8_DATAINI BETWEEN '" + DTOS(mv_par07) + "' AND '" + DTOS(mv_par08) + "'"
_cQry += " AND R8_TIPO <> '1' "
_cQry += " order by R8_MAT,R8_DATAINI "
_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TPSR8"

tcsetfield("TPSR8","R8_DATAINI","D")
tcsetfield("TPSR8","R8_DATAFIM","D")

DbSelectArea("TPSR8")
DbGotop()
Do While ! eof()
	dbselectarea("SRA")
	dbsetorder(1)
	dbSeek( xFilial("SRA") + TPSR8->R8_MAT )
	
	IF SRA->RA_CC < mv_par03 .or. SRA->RA_CC > mv_par04
		DbSelectArea("TPSR8")
		SKIP
		LOOP
	ENDIF
	
	IF TPSR8->R8_DATAINI >= mv_par07
		wDtIni := TPSR8->R8_DATAINI
	ELSE
		wDtIni := mv_par07
	ENDIF
	
	IF TPSR8->R8_DATAFIM >= mv_par08
		wDtFim := mv_par08
	ELSE
		wDtFim := TPSR8->R8_DATAFIM 
	ENDIF
	
	Do While ! eof() .and.  wDtIni <= wDtFim      
		DbSelectArea("TMP4")
		dbSeek( xFilial("SRA") + TPSR8->R8_MAT + dtos(wDtIni)  )
		if eof()
			reclock("TMP4",.t.)
			TMP4->PG_MAT      := TPSR8->R8_MAT
			TMP4->PG_DATAAPO  := dtos(wDtIni)
			TMP4->PG_CC       := SRA->RA_CC
			TMP4->PG_TURNO    := SRA->RA_TNOTRAB
			msunlock()
		endif
		
		if TPSR8->R8_TIPO <> "Q"  // se nao for Licen�a Maternidade
			
			DbSelectArea("SPF")
			DbSetOrder(1) //PF_FILIAL+PF_MAT+DTOS(PF_DATA)
			dbSeek( xFilial("SPF") + TMP4->PG_MAT + TMP4->PG_DATAAPO , .T. )
			IF SPF->PF_MAT = TMP4->PG_MAT
				IF SPF->PF_DATA > stod(TMP4->PG_DATAAPO)
					wTurno := SPF->PF_TURNODE
				ELSE
					wTurno := SPF->PF_TURNOPA
				ENDIF
			ELSE
				wTurno := TMP4->PG_TURNO
			ENDIF
			
			wDiaSemana := dow( stod(TMP4->PG_DATAAPO) )
			
			dbselectarea("SPJ")    // Horario Padrao
			dbsetorder(1) // PJ_FILIAL + PJ_TURNO  + PJ_SEMANA + PJ_DIA
			dbSeek( xFilial("SPJ") + wTurno + "01" + str(wDiaSemana,1,0) )
			
			
			wHoAfasmto := (PJ_HRTOTAL - PJ_HRSINT1)
			
			IF mv_par09 = 1 // Analitico
				wyDet := aScan(aAfastmto, {|x| x[1] == TMP4->PG_MAT })
				if wyDet = 0
					AADD(aAfastmto,{ TMP4->PG_MAT , TMP4->PG_CC , wHoAfasmto } )
				else
					aAfastmto[wyDet][3] := aAfastmto[wyDet][3] +  wHoAfasmto
				endif
			ELSE
				wyDet := aScan(aAfastmto, {|x| x[2] == TMP4->PG_CC })
				if wyDet = 0
					AADD(aAfastmto,{ " " , TMP4->PG_CC , wHoAfasmto } )
				else
					aAfastmto[wyDet][3] := aAfastmto[wyDet][3] +  wHoAfasmto
				endif
			ENDIF
		endif
		
		wDtIni := wDtIni + 1
	Enddo
	
	DbSelectArea("TPSR8")
	Skip
Enddo

Return .t.

// ****************************************************************************************************
// | Funcao    | fHorasPrev |  Autor |  Roberto Fiuza      |  Data |   04/11/14  |                    |
// |**************************************************************************************************|
// | Descricao |  A funcao para Horas Prevista                                                        |
// |           |                                                                                      |
// |**************************************************************************************************|
// | Uso       | Fiuza's Informatica                                                                  |
// ****************************************************************************************************

Static Function fHorasPrev()

Local wTurno     := 0
Local wDiaSemana := 0

DbSelectArea("SPF")
DbSetOrder(1) //PF_FILIAL+PF_MAT+DTOS(PF_DATA)
dbSeek( xFilial("SPF") + TMP4->PG_MAT + TMP4->PG_DATAAPO , .T. )
IF SPF->PF_MAT = TMP4->PG_MAT
	IF SPF->PF_DATA > StoD(TMP4->PG_DATAAPO)
		wTurno := SPF->PF_TURNODE
	ELSE
		wTurno := SPF->PF_TURNOPA
	ENDIF
ELSE
	wTurno := TMP4->PG_TURNO
ENDIF

wDiaSemana := dow( stod(TMP4->PG_DATAAPO) )

dbselectarea("SPJ")    // Horario Padrao
dbsetorder(1) // PJ_FILIAL + PJ_TURNO  + PJ_SEMANA + PJ_DIA
dbSeek( xFilial("SPJ") + wTurno + "01" + str(wDiaSemana,1,0) )


wHPrevistas := (PJ_HRTOTAL - PJ_HRSINT1)  // 05
wFaIntegral := 0  //06
wAtrasoSaid := 0  //07
wHrAtestado := 0  //08
wAfastameto := 0  //09
wTrabalhada := 0  //10


IF mv_par09 = 1 // Analitico
	wyDet := aScan(aDetalhe, {|x| x[1] == TMP4->PG_MAT + TMP4->PG_CC + wTurno })
	if wyDet = 0
		AADD(aDetalhe,{ TMP4->PG_MAT + TMP4->PG_CC + wTurno , TMP4->PG_MAT , TMP4->PG_CC , wTurno , wHPrevistas , wFaIntegral , wAtrasoSaid , wHrAtestado , wAfastameto ,wTrabalhada  } )
	else
		aDetalhe[wyDet][5] := aDetalhe[wyDet][5] +  wHPrevistas
	endif
ELSE
	
	wyDet := aScan(aDetalhe, {|x| x[1] == TMP4->PG_CC + wTurno })
	
	if wyDet = 0
		AADD(aDetalhe,{ TMP4->PG_CC + wTurno                ,  " "         , TMP4->PG_CC , wTurno , wHPrevistas , wFaIntegral , wAtrasoSaid , wHrAtestado , wAfastameto ,wTrabalhada  } )
	else
		aDetalhe[wyDet][5] := aDetalhe[wyDet][5] +  wHPrevistas
	endif
	
	
	wyDet := aScan(aQtMat, {|x| x[1] == TMP4->PG_CC + TMP4->PG_MAT + wTurno })
	if wyDet = 0
		AADD(aQtMat,   { TMP4->PG_CC + TMP4->PG_MAT + wTurno , TMP4->PG_MAT } )
		wyDety := aScan(aCCQtMat, {|x| x[1] == TMP4->PG_CC + wTurno  })
		if wyDety = 0
			AADD(aCCQtMat, { TMP4->PG_CC + wTurno  , 1 } )
		else
			aCCQtMat[wyDety][2] := aCCQtMat[wyDety][2] + 1
		endif
	endif
	
	
ENDIF

Return .t.

// ****************************************************************************************************
// | Funcao    | fFaltas     |  Autor |  Roberto Fiuza      |  Data |   04/11/14  |                   |
// |**************************************************************************************************|
// | Descricao |  A funcao para selecionar as HORAS FALTAS                                            |
// |           |                                                                                      |
// |**************************************************************************************************|
// | Uso       | Fiuza's Informatica                                                                  |
// ****************************************************************************************************
Static Function fFaltas()

Local _cQry   := ""

If Select("QSPH") > 0
	QSPH->(dbCloseArea())
EndIf

// SPH - Historico de Apontamentos

IF mv_par09 = 1 // Analitico
	_cQry := " SELECT PH_MAT,SUM(PH_QUANTC) AS QTDHORAS  "
ELSE
	_cQry := " SELECT PH_CC, SUM(PH_QUANTC) AS QTDHORAS  "
ENDIF
_cQry += " FROM " + RetSqlName("SPH")
_cQry += " WHERE D_E_L_E_T_ = ' '"
_cQry += " AND PH_FILIAL    = '" + XFILIAL("SPH")  + "' "
_cQry += " AND PH_DATA BETWEEN '" + DTOS(mv_par07) + "' AND '" + DTOS(mv_par08) + "'"
_cQry += " AND PH_PD IN ('008') "
_cQry += " AND PH_ABONO = ' ' "
IF mv_par09 = 1 // Analitico
	_cQry += " group by PH_MAT "
ELSE
	_cQry += " group by PH_CC "
ENDIF
_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "QSPH"

dbselectarea("QSPH")
DBGOTOP()
Do While ! eof()
	
	wHPrevistas := 0  //05
	wFaIntegral := QTDHORAS  //06
	wAtrasoSaid := 0  //07
	wHrAtestado := 0  //08
	wAfastameto := 0  //09
	wTrabalhada := 0  //10
	
	IF mv_par09 = 1 // Analitico
		wyDet := aScan(aDetalhe, {|x| x[2] == QSPH->PH_MAT })
		if wyDet > 0
			aDetalhe[wyDet][6] := aDetalhe[wyDet][6] +  wFaIntegral
		endif
	ELSE
		wyDet := aScan(aDetalhe, {|x| x[3] == QSPH->PH_CC  })
		if wyDet > 0
			aDetalhe[wyDet][6] := aDetalhe[wyDet][6] +  wFaIntegral
		endif
	ENDIF
	dbselectarea("QSPH")
	skip
enddo

Return .t.

// ****************************************************************************************************
// | Funcao    | fAtraos     |  Autor |  Roberto Fiuza      |  Data |   04/11/14  |                   |
// |**************************************************************************************************|
// | Descricao |  A funcao para selecionar as HORAS ATRASOS/SAIDAS ANTECIPADAS                        |
// |           |                                                                                      |
// |**************************************************************************************************|
// | Uso       | Fiuza's Informatica                                                                  |
// ****************************************************************************************************
Static Function fAtraos()

Local _cQry   := ""

If Select("QSPH") > 0
	QSPH->(dbCloseArea())
EndIf

// SPH - Historico de Apontamentos

IF mv_par09 = 1 // Analitico
	_cQry := " SELECT PH_MAT,SUM(PH_QUANTC) AS QTDHORAS  "
ELSE
	_cQry := " SELECT PH_CC, SUM(PH_QUANTC) AS QTDHORAS  "
ENDIF
_cQry += " FROM " + RetSqlName("SPH")
_cQry += " WHERE D_E_L_E_T_ = ' '"
_cQry += " AND PH_FILIAL    = '" + XFILIAL("SPH")  + "' "
_cQry += " AND PH_DATA BETWEEN '" + DTOS(mv_par07) + "' AND '" + DTOS(mv_par08) + "'"
_cQry += " AND PH_PD IN ('006','010','012','018') "
_cQry += " AND PH_ABONO = ' ' "
IF mv_par09 = 1 // Analitico
	_cQry += " group by PH_MAT "
ELSE
	_cQry += " group by PH_CC "
ENDIF
_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "QSPH"

dbselectarea("QSPH")
DBGOTOP()
Do While ! eof()
	
	wHPrevistas := 0  //05
	wFaIntegral := 0  //06
	wAtrasoSaid := QTDHORAS  //07
	wHrAtestado := 0  //08
	wAfastameto := 0  //09
	wTrabalhada := 0  //10
	
	IF mv_par09 = 1 // Analitico
		wyDet := aScan(aDetalhe, {|x| x[2] == QSPH->PH_MAT })
		if wyDet > 0
			aDetalhe[wyDet][7] := aDetalhe[wyDet][7] +  wAtrasoSaid
		endif
	ELSE
		wyDet := aScan(aDetalhe, {|x| x[3] == QSPH->PH_CC  })
		if wyDet > 0
			aDetalhe[wyDet][7] := aDetalhe[wyDet][7] +  wAtrasoSaid
		endif
	ENDIF
	dbselectarea("QSPH")
	skip
enddo

Return .t.

// ****************************************************************************************************
// | Funcao    | fAtestado     |  Autor |  Roberto Fiuza      |  Data |   04/11/14  |                 |
// |**************************************************************************************************|
// | Descricao |  A funcao para selecionar as HORAS ATESTADO                                          |
// |           |                                                                                      |
// |**************************************************************************************************|
// | Uso       | Fiuza's Informatica                                                                  |
// ****************************************************************************************************
Static Function fAtestado()

Local _cQry   := ""

If Select("QSPH") > 0
	QSPH->(dbCloseArea())
EndIf

// SPH - Historico de Apontamentos

IF mv_par09 = 1 // Analitico
	_cQry := " SELECT PH_MAT,SUM(PH_QUANTC) AS QTDHORAS  "
ELSE
	_cQry := " SELECT PH_CC, SUM(PH_QUANTC) AS QTDHORAS  "
ENDIF
_cQry += " FROM " + RetSqlName("SPH")
_cQry += " WHERE D_E_L_E_T_ = ' '"
_cQry += " AND PH_FILIAL    = '" + XFILIAL("SPH")  + "' "
_cQry += " AND PH_DATA BETWEEN '" + DTOS(mv_par07) + "' AND '" + DTOS(mv_par08) + "'"
_cQry += " AND PH_PD    IN ('006','010','012','018','008') "
_cQry += " AND PH_ABONO IN ('007','058') "
IF mv_par09 = 1 // Analitico
	_cQry += " group by PH_MAT "
ELSE
	_cQry += " group by PH_CC "
ENDIF
_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "QSPH"

dbselectarea("QSPH")
DBGOTOP()
Do While ! eof()
	
	wHPrevistas := 0  //05
	wFaIntegral := 0  //06
	wAtrasoSaid := 0  //07
	wHrAtestado := QTDHORAS  //08
	wAfastameto := 0  //09
	wTrabalhada := 0  //10
	
	IF mv_par09 = 1 // Analitico
		wyDet := aScan(aDetalhe, {|x| x[2] == QSPH->PH_MAT })
		if wyDet > 0
			aDetalhe[wyDet][8] := aDetalhe[wyDet][8] +  wHrAtestado
		endif
	ELSE
		wyDet := aScan(aDetalhe, {|x| x[3] == QSPH->PH_CC  })
		if wyDet > 0
			aDetalhe[wyDet][8] := aDetalhe[wyDet][8] +  wHrAtestado
		endif
	ENDIF
	dbselectarea("QSPH")
	skip
enddo

Return .t.

// ****************************************************************************************************
// | Funcao    | fAfastmto     |  Autor |  Roberto Fiuza      |  Data |   04/11/14  |                 |
// |**************************************************************************************************|
// | Descricao |  A funcao para selecionar os dias de afastamento                                     |
// |           |                                                                                      |
// |**************************************************************************************************|
// | Uso       | Fiuza's Informatica                                                                  |
// ****************************************************************************************************
Static Function fAfastmto()

Local wxAfast := 0

For wxAfast := 1 to len(aAfastmto)
	
	wHPrevistas := 0  //05
	wFaIntegral := 0  //06
	wAtrasoSaid := 0  //07
	wHrAtestado := 0  //08
	wAfastameto := aAfastmto[wxAfast][3]  //09
	wTrabalhada := 0  //10
	
	IF mv_par09 = 1 // Analitico
		wyDet := aScan(aDetalhe, {|x| x[2] == aAfastmto[wxAfast][1] })
		if wyDet > 0
			aDetalhe[wyDet][9] := aDetalhe[wyDet][9] +  wAfastameto
		endif
	ELSE
		wyDet := aScan(aDetalhe, {|x| x[3] == aAfastmto[wxAfast][2]  })
		if wyDet > 0
			aDetalhe[wyDet][9] := aDetalhe[wyDet][9] +  wAfastameto
		endif
	ENDIF
	
Next

Return .t.



// ****************************************************************************************************
// | Funcao    | ValidPerg |  Autor |  Roberto Fiuza      |  Data |   04/11/14  |                     |
// |**************************************************************************************************|
// | Descricao |  A funcao para criacao das perguntas                                                 |
// |           |                                                                                      |
// |**************************************************************************************************|
// | Uso       | Fiuza's Informatica                                                                  |
// ****************************************************************************************************
Static Function ValidPerg
Local aArea    := GetArea()
Local aRegs    := {}
Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}
Local i	       := 0
Local j        := 0


aAdd(aRegs,{cPerg,"01","Filial De     ?","","","mv_ch1","C",02,0,0,"G","","mv_par01",""	,"","","","","","","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"02","Filial Ate    ?","","","mv_ch2","C",02,0,0,"G","","mv_par02",""	,"","","","","","","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"03","CC De         ?","","","mv_ch3","C",09,0,0,"G","","mv_par03",""	,"","","","","","","","","","","","","","","","","","","","","","","","CTT"})
aAdd(aRegs,{cPerg,"04","CC Ate        ?","","","mv_ch4","C",09,0,0,"G","","mv_par04",""	,"","","","","","","","","","","","","","","","","","","","","","","","CTT"})
aAdd(aRegs,{cPerg,"05","Matricula De  ?","","","mv_ch5","C",06,0,0,"G","","mv_par05",""	,"","","","","","","","","","","","","","","","","","","","","","","","SRA"})
aAdd(aRegs,{cPerg,"06","Matricula Ate ?","","","mv_ch6","C",06,0,0,"G","","mv_par06",""	,"","","","","","","","","","","","","","","","","","","","","","","","SRA"})
aAdd(aRegs,{cPerg,"07","Periodo De    ?","","","mv_ch7","D",08,0,0,"G","","mv_par07",""	,"","","","","","","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"08","Periodo Ate   ?","","","mv_ch8","D",08,0,0,"G","","mv_par08",""	,"","","","","","","","","","","","","","","","","","","","","","","","   "})
aadd(aRegs,{cperg,"09","Tipo          ?","","","mv_ch9","N",01,0,0,"C","","mv_par09","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
dbSetOrder(1)
For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
		
		aHelpPor := {} ; aHelpSpa := {} ; 	aHelpEng := {}
		If i==1
			AADD(aHelpPor,"Informe a filial inicial.          ")
		ElseIf i==2
			AADD(aHelpPor,"Informe a filial final.            ")
		ElseIf i==3
			AADD(aHelpPor,"Informe o centro de custo inicial. ")
		ElseIf i==4
			AADD(aHelpPor,"Informe o centro de custo final.   ")
		ElseIf i==5
			AADD(aHelpPor,"Matricula inicial.                 ")
		ElseIf i==6
			AADD(aHelpPor,"Matricula final.                   ")
		ElseIf i==7
			AADD(aHelpPor,"Periodo Inicial.                   ")
		ElseIf i==8
			AADD(aHelpPor,"Periodo final.                     ")
		ElseIf i==9
			AADD(aHelpPor,"Tipo Analitico ou Sintetico.       ")
		EndIf
		
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return

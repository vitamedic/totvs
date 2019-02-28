/********************************************************************************
Autor: Leandro Data: 06/11/15 
Lista de preços Stand
********************************************************************************/
#include 'protheus.ch'
#include 'topconn.ch'

User Function  vit429() //U_vit429()
    Local oReport := nil
    Local cPerg:= Padr("vit429",10)
    
      //Incluo/Altero as perguntas na tabela SX1
    AjustaSX1(cPerg)    
    //gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
   Pergunte(cPerg,.F.)              
        
   oReport := RptDef(cPerg)
    oReport:PrintDialog()
Return

Static Function RptDef(cNome)
    Local oReport := Nil
    Local oSection1:= Nil
    Local oSection2:= Nil
    Local oBreak
    Local oFunction
    
    oReport := TReport():New(cNome,"Preços Stand",cNome,{|oReport| ReportPrint(oReport)},"Preços Stand")
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.F.)
   //U_vit429()
    oSection1:= TRSection():New(oReport, "Compras", {"TEMP"}, , .F., .T.)
    TRCell():New( oSection1,"CODIGO"   	 ,"TEMP","CODIGO"         ,"@!",07,,,"right",,)
	TRCell():New( oSection1,"D1_TES"     ,"TEMP","TES"            ,"@!",03,,,"left",,)
	TRCell():New( oSection1,"F4_PISCOF"  ,"TEMP","PISCOF"         ,"@!",10,,,"left",,)
	TRCell():New( oSection1,"VLRPIS"     ,"TEMP","VL.PIS"         ,"@E 999,999.999999" ,15,,,"right",,)
	TRCell():New( oSection1,"VLRCOFINS"  ,"TEMP","VL.COFINS"      ,"@E 999,999.999999" ,15,,,"right",,)
	TRCell():New( oSection1,"D1_QUANT"   ,"TEMP","QUANT."  	      ,"@E 99,999,999.99" ,18,,,"right",,)
	TRCell():New( oSection1,"D1_VALIPI"  ,"TEMP","VL.IPI"         ,"@E 999,999.99" ,10,,,"right",,)
	TRCell():New( oSection1,"D1_VALICM"  ,"TEMP","VL.ICM"         ,"@E 999,999.99" ,10,,,"right",,)
	TRCell():New( oSection1,"D1_VALIMP5" ,"TEMP","VL.IMP5"        ,"@E 999,999.99" ,10,,,"right",,)
	TRCell():New( oSection1,"D1_VALIMP6" ,"TEMP","VL.IMP6"        ,"@E 999,999.99" ,10,,,"right",,)
	TRCell():New( oSection1,"VALFRETE"   ,"TEMP","VL.FRETE"       ,"@E 999,999.99" ,10,,,"right",,)
	TRCell():New( oSection1,"CUSTOANT"   ,"TEMP","CUSTO ANT."     ,"@E 999,999.999999" ,16,,,"right",,)
	TRCell():New( oSection1,"DTCUSTOANT" ,"TEMP","DT.CUSTO ANT."  ,"@!" ,15,,,"left",,)
	TRCell():New( oSection1,"UPRC"   	 ,"TEMP","UPRC"       	  ,"@E 999,999.999999" ,10,,,"left",,)
	TRCell():New( oSection1,"PERIODO"  	 ,"TEMP","PERIODO"        ,"@!" ,13,,,"left",,)
	TRCell():New( oSection1,"CUSTO"   	 ,"TEMP","CUSTO"          ,"@E 999,999.999999" ,10,,,"left",,)

    //TRFunction():New(oSection2:Cell("D1_COD"),NIL,"COUNT",,,,,.F.,.T.)
    
    oReport:SetTotalInLine(.F.)
       
        //Aqui, farei uma quebra  por seção
    oSection1:SetPageBreak(.T.)
    oSection1:SetTotalText(" ")                
Return(oReport)

Static Function ReportPrint(oReport)
    Local oSection1 := oReport:Section(1)
    Local cQuery    := ""        
    Local cPro      := ""   
    Local lPrim     := .T.          
    Local cG1 := ""    
    Local mv09 := mv_par09
    Local frete := 0
    
    //Monto minha consulta conforme parametros passado
	cQuery:="SELECT /*D1_DTDIGIT DATA, */D1_COD CODIGO, D1_TES, F4_PISCOF, VLRPIS, VLRCOFINS, D1_QUANT , D1_VALIPI , D1_VALICM, D1_VALIMP5, D1_VALIMP6, VALFRETE,"+ CRLF
	cQuery+="B1_CUSTD CUSTOANT, SubStr(B1_DTCTSTA,7,2)||'/'||SubStr(B1_DTCTSTA,5,2)||'/'||SubStr(B1_DTCTSTA,1,4) DTCUSTOANT, B1_UPRC UPRC, /*UPRC preço da ultima compra unitario*/ "+ CRLF
	cQuery+="SubStr(D1_DTDIGIT,7,2)||'/'||SubStr(D1_DTDIGIT,5,2)||'/'||SubStr(D1_DTDIGIT,1,4) PERIODO, /*Formato de data para excel*/ "+ CRLF
	cQuery+="CAST(CUSTOSTD AS NUMERIC(14,5))  CUSTO "+ CRLF  
	cQuery+="FROM (SELECT DISTINCT SD1.D1_COD,SB1.B1_DESC,SB1.B1_TIPO,SB1.B1_CUSTD,SB1.B1_DTCTSTA,SD1.D1_DTDIGIT,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_QUANT,SD1.D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,"+ CRLF
	cQuery+="SD1.D1_VALIMP6,SD1.D1_NUMCQ,SD1.D1_TES, SB1.B1_UPRC, /*UPRC preço da ultima compra unitario*/ "+ CRLF
	cQuery+="COALESCE( "+ CRLF
 	cQuery+="(SELECT Max((SD1A.D1_TOTAL-SD1A.D1_VALICM-SD1A.D1_VALIMP5-SD1A.D1_VALIMP6)) FROM "+RetSqlName("SD1")+" SD1A "+ CRLF
  	cQuery+="WHERE SD1A.D1_DOC = ( SELECT SF8.F8_NFDIFRE FROM "+RetSqlName("SF8")+" SF8 WHERE SF8.F8_NFORIG = SD1.D1_DOC AND SF8.F8_SERORIG = SD1.D1_SERIE AND ROWNUM = 1 AND SF8.F8_FORNECE = SD1.D1_FORNECE AND SF8.F8_LOJA = SD1.D1_LOJA) "+ CRLF
  	cQuery+="AND SD1A.D1_SERIE = ( SELECT SF8.F8_SEDIFRE FROM "+RetSqlName("SF8")+" SF8 WHERE SF8.F8_NFORIG = SD1.D1_DOC AND SF8.F8_SERORIG = SD1.D1_SERIE AND ROWNUM = 1 AND SF8.F8_FORNECE = SD1.D1_FORNECE AND SF8.F8_LOJA = SD1.D1_LOJA) "+ CRLF
	cQuery+="AND SD1A.D1_COD   = SD1.D1_COD "+ CRLF
	cQuery+="AND SD1A.D_E_L_E_T_ = ' '),0) VALFRETE, "+ CRLF
	cQuery+="SF4.F4_PISCOF, "+ CRLF
	cQuery+="CASE "+ CRLF
  	cQuery+="WHEN SD1.D1_DTDIGIT < '20070101' AND SF4.F4_PISCOF = '1' THEN (SD1.D1_TOTAL)*0.0165 "+ CRLF
  	cQuery+="WHEN SD1.D1_DTDIGIT < '20070101' AND SF4.F4_PISCOF = '3' THEN (SD1.D1_TOTAL)*0.0165 "+ CRLF
  	cQuery+="ELSE 0 "+ CRLF
  	cQuery+="END VLRPIS, "+ CRLF
	cQuery+="CASE "+ CRLF
  	cQuery+="WHEN SD1.D1_DTDIGIT < '20070101' AND SF4.F4_PISCOF = '2' THEN (SD1.D1_TOTAL)*0.076 "+ CRLF
  	cQuery+="WHEN SD1.D1_DTDIGIT < '20070101' AND SF4.F4_PISCOF = '3' THEN (SD1.D1_TOTAL)*0.076 "+ CRLF
  	cQuery+="ELSE 0 "+ CRLF
  	cQuery+="END VLRCOFINS, "+ CRLF
	cQuery+="( SELECT SF8.F8_NFDIFRE FROM "+RetSqlName("SF8")+" SF8 WHERE SF8.F8_NFORIG = SD1.D1_DOC AND SF8.F8_SERORIG = SD1.D1_SERIE AND ROWNUM = 1 AND SF8.F8_FORNECE = SD1.D1_FORNECE AND SF8.F8_LOJA = SD1.D1_LOJA) NFFRETE, "+ CRLF
	cQuery+="( SELECT SF8.F8_SEDIFRE FROM "+RetSqlName("SF8")+" SF8 WHERE SF8.F8_NFORIG = SD1.D1_DOC AND SF8.F8_SERORIG = SD1.D1_SERIE AND ROWNUM = 1 AND SF8.F8_FORNECE = SD1.D1_FORNECE AND SF8.F8_LOJA = SD1.D1_LOJA) SERFRETE, "+ CRLF
	cQuery+="(SD1.D1_TOTAL-SD1.D1_VALICM-SD1.D1_VALIMP5-SD1.D1_VALIMP6+SD1.D1_VALIPI - "+ CRLF
	cQuery+="(CASE "+ CRLF
  	cQuery+="WHEN SD1.D1_DTDIGIT < '20070101' AND SF4.F4_PISCOF = '1' THEN (SD1.D1_TOTAL)*0.0165 "+ CRLF
  	cQuery+="WHEN SD1.D1_DTDIGIT < '20070101' AND SF4.F4_PISCOF = '3' THEN (SD1.D1_TOTAL)*0.0165 ELSE 0 END ) "+ CRLF
  	cQuery+=" - "+ CRLF
  	cQuery+="(CASE WHEN SD1.D1_DTDIGIT < '20070101' AND SF4.F4_PISCOF = '2' THEN (SD1.D1_TOTAL)*0.076 "+ CRLF
  	cQuery+="WHEN SD1.D1_DTDIGIT < '20070101' AND SF4.F4_PISCOF = "
  	cQuery+="'3' THEN (SD1.D1_TOTAL)*0.076 ELSE 0 END )+ COALESCE((SELECT MAX(SD1A.D1_TOTAL-SD1A.D1_VALICM-SD1A.D1_VALIMP5-SD1A.D1_VALIMP6) FROM "+RetSqlName("SD1")+" SD1A WHERE SD1A.D1_DOC = (SELECT SF8.F8_NFDIFRE FROM "+RetSqlName("SF8")+" SF8 WHERE SF8.F8_NFORIG = SD1.D1_DOC AND SF8.F8_SERORIG = SD1.D1_SERIE AND ROWNUM = 1 AND SF8.F8_FORNECE = SD1.D1_FORNECE AND SF8.F8_LOJA = SD1.D1_LOJA) AND SD1A.D1_SERIE = (SELECT SF8.F8_SEDIFRE FROM "+RetSqlName("SF8")+" SF8 WHERE SF8.F8_NFORIG = SD1.D1_DOC AND SF8.F8_SERORIG = SD1.D1_SERIE AND ROWNUM = 1 AND SF8.F8_FORNECE = SD1.D1_FORNECE AND SF8.F8_LOJA = SD1.D1_LOJA) AND SD1A.D1_COD   = SD1.D1_COD AND SD1A.D_E_L_E_T_ = ' '),0))/SD1.D1_QUANT   CUSTOSTD FROM "+RetSqlName("SD1")+" SD1 , "+RetSqlName("SB1")+" SB1 , "+RetSqlName("SF4")+" SF4 WHERE SD1.D_E_L_E_T_ = ' 'AND SB1.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' ' AND SD1.D1_QUANT <> 0 AND SD1.D1_COD = SB1.B1_COD AND SD1.D1_TES = SF4.F4_CODIGO AND SD1.D1_TES IN ('101','102','103','104','105','120','161','247','311','312','313','315','319','454','455') AND SD1.D1_DTDIGIT = SB1.B1_UCOM AND SB1.B1_TIPO IN ('MP','EE','EN') ORDER BY SD1.D1_DTDIGIT,SD1.D1_QUANT DESC) ORDER BY D1_COD,D1_DTDIGIT,D1_QUANT,CUSTOSTD "+ CRLF
   
	Memowrite('C:\TOTVS\vit429.txt', cQuery)
	
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
       	IF Select("TEMP") <> 0
        	DbSelectArea("TEMP")
        	DbCloseArea()
	    ENDIF
	    
    //crio o novo alias        
       	TCQUERY cQuery NEW ALIAS "TEMP"    
    
	/*Imprimindo com estrutura*/
    dbSelectArea("TEMP")
    TEMP->(dbGoTop())
    
    oReport:SetMeter(TEMP->(LastRec()))    
    //Irei percorrer todos os meus registros
    While !Eof()
        
        If oReport:Cancel()
            Exit
        EndIf
        
        //inicializo a primeira seção
        oSection1:Init()
        oReport:IncMeter()
                    
        cPro     := TEMP->CODIGO
        frete:= TEMP->VALFRETE
        IncProc("Imprimindo Produto "+alltrim(TEMP->CODIGO))
        
        //imprimo a primeira seção                
        oSection1:Cell("CODIGO"):SetValue(TEMP->CODIGO)
		oSection1:Cell("TES"):SetValue(TEMP->D1_TES)
	    oSection1:Cell("PISCOF"):SetValue(TEMP->F4_PISCOF)
		oSection1:Cell("VL.PIS"):SetValue(TEMP->VLRPIS)
		oSection1:Cell("VL.COFINS"):SetValue(TEMP->VLRCOFINS)
		oSection1:Cell("QUANT."):SetValue(TEMP->D1_QUANT)
		oSection1:Cell("VL.IPI"):SetValue(TEMP->D1_VALIPI)
		oSection1:Cell("VL.ICM"):SetValue(TEMP->D1_VALICM)
		oSection1:Cell("VL.IMP5"):SetValue(TEMP->D1_VALIMP5)
		oSection1:Cell("VL.IMP6"):SetValue(TEMP->D1_VALIMP6)
		oSection1:Cell("VL.FRETE"):SetValue(TEMP->VALFRETE)
		oSection1:Cell("CUSTO ANT."):SetValue(TEMP->CUSTOANT)
		oSection1:Cell("DT.CUSTO ANT."):SetValue(TEMP->DTCUSTOANT)
		oSection1:Cell("UPRC"):SetValue(TEMP->UPRC)		
		oSection1:Cell("PERIODO"):SetValue(TEMP->PERIODO)		
		oSection1:Cell("CUSTO"):SetValue(TEMP->CUSTO)		
        oSection1:Printline()	 	
		TEMP->(dbSkip())

    Enddo

     	//finalizo a primeira seção
	  oSection1:Finish()	 
Return   
      

static function ajustaSx1(cPerg)  
	/*
	PutSx1(cPerg,"01","Codigo DE ?"        		,'','',"mv_ch1","C",TamSx3  ("B1_COD")[1]   ,0,,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","Codigo ATE?"        		,'','',"mv_ch2","C",TamSx3  ("B1_COD")[1]   ,0,,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"03","Tipo Produto DE ?"  		,'','',"mv_ch3","C",TamSx3  ("B1_TIPO")[1]  ,0,,"G","","02","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"04","Tipo Produto ATE?"  		,'','',"mv_ch4","C",TamSx3  ("B1_TIPO")[1]  ,0,,"G","","02","","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"05","Grupo Produto DE ?" 		,'','',"mv_ch5","C",TamSx3  ("BM_GRUPO")[1] ,0,,"G","","SBM","","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"06","Grupo Produto ATE?" 		,'','',"mv_ch6","C",TamSx3  ("BM_GRUPO")[1] ,0,,"G","","SBM","","","mv_par06","","","","","","","","","","","","","","","","")
    PutSx1(cPerg,"07","Data DE ?"				,".",".","mv_ch7","D",08,0,0,"G","","","","",,"mv_par07","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"08","Data ATE?"				,".",".","mv_ch8","D",08,0,0,"G","","","","",,"mv_par08","","","","","","","","","","","","","","","","")                     
	PutSx1(cPerg,"09","Produtos com?" 			,'','',"mv_ch9","C",13,0,,"G","","","","","mv_par09","Estrutura","Estructura","Structure","","","Sem Estrutura","No Estructura","No Structure","","","","","","","","")
	*/
return

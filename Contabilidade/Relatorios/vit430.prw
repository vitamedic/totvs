/********************************************************************************
Autor: Leandro Data: 12/11/2015
NCMS IBGE
********************************************************************************/

#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
User Function vit430() //U_vit430()
    Local oReport := nil
    Local cPerg:= Padr("vit430",10)
    
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
    Local oBreak
    Local oFunction
    
    oReport := TReport():New(cNome,"NCMS IBGE",cNome,{|oReport| ReportPrint(oReport)},"NCMS IBGE")
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.F.)
    //U_vit430()
    oSection1:= TRSection():New(oReport, "Compras", {"TEMP"}, , .F., .T.)
    TRCell():New( oSection1,"COD"  	       ,"TEMP","CODIGO"           ,"@!",10,,,"right",,)
	TRCell():New( oSection1,"DESCRI"       ,"TEMP","DESCRICAO"        ,"@!",60,,,"left",,)
	TRCell():New( oSection1,"NCM"          ,"TEMP","NCM"              ,"@!",10,,,"left",,)
	TRCell():New( oSection1,"EMISSAO"      ,"TEMP","EMISSAO"          ,"@!",15,,,"left",,)
	TRCell():New( oSection1,"PESO"         ,"TEMP","PESO"             ,"@E 999,999.999999" ,15,,,"center",,)

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
    
    //Monto minha consulta conforme parametros passado
    cQuery :="SELECT COD, DESCRI, NCM, EMISSAO, SUM(PESO_PROD) PESO "
	cQuery +="FROM ( "
	cQuery +="SELECT "
	cQuery +="SD3.D3_COD COD, "
	cQuery +="SB1.B1_DESC DESCRI, "
	cQuery +="SB1.B1_POSIPI NCM, "
	cQuery +="SB1.B1_PESO PESO_LIQ, "
	cQuery +="SD3.D3_QUANT QTD_UN, "
	cQuery +="(SD3.D3_QUANT * SB1.B1_PESO) PESO_PROD, "
	cQuery +="SubStr(SD3.D3_EMISSAO,1,6) EMISSAO "
	cQuery +="FROM "+RetSqlName("SD3")+" SD3 "
	cQuery +="INNER JOIN "+RetSqlName("SB1")+" SB1 ON (SB1.D_E_L_E_T_=' ' "
	cQuery +="AND SB1.B1_COD=SD3.D3_COD "
	cQuery +="AND SB1.B1_TIPO IN ('PA','PL') "
	cQuery +="AND SB1.B1_POSIPI IN ('30049037','30049093','30049069','30049042','30049072','30049073','30049076','30045090','30049068')) "
	cQuery +="WHERE SD3.D_E_L_E_T_=' ' "
	cQuery +="AND SD3.D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
	cQuery +="AND SD3.D3_CF='PR0' "
	cQuery +="AND SD3.D3_ESTORNO<>'S' "
	cQuery +="AND SD3.D3_QUANT>0 "
	cQuery +=") "
	cQuery +="GROUP BY COD, DESCRI, NCM, EMISSAO "
	cQuery +="ORDER BY NCM, COD, EMISSAO"
   
	Memowrite('C:\TOTVS\vit430.txt', cQuery)
	    
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
                    
     cPro     := TEMP->COD
     IncProc("Imprimindo Produto "+alltrim(TEMP->COD))
        
     //imprimo a primeira seção                
     oSection1:Cell("CODIGO"):SetValue(TEMP->COD)
	 oSection1:Cell("DESCRI"):SetValue(TEMP->DESCRI)
	 oSection1:Cell("NCM"):SetValue(TEMP->NCM)
	 oSection1:Cell("EMISSAO"):SetValue(TEMP->EMISSAO)
	 oSection1:Cell("PESO"):SetValue(TEMP->PESO)
     oSection1:Printline()	 	
	 TEMP->(dbSkip())

	Enddo

    //finalizo a primeira seção
	oSection1:Finish()	 
Return   

static function ajustaSx1(cPerg)  
    PutSx1(cPerg,"01","Data DE ?",".",".","mv_ch1","D",08,0,0,"G","","","","",,"mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","Data ATE?",".",".","mv_ch2","D",08,0,0,"G","","","","",,"mv_par02","","","","","","","","","","","","","","","","")                     
return
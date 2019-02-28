/********************************************************************************
Autor: Leandro Data: 12/2016
Rel.Fat. Semestral CMED
********************************************************************************/

#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function vit474() //u_vit474()

    Local oReport := nil
    Local cPerg:= Padr("vit474",10)
    
    //Incluo/Altero as perguntas na tabela SX1
    AjustaSX1(cPerg)    
    //gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
    Pergunte(cPerg,.T.)              
        
    oReport := RptDef(cPerg)
    oReport:PrintDialog()
Return   
                                                 
Static Function RptDef(cNome)
    Local oReport := Nil
    Local oSection1:= Nil
    Local oSection2:= Nil
    Local oBreak
    Local oFunction
    Local mvpar03 := mv_par03 
    
    oReport := TReport():New(cNome,"Faturamento semestral.",cNome,{|oReport| ReportPrint(oReport)},"Faturamento semestral.")
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.F.)
    oReport:SetLandscape()
    oReport:SetDevice(4) 
    
    oSection1:= TRSection():New(oReport, "SS", {"TEMP"}, , .F., .T.)
     
     TRCell():New( oSection1,"CodGgrem"		,"TEMP","CodGgrem"		,"@!",10,,,"left",,)
     TRCell():New( oSection1,"Ano"   		,"TEMP","Ano"  			,"@!",05,,,"left",,)
	 TRCell():New( oSection1,"Mes"     		,"TEMP","Mes"    		,"@!",12,,,"right",,)
	 TRCell():New( oSection1,"TipoCliente"  ,"TEMP","TipoCliente"   ,"@!",09,,,"right",,)
	 TRCell():New( oSection1,"Quantidade"   ,"TEMP","Quantidade"    ,"@!",09,,,"right",,)
	 TRCell():New( oSection1,"Faturamento"  ,"TEMP","Faturamento"	,"@!",10,,,"right",,)
	 
    //TRFunction():New(oSection2:Cell("D1_COD"),NIL,"COUNT",,,,,.F.,.T.)
    
    oReport:SetTotalInLine(.F.)
       
    //Aqui, farei uma quebra  por seção
    oSection1:SetPageBreak(.T.)
    oSection1:SetTotalText(" ")                
Return(oReport)

Static Function ReportPrint(oReport)
    Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(2)     
    Local cQuery    := ""        
    Local cPro      := ""   
    Local lPrim     := .T.          
    Local cG1 := ""    
    Local mvpar03 := mv_par03 
    
 	//Monto minha consulta conforme parametros passado 
	
	cQuery:="select "
	cQuery+="d2_cod cod, sum(d2_quant) as Quantidade, a1_tipoesp TipoCliente, d2_doc nota, "
	cQuery+="SubStr(d2_emissao,1,4) Ano, SubStr(d2_emissao,5,2) Mes, b1_ggrem CodGgrem, "
	cQuery+="CASE "
	cQuery+="WHEN A1_TIPOESP = 'G' THEN 'G' "
	cQuery+="WHEN A1_TIPOESP = 'D' THEN 'D' "
	cQuery+="WHEN A1_TIPOESP = 'H' THEN 'H' "
	cQuery+="WHEN A1_TIPOESP = 'R' THEN 'F' "
	cQuery+="WHEN A1_TIPOESP = 'F' THEN 'F' "
	cQuery+="WHEN A1_TIPOESP = 'P' THEN 'O' "
	cQuery+="WHEN A1_TIPOESP = 'O' THEN 'O' "
	cQuery+="ELSE 'O' "
	cQuery+="END TIPO_LEGEND, "
	cQuery+="sum(d2_total) as Faturamento "
	cQuery+="from "+RetSqlName("sd2")+" sd2a, "+RetSqlName("sa1")+" sa1a, "+RetSqlName("sb1")+" sb1a "
	cQuery+="where sd2a.d_e_l_e_t_ = ' ' and sd2a.d_e_l_e_t_ = ' ' and sb1a.d_e_l_e_t_ = ' ' "
	cQuery+="and b1_tipo in ('PA','PL') "
	cQuery+="AND SD2A.D2_CLIENTE = SA1A.A1_COD  AND SD2A.D2_LOJA = SA1A.A1_LOJA "
	cQuery+="and sd2a.d2_cod = sb1a.b1_cod "
	cQuery+="and d2_emissao between '"+Dtos(mv_par01)+"' and '"+Dtos(mv_par02)+"' " 
	cQuery+="and D2_TIPO IN ('N','C')"
	cQuery+="group by d2_cod, a1_tipoesp, d2_doc, d2_emissao, b1_ggrem, d2_total "
	cQuery+="order by b1_ggrem, d2_doc "
	    
	Memowrite('C:\TOTVS\vit474.txt', cQuery)
	    
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
        
        //imprimo a primeira seção -- Dados da Solicitação do serviço               
        
	     oSection1:Cell("CodGgrem"):SetValue(TEMP->CodGgrem)
		 oSection1:Cell("Ano"):SetValue(TEMP->Ano)
		 oSection1:Cell("Mes"):SetValue(TEMP->Mes)
		 oSection1:Cell("TipoCliente"):SetValue(TEMP->TipoCliente)
		 oSection1:Cell("Quantidade"):SetValue(TEMP->Quantidade)
		 oSection1:Cell("Faturamento"):SetValue(TEMP->Faturamento)
		 
        oSection1:Printline()
        TEMP->(dbSkip())

    Enddo
Return   

static function ajustaSx1(cPerg)  
    PutSx1(cPerg,"01","Data DE ?"				,".",".","mv_ch1","D",08,0,0,"G","","","","",,"mv_par01","","","","","","","","","","","","","","","","")
    PutSx1(cPerg,"02","Data ATE?"				,".",".","mv_ch2","D",08,0,0,"G","","","","",,"mv_par02","","","","","","","","","","","","","","","","")
return
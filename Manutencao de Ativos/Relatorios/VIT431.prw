/********************************************************************************
Autor: Leandro Data: 02/12/2015
Indicador de Atendimento.
********************************************************************************/

#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
User Function VIT431() //U_VIT431()
    Local oReport := nil
    Local cPerg:= Padr("VIT431",10)
    
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
    
    oReport := TReport():New(cNome,"Indicador de Atendimento.",cNome,{|oReport| ReportPrint(oReport)},"Indicador de Atendimento.")
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.F.)
    oReport:SetLandscape()
    oReport:SetDevice(4) 
    
    oSection1:= TRSection():New(oReport, "SS", {"TEMP"}, , .F., .T.)
	
	TRCell():New( oSection1,"IRREGULARIDADE"		,"TEMP","IRREGULARIDADE"			,"@!",10,,,"left",,)
 	TRCell():New( oSection1,"SOLICITACAO_SS"		,"TEMP","SOLIC.SS"			,"@!",10,,,"left",,)
	TRCell():New( oSection1,"SOLICI_OS"    		,"TEMP","SOLIC.OS"     		,"@!",10,,,"left",,)
	TRCell():New( oSection1,"OS_SS"      			,"TEMP","OS SS"		 		,"@!",10,,,"left",,) 
	TRCell():New( oSection1,"SERVICO"      		,"TEMP","SERVICO"				,"@!",10,,,"left",,)
	TRCell():New( oSection1,"ORDEM_OS"  			,"TEMP","ORDEM OS"			,"@!",10,,,"left",,)
	TRCell():New( oSection1,"TIPOSS_SS"   			,"TEMP","TIPO SS"  			,"@!",05,,,"left",,)
	TRCell():New( oSection1,"CODBEM_SS"     		,"TEMP","CODBEM SS"    		,"@!",12,,,"right",,)
	TRCell():New( oSection1,"CCUSTO_SS"     		,"TEMP","CCUSTO SS"    		,"@!",09,,,"right",,)
	TRCell():New( oSection1,"DATA_ABERTURA_SS"      ,"TEMP","DT.ABERT.SS"		,"@!",10,,,"right",,)
	TRCell():New( oSection1,"DATA_FECHAMENTO_SS"    ,"TEMP","DT.FECH.SS"		,"@!",10,,,"left",,)
	TRCell():New( oSection1,"HORA_ABERTURA_SS"   	,"TEMP","HR.ABERT.SS" 		,"@!",10,,,"left",,)
	TRCell():New( oSection1,"HOFECH_SS"   			,"TEMP","HOFECH.SS"  		,"@!",10,,,"left",,)
	TRCell():New( oSection1,"USUARIO_SS"   			,"TEMP","USUARIO.SS" 	,"@!",35,,,"left",,)
	TRCell():New( oSection1,"RAMAL_SS"   			,"TEMP","RAMAL.SS"			,"@!",03,,,"right",,)
	TRCell():New( oSection1,"SOLUCAO_SS"   			,"TEMP","SOLUCAO.SS" 	,"@!",06,,,"left",,)
	TRCell():New( oSection1,"CODMSS_SS"   			,"TEMP","CODMSS.SS"    		,"@!",10,,,"left",,)
	TRCell():New( oSection1,"CDSOLI_SS"   			,"TEMP","CDSOLI.SS"    		,"@!",10,,,"left",,)
	TRCell():New( oSection1,"CDEXEC_SS"   			,"TEMP","CDEXEC.SS"	   		,"@!",10,,,"left",,)
	TRCell():New( oSection1,"PRIORI_SS"   			,"TEMP","PRIORI.SS"    		,"@!",02,,,"right",,)
	TRCell():New( oSection1,"DATA_ORIGI_OS"   		,"TEMP","DT.ORIG.OS" 	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"SERVICO_OS"     		,"TEMP","SERV.OS"       		,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"TIPO_OS"     	  		,"TEMP","TIPO OS"       		,"@!" ,50,,,"left",,)  
	TRCell():New( oSection1,"CCUSTO_OS"       		,"TEMP","CCUSTO OS"     	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"DATA_PRINI_OS"   		,"TEMP","DT.PRINI.OS"   	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"HOPRINI_OS"      		,"TEMP","HOPRINI.OS"    	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"DATA_PRFIM_OS"   		,"TEMP","DT.PRFIM.OS"   	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"HOPRFIM_OS"      		,"TEMP","HOPRFIM.OS"    	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"DATA_DTMPINI_OS" 		,"TEMP","DT.DTMPINI.OS" 	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"HOMPINI_OS"      		,"TEMP","HOMPINI.OS"    	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"DATA_DTMPFIM_OS" 		,"TEMP","DT.DTMPFIM.OS" 	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"HOMPFIM_OS"      		,"TEMP","HOMPFIM.OS"    	,"@!" ,10,,,"left",,)
    TRCell():New( oSection1,"DATA_DTMRINI_OS" 		,"TEMP","DT.DTMRINI.OS" 	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"HOMRINI_OS"      		,"TEMP","HOMRINI.OS"    	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"DATA_DTMRFIM_OS" 		,"TEMP","DT.DTMRFIM.OS" 	,"@!" ,10,,,"left",,)  
	TRCell():New( oSection1,"HOMRFIM_OS"      		,"TEMP","HOMRFIM.OS"    	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"SITUACA_OS"      		,"TEMP","SITUACA.OS"    	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"TERMINO_OS"      		,"TEMP","TERM.OS"       	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"USUARIO_OS"      		,"TEMP","USUARIO OS"    	,"@!" ,25,,,"left",,)
	TRCell():New( oSection1,"TIPOOS_OS"       		,"TEMP","TIPO OS"       	,"@!" ,03,,,"left",,)
	TRCell():New( oSection1,"HORACO1_OS"      		,"TEMP","HORACO1.OS"    	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"HORACO2_OS"      		,"TEMP","HORACO2.OS"    	,"@!" ,10,,,"left",,)
	TRCell():New( oSection1,"SOLICI_OS"       		,"TEMP","SOLICI.OS"     	,"@!" ,10,,,"left",,)

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

    
    //Monto minha consulta conforme parametros passado
    cQuery :="SELECT "
	cQuery +="TJ_IRREGU IRREGULARIDADE,TQB_SOLICI SOLICITACAO_SS, TJ_SOLICI SOLICI_OS, TQB_ORDEM OS_SS,TJ_SERVICO SERVICO, TJ_ORDEM ORDEM_OS, TQB_TIPOSS TIPOSS_SS, TQB_CODBEM CODBEM_SS, TQB_CCUSTO CCUSTO_SS, "
	cQuery +="SubStr(TQB_DTABER,7,2)||'/'||SubStr(TQB_DTABER,5,2)||'/'||SubStr(TQB_DTABER,1,4) DATA_ABERTURA_SS, "
	cQuery +="SubStr(TQB_DTFECH,7,2)||'/'||SubStr(TQB_DTFECH,5,2)||'/'||SubStr(TQB_DTFECH,1,4) DATA_FECHAMENTO_SS, "
	cQuery +="TQB_HOABER HORA_ABERTURA_SS, TQB_HOFECH HOFECH_SS, TQB_USUARI USUARIO_SS, TQB_RAMAL RAMAL_SS, TQB_SOLUCA SOLUCAO_SS, "
	cQuery +="TQB_CODMSS CODMSS_SS, TQB_CDSOLI CDSOLI_SS, TQB_CDEXEC CDEXEC_SS, TQB_PRIORI PRIORI_SS, "
	cQuery +="SubStr(TJ_DTORIGI,7,2)||'/'||SubStr(TJ_DTORIGI,5,2)||'/'||SubStr(TJ_DTORIGI,1,4) DATA_ORIGI_OS, TJ_SERVICO SERVICO_OS, "
	cQuery +="TJ_TIPO TIPO_OS, TJ_CCUSTO CCUSTO_OS, "
	cQuery +="SubStr(TJ_DTPRINI,7,2)||'/'||SubStr(TJ_DTPRINI,5,2)||'/'||SubStr(TJ_DTPRINI,1,4) DATA_PRINI_OS, TJ_HOPRINI HOPRINI_OS, "
	cQuery +="SubStr(TJ_DTPRFIM,7,2)||'/'||SubStr(TJ_DTPRFIM,5,2)||'/'||SubStr(TJ_DTPRFIM,1,4) DATA_PRFIM_OS, TJ_HOPRFIM HOPRFIM_OS, "
	cQuery +="SubStr(TJ_DTMPINI,7,2)||'/'||SubStr(TJ_DTMPINI,5,2)||'/'||SubStr(TJ_DTMPINI,1,4) DATA_DTMPINI_OS, TJ_HOMPINI HOMPINI_OS, "
	cQuery +="SubStr(TJ_DTMPFIM,7,2)||'/'||SubStr(TJ_DTMPFIM,5,2)||'/'||SubStr(TJ_DTMPFIM,1,4) DATA_DTMPFIM_OS, TJ_HOMPFIM HOMPFIM_OS, "
	cQuery +="SubStr(TJ_DTMRINI,7,2)||'/'||SubStr(TJ_DTMRINI,5,2)||'/'||SubStr(TJ_DTMRINI,1,4) DATA_DTMRINI_OS, TJ_HOMRINI HOMRINI_OS, "
	cQuery +="SubStr(TJ_DTMRFIM,7,2)||'/'||SubStr(TJ_DTMRFIM,5,2)||'/'||SubStr(TJ_DTMRFIM,1,4) DATA_DTMRFIM_OS, TJ_HOMRFIM HOMRFIM_OS, "
	cQuery +="TJ_SITUACA SITUACA_OS, TJ_TERMINO TERMINO_OS, TJ_USUARIO USUARIO_OS, TJ_TIPOOS TIPOOS_OS, TJ_HORACO1 HORACO1_OS, TJ_HORACO2 HORACO2_OS, "
	cQuery +="TJ_SOLICI SOLICI_OS "
	cQuery +="FROM "+RetSqlName("TQB")+" TQB, "+RetSqlName("STJ")+ " STJ left join tp7010 tp7 on tp7.D_E_L_E_T_ <> '*' and tp7_codire = tj_irregu  WHERE TQB.D_E_L_E_T_ <> '*' AND STJ.D_E_L_E_T_ <> '*' AND TQB.TQB_SOLICI = STJ.TJ_SOLICI AND STJ.TJ_SITUACA <> 'C'"
	If MV_PAR03 = 1  //Stephen Noel de Melo Ribeiro - Filtra encerradas/nao encerradas/todas 07/01/2018
		cQuery +=" AND TJ_TERMINO = 'N'
	ElseIf MV_PAR03 = 2
		cQuery +=" AND TJ_TERMINO = 'S'
	EndIf //Fim Stephen Noel
	cQuery +="and tqb.tqb_dtaber between '"+Dtos(mv_par01)+"' and '"+Dtos(mv_par02)+"' 
	cQuery +="order by TQB_SOLICI,tqb_dtaber"
   
	Memowrite('C:\TOTVS\VIT431.txt', cQuery)
	    
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
                    
        cPro     := TEMP->SOLICITACAO_SS
        IncProc("Imprimindo Produto "+alltrim(TEMP->SOLICITACAO_SS))
        
        //imprimo a primeira seção -- Dados da Solicitação do serviço   
                    
       oSection1:Cell("IRREGULARIDADE"):SetValue(TEMP->IRREGULARIDADE) 
       oSection1:Cell("SOLICITACAO_SS"):SetValue(TEMP->SOLICITACAO_SS)
		oSection1:Cell("SOLICI_OS"):SetValue(TEMP->SOLICI_OS)
	    oSection1:Cell("SERVICO"):SetValue(TEMP->SERVICO)
	    oSection1:Cell("OS_SS"):SetValue(TEMP->OS_SS)
		oSection1:Cell("ORDEM_OS"):SetValue(TEMP->ORDEM_OS)
		oSection1:Cell("TIPOSS_SS"):SetValue(TEMP->TIPOSS_SS)
		oSection1:Cell("CODBEM_SS"):SetValue(TEMP->CODBEM_SS)
		oSection1:Cell("CCUSTO_SS"):SetValue(TEMP->CCUSTO_SS)
		oSection1:Cell("DATA_ABERTURA_SS"):SetValue(TEMP->DATA_ABERTURA_SS)
		oSection1:Cell("DATA_FECHAMENTO_SS"):SetValue(TEMP->DATA_FECHAMENTO_SS)
		oSection1:Cell("HORA_ABERTURA_SS"):SetValue(TEMP->HORA_ABERTURA_SS)
		oSection1:Cell("HOFECH_SS"):SetValue(TEMP->HOFECH_SS)
		oSection1:Cell("USUARIO_SS"):SetValue(TEMP->USUARIO_SS)
		oSection1:Cell("RAMAL_SS"):SetValue(TEMP->RAMAL_SS)		
		oSection1:Cell("SOLUCAO_SS"):SetValue(TEMP->SOLUCAO_SS)				
		oSection1:Cell("CODMSS_SS"):SetValue(TEMP->CODMSS_SS)				
		oSection1:Cell("CDSOLI_SS"):SetValue(TEMP->CDSOLI_SS)				
		oSection1:Cell("CDEXEC_SS"):SetValue(TEMP->CDEXEC_SS)						
		oSection1:Cell("PRIORI_SS"):SetValue(TEMP->PRIORI_SS)
        oSection1:Cell("DATA_ORIGI_OS"):SetValue(TEMP->DATA_ORIGI_OS)
		oSection1:Cell("SERVICO_OS"):SetValue(TEMP->SERVICO_OS)
		oSection1:Cell("TIPO_OS"):SetValue(TEMP->TIPO_OS)  
		oSection1:Cell("CCUSTO_OS"):SetValue(TEMP->CCUSTO_OS)
		oSection1:Cell("DATA_PRINI_OS"):SetValue(TEMP->DATA_PRINI_OS)
		oSection1:Cell("HOPRINI_OS"):SetValue(TEMP->HOPRINI_OS)  
		oSection1:Cell("DATA_PRFIM_OS"):SetValue(TEMP->DATA_PRFIM_OS)
		oSection1:Cell("HOPRFIM_OS"):SetValue(TEMP->HOPRFIM_OS)
		oSection1:Cell("DATA_DTMPINI_OS"):SetValue(TEMP->DATA_DTMPINI_OS)
		oSection1:Cell("HOMPINI_OS"):SetValue(TEMP->HOMPINI_OS)    
		oSection1:Cell("DATA_DTMPFIM_OS"):SetValue(TEMP->DATA_DTMPFIM_OS)
		oSection1:Cell("HOMPFIM_OS"):SetValue(TEMP->HOMPFIM_OS)
		oSection1:Cell("DATA_DTMRINI_OS"):SetValue(TEMP->DATA_DTMRINI_OS)  
		oSection1:Cell("HOMRINI_OS"):SetValue(TEMP->HOMRINI_OS)
		oSection1:Cell("DATA_DTMRFIM_OS"):SetValue(TEMP->DATA_DTMRFIM_OS)
		oSection1:Cell("HOMRFIM_OS"):SetValue(TEMP->HOMRFIM_OS)  
		oSection1:Cell("SITUACA_OS"):SetValue(TEMP->SITUACA_OS)
		oSection1:Cell("TERMINO_OS"):SetValue(TEMP->TERMINO_OS)
		oSection1:Cell("USUARIO_OS"):SetValue(TEMP->USUARIO_OS)
		oSection1:Cell("TIPOOS_OS"):SetValue(TEMP->TIPOOS_OS)
		oSection1:Cell("HORACO1_OS"):SetValue(TEMP->HORACO1_OS)
		oSection1:Cell("HORACO2_OS"):SetValue(TEMP->HORACO2_OS)
		oSection1:Cell("SOLICI_OS"):SetValue(TEMP->SOLICI_OS)						
        
        oSection1:Printline()
        TEMP->(dbSkip())

    Enddo
Return   

static function ajustaSx1(cPerg)  
    PutSx1(cPerg,"01","Data DE ?"				,".",".","mv_ch1","D",08,0,0,"G","","","","",,"mv_par01","","","","","","","","","","","","","","","","")
    PutSx1(cPerg,"02","Data ATE?"				,".",".","mv_ch2","D",08,0,0,"G","","","","",,"mv_par02","","","","","","","","","","","","","","","","")
    PutSx1(cPerg,"03",OemToAnsi("Status           ?"),"","","mv_ch3","N",01,0,0,"C","","","","S","mv_par03","Abertas","","1","","Encerradas","","","Todas","","","","","","","","",,,)
    
    
return
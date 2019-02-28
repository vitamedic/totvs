/********************************************************************************
Autor: Leandro Data: 27/12/2016
Indicador de Atendimento.
********************************************************************************/

#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
User Function VIT434() //u_VIT434()


    Local oReport := nil
    Local cPerg:= Padr("VIT434",10)
    
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
    
    oReport := TReport():New(cNome,"Indicador de atendimento detalhado.",cNome,{|oReport| ReportPrint(oReport)},"Indicador de atendimento detalhado.")
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.F.)
    oReport:SetLandscape()
    oReport:SetDevice(4) 
    
    oSection1:= TRSection():New(oReport, "SS", {"TEMP"}, , .F., .T.)
    
    If mvpar03 == 1 /*Sem O.S*/
     TRCell():New( oSection1,"SOLICITACAO_SS"		,"TEMP","SOLIC.SS"			,"@!",10,,,"left",,)
     TRCell():New( oSection1,"TIPOSS_SS"   			,"TEMP","TIPO SS"  			,"@!",05,,,"left",,)
	 TRCell():New( oSection1,"CODBEM_SS"     		,"TEMP","CODBEM SS"    		,"@!",12,,,"right",,)
	 TRCell():New( oSection1,"CCUSTO_SS"     		,"TEMP","CCUSTO SS"    		,"@!",09,,,"right",,)
	 TRCell():New( oSection1,"TEXTO"     		,"TEMP","TEXTO"    		,"@!",09,,,"right",,)
	 TRCell():New( oSection1,"DATA_ABERTURA_SS"     ,"TEMP","DT.ABERT.SS"		,"@!",10,,,"right",,)
	 TRCell():New( oSection1,"DATA_FECHAMENTO_SS"   ,"TEMP","DT.FECH.SS"		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"HORA_ABERTURA_SS"   	,"TEMP","HR.ABERT.SS" 		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"HOFECH_SS"   			,"TEMP","HOFECH.SS"  		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"USUARIO_SS"   		,"TEMP","USUARIO.SS" 		,"@!",35,,,"left",,)
	 TRCell():New( oSection1,"RAMAL_SS"   			,"TEMP","RAMAL.SS"			,"@!",03,,,"right",,)
	 TRCell():New( oSection1,"SOLUCAO_SS"   		,"TEMP","SOLUCAO.SS" 		,"@!",06,,,"left",,)
	 TRCell():New( oSection1,"CODMSS_SS"   			,"TEMP","CODMSS.SS"    		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"CDSOLI_SS"   			,"TEMP","CDSOLI.SS"    		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"CDEXEC_SS"   			,"TEMP","CDEXEC.SS"	   		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"PRIORI_SS"   			,"TEMP","PRIORI.SS"    		,"@!",02,,,"right",,)
    EndIf
    
    If mvpar03 == 2 /*Somente as preventivas*/
 	 TRCell():New( oSection1,"ORDEM_OS"  				,"TEMP","ORDEM OS"		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"DATA_ORIGI_OS"   		,"TEMP","DT.ORIG.OS" 	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"TQB_CODBEM"   			,"TEMP","BEM" 		   ,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"SERVICO_OS"     		,"TEMP","SERV.OS"      	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"codigo"     				,"TEMP","CODIGO"     	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"execultante"     		,"TEMP","EXECULTANTE"   	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"TIPO_OS"     	  		,"TEMP","TIPO OS"       	,"@!" ,50,,,"left",,)  
	 TRCell():New( oSection1,"CCUSTO_OS"       		,"TEMP","CCUSTO OS"     	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"OBS"       				,"TEMP","OBSERVAÇÃO"    	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"DATA_DTMPFIM_OS" 		,"TEMP","DT.DTMPFIM.OS" 	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"HOMPFIM_OS"      		,"TEMP","HOMPFIM.OS"    	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"DATA_DTMRINI_OS" 		,"TEMP","DT.DTMRINI.OS" 	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"HOMRINI_OS"      		,"TEMP","HOMRINI.OS"    	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"DATA_DTMRFIM_OS" 		,"TEMP","DT.DTMRFIM.OS" 	,"@!" ,10,,,"left",,)  
	 TRCell():New( oSection1,"HOMRFIM_OS"      		,"TEMP","HOMRFIM.OS"    	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"DATA_PRINI_OS"   		,"TEMP","DT.PRINI.OS"   	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"HOPRINI_OS"      		,"TEMP","HOPRINI.OS"    	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"DATA_PRFIM_OS"   		,"TEMP","DT.PRFIM.OS"   	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"HOPRFIM_OS"      		,"TEMP","HOPRFIM.OS"    	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"DTINICIAL"      		,"TEMP","DT.INICIAL.OS" 	,"@!" ,10,,,"left",,)
	 //TRCell():New( oSection1,"DATA_DTMPINI_OS" 		,"TEMP","DT.DTMPINI.OS" 	,"@!" ,10,,,"left",,)
	 //TRCell():New( oSection1,"HOMPINI_OS"      		,"TEMP","HOMPINI.OS"    	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"SITUACA_OS"      		,"TEMP","SITUACA.OS"    	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"TERMINO_OS"      		,"TEMP","TERM.OS"       	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"USUARIO_OS"      		,"TEMP","USUARIO OS"    	,"@!" ,25,,,"left",,)
	 TRCell():New( oSection1,"TIPOOS_OS"       		,"TEMP","TIPO OS"       	,"@!" ,03,,,"left",,)
	 TRCell():New( oSection1,"HORACO1_OS"      		,"TEMP","HORACO1.OS"    	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"HORACO2_OS"      		,"TEMP","HORACO2.OS"    	,"@!" ,10,,,"left",,)
	 TRCell():New( oSection1,"SOLICI_OS"       		,"TEMP","SOLICI.OS"     	,"@!" ,10,,,"left",,)
    EndIf
    
    If mvpar03 == 3 /*O.S com mais de um tecnico, colocar como parametro data inicial da solicitação*/
     TRCell():New( oSection1,"TL_ORDEM"       		,"TEMP","ORDEM OS"     	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TQB_SOLICI"       	,"TEMP","SOLIC.SS"     	,"@!" ,10,,,"left",,)    
     TRCell():New( oSection1,"TQB_CODBEM"       	,"TEMP","BEM"       	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TEXTO"       	,"TEMP","TEXTO"       	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TL_PLANO"       		,"TEMP","PLANO"     	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TL_SEQRELA"       	,"TEMP","SEQ.REL"     	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TL_TAREFA"       		,"TEMP","TAREFA"     	,"@!" ,10,,,"left",,)    
     TRCell():New( oSection1,"TL_TIPOREG"       	,"TEMP","TIPO REG."     ,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TL_CODIGO"       		,"TEMP","CODIGO"     	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TL_QUANREC"       	,"TEMP","QUAN.REC"     	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TL_QUANTID"       	,"TEMP","QUANTIDADE"    ,"@!" ,10,,,"left",,)    
     TRCell():New( oSection1,"TL_CUSTO"       		,"TEMP","CUSTO"     	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TL_DESTINO"       	,"TEMP","DESTINO"     	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TL_DTINICI"       	,"TEMP","DT.INICIO"     ,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TL_HOINICI"       	,"TEMP","HR.INICIO"     ,"@!" ,10,,,"left",,)    
     TRCell():New( oSection1,"TL_DTFIM"       		,"TEMP","DT.FIM"     	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TL_HOFIM"       		,"TEMP","HR.FIM"     	,"@!" ,10,,,"left",,)
     TRCell():New( oSection1,"TL_REPFIM"       		,"TEMP","REP.FIM"     	,"@!" ,10,,,"left",,)	
     TRCell():New( oSection1,"TL_HREXTRA"       	,"TEMP","HR.EXTRA"     	,"@!" ,10,,,"left",,)	
	EndIf
    

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
    
    If mv_par03 == 1 /*Sem O.S*/
     cQuery:="select "
	 cQuery+="TQB_SOLICI SOLICITACAO_SS,TQB_TIPOSS TIPOSS_SS, TQB_CODBEM CODBEM_SS, TQB_CCUSTO CCUSTO_SS,LTRIM(RTRIM(yp_texto)) TEXTO,"
	 cQuery+="SubStr(TQB_DTABER,7,2)||'/'||SubStr(TQB_DTABER,5,2)||'/'||SubStr(TQB_DTABER,1,4) DATA_ABERTURA_SS,"
	 cQuery+="SubStr(TQB_DTFECH,7,2)||'/'||SubStr(TQB_DTFECH,5,2)||'/'||SubStr(TQB_DTFECH,1,4) DATA_FECHAMENTO_SS,"
	 cQuery+="TQB_HOABER HORA_ABERTURA_SS, TQB_HOFECH HOFECH_SS, TQB_USUARI USUARIO_SS, TQB_RAMAL RAMAL_SS, TQB_SOLUCA SOLUCAO_SS," 
	 cQuery+="TQB_CODMSS CODMSS_SS, TQB_CDSOLI CDSOLI_SS, TQB_CDEXEC CDEXEC_SS, TQB_PRIORI PRIORI_SS "
	 cQuery+="from "+RetSqlName("TQB")+" TQB "
	 cQuery+="inner join SYP010 syp on syp.D_E_L_E_T_ <> '*' and yp_chave = tqb_codmss and LTRIM(RTRIM(yp_texto)) <>  ('\14\10') "
	 cQuery+="WHERE TQB.D_E_L_E_T_ <> '*' and TQB_SOLUCA in ('A') and TQB_ORDEM = ' ' and tqb.tqb_dtaber between '"+Dtos(mv_par01)+"' and '"+Dtos(mv_par02)+"' "
	 cQuery+="order by TQB_SOLICI,tqb_dtaber"
    EndIf
    
    If mvpar03 == 2 /*Somente as preventivas*/
	 cQuery:="select "
	 cQuery+="tj_ordem ORDEM_OS,SubStr(TJ_DTORIGI,7,2)||'/'||SubStr(TJ_DTORIGI,5,2)||'/'||SubStr(TJ_DTORIGI,1,4) DATA_ORIGI_OS," 
	 cQuery+="tj_codbem codbem,TJ_SERVICO SERVICO_OS, tl_codigo Codigo,t1_nome execultante, TJ_TIPO TIPO_OS, TJ_CCUSTO CCUSTO_OS," 
	 cQuery+="UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(tj_observa, 4000,1)) OBS,"
	 cQuery+="SubStr(TJ_DTPRINI,7,2)||'/'||SubStr(TJ_DTPRINI,5,2)||'/'||SubStr(TJ_DTPRINI,1,4) DATA_PRINI_OS, /*TJ_HOPRINI*/ TL_HOINICI HOPRINI_OS," 
	 cQuery+="SubStr(TJ_DTPRFIM,7,2)||'/'||SubStr(TJ_DTPRFIM,5,2)||'/'||SubStr(TJ_DTPRFIM,1,4) DATA_PRFIM_OS, /*TJ_HOPRFIM*/ TL_HOFIM HOPRFIM_OS,"
	 cQuery+="SubStr(TL_DTINICI,7,2)||'/'||SubStr(TL_DTINICI,5,2)||'/'||SubStr(TL_DTINICI,1,4) DTINICIAL," 
	 //cQuery+="SubStr(TJ_DTMPINI,7,2)||'/'||SubStr(TJ_DTMPINI,5,2)||'/'||SubStr(TJ_DTMPINI,1,4) DATA_DTMPINI_OS, TJ_HOMPINI HOMPINI_OS," 
	 cQuery+="SubStr(TJ_DTMPFIM,7,2)||'/'||SubStr(TJ_DTMPFIM,5,2)||'/'||SubStr(TJ_DTMPFIM,1,4) DATA_DTMPFIM_OS, TJ_HOMPFIM HOMPFIM_OS," 
	 cQuery+="SubStr(TJ_DTMRINI,7,2)||'/'||SubStr(TJ_DTMRINI,5,2)||'/'||SubStr(TJ_DTMRINI,1,4) DATA_DTMRINI_OS, TJ_HOMRINI HOMRINI_OS," 
	 cQuery+="SubStr(TJ_DTMRFIM,7,2)||'/'||SubStr(TJ_DTMRFIM,5,2)||'/'||SubStr(TJ_DTMRFIM,1,4) DATA_DTMRFIM_OS, TJ_HOMRFIM HOMRFIM_OS," 
	 cQuery+="TJ_SITUACA SITUACA_OS, TJ_TERMINO TERMINO_OS, TJ_USUARIO USUARIO_OS, TJ_TIPOOS TIPOOS_OS, TJ_HORACO1 HORACO1_OS, TJ_HORACO2 HORACO2_OS, TJ_SOLICI SOLICI_OS " 
	 cQuery+="from "+RetSqlName("stj")+" stj "
	 cQuery+="left join "+RetSqlName("stl")+" stl on stl.d_e_l_e_t_= ' ' and tl_ordem = tj_ordem " 
	 cQuery+="left join "+RetSqlName("st1")+" st1 on st1.d_e_l_e_t_= ' ' and t1_codfunc = tl_codigo   "
	 cQuery+="WHERE STJ.D_E_L_E_T_ <> '*' AND TJ_SERVICO in ('PE0000','PE0001','PE0002','PE0003','PE0004','PE0005','PE0006','PE0007','PM0000','PM0001','PM0002','PM0003','PM0004','PM0005','PM0006','PM0007') "
	 cQuery+="AND STJ.TJ_SITUACA <> 'C' and tj_dtorigi between '"+Dtos(mv_par01)+"' and '"+Dtos(mv_par02)+"'" 
	 cQuery+="order by tj_ordem, TL_HOINICI /*tj_dtorigi,tj_ordem*/"
    Endif
    
    If mvpar03 == 3 /*O.S com mais de um tecnico, colocar como parametro data inicial da solicitação*/
	 cQuery:="select TL_ORDEM,TQB_SOLICI,TQB_CODBEM,LTRIM(RTRIM(yp_texto)) TEXTO,TL_PLANO,TL_SEQRELA,TL_TAREFA,TL_TIPOREG,TL_CODIGO,TL_QUANREC,"
	 cQuery+="TL_QUANTID,TL_CUSTO,TL_DESTINO,
	 cQuery+="SubStr(TL_DTINICI,7,2)||'/'||SubStr(TL_DTINICI,5,2)||'/'||SubStr(TL_DTINICI,1,4) TL_DTINICI,"
	 cQuery+="TL_HOINICI,"
	 cQuery+="SubStr(TL_DTFIM,7,2)||'/'||SubStr(TL_DTFIM,5,2)||'/'||SubStr(TL_DTFIM,1,4) TL_DTFIM,"
	 cQuery+="TL_HOFIM,TL_REPFIM,"
	 cQuery+="TL_HREXTRA from "+RetSqlName("stl")+" stl "
	 cQuery+="inner join tqb010 tqb on tqb.D_E_L_E_T_ <> '*' and tqb_ordem = tl_ordem "
	 cQuery+="inner join SYP010 syp on syp.D_E_L_E_T_ <> '*' and yp_chave = tqb_codmss and LTRIM(RTRIM(yp_texto)) <>  ('\14\10') "
	 cQuery+="where stl.D_E_L_E_T_ <> '*' and tl_dtinici between '"+Dtos(mv_par01)+"' and '"+Dtos(mv_par02)+"'"
    Endif
    
	Memowrite('C:\TOTVS\VIT434.txt', cQuery)
	    
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
        
        If mvpar03 == 1 /*Sem O.S*/
	     oSection1:Cell("SOLICITACAO_SS"):SetValue(TEMP->SOLICITACAO_SS)
		 oSection1:Cell("TIPOSS_SS"):SetValue(TEMP->TIPOSS_SS)
		 oSection1:Cell("CODBEM_SS"):SetValue(TEMP->CODBEM_SS)
		 oSection1:Cell("CCUSTO_SS"):SetValue(TEMP->CCUSTO_SS)
		 oSection1:Cell("TEXTO"):SetValue(TEMP->TEXTO)
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
		EndIf                                   
		
		If mvpar03 == 2 /*Somente as preventivas*/
 		 oSection1:Cell("ORDEM_OS"):SetValue(TEMP->ORDEM_OS)
	     oSection1:Cell("DATA_ORIGI_OS"):SetValue(TEMP->DATA_ORIGI_OS)
	     oSection1:Cell("TQB_CODBEM"):SetValue(TEMP->CODBEM)
	     oSection1:Cell("SERVICO_OS"):SetValue(TEMP->SERVICO_OS)
	     oSection1:Cell("codigo"):SetValue(TEMP->codigo)
	     oSection1:Cell("execultante"):SetValue(TEMP->execultante)
	     oSection1:Cell("TIPO_OS"):SetValue(TEMP->TIPO_OS)  
		 oSection1:Cell("CCUSTO_OS"):SetValue(TEMP->CCUSTO_OS)
		 oSection1:Cell("OBS"):SetValue(TEMP->OBS)
		 oSection1:Cell("DATA_PRINI_OS"):SetValue(TEMP->DATA_PRINI_OS)
		 oSection1:Cell("HOPRINI_OS"):SetValue(TEMP->HOPRINI_OS)  
		 oSection1:Cell("DATA_PRFIM_OS"):SetValue(TEMP->DATA_PRFIM_OS)
		 oSection1:Cell("HOPRFIM_OS"):SetValue(TEMP->HOPRFIM_OS)
		 oSection1:Cell("DTINICIAL"):SetValue(TEMP->DTINICIAL)
		 //oSection1:Cell("DATA_DTMPINI_OS"):SetValue(TEMP->DATA_DTMPINI_OS)
		 //oSection1:Cell("HOMPINI_OS"):SetValue(TEMP->HOMPINI_OS)    
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
		EndIf
		
		If mvpar03 == 3 /*O.S com mais de um tecnico, colocar como parametro data inicial da solicitação*/
		 oSection1:Cell("TL_ORDEM"):SetValue(TEMP->TL_ORDEM)
		 oSection1:Cell("TQB_SOLICI"):SetValue(TEMP->TQB_SOLICI)
		 oSection1:Cell("TQB_CODBEM"):SetValue(TEMP->TQB_CODBEM)
		 oSection1:Cell("TEXTO"):SetValue(TEMP->TEXTO)
		 oSection1:Cell("TL_PLANO"):SetValue(TEMP->TL_PLANO)
		 oSection1:Cell("TL_SEQRELA"):SetValue(TEMP->TL_SEQRELA)
		 oSection1:Cell("TL_TAREFA"):SetValue(TEMP->TL_TAREFA)
		 oSection1:Cell("TL_TIPOREG"):SetValue(TEMP->TL_TIPOREG)
		 oSection1:Cell("TL_CODIGO"):SetValue(TEMP->TL_CODIGO)
		 oSection1:Cell("TL_QUANREC"):SetValue(TEMP->TL_QUANREC)
		 oSection1:Cell("TL_QUANTID"):SetValue(TEMP->TL_QUANTID)
		 oSection1:Cell("TL_CUSTO"):SetValue(TEMP->TL_CUSTO)
		 oSection1:Cell("TL_DESTINO"):SetValue(TEMP->TL_DESTINO)
		 oSection1:Cell("TL_DTINICI"):SetValue(TEMP->TL_DTINICI)
		 oSection1:Cell("TL_HOINICI"):SetValue(TEMP->TL_HOINICI)
		 oSection1:Cell("TL_DTFIM"):SetValue(TEMP->TL_DTFIM)
		 oSection1:Cell("TL_HOFIM"):SetValue(TEMP->TL_HOFIM)
		 oSection1:Cell("TL_REPFIM"):SetValue(TEMP->TL_REPFIM)
		 oSection1:Cell("TL_HREXTRA"):SetValue(TEMP->TL_HREXTRA)
		EndIf

        oSection1:Printline()
        TEMP->(dbSkip())

    Enddo
Return   

static function ajustaSx1(cPerg)  
    PutSx1(cPerg,"01","Data DE ?"				,".",".","mv_ch1","D",08,0,0,"G","","","","",,"mv_par01","","","","","","","","","","","","","","","","")
    PutSx1(cPerg,"02","Data ATE?"				,".",".","mv_ch2","D",08,0,0,"G","","","","",,"mv_par02","","","","","","","","","","","","","","","","")
    PutSx1(cPerg,"03","Informação com?" 		,'','',"mv_ch3","C",13,0,,"G","","","","","mv_par03","S.S sem O.S","S.S sem O.S","S.S sem O.S","","","Somente as preventivas","Somente as preventivas","Somente as preventivas","","","O.S com mais de um tecnico","O.S com mais de um tecnico","O.S com mais de um tecnico","","","")                    
return
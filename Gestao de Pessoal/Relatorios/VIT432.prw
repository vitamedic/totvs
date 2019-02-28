/********************************************************************************
Autor: Leandro Data: 02/12/2015
Contribuição Assistêncial.
********************************************************************************/

#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
User Function VIT432() //U_VIT432()
    Local oReport := nil
    Local cPerg:= Padr("Contribuição Assistêncial.",100)
    
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
    
    oReport := TReport():New(cNome,"Contribuição Assistêncial.",cNome,{|oReport| ReportPrint(oReport)},"Fonte: VIT432")
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.F.)
    oReport:SetPortrait()
    oReport:SetDevice(1) 
    
    oSection1:= TRSection():New(oReport, "RH", {"TEMP"}, , .F., .T.)

    TRCell():New( oSection1,"MATRICULA"	  ,"TEMP","MATRICULA"  ,"@!",10,,,"left",,)
	TRCell():New( oSection1,"FUNCIONARIO" ,"TEMP","FUNCIONARIO","@!",40,,,"left",,)
	TRCell():New( oSection1,"VALOR"      ,"TEMP","VALOR"	   ,"@E 999,999.99",10,,,"left",,) 

    TRFunction():New(oSection1:Cell("VALOR"),NIL,"SUM",,,,,.F.,.T.)
    
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
    
    cQuery :="select RD_MAT MATRICULA,RA_NOME FUNCIONARIO,RD_VALOR VALOR "
    cQuery +="from "+ retsqlname("srd") + " srd "
	cQuery +="inner join "+retsqlname("sra")+" sra on sra.d_e_l_e_t_= ' ' and ra_mat = rd_mat "
	cQuery +="where rd_datpgt = '"+Dtos(mv_par01)+"' and RD_PD = '268' "
	cQuery +="order by rd_pd"

	Memowrite('C:\TOTVS\VIT432.txt', cQuery)
	    
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
                    
        cPro     := TEMP->MATRICULA
        IncProc("Imprimindo Produto "+alltrim(TEMP->MATRICULA))

        //imprimo a primeira seção -- Dados da Solicitação do serviço               
        oSection1:Cell("MATRICULA"):SetValue(TEMP->MATRICULA)
		oSection1:Cell("FUNCIONARIO"):SetValue(TEMP->FUNCIONARIO)
	    oSection1:Cell("VALOR"):SetValue(TEMP->VALOR)
		        
        oSection1:Printline()
        TEMP->(dbSkip())

    Enddo
Return   

static function ajustaSx1(cPerg)  
    PutSx1(cPerg,"01","Período ?"				,".",".","mv_ch1","D",08,0,0,"G","","","","",,"mv_par01","","","","","","","","","","","","","","","","")
return
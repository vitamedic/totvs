/********************************************************************************
Autor: Leandro Data: 17/07/15 
Fatura vs Cte
********************************************************************************/

#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
User Function fatcte() //U_fatcte()
    Local oReport := nil
    Local cPerg:= Padr("fatcte",10)
    
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
    
    oReport := TReport():New(cNome,"Fatura vs Cte",cNome,{|oReport| ReportPrint(oReport)},"Fatura vs Cte")
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.F.)
    
    oSection1:= TRSection():New(oReport, "Faturas - Cte", {"TEMP"}, , .F., .T.)
    TRCell():New( oSection1,"e2_fatura"  ,"TEMP","FATURA"           ,"@!",10,,,"right",,)
	TRCell():New( oSection1,"e2_num"     ,"TEMP","CONHECIMENTO"     ,"@!",10,,,"left",,)
	TRCell():New( oSection1,"e2_emissao" ,"TEMP","EMISSAO"          ,"@!",10,,,"left",,)
	TRCell():New( oSection1,"e2_vencto"  ,"TEMP","VENCIMENTO"       ,"@!",23,,,"left",,)

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
    Local mv01 := mv_par01
    
    //Monto minha consulta conforme parametros passado
   If mv01 == 1                            
	//Fatura
	cQuery := "select e2_fatura, e2_num, e2_emissao, e2_vencto "
	cQuery += "from "+retsqlname("se2")+ " se2 "
	cQuery += "where se2.D_E_L_E_T_ = ' '  and e2_fatura like '"+mv_par02+"%'"
   Else     
	//Conhecimento
	cQuery := "select e2_fatura, e2_num, e2_emissao, e2_vencto "
	cQuery += "from "+retsqlname("se2")+ " se2 "
	cQuery += "where se2.D_E_L_E_T_ = ' ' and  e2_num like '%"+mv_par03+"%'"
   EndIf 	                             
   
	Memowrite('C:\TOTVS\QueryFatCte.txt', cQuery)
	    
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
        
     //imprimo a primeira seção                
     oSection1:Cell("FATURA"):SetValue(TEMP->e2_fatura)
	 oSection1:Cell("CONHECIMENTO"):SetValue(TEMP->e2_num)
	 oSection1:Cell("EMISSAO"):SetValue(cvaltochar(stod(TEMP->e2_emissao))) //Formata Data dd/mm/aaaa
	 oSection1:Cell("VENCIMENTO"):SetValue(cvaltochar(stod(TEMP->e2_vencto))) //Formata Data dd/mm/aaaa
       
     oSection1:Printline()
     TEMP->(dbSkip())

     //imprimo uma linha para separar um produto de outro
     oReport:ThinLine()
    Enddo  	    
    oSection1:Finish()  
Return   

static function ajustaSx1(cPerg)  
	PutSx1(cPerg,"01","Tipo ?"        		    ,'','',"mv_ch1","C",12,0,,"G","","","C","","mv_par01","Fatura","Cuenta","Bill","","","Conhecimento","Conocimiento","Knowledge","","","","","","","","")
	PutSx1(cPerg,"02","Fatura ?"        		,'','',"mv_ch2","C",9,0,,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"03","Conhecimento ?"  		,'','',"mv_ch3","C",9,0,,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
return    
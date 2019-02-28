/********************************************************************************
Autor: Leandro Data: 21/06/2016
Custo Pc Manutenção.
********************************************************************************/

#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
User Function VIT453() //u_VIT453()


    Local oReport := nil
    Local cPerg:= Padr("VIT453",10)
    
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
    
    oReport := TReport():New(cNome,"Custo Pc Manutenção.",cNome,{|oReport| ReportPrint(oReport)},"Custo Pc Manutenção.")
    oReport:SetPortrait()    
    oReport:SetTotalInLine(.F.)
    oReport:SetLandscape()
    oReport:SetDevice(4) 
    
    oSection1:= TRSection():New(oReport, "XX", {"TEMP"}, , .F., .T.)

     TRCell():New( oSection1,"NUM_PEDIDO"			,"TEMP","N.PEDIDO"			,"@!",10,,,"left",,)
     TRCell():New( oSection1,"ITEM_PED"   			,"TEMP","ITEM PEDIDO"  			,"@!",05,,,"left",,)
	 TRCell():New( oSection1,"DIA_EMISSAO"     		,"TEMP","DIA"    		,"@!",12,,,"right",,)
	 TRCell():New( oSection1,"MES_EMISSAO"     		,"TEMP","MES"    		,"@!",09,,,"right",,)
	 TRCell():New( oSection1,"ANO_EMISSAO"     		,"TEMP","ANO"    		,"@!",09,,,"right",,)
	 TRCell():New( oSection1,"DT_PEDIDO"    		,"TEMP","DATA PEDIDO"		,"@!",10,,,"right",,)
	 TRCell():New( oSection1,"DT_NESCESSIDADE"	    ,"TEMP","DATA NESCESSIDADE"		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"DIA_NESC"   			,"TEMP","DIA NECESSIDADE" 		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"MES_NESC"   			,"TEMP","MES NECESSIDADE"  		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"ANO_NESC"   			,"TEMP","ANO NECESSIDADE" 		,"@!",35,,,"left",,)
	 TRCell():New( oSection1,"DT_PREV"   			,"TEMP","DATA PREVISTA"			,"@!",03,,,"right",,)
	 TRCell():New( oSection1,"DIA_PREV"   			,"TEMP","DIA PREVISTO" 		,"@!",06,,,"left",,)
	 TRCell():New( oSection1,"MES_PREV"   			,"TEMP","MES PREVISTO"    		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"ANO_PREV"   			,"TEMP","ANO PREVISTO"    		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"DT_ENTRADA"   		,"TEMP","DATA ENTRADA"	   		,"@!",10,,,"left",,)
	 TRCell():New( oSection1,"COD_PRODUTO"   			,"TEMP","PRODUTO"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"DESC_PRODUTO"   			,"TEMP","DESCRICAO"    		,"@!",02,,,"right",,)	 
	 TRCell():New( oSection1,"TP_PRODUTO"   			,"TEMP","TIPO"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"GRP_PRODUTO"   			,"TEMP","GRUPO"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"ARMAZEM"   			,"TEMP","ARMAZEM"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"QTD_PEDIDO"   			,"TEMP","QTD.PEDIDO"    		,"@!",02,,,"right",,)
 	 TRCell():New( oSection1,"QTD_ENTREGUE"   			,"TEMP","QTD.ENTREGUE"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"QTD_PENDENTE"   			,"TEMP","QTD.PENDENTE"    		,"@!",02,,,"right",,)	 
	 TRCell():New( oSection1,"PRC_UNIT"   			,"TEMP","VALOR UNITARIO"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"TOTAL"   			,"TEMP","TOTAL"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"NUM_SC"   			,"TEMP","SOLICITACAO COMPRA"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"FORNECEDOR"   			,"TEMP","FORNECEDOR"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"NOME_FORNECEDOR"   			,"TEMP","NOME"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"CONTATO"   			,"TEMP","CONTATO"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"CENTRO_CUSTO"   			,"TEMP","CENTRO CUSTO"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"DESC_CC"   			,"TEMP","DESCRICAO CC"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"SOLICITANTE"   			,"TEMP","SOLICITANTE"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"OBS"   			,"TEMP","OBS"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"NF"   			,"TEMP","NOTA FISCAL"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"ITEM_NF"   			,"TEMP","ITEM NF"    		,"@!",02,,,"right",,)
	 TRCell():New( oSection1,"SERIE_NF"   			,"TEMP","SERIE NF"    		,"@!",02,,,"right",,)
	 
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
	cQuery+="NUM_PEDIDO, ITEM_PED,	DIA_EMISSAO,	ANO_EMISSAO,	MES_EMISSAO,	DT_PEDIDO,	DT_NESCESSIDADE,	DIA_NESC,	ANO_NESC,	MES_NESC,	DT_PREV,"
	cQuery+="DIA_PREV,	ANO_PREV,	MES_PREV,	DT_ENTRADA,	COD_PRODUTO,	DESC_PRODUTO,	TP_PRODUTO,	GRP_PRODUTO,	ARMAZEM,	QTD_PEDIDO,	QTD_ENTREGUE,  "
	cQuery+="QTD_PENDENTE,	PRC_UNIT,	TOTAL,	NUM_SC,	FORNECEDOR,	NOME_FORNECEDOR, CONTATO,	CENTRO_CUSTO,	DESC_CC,	SOLICITANTE,	OBS,	NF,	ITEM_NF,	SERIE_NF "
	cQuery+="from vw_pedcom "
	cQuery+="where mes_emissao = '"+mv_par01+"' and ano_emissao = '"+mv_par02+"' and solicitante in ('l.dias','karla.honorato','ronaldo.martins','ronaldo.martin')"
    
	Memowrite('C:\TOTVS\VIT453.txt', cQuery)
	    
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
        
         oSection1:Cell("NUM_PEDIDO"):SetValue(TEMP->NUM_PEDIDO)
		 oSection1:Cell("ITEM_PED"):SetValue(TEMP->ITEM_PED)
		 oSection1:Cell("DIA_EMISSAO"):SetValue(TEMP->DIA_EMISSAO)
		 oSection1:Cell("ANO_EMISSAO"):SetValue(TEMP->ANO_EMISSAO)
		 oSection1:Cell("MES_EMISSAO"):SetValue(TEMP->MES_EMISSAO)
		 oSection1:Cell("DT_PEDIDO"):SetValue(TEMP->DT_PEDIDO)
		 oSection1:Cell("DT_NESCESSIDADE"):SetValue(TEMP->DT_NESCESSIDADE)
		 oSection1:Cell("DIA_NESC"):SetValue(TEMP->DIA_NESC)
		 oSection1:Cell("ANO_NESC"):SetValue(TEMP->ANO_NESC)
		 oSection1:Cell("MES_NESC"):SetValue(TEMP->MES_NESC)
		 oSection1:Cell("DT_PREV"):SetValue(TEMP->DT_PREV)		
		 oSection1:Cell("DIA_PREV"):SetValue(TEMP->DIA_PREV)				
		 oSection1:Cell("ANO_PREV"):SetValue(TEMP->ANO_PREV)				
		 oSection1:Cell("MES_PREV"):SetValue(TEMP->MES_PREV)				
		 oSection1:Cell("DT_ENTRADA"):SetValue(TEMP->DT_ENTRADA)						
		 oSection1:Cell("COD_PRODUTO"):SetValue(TEMP->COD_PRODUTO)
		 oSection1:Cell("DESC_PRODUTO"):SetValue(TEMP->DESC_PRODUTO)
		 oSection1:Cell("TP_PRODUTO"):SetValue(TEMP->TP_PRODUTO)
		 oSection1:Cell("GRP_PRODUTO"):SetValue(TEMP->GRP_PRODUTO)		 		 
		 oSection1:Cell("ARMAZEM"):SetValue(TEMP->ARMAZEM)
		 oSection1:Cell("QTD_PEDIDO"):SetValue(TEMP->QTD_PEDIDO)
		 oSection1:Cell("QTD_ENTREGUE"):SetValue(TEMP->QTD_ENTREGUE)
		 oSection1:Cell("QTD_PENDENTE"):SetValue(TEMP->QTD_PENDENTE)		 
		 oSection1:Cell("PRC_UNIT"):SetValue(TEMP->PRC_UNIT)
		 oSection1:Cell("TOTAL"):SetValue(TEMP->TOTAL)		 
		 oSection1:Cell("NUM_SC"):SetValue(TEMP->NUM_SC)
		 oSection1:Cell("FORNECEDOR"):SetValue(TEMP->FORNECEDOR)
		 oSection1:Cell("NOME_FORNECEDOR"):SetValue(TEMP->NOME_FORNECEDOR)
		 oSection1:Cell("CONTATO"):SetValue(TEMP->CONTATO)		 		 
		 oSection1:Cell("CENTRO_CUSTO"):SetValue(TEMP->CENTRO_CUSTO)
		 oSection1:Cell("DESC_CC"):SetValue(TEMP->DESC_CC)
		 oSection1:Cell("SOLICITANTE"):SetValue(TEMP->SOLICITANTE)
		 oSection1:Cell("OBS"):SetValue(TEMP->OBS)		 
		 oSection1:Cell("NF"):SetValue(TEMP->NF)
		 oSection1:Cell("ITEM_NF"):SetValue(TEMP->ITEM_NF)		 
		 oSection1:Cell("SERIE_NF"):SetValue(TEMP->SERIE_NF)		 
		
        oSection1:Printline()
        TEMP->(dbSkip())

    Enddo
Return   

static function ajustaSx1(cPerg)  
    PutSx1(cPerg,"01","Mes ?"				,".",".","mv_ch1","C",02,0,0,"G","","","","",,"mv_par01","","","","","","","","","","","","","","","","")
    PutSx1(cPerg,"02","Ano ?"				,".",".","mv_ch2","C",04,0,0,"G","","","","",,"mv_par02","","","","","","","","","","","","","","","","")
    //PutSx1(cPerg,"03","Informação com?" 		,'','',"mv_ch3","C",13,0,,"G","","","","","mv_par03","S.S sem O.S","S.S sem O.S","S.S sem O.S","","","Somente as preventivas","Somente as preventivas","Somente as preventivas","","","O.S com mais de um tecnico","O.S com mais de um tecnico","O.S com mais de um tecnico","","","")                    
return
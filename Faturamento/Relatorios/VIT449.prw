#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VIT448.PRWบ Autor ณ Ricardo Fiuza    บ Data ณ  26/05/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio Vendas Farma/Hospitalar por Representante        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's Informatica                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VIT449()  // U_VIT448() Chamado 004531

Private cPerg       := PADR("VIT449",Len(SX1->X1_GRUPO))
//Chama relatorio personalizado
ValidPerg1()
pergunte(cPerg,.F.)    // sem tela de pergunta

oReport := ReportDef1() // Chama a funcao personalizado onde deve buscar as informacoes
oReport:PrintDialog()  // Cria a tela de parametros no modo personalizado apos buscar as informacoes

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ Ricardo Fiuza      บ Data ณ  28/07/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA funcao estatica ReportDef devera ser criada para todos os บฑฑ
ฑฑบ          ณrelatorios que poderao ser agendados pelo usuario.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef1() //Cria o Cabe็alho em excel

Local oReport, oSection, oBreak, oSection2

cTitulo := "Relatorio Vendas por Representante - Periodo " + CVALTOCHAR(MV_PAR03)+ " a " +CVALTOCHAR(MV_PAR04)

oReport  := TReport():New("VIT449",cTitulo,"VIT449",{|oReport| PrintReport1(oReport)},cTitulo)
//oReport:SetLandscape() // Paisagem
oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio Vendas Farma/Hospitalar por Representante",{"TEMP"}, NIL, .F., .T.)
TRCell():New(oSection, "CEL01_FILIAL"        , "SD2", "Cod"           ,PesqPict("SD2","D2_FILIAL"  ),02                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_CODVEN"        , "SA3", "Cod"           ,PesqPict("SA3","A3_COD"     ),09                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_NOMVEN"        , "SA3", "Representante" ,PesqPict("SA3","A3_NOME"    ),40					 , /*lPixel*/, /* Formula*/)  
TRCell():New(oSection, "CEL04_VALOR"         , "SD2", "Valor"         ,PesqPict("SD2","D2_TOTAL"   ),14                  , /*lPixel*/, /* Formula*/)

oSection2:= TRSection():New(oReport, "Motivo Antendimentos", {"TEMP"}, NIL, .F., .T.)
TRCell():New(oSection2,"CEL01_COD"     ,"","Linha"          ,"@!" ,20,,,"left",,) 

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReportบAutor  ณ Roberto Fiuza     บ Data ณ  28/05/2013 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA funcao estatica PrintReport realiza a impressao do relato-บฑฑ
ฑฑบ          ณrio                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport1(oReport)

Local oSection := oReport:Section(1) 
Local oSection2 := oReport:Section(2)

Private aDados[04]     
Private aDados2[01] 
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {} 

oSection2:Cell("CEL01_COD"   ):SetBlock( { || aDados2[01]})

oSection:Cell("CEL01_FILIAL"   ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_CODVEN"   ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_NOMVEN"   ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_VALOR"    ):SetBlock( { || aDados[04]}) 

oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FILIAL"),,.F.)
TRFunction():New(oSection:Cell("CEL04_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := " "
_cQry += "SELECT D2_FILIAL, SUM(SD2.D2_TOTAL) TOTAL, "
_cQry += "CASE PROD.B1_APREVEN "
_cQry += "WHEN '1' THEN 'LINHA FARMA' "
_cQry += "WHEN '2' THEN 'LINHA HOSPITALAR' "
_cQry += "END LINHA,SF2.F2_VEND1 "
_cQry += "FROM " + retsqlname("SD2")+" SD2 "
_cQry += "INNER JOIN " + retsqlname("SB1")+ " PROD ON D2_COD = B1_COD "     
_cQry += "INNER JOIN " + retsqlname("SF2")+ " SF2 ON D2_DOC = F2_DOC AND D2_SERIE = D2_SERIE "   
_cQry += "WHERE PROD.D_E_L_E_T_ <> '*' "
_cQry += "AND   SF2.D_E_L_E_T_ <> '*' "
_cQry += "AND   SD2.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SF2.F2_VEND1   <> ' ' "    
_cQry += "AND   SD2.D2_FILIAL  BETWEEN '" + mv_par01 + "' AND '" +     mv_par02  + "' "
_cQry += "AND   SD2.D2_EMISSAO BETWEEN '" + DTOS(mv_par03) + "' AND '" +     DTOS(mv_par04)  + "' " 
_cQry += "AND   SF2.F2_VEND1   BETWEEN '" + mv_par05 + "' AND '" +     mv_par06  + "' "     
_cQry += "GROUP BY D2_FILIAL,B1_APREVEN, F2_VEND1 "    
_cQry += "ORDER BY D2_FILIAL,B1_APREVEN, F2_VEND1 "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"       

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf        

	oSection2:init()
            
   aDados2[01] := TMP->LINHA
       
   _linha:=TMP->LINHA                                       
   
   oSection2:Printline()
   oSection2:Finish()	 

   oSection:Init()  
      
 DO WHILE ! EOF() .AND. TMP->LINHA == _linha
 
          aDados[01] := TMP->D2_FILIAL
          aDados[02] := TMP->F2_VEND1           
          aDados[03] := Posicione("SA3",1,XFILIAL("SA3")+TMP->F2_VEND1,"A3_NOME")  
          aDados[04] := TMP->TOTAL
                                                              
          oSection:PrintLine()  // Imprime linha de detalhe                           
          aFill(aDados,nil)     // Limpa o array a dados

         dbselectarea("TMP")
         TMP->(dbSkip())
       ENDDO      
     oSection:Finish()
     oReport:ThinLine()
ENDDO

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf      
 
oSection:Finish()
oReport:SkipLine()
oReport:IncMeter() 

//oReport:SkipLine(2) 
//oReport:Say(oReport:Row(),10,"Emitente:_________________________   	   	Gestor Area:_______________________________ 		Contabilidade:____________________________      Diretoria:____________________________        Financeiro:____________________________ ") 
//oReport:SkipLine(3) 
//oReport:Say(oReport:Row(),10,"  Data:________/_______/__________        	  Data:________/_______/__________          		Data:________/_______/__________                 Data:________/_______/__________              Data:________/_______/__________ ") 


Return

//FIM FUNCOES PARA IMPRESSAO - EXCEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criacao das perguntas dos parametros                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function ValidPerg1
Local aArea    := GetArea()
Local aRegs    := {}
Local i	       := 0
Local j        := 0
Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}

aAdd(aRegs,{cPerg,"01","Filial De         ?","","","mv_ch1","C",02,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""   }) 
aAdd(aRegs,{cPerg,"02","Filial Ate        ?","","","mv_ch2","C",02,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""   })   
aAdd(aRegs,{cPerg,"03","Emissใo De        ?","","","mv_ch3","D",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""})   
aAdd(aRegs,{cPerg,"04","Emissใo Ate       ?","","","mv_ch4","D",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""})   
aAdd(aRegs,{cPerg,"05","Representante De  ?","","","mv_ch5","C",09,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA3"}) 
aAdd(aRegs,{cPerg,"06","Representante Ate ?","","","mv_ch6","C",09,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA3"})   

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
			AADD(aHelpPor,"Filial De  ?              ")
		ElseIf i==2
			AADD(aHelpPor,"Filial Ate ?              ")
		ElseIf i==3                               
			AADD(aHelpPor,"Emissใo De ?              ")
		ElseIf i==4                                
			AADD(aHelpPor,"Emissใo Ate ?             ")
		ElseIf i==5
			AADD(aHelpPor,"Representante De ?        ")
		ElseIf i==6
			AADD(aHelpPor,"Representante Ate ?       ")
		Endif
	    PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return



#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

 /*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VIT428   บ Autor ณ Ricardo Fiuza    บ Data ณ  15/10/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Notas Excluํdas (entrada ou saํda) 		      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's Informatica                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function VIT428

Private cPerg       := PADR("VIT428",Len(SX1->X1_GRUPO))
//Chama relatorio personalizado
ValidPerg()
pergunte(cPerg,.F.)    // sem tela de pergunta

oReport := ReportDef() // Chama a funcao personalizado onde deve buscar as informacoes    
oReport:PrintDialog()  // Cria a tela de parametros no modo personalizado apos buscar as informacoes

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ Ricardo Moreira    บ Data ณ  28/07/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA funcao estatica ReportDef devera ser criada para todos os บฑฑ
ฑฑบ          ณrelatorios que poderao ser agendados pelo usuario.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef() //Cria o Cabe็alho em excel

Local oReport, oSection, oBreak

  	cTitulo := "Relatorio Notas Canceladas (Entrada/Saida)"

    oReport  := TReport():New("VIT428",cTitulo,"VIT428",{|oReport| PrintReport(oReport)},cTitulo)
	oReport:SetLandscape() // Paisagem 
	oSection := TRSection():New(oReport,"Relatorio Notas Canceladas (Entrada/Saida)",{""})

TRCell():New(oSection, "CEL01_DOC"       , "SF2", "Documento"         ,PesqPict("SF2","F2_DOC"        ),10                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_SERIE"     , "SF2", "Serie"             ,PesqPict("SF2","F2_SERIE"      ),04				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_FORCLI"    , "SF2", "Forn/Cliente"      ,PesqPict("SF2","F2_CLIENTE"    ),06					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_LOJA"      , "SF2", "Loja"              ,PesqPict("SF2","F2_LOJA"       ),05 					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_NOMEFORCLI", "SF2", "Razใo Social"      ,							   "@!",50					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_VALOR"     , "SF2", "Valor"    	      ,PesqPict("SF2","F2_VALMERC"    ),16 					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_MOTEXC"    , "SF2", "Motivo"            ,PesqPict("SF2","F2_MOTEXCL"    ),10                   , /*lPixel*/, /* Formula*/,"CENTER")
TRCell():New(oSection, "CEL08_DESMOTEXC" , "SF2", "Descricao Motivo"  ,				               "@!",50					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_DTCANCEL"  , "SF2", "Data Exclusใo"     ,PesqPict("SF2","F2_DTCANCE"    ),10 					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_USUCANC"   , "SF2", "User Exclusใo"     ,PesqPict("SF2","F2_USERCAN"    ),30 					 , /*lPixel*/, /* Formula*/)  
TRCell():New(oSection, "CEL11_USUINCL"   , "SF2", "User Inclusใo"     ,PesqPict("SF2","F2_USERCAN"    ),30 					 , /*lPixel*/, /* Formula*/)

//PrintReport(oReport)
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
Static Function PrintReport(oReport)

Local oSection := oReport:Section(1)

Private aDados[11]
Private nCount    := 0
Private wTotProv  := 0
Private wTotDesc  := 0
Private wToItProv := 0
Private wToItDesc := 0
Private wToItBase := 0
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private wTGeProv  := 0
Private aDeTot    := {}
Private wTGeDesc  := 0
Private aBaTot    := {}
Private wTotVerba := 200
                   
oSection:Cell("CEL01_DOC"       ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_SERIE"     ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_FORCLI"    ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_LOJA"      ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_NOMEFORCLI"):SetBlock( { || aDados[05]})  
oSection:Cell("CEL06_VALOR"     ):SetBlock( { || aDados[06]}) 
oSection:Cell("CEL07_MOTEXC"    ):SetBlock( { || aDados[07]}) 
oSection:Cell("CEL08_DESMOTEXC" ):SetBlock( { || aDados[08]})     
oSection:Cell("CEL09_DTCANCEL"  ):SetBlock( { || aDados[09]})     
oSection:Cell("CEL10_USUCANC"   ):SetBlock( { || aDados[10]})  
oSection:Cell("CEL11_USUINCL"   ):SetBlock( { || aDados[11]})   

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf    
                                     
If MV_PAR03 = 1 //Saida                                
 _cQry := " SELECT SF2.F2_DOC DOC,SF2.F2_SERIE SERIE, SF2.F2_CLIENTE CLIFOR, SF2.F2_LOJA LOJA,(SF2.F2_VALMERC-SF2.F2_DESCONT) VALOR,SF2.F2_MOTEXCL CODMOT,
 _cQry += " SF2.F2_DTCANCE DTCAN,SF2.F2_USERCAN USUCAN, SF2.F2_DESCAN DESCMOT, SF2.F2_USERLGI USUINCL, F2_TIPO TIPO " 
 _cQry += " FROM " + RetSqlName("SF2")+" SF2 "  
 _cQry += " WHERE SF2.D_E_L_E_T_ <> ' ' "   
 _cQry += " AND SF2.F2_DTCANCE BETWEEN '"+DTOS(MV_PAR01) +"' AND '"+DTOS(MV_PAR02) +"' " 
 _cQry += " ORDER BY SF2.F2_DOC "  
EndIf

IF MV_PAR03 = 2 //Entrada
 _cQry := " SELECT SF1.F1_DOC DOC,SF1.F1_SERIE SERIE, SF1.F1_FORNECE CLIFOR, SF1.F1_LOJA LOJA,SF1.F1_VALBRUT VALOR,SF1.F1_MOTEXCL CODMOT,SF1.F1_DTCANCE DTCAN,
 _cQry += " SF1.F1_USERCAN USUCAN, SF1.F1_DESCAN DESCMOT, SF1.F1_USERLGI USUINCL, F1_TIPO TIPO " 
 _cQry += " FROM " + RetSqlName("SF1")+" SF1 "  
 _cQry += " WHERE SF1.D_E_L_E_T_ <> ' ' "   
 _cQry += " AND SF1.F1_DTCANCE BETWEEN '"+DTOS(MV_PAR01) +"' AND '"+DTOS(MV_PAR02) +"' " 
 _cQry += " ORDER BY SF1.F1_DOC "  
EndIf


_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

//MemoWrite("C:\TEMP\RELGPE101"+Dtos(MSDate())+StrTran(Time(),":","")+".txt",_Query)

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf     
		
	    cUsr := UsrFullName(substr(Alltrim(Left(Embaralha(TMP->USUINCL,1),15)),3,6))
	    
		aDados[01] := TMP->DOC
		aDados[02] := TMP->SERIE
		aDados[03] := TMP->CLIFOR
		aDados[04] := TMP->LOJA 
   		If MV_PAR03 = 1  .AND. TMP->TIPO <> "B" //Entrada 
   			aDados[05] := Posicione("SA1",1,xFilial("SA1")+TMP->CLIFOR +TMP->LOJA,"A1_NOME")	   	
		Else  
			aDados[05] := Posicione("SA2",1,xFilial("SA2")+TMP->CLIFOR +TMP->LOJA,"A2_NOME")
        EndIf    	       	
        aDados[06] := TMP->VALOR
        aDados[07] := "  "+TMP->CODMOT      
        aDados[08] := TMP->DESCMOT	
		aDados[09] := CVALTOCHAR(STOD(TMP->DTCAN)) 
		aDados[10] := TMP->USUCAN
		aDados[11] := substr(cUsr,1,30)	
		 
		oSection:PrintLine()  // Imprime linha de detalhe
		
		aFill(aDados,nil)     // Limpa o array a dados
  
	dbselectarea("TMP")
	skip
ENDDO

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf
  
	oSection:Finish()
	oReport:SkipLine()
	oReport:IncMeter()
Return

//FIM FUNCOES PARA IMPRESSAO - EXCEL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criacao das perguntas dos parametros                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function ValidPerg
Local aArea    := GetArea()
Local aRegs    := {}
Local i	       := 0
Local j        := 0
Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}


aAdd(aRegs,{cPerg,"01","Data Cancelamento De   	?","","","mv_ch1","D",08,0,0,"G","","mv_par01",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"02","Data Cancelamento Ate   ?","","","mv_ch2","D",08,0,0,"G","","mv_par02",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"03","Entrada/Saida           ?","","","mv_ch3","C",01,0,0,"C","","mv_par03","Saida"  ,"","","","","Entrada" ,"","","","","","","","","","","","","","","","","","","   "})

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
			AADD(aHelpPor,"Informe a Data Cancelamento De.      ")
		ElseIf i==2
			AADD(aHelpPor,"Informe a Data Cancelamento Ate.     ")
		ElseIf i==3		
			AADD(aHelpPor,"Frete de Entrada ou Saํda.           ")	
		Endif 
			PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return

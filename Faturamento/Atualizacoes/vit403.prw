#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ rProdRank บ Autor ณ Roberto Fiuza    บ Data ณ  17/12/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RANKING PRODUTOS VENDIDOS                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's Informatica                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VIT403

Private cPerg       := PADR("VIT403",Len(SX1->X1_GRUPO))
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

Local oReport, oSection, oBreak

cTitulo := "Rela็ใo de Notas de Debito"

oReport  := TReport():New("VIT403",cTitulo,"VIT403",{|oReport| PrintReport1(oReport)},cTitulo)
//oReport:SetLandscape() // Paisagem
oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"RANKING PRODUTOS VENDIDOS",{""})
TRCell():New(oSection, "CEL01_NUM"       	 , "SZ6", "Num"        ,PesqPict("SZ6","Z6_NUMERO"    ),06                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_MOT"           , "SZ6", "Motivo"     ,PesqPict("SZ6","Z6_MOTIVO"    ),20					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_LOCAL"         , "SZ6", "Local"      ,PesqPict("SZ6","Z6_LOCAL"     ),30                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_DATA"       	 , "SZ6", "Emissใo"    ,PesqPict("SZ6","Z6_DATA"      ),12	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_TRANS"         , "SZ6", "Transpor"   ,PesqPict("SZ6","Z6_CLI"       ),08					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_RZ"      		 , "SZ6", "Razao"      ,PesqPict("SZ6","Z6_RAZAO"     ),40                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_TEL"           , "SZ6", "Telefone"   ,PesqPict("SZ6","Z6_TEL"       ),15	  			     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_CUSTO"         , "SZ6", "Custo"      ,PesqPict("SZ6","Z6_VLPED"     ),14					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_TOT3"          , "SZ6", "Valor Nota" ,PesqPict("SZ6","Z6_TOT3"      ),14					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_DEVOL"         , "SZ6", "Nf Devol"   ,PesqPict("SZ6","Z6_DOCDEV"    ),09					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_DOCSAI"        , "SZ6", "Nf Saida"   ,PesqPict("SZ6","Z6_DOCSAI"    ),08					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL12_BAIXA"         , "SZ6", "Dt Baixa"   ,PesqPict("SZ6","Z6_BAIXA"     ),12					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL13_VLBX"          , "SZ6", "Valor Bx"   ,PesqPict("SZ6","Z6_VLPROD"    ),14					 , /*lPixel*/, /* Formula*/)

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
Private aDados[13]
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {}


oSection:Cell("CEL01_NUM"     ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_MOT"     ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_LOCAL"   ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_DATA"    ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_TRANS"   ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_RZ"      ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_TEL"     ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_CUSTO"   ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_TOT3"    ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_DEVOL"   ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_DOCSAI"  ):SetBlock( { || aDados[11]})
oSection:Cell("CEL12_BAIXA"   ):SetBlock( { || aDados[12]})
oSection:Cell("CEL13_VLBX"    ):SetBlock( { || aDados[13]})

//Faturamento por UF
//If mv_par09 == 2
// 	oBreak := TRBreak():New(oSection,oSection:Cell("CEL05_EST"),,.F.)
//	TRFunction():New(oSection:Cell("CEL07_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)

//oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FIL"),,.F.)
//TRFunction():New(oSection:Cell("CEL07_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
//EndIf
//Faturamento por Cliente

oBreak := TRBreak():New(oSection,oSection:Cell("CEL05_TRANS"),,.F.)
TRFunction():New(oSection:Cell("CEL08_CUSTO"  ),"TOT","SUM"  ,oBreak,"",PesqPict("SZ6","Z6_VLPED")   ,,.F.,.F.)
TRFunction():New(oSection:Cell("CEL09_TOT3"   ),"TOT","SUM"  ,oBreak,"",PesqPict("SZ6","Z6_TOT3")   ,,.F.,.F.)
TRFunction():New(oSection:Cell("CEL13_VLBX"   ),"TOT","SUM"  ,oBreak,"",PesqPict("SZ6","Z6_VLPROD")       ,,.F.,.F.)

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf


_cQry := " "
_cQry += "SELECT * "
_cQry += "FROM " + retsqlname("SZ6")+" SZ6 "
_cQry += "WHERE SZ6.D_E_L_E_T_ <> '*' "
_cQry += "AND   SZ6.Z6_CLI  	BETWEEN '" + mv_par01       + "' AND '" +		     mv_par02  + "' "
_cQry += "AND   SZ6.Z6_DATA     BETWEEN '" + DTOS(mv_par03) + "' AND '" +     DTOS( mv_par04)  + "' "
_cQry += "AND   SZ6.Z6_BAIXA    BETWEEN '" + DTOS(mv_par05) + "' AND '" +     DTOS( mv_par06)  + "' "
_cQry += "ORDER BY Z6_CLI, Z6_DATA "


_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	aDados[01] := TMP->Z6_NUMERO
	aDados[02] := TMP->Z6_MOTIVO
	aDados[03] := TMP->Z6_LOCAL
	aDados[04] := CVALTOCHAR(STOD(TMP->Z6_DATA)) 
	aDados[05] := TMP->Z6_CLI
	aDados[06] := TMP->Z6_RAZAO
	aDados[07] := TMP->Z6_TEL
	aDados[08] := TMP->Z6_VLPED   
	aDados[09] := TMP->Z6_TOT3   
	aDados[10] := TMP->Z6_DOCDEV   
	aDados[11] := TMP->Z6_DOCSAI
	aDados[12] := CVALTOCHAR(STOD(TMP->Z6_BAIXA))
	aDados[13] := TMP->Z6_VLPROD   
	
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
Static Function ValidPerg1
Local aArea    := GetArea()
Local aRegs    := {}
Local i	       := 0
Local j        := 0
Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}

aAdd(aRegs,{cPerg,"01","Transportadora  De   ?","","","mv_ch1","C",06,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA4"})
aAdd(aRegs,{cPerg,"02","Transportadora  Ate  ?","","","mv_ch2","C",06,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA4"})
aAdd(aRegs,{cPerg,"03","Dt Emissao De   	 ?","","","mv_ch3","D",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Dt Emissao Ate  	 ?","","","mv_ch4","D",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Dt Baixa De   		 ?","","","mv_ch5","D",10,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Dt Baixa Ate  		 ?","","","mv_ch6","D",10,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""})


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
			AADD(aHelpPor,"Informe a Transportadora Inicial.            ")
		ElseIf i==2
			AADD(aHelpPor,"Informe a Transportadora Final.              ")
		ElseIf i==3
			AADD(aHelpPor,"Informe a Data de Emissao Inicial.           ")
		ElseIf i==4
			AADD(aHelpPor,"Informe a Data de Emissao Final.             ")
		ElseIf i==5
			AADD(aHelpPor,"Informe a Data da Baixa Inicial.             ")
		ElseIf i==6
			AADD(aHelpPor,"Informe a Data da Baixa Final.               ")
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return


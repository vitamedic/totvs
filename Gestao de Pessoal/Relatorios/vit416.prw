#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VIT416   º Autor ³ Roberto Fiuza      º Data ³  04/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Rateio CC                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fiuza's Informatica                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VIT416


Private cPerg       := PADR("VIT416",Len(SX1->X1_GRUPO))
Private cMesAnoCtab := SPACE(06)
Private cAnoMesCtab := SPACE(06)
Private wHoraspDia  := 0
Private wFastEmp    := 0

//Chama relatorio personalizado
ValidPerg()
pergunte(cPerg,.F.)    // sem tela de pergunta

oReport := ReportDef() // Chama a funcao personalizado onde deve buscar as informacoes

oReport:PrintDialog()  // Cria a tela de parametros no modo personalizado apos buscar as informacoes

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³ Roberto Fiuza      º Data ³  28/07/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³A funcao estatica ReportDef devera ser criada para todos os º±±
±±º          ³relatorios que poderao ser agendados pelo usuario.          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef() //Cria o Cabeçalho em excel

Local oReport, oSection, oBreak

cTitulo := "Rateio CC"

// Parametros do TReport
// 1-Arquivo para impressao em disco
// 2-Texto cabecalho da tela
// 3-Nome Grupo SX1 para os parametros
// 4-Funcao para impressao
// 5-Texto Rodape da tela

oReport  := TReport():New("VIT416",cTitulo,"VIT416",{|oReport| PrintReport(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem
oSection := TRSection():New(oReport,"Rateio CC",{""})

TRCell():New(oSection, "CEL01_DOC"     	, "ZA7", "Documento   "   ,PesqPict("ZA7","ZA7_DOC   " ),TamSX3("ZA7_DOC"   )[1] , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_DATA"     , "ZA7", "Data        "   ,PesqPict("ZA7","ZA7_DATA"   ),TamSX3("ZA7_DATA"  )[1] , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_COD"     	, "ZA7", "Cod. Rateio "   ,PesqPict("ZA7","ZA7_COD"    ),TamSX3("ZA7_COD"   )[1] , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_DESC"     , "ZA7", "Desc.Rateio "   ,PesqPict("ZA7","ZA7_DESC"   ),TamSX3("ZA7_DESC"  )[1] , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_ITEM"     , "ZA7", "Item        "   ,PesqPict("ZA7","ZA7_ITEM"   ),TamSX3("ZA7_ITEM"  )[1] , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_MAT"     	, "ZA7", "Matricula   "   ,PesqPict("ZA7","ZA7_MAT"    ),TamSX3("ZA7_MAT"   )[1] , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_NOME"     , "ZA7", "Funcionario "   ,PesqPict("ZA7","ZA7_NOME"   ),TamSX3("ZA7_NOME"  )[1] , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_CC"     	, "ZA7", "Centro Custo"   ,PesqPict("ZA7","ZA7_CC"     ),TamSX3("ZA7_CC"    )[1] , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_CCDESC"   , "ZA7", "Desc.CC     "   ,PesqPict("ZA7","ZA7_CCDESC" ),TamSX3("ZA7_CCDESC")[1] , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_VLUNI"    , "ZA7", "Vl.Unitario "   ,"@E 999,999,999.99"          ,20                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_VLTOT"    , "ZA7", "Valor Total "   ,"@E 999,999,999.99"          ,20                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL12_INDICE"   , "ZA7", "Indice      "   ,"@E 9999.99"                 ,10                      , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL13_OBS"     	, "ZA7", "Observacao  "   ,PesqPict("ZA7","ZA7_OBS"    ),TamSX3("ZA7_OBS"   )[1] , /*lPixel*/, /* Formula*/)


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrintReportºAutor  ³ Roberto Fiuza     º Data ³  28/05/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³A funcao estatica PrintReport realiza a impressao do relato-º±±
±±º          ³rio                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrintReport(oReport)

Local oSection := oReport:Section(1)
Local nCount   := 0

Private aDados[13]

oSection:Cell("CEL01_DOC" 	):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_DATA" 	):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_COD" 	):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_DESC" 	):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_ITEM" 	):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_MAT" 	):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_NOME" 	):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_CC" 	):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_CCDESC"):SetBlock( { || aDados[09]})
oSection:Cell("CEL11_VLUNI" ):SetBlock( { || aDados[10]})
oSection:Cell("CEL10_VLTOT" ):SetBlock( { || aDados[11]})
oSection:Cell("CEL12_INDICE"):SetBlock( { || aDados[12]})
oSection:Cell("CEL13_OBS" 	):SetBlock( { || aDados[13]})


//PARA TOTALIZAR PELO objeto
oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_DOC"),"Sub Total DOC")  // imprime total do DOC cada quebra do DOC
TRFunction():New(oSection:Cell("CEL01_DOC"     ),NIL,"COUNT",oBreak)     
TRFunction():New(oSection:Cell("CEL11_VLUNI"   ),NIL,"SUM"  ,oBreak)     

//oBreak:SetPageBreak(.T.) // Define se salta a página na quebra de seção // Se verdadeiro, aponta que salta página na quebra de seção

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

aFill(aDados,nil)

If Select("QZA7") > 0
	QZA7->(dbCloseArea())
EndIf

_cQry := " SELECT * "
_cQry += " FROM " + RetSqlName("ZA7")
_cQry += " WHERE D_E_L_E_T_ = ' '"
_cQry += " AND ZA7_FILIAL BETWEEN '"+mv_par01	   +"' AND '"+mv_par02		 +"'"
_cQry += " AND ZA7_CC     BETWEEN '"+mv_par03	   +"' AND '"+mv_par04		 +"'"
_cQry += " AND ZA7_DOC    BETWEEN '"+mv_par05	   +"' AND '"+mv_par06		 +"'"
_cQry += " AND ZA7_DATA   BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08) +"'"
_cQry += " AND ZA7_COD    BETWEEN '"+mv_par09	   +"' AND '"+mv_par10		 +"'"
_cQry += " ORDER BY ZA7_DOC,ZA7_DATA,ZA7_CC,ZA7_NOME,ZA7_OBS "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "QZA7"     

tcsetfield("QZA7","ZA7_DATA","D")

dbselectarea("QZA7")
DBGOTOP()
DO WHILE ! EOF()
	
	aFill(aDados,nil)
	
	If oReport:Cancel()
		Exit
	EndIf
	
	IncProc("Centro de custo " + ZA7_CC )
	nCount++
	oReport:IncMeter(nCount)
	
	aDados[01] := ZA7_DOC
	aDados[02] := ZA7_DATA
	aDados[03] := ZA7_COD
	aDados[04] := ZA7_DESC
	aDados[05] := ZA7_ITEM
	aDados[06] := ZA7_MAT
	aDados[07] := ZA7_NOME
	aDados[08] := ZA7_CC
	aDados[09] := ZA7_CCDESC
	aDados[10] := ZA7_VLUNI
	aDados[11] := ZA7_VLTOT
	aDados[12] := ZA7_INDICE
	aDados[13] := ZA7_OBS
	
	oSection:PrintLine()  // Imprime linha de detalhe
	aFill(aDados,nil)     // Limpa o array a dados
	
	dbselectarea("QZA7")
	dbskip()
enddo


oSection:Finish()

If Select("QZA7") > 0
	QZA7->(dbCloseArea())
EndIf


Return

//FIM FUNCOES PARA IMPRESSAO - EXCEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao das perguntas dos parametros                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ValidPerg
Local aArea    := GetArea()
Local aRegs    := {}
Local i	       := 0
Local j        := 0
Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}


aAdd(aRegs,{cPerg,"01","Filial De          ?","","","mv_ch1","C",02,0,0,"G","","mv_par01",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"02","Filial Até         ?","","","mv_ch2","C",02,0,0,"G","","mv_par02",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"03","Do Centro de Custo ?","","","mv_ch3","C",09,0,0,"G","","mv_par03",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","CTT"})
aAdd(aRegs,{cPerg,"04","Ate Centro de Custo?","","","mv_ch4","C",09,0,0,"G","","mv_par04",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","CTT"})
aAdd(aRegs,{cPerg,"05","Documento De       ?","","","mv_ch5","C",09,0,0,"G","","mv_par05",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"06","Documento Ate      ?","","","mv_ch6","C",09,0,0,"G","","mv_par06",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"07","Data De            ?","","","mv_ch7","D",08,0,0,"G","","mv_par07",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"08","Data Ate           ?","","","mv_ch8","D",08,0,0,"G","","mv_par08",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"09","Codigo Rateio De   ?","","","mv_ch9","C",06,0,0,"G","","mv_par09",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"10","Codigo Rateio Ate  ?","","","mv_cha","C",06,0,0,"G","","mv_par10",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})

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
			AADD(aHelpPor,"Informe a filial inicial.          ")
		ElseIf i==2
			AADD(aHelpPor,"Informe a filial final.            ")
		ElseIf i==3
			AADD(aHelpPor,"Informe o centro de custo inicial. ")
		ElseIf i==4
			AADD(aHelpPor,"Informe o centro de custo final.   ")
		ElseIf i==5
			AADD(aHelpPor,"Competência inicial.               ")
		ElseIf i==6
			AADD(aHelpPor,"Deseja imprimir a linha de total   ")
		EndIf
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return




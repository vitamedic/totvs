#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ rProdRank บ Autor ณ Ricardo Fiuza    บ Data ณ  26/05/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Conferencia de Frete                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's Informatica                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VIT426()

Private cPerg       := PADR("VIT426",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio de Conferencia de Frete"

oReport  := TReport():New("VIT426",cTitulo,"VIT426",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem
//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio de Conferencia de Frete",{""})
TRCell():New(oSection, "CEL01_FATURA"        , "SE2", "Fatura"        ,PesqPict("SE2","E2_FATURA"  ),09                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_CTE"           , "SE2", "Num"  	      ,PesqPict("SE2","E2_NUM"     ),09					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_TRANSP"        , "SF2", "Transportadora",                             ,25                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_ESTADO"        , "SF2", "UF"            ,PesqPict("SF2","F2_EST"     ),02	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_MUNIC"         , "SA1", "Municipio"     ,PesqPict("SA1","A1_MUN"     ),25                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_CLIENTE"       , "SA1", "Cliente"       ,PesqPict("SA1","A1_NOME"    ),40					 , /*lPixel*/, /* Formula*/)
//TRCell():New(oSection, "CEL07_LOJA"          , "SD2", "Valor"        ,PesqPict("SD2","D2_TOTAL"   ),14                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_NFSAIDA"       , "SF2", "Nota"          ,PesqPict("SF2","F2_DOC"     ) ,09		  			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_VLNOTA"        , "SF2", "Valor Nota"    ,PesqPict("SF2","F2_VALBRUT" ),14                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_VLFRETE"       , "SE2", "Valor Frete"   ,PesqPict("SE2","E2_VALOR"   ),14                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_VLICMS"        , "SF1", "ICMS Frete"    ,PesqPict("SF1","F1_VALICM"  ),14                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_PERC"          , "   ", "Percentual"    ,                             ,8                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL12_PSCTE"         , "   ", "Peso CTE"      ,PesqPict("SF2","F2_PBRUTO"  ),14                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL13_PESONF"        , "SF2", "Peso Bruto"    ,PesqPict("SF2","F2_PBRUTO"  ),14                  , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL14_VOLUME"        , "SF2", "Volume"        ,								,06                  , /*lPixel*/, /* Formula*/,"RIGHT")
TRCell():New(oSection, "CEL15_MEDIA"         , "   ", "Media"         ,								,06                  , /*lPixel*/, /* Formula*/,"RIGHT")

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
Local wTotVal  := 0
Local _cont    := 0
Local _Pref    := " "
Local _TotPer  := 0


Private aDados[15]
Private _Cte  := " " 
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {}

oSection:Cell("CEL01_FATURA"    ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_CTE"       ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_TRANSP"    ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_ESTADO"    ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_MUNIC"     ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_CLIENTE"   ):SetBlock( { || aDados[06]})
//oSection:Cell("CEL07_LOJA"      ):SetBlock( { || aDados[07]})
oSection:Cell("CEL07_NFSAIDA"   ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_VLNOTA"    ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_VLFRETE"   ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_VLICMS"    ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_PERC"      ):SetBlock( { || aDados[11]})  //CEL12_PSCTE
oSection:Cell("CEL12_PSCTE"     ):SetBlock( { || aDados[12]})
oSection:Cell("CEL13_PESONF"    ):SetBlock( { || aDados[13]})
oSection:Cell("CEL14_VOLUME"    ):SetBlock( { || aDados[14]}) 
oSection:Cell("CEL15_MEDIA"     ):SetBlock( { || aDados[15]})

oBreak := TRBreak():New(oSection,oSection:Cell("CEL02_CTE"),,.F.)

TRFunction():New(oSection:Cell("CEL08_VLNOTA" ),"TOT","SUM"  ,oBreak,"",PesqPict("SF2","F2_VALBRUT") ,,.F.,.F.)
TRFunction():New(oSection:Cell("CEL09_VLFRETE"),"TOT","SUM"  ,oBreak,"",PesqPict("SE2","E2_VALOR")   ,,.F.,.F.)
TRFunction():New(oSection:Cell("CEL10_VLICMS" ),"TOT","SUM"  ,oBreak,"",PesqPict("SF1","F1_VALICM")  ,,.F.,.F.)
//TRFunction():New(oSection:Cell("CEL11_PERC"   ),"TOT","SUM"  ,oBreak,"",PesqPict("SF1","F1_VALICM")  ,,.F.,.F.)
TRFunction():New(oSection:Cell("CEL13_PESONF" ),"TOT","SUM"  ,oBreak,"",PesqPict("SF2","F2_PBRUTO")  ,,.F.,.F.)
TRFunction():New(oSection:Cell("CEL14_VOLUME" ),"TOT","SUM"  ,oBreak,"",PesqPict("SF2","F2_VOLUME1") ,,.F.,.F.)  

oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FATURA"),,.F.)
     
TRFunction():New(oSection:Cell("CEL08_VLNOTA" ),"TOT","SUM"  ,oBreak,"",PesqPict("SF2","F2_VALBRUT") ,,.F.,.F.)
TRFunction():New(oSection:Cell("CEL09_VLFRETE"),"TOT","SUM"  ,oBreak,"",PesqPict("SE2","E2_VALOR")   ,,.F.,.F.)
TRFunction():New(oSection:Cell("CEL10_VLICMS" ),"TOT","SUM"  ,oBreak,"",PesqPict("SF1","F1_VALICM")  ,,.F.,.F.)
//TRFunction():New(oSection:Cell("CEL11_PERC"   ),"TOT","SUM"  ,oBreak,"",PesqPict("SF1","F1_VALICM")  ,,.F.,.F.)
TRFunction():New(oSection:Cell("CEL13_PESONF" ),"TOT","SUM"  ,oBreak,"",PesqPict("SF2","F2_PBRUTO")  ,,.F.,.F.)
TRFunction():New(oSection:Cell("CEL14_VOLUME" ),"TOT","SUM"  ,oBreak,"",PesqPict("SF2","F2_VOLUME1") ,,.F.,.F.)  


oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

IF MV_PAR03 == 1  //ENTRADA
_cQry := " "
_cQry += "SELECT SE2.E2_FATURA FATURA, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_NUM CTE,SE2.E2_PREFIXO PREF, SF1.F1_TRANSP TRANSPORT, SF8.F8_NFORIG NF_ENTRADA, SF8.F8_SERORIG SERIE,SF8.F8_FORNECE FORNECE, "
_cQry += "SF8.F8_LOJA LOJA,SE2.E2_VALOR, SF1.F1_VALBRUT,SF1.F1_VALICM,SF1.F1_BASEICM "
_cQry += "FROM " + retsqlname("SE2")+" SE2 "
_cQry += "INNER JOIN " + retsqlname("SF8")+ " SF8 ON SF8.F8_NFDIFRE = SE2.E2_NUM AND SF8.F8_SEDIFRE = SE2.E2_PREFIXO "     
_cQry += "INNER JOIN " + retsqlname("SF1")+ " SF1 ON SF1.F1_DOC = SE2.E2_NUM AND SF1.F1_SERIE = SE2.E2_PREFIXO AND SF1.F1_FORNECE = SE2.E2_FORNECE AND SF1.F1_LOJA = SE2.E2_LOJA "   
_cQry += "WHERE SF1.D_E_L_E_T_ <> '*' "
_cQry += "AND   SF8.D_E_L_E_T_ <> '*' "
_cQry += "AND   SE2.D_E_L_E_T_ <> '*' "
_cQry += "AND   SE2.E2_FATURA  = '" + mv_par01+  "' "
_cQry += "AND   SF1.F1_TRANSP = '" + mv_par02+  "' "
_cQry += "ORDER BY SE2.E2_NUM, SF8.F8_NFORIG "   

ELSE
_cQry := " "
_cQry += "SELECT SE2.E2_FATURA FATURA, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_NUM CTE,SE2.E2_PREFIXO PREF, SF2.F2_TRANSP TRANSPORT, SF2.F2_EST ESTADO,SF2.F2_CLIENTE CLIENTE, SF2.F2_LOJA LOJA, SF2.F2_DOC ,SF2.F2_VALBRUT , "
_cQry += "SE2.E2_VALOR, SF1.F1_VALICM,(SE2.E2_VALOR/SF2.F2_VALBRUT)*100 PERC, SF2.F2_PBRUTO,SF2.F2_VOLUME1 "
_cQry += "FROM " + retsqlname("SE2")+" SE2 "
_cQry += "INNER JOIN " + retsqlname("SF2")+ " SF2 ON SF2.F2_NUMFRET = SE2.E2_NUM AND SF2.F2_SERFRET = SE2.E2_PREFIXO "     
_cQry += "INNER JOIN " + retsqlname("SF1")+ " SF1 ON SF1.F1_DOC = SE2.E2_NUM AND SF1.F1_SERIE = SE2.E2_PREFIXO AND SF1.F1_FORNECE = SE2.E2_FORNECE AND SF1.F1_LOJA = SE2.E2_LOJA "   
_cQry += "WHERE SF1.D_E_L_E_T_ <> '*' "
_cQry += "AND   SF2.D_E_L_E_T_ <> '*' "
_cQry += "AND   SE2.D_E_L_E_T_ <> '*' "
_cQry += "AND   SE2.E2_FATURA  = '" + mv_par01+  "' "
_cQry += "AND   SF2.F2_TRANSP = '" + mv_par02+  "' "
_cQry += "ORDER BY SE2.E2_NUM, SF2.F2_DOC "

ENDIF

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"       

/*
DBSELECTAREA("TMP")
DBGOTOP()   
DO WHILE ! EOF() .AND.  _Cte <> TMP->CTE .AND. _Pref <> TMP->PREF
	wTotVal := wTotVal + TMP->F2_VALBRUT
    _Cte := TMP->CTE
    _Pref := TMP->PREF
   
	SKIP
ENDDO
*/

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf        

	_Cte   := TMP->CTE
    _Forn  := TMP->E2_FORNECE
    _Lj    := TMP->E2_LOJA   
    
    IF MV_PAR03 == 1
    	_Percent := (((TMP->F1_VALBRUT*TMP->E2_VALOR)/SoVLen())/TMP->F1_VALBRUT)*100
	ELSE
	    _Percent := (( ((TMP->F2_VALBRUT*TMP->E2_VALOR)/SoVL())- ((TMP->F2_VALBRUT*TMP->E2_VALOR)/SoVL())*0.12) /TMP->F2_VALBRUT)*100
	ENDIF
	
	_cont  := _cont +1 
	_TotPer :=  _TotPer + round(_Percent,2)       

	aDados[01] := TMP->FATURA
	aDados[02] := TMP->CTE
	aDados[03] := Posicione("SA4",1,"  "+TMP->TRANSPORT,"A4_NOME") 

IF MV_PAR03 == 1 
	   aDados[04] := Posicione("SA2",1,"  "+TMP->FORNECE+TMP->LOJA,"A2_EST")
	   aDados[05] := Posicione("SA2",1,"  "+TMP->FORNECE+TMP->LOJA,"A2_MUN")
	   aDados[06] := Posicione("SA2",1,"  "+TMP->FORNECE+TMP->LOJA,"A2_NOME")  
	   aDados[07] := TMP->NF_ENTRADA
	   aDados[08] := Posicione("SF1",1,(xFilial("SF1")+TMP->NF_ENTRADA+TMP->SERIE+TMP->FORNECE+TMP->LOJA),"F1_VALBRUT") 
	   aDados[09] := (TMP->F1_VALBRUT*TMP->E2_VALOR)/SoVLen()
	   aDados[10] := ((TMP->F1_VALBRUT*TMP->E2_VALOR)/SoVLen())*(TMP->F1_VALICM/TMP->F1_BASEICM) 
	   aDados[11] := round((    ((TMP->F1_VALBRUT*TMP->E2_VALOR)/SoVLen()) - ((TMP->F1_VALBRUT*TMP->E2_VALOR)/SoVLen())*(TMP->F1_VALICM/TMP->F1_BASEICM))   /(Posicione("SF1",1,(xFilial("SF1")+TMP->NF_ENTRADA+TMP->SERIE+TMP->FORNECE+TMP->LOJA),"F1_VALBRUT"))*100,2) //round(_Percent,2)
	   aDados[12] := 0  
	   aDados[13] := 0   
	   aDados[14] := 0
	   aDados[15] := " "//round((_TotPer/_cont),2)
	   	  
	ELSE 
	   aDados[04] := TMP->ESTADO
	   aDados[05] := Posicione("SA1",1,"  "+TMP->CLIENTE+TMP->LOJA,"A1_MUN")
	   aDados[06] := Posicione("SA1",1,"  "+TMP->CLIENTE+TMP->LOJA,"A1_NOME") 
	   aDados[07] := TMP->F2_DOC
	   aDados[08] := TMP->F2_VALBRUT 	  
       aDados[09] := (TMP->F2_VALBRUT*TMP->E2_VALOR)/SoVL()
	   aDados[10] := ((TMP->F2_VALBRUT*TMP->E2_VALOR)/SoVL())*0.12  
	   aDados[11] := round((((TMP->F2_VALBRUT*TMP->E2_VALOR)/SoVL())/TMP->F2_VALBRUT)*100,2)///round(_Percent,2) 
	   aDados[12] := PesCon()
	   aDados[13] := TMP->F2_PBRUTO 
	   aDados[14] := TMP->F2_VOLUME1
       aDados[15] := " "//round((_TotPer/_cont),2)
		   
	ENDIF  
	
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

oReport:SkipLine(2) 
oReport:Say(oReport:Row(),10,"Emitente:_________________________   	   	Gestor Area:_______________________________ 		Contabilidade:____________________________      Diretoria:____________________________        Financeiro:____________________________ ") 
oReport:SkipLine(3) 
oReport:Say(oReport:Row(),10,"  Data:________/_______/__________        	  Data:________/_______/__________          		Data:________/_______/__________                 Data:________/_______/__________              Data:________/_______/__________ ") 


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

aAdd(aRegs,{cPerg,"01","Fatura Numero  ?","","","mv_ch1","C",09,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","",""    }) 
aAdd(aRegs,{cPerg,"02","Transportadora ?","","","mv_ch2","C",06,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA4"})   
aAdd(aRegs,{cPerg,"03","Entrada/Saida  ?","","","mv_ch3","N",06,0,0,"C","","mv_par03","Entrada","","","","","Saida"		  ,"","","","","","","","","","","","","","","","","","",""    })

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
			AADD(aHelpPor,"Fatura Numero.			            ")		
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return




/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo    ณ SoVL  ณAutor ณ Ricardo Fiuza's     ณData ณ 05/08/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Funcao para retornar a Soma das Notas dos CTE (saida)      ณฑฑ
ฑฑณ          ณ                                                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function SoVL
                     
//Private _G1Pvc := " "   

	_cQuery  := " "
	_cQuery  += "SELECT SUM(SF2.F2_VALBRUT) VALBRUT "
	_cQuery  += "FROM " + retsqlname("SE2")+" SE2 "
	_cQuery  += "INNER JOIN " + retsqlname("SF2")+ " SF2 ON SF2.F2_NUMFRET = SE2.E2_NUM AND SF2.F2_SERFRET = SE2.E2_PREFIXO "     
	_cQuery  += "INNER JOIN " + retsqlname("SF1")+ " SF1 ON SF1.F1_DOC = SE2.E2_NUM AND SF1.F1_SERIE = SE2.E2_PREFIXO AND SF1.F1_FORNECE = SE2.E2_FORNECE AND SF1.F1_LOJA = SE2.E2_LOJA "   
	_cQuery  += "WHERE SF1.D_E_L_E_T_ <> '*' "
	_cQuery  += "AND   SF2.D_E_L_E_T_ <> '*' "
	_cQuery  += "AND   SE2.D_E_L_E_T_ <> '*' "             
	_cQuery  += "AND   SE2.E2_NUM = '" + _Cte+  "' "
	_cQuery  += "AND   SE2.E2_FATURA = '" + mv_par01+  "' "  
	_cQuery  += "AND   SF2.F2_TRANSP = '" + mv_par02+  "' "
	_cQuery  += "ORDER BY SE2.E2_NUM, SF2.F2_DOC "   

	_cQuery :=changequery(_cQuery)
	MEMOWRIT("\sql\SoVl.sql",_cQuery)
   	tcquery _cQuery new alias "TMP3"
   	_cSomTot := tmp3->VALBRUT
	TMP3->(DBCLOSEAREA())   

return(_cSomTot)    



/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo    ณ SoVL  ณAutor ณ Ricardo Fiuza's     ณData ณ 05/08/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Funcao para retornar a Soma das Notas dos CTE              ณฑฑ
ฑฑณ          ณ                                                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function PesCon
     
	_cQue  := " "
	_cQue  += "SELECT ZZX_PSCTE PESOCTE "
	_cQue  += "FROM " + retsqlname("ZZX")+" ZZX "	
	_cQue  += "WHERE ZZX.D_E_L_E_T_ <> '*' "	          
	_cQue  += "AND   ZZX_NOTA = '" + _Cte+  "' "  
	_cQue  += "AND   ZZX_FORNEC = '" + _Forn+  "' "  
	_cQue  += "AND   ZZX_LOJA = '" + _Lj+  "' "  	
	
	_cQuery :=changequery(_cQue)
	MEMOWRIT("\sql\PesCon.sql",_cQue)
   	tcquery _cQue new alias "TMP6"
   	_cPesCH := tmp6->PESOCTE
	TMP6->(DBCLOSEAREA())   

return(_cPesCH)     

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo    ณ SoVLen  ณAutor ณ Ricardo Fiuza's     ณData ณ 05/08/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Funcao para retornar a Soma das Notas dos CTE (entrada)      ณฑฑ
ฑฑณ          ณ                                                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function SoVLen
                     
//Private _G1Pvc := " "   

	_cQuer  := " "
	_cQuer  += "SELECT SUM(SF1.F1_VALBRUT) VALBRUTen "
	_cQuer  += "FROM " + retsqlname("SF1")+" SF1 "
	_cQuer  += "INNER JOIN " + retsqlname("SF8")+ " SF8 ON SF8.F8_NFDIFRE = SF1.F1_DOC AND SF8.F8_SEDIFRE = SF1.F1_SERIE "  
	_cQuer  += "WHERE SF1.D_E_L_E_T_ <> '*' " 
	_cQuer  += "AND   SF1.F1_TIPO = 'C' "	
	_cQuer  += "AND   SF8.D_E_L_E_T_ <> '*' "       
	_cQuer  += "AND   SF8.F8_NFDIFRE = '" + _Cte+  "' "
	

	_cQuer :=changequery(_cQuer)
	MEMOWRIT("\sql\SoVlen.sql",_cQuer)
   	tcquery _cQuer new alias "TMP4"
   	_cSomToten := tmp4->VALBRUTen
	TMP4->(DBCLOSEAREA())   

return(_cSomToten)    

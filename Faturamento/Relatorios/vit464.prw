#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VIT464 บ Autor ณ Ricardo Moreira     บ Data ณ  06/09/16    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio Saldos x Custos                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Vitamedic                         			              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VIT464 //U_VIT464()

Private cPerg       := PADR("VIT464",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio de Margem do Faturamento"

oReport  := TReport():New("VIT464",cTitulo,"VIT464",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  

oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio de Margem do Faturamento",{""})
TRCell():New(oSection, "CEL01_PED"       	   , "SD2", "Pedido"              ,PesqPict("SD2","D2_PEDIDO"   ),14                     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_CLILJ"           , "SD2", "Cliente/Loja"        ,								 ,25				     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_NOME"            , "SA1", "Nome"                ,PesqPict("SA1","A1_NOME"     ),40                     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_DOC"       	   , "SD2", "Nota Fiscal"         ,PesqPict("SD2","D2_DOC"      ),15	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_MARGEM"          , "SC5", "Margem"  			  ,PesqPict("SC5","C5_MARGEM"   ),10					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_EMISSAO"         , "SD2", "Emissใo"         	  ,PesqPict("SD2","D2_EMISSAO"  ),25                     , /*lPixel*/, /* Formula*/) 
TRCell():New(oSection, "CEL07_EMISSAO"         , "SC5", "Emissใo Ped"         	  ,PesqPict("SC5","C5_EMISSAO"  ),25                     , /*lPixel*/, /* Formula*/)    // ALTERADO POR WILSON GOMES - VITAMEDIC - 03/08/2017
TRCell():New(oSection, "CEL08_VEND1"           , "SC5", "Vendedor"   		  ,PesqPict("SA3","A3_NREDUZ"   ),18	  			     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_VEND2"           , "SC5", "Gerente"      		  ,PesqPict("SA3","A3_NREDUZ"   ),18					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_COMIS1"          , "SD2", "% Vend"              ,PesqPict("SD2","D2_COMIS1"   ),12					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_COMIS2"          , "SD2", "% Geren"             ,PesqPict("SD2","D2_COMIS2"   ),12					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL12_CODITEM"         , "SD2", "Cod/Item"  		  ,								 ,20					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL13_DESC"            , "SB1", "Descri็ใo"           ,PesqPict("SB1","B1_DESC"     ),45					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL14_QUANT"           , "SD2", "Quant"    		      ,                              ,25				     , /*lPixel*/, /* Formula*/)  
//TRCell():New(oSection, "CEL14_EMISSAO"         , "SC5", "Emissใo"         	  ,PesqPict("SC5","C5_EMISSAO"  ),25                     , /*lPixel*/, /* Formula*/)    // ALTERADO POR WILSON GOMES - VITAMEDIC - 03/08/2017
//TRCell():New(oSection, "CEL14_EMISSAO"         , "SE1", "Emissใo"         	  ,PesqPict("SE1","E1_EMISSAO"  ),25                     , /*lPixel*/, /* Formula*/)    // ALTERADO POR WILSON GOMES - VITAMEDIC - 01/08/2017
TRCell():New(oSection, "CEL15_PRCVEN"          , "SD2", "Pre็o Venda"         ,                              ,25					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL16_TOTAL"           , "SD2", "Total"               ,PesqPict("SD2","D2_TOTAL"    ),25					 , /*lPixel*/, /* Formula*/,"RIGH")
//TRCell():New(oSection, "CEL16_EMISSAO"         , "SE1", "Emissใo"         	  ,PesqPict("SE1","E1_EMISSAO"  ),25                     , /*lPixel*/, /* Formula*/)    // ALTERADO POR WILSON GOMES - VITAMEDIC - 01/08/2017 // C5_EMISSAO -> DATA PEDIDO

// ****************************************************************************************************
// | Funcao    | FMatriculas |  Autor |  WILSON S GOMES     |  Data |   17/07/17  |                   |
// |**************************************************************************************************|
// | Descricao |  ALTERADO PARA ATENDER NEVA NECESSIDADE DO ROMAX PARA SR. JOSE - TRATANDO SE1                                         |
// |           |  E1_EMISSAO - ALTERADO APำS CONVERSA COM ANDREA PARA SC5 -> C5_EMISSAO                                                                                   |
// |**************************************************************************************************|


Return oReport   ///E1_EMISSAO

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReportบAutor  ณ Ricardo Moreira   บ Data ณ  28/05/2013 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA funcao estatica PrintReport realiza a impressao do relato-บฑฑ
ฑฑบ          ณrio                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport1(oReport)

Local oSection := oReport:Section(1)
Private aDados[16]     // Alterado array para 16 posi็๕es - Wilson Gomes 03/08/2017
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {}


oSection:Cell("CEL01_PED"      ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_CLILJ"    ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_NOME"     ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_DOC"      ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_MARGEM"   ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_EMISSAO"  ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_EMISSAO"  ):SetBlock( { || aDados[07]})   // ALTERADO POR WILSON GOMES - VITAMEDIC - 01/08/2017 (SE1_EMISSAO)
oSection:Cell("CEL08_VEND1"    ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_VEND2"    ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_COMIS1"   ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_COMIS2"   ):SetBlock( { || aDados[11]})
oSection:Cell("CEL12_CODITEM"  ):SetBlock( { || aDados[12]})
oSection:Cell("CEL13_DESC"     ):SetBlock( { || aDados[13]})
oSection:Cell("CEL14_QUANT"    ):SetBlock( { || aDados[14]})
//oSection:Cell("CEL14_EMISSAO"  ):SetBlock( { || aDados[14]})    // ALTERADO POR WILSON GOMES - VITAMEDIC - 01/08/2017 (SE1_EMISSAO)
oSection:Cell("CEL15_PRCVEN"   ):SetBlock( { || aDados[15]}) 
oSection:Cell("CEL16_TOTAL"    ):SetBlock( { || aDados[16]})


//Faturamento por UF
//If mv_par09 == 2
// 	oBreak := TRBreak():New(oSection,oSection:Cell("CEL05_EST"),,.F.)
//	TRFunction():New(oSection:Cell("CEL07_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)

//oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FIL"),,.F.)
//TRFunction():New(oSection:Cell("CEL07_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)     
//EndIf
//Faturamento por Cliente

//oBreak := TRBreak():New(oSection,oSection:Cell("CEL05_TRANS"),,.F.)
//TRFunction():New(oSection:Cell("CEL08_CUSTO"  ),"TOT","SUM"  ,oBreak,"",PesqPict("SZ6","Z6_VLPED")   ,,.F.,.F.)
//TRFunction():New(oSection:Cell("CEL09_TOT3"   ),"TOT","SUM"  ,oBreak,"",PesqPict("SZ6","Z6_TOT3")   ,,.F.,.F.)
//TRFunction():New(oSection:Cell("CEL13_VLBX"   ),"TOT","SUM"  ,oBreak,"",PesqPict("SZ6","Z6_VLPROD")       ,,.F.,.F.)

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

_cQry := "SELECT D2_PEDIDO, D2_CLIENTE, D2_LOJA, A1_NOME,D2_DOC, C5_MARGEM,D2_EMISSAO, C5_EMISSAO, C5_VEND1, C5_VEND2 ,D2_COMIS1, D2_COMIS2,D2_ITEM, D2_COD,B1_DESC, D2_UM, D2_QUANT, D2_PRCVEN, D2_TOTAL " // ALTERADO POR WILSON GOMES - VITAMEDIC - 01/08/2017
_cQry += "FROM " + retsqlname("SD2")+" SD2 "  
_cQry += " INNER JOIN " + retsqlname("SC5")+" SC5 ON SD2.D2_FILIAL = SC5.C5_FILIAL AND SD2.D2_PEDIDO = SC5.C5_NUM "	
_cQry += " INNER JOIN " + retsqlname("SA1")+" SA1 ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA "
_cQry += " INNER JOIN " + retsqlname("SB1")+" PRO ON SD2.D2_COD = PRO.B1_COD AND SD2.D2_FILIAL = PRO.B1_FILIAL " 
//_cQry += " INNER JOIN " + retsqlname("SE1")+" SE1 ON SD2.D2_PEDIDO = SE1.E1_PEDIDO "  // ALTERADO WILSON GOMES - VITAMEDIC - 01/08/2017
_cQry += "WHERE SC5.D_E_L_E_T_ <> '*' " 
//_cQry += "AND   SE1.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SD2.D_E_L_E_T_ <> '*' "
_cQry += "AND   SA1.D_E_L_E_T_ <> '*' " 
_cQry += "AND   PRO.D_E_L_E_T_ <> '*' "
_cQry += "AND   SD2.D2_TIPO = 'N' "
//_cQry += "AND   SC5.C5_VEND1 <> ' ' " 
_cQry += "AND   SD2.D2_CF IN ('5101','5102','6101','6102','6107','6108','6109','6110','7101') " 
_cQry += "AND   SC5.C5_VEND1 BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' " 
_cQry += "AND   SC5.C5_VEND2 BETWEEN '" + mv_par03  + "' AND '" + mv_par04  + "' "
_cQry += "AND   SD2.D2_EMISSAO	BETWEEN '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06)  + "' "
_cQry += "AND   SD2.D2_COD	BETWEEN '" + mv_par07  + "' AND '" + mv_par08  + "' "   
_cQry += "ORDER BY D2_EMISSAO,D2_DOC, D2_COD, D2_ITEM "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf	

	aDados[01] := TMP->D2_PEDIDO
	aDados[02] := TMP->D2_CLIENTE +"/"+TMP->D2_LOJA
	aDados[03] := TMP->A1_NOME
	aDados[04] := TMP->D2_DOC
	aDados[05] := TMP->C5_MARGEM 
	aDados[06] := CVALTOCHAR(STOD(TMP->D2_EMISSAO)) 
	aDados[07] := CVALTOCHAR(STOD(TMP->C5_EMISSAO))// ALTERADO WILSON GOMES - VITAMEDIC - 03/08/2017
	aDados[08] := POSICIONE("SA3",1,XFILIAL("SA3")+TMP->C5_VEND1,"A3_NREDUZ")
	aDados[09] := POSICIONE("SA3",1,XFILIAL("SA3")+TMP->C5_VEND2,"A3_NREDUZ")
	aDados[10] := TMP->D2_COMIS1 
	aDados[11] := TMP->D2_COMIS2  
	aDados[12] := alltrim(TMP->D2_COD) +"/"+TMP->D2_ITEM  
	aDados[13] := TMP->B1_DESC
	aDados[14] := TMP->D2_QUANT
	aDados[15] := ROUND(TMP->D2_PRCVEN,4)
    aDados[16] := TMP->D2_TOTAL	
	
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

aAdd(aRegs,{cPerg,"01","Vendedor de   ?","","","mv_ch1","C",06,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"02","Vendedor Ate  ?","","","mv_ch2","C",06,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"03","Gerente de    ?","","","mv_ch3","C",06,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"04","Gerente Ate   ?","","","mv_ch4","C",06,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SA3"})
aAdd(aRegs,{cPerg,"05","Emissใo de    ?","","","mv_ch5","D",10,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"06","Emissใo Ate   ?","","","mv_ch6","D",10,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"07","Produto de    ?","","","mv_ch7","C",06,0,0,"G","","mv_par07",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"08","Produto Ate   ?","","","mv_ch8","C",06,0,0,"G","","mv_par08",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})


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
			AADD(aHelpPor,"Informe o Vendedor Inicial.            ")
		ElseIf i==2
			AADD(aHelpPor,"Informe o Vendedor Final.              ")	 
		ElseIf i==3
			AADD(aHelpPor,"Informe o Gerente Final.              ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe o Gerente Final.              ")		
		ElseIf i==5
			AADD(aHelpPor,"Informe a Emissใo Final.              ")		
		ElseIf i==6
			AADD(aHelpPor,"Informe a Emissใo Final.              ")		
		ElseIf i==7
			AADD(aHelpPor,"Informe o Produto Final.              ")			
		ElseIf i==8
			AADD(aHelpPor,"Informe o Produto Final.              ")		
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return

#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VIT462 บ Autor ณ Ricardo Moreira     บ Data ณ  25/08/16    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio Saldos x Custos                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Vitamedic                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VIT462 //U_VIT462()

Private cPerg       := PADR("VIT462",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio Saldos x Custos"

oReport  := TReport():New("VIT462",cTitulo,"VIT462",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  

oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio Saldos x Custos",{""})
TRCell():New(oSection, "CEL01_PROD"       	   , "SBF", "Produto"      ,PesqPict("SBF","BF_PRODUTO"   ),14                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_LOCAL"           , "SBF", "Local"        ,PesqPict("SBF","BF_LOCAL"     ),08					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_DESC"            , "SB1", "Descricao"    ,PesqPict("SB1","B1_DESC"      ),70                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_TIPO"       	   , "SB1", "Tipo"         ,PesqPict("SB1","B1_TIPO"      ),04	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_LOCALIZ"         , "SBF", "Localiza็ใo"  ,PesqPict("SBF","BF_LOCALIZ"   ),16					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_LOTE"      	   , "SBF", "Lote"         ,PesqPict("SBF","BF_LOTECTL"   ),15                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_QUANT"           , "SBF", "Quantidade"   ,PesqPict("SBF","BF_QUANT"     ),25	  			     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_EMPENHO"         , "SBF", "Empenho"      ,PesqPict("SBF","BF_EMPENHO"   ),25					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_SALDO"           , "SBF", "Saldo" 	   ,PesqPict("SBF","BF_EMPENHO"   ),25					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_UM"              , "SB1", "UM"           ,PesqPict("SB1","B1_UM"        ),6					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_FABRIC"          , "SB8", "Fabrica็ใo"   ,PesqPict("SB8","B8_DFABRIC"   ),25					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL12_VALID"           , "SB8", "Validade"     ,PesqPict("SB8","B8_DTVALID"   ),25					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL13_DIAVENC"         , "  " , "Dias Venc"    ,                               ,15					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL14_DIAEST"          , "  " , "Dias Est"     ,                               ,15					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL15_CUSTO"           , "SB2", "Custo"        ,                               ,25					 , /*lPixel*/, /* Formula*/,"RIGH")
TRCell():New(oSection, "CEL16_CUSTDIS"         , "SB2", "Total "       ,                               ,25					 , /*lPixel*/, /* Formula*/,"RIGH")

Return oReport


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
Private aDados[16]
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {}


oSection:Cell("CEL01_PROD"      ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_LOCAL"     ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_DESC"      ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_TIPO"      ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_LOCALIZ"   ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_LOTE"      ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_QUANT"     ):SetBlock( { || aDados[07]})
oSection:Cell("CEL08_EMPENHO"   ):SetBlock( { || aDados[08]})
oSection:Cell("CEL09_SALDO"     ):SetBlock( { || aDados[09]})
oSection:Cell("CEL10_UM"        ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_FABRIC"    ):SetBlock( { || aDados[11]})
oSection:Cell("CEL12_VALID"     ):SetBlock( { || aDados[12]})
oSection:Cell("CEL13_DIAVENC"   ):SetBlock( { || aDados[13]})
oSection:Cell("CEL14_DIAEST"    ):SetBlock( { || aDados[14]}) 
oSection:Cell("CEL15_CUSTO"     ):SetBlock( { || aDados[15]})
oSection:Cell("CEL16_CUSTDIS"   ):SetBlock( { || aDados[16]})

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

_cQry := "SELECT DISTINCT  SBF.BF_PRODUTO,SBF.BF_LOCAL, PRO.B1_DESC, PRO.B1_TIPO, SBF.BF_LOCALIZ, SBF.BF_LOTECTL,SBF.BF_QUANT,SBF.BF_EMPENHO, "
_cQry += "(SBF.BF_QUANT - SBF.BF_EMPENHO) SALDO,PRO.B1_UM, to_date(SB8.B8_DFABRIC,'yyyy-mm-dd') FABRICACAO, to_date(SB8.B8_DTVALID,'yy-mm-dd') VALIDADE, "
_cQry += "round(to_date(SB8.B8_DTVALID,'yyyy-mm-dd') - sysdate,0) Dias_a_Vencer  ,round(sysdate - to_date(SB8.B8_DATA,'yyyy-mm-dd') , 0) Dias_em_Estoque "  
_cQry += "FROM " + retsqlname("SBF")+" SBF "  
_cQry += " INNER JOIN " + retsqlname("SB1")+" PRO ON SBF.BF_FILIAL = PRO.B1_FILIAL AND SBF.BF_PRODUTO = PRO.B1_COD AND SBF.BF_LOCAL = PRO.B1_LOCPAD "	
_cQry += " INNER JOIN " + retsqlname("SB8")+" SB8 ON SBF.BF_FILIAL = SB8.B8_FILIAL AND SBF.BF_PRODUTO = SB8.B8_PRODUTO AND SBF.BF_LOTECTL = SB8.B8_LOTECTL AND SBF.BF_LOCAL = SB8.B8_LOCAL"
_cQry += "WHERE SBF.D_E_L_E_T_ <> '*' " 
_cQry += "AND   PRO.D_E_L_E_T_ <> '*' "
_cQry += "AND   SB8.D_E_L_E_T_ <> '*' " 
_cQry += "AND   SB8.B8_DFABRIC <> ' ' "
_cQry += "AND   SB8.B8_DTVALID <> ' ' "
_cQry += "AND   SBF.BF_QUANT - SBF.BF_EMPENHO > 0 "
_cQry += "AND   SBF.BF_PRODUTO	BETWEEN '" + mv_par01  + "' AND '" + mv_par02  + "' "
_cQry += "ORDER BY SBF.BF_PRODUTO "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	_Cod := TMP->BF_PRODUTO
	_Loc := TMP->BF_LOCAL
	
	aDados[01] := TMP->BF_PRODUTO
	aDados[02] := TMP->BF_LOCAL
	aDados[03] := TMP->B1_DESC
	aDados[04] := TMP->B1_TIPO 
	aDados[05] := TMP->BF_LOCALIZ
	aDados[06] := TMP->BF_LOTECTL
	aDados[07] := TMP->BF_QUANT
	aDados[08] := TMP->BF_EMPENHO   
	aDados[09] := TMP->SALDO   
	aDados[10] := TMP->B1_UM   
	aDados[11] := TMP->FABRICACAO //CVALTOCHAR(STOD(TMP->FABRICACAO))
	aDados[12] := TMP->VALIDADE //CVALTOCHAR(STOD(TMP->VALIDADE))
	aDados[13] := TMP->DIAS_A_VENCER
    aDados[14] := TMP->DIAS_EM_ESTOQUE	
	aDados[15] := AllTrim(Transform(val(Custo()), "@ze 9,999,999,999,999.99"))
	aDados[16] := AllTrim(Transform(TMP->SALDO * val(Custo()), "@ze 9,999,999,999,999.99")) 
	
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

aAdd(aRegs,{cPerg,"01","Produto de   ?","","","mv_ch1","C",06,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"02","Produto Ate  ?","","","mv_ch2","C",06,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})

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
			AADD(aHelpPor,"Informe o Produto Inicial.            ")
		ElseIf i==2
			AADD(aHelpPor,"Informe o Produto Final.              ")		
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return


/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ AltQtde ณ Autor ณ Ricardo Moreira ณ          Data ณ28/07/16ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Retorna o Custo Medio Unitario      					      ณฑฑ
ฑฑณ          ณ 			                                  				  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Vitapan                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑณVersao    ณ 1.0                                                        ณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

Static Function Custo() //U_AltQtde()

Local _Custo  := " " 
Local _teste  := " "
Local aArea  := GetArea()

_cQuery 	:= " SELECT B2_CMFIM1 "
_cQuery 	+= " FROM " + retsqlname("SB2")+" SB2 "
_cQuery 	+= " WHERE SB2.D_E_L_E_T_ <> '*' "
_cQuery 	+= " AND SB2.B2_LOCAL = '"+_Loc+"'"
_cQuery 	+= " AND SB2.B2_COD = '"+_Cod+"' "

_cQuery :=changequery(_cQuery)

tcquery _cQuery new alias "TMP1"
_Custo := TMP1->B2_CMFIM1
_teste := cvaltochar(_Custo) 
TMP1->(DBCLOSEAREA())

RestArea(aArea)

return(_teste)


#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VIT433 บ Autor ณ Ricardo oberto Fiuza    บ Data ณ  26/01/16บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RANKING PRODUTOS VENDIDOS                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's Informatica                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VIT433()  //U_VIT433()

Private cPerg       := PADR("VIT433",Len(SX1->X1_GRUPO)) 
Private _lote       := " "
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

cTitulo := "Giro de Insumos"

oReport  := TReport():New("VIT433",cTitulo,"VIT433",{|oReport| PrintReport1(oReport)},cTitulo)
//oReport:SetLandscape() // Paisagem
oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Giro de Insumos",{""})
TRCell():New(oSection, "CEL01_PROD"       	 , "SB8", "Produto"     ,PesqPict("SB8","B8_PRODUTO"   ),10                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_DESCR"         , "SB1", "Descri็ใo"   ,PesqPict("SB1","B1_DESC"      ),60					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_TIPO"          , "SB1", "Tipo"        ,PesqPict("SB1","B1_TIPO"      ),04                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_LOTE"       	 , "SB8", "Lote"        ,PesqPict("SB8","B8_LOTE"      ),15	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_QTDE"          , "SB8", "Saldo"       ,PesqPict("SB8","B8_SALDO"     ),25					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_VAL"    		 , "SB8", "Validade"    ,PesqPict("SB8","B8_DTVALID"   ),20                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_DIAS"          , "   ", "Dias Sem Req",								,10	  			     , /*lPixel*/, /* Formula*/)

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReportบAutor  ณ Ricardo Fiuza     บ Data ณ  26/01/2016 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA funcao estatica PrintReport realiza a impressao do relato-บฑฑ
ฑฑบ          ณrio                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport1(oReport)

Local oSection := oReport:Section(1) 
Local _dias    := ctod(" /  /  ")
Local _difDias := " "
Private aDados[7]
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {}


oSection:Cell("CEL01_PROD"     ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_DESCR"    ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_TIPO"     ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_LOTE"     ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_QTDE"     ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_VAL"      ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_DIAS"     ):SetBlock( { || aDados[07]})

oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf


_cQry := " "
_cQry += "SELECT B8_PRODUTO, B1_DESC, B1_TIPO, B8_LOTECTL, (B8_SALDO - B8_EMPENHO) SALDO, B8_DTVALID "
_cQry += "FROM " + retsqlname("SB8")+" SB8 "
_cQry += "INNER JOIN " + retsqlname("SB1")+" SB1 ON B8_PRODUTO = B1_COD "
_cQry += "WHERE SB1.D_E_L_E_T_ <> '*' "
_cQry += "AND SB8.D_E_L_E_T_ <> '*' " 
_cQry += "AND B8_SALDO - B8_EMPENHO > 0 " 
_cQry += "AND   SB8.B8_PRODUTO	BETWEEN '" + mv_par01 + "' AND '" +	 mv_par02  + "' "
_cQry += "AND   SB8.B8_LOTECTL  BETWEEN '" + mv_par03 + "' AND '" +  mv_par04  + "' "
_cQry += "AND   SB1.B1_TIPO     BETWEEN '" + mv_par05 + "' AND '" +  mv_par06  + "' "
_cQry += "ORDER BY SB8.B8_PRODUTO "


_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf
	_lote :=  TMP->B8_LOTECTL 
	_dias := U_SaldEst()
	_difDias:= DateDiffDay(ctod(_dias),ddatabase) 
   
	aDados[01] := TMP->B8_PRODUTO
	aDados[02] := TMP->B1_DESC
	aDados[03] := TMP->B1_TIPO
	aDados[04] := TMP->B8_LOTECTL
	aDados[05] := TMP->SALDO 
	aDados[06] := CVALTOCHAR(STOD(TMP->B8_DTVALID))
	aDados[07] := _difDias
	
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

aAdd(aRegs,{cPerg,"01","Produto De   ?","","","mv_ch1","C",15,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"02","Produto Ate  ?","","","mv_ch2","C",15,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"03","Lote De    	 ?","","","mv_ch3","C",10,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB8"})
aAdd(aRegs,{cPerg,"04","Lote Ate  	 ?","","","mv_ch4","C",10,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB8"})
aAdd(aRegs,{cPerg,"05","Tipo De   	 ?","","","mv_ch5","C",02,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","02"})
aAdd(aRegs,{cPerg,"06","Tipo Ate  	 ?","","","mv_ch6","C",02,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","02"})


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
		ElseIf i==3
			AADD(aHelpPor,"Informe o Lote Inicial.               ")
		ElseIf i==4
			AADD(aHelpPor,"Informe o Lote Final.                 ")
		ElseIf i==5
			AADD(aHelpPor,"Informe o Tipo de Produto Inicial.    ")
		ElseIf i==6
			AADD(aHelpPor,"Informe o Tipo de Produto Final.      ")
		Endif
		PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
	EndIf
Next

RestArea(aArea)
Return

 
/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo    ณ EstLote  ณAutor ณ Ricardo Fiuza's    ณData ณ 26/01/16      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Funcao para Calcular os dias sem Requisi็ใo                ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
 
User Function SaldEst()

Local _lSaldo := ctod(" / / ")
 
cQuery := " SELECT D3_COD,D3_LOTECTL, MAX(D3_EMISSAO) EMISSAO "
cQuery += " FROM " + retsqlname("SD3")+" SD3 "     
cQuery += " WHERE SD3.D_E_L_E_T_ = ' ' "
cQuery += " AND D3_LOTECTL = '"+_lote+"' "
cQuery += " AND D3_CF IN ('RE6','RE1') "
cQuery += " GROUP BY D3_COD,D3_LOTECTL "
cQuery += " ORDER BY EMISSAO "
               
cQuery :=changequery(cQuery)
 
tcquery cQuery new alias "TMP3"
 _lSaldo := CVALTOCHAR(STOD(tmp3->EMISSAO))
TMP3->(DBCLOSEAREA())
 
return(_lSaldo)  
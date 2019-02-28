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

User Function VIT115_1() //U_VIT115_1()

Private cPerg       := PADR("VIT115",Len(SX1->X1_GRUPO))
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

cTitulo := "Relatorio de Produtos por Validade"

oReport  := TReport():New("VIT115",cTitulo,"VIT115",{|oReport| PrintReport1(oReport)},cTitulo)
oReport:SetLandscape() // Paisagem  

oreport:nfontbody:=8
oreport:cfontbody:= "Courier New" //"Arial"

//oReport:SetPortrait()    // Retrato
oSection := TRSection():New(oReport,"Relatorio de Produtos por Validade",{""})
TRCell():New(oSection, "CEL01_FIL"       	   , "SB1", "Filial"           ,PesqPict("SB1","B1_FILIAL"    ),04                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_COD"             , "SB1", "Codigo"           ,PesqPict("SB1","B1_COD"       ),15					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_PROD"            , "SB1", "Descricao"        ,PesqPict("SB1","B1_DESC"      ),70                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_LOTE"            , "SB8", "Lote"             ,PesqPict("SB8","B8_LOTECTL"   ),15					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_LOCALIZ"         , "SBF", "Localiza็ใo"      ,PesqPict("SBF","BF_LOCALIZ"   ),25	    			 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL06_ALMOX"           , "SBF", "Local"            ,PesqPict("SBF","BF_LOCAL"     ),10					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL07_ESTOQ"      	   , "SB8", "Estoque"          ,PesqPict("SB8","B8_SALDO"     ),25                   , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL08_EMPEN"           , "SB8", "Empenho"          ,PesqPict("SB8","B8_EMPENHO"   ),25	  			     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL09_SALDO"           , "SB8", "Saldo"            ,PesqPict("SB8","B8_SALDO"     ),25					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL10_UM"              , "SB1", "UM" 	           ,PesqPict("SB1","B1_UM"        ),04					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL11_VALID"           , "SB8", "Validade"         ,PesqPict("SB8","B8_DTVALID"   ),25					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL12_VLESTOQ"         , "SB8", "Valor Estoque"    ,PesqPict("SB8","B8_SALDO"     ),25					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL13_VLEMPEN"         , "SB8", "Valor Empenho"    ,PesqPict("SB8","B8_EMPENHO"   ),25					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL14_VLSALDO"         , "SB8", "Valor Saldo"      ,PesqPict("SB8","B8_SALDO"     ),25					 , /*lPixel*/, /* Formula*/)


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
Private aDados[14]
Private _cfilsb1 := xFilial("SB1")
Private _cfilsb8 := xFilial("SB8")
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {}
Private _VUNIT	  := 0  
Private _Valor    := 0

oSection:Cell("CEL01_FIL"       ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_COD"       ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_PROD"      ):SetBlock( { || aDados[03]}) 
oSection:Cell("CEL04_LOTE"      ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_LOCALIZ"   ):SetBlock( { || aDados[05]})
oSection:Cell("CEL06_ALMOX"     ):SetBlock( { || aDados[06]})
oSection:Cell("CEL07_ESTOQ"     ):SetBlock( { || aDados[07]}) //SUM
oSection:Cell("CEL08_EMPEN"     ):SetBlock( { || aDados[08]}) //SUM
oSection:Cell("CEL09_SALDO"     ):SetBlock( { || aDados[09]}) //SUM
oSection:Cell("CEL10_UM"        ):SetBlock( { || aDados[10]})
oSection:Cell("CEL11_VALID"     ):SetBlock( { || aDados[11]})
oSection:Cell("CEL12_VLESTOQ"   ):SetBlock( { || aDados[12]}) //SUM
oSection:Cell("CEL13_VLEMPEN"   ):SetBlock( { || aDados[13]}) //SUM
oSection:Cell("CEL14_VLSALDO"   ):SetBlock( { || aDados[14]}) //SUM

//Faturamento por UF
//If mv_par09 == 2
 	oBreak := TRBreak():New(oSection,oSection:Cell("CEL02_COD"),,.F.)
	TRFunction():New(oSection:Cell("CEL07_ESTOQ"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection:Cell("CEL08_EMPEN"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection:Cell("CEL09_SALDO"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection:Cell("CEL12_VLESTOQ"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection:Cell("CEL13_VLEMPEN"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection:Cell("CEL14_VLSALDO"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
   

	oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FIL"),,.F.)
	TRFunction():New(oSection:Cell("CEL07_ESTOQ"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection:Cell("CEL08_EMPEN"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection:Cell("CEL09_SALDO"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection:Cell("CEL12_VLESTOQ"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection:Cell("CEL13_VLEMPEN"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection:Cell("CEL14_VLSALDO"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)  
	
oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf


_cquery:=" SELECT DISTINCT BF_FILIAL FILIAL,BF_PRODUTO PRODUTO,B1_DESC DESCRI, B1_UM UM,BF_QUANT SALDO,BF_EMPENHO EMPENHO, "
_cquery+=" BF_LOTECTL LOTECTL, B8_DTVALID DTVALID, BF_LOCALIZ LOCALIZ, BF_LOCAL LOCPAD "
_cquery+=" FROM " + retsqlname("SBF")+" SBF "
_cquery+=" INNER JOIN " + retsqlname("SB1")+ " PROD ON BF_PRODUTO = B1_COD AND BF_FILIAL = B1_FILIAL " 
_cquery+=" INNER JOIN " + retsqlname("SB8")+ " SB8 ON BF_PRODUTO = B8_PRODUTO AND BF_FILIAL = B8_FILIAL AND BF_LOCAL = B8_LOCAL " 
_cquery+=" WHERE PROD.D_E_L_E_T_<>'*'"
_cquery+=" AND SB8.D_E_L_E_T_<>'*'" 
_cquery+=" AND SBF.D_E_L_E_T_<>'*'"
_cquery+=" AND B8_SALDO>0"  
_cquery+=" AND BF_QUANT>0"
_cquery+=" AND BF_LOCAL  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND BF_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B8_DTVALID BETWEEN '"+dtos(mv_par09)+"' AND '"+dtos(mv_par10)+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY BF_FILIAL, BF_PRODUTO"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP"
tcsetfield("TMP","DTVALID","D")
tcsetfield("TMP","SALDO"  ,"N",15,3)
tcsetfield("TMP","EMPENHO","N",15,3)
dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf   
	DbSelectArea ("SB2")  // Seleciona a tabela
	DbSetOrder (1)           // Pega o indice 1
	DbSeek (xFilial("SB2")+TMP->PRODUTO+TMP->LOCPAD)  // Procura o ,c๓digo do produto na tabela

	_VUNIT := SB2->B2_CM1 
	//_Valor	:= Consumo() 
	
   //	_media  := _Valor/6
	//_medadia:= _media/30 
	//_dias:=(SB2->B2_QATU-SB2->B2_QEMP)/_mediadia
	
	aDados[01] := TMP->FILIAL	
	aDados[02] := TMP->PRODUTO
	aDados[03] := TMP->DESCRI 
	aDados[04] := TMP->LOTECTL
	aDados[05] := TMP->LOCALIZ
	aDados[06] := TMP->LOCPAD
	aDados[07] := TMP->SALDO
	aDados[08] := TMP->EMPENHO 
	aDados[09] := TMP->SALDO - TMP->EMPENHO
	aDados[10] := TMP->UM
	aDados[11] := TMP->DTVALID	
	aDados[12] := TMP->SALDO * _VUNIT //B2_CM1   
	aDados[13] := TMP->EMPENHO * _VUNIT //B2_CM1    
	aDados[14] := (TMP->SALDO - TMP->EMPENHO) * _VUNIT //B2_CM1     
	        
    	
	//aDados[15] := AllTrim(Transform(val(Custo()), "@ze 9,999,999,999,999.99999"))
	//aDados[16] := AllTrim(Transform(TMP->SALDO * val(Custo()), "@ze 9,999,999,999,999.99")) 
	
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


aAdd(aRegs,{cPerg,"01","Produto de   ?","","","mv_ch1","C",15,0,0,"G","","mv_par01",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"02","Produto Ate  ?","","","mv_ch2","C",15,0,0,"G","","mv_par02",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{cPerg,"03","Do tipo de   ?","","","mv_ch3","C",02,0,0,"G","","mv_par03",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","02 "})
aAdd(aRegs,{cPerg,"04","Do tipo ate  ?","","","mv_ch4","C",02,0,0,"G","","mv_par04",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","02 "})
aAdd(aRegs,{cPerg,"05","Do Grupo de  ?","","","mv_ch5","C",04,0,0,"G","","mv_par05",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SBM"})
aAdd(aRegs,{cPerg,"06","Do Grupo Ate ?","","","mv_ch6","C",04,0,0,"G","","mv_par06",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","SBM"})
aAdd(aRegs,{cPerg,"07","Armazem de   ?","","","mv_ch7","C",04,0,0,"G","","mv_par07",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"08","Armazem Ate  ?","","","mv_ch8","C",04,0,0,"G","","mv_par08",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"09","De Validade  ?","","","mv_ch9","C",08,0,0,"G","","mv_par09",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})
aAdd(aRegs,{cPerg,"10","Ate Validade ?","","","mv_chA","C",08,0,0,"G","","mv_par10",""	  ,"","","","",""			  ,"","","","","","","","","","","","","","","","","","","   "})

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
			AADD(aHelpPor,"Informe o Tipo Inicial.              ")		
		ElseIf i==4
			AADD(aHelpPor,"Informe o Tipo Final.              ") 
		ElseIf i==5
			AADD(aHelpPor,"Informe o Grupo Inicial.              ")
		ElseIf i==6
			AADD(aHelpPor,"Informe o Grupo Final.              ")
		ElseIf i==7
			AADD(aHelpPor,"Informe o Armazem Inicial.              ")
		ElseIf i==8
			AADD(aHelpPor,"Informe o Armazem Final.              ")
		ElseIf i==9
			AADD(aHelpPor,"Informe a Validade Inicial.              ")
		ElseIf i==10
			AADD(aHelpPor,"Informe a Validade Final.              ")
					
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
ฑฑณDescricao ณ Retorna a Media Custo Medio Unitario      					      ณฑฑ
ฑฑณ          ณ 			                                  				  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Vitapan                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑณVersao    ณ 1.0                                                        ณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
/*
Static Function Consumo() //()

Local _Cons    := " " 
Local _dataref := date() - 183
Local aArea    := GetArea() 

	

_cQuery 	:= " SELECT SUM(D3_QUANT) Consumo "
_cQuery 	+= " FROM " + retsqlname("SD3")+" SD3 "
_cQuery 	+= " WHERE SD3.D_E_L_E_T_ <> '*' "
_cQuery 	+= " AND SD3.D3_LOCAL = '"+TMP->LOCPAD+"'"
_cQuery 	+= " AND SD3.D3_COD = '"+TMP->PRODUTO+"' "   
_cQuery 	+= " AND SUBSTR(SD3.D3_CF,1,1) = 'R' "
_cQuery 	+= " AND SD3.D3_ESTONO <> 'S' "       
_cQuery     += " AND SD3.D3_EMISSAO BETWEEN '"+_dataref+"' AND '"+ddatabase+"'"

_cQuery :=changequery(_cQuery)

tcquery _cQuery new alias "TMP1"
_Cons := TMP1->Consumo

TMP1->(DBCLOSEAREA())

RestArea(aArea)

return(_Cons)
*/

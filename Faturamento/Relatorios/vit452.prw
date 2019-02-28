#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
*****************************************************************************
*  Programa  | VIT452   | Autor | Roberto Fiuza         | Data | 14/06/16   *
*****************************************************************************
*  Descricao �Pedidos Pendentes                                             *
*****************************************************************************
*  Uso       � VITAMEDIC                                                    *
*****************************************************************************
*/

User Function VIT452 //u_vit452()

	Private cPerg    := PADR("PVIT452ADM",Len(SX1->X1_GRUPO))
	Private wNomeCli := ""
	Private _nqtdlib := 0 

	Private wTCliQtd := 0
	Private wTCliPen := 0
	Private wTCliVal := 0
	Private wTCliCid := ""
	Private wCliEst  := ""
	Private wTCliEst := 0 
	
	Private wTRepQtd := 0
	Private wTRepPen := 0
	Private wTRepVal := 0
	Private wTRepEst := 0

	Private wTTotQtd := 0
	Private wTTotPen := 0
	Private wTTotVal := 0
	Private wTTotEst := 0


	dbselectarea("SA3")
	dbsetorder(7)  // A3_FILIAL+A3_CODUSR
	if dbseek( xfilial("SA3") + __cuserid )
		IF EMPTY(A3_SUPER)  // se for supervisor
			cPerg       := PADR("PVIT452SUR",Len(SX1->X1_GRUPO))
		ELSE                // se for vendedor
			cPerg       := PADR("PVIT452VED",Len(SX1->X1_GRUPO))
		ENDIF
	endif

//Chama relatorio personalizado
	ValidPerg()
	pergunte(cPerg,.T.)    // sem tela de pergunta

	oReport := ReportDef() // Chama a funcao personalizado onde deve buscar as informacoes

	oReport:PrintDialog()  // Cria a tela de parametros no modo personalizado apos buscar as informacoes

Return

/*
****************************************************************************************
*     Programa |  ReportDef | Autor  |  Roberto Fiuza      |  Data  |  28/05/2016      *
****************************************************************************************
*     Desc.    |  A funcao estatica ReportDef devera ser criada para todos os          *
*              |  relatorios que poderao ser agendados pelo usuario.                   *
****************************************************************************************
*/
Static Function ReportDef() //Cria o Cabeçalho em excel

	Local oReport, oSection, oBreak
	Local wnrel    := "VIT452"+upper(Alltrim(cusername))
	
	wnrel := StrTran(wnrel,".","_")

	cTitulo := "Pedidos pendentes " + " Periodo: "+ cValToChar(mv_par01) + '  ate  ' + cValToChar(mv_par02)

// Parametros do TReport
// 1-Arquivo para impressao em disco
// 2-Texto cabecalho da tela
// 3-Nome Grupo SX1 para os parametros
// 4-Funcao para impressao
// 5-Texto Rodape da tela        

	oReport  := TReport():New(wnrel,cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)
    
	//Define tamanho e tipo da fonte
	oReport:nfontbody:=10
	//oReport:cfontbody:="Times"
	
	//Define formato da impress�o
	//oReport:SetLandscape() // Paisagem
	oReport:SetPortrait() //Retrato
	oReport:lBold := .T.
		
	oSection := TRSection():New(oReport,"Pedidos pendentes",{""})

	TRCell():New(oSection, "CEL01_PED"     , "SC5", "PEDIDO  DATA      	CODIGO   	DESCRI��O	","@!",66,,,"LEFT")  // 70
	TRCell():New(oSection, "CEL10_QVE"     , "SC6", "Q.PEDIDO"        ,                        ,13     , /*lPixel*/, /* Formula*/,"CENTER")
	TRCell():New(oSection, "CEL11_QEN"     , "SC6", "Q.PENDEN"      ,""                      ,13     , /*lPixel*/, /* Formula*/,"CENTER")
	//TRCell():New(oSection, "CEL12_PRC"     , "SRV", "VALOR PENDENTE"    ,"@E 999,999,999.99"   ,20     , /*lPixel*/, /* Formula*/,"RIGHT")
	TRCell():New(oSection, "CEL12_PRC"     , "SRV", "VL.PENDENT(R$) "    ,"@E 999,999,999.99"   ,20     , /*lPixel*/, /* Formula*/,"RIGHT")
	//TRCell():New(oSection, "CEL13_CVE"     , "SRC", "SALDO ESTOQUE"     ,"@E 999,999,999.99"   ,20     , /*lPixel*/, /* Formula*/,"RIGHT")
	TRCell():New(oSection, "CEL13_CVE"     , "SRC", "SALDO ESTOQUE"     ,""   ,20     , /*lPixel*/, /* Formula*/,"RIGHT")
	
Return oReport

/*
*******************************************************************************
*  Programa  | PrintReport         |  Roberto Fiuza     |  Data | 28/05/2016  *
*******************************************************************************
*  Desc.     | A funcao estatica PrintReport realiza a impressao do relatorio *
*******************************************************************************
*/

Static Function PrintReport(oReport)

	Local oSection := oReport:Section(1)
	Local nSkip := 1
	Local oBreak
	
	Private aDados[08]
	Private nCount      := 0

	oSection:Cell("CEL01_PED" ):SetBlock( { || aDados[01]})
	oSection:Cell("CEL10_QVE" ):SetBlock( { || aDados[02]})
	oSection:Cell("CEL11_QEN" ):SetBlock( { || aDados[03]})
	oSection:Cell("CEL12_PRC" ):SetBlock( { || aDados[04]})
	oSection:Cell("CEL13_CVE" ):SetBlock( { || aDados[05]})

// PARA TOTALIZAR PELO objeto
//oBreak := TRBreak():New(oSection,oSection:Cell("TOT.REPR"),"Total repr")  // imprime total do CC cada quebra do CC
//TRFunction():New(oSection:Cell("CEL01_PED"   ),NIL,"COUNT",oBreak)

//TRFunction():New(oSection:Cell("TOT_REPR" ),NIL,"SUM"  ,oBreak)
//TRFunction():New(oSection:Cell("CEL11_QEN" ),NIL,"SUM"  ,oBreak)
//TRFunction():New(oSection:Cell("CEL13_CVE" ),NIL,"SUM"  ,oBreak)

//oBreak:SetPageBreak(.T.) // Define se salta a página na quebra de seção // Se verdadeiro, aponta que salta página na quebra de seção

	//oReport:SkipLine("1")
	oReport:IncMeter()
	oReport:NoUserFilter()
	oSection:Init()


	aFill(aDados,nil)
	
  
	dbselectarea("SA3")
	dbsetorder(7)  // A3_FILIAL+A3_CODUSR
	if dbseek( xfilial("SA3") + __cuserid )
		IF EMPTY(A3_SUPER)  // se for supervisor
			mv_par15 := 3
			mv_par11 := A3_COD
			mv_par12 := A3_COD
			mv_par13 := "      "
			mv_par14 := "ZZZZZZ"
		ELSE                // se for vendedor
			mv_par09 := A3_COD
			mv_par10 := A3_COD
			mv_par15 := 3
			mv_par11 := A3_SUPER
			mv_par12 := A3_SUPER
			mv_par13 := "      "
			mv_par14 := "ZZZZZZ"
		ENDIF
	endif
 
	dbselectarea("SA3")
	dbsetorder(2) // Nome
	DBGOTOP()

	DO WHILE ! EOF()
	
		If oReport:Cancel()
			Exit
		EndIf
	
		// Vendedor
		if SA3->A3_COD < mv_par09 .OR. SA3->A3_COD > mv_par10
			skip
			loop
		endif
		// Gerente (Supervisor)
		if SA3->A3_SUPER < mv_par11 .OR. SA3->A3_SUPER > mv_par12
			skip
			loop
		endif
		// Diretor (Gerente)
		if SA3->A3_GEREN < mv_par13 .OR. SA3->A3_GEREN > mv_par14
			skip
			loop
		endif
		
	
		If CHKFILE("T452")
			T452->(DBCLOSEAREA())
		EndIf
	
		_cQry := "SELECT C5_NUM,C5_EMISSAO,C5_CLIENTE,A1_LOJA,A1_NOME,A1_MUN,A1_EST,C6_PRODUTO,C6_DESCRI,C6_ITEM,C6_LOCAL,C6_QTDVEN,C6_QTDENT,C6_PRCVEN "
		_cQry += "FROM "+RetSqlName("SC5")+" SC5 "
		_cQry += "INNER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.C6_NUM  = SC5.C5_NUM  "
		_cQry += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD  = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI "
		_cQry += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_COD  = SC6.C6_PRODUTO "
		_cQry += "WHERE SC5.D_E_L_E_T_ = ' ' "
		_cQry += "AND SC6.D_E_L_E_T_ = ' ' "
		_cQry += "AND SA1.D_E_L_E_T_ = ' ' "
		_cQry += "AND SB1.D_E_L_E_T_ = ' ' "
		_cQry += "AND SC5.C5_FILIAL  = '" + xFilial("SC5") + "' "
		_cQry += "AND SC6.C6_FILIAL  = '" + xFilial("SC6") + "' "
		_cQry += "AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "' "
		_cQry += "AND SC5.C5_VEND1   = '" + SA3->A3_COD    + "' "
		_cQry += "AND SC5.C5_EMISSAO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
		_cQry += "AND SC5.C5_CLIENTE BETWEEN '" + mv_par03 + "' AND '" + mv_par05 + "'"
		_cQry += "AND SC5.C5_LOJACLI BETWEEN '" + mv_par04 + "' AND '" + mv_par06 + "'"
		_cQry += "AND SC5.C5_NUM     BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'"
		_cQry += "AND SC6.C6_QTDVEN-SC6.C6_QTDENT > 0  "
		_cQry +=" AND SC6.C6_BLQ <> 'R ' "

		if mv_par15 = 1     // PA
			_cQry += "AND SB1.B1_TIPO = 'PA' "
		elseif mv_par15 = 2 // PN
			_cQry += "AND SB1.B1_TIPO = 'PN' "
		endif
		_cQry += "ORDER BY A1_NOME,C5_NUM,C6_DESCRI  "
		
		MemoWrite( "c:/totvs/vit452.txt", _cQry )
	
		_cQry := ChangeQuery(_cQry)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,_cQry), 'T452', .T., .T.)
	
		dbselectarea("T452")
		DBGOTOP()
	
		IF EOF()
			dbselectarea("SA3")
			SKIP
			LOOP
		ENDIF
	
		aFill(aDados,nil)
	//A3_GEREN  
				
		wRepre := "Rep.: " + SA3->A3_COD +"-"+ alltrim(SA3->A3_NOME) 
		wSupervisor := SA3->A3_SUPER      
		
		
		dbselectarea("SA3")
		wRecno := recno()
		dbsetorder(1)
		dbseek( xfilial("SA3") + wSupervisor )
		aDados[01] := wRepre 
		oSection:PrintLine()  // Imprime linha 

		aDados[01] := "Ger.: " + SA3->A3_COD  +"-"+ SA3->A3_NOME  
		oSection:PrintLine()  // Imprime linha 

		aDados[01] := " " 
		oSection:PrintLine()  // Imprime linha 

				
		dbselectarea("SA3")
		dbsetorder(2)
		goto wRecno          
	   //	oSection:PrintLine()  //Imprime linha de detalhe		

		DO WHILE ! EOF()
			wNomeCli := T452->A1_NOME 
			wTCliCid := T452->A1_MUN
			wCliEst  := T452->A1_EST
            
			aDados[01] := "CLIENTE: " + substr(wNomeCli,1,20) +" Cid.: "+ alltrim(substr(wTCliCid,1,20)) +"-"+ alltrim(wCliEst) 
			oSection:PrintLine()  // Imprime linha 
			
			aDados[01] := " " 
			oSection:PrintLine()  // Imprime linha 
			
			do while ! eof() .AND. T452->A1_NOME = wNomeCli .AND. T452->A1_MUN = wTCliCid .AND. T452->A1_EST = wCliEst
			
				aFill(aDados,nil)
			
				dbselectarea("SB2")
				dbsetorder(1)
				dbseek( xfilial("SB2") + T452->C6_PRODUTO + T452->C6_LOCAL )
			
				IncProc("Representante:  " + SA3->A3_COD +" "+ SA3->A3_NOME)
				
				nCount++
				oReport:IncMeter(nCount)

				dbselectarea("SC9")
				dbsetorder(1)
				dbseek( xfilial("SC9") + T452->C5_NUM + T452->C6_ITEM )
				_nqtdlib := 0 
				do while ! sc9->(eof()) .and. sc9->c9_filial = xfilial("SC9") .and. sc9->c9_pedido = T452->C5_NUM .and. sc9->c9_item = T452->C6_ITEM
					if empty(sc9->c9_nfiscal) .and. empty(sc9->c9_blcred) .and. empty(sc9->c9_blest)
						_nqtdlib += sc9->c9_qtdlib
					endif
					sc9->(dbskip())
				enddo
   
				wQtdPend := T452->C6_QTDVEN - ( T452->C6_QTDENT + _nqtdlib )
			    
			    
		
				aDados[01] := T452->C5_NUM +"	"+ dtoc(STOD( T452->C5_EMISSAO )) +"		"+ Alltrim(T452->C6_PRODUTO) +"       "+ T452->C6_DESCRI
				aDados[02] := T452->C6_QTDVEN
				aDados[03] := wQtdPend
				aDados[04] := wQtdPend * T452->C6_PRCVEN
				aDados[05] := sb2->b2_qatu - sb2->b2_reserva - sb2->b2_qemp
				aDados[06] := T452->A1_MUN
				aDados[07] := T452->A1_EST
				
				wTCliQtd := wTCliQtd + aDados[02]
				wTCliPen := wTCliPen + aDados[03]
				wTCliVal := wTCliVal + aDados[04]
				wTCliEst := wTCliEst + aDados[05]
				wTCliCid := aDados[06]
				wCliEst  := aDados[07]
			
				wTRepQtd := wTRepQtd + aDados[02]
				wTRepPen := wTRepPen + aDados[03]
				wTRepVal := wTRepVal + aDados[04]
				wTRepEst := wTRepEst + aDados[05]
			
				wTTotQtd := wTTotQtd + aDados[02]
             	wTTotPen := wTTotPen + aDados[03]
				wTTotVal := wTTotVal + aDados[04]
				wTTotEst := wTTotEst + aDados[05]
				
			
				
				/*
				aDados[02] := dtoc(STOD( T452->C5_EMISSAO ))
				aDados[03] := T452->C5_CLIENTE
				aDados[04] := T452->A1_LOJA
				aDados[05] := T452->A1_NOME
				aDados[06] := T452->A1_MUN
				aDados[07] := T452->A1_EST
			    aDados[08] := T452->C6_PRODUTO
				aDados[09] := T452->C6_DESCRI
				aDados[10] := T452->C6_QTDVEN
				aDados[11] := wQtdPend
				aDados[12] := wQtdPend * T452->C6_PRCVEN
				aDados[13] := sb2->b2_qatu - sb2->b2_reserva - sb2->b2_qemp
			    				
				wTCliQtd := wTCliQtd + aDados[10]
				wTCliPen := wTCliPen + aDados[11]
				wTCliVal := wTCliVal + aDados[12]
				wTCliEst := wTCliEst + aDados[13]
			
				wTRepQtd := wTRepQtd + aDados[10]
				wTRepPen := wTRepPen + aDados[11]
				wTRepVal := wTRepVal + aDados[12]
				wTRepEst := wTRepEst + aDados[13]
			
				wTTotQtd := wTTotQtd + aDados[10]
             	wTTotPen := wTTotPen + aDados[11]
				wTTotVal := wTTotVal + aDados[12]
				wTTotEst := wTTotEst + aDados[13]
			    */
			    
				oSection:PrintLine()  // Imprime linha de detalhe 
				aFill(aDados,nil)     // Limpa o array a dados     

							
				dbselectarea("T452")
				dbskip()
			enddo
		
			//aDados[01] := " " 
			//oSection:PrintLine()  // Imprime linha
				
			aDados[01] := "TOTAL:" //+ substr(wNomeCli,1,20) +" Cid.:"+ alltrim(substr(wTCliCid,1,20)) +"-"+ alltrim(wCliEst) 
			aDados[02] := wTCliQtd
			aDados[03] := wTCliPen
			aDados[04] := wTCliVal
			aDados[05] := wTCliEst
			/*
			aDados[10] := wTCliQtd
			aDados[11] := wTCliPen
			aDados[12] := wTCliVal
			aDados[13] := wTCliEst
			*/
			oSection:PrintLine()  // Imprime linha de detalhe
			aFill(aDados,nil)     // Limpa o array a dados
		
		
			wTCliQtd := 0
			wTCliPen := 0
			wTCliVal := 0
			wTCliEst := 0
			
			oSection:PrintLine()  // Imprime linha em branco
		
		ENDDO
	
		dbselectarea("SA3")
	
		aDados[01] := "TOT.REPR.: " + SA3->A3_COD + "-" + SA3->A3_NOME
		aDados[02] := wTRepQtd
		aDados[03] := wTRepPen
		aDados[04] := wTRepVal
		aDados[05] := wTRepEst

		oSection:PrintLine()  // Imprime linha de detalhe
		        
		aFill(aDados,nil)     // Limpa o array a dados
	
		wTRepQtd := 0
		wTRepPen := 0
		wTRepVal := 0
		wTRepEst := 0

		oSection:PrintLine()  // Imprime linha em branco     

		dbskip()                     
        oSection:Finish()       // imprimiu novo cabecalho 10/08/16
        oSection:SetPageBreak(.T.) // Define se salta a página na quebra de seção // Se verdadeiro, aponta que salta página na quebra de seção


		oSection:Init()

	enddo

	aDados[01] := "TOTAL GERAL "
	aDados[02] := wTTotQtd
	aDados[03] := wTTotPen
	aDados[04] := wTTotVal
	aDados[05] := wTTotEst
	
	/*
	aDados[10] := wTTotQtd
	aDados[11] := wTTotPen
	aDados[12] := wTTotVal
	aDados[13] := wTTotEst
	*/  
	

	oSection:PrintLine()  // Imprime linha de detalhe 
	
	aFill(aDados,nil)     // Limpa o array a dados

	wTTotQtd := 0
	wTTotPen := 0
	wTTotVal := 0
	wTTotEst := 0           
    oSection:Finish()

Return


/*
*******************************************************************************
*  Funcao    | ValidPerg           |  Roberto Fiuza     |  Data | 28/05/2016  *
*******************************************************************************
*  Desc.     | Criacao das perguntas                                          *
*******************************************************************************
*/

Static Function ValidPerg
	_agrpsx1:={}

	aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"03","Do cliente         ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
	aadd(_agrpsx1,{cperg,"04","Da loja            ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"05","Ate o cliente      ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
	aadd(_agrpsx1,{cperg,"06","Ate a loja         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"07","Do pedido          ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"08","Ate o pedido       ?","mv_ch8","C",06,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

	IF ALLTRIM(cperg) = "PVIT452SUR" .OR. ALLTRIM(cperg) = "PVIT452ADM" // se for Gerente OU Administracao
		aadd(_agrpsx1,{cperg,"09","Do vendedor        ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
		aadd(_agrpsx1,{cperg,"10","Ate o vendedor     ?","mv_cha","C",06,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
	ENDIF
	
	IF ALLTRIM(cperg) = "PVIT452ADM"   // Se for da Administracao
		aadd(_agrpsx1,{cperg,"11","Do Gerente         ?","mv_chb","C",06,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
		aadd(_agrpsx1,{cperg,"12","Ate o Gerente      ?","mv_chc","C",06,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
		aadd(_agrpsx1,{cperg,"13","Do Diretor         ?","mv_chd","C",06,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
		aadd(_agrpsx1,{cperg,"14","Ate o Diretor      ?","mv_che","C",06,0,0,"G",space(60),"mv_par14"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
		aadd(_agrpsx1,{cperg,"15","Tipo Produto       ?","mv_chf","N",01,0,0,"C",space(60),"mv_par15"       ,"PA"             ,space(30),space(15),"PN"             ,space(30),space(15),"Todos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	ENDIF
	
	for _i:=1 to len(_agrpsx1)
		if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
			sx1->(reclock("SX1",.t.))
			sx1->x1_grupo  :=_agrpsx1[_i,01]
			sx1->x1_ordem  :=_agrpsx1[_i,02]
			sx1->x1_pergunt:=_agrpsx1[_i,03]
			sx1->x1_variavl:=_agrpsx1[_i,04]
			sx1->x1_tipo   :=_agrpsx1[_i,05]
			sx1->x1_tamanho:=_agrpsx1[_i,06]
			sx1->x1_decimal:=_agrpsx1[_i,07]
			sx1->x1_presel :=_agrpsx1[_i,08]
			sx1->x1_gsc    :=_agrpsx1[_i,09]
			sx1->x1_valid  :=_agrpsx1[_i,10]
			sx1->x1_var01  :=_agrpsx1[_i,11]
			sx1->x1_def01  :=_agrpsx1[_i,12]
			sx1->x1_cnt01  :=_agrpsx1[_i,13]
			sx1->x1_var02  :=_agrpsx1[_i,14]
			sx1->x1_def02  :=_agrpsx1[_i,15]
			sx1->x1_cnt02  :=_agrpsx1[_i,16]
			sx1->x1_var03  :=_agrpsx1[_i,17]
			sx1->x1_def03  :=_agrpsx1[_i,18]
			sx1->x1_cnt03  :=_agrpsx1[_i,19]
			sx1->x1_var04  :=_agrpsx1[_i,20]
			sx1->x1_def04  :=_agrpsx1[_i,21]
			sx1->x1_cnt04  :=_agrpsx1[_i,22]
			sx1->x1_var05  :=_agrpsx1[_i,23]
			sx1->x1_def05  :=_agrpsx1[_i,24]
			sx1->x1_cnt05  :=_agrpsx1[_i,25]
			sx1->x1_f3     :=_agrpsx1[_i,26]
			sx1->(msunlock())
		endif
	next

Return
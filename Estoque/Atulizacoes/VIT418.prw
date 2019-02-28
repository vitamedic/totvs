//------------------------------------------------------------------------
//Autor: Ricardo Moreira de Lima
//Data: 04/05/2015
//Função: RFIN010.PRW
//Descrição: Relatório para extrair dados estoque para inventario,
//
//------------------------------------------------------------------------

#Include 'Protheus.ch'
#include 'TopConn.ch'
#INCLUDE "TBICONN.CH"
User Function VIT418() // u_VIT418()
	Local aItensExcel :={}
	private aCabExcel :={}
	Private cPerg := "VIT418"
	
	// Gera Perguntas
	geraX1()
	
	// Inicia as perguntas
	Pergunte(cPerg, .T.,"Parametros do Resumo")
	
	//Definio cabeçalho	
	aAdd(aCabExcel, {"Cod_Produto" 		    ,"C",TamSX3("BF_PRODUTO") [1], 0})
    aAdd(aCabExcel, {"Unidade"	            ,"C",TamSX3("B1_UM")      [1], 0})
	aAdd(aCabExcel, {"Descricao"	        ,"C",TamSX3("B1_DESC")    [1], 0})
	aAdd(aCabExcel, {"Tipo"					,"C",TamSX3("B1_TIPO")    [1], 0})
	aAdd(aCabExcel, {"Grupo"				,"C",TamSX3("BM_DESC")    [1], 0})
	aAdd(aCabExcel, {"Armazem"				,"C",TamSX3("BF_LOCAL")   [1], 0})
	aAdd(aCabExcel, {"Endereco"	 	        ,"C",TamSX3("BF_LOCALIZ") [1], 0})
	aAdd(aCabExcel, {"Rua"  				,"C",02, 0})
	aAdd(aCabExcel, {"Box"					,"C",02, 0})
	aAdd(aCabExcel, {"Nivel"				,"C",01, 0})
	aAdd(aCabExcel, {"Nivel"				,"C",01, 0})
	aAdd(aCabExcel, {"Lote"					,"C",TamSX3("BF_LOTECTL") [1], 0})
	aAdd(aCabExcel, {"Validade"				,"D",TamSX3("B8_DTVALID") [1], 0})
	aAdd(aCabExcel, {"Valido/Vencido"		,"C",20, 0})	
	aAdd(aCabExcel, {"Quantidade1"	  		,"N",TamSX3("BF_QUANT")   [1], 5})
	aAdd(aCabExcel, {"Conversao"	   		,"C",TamSX3("B1_TIPCONV") [1], 0})
	aAdd(aCabExcel, {"Fator_Conv"			,"N",TamSX3("B1_CONV")    [1], 2})
	aAdd(aCabExcel, {"Empenho" 				,"N", TamSX3("BF_EMPENHO")[1], 5})
	aAdd(aCabExcel, {"Saldo"   				,"N", TamSX3("BF_EMPENHO")[1], 5})
	aAdd(aCabExcel, {"Custo_Medio" 			,"N", TamSX3("B2_CM1")    [1], 2})
	aAdd(aCabExcel, {"Contagem_01" 			,"C", 15, 0}) 
	aAdd(aCabExcel, {"Contagem_02" 			,"C", 15, 0}) 
	aAdd(aCabExcel, {"Contagem_03" 			,"C", 15, 0}) 
	aAdd(aCabExcel, {"USERLGI" 		   		,"C", 15, 0}) 
	aAdd(aCabExcel, {"USERLGA" 		   		,"D", 15, 0})          
	
	MsgRun("Favor Aguardar.....", "Selecionando os Registros",;
		{|| GPItens(@aItensExcel)})
	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
		{||DlgToExcel({{"GETDADOS",;
		"PLANILHA DE DADOS ESTOQUE!",;
		aCabExcel,aItensExcel}})})
Return   

// --------------------------------------------
// Compõe o array aCols
// --------------------------------------------
Static Function GPItens(aCols)  

	//Busca Dados  
	If mv_par04 = 1   
	
		_sql := "select b2_cod Cod_Produto, b1_desc Descricao, b1_um Und, b1_tipo Tipo, b1_grupo Grupo, b2_local Armazem, 
		_sql += "b2_qatu Saldo, b1_tipconv Conversao, b1_conv Fator_Conv, "
		_sql += "b2_cm1 Custo_Medio, b2_vatu1 Valor_Medio, b2_cmfim1 Valor_Custo, "  
	else
	
		_sql := "select bf_produto Cod_Produto, b1_um Und, b1_desc Descricao, b1_tipo Tipo, b1_grupo Grupo,bf_local Armazem, bf_localiz Endereco, "
		_sql += "substr(bf_localiz,1,2) Rua, substr(bf_localiz,3,2) Box, substr(bf_localiz,5,1) Nivel, substr(bf_localiz,6,1) Nivel,"
		_sql += "bf_lotectl Lote, b8_dtvalid Validade, bf_quant Quantidade1, b1_tipconv Conversao, b1_conv Fator_Conv, "
		_sql += "bf_empenho Empenho, (bf_quant - bf_empenho) Saldo, b2_cm1 Custo_Medio, b2_cmfim1 Valor_Custo, "  
	EndIf
	
   	_sql += "' ' Contagem_01, " 
	_sql += "' ' Contagem_02, " 
  	_sql += "' ' Contagem_03, " 
	_sql += "' ' USERLGI, " 
	_sql += "' ' USERLGA "   
	
	If mv_par04 = 1
		_sql += "from "+retsqlname("SB2")+" SB2 " 
		_sql += ", "+retsqlname("SB1")+" SB1 " 
		_sql += "where sb2.D_E_L_E_T_ <> '*' "
		_sql += "and   sb1.D_E_L_E_T_ <> '*' "
		_sql += "and b2_cod = b1_cod "
		_sql += "and b2_qatu > 0.01 "
		_sql += "and b2_local in '"+MV_PAR01+"' "   
		_sql += "and b1_tipo between '"+MV_PAR02+"' AND '"+MV_PAR03+"' " 
   		_sql += "order by 1,2,3,4"
    else
   		_sql += "from "+retsqlname("SBF")+" SBF " 
		_sql += ", "+retsqlname("SB1")+" SB1 " 
		_sql += ", "+retsqlname("SB2")+" SB2 " 
		_sql += ", "+retsqlname("SB8")+" SB8 "
		_sql += "where sbf.D_E_L_E_T_ <> '*' "
		_sql += "and   sb1.D_E_L_E_T_ <> '*' "
		_sql += "and   sb2.D_E_L_E_T_ <> '*' "
		_sql += "and   sb8.D_E_L_E_T_ <> '*' "
		_sql += "and bf_produto = b1_cod "
		_sql += "and bf_produto = b2_cod "
		_sql += "and bf_local = b2_local "
		_sql += "and b8_produto = bf_produto "
		_sql += "and b8_lotectl = bf_lotectl "
		_sql += "and b8_local = bf_local "
		_sql += "and bf_filial = '01' "
		_sql += "and bf_quant > 0.01 "
		_sql += "and bf_local in '"+MV_PAR01+"' "   
		_sql += "and b1_tipo between '"+MV_PAR02+"' AND '"+MV_PAR03+"' " 
   		_sql += "order by 5,1"
	EndIf
	//MemoWrite("C:\Totvs\rel.sql",_sql)
	
	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf
		
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(_sql)),"TMP",.T.,.T.)
	
	While TMP->(!EOF()) 
			  	
		aAdd(aCols,{TMP->Cod_Produto,;
			TMP->Und,;	
			TMP->Descricao,;		
			TMP->Tipo,;
			TMP->Grupo+"/"+POSICIONE("SBM",1,xFilial("SBM")+TMP->Grupo,"BM_DESC"),;
			TMP->Armazem,;
			IIf(MV_PAR04 = 1," ","'"+TMP->Endereco),;
			IIf(MV_PAR04 = 1," ",TMP->Rua),;
			IIf(MV_PAR04 = 1," ",	TMP->Box),;
	   		IIf(MV_PAR04 = 1," ",	TMP->Nivel),;   
	   		IIf(MV_PAR04 = 1," ",	TMP->Nivel),; 
		    IIf(MV_PAR04 = 1," ","'"+TMP->Lote),; 			
			IIf(MV_PAR04 = 1," ",STOD(TMP->Validade)),;
		    IIf(MV_PAR04 = 1," ",IIf(STOD(TMP->Validade)>DDATABASE,"VALIDO","VENCIDO")),;    //Guilherme deixou sem a margem de 4 dias... 
		    IIf(MV_PAR04 = 1," ",TMP->Quantidade1),;
			TMP->Conversao,;
			TMP->Fator_Conv,;
	     	IIf(MV_PAR04 = 1," ",IIf(TMP->Empenho -(INT(TMP->Empenho)) > 0,(INT(TMP->Empenho))+1,TMP->Empenho)),; 
			TMP->Saldo,;
			IIf(TMP->Tipo $ "PA/PL/PN",TMP->Valor_Custo,TMP->Custo_Medio),;
			TMP->Contagem_01,;
			TMP->Contagem_02,;
			TMP->Contagem_03,;
			TMP->USERLGI,;
			TMP->USERLGA,;
			" "})
		TMP->(dbskip())
	EndDo
Return

// --------------------------------------------
// Gera perguntas
// --------------------------------------------
Static Function geraX1()
	Local aArea    := GetArea()
	Local aRegs    := {}
	Local i	       := 0
	Local j        := 0
	Local aHelpPor := {}
	Local aHelpSpa := {}
	Local aHelpEng := {}

	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	aAdd(aRegs,{cPerg,"01","Informe o Local            ?","","","mv_ch1","C",02,0,0,"G","","mv_par01",""		 ,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","  "})
	aAdd(aRegs,{cPerg,"02","Informe o Tipo Inicial     ?","","","mv_ch2","C",02,0,0,"G","","mv_par02",""		 ,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","02"})
	aAdd(aRegs,{cPerg,"03","Informe o Tipo Final       ?","","","mv_ch3","C",02,0,0,"G","","mv_par03",""		 ,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","02"})
	aAdd(aRegs,{cPerg,"04","Material de Consumo        ?","","","mv_ch4","N",01,0,0,"C","","mv_par04","Sim"		 ,"","","","","Não"		   ,"","","","","","","","","","","","","","","","","","","  "})
		
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
				AADD(aHelpPor,"Informe o Local.			              ")
			ElseIf i==2                                 	
				AADD(aHelpPor,"Informe o Grupo.             		  ")
			EndIf
			PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
		EndIf
	Next

	RestArea(aArea)
Return

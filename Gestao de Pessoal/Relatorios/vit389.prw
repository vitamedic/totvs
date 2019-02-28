/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT389   ³ Autor ³ André Almeida Alves   ³ Data ³ 10/12/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Relatorio de espelho de ponto em excel, enviado por email  ³±±
±±³          ³ aos gestores.                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
                                       
#include "TOTVS.ch"
#include "TOPCONN.ch"
#INCLUDE "PROTHEUS.ch"
#include 'HBUTTON.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "TCBROWSE.CH"


User Function vit389()

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Ponto Eletronico"
	Local cPict          := ""
	Local titulo    	 := "Relatorio ponto eletronico em Excel"
	Local nLin         	 := 80
	Local Cabec1         := ""
	Local Cabec2         := ""
	Local imprime        := .T.
	Local aOrd           := {}
	Private cString		 := "SP8"
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 80
	Private tamanho      := "P"
	Private nomeprog     := "VIT38901" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cperg       := "pergvit389"
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "VIT389" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private nqtreg       := 0		  // Quantidade de registros retornados pela consulta, utilizando na regua de progressão.
	Private lEnvia			:= .f.
	_cNomeArq				:= ""
	
	_cde		:= "Informativo - Espelho de Ponto"
	_cconta	:= getmv("MV_WFACC")
	_csenha	:= getmv("MV_WFPASSW")
	_cpara		:= ""
	_ccc		:= ""
	_ccco		:= ""
	_lavisa	:= .t.
	_cassunto	:= ""
	_cmensagem	:= ""
	_canexos	:= ""
	
	If MsgYesNo("Deseja enviar o relatorio aos Gestores? ")
		lEnvia			:= .t.
		mv_par01	:= ' '
		mv_par02	:= '99'
		mv_par03	:= ' '
		mv_par04	:= 'zzzzzzzzz'
		mv_par05	:= ' '
		mv_par06	:= ' '
		
	else
		_agrpsx1:={}

		aadd(_agrpsx1,{cperg,"01","Da Filial    	   ","mv_ch1","C",02,0,0,"G",space(60),"mv_par01",space(15)      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),""})
		aadd(_agrpsx1,{cperg,"02","Até a Filial       ","mv_ch2","C",02,0,0,"G",space(60),"mv_par02",space(15)      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),""})
		aadd(_agrpsx1,{cperg,"03","Da Matrícula       ","mv_ch3","C",06,0,0,"G",space(60),"mv_par03",space(15)      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
		aadd(_agrpsx1,{cperg,"04","Até a matrícula    ","mv_ch4","C",06,0,0,"G",space(60),"mv_par04",space(15)      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
		aadd(_agrpsx1,{cperg,"05","Do Centro de Custo ","mv_ch5","C",10,0,0,"G",space(60),"mv_par05",space(15)      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
		aadd(_agrpsx1,{cperg,"06","Ate Centro de Custo","mv_ch6","C",10,0,0,"G",space(60),"mv_par06",space(15)      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})

		u_pergsx1()

		pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd,.F.,Tamanho,.f.)


		If nLastKey == 27
		Return
		Endif

		SetDefault(aReturn,cString)

		If nLastKey == 27
		Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)
		nTipo := 15

	endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento do relatorio                                          #
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	u_procrel()
Return

User Function procrel()

	if lEnvia
		dbSelectArea("CTT")
		ctt->(dbsetorder(1))
		ctt->(dbgotop())				
		while !ctt->(eof())
			_cassunto	:= "Espelho de Ponto CC - "+Alltrim(ctt->ctt_custo)+" - "+ctt->ctt_desc01
			_cmensagem	:= "Espelho de Ponto dos colaboradores vinculados ao Centro de Custo: "+ctt->ctt_custo
			if ctt->ctt_bloq = '1'
				ctt->(dbskip())
				loop
			endif
		
			_cPara	:= u_retemail()

			nInd     := 0
			cQuery   := ""
			if lEnvia
				Processa({|| query2()},"Aguarde")
			else
				Processa({|| query()},"Aguarde")
			endif
	  
			dbSelectArea("TMP")
			TMP->(DbGoTop())
	
	
	//====================CHAMADA DA FUNCAO EXPORTA PARA O EXCEL===================
			u_VIT389A()
			dbCommitAll()
			_canexos	:= "\system\"+_cNomeArq
			_cauxx	:= _cPara
			//_cpara := "a.almeida@vitamedic.ind.br"
			_cmensagem := _cmensagem+"enviado para ->  "+_cauxx
			u_EMail(_cde,_cconta,_csenha,_cpara,_ccc,_ccco,_cassunto,_cmensagem,_canexos,_lavisa)
			FErase("\system\"+_cNomeArq)
			tmp->(DbCloseArea())
			ctt->(dbskip())
		enddo
	else
			dbSelectArea("TMP")
			TMP->(DbGoTop())
			u_VIT389A()
			dbCommitAll()
			tmp->(DbCloseArea())	
	endif
Return
//endif
//=============================================================================

user Function VIT389A()
	LOCAL cStartPath 	:= GetSrvProfString("Startpath","")
	Local nconproc 		:= 0
	Local dData 		:= "//"
	Local aHoras 		:= {}
	Local nUltimo 		:= ""
	Local cFuncao 		:= ""
	private cDirDocs    := MsDocPath()
	private aStru		:= {}
	private oExcelApp
	private nconta 		:= 0
	set date brit


//-------ESTRTURA PARA SAIR NO EXCEL-----------
	aAdd(aStru,	{"Nome            "	, "C", 30, 00})
	aAdd(aStru,	{"Filial          "	, "C", 06, 00})
	aAdd(aStru,	{"Matricula       "	, "C", 15, 00})
	aAdd(aStru,	{"Data2           "	, "C", 11, 00})
	aAdd(aStru,	{"Hora1           "	, "C", 07, 00})
	aAdd(aStru,	{"Hora2           "	, "C", 12, 00})
	aAdd(aStru,	{"Hora3           "	, "C", 07, 00})
	aAdd(aStru,	{"Hora4           "	, "C", 07, 00})
	aAdd(aStru,	{"Hora5           "	, "C", 07, 00})
	aAdd(aStru,	{"Hora6           "	, "C", 07, 00})
	aAdd(aStru,	{"Hora7           "	, "C", 07, 00})
	aAdd(aStru,	{"Hora8           "	, "C", 07, 00})
	aAdd(aStru,	{"Hora9           "	, "C", 07, 00})
	aAdd(aStru,	{"Hora10          "	, "C", 07, 00})
	aAdd(aStru,	{"Hora11          "	, "C", 07, 00})
	aAdd(aStru,	{"Hora12          "	, "C", 07, 00})
	aAdd(aStru,	{"Hora13          "	, "C", 07, 00})

	cFiles	:= CriaTrab( aStru, .T. )
	dbUseArea( .T.,, cFiles, 'TRB', .T. )

	While ! TMP->(Eof())
   //Alert (TMP->P8_HORA)
		incproc("Processando dados...")
		reclock("TRB",.T.)
        
		If (TMP->P8_MAT <> nUltimo)
			nCon := 1
		EndIf
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SEGUNDO SELECT PARA BUSCAR HORAS POR DIA                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		conta := 0
		cQuery2 := " SELECT	* "
		cQuery2 += " FROM " + RetSqlName("SP8") + " SP8 "
		cQuery2 += " WHERE	P8_FILIAL = '" + TMP->P8_FILIAL + "' AND "
		cQuery2 += " SP8.D_E_L_E_T_ = ' ' AND"
		cQuery2 += " P8_MAT = '" + TMP->P8_MAT +"'AND "
		cQuery2 += " P8_DATA = '" + TMP->P8_DATA +"'"

		MemoWrite("/sql/ponto2.sql",cQuery2)
       
		if Select("TMP2") > 0
			TMP2->(dbCloseArea())
		endif
         
		tcquery cQuery2 new alias "TMP2"
		count to conta
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao das linhas dos horarios do funcionario                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	  
		if conta > 0
			_aarea := GetArea()
			DbSelectArea("TMP2")
			TMP2->(DbGoTop())
		
			while !eof("TMP2")
				AADD(aHoras, TMP2->P8_HORA)     // VETOR CONTENDO OS HORARIOS DE ENTRADA E SAIDA
				nUltimo := TMP2->P8_MAT
				tmp2->(DbSkip())
			EndDo
		
			restarea(_aarea)
		EndIf
      
      //IRA ENTRAR SE  A MATRICULA FOR DIFERENTE QUE A ANTERIOR PARA ESCREVER O NOME     
		If (nCon = 1)
			SRA->(dbsetorder(1))
			SRA->(dbseek(TMP->P8_FILIAL+TMP->P8_MAT))
			TRB->Nome :=  SRA->RA_NOME
			nCon := 0
		EndIf
         
		If (TMP->ABONO <> "   " )
			TRB->Filial 		:= TMP->P8_FILIAL
			TRB->Matricula 	:= TMP->P8_MAT
			TRB->Data2  		:= dtoc(stod(TMP->P8_DATA))
  
			cAbono := ALLTRIM(Posicione("SP6",1,xFilial("SP6")+TMP->ABONO, "P6_DESC"))
			TRB->Hora2 := cAbono
		Else
			TRB->Filial 		:= TMP->P8_FILIAL
			TRB->Matricula 		:= TMP->P8_MAT
			TRB->Data2  		:= dtoc(stod(TMP->P8_DATA))

             //ESCREVENDO OS HORARIOS - HORA1, HORA2 ...        
			For _N := 1 To Len(aHoras)
				&("TRB->Hora"+ALLTRIM(STR(_N))) := StrTran(Transform(aHoras[_N], "@E 99.99"), ",",":")
			Next
		EndIf
		
		aHoras := {}    //LIMPANDO O VETOR
          
		TRB->(msunlock())
		TMP->(DbSkip())

	EndDo

	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRINDO E GRAVANDO NO EXCEL                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	  
	cMontaTxt       := ""
 	
  //01234567890123456789012345678901234567890
         //0         1         2         3         4    
  // 999999       xxxxxxxxxxxxxxxxxxxxxxxxxxxx 
	Cabec1 := " Espelho de Ponto por Centro de Custo"

// Utilizar modelo do fonte vit329
	Private _aCabec := {}
	Private _aDados := {}
	
	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
	Return
	EndIf

	_aCabec:={"Nome","Filial","Matricula","Data2","Hora1","Hora2","Hora3","Hora4","Hora5","Hora6",;
		"Hora7","Hora8","Hora9","Hora10","Hora11","Hora12","Hora13"}
	
	cMontaTxt += "Nome;Filial;Matricula;Data2;Hora1;Hora2;Hora3;Hora4;Hora5;Hora6;Hora7;Hora8;Hora9;Hora10;Hora11;Hora12;Hora13;" + CRLF
	
	trb->(dbgotop())

	while !trb->(eof())
		
		AAdd(_aDados, {trb->Nome, trb->Filial, trb->Matricula, trb->Data2, trb->Hora1, trb->Hora2, trb->Hora3, trb->Hora4, trb->Hora5, trb->Hora6,;
			trb->Hora7, trb->Hora8, trb->Hora9, trb->Hora10, trb->Hora11, trb->Hora12, trb->Hora13})
		
		cMontaTxt += trb->Nome+";"+trb->Filial+";"+trb->Matricula+";"+trb->Data2+";"+trb->Hora1+";"+trb->Hora2+";"+trb->Hora3+";"+trb->Hora4+";"+trb->Hora5+";"+trb->Hora6+";"+trb->Hora7+";"+trb->Hora8+";"+trb->Hora9+";"+trb->Hora10+";"+trb->Hora11+";"+trb->Hora12+";"+trb->Hora13+";" + CRLF
		
		trb->(dbskip())
	end
	if !lEnvia
		DlgToExcel({ {"ARRAY", "Espelho de Ponto", _aCabec, _aDados} })
	endif
	TRB->(DbCloseArea())


// Nome do arquivo criado. 
	_cNomeArq := alltrim(ctt->ctt_custo)+".csv"
	_canexos	:=" "

 // criar arquivo texto vazio a partir do root path no servidor
	nHandle := FCREATE(_cNomeArq)

// grava o conteudo da variavel no arquivo.
	FWrite(nHandle,cMontaTxt)

 // encerra gravação no arquivo
	FClose(nHandle)

Return

Static Function query()
	Local cQuery 	:= ""
	Local dPeriodoI := "//"
	Local dPeriodoF := "//"


//MV_PONMES = 20110226/20110325 
	dPeriodoI := StoD(Substr(GetMv("MV_PONMES"),1,8)) //Periodo Inicial
	dPeriodoF := StoD(Substr(GetMv("MV_PONMES"),10,8)) //Periodo Final
    	
	cQuery := " SELECT DISTINCT(P8_DATA) AS P8_DATA, P8_FILIAL, P8_MAT, ' ' AS ABONO "
	cQuery += " FROM " + RetSqlName("SP8") + " SP8 "
	cQuery += " WHERE	P8_FILIAL BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' AND "
	cQuery += " SP8.D_E_L_E_T_ = ' ' AND"
	cQuery += " P8_MAT BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' AND "
	cQuery += " P8_DATA BETWEEN '" + DtoS(dPeriodoI) + "' AND '" + DtoS(dPeriodoF) + "' AND "
	cQuery += " P8_CC BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "' "
        
	cQuery += " UNION ALL "
		
	cQuery += " SELECT PC_DATA, PC_FILIAL, PC_MAT, PC_ABONO "
	cQuery += " FROM " + RetSqlName("SPC") + " SPC "
	cQuery += " WHERE	PC_FILIAL BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' AND "
	cQuery += " PC_MAT BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' AND "
	cQuery += " SPC.D_E_L_E_T_ = ' ' AND"
	cQuery += " PC_DATA BETWEEN '" + DtoS(dPeriodoI) + "' AND '" + DtoS(dPeriodoF) + "' AND "
	cQuery += " PC_CC BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "'AND "
	cQuery += " PC_ABONO <> ' ' "
	cQuery += " ORDER BY  3,1 "
     	
     	   
	MemoWrite("/sql/ponto.sql",cQuery)
	tcquery cQuery new alias "TMP"

	if Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(dbCloseArea())
	endif
	
	MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)},"Aguarde","Selecionando registros de acordo com os parâmetros.")

	count to nqtreg
	
return(nqtreg)

//Query para enviar relatorio aos Getores.

Static Function query2()
	Local cQuery 	:= ""
	Local dPeriodoI := "//"
	Local dPeriodoF := "//"


//MV_PONMES = 20110226/20110325 
	dPeriodoI := StoD(Substr(GetMv("MV_PONMES"),1,8)) //Periodo Inicial
	dPeriodoF := StoD(Substr(GetMv("MV_PONMES"),10,8)) //Periodo Final
    	
	cQuery := " SELECT DISTINCT(P8_DATA) AS P8_DATA, P8_FILIAL, P8_MAT, ' ' AS ABONO "
	cQuery += " FROM " + RetSqlName("SP8") + " SP8 "
	cQuery += " WHERE	P8_FILIAL BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' AND "
	cQuery += " P8_DATA BETWEEN '" + DtoS(dPeriodoI) + "' AND '" + DtoS(dPeriodoF) + "' AND "
	cQuery += " P8_CC IN '" + ctt->ctt_custo +"' "
        
	cQuery += " UNION ALL "
		
	cQuery += " SELECT PC_DATA, PC_FILIAL, PC_MAT, PC_ABONO "
	cQuery += " FROM " + RetSqlName("SPC") + " SPC "
	cQuery += " WHERE	PC_FILIAL BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' AND "
	cQuery += " PC_DATA BETWEEN '" + DtoS(dPeriodoI) + "' AND '" + DtoS(dPeriodoF) + "' AND "
	cQuery += " PC_CC IN '" + ctt->ctt_custo +"' AND"
	cQuery += " PC_ABONO <> ' ' "
	cQuery += " ORDER BY  3,1 "
     	
     	   
	MemoWrite("/sql/ponto.sql",cQuery)
	tcquery cQuery new alias "TMP"

	if Select("TMP") > 0
		DbSelectArea("TMP")
		TMP->(dbCloseArea())
	endif
	
	MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)},"Aguarde","Selecionando registros de acordo com os parâmetros.")

	count to nqtreg
	
return(nqtreg)

user function retemail()

	if Alltrim(ctt->ctt_custo) $("20010000,11010000,22020001,22020002,22020003")
		_cpara	:= "j.oliveira@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $ ("22040000")
		_cpara	:= "k.batista@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $("22050000")
		_cpara	:= "report@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $ ("23010001")
		_cpara := "a.matsuura@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $ ("23020000,23030000")
		_cpara := "l.pontes@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $ ("240100000")
		_cpara := "r.silva@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $ ("28000001")
		_cpara	:= "f.batista@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $ ("28010000,28010001,28010002,28010003")
		_cpara	:= "k.pureza@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $ ("28020000,28020001,28020002,28020003,28020005")
		_cpara	:= "g.oliveira@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $ ("28030002")
		_cpara	:= "l.boroski@vitamedic.ind.br'
	elseif Alltrim(ctt->ctt_custo) $ ("29040001")
		_cpara	:= "m.filho@vitamedic.ind.br'
	elseif Alltrim(ctt->ctt_custo) $ ("29050100")
		_cpara	:= "a.neto@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $ ("29050101,29050102,29050103,29050601")
		_cpara	:= "m.rosa@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $ ("29050200")
		_cpara	:= "a.duca@vitamedic.ind.br"
	elseif Alltrim(ctt->ctt_custo) $ ("29050000,29050400,29050602,29050603,29050604,29050606,29050607,29050608,29050610,29050701,29050702,29050703,29050801,29050802,29050803")
		_cpara	:= "e.lenza@vitamedic.ind.br"
	else
		_cpara	:= "j.oliveira@vitamedic.ind.br;paula.lima@vitamedic.ind.br"
		_cmensagem += "Sem E-mail vinculado!!!"
	endif
	*/
return(_cpara)

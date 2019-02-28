#define ENTER  Chr(13)+Chr(10)
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


//±±*************************************************************************±±
//±± Programa  | VIT475  | Autor | Roberto Fiuza    |  Data |   24/01/2017   ±±
//±±*************************************************************************±±
//±± Descricao | Gerar arquivo TXT do ponto eletronico para o FPW            ±±
//±±           |                                                             ±±
//±±************************************************************************¹±±
//±± Uso       | VITAMEDIC                                                   ±±
//±±*************************************************************************±±

 
User Function VIT475

	Private cPerg       := PADR("VIT475",Len(SX1->X1_GRUPO))

//Chama relatorio personalizado
	ValidPerg()
	pergunte(cPerg)

	MakeDir(alltrim(mv_par07))

	Processa({|| ProcGen() },"Processando Arquivos TXT")


Return

//***************************************************************************
//* Funcao    | ProcGen  | Autor | Roberto Fiuza    |  Data | 24/01/2017    *
//***************************************************************************
//* Descricao | Gerar arquivo TXT do ponto eletronico para o FPW            *
//*           |                                                             *
//*************************************************************************¹*
//* Uso       | VITAMEDIC                                                   *
//***************************************************************************  

Static Function ProcGen()

	Local cEOL := CHR(13)+CHR(10)

	Local wEvento       := 0
	Local wValor        := 0
	Local wQtdTotal     := 0
	Local wQtdRealizada := 0
	Local wAno          := strzero(Year (mv_par05),4,0)
	Local wMes          := strzero(Month(mv_par05),2,0)
	
	//201701
	
//	If wAno+wMes <> getmv('MV_FOLMES')
//		cTabela := 'RC01'+substr(wAno,3,2)+wMes
//	Else
		cTabela := RetSQLName("SRC")
//	Endif

//
//Evento	Descrição	       Protheus	 FPW
//001	HORAS NORMAIS       	 -   	 -   
//004	ADICIONAL NOTURNO   	 141 	24585 
//006	FALTA 1/2 PERIODO   	 311 	22570 
//007	FALTA INTEGRAL N/AUT	 -   	 -   
//008	FALTA INTEGRAL      	 -   	 -   
//010	ATRASOS             	 403 	22570 
//012	SAIDA ANTECIPADA    	 403 	22570 
//018	SAIDA EXPEDIENTE    	 314 	22570 
//024	HORAS NORMAIS NOT.  	 -   	 -   
//025	AD.NOT.HORAS EXT.N/A	 -   	 -   
//040	HORA EXTRA 50       	 148 	24505 
//041	HORA EXTRA 100	    147 	20230 
//044	HR. NORMAIS N. REALI	 -   	 -   
//045	HR. NOTUR. N/ REALIZ	 -   	 -   
//066	FALTA INTEGRAL DIAS	 259 	20060 
// 0 	ATESTADO MEDICO	     400 	23641


	If Select("QSRC") > 0
		QSRC->(dbCloseArea())
	EndIf
	
	_cQry := " SELECT * "
	_cQry += " FROM " + cTabela
	_cQry += " WHERE D_E_L_E_T_ = ' '"
	_cQry += " AND RC_FILIAL    = '" + XFILIAL("SRC")    + "' "
	_cQry += " AND RC_CC   BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
	_cQry += " AND RC_PD IN('141','311','403','403','314','148','147','259','400') "
	_cQry += " ORDER BY RC_MAT"

	
	_cQry := ChangeQuery(_cQry)
	
	TcQuery _cQry New Alias "QSRC"
	
	
	_cRet := ""
	dbselectarea("QSRC")
	DBGOTOP()
	Do While ! eof()

		IF QSRC->RC_PD = "141"
			wEvento := 24585
		ELSEIF QSRC->RC_PD = "311"
			wEvento := 22570
		ELSEIF QSRC->RC_PD = "403"
			wEvento := 22570
		ELSEIF QSRC->RC_PD = "403"
			wEvento := 22570
		ELSEIF QSRC->RC_PD = "314"
			wEvento := 22570
		ELSEIF QSRC->RC_PD = "148"
			wEvento := 24505
		ELSEIF QSRC->RC_PD = "147"
			wEvento := 20230
		ELSEIF QSRC->RC_PD = "259"
			wEvento := 20060
		ELSEIF QSRC->RC_PD = "400"
			wEvento := 23641
		ENDIF
	
		_cRet += '015'
		_cRet += strzero(val(QSRC->RC_MAT),9,0)
		_cRet += strzero(wEvento,5,0)
		_cRet += SUBSTR(dtos(mv_par05),1,6)
		_cRet += SUBSTR(dtos(mv_par05),1,6)
		_cRet += strzero(QSRC->RC_HORAS * 100,15,0)
		_cRet += strzero(wQtdTotal,3,0)
		_cRet += strzero(wQtdRealizada,3,0)
		_cRet += cEOL

		dbselectarea("QSRC")
		skip
	Enddo

//	MemoWrite("C:\Temp\CLI1.TXT",_cRet)
	MemoWrite(alltrim(mv_par07) + "PONTO" + SUBSTR(dtos(mv_par05),1,6)+ ".TXT" ,_cRet)
 
/*
 SELECT PH_PD,P9_DESC,SUM(PH_QUANTC) FROM SPH010 
INNER JOIN SP9010 ON P9_CODIGO = PH_PD
WHERE PH_DATA BETWEEN '20161101' AND '20161231'
GROUP BY PH_PD,P9_DESC
ORDER BY PH_PD,P9_DESC
*/
Return .t.

//***************************************************************************
//* Funcao    | ValidPerg  | Autor | Roberto Fiuza    |  Data | 24/01/2017  *
//***************************************************************************
//* Descricao | Criar perguntas                                             *
//*           |                                                             *
//*************************************************************************¹*
//* Uso       | VITAMEDIC                                                   *
//***************************************************************************  


Static Function ValidPerg
	Local aArea    := GetArea()
	Local aRegs    := {}
	Local i	       := 0
	Local j        := 0
	Local aHelpPor := {}
	Local aHelpSpa := {}
	Local aHelpEng := {}


	aAdd(aRegs,{cPerg,"01","Filial De ?    ","","","mv_ch1","C",02,0,0,"G","","mv_par01",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
	aAdd(aRegs,{cPerg,"02","Filial Ate ?   ","","","mv_ch2","C",02,0,0,"G","","mv_par02",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
	aAdd(aRegs,{cPerg,"03","C.Custo De ?   ","","","mv_ch3","C",09,0,0,"G","","mv_par03",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","CTT"})
	aAdd(aRegs,{cPerg,"04","C.Custo Ate ?  ","","","mv_ch4","C",09,0,0,"G","","mv_par04",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","CTT"})
	aAdd(aRegs,{cPerg,"05","Periodo De ?   ","","","mv_ch5","D",08,0,0,"G","","mv_par05",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
	aAdd(aRegs,{cPerg,"06","Periodo Ate ?  ","","","mv_ch6","D",08,0,0,"G","","mv_par06",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})
	aAdd(aRegs,{cPerg,"07","Local Arquivo ?","","","mv_ch4","C",20,0,0,"G","","mv_par07",""		,"","","","",""		   ,"","","","","","","","","","","","","","","","","","","   "})


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
				AADD(aHelpPor,"Periodo inicial.                   ")
			ElseIf i==6
				AADD(aHelpPor,"Periodo final.                     ")
			ElseIf i==7
				AADD(aHelpPor,"Local para gravacao do arquivo     ")
			EndIf
			PutSX1Help("P."+cPerg+strzero(i,2)+".",aHelpPor,aHelpEng,aHelpSpa)
		EndIf
	Next

	RestArea(aArea)
Return

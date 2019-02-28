#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "avprint.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITQ003   ³Autor ³ Valeria de Novaes   ³Data ³  11/02/04   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Laudo Tecnico de Material de Embalagem (Materia-Prima)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AP6 - Inspeção de Entregas / Controle de Documentos        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function Vitq003()

Local _mArea  := {"QE6","QEL","QEK","QER"}
Local _mAlias := {}
Local i := 0

Private cLaudo := ""    
Private _analise := ""    

Private 	cDtLib := cTod("//") //TQEK->QEL_DTDILA

Private	cHora  := ""  //TQEK->QEL_HRDILA

PRIVATE cPerg := "PERGVIQ003"
Private nPag := 0
Private _li := 0

_mAlias := U_SalvaAmbiente(_mArea)
_pergsx1()

cnrdoc:=" "
pergunte(cPerg,.t.)

// Deficições do objeto de impressão AVPRINT
/*
#xcommand AVPRINT [ <oPrint> ] ;
[ <name:TITLE,NAME,DOC> <cDocument> ] ;
[ <user: FROM USER> ] ;
[ <prvw: PREVIEW> ] ;
[ TO  <xModel> ] ;
=> ;
[ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPRINTER [ <oPrint> ] ;
[ <name:NAME,DOC> <cDocument> ] ;
[ <user: FROM USER> ] ;
[ <prvw: PREVIEW> ] ;
[ TO  <xModel> ] ;
=> ;
[ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPAGE       => AvPageBegin()
#xcommand AVENDPAGE    => AvPageEnd()
#xcommand AVNEWPAGE    => AvPageEnd()  ; AvPageBegin()
#xcommand AVENDPRINT   => AvPrintEnd() ; AvSetPortrait()
#xcommand AVENDPRINTER => AvPrintEnd() ; AvSetPortrait()
*/
//------------------------------------------------------------------------------//
AVPRINT oPrn NAME "Laudo Técnico"

oFont1  := oSend(TFont(),"New","Arial"          ,0,10,,.F.,,,,,,,,,,,oPrn )
oFont2  := oSend(TFont(),"New","Arial"          ,0,10,,.T.,,,,,,,,,,,oPrn )
oFont3  := oSend(TFont(),"New","Arial"          ,0,12,,.F.,,,,,,,,,,,oPrn )
oFont4  := oSend(TFont(),"New","Arial"          ,0,12,,.T.,,,,,,,,,,,oPrn )
oFont5  := oSend(TFont(),"New","Arial"          ,0,14,,.F.,,,,,,,,,,,oPrn )
oFont6  := oSend(TFont(),"New","Arial"          ,0,14,,.T.,,,,,,,,,,,oPrn )
oFont7  := oSend(TFont(),"New","Arial"          ,0,16,,.F.,,,,,,,,,,,oPrn )
oFont8  := oSend(TFont(),"New","Arial"          ,0,16,,.T.,,,,,,,,,,,oPrn )
oFont9  := oSend(TFont(),"New","Arial"          ,0,18,,.F.,,,,,,,,,,,oPrn )
oFont10 := oSend(TFont(),"New","Arial"          ,0,08,,.F.,,,,,,,,,,,oPrn )
oFont11 := oSend(TFont(),"New","Arial"          ,0,07,,.F.,,,,,,,,,,,oPrn )

aFontes := { oFont1, oFont2, oFont3 , oFont4 , oFont5, oFont6 , oFont7 ,oFont8,oFont9,oFont10,oFont11}

// INICIO DA IMPRESSAO
AVPAGE

_l := 39
_c := 46
_nColMin := _c
_nRowMin := _l
_nColMax := _c*50
_nRowMax := _l*80

//Imprime cabeçario
ImpCab()

// Alimenta vetor com os dados dos Ensaios
DetRes()
_fCabec := .f.
_li := 8

TQEK->(Dbgotop())

While !TQEK->(EOF())
   If _fCabec 
      ImpRoda(_li)
		AVNEWPAGE
		ImpCab()
		_Li := 8
	EndIf
	_fCabec := .t.
	
	QE6->(dbSeek(xFilial("QE6") + TQEK->QEK_PRODUT + Inverte(TQEK->QEK_REVI)))
	cNrDoc := Posicione("QZ1",1,xFilial("QZ1") + QE6->QE6_PRODUT, "QZ1_DOCTO")
	cRev   := StrZero(Val(QE6->QE6_REVI),3)
	
	cLaudo := TQEK->QEL_LAUDO
	cDtLib := TQEK->QEL_DTDILA
	cHora  := TQEK->QEL_HRDILA
	_analise:= TQEK->QEL_ANALIS
	_dtaana:=TQEK->QEL_DTAANA

	cFornec := Alltrim(TQEK->QEK_FORNEC) + "/"+ TQEK->QEK_LOJFOR + " - "+ Posicione("SA2",1,xFilial("SA2") + TQEK->QEK_FORNEC + TQEK->QEK_LOJFOR ,"A2_NOME")
	cLtForn := Posicione("SD1",1,xFilial("SD1") + TQEK->QEK_NTFISC + TQEK->QEK_SERINF + TQEK->QEK_FORNEC + TQEK->QEK_LOJFOR +TQEK->QEK_PRODUT ,"D1_LOTEFOR")
	dDtVad  := Posicione("SD1",1,xFilial("SD1") + TQEK->QEK_NTFISC + TQEK->QEK_SERINF + TQEK->QEK_FORNEC + TQEK->QEK_LOJFOR +TQEK->QEK_PRODUT ,"D1_DTVALID")
	cVolume := Posicione("SD1",1,xFilial("SD1") + TQEK->QEK_NTFISC + TQEK->QEK_SERINF + TQEK->QEK_FORNEC + TQEK->QEK_LOJFOR +TQEK->QEK_PRODUT ,"D1_NUMVOL")
	cFabric := Posicione("SD1",1,xFilial("SD1") + TQEK->QEK_NTFISC + TQEK->QEK_SERINF + TQEK->QEK_FORNEC + TQEK->QEK_LOJFOR +TQEK->QEK_PRODUT ,"D1_FABRIC")
	cLtFabr := Posicione("SD1",1,xFilial("SD1") + TQEK->QEK_NTFISC + TQEK->QEK_SERINF + TQEK->QEK_FORNEC + TQEK->QEK_LOJFOR +TQEK->QEK_PRODUT ,"D1_LOTFABR")
	dDtFab  := Posicione("SD1",1,xFilial("SD1") + TQEK->QEK_NTFISC + TQEK->QEK_SERINF + TQEK->QEK_FORNEC + TQEK->QEK_LOJFOR +TQEK->QEK_PRODUT ,"D1_DTFABR")

	oPrn:Box(_l*_li,_nColMin, _l*(_li+2),_nColMax)
	oPrn:Line(_l*_li,_c*14,_l*(_li+2),_c*14) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*2-15,"Código:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*08,Alltrim(TQEK->QEK_PRODUT), aFontes[3])
	
	oPrn:Line(_l*_Li,_c*35+15,_l*(_li+2),_c*35+15) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*15,"Descrição:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*20,Upper(Alltrim(QE6->QE6_DESCPO)), aFontes[3])
	
	oPrn:Say( _l*_li+15,_c*36,"Categoria:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*41,Upper(QE6->QE6_CATEG), aFontes[3])
	
	_Li += 2
	oPrn:Line(_l*_li,_nColMin,_l*(_li+2),_nColMin) // DESENHA Coluna
	oPrn:Line(_l*_li,_nColMax,_l*(_li+2),_nColMax) // DESENHA Coluna
	oPrn:Line(_l*(_li+2),_nColMin,_l*(_li+2),_nColMax) // DESENHA Linha

	oPrn:Line(_l*_li,_c*7+15,_l*(_li+2),_c*7+15) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*2-15,"Revisão:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*06,Alltrim(QE6->QE6_REVI), aFontes[3])
	
	oPrn:Line(_l*_Li,_c*14,_l*(_li+2),_c*14) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*8-15,"Data:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*10+10,DtoC(QE6->QE6_DTINI), aFontes[3])
	
	oPrn:Line(_l*_Li,_c*25,_l*(_li+2),_c*25) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*15,"Lote:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*17+30,SubStr(TQEK->QEK_LOTE,1,10), aFontes[3])
	
	oPrn:Line(_l*_Li,_c*35+15,_l*(_li+2),_c*35+15) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*26-15,"NºAnalise:", aFontes[4])
//	oPrn:Say( _l*_li+15,_c*30,alltrim(QEL->QEL_ANALIS), aFontes[3])
	oPrn:Say( _l*_li+15,_c*30,alltrim(_analise), aFontes[3])

	oPrn:Say( _l*_li+15,_c*36,"Dt Analise:", aFontes[4])
//	oPrn:Say( _l*_li+15,_c*41,DtoC(TQEK->QEL_DTLAUD), aFontes[3])
//	oPrn:Say( _l*_li+15,_c*41,DtoC(QEL->QEL_DTAANA), aFontes[3])
	oPrn:Say( _l*_li+15,_c*41,dtoc(_dtaana), aFontes[3])

	_Li += 2
	oPrn:Line(_l*_li,_nColMin,_l*(_li+2),_nColMin) // DESENHA Coluna
	oPrn:Line(_l*_li,_nColMax,_l*(_li+2),_nColMax) // DESENHA Coluna
	oPrn:Line(_l*(_li+2),_nColMin,_l*(_li+2),_nColMax) // DESENHA Linha

	oPrn:Line(_l*_Li,_c*35+15,_l*(_li+2),_c*35+15) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*2-15,"Fornecedor: ", aFontes[4])
	oPrn:Say( _l*_li+15,_c*08, cFornec, aFontes[3])
	
	oPrn:Say( _l*_li+15,_c*36,"Lote:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*41,Alltrim(cLtForn), aFontes[3])

	_Li += 2
	oPrn:Line(_l*_li,_nColMin,_l*(_li+2),_nColMin) // DESENHA Coluna
	oPrn:Line(_l*_li,_nColMax,_l*(_li+2),_nColMax) // DESENHA Coluna
	oPrn:Line(_l*(_li+2),_nColMin,_l*(_li+2),_nColMax) // DESENHA Linha

	_cUniMed := Alltrim(Posicione("SAH",1,xFilial("SAH") + TQEK->QEK_UNIMED,"AH_UNIMED"))
	oPrn:Line(_l*_li,_c*16,_l*(_li+2),_c*16) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*2-15,"Quantidade: ", aFontes[4])
	oPrn:Say( _l*_li+15,_c*08,Alltrim(TQEK->QEK_TAMLOT) + " " + _cUniMed, aFontes[3])

	oPrn:Line(_l*_Li,_c*35+15,_l*(_li+2),_c*35+15) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*17,"Nº Volume:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*22,alltrim(str(cVolume)), aFontes[3])

	oPrn:Say( _l*_li+15,_c*36,"NF/Serie:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*41,Alltrim(TQEK->QEK_NTFISC) + " - " + Alltrim(TQEK->QEK_SERINF) , aFontes[3])
	_li += 2
	
	If Alltrim(QE6->QE6_TIPO) == "MP"
	oPrn:Line(_l*_li,_nColMin,_l*(_li+2),_nColMin) // DESENHA Coluna
	oPrn:Line(_l*_li,_nColMax,_l*(_li+2),_nColMax) // DESENHA Coluna
	oPrn:Line(_l*(_li+2),_nColMin,_l*(_li+2),_nColMax) // DESENHA Linha

	oPrn:Line(_l*_Li,_c*35+15,_l*(_li+2),_c*35+15) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*2-15,"Fabricante: ", aFontes[4])
	oPrn:Say( _l*_li+15,_c*08, cFabric, aFontes[3])
	
	oPrn:Say( _l*_li+15,_c*36,"Lote:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*41,Alltrim(cLtFabr), aFontes[3])

	_Li += 2
	oPrn:Line(_l*_li,_nColMin,_l*(_li+2),_nColMin) // DESENHA Coluna
	oPrn:Line(_l*_li,_nColMax,_l*(_li+2),_nColMax) // DESENHA Coluna
	oPrn:Line(_l*(_li+2),_nColMin,_l*(_li+2),_nColMax) // DESENHA Linha

	_cUniMed := Alltrim(Posicione("SAH",1,xFilial("SAH") + TQEK->QEK_UNIMED,"AH_UMRES"))
	oPrn:Line(_l*_li,_c*16,_l*(_li+2),_c*16) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*2-15,"Fabricação: ", aFontes[4])
	oPrn:Say( _l*_li+15,_c*08,dToc(dDtFab), aFontes[3])

	oPrn:Line(_l*_Li,_c*35+15,_l*(_li+2),_c*35+15) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*17,"Validade:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*22,DtoC(dDtVad), aFontes[3])

	oPrn:Say( _l*_li+15,_c*36,"Formula:", aFontes[4])
	U_ImpFEmp(alltrim(QE6->QE6_FORMOL),41,15)

	_li += 2
	endIf
	
	oPrn:Line(_l*_li,_ncolMin,_l*(_li+2),_ncolMin) // DESENHA Coluna
	oPrn:Line(_l*_li,_c*16,_l*(_li+2),_c*16) // DESENHA Coluna
	oPrn:Line(_l*_li,_c*42,_l*(_li+2),_c*42) // DESENHA Coluna
	oPrn:Line(_l*_li,_nColMax,_l*(_li+2),_ncolMax) // DESENHA Coluna
	oPrn:Line(_l*(_li+2),_ncolMin,_l*(_li+2),_nColMax) // DESENHA Linha
	
	oPrn:Say( _l*_li+15,_c*06,"TESTE", aFontes[4])
	oPrn:Say( _l*_li+15,_c*23,"ESPECIFICAÇÃO", aFontes[4])
	oPrn:Say( _l*_li+15,_c*43,"RESULTADO", aFontes[4])
	
	_li += 2

	QER->(dbseek(xFilial("QER") + QE6->QE6_PRODUT + QE6->QE6_REVI + TQEK->QEK_FORNEC + TQEK->QEK_LOJFOR ))
	_Inicio := _li
	_nLin   := _li

	WHILE !QER->(eof()) .and. QER->QER_FILIAL == TQEK->QEK_FILIAL .and. QER->QER_FORNEC == TQEK->QEK_FORNEC .and. ;
		QER->QER_LOJFOR == TQEK->QEK_LOJFOR .and. QER->QER_LOTE == TQEK->QEK_LOTE .and. QER->QER_PRODUT == TQEK->QEK_PRODUT
		
		_cTeste := Alltrim(Posicione("QE1",1,xFilial("QE1") + QER->QER_ENSAIO,"QE1_DESCPO"))
		_cTipo  := Alltrim(Posicione("QE1",1,xFilial("QE1") + QER->QER_ENSAIO,"QE1_CARTA"))
		
		If _cTipo == "TXT"
			_cResult := Alltrim(Posicione("QEQ",1,xFilial("QEQ") + QER->QER_CHAVE,"QEQ_MEDICA"))
			_cEspec  := Alltrim(Posicione("QE8",1,xFilial("QE8") + QER->QER_PRODUT + QER->QER_REVI + QER->QER_ENSAIO,"QE8_TEXTO"))
		Else
			_cResult := Alltrim(Posicione("QES",1,xFilial("QES") + QER->QER_CHAVE,"QES_MEDICA"))
			_cEspec := ""

			if QE7->(dbseek(xFilial("QE7") + QER->QER_PRODUT + QER->QER_REVI + QER->QER_ENSAIO))
				_cUniMed := Alltrim(Posicione("SAH",1,xFilial("SAH") + QE7->QE7_UNIMED,"AH_UMRES"))
				_cResult += " " + _cUniMed
				If QE7->QE7_MINMAX == "1"
					_cEspec := "ENTRE: " + Alltrim(QE7->QE7_LIE) + " e " + Alltrim(QE7->QE7_LSE) + "  " + _cUniMed
				ElseIf QE7->QE7_MINMAX == "2"
					_cEspec := "NO MINIMO: " + Alltrim(QE7->QE7_LIE) + "  " + _cUniMed
				Else
					_cEspec := "NO MAXIMO: " + Alltrim(QE7->QE7_LSE) + "  " + _cUniMed
				EndIf
			EndIf
		EndIf
		
		// Imprime Resultado
		oPrn:Say (_l*_Li+15,_c*43,Upper(Alltrim(_cResult)), aFontes[1])

		//Imprime Teste
		oWWSay(@_li,_c*02,30, alltrim(_cTeste),.f.,aFontes[1])
		
		// Imprime Descricao
		oWWSay(@_nLin,_c*17,50, Upper(alltrim(_cEspec)),.f.,aFontes[1])
		
		If _li <= _nLin
			_li := _nLin
		EndIf
		
		oPrn:Line(_l*_inicio,_ncolMin,_l*_li,_ncolMin) // DESENHA Coluna
		oPrn:Line(_l*_inicio,_c*16,_l*_li,_c*16) // DESENHA Coluna
		oPrn:Line(_l*_inicio,_c*42,_l*_li,_c*42) // DESENHA Coluna
		oPrn:Line(_l*_inicio,_nColMax,_l*_li,_ncolMax) // DESENHA Coluna
		oPrn:Line(_l*_li,_ncolMin,_l*_li,_nColMax) // DESENHA Linha
		
		If _Li >= 79
	      ImpRoda(_li)
			AVNEWPAGE
			ImpCab()
			_Li := 8
		EndIf
		QER->(DBSkip())
	ENDDO
	TQEK->(DBSkip())
EndDo
ImpRoda(_li)

TQEK->(dbCloseArea())
AVENDPAGE
AVENDPRINT
oFont1:End()
oFont2:End()
oFont3:End()
oFont4:End()
oFont5:End()
oFont6:End()
oFont7:End()
oFont8:End()
oFont9:End()
oFont10:End()
oFont11:End()

MS_FLUSH()
U_VoltaAmbiente(_mAlias)
Return (.t.)

Static Function _pergsx1()
Local _sAlias := Alias()
Local _agrpsx1 := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
aadd(_agrpsx1,{cperg,"01","Do Produto      ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","QE6",""})
aadd(_agrpsx1,{cperg,"02","Ate Produto     ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","QE6",""})
aadd(_agrpsx1,{cperg,"03","Do Lote         ?","","","mv_ch3","C",16,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})
aadd(_agrpsx1,{cperg,"04","Ate Lote        ?","","","mv_ch4","C",16,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})
aadd(_agrpsx1,{cperg,"05","Do Fornecedor   ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aadd(_agrpsx1,{cperg,"06","Da Loja         ?","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})
aadd(_agrpsx1,{cperg,"07","Até Fornecedor  ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aadd(_agrpsx1,{cperg,"08","Até Loja        ?","","","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})
aadd(_agrpsx1,{cperg,"09","Da Dt. Laudo    ?","","","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})
aadd(_agrpsx1,{cperg,"10","Até Dt. Laudo   ?","","","mv_chA","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})

For i:=1 to Len(_agrpsx1)
	If !dbSeek(cPerg+_agrpsx1[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(_agrpsx1[i])
				FieldPut(j,_agrpsx1[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
return

Static Function DetRes()
Local _cQuery := ""

_cquery := " SELECT QEK_FORNEC, QEK_LOJFOR, QEK_PRODUT, QEK_REVI, QEK_LOTE, QEK_TAMLOT, QEK_NTFISC, "
_cQuery += " QEL_LAUDO , QEL_DTLAUD, QEL_JUSTLA, QEK_FILIAL,QEL_DTDILA, QEL_HRDILA, QEK_SERINF, QEK_UNIMED, QEK_OBS,"
_cQuery += " QEL_DTAANA , QEL_ANALIS"
_cquery += " FROM "
_cquery +=  retsqlname("QEK")+" QEK, "
_cquery +=  retsqlname("QEL")+" QEL "
_cquery += " WHERE"
_cquery += "     QEK.D_E_L_E_T_<>'*'"
_cquery += " AND QEL.D_E_L_E_T_<>'*'"
_cquery += " AND QEK_FORNEC BETWEEN '" + mv_par05 + "' AND '" + mv_Par07 + "'"
_cquery += " AND QEK_LOJFOR BETWEEN '" + mv_par06 + "' AND '" + mv_Par08 + "'"
_cquery += " AND QEK_PRODUT BETWEEN '" + mv_par01 + "' AND '" + mv_Par02 + "'"
_cquery += " AND SUBSTR(QEK_LOTE,1,10)   BETWEEN '" + mv_par03 + "' AND '" + mv_Par04 + "'"
_cquery += " AND QEL_DTLAUD BETWEEN '" + dtoc(mv_par09) + "' AND '" + dToc(mv_Par10) + "'"
_cquery += " AND QEK_FILIAL = QEL_FILIAL "
_cquery += " AND QEK_FORNEC = QEL_FORNEC "
_cquery += " AND QEK_LOJFOR = QEL_LOJFOR "
_cquery += " AND QEK_PRODUT = QEL_PRODUT "
_cquery += " AND QEK_LOTE   = QEL_LOTE   "
_cquery += " AND QEL_LABOR  =  '" + Space(6) + "'"
_cQuery += " ORDER BY QEK_FORNEC, QEK_LOJFOR, QEK_PRODUT"

_cquery := changequery(_cquery)
tcquery _cQuery new alias "TQEK"
tcsetfield("TQEK","QEL_DTLAUD","D")
tcsetfield("TQEK","QEL_DTDILA","D")
tcsetfield("TQEK","QEL_DTAANA","D")
Return()

Static Function  ImpdDist(_nLin,cNrDoc, cRev)
Local _aArea := GetArea("QDH")
Local _Li := 0
Local _inic := _nLin
Local Impr := .t.
_nLin += 1

dbSelectArea("QDG")
dbSetOrder(1)
dbSeek(xFilial("QDG") + cNrDoc + cRev)

while !QDG->(Eof()) .and. (cNrDoc == QDg->QDG_DOCTO) .and. (cRev == QDG->QDG_RV)

	If _nLin >= 79
		oPrn:line(_l*_inic,_nColMax, _l*_nLin,_nColMax)
		oPrn:line(_l*_inic,_nColMin, _l*_nLin,_nColMin)
		oPrn:line(_l*_nLin,_nColMin, _l*_nLin,_nColMax)

		AVNEWPAGE
		ImpCab()
		_nLin := 8
		_inic := _nLin
	EndIf
	
	If Impr 
		oPrn:Say( _l*_nLin,_c*02,"Distribuição: ", aFontes[4])
		Impr := .f.
	EndIf
	
	If QDG->QDG_TIPO <> "P" .and. empty(QDG->QDG_CODMAN)
		QDG->(DBSkip())
		Loop
	EndIf
	
	_li := _nLin
	cDescP := Alltrim(QDG->QDG_CODMAN) + "  -  " +Alltrim(Posicione("QDC",1,xFilial("QDC") + QDG->QDG_CODMAN,"QDC_DESC"))
	oWWSay(@_Li,_c*09,90, cDescP ,.f.,aFontes[1])
	_nLin += 2

	QDG->(DBSkip())
enddo

//Desenha os traços
if !Impr
	oPrn:line(_l*_inic,_nColMax, _l*_nLin,_nColMax)
	oPrn:line(_l*_inic,_nColMin, _l*_nLin,_nColMin)
EndIf
	oPrn:line(_l*_nLin,_nColMin, _l*_nLin,_nColMax)

RestArea(_aArea)
Return

Static Function ImpCab()
Local _li := 2
nPag += 1 // Incrementa página

oPrn:Box(_nRowMin,_nColMin,_l*7,_nColMax)
_cLogo := "\system\LGESP.BMP"
if file(_cLogo) // Imprime a logomarca
	oSend(oPrn, "SayBitmap", 050, 060, _cLogo , 350,200 )
endif
oPrn:Say( _l*4, _c*20,"LAUDO TÉCNICO ANALÍTICO", aFontes[4])
Return (.t.)

Static Function oWWSay(nLin,nColI,nCols,cTexto,lLower, xFonte)
Local aWords := {}
Local aTexto := {}
Local i := 0

c := 1
AADD(aWords,"")
for i := 1 to len(cTexto)
	cCaracter := SubStr(cTexto,i,1)
	if cCaracter==" "
		AADD(aWords,"")
		c := c + 1
	else
		if len(aWords[c])>0 .and. lLower
			aWords[c] := aWords[c] + lower(cCaracter)
		else
			aWords[c] := aWords[c] + cCaracter
		endif
	endif
next i
AADD(aTexto,"")

c := 1
for i := 1 to len(aWords)
	if len(aTexto[c] + aWords[i]) > nCols
		AADD(aTexto,"")
		c := c+1
	endif
	aTexto[c] := aTexto[c] + aWords[i] + " "
next i

for i := 1 to len(aTexto)
	If xFonte == Nil
		oPrn:Say( _l*nLin+15, nColI,aTexto[i],aFontes[3]) //,100)
	Else
		oPrn:Say( _l*nLin+15, nColI,aTexto[i],xFonte) //,100)
	EndIf
	nLin := nLin + 1
next i
nLin ++
Return(.t.)

Static Function  ImpRoda(_li)
// Rodapé do Laudo
if _li + 17 > 79
	oPrn:Box(_l*_li,_nColMin, _l*(_li+5),_nColMax)
	oPrn:Say (_l*(_Li+1),_c*02,"OBS.:" , aFontes[2])
	oPrn:Say (_l*(_Li+1),_c*05,SubStr(TQEK->QEK_OBS,1,80),aFontes[1])
	oPrn:Say (_l*(_Li+3),_c*05,SubStr(TQEK->QEK_OBS,81,80),aFontes[1])
   
   oPrn:Say (_l*80, _c*41, GetMV("MV_QRVLAU"),aFontes[4] )
	AVNEWPAGE
	ImpCab()
	_Li := 8
	oPrn:Box(_l*_li,_nColMin, _l*(_li+10),_nColMax)
Else
	oPrn:Box(_l*_li,_nColMin, _l*(_li+15),_nColMax)
	oPrn:Say (_l*(_Li+1),_c*02,"OBS.:" , aFontes[2])
	oPrn:Say (_l*(_Li+1),_c*05,Replicate("          ",8) ,aFontes[1])
	oPrn:Say (_l*(_Li+3),_c*05,Replicate("          ",8) ,aFontes[1])
	_li += 5
EndIf

oPrn:Line(_l*(_li  ),_nColMin,_l*(_li),_nColMax) // DESENHA Linha
oPrn:Say (_l*(_Li+1)-30,_c*22,"AVALIAÇÃO FINAL" , aFontes[6])
oPrn:Line(_l*(_li+2),_nColMin,_l*(_li+2),_nColMax) // DESENHA Linha

oPrn:Box (_l*(_li+3),_c*02, _l*(_li+4),_c*03)
oPrn:Say (_l*(_Li+3),_c*04,"Aprovado" , aFontes[4])
oPrn:Box (_l*(_li+3),_c*20, _l*(_li+4),_c*21)
oPrn:Say (_l*(_Li+3),_c*22,"Reprovado" , aFontes[4])
oPrn:Box (_l*(_li+3),_c*35, _l*(_li+4),_c*36)
oPrn:Say (_l*(_Li+3),_c*37,"Aprovado com restrição", aFontes[4])
oPrn:Line(_l*(_li+5),_nColMin,_l*(_li+5),_nColMax) // DESENHA Linha

If cLaudo == "E"
	oPrn:Line(_l*(_li+3),_c*20,_l*(_li+4),_c*21) // DESENHA Linha
	oPrn:Line(_l*(_li+3),_c*21,_l*(_li+4),_c*20) // DESENHA Linha
ElseIf cLaudo == "A"
	oPrn:Line(_l*(_li+3),_c*02,_l*(_li+4),_c*03) // DESENHA Linha
	oPrn:Line(_l*(_li+3),_c*03,_l*(_li+4),_c*02) // DESENHA Linha
ElseIf cLaudo <> "U"
	oPrn:Line(_l*(_li+3),_c*35,_l*(_li+4),_c*36) // DESENHA Linha
	oPrn:Line(_l*(_li+3),_c*36,_l*(_li+4),_c*35) // DESENHA Linha
EndIf 

_Li += 4

oPrn:Line(_l*(_li+3),_c*02,_l*(_li+3),_c*24) // DESENHA Linha
oPrn:Say (_l*(_Li+4),_c*05,"Analista de Controle de Qualidade" , aFontes[3])
oPrn:Line(_l*(_li+1),_c*25,_l*(_li+6),_c*25) // DESENHA COLUNA
oPrn:Line(_l*(_li+3),_c*26,_l*(_li+3),_c*48) // DESENHA Linha
oPrn:Say (_l*(_Li+4),_c*28,"Responsável do Controle de Qualidade" , aFontes[3])
_Li += 6

oPrn:Line(_l*(_li),_nColMin,_l*(_li+4),_ncolMin) // DESENHA COLUNA
oPrn:Line(_l*(_li),_nColMax,_l*(_li+4),_ncolMax) // DESENHA COLUNA
oPrn:Say (_l*(_Li+1),_c*02,"Data Liberação:  " + DtoC(cDtLib) , aFontes[3])
oPrn:Say (_l*(_Li+1),_c*28,"Hora:  "+ cHora , aFontes[3])

_li += 3

If alltrim(cNrDoc) <> ""
	ImpdDist(@_li,cNrDoc,cRev )
Else
	oPrn:Line(_l*(_li),_nColMin,_l*(_li),_nColMax) // DESENHA Linha
EndIf    
oPrn:Say (_l*80, _c*41, GetMV("MV_QRVLAU"),aFontes[4]) 
return ()
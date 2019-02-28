#include "rwmake.ch"
#INCLUDE "avprint.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITQ002   ³Autor ³ Valeria de Novaes   ³Data ³  20/02/03   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Relatorio de Especificacao Tecnica de Materia Prima        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AP6 - Inspecao de Entregas / Controle de Documentos        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function Vitq002(cNrDoc, cRev)

Local _mArea  := {"QE6","QE7","QE8","QDH"}
Local _mAlias := {}
Local cRevi   := If(cRev <> Nil,StrZero(Val(cRev),2),"")
Local i := 0

PRIVATE cPerg := "PERGVIQ001"
Private nPag := 0
Private _cEnsDesc := ""
Private _li := 0

_mAlias := U_SalvaAmbiente(_mArea)

_pergsx1()

// Verificar se existe amarração produto x documento
If cNrDoc == Nil 
	pergunte(cPerg,.t.)
Else
	QZ1->(DBSetOrder(2))//  Order 2 = Documento + Produto
	QZ1->(DBSeek(xFilial("QZ1") + cNrDoc ))
	QE6->(DBSetOrder(1)) 
	mv_par01 := QE6->QE6_PRODUT //		mv_par02 := QE6->QE6_REVI
	If QE6->(DBSeek(xFilial("QE6") + QZ1->QZ1_PROD + Inverte(cRevi)))
		mv_par01 := QE6->QE6_PRODUT //		mv_par02 := QE6->QE6_REVI
	Else
		MsgAlert("DOCUMENTO/REVISÃO: " + Alltrim(cNrDoc) + " / " + cRev + chr(13)  + chr(13)+ Chr(10)+ "Não existe Amarração do Produto x Documento!" + chr(13)  + chr(13)+ Chr(10)+ "ou revisão divergente.")
		Return
	EndIf
	cTpDoc := M->QDH_CODTP
EndIf 

If cNrDoc == Nil
// Localiza especificação de produto
dbSelectArea("QE6")
dbSetOrder(1)
dbSeek(xFilial("QE6")+mv_par01)
if QE6->(Eof())
	MsgBox("Especificações de Produto não encontrada!")
	U_VoltaAmbiente(_mAlias)
	Return(.f.)
endif

	QZ1->(DBSetOrder(1))//  Order 1 = Produto + Documento
	QZ1->(DBSeek(xFilial("QZ1") +  QE6->QE6_PRODUT))
	QDH->(DBSetOrder(1)) // Poduto + documento
	If QDH->(DBSeek(xFilial("QDH") + QZ1->QZ1_DOCTO + StrZero(Val(QE6->QE6_REVI),3) ))
		cNrDoc := QDH->QDH_DOCTO
		cRev   := QDH->QDH_RV
		cTpDoc := QDH->QDH_CODTP // QDH->QDH_DTIMPL
	Else
		MsgAlert("PRODUTO/REVISÃO: " + Alltrim(QE6->QE6_PRODUT) + " / " + QE6->QE6_REVI + "  -  " + Alltrim(QE6->QE6_DESCPO) + "." + chr(13)  + chr(13) + Chr(10)  +  "Não existe Amarração do Produto x Documento"  + chr(13) + chr(13) + Chr(10)+ "ou revisão divergente.")
		Return
	EndIf
EndIf 

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
AVPRINT oPrn NAME "Especificacao Tecnica"

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
ImpCab(cNrDoc,cRev)

// Alimenta vetor com os dados dos Ensaios
_aEnsaio := DetEns(QE6->QE6_PRODUT, QE6->QE6_REVI)
aSort(_aEnsaio ,,,{|x, y| x[1]+x[2] < y[1]+y[2] })

oPrn:Box(_l*14,_nColMin, _l*16,_nColMax)
oPrn:Line(_l*14,_c*14,_l*17,_c*14) // DESENHA Coluna
oPrn:Say( _l*14+15,_c*2-15,"Código:", aFontes[4])
oPrn:Say( _l*14+15,_c*08,Alltrim(QE6->QE6_PRODUT), aFontes[3])

oPrn:Line(_l*14,_c*35+15,_l*16,_c*35+15) // DESENHA Coluna
oPrn:Say( _l*14+15,_c*15-15,"Descrição:", aFontes[4])
oPrn:Say( _l*14+15,_c*20,Alltrim(QE6->QE6_DESCPO), aFontes[3])

oPrn:Say( _l*14+15,_c*36,"Categoria:", aFontes[4])
oPrn:Say( _l*14+15,_c*42,Alltrim(QE6->QE6_CATEG), aFontes[3])

_li := 16
If Alltrim(QE6->QE6_TIPO) <> "ME"
	_cDCB := Alltrim(Posicione("SB1",1,xFilial("SB1") + QE6->QE6_PRODUT ,"B1_DCB1"))

	oPrn:Line(_l*16,_nColMin,_l*18,_nColMin) // DESENHA Coluna
	oPrn:Line(_l*16,_c*14,_l*18,_c*14) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*02-15,"DCB (DCI):", aFontes[4])
	oPrn:Say( _l*_li+15,_c*08,_cDCB, aFontes[3])

	oPrn:Line(_l*16,_c*35+15,_l*18,_c*35+15) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*15-15 ,"Fórmula Molecular:", aFontes[4])
	U_ImpFEmp(alltrim(QE6->QE6_FORMOL),24,15)

	oPrn:Line(_l*16,_nColMax,_l*18,_nColMax) // DESENHA Coluna
	oPrn:Say( _l*_li+15,_c*36,"Peso Molecular:", aFontes[4])
	oPrn:Say( _l*_li+15,_c*44,Transform(QE6->QE6_PESMOL,"@E 9,999,999,999.99"), aFontes[3])
	oPrn:Line(_l*18,_ncolMin,_l*18,_nColMax) // DESENHA Coluna
	_li += 2
EndIf 

oPrn:Line(_l*_li,_ncolMin,_l*(_li+2),_ncolMin) // DESENHA Coluna
oPrn:Line(_l*_li,_c*14,_l*(_li+2),_c*14) // DESENHA Coluna
oPrn:Line(_l*_li,_c*22,_l*(_li+2),_c*22) // DESENHA Coluna
oPrn:Line(_l*_li,_nColMax,_l*(_li+2),_ncolMax) // DESENHA Coluna
oPrn:Line(_l*(_li+2),_ncolMin,_l*(_li+2),_nColMax) // DESENHA Linha

oPrn:Say( _l*_li+15,_c*4,"TESTE", aFontes[4])
oPrn:Say( _l*_li+15,_c*15,"REFERÊNCIA"  , aFontes[4])
oPrn:Say( _l*_li+15,_c*30,"ESPECIFICAÇÃO", aFontes[4])

_li += 2
For i := 1 to Len(_aEnsaio)
	_Inicio := _li
	_nLin := _li
	
	//Imprime Teste
	oWWSay(@_li,_c*02,25, alltrim(_aEnsaio[i][6]),.f.,aFontes[1])

	// Imprime Referencias
	oPrn:Say (_l*(_nLin),_c*15,Alltrim(_aEnsaio[i][8]), aFontes[1])
	
	// Imprime Descricao
	oWWSay(@_nLin,_c*23,55, Upper(alltrim(_aEnsaio[i][4])),.f.,aFontes[1])
	If _li <= _nLin       
		_li := _nLin
	EndIf
	
	oPrn:Line(_l*_inicio,_ncolMin,_l*_li,_ncolMin) // DESENHA Coluna
	oPrn:Line(_l*_inicio,_c*14,_l*_li,_c*14) // DESENHA Coluna
	oPrn:Line(_l*_inicio,_c*22,_l*_li,_c*22) // DESENHA Coluna
	oPrn:Line(_l*_inicio,_nColMax,_l*_li,_ncolMax) // DESENHA Coluna
	oPrn:Line(_l*_li,_ncolMin,_l*_li,_nColMax) // DESENHA Linha

	If _Li >= 79
	   oPrn:Say (_l*80, _c*41, GetMV("MV_QRVET"),aFontes[4] )
		AVNEWPAGE
		ImpCab(cNrDoc,cRev)
		_Li := 19
	EndIf
Next

If alltrim(cNrDoc) <> ""
	ImpRef(@_li,cNrDoc, cRev)
EndIf

If alltrim(cNrDoc) <> ""
	ImpdDist(@_li,cNrDoc, cRev)
EndIf
oPrn:Say (_l*80, _c*41, GetMV("MV_QRVET"),aFontes[4] )

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
//aadd(_agrpsx1,{cperg,"02","Revisao         ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""   ,""})

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

Static Function DetEns(_cProd, _cRev)
Local aEnsaio  := {}
Local _cUniMed := ""
Local  _cDesc  := ""
_cEnsDesc := ""

DbSelectArea("QE7")
DbSetOrder(1)
DBSeek(xFilial("QE7") + _cProd + _cRev)

While !QE7->(EOF()) .and. QE7->QE7_PRODUT = _cProd .and. QE7->QE7_REVI == _cRev
   // Busca a unidade de medida a ser usada
	_cUniMed := Alltrim(Posicione("SAH",1,xFilial("SAH") + QE7->QE7_UNIMED,"AH_UMRES"))

	If QE7->QE7_MINMAX == "1"
		_cTxt := "Entre: " + Alltrim(QE7->QE7_LIE) + " e " + Alltrim(QE7->QE7_LSE) + "  " + _cUniMed
	ElseIf QE7->QE7_MINMAX == "2"
		_cTxt := "No minimo: " + Alltrim(QE7->QE7_LIE) + "  " + _cUniMed
	Else
		_cTxt := "No maximo: " + Alltrim(QE7->QE7_LSE) + "  " + _cUniMed
	EndIf
//	_cTxt := _cTxt + Space(150-Len(_cTxt))
	// Busca descrição do ensaio
	_cDesc := Alltrim(Posicione("QE1",1,xFilial("QE1") + QE7->QE7_ENSAIO,"QE1_DESCPO"))

	// 1 = Laboratorio; 2 = Sequencia do ensaio; 3 = Codigo Ensaio; 4 = Resultado a ser obtido; 5 = Tabela; 6 = Descricao do ensaio; 7 = Metodo utilizado; 8 = Referencia
	Aadd(aEnsaio,{QE7->QE7_LABOR, QE7->QE7_SEQLAB, QE7->QE7_ENSAIO,_cTxt,"QE7", _cDesc,Alltrim(QE7->QE7_METODO), QE7->QE7_REFER})
	
	QE7->(DBSkip())
EndDo

DbSelectArea("QE8")
DbSetOrder(1)
DBSeek(xFilial("QE8") + _cProd + _cRev)

While !QE8->(EOF()) .and. QE8->QE8_PRODUT == _cProd .and. QE8->QE8_REVI == _cRev
	// Busca descrição do ensaio
	_cDesc := Alltrim(Posicione("QE1",1,xFilial("QE1") + QE8->QE8_ENSAIO ,"QE1_DESCPO"))

	// 1 = Laboratorio; 2 = Sequencia do ensaio; 3 = Codigo Ensaio; 4 = Resultado a ser obtido; 5 = Tabela; 6 = Descricao do ensaio; 7 = Metodo utilizado; 8 = Referencia
	Aadd(aEnsaio,{QE8->QE8_LABOR, QE8->QE8_SEQLAB, QE8->QE8_ENSAIO, QE8->QE8_TEXTO,"QE8",_cDesc,Alltrim(QE8->QE8_METODO), QE8->QE8_REFER})

	QE8->(DBSkip())
EndDo

Return(aEnsaio)

Static Function  ImpRef(_nLin,cNrDoc, cRev)
Local _aArea := GetArea("QDH")
Local _Li := 0
Local _inic := _nLin 

oPrn:Say( _l*_nLin+15,_c*02,"Referência: ", aFontes[4])

dbSelectArea("QDB")
dbSetOrder(1)
dbSeek(xFilial("QDB") + cNrDoc + cRev)

while !QDB->(Eof()) .and. (cNrDoc == QDB->QDB_DOCTO) .and. (cRev == QDB->QDB_RV)
    _li := _nLin
	oWWSay(@_Li,_c*15,100, Alltrim(Str(Val(QDB->QDB_SEQ))) + "  -  " + alltrim(QDB->QDB_DESC),.f.)

	If QDH->(dbSeek(xFilial("QDH")+alltrim(QDB->QDB_DESC)))
 	   oWWSay(@_nLin,_c*15,100, "  " + alltrim	(QDH->QDH_TITULO),.f.)
	Else
	 _nLin += 2
	Endif

	If _nLin >= 79
		oPrn:line(_l*_inic,_nColMin, _l*_inic,_nColMax)
		oPrn:line(_l*_nLin,_nColMin, _l*_nLin,_nColMax)
		oPrn:Line(_l*_inic,_c*14,_l*_nLin,_c*14) // DESENHA Coluna
		oPrn:line(_l*_inic,_nColMin, _l*_nLin,_nColMin)
		oPrn:line(_l*_inic,_nColMax, _l*_nLin,_nColMax)
   	oPrn:Say (_l*80, _c*41, GetMV("MV_QRVET"),aFontes[4] )

		AVNEWPAGE
		ImpCab(cNrDoc,cRev)
		_nLin := 19
		_inic := _nLin
	EndIf

	QDB->(dbSkip())
enddo
If _inic == _nLin 
	_nLin += 2
endIf
oPrn:line(_l*_inic,_nColMin, _l*_inic,_nColMax)
oPrn:line(_l*_nLin,_nColMin, _l*_nLin,_nColMax)
oPrn:Line(_l*_inic,_c*14,_l*_nLin,_c*14) // DESENHA Coluna
oPrn:line(_l*_inic,_nColMin, _l*_nLin,_nColMin)
oPrn:line(_l*_inic,_nColMax, _l*_nLin,_nColMax)
RestArea(_aArea)
Return

Static Function  ImpdDist(_nLin,cNrDoc, cRev)
Local _aArea := GetArea("QDH")
Local _Li := 0
Local _inic := _nLin 
_nLin += 1
oPrn:Say( _l*_nLin,_c*02,"Distribuição: ", aFontes[4])

dbSelectArea("QDG")
dbSetOrder(1)
dbSeek(xFilial("QDG") + cNrDoc + cRev)

while !QDG->(Eof()) .and. (cNrDoc == QDg->QDG_DOCTO) .and. (cRev == QDG->QDG_RV)
	If _nLin >= 79
	oPrn:line(_l*_inic,_nColMin, _l*_inic,_nColMax)
	oPrn:line(_l*_nLin,_nColMin, _l*_nLin,_nColMax)
	oPrn:Line(_l*_inic,_c*14,_l*_nLin,_c*14) // DESENHA Coluna
	oPrn:line(_l*_inic,_nColMin, _l*_nLin,_nColMin)
	oPrn:line(_l*_inic,_nColMax, _l*_nLin,_nColMax)
	   oPrn:Say (_l*80, _c*41, GetMV("MV_QRVET"),aFontes[4] )

		AVNEWPAGE
		ImpCab(cNrDoc,cRev)
		_nLin := 19
		_inic := _nLin
	EndIf

    If QDG->QDG_TIPO <> "P" .and. empty(QDG->QDG_CODMAN)
		QDG->(DBSkip())       
		Loop
    EndIf

    _li := _nLin 
    cDescP := Alltrim(QDG->QDG_CODMAN) + "  -  " +Alltrim(Posicione("QDC",1,xFilial("QDC") + QDG->QDG_CODMAN,"QDC_DESC"))
	 oWWSay(@_Li,_c*15,100, cDescP ,.f.,aFontes[1])
	 
	 _nLin += 2
	 QDG->(DBSkip())       
enddo
//Desenha os traços
oPrn:line(_l*_inic,_nColMin, _l*_inic,_nColMax)
oPrn:line(_l*_nLin,_nColMin, _l*_nLin,_nColMax)
oPrn:Line(_l*_inic,_c*14,_l*_nLin,_c*14) // DESENHA Coluna
oPrn:line(_l*_inic,_nColMin, _l*_nLin,_nColMin)
oPrn:line(_l*_inic,_nColMax, _l*_nLin,_nColMax)
RestArea(_aArea)
Return

Static Function ConvNome(cNome)

cRet := ""
cRet := cRet + upper(substr(cNome,1,1))

for i := 2 to len(cNome)
	if substr(cNome,i-1,1)==" "
		cRet := cRet + upper(substr(cNome,i,1))
	else
		cRet := cRet + lower(substr(cNome,i,1))
	endif
next i

return(cret)

Static Function ImpCab(cNrDoc,cRev)
Local _li := 2

nPag += 1
oPrn:Box(_nRowMin,_nColMin,_l*13,_nColMax)
_cLogo := "\system\LGESP.bmp"
if file(_cLogo) // Imprime a logomarca
	oSend(oPrn, "SayBitmap", 050, 060, _cLogo , 350,200 )
endif

oPrn:Say( _l*4, _c*22,"ESPECIFICAÇÃO TÉCNICA", aFontes[4])

oPrn:Line(_l*7,_nColMin,_l*7,_ncolMax) // DESENHA Coluna

oPrn:Say( _l*7+15,_c*02-15,"DOCUMENTO Nº: ", aFontes[1])
oPrn:Say( _l*7+15,_c*09,Alltrim(cNrDoc), aFontes[1]) // Alltrim(cNrDoc)
oPrn:Line(_l*7,_c*19,_l*11,_c*19) // DESENHA Coluna

oPrn:Say( _l*7+15,_c*20-30,"DATA IMPLANTAÇÃO:", aFontes[1])
oPrn:Say( _l*7+15,_c*30,DTOC(QDH->QDH_DTIMPL), aFontes[1])
oPrn:Line(_l*7,_c*35,_l*11,_c*35) // DESENHA Coluna

oPrn:Say( _l*7+15,_c*36-15,"PÁGINA:", aFontes[1])
oPrn:Say( _l*7+15,_c*46,Alltrim(Str(nPag)), aFontes[1])
oPrn:Line((_l*9),_nColMin,(_l*9),_nColMax) // DESENHA Linha

oPrn:Say( _l*9+15,_c*02-15,"REVISÃO:", aFontes[1])
oPrn:Say( _l*9+15,_c*09,cRev, aFontes[1])

oPrn:Say( _l*9+15,_c*20-30,"DATA DA REVISAO:", aFontes[1])
oPrn:Say( _l*9+15,_c*30,DTOC(QDH->QDH_DTVIG), aFontes[1])

oPrn:Say( _l*9+15,_c*36-15,"DATA DA EMISSAO:", aFontes[1])
oPrn:Say( _l*9+15,_c*44,DTOC(dDataBase), aFontes[1])
oPrn:Line((_l*11),_nColMin,(_l*11),_nColMax) // DESENHA LINHA

_cSub := if(cRev <> "000", alltrim(cNrDoc) + "/" + StrZero(Val(cRev)-1,3), "" )
oPrn:Say( _l*11+15,_c*02-15,"SUBSTITUI: ", aFontes[1])
oPrn:Say( _l*11+15,_c*10+10,_cSub, aFontes[1])

Return

Static Function oWWSay(nLin,nColI,nCols,cTexto,lLower, xFonte)

LOCAL aWords := {}
LOCAL aTexto := {}
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
		oPrn:Say( _l*nLin+15, nColI-15,aTexto[i],aFontes[3]) //,100)
	Else
		oPrn:Say( _l*nLin+15, nColI-15,aTexto[i],xFonte) //,100)
	EndIf
	nLin := nLin + 1
next i
nLin ++
Return(.t.)

// Rotina para imprimir a formula Molecular da Especificação
User Function  ImpFEmp(_cForm,nCol,nSLi)
Local xF   
Local _nLi := 1
Local _cAnt := "C"

For xF := 1 to Len(_cForm)
   If _cAnt == "C"
      _nLi += 35
   Else
      _nLi += 20
   EndIf
   If Substr(_cForm, xF, 1) >= "0" .and. Substr(_cForm, xF, 1) <= "9"
	   oPrn:Say(_l*_li+(20+nSLi),(_c*nCol)+_nLi,SubStr(_cForm, xF, 1), aFontes[11])
	   _cAnt := "N"
   Else  
	   oPrn:Say(_l*_li+nSLi,(_c*nCol)+_nLi,SubStr(_cForm, xF, 1), aFontes[3])
	   _cAnt := "C"
   EndIf
Next  
Return()

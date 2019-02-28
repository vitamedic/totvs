#include "rwmake.ch"
#INCLUDE "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VITQ005     ³Autor ³Lucia Valeria        ³Data ³ 30/03/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Lista os Relatorios Relativos a Treinamento                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function Vitq005()
Local cTitulo := "REGISTRO DE TREINAMENTO"
Local cDesc1  := "Este programa ira imprimir o registro de presenca a ser "
Local cDesc2  := "utilizado durante o treinamento, controlando a presenca "
Local cDesc3  := "dos participantes e instrutores."
Local cString := "QD8"
Local wnrel   := "QDA0801"
Local Tamanho := "P"

Private aReturn  := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1 }
Private nLastKey := 0
Private cPerg := "PERGVIQ005"
Private Inclui := .t.

_pergsx1()
Pergunte("VIQ005", .t.)
If mv_par03 == 1
	wnrel := SetPrint( cString, wnrel, "", ctitulo, cDesc1, cDesc2, cDesc3, .f., , , Tamanho )
Else
	cTitulo := "CONVOCACAO DE TREINAMENTO"
	wnrel   := "QDA0802"
	wnrel := SetPrint( cString, wnrel, "", ctitulo, cDesc1, cDesc2, cDesc3, .f., , , Tamanho )
EndIf

If nLastKey != 27 // K_ESC
	SetDefault( aReturn, cString )
	If nLastKey != 27 // K_ESC
		If mv_par03 == 1
			RptStatus( { |lEnd| A080Imp1( @lEnd, ctitulo, wnRel, tamanho ) }, ctitulo )
		Else
			RptStatus( { |lEnd| A080Imp2( @lEnd, ctitulo, wnRel, tamanho ) }, ctitulo )
		EndIf
	Endif
Endif

RETURN( .T. )

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A080Imp1   ³Autor ³ Newton R. Ghiraldelli ³Data ³ 10/08/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia para Funcao que faz a Impressao do Relatorio.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A080Imp1( <lEnd>, <cTitulo>, <wnRel>, <tamanho> )          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ <lEnd>    =                                                ³±±
±±³          ³ <cTitulo> =                                                ³±±
±±³          ³ <wnRel>   =                                                ³±±
±±³          ³ <tamanho> =                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QDOA080                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function A080Imp1( lEnd, cTitulo, wnRel, tamanho )

Local cCabec1    := ""
Local cCabec2    := ""
Local cbtxt      := Space( 10 )
Local cbcont     := 0
Local cIndex1    := 0
Local nz         := 0
Local nInstrutor := 0
Local lList      := .f.

Private cDocumento := ""

QDA->(dbSetOrder(1))
QAA->(dbSetOrder(1))  
_cfilqaa:=xfilial("QAA")

IF !QDA->(dbSeek (xFilial("QDA") + mv_par01 + mv_par02))
	Return()
EndIF

dbSelectArea( "QDH" )
dbSetOrder( 1 )
If dbSeek( xFilial() + QDA->QDA_DOCTO + QDA->QDA_RV )
	cDocumento := Alltrim( QDH_TITULO )
EndIf
li    := 80
m_pag := 1

cIndex1 := CriaTrab( Nil, .f. )
DbSelectarea( "QD8" )
DbSetorder( 1 )
cFiltro :='QD8_FILIAL+QD8_ANO+QD8_NUMERO == "'+xFilial("QD8")+'"+QDA->QDA_ANO+QDA->QDA_NUMERO'
cKey    := IndexKey()
IndRegua( "QD8", cIndex1, cKey, , cFiltro, "Selecionando..." )
SetRegua( RecCount() )

aFunc := {}
While !Eof()
	IncRegua()
	If QD8->QD8_SELECA == "S"
		qaa->(dbseek(_cfilqaa+qd8->qd8_mat))				

		if qaa->qaa_status=="1" .or.;
			dtoc(qaa->qaa_fim)==""
				cNome := Alltrim(Posicione("QAA",1,QD8->QD8_FILMAT + QD8->QD8_MAT , "QAA_NOME" ))
				aAdd(aFunc,{cNome, QD8->QD8_MAT})
		endif
	EndIf
	QD8->(dbSkip())
EndDo
asort(aFunc ,,,{|x,y| x[1] < y[1] })

For i := 1 to Len(aFunc)
	If lEnd
		@ PROW() + 2, 01 PSAY "Cancelado pelo Operador"
		Exit
	EndIf

	If li > 58
		cabec( cTitulo, cCabec1, cCabec2, wnrel, Tamanho )
		impCab()
	Endif
	
	@ li, 00 PSay SubStr(aFunc[i,1],1,40)
	@ li, 52 PSay Replicate( "_", 25 )
	li += 2
Next

li += 2
@ li, 00 PSay "INSTRUTORES" //                                                              VISTO"
@ li, 52 Psay "VISTO"
li++

@ li, 00 PSay Replicate( "-", 80 )
li += 2

If !empty(QDA->QDA_MAT1)
	If li > 58
		cabec( cTitulo, cCabec1, cCabec2, wnrel, Tamanho )
		impCab()
	Endif
	
	@ li,00 PSay Posicione ("QAA",1,QDA->QDA_FILF1+QDA->QDA_MAT1, "QAA_NOME" ) //Substr( QA_nUsr( &( "QDA->QDA_FILF" + Str( nz, 1 ) ), &( "QDA->QDA_MAT" + Str( nz, 1 ) ), .T. ), 1, 30 )
	@ li,52 PSay Replicate("_",25)
	li += 2
EndIf

If !empty(QDA->QDA_MAT2)
	If li > 58
		cabec( cTitulo, cCabec1, cCabec2, wnrel, Tamanho )
		impCab()
	Endif
	
	@ li,00 PSay Posicione ("QAA",1,QDA->QDA_FILF2+QDA->QDA_MAT2, "QAA_NOME" ) 
	@ li,52 PSay Replicate("_",25)
	li += 2
EndIf

If !empty(QDA->QDA_MAT3)
	If li > 58
		cabec( cTitulo, cCabec1, cCabec2, wnrel, Tamanho )
		impCab()
	Endif
	
	@ li,00 PSay Posicione ("QAA",1,QDA->QDA_FILF3+QDA->QDA_MAT3, "QAA_NOME" ) 
	@ li,52 PSay Replicate("_",25)
	li += 2
EndIf

If li != 80
	li++
	roda( cbcont, cbtxt, "P" )
EndIf

Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool( wnrel )
Endif
MS_FLUSH()

Return .t.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A080Imp2   ³Autor ³Rodrigo de A. Sartorio ³Data ³ 06/07/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia para Funcao que faz a Impressao do Relatorio.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A080Imp2( <lEnd>, <ctitulo>, <wnRel>, <tamanho>)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ <lEnd>    =                                                ³±±
±±³          ³ <cTitulo> =                                                ³±±
±±³          ³ <wnRel>   =                                                ³±±
±±³          ³ <tamanho> =                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QDOA080                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function A080Imp2( lEnd, ctitulo, wnRel, tamanho )

Local cCabec1    := "CONVOCACAO DE TREINAMENTO"
Local cCabec2    := ""
Local cbtxt      := SPACE(10)
Local cbcont     := 0
Local cArqTexto  := ""

//Local aUsrMat    := QDOUSUARIO()
//Local cMatFil    := aUsrMat[2]
//Local cMatCod    := aUsrMat[3]
//Local cMatDep    := aUsrMat[4]






Private cDocumento := ""

QDA->(dbSetOrder(1))
IF !QDA->(dbSeek (xFilial("QDA") + mv_par01 + mv_par02))
	Return()
EndIF

dbSelectArea( "QDH" )
dbSetOrder( 1 )
If dbSeek(xFilial()+QDA->QDA_DOCTO+QDA->QDA_RV)
	cDocumento := Alltrim( QDH_TITULO )
EndIf

li    := 80
m_pag := 1

cIndex1 := CriaTrab( Nil, .f. )
DbSelectarea( "QD8" )
DbSetorder( 1 )

cFiltro :='QD8_FILIAL+QD8_ANO+QD8_NUMERO == "'+xFilial("QD8")+'"+QDA->QDA_ANO+QDA->QDA_NUMERO'
cKey    := IndexKey()
IndRegua( "QD8", cIndex1, cKey, , cFiltro, "Selecionando..." )

SetRegua( RecCount() )

While !EOF()
	
	IncRegua()
	
	If QD8->QD8_SELECA == "S"
		
		If lEnd
			li++
			@ PROW()+1, 01 PSAY "Cancelado pelo Operador"
			Exit
		EndIf
		
		If li > 58
			cabec( cTitulo, cCabec1, cCabec2, wnrel, Tamanho )
		EndIf
		
		@ li, 00 PSay QA_NUSR( QD8->QD8_FILMAT, QD8->QD8_MAT, .t. )
		li++
		@ li, 00 PSay QA_NDEPT( QD8->QD8_DEPTO, .t., QD8->QD8_FILMAT )
		li++
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime texto da convocacao do treinamento          			³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cTexto := MSMM(QDA->QDA_CONVOC,,,,3)
		While Len(cTexto) > 0
			_cTxt := fSepTxt(@cTexto,80)
			Li ++
			@Li, 00 Psay _cTxt
		EndDo

		li += 2
		@ li, 00 PSay "Documento:   " + QDA->QDA_DOCTO + " Revisao: " + QDA->QDA_RV
		
		If !Empty( cDocumento )
			li++
			If Len( cDocumento ) > 50
					@ li, 13 PSay Substr( cDocumento, 01, 50 )
				li++
				@ li, 13 PSay Substr( cDocumento, 51, 50 )
			Else
				@ li, 13 PSay cDocumento
			EndIf
			
		EndIf
		
		li+=2
		@ li, 00 PSay "Periodo de   " + DtoC( QDA->QDA_DTINIC ) + " " + ( Substr( QDA->QDA_HORAI,1,2)+":"+Substr( QDA->QDA_HORAI,3,2) ) + " a " + DTOC( QDA->QDA_DTFIM ) + " " + ( Substr( QDA->QDA_HORAF, 1, 2 ) + ":" + Substr( QDA->QDA_HORAF, 3, 2 ) )
		li+=2
		@ li, 00 PSay "Local:       " + QDA->QDA_LOCAL
		li+=2
		@ li, 00 PSay "Treinamento: " + QDA->QDA_NUMERO + "/" + QDA->QDA_ANO
		li+=2
//		@ li, 00 PSay "Departamento Emissor: " + QA_nDept( cMatDep, .t., cMatFil )
		li:=80
		
	EndIf
	dbSkip()
EndDo

If li != 80
	li++
	roda( cbcont, cbtxt, "P" )
EndIf

Set Device To Screen

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool( wnrel )
Endif
MS_FLUSH()

Return .t.

static function _pergsx1()

Local _sAlias := Alias()
Local _agrpsx1 := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
aadd(_agrpsx1,{cperg,"01","Ano do Treinamento  ?","","","mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ",""})
aadd(_agrpsx1,{cperg,"02","Codigo Treinamento  ?","","","mv_ch2","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ",""})
aadd(_agrpsx1,{cperg,"03","Relatorio           ?","","","mv_ch3","N",01,0,0,"C","","mv_par03","Reg. Treinamento","","","","","Conv. Treinamento","","","","","","","","","","","","","","","","","","","   ",""})

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

Static Function ImpCab()
@ li, 00 Psay "*"
@ li, 79 Psay "*"
li++
@ li, 00 PSay "*Treinamento: " + QDA->QDA_NUMERO + "/" + QDA->QDA_ANO
@ li, 79 Psay "*"
li++
@ li, 00 PSay "*Documento:   " + QDA->QDA_DOCTO + " Revisao: " + QDA->QDA_RV
@ li, 79 Psay "*"
li++
If !Empty( cDocumento )
	If Len( cDocumento ) > 50
		@ li, 00 Psay "*"
		@ li, 14 PSay Substr( cDocumento, 1, 50 )
		@ li, 79 Psay "*"
		li++
		@ li, 00 Psay "*"
		@ li, 14 PSay Substr( cDocumento, 51, 50 )
		@ li, 79 Psay "*"
	Else
		@ li, 00 Psay "*"
		@ li, 14 PSay cDocumento
		@ li, 79 Psay "*"
	EndIf
	li++
EndIf

@ li, 00 PSay "*Observacao:  " + SubStr(QDA->QDA_OBS,1,65)
if !empty(SubStr(QDA->QDA_OBS,66,130))
	li++
	@ li, 00 PSay "*             " + SubStr(QDA->QDA_OBS,66,130)
//	@ li, 79 Psay "*"
endif	
li++
@ li, 00 PSay "*Local:       " + QDA->QDA_LOCAL
@ li, 79 Psay "*"
li++
@ li, 00 PSay "*Periodo de   " + DtoC( QDA->QDA_DTINIC )+ " " + ( Substr( QDA->QDA_HORAI,1,2)+":"+Substr( QDA->QDA_HORAI,3,2) ) + " a " + DTOC( QDA->QDA_DTFIM ) + " " + ( Substr( QDA->QDA_HORAF, 1, 2 )+ ":" + Substr( QDA->QDA_HORAF, 3, 2 ) )
@ li, 79 Psay "*"
li++
@ li, 00 Psay "*"
@ li, 79 Psay "*"
li++
@ li, 00 Psay Replicate("*", 80 ) // "********************************************************************************"
li += 2
@ li, 00 Psay "TREINANDO" //                                                                 VISTO"
@ li, 52 Psay "VISTO"
li++
@ li, 00 PSay Replicate( "-", 80 )
li += 2
Return

Static Function fSepTxt(cTexto, nCol)
Local cRet:= Substr(cTexto,1,nCol) 

If At(chr(10), cRet) > 0 
	_nPos  := At(chr(10), cRet)
	cRet   := Substr(cRet,1,_nPos -1 ) 
	cTexto := Substr(ctexto,_nPos+1,len(ctexto))
ElseIf substr(cRet,nCol,1) == " " 
	cRet   := Substr(cTexto,1,nCol-1) 
   cTexto := SubStr(cTexto,nCol, Len(cTexto))
elseIf Len(cRet) >= (nCol -1)   
   _nPos := nCol -1 
   While substr(cRet,_nPos,1) <> " " 
      _nPos --
   EndDo
   _AuxTex := RTrim(SubStr(cRet,1,_nPos))
   cTexto := SubStr(cTexto,_nPos +1 , Len(cTexto)) 

	cret := ""
	While Len(cRet+_AuxTex) < (nCol - 1)
		_nPos := At(" ",_AuxTex)
	   cRet  += substr(_AuxTex,1,_nPos) + " " // Substr(cRet,_nPos,len(cRet))
   	_AuxTex := substr(_AuxTex,_nPos+1,Len(_AuxTex))
	EndDo
	cret := cret + _AuxTex
Else
  ctexto := ""
EndIf

Return(cRet)

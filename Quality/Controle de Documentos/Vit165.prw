
#include "rwmake.ch"
#INCLUDE "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Vit165    ³Autor  ³Lúcia Valeria      ³Data ³  11/27/03    ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±³Descricao  ³ Rotina para Duplicar Documentos                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AP                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function Vit165
Private _cperg := "VIT165"

_pergsx1()

pergunte(_cPerg,.t.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,400 DIALOG oDupDocto TITLE OemToAnsi("Duplicar Documento")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira duplicar documentos do Controle de Documen- "
@ 18,018 Say " tos, conforme a definição de parametros.                      "

@ 60,100 BMPBUTTON TYPE 05 ACTION pergunte(_cPerg,.t.)
@ 60,130 BMPBUTTON TYPE 01 ACTION DuplDoc()
@ 60,160 BMPBUTTON TYPE 02 ACTION Close(oDupDocto)

Activate Dialog oDupDocto Centered

Return

static Function DuplDoc()
//Local aUsrMat  := QDOUSUARIO()
//Local lApelido := aUsrMat[1]
Local lCopiou  := .f.

lapelido := .t.

Private cFileCEL := "000001"+SubStr(StrZero(Year(dDataBase),4),3,2)+".CEL"
Private aQPath    := QDOPATH()
Private cQPath    := aQPath[1]
Private cQPathTrm := aQPath[3]

If !lApelido
	Help( " ", 1, "QD_APELIDO" )
	Return .f.
Endif


QDH->(DbSetOrder(1))
QDH->(DbGoTop())

If QDH->(DBSeek(xFilial("QDH") + mv_par03))
	MsgStop("Documento: " + alltrim(mv_par03) + " já existe.")
	return .f.
EndIf

If !(QDH->(DBSeek(xFilial("QDH") + mv_par01 + mv_par02)))
	MsgStop("Documento/Revisão: " + mv_par01 + " / " + mv_par02 + " a ser duplicado não existe.")
	return .f.
EndIf

If QDH->QDH_STATUS != "L  " // Verifica se o documento esta finalizado
	Help( " ", 1, "QDA090DRVA" )
	Return .f.
EndIf

If !QAA->(DBSeek(xFilial("QAA") + mv_par05))
	MsgStop("Matricula: " + Mv_par05 + " não esta cadastrada no sistema. Verifique!")
	return .f.
EndIf

// Duplicar arquivo do Word
_cDocto  := QDH->QDH_DOCTO
_cRv     := QDH->QDH_RV
_cNomDoc := QDH->QDH_NOMDOC
_cChDoc  := QDH->QDH_CHAVE
While File( cQPath + cFileCEL ) // Verificando se existe o arquivo que será criado
	cFileCEL := STRZERO( VAL( QA_SEQU( "QDH", 6, "N" ) ), 6 ) + SubStr(StrZero(year(dDataBase),4),3,2)+".CEL"
Enddo

ProcessaDoc( { || CopDoc(@lCopiou) } ) // Copiar Documento

If !lCopiou
	MSGStop("Documento não foi copiado. Verifique!!!")
	Return .f.
endIf


//Duplicar campo do Cadastro de Documento - QDH
cChave   := xFilial( "QDH" ) + mv_par03 
cChave   := QA_CvKey( cChave, "QDH", 2, "QDP", 2, .T., {"OBJ","TXT","COM","REV","SUM","CRI","CRT","ITA"} )

_aQDH := Array(QDH->(fCount()))
For i:= 1 to QDH->(fCount()) // copia o conteudo do QDH
	_aQdh[i] := QDH->(FieldGet(i))
Next

QDH->(RecLock("QDH",.t.))
FOR i:= 1 to QDH->(fCount())   // Gera novo registro e transporta dados
	QDH->(fieldPut(i, _aQdh[i]))
Next
QDH->QDH_DOCTO  := mv_par03
QDH->QDH_RV     := mv_par04
QDH->QDH_NOMDOC := cFileCEL
QDH->QDH_STATUS := "D"
QDH->QDH_OBSOL  := "N"
QDH->QDH_CANCEL := "N"
QDH->QDH_DTVIG  := Ctod(" / /")
QDH->QDH_DTLIM  := Ctod(" / /")
QDH->QDH_DTFIM  := Ctod(" / /")
QDH->QDH_DTIMPL := Ctod(" / /")
QDH->QDH_DTCAD  := dDataBase
QDH->QDH_CHAVE  := cChave
QDH->QDH_MAT    := mv_par05

QDH->(msunlock())
// Grava o motivo da Revisão                  
QA2->(RecLock("QA2",.t.))
QA2->QA2_FILIAL := xFilial("QA2")
QA2->QA2_CHAVE  := cChave
QA2->QA2_ESPEC  := "REV"
QA2->QA2_SEQ    := "001"
QA2->QA2_TEXTO  := "Implantacao do novo sistema da garantia da qualidade."
QA2->(msunlock())

//Grava Objetivo do Documento
QA2->(DBSetOrder(1))
QA2->(DBSeek(xFilial("QA2") + _cChDoc))
While QA2->QA2_CHAVE  == _cChDoc
	_aQDH := Array(QA2->(fCount()))
	For i:= 1 to QA2->(fCount()) // Copia dados do 
		_aQdh[i] := QA2->(FieldGet(i))
	Next
	_aArea := QA2->(GetArea())
	QA2->(RecLock("QA2",.t.))

	FOR i:= 1 to QA2->(fCount())
		QA2->(fieldPut(i, _aQdh[i]))
	Next

	QA2->QA2_CHAVE := cChave
	QA2->(msunlock())
	RestArea(_aArea)
	QA2->(DBSkip())
EndDo

// Duplicar campo do Destinatário - QDG
QDG->(DBSetOrder(1))
QDG->(DBSeek(xFilial("QDG") + _cDocto + _cRV))
While QDG->QDG_DOCTO + QDG->QDG_RV == _cDocto + _cRV
	_aQDH := Array(QDG->(fCount()))
	For i:= 1 to QDG->(fCount()) // Copia dados do 
		_aQdh[i] := QDG->(FieldGet(i))
	Next
	_aArea := QDG->(GetArea())
	QDG->(RecLock("QDG",.t.))

	FOR i:= 1 to QDG->(fCount())
		QDG->(fieldPut(i, _aQdh[i]))
	Next

	QDG->QDG_DOCTO  := mv_par03
	QDG->QDG_RV     := mv_par04
	QDG->(msunlock())
	RestArea(_aArea)
	QDG->(DBSkip())
EndDo

// Duplicar Destinos - QDJ
QDJ->(DBSetOrder(1))
QDJ->(DBSeek(xFilial("QDJ") + _cDocto + _cRV))
While QDJ->QDJ_DOCTO + QDJ->QDJ_RV == _cDocto + _cRV
	_aQDH := Array(QDJ->(fCount()))
	For i:= 1 to QDJ->(fCount())
		_aQdh[i] := QDJ->(FieldGet(i))
	Next
	
	_aArea := QDJ->(GetArea())
	QDJ->(RecLock("QDJ",.t.))
	FOR i:= 1 to QDJ->(fCount())
		QDJ->(fieldPut(i, _aQdh[i]))
	Next
	QDJ->QDJ_DOCTO  := mv_par03
	QDJ->QDJ_RV     := mv_par04
	QDJ->(msunlock())
	RestArea(_aArea)
	QDJ->(DBSkip())
EndDo

// Duplicar Campos do Responsáveis pelo Documento - QD0
QD0->(DBSetOrder(1))
QD0->(DBSeek(xFilial("QD0") + _cDocto + _cRV))
While QD0->QD0_DOCTO == _cDocto .and. QD0->QD0_RV == _cRV
	_aQDH := Array(QD0->(fCount()))
	For i:= 1 to QD0->(fCount())
		_aQdh[i] := QD0->(FieldGet(i))
	Next
	
	_aArea := QD0->(GetArea())
	QD0->(RecLock("QD0",.t.))
	FOR i:= 1 to QD0->(fCount())
		QD0->(fieldPut(i, _aQdh[i]))
	Next
	QD0->QD0_DOCTO  := mv_par03
	QD0->QD0_RV     := mv_par04
	QD0->(msunlock())
	RestArea(_aArea)
	QD0->(DBSkip())
EndDo

// Duplicar Referencia e Cadastrar o documento a ser duplicado como Referencia - QDB
_nSeq :=  0
QDB->(DBSetOrder(1))
QDB->(DBSeek(xFilial("QDB") + _cDocto + _cRV))
While QDB->QDB_DOCTO + QDB->QDB_RV == _cDocto + _cRV
	_aQDH := Array(QDB->(fCount()))
	For i:= 1 to QDB->(fCount())
		_aQdh[i] := QDB->(FieldGet(i))
	Next
	
	_aArea := QDB->(GetArea())
	QDB->(RecLock("QDB",.t.))
	FOR i:= 1 to QDB->(fCount())
		QDB->(fieldPut(i, _aQdh[i]))
	Next
	QDB->QDB_DOCTO  := mv_par03
	QDB->QDB_RV     := mv_par04
	_nSeq ++
	QDB->(msunlock())
	RestArea(_aArea)
	QDB->(DBSkip())
EndDo

QDB->(RecLock("QDB",.t.))
QDB->QDB_FILIAL := xFilial("QDB")
QDB->QDB_SEQ    := strZero(_nSeq+1,4)
QDB->QDB_DOCTO  := mv_par03
QDB->QDB_RV     := mv_par04
QDB->QDB_ORIGEM := "I"
QDB->QDB_REVIS  := "S"
QDB->QDB_DESC   := _cDocto + _cRv
QDB->(msunlock())

// Cadastrar Pendencia para o usuário do parametro mv_par04 - QD1

QD1->(RecLock("QD1",.t.))
QD1->QD1_FILIAL := xFilial("QD1")
QD1->QD1_DOCTO  := mv_par03
QD1->QD1_RV     := mv_par04
QD1->QD1_FILMAT := QAA->QAA_FILIAL
QD1->QD1_MAT    := mv_par05
QD1->QD1_DEPTO  := QAA->QAA_CC
QD1->QD1_DTGERA := dDataBase
QD1->QD1_HRGERA := Time()
QD1->QD1_TPPEND := "D"
QD1->QD1_PENDEN := "P"
QD1->QD1_LEUDOC := "N"
QD1->QD1_CARGO  := QAA->QAA_CODFUN
QD1->QD1_TPDIST := "1"
QD1->(msunlock())

Close(oDupDocto)
Return

Static Function CopDoc(lCopiou)

Local cFileTrm := ""
Local oWord
Local cMvSave   := IIf( GetMV("MV_QSAVPSW",.F.,"1") == "1","CELEWIN400","" ) // "Verifica se insere senha ou nao
Local cArquivo  := cQPath + _cNomDoc

Private cEdit   := Alltrim( GetMV( "MV_QDTIPED" ) )
Private cEditor := "TMsOleWord97" //Space(12)

RegProcDoc( 04 )
//ExecBlock( "QDOM700", .f., .f., { cEdit, cEditor } )

cFileTrm := ""
For nTrm:= Len(cArquivo) to 1 STEP -1
	If SubStr(cArquivo,nTrm,1) == "\"
		Exit
	Endif
	cFileTrm := SubStr(cArquivo,nTrm,1)+cFileTrm
Next

If At(":",cArquivo) == 0
	CpyS2T(cArquivo,cQPathTrm,.T.)
Else
	__CopyFile(cArquivo,cQPathTrm+cFileTrm)
Endif

__CopyFile(cArquivo,cQPathTrm+cFileCel) // Copia o Original para outro arquivo

If CpyT2S(cQPathTrm+cFileCel,cQPath,.T.)
	lCopiou:= .T.
Else
	lCopiou:= .F.
EndIf

If File(cQPathTrm+cFileCel)
	FErase(cQPathTrm+cFileCel)
Endif
If File(cQPathTrm+cFileTrm)
	FErase(cQPathTrm+cFileTrm)
Endif

Return nil


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Duplicar do Docto. ?","mv_ch1","C",16,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QDH"})
aadd(_agrpsx1,{_cperg,"02","Revisão do Docto.  ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Para o Docto.      ?","mv_ch3","C",16,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Para Revisão       ?","mv_ch4","C",03,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","Gerar Pend. para   ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QAA"})

for i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[i,1]+_agrpsx1[i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[i,01]
		sx1->x1_ordem  :=_agrpsx1[i,02]
		sx1->x1_pergunt:=_agrpsx1[i,03]
		sx1->x1_variavl:=_agrpsx1[i,04]
		sx1->x1_tipo   :=_agrpsx1[i,05]
		sx1->x1_tamanho:=_agrpsx1[i,06]
		sx1->x1_decimal:=_agrpsx1[i,07]
		sx1->x1_presel :=_agrpsx1[i,08]
		sx1->x1_gsc    :=_agrpsx1[i,09]
		sx1->x1_valid  :=_agrpsx1[i,10]
		sx1->x1_var01  :=_agrpsx1[i,11]
		sx1->x1_def01  :=_agrpsx1[i,12]
		sx1->x1_cnt01  :=_agrpsx1[i,13]
		sx1->x1_var02  :=_agrpsx1[i,14]
		sx1->x1_def02  :=_agrpsx1[i,15]
		sx1->x1_cnt02  :=_agrpsx1[i,16]
		sx1->x1_var03  :=_agrpsx1[i,17]
		sx1->x1_def03  :=_agrpsx1[i,18]
		sx1->x1_cnt03  :=_agrpsx1[i,19]
		sx1->x1_var04  :=_agrpsx1[i,20]
		sx1->x1_def04  :=_agrpsx1[i,21]
		sx1->x1_cnt04  :=_agrpsx1[i,22]
		sx1->x1_var05  :=_agrpsx1[i,23]
		sx1->x1_def05  :=_agrpsx1[i,24]
		sx1->x1_cnt05  :=_agrpsx1[i,25]
		sx1->x1_f3     :=_agrpsx1[i,26]
		sx1->(msunlock())
	endif
next
return

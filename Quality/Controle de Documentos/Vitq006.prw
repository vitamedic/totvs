#include "rwmake.ch"
#include "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VITQ006   ³Autor  ³Lúcia Valéria       ³Data ³  30/03/04    ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Desc.     ³                                                            ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ AP                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function VITQ006()
Local _cFunc := Space(6)
Local _NewCC := Space(9)

Private cNome  := Space(50)
Private cCc    := Space(70)
Private cDesCc := Space(50)
private cFil   := ""

@ 200,1 TO 400,470 DIALOG oQDOCc TITLE OemToAnsi("Troca de Centro de Custo Controle de Documento")
@ 02,10 TO 095,230
@ 10,018 Say " Este programa ira realizar a troca de centro de custo do funcionário nos arquivo de  "
@ 18,018 Say " controle de documentos "
@ 30,015 Say "Mat/Nome: "
@ 30,045 Get _cFunc valid  fFunc(_cFunc) F3 "QAA"
@ 30,075 Get  cNome  picture "@!" when .f.
@ 48,015 Say "CC/Desc.: "
@ 48,045 Get  cCc    when .f.
@ 65,015 Say "Novo CC: "
@ 65,045 Get _NewCC Valid fNexCC(_NewCC) F3 "SI3"
@ 65,085 Get cDesCc when .f.

@ 80,140 BMPBUTTON TYPE 01 ACTION 	Processa({|lEnd| GravaCC(_cFunc,_NewCC)})
@ 80,170 BMPBUTTON TYPE 02 ACTION Close(oQdoCc)

Activate Dialog oQdoCc Centered

Return

Static Function GravaCC(_cFunc,_NewCC)
Local _mArea  := {"QDH","QD1","QD0","QDG","QDP"}
_mAlias := U_SalvaAmbiente(_mArea)

DbSelectArea("QD1")
DbSetOrder(6)
DbSeek(cFil + _cFunc )
procregua(QD1->(lastrec()))
While !QD1->(EOF()) .and. QD1->QD1_FILMAt == cFil .and. QD1->QD1_MAT == _cFunc
   incproc("Ajustando o C.Custo da Distrib. por Usuário (QD1)..." )
   If QD1->QD1_DEPTO == _NewCC
	   QD1->(DBSkip())
	   Loop
   EndIf

   QD1->(RecLock("QD1",.f.))
      QD1->QD1_DEPTO := _NewCC
   QD1->(msUnLock())
   QD1->(DBSkip())
EndDo
                         
cIndQDH := "QDH_FILMAT, QDH_MAT"
cQDHIndex := CriaTrab(nil,.F.)
DbSelectArea("QDH")
IndRegua("QDH", cQDHIndex, cIndQDH,,,"Indexando QDH2 para o processamento ....")
nIndex := RetIndex("QDH")
#IFNDEF TOP
	DbSetIndex(cQDHIndex+OrdBagExt())
#ENDIF
DbSetOrder(nIndex+1)
DbSeek(cFil + _cFunc )
procregua(QDH->(lastrec()))
While !QDH->(EOF()) .and. QDH->QDH_FILMAt == cFil .and. QDH->QDH_MAT == _cFunc
   incproc("Ajustando o C.Custo dos Documentos (QDH)..." )
   If QDH->QDH_DEPTOE == _NewCC
	   QDH->(DBSkip())
	   Loop
   EndIf

   QDH->(RecLock("QDH",.f.))
      QDH->QDH_DEPTOE := _NewCC
   QDH->(msUnLock())
   QDH->(DBSkip())
EndDo

cIndQD0 := "QD0_FILMAT, QD0_MAT"
cQD0Index := CriaTrab(nil,.F.)
DbSelectArea("QD0")
IndRegua("QD0", cQD0Index, cIndQD0,,,"Indexando QD0 para o processamento ....")
nIndex := RetIndex("QD0")
#IFNDEF TOP
	DbSetIndex(cQD0Index+OrdBagExt())
#ENDIF
DbSetOrder(nIndex+1)
DbSeek(cFil + _cFunc )
procregua(QD0->(lastrec()))
While !QD0->(EOF()) .and. QD0->QD0_FILMAt == cFil .and. QD0->QD0_MAT == _cFunc
   incproc("Ajustando o C.Custo do Resp. por Documento (QD0)..." )
   If QD0->QD0_DEPTO == _NewCC
	   QD0->(DBSkip())
	   Loop
   EndIf

   QD0->(RecLock("QD0",.f.))
      QD0->QD0_DEPTO := _NewCC
   QD0->(msUnLock())
   QD0->(DBSkip())
EndDo

cIndQDG := "QDG_FILMAT, QDG_MAT"
cQDGIndex := CriaTrab(nil,.F.)
DbSelectArea("QDG")
IndRegua("QDG", cQDGIndex, cIndQDG,,,"Indexando QDG para o processamento ....")
nIndex := RetIndex("QDG")
#IFNDEF TOP
	DbSetIndex(cQDGIndex+OrdBagExt())
#ENDIF
DbSetOrder(nIndex+1)
DbSeek(cFil + _cFunc )
procregua(QDG->(lastrec()))
While !QDG->(EOF()) .and. QDG->QDG_FILMAt == cFil .and. QDG->QDG_MAT == _cFunc
   incproc("Ajustando o C.Custo do Destinatários (QDG)..." )

   If QDG->QDG_DEPTO == _NewCC
	   QDG->(DBSkip())
	   Loop
   EndIf

   If QDG->QDG_TIPO == "P" 
      If QDJ->(DBSeek(xFilial("QSJ") + QDG->QDG_DOCTO + QDG->QDG_RV))
	   QDJ->(RecLock("QDJ",.f.))
    	  QDJ->QDJ_DEPTO := _NewCC
	   QDJ->(msUnLock())
      EndIf
   EndIf

   QDG->(RecLock("QDG",.f.))
      QDG->QDG_DEPTO := _NewCC
   QDG->(msUnLock())
   QDG->(DBSkip())
EndDo

cIndQDP := "QDP_FILMAT, QDP_MAT"
cQDPIndex := CriaTrab(nil,.F.)
DbSelectArea("QDP")
IndRegua("QDP", cQDPIndex, cIndQDP,,,"Indexando QDP para o processamento ....")
nIndex := RetIndex("QDP")
#IFNDEF TOP
	DbSetIndex(cQDPIndex+OrdBagExt())
#ENDIF
DbSetOrder(nIndex+1)
procregua(QDP->(lastrec()))
While !QDP->(EOF()) .and. QDP->QDP_FILMAt == cFil .and. QDP->QDP_MAT == _cFunc
   incproc("Ajustando o C.Custo do Solicitação (QDP)..." )

   If QDP->QDP_DEPTO == _NewCC
	   QDP->(DBSkip())
	   Loop
   EndIf

   QDP->(RecLock("QDP",.f.))
      QDP->QDP_DEPTO := _NewCC
   QDP->(msUnLock())
   QDP->(DBSkip())
EndDo

FErase( cQD0Index + OrdBagExt() )
FErase( cQDGIndex + OrdBagExt() )
FErase( cQDHIndex + OrdBagExt() )
FErase( cQDPIndex + OrdBagExt() )

U_VoltaAmbiente(_mAlias)
Close(oQdoCc)
Return

Static Function  fFunc(cMat)
Local cRet := .t.
If QAA->( DBSeek(xFilial("QAA") + cMat))
	cFil  := QAA->QAA_FILIAL
	cNome := Alltrim(QAA->QAA_NOME)
	cCC   := Alltrim(QAA->QAA_CC) + " - " + Posicione("SI3",1,xFilial("SI3") + QAA->QAA_CC,"I3_DESC")
Else
	Alert("Funcionário não encontrado")
	cRet := .f.
EndIf

Return (cRet)

Static Function fNexCC(cCodCC)
Local cRet := .t.
If SI3->(DbSeek(xFilial("SI3") + cCodCC ))
	cDesCc := Alltrim(SI3->I3_DESC)
Else
	Alert("Centro de Custo não Cadastrado")
	cRet := .f.
EndIF
Return(cRet)


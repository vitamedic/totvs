//#INCLUDE "QDOR060.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QDOR060  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 15/07/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Protocolo de Entrega de Documentos e Registros da QuaLidade³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QDOR060                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALiZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aldo        ³31/03/00³      ³Inclusao do Tipo de Distribuicao          ³±±
±±³Aldo        ³02/08/01³      ³Acerto na quebra de pagina/cabecalho      ³±±
±±³Eduardo S.  ³21/10/01³10625 ³Acertado para permitir a alteracao do ti- ³±±
±±³            ³        ³      ³tulo padrao do protocolo                  ³±±
±±³Marcelo Myra³10/04/02³KINDER³Adequacao ao processo do cliente          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DRQDO001(lBat)
Local cTitulo := "PROTOCOLO DE ENTREGA E RECOLHIMENTO DE DOCUMENTOS E REGISTROS DA QUALIDADE"
LOCAL cDesc1  := "Este programa ir  imprimir o Protocolo de Entrega de Documentos"
LOCAL cDesc2  := "e Registros da QuaLidade, que assegura o recebimentde documentos"
LOCAL cDesc3  := "por todos os envolvidos em sua implementa‡„o"
LOCAL cString :="QDH"
LOCAL wnrel   :="QDOR060"
LOCAL Tamanho :="P"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel utiLizada para verificar se o relatorio foi iniciado³
//³ pelo MNU ou pela rotina de documentos.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lBat:=IF(lBat == NIL,.F.,lBat)

PRIVATE cPerg :=IF(lBat,"QDR061","QDR060")
PRIVATE aReturn   := { "Zebrado",1,"Administra‡„o", 2, 2, 1, "",1 }
PRIVATE nLastKey:=0
Private INCLUI    := .F.  // Colocada para utiLizar as funcoes
Private Li        := 80
Private m_pag := 1

// Salva a posicao do Documento
If lBat
  Private cChave:=QDH->QDH_FILiAL+QDH->QDH_DOCTO+QDH->QDH_RV
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utiLizadas para parametros                               ³
//³ mv_par01  // Quebra por Departamento 1- Sim 2-Nao                 ³
//³ mv_par02  // De Documento                                         ³
//³ mv_par03  // Ate Documento                                        ³
//³ mv_par04  // De  Revisao                                          ³
//³ mv_par05  // Ate Revisao                                          ³
//³ mv_par06  // De  Depto. Destino                                   ³
//³ mv_par07  // Ate Depto. Destino                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

wnrel :=  SetPrint(cString,wnrel,cPerg,ctitulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)
cTitulo :=Iif(TYPE("NewHead")!="U",NewHead,cTitulo)

If nLastKey == 27
  Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
  Return
Endif

RptStatus({|lEnd| QDOR060Imp(@lEnd,ctitulo,wnRel,tamanho,lBat)},ctitulo)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³QDOR060Imp³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 15/07/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia para funcao que faz a impressao do relatorio.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QDOR060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QDOR060Imp(lEnd,ctitulo,wnRel,tamanho,lBat)
Local cCabec1  :=""
Local cbtxt    := SPACE(10)
Local cbcont   :=0
Local cTxtCopia:=""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Variaveis utiLizadas para quebra de pagina                       ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cOldDoc :=""
Local cOldDepto:=""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Variaveis utiLizadas para while                                  ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cSeek       :=""
Local cCompara    :=""
Local cSeek2  :=""
Local cCompara2:=""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Variaveis utiLizadas pela IndRegua                               ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cIndex1 :=""
Local cIndex2 :=""
Local cFiltro :=""
Local cKey        :=""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utiLizadas na impressao do texto de convocacao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cArqTexto := GETMV("MV_QTXTPRO")    // Parametro com o nome do arquivo
Local cTipPro   := GETMV("MV_QDOTPPR") // Parametro para impressao de somente copias em pael ou nao
Local aTxtCopia := { " Eletronicas"," Em Papel"," Eletronica/Papel"," Nao Recebe"} 

Local aRegQDG   := {}

Private aDriver := ReadDriver()

// Retorna a Posicao do QDH - Documentos
If lBat
  dbSelectarea("QDH")
  dbSetOrder(1)
  dbSeek(cChave)
Endif

If !lBat
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Cria Indice Condicional nos arquivos utiLizados ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cIndex1 := CriaTrab(Nil,.F.)
  dbSelectarea("QDH")
  dbSetOrder(1)
  cKey:=IndexKey()

  cFiltro:='QDH_FILiAL=="'+xFiLial("QDH")+'".And.'
  cFiltro+='QDH_DOCTO>="'+mv_par02+'".And.QDH_DOCTO<="'+mv_par03+'".And.'
  cFiltro+='QDH_RV>="'+mv_par04+'".And.QDH_RV<="'+mv_par05+'"'
  IndRegua("QDH",cIndex1,cKey,,cFiltro,"Selecionando Registros..") 
EndIf

cIndex2 := CriaTrab(Nil,.F.)
dbSelectarea("QD1")
dbSetOrder(1)
cKey:=IndexKey()

If !lBat
  cFiltro:='QD1_FILiAL=="'+xFiLial("QD1")+'".And.'
  cFiltro+='QD1_DOCTO>="'+mv_par02+'".And.QD1_DOCTO<="'+mv_par03+'".And.'
  cFiltro+='QD1_RV>="'+mv_par04+'".And.QD1_RV<="'+mv_par05+'".And.'
  cFiltro+='QD1->QD1_DEPTO>="'+mv_par06+'".And.QD1->QD1_DEPTO<="'+mv_par07+'"'
  cFiltro+='.And.QD1->QD1_TPPEND=="L  "'
Else
  cFiltro:='QD1_FILiAL=="'+QDH->QDH_FILiAL+'".And.'
  cFiltro+='QD1_DOCTO=="'+QDH->QDH_DOCTO+'".And.'
  cFiltro+='QD1_RV=="'+QDH->QDH_RV+'".And.'
  cFiltro+='QD1->QD1_TPPEND=="L  "'
EndIf

If cTipPro =="S"
   cFiltro += '.And. QD1->QD1_TPDIST$"2,3"'
Endif

IndRegua("QD1",cIndex2,cKey,,cFiltro,"Selecionando Registros..") 

//cCabec1:="RESPONSAVEL                  TIPO    COPIAS                DATA    ASSINATURA"
//        1234567890123456789012345678 USUARIO 01234567890123456 ___/___/___ 1234567890123
cCabec1:="PASTA                           CONTROLE DISTRIBUICAO     CONTROLE RECOLHIMENTO "
//        123456789012345678901234567890  ___/___/___ 1234567890123 ___/___/___ 1234567890123
//                 1         2         3         4         5         6         7         8
//       012345678901234567890123456789012345678901234567890123456789012345678901234567890
// Posicoes 000-029-037-055-068

Li       := 80
m_pag    := 1

// Total de Elementos da Regua
SetRegua(If(!lBat,QDH->(LastRec()),QD1->(LastRec())))

dbSelectArea("QDG")
dbSetOrder(3)
dbSelectArea("QDH")

Do While !EOF()
  If !lBat
      IncRegua()
  EndIf
  cSeek:=xFiLial()+QDH_DOCTO+QDH_RV
  cCompara:="QD1_FILiAL+QD1_DOCTO+QD1_RV"
  dbSelectArea("QD1")

  dbSeek( cSeek )
  Do While !Eof() .And. cSeek == &(cCompara)
      If !(QDH->QDH_DOCTO+QDH->QDH_RV == cOldDoc)
          cOldDoc:=QDH->QDH_DOCTO+QDH->QDH_RV
          Li:=80
      EndIf
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Caso parametrizado, quebra pagina por departamento destino   ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If !(QD1->QD1_DEPTO == cOldDepto)
          If !Empty(cOldDepto) .And. mv_par01 == 1
              Li:=80
          Else
              If Li > 54
                  Cabec060(@Li,cArqTexto,Tamanho,cTitulo,cCabec1)
              EndIf
              cOldDepto:=QD1->QD1_DEPTO
         EndIf
      EndIf
      IF Li > 58
          Cabec060(@Li,cArqTexto,Tamanho,cTitulo,cCabec1)
      EndIf
      If lEnd
          Li++
          @ PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
          Exit
      EndIf
      //@ Li,00 PSay "Departamento: "+QD1->QD1_DEPTO+" - "+QA_NDEPT(QD1->QD1_DEPTO,.T.,QD1->QD1_FILMAT)
      //Li++
      cSeek2:=QD1_FILiAL+QD1_DOCTO+QD1_RV+QD1_DEPTO
      cCompara2:="QD1_FILiAL+QD1_DOCTO+QD1_RV+QD1_DEPTO"
      dbSeek(cSeek2)
      //@ Li,00 PSay cCabec1
      //Li++
      //@ Li,00 PSay RepLicate("-",80)
      //Li++
      aRegQDG := {}
      Do While !Eof() .And. cSeek2 == &(cCompara2)
          If lBat
              IncRegua()
          EndIf
          IF Li > 58
              Cabec060(@Li,cArqTexto,Tamanho,cTitulo,cCabec1)
              //@ Li,00 PSay "Departamento: "+QD1->QD1_DEPTO+" - "+QA_NDEPT(QD1->QD1_DEPTO,.T.,QD1->QD1_FILMAT) 
              //Li++
              @ Li,00 PSay cCabec1
              Li++
              @ Li,00 PSay RepLicate("-",80)
              Li++
          EndIf
          If lEnd
              Li++
              @ PROW()+1,001 PSAY "CANCELADO PELO OPERADOR" 
              Exit
          EndIf
          
          // @ Li,00 PSay Left(QA_NUSR(QD1->QD1_FILMAT,QD1->QD1_MAT,.T.),28)

          dbSelectArea("QDG")
          DbSetOrder( 3 )
          If dbSeek( xFiLial() + QD1->QD1_DOCTO + QD1->QD1_RV + QD1->QD1_FILMAT + QD1->QD1_DEPTO + QD1->QD1_MAT )
              While !eof() .and. QDG->QDG_DOCTO + QDG->QDG_RV + QDG->QDG_FILMAT + QDG->QDG_DEPTO + QDG->QDG_MAT == QD1->QD1_DOCTO + QD1->QD1_RV + QD1->QD1_FILMAT + QD1->QD1_DEPTO + QD1->QD1_MAT
                  If aScan(aRegQDG,{ |X| X == QDG->(Recno()) }) == 0
                      aAdd(aRegQDG,QDG->(Recno()))
                      Exit
                  Endif

                  DbSkip()
              Enddo

              // @ Li,29 PSay IF(QDG_TIPO=="D","Usuario","Pasta")

              //@ Li,37 PSay StrZero(QDG->QDG_NCOP,4)
                            
              cDescPas := RetCpo("QDC", 1, QDG_CODMAN, "QDC_DESC")
              
              	if cDescPas=="!ERRO!"
		          	dbSelectArea("QD1")
      		   	dbSkip()
					   Loop
					endif
               
              // Provoca a quebra de linha no primeiro espaco em branco que encontrar 
              // a partir da metade da string           
              lFlag := .t.
              nQuebra := 26
              while lFlag
              		if substr(cDescPas,nQuebra,1)<>" "
              			nQuebra--
              			if nQuebra <= 0
              				nQuebra := 26
								lFlag := .f.
							endif              			            	
              		else
              			lFlag := .f.
              		endif
              enddo
              
              @ Li, 00 PSay "* " + substr(cDescPas,1,nQuebra - 1)
              Li++
              @ Li, 00 PSay "  " + alltrim(substr(cDescPas,nQuebra,50-nQuebra))
              
              

          EndIf

//          @ Li,41 PSay aTxtCopia[Val(QD1->QD1_TPDIST)]
          @ Li,34 PSay "___/___/___"
          @ Li,46 PSay RepLicate("_",10)
          @ Li,58 PSay "___/___/___"
          @ Li,70 PSay RepLicate("_",10)

          Li++
          dbSelectArea("QD1")
          dbSkip()
      EndDo
      Li++
  EndDo
  If lBat
      Exit
  EndIf
  dbSelectArea("QDH")
  dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve as ordens originais dos arquivos                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("QDH")
Set Filter to

RetIndex("QD1")
Set Filter to


dbSelectArea("QDG")
DbSetOrder( 1 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga indices de trabalho                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndex1 += OrdBagExt()
Delete File &(cIndex1)

cIndex2 += OrdBagExt()
Delete File &(cIndex2)

Set Device To Screen

If aReturn[5] == 1
  Set Printer TO
  dbCommitAll()
  ourspool(wnrel)
Endif
MS_FLUSH()

Return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Cabec060  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 16/07/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime dados pertinentes ao cabecalho do programa.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QDOR060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Cabec060(Li,cArqTexto,tamanho,cTitulo,cCabec1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utiLizadas na impressao do texto de convocacao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cTexto:="",cImpTxt:="",cImpLinha:=""
Local aLinha:={}
Local nc:=0,nCount:=0
Local cAcentos  := "€ú‡úŽúú…ú†úƒú úúˆú‚ú¡ú“ú”ú¢ú™ú£ú"
Local cAcSubst  := "C,c,A~A'a`a~a^a'E'e^e'i'o^o~o'O~U'"

If aReturn[4] == 1  // Comprimido
  @ 0,0 PSAY &(aDriver[1])
Else                    // Normal
  @ 0,0 PSAY &(aDriver[2])
Endif

Li:=0
@ Li,00 PSay cTitulo
Li++
Li++
@ Li,00 PSay "Documento: "+QDH->QDH_DOCTO+"/"+QDH->QDH_RV   
Li++
@ Li,00 PSay "Titulo :"+Substr(Alltrim(QDH->QDH_TITULO),1,70)      
If !Empty(Substr(Alltrim(QDH->QDH_TITULO),71))
  Li++
  @ Li,09 PSay Substr(Alltrim(QDH->QDH_TITULO),71)
EndIf
Li+=2
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime texto padrao do protocolo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cArqTexto) .And. cArqTexto != NIL .And. File(cArqTexto)
  cTexto:=MemoRead(cArqTexto)
  For nC := 1 To MLCOUNT(cTexto,80)
      aLinha := MEMOLiNE(cTexto,80,nC)
      cImpTxt   := ""
      cImpLinha := ""
      For nCount := 1 To Len(aLinha)
          cImpTxt := Substr(aLinha,nCount,1)
          If AT(cImpTxt,cAcentos)>0
              cImpTxt:=Substr(cAcSubst,AT(cImpTxt,cAcentos),1)
          EndIf
          cImpLinha := cImpLinha+cImpTxt
      Next nCount
      @Li,00 PSAY cImpLinha
      Li++
  Next nC
EndIf
Li+=2

@ Li,00 PSay cCabec1
Li++
@ Li,00 PSay RepLicate("-",80)
Li++

Return

Static Function RetCpo(cAlias, nIndice, cChave, cCampo)

cAliasAnt := Alias()
nIndiceAnt := IndexOrd()

dbSelectArea(cAlias)
dbSetOrder(nIndice)

dbSeek(xFilial(cAlias)+cChave)

if !Eof()
	cRet := &cCampo.
else
	cRet := "!ERRO!"
endif

dbSelectArea(cAliasAnt)
dbSetOrder(nIndiceAnt)

Return(cRet)
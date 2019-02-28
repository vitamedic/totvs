#INCLUDE "QIER200.CH"
//#INCLUDE "FIVEWIN.CH"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �       � Autor � Gardenia ILany        � Data � 04.05.04    ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Produtos - Uso									���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � QIER200()														    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

User Function VIT197(cProg,_lauto)

// ��������������������������������������Ŀ
// � Par�metros para a fun��o SetPrint () �
// ����������������������������������������
Local wnrel   := "VIT197"+Alltrim(cusername)
Local nlimite := 132
Local cString := "QEK"
Local cDesc1  := OemToAnsi(STR0001) //"Neste relat�rio ser�o relacionados os ensaios a serem realizados em ca-"
Local cDesc2  := OemToAnsi(STR0002) //"da laborat�rio, para a valida��o da Entrada."
Local cDesc3  := ""

if _lauto==nil
	_lauto:=.f.
endif

// �����������������������������������Ŀ
// � Par�metros para a fun��o Cabec    �
// �������������������������������������
Private cTitulo	   := GetMv("MV_QEFICHP")+STR0003	// " - USO"
Private cRelatorio := "VIT197"
Private cTamanho   := "M"
Private nPagina    := 1
Private nRecno     := QEK->(Recno())
Private nomeprog   := "VIT197"
Private nTipo      := 0
Private Cabec1     := ""
Private Cabec2     := ""
Private CbTxt
Private cbCont     := 0

li 	  := 80
m_pag := 1

//������������������������������������������������Ŀ
//� Vari�veis utilizadas pela fun��o SetDefault    �
//��������������������������������������������������
Private aReturn    := {STR0004, 1,STR0005,  1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nLastKey   := 0
Private cPerg      := "PERGVIT197"

//���������������������������������������������������������������Ŀ
//� Se for chamado pela importacao de Entradas, ja apresentou o   �
//� pergunte especifico. Deve somente imprimir o relatorio.       �
//� Se executar o relatorio todo, iria perguntar para cada entre- �
//� ga se quer impressao em video/impressora, etc.                �
//�����������������������������������������������������������������
//AjustaSX1()

//AjustaSXB()


If cProg == "QIER220"
	A200IFic(.F., "QIEA200")
Else
	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para parametros						 �
	//� mv_par01 = Fornecedor			?				 			 �
	//� mv_par02 = Loja Fornecedor		?    		 				 �
	//� mv_par03 = Produto				?			 				 �
	//� mv_par04 = Da Data de Entrada 	?			 				 �
	//� mv_par05 = Do Lote				?			 				 �
	//� mv_par06 = Do Laborat�rio 	    ?				     		 �
	//� mv_par07 = At� Laborat�rio      ?					 		 �
	//� mv_par08 = Considera Entrada    ? 1)-Normal		 	 		 �
	//�  							  	  2)-Beneficiamento 	 	 �
	//�  							  	  3)-Devolucoes     	 	 �
	//� mv_par09 = Considera Lote	    ? 1)-Sim	 		 	 	 �
	//� 							  	  2)-Nao 			 		 �
	//� mv_par10 = Skip-Teste           ? 1)- Todos    		 		 �
	//� 								  2)- A Inspecionar	 		 �
	//����������������������������������������������������������������
	if _lauto
		cperg:=""
		mv_par01:=sd1->d1_fornece    // DO FORNECEDOR
		mv_par02:=sd1->d1_loja       // DA LOJA
		mv_par03:=sd1->d1_fornece    // ATE O FORNECEDOR
		mv_par04:=sd1->d1_loja       // ATE A LOJA
		mv_par05:="               "  // DO PRODUTO
		mv_par06:="ZZZZZZZZZZZZZZZ"  // ATE O PRODUTO
		mv_par07:=sd1->d1_dtdigit    // DA DATA DE ENTREGA
		mv_par08:=sd1->d1_dtdigit    // ATE A DATA DE ENTREGA
		mv_par09:="                " // DO LOTE
		mv_par10:="      "           // DO LABORATORIO
		mv_par11:="ZZZZZZ"           // ATE O LABORATORIO
		mv_par12:=1                  // CONSIDERA ENTRADA (1=NORMAL, 2=BENEFICIAMENTO, 3=DEVOLUCAO)
		mv_par13:=1                  // CONSIDERA LOTE (1=SIM, 2=NAO)
		mv_par14:=1                  // IMPRIME SKIP-TESTE (1=TODOS, 2=A INSPECIONAR)
		mv_par15:=1                  // LINHAS PARA MEDICOES
	else
		Pergunte(cPerg,.F.)
	endif
	
	If cProg == "QIEA200"
		//��������������������������������������������������������������Ŀ
		//� Obs.: Na fun��o A200IFic � atualizado o mv_par com o valor   �
		//�  dos registros correntes.                					 �
		//����������������������������������������������������������������
		cPerg := ""
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Envia controle para a funcao SETPRINT 						 �
	//����������������������������������������������������������������
	wnrel := SetPrint(cString,wnrel,cPerg,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",,cTamanho,"",.F.)
	
	//�������������������������������������Ŀ
	//� Verifica se apertou o botao cancela �
	//���������������������������������������
	If nLastKey <> 27
		
		SetDefault(aReturn,cString)
		
		If nLastKey <> 27
			If cProg == "QIEA200"
				dbGoTo(nRecno)
			Endif
			RptStatus({|lEnd| A200Imp(@lEnd,wnRel,cString,cProg,_lauto)},cTitulo)
		EndIf
		
	Endif
EndIf
Return

/*
���Descri��o � Relacao de Ensaios										  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � A200Imp(lEnd,wnRel,cString)								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd		-	A��o do CodeBlock 							  ���
���			 � wnRel 	-	T�tulo do relat�rio							  ���
���			 � cString	-	Mensagem 									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A200Imp(lEnd,wnRel,cString,cProg,_lauto)

//�����������������������������������������������������������������Ŀ
//� Funcao que imprime a Ficha com os dados da Entrada posicionada. �
//� Esta rotina tambem � chamada do QIER210, que imprime as fichas  �
//� dos Produtos importados, que estejam marcados para inspecao.	�
//�������������������������������������������������������������������
A200IFic(lEnd,cProg,_lauto)

//���������������������������������Ŀ
//� Encerra a impressao desta ficha �
//�����������������������������������

Roda(CbCont,Cbtxt)

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

MS_FLUSH()
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Descri��o � Imprime a Ficha do Produto com os dados da Entrada posicio-���
���			 � nada. 													  ���
���Uso		 � A200Imp(QIER200.PRW) e A210Imp(QIER210.PRW)				  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function A200IFic(lEnd,cProg,_lauto)
Local cLaborat
Local cUnimed
Local cLaudo
Local cSkipLote
Local cDescLab
Local cChaveQEK1
Local cChaveQEK2
Local cChaveQEK3
Local cDescEns 	:= Space(30)
Local cObsEns 	   := Space(30)
local camins:= "  " 
Local aEntrada 	:= {}
Local aEnsaios 	:= {}
Local nRecQEK
Local nRecTRB
Local lImp		:= .T.
Local cFor
Local cLojFor
Local CGrupo
Local cSkTes    := "   "
Local lFirst
Local cTipoEns	:= ''
Local aLabEns   := {}
Local cUM       := ""
Local lSkpLot   := .F.


dbSelectArea("QEK")  
dbSetOrder(1)

If cProg=="VIT197"
	//����������������������������������������������������������������Ŀ
	//� Localiza a Entrada										       �
	//������������������������������������������������������������������
	If mv_par09 == 1
		dbSetOrder(6)
		lImp := dbSeek(xFilial("QEK")+mv_par05)
	Else
		lImp := dbSeek(xFilial("QEK")+mv_par01+mv_par02+mv_par03+Inverte(mv_par04)+;
		Inverte(mv_par05))
	EndIf		

Elseif ! _lauto
	cPerg := "PERGVIT197"
	Pergunte(cPerg,.F.)
//	mv_par01 := QEK->QEK_FORNEC
//	mv_par02 := QEK->QEK_LOJFOR
//	mv_par03 := QEK->QEK_PRODUT
//	mv_par04 := QEK->QEK_DTENTR
//	mv_par05 := QEK->QEK_LOTE
//	mv_par06 := Space(TamSX3("QEL_LABOR")[1])
//	mv_par07 := Repl("Z",TamSX3("QEL_LABOR")[1])
//	mv_par08 := If(Empty(QEK->QEK_TIPONF) .or. QEK->QEK_TIPONF == "N",1,;
//				If(QEK->QEK_TIPONF=="B",2,3))
//	mv_par09 := 2
Endif



qek->(dbGoTop())  
dbsetorder(1)
While qek->(!EOF())

Private aCampos :={}
Private cArqTrb
Private cProduto

if  qek->qek_fornec < mv_par01 .or. qek->qek_fornec > mv_par03
 	qek->(dbskip())
    loop
endif    
if  qek->qek_produt < mv_par05 .or. qek->qek_produt > mv_par06
 	qek->(dbskip())
    loop
endif    

if  qek->qek_dtentr < mv_par07 .or. qek->qek_dtentr > mv_par08
 	qek->(dbskip())
    loop
endif    



nRecQEK    := Recno()
cChaveQEK1 := QEK->QEK_PRODUT+Inverte(QEK->QEK_REVI)
cFor	     := QEK_FORNEC
cLojFor	  := QEK_LOJFOR

dbSelectArea("QE6")
dbSetOrder(1)
dbSeek(xFilial("QE6")+cChaveQEK1)
IF !Found() .Or. !lImp
	Set Device to Screen
	Help(" ",1,"QE_NAOPRRV",,QEK->QEK_PRODUT+" / "+QEK->QEK_REVI,2,1) // "Produto/Revisao nao cadastrados:
	dbSelectArea("QEK")
	dbSetOrder(1)
	Return
EndIf
cProduto := QE6->QE6_PRODUT+QE6->QE6_REVI
dbSelectArea("QE7")
dbSetOrder(1)
dbSeek(xFilial("QE7")+cProduto)
dbSelectArea("QE8")
dbSetOrder(1)
dbSeek(xFilial("QE8")+cProduto)

//��������������������������������������������������������������Ŀ
//� Cria Arquivo de Trabalho. 									 �
//����������������������������������������������������������������
aTam:=TamSX3("QEK_PRODUTO")
AADD(aCampos,{"PRODUTO",   "C",aTam[1],aTam[2]})
aTam:=TamSX3("QEK_REVI")
AADD(aCampos,{"REVI",   "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_ENSAIO")
AADD(aCampos,{"ENSAIO", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_METODO")
AADD(aCampos,{"METODO", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_TIPO")
AADD(aCampos,{"TIPO",   "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_UNIMED")
AADD(aCampos,{"UNIMED", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_NOMINA")
AADD(aCampos,{"NOMINA", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_LIE")
AADD(aCampos,{"LIE", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_LSE")
AADD(aCampos,{"LSE","C",aTam[1],aTam[2]})
aTam:=TamSX3("QF4_PLAMO")
AADD(aCampos,{"PLAMO",  "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_NIVEL")
AADD(aCampos,{"NIVEL", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_AM_INS")
AADD(aCampos,{"AM_INS", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_LABOR")
AADD(aCampos,{"LABOR",  "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_SEQLAB")
AADD(aCampos,{"SEQLAB", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_MINMAX")
AADD(aCampos,{"MINMAX", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE8_TEXTO")
AADD(aCampos,{"TEXTO",  "C",aTam[1],aTam[2]})
aTam:=TamSX3("QEK_VERIFI")
AADD(aCampos,{"Ok","C",aTam[1],aTam[2]})

cArqTrb := CriaTrab(aCampos)
dbUseArea( .T.,, cArqTrb, "TRB", .F., .F. )
dbSelectArea("QE7")

//��������������������������������������������������������������Ŀ
//� Chamada da Funcao para gerar arquivo de Trabalho			 �
//����������������������������������������������������������������
GeraTrab()

//����������������������������������������������������������������Ŀ
//� Identifica o Grupo do Produto								   �
//������������������������������������������������������������������
QEA->(dbSetOrder(2))
QEA->(dbSeek(xFilial("QEA")+QEK->QEK_PRODUT))
cGrupo := QEA->QEA_GRUPO
QEA->(dbSetOrder(1))

dbSelectArea("TRB")
If BOF() .and. EOF()
	HELP(" ",1,"RECNO")
	dbCloseArea()
	
	Ferase(cArqTrb+GetDBExtension())
	Ferase(cArqTrb+OrdBagExt())
	dbSetOrder( 1 )
	Return .T.
Else
	IndRegua("TRB",cArqTrb,"LABOR+SEQLAB",,,STR0006)      //"Selecionando Registros..."
	dbSetIndex(cArqTrb+OrdBagExt())	
Endif
TRB->(dbGoTop())

SetRegua(RecCount())

While TRB->(!EOF())
	IncRegua()
	
	//��������������������������������������������������������������Ŀ
	//� Flag Verifica se j� foi impresso o laboratorio 				 �
	//����������������������������������������������������������������
	If TRB->OK == "S"
		dbSelectArea("TRB")
		dbSkip()
		Loop
	EndIf

	If	!Empty(mv_par10) .And. TRB->LABOR < mv_par10 .or.;
		!Empty(mv_par11) .And. TRB->LABOR > mv_par11
		dbSelectArea("TRB")
		dbSkip()
		Loop                   
	EndIf	
	
	If TRB->LABOR != cLaborat
		cLaborat := TRB->LABOR
	EndIf
	
	//���������������������������������������������������������������Ŀ
	//� Descricao do Laboratorio									  �
	//�����������������������������������������������������������������
	If !Empty(TRB->LABOR)
		cDescLab := Tabela("Q2",TRB->LABOR)
	EndIf
	
	//������������������������������������������������������Ŀ
	//� ARMAZENA NO ARRAY AS ULTIMAS ENTRADAS 				 �
	//��������������������������������������������������������
	dbSelectArea("QEK")
	dbSetOrder(2) 
	dbGoto(nRecQEK)
	nCont   := 0
	lSkpLot := .F.
	While QEK_FILIAL+QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUTO == ;
		xFilial("QEK")+cFor+cLojFor+Substr(cProduto,1,15) .and. nCont < 4     
		
		cSkipLote := Iif (QEK_VERIFI <> 2 , STR0019, STR0020) //"NAO"###"SIM"
		cChaveQEL := QEK_FORNEC+QEK_LOJFOR+QEK_PRODUTO+DTOS(QEK_DTENTR)+QEK_LOTE+;
		Space(TamSX3("QEL_LABOR")[1])
		
		dbSelectArea("QEL")
		QEL->(dbSetOrder(1))
		If dbSeek(xFilial("QEL")+cChaveQEL)
			QED->(dbSetOrder(1))
			QED->(dbSeek(xFilial("QED")+QEL->QEL_LAUDO))
			cLaudo := QED->QED_DESCPO
		Else
			cLaudo := Space(TamSX3("QED_DESCPO")[1])
		EndIf
		
		dbSelectArea("QEK")
		AADD(aEntrada,{QEK_DTENTR,SUBSTR(QEK_LOTE,1,10),Upper(cSkipLote),cLaudo,QEK_DOCENT})
		nCont++

		//���������������������������������������������������������������Ŀ
		//� Verifica se a Entrada atual esta em regime de Skip-Lote		  �
		//�����������������������������������������������������������������
		If nCont == 1
			If QEK->QEK_VERIFI == 2
				lSkpLot := .T.
			EndIf
		EndIf
		
		dbSkip()
	Enddo
	dbSelectArea("QEK")
	dbGoTo(nRecQEK)

	//��������������������������������������������Ŀ
	//�Dados dos ensaios 						   �
	//����������������������������������������������
	aEnsaios := {}
	aLabEns  := {}
	dbSelectArea("TRB")
	nRecTRB := Recno()
	While !EOF() .and. cLaborat == TRB->LABOR
		//��������������������������������������������������������������Ŀ
		//�Verifica o skip-teste										 �
		//����������������������������������������������������������������
		cSkTes := "   "
		// Verifica se tem skip-teste definido
		QEH->(dbSetOrder(1))
		If QEH->(dbSeek(xFilial("QEH")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
			QEK->QEK_PRODUT+TRB->ENSAIO))
			cSkTes := "CER"
			// Verifica o historico skip-teste individual
			QEY->(dbSetOrder(1))
			If QEY->(dbSeek(xFilial("QEY")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
				QEK->QEK_PRODUT+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+TRB->ENSAIO))
				cSkTes := "INS"
			EndIf
		Else
			cSkTes := "N/A"   // indica que nao foi definido
		EndIf			
		If Empty(cSkTes) .Or. cSkTes == "N/A"
			// Verifica o historico skip-teste por grupo
			QEZ->(dbSetOrder(1))
			If QEZ->(dbSeek(xFilial("QEZ")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
				cGrupo+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+TRB->ENSAIO))
				cSkTes := "INS"
			Else
				// Verifica se tem skip-teste definido
				QEI->(dbSetOrder(1))
				If QEI->(dbSeek(xFilial("QEI")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
						cGrupo+TRB->ENSAIO))
					cSkTes := "CER"
				Else
					cSkTes := "N/A" //indica que nao foi definido
				EndIf
			EndIf
		EndIf      

		//��������������������������������������������������������������Ŀ
		//� Verifica se os Ensaios a Inspecionar serao impressos na Fi-  �
		//� do Produto conforme selecao do parametro.				     �
		//����������������������������������������������������������������
		If mv_par14 == 2
			//��������������������������������������������������������������Ŀ
			//� Quando a Entrada atual estiver em regime de Skip-Lote, somen-�
			//� te serao impressos os ensaios em Skip-Teste.				 � 
			//����������������������������������������������������������������
			If lSkpLot 
				If cSkTes # "INS" 
					RecLock("TRB",.F.)
					TRB->OK	 := "S"
					MsUnLock()
					TRB->(dbSkip())
					Loop
				EndIf	
			Else	
				If (cSkTes # "N/A") .And. (cSkTes # "INS") 
					RecLock("TRB",.F.)
					TRB->OK	 := "S"
					MsUnLock()
					TRB->(dbSkip())
					Loop
				EndIf	
			EndIf
		EndIf
		
		RecLock("TRB",.F.)
		TRB->OK	 := "S"
		MsUnLock()
		dbSelectArea("QE1")
		dbSetOrder(1)

//		dbSelectArea("QE7")
//		dbSetOrder(3)
//		dbSeek(xFilial("QE7")+TRB->ENSAIO+TRB->PRODUTO+TRB->REVI)

		dbSelectArea("QE1")
		dbSetOrder(1)

		IF dbSeek(xFilial("QE1")+TRB->ENSAIO)
			_tamobs:=len(alltrim(Substr(QE1_DESCPO,1,30)))
			_tamobs:=30-_tamobs
			_tamobs:=25+_tamobs
			_descpo:= Substr(QE1_DESCPO,1,40)
			cTipoEns := QE1_CARTA
			dbSelectArea("QE7")
			dbSetOrder(3)
			dbSeek(xFilial("QE7")+TRB->ENSAIO+TRB->PRODUTO+TRB->REVI)
			cObsEns := Substr(QE7_OBS,1,_tamobs)
			if !empty(cObsEns)
				_descpo:=substr(_descpo,1,30)
			endif				
			if !empty(cObsEns)
				cDescEns :=alltrim(_descpo)+" "+cObsEns
			else	
				cDescEns :=alltrim(_descpo)
			endif	
		Endif
		
		dbSelectArea("TRB")
		AADD(aEnsaios,{ENSAIO,cTipoEns})

		If cTipoEns <> "TXT"
			SAH->(dbSetOrder(1))
			If SAH->(dbSeek(xFilial("SAH")+TRB->UNIMED))
				cUM := SAH->AH_UMRES
			Else
				cUM := " "
			EndIf
		EndIf       

		DO CASE
			CASE ( AM_INS == "1" )
				cAmIns := "AMO"
				
			CASE ( AM_INS == "2" )
				cAmIns := "INS"
				
			CASE ( AM_INS == "3" )
				cAmIns := "A/I"
		ENDCASE
		
		Aadd(aLabEns,{ENSAIO+" "+cDescEns,METODO,TIPO,cTipoEns,cUM,NOMINA,;
			MINMAX,LIE,LSE,	Left(TEXTO,34),Subs(TEXTO,35,34),Subs(TEXTO,69),;
			PLAMO,NIVEL,cAmIns,	cSkTes})
		
		dbSelectArea("TRB")
		dbSkip()
		
	Enddo
	dbGoTo(nRecTRB)                             
	
	If Len(aLabEns) == 0
		TRB->(dbSkip())
		Loop
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Verifica se � nova pagina 									 �
	//����������������������������������������������������������������
	If Li > 58
		Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
	Endif

	IF ( lEnd )
		@Prow()+1,001 PSAY OemToAnsi(STR0007)	//"CANCELADO PELO OPERADOR"
		Return
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� DADOS DO PRODUTO 										     �
	//����������������������������������������������������������������
	@ Li, 001 PSAY AllTrim(TitSX3("QE6_PRODUT")[1])+" - "+AllTrim(TitSX3("QE6_REVI")[1])+Replicate(".",38-(len(Alltrim(TitSx3("QE6_PRODUT")[1]))+len(Alltrim(TitSx3("QE6_REVI")[1]))))+":"
	@ Li, 044 PSAY QE6->QE6_PRODUT + " - " + QE6->QE6_REVI
	Li++
	@ Li, 001 PSAY AllTrim(TitSX3("QE6_DESCPO")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QE6_DESCPO")[1])))+":"
	@ Li, 044 PSAY QE6->QE6_DESCPO
	Li++
	@ Li, 001 PSAY AllTrim(TitSX3("QE6_APLIC")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QE6_APLIC")[1])))+":"
	@ Li, 044 PSAY QE6->QE6_APLIC
	Li++
	@ Li, 001 PSAY AllTrim(TitSX3("QE6_CROQUI")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QE6_CROQUI")[1])))+":"
	@ Li, 044 PSAY QE6->QE6_CROQUI
	Li++
	@ Li, 001 PSAY AllTrim(TitSX3("QE6_DTCAD")[1])+"/"+AllTrim(TitSX3("QE6_DTDES")[1])+"/"+AllTrim(TitSX3("QE6_RVDES")[1])+"...:"
	@ Li, 044 PSAY QE6->QE6_DTCAD
	@ Li, 057 PSAY QE6->QE6_DTDES
	@ Li, 070 PSAY QE6->QE6_RVDES
	Li++
	
	@ Li, 001 PSAY AllTrim(TitSX3("QE6_DTINI")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QE6_DTINI")[1])))+":"
	@ Li, 044 PSAY QE6->QE6_DTINI
	If !Empty(QE6->QE6_DOCOBR)
		Li++
		@ Li, 001 PSAY AllTrim(TitSX3("QE6_DOCOBR")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QE6_DOCOBR")[1])))+":"
		@ Li, 044 PSAY Iif(QE6->QE6_DOCOBR=="S",OemToAnsi(STR0008),;   // "Sim"
		OemToAnsi(STR0009))	// "Nao"
		If QE6->QE6_DOCOBR == "S"
			@ Li, 074 PSAY "D"
		Endif
	EndIf
	Li++
	@ li,001 PSAY "Categoria................................:"+qe6->qe6_categ
	if QE6->QE6_TIPO=="MP" 

		Li++
		@ li,001 PSAY "Formula quimica molecular................:"+qe6->qe6_formol
		Li++
		@ li,001 PSAY "Peso molecular...........................:"+transform(qe6->qe6_pesmol,"@E 999,999,999.99")
		Li++                                                     
		sb1->(dbseek(xfilial("SB1")+qe6->qe6_produt))
	   @ li,001 PSAY "DCB(DCI).................................:"+sb1->b1_dcb1
	   endif
	Li+= 2
	
	
	//Descricao do Laboratorio 
	@ Li, 001 PSAY STR0010 + TRB->LABOR + " - " + cDescLab      //"LABORATORIO ==> "
	Li+= 2
	
	//=====================================================================================================================================
	//Ensaio 											Metodo		 Familia Instrum. Un.Med	 Nominal 	L.I.E.	L.S.E. Pl Caracterist.	 A/I ST
	//=====================================================================================================================================
	//XXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXXXXXX XXXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX X  XXXXXXXXXXXXXX XXX XXX
	// 			1			 2 		  3			4			 5 		  6			7			 8 		  9			10 		 11		  12			13
	//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	
	@ Li, 000 PSAY Replicate("=",132)
	Li++
	@ Li, 000 PSAY TitSX3("QE7_ENSAIO")[1]
//	@ Li, 040 PSAY TitSX3("QE7_METODO")[1]
//	@ Li, 053 PSAY TitSX3("QE7_TIPO")[1]
	@ Li, 070 PSAY STR0011		//"Un. Med."
	@ Li, 080 PSAY STR0012		//"Nominal"
	@ Li, 091 PSAY STR0013		//"L.I.E."
	@ Li, 102 PSAY STR0014		//"L.S.E."
	@ Li, 109 PSAY STR0015		//"Pl "
	@ Li, 112 PSAY TitSX3("QE7_NIVEL")[1]
	@ Li, 127 PSAY STR0016		//"A/I"
	@ Li, 131 PSAY STR0017		//"ST"
	Li++
	@ Li, 000 PSAY Replicate("=",132)
	    
	//��������������������������������������������������������������Ŀ
	//� Imprime os Ensaios associados ao Laboratorio				 �
	//����������������������������������������������������������������
	For nX := 1 to Len(aLabEns)
		Li++                               
		@ Li, 000 PSAY aLabEns[nX,1]
//		@ Li, 040 PSAY aLabEns[nX,2]
//		@ Li, 053 PSAY aLabEns[nX,3]
		
		If aLabEns[nX,4] <> "TXT"
			@ Li, 070 PSAY aLabEns[nX,5]
			@ Li, 080 PSAY aLabEns[nX,6]
			
			If aLabEns[nX,7] == "1"
				@ Li, 089 PSAY aLabEns[nX,8]
				@ Li, 098 PSAY aLabEns[nX,9]
			ElseIf aLabEns[nX,7] == "2"
				@ Li, 089 PSAY aLabEns[nX,8]
				@ Li, 103 PSAY ">>>"
			ElseIf aLabEns[nX,7] == "3"
				@ Li, 094 PSAY "<<<"
				@ Li, 098 PSAY aLabEns[nX,9]
			EndIf                           
		Else 
			@ Li, 70 PSAY aLabEns[nX,10]
		EndIf			

		@ Li, 107 PSAY aLabEns[nX,13]

		If !Empty(NIVEL)
			@ Li, 110 PSAY Substr(TABELA("Q6",aLabEns[nX,14]),1,10)
		Endif
		@ Li, 125 PSAY aLabEns[nX,15]
		@ Li, 129 PSAY aLabEns[nX,16]

		//��������������������������������������������������������������Ŀ
		//�Imprime restante do aTexto 									 �
		//����������������������������������������������������������������
		If aLabEns[nX,4] == "TXT"
			If !Empty (aLabEns[nX,11])
				Li++
				@ Li, 70 PSAY aLabEns[nX,11]
			Endif
			If !Empty (aLabEns[nX,12])
				Li++
				@ Li, 70 PSAY aLabEns[nX,12]
			Endif
		Endif
		Li++
		@ Li, 000 PSAY Replicate("-",132)
		If Li > 58
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
		Endif

	Next nX
	
	//������������������������������������������������������Ŀ
	//� IMPRIME MENSAGEM DE NOVAS ESPECIFICACOES 	         �
	//��������������������������������������������������������
	If QEK->QEK_ALTESP
		Li+=2
		@ Li, 01 PSAY "��������������������������������������������>>   "+;
		Upper(STR0018)+"   <<��������������������������������������������" // "Entrada com novas Especificacoes"
		Li++
	EndIf
	
	//������������������������������������������������������Ŀ
	//� CABE�ALHO DAS ULTIMAS ENTRADAS						 �
	//��������������������������������������������������������
	// Ultimas Entradas:  Data Entrada	Lote				  Skip-Lote   Laudo									 Doc-Entrada
	// 			1			 2 		  3			4			 5 			6			7			 8 		  9			100
	//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	li+=2
	
	//������������������������������������������������������Ŀ
	//�Imprime o Cabe�alho das ultimas Entradas				 �
	//��������������������������������������������������������
	@ Li, 01 PSAY STR0021		//"Ultimas Entradas:"
	@ Li, 20 PSAY STR0022		//"Data Entrada"
	@ Li, 34 PSAY STR0023		//"Lote"
	@ Li, 51 PSAY STR0024		//"Skip-Lote"
	@ Li, 63 PSAY STR0025		//"Laudo"
	@ Li, 95 PSAY STR0026		//"Doc.Entrada"
	Li++
	
	For nC:= 1 to Len(aEntrada)
		@ Li,20 PSAY aEntrada[nC,1]
		@ Li,34 PSAY aEntrada[nC,2]
		@ Li,51 PSAY aEntrada[nC,3]
		@ Li,63 PSAY aEntrada[nC,4]
		@ Li,95 PSAY aEntrada[nC,5]
		Li++
	Next nC
	aEntrada:={}
	Li++
	
	//��������������������������������������������������������������Ŀ
	//�Posiciona em registros de outros Arquivos p/dados Fornecedor  �
	//����������������������������������������������������������������
	dbSelectArea("SA5")
	dbSetOrder(2)
	dbSeek(xFilial("SA5")+QEK->QEK_PRODUTO+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)
	dbSelectArea("QEG")
	dbSetOrder(1)
	dbSeek(xFilial("QEG")+SA5->A5_SITU)
	
	If Li > 58  
		Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
	Endif
	
	//��������������������������������������Ŀ
	//�Dados do Fornecedor/Cliente           �
	//����������������������������������������
	If !(mv_par12 = 2 .or. mv_par12 = 3)	
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)

		@ Li, 01 PSAY AllTrim(TitSX3("QEK_FORNEC")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_FORNEC")[1])))+":"
		@ Li, 27 PSAY QEK->QEK_FORNEC+"/"+QEK->QEK_LOJFOR+" - "+SA2->A2_NREDUZ+;
		"   ("+QEG->QEG_NIVEL +")"     
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)

		@ Li, 01 PSAY AllTrim(TitSX3("A7_CLIENTE")[1])+Replicate(".",23-Len(AllTrim(TitSX3("A7_CLIENTE")[1])))+":"
		@ Li, 27 PSAY QEK->QEK_FORNEC+"/"+QEK->QEK_LOJFOR+" - "+SA1->A1_NREDUZ+;
		"   ("+QEG->QEG_NIVEL +")"
	EndIf
	
	Li++
	@ Li, 01 PSAY AllTrim(TitSX3("A5_CODPRF")[1])+Replicate(".",23-Len(AllTrim(TitSX3("A5_CODPRF")[1])))+":"
	@ Li, 27 PSAY SA5->A5_CODPRF
	Li++
	@ Li, 01 PSAY AllTrim(TitSX3("QEK_LOTE")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_LOTE")[1])))+":"
	@ Li, 27 PSAY SUBSTR(QEK->QEK_LOTE,1,10)
	@ Li, 62 PSAY AllTrim(TitSX3("QEK_NTFISC")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEK_NTFISC")[1])))+":"
	@ Li, 85 PSAY QEK->QEK_NTFISC
	Li++
	@ Li, 001 PSAY AllTrim(TitSX3("QEK_TAMLOT")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_TAMLOT")[1])))+":"
	
	SAH->(dbSetOrder(1))
	SAH->(dbSeek(xFilial("SAH")+QEK->QEK_UNIMED))
	@ Li, 27 PSAY QEK->QEK_TAMLOT + "  " + SAH->AH_UMRES
	@ Li, 62 PSAY AllTrim(TitSX3("QEK_DTNFIS")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEK_DTNFIS")[1])))+":"
	@ Li, 85 PSAY QEK->QEK_DTNFIS
	Li++
	@ Li, 01 PSAY AllTrim(TitSX3("QEK_DTENTR")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_DTENTR")[1])))+":"
	@ Li, 27 PSAY QEK->QEK_DTENTR
	@ Li, 62 PSAY AllTrim(TitSX3("QEK_PEDIDO")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEK_PEDIDO")[1])))+":"
	@ Li, 85 PSAY QEK->QEK_PEDIDO
	Li++
	@ Li, 01 PSAY AllTrim(TitSX3("QEK_DOCENT")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QEK_DOCENT")[1])))+":"
	@ Li, 27 PSAY QEK->QEK_DOCENT
	@ Li, 62 PSAY AllTrim(TitSX3("QEK_CERFOR")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEK_CERFOR")[1])))+":"
	@ Li, 85 PSAY QEK->QEK_CERFOR
	Li++
	cUniMed:= Iif ( QEK->QEK_UNIMED == QE6->QE6_UNMED1 ,;
	QE6->QE6_UNAMO1 , ;
	Iif (QEK->QEK_UNIMED == QE6->QE6_UNMED2, QE6->QE6_UNAMO2, Space(6) ))
	
	@ Li, 01 PSAY STR0027		//"Lote Amostragem........: "
	If !Empty(cUniMed)
		SAH->(dbSetOrder(1))
		SAH->(dbSeek(xFilial("SAH")+cUniMed))
		cUniMed := SAH->AH_UMRES
	EndIf
	@ Li, 27 PSAY QEK->QEK_TAMAMO + "  " + AllTrim(cUnimed)
	
	dbSelectArea("SD1")
	dbSetOrder(1) 
	//     D1_FILIAL+     D1_DOC+                 D1_SERIE+       D1_FORNECE+     D1_LOJA+        D1_COD+         D1_ITEM
	dbSeek(xFilial("SD1")+left(QEK->QEK_NTFISC,6)+QEK->QEK_SERINF+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+QEK->QEK_ITEMNF)
   Li++  
	@ Li, 01 PSAY "Lote Fornecedor........: " + SD1->D1_LOTEFOR
   @ li, 62 PSAY "Fabricante.............: " + sd1->d1_fabric
   Li++  
	@ Li, 01 PSAY "Num.Volumes............: " + ALLTRIM(STR(SD1->D1_NUMVOL))
	@ li ,62 PSAY "Lote Fabricante........: " + sd1->d1_lotfabr
   Li++  
	@ Li, 01 PSAY "Validade do Lote.......: " + DTOC(SD1->D1_DTVALID)
	@ li, 62 PSAY "Data Fabricacao........: " + DTOC(SD1->D1_DTFABR)
	
	        
	lFirst := .T.
	QF5->(dbSetOrder(1))
	QF5->(dbSeek(xFilial("QF5")+QEK->QEK_CHAVE))
	If QF5->(!Eof())
		While QF5->(!Eof()) .And. QEK->QEK_CHAVE == QF5->QF5_CHAVE 
		            
			If Ascan(aEnsaios,{|x|x[1]==QF5->QF5_ENSAIO}) >  0

				If QF5->QF5_TAMA1 > 0            
					If lFirst
						Li++  
						@ Li, 01 PSAY STR0028 //"Ensaio"      
						@ Li, 13 PSAY STR0029 //"Plano"    
						@ Li, 21 PSAY STR0030 //"Amostragem"    
						@ Li, 35 PSAY STR0031 //"UM"    
						@ Li, 41 PSAY STR0032 //"Aceite"   
						@ Li, 50 PSAY STR0033 //"Rejeite"
						Li++
						lFirst := .F.
					EndIf	
					Li++  
					@ Li, 01 PSAY QF5->QF5_ENSAIO
					@ Li, 13 PSAy QF5->QF5_PLAMO
					@ Li, 21 PSAY QF5->QF5_TAMA1  Picture "@E 9999"
					@ Li, 35 PSAY AllTrim(cUnimed)
					@ Li, 41 PSAY QF5->QF5_ACEI1  Picture "@E 99"
					@ Li, 50 PSAY QF5->QF5_REJEI1 Picture "@E 99"
				Endif
			EndIf
			QF5->(dbSkip())
		EndDo
	EndIf	
   		
	
	Li++
//	@ Li, 01 PSAY AllTrim(TitSX3("QER_RASTRE")[1])+Replicate(".",23-Len(AllTrim(TitSX3("QER_RASTRE")[1])))+":"
//	@ Li, 27 PSAY "__________________"
//	@ Li, 62 PSAY AllTrim(TitSX3("QEL_DTENLA")[1])+Replicate(".",19-Len(AllTrim(TitSX3("QEL_DTENLA")[1])))+":"
//	@ Li, 85 PSAY "__________________"

	@ Li, 01 PSAY "N� de analise..........:___________________"
	@ Li, 62 PSAY "Dt. Entrada Labor......:___________________"

	If Li > 58    
		Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
	Endif
	

	if QE6->QE6_TIPO=="MP"
		Li++
		Li++
		@ Li, 01 PSAY "Quantidade amostrada para referencia futura...................:" + QE6->QE6_QTDE1
		Li++
		@ Li, 01 PSAY "Quantidade amostrada para analise total.......................:" + QE6->QE6_QTDE2
		Li++                                                                                           
		@ Li, 01 PSAY "Quantidade amostrada por barrica para teste de identificacao..:" + QE6->QE6_QTDE3
		Li++
		@ Li, 01 PSAY "Quantidade amostrada para controle de qualidade microbiologico:" + QE6->QE6_QTDE4
	elseif  QE6->QE6_TIPO=="EE"  .or. QE6->QE6_TIPO=="EN"
		Li++
		Li++
		@ Li, 01 PSAY "Quantidade amostrada de material de embalagem conforme procedimento PR_CPR_002"    
	endif
	
	
	Li+= 2
	@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
	Li++
	@ Li, 01 PSAY "|                |Instrumento |     Ensaiador                              M E D I C O E S                         Data/Hr Ensaio |"
	Li++
	@ Li, 01 PSAY "|----------------+------------+-------------------+---------------+---------------+---------------+---------------+---------------|"
	Li++
	
	For nCont := 1 to Len(aEnsaios)
		If aEnsaios[nCont,2] <> "TXT"
			@ Li, 01 PSAY "| " + aEnsaios[nCont,1] + "       |            |                   |               |               |               |               |               |"
			Li++
			@ Li, 01 PSAY "|----------------+------------+-------------------+---------------+---------------+---------------+---------------+---------------|"
			Li++
		Else
			@ Li, 01 PSAY "| " + aEnsaios[nCont,1] + "       |            |                   |                                                               |               |"
			Li++
			@ Li, 01 PSAY "|-----------------------------------------------------------------------------------------------------------------+---------------|"
			Li++
		Endif
		If Li > 58 .And. Len(aEnsaios) > nCont
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
			@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
			Li++
			@ Li, 01 PSAY "|                |Instrumento |     Ensaiador                              M E D I C O E S                         Data/Hr Ensaio |"
			Li++
			@ Li, 01 PSAY "|----------------+------------+-------------------+---------------+---------------+---------------+---------------+---------------|"
			Li++
		Endif
	Next
	
	If Li > 58
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
   endif

	Li++
	Li++
	Li++
	@ Li, 01 PSAY "Material amostrado por_____________ ___/___/___         N� da Requisi��o de materiais:__________________"
	Li++
	Li++
	Li++
	@ Li, 01 PSAY "Laudo:_______________________"
	Li++
	Li++
	If Li > 58
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
   endif
	@ Li, 01 PSAY "[ ] APROVADO       [ ] APROVADO COM RESTRI��O         [ ] REPROVADO"
	Li++
	Li++
	Li++
	@ Li, 01 PSAY "________________________    _____/_____/_____"
	Li++
	@ Li, 01 PSAY "Respons�vel pelo C.Q."
	Li++
	Li++
	@ Li, 01 PSAY "Data libera��o               _____/_____/_____"
	Li++
	Li++
	@ Li, 01 PSAY "________________________ "   
	Li++
	@ Li, 01 PSAY "Visto "


	//��������������������������������������������������������������Ŀ
	//� Converte a chave passada como param. p/ chave do texto		 �
	//����������������������������������������������������������������
	cChave := QE6->QE6_CHAVE
	cEspeci:="QIEA010 "
	dbSelectArea("QA2")
	QA2->(dbSetOrder(1))
	dbSeek(xFilial("QA2")+cEspeci+cChave)
	Do While !EOF() .and. QA2->QA2_FILIAL+QA2->QA2_ESPEC+QA2->QA2_CHAVE ==;
		xFilial("QA2")+cEspeci+cChave
		Li++
		If Li > 58
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
		Endif
//		@ Li, 01 PSAY QA2_TEXTO
		dbSkip()
	Enddo
	
	dbSelectArea("TRB")
	dbSkip()
	Li:=80
EndDo

//���������������������������������������������������������������������Ŀ
//� Verifica se a Entrada foi importada e marca que j� imprimiu a Ficha �
//�����������������������������������������������������������������������
dbSelectArea("QEP")
QEP->(dbSetOrder(1))
If dbSeek(xFilial("QEP")+"1"+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+;
	DtoS(QEK->QEK_DTENTR)+QEK->QEK_LOTE)
	RecLock("QEP",.F.)
	QEP->QEP_IMPFIC := "S"
	MsUnLock()
EndIf

dbSelectArea("TRB")
dbCloseArea()

Ferase(cArqTrb+GetDBExtension())
Ferase(cArqTrb+OrdBagExt())
dbSelectArea("QEK")
dbSetOrder(1) 
dbGoto(nRecQEK)
qek->(dbskip())
enddo
Return

/*/
�������������������������������������������������������������������������Ĵ��
���Descri��o �Gera arquivo de Trabalho 									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � GeraTrab()												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static FuncTion GeraTrab()

While !Eof() .And. xFilial("QE7")==QE7_FILIAL .And. QE7_PRODUTO+QE7_REVI == cProduto
	RecLock("TRB",.T.)
	TRB->PRODUTO	:= QEK->QEK_PRODUTO
	TRB->REVI		:= QEK->QEK_REVI
	TRB->ENSAIO 	:= QE7->QE7_ENSAIO
	TRB->METODO 	:= QE7->QE7_METODO
	TRB->TIPO		:= QE7->QE7_TIPO
	TRB->UNIMED 	:= QE7->QE7_UNIMED
	TRB->NOMINA 	:= QE7->QE7_NOMINA
	TRB->LIE 		:= QE7->QE7_LIE
	TRB->LSE 		:= QE7->QE7_LSE
	TRB->PLAMO		:= QE7->QE7_PLAMO
	TRB->NIVEL  	:= QE7->QE7_NIVEL
	TRB->AM_INS 	:= QE7->QE7_AM_INS
	TRB->LABOR		:= QE7->QE7_LABOR
	TRB->SEQLAB 	:= QE7->QE7_SEQLAB
	TRB->MINMAX 	:= QE7->QE7_MINMAX
	MsUnlock()
	dbSelectArea("QE7")
	dbSkip()
Enddo

dbSelectArea("QE8")
While !Eof() .And. xFilial("QE8")==QE8_FILIAL .And. QE8_PRODUTO+QE8_REVI == cProduto
	RecLock("TRB",.T.)
	TRB->PRODUTO := QEK->QEK_PRODUTO
	TRB->REVI    := QEK->QEK_REVI
	TRB->ENSAIO  := QE8->QE8_ENSAIO
	TRB->METODO  := QE8->QE8_METODO
	TRB->TIPO    := QE8->QE8_TIPO
	TRB->TEXTO   := QE8->QE8_TEXTO
	TRB->PLAMO   := QE8->QE8_PLAMO
	TRB->NIVEL   := QE8->QE8_NIVEL
	TRB->AM_INS  := QE8->QE8_AM_INS
	TRB->LABOR   := QE8->QE8_LABOR
	TRB->SEQLAB  := QE8->QE8_SEQLAB
	MsUnlock()
	dbSelectArea("QE8")
	dbSkip()
Enddo
Return .T.

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Cria perguntas no SX1									  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � QIER200											          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()
Local aPerguntas := {}
Local cSeek      := " "

//Aadd(aPerguntas,{"VIT197","10","Imprime Skip-Teste ?","Imprime Skip-Teste ?",;
//	"Imprime Skip-Teste ?","mv_cha","N",1,0,"C","mv_par10","Todos","Todos","Todos",;
//	"A inspecionar","A inspecionar","A inspecionar"})

//Exclue a pergunta 09, pois a mesma nao sera utilizada
//SX1->(dbSetOrder(1))
//If SX1->(dbSeek("VIT19711"))
//	RecLock("SX1",.F.)
//	SX1->(dbDelete())
//	MsUnLock()
//EndIf

cSeek := (aPerguntas[1,1]+aPerguntas[1,2])
SX1->(dbSetOrder(1))
If SX1->(dbSeek(cSeek))
	RecLock("SX1",.F.)
Else
	RecLock("SX1",.T.)
EndIf	
SX1->X1_GRUPO   := aPerguntas[1,01]
SX1->X1_ORDEM   := aPerguntas[1,02]
SX1->X1_PERGUNT := aPerguntas[1,03]
SX1->X1_PERSPA  := aPerguntas[1,04]
SX1->X1_PERENG  := aPerguntas[1,05]
SX1->X1_VARIAVL := aPerguntas[1,06]
SX1->X1_TIPO    := aPerguntas[1,07]
SX1->X1_TAMANHO := aPerguntas[1,08]
SX1->X1_DECIMAL := aPerguntas[1,09]
SX1->X1_GSC     := aPerguntas[1,10]
SX1->X1_VAR01   := aPerguntas[1,11]
SX1->X1_DEF01   := aPerguntas[1,12]
SX1->X1_DEFSPA1 := aPerguntas[1,13]
SX1->X1_DEFENG1 := aPerguntas[1,14]
SX1->X1_DEF02   := aPerguntas[1,15]
SX1->X1_DEFSPA2 := aPerguntas[1,16]
SX1->X1_DEFENG2 := aPerguntas[1,17]
MsUnlock()
	
Return(NIL)

/*
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Compatibiliza o SXB										  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � QIER200													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSXB()
Local cFilQK1 := ""

cFilQK1 += 'QEK->QEK_FILIAL == @#xFilial("QEK") .And. QEK->QEK_FORNEC == @#mv_par01 .And. '
cFilQK1 += 'QEK->QEK_LOJFOR == @#mv_par02 .And. QEK->QEK_PRODUT == @#mv_par03'

//Ajusta o filtro do QK1
SXB->(dbSetOrder(1))
If SXB->(dbSeek("QK16  ")) 
	If AllTrim(cFilQK1) # AllTrim(SXB->XB_CONTEM)
		RecLock("SXB",.F.)
        SXB->XB_CONTEM := cFilQK1
		MsUnLock()
	EndIf	
EndIf

Return(NIL)
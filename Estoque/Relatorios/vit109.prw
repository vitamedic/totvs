#INCLUDE "VIT109.CH"
#Include "RWMAKE.CH"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    � MATR230  � Autor � Eveli Morasco         � Data � 02/03/93 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Requisicoes para consumo                                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北�         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             潮�
北媚哪哪哪哪哪穆哪哪哪哪履哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅rogramador � Data   � BOPS �  Motivo da Alteracao                     潮�
北媚哪哪哪哪哪呐哪哪哪哪拍哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北矼arcelo Pim.�05/12/97�09882A矷ncl.perg.(Dt.Emiss.,Cod.Prod.,Tipo,Grupo)潮�
北矯esar       �30/03/99砐XXXXX矼anutencao na SetPrint()                  潮�
北滥哪哪哪哪哪牧哪哪哪哪聊哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/


user Function vit109
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis obrigatorias dos programas de relatorio            �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
LOCAL Tamanho  := "M"
LOCAL titulo   := STR0001 	//"Requisicoes para Consumo"
LOCAL cDesc1   := STR0002	//"Emite a relacao das requisicoes feitas para consumo , dividindo por"
LOCAL cDesc2   := STR0003	//"Centro de Custo requisitante ou Conta Contabil.Este relatorio e' um"
LOCAL cDesc3   := STR0004	//"pouco demorado porque ele cria o arquivo de indice na hora."
LOCAL cString  := "SD3"
LOCAL aOrd     := {OemToAnsi(STR0005),OemToAnsi(STR0006)}    //" Centro Custo "###" Cta.Contabil "
LOCAL wnrel    := "VIT109"+Alltrim(cusername)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis tipo Private padrao de todos os relatorios         �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
PRIVATE aReturn:= {OemToAnsi(STR0007),1,OemToAnsi(STR0008), 2, 2, 1, "",1}    //"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0 ,cPerg := "MTR230"

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Verifica as perguntas selecionadas                           �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // De  Centro de Custo                          �
//� mv_par02     // Ate Centro de Custo                          �
//� mv_par03     // Moeda Selecionada ( 1 a 5 )                  �
//� mv_par04     // De  Local                                    �
//� mv_par05     // Ate Local                                    �
//� mv_par06     // Da  Data                                     �
//� mv_par07     // Ate Data                                     �
//� mv_par08     // Do  Produto                                  �
//� mv_par09     // Ate Produto                                  �
//� mv_par10     // Do  Tipo                                     �
//� mv_par11     // Ate Tipo                                     �
//� mv_par12     // Do  Grupo                                    �
//� mv_par13     // Ate Grupo                                    �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
pergunte(cPerg,.F.)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Envia controle para a funcao SETPRINT                        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C230Imp(aOrd,@lEnd,wnRel,titulo,Tamanho)},titulo)

Return NIL

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � C230IMP  � Autor � Rodrigo de A. Sartorio� Data � 07.12.95 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Chamada do Relatorio                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � MATR230  			                                      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function C230Imp(aOrd,lEnd,WnRel,titulo,Tamanho)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis locais exclusivas deste programa                   �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
LOCAL nTipo    	:= 0
LOCAL cRodaTxt 	:= OemToAnsi(STR0009)   //"REGISTRO(S)"
LOCAL nCntImpr 	:= 0
LOCAL nAc1:=0,nAc2:=0,nAg1:=0,nAg2:=0,nAt1:=0,nAt2:=0,nAp1:=0,nAp2:=0
LOCAL	lLista:=.F.
LOCAL dEmissao ,lImprime,nUnit:=0,cCcant,cGrupant,cProdant,cContant
LOCAL cCampoCus,lContinua,lPassou1,lPassou2,lPassou3
LOCAL cCond 	:= 'D3_FILIAL=="'+xFilial("SD3")+'"  .And. D3_CC >= "'+mv_par01+'"'
Local aEntCt    := If(CtbInUse(), { "CT1", "CTT" }, { "SI1", "SI3" })

cCond += '.And. D3_CC <= "'+mv_par02+'" .And. D3_LOCAL >= "'+mv_par04+'"'
cCond += '.And. D3_LOCAL <= "'+mv_par05+'"'
cCond += '.And. D3_COD >= "'+mv_par08+'" .And. D3_COD <= "'+mv_par09+'"'
cCond += '.And. D3_TIPO >= "'+mv_par10+'" .And. D3_TIPO <= "'+mv_par11+'"'
cCond += '.And. D3_ESTORNO == " "'
cCond += '.And. D3_CONTA >= "'+mv_par14+'" .And. D3_CONTA <= "'+mv_par15+'"'

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Contadores de linha e pagina                                 �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
PRIVATE li := 80 ,m_pag := 1

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis locais exclusivas deste programa                   �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
PRIVATE cNomArq

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Caso seja TOPCONNECT, soma o filtro na condicao da IndRegua�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
#IFDEF TOP
	If !Empty(aReturn[7])
		cCond+=".And."+aReturn[7]
	EndIf
#ENDIF

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
nTipo  := IIF(aReturn[4]==1,15,18)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Adiciona a ordem escolhida ao titulo do relatorio          �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If Type("NewHead")#"U"
	NewHead += " (Por "+AllTrim(aOrd[aReturn[8]])+" ,em "+AllTrim(GetMv("MV_SIMB"+LTrim(Str(mv_par03))))+")"
Else
	Titulo  += " (Por "+AllTrim(aOrd[aReturn[8]])+" ,em "+AllTrim(GetMv("MV_SIMB"+LTrim(Str(mv_par03))))+")"
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Define o campo a ser impresso no valor de acordo com a moeda selecionada �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
cCampoCus := "SD3->D3_CUSTO"+Str(mv_par03,1)

lContinua := .T.

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Inicializa variaveis para controlar cursor de progressao     �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
dbSelectArea("SD3")
SetRegua(LastRec())

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Pega o nome do arquivo de indice de trabalho             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
cNomArq := CriaTrab("",.F.)

If aReturn[8] == 1
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Cria o indice de trabalho                                �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	IndRegua("SD3",cNomArq,"D3_FILIAL+D3_CC+D3_GRUPO+D3_COD",,cCond,OemToAnsi(STR0010))   //"Selecionando Registros..."
	dbGoTop()
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Cria o cabecalho de acordo com a ordem selecionada       �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	cabec1 :=OemToAnsi(STR0011)   //"C.C       DESCRICAO                 CODIGO PRODUTO  DESCRICAO                 UM       QUANTIDADE          CUSTO        C U S T O"
	cabec2 :=OemToAnsi(STR0012)   //"                                                                                                        UNITARIO        T O T A L"
	*****      123456789 1234567890123456789012345 123456789012345 1234567890123456789012345 12 9999999999999.99 99999999999.99 9999999999999.99
	*****      0         1         2         3         4         5         6         7         8         9        10        11        12        13
	*****      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	
	Store 0 To nAt1,nAt2
	lPassou3 := .F.                     
	_mal := .F.
	While lContinua .And. !EOF()
		cCcant := D3_CC
		Store 0 To nAc1,nAc2
		lImprime := .T.
		lPassou2 := .F.
		While lContinua .And. !EOF() .And. D3_FILIAL+D3_CC == cFilial+cCCAnt
			cGrupant := D3_GRUPO
			Store 0 To nAg1,nAg2,_ma
			lPassou1 := .F.
			While lContinua .And. !EOF() .And. D3_FILIAL+D3_CC+D3_GRUPO == cFilial+cCCAnt+cGrupAnt
				cProdant := D3_COD+D3_LOCAL
				Store 0 To nAp1,nAp2
				While lContinua .And. !EOF() .And. D3_FILIAL+D3_CC+D3_GRUPO+D3_COD+D3_LOCAL == cFilial+cCCAnt+cGrupAnt+cProdAnt
					If lEnd
						@ PROW()+1,001 PSay OemToAnsi(STR0013)    //"CANCELADO PELO OPERADOR"
						lContinua := .F.
						Exit
					EndIf
					IncRegua()
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					//� So' entra requisicao e devolucao                      �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					If SubStr(D3_CF,2,1) != "E"
						dbSkip()
						Loop
					EndIf
					
					IF D3_EMISSAO < mv_par06 .OR. D3_EMISSAO > mv_par07
						dbSkip()
						Loop
					ENDIF
					
					IF D3_GRUPO < mv_par12 .OR. D3_GRUPO > mv_par13
						dbSkip()
						Loop
					ENDIF
					
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					//� Se tiver numero de OP nao e' para consumo , portanto  �
					//� nao deve entrar                                       �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					If Substr(D3_OP,7,2) # "OS" .And. !Empty(D3_OP)
						dbSkip()
						Loop
					EndIf
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//矱u estou somando as requisicoes e subtraindo as  devolucoes �
					//硃orque este mapa tem o objetivo de totalizar os movimentos  �
					//砳nternos,nao tem sentido mostrar um monte de valores negati-�
					//硋os ,sendo que as requisicoes normalmente serao maiores  que�
					//砤s devolucoes.                                              �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					If D3_TM <= "500"
						nAp1 -= D3_QUANT
						nAp2 -= &(cCampoCus)
					Else
						nAp1 += D3_QUANT
						nAp2 += &(cCampoCus)
					EndIf
					dbSkip()
				EndDo
				If nAp1 != 0 .Or. nAp2 != 0
					IF li > 58
						cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
						lImprime := .T. 
						_mal = .t.
					EndIf
					If lImprime
 					  if nCntImpr >1 .and. !_mal
						 cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
						 _mal := .f.
					  endif
						@ li,000 PSay cCcant
						dbSelectArea(aEntCt[2])
						dbSeek(cFilial+cCcant)
						@li,021 PSay 	Left(If(Alias() = "CTT", &("CTT_DESC" +;
										StrZero(mv_par03, 2)), I3_DESC), 23)
						lImprime := .F.
					EndIf
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					//� Adiciona 1 ao contador de registros impressos         �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					nCntImpr++
					dbSelectArea("SB1")
					dbSeek(cFilial+cProdant)
					@li,045 PSay B1_COD
					@li,061 PSay Substr(B1_DESC,1,22)
					@li,084 PSay B1_UM
					@li,087 PSay nAp1 Picture PesqPictQt("D3_QUANT",16)
					dbSelectArea("SD3")
					IF nAp1 = 0
						nUnit := nAp2
					Else
						nUnit := nAp2/nAp1
					EndIf
					@li,100 PSay nUnit PicTure tm(nUnit,14)
					@li,114 PSay nAp2  PicTure tm(nAp2,16)
					li++
					nAg1 += nAp1
					nAg2 += nAp2
					lPassou1 := .T.
					dbSelectArea("SD3")
				EndIf
			EndDo
			If lPassou1
				Li++
				@li,049 PSay OemToAnsi(STR0014)+cGrupant+Replicate(".",19)    //"Total do Grupo "
				@li,087 PSay nAg1 Picture PesqPictQt("D3_QUANT",16)
				@li,114 PSay nAg2 PicTure tm(nAg2,16)
				li++;li++
				nAc1 += nAg1
				nAc2 += nAg2
				lPassou2 := .T.
			EndIf
		EndDo
		If lPassou2
			@li,049 PSay OemToAnsi(STR0015)+Padl(Alltrim(cCcant),20)+"."    //"Total Centro de Custo "
			@li,087 PSay nAc1 Picture PesqPictQt("D3_QUANT",16)
			@li,114 PSay nAc2 PicTure tm(nAc2,16)
			li++;li++
			nAt1 += nAc1
			nAt2 += nAc2
			lPassou3 := .T.
  			_mal := .f.
		EndIf
	EndDo
/*	If lPassou3
		@ li,049 PSay OemToAnsi(STR0016) //"TOTAL GERAL....................."
		@ li,087 PSay nAt1 Picture PesqPictQt("D3_QUANT",16)
		@ li,114 PSay nAt2 PicTure tm(nAt2,16)
		li++
	EndIf*/
ElseIf aReturn[8] == 2
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Cria o indice de trabalho                                �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	IndRegua("SD3",cNomArq,"D3_FILIAL+D3_CONTA+D3_CC+D3_COD",,cCond,OemToAnsi(STR0010))   //"Selecionando Registros..."
	dbGoTop()
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Cria o cabecalho de acordo com a ordem selecionada       �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	cabec1 := OemToAnsi(STR0017)   //"  DATA  C E N T R O  D E   C U S T O        C O N T A   C O N T A B I L                             V A L O R"
	cabec2 := ""
	*****      123456789 1234567890123456789012345 123456789012345 1234567890123456789012345 12 9999999999999.99 99999999999.99 9999999999999.99
	*****      0         1         2         3         4         5         6         7         8         9        10        11        12        13
	*****      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	lPassou3 := .F.
	While lContinua .And. !EOF()
		cContant := D3_CONTA                                 		
		Store 0 To nAc1                                      
		lPassou2 := .F.					
		While lContinua .And. !EOF() .And. D3_FILIAL+D3_CONTA == cFilial+cContant
			cCcant := D3_CC
			Store 0 To nAc2
			lLista:=.F.                                      
			While lContinua .And. !EOF() .And. D3_FILIAL+D3_CONTA+D3_CC == cFilial+cContant+cCCAnt
				If lEnd
					@ PROW()+1,001 PSay OemToAnsi(STR0013)  //"CANCELADO PELO OPERADOR"
					lContinua := .F.
					Exit
				EndIf
				IncRegua()
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� So' entra requisicao e devolucao                      �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				If SubStr(D3_CF,2,1) != "E"
					dbSkip()
					Loop
				EndIf
				
				IF D3_EMISSAO < mv_par06 .OR. D3_EMISSAO > mv_par07
					dbSkip()
					Loop
				ENDIF
				
				IF D3_GRUPO < mv_par12 .OR. D3_GRUPO > mv_par13
					dbSkip()
					Loop
				ENDIF
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� Se tiver numero de OP nao e' para consumo , portanto  �
				//� nao deve entrar                                       �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				If Substr(D3_OP,7,2) # "OS" .And. !Empty(D3_OP)
					dbSkip()
					Loop
				EndIf
				lLista:=.T.
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矱u estou somando as requisicoes e subtraindo as  devolucoes �
				//硃orque este mapa tem o objetivo de totalizar os movimentos  �
				//砳nternos,nao tem sentido mostrar um monte de valores negati-�
				//硋os ,sendo que as requisicoes normalmente serao maiores  que�
				//砤s devolucoes.                                              �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If D3_TM <= "500"
					nAc2 -= &(cCampoCus)
				Else
					nAc2 += &(cCampoCus)
				EndIf
				dEmissao := D3_EMISSAO
				dbSkip()
			EndDo
			If lLista
				IF li > 58
					cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf
				dbSelectArea(aEntCt[2])
				dbSeek(cFilial+cCcant)
	
				dbSelectArea(aEntCt[1])
				dbSeek(cFilial+cContant)
				dbSelectArea("SD3")
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� Adiciona 1 ao contador de registros impressos         �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				nCntImpr++
				@ li,000 		PSay dEmissao
				@ li,Pcol()+1	PSay cCcant
				@ li,Pcol()+1	PSay SubStr(If(aEntCt[2] = "CTT", &("CTT->CTT_DESC" + StrZero(mv_par03, 2)), SI3->I3_DESC),1,35)
				@ li,057		PSay cContant
  			   @ li,Pcol()+1	PSay SubStr(If(aEntCt[1] = "CT1", &("CT1->CT1_DESC" + StrZero(mv_par03, 2)),AllTrim(SI1->I1_DESC)),1,30)
				@ li,110		PSay nAc2 Picture TM(nAc2,18)

				nAc1 += nAc2
				lPassou2 := .T.				
				li++
			EndIf
		EndDo
		If lPassou2
			@ li,000 PSay OemToAnsi(STR0018)+cContant   //"Total da Conta --> "
			@ li,110 PSay nAc1 PicTure TM(nAc1,18)
			li += 2
			nAg1 += nAc1
			lPassou3 := .T.
  		EndIf
	EndDo
	If lPassou3
		@ li,000 PSay OemToAnsi(STR0019)  //"T O T A L --->"
		@ li,110 PSay nAg1 PicTure TM(nAg1,18)
	EndIf
EndIf

/*IF li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF*/

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Devolve as ordens originais do arquivo                       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
RetIndex("SD3")
Set Filter to

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Apaga indice de trabalho                                     �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
cNomArq += OrdBagExt()
Delete File &(cNomArq)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

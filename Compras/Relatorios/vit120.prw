#Include "vit120.ch"
#INCLUDE "RWMAKE.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MATR190  ³ Autor ³ Paulo Boschetti       ³ Data ³ 02.03.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao da Relacao de Amarracao Produto X Fornecedor       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR190(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Atualizacoes Sofridas Desde a construcao Inicial.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Edson   M.   ³30/03/99³XXXXXX³Passar o Tamanho na SetPrint.           ³±±
±±³ Patricia Sal.³22/12/99³XXXXXX³Acerto LayOut, Fornec. c/ 20 pos. e Loja³±±
±±³              ³        ³      ³com 4 pos.                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
user function vit120
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel

LOCAL cDesc1 :=STR0001	//"Este programa tem como objetivo , relacionar os produtos e seus"
LOCAL cDesc2 :=STR0002	//"respectivos Fornecedores."
LOCAL cDesc3 :=""
LOCAL cString:="SA5"
PRIVATE titulo  :=STR0003	//"Relacao de Amarracao Produto x Fornecedor"
PRIVATE tamanho :="M"
PRIVATE cPerg   := "vit120"
PRIVATE aReturn := { STR0004, 1,STR0005, 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:= "vit120",nLastKey := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "vit120"+Alltrim(cusername)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//pergunte("vit120",.F.)
cperg:="PERGVIT120"
_pergsx1()
pergunte(cperg,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Produto de           	      		  ³
//³ mv_par02             // Produto Ate                          ³
//³ mv_par03             // Fornecedor De           	           ³
//³ mv_par04             // Fornecedor Ate                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| R190Imp(@lEnd,wnrel,cString)},Titulo)

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R190IMP  ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR190			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R190Imp(lEnd,wnrel,cString)
LOCAL CbTxt,cbCont:=00
LOCAL lFirst := .t.
LOCAL cProdAnt := space(15)
LOCAL cProd    := space(132)
LOCAL nCount := 0
LOCAL limite :=132
LOCAL nPosNome := 70
LOCAL nTamNome := 40

STATIC aTamSXG, aTamSXG2

// Verifica conteudo das variaveis Grupo Fornecedor (001) e Loja (002)
aTamSXG := If(aTamSXG == NIL, TamSXG("001"), aTamSXG)
aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

// Verifica se utilizara LayOut Max. (Fornec. com 20 pos. e Loja com 4 pos.)
If aTamSXG[1] != aTamSXG[3]
	cabec1:= STR0008  //"CODIGO PRODUTO  DESCRICAO DO PRODUTO           TP GRUPO UM  CODIGO               LJ   RAZAO SOCIAL              CODIGO NO FORNECEDOR"
	//	  	   		          123456789012345 123456789012345678901234567890 12 123   12  12345678901234567890 1234 123456789012345678901234  12345678901234567890
	//	  		                0         1         2         3         4         5         6         7         8         9        10        11        12        13
	//				             0123456789012345678901234567890123456789012345678901234567890123456789013245678901234567890123456789012345678901234567890123456789012
	
Else
	cabec1 := STR0006  //"CODIGO PRODUTO  DESCRICAO DO PRODUTO           TP GRUPO UM  CODIGO LJ  RAZAO SOCIAL                             CODIGO NO FORNECEDOR"
	//		   		          123456789012345 123456789012345678901234567890 12 123   12  123456 12 1234567890123456789012345678901234567890  123467901234567890
	//     			          0         1         2         3         4         5         6         7         8         9        10        11        12        13
	//					          0123456789012345678901234567890123456789012345678901234567890123456789013245678901234567890123456789012345678901234567890123456789012
Endif
cabec2:= ""
cabec3:= ""
cbtxt := SPACE(10)
Li    := 80
m_pag := 01
nTipo := IIF(aReturn[04]==1,15,18)
// Verif. se utilizara Tam. Max.  (Fornec. com 20 pos. e Loja com 4 pos.)
If aTamSXG[1] != aTamSXG[3]
	nPosNome += ((aTamSXG[4]-aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
	nTamNome -= ((aTamSXG[4]-aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
Endif
dbSelectArea("SA5")
dbSetOrder(2)
Set Softseek on
dbSeek(cFilial+mv_par01)
Set Softseek off

SetRegua(RecCount())

While !Eof() .and. A5_FILIAL+A5_PRODUTO <= cFilial+mv_par02
	If lEnd
		@PROW()+1,001 PSAY STR0007	//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	IncRegua()
	If A5_FORNECEDOR < mv_par07 .or. A5_FORNECEDOR > mv_par08
		dbSkip()
		Loop
	Endif
	If A5_FORNECEDOR = "159229" .or. A5_FORNECEDOR = "408105" .OR. A5_FORNECEDOR = "521129" .OR.;
      A5_FORNECEDOR = "785870" .or. A5_FORNECEDOR = "541132"
		dbSkip()
		Loop
	Endif
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(cFilial+SA5->A5_PRODUTO)
	if sa5->a5_produto<mv_par01 .or.;
      sa5->a5_produto>mv_par02 
		dbSelectArea("SA5")  			
		dbSkip()
		Loop                          
	endif				
	if sb1->b1_tipo<mv_par03 .or.;
		sb1->b1_tipo>mv_par04 
		dbSelectArea("SA5")  			
		dbSkip()
		Loop                          
	endif				
	if	sb1->b1_grupo<mv_par05 .or.;
		sb1->b1_grupo>mv_par06 
  		dbSelectArea("SA5")  			
		dbSkip()
		Loop                          
   endif		
	dbSelectArea("SA5")  			
	lFirst := .T.
	nCount := 0
	cProdAnt := A5_PRODUTO
	
	While !eof() .and. A5_FILIAL+A5_PRODUTO == cFilial+cProdAnt
		If lEnd
			@PROW()+1,001 PSAY STR0007	//"CANCELADO PELO OPERADOR"
			Exit
		Endif                           
		If A5_FORNECEDOR < mv_par07 .or. A5_FORNECEDOR > mv_par08
			dbSkip()
			Loop
		Endif
		if A5_FORNECEDOR = "159229" .or. A5_FORNECEDOR = "408105" .or. A5_FORNECEDOR = "521129" .or.;
         A5_FORNECEDOR = "785870" .or. A5_FORNECEDOR = "541132"
    	   dbSkip()
	   	Loop
  		Endif
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(cFilial+SA5->A5_PRODUTO)
		if sa5->a5_produto<mv_par01 .or.;
        sa5->a5_produto>mv_par02 
   		dbSelectArea("SA5")  			
	    	dbSkip()
	   	Loop                          
	  endif				
	if sb1->b1_tipo<mv_par03 .or.;
		sb1->b1_tipo>mv_par04 
		dbSelectArea("SA5")  			
		dbSkip()
		Loop                          
	endif				
	if	sb1->b1_grupo<mv_par05 .or.;
		sb1->b1_grupo>mv_par06 
  		dbSelectArea("SA5")  			
		dbSkip()
		Loop                          
   endif		
	dbSelectArea("SA5")  			

		If Li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		     
		
		If lFirst
			dbSelectArea("SB1")
			dbSeek(cFilial+SA5->A5_PRODUTO)
			cProd := SA5->A5_PRODUTO+" "+Substr(B1_DESC,1,30)+" "+B1_TIPO+" "+B1_GRUPO+"  "+B1_UM
			@Li , 00 PSAY cProd
			lFirst := .f.
			dbSelectArea("SA5")
		Endif
		If Li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif     
		
		@Li , 60 PSAY A5_FORNECE+" "+A5_LOJA
		
		dbSelectArea("SA2")
		dbSeek(cFilial+SA5->A5_FORNECE+SA5->A5_LOJA)
		_mtipo := " "       
		if a2_tipo == "X"   
		  _mtipo := " Importacao" 
		endif
	
		@Li , nPosNome PSAY SUBS(A2_NOME,1,nTamNome)+" - "+_mtipo
		
		dbSelectArea("SA5")
		
//		@Li ,112 PSAY A5_CODPRF
		
		nCount++
		Li++
		dbSkip()
		
	End
	
	If nCount > 0
		@Li , 00 PSAY __PrtThinLine()
		Li++
	Endif
	
End

If Li != 80
	roda(CbCont,cbtxt,"M")
EnDif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SA5")
Set Filter To
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
return .T.

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Do fornecedor      ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"08","Ate fornecedor     ?","mv_ch8","C",06,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})

for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,04]
		sx1->x1_tipo   :=_agrpsx1[_i,05]
		sx1->x1_tamanho:=_agrpsx1[_i,06]
		sx1->x1_decimal:=_agrpsx1[_i,07]
		sx1->x1_presel :=_agrpsx1[_i,08]
		sx1->x1_gsc    :=_agrpsx1[_i,09]
		sx1->x1_valid  :=_agrpsx1[_i,10]
		sx1->x1_var01  :=_agrpsx1[_i,11]
		sx1->x1_def01  :=_agrpsx1[_i,12]
		sx1->x1_cnt01  :=_agrpsx1[_i,13]
		sx1->x1_var02  :=_agrpsx1[_i,14]
		sx1->x1_def02  :=_agrpsx1[_i,15]
		sx1->x1_cnt02  :=_agrpsx1[_i,16]
		sx1->x1_var03  :=_agrpsx1[_i,17]
		sx1->x1_def03  :=_agrpsx1[_i,18]
		sx1->x1_cnt03  :=_agrpsx1[_i,19]
		sx1->x1_var04  :=_agrpsx1[_i,20]
		sx1->x1_def04  :=_agrpsx1[_i,21]
		sx1->x1_cnt04  :=_agrpsx1[_i,22]
		sx1->x1_var05  :=_agrpsx1[_i,23]
		sx1->x1_def05  :=_agrpsx1[_i,24]
		sx1->x1_cnt05  :=_agrpsx1[_i,25]
		sx1->x1_f3     :=_agrpsx1[_i,26]
		sx1->(msunlock())
	endif
next
return


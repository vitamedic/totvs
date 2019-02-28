/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT136   ³ Autor ³ Aline                 ³ Data ³ 24/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acompanhamento de OP                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "topconn.ch"
#include "rwmake.ch"

user function vit136()
nordem   :=""
tamanho  :="G"
limite   :=132
titulo   :="RELACAO POR ORDEM DE PRODUCAO"
cdesc1   :="Este programa ira emitir o relatorio de RELACAO POR ORDEM DE PRODUCAO"
cdesc2   :=""
cdesc3   :=""
cstring  :="SD3"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT136"
wnrel    :="VIT136"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT136"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

If nLastKey = 27
   Set Filter To
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
   Set Filter To
   Return
Endif

RptStatus({|lEnd| R860Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R860Imp  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR860			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R860Imp(lEnd,wnRel,titulo,tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cabec1,cabec2
LOCAL cRodaTxt := ""
LOCAL nCntImpr := 0
LOCAL nTipo    := 0
LOCAL nomeprog := "VIT136"
LOCAL cCondicao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para controle do cursor de progressao do relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nTotRegs := 0 ,nMult := 1 ,nPosAnt := 4 ,nPosAtu := 4 ,nPosCnt := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL bBloco := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }
LOCAL dDataFec:= GETMV("MV_ULMES")
LOCAL cOpAnt ,cCampoCus ,nCusto ,lContinua := .T.
LOCAL nTotQuant, nTotCusto, nTotReq, nTotProd, nTotDev
LOCAL nTotQuantMod, nTotCustoMod, nTotReqMod, nTotDevMod
LOCAL nQuantReq,nQuantProd,nQuantDev
LOCAL nQtdReqMod,nQtdDevMod

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cNomArq

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona informacoes ao titulo do relatorio                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("NewHead")#"U"
	NewHead += " - "+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par03))))
Else
	Titulo  += " - "+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par03))))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 :="CENTRO               ORDEM DE    MOV CODIGO DO       DESCRICAO              QUANTIDADE UM         CUSTO       C U S T O  NUMERO       DATA DE"
cabec2 :="CUSTO                PRODUCAO        PRODUTO                                                   UNITARIO       T O T A L  DOCUMENTO    EMISSAO"
*****				   12345678901234567890 12345612121 123 123456789012345 12345678901234567890 9,999,999.99 12 99,999,999.99 9999,999,999.99 123456789012 12/12/1234
*****    			   0         1         2         3         4         5         6         7         8         9        10        11        12        13
*****				   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o campo a ser impresso no valor de acordo com a moeda selecionada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par03 == 1
		cCampoCus :=   "SD3->D3_CUSTO1"
	Case mv_par03 == 2
		cCampoCus :=   "SD3->D3_CUSTO2"
	Case mv_par03 == 3
		cCampoCus :=   "SD3->D3_CUSTO3"
	Case mv_par03 == 4
		cCampoCus :=   "SD3->D3_CUSTO4"
	Case mv_par03 == 5
		cCampoCus :=   "SD3->D3_CUSTO5"
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega o nome do arquivo de indice de trabalho             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := CriaTrab("",.F.)

dbSelectArea("SD3")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o indice de trabalho                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCondicao := "D3_FILIAL == '"+xFilial("SD3")+"' .And. D3_OP >= '"+mv_par01+"'"
cCondicao += " .And. D3_OP <= '"+mv_par02+"' .And. D3_OP <> ' ' .And. DTOS(D3_EMISSAO) >= '"+DTOS(mv_par04)+"'.And. DTOS(D3_EMISSAO) <= '"+DTOS(mv_par05)+"'"

IndRegua("SD3",cNomArq,"D3_FILIAL+D3_OP+D3_CHAVE+D3_NUMSEQ+D3_COD",,cCondicao,)     //"Selecionando Registros..."
dbGoTop()

nTotReq		:=nTotProd		:= nTotDev := 0
nTotReqMod	:=nTotDevMod	:= 0
nQuantReq	:=nQuantProd	:= nQuantDev:=0
nQtdReqMod	:=nQtdDevMod	:= 0

SetRegua(LastRec())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Correr SD3 para ler as REs, DEs e Producoes.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While lContinua .And. !Eof()

	If lEnd
		@ PROW()+1,001 PSay "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	IncRegua()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Correr SD3 para a mesma OP.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotQuant := nTotCusto := nQtdeProd := 0
	nTotQuantMod := nTotCustoMod := 0
	cOpAnt := D3_OP
	While !Eof() .AND. D3_FILIAL+D3_OP = xFilial()+cOpAnt

		If lEnd
			@ PROW()+1,001 PSay "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		EndIf

		IncRegua()

		If li > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIf
		
		If D3_ESTORNO == "S"
			dbSkip()
			Loop
		EndIf	
		nCusto := &(cCampoCus)
		If SubStr(SD3->D3_COD,1,3) != "MOD"
			nTotQuant += IIf( SubStr(D3_CF,1,2) == "RE", D3_QUANT, 0 )
			nTotCusto += IIf( SubStr(D3_CF,1,2) == "RE", nCusto, 0 )

			nTotQuant += IIf( SubStr(D3_CF,1,2) == "DE", ( -D3_QUANT ), 0 )
			nTotCusto += IIf( SubStr(D3_CF,1,2) == "DE", ( -nCusto ), 0 )
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Totaliza‡„o separada para a m„o-de-obra                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotQuantMod += IIf( SubStr(D3_CF,1,2) == "RE", D3_QUANT, 0 )
			nTotCustoMod += IIf( SubStr(D3_CF,1,2) == "RE", nCusto, 0 )

			nTotQuantMod += IIf( SubStr(D3_CF,1,2) == "DE", ( -D3_QUANT ), 0 )
			nTotCustoMod += IIf( SubStr(D3_CF,1,2) == "DE", ( -nCusto ), 0 )
		EndIf

		nQtdeProd += IIf( SubStr(D3_CF,1,2) == "PR", D3_QUANT , 0 )
		nQtdeProd += IIf( SubStr(D3_CF,1,2) == "ER", -D3_QUANT , 0 )

		dbSelectArea("SB1")
		dbSeek(cFilial+SD3->D3_COD)
		dbSelectArea("SD3")
		If SubStr(D3_CF,1,2) == "PR"
			Li++
		EndIf	
		@ Li,000 PSay D3_CC
		@ Li,021 PSay D3_OP
		@ Li,033 PSay D3_CF
		@ Li,037 PSay D3_COD
		@ Li,053 PSay SubStr(SB1->B1_DESC,1,20)
		If SubStr(D3_CF,1,2) == "DE"
			@ Li,074 PSay ( -D3_QUANT )	      Picture    PesqPict("SD3","D3_QUANT",12)
			@ Li,087 PSay D3_UM
			@ Li,090 PSay ( nCusto/D3_QUANT ) Picture "@e 999,999.99999" //PesqPict("SD3","D3_CUSTO1",13)
			@ Li,104 PSay ( -nCusto )         Picture PesqPict("SD3","D3_CUSTO1",15)
		Else	
			@ Li,074 PSay D3_QUANT 	         Picture PesqPict("SD3","D3_QUANT",12)
			@ Li,087 PSay D3_UM
			@ Li,090 PSay ( nCusto/D3_QUANT ) Picture "@e 999,999.99999" //PesqPict("SD3","D3_CUSTO1",13)
			@ Li,104 PSay nCusto              Picture PesqPict("SD3","D3_CUSTO1",15)
		EndIf
		@ Li,121 PSay D3_DOC
		@ Li,134 PSay D3_EMISSAO
		Li++		
		If SubStr(SD3->D3_COD,1,3) != "MOD"
			If SubStr(D3_CF,1,2) == "RE"
				nTotReq		+= nCusto
				nQuantReq	+= D3_QUANT
			Elseif SubStr(D3_CF,1,2) == "DE"
				nTotDev		+= nCusto
				nQuantDev	+= D3_QUANT
			Endif
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Totaliza‡„o separada para a m„o-de-obra                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SubStr(D3_CF,1,2) == "RE"
				nTotReqMod		+= nCusto
				nQtdReqMod		+= D3_QUANT
			Elseif SubStr(D3_CF,1,2) == "DE"
				nTotDevMod		+= nCusto
				nQtdDevMod		+= D3_QUANT
         Endif
		EndIf

		If SubStr(D3_CF,1,2) == "PR"
			nTotProd		+= nCusto
			nQuantProd	+= D3_QUANT
		Endif
		
		dbSkip()
		
	End

	Li++
	If (nTotQuant+nTotQuantMod) != 0
		@ Li,000 PSay "TOTAL  " + cOpAnt	//"TOTAL  "
		@ Li,019 PSay "Custo STD : "
		@ Li,033 PSay SB1->B1_CUSTD                 Picture PesqPict("SB1","B1_CUSTD",11)
		@ Li,044 PSay "/"
		@ Li,049 PSay ( SB1->B1_CUSTD * nQtdeProd ) Picture PesqPict("SB1","B1_CUSTD",14)
		If mv_par06 == 1
			@ Li,074 PSay nTotQuant                     Picture PesqPict("SD3","D3_QUANT",12)
		Endif	
		@ Li,104 PSay nTotCusto           Picture PesqPict("SD3","D3_CUSTO1",15)
		Li++
		If nTotQuantMod <> 0 .OR. nTotCustoMod <> 0
			@ Li,000 PSay "       MAO DE OBRA:"
			@ Li,074 PSay nTotQuantMod                  Picture PesqPict("SD3","D3_QUANT",12)
			@ Li,104 PSay nTotCustoMod                  Picture PesqPict("SD3","D3_CUSTO1",15)
			Li++
		Endif
	EndIf
	If SC2->(dbSeek(xFilial("SC2")+cOPAnt))
		@ li,000 PSay cOpAnt+" - Valor final no ultimo fechamento" +DTOC(dDataFec) //+")" //" - Valor final no ultimo fechamento ("
		@ li,105 PSay &(Eval(bBloco,"SC2->C2_VFIM",mv_par03)) Picture PesqPict("SD3","D3_CUSTO1",15)	
		li++
		@ li,000 PSay " - Valor final no ultimo fechamento "+SC2->C2_PRODUTO
		li++
	EndIf	

	@ Li,000 PSay Replicate("-",220)
	Li += 2

EndDo

If li != 80
	Li++
	@ Li,000 PSay "TOTAL REQUISICOES ---->"
	If mv_par06 == 1
		@ Li,074 PSay nQuantReq		Picture PesqPict("SD3","D3_QUANT",12)
	EndIf
	@ Li,105 PSay nTotReq		Picture PesqPict("SD3","D3_CUSTO1",15)
	Li++
	If li > 58
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
	@ Li,000 PSay "TOTAL PRODUCAO    ---->"
	If mv_par06 == 1
		@ Li,074 PSay nQuantProd	Picture PesqPict("SD3","D3_QUANT",12)
	EndIf
	@ Li,105 PSay nTotProd		Picture PesqPict("SD3","D3_CUSTO1",15)
	Li++
	@ Li,000 PSay "TOTAL DEVOLUCOES  ---->"
	If mv_par06 == 1
		@ Li,074 PSay nQuantDev		Picture PesqPict("SD3","D3_QUANT",12)
	EndIf
	@ Li,105 PSay nTotDev		Picture PesqPict("SD3","D3_CUSTO1",15)
   Li++
	If li > 57
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf

	If nTotReqMod <> 0
		@ Li,000 PSay "TOTAL REQUISICOES MAO DE OBRA ---->"
		If mv_par06 == 1
			@ Li,074 PSay nQtdReqMod	Picture PesqPict("SD3","D3_QUANT",12)
		EndIf
		@ Li,105 PSay nTotReqMod   Picture PesqPict("SD3","D3_CUSTO1",15)
		Li++
	EndIf
	If nTotDevMod <> 0
		@ Li,000 PSay "TOTAL DEVOLUCOES  MAO DE OBRA ---->"
		If mv_par06 == 1
			@ Li,074 PSay nQtdDevMod	Picture PesqPict("SD3","D3_QUANT",12)
		EndIf
		@ Li,105 PSay nTotDevMod   Picture PesqPict("SD3","D3_CUSTO1",15)
		Li++
	Endif
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve as ordens originais do arquivo                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SD3")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga indice de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq += OrdBagExt()
FErase( cNomArq )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD3")
RetIndex("SD3")
Set Filter To
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
/*
Return NIL
Picture PesqPict("SD3","D3_QUANT",12)
		EndIf
		@ Li,105 PSay nTotDevMod   Picture PesqPict("SD3","D3_CUSTO1",15)
		Li++
	Endif
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve as ordens originais do arquivo                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SD3")

//ÚÄÄÄÄÄÄÄÄÄÄÄ      

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da O.P             ?","mv_ch1","C",11,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate O.P            ?","mv_ch2","C",11,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Qual a Moeda       ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03"       ,"Moeda1"         ,space(30),space(15),"Moeda2"         ,space(30),space(15),"Moeda3"         ,space(30),space(15),"Moeda4"         ,space(30),space(15),"Moeda5"         ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","De Data Movimento  ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Ate Data Movimento ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Total.Qtde.por O.P ?","mv_ch6","N",08,0,0,"C",space(60),"mv_par06"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{cperg,"13","Tipo Pedido        ?","mv_chC","N",01,0,0,"C",space(60),"mv_par13"       ,"Normal"         ,space(30),space(15),"Licitações"     ,space(30),space(15),"Todos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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


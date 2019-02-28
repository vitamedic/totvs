#include "rwmake.ch"
#include "topconn.ch"

User Function RComsc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,CABEC1,CABEC2,LARG,M_PAG")
SetPrvt("NR_FOLHA,CAB,CSTRING,XCOD_EMP,XCONT,XMD")
SetPrvt("XTPMOV1,XTPMOV2,CARQIND,CFILTRO,CCHAVE,NINDSD2")
SetPrvt("XQTDPRO,XVRTOTAL,XVRICM,XTOTGER,XGERICM,XNUMVEZ")
SetPrvt("XTOTALZAO,XQTDDEV,XTIPO,XFORNEPAD,XGRUPO,XTPCLIENTE")
SetPrvt("XCIDADE,XVEND1,XVEND2,XCOND,XVENCTO,XCOTACAO")
SetPrvt("XCLIENTE,XLOJA,XEMISSAO,XDOC,XSERIE,XUN")
SetPrvt("XQUANT,XFIL,XVRUNIT,XTOTAL,XVALICM,XNOMVEN1")
SetPrvt("XNOMVEN2,XNOMCLI,XDESCPRO,XCODIGO,XEMBAL,")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RComsc  ³ Autor ³ Nycksion Cavalcante    ³ Data ³ 21/06/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao SC's Valorizada                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//³ Define Variaveis Ambientais                                           ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//³ Variaveis utilizadas para parametros                                  ³±±
//³ mv_par01             // Da  Emissao                                   ³±±
//³ mv_par02             // At‚ a Emissao                                 ³±±
//³ mv_par03             // Da  Sol Compra                                ³±±
//³ mv_par04             // Até Sol Compra                                ³±±
//³ mv_par05             // Do Produto                                    ³±±
//³ mv_par06             // Ate o Produto                                 ³±±
//³ mv_par07             // Do Tp                                         ³±±
//³ mv_par08             // Até Tp                                        ³±±
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÙ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

CbTxt       := ""
CbCont      := ""
nOrdem      := 0
Alfa        := 0
Z           := 0
M           := 0
tamanho     := "G"
limite      := 220
titulo      := PADC("Solicitação de Compras Valorizada",74)
cDesc1      := PADC("Este programa ira emitir Solicitação de Compras Valorizada",74)
cDesc2      := ""
cDesc3      := PADC("Solicitação de Compras Valorizada",74)
cNatureza   := ""
aReturn     := { "Especial", 1,"Compras", 1, 2, 1,"",1 }
nomeprog    := "RCOMSC"
cPerg       := "PERGVIT313"
nLastKey    := 0
lContinua   := .T.
nLin        := 0
wNRel       := "RCOMSC"+Alltrim(cusername)
//                      10        20         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        10        20          
//             01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1      :="Nr S C  Item  Produto  Descrição                                 Tp  Grupo  Est Disp  Cons Médio  Qtd Sol  UM  Emissão  Necessidade  Vl Unit  Vl Total"
//cabec1      :="Produto  Grupo Descricao           Data      NF     Ser MFat Vendedor                 Pedido  Cliente Nome do Cliente                  Cidade              UN     Quant             Valor Unit  Valor Total   CP  Vencto"  
cabec2      :=" "                                                                                                                                                                                                                              
Larg        :="G"
M_Pag       := 1
Nr_Folha    := 1
Cab         := .T.
aOrd        := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_pergsx1()
Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SC1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.) 
wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.)
//,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
   Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³ Inicio do Processamento                                      ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

xCOD_EMP := SM0->M0_CODIGO
xCONT    := 0

/*If MV_PAR13 == 1
   xMd      := 1
Elseif MV_PAR13 == 2
   xMd      := 4
Else
   xMd      := 0
Endif*/


RptStatus({|| RptDetail()})

Return( NIL )
                           
Static Function RptDetail()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Query                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := "SELECT SC1010.C1_NUM, SC1010.C1_ITEM, SC1010.C1_PRODUTO, SC1010.C1_DESCRI, SB1010.B1_TIPO, SB1010.B1_GRUPO, SB2010.B2_QATU, SC1010.C1_QUANT, SC1010.C1_UM, SC1010.C1_EMISSAO, SC1010.C1_VUNIT "
cQuery += "FROM SC1"+SM0->M0_CODIGO+"0" + ", SB1"+SM0->M0_CODIGO+"0" + ", SB2"+SM0->M0_CODIGO+"0 "
cQuery += "WHERE SC1010.D_E_L_E_T_ <> '*' AND " + ;
	   	"SC1010.C1_EMISSAO >= '"+DTOS(MV_PAR01)+"' AND " +;
	   	"SC1010.C1_EMISSAO <= '"+DTOS(MV_PAR02)+"' AND " +;
	   	"SC1010.C1_NUM >= '"+MV_PAR03+"' AND " +;
	   	"SC1010.C1_NUM <= '"+MV_PAR04+"' AND " +;
	   	"SC1010.C1_PRODUTO >= '"+MV_PAR05+"' AND " +;
	   	"SC1010.C1_PRODUTO <= '"+MV_PAR06+"' AND " +;
	   	"SB1010.B1_TIPO >= '"+MV_PAR07+"' AND " +;
	   	"SB1010.B1_TIPO <= '"+MV_PAR08 + "' "


/*cSELECT:= 	"SC1010.C1_NUM, SC1010.C1_ITEM, SC1010.C1_PRODUTO, SC1010.C1_DESCR, SB1010.B1_TIPO, SB1010.B1_GRUPO, SB2010.B2_QATU, SC1010.1_QUANT, SC1010.C1_UM, SC1010.C1_EMISSAO, SC1010.C1_VUNIT "
	
cFROM  := 	"SC1"+SM0->M0_CODIGO+"0" + ", SB1"+SM0->M0_CODIGO+"0" + ", SB2"+SM0->M0_CODIGO+"0 "
cWHERE := 	"D_E_L_E_T_ <> '*' AND " + ;
 		   	"SC1010C1_EMISSAO >= '"+DTOS(MV_PAR01)+"' AND " +;
 		   	"SC1010C1_EMISSAO <= '"+DTOS(MV_PAR02)+"' AND " +;
 		   	"SC1010C1_NUM >= '"+MV_PAR03+"' AND " +;
 		   	"SC1010C1_NUM <= '"+MV_PAR04+"' AND " +;
 		   	"SC1010C1_PRODUTO >= '"+MV_PAR05+"' AND " +;
 		   	"SC1010C1_PRODUTO <= '"+MV_PAR06+"' AND " +;
 		   	"SB1010B1_TIPO >= '"+MV_PAR07+"' AND " +;
		   	"SB1010B1_TIPO <= '"+MV_PAR08 + "' "
cOrder:=    "C1_NUM "*/

/*IF MV_PAR18 == "S"
   cOrder := "D2_CLIENTE, "+cOrder
ENDIF*/
 	
//cQuery := 	"SELECT "+cSELECT+" FROM "+cFROM+" WHERE "+cWHERE+" ORDER BY "+cOrder

TCQUERY cQuery NEW ALIAS "QC1"

dbSelectArea("QC1")
nRecs:=0
DBEVAL({|| nRecs:=nRecs+1})
SetRegua(nRecs)
dbGotop()


nLin     := 62
xSCNum  := 0
xSCItem := 0
xSCPrd  := 0
xSCDesc := 0
xSCTp   := 0
xSCGrp  := 0
xSCQAtu := 0
xSCQuant:= 0
xSCUnMed:= 0
xSCEmiss:= 0
xSCVlUnt:= 0
xSCVlTot:= 0
xSCVlTGr:= 0

SETPRC(0,0)

xTotDia := 0

While !Eof()

   IncRegua()
	xQtdDev := 0

	xSCNum  = C1_NUM
	xSCItem = C1_ITEM
	xSCPrd  = C1_PRODUTO
	xSCDesc = C1_DESCRI
	xSCTp   = B1_TIPO
	xSCGrp  = B1_GRUPO
	xSCQAtu = B2_QATU
	xSCQuant= C1_QUANT
	xSCUnMed= C1_UM
	xSCEmiss= C1_EMISSAO
	xSCVlUnt= C1_VUNIT
	
	@ nlin, 000 PSAY xSCNum
	@ nlin, 008 PSAY xSCItem
	@ nlin, 014 PSAY xSCPrd
	@ nlin, 023 PSAY xSCDesc
	@ nlin, 065 PSAY xSCTp
	@ nlin, 069 PSAY xSCGrp
	@ nlin, 076 PSAY xSCQAtu
	@ nlin, 098 PSAY xSCQuant
	@ nlin, 107 PSAY xSCUnMed
	@ nlin, 111 PSAY xSCEmiss
	@ nlin, 133 PSAY xSCVlUnt Picture "@E 9,999,999.99"
	xSCVlTot = C1_VLUNIT * C1_QUANT
	@ nLin, 142 PSAY xSCVlTot Picture "@E 9,999,999.99"
	nlin = nLin + 1
	
	xTotDia = xTotDia + (C1_VUNIT*C1_QUANT)
   xTotGeral = xTotGeral + xTotDia
	xDtEmissao = C1_EMISSAO
	
	dbSkip() 
	
	If xDtEmissao <> C1_EMISSAO
		@ nLin, 000 PSAY "T O T A L -------------------------->"
		@ nLin, 142 PSAY xTotDia Picture "@E 9,999,999.99"
	EndIf
	
Enddo
  
@ nLin, 000 PSAY "Total GERAL===================================>"
@ nLin, 192 PSAY xTotGeral            Picture "@E 9999,999,999.99"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                      FIM DA IMPRESSAO                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


@ 001 , 001 PSAY chr(18)                   // Descompressao de Impressao

Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbCommitAll()
   OurSpool(wnrel)
EndIf

dbCloseArea("QC1")
DbSelectArea("SC1") 

MS_FLUSH()

Return
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim do Programa                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                   FUNCOES ESPECIFICAS                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CABECALHO ³ Autor ³  Cavalcante     ³ Data ³ 20/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Cabe‡alho do Relat¢rio                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FAT1010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 05/12/00 ==> Function HEL
Static Function HEL()


nLin := nLin+1
If nLin > 61
   Cabec(Titulo,cabec1,cabec2,nomeprog,Larg)
   nLin:=8
Endif

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RODAPE    ³ Autor ³ Nycksion Cavalcante  ³ Data ³ 20/02/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Rodape do Relat¢rio                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ProXareA                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Substituido pelo assistente de conversao do AP5 IDE em 05/12/00 ==> Function RODAPE
Static Function RODAP()

@ 059 , 001 PSAY Replicate("*",220)
@ 060 , 001 PSAY "TECNOLOGIA DA INFORMACAO" + SPACE(107) + "RDMAKE - RComsc"
@ 061 , 001 PSAY Replicate("*",220)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


static function STOD(dDat)
xRet:=CTOD(SUBSTR(dDat,7,2)+"/"+SUBSTR(dDat,5,2)+"/"+SUBSTR(dDat,1,4))
return(xret)

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da emissao                   ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a emissao                ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da sol. compra               ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC1"})
aadd(_agrpsx1,{cperg,"04","Ate a sol. compra            ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC1"})
aadd(_agrpsx1,{cperg,"05","Do produto                   ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"06","Ate o produto                ?","mv_ch6","C",06,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"07","Do tp produto                ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"08","Ate tp produto               ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})

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
return()

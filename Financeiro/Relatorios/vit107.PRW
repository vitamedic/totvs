#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 08/02/02
#INCLUDE "TOPCONN.CH"

User Function VIT107()        // incluido pelo assistente de conversao do AP6 IDE em 08/02/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CTEST,TAMANHO,NHORA,LIMITE,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CBCONT,CBTXT,NORDEM,CSTRING")
SetPrvt("NOMEPROG,ALINHA,M_PAG,LTEST,WNREL,NSUPTIT")
SetPrvt("NSUPDES,NSUPREC,NCORTIT,NCORDES,NCORREC,NTOTTIT")
SetPrvt("NTOTDES,NTOTREC,ARETURN,CPERG,MV_PAR01,MV_PAR02")
SetPrvt("MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,MV_PAR08")
SetPrvt("MV_PAR09,MV_PAR10,MV_PAR11,MV_PAR12,MV_PAR13,MV_PAR14")
SetPrvt("LI,CCODVEND,NVALDESC,NVALREC,CTITREL,CQUERY")
SetPrvt("ACAMPOS,CNOMEARQ,CVEND1,DDATA,_AGRPSX1,_I")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/02/02 ==> #INCLUDE "TOPCONN.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
ÛÛ³Programa ³  VIT107   ³Autor ³Gardenia Ilany        ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Relatorio de Titulos a Receber no Periodo                  ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan - SigaFin Versao 4.07 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


cTest    := 1
Tamanho  := "M"
nHora    := Time()
Limite   := 132
Titulo   := "Relacao de Baixas"
cDesc1   := "Este programa ira emitir o relatorio de titulos baixados de "
cDesc2   := "acordo com os parametros"
cDesc3   := ""
cbCont   := 0
cbTxt    := ""
nOrdem   := ""
cString  := "SE1"
NomeProg := "VIT107"
aLinha   := {}
m_pag    := 0
lTest    := .T.
wnRel    := "VIT107"+Alltrim(cusername)
nSupTit  := 0
nSupDes  := 0
nSupRec  := 0
nCorTit  := 0
nCorDes  := 0
nCorRec  := 0
nTotTit  := 0
nTotDes  := 0
nTotRec  := 0
aReturn  := {"Zebrado",1,"administracao",1,2,1,"",0}
cPerg    := "PERGVIT107"

_pergsx1()
pergunte(cperg,.f.)

WnRel:=SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)
If nLastkey == 27 .Or. LastKey() == 27
  Set Filter To
  Return
EndIf
SetDefault(aReturn,cString)
rptStatus({||Imptit2()})// Substituido pelo assistente de conversao do AP6 IDE em 08/02/02 ==> rptStatus({||Execute(Imptit2)})
Return
/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPTIT2   ³Autor ³Gardenia Ilany           ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ vitapan     - Sigafin Versao 4.07 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao dos Titulos do Contas a Receber                     ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/02/02 ==> Function ImpTit2
Static Function ImpTit2()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01  := Do Banco           C  03   ³
//³mv_par02  := Ate Banco          C  03   ³
//³mv_par03  := Da Emissao         D  08   ³
//³mv_par04  := Ate Emissao        D  08   ³
//³mv_par05  := Do Vencimento      D  08   ³
//³mv_par06  := Ate Vencimento     D  08   ³
//³mv_par07  := Do Cliente         C  06   ³
//³mv_par08  := Da Loja            C  02   ³
//³mv_par09  := Ate Cliente        C  06   ³
//³mv_par10  := Ate Loja           C  02   ³
//³mv_par11  := Do Representante   C  06   ³
//³mv_par12  := Ate Representante  C  06   ³
//³mv_par13  := Da Natureza        C  02   ³
//³mv_par14  := Ate Natureza       C  02   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn[8]
SeleArq()
CriaArq()
dbSelectArea("TRA")
dbGoTop()
If Eof()
  lTest := .F.
EndIf
SetRegua(RecCount())
@ 00,00 PSAY AvalImp(Limite)
ImpCabec()
_valorger:=0
_recebger:=0
_descger:=0
_jurosger:=0
_comisger:=0
_saldoger:=0
Do While !Eof() .And. lTest == .T.
  if mv_par15 = 2
	  @ li,000 PSAY "Gerente Regional:"
  elseif mv_par15 = 3
	  @ li,000 PSAY "Diretor Comercial:"  
  else
	  @ li,000 PSAY "Representante :"  
  endif
  @ li,017 PSAY Alltrim(TRA->E1_VEND1)+"-"+Alltrim(TRA->E1_NOMEVE)
  li := li + 1
  cCodVend := TRA->E1_VEND1
  _valorrep:=0
  _recebrep:=0
  _descrep:=0
  _jurosrep:=0
  _comisrep:=0
  _saldorep:=0
  Do While cCodVend == TRA->E1_VEND1 .And. !Eof()
    IncRegua()                              
    _valorcli:=0
    _recebcli:=0
    _desccli:=0
    _juroscli:=0
    _comiscli:=0
    _saldocli:=0
 	 _cCodCli := TRA->E1_CLIENTE
    li := li + 1
  	 @ li,000 PSAY TRA->E1_CLIENTE Picture "999999"
    @ li,010 PSAY TRA->E1_NOMCLI Picture "@!"
    @ li,053 PSAY TRA->E1_TELCLI Picture "@!"
    li := li + 1
	 Do While cCodVend == TRA->E1_VEND1 .And. _cCodCli == TRA->E1_CLIENTE .and. !Eof()
//XXX-999999 X XX  99/99/99 99/99/99 9,999,999.99 999 9,999,999.99 9,999,999.99 9,999,999.99 99/99/99 9,999,999.99 9,999,999.99
//Numero    +P+Tp  Emissao  Vencto        Vlr.Tit.Bco     Vlr.Pago    Pago Tit.    Pago Jrs. Baixa        Vl.Desc.    A Receber" 
       @ li,000 PSAY TRA->E1_PREFIXO+"-"+TRA->E1_NUM+"-"+TRA->E1_PARCELA+"-"+TRA->E1_TIPO
	    @ li,018 PSAY DtoC(TRA->E1_EMISSAO)
	    @ li,027 PSAY DtoC(TRA->E1_VENCTO)
	    @ li,036 PSAY TRA->E1_VALOR Picture "@E 9,999,999.99"
	    @ li,049 PSAY TRA->E1_PORTADO  
	    @ li,053 PSAY TRA->E1_VALLIQ Picture "@E 9,999,999.99"
       @ li,066 PSAY TRA->E1_VALLIQ-TRA->E1_JUROS picture "@E 9,999,999.99"
       @ li,079 PSAY TRA->E1_JUROS picture "@E 9,999,999.99"
       @ li,092 PSAY TRA->E1_BAIXA
       @ li,101 PSAY TRA->E1_DESCONT picture "@E 9,999,999.99"
	    @ li,114 PSAY TRA->E1_SALDO Picture "@E 9,999,999.99"
	    _valorcli+=TRA->E1_VALOR
	    _recebcli+=TRA->E1_VALLIQ
	    _comiscli+=TRA->E1_VALLIQ-TRA->E1_JUROS
	    _juroscli+=TRA->E1_JUROS
	    _desccli+=TRA->E1_DESCONT
	    _saldocli+=TRA->E1_SALDO

	    _valorrep+=TRA->E1_VALOR
	    _recebrep+=TRA->E1_VALLIQ
	    _comisrep+=TRA->E1_VALLIQ-TRA->E1_JUROS
	    _jurosrep+=TRA->E1_JUROS
	    _descrep+=TRA->E1_DESCONT
	    _saldorep+=TRA->E1_SALDO
	             
	    _valorger+=TRA->E1_VALOR
	    _recebger+=TRA->E1_VALLIQ
	    _comisger+=TRA->E1_VALLIQ-TRA->E1_JUROS
	    _jurosger+=TRA->E1_JUROS
	    _descger+=TRA->E1_DESCONT
	    _saldoger+=TRA->E1_SALDO
	
	    li := li + 1
	    If li >= 58
	      ImpCabec()
	      @ li,000 PSAY Replicate("-",132)
	      li := li + 1
	    EndIf
	    dbSelectArea("TRA")
	    dbSkip()
	    If Eof()
	      Exit
	    EndIf
	 enddo                            
    @ li,000 PSAY "Total Cliente -->"
    @ li,036 PSAY _valorcli Picture "@E 9,999,999.99"
    @ li,053 PSAY _recebcli Picture "@E 9,999,999.99"
    @ li,066 PSAY _comiscli Picture "@E 9,999,999.99"
    @ li,079 PSAY _juroscli Picture "@E 9,999,999.99"
    @ li,101 PSAY _desccli Picture "@E 9,999,999.99"
    @ li,114 PSAY _saldocli Picture "@E 9,999,999.99"
    li := li + 1
  EndDo
  if mv_par15 = 2
	  @ li,000 PSAY "Total Ger.Regional ->"
  elseif mv_par15 = 3
	  @ li,000 PSAY "Total Diretoria ->"
  else
	  @ li,000 PSAY "Total Representante ->"
  endif	  
  @ li,036 PSAY _valorrep Picture "@E 9,999,999.99"
  @ li,053 PSAY _recebrep Picture "@E 9,999,999.99"
  @ li,066 PSAY _comisrep Picture "@E 9,999,999.99"
  @ li,079 PSAY _jurosrep Picture "@E 9,999,999.99"
  @ li,101 PSAY _descrep Picture "@E 9,999,999.99"
  @ li,114 PSAY _saldorep Picture "@E 9,999,999.99"
  li := li + 2
  nTotTit := nTotTit + nSupTit
  nTotDes := nTotDes + nSupDes
  nTotRec := nTotRec + nSupRec
  nSupTit := 0
  nSupDes := 0
  nSupRec := 0
//  ImpCabec()
EndDo
//ImpRodape()
//eject
dbSelectArea("TRA")
dbCloseArea("TRA")
dbSelectArea("TRA1")
dbCloseArea("TRA1")
Set Device To Screen
If aReturn[5] == 1
  Set Printer To
  dbCommitAll()
  OurSpool(wnRel)
EndIf
ms_Flush()
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPCABEC  ³Autor ³Gardenia Ilany           ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitapan - Sigafin Versao 4.07 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Cabecalho Do Relatorio                           ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/02/02 ==> Function ImpCabec
Static Function ImpCabec()
cTitRel := "Por Ordem de Representante+Cliente+Vencimento"
m_Pag := m_Pag + 1
@ 00,000 PSAY Replicate("*",132)
@ 01,000 PSAY Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)
@ 01,059 PSAY "Relacao de Baixas"
@ 01,113 PSAY "Folha...:"
@ 01,128 PSAY StrZero(m_Pag,3)
@ 02,000 PSAY "C.I./VIT107/v.4.07"
@ 02,056 PSAY "Emissoes Entre "+DtoC(mv_par03)+" e "+DtoC(mv_par04)
@ 02,113 PSAY "DT. Ref.: "+DtoC(dDataBase)
@ 03,000 PSAY "Hora...: "+ SubStr(nHora,1,8)
@ 03,028 PSAY PadC(cTitRel,84)
@ 03,113 PSAY "Emissao.: "+DtoC(Date())
@ 04,000 PSAY Replicate("-",132)
//                       10        20        30        40        50        60        70        80        90        100       110       120       130
//             0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
@ 05,000 PSAY "Codigo    Nome Cliente                                  Telefone"
@ 06,000 PSAY "Numero    +P+Tp  Emissao  Vencto        Vlr.Tit.Bco     Vlr.Pago    Pago Tit.    Pago Jrs. Baixa        Vl.Desc.    A Receber" 
//Codigo     Nome Cliente           
//Numero    +P+Tp  Emissao  Vencto        Vlr.Tit.Bco     Vlr.Pago    Pago Tit.        Juros Baixa        Vl.Desc.    A Receber 
//XXX-999999 X XX  99/99/99 99/99/99 9,999,999.99 999 9,999,999.99 9,999,999.99 9,999,999.99 99/99/99 9,999,999.99 9,999,999.99

@ 07,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
li := 08
dbSelectArea("TRA")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPRODAPE ³Autor ³Gardenia Ilany           ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitapan - Sigafin Versao 4.07 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Rodape do Relatorio                              ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpRodape()
@ li,000 PSAY Replicate("-",132)
li := li + 1
@ li,000 PSAY "T O T A L  G E R A L -->"
@ li,036 PSAY _valorger Picture "@E 9,999,999.99"
@ li,053 PSAY _recebger Picture "@E 9,999,999.99"
@ li,066 PSAY _comisger Picture "@E 9,999,999.99"
@ li,079 PSAY _jurosger Picture "@E 9,999,999.99"
@ li,101 PSAY _descger Picture "@E 9,999,999.99"
@ li,114 PSAY _saldoger Picture "@E 9,999,999.99"
li := li + 1
@ li,000 PSAY Replicate("-",132)
li := li + 1
//@ li,000 PSAY "O C.I. Faz Parte da Sua Solucao"
@ li,109 PSAY "Hora Termino.:"+SubStr(Time(),1,8)
//li := li + 1
//@ li,000 PSAY Replicate("*",132)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ SELEARQ   ³Autor ³Gardenia Ilany   ³ Data ³ 10/07/2000 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitapan - Sigafin Versao 4.07 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Selecao de dados para o relatorio                             ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/02/02 ==> Function SeleArq
Static Function SeleArq()          

cQuery:=" SELECT *"
cQuery+=" FROM "
cQuery+=  RetSqlName("SE1")+" SE1"
cQuery+=" WHERE "
cQuery+="     SE1.D_E_L_E_T_ <> '*'"
cQuery+=" AND E1_PREFIXO <> '1  '"
//cQuery := cQuery + ' AND E1_STATUS  =  "B" '
cQuery+=" AND E1_TIPO NOT IN ('RA ','AB-','NCC')"
cQuery+=" AND E1_FILIAL = '"+xFilial("SE1")+"'"
cQuery+=" AND E1_PORTADO >= '"+mv_par01+"'"
cQuery+=" AND E1_PORTADO <= '"+mv_par02+"'"
cQuery+=" AND E1_EMISSAO >= '"+DtoS(mv_par03)+"'"
cQuery+=" AND E1_EMISSAO <= '"+DtoS(mv_par04)+"'"
cQuery+=" AND E1_BAIXA >= '"+DtoS(mv_par05)+"'"
cQuery+=" AND E1_BAIXA <= '"+DtoS(mv_par06)+"'"
cQuery+=" AND E1_CLIENTE >= '"+mv_par07+"'"
cQuery+=" AND E1_LOJA >= '"+mv_par08+"'"
cQuery+=" AND E1_CLIENTE <= '"+mv_par09+"'"
cQuery+=" AND E1_LOJA <= '"+mv_par10+"'"
cQuery+=" AND E1_VEND"+alltrim(str(mv_par15,1))+" BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
cQuery+=" AND E1_NATUREZ >= '"+mv_par13+"'"
cQuery+=" AND E1_NATUREZ <= '"+mv_par14+"'"
if mv_par15= 2
	cQuery+=" ORDER BY E1_VEND2,E1_CLIENTE,E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"
elseif mv_par15= 3
	cQuery+=" ORDER BY E1_VEND3,E1_CLIENTE,E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"
else
	cQuery+=" ORDER BY E1_VEND1,E1_CLIENTE,E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"
endif
TCQuery cQuery NEW ALIAS "TRA1"
//cQuery := cQuery + ' AND E1_VEND1    >= "'+mv_par11+'"'
//cQuery := cQuery + ' AND E1_VEND1    <= "'+mv_par12+'"'
dbSelectArea("TRA1")
dbGoTop()
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ CRIAARQ   ³Autor ³Gardenia Ilany   ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitapan - Sigafin Versao 4.07 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Cria o Arquivo que recebera os dados para impressao.          ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/02/02 ==> Function CriaArq
Static Function CriaArq()
aCampos := {}
AADD(aCampos,{"E1_PORTADO" ,"C", 03,0})
AADD(aCampos,{"E1_PREFIXO" ,"C", 03,0})
AADD(aCampos,{"E1_NUM"     ,"C", 06,0})
AADD(aCampos,{"E1_PARCELA" ,"C", 01,0})
AADD(aCampos,{"E1_TIPO"    ,"C", 03,0})
AADD(aCampos,{"E1_EMISSAO" ,"D", 08,0})
AADD(aCampos,{"E1_VENCTO" ,"D", 08,0})
AADD(aCampos,{"E1_BAIXA"   ,"D", 08,0})
AADD(aCampos,{"E1_CLIENTE" ,"C", 06,0})
AADD(aCampos,{"E1_LOJA"    ,"C", 02,0})
AADD(aCampos,{"E1_NOMCLI"  ,"C", 40,0})
AADD(aCampos,{"E1_TELCLI"  ,"C", 15,0})
AADD(aCampos,{"E1_VALOR"   ,"N", 17,2})
AADD(aCampos,{"E1_VALLIQ"  ,"N", 17,2})
AADD(aCampos,{"E1_DESCONT" ,"N", 17,2})
AADD(aCampos,{"E1_SALDO"   ,"N", 17,2})
AADD(aCampos,{"E1_JUROS"   ,"N", 17,2})
/*if mv_par15 = 2
	AADD(aCampos,{"E1_VEND2"   ,"C", 06,0})
elseif mv_par15 = 3                                    
	AADD(aCampos,{"E1_VEND3"   ,"C", 06,0})
else                                      */
AADD(aCampos,{"E1_VEND1"   ,"C", 06,0})
AADD(aCampos,{"E1_NOMEVE"  ,"C", 40,0})
AADD(aCampos,{"E1_CODCOR"  ,"C", 06,0})
AADD(aCampos,{"E1_NOMCOR"  ,"C", 40,0})
cNomeArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cNomearq,"TRA",.T.,.F.)
dbSelectArea("TRA")
Index On TRA->E1_VEND1+TRA->E1_NOMCLI+DTOS(TRA->E1_VENCTO)+TRA->E1_PREFIXO+TRA->E1_NUM+TRA->E1_PARCELA To &cNomeArq
dbSelectArea("TRA1")
dbGoTop()
Do While !Eof()
  dbSelectArea("SA1")
  dbSetOrder(1)
  dbSeek(xFilial("SA1")+TRA1->E1_CLIENTE+TRA1->E1_LOJA)
  dbSelectArea("SD2")
  dbSetOrder(3)
  dbSeek(xFilial("SD2")+TRA1->E1_NUM+TRA1->E1_PREFIXO)
  dbSelectArea("SC5")
  dbSetOrder(1)
  dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
  dbSelectArea("SA3")
  dbSetOrder(1)
  dbSeek(xFilial("SA3")+TRA1->E1_VEND1)
  cVend1 := SA3->A3_NOME
  dbSelectArea("TRA")
  RecLock("TRA",.T.)
  if mv_par15= 2
    TRA->E1_VEND1  := TRA1->E1_VEND2
	  dbSelectArea("SA3")
	  dbSetOrder(1)
	  dbSeek(xFilial("SA3")+TRA1->E1_VEND2)
	  cVend1 := SA3->A3_NOME   
  elseif mv_par15= 3
    TRA->E1_VEND1   := TRA1->E1_VEND3
	  dbSelectArea("SA3")
	  dbSetOrder(1)
	  dbSeek(xFilial("SA3")+TRA1->E1_VEND3)
	  cVend1 := SA3->A3_NOME    
  else  
    TRA->E1_VEND1   := TRA1->E1_VEND1
	  dbSelectArea("SA3")
	  dbSetOrder(1)
	  dbSeek(xFilial("SA3")+TRA1->E1_VEND1)
	  cVend1 := SA3->A3_NOME    
  endif
    TRA->E1_NOMEVE  := cVend1
    TRA->E1_PORTADO := TRA1->E1_PORTADO
    TRA->E1_PREFIXO := TRA1->E1_PREFIXO
    TRA->E1_NUM     := TRA1->E1_NUM
    TRA->E1_PARCELA := TRA1->E1_PARCELA
    TRA->E1_TIPO    := TRA1->E1_TIPO
//    TRA->E1_PECDESC := TRA1->E1_DESCFIN
    TRA->E1_DESCONT := TRA1->E1_DESCONT
        dData := CtoD(SubStr(TRA1->E1_EMISSAO,7,2)+"/"+SubStr(TRA1->E1_EMISSAO,5,2)+"/"+SubStr(TRA1->E1_EMISSAO,3,2))
    TRA->E1_EMISSAO := dData
    dData := CtoD(SubStr(TRA1->E1_VENCTO,7,2)+"/"+SubStr(TRA1->E1_VENCTO,5,2)+"/"+SubStr(TRA1->E1_VENCTO,3,2))
    TRA->E1_VENCTO := dData
    TRA->E1_CLIENTE := TRA1->E1_CLIENTE
    TRA->E1_LOJA    := TRA1->E1_LOJA
    TRA->E1_NOMCLI  := SA1->A1_NOME
    TRA->E1_TELCLI  := alltrim(sa1->a1_ddd)+" "+alltrim(SA1->A1_TEL)
    TRA->E1_VALOR   := TRA1->E1_VALOR
    TRA->E1_SALDO   := TRA1->E1_SALDO
    TRA->E1_JUROS   := TRA1->E1_JUROS
    TRA->E1_VALLIQ  := TRA1->E1_VALLIQ
    TRA->E1_DESCONT := TRA1->E1_DESCONT
    dData := CtoD(SubStr(TRA1->E1_BAIXA,7,2)+"/"+SubStr(TRA1->E1_BAIXA,5,2)+"/"+SubStr(TRA1->E1_BAIXA,3,2))
    TRA->E1_BAIXA   := dData
  msUnLock()
  dbSelectArea("TRA1")
  dbSkip()
EndDo
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01  := Do Banco           C  03   ³
//³mv_par02  := Ate Banco          C  03   ³
//³mv_par03  := Da Emissao         D  08   ³
//³mv_par04  := Ate Emissao        D  08   ³
//³mv_par05  := Do Vencimento      D  08   ³
//³mv_par06  := Ate Vencimento     D  08   ³
//³mv_par07  := Do Cliente         C  06   ³
//³mv_par08  := Da Loja            C  02   ³
//³mv_par09  := Ate Cliente        C  06   ³
//³mv_par10  := Ate Loja           C  02   ³
//³mv_par11  := Do Representante   C  06   ³
//³mv_par12  := Ate Representante  C  06   ³
//³mv_par13  := Da Natureza        C  02   ³
//³mv_par14  := Ate Natureza       C  02   ³




// Substituido pelo assistente de conversao do AP6 IDE em 08/02/02 ==> static function _pergsx1()

Static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Banco           ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA6"})
aadd(_agrpsx1,{cperg,"02","Ate o Banco        ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA6"})
aadd(_agrpsx1,{cperg,"03","Da Emissao         ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a Emissao      ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da Baixa           ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate a Baixa        ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do Cliente         ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"08","Da Loja            ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Ate o Cliente      ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"10","Ate a Loja         ?","mv_ch10","C",02,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Do Representante   ?","mv_ch11","C",06,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"12","Ate o Representante?","mv_ch12","C",06,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"13","Da Natureza        ?","mv_ch13","C",10,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SED"})
aadd(_agrpsx1,{cperg,"14","Ate a Natureza     ?","mv_ch14","C",10,0,0,"G",space(60),"mv_par14"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SED"})
aadd(_agrpsx1,{cperg,"15","Considera vendedor ?","mv_ch15","N",01,0,0,"C",space(60),"mv_par15"       ,"Vendedor 1"     ,space(30),space(15),"Vendedor 2"     ,space(30),space(15),"Vendedor 3"     ,space(30),space(15),"Vendedor 4"     ,space(30),space(15),"Vendedor 5"     ,space(30),"   "})

	
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


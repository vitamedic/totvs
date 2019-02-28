/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
ÛÛ³Programa  ³  VIT026   ³Autor ³Gardenia Ilany       ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Relatorio de Titulos a Receber no Periodo                  ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan - SigaFin Versao 6.09 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

User Function vit026()

cTest    := 1
Tamanho  := "M"
nHora    := Time()
Limite   := 132
Titulo   := "Titulos Vencidos e a Receber"
cDesc1   := "Este programa ira emitir o relatorio de titulos a Receber de "
cDesc2   := "Acordo com os parametros"
cDesc3   := ""
cbCont   := 0
cbTxt    := ""
nOrdem   := ""
cString  := "SE1"
NomeProg := "VIT026"
aLinha   := {}
m_pag    := 0
lTest    := .T.
wnRel    := "VIT026"+Alltrim(cusername)
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
cPerg    := "PERGVIT026"
li       := 0

_pergsx1()
pergunte(cperg,.f.)

wnrel:=SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)
if nLastkey == 27 .Or. LastKey() == 27
	set filter to
	return
endif
setdefault(aReturn,cString)
rptstatus({||Imptit2()})

return

/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPTIT2   ³Autor ³Gardenia Ilany           ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ vitapan     - Sigafin Versao 6.09 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao dos Titulos do Contas a Receber                     ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpTit2()

nOrdem := aReturn[8]
SeleArq()
CriaArq()

tra->(dbgotop())

if eof()
	lTest := .F.
endif

setregua(reccount())

@ 000,000 psay avalimp(limite)
_ttotrec:=0
_tclirec := 0

while !tra->(eof()) .and. ltest == .t.

	impcabec()
	if mv_par15 = 2
		@ li,000 psay "Gerente Regional:"
	elseif mv_par15 = 3
		@ li,000 psay "Diretor Comercial:"
	else
		@ li,000 psay "Representante :"
	endif
	
	@ li,017 psay alltrim(tra->e1_vend1)+"-"+alltrim(tra->e1_nomeve)
	li++	
	cCodVend := tra->e1_vend1
	_tvendrec:=0

	while cCodVend == tra->e1_vend1 .and. !tra->(eof())
		incregua()
		_cCodCli := tra->e1_cliente
		_nSupTit := 0
		_nSupDes := 0
		_nSupRec := 0
		_tclirec := 0
		li++
		@ li,000 psay tra->e1_cliente Picture "999999"
		@ li,013 psay tra->e1_nomcli Picture "@!"
		@ li,056 psay tra->e1_telcli Picture "@!"
		li++

		while cCodVend == tra->e1_vend1 .and. _cCodCli == tra->e1_cliente .and. !tra->(eof())
			
			@ li,000 psay tra->e1_prefixo+"-"+tra->e1_num+"-"+tra->e1_parcela+"-"+tra->e1_tipo
			@ li,021 psay dtoc(tra->e1_emissao)
			@ li,030 psay dtoc(tra->e1_vencto)
			@ li,039 psay tra->e1_valor Picture "@E 9,999,999.99"

			if tra->e1_situaca=='3'
				@ li,052 psay "CHQ"
			else
				@ li,052 psay tra->e1_portado
			endif

			@ li,056 psay (tra->e1_valor + tra->e1_juros - tra->e1_saldo) picture "@E 9,999,999.99"
			@ li,069 psay (tra->e1_valor - tra->e1_saldo) picture "@E 9,999,999.99"
			@ li,082 psay tra->e1_juros picture "@E 9,999,999.99"
			@ li,095 psay tra->e1_baixa

			if dtos(tra->e1_vencto) < dtos(ddatabase)
				@ li,104 psay tra->e1_descont Picture "@E 9,999,999.99"
				@ li,117 psay tra->e1_saldo Picture "@E 9,999,999.99"
				nValDesc := 0
				nValRec  := tra->e1_saldo
			elseif dtos(tra->e1_vencto) >= dtos(ddatabase)
				if empty(tra->e1_baixa)
					nValDesc := ((tra->e1_valor * tra->e1_pecdesc) / 100)
					@ li,104 psay nvaldesc Picture "@E 9,999,999.99"
					nValRec  := (tra->e1_valor - (( tra->e1_valor * tra->e1_pecdesc) / 100))
					@ li,117 psay nValRec Picture "9,999,999.99"
				else
					@ li,104 psay tra->e1_descont Picture "@E 9,999,999.99"
					@ li,117 psay tra->e1_saldo Picture "@E 9,999,999.99"
					nValDesc := 0
					nValRec  := tra->e1_saldo
				endif
			endif
			nSupTit := nSupTit + tra->e1_valor
			nSupDes := nSupDes + nValDesc
			nSupRec := nSupRec + nValRec
			_nSupTit := _nSupTit + tra->e1_valor
			_nSupDes := _nSupDes + nValDesc
			_nSupRec := _nSupRec + nValRec
			_tclirec += tra->e1_valor + tra->e1_juros - tra->e1_saldo
			_tvendrec += tra->e1_valor + tra->e1_juros - tra->e1_saldo
			_ttotrec += tra->e1_valor + tra->e1_juros - tra->e1_saldo
			li++
			
			if li >= 58
				ImpCabec()
				@ li,000 psay Replicate("-",132)
				li++
			endif

			tra->(dbskip())

			if tra->(eof())
				exit
			endif
		end

		@ li,000 psay "Total Cliente -->"
		@ li,039 psay _nSupTit Picture "@E 9,999,999.99"
		@ li,056 psay _tclirec Picture "@E 9,999,999.99"
		@ li,104 psay _nSupDes Picture "@E 9,999,999.99"
		@ li,117 psay _nSupRec Picture "@E 9,999,999.99"
		li++
	end

	if mv_par15 = 2
		@ li,000 psay "Total Ger.Regional ->"
	elseif mv_par15 = 3
		@ li,000 psay "Total Diretoria ->"
	else
		@ li,000 psay "Total Representante ->"
	endif
	@ li,039 psay nSupTit Picture  "@E 999,999,999.99"
	@ li,056 psay _tclirec Picture "@E 9,999,999.99"
	@ li,104 psay nSupDes Picture  "@E 9,999,999.99"
	@ li,117 psay nSupRec Picture  "@E 999,999,999.99"
	li := li + 2
	nTotTit := nTotTit + nSupTit
	nTotDes := nTotDes + nSupDes
	nTotRec := nTotRec + nSupRec
	nSupTit := 0
	nSupDes := 0
	nSupRec := 0
end

tra->(dbclosearea())
tra1->(dbclosearea())

set device to screen
if areturn[5] == 1
	set printer To
	dbcommitall()
	ourspool(wnrel)
endif
ms_Flush()
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPCABEC  ³Autor ³Gardenia Ilany           ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitapan - Sigafin Versao 6.09 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Cabecalho Do Relatorio                           ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function ImpCabec()

cTitRel := "Por Ordem de Representante+Cliente+Vencimento"
m_Pag := m_Pag + 1
@ 00,000 psay replicate("*",132)
@ 01,000 psay alltrim(sm0->m0_nome)+"/"+alltrim(sm0->m0_filial)
@ 01,059 psay "Relacao Titulos a Receber"
@ 01,113 psay "Folha...:"
@ 01,128 psay strzero(m_Pag,3)
@ 02,000 psay "C.I./vit026/v.6.09"
@ 02,056 psay "Emissoes Entre "+dtoc(mv_par03)+" e "+dtoc(mv_par04)
@ 02,113 psay "DT. Ref.: "+dtoc(dDataBase)
@ 03,000 psay "Hora...: "+ subStr(nHora,1,8)
@ 03,028 psay PadC(cTitRel,84)
@ 03,113 psay "Emissao.: "+dtoc(date())
@ 04,000 psay replicate("-",132)
//                       10        20        30        40        50        60        70        80        90        100       110       120       130
//             0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
@ 05,000 psay "Codigo       Nome Cliente                                  Telefone"
@ 06,000 psay "Numero       +P+Tp  Emissao  Vencto        Vlr.Tit.Bco     Vlr.Pago    Pago Tit.    Pago Jrs. Baixa        Vl.Desc.    A Receber"
//Codigo        Nome Cliente
//Numero       +P+Tp  Emissao  Vencto        Vlr.Tit.Bco     Vlr.Pago    Pago Tit.        Juros Baixa        Vl.Desc.    A Receber
//XXX-999999999 X XX  99/99/99 99/99/99 9,999,999.99 999 9,999,999.99 9,999,999.99 9,999,999.99 99/99/99 9,999,999.99 9,999,999.99

@ 07,000 psay "------------------------------------------------------------------------------------------------------------------------------------"
li := 08
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPRODAPE ³Autor ³Gardenia Ilany           ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitapan - Sigafin Versao 6.09 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Rodape do Relatorio                              ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function ImpRodape()
@ li,000 psay replicate("-",132)
li++
@ li,000 psay "T O T A L  G E R A L -->"
@ li,036 psay nTotTit Picture "@E 9,999,999.99"
@ li,053 psay _tclirec Picture "@E 9,999,999.99"
@ li,101 psay nTotDes Picture "@E 9,999,999.99"
@ li,114 psay nTotRec Picture "@E 9,999,999.99"
li++
@ li,000 psay Replicate("-",132)
li++
@ li,109 psay "Hora Termino.:"+SubStr(Time(),1,8)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ SELEARQ   ³Autor ³Gardenia Ilany   ³ Data ³ 10/07/2000 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitapan - Sigafin Versao 6.09 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Selecao de dados para o relatorio                             ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function SeleArq()
cQuery:=" SELECT * "
cQuery+=" FROM "
cQuery+= RetSqlName("SE1")+" SE1, "
cQuery+= RetSqlName("SA1")+" SA1"
cQuery+=" WHERE"
cQuery+="     SE1.D_E_L_E_T_ = ' '"
cQuery+=" AND SA1.D_E_L_E_T_ = ' '"
cQuery+=" AND E1_FILIAL='"+xFilial("SE1")+"'"
cQuery+=" AND E1_SALDO<>0"
cQuery+=" AND E1_CLIENTE = A1_COD"
cQuery+=" AND E1_LOJA = A1_LOJA"
if !empty(mv_par16)
	cQuery+=" AND A1_EST = '"+mv_par16+"'"
endif
cQuery+=" AND E1_TIPO NOT IN ('RA','AB-','NCC')"
cQuery+=" AND E1_PORTADO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQuery+=" AND E1_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
cQuery+=" AND E1_VENCTO BETWEEN '"+dtos(mv_par05)+"' AND '"+DtoS(mv_par06)+"'"
cQuery+=" AND E1_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par09+"'"
cQuery+=" AND E1_LOJA BETWEEN '"+mv_par08+"' AND '"+mv_par10+"'"
cQuery+=" AND E1_VEND"+alltrim(str(mv_par15,1))+" BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
cQuery+=" AND E1_NATUREZ BETWEEN '"+mv_par13+"' AND '"+mv_par14+"'"
if mv_par15= 2
	cQuery+=" ORDER BY E1_VEND2,E1_CLIENTE,E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"
elseif mv_par15= 3
	cQuery+=" ORDER BY E1_VEND3,E1_CLIENTE,E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"
else
	cQuery+=" ORDER BY E1_VEND1,E1_CLIENTE,E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"
endif

memowrit("/sql/vit026.sql",cQuery)
cquery:=changequery(cquery)
tcquery cquery new alias "TRA1"    

tra1->(dbgotop())
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ CRIAARQ   ³Autor ³Gardenia Ilany   ³ Data ³ 08/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitapan - Sigafin Versao 6.09 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Cria o Arquivo que recebera os dados para impressao.          ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function CriaArq()
aCampos := {}
AADD(aCampos,{"E1_PORTADO" ,"C", 03,0})
AADD(aCampos,{"E1_PREFIXO" ,"C", 03,0})
AADD(aCampos,{"E1_NUM"     ,"C", 09,0})
AADD(aCampos,{"E1_PARCELA" ,"C", 01,0})
AADD(aCampos,{"E1_TIPO"    ,"C", 03,0})
AADD(aCampos,{"E1_EMISSAO" ,"D", 08,0})
AADD(aCampos,{"E1_VENCTO"  ,"D", 08,0})
AADD(aCampos,{"E1_BAIXA"   ,"D", 08,0})
AADD(aCampos,{"E1_CLIENTE" ,"C", 06,0})
AADD(aCampos,{"E1_LOJA"    ,"C", 02,0})
AADD(aCampos,{"E1_NOMCLI"  ,"C", 40,0})
AADD(aCampos,{"E1_TELCLI"  ,"C", 15,0})
AADD(aCampos,{"E1_VALOR"   ,"N", 17,2})
AADD(aCampos,{"E1_DESCONT" ,"N", 17,2})
AADD(aCampos,{"E1_PECDESC" ,"N", 07,3})
AADD(aCampos,{"E1_SALDO"   ,"N", 17,2})
AADD(aCampos,{"E1_JUROS"   ,"N", 17,2})
AADD(aCampos,{"E1_VEND1"   ,"C", 06,0})
AADD(aCampos,{"E1_NOMEVE"  ,"C", 40,0})
AADD(aCampos,{"E1_CODCOR"  ,"C", 06,0})
AADD(aCampos,{"E1_NOMCOR"  ,"C", 40,0})
AADD(aCampos,{"E1_SITUACA" ,"C", 01,0})

cNomeArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cNomearq,"TRA",.T.,.F.)
dbselectarea("TRA")
index on tra->e1_vend1+tra->e1_nomcli+dtos(tra->e1_vencto)+tra->e1_prefixo+tra->e1_num+tra->e1_parcela To &cNomeArq

tra1->(dbgotop())

while !tra1->(eof())

/*	sa1->(dbsetorder(1))
	sa1->(dbSeek(xFilial("SA1")+tra1->e1_cliente+tra1->e1_loja))
*/	
	sd2->(dbsetorder(3))
	sd2->(dbseek(xfilial("SD2")+tra1->e1_num+tra1->e1_prefixo))

	sc5->(dbsetorder(1))
	sc5->(dbseek(xFilial("SC5")+sd2->d2_pedido))

	tra->(recLock("TRA",.T.))
	
		if mv_par15= 2
			tra->e1_vend1  := tra1->e1_vend2
			sa3->(dbsetorder(1))
			sa3->(dbseek(xFilial("SA3")+tra1->e1_vend2))
			cVend1 := sa3->a3_nome

		elseif mv_par15= 3
			tra->e1_vend1   := tra1->e1_vend3
			sa3->(dbsetorder(1))
			sa3->(dbseek(xFilial("SA3")+tra1->e1_vend3))
			cVend1 := sa3->a3_nome
		else
			tra->e1_vend1   := tra1->e1_vend1
			sa3->(dbsetorder(1))
			sa3->(dbseek(xFilial("SA3")+tra1->e1_vend1))
			cVend1 := sa3->a3_nome
		endif
		tra->e1_nomeve  := cVend1
		tra->e1_portado := tra1->e1_portado
		tra->e1_prefixo := tra1->e1_prefixo
		tra->e1_num     := tra1->e1_num
		tra->e1_parcela := tra1->e1_parcela
		tra->e1_tipo    := tra1->e1_tipo
		tra->e1_pecdesc := tra1->e1_descfin
		tra->e1_descont := tra1->e1_descont
		tra->e1_situaca := tra1->e1_situaca
		ddata := ctod(substr(tra1->e1_emissao,7,2)+"/"+substr(tra1->e1_emissao,5,2)+"/"+substr(tra1->e1_emissao,3,2))
		tra->e1_emissao := dData
		ddata := ctod(substr(tra1->e1_vencto,7,2)+"/"+substr(tra1->e1_vencto,5,2)+"/"+substr(tra1->e1_vencto,3,2))
		tra->e1_vencto := dData
		tra->e1_cliente := tra1->e1_cliente
		tra->e1_loja    := tra1->e1_loja
		tra->e1_nomcli  := tra1->a1_nome
		tra->e1_telcli  := alltrim(tra1->a1_ddd)+" "+alltrim(tra1->a1_tel)
		tra->e1_valor   := tra1->e1_valor
		tra->e1_saldo   := tra1->e1_saldo
		tra->e1_juros   := tra1->e1_juros
		ddata := ctod(substr(tra1->e1_baixa,7,2)+"/"+substr(tra1->e1_baixa,5,2)+"/"+substr(tra1->e1_baixa,3,2))
		tra->e1_baixa   := ddata
	
	tra->(msUnLock())
	tra1->(dbskip())
end

return


Static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Banco           ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA6"})
aadd(_agrpsx1,{cperg,"02","Ate o Banco        ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA6"})
aadd(_agrpsx1,{cperg,"03","Da Emissao         ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a Emissao      ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do Vencimento      ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate o Vencimento   ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do Cliente         ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"08","Da Loja            ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Ate o Cliente      ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"10","Ate a Loja         ?","mv_ch10","C",02,0,0,"G",space(60),"mv_par10"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Do Representante   ?","mv_ch11","C",06,0,0,"G",space(60),"mv_par11"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"12","Ate o Representante?","mv_ch12","C",06,0,0,"G",space(60),"mv_par12"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"13","Da Natureza        ?","mv_ch13","C",10,0,0,"G",space(60),"mv_par13"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SED"})
aadd(_agrpsx1,{cperg,"14","Ate a Natureza     ?","mv_ch14","C",10,0,0,"G",space(60),"mv_par14"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SED"})
aadd(_agrpsx1,{cperg,"15","Considera vendedor ?","mv_ch15","N",01,0,0,"C",space(60),"mv_par15"      ,"Vendedor 1"     ,space(30),space(15),"Vendedor 2"     ,space(30),space(15),"Vendedor 3"     ,space(30),space(15),"Vendedor 4"     ,space(30),space(15),"Vendedor 5"     ,space(30),"   "})
aadd(_agrpsx1,{cperg,"16","Filtra Estado      ?","mv_ch16","C",02,0,0,"G",space(60),"mv_par16"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
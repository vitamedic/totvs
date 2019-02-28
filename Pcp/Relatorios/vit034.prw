#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function vit034()


SetPrvt("TAMANHO,NHORA,LIMITE,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,CBCONT,CBTXT,NORDEM,CPERG,CSTRING")
SetPrvt("NOMEPROG,ALINHA,M_PAG,WNREL,NQUANTVAL,NQUJEVAL")
SetPrvt("NQTDVAL,NDIFVAL,NPERVAL,NQUANTTOT,NQUJETOT,NQTDTOT")
SetPrvt("NDIFTOT,NPERTOT,ARETURN,MV_PAR01,MV_PAR02,MV_PAR03")
SetPrvt("MV_PAR04,MV_PAR05,NCONT,NTOTCONT,CPROD,NDIAS")
SetPrvt("NVALLIQ,LI,CQUERY,_CDATA,DDATEMIS,DDATRFIN")
SetPrvt("NPERC,CQUER1,ACAMPOS,CNOMEARQ,_TOTDIAS,_GTOTDIAS, _PTOTDIAS")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa  ³ VIT034   ³Autor ³ GARDENIA ILANY                           ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Relatorio Controle de Lotes e de Produtos Acabados -       ³ÛÛ
ÛÛ³          ³ Acompanhamento de OPs                                      ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic - SigaEst Versao 4.07 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ÛÛ³Alteracoes³ 12/04/06: Inclusão de Totalizador para Dias (Periodo de Fab.) ³ÛÛ
ÛÛ³          ³           e Media Entre Op/Periodo.                           ³ÛÛ
ÛÛ³          ³                                                               ³ÛÛ
ÛÛ³          ³ 18/01/10: Exclusao da Informacoes de Qtde.Vendida, pelo Fato  ³ÛÛ
ÛÛ³          ³           de nao Serem Utilizadas no Relatorio - TRA2.        ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Tamanho    := "M"
nHora      := Time()
Limite     := 132
Titulo     := "Controle de Lotes de Produtos Acabados"
cDesc1     := "Este programa ira emitir o relatorio de Controle de Estoque"
cDesc2     := "dos Produtos Acabados de acordo com os parametros"
cDesc3     := ""
cbCont     := 0
cbTxt      := ""
nOrdem     := ""
cPerg      := "PERGVIT034"
cString    := "SB8"
NomeProg   := "VIT034"
aLinha     := {}
m_Pag      := 0
wnRel      := "VIT034"+Alltrim(cusername)
nQuantVal  := 0
nQujeVal   := 0
nDifVal    := 0
nPerVal    := 0
nQuantTot  := 0
nQujeTot   := 0
nDifTot    := 0
nPerTot    := 0
_totdias   := 0
_media     := 0
aReturn    := {"Zebrado",1,"Administracao",1,2,1,"",0}

_pergsx1()
Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

If nLastkey == 27 .Or. LastKey() == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

ntipo :=if(areturn[4]==1,15,18)

if nlastkey==27
	set filter to
	return
endif

rptStatus({||Imptit2()})
Return
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
ÛÛ³Programa  ³ IMPTIT2   ³Autor ³ GARDENIA ILANY                          ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao dos Produtos Acabados                            ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic - Sigafin Versao 4.07 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ImpTit2()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01  := Do Produto         ³
//³mv_par02  := Ate o Produto      ³
//³mv_par03  := Da Emissao         ³
//³mv_par04  := Ate a Emissao      ³
//³mv_par05  := Emite as Op's      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(Recno())

CriaArq()
SeleTrab()

tra->(dbGoTop())

SetRegua(RecCount())

@ 00,00 PSAY AvalImp(Limite)

ImpCabec()

nCont      := 0
nTotCont   := 0
_gTotCont  := 0
_gQuantTot := 0
_gQujeTot  := 0
_gDifTot   := 0
_gPerTot   := 0
_mgrupo    := " "
_mentiq    := 0
_getiq     := 0
_tetiq     := 0
_gtotdias  := 0
_ptotdias  := 0

While !tra->(Eof())
	cProd := tra->b1_cod
	if tra->b1_grupo<> _mgrupo
		if !empty(_gtotcont)
			li := li + 1
			If li >= 58
				If Eof()
					Exit
				EndIf
				ImpCabec()
			EndIf
			@ prow()+1,000 PSAY "Total "+tabela("V0",_mgrupo+"    ")
			@ prow(),018 PSAY _gtotCont Picture "999"
			@ prow(),038 PSAY _getiq Picture "@E 9999.99"
			@ prow(),049 PSAY _gQuanttot Picture "@E 99,999,999.99"
			@ prow(),063 PSAY _gQujetot  Picture "@E 99,999,999.99"
			@ prow(),106 PSAY _gtotdias   Picture "@E 9,999"
			@ prow(),112 PSAY _gDiftot   Picture "@E 9,999,999.99"
			@ prow(),125 PSAY ((_gQujetot / _gQuanttot)*100)-100 Picture "@E 9999.99"
			
			_tetiq += _getiq
			_getiq     := 0
			_gTotCont  := 0
			_gQuantTot := 0
			_gQujeTot  := 0
			_gDifTot   := 0
			_gPerTot   := 0
			_ptotdias+= _gtotdias
			_gtotdias   := 0
		endif
		_mgrupo = tra->b1_grupo
	endif
	
	While tra->b1_cod == cProd .And.;
	      !tra->(Eof())
	      
		IncRegua()
		@ li,000 PSAY SubStr(tra->b1_grupo,1,4) Picture "@!"
		@ li,006 PSAY SubStr(tra->b1_cod,1,6) Picture "@!"
		@ li,014 PSAY SubStr(tra->b1_desc,1,22) Picture "@!"
		@ li,038 PSAY tra->c2_lotectl Picture "@!"
		@ li,049 PSAY tra->c2_quant Picture "@E 99,999,999.99"
		@ li,063 PSAY tra->c2_quje  Picture "@E 99,999,999.99"
		@ li,090 PSAY dtoc(tra->c2_emissao)
		@ li,099 PSAY dtoc(tra->c2_datrf)
		nDias := (tra->c2_datrf - tra->c2_emissao)
		if empty(tra->c2_datrf)
			nDias := (date() - tra->c2_emissao)
		endif
		@ li,108 PSAY nDias Picture "@R 999"
		@ li,112 PSAY tra->c2_diferen Picture "@E 9,999,999.99"
		nValLiq := ((tra->c2_quje / tra->c2_quant) * 100)
		@ li,125 PSAY nValLiq Picture "9999.99"
		_mentiq := tra->b1_cxpad
		nQuantVal := nQuantVal + tra->c2_quant
		nQujeVal  := nQujeVal  + tra->c2_quje
		nDifVal   := nDifVal   + tra->c2_diferen
		nPerVal   := nPerVal   + nValLiq
		_totdias+= nDias
		nCont     := nCont     + 1
		nValLiq   := 0
		li := li + 1
		If li >= 58
			If Eof()
				Exit
			EndIf
			ImpCabec()
		EndIf

		tra->(dbSkip())
	end
	
	If Eof()
		Exit
	EndIf
	@ li,000 PSAY "Total -->"
	@ li,010 PSAY nCont Picture "999"
	@ li,038 PSAY nCont*_mentiq Picture "@E 9999.99"
	@ li,049 PSAY nQuantVal Picture "@E 99,999,999.99"
	@ li,063 PSAY nQujeVal  Picture "@E 99,999,999.99"
	@ li,106 PSAY _totdias Picture "@E 9,999"
	@ li,112 PSAY nDifVal   Picture "@E 9,999,999.99"
	@ li,125 PSAY (nPerVal / nCont) Picture "9999.99"
	_getiq += nCont*_mentiq
	nTotCont := (nTotCont + nCont)
	nQuantTot := nQuantTot + nQuantVal
	nQujeTot  := nQujeTot  + nQujeVal
	nDifTot   := nDifTot   + nDifVal
	nPerTot   := nPerTot   + nPerVal
	_gTotCont +=  nCont
	_gQuantTot += nQuantVal
	_gQujeTot  += nQujeVal
	_gDifTot   += nDifVal
	_gPerTot   += nPerVal
	_gtotdias  += _totdias
	nQuantVal := 0
	nQujeVal  := 0
	nDifVal   := 0
	nPerVal   := 0
	nCont     := 0
	_totdias  := 0
	li := li + 2
end 

@ li,000 PSAY "Total -->"
@ li,011 PSAY nCont Picture "999"
@ li,038 PSAY nCont*_mentiq Picture "@E 9999.99"
@ li,049 PSAY nQuantVal Picture "@E 99,999,999.99"
@ li,063 PSAY nQujeVal  Picture "@E 99,999,999.99"
@ li,106 PSAY _totdias Picture "@E 9,999"
@ li,112 PSAY nDifVal   Picture "@E 9,999,999.99"
@ li,125 PSAY (nPerVal / nCont) Picture "9999.99"

_getiq += nCont*_mentiq
nTotCont := (nTotCont + nCont)
nQuantTot := nQuantTot + nQuantVal
nQujeTot  := nQujeTot  + nQujeVal
nDifTot   := nDifTot   + nDifVal
nPerTot   := nPerTot   + nPerval
nPerVal   := 0

_gTotCont +=  nCont
_gQuantTot += nQuantVal
_gQujeTot  += nQujeVal
_gDifTot   += nDifVal
_gPerTot   += nPerVal
_ptotdias  += _gtotdias

li := li + 1
if !empty(_gtotcont)
	li := li + 1
	If li >= 58
		ImpCabec()
	EndIf
	@ prow()+1,000 PSAY "Total "+tabela("V0",_mgrupo+"    ")
	@ prow(),018 PSAY _gtotCont Picture "999"
	@ prow(),038 PSAY _getiq Picture "@E 9999.99"
	@ prow(),049 PSAY _gQuanttot Picture "@E 99,999,999.99"
	@ prow(),063 PSAY _gQujetot  Picture "@E 99,999,999.99"
	@ prow(),106 PSAY _gtotdias   Picture "@E 9,999"
	@ prow(),112 PSAY _gDiftot   Picture "@E 9,999,999.99"
	
	@ prow(),125 PSAY ((_gQujetot / _gQuanttot)*100)-100 Picture "@E 9999.99"
	_tetiq += _getiq
	_getiq := 0
	_gTotCont := 0
	_gQuantTot := 0
	_gQujeTot  := 0
	_gDifTot   := 0
	_gPerTot   := 0
end
@ li,000 PSAY Replicate("-",132)
li := li + 1
@ li,000 PSAY "T O T A L  G E R A L --->"
@ li,027 PSAY nTotCont Picture "@E 9,999"
@ li,038 PSAY _tetiq Picture "@E 999,999,999,999.99"

ImpRodape()
tra->(dbCloseArea())
tra1->(dbCloseArea())
//tra2->(dbCloseArea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa  ³ IMPCABEC  ³Autor ³ GARDENIA ILANY                          ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Cabecalho Do Relatorio                        ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic- Sigafin Versao 4.07 SQL         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function ImpCabec()
m_Pag := m_Pag + 1
@ 00,000 PSAY Replicate("*",132)
@ 01,000 PSAY "VITAMEDIC INDUSTRIA FARMACEUTICA LTDA"
@ 01,118 PSAY "Folha...:"
@ 01,128 PSAY StrZero(m_Pag,4)
@ 02,000 PSAY "Controle de Estoque de Produtos Acabados"
@ 02,114 PSAY "Dt Ref..:"
@ 02,124 PSAY DtoC(dDataBase)
@ 03,000 PSAY "Relacao de lotes no periodo de: "+DtoC(mv_par03)+" e "+DtoC(mv_par04)+"."
@ 03,114 PSAY "Emissao.:"
@ 03,124 PSAY DtoC(Date())
//                      10        20        30        40        50        60        70        80        90        100       110       120       130
//            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
@ 04,000 PSAY Replicate("-",132)

@ 05,000 PSAY "Codigo Produto                        Lote           Qtde          Qtde                   Data     Data     Per.   Diferenca    %   "
@ 06,000 PSAY "                                                     Teorica       Produzida              Abertura Fechamen Fab.              Aprov."


@ 07,000 PSAY Replicate("-",132)
li := 08
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa  ³ IMPRODAPE ³Autor ³ GARDENIA ILANY                          ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Cabecalho Do Relatorio                        ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic - Sigafin Versao 4.07 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ImpRodape()
@ li,050 PSAY nQuantTot Picture "@E 999,999,999,999.99"
@ li,064 PSAY nQujeTot  Picture "@E 999,999,999,999.99"
@ li,106 PSAY _ptotdias Picture "@E 999,999"
@ li,112 PSAY nDifTot   Picture "@E 999,999,999,999.99"
@ li,125 PSAY (nPerTot / nTotCont) Picture "9999.99"
li := li + 1
@ li,000 PSAY Replicate("-",132)
li := li + 1
@ li,000 PSAY "M E D I A  G E R A L   D O  P E R I O D O  D E  F A B R I C A C A O  D A S  "
@ li,077 PSAY nTotCont  Picture "@E 999,999"
@ li,084 PSAY "O P' S: "
@ li,094 PSAY (_ptotdias / nTotCont) Picture "@E 999,999,999.99"
li := li + 1
@ li,000 PSAY Replicate("-",132)
li := li + 1
@ li,109 PSAY "Hora Termino.: "+SubStr(Time(),1,8)
li := li + 1
@ li,000 PSAY Replicate("*",132)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa  ³ SELETRAB  ³Autor ³ Gardenia Ilany                          ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Funcao de Selecionar os Dados para a Gravacao no Arquivo de³ÛÛ
ÛÛ³          ³ Trabalho                                                   ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic - Sigafin Versao 4.07 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function SeleTrab()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta o Arquivo com as Producoes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cQuery:=" SELECT C2_PRODUTO, C2_LOTECTL, C2_QUANT, C2_QUJE, C2_EMISSAO, C2_DATRF "
_cQuery+=" FROM "
_cQuery+=  RetSqlName("SC2")+ " SC2"
_cQuery+=" WHERE"
_cQuery+="     SC2.D_E_L_E_T_<>'*'"
_cQuery+=" AND C2_FILIAL='"+xFilial("SC2")+"'"
_cQuery+=" AND C2_PRODUTO>='"+mv_par01+"'"
_cQuery+=" AND C2_PRODUTO<='"+mv_par02+"'"
_cQuery+=" AND C2_EMISSAO>='"+dtoS(mv_par03)+"'"
_cQuery+=" AND C2_EMISSAO<='"+dtoS(mv_par04)+"'"
If (mv_par05 == 1)
	_cQuery+=" AND C2_DATRF = ' '"
ElseIf (mv_par05 == 2)
	_cQuery+=" AND C2_DATRF<> ' '"
	_cQuery+=" AND C2_DATRF>= '"+dtoc(mv_par06)+"'"
	_cQuery+=" AND C2_DATRF<= '"+dtoc(mv_par07)+"'"
EndIf
_cQuery+=" AND C2_IMPREL<>'N'" // INCLUIDO EM 30/04/07 - HERAILDO
_cQuery+=" ORDER BY C2_PRODUTO, C2_LOTECTL, C2_EMISSAO"

_cQuery:=changequery(_cQuery)

TCQuery _cQuery NEW ALIAS "TRA1"
tcsetfield("TRA1","C2_QUANT","N",15,2)
tcsetfield("TRA1","C2_QUJE","N",15,2)
tcsetfield("TRA1","C2_EMISSAO","D")
tcsetfield("TRA1","C2_DATRF","D")

tra1->(dbgotop())

While !tra1->(Eof())
	
	sb1->(dbSetOrder(1))
	sb1->(dbSeek(xFilial("SB1")+tra1->c2_produto))
	sbm->(dbseek(xFilial("SBM")+sb1->b1_grupo))
	
	if sb1->b1_grupo >= mv_par08 .and.;
		sb1->b1_grupo <= mv_par09
		
		dbSelectArea("TRA")
		RecLock("TRA",.T.)
		tra->b1_cod     := tra1->c2_produto
		tra->b1_grupo   := sbm->bm_tipgru
		tra->b1_desc    := sb1->b1_desc
		tra->b1_cxpad   := sb1->b1_cxpad
		tra->c2_lotectl := tra1->c2_lotectl
		tra->c2_quant   := tra1->c2_quant
		tra->c2_quje    := tra1->c2_quje
		//	  dDatEmis := TRA1->C2_EMISSAO
		tra->c2_emissao := tra1->c2_emissao
		//	  dDatrFin := TRA1->C2_DATRF
		tra->c2_datrf   := tra1->c2_datrf
		tra->c2_diferen := (tra1->c2_quje - tra1->c2_quant)
		nPerc := ((tra1->c2_quje / tra1->c2_quant) * 100)
		tra->c2_percent := Round(nPerc,2)
		msUnLock()
	endif
	tra1->(dbSkip())
End
return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa  ³ CRIAARQ   ³Autor ³ Gardenia Ilany                          ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Cria Arquivo para Receber dados de Outras Querys           ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic - Sigafin Versao 4.07 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

// Substituido pelo assistente de conversao do AP6 IDE em 09/05/02 ==> Function CriaArq
Static Function CriaArq()
aCampos := {}
AADD(aCampos,{"B1_COD"     ,"C", 15,0})
AADD(aCampos,{"B1_DESC"    ,"C", 40,0})
AADD(aCampos,{"C2_LOTECTL" ,"C", 10,0})
AADD(aCampos,{"C2_QUANT"   ,"N", 12,2})
AADD(aCampos,{"C2_QUJE"    ,"N", 12,2})
//AADD(aCampos,{"D2_QTDVEN"  ,"N", 11,2})
AADD(aCampos,{"C2_DATRF"   ,"D", 08,0})
AADD(aCampos,{"C2_EMISSAO" ,"D", 08,2})
AADD(aCampos,{"C2_DIFEREN" ,"N", 12,2})
AADD(aCampos,{"C2_PERCENT" ,"N", 14,4})
AADD(aCampos,{"B1_GRUPO"   ,"C", 2,0})
AADD(aCampos,{"B1_CXPAD"   ,"N", 6,0})
AADD(aCampos,{"B1_APREVEN" ,"C",1,0})


cNomeArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cNomearq,"TRA",.T.,.F.)
dbSelectArea("TRA")
Index on tra->b1_grupo+tra->b1_desc+tra->b1_cod+c2_lotectl To &cNomeArq
dbSelectArea("TRA")
Return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Da emissao         ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a emisao       ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Emite as Op's      ?","mv_ch5","N",01,0,3,"C",space(60),"mv_par05"       ,"Abertas"        ,space(30),space(15),"Fechadas"       ,space(30),space(15),"Todas"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Do encerramento    ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Ate o encerramento ?","mv_ch7","D",08,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Do tipo de grupo   ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"09","Ate tipo de grupo  ?","mv_ch9","C",04,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})

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

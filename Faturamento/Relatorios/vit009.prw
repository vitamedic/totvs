#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"

User Function vit009()  


SetPrvt("CTEST,TAMANHO,NHORA,LIMITE,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CBCONT,CBTXT,NORDEM,CPERG")
SetPrvt("CSTRING,NOMEPROG,ALINHA,M_PAG,LTEST,WNREL")
SetPrvt("ARETURN,MV_PAR01,MV_PAR02,DNOMEARQ,CCODTAB,LI")
SetPrvt("CTITREL,CQUERY,CQUANTREG,ACAMPOS,CNOMEARQ,")


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
ÛÛ³Programa ³  VIT009  ³Autor ³Gardenia Ilany F. Vale  ³ Data ³ 03/02/2002³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Tabela de Precos                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

cTest     := 1
Tamanho   := "M"
nHora     := Time()
Limite    := 132
Titulo    := "Relatorio Tabela de Precos"
cDesc1    := "Este programa ira emitir o relatorio de Tabela de Precos"
cDesc2    := "De Acordo com os parametros"
cDesc3    := ""
cbCont    := 0
cbTxt     := ""
nOrdem    := ""
cPerg     := "PERGVIT009"
cString   := "DA1"
NomeProg  := "VIT009"
aLinha    := {}
m_pag     := 0
lTest     := .T.
wnRel     := "VIT009"+Alltrim(cusername)
aReturn:={"Zebrado",1,"administracao",1,2,1,"",0}
_pergsx1()
Pergunte(cPerg,.F.)
wnRel:=SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)

_cfilsa3:=xfilial("SA3")

// PESQUISA CODIGO DO SUPERVISOR
sa3->(dbsetorder(7))
if sa3->(dbseek(_cfilsa3+__cuserid))
	_cgerente:=sa3->a3_cod
else
	_cgerente:=space(6)
endif

If nLastkey == 27 .Or. LastKey() == 27
  Set Filter To
  Return
EndIf
SetDefault(aReturn,cString)                                        
ntipo:=if(areturn[4]==1,15,18)
If nLastkey == 27 .Or. LastKey() == 27
  Set Filter To
  Return
EndIf
rptStatus({||Imptit2()})
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPTIT2  ³Autor ³Gardenia Ilany F.Vale  ³ Data ³ 03/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ ´ÛÛ
ÛÛ³Uso   ³ Vitamedic - SigaFat Versao 6.09 SQL                              ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao                                                  ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ImpTit2()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01  := Da Tabela          C  03                     ³
//³mv_par02  := Ate Tabela         C  03                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SeleArq()
CriaArq()
ImpCabec()
dbSelectArea("TRA")
dbGoTop()
SetRegua(RecCount())
dbSelectArea("TRA")
dNomeArq := CriaTrab(,.F.)
Index On TRA->DA1_CODTAB+TRA->DA1_DESC+TRA->DA1_ITEM To &dNomeArq
//Index On TRA->DA1_CODTAB+TRA->DA1_ITEM To &dNomeArq

Set Index To &dNomeArq
Do While !Eof()
  cCodTab := TRA->DA1_CODTAB
  @ li,000 PSAY "Tabela..: "+TRA->DA1_CODTAB
  @ li,014 PSAY TRA->DA1_DESCRI Picture "@!"
  li := li + 1
  Do While cCodTab == TRA->DA1_CODTAB
    IncRegua()
    @ li,000 PSAY TRA->DA1_CODPRO Picture "999999"
    @ li,007 PSAY TRA->DA1_CODBAR  Picture "@!"
    @ li,023 PSAY SubStr(TRA->DA1_DESC,1,40) Picture "@!"
    @ li,064 PSAY SubStr(TRA->DA1_APRES,1,34) Picture "@!"
    @ li,099 PSAY TRA->DA1_CXPAD Picture "@E 9999"
    @ li,113 PSAY TRA->DA1_PRCVEN Picture "@E 99,999.99"
    @ li,123 PSAY TRA->DA1_PRCVEN/0.7   Picture "@E 99,999.99"
    li := li + 1
    If li >= 58
      ImpCabec()
    EndIf
    dbSelectArea("TRA")
    dbSkip()
    If Eof()
      Exit
    EndIf
  EndDo
  li := li + 1
EndDo
ImpRodape()
Eject
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPCABEC ³Autor ³Gardenia Ilany F.Vale  ³ Data ³ 03/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso       ³ Vitamedic - SigaFat Versao 4.07 SQL                          ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Cabecalho Do Relatorio                        ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ImpCabec()
cTitRel := "Relatorio de Tabelas de Precos Vitamedic"
m_Pag := m_Pag + 1
@ 00,000 PSAY AvalImp(Limite)
@ 00,000 PSAY "************************************************************************************************************************************"
@ 01,000 PSAY Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)
@ 01,038 PSAY "Relatorio de Tabela de Precos"
@ 01,114 PSAY "Folha...:"
@ 01,129 PSAY StrZero(m_Pag,3)
@ 02,000 PSAY "VIT009/v.6.09"
@ 02,114 PSAY "DT. Ref.: "+DtoC(dDataBase)
@ 03,000 PSAY "Hora.: "+ SubStr(nHora,1,8)
@ 03,040 PSAY cTitRel
@ 03,114 PSAY "Emissao.: "+DtoC(Date())
//                       10        20        30        40        50        60        70        80        90        100       110       120       130
//             0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
@ 04,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
@ 05,000 PSAY "Codigo Codigo EAN      Descricao Produto                        Apresentacao                        Caixa Pad.  Prc. Fab.   Max.Cons"
@ 06,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
li := 07    // xxxxxx xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 9,999.99    99,999.99  99,999.99
                                                                                           dbSelectArea("TRA")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPRODAPE ³Autor ³Gardenia Ilany F.Vale  ³ Data ³ 03/02/2002³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitamedic - Sigafat Versao 4.07 SQL                              ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Rpdape do Relatorio                           ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ImpRodape()
li := li - 1
@ li,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
li := li + 1
@ li,110 PSAY "Hora Termino.:"+SubStr(Time(),1,8)
li := li + 1
@ li,000 PSAY "************************************************************************************************************************************"
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa  ³ SELEARQ  ³Autor ³Gardenia Ilany F.Vale  ³ Data ³ 03/02/2002³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso       ³ Vitamedic - SigaFat Versao 5.09 SQL                          ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Selecao de Dados para o Relatorio                          ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function SeleArq()

cQuery:=" SELECT DA1.*"
cQuery+=" FROM"
cQuery+=" DA0010 DA0, DA1010 DA1"
cQuery+=" WHERE"
cQuery+=" DA0.D_E_L_E_T_ = ' '"
cQuery+=" AND DA1.D_E_L_E_T_=' '"
cQuery+=" AND DA1_FILIAL=' '"
cQuery+=" AND DA0_CODTAB = DA1_CODTAB"
cQuery+=" AND DA1_CODTAB>='"+mv_par01+"'"
cQuery+=" AND DA1_CODTAB<='"+mv_par02+"'"
cQuery+=" AND DA1_ATIVO = '1'"
cQuery+=" AND DA0_ESTADO IN (SELECT A1_EST" 
cQuery+=" FROM SA1010 SA1, SA3010 SA3"
cQuery+=" WHERE SA1.D_E_L_E_T_ = ' '"
cQuery+=" AND A1_MSBLQL NOT IN '1'"
cQuery+=" AND A1_VEND = A3_COD"
if !empty(_cgerente) .and. _cgerente > "001000"
	cQuery+=" AND A3_SUPER='"+_cgerente+"')"
elseif !empty(_cgerente) .and. _cgerente < "001000"
	cQuery+=" AND A3_COD='"+_cgerente+"')"
EndIf
cQuery+=" ORDER BY DA1_CODTAB, DA1_CODPRO"
TCQuery cQuery NEW ALIAS "TRA1"
dbSelectArea("TRA1")
dbGoTop()
cQuantReg := 0
Do While !Eof()
  cQuantReg := cQuantReg + 1
  dbSkip()
  If Eof()
    Exit
  EndIf
EndDo
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa  ³ CRIAARQ  ³Autor ³Gardenia Ilany F.Vale  ³ Data ³ 03/02/2002³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso       ³ Vitamedic - SigaFat Versao 6.09 SQL                          ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Cria o Arquivo que Recebera os Dados para Impressao.       ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function CriaArq()
aCampos := {}
AADD(aCampos,{"DA1_CODTAB"  ,"C", 03,0})
AADD(aCampos,{"DA1_ITEM"    ,"C", 04,0})
AADD(aCampos,{"DA1_DESCRI" ,"C", 30,0})
AADD(aCampos,{"DA1_CODPRO" ,"C", 15,0})
AADD(aCampos,{"DA1_CODBAR"  ,"C", 15,0})
AADD(aCampos,{"DA1_DESC" ,"C", 40,0})
AADD(aCampos,{"DA1_APRES"   ,"C", 60,0})
AADD(aCampos,{"DA1_PRCVEN"   ,"N", 9,2})
AADD(aCampos,{"DA1_CXPAD"   ,"N", 3,0})

cNomeArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cNomearq,"TRA",.T.,.F.)
dbSelectArea("TRA")
Index On TRA->DA1_CODTAB+TRA->DA1_CODPRO+TRA->DA1_ITEM To &cNomeArq
dbGoTop()
dbSelectArea("TRA1")
dbGoTop()
SetRegua(cQuantReg)
Do While !Eof()
  IncRegua()
  dbSelectArea("DA0")
  dbSetOrder(1)
  dbSeek(xFilial("DA0")+TRA1->DA1_CODTAB)
  dbSelectArea("SB1")
  dbSetOrder(1)
  dbSeek(xFilial("SB1")+TRA1->DA1_CODPRO)
  dbSelectArea("TRA")
  dbSeek(TRA1->DA1_CODTAB+TRA1->DA1_CODPRO+TRA1->DA1_ITEM)
  If !Found()
    RecLock("TRA",.T.)
  Else
    RecLock("TRA",.F.)
  EndIf
    TRA->DA1_CODTAB := TRA1->DA1_CODTAB
    TRA->DA1_ITEM   := TRA1->DA1_ITEM
    TRA->DA1_DESCRI := DA0->DA0_DESCRI
    TRA->DA1_CODPRO := TRA1->DA1_CODPRO
    TRA->DA1_CODBAR := SB1->B1_CODBAR
    TRA->DA1_DESC   := SB1->B1_DESC
    TRA->DA1_APRES  := SB1->B1_APRES
    TRA->DA1_PRCVEN := TRA1->DA1_PRCVEN
    TRA->DA1_CXPAD := SB1->B1_CXPAD
  msUnLock()
  dbSelectArea("TRA1")
  dbSkip()
EndDo
Return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da tabela          ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"DA0"})
aadd(_agrpsx1,{cperg,"02","Ate a tabela       ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"DA0"})
	
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

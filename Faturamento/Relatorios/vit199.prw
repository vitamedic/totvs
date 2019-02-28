#include "rwmake.ch"    
#INCLUDE "TOPCONN.CH"

User Function vit199()  


SetPrvt("CTEST,TAMANHO,NHORA,LIMITE,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CBCONT,CBTXT,NORDEM,CPERG")
SetPrvt("CSTRING,NOMEPROG,ALINHA,M_PAG,LTEST,WNREL")
SetPrvt("ARETURN,MV_PAR01,MV_PAR02,DNOMEARQ,CCODTAB,LI")
SetPrvt("CTITREL,CQUERY,CQUANTREG,ACAMPOS,CNOMEARQ,")



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³  VIT199   ³Autor ³Aline                 ³ Data ³ 26/05/2004 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitamedic - SigaFat Versao 6.09 SQL                            ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Ficha de Produtos                                          ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic - SigaFat Versao 6.09 SQL        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

//cTest     := 1
Tamanho   := "P"
nHora     := Time()
Limite    := 80
Titulo    := "Relatorio Tabela de Precos"
cDesc1    := "Este programa ira emitir o relatorio de Tabela de Precos"
cDesc2    := "De Acordo com os parametros"
cDesc3    := ""
cbCont    := 0
cbTxt     := ""
nOrdem    := ""
cPerg     := "VIT199"
cString   := "DA1"
NomeProg  := "VIT199"
aLinha    := {}
m_pag     := 0
lTest     := .T.
wnRel     := "VIT199"+Alltrim(cusername)
aReturn:={"Zebrado",1,"administracao",1,2,1,"",0}

cperg:="PERGVIT199"
_pergsx1()
pergunte(cperg,.f.)

//Pergunte(cPerg,.F.)
wnRel:=SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,tamanho,"",.f.)


SetDefault(aReturn,cString)                                        
If nLastkey == 27 .Or. LastKey() == 27
  Set Filter To
  Return                  
EndIf
rptStatus({||Imptit2()})
Return
/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPTIT2   ³Autor ³Gardenia Ilany F. Vale   ³ Data ³ 03/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitamedic - SigaFat Versao 6.09 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao                                                     ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
//  li := li + 1            
  ma = .t.
  Do While cCodTab == TRA->DA1_CODTAB
    IncRegua()                      
    _nprco := 0
    
    if TRA->DA1_TIPO = "PA"
    if tra->da1_categ <> "N"
       _nprco = TRA->DA1_PRCVEN / .7234
    else                                  
       _nprco = TRA->DA1_PRCVEN / .7523
    endif                                                                          
    
    if ma
        @ prow()+2,000 PSAY "LISTA DE PRODUTOS VITAMEDIC          "
          ma = .f.
    endif
    @ prow()+2,000 PSAY "Nome Comercial:               "+SubStr(TRA->DA1_DESC,1,40)
    @ prow()+1,000 PSAY "Produto Referencia:           "
    @ prow()+1,000 PSAY "Codigo Produto:               "+TRA->DA1_CODPROSS
    @ prow()+1,000 PSAY "Apresentacao:                 "+TRA->da1_APRES 
    @ prow()+1,000 PSAY "Classe Terapeutica:           "
    @ prow()+1,000 PSAY "Psicotropico Port.344/98:     "+"Nao"
    @ prow()+1,000 PSAY "Farmaceutico Responsavel:     "+"Dr. Jose Joaquim G. Silvestre"
    @ prow()+1,000 PSAY "No.Registro Min.Saude:        "+TRA->DA1_ANVISA
    @ prow()+1,000 PSAY "Codigo DCB:                   "+TRA->da1_dcb1 
    @ prow()+1,000 PSAY "Validade:                     "+transform(tra->da1_valid,"@E 9999999999")+"  Dias"
    @ prow()+1,000 PSAY "Peso Bruto Cartucho:          "+transform(tra->da1_pesobr,"@E 999999.9999")
    @ prow()+1,000 PSAY "Peso Bruto Cx.Emb:            "+transform(tra->da1_cxpaD*tra->da1_pesobr,"@E 999,999.999")
    @ prow()+1,000 PSAY "Origem do Produto:            "+"Nacional"
    @ prow()+1,000 PSAY "Codigo de Barras :            "+TRA->da1_codbar 
    @ prow()+1,000 PSAY "Caixa Padrao:                 "+transform(tra->da1_cxpaD,"@E 999,999") 
    @ prow()+1,000 PSAY "Classificacao Fiscal IPI:     "+TRA->da1_categ 
    @ prow()+1,000 PSAY "Classificacao Fiscal NCM:     "+TRA->da1_posipi 
    @ prow()+1,000 PSAY "Preco Fabrica (ICMS "+transform(_nper,"@E 99")+" %):     "+transform(tra->da1_prcven,"@E 999,999.99") 
    @ prow()+1,000 PSAY "Preco Consumidor (ICMS "+transform(_nper,"@E 99")+" %):"+transform(_nprco,"@E 999,999.99")
    @ prow()+1,000 PSAY  REPLICATE("_",80)
    If prow() >58 //li >= 58
      ImpCabec()
    EndIf
    ENDIF
    dbSelectArea("TRA")
    dbSkip()
    If Eof()
      Exit
    EndIf
  EndDo
//  li := li + 1
EndDo
//ImpRodape()
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPCABEC  ³Autor ³Gardenia Ilany F. Vale   ³ Data ³ 03/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitamedic - SigaFat Versao 4.07 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Cabecalho Do Relatorio                           ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpCabec()
//cTitRel := "Relatorio de Tabelas de Precos Vitapan"
m_Pag := m_Pag + 1       
@ 00,000 PSAY AvalImp(Limite)
@ 01,60 PSAY "Pagina:"+StrZero(m_Pag,3)

/*
@ 00,000 PSAY "************************************************************************************************************************************"
@ 01,000 PSAY Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)
@ 01,038 PSAY "Relatorio de Tabela de Precos"
@ 01,114 PSAY "Folha...:"
@ 01,129 PSAY StrZero(m_Pag,3)
@ 02,000 PSAY "VIT199/v.6.09"
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
  */                                                                                         dbSelectArea("TRA")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPRODAPE ³Autor ³Gardenia Ilany F. Vale   ³ Data ³ 03/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitamedic - Sigafat Versao 4.07 SQL                               ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Impressao do Rpdape do Relatorio                              ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ SELEARQ   ³Autor ³Gardenia Ilany F. Vale   ³ Data ³ 03/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitamedic - SigaFat Versao 5.09 SQL                               ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Selecao de dados para o relatorio                             ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SeleArq()
cQuery :=          ' SELECT * FROM ' + RetSqlName("DA1")
cQuery := cQuery + ' WHERE D_E_L_E_T_ = " " '
cQuery := cQuery + ' AND DA1_FILIAL    = "'+xFilial("DA1")+'"'
cQuery := cQuery + ' AND DA1_CODTAB   >= "'+mv_par01+'"'
cQuery := cQuery + ' AND DA1_CODTAB   <= "'+mv_par02+'"'
cQuery := cQuery + ' ORDER BY DA1_CODTAB, DA1_CODPRO'
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ CRIAARQ   ³Autor ³Gardenia Ilany F. Vale   ³ Data ³ 03/02/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitamedic - SigaFat Versao 6.09 SQL                               ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Cria o Arquivo que recebera os dados para impressao.          ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
AADD(aCampos,{"DA1_DCB1"   ,"C", 8,0})
AADD(aCampos,{"DA1_VALID"   ,"N", 4,0})
AADD(aCampos,{"DA1_POSIPI"   ,"C", 20,0})
AADD(aCampos,{"DA1_CATEG"   ,"C", 3,0})
AADD(aCampos,{"DA1_PESOBR"   ,"N",11,4})
AADD(aCampos,{"DA1_ANVISA"   ,"C",13,0})
AADD(aCampos,{"DA1_TIPO"   ,"C",2,0})
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
    TRA->DA1_CXPAD := SB1->B1_CXPAD  
    TRA->DA1_VALID := SB1->B1_PRVALID
    TRA->DA1_DCB1 := SB1->B1_DCB1
    TRA->DA1_POSIPI := SB1->B1_POSIPI    
    TRA->DA1_CATEG := SB1->B1_CATEG       
    TRA->DA1_PESOBR := SB1->B1_PESBRU    
    TRA->DA1_ANVISA := SB1->B1_ANVISA        
    TRA->DA1_TIPO := SB1->B1_TIPO            
  msUnLock()
  dbSelectArea("TRA1")
  dbSkip()
EndDo
Return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da Tabela          ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"DA0"})
aadd(_agrpsx1,{cperg,"02","Ate a Tabela       ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"DA0"})

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

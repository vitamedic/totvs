#include "rwmake.ch"       
#INCLUDE "TOPCONN.CH"

User Function VIT043()     

SetPrvt("CTEST,TAMANHO,NHORA,LIMITE,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CBCONT,NLASTKEY,CBTXT,CPERG")
SetPrvt("CSTRING,NOMEPROG,ALINHA,M_PAG,WNREL,ARETURN")
SetPrvt("MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06")
SetPrvt("DDATE,CNOMEMES,CTAMNOME,CQUER1,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄ ÄÄÄ¿ÛÛ
ÛÛ³Programa  ³ VIT043   ³Autor ³Gardenia				 ³ Data ³ 08/03/2002  ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Relatorio de Compensacao de Horas                          ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic - SigaFin Versao 4.07 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


cTest    := 1
Tamanho  := "M"
nHora    := Time()
Limite   := 132
Titulo   := "Informativo de debito ao Cliente"
cDesc1   := "Este programa ira emitir um relatorio de informação de débito ao cliente  "
cDesc2   := "De acordo com os parametros..."
cDesc3   := ""
cbCont   := 0
nLastKey := 0
cbTxt    := ""
cString  := "SE1"
NomeProg := "VIT043"
aLinha   := {}
m_pag    := 0
wnRel    := "VIT043"+Alltrim(cusername)
aReturn:={"Zebrado",1,"administracao",1,2,1,"",0}

cperg    :="PERGVIT043"
_pergsx1()
pergunte(cperg,.f.)


SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho)
If nLastkey == 27 .Or. LastKey() == 27
  Set Filter To
  Return
EndIf
SetDefault(aReturn,cString)
rptStatus({||Imptit2()})
Return
/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ IMPTIT2   ³Autor ³Gardenia                 ³ Data ³ 08/03/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitamedic - Sigafin Versao 4.07 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
7ÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/03/02 ==> Function ImpTit2
Static Function ImpTit2()
//SeleArq()
SetRegua(RecCount())
_total :=0
dbSelectArea("SE1")   
_cfilse1 := xfilial("SE1")
_cfilsa1 := xfilial("SA1")
sa1->(dbsetorder(1))
_cindse1 :=criatrab(,.f.)
if !empty(mv_par03)
	_cchave :="E1_FILIAL+E1_CLIENTE+E1_LOJA"
	se1->(indregua("se1",_cindse1,_cchave))
	se1->(dbSeek(_cfilse1+mv_par03+mv_par04,.t.))
else
	_cchave :="E1_FILIAL+E1_BAIXA+E1_CLIENTE+E1_LOJA"
	se1->(dbSeek(_cfilse1+dtos(mv_par01),.t.))
endif	
_mpag:=0
_cpassou = .F.                          

Do While !Eof() // .and. se1->e1_baixa <= mv_par02
  If empty(e1_baixa) .or. empty(e1_saldo)
    dbSelectArea("SE1")
    dbSkip()
    Loop
  EndIf
  If !empty(mv_par03) .and. (mv_par03 <> se1->e1_cliente .or. mv_par04 <> se1->e1_loja)
    dbSelectArea("SE1")
    dbSkip()
    Loop
  EndIf
  If empty(se1->e1_saldo) .or. se1->e1_saldo == se1->e1_valor
    dbSelectArea("SE1")
    dbSkip()
    Loop
  EndIf
	_cliente := se1->e1_cliente
	_loja := se1->e1_loja   
  IncRegua()
  _total :=0

							  
  _njurrec  :=se1->e1_juros
  _ndias    :=date()-se1->e1_vencto
  _njuros1:=0
  if _ndias <=30
   	_njuros :=(se1->e1_saldo*_ndias*0.27)/100
  else                
	_njuros :=(se1->e1_saldo*30*0.27)/100
	_saldo:=se1->e1_saldo*((1+(0.27/100))^(_ndias-30))
	_njuros1:=_saldo-se1->e1_saldo
  endif  
   _njuros:=_njuros+_njuros1	
  
	_mudou := .T.
   Do While !Eof() .and. e1_baixa <= mv_par02 .and. _cliente == se1->e1_cliente ;
  	 .and. _loja == se1->e1_loja                
	  If empty(e1_baixa) .or. empty(e1_saldo)
	    dbSelectArea("SE1")
	    dbSkip()
	    Loop
	  EndIf
	  If !empty(mv_par03) .and. (mv_par03 <> se1->e1_cliente .or. mv_par04 <> se1->e1_loja)
	    dbSelectArea("SE1")
	    dbSkip()
	    Loop
	  EndIf
	  If empty(se1->e1_saldo) .or. se1->e1_saldo == se1->e1_valor
	    dbSelectArea("SE1")
	    dbSkip()
	    Loop
	  EndIf
	  if _mudou 
	    _mudou := .F.
     	 setprc(0,0)
		 @ 000,000      PSAY avalimp(limite)
	    @ prow()+4,00 PSAY "Anapolis," +strzero(day(ddatabase),2)+ " de "+ mesExtenso(ddatabase)+ " de  "+ strzero(Year(ddatabase),4) + " ."
		 sa1->(dbSeek(_cfilsa1+_cliente,.t.))
       @ prow()+3,00 PSAY "A"
	    @ prow()+2,00 PSAY sa1->a1_nome
  		 @ prow()+2,00 PSAY "A/C Dpto. de Contas a Pagar"
	    @ prow()+4,00 PSAY "-------------------------------------------------------"
  		 @ prow()+2,00 PSAY "Prezados senhores "
	    @ prow()+4,00 PSAY "Solicitamos de V.Sas., pagamento do valor complementar a quitacao do(s) titulo(os)"
	    @ prow()+1,00 PSAY "abaixo discriminado(s), visto pagamento parcial do(s) mesmo(s) nesta data."  && +se1->e1_prefixo+"-"+se1->e1_num+se1->e1_parcela 
	    @ prow()+3,00 PSAY "No.Titulo   Emissao    Venc. Vl.Nominal   Vlr.Pago  Restante   Juros Tot.Pagar"

//No.Titulo   Emissao    Venc. Vl.Nominal   Vlr.Pago  Restante  Juros   Tot.Pagar
//XXX999999X 99/99/99 99/99/99 999,999.99 999,999.99 99,999.99 9999.99 999,999.99 
	  endif       
	  @ prow()+1 ,00 PSAY se1->e1_prefixo+"-"+se1->e1_num+se1->e1_parcela 
	  @ prow(),12 PSAY  se1->e1_emissao
	  @ prow(),21 PSAY  se1->e1_vencto
	  @ prow(),30 PSAY  se1->e1_valor  picture "@E 999,999.99"
	  @ prow(),44 PSAY  se1->e1_valliq picture "@E 999,999.99"
	  @ prow(),55 PSAY  se1->e1_saldo  picture "@E 99,999.99"
	  @ prow(),66 PSAY  _njuros        picture "@E 9999.99"
	  @ prow(),66 PSAY  se1->e1_saldo+_njuros picture "@E 999,999.99"

	  _total += se1->e1_saldo+_njuros
     dbSelectArea("SE1")
	  dbSkip()
     If Eof()
	    Exit
	  EndIf
  enddo
  @ prow() +2 ,00 PSAY "Total =====================>"
  @ prow() +1,66 PSAY _total  picture "@E 9999,999.99"
  @ prow()+3,00 PSAY "No aguardo da regularizacao, agradecemos"
  @ prow()+4,00 PSAY "Atenciosamente,"
  @ prow()+4,00 PSAY "Departamento de Crédito e Cobranca"
  @ prow()+2,00 PSAY "VITAMEDIC - Industria Farmaceutica Ltda."
  @ prow()+1,00 PSAY "Rua VPR -01, Qd. 2A, Modulo 1, DAIA - Anapolis - GO."
  @ prow()+1,00 PSAY "CEP - 75133-600"
  @ prow()+1,00 PSAY "Fone: (0xx62) 3902-6100"
  eject
EndDo
se1->(retindex("SE1"))
ferase(_cindse1+se1->(ordbagext()))

Set Filter To
Set Device To Screen
If aReturn[5] == 1
  Set Printer To
  dbCommitAll()
  OurSpool(wnRel)
EndIf
ms_Flush()
Set Century Off
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa ³ SELEARQ   ³Autor ³Gardenia                 ³ Data ³ 08/03/2002 ³ÛÛ
ÛÛÃÄÄÄÄÄÄÂÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Uso   ³ Vitamedic - Sigafin Versao 4.07 SQL                             ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Selecao de dados para o relatorio                             ³ÛÛ
ÛÛÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛÛ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP6 IDE em 08/03/02 ==> Function SeleArq
Static Function SeleArq()
/*
// versao SQL ja Esta Pronto Ok
  cQuer1 :=          ' SELECT * FROM ' + RetSqlName("SRA")
  cQuer1 := cQuer1 + ' WHERE D_E_L_E_T_ = " " '
  cQuer1 := cQuer1 + ' AND RA_FILIAL    = "'+xFilial("SRA")+'"'
  cQuer1 := cQuer1 + ' AND RA_MAT      >= "'+mv_par01+'"'
  cQuer1 := cQuer1 + ' AND RA_MAT      <= "'+mv_par02+'"'
  cQuer1 := cQuer1 + ' AND RA_ADMISSA  >= "'+DtoS(mv_par03)+'"'
  cQuer1 := cQuer1 + ' AND RA_ADMISSA  <= "'+DtoS(mv_par04)+'"'
  cQuer1 := cQuer1 + ' AND RA_CC       >= "'+mv_par05+'"'
  cQuer1 := cQuer1 + ' AND RA_CC       <= "'+mv_par06+'"'
  TCQuery cQuer1 NEW ALIAS "TRA"
  dbSelectArea("TRA")
  dbGoTop()
*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 08/03/02




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³mv_par01  := Da Matricula       C  06   ³
//³mv_par02  := Ate Matricula      C  06   ³
//³mv_par03  := Da Dt. Admissao    D  08   ³
//³mv_par04  := Ate Dt. Admissao   D  08   ³
//³mv_par05  := Do Centro Custo    C  09   ³
//³mv_par06  := Ate Centro Custo   C  09   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da Data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a Data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do Cliente         ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"04","Da Loja            ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Ate o Cliente      ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"06","Ate a Loja         ?","mv_ch6","C",06,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

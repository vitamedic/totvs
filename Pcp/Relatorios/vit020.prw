#include "rwmake.ch"

User Function vit020()

SetPrvt("CBTXT,CBCONT,WNREL,NORDEM,TAMANHO,LIMITE")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,CCANCEL,NTIPO")
SetPrvt("CFILSB1,CFILSC2,CFILSD4,CFILSG1,CFILSZD,AETIQ1")
SetPrvt("AETIQ2,I,NPARTE,NQTDIMP,CPROD,CLOTE")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT020   ³ Autor ³ Gardenia Ilany        ³ Data ³ 29/01/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de Etiquetas das Materias Primas Empenhadas na   ³±±
±±³          ³ Inclusao de Ordens de Producao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt  := ""
CbCont := ""
wnrel  := ""
nOrdem := ""
Tamanho:= "P"
limite := 80
titulo := "IMPRESSAO DE ETIQUETAS DE PRODUCAO"
cDesc1 := oemtoansi("Este programa ira emitir as etiquetas de materias primas para producao")
cDesc2 := ""
cDesc3 := ""

cString:="SD4"
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog:="GRE030"
aLinha  := { }
nLastKey := 0
cPerg:="PERGVIT020"
_pergsx1()
pergunte(cperg,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametro                         ³
//³ mv_par01              Da ordem de producao                  ³
//³ mv_par02              Ate a ordem de producao               ³
//³ mv_par03              Do produto                            ³
//³ mv_par04              Ate o produto                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cCancel := "***** CANCELADO PELO OPERADOR *****"
wnrel:="VIT020"+Alltrim(cusername)
wnrel:=SetPrint(cString,wnrel,cperg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,,,.T.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)
ntipo:=if(areturn[4]==1,15,18)
If nLastKey == 27
	Set Filter To
	Return
Endif


//*******************************************
//Funcao RptDetail - Impressao do Relatorio
//*******************************************
RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP6 IDE em 29/01/02 ==> RptStatus({|| Execute(RptDetail) })
Return NIL

// Substituido pelo assistente de conversao do AP6 IDE em 29/01/02 ==> Function RptDetail
Static Function RptDetail()
setprc(0,0)
@ 000,000 PSAY chr(15)
cfilsb1:=xfilial("SB1")
cfilsc2:=xfilial("SC2")
cfilsd4:=xfilial("SD4")
cfilsg1:=xfilial("SG1")
sb1->(dbsetorder(1))
sc2->(dbsetorder(1))
sd4->(dbsetorder(2))

setregua(sd4->(lastrec()))
sd4->(dbseek(cfilsd4+mv_par01,.t.))

aetiq1:={"","","","",""}
aetiq2:={"","","","",""}
i:=1

while ! sd4->(eof()) .and. left(sd4->d4_op,6)<=mv_par02
	_cod :=sd4->d4_op
	sb1->(dbseek(cfilsb1+sd4->d4_cod))
	
	if sb1->b1_tipo>=mv_par05 .and. sb1->b1_tipo<=mv_par06 .and. sd4->d4_cod>=mv_par03 .and.;
		sd4->d4_cod<=mv_par04 .and. sd4->d4_cod <> '100013'
		
		cprod:=sd4->d4_cod
		clote:=sd4->d4_lotectl
		sc2->(dbseek(cfilsc2+sd4->d4_op))
		sg1->(dbseek(cfilsg1+sc2->c2_produto+sd4->d4_cod+sd4->d4_trt))
		if i==1
			aetiq1[1]:=alltrim(sb1->b1_desc)+"-"+alltrim(sd4->d4_cod)
			aetiq1[2]:="Qtde: "+transform(sd4->d4_qtdeori,"@E 999,999.99")+" "+sb1->b1_um
			sb1->(dbseek(cfilsb1+sg1->g1_cod))
			aetiq1[3]:="RE: "+alltrim(sd4->d4_lotectl)
			sc2->(dbseek(cfilsc2+left(sd4->d4_op,6)))
			sb1->(dbseek(cfilsb1+sc2->c2_produto))
			aetiq1[4]:=alltrim(sb1->b1_desc)+" Lt: "+sc2->c2_lotectl
			aetiq1[5]:="Data Lote: "+dtoc(sc2->c2_emissao)
		else
			aetiq2[1]:=alltrim(sb1->b1_desc)+"-"+alltrim(sd4->d4_cod)
			aetiq2[2]:="Qtde: "+transform(sd4->d4_qtdeori,"@E 999,999.99")+" "+sb1->b1_um
			sb1->(dbseek(cfilsb1+sg1->g1_cod))
			aetiq2[3]:="RE: "+alltrim(sd4->d4_lotectl)
			sc2->(dbseek(cfilsc2+left(sd4->d4_op,6)))
			sb1->(dbseek(cfilsb1+sc2->c2_produto))
			aetiq2[4]:=alltrim(sb1->b1_desc)+" Lt: "+sc2->c2_lotectl
			aetiq2[5]:="Data Lote: "+dtoc(sc2->c2_emissao)
		endif
		i:=i+1
		if i==3
			i:=1
			@ prow(),000   PSAY aetiq1[1]
			@ prow(),074   PSAY aetiq2[1]
			@ prow()+1,000 PSAY aetiq1[2]
			@ prow(),074   PSAY aetiq2[2]
			@ prow()+1,000 PSAY aetiq1[3]
			@ prow(),074   PSAY aetiq2[3]
			@ prow()+1,000 PSAY aetiq1[4]
			@ prow(),074   PSAY aetiq2[4]
			@ prow()+1,000 PSAY aetiq1[5]
			@ prow(),074   PSAY aetiq2[5]
			@ prow()+5,000 PSAY " "
			aetiq1:={"","","","",""}
			aetiq2:={"","","","",""}
		endif
		sd4->(dbskip())
	else
		sd4->(dbskip())
	endif
end
if !empty(aetiq1[1])
	@ prow(),000   PSAY aetiq1[1]
	@ prow(),074   PSAY aetiq2[1]
	@ prow()+1,000 PSAY aetiq1[2]
	@ prow(),074   PSAY aetiq2[2]
	@ prow()+1,000 PSAY aetiq1[3]
	@ prow(),074   PSAY aetiq2[3]
	@ prow()+1,000 PSAY aetiq1[4]
	@ prow(),074   PSAY aetiq2[4]
	@ prow()+1,000 PSAY aetiq1[5]
	@ prow(),074   PSAY aetiq2[5]
	@ prow()+5,000 PSAY " "
endif
If ( aReturn[5]==1 )
	Set Print to
	dbCommitall()
	ourspool(wnrel)
EndIf

MS_Flush()

Return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da OP              ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a OP           ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do Produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o Produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Do Tipo            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Ate o Tipo         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})


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

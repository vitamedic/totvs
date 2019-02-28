#include "rwmake.ch"       

User Function vit021()     


SetPrvt("CBTXT,CBCONT,WNREL,NORDEM,TAMANHO,LIMITE,NQTDE")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,CCANCEL,NTIPO")
SetPrvt("CFILSB1,CFILSC2,CFILSD4,CFILSG1,CFILSZD,AETIQ1")
SetPrvt("AETIQ2,I,NPARTE,NQTDIMP,CPROD,CLOTE")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT021   ³ Autor ³ Gardenia Ilany        ³ Data ³ 29/01/02 ³±±
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
titulo := "IMPRESSAO DE ETIQUETAS DE EMBALAGEM  POR ORDEM DE PRODUCAO  "
cDesc1 := oemtoansi("Este programa ira emitir as etiquetas de embalagem")
cDesc2 := ""
cDesc3 := ""

cString:="SC2"
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog:="VIT021"
aLinha  := { }
nLastKey := 0
cPerg:="PERGVIT020"
_pergsx1()
pergunte(cperg,.f.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametro                         ³
//³ mv_par01              Da ordem de producao                  ³
//³ mv_par02              Ate a ordem de producao               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cCancel := "***** CANCELADO PELO OPERADOR *****"
wnrel:="VIT021"+Alltrim(cusername)
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

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP6 IDE em 29/01/02 ==> RptStatus({|| Execute(RptDetail) })
Return NIL

//*******************************************
//Funcao RptDetail - Impressao do Relatorio
//*******************************************

// Substituido pelo assistente de conversao do AP6 IDE em 29/01/02 ==> Function RptDetail
Static Function RptDetail()
setprc(0,0)
//@ 000,000 PSAY chr(15)
cfilsb1:=xfilial("SB1")
cfilsc2:=xfilial("SC2")
sb1->(dbsetorder(1))
sc2->(dbsetorder(1))
setregua(sd4->(lastrec()))
sc2->(dbseek(cfilsc2+mv_par01,.t.))
aetiq1:={"","","","","","" }
aetiq2:={"","","","","",""}
while ! sc2->(eof()) .and. left(sc2->c2_num,8)<=mv_par02
	nqtde:= sc2->c2_quant
  	sb1->(dbseek(cfilsb1+sc2->c2_produto))
	nqtde:=nqtde/sb1->b1_cxpad
	nqtde:=nqtde+(nqtde*0.03)
	nqtde := int(nqtde)
	i:=1
//msgstop(nqtde)
   while ! sc2->(eof()).and. left(sc2->c2_num,8)<=mv_par02 .and. nqtde >=1
		if i==1
			aetiq1[1]:=alltrim(sc2->c2_produto)+"-" +substr(alltrim(sb1->b1_desc),1,30)
			aetiq1[2]:=substr(alltrim(sb1->b1_apres),1,30)
			aetiq1[3]:="Lote...: "+sc2->c2_lotectl
			aetiq1[4]:="Caixa..: "+strzero(sb1->b1_cxpad,3,0)
			aetiq1[5]:="D.Fab..: "+strzero(month(sc2->c2_datpri),2,0) + '/'+ strzero(year(sc2->c2_datpri),4,0)
			aetiq1[6]:="D.Val..: "+strzero(month(sc2->c2_dtvalid),2,0) + '/'+ strzero(year(sc2->c2_dtvalid),4,0)
		 else
			aetiq2[1]:=alltrim(sc2->c2_produto)+"-" +substr(alltrim(sb1->b1_desc),1,30)
			aetiq2[2]:=substr(alltrim(sb1->b1_apres),1,30)
			aetiq2[3]:="Lote...: "+sc2->c2_lotectl
			aetiq2[4]:="Caixa..: "+strzero(sb1->b1_cxpad,3,0)
			aetiq2[5]:="D.Fab..: "+strzero(month(sc2->c2_datpri),2,0) + '/'+ strzero(year(sc2->c2_datpri),4,0)
			aetiq2[6]:="D.Val..: "+strzero(month(sc2->c2_dtvalid),2,0) + '/'+ strzero(year(sc2->c2_dtvalid),4,0)
		 endif
 		 i:=i+1
		 if i==3
			i:=1
//			@ prow(),000   PSAY chr(27)+"G"
         @ prow(),000   PSAY aetiq1[1]
			@ prow(),041   PSAY aetiq2[1]
//			@ prow(),pcol  PSAY chr(27)+"H"
			@ prow()+1,000 PSAY aetiq1[2]
			@ prow(),041   PSAY aetiq2[2]
//			@ prow(),000   PSAY chr(27)+"G"
			@ prow()+1,000 PSAY aetiq1[3]
			@ prow(),041   PSAY aetiq2[3]
//			@ prow(),pcol  PSAY chr(27)+"H"
			@ prow()+1,000 PSAY aetiq1[4]
			@ prow(),041   PSAY aetiq2[4]
			@ prow()+1,000 PSAY aetiq1[5]
			@ prow(),041   PSAY aetiq2[5]
			@ prow()+1,000 PSAY aetiq1[6]
			@ prow(),041   PSAY aetiq2[6]
//		devpos(prow()+2,000)
			@ prow()+4,000 PSAY " "
			aetiq1:={"","","","","",""}
			aetiq2:={"","","","","",""}
		endif
   	nqtde := nqtde-1
   end
	sc2->(dbskip())
end
if !empty(aetiq1[1])
   @ prow(),000   PSAY aetiq1[1]
	@ prow(),041   PSAY aetiq2[1]
	@ prow()+1,000 PSAY aetiq1[2]
	@ prow(),041   PSAY aetiq2[2]
	@ prow()+1,000 PSAY aetiq1[3]
	@ prow(),041   PSAY aetiq2[3]
	@ prow()+1,000 PSAY aetiq1[4]
	@ prow(),041   PSAY aetiq2[4]
	@ prow()+1,000 PSAY aetiq1[5]
	@ prow(),041   PSAY aetiq2[5]
	@ prow()+1,000 PSAY aetiq1[6]
	@ prow(),041   PSAY aetiq2[6]
	@ prow()+5,000 PSAY " "
//	devpos(prow()+2,000)
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





/*
Mercadoria                                      Lote        Quantidade
999999-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxx 999.999.999 _________
*/






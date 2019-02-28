#include "rwmake.ch"       

User Function VIT233()     


SetPrvt("CBTXT,CBCONT,WNREL,NORDEM,TAMANHO,LIMITE,NQTDE")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,CCANCEL,NTIPO")
SetPrvt("CFILSB1,CFILSC2,CFILSD4,CFILSG1,CFILSZD,AETIQ1")
SetPrvt("AETIQ2,I,NPARTE,NQTDIMP,CPROD,CLOTE")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT233   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 01/08/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de Etiquetas dos Produtos Sanitizantes e/ou      ³±±
±±³          ³ Produtos Beneficiados por Algum Servico                    ³±±
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
titulo := "IMPRESSAO DE ETIQUETAS DE PRODUTO SANITIZANTE/BENEFICIADO"
cDesc1 := oemtoansi("Este programa ira emitir as etiquetas de produto sanitizante/beneficiados")
cDesc2 := ""
cDesc3 := ""

cString:="SC2"
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog:="VIT233"
aLinha  := { }
nLastKey := 0
cPerg:="PERGVIT233"
_pergsx1()
pergunte(cperg,.f.)

cCancel := "***** CANCELADO PELO OPERADOR *****"
wnrel:="VIT233"+Alltrim(cusername)
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

RptStatus({|| RptDetail() })
Return NIL

//*******************************************
//Funcao RptDetail - Impressao do Relatorio
//*******************************************

Static Function RptDetail()
setprc(0,0)
cfilsb1:=xfilial("SB1")
cfilsc2:=xfilial("SC2")
sb1->(dbsetorder(1))
sc2->(dbsetorder(1))

setregua(sd4->(lastrec()))

sc2->(dbseek(cfilsc2+mv_par01,.t.))
aetiq1:={"","","","","","" }
aetiq2:={"","","","","",""}


while ! sc2->(eof()) .and. left(sc2->c2_num,8)<=mv_par02
  	sb1->(dbseek(cfilsb1+sc2->c2_produto))
	if mv_par03==1
		nqtde:= mv_par04
	else 
		nqtde:= mv_par04
		_mtp:=if(sb1->b1_tipo="MP","MAT.PRIMA","MAT.EMBALAGEM")
	endif	
	i:=1

	while ! sc2->(eof()).and. left(sc2->c2_num,8)<=mv_par02 .and. nqtde >=1
		if i==1
			aetiq1[1]:=if(mv_par03==1,"      PRODUTO SANITIZANTE","      PRODUTO BENEFICIADO - "+_mtp)
			aetiq1[2]:= "  "
			aetiq1[3]:=alltrim(sc2->c2_produto)+"-" +substr(alltrim(sb1->b1_desc),1,40)
			aetiq1[4]:="Lote...: "+sc2->c2_lotectl
   			if mv_par03==1                                      		
				aetiq1[5]:="D.Fab..: "+dtoc(mv_par05) 
				aetiq1[6]:="D.Val..: "+dtoc(mv_par06)
			else   
				if sb1->b1_grupo$"EE05/EN07" // GRAVAÇÃO DE ALUMÍNIO
					aetiq1[5]:="D.Fab..: "+dtoc(sc2->c2_datpri) 
					aetiq1[6]:="D.Val..: "+dtoc(sc2->c2_dtvalid)+"         Quantidade:"+ transform(sb1->b1_le,'@E 9,999,999.9999')				
				else
					aetiq1[5]:="D.Fab..: "+dtoc(sc2->c2_datpri) 
					aetiq1[6]:="D.Val..: "+dtoc(sc2->c2_dtvalid)+"         Dt.Reanalise:"+ dtoc(sc2->c2_dtvalid-180)
				endif
			endif

		 else
			aetiq2[1]:=if(mv_par03==1,"      PRODUTO SANITIZANTE","      PRODUTO BENEFICIADO - "+_mtp)
			aetiq2[2]:= "  "
			aetiq2[3]:=alltrim(sc2->c2_produto)+"-" +substr(alltrim(sb1->b1_desc),1,30)
			aetiq2[4]:="Lote...: "+sc2->c2_lotectl
   			if mv_par03==1
				aetiq2[5]:="D.Fab..: "+dtoc(mv_par05) 
				aetiq2[6]:="D.Val..: "+dtoc(mv_par06)
			else
				if sb1->b1_grupo$"EE05/EN07" // GRAVAÇÃO DE ALUMÍNIO
					aetiq2[5]:="D.Fab..: "+dtoc(sc2->c2_datpri) 
					aetiq2[6]:="D.Val..: "+dtoc(sc2->c2_dtvalid)+"         Quantidade:"+ transform(sb1->b1_le,'@E 9,999,999.9999')				
				else
					aetiq2[5]:="D.Fab..: "+dtoc(sc2->c2_datpri) 
					aetiq2[6]:="D.Val..: "+dtoc(sc2->c2_dtvalid)+"         Dt.Reanalise:"+ dtoc(sc2->c2_dtvalid-180)
				endif
			endif
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
			@ prow()+1,000 PSAY aetiq1[6]
			@ prow(),074   PSAY aetiq2[6]
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
aadd(_agrpsx1,{cperg,"01","Da OP              ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC2"})
aadd(_agrpsx1,{cperg,"02","Ate a OP           ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC2"})
aadd(_agrpsx1,{cperg,"03","Tipo Etiqueta      ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03"       ,"1-Sanitizante"  ,space(30),space(15),"2-Beneficiam."  ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Qtde.Etiqueta      ?","mv_ch4","N",06,0,0,"C",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Dt.Fabricacao      ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Dt.Validade        ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//dd(_agrpsx1,{cperg,"07","Qtde. Teorica      ?","mv_ch7","N",15,4,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

	
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






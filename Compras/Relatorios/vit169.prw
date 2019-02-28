#include "rwmake.ch"       

User Function VIT169()     


SetPrvt("CBTXT,CBCONT,WNREL,NORDEM,TAMANHO,LIMITE")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,CCANCEL,NTIPO")
SetPrvt("CFILSB1,CFILSC2,CFILSD4,CFILSG1,CFILSZD,AETIQ1")
SetPrvt("AETIQ2,I,NPARTE,NQTDIMP,CPROD,CLOTE")

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    � VIT169   � Autor � Gardenia Ilany        � Data � 11/07/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Impressao de Etiquetas de Fornecedores                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Define Variaveis                                             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
CbTxt  := ""
CbCont := ""
wnrel  := ""
nOrdem := ""
Tamanho:= "G"
limite := 200 
titulo := "IMPRESSAO DE ETIQUETAS DE TRANSPORTADORAS"
cDesc1 := oemtoansi("Este programa ira emitir as etiquetas de transportadoras")
cDesc2 := ""
cDesc3 := ""

cString:="SA2"
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog:="VIT169"
aLinha  := { }
nLastKey := 0
cPerg:="PERGVIT169"
_pergsx1()
pergunte(cperg,.f.)


//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Variaveis utilizadas para parametro                         �
//� mv_par01              Da ordem de producao                  �
//� mv_par02              Ate a ordem de producao               �
//� mv_par03              Do produto                            �
//� mv_par04              Ate o produto                         �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�

cCancel := "***** CANCELADO PELO OPERADOR *****"
wnrel:="VIT169"+Alltrim(cusername)
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
@ 000,000 PSAY chr(15)
cfilsa2:=xfilial("SA2")
sa2->(dbsetorder(2))
setregua(sa2->(lastrec()))
//sa2->(dbseek(cfilsa2+mv_par01,.t.))
aetiq1:={"","","","",""}
aetiq2:={"","","","",""}
aetiq3:={"","","","",""}
aetiq4:={"","","","",""}
i:=1                              
sa2->(dbgotop())
while ! sa2->(eof()) //.and. sa2->a2_cod<=mv_par02
	if substr(mv_par03,1,1) > substr(sa2->a2_nome,1,1)
		sa2->(dbskip())
		loop
	endif	
	_nome:=sa2->a2_nome
	_end:=sa2->a2_end
	_bairro:=sa2->a2_bairro
	_est:=sa2->a2_est
	_mun:=sa2->a2_mun
	_cep:=sa2->a2_cep
	if i==1
		aetiq1[1]:=alltrim(_nome)
		aetiq1[2]:=alltrim(_end)
		aetiq1[3]:=_bairro
		aetiq1[4]:=alltrim(_mun)+ ' - '+_est
		aetiq1[5]:='CEP:' +_cep
   elseif i==2
		aetiq2[1]:=alltrim(_nome)
		aetiq2[2]:=alltrim(_end)
		aetiq2[3]:=_bairro
		aetiq2[4]:=alltrim(_mun)+ ' - '+_est
		aetiq2[5]:="CEP: "+_cep
	elseif i==3
		aetiq3[1]:=alltrim(_nome)
		aetiq3[2]:=alltrim(_end)
		aetiq3[3]:=_bairro
		aetiq3[4]:=alltrim(_mun)+ ' - '+_est
		aetiq3[5]:="CEP: "+_cep
	else
		aetiq4[1]:=alltrim(_nome)
		aetiq4[2]:=alltrim(_end)
		aetiq4[3]:=_bairro
		aetiq4[4]:=alltrim(_mun)+ ' - '+_est
		aetiq4[5]:="CEP: "+_cep
   endif
	i:=i+1
	if i==5
		i:=1
      @ prow(),000   PSAY aetiq1[1]
		@ prow(),055   PSAY aetiq2[1]
		@ prow(),115   PSAY aetiq3[1]
		@ prow(),175   PSAY aetiq4[1]
		
		@ prow()+1,000 PSAY aetiq1[2]
		@ prow(),055   PSAY aetiq2[2]
		@ prow(),115   PSAY aetiq3[2]
		@ prow(),175   PSAY aetiq4[2]
		
		@ prow()+1,000 PSAY aetiq1[3]
		@ prow(),055   PSAY aetiq2[3]
		@ prow(),115   PSAY aetiq3[3]
		@ prow(),175   PSAY aetiq4[3]

		@ prow()+1,000 PSAY aetiq1[4]
		@ prow(),055   PSAY aetiq2[4]
		@ prow(),115   PSAY aetiq3[4]
		@ prow(),175   PSAY aetiq4[4]
		
		@ prow()+1,000 PSAY aetiq1[5]
		@ prow(),055   PSAY aetiq2[5]
		@ prow(),115   PSAY aetiq3[5]
		@ prow(),175   PSAY aetiq4[5]

		@ prow()+5,000 PSAY " "
		aetiq1:={"","","","",""}
		aetiq2:={"","","","",""}
		aetiq3:={"","","","",""}
		aetiq4:={"","","","",""}
	endif
	sa2->(dbskip())
end
if !empty(aetiq1[1])
   @ prow(),000   PSAY aetiq1[1]
	@ prow(),055   PSAY aetiq2[1]
	@ prow(),115   PSAY aetiq3[1]
	@ prow(),175   PSAY aetiq4[1]
		
	@ prow()+1,000 PSAY aetiq1[2]
	@ prow(),055   PSAY aetiq2[2]
	@ prow(),115   PSAY aetiq3[2]
	@ prow(),175   PSAY aetiq4[2]
		
	@ prow()+1,000 PSAY aetiq1[3]
	@ prow(),055   PSAY aetiq2[3]
	@ prow(),115   PSAY aetiq3[3]
	@ prow(),175   PSAY aetiq4[3]

	@ prow()+1,000 PSAY aetiq1[4]
	@ prow(),055   PSAY aetiq2[4]
	@ prow(),115   PSAY aetiq3[4]
	@ prow(),175   PSAY aetiq4[4]
		
	@ prow()+1,000 PSAY aetiq1[5]
	@ prow(),055   PSAY aetiq2[5]
	@ prow(),115   PSAY aetiq3[5]
	@ prow(),175   PSAY aetiq4[5]
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
aadd(_agrpsx1,{cperg,"01","Da Transportadora  ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"02","Ate a Transport.   ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})

	
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






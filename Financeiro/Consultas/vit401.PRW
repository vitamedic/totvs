/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT401   ³ Autor ³ Alberto Olegario      ³ Data ³ 19/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Consulta Orcado x Realizado por Natureza Baseado nos       ³±±
±±³          ³ Pedidos de Compra                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit401()
cperg:="PERGVIT401"
_pergsx1()
if pergunte(cperg,.t.)
	_cfilsa2:=xfilial("SA2")
	_cfilsc7:=xfilial("SC7")
	_cfilse7:=xfilial("SE7")
	_cfilsed:=xfilial("SED")   
	sa2->(dbsetorder(1))
	sc7->(dbsetorder(1))
	se7->(dbsetorder(1))
	sed->(dbsetorder(1))
	
	_aesttmp:={}
	aadd(_aesttmp,{"NATUREZA" ,"C",10,0})
	aadd(_aesttmp,{"DESCRICAO","C",30,0})
	aadd(_aesttmp,{"ORCADO"   ,"N",15,2})
	aadd(_aesttmp,{"REALIZADO","N",15,2})
   aadd(_aesttmp,{"PERCREA"  ,"N",10,2})
	aadd(_aesttmp,{"DIFERENCA","N",15,2})
	aadd(_aesttmp,{"PERCDIF"  ,"N",15,2})
	
	_carqtmp1:=criatrab(_aesttmp,.t.)
	dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)
	
	_carqtmp2:=""
	_cindtmp2:=""
	
	_ddataini  :=ctod("01/"+mv_par01+"/"+mv_par02)
	_ddatafim  :=lastday(_ddataini)
	_norcado   :=0
	_nrealizado:=0
	
	processa({|| _querys()})
	
	_npercrea  :=round(_nrealizado/_norcado,2)
	_ndiferenca:=_norcado-_nrealizado
	_npercdif  :=round(_ndiferenca/_norcado,2)
	
	_acampos1:={}
	aadd(_acampos1,{"NATUREZA" ,"Natureza" ,                       ,10,00})
	aadd(_acampos1,{"DESCRICAO","Descricao",                       ,30,00})
	aadd(_acampos1,{"ORCADO"   ,"Orcado"   ,"@E 999,999,999,999.99",15,02})
	aadd(_acampos1,{"REALIZADO","Realizado","@E 999,999,999,999.99",15,02})
   aadd(_acampos1,{"PERCREA"  ,"% realiz.","@E 9999999.99"      ,10,02})
	aadd(_acampos1,{"DIFERENCA","Diferenca","@E 9999,999,999,999.99",15,02})
   aadd(_acampos1,{"PERCDIF"  ,"% difer." ,"@E 9999999.99"    ,10,02})
	
	tmp1->(dbgotop())
	
	@ 020,002 to 520,790 dialog odlg title "Orcado X realizado"
	
	@ 002,002 say "Mes/ano: "+mv_par01+"/"+mv_par02+" | "+;
                      "Orcado: "+transform(_norcado,"@E 999,999,999.99")+" | "+;
                      "Realizado: "+transform(_nrealizado,"@E 999,999,999.99")+" | "+;
                      "% real.: "+transform(_npercrea,"@E 9999999.99")+" | "+;
                      "Diferenca: "+transform(_ndiferenca,"@E 9999,999,999.99")+" | "+;
                      "% dif.: "+transform(_npercdif,"@E 9999999.99")
	@ 010,002 to 228,393 browse "TMP1" fields _acampos1
	
	@ 233,002 bmpbutton type 1 action close(odlg)
	@ 233,035 bmpbutton type 6 action _imprime()
	
	activate dialog odlg
	
	_cindtmp2+=tmp2->(ordbagext())
	tmp1->(dbclosearea())
	tmp2->(dbclosearea())
	ferase(_carqtmp1+".dbf")
	ferase(_carqtmp2+".dbf")
	ferase(_cindtmp2)
endif
return


static function _imprime()
_nregtmp1:=tmp1->(recno())
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="ORCADO X REALIZADO DO MES "+mv_par01+" DO ANO "+mv_par02
cdesc1  :="Este programa ira emitir a relacao de orcado X realizado"
cdesc2  :=""
cdesc3  :=""
cstring :="SC7"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT401"
wnrel   :="VIT401"+Alltrim(cusername)
alinha  :={}
nlastkey:=0
lcontinua:=.t.

cperg:=""

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)

if nlastkey==27
	set filter to
	return
endif

rptstatus({|| rptdetail()})
tmp1->(dbgoto(_nregtmp1))
return

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:="NATUREZA   DESCRICAO                              ORCADO      REALIZADO % REAL.      DIFERENCA  % DIF."
cabec2:=""

_ntotorc:=0
_ntotrea:=0

setprc(0,0)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
		lcontinua
	incregua()
	if prow()==0 .or. prow()>55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY tmp1->natureza
	@ prow(),011   PSAY tmp1->descricao
	@ prow(),042   PSAY tmp1->orcado    picture "@E 999,999,999.99"
	@ prow(),057   PSAY tmp1->realizado	picture "@E 999,999,999.99"
   @ prow(),072   PSAY tmp1->percrea   picture "@E 9999999.99"
	@ prow(),080   PSAY tmp1->diferenca picture "@E 9999,999,999.99"
   @ prow(),095   PSAY tmp1->percdif   picture "@E 9999999.99"
	_ntotorc+=tmp1->orcado
	_ntotrea+=tmp1->realizado
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end

if prow()>0 .and.;
	lcontinua
	_ntotdif :=_ntotorc-_ntotrea
	_npercrea:=round(_ntotrea/_ntotorc,2)
	_npercdif:=round(_ntotdif/_ntotorc,2)
	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "TOTAIS"
	@ prow(),042   PSAY _ntotorc  picture "@E 999,999,999.99"
	@ prow(),057   PSAY _ntotrea  picture "@E 999,999,999.99"
   @ prow(),072   PSAY _npercrea   picture "@E 9999999.99"
	@ prow(),080   PSAY _ntotdif  picture "@E 999,999,999.99"
   @ prow(),095   PSAY _npercdif picture "@E 9999999.99"
	roda(cbcont,cbtxt)
endif

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()
return

static function _querys()
procregua(2)

incproc("Verificando pedidos...")

_cquery:=" SELECT"
_cquery+=" A2_NATORC NATUREZA,SUM(C7_TOTAL) VALOR"
_cquery+=" FROM "
_cquery+=  retsqlname("SA2")+" SA2,"
_cquery+=  retsqlname("SC7")+" SC7"
_cquery+=" WHERE"
_cquery+="     SA2.D_E_L_E_T_<>'*'"
_cquery+=" AND SC7.D_E_L_E_T_<>'*'"
_cquery+=" AND A2_FILIAL='"+_cfilsa2+"'"
_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
_cquery+=" AND C7_FORNECE=A2_COD"
_cquery+=" AND C7_LOJA=A2_LOJA"
_cquery+=" AND C7_EMISSAO BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"
_cquery+=" AND A2_NATORC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" GROUP BY A2_NATORC"
_cquery+=" ORDER BY A2_NATORC"

_cquery:=changequery(_cquery)

tcquery _cquery alias "TMP2" new
tcsetfield("TMP2","VALOR","N",12,2)

_carqtmp2:=criatrab(,.f.)
copy to &_carqtmp2
tmp2->(dbclosearea())
dbusearea(.t.,,_carqtmp2,"TMP2",.f.,.f.)
_cindtmp2:=criatrab(,.f.)
_cchave  :="NATUREZA"
tmp2->(indregua("TMP2",_cindtmp2,_cchave,,,"Selecionando registros..."))

incproc("Verificando pedidos...")

sed->(dbseek(_cfilsed+mv_par03,.t.))
while ! sed->(eof()) .and.;
		sed->ed_filial==_cfilsed .and.;
		sed->ed_codigo<=mv_par04
	tmp1->(dbappend())
	tmp1->natureza :=sed->ed_codigo
	tmp1->descricao:=sed->ed_descric
	if se7->(dbseek(_cfilse7+sed->ed_codigo+mv_par02))
		if mv_par01=="01"
			tmp1->orcado:=se7->e7_valjan1
		elseif mv_par01=="02"
			tmp1->orcado:=se7->e7_valfev1
		elseif mv_par01=="03"
			tmp1->orcado:=se7->e7_valmar1
		elseif mv_par01=="04"
			tmp1->orcado:=se7->e7_valabr1
		elseif mv_par01=="05"
			tmp1->orcado:=se7->e7_valmai1
		elseif mv_par01=="06"
			tmp1->orcado:=se7->e7_valjun1
		elseif mv_par01=="07"
			tmp1->orcado:=se7->e7_valjul1
		elseif mv_par01=="08"
			tmp1->orcado:=se7->e7_valago1
		elseif mv_par01=="09"
			tmp1->orcado:=se7->e7_valset1
		elseif mv_par01=="10"
			tmp1->orcado:=se7->e7_valout1
		elseif mv_par01=="11"
			tmp1->orcado:=se7->e7_valnov1
		elseif mv_par01=="12"
			tmp1->orcado:=se7->e7_valdez1
		endif
	endif
	if tmp2->(dbseek(sed->ed_codigo))
		tmp1->realizado:=tmp2->valor
	endif
	tmp1->percrea  :=round((tmp1->realizado/tmp1->orcado)*100,2)
	tmp1->diferenca:=tmp1->orcado-tmp1->realizado
	tmp1->percdif  :=round((tmp1->diferenca/tmp1->orcado)*100,2)
	_norcado   +=tmp1->orcado
	_nrealizado+=tmp1->realizado
	sed->(dbskip())
end
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Mes                ?","mv_ch1","C",02,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ano                ?","mv_ch2","C",04,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da natureza        ?","mv_ch3","C",10,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SED"})
aadd(_agrpsx1,{cperg,"04","Ate a natureza     ?","mv_ch4","C",10,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SED"})
	
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
NATUREZA   DESCRICAO                              ORCADO      REALIZADO % REAL.      DIFERENCA  % DIF.
9999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999,99 999.999.999,99 9999,99 999.999.999,99 9999,99
*/

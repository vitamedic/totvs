/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT248   ³ Autor ³ Aline B. Pereira      ³ Data ³ 01/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Fretes / Transportadora e Periodo               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function VIT248()
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="TRANSPORTADORA/UF/CLIENTES"
cdesc1   :="Este programa ira emitir o relação de fretes/transportadora/UF/Clientes"
cdesc2   :="  "
cdesc3   :=""
cstring  :="SF2"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT248"
wnrel    :="VIT248"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT248"
_pergsx1()
pergunte(cperg,.f.)



wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)


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
return

static function rptdetail()
_cfilsa1:=xfilial("SA1")
_cfilsa2:=xfilial("SA2")
_cfilsf2:=xfilial("SF2")
_cfilsa4:=xfilial("SA4")
sa1->(dbsetorder(1))
sa2->(dbsetorder(1))
sa4->(dbsetorder(1))
sf2->(dbsetorder(1))

processa({|| _querys()})

sa4->(dbseek(_cfilsa4+mv_par07))
cabec1:="Período: "+dtoc(mv_par01) + " a "+dtoc(mv_par02)
cabec2:="Codg.     Cliente                                  Emissao  Entrega  Dias Transportadora                        Conhec.   No. NF    Ser        Peso  Volume  Valor Nota  Vl.Conhec.   Desconto   %    Cidade/UF"
//Codg.     Cliente                                  Emissao  Entrega  Dias Transportadora                        Conhec.   No. NF    Ser        Peso  Volume  Valor Nota  Vl.Conhec.   Desconto   %    Cidade/UF
//999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 999  999999-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999999999 999999999 999  999.999.99  999999  999.999,99  999.999,99 999.999,99 999,99 XXXXXXXXXXXXXXXXXX XX


setprc(0,0)
_total:=0
_totfrete:=0
_totdescfr:=0
_tnota:=0
_tconhe:=0
_tdescfr:=0
_tpeso:=0
_tvolume:=0
_1total:=0
_1totfrete:=0
_1totdescfr:=0
_1tnota:=0
_1tdescfr:=0
_1tpeso:=0
_1tvolume:=0

_muf:=""
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	
	if prow()==0 .or. prow()>53
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_transp:=tmp1->transp
	_passou :=.t.
	
	sa4->(dbseek(_cfilsa4+tmp1->transp))
	_tnota:=0
	_tconhe:=0
	_tdesconhe:=0
	_numfret:=tmp1->numfret
	_serfret:=tmp1->serfret
	if tmp1->uf <> _muf
		_muf:=tmp1->uf
		if !empty(_1total)
			if prow()>59
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
			endif
			
			@ prow()+1,000 PSAY "TOTAL ESTADO ===>"
			@ prow(),137 PSAY _1tpeso picture "@E 999,999.99"
			@ prow(),149 PSAY _1tvolume picture "@E 999999"
			@ prow(),157 PSAY _1total picture "@E 999,999.99"
			@ prow(),169 PSAY _1totfrete picture "@E 999,999.99"
			@ prow(),180 PSAY _1totdescfr picture "@E 999,999.99"
			@ prow(),191 PSAY ((_1totfrete-_1totdescfr)/_1total)*100 picture "@E 999.99"
			@ prow()+1,000 PSAY " "
			
			_1total:=0
			_1totfrete:=0
			_1totdescfr:=0
			_1tnota:=0
			_1tdescfr:=0
			_1tpeso:=0
			_1tvolume:=0
			
			
		endif
	endif	              
	if tmp1->tp="N"
		sa1->(dbseek(_cfilsa1+tmp1->cliente))
		_mcli :=sa1->a1_nome
		_mmun:=sa1->a1_mun
	else
		sa2->(dbseek(_cfilsa2+tmp1->cliente))
		_mcli :=sa2->a2_nome
		_mmun:=sa2->a2_mun
	endif	


	@ prow()+1,000 PSAY tmp1->cliente+"-"+tmp1->loja
	@ prow(),010 PSAY substr(_mcli,1,40)
	@ prow(),051 PSAY tmp1->emissao
	@ prow(),060 PSAY tmp1->entrega
	@ prow(),069 PSAY if(!empty(tmp1->entrega),tmp1->entrega-tmp1->emissao,"") picture "@E 999"
	@ prow(),074 PSAY tmp1->transp+"-"+substr(sa4->a4_nome,1,30)
	@ prow(),112 PSAY tmp1->numfret
	@ prow(),122 PSAY tmp1->doc
	@ prow(),132 PSAY tmp1->serie
	@ prow(),137 PSAY tmp1->pbruto picture "@E 999,999.99"
	@ prow(),149 PSAY tmp1->volume1 picture "@E 999999"
	@ prow(),157 PSAY tmp1->valbrut picture "@E 999,999.99"
	@ prow(),169 PSAY tmp1->vlfrete picture "@E 999,999.99"
	@ prow(),180 PSAY tmp1->descfr picture "@E 999,999.99"
	@ prow(),191 PSAY ((tmp1->vlfrete-tmp1->descfr)/tmp1->valbrut)*100 picture "@E 999.99"
	@ prow(),198 PSAY substr(alltrim(_mmun),1,18)
	@ prow(),217 PSAY tmp1->uf
	_tconhe+=tmp1->vlfrete
	_tdesconhe+=tmp1->descfr
	
	_1total+=tmp1->valbrut
	_1totfrete+=tmp1->vlfrete
	_1totdescfr+=tmp1->descfr
	_1tnota+=tmp1->valbrut
	_1tdescfr+=tmp1->descfr
	_1tpeso+=tmp1->pbruto
	_1tvolume+=tmp1->volume1
	
	
	_total+=tmp1->valbrut
	_totfrete+=tmp1->vlfrete
	_totdescfr+=tmp1->descfr
	_tnota+=tmp1->valbrut
	_tdescfr+=tmp1->descfr
	_tpeso+=tmp1->pbruto
	_tvolume+=tmp1->volume1
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end

if !empty(_1total)
	if prow()>59
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	
	@ prow()+1,000 PSAY "TOTAL ESTADO ===>"
	@ prow(),137 PSAY _1tpeso picture "@E 999,999.99"
	@ prow(),149 PSAY _1tvolume picture "@E 999999"
	@ prow(),157 PSAY _1total picture "@E 999,999.99"
	@ prow(),169 PSAY _1totfrete picture "@E 999,999.99"
	@ prow(),180 PSAY _1totdescfr picture "@E 999,999.99"
	@ prow(),191 PSAY ((_1totfrete-_1totdescfr)/_1total)*100 picture "@E 999.99"

	_1total:=0
	_1totfrete:=0
	_1totdescfr:=0
	_1tnota:=0
	_1tdescfr:=0
	_1tpeso:=0
	_1tvolume:=0
endif


if lcontinua .and. !empty(_total)
	@ prow()+2,000 PSAY "TOTAL GERAL ===>"
	@ prow(),137 PSAY _tpeso picture "@E 999,999.99"
	@ prow(),149 PSAY _tvolume picture "@E 999999"
	@ prow(),157 PSAY _total picture "@E 999,999.99"
	@ prow(),169 PSAY _totfrete picture "@E 999,999.99"
	@ prow(),180 PSAY _totdescfr picture "@E 999,999.99"
	@ prow(),191 PSAY ((_totfrete-_totdescfr)/_total)*100 picture "@E 999.99"
endif
if prow()>0 .and.;
	lcontinua
	roda(cbcont,cbtxt)
endif

tmp1->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()
return



static function _querys()
_cquery:=" SELECT"
_cquery+=" F2_DOC DOC,F2_CLIENTE CLIENTE,F2_LOJA LOJA,F2_VALBRUT VALBRUT,F2_NUMFRET NUMFRET,F2_SERIE SERIE,"
_cquery+=" F2_SERFRET SERFRET,F2_EMISSAO EMISSAO,F2_VLFRETE VLFRETE,F2_VOLUME1 VOLUME1,F2_PBRUTO PBRUTO,"
_cquery+=" F2_DESCFR DESCFR,F2_DESCPG DESCPG,F2_TRANSP TRANSP,F2_EST UF,F2_TIPO TP,F2_DTENTRG ENTREGA"
_cquery+=" FROM "
_cquery+=  retsqlname("SF2")+" SF2"
_cquery+=" WHERE"
_cquery+="     SF2.D_E_L_E_T_<>'*'"
_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
_cquery+=" AND F2_TRANSP BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND F2_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par05+"'"
_cquery+=" AND F2_LOJA BETWEEN '"+mv_par04+"' AND '"+mv_par06+"'"
_cquery+=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND F2_EST BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
_cquery+=" ORDER BY F2_EST,F2_CLIENTE,F2_TRANSP,F2_SERFRET,F2_EMISSAO"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","ENTREGA","D")
tcsetfield("TMP1","VALBRUT","N",15,2)
tcsetfield("TMP1","VLFRETE","N",15,2)
tcsetfield("TMP1","VOLUME1","N",15,0)
tcsetfield("TMP1","PBRUTO" ,"N",15,2)
tcsetfield("TMP1","DESCFR" ,"N",15,2)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do cliente         ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"04","Da loja            ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"05","Ate o cliente      ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"06","Ate a loja         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"07","Da Transportadora  ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
aadd(_agrpsx1,{cperg,"08","Ate Transportadora ?","mv_ch8","C",06,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
aadd(_agrpsx1,{cperg,"09","Do Estado          ?","mv_ch9","C",02,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"12 "})
aadd(_agrpsx1,{cperg,"10","Ate Estado         ?","mv_chA","C",02,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"12 "})
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




/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT140   ³ Autor ³ Gardenia Ilany          Data ³ 10/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Fornecedores / Ranking                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT140()
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="RELACAO DE FORNECEDORES / RANKING"
cdesc1  :="Este programa ira emitir a relacao de fornecedores / ranking"
cdesc2  :=""
cdesc3  :=""
cstring :="SD1"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT140"
wnrel   :="VIT140"+Alltrim(cusername)
alinha  :={}
aordem  :={"Valor"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGVIT140"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
//	tcquit()
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

if nlastkey==27
	set filter to
//	tcquit()
	return
endif

rptstatus({|| rptdetail()})
//tcquit()
return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:="PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)
cabec2:="Codigo Descricao                                               Valor Media Periodo       % Repres.   % Acumulado" 

_cfilsa2:=xfilial("SA2")
_cfilsd1:=xfilial("SD1")
_cfilsf1:=xfilial("SF1")
_cfilsbm:=xfilial("SBM")
sa2->(dbsetorder(1))
sf1->(dbsetorder(1))
sd1->(dbsetorder(3))
sbm->(dbsetorder(1))

_aestrut :={}
aadd(_aestrut,{"FORNECE","C",06,0})
aadd(_aestrut,{"LOJA"      ,"C",02,0})
aadd(_aestrut,{"GRUPO"     ,"C",4,0})
aadd(_aestrut,{"DESCRICAO" ,"C",40,0})
aadd(_aestrut,{"DESCGRUPO" ,"C",40,0})
aadd(_aestrut,{"VALOR"     ,"N",12,2})
aadd(_aestrut,{"ORDEMVAL"  ,"N",06,0})

_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)

_cindtmp11:=criatrab(,.f.)
_cchave  :="fornece+loja"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))

_cindtmp12:=criatrab(,.f.)
_cchave  :="strzero(valor,12,2)+fornece+loja"
tmp1->(indregua("TMP1",_cindtmp12,_cchave))

tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetindex(_cindtmp12))

tmp1->(dbsetorder(1))
_ntotal:=0     
_peracum:=0
setregua(sd1->(lastrec()))
sd1->(dbseek(_cfilsd1+dtos(mv_par01),.t.))
while ! sd1->(eof()) .and.;
		sd1->d1_filial==_cfilsd1 .and.;
		sd1->d1_emissao<=mv_par02
	incregua()
	sf1->(dbseek(_cfilsf1+sd1->d1_doc+sd1->d1_serie+sd1->d1_fornece+sd1->d1_loja))
	if sf1->f1_tipo =="D" 
		sd1->(dbskip())		
		loop
	endif

	if mv_par09 ==2
		if sf1->f1_especie =="CTR  " .or. sf1->f1_especie =="CFST "
			sd1->(dbskip())		
			loop
		endif
	elseif mv_par09 ==1
		if sf1->f1_especie <>"CTR  " .and. sf1->f1_especie <>"CFST "
			sd1->(dbskip())		
			loop
		endif		
	endif		
//	msgstop(sf1->f1_especie)
	if sd1->d1_fornece>=mv_par03 .and.;
		sd1->d1_fornece<=mv_par04 .and.;
		sd1->d1_tp>=mv_par05 .and.;
		sd1->d1_tp<=mv_par06 .and.;		
		sd1->d1_grupo>=mv_par07 .and.;
		sd1->d1_grupo<=mv_par08 
		sa2->(dbseek(_cfilsa2+sd1->d1_fornece+sd1->d1_loja))
		sbm->(dbseek(_cfilsbm+sd1->d1_grupo))
		if ! tmp1->(dbseek(sd1->d1_fornece+sd1->d1_loja))
	  			tmp1->(dbappend())
			tmp1->fornece  :=sd1->d1_fornece
			tmp1->loja     :=sd1->d1_loja 
			tmp1->descricao:=sa2->a2_nome
			tmp1->grupo    :=sd1->d1_grupo
			tmp1->descgrupo:=sbm->bm_desc  
			tmp1->valor    :=sd1->d1_total
		else
			tmp1->valor    +=sd1->d1_total
		endif
		_ntotal+=sd1->d1_total
	endif
	sd1->(dbskip())
end

_nordemval:=1
tmp1->(dbsetorder(2))
tmp1->(dbgobottom())
while ! tmp1->(bof())
	tmp1->ordemval:=_nordemval
	_nordemval++
	tmp1->(dbskip(-1))
end
if nordem==1
	tmp1->(dbsetorder(2))
	tmp1->(dbgobottom())
	_ccond:="! tmp1->(bof())"
endif
_ntotquant:=0
_ntotvalor:=0
_nconta:=1     
_nmeses:=(mv_par02-mv_par01)/30
while &_ccond
	incregua()
	if prow()==0 .or. prow()>55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif  
	@ prow()+1,000 PSAY strzero(_nconta,3,0) picture "999"
	_nconta++
	@ prow(),004 PSAY left(tmp1->fornece,6)
	@ prow(),011   PSAY tmp1->loja
	@ prow(),014   PSAY tmp1->descricao
//	@ prow(),052   PSAY tmp1->grupo
//	@ prow(),057   PSAY substr(tmp1->descgrupo,1,30)
	@ prow(),056   PSAY tmp1->valor    picture "@E 9,999,999.99"
	if _nmeses < 1
	 	_nmeses :=1
	endif 	
	@ prow(),069   PSAY (tmp1->valor/_nmeses)    picture "@E 9,999,999.99"
	@ prow(),090   PSAY (tmp1->valor/_ntotal)*100    picture "@R 999.99 %"
	_ntotvalor+=tmp1->valor
	_peracum+= (tmp1->valor/_ntotal)*100 
	@ prow(),105   PSAY _peracum   picture "@R 999.99 %"
	tmp1->(dbskip(-1))
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end
if prow()>0 .and.;
	lcontinua
	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "TOTAL"
	@ prow(),056   PSAY _ntotvalor picture "@E 9,999,999,999.99"
	roda(cbcont,cbtxt)
endif


_cext:=tmp1->(ordbagext())
tmp1->(dbclosearea())
ferase(_carqtmp1+getdbextension())
ferase(_cindtmp11+_cext)
ferase(_cindtmp12+_cext)
	
set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do fornecedor      ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"04","Ate o fornecedor   ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"05","Do tipo            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Ate o tipo         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"07","Do grupo           ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"08","Ate o grupo        ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"09","Transportadora     ?","mv_ch9","N",01,0,3,"C",space(60),"mv_par09"       ,"Sim"            ,space(30),space(15),"Não"            ,space(30),space(15),"Todos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
Codigo Descricao                                Principio ativo                          Quantidade          Valor Ord.Qtd. Ord.Val.
999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999.999,99 999.999.999,99  999999   999999
*/

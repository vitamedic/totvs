/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT096   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 05/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Preco Medio de Venda de Produtos por Representante         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit096()
nordem  :=""
tamanho :="P"
limite  :=80
titulo  :="VENDA DE PRODUTOS "
cdesc1  :="Este programa ira emitir a relacao de Venda de produtos"
cdesc2  :=""
cdesc3  :=""
cstring :="SD2"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT096"
wnrel   :="VIT096"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGVIT096"
_pergsx1()
pergunte(cperg,.f.)
/*if mv_par11=="2"
	if sm0->m0_codigo<>"02" .or.;
		(upper(alltrim(getenvserver()))<>"BACKUP" .and. upper(alltrim(getenvserver()))<>"BKP")
		msgstop("Programa não habilitado para esta filial!")
		return
	endif
	if tclink("oracle/dadosadv","192.168.1.20")<>0
		msgstop("Falha de conexao com o banco!")
		tcquit()
		return
	endif
endif
*/
wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	if mv_par11=="2"
		tcquit()
	endif
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

if nlastkey==27
	set filter to
	if mv_par11=="2"
		tcquit()
	endif
	return
endif

rptstatus({|| rptdetail()})
if mv_par11=="2"
	tcquit()
endif
return

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:="PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)
cabec2:="Ordem Codigo Descricao                                 Quantidade"
//  Valor vendido Preco Medio   %    % acum"

_cfilsb1:=xfilial("SB1")
_cfilsd2:=xfilial("SD2")
_cfilsf4:=xfilial("SF4")
_cfilsa3:=xfilial("SA3")
_cfilsf2:=xfilial("SF2")
sb1->(dbsetorder(1))
sd2->(dbsetorder(5))
sf4->(dbsetorder(1))
sa3->(dbsetorder(1))
sf2->(dbsetorder(1))
if mv_par11=="2"
	_abretop("SD2010",5)
	_abretop("SF2010",1)
	_abretop("SF4010",1)
endif

_aestrut:={}
aadd(_aestrut,{"PRODUTO"  ,"C",15,0})
aadd(_aestrut,{"DESCRICAO","C",40,0})
aadd(_aestrut,{"QUANT"    ,"N",09,0})
aadd(_aestrut,{"VENDEDOR" ,"C",06,0})
aadd(_aestrut,{"TIPO     ","C",01,0})

_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
_cindtmp11:=criatrab(,.f.)
_cchave   :="vendedor+produto"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))

_cindtmp12:=criatrab(,.f.)
_cchave   :="vendedor+tipo+strzero(quant,09)"
tmp1->(indregua("TMP1",_cindtmp12,_cchave))

tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetindex(_cindtmp12))
tmp1->(dbsetorder(1))

_ntotquant:=0

_cindsb1:=criatrab(,.f.)
_cchave :="b1_filial+b1_cod"
_cfiltro:="b1_tipo=='PA'"
sb1->(indregua("SB1",_cindsb1,_cchave,,_cfiltro))


// PESQUISA CODIGO DO SUPERVISOR
sa3->(dbsetorder(7))
if sa3->(dbseek(_cfilsa3+__cuserid))
	_cgerente:=sa3->a3_cod
else
	_cgerente:=space(6)
endif

processa({|| _calcmov()})

setregua(tmp1->(lastrec()))

setprc(0,0)

tmp1->(dbsetorder(2))

_i     :=1
_npacum:=0

_cvend := space(06)
_nqtlinha := 0
_ntipo:=" "
tmp1->(dbgobottom())
while ! tmp1->(bof()) .and.;
	lcontinua
	incregua()
	if prow()>60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif
	if _cvend <> tmp1->vendedor
		if _ntotquant>0
			_impzero()
			_ntipo:=tmp1->tipo
			@ prow()+1,000 PSAY "TOTAL LINHA:"
			@ prow(),054   PSAY _ntotquant picture "@E 999,999,999"
			@ prow()+1,000 PSAY ""
			_nqtlinha +=_ntotquant
			_ntotquant:=0
			_i := 0
		endif
		if !empty(_nqtlinha)
			@ prow()+1,000 PSAY replicate("-",limite)
			@ prow()+1,000 PSAY "TOTAL"
			@ prow(),054   PSAY _nqtlinha picture "@E 999,999,999"
			_nqtlinha +=_ntotquant
			_ntotquant:=0
		endif
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
		_cvend:=tmp1->vendedor
		sa3->(dbseek(_cfilsa3+_cvend))
		_ntipo:=tmp1->tipo
		@ prow()+2,000 PSAY "REPRESENTANTE: "+_cvend+" - "+sa3->a3_nome
		_aprodlin:={}
	endif
	if _ntipo<>tmp1->tipo .and. _ntotquant>0
		_impzero()
		_ntipo:=tmp1->tipo
		@ prow()+1,000 PSAY "TOTAL LINHA:"
		@ prow(),054   PSAY _ntotquant picture "@E 999,999,999"
		@ prow()+1,000 PSAY ""
		_nqtlinha +=_ntotquant
		_ntotquant:=0
		_i:=0
	endif
	@ prow()+1,000 PSAY _i          picture "99999"
	@ prow(),006   PSAY left(tmp1->produto,6)
	@ prow(),013   PSAY tmp1->descricao
	@ prow(),054   PSAY tmp1->quant picture "@E 999,999,999"
	aadd(_aprodlin,tmp1->produto)
	_ntotquant+=tmp1->quant
	_i++
	tmp1->(dbskip(-1))
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if prow()>0 .and.;
	lcontinua
	if _ntotquant>0
		_impzero()
		_ntipo = tmp1->tipo
		@ prow()+1,000 PSAY "TOTAL LINHA:"
		@ prow(),054   PSAY _ntotquant picture "@E 999,999,999"
		@ prow()+1,000 PSAY ""
		_nqtlinha += _ntotquant
		_ntotquant = 0
	endif
	if !empty(_nqtlinha)
		@ prow()+1,000 PSAY replicate("-",limite)
		@ prow()+1,000 PSAY "TOTAL"
		@ prow(),054   PSAY _nqtlinha picture "@E 999,999,999"
		_nqtlinha += _ntotquant
		_ntotquant = 0
	endif
	roda(cbcont,cbtxt)
endif

_cindtmp11+=tmp1->(ordbagext())
if nordem>1
	_cindtmp12+=tmp1->(ordbagext())
endif
tmp1->(dbclosearea())
ferase(_carqtmp1+getdbextension())
ferase(_cindtmp11)
if nordem>1
	ferase(_cindtmp12)
endif

_cindsb1+=sb1->(ordbagext())
sb1->(retindex("SB1"))
ferase(_cindsb1)

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

static function _impzero()
sb1->(dbseek(_cfilsb1))
while ! sb1->(eof()) .and.;
	sb1->b1_filial==_cfilsb1
	if sb1->b1_cod>=mv_par05 .and.;
		sb1->b1_cod<=mv_par06
		if sb1->b1_apreven==_ntipo
			_j:=ascan(_aprodlin,sb1->b1_cod)
			if _j==0
				if prow()>60
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
				endif
				@ prow()+1,000 PSAY _i          picture "99999"
				@ prow(),006   PSAY left(sb1->b1_cod,6)
				@ prow(),013   PSAY sb1->b1_desc
				@ prow(),054   PSAY 0           picture "@E 999,999,999"
				_i++
			endif
		endif
	endif
	sb1->(dbskip())
end
return


static function _calcmov()
procregua(2)
incproc("Calculando faturamento...")
_ddataini:=mv_par01
_ddatafim:=mv_par02
/*if mv_par11=="2"
	sd2010->(dbseek(_cfilsd2+dtos(_ddataini),.t.))
	while ! sd2010->(eof()) .and.;
		sd2010->d2_filial==_cfilsd2 .and.;
		sd2010->d2_emissao<=_ddatafim
		// Valida Gerente Regional
		sf2010->(dbseek(_cfilsf2+sd2010->d2_doc+sd2010->d2_serie))
		sa3010->(dbsetorder(1))
		sa3010->(dbseek(_cfilsa3+sf2010->f2_vend1))
		_mger:=if(empty(_cgerente),.t.,sa3010->a3_super==_cgerente) // Valida Gerente Regional
		if _mger .and.;
			sd2010->d2_cod>=mv_par05 .and.;
			sd2010->d2_cod<=mv_par06
			sf4010->(dbseek(_cfilsf4+sd2010->d2_tes))
			if sf4010->f4_duplic=="S"
				sf2010->(dbseek(_cfilsf2+sd2010->d2_doc+sd2010->d2_serie))
				_cvend:=sf2010->(fieldget(fieldpos("F2_VEND"+alltrim(str(mv_par09,1)))))
				sb1->(dbseek(_cfilsd2+sd2010->d2_cod))
				if _cvend>=mv_par03 .and.;
					_cvend<=mv_par04
					sb1->(dbseek(_cfilsd2+sd2010->d2_cod))
					if tmp1->(dbseek(_cvend+sd2010->d2_cod))
						tmp1->quant+=sd2010->d2_quant
					else
						tmp1->(dbappend())
						tmp1->vendedor :=_cvend
						tmp1->descricao:=sb1->b1_desc
						tmp1->tipo     :=sb1->b1_apreven
						tmp1->produto  :=sd2010->d2_cod
						tmp1->quant    :=sd2010->d2_quant
					endif
				endif
			endif
		endif
		sd2010->(dbskip())
	end
endif
*/

incproc("Calculando faturamentos...")
sd2->(dbseek(_cfilsd2+dtos(_ddataini),.t.))
while ! sd2->(eof()) .and.;
	sd2->d2_filial==_cfilsd2 .and.;
	sd2->d2_emissao<=_ddatafim
	// Valida Gerente Regional
	sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
	sa3->(dbsetorder(1))
	sa3->(dbseek(_cfilsa3+sf2->f2_vend1))
	_mger:=if(empty(_cgerente),.t.,sa3->a3_super==_cgerente) // Valida Gerente Regional
	if _mger .and.;
		sd2->d2_cod>=mv_par05 .and.;
		sd2->d2_cod<=mv_par06
		sf4->(dbseek(_cfilsf4+sd2->d2_tes))
		if sf4->f4_duplic=="S"
			sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
			_cvend:=sf2->(fieldget(fieldpos("F2_VEND"+alltrim(str(mv_par09,1)))))
			sb1->(dbseek(_cfilsd2+sd2->d2_cod))
			if _cvend>=mv_par03 .and.;
				_cvend<=mv_par04
				if tmp1->(dbseek(_cvend+sd2->d2_cod))
					tmp1->quant+=sd2->d2_quant
				else
					tmp1->(dbappend())
					tmp1->vendedor :=_cvend
					tmp1->descricao:=sb1->b1_desc
					tmp1->tipo     :=sb1->b1_apreven
					tmp1->produto  :=sd2->d2_cod
					tmp1->quant    :=sd2->d2_quant
				endif
			endif
		endif
	endif
	sd2->(dbskip())
end
return

static function _abretop(_carq,_nordem)
_calias:=left(_carq,3)
dbusearea(.t.,"TOPCONN",_carq,_carq,.t.,.f.)
six->(dbseek(_calias))
while ! six->(eof()) .and.;
	six->indice==_calias
	dbsetindex(_carq+six->ordem)
	six->(dbskip())
end
dbsetorder(_nordem)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do vendedor        ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"04","Ate o vendedor     ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"05","Do produto         ?","mv_ch5","C",15,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"06","Ate o produto      ?","mv_ch6","C",15,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"07","Do documento       ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o documento    ?","mv_ch8","C",06,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Considera vendedor ?","mv_ch9","N",01,0,0,"C",space(60),"mv_par09"       ,"Vendedor 1"     ,space(30),space(15),"Vendedor 2"     ,space(30),space(15),"Vendedor 3"     ,space(30),space(15),"Vendedor 4"     ,space(30),space(15),"Vendedor 5"     ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Salta pagina       ?","mv_chA","N",01,0,0,"C",space(60),"mv_par10"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Grade              ?","mv_chB","C",01,0,0,"G",space(60),"mv_par11"       ,"1"              ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
Ordem Codigo Descricao                                 Quantidade  Valor vendido Preco Medio   %    % acum
99999 999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999.999.999 999.999.999,99  999.999,99 999,99 999,99
*/

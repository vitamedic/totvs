/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT157   ³ Autor ³ Aline B. Pereira      ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Vendas por Gerente e Representante            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit157()
nordem  :=""
tamanho :="P"
limite  :=80
titulo  :="RELATORIO DE VENDAS "
cdesc1  :="Este programa ira emitir a relacao de Venda por Gerente Regional e Representante"
cdesc2  :=""
cdesc3  :=""
cstring :="SD2"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT157"
wnrel   :="VIT157"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGVIT157"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

if nlastkey==27
	set filter to
	return
endif

rptstatus({|| rptdetail()})
//tcquit()
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

cabec2:="Ordem Codigo Nome                      Farma  Lic.Farma  Lic.Hosp.       Total"
//  Valor vendido Preco Medio   %    % acum"

_cfilsb1:=xfilial("SB1")
_cfilsa1:=xfilial("SA1")
_cfilsd2:=xfilial("SD2")
_cfilsf4:=xfilial("SF4")
_cfilsa3:=xfilial("SA3")
_cfilsf2:=xfilial("SF2")
_cfilsc5:=xfilial("SC5")
_cfilda0:=xfilial("DA0")
sa1->(dbsetorder(1))
sb1->(dbsetorder(1))
sd2->(dbsetorder(3))
sf4->(dbsetorder(1))
sa3->(dbsetorder(1))
sf2->(dbsetorder(4))
sc5->(dbsetorder(1))
da0->(dbsetorder(1))


_aestrut:={}
aadd(_aestrut,{"CLIENTE"  ,"C",6,0})
aadd(_aestrut,{"PEDIDO"  ,"C",6,0})
aadd(_aestrut,{"LOJA"  ,"C",2,0})
aadd(_aestrut,{"NOME","C",30,0})
//aadd(_aestrut,{"VALORPF"    ,"N",11,2})
//aadd(_aestrut,{"VALORPH"    ,"N",11,2})
aadd(_aestrut,{"VALORFF"    ,"N",11,2})
aadd(_aestrut,{"VALICH"    ,"N",11,2})
aadd(_aestrut,{"VALICF"    ,"N",11,2})

//aadd(_aestrut,{"VALORBF"    ,"N",11,2})
//aadd(_aestrut,{"VALORBH"    ,"N",11,2})
aadd(_aestrut,{"VENDEDOR" ,"C",06,0})
//aadd(_aestrut,{"TIPO     ","C",01,0})
aadd(_aestrut,{"GERENTE  ","C",06,0})

_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
_cindtmp11:=criatrab(,.f.)
_cchave   :="vendedor+cliente+loja"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))

_cindtmp12:=criatrab(,.f.)
_cchave   :="gerente+vendedor+strzero(valorff+valich+valicf,11,2)"
tmp1->(indregua("TMP1",_cindtmp12,_cchave))

_cindtmp13:=criatrab(,.f.)
_cchave   :="gerente+nome+strzero(valorff+valich+valicf,11,2)"
tmp1->(indregua("TMP1",_cindtmp13,_cchave))

tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetindex(_cindtmp12))
tmp1->(dbsetindex(_cindtmp13))
tmp1->(dbsetorder(1))

_ntotquant:=0

_cindsb1:=criatrab(,.f.)
_cchave :="b1_filial+b1_cod"
_cfiltro:="b1_tipo=='PA'"
sb1->(indregua("SB1",_cindsb1,_cchave,,_cfiltro))

if mv_par08=1
	processa({|| _calcmov()})
else
	processa({|| _calcmov2()})
endif
setregua(tmp1->(lastrec()))

setprc(0,0)

_i      :=1
_npacum :=0
_nvalorf:=0
_nvalorh:=0
_ngerff :=0
_ngerfh :=0
_ngerff :=0
_ngerfh :=0
_nrepff :=0
_nrepfh :=0
_ntgff  :=0
_ntgfh  :=0
_nrepcf := 0
_ntgch := 0
_cvend := space(06)
_cgerente:= space(06)
_nqtlinha := 0
_ntipo:=" "


if mv_par08=1
	tmp1->(dbgobottom())
	tmp1->(dbsetorder(2))
	while ! tmp1->(bof()) .and.;
		lcontinua
		incregua()
		if prow()==0 .or. prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		if _cgerente  <> tmp1->gerente
			if _nrepff>0 .or. _nrepfh>0
				//	   	_impzero()
				@ prow()+1,000 PSAY "TOTAL REPRESENTANTE:"
				@ prow(),058   PSAY _nrepff picture "@E 999,999.99"
				@ prow(),070   PSAY _nrepfh picture "@E 999,999.99"
				@ prow()+1,000 PSAY ""
				_ngerff  +=_nrepff
				_ngerfh  +=_nrepfh
				_nrepff:=0
				_nrepfh:=0
				//	_i := 0
			endif
			if _ngerff>0 .or. _ngerfh >0
				//	   	_impzero()
				@ prow()+1,000 PSAY "TOTAL REGIAO:"
				@ prow(),058   PSAY _ngerff picture "@E 999,999.99"
				@ prow(),070   PSAY _ngerfh picture "@E 999,999.99"
				@ prow()+1,000 PSAY ""
				_ntgff  +=_ngerff
				_ntgfh  +=_ngerfh
				_ngerff:=0
				_ngerfh:=0
				_i := 0
			endif
			_cvend:=tmp1->vendedor
			_cgerente :=tmp1->gerente
			sa3->(dbseek(_cfilsa3+_cgerente))
			@ prow()+2,000 PSAY "REGIONAL : "+_cgerente+" - "+sa3->a3_nome
			_cvend:=tmp1->vendedor
			sa3->(dbseek(_cfilsa3+_cvend))
			@ prow()+1,000 PSAY "REPRESENTANTE: "+_cvend+" - "+sa3->a3_nome
			_aprodlin:={}
		endif
		if _cvend  <> tmp1->vendedor
			if _nrepff>0 .or. _nrepfh>0
				//	   	_impzero()
				@ prow()+1,000 PSAY "TOTAL REPRESENTANTE:"
				@ prow(),058   PSAY _nrepff picture "@E 999,999.99"
				@ prow(),070   PSAY _nrepfh picture "@E 999,999.99"
				@ prow()+1,000 PSAY ""
				_ngerff  +=_nrepff
				_ngerfh  +=_nrepfh
				_nrepff:=0
				_nrepfh:=0
				//	_i := 0
			endif
			@ prow()+2,000 PSAY "REGIONAL : "+_cgerente+" - "+sa3->a3_nome
			_cvend:=tmp1->vendedor
			sa3->(dbseek(_cfilsa3+_cvend))
			@ prow()+1,000 PSAY "REPRESENTANTE: "+_cvend+" - "+sa3->a3_nome
			
		endif
		@ prow()+1,000 PSAY _i          picture "99999"
		@ prow(),006   PSAY tmp1->cliente
		@ prow(),014   PSAY tmp1->loja
		@ prow(),017   PSAY tmp1->nome
		@ prow(),058   PSAY tmp1->valorff picture "@E 999,999.99"
		@ prow(),070   PSAY tmp1->valorfh picture "@E 999,999.99"
		_nrepff  +=tmp1->valorff
		_nrepfh  +=tmp1->valorfh
		//	aadd(_aprodlin,tmp1->produto)
		//	_ntotquant+=tmp1->quant
		_i++
		tmp1->(dbskip(-1))
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
	end
	if _nrepff>0 .or. _nrepfh>0
		if prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		
		@ prow()+1,000 PSAY "TOTAL REPRESENTANTE:"
		@ prow(),058   PSAY _nrepff picture "@E 999,999.99"
		@ prow(),070   PSAY _nrepfh picture "@E 999,999.99"
		@ prow()+1,000 PSAY ""
		_ngerff  +=_nrepff
		_ngerfh  +=_nrepfh
		_nrepff:=0
		_nrepfh:=0
		
	endif
	if _ngerff>0 .or. _ngerfh >0
		if prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		
		@ prow()+1,000 PSAY "TOTAL REGIAO:"
		@ prow(),058   PSAY _ngerff picture "@E 999,999.99"
		@ prow(),070   PSAY _ngerfh picture "@E 999,999.99"
		@ prow()+1,000 PSAY ""
		_ntgff  +=_ngerff
		_ntgfh  +=_ngerfh
		_ngerff:=0
		_ngerfh:=0
		_i := 0
	endif
	if _ntgff>0 .or. _ntgfh >0
		if prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		
		@ prow()+1,000 PSAY "TOTAL REGIAO:"
		@ prow(),058   PSAY _ntgff picture "@E 999,999.99"
		@ prow(),070   PSAY _ntgfh picture "@E 999,999.99"
		@ prow()+1,000 PSAY ""
		_ntgff  +=_ngerff
		_ntgfh  +=_ngerfh
		_ngerff:=0
		_ngerfh:=0
		_i := 0
	endif
	
	if prow()>0 .and.;
		lcontinua
		if _ntotquant>0
			_impzero()
			_ntipo = tmp1->tipo
			@ prow()+1,000 PSAY "TOTAL LINHA:"
			@ prow(),054   PSAY _ntotquant picture "@E 999,999.99"
			@ prow()+1,000 PSAY ""
			_nqtlinha += _ntotquant
			_ntotquant = 0
		endif
		if !empty(_nqtlinha)
			@ prow()+1,000 PSAY replicate("-",limite)
			@ prow()+1,000 PSAY "TOTAL"
			@ prow(),054   PSAY _nqtlinha picture "@E 999,999.99"
			_nqtlinha += _ntotquant
			_ntotquant = 0
		endif
		roda(cbcont,cbtxt)
	endif
	
else  // SINTETICO
	
	tmp1->(dbgobottom())
	tmp1->(dbsetorder(3))
	_ngerff :=0
	_ngerlh :=0
	_ngerlf :=0
	while ! tmp1->(bof()) .and.;
		lcontinua
		incregua()
		if prow()==0 .or. prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		if _cgerente  <> tmp1->gerente
			if _ngerff>0 .or. _ngerlh >0  .or. _ngerlf > 0
				sa3->(dbseek(_cfilsa3+_cgerente))
				@ prow()+1,000 PSAY _cgerente +"-"+substr(sa3->a3_nome,1,20)
				@ prow(),034   PSAY _ngerff picture "@E 999,999.99"
				@ prow(),045   PSAY _ngerlh picture "@E 999,999.99"
				@ prow(),056   PSAY _ngerlf picture "@E 999,999.99"
				@ prow(),067   PSAY _ngerff+_ngerlh+_ngerlf picture "@E 9999,999.99"
				@ prow()+1,000 PSAY ""
				_ntgff  +=_ngerff
				_ntgfh  +=_ngerfh
				_ntgch += _nrepcf
				_ngerff:=0
				_ngerlh:=0
				_ngerlf:=0
				_i := 0
			endif
			_cgerente := tmp1->gerente
		endif
		@ prow()+1,000 PSAY _i  picture "999"
		@ prow(),004   PSAY tmp1->vendedor
		@ prow(),016   PSAY substr(tmp1->nome,1,15)
		@ prow(),034   PSAY tmp1->valorff picture "@E 999,999.99"
		@ prow(),045   PSAY tmp1->valicf picture "@E 999,999.99"
		@ prow(),056   PSAY tmp1->valich picture "@E 999,999.99"
		@ prow(),067   PSAY tmp1->valorff+tmp1->valicf+tmp1->valich picture "@E 9999,999.99"
		_ngerff  +=tmp1->valorff
		_ngerlh  +=tmp1->valicf
		_ngerlf  +=tmp1->valich
		
		_i++
		tmp1->(dbskip(-1))
		
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
	end
	if _ngerff>0 .or. _ngerlh >0  .or. _ngerlf > 0
		sa3->(dbseek(_cfilsa3+tmp1->gerente))
		@ prow()+1,000 PSAY tmp1->gerente+"-"+substr(sa3->a3_nome,1,20)
		@ prow(),034   PSAY _ngerff picture "@E 999,999.99"
		@ prow(),045   PSAY _ngerlh picture "@E 999,999.99"
		@ prow(),056   PSAY _ngerlf picture "@E 999,999.99"
		@ prow(),067   PSAY _ngerff+_ngerlh+_ngerlf picture "@E 9999,999.99"
		@ prow()+1,000 PSAY ""
		_ntgff  +=_ngerff
		_ntgfh  +=_ngerlh
		_ntgch += _ngerlf
		_ngerff:=0
		_ngerlh:=0
		_ngerlf	:=0
		_i := 0
	endif
	if prow()>0 .and.;
		lcontinua
		@ prow()+1,000 PSAY "TOTAL GERAL:"
		@ prow(),034   PSAY _ntgff picture "@E 999,999.99"
		@ prow(),045   PSAY _ntgfh picture "@E 999,999.99"
		@ prow(),056   PSAY _ntgch picture "@E 999,999.99"
		@ prow(),067   PSAY _ntgff+_ntgfh+_ntgch picture "@E 9999,999.99"
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

/*static function _impzero()
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
return*/

static function _calcmov()
procregua(1)
sf2->(dbsetorder(3))
sf2->(dbseek(_cfilsf2+" "+dtos(mv_par01)))
while !sf2->(eof()) .and.;
	sf2->f2_filial==_cfilsf2 .and.;
	sf2->f2_emissao<=mv_par02
	MSGSOTP(1)
	sd2->(dbseek(_cfilsf2+sf2->f2_doc+sf2->f2_serie))
	sf4->(dbseek(_cfilsf4+sd2->d2_tes))
	if sf4->f4_duplic=="S"
		MSGSOTP(2)
		
		_cvend:=sf2->f2_vend1
		_cgerente := sf2->f2_vend2
		if _cgerente>=mv_par05 .and.;
			_cgerente<=mv_par06 .and.;
			_cvend>=mv_par03 .and.;
			_cvend<=mv_par04
			sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
			sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
			da0->(dbseek(_cfilda0+sc5->c5_tabela))
			_mlic := .f.
			if (da0->da0_status = "L" .or. da0->da0_status = "R")
				_mlic := .t.
			endif
			if tmp1->(dbseek(_cvend+sf2->f2_cliente+sf2->f2_loja))
				if _mlic
					if sb1->b1_apreven = '1'
						tmp1->valicf +=sf2->f2_valmerc
					else
						tmp1->valich +=sf2->f2_valmerc
					endif
					//  		   			tmp1->valorfh +=sf2->f2_valmerc
				else
					tmp1->valorff +=sf2->f2_valmerc
				endif
			else
				tmp1->(dbappend())
				tmp1->vendedor :=_cvend
				tmp1->cliente :=sf2->f2_cliente
				tmp1->loja :=sf2->f2_loja
				tmp1->nome:=substr(sa1->a1_nome,1,30)
				tmp1->gerente:=_cgerente
				tmp1->pedido :=sd2->d2_pedido
				if _mlic
					if sb1->b1_apreven = '1'
						tmp1->valicf +=sf2->f2_valmerc
					else
						tmp1->valich +=sf2->f2_valmerc
					endif
				else
					tmp1->valorff +=sf2->f2_valmerc
				endif
				
			endif
		endif
	endif
	sf2->(dbskip())
end
return

static function _calcmov2()
procregua(1)
//sf2->(dbsetorder(4))
sf2->(dbseek(_cfilsf2+" "+dtos(mv_par01)))
MSGSTOP(dtos(mv_par01))
while !sf2->(eof()) .and.;
	sf2->f2_filial==_cfilsf2 .and.;
	sf2->f2_serie="1  " .and.;
	sf2->f2_emissao<=mv_par02
	sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie))
	sf4->(dbseek(_cfilsf4+sd2->d2_tes))
	sb1->(dbseek(_cfilsb1+sd2->d2_cod))
	/*
	if sb1->b1_tipo <> 'PA'
	_nvalout +=tmp1->saldo
	else
	sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
	da0->(dbseek(_cfilda0+sc5->c5_tabela))
	if (da0->da0_status = "L" .or. da0->da0_status = "R")
	if sb1->b1_apreven = '1'
	_nvalicf +=tmp1->saldo
	else
	_nvalich +=tmp1->saldo
	endif
	*/
	
	if sf4->f4_duplic=="S"
		_cvend:=sf2->f2_vend1
		_cgerente := sf2->f2_vend2
		if _cgerente>=mv_par05 .and.;
			_cgerente<=mv_par06 .and.;
			_cvend>=mv_par03 .and.;
			_cvend<=mv_par04
			sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
			sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
			da0->(dbseek(_cfilda0+sc5->c5_tabela))
			_mlic := .f.
			if !EMPTY(da0->da0_status) // = "L" .or. da0->da0_status = "R")
				_mlic := .t.
			endif
			if tmp1->(dbseek(_cvend))
				if _mlic
					if sb1->b1_apreven = '1'
						tmp1->valicf +=sf2->f2_valmerc
					else
						tmp1->valich +=sf2->f2_valmerc
					endif
				else
					tmp1->valorff +=sf2->f2_valmerc
				endif
			else
				sa3->(dbseek(_cfilsa3+_cvend))
				tmp1->(dbappend())
				tmp1->vendedor :=_cvend
				tmp1->nome:=substr(sa3->a3_nome,1,25)
				tmp1->gerente:=_cgerente
				if _mlic
					if sb1->b1_apreven = '1'
						tmp1->valicf +=sf2->f2_valmerc
					else
						tmp1->valich +=sf2->f2_valmerc
					endif
				else
					tmp1->valorff +=sf2->f2_valmerc
				endif
			endif
		endif
	endif
	sf2->(dbskip())
end
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do vendedor        ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"04","Ate o vendedor     ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"05","Do Gerente Regional?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"06","Ate Gerente Regional?","mv_ch6","C",06,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"07","Salta pagina       ?","mv_ch7","N",01,0,0,"C",space(60),"mv_par07"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Analitico          ?","mv_ch8","N",01,0,0,"C",space(60),"mv_par08"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

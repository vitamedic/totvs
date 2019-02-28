/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT140   ³ Autor ³Aline B. Pereira         Data ³ 27/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio Analise Financeira por Fornecedor                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT258()
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="ANALISE FINANCEIRA POR FORNECEDOR "
cdesc1  :="Este programa ira emitir a analise financeiro por fornecedor"
cdesc2  :=""
cdesc3  :=""
cstring :="SE2"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT258"
wnrel   :="VIT258"+Alltrim(cusername)
alinha  :={}
aordem  :={"Sintetico Alfabetica","Sintetico Rankig"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGVIT258"
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

return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:="PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02) +"             Valor Total Minimo: "+transform(mv_par07,"@E 999,999,999.99")
cabec2:="PRF-Num.Parc  TP Emissao   Vencimento            Valor   Atraso Dt.Entrega   Cond.Pgto   Prz.Medio"
cabec3:="Codigo    Fornecedor                           Vencidos        A Vencer    Sub-Total Comp.Pendentes       Total Prz.Medio"

_cfilsa2:=xfilial("SA2")
_cfilse2:=xfilial("SE2")
_cfilsbm:=xfilial("SBM")
_cfilsc7:=xfilial("SC7")
_cfilsm2:=xfilial("SM2")
_cfilse4:=xfilial("SE4")
_cfilsf1:=xfilial("SF1")

sa2->(dbsetorder(1))
se2->(dbsetorder(3))
sbm->(dbsetorder(1))
sc7->(dbsetorder(1))
sm2->(dbsetorder(1))
se4->(dbsetorder(1))
sf1->(dbsetorder(2))
_nvalc7:=0
_nvale2:=0

_acom    :={}


_aestrut:={}
aadd(_aestrut,{"PREFIXO" ,"C",03,0})
aadd(_aestrut,{"NUMERO"  ,"C",06,0})
aadd(_aestrut,{"PARCELA" ,"C",01,0})
aadd(_aestrut,{"TIPO"    ,"C",03,0})
aadd(_aestrut,{"FORNECE" ,"C",06,0})
aadd(_aestrut,{"LOJA"    ,"C",02,0})
aadd(_aestrut,{"TPREL"   ,"C",01,0})
aadd(_aestrut,{"EMISSAO" ,"D",08,0})
aadd(_aestrut,{"VENC"    ,"D",08,0})
aadd(_aestrut,{"DTENT"   ,"D",08,0})
aadd(_aestrut,{"VALOR"   ,"N",17,2})
aadd(_aestrut,{"COND"    ,"C",03,0})



_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)

_cchave  :="fornece+loja+tprel+dtos(venc)"
_cindtmp11:=criatrab(,.f.)
tmp1->(indregua("TMP1",_cindtmp11,_cchave,,,"Selecionando registros..."))


processa({|| _calcula()})

_cforn := ""
_cloja :=""
store 0 to _nvenc, _navenc, _ntvalor,_ntvenc,_ntavenc, _npend, _ntpend,_nttot
store 0 to _nsvenc,_nsavenc,_nspend,_nttota
setprc(0,0)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())

_ddat := ctod("")
_nval := 0
_ntprazo :=0
_nt := 0
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	_mforn:= tmp1->fornece
	_mloja:= tmp1->loja
	_nval := 0
	_nreg :=tmp1->(recno())
	while !tmp1->(eof()) .and.;
		tmp1->fornece==_mforn .and.;
		tmp1->loja == _mloja
		_nval += tmp1->valor
		tmp1->(dbskip())
	end
	tmp1->(dbgoto(_nreg))
	if _nval >= mv_par07 		// Imprime Fornecedor se o valor < mv_par07
		tmp1->(dbseek(_mforn+_mloja))
		while !tmp1->(eof()) .and.;
			tmp1->fornece==_mforn .and.;
			tmp1->loja == _mloja
			sa2->(dbseek(_cfilsa2+tmp1->fornece+tmp1->loja))
			if sa2->a2_tpfor == mv_par09 .OR. mv_par09=="T"
				_mnome := sa2->a2_nome
				// Imprime Fornecedor
				if _cforn <> tmp1->fornece .or. _cloja <> tmp1->loja
					// Salta pagina imprime novo fornecedor
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
					@ prow()+1,000 PSAY sa2->a2_cod+"-"+sa2->a2_loja
					@ prow()  ,010 PSAY sa2->a2_nome
					@ prow()  ,052 PSAY sa2->a2_tel
					_cforn := tmp1->fornece
					_cloja := tmp1->loja
					_ngprazo := 0
					_ng := 0
				endif
				_ndias:=date()-tmp1->venc
				if tmp1->tprel == "F"
					if _ndias > 0
						_nvenc += tmp1->valor
					else
						_navenc += tmp1->valor
					endif
				else
					if !empty(_nvenc)
						if prow()>56
							cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
						endif
						@ prow()+1,000 PSAY "Total Vencidos:"
						@ prow(),040   PSAY _nvenc picture "@E 999,999,999.99"
						@ prow()+1,000 PSAY ""
						_ntvalor += _nvenc
						_nsvenc += _nvenc
						store 0 to _nvenc
					endif
					if !empty(_navenc)
						if prow()>56
							cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
						endif
						@ prow()+1,000 PSAY "Total a Vencer:"
						@ prow(),040   PSAY _navenc picture "@E 999,999,999.99"
						@ prow()+1,000 PSAY ""
						_nsavenc += _navenc
						_ntvalor += _navenc
						store 0 to _navenc
					endif
					_npend += tmp1->valor
				endif
				
				if prow()>56
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
				endif
				if _ndias <= 0 .and. !empty(_nvenc)
					if prow()>56
						cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
					endif
					@ prow()+1,000 PSAY "Total Vencidos:"
					@ prow(),040   PSAY _nvenc picture "@E 999,999,999.99"
					@ prow()+1,000 PSAY ""
					_ntvenc += _nvenc
					_nsvenc += _nvenc
					_ntvalor += _nvenc
					store 0 to _nvenc
				endif
				@ prow()+1,000 PSAY tmp1->prefixo+"-"+tmp1->numero+"-"+tmp1->parcela
				@ prow(),015   PSAY tmp1->tprel
				@ prow(),018   PSAY dtoc(tmp1->emissao)
				@ prow(),028   PSAY dtoc(tmp1->venc)
				@ prow(),040   PSAY tmp1->valor picture "@E 999,999,999.99"
				if _ndias > 0
					@ prow(),060 PSAY _ndias
				endif
				if !empty(tmp1->dtent)
					@ prow(),065 PSAY tmp1->dtent
				endif
				se4->(dbseek(_cfilse4+tmp1->cond))
				_ccond:=se4->e4_cond
				@ prow(),078 PSAY tmp1->cond+" - "+se4->e4_descri
				_nprazo :=0
				_nparcelas := 0
				while ! empty(_ccond)
					_nprazo+=val(substr(_ccond,1,len(_ccond)-at(",",_ccond)))
					_nparcelas++
					if at(",",_ccond)==0
						_ccond:=""
					else
						_ccond:=substr(_ccond,at(",",_ccond)+1)
					endif
				end
				@ prow(),095 PSAY round(_nprazo/_nparcelas,0) picture "@E 999"
				_ntprazo += round(_nprazo/_nparcelas,0)
				_nt ++
				_ngprazo += round(_nprazo/_nparcelas,0)
				_ng ++
			endif
			tmp1->(dbskip())
		end
		if !empty(_nvenc)
			if prow()>56
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY "Total Vencidos:"
			@ prow(),040   PSAY _nvenc picture "@E 999,999,999.99"
			@ prow()+1,000 PSAY ""
			_nsvenc += _nvenc
			_ntvalor += _nvenc
			store 0 to _nvenc
		endif
		if !empty(_navenc)
			if prow()>56
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY "Total a Vencer:"
			@ prow(),040   PSAY _navenc picture "@E 999,999,999.99"
			@ prow()+1,000 PSAY ""
			_nsavenc += _navenc
			_ntvalor += _navenc
			store 0 to _navenc
		endif
		if !empty(_npend)
			if prow()>56
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY "Total Compras Pendentes:"
			@ prow(),040   PSAY _npend picture "@E 999,999,999.99"
			@ prow()+1,000 PSAY ""
			_nspend += _npend
			_ntvalor += _npend
			store 0 to _npend
		endif
		if !empty(_ntvalor)
			if prow()>56
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY "Total em aberto:"
			@ prow(),040   PSAY _ntvalor picture "@E 999,999,999.99"
			@ prow(),095   PSAY round(_ntprazo/_nt,0) picture "@E 999"
			@ prow()+1,000 PSAY ""
			store 0 to _ntvalor,_nt,_ntprazo
		endif
		if sa2->a2_tpfor == mv_par09 .OR. mv_par09=="T"
			aadd(_acom,{_mforn,_mloja,_mnome,_nsvenc,_nsavenc,_nsvenc+_nsavenc,_nspend,_nsvenc+_nsavenc+_nspend,_ngprazo,_ng})
		endif	
		store 0 to _nsvenc,_nsavenc,_nspend
	endif
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end
if !empty(_nvenc)
	if prow()>56
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY "Total Vencidos:"
	@ prow(),040   PSAY _nvenc picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY ""
	
	//	_ntvenc += _nvenc
	_ntvalor += _nvenc
	
	store 0 to _nvenc
endif
if !empty(_navenc)
	if prow()>56
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY "Total a Vencer:"
	@ prow(),040   PSAY _navenc picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY ""
	
	//	_ntavenc += _navenc
	_ntvalor += _navenc
	
	store 0 to _navenc
endif
if !empty(_npend)
	if prow()>56
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY "Total Compras Pendentes:"
	@ prow(),040   PSAY _npend picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY ""
	_ntvalor += _npend
	store 0 to _npend
endif
if !empty(_ntvalor)
	if prow()>56
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY "Total em aberto:"
	@ prow(),040   PSAY _ntvalor picture "@E 999,999,999.99"
	@ prow(),095   PSAY round(_ntprazo/_nt,0) picture "@E 999"
	
	@ prow()+1,000 PSAY ""
	store 0 to _ntvalor
	//	roda(cbcont,cbtxt)
	
endif
if mv_par08=1
	if nordem==1
		_acoms:= asort(_acom,,,{|x,y| x[3]<y[3]})
	else
		_acoms:= asort(_acom,,,{|y,x| y[6]<x[6]})
	endif
	cabec(titulo,cabec1,cabec3,wnrel,tamanho,ntipo)
	store 0 to _ntvenc,_ntavenc,_ntpend ,_nprz,_ntt
	for _i:=1 to len(_acoms)
		if prow()>54
			cabec(titulo,cabec1,cabec3,wnrel,tamanho,ntipo)
		endif
		@ prow()+1,000 PSAY _acoms[_i,1]
		@ prow(),007 PSAY _acoms[_i,2]
		@ prow(),010   PSAY left(_acoms[_i,3],30)
		@ prow(),041   PSAY _acoms[_i,4] picture "@E 999,999,999.99"
		@ prow(),056   PSAY _acoms[_i,5] picture "@E 999,999,999.99"
		@ prow(),070   PSAY _acoms[_i,6] picture "@E 999,999,999.99"
		@ prow(),084   PSAY _acoms[_i,7] picture "@E 999,999,999.99"
		@ prow(),098   PSAY _acoms[_i,8] picture "@E 999,999,999.99"
		@ prow(),121   PSAY _acoms[_i,9]/_acoms[_i,10]picture "@E 999"
		_ntvenc += _acoms[_i,4]
		_ntavenc += _acoms[_i,5]
		_ntpend += _acoms[_i,7]
		_nprz += _acoms[_i,9]/_acoms[_i,10]
		_ntt ++
	next
	if prow()>56
		cabec(titulo,cabec1,cabec3,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "Total Geral:"
	@ prow(),041   PSAY _ntvenc picture "@E 999,999,999.99"
	@ prow(),056   PSAY _ntavenc picture "@E 999,999,999.99"
	@ prow(),070   PSAY _ntvenc+_ntavenc picture "@E 999,999,999.99"
	@ prow(),084   PSAY _ntpend picture "@E 999,999,999.99"
	@ prow(),098   PSAY _ntvenc+_ntavenc+_ntpend picture "@E 999,999,999.99"
	@ prow(),121   PSAY round(_nprz/_ntt,0) picture "@E 999"
endif
/*if prow()>0 .and.;
lcontinua
@ prow()+1,000 PSAY replicate("-",limite)
@ prow()+1,000 PSAY "Total Geral:"
@ prow(),040   PSAY _ntvalor picture "@E 999,999,999.99"
roda(cbcont,cbtxt)
endif
*/
tmp1->(dbclosearea())

set device to screen

setpgeject(.f.)
if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return()



static function _calcula()
_ddata:=ddatabase
_nvalor:= 0

se2->(dbsetorder(3))
se2->(dbseek(_cfilse2+dtos(mv_par01),.t.))
while ! se2->(eof()) .and.;
	se2->e2_filial==_cfilse2 .and.;
	se2->e2_vencrea<=mv_par02
	incproc("Selecionando titulos...")
	if	se2->e2_fornece>=mv_par03 .and.;
		se2->e2_fornece<=mv_par04 .and.;
		se2->e2_loja   >=mv_par05 .and.;
		se2->e2_loja   <=mv_par06 .and.;
		se2->e2_saldo  > 0
		_nvalor:= se2->e2_saldo
		if se2->e2_moeda >1
			sm2->(dbseek(_ddata))
			_ccampo   :="M2_MOEDA"+strzero(se2->e2_moeda,1)
			_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
			if _nvalmoeda==0
				sm2->(dbskip(-1))
				while ! sm2->(bof()) .and.;
					_nvalmoeda==0
					_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
					sm2->(dbskip(-1))
				end
			endif
			if _nvalmoeda>0
				_nvalor:=round(_nvalor*_nvalmoeda,2)
			endif
		endif
		sf1->(dbseek(_cfilsf1+se2->e2_fornece+se2->e2_loja+se2->e2_num,.t.))
		tmp1->(dbappend())
		tmp1->prefixo :=se2->e2_prefixo
		tmp1->numero  :=se2->e2_num
		tmp1->parcela :=se2->e2_parcela
		tmp1->tipo    :=se2->e2_tipo
		tmp1->fornece :=se2->e2_fornece
		tmp1->loja    :=se2->e2_loja
		tmp1->venc    :=se2->e2_vencrea
		tmp1->emissao :=se2->e2_emissao
		tmp1->valor   :=_nvalor
		tmp1->tprel   :="F"
		tmp1->dtent   :=ctod("")
		tmp1->cond    :=sf1->f1_cond
	endif
	se2->(dbskip())
end


_cquery:=" SELECT"
_cquery+=" C7_FORNECE FORNECE,"
_cquery+=" C7_LOJA LOJA,"
_cquery+=" C7_NUM NUM,"
_cquery+=" C7_MOEDA MOEDA,"
_cquery+=" C7_COND COND,"
_cquery+=" C7_EMISSAO EMISSAO,"
_cquery+=" C7_DATPRF DTENT,"
_cquery+=" SUM((C7_QUANT-C7_QUJE)*C7_PRECO) VALOR"
_cquery+=" FROM "
_cquery+=" SC7010 SC7"
_cquery+=" WHERE"
_cquery+="     SC7.D_E_L_E_T_<>'*'"
_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
_cquery+=" AND C7_QUANT-C7_QUJE>0"
_cquery+=" AND C7_RESIDUO=' '"
_cquery+=" AND C7_FORNECE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND C7_LOJA    BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"

_cquery+=" GROUP BY"
_cquery+=" C7_FORNECE,C7_LOJA,C7_NUM,C7_MOEDA,C7_COND,C7_EMISSAO,C7_DATPRF"
//_cquery+=" 1,2,3,4,5,6,7,8"


tcquery _cquery new alias "TMP2"

tcsetfield("TMP2","VALOR","N",12,2)
tcsetfield("TMP2","MOEDA","N",01,0)

tmp2->(dbgotop())
while ! tmp2->(eof())
	_demissao := CtoD(SubStr(tmp2->emissao,7,2)+"/"+SubStr(tmp2->emissao,5,2)+"/"+SubStr(tmp2->emissao,3,2))
	_nvalor :=tmp2->valor
	_ncond := tmp2->cond
	_dtent := ctod(substr(tmp2->dtent,7,2)+"/"+substr(tmp2->dtent,5,2)+"/"+substr(tmp2->dtent,3,2))
	//	_dtent := ctod(_dtent)
	if _dtent>date()
		_aparc := Condicao(_nvalor,_ncond,,_dtent)
	else
		_aparc := Condicao(_nvalor,_ncond,,date())
	endif
	for _np:=1 to len(_aparc)
		_nvalparc:=_aparc[_np,2]
		if tmp2->moeda>1
			sm2->(dbseek(_ddata))
			_ccampo   :="M2_MOEDA"+strzero(tmp2->moeda,1)
			_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
			if _nvalmoeda==0
				sm2->(dbskip(-1))
				while ! sm2->(bof()) .and.;
					_nvalmoeda==0
					_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
					sm2->(dbskip(-1))
				end
			endif
			if _nvalmoeda>0
				_nvalparc:=round(_nvalparc*_nvalmoeda,2)
			endif
		endif
		tmp1->(dbappend())
		tmp1->fornece :=tmp2->fornece
		tmp1->numero  :=tmp2->num
		tmp1->loja    :=tmp2->loja
		tmp1->emissao :=_demissao
		tmp1->venc    :=_aparc[_np,1]
		//		tmp1->parcela :=_aparc[_np,2]
		tmp1->valor   :=_nvalparc
		tmp1->tprel   :="P"
		tmp1->dtent   :=_dtent
		tmp1->cond    :=tmp2->cond
	next
	tmp2->(dbskip())
end

tmp2->(dbclosearea())

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Vencimento      ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o Vencimento   ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do Fornecedor      ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"04","Ate o Fornecedor   ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"05","Da Loja            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"06","Ate a Loja         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"07","Valor minimo       ?","mv_ch7","N",12,2,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Sintetico          ?","mv_ch8","N",01,0,0,"C",space(60),"mv_par08"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Tipo Fornecedor    ?","mv_ch9","C",01,0,0,"C",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{cperg,"09","Tipo Fornecedor    ?","mv_ch9","C",01,0,0,"C",space(60),"mv_par09"       ,"T-Todos"        ,space(30),space(15),"D- Direto"      ,space(30),space(15),"F-Financeiro"   ,space(30),space(15),"M-Manutenção"   ,space(30),space(15),"C-Consumo"      ,space(30),"   "})

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

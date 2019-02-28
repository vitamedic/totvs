/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT073   ³ Autor ³ Aline                 ³ Data ³ 24/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acompanhamento Trimestral de Compras                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"


user function vit073()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="ACOMPANHAMENTO TRIMESTRAL DE COMPRAS"
cdesc1   :="Este programa ira emitir o relatorio de acompanhamento trimestral de compras"
cdesc2   :=""
cdesc3   :=""
cstring  :="SE2"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT073"
wnrel    :="VIT073"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT073"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=18

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
_cfilse2:=xfilial("SE2")
_cfilsd1:=xfilial("SD1")
_cfilsc7:=xfilial("SC7")
_cfilsm2:=xfilial("SM2")
_cfilsf1:=xfilial("SF1")
se2->(dbsetorder(3))
sd1->(dbsetorder(1))
sf1->(dbsetorder(1))
sc7->(dbsetorder(1))
sm2->(dbsetorder(1))
_mtes := 0
_mout := 0
_mpag := 0
_mcpend := 0
_mtes2 := 0
_mout2 := 0
_mcpend2 := 0
_mtes3 := 0
_mout3 := 0
_mcpend3 := 0
_pdata_in1 :=CTOD(" ")
_pdata_in2 :=CTOD(" ")
_pdata_in3 :=CTOD(" ")
_pdata_fi1 :=CTOD(" ")
_pdata_fi2 :=CTOD(" ")
_pdata_fi3 :=CTOD(" ")
_nmes1 := month(mv_par01)
_nano1 := year(mv_par01)
if _nmes1=11
	_nmes2:=_nmes1+1
	_nmes3:=1
	_nano2:=_nano1
	_nano3:=_nano1+1
elseif _nmes1=12
	_nmes2:=1
	_nmes3:=2
	_nano2:=_nano1+1
	_nano3:=_nano1+1
else
	_nmes2:=_nmes1+1
	_nmes3:=_nmes1+2
	_nano2:=_nano1
	_nano3:=_nano1
endif
_nmes1 :=strzero(_nmes1,2)
_nano1:=strzero(_nano1,4)
_nmes2:=strzero(_nmes2,2)
_nano2:=strzero(_nano2,4)
_nmes3:=strzero(_nmes3,2)
_nano3:=strzero(_nano3,4)
_pdata_in1 :=CTOD("01/"+_nmes1+"/"+_nano1)
_pdata_in2 :=CTOD("01/"+_nmes2+"/"+_nano2)
_pdata_in3 :=CTOD("01/"+_nmes3+"/"+_nano3)
_mdia = 31
_pdata_fi1 := CTOD(STRZERO(_mdia,2)+"/"+_nmes1+"/"+_nano1)
WHILE EMPTY(_pdata_fi1)
	_pdata_fi1 := CTOD(STRZERO(_mdia,2)+"/"+_nmes1+"/"+_nano1)
	_mdia --
	SKIP
END
_mdia := 31
_pdata_fi2 := CTOD(STRZERO(_mdia,2)+"/"+_nmes2+"/"+_nano2)
WHILE EMPTY(_pdata_fi2)
	_pdata_fi2 := CTOD(STRZERO(_mdia,2)+"/"+_nmes2+"/"+_nano2)
	_mdia --
	SKIP
END
_mdia := 31
_pdata_fi3 := CTOD(STRZERO(_mdia,2)+"/"+_nmes3+"/"+_nano3)
WHILE EMPTY(_pdata_fi3)
	_pdata_fi3 := CTOD(STRZERO(_mdia,2)+"/"+_nmes3+"/"+_nano3)
	_mdia --
	SKIP
END

cabec1:="Mes/Ano  "+_nmes1+"/"+substr(_nano1,3,2)+"                                           "+_nmes2+"/"+substr(_nano2,3,2)+"                                "+_nmes3+"/"+substr(_nano3,3,2)
cabec2:="Dia      Confirmado    Pendente        Pago       Total  Confirmado   Pendente       Total   Confirmado   Pendente      Total"

setregua(1)
incregua()
setprc(0,0)
_ttes1 := 0
_tout1 := 0
_tpag1 := 0
_ttes2 := 0
_tout2 := 0
_ttes3 := 0
_tout3 := 0
for _i:=1 to 31
	_ntes :=0
	_npag :=0
	_ncompras := 0
	_ntes1 := 0
	_nout1 := 0
	_npag1 := 0
	_ntes2 := 0
	_nout2 := 0
	_ntes3 := 0
	_nout3 := 0
	
	_ddata := CTOD("")
	if _pdata_in1 <= _pdata_fi1
		_ddata := _pdata_in1
		processa({|| _calcula()})
		_ntes1 :=_ntes
		_nout1 :=_ncompras
		_npag1 :=_npag
		_ntes := 0
		_ncompras := 0
		_npag := 0
	endif
	if _pdata_in2 <= _pdata_fi2
		_ddata := _pdata_in2
		processa({|| _calcula()})
		_ntes2 := _ntes
		_nout2 := _ncompras
		_ntes := 0
		_ncompras := 0
		_npag := 0
	endif
	if _pdata_in3 <= _pdata_fi3
		_ddata := _pdata_in3
		processa({|| _calcula()})
		_ntes3 := _ntes
		_nout3 := _ncompras
		_ntes := 0
		_ncompras := 0
		_npag := 0
	endif
	_md := DTOC(_pdata_in1)
	_md := SUBSTR(_md,1,2)
	if prow()==0 .or. prow()>50
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 psay STRZERO(_i,2)
	@ prow()  ,008 psay TRANSFORM(_ntes1,"@E 9999,999.99")
	@ prow()  ,020 psay TRANSFORM(_nout1,"@E 9999,999.99")
	@ prow()  ,032 psay TRANSFORM(_npag1,"@E 9999,999.99")
	@ prow()  ,044 psay TRANSFORM(_ntes1+_nout1+_npag1,"@E 9999,999.99")
	@ prow()  ,056 psay TRANSFORM(_ntes2,"@E 9999,999.99")
	@ prow()  ,067 psay TRANSFORM(_nout2,"@E 9999,999.99")
	@ prow()  ,079 psay TRANSFORM(_ntes2+_nout2,"@E 9999,999.99")
	@ prow()  ,091 psay TRANSFORM(_ntes3,"@E 9999,999.99")
	@ prow()  ,102 psay TRANSFORM(_nout3,"@E 9999,999.99")
	@ prow()  ,113 psay TRANSFORM(_ntes3+_nout3,"@E 9999,999.99")
	_ttes1 += _ntes1
	_tout1 += _nout1
	_tpag1 += _npag1
	_ttes2 += _ntes2
	_tout2 += _nout2
	_ttes3 += _ntes3
	_tout3 += _nout3
	_pdata_in1 ++
	_pdata_in2 ++
	_pdata_in3 ++
next
@ prow()+1,008 psay TRANSFORM(_ttes1,"@E 9999,999.99")
@ prow()  ,020 psay TRANSFORM(_tout1,"@E 9999,999.99")
@ prow()  ,032 psay TRANSFORM(_tpag1,"@E 9999,999.99")
@ prow()  ,044 psay TRANSFORM(_ttes1+_tout1+_tpag1,"@E 9999,999.99")
@ prow()  ,056 psay TRANSFORM(_ttes2,"@E 9999,999.99")
@ prow()  ,067 psay TRANSFORM(_tout2,"@E 9999,999.99")
@ prow()  ,079 psay TRANSFORM(_ttes2+_tout2,"@E 9999,999.99")
@ prow()  ,091 psay TRANSFORM(_ttes3,"@E 9999,999.99")
@ prow()  ,102 psay TRANSFORM(_tout3,"@E 9999,999.99")
@ prow()  ,113 psay TRANSFORM(_ttes3+_tout3,"@E 9999,999.99")
@ prow()+2,000 psay "Total Geral do Trimestre: "+TRANSFORM((_ttes1+_tout1+_tpag1)+(_ttes2+_tout2)+(_ttes3+_tout3),"@E 99999,999.99")
_ncompr:= 0
_ncompmes:= 0
processa({|| _compras()})
@ prow()+2,001 psay "Compras entre "+dtoc(mv_par02)+" a "+dtoc(mv_par03)+": "+TRANSFORM(_ncompr,"@E 9999,999.99")
@ prow()+1,001 psay "Compras no mes: "+TRANSFORM(_ncompmes,"@E 9999,999.99")

roda(0," ")

set device to screen
se2->(dbclosearea())
sd1->(dbclosearea())
sf1->(dbclosearea())
sc7->(dbclosearea())
sm2->(dbclosearea())

if areturn[5]==1
	set printer to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

static function _calcula()
procregua(3)
incproc("Calculando contas a pagar...")
_cquery:=" SELECT"
_cquery+=" E2_PREFIXO PREFIXO,E2_NUM NUMERO,E2_PARCELA PARCELA,E2_TIPO TIPO,"
_cquery+=" E2_SALDO SALDO,E2_MOEDA MOEDA,E2_NUM NUM,E2_VENCREA VENC"
_cquery+=" FROM "
_cquery+=" SE2010 SE2"
_cquery+=" WHERE"
_cquery+="     SE2.D_E_L_E_T_<>'*'"
_cquery+=" AND E2_FILIAL='"+_cfilse2+"'"
_cquery+=" AND E2_VENCREA='"+dtos(_ddata)+"'"
_cquery+=" AND E2_SALDO>0"

_cquery:=changequery(_cquery)

tcquery  _cquery new alias "TMP1"
tcsetfield("TMP1","SALDO"  ,"N",12,2)
tcsetfield("TMP1","MOEDA"  ,"N",02,0)
tmp1->(dbgotop())
while !tmp1->(eof())
	if tmp1->moeda>1
		sm2->(dbseek(ddatabase))
		_ccampo   :="M2_MOEDA"+strzero(tmp1->moeda,1)
		_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
		if _nvalmoeda==0
			sm2->(dbskip(-1))
			while ! sm2->(bof()) .and.;
				_nvalmoeda==0
				_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
				sm2->(dbskip(-1))
			end
		endif
		if _nvalmoeda==0
			_nvalor:=tmp1->saldo
		else
			_nvalor:=round(tmp1->saldo*_nvalmoeda,2)
		endif
	else
		_nvalor:=tmp1->saldo
	endif
	sd1->(dbseek(_cfilse2+tmp1->numero+tmp1->prefixo))
	if !empty(sd1->d1_pedido)
		_ntes +=_nvalor
	endif
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

incproc("Calculando contas pagas...")
_cquery:=" SELECT"
_cquery+=" E2_PREFIXO PREFIXO,E2_NUM NUMERO,E2_PARCELA PARCELA,E2_TIPO TIPO,"
_cquery+=" E2_VALLIQ SALDO,E2_MOEDA MOEDA"
_cquery+=" FROM "
_cquery+=" SE2010 SE2,"
_cquery+=" WHERE"
_cquery+="     SE2.D_E_L_E_T_<>'*'"
_cquery+=" AND E2_FILIAL='"+_cfilse2+"'"
_cquery+=" AND E2_BAIXA='"+dtos(_ddata)+"'"

_cquery:=changequery(_cquery)

tcquery  _cquery new alias "TMP1"
tcsetfield("TMP1","SALDO"  ,"N",12,2)
tcsetfield("TMP1","MOEDA"  ,"N",02,0)

tmp1->(dbgotop())
while !tmp1->(eof())
	_nvalor:=tmp1->saldo
	sd1->(dbseek(_cfilse2+tmp1->numero+tmp1->prefixo))
	if !empty(sd1->d1_pedido)
		_npag +=_nvalor
	endif
	tmp1->(dbskip())
end
tmp1->(dbclosearea())
incproc("Calculando saldo de compras pendentes...")
_cquery:=" SELECT"
_cquery+=" C7_MOEDA MOEDA,SUM((C7_QUANT-C7_QUJE)*C7_PRECO) VALOR,C7_COND COND,"
_cquery+=" C7_DATPRF DTENT, C7_NUM NUM"
_cquery+=" FROM "
_cquery+=" SC7010 SC7"
_cquery+=" WHERE"
_cquery+="     SC7.D_E_L_E_T_<>'*'"
_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
_cquery+=" AND C7_QUANT-C7_QUJE>0"
_cquery+=" AND C7_RESIDUO=' '"
_cquery+=" GROUP BY"
_cquery+=" C7_MOEDA,C7_COND,C7_DATPRF,C7_NUM"

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","VALOR","N",12,2)
tcsetfield("TMP1","MOEDA","N",01,0)

tmp1->(dbgotop())
while ! tmp1->(eof())
	_nvalor :=tmp1->valor
	_ncond := tmp1->cond
	_dtent := substr(tmp1->dtent,7,2)+"/"+substr(tmp1->dtent,5,2)+"/"+substr(tmp1->dtent,3,2)
	_dtent := ctod(_dtent)
	_aparc := Condicao(_nvalor,_ncond,,_dtent)
	for _np:=1 to len(_aparc)
		if dtos(_aparc[_np,1]) == dtos(_ddata)
			_nvalparc:=_aparc[_np,2]
			if tmp1->moeda<>1
				sm2->(dbseek(_ddata))
				_ccampo   :="M2_MOEDA"+strzero(tmp1->moeda,1)
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
					_nvalparc:=round(_nvalor*_nvalmoeda,2)
				endif
			endif
			_ncompras += _nvalparc
		endif
	next
	tmp1->(dbskip())
end
tmp1->(dbclosearea())
return

static function _compras()
procregua(1)
incproc("Calculando compras entre "+dtoc(mv_par02)+ " e "+dtoc(mv_par03))
_cquery:=" SELECT"
_cquery+=" C7_MOEDA MOEDA,SUM(C7_QUANT*C7_PRECO) VALOR,C7_DATPRF DTENT,"
_cquery+=" C7_NUM NUM,C7_COND COND"
_cquery+=" FROM "
_cquery+=" SC7010 SC7"
_cquery+=" WHERE"
_cquery+="     SC7.D_E_L_E_T_<>'*'"
_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
_cquery+=" AND C7_QUANT>0"
_cquery+=" AND C7_EMISSAO BETWEEN '"+dtos(mv_par02)+"' AND '"+dtos(mv_par03)+"'"
_cquery+=" GROUP BY"
_cquery+=" C7_MOEDA,C7_COND,C7_DATPRF,C7_NUM"

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","VALOR","N",12,2)
tcsetfield("TMP1","MOEDA","N",01,0)

tmp1->(dbgotop())
while ! tmp1->(eof())
	_nvalor :=tmp1->valor
	sc7->(dbseek(_cfilsc7+tmp1->num))
	if !empty(sc7->c7_ipi)
		_nvalor :=_nvalor +(_nvalor*sc7->c7_ipi)/100
	endif
	if tmp1->moeda<>1
		sm2->(dbseek(tmp1->dtent))
		_ccampo   :="M2_MOEDA"+strzero(tmp1->moeda,1)
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
			_nvalor :=round(_nvalor*_nvalmoeda,2)
		endif
	endif
	_ncompr += _nvalor
	tmp1->(dbskip())
end
tmp1->(dbclosearea())
//  _pdata1 :=CTOD(" ")
//  _nmes := month(mv_par02)
//  _nano := year(mv_par02)
_nmes :=strzero(month(mv_par02),2)
_nano :=strzero(year(mv_par02),4)
_pdata1 :=CTOD("01/"+_nmes+"/"+_nano)
incproc("Calculando compras no mes")
_cquery:=" SELECT"
_cquery+=" C7_MOEDA MOEDA,SUM(C7_QUANT*C7_PRECO) VALOR,C7_COND COND,"
_cquery+=" C7_DATPRF DTENT, C7_NUM NUM"
_cquery+=" FROM "
_cquery+=" SC7010 SC7"
_cquery+=" WHERE"
_cquery+="     SC7.D_E_L_E_T_<>'*'"
_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
_cquery+=" AND C7_QUANT>0"
_cquery+=" AND C7_EMISSAO BETWEEN '"+dtos( _pdata1)+"' AND '"+dtos(date())+"'"
_cquery+=" GROUP BY"
_cquery+=" C7_MOEDA,C7_COND,C7_DATPRF,C7_NUM"

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","VALOR","N",12,2)
tcsetfield("TMP1","MOEDA","N",01,0)

tmp1->(dbgotop())
while ! tmp1->(eof())
	_nvalor :=tmp1->valor
	sc7->(dbseek(_cfilsc7+tmp1->num))
	if !empty(sc7->c7_ipi)
		_nvalor :=_nvalor +(_nvalor*sc7->c7_ipi)/100
	endif
	if tmp1->moeda<>1
		sm2->(dbseek(tmp1->dtent))
		_ccampo   :="M2_MOEDA"+strzero(tmp1->moeda,1)
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
			_nvalor :=round(_nvalor*_nvalmoeda,2)
		endif
	endif
	_ncompmes += _nvalor
	tmp1->(dbskip())
end
tmp1->(dbclosearea())
return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Data inicial       ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Compras de         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Compras ate        ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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

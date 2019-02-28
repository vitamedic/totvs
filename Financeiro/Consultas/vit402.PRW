/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT402  ³ Autor ³ Alberto Olegario      ³ Data ³ 01/09/05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Fluxo de Caixa Resumido                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Adubos Goias                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
                         
#include "rwmake.ch"
#include "topconn.ch"

user function vit402()
PRIVATE _acampos1:={}
cperg:="PERGVIT402"
_pergsx1()
if pergunte(cperg,.t.)
	_aesttmp:={}
	aadd(_aesttmp,{"DESC"     ,"C",12,00})
	aadd(_aesttmp,{"RECEBER"  ,"N",12,02})
	aadd(_aesttmp,{"PAGAR"    ,"N",12,02})
	aadd(_aesttmp,{"CRECEBER" ,"C",15,00})
	aadd(_aesttmp,{"CPAGAR"   ,"C",15,00})
	aadd(_aesttmp,{"CSALDODIA","C",15,00})
	aadd(_aesttmp,{"CSALDO"   ,"C",15,00})
	aadd(_aesttmp,{"ORDEM"    ,"C",08,00})
	aadd(_aesttmp,{"TIPO"     ,"C",01,00})
	_carqtmp1:=criatrab(_aesttmp,.t.)
	dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)
	
	_cindtmp1:=criatrab(,.f.)
	_cchave  :="ORDEM"
	tmp1->(indregua("TMP1",_cindtmp1,_cchave,,,"Selecionando registros..."))

	_cdesc   :=space(12)
	_nreceber:=0
	_npagar  :=0
	_nordem  :=1
	processa({|| _bancos()})
	processa({|| _titulos()})
	processa({|| _saldos()})
	
	_acampos1:={}

	aadd(_acampos1,{"DESC"     ,"Descricao"   ,"@!",12,00})
	aadd(_acampos1,{"CRECEBER" ,"Receber"     ,"@!",15,00})
	aadd(_acampos1,{"CPAGAR"   ,"Pagar"       ,"@!",15,00})
	aadd(_acampos1,{"CSALDODIA","Saldo do dia","@!",15,00})
	aadd(_acampos1,{"CSALDO"   ,"Saldo"       ,"@!",15,00})
	
	tmp1->(dbgotop())
	
	@ 100,001 to 495,550  dialog odlg title "Fluxo de caixa resumido - "+alltrim(str(mv_par01,6))+" dia(s)"
	
	@ 002,002 to 180,273 browse "TMP1" fields _acampos1 //180-273
	
	@ 182,002 bmpbutton type 1 action close(odlg)
	
	activate dialog odlg centered
		
	_cindtmp1:=_cindtmp1+tmp1->(ordbagext())
	tmp1->(dbclosearea())
	ferase(_carqtmp1+".dbf")
	ferase(_cindtmp1)
endif
return

static function _bancos()
_cfilsa6:=xfilial("SA6")
sa6->(dbsetorder(1))

procregua(sa6->(lastrec()))

tmp1->(dbappend())
tmp1->desc :="BANCOS"
tmp1->ordem:=strzero(_nordem++,8)
tmp1->tipo :=" "

sa6->(dbgotop())
while ! sa6->(eof())
	incproc("Calculando saldos bancarios...")
	if  sa6->a6_fluxcai<>"N" 
		tmp1->(dbappend())
		tmp1->desc:=sa6->a6_nreduz
		if sa6->a6_salatu>=0
			tmp1->receber:=sa6->a6_salatu
		else
			tmp1->pagar  :=sa6->a6_salatu*(-1)
		endif
		tmp1->ordem:=strzero(_nordem++,8)
		tmp1->tipo :="B"
	endif
	sa6->(dbskip())
end

tmp1->(dbappend())
tmp1->ordem:=strzero(_nordem++,8)
tmp1->tipo :=" "
return

static function _titulos()
_cfilse1:=xfilial("SE1")
_cfilse2:=xfilial("SE2")
se1->(dbsetorder(7))
se2->(dbsetorder(3))

_ddatafim:=ddatabase+mv_par01

procregua(4)

incproc("Calculando titulos a receber vencidos...")

_cquery:=" SELECT"
_cquery+=" E1_TIPO TIPO,SUM(E1_SALDO) SALDO"
_cquery+=" FROM"
_cquery+=  retsqlname("SE1")+" SE1"
_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_VENCREA<'"+dtos(ddatabase)+"'"
_cquery+=" AND E1_SALDO>0"
_cquery+=" GROUP BY E1_TIPO"

_cquery:=changequery(_cquery)

tcquery _cquery alias "TMPA" new
tcsetfield("TMPA","SALDO","N",12,2)

tmpa->(dbgotop())
while ! tmpa->(eof())                   
	if substr(tmpa->tipo,3,1)=="-" .or. tmpa->tipo$"NCC/RA"
		_nreceber-=tmpa->saldo
	else
		_nreceber+=tmpa->saldo
	endif
	tmpa->(dbskip())
end

tmpa->(dbclosearea())

incproc("Calculando titulos a pagar vencidos...")

_cquery:=" SELECT"
_cquery+=" E2_TIPO TIPO,SUM(E2_SALDO) SALDO"
_cquery+=" FROM"
_cquery+=  retsqlname("SE2")+" SE2"
_cquery+=" WHERE"
_cquery+=" SE2.D_E_L_E_T_<>'*'"
_cquery+=" AND E2_FILIAL='"+_cfilse2+"'"
_cquery+=" AND E2_VENCREA<'"+dtos(ddatabase)+"'"
_cquery+=" AND E2_SALDO>0"
_cquery+=" GROUP BY E2_TIPO"

_cquery:=changequery(_cquery)

tcquery _cquery alias "TMPA" new
tcsetfield("TMPA","SALDO","N",12,2)

tmpa->(dbgotop())
while ! tmpa->(eof())
	if substr(tmpa->tipo,3,1)=="-" .or. tmpa->tipo=="NDF"
		_npagar-=tmpa->saldo
	else
		_npagar+=tmpa->saldo
	endif
	tmpa->(dbskip())
end

//tmpa->(dbclosearea())

tmp1->(dbappend())
tmp1->desc   :="VENCIDOS"
tmp1->receber:=_nreceber
tmp1->pagar  :=_npagar
tmp1->ordem  :=strzero(_nordem++,8)
tmp1->tipo   :="A"

tmp1->(dbappend())
tmp1->ordem:=strzero(_nordem++,8)
tmp1->tipo :=" "

incproc("Calculando titulos a receber a vencer...")

se1->(dbseek(_cfilse1+dtos(ddatabase),.t.))
while ! se1->(eof()) .and.;
		se1->e1_filial==_cfilse1 .and.;
		se1->e1_vencrea<=_ddatafim
	if se1->e1_saldo>0
		if substr(se1->e1_tipo,3,1)=="-" .or. se1->e1_tipo=="NCC"
			_nreceber:=se1->e1_saldo*(-1)
		else
			_nreceber:=se1->e1_saldo
		endif
		_cordem:=dtos(se1->e1_vencrea)
		if ! tmp1->(dbseek(_cordem))
			tmp1->(dbappend())
			tmp1->desc   :=dtoc(se1->e1_vencrea)
			tmp1->receber:=_nreceber
			tmp1->ordem  :=_cordem
			tmp1->tipo   :="V"
		else
			tmp1->receber+=_nreceber
		endif
	endif
	se1->(dbskip())
end

incproc("Calculando titulos a pagar a vencer...")

se2->(dbseek(_cfilse2+dtos(ddatabase),.t.))
while ! se2->(eof()) .and.;
		se2->e2_filial==_cfilse2 .and.;
		se2->e2_vencrea<=_ddatafim
	if se2->e2_saldo>0
		if substr(se2->e2_tipo,3,1)=="-" .or. se2->e2_tipo=="NDF"
			_npagar:=se2->e2_saldo*(-1)
		else
			_npagar:=se2->e2_saldo
		endif
		_cordem:=dtos(se2->e2_vencrea)
		if ! tmp1->(dbseek(_cordem))
			tmp1->(dbappend())
			tmp1->desc :=dtoc(se2->e2_vencrea)
			tmp1->pagar:=_npagar
			tmp1->ordem:=_cordem
			tmp1->tipo :="V"
		else
			tmp1->pagar+=_npagar
		endif
	endif
	se2->(dbskip())
end
return

static function _saldos()
procregua(tmp1->(lastrec()))
_nreceber:=0
_npagar  :=0
_nsaldo  :=0

tmp1->(dbgotop())
while ! tmp1->(eof())
	incproc("Calculando saldos...")
	if tmp1->tipo<>" "
		_nreceber +=tmp1->receber
		_npagar   +=tmp1->pagar
		_nsaldodia:=(tmp1->receber-tmp1->pagar)
		_nsaldo   +=_nsaldodia
		tmp1->creceber :=transform(tmp1->receber,"@E 999,999,999.99")
		tmp1->cpagar   :=transform(tmp1->pagar  ,"@E 999,999,999.99")
		tmp1->cpagar   :=transform(tmp1->pagar  ,"@E 999,999,999.99")
		if tmp1->tipo<>"B"
			tmp1->csaldodia:=transform(_nsaldodia   ,"@E 999,999,999.99")
		endif
		tmp1->csaldo   :=transform(_nsaldo      ,"@E 999,999,999.99")
	endif
	tmp1->(dbskip())
end

// LINHA EM BRANCO
_nordem:=90000000
tmp1->(dbappend())
tmp1->ordem:=strzero(_nordem++,8)
tmp1->tipo :=" "

tmp1->(dbappend())
tmp1->desc    :="TOTAIS"
tmp1->creceber:=transform(_nreceber    ,"@E 999,999,999.99")
tmp1->cpagar  :=transform(_npagar      ,"@E 999,999,999.99")
tmp1->csaldo  :=transform(_nsaldo      ,"@E 999,999,999.99")
tmp1->ordem   :=strzero(_nordem++,8)
tmp1->tipo    :="T"
return

static function _pergsx1()
_agrpsx1:={} 
aadd(_agrpsx1,{cperg,"01","Quantos dias       ?","mv_ch1","N",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

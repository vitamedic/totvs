/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT141   ³ Autor ³ Gardenia Ilany          Data ³ 22/07/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Compras / Grupo                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT141()
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="RELACAO DE COMPRAS / GRUPO"
cdesc1  :="Este programa ira emitir a relacao de fornecedores / ranking"
cdesc2  :=""
cdesc3  :=""
cstring :="SC7"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT141"
wnrel   :="VIT141"+Alltrim(cusername)
alinha  :={}
aordem  :={"Valor"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGVIT141"
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
cabec2:="    Codigo   Descricao                                    Pendente   Confirmado              Total           Pend.Total " 

_cfilsb1:=xfilial("SB1")
_cfilsc7:=xfilial("SC7")
_cfilsbm:=xfilial("SBM")
sb1->(dbsetorder(1))
sc7->(dbsetorder(5))
sbm->(dbsetorder(1))

_aestrut :={}
aadd(_aestrut,{"GRUPO"     ,"C",4,0})
aadd(_aestrut,{"DESCGRUPO" ,"C",40,0})
aadd(_aestrut,{"PENDENTE"  ,"N",12,2})
aadd(_aestrut,{"EFETIVO"   ,"N",12,2})
aadd(_aestrut,{"ORDEMVAL"  ,"N",06,0})
aadd(_aestrut,{"PENDGER"  ,"N",12,2})

_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)

_cindtmp11:=criatrab(,.f.)
_cchave  :="grupo"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))

_cindtmp12:=criatrab(,.f.)
_cchave  :="strzero((pendente+efetivo),12,2)+grupo"
tmp1->(indregua("TMP1",_cindtmp12,_cchave))

tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetindex(_cindtmp12))

tmp1->(dbsetorder(1))
_ntotal:=0
setregua(sc7->(lastrec()))
sc7->(dbseek(_cfilsc7+dtos(mv_par03),.t.))
while ! sc7->(eof()) .and.;
		sc7->c7_filial==_cfilsc7 .and.;
		sc7->c7_emissao<=mv_par02
	incregua()                 
	
	_produto:= sc7->c7_produto
	sb1->(dbseek(_cfilsb1+_produto))
	_grupo:=sb1->b1_grupo
	_pedido:=sc7->c7_num
	sbm->(dbseek(_cfilsbm+_grupo))
	sb1->(dbseek(_cfilsb1+_produto))
	_pendente:=0
	_pendger:=0
	_efetivo:=0
   if sc7->c7_emissao >= mv_par01 .and. sc7->c7_emissao <=mv_par02
   	if sc7->c7_residuo<> "S"
			_pendente:=(sc7->c7_quant-sc7->c7_quje)*sc7->c7_preco
		endif	
		_efetivo:= sc7->c7_quje*sc7->c7_preco
		_nvalmoeda:=0
	   if !empty(sc7->c7_ipi)
	   	if sc7->c7_residuo<> "S"
		      _pendente :=_pendente +(_pendente*sc7->c7_ipi)/100
		   endif   
	      _efetivo :=_pendente +(_efetivo*sc7->c7_ipi)/100
	   endif   
	  	if sc7->c7_moeda<>1
			sm2->(dbseek(sc7->c7_emissao))
			_ccampo   :="M2_MOEDA"+strzero(sc7->c7_moeda,1)
			_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
			if _nvalmoeda==0
				sm2->(dbskip(-1))
				while ! sm2->(bof()) .and.;
						_nvalmoeda==0
					_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
					sm2->(dbskip(-1))
				end
			endif
		endif	
		if _nvalmoeda>0
	 	   _pendente :=round(_pendente*_nvalmoeda,2)
	 	   _efetivo :=round(_efetivo*_nvalmoeda,2)
		endif
	endif
  	if sc7->c7_residuo<> "S"
		_pendger:=(sc7->c7_quant-sc7->c7_quje)*sc7->c7_preco
	endif	
	_nvalmoeda:=0
   if !empty(sc7->c7_ipi)
   	if sc7->c7_residuo<> "S"
	      _pendger :=_pendger +(_pendger*sc7->c7_ipi)/100
	   endif   
   endif   
  	if sc7->c7_moeda<>1
		sm2->(dbseek(sc7->c7_emissao))
		_ccampo   :="M2_MOEDA"+strzero(sc7->c7_moeda,1)
		_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
		if _nvalmoeda==0
			sm2->(dbskip(-1))
			while ! sm2->(bof()) .and.;
				_nvalmoeda==0
				_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
				sm2->(dbskip(-1))
			end
		endif
	endif	
	if _nvalmoeda>0
	   _pendger :=round(_pendger*_nvalmoeda,2)
	endif
	if ! tmp1->(dbseek(_grupo))
  			tmp1->(dbappend())
		tmp1->grupo    :=sb1->b1_grupo
		tmp1->descgrupo:=sbm->bm_desc  
		tmp1->pendente :=_pendente
		tmp1->efetivo :=_efetivo
		tmp1->pendger :=_pendger
	else
		tmp1->pendente +=_pendente
		tmp1->efetivo +=_efetivo
		tmp1->pendger +=_pendger
	endif
	sc7->(dbskip())
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
_ntpendente:=0
_ntefetivo:=0
_ntotvalor:=0
_ntpendger:=0
_nconta:=1
while &_ccond
	incregua()
	if prow()==0 .or. prow()>55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif  
	@ prow()+1,000 PSAY strzero(_nconta,3,0) picture "999"
	_nconta++
	@ prow(),004 PSAY left(tmp1->grupo,6)
	@ prow(),014   PSAY tmp1->descgrupo
	@ prow(),056   PSAY tmp1->pendente   picture "@E 999,999,999.99"
	@ prow(),069   PSAY tmp1->efetivo    picture "@E 999,999,999.99"
	@ prow(),090   PSAY (tmp1->pendente+tmp1->efetivo)    picture "@E 999,999,999.99"
	@ prow(),109   PSAY tmp1->pendger    picture "@E 999,999,999.99"

	_ntpendente+=tmp1->pendente
	_ntefetivo+=tmp1->efetivo
	_ntotvalor+=(tmp1->pendente+tmp1->efetivo)
	_ntpendger+=tmp1->pendger
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
	@ prow(),056   PSAY _ntpendente   picture "@E 999,999,999.99"
	@ prow(),069   PSAY _ntefetivo    picture "@E 999,999,999.99"
	@ prow(),090   PSAY _ntotvalor   picture "@E 999,999,999.99"
	@ prow(),109   PSAY _ntpendger   picture "@E 999,999,999.99"
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

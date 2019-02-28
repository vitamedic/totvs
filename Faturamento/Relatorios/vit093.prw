/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT093   ³ Autor ³ Aline                 ³ Data ³ 06/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faturamento Acumulado - por Periodo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit093()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="FATURAMENTO ACUMULADO "
cdesc1   :="Este programa ira emitir o relatorio de faturamento acumulado"
cdesc2   :=""
cdesc3   :=""
cstring  :="SF2"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT093"
wnrel    :="VIT093"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT093"
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
_cfilsf2:=xfilial("SF2")
_cfilsm2:=xfilial("SM2")
_cfilsd2:=xfilial("SD2")
_cfilsf4:=xfilial("SF4")
_cfilsb1:=xfilial("SB1")
_cfilse1:=xfilial("SE1")
_cfilsc5:=xfilial("SC5")
_cfilda0:=xfilial("DA0")

IF mv_par03 = "1"
	sf2->(dbsetorder(1))
ELSE
	sf2->(dbsetorder(3))
ENDIF
sm2->(dbsetorder(1))
se1->(dbsetorder(6))
sf4->(dbsetorder(1))
sb1->(dbsetorder(1))
sd2->(dbsetorder(3))
sc5->(dbsetorder(1))
da0->(dbsetorder(1))


cabec1:="Faturamento Acumulado - "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
cabec2:="Dia  (R$) Comercial   (%)    Lic.Farma. (%) Lic.Econom.  (%)  Faturado Dia  Fat.Acumulado  Icms.Subs  Outros  (U$)Faturado  Aacumulado"

setregua(1)
incregua()
setprc(0,0)

_ddata := CTOD("")
_nvalac := 0
_nvalac2 := 0
_pdata_in1 := mv_par01
_ntotret := 0
_ntotout := 0
_ntotlic := 0
_ntotval := 0
_ntotlicf := 0
_ntotlich := 0
_ntot := 0
while dtos(_pdata_in1) <= dtos(mv_par02)
	_nvalor :=0
	_nvalicf :=0
	_nvalich :=0
	_nvalout :=0
	_nvalor2 :=0
	_nvalret :=0
	_ddata := _pdata_in1
	processa({|| _calcula()})
	_nvalac += _nvalor+_nvalicf+_nvalich
	_ntot +=  _nvalor+_nvalicf+_nvalich
	_nvalac2 += _nvalor2
	if prow()==0 .or. prow()>50
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 psay DTOC(_pdata_in1)
	@ prow()  ,008 psay if(!empty(_nvalor), TRANSFORM(_nvalor, "@E 9,999,999.99")," ")
	@ prow()  ,021 psay if(!empty(_nvalor), TRANSFORM(round(((_nvalor/_ntot)*100),2), "@E 999.99")," ")
	@ prow()  ,028 psay if(!empty(_nvalicf), TRANSFORM(_nvalicf, "@E 999,999.99")," ")
	@ prow()  ,038 psay if(!empty(_nvalicf), TRANSFORM(round(((_nvalicf/_ntot)*100),2), "@E 999.99")," ")
	@ prow()  ,045 psay if(!empty(_nvalich), TRANSFORM(_nvalich, "@E 999,999.99")," ")
	@ prow()  ,056 psay if(!empty(_nvalich), TRANSFORM(round(((_nvalich/_ntot)*100),2), "@E 999.99")," ")
	@ prow()  ,063 psay if(!empty(_nvalor+_nvalicf+_nvalich),TRANSFORM(_nvalor+_nvalicf+_nvalich,"@E 99,999,999.99")," ")
	@ prow()  ,077 psay if(!empty(_nvalac), TRANSFORM(_nvalac, "@E 999,999,999.99")," ")
	@ prow()  ,091 psay if(!empty(_nvalret),TRANSFORM(_nvalret,"@E 999,999.99")," ")
	@ prow()  ,102 PSay if(!empty(_nvalout),TRANSFORM(_nvalout,"@E 999,999.99")," ")
	@ prow()  ,113 psay if(!empty(_nvalor2), TRANSFORM(_nvalor2,"@E 999,999.99")," ")
	@ prow()  ,124 psay if(!empty(_nvalac2),TRANSFORM(_nvalac2,"@E 9999,999.99")," ")
	_ntotret += _nvalret
	_ntotout += _nvalout
	_ntotlicf += _nvalicf
	_ntotlich += _nvalich
	_ntotval += _nvalor
	_ntot := 0
	_pdata_in1 ++
	_md := DTOC(_pdata_in1)
	_md := SUBSTR(_md,1,2)
end
@ prow()+1,000 psay "TOTAL"
@ prow()  ,008 psay TRANSFORM(_ntotval, "@E 999,999,999.99")
@ prow()  ,023 psay if(!empty(_ntotval),TRANSFORM(round(((_ntotval/_nvalac)*100),2), "@E 999.99")," ")
@ prow()  ,029 psay  TRANSFORM(_ntotlicf, "@E 999,999,999.99")
@ prow()  ,044 psay if(!empty(_ntotlicf),TRANSFORM(round(((_ntotlicf/_nvalac)*100),2), "@E 999.99")," ")
@ prow()  ,051 psay  TRANSFORM(_ntotlich, "@E 999,999,999.99")
@ prow()  ,065 psay if(!empty(_ntotlich),TRANSFORM(round(((_ntotlich/_nvalac)*100),2), "@E 999.99")," ")
@ prow()  ,091 psay TRANSFORM(_ntotret,"@E 999,999.99")
@ prow()  ,102 psay if(!empty(_ntotout),TRANSFORM(_ntotout,"@E 9,999,999.99")," ")
@ prow()+3,000 psay "Total Geral Licitacoes: "
@ prow()  ,043 psay TRANSFORM(_ntotlicf+_ntotlich, "@E 999,999,999.99")
@ prow()  ,056 psay TRANSFORM(round(((_ntotlicf+_ntotlich)/_nvalac)*100,2), "@E 999.99")

roda(0," ")
set device to screen
if areturn[5]==1
	set printer to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

static function _calcula()
procregua(3)
incproc("Calculando faturamento..."+dtoc(_ddata))
IF mv_par03 = "1"
	_cquery:=" SELECT"
	_cquery+=" F2_DOC DOC,F2_SERIE SERIE,F2_CLIENTE CLIENTE,F2_LOJA LOJA,"
	_cquery+=" F2_VALMERC SALDO,F2_ICMSRET ICMSRET"
	_cquery+=" FROM "
	_cquery+=" SF2010 SF2"
	_cquery+=" WHERE"
	_cquery+="     SF2.D_E_L_E_T_<>'*'"
	_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
	_cquery+=" AND F2_EMISSAO='"+dtos(_ddata)+"'"
	_cquery+=" AND F2_TIPO IN ('N','C')"
	//  " AND F2_TIPO$'N/C'"
	
	_cquery:=changequery(_cquery)
	
	tcquery  _cquery new alias "TMP1"
	
	tcsetfield("TMP1","SALDO"  ,"N",12,2)
	tmp1->(dbgotop())
	while !tmp1->(eof())
		sd2->(dbseek(_cfilsd2+tmp1->doc+tmp1->serie))
		sf4->(dbseek(_cfilsf4+sd2->d2_tes))
		if sf4->f4_duplic=="S" .and. sf4->f4_estoque=="S"
			sb1->(dbseek(_cfilsb1+sd2->d2_cod))
			if sb1->b1_tipo <> 'PA' .and. sb1->b1_tipo <> "PL"
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
				else
					_nvalor +=tmp1->saldo
				endif
			endif
			_nvalret +=icmsret
			sm2->(dbseek(dtos(_ddata)))
			_ccampo   :="M2_MOEDA2"
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
				_nvalor2 +=tmp1->saldo
			else
				_nvalor2 +=round(tmp1->saldo/_nvalmoeda,2)
			endif
		endif
		tmp1->(dbskip())
	end
	tmp1->(dbclosearea())
else
	sf2->(dbseek(_cfilsf2+" "+dtos(_ddata),.t.))
	while ! sf2->(eof()) .and.;
		sf2->f2_filial==_cfilsf2 .and.;
		sf2->f2_emissao<=_ddata
		sd2->(dbseek(_cfilsf2+sf2->f2_doc+sf2->f2_serie))
		sf4->(dbseek(_cfilsf4+sd2->d2_tes))
		if sf4->f4_duplic=="S"
			sb1->(dbseek(_cfilsb1+sd2->d2_cod))
			if sb1->b1_tipo <> 'PA' .AND. sb1->b1_tipo <> 'PL'
				_nvalout +=0 //tmp1->saldo
			else
				_nvalor +=sf2->f2_valmerc
			endif
			_mdt :=dtos(_ddata)
			sm2->(dbseek(_ddata))
			_ccampo   :="M2_MOEDA2"
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
				_nvalor2 +=sf2->f2_valmerc
			else
				_nvalor2 +=round(sf2->f2_valmerc/_nvalmoeda,2)
			endif
		endif
		sf2->(dbskip())
	end
endif
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Data inicial       ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Data final         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Grade              ?","mv_ch3","C",01,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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
Faturamento Acumulado - Periodo de : 99/99/99 a   99/99/99
Dia (R$)Diario  Acumulado    (U$)Diario  Acumulado
99  999.999,99 999.999,99    999.999,99 999.999,99
*/

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT150  � Autor � Aline                  � Data � 09/09/03 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Relacao de Produtos / Lotes                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

/*
Variaveis utilizadas para parametros
mv_par01 Da data
mv_par02 Ate a data
mv_par01 Do produto
mv_par02 Ate o produto
mv_par01 Do tipo
mv_par02 Ate o tipo
mv_par01 Do grupo
mv_par02 Ate a grupo
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT150()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="RELACAO DE PRODUTOS / LOTES"
cdesc1   :="Este programa ira emitir a relacao de Produto /lote"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB8"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT150"
wnrel    :="VIT150"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT150"
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
_cfilsb1:=xfilial("SB1")
_cfilsb8:=xfilial("SB8")
sb1->(dbsetorder(3))
sb8->(dbsetorder(1))

processa({|| _querys()})

cabec1:="Produto                                         Data           Lote"
cabec2:=''

setprc(0,0)

setregua(sb8->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_mprod := left(tmp1->produto,06)+" - "+left(tmp1->descri,40)
	_cproduto:=tmp1->produto
	_ant :=""
	while ! tmp1->(eof()) .and.;
		tmp1->produto==_cproduto .and.;
		lcontinua
		incregua()
		_lote :=tmp1->lotectl
		_local :=tmp1->local
		_dtvalid :=tmp1->dtvalid
		_num := tmp1->um
		tmp1->(dbskip())
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
		if _lote<> _ant
			@ prow()+1,000 PSAY _mprod
			@ prow(),50   PSAY _dtvalid
			@ prow(),065  PSAY _lote //nqlote  picture "@E 999,999,999.99"
			_ant := _lote
		endif
	end
end

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
//_cquery+=" B8_PRODUTO PRODUTO,B1_DESC DESCRI,B8_DTVALID DTVALID,"
_cquery+=" B8_PRODUTO PRODUTO,B1_DESC DESCRI,B8_DATA DTVALID,"
_cquery+=" B1_UM UM,B8_SALDO SALDO,B8_EMPENHO EMPENHO,B8_LOTECTL LOTECTL,B8_LOCAL LOCAL"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SB8")+" SB8"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SB8.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
_cquery+=" AND B8_PRODUTO=B1_COD"
_cquery+=" AND B8_LOCAL  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND B8_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY B1_DESC,B8_LOCAL,B8_LOTECTL"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DTVALID","D")
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Armazem            ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem      ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
Produto: xxxxxxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Data        Quantidade UM Ordem de producao Quantidade Seg. UM
99/99/99 999,999,999.999 xx    xxxxxxxxxxx    999,999,999.999 xx
*/

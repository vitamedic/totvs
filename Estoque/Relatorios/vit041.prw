/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT041   ³ Autor ³ Gardenia              ³ Data ³ 07/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Estoque de PA / Lote                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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

user function VIT041()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="RELACAO DE ESTOQUE DE PRODUTO / LOTE"
cdesc1   :="Este programa ira emitir a relacao de estoque de Produto /lote"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB8"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT041"
wnrel    :="VIT041"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT041"
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
_cfilsz0:=xfilial("SZ0")
sb1->(dbsetorder(3))
sb8->(dbsetorder(1))
sz0->(dbsetorder(1))

processa({|| _querys()})

cabec1:="LOTE      AL       ESTOQUE        EMPENHO         SALDO UN   VALIDADE   RT"
cabec2:=''

_rt:=""
if mv_par09==1
	_rt:="TODOS"
elseif mv_par09==2
	_rt:="GIOVANA"
elseif mv_par09==3
	_rt:="JOSE FERNANDO"
else
	_rt:="RICARDO"
endif

setprc(0,0)

setregua(sb8->(lastrec()))

tmp1->(dbgotop())

while ! tmp1->(eof()) .and.;
	lcontinua
	
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	
	if (alltrim(_rt)==alltrim(tmp1->resp)) .or.;
		(_rt="TODOS")
		
		@ prow()+1,000 PSAY left(tmp1->produto,10)+" - "+left(tmp1->descri,58)
		@ prow()+1,000 PSAY ""
		_nquant   := 0
		_nsaldo   := 0
		_nempenho := 0
		_cproduto := tmp1->produto
		_ntqt     := 0
		_ntemp    := 0
		
		while ! tmp1->(eof()) .and.;
			tmp1->produto==_cproduto .and.;
			lcontinua
			
			incregua()
			
			//tratar aqui
			if (alltrim(_rt)==alltrim(tmp1->resp)) .or.;
				(_rt="TODOS")
				
				_lote      := tmp1->lotectl
				_nqlote    := 0
				_nqemplote := 0
				_local     := tmp1->local
				_dtvalid   := tmp1->dtvalid
				_num       := tmp1->um
				_resp      := tmp1->resp
				
				while ! tmp1->(eof()) .and.;
					tmp1->produto==_cproduto .and.;
					lcontinua .and.;
					_lote ==tmp1->lotectl .and.;
					_local==tmp1->local
					
					_nqlote    += tmp1->saldo
					_nqemplote += tmp1->empenho
					_nquant    += tmp1->saldo
					_nsaldo    += tmp1->saldo
					_nempenho  += tmp1->empenho
					
					tmp1->(dbskip())
					
					if labortprint
						@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
						lcontinua:=.f.
					endif
				end
				
				if prow()>53
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
				endif
				
				@ prow()+1,000 PSAY _lote
				@ prow(),010   PSAY _local
				@ prow(),013   PSAY _nqlote  picture "@E 999,999,999.99"
				@ prow(),027   PSAY _nqemplote picture "@E 999,999,999.99"
				@ prow(),041   PSAY _nqlote-_nqemplote   picture "@E 999,999,999.99"
				@ prow(),055   PSAY _num
				@ prow(),058   PSAY _dtvalid
				@ prow(),067   PSAY substr(_resp,1,13)
				
			else
				tmp1->(dbskip())
			endif
		end
		
		if lcontinua
			@ prow()+1,000 PSAY "Totais"
			@ prow(),013   PSAY _nquant  picture "@E 999,999,999.99"
			@ prow(),027   PSAY _nempenho picture "@E 999,999,999.99"
			@ prow(),041   PSAY _nquant-_nempenho   picture "@E 999,999,999.99"
			@ prow()+1,000 PSAY replicate("-",limite)
		endif
		
	else
		tmp1->(dbskip())
	endif
end

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
_cquery+=" B8_PRODUTO PRODUTO,"
_cquery+=" B1_DESC DESCRI,"
_cquery+=" B8_DTVALID DTVALID,"
_cquery+=" B1_UM UM,"
_cquery+=" B8_SALDO SALDO,"
_cquery+=" B8_EMPENHO EMPENHO,"
_cquery+=" B8_LOTECTL LOTECTL,"
_cquery+=" B8_LOCAL LOCAL,"
_cquery+=" (SELECT Z0_RESP"
_cquery+="    FROM "
_cquery+=     retsqlname("SZ0")+" SZ0"
_cquery+="    WHERE SZ0.D_E_L_E_T_<>'*'"
_cquery+="    AND SZ0.Z0_PRODUTO=SB8.B8_PRODUTO"
_cquery+="    AND SZ0.Z0_LOTECTL=SB8.B8_LOTECTL"
_cquery+="    AND SZ0.Z0_LOCAL=SB8.B8_LOCAL"
_cquery+=" ) RESP"

_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SB8")+" SB8"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SB8.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
_cquery+=" AND B8_PRODUTO=B1_COD"
_cquery+=" AND B8_SALDO>0"
_cquery+=" AND B8_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND B8_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY B1_DESC,B8_LOCAL,B8_LOTECTL"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
MEMOWRIT("\sql\vit041.sql",_cquery)
tcsetfield("TMP1","DTVALID","D")
tcsetfield("TMP1","SALDO"  ,"N",15,3)
tcsetfield("TMP1","EMPENHO","N",15,3)
return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Armazem            ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem      ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","RT                 ?","mv_ch9","N",01,0,0,"C",space(60),"mv_par09"       ,"1-Todos     "   ,space(30),space(15),"2-Giovanna     ",space(30),space(15),"3-Jose Fernando",space(30),space(15),"4-Ricardo      ",space(30),space(15),space(15)        ,space(30),"   "})

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

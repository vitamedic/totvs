/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT218   ³ Autor ³ Gardenia              ³ Data ³ 07/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Titulos / Importacao                            ³±±
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

user function VIT218()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="RELACAO TITULOS /IMPORTAÇÃO"
cdesc1   :="Este programa ira emitir a relacao de titulos /importação"
cdesc2   :=""
cdesc3   :=""
cstring  :="SE2"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT218"
wnrel    :="VIT218"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT218"
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
_cfilse2:=xfilial("SE2")
_cfilsa2:=xfilial("SA2")
se2->(dbsetorder(1))
sa2->(dbsetorder(1))

processa({|| _querys()})

cabec1:="CODIGO LJ FORNECEDOR                                    IMPORTACAO"
//CODIGO LJ FORNECEDOR                                  IMPORTACAO 
cabec2:='PRE TITULO PARC   EMISSAO           VALOR          SALDO     BAIXA'
//PRE TITULO PARC   EMISSAO          VALOR          SALDO   BAIXA 
//XXX 999999  X    99/99/99 999.999.999,99 999.999.999,99


setprc(0,0)

setregua(sb8->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
//999999 99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX      999999
	sa2->(dbseek(_cfilsa2+tmp1->fornece+tmp1->loja))
   @ prow()+2,000 PSAY tmp1->fornece+"-"+tmp1->loja + " " + sa2->a2_nome	 
 	@ prow(),060 PSAY tmp1->import
	_import  :=tmp1->import
	_tvalor:=0
	_tsaldo:=0
	while ! tmp1->(eof()) .and.;
		tmp1->import==_import .and.;
		lcontinua
		incregua()
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
//XXX 999999  X    99/99/99 999.999.999,99 999.999.999,99     
		@ prow()+1,000 PSAY tmp1->prefixo
		@ prow(),004   PSAY tmp1->num
		@ prow(),013   PSAY tmp1->parcela  
		@ prow(),018   PSAY tmp1->emissao
		@ prow(),027    PSAY tmp1->valor picture "@E 999,999,999.99"
		@ prow(),042   PSAY tmp1->saldo picture "@E 999,999,999.99"
		@ prow(),058   PSAY tmp1->baixa
		_tvalor+=tmp1->valor
		_tsaldo+=tmp1->saldo
		tmp1->(dbskip())
	end
	if lcontinua
		@ prow()+1,000 PSAY "TOTAIS"
		@ prow(),027   PSAY _tvalor picture "@E 999,999,999.99"
		@ prow(),042   PSAY _tsaldo picture "@E 999,999,999.99"
//		@ prow()+1,000 PSAY replicate("-",limite)
	endif
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
_cquery+=" E2_PREFIXO PREFIXO,E2_NUM NUM,E2_FORNECE FORNECE,E2_LOJA LOJA,E2_EMISSAO EMISSAO,"
_cquery+=" E2_VALOR VALOR,E2_BAIXA BAIXA,E2_SALDO SALDO,E2_IMPORT IMPORT,E2_PARCELA PARCELA 
// ,A2_NOME NOME"
_cquery+=" FROM "
//_cquery+=  retsqlname("SA2")+" SA2,"
_cquery+=  retsqlname("SE2")+" SE2"
_cquery+=" WHERE"
_cquery+="     SE2.D_E_L_E_T_<>'*'"
//_cquery+=" AND SE2.D_E_L_E_T_<>'*'"
//_cquery+=" AND A2_FILIAL='"+_cfilsa2+"'"
_cquery+=" AND E2_FILIAL='"+_cfilse2+"'"
//_cquery+=" AND E2_FORNECE=A2_COD"
//_cquery+=" AND E2_LOJA>E2_LOJA"
_cquery+=" AND E2_EMISSAO  BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
_cquery+=" AND E2_IMPORT BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY E2_IMPORT"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","BAIXA","D")
tcsetfield("TMP1","SALDO"  ,"N",15,2)
tcsetfield("TMP1","VALOR","N",15,2)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Fornecedor      ?","mv_ch1","C",6,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"02","Ate o fornecedor   ?","mv_ch2","C",6,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"03","Da emissao         ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a emissao      ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da importação      ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate a importação   ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
	
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
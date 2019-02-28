/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT250   ³Autor ³ Gardenia              ³Data ³ 07/03/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Producao / Linha                                ³±±
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

user function VIT250()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="RELACAO DE PRODUCAO /LINHA "
cdesc1   :="Este programa ira emitir a relacao de producao por linha"
cdesc2   :=""
cdesc3   :=""
cstring  :="SD3"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT250"
wnrel    :="VIT250"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT250"
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
_cfilsd3:=xfilial("SD3")
sb1->(dbsetorder(1))
sd3->(dbsetorder(1))

processa({|| _querys()})

cabec1:="Periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)

cabec2:="Mes/Ano     solidos  semi-solidos     liquidos        gotas   terceiros  Produzidos"
//Mes/Ano     solidos  semi-solidos     liquidos        gotas   terceiros  Produzidos
//99/9999 999,999,999   999,999,999  999,999,999  999,999,999 999,999,999 999,999,999

setprc(0,0)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
_ntotal   :=0
_ntotsegum:=0
_nquant   :=0
_nqtsegum :=0
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_emissao:=tmp1->emissao
//	msgstop(month(tmp1->emissao))
//	msgstop(month(_emissao))
//	msgstop(year(tmp1->emissao))
//	msgstop(year(_emissao))
	_gotas:=0
	_liquidos:=0
	_semisol:=0
	_tercei:=0
	_solidos:=0
	while ! tmp1->(eof()) .and.;
			month(tmp1->emissao)==month(_emissao)  .and.;
			year(tmp1->emissao)==year(_emissao) .and.	lcontinua
		incregua()
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif  
		if tmp1->grupo == 'PA01'
			_gotas+= tmp1->quant * TMP1->conv
		elseif tmp1->grupo == 'PA02'
			_liquidos+= tmp1->quant * TMP1->conv // * _conv
		elseif tmp1->grupo == 'PA03'
			_semisol+= tmp1->quant * TMP1->conv  // * _conv
		elseif tmp1->grupo$'PA04/PA05/PA06/PA07/PA10/PA12'
			_tercei+= tmp1->quant * TMP1->conv // * _conv
		elseif tmp1->grupo$'PA11/PA09/PA08'
			_solidos+= tmp1->quant * TMP1->conv // * _conv
		endif	
		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
	end
//99/9999 999,999,999   999,999,999  999,999,999  999,999,999 999,999,999 999,999,999

	@ prow()+1,000 PSAY month(_emissao) 
	@ prow(),002  PSAY "/" 
	@ prow(),003 PSAY year(_emissao)
	@ prow(),009   PSAY _solidos  picture "@E 999,999,999"
	@ prow(),022   PSAY _semisol  picture "@E 999,999,999"
	@ prow(),035   PSAY _liquidos    picture "@E 999,999,999"
	@ prow(),048   PSAY _gotas    picture "@E 999,999,999"
	@ prow(),060   PSAY _tercei   picture "@E 999,999,999"
	@ prow(),072   PSAY _solidos+_semisol+_liquidos+_gotas+_tercei   picture "@E 999,999,999"

/*
	if lcontinua
		@ prow()+2,000 PSAY "Totais"
		@ prow(),009   PSAY _nquant   picture "@E 999,999,999.999"
		@ prow(),046   PSAY _nqtsegum picture "@E 999,999,999.999"
		@ prow()+1,000 PSAY replicate("-",limite)
	endif
*/
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
_cquery+=" D3_COD PRODUTO,B1_DESC DESCRI,D3_EMISSAO EMISSAO,D3_QUANT QUANT,"
_cquery+=" B1_UM UM,D3_OP OP,D3_QTSEGUM QTSEGUM,B1_SEGUM SEGUM,D3_GRUPO GRUPO,B1_CONVFH CONV"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SD3")+" SD3"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SD3.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
_cquery+=" AND D3_COD=B1_COD"
_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND D3_CF='PR0'"
_cquery+=" AND D3_ESTORNO<>'S'"
_cquery+=" AND D3_TIPO='PA'"
_cquery+=" ORDER BY D3_EMISSAO,D3_GRUPO"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","QUANT"  ,"N",15,3)
tcsetfield("TMP1","QTSEGUM","N",15,3)
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
Produto: xxxxxxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  Data        Quantidade UM Ordem de producao Quantidade Seg. UM
99/99/99 999,999,999.999 xx    xxxxxxxxxxx    999,999,999.999 xx
*/
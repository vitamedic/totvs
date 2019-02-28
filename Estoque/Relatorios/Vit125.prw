/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT125   ³ Autor ³ Aline B. Pereira      ³ Data ³ 25/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Materiais sem Movimentacao Semestral                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit125()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="MATERIAIS S/ MOVIMENTACAO  "
cdesc1   :="Este programa ira emitir o resumo da movimentacao do estoque "
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT125"
wnrel    :="VIT125"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT125"
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
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)
titulo:="MATERIAIS S/ MOVIMENTACAO "

_dinimed := (mv_par07-180)   //180 DIAS - 6 Meses

while empty(_dinimed)
	_dinimed :=ctod(strzero(_ddia,2)+"/"+_cmesmed+"/"+_canomed)
	_ddia --
end
_dfimmed := ddatabase
cabec1:="Desde :" +dtoc(_dinimed)
cabec2:="Codigo Descricao                  Loc Tipo     Estoque  Vlr.Cst.Med.       Empenho  Ult.Movim.   Qtde.Mov.  Ult.Compra  Qtde.Compra"
//cabec2:="Codigo Descricao                    Local Tipo Estoque      Empenho Ult.Movim.    Qtde.Mov.   Ult.Compra   Qtde.Compra"


_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsd3:=xfilial("SD3")
_cfilsd1:=xfilial("SD1")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sd3->(dbsetorder(7))
sd1->(dbsetorder(7))
_acom    :={}

_ccq     :=getmv("MV_CQ")
_nmovmes :=0
_ntsaimes :=0

processa({|| _geratmp()})

setprc(0,0)
_nucom :=0
setregua(sb1->(lastrec()))
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	sb1->(dbseek(_cfilsb1+tmp1->produto))
	_local:=sb1->b1_locpad
	_tipo:=sb1->b1_tipo
	// SALDO ATUAL / EMPENHO e ULTIMA SAIDA
	if sb2->(dbseek(_cfilsb2+sb1->b1_cod+sb1->b1_locpad))
		_cquery:=" SELECT"
		_cquery+=" D3_COD COD"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SD3")+" SD3"
		_cquery+=" WHERE "
		_cquery+="     SD3.D_E_L_E_T_<>'*'"
		_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
		_cquery+=" AND D3_COD='"+tmp1->produto+"'"
		_cquery+=" AND D3_TM>'500'"
		_cquery+=" AND D3_DOC<>'INVENT'"
		_cquery+=" AND D3_EMISSAO>'"+dtos(_dinimed)+"'"
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tmp2->(dbgotop())
		if tmp2->cod == tmp1->produto
			_ok := .f.
		else
			_ok := .t.
		endif
		tmp2->(dbclosearea())
			
		if  _ok //  .and. !empty(sb2->b2_usai)
			_cquery:=" SELECT"
			_cquery+=" D3_COD COD, D3_QUANT QUANT,D3_EMISSAO EMISSAO"
			_cquery+=" FROM "
			_cquery+=  retsqlname("SD3")+" SD3"
			_cquery+=" WHERE "
			_cquery+="     SD3.D_E_L_E_T_<>'*'"
			_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
			_cquery+=" AND D3_COD='"+tmp1->produto+"'"
			_cquery+=" AND D3_TM>'500'"
			_cquery+=" AND D3_DOC<>'INVENT'"
			_cquery+=" AND D3_EMISSAO<='"+dtos(_dinimed)+"'"
			_cquery+=" ORDER BY D3_EMISSAO DESC"
			
			_cquery:=changequery(_cquery)
			
			tcquery _cquery alias "TMP3" new
			tcsetfield("TMP3","EMISSAO","D",08)
			tcsetfield("TMP3","QUANT","N",15,2)
			
			tmp3->(dbgotop())
			_quant:= tmp3->quant
			_emissao:=tmp3->emissao
			tmp3->(dbclosearea())
			
			_nsaldo:=sb2->b2_qatu-sb2->b2_reserva-sb2->b2_qemp
			_nempen:=sb2->b2_reserva+sb2->b2_qemp
			_cst:=sb2->b2_cm1

			sd1->(dbseek(_cfilsd1+tmp1->produto+"98"+dtos(sb1->b1_ucom)))
			_nucom :=sd1->d1_quant
			if empty(_emissao) .and. sb1->b1_ucom > _dinimed
				_ok := .f.
			endif	
			if !empty(_nsaldo)  .and. _ok
				//	   	    aadd(_acom,{tmp1->produto,sb1->b1_desc,_nsaldo,_nempen,dtoc(sb2->b2_usai),_numov,dtoc(sb1->b1_ucom),_nucom})
				aadd(_acom,{tmp1->produto,sb1->b1_desc,_local,_tipo,_nsaldo,(_cst*_nsaldo),_nempen,dtoc(_emissao),_quant,dtoc(sb1->b1_ucom),_nucom})
			endif
		endif
	else
		_nsaldo:=0
		_nempen:=0
	endif
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if lcontinua
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	_nest :=0
	_nemp :=0
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	for _i:=1 to len(_acom)
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
//Codigo Descricao                  Loc Tipo     Estoque  Vlr.Cst.Med.       Empenho  Ult.Movim.   Qtde.Mov.  Ult.Compra  Qtde.Compra
//999999 xxxxxxxxxxxxxxxxxxxxxxxxx  99  xx  9,999,999.99  9,999,999.99  9,999,999.99  99/99/99  9,999,999.99  99/99/99   9,999,999.99

		@ prow()+1,000 PSAY left(_acom[_i,1],6)
		@ prow() ,007   PSAY left(_acom[_i,2],25)
		@ prow() ,034   PSAY _acom[_i,3] 
		@ prow() ,038   PSAY _acom[_i,4] 
		@ prow() ,042   PSAY _acom[_i,5]  picture "@E 9,999,999.99"
		@ prow() ,056   PSAY _acom[_i,6]  picture "@E 9,999,999.99"
		@ prow() ,070   PSAY _acom[_i,7]  picture "@E 9,999,999.99"
		@ prow() ,084   PSAY _acom[_i,8]
		@ prow() ,094   PSAY _acom[_i,9]  picture "@E 9,999,999.99"
		@ prow() ,108   PSAY _acom[_i,10]
		@ prow() ,119   PSAY _acom[_i,11] picture "@E 9,999,999.99"
	next
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
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

static function _geratmp()
procregua(1)
incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_COD PRODUTO"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_ESTOQUE='S'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery +=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery +=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY"
_cquery+=" B1_DESC"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"

return





static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Data Limite        ?","mv_ch7","D",08,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
S A I D A S                        E S T O Q U E
Codigo Descricao                                Mes Ant.   No Mes   No Dia    Media  Ent.Mes  Ent.Dia Processo  Empenho    Saldo Pendencia Dias Quarentena          Valor
XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999  9999.999 9999   9999.999 999.999.999,99
*/

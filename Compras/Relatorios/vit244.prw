/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT244   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 22/09/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Divergencias Pc X Nf                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit244()
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="DIVERGENCIAS ENTRE PC X NF"
cdesc1   :="Este programa ira emitir a relação de divergências entre PC X NF"
cdesc2   :=""
cdesc3   :=""
cstring  :="SC7"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT244"
wnrel    :="VIT244"+Alltrim(cusername)
aordem   :={"Produto","Fornecedor","Data de entrada"}
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT244"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.f.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)
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
titulo:="DIVERGENCIAS ENTRE PC X NF NO PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)

cabec1:=" NOTA"
cabec2:="PEDIDO     EMISSAO  FORNECEDOR                               PRODUTO                                        UM CONS.MED. CST.MED  QUANTIDADE           VALOR UNITARIO          VALOR TOTAL ENTREGA  CONDICAO DE PAGTO."

_cfilsa2:=xfilial("SA2")
_cfilsb1:=xfilial("SB1")
_cfilsb3:=xfilial("SB3")
_cfilsb2:=xfilial("SB2")
_cfilsc7:=xfilial("SC7")
_cfilsd1:=xfilial("SD1")
_cfilse4:=xfilial("SE4")
_cfilsf1:=xfilial("SF1")
_cfilsf4:=xfilial("SF4")

processa({|| _geratmp()})

setprc(0,0)

setregua(sd1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	
	_limp  :=.f.
	if nordem==1 // PRODUTO
		_ccod  :=tmp1->cod
		_ccondw:="tmp1->cod==_ccod"
	elseif nordem==2 // FORNECEDOR
		_cfornece:=tmp1->fornece
		_cloja   :=tmp1->loja
		_ccondw  :="tmp1->fornece==_cfornece .and. tmp1->loja==_cloja"
	else // DATA DE ENTRADA
		_ddtdigit:=tmp1->dtdigit
		_ccondw  :="tmp1->dtdigit==_ddtdigit"
	endif
	while ! tmp1->(eof()) .and.;
		&_ccondw .and.;
		lcontinua
		
		incregua()
		
		sf1->(dbsetorder(1))
		sf1->(dbseek(_cfilsf1+tmp1->doc+tmp1->serie+tmp1->fornece+tmp1->loja))
		
		_nvunit:=round(tmp1->total/tmp1->quant,6)
		
		_ldiv:=.f.
		_lntp:=.f.
		_ldde:=.f.
		_ldqt:=.f.
		_ldpr:=.f.
		_ldcp:=.f.
		if empty(tmp1->pedido) // NAO TEM PEDIDO
			_lntp:=.t.
			_ldiv:=.t.
		else
			sc7->(dbsetorder(1))
			sc7->(dbseek(_cfilsc7+tmp1->pedido+tmp1->itempc))
			
			if mv_par19==1 // DIVERGENCIA NA DATA DE ENTREGA
				_ndifdias:=tmp1->dtdigit-sc7->c7_datprf
				if abs(_ndifdias)>mv_par20
					_ldde:=.t.
					_ldiv:=.t.
				endif
			endif
			
			if mv_par21==1 // DIVERGENCIA NA QUANTIDADE
				_ndifquant:=tmp1->quant-sc7->c7_quant
				_nperquant:=(_ndifquant/sc7->c7_quant)*100
				if abs(_nperquant)>mv_par22
					_ldqt:=.t.
					_ldiv:=.t.
				endif
			endif
			
			if mv_par23==1 // DIVERGENCIA NO PRECO
				_ndifpreco:=_nvunit-sc7->c7_preco
				_nperpreco:=(_ndifpreco/sc7->c7_preco)*100
				if abs(_nperpreco)>mv_par24
					_ldpr:=.t.
					_ldiv:=.t.
				endif
			endif
			
			if mv_par25==1 // DIVERGENCIA NA CONDICAO DE PAGAMENTO
				if sf1->f1_cond<>sc7->c7_cond
					_ldcp:=.t.
					_ldiv:=.t.
				endif
			endif
		endif
		
		if _ldiv
			
			_limp:=.t.
			
			if prow()==0 .or. prow()>56
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			
			sa2->(dbsetorder(1))
			sa2->(dbseek(_cfilsa2+tmp1->fornece+tmp1->loja))
			sb3->(dbsetorder(1))
			sb3->(dbseek(_cfilsb3+tmp1->cod))
			sb2->(dbsetorder(1))
			sb2->(dbseek(_cfilsb2+tmp1->cod))
			se4->(dbsetorder(1))
			se4->(dbseek(_cfilse4+sf1->f1_cond))
			
			@ prow()+2,000 PSAY tmp1->doc+"/"+tmp1->serie
			@ prow(),011   PSAY tmp1->emissao
			@ prow(),020   PSAY tmp1->fornece+"/"+tmp1->loja+"-"+left(sa2->a2_nome,30)
			@ prow(),061   PSAY substr(tmp1->cod,1,6)+"-"+left(tmp1->descri,30)
			@ prow(),102   PSAY tmp1->um
			@ prow(),105   PSAY sb3->b3_media picture "@E 99,999,999"
			@ prow(),116   PSAY sb2->b2_cm1 picture "@E 99,999,999"
			@ prow(),132   PSAY tmp1->quant picture "@E 99,999,999.99"
			@ prow(),152   PSAY _nvunit picture "@E 999,999,999.999999"
			@ prow(),172   PSAY _nvunit picture "@E 999,999,999.999999"
			@ prow(),177   PSAY tmp1->total picture "@E 999,999,999.99"
			@ prow(),192   PSAY tmp1->dtdigit
			@ prow(),201   PSAY sf1->f1_cond+"-"+left(se4->e4_descri,15)
			
			if _lntp
				@ prow()+1,000 PSAY "NAO HA PEDIDO DE COMPRA COLOCADO"
			else
				se4->(dbsetorder(1))
				se4->(dbseek(_cfilse4+sc7->c7_cond))
				
				@ prow()+1,000 PSAY tmp1->pedido
				@ prow(),011   PSAY sc7->c7_emissao
				@ prow(),132   PSAY sc7->c7_quant picture "@E 99,999,999.99"
				@ prow(),152   PSAY sc7->c7_preco picture "@E 999,999,999.999999"
				@ prow(),177   PSAY sc7->c7_total picture "@E 999,999,999.99"
				@ prow(),192   PSAY sc7->c7_datprf
				@ prow(),201   PSAY sc7->c7_cond+"-"+left(se4->e4_descri,15)
				
				@ prow()+1,000 PSAY "DIVERGENCIAS"
				if _ldqt // DIVERGENCIA NA QUANTIDADE
					@ prow(),132   PSAY _ndifquant picture "@E 99,999,999.99"
					@ prow(),146   PSAY _nperquant picture "@E 9999%"
				endif
				if _ldpr // DIVERGENCIA NO PRECO
					@ prow(),152   PSAY _ndifpreco picture "@E 999,999,999.999999"
					@ prow(),171   PSAY _nperpreco picture "@E 9999%"
				endif
				if _ldqt .or. _ldpr // SE HOUVER DIFERENCA NA QUANTIDADE OU NO PRECO IMPRIME A DIFERENCA NO VALOR TOTAL
					@ prow(),177   PSAY tmp1->total-sc7->c7_total picture "@E 999,999,999.99"
				endif
				if _ldde // DIVERGENCIA NA DATA DE ENTREGA
					@ prow(),192   PSAY transform(_ndifdias,"@E 999")+" DIAS"
				endif
			endif
		endif
		
		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
	end
	if _limp
		@ prow()+1,000 PSAY replicate("-",limite)
	endif
end

if prow()>0
	roda(cbcont,cbtxt)
endif

tmp1->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif

ms_flush()
return

static function _geratmp()
procregua(1)

incproc("Selecionando registros...")

_cquery:=" SELECT"
_cquery+=" D1_DOC DOC,"
_cquery+=" D1_SERIE SERIE,"
_cquery+=" D1_PEDIDO PEDIDO,"
_cquery+=" D1_ITEMPC ITEMPC,"
_cquery+=" D1_EMISSAO EMISSAO,"
_cquery+=" D1_FORNECE FORNECE,"
_cquery+=" D1_LOJA LOJA,"
_cquery+=" D1_COD COD,"
_cquery+=" B1_DESC DESCRI,"
_cquery+=" D1_UM UM,"
_cquery+=" D1_DTDIGIT DTDIGIT,"
_cquery+=" SUM(D1_QUANT) QUANT,"
_cquery+=" SUM(D1_TOTAL-D1_VALDESC) TOTAL"
_cquery+=" FROM "
_cquery+=  retsqlname("SD1")+" SD1,"
_cquery+=  retsqlname("SF4")+" SF4,"
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE"
_cquery+="     SD1.D_E_L_E_T_<>'*'"
_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND D1_FILIAL='"+_cfilsd1+"'"
_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND D1_TES=F4_CODIGO"
_cquery+=" AND F4_DUPLIC='S'"
_cquery+=" AND D1_COD=B1_COD"
_cquery+=" AND (B1_PCOBRIG='S' OR D1_PEDIDO<>'      ')"
_cquery+=" AND D1_TIPO IN ('N')"
_cquery+=" AND D1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND D1_FORNECE BETWEEN '"+mv_par03+"' AND '"+mv_par05+"'"
_cquery+=" AND D1_LOJA BETWEEN '"+mv_par04+"' AND '"+mv_par06+"'"
_cquery+=" AND D1_COD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND D1_TP BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
_cquery+=" AND D1_GRUPO BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
_cquery+=" AND D1_DOC BETWEEN '"+mv_par13+"' AND '"+mv_par15+"'"
_cquery+=" AND D1_SERIE BETWEEN '"+mv_par14+"' AND '"+mv_par16+"'"
_cquery+=" AND D1_PEDIDO BETWEEN '"+mv_par17+"' AND '"+mv_par18+"'"
_cquery+=" GROUP BY"
_cquery+=" D1_DOC,D1_SERIE,D1_PEDIDO,D1_ITEMPC,D1_EMISSAO,D1_FORNECE,D1_LOJA,D1_COD,B1_DESC,D1_UM,D1_DTDIGIT"
//_cquery+=" 1,2,3,4,5,6,7,8,9,10,11"
_cquery+=" ORDER BY"
if nordem==1 // PRODUTO
	_cquery+=" 8,11,1,2,3"
elseif nordem==2 // FORNECEDOR
	_cquery+=" 6,7,11,1,2,3"
else // DATA DE ENTRADA
	_cquery+=" 11,1,2,3"
endif

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","QUANT"  ,"N",11,2)
tcsetfield("TMP1","TOTAL"  ,"N",14,2)
tcsetfield("TMP1","DTDIGIT","D")
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do fornecedor      ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"FOR"})
aadd(_agrpsx1,{cperg,"04","Da loja            ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Ate o fornecedor   ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"FOR"})
aadd(_agrpsx1,{cperg,"06","Ate a loja         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do produto         ?","mv_ch7","C",15,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"08","Ate o produto      ?","mv_ch8","C",15,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"09","Do tipo            ?","mv_ch9","C",02,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"10","Ate o tipo         ?","mv_chA","C",02,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"11","Do grupo           ?","mv_chB","C",04,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"12","Ate o grupo        ?","mv_chC","C",04,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"13","Da nota            ?","mv_chD","C",06,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"14","Da serie           ?","mv_chE","C",03,0,0,"G",space(60),"mv_par14"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"15","Ate a nota         ?","mv_chF","C",06,0,0,"G",space(60),"mv_par15"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"16","Ate a serie        ?","mv_chG","C",03,0,0,"G",space(60),"mv_par16"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"17","Do pedido          ?","mv_chH","C",06,0,0,"G",space(60),"mv_par17"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC7"})
aadd(_agrpsx1,{cperg,"18","Ate o pedido       ?","mv_chI","C",06,0,0,"G",space(60),"mv_par18"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC7"})
aadd(_agrpsx1,{cperg,"19","Div. data entrega  ?","mv_chJ","N",01,0,0,"C",space(60),"mv_par19"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"20","Dias de tolerancia ?","mv_chK","N",02,0,0,"G",space(60),"mv_par20"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"21","Div. quantidade    ?","mv_chL","N",01,0,0,"C",space(60),"mv_par21"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"22","% de tolerancia    ?","mv_chM","N",03,0,0,"G",space(60),"mv_par22"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"23","Div. preco         ?","mv_chN","N",01,0,0,"C",space(60),"mv_par23"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"24","% de tolerancia    ?","mv_chO","N",03,0,0,"G",space(60),"mv_par24"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"25","Div. cond. pagto.  ?","mv_chP","N",01,0,0,"C",space(60),"mv_par25"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
NOTA
PEDIDO     EMISSAO  FORNECEDOR                               PRODUTO                                                  UM CONS.MEDIO    QUANTIDADE           VALOR UNITARIO          VALOR TOTAL ENTREGA  CONDICAO DE PAGTO.
999999/XXX 99/99/99 999999/99-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 99.999.999 99,999,999.99       999.999.999,999999       999.999.999,99 99/99/99 999-XXXXXXXXXXXXXXX
999999     99/99/99                                                                                                                 99,999,999.99       999.999.999,999999       999.999.999,99 99/99/99 999-XXXXXXXXXXXXXXX
DIVERGENCIAS                                                                                                                        99,999,999.99 9999% 999.999.999,999999 9999% 999.999.999,99 999 DIAS
*/

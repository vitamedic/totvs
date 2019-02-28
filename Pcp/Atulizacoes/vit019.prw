/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT019   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 28/01/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Simulacao de Producao                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³22/03/04 - Edson Tratamento de Quantidade Basica            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit019()
ccadastro:="Simulacao producao"
arotina  :={}
aadd(arotina,{"Pesquisar" ,"axpesqui"                    ,0,1})
aadd(arotina,{"Visualizar","axvisual"                    ,0,2})
aadd(arotina,{"Incluir"   ,"axinclui"                    ,0,3})
aadd(arotina,{"Alterar"   ,"axaltera"                    ,0,4})
aadd(arotina,{"Excluir"   ,"axdeleta"                    ,0,5})
aadd(arotina,{"Limpar"    ,'execblock("VIT019A",.f.,.f.)',0,6})
aadd(arotina,{"Imprimir"  ,'execblock("VIT019B",.f.,.f.)',0,7})
sz2->(dbsetorder(1))
sz2->(dbgotop())
sz2->(mbrowse(006,001,022,075,"SZ2"))
return

user function vit019a()
if msgyesno("Confirma a exclusao de todos os registros da simulacao?")
	_cfilsz2:=xfilial("SZ2")
	_ccomando:="DELETE FROM "+retsqlname("SZ2")+" WHERE Z2_FILIAL='"+_cfilsz2+"'"
	tcsqlexec(_ccomando)
	sz2->(dbgotop())
	sysrefresh()
endif
return

user function vit019b()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="SIMULACAO DE OP COM NECESSIDADE DE COMPRAS"
cdesc1   :="Este programa ira emitir a simulacao de ordens de producao"
cdesc2   :=""
cdesc3   :=""
cstring  :="SZ2"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT019"
wnrel    :="VIT019"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:=""

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

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

_nregsz2:=sz2->(recno())

rptstatus({|| rptdetail()})

sz2->(dbgoto(_nregsz2))
return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:=""
cabec2:=""

_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsc1:=xfilial("SC1")
_cfilsc7:=xfilial("SC7")
_cfilsg1:=xfilial("SG1")
_cfilsz2:=xfilial("SZ2")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sc1->(dbsetorder(1))
sc7->(dbsetorder(1))
sg1->(dbsetorder(1))
sz2->(dbsetorder(1))

_aesttmp:={}
aadd(_aesttmp,{"COMP" ,"C",15,0})
aadd(_aesttmp,{"QUANT","N",12,2})

_carqtmp1:=criatrab(_aesttmp,.t.)

dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)

_cindtmp1:=criatrab(,.f.)
_cchave  :="COMP"
tmp1->(indregua("TMP1",_cindtmp1,_cchave,,,"Selecionando registros..."))

setprc(0,0)

setregua(sz2->(lastrec()*2))

sz2->(dbseek(_cfilsz2))
while ! sz2->(eof()) .and.;
		sz2->z2_filial==_cfilsz2 .and.;
      lcontinua
	incregua()
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	sb1->(dbseek(_cfilsb1+sz2->z2_produto))
	@ prow()+1,000 PSAY left(sz2->z2_produto,6)+" - "+left(sb1->b1_desc,40)
	@ prow(),050   PSAY "UM: "+sb1->b1_um
	@ prow(),057   PSAY "Lote padrao: "+transform(sb1->b1_qb,"@E 999,999,999")
	@ prow(),082   PSAY "Qtde. a fab.: "+transform(sz2->z2_quant,"@E 999,999,999")
	_geratmp(sz2->z2_produto,sb1->b1_qb,sz2->z2_quant)
	sz2->(dbskip())
   if labortprint
      @ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
      lcontinua:=.f.
   endif
end
	
_aee      :={}
_aen      :={}
_amp      :={}
_ccq      :=getmv("MV_CQ")
tmp1->(dbgotop())
while ! tmp1->(eof())
	sb1->(dbseek(_cfilsb1+tmp1->comp))
	if sb2->(dbseek(_cfilsb2+tmp1->comp+sb1->b1_locpad))
		_nqatu   :=sb2->b2_qatu
		_nqemp   :=sb2->b2_qemp
		_nqtddisp:=_nqatu-_nqemp
	else
		_nqatu   :=0
		_nqemp   :=0
		_nqtddisp:=0
	endif
	if sb2->(dbseek(_cfilsb2+tmp1->comp+_ccq))
		_nquarent:=sb2->b2_qatu-sb2->b2_qemp
	else
		_nquarent:=0
	endif
	_nqtdnec:=((_nqtddisp+_nquarent)-tmp1->quant)*(-1)
	if _nqtdnec<0
		_nqtdnec:=0
	endif
	
	_cquery:=" SELECT"
	_cquery+=" SUM(C1_QUANT-C1_QUJE) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC1")+" SC1"
	_cquery+=" WHERE"
	_cquery+="     SC1.D_E_L_E_T_<>'*'"
	_cquery+=" AND C1_FILIAL='"+_cfilsc1+"'"
	_cquery+=" AND C1_QUANT-C1_QUJE>0"
	_cquery+=" AND C1_PRODUTO='"+tmp1->comp+"'"
	
	_cquery:=changequery(_cquery)

	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",12,2)
	
	tmp2->(dbgotop())
	_nsolic:=tmp2->quant
	tmp2->(dbclosearea())
  
	_cquery:=" SELECT"
	_cquery+=" SUM(C7_QUANT-C7_QUJE) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC7")+" SC7"
	_cquery+=" WHERE"
	_cquery+="     SC7.D_E_L_E_T_<>'*'"
	_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
	_cquery+=" AND C7_QUANT-C7_QUJE>0"
	_cquery+=" AND C7_RESIDUO=' '"
	_cquery+=" AND C7_PRODUTO='"+tmp1->comp+"'"
	
	_cquery:=changequery(_cquery)

	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",12,2)
	
	tmp2->(dbgotop())
	_npedido:=tmp2->quant
	tmp2->(dbclosearea())
  
	if sb1->b1_tipo=="EE"
		aadd(_aee,{left(tmp1->comp,6),left(sb1->b1_desc,30),sb1->b1_um,tmp1->quant,_nqatu,_nquarent,_nqemp,;
					  _nqtdnec,_nsolic+_npedido})
	elseif sb1->b1_tipo=="EN"
		aadd(_aen,{left(tmp1->comp,6),left(sb1->b1_desc,30),sb1->b1_um,tmp1->quant,_nqatu,_nquarent,_nqemp,;
					  _nqtdnec,_nsolic+_npedido})
	elseif sb1->b1_tipo<>"MO" 
		aadd(_amp,{left(tmp1->comp,6),left(sb1->b1_desc,30),sb1->b1_um,tmp1->quant,_nqatu,_nquarent,_nqemp,;
					  _nqtdnec,_nsolic+_npedido})
	endif
	tmp1->(dbskip())
   if labortprint
      @ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
      lcontinua:=.f.
   endif
end

@ prow()+1,000 PSAY replicate("-",limite)
@ prow()+1,000 PSAY "Codigo Descricao                      UM   Quantidade        Estoque    Empenho    Disponivel  Quarentena   Necessidade    Em Aberto"
@ prow()+1,000 PSAY replicate("-",limite)
cabec1:="Codigo Descricao                      UM   Quantidade        Estoque       Empenho       Disponivel Quarentena Necessidade    Em Aberto"

_aees:=asort(_aee,,,{|x,y| x[2]<y[2]})
_aens:=asort(_aen,,,{|x,y| x[2]<y[2]})
_amps:=asort(_amp,,,{|x,y| x[2]<y[2]})

@ prow()+2,000 PSAY "MAT. EMBALAGEM ESSENCIAL"
@ prow()+1,000 PSAY " "
for _i:=1 to len(_aees)
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif                           
	@ prow()+1,000 PSAY _aees[_i,1]
	@ prow(),007   PSAY _aees[_i,2]
	@ prow(),038   PSAY _aees[_i,3]
	@ prow(),041   PSAY _aees[_i,4] picture "@E 99999,999.99"
	@ prow(),054   PSAY _aees[_i,5] picture "@E 9999999,999.99"
	@ prow(),067   PSAY _aees[_i,7] picture "@E 9999,999.99"
	@ prow(),079   PSAY (_aees[_i,5]-_aees[_i,7]) picture "@E 99999,999.99"
	@ prow(),092   PSAY _aees[_i,6] picture "@E 99999,999.99"
	@ prow(),105   PSAY _aees[_i,8] picture "@E 99999,999.99"
	@ prow(),118   PSAY _aees[_i,9] picture "@E 999,999,999.99"
next

@ prow()+2,000 PSAY "MAT. EMBALAGEM NAO ESSENCIAL"
@ prow()+1,000 PSAY " "
_ndisp:=0
for _i:=1 to len(_aens)
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY _aens[_i,1]
	@ prow(),007   PSAY _aens[_i,2]
	@ prow(),038   PSAY _aens[_i,3]
	@ prow(),041   PSAY _aens[_i,4] picture "@E 99999,999.99"
	@ prow(),054   PSAY _aens[_i,5] picture "@E 9999999,999.99"
	@ prow(),067   PSAY _aens[_i,7] picture "@E 9999,999.99"
	@ prow(),079   PSAY _aens[_i,5]-_aens[_i,7] picture "@E 99999,999.99"
	@ prow(),092   PSAY _aens[_i,6] picture "@E 99999,999.99"
	@ prow(),105   PSAY _aens[_i,8] picture "@E 99999,999.99"
	@ prow(),118   PSAY _aens[_i,9] picture "@E 999,999,999.99"

/*	@ prow(),067   PSAY _aens[_i,6] picture "@E 9999,999.99"
	@ prow(),079   PSAY _aens[_i,7] picture "@E 99999,999.99"
	@ prow(),092   PSAY _aens[_i,8] picture "@E 99999,999.99"
	@ prow(),105   PSAY _aens[_i,9] picture "@E 99999,999.99"
	@ prow(),118   PSAY _aens[_i,10] picture "@E 999,999,999.99"*/
next

@ prow()+2,000 PSAY "MATERIA PRIMA"
@ prow()+1,000 PSAY " " 
_mtmat := 0
_mt1 := 0
_mt2 := 0
_mt3 := 0
_mt4 := 0
_mt5 := 0
_mt6 := 0

for _i:=1 to len(_amps)
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY _amps[_i,1]
	@ prow(),007   PSAY _amps[_i,2]
	@ prow(),038   PSAY _amps[_i,3]
	@ prow(),041   PSAY _amps[_i,4] picture "@E 99999,999.99"
	@ prow(),054   PSAY _amps[_i,5] picture "@E 9999999,999.99"
	@ prow(),067   PSAY _amps[_i,7] picture "@E 9999,999.99"
	@ prow(),079   PSAY (_amps[_i,5]-_amps[_i,7]) picture "@E 99999,999.99"
	@ prow(),092   PSAY _amps[_i,6] picture "@E 99999,999.99"
	@ prow(),105   PSAY _amps[_i,8] picture "@E 99999,999.99"
	@ prow(),118   PSAY _amps[_i,9] picture "@E 999,999,999.99"

/*	_mtmat += _amps[_i,4]   // retirado a pedido Sandro PCP em 07/06/05.
	_mt1 += _amps[_i,5]   
	_mt2 += _amps[_i,6]   
	_mt3 += _amps[_i,7]   
	_mt4 += _amps[_i,6]   
	_mt5 += _amps[_i,8]   
	_mt6 += _amps[_i,9]   */
next      
/*if prow()>55
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
endif
@ prow()+1,000 PSAY "TOTAL MATERIA PRIMA"
@ prow()  ,041   PSAY _mtmat picture "@E 99999,999.99"
//prow(),054   PSAY _mt1 picture "@E 99999,999.99"
@ prow(),067   PSAY _mt2 picture "@E 9999,999.99"
@ prow(),079   PSAY _mt3 picture "@E 99999,999.99"
@ prow(),092   PSAY _mt4 picture "@E 99999,999.99"
@ prow(),105   PSAY _mt5 picture "@E 99999,999.99"
@ prow(),118   PSAY _mt6 picture "@E 999,999,999.99"*/
if prow()>0 .and.;
	lcontinua
   roda(cbcont,cbtxt)
endif

set device to screen

_cindtmp1+=tmp1->(ordbagext())
tmp1->(dbclosearea())
ferase(_carqtmp1+getdbextension())
ferase(_cindtmp1)

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endIf

ms_flush()
return

static function _geratmp(_cproduto,_nqb,_nquant)
local _nregsg1
sg1->(dbseek(_cfilsg1+_cproduto))
while ! sg1->(eof()) .and.;
		sg1->g1_filial==_cfilsg1 .and.;
		sg1->g1_cod==_cproduto

	_nqtdsg1:=sg1->g1_quant
	sb1->(dbseek(_cfilsb1+sg1->g1_comp))
	_nregsg1:=sg1->(recno())
	sg1->(dbseek(_cfilsg1+sb1->b1_cod))
	if sb1->b1_tipo=="PI"
//		_nregsg1:=sg1->(recno())
		_geratmp(sb1->b1_cod,sb1->b1_qb,(_nqtdsg1/_nqb)*_nquant)
		sg1->(dbgoto(_nregsg1))
	else
		sg1->(dbgoto(_nregsg1))
		if ! tmp1->(dbseek(sg1->g1_comp))
			tmp1->(dbappend())
			tmp1->comp :=sg1->g1_comp
			tmp1->quant:=(sg1->g1_quant/_nqb)*_nquant
		else
			tmp1->quant+=(sg1->g1_quant/_nqb)*_nquant
		endif
	endif
	sg1->(dbskip())
end
return

/*
xxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx UM: xx Lote padrao: 999.999.999 Qtde. a fab.: 999.999.999
Codigo Descricao                      UM   Quantidade      Estoque  Quarentena      Empenho  Necessidade  Solicitacao       Pedido
xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx 99999.999,99 99999.999,99 9999.999,99 99999.999,99 99999.999,99 99999.999,99 99999.999,99
*/

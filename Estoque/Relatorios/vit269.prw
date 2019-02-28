/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT269   ³ Autor ³ Aline                ³ Data ³ 29/06/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Fretes de Entrada / Fatura                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

//Variaveis utilizadas para parametros
//mv_par01 Da Fatura
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT269()
nordem   :=""
tamanho  :="G"
limite   :=132
titulo   :="Acompanhamento de Entrada de Compras/Frete "
cdesc1   :="Este programa ira emitir o relatorio de conhecimentos de frete/notas compra,pedidos e solicitações   "
cdesc2   :=" "
cdesc3   :=""
cstring  :="SF8"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT269"
wnrel    :="VIT269"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT127"
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
_cfilsf1:=xfilial("SF1")
_cfilsd1:=xfilial("SD1")
_cfilsa2:=xfilial("SA2")
_cfilsf8:=xfilial("SF8")
_cfilsa4:=xfilial("SA4")
_cfilse2:=xfilial("SE2")
_cfilszb:=xfilial("SZB")
_cfilsc7:=xfilial("SC7")
_cfilsc1:=xfilial("SC1")
sf1->(dbsetorder(1))
sd1->(dbsetorder(1))
sa2->(dbsetorder(1))
sa4->(dbsetorder(1))
sf8->(dbsetorder(2))
se2->(dbsetorder(1))
szb->(dbsetorder(1))
sc7->(dbsetorder(4))
sc1->(dbsetorder(6))


processa({|| _querys()})

sa2->(dbseek(_cfilsa2+mv_par03))
cabec1:="Transp. : "+mv_par03 +"-"+sa2->a2_nome + "  período: "+dtoc(mv_par04)+ " a "+dtoc(mv_par05 )
cabec2:="Emissao   Conhec.    Entrada   Dif.  Emissao   Nota       Entrada    Dif.  Pedido    Solicitacao  Necess.   NxE  UF  Fornecedor"
//Emissao   Conhec.    Entrada   Dif.  Emissao   Nota       Entrada    Dif.  Pedido    Solicitacao  Necess.   NxE  UF  Fornecedor
//99/99/99  999999999  99/99/99  999   99/99/99  999999999  99/99/99   999   99/99/99  99/99/99     99/99/99  999  xx  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


setprc(0,0)


tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	sa2->(dbseek(_cfilsa2+tmp1->fornece))
	_nfdifre:=tmp1->nfdifre
	_sedifre:=tmp1->sedifre
	_nforig:=tmp1->nforig
	_serorig:=tmp1->serorig
	_transp:=tmp1->transp
	_lojtran:=tmp1->lojtran
	_fornece:=tmp1->fornece
	_loja:=tmp1->loja
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	sf1->(dbseek(_cfilsf1+_nfdifre+_sedifre+_transp+_lojtran))
	@ prow()+1,000 PSAY sf1->f1_emissao
	@ prow(),010 PSAY _nfdifre
	@ prow(),021 PSAY tmp1->dtdigit
	@ prow(),031 PSAY tmp1->dtdigit-sf1->f1_emissao  picture "@E 999"
	sf1->(dbseek(_cfilsf1+_nforig+_serorig+_fornece+_loja))	
	_passou :=.f.
	while ! tmp1->(eof()) .and.;
		lcontinua .and. _nfdifre==tmp1->nfdifre  .and. _sedifre==tmp1->sedifre
		sd1->(dbseek(_cfilsd1+tmp1->nforig+tmp1->serorig+tmp1->fornece+tmp1->loja))
		sf1->(dbseek(_cfilsf1+tmp1->nforig+tmp1->serorig+tmp1->fornece+tmp1->loja))
		sc7->(dbseek(_cfilsc7+sd1->d1_cod+sd1->d1_pedido))
		sc1->(dbseek(_cfilsc1+sc7->c7_num+sc7->c7_item+sc7->c7_produto))		
		if !_passou
			@ prow(),037 PSAY sf1->f1_emissao
			_passou :=.t.
		else
			@ prow()+1,037 PSAY sf1->f1_emissao //sa2->a2_cod
		endif
		@ prow(),047 PSAY tmp1->nforig
		@ prow(),058 PSAY sf1->f1_dtdigit
		@ prow(),069 PSAY sf1->f1_dtdigit-sf1->f1_emissao  picture "@E 999"	
		@ prow(),075 PSAY sc7->c7_emissao
		@ prow(),085 PSAY sc1->c1_emissao
		@ prow(),098 PSAY sc1->c1_datprf 
		@ prow(),108 PSAY sf1->f1_dtdigit-sc1->c1_datprf  picture "@E 999"	
		@ prow(),113 PSAY sa2->a2_est
		@ prow(),117 PSAY sa2->a2_cod+"-"+sa2->a2_loja+"  "+substr(sa2->a2_nome,1,30)
		tmp1->(dbskip())
	end
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
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
_cquery+=" F8_NFORIG NFORIG,F8_SERORIG SERORIG,F8_FORNECE FORNECE,F8_LOJA LOJA,F8_DTDIGIT DTDIGIT,"
_cquery+=" F8_NFDIFRE NFDIFRE,F8_SEDIFRE SEDIFRE,F8_TRANSP TRANSP,F8_LOJTRAN LOJTRAN"
_cquery+=" FROM "
_cquery+=  retsqlname("SF8")+" SF8"
_cquery+=" WHERE"
_cquery+="     SF8.D_E_L_E_T_<>'*'"
_cquery+=" AND F8_FILIAL='"+_cfilsf8+"'"
_cquery+=" AND F8_NFDIFRE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND F8_TRANSP = '"+mv_par03+"'
_cquery+=" AND F8_DTDIGIT BETWEEN '"+dtos(mv_par04)+"' AND '"+dtos(mv_par05)+"'"

_cquery+=" ORDER BY F8_NFDIFRE"



_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DTDIGIT","D")
//tcsetfield("TMP1","VALBRUT"  ,"N",15,2)
return

static function _pergsx1()
_agrpsx1:={}

aadd(_agrpsx1,{cperg,"01","Da Nota            ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a Nota         ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da Transportadora  ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
aadd(_agrpsx1,{cperg,"04","Da Data            ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Ate a Data         ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

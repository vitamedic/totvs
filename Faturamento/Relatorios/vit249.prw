/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT249   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 01/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Notas Fiscais Saída por Período e Cliente                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function vit249()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="NOTA FISCAL POR PERIODO E CLIENTES"
cdesc1  :="Este programa ira emitir a Notas Fiscais por Periodo e Clientes"
cdesc2  :=""
cdesc3  :=""
cstring :="SF2"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT249"
wnrel   :="VIT249"+Alltrim(cusername)
alinha  :={}
nlastkey:=0
aordem  :={}
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)

cperg:="PERGVIT249"
_pergsx1()
pergunte(cperg,.f.)


wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)

if nlastkey==27
	set filter to
	return
endif

rptstatus({|| rptdetail()})
return

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
_cfilsf2:=xfilial("SF2")
_cfilsa1:=xfilial("SA1")
_cfilsd2:=xfilial("SD2")
_cfilsb1:=xfilial("SB1")
sf2->(dbsetorder(1))
sa1->(dbsetorder(1))
sd2->(dbsetorder(3))
sb1->(dbsetorder(1))

_valtot:=0
_valbase:=0
_valicm:=0
_valpis:=0
_valcofins:=0

_qtnota:=0

processa({|| _querys()})
if mv_par07==1
	_mtipo := " SOMENTE ZONA FRANCA"
elseif mv_par08=2
	_mtipo:= " SOMENTE ESTADUAL"
elseif mv_par08=3
	_mtipo:= " SOMENTE INTERESTADUAL"
elseif mv_par08=4
	_mtipo:=" SOMENTE ORGAO PUBLICO"
else
	_mtipo:=""
endif

//Informação sobre o faturamento da NF: LISTA POSITIVA / LISTA NEGATIVA
if mv_par09==1 			// LISTA POSITIVA
	_mlista:=" LISTA POSITIVA"
elseif mv_par09==2 		//LISTA NEGATIVA
	_mlista:=" LISTA NEGATIVA"
else				         // AMBAS
	_mlista:=" LISTA POSITIVA/NEGATIVA"
endif

cabec1:="PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)+_mtipo+_mlista
cabec2:="Emissao    NF/Serie     Cliente    Descricao                       Cidade              UF  CFOP     Total Nota      Base ICMS     Valor ICMS            PIS         COFINS"
setprc(0,0)
@ 000,000 PSAY avalimp(133)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif

	sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))

	_npis:=0
	_ncofins:=0
	_lista:=""
	sd2->(dbseek(_cfilsd2+tmp1->doc+tmp1->serie+tmp1->cliente+tmp1->loja))
	while !sd2->(eof()) .and.;
		sd2->d2_doc==tmp1->doc .and.;
		sd2->d2_serie==tmp1->serie .and.;
		sd2->d2_cliente == tmp1->cliente .and.;
		sd2->d2_loja == tmp1->loja
		
		_npis += sd2->d2_valimp6
		_ncofins += sd2->d2_valimp5
		_ncfop := sd2->d2_cf // Informado a Contabilidade que o valor atribuido a cf pode ficar errado no caso de notas com cfop diferente na mesma nota
		
		//Se cliente for Zona Franca e tiver Suframa, lista NEGATIVA é equiparada a lista POSITIVA
		if empty(sa1->a1_codmun)
			sb1->(dbseek(_cfilsb1+sd2->d2_cod))
			_lista:=sb1->b1_grtrib
		else 
			_lista:="001"
		endif
		sd2->(dbskip())
	end
	
	if (mv_par09==1 .or. mv_par09==3) .and. _lista$"001/003"
		@ prow()+1,000 PSAY tmp1->emissao
		@ prow(),011   PSAY tmp1->doc+"-"
		@ prow(),021   PSAY tmp1->serie
		@ prow(),024   PSAY sa1->a1_cod+"-"
		@ prow(),031   PSAY sa1->a1_loja
		@ prow(),035   PSAY substr(sa1->a1_nome,1,30)
		@ prow(),067   PSAY substr(sa1->a1_mun,1,18)
		@ prow(),087   PSAY sa1->a1_est
		@ prow(),091   PSAY _ncfop
		@ prow(),096   PSAY tmp1->valmerc picture "@E 999,999,999.99"
		@ prow(),111   PSAY tmp1->baseicm picture "@E 999,999,999.99"
		@ prow(),126   PSAY tmp1->valicm picture "@E 999,999,999.99"
		@ prow(),141   PSAY _npis picture "@E 999,999,999.99"
		@ prow(),156   PSAY _ncofins picture "@E 999,999,999.99"
		_valtot+= tmp1->valmerc
		_valbase+= tmp1->baseicm
		_valicm+= tmp1->valicm
		_valpis+= _npis
		_valcofins+= _ncofins
		_qtnota++
	elseif (mv_par09==2 .or. mv_par09==3) .and. _lista$"002/004"
		@ prow()+1,000 PSAY tmp1->emissao
		@ prow(),011   PSAY tmp1->doc+"-"
		@ prow(),021   PSAY tmp1->serie
		@ prow(),024   PSAY sa1->a1_cod+"-"
		@ prow(),031   PSAY sa1->a1_loja
		@ prow(),035   PSAY substr(sa1->a1_nome,1,30)
		@ prow(),067   PSAY substr(sa1->a1_mun,1,18)
		@ prow(),087   PSAY sa1->a1_est
		@ prow(),091   PSAY _ncfop
		@ prow(),096   PSAY tmp1->valmerc picture "@E 999,999,999.99"
		@ prow(),111   PSAY tmp1->baseicm picture "@E 999,999,999.99"
		@ prow(),126   PSAY tmp1->valicm picture "@E 999,999,999.99"
		@ prow(),141   PSAY _npis picture "@E 999,999,999.99"
		@ prow(),156   PSAY _ncofins picture "@E 999,999,999.99"
		_valtot+= tmp1->valmerc
		_valbase+= tmp1->baseicm
		_valicm+= tmp1->valicm
		_valpis+= _npis
		_valcofins+= _ncofins
		_qtnota++
	endif
	
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if prow()>60
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
endif
if !empty(_qtnota)
	@ prow()+1,001 PSAY "Qtde. Notas: "
	@ prow(),022 PSAY _qtnota
	@ prow(),096 PSAY _valtot picture "@E 999,999,999.99"
	@ prow(),111 PSAY _valbase picture "@E 999,999,999.99"
	@ prow(),126 PSAY _valicm picture "@E 999,999,999.99"
	@ prow(),141 PSAY _valpis picture "@E 999,999,999.99"
	@ prow(),156 PSAY _valcofins picture "@E 999,999,999.99"
endif

if prow()>0 .and. lcontinua
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

static function _querys()

_cquery:=" SELECT"
_cquery+=" F2_DOC DOC,"
_cquery+=" F2_SERIE SERIE,"
_cquery+=" F2_CLIENTE CLIENTE,"
_cquery+=" F2_LOJA LOJA,"
_cquery+=" F2_EMISSAO EMISSAO,"
_cquery+=" F2_VALMERC VALMERC,"
_cquery+=" F2_BASEICM BASEICM,"
_cquery+=" F2_VALICM  VALICM"
_cquery+=" FROM "

if (mv_par07==1) .or. (mv_par08>1) // .or. (mv_par08==3))
	_cquery+=  retsqlname("SF2")+" SF2,"
	_cquery+=  retsqlname("SA1")+" SA1"
else
	_cquery+=  retsqlname("SF2")+" SF2"
endif

_cquery+=" WHERE"
_cquery+="     SF2.D_E_L_E_T_<>'*'"
_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
_cquery+=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND F2_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND F2_LOJA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND (F2_TIPO='N'"
_cquery+=" OR F2_TIPO='C')"

if (mv_par07==1) // ZONA FRANCA
	_cquery+=" AND F2_CLIENTE=A1_COD"
	_cquery+=" AND F2_LOJA=A1_LOJA"
	_cquery+=" AND A1_CODMUN<>' '"
endif

if (mv_par08==2)  // Estadual
	_cquery+=" AND F2_CLIENTE=A1_COD"
	_cquery+=" AND F2_LOJA=A1_LOJA"
	_cquery+=" AND F2_EST='GO'"
endif

if mv_par08==3 //Interestadual
	_cquery+=" AND F2_CLIENTE=A1_COD"
	_cquery+=" AND F2_LOJA=A1_LOJA"
	_cquery+=" AND F2_EST<>'GO'"
endif

if mv_par08==4 //Estadual Orgao Publico
	_cquery+=" AND F2_CLIENTE=A1_COD"
	_cquery+=" AND F2_LOJA=A1_LOJA"
	_cquery+=" AND F2_EST='GO'"
	_cquery+=" AND F2_TIPOCLI='F'"
//	_cquery+=" AND A1_TIPO='F'"
endif

if mv_par08==5 //Interestadual Orgao Publico
	_cquery+=" AND F2_CLIENTE=A1_COD"
	_cquery+=" AND F2_LOJA=A1_LOJA"
	_cquery+=" AND F2_EST<>'GO'"
	_cquery+=" AND F2_TIPOCLI='F'"
endif

_cquery+=" ORDER BY F2_EMISSAO, F2_DOC"


_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","VALMERC","N",12,2)

return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do cliente         ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"04","Ate o cliente      ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"05","Da loja            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"06","Ate a loja         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"07","So Cliente Zona Fra?","mv_ch7","N",01,0,0,"C",space(60),"mv_par07"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Operações          ?","mv_ch8","N",01,0,0,"C",space(60),"mv_par08"       ,"1-Todas     "   ,space(30),space(15),"2-Estadual     ",space(30),space(15),"3-Interestadual",space(30),space(15),"4-Est. Orgao "  ,space(30),space(15),"5-Inters.Orgao" ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Lista              ?","mv_ch9","N",01,0,0,"C",space(60),"mv_par09"       ,"Positiva    "   ,space(30),space(15),"Negativa       ",space(30),space(15),"Ambas          ",space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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



/* 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT271   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 15/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Vendas por ABC/Clientes × 12 Meses            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit271()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="RELATORIO DE VENDAS POR CLIENTES x 12 MESES"
cdesc1  :="Este programa ira emitir a relacao de Venda por Cliente"
cdesc2  :="em um periodo de 12 meses, anteriores a data de referencia"
cdesc3  :=""
cstring :="SF2"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT271"
wnrel   :="VIT271"+Alltrim(cusername)
alinha  :={}
aordem  :={"Alfabetica","Ranking"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

_cperg:="PERGVIT271"
_pergsx1()
pergunte(_cperg,.f.)

wnrel:=setprint(cstring,wnrel,_cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

if nlastkey==27
	set filter to
	if mv_par05=="2"
		tcquit()
	endif
	return
endif

if mv_par05=="2"
	if sm0->m0_codigo<>"02" .or.;
		(upper(alltrim(getenvserver()))<>"BACKUP" .and. upper(alltrim(getenvserver()))<>"BKP")
		msgstop("Programa não habilitado para esta filial!")
		return
	endif
	if tclink("oracle/dadosadv","192.168.1.20")<>0
		msgstop("Falha de conexao com o banco!")
		tcquit()
		return
	endif
endif

rptstatus({|| rptdetail()})
if mv_par05=="2"
	tcquit()
endif
return

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)
_aper :={}
_atot :={}
_asubtot:={}


//************************************************
// Definição do Período (12 meses) pelo parâmetro
//************************************************

_mes := month(mv_par01)
_ano := year(mv_par01)

if _mes=12
	_mesini:=1
	_anoini:=_ano
else
	_mesini:=_mes+1
	_anoini:=_ano-1
endif

for _i:=1 to 12
	
	_pdtini:=ctod("01/"+strzero(_mesini,2)+"/"+strzero(_anoini,4))
	_mdia:=31
	_pdtfin:=ctod(strzero(_mdia,2)+"/"+strzero(_mesini,2)+"/"+strzero(_anoini,4))
	
	while empty(_pdtfin)
		_pdtfin := ctod(strzero(_mdia,2)+"/"+strzero(_mesini,2)+"/"+strzero(_anoini,4))
		_mdia --
		skip
	end
	
	aadd(_aper,{_pdtini,_pdtfin,strzero(day(_pdtini),2)+"/"+strzero(month(_pdtini),2)+" - "+strzero(day(_pdtfin),2)+"/"+strzero(month(_pdtfin),2)})

	if _mesini=12
		_mesini:=1 
		_anoini++
	else
		_mesini++
	endif
	
next

for i:=1 to 4
	aadd(_atot,{0,0,0,0,0,0,0,0,0,0,0,0})
	aadd(_asubtot,{0,0,0,0,0,0,0,0,0,0,0,0})
next

cabec1:="Ordem  Codigo Nome                  UF|  PERIODO 01 |  PERIODO 02 |  PERIODO 03 |  PERIODO 04 |  PERIODO 05 |  PERIODO 06 |  PERIODO 07 |  PERIODO 08 |  PERIODO 09 |  PERIODO 10 |  PERIODO 11 |  PERIODO 12 |TOTAL PERIODO"
cabec2:="                                      |"+_aper[1,3]+"|"+_aper[2,3]+"|"+_aper[3,3]+"|"+_aper[4,3]+"|"+_aper[5,3]+"|"+_aper[6,3]+"|"+_aper[7,3]+"|"+_aper[8,3]+"|"+_aper[9,3]+"|"+_aper[10,3]+"|"+_aper[11,3]+"|"+_aper[12,3]+"|"

_cfilsa1:=xfilial("SA1")
_cfilsb1:=xfilial("SB1")
_cfilsd2:=xfilial("SD2")
_cfilsa3:=xfilial("SA3")
_cfilsf2:=xfilial("SF2")
_cfilsf4:=xfilial("SF4")
_cfilsc5:=xfilial("SC5")
_cfilda0:=xfilial("DA0")

sa1->(dbsetorder(1))
sb1->(dbsetorder(1))
sd2->(dbsetorder(3))
sa3->(dbsetorder(1))
sf2->(dbsetorder(1))
sf4->(dbsetorder(1))
sc5->(dbsetorder(1))
da0->(dbsetorder(1))

if mv_par05=="2"
	_abretop("SA1010",1)
	_abretop("SB1010",1)
	_abretop("SD2010",3)
	_abretop("SA3010",1)
	_abretop("SF2010",1)
	_abretop("SF4010",1)
	_abretop("SC5010",1)
	_abretop("DA0010",1)
	_cindsf2:=criatrab(,.f.)
	_cchave :="F2_FILIAL+DTOS(F2_EMISSAO)+F2_CLIENTE+F2_LOJA"
	_cfiltro:="F2_TIPO$'NC'"
	sf2010->(indregua("SF2010",_cindsf2,_cchave,,_cfiltro))
endif


_cindsf2:=criatrab(,.f.)
_cchave :="F2_FILIAL+DTOS(F2_EMISSAO)+F2_CLIENTE+F2_LOJA"
_cfiltro:="F2_TIPO$'NC'"
sf2->(indregua("SF2",_cindsf2,_cchave,,_cfiltro))

_aestrut:={}
aadd(_aestrut,{"CLIENTE"  ,"C",6,0})
aadd(_aestrut,{"LOJA"     ,"C",2,0})
aadd(_aestrut,{"NOME"     ,"C",30,0})
aadd(_aestrut,{"UF"		  ,"C",2,0})
aadd(_aestrut,{"VALORFF1" ,"N",13,2})
aadd(_aestrut,{"VALICH1"  ,"N",13,2})
aadd(_aestrut,{"VALICF1"  ,"N",13,2})
aadd(_aestrut,{"VALORFF2" ,"N",13,2})
aadd(_aestrut,{"VALICH2"  ,"N",13,2})
aadd(_aestrut,{"VALICF2"  ,"N",13,2})
aadd(_aestrut,{"VALORFF3" ,"N",13,2})
aadd(_aestrut,{"VALICH3"  ,"N",13,2})
aadd(_aestrut,{"VALICF3"  ,"N",13,2})
aadd(_aestrut,{"VALORFF4" ,"N",13,2})
aadd(_aestrut,{"VALICH4"  ,"N",13,2})
aadd(_aestrut,{"VALICF4"  ,"N",13,2})
aadd(_aestrut,{"VALORFF5" ,"N",13,2})
aadd(_aestrut,{"VALICH5"  ,"N",13,2})
aadd(_aestrut,{"VALICF5"  ,"N",13,2})
aadd(_aestrut,{"VALORFF6" ,"N",13,2})
aadd(_aestrut,{"VALICH6"  ,"N",13,2})
aadd(_aestrut,{"VALICF6"  ,"N",13,2})
aadd(_aestrut,{"VALORFF7" ,"N",13,2})
aadd(_aestrut,{"VALICH7"  ,"N",13,2})
aadd(_aestrut,{"VALICF7"  ,"N",13,2})
aadd(_aestrut,{"VALORFF8" ,"N",13,2})
aadd(_aestrut,{"VALICH8"  ,"N",13,2})
aadd(_aestrut,{"VALICF8"  ,"N",13,2})
aadd(_aestrut,{"VALORFF9" ,"N",13,2})
aadd(_aestrut,{"VALICH9"  ,"N",13,2})
aadd(_aestrut,{"VALICF9"  ,"N",13,2})
aadd(_aestrut,{"VALORFF10","N",13,2})
aadd(_aestrut,{"VALICH10" ,"N",13,2})
aadd(_aestrut,{"VALICF10" ,"N",13,2})
aadd(_aestrut,{"VALORFF11","N",13,2})
aadd(_aestrut,{"VALICH11" ,"N",13,2})
aadd(_aestrut,{"VALICF11" ,"N",13,2})
aadd(_aestrut,{"VALORFF12","N",13,2})
aadd(_aestrut,{"VALICH12" ,"N",13,2})
aadd(_aestrut,{"VALICF12" ,"N",13,2})
aadd(_aestrut,{"TOTAL"    ,"N",14,2})
aadd(_aestrut,{"TOTLF"    ,"N",14,2})
aadd(_aestrut,{"TOTLH"    ,"N",14,2})
aadd(_aestrut,{"TOTFF"    ,"N",14,2})

_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
_cindtmp11:=criatrab(,.f.)
_cchave   :="cliente+loja"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))

_cindtmp12:=criatrab(,.f.)
_cchave   :="nome"
tmp1->(indregua("TMP1",_cindtmp12,_cchave))

_cindtmp13:=criatrab(,.f.)
_cchave   :="strzero(total,14,2)+nome"
tmp1->(indregua("TMP1",_cindtmp13,_cchave))

_cindtmp14:=criatrab(,.f.)
_cchave   :="strzero(totff,14,2)+nome"
tmp1->(indregua("TMP1",_cindtmp14,_cchave))

_cindtmp15:=criatrab(,.f.)
_cchave   :="strzero(totlf,14,2)+nome"
tmp1->(indregua("TMP1",_cindtmp15,_cchave))

_cindtmp16:=criatrab(,.f.)
_cchave   :="strzero(totlh,14,2)+nome"
tmp1->(indregua("TMP1",_cindtmp16,_cchave))

tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetindex(_cindtmp12))
tmp1->(dbsetindex(_cindtmp13))
tmp1->(dbsetindex(_cindtmp14))
tmp1->(dbsetindex(_cindtmp15))
tmp1->(dbsetindex(_cindtmp16))

tmp1->(dbsetorder(1))

// PESQUISA CODIGO DO SUPERVISOR
sa3->(dbsetorder(7))
if sa3->(dbseek(_cfilsa3+__cuserid))
	_cgerente:=sa3->a3_cod
else
	_cgerente:=space(6)
endif

_nvalortot :=0                      
_subtotper:=0

processa({|| _calcmov()})
setregua(tmp1->(lastrec()))

setprc(0,0)
tmp1->(dbsetorder(1))
tmp1->(dbgotop())

// CALCULA TOTALIZADORES POR CLIENTE APÓS CRIAÇÃO DO ARQUIVO TEMPORÁRIO

while !eof()                        
	tmp1->totff:=tmp1->valorff1+tmp1->valorff2+tmp1->valorff3+tmp1->valorff4+tmp1->valorff5+tmp1->valorff6+;
			tmp1->valorff7+tmp1->valorff8+tmp1->valorff9+tmp1->valorff10+tmp1->valorff11+tmp1->valorff12

	tmp1->totlf:=tmp1->valicf1+tmp1->valicf2+tmp1->valicf3+tmp1->valicf4+tmp1->valicf5+tmp1->valicf6+;
			tmp1->valicf7+tmp1->valicf8+tmp1->valicf9+tmp1->valicf10+tmp1->valicf11+tmp1->valicf12

	tmp1->totlh:=tmp1->valich1+tmp1->valich2+tmp1->valich3+tmp1->valich4+tmp1->valich5+tmp1->valich6+;
			tmp1->valich7+tmp1->valich8+tmp1->valich9+tmp1->valich10+tmp1->valich11+tmp1->valich12

	tmp1->total:=tmp1->totff+tmp1->totlf+tmp1->totlh

	tmp1->(dbskip())
end

if (nordem==1)  						// ORDEM ALFABÉTICA
	if (mv_par04==1)
		titulo  :="RELATORIO DE VENDAS POR CLIENTES x 12 MESES (ORDEM ALFABETICA - TOTAL VENDAS FARMA)"
	elseif (mv_par04==2)
		titulo  :="RELATORIO DE VENDAS POR CLIENTES x 12 MESES (ORDEM ALFABETICA - TOTAL VENDAS LIC. FARMA)"
	elseif (mv_par04==3)
		titulo  :="RELATORIO DE VENDAS POR CLIENTES x 12 MESES (ORDEM ALFABETICA - TOTAL VENDAS LIC. HOSPITALAR)"
	else
		titulo  :="RELATORIO DE VENDAS POR CLIENTES x 12 MESES (ORDEM ALFABETICA - TOTAL GERAL VENDAS)"
	endif
	tmp1->(dbsetorder(2))
	tmp1->(dbgotop())
	_ccond:="! tmp1->(eof())"
else  					  			// ORDEM RANKING (ABC)
	if mv_par04==1		  			// TOTALIZA VENDA FARMA
		titulo  :="RELATORIO DE VENDAS POR CLIENTES x 12 MESES (RANKING VENDAS FARMA)"
		tmp1->(dbsetorder(4))
	elseif mv_par04==2			// TOTALIZA VENDA LICITAÇÃO FARMA
		titulo  :="RELATORIO DE VENDAS POR CLIENTES x 12 MESES (RANKING LIC. FARMA)"
		tmp1->(dbsetorder(5))
	elseif mv_par04==3			// TOTALIZA VENDA LICITAÇÃO HOSPITALAR
		titulo  :="RELATORIO DE VENDAS POR CLIENTES x 12 MESES (RANKING LIC.HOSPITALAR)"
		tmp1->(dbsetorder(6))
	else								// TOTALIZA VENDAS EM GERAL
		titulo  :="RELATORIO DE VENDAS POR CLIENTES x 12 MESES (RANKING TOTAL VENDAS)"
		tmp1->(dbsetorder(3))
	endif

	tmp1->(dbgobottom())
	_ccond:="! tmp1->(bof())"
endif

_npacum :=0
_nperc  :=0
_nc     := .t.
_i		  :=1

for _j:=1 to 12 
	_asubtot[1,_j]:=0 // Sub-total geral faturamento farma
	_asubtot[2,_j]:=0 // Sub-total geral faturamento licitação farma
	_asubtot[3,_j]:=0 // Sub-total geral faturamento licitação hospitalar
	_asubtot[4,_j]:=0	// Sub-total geral faturamento para 1 período
next	



while &_ccond .and.;
	lcontinua

	incregua()
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif

	if mv_par04==1 		// Comparativo para vendas Farma
		_nvalortot:=_atot[1,1]+_atot[1,2]+_atot[1,3]+_atot[1,4]+_atot[1,5]+_atot[1,6]+_atot[1,7]+_atot[1,8]+_atot[1,9]+;
						_atot[1,10]+_atot[1,11]+_atot[1,12]
						
		_nperc :=round(((tmp1->totff)/_nvalortot)*100,2)
		_npacum+=_nperc
		
	elseif mv_par04==2 	// Comparativo para vendas Licitação Farma
		_nvalortot:=_atot[2,1]+_atot[2,2]+_atot[2,3]+_atot[2,4]+_atot[2,5]+_atot[2,6]+_atot[2,7]+_atot[2,8]+_atot[2,9]+;
						_atot[2,10]+_atot[2,11]+_atot[2,12]
						
		_nperc :=round(((tmp1->totlf)/_nvalortot)*100,2)
		_npacum+=_nperc	
	elseif mv_par04==3 	// Comparativo para vendas Licitação Hospitalar
		_nvalortot:=_atot[3,1]+_atot[3,2]+_atot[3,3]+_atot[3,4]+_atot[3,5]+_atot[3,6]+_atot[3,7]+_atot[3,8]+_atot[3,9]+;
						_atot[3,10]+_atot[3,11]+_atot[3,12]
						
		_nperc :=round(((tmp1->totlh)/_nvalortot)*100,2)
		_npacum+=_nperc
	
	else 						// Comparativo para total de vendas
		_nvalortot:=_atot[4,1]+_atot[4,2]+_atot[4,3]+_atot[4,4]+_atot[4,5]+_atot[4,6]+_atot[4,7]+_atot[4,8]+_atot[4,9]+;
						_atot[4,10]+_atot[4,11]+_atot[4,12]
						
		_nperc :=round(((tmp1->total)/_nvalortot)*100,2)
		_npacum+=_nperc
	endif

	if (_npacum <= 50.99) .and.;
	 	(_i == 1) .and.;
	 	(nordem>1)
		@ prow()+1,000 PSAY "CLIENTES A "
		
	elseif (_npacum > 51 .and. _npacum <= 80) .and.;
			 _nc .and.;
			 (nordem>1)

		_nc 		  := .f.
		_subtotper := 0
		_j			  := mv_par04

		for _k:=1 to 12
			_subtotper+=_asubtot[_j,_k]
		next

		if prow()>58
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		@ prow()+1,000 PSAY "SUB-TOTAL :"
		@ prow(),039   PSAY _asubtot[_j,1] picture "@E 99,999,999.99"
		@ prow(),052   PSAY "|"
		@ prow(),053   PSAY _asubtot[_j,2] picture "@E 99,999,999.99"
		@ prow(),066   PSAY "|"
		@ prow(),067   PSAY _asubtot[_j,3] picture "@E 99,999,999.99"
		@ prow(),080   PSAY "|"         
		@ prow(),081   PSAY _asubtot[_j,4] picture "@E 99,999,999.99"
		@ prow(),094   PSAY "|"
		@ prow(),095   PSAY _asubtot[_j,5] picture "@E 99,999,999.99"
		@ prow(),108   PSAY "|"
		@ prow(),109   PSAY _asubtot[_j,6] picture "@E 99,999,999.99"
		@ prow(),122   PSAY "|"
		@ prow(),123   PSAY _asubtot[_j,7] picture "@E 99,999,999.99"
		@ prow(),136   PSAY "|"
		@ prow(),137   PSAY _asubtot[_j,8] picture "@E 99,999,999.99"
		@ prow(),150   PSAY "|"
		@ prow(),151   PSAY _asubtot[_j,9] picture "@E 99,999,999.99"
		@ prow(),164   PSAY "|"
		@ prow(),165   PSAY _asubtot[_j,10] picture "@E 99,999,999.99"
		@ prow(),178   PSAY "|"
		@ prow(),179   PSAY _asubtot[_j,11] picture "@E 99,999,999.99"
		@ prow(),192   PSAY "|"
		@ prow(),193   PSAY _asubtot[_j,12] picture "@E 99,999,999.99"
		@ prow(),206   PSAY "|"
		@ prow(),207   PSAY _subtotper picture "@E 99,999,999.99"
	
		for _j:=1 to 12 
			_asubtot[1,_j]:=0 // Sub-total geral faturamento farma
			_asubtot[2,_j]:=0 // Sub-total geral faturamento licitação farma
			_asubtot[3,_j]:=0 // Sub-total geral faturamento licitação hospitalar
			_asubtot[4,_j]:=0	// Sub-total geral faturamento para 1 período
		next	
		@ prow()+2,000 PSAY "CLIENTES B "

	elseif _npacum > 80 .and. (nordem>1)
		if !_nc

			_j:= mv_par04
			_subtotper:=0
			for _k:=1 to 12
				_subtotper+=_asubtot[_j,_k]
			next
		
			if !empty(_subtotper)  // Verificar tratamento se OK
				if prow()>58
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
				endif

				@ prow()+1,000 PSAY "SUB-TOTAL :"
				@ prow(),039   PSAY _asubtot[_j,1] picture "@E 99,999,999.99"
				@ prow(),052   PSAY "|"
				@ prow(),053   PSAY _asubtot[_j,2] picture "@E 99,999,999.99"
				@ prow(),066   PSAY "|"
				@ prow(),067   PSAY _asubtot[_j,3] picture "@E 99,999,999.99"
				@ prow(),080   PSAY "|"         
				@ prow(),081   PSAY _asubtot[_j,4] picture "@E 99,999,999.99"
				@ prow(),094   PSAY "|"
				@ prow(),095   PSAY _asubtot[_j,5] picture "@E 99,999,999.99"
				@ prow(),108   PSAY "|"
				@ prow(),109   PSAY _asubtot[_j,6] picture "@E 99,999,999.99"
				@ prow(),122   PSAY "|"
				@ prow(),123   PSAY _asubtot[_j,7] picture "@E 99,999,999.99"
				@ prow(),136   PSAY "|"
				@ prow(),137   PSAY _asubtot[_j,8] picture "@E 99,999,999.99"
				@ prow(),150   PSAY "|"
				@ prow(),151   PSAY _asubtot[_j,9] picture "@E 99,999,999.99"
				@ prow(),164   PSAY "|"
				@ prow(),165   PSAY _asubtot[_j,10] picture "@E 99,999,999.99"
				@ prow(),178   PSAY "|"
				@ prow(),179   PSAY _asubtot[_j,11] picture "@E 99,999,999.99"
				@ prow(),192   PSAY "|"
				@ prow(),193   PSAY _asubtot[_j,12] picture "@E 99,999,999.99"
		
				@ prow(),206   PSAY "|"
				@ prow(),207   PSAY _subtotper picture "@E 99,999,999.99"
		
				for _j:=1 to 12 
					_asubtot[1,_j]:=0 // Sub-total geral faturamento farma
					_asubtot[2,_j]:=0 // Sub-total geral faturamento licitação farma
					_asubtot[3,_j]:=0 // Sub-total geral faturamento licitação hospitalar
					_asubtot[4,_j]:=0	// Sub-total geral faturamento para 1 período
				next	
			endif
			@ prow()+1,000 PSAY " "
			@ prow()+1,000 PSAY "CLIENTES C "
		endif
		_nc = .t.
	endif

	if (mv_par04==1) .and. (tmp1->totff<>0)
		@ prow()+1,000 PSAY _i  picture "999"
		_i++
		@ prow(),005   PSAY tmp1->cliente+"-"+tmp1->loja
		@ prow(),015   PSAY substr(tmp1->nome,1,20)
		@ prow(),036   PSAY tmp1->uf+"|"
		@ prow(),039   PSAY tmp1->valorff1 picture "@E 99,999,999.99"
		@ prow(),052   PSAY "|"
		@ prow(),053   PSAY tmp1->valorff2 picture "@E 99,999,999.99"
		@ prow(),066   PSAY "|"
		@ prow(),067   PSAY tmp1->valorff3 picture "@E 99,999,999.99"
		@ prow(),080   PSAY "|"
		@ prow(),081   PSAY tmp1->valorff4 picture "@E 99,999,999.99"
		@ prow(),094   PSAY "|"
		@ prow(),095   PSAY tmp1->valorff5 picture "@E 99,999,999.99"
		@ prow(),108   PSAY "|"
		@ prow(),109   PSAY tmp1->valorff6 picture "@E 99,999,999.99"
		@ prow(),122   PSAY "|"
		@ prow(),123   PSAY tmp1->valorff7 picture "@E 99,999,999.99"
		@ prow(),136   PSAY "|"
		@ prow(),137   PSAY tmp1->valorff8 picture "@E 99,999,999.99"
		@ prow(),150   PSAY "|"
		@ prow(),151   PSAY tmp1->valorff9 picture "@E 99,999,999.99"
		@ prow(),164   PSAY "|"
		@ prow(),165   PSAY tmp1->valorff10 picture "@E 99,999,999.99"
		@ prow(),178   PSAY "|"
		@ prow(),179   PSAY tmp1->valorff11 picture "@E 99,999,999.99"
		@ prow(),192   PSAY "|"
		@ prow(),193   PSAY tmp1->valorff12 picture "@E 99,999,999.99"
		
		@ prow(),206   PSAY "|"
		@ prow(),207   PSAY tmp1->totff picture "@E 99,999,999.99"
		
		_asubtot[1,1]+= tmp1->valorff1
		_asubtot[1,2]+= tmp1->valorff2
		_asubtot[1,3]+= tmp1->valorff3
		_asubtot[1,4]+= tmp1->valorff4
		_asubtot[1,5]+= tmp1->valorff5
		_asubtot[1,6]+= tmp1->valorff6
		_asubtot[1,7]+= tmp1->valorff7
		_asubtot[1,8]+= tmp1->valorff8
		_asubtot[1,9]+= tmp1->valorff9
		_asubtot[1,10]+= tmp1->valorff10
		_asubtot[1,11]+= tmp1->valorff11
		_asubtot[1,12]+= tmp1->valorff12

	elseif (mv_par04==2) .and. (tmp1->totlf<>0)
		@ prow()+1,000 PSAY _i  picture "999"
		_i++
		@ prow(),005   PSAY tmp1->cliente+"-"+tmp1->loja
		@ prow(),015   PSAY substr(tmp1->nome,1,20)
		@ prow(),036   PSAY tmp1->uf+"|"
		@ prow(),039   PSAY tmp1->valicf1 picture "@E 99,999,999.99"
		@ prow(),052   PSAY "|"
		@ prow(),053   PSAY tmp1->valicf2 picture "@E 99,999,999.99"
		@ prow(),066   PSAY "|"
		@ prow(),067   PSAY tmp1->valicf3 picture "@E 99,999,999.99"
		@ prow(),080   PSAY "|"
		@ prow(),081   PSAY tmp1->valicf4 picture "@E 99,999,999.99"
		@ prow(),094   PSAY "|"
		@ prow(),095   PSAY tmp1->valicf5 picture "@E 99,999,999.99"
		@ prow(),108   PSAY "|"
		@ prow(),109   PSAY tmp1->valicf6 picture "@E 99,999,999.99"
		@ prow(),122   PSAY "|"
		@ prow(),123   PSAY tmp1->valicf7 picture "@E 99,999,999.99"
		@ prow(),136   PSAY "|"
		@ prow(),137   PSAY tmp1->valicf8 picture "@E 99,999,999.99"
		@ prow(),150   PSAY "|"
		@ prow(),151   PSAY tmp1->valicf9 picture "@E 99,999,999.99"
		@ prow(),164   PSAY "|"
		@ prow(),165   PSAY tmp1->valicf10 picture "@E 99,999,999.99"
		@ prow(),178   PSAY "|"
		@ prow(),179   PSAY tmp1->valicf11 picture "@E 99,999,999.99"
		@ prow(),192   PSAY "|"
		@ prow(),193   PSAY tmp1->valicf12 picture "@E 99,999,999.99"
		
		@ prow(),206   PSAY "|"
		@ prow(),207   PSAY tmp1->totlf picture "@E 99,999,999.99"

		_asubtot[2,1]+= tmp1->valicf1
		_asubtot[2,2]+= tmp1->valicf2
		_asubtot[2,3]+= tmp1->valicf3
		_asubtot[2,4]+= tmp1->valicf4
		_asubtot[2,5]+= tmp1->valicf5
		_asubtot[2,6]+= tmp1->valicf6
		_asubtot[2,7]+= tmp1->valicf7
		_asubtot[2,8]+= tmp1->valicf8
		_asubtot[2,9]+= tmp1->valicf9
		_asubtot[2,10]+= tmp1->valicf10
		_asubtot[2,11]+= tmp1->valicf11
		_asubtot[2,12]+= tmp1->valicf12

	elseif (mv_par04==3) .and. (tmp1->totlh<>0)
		@ prow()+1,000 PSAY _i  picture "999"
		_i++
		@ prow(),005   PSAY tmp1->cliente+"-"+tmp1->loja
		@ prow(),015   PSAY substr(tmp1->nome,1,20)
		@ prow(),036   PSAY tmp1->uf+"|"
		@ prow(),039   PSAY tmp1->valich1 picture "@E 99,999,999.99"
		@ prow(),052   PSAY "|"
		@ prow(),053   PSAY tmp1->valich2 picture "@E 99,999,999.99"
		@ prow(),066   PSAY "|"
		@ prow(),067   PSAY tmp1->valich3 picture "@E 99,999,999.99"
		@ prow(),080   PSAY "|"
		@ prow(),081   PSAY tmp1->valich4 picture "@E 99,999,999.99"
		@ prow(),094   PSAY "|"
		@ prow(),095   PSAY tmp1->valich5 picture "@E 99,999,999.99"
		@ prow(),108   PSAY "|"
		@ prow(),109   PSAY tmp1->valich6 picture "@E 99,999,999.99"
		@ prow(),122   PSAY "|"
		@ prow(),123   PSAY tmp1->valich7 picture "@E 99,999,999.99"
		@ prow(),136   PSAY "|"
		@ prow(),137   PSAY tmp1->valich8 picture "@E 99,999,999.99"
		@ prow(),150   PSAY "|"
		@ prow(),151   PSAY tmp1->valich9 picture "@E 99,999,999.99"
		@ prow(),164   PSAY "|"
		@ prow(),165   PSAY tmp1->valich10 picture "@E 99,999,999.99"
		@ prow(),178   PSAY "|"
		@ prow(),179   PSAY tmp1->valich11 picture "@E 99,999,999.99"
		@ prow(),192   PSAY "|"
		@ prow(),193   PSAY tmp1->valich12 picture "@E 99,999,999.99"
		
		@ prow(),206   PSAY "|"
		@ prow(),207   PSAY tmp1->totlh picture "@E 99,999,999.99"

		_asubtot[3,1]+= tmp1->valich1
		_asubtot[3,2]+= tmp1->valich2
		_asubtot[3,3]+= tmp1->valich3
		_asubtot[3,4]+= tmp1->valich4
		_asubtot[3,5]+= tmp1->valich5
		_asubtot[3,6]+= tmp1->valich6
		_asubtot[3,7]+= tmp1->valich7
		_asubtot[3,8]+= tmp1->valich8
		_asubtot[3,9]+= tmp1->valich9
		_asubtot[3,10]+= tmp1->valich10
		_asubtot[3,11]+= tmp1->valich11
		_asubtot[3,12]+= tmp1->valich12

	elseif (mv_par04==4) .and. (tmp1->total<>0)
		@ prow()+1,000 PSAY _i  picture "999"
		_i++
		@ prow(),005   PSAY tmp1->cliente+"-"+tmp1->loja
		@ prow(),015   PSAY substr(tmp1->nome,1,20)
		@ prow(),036   PSAY tmp1->uf+"|"
		@ prow(),039   PSAY (tmp1->valorff1+tmp1->valicf1+tmp1->valich1) picture "@E 99,999,999.99"
		@ prow(),052   PSAY "|"
		@ prow(),053   PSAY (tmp1->valorff2+tmp1->valicf2+tmp1->valich2) picture "@E 99,999,999.99"
		@ prow(),066   PSAY "|"
		@ prow(),067   PSAY (tmp1->valorff3+tmp1->valicf3+tmp1->valich3) picture "@E 99,999,999.99"
		@ prow(),080   PSAY "|"
		@ prow(),081   PSAY (tmp1->valorff4+tmp1->valicf4+tmp1->valich4) picture "@E 99,999,999.99"
		@ prow(),094   PSAY "|"
		@ prow(),095   PSAY (tmp1->valorff5+tmp1->valicf5+tmp1->valich5) picture "@E 99,999,999.99"
		@ prow(),108   PSAY "|"
		@ prow(),109   PSAY (tmp1->valorff6+tmp1->valicf6+tmp1->valich6) picture "@E 99,999,999.99"
		@ prow(),122   PSAY "|"
		@ prow(),123   PSAY (tmp1->valorff7+tmp1->valicf7+tmp1->valich7) picture "@E 99,999,999.99"
		@ prow(),136   PSAY "|"
		@ prow(),137   PSAY (tmp1->valorff8+tmp1->valicf8+tmp1->valich8) picture "@E 99,999,999.99"
		@ prow(),150   PSAY "|"
		@ prow(),151   PSAY (tmp1->valorff9+tmp1->valicf9+tmp1->valich9) picture "@E 99,999,999.99"
		@ prow(),164   PSAY "|"
		@ prow(),165   PSAY (tmp1->valorff10+tmp1->valicf10+tmp1->valich10) picture "@E 99,999,999.99"
		@ prow(),178   PSAY "|"
		@ prow(),179   PSAY (tmp1->valorff11+tmp1->valicf11+tmp1->valich11) picture "@E 99,999,999.99"
		@ prow(),192   PSAY "|"
		@ prow(),193   PSAY (tmp1->valorff12+tmp1->valicf12+tmp1->valich12) picture "@E 99,999,999.99"
		
		@ prow(),206   PSAY "|"
		@ prow(),207   PSAY tmp1->total picture "@E 99,999,999.99"

		_asubtot[4,1]+= tmp1->valorff1+tmp1->valicf1+tmp1->valich1
		_asubtot[4,2]+= tmp1->valorff2+tmp1->valicf2+tmp1->valich2
		_asubtot[4,3]+= tmp1->valorff3+tmp1->valicf3+tmp1->valich3
		_asubtot[4,4]+= tmp1->valorff4+tmp1->valicf4+tmp1->valich4
		_asubtot[4,5]+= tmp1->valorff5+tmp1->valicf5+tmp1->valich5
		_asubtot[4,6]+= tmp1->valorff6+tmp1->valicf6+tmp1->valich6
		_asubtot[4,7]+= tmp1->valorff7+tmp1->valicf7+tmp1->valich7
		_asubtot[4,8]+= tmp1->valorff8+tmp1->valicf8+tmp1->valich8
		_asubtot[4,9]+= tmp1->valorff9+tmp1->valicf9+tmp1->valich9
		_asubtot[4,10]+= tmp1->valorff10+tmp1->valicf10+tmp1->valich10
		_asubtot[4,11]+= tmp1->valorff11+tmp1->valicf11+tmp1->valich11
		_asubtot[4,12]+= tmp1->valorff12+tmp1->valicf12+tmp1->valich12

	endif
	
	if nordem==2
		tmp1->(dbskip(-1))
	else
		tmp1->(dbskip())
	endif
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if prow()>0 .and.;
	lcontinua .and. (nordem>1)
	if prow()>58
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif

	_j:= mv_par04
	_subtotper:=0
	for _k:=1 to 12
		_subtotper+=_asubtot[_j,_k]
	next

	if !empty(_subtotper) // Verificar tratamento se OK 
		if prow()>58
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif

		@ prow()+1,000 PSAY "SUB-TOTAL :"
		@ prow(),039   PSAY _asubtot[_j,1] picture "@E 99,999,999.99"
		@ prow(),052   PSAY "|"
		@ prow(),053   PSAY _asubtot[_j,2] picture "@E 99,999,999.99"
		@ prow(),066   PSAY "|"
		@ prow(),067   PSAY _asubtot[_j,3] picture "@E 99,999,999.99"
		@ prow(),080   PSAY "|"         
		@ prow(),081   PSAY _asubtot[_j,4] picture "@E 99,999,999.99"
		@ prow(),094   PSAY "|"
		@ prow(),095   PSAY _asubtot[_j,5] picture "@E 99,999,999.99"
		@ prow(),108   PSAY "|"
		@ prow(),109   PSAY _asubtot[_j,6] picture "@E 99,999,999.99"
		@ prow(),122   PSAY "|"
		@ prow(),123   PSAY _asubtot[_j,7] picture "@E 99,999,999.99"
		@ prow(),136   PSAY "|"
		@ prow(),137   PSAY _asubtot[_j,8] picture "@E 99,999,999.99"
		@ prow(),150   PSAY "|"
		@ prow(),151   PSAY _asubtot[_j,9] picture "@E 99,999,999.99"
		@ prow(),164   PSAY "|"
		@ prow(),165   PSAY _asubtot[_j,10] picture "@E 99,999,999.99"
		@ prow(),178   PSAY "|"
		@ prow(),179   PSAY _asubtot[_j,11] picture "@E 99,999,999.99"
		@ prow(),192   PSAY "|"
		@ prow(),193   PSAY _asubtot[_j,12] picture "@E 99,999,999.99"

		@ prow(),206   PSAY "|"
		@ prow(),207   PSAY _subtotper picture "@E 99,999,999.99"
	endif
endif
	
if prow()>58
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
endif


_j:= mv_par04
@ prow()+2,000 PSAY "TOTAL GERAL :"
@ prow(),039   PSAY _atot[_j,1] picture "@E 99,999,999.99"
@ prow(),052   PSAY "|"
@ prow(),053   PSAY _atot[_j,2] picture "@E 99,999,999.99"
@ prow(),066   PSAY "|"
@ prow(),067   PSAY _atot[_j,3] picture "@E 99,999,999.99"
@ prow(),080   PSAY "|"         
@ prow(),081   PSAY _atot[_j,4] picture "@E 99,999,999.99"
@ prow(),094   PSAY "|"
@ prow(),095   PSAY _atot[_j,5] picture "@E 99,999,999.99"
@ prow(),108   PSAY "|"
@ prow(),109   PSAY _atot[_j,6] picture "@E 99,999,999.99"
@ prow(),122   PSAY "|"
@ prow(),123   PSAY _atot[_j,7] picture "@E 99,999,999.99"
@ prow(),136   PSAY "|"
@ prow(),137   PSAY _atot[_j,8] picture "@E 99,999,999.99"
@ prow(),150   PSAY "|"
@ prow(),151   PSAY _atot[_j,9] picture "@E 99,999,999.99"
@ prow(),164   PSAY "|"
@ prow(),165   PSAY _atot[_j,10] picture "@E 99,999,999.99"
@ prow(),178   PSAY "|"
@ prow(),179   PSAY _atot[_j,11] picture "@E 99,999,999.99"
@ prow(),192   PSAY "|"
@ prow(),193   PSAY _atot[_j,12] picture "@E 99,999,999.99"
@ prow(),206   PSAY "|"

_totper:=0
for _k:=1 to 12
	_totper+=_atot[_j,_k]
next

@ prow(),207   PSAY _totper picture "@E 99,999,999.99"


roda(cbcont,cbtxt)


_cindtmp11+=tmp1->(ordbagext())
if nordem>1
	_cindtmp12+=tmp1->(ordbagext())
endif

tmp1->(dbclosearea())

ferase(_carqtmp1+getdbextension())
ferase(_cindtmp11)

if nordem>1
	ferase(_cindtmp12)
	ferase(_cindtmp13)
	ferase(_cindtmp14)
	ferase(_cindtmp15)
	ferase(_cindtmp16)
endif

_cindsf2+=sf2->(ordbagext())

sf2->(retindex("SF2"))
ferase(_cindsf2)

sf2->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return


//*************************************************
//
// FUNÇÃO PARA CÁLCULO DE MOVIMENTAÇÒES PARA
// O PERÍODO DE 12 MESES
//
//*************************************************

static function _calcmov()
for _j:=1 to 12 
	_atot[1,_j]:=0	// Total geral faturamento farma
	_atot[2,_j]:=0	// Total geral faturamento licitação farma
	_atot[3,_j]:=0	// Total geral faturamento licitação hospitalar
	_atot[4,_j]:=0	// Total geral faturamento para os 12 períodos
next

if mv_par05=="2"
	procregua(sf2010->(lastrec()))
	sf2010->(dbseek(_cfilsf2+dtos(_aper[1,1]),.t.))  //Aponta para registro com data superior ou igual à data inicial
	while !sf2010->(eof()) .and.;
		sf2010->f2_filial==_cfilsf2 .and.;
		sf2010->f2_emissao<=mv_par01 .and.;
		sd2010->(dbseek(_cfilsd2+sf2010->f2_doc+sf2010->f2_serie+sf2010->f2_cliente+sf2010->f2_loja))
		                                      
		sf4010->(dbseek(_cfilsf4+sd2010->d2_tes))
		sa3010->(dbsetorder(1))
		sa3010->(dbseek(_cfilsa3+sf2010->f2_vend1))
		
		_mger:=if(empty(_cgerente),.t.,if(_cgerente > "001000",sa3->a3_super==_cgerente,sa3->a3_cod==_cgerente)) // Valida Gerente Regional
		
		if _mger .and.;
			sf2010->f2_vend1>=mv_par02 .and.;
			sf2010->f2_vend1<=mv_par03 .and.;
			sd2010->d2_tipo=="N" .and.;
			sf4010->f4_estoque=="S"
			
			sa1010->(dbseek(_cfilsa1+sf2010->f2_cliente+sf2010->f2_loja))
			sb1010->(dbseek(_cfilsb1+sd2010->d2_cod))
			sc5010->(dbseek(_cfilsc5+sd2010->d2_pedido))
			da0010->(dbseek(_cfilda0+sc5010->c5_tabela))
			
			_mlic := .f.
			if !empty(da0010->da0_status)
				_mlic := .t.
			endif
			
			if !(tmp1->(dbseek(sf2010->f2_cliente+sf2010->f2_loja)))

				tmp1->(dbappend())
				tmp1->cliente :=sf2010->f2_cliente
				tmp1->loja := sf2010->f2_loja
				tmp1->nome:=substr(sa1010->a1_nome,1,35)
				tmp1->uf:=sa1010->a1_est
				tmp1->valicf1  :=0
				tmp1->valich1  :=0
				tmp1->valorff1 :=0
				tmp1->valicf2  :=0
				tmp1->valich2  :=0
				tmp1->valorff2 :=0
				tmp1->valicf3  :=0
				tmp1->valich3  :=0
				tmp1->valorff3 :=0
				tmp1->valicf4  :=0
				tmp1->valich4  :=0
				tmp1->valorff4 :=0
				tmp1->valicf5  :=0
				tmp1->valich5  :=0
				tmp1->valorff5 :=0
				tmp1->valicf6  :=0
				tmp1->valich6  :=0
				tmp1->valorff6 :=0
				tmp1->valicf7  :=0
				tmp1->valich7  :=0
				tmp1->valorff7 :=0
				tmp1->valicf8  :=0
				tmp1->valich8  :=0
				tmp1->valorff8 :=0
				tmp1->valicf9  :=0
				tmp1->valich9  :=0
				tmp1->valorff9 :=0
				tmp1->valicf10 :=0
				tmp1->valich10 :=0
				tmp1->valorff10:=0
				tmp1->valicf11 :=0
				tmp1->valich11 :=0
				tmp1->valorff11:=0
				tmp1->valicf12 :=0
				tmp1->valich12 :=0
				tmp1->valorff12:=0
				tmp1->total    :=0
				tmp1->totff    :=0
				tmp1->totlf    :=0
				tmp1->totlh    :=0
    		endif

			_periodo:=0
			do case 
				case (sf2010->f2_emissao<=_aper[1,2])
					_periodo:=1
				case (sf2010->f2_emissao>=_aper[2,1]) .and. (sf2010->f2_emissao<=_aper[2,2])
					_periodo:=2
				case (sf2010->f2_emissao>=_aper[3,1]) .and. (sf2010->f2_emissao<=_aper[3,2])
					_periodo:=3
				case (sf2010->f2_emissao>=_aper[4,1]) .and. (sf2010->f2_emissao<=_aper[4,2])
					_periodo:=4
				case (sf2010->f2_emissao>=_aper[5,1]) .and. (sf2010->f2_emissao<=_aper[5,2])
					_periodo:=5
				case (sf2010->f2_emissao>=_aper[6,1]) .and. (sf2010->f2_emissao<=_aper[6,2])
					_periodo:=6
				case (sf2010->f2_emissao>=_aper[7,1]) .and. (sf2010->f2_emissao<=_aper[7,2])
					_periodo:=7
				case (sf2010->f2_emissao>=_aper[8,1]) .and. (sf2010->f2_emissao<=_aper[8,2])
					_periodo:=8
				case (sf2010->f2_emissao>=_aper[9,1]) .and. (sf2010->f2_emissao<=_aper[9,2])
					_periodo:=9
				case (sf2010->f2_emissao>=_aper[10,1]) .and. (sf2010->f2_emissao<=_aper[10,2])
					_periodo:=10
				case (sf2010->f2_emissao>=_aper[11,1]) .and. (sf2010->f2_emissao<=_aper[11,2])
					_periodo:=11
				case (sf2010->f2_emissao>=_aper[12,1]) .and. (sf2010->f2_emissao<=_aper[12,2])
					_periodo:=12
			end case

			if	sf4010->f4_duplic=="S" .and. (sb1->b1_tipo =="PA" .or. sb1->b1_tipo='PL')
				if _mlic
					if sb1010->b1_apreven = '1'
	           			do case
    	       				case _periodo==1 
									tmp1->valicf1 +=sf2010->f2_valmerc
           					case _periodo==2
									tmp1->valicf2 +=sf2010->f2_valmerc         				
           					case _periodo==3
									tmp1->valicf3 +=sf2010->f2_valmerc         				
    	       				case _periodo==4
									tmp1->valicf4 +=sf2010->f2_valmerc         				
           					case _periodo==5
									tmp1->valicf5 +=sf2010->f2_valmerc         				
           					case _periodo==6
									tmp1->valicf6 +=sf2010->f2_valmerc         				
    	       				case _periodo==7
									tmp1->valicf7 +=sf2010->f2_valmerc         				
           					case _periodo==8
									tmp1->valicf8 +=sf2010->f2_valmerc         				
          					case _periodo==9
									tmp1->valicf9 +=sf2010->f2_valmerc         				
	           				case _periodo==10
    	       					tmp1->valicf10 +=sf2010->f2_valmerc         				
        	   				case _periodo==11
									tmp1->valicf11 +=sf2010->f2_valmerc         				
           					case _periodo==12
									tmp1->valicf12 +=sf2010->f2_valmerc         				
    	       			end case
						_atot[2,_periodo]+=sf2010->f2_valmerc
					else
	           			do case
    	       				case _periodo==1 
									tmp1->valich1 +=sf2010->f2_valmerc         				
           					case _periodo==2
									tmp1->valich2 +=sf2010->f2_valmerc         				
								case _periodo==3
									tmp1->valich3 +=sf2010->f2_valmerc         				
								case _periodo==4
									tmp1->valich4 +=sf2010->f2_valmerc         				
           					case _periodo==5
									tmp1->valich5 +=sf2010->f2_valmerc         				
	           				case _periodo==6
									tmp1->valich6 +=sf2010->f2_valmerc         				
        	   				case _periodo==7
									tmp1->valich7 +=sf2010->f2_valmerc         				
           					case _periodo==8
									tmp1->valich8 +=sf2010->f2_valmerc         				
    	       				case _periodo==9
									tmp1->valich9 +=sf2010->f2_valmerc         				
            				case _periodo==10
									tmp1->valich10 +=sf2010->f2_valmerc         				
    	       				case _periodo==11
									tmp1->valich11 +=sf2010->f2_valmerc         				
           					case _periodo==12
									tmp1->valich12 +=sf2010->f2_valmerc         				
           				end case
						_atot[3,_periodo]+=sf2010->f2_valmerc
					endif
				else
	           		do case
    	       			case _periodo==1 
								tmp1->valorff1 +=sf2010->f2_valmerc         				
           				case _periodo==2
								tmp1->valorff2 +=sf2010->f2_valmerc         				
           				case _periodo==3
								tmp1->valorff3 +=sf2010->f2_valmerc         				
    	       			case _periodo==4
								tmp1->valorff4 +=sf2010->f2_valmerc         				
           				case _periodo==5
								tmp1->valorff5 +=sf2010->f2_valmerc         				
	           			case _periodo==6
								tmp1->valorff6 +=sf2010->f2_valmerc         				
        	   			case _periodo==7
								tmp1->valorff7 +=sf2010->f2_valmerc         				
           				case _periodo==8
								tmp1->valorff8 +=sf2010->f2_valmerc         				
	           			case _periodo==9
								tmp1->valorff9 +=sf2010->f2_valmerc         				
        	   			case _periodo==10
								tmp1->valorff10 +=sf2010->f2_valmerc         				
           				case _periodo==11
								tmp1->valorff11 +=sf2010->f2_valmerc         				
	           			case _periodo==12
								tmp1->valorff12 +=sf2010->f2_valmerc         				
        	   		end case
					_atot[1,_periodo]+=sf2010->f2_valmerc          		
				endif
				_atot[4,_periodo]+=sf2010->f2_valmerc
			endif
		endif
		sf2010->(dbskip())
	end
endif

procregua(sf2->(lastrec()))
sf2->(dbseek(_cfilsf2+dtos(_aper[1,1]),.t.))

while !sf2->(eof()) .and.;
	sf2->f2_filial==_cfilsf2 .and.;
	sf2->f2_emissao<=mv_par01
    
	sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie+sf2->f2_cliente+sf2->f2_loja))
	sf4->(dbseek(_cfilsf4+sd2->d2_tes))

	sa3->(dbsetorder(1))
	sa3->(dbseek(_cfilsa3+sf2->f2_vend1))
	
	_mger:=if(empty(_cgerente),.t.,if(_cgerente > "001000",sa3->a3_super==_cgerente,sa3->a3_cod==_cgerente)) // Valida Gerente Regional
	
	_ccond2:=.f.
	if !empty(mv_par06)
		if sf2->f2_est==mv_par06
			_ccond2:= .t.
		else
			_ccond2:= .f.
		endif
	else
		_ccond2:= .t.
	endif
	
	if  _mger .and.;
		sf2->f2_vend1>=mv_par02 .and.;
		sf2->f2_vend1<=mv_par03 .and.;
		sd2->d2_tipo=="N" .and.;
		sf4->f4_estoque=="S" .and.;
		_ccond2
		
		sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
		sb1->(dbseek(_cfilsb1+sd2->d2_cod))
		sc5->(dbseek(_cfilsc5+sd2->d2_pedido))

		if mv_par05=="2"
			da0010->(dbseek(_cfilda0+sc5->c5_tabela))
			_mlic := .f.
			if !EMPTY(da0010->da0_status) .and.  da0->da0_status <> "Z"
				_mlic := .t.
			endif
		else
			da0->(dbseek(_cfilda0+sc5->c5_tabela))
			_mlic := .f.
			if !EMPTY(da0->da0_status) .and.  da0->da0_status <> "Z"
				_mlic := .t.
			endif
		endif
		
		if !(tmp1->(dbseek(sf2->f2_cliente+sf2->f2_loja)))
			tmp1->(dbappend())
			tmp1->cliente :=sf2->f2_cliente
			tmp1->loja := sf2->f2_loja
			tmp1->nome:=substr(sa1->a1_nome,1,35)
			tmp1->uf:=sa1->a1_est		
			tmp1->valicf1  :=0
			tmp1->valich1  :=0
			tmp1->valorff1 :=0
			tmp1->valicf2  :=0
			tmp1->valich2  :=0
			tmp1->valorff2 :=0
			tmp1->valicf3  :=0
			tmp1->valich3  :=0
			tmp1->valorff3 :=0
			tmp1->valicf4  :=0
			tmp1->valich4  :=0
			tmp1->valorff4 :=0
			tmp1->valicf5  :=0
			tmp1->valich5  :=0
			tmp1->valorff5 :=0
			tmp1->valicf6  :=0
			tmp1->valich6  :=0
			tmp1->valorff6 :=0
			tmp1->valicf7  :=0
			tmp1->valich7  :=0
			tmp1->valorff7 :=0
			tmp1->valicf8  :=0
			tmp1->valich8  :=0
			tmp1->valorff8 :=0
			tmp1->valicf9  :=0
			tmp1->valich9  :=0
			tmp1->valorff9 :=0
			tmp1->valicf10 :=0
			tmp1->valich10 :=0
			tmp1->valorff10:=0
			tmp1->valicf11 :=0
			tmp1->valich11 :=0
			tmp1->valorff11:=0
			tmp1->valicf12 :=0
			tmp1->valich12 :=0
			tmp1->valorff12:=0
			tmp1->total    :=0
			tmp1->totff    :=0
			tmp1->totlf    :=0
			tmp1->totlh    :=0
		endif

		_periodo:=0
		do case 
			case (sf2->f2_emissao<=_aper[1,2])
				_periodo:=1
			case (sf2->f2_emissao>=_aper[2,1]) .and. (sf2->f2_emissao<=_aper[2,2])
				_periodo:=2
			case (sf2->f2_emissao>=_aper[3,1]) .and. (sf2->f2_emissao<=_aper[3,2])
				_periodo:=3
			case (sf2->f2_emissao>=_aper[4,1]) .and. (sf2->f2_emissao<=_aper[4,2])
				_periodo:=4
			case (sf2->f2_emissao>=_aper[5,1]) .and. (sf2->f2_emissao<=_aper[5,2])
				_periodo:=5
			case (sf2->f2_emissao>=_aper[6,1]) .and. (sf2->f2_emissao<=_aper[6,2])
				_periodo:=6
			case (sf2->f2_emissao>=_aper[7,1]) .and. (sf2->f2_emissao<=_aper[7,2])
				_periodo:=7
			case (sf2->f2_emissao>=_aper[8,1]) .and. (sf2->f2_emissao<=_aper[8,2])
				_periodo:=8
			case (sf2->f2_emissao>=_aper[9,1]) .and. (sf2->f2_emissao<=_aper[9,2])
				_periodo:=9
			case (sf2->f2_emissao>=_aper[10,1]) .and. (sf2->f2_emissao<=_aper[10,2])
				_periodo:=10
			case (sf2->f2_emissao>=_aper[11,1]) .and. (sf2->f2_emissao<=_aper[11,2])
				_periodo:=11
			case (sf2->f2_emissao>=_aper[12,1]) .and. (sf2->f2_emissao<=_aper[12,2])
				_periodo:=12
		end case

		if	sf4->f4_duplic=="S" .and. (sb1->b1_tipo =="PA" .or. sb1->b1_tipo =="PL")
			if _mlic
				if sb1->b1_apreven = '1'
        			do case
        				case _periodo==1 
							tmp1->valicf1 +=sf2->f2_valmerc
        				case _periodo==2
							tmp1->valicf2 +=sf2->f2_valmerc         				
        				case _periodo==3
							tmp1->valicf3 +=sf2->f2_valmerc         				
        				case _periodo==4
							tmp1->valicf4 +=sf2->f2_valmerc         				
        				case _periodo==5
							tmp1->valicf5 +=sf2->f2_valmerc         				
        				case _periodo==6
							tmp1->valicf6 +=sf2->f2_valmerc         				
        				case _periodo==7
							tmp1->valicf7 +=sf2->f2_valmerc         				
        				case _periodo==8
							tmp1->valicf8 +=sf2->f2_valmerc         				
       				case _periodo==9
							tmp1->valicf9 +=sf2->f2_valmerc         				
        				case _periodo==10
        					tmp1->valicf10 +=sf2->f2_valmerc         				
        				case _periodo==11
							tmp1->valicf11 +=sf2->f2_valmerc         				
        				case _periodo==12
							tmp1->valicf12 +=sf2->f2_valmerc         				
        			end case
					_atot[2,_periodo]+=sf2->f2_valmerc
				else
    				do case
           			case _periodo==1 
							tmp1->valich1 +=sf2->f2_valmerc         				
           			case _periodo==2
							tmp1->valich2 +=sf2->f2_valmerc         				
						case _periodo==3
							tmp1->valich3 +=sf2->f2_valmerc         				
						case _periodo==4
							tmp1->valich4 +=sf2->f2_valmerc         				
           			case _periodo==5
							tmp1->valich5 +=sf2->f2_valmerc         				
           			case _periodo==6
							tmp1->valich6 +=sf2->f2_valmerc         				
           			case _periodo==7
							tmp1->valich7 +=sf2->f2_valmerc         				
           			case _periodo==8
							tmp1->valich8 +=sf2->f2_valmerc         				
           			case _periodo==9
							tmp1->valich9 +=sf2->f2_valmerc         				
            		case _periodo==10
							tmp1->valich10 +=sf2->f2_valmerc         				
           			case _periodo==11
							tmp1->valich11 +=sf2->f2_valmerc         				
           			case _periodo==12
							tmp1->valich12 +=sf2->f2_valmerc         				
       			end case
				   _atot[3,_periodo]+=sf2->f2_valmerc
				   
				   if (sf2->f2_doc=="035538")
				   	_periodo:=_periodo
				   endif
				endif
			else
        		do case
        			case _periodo==1 
						tmp1->valorff1 +=sf2->f2_valmerc         				
        			case _periodo==2
						tmp1->valorff2 +=sf2->f2_valmerc         				
        			case _periodo==3
						tmp1->valorff3 +=sf2->f2_valmerc         				
        			case _periodo==4
						tmp1->valorff4 +=sf2->f2_valmerc         				
        			case _periodo==5
						tmp1->valorff5 +=sf2->f2_valmerc         				
        			case _periodo==6
						tmp1->valorff6 +=sf2->f2_valmerc         				
        			case _periodo==7
						tmp1->valorff7 +=sf2->f2_valmerc         				
        			case _periodo==8
						tmp1->valorff8 +=sf2->f2_valmerc         				
        			case _periodo==9
						tmp1->valorff9 +=sf2->f2_valmerc         				
        			case _periodo==10
						tmp1->valorff10 +=sf2->f2_valmerc         				
        			case _periodo==11
						tmp1->valorff11 +=sf2->f2_valmerc         				
        			case _periodo==12
						tmp1->valorff12 +=sf2->f2_valmerc         				
        		end case
				_atot[1,_periodo]+=sf2->f2_valmerc          		
			endif
			_atot[4,_periodo]+=sf2->f2_valmerc
		endif
	endif
	sf2->(dbskip())
end

return


static function _abretop(_carq,_nordem)
_calias:=left(_carq,3)
dbusearea(.t.,"TOPCONN",_carq,_carq,.t.,.f.)
six->(dbseek(_calias))
while ! six->(eof()) .and.;
	six->indice==_calias
	dbsetindex(_carq+six->ordem)
	six->(dbskip())
end
dbsetorder(_nordem)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Data de Referencia ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Do vendedor        ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{_cperg,"03","Ate o vendedor     ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{_cperg,"04","Totaliza Valor     ?","mv_ch4","N",01,0,0,"C",space(60),"mv_par04"       ,"Farma"          ,space(30),space(15),"Lic. Farma"     ,space(30),space(15),"Lic. Hosp."     ,space(30),space(15),"Total"          ,space(30),space(15),space(15)        ,space(30),"   "})                                        
aadd(_agrpsx1,{_cperg,"05","Grade              ?","mv_ch5","C",01,0,0,"G",space(60),"mv_par05"       ,"1"              ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"06","Do estado          ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"12 "})


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
Codigo    Nome                 UF|  PERIODO 01 |  PERIODO 02 |  PERIODO 03 |  PERIODO 04 |  PERIODO 05 |  PERIODO 06 |  PERIODO 07 |  PERIODO 08 |  PERIODO 09 |  PERIODO 10 |  PERIODO 11 |  PERIODO 12 |TOTAL PERIODO"
                                 |01/01   30/01|01/02   28/02|01/03   31/03|01/04   30/04|01/05   31/05|01/06   30/06|01/07   31/07|01/08   31/08|01/09   30/09|01/10   31/10|01/11   30/11|01/12   31/12|"
999999-99 XXXXXXXXXXXXXXXXXXXX XX|99.999.999,99|99.999.999,99|99.999.999,99|99.999.999,99|99.999.999,99|99.999.999,99|99.999.999,99|99.999.999,99|99.999.999,99|99.999.999,99|99.999.999,99|99.999.999,99|99.999.999,99"

*/

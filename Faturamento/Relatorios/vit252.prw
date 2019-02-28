/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT252   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 27/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Vendas por Vendedor (Ranking)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT252()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="FATURAMENTO POR VENDEDOR (RANKING) - REAIS"
cdesc1  :="Este programa ira emitir a relacao de Vendas por Vendedor"
cdesc2  :=""
cdesc3  :=""
cstring :="SF2"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT252"
wnrel   :="VIT252"+Alltrim(cusername)
alinha  :={}
aordem  :={"Alfabetica","Ranking"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGVIT252"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

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

cabec1:="PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)
cabec2:="Ordem Codigo Representante                         UF        Farma    Lic.Farma    Lic.Hosp.         Total   Bonificacao   Bon.(%)  %Total   %Acum."

_cfilsb1:=xfilial("SB1")  // Cadastro de Produtos
_cfilsa1:=xfilial("SA1")  // Cadastro de Clientes
_cfilsd2:=xfilial("SD2")  // Itens NF Saída
_cfilsa3:=xfilial("SA3")  // Cadastro de Vendedores
_cfilsf2:=xfilial("SF2")  // Cabeçalho NF Saída
_cfilsf4:=xfilial("SF4")  // Cadastro de TES
_cfilsc5:=xfilial("SC5")  // Pedidos de Venda
_cfilda0:=xfilial("DA0")  // Lista de Preços

sb1->(dbsetorder(1))
sa1->(dbsetorder(1))
sd2->(dbsetorder(3))
sa3->(dbsetorder(1))
sf2->(dbsetorder(1))
sf4->(dbsetorder(1))
sc5->(dbsetorder(1))
da0->(dbsetorder(1))
if mv_par05=="2"
	_abretop("SB1010",1)
	_abretop("SA1010",1)
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

// PESQUISA CODIGO DO SUPERVISOR
sa3->(dbsetorder(7))
if sa3->(dbseek(_cfilsa3+__cuserid))
	_cgerente:=sa3->a3_cod
else
	_cgerente:=space(6)
endif

sa3->(dbsetorder(1))

_aestrut:={}
aadd(_aestrut,{"VENDEDOR" ,"C",6,0})
aadd(_aestrut,{"NOME"     ,"C",30,0})
aadd(_aestrut,{"UF"       ,"C",2,0})
aadd(_aestrut,{"VALORFF"  ,"N",11,2})
aadd(_aestrut,{"VALICH"   ,"N",11,2})
aadd(_aestrut,{"VALICF"   ,"N",11,2})
aadd(_aestrut,{"TOTAL"    ,"N",11,2})
aadd(_aestrut,{"BONIFIC"  ,"N",11,2})
aadd(_aestrut,{"GERENTE"  ,"N",6,0})

_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
_cindtmp11:=criatrab(,.f.)
_cchave   :="vendedor+nome"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))

_cindtmp12:=criatrab(,.f.)
_cchave   :="nome+strzero(valorff+valich+valicf,11,2)"
tmp1->(indregua("TMP1",_cindtmp12,_cchave))

_cindtmp13:=criatrab(,.f.)
_cchave   :="strzero(valorff+valich+valicf,11,2)+nome"
tmp1->(indregua("TMP1",_cindtmp13,_cchave))

tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetindex(_cindtmp12))
tmp1->(dbsetindex(_cindtmp13))
tmp1->(dbsetorder(1))


// ATRIBUIÇÃO DE VARIÁVEIS
_nvalortot := 0           	// Valor Total de Faturamento, exceto bonificações
_i         := 1				// Contador para descriminação da ordem
_nperc     := 0				// Percentual do Total faturado por vendedor sobre Total Geral
_npacum 	  := 0				// Percentual sobre Total acumulativo vendedor a vendedor


/*
// UTILIZADO PARA IMPRESSÃO DE SUB-TOTAIS EM DIVISÃO DE CLASSES A/B/C
// RETIRADO EM 21/07/06 POR SOLICITAÇÃO DA DTC - Alex Júnio

_nsgff 	  := 0				// Sub-Total do Faturamento Venda Farma por vendedor
_nsgfh 	  := 0				// Sub-Total do Faturamento Venda Licitação Farma por vendedor
_nsgch 	  := 0				// Sub-Total do Faturamento Venda Licitação Hospitalar por vendedor
_nsbon 	  := 0				// Sub-Total do Faturamento em Bonificação por vendedor
*/

_ntgff     := 0				// Total Geral do Faturamento Venda Farma por vendedor
_ntgfh     := 0				// Total Geral do Faturamento Venda Licitação Farma por vendedor
_ntgch     := 0				// Total Geral do Faturamento Venda Licitação Hospitalar por vendedor
_ntbon     := 0				// Total Geral do Faturamento em Bonificação por vendedor

_nc        := .t.				// Identificador para flag de impressão de sub-totais

// CÁLCULO DE MOVIMENTAÇÕES NO PERÍODO
processa({|| _calcmov()})

setregua(tmp1->(lastrec()))

setprc(0,0)

if nordem==1
	titulo :="FATURAMENTO POR VENDEDOR (ORDEM ALFABETICA) - REAIS"
	tmp1->(dbsetorder(2))
	tmp1->(dbgotop())
	_ccond:="! tmp1->(eof())"
else
	titulo :="FATURAMENTO POR VENDEDOR (RANKING) - REAIS"		
	tmp1->(dbsetorder(3))
	tmp1->(dbgobottom())
	_ccond:="! tmp1->(bof())"
endif


while &_ccond .and.;
	lcontinua
	incregua()
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	_nperc :=round(((tmp1->valorff+tmp1->valicf+tmp1->valich)/_nvalortot)*100,2)
	_npacum+=_nperc

/*
// UTILIZADO PARA IMPRESSÃO DE SUB-TOTAIS EM DIVISÃO DE CLASSES A/B/C
// RETIRADO EM 21/07/06 POR SOLICITAÇÃO DA DTC - Alex Júnio

	if (_npacum <= 50.99) .and. (_i = 1) .and. (nordem>1)
		@ prow()+1,000 PSAY "VENDEDORES A "
	elseif (_npacum > 51 .and. _npacum <= 80) .and. _nc .and. (nordem>1)
		_nc = .f.
		if !empty(_nsgff+_nsgfh+_nsgch)
			if prow()>58
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY "SUB-TOTAL A:"
			@ prow(),054   PSAY _nsgff picture "@E 9,999,999.99"
			@ prow(),067   PSAY _nsgfh picture "@E 9,999,999.99"
			@ prow(),080   PSAY _nsgch picture "@E 9,999,999.99"
			@ prow(),093   PSAY _nsgff+_nsgfh+_nsgch picture "@E 99,999,999.99"
			@ prow(),107   PSAY _nsbon picture "@E 99,999,999.99"
			@ prow(),122   PSAY round((_nsbon/(_nsgff+_nsgfh+_nsgch))*100,2) picture "@E 999.99"
			_nsgff :=0
			_nsgfh :=0
			_nsgch :=0
			_nsbon :=0
		endif
		@ prow()+1,000 PSAY " "
		@ prow()+1,000 PSAY "VENDEDORES B "
	elseif (_npacum > 80) .and. (nordem>1)
		if !_nc
			if !empty(_nsgff+_nsgfh+_nsgch)
				if prow()>58
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
				endif
				@ prow()+1,000 PSAY "SUB-TOTAL B:"
				@ prow(),054   PSAY _nsgff picture "@E 9,999,999.99"
				@ prow(),067   PSAY _nsgfh picture "@E 9,999,999.99"
				@ prow(),080   PSAY _nsgch picture "@E 9,999,999.99"
				@ prow(),093   PSAY _nsgff+_nsgfh+_nsgch picture "@E 99,999,999.99"
				@ prow(),107   PSAY _nsbon picture "@E 99,999,999.99"
				@ prow(),122   PSAY round((_nsbon/(_nsgff+_nsgfh+_nsgch))*100,2) picture "@E 999.99"
				_nsgff :=0
				_nsgfh :=0
				_nsgch :=0
				_nsbon :=0
			endif
			@ prow()+1,000 PSAY " "
			@ prow()+1,000 PSAY "VENDEDORES C "
		endif
		_nc = .t.
	endif
*/

	@ prow()+1,000 PSAY _i  picture "999"
	@ prow(),004   PSAY tmp1->vendedor
	@ prow(),014   PSAY substr(tmp1->nome,1,35)
	@ prow(),051   PSAY tmp1->uf
	@ prow(),054   PSAY tmp1->valorff picture "@E 9,999,999.99"
	@ prow(),067   PSAY tmp1->valicf picture "@E 9,999,999.99"
	@ prow(),080   PSAY tmp1->valich picture "@E 9,999,999.99"
	@ prow(),093   PSAY tmp1->valorff+tmp1->valicf+tmp1->valich picture "@E 99,999,999.99"
	@ prow(),107   PSAY tmp1->bonific picture "@E 99,999,999.99"
	@ prow(),122   PSAY round(tmp1->bonific/(tmp1->valorff+tmp1->valicf+tmp1->valich)*100,2) picture "@E 999.99"
	@ prow(),132   PSAY _nperc picture "@E 999.99"
	@ prow(),141   PSAY _npacum picture "@E 999.99"
	_ntgff  +=tmp1->valorff
	_ntgfh  +=tmp1->valicf
	_ntgch  +=tmp1->valich
	_ntbon += tmp1->bonific

/*
// UTILIZADO PARA IMPRESSÃO DE SUB-TOTAIS EM DIVISÃO DE CLASSES A/B/C
// RETIRADO EM 21/07/06 POR SOLICITAÇÃO DA DTC - Alex Júnio

	_nsgff  +=tmp1->valorff
	_nsgfh  +=tmp1->valicf
	_nsgch  +=tmp1->valich
	_nsbon += tmp1->bonific
*/	
	_i++
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


/*
// UTILIZADO PARA IMPRESSÃO DE SUB-TOTAIS EM DIVISÃO DE CLASSES A/B/C
// RETIRADO EM 21/07/06 POR SOLICITAÇÃO DA DTC - Alex Júnio

if prow()>0 .and.;
	lcontinua .and.;
	(nordem>1)
	if prow()>58
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY "SUB-TOTAL C:"
	@ prow(),054   PSAY _nsgff picture "@E 9,999,999.99"
	@ prow(),067   PSAY _nsgfh picture "@E 9,999,999.99"
	@ prow(),080   PSAY _nsgch picture "@E 9,999,999.99"
	@ prow(),093   PSAY _nsgff+_nsgfh+_nsgch picture "@E 99,999,999.99"
	@ prow(),107   PSAY _nsbon picture "@E 99,999,999.99"
	@ prow(),122   PSAY round((_nsbon/(_nsgff+_nsgfh+_nsgch))*100,2) picture "@E 999.99"
	_nsgff :=0
	_nsgfh :=0
	_nsgch :=0
	_nsprz :=0
	_nsbon :=0
endif
*/
	
if prow()>58
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
endif
@ prow()+1,000 PSAY "TOTAL GERAL:"
@ prow(),053   PSAY _ntgff picture "@E 99,999,999.99"
@ prow(),067   PSAY _ntgfh picture "@E 9,999,999.99"
@ prow(),080   PSAY _ntgch picture "@E 9,999,999.99"
@ prow(),091   PSAY _ntgff+_ntgfh+_ntgch picture "@E 999,999,999.99"
@ prow(),106   PSAY _ntbon picture "@E 99,999,999.99"
@ prow(),121   PSAY round((_ntbon/(_ntgff+_ntgfh+_ntgch))*100,2) picture "@E 999.99"

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


static function _calcmov()
if (mv_par06=="2")
	procregua(sf2010->(lastrec()))
	sf2010->(dbseek(_cfilsf2+dtos(mv_par01),.t.))
	while !sf2010->(eof()) .and.;
		sf2010->f2_filial==_cfilsf2 .and.;
		sf2010->f2_emissao<=mv_par02 .and.;
		sd2010->(dbseek(_cfilsd2+sf2010->f2_doc+sf2010->f2_serie+sf2010->f2_cliente+sf2010->f2_loja))
		
		if ! Empty(sf2010->f2_vend1)
			
			sf4010->(dbseek(_cfilsf4+sd2010->d2_tes))
			sa3->(dbsetorder(1))
			sa3->(dbseek(_cfilsa3+sf2010->f2_vend1))
			
			_mger:=if(empty(_cgerente),.t.,sa3->a3_super==_cgerente) // Valida Gerente Regional
			
			if _mger .and.; 		
		   	sa3->a3_cod>=mv_par03 .and.;
				sa3->a3_cod<=mv_par04 .and.;
			   sd2010->d2_tipo=="N" .and.;
				sf4010->f4_estoque=="S"
				
				sb1010->(dbseek(_cfilsb1+sd2010->d2_cod))
				sc5010->(dbseek(_cfilsc5+sd2010->d2_pedido))
				da0010->(dbseek(_cfilda0+sc5010->c5_tabela))
			
				_mlic := .f.
				if !empty(da0010->da0_status) 
					_mlic := .t.
				endif

				_ndesc := 0
				_nregsd2:=sd2010->(recno())
				while !sd2010->(eof()) .and.;
					sd2010->d2_filial==_cfilsd2 .and.;
					sd2010->d2_doc=sf2010->f2_doc .and.;
					sd2010->d2_serie=sf2010->f2_serie
					if sc5010->c5_licitac <> "S"
						_ndesc +=sd2010->d2_prunit * sd2010->d2_quant
					endif
					sd2010->(dbskip())
				end
				sd2010->(dbgoto(_nregsd2))
				if tmp1->(dbseek(sa3->a3_cod))
					if	sf4010->f4_duplic=="S" .and. (sb1->b1_tipo =="PA" .or. sb1->b1_tipo='PL')
						if _mlic
							if sb1010->b1_apreven = '1'
								tmp1->valicf +=sf2010->f2_valmerc
							else
								tmp1->valich +=sf2010->f2_valmerc
							endif
						else
							tmp1->valorff +=sf2010->f2_valmerc
						endif
						tmp1->total += _ndesc
						_nvalortot += sf2010->f2_valmerc
					else
						if (sd2010->d2_tes = '526' .OR. sd2010->d2_tes = '527') .and. (sb1010->b1_tipo='PA' .or. sb1->b1_tipo='PL')
							tmp1->bonific +=sf2010->f2_valmerc
						endif
					endif
				else
					tmp1->(dbappend())
					tmp1->vendedor :=sf2010->f2_vend1
					tmp1->nome:=substr(sa3->a3_nome,1,35)
					tmp1->uf:=sa3->a3_est
					if	sf4010->f4_duplic=="S" .and. (sb1->b1_tipo =="PA"  .or. sb1->b1_tipo='PL')
						if _mlic
							if sb1010->b1_apreven = '1'
								tmp1->valicf :=sf2010->f2_valmerc
							else
								tmp1->valich :=sf2010->f2_valmerc
							endif
						else
							tmp1->valorff :=sf2010->f2_valmerc
						endif
						_nvalortot += sf2010->f2_valmerc
						tmp1->total := _ndesc
					else
						if (sd2010->d2_tes = '526' .OR. sd2010->d2_tes = '527') .and.( sb1010->b1_tipo='PA' .or. sb1->b1_tipo='PL')
							tmp1->bonific +=sf2010->f2_valmerc
						endif
					endif
				endif
			endif
			sf2010->(dbskip())
		endif
	end
endif

procregua(sf2->(lastrec()))
sf2->(dbseek(_cfilsf2+dtos(mv_par01),.t.))

while !sf2->(eof()) .and.;
	sf2->f2_filial==_cfilsf2 .and.;
	sf2->f2_emissao<=mv_par02
	
	if ! Empty(sf2->f2_vend1)
		
		sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie+sf2->f2_cliente+sf2->f2_loja))
		sf4->(dbseek(_cfilsf4+sd2->d2_tes))
		sa3->(dbsetorder(1))
		sa3->(dbseek(_cfilsa3+sf2->f2_vend1))
		
		_mger:=if(empty(_cgerente),.t.,sa3->a3_super==_cgerente) // Valida Gerente Regional
			
		if _mger .and.; 		
	   	sa3->a3_cod>=mv_par03 .and.;
			sa3->a3_cod<=mv_par04 .and.;
			sd2->d2_tipo=="N" .and.;
			sf4->f4_estoque=="S"
			
			sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
			sb1->(dbseek(_cfilsb1+sd2->d2_cod))
			sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
			if mv_par06=="2"
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
			
			_ndesc := 0
			_nregsd2:=sd2->(recno())
			while !sd2->(eof()) .and.;
				sd2->d2_filial==_cfilsd2 .and.;
				sd2->d2_doc=sf2->f2_doc .and.;
				sd2->d2_serie=sf2->f2_serie
				
				if sc5->c5_licitac <> "S"
					_ndesc +=sd2->d2_prunit * sd2->d2_quant
				endif
				sd2->(dbskip())
			end
			sd2->(dbgoto(_nregsd2))
			
			if tmp1->(dbseek(sa3->a3_cod))
				if	sf4->f4_duplic=="S" .and. (sb1->b1_tipo =="PA" .or. sb1->b1_tipo =="PL")
					if _mlic
						if sb1->b1_apreven = '1'
							tmp1->valicf +=sf2->f2_valmerc
						else
							tmp1->valich +=sf2->f2_valmerc
						endif
					else
						tmp1->valorff +=sf2->f2_valmerc
					endif
					tmp1->total += _ndesc
					_nvalortot += sf2->f2_valmerc
				else
					if (sd2->d2_tes = '526' .OR. sd2->d2_tes = '527') .and. (sb1->b1_tipo='PA' .or. sb1->b1_tipo='PL')
						tmp1->bonific +=sf2->f2_valmerc
					endif
				endif
			else
				tmp1->(dbappend())
				tmp1->vendedor :=sa3->a3_cod
				tmp1->nome:=substr(sa3->a3_nome,1,35)
				tmp1->uf:=sa3->a3_est
				
				if	sf4->f4_duplic=="S" .and. (sb1->b1_tipo =="PA" .or. sb1->b1_tipo =="PL")
					if _mlic
						if sb1->b1_apreven = '1'
							tmp1->valicf :=sf2->f2_valmerc
						else
							tmp1->valich :=sf2->f2_valmerc
						endif
					else
						tmp1->valorff :=sf2->f2_valmerc
					endif
					_nvalortot += sf2->f2_valmerc
					tmp1->total := _ndesc
				else
					if (sd2->d2_tes = '526' .OR. sd2->d2_tes = '527') .and. sb1->b1_tipo='PA'
						tmp1->bonific +=sf2->f2_valmerc
					endif
				endif
			endif
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
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do vendedor        ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"04","Ate o vendedor     ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"05","Grade              ?","mv_ch5","C",01,0,0,"G",space(60),"mv_par05"       ,"1"              ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
Ordem Codigo Descricao                                 Quantidade  Valor vendido Preco Medio   %    % acum
99999 999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999.999.999 999.999.999,99  999.999,99 999,99 999,99
Ordem UF          Farma %Farma      Lic.Farma   % L.F Lic.Economica  %L.E             Total    Bonificacao  %Bonif.  Atrz. Prz.Medio"
99999 99 999.999.999,99 999.99 999.999.999,99  999,99 999.999.999,99 999.99  999.999.999,99 999.999.999,99   999,99

*/

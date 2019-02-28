/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT039   ³ Autor ³ Gardenia Ilany        ³ Data ³ 05/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acompanhamento de Campanha                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alterações³ 22/03/2006 - Inclusão da opção Sintética para o Relatório  ³±±
±±³          ³ com Omissão das Informações das NF (Detalhe)               ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function VIT039()
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="ACOMPANHAMENTO DE CAMPANHA  "
cdesc1  :="Este programa ira emitir o relatorio de acompanhamento de campanha"
cdesc2  :=""
cdesc3  :=""
cstring :="SZ3"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT039"
wnrel   :="VIT039"+Alltrim(cusername)
alinha  :={}
aordem  :={"Nota"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGVIT039"
_pergsx1()
pergunte(cperg,.f.)




wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if mv_par08<>"1"
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


if nlastkey==27
	set filter to
	if mv_par08<>"1"
		tcquit()
	endif
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

if nlastkey==27
	set filter to
	if mv_par08<>"1"
		tcquit()
	endif
	return
endif

rptstatus({|| rptdetail()})
if mv_par08<>"1"
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

cabec1:="PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)+if(mv_par09=1,"  Separa Promocao"," Nao Separa Promocao")
if mv_par10==1
	cabec2      :="Nota Fiscal  Emissao    Valor da Fatura         Promocoes           Indice           A Pagar"
else
	cabec2      :="RELATORIO SINTETICO:     Valor da Fatura         Promocoes           Indice           A Pagar"
endif

_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsd2:=xfilial("SD2")
_cfilsz3:=xfilial("SZ3")
_cfilsf4:=xfilial("SF4")
_cfilda0:=xfilial("DA0")
sa1->(dbsetorder(1))
sa3->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(2))
sz3->(dbsetorder(1))
sf4->(dbsetorder(1))
sd2->(dbsetorder(5))
da0->(dbsetorder(1))

_aestrut:={}
aadd(_aestrut,{"CLIENTE"  ,"C",6,0})
aadd(_aestrut,{"LOJA"  ,"C",2,0})
aadd(_aestrut,{"NOTA"  ,"C",9,0})
aadd(_aestrut,{"SERIE"  ,"C",2,0})
aadd(_aestrut,{"PEDIDO"  ,"C",6,0})
aadd(_aestrut,{"PROMOC"  ,"C",1,0})
aadd(_aestrut,{"EMISSAO","D",8,0})
aadd(_aestrut,{"TOTAL"    ,"N",12,2})
aadd(_aestrut,{"DESC"    ,"N",12,2})
aadd(_aestrut,{"AVISTA"    ,"N",12,2})
aadd(_aestrut,{"TPFRETE"   ,"N",12,2})


_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
_cindtmp11:=criatrab(,.f.)
_cchave   :="cliente+loja+nota+serie"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))

tmp1->(dbclearind())
tmp1->(dbsetindex(_cindtmp11))
tmp1->(dbsetorder(1))

if mv_par08<> "1"
	_abretop("SZ3010",1)
	_abretop("SA3010",1)
	sz3010->(dbsetorder(1))
endif



_ntotvalor:=0
_ntotquant:=0

// PESQUISA CODIGO DO SUPERVISOR
sa3->(dbsetorder(7))
if sa3->(dbseek(_cfilsa3+__cuserid))
	_cgerente:=sa3->a3_cod
else
	_cgerente:=space(6)
endif

processa({|| _calcmov()})

setregua(tmp1->(lastrec()))

setprc(0,0)

tmp1->(dbsetorder(1))
tmp1->(dbgotop())

_i     :=1
_npacum:=0
if mv_par08<>"1"
	sa3010->(dbseek(_cfilsa3+mv_par07))
else
	sa3->(dbseek(_cfilsa3+mv_par07))
endif
_pagar:=0
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	if prow()==0 .or. prow()>55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
		if mv_par08<> "1"
			@ prow()+1,000 PSAY "Vendedor: "+mv_par07 +' - ' + sa3010->a3_nome
		else
			@ prow()+1,000 PSAY "Vendedor: "+mv_par07 +' - ' + sa3->a3_nome
		endif
	endif
	_cliente := tmp1->cliente
	_loja :=tmp1->loja
	_emissao :=tmp1->emissao
	set softseek on
	if mv_par08<> "1"
		sz3010->(dbseek(_cfilsz3+mv_par07+_cliente+_loja))
	else
		sz3->(dbseek(_cfilsz3+mv_par07+_cliente+_loja))
	endif
	set softseek off
	if mv_par08<> "1"
		if ( sz3010->z3_tipo =="I") .or. (sz3010->z3_incial > _emissao .or. sz3010->z3_final < _emissao)
			tmp1->(dbskip())
			loop
		endif
		if sz3010->z3_vend <> mv_par07  .or.( sz3010->z3_cliente <> _cliente .or. sz3010->z3_loja <> _loja)
			tmp1->(dbskip())
			loop
		endif
	else
		if ( sz3->z3_tipo =="I") .or. (sz3->z3_incial > _emissao .or. sz3->z3_final < _emissao)
			tmp1->(dbskip())
			loop
		endif
		if sz3->z3_vend <> mv_par07  .or.( sz3->z3_cliente <> _cliente .or. sz3->z3_loja <> _loja)
			tmp1->(dbskip())
			loop
		endif
	endif
	_emissao :=tmp1->emissao
	limpcamp:=.t.
	_ntotal1 :=0
	_promocao1 :=0
	while ! tmp1->(eof()) .and. _cliente == tmp1->cliente  .and. _loja == tmp1->loja
		_nota :=tmp1->nota
		_serie:=tmp1->serie
		_emissao:=tmp1->emissao
		if mv_par08<> "1"
			if ( sz3010->z3_tipo =="I") .or. (sz3010->z3_incial > _emissao .or. sz3010->z3_final < _emissao)
				tmp1->(dbskip())
				loop
			endif
		else
			if ( sz3->z3_tipo =="I") .or. (sz3->z3_incial > _emissao .or. sz3->z3_final < _emissao)
				tmp1->(dbskip())
				loop
			endif
		endif
		_ntotal :=0
		_promocao :=0
		while ! tmp1->(eof()) .and. _cliente == tmp1->cliente .and. _nota == tmp1->nota;
			.and. _serie == tmp1->serie .and.  _loja == tmp1->loja
			if prow()==1.or.prow()>55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
			endif
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				eject
				lcontinua:=.f.
			endif
			if mv_par08<> "1"
				if ( sz3010->z3_tipo =="I") .or. (sz3010->z3_incial > _emissao .or. sz3010->z3_final < _emissao)
					tmp1->(dbskip())
					loop
				endif
			else
				if ( sz3->z3_tipo =="I") .or. (sz3->z3_incial > _emissao .or. sz3->z3_final < _emissao)
					tmp1->(dbskip())
					loop
				endif
			endif
			if limpcamp
				//				@ prow()+1,000 PSAY replicate("-",limite)
				sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
				if mv_par08<> "1"
					@ prow()+1,000 PSAY ""
					@ prow()+1,000 PSAY "Cliente: "+tmp1->cliente+"/"+tmp1->loja+"-"+sa1->a1_nome
					@ prow()+1,000 PSAY "Inicio: "+dtoc(sz3010->z3_incial)
					@ prow(),025   PSAY "Fim: "+dtoc(sz3010->z3_final)
					@ prow(),040   PSAY "Valor: "+transform(sz3010->z3_valor,"@E 999,999,999,999.99")
					@ prow(),067   PSAY "Desconto: "+transform(sz3010->z3_descont,"@E 99.99")+"%"
					@ prow(),092   PSAY "Prazo Medio: "+transform(sz3010->z3_cond,"999")
					@ prow(),114 	PSAY "% Premiacao: "+transform(sz3010->z3_brinde,"@E 99.99")+"%"
				else
					@ prow()+1,000 PSAY ""
					@ prow()+1,000 PSAY "Cliente: "+tmp1->cliente+"/"+tmp1->loja+"-"+sa1->a1_nome
					@ prow()+1,000 PSAY "Inicio: "+dtoc(sz3->z3_incial)
					@ prow(),025   PSAY "Fim: "+dtoc(sz3->z3_final)
					@ prow(),040   PSAY "Valor: "+transform(sz3->z3_valor,"@E 999,999,999,999.99")
					@ prow(),067   PSAY "Desconto: "+transform(sz3->z3_descont,"@E 99.99")+"%"
					@ prow(),092   PSAY "Prazo Medio: "+transform(sz3->z3_cond,"999")
					@ prow(),114 	PSAY "% Premiacao: "+transform(sz3->z3_brinde,"@E 99.99")+"%"
				endif
				limpcamp:=.f.
			endif
			//			sc6->(dbseek(cfilsc6+sd2->d2_cod+sd2->d2_pedido))
			if mv_par08<> "1"
				if (tmp1->promoc=='M' .and. mv_par09<>1);
					.or. (mv_par09==1 .and.(tmp1->promoc $'PMF')).and. (tmp1->desc > sz3->z3_descont+tmp1->avista+tmp1->tpfrete)
					_promocao += tmp1->total
					_promocao1 += tmp1->total
				endif
			else
				//				if tmp1->promoc =='P' .or. tmp1->promoc=='M' .or. tmp1->promoc=='F' .or.  (tmp1->desc > sz3->z3_descont+tmp1->avista+tmp1->tpfrete)
				// se nao separa promocao e promoc==M ou (se separa e promoc $ PFM) e frete por conta do cliente
				if (tmp1->promoc=='M' .and. mv_par09<>1);
					.or. (mv_par09==1 .and.(tmp1->promoc $'PMF')).and. (tmp1->desc > sz3->z3_descont+tmp1->avista+tmp1->tpfrete)
					_promocao1 += tmp1->total
					_promocao += tmp1->total
				endif
			endif
			_ntotal+=tmp1->total
			_ntotal1+=tmp1->total
			tmp1->(dbskip())
		end
		if mv_par10==1
			@ prow()+1,000 PSAY _nota +"-"+_serie
			@ prow(),015   PSAY _emissao
			@ prow(),026   PSAY _ntotal picture "@E 999,999,999.99"
			@ prow(),044   PSAY _promocao picture "@E 999,999,999.99"
			@ prow(),061   PSAY _ntotal-_promocao picture "@E 999,999,999.99"
			if mv_par08<> "1"
				@ prow(),079   PSAY (_ntotal-_promocao)*(sz3010->z3_brinde/100) picture "@E 999,999,999.99"
			else
				@ prow(),079   PSAY (_ntotal-_promocao)*(sz3->z3_brinde/100) picture "@E 999,999,999.99"
			endif
		endif
	end
	@ prow()+1,000   PSAY 'TOTAIS ==>'
	@ prow(),026   PSAY _ntotal1 picture "@E 999,999,999.99"
	@ prow(),044   PSAY _promocao1 picture "@E 999,999,999.99"
	@ prow(),061   PSAY _ntotal1-_promocao1 picture "@E 999,999,999.99"
	if mv_par08<> "1"
		@ prow(),079   PSAY (_ntotal1-_promocao1)*(sz3010->z3_brinde/100) picture "@E 999,999,999.99"
		_pagar+=(_ntotal1-_promocao1)*(sz3010->z3_brinde/100)
	else
		@ prow(),079   PSAY (_ntotal1-_promocao1)*(sz3->z3_brinde/100) picture "@E 999,999,999.99"
		_pagar+=(_ntotal1-_promocao1)*(sz3->z3_brinde/100)
	endif
end
@ prow()+1,000 PSAY "TOTAL A PAGAR REPRESENTANTE"
@ prow(),079   PSAY _pagar picture "@E 999,999,999.99"
roda(cbcont,cbtxt)
_cindtmp11+=tmp1->(ordbagext())
tmp1->(dbclosearea())
if mv_par08<> "1"
	ferase(_carqtmp1+getdbextension())
	ferase(_cindtmp11)
endif
set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return




static function _calcmov()
if mv_par08<> "1"
	_abretop("SF4010",1)
	_abretop("SC6010",2)
	_abretop("SC5010",1)
	_abretop("SB1010",1)
//	_abretop("SA3010",1)
	_abretop("DA0010",1)
endif

procregua(sd2->(lastrec()))
if mv_par08=="2" .or. mv_par08 =="3"
	sd2->(dbseek(_cfilsd2+dtos(mv_par01),.t.))
	while ! sd2->(eof()) .and.;
		sd2->d2_filial==_cfilsd2 .and.;
		sd2->d2_emissao<=mv_par02
		incproc("Processando notas fiscais de saida: "+dtoc(sd2->d2_emissao))
		sc6010->(dbseek(_cfilsc6+sd2->d2_cod+sd2->d2_pedido))
		sc5010->(dbseek(_cfilsc5+sd2->d2_pedido))
		_vendedor :=sc5->c5_vend1
		// Valida Gerente Regional
		sa3->(dbsetorder(1))
		sa3->(dbseek(_cfilsa3+_vendedor))
		_mger:=if(empty(_cgerente),.t.,if(_cgerente > "001000",sa3->a3_super==_cgerente,sa3->a3_cod==_cgerente)) // Valida Gerente Regional
		if sc5010->c5_vend1 <> mv_par07
			sd2->(dbskip())
			loop
		endif
		if sd2->d2_cliente <  mv_par03 .or. sd2->d2_cliente > mv_par05
			sd2->(dbskip())
			loop
		endif
		
		sf4010->(dbseek(_cfilsf4+sd2->d2_tes))
		if _mger .and.;
		   sf4010->f4_estoque=="S" .and.;
			sf4010->f4_duplic=="S" .and. sc5010->c5_vend1==mv_par07 
			tmp1->(dbappend())
			tmp1->cliente := sd2->d2_cliente
			tmp1->loja :=sd2->d2_loja
			tmp1->emissao :=sd2->d2_emissao
			tmp1->nota :=sd2->d2_doc
			tmp1->serie:=sd2->d2_serie
			tmp1->desc:=sd2->d2_desc
			tmp1->total:=sd2->d2_total
			tmp1->promoc:=sc6010->c6_promoc
			if sc5010->c5_condpag$"536/607/608/836/860/861" // A VISTA
				if sb1010->b1_promoc$"PF" .and. sc5010->c5_promoc=="S"
					tmp1->avista:=3
				else
					if da0010->da0_status$"L/R"
						tmp1->avista:=3
					else
						tmp1->avista:=5
					endif
				endif
			else
				tmp1->avista := 0
			endif
			if sc5010->c5_TPFRETE =="F" // FRETE POR CONTA DO CLIENTE
				tmp1->tpfrete:=2.5
			else
				tmp1->tpfrete := 0
			endif			
		endif
		sd2->(dbskip())
	end
	_abretop("SD2010",5)
	sd2010->(dbseek(_cfilsd2+dtos(mv_par01),.t.))
	while ! sd2010->(eof()) .and.;
		sd2010->d2_filial==_cfilsd2 .and.;
		sd2010->d2_emissao<=mv_par02
		if sd2010->d2_cliente <  mv_par03 .or. sd2010->d2_cliente > mv_par05
			sd2010->(dbskip())
			loop
		endif
		
		incproc("Processando notas fiscais de saida: "+dtoc(sd2010->d2_emissao))
		sc6010->(dbseek(_cfilsc6+sd2010->d2_cod+sd2010->d2_pedido))
		sc5010->(dbseek(_cfilsc5+sd2010->d2_pedido))
		if sc5010->c5_vend1 <> mv_par07
			sd2010->(dbskip())
			loop
		endif
		sf4010->(dbseek(_cfilsf4+sd2010->d2_tes))
		_vendedor :=sc5010->c5_vend1
		sf4010->(dbseek(_cfilsf4+sd2010->d2_tes))
		// Valida Gerente Regional
		sa3->(dbsetorder(1))
		sa3->(dbseek(_cfilsa3+_vendedor))
		_mger:=if(empty(_cgerente),.t.,if(_cgerente > "001000",sa3->a3_super==_cgerente,sa3->a3_cod==_cgerente)) // Valida Gerente Regional
		
		if _mger .and.;
		   sf4010->f4_estoque=="S" .and.;
			sf4010->f4_duplic=="S"  .and. sc5010->c5_vend1 ==mv_par07
			tmp1->(dbappend())
			tmp1->cliente := sd2010->d2_cliente
			tmp1->loja :=sd2010->d2_loja
			tmp1->emissao :=sd2010->d2_emissao
			tmp1->nota :=sd2010->d2_doc
			tmp1->serie:=sd2010->d2_serie
			tmp1->desc:=sd2010->d2_desc
			tmp1->total:=sd2010->d2_total
			tmp1->promoc:=sc6010->c6_promoc
			if sc5010->c5_condpag$"536/607/608/836/860/861" // A VISTA
				if sb1010->b1_promoc$"PF" .and. sc5010->c5_promoc=="S"
					tmp1->avista:=3
				else
					if da0010->da0_status$"L/R"
						tmp1->avista:=3
					else
						tmp1->avista:=5
					endif
				endif
			else
				tmp1->avista := 0
			endif
			if sc5010->c5_TPFRETE =="F" // FRETE POR CONTA DO CLIENTE
				tmp1->tpfrete:=2.5
			else
				tmp1->tpfrete := 0
			endif
			
			
			//		msgstop("entrei")
		endif
		sd2010->(dbskip())
	end
	sd2010->(dbclosearea())
else
	sd2->(dbseek(_cfilsd2+dtos(mv_par01),.t.))
	while ! sd2->(eof()) .and.;
		sd2->d2_filial==_cfilsd2 .and.;
		sd2->d2_emissao<=mv_par02
		incproc("Processando notas fiscais de saida: "+dtoc(sd2->d2_emissao))
		sc6->(dbseek(_cfilsc6+sd2->d2_cod+sd2->d2_pedido))
		sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
		_vendedor :=sc5->c5_vend1
		if sc5->c5_vend1 <> mv_par07
			sd2->(dbskip())
			loop
		endif
		if sd2->d2_cliente <  mv_par03 .or. sd2->d2_cliente > mv_par05
			sd2->(dbskip())
			loop
		endif
		sf4->(dbseek(_cfilsf4+sd2->d2_tes))
		// Valida Gerente Regional
		sa3->(dbsetorder(1))
		sa3->(dbseek(_cfilsa3+_vendedor))
		_mger:=if(empty(_cgerente),.t.,if(_cgerente > "001000",sa3->a3_super==_cgerente,sa3->a3_cod==_cgerente)) // Valida Gerente Regional
		
		if _mger .and.;
		   sf4->f4_estoque=="S" .and.;
			sf4->f4_duplic=="S" .and. sc5->c5_vend1==mv_par07
			tmp1->(dbappend())
			tmp1->cliente := sd2->d2_cliente
			tmp1->loja :=sd2->d2_loja
			tmp1->emissao :=sd2->d2_emissao
			tmp1->nota :=sd2->d2_doc
			tmp1->serie:=sd2->d2_serie
			tmp1->desc:=sd2->d2_desc
			tmp1->total:=sd2->d2_total
			tmp1->promoc:=sc6->c6_promoc
			if sc5->c5_condpag$"536/607/608/836/860/861" // A VISTA
				if sb1->b1_promoc$"PF" .and. sc5->c5_promoc=="S"
					tmp1->avista:=3
				else
					if da0->da0_status$"L/R"
						tmp1->avista:=3
					else
						tmp1->avista:=5
					endif
				endif
			else
				tmp1->avista := 0
			endif
			if sc5->c5_TPFRETE =="F" // FRETE POR CONTA DO CLIENTE
				tmp1->tpfrete:=2.5
			else
				tmp1->tpfrete := 0
			endif
			
		endif
		sd2->(dbskip())
	end
endif
return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch01","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch02","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do cliente         ?","mv_ch03","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"04","Da loja            ?","mv_ch04","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Ate o cliente      ?","mv_ch05","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"06","Ate a loja         ?","mv_ch06","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Representante      ?","mv_ch07","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"08","Grade              ?","mv_ch08","C",01,0,0,"G",space(60),"mv_par08"       ,"1"              ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Separa Promocao    ?","mv_ch09","N",08,0,0,"C",space(60),"mv_par09"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Tipo Relatorio     ?","mv_ch10","N",08,0,0,"C",space(60),"mv_par10"       ,"Analitico"      ,space(30),space(15),"Sintetico"      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

/*
Ordem Codigo Descricao                                 Quantidade  Valor vendido Preco Medio   %    % acum
99999 999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999.999.999 999.999.999,99  999.999,99 999,99 999,99
*/

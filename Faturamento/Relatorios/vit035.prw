/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT035   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 05/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Preco Medio de Venda de Produtos - Faturamento             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vit apan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "rwmake.ch"
#include "topconn.ch"

user function vit035()
	nordem  :=""
	tamanho :="G"
	limite  :=220
	titulo  :="PRECO MEDIO DE VENDA DE PRODUTOS"
	cdesc1  :="Este programa ira emitir a relacao do preco medio de venda de produtos"
	cdesc2  :=""
	cdesc3  :=""
	cstring :="SD2"
	areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
	nomeprog:="VIT035"
	wnrel   :="VIT035"+Alltrim(cusername)
	alinha  :={}
	aordem  :={"Codigo","Descricao","Quantidade","Valor","Tipo"}
	nlastkey:=0
	ccancel := "***** CANCELADO PELO OPERADOR *****"
	lcontinua:=.t.

	cperg:="PERGVIT035"
	_pergsx1()
	pergunte(cperg,.f.)

/*
IF mv_par09>="2"
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
*/
wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	if mv_par09>="2"
		tcquit()
	endif
return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

if nlastkey==27
	set filter to
	if mv_par09>="2"
		tcquit()
	endif
return
endif

rptstatus({|| rptdetail()})
if mv_par09>="2"
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

	cabec1:="PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)+" - "+mv_par12
//cabec2:="Ordem Codigo Descricao                                 Quantidade  Valor vendido Preco Medio     %Linha  %Acum. %Geral %Acum.G"
	cabec2:="Ordem Codigo Descricao                      Qtde.Farma    Valor Farma  Pr.M.Farma   %    %Ac.Farm  Qtde.Lic.      Valor Lic. Pr.Med.Lic    %   %Ac.Lic.  Qtde.Total   Valor Total    Pr.Medio  %Linha %Ac.L %Geral %Acum.G"

	_cfilsb1:=xfilial("SB1")
	_cfilsa1:=xfilial("SA1")
	_cfilsa3:=xfilial("SA3")
	_cfilsf2:=xfilial("SF2")
	_cfilsd2:=xfilial("SD2")
	_cfilsf4:=xfilial("SF4")
	_cfilsc5:=xfilial("SC5")
	_cfilsc6:=xfilial("SC6")
	_cfilda0:=xfilial("da0")
	_cfilsct:=xfilial("sct")

	sb1->(dbsetorder(1))
	da0->(dbsetorder(1))
	sc5->(dbsetorder(1))
	sc6->(dbsetorder(2))
	sa1->(dbsetorder(1))
	sa3->(dbsetorder(1))
	sf2->(dbsetorder(1))
	sd2->(dbsetorder(5))
	sf4->(dbsetorder(1))
	sct->(dbsetorder(1))

	_aestrut:={}
	aadd(_aestrut,{"PRODUTO"  ,"C",15,0})
	aadd(_aestrut,{"DESCRICAO","C",40,0})
	aadd(_aestrut,{"QUANT"    ,"N",09,0})
	aadd(_aestrut,{"VALOR"    ,"N",12,2})
	aadd(_aestrut,{"QUANTh"    ,"N",09,0})
	aadd(_aestrut,{"VALORh"    ,"N",12,2})
	aadd(_aestrut,{"APRVEN"    ,"C",1,0})
	aadd(_aestrut,{"CLIENTE"    ,"C",40,0})
	aadd(_aestrut,{"UF"         ,"C",02,0})
	aadd(_aestrut,{"TIPOPED"    ,"C",1,0})
	aadd(_aestrut,{"REPRES"    ,"C",6,0})
	aadd(_aestrut,{"GERREP"    ,"C",6,0})
	aadd(_aestrut,{"ANO"    ,"C",02,0})
	aadd(_aestrut,{"MES"      ,"C",02,0})


	_carqtmp1:=criatrab(_aestrut,.t.)
	dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
	_cindtmp11:=criatrab(,.f.)
	_cchave   :="produto"
	tmp1->(indregua("TMP1",_cindtmp11,_cchave))

	if nordem==1
		_cindtmp12:=criatrab(,.f.)
		_cchave   :="aprven+produto"
		tmp1->(indregua("TMP1",_cindtmp12,_cchave))
	elseif nordem==2
		_cindtmp12:=criatrab(,.f.)
		_cchave   :="aprven+descricao+produto"
		tmp1->(indregua("TMP1",_cindtmp12,_cchave))
	elseif nordem==3
		_cindtmp12:=criatrab(,.f.)
		_cchave   :="aprven+strzero(quant,09)+descricao+produto"
		tmp1->(indregua("TMP1",_cindtmp12,_cchave))
	else
		_cindtmp12:=criatrab(,.f.)
		_cchave   :="aprven+strzero(valor,12,2)+descricao+produto"
		tmp1->(indregua("TMP1",_cindtmp12,_cchave))
	endif
//*if nordem>1
	tmp1->(dbclearind())
	tmp1->(dbsetindex(_cindtmp11))
	tmp1->(dbsetindex(_cindtmp12))
	tmp1->(dbsetorder(1))
//endif
	_ntotvalor:=0
	_ntotquant:=0
	_ntlinha1 :=0
	_ntlinha2 :=0
	_ntotvalh:=0
	_ntotvalr:=0


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
	tmp1->(dbsetorder(2))


	_i       :=1
	_npacum  :=0
	_caprven :=" "
	_ntotlin := 0
	_ntotvlin :=0
	_ntotquant:=0
	_nvalor := 0
	_nvalorh := 0
	_nttquant:=0
	_ntquant:=0
	_ntquant:=0

	_a :=1
	_nrep := ""
	_nprod :=""
	_nlacum :=0
	_nger :=""

	store 0 to _ngquant,_ngvalor,_ngtquant,_nperch,_npacumh,_nprmedh,_nperct,_npacumt,_ntotlinh,_ntotquanh,_ntotvlinh
	store 0 to _nvalorh,_ntotling,_ntotquang,_ntotvling,_nvalorg

	tmp1->(dbsetorder(2))
	if nordem>2 .or. nordem>6
		tmp1->(dbgobottom())
	else
		tmp1->(dbgotop())
	endif

	while if(nordem>2,!tmp1->(bof()),! tmp1->(eof())) .and.;
			lcontinua
		incregua()
		if prow()==0 .or. prow()>55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
		endif
		if _caprven<>tmp1->aprven
			if _ntotquant>0
				@ prow()+1,000 PSAY "TOTAL LINHA"+if(_caprven="1"," FARMA:"," HOSPITALAR")
				@ prow(),043   PSAY _ntotquant picture "@E 999,999,999"
				@ prow(),055   PSAY _nvalor picture "@E 999,999,999.99"
				@ prow(),097   PSAY _ntotquanh picture "@E 999,999,999"
				@ prow(),110   PSAY _nvalorh picture "@E 999,999,999.99"
				@ prow(),151   PSAY _ntotquang picture "@E 999,999,999"
				@ prow(),164   PSAY _nvalorg picture "@E 999,999,999.99"
			
				@ prow()+1,000 PSAY ""
				_nttquant +=_ntquant
			
				_ntotlin +=_ntotquant
				_ntotvlin += _nvalor
				_ntotlinh +=_ntotquanh
				_ntotvlinh += _nvalorh
				_ntotling +=_ntotquang
				_ntotvling += _nvalorg
				store 0 to _ntotquant,_ntquant,_nvalor,_nlacum,_nvalorh,_nvalorg,_ntotquant,_ntotquanh,_nvalorh,_ntotquang
				_i:=0
			endif
			_caprven:=tmp1->aprven
		endif
		if !empty(mv_par10) .and. _a =1
			@ prow()+1,000 PSAY tmp1->cliente
			@ prow()+1,000 PSAY ""
		endif
		if !empty(mv_par11) .and. _a =1
			@ prow()+1,000 PSAY tmp1->uf
			@ prow()+1,000 PSAY ""
		endif
		_nprmed:=round(tmp1->valor/tmp1->quant,2)
		_nprmedh:=round(tmp1->valorh/tmp1->quanth,2)
		_nperc :=round((tmp1->valor/_ntotvalor)*100,2)
		_npacum+= round(_nperc,2)
		_nperch :=round((tmp1->valorh/_ntotvalor)*100,2)
		_npacumh+= round(_nperch,2)
		_nperct :=round(((tmp1->valorh+tmp1->valor)/_ntotvalor)*100,2)
		_npacumt+= round(_nperct,2)
		@ prow()+1,000 PSAY _i          picture "99999"
		@ prow(),006   PSAY left(tmp1->produto,6)
		@ prow(),013   PSAY substr(tmp1->descricao,1,30)
		@ prow(),043   PSAY tmp1->quant picture "@E 999,999,999"
		@ prow(),055   PSAY tmp1->valor picture "@E 999,999,999.99"
		@ prow(),071   PSAY _nprmed     picture "@E 999,999.99"
		@ prow(),083   PSAY _nperc      picture "@E 999.99"
		@ prow(),091   PSAY _npacum     picture "@E 999.99"
	//lic.
		@ prow(),097   PSAY tmp1->quanth picture "@E 999,999,999"
		@ prow(),110   PSAY tmp1->valorh picture "@E 999,999,999.99"
		@ prow(),125   PSAY _nprmedh     picture "@E 999,999.99"
		@ prow(),136   PSAY _nperch      picture "@E 999.99"
		@ prow(),143   PSAY _npacumh     picture "@E 999.99"
	//Total
		@ prow(),151   PSAY tmp1->quant+tmp1->quanth picture "@E 999,999,999"
		@ prow(),164   PSAY tmp1->valor+tmp1->valorh picture "@E 999,999,999.99"
		@ prow(),179   PSAY (tmp1->valor+tmp1->valorh)/(tmp1->quant+tmp1->quanth) picture "@E 999,999.99" //pr.med
	// % do produto da linha
		if tmp1->aprven=="1"
			_nlacum += round(((tmp1->valor+tmp1->valorh)/_ntlinha1)*100,2)
			@ prow(),191   PSAY round(((tmp1->valor+tmp1->valorh)/_ntlinha1)*100,2) picture "@E 999.99"
			@ prow(),198   PSAY _nlacum picture "@E 999.99"
		else
			_nlacum += round((tmp1->valor/_ntlinha2)*100,2)
			@ prow(),191   PSAY round((tmp1->valor/_ntlinha2)*100,2) picture "@E 999.99"
			@ prow(),198   PSAY _nlacum picture "@E 999.99"
		endif
	
	
		@ prow(),205  PSAY _npercT      picture "@E 999.99" //percentual geral
		@ prow(),212  PSAY _npacumT     picture "@E 999.99" //perc.acumulado
	
		sb1->(dbseek(_cfilsb1+tmp1->produto))
		_ntquant+=tmp1->quant*sb1->b1_conv
		_nvalor +=tmp1->valor
		_ntotquant+=tmp1->quant
		_ntotquanh +=tmp1->quanth
		_nvalorh +=tmp1->valorh
		_ntotquang +=tmp1->quant+tmp1->quanth
		_nvalorg += tmp1->valorh+tmp1->valor
		_i++
		_a++
		if nordem>2
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

	if _ntotquanh>0
		@ prow()+1,000 PSAY "TOTAL LINHA"+if(_caprven="1"," FARMA:"," HOSPITALAR")
		@ prow(),043   PSAY _ntotquant picture "@E 999,999,999"
		@ prow(),055   PSAY _nvalor picture "@E 999,999,999.99"
		@ prow(),097   PSAY _ntotquanh picture "@E 999,999,999"
		@ prow(),110   PSAY _nvalorh picture "@E 999,999,999.99"
		@ prow(),151   PSAY _ntotquang picture "@E 999,999,999"
		@ prow(),164   PSAY _nvalorg picture "@E 999,999,999.99"
		_nttquant +=_ntquant
		_ntotlin +=_ntotquant
		_ntotvlin += _nvalor
		_ntotlinh +=_ntotquanh
		_ntotvlinh += _nvalorh
		_ntotling +=_ntotquang
		_ntotvling += _nvalorg
	endif

		// Condição criada para atribuir valores às variáveis de totalizadores quando os dados fizerem
		// menção apenas da linha Farma - Incluído em 31/10/06 - Alex Júnio de Miranda.
	if _caprven="1"
		_nttquant +=_ntquant
		_ntotlin +=_ntotquant
		_ntotvlin += _nvalor
		_ntotlinh +=_ntotquanh
		_ntotvlinh += _nvalorh
		_ntotling +=_ntotquang
		_ntotvling += _nvalorg
	endif

	if prow()>0 .and.;
			lcontinua
		@ prow()+1,000 PSAY replicate("-",limite)
		@ prow()+1,000 PSAY "TOTAL"
		@ prow(),043   PSAY _ntotlin picture "@E 999,999,999"
		@ prow(),055   PSAY _ntotvlin picture "@E 999,999,999.99"
		@ prow(),097   PSAY _ntotlinh picture "@E 999,999,999"
		@ prow(),110   PSAY _ntotvlinh picture "@E 999,999,999.99"
		@ prow(),151   PSAY _ntotling picture "@E 999,999,999"
		@ prow(),164   PSAY _ntotvling picture "@E 999,999,999.99"
	
	//	@ prow(),108   PSAY _nttquant picture "@E 9,999,999,999"
		roda(cbcont,cbtxt)
	endif


	_cindtmp11+=tmp1->(ordbagext())
	if nordem>1
		_cindtmp12+=tmp1->(ordbagext())
	endif
	tmp1->(dbclosearea())
	ferase(_carqtmp1+getdbextension())
	ferase(_cindtmp11)
	if nordem>1
		ferase(_cindtmp12)
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
	procregua(sd2->(lastrec()))

	sd2->(dbseek(_cfilsd2+dtos(mv_par01),.t.))
	while ! sd2->(eof()) .and.;
			sd2->d2_filial==_cfilsd2 .and.;
			sd2->d2_emissao<=mv_par02
		incproc("Processando notas fiscais de saida T: "+dtoc(sd2->d2_emissao))
		sc6->(dbseek(_cfilsc6+sd2->d2_cod+sd2->d2_pedido))
		// Valida Gerente Regional
		sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
		sa3->(dbsetorder(1))
		sa3->(dbseek(_cfilsa3+sf2->f2_vend1))
		_mger:=if(empty(_cgerente),.t.,if(_cgerente > "001000",sa3->a3_super==_cgerente,sa3->a3_cod==_cgerente)) // Valida Gerente Regional
		if _mger .and.;
				sd2->d2_cod>=mv_par03 .and.;
				sd2->d2_cod<=mv_par04 .and.;
				sd2->d2_tipo=="N"
			sf4->(dbseek(_cfilsf4+sd2->d2_tes))
			if sf4->f4_estoque=="S" .and.;
					sf4->f4_duplic=="S"
				sb1->(dbseek(_cfilsb1+sd2->d2_cod))
				if sb1->b1_tipo>=mv_par05 .and.;
						sb1->b1_tipo<=mv_par06 .and.;
						sb1->b1_grupo>=mv_par07 .and.;
						sb1->b1_grupo<=mv_par08
					if !empty(mv_par10)  // p/cliente especifico
						sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
						sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
						if sf2->f2_cliente== mv_par10
							if ! tmp1->(dbseek(sd2->d2_cod))
								tmp1->(dbappend())
								tmp1->produto  :=sd2->d2_cod
								tmp1->descricao:=sb1->b1_desc
								sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
								da0->(dbseek(_cfilda0+sc5->c5_tabela))
								if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
									tmp1->quanth    :=sd2->d2_quant
									tmp1->valorh    :=sd2->d2_total
								else
									tmp1->quant    :=sd2->d2_quant
									tmp1->valor    :=sd2->d2_total
								endif
								tmp1->aprven   :=sb1->b1_apreven
								tmp1->cliente  :=substr(sa1->a1_nome,1,40)
								tmp1->repres :=sf2->f2_vend1
//								tmp1->meta   :=sct->ct_quant
								tmp1->gerrep :=sf2->f2_vend2
							else
								sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
								da0->(dbseek(_cfilda0+sc5->c5_tabela))
								if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
									tmp1->quanth    +=sd2->d2_quant
									tmp1->valorh    +=sd2->d2_total
								else
									tmp1->quant    +=sd2->d2_quant
									tmp1->valor    +=sd2->d2_total
								endif
							endif
						endif
					elseif !empty(mv_par11) // para estado especifico
						sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
						if sf2->f2_est== alltrim(mv_par11)
							if !tmp1->(dbseek(sd2->d2_cod))
								tmp1->(dbappend())
								tmp1->produto  :=sd2->d2_cod
								tmp1->descricao:=sb1->b1_desc
								tmp1->aprven   :=sb1->b1_apreven
								tmp1->uf       :=sf2->f2_est
								sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
								da0->(dbseek(_cfilda0+sc5->c5_tabela))
								if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
									tmp1->quanth    :=sd2->d2_quant
									tmp1->valorh    :=sd2->d2_total
								else
									tmp1->quant    :=sd2->d2_quant
									tmp1->valor    :=sd2->d2_total
								endif
								
							else
								sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
								da0->(dbseek(_cfilda0+sc5->c5_tabela))
								if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
									tmp1->quanth    +=sd2->d2_quant
									tmp1->valorh    +=sd2->d2_total
								else
									tmp1->quant    +=sd2->d2_quant
									tmp1->valor    +=sd2->d2_total
								endif
								
							endif
						endif
					elseif !empty(mv_par12) // para tipo de pedido especifico licitacao ou farma
						sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
						da0->(dbseek(_cfilda0+sc5->c5_tabela))
						if mv_par12 == "L"
							if (da0->da0_status = "L" .or. da0->da0_status = "R")
								if ! tmp1->(dbseek(sd2->d2_cod))
									tmp1->(dbappend())
									tmp1->produto  :=sd2->d2_cod
									tmp1->descricao:=sb1->b1_desc
									tmp1->aprven   :=sb1->b1_apreven
									sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
									da0->(dbseek(_cfilda0+sc5->c5_tabela))
									if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
										tmp1->quanth    :=sd2->d2_quant
										tmp1->valorh    :=sd2->d2_total
									else
										tmp1->quant    :=sd2->d2_quant
										tmp1->valor    :=sd2->d2_total
									endif
									
								else
									sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
									da0->(dbseek(_cfilda0+sc5->c5_tabela))
									if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
										tmp1->quanth    +=sd2->d2_quant
										tmp1->valorh    +=sd2->d2_total
									else
										tmp1->quant    +=sd2->d2_quant
										tmp1->valor    +=sd2->d2_total
									endif
									
								endif
							endif
						else
							//					  if empty(da0->da0_status)  //  = "L" .or. da0->da0_status = "R")
							if ! tmp1->(dbseek(sd2->d2_cod))
								tmp1->(dbappend())
								tmp1->produto  :=sd2->d2_cod
								tmp1->descricao:=sb1->b1_desc
								tmp1->aprven   :=sb1->b1_apreven
								sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
								da0->(dbseek(_cfilda0+sc5->c5_tabela))
								if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
									tmp1->quanth    :=sd2->d2_quant
									tmp1->valorh    :=sd2->d2_total
								else
									tmp1->quant    :=sd2->d2_quant
									tmp1->valor    :=sd2->d2_total
								endif
								
							else
								sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
								da0->(dbseek(_cfilda0+sc5->c5_tabela))
								if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
									tmp1->quanth    +=sd2->d2_quant
									tmp1->valorh    +=sd2->d2_total
								else
									tmp1->quant    +=sd2->d2_quant
									tmp1->valor   +=sd2->d2_total
								endif
							endif
							//						endif
						endif


					elseif !empty(mv_par13) // para representante especifico
						sf2->(dbseek(_cfilsf2+sd2->d2_doc+sd2->d2_serie))
						if sf2->f2_vend1== alltrim(mv_par13)
							if !tmp1->(dbseek(sd2->d2_cod))
								tmp1->(dbappend())
								tmp1->produto  :=sd2->d2_cod
								tmp1->descricao:=sb1->b1_desc
								tmp1->aprven   :=sb1->b1_apreven
								tmp1->uf       :=sf2->f2_est
								sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
								da0->(dbseek(_cfilda0+sc5->c5_tabela))
								if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
									tmp1->quanth    :=sd2->d2_quant
									tmp1->valorh    :=sd2->d2_total
								else
									tmp1->quant    :=sd2->d2_quant
									tmp1->valor    :=sd2->d2_total
								endif
								
							else
								sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
								da0->(dbseek(_cfilda0+sc5->c5_tabela))
								if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
									tmp1->quanth    +=sd2->d2_quant
									tmp1->valorh    +=sd2->d2_total
								else
									tmp1->quant    +=sd2->d2_quant
									tmp1->valor    +=sd2->d2_total
								endif
																
							endif
						endif

					else  // relatorio abc geral
						if ! tmp1->(dbseek(sd2->d2_cod))
							tmp1->(dbappend())
							tmp1->produto  :=sd2->d2_cod
							tmp1->descricao:=sb1->b1_desc
							tmp1->aprven   :=sb1->b1_apreven
							sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
							da0->(dbseek(_cfilda0+sc5->c5_tabela))
							if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
								tmp1->quanth    :=sd2->d2_quant
								tmp1->valorh    :=sd2->d2_total
							else
								tmp1->quant    :=sd2->d2_quant
								tmp1->valor    :=sd2->d2_total
							endif
							
						else
							sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
							da0->(dbseek(_cfilda0+sc5->c5_tabela))
							if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
								tmp1->quanth    +=sd2->d2_quant
								tmp1->valorh    +=sd2->d2_total
							else
								tmp1->quant    +=sd2->d2_quant
								tmp1->valor    +=sd2->d2_total
							endif
						endif
					endif
					_ntotvalor+=sd2->d2_total
					sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
					da0->(dbseek(_cfilda0+sc5->c5_tabela))
					if (da0->da0_status = "L" .or. da0->da0_status = "R")  // identifica a tabela de licitação
						_ntotvalh +=sd2->d2_total
					else
						_ntotvalr +=sd2->d2_total
					endif
					if	sb1->b1_apreven == '1'
						_ntlinha1 +=sd2->d2_total
					else
						_ntlinha2 +=sd2->d2_total
					endif
					
				endif
			endif
		endif
		sd2->(dbskip())
	end
	sd2->(dbclosearea())

return


static function _pergsx1()
	_agrpsx1:={}
	aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"03","Do produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
	aadd(_agrpsx1,{cperg,"04","Ate o produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
	aadd(_agrpsx1,{cperg,"05","Do tipo            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
	aadd(_agrpsx1,{cperg,"06","Ate o tipo         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
	aadd(_agrpsx1,{cperg,"07","Do grupo           ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
	aadd(_agrpsx1,{cperg,"08","Ate o grupo        ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
	aadd(_agrpsx1,{cperg,"09","Grade              ?","mv_ch9","C",01,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"10","Do cliente         ?","mv_chA","C",06,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
	aadd(_agrpsx1,{cperg,"11","Do estado          ?","mv_chB","C",02,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"12","Tipo               ?","mv_chC","C",01,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"13","Do representante   ?","mv_chd","C",06,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})

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
Ordem Codigo Descricao                     Qtde.Farma    Valor Farma  Pr.M.Farma   %    % acum   Qtde.Lic.     Valor Lic. Pr.Med.Lic    %   % acum   Qtde.Total   Valor Total    Pr.Medio     %   % acum
99999 999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999.999.999 999.999.999,99  999.999,99 999,99 999,99 999.999.999 999.999.999,99  999.999,99 999,99 999,99 999.999.999 999.999.999,99  999.999,99 999,99 999,99
7      14                            44          56              72         83     91     97          110             125        136    143    151         164             179        189    196
*/

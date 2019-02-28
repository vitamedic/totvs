/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT173   ³ Autor ³ Aline B. Pereira      ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Vendas por Clientes                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit173()
	nordem  :=""
	tamanho :="G"
	limite  :=220
	titulo  :="RELATORIO DE VENDAS POR CLIENTES "
	cdesc1  :="Este programa ira emitir a relacao de Venda por Cliente"
	cdesc2  :=""
	cdesc3  :=""
	cstring :="SF2"
	areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
	nomeprog:="VIT173"
	wnrel   :="VIT173"+Alltrim(cusername)
	alinha  :={}
	aordem  :={"Alfabetica","Ranking","Atraso","UF","Sintetico-UF","Prazo"}
	nlastkey:=0
	ccancel := "***** CANCELADO PELO OPERADOR *****"
	lcontinua:=.t.

	cperg:="PERGVIT173"
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
		if mv_par06=="2"
			tcquit()
		endif
		return
	endif

	if mv_par06=="2"
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
	if mv_par06=="2"
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
	_acom :={}
	_ames :={}


	cabec1:="PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)
	cabec2:="Ordem Codigo Nome                                       UF  Farma   Lic.Farma    Lic.Hosp.       Total Bonificacao     %   Atrz. Prz. Desc.    %   %Acum."
	cabec3:="UF          Farma   Lic.Farma     Lic.Economica    Total Lic.         Total    Bonificacao "


//  Valor vendido Preco Medio   %    % acum"

	_cfilsb1:=xfilial("SB1")
	_cfilsa1:=xfilial("SA1")
	_cfilsd2:=xfilial("SD2")
	_cfilsa3:=xfilial("SA3")
	_cfilsf2:=xfilial("SF2")
	_cfilsf4:=xfilial("SF4")
	_cfilsc5:=xfilial("SC5")
	_cfilda0:=xfilial("DA0")
	_cfilse4:=xfilial("SE4")

	sa1->(dbsetorder(1))
	sb1->(dbsetorder(1))
	sd2->(dbsetorder(3))
	sa3->(dbsetorder(1))
	sf2->(dbsetorder(1))
	sf4->(dbsetorder(1))
	sc5->(dbsetorder(1))
	sc6->(dbsetorder(1))
	da0->(dbsetorder(1))
	if mv_par06=="2"
		_abretop("SF2010",1)
		_abretop("SE4010",1)
		_abretop("SF4010",1)
		_abretop("SA1010",1)
		_abretop("SA3010",1)
		_abretop("SC5010",1)
		_abretop("SD2010",3)
		_abretop("SB1010",1)
		_abretop("DA0010",1)
		_cindsf2:=criatrab(,.f.)
		_cchave :="F2_FILIAL+DTOS(F2_EMISSAO)+F2_CLIENTE+F2_LOJA"
		_cfiltro:="F2_TIPO$'NC'"
		sf2010->(indregua("SF2010",_cindsf2,_cchave,,_cfiltro))
	endif


	_cindsf2:=criatrab(,.f.)
	_cchave :="F2_FILIAL+DTOS(F2_EMISSAO)+F2_CLIENTE+F2_LOJA"
	_cfiltro:="F2_TIPO$'NC'"
//_cfiltro:="F2_TIPO$'NC' .AND. F2_VALFAT>0"
	sf2->(indregua("SF2",_cindsf2,_cchave,,_cfiltro))


	_aestrut:={}
	aadd(_aestrut,{"CLIENTE"  ,"C",6,0})
	aadd(_aestrut,{"LOJA"  ,"C",2,0})
	aadd(_aestrut,{"NOME","C",30,0})
	aadd(_aestrut,{"UF","C",2,0})
	aadd(_aestrut,{"VALORFF"    ,"N",11,2})
	aadd(_aestrut,{"VALICH"    ,"N",11,2})
	aadd(_aestrut,{"VALICF"    ,"N",11,2})
	aadd(_aestrut,{"PRAZO"    ,"N",11,0})
	aadd(_aestrut,{"PARCELAS"    ,"N",11,0})
	aadd(_aestrut,{"PRAZOMED"    ,"N",11,0})
	aadd(_aestrut,{"DESCONTO"    ,"N",11,0})
	aadd(_aestrut,{"REPASSE"    ,"N",11,0})
	aadd(_aestrut,{"ATRASO"    ,"N",11,2})
	aadd(_aestrut,{"TOTAL"    ,"N",11,2})
	aadd(_aestrut,{"TPPED"    ,"C",01,0})
	aadd(_aestrut,{"BONIFIC"  ,"N",11,2})
	aadd(_aestrut,{"ANO"      ,"C",02,0})
	aadd(_aestrut,{"MES"      ,"C",02,0})

	_carqtmp1:=criatrab(_aestrut,.t.)
	dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
	_cindtmp11:=criatrab(,.f.)
	_cchave   :="cliente+loja"
	tmp1->(indregua("TMP1",_cindtmp11,_cchave))

	_cindtmp12:=criatrab(,.f.)
	_cchave   :="nome+strzero(valorff+valich+valicf,11,2)"
	tmp1->(indregua("TMP1",_cindtmp12,_cchave))

	_cindtmp13:=criatrab(,.f.)
	_cchave   :="strzero(valorff+valich+valicf,11,2)+nome"
	tmp1->(indregua("TMP1",_cindtmp13,_cchave))

	_cindtmp14:=criatrab(,.f.)
	_cchave   :="strzero(atraso)+strzero(valorff+valich+valicf,11,2)+nome"
	tmp1->(indregua("TMP1",_cindtmp14,_cchave))

	_cindtmp15:=criatrab(,.f.)
	_cchave   :="uf+ano+mes"
	tmp1->(indregua("TMP1",_cindtmp15,_cchave))

	_cindtmp16:=criatrab(,.f.)
	_cchave   :="strzero(prazo/parcelas)+nome"
	tmp1->(indregua("TMP1",_cindtmp16,_cchave))

	tmp1->(dbclearind())
	tmp1->(dbsetindex(_cindtmp11))
	tmp1->(dbsetindex(_cindtmp12))
	tmp1->(dbsetindex(_cindtmp13))
	tmp1->(dbsetindex(_cindtmp14))
	tmp1->(dbsetindex(_cindtmp15))
	tmp1->(dbsetindex(_cindtmp16))
	tmp1->(dbsetorder(1))

	_ntotquant:=0
	_nvalortot :=0
	_numcli := 0
	_nrep := 0

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
	_i      :=1
	_npacum :=0
	_nvalorf:=0
	_nvalorh:=0
	_nqtlinha := 0
	_ntipo:=" "


	if nordem==1
		tmp1->(dbsetorder(2))
		tmp1->(dbgotop())
		_ccond:="! tmp1->(eof())"
	elseif nordem==2
		tmp1->(dbsetorder(3))
		tmp1->(dbgobottom())
		_ccond:="! tmp1->(bof())"
	elseif nordem==3
		tmp1->(dbsetorder(4))
		tmp1->(dbgotop())
		_ccond:="! tmp1->(eof())"
	elseif nordem==6
		tmp1->(dbsetorder(6))
		tmp1->(dbgobottom())
		_ccond:="! tmp1->(bof())"
	else
		tmp1->(dbsetorder(5))
		tmp1->(dbgotop())
		_ccond:="! tmp1->(eof())"
	endif
	_ntgff :=0
	_ntgfh :=0
	_ntgch :=0
	_npacum :=0
	_nperc :=0
	_ncont := 0
	_nc := .t.
	_ntbon:=0
	_nprz :=0
	_nsgff :=0
	_nsgfh :=0
	_nsgch :=0
	_nsprz :=0
	_nsbon :=0
	_muf:=""
	_ntgffu  :=0
	_ntgfhu :=0
	_ntgchu  :=0
	_nprzu := 0
	_j:=0
	_ntbonu :=0
	_nsgffu  :=0
	_nsgfhu  :=0
	_nsgchu  :=0
	_nsprzu :=0
	_nsbonu :=0
	_natrso :=0
	_natrsz :=	0
	_n := 0
	_npzec :=0
	_nec:=0
	_npzfr := 0
	_nfr :=0
	if nordem <> 5
		while &_ccond .and.;
				lcontinua
			incregua()
			if prow()==0 .or. prow()>60
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			_nperc :=round(((tmp1->valorff+tmp1->valicf+tmp1->valich)/_nvalortot)*100,2)
			_npacum+=_nperc
			_nmedd := 0
			if !empty(tmp1->valorff)
				_nmedd := tmp1->total
				_nmedd:= _nmedd -(_nmedd *.65 )
				_nmedd := _nmedd - (_nmedd *( tmp1->repasse/100))
				_nmedd := round(100-((tmp1->valorff)/_nmedd*100),2)
			endif
			if nordem<>6
				if _npacum <= 50.99 .and. _i = 1
					@ prow()+1,000 PSAY "CLIENTES A "
				elseif (_npacum > 51 .and. _npacum <= 80) .and. _nc
					_nc = .f.
					if !empty(_nsgff+_nsgfh+_nsgch)
						if prow()>58
							cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
						endif
						@ prow()+1,000 PSAY "SUB-TOTAL :"
						@ prow(),054   PSAY _nsgff picture "@E 9999,999.99"
						@ prow(),066   PSAY _nsgfh picture "@E 9999,999.99"
						@ prow(),079   PSAY _nsgch picture "@E 9999,999.99"
						@ prow(),091   PSAY _nsgff+_nsgfh+_nsgch picture "@E 99999,999.99"
						@ prow(),103   PSAY _nsbon picture "@E 99999,999.99"
						@ prow(),115   PSAY round((_nsbon/(_nsgff+_nsgfh+_nsgch))*100,2) picture "@E 999.99"
						@ prow(),127   PSAY _nsprz/_i picture "@E 9999"
						_nsgff :=0
						_nsgfh :=0
						_nsgch :=0
						_nsprz :=0
						_nsbon :=0
					endif
					@ prow()+1,000 PSAY " "
					@ prow()+1,000 PSAY "CLIENTES B "
				elseif _npacum > 80
					if !_nc
						if !empty(_nsgff+_nsgfh+_nsgch)
							if prow()>58
								cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
							endif
							@ prow()+1,000 PSAY "SUB-TOTAL :"
							@ prow(),054   PSAY _nsgff picture "@E 9999,999.99"
							@ prow(),066   PSAY _nsgfh picture "@E 9999,999.99"
							@ prow(),079   PSAY _nsgch picture "@E 9999,999.99"
							@ prow(),091   PSAY _nsgff+_nsgfh+_nsgch picture "@E 99999,999.99"
							@ prow(),103   PSAY _nsbon picture "@E 99999,999.99"
							@ prow(),115   PSAY round((_nsbon/(_nsgff+_nsgfh+_nsgch))*100,2) picture "@E 999.99"
							@ prow(),127   PSAY _nsprz/_i picture "@E 9999"
							_nsgff :=0
							_nsgfh :=0
							_nsgch :=0
							_nsprz :=0
							_nsbon :=0
						endif
						@ prow()+1,000 PSAY " "
						@ prow()+1,000 PSAY "CLIENTES C "
					endif
					_nc = .t.
				endif
			endif
			@ prow()+1,000 PSAY _i  picture "999"
			@ prow(),004   PSAY tmp1->cliente+"-"+tmp1->loja
			@ prow(),014   PSAY substr(tmp1->nome,1,36)
			@ prow(),051   PSAY tmp1->uf
			@ prow(),054   PSAY tmp1->valorff picture "@E 9999,999.99"
			@ prow(),066   PSAY tmp1->valicf picture "@E 9999,999.99"
			@ prow(),079   PSAY tmp1->valich picture "@E 9999,999.99"
			@ prow(),091   PSAY tmp1->valorff+tmp1->valicf+tmp1->valich picture "@E 9999,999.99"
			@ prow(),103   PSAY tmp1->bonific picture "@E 9999,999.99"
			@ prow(),115   PSAY round(tmp1->bonific/(tmp1->valorff+tmp1->valicf+tmp1->valich)*100,2) picture "@E 999.99"
			@ prow(),122   PSAY tmp1->atraso picture "@E 9999"
			@ prow(),127   PSAY round(tmp1->prazo/tmp1->parcelas,0) picture "@E 9999"
		// prow(),127   PSAY tmp1->prazomed picture "@E 9999"
			@ prow(),132   PSAY _nmedd picture "@E 999.99"
			@ prow(),140   PSAY _nperc picture "@E 999.99"
			@ prow(),147   PSAY _npacum picture "@E 999.99"
			_ntgff  +=tmp1->valorff
			_ntgfh  +=tmp1->valicf
			_ntgch  +=tmp1->valich
			_nprz += round(tmp1->prazo/tmp1->parcelas,0)
		//
			_ntbon += tmp1->bonific
			_nsgff  +=tmp1->valorff
			_nsgfh  +=tmp1->valicf
			_nsgch  +=tmp1->valich
			_nsprz += round(tmp1->prazo/tmp1->parcelas,0)
			_nsbon += tmp1->bonific
			_natrsz +=	tmp1->atraso
		//
			_i++
			_n ++
			if nordem==2 .or. nordem==6
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
				lcontinua
			if prow()>58
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if nordem<5
				if !empty(_nsgff+_nsgfh+_nsgch) .and. nordem<>5
					if prow()>58
						cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
					endif
					@ prow()+1,000 PSAY "SUB-TOTAL C:"
					@ prow(),054   PSAY _nsgff picture "@E 9999,999.99"
					@ prow(),066   PSAY _nsgfh picture "@E 9999,999.99"
					@ prow(),079   PSAY _nsgch picture "@E 9999,999.99"
					@ prow(),091   PSAY _nsgff+_nsgfh+_nsgch picture "@E 99999,999.99"
					@ prow(),103   PSAY _nsbon picture "@E 99999,999.99"
					@ prow(),115   PSAY round((_nsbon/(_nsgff+_nsgfh+_nsgch))*100,2) picture "@E 999.99"
					@ prow(),127   PSAY _nsprz/_i picture "@E 9999"
					_nsgff :=0
					_nsgfh :=0
					_nsgch :=0
					_nsprz :=0
					_nsbon :=0
				endif
			else
				if !empty(_nsgffu) .and. !empty(_nsgffu)
					if prow()>58
						cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
					endif
					_j++
					@ prow()+1,000 PSAY _j   picture "999"
					@ prow(),004   PSAY _muf
					@ prow(),010   PSAY _nsgffu picture "@E 999,999,999.99"
					@ prow(),025   PSAY round((_nsgffu/(_nsgffu+_nsgfhu+_nsgchu))*100,2) picture "@E 999.99"
					@ prow(),033   PSAY _npzfr/_nfr picture "@E 9999"
					@ prow(),039   PSAY _nsgfhu picture "@E 999,999,999.99"
					@ prow(),054   PSAY round((_nsgfhu/(_nsgffu+_nsgfhu+_nsgchu))*100,2) picture "@E 999.99"
					@ prow(),061   PSAY _nsgchu picture "@E 999,999,999.99"
					@ prow(),076   PSAY round((_nsgchu/(_nsgffu+_nsgfhu+_nsgchu))*100,2) picture "@E 999.99"
					@ prow(),083   PSAY _nsgfhu+_nsgchu picture "@E 999,999,999.99"
					@ prow(),098   PSAY round(((_nsgfhu+_nsgchu)/(_nsgffu+_nsgfhu+_nsgchu))*100,2) picture "@E 999.99"
					@ prow(),105   PSAY _npzec/_nec picture "@E 9999"
					@ prow(),110   PSAY _nsgffu+_nsgfhu+_nsgchu picture "@E 999,999,999.99"
					@ prow(),125   PSAY _nsbonu picture "@E 999,999.99"
					@ prow(),136   PSAY round((_nsbonu/(_nsgffu+_nsgfhu+_nsgchu))*100,2) picture "@E 999.99"
					@ prow(),143   PSAY _nsprzu/_n picture "@E 9999"
					_nec := 0
					_nfr := 0
					_nsgffu :=0
					_nsgfhu :=0
					_nsgchu :=0
					_nsprzu :=0
					_nsbonu :=0
					_n := 0
				endif
			endif
		
			if prow()>58
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY "TOTAL GERAL:"
			if nordem <> 5
				@ prow(),054   PSAY _ntgff picture "@E 99999,999.99"
				@ prow(),067   PSAY _ntgfh picture "@E 9999,999.99"
				@ prow(),080   PSAY _ntgch picture "@E 9999,999.99"
				@ prow(),092   PSAY _ntgff+_ntgfh+_ntgch picture "@E 9999999,999.99"
				@ prow(),107   PSAY _ntbon picture "@E 99999,999.99"
				@ prow(),120   PSAY round((_ntbon/(_ntgff+_ntgfh+_ntgch))*100,2) picture "@E 999.99"
				@ prow(),127   PSAY _nprz/_i picture "@E 9999"
			else
				@ prow(),010   PSAY _ntgff picture "@E 999,999,999.99"
				@ prow(),025   PSAY round((_ntgff/(_ntgff+_ntgfh+_ntgch))*100,2) picture "@E 999.99"
			
				@ prow(),039   PSAY _ntgfh picture "@E 999,999,999.99"
				@ prow(),054   PSAY round((_ntgfh/(_ntgff+_ntgfh+_ntgch))*100,2) picture "@E 999.99"
			
				@ prow(),061   PSAY _ntgch picture "@E 999,999,999.99"
				@ prow(),076   PSAY round((_ntgch/(_ntgff+_ntgfh+_ntgch))*100,2) picture "@E 999.99"
			
				@ prow(),083   PSAY _ntgfh+_ntgch picture "@E 999,999,999.99"
				@ prow(),098   PSAY round(((_ntgfh+_ntgch)/(_ntgff+_ntgfh+_ntgch))*100,2) picture "@E 999.99"
			
				@ prow(),110   PSAY _ntgff+_ntgfh+_ntgch picture "@E 999,999,999.99"
				@ prow(),125   PSAY _ntbon picture "@E 999,999.99"
				@ prow(),136   PSAY round((_ntbon/(_ntgff+_ntgfh+_ntgch))*100,2) picture "@E 999.99"
				@ prow(),143   PSAY _natrso/_i picture "@E 9999"
			endif
		endif
	
	/////
	else
		store 0 to _ntgff,_ntgfh,_ntgch,_ntbon,_nttg,_nff,_nfh,_nch,_non
		store 0 to _ngff,_ngfh,_ngch,_nbon,_ntg
	
		tmp1->(dbsetorder(5))
		tmp1->(dbgotop())
		_ccond:="! tmp1->(eof())"
		while ! tmp1->(eof())
			incregua()
			_nval := 0
			aadd(_acom,{tmp1->ano,tmp1->mes,tmp1->uf,tmp1->valorff,tmp1->valicf,tmp1->valich,tmp1->valorff+tmp1->valicf+tmp1->valich,tmp1->bonific})
			tmp1->(dbskip())
		end
		_acoms:= asort(_acom,,,{|y,x| y[3]+y[1]+y[2] < x[3]+x[1]+x[2]})
		cabec(titulo,cabec1,cabec3,wnrel,tamanho,ntipo)
		_muf:=""
		store 0 to  _naff,_nafh,_nach,_nag,_nabon
		_mano :=""
		for _i:=1 to len(_acoms)
			if prow()>54
				cabec(titulo,cabec1,cabec3,wnrel,tamanho,ntipo)
			endif
			if _mano <> _acoms[_i,1]
				if prow()>56
					cabec(titulo,cabec1,cabec3,wnrel,tamanho,ntipo)
				endif
				if !empty(_naff)
					@ prow()+1,000 PSAY replicate("-",limite)
					@ prow()+1,000 PSAY ""
					@ prow(),008   PSAY _naff picture "@E 999,999,999.99"
					@ prow(),023   PSAY _nafh picture "@E 999,999,999.99"
					@ prow(),039   PSAY _nach picture "@E 999,999,999.99"
					@ prow(),055   PSAY _nafh+_nach picture "@E 999,999,999.99"
					@ prow(),070   PSAY _nag picture "@E 999,999,999.99"
					@ prow(),085   PSAY _nabon picture "@E 999,999,999.99"
					@ prow()+1,000 PSAY ""
				//      		aadd(_ames,{_mano,_naff,_nafh,_nach,_nafh+_nach,_nag,_nabon})
					store 0 to  _naff,_nafh,_nach,_nag,_nabon
				endif
				_mano := _acoms[_i,1]
			endif
			if empty(_muf) .or. _muf <> _acoms[_i,3]
				_muf := _acoms[_i,3]
				if prow()>56
					cabec(titulo,cabec1,cabec3,wnrel,tamanho,ntipo)
				endif
			
				if !empty(_ngff)
				//				@ prow()+1,000 PSAY replicate("-",limite)
					@ prow()+1,000 PSAY ""
					@ prow(),008   PSAY _ngff picture "@E 999,999,999.99"
					@ prow(),023   PSAY _ngfh picture "@E 999,999,999.99"
					@ prow(),039   PSAY _ngch picture "@E 999,999,999.99"
					@ prow(),055   PSAY _ngfh+_ngch picture "@E 999,999,999.99"
					@ prow(),070   PSAY _ntg picture "@E 999,999,999.99"
					@ prow(),085   PSAY _nbon picture "@E 999,999,999.99"
				
					_ntgff  +=_ngff
					_ntgfh  +=_ngfh
					_ntgch  +=_ngch
					_nttg += _ntg
					_ntbon += _nbon
					store 0 to  _ngff,_ngfh,_ngch,_ntg,_nbon
				endif
				@ prow()+1,000 PSAY _acoms[_i,3]
			endif
		
			@ prow()+1,000 PSAY _acoms[_i,2] +"/"
			@ prow(),004   PSAY _acoms[_i,1]
			@ prow(),008   PSAY _acoms[_i,4] picture "@E 999,999,999.99"
			@ prow(),023   PSAY _acoms[_i,5] picture "@E 999,999,999.99"
			@ prow(),039   PSAY _acoms[_i,6] picture "@E 999,999,999.99"
			@ prow(),055   PSAY _acoms[_i,6]+_acoms[_i,5] picture "@E 999,999,999.99"
			@ prow(),070   PSAY _acoms[_i,7] picture "@E 999,999,999.99"
			@ prow(),085   PSAY _acoms[_i,8] picture "@E 999,999,999.99"
			_ngff  +=_acoms[_i,4]
			_ngfh  +=_acoms[_i,5]
			_ngch  +=_acoms[_i,6]
			_ntg += _acoms[_i,7]
			_nbon += _acoms[_i,8]
			_naff  +=_acoms[_i,4]
			_nafh  +=_acoms[_i,5]
			_nach  +=_acoms[_i,6]
			_nag += _acoms[_i,7]
			_nabon += _acoms[_i,8]
		
		next
		if !empty(_naff)
			if prow()>56
				cabec(titulo,cabec1,cabec3,wnrel,tamanho,ntipo)
			endif
			if !empty(_naff)
				@ prow()+1,000 PSAY replicate("-",limite)
				@ prow()+1,000 PSAY ""
				@ prow(),008   PSAY _naff picture "@E 999,999,999.99"
				@ prow(),023   PSAY _nafh picture "@E 999,999,999.99"
				@ prow(),039   PSAY _nach picture "@E 999,999,999.99"
				@ prow(),055   PSAY _nafh+_nach picture "@E 999,999,999.99"
				@ prow(),070   PSAY _nag picture "@E 999,999,999.99"
				@ prow(),085   PSAY _nabon picture "@E 999,999,999.99"
				@ prow()+1,000 PSAY ""
			
				store 0 to  _naff,_nafh,_nach,_nag,_nabon
			endif
		endif
	
		if !empty(_ngff)
			if prow()>56
				cabec(titulo,cabec1,cabec3,wnrel,tamanho,ntipo)
			endif
		
			@ prow()+1,000 PSAY replicate("-",limite)
			@ prow()+1,000 PSAY ""
			@ prow(),008   PSAY _ngff picture "@E 999,999,999.99"
			@ prow(),023   PSAY _ngfh picture "@E 999,999,999.99"
			@ prow(),039   PSAY _ngch picture "@E 999,999,999.99"
			@ prow(),055   PSAY _ngfh+_ngch picture "@E 999,999,999.99"
			@ prow(),070   PSAY _ntg picture "@E 999,999,999.99"
			@ prow(),085   PSAY _nbon picture "@E 999,999,999.99"
		
			_ntgff  +=_ngff
			_ntgfh  +=_ngfh
			_ntgch  +=_ngch
			_nttg += _ntg
			_ntbon += _nbon
			store 0 to  _ngff,_ngfh,_ngch,_ntg,_nbon
		endif
		for _i:=1 to len(_ames)
			@ prow()+1,000 PSAY "Ano:"+ _ames[_i,1]
			@ prow(),008   PSAY _ames[_i,2] picture "@E 999,999,999.99"
			@ prow(),023   PSAY _ames[_i,3] picture "@E 999,999,999.99"
			@ prow(),039   PSAY _ames[_i,4] picture "@E 999,999,999.99"
			@ prow(),055   PSAY _ames[_i,4]+_ames[_i,5] picture "@E 999,999,999.99"
			@ prow(),070   PSAY _ames[_i,6] picture "@E 999,999,999.99"
			@ prow(),085   PSAY _ames[_i,7] picture "@E 999,999,999.99"
		next
		if prow()>56
			cabec(titulo,cabec1,cabec3,wnrel,tamanho,ntipo)
		endif
		@ prow()+1,000 PSAY replicate("-",limite)
		@ prow()+1,000 PSAY "Tot"
		@ prow(),006   PSAY _ntgff picture "@E 999,999,999.99"
		@ prow(),019   PSAY _ntgfh picture "@E 999,999,999.99"
		@ prow(),034   PSAY _ntgch picture "@E 999,999,999.99"
		@ prow(),049   PSAY _ntgfh+_ntgch picture "@E 999,999,999.99"
		@ prow(),064   PSAY _nttg picture "@E 999,999,999.99"
		@ prow(),079   PSAY _ntbon picture "@E 999,999,999.99"
	
	endif
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

static function _impzero()
	sb1->(dbseek(_cfilsb1))
	while ! sb1->(eof()) .and.;
			sb1->b1_filial==_cfilsb1
		if sb1->b1_cod>=mv_par05 .and.;
				sb1->b1_cod<=mv_par06
			if sb1->b1_apreven==_ntipo
				_j:=ascan(_aprodlin,sb1->b1_cod)
				if _j==0
					if prow()>60
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
					endif
					@ prow()+1,000 PSAY _i          picture "99999"
					@ prow(),006   PSAY left(sb1->b1_cod,6)
					@ prow(),013   PSAY sb1->b1_desc
					@ prow(),054   PSAY 0           picture "@E 999,999,999"
					_i++
				endif
			endif
		endif
		sb1->(dbskip())
	end
return

static function _calcmov()
	_nprazo :=0
	_nparcelas  :=0

	if mv_par06=="2" // grade 2
		procregua(sf2010->(lastrec()))
		sf2010->(dbseek(_cfilsf2+dtos(mv_par01),.t.))
		while !sf2010->(eof()) .and.;
				sf2010->f2_filial==_cfilsf2 .and.;
				sf2010->f2_emissao<=mv_par02	.and.;
				sd2010->(dbseek(_cfilsd2+sf2010->f2_doc+sf2010->f2_serie+sf2010->f2_cliente+sf2010->f2_loja))
			
			sf4010->(dbseek(_cfilsf4+sd2010->d2_tes))
			sa3010->(dbsetorder(1))
			sa3010->(dbseek(_cfilsa3+_cvend))
			_mger:=if(empty(_cgerente),.t.,if(_cgerente > "001000",sa3->a3_super==_cgerente,sa3->a3_cod==_cgerente)) // Valida Gerente / Representante Regional
			
			if empty(_cgerente)
				_cvend:=sf2010->(fieldget(fieldpos("F2_VEND"+alltrim(str(mv_par05,1)))))
			else
				_cvend:=sf2010->(fieldget(fieldpos("F2_VEND1")))				
			endif
			if _mger .and.;
					_cvend>=mv_par03 .and.;
					_cvend<=mv_par04 .and.;
					sd2010->d2_tipo=="N" .and. sf4010->f4_estoque=="S"  			//.and.sf4010->f4_duplic=="S"
 			                                                   
				if(empty(_cgerente),.t.,if(_cgerente > "001000",sa3->a3_super==_cgerente,sa3->a3_cod==_cgerente)) // Valida Gerente Regional
			
					sa1010->(dbseek(_cfilsa1+sf2010->f2_cliente+sf2010->f2_loja))
					sb1010->(dbseek(_cfilsb1+sd2010->d2_cod))
					sc5010->(dbseek(_cfilsc5+sd2010->d2_pedido))
					da0010->(dbseek(_cfilda0+sc5010->c5_tabela))
			
					_nrep := da0010->da0_desc3
					_mlic := .f.
					if !EMPTY(da0010->da0_status) // = "L" .or. da0->da0_status = "R")
						_mlic := .t.
					endif
					se4010->(dbseek(_cfilse4+sf2010->f2_cond))
					_ccond:=se4010->e4_cond
					if se4010->e4_solid=="S"
						_ccond:=substr(_ccond,at(",",_ccond)+1)
					endif
					_nprazo :=0
					_nparcelas := 0
					while ! empty(_ccond)
						_nprazo+=val(substr(_ccond,1,len(_ccond)-at(",",_ccond)))
						_nparcelas++
						if at(",",_ccond)==0
							_ccond:=""
						else
							_ccond:=substr(_ccond,at(",",_ccond)+1)
						endif
					end
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
					if tmp1->(dbseek(sf2010->f2_cliente+sf2010->f2_loja))
						if	sf4010->f4_duplic=="S" .and. (sb1->b1_tipo =="PA" .or. sb1->b1_tipo='PL')
							if _mlic
								if sb1010->b1_apreven = '1'
									tmp1->valicf +=sf2010->f2_valmerc
								else
									tmp1->valich +=sf2010->f2_valmerc
								endif
								tmp1->tpped :="L"
							else
								tmp1->valorff +=sf2010->f2_valmerc
								tmp1->tpped :="F"
							endif
							tmp1->total += _ndesc
							_nvalortot += sf2010->f2_valmerc
						else
							if (sd2010->d2_tes = '526' .OR. sd2010->d2_tes = '527') .and. (sb1010->b1_tipo='PA' .or. sb1->b1_tipo='PL')
								tmp1->bonific +=sf2010->f2_valmerc
							endif
						endif
						tmp1->prazo+=_nprazo
						tmp1->parcelas+=_nparcelas
					else
						tmp1->(dbappend())
						tmp1->cliente :=sf2010->f2_cliente
						tmp1->loja := sf2010->f2_loja
						tmp1->nome:=substr(sa1010->a1_nome,1,35)
						tmp1->uf:=sa1010->a1_est
						tmp1->prazo:=_nprazo
						tmp1->parcelas:=_nparcelas
						tmp1->atraso := sa1010->a1_metr
						tmp1->repasse := _nrep
						_numcli ++
						if	sf4010->f4_duplic=="S" .and. (sb1->b1_tipo =="PA"  .or. sb1->b1_tipo='PL')
							if _mlic
								if sb1010->b1_apreven = '1'
									tmp1->valicf :=sf2010->f2_valmerc
								else
									tmp1->valich :=sf2010->f2_valmerc
								endif
								tmp1->tpped :="L"
							else
								tmp1->valorff :=sf2010->f2_valmerc
								tmp1->tpped :="F"
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
			end
		endif
// vendas
		procregua(sf2->(lastrec()))
		sf2->(dbseek(_cfilsf2+dtos(mv_par01),.t.))
		while !sf2->(eof()) .and.;
				sf2->f2_filial==_cfilsf2 .and.;
				sf2->f2_emissao<=mv_par02
			sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie+sf2->f2_cliente+sf2->f2_loja))
			sf4->(dbseek(_cfilsf4+sd2->d2_tes))
			_cvend:=sf2->(fieldget(fieldpos("F2_VEND"+alltrim(str(mv_par05,1)))))
			sa3->(dbsetorder(1))
			sa3->(dbseek(_cfilsa3+_cvend))
			_mger:=if(empty(_cgerente),.t.,if(_cgerente > "001000",sa3->a3_super==_cgerente,sa3->a3_cod==_cgerente)) // Valida Gerente Regional

			if  _mger .and.;
					_cvend>=mv_par03 .and.;
					_cvend<=mv_par04 .and.;
					sd2->d2_tipo=="N" .and. sf4->f4_estoque=="S" //.and. sf4->f4_duplic=="S"

				sa1->(dbseek(_cfilsa1+sf2->f2_cliente+sf2->f2_loja))
				sb1->(dbseek(_cfilsb1+sd2->d2_cod))
				sc5->(dbseek(_cfilsc5+sd2->d2_pedido))
				if mv_par06=="2"
					da0010->(dbseek(_cfilda0+sc5->c5_tabela))
					_nrep := da0->da0_desc3
					_mlic := .f.
					if !EMPTY(da0010->da0_status) .and.  da0->da0_status <> "Z"// = "L" .or. da0->da0_status = "R")
						_mlic := .t.
					endif
				else
					da0->(dbseek(_cfilda0+sc5->c5_tabela))
					_nrep := da0->da0_desc3
					_mlic := .f.
					if !EMPTY(da0->da0_status) .and.  da0->da0_status <> "Z"// = "L" .or. da0->da0_status = "R")
						_mlic := .t.
					endif
				endif
				se4->(dbseek(_cfilse4+sf2->f2_cond))
				_ccond:=se4->e4_cond
				if se4->e4_solid=="S"
					_ccond:=substr(_ccond,at(",",_ccond)+1)
				endif
				_nprazo :=0
				_nparcelas := 0
				while ! empty(_ccond)
					_nprazo+=val(substr(_ccond,1,len(_ccond)-at(",",_ccond)))
					_nparcelas++
					if at(",",_ccond)==0
						_ccond:=""
					else
						_ccond:=substr(_ccond,at(",",_ccond)+1)
					endif
				end
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
				if nordem <> 5
					if tmp1->(dbseek(sf2->f2_cliente+sf2->f2_loja))
						if	sf4->f4_duplic=="S" .and. (sb1->b1_tipo =="PA" .or. sb1->b1_tipo =="PL")
							if _mlic
								if sb1->b1_apreven = '1'
									tmp1->valicf +=sf2->f2_valmerc
								else
									tmp1->valich +=sf2->f2_valmerc
								endif
								tmp1->tpped :="L"
							else
								tmp1->valorff +=sf2->f2_valmerc
								tmp1->tpped :="F"
							endif
							tmp1->total += _ndesc
							_nvalortot += sf2->f2_valmerc
						else
							if (sd2->d2_tes = '526' .OR. sd2->d2_tes = '527') .and. (sb1->b1_tipo='PA' .or. sb1->b1_tipo='PL')
								tmp1->bonific +=sf2->f2_valmerc
							endif
						endif
						tmp1->prazo+=_nprazo
						tmp1->parcelas+=_nparcelas
					else
						tmp1->(dbappend())
						tmp1->cliente :=sf2->f2_cliente
						tmp1->loja := sf2->f2_loja
						tmp1->nome:=substr(sa1->a1_nome,1,35)
						tmp1->uf:=sa1->a1_est
						tmp1->prazo:=_nprazo
						tmp1->parcelas:=_nparcelas
						tmp1->atraso := sa1->a1_metr
						tmp1->repasse := _nrep
						_numcli ++
						if	sf4->f4_duplic=="S" .and. (sb1->b1_tipo =="PA" .or. sb1->b1_tipo =="PL")
							if _mlic
								if sb1->b1_apreven = '1'
									tmp1->valicf :=sf2->f2_valmerc
								else
									tmp1->valich :=sf2->f2_valmerc
								endif
								tmp1->tpped :="L"
							else
								tmp1->valorff :=sf2->f2_valmerc
								tmp1->tpped :="F"
						
							endif
							_nvalortot += sf2->f2_valmerc
							tmp1->total := _ndesc
						else
							if (sd2->d2_tes = '526' .OR. sd2->d2_tes = '527') .and. sb1->b1_tipo='PA'
								tmp1->bonific +=sf2->f2_valmerc
							endif
						endif
					endif
				else
			///
					_ano :=SubStr(dtoc(sf2->f2_emissao),7,4)
					_mes :=SubStr(dtoc(sf2->f2_emissao),4,2)
					tmp1->(dbsetorder(5))
					if tmp1->(dbseek(sf2->f2_est+_ano+_mes))
						if	sf4->f4_duplic=="S" .and. (sb1->b1_tipo =="PA" .or. sb1->b1_tipo =="PL")
							if _mlic
								if sb1->b1_apreven = '1'
									tmp1->valicf +=sf2->f2_valmerc
								else
									tmp1->valich +=sf2->f2_valmerc
								endif
								tmp1->tpped :="L"
							else
								tmp1->valorff +=sf2->f2_valmerc
								tmp1->tpped :="F"
							endif
							tmp1->total += _ndesc
							_nvalortot += sf2->f2_valmerc
						else
							if (sd2->d2_tes = '526' .OR. sd2->d2_tes = '527') .and. (sb1->b1_tipo='PA' .or. sb1->b1_tipo='PL')
								tmp1->bonific +=sf2->f2_valmerc
							endif
						endif
						tmp1->prazo+=_nprazo
						tmp1->parcelas+=_nparcelas
					else
						tmp1->(dbappend())
						tmp1->cliente :=sf2->f2_cliente
						tmp1->loja := sf2->f2_loja
						tmp1->nome:=substr(sa1->a1_nome,1,35)
						tmp1->uf:=sf2->f2_est
						tmp1->prazo:=_nprazo
						tmp1->parcelas:=_nparcelas
						tmp1->atraso := sa1->a1_metr
						tmp1->repasse := _nrep
						tmp1->ano := _ano
						tmp1->mes := _mes
						_numcli ++
						if	sf4->f4_duplic=="S" .and. (sb1->b1_tipo =="PA" .or. sb1->b1_tipo =="PL")
							if _mlic
								if sb1->b1_apreven = '1'
									tmp1->valicf :=sf2->f2_valmerc
								else
									tmp1->valich :=sf2->f2_valmerc
								endif
								tmp1->tpped :="L"
							else
								tmp1->valorff :=sf2->f2_valmerc
								tmp1->tpped :="F"
						
							endif
							_nvalortot += sf2->f2_valmerc
							tmp1->total := _ndesc
						else
							if (sd2->d2_tes = '526' .OR. sd2->d2_tes = '527') .and. sb1->b1_tipo='PA'
								tmp1->bonific +=sf2->f2_valmerc
							endif
						endif
					endif
			///
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
		aadd(_agrpsx1,{cperg,"05","Considera vendedor ?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,"Vendedor 1"     ,space(30),space(15),"Vendedor 2"     ,space(30),space(15),"Vendedor 3"     ,space(30),space(15),"Vendedor 4"     ,space(30),space(15),"Vendedor 5"     ,space(30),"   "})
		aadd(_agrpsx1,{cperg,"06","Grade              ?","mv_ch6","C",01,0,0,"G",space(60),"mv_par06"       ,"1"              ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
		aadd(_agrpsx1,{cperg,"07","Estado             ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})


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

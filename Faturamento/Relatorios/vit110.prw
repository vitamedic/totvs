/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT110   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 14/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Curva ABC por Estado x Cliente                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit110()
	nordem  :=""
	tamanho :="G"
	limite  :=220
	titulo  :="CURVA ABC POR CLIENTE"
	cdesc1  :="Este programa ira emitir a curva ABC por cliente por estado"
	cdesc2  :=""
	cdesc3  :=""
	cstring :="SF2"
	areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
	nomeprog:="VIT110"
	wnrel   :="VIT110"+Alltrim(cusername)
	alinha  :={}
	aordem  :={"Alfabetica","Ranking"}
	nlastkey:=0
	ccancel := "***** CANCELADO PELO OPERADOR *****"
	lcontinua:=.t.

	cperg:="PERGVIT110"
	_pergsx1()
	pergunte(cperg,.f.)

	wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.f.,tamanho,"",.f.)


	if nlastkey==27
		set filter to
		return
	endif

	setdefault(areturn,cstring)

	ntipo :=if(areturn[4]==1,15,18)
	nordem:=areturn[8]

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
	cbcont:=0
	m_pag :=1
	li    :=80
	cbtxt :=space(10)

	_ndiaini :=day(mv_par01)
	_ndiafim :=day(mv_par02)
	_nmesini6:=month(mv_par01)
	_nmesfim6:=month(mv_par02)
	_nanoini6:=year(mv_par01)
	_nanofim6:=year(mv_par02)
	_nultdia :=day(lastday(mv_par01))

	_nmesini1:=_nmesini6-5
	if _nmesini1<=0
		_nmesini1+=12
		_nanoini1:=_nanoini6-1
	else
		_nanoini1:=_nanoini6
	endif
	_nmesfim1:=_nmesfim6-5
	if _nmesfim1<=0
		_nmesfim1+=12
		_nanofim1:=_nanofim6-1
	else
		_nanofim1:=_nanofim6
	endif
	_ddataini1:=ctod(strzero(_ndiaini,2)+"/"+strzero(_nmesini1,2)+"/"+strzero(_nanoini1,4))
	if _ndiafim==_nultdia
		_ddatafim1:=ctod(strzero(day(lastday(_ddataini1)),2)+"/"+strzero(_nmesfim1,2)+"/"+strzero(_nanofim1,4))
	else
		_ddatafim1:=ctod(strzero(_ndiafim,2)+"/"+strzero(_nmesfim1,2)+"/"+strzero(_nanofim1,4))
	endif

	_nmesini2:=_nmesini6-4
	if _nmesini2<=0
		_nmesini2+=12
		_nanoini2:=_nanoini6-1
	else
		_nanoini2:=_nanoini6
	endif
	_nmesfim2:=_nmesfim6-4
	if _nmesfim2<=0
		_nmesfim2+=12
		_nanofim2:=_nanofim6-1
	else
		_nanofim2:=_nanofim6
	endif
	_ddataini2:=ctod(strzero(_ndiaini,2)+"/"+strzero(_nmesini2,2)+"/"+strzero(_nanoini2,4))
	if _ndiafim==_nultdia
		_ddatafim2:=ctod(strzero(day(lastday(_ddataini2)),2)+"/"+strzero(_nmesfim2,2)+"/"+strzero(_nanofim2,4))
	else
		_ddatafim2:=ctod(strzero(_ndiafim,2)+"/"+strzero(_nmesfim2,2)+"/"+strzero(_nanofim2,4))
	endif

	_nmesini3:=_nmesini6-3
	if _nmesini3<=0
		_nmesini3+=12
		_nanoini3:=_nanoini6-1
	else
		_nanoini3:=_nanoini6
	endif
	_nmesfim3:=_nmesfim6-3
	if _nmesfim3<=0
		_nmesfim3+=12
		_nanofim3:=_nanofim6-1
	else
		_nanofim3:=_nanofim6
	endif
	_ddataini3:=ctod(strzero(_ndiaini,2)+"/"+strzero(_nmesini3,2)+"/"+strzero(_nanoini3,4))
	if _ndiafim==_nultdia
		_ddatafim3:=ctod(strzero(day(lastday(_ddataini3)),2)+"/"+strzero(_nmesfim3,2)+"/"+strzero(_nanofim3,4))
	else
		_ddatafim3:=ctod(strzero(_ndiafim,2)+"/"+strzero(_nmesfim3,2)+"/"+strzero(_nanofim3,4))
	endif

	_nmesini4:=_nmesini6-2
	if _nmesini4<=0
		_nmesini4+=12
		_nanoini4:=_nanoini6-1
	else
		_nanoini4:=_nanoini6
	endif
	_nmesfim4:=_nmesfim6-2
	if _nmesfim4<=0
		_nmesfim4+=12
		_nanofim4:=_nanofim6-1
	else
		_nanofim4:=_nanofim6
	endif
	_ddataini4:=ctod(strzero(_ndiaini,2)+"/"+strzero(_nmesini4,2)+"/"+strzero(_nanoini4,4))
	if _ndiafim==_nultdia
		_ddatafim4:=ctod(strzero(day(lastday(_ddataini4)),2)+"/"+strzero(_nmesfim4,2)+"/"+strzero(_nanofim4,4))
	else
		_ddatafim4:=ctod(strzero(_ndiafim,2)+"/"+strzero(_nmesfim4,2)+"/"+strzero(_nanofim4,4))
	endif

	_nmesini5:=_nmesini6-1
	if _nmesini5<=0
		_nmesini5+=12
		_nanoini5:=_nanoini6-1
	else
		_nanoini5:=_nanoini6
	endif
	_nmesfim5:=_nmesfim6-1
	if _nmesfim5<=0
		_nmesfim5+=12
		_nanofim5:=_nanofim6-1
	else
		_nanofim5:=_nanofim6
	endif
	_ddataini5:=ctod(strzero(_ndiaini,2)+"/"+strzero(_nmesini5,2)+"/"+strzero(_nanoini5,4))
	if _ndiafim==_nultdia
		_ddatafim5:=ctod(strzero(day(lastday(_ddataini5)),2)+"/"+strzero(_nmesfim5,2)+"/"+strzero(_nanofim5,4))
	else
		_ddatafim5:=ctod(strzero(_ndiafim,2)+"/"+strzero(_nmesfim5,2)+"/"+strzero(_nanofim5,4))
	endif
	_ddataini6:=mv_par01
	_ddatafim6:=mv_par02

	cabec1:="CODIGO LJ CLIENTE                                   "+;
		left(dtoc(_ddataini1),5)+" A "+left(dtoc(_ddatafim1),5)+"  "+;
		left(dtoc(_ddataini2),5)+" A "+left(dtoc(_ddatafim2),5)+"  "+;
		left(dtoc(_ddataini3),5)+" A "+left(dtoc(_ddatafim3),5)+"  "+;
		left(dtoc(_ddataini4),5)+" A "+left(dtoc(_ddatafim4),5)+"  "+;
		left(dtoc(_ddataini5),5)+" A "+left(dtoc(_ddatafim5),5)+"  "+;
		left(dtoc(_ddataini6),5)+" A "+left(dtoc(_ddatafim6),5)+;
		"          TOTAL          MEDIA % EST. % GER. PRAZO MEDIO"
	cabec2:=""

	_cfilsa1:=xfilial("SA1")
	_cfilse4:=xfilial("SE4")
	_cfilsb1:=xfilial("SB1")
	_cfilsf2:=xfilial("SF2")
	_cfilsf4:=xfilial("SF4")
	_cfilsa3:=xfilial("SA3")
	sa1->(dbsetorder(1))
	sb1->(dbsetorder(1))
	se4->(dbsetorder(1))
	sf2->(dbsetorder(1))
	sf4->(dbsetorder(1))
	sa3->(dbsetorder(1))

	_aestrut:={}
	aadd(_aestrut,{"ESTADO"   ,"C",02,0})
	aadd(_aestrut,{"CODIGO"   ,"C",06,0})
	aadd(_aestrut,{"LOJA"     ,"C",02,0})
	aadd(_aestrut,{"NOME"     ,"C",40,0})
	aadd(_aestrut,{"VALOR1"   ,"N",12,2})
	aadd(_aestrut,{"VALOR2"   ,"N",12,2})
	aadd(_aestrut,{"VALOR3"   ,"N",12,2})
	aadd(_aestrut,{"VALOR4"   ,"N",12,2})
	aadd(_aestrut,{"VALOR5"   ,"N",12,2})
	aadd(_aestrut,{"VALOR6"   ,"N",12,2})
	aadd(_aestrut,{"VALORT"   ,"N",12,2})
	aadd(_aestrut,{"PRAZOMED" ,"N",06,2})

	_cindsa1:=criatrab(,.f.)
	_cchave :="A1_FILIAL+A1_EST+A1_COD+A1_LOJA"
	sa1->(indregua("SA1",_cindsa1,_cchave))

	_cindsf2:=criatrab(,.f.)
	_cchave :="F2_FILIAL+F2_CLIENTE+F2_LOJA+DTOS(F2_EMISSAO)"
	_cfiltro:="F2_TIPO$'NC' .AND. F2_VALFAT>0"
	sf2->(indregua("SF2",_cindsf2,_cchave,,_cfiltro))

	_carqtmp1:=criatrab(_aestrut,.t.)
	dbusearea(.t.,,_carqtmp1,"TMP1",.f.)

	_cindtmp11:=criatrab(,.f.)
	_cchave   :="ESTADO+CODIGO+LOJA"
	tmp1->(indregua("TMP1",_cindtmp11,_cchave))

	_cindtmp12:=criatrab(,.f.)
	_cchave   :="ESTADO+NOME+CODIGO+LOJA"
	tmp1->(indregua("TMP1",_cindtmp12,_cchave))

	_cindtmp13:=criatrab(,.f.)
	_cchave   :="ESTADO+STRZERO(VALORT,12,2)+CODIGO+LOJA"
	tmp1->(indregua("TMP1",_cindtmp13,_cchave))

	tmp1->(dbclearind())
	tmp1->(dbsetindex(_cindtmp11))
	tmp1->(dbsetindex(_cindtmp12))
	tmp1->(dbsetindex(_cindtmp13))
	tmp1->(dbsetorder(1))

	_aest  :={}
	_ntotal:=0

// PESQUISA CODIGO DO SUPERVISOR
	sa3->(dbsetorder(7))
	if sa3->(dbseek(_cfilsa3+__cuserid))
		_cgerente:=sa3->a3_cod
	else
		_cgerente:=space(6)
	endif


	processa({|| _geratmp()})

	setregua(tmp1->(lastrec()))

	setprc(0,0)

	if nordem==1
		tmp1->(dbsetorder(2))
		tmp1->(dbgotop())
		_ccond:="! tmp1->(eof())"
	else
		tmp1->(dbsetorder(3))
		tmp1->(dbgobottom())
		_ccond:="! tmp1->(bof())"
	endif
	_nval1 := 0
	_nval2 := 0
	_nval3 := 0
	_nval4 := 0
	_nval5 := 0
	_nval6 := 0
	_nvalt := 0
	_tval1 := 0
	_tval2 := 0
	_tval3 := 0
	_tval4 := 0
	_tval5 := 0
	_tval6 := 0
	_tvalt := 0
	_mest := "  "
	while &_ccond .and.;
			lcontinua
		_limpcab:=.t.
		_cestado:=tmp1->estado
		_i:=ascan(_aest,{|x| x[1]==_cestado})
		_nvalore:=_aest[_i,2]
		while &_ccond .and.;
				tmp1->estado==_cestado .and.;
				lcontinua
			incregua()
			if if(mv_par05==2,tmp1->valort>0,.t.)
				if !empty(_nvalt) .and. _mest<> _cestado
					if mv_par08=1
						@ prow()+1,000   PSAY " TOTAL DO ESTADO"
					endif
					@ prow()  ,051   PSAY _nval1 picture "@E 999,999,999.99"
					@ prow()  ,066   PSAY _nval2 picture "@E 999,999,999.99"
					@ prow()  ,081   PSAY _nval3 picture "@E 999,999,999.99"
					@ prow()  ,096   PSAY _nval4 picture "@E 999,999,999.99"
					@ prow()  ,111   PSAY _nval5 picture "@E 999,999,999.99"
					@ prow()  ,126   PSAY _nval6 picture "@E 999,999,999.99"
					@ prow()  ,141   PSAY _nvalt picture "@E 999,999,999.99"
					@ prow()  ,156   PSAY round(_nvalt/6,2) picture "@E 999,999,999.99"
					_nval1 := 0
					_nval2 := 0
					_nval3 := 0
					_nval4 := 0
					_nval5 := 0
					_nval6 := 0
					_nvalt := 0
				endif
				if _limpcab .or. prow()>56
					if mv_par08=1
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
					endif
					@ prow()+1,000 PSAY "ESTADO: "+_cestado
					if mv_par08=1
						@ prow()+1,000 PSAY " "
					endif
					_limpcab:=.f.
					_mest := _cestado
				endif
				_nvalorm:=round(tmp1->valort/6,2)
				_npest  :=round((tmp1->valort/_nvalore)*100,2)
				_nptot  :=round((tmp1->valort/_ntotal)*100,2)
				if mv_par08=1
					@ prow()+1,000 PSAY tmp1->codigo
					@ prow(),007   PSAY tmp1->loja
					@ prow(),010   PSAY tmp1->nome
					@ prow(),051   PSAY tmp1->valor1 picture "@E 999,999,999.99"
					@ prow(),066   PSAY tmp1->valor2 picture "@E 999,999,999.99"
					@ prow(),081   PSAY tmp1->valor3 picture "@E 999,999,999.99"
					@ prow(),096   PSAY tmp1->valor4 picture "@E 999,999,999.99"
					@ prow(),111   PSAY tmp1->valor5 picture "@E 999,999,999.99"
					@ prow(),126   PSAY tmp1->valor6 picture "@E 999,999,999.99"
					@ prow(),141   PSAY tmp1->valort picture "@E 999,999,999.99"
					@ prow(),156   PSAY _nvalorm     picture "@E 999,999,999.99"
					@ prow(),171   PSAY _npest       picture "@E 999.99"
					if mv_par06==1
						@ prow(),178   PSAY _nptot       picture "@E 999.99"
					endif
					@ prow(),188   PSAY tmp1->prazomed picture "@E 999.99"
				endif
				_nval1 += tmp1->valor1
				_nval2 += tmp1->valor2
				_nval3 += tmp1->valor3
				_nval4 += tmp1->valor4
				_nval5 += tmp1->valor5
				_nval6 += tmp1->valor6
				_nvalt += tmp1->valort
			
				_tval1 += tmp1->valor1
				_tval2 += tmp1->valor2
				_tval3 += tmp1->valor3
				_tval4 += tmp1->valor4
				_tval5 += tmp1->valor5
				_tval6 += tmp1->valor6
				_tvalt += tmp1->valort
			
			endif
			if nordem==1
				tmp1->(dbskip())
			else
				tmp1->(dbskip(-1))
			endif
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				eject
				lcontinua:=.f.
			endif
		end
	end
	if !empty(_nvalt)
		if mv_par08=1
			@ prow()+1,000   PSAY " TOTAL DO ESTADO"
		endif
		@ prow()  ,051   PSAY _nval1 picture "@E 999,999,999.99"
		@ prow()  ,066   PSAY _nval2 picture "@E 999,999,999.99"
		@ prow()  ,081   PSAY _nval3 picture "@E 999,999,999.99"
		@ prow()  ,096   PSAY _nval4 picture "@E 999,999,999.99"
		@ prow()  ,111   PSAY _nval5 picture "@E 999,999,999.99"
		@ prow()  ,126   PSAY _nval6 picture "@E 999,999,999.99"
		@ prow()  ,141   PSAY _nvalt picture "@E 999,999,999.99"
		@ prow()  ,156   PSAY round(_nvalt/6,2) picture "@E 999,999,999.99"
		_nval1 := 0
		_nval2 := 0
		_nval3 := 0
		_nval4 := 0
		_nval5 := 0
		_nval6 := 0
		_nvalt := 0
	endif
	if !empty(_tvalt)
		@ prow()+1,000   PSAY " TOTAL GERAL"
		@ prow()  ,051   PSAY _tval1 picture "@E 999,999,999.99"
		@ prow()  ,066   PSAY _tval2 picture "@E 999,999,999.99"
		@ prow()  ,081   PSAY _tval3 picture "@E 999,999,999.99"
		@ prow()  ,096   PSAY _tval4 picture "@E 999,999,999.99"
		@ prow()  ,111   PSAY _tval5 picture "@E 999,999,999.99"
		@ prow()  ,126   PSAY _tval6 picture "@E 999,999,999.99"
		@ prow()  ,141   PSAY _tvalt picture "@E 999,999,999.99"
		@ prow()  ,156   PSAY round(_nvalt/6,2) picture "@E 999,999,999.99"
		_tval1 := 0
		_tval2 := 0
		_tval3 := 0
		_tval4 := 0
		_tval5 := 0
		_tval6 := 0
		_tvalt := 0
	endif
	if prow()>0 .and.;
			lcontinua
		roda(cbcont,cbtxt)
	endif

	_cindtmp11+=tmp1->(ordbagext())
	_cindtmp12+=tmp1->(ordbagext())
	_cindtmp13+=tmp1->(ordbagext())
	tmp1->(dbclosearea())
	ferase(_carqtmp1+getdbextension())
	ferase(_cindtmp11)
	ferase(_cindtmp12)
	ferase(_cindtmp13)

	_cindsa1+=sa1->(ordbagext())
	_cindsf2+=sf2->(ordbagext())

	sa1->(retindex("SA1"))
	sf2->(retindex("SF2"))

	ferase(_cindsa1)
	ferase(_cindsf2)
	set device to screen

	if areturn[5]==1
		set print to
		dbcommitall()
		ourspool(wnrel)
	endif
	ms_flush()
return

static function _geratmp()
	procregua(sa1->(lastrec()))
	sa1->(dbseek(_cfilsa1+mv_par03,.t.))
	while ! sa1->(eof()) .and.;
			sa1->a1_filial==_cfilsa1 .and.;
			sa1->a1_est<=mv_par04
	
		incproc("Calculando faturamento...")
		tmp1->(dbappend())
		tmp1->estado:=sa1->a1_est
		tmp1->codigo:=sa1->a1_cod
		tmp1->loja  :=sa1->a1_loja
		tmp1->nome  :=sa1->a1_nome
		_nvalor1    :=0
		_nvalor2    :=0
		_nvalor3    :=0
		_nvalor4    :=0
		_nvalor5    :=0
		_nvalor6    :=0
		_nprazo     :=0
		_nparcelas  :=0
		_cper := 0
		for _i:=1 to 6
			_cper:=strzero(_i,1)
			_dini:=_ddataini&_cper
			_dfim:=_ddatafim&_cper
			sf2->(dbseek(_cfilsf2+tmp1->codigo+tmp1->loja+dtos(_dini),.t.))

		// Valida Gerente Regional
			sa3->(dbsetorder(1))
			sa3->(dbseek(_cfilsa3+sf2->f2_vend1))
			_mger:=if(empty(_cgerente),.t.,if(_cgerente > "001000",sa3->a3_super==_cgerente,sa3->a3_cod==_cgerente)) // Valida Gerente Regional
			if _mger
			
				while !sf2->(eof()) .and.;
						sf2->f2_filial==_cfilsf2 .and.;
						sf2->f2_cliente==tmp1->codigo .and.;
						sf2->f2_loja==tmp1->loja .and.;
						sf2->f2_emissao<=_dfim
					_nvalor&_cper+=(sf2->f2_valfat-sf2->f2_icmsret)
				
					se4->(dbseek(_cfilse4+sf2->f2_cond))
					_ccond:=se4->e4_cond
					if se4->e4_solid=="S"
						_ccond:=substr(_ccond,at(",",_ccond)+1)
					endif
					while !empty(_ccond)
						_nprazo+=val(substr(_ccond,1,len(_ccond)-at(",",_ccond)))
						_nparcelas++
						if at(",",_ccond)==0
							_ccond:=""
						else
							_ccond:=substr(_ccond,at(",",_ccond)+1)
						endif
					end
					sf2->(dbskip())
				end
			endif
			tmp1->(fieldput(fieldpos("VALOR"+_cper),_nvalor&_cper))
		next

		tmp1->valort  :=tmp1->valor1+tmp1->valor2+tmp1->valor3+tmp1->valor4+tmp1->valor5+tmp1->valor6
		tmp1->prazomed:=round(_nprazo/_nparcelas,2)
		_i:=ascan(_aest,{|x| x[1]==sa1->a1_est})
		if _i==0
			aadd(_aest,{sa1->a1_est,tmp1->valort})
		else
			_aest[_i,2]+=tmp1->valort
		endif
		_ntotal+=tmp1->valort
	
		sa1->(dbskip())
	end
return

static function _pergsx1()
	_agrpsx1:={}
	aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"03","Do estado          ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"12 "})
	aadd(_agrpsx1,{cperg,"04","Ate o estado       ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"12 "})
	aadd(_agrpsx1,{cperg,"05","Clientes sem venda ?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"06","Imprime % geral    ?","mv_ch6","N",01,0,0,"C",space(60),"mv_par06"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"07","Grade              ?","mv_ch7","C",01,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"08","Tipo do relatorio  ?","mv_ch8","N",01,0,0,"C",space(60),"mv_par08"       ,"Analitico"      ,space(30),space(15),"Sintetico"      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
ESTADO: XX
CODIGO LJ CLIENTE                                   99/99 A 99/99  99/99 A 99/99  99/99 A 99/99  99/99 A 99/99  99/99 A 99/99  99/99 A 99/99          TOTAL          MEDIA % EST. % GER. PRAZO MEDIO
999999 99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.99 999.99    999,99
TOTAL DO ESTADO XX                                 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99        999.99
TOTAL GERAL                                        999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99        999.99
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ vit108   ³ Autor ³ Gardenia              ³ Data ³ 18/09/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Fretes de Saida / Fatura                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
Variaveis utilizadas para parametros
mv_par01 Da Fatura
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit108()
	nordem   :=""
	tamanho  :="G"
	limite   :=200
	titulo   :="FRETES DE SAIDA / FATURA "
	cdesc1   :="Este programa ira emitir o relatorio de conhecimentos de frete   "
	cdesc2   :="de uma fatura"
	cdesc3   :=""
	cstring  :="SF2"
	areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
	nomeprog :="VIT108"
	wnrel    :="VIT108"+Alltrim(cusername)
	alinha   :={}
	nlastkey :=0
	cbcont   :=0
	m_pag    :=1
	li       :=200
	cbtxt    :=space(10)
	lcontinua:=.t.

	cperg:="PERGVIT108"
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
	_cfilsa1:=xfilial("SA1")
	_cfilsa2:=xfilial("SA2")
	_cfilsf2:=xfilial("SF2")
	_cfilsa4:=xfilial("SA4")
	_cfilszb:=xfilial("SZB")
	sa1->(dbsetorder(1))
	sa2->(dbsetorder(3))
	sa4->(dbsetorder(1))
	sf2->(dbsetorder(1))
	szb->(dbsetorder(1))

	processa({|| _querys()})

	sa4->(dbseek(_cfilsa4+mv_par02))
	_cgctransp:=sa4->a4_cgc

	sa2->(dbseek(_cfilsa2+_cgctransp))
	_codtransp:=sa2->a2_cod

	cabec1:="Fatura/Transp. : "+mv_par01 + " / "+mv_par02+"-"+substr(sa4->a4_nome,1,25)  +"   Venc.:"+dtoc(mv_par03)
//cabec2:="Conhec    Ser Cliente                                          Emissao  No. NF    Ser       Peso Volume  Valor Nota  Vl.Conhec.    Desconto  ICMS frete   Perc.    Frt.Prev       Difer.    Observacoes"
	cabec2:="Conhec  Ser Cliente                                          Emissao  No. NF    Ser Peso Bruto Peso Frete Volume  Valor Nota  Vl.Conhec.    Desconto  ICMS frete   Perc.    Frt.Prev       Difer.    Observacoes"
//Conhec  Ser Cliente                                          Emissao  No. NF    Ser Peso Bruto Peso Frete Volume  Valor Nota  Vl.Conhec.    Desconto  ICMS frete   Perc.    Frt.Prev       Difer.  Obs
//999999  999 999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99 999999999 999 999.999.99 999.999.99 999999  999.999,99  999.999,99  999.999,99  999.999,99  999,99  999.999,99   999.999,99  xxxxxxxxxxxxxxxxxxxxxxxxxx

	setprc(0,0)

	tmp1->(dbgotop())
	_total:=0
	_totfrete:=0
	_tdescfr:=0
	_totdescfr:=0
	_toticmsfr:=0
	_tdifer:=0
	while ! tmp1->(eof()) .and.;
			lcontinua
		if prow()==0 .or. prow()>55
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif

		sa2->(dbsetorder(1))

		if tmp1->tipo$"BD"
			sa2->(dbseek(_cfilsa2+tmp1->cliente+tmp1->loja))
			_local:=sa2->a2_local
			_uf:=sa2->a2_est
			_nome:=sa2->a2_nome
			_suframa:=  ' '
		else
			sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
			_local:=sa1->a1_local
			_uf:=sa1->a1_est
			_suframa:=sa1->a1_suframa
			_nome:=sa1->a1_nome
		endif
	
		_numfret:=tmp1->numfret
		_serfret:=tmp1->serfret
		@ prow()+1,000 PSAY tmp1->numfret
		@ prow(),008 PSAY tmp1->serfret
		_passou :=.t.
		_tnota:=0
		_tconhe:=0
		_tdescfr:=0
		_tpeso:=0
		_icmsfr := 0
		_x:=0
		_z:=0

		while ! tmp1->(eof()) .and. _numfret == tmp1->numfret .and. _serfret == tmp1->serfret .and.;
				lcontinua
			if _passou
				@ prow(),012 PSAY tmp1->cliente
				_passou :=.f.
			else
				@ prow()+1,012 PSAY tmp1->cliente
			endif

			@ prow(),019 PSAY _nome
			@ prow(),061 PSAY tmp1->emissao
			@ prow(),070 PSAY tmp1->doc
			@ prow(),080 PSAY tmp1->serie
			@ prow(),084 PSAY tmp1->pbruto picture "@E 999,999.99"
			@ prow(),095 PSAY tmp1->pfrete picture "@E 999,999.99"
			@ prow(),106 PSAY tmp1->volume1 picture "@E 999999"
			@ prow(),114 PSAY tmp1->valbrut picture "@E 999,999.99"
			@ prow(),126 PSAY tmp1->vlfrete picture "@E 999,999.99"
//		_tpeso+=tmp1->pbruto
			_tpeso+=tmp1->pfrete
			_descfr:=tmp1->descfr
			_icmsfr+=tmp1->icmsfr
			_total+=tmp1->valbrut
			_totfrete+=tmp1->vlfrete
			_totdescfr+=tmp1->descfr
			_toticmsfr+=tmp1->icmsfr
		
			_tnota+=tmp1->valbrut
			_tconhe+=tmp1->vlfrete
			_tdescfr+=tmp1->descfr
		
			_obsfr:=tmp1->obsfr
			tmp1->(dbskip())
			if prow()==0 .or. prow()>55
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
				@ prow()+1,00 psay ""
			endif
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				lcontinua:=.f.
			endif
		end
		_txsuframa:=0
		if !empty(_suframa) .or. _uf=="AM"
			_txsuframa:= 22  // criado para teste
		endif
	
		szb->(dbseek(_cfilszb+_codtransp+_uf+"S"+_local))
		_aliqicm:=0

		if ((_tpeso < szb->zb_fretmax) .or. (szb->zb_fretmax=0)) .and. (szb->zb_tpcalc=="2")				// Cálculo sobre a Nota com peso menor que o Peso Máximo: Percentual
			_x:= (_tnota*szb->zb_advalor/100)

		elseif ((_tpeso > szb->zb_fretmax) .and. (szb->zb_tpcalc=="2")) .or.;   // Cálculo sobre a Nota com peso maior que Peso Máximo: Peso
			(szb->zb_tpcalc=="1")   											// Cálculo sobre o Peso: Peso
			_x:= szb->zb_fretpes* _tpeso

		elseif szb->zb_tpcalc == "3"											// Cálculo sobre o Peso e a Nota (Ambos): Percentual + Peso
			_x:= (_tnota*szb->zb_advalor/100)
			_x:=_x+ szb->zb_fretpes* _tpeso
		endif

		_qtdped:=int(_tpeso/100)
		if (_tpeso/100)-_qtdped > 0
			_qtdped+=1
		endif

		_z:= _x		 							// Total do frete
	
		_aliqicm:= (100-szb->zb_aliqicm)/100 	// Alíquota do ICMS

		_peso:=.f.
		_x:= _z/_tpeso
		if _x < szb->zb_vlrmin					// Verifica se o Valor por Peso é menor que o Peso Mínimo
			_z:= szb->zb_vlrmin*_tpeso
			_peso:=.t.
		endif
	
		if _z < szb->zb_fretmin 				// Verifica se o Valor do Frete é menor que o Preço Mínimo
			_z:= szb->zb_fretmin
			_peso:=.f.
		endif
	
		if !_peso
			if _tnota*szb->zb_gris/100 < szb->zb_grismin
				_gris:=szb->zb_grismin
			else
				_gris:= (_tnota*szb->zb_gris/100)
			endif
			_z:=_z + _gris

			_z:= _z + szb->zb_txdocto							// Aplica a cobrança da Taxa do Documento
		endif
		
		_z:= _z + szb->zb_txporto + (szb->zb_pedagio*_qtdped)	// Aplica Cobrança de Pedágio

		_z:= _z + _txsuframa								// Aplica a cobrança da Taxa do Suframa
	
		_z:=_z/_aliqicm										// Aplica alíquota do ICMS

//Conhec  Ser Cliente                                          Emissao  No. NF    Ser Peso Bruto Peso Frete Volume  Valor Nota  Vl.Conhec.    Desconto  ICMS frete   Perc.    Frt.Prev       Difer.  Obs
//999999  999 999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99 999999999 999 999.999.99 999.999.99 999999  999.999,99  999.999,99  x99.999,99  999.999,99  999,99  999.999,99   999.999,99  xxxxxxxxxxxxxxxxxxxxxxxxxx

		@ prow(),138 PSAY _descfr picture "@E 999,999.99"
		@ prow(),150 PSAY _icmsfr picture "@E 999,999.99"
		@ prow(),162 PSAY ((_tconhe-_tdescfr-_icmsfr)/_tnota)*100 picture "@E 999.99"
		@ prow(),170 PSAY _z picture "@E 999,999.99"
		@ prow(),183 PSAY (_tconhe-_descfr)-_z picture "@E 999,999.99"
		@ prow(),195 PSAY substr(_obsfr,1,26)
		_tdifer+=(_tconhe-_descfr)-_z
	end

	if lcontinua .and. !empty(_total)
		@ prow()+1,000 PSAY "TOTAL DIFERENCA           ========================>"
		@ prow(),183   PSAY _tdifer picture "@E 999,999.99"
		@ prow()+2,000 PSAY "DESCONTO FATURA           ========================>"
		@ prow(),138   PSAY mv_par06 picture "@E 999,999.99"
		@ prow()+2,000 PSAY "SOMA DOS CONHECIMENTOS (1)========================>"
		@ prow(),114   PSAY _total picture "@E 999,999.99"
		@ prow(),126   PSAY _totfrete picture "@E 999,999.99"
		@ prow(),138   PSAY _totdescfr+mv_par06 picture "@E 999,999.99"
		@ prow(),150   PSAY _toticmsfr picture "@E 999,999.99"
		@ prow(),162   PSAY ((_totfrete-_totdescfr-_toticmsfr-mv_par06)/_total)*100 picture "@E 999.99"
		@ prow()+2,000 PSAY "DESPESA BANCARIA (2)==============================>"
		@ prow(),114   PSAY mv_par05  picture "@E 999,999.99"
		@ prow()+2,000 PSAY "VALOR INFORMADO FATURA (3) =======================>"
		@ prow(),114   PSAY mv_par04  picture "@E 999,999.99"
		@ prow()+2,000 PSAY "DIF. VALOR CALCULADO X SOMA CONHECIMENTOS (1+2)-3 >"
		@ prow(),114  PSAY (mv_par04-(_totfrete+mv_par05))-mv_par06 picture "@E 999,999.99"
	endif

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
	_cquery+=" F2_DOC DOC,F2_CLIENTE CLIENTE,F2_LOJA LOJA,F2_VALBRUT VALBRUT,F2_NUMFRET NUMFRET,F2_SERIE SERIE,"
	_cquery+=" F2_SERFRET SERFRET,F2_EMISSAO EMISSAO,F2_VLFRETE VLFRETE,F2_VOLUME1 VOLUME1,F2_PBRUTO PBRUTO,F2_PESFRET PFRETE,"
	_cquery+=" F2_DESCFR DESCFR,F2_DESCPG,F2_ICMSFR ICMSFR,F2_OBSFR OBSFR,F2_TRANSP TRANSP,F2_TIPO TIPO"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SF2")+" SF2"
	_cquery+=" WHERE"
	_cquery+="     SF2.D_E_L_E_T_<>'*'"
	_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
	_cquery+=" AND F2_FATURA = '"+mv_par01+"'"
	_cquery+=" AND F2_TRANSP = '"+mv_par02+"'"
	_cquery+=" ORDER BY F2_NUMFRET, F2_DOC"

	_cquery:=changequery(_cquery)

	tcquery _cquery new alias "TMP1"
	tcsetfield("TMP1","EMISSAO","D")
	tcsetfield("TMP1","VALBRUT"  ,"N",15,2)
	tcsetfield("TMP1","VLFRETE"  ,"N",15,2)
	tcsetfield("TMP1","VOLUME1"  ,"N",15,0)
	tcsetfield("TMP1","PBRUTO"  ,"N",15,2)
	tcsetfield("TMP1","PFRETE"  ,"N",15,2)
	tcsetfield("TMP1","DESCFR"  ,"N",15,2)
return



static function _pergsx1()
	_agrpsx1:={}

	aadd(_agrpsx1,{cperg,"01","Da Fatura          ?","mv_ch1","C",10,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"02","Da Transportadora  ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
	aadd(_agrpsx1,{cperg,"03","Vencimento         ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"04","Valor Fatura       ?","mv_ch4","N",15,2,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"05","Despesa Bancaria   ?","mv_ch5","N",15,2,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	aadd(_agrpsx1,{cperg,"06","Desconto           ?","mv_ch6","N",15,2,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

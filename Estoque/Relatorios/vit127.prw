/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT127   ³ Autor ³ Gardenia              ³ Data ³ 25/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Fretes de Entrada / Fatura                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
Variaveis utilizadas para parametros
mv_par01 Da Fatura
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT127()

nordem   :=""
tamanho  :="G"
limite   :=132
titulo   :="FRETES DE COMPRA "
cdesc1   :="Este programa ira emitir o relatorio de conhecimentos de frete   "
cdesc2   :=" "
cdesc3   :=""
cstring  :="SF8"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT127"
wnrel    :="VIT127"+Alltrim(cusername)
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

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)
nordem:=areturn[8]

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
_cfilsa1:=xfilial("SA1")
_cfilsf8:=xfilial("SF8")
_cfilsa4:=xfilial("SA4")
_cfilse2:=xfilial("SE2")
_cfilszb:=xfilial("SZB")
sf1->(dbsetorder(1))
sd1->(dbsetorder(1))
sa2->(dbsetorder(1))
sa1->(dbsetorder(1))
sa4->(dbsetorder(1))
sf8->(dbsetorder(2))
se2->(dbsetorder(1))
szb->(dbsetorder(1))


processa({|| _querys()})

sa2->(dbseek(_cfilsa2+mv_par03))
cabec1:="Transp. : "+mv_par03 +"-"+sa2->a2_nome + "  período: "+dtoc(mv_par04)+ " a "+dtoc(mv_par05) + "     Venc.: "+dtoc(mv_par06)
cabec2:="Conhec    Ser Fornecedor                                       Emissao  No.Nota     Ser    Volume       Peso    Valor Nota    Vl.Conhec.   Desconto  ICMS Frete      %  Fatura        Baixa Fat   Vlr.Sim.  Diferenca"
//Conhec    Ser Fornecedor                                       Emissao  No.Nota    Ser     Volume       Peso    Valor Nota    Vl.Conhec.   Desconto  ICMS Frete      %  Fatura        Baixa Fat   Vlr.Sim. Diferenca
//999999999 999 999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99 999999999  999 999.999,99 999.999,99 99.999.999,99 99.999.999,99 999.999,99  999.999,99 999,99  999-999999999 99/99/99  999,999.99 999.999,99

setprc(0,0)

tmp1->(dbgotop())
_totnota:=0
_totfrete:=0
_toticm:=0
_totdesc:=0
_totvol:=0
_totpeso:=0
while ! tmp1->(eof()) .and.;
	lcontinua
	
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	
	sa2->(dbseek(_cfilsa2+tmp1->fornece))
	sa1->(dbseek(_cfilsa1+tmp1->fornece))
	
	_nfdifre:=tmp1->nfdifre
	_sedifre:=tmp1->sedifre
	_nforig:=tmp1->nforig
	_serorig:=tmp1->serorig
	_transp:=tmp1->transp
	_lojtran:=tmp1->lojtran
	_fornece:=tmp1->fornece
	_loja:=tmp1->loja
	
	_totnf:=0
	_tpeso:=0

	sf1->(dbseek(_cfilsf1+_nforig+_serorig+_fornece+_loja))
	_tiponf:= sf1->f1_tipo

	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	
	sf1->(dbseek(_cfilsf1+tmp1->nfdifre+tmp1->sedifre+tmp1->transp+tmp1->lojtran))
	se2->(dbseek(_cfilse2+tmp1->sedifre+tmp1->nfdifre))
	
	if tmp1->sedifre== se2->e2_prefixo .and. tmp1->nfdifre == se2->e2_num .and. tmp1->transp == se2->e2_fornece
		_prefat:= se2->e2_fatpref
		_fatura := se2->e2_fatura
	else
		_prefat:= '   '
		_fatura := '      '
	endif
	
	se2->(dbseek(_cfilse2+_prefat+_fatura))
	
	if _prefat == se2->e2_prefixo .and. _fatura == se2->e2_num .and. tmp1->transp == se2->e2_fornece
		_baixa:= se2->e2_baixa
	else
		_baixa:= ctod("  /  /  ")
	endif
	
	_icm:=sf1->f1_valicm
	@ prow()+1,000 PSAY _nfdifre
	@ prow()  ,011 PSAY _sedifre
	_passou :=.f.
	
	while ! tmp1->(eof()) .and.;
		lcontinua .and. _nfdifre==tmp1->nfdifre  .and. _sedifre==tmp1->sedifre
		
		sd1->(dbseek(_cfilsd1+tmp1->nforig+tmp1->serorig+tmp1->fornece+tmp1->loja))
		_volume:=0
		_peso:=0
		
		while ! sd1->(eof()) .and. tmp1->nforig==sd1->d1_doc .and.;
			tmp1->serorig==sd1->d1_serie .and. tmp1->fornece==sd1->d1_fornece

			_volume+=sd1->d1_numvol
			_peso+=sd1->d1_peso
			sd1->(dbskip())
		end
		sf1->(dbseek(_cfilsf1+tmp1->nforig+tmp1->serorig+tmp1->fornece+tmp1->loja))
		
//Conhec    Ser Fornecedor                                       Emissao  No.Nota    Ser     Volume       Peso    Valor Nota    Vl.Conhec.   Desconto  ICMS Frete      %  Fatura        Baixa Fat   Vlr.Sim. Diferenca
//999999999 999 999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99 999999999  999 999.999,99 999.999,99 99.999.999,99 99.999.999,99 999.999,99  999.999,99 999,99  999-999999999 99/99/99  999,999.99 999.999,99
		
		if alltrim(_tiponf)=="D"
			if !_passou
				@ prow(),015 PSAY sa1->a1_cod
				_passou :=.t.
			else
				@ prow()+1,015 PSAY sa1->a1_cod
			endif
			@ prow(),022 PSAY sa1->a1_nome
		else
			if !_passou
				@ prow(),015 PSAY sa2->a2_cod
				_passou :=.t.
			else
				@ prow()+1,015 PSAY sa2->a2_cod
			endif
			@ prow(),022 PSAY sa2->a2_nome
		endif
		@ prow(),063 PSAY sf1->f1_emissao
		@ prow(),072 PSAY tmp1->nforig
		@ prow(),084 PSAY tmp1->serorig
		@ prow(),087 PSAY _volume picture "@E 999,999.99"
		@ prow(),098 PSAY _peso picture "@E 999,999.99"
		@ prow(),109 PSAY sf1->f1_valbrut picture "@E 99,999,999.99"

		_valnota:=sf1->f1_valbrut
		_totnota+=sf1->f1_valbrut
		_totnf+=sf1->f1_valbrut
		_totvol+=_volume
		_totpeso+=_peso
		_tpeso+=_peso

		tmp1->(dbskip())
	end

	sf1->(dbseek(_cfilsf1+_nfdifre+_sedifre+_transp+_lojtran))
	@ prow(),123 PSAY sf1->f1_valbrut picture "@E 99,999,999.99"
	@ prow(),137 PSAY sf1->f1_descont picture "@E 999,999.99"
	@ prow(),149 PSAY sf1->f1_valicm picture "@E 999,999.99"
	
	_valfrete:=sf1->f1_valbrut
	_totfrete+=sf1->f1_valbrut
	_toticm+=sf1->f1_valicm
	_totdesc+=sf1->f1_descont

	@ prow(),160 PSAY ((_valfrete-sf1->f1_valicm)/_totnf)*100 picture "@E 999.99"

	if !empty(_prefat)
		@ prow(),168 PSAY _prefat+"-"+_fatura
	endif

	if !empty(_baixa)
		@ prow(),182 PSAY _baixa
	endif
	_x:=0
	_y:=0
	_z:=0
	
	_aliqicm:=0
	if alltrim(_tiponf)=="D"
		sa1->(dbseek(_cfilsa1+_fornece+_loja))
		_local:=sa1->a1_local
		_uf:=sa1->a1_est
		szb->(dbseek(_cfilszb+mv_par03+_uf+"S"+_local))
	else
		sa2->(dbseek(_cfilsa2+_fornece+_loja))
		_local:=sa2->a2_local
		_uf:=sa2->a2_est
		szb->(dbseek(_cfilszb+mv_par03+_uf+"E"+_local))
	endif
	
	if ((_tpeso < szb->zb_fretmax) .or. (szb->zb_fretmax=0)) .and. (szb->zb_tpcalc=="2")				// Cálculo sobre a Nota com peso menor que o Peso Máximo: Percentual
		_x:= (_totnf*szb->zb_advalor/100)

	elseif ((_tpeso > szb->zb_fretmax) .and. (szb->zb_tpcalc=="2")) .or.;   // Cálculo sobre a Nota com peso maior que Peso Máximo: Peso
		   (szb->zb_tpcalc=="1")   											// Cálculo sobre o Peso: Peso
		_x:= szb->zb_fretpes* _tpeso

	elseif szb->zb_tpcalc == "3"											// Cálculo sobre o Peso e a Nota (Ambos): Percentual + Peso
		_x:= (_totnf*szb->zb_advalor/100)
		_x:=_x+ szb->zb_fretpes* _tpeso
	endif

	_qtdped:=int(_tpeso/100)
	if (_tpeso/100)-_qtdped > 0
		_qtdped+=1
	endif

	_z:= _x		 							// Total do frete
	
	_aliqicm:= (100-szb->zb_aliqicm)/100 	// Alíquota do ICMS

	_peso:=.f.	  
	_x:= _z/_tpeso 							// Verifica se o Valor por Peso é menor que o Peso Mínimo
	if _x < szb->zb_vlrmin	
		_z:= szb->zb_vlrmin*_tpeso
		_peso:=.t.
	endif
	
	if _z < szb->zb_fretmin 				// Verifica se o Valor do Frete é menor que o Preço Mínimo
		_z:= szb->zb_fretmin
		_peso:=.f.
	endif
	
	if !_peso
		if _totnf*szb->zb_gris/100 < szb->zb_grismin
			_gris:=szb->zb_grismin
		else
			_gris:= (_totnf*szb->zb_gris/100)
		endif
		_z:=_z + _gris

		_z:= _z + szb->zb_txdocto				// Aplica a cobrança da Taxa do Documento	
	endif

	_z:=_z+szb->zb_txporto +(szb->zb_pedagio*_qtdped)	// Aplica Cobrança de Pedágio 

	_z:=_z/_aliqicm							// Aplica alíquota do ICMS


//Conhec    Ser Fornecedor                                       Emissao  No.Nota    Ser     Volume       Peso    Valor Nota    Vl.Conhec.   Desconto  ICMS Frete      %  Fatura        Baixa Fat   Vlr.Sim. Diferenca
//999999999 999 999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99 999999999  999 999.999,99 999.999,99 99.999.999,99 99.999.999,99 999.999,99  999.999,99 999,99  999-999999999 99/99/99  999,999.99 999.999,99

	@ prow(),192 PSAY _z picture "@E 999,999.99"
	
	@ prow(),203 PSAY _valfrete-_z picture "@E 999,999.99"
	
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end
if lcontinua .and. !empty(_totnota)
	@ prow()+2,000 PSAY "DESCONTO FATURA  ============>"
	@ prow(),137 PSAY mv_par07 picture "@E 999,999.99"
	@ prow()+1,000 PSAY "TOTAIS      =================>"
	@ prow(),087 PSAY _totvol picture "@E 999,999.99"
	@ prow(),098 PSAY _totpeso picture "@E 999,999.99"
	@ prow(),109 PSAY _totnota picture "@E 99,999,999.99"
	@ prow(),123 PSAY _totfrete picture "@E 99,999,999.99"
	@ prow(),137 PSAY _totdesc+mv_par07 picture "@E 999,999.99"
	@ prow(),149 PSAY _toticm picture "@E 999,999.99"
	@ prow(),160 PSAY ((_totfrete-_toticm-mv_par07)/_totnota)*100 picture "@E 999.99"
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

//Utilização do Filtro
#IFDEF TOP
	IF !Empty(aReturn[7])   // Coloca expressao do filtro
		_filtro := aReturn[7]
		_filtro := STRTRAN (_filtro,".And."," AND " )
		_filtro := STRTRAN (_filtro,".and."," AND " )
		_filtro := STRTRAN (_filtro,".Or."," OR ")
		_filtro := STRTRAN (_filtro,".or."," OR ")
		_filtro := STRTRAN (_filtro,"=="," = ")
		_filtro := STRTRAN (_filtro,'"',"'")
		_filtro := STRTRAN (_filtro,'Alltrim',"LTRIM")
		_filtro := STRTRAN (_filtro,'$',"LIKE")
		_cquery+=" AND ("+_filtro+")"
	Endif
#ENDIF

#IFNDEF TOP
	IF !Empty(aReturn[7])   // Coloca expressao do filtro
		Set Filter to &( aReturn[7] )
	Endif
#ENDIF

_cquery+=" ORDER BY F8_NFDIFRE"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DTDIGIT","D")
//tcsetfield("TMP1","VALBRUT"  ,"N",15,2)
return

static function _pergsx1()
_agrpsx1:={}

aadd(_agrpsx1,{cperg,"01","Do Conhecimento    ?","mv_ch1","C",09,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o Conhecimento ?","mv_ch2","C",09,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da Transportadora  ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
aadd(_agrpsx1,{cperg,"04","Da Dt. Digitacao   ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Ate a Dt. Digitacao?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Vencimento         ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Desconto           ?","mv_ch5","N",15,2,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

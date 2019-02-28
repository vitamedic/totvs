/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT049  ³ Autor ³ Heraildo C. de Freitas³ Data ³ 03/04/02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄ´±±
±±³Descricao ³ Resumo de Resultados / Lucro         Alteração : 04/09/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit049()
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="RESUMO DE RESULTADOS / LUCRO"
cdesc1   :="Este programa ira emitir o resumo de resultados / lucro"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
//aordem  :={"Alfabetica","Ranking"}

nomeprog :="VIT049"
wnrel    :="VIT049"+Alltrim(cusername)
//aordem  :={"Alfabetica","Farma/Hospitalar"}
aordem  :={}
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT049"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)
if mv_par04="2"
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
	if mv_par04="2"
		tcquit()
	endif
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)
nordem:=areturn[8]
if nlastkey==27
	set filter to
	if mv_par04="2"
		tcquit()
	endif
	return
endif
rptstatus({|| rptdetail()})
return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)
titulo:="RESUMO DE RESULTADOS - PERIODO DE "+;
dtoc(mv_par01)+" A "+dtoc(mv_par02)+" ("+;
if(mv_par03==1,"PRECO MEDIO",if(mv_par03==2,"ULTIMO PRECO","MAIOR CUSTO"))+")"

//cabec1:="Codigo Descricao                                Qtd. Fat.          Custo         c/ 10%      Valor 3o.           Soma  Cst fabr    Pr. ABC   N/P  Custo Vd.  Cst. tt. % Lucro      Vlr. fat.       Lucro R$"
cabec1:="Codigo Descricao                                       Insumos         Terc. Indice%     CST.FAB       CST.TOT     TAB.17%   PR.ABC MARGEM CONTR. %MARGEM   QTDE.FAT      VLR.FAT      VL.RESULT.   %ITEM  %.ACUM."
//                                                     999.999.999.99
cabec2:="Tabela Linha Farma :"+ mv_par05 +"         Tabela Linha Hospitalar :"+mv_par06

_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsd2:=xfilial("SD2")
_cfilsf4:=xfilial("SF4")
_cfilsg1:=xfilial("SG1")
_cfilda0:=xfilial("DA0")
_cfilda1:=xfilial("DA1")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sd2->(dbsetorder(1))
sf4->(dbsetorder(1))
sg1->(dbsetorder(1))
da1->(dbsetorder(2))
da0->(dbsetorder(1))

_cindsd2:=criatrab(,.f.)
_cchave :="D2_FILIAL+D2_COD+DTOS(D2_EMISSAO)"
_cfiltro:="D2_EMISSAO>=MV_PAR01 .AND. D2_EMISSAO<=MV_PAR02"
sd2->(indregua("SD2",_cindsd2,_cchave,,_cfiltro,"Selecionando registros..."))
if mv_par04="2"
	_abretop("SB1010",1)
	_abretop("SB2010",1)
	_abretop("SG1010",1)
endif
_ntqtdfat:=0
_ntvalfat:=0
_ntvalluc:=0
_acom    :={}
processa({|| _geratmp()})

setprc(0,0)

setregua(sb1->(lastrec()))
_nprabc :=0
_nnp    :=0
_nprabc :=0
_nnp    :=0
_n8 := 0
_n9 := 0
_n12 := 0
_n5 := 0
_nresult :=0
if mv_par04="2"
	tmp1->(dbgotop())
	while ! tmp1->(eof()) .and.;
		lcontinua
		incregua()
		// QUANTIDADE FATURADA
		_cquery:=" SELECT"
		_cquery+=" SUM(D2_QUANT) QUANT,SUM(D2_TOTAL) VALOR"
		_cquery+=" FROM "
		_cquery+=" SD2010 SD2,"
		_cquery+=" SF4010 SF4"
		_cquery+=" WHERE"
		_cquery+="     SD2.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND D2_COD='"+tmp1->produto+"'"
		_cquery+=" AND D2_TES=F4_CODIGO"
		_cquery+=" AND F4_DUPLIC='S'"
		_cquery+=" AND F4_ESTOQUE= 'S'"
		_cquery+=" AND D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
		
		//	_cquery+=" AND F4_ESTOQUE='S'" // retirado por causa do fat. da Pro-diet SP e DF ainda esta sendo
		//	 avaliado 13/07/04,
		// Retorno em 30/06/06 faturamento da Vilamed.
		
		
		tcquery _cquery new alias "TMP2"
		tcsetfield("TMP2","QUANT","N",07,0)
		tcsetfield("TMP2","VALOR","N",12,2)
		
		tmp2->(dbgotop())
		_nqtdfat:=tmp2->quant
		_nvalfat:=tmp2->valor
		tmp2->(dbclosearea())
		
		sd2->(dbseek(_cfilsd2+tmp1->produto))
		while ! sd2->(eof()) .and.;
			sd2->d2_filial==_cfilsd2 .and.;
			sd2->d2_cod==tmp1->produto
			sf4->(dbseek(_cfilsf4+sd2->d2_tes))
			if sf4->f4_duplic=="S" // .and.;
				//			sf4->f4_estoque=="S"
				_nqtdfat+=sd2->d2_quant
				_nvalfat+=sd2->d2_total
			endif
			sd2->(dbskip())
		end
		if _nqtdfat>0
			_ncusto:=0
			_calccus(tmp1->produto,tmp1->qb,_nqtdfat)
			sb1010->(dbseek(_cfilsb1+tmp1->produto))
			_nvalterc := sb1010->b1_valterc
			_ncusto:= _ncusto / _nqtdfat

			if sb1->b1_apreven ="1"
				da1->(dbseek(_cfilda0+tmp1->produto+mv_par05))
				_nprfab := da1->da1_prcven
			else
				da1->(dbseek(_cfilda0+tmp1->produto+mv_par06))
				_nprfab := da1->da1_prcven
			endif
			_nprabc   :=round(_nvalfat/_nqtdfat,2)
			_nnp      :=sb1->b1_percnp /100
			_n5 := (_nnp * _nprabc)+_ncusto
			_n8 := _nprabc - _n5
			_n9 := round((_n8/_nprabc)*100,2) // % margem
			_n12 := (_nvalfat*_n9 )/100
			_nresult += _n12
			aadd(_acom,{_ncusto,_nvalterc,_nnp,,_n5,_nprfab,_nprabc,;
					_n8,_n9,_nqtdfat,_nvalfat,_n12,tmp1->produto,tmp1->descricao})		
			
		endif
		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
	end
else
	tmp1->(dbgotop())
	while ! tmp1->(eof()) .and.;
		lcontinua
		incregua()
		// QUANTIDADE FATURADA
		_cquery:=" SELECT"
		_cquery+=" SUM(D2_QUANT) QUANT,SUM(D2_TOTAL) VALOR"
		_cquery+=" FROM "
		_cquery+=" SD2010 SD2,"
		_cquery+=" SF4010 SF4"
		_cquery+=" WHERE"
		_cquery+="     SD2.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND D2_COD='"+tmp1->produto+"'"
		_cquery+=" AND D2_TES=F4_CODIGO"
		_cquery+=" AND F4_DUPLIC='S'"
		_cquery+=" AND D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
		
		//	_cquery+=" AND F4_ESTOQUE='S'" // retirado por causa do fat. da Pro-diet SP e DF ainda esta sendo
		//	 avaliado 13/07/04		

		tcquery _cquery new alias "TMP2"
		tcsetfield("TMP2","QUANT","N",07,0)
		tcsetfield("TMP2","VALOR","N",12,2)
		tmp2->(dbgotop())
		_nqtdfat:=tmp2->quant
		_nvalfat:=tmp2->valor
		tmp2->(dbclosearea())
		if _nqtdfat>0
			_ncusto:=0
			_calccus2(tmp1->produto,tmp1->qb,_nqtdfat)
			_ncusto:= _ncusto / _nqtdfat
			sb1->(dbseek(_cfilsb1+tmp1->produto))
			
			//
			_nvalterc :=sb1->b1_valterc
			if sb1->b1_apreven ="1"
				da1->(dbseek(_cfilda0+tmp1->produto+mv_par05))
				_nprfab := da1->da1_prcven
			else
				da1->(dbseek(_cfilda0+tmp1->produto+mv_par06))
				_nprfab := da1->da1_prcven
			endif
			_nprabc   :=round(_nvalfat/_nqtdfat,2)
			_nnp      :=sb1->b1_percnp /100
			_n5 := (_nnp * _nprabc)+_ncusto+_nvalterc
			_n8 := _nprabc - _n5
			_n9 := round((_n8/_nprabc)*100,2) // % margem
			_n12 := (_nvalfat*_n9 )/100
			_nresult += _n12
			aadd(_acom,{_ncusto,_nvalterc,_nnp,,_n5,_nprfab,_nprabc,;
					_n8,_n9,_nqtdfat,_nvalfat,_n12,tmp1->produto,tmp1->descricao})			
		endif
		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
		
	end
end
//
//if nordem==2
	_acoms:= asort(_acom,,,{|x,y| x[14]<y[14]})
/*else
	_acoms := asort(_acom,,,{|x,y| x[11]<y[11]})
endif*/
_nacum:=0
_ntot := 0
_ntqtde := 0
_ntres := 0

for _i:=1 to len(_acoms)
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	 _nacum += _acoms[_i,12]/_nresult
	@ prow()+1,000 PSAY left(_acoms[_i,13],6)
	@ prow(),007   PSAY left(_acoms[_i,14],40)
	@ prow(),048   PSAY _acoms[_i,1] picture "@E 999,999.9999" // 1 INSUMOS
	@ prow(),062   PSAY _acoms[_i,2] picture "@E 999,999.9999"  // 2 TERCEIRO
	@ prow(),076   PSAY _acoms[_i,3]*100 picture "@E 999.99" // 3 INDICE 
	@ prow(),083   PSAY _acoms[_i,3]*_acoms[_i,7] picture "@E 999,999.9999" // 4 CST.FAB
	@ prow(),097   PSAY (_acoms[_i,3]*_acoms[_i,7])+_acoms[_i,1] picture "@E 999,999.9999" // 5 CST.TOT
	@ prow(),111   PSAY _acoms[_i,6] picture "@E 999,999.99" // 6 PR.FAB
	@ prow(),122   PSAY _acoms[_i,7] picture "@E 999,999.99" // 7 PR.ABC
	@ prow(),133   PSAY _acoms[_i,8] picture "@E 99,999.999" // 8 MARG.CONTR.BR
	@ prow(),144   PSAY _acoms[_i,9] picture "@E 999.99" // 9 % MARG.CONTR.
	@ prow(),152   PSAY _acoms[_i,10] picture "@E 999,999,999" //10 QTDE.FAT
	@ prow(),164   PSAY _acoms[_i,11] picture "@E 999,999,999.99" //11 VLR.FAT
	@ prow(),179   PSAY _acoms[_i,12] picture "@E 999,999,999.99" //12 VLR.RESULTADO
	@ prow(),195   PSAY round((_acoms[_i,12]/_nresult)*100,2) picture "@E 999.999" //13 % ITEM       
	@ prow(),202   PSAY round(_nacum*100,2) picture "@E 999.99" //14 % ACUMULADO  
	_ntot += _acoms[_i,11]
	_ntqtde += _acoms[_i,10]
	_ntres += _acoms[_i,12]   
next

if prow()>0 .and.;
	lcontinua
	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "TOTAL"
	@ prow(),144   PSAY (_ntres/_ntot)*100 picture "@E 999.99"	
	@ prow(),152   PSAY _ntqtde  picture "@E 999,999,999"
	@ prow(),164   PSAY _ntot  picture "@E 999,999,999.99"
	@ prow(),179   PSAY _ntres picture "@E 999,999,999.99"
	roda(cbcont,cbtxt)
endif
if mv_par04="2"
	sb1010->(dbclosearea())
	sb2010->(dbclosearea())
	sg1010->(dbclosearea())
endif
tmp1->(dbclosearea())

sd2->(retindex("SD2"))
if mv_par04="2"
	tcquit()
endif

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf
ms_flush()
return

static function _calccus(_cproduto,_nqb,_nquant)
sg1010->(dbseek(_cfilsg1+_cproduto))
while ! sg1010->(eof()) .and.;
	sg1010->g1_filial==_cfilsg1 .and.;
	sg1010->g1_cod==_cproduto
	sb1010->(dbseek(_cfilsb1+sg1010->g1_comp))
	if sb1010->b1_tipo <> "MO"
		if sb1010->b1_tipo=="PI"
			_nregsg1:=sg1010->(recno())
			//	  _calccus(sg1010->g1_comp,sb1010->b1_qb,sg1010->g1_quant*_nquant)
			_calccus(sg1010->g1_comp,sb1010->b1_qb,round((sg1010->g1_quant/_nqb),2)*_nquant)
			sg1010->(dbgoto(_nregsg1))
		else
			sb2010->(dbseek(_cfilsb2+sg1010->g1_comp+sb1010->b1_locpad))
			if mv_par03==1
				_ncusto+=round(((sg1010->g1_quant/_nqb)*_nquant)*sb2010->b2_cm1,2)
			elseif mv_par03==2
				_ncusto+=round(((sg1010->g1_quant/_nqb)*_nquant)*sb1010->b1_uprc,2)
			else
				_ncusto1:=round(((sg1010->g1_quant/_nqb)*_nquant)*sb2010->b2_cm1,2)
				_ncusto2:=round(((sg1010->g1_quant/_nqb)*_nquant)*sb1010->b1_uprc,2)
				if _ncusto1>_ncusto2
					_ncusto+=_ncusto1
				else
					_ncusto+=_ncusto2
				endif
			endif
		endif
	endif
	sg1010->(dbskip())
end
return

static function _calccus2(_cproduto,_nqb,_nquant)
sg1->(dbseek(_cfilsg1+_cproduto))
while ! sg1->(eof()) .and.;
	sg1->g1_filial==_cfilsg1 .and.;
	sg1->g1_cod==_cproduto
	sb1->(dbseek(_cfilsb1+sg1->g1_comp))
	if sb1->b1_tipo <> "MO"
		
		if sb1->b1_tipo=="PI"
			_nregsg1:=sg1->(recno())
			_calccus2(sg1->g1_comp,sb1->b1_qb,round((sg1->g1_quant/_nqb),2)*_nquant)
			sg1->(dbgoto(_nregsg1))
		else
			sb2->(dbseek(_cfilsb2+sg1->g1_comp+sb1->b1_locpad))
			if mv_par03==1
				_ncusto+=round(((sg1->g1_quant/_nqb)*_nquant)*sb2->b2_cm1,2)
			elseif mv_par03==2
				_ncusto+=round(((sg1->g1_quant/_nqb)*_nquant)*sb1->b1_uprc,2)
			else
				_ncusto1:=round(((sg1->g1_quant/_nqb)*_nquant)*sb2->b2_cm1,2)
				_ncusto2:=round(((sg1->g1_quant/_nqb)*_nquant)*sb1->b1_uprc,2)
				if _ncusto1>_ncusto2
					_ncusto+=_ncusto1
				else
					_ncusto+=_ncusto2
				endif
			endif
		endif
	endif
	sg1->(dbskip())
end
return

static function _geratmp()
procregua(1)
incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_COD PRODUTO,B1_DESC DESCRICAO,B1_QB QB,B1_APREVEN APRES"
_cquery+=" FROM "
_cquery+=" SB1010 SB1"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND (B1_TIPO='PA'"
_cquery+=" OR B1_TIPO='PL')"

_cquery+=" ORDER BY"
_cquery+=" B1_DESC"
tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","QB","N",07,0)
return
/*

static function  _geratmp1()
sb1->(dbgotop())
while ! sb1->(eof()) .and.;
sb1->b1_filial==_cfilsb1 .and.;
sb1->b1_tipo ='PA'
if ! tmp1->(dbseek(sb1->b1_cod))
tmp1->(dbappend())
tmp1->produto :=sb1->b1_cod
tmp1->descricao :=sb1->b1_desc
tmp1->qb :=sb1->b1_qb
tmp1->apres:=sb1->b1_apreven
endif
sb1->(dbskip())
end
return
*/

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
aadd(_agrpsx1,{cperg,"03","Tipo de custo      ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03"       ,"Custo medio"    ,space(30),space(15),"Ultimo preco"   ,space(30),space(15),"Maior custo"    ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Grade              ?","mv_ch4","C",01,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Tabela precos Farma?","mv_ch5","C",03,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"DA0"})
aadd(_agrpsx1,{cperg,"06","Tabela precos Hosp.?","mv_ch6","C",03,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"DA0"})


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
Codigo Descricao                                Qtd. Fat.          Custo         c/ 10%      Valor 3o.           Soma  Cst fabr    Pr. ABC   N/P  Custo Vd.  Cst. tt. % Lucro      Vlr. fat.       Lucro R$
999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 9.999.999 999.999.999,99 999.999.999,99 999.999.999,99 999.999.999,99 999,99999 999.999,99 999,99 999,99999 999,99999 9999,99 999.999.999,99 999.999.999,99
*/

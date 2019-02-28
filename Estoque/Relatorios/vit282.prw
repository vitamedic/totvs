/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT282   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 14/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao das Fichas de Descarte                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit282(_calias,_nreg,_nopc,_lconsulta)
private _nl

if _nopc==6
	mv_par01:=szj->zj_numero
	mv_par02:=szj->zj_numero
	
	_aarea   :=getarea()
	_aareaszj:=szj->(getarea())
	
	processa({|| _imprime()})
	
	szj->(restarea(_aareaszj))
	restarea(_aarea)
	
	sysrefresh()
else
	cperg:="PERGVIT282"
	_pergsx1()
	
	if pergunte(cperg,.t.)
		processa({|| _imprime()})
	endif
endif
return()

static function _imprime()
_cfilsb1:=xfilial("SB1")
_cfilsc2:=xfilial("SC2")
_cfilszi:=xfilial("SZI")
_cfilszj:=xfilial("SZJ")
_cfilszk:=xfilial("SZK")

arial10 :=tfont():new("Arial",,10,,.f.)
arial10n:=tfont():new("Arial",,10,,.t.)
arial12 :=tfont():new("Arial",,12,,.f.)
arial12n:=tfont():new("Arial",,12,,.t.)
arial14 :=tfont():new("Arial",,14,,.f.)
arial14n:=tfont():new("Arial",,14,,.t.)
arial16 :=tfont():new("Arial",,16,,.f.)
arial16n:=tfont():new("Arial",,16,,.t.)

_ncustinc:=getmv("MV_CUSTINC")

oprn:=tmsprinter():new()
oprn:setup()

procregua(szj->(lastrec()))

szj->(dbsetorder(1))
szj->(dbseek(_cfilszj+mv_par01,.t.))
while ! szj->(eof()) .and.;
	szj->zj_filial==_cfilszj .and.;
	szj->zj_numero<=mv_par02
	
	incproc("Imprimindo ficha "+szj->zj_numero)
	
	sc2->(dbsetorder(1))
	sc2->(dbseek(_cfilsc2+szj->zj_op))
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+sc2->c2_produto))
	szi->(dbsetorder(1))
	szi->(dbseek(_cfilszi+szj->zj_motivo))
	
	_npag :=1
	_lemb :=.f.
	_lpamp:=.f.


	szk->(dbsetorder(1))
	szk->(dbseek(_cfilszk+szj->zj_numero))
	while ! szk->(eof()) .and.;
		szk->zk_filial==_cfilszk .and.;
		szk->zk_numero==szj->zj_numero
		
		if szk->zk_tipo$"EE/EN"
			_lemb:=.t.
		else
			_lpamp:=.t.
		endif
		
		szk->(dbskip())
	end
	
	_impcab()
	
	oprn:box(_nl,50,_nl+490,2300)
	_nl+=20
	oprn:say(_nl,1150,"I - SOLICITAÇÃO DE DESCARTE",arial14n,,,,2)
	_nl+=80
	oprn:say(_nl,070,"NÚMERO: "+szj->zj_numero,arial12)
	oprn:say(_nl,2280,"CENTRO DE CUSTO: "+szj->zj_cc,arial12,,,,1)
	_nl+=80
	oprn:box(_nl,70,_nl+40,110)
	if _lemb
		oprn:say(_nl,80,"x",arial12)
	endif
	oprn:say(_nl,120,"Material de Embalagem",arial12)
	oprn:say(_nl,2280,"Produto: "+alltrim(sc2->c2_produto)+" - "+alltrim(sb1->b1_desc),arial12,,,,1)
	_nl+=50
	oprn:box(_nl,70,_nl+40,110)
	if _lpamp
		oprn:say(_nl,80,"x",arial12)
	endif
	oprn:say(_nl,120,"Produtos Químicos e/ou Farmacêuticos",arial12)
	oprn:say(_nl,2280,"OP: "+substr(szj->zj_op,1,6)+"   Lote: "+alltrim(sc2->c2_lotectl),arial12,,,,1)
	
	_nl+=100
	oprn:say(_nl,70,"Motivo do descarte: "+alltrim(szi->zi_desc),arial12)
	_nl+=50
	oprn:say(_nl,70,"Responsável: "+alltrim(szj->zj_usuario),arial12)
	oprn:say(_nl,1900,"Data: "+dtoc(szj->zj_emissao),arial12)
	_nl+=50
	oprn:say(_nl,70,"Gerência/Encarregado: ______________________________________________________",arial12)
	oprn:say(_nl,1900,"Data: __/__/__",arial12)
	_nl+=80
	
	_impcabdet()
	
	_npeso :=0
	_nquant:=0
	_ncusto:=0
	
	szk->(dbsetorder(1))
	szk->(dbseek(_cfilszk+szj->zj_numero))
	while ! szk->(eof()) .and.;
		szk->zk_filial==_cfilszk .and.;
		szk->zk_numero==szj->zj_numero
		
		sb1->(dbsetorder(1))
		sb1->(dbseek(_cfilsb1+szk->zk_produto))
		
		_ncustoun:=round(szk->zk_custo/szk->zk_quant,4)
		_npeso+=szk->zk_peso
		_nquant+=szk->zk_quant
		_ncusto+=szk->zk_custo
		
		if _nl>2900
			oprn:endpage()
			_impcab()
			_impcabdet()
		endif
		
		_nl+=50
		oprn:box(_nl,50,_nl+60,2300)
		oprn:box(_nl,250,_nl+60,251)
		oprn:box(_nl,1000,_nl+60,1001)
		oprn:box(_nl,1250,_nl+60,1251)
		oprn:box(_nl,1500,_nl+60,1501)
		oprn:box(_nl,1750,_nl+60,1751)
		oprn:box(_nl,2000,_nl+60,2001)
		_nl+=10
		oprn:say(_nl,070,alltrim(szk->zk_produto),arial10)
		oprn:say(_nl,270,alltrim(substr(sb1->b1_desc,1,35)),arial10)
		oprn:say(_nl,1020,alltrim(szk->zk_lotectl),arial10)
		oprn:say(_nl,1490,transform(szk->zk_quant,"@E 999,999,999,999.99"),arial10,,,,1)
		oprn:say(_nl,1540,dtoc(szk->zk_dtvalid),arial10)
		oprn:say(_nl,1990,transform(_ncustoun,"@E 9,999,999.9999"),arial10,,,,1)
		oprn:say(_nl,2290,transform(szk->zk_custo,"@E 999,999,999.99"),arial10,,,,1)
		
		szk->(dbskip())
	end
	
	_ntotinc:=round(_npeso*_ncustinc,2)
	
	_nl+=50
	oprn:box(_nl,50,_nl+60,2300)
	_nl+=10
	oprn:say(_nl,1130,"Total:",arial10)
	oprn:say(_nl,1490,transform(_nquant,"@E 999,999,999,999.99"),arial10,,,,1)
	oprn:say(_nl,1900,"Total:",arial10)
	oprn:say(_nl,2290,transform(_ncusto,"@E 999,999,999.99"),arial10,,,,1)
	
	_nl+=50
	oprn:box(_nl,50,_nl+170,2300)
	_nl+=10
	//	if !empty(_npeso) .and. !empty(_ntotinc)
	oprn:say(_nl,070,"Peso Kg:",arial12)
	oprn:say(_nl,900,+transform(_npeso,"@E 999,999.999"),arial12,,,,1)
	_nl+=50
	oprn:say(_nl,070,"Custo da incineração por Kg:",arial12)
	oprn:say(_nl,900,transform(_ncustinc,"@E 999,999.99"),arial12,,,,1)
	_nl+=50
	oprn:say(_nl,070,"Custo total da incineração:",arial12)
	oprn:say(_nl,900,transform(_ntotinc,"@E 999,999,999.99"),arial12,,,,1)
	//	endif
	_nl+=60
	oprn:box(_nl,50,_nl+170,2300)
	_nl+=10
	oprn:say(_nl,070,"Custo total do documento:",arial12)
	oprn:say(_nl,900,transform(_ncusto+_ntotinc,"@E 999,999,999.99"),arial12,,,,1)
	_nl+=100
	oprn:say(_nl,70,"Custos: __________________________________________________________________",arial12)
	oprn:say(_nl,1900,"Data: __/__/__",arial12)
	
	oprn:endpage()
	
	reclock("SZJ",.f.)
	szj->zj_impres:="S"
	msunlock()
	
	szj->(dbskip())
end
oprn:preview()
return()

static function _impcab()
oprn:startpage()

_nl:=100
oprn:box(_nl,50,_nl+210,2300)
oprn:box(_nl,1800,_nl+210,1801)

_nl+=20
oprn:saybitmap(_nl+30,70,"vitapan.bmp",387,123)
oprn:say(_nl,1150,"DEPARTAMENTO DE UTILIDADES",arial16,,,,2)
oprn:say(_nl,2280,"Formulário RQ-UTL-001",arial12,,,,1)
oprn:say(_nl+50,2280,"Revisão: 005",arial12,,,,1)
oprn:say(_nl+100,2280,"Página: "+alltrim(str(_npag)),arial12,,,,1)
_nl+=60
oprn:say(_nl,1150,"FICHA DE REGISTRO PARA DESCARTE DE",arial16n,,,,2)
_nl+=60
oprn:say(_nl,1150,"MATERIAIS E RESÍDUOS INDUSTRIAIS",arial16n,,,,2)
_nl+=90

_npag++
return()

static function _impcabdet()
oprn:box(_nl,50,_nl+60,2300)
oprn:box(_nl,1750,_nl+60,1751)
_nl+=10
oprn:say(_nl,850,"SOLICITANTE",arial12n,,,,2)
oprn:say(_nl,2000,"CUSTOS",arial12n,,,,2)

_nl+=50
oprn:box(_nl,50,_nl+60,2300)
oprn:box(_nl,250,_nl+60,251)
oprn:box(_nl,1000,_nl+60,1001)
oprn:box(_nl,1250,_nl+60,1251)
oprn:box(_nl,1500,_nl+60,1501)
oprn:box(_nl,1750,_nl+60,1751)
oprn:box(_nl,2000,_nl+60,2001)
_nl+=10
oprn:say(_nl,070,"Código",arial10n)
oprn:say(_nl,270,"Descrição",arial10n)
oprn:say(_nl,1020,"Lote",arial10n)
oprn:say(_nl,1320,"Qtde.",arial10n)
oprn:say(_nl,1520,"Vencimento",arial10n)
oprn:say(_nl,1820,"Cst. Unit.",arial10n)
oprn:say(_nl,2070,"Cst. Total",arial10n)
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da ficha                     ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a ficha                  ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
return()

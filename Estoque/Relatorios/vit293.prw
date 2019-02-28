/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT293   ³ Autor ³ Heraildo C. Freitas   ³ Data ³ 05/04/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Listagem para Inventario                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "rwmake.ch"
#include "topconn.ch"

user function vit293()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="LISTAGEM PARA INVENTARIO"
cdesc1   :="Este programa ira emitir a listagem de produtos para inventario"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT293"
wnrel    :="VIT293"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT293"
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
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb8:=xfilial("SB8")
_cfilsbf:=xfilial("SBF")

processa({|| geratmp()})

setprc(0,0)

setregua(0)

if mv_par13==2 .and.;
	mv_par14==2
	
	cabec1:="CODIGO          DESCRICAO                                AR QUANTIDADE"
	cabec2:=""
	
	_limpcab:=.t.
	
	tmp1->(dbgotop())
	while ! tmp1->(eof()) .and.;
		lcontinua
		
		incregua()
		
		if _limpcab .or. prow()>56
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			_limpcab:=.f.
		endif
		
		@ prow()+1,000 psay tmp1->b2_cod
		@ prow(),016   psay substr(tmp1->b1_desc,1,40)
		@ prow(),057   psay tmp1->b2_local
		@ prow(),060   psay "____________________"
		
		tmp1->(dbskip())
		
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
	end
	tmp1->(dbclosearea())
endif

if mv_par13==1 .and.;
	mv_par14==2
	
	cabec1:="LOTE       AR QUANTIDADE"
	cabec2:=""
	
	_limpcab:=.t.
	
	tmp2->(dbgotop())
	while ! tmp2->(eof()) .and.;
		lcontinua
		
		incregua()
		
		if _limpcab .or. prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			_limpcab:=.f.
		endif
		
		@ prow()+2,000 psay tmp2->b8_produto
		@ prow(),016   psay substr(tmp2->b1_desc,1,40)
		
		_cproduto:=tmp2->b8_produto
		while ! tmp2->(eof()) .and.;
			tmp2->b8_produto==_cproduto .and.;
			lcontinua
			
			if prow()>56
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			
			@ prow()+1,000 psay tmp2->b8_lotectl
			@ prow(),011   psay tmp2->b8_local
			@ prow(),014   psay "____________________"
			
			tmp2->(dbskip())
			
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				eject
				lcontinua:=.f.
			endif
		end
	end
	tmp2->(dbclosearea())
endif

if mv_par13==1 .and.;
	mv_par14==1
	
	cabec1:="LOTE       AR QUANTIDADE"
	cabec2:=""
	
	_limpcab:=.t.
	
	tmp3->(dbgotop())
	while ! tmp3->(eof()) .and.;
		lcontinua
		
		incregua()
		
		if _limpcab .or. prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			_limpcab:=.f.
		endif
		
		@ prow()+2,000 psay tmp3->bf_localiz
		@ prow(),016   psay "-"
		@ prow(),018   psay tmp3->bf_produto
		@ prow(),034   psay substr(tmp3->b1_desc,1,40)
		
		_clocaliz:=tmp3->bf_localiz
		_cproduto:=tmp3->bf_produto
		while ! tmp3->(eof()) .and.;
			tmp3->bf_localiz==_clocaliz .and.;
			tmp3->bf_produto==_cproduto .and.;
			lcontinua
			
			if prow()>56
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			
			@ prow()+1,000 psay tmp3->bf_lotectl
			@ prow(),011   psay tmp3->bf_local
			@ prow(),014   psay "____________________"
			
			tmp3->(dbskip())
			
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				eject
				lcontinua:=.f.
			endif
		end
	end
	tmp3->(dbclosearea())
endif

if prow()>0 .and.;
	lcontinua
	
	roda(cbcont,cbtxt)
endif

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()
return()

static function geratmp()
procregua(0)

if mv_par13==2 .and.;
	mv_par14==2
	
	incproc("Selecionando produtos...")
	_cquery:=" SELECT"
	_cquery+=" B2_COD,"
	_cquery+=" B1_DESC,"
	_cquery+=" B1_UM,"
	_cquery+=" B2_LOCAL,"
	_cquery+=" B2_QATU"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("SB1")+" SB1,"
	_cquery+=  retsqlname("SB2")+" SB2"
	
	_cquery+=" WHERE"
	_cquery+="     SB1.D_E_L_E_T_=' '"
	_cquery+=" AND SB2.D_E_L_E_T_=' '"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND B2_FILIAL='"+_cfilsb2+"'"
	_cquery+=" AND B2_COD=B1_COD"
	_cquery+=" AND B2_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" AND B2_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" AND B2_QATU<>0"
	_cquery+=" AND B1_RASTRO NOT IN ('L','S')"
	_cquery+=" AND B1_LOCALIZ<>'S'"
	
	_cquery+=" ORDER BY"
	_cquery+=" 2,4,1"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP1"
	u_setfield("TMP1")
endif

if mv_par13==1 .and.;
	mv_par14==2
	
	incproc("Selecionando produtos...")
	_cquery:=" SELECT"
	_cquery+=" B8_PRODUTO,"
	_cquery+=" B1_DESC,"
	_cquery+=" B1_UM,"
	_cquery+=" B8_LOCAL,"
	_cquery+=" B8_LOTECTL,"
	_cquery+=" SUM(B8_SALDO) B8_SALDO"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("SB1")+" SB1,"
	_cquery+=  retsqlname("SB8")+" SB8"
	
	_cquery+=" WHERE"
	_cquery+="     SB1.D_E_L_E_T_=' '"
	_cquery+=" AND SB8.D_E_L_E_T_=' '"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
	_cquery+=" AND B8_PRODUTO=B1_COD"
	_cquery+=" AND B8_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" AND B8_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" AND B8_LOTECTL BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	_cquery+=" AND B8_SALDO<>0"
	_cquery+=" AND B1_RASTRO='L'"
	_cquery+=" AND B1_LOCALIZ<>'S'"
	
	_cquery+=" GROUP BY"
	_cquery+=" B8_PRODUTO,B1_DESC,B1_UM,B8_LOCAL,B8_LOTECTL"
	
	_cquery+=" ORDER BY"
	_cquery+=" 2,4,1,5"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	u_setfield("TMP2")
endif

if mv_par13==1 .and.;
	mv_par14==1
	
	incproc("Selecionando produtos...")
	_cquery:=" SELECT"
	_cquery+=" BF_PRODUTO,"
	_cquery+=" B1_DESC,"
	_cquery+=" B1_UM,"
	_cquery+=" BF_LOCAL,"
	_cquery+=" BF_LOTECTL,"
	_cquery+=" BF_LOCALIZ,"
	_cquery+=" BF_QUANT"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("SB1")+" SB1,"
	_cquery+=  retsqlname("SBF")+" SBF"
	
	_cquery+=" WHERE"
	_cquery+="     SB1.D_E_L_E_T_=' '"
	_cquery+=" AND SBF.D_E_L_E_T_=' '"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND BF_FILIAL='"+_cfilsbF+"'"
	_cquery+=" AND BF_PRODUTO=B1_COD"
	_cquery+=" AND BF_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" AND BF_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" AND BF_LOTECTL BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	_cquery+=" AND BF_LOCALIZ BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
	_cquery+=" AND BF_QUANT<>0"
	_cquery+=" AND B1_LOCALIZ='S'"
	
	_cquery+=" ORDER BY"
	_cquery+=" 6,2,4,1,5"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP3"
	u_setfield("TMP3")
endif
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto                   ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto                ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo                      ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo                   ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo                     ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo                  ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Do armazem                   ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem                ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do lote                      ?","mv_ch9","C",10,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate o lote                   ?","mv_cha","C",10,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Do endereco                  ?","mv_chb","C",15,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBE"})
aadd(_agrpsx1,{cperg,"12","Ate o endereco               ?","mv_chc","C",15,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBE"})
aadd(_agrpsx1,{cperg,"13","Produtos com controle de lote?","mv_chd","N",01,0,0,"C",space(60),"mv_par13"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"14","Produtos com controle de end.?","mv_che","N",01,0,0,"C",space(60),"mv_par14"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

for _ni:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_ni,1]+_agrpsx1[_ni,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_ni,01]
		sx1->x1_ordem  :=_agrpsx1[_ni,02]
		sx1->x1_pergunt:=_agrpsx1[_ni,03]
		sx1->x1_variavl:=_agrpsx1[_ni,04]
		sx1->x1_tipo   :=_agrpsx1[_ni,05]
		sx1->x1_tamanho:=_agrpsx1[_ni,06]
		sx1->x1_decimal:=_agrpsx1[_ni,07]
		sx1->x1_presel :=_agrpsx1[_ni,08]
		sx1->x1_gsc    :=_agrpsx1[_ni,09]
		sx1->x1_valid  :=_agrpsx1[_ni,10]
		sx1->x1_var01  :=_agrpsx1[_ni,11]
		sx1->x1_def01  :=_agrpsx1[_ni,12]
		sx1->x1_cnt01  :=_agrpsx1[_ni,13]
		sx1->x1_var02  :=_agrpsx1[_ni,14]
		sx1->x1_def02  :=_agrpsx1[_ni,15]
		sx1->x1_cnt02  :=_agrpsx1[_ni,16]
		sx1->x1_var03  :=_agrpsx1[_ni,17]
		sx1->x1_def03  :=_agrpsx1[_ni,18]
		sx1->x1_cnt03  :=_agrpsx1[_ni,19]
		sx1->x1_var04  :=_agrpsx1[_ni,20]
		sx1->x1_def04  :=_agrpsx1[_ni,21]
		sx1->x1_cnt04  :=_agrpsx1[_ni,22]
		sx1->x1_var05  :=_agrpsx1[_ni,23]
		sx1->x1_def05  :=_agrpsx1[_ni,24]
		sx1->x1_cnt05  :=_agrpsx1[_ni,25]
		sx1->x1_f3     :=_agrpsx1[_ni,26]
		sx1->(msunlock())
	endif
next
return()

/*
CODIGO          DESCRICAO                                AR QUANTIDADE
XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX ____________________

XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
LOTE       AR QUANTIDADE
XXXXXXXXXX XX ____________________

XXXXXXXXXXXXXXX - XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
LOTE       AR QUANTIDADE
XXXXXXXXXX XX ____________________
*/

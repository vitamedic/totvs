/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT156   ³ Autor ³ Gardenia Ilany          Data ³ 16/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Curva ABC de Insumos                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT156()
nordem  :=""
tamanho :="G"
limite  :=200
titulo  :="ABC INSUMOS"
cdesc1  :="Este programa ira emitir a relacao do preco medio de venda de produtos"
cdesc2  :=""
cdesc3  :=""
cstring :="SD3"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT156"
wnrel   :="VIT156"+Alltrim(cusername)
alinha  :={}
aordem  :={"Codigo","Descricao","Participação"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGVIT156"
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

cabec1:="Data Referência: "+dtoc(mv_par01)
cabec2:="Ordem Codg.  Descrição                                   Cons.12 meses      Vl.Cons.12 M  Particip. Cst.12 M  Cst. Ano  Cst.Atual Var.12 M      Var.Ano       Pond.12M   Pond.Ano  Part. acum. Tipo"

_cfilsb1:=xfilial("SB1")
_cfilsd3:=xfilial("SD3")
sb1->(dbsetorder(1))
sd3->(dbsetorder(6))

//_abretop("SD3010",6)
//_abretop("SB1010",1)

_aestrut:={}
aadd(_aestrut,{"PRODUTO"  ,"C",15,0})
aadd(_aestrut,{"DESCRICAO","C",40,0})
aadd(_aestrut,{"CSTUNIT"  ,"N",12,3})
aadd(_aestrut,{"QUANTANO" ,"N",15,3})
aadd(_aestrut,{"VALORANO" ,"N",15,3})
aadd(_aestrut,{"QUANT12M" ,"N",09,0})
aadd(_aestrut,{"VALOR12M" ,"N",12,2})

_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
_cindtmp11:=criatrab(,.f.)
_cchave   :="produto"
tmp1->(indregua("TMP1",_cindtmp11,_cchave))
if nordem==1
	_cindtmp12:=criatrab(,.f.)
	_cchave   :="produto"
	tmp1->(indregua("TMP1",_cindtmp12,_cchave))
elseif nordem==2
	_cindtmp12:=criatrab(,.f.)
	_cchave   :="descricao+produto"
	tmp1->(indregua("TMP1",_cindtmp12,_cchave))
elseif nordem==3
	_cindtmp12:=criatrab(,.f.)
	_cchave   :="strzero(valor12m,12)+descricao+produto"
	tmp1->(indregua("TMP1",_cindtmp12,_cchave))
endif
//if nordem>1
	tmp1->(dbclearind())
	tmp1->(dbsetindex(_cindtmp11))
	tmp1->(dbsetindex(_cindtmp12))
	tmp1->(dbsetorder(1))
//endif
_ntotvalor:=0
_ntotquant:=0

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
_a :=1
if nordem>2
	tmp1->(dbgobottom())
else
	tmp1->(dbgotop())
endif         

//Ordem Codg.  Descrição                                 Cons.12 meses   Vl.Cons.12 M Particip.Cst.12 M Cst. Ano Var.12 M  Var.Ano Pond.12M Pond.Ano 
//99999 999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999,999.99 999,999,999.99 9999.999 9999.999 9999.999 9999.9999 999.9999 999.9999 999.9999
_tparticip:=0
while if(nordem>2,! tmp1->(bof()),! tmp1->(eof())) .and.;
		lcontinua
	incregua()
	if prow()==0 .or. prow()>55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY _i          picture "99999"
	@ prow(),006   PSAY left(tmp1->produto,6)
	@ prow(),013   PSAY tmp1->descricao                
	_particip:=(tmp1->valor12m/_ntotvalor)*100
	@ prow(),054   PSAY tmp1->quant12m picture "@E 99999,999,999.99"
	@ prow(),073   PSAY tmp1->valor12m picture "@E 99999,999,999.99"
	@ prow(),090   PSAY  _particip picture "@R 999.99 %"
	_tparticip+=_particip
	sb1->(dbseek(_cfilsb1+tmp1->produto))                             

/* _custo12m:=round(tmp1->valor12m/tmp1->quant12m,3)
   _custoano:=round(tmp1->valorano/tmp1->quantano,3)
	@ prow(),094   PSAY _custo12m picture "@E 9999.999"
	@ prow(),104   PSAY _custoano picture "@E 9999.999"   // Tirei o Jr. queria o custo de datas e não do período
	@ prow(),114   PSAY _custoatual picture "@E 9999.999"
*/
   _custo:=calcest(sb1->b1_cod,sb1->b1_locpad,(mv_par01-365))   
   _custo1:=_custo[2]
   _estoque1:=_custo[1]
   _custo12m:= _custo1/_estoque1
	@ prow(),099  PSAY _custo12m picture "@E 9999.9999"
	
	
	_year:=year(mv_par01)-1
   _data:="31/12/"+strzero(_year,4)
   _data:= ctod(_data)
   _custo:=calcest(sb1->b1_cod,sb1->b1_locpad,(_data))   
   _custo1:=_custo[2]
   _estoque1:=_custo[1]
   _custoano:=_custo1/_estoque1
	@ prow(),109  PSAY _custoano picture "@E 9999.9999"
  
   _custo:=calcest(sb1->b1_cod,sb1->b1_locpad,mv_par01)   
   _custo1:=_custo[2]
   _estoque1:=_custo[1]
   _custoatual:=round(_custo1/_estoque1,3)
	@ prow(),119  PSAY _custoatual picture "@E 9999.9999"
	
	_var12m:=((round(_custoatual/_custo12m,3))-1)*100
	_varano:=((round(_custoatual/_custoano,3))-1)*100
	@ prow(),130   PSAY _var12m picture "@E 9999.99 %"
	@ prow(),143   PSAY _varano picture "@E 9999.99 %"
	@ prow(),158   PSAY (_particip*_var12m)/100 picture "@R 999.99 %"
	@ prow(),168   PSAY (_particip*_varano)/100 picture "@R 999.99 %"
	@ prow(),178   PSAY _tparticip picture "@R 999.99 %"
	@ prow(),187   PSAY sb1->b1_tipo
//	_ntotquant+=tmp1->quant
//	_nvalor +=tmp1->valor
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
/*
if _ntotquant>0          
	@ prow()+1,000 PSAY "TOTAL LINHA "+if(_caprven="1"," FARMA:"," HOSPITALAR:")
	@ prow(),054   PSAY _ntotquant picture "@E 999,999,999"  
	@ prow(),066   PSAY _nvalor picture "@E 999,999,999.99"
 	@ prow()+1,000 PSAY ""
	_ntotlin +=_ntotquant
	_ntotvlin+=_nvalor
	_ntotquant:=0
endif
*/
if prow()>0 .and.;
	lcontinua
//	@ prow()+1,000 PSAY replicate("-",limite)
//	@ prow()+1,000 PSAY "TOTAL"
//	@ prow(),054   PSAY _ntotlin picture "@E 999,999,999"
//	@ prow(),066   PSAY _ntotvlin picture "@E 999,999,999.99"
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
procregua(sd3->(lastrec()))
_dataref:=mv_par01 - 365
sd3->(dbseek(_cfilsd3+dtos(_dataref),.t.))
while ! sd3->(eof()) .and.;
		sd3->d3_filial==_cfilsd3 .and.;
		sd3->d3_emissao<=mv_par01
	incproc("Processando consumo: "+dtoc(sd3->d3_emissao))
	if sd3->d3_cod>=mv_par02 .and.;
		sd3->d3_cod<=mv_par03 .and.;
		sd3->d3_local >= mv_par08 .and.;
		sd3->d3_local <= mv_par09
		sb1->(dbseek(_cfilsb1+sd3->d3_cod))
		if sb1->b1_tipo>=mv_par04 .and.;
			sb1->b1_tipo<=mv_par05 .and.;
			sb1->b1_grupo>=mv_par06 .and.;
			sb1->b1_grupo<=mv_par07    
			if substr(sd3->d3_cf,1,1) == "R" .and. sd3->d3_estorno <> "S"   
				if !tmp1->(dbseek(sd3->d3_cod))
					tmp1->(dbappend())
					tmp1->produto  :=sd3->d3_cod
					tmp1->descricao:=sb1->b1_desc
					tmp1->quant12m :=sd3->d3_quant
					tmp1->valor12m :=sd3->d3_custo1
					if year(sd3->d3_emissao) == year(mv_par01)
						tmp1->quantano :=sd3->d3_quant
						tmp1->valorano :=sd3->d3_custo1
					endif	
				else
					tmp1->quant12m +=sd3->d3_quant
					tmp1->valor12m +=sd3->d3_custo1
					if year(sd3->d3_emissao) == year(mv_par01)
						tmp1->quantano +=sd3->d3_quant
						tmp1->valorano +=sd3->d3_custo1
                endif
				endif	  							
				_ntotvalor+=sd3->d3_custo1					
				_ntotquant+=sd3->d3_quant                       	
			endif
		endif
	endif	
	sd3->(dbskip())
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
aadd(_agrpsx1,{cperg,"01","Data Referencia    ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Do produto         ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Ate o produto      ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Do tipo            ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Ate o tipo         ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Do grupo           ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Ate o grupo        ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"08","Do armazem         ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Ate o armazem      ?","mv_ch9","C",02,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

	
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
*/

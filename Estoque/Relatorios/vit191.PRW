/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT191   ³ Autor ³ Gardenia              ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Simulacao de Frete                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
Variaveis utilizadas para parametros
mv_par01 Da data
mv_par02 Ate a data
mv_par01 Do produto
mv_par02 Ate o produto
mv_par01 Do tipo
mv_par02 Ate o tipo
mv_par01 Do grupo
mv_par02 Ate a grupo
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT191()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="SIMULACAO DE FRETE ENTRADA  "
cdesc1   :="Este programa ira emitir a simulacao de frete de entrada"
cdesc2   :=""
cdesc3   :=""
cstring  :="SZE"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT191"
wnrel    :="VIT191"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT191"
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
_cfilsze:=xfilial("SZE")
_cfilszf:=xfilial("SZF")
_cfilsa2:=xfilial("SA2")
_cfilszc:=xfilial("SZC")
sze->(dbsetorder(1))
szf->(dbsetorder(1))
sa2->(dbsetorder(1))
szc->(dbsetorder(1))

processa({|| _querys()})

cabec1:="SIMULA   FORNECEDOR                                             VALOR NF       PESO     VOLUME  DT.SIMUL"
//SIMULA FORNECEDOR                                             VALOR NF       PESO     VOLUME  DT.SIMUL
//99999  999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999,999.99 999,999.99 999,999.99  99/99/99
cabec2:=''



setprc(0,0)

setregua(sze->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	incregua()
	_valor1:=0
	_valor2:=0
	_valor3:=0
	_simula:=tmp1->simula
//99999  999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999,999.99 999,999.99 999,999.99  99/99/99
   sa2->(dbseek(_cfilsa2+tmp1->fornec+tmp1->lojafor))
	@ prow()+2,000 PSAY _simula
	@ prow(),008  PSAY tmp1->fornec+"-"+tmp1->lojafor
	@ prow(),018  PSAY sa2->a2_nome
	@ prow(),057  PSAY tmp1->valornf  picture "@E 999,999,999.99"
	@ prow(),072  PSAY tmp1->peso  picture "@E 999,999.99"
	@ prow(),083  PSAY tmp1->volume picture "@E 999,999.99"
	@ prow(),095  PSAY tmp1->datas
   szf->(dbseek(_cfilszf+_simula))
   _passou:=.f.
	while ! szf->(eof()) .and.;
		_simula==szf->zf_simula .and. lcontinua 
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
		if !_passou
			@ prow()+1,000 PSAY "DOCUMENTOS ESPECIAIS:"
			_passou :=.t.
		endif	
	   szc->(dbseek(_cfilszc+szf->zf_documen))
		@ prow()+1,008   PSAY szf->zf_documen
		@ prow(),018   PSAY szc->zc_desc 
		szf->(dbskip())
	end
   _x1:=tmp1->valor1
   _x2:=tmp1->valor2
   _x3:=tmp1->valor3
   
   if _x1==_x2
	_x1+=0.01
	endif
	if _x1==_x3
		_x3+=0.01
	endif
	if _x2==_x3
		_x2+=0.01
	endif	
/*  
   
	if (tmp1->valor1 <= tmp1->valor2) .and. (tmp1->valor1 <= tmp1->valor3) 
      _valor1:=tmp1->valor1
      _transp1:=tmp1->transp1
   elseif 	 (tmp1->valor2 <= tmp1->valor1) .and. (tmp1->valor2 <= tmp1->valor3)
      _valor1:=tmp1->valor2
      _transp1:=tmp1->transp2
	elseif	(tmp1->valor3 <= tmp1->valor2) .and. (tmp1->valor3 <= tmp1->valor1)
      _valor1:=tmp1->valor3   
      _transp1:=tmp1->transp3
   endif
   

	if ((tmp1->valor1 >=tmp1->valor2) .and. (tmp1->valor1 <= tmp1->valor3)) .or.  ((tmp1->valor1 <= tmp1->valor2) .and. (tmp1->valor1 >= tmp1->valor3)) 
		_valor2:=tmp1->valor1  
      _transp2:=tmp1->transp1
	elseif ((tmp1->valor2 >= tmp1->valor1) .and. (tmp1->valor2 <= tmp1->valor3)) .or.  ((tmp1->valor2 <= tmp1->valor1) .and. (tmp1->valor2 >= tmp1->valor3)) 
		_valor2:=tmp1->valor2
      _transp2:=tmp1->transp2
	elseif ((tmp1->valor3 >= tmp1->valor1) .and. (tmp1->valor3 <= tmp1->valor2)) .or.  ((tmp1->valor3 <= tmp1->valor1) .and. (tmp1->valor3 >= tmp1->valor2))  
		_valor2:=tmp1->valor3
      _transp2:=tmp1->transp3
	endif
       
   
	if (tmp1->valor1 >= tmp1->valor2) .and. (tmp1->valor1 >= tmp1->valor3) 
		_valor3:=tmp1->valor1
      _transp3:=tmp1->transp1
	elseif (tmp1->valor2 >= tmp1->valor1) .and. (tmp1->valor2 >= tmp1->valor3)	 
		_valor3:=tmp1->valor2
      _transp3:=tmp1->transp2
	elseif	(tmp1->valor3 >= tmp1->valor1) .and. (tmp1->valor3 >= tmp1->valor2)	
		_valor3:=tmp1->valor3
      _transp3:=tmp1->transp3
	endif

*/

	if (_x1 <= _x2) .and. (_x1 <= _x3) 
      _valor1:=_x1
      _transp1:=tmp1->transp1
   elseif 	 (_x2 <= _x1) .and. (_x2 <= _x3)
      _valor1:=_x2
      _transp1:=tmp1->transp2
	elseif	(_x3 <= _x2) .and. (_x3 <= _x1)
      _valor1:=_x3   
      _transp1:=tmp1->transp3
   endif
   

	if ((_x1 >=_x2) .and. (_x1 <= _x3)) .or.  ((_x1 <= _x2) .and. (_x1 >= _x3)) 
		_valor2:=_x1  
      _transp2:=tmp1->transp1
	elseif ((_x2 >= _x1) .and. (_x2 <= _x3)) .or.  ((_x2 <= _x1) .and. (_x2 >= _x3)) 
		_valor2:=_x2
      _transp2:=tmp1->transp2
	elseif ((_x3 >= _x1) .and. (_x3 <= _x2)) .or.  ((_x3 <= _x1) .and. (_x3 >= _x2))  
		_valor2:=_x3
      _transp2:=tmp1->transp3
	endif
       
   
	if (_x1 >= _x2) .and. (_x1 >= _x3) 
		_valor3:=_x1
      _transp3:=tmp1->transp1
	elseif (_x2 >= _x1) .and. (_x2 >= _x3)	 
		_valor3:=_x2
      _transp3:=tmp1->transp2
	elseif	(_x3 >= _x1) .and. (_x3 >= _x2)	
		_valor3:=_x3
      _transp3:=tmp1->transp3
	endif

	@ prow()+1,000 PSAY "OPCOES DE TRANSPORTADORA:"
	if !empty(_transp1)  
	   sa2->(dbseek(_cfilsa2+_transp1))
		@ prow()+1,008 PSAY _transp1  
		@ prow(),018 PSAY  sa2->a2_nome
		@ prow(),060  PSAY _valor1  picture "@E 999,999,999.99"
	endif
	if	 !empty(_transp2)  
	   sa2->(dbseek(_cfilsa2+_transp2))
		@ prow()+1,008 PSAY _transp2  
		@ prow(),018 PSAY  sa2->a2_nome
		@ prow(),060  PSAY _valor2  picture "@E 999,999,999.99"
	endif
	 if !empty(_transp3)  	
	   sa2->(dbseek(_cfilsa2+_transp3))
		@ prow()+1,008 PSAY _transp3  
		@ prow(),018 PSAY  sa2->a2_nome
		@ prow(),060  PSAY _valor3  picture "@E 999,999,999.99"
	endif
	tmp1->(dbskip())
end

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
_cquery+=" ZE_FORNEC FORNEC,ZE_LOJAFOR LOJAFOR,ZE_PESO PESO,ZE_VOLUME VOLUME,ZE_SIMULA SIMULA,"
_cquery+=" ZE_VALORNF VALORNF,ZE_TRANSP1 TRANSP1,ZE_TRANSP2 TRANSP2,ZE_TRANSP3 TRANSP3,"
_cquery+=" ZE_VALOR1 VALOR1,ZE_VALOR2 VALOR2,ZE_VALOR3 VALOR3,ZE_DATA DATAS"
_cquery+=" FROM "
_cquery+=  retsqlname("SZE")+" SZE"
_cquery+=" WHERE"                          
_cquery+="     SZE.D_E_L_E_T_<>'*'"
_cquery+=" AND ZE_FILIAL='"+_cfilsze+"'"
_cquery+=" AND ZE_SIMULA  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND ZE_DATA BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
_cquery+=" ORDER BY ZE_SIMULA,ZE_DATA"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DATAS","D")
tcsetfield("TMP1","VALORNF" ,"N",15,2)
tcsetfield("TMP1","VALOR1"  ,"N",15,2)
tcsetfield("TMP1","VALOR2"  ,"N",15,2)
tcsetfield("TMP1","VALOR3"  ,"N",15,2)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da simulacao       ?","mv_ch1","C",05,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate a simulacao    ?","mv_ch2","C",05,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Da Data            ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate a Data         ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
	
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
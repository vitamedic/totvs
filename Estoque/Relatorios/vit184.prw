/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT184   ³ Autor ³ Gardenia              ³ Data ³ 07/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rel.Atualizacao dos Custos de Insumos                      ³±±
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

user function VIT184()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="EFENCIENCIA DE COMPRAS " //ATUALIZACAO DOS CUSTOS DE INSUMOS POR COMPRA"
cdesc1   :="Este programa ira emitir a movimentação dos custos de"
cdesc2   :="insumos "
cdesc3   :=""
cstring  :="SD1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT184"
wnrel    :="VIT184"
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=200
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT184"
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
_cfilsd1:=xfilial("SD1")
_cfilsd3:=xfilial("SD3")
_cfilsb2:=xfilial("SB2")
_cfilsf4:=xfilial("SF4")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sd1->(dbsetorder(7))
sd3->(dbsetorder(7))
sf4->(dbsetorder(1))


processa({|| _querys()})

cabec1:="periodo: "+dtoc(mv_par08) +" a " + dtoc(mv_par09)  +     "                      Dt. cst ant.: "+  dtoc(mv_par10)
cabec2:="Produto Descricao                                 Qtde.Recebida   Cst.Anterior Cst.Ult.Compra  Difer. Total anterior    Total atual  Entrada"
//Produto Descricao                                 Qtde.Recebida   Cst.Anterior Cst.Ult.Compra Difer. Total anterior Total atual     Entrada
//999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999,99 999.999,999999 999.999,999999 999,99 999.999.999,99 999.999.999,99 99/99/99



setprc(0,0)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
_tquant:=0
_tcustoant:=0
_tcusto:=0
_ttcustoant:=0
_ttcusto:=0
_data:=ctod(space(08))



while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif               
	_quant:=0
	_custo:=0
	_custoant:=0
	_cproduto:=tmp1->cod
	sd1->(dbseek(_cfilsd1+_cproduto,.t.))
	sb1->(dbseek(_cfilsb1+_cproduto))
	_locpad:= sb1->b1_locpad
	sb2->(dbseek(_cfilsb1+_cproduto+tmp1->locpad))

	set softseek on
	sd3->(dbseek(_cfilsd3+_cproduto+_locpad+dtos(mv_par10)))
	set softseek off
//   _custoant:=sd3->d3_custo1/sd3->d3_quant

	_custoant:=0
//	if _cproduto==sd3->d3_cod .and. sd3->d3_estorno <> "S"
//	   _custoant:=sd3->d3_custo1/sd3->d3_quant
//	else    
//	   sd3->(dbskip(-1))
//	   if _cproduto==sd3->d3_cod
//	     _custoant:=sd3->d3_custo1/sd3->d3_quant
//	   else 
//	     _custoant:= 0
//	   endif 
//  endif



		if _cproduto==sd3->d3_cod .and. sd3->d3_emissao <= mv_par10   
		   _custoant:=sd3->d3_custo1/sd3->d3_quant
		elseif _cproduto <> sd3->d3_cod .or. sd3->d3_emissao > mv_par10   
		   sd3->(dbskip(-1))
		   if _cproduto==sd3->d3_cod .and. sd3->d3_quant >0
		     _custoant:=sd3->d3_custo1/sd3->d3_quant
		   elseif _cproduto==sd3->d3_cod .and. sd3->d3_quant =0
			   sd3->(dbskip(-1))
			   if _cproduto==sd3->d3_cod 
			     _custoant:=sd3->d3_custo1/sd3->d3_quant
            endif
         else   
		     _custoant:= 0
		   endif 
	   endif             

//		msgstop(_cproduto)
//		msgstop(sd3->d3_cod)
//		msgstop(sd3->d3_emissao)
//		msgstop(mv_par10)


//msgstop(sd3->d3_cod)
//msgstop(sd3->d3_emissao)
//msgstop(_custoant)


   if _custoant == 0
		if tmp1->tipo == "EE" .or. tmp1->tipo =="EN" .or. tmp1->tipo == "MP"
			set softseek on
			sd1->(dbseek(_cfilsd1+_cproduto+"98"+dtos(mv_par10)))
			set softseek off
       else
			set softseek on
			sd1->(dbseek(_cfilsd1+_cproduto+_locpad+dtos(mv_par10)))
			set softseek off
		endif	
//		msgstop(_cproduto)
//		msgstop(sd1->d1_cod)
//		msgstop(sd1->d1_dtdigit)
//		msgstop(mv_par10)
  
		if _cproduto==sd1->d1_cod .and. sd1->d1_dtdigit <= mv_par10   
		   _custoant:=sd1->d1_custo/sd1->d1_quant
		elseif _cproduto <> sd1->d1_cod .or. sd1->d1_dtdigit > mv_par10   
		   sd1->(dbskip(-1))
		   if _cproduto==sd1->d1_cod .and. sd1->d1_quant >0
		     _custoant:=sd1->d1_custo/sd1->d1_quant
		   elseif _cproduto==sd1->d1_cod .and. sd1->d1_quant =0
			   sd1->(dbskip(-1))
			   if _cproduto==sd1->d1_cod 
			     _custoant:=sd1->d1_custo/sd1->d1_quant
            endif
		     _custoant:= 0
		   endif 
	   endif             
   endif                   

	sd1->(dbsetorder(7))
	sd1->(dbseek(_cfilsd1+_cproduto,.t.))
	while !sd1->(eof()) .and.;
		_cproduto==sd1->d1_cod   .and. ;
		lcontinua               
		if sd1->d1_dtdigit < mv_par08 .or. sd1->d1_dtdigit > mv_par09 .or. sd1->d1_quant == 0
		   sd1->(dbskip())
		   loop
		endif   
      if empty(sd1->d1_pedido) .or. empty(_custoant)				
		   sd1->(dbskip())
		   loop
		endif   
		_quant:=sd1->d1_quant
		_data:=sd1->d1_dtdigit
	   _custo:=sd1->d1_custo/sd1->d1_quant
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
	   sd1->(dbskip())
	end

//999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999,99 999.999,999999 999.999,999999 999,99 999.999.999,99 999.999.999,99 99/99/99
	if _quant > 0
		@ prow()+1,00 PSAY substr(tmp1->cod,1,6)
		@ prow(),08   PSAY tmp1->descr
		@ prow(),49 PSAY _quant  picture  "@E 999,999,999.99"
		@ prow(),64 PSAY _custoant picture  "@E 999,999.999999"
		@ prow(),79 PSAY _custo picture  "@E 999,999.999999"
		@ prow(),94 PSAY 100-((_custoant/_custo)*100) picture  "@E 9999.99"
		@ prow(),102 PSAY _quant*_custoant  picture  "@E 999,999,999.99"
		@ prow(),117 PSAY _quant*_custo  picture  "@E 999,999,999.99"
		@ prow(),132 PSAY _data
		_tquant+=_quant
		_tcustoant+=_custoant
		_tcusto+=_custo
		_ttcustoant+=_quant*_custoant
		_ttcusto+=_quant*_custo
	endif	
   tmp1->(dbskip())
end
@ prow()+2,00 PSAY "TOTAIS ====>"
@ prow(),94 PSAY 100-((_ttcustoant/_ttcusto)*100) picture  "@E 999.99%"
@ prow(),102 PSAY _ttcustoant  picture  "@E 999,999,999.99"
@ prow(),117 PSAY _ttcusto  picture  "@E 999,999,999.99"
@ prow()+1,101 PSAY "Acrescimo"
@ prow(),117 PSAY (_ttcusto)-(_ttcustoant)  picture  "@E 999,999,999.99"
@ prow()+1,101 PSAY "IGP-FGV"
@ prow(),117 PSAY mv_par07  picture  "@E 999,999,999.99%"
@ prow()+1,101 PSAY "Result.Periodo"            
_resper:=0
_resper:=round((100-((_ttcustoant/_ttcusto)*100)),2)-mv_par07
@ prow(),117 PSAY (100-((_ttcustoant/_ttcusto)*100))-mv_par07  picture  "@E 999,999,999.99%"
@ prow()+1,101 PSAY "Result.Mes"
@ prow(),117 PSAY (_ttcustoant)*(_resper/100) picture  "@E 999,999,999.99"

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
_cquery+=" B1_COD COD,B1_DESC DESCR,B1_LOCPAD LOCPAD,B1_TIPO TIPO"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
if mv_par11 = 1
	_cquery+=" AND B1_ESTOQUE='S'"
elseif mv_par11 = 2	
	_cquery+=" AND B1_ESTOQUE='N'"
endif
_cquery+=" ORDER BY B1_DESC"



_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
//tcsetfield("TMP1","DTDIGIT","D")
//tcsetfield("TMP1","EMISSAO","D")
//tcsetfield("TMP1","QUANT"  ,"N",15,3)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","IPCA               ?","mv_ch6","N",05,2,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
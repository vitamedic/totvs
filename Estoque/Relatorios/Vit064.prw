/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT064   ³ Autor ³ Gardenia              ³ Data ³ 07/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Movimentacao Interna                                       ³±±
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

user function VIT064()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="MOVIMENTACAO INTERNA "
cdesc1   :="Este programa ira emitir a relacao de entradas e saídas"
cdesc2   :="de acordo com os parametros"
cdesc3   :=""
cstring  :="SD1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT064"
wnrel    :="VIT064"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT064"
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
_cfilsa2:=xfilial("SA2")
_cfilsd1:=xfilial("SD1")
_cfilsd3:=xfilial("SD3")
_cfilsb2:=xfilial("SB2")
_cfilctt:=xfilial("CTT")

sb1->(dbsetorder(1))
sd1->(dbsetorder(3))
sd3->(dbsetorder(6))
sa2->(dbsetorder(1))
sb2->(dbsetorder(1))
ctt->(dbsetorder(1))

processa({|| _querys()})

cabec1:="Período: " + dtoc(mv_par01) + " a " + dtoc(mv_par02) 
cabec2:="DOC.   ENTRADA          SAIDA  VL.UNIT  VL.TOTAL  DATA    FORNEC/DPTO." 
//999999 999.999.999,99 999.999.999,99 99/99/99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"


setprc(0,0)

setregua(sb8->(lastrec()))
_nest :=0
_ntent :=0
_ntsai := 0
_ntvsai := 0
_ntvent := 0	
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	sb1->(dbseek(_cfilsb1+tmp1->produto))
	_locpad := sb1->b1_locpad
	@ prow()+2,000 PSAY left(tmp1->produto,10)+" - "+left(sb1->b1_desc,58)
//	@ prow()+1,000 PSAY ""
	_nquant  :=0
	_cproduto:=tmp1->produto    
	_nent :=0
	_nsai := 0
	_nvsai := 0
	_nvent := 0	
	while ! tmp1->(eof()) .and.;
		tmp1->produto==_cproduto .and.;
		lcontinua
		incregua()
		if labortprint
  			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
		@ prow()+1,000 PSAY tmp1->doc 
		if substr(tmp1->cf,1,1) =='R'
			@ prow(),020   PSAY tmp1->quant picture "@E 999,999,999"
			@ prow(),032   PSAY tmp1->vunit/tmp1->quant picture "@E 999,999.99"
			@ prow(),044   PSAY tmp1->vunit picture "@E 999,999.99"
			@ prow(),055 PSAY  tmp1->emissao
		   ctt->(dbseek(_cfilctt+tmp1->cc))
			@ prow(),065 PSAY "#"+ctt->ctt_desc01	
			_nsai += tmp1->quant
			_ntsai += tmp1->quant			
			_ntvsai += tmp1->vunit			
			_nvsai += tmp1->vunit			
		else
			@ prow(),008   PSAY tmp1->quant picture "@E 999,999,999"
			@ prow(),032   PSAY tmp1->vunit picture "@E 999,999.99"
			@ prow(),044   PSAY tmp1->vunit*tmp1->quant picture "@E 999,999.99"			
			@ prow(),055 PSAY  tmp1->emissao
			sa2->(dbseek(_cfilsa2+tmp1->fornece))
			@ prow(),065 PSAY sa2->a2_nome		
			_nent += tmp1->quant
			_ntent +=tmp1->quant		      
			_ntvent += tmp1->vunit*tmp1->quant					
			_nvent += tmp1->vunit*tmp1->quant			
			if sb1->b1_estoque='N'    
			  if !empty(tmp1->cc)
					@ prow()+1,020 PSAY tmp1->quant picture "@E 999,999,999"   
					@ prow(),032   PSAY tmp1->vunit picture "@E 999,999.99"
					@ prow(),044   PSAY tmp1->vunit*tmp1->quant picture "@E 999,999.99"				
					@ prow(),055 PSAY  tmp1->emissao
				   ctt->(dbseek(_cfilctt+tmp1->cc))
					@ prow(),065 PSAY "#"+ctt->ctt_desc01	
					_nsai += tmp1->quant
					_ntsai += tmp1->quant			
					_nvsai += tmp1->quant*tmp1->vunit													
				else	   
  					@ prow()+1,020   PSAY tmp1->quant picture "@E 999,999,999"
					@ prow(),055 PSAY  tmp1->emissao
					@ prow(),065 PSAY "Rateio %"
					_nsai += tmp1->quant
					_ntsai += tmp1->quant			
					_nvsai += tmp1->quant*tmp1->vunit								
				endif	
 			endif				  
		endif	
		tmp1->(dbskip())                                      
	end
	sb2->(dbseek(_cfilsb2+_cproduto+_locpad))
	@ prow()+1,000 PSAY "Qtde:"
	@ prow(),008  PSAY  _nent picture "@E 999,999,999"
	@ prow(),020  PSAY  _nsai picture "@E 999,999,999"
	@ prow(),040  PSAY  "Estoque Atual: "+TRANSFORM(sb2->b2_qatu,"@E 999,999,999.99")
	@ prow()+1,000 PSAY "Valor:"
	@ prow(),008  PSAY  _nvent picture "@E 99999,999.99"
	@ prow(),021  PSAY  _nvsai picture "@E 99999,999.99"
	_nest += sb2->b2_qatu
end
@ prow()+2,000 PSAY "T.Geral:"
@ prow(),008  PSAY  _ntent picture "@E 999,999,999"
@ prow(),020  PSAY  _ntsai picture "@E 999,999,999"
@ prow(),040  PSAY  "Estoque : "+TRANSFORM(_nest,"@E 999,999,999.99")
@ prow()+2,000 PSAY "V.Geral:"
@ prow(),008  PSAY  _ntvent picture "@E 999,999,999.99"
@ prow(),023  PSAY  _ntvsai picture "@E 999,999,999.99"

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


Static function _querys()
procregua(1)
incproc("Selecionando registros...")
cquery1:=        " SELECT D1_COD PRODUTO,D1_QUANT QUANT,D1_UM UM,D1_DOC DOC,D1_DTDIGIT EMISSAO,D1_FORNECE FORNECE,' ' CF,D1_CC CC,D1_VUNIT VUNIT"
cquery1:=cquery1+" FROM "+retsqlname("SD1")+" SD1"
cquery1:=cquery1+" WHERE D1_FILIAL='"+_cfilsd1+"'"
cquery1:=cquery1+" AND SD1.D_E_L_E_T_<>'*'"
cquery1:=cquery1+" AND D1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
cquery1:=cquery1+" AND D1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cquery1:=cquery1+" AND D1_TP BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cquery1:=cquery1+" AND D1_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
cquery1:=cquery1+" AND D1_CC BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
//cquery1:=cquery1+" AND D1_ORIGLAN<>'LF'"
//cquery1:=cquery1+" GROUP BY D1_COD,D1_TES"
cquery1:=cquery1+" UNION ALL"
cquery1:=cquery1+" SELECT D3_COD PRODUTO,D3_QUANT QUANT,D3_UM UM,D3_DOC DOC,D3_EMISSAO EMISSAO,' ' FORNECE,D3_CF CF ,D3_CC CC,D3_CUSTO1 VUNIT"
cquery1:=cquery1+" FROM "+retsqlname("SD3")+" SD3"
cquery1:=cquery1+" WHERE D3_FILIAL='"+_cfilsd3+"'"
cquery1:=cquery1+" AND SD3.D_E_L_E_T_<>'*'"
cquery1:=cquery1+" AND D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
cquery1:=cquery1+" AND D3_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cquery1:=cquery1+" AND D3_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cquery1:=cquery1+" AND D3_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
cquery1:=cquery1+" AND D3_CC BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
cquery1:=cquery1+" AND D3_LOCAL <> '98'"

//cquery1:=cquery1+" GROUP BY D2_COD,D2_TES"
cquery1:=cquery1+" ORDER BY 1,5"
cquery1:=changequery(cquery1)
tcquery cquery1 new alias "TMP1"
tcsetfield("TMP1","QUANT","N",12,3)
tcsetfield("TMP1","EMISSAO","D",8)
tcsetfield("TMP1","CCUSTO","N",8)
tcsetfield("TMP1","VUNIT","N",12,3)
return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da Data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a Data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Do tipo            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Ate o tipo         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"07","Do grupo           ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"08","Ate o grupo        ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"09","Do Centro de Custo ?","mv_ch9","C",09,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{cperg,"10","Ate Centro de Custo?","mv_chA","C",09,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})

	
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
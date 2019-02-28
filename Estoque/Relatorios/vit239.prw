/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT239   ³ Autor ³ Gardenia              ³ Data ³ 30/08/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Requisicoes por CC                                         ³±±
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

user function VIT239()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="REQUISIÇÕES PARA CONSUMO "
cdesc1   :="Este programa ira emitir a relacao de requisições para consumo por CC"
cdesc2   :=""
cdesc3   :=""
cstring  :="SD3"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT239"
wnrel    :="VIT239"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT239"
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
_cfilsd3:=xfilial("SD3")
_cfilctt:=xfilial("CTT")
sb1->(dbsetorder(3))
ctt->(dbsetorder(1))

processa({|| _querys()})

cabec1:="C.C      DESCRICAO                         CD.PROD DESCRICAO                          UM           QTDE   CST.UNITARIO     CST.TOTAL"    
//C.C      DESCRICAO                         CD.PROD DESCRICAO                          UM           QTDE   CST.UNITATIO      CST.TOTAL"    
//99999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 999,999,999.99 999,999,999.99 999,999,999.99
cabec2:=''



setprc(0,0)

setregua(sd3->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_cc:=tmp1->cc
	_tccquant:=0
	_tcccusto:=0
	_passoucc:=.f.
	while ! tmp1->(eof()) .and. _cc== tmp1->cc .and. ;
      lcontinua
   	_grupo:=tmp1->grupo
   	_tgquant:=0
   	_tgcusto:=0
		while ! tmp1->(eof()) .and. _cc== tmp1->cc .and. _grupo==tmp1->grupo .and. ;
	      lcontinua
			_produto:=tmp1->produto    
			_desc:=tmp1->descri
			_um:=tmp1->um
			_quant:=0         
			_custo1:=0
			while ! tmp1->(eof()) .and. _cc== tmp1->cc .and. _grupo==tmp1->grupo .and. ;
				tmp1->produto==_produto .and. lcontinua
				incregua()
				if tmp1->tm > "500"
					_quant+=tmp1->quant
					_custo1+=tmp1->custo1
				else	
					_quant-=tmp1->quant
					_custo1-=tmp1->custo1
				endif	
				tmp1->(dbskip())
				if labortprint
					@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
					lcontinua:=.f.
				endif
			end
			if prow()>53
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
			endif
//99999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 999,999,999.99 999,999.99999 999,999,999.99
			ctt->(dbseek(_cfilctt+_cc))
			if !_passoucc
				@ prow()+1,000 PSAY substr(_cc,1,9) 
				@ prow(),009   PSAY substr(ctt->ctt_desc01,1,30)
				@ prow(),044   PSAY substr(_produto,1,6)  
				_passoucc :=.t.
			else
				@ prow()+1,044   PSAY substr(_produto,1,6)  
			endif	
			@ prow(),051   PSAY substr(_desc,1,34)
			@ prow(),086   PSAY _um
			@ prow(),089   PSAY _quant   picture "@E 999,999,999.99"
			@ prow(),105   PSAY _custo1/_quant   picture "@E 999,999.99999"
			@ prow(),118   PSAY _custo1   picture "@E 999,999,999.99"
			_tccquant+=_quant
			_tcccusto+=_custo1
			_tgquant+=_quant
			_tgcusto+=_custo1
		end	
		if lcontinua
			@ prow()+1,044 PSAY "TOTAIS " +_grupo
			@ prow(),089   PSAY _tgquant   picture "@E 999,999,999.99"
			@ prow(),118   PSAY _tgcusto   picture "@E 999,999,999.99"
			@ prow()+1,00  PSAY  ""
      endif
	end
	if lcontinua 
		@ prow()+1,044 PSAY "TOTAIS CC"
		@ prow(),089   PSAY _tccquant   picture "@E 999,999,999.99"
		@ prow(),118   PSAY _tcccusto   picture "@E 999,999,999.99"
	   roda(cbcont,cbtxt)
//		@ prow()+1,000 PSAY replicate("-",limite)
	endif
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
_cquery+=" D3_COD PRODUTO,B1_DESC DESCRI,D3_QUANT QUANT,D3_EMISSAO EMISSAO,D3_CUSTO1 CUSTO1,"
_cquery+=" B1_UM UM,D3_CC CC,D3_GRUPO GRUPO,D3_TM TM"
_cquery+=" FROM "
_cquery+=  retsqlname("SD3")+" SD3,"
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SD3.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
_cquery+=" AND D3_COD=B1_COD"
_cquery+=" AND D3_ESTORNO<>'S'"
_cquery+=" AND D3_OP='             '"
_cquery+=" AND SUBSTR(D3_CF,2,1)='E'"
_cquery+=" AND D3_LOCAL  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND D3_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND D3_CC BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par11)+"' AND '"+dtos(mv_par12)+"'"
_cquery+=" ORDER BY D3_CC,D3_GRUPO,B1_DESC"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","CUSTO1"  ,"N",15,5)
tcsetfield("TMP1","QUANT","N",15,2)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Armazem            ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem      ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do CC              ?","mv_ch9","C",09,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{cperg,"10","Ate o CC           ?","mv_chA","C",09,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{cperg,"11","Da data            ?","mv_chB","D",08,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Ate a data         ?","mv_chC","D",08,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
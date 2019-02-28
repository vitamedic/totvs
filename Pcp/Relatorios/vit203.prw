/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT203   ³Autor ³ Aline                 ³Data ³ 30/06/04   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Movimentacao de Produtos                        ³±±
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

user function VIT203()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="RELACAO DE MOVIMENTOS - ANALITICO "
cdesc1   :="Este programa ira emitir a movimentação sintética do período"
cdesc2   :="Entrada de PA e saídas dos demais tipos de acordo com os parâmetros"
cdesc3   :=""
cstring  :="SD3"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT203"
wnrel    :="VIT203"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)                       
lcontinua:=.t.

cperg:="PERGVIT203"
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
_cfilsc2:=xfilial("SC2")
sb1->(dbsetorder(1))
sd3->(dbsetorder(1))
sc2->(dbsetorder(1))
/*
_cindsd3:=criatrab(,.f.)
_cchave :="D3_FILIAL+D3_OP+D3_COD+DTOS(D3_EMISSAO)+D3_DOC"

sd3->(indregua("SD3",_cindsd3,_cchave,,,))
*/
processa({|| _querys()})

cabec1:="Periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
cabec2:="Data          Quantidade UN   Custo Total Ord.Producao Codg.     Descricao               Qtde.Apont. Un  Tipo   Perda"

setprc(0,0)

setregua(sd3->(lastrec()))

tmp1->(dbgotop())
_nquant :=0
_nval   :=0
_nqtot  :=0
_ntquant :=0
_ntval := 0
_ntot := _nperd := 0
_ntperd := 0
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif        
	incregua()
	_nquant  :=0
	_nqtsegum:=0
	_cproduto:=tmp1->produto
	_cdescpro:=tmp1->descri
	_nperda := 0                
	@ prow()+2,000 PSAY _cproduto+" - "+left(_cdescpro,30)
	while ! tmp1->(eof()) .and.;
			tmp1->produto==_cproduto .and.;
			lcontinua                      
//  			sd3->(dbseek(_cfilsd3+_cproduto))
	
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
 		@ prow()+1,000 PSAY tmp1->emissao
		@ prow(),009   PSAY tmp1->quant   picture "@E 999,999,999.999"
		@ prow(),025   PSAY tmp1->um
		@ prow(),028   PSAY tmp1->valor   picture "@E 999,999.99999"
		@ prow(),042   PSAY tmp1->op
		sc2->(dbseek(_cfilsc2+tmp1->op))
		sb1->(dbseek(_cfilsb1+sc2->c2_produto))
		
		_cquery:=" SELECT"
		_cquery+=" D3_QUANT QUANT,"
		_cquery+=" D3_UM UM,"
		_cquery+=" D3_PARCTOT PARCTOT,"
		_cquery+=" D3_PERDA PERDA"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SD3")+" SD3"
		_cquery+=" WHERE"
		_cquery+="     SD3.D_E_L_E_T_<>'*'"
		_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
		_cquery+=" AND D3_OP='"+tmp1->op+"'"
		_cquery+=" AND D3_COD='"+sc2->c2_produto+"'"
		_cquery+=" AND D3_EMISSAO='"+dtos(tmp1->emissao)+"'"
		_cquery+=" AND D3_DOC='"+tmp1->doc+"'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP2"
		tcsetfield("TMP2","QUANT","N",12,2)
		tcsetfield("TMP2","PERDA","N",12,2)
		
		tmp2->(dbgotop())
		@ prow(),055  PSAY substr(sb1->b1_cod,1,6)
		@ prow(),065  PSAY substr(sb1->b1_desc,1,20)
		@ prow(),088  PSAY tmp2->quant picture "@E 999,999.99"
		@ prow(),100  PSAY tmp2->um
		@ prow(),105  PSAY tmp2->parctot		                   
		@ prow(),108  PSAY tmp2->perda picture "@E 999,999.99"		                   				
			
		_nquant  +=tmp1->quant
		_nval    +=tmp1->valor
		_nqtot   +=tmp2->quant
		_nperd   +=tmp2->perda
		
		tmp2->(dbclosearea())
		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
	end
	if !empty(_nquant) .and. lcontinua
		@ prow()+1,000 PSAY "Totais"
		@ prow(),009   PSAY _nquant   picture "@E 999,999,999.99"
		@ prow(),028   PSAY _nval   picture   "@E 999,999,999.99"
		@ prow(),085   PSAY _nqtot picture    "@E 999,999,999.99"	
		@ prow(),103   PSAY _nperd picture    "@E 999,999,999.99"
		_ntquant += _nquant
		_ntval += _nval
      _ntot += _nqtot                                          
      _ntperd += _nperd
	endif
end
if lcontinua
	@ prow()+2,000 PSAY "Tot.Geral"
	@ prow(),009   PSAY _ntquant   picture "@E 999,999,999.99"
	@ prow(),028   PSAY _ntval   picture "@E 999,999,999.99"
	@ prow(),085   PSAY _ntot   picture "@E 999,999,999.99"
	@ prow(),103   PSAY _ntperd   picture "@E 999,999,999.99"
endif
if prow()>0 .and.;
	lcontinua
   roda(cbcont,cbtxt)
endif

//sd3->(retindex("SD3"))
//ferase(_cindsd3)    

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
_cquery+=" D3_COD PRODUTO,B1_DESC DESCRI,D3_EMISSAO EMISSAO,D3_QUANT QUANT,D3_CF CF,D3_CUSTO1 VALOR,"
_cquery+=" B1_UM UM,D3_OP OP,B1_SEGUM SEGUM,B1_TIPO TIPO,D3_PERDA PERDA,D3_DOC DOC"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SD3")+" SD3"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"

_cquery+=" AND SD3.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
_cquery+=" AND D3_COD=B1_COD"
_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND D3_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND D3_ESTORNO<>'S'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" ORDER BY B1_DESC,D3_EMISSAO,D3_OP"

//_cquery+=" AND D3_CF IN ('PR0','RE0','RE1','RE2','RE4')"
//_cquery+=" AND D3_TM<>'508'"

_cquery:=changequery(_cquery)
         
tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","QUANT"  ,"N",15,3)
tcsetfield("TMP1","VALOR","N",15,3)
tcsetfield("TMP1","PERDA","N",15,3)
tcsetfield("TMP1","DOC","C",6,0)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Do tipo            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Ate o tipo         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"07","Do grupo           ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"08","Ate o grupo        ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
	
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
Data      Quantidade         Valor     OP       Descricao OP                    Qtde.Apont. Unid
99/99/99 999,999.999 999,999.99999 xxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999,999.999  xx
*/
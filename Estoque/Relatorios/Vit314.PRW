/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT314   ³ Autor ³ Nycksion              ³ Data ³ 28/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Produtos                                        ³±±
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
mv_par03 Do produto
mv_par04 Ate o produto
mv_par05 Do grupo
mv_par06 Ate a grupo
mv_par07 Do Almox
mv_par08 Ate Almox
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT314()
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="RELACAO DE PRODUTOS SEM MOVIMENTAÇÃO"
cdesc1   :="Este programa ira emitir a relacao de Produtos sem movimentação no período"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB2"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT314"
wnrel    :="VIT314"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT314"
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

processa({|| _querys()})

cabec1:="PRODUTOS SEM MOVIMENTAÇÃO ENTRE :" +dtoc(mv_par01)+" A "+dtoc(mv_par02)+;
" / PRODUTO :"+MV_PAR03+" A "+MV_PAR04+" / GRUPO :"+MV_PAR05+" A "+MV_PAR06+;
" / ALMOXARIFADO :"+mv_par07+" A "+mv_par08
cabec2:="FILIAL PRODUTO DESCRIÇÃO                         GRUPO  UM  AL  ULT MOV    QTDE ATUAL  VALOR ATUAL"
//       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                 10        20        30        40        50        60        70        80        90
//       99     999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX       999  XX  99  99/99/99  99999  999.999,99

setprc(0,0)

setregua(sb1->(lastrec()))
dbselectarea("sb1")
sb1->(dbsetorder(1))
sb1->(dbgotop())
//tmpb1->(dbclosearea())
dbselectarea("sb2")
sb2->(dbsetorder(1))
sb2->(dbgotop())   
//tmpb2->(dbclosearea())

//dbselectarea("tmpb1")
while !sb1->(eof()) .and. lcontinua
	if (sb1->b1_cod>=MV_PAR03 .and. sb1->b1_cod<=MV_PAR04)
		produto := sb1->b1_cod
		if prow()==0 .or. prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
		sb2->(dbseek(_cfilsb2+produto))
		while	!sb2->(eof()) .and. produto==sb2->b2_cod .and. (sb2->b2_cod>=MV_PAR03 .and. sb2->b2_cod<=MV_PAR04)
			if sb2->b2_local>=mv_par07 .and. sb2->b2_local<=mv_par08
				if sb2->b2_usai<=mv_par01 .or. sb2->b2_usai>=mv_par02
					@ prow()+1,000 PSAY sb1->b1_filial
					@ prow()  ,007 PSAY sb1->b1_cod
					@ prow()  ,015 PSAY sb1->b1_desc
					@ prow()  ,051 PSAY sb1->b1_grupo
					@ prow()  ,057 PSAY sb1->b1_um
					@ prow()  ,061 PSAY sb2->b2_local
					@ prow()  ,064 PSAY sb2->b2_usai
					@ prow()  ,078 PSAY transform(sb2->b2_qatu,"@E 9999")
					@ prow()  ,084 PSAY transform(sb2->b2_vatu1,"@E 9,999,999.99")
				endif	
			end
			sb2->(dbskip())
		end
		sb1->(dbskip())
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
	else
		sb1->(dbskip())		
	endif
end

if prow()>0 .and.;
	lcontinua
   roda(cbcont,cbtxt)
endif

sb1->(dbclosearea())
sb2->(dbclosearea())

set device to screen

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endIf

ms_flush()
return

static function _querys()
/*_cquery1:=" SELECT"
_cquery1+=" B1_FILIAL, B1_COD PRODUTO, B1_DESC DESCRI, B1_GRUPO GRUPO, B1_UM UM"
_cquery1+=" FROM "
_cquery1+=  retsqlname("SB1")+" SB1,"
_cquery1+=" WHERE"
_cquery1+="     SB1.D_E_L_E_T_<>'*'"
_cquery1+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery1+=" AND B1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery1+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"

_cquery1:=changequery(_cquery1)
tcquery _cquery1 new alias "TMPB1"

_cquery2:=" SELECT"
_cquery2+=" B2_COD CODB2, B2_LOCAL ALMOXB2, B2_USAI ULTSAIB2"
_cquery2+=" FROM "
_cquery2+=  retsqlname("SB2")+" SB2"
_cquery2+=" WHERE"
_cquery2+="     SB2.D_E_L_E_T_<>'*'"
_cquery2+=" AND B2_FILIAL='"+_cfilsb2+"'"
_cquery2+=" AND B2_USAI BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(mv_par02)+"'"

_cquery2:=changequery(_cquery2)
tcquery _cquery2 new alias "TMPB2"*/
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da Data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a Data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
	
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
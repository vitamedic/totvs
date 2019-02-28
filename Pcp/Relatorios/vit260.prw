/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT260   ³Autor ³ Alex Júnio de Miranda ³Data ³ 03/03/06   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Empenhos de Produtos por Ordem de Produção e Quantidade    ³±±
±±³          ³ Entregue.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit260()
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="EMPENHOS DE ORDENS DE PRODUCAO"
cdesc1  :="Este programa ira emitir os empenhos de produtos por Ordem de Produção"
cdesc2  :="já entregue e ainda empenhados"
cdesc3  :=""
cstring :="SD4"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT260"
wnrel   :="VIT260"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)

cperg:="PERGVIT260"
_pergsx1()
pergunte(cperg,.f.)


wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)

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
_cfilsd4:=xfilial("SD4")
_cfilsb1:=xfilial("SB1")
_cfilsc2:=xfilial("SC2")
sd4->(dbsetorder(2))
sb1->(dbsetorder(1))
sc2->(dbsetorder(1))

processa({|| _querys()})

cabec1:="Periodo: "+dtoc(mv_par05)+" a "+dtoc(mv_par06)
if mv_par08==1
  cabec2:="PRODUTO  SEQUEN.  DESC                                      ARM. LOTE        DATA          EMP. TOTAL    EMP.ENTREGUE"
elseif mv_par08==2
  cabec2:="PRODUTO  SEQUEN.  DESC                                      ARM. LOTE        DATA          EMP. TOTAL    EMP.PENDENTE"
else
  cabec2:="PRODUTO  SEQUEN.  DESC                                      ARM. LOTE        DATA          QTDE. TOTAL   EMP.ENTREGUE   EMP.PENDENTE"
endif

setprc(0,0)
@ 000,000 PSAY avalimp(133)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif
	
	_op:= tmp1->op
	sb1->(dbseek(_cfilsb1+tmp1->produto)) 
	@ prow()+1,000 PSAY "OP: "+_op+" - "
	@ prow(),019   PSAY sb1->b1_desc

	while (tmp1->op==_op) .and.;
			lcontinua .and. !eof()
		
 	   if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
		@ prow()+1,000 PSAY SUBSTR(tmp1->cod,1,6)
		@ prow(),010   PSAY tmp1->trat
		@ prow(),018   PSAY tmp1->descr
		@ prow(),060   PSAY tmp1->local
		@ prow(),065   PSAY tmp1->lote
		@ prow(),077   PSAY dtoc(tmp1->data)
		@ prow(),087   PSAY tmp1->qtdeori picture "@E 99,999,999.9999"  //quantidade de empenho original

		if mv_par08==1
			@ prow(),102  PSAY (tmp1->qtdeori - tmp1->empenho) picture "@E 99,999,999.9999"  //quantidade de empenho já entregue
		elseif mv_par08==2
			@ prow(),102  PSAY tmp1->empenho picture "@E 99,999,999.9999"  //quantidade de empenho pendente
		else
			@ prow(),102  PSAY (tmp1->qtdeori - tmp1->empenho) picture "@E 99,999,999.9999"  //quantidade de empenho já entregue  
			@ prow(),117  PSAY tmp1->empenho picture "@E 99,999,999.9999" //quantidade de empenho pendente
		endif

		tmp1->(dbskip())
		if prow()==0 .or. prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
		endif

	end                                 
	@ prow()+1,000 PSAY " "	
end


if prow()>0 .and. lcontinua
	roda(cbcont,cbtxt)
endif

tmp1->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

static function _querys()
_cquery:=" SELECT"
_cquery+=" D4_OP OP,"
_cquery+=" C2_PRODUTO PRODUTO,"
_cquery+=" D4_COD COD,"                  
_cquery+=" D4_TRT TRAT,"
_cquery+=" B1_DESC DESCR,"
_cquery+=" D4_LOCAL LOCAL,"
_cquery+=" D4_LOTECTL LOTE,"
_cquery+=" D4_DATA DATA,"
_cquery+=" D4_QTDEORI QTDEORI,"
_cquery+=" D4_QUANT EMPENHO"
_cquery+=" FROM "

_cquery+=  retsqlname("SD4")+" SD4,"
_cquery+=  retsqlname("SC2")+" SC2,"
_cquery+=  retsqlname("SB1")+" SB1"

_cquery+=" WHERE"                   
_cquery+="     SD4.D_E_L_E_T_<>'*'"
_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SC2.D_E_L_E_T_<>'*'"
_cquery+=" AND D4_FILIAL='"+_cfilsd4+"'"
_cquery+=" AND B1_FILIAL='"+_cfilsc2+"'"
_cquery+=" AND C2_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND D4_OP BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND D4_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND SUBSTR(D4_COD,1,3)<>'MOD'"
_cquery+=" AND D4_COD=B1_COD"
_cquery+=" AND D4_DATA BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"

if mv_par08==2
	_cquery+=" AND D4_QUANT>0"
endif

_cquery+=" AND SUBSTR(D4_OP,1,6)=C2_NUM"
_cquery+=" AND SUBSTR(D4_OP,7,2)=C2_ITEM"
_cquery+=" AND SUBSTR(D4_OP,9,3)=C2_SEQUEN"

if (mv_par07==1) .or. (mv_par07==2)
	_cquery+=" AND D4_OP IN "
  	_cquery+=" (SELECT"
	_cquery+=" C2_NUM||C2_ITEM||C2_SEQUEN||C2_ITEMGRD NUMOP"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC2")+" SC2"
	_cquery+=" WHERE"
	_cquery+="     SC2.D_E_L_E_T_<>'*'"
	_cquery+=" AND C2_FILIAL='"+_cfilsc2+"'"

	if (mv_par07==1)
	  _cquery+=" AND C2_DATRF='        ') "
	elseif (mv_par07==2)
	  _cquery+=" AND C2_DATRF<>'        ') "
	endif
	
endif
_cquery+=" ORDER BY 1,3,4"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"    
tcsetfield("TMP1","DATA","D")
tcsetfield("TMP1","QTDEORI","N",12,4)
tcsetfield("TMP1","EMPENHO","N",12,4)

return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da O.P.            ?","mv_ch1","C",13,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC2"})
aadd(_agrpsx1,{cperg,"02","Ate a O.P.         ?","mv_ch2","C",13,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC2"})
aadd(_agrpsx1,{cperg,"03","Do Produto         ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o Produto      ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Da Data            ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate a Data         ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Considera OP´s     ?","mv_ch7","N",01,0,0,"C",space(60),"mv_par07"       ,"Abertas"        ,space(30),space(15),"Encerradas"     ,space(30),space(15),"Ambas"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Considera Empenhos ?","mv_ch8","N",01,0,0,"C",space(60),"mv_par08"       ,"Entregues"      ,space(30),space(15),"Pendentes"      ,space(30),space(15),"Ambos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
LAYOUT DO RELATORIO

PRODUTO  SEQUEN.  DESC                                     ARM. LOTE        DATA        QTDE. TOTAL   EMP.PENDENTE  EMP. ENTREGUE
OP: 99999999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 
    D4_OP			B1_DESC
999999   999     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99   9999999999  99/99/99  99.999.999,99  99.999.999,99  99.999.999,99
D4_COD   D4_TRT  B1_DESC                                 D4_LOCAL D4_LOTECTL D4_DATA   D4_QTDEORI		D4_QUANT		 (D4_QTDEORI-D4_QUANT)  
*/

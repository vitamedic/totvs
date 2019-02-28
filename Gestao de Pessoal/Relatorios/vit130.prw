/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT130   ³ Autor ³ Gardenia              ³ Data ³ 17/03/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Despesas com Unimed                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT130()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="DESPESAS COM UNIMED "
cdesc1   :="Este programa ira emitir as despesas com UNIMED"
cdesc2   :=""
cdesc3   :=""
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT130"
wnrel    :="VIT130"+Alltrim(cusername)
alinha   :={}
aordem  :={"Alfabetica","Codigo Unimed"}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT130"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.f.,tamanho,"",.f.)

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

static function rptdetail()
_cfilsra:=xfilial("SRA")
_cfilsrx:=xfilial("SRX")
_cfilsrd:=xfilial("SRD")
_cfilsrc:=xfilial("SRC")
sra->(dbsetorder(1))
srd->(dbsetorder(1))
src->(dbsetorder(2))
srx->(dbsetorder(2))

processa({|| _querys()})

cabec1:="Mês/Ano: "+substr(mv_par05,5,2)+"/"+substr(mv_par05,1,4)
cabec2:="Cod.Unimed Matric. Nome                                      CC Lanc. Qtd.Depen. Funcionario    Dependente      Empresa   Vl. Pago "
//Cod.Unimed Matric. Nome                                     CC Lanc  Qtd.Depen. Funcionario    Dependente      Empresa   Vl. Pago 
//999999     999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999999    999.999  999,999.99    999,999.99   999,999.99 999,999.99 



setprc(0,0)

setregua(sra->(lastrec()))

tmp1->(dbgotop())

_unimed:=0
_peruni:=0
_unimeddep:=0
_unimedfun:=0
_unimedemp:=0
_vlpago:=0 
_cclanc:=""

_tunimeddep:=0
_tunimedfun:=0
_tunimedemp:=0
_tvlpago:=0


while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	incregua()
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
	srx->(dbseek("22"+"01"+strzero(val(tmp1->asmedic),2,0)))
	srd->(dbseek(_cfilsrd+tmp1->mat+mv_par05+"256"+"   "))
	src->(dbseek(_cfilsrd+tmp1->cc+tmp1->mat+"256"+"   "))
	
	_unimed:=val(substr(srx->rx_txt,27,6))         
	_peruni:=(val(substr(srx->rx_txt,46,6)))/100
//	_unimeddep:=_unimed*val(tmp1->dpassme)*_peruni                         
	_unimeddep:=val(substr(srx->rx_txt,39,6))*val(tmp1->dpassme)*_peruni                         
	_unimedfun:=_unimed*_peruni
//	_unimedemp:=_unimed*(val(tmp1->dpassme)+1)-(_unimedfun+_unimeddep)
	_unimedemp:=_unimed+(val(substr(srx->rx_txt,39,6))*val(tmp1->dpassme))-(_unimedfun+_unimeddep)

	if empty(tmp1->asmedic)
	  _unimed:=0
	endif  

	if srd->rd_valor<=0
		_valor:=src->rc_valor
		_cclanc:=src->rc_cc
	else
		_valor:=srd->rd_valor
		_cclanc:=srd->rd_cc
	endif	
//Cod.Unimed Matric. Nome                                      CC Lanc. Qtd.Depen. Funcionario    Dependente      Empresa   Vl. Pago 
//999999     999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99999999    999.999  999,999.99    999,999.99   999,999.99 999,999.99 
	if (_valor >0 .or. alltrim(tmp1->asmedic)='11')
		@ prow()+1,000 PSAY tmp1->unimed
		@ prow(),011 PSAY tmp1->mat
		@ prow(),019 PSAY tmp1->nome
		@ prow(),061 PSAY _cclanc
		@ prow(),073 PSAY tmp1->dpassme picture "999999" 
		@ prow(),082 PSAY _unimedfun picture "@E 999,999.99" 
		@ prow(),096 PSAY _unimeddep picture "@E 999,999.99" 
		@ prow(),109 PSAY _unimedemp picture "@E 999,999.99" 
		_vlpago:=_unimedfun+_unimeddep+_unimedemp
		@ prow(),120 PSAY _vlpago picture "@E 999,999.99" 
		_tunimeddep+=_unimeddep
		_tunimedfun+=_unimedfun
		_tunimedemp+=_unimedemp
		_tvlpago+=_vlpago
	endif	
	tmp1->(dbskip())
	end
	@ prow()+1,004 PSAY "TOTAIS ====>"
	@ prow(),082 PSAY _tunimedfun picture "@E 999,999.99" 
	@ prow(),096 PSAY _tunimeddep picture "@E 999,999.99" 
	@ prow(),109 PSAY _tunimedemp picture "@E 999,999.99" 
	@ prow(),120 PSAY _tvlpago picture "@E 999,999.99" 


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
_cquery+=" RA_UNIMED UNIMED,RA_MAT MAT,RA_NOME NOME,RA_CC CC,"
_cquery+=" RA_DPASSME DPASSME, RA_ASMEDIC ASMEDIC,RA_COMIS COMIS"
_cquery+=" FROM "
_cquery+=  retsqlname("SRA")+" SRA"
_cquery+=" WHERE"
_cquery+="     SRA.D_E_L_E_T_<>'*'"
_cquery+=" AND RA_FILIAL='"+_cfilsra+"'"
_cquery+=" AND RA_MAT  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND RA_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"

if (nordem==1)  						// ORDEM ALFABÉTICA
	_cquery+=" ORDER BY RA_NOME, RA_UNIMED"	
else 
	_cquery+=" ORDER BY RA_UNIMED,RA_NOME"
endif

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","SALARIO"  ,"N",15,3)
tcsetfield("TMP1","EXTRA"  ,"N",15,3)
tcsetfield("TMP1","COMIS"  ,"N",15,3)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da Matricula       ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"02","Ate a matricula    ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"03","Do Centro de Custo ?","mv_ch3","C",09,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
aadd(_agrpsx1,{cperg,"04","Ate Centro de Custo?","mv_ch4","C",09,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
aadd(_agrpsx1,{cperg,"05","Ano/mes            ?","mv_ch5","C",06,2,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
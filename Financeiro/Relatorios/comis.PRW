/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ COMIS   ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emitir a Relacao de Comissao por Vendedor                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function comis()
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="COMISSAO POR VENDEDOR"
cdesc1   :="Este programa ira emitir a relacao de comissao por vendedor"
cdesc2   :=""
cdesc3   :=""
cstring  :="SE3"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}    
nomeprog :="COMIS1"
wnrel    :="COMIS1"
alinha   :={} 
aordem   :={"Nome do cliente","Data de baixa"}
nlastkey :=0
lcontinua:=.t.

cperg:="COMIS1"
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

rptstatus({|| rptdetail()},titulo)
return

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:="PERIODO DE "+dtoc(mv_par03)+" A "+dtoc(mv_par04)
cabec2:="CLIENTE   NOME                                     PRF NUMERO P TIPO BAIXA     EMISSAO             VALOR   PERC     VLR COMISSAO"

_cfilsa1:=xfilial("SA1")
_cfilse3:=xfilial("SE3")
_cfilsa3:=xfilial("SA3")
_cfilse1:=xfilial("SE1")

sa1->(dbsetorder(1))
se3->(dbsetorder(1))
sa3->(dbsetorder(1))
se1->(dbsetorder(1))

processa({|| _querys()})

setprc(0,0)

setregua(se3->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
		lcontinua
	incregua()
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif
   _ncomis:=0
   _xtotcom:=0
	_ntotrep:=0
	_crepres:=tmp1->repres
	sa3->(dbseek(_cfilsa3+_crepres))
	@ prow()+2,000 PSAY "Vendedor: "+_crepres+" - "+left(sa3->a3_nome,40)
	while ! tmp1->(eof()) .and.;
			tmp1->repres==_crepres .and.;
			lcontinua
		if prow()>52
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		endif
		if nordem==1
			_ntotcli:=0
			_ccliente:=tmp1->cliente
			_cloja   :=tmp1->loja
			@ prow()+1,000 PSAY ""
			while ! tmp1->(eof()) .and.;
					tmp1->repres==_crepres .and.;
					tmp1->cliente==_ccliente .and.;
					tmp1->loja==_cloja .and.;
					lcontinua
				_implinha()
				_ntotcli+=tmp1->valor
				tmp1->(dbskip())
				if labortprint
					@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
					lcontinua:=.f.
				endif
			end
			@ prow()+1,000 PSAY "TOTAL DO CLIENTE"
			@ prow(),091   PSAY _ntotcli picture "@E 999,999,999.99"
			_ntotrep+=_ntotcli
		else
			_ntotdia:=0 
			_xcomdia:=0
			_dvencrea:=tmp1->emissao
			@ prow()+1,000 PSAY ""
			while ! tmp1->(eof()) .and.;
					tmp1->repres==_crepres .and.;
					tmp1->emissao==_dvencrea .and.;
					lcontinua
				_implinha()
				_ntotdia+=tmp1->valor
				_xcomdia:=(_ntotdia*tmp1->perc/100)
				tmp1->(dbskip())
				if labortprint
					@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
					lcontinua:=.f.
				endif
			end
			@ prow()+1,000 PSAY "TOTAL DO DIA"
			@ prow(),091   PSAY _ntotdia picture "@E 999,999,999.99"
			@ prow(),115   PSAY _xcomdia picture "@E 999,999,999.99"
			_ntotrep+=_ntotdia   
			_xtotcom+=_xcomdia  
			
		endif 
	end
	@ prow()+2,000 PSAY "TOTAL DO VENDEDOR "+_crepres
	@ prow(),091   PSAY _ntotrep picture "@E 999,999,999.99"  
	@ prow(),115   PSAY _xtotcom picture "@E 999,999,999.99"
		@ prow()+1,000 PSAY replicate("-",limite)
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

static function _implinha()
@ prow()+1,000 PSAY tmp1->cliente+"/"+tmp1->loja
@ prow(),010   PSAY tmp1->nome
@ prow(),051   PSAY tmp1->prefixo
@ prow(),055   PSAY tmp1->numero
@ prow(),062   PSAY tmp1->parcela
@ prow(),065   PSAY tmp1->tipo
@ prow(),069   PSAY tmp1->emissao
@ prow(),080   PSAY tmp1->emis1
@ prow(),091   PSAY tmp1->valor picture "@E 999,999,999.99" 
@ prow(),105   PSAY tmp1->perc picture "@E 999.99"   
_ncomis:=(tmp1->valor*tmp1->perc/100)
@ prow(),115   PSAY _ncomis picture "@E 999,999,99.99"

if prow()>54
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
endif
return

static function _querys()
procregua(1)

incproc("Selecionando titulos...")

_cquery:=" SELECT"
_cquery+=" E3_VEND REPRES,E3_CODCLI CLIENTE,E3_LOJA LOJA,A1_NOME NOME,E3_PORC PERC,"
_cquery+=" E3_PREFIXO PREFIXO,E3_NUM NUMERO,E3_PARCELA PARCELA,E3_TIPO TIPO,E1_EMISSAO emis1,"
_cquery+=" E3_EMISSAO EMISSAO,E3_VENCTO VENCREA,E3_BASE VALOR"
_cquery+=" FROM "
_cquery+=  retsqlname("SA1")+" SA1,"
_cquery+=  retsqlname("SE3")+" SE3," 
_cquery+=  retsqlname("SE1")+" SE1"
_cquery+=" WHERE"
_cquery+="     SA1.D_E_L_E_T_<>'*'"
_cquery+=" AND SE3.D_E_L_E_T_<>'*'"
_cquery+=" AND SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND A1_FILIAL='"+_cfilsa1+"'"
_cquery+=" AND E3_FILIAL='"+_cfilse3+"'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E3_CODCLI=A1_COD"
_cquery+=" AND E3_LOJA=A1_LOJA"     
_cquery+=" AND E3_CODCLI=E1_CLIENTE"
_cquery+=" AND E3_LOJA=E1_LOJA"   
_cquery+=" AND E3_NUM=E1_NUM" 
_cquery+=" AND E3_PREFIXO = E1_PREFIXO"    
_cquery+=" AND E3_PARCELA=E1_PARCELA"
_cquery+=" AND E3_VEND BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND E3_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
_cquery+=" AND E1_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"

if nordem==1
	_cquery+=" ORDER BY E3_VEND"
else
	_cquery+=" ORDER BY E3_VEND,E3_EMISSAO,E1_EMISSAO"
endif

_cquery:=changequery(_cquery)

tcquery _cquery alias "TMP1" new
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","VENCREA","D") 
tcsetfield("TMP1","EMIS1","D")
tcsetfield("TMP1","VALOR"  ,"N",12,2) 
tcsetfield("TMP1","PERC"  ,"N",6,2) 

return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do vendedor        ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"02","Ate o vendedor     ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"03","Da Baixa           ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a Baixa        ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da Emissao         ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate a Emissao      ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
REPRESENTANTE: 999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
CLIENTE   NOME                                     PRF NUMERO P TIPO EMISSAO  VENCTO. REAL          VALOR ATRASO
999999/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX 999999 X  XXX 99/99/99   99/99/99   999.999.999,99 999999
*/

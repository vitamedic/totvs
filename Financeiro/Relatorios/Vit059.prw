/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT059   ³ Autor ³ Gardenia              ³ Data ³ 07/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Bordero de Titulos Enviados ao Banco                       ³±±
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
mv_par03 Do bordero 
mv_par04 Ate o bordero
mv_par05 Do banco
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT059()
nordem   :=""
tamanho  :="P"
limite   :=79
titulo   :="BORDERO DE TITULOS ENVIADOS AO BANCO"
cdesc1   :="Este programa ira emitir o bordero de titulos enviados ao banco"
cdesc2   :=""
cdesc3   :=""
cstring  :="SE1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT059"
wnrel    :="VIT059"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT059"
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
_cfilsa1:=xfilial("SA1")
_cfilse1:=xfilial("SE1")
_cfilsa6:=xfilial("SA6")
_cfilsx5:=xfilial("SX5")
sa1->(dbsetorder(1))
se1->(dbsetorder(1))
sa6->(dbsetorder(1))
sx5->(dbsetorder(1))


processa({|| _querys()})

cabec1:="Periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
cabec2:="Titulo             Emissao    Venc.Real            Valor      CGC Cliente"

setprc(0,0)

setregua(sc9->(lastrec()))
@ 000,000 PSAY avalimp(79)

tmp1->(dbgotop())
_totger :=0
_nconta:=0
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_numbor :=tmp1->numbor    
	_portado :=tmp1->portado
	sa6->(dbseek(_cfilsa6+_portado+mv_par06))
   sx5->(dbseek(_cfilsx5+"07"+tmp1->situaca))
   @ prow()+2 ,00 PSAY "Bordero: "+ tmp1->numbor
   @ prow(),16 PSAY "Banco: "+tmp1->portado + "-"+substr(sa6->a6_nome,1,30)+ "  Agencia: " + sa6->a6_agencia 
   @ prow()+1,00 PSAY "Situacao:" +  substr(sx5->x5_descri,1,30)
   @ prow()+1,00 PSAY " "
   _total :=0
	while ! tmp1->(eof()) .and.;
			tmp1->numbor==_numbor .and.;
			lcontinua
		incregua()
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif                   
//Titulo             Emissao   Venc.Real            Valor    CGC
//xxx 999999999-x    99/99/99  99/99/99   999,999,999.99
		sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
		_nconta++
		@ prow()+1,000 PSAY tmp1->prefixo
		@ prow(),005 PSAY tmp1->num
		@ prow(),015 PSAY tmp1->parcela
		@ prow(),019 PSAY tmp1->emissao
		@ prow(),030 PSAY tmp1->vencrea
		@ prow(),041 PSAY tmp1->valor picture "@E 999,999,999.99"
		@ prow(),060 PSAY sa1->a1_cgc picture "@R 99.999.999/9999-99"
		
		_total += tmp1->valor
		_totger += tmp1->valor
		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
	end
//999999   X  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99  XXXXXXXXXXXXXXXXXXXX   999,999,999.99   999999
	@ prow()+2,000 PSAY "Total borderô ==============>"
	@ prow(),41 PSAY _total picture "@E 999,999,999.99"
end
if lcontinua
	@ prow()+2,000 PSAY "Total Geral ================>"
	@ prow(),41 PSAY _totger picture "@E 999,999,999.99"
	@ prow()+2,000 PSAY "Total de títulos ===========>"
	@ prow(),44 PSAY _nconta picture "@E 999,999,999"
	@ prow()+1,000 PSAY replicate("-",limite)
endif
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
_cquery+=" E1_PORTADO PORTADO,E1_SITUACA SITUACA,E1_NUM NUM,E1_PREFIXO PREFIXO,E1_NUMBOR NUMBOR,"
_cquery+=" E1_PARCELA PARCELA,E1_EMISSAO EMISSAO,E1_VENCREA VENCREA,E1_VALOR VALOR,E1_CLIENTE CLIENTE,E1_LOJA LOJA "
_cquery+=" FROM "
_cquery+=  retsqlname("SE1")+" SE1"
_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_VENCREA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND E1_NUMBOR BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND E1_PORTADO BETWEEN '"+mv_par05+"' AND '"+mv_par05+"'"
//_cquery+=" AND E1_PORTADO='"+mv_par05+"'"
_cquery+=" ORDER BY E1_NUMBOR,E1_VENCREA,E1_PREFIXO,E1_NUM,E1_PARCELA"
//_cquery+=" ORDER BY E1_NUMBOR"


_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","VENCREA","D")
tcsetfield("TMP1","VALOR"  ,"N",15,3)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Vencto          ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o vencto       ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do Bordero         ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate o Bordero      ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do Banco           ?","mv_ch5","C",03,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA6"})
	
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
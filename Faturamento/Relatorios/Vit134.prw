/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±±
±±³Programa  ³ VIT134   ³ Autor ³ Gardenia              ³ Data ³ 09/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao Arquivo Texto para Emissao do Passe Fiscal         ³±±
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

user function VIT134()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="ARQUIVO PARA EMISSAO DO PASSE FISCAL VIA PROTOCOLO FTP"
cdesc1   :="Este programa ira emitir um arquivo texto para emissao do "
cdesc2   :="passe fiscal via protocolo ftp"
cdesc3   :=""
cstring  :="SD2"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT134"
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.
sx1->(dbseek("VIT134"+"06"))
wnrel:= substr(sx1->x1_cnt01,1,6)
_nomearq:=wnrel

cperg:="PERGVIT134"
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
_cfilsf2:=xfilial("SF2")
_cfilsa4:=xfilial("SA4")
_cfilsa1:=xfilial("SA1")
sf2->(dbsetorder(1))
sa4->(dbsetorder(1))
sa1->(dbsetorder(1))

processa({|| _querys()})

//cabec1:="LOTE      AL          ESTOQUE           EMPENHO           SALDO       VALIDADE"
//cabec2:=""



setprc(0,0)

setregua(sf2->(lastrec()))
tmp1->(dbgotop())                                   
_seq:=1
_tot:=0
tmp1->(dbgotop())                                   
_passou :=.t.                 
_totnota:=0
_setprint:=.f.
while ! tmp1->(eof()) .and.;
   lcontinua      
   if _passou
   	_seq:=1
   	_header()
   	_passou:=.f.
	endif	
   _seq+=1
   _totnota+=1
	@ prow()+1,000 PSAY "23"
	@ prow(),002 PSAY "1"
	sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
	@ prow(),003 PSAY sa1->a1_cgc
	@ prow(),017 PSAY sa1->a1_est
	@ prow(),019 PSAY strzero(day(tmp1->emissao),2,0)+strzero(month(tmp1->emissao),2,0)+strzero(year(tmp1->emissao),4,0)
	@ prow(),027 PSAY strzero(val(tmp1->doc),8,0)
	@ prow(),035 PSAY strzero(int(tmp1->valbrut),14,0)
	@ prow(),049 PSAY "00000"
	@ prow(),054 PSAY tmp1->serie
	@ prow(),120 PSAY strzero(_seq,8,0)  
	_tot+=tmp1->valbrut
	if (_totnota/10)=1
	  _setprint:=.t.
	  _passou :=.t.
	  _trailer()
	  _totnota:=0
	endif  
	tmp1->(dbskip()) 
end                   
if _totnota <10
	_trailer()
endif	

tmp1->(dbclosearea())


sx1->x1_cnt01:=_nomearq
sx1->(msunlock())
sysrefresh()

set device to screen

//if areturn[5]==1
//   set print to
//   dbcommitall()
//   ourspool(wnrel)
//endIf

ms_flush()
return

static function _querys()
_cquery:=" SELECT"
_cquery+=" F2_DOC DOC,F2_CLIENTE CLIENTE,F2_EMISSAO EMISSAO,F2_EST EST,F2_VALBRUT VALBRUT,"
_cquery+=" F2_SERIE SERIE,F2_LOJA LOJA,F2_TRANSP TRANSP"
_cquery+=" FROM "
_cquery+=  retsqlname("SF2")+" SF2,"
_cquery+=" WHERE"
_cquery+="     SF2.D_E_L_E_T_<>'*'"
_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
_cquery+=" AND F2_TRANSP='"+mv_par05+"'"
_cquery+=" AND F2_DOC  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
_cquery+=" ORDER BY F2_DOC"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","VALBRUT"  ,"N",15,2)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da Nota            ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o Nota         ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da Emissao         ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a Emissao      ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Transportadora     ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
aadd(_agrpsx1,{cperg,"06","Nº Remessa         ?","mv_ch6","N",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Inscrição Estadual ?","mv_ch7","N",09,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Nº Credenciamento  ?","mv_ch8","N",05,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","CPF. Responsável   ?","mv_ch9","N",11,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","UF do CPF Respons. ?","mv_ch10","C",02,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
  

static function _header()
	@ 00,001 PSAY "03"
	@ 00,003 PSAY strzero(day(ddatabase),2,0)+strzero(month(ddatabase),2,0)+strzero(year(ddatabase),4,0)
	@ 00,011 PSAY substr(time(),1,2)+substr(time(),4,2)
	@ 00,015 PSAY mv_par07
	@ 00,024 PSAY mv_par08
	sa4->(dbseek(_cfilsa4+mv_par05))
	@ 00,029 PSAY sa4->a4_cgc
	@ 00,043 PSAY sa4->a4_est
	@ 00,045 PSAY "1"
	@ 00,046 PSAY mv_par09
	@ 00,057 PSAY mv_par10  
	@ 00,059 PSAY substr(strzero(year(ddatabase),4,0),3,4)+mv_par06      
	@ 00,067 PSAY replicate(" ",54)
	@ 00,121 PSAY "00000001"
return 


static function  _trailer()
	@ prow()+1,000 PSAY "99"
	@ prow(),002 PSAY strzero(_seq-1,6,0)
	@ prow(),008 PSAY strzero(int(_tot),14,0)
	@ prow(),120 PSAY strzero(_seq+1,8,0)  
	if _setprint
	_nomearq:=val(_nomearq)+1     
	_nomearq:=strzero(_nomearq,6,0)
	endif	
	sx1->(dbseek("VIT134"+"06"))
	sx1->(reclock("SX1",.f.))
//	if areturn[5]==1
//	   set print to
//	   dbcommitall()
//      ourspool(wnrel)
//	endIf
	set device to screen
return










/*
Produto: xxxxxxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  Data        Quantidade UM Ordem de producao Quantidade Seg. UM
99/99/99 999,999,999.999 xx    xxxxxxxxxxx    999,999,999.999 xx
*/
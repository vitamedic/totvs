/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT219   ³ Autor ³ Gardenia              ³ Data ³ 20/12/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Saldos de Produtos no Fechamento Comercial                 ³±±
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

user function VIT219()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="SALDOS DE ESTOQUE NO FECHAMENTO "
cdesc1   :="Este programa ira emitir o saldo dos Produtos no fechamento comercial"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT219"
wnrel    :="VIT219"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT219"
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
_cfilsf1:=xfilial("SF1")
_cfilsa2:=xfilial("SA2")
_cfilsf8:=xfilial("SF8")
_cfilsd3:=xfilial("SD3")
_cfilsa4:=xfilial("SA4")
_cfilsf4:=xfilial("SF4")
_cfilsd2:=xfilial("SD2")
sb1->(dbsetorder(3))
sa4->(dbsetorder(1))
sd3->(dbsetorder(7))
sf8->(dbsetorder(2))
sa2->(dbsetorder(1))
sd1->(dbsetorder(7))
sf1->(dbsetorder(1))
sf4->(dbsetorder(1))
sd2->(dbsetorder(6))


processa({|| _querys()})

cabec1:="Produto                                             Janeiro   Fevereiro       Marco       Abril        Maio       Junho       Julho      Agosto    Setembro     Outubro    Novembro    Dezembro       Media"
//Produto                                             Janeiro   Fevereiro       Marco       Abril        Maio       Junho       Julho      Agosto    Setembro     Outubro    Novembro    Dezembro       Media
//999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99
cabec2:=" "



setprc(0,0)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
	_cproduto:=tmp1->cod  
	_locpad:=tmp1->locpad     
    @ prow()+1,00 PSAY substr(tmp1->cod,1,6)+"-"+tmp1->descr
//999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99
   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par09) 
   _saldo1:=_estoque[1]
	 @ prow(),48 PSAY _saldo1 picture "@E 9999,999.99"

   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par10) 
   _saldo2:=_estoque[1]
	 @ prow(),60 PSAY _saldo2 picture "@E 9999,999.99"

   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par11) 
   _saldo3:=_estoque[1]
	 @ prow(),72 PSAY _saldo3 picture "@E 9999,999.99"

   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par12) 
   _saldo4:=_estoque[1]
	 @ prow(),84 PSAY _saldo4 picture "@E 9999,999.99"

   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par13) 
   _saldo5:=_estoque[1]
	 @ prow(),96 PSAY _saldo5 picture "@E 9999,999.99"

   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par14) 
   _saldo6:=_estoque[1]
	 @ prow(),108 PSAY _saldo6 picture "@E 9999,999.99"

   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par15) 
   _saldo7:=_estoque[1]
	 @ prow(),120 PSAY _saldo7 picture "@E 9999,999.99"

   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par16) 
   _saldo8:=_estoque[1]
	 @ prow(),132 PSAY _saldo8 picture "@E 9999,999.99"

   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par17) 
   _saldo9:=_estoque[1]
	 @ prow(),144 PSAY _saldo9 picture "@E 9999,999.99"

   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par18) 
   _saldo10:=_estoque[1]
	 @ prow(),156 PSAY _saldo10 picture "@E 9999,999.99"

   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par19) 
   _saldo11:=_estoque[1]
	 @ prow(),168 PSAY _saldo11 picture "@E 9999,999.99"

   _estoque:=calcest(_cproduto,tmp1->locpad,mv_par20) 
   _saldo12:=_estoque[1]
	 @ prow(),180 PSAY _saldo12 picture "@E 9999,999.99"
	_tsaldo:= _saldo1+_saldo2+_saldo3+_saldo4+_saldo5+_saldo6+_saldo7+_saldo8+_saldo9+_saldo10+_saldo11+_saldo12
	_meses:=0
	for i = 9 to 20
	 _var:="mv_par"                   
	  _var2:=strzero(i,2,0)
	 _var3:=_var+_var2
//	 msgstop(&_var3.)
	 if !empty(&_var3.)
	 	_meses+=1
	 endif	
	next	
	@ prow(),192 PSAY _tsaldo/_meses picture "@E 9999,999.99"
	tmp1->(dbskip())
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
_cquery+=" B1_COD COD,B1_DESC DESCR,B1_LOCPAD LOCPAD"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND B1_LOCPAD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
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
aadd(_agrpsx1,{cperg,"07","Armazem            ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem      ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Janeiro            ?","mv_ch9","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Fevereiro          ?","mv_chA","D",08,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Marco              ?","mv_chB","D",08,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Abril              ?","mv_chC","D",08,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"13","Maio               ?","mv_chD","D",08,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"14","Junho              ?","mv_chE","D",08,0,0,"G",space(60),"mv_par14"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"15","Julho              ?","mv_chF","D",08,0,0,"G",space(60),"mv_par15"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"16","Agosto             ?","mv_chG","D",08,0,0,"G",space(60),"mv_par16"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"17","Setembro           ?","mv_chH","D",08,0,0,"G",space(60),"mv_par17"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"18","Outubro            ?","mv_chI","D",08,0,0,"G",space(60),"mv_par18"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"19","Novembro           ?","mv_chJ","D",08,0,0,"G",space(60),"mv_par19"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"20","Dezembro           ?","mv_chL","D",08,0,0,"G",space(60),"mv_par20"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
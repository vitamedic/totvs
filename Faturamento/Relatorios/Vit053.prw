/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT053   ³ Autor ³ Gardenia              ³ Data ³ 07/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos Liberados                               ³±±
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

user function VIT053()
nordem   :=""
tamanho  :="P"
limite   :=132
titulo   :="PEDIDOS LIBERADOS"
cdesc1   :="Este programa ira emitir a relacao dos pedidos liberados"
cdesc2   :=""
cdesc3   :=""
cstring  :="SC9"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT053"
wnrel    :="VIT053"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT053"
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
_cfilsa3:=xfilial("SA3")
_cfilsc9:=xfilial("SC9")
_cfilsc5:=xfilial("SC5")
sa1->(dbsetorder(1))
sa3->(dbsetorder(1))
sc5->(dbsetorder(1))



processa({|| _querys()})

cabec1:="Periodo de "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
cabec2:="Pedido  Fat Cliente                                   Data Ped  Representante                   Valor    Qtde"

//Pedido  Fat Cliente                                  Data Ped  Representante                   Valor    Qtde
//999999   X  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99  XXXXXXXXXXXXXXXXXXXX   999,999,999.99   999999



setprc(0,0)

setregua(sc9->(lastrec()))
@ 000,000 PSAY avalimp(132)

tmp1->(dbgotop())
_totalped :=0
_totalqtde :=0
_totval := 0
_totqte := 0
_mant := "  "
_ntped := 0
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
   _totped :=0
   _totqtde :=0
   _pedido :=tmp1->pedido
   _cliente := tmp1->cliente
   _nota :=tmp1->nfiscal
  	if _mant <> tmp1->vend
	   _mant := tmp1->vend
	   if !empty(_totqte)
	     @ prow()+1,000 PSAY "Total"
	     @ prow(),087 PSAY _totval  picture "@E 999,999,999.99"
		  @ prow(),104 PSAY _totqte picture "@E 999999"
	     @ prow()+1,000 PSAY " "
	     _totval := 0
	     _totqte := 0
	   endif	 
	endif   

	while ! tmp1->(eof()) .and.;
			tmp1->pedido==_pedido .and.;
			lcontinua
		incregua()
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif                   
		_totped += tmp1->qtdlib*tmp1->prcven
		_totalped += tmp1->qtdlib*tmp1->prcven
		_totqtde += tmp1->qtdlib
		_totalqtde += tmp1->qtdlib
		tmp1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
	end
	@ prow()+1,000 PSAY _pedido
//999999   X  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99  XXXXXXXXXXXXXXXXXXXX   999,999,999.99   999999

	if empty(_nota)
	  @ prow(),10 PSAY 'N'
	else   
	  @ prow(),10 PSAY 'S'
	endif  
	sa1->(dbseek(_cfilsa1+_cliente))
	sc5->(dbseek(_cfilsc5+_pedido))
	sa3->(dbseek(_cfilsa3+sc5->c5_vend1))
	@ prow(),013 PSAY sa1->a1_nome
	@ prow(),054 PSAY sc5->c5_emissao
	@ prow(),064 PSAY substr(sa3->a3_nome,1,20)
	@ prow(),087 PSAY _totped   picture "@E 999,999,999.99"
	@ prow(),104 PSAY _totqtde picture "@E 999999"
	_totval += _totped
	_totqte += _totqtde
	_ntped ++
end         
if lcontinua
	  if !empty(_totqte)
	    @ prow()+1,000 PSAY "Total"
		 @ prow(),087 PSAY _totval  picture "@E 999,999,999.99"
		 @ prow(),104 PSAY _totqte picture "@E 999999"
       @ prow()+1,000 PSAY " "
	  endif	 
	@ prow()+2,000 PSAY "Totais"
	@ prow()  ,045 PSAY _ntped picture "@E 999999"
	@ prow(),087 PSAY _totalped   picture "@E 999,999,999.99"
	@ prow(),104 PSAY _totalqtde picture "@E 999999"
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
_cquery+=" C9_DATALIB DATALIB,C9_QTDLIB QTDLIB,C9_CLIENTE CLIENTE,"
_cquery+=" C9_PRCVEN PRCVEN,C9_NFISCAL NFISCAL,C9_PEDIDO PEDIDO,C5_VEND1 VEND"
_cquery+=" FROM "
_cquery+=  retsqlname("SC9")+" SC9,"
_cquery+=  retsqlname("SC5")+" SC5"
_cquery+=" WHERE"
_cquery+="     SC9.D_E_L_E_T_<>'*'"
_cquery+=" AND SC5.D_E_L_E_T_<>'*'"
_cquery+=" AND C9_FILIAL='"+_cfilsc9+"'"
_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
_cquery+=" AND C9_PEDIDO=C5_NUM"
_cquery+=" AND C5_TIPO='N'"
_cquery+=" AND C9_DATALIB BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" ORDER BY C5_VEND1,C9_PEDIDO"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DATALIB","D")
tcsetfield("TMP1","QTDLIB"  ,"N",15,3)
tcsetfield("TMP1","PRCVEN","N",15,6)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
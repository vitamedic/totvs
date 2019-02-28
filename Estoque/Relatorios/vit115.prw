/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT115   ³ Autor ³ Gardenia              ³ Data ³ 28/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Produtos Vencidos e a Vencer                    ³±±
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

user function VIT115()
nordem   :=""
tamanho := "G"
limite  := 220
titulo   :="RELACAO DE PRODUTOS POR VALIDADE"
cdesc1   :="Este programa ira emitir a relacao de estoque de Produto /lote"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB8"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT115"
wnrel    :="VIT115"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
cbtxt    :=space(10)
lcontinua:=.t.
m_pag    :=1
li			:= 220
_vlunit  := 0

cperg:="PERGVIT115"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

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
_cfilsb8:=xfilial("SB8")
_cfilsd3:=xfilial("SD3")
sb1->(dbsetorder(3))
sb2->(dbsetorder(1))
sb8->(dbsetorder(1))
sd3->(dbsetorder(7))

processa({|| _querys()})

cabec1:="VENCIMENTO ENTRE " +dtoc(mv_par09)+" E "+dtoc(mv_par10)+"            CONSUMO                                      QUANTIDADE                                                   VALOR (R$)"
cabec2:="PRODUTO DESCRICAO                           ~MES   ~DIAS   LOTE       AL       ESTOQUE        EMPENHO            SALDO   UM   VALIDADE      ESTOQUE       EMPENHO             SALDO"

//       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                 10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
//cabec2:="LOTE      AL          ESTOQUE           EMPENHO           SALDO       VALIDADE"
//       999999   99   999.999.999,99    999.999.999,99   999.999.999,99    99/99/99


setprc(0,0)
@ 000,000 PSAY avalimp(180)

setregua(sb8->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_consumo:=0
	_dataref:=date() - 183
	sb2->(dbseek(_cfilsb2+tmp1->produto+tmp1->locpad))             
	_vlunit:=sb2->b2_cm1
	set softseek  on
	sd3->(dbseek(_cfilsd3+tmp1->produto+tmp1->locpad+dtos(_dataref)))
	set softseek off
	_locpad:=tmp1->locpad

  	while ! sd3->(eof()) .and.;
		sd3->d3_filial==_cfilsd3 .and.;
		sd3->d3_emissao<=date() .and. sd3->d3_emissao >= _dataref .and.;
		 tmp1->produto == sd3->d3_cod .and.;
		 _locpad == tmp1->locpad
		if substr(sd3->d3_cf,1,1) == "R" .and. sd3->d3_estorno <> "S"   
			_consumo+=sd3->d3_quant
		endif	
		sd3->(dbskip())
	end

   _media:=_consumo/6                                
   _mediadia:=_media/30
   _dias:=(sb2->b2_qatu-sb2->b2_qemp)/_mediadia
	@ prow()+1,000 PSAY left(tmp1->produto,6)
	@ prow()  ,008 PSAY Left(tmp1->descri,25)
	@ prow()  ,036 PSAY transform(_media,"@E 9,999,999.99")
	@ prow()  ,050 PSAY transform(_dias,"@E 99,999")

	_nquant  :=0
	_nsaldo :=0
	_nempenho :=0
	_cproduto:=tmp1->produto 
	while ! tmp1->(eof()) .and.;
		tmp1->produto==_cproduto .and.;
		lcontinua
		incregua()
		_lote :=tmp1->lotectl
		_nqlote :=0
		_nqemplote :=0
      _locpad :=tmp1->locpad
      _dtvalid :=tmp1->dtvalid
      _num := tmp1->um

		while ! tmp1->(eof()) .and.;
			tmp1->produto==_cproduto .and.;
			lcontinua .and. _lote ==tmp1->lotectl
			_nqlote +=tmp1->saldo
			_nqemplote +=tmp1->empenho
			_nquant  +=tmp1->saldo
			_nsaldo +=tmp1->saldo
			_nempenho += tmp1->empenho
			tmp1->(dbskip())
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				lcontinua:=.f.
			endif
		end
		
		if _cproduto=tmp1->produto
/*
VENCIMENTO ENTRE 01/01/01 E 10/01/01        CONSUMO                                          QUANTIDADE                                                   VALOR"
PRODUTO DESCRIÇÃO                           ~MÊS   ~DIAS   LOTE       AL       ESTOQUE         EMPENHO           SALDO   UM   VALIDADE     ESTOQUE        EMPENHO             SALDO"
999999  XXXXXXXXXXXXXXXXXXXXXXXXX   9,999,999.99  99,999   AUTO999999 99 99,999,999.99  999,999,999.99  999,999,999.99   XX   99/99/99   999,999.99    999,999.99    999,999,999.99
*/
			@ prow()  ,059   PSAY _lote 
			@ prow()  ,070   PSAY _locpad   
			@ prow()  ,073   PSAY _nqlote picture "@E 99,999,999.99"
			@ prow()  ,087   PSAY _nqemplote picture "@E 999,999,999.99"
			@ prow()  ,104   PSAY _nqlote-_nqemplote picture "@E 999,999,999.99"
			@ prow()  ,121   PSAY _num
			@ prow()  ,126   PSAY _dtvalid
			@ prow()  ,137   PSAY _nqlote*_vlunit picture "@E 999,999.99"
			@ prow()  ,151   PSAY _nqemplote*_vlunit picture "@E 999,999.99"
			@ prow()  ,165   PSAY (_nqlote-_nqemplote)*_vlunit picture "@E 999,999,999.99"		
			@ prow()+1,000   PSAY " "
		else
			@ prow()  ,059   PSAY _lote 
			@ prow()  ,070   PSAY _locpad   
			@ prow()  ,073   PSAY _nqlote picture "@E 99,999,999.99"
			@ prow()  ,087   PSAY _nqemplote picture "@E 999,999,999.99"
			@ prow()  ,104   PSAY _nqlote-_nqemplote picture "@E 999,999,999.99"
			@ prow()  ,121   PSAY _num
			@ prow()  ,126   PSAY _dtvalid
			@ prow()  ,137   PSAY _nqlote*_vlunit picture "@E 999,999.99"
			@ prow()  ,151   PSAY _nqemplote*_vlunit picture "@E 999,999.99"
			@ prow()  ,165   PSAY (_nqlote-_nqemplote)*_vlunit picture "@E 999,999,999.99"		
		endif
	end
	if lcontinua                            
		@ prow()+1,062  PSAY "TOTAIS: "
		@ prow()  ,073  PSAY _nquant           				picture "@E 99,999,999.99"
   	@ prow()  ,087  PSAY _nempenho         				picture "@E 999,999,999.99"
		@ prow()  ,104  PSAY _nquant-_nempenho 				picture "@E 999,999,999.99" 
		@ prow()  ,137  PSAY _nquant*_vlunit 				picture "@E 999,999.99"
		@ prow()  ,151  PSAY _nempenho*_vlunit 				picture "@E 999,999.99"
		@ prow()  ,165  PSAY (_nquant-_nempenho)*_vlunit picture "@E 999,999,999.99"		
		@ prow()+1,000  PSAY replicate("-",limite)
	endif
	if prow()>53
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
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
_cquery+=" B8_PRODUTO PRODUTO,B1_DESC DESCRI,B8_DTVALID DTVALID,"
_cquery+=" B1_UM UM,B8_SALDO SALDO,B8_EMPENHO EMPENHO,B8_LOTECTL LOTECTL,B8_LOCAL LOCPAD"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SB8")+" SB8"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SB8.D_E_L_E_T_<>'*'"

_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
_cquery+=" AND B8_PRODUTO=B1_COD"
_cquery+=" AND B8_SALDO>0"
_cquery+=" AND B8_LOCAL  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND B8_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B8_DTVALID BETWEEN '"+dtos(mv_par09)+"' AND '"+dtos(mv_par10)+"'"
//_cquery+=" AND D3_ESTORNO<>'S'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY B8_DTVALID,B8_PRODUTO,B1_DESC,B8_LOCAL,B8_LOTECTL"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DTVALID","D")
tcsetfield("TMP1","SALDO"  ,"N",15,3)
tcsetfield("TMP1","EMPENHO","N",15,3)
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
aadd(_agrpsx1,{cperg,"09","De Validade        ?","mv_ch9","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate Validade       ?","mv_chA","D",08,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
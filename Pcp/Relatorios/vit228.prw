/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT228 Autor  ³Aline B. Pereira  ³Data ³  14/04/2005       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gerenciamento de Previsao de Vendas                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit228()
nordem   :=""
tamanho  :="G" // P , M   ou G
limite   :=220 // 80, 132 ou 220
titulo   :="GERENCIAMENTO DE PREVISAO DE VENDAS "
cdesc1   :="Este programa ira emitir o gerenciamento de previsao de vendas "
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT228"
wnrel    :="VIT228"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT228"
_pergsx1()
pergunte(cperg,.f.)

if nlastkey==27
   set filter to
   return
endif

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

rptstatus({|| rptdetail()},titulo)
return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

titulo+=" - MES/ANO DE REFERENCIA: "+mv_par05+"/"+mv_par06
cabec1:="CODIGO DESCRICAO                                  ESTOQUE      OP´s     OP´s    PREVISAO MES/ANO COBERTURA    PEDIDOS   SALDO NECESSIDADE     LOTE "
cabec2:="                                                DISPONIVEL   GERADAS  PROCESSO DE VENDAS            DIAS    PENDENTES   FINAL                PADRAO"

_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsbm:=xfilial("SBM")
_cfilsc2:=xfilial("SC2")
_cfilsc4:=xfilial("SC4")
_cfilsc6:=xfilial("SC6")
_cfilsf4:=xfilial("SF4")
_cfilsh6:=xfilial("SH6")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sbm->(dbsetorder(1))
sc2->(dbsetorder(1))
sc4->(dbsetorder(1))
sc6->(dbsetorder(1))
sf4->(dbsetorder(1))
sh6->(dbsetorder(1))

processa({|| _geratmp()})

setprc(0,0)

setregua(sb1->(lastrec()))
	
_atsaldo :=array(mv_par07)
_atpreven:=array(mv_par07)
_atcobert:=array(mv_par07)
_atsaldof:=array(mv_par07)
_atneces :=array(mv_par07)
_atopger :=array(mv_par07)
_atpproc :=array(mv_par07)
_atpend :=array(mv_par07)

_adataini:=array(mv_par07)
_adatafim:=array(mv_par07)
_amesano :=array(mv_par07)

for _i:=1 to mv_par07
	if _i==1
		_nmes:=val(mv_par05)
		_nano:=val(mv_par06)
		_adataini[_i]:=ctod("01/"+strzero(_nmes,2)+"/"+strzero(_nano,4))
		_adatafim[_i]:=lastday(_adataini[_i])
	else
		if _nmes==12
			_nmes:=1
			_nano++
		else
			_nmes++
		endif
		_adataini[_i]:=ctod("01/"+strzero(_nmes,2)+"/"+strzero(_nano,4))
		_adatafim[_i]:=lastday(_adataini[_i])
	endif
	_atsaldo[_i] :=0
	_atpreven[_i]:=0
	_atcobert[_i]:=0
	_atsaldof[_i]:=0
	_atneces[_i] :=0
   _atopger[_i] :=0
	_atpproc[_i] :=0
	_atpend[_i] :=0
	_amesano[_i] :=strzero(month(_adataini[_i]),2)+"/"+strzero(year(_adataini[_i]),4)
next

_ccq      :=getmv("MV_CQ")

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
		lcontinua
	if prow()==0 .or. prow()>56
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	
	_agsaldo :=array(mv_par07)
	_agpreven:=array(mv_par07)
	_agcobert:=array(mv_par07)
	_agsaldof:=array(mv_par07)
	_agneces :=array(mv_par07)
	_agopger :=array(mv_par07)
	_agpproc :=array(mv_par07)
	_agpend :=array(mv_par07)
	for _i:=1 to mv_par07
		_agsaldo[_i] :=0
		_agpreven[_i]:=0
		_agcobert[_i]:=0
		_agsaldof[_i]:=0
		_agneces[_i] :=0
		_agopger[_i] :=0
		_agpproc[_i] :=0		
		_agpend[_i] :=0		
	next
	
	_cgrupo:=tmp1->grupo
	sbm->(dbseek(_cfilsbm+_cgrupo))
	@ prow()+2,000 PSAY "LINHA: "+_cgrupo+" - "+sbm->bm_desc
	@ prow()+1,000 PSAY replicate("-",limite)
	while ! tmp1->(eof()) .and.;
			tmp1->grupo==_cgrupo .and.;
			lcontinua
		incregua()

		_asaldo :=array(mv_par07)
		_apreven:=array(mv_par07)
		_acobert:=array(mv_par07)
		_asaldof:=array(mv_par07)
		_aneces :=array(mv_par07)
		// SALDO DISPONIVEL
		_nsaldo:=0
		if sb2->(dbseek(_cfilsb2+tmp1->codigo+tmp1->locpad))
			_nsaldo+=sb2->b2_qatu
		endif
		if sb2->(dbseek(_cfilsb2+tmp1->codigo+"02")) // FRACIONADO
			_nsaldo+=sb2->b2_qatu
		endif
		if sb2->(dbseek(_cfilsb2+tmp1->codigo+_ccq)) // CONTROLE DE QUALIDADE
			_nsaldo+=sb2->b2_qatu
		endif
		
		// OP´s GERADAS
		_cquery:=" SELECT"
		_cquery+=" SUM(C2_QUANT-C2_QUJE) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC2")+" SC2"
		_cquery+=" WHERE "
		_cquery+="     SC2.D_E_L_E_T_<>'*'"
		_cquery+=" AND C2_FILIAL='"+_cfilsc2+"'"
		_cquery+=" AND C2_PRODUTO='"+tmp1->codigo+"'"
		_cquery+=" AND C2_DATRF='        '"
		_cquery+=" AND C2_NUM||C2_ITEM||C2_SEQUEN||C2_ITEMGRD NOT IN "
		_cquery+=" (SELECT"
		_cquery+="  DISTINCT H6_OP"
		_cquery+="  FROM "
		_cquery+=   retsqlname("SH6")+" SH6"
		_cquery+="  WHERE "
		_cquery+="      SH6.D_E_L_E_T_<>'*'"
		_cquery+="  AND H6_FILIAL='"+_cfilsh6+"'"
		_cquery+="  AND H6_PRODUTO='"+tmp1->codigo+"')"
  		
		_cquery:=changequery(_cquery)
   	
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		
		tmp2->(dbgotop())
		_nopger:=tmp2->quant
		tmp2->(dbclosearea())
			
		// OP´s EM PROCESSO
		_cquery:=" SELECT"
		_cquery+=" SUM(C2_QUANT-C2_QUJE) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC2")+" SC2"
		_cquery+=" WHERE "
		_cquery+="     SC2.D_E_L_E_T_<>'*'"
		_cquery+=" AND C2_FILIAL='"+_cfilsc2+"'"
		_cquery+=" AND C2_PRODUTO='"+tmp1->codigo+"'"
		_cquery+=" AND C2_DATRF='        '"
		_cquery+=" AND C2_NUM||C2_ITEM||C2_SEQUEN||C2_ITEMGRD IN "
		_cquery+=" (SELECT"
		_cquery+="  DISTINCT H6_OP"
		_cquery+="  FROM "
		_cquery+=   retsqlname("SH6")+" SH6"
		_cquery+="  WHERE "
		_cquery+="      SH6.D_E_L_E_T_<>'*'"
		_cquery+="  AND H6_FILIAL='"+_cfilsh6+"'"
		_cquery+="  AND H6_PRODUTO='"+tmp1->codigo+"')"
   		
		_cquery:=changequery(_cquery)
   	
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		                 
		
		tmp2->(dbgotop())
		_nopproc:=tmp2->quant
		tmp2->(dbclosearea())
		
		// PEDIDOS
		_cquery:=" SELECT"
		_cquery+=" SUM(C6_QTDVEN-C6_QTDENT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC6")+" SC6,"
		_cquery+=  retsqlname("SF4")+" SF4"
		_cquery+=" WHERE "
		_cquery+="     SC6.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND C6_TES=F4_CODIGO"
		_cquery+=" AND C6_PRODUTO='"+tmp1->codigo+"'"
		_cquery+=" AND C6_BLQ<>'R '"
		_cquery+=" AND F4_ESTOQUE='S'"
  		
		_cquery:=changequery(_cquery)
   	
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		
		tmp2->(dbgotop())
		_ncartped:=tmp2->quant
		tmp2->(dbclosearea())
		
		_limp:=.f.
		_limpdesc:=.t.
		for _i:=1 to mv_par07
			// SALDO DISPONIVEL
			if _i==1
				_asaldo[_i] :=_nsaldo
			else
				_asaldo[_i]:=_asaldof[_i-1]+_aneces[_i-1]
			endif
/*			
			// PREVISAO DE VENDAS
			_cquery:=" SELECT"
			_cquery+=" SUM(C4_QUANT) QUANT"
			_cquery+=" FROM "
			_cquery+=  retsqlname("SC4")+" SC4"
			_cquery+=" WHERE "
			_cquery+="     SC4.D_E_L_E_T_<>'*'"
			_cquery+=" AND C4_FILIAL='"+_cfilsc4+"'"
			_cquery+=" AND C4_PRODUTO='"+tmp1->codigo+"'"
			_cquery+=" AND C4_DATA BETWEEN '"+dtos(_adataini[_i])+"' AND '"+dtos(_adatafim[_i])+"'"
*/   		
			// PREVISAO DE VENDAS
			_cquery:=" SELECT"
			_cquery+=" SUM(CT_QUANT) QUANT"
			_cquery+=" FROM "
			_cquery+=  retsqlname("SCT")+" SCT"
			_cquery+=" WHERE "
			_cquery+="     SCT.D_E_L_E_T_<>'*'"
			_cquery+=" AND CT_FILIAL='"+_cfilsc4+"'"
			_cquery+=" AND CT_PRODUTO='"+tmp1->codigo+"'"
			_cquery+=" AND CT_DATA BETWEEN '"+dtos(_adataini[_i])+"' AND '"+dtos(_adatafim[_i])+"'"
   					
			_cquery:=changequery(_cquery)
	   	
			tcquery _cquery alias "TMP2" new
			tcsetfield("TMP2","QUANT","N",07,0)
			
			tmp2->(dbgotop())
			_apreven[_i]:=tmp2->quant
			tmp2->(dbclosearea())
			
			// COBERTURA DIAS
			_acobert[_i]:=round(((_asaldo[_i]+_nopger+_nopproc)/_apreven[_i])*day(_adatafim[_i]),2)
			//SALDO FINAL
			if _i==1
				_asaldof[_i]:=(_asaldo[_i]+_nopger+_nopproc) - (_apreven[_i]+_ncartped)
			else
				_asaldof[_i]:=_asaldo[_i] - _apreven[_i]
			endif
			
			// NECESSIDADE
			if _asaldof[_i]>=0
				_aneces[_i]:=0
			else
				_nneces:=abs(_asaldof[_i])
				if _nneces%tmp1->qb==0
					_aneces[_i]:=(_nneces/tmp1->qb)*tmp1->qb
				else
					_aneces[_i]:=(int(_nneces/tmp1->qb)+1)*tmp1->qb
				endif
			endif
			
			if prow()>56
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if _apreven[_i]>0
				_limp:=.t.
				if _i==1
					@ prow()+1,000 PSAY left(tmp1->codigo,6)
					@ prow(),007   PSAY left(tmp1->descricao,40)
					@ prow(),049   PSAY _asaldo[_i]  picture "@E 9,999,999"
					@ prow(),059   PSAY _nopger      picture "@E 9,999,999"
					@ prow(),069   PSAY _nopproc     picture "@E 9,999,999"
					@ prow(),079   PSAY _apreven[_i] picture "@E 9,999,999"
					@ prow(),089   PSAY _amesano[_i]
					@ prow(),098   PSAY _acobert[_i] picture "@E 9999.99"
					@ prow(),107   PSAY _ncartped    picture "@E 9,999,999"
					@ prow(),117   PSAY _asaldof[_i] picture "@E 9,999,999"
					@ prow(),129   PSAY _aneces[_i]  picture "@E 9,999,999"
					@ prow(),139   PSAY tmp1->qb     picture "@E 9,999,999"
					_limpdesc:=.f.
				else
					if _limpdesc
						@ prow()+1,000 PSAY left(tmp1->codigo,6)
						@ prow(),007   PSAY left(tmp1->descricao,40)
						@ prow(),049 PSAY _asaldo[_i]  picture "@E 9,999,999"
						_limpdesc:=.f.
					else
						@ prow()+1,049 PSAY _asaldo[_i]  picture "@E 9,999,999"
					endif
					@ prow(),079   PSAY _apreven[_i] picture "@E 9,999,999"
					@ prow(),089   PSAY _amesano[_i]
					@ prow(),098   PSAY _acobert[_i] picture "@E 9999.99"
					@ prow(),117   PSAY _asaldof[_i] picture "@E 9,999,999"
					@ prow(),129   PSAY _aneces[_i]  picture "@E 9,999,999"
				endif
				_agsaldo[_i] +=_asaldo[_i]
				_agopger[_i] +=_nopger
				_agpproc[_i] +=_nopproc
				_agpreven[_i]+=_apreven[_i]
				_agcobert[_i]+=_acobert[_i]
				_agsaldof[_i]+=_asaldof[_i]
				_agneces[_i] +=_aneces[_i]
				_agpend[_i] +=_ncartped 
			endif
		next
		if _limp
			@ prow()+1,000 PSAY replicate("-",limite)
		endif
		tmp1->(dbskip())
   	if labortprint
      	@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
      	eject
	      lcontinua:=.f.
   	endif
	end
	if lcontinua
		@ prow()+1,000 PSAY "TOTAIS DA LINHA"
		for _i:=1 to mv_par07
			if _i==1
				@ prow(),049   PSAY _agsaldo[_i] picture "@E 9,999,999"
				@ prow(),059   PSAY _agopger[_i] picture "@E 9,999,999"
				@ prow(),069   PSAY _agpproc[_i] picture "@E 9,999,999"			
			else
				if prow()>56
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
				endif
				@ prow()+1,049 PSAY _agsaldo[_i] picture "@E 9,999,999"
			endif
			@ prow(),079   PSAY _agpreven[_i] picture "@E 9,999,999"
			@ prow(),089   PSAY _amesano[_i]
//			@ prow(),098   PSAY _agcobert[_i] picture "@E 9999.99"
			@ prow(),098   PSAY round(((_agsaldo[_i]+_agopger[_i]+_agpproc[_i])/_agpreven[_i])*day(_adatafim[_i]),2)picture "@E 9999.99"
			if _i==1			
				@ prow(),107   PSAY _agpend[_i] picture "@E 9,999,999"
			endif	
			@ prow(),117   PSAY _agsaldof[_i] picture "@E 9,999,999"
			@ prow(),129   PSAY _agneces[_i]  picture "@E 9,999,999"
//			_acobert[_i]:=round((_asaldo[_i]/_apreven[_i])*day(_adatafim[_i]),2)/			
			_atsaldo[_i] +=_agsaldo[_i]
			_atpreven[_i]+=_agpreven[_i]
			_atcobert[_i]+=_agcobert[_i]
			_atsaldof[_i]+=_agsaldof[_i]
			_atneces[_i] +=_agneces[_i]
		   _atopger[_i] += _agopger[_i]
			_atpproc[_i] += _agpproc[_i]
			_atpend[_i] += _agpend[_i]
		next
		@ prow()+1,000 PSAY replicate("*",limite)
	endif
end

if prow()>0 .and.;
	lcontinua
	@ prow()+1,000 PSAY replicate("*",limite)
	@ prow()+1,000 PSAY "TOTAIS DO RELATORIO"
	for _i:=1 to mv_par07
		if _i==1
			@ prow(),049   PSAY _atsaldo[_i] picture "@E 9,999,999"
			@ prow(),059   PSAY _atopger[_i] picture "@E 9,999,999"
			@ prow(),069   PSAY _atpproc[_i] picture "@E 9,999,999"
		else
			if prow()>56
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,049 PSAY _atsaldo[_i] picture "@E 9,999,999"
		endif
		@ prow(),079   PSAY _atpreven[_i] picture "@E 9,999,999"
		@ prow(),089   PSAY _amesano[_i]
//		@ prow(),098   PSAY _atcobert[_i] picture "@E 9999.99" 
		@ prow(),098   PSAY round(((_atsaldo[_i]+_atopger[_i]+_atpproc[_i])/_atpreven[_i])*day(_adatafim[_i]),2) picture "@E 9999.99"	
		if _i==1					
			@ prow(),107   PSAY _atpend[_i] picture "@E 9,999,999"
		endif	
		@ prow(),117   PSAY _atsaldof[_i] picture "@E 9,999,999"
		@ prow(),129   PSAY _atneces[_i]  picture "@E 9,999,999"
	next
   roda(cbcont,cbtxt)
endif

set device to screen

tmp1->(dbclosearea())

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endif

ms_flush()
return

static function _geratmp()
procregua(1)

incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_GRUPO GRUPO,B1_DESC DESCRICAO,B1_COD CODIGO,B1_LOCPAD LOCPAD,B1_QB QB"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE "
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
//_cquery+=" AND B1_CLASSE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND B1_TIPO='PA'"
//_cquery+=" AND B1_STATDES<>'DE'"
//_cquery+=" AND (B1_STATCOM<>'BA' OR B1_STATPRO<>'BL')" //By Mario 24/02/2003 - Solicitado por Sandro.
_cquery+=" ORDER BY"
_cquery+=" 1,2"

_cquery:=changequery(_cquery)

tcquery _cquery alias "TMP1" new
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do grupo           ?","mv_ch3","C",04,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"04","Ate o grupo        ?","mv_ch4","C",04,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
//aadd(_agrpsx1,{cperg,"05","Da classe comercial?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"Z2 "})
//dd(_agrpsx1,{cperg,"04","Ate a classe comerc?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"Z2 "})
aadd(_agrpsx1,{cperg,"05","Mes de referencia  ?","mv_ch5","C",02,0,0,"G",'pertence("01#02#03#04#05#06#07#08#09#10#11#12")',"mv_par05"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ano de referencia  ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Quantos meses      ?","mv_ch7","N",02,0,0,"G",'naovazio()',"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
CODIGO DESCRICAO                                  ESTOQUE      OP´s     OP´s    PREVISAO MES/ANO COBERTURA  PEDIDOS      SALDO NECESSIDADE     LOTE 
                                                DISPONIVEL   GERADAS  PROCESSO DE VENDAS            DIAS    PENDENTES    FINAL                PADRAO
999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  9.999.999 9.999.999 9.999.999 9.999.999 99/9999  9999,99  9.999.999 9.999.999   9.999.999 9.999.999
*/
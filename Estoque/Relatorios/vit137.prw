/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT137   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 30/06/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Lista de Produtos com Problemas de Saldo na Data Informada ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit137()
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="PRODUTOS COM PROBLEMAS DE SALDO NA DATA INFORMADA"
cdesc1   :="Este programa ira emitir a relacao de produtos com problemas de saldo"
cdesc2   :="na data informada nos parametros"
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT137"
wnrel    :="VIT137"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT137"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

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

static function rptdetail()
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb9:=xfilial("SB9")
_cfilsbj:=xfilial("SBJ")
_cfilsbk:=xfilial("SBK")
_cfilsd1:=xfilial("SD1")
_cfilsd2:=xfilial("SD2")
_cfilsd3:=xfilial("SD3")
_cfilsd5:=xfilial("SD5")
_cfilsdb:=xfilial("SDB")
_cfilsf4:=xfilial("SF4")

processa({|| _geratmp()})

titulo:="PRODUTOS COM PROBLEMAS DE SALDO EM "+dtoc(mv_par09)
cabec1:="CODIGO          DESCRICAO                              AR  Ult.PR     SALDO SB2          SALDO SB8          SALDO SBF LOTE       SUB-LOTE ENDERECO"
cabec2:=""

setprc(0,0)

setregua(sb1->(lastrec()))

_dulmes  :=getmv("MV_ULMES")
_ddataini:=_dulmes+1
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	
	incregua()
	
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+tmp1->produto))
	
	_cquery:=" SELECT"
	_cquery+=" B9_LOCAL ARMAZEM,SUM(B9_QINI) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SB9")+" SB9"
	_cquery+=" WHERE"
	_cquery+="     SB9.D_E_L_E_T_<>'*'"
	_cquery+=" AND B9_FILIAL='"+_cfilsb9+"'"
	_cquery+=" AND B9_COD='"+tmp1->produto+"'"
	_cquery+=" AND B9_DATA='"+dtos(_dulmes)+"'"
	_cquery+=" AND B9_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" GROUP BY"
	_cquery+=" B9_LOCAL"
//	_cquery+=" 1"
	_cquery+=" UNION ALL"
	_cquery+=" SELECT"
	_cquery+=" D1_LOCAL ARMAZEM,SUM(D1_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD1")+" SD1,"
	_cquery+=  retsqlname("SF4")+" SF4"
	_cquery+=" WHERE"
	_cquery+="     SD1.D_E_L_E_T_<>'*'"
	_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
	_cquery+=" AND D1_FILIAL='"+_cfilsd1+"'"
	_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
	_cquery+=" AND D1_TES=F4_CODIGO"
	_cquery+=" AND F4_ESTOQUE='S'"
	_cquery+=" AND D1_COD='"+tmp1->produto+"'"
	_cquery+=" AND D1_DTDIGIT BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(mv_par09)+"'"
	_cquery+=" AND D1_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" GROUP BY"
	_cquery+=" D1_LOCAL"
//	_cquery+=" 1"
	_cquery+=" UNION ALL"
	_cquery+=" SELECT"
	_cquery+=" D2_LOCAL ARMAZEM,SUM(D2_QUANT)*(-1) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD2")+" SD2,"
	_cquery+=  retsqlname("SF4")+" SF4"
	_cquery+=" WHERE"
	_cquery+="     SD2.D_E_L_E_T_<>'*'"
	_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
	_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
	_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
	_cquery+=" AND D2_TES=F4_CODIGO"
	_cquery+=" AND F4_ESTOQUE='S'"
	_cquery+=" AND D2_COD='"+tmp1->produto+"'"
	_cquery+=" AND D2_EMISSAO BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(mv_par09)+"'"
	_cquery+=" AND D2_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" GROUP BY"
	_cquery+=" D2_LOCAL"
//	_cquery+=" 1"
	_cquery+=" UNION ALL"
	_cquery+=" SELECT"
	_cquery+=" D3_LOCAL ARMAZEM,SUM(D3_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD3")+" SD3"
	_cquery+=" WHERE"
	_cquery+="     SD3.D_E_L_E_T_<>'*'"
	_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
	_cquery+=" AND D3_COD='"+tmp1->produto+"'"
	_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(mv_par09)+"'"
	_cquery+=" AND D3_TM<'500'"
	_cquery+=" AND D3_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" AND D3_ESTORNO<>'S'"
	_cquery+=" GROUP BY"
	_cquery+=" D3_LOCAL"
//	_cquery+=" 1"
	_cquery+=" UNION ALL"
	_cquery+=" SELECT"
	_cquery+=" D3_LOCAL ARMAZEM,SUM(D3_QUANT)*(-1) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD3")+" SD3"
	_cquery+=" WHERE"
	_cquery+="     SD3.D_E_L_E_T_<>'*'"
	_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
	_cquery+=" AND D3_COD='"+tmp1->produto+"'"
	_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(mv_par09)+"'"
	_cquery+=" AND D3_TM>='500'"
	_cquery+=" AND D3_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" AND D3_ESTORNO<>'S'"
	_cquery+=" GROUP BY"
	_cquery+=" D3_LOCAL"
//	_cquery+=" 1"
	_cquery+=" ORDER BY"
	_cquery+=" 1"
	
	_cquery:=changequery(_cquery)
	tcquery _cquery alias "TMP2" new
	
	tmp2->(dbgotop())
	while ! tmp2->(eof())
		_nquantfis:=0
		_carmazem :=tmp2->armazem
		while ! tmp2->(eof()) .and.;
			tmp2->armazem==_carmazem
			_nquantfis+=tmp2->quant
			tmp2->(dbskip())
		end
		if _nquantfis<0
			if prow()==0 .or. prow()>52
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY tmp1->produto
				@ prow(),016   PSAY left(sb1->b1_desc,40)
				@ prow(),058   PSAY _carmazem
				@ prow(),61 PSAY sb1->b1_uprc* (_nquantfis) PICTURE "@E 999,999.99"
			
			@ prow(),075   PSAY _nquantfis picture "@E 999,999,999,999.99"
		endif
		if sb1->b1_rastro$"SL"
			_cquery:=" SELECT"
			_cquery+=" SUM(BJ_QINI) QUANT"
			_cquery+=" FROM "
			_cquery+=  retsqlname("SBJ")+" SBJ"
			_cquery+=" WHERE"
			_cquery+="     SBJ.D_E_L_E_T_<>'*'"
			_cquery+=" AND BJ_FILIAL='"+_cfilsbj+"'"
			_cquery+=" AND BJ_COD='"+tmp1->produto+"'"
			_cquery+=" AND BJ_DATA='"+dtos(_dulmes)+"'"
			_cquery+=" AND BJ_LOCAL='"+_carmazem+"'"
			_cquery+=" UNION ALL"
			_cquery+=" SELECT"
			_cquery+=" SUM(D5_QUANT) QUANT"
			_cquery+=" FROM "
			_cquery+=  retsqlname("SD5")+" SD5"
			_cquery+=" WHERE"
			_cquery+="     SD5.D_E_L_E_T_<>'*'"
			_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
			_cquery+=" AND D5_PRODUTO='"+tmp1->produto+"'"
			_cquery+=" AND D5_DATA BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(mv_par09)+"'"
			_cquery+=" AND (D5_ORIGLAN<'500' OR D5_ORIGLAN='MAN')"
			_cquery+=" AND D5_LOCAL='"+_carmazem+"'"
			_cquery+=" AND D5_ESTORNO<>'S'"
			_cquery+=" UNION ALL"
			_cquery+=" SELECT"
			_cquery+=" SUM(D5_QUANT)*(-1) QUANT"
			_cquery+=" FROM "
			_cquery+=  retsqlname("SD5")+" SD5"
			_cquery+=" WHERE"
			_cquery+="     SD5.D_E_L_E_T_<>'*'"
			_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
			_cquery+=" AND D5_PRODUTO='"+tmp1->produto+"'"
			_cquery+=" AND D5_DATA BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(mv_par09)+"'"
			_cquery+=" AND D5_ORIGLAN>='500'"
			_cquery+=" AND D5_ORIGLAN<>'MAN'"
			_cquery+=" AND D5_LOCAL='"+_carmazem+"'"
			_cquery+=" AND D5_ESTORNO<>'S'"
			
			_cquery:=changequery(_cquery)
			tcquery _cquery alias "TMP3" new
			
			_nquantlot:=0
			tmp3->(dbgotop())
			while ! tmp3->(eof())
				_nquantlot+=tmp3->quant
				tmp3->(dbskip())
			end
			tmp3->(dbclosearea())
			if _nquantlot<0 .or. _nquantlot<>_nquantfis
				if prow()==0 .or. prow()>52
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
				endif
				@ prow()+1,000 PSAY tmp1->produto
				@ prow(),016   PSAY left(sb1->b1_desc,40)
				@ prow(),058   PSAY _carmazem
				@ prow(),61 PSAY sb1->b1_uprc* (_nquantfis) PICTURE "@E 999,999.99"
				
				@ prow(),072   PSAY "*"
				@ prow(),075   PSAY _nquantfis picture "@E 999,999,999,999.99"
				@ prow(),094   PSAY _nquantlot picture "@E 999,999,999,999.99"
			endif
		endif
	end
	tmp2->(dbclosearea())
	
	if sb1->b1_rastro$"SL"
		_cquery:=" SELECT"
		_cquery+=" BJ_LOCAL ARMAZEM,BJ_LOTECTL LOTECTL,BJ_NUMLOTE NUMLOTE,SUM(BJ_QINI) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SBJ")+" SBJ"
		_cquery+=" WHERE"
		_cquery+="     SBJ.D_E_L_E_T_<>'*'"
		_cquery+=" AND BJ_FILIAL='"+_cfilsbj+"'"
		_cquery+=" AND BJ_COD='"+tmp1->produto+"'"
		_cquery+=" AND BJ_DATA='"+dtos(_dulmes)+"'"
		_cquery+=" AND BJ_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		_cquery+=" GROUP BY"
		_cquery+=" BJ_LOCAL,BJ_LOTECTL,BJ_NUMLOTE"
//		_cquery+=" 1,2,3"
		_cquery+=" UNION ALL"
		_cquery+=" SELECT"
		_cquery+=" D5_LOCAL ARMAZEM,D5_LOTECTL LOTECTL,D5_NUMLOTE NUMLOTE,SUM(D5_QUANT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SD5")+" SD5"
		_cquery+=" WHERE"
		_cquery+="     SD5.D_E_L_E_T_<>'*'"
		_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
		_cquery+=" AND D5_PRODUTO='"+tmp1->produto+"'"
		_cquery+=" AND D5_DATA BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(mv_par09)+"'"
		_cquery+=" AND (D5_ORIGLAN<'500' OR D5_ORIGLAN='MAN')"
		_cquery+=" AND D5_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		_cquery+=" AND D5_ESTORNO<>'S'"
		_cquery+=" GROUP BY"
		_cquery+=" D5_LOCAL,D5_LOTECTL,D5_NUMLOTE"
//		_cquery+=" 1,2,3"
		_cquery+=" UNION ALL"
		_cquery+=" SELECT"
		_cquery+=" D5_LOCAL ARMAZEM,D5_LOTECTL LOTECTL,D5_NUMLOTE NUMLOTE,SUM(D5_QUANT)*(-1) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SD5")+" SD5"
		_cquery+=" WHERE"
		_cquery+="     SD5.D_E_L_E_T_<>'*'"
		_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
		_cquery+=" AND D5_PRODUTO='"+tmp1->produto+"'"
		_cquery+=" AND D5_DATA BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(mv_par09)+"'"
		_cquery+=" AND D5_ORIGLAN>='500'"
		_cquery+=" AND D5_ORIGLAN<>'MAN'"
		_cquery+=" AND D5_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		_cquery+=" AND D5_ESTORNO<>'S'"
		_cquery+=" GROUP BY"
		_cquery+=" D5_LOCAL,D5_LOTECTL,D5_NUMLOTE"
//		_cquery+=" 1,2,3"
		_cquery+=" ORDER BY"
		_cquery+=" 1,2,3"
		
		_cquery:=changequery(_cquery)
		tcquery _cquery alias "TMP2" new
		
		tmp2->(dbgotop())
		while ! tmp2->(eof())
			_carmazem:=tmp2->armazem
			_clotectl:=tmp2->lotectl
			_cnumlote:=tmp2->numlote
			_nquantlot:=0
			while ! tmp2->(eof()) .and.;
				tmp2->armazem==_carmazem .and.;
				tmp2->lotectl==_clotectl .and.;
				tmp2->numlote==_cnumlote
				_nquantlot+=tmp2->quant
				tmp2->(dbskip())
			end
			if _nquantlot<0
				if prow()==0 .or. prow()>52
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
				endif
				@ prow()+1,000 PSAY tmp1->produto
				@ prow(),016   PSAY left(sb1->b1_desc,40)
				@ prow(),058   PSAY _carmazem
				@ prow(),61 PSAY sb1->b1_uprc* (_nquantlot) PICTURE "@E 999,999.99"
				@ prow(),073   PSAY "#"
                                  
			@ prow(),094   PSAY _nquantlot picture "@E 999,999,999,999.99"
				@ prow(),132   PSAY _clotectl
				@ prow(),144   PSAY _cnumlote
			endif
		end
		tmp2->(dbclosearea())
	endif
	if sb1->b1_localiz=="S"
		_cquery:=" SELECT"
		_cquery+=" BK_LOCAL ARMAZEM,BK_LOTECTL LOTECTL,BK_LOCALIZ LOCALIZ,SUM(BK_QINI) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SBK")+" SBK"
		_cquery+=" WHERE"
		_cquery+="     SBK.D_E_L_E_T_<>'*'"
		_cquery+=" AND BK_FILIAL='"+_cfilsbk+"'"
		_cquery+=" AND BK_COD='"+tmp1->produto+"'"
		_cquery+=" AND BK_DATA='"+dtos(_dulmes)+"'"
		_cquery+=" AND BK_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		_cquery+=" GROUP BY"
		_cquery+=" BK_LOCAL,BK_LOTECTL,BK_LOCALIZ"
//		_cquery+=" 1,2,3"
		_cquery+=" UNION ALL"
		_cquery+=" SELECT"
		_cquery+=" DB_LOCAL ARMAZEM,DB_LOTECTL LOTECTL,DB_LOCALIZ LOCALIZ,SUM(DB_QUANT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SDB")+" SDB"
		_cquery+=" WHERE"
		_cquery+="     SDB.D_E_L_E_T_<>'*'"
		_cquery+=" AND DB_FILIAL='"+_cfilsdb+"'"
		_cquery+=" AND DB_PRODUTO='"+tmp1->produto+"'"
		_cquery+=" AND DB_DATA BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(mv_par09)+"'"
		_cquery+=" AND DB_TM<'500'"
		_cquery+=" AND DB_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		_cquery+=" AND DB_ESTORNO<>'S'"
		_cquery+=" GROUP BY"
		_cquery+=" DB_LOCAL,DB_LOTECTL,DB_LOCALIZ"
//		_cquery+=" 1,2,3"
		_cquery+=" UNION ALL"
		_cquery+=" SELECT"
		_cquery+=" DB_LOCAL ARMAZEM,DB_LOTECTL LOTECTL,DB_LOCALIZ LOCALIZ,SUM(DB_QUANT)*(-1) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SDB")+" SDB"
		_cquery+=" WHERE"
		_cquery+="     SDB.D_E_L_E_T_<>'*'"
		_cquery+=" AND DB_FILIAL='"+_cfilsdb+"'"
		_cquery+=" AND DB_PRODUTO='"+tmp1->produto+"'"
		_cquery+=" AND DB_DATA BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(mv_par09)+"'"
		_cquery+=" AND DB_TM>='500'"
		_cquery+=" AND DB_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
		_cquery+=" AND DB_ESTORNO<>'S'"
		_cquery+=" GROUP BY"
		_cquery+=" DB_LOCAL,DB_LOTECTL,DB_LOCALIZ"
//		_cquery+=" 1,2,3"
		_cquery+=" ORDER BY"
		_cquery+=" 1,2,3"
		
		_cquery:=changequery(_cquery)
		tcquery _cquery alias "TMP2" new
		
		tmp2->(dbgotop())
		while ! tmp2->(eof())
			_carmazem:=tmp2->armazem
			_clotectl:=tmp2->lotectl
			_clocaliz:=tmp2->localiz
			_nquantend:=0
			while ! tmp2->(eof()) .and.;
				tmp2->armazem==_carmazem .and.;
				tmp2->lotectl==_clotectl .and.;
				tmp2->localiz==_clocaliz
				_nquantend+=tmp2->quant
				tmp2->(dbskip())
			end
			if _nquantend<0
				if prow()==0 .or. prow()>52
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
				endif
				@ prow()+1,000 PSAY tmp1->produto
				@ prow(),016   PSAY left(sb1->b1_desc,40)
				@ prow(),058   PSAY _carmazem
				@ prow(),61 PSAY sb1->b1_uprc* (_nquantend) PICTURE "@E 999,999.99"
				@ prow(),73 PSAY "--"
				@ prow(),094   PSAY _nquantend picture "@E 999,999,999,999.99"
				@ prow(),132   PSAY _clotectl
				@ prow(),152   PSAY _clocaliz
			endif
		end


		tmp2->(dbclosearea())
	endif
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if prow()>0 .and.;
	lcontinua
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
_cquery:=" SELECT"
_cquery+=" B1_COD PRODUTO,B1_LOCPAD ARMZ"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE "
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND SUBSTR(B1_COD,1,3)<>'MOD'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Do armazem         ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"  "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem      ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Data de referencia ?","mv_ch9","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
CODIGO          DESCRICAO                                               AR          SALDO SB2          SALDO SB8          SALDO SBF LOTE       SUB-LOTE ENDERECO
XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99 999.999.999.999,99 999.999.999.999,99 999.999.999.999,99 XXXXXXXXXX  999999  XXXXXXXXXX
*/

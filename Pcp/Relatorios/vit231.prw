/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT231   ³Autor ³ Aline B. Pereira      ³Data ³ 17/05/05   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gerenciamento Estoque PA                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function vit231()
nordem   :=""
tamanho  :="G" // P , M   ou G
limite   :=220 // 80, 132 ou 220
titulo   :="GERENCIAMENTO DE PRODUTO ACABADO (GPA)"
cdesc1   :="Este programa ira emitir o gerenciamento de produto acabado (GPA)"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT231"
wnrel    :="VIT231"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)
lcontinua:=.t.

cperg:="PERGVIT231"
_pergsx1()
pergunte(cperg,.f.)


titulo+=" - DE "+dtoc(mv_par05)+" A "+dtoc(mv_par06)
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
_cfilsb2:=xfilial("SB2")
_cfilsbm:=xfilial("SBM")
_cfilsc2:=xfilial("SC2")
_cfilsc5:=xfilial("SC5")
_cfilsct:=xfilial("SCT")
_cfilsc6:=xfilial("SC6")
_cfilsd2:=xfilial("SD2")
_cfilsd3:=xfilial("SD3")
_cfilsf4:=xfilial("SF4")
_cfilsh6:=xfilial("SH6")
_cfilshc:=xfilial("SHC")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sbm->(dbsetorder(1))
sc2->(dbsetorder(1))
sc5->(dbsetorder(1))
sct->(dbsetorder(1))
sc6->(dbsetorder(1))
sd2->(dbsetorder(1))
sd3->(dbsetorder(1))
sf4->(dbsetorder(1))
sh6->(dbsetorder(1))
shc->(dbsetorder(1))

processa({|| _geratmp()})

cabec1:="CODIGO DESCRICAO                                  ESTOQUE     OP´s    PREVISAO     OP´s   FATURADO  FATURADO    OUTRAS  CARTEIRA  CARTEIRA EMPENHADO       PMP PRODUZIDO  META   COBERTURA META PREV. QUARENTENA REPROVADO"
cabec2:="                                                DISPONIVEL  PROCESSO   VENDAS    GERADAS COMERCIAL LICITACAO    SAIDAS  PED.LIC.  PED.COM.                 MES   NO MES  PROD(%)    DIAS    VENDAS(%)"

setprc(0,0)

setregua(sb1->(lastrec()))

_ntsaldo  :=0
_ntopproc :=0
_ntpreven :=0
_ntopger  :=0
_ntfatcom :=0
_ntfatlic :=0
_ntoutsai :=0
_ntcartl  :=0
_ntcartc  :=0
_ntempenho:=0
_ntpmp    :=0
_ntproduz :=0
_ntcq     :=0
_ntrean   :=0
_ntreprov :=0
_ccq      :=getmv("MV_CQ")

tmp1->(dbgotop())

while ! tmp1->(eof()) .and.;
	lcontinua

	if prow()==0 .or. prow()>56
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif

	_ngsaldo  :=0
	_ngopproc :=0
	_ngpreven :=0
	_ngopger  :=0
	_ngfatcom :=0
	_ngfatlic :=0
	_ngoutsai :=0
	_ngcartc  :=0
	_ngcartl  :=0
	_ngempenho:=0
	_ngpmp    :=0
	_ngproduz :=0
	_ngcq     :=0
	_ngrean   :=0
	_ngreprov :=0
	_cgrupo   :=tmp1->grupo

	sbm->(dbseek(_cfilsbm+tmp1->grupo))
	@ prow()+2,000 PSAY "LINHA: "+_cgrupo+" - "+sbm->bm_desc //tabela("V0",sbm->bm_tipgru+"  ")//+sbm->bm_desc
	@ prow()+1,000 PSAY replicate("-",limite)

	while ! tmp1->(eof()) .and.;
		tmp1->grupo==_cgrupo .and.;
		lcontinua

		incregua()

		if prow()>56
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif

		sb2->(dbseek(_cfilsb2+tmp1->codigo+tmp1->locpad))
		
		// SALDO DISPONIVEL
//		_nsaldo:=saldosb2()+sb2->b2_qaclass
		_nsaldo:=(sb2->b2_qatu - sb2->b2_qemp - sb2->b2_reserva)+sb2->b2_qaclass
		
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
		
		// PREVISAO DE VENDAS
		_cquery:=" SELECT"
		_cquery+=" SUM(CT_QUANT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SCT")+" SCT"
		_cquery+=" WHERE "
		_cquery+="     SCT.D_E_L_E_T_<>'*'"
		_cquery+=" AND CT_FILIAL='"+_cfilsct+"'"
		_cquery+=" AND CT_PRODUTO='"+tmp1->codigo+"'"
		_cquery+=" AND CT_DATA BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		
		tmp2->(dbgotop())
		_npreven:=0
		
		_npreven:=tmp2->quant
		tmp2->(dbclosearea())
		
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
		
		// FATURADO COMERCIAL
		_cquery:=" SELECT"
		_cquery+=" SUM(D2_QUANT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC5")+" SC5,"
		_cquery+=  retsqlname("SD2")+" SD2,"
		_cquery+=  retsqlname("SF4")+" SF4"
		_cquery+=" WHERE "
		_cquery+="     SC5.D_E_L_E_T_<>'*'"
		_cquery+=" AND SD2.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
		_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND D2_PEDIDO=C5_NUM"
		_cquery+=" AND D2_TES=F4_CODIGO"
		_cquery+=" AND D2_COD='"+tmp1->codigo+"'"
		_cquery+=" AND D2_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
		_cquery+=" AND F4_ESTOQUE='S'"
		_cquery+=" AND F4_DUPLIC='S'"
		_cquery+=" AND C5_LICITAC<>'S'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		
		tmp2->(dbgotop())
		_nfatcom:=tmp2->quant
		tmp2->(dbclosearea())
		
		// FATURADO LICITACAO
		_cquery:=" SELECT"
		_cquery+=" SUM(D2_QUANT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC5")+" SC5,"
		_cquery+=  retsqlname("SD2")+" SD2,"
		_cquery+=  retsqlname("SF4")+" SF4"
		_cquery+=" WHERE "
		_cquery+="     SC5.D_E_L_E_T_<>'*'"
		_cquery+=" AND SD2.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
		_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND D2_PEDIDO=C5_NUM"
		_cquery+=" AND D2_TES=F4_CODIGO"
		_cquery+=" AND D2_COD='"+tmp1->codigo+"'"
		_cquery+=" AND D2_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
		_cquery+=" AND C5_LICITAC='S'"
		_cquery+=" AND F4_ESTOQUE='S'"
		_cquery+=" AND F4_DUPLIC='S'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		
		tmp2->(dbgotop())
		_nfatlic:=tmp2->quant
		tmp2->(dbclosearea())
		
		// OUTRAS SAIDAS
		_cquery:=" SELECT"
		_cquery+=" SUM(D2_QUANT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SD2")+" SD2,"
		_cquery+=  retsqlname("SF4")+" SF4"
		_cquery+=" WHERE "
		_cquery+="     SD2.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND D2_TES=F4_CODIGO"
		_cquery+=" AND D2_COD='"+tmp1->codigo+"'"
		_cquery+=" AND D2_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
		_cquery+=" AND F4_ESTOQUE='S'"
		_cquery+=" AND F4_DUPLIC='N'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		
		tmp2->(dbgotop())
		_noutsai:=tmp2->quant
		tmp2->(dbclosearea())
		
		_cquery:=" SELECT"
		_cquery+=" SUM(D3_QUANT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SD3")+" SD3"
		_cquery+=" WHERE "
		_cquery+="     SD3.D_E_L_E_T_<>'*'"
		_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
		_cquery+=" AND D3_COD='"+tmp1->codigo+"'"
		_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
		_cquery+=" AND D3_TM>'500'"
		_cquery+=" AND D3_ESTORNO<>'S'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		
		tmp2->(dbgotop())
		_noutsai+=tmp2->quant
		tmp2->(dbclosearea())
		
		// CARTEIRA DE PEDIDOS - LICITACOES
		_cquery:=" SELECT"
		_cquery+=" SUM(C6_QTDVEN-C6_QTDENT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC6")+" SC6,"
		_cquery+=  retsqlname("SC5")+" SC5,"
		_cquery+=  retsqlname("SF4")+" SF4"
		_cquery+=" WHERE "
		_cquery+="     SC6.D_E_L_E_T_<>'*'"
		_cquery+=" AND SC5.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
		_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND C6_NUM=C5_NUM"
		_cquery+=" AND C6_TES=F4_CODIGO"
		_cquery+=" AND C6_PRODUTO='"+tmp1->codigo+"'"
		_cquery+=" AND C6_BLQ<>'R '"
		_cquery+=" AND C5_LICITAC='S'"
		_cquery+=" AND F4_ESTOQUE='S'"
		//		_cquery+=" AND F4_DUPLIC='S'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		
		tmp2->(dbgotop())
		_ncartpedl:=tmp2->quant
		tmp2->(dbclosearea())
		
		// CARTEIRA DE PEDIDOS - COMERCIAL
		_cquery:=" SELECT"
		_cquery+=" SUM(C6_QTDVEN-C6_QTDENT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SC6")+" SC6,"
		_cquery+=  retsqlname("SC5")+" SC5,"
		_cquery+=  retsqlname("SF4")+" SF4"
		_cquery+=" WHERE "
		_cquery+="     SC6.D_E_L_E_T_<>'*'"
		_cquery+=" AND SC5.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
		_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND C6_NUM=C5_NUM"
		_cquery+=" AND C6_TES=F4_CODIGO"
		_cquery+=" AND C6_PRODUTO='"+tmp1->codigo+"'"
		_cquery+=" AND C6_BLQ<>'R '"
		_cquery+=" AND C5_LICITAC='N'"
		_cquery+=" AND F4_ESTOQUE='S'"
		//		_cquery+=" AND F4_DUPLIC='S'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		
		tmp2->(dbgotop())
		_ncartpedc:=tmp2->quant
		tmp2->(dbclosearea())
		
		// EMPENHADO
		_nempenho:=sb2->b2_qemp+sb2->b2_reserva
		
		// PMP
		_cquery:=" SELECT"
		_cquery+=" SUM(HC_QUANT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SHC")+" SHC"
		_cquery+=" WHERE "
		_cquery+="     SHC.D_E_L_E_T_<>'*'"
		_cquery+=" AND HC_FILIAL='"+_cfilshc+"'"
		_cquery+=" AND HC_PRODUTO='"+tmp1->codigo+"'"
		_cquery+=" AND HC_DATA BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		
		tmp2->(dbgotop())
		_npmp:=tmp2->quant
		tmp2->(dbclosearea())
		
		// PRODUZIDO NO MES
		_cquery:=" SELECT"
		_cquery+=" SUM(D3_QUANT) QUANT"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SD3")+" SD3"
		_cquery+=" WHERE "
		_cquery+="     SD3.D_E_L_E_T_<>'*'"
		_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
		_cquery+=" AND D3_COD='"+tmp1->codigo+"'"
		_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
		_cquery+=" AND D3_CF='PR0'"
		_cquery+=" AND D3_ESTORNO<>'S'"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tcsetfield("TMP2","QUANT","N",07,0)
		
		tmp2->(dbgotop())
		_nproduz:=tmp2->quant
		tmp2->(dbclosearea())
		
		// META MES
		_nmetames:=round((_nproduz/_npmp)*100,2)
		//		_nmetames:=round((_npreven/_nproduz)*100,2)
		
		// COBERTURA DIAS
		//		_ncobert:=round((_nsaldo/_npreven)*day(lastday(mv_par06)),2)
		_ncobert:=round((_nsaldo/_npreven)*30,2)
		
		// META DA PREVISAO DE VENDAS
		_nmetaprev:=round(((_nfatcom+_nfatlic)/_npreven)*100,2)
		
		// QUARENTENA
		sb2->(dbseek(_cfilsb2+tmp1->codigo+_ccq))
		_ncq:=sb2->b2_qatu
		
		// REANALISE
		sb2->(dbseek(_cfilsb2+tmp1->codigo+"96"))
		_nrean:=sb2->b2_qatu
		
		// REPROVADOS
		sb2->(dbseek(_cfilsb2+tmp1->codigo+"97"))
		_nreprov:=sb2->b2_qatu

		if prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		
		@ prow()+1,000 PSAY left(tmp1->codigo,6)
		@ prow(),007   PSAY left(tmp1->descricao,40)
		@ prow(),049   PSAY _nsaldo   picture "@E 9,999,999"
		@ prow(),059   PSAY _nopproc  picture "@E 9,999,999"
		@ prow(),069   PSAY _npreven  picture "@E 9,999,999"
		@ prow(),079   PSAY _nopger   picture "@E 9,999,999"
		@ prow(),089   PSAY _nfatcom  picture "@E 9,999,999"
		@ prow(),099   PSAY _nfatlic  picture "@E 9,999,999"
		@ prow(),109   PSAY _noutsai  picture "@E 9,999,999"
		@ prow(),119   PSAY _ncartpedl picture "@E 9,999,999"
		@ prow(),129   PSAY _ncartpedc picture "@E 9,999,999"
		@ prow(),139   PSAY _nempenho picture "@E 9,999,999"
		@ prow(),149   PSAY _npmp     picture "@E 9,999,999"
		@ prow(),159   PSAY _nproduz  picture "@E 9,999,999"
		@ prow(),169   PSAY _nmetames picture "@E 9999.99"
		@ prow(),179   PSAY _ncobert  picture "@E 9999.99"
		@ prow(),189   PSAY _nmetaprev  picture "@E 9999.99"
		@ prow(),199   PSAY _ncq      picture "@E 9,999,999"
		@ prow(),209   PSAY _nreprov  picture "@E 9,999,999"

		_ngsaldo  +=_nsaldo
		_ngopproc +=_nopproc
		_ngpreven +=_npreven
		_ngopger  +=_nopger
		_ngfatcom +=_nfatcom
		_ngfatlic +=_nfatlic
		_ngoutsai +=_noutsai
		_ngcartl  +=_ncartpedl
		_ngcartc  +=_ncartpedc
		_ngempenho+=_nempenho
		_ngpmp    +=_npmp
		_ngproduz +=_nproduz
		_ngcq     +=_ncq
		_ngrean   +=_nrean
		_ngreprov +=_nreprov

		tmp1->(dbskip())

		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif
	end
	
	if lcontinua
		if prow()>60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		
		@ prow()+1,000 PSAY replicate("-",limite)
		@ prow()+1,000 PSAY "TOTAIS DA LINHA"
		@ prow(),049   PSAY _ngsaldo   picture "@E 9,999,999"
		@ prow(),059   PSAY _ngopproc  picture "@E 9,999,999"
		@ prow(),069   PSAY _ngpreven  picture "@E 9,999,999"
		@ prow(),079   PSAY _ngopger   picture "@E 9,999,999"
		@ prow(),089   PSAY _ngfatcom  picture "@E 9,999,999"
		@ prow(),099   PSAY _ngfatlic  picture "@E 9,999,999"
		@ prow(),109   PSAY _ngoutsai  picture "@E 9,999,999"
		@ prow(),119   PSAY _ngcartl   picture "@E 9,999,999"
		@ prow(),129   PSAY _ngcartc   picture "@E 9,999,999"
		@ prow(),139   PSAY _ngempenho picture "@E 9,999,999"
		@ prow(),149   PSAY _ngpmp     picture "@E 9,999,999"
		@ prow(),159   PSAY _ngproduz  picture "@E 9,999,999"
		@ prow(),169   PSAY round((_ngproduz/_ngpmp)*100,2) picture "@E 999,99"
		@ prow(),179   PSAY round((_ngsaldo/_ngpreven)*30,2)  picture "@E 999,99"
		@ prow(),189   PSAY round(((_ngfatcom+_ngfatlic)/_ngpreven)*100,2)  picture "@E 999,99"
		@ prow(),199   PSAY _ngcq      picture "@E 9,999,999"
		@ prow(),209   PSAY _ngreprov  picture "@E 9,999,999"

		_ntsaldo  +=_ngsaldo
		_ntopproc +=_ngopproc
		_ntpreven +=_ngpreven
		_ntopger  +=_ngopger
		_ntfatcom +=_ngfatcom
		_ntfatlic +=_ngfatlic
		_ntoutsai +=_ngoutsai
		_ntcartl  +=_ngcartl
		_ntcartc  +=_ngcartc
		_ntempenho+=_ngempenho
		_ntpmp    +=_ngpmp
		_ntproduz +=_ngproduz
		_ntcq     +=_ngcq
		_ntrean   +=_ngrean
		_ntreprov +=_ngreprov
	endif
end

if prow()>58
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
endif

@ prow()+1,000 PSAY replicate("-",limite)
@ prow()+1,000 PSAY "TOTAIS DO RELATORIO"
@ prow(),049   PSAY _ntsaldo   picture "@E 9,999,999"
@ prow(),059   PSAY _ntopproc  picture "@E 9,999,999"
@ prow(),069   PSAY _ntpreven  picture "@E 9,999,999"
@ prow(),079   PSAY _ntopger   picture "@E 9,999,999"
@ prow(),089   PSAY _ntfatcom  picture "@E 9,999,999"
@ prow(),099   PSAY _ntfatlic  picture "@E 9,999,999"
@ prow(),109   PSAY _ntoutsai  picture "@E 9,999,999"
@ prow(),119   PSAY _ntcartl   picture "@E 9,999,999"
@ prow(),129   PSAY _ntcartc   picture "@E 9,999,999"
@ prow(),139   PSAY _ntempenho picture "@E 9,999,999"
@ prow(),149   PSAY _ntpmp     picture "@E 9,999,999"
@ prow(),159   PSAY _ntproduz  picture "@E 9,999,999"
@ prow(),169   PSAY (_ntproduz/_ntpmp)*100 picture "@E 9999,99"
@ prow(),179   PSAY (_ntsaldo/_ntpreven)*30  picture "@E 9999,99"
@ prow(),189   PSAY ((_ntfatcom+_ntfatlic)/_ntpreven)*100  picture "@E 9,999,99"

@ prow(),199   PSAY _ntcq      picture "@E 9,999,999"
@ prow(),209   PSAY _ntreprov  picture "@E 9,999,999"

set device to screen

tmp1->(dbclosearea())

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()
return

static function _geratmp()
procregua(1)
incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_GRUPO GRUPO,B1_DESC DESCRICAO,B1_COD CODIGO,B1_LOCPAD LOCPAD"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE "
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
//_cquery+=" AND B1_CLASSE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND B1_TIPO='PA'"
//_cquery+=" AND B1_STATDES<>'DE'"
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
aadd(_agrpsx1,{cperg,"05","Da data            ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate a data         ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{cperg,"07","Da classe comercial?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"Z2 "})
//aadd(_agrpsx1,{cperg,"08","Ate a classe comerc?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"Z2 "})

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
CODIGO DESCRICAO                                  ESTOQUE     OP´s    PREVISAO     OP´s   FATURADO  FATURADO    OUTRAS  CARTEIRA EMPENHADO       PMP PRODUZIDO  META   COBERTURA META PREV. QUARENTENA REANALISE REPROVADO
DISPONIVEL  PROCESSO   VENDAS    GERADAS COMERCIAL LICITACAO    SAIDAS   PEDIDOS                 MES   NO MES  MES (%)    DIAS   VENDAS (%)
999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  9.999.999 9.999.999 9.999.999 9.999.999 9.999.999 9.999.999 9.999.999 9.999.999 9.999.999 9.999.999 9.999.999 9999,99   9999,99  9999,99    9.999.999 9.999.999 9.999.999
*/

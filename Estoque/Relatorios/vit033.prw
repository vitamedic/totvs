/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT033   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 28/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo da Movimentacao do Estoque de PA                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit033()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="RESUMO DA MOVIMENTACAO DO ESTOQUE DE PA"
cdesc1   :="Este programa ira emitir o resumo da movimentacao do estoque de PA"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT033"
wnrel    :="VIT033"+Alltrim(cusername)
aordem  :={"Descricao","Dias Estoque","Qtde.Pendente"}
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT033"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)
nordem:=areturn[8]
if nlastkey==27
	set filter to
	return
endif
rptstatus({|| rptdetail()})
return

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)
if nordem ==1
	_mtipo:= "Descricao"
elseif nordem==2
	_mtipo:= "Dias Estoque"
else
	_mtipo:="Qtde.Pendente"
endif

titulo:="RESUMO DA MOVIMENTACAO DO ESTOQUE EM "+dtoc(ddatabase)+ " - "+_mtipo

cabec1:="                                           S A I D A S                        E S T O Q U E"
if mv_par01 ==1
	cabec2:="Codigo Descricao                   Mes Ant.   No Mes   No Dia    Media  Ent.Mes  Ent.Dia Processo    Saldo Pendencia Dias Quarentena"
else
	cabec2:="Codigo Descricao                   Mes Ant.   No Mes   Lt.Padrao Media  Ent.Mes  Ent.Dia Processo    Saldo Pendencia Dias Quarentena"
endif
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsc2:=xfilial("SC2")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsc9:=xfilial("SC9")
_cfilsd5:=xfilial("SD5")
_cfilsd7:=xfilial("SD7")
_cfilsf4:=xfilial("SF4")
_cfilsbm:=xfilial("SBM")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sc2->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(1))
sc9->(dbsetorder(1))
sd5->(dbsetorder(1))
sd7->(dbsetorder(1))
sf4->(dbsetorder(1))
sbm->(dbsetorder(1))

if month(ddatabase)==01
	_cmesant:="12"
else
	_cmesant:=strzero(month(ddatabase)-1,2)
endif
if month(ddatabase)==01
	_canoant:=strzero(year(ddatabase)-1,4)
else
	_canoant:=strzero(year(ddatabase),4)
endif
_diniant:=ctod("01/"+_cmesant+"/"+_canoant)
_dfimant:=lastday(_diniant)
_diniatu:=firstday(ddatabase)
if month(ddatabase)==01
	_cmesmed:="10"
elseif month(ddatabase)==02
	_cmesmed:="11"
elseif month(ddatabase)==03
	_cmesmed:="12"
else
	_cmesmed:=strzero(month(ddatabase)-3)
endif
if month(ddatabase)<=03
	_canomed:=strzero(year(ddatabase)-1,4)
else
	_canomed:=strzero(year(ddatabase),4)
endif
_dinimed :=ctod("01/"+_cmesmed+"/"+_canomed)
_dfimmed :=_dfimant
_ccq     :=getmv("MV_CQ")
_ntsaiant:=0
_ntsaimes:=0
_ntsaidia:=0
_ntentmes:=0
_ntentdia:=0  	
_ntproces:=0
_ntsaldo :=0
_ntpenden:=0
_ntquaren:=0
_acom    :={}
_ahos    :={}

if mv_par01 ==1
	processa({|| _geratmp()})
else
	processa({|| _geratmp2()})
endif

setprc(0,0)
setregua(sb1->(lastrec()))
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	sb1->(dbseek(_cfilsb1+tmp1->produto))
	
	// SAIDA DO MES ANTERIOR
	_cquery:=" SELECT"
	_cquery+=" SUM(D5_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD5")+" SD5"
	_cquery+=" WHERE"
	_cquery+="     SD5.D_E_L_E_T_<>'*'"
	_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
	_cquery+=" AND D5_PRODUTO='"+sb1->b1_cod+"'"
	_cquery+=" AND D5_LOCAL='"+sb1->b1_locpad+"'"
	_cquery+=" AND D5_ORIGLAN>='500'"
	_cquery+=" AND D5_ESTORNO<>'S'"
//	_cquery+=" AND D5_CLIFOR<>' '"
	_cquery+=" AND D5_SERIE<>'   '"
	_cquery+=" AND D5_DATA BETWEEN '"+dtos(_diniant)+"' AND '"+dtos(_dfimant)+"'"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",07,0)
	
	tmp2->(dbgotop())
	_nsaiant:=tmp2->quant
	tmp2->(dbclosearea())
	
	// SAIDA NO MES ATUAL
	_cquery:=" SELECT"
	_cquery+=" SUM(D5_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD5")+" SD5"
	_cquery+=" WHERE"
	_cquery+="     SD5.D_E_L_E_T_<>'*'"
	_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
	_cquery+=" AND D5_PRODUTO='"+sb1->b1_cod+"'"
	_cquery+=" AND D5_LOCAL='"+sb1->b1_locpad+"'"
	_cquery+=" AND D5_ORIGLAN>='500'"
	_cquery+=" AND D5_ESTORNO<>'S'"
//	_cquery+=" AND D5_CLIFOR<>' '"
	_cquery+=" AND D5_SERIE<>'   '"
	_cquery+=" AND D5_DATA BETWEEN '"+dtos(_diniatu)+"' AND '"+dtos(ddatabase)+"'"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",07,0)
	
	tmp2->(dbgotop())
	_nsaimes:=tmp2->quant
	tmp2->(dbclosearea())
	
	// SAIDA NO DIA
	_cquery:=" SELECT"
	_cquery+=" SUM(D5_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD5")+" SD5"
	_cquery+=" WHERE"
	_cquery+="     SD5.D_E_L_E_T_<>'*'"
	_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
	_cquery+=" AND D5_PRODUTO='"+sb1->b1_cod+"'"
	_cquery+=" AND D5_LOCAL='"+sb1->b1_locpad+"'"
	_cquery+=" AND D5_ORIGLAN>='500'"
	_cquery+=" AND D5_ESTORNO<>'S'"
//	_cquery+=" AND D5_SERIE<>'   '"
	_cquery+=" AND D5_CLIFOR<>' '"
	_cquery+=" AND D5_DATA='"+dtos(ddatabase)+"'"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",07,0)
	
	tmp2->(dbgotop())
	_nsaidia:=tmp2->quant
	tmp2->(dbclosearea())
	
	// SAIDA MEDIA DOS ULTIMOS 3 MESES
	_cquery:=" SELECT"
	_cquery+=" SUM(D5_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD5")+" SD5"
	_cquery+=" WHERE"
	_cquery+="     SD5.D_E_L_E_T_<>'*'"
	_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
	_cquery+=" AND D5_PRODUTO='"+sb1->b1_cod+"'"
	_cquery+=" AND D5_LOCAL='"+sb1->b1_locpad+"'"
	_cquery+=" AND D5_ORIGLAN>='500'"
	_cquery+=" AND D5_ESTORNO<>'S'"
//	_cquery+=" AND D5_CLIFOR<>' '"
	_cquery+=" AND D5_SERIE<>'   '"
	_cquery+=" AND D5_DATA BETWEEN '"+dtos(_dinimed)+"' AND '"+dtos(_dfimmed)+"'"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",07,0)
	
	tmp2->(dbgotop())
	_nsaimed:=int(tmp2->quant/3)
	tmp2->(dbclosearea())
	
	// ENTRADA NO MES
	_cquery:=" SELECT"
	_cquery+=" SUM(D5_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD5")+" SD5,"
	_cquery+=  retsqlname("SD7")+" SD7"
	_cquery+=" WHERE"
	_cquery+="     SD5.D_E_L_E_T_<>'*'"
	_cquery+=" and SD7.D_E_L_E_T_<>'*'"
	_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
	_cquery+=" AND D7_FILIAL='"+_cfilsd7+"'"
	_cquery+=" AND D5_PRODUTO='"+sb1->b1_cod+"'"
	_cquery+=" AND D5_LOCAL='"+sb1->b1_locpad+"'"
	_cquery+=" AND D5_ORIGLAN<'500'"
	_cquery+=" AND D5_ESTORNO<>'S'"
	_cquery+=" AND D5_DATA BETWEEN '"+dtos(_diniatu)+"' AND '"+dtos(ddatabase)+"'"
	_cquery+=" AND D5_PRODUTO=D7_PRODUTO"
	_cquery+=" AND D5_LOTECTL=D7_LOTECTL"
	_cquery+=" AND D5_DOC=D7_NUMERO"
	_cquery+=" AND D5_NUMSEQ=D7_NUMSEQ"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",07,0)
	
	tmp2->(dbgotop())
	_nentmes:=tmp2->quant
	tmp2->(dbclosearea())
	
	// ENTRADA NO DIA
	_cquery:=" SELECT"
	_cquery+=" SUM(D5_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD5")+" SD5,"
	_cquery+=  retsqlname("SD7")+" SD7"
	_cquery+=" WHERE"
	_cquery+="     SD5.D_E_L_E_T_<>'*'"
	_cquery+=" AND SD7.D_E_L_E_T_<>'*'"
	_cquery+=" AND D5_FILIAL='"+_cfilsd5+"'"
	_cquery+=" AND D7_FILIAL='"+_cfilsd7+"'"
	_cquery+=" AND D5_PRODUTO='"+sb1->b1_cod+"'"
	_cquery+=" AND D5_LOCAL='"+sb1->b1_locpad+"'"
	_cquery+=" AND D5_ORIGLAN<'500'"
	_cquery+=" AND D5_ESTORNO<>'S'"
	_cquery+=" AND D5_DATA='"+dtos(ddatabase)+"'"
	_cquery+=" AND D5_PRODUTO=D7_PRODUTO"
	_cquery+=" AND D5_LOTECTL=D7_LOTECTL"
	_cquery+=" AND D5_DOC=D7_NUMERO"
	_cquery+=" AND D5_NUMSEQ=D7_NUMSEQ"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",07,0)
	
	tmp2->(dbgotop())
	_nentdia:=tmp2->quant
	tmp2->(dbclosearea())
	
	// SALDO EM PROCESSO (ORDENS DE PRODUCAO EM ABERTO)
	_cquery:=" SELECT"
	_cquery+=" SUM(C2_QUANT-C2_QUJE) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC2")+" SC2"
	_cquery+=" WHERE"
	_cquery+="     SC2.D_E_L_E_T_<>'*'"
	_cquery+=" AND C2_FILIAL='"+_cfilsc2+"'"
	_cquery+=" AND C2_PRODUTO='"+sb1->b1_cod+"'"
	_cquery+=" AND C2_DATRF='        '"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",07,0)
	
	tmp2->(dbgotop())
	_nproces:=tmp2->quant
	tmp2->(dbclosearea())
	
	// SALDO ATUAL
	if sb2->(dbseek(_cfilsb2+sb1->b1_cod+sb1->b1_locpad))
		_nsaldo:=int(sb2->b2_qatu-sb2->b2_reserva-sb2->b2_qemp)
	else
		_nsaldo:=0
	endif
	
	// PENDENCIA (PEDIDOS DE VENDA EM ABERTO)
	_cquery:=" SELECT"
	_cquery+=" SUM(C6_QTDVEN-C6_QTDENT) QTDPEN"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC5")+" SC5,"
	_cquery+=  retsqlname("SC6")+" SC6,"
	_cquery+=  retsqlname("SF4")+" SF4"
	_cquery+=" WHERE"
	_cquery+="     SC5.D_E_L_E_T_<>'*'"
	_cquery+=" AND SC6.D_E_L_E_T_<>'*'"
	_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
	_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
	_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
	_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
	_cquery+=" AND C6_PRODUTO='"+sb1->b1_cod+"'"
	_cquery+=" AND C6_LOCAL='"+sb1->b1_locpad+"'"
	_cquery+=" AND C6_NUM=C5_NUM"
	_cquery+=" AND C6_TES=F4_CODIGO"
	_cquery+=" AND C6_BLQ<>'R '"
	_cquery+=" AND (C6_QTDVEN-C6_QTDENT)>0"
	_cquery+=" AND C5_TIPO='N'"
	_cquery+=" AND F4_ESTOQUE='S'"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QTDPEN","N",07,0)
	
	_npenden:=tmp2->qtdpen
	tmp2->(dbclosearea())
	
	_cquery:=" SELECT"
	_cquery+=" SUM(C9_QTDLIB) QTDLIB"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC5")+" SC5,"
	_cquery+=  retsqlname("SC6")+" SC6,"
	_cquery+=  retsqlname("SC9")+" SC9,"
	_cquery+=  retsqlname("SF4")+" SF4"
	_cquery+=" WHERE"
	_cquery+="     SC5.D_E_L_E_T_<>'*'"
	_cquery+=" AND SC6.D_E_L_E_T_<>'*'"
	_cquery+=" AND SC9.D_E_L_E_T_<>'*'"
	_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
	_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
	_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
	_cquery+=" AND C9_FILIAL='"+_cfilsc9+"'"
	_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
	_cquery+=" AND C9_PRODUTO='"+sb1->b1_cod+"'"
	_cquery+=" AND C9_LOCAL='"+sb1->b1_locpad+"'"
	_cquery+=" AND C9_PEDIDO=C6_NUM"
	_cquery+=" AND C9_ITEM=C6_ITEM"
	_cquery+=" AND C6_NUM=C5_NUM"
	_cquery+=" AND C6_TES=F4_CODIGO"
	_cquery+=" AND C6_BLQ<>'R '"
	_cquery+=" AND (C6_QTDVEN-C6_QTDENT)>0"
	_cquery+=" AND C5_TIPO='N'"
	_cquery+=" AND F4_ESTOQUE='S'"
	_cquery+=" AND C9_NFISCAL='      '"
	_cquery+=" AND C9_BLCRED='  '"
	_cquery+=" AND C9_BLEST='  '"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QTDLIB","N",07,0)
	
	_nqtdlib:=tmp2->qtdlib
	tmp2->(dbclosearea())
	
	_npenden-=_nqtdlib
	
	// NUMERO DE DIAS DO ESTOQUE
	if _nsaimed==0
		_ndias:=int(((_nsaldo-_npenden)/_nsaimes)*30)
	else
		_ndias:=int(((_nsaldo-_npenden)/_nsaimed)*30)
	endif
	
	// SALDO EM QUARENTENA
	if sb2->(dbseek(_cfilsb2+sb1->b1_cod+_ccq))
		_nquaren:=int(sb2->b2_qatu-sb2->b2_reserva-sb2->b2_qemp)
	else
		_nquaren:=0
	endif
	if mv_par01 ==1
		if sb1->b1_apreven=="1"
			aadd(_acom,{sb1->b1_cod,sb1->b1_desc,_nsaiant,_nsaimes,_nsaidia,;
			_nsaimed,_nentmes,_nentdia,_nproces,_nsaldo,_npenden,;
			_ndias,_nquaren})
		else
			aadd(_ahos,{sb1->b1_cod,sb1->b1_desc,_nsaiant,_nsaimes,_nsaidia,;
			_nsaimed,_nentmes,_nentdia,_nproces,_nsaldo,_npenden,;
			_ndias,_nquaren})
		endif
	else
		if sb1->b1_apreven=="1"
			aadd(_acom,{sb1->b1_cod,sb1->b1_desc,_nsaiant,_nsaimes,sb1->b1_le,;
			_nsaimed,_nentmes,_nentdia,_nproces,_nsaldo,_npenden,;
			_ndias,_nquaren,sb1->b1_grupo})
		else
			aadd(_ahos,{sb1->b1_cod,sb1->b1_desc,_nsaiant,_nsaimes,sb1->b1_le,;
			_nsaimed,_nentmes,_nentdia,_nproces,_nsaldo,_npenden,;
			_ndias,_nquaren,sb1->b1_grupo})
		endif
	endif
	_ntsaiant+=_nsaiant
	_ntsaimes+=_nsaimes
	_ntsaidia+=_nsaidia
	_ntentmes+=_nentmes
	_ntentdia+=_nentdia
	_ntproces+=_nproces
	_ntsaldo +=_nsaldo
	_ntpenden+=_npenden
	_ntquaren+=_nquaren
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if lcontinua
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	_ncsaiant:=0
	_ncsaimes:=0
	_ncsaidia:=0
	_ncentmes:=0
	_ncentdia:=0
	_ncproces:=0
	_ncsaldo :=0
	_ncpenden:=0
	_ncquaren:=0
	_nlsaiant:=0
	_nlsaimes:=0
	_nlsaidia:=0
	_nlentmes:=0
	_nlentdia:=0
	_nlproces:=0
	_nlsaldo :=0
	_nlpenden:=0
	_nlquaren:=0
	_smtp := "  "
	_sbmt := "      "
	_mgr :="  "
	if nordem<>1
		if nordem==2
			_acoms:= asort(_acom,,,{|x,y| x[12]<y[12]})
		else
			_acoms := asort(_acom,,,{|x,y| x[11]<y[11]})
		endif
		for _i:=1 to len(_acoms)
			if prow()>54
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if mv_par01 <>1
				sbm->(dbseek(_cfilsbm+_acoms[_i,14]))
				if _smtp <> sbm->bm_tipgru
					_smtp := sbm->bm_tipgru
					_totsbm()
				endif
			endif
			@ prow()+1,000 PSAY left(_acoms[_i,1],6)
			@ prow(),007   PSAY left(_acoms[_i,2],27)
			@ prow(),035   PSAY _acoms[_i,3] picture "@E 9999,999"
			@ prow(),044   PSAY _acoms[_i,4] picture "@E 9999,999"
			@ prow(),053   PSAY _acoms[_i,5] picture "@E 9999,999"
			@ prow(),062   PSAY _acoms[_i,6] picture "@E 9999,999"
			@ prow(),071   PSAY _acoms[_i,7] picture "@E 9999,999"
			@ prow(),080   PSAY _acoms[_i,8] picture "@E 9999,999"
			@ prow(),089   PSAY _acoms[_i,9] picture "@E 9999,999"
			@ prow(),098   PSAY _acoms[_i,10] picture "@E 9999,999"
			@ prow(),108   PSAY _acoms[_i,11] picture "@E 9999,999"
			@ prow(),117   PSAY _acoms[_i,12] picture "@E 9999"
			@ prow(),124   PSAY _acoms[_i,13] picture "@E 9999,999"
			_ncsaiant+=_acoms[_i,3]
			_ncsaimes+=_acoms[_i,4]
			if mv_par01 ==1
				_ncsaidia+=_acoms[_i,5]
			else
				_sbmt := sbm->bm_tipgru+"    "
				_ncsaidia+=0
				_mgr1 := _acoms[_i,14]
				_nlsaiant+=_acoms[_i,3]
				_nlsaimes+=_acoms[_i,4]
				_nlsaidia+=0
				_nlentmes+=_acoms[_i,7]
				_nlentdia+=_acoms[_i,8]
				_nlproces+=_acoms[_i,9]
				_nlsaldo +=_acoms[_i,10]
				_nlpenden+=_acoms[_i,11]
				_nlquaren+=_acoms[_i,13]
			endif
			_ncentmes+=_acoms[_i,7]
			_ncentdia+=_acoms[_i,8]
			_ncproces+=_acoms[_i,9]
			_ncsaldo +=_acoms[_i,10]
			_ncpenden+=_acoms[_i,11]
			_ncquaren+=_acoms[_i,13]
		next
	else
		for _i:=1 to len(_acom)
			if prow()>54
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if mv_par01 <>1
				sbm->(dbseek(_cfilsbm+_acom[_i,14]))
				if _smtp <> sbm->bm_tipgru
					_smtp := sbm->bm_tipgru
					_totsbm()
				endif
			endif
			@ prow()+1,000 PSAY left(_acom[_i,1],6)
			@ prow(),007   PSAY left(_acom[_i,2],27)
			@ prow(),035   PSAY _acom[_i,3] picture "@E 9999,999"
			@ prow(),044   PSAY _acom[_i,4] picture "@E 9999,999"
			@ prow(),053   PSAY _acom[_i,5] picture "@E 9999,999"
			@ prow(),062   PSAY _acom[_i,6] picture "@E 9999,999"
			@ prow(),071   PSAY _acom[_i,7] picture "@E 9999,999"
			@ prow(),080   PSAY _acom[_i,8] picture "@E 9999,999"
			@ prow(),089   PSAY _acom[_i,9] picture "@E 9999,999"
			@ prow(),098   PSAY _acom[_i,10] picture "@E 9999,999"
			@ prow(),108   PSAY _acom[_i,11] picture "@E 9999,999"
			@ prow(),117   PSAY _acom[_i,12] picture "@E 9999"
			@ prow(),124   PSAY _acom[_i,13] picture "@E 9999,999"
			_ncsaiant+=_acom[_i,3]
			_ncsaimes+=_acom[_i,4]
			if mv_par01 ==1
				_ncsaidia+=_acom[_i,5]
			else
				_sbmt := sbm->bm_tipgru+"    "
				_ncsaidia+=0
				_mgr1 := _acom[_i,14]
				_nlsaiant+=_acom[_i,3]
				_nlsaimes+=_acom[_i,4]
				_nlsaidia+=0
				_nlentmes+=_acom[_i,7]
				_nlentdia+=_acom[_i,8]
				_nlproces+=_acom[_i,9]
				_nlsaldo +=_acom[_i,10]
				_nlpenden+=_acom[_i,11]
				_nlquaren+=_acom[_i,13]
			endif
			_ncentmes+=_acom[_i,7]
			_ncentdia+=_acom[_i,8]
			_ncproces+=_acom[_i,9]
			_ncsaldo +=_acom[_i,10]
			_ncpenden+=_acom[_i,11]
			_ncquaren+=_acom[_i,13]
		next
		
	endif
	if mv_par01 <>1
		sbm->(dbseek(_cfilsbm+_mgr))
		_smtp := sbm->bm_tipgru
		_totsbm()
	endif
	if mv_par01 ==1
		@ prow()+1,000 PSAY "TOTAL COMERCIAL"
		@ prow(),035   PSAY _ncsaiant picture "@E 9999,999"
		@ prow(),044   PSAY _ncsaimes picture "@E 9999,999"
		@ prow(),053   PSAY _ncsaidia picture "@E 9999,999"
	else
		@ prow()+1,000 PSAY "TOTAL COMERCIAL"
		@ prow(),035   PSAY _ncsaiant picture "@E 9999,999"
		@ prow(),044   PSAY _ncsaimes picture "@E 9999,999"
	endif
	@ prow(),071   PSAY _ncentmes picture "@E 9999,999"
	@ prow(),080   PSAY _ncentdia picture "@E 9999,999"
	@ prow(),089   PSAY _ncproces picture "@E 9999,999"
	@ prow(),098   PSAY _ncsaldo  picture "@E 9999,999"
	@ prow(),108   PSAY _ncpenden picture "@E 9999,999"
	@ prow(),124   PSAY _ncquaren picture "@E 9999,999"
	@ prow()+1,000 PSAY " "
	_nhsaiant:=0
	_nhsaimes:=0
	_nhsaidia:=0
	_nhentmes:=0
	_nhentdia:=0
	_nhproces:=0
	_nhsaldo :=0
	_nhpenden:=0
	_nhquaren:=0
	_smtp := "  "
	_sbmt := "      "
	_mgr :="      "
	_mgr1 :="      "
	if nordem<>1
		if nordem==2
			_ahoss:= asort(_ahos,,,{|x,y| x[12]<y[12]})
		else
			_ahoss:= asort(_ahos,,,{|x,y| x[11]<y[11]})
		endif
		
		for _i:=1 to len(_ahoss)
			if prow()>54
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if mv_par01 <>1
				sbm->(dbseek(_cfilsbm+_ahoss[_i,14]))
				if _smtp <> sbm->bm_tipgru
					_smtp := sbm->bm_tipgru
					_totsbm()
				endif
			endif
			@ prow()+1,000 PSAY left(_ahoss[_i,1],6)
			@ prow(),007   PSAY left(_ahoss[_i,2],27)
			@ prow(),035   PSAY _ahoss[_i,3] picture "@E 9999,999"
			@ prow(),044   PSAY _ahoss[_i,4] picture "@E 9999,999"
			@ prow(),053   PSAY _ahoss[_i,5] picture "@E 9999,999"
			@ prow(),062   PSAY _ahoss[_i,6] picture "@E 9999,999"
			@ prow(),071   PSAY _ahoss[_i,7] picture "@E 9999,999"
			@ prow(),080   PSAY _ahoss[_i,8] picture "@E 9999,999"
			@ prow(),089   PSAY _ahoss[_i,9] picture "@E 9999,999"
			@ prow(),098   PSAY _ahoss[_i,10] picture "@E 9999,999"
			@ prow(),108   PSAY _ahoss[_i,11] picture "@E 9999,999"
			@ prow(),117   PSAY _ahoss[_i,12] picture "@E 9999"
			@ prow(),124   PSAY _ahoss[_i,13] picture "@E 9999,999"
			_nhsaiant+=_ahoss[_i,3]
			_nhsaimes+=_ahoss[_i,4]
			if mv_par01 = 1
				_nhsaidia+=_ahoss[_i,5]
			else
				_sbmt := sbm->bm_tipgru+"    "
				_mgr1 := _ahoss[_i,14]
				_nhsaidia+=0
				_nlsaiant+=_ahoss[_i,3]
				_nlsaimes+=_ahoss[_i,4]
				_nlsaidia+=0
				_nlentmes+=_ahoss[_i,7]
				_nlentdia+=_ahoss[_i,8]
				_nlproces+=_ahoss[_i,9]
				_nlsaldo +=_ahoss[_i,10]
				_nlpenden+=_ahoss[_i,11]
				_nlquaren+=_ahoss[_i,13]
			endif
			_nhentmes+=_ahoss[_i,7]
			_nhentdia+=_ahoss[_i,8]
			_nhproces+=_ahoss[_i,9]
			_nhsaldo +=_ahoss[_i,10]
			_nhpenden+=_ahoss[_i,11]
			_nhquaren+=_ahoss[_i,13]
		next
	else
		for _i:=1 to len(_ahos)
			if prow()>54
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if mv_par01 <>1
				sbm->(dbseek(_cfilsbm+_ahos[_i,14]))
				if _smtp <> sbm->bm_tipgru
					_smtp := sbm->bm_tipgru
					_totsbm()
				endif
			endif
			@ prow()+1,000 PSAY left(_ahos[_i,1],6)
			@ prow(),007   PSAY left(_ahos[_i,2],27)
			@ prow(),035   PSAY _ahos[_i,3] picture "@E 9999,999"
			@ prow(),044   PSAY _ahos[_i,4] picture "@E 9999,999"
			@ prow(),053   PSAY _ahos[_i,5] picture "@E 9999,999"
			@ prow(),062   PSAY _ahos[_i,6] picture "@E 9999,999"
			@ prow(),071   PSAY _ahos[_i,7] picture "@E 9999,999"
			@ prow(),080   PSAY _ahos[_i,8] picture "@E 9999,999"
			@ prow(),089   PSAY _ahos[_i,9] picture "@E 9999,999"
			@ prow(),098   PSAY _ahos[_i,10] picture "@E 9999,999"
			@ prow(),108   PSAY _ahos[_i,11] picture "@E 9999,999"
			@ prow(),117   PSAY _ahos[_i,12] picture "@E 9999"
			@ prow(),124   PSAY _ahos[_i,13] picture "@E 9999,999"
			_nhsaiant+=_ahos[_i,3]
			_nhsaimes+=_ahos[_i,4]
			if mv_par01 = 1
				_nhsaidia+=_ahos[_i,5]
			else
				_sbmt := sbm->bm_tipgru+"    "
				_mgr1 := _ahos[_i,14]
				_nhsaidia+=0
				_nlsaiant+=_ahos[_i,3]
				_nlsaimes+=_ahos[_i,4]
				_nlsaidia+=0
				_nlentmes+=_ahos[_i,7]
				_nlentdia+=_ahos[_i,8]
				_nlproces+=_ahos[_i,9]
				_nlsaldo +=_ahos[_i,10]
				_nlpenden+=_ahos[_i,11]
				_nlquaren+=_ahos[_i,13]
			endif
			_nhentmes+=_ahos[_i,7]
			_nhentdia+=_ahos[_i,8]
			_nhproces+=_ahos[_i,9]
			_nhsaldo +=_ahos[_i,10]
			_nhpenden+=_ahos[_i,11]
			_nhquaren+=_ahos[_i,13]
		next
		
	endif
	if mv_par01<>1
		_mgr :=_mgr1
		sbm->(dbseek(_cfilsbm+_mgr))
		_smtp := sbm->bm_tipgru
		if !empty(_nlsaiant)
			@ prow()+1,000 PSAY "TOTAL LINHA "+tabela("V0",_sbmt+"    ")
			@ prow(),035   PSAY _nlsaiant picture "@E 9999,999"
			@ prow(),044   PSAY _nlsaimes picture "@E 9999,999"
			@ prow(),071   PSAY _nlentmes picture "@E 9999,999"
			@ prow(),080   PSAY _nlentdia picture "@E 9999,999"
			@ prow(),089   PSAY _nlproces picture "@E 9999,999"
			@ prow(),098   PSAY _nlsaldo  picture "@E 9999,999"
			@ prow(),108   PSAY _nlpenden picture "@E 9999,999"
			@ prow(),124   PSAY _nlquaren picture "@E 9999,999"
			@ prow()+1,000 PSAY " "
			_nlsaiant:=0
			_nlsaimes:=0
			_nlsaidia:=0
			_nlentmes:=0
			_nlentdia:=0
			_nlproces:=0
			_nlsaldo :=0
			_nlpenden:=0
			_nlquaren:=0
		endif
	endif
	@ prow()+1,000 PSAY "TOTAL HOSPITALAR"
	if mv_par01==1
		@ prow(),035   PSAY _nhsaiant picture "@E 9999,999"
		@ prow(),044   PSAY _nhsaimes picture "@E 9999,999"
		@ prow(),053   PSAY _nhsaidia picture "@E 9999,999"
	else
		@ prow(),035   PSAY _nhsaiant picture "@E 9999,999"
		@ prow(),044   PSAY _nhsaimes picture "@E 9999,999"
	endif
	@ prow(),071   PSAY _nhentmes picture "@E 9999,999"
	@ prow(),080   PSAY _nhentdia picture "@E 9999,999"
	@ prow(),089   PSAY _nhproces picture "@E 9999,999"
	@ prow(),098   PSAY _nhsaldo  picture "@E 9999,999"
	@ prow(),108   PSAY _nhpenden picture "@E 9999,999"
	@ prow(),124   PSAY _nhquaren picture "@E 9999,999"
	@ prow()+1,000 PSAY " "
	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "TOTAL GERAL"
	if mv_par01==1
		@ prow(),035   PSAY _ntsaiant picture "@E 9999,999"
		@ prow(),044   PSAY _ntsaimes picture "@E 9999,999"
		@ prow(),053   PSAY _ntsaidia picture "@E 9999,999"
	else
		@ prow(),035   PSAY _ntsaiant picture "@E 9999,999"
		@ prow(),044   PSAY _ntsaimes picture "@E 9999,999"
	endif
	@ prow(),071   PSAY _ntentmes picture "@E 9999,999"
	@ prow(),080   PSAY _ntentdia picture "@E 9999,999"
	@ prow(),089   PSAY _ntproces picture "@E 9999,999"
	@ prow(),098   PSAY _ntsaldo  picture "@E 9999,999"
	@ prow(),108   PSAY _ntpenden picture "@E 9999,999"
	@ prow(),124   PSAY _ntquaren picture "@E 9999,999"
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

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Considera sistema  ?","mv_ch1","N",01,0,0,"C",space(60),"mv_par01"       ,"1-Comercial"    ,space(30),space(15),"2-Estoque"      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Do Tipo do grupo   ?","mv_ch2","C",01,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Ate o tipo do grupo?","mv_ch3","C",01,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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


static function _geratmp()
procregua(1)
incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_COD PRODUTO"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SBM")+" SBM"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SBM.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND BM_FILIAL='"+_cfilsbm+"'"
_cquery+=" AND B1_GRUPO=BM_GRUPO"
_cquery+=" AND B1_TIPO='PA'"
_cquery+=" AND BM_TIPGRU BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
_cquery+=" GROUP BY"
_cquery+=" BM_TIPGRU,B1_DESC,B1_COD"
_cquery+=" ORDER BY"
_cquery+=" B1_DESC,B1_COD"
_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
return

static function _geratmp2()
procregua(1)
incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_COD PRODUTO"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SBM")+" SBM"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SBM.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND BM_FILIAL='"+_cfilsbm+"'"
_cquery+=" AND B1_GRUPO=BM_GRUPO"
_cquery+=" AND B1_TIPO='PA'"
_cquery+=" AND BM_TIPGRU BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
_cquery+=" ORDER BY"
_cquery+=" BM_TIPGRU,B1_DESC,B1_COD"
_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
return

static function _totsbm()
if !empty(_nlsaiant)
	@ prow()+1,000 PSAY "TOTAL LINHA "+tabela("V0",_sbmt+"    ")
	@ prow(),035   PSAY _nlsaiant picture "@E 9999,999"
	@ prow(),044   PSAY _nlsaimes picture "@E 9999,999"
	@ prow(),071   PSAY _nlentmes picture "@E 9999,999"
	@ prow(),080   PSAY _nlentdia picture "@E 9999,999"
	@ prow(),089   PSAY _nlproces picture "@E 9999,999"
	@ prow(),098   PSAY _nlsaldo  picture "@E 9999,999"
	@ prow(),108   PSAY _nlpenden picture "@E 9999,999"
	@ prow(),124   PSAY _nlquaren picture "@E 9999,999"
	@ prow()+1,000 PSAY " "
	_nlsaiant:=0
	_nlsaimes:=0
	_nlsaidia:=0
	_nlentmes:=0
	_nlentdia:=0
	_nlproces:=0
	_nlsaldo :=0
	_nlpenden:=0
	_nlquaren:=0
endif
return


/*
S A I D A S                        E S T O Q U E
Codigo Descricao                   Mes Ant.   No Mes   No Dia    Media  Ent.Mes  Ent.Dia Processo    Saldo Pendencia Dias Quarentena
XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXX 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999  9999.999 9999   9999.999
Codigo Descricao                   No Mes   No Dia    Media   Lote Pad  Ent.Mes  Ent.Dia Processo    Saldo Pendencia Dias Quarentena
XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXX 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999  9999.999 9999   9999.999
*/

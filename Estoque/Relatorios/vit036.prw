/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT036   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 28/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo da Movimentacao do Estoque de PA (Gerencial)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit036()
_Test    :=""
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="RESUMO DA MOVIMENTACAO DO ESTOQUE DE PA (GERENCIAL)"
cdesc1   :="Este programa ira emitir o resumo da movimentacao do estoque de PA (Gerencial)"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT036"
wnrel    :="VIT036"+Alltrim(cusername)
aordem  :={"Descricao","Dias Estoque","Vl.Pendencia","Qtde.Pendente"}
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT036"
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
elseif nordem==3
	_mtipo:="Vl.Pendencia"
else
	_mtipo:="Qtde.Pendente"
endif
titulo:="RESUMO DA MOVIMENTACAO DO ESTOQUE (GERENCIAL) EM "+dtoc(ddatabase) + " - "+_mtipo

cabec1:="                                                        S A I D A S                        E S T O Q U E"
cabec2:="Codigo Descricao                                Mes Ant.   No Mes   No Dia    Media  Ent.Mes  Ent.Dia Processo  Empenho    Saldo Pendencia Dias Quarentena     Valor Est. Valor Pend."

//_cfilda0:=xfilial("DA0")
//_cfilda1:=xfilial("DA1")
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsc2:=xfilial("SC2")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsc9:=xfilial("SC9")
_cfilsd5:=xfilial("SD5")
_cfilsd2:=xfilial("SD2")
_cfilsd7:=xfilial("SD7")
_cfilsf4:=xfilial("SF4")
//da0->(dbsetorder(1))
//da1->(dbsetorder(1))
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sc2->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(1))
sc9->(dbsetorder(1))
sd2->(dbsetorder(1))
sd5->(dbsetorder(1))
sd7->(dbsetorder(1))
sf4->(dbsetorder(1))

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
_ntempen :=0
_ntsaldo :=0
_ntpenden:=0
_ntquaren:=0
_ntvalor :=0
_ntvrpen :=0
_nvrpen  :=0
_acom    :={}
_ahos    :={}

processa({|| _geratmp()})

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
//	_cquery+=" AND D5_CLIFOR<>' '"
	_cquery+=" AND D5_SERIE<>'   '"
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
	_cquery+=" AND SD7.D_E_L_E_T_<>'*'"
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
	
	// SALDO ATUAL E EMPENHO
	if sb2->(dbseek(_cfilsb2+sb1->b1_cod+sb1->b1_locpad))
		_nsaldo:=int(sb2->b2_qatu-sb2->b2_reserva-sb2->b2_qemp)
		_nempen:=int(sb2->b2_reserva+sb2->b2_qemp)
	else
		_nsaldo:=0
		_nempen:=0
	endif
	
	// PENDENCIA (PEDIDOS DE VENDA EM ABERTO)
	_cquery:=" SELECT"
	_cquery+=" SUM(C6_QTDVEN-C6_QTDENT) QTDPEN,"
	_cquery+=" SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) VRPEN"
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
	//_cquery+=" AND C5_LIBEROK<>'S'" // TESTE 	RICARDO MOREIRA 05/05/2016 // RETIRADO O TESTE MARCIO DAVID 15/08/2018
	_cquery+=" AND F4_ESTOQUE='S'"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QTDPEN","N",07,0)
	tcsetfield("TMP2","VRPEN","N",12,2)
	
	_npenden:=tmp2->qtdpen
	_nvrpen:=tmp2->vrpen
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
//Alteração Stephen Para buscar o saldo em quarentena 13/06/2018.
/*	if sb2->(dbseek(_cfilsb2+sb1->b1_cod+_ccq))
		_nquaren:=int(sb2->b2_qatu-sb2->b2_reserva-sb2->b2_qemp)
	else
		_nquaren:=0
	endif
	
*/
_cquery:=" SELECT " 
_cquery+=" SUM(B8_SALDO) SLDQRT " 
_cquery+=" FROM SB8010 SB8 "
_cquery+=" WHERE SB8.d_e_l_e_t_ = ' ' "
_cquery+=" AND SB8.B8_LOCAL = '98' "
_cquery+=" AND SB8.B8_PRODUTO = '"+tmp1->produto+"'

_cquery:=changequery(_cquery)	
tcquery _cquery new alias "TMP3"

DbSelectArea("TMP3")
tmp3->(dbGoTop())
_nquaren := tmp3->SLDQRT
tmp3->(DbCloseArea())

//FIM ALTERAÇÃO Stephe Noel de Melo 	
	// VALOR DO SALDO EM ESTOQUE BASEADO NA TABELA DE PRECOS INFORMADA
	
/*	if da0->(dbseek(_cfilda0+mv_par01)) .and.;
		da1->(dbseek(_cfilda1+mv_par01+sb1->b1_cod)) .and.;
		sb1->b1_apreven="1"
		_nvalor:=da1->da1_prcven*(1-(da0->da0_desc1/100))
		_nvalor:=_nvalor*(1-(da0->da0_desc2/100))
		_nvalor:=_nvalor*(1-(da0->da0_desc3/100))
		_nvalor:=_nvalor*(1-(da0->da0_desc4/100))
		_nvalor:=round(_nvalor*0.7,2) // MENOS 30%
		_nvalor:=_nsaldo*_nvalor
	elseif da0->(dbseek(_cfilda0+mv_par02)) .and.;
		da1->(dbseek(_cfilda1+mv_par02+sb1->b1_cod)) .and.;
		sb1->b1_apreven="2"
		_nvalor:=da1->da1_prcven
		_nvalor:=_nsaldo*_nvalor
	else
		_nvalor:=0
	endif
*/

	_datafim:=date() 
	_dataini:=_datafim - mv_par01 
	
	_cquery:=" SELECT"
	_cquery+=" SUM(SD2.D2_TOTAL) TOTAL,"
	_cquery+=" SUM(SD2.D2_QUANT) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SD2")+" SD2,"
	_cquery+=  retsqlname("SF4")+" SF4"
	_cquery+=" WHERE"
	_cquery+="     SD2.D_E_L_E_T_<>'*'"
	_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
	_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
	_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
	_cquery+=" AND D2_COD='"+sb1->b1_cod+"'"
	_cquery+=" AND SF4.F4_DUPLIC = 'S'"
	_cquery+=" AND SF4.F4_ESTOQUE = 'S'"
	_cquery+=" AND SF4.F4_CODIGO = SD2.D2_TES "
	_cquery+=" AND SD2.D2_TIPO IN ('N','C')"

	_cquery+=" AND SD2.D2_EMISSAO BETWEEN '"+dtos(_dataini)+"' AND '"+dtos(_datafim)+"'"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",12,2)
	tcsetfield("TMP2","QUANT","N",12,2)
	
	tmp2->(dbgotop())
	_nvalor:=tmp2->total/tmp2->quant 
	_nvalor:=_nsaldo*_nvalor
	tmp2->(dbclosearea())


	if sb1->b1_apreven=="1"
		aadd(_acom,{sb1->b1_cod,sb1->b1_desc,_nsaiant,_nsaimes,_nsaidia,;
		_nsaimed,_nentmes,_nentdia,_nproces,_nempen,_nsaldo,;
		_npenden,_ndias,_nquaren,_nvalor,_nvrpen})
		
	else
		aadd(_ahos,{sb1->b1_cod,sb1->b1_desc,_nsaiant,_nsaimes,_nsaidia,;
		_nsaimed,_nentmes,_nentdia,_nproces,_nempen,_nsaldo,;
		_npenden,_ndias,_nquaren,_nvalor,_nvrpen})
	endif
	_ntsaiant+=_nsaiant
	_ntsaimes+=_nsaimes
	_ntsaidia+=_nsaidia
	_ntentmes+=_nentmes
	_ntentdia+=_nentdia
	_ntproces+=_nproces
	_ntempen +=_nempen
	_ntsaldo +=_nsaldo
	_ntpenden+=_npenden
	_ntquaren+=_nquaren
	_ntvalor +=_nvalor
	_ntvrpen +=_nvrpen
	
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
	_ncempen :=0
	_ncsaldo :=0
	_ncpenden:=0
	_ncquaren:=0
	_ncvalor :=0
	_ncvrpen :=0
	if nordem<>1
		if nordem==2
			_acoms:= asort(_acom,,,{|x,y| x[13]<y[13]})
		elseif nordem==3
			_acoms:= asort(_acom,,,{|x,y| x[16]<y[16]})
		else
			_acoms:= asort(_acom,,,{|x,y| x[12]<y[12]})
		endif
		for _i:=1 to len(_acoms)
			if prow()>54
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY left(_acoms[_i,1],6)
			@ prow(),007   PSAY left(_acoms[_i,2],40)
			@ prow(),048   PSAY _acoms[_i,3] picture "@E 9999,999"
			@ prow(),057   PSAY _acoms[_i,4] picture "@E 9999,999"
			@ prow(),066   PSAY _acoms[_i,5] picture "@E 9999,999"
			@ prow(),075   PSAY _acoms[_i,6] picture "@E 9999,999"
			@ prow(),084   PSAY _acoms[_i,7] picture "@E 9999,999"
			@ prow(),093   PSAY _acoms[_i,8] picture "@E 9999,999"
			@ prow(),102   PSAY _acoms[_i,9] picture "@E 9999,999"
			@ prow(),111   PSAY _acoms[_i,10] picture "@E 9999,999"
			@ prow(),120   PSAY _acoms[_i,11] picture "@E 9999,999"
			@ prow(),130   PSAY _acoms[_i,12] picture "@E 9999,999"
			@ prow(),139   PSAY _acoms[_i,13] picture "@E 9999"
			@ prow(),146   PSAY _acoms[_i,14] picture "@E 9999,999"
			@ prow(),155   PSAY _acoms[_i,15] picture "@E 999,999,999.99"
			@ prow(),170   PSAY _acoms[_i,16] picture "@E 999,999,999.99"
			_ncsaiant+=_acoms[_i,3]
			_ncsaimes+=_acoms[_i,4]
			_ncsaidia+=_acoms[_i,5]
			_ncentmes+=_acoms[_i,7]
			_ncentdia+=_acoms[_i,8]
			_ncproces+=_acoms[_i,9]
			_ncempen +=_acoms[_i,10]
			_ncsaldo +=_acoms[_i,11]
			_ncpenden+=_acoms[_i,12]
			_ncquaren+=_acoms[_i,14]
			_ncvalor +=_acoms[_i,15]
			_ncvrpen +=_acoms[_i,16]
		next
	else
		for _i:=1 to len(_acom)
			if prow()>54
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY left(_acom[_i,1],6)
			@ prow(),007   PSAY left(_acom[_i,2],40)
			@ prow(),048   PSAY _acom[_i,3] picture "@E 9999,999"
			@ prow(),057   PSAY _acom[_i,4] picture "@E 9999,999"
			@ prow(),066   PSAY _acom[_i,5] picture "@E 9999,999"
			@ prow(),075   PSAY _acom[_i,6] picture "@E 9999,999"
			@ prow(),084   PSAY _acom[_i,7] picture "@E 9999,999"
			@ prow(),093   PSAY _acom[_i,8] picture "@E 9999,999"
			@ prow(),102   PSAY _acom[_i,9] picture "@E 9999,999"
			@ prow(),111   PSAY _acom[_i,10] picture "@E 9999,999"
			@ prow(),120   PSAY _acom[_i,11] picture "@E 9999,999"
			@ prow(),130   PSAY _acom[_i,12] picture "@E 9999,999"
			@ prow(),139   PSAY _acom[_i,13] picture "@E 9999"
			@ prow(),146   PSAY _acom[_i,14] picture "@E 9999,999"
			@ prow(),155   PSAY _acom[_i,15] picture "@E 999,999,999.99"
			@ prow(),170   PSAY _acom[_i,16] picture "@E 999,999,999.99"
			_ncsaiant+=_acom[_i,3]
			_ncsaimes+=_acom[_i,4]
			_ncsaidia+=_acom[_i,5]
			_ncentmes+=_acom[_i,7]
			_ncentdia+=_acom[_i,8]
			_ncproces+=_acom[_i,9]
			_ncempen +=_acom[_i,10]
			_ncsaldo +=_acom[_i,11]
			_ncpenden+=_acom[_i,12]
			_ncquaren+=_acom[_i,14]
			_ncvalor +=_acom[_i,15]
			_ncvrpen +=_acom[_i,16]
		next
	endif
	@ prow()+1,000 PSAY "TOTAL LINHA COMERCIAL"
	@ prow(),048   PSAY _ncsaiant picture "@E 9999,999"
	@ prow(),057   PSAY _ncsaimes picture "@E 9999,999"
	@ prow(),066   PSAY _ncsaidia picture "@E 9999,999"
	@ prow(),084   PSAY _ncentmes picture "@E 9999,999"
	@ prow(),093   PSAY _ncentdia picture "@E 9999,999"
	@ prow(),102   PSAY _ncproces picture "@E 9999,999"
	@ prow(),111   PSAY _ncempen  picture "@E 9999,999"
	@ prow(),120   PSAY _ncsaldo  picture "@E 9999,999"
	@ prow(),130   PSAY _ncpenden picture "@E 9999,999"
	@ prow(),146   PSAY _ncquaren picture "@E 9999,999"
	@ prow(),155   PSAY _ncvalor  picture "@E 999,999,999.99"
	@ prow(),170   PSAY _ncvrpen  picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY " "
	
	_nhsaiant:=0
	_nhsaimes:=0
	_nhsaidia:=0
	_nhentmes:=0
	_nhentdia:=0
	_nhproces:=0
	_nhempen :=0
	_nhsaldo :=0
	_nhpenden:=0
	_nhquaren:=0
	_nhvalor :=0
	_nhvrpen :=0
	if nordem<>1
		if nordem==2
			_ahoss:= asort(_ahos,,,{|x,y| x[13]<y[13]})
		elseif nordem==3
			_ahoss:= asort(_ahos,,,{|x,y| x[16]>y[16]})
		else
			_ahoss:= asort(_ahos,,,{|x,y| x[12]>y[12]})
		endif
		for _i:=1 to len(_ahoss)
			if prow()>54
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY left(_ahoss[_i,1],6)
			@ prow(),007   PSAY left(_ahoss[_i,2],40)
			@ prow(),048   PSAY _ahoss[_i,3] picture "@E 9999,999"
			@ prow(),057   PSAY _ahoss[_i,4] picture "@E 9999,999"
			@ prow(),066   PSAY _ahoss[_i,5] picture "@E 9999,999"
			@ prow(),075   PSAY _ahoss[_i,6] picture "@E 9999,999"
			@ prow(),084   PSAY _ahoss[_i,7] picture "@E 9999,999"
			@ prow(),093   PSAY _ahoss[_i,8] picture "@E 9999,999"
			@ prow(),102   PSAY _ahoss[_i,9] picture "@E 9999,999"
			@ prow(),111   PSAY _ahoss[_i,10] picture "@E 9999,999"
			@ prow(),120   PSAY _ahoss[_i,11] picture "@E 9999,999"
			@ prow(),130   PSAY _ahoss[_i,12] picture "@E 9999,999"
			@ prow(),139   PSAY _ahoss[_i,13] picture "@E 9999"
			@ prow(),146   PSAY _ahoss[_i,14] picture "@E 9999,999"
			@ prow(),155   PSAY _ahoss[_i,15] picture "@E 999,999,999.99"
			@ prow(),170   PSAY _ahoss[_i,16] picture "@E 999,999,999.99"
			_nhsaiant+=_ahoss[_i,3]
			_nhsaimes+=_ahoss[_i,4]
			_nhsaidia+=_ahoss[_i,5]
			_nhentmes+=_ahoss[_i,7]
			_nhentdia+=_ahoss[_i,8]
			_nhproces+=_ahoss[_i,9]
			_nhempen +=_ahoss[_i,10]
			_nhsaldo +=_ahoss[_i,11]
			_nhpenden+=_ahoss[_i,12]
			_nhquaren+=_ahoss[_i,14]
			_nhvalor +=_ahoss[_i,15]
			_nhvrpen +=_ahoss[_i,16]
		next
	else
		for _i:=1 to len(_ahos)
			if prow()>54
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY left(_ahos[_i,1],6)
			@ prow(),007   PSAY left(_ahos[_i,2],40)
			@ prow(),048   PSAY _ahos[_i,3] picture "@E 9999,999"
			@ prow(),057   PSAY _ahos[_i,4] picture "@E 9999,999"
			@ prow(),066   PSAY _ahos[_i,5] picture "@E 9999,999"
			@ prow(),075   PSAY _ahos[_i,6] picture "@E 9999,999"
			@ prow(),084   PSAY _ahos[_i,7] picture "@E 9999,999"
			@ prow(),093   PSAY _ahos[_i,8] picture "@E 9999,999"
			@ prow(),102   PSAY _ahos[_i,9] picture "@E 9999,999"
			@ prow(),111   PSAY _ahos[_i,10] picture "@E 9999,999"
			@ prow(),120   PSAY _ahos[_i,11] picture "@E 9999,999"
			@ prow(),130   PSAY _ahos[_i,12] picture "@E 9999,999"
			@ prow(),139   PSAY _ahos[_i,13] picture "@E 9999"
			@ prow(),146   PSAY _ahos[_i,14] picture "@E 9999,999"
			@ prow(),155   PSAY _ahos[_i,15] picture "@E 999,999,999.99"
			@ prow(),170   PSAY _ahos[_i,16] picture "@E 999,999,999.99"
			_nhsaiant+=_ahos[_i,3]
			_nhsaimes+=_ahos[_i,4]
			_nhsaidia+=_ahos[_i,5]
			_nhentmes+=_ahos[_i,7]
			_nhentdia+=_ahos[_i,8]
			_nhproces+=_ahos[_i,9]
			_nhempen +=_ahos[_i,10]
			_nhsaldo +=_ahos[_i,11]
			_nhpenden+=_ahos[_i,12]
			_nhquaren+=_ahos[_i,14]
			_nhvalor +=_ahos[_i,15]
			_nhvrpen +=_ahos[_i,16]
		next
	endif
	@ prow()+1,000 PSAY "TOTAL LINHA HOSPITALAR"
	@ prow(),048   PSAY _nhsaiant picture "@E 9999,999"
	@ prow(),057   PSAY _nhsaimes picture "@E 9999,999"
	@ prow(),066   PSAY _nhsaidia picture "@E 9999,999"
	@ prow(),084   PSAY _nhentmes picture "@E 9999,999"
	@ prow(),093   PSAY _nhentdia picture "@E 9999,999"
	@ prow(),102   PSAY _nhproces picture "@E 9999,999"
	@ prow(),111   PSAY _nhempen  picture "@E 9999,999"
	@ prow(),120   PSAY _nhsaldo  picture "@E 9999,999"
	@ prow(),130   PSAY _nhpenden picture "@E 9999,999"
	@ prow(),146   PSAY _nhquaren picture "@E 9999,999"
	@ prow(),155   PSAY _nhvalor  picture "@E 999,999,999.99"
	@ prow(),170   PSAY _nhvrpen  picture "@E 999,999,999.99"
	
	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "TOTAL"
	@ prow(),048   PSAY _ntsaiant picture "@E 9999,999"
	@ prow(),057   PSAY _ntsaimes picture "@E 9999,999"
	@ prow(),066   PSAY _ntsaidia picture "@E 9999,999"
	@ prow(),084   PSAY _ntentmes picture "@E 9999,999"
	@ prow(),093   PSAY _ntentdia picture "@E 9999,999"
	@ prow(),102   PSAY _ntproces picture "@E 9999,999"
	@ prow(),111   PSAY _ntempen  picture "@E 9999,999"
	@ prow(),120   PSAY _ntsaldo  picture "@E 9999,999"
	@ prow(),130   PSAY _ntpenden picture "@E 9999,999"
	@ prow(),146   PSAY _ntquaren picture "@E 9999,999"
	@ prow(),155   PSAY _ntvalor  picture "@E 999,999,999.99"
	@ prow(),170   PSAY _ntvrpen  picture "@E 999,999,999.99"
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

static function _geratmp()

//Tira os Tipos de Produtos
                 
aProdT:={}
aProdTp:=Alltrim(MV_PAR02) 
While At(";",aProdTp) > 0
	_nFim    := At(";",aProdTp) - 1
	aAdd(aProdT,SubStr(aProdTp,1,_nFim))
	aProdTp := SubStr(aProdTp,_nFim + 2,Len(aProdTp) - (_nFim + 1))
End                 

procregua(1)

incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_COD PRODUTO"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"  

//Tipo de Produto    


If len(aProdT)>0
	_Test := "('"
	for x:=1 to len(aProdT) 
	_Test += aProdT[X]+"','"
	Next x
Endif  
    
 _CONT := LEN(_Test)-2
 _Test := SUBSTR(_Test,1,_CONT)
 
_cquery+=" AND B1_TIPO IN "+_Test+") "
_cquery+=" ORDER BY"
_cquery+=" B1_DESC"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Dias para Prc.Medio?","mv_ch1","N",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Tipo Produto       ?","mv_ch2","C",25,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
S A I D A S                        E S T O Q U E
Codigo Descricao                                Mes Ant.   No Mes   No Dia    Media  Ent.Mes  Ent.Dia Processo  Empenho    Saldo Pendencia Dias Quarentena          Valor
XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999  9999.999 9999   9999.999 999.999.999,99
*/

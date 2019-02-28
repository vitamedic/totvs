/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT292   ³ Autor ³ Aline B. Pereira      ³ Data ³ 30/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Estoque / Media Venda PA                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit292()
nordem   :=""
tamanho  :="M"
limite   :=120
titulo   :="RELATORIO DE ESTOQUE / MEDIA VENDA (SEMESTRAL) DE PA"
cdesc1   :="Este programa ira emitir o relatorio de estoque/ media venda semestral de PA"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT292"
wnrel    :="VIT292"+Alltrim(cusername)
//aordem  :={"Descricao","Dias Estoque","Qtde.Pendente"}//
aordem   :={}
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT292"
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
titulo:="RELATORIO ESTOQUE/MEDIA VENDA "


cabec1:="MEDIA VENDA ENTRE :"+dtoc(mv_par01)+" e "+dtoc(mv_par02) +space(20)+" *Estoque = estoque+quarentena-pendencia"
cabec2:="Codigo Descricao                     Lt.Padrao  Med.Venda  Meta Mes  *Estoque     Em Prod.   Necessidade"

_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsc2:=xfilial("SC2")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsc9:=xfilial("SC9")
_cfilsd5:=xfilial("SD5")
_cfilsd3:=xfilial("SD3")
_cfilsf4:=xfilial("SF4")
_cfilsbm:=xfilial("SBM")
_cfilsct:=xfilial("SCT")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sc2->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(1))
sc9->(dbsetorder(1))
sd5->(dbsetorder(1))
sd3->(dbsetorder(1))
sf4->(dbsetorder(1))
sbm->(dbsetorder(1))
sct->(dbsetorder(1))

/*
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
_cmesmed:=strzero(month(ddatabase)-6)
endif

if month(ddatabase)<=06
_canomed:=strzero(year(ddatabase)-1,4)
else
_canomed:=strzero(year(ddatabase),4)
endif
_dinimed :=ctod("01/"+_cmesmed+"/"+_canomed)
_dfimmed :=_dfimant*/



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
_nqtven :=0

_acom    :={}
_aHom    :={}


_nlotpad:=0
_nmedven:=0
_nsaldo:=0
_nprocs:=0
_nmeta:=0

_ntlot:=0
_ntmed:=0
_ntsaldo:=0
_ntprocs :=0
_ntmeta:=0
_smtp:=""
processa({|| _geratmp2()})

setprc(0,0)
setregua(sb1->(lastrec()))
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	sb1->(dbseek(_cfilsb1+tmp1->produto))
	
	// SALDO EM PROCESSO (ORDENS DE PRODUCAO EM ABERTO)
	incproc("Calculando produção...")
	_cquery:=" SELECT"
	_cquery+=" SUM(C2_QUANT-C2_QUJE) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC2")+" SC2"
	_cquery+=" WHERE"
	_cquery+="     SC2.D_E_L_E_T_<>'*'"
	_cquery+=" AND C2_FILIAL='"+_cfilsc2+"'"
	_cquery+=" AND C2_PRODUTO='"+sb1->b1_cod+"'"
	_cquery+=" AND C2_DATRF='        '"
	
	//	_cquery+=" AND C2_LOCAL='"+sb1->b1_locpad+"'"
	
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

/// META MES ATUAL

	_ddataini:=ddatabase
	_ddatafim:=lastday(_ddataini)
	
	incproc("Calculando metas...")
	_cquery:=" SELECT"
	_cquery+=" SUM(CT_QUANT) META"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SCT")+" SCT"
	_cquery+=" WHERE"
	_cquery+="     SCT.D_E_L_E_T_<>'*'"
	_cquery+=" AND CT_FILIAL='"+_cfilsct+"'"  
	_cquery+=" AND CT_PRODUTO='"+sb1->b1_cod+"'"  	
	_cquery+=" AND CT_TIPO='PA'"	
	_cquery+=" AND CT_VEND='002000'"	
	_cquery+=" AND CT_DATA BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(_ddatafim)+"'"

	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","META","N",07,0)
	
	tmp2->(dbgotop())
	_nmeta:=tmp2->meta
	tmp2->(dbclosearea())
	

	
		// (PEDIDOS DE VENDA SEMESTRAL)
	incproc("Calculando pedidos de vendas...")	
	_cquery:=" SELECT"
	_cquery+=" SUM(C6_QTDVEN) QTDVEN"
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
	_cquery+=" AND C5_TIPO='N'"
	_cquery+=" AND F4_ESTOQUE='S'"
	_cquery+=" AND C5_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QTDVEN","N",07,0)
	
	_nqtven:=tmp2->qtdven
	tmp2->(dbclosearea())
	
	
	// PENDENCIA (PEDIDOS DE VENDA EM ABERTO)
	incproc("Calculando pendencias...")	
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
	

	
	// SALDO EM QUARENTENA
	if sb2->(dbseek(_cfilsb2+sb1->b1_cod+_ccq))
		_nquaren:=int(sb2->b2_qatu-sb2->b2_reserva-sb2->b2_qemp)
	else
		_nquaren:=0
	endif                                                      
	

	if sb1->b1_apreven=="1"	
		aadd(_acom,{sb1->b1_cod,sb1->b1_desc,sb1->b1_le,;	
		_nqtven/6,(_nsaldo+_nquaren)-_npenden,_nproces,sb1->b1_grupo,_nmeta,sb1->b1_apreven,tmp1->tipo})
	else
		aadd(_ahom,{sb1->b1_cod,sb1->b1_desc,sb1->b1_le,;	
		_nqtven/6,(_nsaldo+_nquaren)-_npenden,_nproces,sb1->b1_grupo,_nmeta,sb1->b1_apreven,tmp1->tipo})
	endif	
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if lcontinua
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	_acoms := asort(_acom,,,{|x,y|x[10]+x[2]<y[10]+y[2]})
	for _i:=1 to len(_acoms)
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		sbm->(dbseek(_cfilsbm+_acoms[_i,7]))
		if _smtp <> sbm->bm_tipgru  // linha for diferente
			_smtp := sbm->bm_tipgru
			_tsbm()
		endif
		@ prow()+1,000 PSAY left(_acom[_i,1],6)
		@ prow(),007   PSAY left(_acom[_i,2],25)
		@ prow(),034   PSAY _acom[_i,3] picture "@E 999,999,999"
		@ prow(),046   PSAY _acom[_i,4] picture "@E 999,999,999"
		@ prow(),057   PSAY _acom[_i,8] picture "@E 999,999,999"
		@ prow(),069   PSAY _acom[_i,5] picture "@E 999,999,999"
		@ prow(),080   PSAY _acom[_i,6] picture "@E 999,999,999"
		@ prow(),092   PSAY _acom[_i,6]-(_acom[_i,5]*(-1))picture "@E 999,999,999"
		_sbmt := sbm->bm_tipgru+"    "
		_nlotpad+=_acom[_i,3]
		_nmedven+=_acom[_i,4]
		_nsaldo+=_acom[_i,5]
		_nprocs+=_acom[_i,6]
		_nmeta+= _acom[_i,8]
		
		_ntlot+=_acom[_i,3]
		_ntmed+=_acom[_i,4]
		_ntsaldo+=_acom[_i,5]
		_ntprocs +=_acom[_i,6]
		_ntmeta+=_acom[_i,8]
	next
	if !empty(_nlotpad)
		@ prow()+1,000 PSAY "TOTAL LINHA "+tabela("V0",_sbmt+"    ")
		@ prow(),034   PSAY _nlotpad picture "@E 999,999,999"
		@ prow(),046   PSAY _nmedven picture "@E 999,999,999"
		@ prow(),057   PSAY _nmeta picture "@E 999,999,999"
		@ prow(),069   PSAY _nsaldo picture "@E 999,999,999"
		@ prow(),080   PSAY _nprocs picture "@E 999,999,999"
		@ prow(),092   PSAY _nprocs - (_nsaldo*(-1)) picture "@E 999,999,999"
		@ prow()+1,000 PSAY " "
		_nlotpad:=0
		_nmedven:=0
		_nsaldo:=0
		_nprocs:=0
		_nmeta:=0
		
	endif
	
// economica                                          
	_aHoms := asort(_aHom,,,{|x,y|x[10]+x[2]<y[10]+y[2]})
   _smtp :=""
	@ prow()+1,000 PSAY "Linha Economica"

	for _i:=1 to len(_ahoms)
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		sbm->(dbseek(_cfilsbm+_ahoms[_i,7]))
		if _smtp <> sbm->bm_tipgru  // linha for diferente
			_smtp := sbm->bm_tipgru
			_tsbm()
		endif
		@ prow()+1,000 PSAY left(_ahom[_i,1],6)
		@ prow(),007   PSAY left(_ahom[_i,2],27)
		@ prow(),034   PSAY _ahom[_i,3] picture "@E 999,999,999"
		@ prow(),046   PSAY _ahom[_i,4] picture "@E 999,999,999"
		@ prow(),057   PSAY _ahom[_i,8] picture "@E 999,999,999"
		@ prow(),069   PSAY _ahom[_i,5] picture "@E 999,999,999"
		@ prow(),080   PSAY _ahom[_i,6] picture "@E 999,999,999"
		@ prow(),092   PSAY _ahom[_i,6]-(_ahom[_i,5]*(-1))picture "@E 999,999,999"
		_sbmt := sbm->bm_tipgru+"    "
		_nlotpad+=_ahom[_i,3]
		_nmedven+=_ahom[_i,4]
		_nsaldo+=_ahom[_i,5]
		_nprocs+=_ahom[_i,6]
		_nmeta+= _ahom[_i,8]
		
		_ntlot+=_ahom[_i,3]
		_ntmed+=_ahom[_i,4]
		_ntsaldo+=_ahom[_i,5]
		_ntprocs +=_ahom[_i,6]
		_ntmeta+=_ahom[_i,8]
	next
	if !empty(_nlotpad)
		@ prow()+1,000 PSAY "TOTAL LINHA "+tabela("V0",_sbmt+"    ")
		@ prow(),034   PSAY _nlotpad picture "@E 999,999,999"
		@ prow(),046   PSAY _nmedven picture "@E 999,999,999"
		@ prow(),057   PSAY _nmeta picture "@E 999,999,999"
		@ prow(),069   PSAY _nsaldo picture "@E 999,999,999"
		@ prow(),080   PSAY _nprocs picture "@E 999,999,999"
		@ prow(),092   PSAY _nprocs - (_nsaldo*(-1)) picture "@E 999,999,999"
		@ prow()+1,000 PSAY " "
		_nlotpad:=0
		_nmedven:=0
		_nsaldo:=0
		_nprocs:=0
		_nmeta:=0
		
	endif

//	
	
	if !empty(_ntlot)
		@ prow()+1,000 PSAY "TOTAL GERAL "
		@ prow(),034   PSAY _ntlot picture "@E 999,999,999"
		@ prow(),046   PSAY _ntmed picture "@E 999,999,999"
		@ prow(),057   PSAY _ntmeta picture "@E 999,999,999"
		@ prow(),069   PSAY _ntsaldo picture "@E 999,999,999"
		@ prow(),080   PSAY _ntprocs picture "@E 999,999,999"
		@ prow(),092   PSAY _ntprocs-(_ntsaldo*(-1)) picture "@E 999,999,999"
//@ prow(),092   PSAY _ntmeta picture "@E 999,999,999"
		@ prow()+1,000 PSAY " "		
	endif
	
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

static function _tsbm()
if !empty(_nlotpad)
	@ prow()+1,000 PSAY "TOTAL LINHA "+tabela("V0",_sbmt+"    ")
	@ prow(),034   PSAY _nlotpad picture "@E 999,999,999"
	@ prow(),046   PSAY _nmedven picture "@E 999,999,999"
	@ prow(),057   PSAY _nmeta picture "@E 999,999,999"
	@ prow(),069   PSAY _nsaldo picture "@E 999,999,999"
	@ prow(),080   PSAY _nprocs picture "@E 999,999,999"
	@ prow(),092   PSAY _nprocs-(_nsaldo*(-1)) picture "@E 999,999,999"
// prow(),092   PSAY _nmeta picture "@E 999,999,999"
	@ prow()+1,000 PSAY " "
	_nlotpad:=0
	_nmedven:=0
	_nsaldo:=0
	_nprocs:=0
	_nmeta:=0
endif
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


static function _geratmp()
procregua(1)
incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_COD PRODUTO,BM_TIPGRU TIPO""
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
_cquery+=" GROUP BY"
_cquery+=" B1_DESC,B1_COD"
_cquery+=" ORDER BY"
_cquery+=" B1_DESC,B1_COD"
_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
return

static function _geratmp2()
procregua(1)
incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_COD PRODUTO,BM_TIPGRU TIPO"
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

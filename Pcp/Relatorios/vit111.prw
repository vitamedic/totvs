/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT111   ³Autor ³ Heraildo C. de Freitas  ³Data ³ 21/10/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Simulacao de Producao Baseado nas Metas de Venda           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³10/05/04 - Edson  - Tratamento de Quantidade Basica         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit111()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="SIMULACAO DE PRODUCAO COM NECESSIDADE DE COMPRAS"
cdesc1   :="Este programa ira emitir a simulacao de producao"
cdesc2   :="baseado nas metas de venda"
cdesc3   :=""
cstring  :="SCT"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT111"
wnrel    :="VIT111"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT111"
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
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

                            
_ccq     :=getmv("MV_CQ")
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsc1:=xfilial("SC1")
_cfilsc7:=xfilial("SC7")
_cfilsg1:=xfilial("SG1")
_cfilsct:=xfilial("SCT") 
_cfilsc6:=xfilial("SC6")
_cfilsc5:=xfilial("SC5")
_cfilsc2:=xfilial("SC2")
_cfilsf4:=xfilial("SF4")
_cfilsbm:=xfilial("SBM")

sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sc1->(dbsetorder(1))
sc7->(dbsetorder(1))
sg1->(dbsetorder(1))
sct->(dbsetorder(1))    
sc5->(dbsetorder(1))
sc6->(dbsetorder(1))
sf4->(dbsetorder(1))
sz2->(dbsetorder(1))
sbm->(dbsetorder(1))

_mdesc1:= ""
_mdesc2:= ""                                                   
sct->(dbseek(_cfilsct+mv_par01))
_mdesc1:= sct->ct_descri
if mv_par01<> mv_par02
	sct->(dbseek(_cfilsct+mv_par02))
	_mdesc2:= sct->ct_descri
else
	_mdesc2:= _mdesc1
endif
cabec1:="Produto                                 UM    Lt.Padrao   Previsao     Estoque   Pendencia  Processo  Quarentena Q.Fabricar Q.Lotes"
//        /                                             999,999,999 999,999,999 999,999,99 9999,999,99 999,999,999 999,999,999
cabec2:="Documento de : "+ mv_par01+" - "+_mdesc1+"  a  "+mv_par02+" - "+_mdesc2
//
_aesttmp:={}
aadd(_aesttmp,{"COMP" ,"C",15,0})
aadd(_aesttmp,{"QUANT","N",12,2})

_carqtmp1:=criatrab(_aesttmp,.t.)

dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)
_cindtmp1:=criatrab(,.f.)
_cchave  :="COMP"
tmp1->(indregua("TMP1",_cindtmp1,_cchave,,,"Selecionando registros..."))
//
_aesttma:={}
aadd(_aesttma,{"PRODUTO" ,"C",15,0})
aadd(_aesttma,{"DESCRICAO" ,"C",40,0})
aadd(_aesttma,{"QUANT","N",12,2})

_carqtmpa:=criatrab(_aesttmA,.t.)

dbusearea(.t.,,_carqtmpa,"TMPA",.f.,.f.)

_cindtmpa:=criatrab(,.f.)
_cchave  :="PRODUTO"
tmpA->(indregua("TMPA",_cindtmpA,_cchave))

_cindtmpa2:=criatrab(,.f.)
_cchave  :="DESCRICAO+PRODUTO"
tmpA->(indregua("TMPA",_cindtmpa2,_cchave))

tmpA->(dbclearind())
tmpA->(dbsetindex(_cindtmpA))
tmpA->(dbsetindex(_cindtmpA2))

//           

setprc(0,0)  
processa({|| _geratmpA()})

setregua(tmpa->(lastrec()))

tmpa->(dbsetorder(2))
tmpa->(dbgotop())
while ! tmpa->(eof()) .and.;
  	   lcontinua
	incregua()
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
//		@ prow()+1,000 PSAY "Codigo Descricao                                UM Lote padrao Qtde. a fab. Documento"
//		@ prow()+1,000 PSAY replicate("-",limite)
	endif
	sb1->(dbseek(_cfilsb1+tmpa->produto))
		// SALDO EM QUARENTENA
	if sb2->(dbseek(_cfilsb2+sb1->b1_cod+_ccq))
		_nquaren:=int(sb2->b2_qatu-sb2->b2_reserva-sb2->b2_qemp)
	else
		_nquaren:=0
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
      
// 
	_nqtprod := 0
	_npend := 0              
	_npend := int(_nsaldo-_npenden)                         
	if mv_par03 ==1
		_nqtprod := (tmpa->quant-(_nsaldo+_nproces+_nquaren))+_npenden
	else
		_nqtprod := (tmpa->quant-(_nsaldo+_nproces+_nquaren))
	endif
	@ prow()+1,000 PSAY left(tmpa->produto,6)+" - "+left(sb1->b1_desc,30)
	@ prow(),040   PSAY sb1->b1_um
	@ prow(),044   PSAY transform(sb1->b1_qb,"@E 999,999,999")
	@ prow(),055   PSAY transform(tmpa->quant,"@E 999,999,999")
	@ prow(),067   PSAY transform(_nsaldo,"@E 999,999,999")	
	@ prow(),079   PSAY transform(_npenden,"@E 999,999,999")	
	@ prow(),091   PSAY transform(_nproces,"@E 999,999,999")	
	@ prow(),104   PSAY transform(_nquaren,"@E 9999,999") 
	if _nqtprod/sb1->b1_qb > round( _nqtprod/sb1->b1_qb,0)
  	    _nqtprodt := ROUND(( _nqtprod/sb1->b1_qb),0)+1
	 else
	    _nqtprodt :=  round(_nqtprod/sb1->b1_qb,0)
	endif
	if _nqtprod >0
		@ prow(),112   PSAY transform(_nqtprod,"@E 999,999,999")
		@ prow(),124   PSAY transform(round(_nqtprodt,0),"@E 999,999")
	else
		@ prow(),112   PSAY transform(0,"@E 999,999,999")
 		@ prow(),124   PSAY transform(0,"@E 999,999")
   endif                               
  	_geratmp(tmpa->produto,sb1->b1_qb,_nqtprodt*sb1->b1_qb) // solicitado pela Sra.Andrea que a qtde a produzir
                                            // seja a maior alterado de _nqtprod para _nqtprodt
	tmpa->(dbskip())
   if labortprint
      @ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
      lcontinua:=.f.
   endif
end
_aee      :={}
_aen      :={}
_amp      :={}
_ccq      :=getmv("MV_CQ")
tmp1->(dbgotop())
while ! tmp1->(eof())
	sb1->(dbseek(_cfilsb1+tmp1->comp))
	if sb2->(dbseek(_cfilsb2+tmp1->comp+sb1->b1_locpad))
		_nqatu   :=sb2->b2_qatu
		_nqemp   :=sb2->b2_qemp
		_nqtddisp:=_nqatu-_nqemp
	else
		_nqatu   :=0
		_nqemp   :=0
		_nqtddisp:=0
	endif
	if sb2->(dbseek(_cfilsb2+tmp1->comp+_ccq))
		_nquarent:=sb2->b2_qatu-sb2->b2_qemp
	else
		_nquarent:=0
	endif
	_nqtdnec:=((_nqtddisp+_nquarent)-tmp1->quant)*(-1)
	if _nqtdnec<0
		_nqtdnec:=0
	endif
	_cquery:=" SELECT"
	_cquery+=" SUM(C1_QUANT-C1_QUJE) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC1")+" SC1"
	_cquery+=" WHERE"
	_cquery+="     SC1.D_E_L_E_T_<>'*'"
	_cquery+=" AND C1_FILIAL='"+_cfilsc1+"'"
	_cquery+=" AND C1_QUANT-C1_QUJE>0"
	_cquery+=" AND C1_PRODUTO='"+tmp1->comp+"'"
	
	_cquery:=changequery(_cquery)

	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",12,2)
	
	tmp2->(dbgotop())
	_nsolic:=tmp2->quant
	tmp2->(dbclosearea())
  
	_cquery:=" SELECT"
	_cquery+=" SUM(C7_QUANT-C7_QUJE) QUANT"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC7")+" SC7"
	_cquery+=" WHERE"
	_cquery+="     SC7.D_E_L_E_T_<>'*'"
	_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
	_cquery+=" AND C7_QUANT-C7_QUJE>0"
	_cquery+=" AND C7_RESIDUO=' '"
	_cquery+=" AND C7_PRODUTO='"+tmp1->comp+"'"
	
	_cquery:=changequery(_cquery)

	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",12,2)
	
	tmp2->(dbgotop())
	_npedido:=tmp2->quant
	tmp2->(dbclosearea())  
	if sb1->b1_tipo=="EE"
		aadd(_aee,{left(tmp1->comp,6),left(sb1->b1_desc,30),sb1->b1_um,tmp1->quant,_nqatu,_nquarent,_nqemp,;
					  _nqtdnec,_nsolic,_npedido})
	elseif sb1->b1_tipo=="EN"
		aadd(_aen,{left(tmp1->comp,6),left(sb1->b1_desc,30),sb1->b1_um,tmp1->quant,_nqatu,_nquarent,_nqemp,;
					  _nqtdnec,_nsolic,_npedido})
	elseif sb1->b1_tipo<>"MO" 
		aadd(_amp,{left(tmp1->comp,6),left(sb1->b1_desc,30),sb1->b1_um,tmp1->quant,_nqatu,_nquarent,_nqemp,;
					  _nqtdnec,_nsolic,_npedido})
	endif
	tmp1->(dbskip())
   if labortprint
      @ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
      lcontinua:=.f.
   endif
end

@ prow()+1,000 PSAY replicate("-",limite)
@ prow()+1,000 PSAY "Codigo Descricao                      UM   Quantidade      Estoque  Quarentena      Empenho  Necessidade  Solicitacao       Pedido"
@ prow()+1,000 PSAY replicate("-",limite)
cabec1:="Codigo Descricao                      UM   Quantidade      Estoque  Quarentena      Empenho  Necessidade  Solicitacao       Pedido"

_aees:=asort(_aee,,,{|x,y| x[2]<y[2]})
_aens:=asort(_aen,,,{|x,y| x[2]<y[2]})
_amps:=asort(_amp,,,{|x,y| x[2]<y[2]})

/*@ prow()+1,000 PSAY replicate("-",limite)
@ prow()+1,000 PSAY "Materiais sem (solicitacao e/ou pedido) e com a quantidade necessaria maior que 0" 
@ prow()+1,000 PSAY replicate("-",limite)*/

if mv_par05==2
@ prow()+2,000 PSAY "MAT. EMBALAGEM ESSENCIAL1"
@ prow()+1,000 PSAY " "
for _i:=1 to len(_aees)
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
// 	if _aees[_i,8]>0 .and. (_aees[_i,9]=0 .OR. _aees[_i,10]=0)
		@ prow()+1,000 PSAY _aees[_i,1]
		@ prow(),007   PSAY _aees[_i,2]
		@ prow(),038   PSAY _aees[_i,3]
		@ prow(),041   PSAY _aees[_i,4] picture "@E 99999,999.99"
		@ prow(),054   PSAY _aees[_i,5] picture "@E 99999,999.99"
		@ prow(),067   PSAY _aees[_i,6] picture "@E 9999,999.99"
		@ prow(),079   PSAY _aees[_i,7] picture "@E 99999,999.99"
		@ prow(),092   PSAY _aees[_i,8] picture "@E 99999,999.99"
		@ prow(),105   PSAY _aees[_i,9] picture "@E 99999,999.99"
		@ prow(),118   PSAY _aees[_i,10] picture "@E 999,999,999.99"
//  endif		
next
@ prow()+2,000 PSAY "MAT. EMBALAGEM NAO ESSENCIAL"
@ prow()+1,000 PSAY " "
for _i:=1 to len(_aens)
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif 
//	if _aens[_i,8]>0 .and. (_aens[_i,9]=0 .OR. _aens[_i,10]=0)	
		@ prow()+1,000 PSAY _aens[_i,1]
		@ prow(),007   PSAY _aens[_i,2]
		@ prow(),038   PSAY _aens[_i,3]
		@ prow(),041   PSAY _aens[_i,4] picture "@E 99999,999.99"
		@ prow(),054   PSAY _aens[_i,5] picture "@E 99999,999.99"
		@ prow(),067   PSAY _aens[_i,6] picture "@E 9999,999.99"
		@ prow(),079   PSAY _aens[_i,7] picture "@E 99999,999.99"
		@ prow(),092   PSAY _aens[_i,8] picture "@E 99999,999.99"
		@ prow(),105   PSAY _aens[_i,9] picture "@E 99999,999.99"
		@ prow(),118   PSAY _aens[_i,10] picture "@E 999,999,999.99"
//	endif	
next
@ prow()+2,000 PSAY "MATERIA PRIMA"
@ prow()+1,000 PSAY " "
for _i:=1 to len(_amps)
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
//	if _amps[_i,8]>0 .and. (_amps[_i,9]=0 .OR. _amps[_i,10]=0)
		@ prow()+1,000 PSAY _amps[_i,1]
		@ prow(),007   PSAY _amps[_i,2]
		@ prow(),038   PSAY _amps[_i,3]
		@ prow(),041   PSAY _amps[_i,4] picture "@E 99999,999.99"
		@ prow(),054   PSAY _amps[_i,5] picture "@E 99999,999.99"
		@ prow(),067   PSAY _amps[_i,6] picture "@E 9999,999.99"
		@ prow(),079   PSAY _amps[_i,7] picture "@E 99999,999.99"
		@ prow(),092   PSAY _amps[_i,8] picture "@E 99999,999.99"
		@ prow(),105   PSAY _amps[_i,9] picture "@E 99999,999.99"
		@ prow(),118   PSAY _amps[_i,10] picture "@E 999,999,999.99"
//   endif
next
endif
if mv_par04==1
@ prow()+1,000 PSAY replicate("-",limite)
@ prow()+1,000 PSAY "Materiais com diferenca na quantidade solicitada e/ou pedida com a quantidade necessaria" 
@ prow()+1,000 PSAY replicate("-",limite)
@ prow()+2,000 PSAY "MAT. EMBALAGEM ESSENCIAL"
@ prow()+1,000 PSAY " "
for _i:=1 to len(_aees)
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	if ( _aees[_i,8] <> _aees[_i,9]) .OR.(_aees[_i,8] <> _aees[_i,10])
		@ prow()+1,000 PSAY _aees[_i,1]
		@ prow(),007   PSAY _aees[_i,2]
		@ prow(),038   PSAY _aees[_i,3]
		@ prow(),041   PSAY _aees[_i,4] picture "@E 99999,999.99"
		@ prow(),054   PSAY _aees[_i,5] picture "@E 99999,999.99"
		@ prow(),067   PSAY _aees[_i,6] picture "@E 9999,999.99"
		@ prow(),079   PSAY _aees[_i,7] picture "@E 99999,999.99"
		@ prow(),092   PSAY _aees[_i,8] picture "@E 99999,999.99"
		@ prow(),105   PSAY _aees[_i,9] picture "@E 99999,999.99"
		@ prow(),118   PSAY _aees[_i,10] picture "@E 999,999,999.99"
  endif		
next
@ prow()+2,000 PSAY "MAT. EMBALAGEM NAO ESSENCIAL"
@ prow()+1,000 PSAY " "
for _i:=1 to len(_aens)
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif 
//	if (_aens[_i,8] <>_aens[_i,9]) .or. (_aens[_i,8] <> _aens[_i,10])	
		@ prow()+1,000 PSAY _aens[_i,1]
		@ prow(),007   PSAY _aens[_i,2]
		@ prow(),038   PSAY _aens[_i,3]
		@ prow(),041   PSAY _aens[_i,4] picture "@E 99999,999.99"
		@ prow(),054   PSAY _aens[_i,5] picture "@E 99999,999.99"
		@ prow(),067   PSAY _aens[_i,6] picture "@E 9999,999.99"
		@ prow(),079   PSAY _aens[_i,7] picture "@E 99999,999.99"
		@ prow(),092   PSAY _aens[_i,8] picture "@E 99999,999.99"
		@ prow(),105   PSAY _aens[_i,9] picture "@E 99999,999.99"
		@ prow(),118   PSAY _aens[_i,10] picture "@E 999,999,999.99"
//	endif	
next

@ prow()+2,000 PSAY "MATERIA PRIMA"
@ prow()+1,000 PSAY " "
for _i:=1 to len(_amps)
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
//	if ( _amps[_i,8] <> _amps[_i,9]) .OR. ( _amps[_i,8] <> _amps[_i,10] )
		@ prow()+1,000 PSAY _amps[_i,1]
		@ prow(),007   PSAY _amps[_i,2]
		@ prow(),038   PSAY _amps[_i,3]
		@ prow(),041   PSAY _amps[_i,4] picture "@E 99999,999.99"
		@ prow(),054   PSAY _amps[_i,5] picture "@E 99999,999.99"
		@ prow(),067   PSAY _amps[_i,6] picture "@E 9999,999.99"
		@ prow(),079   PSAY _amps[_i,7] picture "@E 99999,999.99"
		@ prow(),092   PSAY _amps[_i,8] picture "@E 99999,999.99"
		@ prow(),105   PSAY _amps[_i,9] picture "@E 99999,999.99"
		@ prow(),118   PSAY _amps[_i,10] picture "@E 999,999,999.99"
//   endif
next
endif

//
if prow()>0 .and.;
	lcontinua
   roda(cbcont,cbtxt)
endif

set device to screen

_cindtmp1+=tmp1->(ordbagext())
tmp1->(dbclosearea())
ferase(_carqtmp1+getdbextension())
ferase(_cindtmp1)

_cindtmpa+=tmpa->(ordbagext())
tmpa->(dbclosearea())
ferase(_carqtmpa+getdbextension())
ferase(_cindtmpa)

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endif

ms_flush()
return

static function _geratmp(_cproduto,_nqb,_nquant)

sg1->(dbseek(_cfilsg1+_cproduto))
while ! sg1->(eof()) .and.;
		sg1->g1_filial==_cfilsg1 .and.;
		sg1->g1_cod==_cproduto
	sb1->(dbseek(_cfilsb1+sg1->g1_comp))
	if sb1->b1_tipo=="PI"
		_nregsg1:=sg1->(recno())
		_geratmp(sg1->g1_comp,sb1->b1_qb,(sg1->g1_quant/_nqb)*_nquant)
		sg1->(dbgoto(_nregsg1))
	else
		if ! tmp1->(dbseek(sg1->g1_comp))
			tmp1->(dbappend())
			tmp1->comp :=sg1->g1_comp
			tmp1->quant:=(sg1->g1_quant/_nqb)*_nquant
		else
			tmp1->quant+=(sg1->g1_quant/_nqb)*_nquant
		endif
	endif
	sg1->(dbskip())
end
return

static function  _geratmpA()    
sct->(dbseek(_cfilsct+mv_par01))
while ! sct->(eof()) .and.;
		sct->ct_filial==_cfilsct .and.;
		sct->ct_doc <=mv_par02
  		sb1->(dbseek(_cfilsb1+sct->ct_produto))
		if ! tmpa->(dbseek(sct->ct_produto))
			tmpa->(dbappend())
			tmpa->produto :=sct->ct_produto
			tmpa->descricao :=sb1->b1_desc
			tmpa->quant:=sct->ct_quant
		else
			tmpa->quant +=sct->ct_quant
		endif
	sct->(dbskip())
end
return
/*
static function _geratmpA()
procregua(1)              

incproc("Selecionando produtos...")
	_cquery:=" SELECT"
	_cquery+=" CT_PRODUTO PRODUTO,SUM(CT_QUANT) QUANT,"
	_cquery+=" B1_DESC DESCRICAO,' ' D_E_L_E_T_,"
	_cquery+=" BM_TIPGRU TIPGRU"
	_cquery+=" FROM "
	_cquery+=" SB1010 SB1,"
	_cquery+=" SBM010 SBM,"		
	_cquery+=" SCT010 SCT"
	_cquery+=" WHERE"     
	_cquery+="     SB1.D_E_L_E_T_<>'*'"     
	_cquery+=" AND SCT.D_E_L_E_T_<>'*'"
	_cquery+=" AND SBM.D_E_L_E_T_<>'*'"
	_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
	_cquery+=" AND CT_FILIAL='"+_cfilsct+"'"  
  	_cquery+=" AND BM_FILIAL='"+_cfilsbm+"'"	
	_cquery+=" AND CT_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	_cquery+=" GROUP BY"
	_cquery+=" B1_DESC,CT_PRODUTO,BM_TIPGRU"
	_cquery+=" ORDER BY"
	_cquery+=" B1_DESC,CT_PRODUTO,BM_TIPGRU"
                                               
//	_cquery:=changequery(_cquery)
	tcquery _cquery new alias "TMPA" 
	tcsetfield("TMPA","QUANT","N",14,0)
	
return                     
*/

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Documento1         ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Documento2         ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Considera Pendência?","mv_ch3","N",08,0,0,"C",space(60),"mv_par03"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Imp.Dif.Ped/SolXNec?","mv_ch4","N",08,0,0,"C",space(60),"mv_par04"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Som.Dif.Ped/SolXNec?","mv_ch5","N",08,0,0,"C",space(60),"mv_par05"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
Codigo Descricao                                UM Lote padrao Qtde. a fab. Documento
xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx 999.999.999  999.999.999   999999
Codigo Descricao                      UM   Quantidade      Estoque  Quarentena      Empenho  Necessidade  Solicitacao       Pedido
xxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx 99999.999,99 99999.999,99 9999.999,99 99999.999,99 99999.999,99 99999.999,99 99999.999,99
*/

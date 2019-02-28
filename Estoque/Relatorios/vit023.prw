/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT023   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 04/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo Geral                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit023()
titulo  := "RESUMO GERAL"
cdesc1  := "Este programa ira emitir o resumo geral"
cdesc2  := ""
cdesc3  := ""
tamanho := "P"
limite  := 80
cstring :="SB1"
areturn :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog:="VIT023"
alinha  :={}
nlastkey:=0
lcontinua:=.t.

cperg:="PERGVIT023"
_pergsx1()
pergunte(cperg,.f.)

////
if mv_par03<>"1"
	if sm0->m0_codigo<>"02" .or.;
		(upper(alltrim(getenvserver()))<>"BACKUP" .and. upper(alltrim(getenvserver()))<>"BKP")
		msgstop("Programa não habilitado para esta filial!")				
		return
	endif
	if tclink("oracle/dadosadv","192.168.1.20")<>0
		msgstop("Falha de conexao com o banco!")
		tcquit()
		return
	endif
endif	

///

wnrel:="VIT023"+Alltrim(cusername)
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
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)
if mv_par03="2"
	_abretop("DA0010",1)
	_abretop("DA1010",1)
	_abretop("SB1010",1)
	_abretop("SB2010",1)
	_abretop("SE1010",1)
	_abretop("SM2010",1)
endif
_cfilda0:=xfilial("DA0")
_cfilda1:=xfilial("DA1")
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsc2:=xfilial("SC2")
_cfilsc7:=xfilial("SC7")
_cfilse1:=xfilial("SE1")
_cfilse2:=xfilial("SE2")
da0->(dbsetorder(1))
da1->(dbsetorder(1))
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sc2->(dbsetorder(1))
sc7->(dbsetorder(1))
se1->(dbsetorder(1))
se2->(dbsetorder(1))
sm2->(dbsetorder(1))

_ccq      :=getmv("MV_CQ")
_nmp      :=0
_ncqmp    :=0
_nee      :=0
_ncqee    :=0
_nen      :=0
_ncqen    :=0
_npa      :=0
_ncqpa    :=0
_noutros  :=0
_nproducao:=0
_ncarteira:=0
_nprotesto:=0
_nadvogado:=0
_ncheques :=0
_ncobbanco:=0
_noutrec  :=0
_ntesourar:=0
_ncompras :=0
_noutpag  :=0  

if mv_par03="2"
	processa({|| _calcula()})
else                        
	processa({|| _calcula2()})
endif	

setregua(1)
incregua()

setprc(0,0)

@ 000,000 PSAY avalimp(limite)

@ 002,000      PSAY "Resumo geral em "+dtoc(ddatabase)+" as "+time() +"       Tesouraria até :"+dtoc(mv_par04)

_nsoma :=_nmp+_ncqmp+_nee+_ncqee+_nen+_ncqen+_noutros
_nsaldo:=_nsoma
@ prow()+2,000 PSAY "1 - Estoques / Almoxarifados"
@ prow()+2,000 PSAY "Matéria Prima"
@ prow(),032   PSAY _nmp       picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Quarentena Mat. Prima"
@ prow(),032   PSAY _ncqmp     picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Mat. Embalagem Essencial"
@ prow(),032   PSAY _nee       picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Quarentena Emb. Essencial"
@ prow(),032   PSAY _ncqee     picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Mat. de Embalagem não Essencial"
@ prow(),032   PSAY _nen       picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Quarentena Emb. não Essencial"
@ prow(),032   PSAY _ncqen     picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Outros Materiais"
@ prow(),032   PSAY _noutros   picture "@E 999,999,999.99"
@ prow(),047   PSAY _nsoma     picture "@E 999,999,999.99"

_nsoma :=_nproducao+_ncqpa+_npa
_nsaldo+=_nsoma
@ prow()+4,000 PSAY "2 - Produção / Indústria"
@ prow()+2,000 PSAY "Em Produção"
@ prow(),032   PSAY _nproducao picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Em Quarentena"
@ prow(),032   PSAY _ncqpa     picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Produto Acabado"
@ prow(),032   PSAY _npa       picture "@E 999,999,999.99"
@ prow(),047   PSAY _nsoma     picture "@E 999,999,999.99"
@ prow(),062   PSAY _nsaldo    picture "@E( 999,999,999.99"

_nsoma :=_ncarteira+_nprotesto+_nadvogado+_ncheques+_ncobbanco+_noutrec
_nsaldo+=_nsoma
@ prow()+4,000 PSAY "3 - Contas a Receber"
@ prow()+2,000 PSAY "Duplicatas em Carteira"
@ prow(),032   PSAY _ncarteira picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Duplicatas em Protesto"
@ prow(),032   PSAY _nprotesto picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Duplicatas com Advogado"
@ prow(),032   PSAY _nadvogado picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Cheques em Carteira"
@ prow(),032   PSAY _ncheques  picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Cobrança Bancária"
@ prow(),032   PSAY _ncobbanco picture "@E 999,999,999.99"
if mv_par03="2"
	@ prow()+1,000 PSAY "Outros"
	@ prow(),032   PSAY _noutrec picture "@E 999,999,999.99"
endif	
@ prow(),047   PSAY _nsoma     picture "@E 999,999,999.99"
@ prow(),062   PSAY _nsaldo    picture "@E( 999,999,999.99"

_nsoma :=_ntesourar+_ncompras+_noutpag
_nsaldo-=_nsoma
@ prow()+4,000 PSAY "4 - Contas a Pagar"
@ prow()+2,000 PSAY "Tesouraria"
@ prow(),032   PSAY _ntesourar picture "@E 999,999,999.99"
@ prow()+1,000 PSAY "Compras Pendentes"
@ prow(),032   PSAY _ncompras  picture "@E 999,999,999.99"
if mv_par03="2"
	@ prow()+1,000 PSAY "Outras"
	@ prow(),032   PSAY _noutpag   picture "@E 999,999,999.99"
endif	
@ prow(),047   PSAY _nsoma*-1  picture "@E( 999,999,999.99"
@ prow(),062   PSAY _nsaldo    picture "@E( 999,999,999.99"

roda(0," ")

set device to screen
if mv_par03<>"1"
	tcquit()
endif	

if areturn[5]==1
	set printer to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

// grade 2
static function _calcula()
procregua(7)
da0010->(dbseek(_cfilda0+mv_par01))

incproc("Calculando estoques...")
sb2010->(dbseek(_cfilsb2))
while ! sb2010->(eof()) .and.;
		sb2010->b2_filial==_cfilsb2
	sb1010->(dbseek(_cfilsb1+sb2010->b2_cod))
	if sb1010->b1_tipo$"MP/EE/EN"
		if sb2010->b2_local<>_ccq
			_ndisp :=sb2010->b2_qatu-sb2->b2_qemp-sb2->b2_reserva
			_nvalor:=round(_ndisp*sb2010->b2_cm1,2)
			if _ndisp>0
				if sb1010->b1_tipo=="MP"			
					_nmp+=_nvalor
				elseif sb1010->b1_tipo=="EE"
					_nee+=_nvalor
				else
					_nen+=_nvalor
				endif
			endif
		else
			if sb1010->b1_tipo=="MP"
				_ncqmp+=sb2010->b2_vatu1
			elseif sb1010->b1_tipo=="EE"
				_ncqee+=sb2010->b2_vatu1
			else
				_ncqen+=sb2010->b2_vatu1
			endif
		endif
	elseif sb1010->b1_tipo=="PA"
	   if sb1->b1_apreven ="1"
			da1010->(dbseek(_cfilda1+mv_par01+sb2010->b2_cod))
			_ncusto:=da1010->da1_prcven*(1-(da0010->da0_desc1/100))
			_ncusto:=_ncusto*(1-(da0010->da0_desc2/100))
			_ncusto:=_ncusto*(1-(da0010->da0_desc3/100))
			_ncusto:=_ncusto*(1-(da0010->da0_desc4/100))
			_ncusto:=round(_ncusto*0.7,2) // MENOS 30%
		else
			da1010->(dbseek(_cfilda1+mv_par02+sb2010->b2_cod))
			_ncusto:=da1010->da1_prcven
		endif	
		if sb2010->b2_local<>_ccq
			_npa+=round(sb2010->b2_qatu*_ncusto,2)
		else
			_ncqpa+=round(sb2010->b2_qatu*_ncusto,2)
		endif
	elseif ! sb1010->b1_tipo$"PI/PL/MO"
		_noutros+=sb2010->b2_vatu1
	endif
	sb2010->(dbskip())
end
			
incproc("Calculando produção...")
_cquery:=" SELECT"
_cquery+=" C2_PRODUTO PRODUTO,C2_QUANT-C2_QUJE QUANT"
_cquery+=" FROM "
_cquery+=" SB1010 SB1,"
_cquery+=" SC2010 SC2"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SC2.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND C2_FILIAL='"+_cfilsc2+"'"
_cquery+=" AND C2_PRODUTO=B1_COD"
_cquery+=" AND B1_TIPO='PA'"
_cquery+=" AND C2_DATRF='        '"
_cquery+=" AND C2_QUANT-C2_QUJE>0"

//_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","QUANT","N",15,2)

tmp1->(dbgotop())
while ! tmp1->(eof())               
   if sb1->b1_apreven ="1"   
		da1010->(dbseek(_cfilda1+mv_par01+tmp1->produto))
		_ncusto:=da1010->da1_prcven*(1-(da0010->da0_desc1/100))
		_ncusto:=_ncusto*(1-(da0010->da0_desc2/100))
		_ncusto:=_ncusto*(1-(da0010->da0_desc3/100))
		_ncusto:=_ncusto*(1-(da0010->da0_desc4/100))
		_ncusto:=round(_ncusto*0.7,2) // MENOS 30%
	else
		da1010->(dbseek(_cfilda1+mv_par02+tmp1->produto))
		_ncusto:=da1010->da1_prcven
	endif	
	_nproducao+=round(tmp1->quant*_ncusto,2)
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

incproc("Calculando contas a receber...")
_cquery:=" SELECT"
_cquery+=" E1_PREFIXO PREFIXO,E1_NUM NUMERO,E1_PARCELA PARCELA,E1_TIPO TIPO,"
_cquery+=" E1_SITUACA SITUACAO,E1_SALDO SALDO,E1_MOEDA MOEDA"
_cquery+=" FROM "
_cquery+=" SE1010 SE1"
_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_SITUACA<>'2'"
_cquery+=" AND SUBSTR(E1_TIPO,3,1)<>'-'"
_cquery+=" AND E1_SALDO>0"

//_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","SALDO","N",12,2)
tcsetfield("TMP1","MOEDA","N",02,0)

tmp1->(dbgotop())
while ! tmp1->(eof())
	_nvalor:=tmp1->saldo
	if ! tmp1->tipo$"RA /NCC"
		se1010->(dbseek(_cfilse1+tmp1->prefixo+tmp1->numero+tmp1->parcela))
		while ! se1010->(eof()) .and.;
				se1010->e1_filial==_cfilse1 .and.;
				se1010->e1_prefixo==tmp1->prefixo .and.;
				se1010->e1_num==tmp1->numero .and.;
				se1010->e1_parcela==tmp1->parcela
			if right(se1010->e1_tipo,3)=="-"
				_nvalor-=se1010->e1_saldo
			endif
			se1010->(dbskip())
		end
	endif
	if tmp1->moeda>1
		sm2010->(dbseek(ddatabase))
		_ccampo   :="M2_MOEDA"+strzero(tmp1->moeda,1)
		_nvalmoeda:=sm2010->(fieldget(fieldpos(_ccampo)))
		if _nvalmoeda==0
			sm2010->(dbskip(-1))
			while ! sm2010->(bof()) .and.;
					_nvalmoeda==0
				_nvalmoeda:=sm2010->(fieldget(fieldpos(_ccampo)))
				sm2010->(dbskip(-1))
			end
		endif
		if _nvalmoeda>0
			_nvalor:=round(_nvalor*_nvalmoeda,2)
		endif
	endif
	if tmp1->tipo=="CH "
		_ncheques+=_nvalor
	elseif tmp1->situacao=="0"
		if tmp1->tipo$"RA /NCC"
			_ncarteira-=_nvalor
		else
			_ncarteira+=_nvalor
		endif
	elseif tmp1->situacao$"134"
		_ncobbanco+=_nvalor
	elseif tmp1->situacao=="5"
		_nadvogado+=_nvalor
	elseif tmp1->situacao=="6"
		_nprotesto+=_nvalor
	endif
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

incproc("Calculando outros a receber...")

se1->(dbsetorder(1))
se1->(dbseek(_cfilse1))
while ! se1->(eof()) .and.;
		se1->e1_filial==_cfilse1
	if se1->e1_saldo>0
		if se1->e1_moeda>1
			sm2010->(dbseek(ddatabase))
			_ccampo   :="M2_MOEDA"+strzero(se1->e1_moeda,1)
			_nvalmoeda:=sm2010->(fieldget(fieldpos(_ccampo)))
			if _nvalmoeda==0
				sm2010->(dbskip(-1))
				while ! sm2010->(bof()) .and.;
						_nvalmoeda==0
					_nvalmoeda:=sm2010->(fieldget(fieldpos(_ccampo)))
					sm2010->(dbskip(-1))
				end
			endif
			if _nvalmoeda>0
				_nvalor:=round(se1->e1_saldo*_nvalmoeda,2)
			else
				_nvalor:=se1->e1_saldo
			endif
		else
			_nvalor:=se1->e1_saldo
		endif
		if se1->e1_tipo$"RA /NCC" .or. right(se1->e1_tipo,1)=="-"
			_noutrec-=_nvalor
		else
			_noutrec+=_nvalor
		endif
	endif
	se1->(dbskip())
end

incproc("Calculando contas a pagar...")
_cquery:=" SELECT"
_cquery+=" E2_PREFIXO PREFIXO,E2_NUM NUMERO,E2_PARCELA PARCELA,E2_TIPO TIPO,"
_cquery+=" E2_SALDO SALDO,E2_MOEDA MOEDA"
_cquery+=" FROM "
_cquery+=" SE2010 SE2"
_cquery+=" WHERE"
_cquery+="     SE2.D_E_L_E_T_<>'*'"
_cquery+=" AND E2_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E2_SALDO>0"

//_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","SALDO"  ,"N",12,2)
tcsetfield("TMP1","MOEDA"  ,"N",02,0)

tmp1->(dbgotop())
while ! tmp1->(eof())
	if tmp1->moeda>1
		sm2010->(dbseek(ddatabase))
		_ccampo   :="M2_MOEDA"+strzero(tmp1->moeda,1)
		_nvalmoeda:=sm2010->(fieldget(fieldpos(_ccampo)))
		if _nvalmoeda==0
			sm2010->(dbskip(-1))
			while ! sm2010->(bof()) .and.;
					_nvalmoeda==0
				_nvalmoeda:=sm2010->(fieldget(fieldpos(_ccampo)))
				sm2010->(dbskip(-1))
			end
		endif
		if _nvalmoeda==0
			_nvalor:=tmp1->saldo
		else                                       
			_nvalor:=round(tmp1->saldo*_nvalmoeda,2)
		endif
	else
		_nvalor:=tmp1->saldo
	endif
	if tmp1->tipo$"PA /NDF" .or. right(tmp1->tipo,1)=="-"
		_ntesourar-=_nvalor
	else
		_ntesourar+=_nvalor
	endif
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

incproc("Calculando outros a pagar...")
se2->(dbsetorder(1))
se2->(dbseek(_cfilse2))
while ! se2->(eof()) .and.;
		se2->e2_filial==_cfilse2
	if se2->e2_saldo>0
		if se2->e2_moeda>1
			sm2010->(dbseek(ddatabase))
			_ccampo   :="M2_MOEDA"+strzero(se2->e2_moeda,1)
			_nvalmoeda:=sm2010->(fieldget(fieldpos(_ccampo)))
			if _nvalmoeda==0
				sm2010->(dbskip(-1))
				while ! sm2010->(bof()) .and.;
						_nvalmoeda==0
					_nvalmoeda:=sm2010->(fieldget(fieldpos(_ccampo)))
					sm2010->(dbskip(-1))
				end
			endif
			if _nvalmoeda>0
				_nvalor:=round(se2->e2_saldo*_nvalmoeda,2)
			else
				_nvalor:=se2->e2_saldo
			endif
		else
			_nvalor:=se2->e2_saldo
		endif
		if se2->e2_tipo$"PA /NDF" .or. right(se2->e2_tipo,1)=="-"
			_noutpag-=_nvalor
		else
			_noutpag+=_nvalor
		endif
	endif
	se2->(dbskip())
end

incproc("Calculando compras pendentes...")
_cquery:=" SELECT"
_cquery+=" C7_MOEDA MOEDA,SUM((C7_QUANT-C7_QUJE)*C7_PRECO) VALOR"
_cquery+=" FROM "
_cquery+=" SC7010 SC7"
_cquery+=" WHERE"
_cquery+="     SC7.D_E_L_E_T_<>'*'"
_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
_cquery+=" AND C7_QUANT-C7_QUJE>0"
_cquery+=" AND C7_RESIDUO=' '"
_cquery+=" GROUP BY"
_cquery+=" C7_MOEDA"

//_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","VALOR","N",12,2)
tcsetfield("TMP1","MOEDA","N",01,0)

tmp1->(dbgotop())
while ! tmp1->(eof())
	if tmp1->moeda==1
		_ncompras+=tmp1->valor
	else
		sm2010->(dbseek(ddatabase))
		_ccampo   :="M2_MOEDA"+strzero(tmp1->moeda,1)
		_nvalmoeda:=sm2010->(fieldget(fieldpos(_ccampo)))
		if _nvalmoeda==0
			sm2010->(dbskip(-1))
			while ! sm2010->(bof()) .and.;
					_nvalmoeda==0
				_nvalmoeda:=sm2010->(fieldget(fieldpos(_ccampo)))
				sm2010->(dbskip(-1))
			end
		endif
		if _nvalmoeda>0
			_ncompras+=round(tmp1->valor*_nvalmoeda,2)
		else
			_ncompras+=tmp1->valor
		endif
	endif
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

da0010->(dbclosearea())
da1010->(dbclosearea())
sb1010->(dbclosearea())
sb2010->(dbclosearea())
se1010->(dbclosearea())
sm2010->(dbclosearea())
return
// fim grade 2//
  
// grade 1
static function _calcula2()
procregua(7)
da0->(dbseek(_cfilda0+mv_par01))
incproc("Calculando estoques...")
sb2->(dbseek(_cfilsb2))
while ! sb2->(eof()) .and.;
	sb2->b2_filial==_cfilsb2
	sb1->(dbseek(_cfilsb1+sb2->b2_cod))
	if sb1->b1_tipo$"MP/EE/EN"
		if sb2->b2_local==sb1->b1_locpad
			_ndisp :=	sb2->b2_qatu-sb2->b2_qemp-sb2->b2_reserva 
			_nvalor:=round(_ndisp*sb2->b2_cm1,2)
			if _ndisp>0
				if sb1->b1_tipo=="MP" 
		/*	 if _nvalor > 100000  
				 msgstop(sb2->b2_cod)                              
				 msgtop(sb2->b2_qatu)
				 msgstop(sb2->b2_qemp)
				 msgstop(sb2->b2_reserva)
			    msgstop(_ndisp)				  
				  msgstop(_nvalor)*/
					_nmp+=_nvalor 
//			endif		
				elseif sb1->b1_tipo=="EE"
					_nee+=_nvalor
				else
					_nen+=_nvalor
				endif
			endif
		elseif sb2->b2_local==_ccq
			if sb1->b1_tipo=="MP"
				_ncqmp+=sb2->b2_vatu1
			elseif sb1->b1_tipo=="EE"
				_ncqee+=sb2->b2_vatu1
			else
				_ncqen+=sb2->b2_vatu1
			endif
		endif
	elseif sb1->b1_tipo=="PA" 
	   if sb1->b1_apreven ="1"
  			da1->(dbseek(_cfilda1+mv_par01+sb2->b2_cod))
			_ncusto:=da1->da1_prcven*(1-(da0->da0_desc1/100))
			_ncusto:=_ncusto*(1-(da0->da0_desc2/100))
			_ncusto:=_ncusto*(1-(da0->da0_desc3/100))
			_ncusto:=_ncusto*(1-(da0->da0_desc4/100))
			_ncusto:=round(_ncusto*0.7,2) // MENOS 30%
		else
  			da1->(dbseek(_cfilda1+mv_par02+sb2->b2_cod))
 			_ncusto:=da1->da1_prcven
		endif	
		if sb2->b2_local<>_ccq
			_npa+=round(sb2->b2_qatu*_ncusto,2)
		else
			_ncqpa+=round(sb2->b2_qatu*_ncusto,2)
		endif
	elseif ! sb1->b1_tipo$"PI/PL/MO"
		_noutros+=sb2->b2_vatu1
	endif
	sb2->(dbskip())
end
			
incproc("Calculando produção...")
_cquery:=" SELECT"
_cquery+=" C2_PRODUTO PRODUTO,C2_QUANT-C2_QUJE QUANT"
_cquery+=" FROM "
_cquery+=" SB1010 SB1,"
_cquery+=" SC2010 SC2"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SC2.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND C2_FILIAL='"+_cfilsc2+"'"
_cquery+=" AND C2_PRODUTO=B1_COD"
_cquery+=" AND B1_TIPO='PA'"
_cquery+=" AND C2_DATRF='        '"
_cquery+=" AND C2_QUANT-C2_QUJE>0"

//_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","QUANT","N",15,2)

tmp1->(dbgotop())
while ! tmp1->(eof())
   if sb1->b1_apreven="1"   
	  	da1->(dbseek(_cfilda1+mv_par01+tmp1->produto))
		_ncusto:=da1->da1_prcven*(1-(da0->da0_desc1/100))
		_ncusto:=_ncusto*(1-(da0010->da0_desc2/100))
		_ncusto:=_ncusto*(1-(da0010->da0_desc3/100))
		_ncusto:=_ncusto*(1-(da0010->da0_desc4/100))
		_ncusto:=round(_ncusto*0.7,2) // MENOS 30%
	else
	  	da1->(dbseek(_cfilda1+mv_par02+tmp1->produto))
		_ncusto:=da1->da1_prcven
	endif
	_nproducao+=round(tmp1->quant*_ncusto,2)
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

incproc("Calculando contas a receber...")
_cquery:=" SELECT"
_cquery+=" E1_PREFIXO PREFIXO,E1_NUM NUMERO,E1_PARCELA PARCELA,E1_TIPO TIPO,"
_cquery+=" E1_SITUACA SITUACAO,E1_SALDO SALDO,E1_MOEDA MOEDA"
_cquery+=" FROM "
_cquery+=" SE1010 SE1"
_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_SITUACA<>'2'"
_cquery+=" AND SUBSTR(E1_TIPO,3,1)<>'-'"
_cquery+=" AND E1_SALDO>0"

//_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","SALDO","N",12,2)
tcsetfield("TMP1","MOEDA","N",02,0)

tmp1->(dbgotop())
while ! tmp1->(eof())
	_nvalor:=tmp1->saldo
	if ! tmp1->tipo$"RA /NCC"
		se1->(dbseek(_cfilse1+tmp1->prefixo+tmp1->numero+tmp1->parcela))
		while ! se1->(eof()) .and.;
				se1->e1_filial==_cfilse1 .and.;
				se1->e1_prefixo==tmp1->prefixo .and.;
				se1->e1_num==tmp1->numero .and.;
				se1->e1_parcela==tmp1->parcela
			if right(se1->e1_tipo,3)=="-"
				_nvalor-=se1->e1_saldo
			endif
			se1->(dbskip())
		end
	endif
	if tmp1->moeda>1
		sm2->(dbseek(ddatabase))
		_ccampo   :="M2_MOEDA"+strzero(tmp1->moeda,1)
		_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
		if _nvalmoeda==0
			sm2->(dbskip(-1))
			while ! sm2->(bof()) .and.;
					_nvalmoeda==0
				_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
				sm2->(dbskip(-1))
			end
		endif
		if _nvalmoeda>0
			_nvalor:=round(_nvalor*_nvalmoeda,2)
		endif
	endif
	if tmp1->tipo=="CH "
		_ncheques+=_nvalor
	elseif tmp1->situacao=="0"
		if tmp1->tipo$"RA /NCC"
			_ncarteira-=_nvalor
		else
			_ncarteira+=_nvalor
		endif
	elseif tmp1->situacao$"134"
		_ncobbanco+=_nvalor
	elseif tmp1->situacao=="5"
		_nadvogado+=_nvalor
	elseif tmp1->situacao=="6"
		_nprotesto+=_nvalor
	endif
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

incproc("Calculando contas a pagar...")
_cquery:=" SELECT"
_cquery+=" E2_PREFIXO PREFIXO,E2_NUM NUMERO,E2_PARCELA PARCELA,E2_TIPO TIPO,"
_cquery+=" E2_SALDO SALDO,E2_MOEDA MOEDA"
_cquery+=" FROM "
_cquery+=" SE2010 SE2"
_cquery+=" WHERE"
_cquery+="     SE2.D_E_L_E_T_<>'*'"
_cquery+=" AND E2_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E2_SALDO>0"
_cquery+=" AND E2_VENCREA <= '" +dtos(mv_par04)+"'"

//_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","SALDO"  ,"N",12,2)
tcsetfield("TMP1","MOEDA"  ,"N",02,0)

tmp1->(dbgotop())
while ! tmp1->(eof())
	if tmp1->moeda>1
		sm2->(dbseek(ddatabase))
		_ccampo   :="M2_MOEDA"+strzero(tmp1->moeda,1)
		_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
		if _nvalmoeda==0
			sm2->(dbskip(-1))
			while ! sm2->(bof()) .and.;
					_nvalmoeda==0
				_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
				sm2->(dbskip(-1))
			end
		endif
		if _nvalmoeda==0
			_nvalor:=tmp1->saldo
		else
			_nvalor:=round(tmp1->saldo*_nvalmoeda,2)
		endif
	else
	
		_nvalor:=tmp1->saldo
	endif
	if tmp1->tipo$"PA /NDF" .or. right(tmp1->tipo,1)=="-"
		_ntesourar-=_nvalor
	else
		_ntesourar+=_nvalor
	endif
	tmp1->(dbskip())
end
tmp1->(dbclosearea())


incproc("Calculando compras pendentes...")
_cquery:=" SELECT"
_cquery+=" C7_MOEDA MOEDA,SUM((C7_QUANT-C7_QUJE)*C7_PRECO) VALOR"
_cquery+=" FROM "
_cquery+=" SC7010 SC7"
_cquery+=" WHERE"
_cquery+="     SC7.D_E_L_E_T_<>'*'"
_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
_cquery+=" AND C7_QUANT-C7_QUJE>0"
_cquery+=" AND C7_RESIDUO=' '"
_cquery+=" GROUP BY"
_cquery+=" C7_MOEDA"

//_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","VALOR","N",12,2)
tcsetfield("TMP1","MOEDA","N",01,0)

tmp1->(dbgotop())
while ! tmp1->(eof())
	if tmp1->moeda==1
		_ncompras+=tmp1->valor
	else
		sm2->(dbseek(ddatabase))
		_ccampo   :="M2_MOEDA"+strzero(tmp1->moeda,1)
		_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
		if _nvalmoeda==0
			sm2->(dbskip(-1))
			while ! sm2->(bof()) .and.;
					_nvalmoeda==0
				_nvalmoeda:=sm2->(fieldget(fieldpos(_ccampo)))
				sm2->(dbskip(-1))
			end
		endif
		if _nvalmoeda>0
			_ncompras+=round(tmp1->valor*_nvalmoeda,2)
		else
			_ncompras+=tmp1->valor
		endif
	endif
	tmp1->(dbskip())
end
tmp1->(dbclosearea())
return

//
static function _abretop(_carq,_nordem)
_calias:=left(_carq,3)
dbusearea(.t.,"TOPCONN",_carq,_carq,.t.,.f.)
six->(dbseek(_calias))
while ! six->(eof()) .and.;
		six->indice==_calias
	dbsetindex(_carq+six->ordem)
	six->(dbskip())
end
dbsetorder(_nordem)
return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Tabela precos FARMA?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"DA0"})
aadd(_agrpsx1,{cperg,"02","Tabela precos HOSP.?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"DA0"})	
aadd(_agrpsx1,{cperg,"03","Grade              ?","mv_ch3","C",01,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Contas a Pagar até ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT060   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 02/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo da Cobranca                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit060()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="RESUMO DA COBRANCA"
cdesc1   :="Este programa ira emitir o resumo da cobranca"
cdesc2   :=""
cdesc3   :=""
cstring  :="SE1"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT060"
wnrel    :="VIT060"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

_cperg:="PERGVIT060"
_pergsx1()
pergunte(_cperg,.f.)

wnrel:=setprint(cstring,wnrel,_cperg,@titulo,cdesc1,cdesc2,cdesc3,.t.,"",.f.,tamanho,"",.f.)

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

titulo:="RESUMO DA COBRANCA"
cabec1:="                                     V E N C I D A S                                  A   V E N C E R"
cabec2:="Cobranca                Ate 5 dias De 06 a 15 dias Maior que 15 dias     Ate 5 dias De 06 a 15 dias Maior que 15 dias          Total"

_cfilsa6:=xfilial("SA6")
_cfilsa1:=xfilial("SA1")
_cfilse1:=xfilial("SE1")
_cfilse5:=xfilial("SE5")
sa6->(dbsetorder(1))
sa1->(dbsetorder(1))
se1->(dbsetorder(1))
se5->(dbsetorder(1))

_atotger:={0,0,0,0,0,0}
_asitger:=array(7,6)
for _i:=1 to 7
	for _j:=1 to 6
		_asitger[_i,_j]:=0 
	next
next

#IFNDEF TOP
	_aestrut:={}
	aadd(_aestrut,{"BANCO"   ,"C",03,0})
	aadd(_aestrut,{"AGENCIA" ,"C",05,0})
	aadd(_aestrut,{"CONTA"   ,"C",10,0})
	aadd(_aestrut,{"SITUACAO","C",01,0})
	aadd(_aestrut,{"PREFIXO" ,"C",03,0})
	aadd(_aestrut,{"NUMERO"  ,"C",06,0})
	aadd(_aestrut,{"PARCELA" ,"C",01,0})
	aadd(_aestrut,{"TIPO"    ,"C",03,0})
	
	_carqtmp1:=criatrab(_aestrut,.t.)
	dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)
	
	_cchave  :="BANCO+AGENCIA+CONTA+SITUACAO+PREFIXO+NUMERO+PARCELA+TIPO"
	_cindtmp1:=criatrab(,.f.)
	tmp1->(indregua("TMP1",_cindtmp1,_cchave,,,"Selecionando registros..."))
#ENDIF

_nvalfat  :=0
_nvalgnr  :=0
_nvalbai  :=0
_agnr     :={0,0,0,0,0,0}
_aavista  :={0,0,0,0,0,0}
_aparcial :={0,0,0,0,0,0}
_acarteira:={0,0,0,0,0,0}
_acheqdev :={0,0,0,0,0,0}
_acheque  :={0,0,0,0,0,0}

processa({|| _geratmp()})

setprc(0,0)

setregua(se1->(lastrec()))

tmp1->(dbgotop())    
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>75
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
	if mv_par05==1 .and. sa1->a1_categ == "H " 
		tmp1->(dbskip())
      loop
   elseif mv_par05==2 .and. sa1->a1_categ <> "H "    
		tmp1->(dbskip())
      loop
   endif   
	if ! tmp1->banco$"CHE/   "
		sa6->(dbseek(_cfilsa6+tmp1->banco+tmp1->agencia+tmp1->conta))
		@ prow()+2,000 PSAY tmp1->banco+"/"+alltrim(tmp1->agencia)+"/"+alltrim(tmp1->conta)+" - "+sa6->a6_nome
	endif
	_atotsit  :={0,0,0,0,0,0}
	_cbanco   :=tmp1->banco
	_cagencia :=tmp1->agencia
	_cconta   :=tmp1->conta
  	_cheqdev := 0
	while ! tmp1->(eof()) .and.;
			tmp1->banco==_cbanco .and.;
			tmp1->agencia==_cagencia .and.;
			tmp1->conta==_cconta .and.;
			lcontinua
		sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
		if mv_par05==1 .and. sa1->a1_categ == "H " 
			tmp1->(dbskip())
	      loop
	   elseif mv_par05==2 .and. sa1->a1_categ <> "H "    
			tmp1->(dbskip())
	      loop
	   endif   

		_asit:={0,0,0,0,0,0}
		if ! _cbanco$"CHE/   "
			if prow()>75
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			@ prow()+1,000 PSAY left(tabela("07",tmp1->situacao),19)
		endif              
		_csituacao:=tmp1->situacao
		while ! tmp1->(eof()) .and.;
				tmp1->banco==_cbanco .and.;
				tmp1->agencia==_cagencia .and.;
				tmp1->conta==_cconta .and.;
				tmp1->situacao==_csituacao .and.;
				lcontinua
			incregua()
			sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
			if mv_par05==1 .and. sa1->a1_categ == "H " 
				tmp1->(dbskip())
		      loop
		   elseif mv_par05==2 .and. sa1->a1_categ <> "H "    
				tmp1->(dbskip())
		      loop
	   	endif   
			se1->(dbseek(_cfilse1+tmp1->prefixo+tmp1->numero+tmp1->parcela+tmp1->tipo))
//			_nsaldo:=saldotit(se1->e1_prefixo,se1->e1_num,se1->e1_parcela,;
//									se1->e1_tipo,se1->e1_naturez,"R",;
//									se1->e1_cliente,se1->e1_moeda,,,se1->e1_loja,_cfilse1)
			_nsaldo:=se1->e1_saldo
			if se1->e1_tipo$"RA /NCC"
				_nsaldo*=(-1)
			endif
			_ndias:=ddatabase-se1->e1_vencrea
			_ndiasav:=se1->e1_vencto-se1->e1_emissao
			if _ndias>15
				if _csituacao=="0"
					if se1->e1_parcela=="R"
						_agnr[1]+=_nsaldo
					elseif _ndiasav<=10
						_aavista[1]+=_nsaldo
					elseif _nsaldo<se1->e1_vlcruz
						_aparcial[1]+=_nsaldo
					else
						_acarteira[1]+=_nsaldo         
					endif
////  				if !empty(se1->e2_dtdev2)
			  	elseif _csituacao=="3"
	  			  	if tmp1->prefixo=="CHD" .and. tmp1->banco =="VIT"
						_acheqdev[1]+=_nsaldo
					else
						_acheque[1] +=_nsaldo
					endif	
				endif	
  				_asit[1]+=_nsaldo            

				//aqui - achar título errado
/*				@ prow()+1,000 PSAY tmp1->prefixo
				@ prow(),008 PSAY tmp1->numero
				@ prow(),015 PSAY tmp1->parcela
				@ prow(),018 PSAY se1->e1_valor picture "@E 999,999,999.99" //até aqui

*/  				
			elseif _ndias>5
				if _csituacao=="0"
					if se1->e1_parcela=="R"
						_agnr[2]+=_nsaldo
					elseif _ndiasav<=10
						_aavista[2]+=_nsaldo
					elseif _nsaldo<se1->e1_vlcruz
						_aparcial[2]+=_nsaldo
					else
						_acarteira[2]+=_nsaldo
					endif
// 				if !empty(se1->e2_dtdev2)
			  	elseif _csituacao=="3"
	  			  	if tmp1->prefixo=="CHD" .and. tmp1->banco =="VIT"
						_acheqdev[2]+=_nsaldo
					else
						_acheque[2] +=_nsaldo
					endif	
				endif	
				_asit[2]+=_nsaldo
		  	elseif _ndias>0
				if _csituacao=="0"
					if se1->e1_parcela=="R"
						_agnr[3]+=_nsaldo
					elseif _ndiasav<=10
						_aavista[3]+=_nsaldo
					elseif _nsaldo<se1->e1_vlcruz
						_aparcial[3]+=_nsaldo
					else
						_acarteira[3]+=_nsaldo
					endif
//  				if !empty(se1->e2_dtdev2)
			  	elseif _csituacao=="3" .and. tmp1->banco =="VIT"
	  			  	if tmp1->prefixo=="CHD" 
						_acheqdev[3]+=_nsaldo
					else
						_acheque[3] +=_nsaldo
					endif	
				endif	
				_asit[3]+=_nsaldo
			elseif _ndias>=-5
				if _csituacao=="0"
					if se1->e1_parcela=="R"
						_agnr[4]+=_nsaldo
					elseif _ndiasav<=10
						_aavista[4]+=_nsaldo
					elseif _nsaldo<se1->e1_vlcruz
						_aparcial[4]+=_nsaldo
					else
						_acarteira[4]+=_nsaldo
					endif
//  				if !empty(se1->e2_dtdev2)
			  	elseif _csituacao=="3" .and. tmp1->banco =="VIT"
	  			  	if tmp1->prefixo=="CHD"
						_acheqdev[4]+=_nsaldo
					else
						_acheque[4] +=_nsaldo
					endif	
				endif	
				_asit[4]+=_nsaldo
			elseif _ndias>=-15
				if _csituacao=="0"
					if se1->e1_parcela=="R"
						_agnr[5]+=_nsaldo
					elseif _ndiasav<=10
						_aavista[5]+=_nsaldo
					elseif _nsaldo<se1->e1_vlcruz
						_aparcial[5]+=_nsaldo
					else
						_acarteira[5]+=_nsaldo
					endif
//  				if !empty(se1->e2_dtdev2)
			  	elseif _csituacao=="3" .and. tmp1->banco =="VIT"
	  			  	if tmp1->prefixo=="CHD"
						_acheqdev[5]+=_nsaldo
					else
						_acheque[5] +=_nsaldo
					endif	
				endif	
				_asit[5]+=_nsaldo
			else
				if _csituacao=="0"
					if se1->e1_parcela=="R"
						_agnr[6]+=_nsaldo
					elseif _ndiasav<=10
						_aavista[6]+=_nsaldo
					elseif _nsaldo<se1->e1_vlcruz
						_aparcial[6]+=_nsaldo
					else
						_acarteira[6]+=_nsaldo
					endif
//  				if !empty(se1->e2_dtdev2)
			  	elseif _csituacao=="3" .and. tmp1->banco =="VIT"
	  			  	if tmp1->prefixo=="CHD" 
						_acheqdev[6]+=_nsaldo
					else
						_acheque[6] +=_nsaldo
					endif	
				endif	
				_asit[6]+=_nsaldo
			endif
			tmp1->(dbskip())
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				eject
				lcontinua:=.f.
			endif
		end
		_ntotsit:=0
		for _p:=1 to 06
			_ntotsit+=_asit[_p]
			_atotsit[_p]+=_asit[_p]
			_atotger[_p]+=_asit[_p]
    		_asitger[val(_csituacao)+1,_p]+=_asit[_p]
		next       
		if ! _cbanco$"CHE/   "
			@ prow(),020 PSAY _asit[3] picture "@E 999,999,999.99"
			@ prow(),036 PSAY _asit[2] picture "@E 999,999,999.99"
			@ prow(),054 PSAY _asit[1] picture "@E 999,999,999.99"
			@ prow(),069 PSAY _asit[4] picture "@E 999,999,999.99"
			@ prow(),085 PSAY _asit[5] picture "@E 999,999,999.99"
			@ prow(),103 PSAY _asit[6] picture "@E 999,999,999.99"
			@ prow(),118 PSAY _ntotsit picture "@E 999,999,999.99"
		endif
	end
	_ntotsit:=0
	for _i:=1 to 6
		_ntotsit+=_atotsit[_i]
	next
	_cheqdev := _acheqdev[6]+_acheqdev[5]+_acheqdev[4]+_acheqdev[3]+_acheqdev[2]+_acheqdev[1]
//	if _cheqdev>0 .AND. _cbanco == "VIT" 
//			@ prow()+1,000 PSAY "CHEQUE DEVOLVIDO"
//			@ prow(),020   PSAY _acheqdev[3] picture "@E 999,999,999.99"
//			@ prow(),036   PSAY _acheqdev[2] picture "@E 999,999,999.99"
//			@ prow(),054   PSAY _acheqdev[1] picture "@E 999,999,999.99"
//			@ prow(),069   PSAY _acheqdev[4] picture "@E 999,999,999.99"
//			@ prow(),085   PSAY _acheqdev[5] picture "@E 999,999,999.99"
//			@ prow(),103   PSAY _acheqdev[6] picture "@E 999,999,999.99"
//			@ prow(),118   PSAY _cheqdev     picture "@E 999,999,999.99"
//			_ntotsit+= _cheqdev
//	endif
	if ! _cbanco$"CHE/   "
		@ prow()+1,000 PSAY "TOTAL"
		@ prow(),020 PSAY _atotsit[3] picture "@E 999,999,999.99"
		@ prow(),036 PSAY _atotsit[2] picture "@E 999,999,999.99"
		@ prow(),054 PSAY _atotsit[1] picture "@E 999,999,999.99"
		@ prow(),069 PSAY _atotsit[4] picture "@E 999,999,999.99"
		@ prow(),085 PSAY _atotsit[5] picture "@E 999,999,999.99"
		@ prow(),103 PSAY _atotsit[6] picture "@E 999,999,999.99"
		@ prow(),118 PSAY _ntotsit picture "@E 999,999,999.99"
	endif
end
   
if prow()>0 .and.;
	lcontinua
	@ prow()+1,000 PSAY replicate("-",limite)
	if prow()>75
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY padc("R E S U M O   G E R A L",132)
	_aordem:={1,4,2,3,5,6,7}
	for _i:=1 to 7
		_k:=_aordem[_i]
		_ntotsit:=0                 
		for _j:=1 to 6
			_ntotsit+=_asitger[_k,_j]
   	next
		if _ntotsit>0
			if prow()>75
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			if _k==1
				_ntot:=0
				for _c:=1 to 6
					_ntot+=_agnr[_c]
				next
				if _ntot>0
					@ prow()+1,000 PSAY "GNR"
					@ prow(),020   PSAY _agnr[3] picture "@E 999,999,999.99"
					@ prow(),036   PSAY _agnr[2] picture "@E 999,999,999.99"
					@ prow(),054   PSAY _agnr[1] picture "@E 999,999,999.99"
					@ prow(),069   PSAY _agnr[4] picture "@E 999,999,999.99"
					@ prow(),085   PSAY _agnr[5] picture "@E 999,999,999.99"
					@ prow(),103   PSAY _agnr[6] picture "@E 999,999,999.99"
					@ prow(),118   PSAY _ntot    picture "@E 999,999,999.99"
				endif
				_ntot:=0
				for _c:=1 to 6
					_ntot+=_aavista[_c]
				next
				if _ntot>0
					@ prow()+1,000 PSAY "A VISTA"
					@ prow(),020   PSAY _aavista[3] picture "@E 999,999,999.99"
					@ prow(),036   PSAY _aavista[2] picture "@E 999,999,999.99"
					@ prow(),054   PSAY _aavista[1] picture "@E 999,999,999.99"
					@ prow(),069   PSAY _aavista[4] picture "@E 999,999,999.99"
					@ prow(),085   PSAY _aavista[5] picture "@E 999,999,999.99"
					@ prow(),103   PSAY _aavista[6] picture "@E 999,999,999.99"
					@ prow(),118   PSAY _ntot       picture "@E 999,999,999.99"
				endif
				_ntot:=0
				for _c:=1 to 6
					_ntot+=_aparcial[_c]
				next
				if _ntot>0
					@ prow()+1,000 PSAY "PAGTO. PARCIAL"
					@ prow(),020   PSAY _aparcial[3] picture "@E 999,999,999.99"
					@ prow(),036   PSAY _aparcial[2] picture "@E 999,999,999.99"
					@ prow(),054   PSAY _aparcial[1] picture "@E 999,999,999.99"
					@ prow(),069   PSAY _aparcial[4] picture "@E 999,999,999.99"
					@ prow(),085   PSAY _aparcial[5] picture "@E 999,999,999.99"
					@ prow(),103   PSAY _aparcial[6] picture "@E 999,999,999.99"
					@ prow(),118   PSAY _ntot        picture "@E 999,999,999.99"
				endif
				_ntot:=0
				for _c:=1 to 6
					_ntot+=_acarteira[_c]
				next
				if _ntot>0
					@ prow()+1,000 PSAY "CARTEIRA"
					@ prow(),020   PSAY _acarteira[3] picture "@E 999,999,999.99"
					@ prow(),036   PSAY _acarteira[2] picture "@E 999,999,999.99"
					@ prow(),054   PSAY _acarteira[1] picture "@E 999,999,999.99"
					@ prow(),069   PSAY _acarteira[4] picture "@E 999,999,999.99"
					@ prow(),085   PSAY _acarteira[5] picture "@E 999,999,999.99"
					@ prow(),103   PSAY _acarteira[6] picture "@E 999,999,999.99"
					@ prow(),118   PSAY _ntot         picture "@E 999,999,999.99"
				endif
			elseif _k==4
				_ntot:=0
				for _c:=1 to 6
					_ntot+=_acheqdev[_c]
				next
				if _ntot>0
					@ prow()+1,000 PSAY "CHEQUE DEVOLVIDO"
					@ prow(),020   PSAY _acheqdev[3] picture "@E 999,999,999.99"
					@ prow(),036   PSAY _acheqdev[2] picture "@E 999,999,999.99"
					@ prow(),054   PSAY _acheqdev[1] picture "@E 999,999,999.99"
					@ prow(),069   PSAY _acheqdev[4] picture "@E 999,999,999.99"
					@ prow(),085   PSAY _acheqdev[5] picture "@E 999,999,999.99"
					@ prow(),103   PSAY _acheqdev[6] picture "@E 999,999,999.99"
					@ prow(),118   PSAY _ntot         picture "@E 999,999,999.99"
				endif
				_ntot:=0
				for _c:=1 to 6
					_ntot+=_acheque[_c]
				next
				if _ntot>0
					@ prow()+1,000 PSAY "CHEQUE "
					@ prow(),020   PSAY _acheque[3] picture "@E 999,999,999.99"
					@ prow(),036   PSAY _acheque[2] picture "@E 999,999,999.99"
					@ prow(),054   PSAY _acheque[1] picture "@E 999,999,999.99"
					@ prow(),069   PSAY _acheque[4] picture "@E 999,999,999.99"
					@ prow(),085   PSAY _acheque[5] picture "@E 999,999,999.99"
					@ prow(),103   PSAY _acheque[6] picture "@E 999,999,999.99"
					@ prow(),118   PSAY _ntot         picture "@E 999,999,999.99"
				endif				
			else	
				@ prow()+1,000 PSAY left(tabela("07",strzero(_k-1,1)),16)
				@ prow(),020   PSAY _asitger[_k,3] picture "@E 999,999,999.99"
				@ prow(),036   PSAY _asitger[_k,2] picture "@E 999,999,999.99"
				@ prow(),054   PSAY _asitger[_k,1] picture "@E 999,999,999.99"
				@ prow(),069   PSAY _asitger[_k,4] picture "@E 999,999,999.99"
				@ prow(),085   PSAY _asitger[_k,5] picture "@E 999,999,999.99"
				@ prow(),103   PSAY _asitger[_k,6] picture "@E 999,999,999.99"
				@ prow(),118   PSAY _ntotsit       picture "@E 999,999,999.99"
			endif
		endif
	next
	_ntotsit:=0
	for _i:=1 to 6
		_ntotsit+=_atotger[_i]
	next
	@ prow()+2,000 PSAY "TOTAL GERAL"
	@ prow(),020   PSAY _atotger[3] picture "@E 999,999,999.99"
	@ prow(),036   PSAY _atotger[2] picture "@E 999,999,999.99"
	@ prow(),054   PSAY _atotger[1] picture "@E 999,999,999.99"
	@ prow(),069   PSAY _atotger[4] picture "@E 999,999,999.99"
	@ prow(),085   PSAY _atotger[5] picture "@E 999,999,999.99"
	@ prow(),103   PSAY _atotger[6] picture "@E 999,999,999.99"
	@ prow(),118   PSAY _ntotsit    picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY "INADIMPLENCIA"
	@ prow(),028   PSAY (_atotger[3]/_ntotsit)*100 picture "@E 999.99%"
	@ prow(),044   PSAY (_atotger[2]/_ntotsit)*100 picture "@E 999.99%"
	@ prow(),062   PSAY (_atotger[1]/_ntotsit)*100 picture "@E 999.99%"
	@ prow(),126   PSAY ((_atotger[1]+_atotger[2]+_atotger[3])/_ntotsit)*100 picture "@E 999.99%"
	@ prow()+1,000 PSAY replicate("-",limite)
	if prow()>75
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	@ prow()+1,000 PSAY "SALDO ANTERIOR"
	@ prow(),118   PSAY (_ntotsit-_nvalfat-_nvalgnr)+_nvalbai picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY "FATURAMENTO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)
	@ prow(),118   PSAY _nvalfat picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY "GNR DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)
	@ prow(),118   PSAY _nvalgnr picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY "BAIXAS DE "+dtoc(mv_par03)+" A "+dtoc(mv_par04)
	@ prow(),118   PSAY _nvalbai picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY "SALDO ATUAL"
	@ prow(),118   PSAY _ntotsit picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY replicate("-",limite)
//   roda(cbcont,cbtxt)
endif

#IFNDEF TOP
	_cindtmp1+=tmp1->(ordbagext())
	tmp1->(dbclosearea())
	ferase(_carqtmp1+getdbextension())
	ferase(_cindtmp1)
#ELSE
	tmp1->(dbclosearea())
#ENDIF

set device to screen

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endif
ms_flush()
return

static function _geratmp()
#IFNDEF TOP
	procregua(se1->(lastrec()))
	se1->(dbseek(_cfilse1))
	while ! se1->(eof()) .and.;
			se1->e1_filial==_cfilse1
		incproc("Selecionando titulos...")
		if se1->e1_saldo>0 .and.;
			right(se1->e1_tipo,1)<>"-" .and.;
			se1->e1_tipo<>"PR "
			tmp1->(dbappend())
			tmp1->banco   :=se1->e1_portado
			tmp1->agencia :=se1->e1_agedep
			tmp1->conta   :=se1->e1_conta
			tmp1->situacao:=se1->e1_situaca
			tmp1->prefixo :=se1->e1_prefixo
			tmp1->numero  :=se1->e1_num
			tmp1->parcela :=se1->e1_parcela
			tmp1->tipo    :=se1->e1_tipo
		endif
		se1->(dbskip())
	end
	procregua(se1->(lastrec()))
	se1->(dbsetorder(6))
	se1->(dbseek(_cfilse1+dtos(mv_par01),.t.))
	while ! se1->(eof()) .and.;
			se1->e1_filial==_cfilse1 .and.;
			se1->e1_emissao<=mv_par02
		if se1->e1_origem=="MATA460 "
			incproc("Calculando faturamento...")
  			if se1->e1_parcela<>"R"
				_nvalfat+=se1->e1_valor
			else
				_nvalgnr+=se1->e1_valor
			endif
		endif
		se1->(dbskip())
	end
	se1->(dbsetorder(1))
	procregua(se5->(lastrec()))
	se5->(dbseek(_cfilse5+dtos(mv_par03),.t.))
	while ! se5->(eof()) .and.;
			se5->e5_filial==_cfilse5 .and.;
			se5->e5_data<=mv_par04
		incproc("Calculando baixas...")
		if se5->e5_recpag=="R" .and.;
			se5->e5_tipodoc$"VLV2"
			_nvalbai+=se5->e5_valor
		endif
		se5->(dbskip())
	end
#ELSE
	procregua(3)
	incproc("Selecionando titulos...")
	_cquery:=" SELECT"
	_cquery+=" E1_PORTADO BANCO,E1_AGEDEP AGENCIA,E1_CONTA CONTA,E1_SITUACA SITUACAO,"
	_cquery+=" E1_PREFIXO PREFIXO,E1_NUM NUMERO,E1_PARCELA PARCELA,E1_TIPO TIPO,E1_CLIENTE CLIENTE,E1_LOJA LOJA"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SE1")+" SE1"
	_cquery+=" WHERE"
	_cquery+="     SE1.D_E_L_E_T_<>'*'"
	_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
	_cquery+=" AND E1_SALDO>0"
	_cquery+=" AND SUBSTR(E1_TIPO,3,1)<>'-'"
	_cquery+=" AND E1_TIPO<>'PR '"
	_cquery+=" ORDER BY"
	_cquery+=" E1_PORTADO,E1_AGEDEP,E1_CONTA,E1_SITUACA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
	tcquery _cquery new alias "TMP1"
	incproc("Calculando faturamento...")
	_cquery:=" SELECT"
	_cquery+=" SUM(E1_VALOR) VALOR"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SE1")+" SE1"
	_cquery+=" WHERE"
	_cquery+="     SE1.D_E_L_E_T_<>'*'"
	_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
	_cquery+=" AND E1_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	_cquery+=" AND E1_ORIGEM='MATA460 '"
	_cquery+=" AND E1_PARCELA<>'R'"
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","VALOR","N",12,2)
	tmp2->(dbgotop())
	_nvalfat:=tmp2->valor
	tmp2->(dbclosearea())
	
	incproc("Calculando gnr....")
	_cquery:=" SELECT"
	_cquery+=" SUM(E1_VALOR) VALOR"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SE1")+" SE1"
	_cquery+=" WHERE"
	_cquery+="     SE1.D_E_L_E_T_<>'*'"
	_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
	_cquery+=" AND E1_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	_cquery+=" AND E1_ORIGEM='MATA460 '"
	_cquery+=" AND E1_PARCELA='R'"	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","VALOR","N",12,2)
	tmp2->(dbgotop())
	_nvalgnr:=tmp2->valor
	tmp2->(dbclosearea())

	incproc("Calculando baixas...")
	_cquery:=" SELECT"
	_cquery+=" SUM(E5_VALOR) VALOR"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SE5")+" SE5"
	_cquery+=" WHERE"
	_cquery+="     SE5.D_E_L_E_T_<>'*'"
	_cquery+=" AND E5_FILIAL='"+_cfilse5+"'"
	_cquery+=" AND E5_DATA BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
	_cquery+=" AND E5_RECPAG='R'"
	_cquery+=" AND E5_TIPODOC IN ('V2','VL')"
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","VALOR","N",12,2)
	
	tmp2->(dbgotop())
	_nvalbai:=tmp2->valor
	tmp2->(dbclosearea())
#ENDIF
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Faturamento de     ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Faturamento ate    ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Baixas de          ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Baixas ate         ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","Tipo Cliente       ?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,"1-Farma"        ,space(30),space(15),"2-Hospitalar"   ,space(30),space(15),"3-Ambos"        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
                                     V E N C I D A S                                  A   V E N C E R
Cobranca                Ate 5 dias De 06 a 15 dias Maior que 15 dias     Ate 5 dias De 06 a 15 dias Maior que 15 dias          Total
xxxxxxxxxxxxxxxxxxx 999.999.999,99  999.999.999,99    999.999.999,99 999.999.999,99  999.999.999,99    999.999.999,99 999.999.999,99
*/

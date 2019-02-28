/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT124   � Autor � Gardenia              � Data � 15/07/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Resumo da Folha de Pagamento                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/


/*
Variaveis utilizadas para parametros
mv_par01 Da Matricula
mv_par02 Ate a Matricula
mv_par03 Do Centro de Custo
mv_par04 Ate o Centro de custo
mv_par05 Encargos(%)
mv_par06 Refei��o
mv_par07 Vale transporte
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT124()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="RESUMO DA FOLHA DE PAGAMENTO "
cdesc1   :="Este programa ira emitir o resumo  de estoque de Produto /lote"
cdesc2   :=""
cdesc3   :=""
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT124"
wnrel    :="VIT124"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=200
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT124"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.t.)

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
_cfilsra:=xfilial("SRA")
_cfilsro:=xfilial("SRO")
_cfilsrj:=xfilial("SRJ")
_cfilsrd:=xfilial("SRD")
_cfilsi3:=xfilial("SI3")
_cfilsrx:=xfilial("SRX")
sra->(dbsetorder(1))
sro->(dbsetorder(1))
srj->(dbsetorder(1))
srd->(dbsetorder(2))
si3->(dbsetorder(1))
srx->(dbsetorder(2))

processa({|| _querys()})

cabec1:="    Fun��o                      Nome                                 Sal�rioBase  Adicionais  Sal�rio   Comiss�o  Sub-Total Encargos(1)   FGTS(2)  Sub-Total      Vale Tr.   Refei��o     Unimed     Total"
//Fun��o              Nome                                      Sal�rio     Assid.   Valor B.  Comiss�o Sub-Total  Encargos      FGTS Sub-Total  Vale Tr.  Refei��o     Unimed     Total
//XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99
cabec2:=''



setprc(0,0)

setregua(sra->(lastrec()))

tmp1->(dbgotop())
_totsal:=0
_totassid:=0
_totvalb:=0
_totcomis:=0
_tot1subtot:=0
_totenc:=0
_totfgts:=0
_tot2subtot:=0
_tottrans:=0
_totref:=0
_totunimed:=0
_tottotal:=0
_nseq:=0
_totsalb:=0
_totadic:=0

	_mdir := ""


	_dctotsalb:=0
	_dctotad  :=0
	_dctotsal:=0
	_dctotvalb:=0
	_dctotcomis:=0
	_dctot1subtot:=0
	_dctotenc:=0
	_dctotfgts:=0
	_dctot2subtot:=0
	_dctottrans:=0
	_dctotref:=0
	_dcunimed:=0
	_dctottotal:=0


while ! tmp1->(eof()) .and.;
	lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_codfunc  :=tmp1->codfunc
	_cc :=tmp1->cc           	
	si3->(dbseek(_cfilsi3+_cc))
	_cctotsal:=0
	_cctotvalb:=0
	_cctotcomis:=0
	_cctot1subtot:=0
	_cctotenc:=0
	_cctotfgts:=0
	_cctot2subtot:=0
	_cctottrans:=0
	_cctotref:=0
	_cctottotal:=0
	_ccunimed:=0
	_cctotsalb:=0
	_cctotad:=0
	
	if _mdir <> substr(_cc,1,2)

		if !empty(_dctotsal) 
			@ prow()+1,004 PSAY "TOTAL =====>"
			@ prow(),069 PSAY _dctotsalb picture "@E 999,999.99"
			@ prow(),080 PSAY _dctotad picture "@E 999,999.99"
			@ prow(),091 PSAY _dctotsal picture "@E 999,999.99"
			@ prow(),102 PSAY _dctotcomis picture "@E 999,999.99"
			@ prow(),113 PSAY _dctot1subtot picture "@E 999,999.99"
			@ prow(),124 PSAY _dctotenc picture "@E 999,999.99"
			@ prow(),135 PSAY _dctotfgts picture "@E 999,999.99"
			@ prow(),147 PSAY _dctot2subtot picture "@E 999,999.99"
			@ prow(),160 PSAY _dctottrans picture "@E 999,999.99"
			@ prow(),174 PSAY _dctotref picture "@E 999,999.99"
			@ prow(),185 PSAY _dcunimed picture "@E 999,999.99"
			@ prow(),196 PSAY _dctottotal picture "@E 999,999.99"
			@ prow()+1,000 PSAY " "
			_dctotsalb:=0
			_dctotad  :=0
			_dctotsal:=0
			_dctotvalb:=0
			_dctotcomis:=0
			_dctot1subtot:=0
			_dctotenc:=0
			_dctotfgts:=0
			_dctot2subtot:=0
			_dctottrans:=0
			_dctotref:=0
			_dcunimed:=0
			_dctottotal:=0             
		endif
		_mdir := substr(_cc,1,2)		
	endif
	
	
	while ! tmp1->(eof()) .and.;
		tmp1->cc==_cc .and.;
		lcontinua
		incregua()
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
		//XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99
		_sal1:=0
		_salb:=0
		
		srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"101"+"   "))
		_salb:=srd->rd_valor
		srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"710"+"   "))
		_sal1:=srd->rd_valor
		srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"115"+"   "))
		_sal1+=srd->rd_valor
		srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"298"+"   "))
		_sal1+=srd->rd_valor
		srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"107"+"   "))
		_sal1+=srd->rd_valor
		srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"113"+"   "))
		_sal1+=srd->rd_valor
		
		//		srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"714"+"   "))  // 13�
		//		_sal1+=srd->rd_valor
		
		srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"104"+"   "))
		_sal1-=srd->rd_valor
		_comis:=srd->rd_valor
		
		if _sal1<>0
			_nseq+=1
			@ prow()+1,000 PSAY _nseq  picture "999"
			@ prow(),004 PSAY substr(si3->i3_desc,1,25)
			@ prow(),031 PSAY substr(tmp1->nome,1,36)
			@ prow(),069 PSAY _salb picture "@E 999,999.99"
			@ prow(),080 PSAY _sal1-_salb picture "@E 999,999.99"
			@ prow(),091 PSAY _sal1 picture "@E 999,999.99"
			//			@ prow(),075 PSAY _assi1 picture "@E 999,999.99"
			//	@ prow(),086 PSAY tmp1->extra picture "@E 999,999.99"
			@ prow(),102 PSAY _comis picture "@E 999,999.99"
			_subtot1:=_sal1+tmp1->extra+_comis
			@ prow(),113 PSAY _subtot1 picture "@E 999,999.99"
			srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"706"+"   "))
			_encargos:=(srd->rd_valor)*(mv_par05/100)
			@ prow(),124 PSAY _encargos picture "@E 999,999.99"
			srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"711"+"   "))
			_fgts1:=srd->rd_valor
			srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"810"+"   "))
			_fgts2:=srd->rd_valor
			@ prow(),135 PSAY _fgts1+_fgts2  picture "@E 999,999.99"
			_subtot2:=_subtot1+_encargos +(_fgts1+_fgts2)
			@ prow(),147 PSAY _subtot2 picture "@E 999,999.99"
			srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"553"+"   "))
			_trans:=(srd->rd_horas*2*mv_par07)-srd->rd_valor
			@ prow(),160 PSAY _trans picture "@E 999,999.99"
			srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"552"+"   "))
			_ref:=srd->rd_valor/mv_par10
			_ref:=(_ref*mv_par06)-srd->rd_valor
			@ prow(),174 PSAY _ref picture "@E 999,999.99"
			srx->(dbseek("22"+"01"+strzero(val(tmp1->asmedic),2,0)))
			srd->(dbseek(_cfilsrd+_cc+tmp1->mat+mv_par08+"551"+"   "))
			//			_taxaunimed:=val(substr(srx->rx_txt,45,2)/100
			_valunimed:=val(substr(srx->rx_txt,27,6))
			_unimed:=_valunimed*(val(tmp1->dpassme)+1)
			//			msgstop(_valunimed)
			_unimed:=_unimed - srd->rd_valor
			if empty(tmp1->asmedic)
				_unimed:=0
			endif
			@ prow(),185 PSAY _unimed picture "@E 999,999.99"
			@ prow(),196 PSAY _subtot2+_trans+_ref+_unimed picture "@E 999,999.99"
			_totsalb+=_salb
			_totsal+=_sal1
			_totadic+=_sal1-_salb
			_totvalb+=tmp1->extra
			_totcomis+=_comis
			_tot1subtot+=_subtot1
			_totenc+=_encargos
			_totfgts+=_fgts1+_fgts2
			_tot2subtot+=_subtot2
			_tottrans+=_trans
			_totref+=_ref
			_totunimed+=_unimed
			_tottotal+=_subtot2+_trans+_ref+_unimed
			
			_cctotsalb+=_salb
			_cctotad  +=_sal1-_salb
			_cctotsal+=_sal1
			_cctotvalb+=tmp1->extra
			_cctotcomis+=_comis
			_cctot1subtot+=_subtot1
			_cctotenc+=_encargos
			_cctotfgts+=_fgts1+_fgts2
			_cctot2subtot+=_subtot2
			_cctottrans+=_trans
			_cctotref+=_ref
			_ccunimed+=_unimed
			_cctottotal+=_subtot2+_trans+_ref+_unimed
			
		endif
		_ccant:= substr(_cc,1,2)
		tmp1->(dbskip())
	end	
	if _cctotsal>0
		@ prow()+1,004 PSAY "TOTAL " +substr(si3->i3_desc,1,25)+ " =====>"
		@ prow(),069 PSAY _cctotsalb picture "@E 999,999.99"
		@ prow(),080 PSAY _cctotad picture "@E 999,999.99"
		@ prow(),091 PSAY _cctotsal picture "@E 999,999.99"
		@ prow(),102 PSAY _cctotcomis picture "@E 999,999.99"
		@ prow(),113 PSAY _cctot1subtot picture "@E 999,999.99"
		@ prow(),124 PSAY _cctotenc picture "@E 999,999.99"
		@ prow(),135 PSAY _cctotfgts picture "@E 999,999.99"
		@ prow(),147 PSAY _cctot2subtot picture "@E 999,999.99"
		@ prow(),160 PSAY _cctottrans picture "@E 999,999.99"
		@ prow(),174 PSAY _cctotref picture "@E 999,999.99"
		@ prow(),185 PSAY _ccunimed picture "@E 999,999.99"
		@ prow(),196 PSAY _cctottotal picture "@E 999,999.99"
		@ prow()+1,000 PSAY " "
		_dctotsalb+=_cctotsalb
		_dctotad  +=_cctotad
		_dctotsal+=_cctotsal
		_dctotvalb+=_cctotvalb
		_dctotcomis+=_cctotcomis
		_dctot1subtot+=_cctot1subtot
		_dctotenc+=_cctotenc
		_dctotfgts+=_cctotfgts
		_dctot2subtot+=_cctot2subtot
		_dctottrans+=_cctottrans
		_dctotref+=_cctotref
		_dcunimed+=_ccunimed
		_dctottotal+=_cctottotal
	endif             
end
if prow()>53
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
endif

if lcontinua .and. _totsal>0
	@ prow()+1,004 PSAY "Totais =======>"
	
	
	@ prow(),069 PSAY _totsalb picture "@E 999,999.99"
	@ prow(),080 PSAY _totadic picture "@E 999,999.99"
	@ prow(),091 PSAY _totsal picture "@E 999,999.99"
	// prow(),075 PSAY _totassid picture "@E 999,999.99"
	//	@ prow(),086 PSAY _totvalb picture "@E 999,999.99"
	@ prow(),102 PSAY _totcomis picture "@E 999,999.99"
	@ prow(),113 PSAY _tot1subtot picture "@E 999,999.99"
	@ prow(),124 PSAY _totenc picture "@E 999,999.99"
	@ prow(),135 PSAY _totfgts picture "@E 999,999.99"
	@ prow(),147 PSAY _tot2subtot picture "@E 999,999.99"
	@ prow(),160 PSAY _tottrans picture "@E 999,999.99"
	@ prow(),174 PSAY _totref picture "@E 999,999.99"
	@ prow(),185 PSAY _totunimed picture "@E 999,999.99"
	@ prow(),196 PSAY _tottotal picture "@E 999,999.99"
	
	@ prow()+1,004 PSAY "Totais (%)====>"
	@ prow(),080 PSAY _totsal/_tottotal*100 picture "@E 999,999.99"
	//	@ prow(),086 PSAY _totvalb/_tottotal*100 picture "@E 999,999.99"
	@ prow(),097 PSAY _totcomis/_tottotal*100 picture "@E 999,999.99"
	@ prow(),108 PSAY _tot1subtot/_tottotal*100 picture "@E 999,999.99"
	@ prow(),119 PSAY _totenc/_tottotal*100 picture "@E 999,999.99"
	@ prow(),130 PSAY _totfgts/_tottotal*100 picture "@E 999,999.99"
	@ prow(),141 PSAY _tot2subtot/_tottotal*100 picture "@E 999,999.99"
	@ prow(),153 PSAY _tottrans/_tottotal*100 picture "@E 999,999.99"
	@ prow(),164 PSAY _totref/_tottotal*100 picture "@E 999,999.99"
	@ prow(),175 PSAY _totunimed/_tottotal*100 picture "@E 999,999.99"
	@ prow(),186 PSAY _tottotal/_tottotal*100 picture "@E 999,999.99"
endif
if prow()>53
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
endif

/*
@ prow()+1,000 PSAY replicate("=",197)
sra->(dbseek(_cfilsra+'000001'))
@ prow()+1,004 PSAY "PROPRIET�RIO"
@ prow(),035 PSAY substr(sra->ra_nome,1,36)
@ prow(),080 PSAY sra->ra_salario picture "@E 999,999.99"
_subtot1:=sra->ra_salario
_totpro:=sra->ra_salario
@ prow(),108 PSAY _subtot1 picture "@E 999,999.99"
_encargos:=sra->ra_salario*(20/100)
_totproenc:=sra->ra_salario*(20/100)
@ prow(),119 PSAY _encargos picture "@E 999,999.99"
_subtot2:=_subtot1+_encargos
@ prow(),141 PSAY _subtot2 picture "@E 999,999.99"
@ prow(),186 PSAY _subtot2 picture "@E 999,999.99"

sra->(dbseek(_cfilsra+'000002'))
@ prow()+1,004 PSAY "PROPRIET�RIO"
@ prow(),035 PSAY substr(sra->ra_nome,1,40)
@ prow(),080 PSAY sra->ra_salario picture "@E 999,999.99"
_subtot1:=sra->ra_salario
_totpro:=_totpro+sra->ra_salario
@ prow(),108 PSAY _subtot1 picture "@E 999,999.99"
_encargos:=sra->ra_salario*(20/100)
_totproenc:=_totproenc+(sra->ra_salario*(20/100))
@ prow(),119 PSAY _encargos picture "@E 999,999.99"
_subtot2:=_subtot1+_encargos
@ prow(),141 PSAY _subtot2 picture "@E 999,999.99"
@ prow(),186 PSAY _subtot2 picture "@E 999,999.99"

*/
_subtot1:=0 
_totpro:=0    
_encargos:=0
_totproenc:=0
_subtot2:=0

if mv_par11==1
	sra->(dbseek(_cfilsra+'000003'))
	@ prow()+1,004 PSAY "PROPRIET�RIO"
	@ prow(),035 PSAY substr(sra->ra_nome,1,40)
	@ prow(),069 PSAY sra->ra_salario picture "@E 999,999.99"
	@ prow(),091 PSAY sra->ra_salario picture "@E 999,999.99"
	_subtot1:=sra->ra_salario
	_totpro:=sra->ra_salario
	@ prow(),113 PSAY _subtot1 picture "@E 999,999.99"
	_encargos:=sra->ra_salario*(20/100)
	_totproenc:=sra->ra_salario*(20/100)
	@ prow(),124 PSAY _encargos picture "@E 999,999.99"
	_subtot2:=_subtot1+_encargos
	@ prow(),147 PSAY _subtot2 picture "@E 999,999.99"
	@ prow(),196 PSAY _subtot2 picture "@E 999,999.99"

	sra->(dbseek(_cfilsra+'000005'))
	@ prow()+1,004 PSAY "PROPRIET�RIO"
	@ prow(),035 PSAY substr(sra->ra_nome,1,40)
	@ prow(),069 PSAY sra->ra_salario picture "@E 999,999.99"
	@ prow(),091 PSAY sra->ra_salario picture "@E 999,999.99"
	_subtot1:=sra->ra_salario
	_totpro:=_totpro+sra->ra_salario
	@ prow(),113 PSAY _subtot1 picture "@E 999,999.99"
	_encargos:=sra->ra_salario*(20/100)
	_totproenc:=_totproenc+(sra->ra_salario*(20/100))
	@ prow(),124 PSAY _encargos picture "@E 999,999.99"
	_subtot2:=_subtot1+_encargos
	@ prow(),147 PSAY _subtot2 picture "@E 999,999.99"
	@ prow(),196 PSAY _subtot2 picture "@E 999,999.99"
	
endif


@ prow()+1,004 PSAY "ESTAGIARIOS/SERV. TERCEIROS"
@ prow(),069 PSAY mv_par09 picture "@E 999,999.99"
@ prow(),091 PSAY mv_par09 picture "@E 999,999.99"
@ prow(),196 PSAY mv_par09 picture "@E 999,999.99"
@ prow()+1,004 PSAY "Total =======>"

//@ prow(),069 PSAY _totpro+mv_par09 picture "@E 999,999.99"
//@ prow(),091 PSAY _totpro+mv_par09 picture "@E 999,999.99"



if prow()>53
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
endif

@ prow()+2,004 PSAY "Totais =======>"
@ prow(),069 PSAY _totsalb+_totpro+mv_par09 picture "@E 999,999.99"
@ prow(),080 PSAY _totadic picture "@E 999,999.99"
@ prow(),091 PSAY _totsal+_totpro+mv_par09 picture "@E 999,999.99"
//prow(),075 PSAY _totassid picture "@E 999,999.99"
//@ prow(),086 PSAY _totvalb picture "@E 999,999.99"
@ prow(),102 PSAY _totcomis picture "@E 999,999.99"
@ prow(),113 PSAY _tot1subtot+_totpro picture "@E 999,999.99"
@ prow(),124 PSAY _totenc+_totproenc picture "@E 999,999.99"
@ prow(),135 PSAY _totfgts picture "@E 999,999.99"
@ prow(),147 PSAY _tot2subtot+_totpro+_totproenc picture "@E 999,999.99"
@ prow(),160 PSAY _tottrans picture "@E 999,999.99"
@ prow(),174 PSAY _totref picture "@E 999,999.99"
@ prow(),185 PSAY _totunimed picture "@E 999,999.99"
@ prow(),196 PSAY _tottotal+_totpro+_totproenc+mv_par09 picture "@E 999,999.99"

@ prow()+1,004 PSAY "Totais (%)====>"
@ prow(),091 PSAY (_totsal+_totpro+mv_par09)/(_tottotal+_totpro+mv_par09)*100 picture "@E 999,999.99"
//@ prow(),075 PSAY _totassid/(_tottotal+_totpro)*100 picture "@E 999,999.99"
//@ prow(),086 PSAY _totvalb/(_tottotal+_totpro)*100 picture "@E 999,999.99"
@ prow(),102 PSAY _totcomis/(_tottotal+_totpro)*100 picture "@E 999,999.99"
@ prow(),113 PSAY (_tot1subtot+_totpro)/(_tottotal+_totpro)*100 picture "@E 999,999.99"
@ prow(),124 PSAY (_totenc+_totproenc)/(_tottotal+_totpro+_totproenc)*100 picture "@E 999,999.99"
@ prow(),135 PSAY _totfgts/(_tottotal+_totpro+_totproenc)*100 picture "@E 999,999.99"
@ prow(),147 PSAY (_tot2subtot+_totpro+_totproenc)/(_tottotal+_totpro+_totproenc)*100 picture "@E 999,999.99"
@ prow(),160 PSAY _tottrans/(_tottotal+_totpro+_totproenc)*100 picture "@E 999,999.99"
@ prow(),174 PSAY _totref/(_tottotal+_totpro+_totproenc)*100 picture "@E 999,999.99"
@ prow(),185 PSAY _totunimed/(_tottotal+_totpro+_totproenc)*100 picture "@E 999,999.99"
@ prow(),196 PSAY (_tottotal+_totpro+_totproenc+mv_par09)/(_tottotal+_totpro+_totproenc+mv_par09)*100 picture "@E 999,999.99"



@ prow()+2,004 PSAY "(1) INSS(20%) + SAT(2%) + TERCEIROS(5,8%)"
@ prow()+1,004 PSAY "OBS.: TERCEIROS = SAL.ED.(2,5) + INCRA(0,2) + SENAI(1,5) + SEBRAE(0,6)"
@ prow()+1,004 PSAY "FGTS(8.5%)"


@ prow()+1,000 PSAY replicate("=",197)



if prow()>0 .and.;
	lcontinua
	//   roda(cbcont,cbtxt)
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

//FILTRO DO RELATORIO
_filtro := aReturn[7]
_filtro := STRTRAN (_filtro,".And."," And " )
_filtro := STRTRAN (_filtro,".and."," And " )
_filtro := STRTRAN (_filtro,".Or."," Or ")
_filtro := STRTRAN (_filtro,".or."," Or ")
_filtro := STRTRAN (_filtro,"=="," = ")
_filtro := STRTRAN (_filtro,'"',"'")
_filtro := STRTRAN (_filtro,'Alltrim',"LTRIM")
_filtro := STRTRAN (_filtro,'$',"Like")

//Monta a Query de acordo com os parametros
_cquery:=" SELECT"
_cquery+=" RA_MAT MAT,RA_NOME NOME,RA_SALARIO SALARIO,RA_CODFUNC CODFUNC,RA_CC CC,"
_cquery+=" RA_EXTRA EXTRA,RA_DPASSME DPASSME, RA_ASMEDIC ASMEDIC,RA_COMIS COMIS"
_cquery+=" FROM "
_cquery+=  retsqlname("SRA")+" SRA,"
_cquery+=" WHERE"
_cquery+="     SRA.D_E_L_E_T_<>'*'"
_cquery+=" AND RA_FILIAL='"+_cfilsra+"'"
_cquery+=" AND RA_MAT  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND RA_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"

// Considera filtro se n�o estiver vazio
If !Empty(_filtro)
     _cquery+= " AND ("+_filtro+")"
EndIf

_cquery+=" ORDER BY RA_CC,RA_NOME"


_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","SALARIO"  ,"N",15,3)
tcsetfield("TMP1","EXTRA"  ,"N",15,3)
tcsetfield("TMP1","COMIS"  ,"N",15,3)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da Matricula       ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"02","Ate a matricula    ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"03","Do Centro de Custo ?","mv_ch3","C",09,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
aadd(_agrpsx1,{cperg,"04","Ate Centro de Custo?","mv_ch4","C",09,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
aadd(_agrpsx1,{cperg,"05","Encargos (%)       ?","mv_ch5","N",05,2,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Vl.Refeicao Empresa?","mv_ch6","N",12,2,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Vale Transporte    ?","mv_ch7","N",12,2,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ano/mes            ?","mv_ch8","C",06,2,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Serv. Terceiros    ?","mv_ch9","N",12,2,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Vl.Refeicao func.  ?","mv_chA","N",15,2,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Imprime Pro-Labore ?","mv_chB","N",01,0,0,"C",space(60),"mv_par11"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
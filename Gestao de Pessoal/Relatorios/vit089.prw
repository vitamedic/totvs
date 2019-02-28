/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT089   ³ Autor ³ Gardenia              ³ Data ³ 15/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo da Folha de Pagamento                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


/*
Variaveis utilizadas para parametros
mv_par01 Da Matricula 
mv_par02 Ate a Matricula
mv_par03 Do Centro de Custo 
mv_par04 Ate o Centro de custo
mv_par05 Encargos(%)        
mv_par06 Refeição           
mv_par07 Vale transporte        
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT089()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="RESUMO DA FOLHA DE PAGAMENTO "
cdesc1   :="Este programa ira emitir o resumo  de estoque de Produto /lote"
cdesc2   :=""
cdesc3   :=""
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT089"
wnrel    :="VIT089"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=200
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT089"
_pergsx1()
pergunte(cperg,.f.)

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
_cfilsra:=xfilial("SRA")
_cfilsro:=xfilial("SRO")
_cfilsrj:=xfilial("SRJ")
sra->(dbsetorder(1))
sro->(dbsetorder(1))
srj->(dbsetorder(1))

processa({|| _querys()})

cabec1:="Função              Nome                                           Salário     Assid.    Valor B   Comissão  Sub-Total Encargos(1)   FGTS(2)  Sub-Total   Vale Tr.   Refeição      Total"
//Função              Nome                                      Salário     Assid.   Valor B  Comissão Sub-Total  Encargos      FGTS Sub-Total  Vale Tr.  Refeição     Total
//XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99 99,999.99
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
_tottotal:=0
_nseq:=0
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_codfunc  :=tmp1->codfunc      
	srj->(dbseek(_cfilsrj+_codfunc))
	
	while ! tmp1->(eof()) .and.;
		tmp1->codfunc==_codfunc .and.;
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
		_nseq+=1
		@ prow()+1,000 PSAY _nseq picture "999"
   	@ prow(),004 PSAY substr(srj->rj_desc,1,20)
		@ prow(),025 PSAY substr(tmp1->nome,1,36)
		@ prow(),064 PSAY tmp1->salario picture "@E 999,999.99"
		_assid:= tmp1->salario*0.07
		@ prow(),075 PSAY tmp1->salario*0.07 picture "@E 999,999.99"
		@ prow(),086 PSAY tmp1->extra picture "@E 999,999.99"
		@ prow(),097 PSAY tmp1->comis picture "@E 999,999.99"
		_subtot1:=tmp1->salario+_assid+tmp1->extra+tmp1->comis
		@ prow(),108 PSAY _subtot1 picture "@E 999,999.99"
		_encargos:=tmp1->(salario+_assid)*(mv_par05/100)
		@ prow(),119 PSAY _encargos picture "@E 999,999.99"
		_fgts:=tmp1->(salario+_assid)*0.085
		@ prow(),130 PSAY _fgts  picture "@E 999,999.99"
		_subtot2:=_subtot1+_encargos +_fgts 
		@ prow(),141 PSAY _subtot2 picture "@E 999,999.99"
		_trans:=mv_par07-(tmp1->salario*0.06)
		if _trans <0
		  _trans :=0
		endif  
		@ prow(),153 PSAY _trans picture "@E 999,999.99"
		@ prow(),164 PSAY mv_par06 picture "@E 999,999.99"
		@ prow(),175 PSAY _subtot2+_trans+mv_par07 picture "@E 999,999.99" 
		_totsal+=tmp1->salario
		_totassid+=_assid
		_totvalb+=tmp1->extra
		_totcomis+=tmp1->comis
		_tot1subtot+=_subtot1
		_totenc+=_encargos
		_totfgts+=_fgts      
		_tot2subtot+=_subtot2
		_tottrans+=_trans
		_totref+=mv_par06
		_tottotal+=_subtot2+_trans+mv_par07
		tmp1->(dbskip())
	end
end
if prow()>53
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
endif

if lcontinua
	@ prow()+1,000 PSAY "Totais =======>"
	@ prow(),064 PSAY _totsal picture "@E 999,999.99"
	@ prow(),075 PSAY _totassid picture "@E 999,999.99"
	@ prow(),086 PSAY _totvalb picture "@E 999,999.99"
	@ prow(),097 PSAY _totcomis picture "@E 999,999.99"
	@ prow(),108 PSAY _tot1subtot picture "@E 999,999.99"
	@ prow(),119 PSAY _totenc picture "@E 999,999.99"
	@ prow(),130 PSAY _totfgts picture "@E 999,999.99"
	@ prow(),141 PSAY _tot2subtot picture "@E 999,999.99"
	@ prow(),153 PSAY _tottrans picture "@E 999,999.99"
	@ prow(),164 PSAY _totref picture "@E 999,999.99"
	@ prow(),175 PSAY _tottotal picture "@E 999,999.99"

	@ prow()+1,000 PSAY "Totais (%)====>"
	@ prow(),064 PSAY _totsal/_tottotal*100 picture "@E 999,999.99"
	@ prow(),075 PSAY _totassid/_tottotal*100 picture "@E 999,999.99"
	@ prow(),086 PSAY _totvalb/_tottotal*100 picture "@E 999,999.99"
	@ prow(),097 PSAY _totcomis/_tottotal*100 picture "@E 999,999.99"
	@ prow(),108 PSAY _tot1subtot/_tottotal*100 picture "@E 999,999.99"
	@ prow(),119 PSAY _totenc/_tottotal*100 picture "@E 999,999.99"
	@ prow(),130 PSAY _totfgts/_tottotal*100 picture "@E 999,999.99"
	@ prow(),141 PSAY _tot2subtot/_tottotal*100 picture "@E 999,999.99"
	@ prow(),153 PSAY _tottrans/_tottotal*100 picture "@E 999,999.99"
	@ prow(),164 PSAY _totref/_tottotal*100 picture "@E 999,999.99"
	@ prow(),175 PSAY _tottotal/_tottotal*100 picture "@E 999,999.99"
endif
if prow()>53
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
endif

@ prow()+1,000 PSAY replicate("=",186)
sra->(dbseek(_cfilsra+'000003'))
@ prow()+1,000 PSAY "PROPRIETÁRIO"
@ prow(),022 PSAY substr(sra->ra_nome,1,40)
@ prow(),064 PSAY sra->ra_salario picture "@E 999,999.99"
_subtot1:=sra->ra_salario
_totpro:=sra->ra_salario
@ prow(),108 PSAY _subtot1 picture "@E 999,999.99"
_encargos:=sra->ra_salario*(mv_par05/100)
_totproenc:=sra->ra_salario*(mv_par05/100)
@ prow(),119 PSAY _encargos picture "@E 999,999.99"
_subtot2:=_subtot1+_encargos  
@ prow(),141 PSAY _subtot2 picture "@E 999,999.99"
@ prow(),175 PSAY _subtot2 picture "@E 999,999.99" 

sra->(dbseek(_cfilsra+'000005'))
@ prow()+1,000 PSAY "PROPRIETÁRIO"
@ prow(),022 PSAY substr(sra->ra_nome,1,40)
@ prow(),064 PSAY sra->ra_salario picture "@E 999,999.99"
_subtot1:=sra->ra_salario
_totpro:=_totpro+sra->ra_salario
@ prow(),108 PSAY _subtot1 picture "@E 999,999.99"
_encargos:=sra->ra_salario*(mv_par05/100)
_totproenc:=_totproenc+(sra->ra_salario*(mv_par05/100))
@ prow(),119 PSAY _encargos picture "@E 999,999.99"
_subtot2:=_subtot1+_encargos  
@ prow(),141 PSAY _subtot2 picture "@E 999,999.99"
@ prow(),175 PSAY _subtot2 picture "@E 999,999.99" 


@ prow()+1,000 PSAY "ESTAGIARIOS/SERV. TERCEIROS"
@ prow(),064 PSAY mv_par09 picture "@E 999,999.99"
@ prow(),175 PSAY mv_par09 picture "@E 999,999.99" 



if prow()>53
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
endif

@ prow()+2,000 PSAY "Totais =======>"
@ prow(),064 PSAY _totsal+_totpro+mv_par09 picture "@E 999,999.99"
@ prow(),075 PSAY _totassid picture "@E 999,999.99"
@ prow(),086 PSAY _totvalb picture "@E 999,999.99"
@ prow(),097 PSAY _totcomis picture "@E 999,999.99"
@ prow(),108 PSAY _tot1subtot+_totpro picture "@E 999,999.99"
@ prow(),119 PSAY _totenc+_totproenc picture "@E 999,999.99"
@ prow(),130 PSAY _totfgts picture "@E 999,999.99"
@ prow(),141 PSAY _tot2subtot+_totpro+_totproenc picture "@E 999,999.99"
@ prow(),153 PSAY _tottrans picture "@E 999,999.99"
@ prow(),164 PSAY _totref picture "@E 999,999.99"
@ prow(),175 PSAY _tottotal+_totpro+_totproenc+mv_par09 picture "@E 999,999.99"

@ prow()+1,000 PSAY "Totais (%)====>"
@ prow(),064 PSAY (_totsal+_totpro+mv_par09)/(_tottotal+_totpro+mv_par09)*100 picture "@E 999,999.99"
@ prow(),075 PSAY _totassid/(_tottotal+_totpro)*100 picture "@E 999,999.99"
@ prow(),086 PSAY _totvalb/(_tottotal+_totpro)*100 picture "@E 999,999.99"
@ prow(),097 PSAY _totcomis/(_tottotal+_totpro)*100 picture "@E 999,999.99"
@ prow(),108 PSAY (_tot1subtot+_totpro)/(_tottotal+_totpro)*100 picture "@E 999,999.99"
@ prow(),119 PSAY (_totenc+_totproenc)/(_tottotal+_totpro+_totproenc)*100 picture "@E 999,999.99"
@ prow(),130 PSAY _totfgts/(_tottotal+_totpro+_totproenc)*100 picture "@E 999,999.99"
@ prow(),141 PSAY (_tot2subtot+_totpro+_totproenc)/(_tottotal+_totpro+_totproenc)*100 picture "@E 999,999.99"
@ prow(),153 PSAY _tottrans/(_tottotal+_totpro+_totproenc)*100 picture "@E 999,999.99"
@ prow(),164 PSAY _totref/(_tottotal+_totpro+_totproenc)*100 picture "@E 999,999.99"
@ prow(),175 PSAY (_tottotal+_totpro+_totproenc+mv_par09)/(_tottotal+_totpro+_totproenc+mv_par09)*100 picture "@E 999,999.99"



@ prow()+2,000 PSAY "(1) INSS(20%) + SAT(2%) + TERCEIROS(5,8%)"
@ prow()+1,000 PSAY "OBS.: TERCEIROS = SAL.ED.(2,5) + INCRA(0,2) + SENAI(1,5) + SEBRAE(0,6)"
@ prow()+1,000 PSAY "FGTS(8.5%)"


@ prow()+1,000 PSAY replicate("=",186)



if prow()>0 .and.;
	lcontinua
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

static function _querys()
_cquery:=" SELECT"
_cquery+=" RA_MAT MAT,RA_NOME NOME,RA_SALARIO SALARIO,RA_CODFUNC CODFUNC,"
_cquery+=" RA_EXTRA EXTRA,RA_COMIS COMIS"
_cquery+=" FROM "
_cquery+=  retsqlname("SRA")+" SRA,"
_cquery+=" WHERE"
_cquery+="     SRA.D_E_L_E_T_<>'*'"
_cquery+=" AND RA_FILIAL='"+_cfilsra+"'"
_cquery+=" AND RA_MAT  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND RA_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND RA_ADMISSA < '"+dtos(mv_par08)+"'"
_cquery+=" AND RA_SITFOLH <> 'D'"
_cquery+=" ORDER BY RA_CODFUNC,RA_NOME"


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
aadd(_agrpsx1,{cperg,"05","Encargos (%)       ?","mv_ch5","C",05,2,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Refeição           ?","mv_ch6","C",12,2,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Vale Transporte    ?","mv_ch7","C",12,2,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
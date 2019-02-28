/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT209  ³ Autor ³ Aline                 ³ Data ³ 26/08/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Ativo                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit209()
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="Relacao Ativo  "
cdesc1   :="Este programa ira emitir o relatorio de Ativo"
cdesc2   :=""
cdesc3   :=""
cstring  :="SN3"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT209"
wnrel    :="VIT209"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT209"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

if nlastkey==27
   set filter to
   return
endif

setdefault(areturn,cstring)

ntipo:=18

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
_cfilsn3:=xfilial("SN3")
_cfilsm2:=xfilial("SM2")
_cfilsn1:=xfilial("SN1")

sm2->(dbsetorder(1))    
ctt->(dbsetorder(1))
ct1->(dbsetorder(1))
sn3->(dbsetorder(1))


cabec1:="     Relacao de Ativo Fixo com Aquisição entre "+dtoc(mv_par07)+" a  "+dtoc(mv_par08)+"   e Depreciação "+dtoc(mv_par09)+" a  "+dtoc(mv_par10)
cabec2:="Cod.Bem     Item     Historico                                 Val.Original   Val.Depreciado Val.Residual               Aquisicao Inic.Deprec.  C.Custo    Plaqueta"

setregua(1)
incregua()
setprc(0,0)


processa({|| _geratmp()})    
_ntot := 0
_ntotd := 0
_nvalord := 0
_ntotr := 0
_nvalorr := 0
_nvalor := 0
_mconta := space(15)
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	incregua()
  if prow()==0 .or. prow()>50 
    cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
  endif             
	sn3->(dbseek(_cfilsn3+tmp1->produto+tmp1->item))
  if  tmp1->conta<> _mconta         
     _mconta := tmp1->conta
     if !empty(_nvalor)
			@ prow()+1,000 psay "TOTAL DA CONTA"
			@ prow()  ,061 psay TRANSFORM(_nvalor, "@E 999,999,999.99")
			@ prow()  ,077 psay TRANSFORM(_nvalord, "@E 999,999,999.99")		
			@ prow()  ,092 psay TRANSFORM(_nvalorr, "@E 999,999,999.99")			
			_nvalor :=0
			_nvalord :=0
  			_nvalorr :=0
     endif
	  @ prow()+2,000 psay tmp1->conta
  endif                                                   
  @ prow()+1,000 psay tmp1->produto 
  @ prow()  ,012 psay tmp1->item 
  @ prow()  ,020 psay tmp1->histor                                                   
  @ prow()  ,061 psay TRANSFORM(tmp1->valor, "@E 999,999,999.99")
  @ prow()  ,077 psay TRANSFORM(tmp1->vldep, "@E 999,999,999.99")
  @ prow()  ,092 psay TRANSFORM(tmp1->valor-tmp1->vldep, "@E 999,999,999.99")
//  @ prow()  ,100 psay tmp1->conta                                                   
  @ prow()  ,122 psay dtoc(sn3->n3_aquisic)
  @ prow()  ,132 psay dtoc(sn3->n3_dindepr)
  @ prow()  ,146 psay tmp1->custbem
  @ prow()  ,157 psay tmp1->chapa

  _ntot += tmp1->valor              
  _ntotd += tmp1->vldep
  _ntotr += tmp1->valor-tmp1->vldep
  _nvalord += tmp1->vldep
  _nvalorr += tmp1->valor-tmp1->vldep  
  _nvalor += tmp1->valor                                                                              
  	tmp1->(dbskip())
end   
if !empty(_nvalor)
	@ prow()+1,000 psay "TOTAL DA CONTA"
	@ prow()  ,061 psay TRANSFORM(_nvalor, "@E 999,999,999.99")
	@ prow()  ,077 psay TRANSFORM(_nvalord, "@E 999,999,999.99")			
	@ prow()  ,092 psay TRANSFORM(_nvalorr, "@E 999,999,999.99")			
	_nvalor :=0
	_nvalord :=0
	_nvalorr :=0	
endif
@ prow()+1,000 psay "TOTAL GERAL "
@ prow()  ,061 psay TRANSFORM(_ntot, "@E 999,999,999.99")
@ prow()  ,077 psay TRANSFORM(_ntotd, "@E 999,999,999.99")
@ prow()  ,092 psay TRANSFORM(_ntotr, "@E 999,999,999.99")
roda(0," ")      
tmp1->(dbclosearea())
set device to screen
if areturn[5]==1    
	set printer to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

static function _geratmp()
procregua(1)

incproc("Selecionando Ativos...")
_cquery:=" SELECT"
_cquery+=" N3_CBASE PRODUTO, N3_HISTOR HISTOR, N3_VORIG1 VALOR, N3_VRDACM1 VLDEP,N3_CCONTAB CONTA,N3_ITEM ITEM,"
_cquery+=" N1_CHAPA CHAPA, N3_CUSTBEM CUSTBEM"
_cquery+=" FROM "
_cquery+=  retsqlname("SN3")+" SN3,"
_cquery+=  retsqlname("SN1")+" SN1"
_cquery+=" WHERE"
_cquery+="     SN3.D_E_L_E_T_<>'*'"
_cquery+=" AND SN1.D_E_L_E_T_<>'*'"
_cquery+=" AND N3_FILIAL='"+_cfilsn3+"'"
_cquery+=" AND N1_FILIAL='"+_cfilsn1+"'"
_cquery+=" AND N3_CBASE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND N3_CCONTAB BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND N3_CCUSTO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND N3_AQUISIC BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
_cquery+=" AND N3_DINDEPR BETWEEN '"+dtos(mv_par09)+"' AND '"+dtos(mv_par10)+"'"
_cquery+=" AND (N3_BAIXA<>'1' AND N3_BAIXA<>'2')"
_cquery+=" AND N3_CBASE=N1_CBASE"
_cquery+=" AND N3_ITEM=N1_ITEM"
_cquery+=" ORDER BY"
_cquery+=" N3_CCONTAB,N3_HISTOR"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
return


static function _pergsx1()
_agrpsx1:={}
//³ mv_par01        	// Do Bem                                  ³
//³ mv_par02        	// Ate o Bem                               ³
//³ mv_par03        	// A partir da data                        ³
//³ mv_par04        	// Ate a Data                              ³
//³ mv_par05        	// A partir da conta                       ³
//³ mv_par06        	// Ate a conta                             ³
//³ mv_par07        	// Qual a Moeda                            ³
//³ mv_par08        	// Do Centro de Custo                      ³
//³ mv_par09        	// Ate o Centro de Custo                   ³
aadd(_agrpsx1,{cperg,"01","Do Bem             ?","mv_ch1","C",10,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SN1"})
aadd(_agrpsx1,{cperg,"02","Ate o Bem          ?","mv_ch2","C",10,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SN1"})
aadd(_agrpsx1,{cperg,"03","A partir da Conta  ?","mv_ch3","C",20,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CT1"})
aadd(_agrpsx1,{cperg,"04","Ate a Conta        ?","mv_ch4","C",20,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CT1"})
aadd(_agrpsx1,{cperg,"05","Do Centro de Custo ?","mv_ch5","C",09,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{cperg,"06","Ate Centro de Custo?","mv_ch6","C",09,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{cperg,"07","Da Data Aquisição  ?","mv_ch7","D",08,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate Data Aquisição ?","mv_ch8","D",08,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Dt.Inic.Depreciação?","mv_ch9","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Dt.Fim.Depreciação ?","mv_chA","D",08,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})


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
Faturamento Acumulado - Periodo de : 99/99/99 a   99/99/99 
Dia (R$)Diario  Acumulado    (U$)Diario  Acumulado
99  999.999,99 999.999,99    999.999,99 999.999,99
*/

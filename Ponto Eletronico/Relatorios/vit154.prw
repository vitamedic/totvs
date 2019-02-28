/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT154   ³Autor ³ Gardenia              ³Data ³ 25/02/03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Saldo do Banco de Horas                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
Variaveis utilizadas para parametros
mv_par01 Da Fatura    
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT154()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="Horas a Pagar - Banco de Horas"
cdesc1   :="Este programa ira emitir o relatorio de horas a pagar"
cdesc2   :=" "
cdesc3   :=""
cstring  :="SPI"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT154"
wnrel    :="VIT154"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT154"
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
_cfilsi3:=xfilial("SI3")
_cfilspi:=xfilial("SPI")
_cfilsp9:=xfilial("SP9")
sra->(dbsetorder(1))
si3->(dbsetorder(1))
spi->(dbsetorder(2))
sp9->(dbsetorder(1))

processa({|| _querys()})

cabec1:="Período:" + dtoc(mv_par05) + " a " +dtoc(mv_par06)
cabec2:="Matric. Funcionário                               Saldo Geral Vl.Geral (R$)  Saldo mes Vl.mes (R$)  Sl.Pagar 50%  Lancar BH"
//cabec2:="Matric. Funcionário                               Saldo Geral"// Vl.Geral (R$)  Saldo mes Vl.mes (R$)    Sl.Pagar"
//Matric. Funcionário                               Saldo Geral Vl.Geral (R$)  Saldo mes Vl.mes (R$)    Sl.Pagar
//999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999.999,99   999,999.99  999.999,99  999,999.99  999,999.99



setprc(0,0)
                                         

tmp1->(dbgotop())
_tsaldo:=0
_tvalor:=0
_tsaldomes:=0
_tvalormes:=0
_tpagsaldo:=0
_tpagsaldomes:=0

while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif    
	
//999999     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX     999,999.99  999,999.99 999,999.99  999,999.99    999,999.99  9,999,999.99

	_cc:=tmp1->cc
   si3->(dbseek(_cfilsi3+tmp1->cc))
	_mat:=tmp1->mat  
	_credito:=0
	_debito:=0
	_saldo:=0

	_creditomes:=0
	_debitomes:=0
	_saldomes:=0
	_hora100:=0

	_minsaldomes:=0
	_minsaldo50mes:=0
	_minsaldo100mes:=0
	_pagsaldomes=0
	_pagsaldo50mes=0
	_pagsaldo100mes=0

	_minsaldo:=0
	_pagsaldo=0

	sra->(dbseek(_cfilsra+tmp1->mat))
	if sra->ra_sitfolh =="D"
		tmp1->(dbskip())  
		loop
	endif
	while ! tmp1->(eof()) .and.;
	     lcontinua .and. _mat==tmp1->mat // .and. _cc==tmp1->cc
		if prow()==0 .or. prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)	
		endif    
	   _imprime := .f.
		if sra->ra_sitfolh =="D"
			tmp1->(dbskip())
		endif
		sp9->(dbseek(_cfilsp9+tmp1->pd))
	   if   tmp1->datat<= mv_par06 
	      if sp9->p9_tipocod =="1" 
	       	_credito:=SomaHoras(_credito,tmp1->quant)                   
   	   endif
	      if sp9->p9_tipocod =="2" 
	       	_debito:=SomaHoras(_debito,tmp1->quant)
	      endif   	    
	   endif   
	   if   tmp1->datat>= mv_par07  .and. tmp1->datat <= mv_par08 	        
	      if sp9->p9_tipocod =="1" 
	      	_creditomes:=SomaHoras(_creditomes,tmp1->quant)
	      	if sp9->p9_codigo == "041"
	      		_hora100:=SomaHoras(_hora100,tmp1->quant)
	      	endif	
	      endif
//         if sp9->p9_tipocod =="2" 
//	       	_debitomes:=SomaHoras(_debitomes,tmp1->quant)
//	     endif   	    
      endif
		tmp1->(dbskip())
   end
   _saldo:=SubHoras(_credito,_debito)
   _saldomes:=SubHoras(_creditomes,_debitomes)
   _saldo50mes:=SubHoras(_saldomes,_hora100)
   _saldo100mes:=_hora100
   
   if !empty(mv_par07)  .and. _saldomes>0 .and. _saldo>=0
   	_imprime:=.t.
   elseif empty(mv_par07) .and. _saldo <0
   	_imprime:=.t.	
   endif	
   if _imprime
    	_tsaldo+=_saldo
	   _valor:=(sra->ra_salario/220)*_saldo
	   _valor:=_valor+(_valor*0.50)

    	_tsaldomes+=_saldomes
	   _valormes:=(sra->ra_salario/220)*_saldomes
	   _valor100mes:=(sra->ra_salario/220)*_hora100
	   _valormes:=_valormes-_valor100mes
	   _valormes:=_valormes+(_valormes*0.50)
	   _valor100mes:=_valor100mes*2
	   _valormes:=_valormes+_valor100mes
//999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999.999,99   999,999.99  999.999,99  999,999.99  999,999.99
		 @ prow()+1,000 PSAY sra->ra_mat  
	    @ prow(),008 PSAY sra->ra_nome
		 @ prow(),051 PSAY _saldo picture "@E 999,999.99"
		 @ prow(),064 PSAY _valor picture "@E 999,999.99"
		 if !empty(_saldomes)
		 	 _minsaldomes:=hrs2min(_saldomes)
		 	 _minsaldomes:=_minsaldomes/2
		 	 _pagsaldomes:=min2hrs(_minsaldomes)

		 	 _minsaldo50mes:=hrs2min(_saldo50mes)
		 	 _minsaldo50mes:=_minsaldo50mes/2
		 	 _pagsaldo50mes:=min2hrs(_minsaldo50mes)

//		 	 _minsaldo100mes:=hrs2min(_saldo100mes)
//		 	 _minsaldo100mes:=_minsaldo100mes/2
//		 	 _pagsaldo100mes:=min2hrs(_minsaldo100mes)
		 	 
		 	 
			 @ prow(),076 PSAY _saldomes picture "@E 999,999.99"
			 @ prow(),088 PSAY _valormes/2 picture "@E 999,999.99"
//			 @ prow(),101 PSAY _pagsaldomes picture "@E 999,999.99"
			 @ prow(),101 PSAY somahoras(_pagsaldo50mes,_hora100) picture "@E 999,999.99"
//			 @ prow(),114 PSAY _pagsaldo100mes picture "@E 999,999.99"
			 @ prow(),114 PSAY _pagsaldo50mes picture "@E 999,999.99"
			 _tpagsaldomes+=_pagsaldomes
		 else
		 	 _minsaldo:=hrs2min(_saldo)
		 	 _minsaldo:=_minsaldo/2
		 	 _pagsaldo:=min2hrs(_minsaldo)
			 @ prow(),101 PSAY _pagsaldo picture "@E 999,999.99"
			 _tsaldo+=_pagsaldo
 		 endif	 
	   _tvalor+=_valor
	   _tvalormes+=_valormes
	endif 	 
 	if labortprint
	   @ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end
if lcontinua .and. !empty(_tsaldo)
//if lcontinua .and. !empty(_tvalor)
	@ prow()+1,000 PSAY "TOTAL            =================>"
   @ prow(),051 PSAY _tsaldo picture "@E 999,999.99"
	@ prow(),064 PSAY _tvalor picture "@E 999,999.99"
	if !empty(_tsaldomes)
	   @ prow(),076 PSAY _tsaldomes picture "@E 999,999.99"
		@ prow(),088 PSAY _tvalormes/2 picture "@E 999,999.99"
		@ prow(),101 PSAY _tpagsaldomes picture "@E 999,999.99"
	endif	
endif



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
_cquery+=" PI_MAT MAT,PI_DATA DATAT,PI_PD PD,PI_CC CC,PI_QUANT QUANT,RA_NOME NOME"
_cquery+=" FROM "
_cquery+=  retsqlname("SRA")+" SRA,"
_cquery+=  retsqlname("SPI")+" SPI"
_cquery+=" WHERE"
_cquery+="     SPI.D_E_L_E_T_<>'*'"
_cquery+=" AND SRA.D_E_L_E_T_<>'*'"
_cquery+=" AND PI_FILIAL='"+_cfilspi+"'"
_cquery+=" AND RA_FILIAL='"+_cfilsra+"'"
_cquery+=" AND PI_MAT=RA_MAT"
_cquery+=" AND PI_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND PI_MAT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND PI_DATA BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
_cquery+=" ORDER BY RA_NOME"



_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DATAT","D")
tcsetfield("TMP1","QUANT"  ,"N",15,2)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da Matricula       ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"02","Ate a Matricula    ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"03","Do CC              ?","mv_ch3","C",09,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
aadd(_agrpsx1,{cperg,"04","Ate o CC           ?","mv_ch4","C",09,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
	
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


Static Function _CalcSalBH()
  _credito:=0
  _debito:=0
  _saldo:=0
  spi->(dbseek(_cfilspi+sra->ra_mat))
  while ! spi->(eof()) .and. spi->pi_mat == sra->ra_mat 
	 sp9->(dbseek(_cfilsp9+spi->pi_pd))
    if sp9->p9_tipocod =="1" 
     	_credito:=somaHoras(_credito,spi->pi_quant)
    endif
    if sp9->p9_tipocod =="2"                           
     	_debito:=SomaHoras(_debito,spi->pi_quant)
    endif   	    
	 spi->(dbskip())
  end
  _saldo:=SubHoras(_credito,_debito)
return(_saldo)   
  

  





/*
Produto: xxxxxxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  Data        Quantidade UM Ordem de producao Quantidade Seg. UM
99/99/99 999,999,999.999 xx    xxxxxxxxxxx    999,999,999.999 xx
*/
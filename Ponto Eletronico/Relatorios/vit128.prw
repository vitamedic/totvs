/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT128    ³Autor ³ Gardenia              ³Data ³ 25/02/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Horas a Pagar - Banco de Horas                             ³±±
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

user function VIT128()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="Horas a Pagar - Banco de Horas"
cdesc1   :="Este programa ira emitir o relatorio de horas a pagar"
cdesc2   :=" "
cdesc3   :=""
cstring  :="SPI"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT128"
wnrel    :="VIT128"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=200
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT128"
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

cabec1:="Período: "+dtoc(mv_par01) +" a "+dtoc(mv_par02)
cabec2:="Matricula  Funcionário                              Centro de Custo              Credito Mes  Debito Mes  Deb.4 meses    Apuração  Result.Mes  Saldo a Pagar         Valor"
//Matricula  Funcionário                              Centro de Custo              Credito Mes  Debito Mes  Deb.4 meses   Resul.Mes    Apuração  Saldo a Pagar         Valor
//999999     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX     999,999.99  999,999.99   999,999.99  999,999.99  999,999.99     999,999.99  9,999,999.99


setprc(0,0)
                                         

tmp1->(dbgotop())
_tvalor:=0
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif    
	
//999999     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX     999,999.99  999,999.99 999,999.99  999,999.99    999,999.99  9,999,999.99

	_cc:=tmp1->cc
   si3->(dbseek(_cfilsi3+tmp1->cc))
//	while ! tmp1->(eof()) .and.;
//      lcontinua .and. _cc==tmp1->cc
//		if prow()==0 .or. prow()>54
//			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
//		endif    
		_mat:=tmp1->mat  
		_credito:=0
		_debito:=0
		_saldo:=0
		_2saldo:=0
		_valor:=0
		_vsalatemes:=0
		_debmes:=0
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
			if sra->ra_sitfolh =="D"
				tmp1->(dbskip())
				loop
			endif
			sp9->(dbseek(_cfilsp9+tmp1->pd))
			if tmp1->datat >= mv_par01 .and. tmp1->datat <= mv_par02
	         if sp9->p9_tipocod =="1" 
	         	_credito:=SomaHoras(_credito,tmp1->quant)
	         endif
	      endif   	
			if tmp1->datat >= mv_par01 .and. tmp1->datat <= mv_par02
	         if sp9->p9_tipocod =="2" 
	         	_debmes:= SomaHoras(_debmes,tmp1->quant)
	         endif
	      endif   	
			if tmp1->datat >= mv_par03 .and. tmp1->datat <= mv_par04
	         if sp9->p9_tipocod =="2"                           
	         	_debito:=SomaHoras(_debito,tmp1->quant)
	         endif
	      endif   	    
			tmp1->(dbskip())
       end
      _saldo:=SubHoras(_credito,_debito)
      _vsalatemes:=_FSalatemes()
      if _saldo >0 .and. _vsalatemes>0
	     _valor:=(sra->ra_salario/220)*_saldo
	     _valor:=_valor+(_valor*0.50)
		   @ prow()+1,000 PSAY sra->ra_mat  
			@ prow(),012 PSAY sra->ra_nome
			@ prow(),053 PSAY si3->i3_desc
			@ prow(),082 PSAY _credito picture "@E 999,999.99"
			@ prow(),094 PSAY _debmes picture "@E 999,999.99"
			@ prow(),107 PSAY _debito picture "@E 999,999.99"
		   @ prow(),119 PSAY _saldo picture "@E 999,999.99"
		   @ prow(),131 PSAY  SubHoras(_credito,_debmes) picture "@E 999,999.99"
 		   @ prow(),146 PSAY _saldo picture "@E 999,999.99"
			@ prow(),158 PSAY _valor picture "@E 9,999,999.99"
		elseif (_saldo <0) .and. ((_credito-_debmes)<0) .and. (_vsalatemes >0)
	     _valor:=(sra->ra_salario/220)*_vsalatemes
	     _valor:=_valor+(_valor*0.50)
		   @ prow()+1,000 PSAY sra->ra_mat  
			@ prow(),012 PSAY sra->ra_nome
			@ prow(),053 PSAY si3->i3_desc
			@ prow(),082 PSAY _credito picture "@E 999,999.99"
			@ prow(),094 PSAY _debmes picture "@E 999,999.99"
			@ prow(),107 PSAY _debito picture "@E 999,999.99"
		   @ prow(),119 PSAY _saldo picture "@E 999,999.99"
		   @ prow(),131 PSAY  SubHoras(_credito,_debmes) picture "@E 999,999.99"
 		   @ prow(),146 PSAY _vsalatemes picture "@E 999,999.99"
			@ prow(),158 PSAY _valor picture "@E 9,999,999.99"
		endif 	 
	   _tvalor+=_valor
	 	if labortprint
  		   @ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
//	end	 
end
if lcontinua .and. !empty(_tvalor)
	@ prow()+1,000 PSAY "TOTAL            =================>"
	@ prow(),158  PSAY _tvalor picture "@E 9,999,999.99"
//	@ prow()+1,000 PSAY "VALOR FATURA     =================>"
//	@ prow(),069   PSAY mv_par04 picture "@E 999,999.99"
//	@ prow()+2,000 PSAY "TOTAL NF'S / VALOR FATURA (%)=====>"
//	@ prow(),069   PSAY (mv_par04/_total)*100 picture "@E 999,999.99"
 
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
_cquery+=" PI_MAT MAT,PI_DATA DATAT,PI_PD PD,PI_CC CC,PI_QUANT QUANT"
_cquery+=" FROM "
_cquery+=  retsqlname("SPI")+" SPI"
_cquery+=" WHERE"
_cquery+="     SPI.D_E_L_E_T_<>'*'"
_cquery+=" AND PI_FILIAL='"+_cfilspi+"'"
_cquery+=" AND PI_DATA BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
_cquery+=" AND PI_CC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND PI_MAT BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY PI_MAT"



_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DATAT","D")
tcsetfield("TMP1","QUANT"  ,"N",15,2)
return

static function _pergsx1()
_agrpsx1:={}

aadd(_agrpsx1,{cperg,"01","Da Data do Credito ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a Data Credito ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da Data da Compen. ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a Data Compen. ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da Matricula       ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"06","Ate a Matricula    ?","mv_ch6","C",06,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"07","Do CC              ?","mv_ch7","C",09,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
aadd(_agrpsx1,{cperg,"08","Ate o CC           ?","mv_ch8","C",09,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
	
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
  _2credito:=0
  _2debito:=0
  _2saldo:=0
  spi->(dbseek(_cfilspi+sra->ra_mat))
  while ! spi->(eof()) .and. spi->pi_mat == sra->ra_mat 
	 sp9->(dbseek(_cfilsp9+spi->pi_pd))
    if sp9->p9_tipocod =="1" 
     	_2credito:=somaHoras(_2credito,spi->pi_quant)
    endif
    if sp9->p9_tipocod =="2"                           
     	_2debito:=SomaHoras(_2debito,spi->pi_quant)
    endif   	    
	 spi->(dbskip())
  end
  _2saldo:=SubHoras(_2credito,_2debito)
return(_2saldo)   
  

Static Function _FSalatemes()
  _3credito:=0
  _3debito:=0
  _3saldo:=0
  spi->(dbseek(_cfilspi+sra->ra_mat))
  while ! spi->(eof()) .and. spi->pi_mat == sra->ra_mat 
	 sp9->(dbseek(_cfilsp9+spi->pi_pd))
 	 if  spi->pi_data <= mv_par02
	   if sp9->p9_tipocod =="1" 
    	  _3credito:=somaHoras(_3credito,spi->pi_quant)
	   endif
	    if sp9->p9_tipocod =="2"                           
	     	_3debito:=SomaHoras(_3debito,spi->pi_quant)
	    endif   	    
	 endif   
	 spi->(dbskip())
  end
  _3saldo:=SubHoras(_3credito,_3debito)
return(_3saldo)   
  





/*
Produto: xxxxxxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  Data        Quantidade UM Ordem de producao Quantidade Seg. UM
99/99/99 999,999,999.999 xx    xxxxxxxxxxx    999,999,999.999 xx
*/
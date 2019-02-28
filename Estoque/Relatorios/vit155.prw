/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT155   ³ Autor ³ Gardenia              ³ Data ³ 07/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rel.Prod. de Controle da Policia Federal e Min. Exercito   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
Variaveis utilizadas para parametros
mv_par01 Da data
mv_par02 Ate a data
mv_par01 Do produto
mv_par02 Ate o produto
mv_par01 Do tipo
mv_par02 Ate o tipo
mv_par01 Do grupo
mv_par02 Ate a grupo
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT155()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="PROD. CONTROLADOS  POLICIA FEDERAL E MINISTÉRIO DO EXÉRCITO"
cdesc1   :="Este programa ira emitir a relacao de estoque de Produtos"
cdesc2   :="controlados pela Polícia Federal e Ministério do exército "
cdesc3   :=""
cstring  :="SD1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT155"
wnrel    :="VIT155"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT155"
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
_cfilsb1:=xfilial("SB1")
_cfilsd1:=xfilial("SD1")
_cfilsf1:=xfilial("SF1")
_cfilsa2:=xfilial("SA2")
_cfilsf8:=xfilial("SF8")
_cfilsd3:=xfilial("SD3")
_cfilsa4:=xfilial("SA4")
_cfilsf4:=xfilial("SF4")
_cfilsd2:=xfilial("SD2")
sb1->(dbsetorder(3))
sa4->(dbsetorder(1))
sd3->(dbsetorder(7))
sf8->(dbsetorder(2))
sa2->(dbsetorder(1))
sd1->(dbsetorder(7))
sf1->(dbsetorder(1))
sf4->(dbsetorder(1))
sd2->(dbsetorder(6))


processa({|| _querys()})

cabec1:="Periodo:" +dtoc(mv_par09) +" a " +dtoc(mv_par10)
//999999-9  999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999-9
cabec2:="Nota         Dt.Nota  Dt.Entra       Qtde.  Transportadora                            Conhec.  Guia Traf."



setprc(0,0)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_movim:=.f.
	_passou:=.f.
// 	@ prow()+1,000 PSAY ""
	_tquant  :=0
	_tsaida :=0
	_cproduto:=tmp1->cod  
	_locpad:=tmp1->locpad     
	_dtsldini:=mv_par09
   _estoque:=calcest(_cproduto,tmp1->locpad,_dtsldini) 
   _saldoini:=_estoque[1]
//	sd1->(dbseek(_cfilsd1+_cproduto+_locpad+dtos(mv_par09),.t.))
	sd1->(dbseek(_cfilsd1+_cproduto,.t.))
	while !sd1->(eof()) .and.;
		_cproduto==sd1->d1_cod   .and. ;
		lcontinua               
		if sd1->d1_dtdigit <mv_par09 .or. sd1->d1_dtdigit >mv_par10 .or. sd1->d1_quant<=0
			sd1->(dbskip())			
			loop
		endif	
		sf4->(dbseek(_cfilsf4+sd1->d1_tes,.t.))
 	   if sf4->f4_estoque <>"S" 
			sd1->(dbskip())
			loop
		endif
		if !_passou
		   @ prow()+2,000 PSAY left(tmp1->cod,10)+" - "+ltrim(left(tmp1->descri,58)) + " - " + tmp1->um
		   @ prow()+1,00 PSAY "ENTRADAS:" 
		   _passou :=.t.
		endif
		_movim:=.t.
		sa2->(dbseek(_cfilsa2+sd1->d1_fornece+sd1->d1_loja))
		sf1->(dbseek(_cfilsf1+sd1->d1_doc+sd1->d1_serie+sd1->d1_fornece+sd1->d1_loja))
		sf8->(dbseek(_cfilsf8+sd1->d1_doc+sd1->d1_serie+sd1->d1_fornece+sd1->d1_loja))
		@ prow()+2,00 PSAY "Fornecedor: "+sd1->d1_fornece+"-"+sd1->d1_loja+ " "+alltrim(sa2->a2_nome)
		@ prow(),65 PSAY "End.: "+alltrim(sa2->a2_end) +" "+alltrim(sa2->a2_bairro)+" "+alltrim(sa2->a2_mun)+" "+sa2->a2_est
		@ prow(),150 PSAY "CGC:"+sa2->a2_cgc
		@ prow()+1,00 PSAY sd1->d1_doc+"-"+sd1->d1_serie
		@ prow(),12 PSAY sd1->d1_emissao
		@ prow(),21 PSAY sd1->d1_dtdigit
		@ prow(),30 PSAY sd1->d1_quant picture "@E 9,999,999.99"
		@ prow(),44 PSAY sd1->d1_um
		sa2->(dbseek(_cfilsa2+sf8->f8_transp+sf8->f8_lojtran))
		@ prow(),48 PSAY substr(sa2->a2_nome,1,40) 
		@ prow(),90 PSAY sf8->f8_nfdifre+"-"+sf8->f8_sedifre
		@ prow(),150 PSAY "CGC:"+sa2->a2_cgc
		if _locpad== sd1->d1_local
			_tquant+=sd1->d1_quant
		endif	
		sd1->(dbskip())
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
	end
	sd3->(dbseek(_cfilsd3+_cproduto+_locpad+dtos(mv_par09),.t.))
	while !sd3->(eof()) .and.;
		_cproduto==sd3->d3_cod .and. sd3->d3_local==_locpad .and. sd3->d3_emissao <=mv_par10 .and. ;
		lcontinua
	  if sd3->d3_estorno =="S"  .or. !substr(sd3->d3_cf,1,1)$"RD" 
			sd3->(dbskip())
			loop
		endif
		if substr(sd3->d3_cf,1,1) =="R" 
	      _tsaida+=sd3->d3_quant
	   elseif substr(sd3->d3_cf,1,1) =="D"  // .and. sd3->d3_tm <>"499" 
       _tquant+=sd3->d3_quant
//      elseif substr(sd3->d3_cf,1,1) =="D" .and. sd3->d3_doc=="INVENT"
//       _tquant+=sd3->d3_quant
//      elseif substr(sd3->d3_cf,1,1) =="D" .and. !empty(sd3->d3_localiz)
//       _tquant+=sd3->d3_quant
      endif 
		sd3->(dbskip())
		_movim:=.t.
   end   
	sd2->(dbseek(_cfilsd2+_cproduto+_locpad+dtos(mv_par09),.t.))
	while !sd2->(eof()) .and.;
		_cproduto==sd2->d2_cod .and. sd2->d2_local==_locpad .and. sd2->d2_emissao <=mv_par10 .and. ;
		lcontinua
		sf4->(dbseek(_cfilsf4+sd2->d2_tes,.t.))
	  if sf4->f4_estoque <>"S" 
			sd2->(dbskip())
			loop
		endif
      _tsaida+=sd2->d2_quant
		sd2->(dbskip())
		_movim:=.t.
   end   
//   if _tquant > 0 .or. _tsaida >0 
		if !_passou
		   @ prow()+2,000 PSAY left(tmp1->cod,10)+" - "+ltrim(left(tmp1->descri,58)) + " - " + tmp1->um
		   @ prow()+1,00 PSAY "ENTRADAS:" 
		   _passou :=.t.
		endif
		@ prow()+2,00 PSAY "Estoque em "+dtoc(_dtsldini)+":"
		@ prow(),25   PSAY _saldoini picture  "@E 999,999,999.99"
		@ prow()+1,00 PSAY "Qtde. comprada/Ent:"  
		@ prow(),25 PSAY _tquant  picture  "@E 999,999,999.99"
		@ prow()+1,00 PSAY "Qtde. utilizada...:"
		@ prow(),25 PSAY _tsaida  picture  "@E 999,999,999.99"
	   _estoque:=calcest(_cproduto,_locpad,mv_par10) 
	   _saldofim:=_estoque[1]
		@ prow()+1,00 PSAY "Saldo Atual.......:"
		@ prow(),25 PSAY (_saldoini+_tquant-_tsaida) picture  "@E 999,999,999.99"
//	endif	
	tmp1->(dbskip())
end

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
_cquery+=" B1_COD COD,B1_DESC DESCRI,B1_LOCPAD LOCPAD,B1_UM UM"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
if mv_par11==1
	_cQuery+=" AND B1_PFIDENT ='PF'"
elseif mv_par11==2
	_cQuery+=" AND B1_PFIDENT ='ME'"
elseif mv_par11==3	
	_cQuery+=" AND B1_PFIDENT IN ('ME','PF')"
endif	
_cquery+=" ORDER BY B1_DESC"
_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
//tcsetfield("TMP1","DTDIGIT","D")
//tcsetfield("TMP1","EMISSAO","D")
//tcsetfield("TMP1","QUANT"  ,"N",15,3)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Armazem            ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem      ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Da Data            ?","mv_ch9","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate a Data         ?","mv_chA","D",08,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Qual orgão         ?","mv_chB","N",01,0,0,"C",space(60),"mv_par11"       ,"Polic. Federal" ,space(30),space(15),"Min. Exercito"  ,space(30),space(15),"Ambos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
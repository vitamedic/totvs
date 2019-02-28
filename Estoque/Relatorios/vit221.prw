/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT126   ³ Autor ³ Gardenia Ilany      ³ Data ³ 27/12/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Giro de Estoque                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function VIT221()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="GIRO DE ESTOQUE"
cdesc1   :="Este programa ira emitir o relatório de giro de estoque"
cdesc2   :=""
cdesc3   :=""
cstring  :="SD3"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT221"
wnrel    :="VIT221"+Alltrim(cusername)
aordem  :={"Descricao","Ranking","Giro"}
m_pag    :=1
li       :=200
alinha   :={}
nlastkey :=0
lcontinua:=.t.
cperg:="PERGVIT221"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
   set filter to
   return
endif

setdefault(areturn,cstring)

nordem:=areturn[8]
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
li    :=200
cbtxt :=space(10)

//if nordem ==1
// _mtipo:= "Descricao"
//elseif nordem==2
// _mtipo:= "Ranking"
//elseif nordem==3
// _mtipo:="Giro"
//endif 



titulo:="GIRO DE ESTOQUE"
cabec1:="Período: " +dtoc(mv_par07)+" e "+dtoc(mv_par08)+space(21)+"        Media           Media        Estoque                               Dias de        Preco         Valor"
cabec2:="Codigo Descricao                                     Comp/Prod      Cons/Venda          Atual        Empenho         Emp.OP Estoque        Medio         Estoque"

_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsd3:=xfilial("SD3")
_cfilsd4:=xfilial("SD4")
_cfilsd2:=xfilial("SD2")
_cfilsd1:=xfilial("SD1")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sd3->(dbsetorder(6))
sd2->(dbsetorder(1))
sd1->(dbsetorder(3))
sd4->(dbsetorder(1))
_acom    :={}

_ccq     :=getmv("MV_CQ")
_nmovmes :=0
_ntsaimes :=0

processa({|| _geratmp()})

setprc(0,0)
_qtdent :=0
_qtdsai :=0

_test:=0
_temp:=0
_tempop:=0
_tvest:=0
_custo:=0

setregua(sb1->(lastrec()))
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	incregua() 
 
   
// ENTRADAS NO PERÍODO           
//	incproc("Selecionando entradas...")

	_cquery :=" SELECT "
	_cquery +=" SUM(D3_QUANT) QUANT,SUM(D3_CUSTO1) CUSTO1"
	_cquery +=" FROM "+retsqlname("SD3")+" SD3"
	_cquery +=" WHERE D3_FILIAL='"+_cfilsd3+"'"
	_cquery +=" AND SD3.D_E_L_E_T_<>'*'"
	_cquery +=" AND D3_COD='"+tmp1->produto+"'"   
   _cquery +=" AND D3_LOCAL BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
  	_cquery +=" AND D3_ESTORNO <>'S'"
   _cquery +=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
   _cquery +=" AND D3_TM < '500'"
   
 	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",15,2)
	tcsetfield("TMP2","CUSTO1","N",15,2)
	
	tmp2->(dbgotop())
	_qtdent:=tmp2->quant
	_cstent:=tmp2->custo1
	tmp2->(dbclosearea())         
	
	// SAIDA DO PERIODO
//	incproc("Selecionando saidas...")

	_cquery :=" SELECT "
	_cquery +=" SUM(D3_QUANT) QUANT,SUM(D3_CUSTO1) CUSTO1"
	_cquery +=" FROM "+retsqlname("SD3")+" SD3"
	_cquery +=" WHERE D3_FILIAL='"+_cfilsd3+"'"
	_cquery +=" AND SD3.D_E_L_E_T_<>'*'"
	_cquery +=" AND D3_COD='"+tmp1->produto+"'"  
   _cquery +=" AND D3_LOCAL BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
   _cquery +=" AND D3_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
  	_cquery +=" AND D3_ESTORNO <>'S'"
   _cquery +=" AND D3_TM >= '500'"
   _cquery +=" AND D3_TM <= '999'"
   
 	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP3"
	tcsetfield("TMP3","QUANT","N",15,2)
	tcsetfield("TMP3","CUSTO1","N",15,2)
	tmp3->(dbgotop())
	_qtdsai:=tmp3->quant
	_cstsai:=tmp3->custo1
	tmp3->(dbclosearea())

  // Soma o empenho do produto

	_cquery :=" SELECT "
	_cquery +=" SUM(D4_QUANT) QUANT"
	_cquery +=" FROM "+retsqlname("SD4")+" SD4"
	_cquery +=" WHERE D4_FILIAL='"+_cfilsd4+"'"
	_cquery +=" AND SD4.D_E_L_E_T_<>'*'"
	_cquery +=" AND D4_COD='"+tmp1->produto+"'"  
   _cquery +=" AND D4_LOCAL BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
//   _cquery +=" AND D4_DATA BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
  	_cquery +=" AND D4_QUANT >0"
   
 	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP5"
	tcsetfield("TMP5","QUANT","N",15,2)
	tmp5->(dbgotop())
	_empop:=tmp5->quant
	tmp5->(dbclosearea())



	if tmp1->tipo == "PA"
		_cquery :=" SELECT "
		_cquery +=" SUM(D2_QUANT) QUANT,SUM(D2_TOTAL) CUSTO1"
		_cquery +=" FROM "+retsqlname("SD2")+" SD2"
		_cquery +=" WHERE D2_FILIAL='"+_cfilsd2+"'"
		_cquery +=" AND SD2.D_E_L_E_T_<>'*'"
		_cquery +=" AND D2_COD='"+tmp1->produto+"'"  
	   _cquery +=" AND D2_LOCAL BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	   _cquery +=" AND D2_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
   
	 	_cquery:=changequery(_cquery)
	
		tcquery _cquery new alias "TMP4"
		tcsetfield("TMP4","QUANT","N",15,2)
		tcsetfield("TMP4","CUSTO1","N",15,2)

		tmp4->(dbgotop())
		_qtdsai+=tmp4->quant
		_cstsai+=tmp4->custo1
		tmp4->(dbclosearea())
    endif

	sb1->(dbseek(_cfilsb1+tmp1->produto))
	// SALDO ATUAL E EMPENHO
	if sb2->(dbseek(_cfilsb2+sb1->b1_cod+sb1->b1_locpad))
		_nsaldo:=int(sb2->b2_qatu-sb2->b2_reserva-sb2->b2_qemp)
		_nempen:=int(sb2->b2_reserva+sb2->b2_qemp)
		_custo:=sb2->b2_cm1
	else
		_nsaldo:=0
		_nempen:=0
	endif
	   _meses:=int((mv_par08-mv_par07)/30)          
	aadd(_acom,{sb1->b1_cod,sb1->b1_desc,(_qtdent/_meses),(_qtdsai+_empop)/_meses,_nsaldo,_nempen,_empop,(_nsaldo)/((_qtdsai+_empop)/_meses),(_custo),_nsaldo*_custo})   // _nsaldo*(_cstent/_qtdent)})
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if lcontinua
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
   _tqtdent:=0
	_tqtdsai:=0
	_nest :=0
	_nemp :=0
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif       
	if nordem==1	
		 _acom:= asort(_acom,,,{|x,y| x[2]<y[2]})
	elseif nordem==2	
		 _acom:= asort(_acom,,,{|x,y| y[4]<x[4]})
	elseif nordem==3	  
		 _acom:= asort(_acom,,,{|x,y| y[7]<x[7]})
	endif	 
	for _i:=1 to len(_acom)
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif       
		if _acom[_i,5] > 0 .or. _acom[_i,6] > 0
			@ prow()+1,000  PSAY left(_acom[_i,1],6)
			@ prow() ,007   PSAY left(_acom[_i,2],40)
			@ prow() ,048   PSAY _acom[_i,3] picture "@E 999,999,999.99"
			@ prow() ,064   PSAY _acom[_i,4] picture "@E 999,999,999.99"
			@ prow() ,079   PSAY _acom[_i,5] picture "@E 999,999,999.99"
			@ prow() ,094   PSAY _acom[_i,6] picture "@E 999,999,999.99"
			@ prow() ,109   PSAY _acom[_i,7] picture "@E 999,999,999.99"
			@ prow() ,124   PSAY _acom[_i,8]*30 picture "@E 9999999"
			@ prow() ,132   PSAY _acom[_i,9] picture "@E 999,999.9999"
			@ prow() ,147   PSAY _acom[_i,10] picture "@E 999,999,999.99"
			_test+=_acom[_i,5]
			_temp+=_acom[_i,6]
			_tempop+=_acom[_i,7]
			_tvest+=_acom[_i,10]
		endif	
	next
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif       
   @ prow()+1,000 PSAY "TOTAL "
	@ prow() ,078   PSAY _test   picture "@E 9999,999,999.99"
	@ prow() ,094   PSAY _temp   picture "@E 999,999,999.99"
	@ prow() ,109   PSAY _tempop picture "@E 999,999,999.99"
	@ prow() ,147   PSAY _tvest  picture "@E 999,999,999.99"
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

static function _geratmp()
procregua(1)
incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_COD PRODUTO,B1_TIPO TIPO"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"  
_cquery +=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery +=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
if mv_par11 == "1" 
	_cquery+=" AND B1_APREVEN='1'"
elseif mv_par11 == "2"
	_cquery+=" AND B1_APREVEN='2'"
endif
_cquery+=" ORDER BY"
_cquery+=" B1_DESC"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"

return


static function _pergsx1()
_agrpsx1:={}
//aadd(_agrpsx1,{cperg,"01","Data Limite        ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Da data            ?","mv_ch7","D",08,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate a data         ?","mv_ch8","D",08,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do armazem         ?","mv_ch9","C",02,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate o armazem      ?","mv_chA","C",02,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Linha-Farma/Hospit.?","mv_chB","C",01,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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
                                                        S A I D A S                        E S T O Q U E
Codigo Descricao                                Mes Ant.   No Mes   No Dia    Media  Ent.Mes  Ent.Dia Processo  Empenho    Saldo Pendencia Dias Quarentena          Valor
XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999 9999.999  9999.999 9999   9999.999 999.999.999,99
*/

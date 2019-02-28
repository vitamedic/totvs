/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT126   ³ Autor ³ Aline B. Pereira      ³ Data ³ 18/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Resumo da Movimentacao do Estoque de Materiais             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit126()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="RESUMO DA MOVIMENTACAO DO ESTOQUE DE MATERIAIS"
cdesc1   :="Este programa ira emitir o resumo da movimentacao do estoque "
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT126"
wnrel    :="VIT126"+Alltrim(cusername)
m_pag    :=1
li       :=132
alinha   :={}
nlastkey :=0
lcontinua:=.t.
cperg:="PERGVIT126"
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
cbcont:=0
m_pag :=1
li    :=132
cbtxt :=space(10)
titulo:="MEDIA DE CONSUMO DE MATERIAIS "

if month(ddatabase)==01
	_cmesmed:="08"
elseif month(ddatabase)==02
	_cmesmed:="09"
elseif month(ddatabase)==03
	_cmesmed:="10"
else
	_cmesmed:=strzero(month(ddatabase)-6)                       
endif 

if month(ddatabase)<=06
	_canomed:=strzero(year(ddatabase)-1,4)
else
	_canomed:=strzero(year(ddatabase),4)
endif
_dfimmed := ddatabase
_ddia :=day(ddatabase)
_dinimed :=ctod(strzero(_ddia,2)+"/"+_cmesmed+"/"+_canomed)

while empty(_dinimed)
	_dinimed :=ctod(strzero(_ddia,2)+"/"+_cmesmed+"/"+_canomed)
	_ddia --
end
                                                                                                                         
cabec1:="Movimento entre: " +dtoc(_dinimed)+" e "+dtoc(_dfimmed)+space(14)+"Media         Media       Estoque                 Qtde.Mes        Custo     Custo"
cabec2:="Codigo Descricao                       UM       Compras       Consumo         Atual       Empenho    Estoque        Medio     Total"

_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsd3:=xfilial("SD3")
_cfilsd1:=xfilial("SD1")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sd3->(dbsetorder(6))
sd1->(dbsetorder(3))
_acom    :={}

_ccq     :=getmv("MV_CQ")
_nmovmes :=0
_ntsaimes :=0

processa({|| _geratmp()})

setprc(0,0)
_nmed :=0
_nent :=0
_nent2 :=0

setregua(sb1->(lastrec()))
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	incregua() 
//  	incproc("Selecionando entradas...")
	_cquery := " SELECT "
	_cquery +=" SUM(D1_QUANT) QTDE"
	_cquery +=" FROM "+retsqlname("SD1")+" SD1"
	_cquery +=" WHERE D1_FILIAL='"+_cfilsd1+"'"
	_cquery +=" AND SD1.D_E_L_E_T_<>'*'"
	_cquery +=" AND D1_DTDIGIT BETWEEN '"+dtos(_dinimed)+"' AND '"+dtos(_dfimmed)+"'"
	_cquery +=" AND D1_COD='"+tmp1->produto+"'"
	_cquery +=" AND D1_TIPO='N'"	
	
	_cquery:=changequery(_cquery)
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QTDE","N",07,0)
	
	tmp2->(dbgotop())
	_nent:=tmp2->qtde
	tmp2->(dbclosearea())
  
   
	// ENTRADA  DOS ULTIMOS 6 MESES
//	incproc("Selecionando entradas...")

	_cquery :=" SELECT "
	_cquery +=" SUM(D3_QUANT) QUANT"
	_cquery +=" FROM "+retsqlname("SD3")+" SD3"
	_cquery +=" WHERE D3_FILIAL='"+_cfilsd3+"'"
	_cquery +=" AND SD3.D_E_L_E_T_<>'*'"
	_cquery +=" AND D3_COD='"+tmp1->produto+"'"   
	_cquery +=" AND D3_LOCAL='"+tmp1->locpad+"'"  
//  	_cquery +=" AND D3_LOCAL <>'98'"  Tirei e coloquei o filtro acima - Gardênia 08/08/05

   _cquery +=" AND D3_EMISSAO BETWEEN '"+dtos(_dinimed)+"' AND '"+dtos(_dfimmed)+"'"
   _cquery +=" AND D3_TM < '500'"                 
   _cquery +=" AND D3_CF <> 'DE4'" // Filtro para excluir Transferências
   _cquery +=" AND D3_ESTORNO <> 'S'"  // Coloquei este filtro 08/08/05 - Gardênia
   
 	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",07,0)
	
	tmp2->(dbgotop())
	_nent2=tmp2->quant
	tmp2->(dbclosearea())         
	
	// SAIDA DOS ULTIMOS 6 MESES
//	incproc("Selecionando saidas...")

	_cquery :=" SELECT "
	_cquery +=" SUM(D3_QUANT) QUANT"
	_cquery +=" FROM "+retsqlname("SD3")+" SD3"
	_cquery +=" WHERE D3_FILIAL='"+_cfilsd3+"'"
	_cquery +=" AND SD3.D_E_L_E_T_<>'*'"
	_cquery +=" AND D3_COD='"+tmp1->produto+"'"  
	_cquery +=" AND D3_LOCAL='"+tmp1->locpad+"'"  
//  	_cquery +=" AND D3_LOCAL <>'98'"  Tirei e coloquei o filtro acima - Gardênia 08/08/05
   _cquery +=" AND D3_EMISSAO BETWEEN '"+dtos(_dinimed)+"' AND '"+dtos(_dfimmed)+"'"
   _cquery +=" AND D3_TM >= '500'"
   _cquery +=" AND D3_TM <= '999'"                                          
   _cquery +=" AND D3_CF <> 'RE4'" // Filtro para excluir Transferências   
   _cquery +=" AND D3_ESTORNO <> 'S'"  // Coloquei este filtro 08/08/05 - Gardênia
   
 	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	tcsetfield("TMP2","QUANT","N",07,0)
	
	tmp2->(dbgotop())
	_nmed:=tmp2->quant
	tmp2->(dbclosearea())

	sb1->(dbseek(_cfilsb1+tmp1->produto))
	// SALDO ATUAL E EMPENHO
	if sb2->(dbseek(_cfilsb2+sb1->b1_cod+sb1->b1_locpad))
		_nsaldo:=int(sb2->b2_qatu-sb2->b2_reserva-sb2->b2_qemp)
		_nempen:=int(sb2->b2_reserva+sb2->b2_qemp)
		_cm1:=sb2->b2_cm1
	else
		_nsaldo:=0
		_nempen:=0
		_cm1:=0
	endif

	aadd(_acom,{sb1->b1_cod,sb1->b1_desc,sb1->b1_um,((_nent+_nent2)/6),(_nmed+_nempen)/6,_nsaldo,_nempen,(_nsaldo)/((_nmed+_nempen)/6),_cm1,(_cm1*_nsaldo)})
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end
                               
if lcontinua
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
   _nentt:=0
	_nsatt:=0
	_nest :=0
	_nemp :=0
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif       

	for _i:=1 to len(_acom)
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif       
		if _acom[_i,6] > 0 .or. _acom[_i,7] > 0 .or. _acom[_i,4] > 0 .or. _acom[_i,5] > 0

			@ prow()+1,000 PSAY left(_acom[_i,1],6)               	     		// Código Produto
			@ prow() ,007   PSAY left(_acom[_i,2],30)									// Descrição Produto
			@ prow() ,039   PSAY _acom[_i,3]												// Unidade Medida
			@ prow() ,042   PSAY _acom[_i,4]  picture "@E 99,999,999.99"		// Média Compras
			@ prow() ,056   PSAY _acom[_i,5]  picture "@E 99,999,999.99"		// Média Consumo
			@ prow() ,070   PSAY _acom[_i,6]  picture "@E 99,999,999.99"		// Estoque atual
			@ prow() ,084   PSAY _acom[_i,7]  picture "@E 99,999,999.99999"		// Empenho
			@ prow() ,098   PSAY _acom[_i,8]  picture "@E 999,999.99999"			// Qtde. Mes - Estoque
			if mv_par07=1
				@ prow() ,108   PSAY _acom[_i,9]  picture "@E 999,999.99999"		// Custo Médio
				@ prow() ,119   PSAY _acom[_i,10] picture "@E 99,999,999.99"		// Custo Total (Custo Médio * Est. Atual)
			endif	
		endif	
	next

	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif       

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
_cquery+=" B1_COD PRODUTO,B1_LOCPAD LOCPAD"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"  
_cquery +=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery +=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY"
_cquery+=" B1_DESC"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"      ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Imprime Custo      ?","mv_ch7","N",01,0,0,"C",space(60),"mv_par07"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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
Movimento entre: 99/99/99 e 99/99/99                Media         Media       Estoque              Qtde.Mes      Custo         Custo
Codigo Descricao                       UM         Compras       Consumo         Atual      Empenho  Estoque      Medio         Total
999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX  99,999,999.99 99,999,999.99 99,999,999.99 9,999,999.99 9,999.99 999,999.99 99,999,999.99
*/

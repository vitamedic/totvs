/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT058   ³ Autor ³ Gardenia Ilany        ³ Data ³ 22/04/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Solicitacoes de Compras                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
Do numero
Ate o numero
Lista quais    (Todas / Em aberto)
Da data
Ate a data
Considera SCs  (Firmes / Previstas / Ambas)
Tipo relatorio (Analitico / Sintetico)
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT058()   

nordem  :=""
tamanho :="G"
limite  :=180
titulo  :="RELACAO DE SOLICITACOES DE COMPRAS"
cdesc1  :="Este programa ira emitir a relacao de pedidos para cotacao de frete"
cdesc2  :=""
cdesc3  :=""
cstring :="SC2"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT058"
wnrel   :="VIT058"+Alltrim(cusername)
alinha  :={}
nlastkey:=0
lcontinua:=.t.  
Private _prodprc := " " 
Private _Dt      := CToD("  /  /   ")

cperg:="PERGVIT058"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.t.)

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

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=180
_teste:=0
cbtxt :=space(10)
if mv_par07==1
	cabec1:="                                                                 QUANTIDADE"
	cabec2:="IT  PROD.   DESCRICAO                                TP GRUP   SOLICITADA UM  SALDO DA SC U.COMPRA     ULTIMO PRECO    VALOR TOTAL      C.CUSTO   DT.NECES     LTIM_SPT    Ult Valor Ano   OBS"
//	cabec2:="IT PRODUTO DESCRICAO                                   TP GRUP   SOLICITADA UM  SALDO DA SC U.COMPRA     ULTIMO PRECO    VALOR TOTAL C.Custo OBS"
else
	cabec1:="                                                                 QUANTIDADE"
	cabec2:="PRODUTO DESCRICAO                                      TP GRUP   SOLICITADA UM    SALDO SCs U.COMPRA     ULTIMO PRECO    VALOR TOTAL    C.CUSTO    OBS"
endif

_cfilsb1:=xfilial("SB1")
_cfilsc1:=xfilial("SC1")
_cfilsa5:=xfilial("SA5")
sb1->(dbsetorder(1))
sc1->(dbsetorder(1))
sa5->(dbsetorder(2))

setprc(0,0)

setregua(sc1->(lastrec()))

_aprod:={}
_ntotquant:=0
_ntotsaldo:=0
_ntotvalor:=0
sc1->(dbseek(_cfilsc1+mv_par01,.t.))
while ! sc1->(eof()) .and. sc1->c1_filial==_cfilsc1 .and.;
		sc1->c1_num<=mv_par02 .and. lcontinua
	if if(mv_par03==1,.t.,sc1->c1_quant>sc1->c1_quje) .and.;
		sc1->c1_emissao>=mv_par04 .and. sc1->c1_emissao<=mv_par05 .and.;
		if(mv_par06==1,sc1->c1_tpop=="F",if(mv_par06==2,sc1->c1_tpop=="P",.t.))
		if mv_par07==1
			if prow()==0 .or. prow()>54
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
			endif
			@ prow()+2,000 PSAY "NUMERO: "+sc1->c1_num
			@ prow(),015   PSAY "EMISSAO: "+dtoc(sc1->c1_emissao)
			@ prow(),033   PSAY "SOLICITANTE: "+sc1->c1_solicit
			_nquantsc:=0
			_nsaldosc:=0
			_nvalorsc:=0
			_cnum:=sc1->c1_num
			while ! sc1->(eof()) .and. sc1->c1_filial==_cfilsc1 .and.;
					sc1->c1_num==_cnum
				incregua()
				if if(mv_par03==1,.t.,sc1->c1_quant>sc1->c1_quje) .and.;
					sc1->c1_emissao>=mv_par04 .and. sc1->c1_emissao<=mv_par05 .and.;
					if(mv_par06==1,sc1->c1_tpop=="F",if(mv_par06==2,sc1->c1_tpop=="P",.t.))
					sb1->(dbseek(_cfilsb1+sc1->c1_produto))
					_nsaldo:=sc1->c1_quant-sc1->c1_quje
					_nvalor:=round(_nsaldo*sb1->b1_uprc,2)
					if prow()==0 .or. prow()>54
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
					endif

					/* LEAD TIME SUPRIMENTOS */
					_cquery:=" SELECT"
					_cquery+=" MAX(A5_LEADTIM) LEADTIME"
					_cquery+=" FROM "
					_cquery+=  retsqlname("SA5")+" SA5"

					_cquery+=" WHERE"
					_cquery+="     SA5.D_E_L_E_T_<>'*'"
					_cquery+=" AND A5_FILIAL='"+_cfilsa5+"'"
					_cquery+=" AND A5_PRODUTO='"+sc1->c1_produto+"'"
//					_cquery+=" AND A5_MSBLQL<>'2'"
					
					_cquery:=changequery(_cquery)
					
					tcquery _cquery new alias "TMP1"
					
					tmp1->(dbgotop())
															
					_leadtime:= 0
					_leadtime:= tmp1->leadtime
			
					tmp1->(dbclosearea())
				
//IT  PROD.   DESCRICAO                                TP GRUP   SOLICITADA UM  SALDO DA SC U.COMPRA     ULTIMO PRECO    VALOR TOTAL C.CUSTO   DT.NECES LTIM_SPT OBS
//999 999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXX 9999.999,999 XX 9999.999,999 99/99/99 999.999.999,9999 999.999.999,99 999999999 99/99/99 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
			  		_prodprc := sc1->c1_produto  //Ricardo MOreira 17/11/2016 
			  		_Dt := FirstYDate( dDatabase )              
				   
					@ prow()+1,000 PSAY substr(sc1->c1_item,2,3)
					@ prow(),004   PSAY substr(sc1->c1_produto,1,6)
					@ prow(),012   PSAY substr(sc1->c1_descri,1,40)
					@ prow(),053   PSAY sb1->b1_tipo
					@ prow(),056   PSAY sb1->b1_grupo
					@ prow(),061   PSAY sc1->c1_quant picture "@E 9999,999.999"
					@ prow(),074   PSAY sc1->c1_um
					@ prow(),077   PSAY _nsaldo       picture "@E 9999,999.999"
					@ prow(),090   PSAY sb1->b1_ucom
					@ prow(),099   PSAY sb1->b1_uprc  picture "@E 999,999,999.9999"
					@ prow(),116   PSAY _nvalor       picture "@E 999,999,999.99"
					@ prow(),131   PSAY sc1->c1_cc    picture "@E 999999999"
					@ prow(),141   PSAY sc1->c1_datprf              
					if _leadtime>0
						@ prow(),156   PSAY sc1->c1_emissao+_leadtime
					endif
					_teste := VAL(RtPrAno())
					@ prow(),170   PSAY _teste  picture "@E 999,999,999.99"     //Ricardo Moreira Adicionar o Ult preço do ano passado
				   	@ prow(),190   PSAY sc1->c1_obs
					_nquantsc+=sc1->c1_quant
					_nsaldosc+=_nsaldo
					_nvalorsc+=_nvalor
				endif
				sc1->(dbskip())
			end
			@ prow()+1,000 PSAY replicate("-",limite)
			@ prow()+1,000 PSAY "TOTAL DA SC "+_cnum
			@ prow(),063   PSAY _nquantsc picture "@E 999,999,999.999"
			@ prow(),079   PSAY _nsaldosc picture "@E 999,999,999.999"
			@ prow(),118   PSAY _nvalorsc picture "@E 999,999,999.99"
			_ntotquant+=_nquantsc
			_ntotsaldo+=_nsaldosc
			_ntotvalor+=_nvalorsc
		else
			incregua()
			_nsaldo:=sc1->c1_quant-sc1->c1_quje
			_i:=ascan(_aprod,{|x| x[1]==sc1->c1_produto})
			if _i==0
				aadd(_aprod,{sc1->c1_produto,sc1->c1_quant,_nsaldo})
			else
				_aprod[_i,2]+=sc1->c1_quant
				_aprod[_i,3]+=_nsaldo
			endif
			sc1->(dbskip())
		endif
	else
		incregua()
		sc1->(dbskip())
	endif
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end

if mv_par07==2 .and. len(_aprod)>0 .and. lcontinua
	_aprods:=asort(_aprod,,,{|x,y| x[1]<y[1]})
	for _i:=1 to len(_aprods)
		if prow()==0 .or. prow()>54
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
		endif
		sb1->(dbseek(_cfilsb1+_aprods[_i,1]))
		_nvalor:=round(_aprods[_i,3]*sb1->b1_uprc,2)
		@ prow()+1,000 PSAY substr(_aprods[_i,1],1,6)
		@ prow(),008   PSAY substr(sb1->b1_desc,1,46)
		@ prow(),055   PSAY sb1->b1_tipo
		@ prow(),058   PSAY sb1->b1_grupo
		@ prow(),063   PSAY _aprods[_i,2] picture "@E 9999,999.999"
		@ prow(),076   PSAY sb1->b1_um
		@ prow(),079   PSAY _aprods[_i,3] picture "@E 9999,999.999"
		@ prow(),092   PSAY sb1->b1_ucom
		@ prow(),101   PSAY sb1->b1_uprc  picture "@E 999,999,999.99999"
		@ prow(),118   PSAY _nvalor       picture "@E 999,999,999.99"
		@ prow(),133   PSAY sc1->c1_cc picture "@E 999999999"
		@ prow(),144   PSAY sc1->c1_obs
		_ntotquant+=_aprods[_i,2]
		_ntotsaldo+=_aprods[_i,3]
		_ntotvalor+=_nvalor
	next
endif

if (_ntotquant>0 .or. _ntotsaldo>0 .or. _ntotvalor>0) .and. lcontinua
	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "TOTAL DO RELATORIO"
	@ prow(),063   PSAY _ntotquant picture "@E 999,999,999.999"
	@ prow(),079   PSAY _ntotsaldo picture "@E 999,999,999.999"
	@ prow(),118   PSAY _ntotvalor picture "@E 999,999,999.99"  
	
	
	//Ricardo Moreira 14/11/2016
	@ prow()+3,065   PSAY "SOLICITANTE "   //sc1->c1_solicit
	@ prow(),125     PSAY " APROVADOR "   //sc1->c1_nomapro 
	@ prow()+3,045 PSAY replicate("-",50)
	@ prow(),105 PSAY replicate("-",50)
	@ prow()+1,065   PSAY sc1->c1_solicit   //sc1->c1_solicit
	@ prow(),124   PSAY sc1->c1_nomapro  //sc1->c1_nomapro
	
	roda(cbcont,cbtxt)
endif
 



set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do numero          ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o numero       ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Lista quais        ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03"       ,"Todas"          ,space(30),space(15),"Em aberto"      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Da data            ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Ate a data         ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Considera SCs      ?","mv_ch6","N",01,0,0,"C",space(60),"mv_par06"       ,"Firmes"         ,space(30),space(15),"Previstas"      ,space(30),space(15),"Ambas"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Tipo do relatorio  ?","mv_ch7","N",01,0,0,"C",space(60),"mv_par07"       ,"Analitico"      ,space(30),space(15),"Sintetico"      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
ANALITICO
NUMERO: 999999 EMISSAO: 99/99/99 SOLICITANTE: XXXXXXXXXXXXXXX
                                                                 QUANTIDADE
IT PRODUTO DESCRICAO                                   TP GRUP   SOLICITADA UM  SALDO DA SC U.COMPRA     ULTIMO PRECO    VALOR TOTAL
99 XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXX 9999.999,999 XX 9999.999,999 99/99/99 999.999.999,9999 999.999.999,99

SINTETICO
                                                                 QUANTIDADE
PRODUTO DESCRICAO                                      TP GRUP   SOLICITADA UM    SALDO SCs U.COMPRA     ULTIMO PRECO    VALOR TOTAL
XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXX 9999.999,999 XX 9999.999,999 99/99/99 999.999.999,9999 999.999.999,99
*/                                                      



//Vitamedic
//Data: 17/11/2016
//Retorna o preço do ultimo ano
//Autor: Ricardo Moreira                                        

Static Function RtPrAno() // U_RtPrAno()                                                       
Local _Valor := " "

If Select("TMP5") > 0
	TMP5->(dbCloseArea())
EndIf

_cQry := " SELECT * FROM  "
_cQry += "( SELECT D1_VUNIT Preco "
_cQry += "FROM " + retsqlname("SD1")+" SD1 " 
_cQry += "WHERE   D_E_L_E_T_ <> '*' "
_cQry += "AND   D1_COD	= '" + _prodprc + "' 
_cQry += "AND   D1_EMISSAO	< '" + DTOS(_Dt) + "' 
_cQry += "AND   D1_QUANT > 0 "
_cQry += "ORDER BY D1_EMISSAO DESC) "
_cQry += "WHERE ROWNUM = 1 "  

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP5"

dbselectarea("TMP5")
DBGOTOP()
  
	_Valor := cvaltochar(TMP5->Preco)

Return _Valor 


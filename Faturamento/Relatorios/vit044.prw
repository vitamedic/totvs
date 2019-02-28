/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT044   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 05/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Preco Medio de Venda de Produtos - Pedidos                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit044()
cArq:=""
cInd:=""
aStru:={}

@ 0,0 To 260 , 200 Dialog oDialog Title OemToAnsi("Curva ABC - Pedidos")
@ 010,10	 Button OemToAnsi("_Relatorio") 	Size 80,30 Action _ProcRel()
@ 050,10  Button OemToAnsi("_E-Mail")   	Size 80,30 Action _Mail()
@ 090,10  Button OemToAnsi("_Cancela") 	Size 80,30 Action Close(oDialog)
Activate Dialog oDialog Centered

return

Static Function _Mail()
Close(oDialog)
ExecBlock("VIT147",.F.,.F.)
Return

//user function VIT044()
static function _ProcRel()
Close(oDialog)
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="CURVA ABC - PEDIDOS"
cdesc1  :="Este programa ira emitir a relacao do preco medio de venda de produtos"
cdesc2  :=""
cdesc3  :=""
cstring :="SC6"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT044"
wnrel   :="VIT044"+Alltrim(cusername)
alinha  :={}
aordem  :={"Codigo","Descricao","Quantidade","Valor"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.

cperg:="PERGVIT044"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

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
li    :=80
cbtxt :=space(10)

_cfilsb1:=xfilial("SB1")
_cfilsc6:=xfilial("SC6")
_cfilsf4:=xfilial("SF4")
_cfilsc5:=xfilial("SC5")
_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")

sb1->(dbsetorder(1))
sa3->(dbsetorder(1))
sc5->(dbsetorder(2))
sc6->(dbsetorder(1))
sf4->(dbsetorder(1))
sa1->(dbsetorder(1))

_represent:=""

if !empty(mv_par12)
	sa3->(dbseek(_cfilsa3+mv_par12))
	_represent:=sa3->a3_nome	
	cabec1:="PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)+"     - REPRESENTANTE: "+_represent
else
	cabec1:="PERIODO DE "+dtoc(mv_par01)+" A "+dtoc(mv_par02)
endif

cabec2:="Ordem Codigo Descricao                       Qtd.Pedido Qtd.Entregue          Valor       Vl.Entrege Preco Medio    %   % Acum  "

_aestrut:={}
aadd(_aestrut,{"PRODUTO"  ,"C",15,0})
aadd(_aestrut,{"DESCRICAO","C",40,0})
aadd(_aestrut,{"QUANT"    ,"N",09,0})
aadd(_aestrut,{"VALOR"    ,"N",12,2})
aadd(_aestrut,{"APRVEN"   ,"C",1,0})
aadd(_aestrut,{"CLIENTE"  ,"C",40,0})
aadd(_aestrut,{"UF"       ,"C",02,0})
aadd(_aestrut,{"QTENT"    ,"N",09,0})
aadd(_aestrut,{"VLLISTA"  ,"N",12,2})
aadd(_aestrut,{"PRVEN"    ,"N",12,2})
aadd(_aestrut,{"QTPED"    ,"N",09,0})
aadd(_aestrut,{"PEDIDO"   ,"C",06,0}) 
aadd(_aestrut,{"PORC"     ,"N",02,0})

_carqtmp2:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp2,"TMP2",.f.)
_cindtmp21:=criatrab(,.f.)
_cchave   :="produto"
tmp2->(indregua("TMP2",_cindtmp21,_cchave))
if nordem==1
	_cindtmp22:=criatrab(,.f.)
	_cchave   :="aprven+produto"
	tmp2->(indregua("TMP2",_cindtmp22,_cchave))
elseif nordem==2
	_cindtmp22:=criatrab(,.f.)
	_cchave   :="aprven+descricao+produto"
	tmp2->(indregua("TMP2",_cindtmp22,_cchave))
elseif nordem==3
	_cindtmp22:=criatrab(,.f.)
	_cchave   :="aprven+strzero(quant,09)+descricao+produto"
	tmp2->(indregua("TMP2",_cindtmp22,_cchave))
elseif nordem==4
	_cindtmp22:=criatrab(,.f.)
	_cchave   :="aprven+strzero(valor,12,2)+descricao+produto"
	tmp2->(indregua("TMP2",_cindtmp22,_cchave))
endif
//if nordem>1
tmp2->(dbclearind())
tmp2->(dbsetindex(_cindtmp21))
tmp2->(dbsetindex(_cindtmp22))
tmp2->(dbsetorder(1))
//endif
_ntotvalor:=0
_nqtped := 0
_ntotquant:=0

// PESQUISA CODIGO DO SUPERVISOR
sa3->(dbsetorder(7))
if sa3->(dbseek(_cfilsa3+__cuserid))
	_cgerente:=sa3->a3_cod
else
	_cgerente:=space(6)
endif


processa({|| _calcmov()})

setregua(tmp2->(lastrec()))

setprc(0,0)

tmp2->(dbsetorder(2))

_i     :=1
_npacum:=0
_caprven :=" "
_ntotlin := 0
_ntotvlin :=0
_ntotquant:=0
_nvalor := 0
_ntentlin := 0
_ntotent := 0
_ndscmed := 0
_ntprent := 0
_nprent := 0
_j :=1
if nordem>2
	tmp2->(dbgobottom())
else
	tmp2->(dbgotop())
endif
while if(nordem>2,! tmp2->(bof()),! tmp2->(eof())) .and.;
	lcontinua
	incregua()
	if prow()==0 .or. prow()>55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif
//_nprmed:=(round(tmp2->valor/tmp2->quant,2) ricardo moreira 29/09/2015

//_nprmed:=(round(tmp2->valor/tmp2->quant-(tmp2->valor*(tmp2->porc/100))/tmp2->quant,2))
_nprmed:=(tmp2->valor/tmp2->quant-(tmp2->valor*(tmp2->porc/100))/tmp2->quant)
	tmp2->porc
	_ndscmed:=round(((tmp2->vllista/tmp2->qtped))*100,2)
	_nperc :=round((tmp2->valor/_ntotvalor)*100,2)
	_npacum+=_nperc
	if _caprven<>tmp2->aprven
		if _ntotquant>0
			@ prow()+1,000 PSAY "TOTAL LINHA"+if(_caprven="1"," FARMA:"," HOSPITALAR")
			@ prow(),044   PSAY _ntotquant picture "@E 999,999,999"
			@ prow(),056   PSAY _ntotent picture "@E 999,999,999"
			@ prow(),068   PSAY _nvalor picture "@E 999,999,999.99"
			@ prow(),083   PSAY _nprent picture "@E 999,999,999.99"
			@ prow()+1,000 PSAY ""
			_ntentlin += _ntotent
			_ntotlin +=_ntotquant
			_ntotvlin += _nvalor
			_ntprent += _nprent
			_nprent := 0
			_ntotquant:=0
			_nvalor := 0
			_ntotent:=0
			_i:=0
		endif
		_caprven:=tmp2->aprven
	endif
	if !empty(mv_par09) .and. _j =1
		@ prow()+1,000 PSAY tmp2->cliente
		@ prow()+1,000 PSAY ""
	endif
	if !empty(mv_par11) .and. _j =1
		@ prow()+1,000 PSAY tmp2->uf
		@ prow()+1,000 PSAY ""
	endif
	@ prow()+1,000 PSAY _i          picture "99999"
	@ prow(),006   PSAY left(tmp2->produto,6)
	@ prow(),013   PSAY SUBSTR(tmp2->descricao,1,30)
	@ prow(),044   PSAY tmp2->quant picture "@E 999,999,999"
	@ prow(),056   PSAY tmp2->qtent picture "@E 999,999,999"
	@ prow(),068   PSAY tmp2->valor picture "@E 999,999,999.99"
	@ prow(),083   PSAY tmp2->qtent*_nprmed picture "@E 999,999,999.99"
	@ prow(),099   PSAY _nprmed     picture "@E 999,999.99"
	@ prow(),111   PSAY _nperc      picture "@E 999.99"
	@ prow(),118   PSAY _npacum     picture "@E 999.99"
	
	//	if tmp1->aprven<> "2"
	// 		@ prow(),118   PSAY _ndscmed   picture "@E 999.99"
	// 	endif
	_ntotquant+=tmp2->quant
	_ntotent += tmp2->qtent
	_nvalor +=tmp2->valor
	_nprent +=_nprmed *tmp2->qtent
	_i++
	_j++
	if nordem>2
		tmp2->(dbskip(-1))
	else
		tmp2->(dbskip())
	endif
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end
if _ntotquant>0
	if prow()==0 .or. prow()>55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif

	@ prow()+1,000 PSAY "TOTAL LINHA "+if(_caprven="1"," FARMA:"," HOSPITALAR:")
	@ prow(),044   PSAY _ntotquant picture "@E 999,999,999"
	@ prow(),056   PSAY _ntotent picture "@E 999,999,999"
	@ prow(),068   PSAY _nvalor picture "@E 999,999,999.99"
	@ prow(),083   PSAY _nprent picture "@E 999,999,999.99"
	@ prow()+1,000 PSAY ""
	_ntentlin += _ntotent
	_ntotlin +=_ntotquant
	_ntotvlin+=_nvalor
	_ntprent +=_nprent
	_ntotquant:=0
endif
if prow()>0 .and.;
	lcontinua                 
		if prow()==0 .or. prow()>55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif

	@ prow()+1,000 PSAY replicate("-",limite)
	@ prow()+1,000 PSAY "TOTAL"
	@ prow(),044   PSAY _ntotlin picture  "@E 999,999,999"
	@ prow(),056   PSAY _ntentlin picture "@E 999,999,999"
	@ prow(),068   PSAY _ntotvlin picture "@E 999,999,999.99"
	@ prow(),083   PSAY _ntprent picture "@E 999,999,999.99"
	roda(cbcont,cbtxt)
endif
_cindtmp21+=tmp2->(ordbagext())
if nordem>1
	_cindtmp22+=tmp2->(ordbagext())
endif
tmp2->(dbclosearea())
ferase(_carqtmp2+getdbextension())
ferase(_cindtmp21)
if nordem>1
	ferase(_cindtmp22)
endif

set device to screen
if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return


static function _calcmov()
_descon := 0
procregua(sc5->(lastrec()))
sc5->(dbseek(_cfilsc5+dtos(mv_par01),.t.))
while ! sc5->(eof()) .and.;
	sc5->c5_filial==_cfilsc5 .and.;
	sc5->c5_emissao<=mv_par02
	// Valida Gerente Regional  
	sa3->(dbsetorder(1))	
	sa3->(dbseek(_cfilsa3+sc5->c5_vend1))
	_mger:=if(empty(_cgerente),.t.,if(_cgerente > "001000",sa3->a3_super==_cgerente,sa3->a3_cod==_cgerente)) // Valida Gerente Regional
	
 	if empty(mv_par12) .or.;
 	 	(sc5->c5_vend1=mv_par12)

		if _mger

			sc6->(dbseek(_cfilsc6+sc5->c5_num,.t.))
			while !sc6->(eof()) .and.;
				sc6->c6_filial==_cfilsc6 .and.;
				sc6->c6_num = sc5->c5_num
				incproc("Processando pedidos : "+dtoc(sc5->c5_emissao))
				if sc6->c6_produto>=mv_par03 .and.;
					sc6->c6_produto<=mv_par04 .and.;
					sc5->c5_tipo=="N"
					sf4->(dbseek(_cfilsf4+sc6->c6_tes))
								
					if sf4->f4_estoque=="S" .and.;
						sf4->f4_duplic=="S"
						sb1->(dbseek(_cfilsb1+sc6->c6_produto))
						if sb1->b1_tipo>=mv_par05 .and.;
							sb1->b1_tipo<=mv_par06 .and.;
							sb1->b1_grupo>=mv_par07 .and.;
							sb1->b1_grupo<=mv_par08
         	
							if !empty(mv_par09)
//								sc5->(dbseek(_cfilsc5+sc6->c6_num))
								sa1->(dbseek(_cfilsa1+sc5->c5_cliente+sc5->c5_lojacli))
								if sc5->c5_cliente== mv_par09	.and. sc5->c5_lojacli == mv_par10
		
									if ! tmp2->(dbseek(sc6->c6_produto))
										tmp2->(dbappend())
										tmp2->produto  :=sc6->c6_produto
										tmp2->descricao:=sb1->b1_desc
										tmp2->quant    :=sc6->c6_qtdven && -sc6->c6_qtdent
										tmp2->valor    :=sc6->c6_valor
										tmp2->prven    :=sc6->c6_prcven
										tmp2->aprven   :=sb1->b1_apreven
										tmp2->cliente  :=substr(sa1->a1_nome,1,40)
										tmp2->qtent    :=sc6->c6_qtdent && -sc6->c6_qtdent
										tmp2->vllista  :=sc6->c6_prunit && -sc6->c6_qtdent
										tmp2->qtped    :=1 && -sc6->c6_qtdent             
										tmp2->pedido   :=sc6->c6_num //Ricardo Moreira 29/09/2015
										_descon        :=POSICIONE("SC5",1,XFILIAL("SC5")+tmp2->pedido,"C5_PDESCAB")
										tmp2->porc     :=_descon
										
									else
										tmp2->quant    +=sc6->c6_qtdven && -sc6->c6_qtdent
										tmp2->valor    +=sc6->c6_valor
										tmp2->prven    +=sc6->c6_prcven
										tmp2->qtent    +=sc6->c6_qtdent && -sc6->c6_qtdent
										if !empty(sc6->c6_descont)
											tmp2->vllista  +=sc6->c6_prunit && -sc6->c6_qtdent
											tmp2->qtped    +=1 && -sc6->c6_qtdent
										endif
									endif
								endif
							elseif !empty(mv_par11)
												
								sa1->(dbseek(_cfilsa1+sc5->c5_cliente+sc5->c5_lojacli))
								if sa1->a1_est== alltrim(mv_par11)
									if ! tmp2->(dbseek(sc6->c6_produto))
										tmp2->(dbappend())
										tmp2->produto  :=sc6->c6_produto
										tmp2->descricao:=sb1->b1_desc
										tmp2->quant    :=sc6->c6_qtdven && -sc6->c6_qtdent
										tmp2->qtent    :=sc6->c6_qtdent && -sc6->c6_qtdent
										tmp2->valor    :=sc6->c6_valor
										tmp2->aprven   :=sb1->b1_apreven
										tmp2->uf       :=sa1->a1_est
										tmp2->vllista  :=sc6->c6_prunit && -sc6->c6_qtdent
										tmp2->qtped    :=1 && -sc6->c6_qtdent
										tmp2->pedido   :=sc6->c6_num//Ricardo Moreira 29/09/2015
										tmp2->porc     :=POSICIONE("SC5",1,XFILIAL("SC5")+tmp2->pedido,"C5_PDESCAB")
									else
										tmp2->quant    +=sc6->c6_qtdven && -sc6->c6_qtdent
										tmp2->qtent    +=sc6->c6_qtdent && -sc6->c6_qtdent
										tmp2->valor    +=sc6->c6_valor
										tmp2->prven    +=sc6->c6_prcven
										if !empty(sc6->c6_descont)
											tmp2->vllista  +=sc6->c6_prunit && -sc6->c6_qtdent
											tmp2->qtped    +=1 && -sc6->c6_qtdent
										endif
									endif
								endif
							else
								if ! tmp2->(dbseek(sc6->c6_produto))
									tmp2->(dbappend())
									tmp2->produto  :=sc6->c6_produto
									tmp2->descricao:=sb1->b1_desc
									tmp2->quant    :=sc6->c6_qtdven && -sc6->c6_qtdent
									tmp2->valor    :=sc6->c6_valor
									tmp2->prven    :=sc6->c6_prcven
									tmp2->aprven   :=sb1->b1_apreven
									tmp2->prven    :=sc6->c6_prcven
									tmp2->qtent    :=sc6->c6_qtdent && -sc6->c6_qtdent
									tmp2->vllista  :=sc6->c6_prunit && -sc6->c6_qtdent
									tmp2->qtped    :=1 && -sc6->c6_qtdent                                   
									tmp2->pedido   :=sc6->c6_num//Ricardo Moreira 29/09/2015 
									tmp2->porc     :=POSICIONE("SC5",1,XFILIAL("SC5")+tmp2->pedido,"C5_PDESCAB")
								else
									tmp2->quant    +=sc6->c6_qtdven && -sc6->c6_qtdent
									tmp2->valor    +=sc6->c6_valor
									tmp2->qtent    +=sc6->c6_qtdent && -sc6->c6_qtdent
									tmp2->prven    +=sc6->c6_prcven
									if !empty(sc6->c6_descont)
										tmp2->vllista  +=sc6->c6_prunit && -sc6->c6_qtdent
										tmp2->qtped    +=1 && -sc6->c6_qtdent
									endif
								endif
							endif
							_ntotvalor+=sc6->c6_valor
						endif
					endif
				endif
				sc6->(dbskip())
			end	
		endif
	endif
	sc5->(dbskip())
end
return



static function _geratmp()
procregua(1)
incproc("Calculando pedidos...")
_cquery:=" SELECT"
_cquery+=" C6_PRODUTO PRODUTO,"
_cquery+=" ' ' D_E_L_E_T_"
_cquery+=" FROM "
_cquery+=" SC5010 SC5,"
_cquery+=" SC6010 SC6,"
_cquery+=" SF4010 SF4,"
_cquery+=" SB1010 SB1"
_cquery+=" WHERE"
_cquery+="     SC5.D_E_L_E_T_<>'*'"
_cquery+=" AND SC6.D_E_L_E_T_<>'*'"
_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
_cquery+=" AND SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND C5_FILIAL='"+_cfilsc5+"'"
_cquery+=" AND C6_FILIAL='"+_cfilsc6+"'"
_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND C6_NUM=C5_NUM"
_cquery+=" AND C6_TES=F4_CODIGO"
_cquery+=" AND F4_DUPLIC='S'"
_cquery+=" AND C5_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND C5_TIPO='N'"
_cquery+=" AND C6_BLQ<>'R '"
_cquery+=" AND C6_PRODUTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND B1_TIPO  BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" GROUP BY"
_cquery+=" C6_PRODUTO"
_cquery+=" ORDER BY"
_cquery+=" C6_PRODUTO"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMPA"

return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Do tipo            ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Ate o tipo         ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"07","Do grupo           ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"08","Ate o grupo        ?","mv_ch8","C",04,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"09","Do cliente         ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"10","Loja               ?","mv_chA","C",02,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"  "})
aadd(_agrpsx1,{cperg,"11","Do estado          ?","mv_chB","C",02,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"12","Do representante   ?","mv_chC","C",06,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})

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
Ordem Codigo Descricao                                 Quantidade  Valor vendido Preco Medio   %    % acum
99999 999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 999.999.999 999.999.999,99  999.999,99 999,99 999,99
*/

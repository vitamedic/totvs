/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT236   ³ Autor ³ Gardenia Ilany        ³ Data ³ 15/08/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Materiais sem Momimentacao / Lote                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function VIT236()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="MATERIAIS S/ MOVIMENTACAO /LOTE"
cdesc1   :="Este programa ira emitir os materiais s/movimentação /lote "
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT236"
wnrel    :="VIT236"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT236"
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
li    :=80
cbtxt :=space(10)
titulo:="MATERIAIS S/ MOVIMENTACAO /LOTE"

_dinimed :=mv_par07
_datasaldo := ctod("  /  /  ")

if mv_par09=2
	_ddia := day(mv_par08)
	_datasaldo := ctod(strzero(_ddia,2)+"/"+strzero(month(mv_par08),2)+"/"+strzero(year(mv_par08),4))
	
	while empty(_datasaldo)
		_datasaldo := ctod(strzero(_ddia,2)+"/"+strzero(month(mv_par08),2)+"/"+strzero(year(mv_par08),4))
		_ddia --
	end
endif

_dfimmed := mv_par08

cabec1:="Periodo de " +dtoc(_dinimed)+" ate "+dtoc(_dfimmed)
cabec2:="Codigo Descricao                                 UM   Sld.Estoque    Lote    Validade   Ult.Movim.  Ult.compra   Cst. Total"

_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb8:=xfilial("SB8")
_cfilsb9:=xfilial("SB9")
_cfilsbj:=xfilial("SBJ")
_cfilsd2:=xfilial("SD2")
_cfilsd3:=xfilial("SD3")
_cfilsf4:=xfilial("SF4")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sb8->(dbsetorder(1))
sb9->(dbsetorder(1))
sbj->(dbsetorder(2))
sf4->(dbsetorder(1))
sd2->(dbsetorder(6))
sd3->(dbsetorder(7))
_acom    :={}


processa({|| _geratmp()})

setprc(0,0)
_tvatu :=0

setregua(sb1->(lastrec()))
tmp1->(dbgotop())

while ! tmp1->(eof()) .and.;
	lcontinua
	
	incproc("Verificando Saldos e ...")
	sb1->(dbseek(_cfilsb1+tmp1->produto))
	_local:=sb1->b1_locpad
	
	//VERIFICA ÚLTIMA MOVIMENTAÇÃO E SALDO EM ESTOQUE
	
	_saldo:=0
	
	if mv_par09=1
		sb2->(dbseek(_cfilsb2+tmp1->produto+_local))
		_saldo:=sb2->b2_qatu
	else
		sb9->(dbseek(_cfilsb9+tmp1->produto+_local+dtos(_datasaldo)))
		_saldo:=sb9->b9_qini
	endif
	
	if _saldo>0
		
		//MOVIMENTAÇÃO DE ENTRADA DE PRODUÇÃO OU SAÍDAS
		_cquery:=" SELECT"
		_cquery+=" D3_COD COD"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SD3")+" SD3"
		_cquery+=" WHERE "
		_cquery+="     SD3.D_E_L_E_T_<>'*'"
		_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
		_cquery+=" AND D3_COD='"+tmp1->produto+"'"
		_cquery+=" AND (D3_TM>'500' OR D3_TM='001')"
		_cquery+=" AND D3_DOC<>'INVENT'"
		_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(_dinimed)+"' AND '"+dtos(_dfimmed)+"'"
		_cquery+=" AND D3_ESTORNO=' '"

		//MOVIMENTAÇÃO DE SAÍDA POR NOTA FISCAL
		_cquery+=" UNION ALL"
		_cquery+=" SELECT"
		_cquery+=" D2_COD COD"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SD2")+" SD2,"
		_cquery+=  retsqlname("SF4")+" SF4"
		_cquery+=" WHERE "
		_cquery+="     SD2.D_E_L_E_T_<>'*'"
		_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
		_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
		_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
		_cquery+=" AND D2_COD='"+tmp1->produto+"'"
		_cquery+=" AND D2_TES=F4_CODIGO"
		_cquery+=" AND F4_ESTOQUE='S'"
		_cquery+=" AND D2_EMISSAO BETWEEN '"+dtos(_dinimed)+"' AND '"+dtos(_dfimmed)+"'"

		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP2" new
		tmp2->(dbgotop())
		if tmp2->cod == tmp1->produto
			_ok := .f.
		else
			_ok := .t.
		endif
		tmp2->(dbclosearea())

/*
		sd3->(dbordernickname("SD3VIT02"))
		if sd3->(dbseek(_cfilsd3+tmp1->produto+_local+dtos(_dinimed))) .and. dtos(sd3->d3_emissao)>=dtos(_dinimed)
			_ok:= .t.
		else
			sd3->(dbskip())
		endif
		
		while ! sd3->(eof()) .and. ;
				sd3->d3_cod=tmp1->produto .and. ;
				sd3->d3_local=_local .and.;
				dtos(sd3->d3_emissao)<=dtos(_dfimmed) .and. ;
				_ok
				
			if sd3->d3_tm>500 .and.;
				sd3->d3_doc<>'INVENT'
		
				_ok:=.f.
			else
				_ok:=.t.
			endif

			sd3->(dbskip())
		end		      
*/

		if _ok
			_cquery:=" SELECT"
			_cquery+=" D3_COD COD, D3_QUANT QUANT,D3_EMISSAO EMISSAO"
			_cquery+=" FROM "
			_cquery+=  retsqlname("SD3")+" SD3"
			_cquery+=" WHERE "
			_cquery+="     SD3.D_E_L_E_T_<>'*'"
			_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
			_cquery+=" AND D3_COD='"+tmp1->produto+"'"
			_cquery+=" AND (D3_TM>'500' OR D3_TM='001')"
			_cquery+=" AND D3_DOC<>'INVENT'"
			_cquery+=" AND D3_EMISSAO<='"+dtos(_dinimed)+"'"
			_cquery+=" AND D3_ESTORNO=' '"

			_cquery+=" UNION ALL"

			_cquery+=" SELECT"
			_cquery+=" D2_COD COD, D2_QUANT QUANT,D2_EMISSAO EMISSAO"
			_cquery+=" FROM "
			_cquery+=  retsqlname("SD2")+" SD2,"
			_cquery+=  retsqlname("SF4")+" SF4"
			_cquery+=" WHERE "
			_cquery+="     SD2.D_E_L_E_T_<>'*'"
			_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
			_cquery+=" AND D2_FILIAL='"+_cfilsd2+"'"
			_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
			_cquery+=" AND D2_COD='"+tmp1->produto+"'"
			_cquery+=" AND D2_TES=F4_CODIGO"
			_cquery+=" AND F4_ESTOQUE='S'"
			_cquery+=" AND D2_EMISSAO <='"+dtos(_dinimed)+"'"

			_cquery+=" ORDER BY 3 DESC"
			
			_cquery:=changequery(_cquery)
			
			tcquery _cquery alias "TMP3" new
			tcsetfield("TMP3","EMISSAO","D",08)
			tcsetfield("TMP3","QUANT","N",15,2)
			
			tmp3->(dbgotop())
			_quant:= tmp3->quant
			_emissao:=tmp3->emissao
			tmp3->(dbclosearea())
			
			// SALDO ATUAL / EMPENHO e ULTIMA SAIDA
			
			if mv_par09=1 // CONSIDERA SALDO ATUAL
				
				sb8->(dbseek(_cfilsb8+sb1->b1_cod+sb1->b1_locpad))
				_passou:=.f.
				
				while ! sb8->(eof()) .and. sb8->b8_produto == sb1->b1_cod  .and. ;
					_local == sb8->b8_local .and. lcontinua
					
					if sb8->b8_saldo = 0
						sb8->(dbskip())
					endif
					_lote := sb8->b8_lotectl
					_dtvalid:= sb8->b8_dtvalid
					_saldolote:=0
					_empenho:=0
					
					while ! sb8->(eof()) .and. sb8->b8_produto == sb1->b1_cod .and. ;
						_lote == sb8->b8_lotectl .and. _local == sb8->b8_local .and. lcontinua
						
						_saldolote += sb8->b8_saldo
						_empenho+= sb8->b8_empenho
						sb8->(dbskip())
					end
					
					_saldolote:=_saldolote-_empenho
					
					if sb2->(dbseek(_cfilsb2+sb1->b1_cod+sb1->b1_locpad)) .and.;
						_saldolote>0
						
						_vatu:= sb2->b2_vatu1/sb2->b2_qatu
						aadd(_acom,{tmp1->produto,sb1->b1_desc,_saldolote,_lote,dtoc(_dtvalid),dtoc(_emissao),dtoc(sb1->b1_ucom),_vatu*_saldolote,sb1->b1_um})
					endif
				end
				
			else // CONSIDERA SALDO FECHAMENTO
				
				_cquery:=" SELECT"
				_cquery+=" BJ_COD COD, BJ_LOTECTL LOTE, BJ_QINI QUANT, BJ_DTVALID DTVALID"
				_cquery+=" FROM "
				_cquery+=  retsqlname("SBJ")+" SBJ"
				_cquery+=" WHERE "
				_cquery+="     SBJ.D_E_L_E_T_<>'*'"
				_cquery+=" AND BJ_FILIAL='"+_cfilsbj+"'"
				_cquery+=" AND BJ_COD='"+tmp1->produto+"'"
				_cquery+=" AND BJ_LOCAL='"+_local+"'"
				_cquery+=" AND BJ_DATA='"+dtos(_datasaldo)+"'"
				_cquery+=" AND BJ_QINI>'0'"
				_cquery+=" ORDER BY BJ_LOTECTL"
				
				_cquery:=changequery(_cquery)
				
				tcquery _cquery alias "TMP4" new
				tcsetfield("TMP4","QUANT","N",15,2)
				tcsetfield("TMP4","DTVALID","D",08)
				
				tmp4->(dbgotop())
				_passou:=.f.
				
				while ! tmp4->(eof()) .and. lcontinua
					
					_lote := tmp4->lote
					_dtvalid:= tmp4->dtvalid
					_saldolote:=0
					_empenho:=0
					
					while ! tmp4->(eof()) .and. ;
						_lote == tmp4->lote .and. lcontinua
						
						_saldolote += tmp4->quant
						tmp4->(dbskip())
					end
					
					if sb9->(dbseek(_cfilsb9+tmp1->produto+_local+dtos(_datasaldo)))
						_vatu:= sb9->b9_vini1/sb9->b9_qini
						aadd(_acom,{tmp1->produto,sb1->b1_desc,_saldolote,_lote,dtoc(_dtvalid),dtoc(_emissao),dtoc(sb1->b1_ucom),_vatu*_saldolote,sb1->b1_um})
					endif
				end
				
				tmp4->(dbclosearea())
			endif
		endif
	endif
	
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
	
	_qtotlote:=0
	_tvallote:=0
	_qtot:=0
	if len(_acom)>0
		_produto:=_acom[1,1]
	endif
	
	for _i:=1 to len(_acom)
		if prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		incregua()
			
		if _produto<>_acom[_i,1]
			@ prow()+1,010 PSAY "TOTAL PRODUTO"
			@ prow() ,053   PSAY _qtotlote picture "@E 9,999,999.99"
			@ prow() ,111   PSAY _tvallote picture "@E 9,999,999.99"
			_qtotlote:=0
			_tvallote:=0
			@ prow()+1,000 PSAY "  "			
		endif

		@ prow()+1,000 PSAY left(_acom[_i,1],6)
		@ prow() ,007   PSAY left(_acom[_i,2],40)
		@ prow() ,049   PSAY _acom[_i,9]
		@ prow() ,055   PSAY _acom[_i,3] picture "@E 999,999.99"
		@ prow() ,067   PSAY _acom[_i,4]
		@ prow() ,079   PSAY _acom[_i,5]
		@ prow() ,090   PSAY _acom[_i,6]
		@ prow() ,101   PSAY _acom[_i,7]
		@ prow() ,113   PSAY _acom[_i,8] picture "@E 999,999.99"

		_produto := _acom[_i,1]
		_qtotlote += _acom[_i,3]
		_tvallote += +_acom[_i,8]
		_qtot +=_acom[_i,3]
		_tvatu +=_acom[_i,8]

	next
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif

	@ prow()+1,010 PSAY "TOTAL PRODUTO"
	@ prow() ,053   PSAY _qtotlote picture "@E 9,999,999.99"
	@ prow() ,111   PSAY _tvallote picture "@E 9,999,999.99"

	@ prow()+2,000 PSAY "TOTAL "
	@ prow() ,111  PSAY _tvatu picture "@E 9,999,999.99"
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
_cquery+=" B1_COD PRODUTO"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"

_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND B1_ESTOQUE='S'"
_cquery+=" AND B1_RASTRO='L'"

_cquery+=" ORDER BY"
_cquery+=" B1_DESC"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Data Inicio        ?","mv_ch7","D",08,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Data Fim           ?","mv_ch8","D",08,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Saldo a Considerar ?","mv_ch9","N",01,0,0,"C",space(60),"mv_par09"       ,"Atual"          ,space(30),space(15),"Fechamento"     ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT296   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 01/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Diferencas entre Empenhos nas Tabelas           ³±±
±±³          ³ SB2, SB8, SBF, SD4, SDC                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "rwmake.ch"
#include "topconn.ch"

user function vit296()
nordem   :=""
tamanho  :="G"
limite   :=220
titulo   :="RELACAO DE DIFERENCAS ENTRE EMPENHOS"
cdesc1   :="Este programa ira emitir a relacao de diferencas entre empenhos"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT296"
wnrel    :="VIT296"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT296"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

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

rptstatus({|| rptdetail()},titulo)
return()

static function rptdetail()
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb8:=xfilial("SB8")
_cfilsbf:=xfilial("SBF")
_cfilsd4:=xfilial("SD4")
_cfilsdc:=xfilial("SDC")

cabec1:="CODIGO          DESCRICAO                                                    AR LOTE       ENDERECO"
cabec2:=""

setprc(0,0)

setregua(sb1->(lastrec()))

_cquery:=" SELECT"
_cquery+=" B1_COD,"
_cquery+=" B1_DESC,"
_cquery+=" B1_RASTRO,"
_cquery+=" B1_LOCALIZ"

_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"

_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_=' '"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"

_cquery+=" ORDER BY"
_cquery+=" B1_COD"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMPP"
u_setfield("TMPP")

tmpp->(dbgotop())
while ! tmpp->(eof()) .and.;
	lcontinua
	
	incregua("Produto: "+tmpp->b1_cod)
	
	_limpprod:=.t.
	
	sb2->(dbsetorder(1))
	sb2->(dbseek(_cfilsb2+tmpp->b1_cod+mv_par07,.t.))
	while ! sb2->(eof()) .and.;
		sb2->b2_filial==_cfilsb2 .and.;
		sb2->b2_cod==tmpp->b1_cod .and.;
		sb2->b2_local<=mv_par08
		
		_cquery:=" SELECT"
		_cquery+=" SUM(D4_QUANT) D4_QUANT"
		
		_cquery+=" FROM "
		_cquery+=  retsqlname("SD4")+" SD4"
		
		_cquery+=" WHERE"
		_cquery+="     SD4.D_E_L_E_T_=' '"
		_cquery+=" AND D4_FILIAL='"+_cfilsd4+"'"
		_cquery+=" AND D4_COD='"+tmpp->b1_cod+"'"
		_cquery+=" AND D4_LOCAL='"+sb2->b2_local+"'"
		_cquery+=" AND D4_QUANT>0"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery new alias "TMP1"
		u_setfield("TMP1")
		
		tmp1->(dbgotop())
		if tmp1->d4_quant>sb2->b2_qemp
			
			if prow()==0 .or. prow()>56
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
			endif
			
			if _limpprod
				@ prow()+1,000 PSAY tmpp->b1_cod
				@ prow(),016   PSAY substr(tmpp->b1_desc,1,60)
				_limpprod:=.f.
			else
				@ prow()+1,000 PSAY " "
			endif
			@ prow(),077   PSAY sb2->b2_local
			@ prow(),107   PSAY "SD4: "+transform(tmp1->d4_quant,"@E 999,999,999,999.99999")
			@ prow(),132   PSAY "SB2: "+transform(sb2->b2_qemp,"@E 999,999,999,999.99999")
			@ prow(),157   PSAY "SD4-SB2: "+transform(tmp1->d4_quant-sb2->b2_qemp,"@E 999,999,999,999.99999")
		endif
		
		tmp1->(dbclosearea())
		
		if tmpp->b1_rastro=="L"
			_cquery:=" SELECT"
			_cquery+=" D4_LOTECTL,"
			_cquery+=" SUM(D4_QUANT) D4_QUANT"
			
			_cquery+=" FROM "
			_cquery+=  retsqlname("SD4")+" SD4"
			
			_cquery+=" WHERE"
			_cquery+="     SD4.D_E_L_E_T_=' '"
			_cquery+=" AND D4_FILIAL='"+_cfilsd4+"'"
			_cquery+=" AND D4_COD='"+tmpp->b1_cod+"'"
			_cquery+=" AND D4_LOCAL='"+sb2->b2_local+"'"
			_cquery+=" AND D4_QUANT>0"
			_cquery+=" AND D4_LOTECTL<>'          '"
			
			_cquery+=" GROUP BY"
			_cquery+=" D4_LOTECTL"
			
			_cquery+=" ORDER BY"
			_cquery+=" D4_LOTECTL"
			
			_cquery:=changequery(_cquery)
			
			tcquery _cquery new alias "TMP1"
			u_setfield("TMP1")
			
			tmp1->(dbgotop())
			while ! tmp1->(eof())
				
				_cquery:=" SELECT"
				_cquery+=" SUM(B8_SALDO) B8_SALDO,"
				_cquery+=" SUM(B8_EMPENHO) B8_EMPENHO"
				
				_cquery+=" FROM "
				_cquery+=  retsqlname("SB8")+" SB8"
				
				_cquery+=" WHERE"
				_cquery+="     SB8.D_E_L_E_T_=' '"
				_cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
				_cquery+=" AND B8_PRODUTO='"+tmpp->b1_cod+"'"
				_cquery+=" AND B8_LOCAL='"+sb2->b2_local+"'"
				_cquery+=" AND B8_LOTECTL='"+tmp1->d4_lotectl+"'"
				
				_cquery:=changequery(_cquery)
				
				tcquery _cquery new alias "TMP2"
				u_setfield("TMP2")
				
				tmp2->(dbgotop())
				if tmp1->d4_quant>tmp2->b8_empenho
					
					if prow()==0 .or. prow()>56
						cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
					endif
					
					if _limpprod
						@ prow()+1,000 PSAY tmpp->b1_cod
						@ prow(),016   PSAY substr(tmpp->b1_desc,1,60)
						_limpprod:=.f.
					else
						@ prow()+1,000 PSAY " "
					endif
					@ prow(),077   PSAY sb2->b2_local
					@ prow(),080   PSAY tmp1->d4_lotectl
					@ prow(),107   PSAY "SD4: "+transform(tmp1->d4_quant,"@E 999,999,999,999.99999")
					@ prow(),132   PSAY "SB8: "+transform(tmp2->b8_empenho,"@E 999,999,999,999.99999")
					@ prow(),157   PSAY "SD4-SB8: "+transform(tmp1->d4_quant-tmp2->b8_empenho,"@E 999,999,999,999.99999")
					@ prow(),186   PSAY "SALDO SB8: "+transform(tmp2->b8_saldo,"@E 999,999,999,999.99999")
				endif
				
				tmp2->(dbclosearea())
				
				if tmpp->b1_localiz=="S"
					_cquery:=" SELECT"
					_cquery+=" SUM(BF_QUANT) BF_QUANT,"
					_cquery+=" SUM(BF_EMPENHO) BF_EMPENHO"
					
					_cquery+=" FROM "
					_cquery+=  retsqlname("SBF")+" SBF"
					
					_cquery+=" WHERE"
					_cquery+="     SBF.D_E_L_E_T_=' '"
					_cquery+=" AND BF_FILIAL='"+_cfilsbf+"'"
					_cquery+=" AND BF_PRODUTO='"+tmpp->b1_cod+"'"
					_cquery+=" AND BF_LOCAL='"+sb2->b2_local+"'"
					_cquery+=" AND BF_LOTECTL='"+tmp1->d4_lotectl+"'"
					
					_cquery:=changequery(_cquery)
					
					tcquery _cquery new alias "TMP2"
					u_setfield("TMP2")
					
					tmp2->(dbgotop())
					if tmp1->d4_quant>tmp2->bf_empenho
						
						if prow()==0 .or. prow()>56
							cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
						endif
						
						if _limpprod
							@ prow()+1,000 PSAY tmpp->b1_cod
							@ prow(),016   PSAY substr(tmpp->b1_desc,1,60)
							_limpprod:=.f.
						else
							@ prow()+1,000 PSAY " "
						endif
						@ prow(),077   PSAY sb2->b2_local
						@ prow(),080   PSAY tmp1->d4_lotectl
						@ prow(),107   PSAY "SD4: "+transform(tmp1->d4_quant,"@E 999,999,999,999.99999")
						@ prow(),132   PSAY "SBF: "+transform(tmp2->bf_empenho,"@E 999,999,999,999.99")
						@ prow(),157   PSAY "SD4-SBF: "+transform(tmp1->d4_quant-tmp2->bf_empenho,"@E 999,999,999,999.99999")
						@ prow(),186   PSAY "SALDO SBF: "+transform(tmp2->bf_quant,"@E 999,999,999,999.99999")
					endif
					
					tmp2->(dbclosearea())
					
					_cquery:=" SELECT"
					_cquery+=" SUM(DC_QUANT) DC_QUANT"
					
					_cquery+=" FROM "
					_cquery+=  retsqlname("SDC")+" SDC"
					
					_cquery+=" WHERE"
					_cquery+="     SDC.D_E_L_E_T_=' '"
					_cquery+=" AND DC_FILIAL='"+_cfilsdc+"'"
					_cquery+=" AND DC_PRODUTO='"+tmpp->b1_cod+"'"
					_cquery+=" AND DC_LOCAL='"+sb2->b2_local+"'"
					_cquery+=" AND DC_LOTECTL='"+tmp1->d4_lotectl+"'"
					_cquery+=" AND DC_QUANT>0"
					_cquery+=" AND DC_ORIGEM='SC2'"
					
					_cquery:=changequery(_cquery)
					
					tcquery _cquery new alias "TMP2"
					u_setfield("TMP2")
					
					tmp2->(dbgotop())
					if tmp1->d4_quant<>tmp2->dc_quant
						
						if prow()==0 .or. prow()>56
							cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
						endif
						
						if _limpprod
							@ prow()+1,000 PSAY tmpp->b1_cod
							@ prow(),016   PSAY substr(tmpp->b1_desc,1,60)
							_limpprod:=.f.
						else
							@ prow()+1,000 PSAY " "
						endif
						@ prow(),077   PSAY sb2->b2_local
						@ prow(),080   PSAY tmp1->d4_lotectl
						@ prow(),107   PSAY "SD4: "+transform(tmp1->d4_quant,"@E 999,999,999,999.99999")
						@ prow(),132   PSAY "SDC: "+transform(tmp2->dc_quant,"@E 999,999,999,999.99999")
						@ prow(),157   PSAY "SD4-SDC: "+transform(tmp1->d4_quant-tmp2->dc_quant,"@E 999,999,999,999.99999")
					endif
					
					tmp2->(dbclosearea())
				endif
				tmp1->(dbskip())
			end
			
			tmp1->(dbclosearea())
			
			if tmpp->b1_localiz=="S"
				_cquery:=" SELECT"
				_cquery+=" DC_LOTECTL,"
				_cquery+=" SUM(DC_QUANT) DC_QUANT"
				
				_cquery+=" FROM "
				_cquery+=  retsqlname("SDC")+" SDC"
				
				_cquery+=" WHERE"
				_cquery+="     SDC.D_E_L_E_T_=' '"
				_cquery+=" AND DC_FILIAL='"+_cfilsdc+"'"
				_cquery+=" AND DC_PRODUTO='"+tmpp->b1_cod+"'"
				_cquery+=" AND DC_LOCAL='"+sb2->b2_local+"'"
				_cquery+=" AND DC_QUANT>0"
				_cquery+=" AND DC_ORIGEM<>'SDD'"
				
				_cquery+=" GROUP BY"
				_cquery+=" DC_LOTECTL"
				
				_cquery+=" ORDER BY"
				_cquery+=" DC_LOTECTL"
				
				_cquery:=changequery(_cquery)
				
				tcquery _cquery new alias "TMP1"
				u_setfield("TMP1")
				
				tmp1->(dbgotop())
				while ! tmp1->(eof())
					
					_cquery:=" SELECT"
					_cquery+=" SUM(B8_SALDO) B8_SALDO,"
					_cquery+=" SUM(B8_EMPENHO) B8_EMPENHO"
					
					_cquery+=" FROM "
					_cquery+=  retsqlname("SB8")+" SB8"
					
					_cquery+=" WHERE"
					_cquery+="     SB8.D_E_L_E_T_=' '"
					_cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
					_cquery+=" AND B8_PRODUTO='"+tmpp->b1_cod+"'"
					_cquery+=" AND B8_LOCAL='"+sb2->b2_local+"'"
					_cquery+=" AND B8_LOTECTL='"+tmp1->dc_lotectl+"'"
					
					_cquery:=changequery(_cquery)
					
					tcquery _cquery new alias "TMP2"
					u_setfield("TMP2")
					
					tmp2->(dbgotop())
					if tmp1->dc_quant>tmp2->b8_empenho
						
						if prow()==0 .or. prow()>56
							cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
						endif
						
						if _limpprod
							@ prow()+1,000 PSAY tmpp->b1_cod
							@ prow(),016   PSAY substr(tmpp->b1_desc,1,60)
							_limpprod:=.f.
						else
							@ prow()+1,000 PSAY " "
						endif
						@ prow(),077   PSAY sb2->b2_local
						@ prow(),080   PSAY tmp1->dc_lotectl
						@ prow(),107   PSAY "SDC: "+transform(tmp1->dc_quant,"@E 999,999,999,999.99999")
						@ prow(),132   PSAY "SB8: "+transform(tmp2->b8_empenho,"@E 999,999,999,999.99999")
						@ prow(),157   PSAY "SDC-SB8: "+transform(tmp1->dc_quant-tmp2->b8_empenho,"@E 999,999,999,999.99999")
						@ prow(),186   PSAY "SALDO SB8: "+transform(tmp2->b8_saldo,"@E 999,999,999,999.99999")
					endif
					
					tmp2->(dbclosearea())
					
					tmp1->(dbskip())
				end
				
				tmp1->(dbclosearea())
				
				_cquery:=" SELECT"
				_cquery+=" DC_LOTECTL,"
				_cquery+=" DC_LOCALIZ,"
				_cquery+=" SUM(DC_QUANT) DC_QUANT"
				
				_cquery+=" FROM "
				_cquery+=  retsqlname("SDC")+" SDC"
				
				_cquery+=" WHERE"
				_cquery+="     SDC.D_E_L_E_T_=' '"
				_cquery+=" AND DC_FILIAL='"+_cfilsdc+"'"
				_cquery+=" AND DC_PRODUTO='"+tmpp->b1_cod+"'"
				_cquery+=" AND DC_LOCAL='"+sb2->b2_local+"'"
				_cquery+=" AND DC_QUANT>0"
				_cquery+=" AND DC_ORIGEM<>'SDD'"
				
				_cquery+=" GROUP BY"
				_cquery+=" DC_LOTECTL,DC_LOCALIZ"
				
				_cquery+=" ORDER BY"
				_cquery+=" DC_LOTECTL,DC_LOCALIZ"
				
				_cquery:=changequery(_cquery)
				
				tcquery _cquery new alias "TMP1"
				u_setfield("TMP1")
				
				tmp1->(dbgotop())
				while ! tmp1->(eof())
					
					_cquery:=" SELECT"
					_cquery+=" SUM(BF_QUANT) BF_QUANT,"
					_cquery+=" SUM(BF_EMPENHO) BF_EMPENHO"
					
					_cquery+=" FROM "
					_cquery+=  retsqlname("SBF")+" SBF"
					
					_cquery+=" WHERE"
					_cquery+="     SBF.D_E_L_E_T_=' '"
					_cquery+=" AND BF_FILIAL='"+_cfilsbf+"'"
					_cquery+=" AND BF_PRODUTO='"+tmpp->b1_cod+"'"
					_cquery+=" AND BF_LOCAL='"+sb2->b2_local+"'"
					_cquery+=" AND BF_LOTECTL='"+tmp1->dc_lotectl+"'"
					_cquery+=" AND BF_LOCALIZ='"+tmp1->dc_localiz+"'"
					
					_cquery:=changequery(_cquery)
					
					tcquery _cquery new alias "TMP2"
					u_setfield("TMP2")
					
					tmp2->(dbgotop())
					if tmp1->dc_quant>tmp2->bf_empenho
						
						if prow()==0 .or. prow()>56
							cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
						endif
						
						if _limpprod
							@ prow()+1,000 PSAY tmpp->b1_cod
							@ prow(),016   PSAY substr(tmpp->b1_desc,1,60)
							_limpprod:=.f.
						else
							@ prow()+1,000 PSAY " "
						endif
						@ prow(),077   PSAY sb2->b2_local
						@ prow(),080   PSAY tmp1->dc_lotectl
						@ prow(),091   PSAY tmp1->dc_localiz
						@ prow(),107   PSAY "SDC: "+transform(tmp1->dc_quant,"@E 999,999,999,999.99999")
						@ prow(),132   PSAY "SBF: "+transform(tmp2->bf_empenho,"@E 999,999,999,999.99999")
						@ prow(),157   PSAY "SDC-SBF: "+transform(tmp1->dc_quant-tmp2->bf_empenho,"@E 999,999,999,999.99999")
						@ prow(),186   PSAY "SALDO SBF: "+transform(tmp2->bf_quant,"@E 999,999,999,999.99999")
					endif
					
					tmp2->(dbclosearea())
					
					tmp1->(dbskip())
				end
				
				tmp1->(dbclosearea())
			endif
		endif
		sb2->(dbskip())
	end
	
	if ! _limpprod
		@ prow()+1,000 PSAY replicate("-",limite)
	endif
	
	tmpp->(dbskip())
	
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end
tmpp->(dbclosearea())

if prow()>0 .and.;
	lcontinua
	roda(cbcont,cbtxt)
endif

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto                   ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto                ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo                      ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo                   ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo                     ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo                  ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Do armazem                   ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem                ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
return()

/*
CODIGO          DESCRICAO                                                    AR LOTE       ENDERECO
XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXX XXXXXXXXXXXXXXX XXX: 999,999,999,999.99  XXX: 999,999,999,999.99  XXX-XXX: 999,999,999,999.99  SALDO XXX: 999,999,999,999.99 
*/

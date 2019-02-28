/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT297   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 01/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Recalcula Empenhos SB2, SB8 E SBF                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit297()
cperg:="PERGVIT297"
_pergsx1()
if pergunte(cperg,.t.) .and.;
	msgyesno("Confirma recalculo dos empenhos?")
	
	processa({|| _acerta()})
	
endif
return()

static function _acerta()
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb8:=xfilial("SB8")
_cfilsbf:=xfilial("SBF")
_cfilsd4:=xfilial("SD4")
_cfilsdc:=xfilial("SDC")

procregua(1)

incproc("Verificando SD4...")

_cquery:=" SELECT"
_cquery+=" D4_COD,"
_cquery+=" D4_LOCAL,"
_cquery+=" SUM(D4_QUANT) D4_QUANT,"
_cquery+=" SUM(D4_QTSEGUM) D4_QTSEGUM"

_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SD4")+" SD4"

_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_=' '"
_cquery+=" AND SD4.D_E_L_E_T_=' '"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND D4_FILIAL='"+_cfilsd4+"'"
_cquery+=" AND D4_COD=B1_COD"
_cquery+=" AND D4_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND D4_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND D4_QUANT>0"

_cquery+=" GROUP BY"
_cquery+=" D4_COD,D4_LOCAL"

_cquery+=" ORDER BY"
_cquery+=" D4_COD,D4_LOCAL"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP2"
u_setfield("TMP2")

tmp2->(dbgotop())
while ! tmp2->(eof())
	sb2->(dbsetorder(1))
	sb2->(dbseek(_cfilsb2+tmp2->d4_cod+tmp2->d4_local))
	
	sb2->(reclock("SB2",.f.))
	sb2->b2_qemp:=tmp2->d4_quant
	sb2->b2_qemp2:=tmp2->d4_qtsegum
	sb2->(msunlock())
	
	tmp2->(dbskip())
end
tmp2->(dbclosearea())

incproc("Verificando SDC")

_cquery:=" SELECT"
_cquery+=" DC_PRODUTO,"
_cquery+=" DC_LOCAL,"
_cquery+=" DC_LOTECTL,"
_cquery+=" DC_LOCALIZ,"
_cquery+=" SUM(DC_QUANT) DC_QUANT,"
_cquery+=" SUM(DC_QTSEGUM) DC_QTSEGUM"

_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SDC")+" SDC"

_cquery+=" WHERE"
_cquery+="     SDC.D_E_L_E_T_=' '"
_cquery+=" AND SB1.D_E_L_E_T_=' '"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND DC_FILIAL='"+_cfilsdc+"'"
_cquery+=" AND DC_PRODUTO=B1_COD"
_cquery+=" AND DC_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND DC_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND DC_QUANT>0"

_cquery+=" GROUP BY"
_cquery+=" DC_PRODUTO,DC_LOCAL,DC_LOTECTL,DC_LOCALIZ"

_cquery+=" ORDER BY"
_cquery+=" DC_PRODUTO,DC_LOCAL,DC_LOTECTL,DC_LOCALIZ"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
u_setfield("TMP1")

tmp1->(dbgotop())
while ! tmp1->(eof())
	
	incproc("Processando "+tmp1->dc_produto+tmp1->dc_local+tmp1->dc_lotectl)
	
	_cproduto:=tmp1->dc_produto
	_clocal  :=tmp1->dc_local
	_clotectl:=tmp1->dc_lotectl
	                           
	_nquant  :=0
	_nqtsegum:=0
	while ! tmp1->(eof()) .and.;
		tmp1->dc_produto==_cproduto .and.;
		tmp1->dc_local==_clocal .and.;
		tmp1->dc_lotectl==_clotectl
		
		sbf->(dbordernickname("SBFVIT01"))
		if sbf->(dbseek(_cfilsbf+tmp1->dc_produto+tmp1->dc_local+tmp1->dc_lotectl+tmp1->dc_localiz))
			sbf->(reclock("SBF",.f.))
			if sbf->bf_quant>=tmp1->dc_quant
				sbf->bf_empenho:=tmp1->dc_quant
				sbf->bf_empen2 :=tmp1->dc_qtsegum
			else
				sbf->bf_empenho:=sbf->bf_quant
				sbf->bf_empen2 :=sbf->bf_qtsegum
			endif
			sbf->(msunlock())
		endif
		_nquant+=tmp1->dc_quant
		_nqtsegum+=tmp1->dc_qtsegum
		
		tmp1->(dbskip())
	end
	
	sb8->(dbsetorder(3))
	if sb8->(dbseek(_cfilsb8+_cproduto+_clocal+_clotectl))
		while ! sb8->(eof()) .and.;
			sb8->b8_produto==_cproduto .and.;
			sb8->b8_local==_clocal .and.;
			sb8->b8_lotectl==_clotectl
			
			sb8->(reclock("SB8",.f.))
			if sb8->b8_saldo>=_nquant
				sb8->b8_empenho:=_nquant
				sb8->b8_empenh2:=_nqtsegum
				_nquant  :=0
				_nqtsegum:=0
			else
				sb8->b8_empenho:=sb8->b8_saldo
				sb8->b8_empenh2:=sb8->b8_saldo2
				_nquant  -=sb8->b8_saldo
				_nqtsegum-=sb8->b8_saldo2
			endif
			sb8->(msunlock())
			
			sb8->(dbskip())
		end
	endif
end
tmp1->(dbclosearea())

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

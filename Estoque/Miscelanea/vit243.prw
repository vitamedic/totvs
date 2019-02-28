/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT243   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 19/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gerar Movimentacao para Criacao do Saldo por Endereco para ³±±
±±³          ³ Produtos que Passaram a Controlar Endereco                 ³±±
±±³          ³ Executar Apenas uma Vez                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function vit243()
cperg:="PERGVIT243"
_pergsx1()
if pergunte(cperg,.t.) .and.;
	msgyesno("Confirma criacao do saldo por endereco?")
	
	processa({|| _gera()})
	
	msginfo("Criacao do saldo por endereco finalizada com sucesso!")
endif
return

static function _gera()

_cfilsb1:=xfilial("SB1")
_cfilsb8:=xfilial("SB8")
_cfilsbf:=xfilial("SBF")
_cfilsd4:=xfilial("SD4")
_cfilsdb:=xfilial("SDB")
_cfilsdc:=xfilial("SDC")

procregua(sb1->(lastrec()))

_cquery:=" SELECT"
_cquery+=" B1_COD"

_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"

_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_=' '"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND B1_LOCALIZ='S'"

_cquery+=" ORDER BY"
_cquery+=" 1"

_cquery:=changequery(_cquery)

tcquery _cquery alias "TMP1" new

tmp1->(dbgotop())
while ! tmp1->(eof())

	incproc("Processando produto "+tmp1->b1_cod)
	
	_cquery:=" SELECT"
	_cquery+=" B8_LOCAL,"
	_cquery+=" B8_LOTECTL,"
	_cquery+=" B8_DTVALID,"
	_cquery+=" SUM(B8_SALDO) B8_SALDO,"
	_cquery+=" SUM(B8_SALDO2) B8_SALDO2"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("SB8")+" SB8"
	
	_cquery+=" WHERE"
	_cquery+="     SB8.D_E_L_E_T_=' '"
	_cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
	_cquery+=" AND B8_PRODUTO='"+tmp1->b1_cod+"'"
	_cquery+=" AND B8_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" AND B8_SALDO>0"
	
	_cquery+=" GROUP BY"
	_cquery+=" B8_LOCAL,B8_LOTECTL,B8_DTVALID"
	
	_cquery+=" ORDER BY"
	_cquery+=" B8_LOCAL,B8_LOTECTL,B8_DTVALID"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery alias "TMP2" new
	u_setfield("TMP2")
	
	tmp2->(dbgotop())
	while ! tmp2->(eof())
		
		_clocaliz:=mv_par09
		_cdoc    :="VIT243"
		_cnumseq :=getmv("MV_DOCSEQ")
		
		putmv("MV_DOCSEQ",soma1(_cnumseq))
		
		reclock("SDB",.t.)
		sdb->db_filial :=_cfilsdb
		sdb->db_item   :="0001"
		sdb->db_produto:=tmp1->b1_cod
		sdb->db_local  :=tmp2->b8_local
		sdb->db_localiz:=_clocaliz
		sdb->db_doc    :=_cdoc
		sdb->db_tm     :="499"
		sdb->db_origem :="SD3"
		sdb->db_quant  :=tmp2->b8_saldo
		sdb->db_data   :=ddatabase
		sdb->db_lotectl:=tmp2->b8_lotectl
		sdb->db_numseq :=_cnumseq
		sdb->db_tipo   :="D"
		sdb->db_qtsegum:=tmp2->b8_saldo2
		sdb->db_servic :="499"
		sdb->db_ativid :="ZZZ"
		sdb->db_hrini  :=substr(time(),1,5)
		sdb->db_atuest :="S"
		sdb->db_status :="M"
		sdb->db_ordativ:="ZZ"
		msunlock()
			
		_cquery:=" SELECT"
		_cquery+=" D4_DATA,"
		_cquery+=" D4_OP,"
		_cquery+=" D4_TRT,"
		_cquery+=" D4_QUANT,"
		_cquery+=" D4_QTSEGUM"
		
		_cquery+=" FROM "
		_cquery+=  retsqlname("SD4")+" SD4"
		
		_cquery+=" WHERE"
		_cquery+="     SD4.D_E_L_E_T_=' '"
		_cquery+=" AND D4_FILIAL='"+_cfilsd4+"'"
		_cquery+=" AND D4_COD='"+tmp1->b1_cod+"'"
		_cquery+=" AND D4_LOCAL='"+tmp2->b8_local+"'"
		_cquery+=" AND D4_LOTECTL='"+tmp2->b8_lotectl+"'"
		_cquery+=" AND D4_QUANT>0"
		
		_cquery+=" ORDER BY"
		_cquery+=" D4_DATA,D4_OP,D4_TRT"
		
		_cquery:=changequery(_cquery)
		
		tcquery _cquery alias "TMP3" new
		u_setfield("TMP3")
		
		_nemp :=0
		_nemp2:=0
		
		tmp3->(dbgotop())
		while ! tmp3->(eof())
		
			reclock("SDC",.t.)
			sdc->dc_filial :=_cfilsdc
			sdc->dc_origem :="SC2"
			sdc->dc_produto:=tmp1->b1_cod
			sdc->dc_local  :=tmp2->b8_local
			sdc->dc_localiz:=_clocaliz
			sdc->dc_lotectl:=tmp2->b8_lotectl
			sdc->dc_quant  :=tmp3->d4_quant
			sdc->dc_op     :=tmp3->d4_op
			sdc->dc_trt    :=tmp3->d4_trt
			sdc->dc_qtdorig:=tmp3->d4_quant
			sdc->dc_qtsegum:=tmp3->d4_qtsegum
			msunlock()
			
			_nemp+=tmp3->d4_quant
			_nemp2+=tmp3->d4_qtsegum
			
			tmp3->(dbskip())
		end
		tmp3->(dbclosearea())
		
		if tmp2->b8_dtvalid<ddatabase
			reclock("SDC",.t.)
			sdc->dc_filial :=_cfilsdc
			sdc->dc_origem :="SDD"
			sdc->dc_produto:=tmp1->b1_cod
			sdc->dc_local  :=tmp2->b8_local
			sdc->dc_localiz:=_clocaliz
			sdc->dc_lotectl:=tmp2->b8_lotectl
			sdc->dc_quant  :=tmp2->b8_saldo
			sdc->dc_pedido :="000001"
			sdc->dc_qtdorig:=tmp2->b8_saldo
			sdc->dc_qtsegum:=tmp2->b8_saldo2
			msunlock()
			
			_nemp:=tmp2->b8_saldo
			_nemp2:=tmp2->b8_saldo2
		endif
		
		reclock("SBF",.t.)
		sbf->bf_filial :=_cfilsbf
		sbf->bf_produto:=tmp1->b1_cod
		sbf->bf_local  :=tmp2->b8_local
		sbf->bf_prior  :="ZZZ"
		sbf->bf_localiz:=_clocaliz
		sbf->bf_lotectl:=tmp2->b8_lotectl
		sbf->bf_quant  :=tmp2->b8_saldo
		sbf->bf_qtsegum:=tmp2->b8_saldo2
		sbf->bf_empenho:=_nemp
		sbf->bf_empen2 :=_nemp2
		msunlock()
		
		tmp2->(dbskip())
	end
	tmp2->(dbclosearea())
	
	tmp1->(dbskip())
end
tmp1->(dbclosearea())
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Do armazem         ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem      ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Endereco           ?","mv_ch9","C",15,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBE"})
	
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

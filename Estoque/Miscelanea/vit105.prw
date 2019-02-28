/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT105   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 01/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gerar Inventario para Produtos nao Digitados Zerando a     ³±±
±±³          ³ Quantidade ou Inventariando a Quantidade Empenhada         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function vit105()              
cperg:="PERGVIT105"
_pergsx1()
if pergunte(cperg,.t.) .and.;
	msgyesno("Confirma geração do inventário?")
	
	processa({|| _gera()})
	
endif
return()

static function _gera()
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb7:=xfilial("SB7")
_cfilsb8:=xfilial("SB8")
_cfilsbf:=xfilial("SBF")

procregua(0)

_cindsb7:=criatrab(,.f.)
_cchave :="B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOTECTL+B7_LOCALIZ"
sb7->(indregua("SB7",_cindsb7,_cchave))

incproc("Selecionando registros...")
_cquery:=" SELECT"
_cquery+=" B1_COD,"
_cquery+=" B1_TIPO,"
_cquery+=" B1_RASTRO,"
_cquery+=" B1_LOCALIZ"

_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"

_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_=' '"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par04+"' AND '"+mv_par05+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"

_cquery+=" ORDER BY"
_cquery+=" B1_COD"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
u_setfield("TMP1")

tmp1->(dbgotop())
while ! tmp1->(eof())
	
	incproc("Processando "+tmp1->b1_cod)
	
	if tmp1->b1_localiz=="S"
		
		sbf->(dbsetorder(2))
		sbf->(dbseek(_cfilsbf+tmp1->b1_cod+mv_par08,.t.))
		while ! sbf->(eof()) .and.;
			sbf->bf_filial==_cfilsbf .and.;
			sbf->bf_produto==tmp1->b1_cod .and.;
			sbf->bf_local<=mv_par09
			
			if sbf->bf_localiz>=mv_par10 .and.;
				sbf->bf_localiz<=mv_par11 .and.;
				(sbf->bf_quant>0 .or. sbf->bf_empenho>0)
				
				sb8->(dbsetorder(3))
				sb8->(dbseek(_cfilsb8+sbf->bf_produto+sbf->bf_local+sbf->bf_lotectl))
				if sb8->b8_dtvalid>=mv_par01
					if sb7->(dbseek(_cfilsb7+dtos(mv_par01)+sbf->bf_produto+sbf->bf_local+sbf->bf_lotectl+sbf->bf_localiz))
						reclock("SB7",.f.)
						sb7->b7_quant  +=sbf->bf_empenho
						sb7->b7_qtsegum+=sbf->bf_empen2
					else
						reclock("SB7",.t.)
						sb7->b7_filial :=_cfilsb7
						//sb7->b7_status :="1"
						sb7->b7_cod    :=sbf->bf_produto
						sb7->b7_local  :=sbf->bf_local
						sb7->b7_tipo   :=tmp1->b1_tipo
						sb7->b7_doc    :=left(dtoc(mv_par01),2)+substr(dtoc(mv_par01),4,2)+right(dtoc(mv_par01),2)
						sb7->b7_quant  :=sbf->bf_empenho
						sb7->b7_qtsegum:=sbf->bf_empen2
						sb7->b7_data   :=mv_par01
						sb7->b7_lotectl:=sbf->bf_lotectl
						sb7->b7_dtvalid:=sb8->b8_dtvalid
						sb7->b7_localiz:=sbf->bf_localiz
					endif
					msunlock()
				endif
			endif
			
			sbf->(dbskip())
		end
	elseif tmp1->b1_rastro=="L"
		sb8->(dbsetorder(3))
		sb8->(dbseek(_cfilsb8+tmp1->b1_cod+mv_par08,.t.))
		while ! sb8->(eof()) .and.;
			sb8->b8_filial==_cfilsb8 .and.;
			sb8->b8_produto==tmp1->b1_cod .and.;
			sb8->b8_local<=mv_par09
			
			if sb8->b8_dtvalid>=mv_par01
				
				_nsaldo  :=0
				_nsaldo2 :=0
				_nemp    :=0
				_nemp2   :=0
				_clocal  :=sb8->b8_local
				_clotectl:=sb8->b8_lotectl
				_ddtvalid:=sb8->b8_dtvalid
				while ! sb8->(eof()) .and.;
					sb8->b8_filial==_cfilsb8 .and.;
					sb8->b8_produto==tmp1->b1_cod .and.;
					sb8->b8_local==_clocal .and.;
					sb8->b8_lotectl==_clotectl
					
					_nsaldo+=sb8->b8_saldo
					_nsaldo2+=sb8->b8_saldo2
					_nemp+=sb8->b8_empenho
					_nemp2+=sb8->b8_empenh2
					
					sb8->(dbskip())
				end
				
				if _nsaldo>0 .or. _nemp>0
					if sb7->(dbseek(_cfilsb7+dtos(mv_par01)+tmp1->b1_cod+_clocal+_clotectl))
						reclock("SB7",.f.)
						sb7->b7_quant  +=_nemp
						sb7->b7_qtsegum+=_nemp2
					else
						reclock("SB7",.t.)
						sb7->b7_filial :=_cfilsb7
						//sb7->b7_status :="1"
						sb7->b7_cod    :=tmp1->b1_cod
						sb7->b7_local  :=_clocal
						sb7->b7_tipo   :=tmp1->b1_tipo
						sb7->b7_doc    :=left(dtoc(mv_par01),2)+substr(dtoc(mv_par01),4,2)+right(dtoc(mv_par01),2)
						sb7->b7_quant  :=_nemp
						sb7->b7_qtsegum:=_nemp2
						sb7->b7_data   :=mv_par01
						sb7->b7_lotectl:=_clotectl
						sb7->b7_dtvalid:=_ddtvalid
					endif
					msunlock()
				endif
			else
				sb8->(dbskip())
			endif
		end
	else
		sb2->(dbsetorder(1))
		sb2->(dbseek(_cfilsb2+tmp1->b1_cod+mv_par08,.t.))
		while ! sb2->(eof()) .and.;
			sb2->b2_filial==_cfilsb2 .and.;
			sb2->b2_cod==tmp1->b1_cod .and.;
			sb2->b2_local<=mv_par09
			
			if sb2->b2_qatu>0
				if ! sb7->(dbseek(_cfilsb7+dtos(mv_par01)+tmp1->b1_cod+sb2->b2_local))
					reclock("SB7",.t.)
					sb7->b7_filial :=_cfilsb7
					//sb7->b7_status :="1"
					sb7->b7_cod    :=tmp1->b1_cod
					sb7->b7_local  :=sb2->b2_local
					sb7->b7_tipo   :=tmp1->b1_tipo
					sb7->b7_doc    :=left(dtoc(mv_par01),2)+substr(dtoc(mv_par01),4,2)+right(dtoc(mv_par01),2)
					sb7->b7_quant  :=0
					sb7->b7_qtsegum:=0
					sb7->b7_data   :=mv_par01
					msunlock()
				endif
			endif
			
			sb2->(dbskip())
		end
	endif
	
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

sb7->(retindex("SB7"))
ferase(_cindsb7+ordbagext())
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Data do inventario           ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Do produto                   ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Ate o produto                ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Do tipo                      ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Ate o tipo                   ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"06","Do grupo                     ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Ate o grupo                  ?","mv_ch7","C",04,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"08","Do armazem                   ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Ate o armazem                ?","mv_ch9","C",02,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Do endereco                  ?","mv_cha","C",15,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBE"})
aadd(_agrpsx1,{cperg,"11","Ate o endereco               ?","mv_chb","C",15,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBE"})

for _ni:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_ni,1]+_agrpsx1[_ni,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_ni,01]
		sx1->x1_ordem  :=_agrpsx1[_ni,02]
		sx1->x1_pergunt:=_agrpsx1[_ni,03]
		sx1->x1_variavl:=_agrpsx1[_ni,04]
		sx1->x1_tipo   :=_agrpsx1[_ni,05]
		sx1->x1_tamanho:=_agrpsx1[_ni,06]
		sx1->x1_decimal:=_agrpsx1[_ni,07]
		sx1->x1_presel :=_agrpsx1[_ni,08]
		sx1->x1_gsc    :=_agrpsx1[_ni,09]
		sx1->x1_valid  :=_agrpsx1[_ni,10]
		sx1->x1_var01  :=_agrpsx1[_ni,11]
		sx1->x1_def01  :=_agrpsx1[_ni,12]
		sx1->x1_cnt01  :=_agrpsx1[_ni,13]
		sx1->x1_var02  :=_agrpsx1[_ni,14]
		sx1->x1_def02  :=_agrpsx1[_ni,15]
		sx1->x1_cnt02  :=_agrpsx1[_ni,16]
		sx1->x1_var03  :=_agrpsx1[_ni,17]
		sx1->x1_def03  :=_agrpsx1[_ni,18]
		sx1->x1_cnt03  :=_agrpsx1[_ni,19]
		sx1->x1_var04  :=_agrpsx1[_ni,20]
		sx1->x1_def04  :=_agrpsx1[_ni,21]
		sx1->x1_cnt04  :=_agrpsx1[_ni,22]
		sx1->x1_var05  :=_agrpsx1[_ni,23]
		sx1->x1_def05  :=_agrpsx1[_ni,24]
		sx1->x1_cnt05  :=_agrpsx1[_ni,25]
		sx1->x1_f3     :=_agrpsx1[_ni,26]
		sx1->(msunlock())
	endif
next
return()

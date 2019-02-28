/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT106   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 08/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Diferencas entre SB2 X SB8 X SBF                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit106()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="RELACAO DE DIFERENCAS ENTRE SB2 X SB8 X SBF"
cdesc1   :="Este programa ira emitir a relacao de diferencas entre SB2 X SB8 X SBF"
cdesc2   :=""
cdesc3   :=""
cstring  :="SB1"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT106"
wnrel    :="VIT106"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT106"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

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
return

static function rptdetail()
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb8:=xfilial("SB8")
_cfilsbf:=xfilial("SBF")
sb1->(dbsetorder(1))
sb2->(dbsetorder(1))
sb8->(dbsetorder(1))
sbf->(dbsetorder(2))

cabec1:="CODIGO       DESCRICAO                                         AR         QUANT. SB2          QUANT. SB8          QUANT. SBF"
cabec2:=""

setprc(0,0)

setregua(sb1->(lastrec()))

sb1->(dbseek(_cfilsb1+mv_par01,.t.))
while ! sb1->(eof()) .and.;
		sb1->b1_filial==_cfilsb1 .and.;
		sb1->b1_cod<=mv_par02 .and.;
      lcontinua
	incregua()
	if (sb1->b1_rastro=="L" .or. sb1->b1_localiz=="S") .and.;
		sb1->b1_tipo>=mv_par03 .and.;
		sb1->b1_tipo<=mv_par04 .and.;
		sb1->b1_grupo>=mv_par05 .and.;
		sb1->b1_grupo<=mv_par06
		sb2->(dbseek(_cfilsb2+sb1->b1_cod+mv_par07,.t.))
		while ! sb2->(eof()) .and.;
				sb2->b2_filial==_cfilsb2 .and.;
				sb2->b2_cod==sb1->b1_cod .and.;
				sb2->b2_local<=mv_par08
			_ldif:=.f.
			_nsaldosb2:=sb2->b2_qatu
			_nclasssb2:=sb2->b2_qaclass
			if sb1->b1_rastro=="L"
				_cquery:=" SELECT"
				_cquery+=" SUM(B8_SALDO) SALDO,SUM(B8_QACLASS) QACLASS"
				_cquery+=" FROM "
				_cquery+=  retsqlname("SB8")+" SB8"
				_cquery+=" WHERE "
				_cquery+="     SB8.D_E_L_E_T_<>'*'"
				_cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
				_cquery+=" AND B8_PRODUTO='"+sb1->b1_cod+"'"
				_cquery+=" AND B8_LOCAL='"+sb2->b2_local+"'"
      		
				_cquery:=changequery(_cquery)
				
				tcquery _cquery new alias "TMP1"
				tcsetfield("TMP1","SALDO"  ,"N",15,5)
				tcsetfield("TMP1","QACLASS","N",15,5)
				
				tmp1->(dbgotop())
				_nsaldosb8:=tmp1->saldo
				_nclasssb8:=tmp1->qaclass
				tmp1->(dbclosearea())
				
				if round(_nsaldosb2,5)<>round(_nsaldosb8,5) .or.;
					round(_nclasssb2,5)<>round(_nclasssb8,5)
					_ldif:=.t.
				endif
			endif
			if sb1->b1_localiz=="S"
				_cquery:=" SELECT"
				_cquery+=" SUM(BF_QUANT) SALDO"
				_cquery+=" FROM "
				_cquery+=  retsqlname("SBF")+" SBF"
				_cquery+=" WHERE "
				_cquery+="     SBF.D_E_L_E_T_<>'*'"
				_cquery+=" AND BF_FILIAL='"+_cfilsbf+"'"
				_cquery+=" AND BF_PRODUTO='"+sb1->b1_cod+"'"
				_cquery+=" AND BF_LOCAL='"+sb2->b2_local+"'"
      		
				_cquery:=changequery(_cquery)
				
				tcquery _cquery new alias "TMP1"
				tcsetfield("TMP1","SALDO","N",15,5)
				
				tmp1->(dbgotop())
				_nsaldosbf:=tmp1->saldo
				tmp1->(dbclosearea())
				
				if round(_nsaldosb2-_nclasssb2,5)<>round(_nsaldosbf,5)
					_ldif:=.t.
				endif
				if sb1->b1_rastro=="L"
					_cquery:=" SELECT"
					_cquery+=" B8_LOTECTL LOTECTL,SUM(B8_SALDO-B8_QACLASS) SALDO"
					_cquery+=" FROM "
					_cquery+=  retsqlname("SB8")+" SB8"
					_cquery+=" WHERE "
					_cquery+="     SB8.D_E_L_E_T_<>'*'"
					_cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
					_cquery+=" AND B8_PRODUTO='"+sb1->b1_cod+"'"
					_cquery+=" AND B8_LOCAL='"+sb2->b2_local+"'"
					_cquery+=" GROUP BY"
					_cquery+=" B8_LOTECTL"
      			
					_cquery:=changequery(_cquery)
					
					tcquery _cquery new alias "TMP2"
					tcsetfield("TMP2","SALDO","N",15,5)
					
					tmp2->(dbgotop())
					while ! tmp2->(eof()) .and.;
							! _ldif
						_nsaldolot:=tmp2->saldo
						_cquery:=" SELECT"
						_cquery+=" SUM(BF_QUANT) SALDO"
						_cquery+=" FROM "
						_cquery+=  retsqlname("SBF")+" SBF"
						_cquery+=" WHERE "
						_cquery+="     SBF.D_E_L_E_T_<>'*'"
						_cquery+=" AND BF_FILIAL='"+_cfilsbf+"'"
						_cquery+=" AND BF_PRODUTO='"+sb1->b1_cod+"'"
						_cquery+=" AND BF_LOCAL='"+sb2->b2_local+"'"
						_cquery+=" AND BF_LOTECTL='"+tmp2->lotectl+"'"
		      		
						_cquery:=changequery(_cquery)
						
						tcquery _cquery new alias "TMP1"
						tcsetfield("TMP1","SALDO","N",15,5)
						
						tmp1->(dbgotop())
						_nsaldoend:=tmp1->saldo
						tmp1->(dbclosearea())
						
						if round(_nsaldolot,5)<>round(_nsaldoend,5)
							_ldif:=.t.
						endif
						tmp2->(dbskip())
					end
				endif
			endif
			if _ldif
				if prow()==0 .or. prow()>52
					cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
				endif
				@ prow()+1,000 PSAY sb1->b1_cod
				@ prow(),012   PSAY left(sb1->b1_desc,53)
				@ prow(),065   PSAY sb2->b2_local
				@ prow(),068   PSAY _nsaldosb2-_nclasssb2 picture "@E 999,999,999,999.99999"
				if sb1->b1_rastro=="L"
					@ prow(),089   PSAY _nsaldosb8-_nclasssb8 picture "@E 999,999,999,999.99999"
				endif
				if sb1->b1_localiz=="S"
					@ prow(),108   PSAY _nsaldosbf picture "@E 999,999,999,999.99999"
				endif
				if sb1->b1_rastro=="L" .and.;
					sb1->b1_localiz=="S"
					tmp2->(dbgotop())
					while ! tmp2->(eof())
						_nsaldolot:=tmp2->saldo
						_cquery:=" SELECT"
						_cquery+=" SUM(BF_QUANT) SALDO"
						_cquery+=" FROM "
						_cquery+=  retsqlname("SBF")+" SBF"
						_cquery+=" WHERE "
						_cquery+="     SBF.D_E_L_E_T_<>'*'"
						_cquery+=" AND BF_FILIAL='"+_cfilsbf+"'"
						_cquery+=" AND BF_PRODUTO='"+sb1->b1_cod+"'"
						_cquery+=" AND BF_LOCAL='"+sb2->b2_local+"'"
						_cquery+=" AND BF_LOTECTL='"+tmp2->lotectl+"'"
		      		
						_cquery:=changequery(_cquery)
						
						tcquery _cquery new alias "TMP1"
						tcsetfield("TMP1","SALDO","N",15,5)
						
						tmp1->(dbgotop())
						_nsaldoend:=tmp1->saldo
						tmp1->(dbclosearea())
						
						if round(_nsaldolot,5)<>round(_nsaldoend,5)
							if prow()>53
								cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
							endif
							@ prow()+1,070 PSAY "LOTE: "+tmp2->lotectl
							@ prow(),089   PSAY _nsaldolot picture "@E 999,999,999,999.99999"
							@ prow(),108   PSAY _nsaldoend picture "@E 999,999,999,999.99999"
							sbf->(dbseek(_cfilsbf+sb1->b1_cod+sb2->b2_local+tmp2->lotectl))
							while ! sbf->(eof()) .and.;
									sbf->bf_filial==_cfilsbf .and.;
									sbf->bf_produto==sb1->b1_cod .and.;
									sbf->bf_lotectl==tmp2->lotectl
								if prow()>54
									cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
								endif
								@ prow()+1,065 PSAY "LOCALIZACAO: "+sbf->bf_localiz
								@ prow(),108   PSAY sbf->bf_quant picture "@E 999,999,999,999.99999"
								sbf->(dbskip())
							end
						endif
						tmp2->(dbskip())
					end
				endif
				@ prow()+1,000 PSAY replicate("-",limite)
			endif
			if select("TMP2")>0
				tmp2->(dbclosearea())
			endif
			sb2->(dbskip())
		end
	endif
	sb1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

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
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Do almoxarifado    ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o almoxarifado ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
CODIGO          DESCRICAO                                             AR         QUANT. SB2          QUANT. SB8          QUANT. SBF
xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 
                                                                            LOTE: XXXXXXXXXX 999.999.999.999,99  999.999.999.999,99 
                                                                     LOCALIZACAO: XXXXXXXXXX                     999.999.999.999,99 
*/
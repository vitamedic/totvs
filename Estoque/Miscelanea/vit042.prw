/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT042   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 14/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acerto do SD5 Baseado no SD2                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"

user function vit042()
cperg:="PERGVIT042"
_pergsx1()
if pergunte(cperg,.t.) .and.;
	msgyesno("Confirma acerto do SD5 pelo SD2?")
	processa({|| _acerta()})
	msginfo("Acerto finalizado com sucesso!")
endif
return

static function _acerta()
procregua(sd2->(lastrec()))

_cfilsb8:=xfilial("SB8")
_cfilsd2:=xfilial("SD2")
_cfilsd5:=xfilial("SD5")
sb8->(dbsetorder(3))
sd2->(dbsetorder(5))

_cindsd5:=criatrab(,.f.)
_cchave :='D5_FILIAL+D5_PRODUTO+D5_LOCAL+D5_LOTECTL+D5_DOC+D5_SERIE+D5_CLIFOR+D5_LOJA+D5_ORIGLAN+DTOS(D5_DATA)'
_cfiltro:='! EMPTY(D5_DOC) .AND. D5_ORIGLAN>="501" .AND. D5_ORIGLAN<="999" .AND. ! EMPTY(D5_CLIFOR) .AND. D5_ESTORNO<>"S"'
sd5->(indregua("SD5",_cindsd5,_cchave,,_cfiltro,"Selecionando registros..."))

sd2->(dbseek(_cfilsd2+dtos(mv_par01),.t.))
while ! sd2->(eof()) .and.;
		sd2->d2_filial==_cfilsd2 .and.;
		sd2->d2_emissao<=mv_par02
	incproc("Acertando SD5...")
	if ! empty(sd2->d2_lotectl) .and.;
		sd2->d2_cod>=mv_par03 .and.;
		sd2->d2_cod<=mv_par04 .and.;
		sd2->d2_local>=mv_par05 .and.;
		sd2->d2_local<=mv_par06 .and.;
		! sd5->(dbseek(_cfilsd5+sd2->d2_cod+sd2->d2_local+sd2->d2_lotectl+sd2->d2_doc+sd2->d2_serie+sd2->d2_cliente+sd2->d2_loja+sd2->d2_tes+dtos(sd2->d2_emissao))) .and.;
		sb8->(dbseek(_cfilsb8+sd2->d2_cod+sd2->d2_local+sd2->d2_lotectl))
		_ntotal :=0
		_ntotal2:=0
		while ! sb8->(eof()) .and.;
				sb8->b8_filial==_cfilsb8 .and.;
				sb8->b8_produto==sd2->d2_cod .and.;
				sb8->b8_local==sd2->d2_local .and.;
				sb8->b8_lotectl==sd2->d2_lotectl .and.;
				_ntotal<sd2->d2_quant
			if sb8->b8_saldo>0
				if sb8->b8_saldo>(sd2->d2_quant-_ntotal)
					_nquant :=(sd2->d2_quant-_ntotal)
					_nquant2:=(sd2->d2_qtsegum-_ntotal2)
				else
					_nquant :=sb8->b8_saldo
					_nquant2:=sb8->b8_saldo2
				endif
				_ntotal +=_nquant
				_ntotal2+=_nquant2
				sd5->(reclock("SD5",.t.))
				sd5->d5_filial :=sd2->d2_filial
				sd5->d5_produto:=sd2->d2_cod
				sd5->d5_local  :=sd2->d2_local
				sd5->d5_doc    :=sd2->d2_doc
				sd5->d5_serie  :=sd2->d2_serie
				sd5->d5_data   :=sd2->d2_emissao
				sd5->d5_origlan:=sd2->d2_tes
				sd5->d5_numseq :=sd2->d2_numseq
				sd5->d5_clifor :=sd2->d2_cliente
				sd5->d5_loja   :=sd2->d2_loja
				sd5->d5_quant  :=_nquant
				sd5->d5_lotectl:=sd2->d2_lotectl
				sd5->d5_numlote:=sb8->b8_numlote
				sd5->d5_dtvalid:=sd2->d2_dtvalid
				sd5->d5_qtsegum:=_nquant2
				sd5->(msunlock())
				sb8->(reclock("SB8",.f.))
				sb8->b8_saldo -=_nquant
				sb8->b8_saldo2-=_nquant2
				sb8->(msunlock())
			endif
			sb8->(dbskip())
		end
	endif
	sd2->(dbskip())
end
sd5->(retindex("SD5"))
_cindsd5+=sd5->(ordbagext())
ferase(_cindsd5)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"04","Ate o produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"05","Do armazem         ?","mv_ch5","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate o armazem      ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

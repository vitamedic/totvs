/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ QG002  ³ Autor ³                        ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acerta Quantidade Entregue no SC6 pelo SD2                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"

user function qg002()
if sm0->m0_codigo<>"02" .or.;
	(upper(alltrim(getenvserver()))<>"BACKUP" .and. upper(alltrim(getenvserver()))<>"BKP")
	msgstop("Este programa so pode ser executado na empresa 02, ambiente backup!")
	return
endif
if tclink("oracle/dadosadv","192.168.1.20")<>0
	msgstop("Falha de conexao com o banco!")
	tcquit()
	return
endif
cperg:="QG002 "
_pergsx1()

if pergunte(cperg,.t.) .and.;
	msgyesno("Acertar quantidade entregue no SC6?")
	processa({|| _acerta()})
	msginfo("Processamento finalizado com sucesso!")
endif
tcquit()
return

static function _acerta()
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsd2:=xfilial("SD2")
sd2->(dbsetorder(8))

_abretop("SC5010",1)
_abretop("SC6010",1)
_abretop("SD2010",8)

procregua(sc6010->(lastrec()))

sc6010->(dbseek(_cfilsc6+mv_par01,.t.))
_cnum  :=sc6010->c6_num
_anota :={}
_lresid:=.f.
aadd(_anota,{sc6010->c6_nota,sc6010->c6_serie})
if round(sc6010->c6_qtdven,2)<>round(sc6010->c6_qtdent,2) .and.;
	sc6010->c6_blq<>"R "
	_lresid:=.t.
endif
while ! sc6010->(eof()) .and.;
		sc6010->c6_filial==_cfilsc6 .and.;
		sc6010->c6_num<=mv_par02
	incproc("Acertando quantidade entregue no pedido "+sc6010->c6_num)

	_nquant:=0
	sd2->(dbseek(_cfilsd2+sc6010->c6_num+sc6010->c6_item))
	while ! sd2->(eof()) .and.;
			sd2->d2_filial==_cfilsd2 .and.;
			sd2->d2_pedido==sc6010->c6_num .and.;
			sd2->d2_itempv==sc6010->c6_item
		_nquant+=sd2->d2_quant
		sd2->(dbskip())
	end
	sd2010->(dbseek(_cfilsd2+sc6010->c6_num+sc6010->c6_item))
	while ! sd2010->(eof()) .and.;
			sd2010->d2_filial==_cfilsd2 .and.;
			sd2010->d2_pedido==sc6010->c6_num .and.;
			sd2010->d2_itempv==sc6010->c6_item
		_nquant+=sd2010->d2_quant
		sd2010->(dbskip())
	end
	sc6010->(reclock("SC6010",.f.))
	if _nquant>sc6010->c6_qtdven
		sc6010->c6_qtdent:=sc6010->c6_qtdven
	else
		sc6010->c6_qtdent:=_nquant
	endif
	sc6010->(msunlock())
	sc6010->(dbskip())
	if sc6010->c6_num<>_cnum
		if sc5010->(dbseek(_cfilsc5+_cnum))
			sc5010->(reclock("SC5010",.f.))
			if _lresid
				sc5010->c5_nota :=space(6)
				sc5010->c5_serie:=space(3)
			else
				if len(_anota)>1
					sc5010->c5_nota :="XXXXXX"
					sc5010->c5_serie:=space(3)
				else
					if empty(_anota[1,1])
						sc5010->c5_nota :="XXXXXX"
						sc5010->c5_serie:=space(3)
					else
						sc5010->c5_nota :=_anota[1,1]
						sc5010->c5_serie:=_anota[1,2]
					endif
				endif
				sc5010->c5_liberok:="S"
			endif
			sc5010->(msunlock())
		endif
		_cnum  :=sc6010->c6_num
		_anota :={}
		_lresid:=.f.
		aadd(_anota,{sc6010->c6_nota,sc6010->c6_serie})
	else
		_i:=ascan(_anota,{|x| x[1]==sc6010->c6_nota .and. x[2]==sc6010->c6_serie})
		if _i==0
			aadd(_anota,{sc6010->c6_nota,sc6010->c6_serie})
		endif
	endif
	if round(sc6010->c6_qtdven,2)<>round(sc6010->c6_qtdent,2) .and.;
		sc6010->c6_blq<>"R "
		_lresid:=.t.
	endif
end
sc5010->(dbclosearea())
sc6010->(dbclosearea())
sd2010->(dbclosearea())
return

static function _abretop(_carq,_nordem)
_calias:=left(_carq,3)
dbusearea(.t.,"TOPCONN",_carq,_carq,.t.,.f.)
six->(dbseek(_calias))
while ! six->(eof()) .and.;
		six->indice==_calias
	dbsetindex(_carq+six->ordem)
	six->(dbskip())
end
dbsetorder(_nordem)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do pedido          ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o pedido       ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
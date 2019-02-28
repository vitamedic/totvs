/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT015   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 23/01/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ordem de Separacao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function vit015()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="ORDEM DE SEPARACAO"
cdesc1   :="Este programa ira emitir a ordem de separacao"
cdesc2   :=""
cdesc3   :=""
cstring  :="SC9"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT015"
wnrel    :="VIT015"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT015"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)

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

cabec1:=""
cabec2:=""

_cfilsa1:=xfilial("SA1")
_cfilsa3:=xfilial("SA3")
_cfilsa4:=xfilial("SA4")
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsc9:=xfilial("SC9")
_cfilsdc:=xfilial("SDC")
_cfilsb1:=xfilial("SB1")
sa1->(dbsetorder(1))
sa3->(dbsetorder(1))
sa4->(dbsetorder(1))
sb1->(dbsetorder(1))
sc5->(dbsetorder(1))
sc9->(dbsetorder(1))  
sdc->(dbsetorder(1))
sb1->(dbsetorder(1))

_carqtmp1:=""
_cindtmp1:=""

processa({|| _geratmp()})

setprc(0,0)
//@ 000,000 PSAY chr(15)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	_ccliente:=tmp1->cliente
	_cloja   :=tmp1->loja
	_ctabela :=tmp1->tabela
	_ccateg  :=tmp1->categ
	_apedido :={}
	_nregtmp1:=tmp1->(recno())
	while ! tmp1->(eof()) .and.;
		tmp1->cliente==_ccliente .and.;
		tmp1->loja==_cloja .and.;
		tmp1->tabela==_ctabela .and.;
		tmp1->categ==_ccateg
		_i:=ascan(_apedido,tmp1->pedido)
		if _i==0
			aadd(_apedido,tmp1->pedido)
		endif
		tmp1->(dbskip())
	end
	_apedidos:=asort(_apedido)
	tmp1->(dbgoto(_nregtmp1))
	while ! tmp1->(eof()) .and.;
		tmp1->cliente==_ccliente .and.;
		tmp1->loja==_cloja .and.;
		tmp1->tabela==_ctabela .and.;
		tmp1->categ==_ccateg
		sc5->(dbseek(_cfilsc5+tmp1->pedido))
		sa4->(dbseek(_cfilsa4+sc5->c5_transp))
		sa3->(dbseek(_cfilsa3+sc5->c5_vend1))
		sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		_ncol:=16
		@ prow()+1,000 PSAY "PEDIDO(S).....:"
		for _i:=1 to len(_apedidos)
			if _i==1
				@ prow(),_ncol PSAY _apedidos[_i] +" - CLIENTE: "+ sa1->a1_nome 
				_ncol+=6
			else
				@ prow(),_ncol PSAY "/"+_apedidos[_i] +" - CLIENTE: "+ sa1->a1_nome 
				_ncol+=7
			endif
		next
		@ prow()+1,000 PSAY "TRANSPORTADORA: "+sc5->c5_transp+" - "+sa4->a4_nome
		@ prow()+1,000 PSAY "VENDEDOR......: "+sc5->c5_vend1+" - "+sa3->a3_nome
		@ prow()+1,000 PSAY "CIDADE - UF...: "+alltrim(sa1->a1_mun)+" - "+sa1->a1_est
		@ prow()+2,000 PSAY "VOLUMES..: _________________________                                         DATA DE SEPARACAO: ____/____/____"
		@ prow()+2,000 PSAY "SEPARADOR: _________________________ CONFERENTE: _________________________ RESPONSAVEL: ______________________"
		@ prow()+2,000 PSAY "HORARIO..: _____:_____  _____:_____               _____:_____  _____:_____               ____:____   ____:____"
		@ prow()+1,000 PSAY replicate("-",limite)
		@ prow()+1,000 PSAY "CODIGO  DESCRICAO                                 UM    QT.TOTAL  QT.CX   EMB   QT.FRAC.  ATEN  CONF  LOTE     VAL    ENDERECO"
		@ prow()+1,000 PSAY replicate("-",limite)
		_ntotqtd:=0
		_ntotcx :=0
		_ntotun :=0
		_npesobr :=0
		_npesolq :=0
		while ! tmp1->(eof()) .and.;
			tmp1->cliente==_ccliente .and.;
			tmp1->loja==_cloja .and.;
			tmp1->tabela==_ctabela .and.;
			tmp1->categ==_ccateg
			_nqtd:=0
			_ncx :=0
			_nun :=0
			sb1->(dbseek(_cfilsb1+tmp1->produto))
			_cproduto:=tmp1->produto
			_clotectl:=tmp1->lotectl
			_clocaliz:=tmp1->localiz
			_dtvalid :=substr(dtoc(tmp1->dtvalid),4,2)+"/"+substr(dtoc(tmp1->dtvalid),7,2)
			while ! tmp1->(eof()) .and.;
				tmp1->cliente==_ccliente .and.;
				tmp1->loja==_cloja .and.;
				tmp1->tabela==_ctabela .and.;
				tmp1->categ==_ccateg .and.;
				tmp1->produto==_cproduto .and.;
				tmp1->lotectl==_clotectl .and.;
				tmp1->localiz==_clocaliz
				_nqtd+=tmp1->qtdlib
				tmp1->(dbskip())
			end
			if prow()>54
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
				@ prow()+1,000 PSAY "PEDIDO(S).....:"
				@ prow()+1,000 PSAY " "
			endif
			_ncx+=int(_nqtd/sb1->b1_cxpad)
			_nun+=_nqtd%sb1->b1_cxpad
//CODIGO  DESCRICAO                                 UM   QT.TOTAL   QT.CX   EMB   QT.FRAC.  ATEN  CONF  LOTE     VAL    ENDERECO
//999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX  999999.99     999   999       999   ____  (  )  013140   02/12  01001

			@ prow()+1,000 PSAY left(_cproduto,6)
			@ prow(),008   PSAY left(sb1->b1_desc,27)
			@ prow(),050   PSAY sb1->b1_um
			@ prow(),054   PSAY _nqtd picture "@E 999,999.99"
			@ prow(),068   PSAY _ncx  picture "@E 999"
			@ prow(),074   PSAY sb1->b1_cxpad picture "@E 999"
			@ prow(),084   PSAY _nun  picture "@E 999"
			@ prow(),090   PSAY "____"
			@ prow(),096   PSAY "(  )"
			@ prow(),102   PSAY left(_clotectl,6)
			@ prow(),111   PSAY _dtvalid 
			@ prow(),118   PSAY left(_clocaliz,10)

			_npesobr += _ncx*(sb1->b1_pesbru*sb1->b1_cxpad)      
			_npesolq += _ncx*(sb1->b1_peso*sb1->b1_cxpad)      
			_ntotqtd+=_nqtd
			_ntotcx +=_ncx
			_ntotun +=_nun
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				eject
				lcontinua:=.f.
			endif
		end
		@ prow()+2,000 PSAY "TOTAL"
		@ prow(),045   PSAY _ntotqtd picture "@E 999999"
		@ prow(),052   PSAY _ntotcx  picture "@E 999"
		@ prow(),060   PSAY _ntotun  picture "@E 999"
		@ prow()+2,000 PSAY sc5->c5_menped
		@ prow()+1,000 PSAY "PESO BRUTO:"
		@ prow(),020   PSAY _npesobr picture "@E 999,999.99"
		@ prow(),035   PSAY "PESO LIQUIDO:"
		@ prow(),049   PSAY _npesolq picture "@E 999,999.99"
		if _ccateg <> " "
			@ prow()+2,000 PSAY "Categoria :"+if(_ccateg=="N","Negativa","Positiva") 
  		endif	
	end
end
if prow()>0 .and.;
	lcontinua
	roda(cbcont,cbtxt)
endif

set device to screen

_cindtmp1+=tmp1->(ordbagext())
tmp1->(dbclosearea())
ferase(_carqtmp1+getdbextension())
ferase(_cindtmp1)

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()
return


static function _geratmp()
procregua(1)

incproc("Selecionando pedidos...")

_aestrut:={}
aadd(_aestrut,{"CLIENTE"  ,"C",06,0})
aadd(_aestrut,{"LOJA"     ,"C",02,0})
aadd(_aestrut,{"TABELA"   ,"C",03,0})
aadd(_aestrut,{"CATEG"    ,"C",01,0})
aadd(_aestrut,{"DESCRICAO","C",40,0})
aadd(_aestrut,{"PRODUTO"  ,"C",15,0})
aadd(_aestrut,{"LOTECTL"  ,"C",10,0})
aadd(_aestrut,{"LOCALIZ"  ,"C",15,0})
aadd(_aestrut,{"PEDIDO"   ,"C",06,0})
aadd(_aestrut,{"QTDLIB"   ,"N",09,2})
aadd(_aestrut,{"DTVALID"   ,"D",06,0})

_carqtmp1:=criatrab(_aestrut,.t.)
dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)

_cindtmp1:=criatrab(,.f.)
_cchave :='CLIENTE+LOJA+TABELA+CATEG+DESCRICAO+PRODUTO+LOTECTL+PEDIDO'
tmp1->(indregua("TMP1",_cindtmp1,_cchave,,,"Selecionando registros..."))
sc9->(dbseek(_cfilsc9+mv_par01,.t.))
while ! sc9->(eof()) .and.;
	sc9->c9_filial==_cfilsc9 .and.;
	sc9->c9_pedido<=mv_par02
	if sc9->c9_datalib>=mv_par03 .and.;
		sc9->c9_datalib<=mv_par04 .and.;
		sc9->c9_cliente>=mv_par05 .and.;
		sc9->c9_loja>=mv_par06 .and.;
		sc9->c9_cliente<=mv_par07 .and.;
		sc9->c9_loja<=mv_par08
		_cpedido:=sc9->c9_pedido
		sc5->(dbseek(_cfilsc5+_cpedido))
		if sc5->c5_tipo=="N"
			_nregsc9:=sc9->(recno())
			_lok:=.t.
			while ! sc9->(eof()) .and.;
				sc9->c9_filial==_cfilsc9 .and.;
				sc9->c9_pedido==_cpedido
				if empty(sc9->c9_nfiscal)
					if ! empty(sc9->c9_blcred) .or. ! empty(sc9->c9_blest)
						_lok:=.f.
					endif
				endif
				sc9->(dbskip())
			end
			if _lok
				sc9->(dbgoto(_nregsc9))
				while ! sc9->(eof()) .and.;
					sc9->c9_filial==_cfilsc9 .and.;
					sc9->c9_pedido==_cpedido
					if empty(sc9->c9_nfiscal) .and.;
						empty(sc9->c9_blcred) .and.;
						empty(sc9->c9_blest)
						
						sb1->(dbseek(_cfilsb1+sc9->c9_produto))

						if sb1->b1_localiz=='S'
	        				_cquery:= "SELECT "
	        				_cquery+= " DC_PRODUTO PRODUTO,"
	        				_cquery+= " DC_LOTECTL LOTECTL,"
	        				_cquery+= " DC_LOCALIZ LOCALIZ,"
	        				_cquery+= " DC_PEDIDO PEDIDO,"
	        				_cquery+= " DC_QUANT QUANT"
	        				_cquery+= " FROM"
	        				_cquery+= retsqlname("SDC")+" SDC"
	        				_cquery+= " WHERE"
	        				_cquery+= " SDC.D_E_L_E_T_=' '"
	        				_cquery+= " AND SDC.DC_PRODUTO='"+sc9->c9_produto+"'"
	        				_cquery+= " AND SDC.DC_PEDIDO='"+sc9->c9_pedido+"'"
	        				_cquery+= " AND SDC.DC_ITEM='"+sc9->c9_item+"'"
	        				_cquery+= " AND SDC.DC_LOTECTL='"+sc9->c9_lotectl+"'"
							/* incluido para tratamento de diversos empenhos parciais para o mesmo lote num mesmo pedido e faturamento*/
	        				_cquery+= " AND SDC.DC_SEQ='"+sc9->c9_sequen+"'"
	        				_cquery+= " ORDER BY DC_PEDIDO, DC_PRODUTO, DC_LOTECTL, DC_LOCALIZ"
	
							_cquery:=changequery(_cquery)
		
							tcquery _cquery new alias "TMP3"
	
							tmp3->(dbgotop())
						  
							while ! tmp3->(eof())
								sb1->(dbseek(_cfilsb1+sc9->c9_produto))
								tmp1->(dbappend())
								tmp1->cliente  :=sc9->c9_cliente
								tmp1->loja     :=sc9->c9_loja
								tmp1->tabela   :=sc5->c5_tabela
								tmp1->categ    :=if(sc5->c5_percfat==100," ",left(sb1->b1_categ,1))
								tmp1->descricao:=sb1->b1_desc   
								tmp1->dtvalid  :=sc9->c9_dtvalid
								tmp1->produto  :=sc9->c9_produto
								tmp1->lotectl  :=sc9->c9_lotectl
								tmp1->pedido   :=sc9->c9_pedido
	//							tmp1->qtdlib   :=sc9->c9_qtdlib
								tmp1->qtdlib   :=tmp3->quant
								tmp1->localiz  :=tmp3->localiz
	
								tmp3->(dbskip())
								sc9->(reclock("SC9",.f.))
								sc9->c9_impsep :="S"
								sc9->c9_datasep:=ddatabase
								sc9->c9_horasep:=left(time(),5)
								sc9->c9_ususep :=cusername
								sc9->(msunlock())
		
							end
							tmp3->(dbclosearea())		
						else
							sb1->(dbseek(_cfilsb1+sc9->c9_produto))
							tmp1->(dbappend())
							tmp1->cliente  :=sc9->c9_cliente
							tmp1->loja     :=sc9->c9_loja
							tmp1->tabela   :=sc5->c5_tabela
							tmp1->categ    :=if(sc5->c5_percfat==100," ",left(sb1->b1_categ,1))
							tmp1->descricao:=sb1->b1_desc   
							tmp1->dtvalid  :=sc9->c9_dtvalid
							tmp1->produto  :=sc9->c9_produto
							tmp1->lotectl  :=sc9->c9_lotectl
							tmp1->pedido   :=sc9->c9_pedido
							tmp1->qtdlib   :=sc9->c9_qtdlib
							tmp1->localiz  :=""      

							sc9->(reclock("SC9",.f.))
							sc9->c9_impsep :="S"
							sc9->c9_datasep:=ddatabase
							sc9->c9_horasep:=left(time(),5)
							sc9->c9_ususep :=cusername
							sc9->(msunlock())					
						endif                
						
					endif
					sc9->(dbskip())
				end
			endif
		else
			sc9->(dbskip())
		endif
	else
		sc9->(dbskip())
	endif
end
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do pedido          ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o pedido       ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da data            ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a data         ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do cliente         ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"06","Da loja            ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Ate o cliente      ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"08","Ate a loja         ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
PEDIDO(S).....: 999999/999999
TRANSPORTADORA: 999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
VENDEDOR......: 999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
CIDADE - UF...: XXXXXXXXXXXXXXXXXXXXXXXXX - XX

VOLUMES..: _______________                        DATA DE SEPARACAO: ___/___/___

SEPARADOR: _______________ CONFERENTE: _______________ RESPONSAVEL: ____________

HORARIO..: ___:___ ___:___             ___:___ ___:___              __:__  __:__

CODIGO DESCRICAO                          UM   QTDE  CX EMB  UN ATEN CONF LOTE
999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 999999 999 999 999 ____ (__) 999999
*/

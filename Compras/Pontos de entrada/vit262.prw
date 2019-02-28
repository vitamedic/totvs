/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT262   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 16/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa chamado pelo botao especifico na análise da       ³±±
±±³          ³ cotacao de compras para consulta do historico de compras   ³±±
±±³          ³ do produto                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit262(_cproduto)
private ogetseg,odlg2,aheader,acols,n

_aarea  :=getarea()
_aheader:=aheader
_acols  :=acols
_n      :=n

aheader:={}
acols  :={}
n      :=1

_cfilsa2:=xfilial("SA2")
_cfilsd1:=xfilial("SD1")
_cfilsf4:=xfilial("SF4")

cperg:="PERGVIT262"
_pergsx1()

if pergunte(cperg,.t.)
	
	processa({|| _geratmp(_cproduto)})
	
	aadd(aheader,{"Nome fornecedor","A2_NOME"   ,"@!"                      ,40,0,"ALLWAYSTRUE()","û","C","SA2"})
	aadd(aheader,{"Entrada"        ,"D1_DTDIGIT","@D"                      ,08,0,"ALLWAYSTRUE()","û","D","SD1"})
	aadd(aheader,{"Quantidade"     ,"D1_QUANT"  ,"@E 99,999,999.99"        ,11,2,"ALLWAYSTRUE()","û","N","SD1"})
	aadd(aheader,{"Vl.unitario"    ,"D1_VUNIT"  ,"@E 99,999,999,999.999999",18,6,"ALLWAYSTRUE()","û","N","SD1"})
	aadd(aheader,{"Vl.total"       ,"D1_TOTAL"  ,"@E 99,999,999,999.99"    ,14,2,"ALLWAYSTRUE()","û","N","SD1"})
	aadd(aheader,{"Vl.IPI"         ,"D1_VALIPI" ,"@E 99,999,999,999.99"    ,14,2,"ALLWAYSTRUE()","û","N","SD1"})
	aadd(aheader,{"Custo unit."    ,"D1_CUSTO5" ,"@E 99,999,999,999.99999" ,17,5,"ALLWAYSTRUE()","û","N","SD1"})
	aadd(aheader,{"Custo total"    ,"D1_CUSTO"  ,"@E 99,999,999,999.99999" ,17,5,"ALLWAYSTRUE()","û","C","SD1"})
	aadd(aheader,{"Fornecedor"     ,"D1_FORNECE","@!"                      ,06,0,"ALLWAYSTRUE()","û","C","SD1"})
	aadd(aheader,{"Loja"           ,"D1_LOJA"   ,"@!"                      ,02,0,"ALLWAYSTRUE()","û","C","SD1"})
	aadd(aheader,{"Nota"           ,"D1_DOC"    ,"@!"                      ,06,0,"ALLWAYSTRUE()","û","C","SD1"})
	aadd(aheader,{"Serie"          ,"D1_SERIE"  ,"@!"                      ,03,0,"ALLWAYSTRUE()","û","C","SD1"})
	aadd(aheader,{"Emissao"        ,"D1_EMISSAO","@D"                      ,08,0,"ALLWAYSTRUE()","û","D","SD1"})
	aadd(aheader,{"Pedido"         ,"D1_PEDIDO" ,"@!"                      ,06,0,"ALLWAYSTRUE()","û","C","SD1"})
	
	nusado:=len(aheader)
	_ni:=1
	tmp1->(dbgotop())
	while ! tmp1->(eof())
		aadd(acols,array(nusado+1))
		for _nj:=1 to nusado
			acols[_ni,_nj]:=tmp1->(fieldget(fieldpos(aheader[_nj,2])))
		next
		acols[_ni,nusado+1]:=.f.
		_ni++
		tmp1->(dbskip())
	end
	if len(acols)==0
		aadd(acols,array(nusado+1))
		for _nj:=1 to nusado
			acols[1,_nj]:=criavar(aheader[_nj,2],.t.)
		next
	endif
	
	ctitulo:="Historico de compras"
	nopca:=1
	nopcx:=2
	aaltera:={}
	abotoes:={}
	
	define msdialog odlg2 title ctitulo pixel from 0,0 to 400,650 of omainwnd
	
	ogetseg:=msgetdados():new(15,1,200,325,nopcx,"ALLWAYSTRUE()","ALLWAYSTRUE()","",.t.)
	
	activate msdialog odlg2 on init enchoicebar(odlg2,{|| nopca:=1,if(ogetseg:tudook(),odlg2:end(),nopca:=0)},{||odlg2:end()},,abotoes) centered
	
	tmp1->(dbclosearea())
endif

aheader:=_aheader
acols  :=_acols
n      :=_n
restarea(_aarea)
return()

static function _geratmp(_cproduto)
procregua(1)

incproc("Calculando entradas...")

_cquery:=" SELECT"
_cquery+=" D1_DTDIGIT,"
_cquery+=" D1_QUANT,"
_cquery+=" D1_VUNIT,"
_cquery+=" D1_TOTAL,"
_cquery+=" D1_VALIPI,"
_cquery+=" (D1_CUSTO/D1_QUANT) D1_CUSTO5,"
_cquery+=" D1_CUSTO,"
_cquery+=" D1_FORNECE,"
_cquery+=" D1_LOJA,"
_cquery+=" A2_NOME,"
_cquery+=" D1_DOC,"
_cquery+=" D1_SERIE,"
_cquery+=" D1_EMISSAO,"
_cquery+=" D1_PEDIDO"

_cquery+=" FROM "
_cquery+=  retsqlname("SA2")+" SA2,"
_cquery+=  retsqlname("SD1")+" SD1,"
_cquery+=  retsqlname("SF4")+" SF4"

_cquery+=" WHERE"
_cquery+="     SA2.D_E_L_E_T_<>'*'"
_cquery+=" AND SD1.D_E_L_E_T_<>'*'"
_cquery+=" AND SF4.D_E_L_E_T_<>'*'"
_cquery+=" AND A2_FILIAL='"+_cfilsa2+"'"
_cquery+=" AND D1_FILIAL='"+_cfilsd1+"'"
_cquery+=" AND F4_FILIAL='"+_cfilsf4+"'"
_cquery+=" AND D1_FORNECE=A2_COD"
_cquery+=" AND D1_LOJA=A2_LOJA"
_cquery+=" AND D1_TES=F4_CODIGO"
_cquery+=" AND D1_TIPO='N'"
_cquery+=" AND D1_COD='"+_cproduto+"'"
_cquery+=" AND D1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
if mv_par03==1
	_cquery+=" AND F4_ESTOQUE='S'"
elseif mv_par03==2
	_cquery+=" AND F4_ESTOQUE='N'"
endif
if mv_par04==1
	_cquery+=" AND F4_DUPLIC='S'"
elseif mv_par04==2
	_cquery+=" AND F4_DUPLIC='N'"
endif

_cquery+=" ORDER BY"
_cquery+=" D1_DTDIGIT DESC,D1_DOC,D1_SERIE"

_cquery:=changequery(_cquery)

memowrit("vit262.sql",_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","D1_DTDIGIT","D")
tcsetfield("TMP1","D1_QUANT"  ,"N",11,2)
tcsetfield("TMP1","D1_VUNIT"  ,"N",18,6)
tcsetfield("TMP1","D1_TOTAL"  ,"N",14,2)
tcsetfield("TMP1","D1_VALIPI" ,"N",14,2)
tcsetfield("TMP1","D1_CUSTO5" ,"N",17,5)
tcsetfield("TMP1","D1_CUSTO"  ,"N",17,5)
tcsetfield("TMP1","D1_EMISSAO","D")
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Data de entrada de ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Data de entrada ate?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","TES mov. estoque   ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),"Ambos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","TES gera financeiro?","mv_ch4","N",01,0,0,"C",space(60),"mv_par04"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),"Ambos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

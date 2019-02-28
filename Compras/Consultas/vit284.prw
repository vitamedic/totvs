/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT284   ³ Autor ³ Heraildo C. de Freitas³ DATA ³ 30/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Consulta Pedidos De Compra em Aberto                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit284()
private l120auto
private ntipoped

l120auto:=.f.
ntipoped:=1

_cfilsc7:=xfilial("SC7")

cperg:="PERGVIT284"
_pergsx1()
if pergunte(cperg,.t.)
	
	arotina:={}
	aadd(arotina,{"Pesquisar" ,"PESQBRW"   ,0,1})
	aadd(arotina,{"Visualizar","A120PEDIDO",0,2})
	aadd(arotina,{"Imprimir"  ,"U_VIT091"  ,0,6})
	
	ccadastro:="Pedidos de compra em aberto"
	
	dbselectarea("SC7")
	dbsetorder(1)
	
	afixe:={}
	aadd(afixe,{"Numero"           ,"C7_NUM"})
	aadd(afixe,{"Item"             ,"C7_ITEM"})
	aadd(afixe,{"Emissao"          ,"C7_EMISSAO"})
	aadd(afixe,{"Fornecedor"       ,"C7_FORNECE"})
	aadd(afixe,{"Loja"             ,"C7_LOJA"})
	aadd(afixe,{"Nome Fornecedor"  ,"C7_NOMEFOR"})
	aadd(afixe,{"Produto"          ,"C7_PRODUTO"})
	aadd(afixe,{"Descricao Produto","C7_DESCRI"})
	aadd(afixe,{"Quantidade"       ,"C7_QUANT"})
	aadd(afixe,{"Unidade"          ,"C7_UM"})
	aadd(afixe,{"Preco"            ,"C7_PRECO"})
	aadd(afixe,{"Total"            ,"C7_TOTAL"})
	aadd(afixe,{"Qtd. Entregue"    ,"C7_QUJE"})
	aadd(afixe,{"Observacoes"      ,"C7_OBS"})
	
	cfiltro:="       C7_FILIAL=='"+_cfilsc7+"'"
	cfiltro+=" .AND. C7_FORNECE>='"+mv_par01+"'"
	cfiltro+=" .AND. C7_LOJA>='"+mv_par02+"'"
	cfiltro+=" .AND. C7_FORNECE<='"+mv_par03+"'"
	cfiltro+=" .AND. C7_LOJA<='"+mv_par04+"'"
	cfiltro+=" .AND. C7_PRODUTO>='"+mv_par05+"'"
	cfiltro+=" .AND. C7_PRODUTO<='"+mv_par06+"'"
	cfiltro+=" .AND. EMPTY(C7_RESIDUO)"
	cfiltro+=" .AND. C7_CONAPRO<>'B'"
	cfiltro+=" .AND. C7_QUJE<C7_QUANT"
	cfiltro+=" .AND. C7_TIPO==1"
	
	aindexsc7 :={}
	bfiltrabrw:={|| filbrowse("SC7",@aindexsc7,@cfiltro)}
	eval(bfiltrabrw)
	
	mbrowse(06,01,22,75,"SC7",afixe,"C7_QUJE")
	
	endfilbrw("SC7",aindexsc7)
endif
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do fornecedor                ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"FOR"})
aadd(_agrpsx1,{cperg,"02","Da loja                      ?","mv_ch2","C",02,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Ate o fornecedor             ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a loja                   ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"FOR"})
aadd(_agrpsx1,{cperg,"05","Do produto                   ?","mv_ch5","C",15,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"06","Ate o produto                ?","mv_ch6","C",15,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
	
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

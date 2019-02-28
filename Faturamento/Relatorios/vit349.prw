/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT349   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 01/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Pedidos Nao Faturados                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"            
#include "dialog.ch"
#include "topconn.ch"

user function vit349()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="RELATORIO DE PEDIDOS NAO FATURADOS"
cdesc1  :="Este programa ira emitir a relacao de pedidos nao faturados"
cdesc2  :=""
cdesc3  :=""
cstring :="SC5"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT349"
wnrel   :="VIT349"+Alltrim(cusername)
alinha  :={}
aordem  :={"Por Pedido","Por Produto","Por Cliente","Por Data Entrega","Por Vendedor"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.


_cperg:="PERGVIT349"
_pergsx1()
pergunte(_cperg,.f.)

//wnrel:=setprint(cstring,wnrel,_cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)
wnrel:=setprint(cstring,wnrel,_cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

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

rptstatus({|| rptdetail()})
return


static function rptdetail()
_cfilsb1:=xfilial("SB1")
_cfilsc5:=xfilial("SC5")
_cfilsc6:=xfilial("SC6")
_cfilsa1:=xfilial("SA1")
_cfilsf4:=xfilial("SF4")
_cfilsa3:=xfilial("SA3")
sb1->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(1))
sa1->(dbsetorder(1))
sf4->(dbsetorder(1))
sa3->(dbsetorder(1))

//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//

_aCabec := {}
_aDados := {}
_aSaldo := {}

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return
EndIf

if mv_par14==1
	_aCabec := {"Pedido", "Emissao","Cliente/Loja","Razao Social","Item","Produto","Descricao Produto","Dt Entrega","Qtd Pedida","Qtd Entregue","Qtd Pendente","Vlr Total","Vendedor"}
else
	_aCabec := {"Pedido", "Emissao","Cliente/Loja","Razao Social","Item","Produto","Descricao Produto","Dt Entrega","Qtd Pedida","Qtd Entregue","Qtd Pendente","Vlr Saldo","Vendedor"}
endif

processa({|| _querys()})
tmp1->(dbgotop())

While !tmp1->(Eof())         

if ((mv_par11==1 .or. mv_par11==3) .and. tmp1->blq=='R ') // Considera Resíduos e Registro com Resíduo eliminado
	if mv_par14==1 // Imprime valor total
		AAdd(_aDados, {tmp1->numero, tmp1->emissao, tmp1->cliente+'-'+tmp1->loja, tmp1->nomecli, tmp1->it, tmp1->produto, tmp1->descri, tmp1->entreg, tmp1->qtdven, tmp1->qtdent, 0, tmp1->vlrtot, tmp1->vendedor})
	else // Imprime Valor Saldo
		AAdd(_aDados, {tmp1->numero, tmp1->emissao, tmp1->cliente+'-'+tmp1->loja, tmp1->nomecli, tmp1->it, tmp1->produto, tmp1->descri, tmp1->entreg, tmp1->qtdven, tmp1->qtdent, 0, 0, tmp1->vendedor})
	endif
else // Item sem Resíduo eliminado
	AAdd(_aDados, {tmp1->numero, tmp1->emissao, tmp1->cliente+'-'+tmp1->loja, tmp1->nomecli, tmp1->it, tmp1->produto, tmp1->descri, tmp1->entreg, tmp1->qtdven, tmp1->qtdent, tmp1->qtdpend, tmp1->vlrtot, tmp1->vendedor})
endif
	tmp1->(dbSkip())
End

//AAdd(_aSaldo,_aCabec)

DlgToExcel({ {"ARRAY", "Pedido Nao Faturado - "+aOrdem[nOrdem], _aCabec, _aDados} })
tmp1->(dbclosearea())

set device to screen

ms_flush()
return

return


static function _querys()       


_cquery:=" SELECT"
_cquery+="  C6_NUM NUMERO,"
_cquery+="  C5_EMISSAO EMISSAO,"
_cquery+="  A1_COD CLIENTE,"
_cquery+="  A1_LOJA LOJA,"
_cquery+="  A1_NOME NOMECLI,"
_cquery+="  C6_ITEM IT,"
_cquery+="  C6_PRODUTO PRODUTO,"
_cquery+="  B1_DESC DESCRI,"
_cquery+="  C6_QTDVEN QTDVEN,"
_cquery+="  C6_ENTREG ENTREG,"
_cquery+="  C6_QTDENT QTDENT,"
_cquery+="  (C6_QTDVEN-C6_QTDENT) QTDPEND,"
if mv_par14==1  // Valor Total
	_cquery+="  CAST(C6_QTDVEN*C6_PRCVEN AS NUMERIC(14,2)) VLRTOT,"
else // Saldo
	_cquery+="  CAST((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN AS NUMERIC(14,2)) VLRTOT,"
endif
_cquery+="  C6_BLQ BLQ,"
_cquery+="  (SELECT A3_NOME FROM "+retsqlname("SA3")+" SA3 WHERE SA3.D_E_L_E_T_=' ' AND C5_VEND1=A3_COD) VENDEDOR"
_cquery+=" FROM "
_cquery+=  retsqlname("SC6")+" SC6, "
_cquery+=  retsqlname("SC5")+" SC5, "
_cquery+=  retsqlname("SA1")+" SA1, "
_cquery+=  retsqlname("SB1")+" SB1, "
//_cquery+=  retsqlname("SA3")+" SA3, "
_cquery+=  retsqlname("SF4")+" SF4"
_cquery+=" WHERE SC6.D_E_L_E_T_=' ' AND SC5.D_E_L_E_T_=' ' AND SA1.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' '"
_cquery+=" AND C5_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND C5_EMISSAO BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"
_cquery+=" AND C5_NUM=C6_NUM"
_cquery+=" AND C5_VEND1 BETWEEN '"+mv_par12+"' AND '"+mv_par13+"'"
_cquery+=" AND A1_COD=C6_CLI"
_cquery+=" AND A1_LOJA=C6_LOJA"
_cquery+=" AND A1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND C6_PRODUTO=B1_COD"
_cquery+=" AND C6_TES=F4_CODIGO"
if mv_par09==1 // Situação do Pedido
	_cquery+=" AND C6_QTDVEN-C6_QTDENT>0"
endif
if mv_par11=2 // Considera Resíduo Eliminado
	_cquery+=" AND C6_BLQ=' '"
elseif mv_par11==3
	_cquery+=" AND C6_BLQ = 'R '"
endif         

_cquery+=" AND B1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"

if mv_par15 == 1 //SOMENTE TIPOS SOLICITADOS POR PARAMETRO
 _cquery+=" AND B1_TIPO IN ('PA','PL','PN','PD','PM')"
elseif mv_par15 == 2
 _cquery+=" AND B1_TIPO IN ('PA')"
elseif mv_par15 == 3
 _cquery+=" AND B1_TIPO IN ('PN')"
elseif mv_par15 == 4
 _cquery+=" AND B1_TIPO IN ('PD')"
elseif mv_par15 == 5
 _cquery+=" AND B1_TIPO IN ('PA','PL')"
endif


if mv_par10==1 //TES Gera Financeiro
	_cquery+=" AND F4_DUPLIC = 'S'"
elseif mv_par10==2
	_cquery+=" AND F4_DUPLIC = 'N'"
endif                              
//_cquery+=" AND C5_VEND1=A3_COD"

if nOrdem=1 // Ordena Por Pedido
	_cquery+=" ORDER BY C6_NUM, C6_ITEM"

elseif 	nOrdem=2 // Ordena Por Produto
	_cquery+=" ORDER BY C6_PRODUTO, A1_COD, A1_LOJA, C6_NUM, C6_ITEM"

elseif 	nOrdem=2 // Ordena Por Cliente
	_cquery+=" ORDER BY A1_COD, A1_LOJA, C6_NUM, C6_ITEM"

elseif 	nOrdem=2 // Ordena Por Data de Entrega
	_cquery+=" ORDER BY C6_ENTREG, A1_COD, A1_LOJA, C6_NUM, C6_ITEM"

else // Ordena por Vendedor
//	_cquery+=" ORDER BY A3_NOME, A1_COD, A1_LOJA, C6_NUM, C6_ITEM"
	_cquery+=" ORDER BY 15, A1_COD, A1_LOJA, C6_NUM, C6_ITEM"
endif                                               

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"    
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","ENTREG","D")
tcsetfield("TMP1","QTDVEN","N",12,5)
tcsetfield("TMP1","QTDENT","N",12,5)
tcsetfield("TMP1","QTDPEND","N",12,5)
tcsetfield("TMP1","VLRTOT","N",12,5)

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Do Pedido          ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate o Pedido       ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Do Produto         ?","mv_ch3","C",15,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{_cperg,"04","Ate o Produto      ?","mv_ch4","C",15,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{_cperg,"05","Do Cliente         ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CLI"})
aadd(_agrpsx1,{_cperg,"06","Ate o Cliente      ?","mv_ch6","C",06,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CLI"})
aadd(_agrpsx1,{_cperg,"07","Da Data de Entrega ?","mv_ch7","D",08,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"08","Ate a Data Entrega ?","mv_ch8","D",08,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"09","Situcao do Pedido  ?","mv_ch9","N",01,0,0,"C",space(60),"mv_par09"       ,"Em aberto"      ,space(30),space(15),"Todos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"10","Com Geracao Duplic.?","mv_cha","N",01,0,0,"C",space(60),"mv_par10"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),"Ambos"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"11","Cons.Res.Eliminados?","mv_chb","N",01,0,0,"C",space(60),"mv_par11"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),"Somente"        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
//aadd(_agrpsx1,{_cperg,"12","Lista Tot.Faturados?","mv_chc","N",01,0,0,"C",space(60),"mv_par12"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"12","Do Vendedor        ?","mv_chc","C",06,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{_cperg,"13","Ate o Vendedor     ?","mv_chd","C",06,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
//aadd(_agrpsx1,{_cperg,"15","Qual Moeda         ?","mv_chf","N",01,0,0,"C",space(60),"mv_par15"       ,"Moeda 1"        ,space(30),space(15),"Moeda 2"        ,space(30),space(15),"Moeda 3"        ,space(30),space(15),"Moeda 4"        ,space(30),space(15),"Moeda 5"        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"14","Imprime            ?","mv_che","N",01,0,0,"C",space(60),"mv_par14"       ,"Valor Total"    ,space(30),space(15),"Saldo"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"15","Considera Tipo     ?","mv_chf","N",01,0,0,"C",space(60),"mv_par15"       ,"Todos "         ,space(30),space(15),"Somente PA"     ,space(30),space(15),"Somente PN"     ,space(30),space(15),"Somente PD"     ,space(30),space(15),"Somente PA,PL"  ,space(30),"   "})

for i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[i,1]+_agrpsx1[i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[i,01]
		sx1->x1_ordem  :=_agrpsx1[i,02]
		sx1->x1_pergunt:=_agrpsx1[i,03]
		sx1->x1_variavl:=_agrpsx1[i,04]
		sx1->x1_tipo   :=_agrpsx1[i,05]
		sx1->x1_tamanho:=_agrpsx1[i,06]
		sx1->x1_decimal:=_agrpsx1[i,07]
		sx1->x1_presel :=_agrpsx1[i,08]
		sx1->x1_gsc    :=_agrpsx1[i,09]
		sx1->x1_valid  :=_agrpsx1[i,10]
		sx1->x1_var01  :=_agrpsx1[i,11]
		sx1->x1_def01  :=_agrpsx1[i,12]
		sx1->x1_cnt01  :=_agrpsx1[i,13]
		sx1->x1_var02  :=_agrpsx1[i,14]
		sx1->x1_def02  :=_agrpsx1[i,15]
		sx1->x1_cnt02  :=_agrpsx1[i,16]
		sx1->x1_var03  :=_agrpsx1[i,17]
		sx1->x1_def03  :=_agrpsx1[i,18]
		sx1->x1_cnt03  :=_agrpsx1[i,19]
		sx1->x1_var04  :=_agrpsx1[i,20]
		sx1->x1_def04  :=_agrpsx1[i,21]
		sx1->x1_cnt04  :=_agrpsx1[i,22]
		sx1->x1_var05  :=_agrpsx1[i,23]
		sx1->x1_def05  :=_agrpsx1[i,24]
		sx1->x1_cnt05  :=_agrpsx1[i,25]
		sx1->x1_f3     :=_agrpsx1[i,26]
		sx1->(msunlock())
	endif
next
return

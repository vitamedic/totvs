/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT206  ³Autor ³ Aline B. Pereira       ³Data ³ 22/07/04   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acompanhamento de Solicitacao de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


/*
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alteracoes³ 05/04/06 - (Alex) Omissao dos Pedidos nao Atendidos com    ³±±
±±³          ³            Residuos Eliminados.                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
Variaveis utilizadas para parametros
mv_par01 Da data
mv_par02 Ate a data
mv_par01 Do produto
mv_par02 Ate o produto
mv_par01 Do tipo
mv_par02 Ate o tipo
mv_par01 Do grupo
mv_par02 Ate a grupo
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT206()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="ACOMPANHAMENTO DE SOLICITACOES DE COMPRA"
cdesc1   :="Este programa ira emitir o acompanhamento de solicitacoes de compra"
cdesc2   :=""
cdesc3   :=""
cstring  :="SC1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT206"
wnrel    :="VIT206"+Alltrim(cusername)
aordem   :={"Alfabetica","Data Entrega"}
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT206"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.f.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)
nordem:=areturn[8]
if nlastkey==27
	set filter to
	return
endif

rptstatus({|| rptdetail()})
return

static function rptdetail()
_cfilsb1:=xfilial("SB1")
_cfilsa2:=xfilial("SA2")
_cfilsb2:=xfilial("SB2")
_cfilsc1:=xfilial("SC1")
_cfilsc7:=xfilial("SC7")
_cfilsd1:=xfilial("SD1")
sd1->(dbsetorder(5))
sa2->(dbsetorder(1))
sc7->(dbsetorder(4))
sb1->(dbsetorder(3))
sb2->(dbsetorder(1))
sc1->(dbsetorder(1))

processa({|| _querys()})
_mens := " Obs: "
if mv_par13==1
	_mens := " Somente solicitacoes sem pedido colocado"
endif
if mv_par14==1
	_mens += " e/ou solicitacoes com pendencia de entrega"
endif

cabec1:='Periodo: '+dtoc(mv_par09)+ " a "+ dtoc(mv_par10) + _mens
if mv_par15==1
	cabec2:="Codg.  Descrição Produto               UM Solic. Dt.Solic Dt.Neces  Dt.Ult.Mov    Qtde. Solic. Solicitante    Pedido  Dt.Ped. Dt.Entrega   Qtde.Pedido   Nota      Dt. Nota     Qtde.Nota  Fornecedor"
else
	cabec2:="Codg.  Descrição Produto               UM Solic. Dt.Solic Dt.Neces  Dt.Ult.Mov    Qtde. Solic. Solicitante    Pedido  Dt.Ped. Dt.Entrega   Qtde.Pedido   Nota      Dt. Nota     Qtde.Nota   Estoq.Atual"
endif
//Codg.  Descrição Produto                        UM Solic. Dt.Solic   Qtde. Solic. Solicitante          Pedido  Dt.Ped.    Qtde.Pedido Nota      Ser Dt. Nota      Qtde.Nota
//999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 999999 99/99/99 999.999.999,99 XXXXXXXXXXXXXXXXXXXX 999999 99/99/99 999.999.999,99 999999999 XXX 99/99/99 999.999.999,99


setprc(0,0)
_ntot := 0
_n1 := 0
_n2 := 0
_n3 :=0
_nest := 0
setregua(sc1->(lastrec()))
tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	incregua()
	
	if !empty(tmp1->pedido)
		sc7->(dbseek(_cfilsc7+tmp1->produto+tmp1->pedido+tmp1->itemped))
		_residuo:=sc7->c7_residuo
		
		set softseek on
		sd1->(dbseek(_cfilsd1+tmp1->produto+tmp1->localp))
		set softseek off
		_passou = .f.
		_pend =.f.
		_qtdenota:=0
		_nota:= space(06)
		_serie:=space(02)
		_qtdenota:=0
		_emissao:= ctod(space(08))
		
		while ! sd1->(eof()) .and. tmp1->produto==sd1->d1_cod
			if sd1->d1_pedido == tmp1->pedido .and. sd1->d1_itempc == tmp1->itemped
				_nota:= sd1->d1_doc
				_serie:=sd1->d1_serie
				_qtdenota+=sd1->d1_quant
				_emissao:= sd1->d1_emissao
				_pend =.t.
				
				if sc7->c7_quant <= _qtdenota
					_passou:=.t.
				endif
			endif
			sd1->(dbskip())
		end
		sb2->(dbseek(_cfilsb2+tmp1->produto+tmp1->localp))
		_nest := sb2->b2_qatu
		
		if mv_par13==1 .and. !empty(tmp1->pedido)
			tmp1->(dbskip())
			loop
		endif
		if mv_par14==1 .and. _passou
			tmp1->(dbskip())
			loop
		endif
		
		// reabilitado em 05/04/06 para omitir os pedidos não atendidos e com resíduos eliminados
		if !_passou .and. _residuo=='S'
			tmp1->(dbskip())
			loop
		endif
		
		//Codg.  Descrição Produto                        UM Solic. Dt.Solic Dt.Neces   Qtde. Solic. Solicitante          Pedido  Dt.Ped.    Qtde.Pedido Nota   Ser Dt. Nota      Qtde.Nota
		//999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 999999 99/99/99 99/99/99 999.999.999,99 XXXXXXXXXXXXXXXXXXXX 999999 99/99/99 999.999.999,99 999999 XXX 99/99/99 999.999.999,99
		if sc7->c7_datprf <> tmp1->datprf
			@ prow()+1,000 PSAY '*'+substr(tmp1->produto,1,6)
		else
			@ prow()+1,001 PSAY substr(tmp1->produto,1,6)
		endif
		@ prow(),008  PSAY substr(tmp1->descri,1,30)
		@ prow(),040  PSAY tmp1->um
		@ prow(),042  PSAY tmp1->num
		@ prow(),049  PSAY tmp1->emissao
		@ prow(),059  PSAY tmp1->datprf
		@ prow(),069  PSAY sb2->b2_usai
		@ prow(),080  PSAY tmp1->quant picture "@E 999,999,999.99"
		@ prow(),096  PSAY substr(tmp1->solicit,1,16)
		@ prow(),111  PSAY tmp1->pedido
		@ prow(),118  PSAY sc7->c7_emissao
		@ prow(),128  PSAY sc7->c7_datprf
		@ prow(),138  PSAY sc7->c7_quant picture "@E 999,999,999.99"
		_n1+= tmp1->quant
		_n2 += sc7->c7_quant
		
		// @ prow(),154   PSAY substr(sc7->c7_user,1,10)
		if _passou .or. _pend
			@ prow(),153   PSAY _nota
			//	@ prow(),159   PSAY _serie
			@ prow(),163   PSAY _emissao
			@ prow(),172   PSAY _qtdenota picture "@E 999,999,999.99"
			_n3 += _qtdenota
		endif
		if mv_par15==1
			sa2->(dbseek(_cfilsa2+sc7->c7_fornece+sc7->c7_loja))
			@ prow(),187 PSAY substr(sa2->a2_nome,1,30)
		else
			@ prow(),187   PSAY _nest picture "@E 999,999,999.99"
		endif
	else
		sb2->(dbseek(_cfilsb2+tmp1->produto+tmp1->localp))
		_nest := sb2->b2_qatu

		@ prow()+1,001 PSAY substr(tmp1->produto,1,6)
		@ prow(),008   PSAY substr(tmp1->descri,1,30)
		@ prow(),040   PSAY tmp1->um
		@ prow(),042   PSAY tmp1->num
		@ prow(),049   PSAY tmp1->emissao
		@ prow(),059   PSAY tmp1->datprf
		@ prow(),069   PSAY sb2->b2_usai
		@ prow(),080   PSAY tmp1->quant picture "@E 999,999,999.99"
		@ prow(),096   PSAY substr(tmp1->solicit,1,16)
		@ prow(),111   PSAY "pedido não colocado"
		@ prow(),187   PSAY _nest picture "@E 999,999,999.99"
		_n1+= tmp1->quant
	endif
	
	tmp1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end
@ prow()+1,001   PSAY "Total"
@ prow(),080   PSAY _n1 picture "@E 999,999,999.99"
@ prow(),138   PSAY _n2 picture "@E 999,999,999.99"
@ prow(),170   PSAY _n3 picture "@E 999,999,999.99"

tmp1->(dbclosearea())


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

static function _querys()
_cquery:=" SELECT"
_cquery+=" C1_PRODUTO PRODUTO,B1_DESC DESCRI,C1_EMISSAO EMISSAO,C1_NUM NUM,C1_DATPRF DATPRF,"
_cquery+=" C1_UM UM,C1_QUANT QUANT,C1_PEDIDO PEDIDO,C1_SOLICIT SOLICIT,C1_LOCAL LOCALP,C1_ITEMPED ITEMPED"
_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SC1")+" SC1"
_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_<>'*'"
_cquery+=" AND SC1.D_E_L_E_T_<>'*'"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND C1_FILIAL='"+_cfilsc1+"'"
_cquery+=" AND C1_PRODUTO=B1_COD"
_cquery+=" AND C1_NUM BETWEEN '"+mv_par16+"' AND '"+mv_par17+"'"
_cquery+=" AND C1_LOCAL  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND C1_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND C1_EMISSAO BETWEEN '"+dtos(mv_par09)+"' AND '"+dtos(mv_par10)+"'"
_cquery+=" AND C1_DATPRF BETWEEN '"+dtos(mv_par11)+"' AND '"+dtos(mv_par12)+"'"
if nordem==2 // FORNECEDOR
	_cquery+=" ORDER BY C1_DATPRF,B1_DESC"
else
	_cquery+=" ORDER BY B1_DESC,C1_LOCAL"
	
endif



_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","DATPRF","D")
tcsetfield("TMP1","QUANT"  ,"N",15,3)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto         ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto      ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo            ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo           ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo        ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Armazem            ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem      ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Da data solicit.   ?","mv_ch9","D",08,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate a data solic.  ?","mv_chA","D",08,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Da data de entrega ?","mv_chB","D",08,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Ate a data entrega ?","mv_chC","D",08,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"13","Somente Pend.Pedido?","mv_chD","N",08,0,0,"C",space(60),"mv_par13"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"14","Somente Pend.Notas ?","mv_chE","N",08,0,0,"C",space(60),"mv_par14"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"15","Imprime            ?","mv_chF","N",01,0,0,"C",space(60),"mv_par15"       ,"1-Fornecedor"   ,space(30),space(15),"2-Estoque Atual",space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"16","Da solicitacao     ?","mv_chG","C",06,0,0,"G",space(60),"mv_par16"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC1"})
aadd(_agrpsx1,{cperg,"17","Ate a solicitacao  ?","mv_chH","C",06,0,0,"G",space(60),"mv_par17"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SC1"})

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
Produto: xxxxxxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Data        Quantidade UM Ordem de producao Quantidade Seg. UM
99/99/99 999,999,999.999 xx    xxxxxxxxxxx    999,999,999.999 xx
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT159   ³ Autor ³ Gardenia              ³ Data ³ 05/11/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao Sintetica de Comissoes                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function VIT159()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="RELACAO SINTETICA DE COMISSÕES / VENDEDOR"
cdesc1   :="Este programa ira emitir a relacao sintetica de comissões por vendedor"
cdesc2   :=""
cdesc3   :=""
cstring  :="SE3"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT159"
wnrel    :="VIT159"+Alltrim(cusername)
aordem   :={"Nome Vendedor + Emissao","Codigo Vendedor + Emissao"}
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT159"
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

_cfilse3:=xfilial("SE3")
_cfilsa3:=xfilial("SA3")
sa3->(dbsetorder(1))
se3->(dbsetorder(2))


processa({|| _querys()})

cabec1:="Período: "+dtoc(mv_par01)+ " a " +dtoc(mv_par02)
//Codg.  vendedor                                   Valor Base Vl.comissão  Imp. Renda  Vl.liquido  Obs.
//999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  9999.999,99 9999.999,99 9999.999,99 9999.999,99  _________________________________
cabec2:="Codg.  vendedor                                   Valor Base Vl.comissão  Imp. Renda  Vl.liquido  Obs."



setprc(0,0)
_ntbase:=0
_ntcomis:=0
_ntliq:=0
_ntir:=0
tmp1->(dbgotop())
lcontinua := .t.
while ! tmp1->(eof()) .and.;
	lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_cvend:=tmp1->vend
	_cnome:=tmp1->nome
	_nbase:=0
	_ncomis:=0
	while ! tmp1->(eof()) .and.;
		tmp1->vend==_cvend .and.;
		lcontinua
		_nbase+=tmp1->base
		_ncomis+=tmp1->comis
		_ntbase+=tmp1->base
		_ntcomis+=tmp1->comis
		tmp1->(dbskip())
	end
	
	if prow()>53
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	@ prow()+5,00 PSAY _cvend
	@ prow(),07 PSAY _cnome
	@ prow(),49 PSAY _nbase picture "@E 9999,999.99"
	@ prow(),61 PSAY _ncomis picture "@E 9999,999.99"
	@ prow(),73 PSAY _ncomis*mv_par06/100 picture "@E 9999,999.99"
	@ prow(),85 PSAY _ncomis-(_ncomis*mv_par06/100) picture "@E 9999,999.99"
	@ prow(),98 PSAY "__________________________________"
	_ntliq+=_ncomis-(_ncomis*mv_par06/100)
	_ntir+=_ncomis*mv_par06/100
	
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end
if lcontinua
	if mv_par08 = 1
		@ prow()+5,000 PSAY "Totais"
		@ prow(),49 PSAY _ntbase picture "@E 9999,999.99"
		@ prow(),61 PSAY _ntcomis picture "@E 9999,999.99"
		@ prow(),73 PSAY _ntir picture "@E 9999,999.99"
		@ prow(),85 PSAY _ntliq picture "@E 9999,999.99"
	endif
endif

if prow()>0 .and.;
	lcontinua
	roda(cbcont,cbtxt)
endif

tmp1->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endIf

ms_flush()
return

static function _querys()
if mv_par07=1
	_cquery:=" SELECT"
	_cquery+=" E3_VEND VEND,A3_NOME NOME,E3_NUM NUM,E3_EMISSAO EMISSAO,E3_SERIE SERIE,E3_CODCLI CODCLI,"
	_cquery+=" E3_LOJA LOJA,E3_BASE BASE,E3_PORC PORC,E3_COMIS COMIS,E3_DATA DATA,E3_PREFIXO PREFIXO,E3_PARCELA PARCELA"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SA3")+" SA3,"
	_cquery+=  retsqlname("SE3")+" SE3"
	_cquery+=" WHERE"
	_cquery+="     SA3.D_E_L_E_T_<>'*'"
	_cquery+=" AND SE3.D_E_L_E_T_<>'*'"
	_cquery+=" AND A3_FILIAL='"+_cfilsa3+"'"
	_cquery+=" AND E3_FILIAL='"+_cfilse3+"'"
	_cquery+=" AND E3_VEND=A3_COD"
	_cquery+=" AND E3_EMISSAO  BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	_cquery+=" AND E3_VEND BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"

	if mv_par05==1
		_cquery+=" AND E3_DATA='"+space(08)+"'"
	elseif mv_par05==2
		_cquery+=" AND E3_DATA<>'"+space(08)+"'"
	endif

	if nordem==1 // NOME VENDEDOR + EMISSAO
		_cquery+=" ORDER BY A3_NOME,E3_EMISSAO"
	else // CODIGO VENDEDOR + EMISSAO
		_cquery+=" ORDER BY E3_VEND,E3_EMISSAO"
	endif	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP1"
	tcsetfield("TMP1","DATA","D")
	tcsetfield("TMP1","EMISSAO","D")
	tcsetfield("TMP1","BASE"  ,"N",15,2)
	tcsetfield("TMP1","COMIS","N",15,2)
else
	_aestrut:={}
	aadd(_aestrut,{"VEND"   ,"C",6,0})
	aadd(_aestrut,{"NOME"   ,"C",40,0})
	aadd(_aestrut,{"EMISSAO","D",8,0})
	aadd(_aestrut,{"NUM"    ,"C",6,0})
	aadd(_aestrut,{"SERIE"  ,"C",3,0})
	aadd(_aestrut,{"CODCLI" ,"C",6,0})
	aadd(_aestrut,{"BASE"   ,"N",15,2})
	aadd(_aestrut,{"DESC"   ,"N",12,2})
	aadd(_aestrut,{"PORC"   ,"N",12,2})
	aadd(_aestrut,{"COMIS"  ,"N",12,2})
	aadd(_aestrut,{"DATAT"   ,"D",8,0})
	aadd(_aestrut,{"PREFIXO","C",3,0})
	aadd(_aestrut,{"PARCELA","C",1,0})
	
	
	_carqtmp1:=criatrab(_aestrut,.t.)
	dbusearea(.t.,,_carqtmp1,"TMP1",.f.)
	_cindtmp11:=criatrab(,.f.)

	if nordem==1 // NOME VENDEDOR + EMISSAO
		_cchave   :="nome+emissao"
	else // CODIGO VENDEDOR + EMISSAO
		_cchave   :="vend+emissao"
	endif	
	
	tmp1->(indregua("TMP1",_cindtmp11,_cchave))
	
	tmp1->(dbclearind())
	tmp1->(dbsetindex(_cindtmp11))
	tmp1->(dbsetorder(1))
	
	se3->(dbseek(_cfilse3+mv_par03,.t.))
	while ! se3->(eof()) .and.;
		se3->e3_filial==_cfilse3 .and.;
		se3->e3_vend<=mv_par04
		if mv_par05==1 .and. se3->e3_data <>ctod(space(08))
			se3->(dbskip())
			loop
		elseif  mv_par05==2 .and. se3->e3_data ==ctod(space(08))
			se3->(dbskip())
			loop
		endif
		if se3->e3_emissao>=mv_par01 .and. se3->e3_emissao<=mv_par02
			sa3->(dbseek(_cfilsa3+se3->e3_vend))
			tmp1->(dbappend())
			tmp1->vend := se3->e3_vend
			tmp1->nome :=sa3->a3_nome
			tmp1->emissao :=se3->e3_emissao
			tmp1->num :=se3->e3_num
			tmp1->serie :=se3->e3_serie
			tmp1->codcli :=se3->e3_codcli
			tmp1->base :=se3->e3_base
			tmp1->porc :=se3->e3_porc
			tmp1->comis :=se3->e3_comis
			tmp1->datat :=se3->e3_data
			tmp1->prefixo :=se3->e3_prefixo
			tmp1->parcela :=se3->e3_parcela
		endif
		se3->(dbskip())
	end
endif
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do vendedor        ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"04","Ate o vendedor     ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA3"})
aadd(_agrpsx1,{cperg,"05","Considera quais    ?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,"Não Pagas"      ,space(30),space(15),"Pagas"          ,space(30),space(15),"Ambas"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Aliquota de IR     ?","mv_ch6","N",15,2,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Vitamedic          ?","mv_ch7","N",01,0,0,"C",space(60),"mv_par07"       ,"Sim"            ,space(30),space(15),"Não"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Totaliza           ?","mv_ch8","N",01,0,0,"C",space(60),"mv_par08"       ,"Sim"            ,space(30),space(15),"Não"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

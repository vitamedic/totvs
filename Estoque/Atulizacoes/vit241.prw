/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT241   ³ Autor ³ Heraildo C. Freitas   ³ Data ³ 02/09/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Liberacao de Solicitacoes ao Armazem                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit241()
_cperg:="PERGVIT241"
_pergsx1()
if pergunte(_cperg,.t.)
	
	_cfilctt:=xfilial("CTT")
	_cfilsb1:=xfilial("SB1")
	_cfilscp:=xfilial("SCP")
	_cfilsd3:=xfilial("SD3")
	_cfilszh:=xfilial("SZH")
	
	_aestrut:={}
	aadd(_aestrut,{"OK"     ,"C",04,0})
	aadd(_aestrut,{"NUMERO" ,"C",06,0})
	aadd(_aestrut,{"ITEM"   ,"C",02,0})
	aadd(_aestrut,{"PRODUTO","C",15,0})
	aadd(_aestrut,{"DESCPRO","C",40,0})
	aadd(_aestrut,{"QUANT"  ,"N",12,2})
	aadd(_aestrut,{"UM"     ,"C",02,0})
	aadd(_aestrut,{"EMISSAO","D",08,0})
	aadd(_aestrut,{"DATPRF" ,"D",08,0})
	aadd(_aestrut,{"OBS"    ,"C",30,0})
	aadd(_aestrut,{"SOLICIT","C",15,0})
	aadd(_aestrut,{"CC"     ,"C",09,0})
	aadd(_aestrut,{"DESCCC" ,"C",40,0})
	aadd(_aestrut,{"DATALIB","D",08,0})
	
	_carqtmp2:=criatrab(_aestrut,.t.)
	
	dbusearea(.t.,,_carqtmp2,"TMP2",.f.,.f.)
	
	_cindtmp2:=criatrab(,.f.)
	_cchave  :="SOLICIT+NUMERO+ITEM"
	tmp2->(indregua("TMP2",_cindtmp2,_cchave))
	
	processa({|| _geratmp()})
	
	ccadastro:="Liberação de solicitações ao armazém"
	
	arotina:={}
	aadd(arotina,{'Liberar marc.'  ,'U_VIT241A("M")',0,1})
	aadd(arotina,{'liberar Todas'  ,'U_VIT241A("T")',0,2})
	aadd(arotina,{'Estornar marc.' ,'U_VIT241B()',0,3})
	aadd(arotina,{'Histórico cons.','U_VIT241C()',0,4})
	
	_acampos1:={}
	aadd(_acampos1,{"OK"     ,," "})
	aadd(_acampos1,{"SOLICIT",,"Solicitante"})
	aadd(_acampos1,{"PRODUTO",,"Produto"})
	aadd(_acampos1,{"DESCPRO",,"Desc. Produto"})
	aadd(_acampos1,{"QUANT"  ,,"Quantidade","@E 999,999,999.99"})
	aadd(_acampos1,{"UM"     ,,"UM"})
	aadd(_acampos1,{"CC"     ,,"C.Custo"})
	aadd(_acampos1,{"DESCCC" ,,"Desc. C.Custo"})
	aadd(_acampos1,{"NUMERO" ,,"Número"})
	aadd(_acampos1,{"ITEM"   ,,"Item"})
	aadd(_acampos1,{"EMISSAO",,"Emissão"})
	aadd(_acampos1,{"DATPRF" ,,"Necessidade"})
	aadd(_acampos1,{"DATALIB",,"Data lib."})
	
	cmarca  :=getmark(,"TMP2","OK")
	lgrade  :=.f.
	linverte:=.f.
	
	tmp2->(dbgotop())
	markbrowse("TMP2","OK",,_acampos1,linverte,cmarca)
	
	tmp1->(dbclosearea())
	
	_cindtmp2+=tmp2->(ordbagext())
	tmp2->(dbclosearea())
	ferase(_carqtmp2+getdbextension())
	ferase(_cindtmp2)
endif
return

user function vit241a(_ctipo)
tmp2->(dbgotop())
while ! tmp2->(eof())
	if if(_ctipo=="T",.t.,tmp2->(marked("OK")) .and. empty(tmp2->datalib))
		
		scp->(dbsetorder(1))
		scp->(dbseek(_cfilscp+tmp2->numero+tmp2->item))
		scp->(reclock("SCP",.f.))
		scp->cp_datalib:=date()
		scp->cp_usrlib :=__cuserid
		scp->(msunlock())
		if mv_par03==1 // NÃO LIBERADAS
			tmp2->(dbdelete())
		end
	endif
	tmp2->(dbskip())
end
tmp2->(dbgotop())
sysrefresh()
return

user function vit241b()
tmp2->(dbgotop())
while ! tmp2->(eof())
	if tmp2->(marked("OK")) .and.;
		! empty(tmp2->datalib)
		
		scp->(dbsetorder(1))
		scp->(dbseek(_cfilscp+tmp2->numero+tmp2->item))
		scp->(reclock("SCP",.f.))
		scp->cp_datalib:=ctod("  /  /  ")
		scp->cp_usrlib :=space(6)
		scp->(msunlock())
		if mv_par03==2 // LIBERADAS
			tmp2->(dbdelete())
		end
	endif
	tmp2->(dbskip())
end
tmp2->(dbgotop())
sysrefresh()
return

user function vit241c()

processa({|| _gerahis()})

_carqtmp3:=criatrab(,.f.)

dbselectarea("TMP3")
copy to &_carqtmp3

tmp3->(dbclosearea())

dbusearea(.t.,,_carqtmp3,"TMP3",.f.,.f.)

_acampos2:={}
aadd(_acampos2,{"MES"     ,"Mês"        ,"@!"                     ,02,0})
aadd(_acampos2,{"ANO"     ,"Ano"    	 ,"@!"                     ,04,0})
aadd(_acampos2,{"QUANT"   ,"Quantidade" ,"@E 999,999,999.99"      ,12,2})
aadd(_acampos2,{"CUSTOMED","Custo Médio","@E 99,999,999.99999"    ,14,5})
aadd(_acampos2,{"CUSTOTOT","Custo Total","@E 99,999,999,999.99999",17,5})

_ntotquant:=0
_ntotcusto:=0
tmp3->(dbgotop())
while ! tmp3->(eof())
	_ntotquant+=tmp3->quant
	_ntotcusto+=tmp3->custotot
	tmp3->(dbskip())
end

tmp3->(dbgotop())

@ 000,000 to 250,600 dialog odlg1 title "Histórico de consumo nos últimos 6 meses"

@ 005,005 to 095,260 browse "TMP3" fields _acampos2

@ 005,265 bmpbutton type 1 action close(odlg1)

@ 100,010 say "Quantidade total: "+alltrim(transform(_ntotquant,"@E 999,999,999.99"))+"     Custo total: "+alltrim(transform(_ntotcusto,"@E 999,999,999.99999"))

tmp4->(dbgotop())
@ 110,010 say "ÚLTIMA REQUISIÇÃO - Data: "+dtoc(tmp4->emissao)+"     Quantidade: "+alltrim(transform(tmp4->quant,"@E 999,999,999.99"))+"     Custo médio: "+alltrim(transform(tmp4->customed,"@E 999,999,999.99999"))+"     Custo total: "+alltrim(transform(tmp4->custotot,"@E 999,999,999,999.99999"))

activate dialog odlg1 centered

tmp3->(dbclosearea())
ferase(_carqtmp3+getdbextension())

tmp4->(dbclosearea())

sysrefresh()
return

static function _gerahis()
procregua(2)

_ddataini:=firstday(ddatabase-180)

incproc("Selecionando registros...")
_cquery:=" SELECT"
_cquery+=" SUBSTR(D3_EMISSAO,5,2) MES,SUBSTR(D3_EMISSAO,1,4) ANO,SUM(D3_QUANT) QUANT,SUM(D3_CUSTO1)/SUM(D3_QUANT) CUSTOMED,"
//_cquery+=" D3_EMISSAO[5,6] MES,D3_EMISSAO[1,4] ANO,SUM(D3_QUANT) QUANT,SUM(D3_CUSTO1)/SUM(D3_QUANT) CUSTOMED,"
_cquery+=" SUM(D3_CUSTO1) CUSTOTOT"
_cquery+=" FROM "
_cquery+=  retsqlname("SD3")+" SD3"
_cquery+=" WHERE"
_cquery+="     SD3.D_E_L_E_T_<>'*'"
_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
_cquery+=" AND D3_CC='"+tmp2->cc+"'"
_cquery+=" AND D3_COD='"+tmp2->produto+"'"
_cquery+=" AND D3_EMISSAO BETWEEN '"+dtos(_ddataini)+"' AND '"+dtos(ddatabase)+"'"
_cquery+=" AND D3_ESTORNO<>'S'"
_cquery+=" GROUP BY"
_cquery+=" SUBSTR(D3_EMISSAO,5,2),SUBSTR(D3_EMISSAO,1,4)"
//_cquery+=" 1,2"
_cquery+=" ORDER BY"
_cquery+=" 2,1"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP3"
tcsetfield("TMP3","QUANT"   ,"N",12,2)
tcsetfield("TMP3","CUSTOMED","N",14,5)
tcsetfield("TMP3","CUSTOTOT","N",17,5)

incproc("Selecionando registros...")
_cquery:=" SELECT"
_cquery+=" D3_EMISSAO EMISSAO,D3_QUANT QUANT,D3_CUSTO1/D3_QUANT CUSTOMED,D3_CUSTO1 CUSTOTOT"
_cquery+=" FROM "
_cquery+=  retsqlname("SD3")+" SD3"
_cquery+=" WHERE"
_cquery+="     SD3.D_E_L_E_T_<>'*'"
_cquery+=" AND D3_FILIAL='"+_cfilsd3+"'"
_cquery+=" AND D3_CC='"+tmp2->cc+"'"
_cquery+=" AND D3_COD='"+tmp2->produto+"'"
_cquery+=" AND D3_ESTORNO<>'S'"
_cquery+=" ORDER BY"
_cquery+=" 1 DESC"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP4"
tcsetfield("TMP4","EMISSAO" ,"D")
tcsetfield("TMP4","QUANT"   ,"N",12,2)
tcsetfield("TMP4","CUSTOMED","N",14,5)
tcsetfield("TMP4","CUSTOTOT","N",17,5)
return

static function _geratmp()
procregua(2)

incproc("Selecionando registros...")
_cquery:=" SELECT"
_cquery+=" CP_NUM NUMERO,CP_ITEM ITEM,CP_PRODUTO PRODUTO,CP_QUANT QUANT,CP_UM UM,"
_cquery+=" CP_EMISSAO EMISSAO,CP_DATPRF DATPRF,CP_OBS OBS,CP_SOLICIT SOLICIT,CP_CC CC,CP_DATALIB DATALIB"
_cquery+=" FROM "
_cquery+=  retsqlname("SCP")+" SCP"
_cquery+=" WHERE"
_cquery+="     SCP.D_E_L_E_T_<>'*'"
_cquery+=" AND CP_FILIAL='"+_cfilscp+"'"
_cquery+=" AND CP_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND CP_QUJE=0"
if mv_par03==1 // NÃO LIBERADAS
	_cquery+=" AND CP_DATALIB='        '"
elseif mv_par03==2 // LIBERADAS
	_cquery+=" AND CP_DATALIB<>'        '"
endif
_cquery+=" ORDER BY"
_cquery+=" 1,2"

_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","QUANT"  ,"N",12,2)
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","DATPRF" ,"D")
tcsetfield("TMP1","DATALIB","D")

incproc("Selecionando registros...")

tmp1->(dbgotop())
while ! tmp1->(eof())
	
	sb1->(dbsetorder(1))
	sb1->(dbseek(_cfilsb1+tmp1->produto))
	
	_lok:=.f.
	szh->(dbsetorder(1))
	szh->(dbseek(_cfilszh+__cuserid))
	while ! szh->(eof()) .and.;
		szh->zh_filial==_cfilszh .and.;
		szh->zh_codusr==__cuserid
		
		_npos:=len(alltrim(szh->zh_cc))
		if szh->zh_grupo==sb1->b1_grupo .and.;
			alltrim(szh->zh_cc)==substr(tmp1->cc,1,_npos) .and.;
			szh->zh_tipo$"LA"
			
			_lok:=.t.
		endif
		szh->(dbskip())
	end
	if _lok
		ctt->(dbsetorder(1))
		ctt->(dbseek(_cfilctt+tmp1->cc))
		
		tmp2->(dbappend())
		tmp2->numero :=tmp1->numero
		tmp2->item   :=tmp1->item
		tmp2->produto:=tmp1->produto
		tmp2->descpro:=sb1->b1_desc
		tmp2->quant  :=tmp1->quant
		tmp2->um     :=tmp1->um
		tmp2->emissao:=tmp1->emissao
		tmp2->datprf :=tmp1->datprf
		tmp2->obs    :=tmp1->obs
		tmp2->solicit:=tmp1->solicit
		tmp2->cc     :=tmp1->cc
		tmp2->desccc :=ctt->ctt_desc01
		tmp2->datalib:=tmp1->datalib
	endif
	
	tmp1->(dbskip())
end
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Visualizar         ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03"       ,"Não liberadas"  ,space(30),space(15),"Liberadas"      ,space(30),space(15),"Todas"          ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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

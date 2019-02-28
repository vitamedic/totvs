/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT142   ³ Autor ³ Gardenia              ³ Data ³ 18/09/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Fretes/Transportadora e Periodo                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
Variaveis utilizadas para parametros
mv_par01 Da Fatura
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT142()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="FRETES/TRANSPORTADORA"
cdesc1   :="Este programa ira emitir o relação de fretes/transportadora"
cdesc2   :="  "
cdesc3   :=""
cstring  :="SF2"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT142"
wnrel    :="VIT142"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT142"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo:=if(areturn[4]==1,15,18)

if nlastkey==27
	set filter to
	return
endif

rptstatus({|| rptdetail()})
return

static function rptdetail()
_cfilsa1:=xfilial("SA1")
_cfilsf2:=xfilial("SF2")
_cfilsa4:=xfilial("SA4")
sa1->(dbsetorder(1))
sa4->(dbsetorder(1))
sf2->(dbsetorder(1))

processa({|| _querys()})

sa4->(dbseek(_cfilsa4+mv_par02))
cabec1:="Período: "+dtoc(mv_par03) + " a "+dtoc(mv_par04)
cabec2:="Conhec    Codg. Cliente                                      Emissao  No. NF    Ser       Peso Volume Valor Nota     Vl.Conhec.      Desconto     Perc.   Desc.Concedido."

//Conhec    Codg. Cliente                                      Emissao  No. NF    Ser       Peso Volume Valor Nota     Vl.Conhec.  Desconto      Perc.   Desc.Concedido.
//Conhec    Cliente                                            Emissao  No. NF    Ser       Peso Volume    Valor Nota    Vl.Conhec.   Perc.
//999999999 999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    99/99/99 999999999 999 999.999.99 999999 999.999,99  99.999.999,99  999.99


setprc(0,0)
_total:=0
_totfrete:=0
_totdescfr:=0
_tnota:=0
_tconhe:=0
_tdescfr:=0
_tpeso:=0
_tvolume:=0


tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	if prow()==0 .or. prow()>53
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	_transp:=tmp1->transp
	_passou :=.t.
	
	_1total:=0
	_1totfrete:=0
	_1totdescfr:=0
	_1tnota:=0
	_1tdescfr:=0
	_1tpeso:=0
	_1tvolume:=0
	
	_ftotal:=0
	_ftotfrete:=0
	_ftotdescfr:=0
	_ftnota:=0
	_ftdescfr:=0
	_ftpeso:=0
	_ftvolume:=0
	
	sa4->(dbseek(_cfilsa4+tmp1->transp))
	if mv_par05 == 2 .and. tmp1->descpg == "S"
		tmp1->(dbskip())
		loop
	endif
	if mv_par05 == 2 .and. empty(tmp1->descfr)
		tmp1->(dbskip())
		loop
	endif
	_passou :=.t.
	while ! tmp1->(eof()) .and. _transp == tmp1->transp .and.   lcontinua
		if mv_par05 == 2 .and. tmp1->descpg == "S"
			tmp1->(dbskip())
			loop
		endif
		if mv_par05 == 2 .and. empty(tmp1->descfr)
			tmp1->(dbskip())
			loop
		endif
		_tnota:=0
		_tconhe:=0
		_tdesconhe:=0
		_numfret:=tmp1->numfret
		_serfret:=tmp1->serfret
		_passou2 :=.t.
		_muf := ""
		
		while ! tmp1->(eof()) .and. _numfret == tmp1->numfret .and. _serfret == tmp1->serfret .and.;
			lcontinua .and.   _transp == tmp1->transp
			if mv_par05 == 2 .and. tmp1->descpg == "S"
				tmp1->(dbskip())
				loop
			endif
			if mv_par05 == 2 .and. empty(tmp1->descfr)
				tmp1->(dbskip())
				loop
			endif
			sa1->(dbseek(_cfilsa1+tmp1->cliente))
			if _passou
				@ prow()+2,000 PSAY tmp1->transp
				@ prow(),08 PSAY sa4->a4_nome
				@ prow()+1,00 PSAY " "
				_passou:=.f.
			endif
			if _muf <> tmp1->uf
				if !empty(_ftotal)
					
					@ prow()+1,000 PSAY "TOTAL ESTADO ==>"
					@ prow(),084 PSAY _ftpeso picture "@E 999,999.99"
					@ prow(),095 PSAY _ftvolume picture "@E 999999"
					@ prow(),102 PSAY _ftotal picture "@E 999,999.99"
					@ prow(),117 PSAY _ftotfrete picture "@E 999,999.99"
					@ prow(),131 PSAY _ftotdescfr picture "@E 999,999.99"
					@ prow(),145 PSAY ((_ftotfrete-_ftotdescfr)/_ftotal)*100 picture "@E 999.99"
					@ prow()+1,00 PSAY " "
					_ftotal:=0
					_ftotfrete:=0
					_ftotdescfr:=0
					_ftnota:=0
					_ftdescfr:=0
					_ftpeso:=0
					_ftvolume:=0
					
				endif
				@ prow()+1,000 PSAY tmp1->uf
				
				_muf :=tmp1->uf
			endif
			
			if _passou2
				@ prow()+1,000 PSAY tmp1->numfret
				_passou2 :=.f.
			else
				@ prow()+1,00 PSAY " "
			endif
			
			@ prow(),010 PSAY tmp1->cliente+"-"+tmp1->loja
			@ prow(),020 PSAY sa1->a1_nome
			@ prow(),061 PSAY tmp1->emissao
			@ prow(),070 PSAY tmp1->doc
			@ prow(),080 PSAY tmp1->serie
			@ prow(),084 PSAY tmp1->pbruto picture "@E 999,999.99"
			@ prow(),095 PSAY tmp1->volume1 picture "@E 999999"
			@ prow(),102 PSAY tmp1->valbrut picture "@E 999,999.99"
			_tconhe+=tmp1->vlfrete
			_tdesconhe+=tmp1->descfr
			
			_1total+=tmp1->valbrut
			_1totfrete+=tmp1->vlfrete
			_1totdescfr+=tmp1->descfr
			_1tnota+=tmp1->valbrut
			_1tdescfr+=tmp1->descfr
			_1tpeso+=tmp1->pbruto
			_1tvolume+=tmp1->volume1
			
			_ftotal+=tmp1->valbrut
			_ftotfrete+=tmp1->vlfrete
			_ftotdescfr+=tmp1->descfr
			_ftnota+=tmp1->valbrut
			_ftdescfr+=tmp1->descfr
			_ftpeso+=tmp1->pbruto
			_ftvolume+=tmp1->volume1
			
			
			_total+=tmp1->valbrut
			_totfrete+=tmp1->vlfrete
			_totdescfr+=tmp1->descfr
			_tnota+=tmp1->valbrut
			_tdescfr+=tmp1->descfr
			_tpeso+=tmp1->pbruto
			_tvolume+=tmp1->volume1
			
			tmp1->(dbskip())
			if prow()==0 .or. prow()>53
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
				@ prow()+1,00 psay ""
			endif
			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				lcontinua:=.f.
			endif
		end
		@ prow(),117 PSAY _tconhe picture "@E 999,999.99"
		@ prow(),131 PSAY _tdesconhe picture "@E 999,999.99"
		@ prow(),145 PSAY ((_tconhe-_tdesconhe)/_tnota)*100 picture "@E 999.99"
		if !empty(tmp1->descfr)
			if tmp1->descpg == "S"
				@ prow(),154 PSAY "Sim"
			else
				@ prow(),154 PSAY "Não"
			endif
		endif
	end
	
//Conhec    Codg.     Cliente                                  Emissao  No. NF    Ser       Peso Volume    Valor Nota    Vl.Conhec.  Desconto      Perc.   Desc.Concedido.
//Conhec    Cliente                                            Emissao  No. NF    Ser       Peso Volume    Valor Nota    Vl.Conhec.   Perc.
//999999999 999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 999999999 999 999.999.99 999999 99.999.999,99 99.999.999,99  999.99
	
	if !empty(_ftotal)
		@ prow()+1,000 PSAY "TOTAL ESTADO ==>"
		@ prow(),084 PSAY _ftpeso picture "@E 999,999.99"
		@ prow(),095 PSAY _ftvolume picture "@E 999999"
		@ prow(),102 PSAY _ftotal picture "@E 999,999.99"
		@ prow(),117 PSAY _ftotfrete picture "@E 999,999.99"
		@ prow(),131 PSAY _ftotdescfr picture "@E 999,999.99"
		@ prow(),145 PSAY ((_ftotfrete-_ftotdescfr)/_ftotal)*100 picture "@E 999.99"
		@ prow()+1,00 PSAY " "
		
	endif
	
	@ prow()+1,000 PSAY "TOTAL TRANSP ==>"
	@ prow(),084 PSAY _1tpeso picture "@E 999,999.99"
	@ prow(),095 PSAY _1tvolume picture "@E 999999"
	@ prow(),102 PSAY _1total picture "@E 999,999.99"
	@ prow(),117 PSAY _1totfrete picture "@E 999,999.99"
	@ prow(),131 PSAY _1totdescfr picture "@E 999,999.99"
	@ prow(),145 PSAY ((_1totfrete-_1totdescfr)/_1total)*100 picture "@E 999.99"
	
end
if lcontinua .and. !empty(_total)
	@ prow()+2,000 PSAY "TOTAL GERAL ===>"
	@ prow(),084 PSAY _tpeso picture "@E 999,999.99"
	@ prow(),095 PSAY _tvolume picture "@E 999999"
	@ prow(),102   PSAY _total picture "@E 999,999.99"
	@ prow(),117   PSAY _totfrete picture "@E 999,999.99"
	@ prow(),131 PSAY _totdescfr picture "@E 999,999.99"
	@ prow(),145   PSAY ((_totfrete-_totdescfr)/_total)*100 picture "@E 999.99"
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
_cquery:=" SELECT"
_cquery+=" F2_DOC DOC,F2_CLIENTE CLIENTE,F2_LOJA LOJA,F2_VALBRUT VALBRUT,F2_NUMFRET NUMFRET,F2_SERIE SERIE,"
_cquery+=" F2_SERFRET SERFRET,F2_EMISSAO EMISSAO,F2_VLFRETE VLFRETE,F2_VOLUME1 VOLUME1,F2_PBRUTO PBRUTO,"
_cquery+=" F2_DESCFR DESCFR,F2_DESCPG DESCPG,F2_TRANSP TRANSP,F2_EST UF"
_cquery+=" FROM "
_cquery+=  retsqlname("SF2")+" SF2"
_cquery+=" WHERE"
_cquery+="     SF2.D_E_L_E_T_<>'*'"
_cquery+=" AND F2_FILIAL='"+_cfilsf2+"'"
_cquery+=" AND F2_TRANSP BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'"
_cquery+=" AND F2_EST BETWEEN '"+mv_par06+"' AND '"+mv_par07+"'"
_cquery+=" ORDER BY F2_TRANSP,F2_EST,F2_NUMFRET,F2_SERFRET,F2_EMISSAO"



_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","VALBRUT"  ,"N",15,2)
tcsetfield("TMP1","VLFRETE"  ,"N",15,2)
tcsetfield("TMP1","VOLUME1"  ,"N",15,0)
tcsetfield("TMP1","PBRUTO"  ,"N",15,2)
tcsetfield("TMP1","DESCFR"  ,"N",15,2)
return

static function _pergsx1()
_agrpsx1:={}

aadd(_agrpsx1,{cperg,"01","Da Transportadora     ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
aadd(_agrpsx1,{cperg,"02","Ate a Transportadora  ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA4"})
aadd(_agrpsx1,{cperg,"03","Da Data               ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a Data            ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Só desc. não Pagos    ?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Do estado             ?","mv_ch6","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"12 "})
aadd(_agrpsx1,{cperg,"07","Ate o estado          ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"12 "})

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


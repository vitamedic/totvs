/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT278   ³ Autor ³Heraildo C. de Freitas ³ Data ³ 26/10/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rastreamento de lancamentos contabeis                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit278()
nordem  :=""
tamanho :="G"
limite  :=220
titulo  :="RASTREAMENTO DE LANCAMENTOS CONTABEIS"
cdesc1  :="Este programa ira emitir o rastreamento de lancamentos contabeis"
cdesc2  :=""
cdesc3  :=""
cstring :="CT2"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT278"
wnrel   :="VIT278"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
lcontinua:=.t.

cperg:="PERGVIT278"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.f.,tamanho,"",.f.)

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

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

titulo:="RASTREAMENTO DE LANCAMENTOS CONTABEIS"
cabec1:="  DATA     LOTE/SUB/DOC/LINHA DC CONTA DEBITO         CONTA CREDITO                     VALOR HISTORICO                      CC DEBITO CC CREDITO"
cabec2:=""

_cfilct2:=xfilial("CT2")
_cfilctk:=xfilial("CTK")

processa({|| _geratmp()})

setregua(1)

setprc(0,0)

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	
	if prow()==0 .or. prow()>56
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
	endif
	
	incregua()
	
	@ prow()+2,000 PSAY tmp1->ct2_data
	@ prow(),011   PSAY tmp1->ct2_lote+tmp1->ct2_sblote+tmp1->ct2_doc+tmp1->ct2_linha
	@ prow(),030   PSAY tmp1->ct2_dc
	@ prow(),033   PSAY tmp1->ct2_debito
	@ prow(),054   PSAY tmp1->ct2_credit
	@ prow(),075   PSAY tmp1->ct2_valor picture "@E 999,999,999,999.99"
	@ prow(),094   PSAY tmp1->ct2_hist
	@ prow(),125   PSAY tmp1->ct2_ccd
	@ prow(),135   PSAY tmp1->ct2_ccc
	
	_cquery:=" SELECT"
	_cquery+=" CTK_TABORI,"
	_cquery+=" CTK_RECORI"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("CTK")+" CTK"
	
	_cquery+=" WHERE"
	_cquery+="     CTK.D_E_L_E_T_=' '"
	_cquery+=" AND CTK_FILIAL='"+_cfilctk+"'"
	_cquery+=" AND CTK_SEQUEN='"+tmp1->ct2_sequen+"'"
	_cquery+=" AND CTK_RECDES='"+alltrim(str(tmp1->ct2recno,10))+"'"
	
	_cquery+=" ORDER BY"
	_cquery+=" 1,2"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP2"
	for _ni:=1 to tmp2->(fcount())
		_ccampo:=upper(alltrim(tmp2->(fieldname(_ni))))
		sx3->(dbsetorder(2))
		if sx3->(dbseek(_ccampo))
			tcsetfield("TMP2",_ccampo,sx3->x3_tipo,sx3->x3_tamanho,sx3->x3_decimal)
		endif
	next
	
	_lcab:=.t.
	
	tmp2->(dbgotop())
	while ! tmp2->(eof())
		
		if select(tmp2->ctk_tabori)==0
			chkfile(tmp2->ctk_tabori)
		endif
		
		if tmp2->ctk_tabori=="SD3"
			
			if prow()>56
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
				_lcab:=.t.
			endif
			
			if _lcab
				@ prow()+2,000 PSAY "TM  CF        OP      PRODUTO         TIPO GRUPO UM    QUANTIDADE LOCAL DOCUMENTO EMISSAO             CUSTO USUARIO"
				_lcab:=.f.
			endif
			
			sd3->(dbgoto(val(tmp2->ctk_recori)))
			@ prow()+1,000 PSAY sd3->d3_tm
			@ prow(),004   PSAY sd3->d3_cf
			@ prow(),008   PSAY sd3->d3_op
			@ prow(),022   PSAY sd3->d3_cod
			@ prow(),039   PSAY sd3->d3_tipo
			@ prow(),043   PSAY sd3->d3_grupo
			@ prow(),049   PSAY sd3->d3_um
			@ prow(),052   PSAY sd3->d3_quant picture "@E 99,999,999.99"
			@ prow(),067   PSAY sd3->d3_local
			@ prow(),073   PSAY sd3->d3_doc
			@ prow(),082   PSAY sd3->d3_emissao
			@ prow(),093   PSAY sd3->d3_custo1 picture "@E 999,999,999.99"
			@ prow(),108   PSAY sd3->d3_usuario
		endif
		
		tmp2->(dbskip())
	end
	tmp2->(dbclosearea())
	
	@ prow()+1,000 PSAY replicate("-",limite)
	
	tmp1->(dbskip())
	
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if prow()>0
	roda(cbcont,cbtxt)
endif

tmp1->(dbclosearea())

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return()

static function _geratmp()
procregua(1)

incproc("Selecionando lancamentos...")

_cquery:=" SELECT"
_cquery+=" CT2_DATA,"
_cquery+=" CT2_LOTE,"
_cquery+=" CT2_SBLOTE,"
_cquery+=" CT2_DOC,"
_cquery+=" CT2_LINHA,"
_cquery+=" CT2_DC,"
_cquery+=" CT2_DEBITO,"
_cquery+=" CT2_CREDIT,"
_cquery+=" CT2_VALOR,"
_cquery+=" CT2_HIST,"
_cquery+=" CT2_CCD,"
_cquery+=" CT2_CCC,"
_cquery+=" CT2_SEQUEN,"
_cquery+=" CT2.R_E_C_N_O_ CT2RECNO"

_cquery+=" FROM "
_cquery+=  retsqlname("CT2")+" CT2"

_cquery+=" WHERE"
_cquery+="     CT2.D_E_L_E_T_=' '"
_cquery+=" AND CT2_FILIAL='"+_cfilct2+"'"
_cquery+=" AND CT2_DATA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND CT2_LOTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND CT2_SBLOTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND CT2_DOC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND CT2_LINHA BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
_cquery+=" AND CT2_SEQUEN<>'          '"

_cquery+=" ORDER BY"
_cquery+=" 1,2,3,4,5"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
for _ni:=1 to tmp1->(fcount())
	_ccampo:=upper(alltrim(tmp1->(fieldname(_ni))))
	sx3->(dbsetorder(2))
	if sx3->(dbseek(_ccampo))
		tcsetfield("TMP1",_ccampo,sx3->x3_tipo,sx3->x3_tamanho,sx3->x3_decimal)
	endif
next
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data                      ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data                   ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do lote                      ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate o lote                   ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do sub lote                  ?","mv_ch5","C",03,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate o sub lote               ?","mv_ch6","C",03,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do documento                 ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o documento              ?","mv_ch8","C",06,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Da linha                     ?","mv_ch9","C",03,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate a linha                  ?","mv_cha","C",03,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

/*
  DATA     LOTE/SUB/DOC/LINHA DC CONTA DEBITO         CONTA CREDITO                     VALOR HISTORICO                      CC DEBITO CC CREDITO
99/99/9999 999999999999999999 X  XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX 999.999.999.999,99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXX XXXXXXXXX

TM  CF        OP      PRODUTO         TIPO GRUPO UM    QUANTIDADE LOCAL DOCUMENTO EMISSAO             CUSTO USUARIO
XXX XXX XXXXXXXXXXXXX XXXXXXXXXXXXXXX  XX  XXXX  XX 99.999.999,99  99    999999   99/99/9999 999.999.999,99 XXXXXXXXXXXXXXX
*/

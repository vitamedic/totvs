/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITQ012    ³Autor ³ Gardenia              ³Data ³ 17/12/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Documentos / Pasta                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
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

user function VITQ012()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="RELACAO DE DOCUMENTOS  /PASTA"
cdesc1   :="Este programa ira emitir a relacao de documentos  /pasta"
cdesc2   :=""
cdesc3   :=""
cstring  :="QDG"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VITQ012"
wnrel    :="VITQ012"
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVITQ12"
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
_cfilqdg:=xfilial("QDG")
_cfilqdh:=xfilial("QDH")
_cfilqdc:=xfilial("QDC")
qdg->(dbsetorder(5))
qdh->(dbsetorder(1))
qdc->(dbsetorder(1))

processa({|| _querys()})

cabec1:="CODIGO            REV DOCUMENTO"
//"CODIGO           REV DOCUMENTO"
//XXXXXXXXXXXXXXXX XXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 
cabec2:=' '

setprc(0,0)

setregua(qdg->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	qdc->(dbseek(_cfilqdc+tmp1->codman))
   @ prow()+2,000 PSAY tmp1->codman+" " + qdc->qdc_desc	 
	_codman  :=tmp1->codman
	while ! tmp1->(eof()) .and.;
		tmp1->codman==_codman .and.;
		lcontinua
		incregua()
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
//XXXXXXXXXXXXXXXX XXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 
		qdh->(dbseek(_cfilqdh+tmp1->docto+tmp1->rv))
		if qdh->qdh_obsol == "S" .or. qdh->qdh_cancel =="S"   .or. qdh->qdh_status <> "L" // .or. qdh->qdh_dtlim < ddatabase
			tmp1->(dbskip())                                                                                  
			
         loop
      endif   
		@ prow()+1,000 PSAY tmp1->docto
		@ prow(),018   PSAY tmp1->rv
		@ prow(),022   PSAY qdh->qdh_titulo
		tmp1->(dbskip())
	end
//	if lcontinua
//		@ prow()+1,000 PSAY "TOTAIS"
//		@ prow(),027   PSAY _tvalor picture "@E 999,999,999.99"
//		@ prow(),042   PSAY _tsaldo picture "@E 999,999,999.99"
//		@ prow()+1,000 PSAY replicate("-",limite)
//	endif
end

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
_cquery+=" QDG_DOCTO DOCTO,QDG_RV RV,QDG_DEPTO DEPTO,QDG_CODMAN CODMAN,QDG_RECEB RECEB"
_cquery+=" FROM "
_cquery+=  retsqlname("QDG")+" QDG"
_cquery+=" WHERE"
_cquery+="     QDG.D_E_L_E_T_<>'*'"
_cquery+=" AND QDG_FILIAL='"+_cfilqdg+"'"
_cquery+=" AND QDG_RECEB='S'"
_cquery+=" AND QDG_DOCTO  BETWEEN '"+mv_par01+"' AND '"+mv_par03+"'"
_cquery+=" AND QDG_RV  BETWEEN '"+mv_par02+"' AND '"+mv_par04+"'"
_cquery+=" AND QDG_CODMAN BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" ORDER BY QDG_CODMAN,QDG_DOCTO,QDG_RV"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
//tcsetfield("TMP1","EMISSAO","D")
//tcsetfield("TMP1","BAIXA","D")
//tcsetfield("TMP1","SALDO"  ,"N",15,2)
//tcsetfield("TMP1","VALOR","N",15,2)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Docto           ?","mv_ch1","C",16,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QDH"})
aadd(_agrpsx1,{cperg,"02","Da revisão         ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Ate o docto        ?","mv_ch3","C",16,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QDH"})
aadd(_agrpsx1,{cperg,"04","Ate a revisao      ?","mv_ch4","C",03,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da pasta           ?","mv_ch5","C",15,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QDC"})
aadd(_agrpsx1,{cperg,"06","Ate a pasta        ?","mv_ch6","C",15,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QDC"})
	
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
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT232   ³Autor ³ Gardenia              ³Data ³ 22/04/05   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Lista de Treinamentos por Treinando                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT232()
nordem   :=""
tamanho  :="G"
limite   :=200
titulo   :="LISTA DE TREINAMENTOS POR TREINANDO"
cdesc1   :="Este programa ira emitir a relação de treinamentos por treinado"
cdesc2   :=""
cdesc3   :=""
cstring  :="QD8"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT232"
wnrel    :="VIT232"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT232"
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
_cfilqda:=xfilial("QDA")
_cfilqdh:=xfilial("QDH")
_cfilqaa:=xfilial("QAA")
_cfilqad:=xfilial("QAD")
_cfilqd8:=xfilial("QD8")
qda->(dbsetorder(1))
qdh->(dbsetorder(1))
qaa->(dbsetorder(1))
qad->(dbsetorder(1))
qd8->(dbsetorder(1))

processa({|| _querys()})

cabec1:="NUMERO/ANO DOCUMENTO/REVISAO    TITULO                                                       OBSERVACAO                                                                     PART. DT.INCIO   DT.FIM "                     
//"NUMERO/ANO DOCUMENTO/REVISAO    TITULO                                                       OBSERVACAO                                                                     PART. DT.INCIO DT.FIM "                     
//9999/9999  9999999999999999/999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX 99/99/99 99/99/99
cabec2:=" "



setprc(0,0)

setregua(sra->(lastrec()))

tmp1->(dbgotop())

_totfunc:=0


while ! tmp1->(eof()) .and.;
      lcontinua
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	incregua()
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
	_mat:= tmp1->mat
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif                                                           
	qaa->(dbseek(_cfilqaa+tmp1->mat))
//	qad->(dbseek(_cfilqad+tmp1->depto))
	qad->(dbseek("01"+tmp1->depto))
   @ prow()+1,00 PSAY "USUÁRIO.....: "+ qaa->qaa_nome
   @ prow()+1,00 PSAY "DEPARTAMENTO: "+ qad->qad_desc
   @ prow()+1,00 PSAY "  " 
  	while ! tmp1->(eof()) .and.;
      lcontinua .and. tmp1->mat == _mat 
		if prow()==0 .or. prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif     
//9999/9999  9999999999999999/999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX 99/99/99 99/99/99
		qdh->(dbseek(_cfilqdh+tmp1->docto+tmp1->rv))
		@ prow()+1,000 PSAY tmp1->numero+"/"+tmp1->ano
		@ prow(),011 PSAY  tmp1->docto+"/"+tmp1->rv
		@ prow(),032 PSAY substr(qdh->qdh_titulo,1,60)
		@ prow(),093 PSAY substr(tmp1->obs,1,60)
		if tmp1->seleca = "S"
			@ prow(),174  PSAY "Sim"
		elseif tmp1->seleca = "N"	 
			@ prow(),174  PSAY "Não"
		endif	
		@ prow(),178  PSAY tmp1->dtinic
		@ prow(),188  PSAY tmp1->dtfim
		if substr(qdh->qdh_titulo,61,100) <> "  "
			@ prow()+1,032 PSAY substr(qdh->qdh_titulo,61,100)
		endif	
			 
	  	tmp1->(dbskip())
	end
   @ prow()+1,00 PSAY replicate("_",200)
   @ prow()+1,00 PSAY "  " 

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
_cquery+=" QDA_ANO ANO,QDA_NUMERO NUMERO,QDA_DOCTO DOCTO,QDA_RV RV,QDA_BAIXA BAIXA,"
_cquery+=" QDA_DTINIC DTINIC, QDA_DTFIM DTFIM,QDA_OBS OBS,QD8_DEPTO DEPTO,QD8_SELECA SELECA,QD8_MAT MAT,"
_cquery+=" QDA_OBS OBS"
_cquery+=" FROM "
_cquery+=  retsqlname("QDA")+" QDA,"
_cquery+=  retsqlname("QD8")+" QD8"
_cquery+=" WHERE"
_cquery+="     QDA.D_E_L_E_T_<>'*'"
_cquery+=" AND QD8.D_E_L_E_T_<>'*'"
_cquery+=" AND QDA_ANO=QD8_ANO"
_cquery+=" AND QDA_NUMERO=QD8_NUMERO"
_cquery+=" AND QDA_FILIAL='"+_cfilqda+"'"
_cquery+=" AND QD8_FILIAL='"+_cfilqd8+"'"
_cquery+=" AND QD8_MAT  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
if mv_par03 = 2
	_cquery+=" AND QD8_BAIXA=  'S'"
elseif mv_par03 = 3	
	_cquery+=" AND QD8_BAIXA<>  'S'"
endif
if mv_par04 = 2
	_cquery+=" AND QD8_SELECA=  'S'"
elseif mv_par04 = 3	
	_cquery+=" AND QD8_SELECA=  'N'"
endif	
_cquery+=" ORDER BY QD8_MAT,QD8_ANO,QD8_NUMERO"
_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","DTINIC"  ,"D",8,0)
tcsetfield("TMP1","DTFIM"  ,"D",8,0)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do treinando       ?","mv_ch1","C",10,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QAA"})
aadd(_agrpsx1,{cperg,"02","Ate o treinando    ?","mv_ch2","C",10,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"QAA"})
aadd(_agrpsx1,{cperg,"03","Treinamentos       ?","mv_ch3","N",01,0,0,"C",space(60),"mv_par03"       ,"Todos"          ,space(30),space(15),"Realizados"     ,space(30),space(15),"Pendentes"      ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Treinandos         ?","mv_ch4","N",01,0,0,"C",space(60),"mv_par04"       ,"Todos"          ,space(30),space(15),"Participantes"  ,space(30),space(15),"Nao Participant",space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
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
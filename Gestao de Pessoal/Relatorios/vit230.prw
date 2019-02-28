/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT230   ³ Autor ³ Gardenia              ³ Data ³ 22/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcionarios / CC                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
Variaveis utilizadas para parametros
mv_par01 Da Matricula 
mv_par02 Ate a Matricula
mv_par03 Do Centro de Custo 
mv_par04 Ate o Centro de custo
*/

#include "rwmake.ch"
#include "topconn.ch"

user function VIT230()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="FUNCIONARIOS /CC "
cdesc1   :="Este programa ira emitir a relação de funcionarios /cc"
cdesc2   :=""
cdesc3   :=""
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT230"
wnrel    :="VIT230"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=80
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT230"
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
_cfilsra:=xfilial("SRA")
_cfilsrj:=xfilial("SRJ")
_cfilsi3:=xfilial("SI3")
si3->(dbsetorder(1))
sra->(dbsetorder(1))
srj->(dbsetorder(1))

processa({|| _querys()})

cabec1:="Matric. Nome                                      Função                             Admissão    Salário"
//Matric. Nome                                     CTPS        Função                         Admissão   
//999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999-99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99
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
	_cc:=tmp1->cc
	_desccc:=tmp1->desccc
	_tccfun:=0
	_passou :=.t.
  	while ! tmp1->(eof()) .and.;
      lcontinua .and. tmp1->cc == _cc 
		if prow()==0 .or. prow()>54
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif     
//999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999.999  999,999.99    999,999.99   999,999.99 999,999.99 
		if _passou 
		   @ prow()+1,00 PSAY _cc + "   " + _desccc
		   _passou :=.f.
		endif   
		@ prow()+1,000 PSAY tmp1->mat
		@ prow(),008 PSAY tmp1->nome
//		@ prow(),50 PSAY alltrim(tmp1->numcp)+"-"+tmp1->sercp
	   srj->(dbseek(_cfilsrj+tmp1->codfunc))
 	   @ prow(),50 PSAY substr(srj->rj_desc,1,30)
      @ prow(),85 PSAY tmp1->admissa
		@ prow(),95 PSAY tmp1->SAL picture "@E 999,999.99"
		_tccfun+=1
		_totfunc+=1
		tmp1->(dbskip())
	end
	if _tccfun >0 
//		@ prow()+1,004 PSAY   "TOTAL CC ==>" 
//		@ prow(),020 PSAY _tccfun picture "@E 999,999" 
		@ prow()+1,004 PSAY   " " 
	endif	
end	
@ prow()+1,004 PSAY "TOTAL GERAL===>"
@ prow(),020 PSAY _totfunc picture "@E 999,999" 


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
_cquery+=" RA_MAT MAT,RA_NOME NOME,RA_CC CC,I3_DESC DESCCC,RA_NUMCP NUMCP,RA_SERCP SERCP,"
_cquery+=" RA_DPASSME DPASSME, RA_ASMEDIC ASMEDIC,RA_COMIS COMIS,RA_CODFUNC CODFUNC,RA_ADMISSA ADMISSA,RA_SALARIO SAL"
_cquery+=" FROM "
_cquery+=  retsqlname("SRA")+" SRA,"
_cquery+=  retsqlname("SI3")+" SI3"
_cquery+=" WHERE"
_cquery+="     SRA.D_E_L_E_T_<>'*'"
_cquery+=" AND SI3.D_E_L_E_T_<>'*'"
_cquery+=" AND RA_CC=I3_CUSTO"
_cquery+=" AND RA_FILIAL='"+_cfilsra+"'"
_cquery+=" AND I3_FILIAL='"+_cfilsi3+"'"
_cquery+=" AND RA_MAT  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND RA_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
//_cquery+=" AND RA_ADMISSA < '"+dtos(mv_par08)+"'"
_cquery+=" AND RA_SITFOLH <> 'D'"
_cquery+=" ORDER BY RA_CC,RA_NOME"


_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","SALARIO"  ,"N",15,3)
tcsetfield("TMP1","EXTRA"  ,"N",15,3)
tcsetfield("TMP1","COMIS"  ,"N",15,3)
tcsetfield("TMP1","ADMISSA"  ,"D",8,0)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da Matricula       ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"02","Ate a matricula    ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"03","Do Centro de Custo ?","mv_ch3","C",09,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
aadd(_agrpsx1,{cperg,"04","Ate Centro de Custo?","mv_ch4","C",09,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
	
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
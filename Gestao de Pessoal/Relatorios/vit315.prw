/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT315   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 12/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Lista de Aniversariantes por Período                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function vit315()
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="LISTA DE ANIVERSARIANTES POR PERIODO"
cdesc1  :="Este programa ira emitir uma lista com os aniversariantes por periodo"
cdesc2  :="de acordo com o Cadastro de Funcionarios - SRA"
cdesc3  :=""
cstring :="SRA"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT315"
wnrel   :="VIT315"+Alltrim(cusername)
alinha  :={}
aordem  :={"Matricula","Centro de Custos","Nome","Dt. Nascimento"}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)

cperg:="PERGVIT315"
_pergsx1()
pergunte(cperg,.f.)


wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,aordem,.t.,tamanho,"",.f.)

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
_cfilsra:=xfilial("SRA")
sra->(dbsetorder(1))

processa({|| _querys()})

cabec1:="DO MES "+mv_par09+" AO "+mv_par10
if mv_par15==1 // Imprime Estado Civil
	if mv_par13==1 // Imprime Salario
		cabec2:="CC         MAT      NOME                                      DT.NASC.    EST.CIVIL          SALARIO"
	else
		cabec2:="CC         MAT      NOME                                      DT.NASC.    EST.CIVIL"
	endif
else
	if mv_par13==1 // Imprime Salario
		cabec2:="CC         MAT      NOME                                      DT.NASC.                       SALARIO"
	else
		cabec2:="CC         MAT      NOME                                      DT.NASC."
	endif
endif
//CC         MAT      NOME                                      DT.NASC.    EST.CIVIL          SALARIO
//99999999   999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/9999  XXXXXXXXXX    9.999.999,99
//0          11       20                                        61          73            87

setprc(0,0)
@ 000,000 PSAY avalimp(132)

setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif
	
	@ prow()+1,000 PSAY substr(tmp1->cc,1,8)
	@ prow(),011   PSAY tmp1->mat
	@ prow(),020   PSAY tmp1->nome
	@ prow(),061   PSAY tmp1->aniversario

	if mv_par15==1
		@ prow(),073   PSAY tmp1->estcivil
	endif

	if mv_par13==1
		@ prow(),087   PSAY tmp1->salario picture "@E 9,999,999.99"
	endif
	tmp1->(dbskip())

	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

if prow()>0 .and. lcontinua
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
return

static function _querys()

_cquery:=" SELECT"
_cquery+="   RA_MAT MAT,"
_cquery+="   RA_NOME NOME,"
_cquery+="   RA_CC CC,"

if mv_par14==1 // Imprime Ano do Nascimento
	_cquery+="   SubStr(RA_NASC,7,2)||'/'||SubStr(RA_NASC,5,2)||'/'||SubStr(RA_NASC,1,4) ANIVERSARIO"
else
	_cquery+="   SubStr(RA_NASC,7,2)||'/'||SubStr(RA_NASC,5,2) ANIVERSARIO"
endif

if mv_par15==1 // Imprime Estado Civil
	_cquery+=",   CASE"
	_cquery+="     WHEN RA_ESTCIVI='S'"
	_cquery+="       THEN 'Solteiro'"
	_cquery+="     WHEN RA_ESTCIVI='C'"
	_cquery+="       THEN 'Casado'"
	_cquery+="     WHEN RA_ESTCIVI='V'"
	_cquery+="       THEN 'Viuvo'"
	_cquery+="     WHEN RA_ESTCIVI='D'"
	_cquery+="       THEN 'Divorciado'"
	_cquery+="     WHEN RA_ESTCIVI='Q'"
	_cquery+="       THEN 'Desquitado'"
	_cquery+="     ELSE 'Marital'"
	_cquery+="   END ESTCIVIL"
endif

if mv_par13==1 // Imprime Salário
	_cquery+=",   RA_SALARIO SALARIO"
endif           

_cquery+=" FROM "
_cquery+=  retsqlname("SRA")+" SRA,"
_cquery+=" WHERE SRA.D_E_L_E_T_<>'*'"
_cquery+=" AND RA_FILIAL = '"+_cfilsra+"'"
_cquery+=" AND RA_CC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND RA_MAT BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND RA_NOME BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND RA_NASC BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"'"

_sitfolh:=""
if len(mv_par11)>0
	_sitfolh:="("
endif

for _i:=1 to len(mv_par11)
	if substr(mv_par11,_i,1)<>""
		if substr(mv_par11,_i+1,1)<>""
			_sitfolh+="'"+substr(mv_par11,_i,1)+"',"
		else 
			_sitfolh+="'"+substr(mv_par11,_i,1)+"'"		
		endif
	endif
next        

if len(mv_par11)>0
	_sitfolh+=")"
endif

_cquery+=" AND RA_SITFOLH IN "+ _sitfolh


_catfunc:=""
if len(mv_par12)>0
	_catfunc:="("
endif

for _i:=1 to len(mv_par12)
	if substr(mv_par12,_i,1)<>""
		if substr(mv_par12,_i+1,1)<>""
			_catfunc+="'"+substr(mv_par12,_i,1)+"',"
		else 
			_catfunc+="'"+substr(mv_par12,_i,1)+"'"		
		endif
	endif
next        

if len(mv_par12)>0
	_catfunc+=")"
endif


_cquery+=" AND RA_CATFUNC IN "+ _catfunc
_cquery+=" AND SubStr(RA_NASC,5,2) BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"

if nordem==1
	_cquery+=" ORDER BY RA_MAT"
elseif nordem==2
	_cquery+=" ORDER BY RA_CC, RA_NOME"
elseif nordem==3
	_cquery+=" ORDER BY RA_NOME"
else
	_cquery+=" ORDER BY SubStr(RA_NASC,5,2), SubStr(RA_NASC,7,2),RA_NOME"
endif


_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","SALARIO","N",15,2)

return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do centro de custo     ?","mv_ch1","C",08,0,0,"G",space(60)   ,"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{cperg,"02","Ate o centro de custo  ?","mv_ch2","C",08,0,0,"G",space(60)   ,"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{cperg,"03","Da matricula           ?","mv_ch3","C",06,0,0,"G",space(60)   ,"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"04","Ate a matricula        ?","mv_ch4","C",06,0,0,"G",space(60)   ,"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"05","Do nome                ?","mv_ch5","C",30,0,0,"G",space(60)   ,"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate o nome             ?","mv_ch6","C",30,0,0,"G",space(60)   ,"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Da data de nascimento  ?","mv_ch7","D",08,0,0,"G",space(60)   ,"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate a dt.de nascimento ?","mv_ch8","D",08,0,0,"G",space(60)   ,"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do mes                 ?","mv_ch9","C",02,0,0,"G",space(60)   ,"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate o mes              ?","mv_cha","C",02,0,0,"G",space(60)   ,"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Situacoes              ?","mv_chb","C",05,0,0,"G","fSituacao" ,"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Categorias             ?","mv_chc","C",15,0,0,"G","fCategoria","mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"13","Imprime salario        ?","mv_chd","C",01,0,2,"C",space(60)   ,"mv_par13"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"14","Imprime ano nascimento ?","mv_che","C",01,0,1,"C",space(60)   ,"mv_par14"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"15","Imprime estado civil   ?","mv_chf","C",01,0,2,"C",space(60)   ,"mv_par15"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
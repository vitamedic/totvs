/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT253   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 14/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Últimas Férias Gozadas por Funcionário                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit253()
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="ULTIMAS FERIAS GOZADAS"
cdesc1  :="Este programa ira emitir a data das ultimas ferias do(s) funcionario(s)"
cdesc2  :=""
cdesc3  :=""
cstring :="SRA"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT253"
wnrel   :="VIT253"+Alltrim(cusername)
alinha  :={}
aordem  :={}
nlastkey:=0
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)

cperg:="PERGVIT253"
_pergsx1()
pergunte(cperg,.f.)


wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)

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
_cfilsrf:=xfilial("SRF")
_cfilsrh:=xfilial("SRH")
_cfilsrj:=xfilial("SRJ")
sra->(dbsetorder(1))
srf->(dbsetorder(1))
srh->(dbsetorder(1))
srj->(dbsetorder(1))


processa({|| _querys()})
cabec1:="                                                                                                 ULTIMAS FERIAS     VENCIMENTO"
if mv_par08==1
	cabec2:="MAT    FUNCIONARIO                              FUNCAO                SITUACAO  SALARIO  ADMISSAO  INICIO    FIM       FERIAS    AVOS"
else
	cabec2:="MAT    FUNCIONARIO                              FUNCAO                SITUACAO           ADMISSAO  INICIO    FIM       FERIAS    AVOS"
endif

setprc(0,0)
@ 000,000 PSAY avalimp(133)


setregua(tmp1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
	incregua()
	if prow()==0 .or. prow()>60
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
	endif
	
	srh->(dbseek(_cfilsrh+tmp1->mat)) //+dtos(tmp1->admissao)
	_dtini:= ctod(space(08))
	_dtfim:= ctod(space(08))
	_dtvencfer:= tmp1->databas+364 //Vencimento das férias calculado com base no vencimento (365 dias) do período 
											 //de provisão (databas=início do período)

	_avos:=round((dDataBase-tmp1->databas)/30,1)
	
	while (srh->rh_filial==_cfilsrh) .and.;
			(srh->rh_mat==tmp1->mat) .and.;
			lcontinua .and. !eof()
		
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			eject
			lcontinua:=.f.
		endif

		_dtini:= srh->rh_dataini
		_dtfim:= srh->rh_datafim
		srh->(dbskip())
	end

	if (mv_par09==1) .or.;								// Mostra todos os avos
		(mv_par09==2 .and. _avos==mv_par10) .or.; //Filtra avos somente igual ao mv_par11
		(mv_par09==3 .and. _avos>mv_par10) .or.; 	//Filtra avos somente maiores que mv_par11
		(mv_par09==4 .and. _avos<mv_par10)		 	//Filtra avos somente menores que mv_par11
		
		@ prow()+1,000 PSAY tmp1->mat
		@ prow(),007   PSAY tmp1->nome
		@ prow(),048   PSAY tmp1->descfunc
		if (tmp1->sitfolh==' ')
			@ prow(),070	PSAY "NORMAL"
		elseif (tmp1->sitfolh=='A')
			@ prow(),070	PSAY "AFAST."
		elseif (tmp1->sitfolh=='D')
			@ prow(),070	PSAY "DEMIT."
		elseif (tmp1->sitfolh=='F')
			@ prow(),070	PSAY "FERIAS"
		endif
		if mv_par08==1
		   @ prow(),078   PSAY tmp1->salario picture "@E 99,999.99"
		endif
		@ prow(),089   PSAY dtoc(tmp1->admissao)
		@ prow(),099   PSAY dtoc(_dtini)
		@ prow(),109   PSAY dtoc(_dtfim)
		@ prow(),119   PSAY dtoc(_dtvencfer)
		@ prow(),129   PSAY _avos picture "@E 99.9"

	endif
	tmp1->(dbskip())
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
_cquery+=" RA_MAT MAT,"
_cquery+=" RA_NOME NOME,"
_cquery+=" RJ_DESC DESCFUNC,"
_cquery+=" RA_SITFOLH SITFOLH,"
_cquery+=" RA_SALARIO SALARIO,"
_cquery+=" RA_ADMISSA ADMISSAO,"
_cquery+=" RF_DATABAS DATABAS"
_cquery+=" FROM "

_cquery+=  retsqlname("SRA")+" SRA,"
_cquery+=  retsqlname("SRJ")+" SRJ,"
_cquery+=  retsqlname("SRF")+" SRF"

_cquery+=" WHERE"                   
_cquery+="     SRA.D_E_L_E_T_<>'*'"
_cquery+=" AND SRJ.D_E_L_E_T_<>'*'"
_cquery+=" AND SRF.D_E_L_E_T_<>'*'"
_cquery+=" AND RA_FILIAL='"+_cfilsra+"'"
_cquery+=" AND RF_FILIAL='"+_cfilsrf+"'"
_cquery+=" AND RJ_FILIAL='"+_cfilsrj+"'"
_cquery+=" AND RA_MAT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND RA_CC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND RA_SITFOLH IN (' '"

if mv_par05==1  //Cons.Func.Afastado ?
   _cquery+=",'A'"
endif

if mv_par06==1  //Cons.Func.de Ferias?
   _cquery+=",'F'"
endif

if mv_par07==1  //Cons.Func.Demitido ?
   _cquery+=",'D'"
endif
_cquery+=")"
_cquery+=" AND RA_MAT=RF_MAT"
_cquery+=" AND RA_CODFUNC=RJ_FUNCAO"
_cquery+=" ORDER BY RA_NOME, RA_MAT"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"    
tcsetfield("TMP1","ADMISSAO","D")
tcsetfield("TMP1","SALARIO","N",12,2)
tcsetfield("TMP1","DATABAS","D")

return



static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do Funcionario     ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"02","Ate o Funcionario  ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"03","Do C.Custo         ?","mv_ch3","C",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{cperg,"04","Ate o C.Custo      ?","mv_ch4","C",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"CTT"})
aadd(_agrpsx1,{cperg,"05","Cons.Func.Afastado ?","mv_ch5","N",01,0,0,"C",space(60),"mv_par05"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Cons.Func.de Ferias?","mv_ch6","N",01,0,0,"C",space(60),"mv_par06"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Cons.Func.Demitido ?","mv_ch7","N",01,0,0,"C",space(60),"mv_par07"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Imprime Salario    ?","mv_ch8","N",01,0,0,"C",space(60),"mv_par08"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Mostrar avos       ?","mv_ch9","N",01,0,0,"C",space(60),"mv_par09"       ,"Todos"          ,space(30),space(15),"Igual a"        ,space(30),space(15),"Maior que"      ,space(30),space(15),"Menor que"      ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Quais (anterior)   ?","mv_cha","N",15,1,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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
LAYOUT DO RELATORIO

                                                                                                      ULTIMAS FERIAS      VENCIMENTO
Nº MAT. FUNCIONARIO                               FUNCAO                SITUACAO   SALARIO  ADMISSAO  INICIO    FIM       FERIAS
999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX  X       999.999,99  99/99/99  99/99/99  99/99/99  99/99/99
RA_MAT  RA_NOME                                 RJ_DESC                RA_SALARIO   RA_ADMISSAO RH_DATAINI RH_DATAFIM _dtvencfer
*/

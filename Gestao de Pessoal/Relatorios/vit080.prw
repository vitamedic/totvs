/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT080   ³ Autor ³ Gardenia Ilany        ³ Data ³ 08/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcionarios por Cargo e Salarios                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function vit080()
nordem  :=""
tamanho :="M"
limite  :=132
titulo  :="Funcionários / Cargo"
cdesc1  :="Este programa ira emitir a relacao de cargos e salarios "
cdesc2  :="De acordo com os parametros..."
cdesc3  :=""
cstring :="SRA"
areturn :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog:="VIT080"
wnrel   :="VIT080"+Alltrim(cusername)
alinha  :={}
nlastkey:=0
aordem  :={}
ccancel := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.
cbcont   :=0
m_pag    :=1
li       :=132
cbtxt    :=space(10)

cperg:="PERGVIT080"
_pergsx1()
pergunte(cperg,.f.)


wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

rptstatus({|| rptdetail()})
Return


//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()

_cfilsrj:=xfilial("SRJ")
_cfilsra:=xfilial("SRA")
_cfilszt:=xfilial("SZT")
_cfilctt:=xfilial("CTT")
srj->(dbsetorder(1))
sra->(dbsetorder(7))
szt->(dbsetorder(1))
ctt->(dbsetorder(1))

_mpag:=0
_ntot :=0
_acom    :={}

cabec1:=" Considera demitidos de "+dtoc(mv_par03)+" a "+dtoc(mv_par04)
cabec2:="Matric. Colaborador                                      Cargo                                 Sal.Base Data Admis. Demissao"

setprc(0,0)
@ 000,000 PSAY AvalImp(Limite)

setregua(sra->(lastrec()))

sra->(dbgotop())

while ! sra->(eof()) .and.;
	lcontinua

	incregua()
	if prow()==0 .or. prow()>55
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif

	if sra->ra_sitfolh =='D' .and. (sra->ra_demissa < mv_par03 .or.  sra->ra_demissa > mv_par04)
		sra->(dbSkip())
		loop
	endif
	
	if sra->ra_mat < mv_par01 .and. sra->ra_mat > mv_par02
		sra->(dbSkip())
		loop
	endif
	
	if sra->ra_mat > "900000"
		sra->(dbSkip())
		loop
	endif

	If sra->ra_cc  < mv_par05 .or. sra->ra_cc > mv_par06
		sra->(dbSkip())
		loop
	endif
	
	_codfunc:= sra->ra_codfunc

	srj->(dbseek(_cfilsrj+sra->ra_codfunc))
	_func:=substr(srj->rj_desc,1,30)

	ctt->(dbseek(_cfilctt+sra->ra_cc))
	_gerenc:=ctt->ctt_gerenc

	aadd(_acom,{sra->ra_mat,substr(sra->ra_nome,1,35),_func,;
	sra->ra_salario,sra->ra_admissa,sra->ra_demissa,_gerenc,sra->ra_cc})
	
	sra->(dbSkip())

	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		eject
		lcontinua:=.f.
	endif
end

_acoms:= asort(_acom,,,{|x,y| x[7]+x[8]+x[3]<y[7]+y[8]+y[3]})
_mcant:=space(0)

incregua()

if prow()>55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
endif

_cont:=0
_nval:=0
_ntval:=0
_nttval:=0
_nttot:=0
_mcc :=""

for _i:=1 to len(_acoms)
	if prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
	endif
	if _mcc <> _acoms[_i,7]
		if _cont>0
			@ prow()+1, 000 PSAY "Qtde. Funcionários:"
			@ prow(),22 PSAY _cont picture "@E 999,999"
			@ prow(),90 PSAY _nval picture "@E 999,999,999.99"
			@ prow()+1, 000 PSAY " "
			_ntval += _nval
			_cont:=0
			_nval:=0
		endif
	  	if !empty(_ntval)
			@ prow()+3,00 PSAY "No. de Funcionários:"
			@ prow(),23  PSAY _ntot picture "9999"
			@ prow(),090 PSAY _ntval picture "@E 999,999,999.99"
			_nttval += _ntval
			_nttot += _ntot
			_ntot:=0
			_ntval:=0			
	   	endif
		
		if prow()>0
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		endif
		@ prow()+1, 000 PSAY _acoms[_i,8]
		@ prow()  , 001 PSAY ""
		_mcc := _acoms[_i,7]
	endif
	if _mcant <> _acoms[_i,3]
		_mcant:=_acoms[_i,3]
		if _cont>0
			@ prow()+1, 000 PSAY "Qtde. Funcionários:"
			@ prow(),22 PSAY _cont picture "@E 999,999"
			@ prow(),90 PSAY _nval picture "@E 999,999,999.99"
			@ prow()+1, 000 PSAY " "
			_ntval += _nval
			_cont:=0
			_nval:=0
		endif
	endif
	@ prow()+1,000 PSAY left(_acoms[_i,1],6)
	@ prow(),008   PSAY left(_acoms[_i,2],40)
	@ prow(),057   PSAY left(_acoms[_i,3],40)
	@ prow(),090   PSAY _acoms[_i,4] picture "@E 999,999,999.99"
	@ prow(),105   PSAY _acoms[_i,5]
	@ prow(),116   PSAY _acoms[_i,6]
	_ntot++
	_cont++
	_nval += _acoms[_i,4]
next
if _cont>0
	@ prow()+1, 000 PSAY "Qtde. Funcionários:"
	@ prow(),22 PSAY _cont picture "@E 999,999"
	@ prow(),90 PSAY _nval picture "@E 999,999,999.99"
	@ prow()+1, 000 PSAY " "
	_ntval += _nval
	_cont:=0
	_nval:=0
endif

if !empty(_ntval)
	@ prow()+3,00 PSAY "No. de Funcionários:"
	@ prow(),23  PSAY _ntot picture "9999"
	@ prow(),090 PSAY _ntval picture "@E 999,999,999.99"
	_nttval += _ntval
	_nttot += _ntot
	_ntot:=0
	_ntval:=0			
endif

@ prow()+3,00 PSAY "No. Total de Func.:"
@ prow(),23  PSAY _nttot picture "9999"
@ prow(),090 PSAY _nttval picture "@E 999,999,999.99"

if prow()>0 .and. lcontinua
	roda(cbcont,cbtxt)
endif

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return


static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da matricula       ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"02","Ate a matricula    ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"03","Demitidos de       ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Demitidos Ate      ?","mv_ch4","D",08,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do Centro de Custo ?","mv_ch5","C",09,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})
aadd(_agrpsx1,{cperg,"06","Ate Centro de Custo?","mv_ch6","C",09,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SI3"})

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

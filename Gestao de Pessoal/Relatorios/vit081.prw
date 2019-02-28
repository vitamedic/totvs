/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT081   ³ Autor ³ Gardenia              ³ Data ³ 08/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao de Relacao de Cargos e Salarios                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function VIT081()

nordem  :=""
tamanho  := "M"
limite   := 132
titulo   := "Funcionários / Cargo"
cdesc1   := "Este programa ira emitir a relacao de cargos e salarios "
cdesc2   := "De acordo com os parametros..."
cdesc3   := ""
cstring  := "SRA"
areturn  := {"Zebrado",1,"administracao",1,2,1,"",0}
nomeprog := "VIT081"
wnrel    := "VIT081"
alinha   := {}
nlastkey := 0
ccancel  := "***** CANCELADO PELO OPERADOR *****"
lcontinua:=.t.


cperg    :="PERGVIT081"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=SetPrint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,,.t.,tamanho,"",.f.)

if nlastkey==27
	set filter to
	return
endif

SetDefault(aReturn,cString)

ntipo :=if(areturn[4]==1,15,18)
nordem:=areturn[8]

if nlastkey==27
	set filter to
	return
endif

rptStatus({|| rptdetail()})
//Set Century Off
Return
//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=132
cbtxt :=space(10)

_cfilsrj:=xfilial("SRJ")
_cfilsra:=xfilial("SRA")
_cfilsrb:=xfilial("SRB")
_cfilsx5:=xfilial("SX5")
srj->(dbsetorder(1))
sra->(dbsetorder(7))
srb->(dbsetorder(1))
sx5->(dbsetorder(1))

_mpag:=0
_ntot :=0
_tcont:=0
_tgdepen:=0
_tgeral:=0
_totdepen:=0

cabec1:="Função                                  Qtde. Func.           "//Salario           Tot/Cargo              Depend.     Func.+Depend."
cabec2:=""

setprc(0,0)
@ 000,000 PSAY avalimp(133)

setregua(sra->(lastrec()))


sra->(dbgotop())

while ! sra->(eof())
	
	If (sra->ra_sitfolh =='D')
		sra->(dbskip())
	elseif (sra->ra_mat < mv_par01 .and.;
		sra->ra_mat > mv_par02)
		sra->(dbskip())
	else
		IncRegua()
		if prow()==0 .or. prow()>58
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
		endif
		
		_codfunc:= sra->ra_codfunc
		_cont:=0
		
		srj->(dbseek(_cfilsrj+sra->ra_codfunc))
		
		@ prow()+1,00 PSAY srj->rj_desc
		
		_salario:= srj->rj_salario
		_totdepen:=0
		
		while ! sra->(eof()) .and.;
			_codfunc == sra->ra_codfunc
			
			if prow()==0 .or. prow()>58
				cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
			endif
			if sra->ra_sitfolh <>'D'
				
				if sra->ra_mat >= mv_par01 .and.;
					sra->ra_mat <= mv_par02
					
					if prow()>58
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,ntipo)
					endif
					
					srb->(dbseek(_cfilsrb+sra->ra_mat))

					while ! srb->(eof()) .and.;
							sra->ra_mat==srb->rb_mat

						if (srb->rb_graupar="F" .or.;
							srb->rb_graupar="C")
							_totdepen+=1
						endif
						srb->(dbskip())
					end
					_cont++
				endif
			endif
			sra->(dbskip())

			if labortprint
				@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
				eject
				lcontinua:=.f.
			endif
		end
		@ prow(),40 PSAY _cont picture "@E 999,999"
		@ prow(),60 PSAY _salario picture "@E 999,999.99"
		@ prow(),80 PSAY _salario*_cont picture "@E 999,999.99"
		@ prow(),100 PSAY _totdepen picture "@E 999,999"
		@ prow(),115 PSAY _totdepen+_cont picture "@E 999,999"
		_tcont+=_cont
		_tgdepen+=_totdepen
		_tgeral+=_totdepen+_cont
		_ntot+=_cont*_salario
	endif
end

if prow()>58
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,15)
endif

@ prow()+1,00 PSAY "Total Geral ====>"
@ prow(),40 PSAY _tcont picture "@E 999,999"
@ prow(),79 PSAY _ntot picture "@E 9999,999.99"
@ prow(),100 PSAY _tgdepen picture "@E 999,999"
@ prow(),115 PSAY _tgeral picture "@E 999,999"

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

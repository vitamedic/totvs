/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT192   ³ Autor ³ Aline                 ³ Data ³ 18/05/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Horario de Trabalho                             ³±±
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

user function VIT192()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="Relacao de Horario de Trabalho "
cdesc1   :="Este programa ira emitir Relacao de Horario de Trabalho"
cdesc2   :=""
cdesc3   :=""
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT192"
wnrel    :="VIT192"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
cbcont   :=0
m_pag    :=1
li       :=200
cbtxt    :=space(10)
lcontinua:=.t.

cperg:="PERGVIT192"
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

_cfilspj:=xfilial("SPJ")
spj->(dbsetorder(1))
_cfilsrj:=xfilial("SRJ")
srj->(dbsetorder(1))

dbSelectArea("SRA")
dbSetOrder(3)
dbGoTop()   

//processa({|| _querys()})

//cabec1:="Função                             Nome                                       Salário              Comissão  Sub-Total Encargos(1)   FGTS(2)  Sub-Total   Vale Tr.   Refeição     Unimed     Total"
 cabec1:="Matric. Nome                                       Função              Carteira Prof. Entr.       Intervalo        Saida"
 cabec2:="                                                                        Numero Serie                                      "
setprc(0,0)

setregua(sra->(lastrec()))
Do While !Eof() 
  If SRA->RA_SITFOLH =='D'
    dbSelectArea("SRA")
    dbSkip()
    Loop
  EndIf                                                 
  If SRA->RA_MAT < mv_par01 .OR. SRA->RA_MAT > mv_par02
    dbSelectArea("SRA")
    dbSkip()
    Loop
  EndIf
	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	incregua()
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
		if prow()>53
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
		endif
		spj->(dbseek("  "+sra->ra_tnotrab+"012"))     
		srj->(dbseek(_cfilsrj+sra->ra_codfunc))     
		@ prow()+1 ,00 PSAY sra->ra_mat
	  	@ prow()   ,08 PSAY sra->ra_nome
	  	@ prow()   ,50 PSAY srj->rj_desc
	  	@ prow()   ,71 PSAY sra->ra_numcp+"-"+sra->ra_sercp
	  	@ prow()   ,85 PSAY spj->pj_entra1 PICTURE("@e 99.99 hs")
	  	@ prow()   ,95 PSAY spj->pj_saida1 PICTURE("@e 99.99 ")+" as "
	  	@ prow()   ,105 PSAY spj->pj_entra2 PICTURE("@e 99.99 hs")
	  	@ prow()   ,115 PSAY spj->pj_saida2 PICTURE("@e 99.99 hs")
	sra->(dbskip())
end
if prow()>53
	cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
endif


if prow()>0 .and.;
	lcontinua
//   roda(cbcont,cbtxt)
endif

sra->(dbclosearea())
srj->(dbclosearea())
spj->(dbclosearea())

set device to screen

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endIf

ms_flush()
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da Matricula       ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
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

/*
Produto: xxxxxxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  Data        Quantidade UM Ordem de producao Quantidade Seg. UM
99/99/99 999,999,999.999 xx    xxxxxxxxxxx    999,999,999.999 xx
*/
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT083   ³ Autor ³ Gardenia Ilany        ³ Data ³ 21/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Termo de Responsabilidade                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para VITAMEDIC                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "topconn.ch"
#include "rwmake.ch"

user function VIT083()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="TERMO DE RESPONSABILIDADE"
cdesc1   :="Este programa ira emitir a o termo de responsabilidade"
cdesc2   :="de acordo com os parametros"
cdesc3   :=""
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT083"
nrel    :="VIT083"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.
wnrel := ""
cperg:="PERGVIT083"
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
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:=""
cabec2:=""

_cfilsra:=xfilial("SRA")
_cfilsrb:=xfilial("SRB")
sra->(dbsetorder(1))
srb->(dbsetorder(1))

processa({|| _geratmp()})

setprc(0,0)

@ 000,000 PSAY avalimp(limite)+chr(18)

setregua(se1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
			lcontinua
	@ prow()+4,000 PSAY "                           TERMO DE RESPONSABILIDADE"
	@ prow()+4,005 PSAY "(Concessão de Salário Família  -  Portaria nº MPAS-3040/1982)
	if sm0->m0_codigo=='01'
		@ prow()+4,005 PSAY "Empresa..: VITAMEDIC INDUSTRIA FARMACEUTICA LTDA.
		@ prow()+1,005 PSAY "           Rua: VPR 01 Qd. 2-A Modulo 01"
		@ prow()+1,005 PSAY "           75133/600 - Anapolis-GO"
		@ prow()+1,005 PSAY "           CNPJ: 30.222.814/0001.31"
	elseif sm0->m0_codigo=="03"
 		@ prow()+4,010 PSAY "Empresa..: FUNDAÇÃO CULTURAL VITAMEDIC."
		@ prow()+1,010 PSAY "           Av.: Pedro Ludovico Lt.19/20 - Jd. Ana Paula"
		@ prow()+1,010 PSAY "           75000/000 - Anapolis-GO"
		@ prow()+1,010 PSAY "           CNPJ: 03.931.389/0001.87"
	endif
	@ prow()+4,005 PSAY "Segurado.: "+tmp1->nome
	@ prow()+1,005 PSAY "CTPS.....: "+tmp1->numcp +" - "+tmp1->sercp+tmp1->ufcp
	@ prow()+1,005 PSAY "Admissao.: "+dtoc(tmp1->admissa)
	srb->(dbseek(_cfilsrb+tmp1->mat))
	@ prow()+6,000 PSAY "                           RELACAO DE FILHOS"

   @ prow()+4,005 PSAY "Nome Filho                                   Dt.Nasc.
   @ prow()+1,005 PSAY "--------------------------------------------------------------------"
	while ! srb->(eof()) .and. tmp1->mat==srb->rb_mat
	   @ prow()+1,005 PSAY srb->rb_nome
	   @ prow(),050 PSAY srb->rb_dtnasc
		srb->(dbskip())
	end
	@ prow()+3,005 PSAY "Pelo presente TERMO DE RESPONSABILIDADE, declaro estar ciente de que"
	@ prow()+1,005 PSAY "deverei comunicar de imediato a ocorrência dos seguintes  fatos, que"
	@ prow()+1,005 PSAY "determinam a perda do direito ao salário família."
	@ prow()+2,005 PSAY "           - OBITO DE FILHO"
	@ prow()+1,005 PSAY "           - CESSAÇÃO DE INVALIDEZ DE FILHO INVÁLIDO"
	@ prow()+1,005 PSAY "           - SENTENÇA JUDICIAL PARA PAGAMENTO A OUTREM"
	@ prow()+2,005 PSAY "Estou ciente, ainda, que a falta de cumprimento do  compromisso  ora"
	@ prow()+1,005 PSAY "assumido, além  de obrigar à devolução  das  importâncias  recebidas"
	@ prow()+1,005 PSAY "indevidamente, sujeitar-me-á às penalidades previstas no art. 171 do"
	@ prow()+1,005 PSAY "código penal e à rescisão do contrato de trabalho, por justa  causa,"
	@ prow()+1,005 PSAY "nos termos do art. 482 da CLT."
	@ prow()+05,005 PSAY alltrim(sm0->m0_cidcob)+", "+str(day(ddatabase),2)+" de "+;
						mesextenso(month(ddatabase))+" de "+str(year(ddatabase),4)
	@ prow()+4,005 PSAY tmp1->mat +"   "+tmp1->nome

	tmp1->(dbskip())
	if  ! tmp1->(eof())
		@ 66,00 PSAY " "
		@ 00,00 PSAY " "
//	   eject
	endif
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end
set device to screen

 tmp1->(dbclosearea())

if areturn[5]==1
   set print to
   dbcommitall()
   ourspool(wnrel)
endif
ms_flush()
return

static function _geratmp()
procregua(1)

incproc("Selecionando titulos vencidos...")
_cquery:=" SELECT"
_cquery+=" RA_MAT MAT,RA_NOME NOME,RA_NUMCP NUMCP,RA_SERCP SERCP,RA_UFCP UFCP,"
_cquery+=" RA_ADMISSA ADMISSA,RA_CODFUNC CODFUNC"
_cquery+=" FROM "
_cquery+=  retsqlname("SRA")+" SRA"
_cquery+=" WHERE"
_cquery+="     SRA.D_E_L_E_T_<>'*'"
_cquery+=" AND RA_FILIAL='"+_cfilsra+"'"
_cquery+=" AND RA_MAT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" ORDER BY"
_cquery+=" RA_NOME"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","ADMISSA","D")
//tcsetfield("TMP1","JUROS"  ,"N",15,2)
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

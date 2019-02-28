/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT074   � Autor � Gardenia Ilany        � Data � 21/06/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ficha de Salario Familia                                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para VITAMEDIC                                  ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "topconn.ch"
#include "rwmake.ch"

user function VIT077()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="FICHA DE DECLARA��O DE OP��O"
cdesc1   :="Este programa ira emitir a ficha de declara��o de op��o"
cdesc2   :="de acordo com os parametros"
cdesc3   :=""
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT077"
wnrel    :="VIT077"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT077"
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
sra->(dbsetorder(1))

processa({|| _geratmp()})

setprc(0,0)

@ 000,000 PSAY avalimp(limite)+chr(18)
	
setregua(se1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
			lcontinua
	@ prow()+4,000 PSAY "                           DECLARA��O DE OP��O"
	@ prow()+6,010 PSAY "     Eu "+alltrim(tmp1->nome)+","
	@ prow()+2,005 PSAY "portador(a) da Carteira profissional n�"+tmp1->numcp+"/"+tmp1->sercp+tmp1->ufcp+", empregado(a) da "
	if sm0->m0_codigo=='01'
		@ prow()+2,005 PSAY "empresa  VITAMEDIC IND�STRIA FARMAC�UTICA LTDA. sita � Rua VPR 01 Qd. 2-A"
		@ prow()+2,005 PSAY "Modulo  01 - DAIA, An�polis-GO, declaro, para todos os fins, que, nesta"
	elseif sm0->m0_codigo=='03'
		@ prow()+2,005 PSAY "empresa FUNDA��O CULTURAL VITAMEDIC sita � Av. Pedro  Ludovico  Lt. 19/20"
		@ prow()+2,005 PSAY "Jd. Ana Paula ,  An�polis-GO,  declaro,  para todos os fins, que, nesta"
	endif	
	@ prow()+2,005 PSAY "data, exer�o a op��o pelo regime do Regulamento do Fundo de Garantia do"
	@ prow()+2,005 PSAY "Tempo de Servi�o"
	@ prow()+8,004 PSAY alltrim(sm0->m0_cidcob)+", "+str(day(ddatabase),2)+" de "+;
						mesextenso(month(ddatabase))+" de "+str(year(ddatabase),4)
	@ prow()+6,005 PSAY tmp1->nome
   @ prow()+4,005 PSAY "Testemunhas:"
   @ prow()+3,005 PSAY "1�) _______________________________________________"
   @ prow()+3,005 PSAY "2�) _______________________________________________"
	@ prow()+3,005 PSAY "___________________________________________________"
	@ prow()+1,005 PSAY "     (Assistente respons�vel legal pelo menor)"
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
_cquery+=" RA_MAT MAT,RA_NOME NOME,RA_NUMCP NUMCP,RA_SERCP SERCP,RA_UFCP UFCP"
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
//tcsetfield("TMP1","ADMISSA","D")
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


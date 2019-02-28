/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT085   � Autor � Gardenia Ilany        � Data � 21/06/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Aviso Previo do Empregador para Dispensa do Colaborador    潮�
北�          � no Periodo de Experiencia.                                 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "topconn.ch"
#include "rwmake.ch"

user function VIT114()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="AVISO PREVIO DO COLABORADOR"
cdesc1   :="Este programa ira emitir  o aviso previo  do colaborador"
cdesc2   :="de acordo com os parametros"
cdesc3   :=""
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT114"
wnrel    :="VIT114"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT114"
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
_cfilsr8:=xfilial("SR8")
sra->(dbsetorder(1))
sr8->(dbsetorder(1))

processa({|| _geratmp()})

setprc(0,0)

@ 000,000 PSAY avalimp(limite)+chr(18)
	
setregua(se1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
			lcontinua
	set softseek on		
   sr8->(dbseek(_cfilsr8+tmp1->mat))
   set softseek off
   _dias:=100
	while ! sr8->(eof()) .and. sr8->r8_mat==tmp1->mat
		if sr8->r8_tipo=='F' 
        _dias := date()-sr8->r8_datafim
      endif  
		sr8->(dbskip())      
   end     
   if _dias <=30
      msgstop("Funcion醨io "+Alltrim(tmp1->nome) + " com estabilidade de f閞ias !!!")
		tmp1->(dbskip())      
		loop
	else	
		@ prow()+4,000 PSAY "            AVISO PR蒝IO DO EMPREGADOR PARA DISPENSA DO COLABORADOR "
		@ prow()+8,005 PSAY "Ao"
		@ prow()+1,005 PSAY "Sr(a): "+ tmp1->nome
		@ prow()+1,005 PSAY "NESTA"                     
		@ prow()+4,005 PSAY "Pelo presente o notificamos que n鉶 mais ser鉶 utilizados os seus servi鏾s"
		@ prow()+1,005 PSAY "pela nossa empresa e por isso vimos avis�-lo nesta data, nos termos e para"
		@ prow()+1,005 PSAY "os efeitos do disposto no Artigo 479 CLT.                           "
		@ prow()+5,005 PSAY "Pedimos a devolu玢o da presente com seu 'CIENTE'."
		@ prow()+08,005 PSAY alltrim(sm0->m0_cidcob)+", "+str(day(mv_par03),2)+" de "+;
						mesextenso(month(mv_par03),2)+" de "+str(year(mv_par03),4)
		@ prow()+6,005 PSAY sm0->m0_nomecom
		@ prow()+6,005 PSAY tmp1->nome
		@ prow()+4,005 PSAY "Foi programado  para o dia:" +dtoc(mv_par05)+" , o  pagamento  dos valores  de sua"
		@ prow()+1,005 PSAY "de sua rescis鉶. Para tanto voc� dever� comparecer  nesta data,  munido" 
		@ prow()+1,005 PSAY "de seus documentos, para as devidas baixas."
		tmp1->(dbskip())
		if  ! tmp1->(eof())
		@ 66,00 PSAY " "
		@ 00,00 PSAY " "
//		   eject
		endif   
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
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
aadd(_agrpsx1,{cperg,"03","Data do aviso      ?","mv_ch3","D",08,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Dias de aviso      ?","mv_ch4","N",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Data Pagto         ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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


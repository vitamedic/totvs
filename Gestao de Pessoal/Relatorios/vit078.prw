/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT074   � Autor � Gardenia Ilany        � Data � 21/06/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Contrato de Trabalho a Titulo de Experiencia               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para VITAMEDIC                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "topconn.ch"
#include "rwmake.ch"

user function VIT078()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="CONTRATO DE TRABALHO A TITULO DE EXPERIENCIA "
cdesc1   :="Este programa ira emitir a ficha de declara玢o de op玢o"
cdesc2   :="de acordo com os parametros"
cdesc3   :=""
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT078"
wnrel    :="VIT078"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT078"
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
_cfilsrj:=xfilial("SRJ")
sra->(dbsetorder(1))
srj->(dbsetorder(1))

processa({|| _geratmp()})

setprc(0,0)

@ 000,000 PSAY avalimp(limite)+chr(18)
	
setregua(se1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
			lcontinua
   srj->(dbseek(_cfilsrj+tmp1->codfunc))
  	@ prow()+1,000 PSAY "             CONTRATO DE TRABALHO A TITULO DE EXPERI蔔CIA"
	@ prow()+3,005 PSAY "     Por  este  instrumento  particular,  que  entre si fazem a   firma"
	if sm0->m0_codigo=="01"
		@ prow()+1,005 PSAY "VITAMEDIC IND赟TRIA FARMAC蔝TICA LTDA. Com sede nesta cidade de An醦olis,"
		@ prow()+1,005 PSAY "�  Rua  VPR  01  Qd.2-A  M骴ulo 01 ,neste ato denominada 'Empregadora',"
	elseif sm0->m0_codigo=="03"	
		@ prow()+1,005 PSAY "FUNDA敲O CULTURAL VITAMEDIC   Com sede  nesta  cidade  de An醦olis,  � Av."
		@ prow()+1,005 PSAY "Pedro Ludovico Lt.19/20 Jd.Ana Paula ,neste ato denominada 'Empregadora',"
	endif	
	@ prow()+1,005 PSAY "e o Sr(a) "+tmp1->nome
	@ prow()+1,005 PSAY "portador(a) da Carteira profissional n� "+tmp1->numcp+", serie "+tmp1->sercp+tmp1->ufcp+", inscrito"
	@ prow()+1,005 PSAY "no CPF sob n� "+ tmp1->cic+ " e cadastrado no PIS-PASEP sob n� "+tmp1->pis+","
	@ prow()+1,005 PSAY "doravante, chamado, simplesmente 'Empregado',firmam o presente contrato"
	@ prow()+1,005 PSAY "individual de trabalho, em car醫er de experi阯cia, conforme a letra 'C'" 
	@ prow()+1,005 PSAY "par醙rado 2篸o artigo 443 da consolida玢o das leis do trabalho,mediante"
	@ prow()+1,005 PSAY "as seguintes condi珲es:"
	@ prow()+1,005 PSAY "      1) - O Empregado trabalhar� para a Empregadora,exercendo a fun玢o"
   @ prow()+1,005 PSAY "de "+ substr(srj->rj_desc,1,30) +" percebendo um sal醨io de R$" +transform(tmp1->salario,"@E 999,999,999.99")
   @ prow()+1,005 PSAY alltrim(extenso(tmp1->salario))
   @ prow()+1,005 PSAY "pagos de forma mensal."
   @ prow()+1,005 PSAY "      2) - O hor醨io a ser obedecido ser� o seguinte: das "+mv_par03 +" as" + mv_par04
   @ prow()+1,005 PSAY "com intervalo de "+mv_par05 + " minutos."
   @ prow()+1,005 PSAY "      3) - Este contrato tem in韈io a  partir de "+dtoc(tmp1->admissa)+",  vencendo-se"  
   @ prow()+1,005 PSAY "em "+ dtoc(tmp1->vctoexp) +" , podendo ser prorrogado, obedecido o disposto no Par醙rafo"
   @ prow()+1,005 PSAY "趎ico do Artigo 445 da CLT."
   @ prow()+1,005 PSAY "      4) - O Empregado se compromete a trabalhar em regime de compensa-"
   @ prow()+1,005 PSAY "玢o e prorroga玢o  de  horas,  inclusive  em  per韔do  noturno,  sempre"
   @ prow()+1,005 PSAY "que as necessidades assim exigirem, observadas as formalidades legais."
   @ prow()+1,005 PSAY "      5) - Obriga-se o Empregado,  al閙  de  executar  com dedica玢o  e"
   @ prow()+1,005 PSAY "lealdade o seu servi鏾, a cumprir o Regulamento Interno da Empregadora,"
   @ prow()+1,005 PSAY "as instru珲es de sua administra玢o e  as ordens  de seus chefes e supe-"
   @ prow()+1,005 PSAY "riores hier醨quicos, relativas  鄐 peculiaridades dos servi鏾s  que lhe"
   @ prow()+1,005 PSAY "forem confiados."
   @ prow()+1,005 PSAY "      6) - Aplicam-se a este contrato todas as normas em vigor, relati-"
   @ prow()+1,005 PSAY "vas aos contratos a prazo determinado, devendo sua rescis鉶 antecipada,"
   @ prow()+1,005 PSAY "por justa causa,  obedecer  ao disposto  nos  artigos 482 e 483 da CLT,"
   @ prow()+1,005 PSAY "conforme  o caso."
   @ prow()+1,005 PSAY "      7) - Vencido o  per韔do  experimental e continuando o empregado a"
   @ prow()+1,005 PSAY "prestar servi鏾s � Empregadora, por tempo indeterminado,ficam prorroga-"
   @ prow()+1,005 PSAY "das todas as cl醬sulas aqui estabelecidas, enquanto n鉶  se rescindir o"    
   @ prow()+1,005 PSAY "contrato de trabalho."
   @ prow()+1,005 PSAY "+---------------------------------------------------------------------+"
   @ prow()+1,005 PSAY "|                               CONTRATO                              |"
   @ prow()+1,005 PSAY "|                                                                     |"
   @ prow()+1,005 PSAY "|     E por estarem de pleno acordo, assinam ambas as partes, em duas |"
   @ prow()+1,005 PSAY "|vias de igual teor, na presen鏰 de duas testemunhas.                 |"
   @ prow()+1,005 PSAY "|                                                                     |"
   @ prow()+1,005 PSAY "|                              _______________________________________|"                 
   @ prow()+1,005 PSAY "|"+dtoc(tmp1->admissa)+"                      Assintatura do Respons醰el quando menor|"                 
   @ prow()+1,005 PSAY "|________________________________     _______________________________ |"
   @ prow()+1,005 PSAY "|      Empregadora                              Empregado                                        
   @ prow()+1,005 PSAY "+---------------------------------------------------------------------+"
   @ prow()+1,005 PSAY "+---------------------------------------------------------------------+"
   @ prow()+1,005 PSAY "|                      TERMO DE PRORROGA敲O                           |"
   @ prow()+1,005 PSAY "|     Por m鷗uo acordo entre as partes, fica o presente  contrato  de |"
   @ prow()+1,005 PSAY "|experi阯cia, que deveria vencer nesta data, prorrogado at� "+dtoc(tmp1->admissa+90)+"  |"
   @ prow()+1,005 PSAY "|                                  ___________________________________|"                 
   @ prow()+1,005 PSAY "|___/___/___"+"                                    Assinatatura           |"                 
   @ prow()+1,005 PSAY "+---------------------------------------------------------------------+"
   @ prow()+1,005 PSAY "+---------------------------------------------------------------------+"
   @ prow()+1,005 PSAY "|Testemunhas:_________________________       _________________________|"                 
   @ prow()+1,005 PSAY "|                     Nome                            Nome            |"
   @ prow()+1,005 PSAY "+---------------------------------------------------------------------+"
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

incproc("Selecionando funcion醨ios...")
_cquery:=" SELECT"
_cquery+=" RA_MAT MAT,RA_NOME NOME,RA_NUMCP NUMCP,RA_SERCP SERCP,RA_UFCP UFCP,RA_CIC CIC,"
_cquery+=" RA_PIS PIS,RA_CODFUNC CODFUNC,RA_SALARIO SALARIO,RA_ADMISSA ADMISSA,RA_VCTOEXP VCTOEXP"
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
tcsetfield("TMP1","VCTOEXP","D")
tcsetfield("TMP1","SALARIO"  ,"N",15,2)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da matricula       ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"02","Ate a matricula    ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SRA"})
aadd(_agrpsx1,{cperg,"03","Do hor醨io         ?","mv_ch3","C",05,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate hor醨io        ?","mv_ch4","C",05,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Intervalo(minutos) ?","mv_ch5","C",03,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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


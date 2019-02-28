/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT076   ³ Autor ³ Gardenia Ilany        ³ Data ³ 21/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Declaracao de Deslocamento para Vale Transporte            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Alteracoes³ - 14/09/06: Alex Júnio                                     ³±±
±±³          ³   Adequação para Imprimir os Meios Utilizados pelo         ³±±
±±³          ³   Funcionário como Transporte.                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function VIT076()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="DECLARACAO DE DESLOCAMENTO PARA VALE TRANSPORTE"
cdesc1   :="Este programa ira emitir a ficha de declaracao de deslocamento para "
cdesc2   :="o vale transporte de acordo com os parametros"
cdesc3   :=""
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT076"
wnrel    :="VIT076"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT076"
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
_cfilsrn:=xfilial("SRN")
_cfilsr0:=xfilial("SR0")
sra->(dbsetorder(1))
srn->(dbsetorder(1))
sr0->(dbsetorder(1))

processa({|| _geratmp()})

setprc(0,0)

@ 000,000 PSAY avalimp(limite)+chr(18)
	
setregua(se1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
			lcontinua
	@ prow()+4,000 PSAY "                           DECLARAÇÃO DE DESLOCAMENTO"
	@ prow()+1,000 PSAY "                             PARA O VALE-TRANSPORTE"
	if sm0->m0_codigo=="01"	
		@ prow()+4,005 PSAY "Empresa..: VITAMEDIC INDÚSTRIA FARMACÊUTICA LTDA.
		@ prow()+1,005 PSAY "           Rua: VPR 01 Qd. 2-A Módulo 01 - DAIA"
		@ prow()+1,005 PSAY "           75133/600 - Anápolis-GO"
		@ prow()+1,005 PSAY "           CNPJ: 30.222.814/0001.31"
	elseif sm0->m0_codigo=="03"	
 		@ prow()+4,010 PSAY "Empresa..: FUNDAÇÃO CULTURAL VITAMEDIC."
		@ prow()+1,010 PSAY "           Av.: Pedro Ludovico Lt.19/20 - Jd. Ana Paula"
		@ prow()+1,010 PSAY "           75000/000 - Anapolis-GO"
		@ prow()+1,010 PSAY "           CNPJ: 03.931.389/0001.87"
	endif

	@ prow()+4,005 PSAY "     De conformidade com  o Decreto nº 95.247, que regulamenta a lei nº"
	@ prow()+1,005 PSAY "7.418, de 16 de  dezembro de  1985,  com  a  alteração dada pela lei nº"
	@ prow()+1,005 PSAY "7.619, de 30 de setembro de 1987, declaro meu endereço atual. :
	@ prow()+2,005 PSAY "Rua... :" + tmp1->enderec
	@ prow()+1,005 PSAY "Bairro :" + tmp1->bairro
	@ prow()+1,005 PSAY "Cidade :" + tmp1->municip
	@ prow()+1,005 PSAY "Estado :" + tmp1->estado
	@ prow()+2,005 PSAY "e que uso os meios de transportes abaixo para o deslocamento Residência/"
	@ prow()+1,005 PSAY "Trabalho/Residência:"
	@ prow()+1,005 PSAY " "

	sr0->(dbseek(_cfilsr0+tmp1->mat))
	
	While !sr0->(eof()) .and.;
			tmp1->mat==sr0->r0_mat

		srn->(dbseek(_cfilsrn+sr0->r0_meio))
		
		if (srn->rn_tpmeio=="1")
			@ prow()+1,005 PSAY "     - Transporte Municipal Urbano - Empresa: "+srn->rn_desc
		else
			@ prow()+1,005 PSAY "     - Transporte Intermunicipal Semi-Urbano - Empresa: "+srn->rn_desc
		endif
		
		sr0->(dbskip())
	end

	@ prow()+2,000 PSAY "                           AUTORIZAÇÃO DE DESCONTO"
	
   @ prow()+4,005 PSAY "     Autorizo o desconto até limite de 6%(seis por cento) do meu salário"
   @ prow()+1,005 PSAY "para participar como beneficiário do  Programa Vale Transporte,comprome-"
   @ prow()+1,005 PSAY "tendo-me  ainda  a  utilização  desse benefício exclusivamente ao efeito"
   @ prow()+1,005 PSAY "deslocamento Residência - Trabalho e Vice-Versa,  sujeitando-me  as pena-"
   @ prow()+1,005 PSAY "lidades previstas em lei."
	@ prow()+4,005 PSAY alltrim(sm0->m0_cidcob)+", "+str(day(ddatabase),2)+" de "+;
						mesextenso(month(ddatabase))+" de "+str(year(ddatabase),4)
	@ prow()+8,005 PSAY tmp1->nome
	@ prow()+1,005 PSAY "CPF: "+tmp1->cic
	
	tmp1->(dbskip())
	if  ! tmp1->(eof())
		@ 66,00 PSAY " "
		@ 00,00 PSAY " "
//   eject
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
_cquery+=" RA_MAT MAT,RA_NOME NOME,RA_CIC CIC,RA_ENDEREC ENDEREC,RA_BAIRRO BAIRRO,"
_cquery+=" RA_MUNICIP MUNICIP,RA_ESTADO ESTADO"
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


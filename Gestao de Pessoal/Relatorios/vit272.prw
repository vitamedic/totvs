/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT272   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 24/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Declaracao de Renuncia de Vale Transporte                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function VIT272()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="TERMO DE RESPONSABILIDADE CARTAO VALE TRANSPORTE"
cdesc1   :="Este programa ira emitir o Termo de Responsabilidade sobre"
cdesc2   :="o Cartao Vale Transporte e Autorizacao para desconto em"
cdesc3   :="folha de pagamento para reemissao do cartao."
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT272"
wnrel    :="VIT272"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT272"
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
_cfilsx5:=xfilial("SX5")
sra->(dbsetorder(1))
sx5->(dbsetorder(1))

processa({|| _geratmp()})

setprc(0,0)

@ 000,000 PSAY avalimp(limite)+chr(18)
	
setregua(se1->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
			lcontinua
	@ prow()+4,005 PSAY "                         TERMO DE RESPONSABILIDADE"
	@ prow()+1,005 PSAY "              AUTORIZAÇÃO PARA DESCONTO EM FOLHA DE PAGAMENTO"

	@ prow()+3,002 PSAY "VITAMEDIC INDÚSTRIA FARMACÊUTICA LTDA, pessoa jurídica de direito privado   ins-"
	@ prow()+1,002 PSAY "crita no CNPJ sob o nº 30.222.814/0001-31, sediada à Rua VPR-1, Quadra   02-A,"
	@ prow()+1,002 PSAY "módulo 01, DAIA, Anápolis - GO., ora  denominada  como  empregadora          e"
	@ prow()+1,002 PSAY alltrim(tmp1->nome)+", "+lower(alltrim(tmp1->naciona))+", Contrato de Trabalho sob"
	@ prow()  ,079 PSAY "'" 
	@ prow()+1,002 PSAY "matrícula "+tmp1->mat+" ora denominado(a) empregado(a), firmam o presente Termo    de"
	@ prow()+1,002 PSAY "Responsabilidade, comprometendo-se a:"

	@ prow()+2,002 PSAY "I - A EMPREGADORA deverá disponibilizar a 1ª via do Cartão Vale Transporte re-"
	@ prow()+1,002 PSAY "quisitado junto a empresa de Transporte Coletivo Urbano."

	@ prow()+2,002 PSAY "II - A EMPREGADORA disponibilizará também o crédito das locomoções    conforme"
	@ prow()+1,002 PSAY "solicitado pelo empregado no Termo de Opção de Vale Transporte, instituído pe-"
	@ prow()+1,002 PSAY "las leis nº 7.418/85 e seguintes."

	@ prow()+2,002 PSAY "III - O EMPREGADO obriga-se a utilizar o Vale Transporte sob as penas da   lei"
	@ prow()+1,002 PSAY "95.247/87, mantendo atualizado o endereço."

	@ prow()+2,002 PSAY "IV - É vedado AO EMPREGADO ceder, vender ou transferir a quem quer que seja  o"
	@ prow()+1,002 PSAY "cartão Vale  Transporte, devendo informar a EMPREGADORA a sua perda, roubo  ou"
	@ prow()+1,002 PSAY "defeito, para que seja providendiado o bloqueio dos créditos e     transferido"
	@ prow()+1,002 PSAY "saldo remanescente, sob pena das implicações previstas na lei acima e    perda"
	@ prow()+1,002 PSAY "imediata do benefício."

	@ prow()+2,002 PSAY "V - Para a reemissão do cartão Vale Transporte por qualquer motivo, salvo   em"
	@ prow()+1,002 PSAY "caso de defeito não ocasionado pelo usuário, será cobrado o valor   correspon-"
	@ prow()+1,002 PSAY "dente à 17 passagens."

	@ prow()+2,002 PSAY "VI - O EMPREGADO terá o direito de utilizar referido cartão enquanto    houver"
	@ prow()+1,002 PSAY "vínculo com A EMPREGADORA, obrigando-se a devolvê-lo em perfeitas    condições"
	@ prow()+1,002 PSAY "observando o desgaste natural decorrente do uso, quando do seu afastamento  e/"
	@ prow()+1,002 PSAY "ou rescisão do contrato de trabalho."

	@ prow()+2,002 PSAY "   a) Em caso de renúncia ou perda do benefício, O EMPREGADO encontra-se obri-"
	@ prow()+1,002 PSAY "gado a restituir o cartão nos termos constantes neste Termo."

	@ prow()+2,002 PSAY "   b) A não restituição implica em bloqueio imediato do mesmo e    autorização"	
	@ prow()+1,002 PSAY "tácita para desconto do custo da reemissão, citado no item 5."	

	@ prow()+2,002 PSAY "VII - O não cumprimento de quaisquer itens acima ocasionará perda do benefício."
                                                                                                      "
	@ prow()+2,002 PSAY "Assim juntos e entendidos, assinam o presente Termo de Compromisso em uma   só"
	@ prow()+1,002 PSAY "via, com finalidade exclusiva do cumprimento das responsabilidades assumidas."

// DATA POR EXTEnSO
	@ prow()+2,002 PSAY "Anápolis-GO, "+str(day(ddatabase),2)+" de "+mesextenso(month(ddatabase))+;
							  " de "+str(year(ddatabase),4)
                       
//012345678901234567890123456789012345678901234567890123456789012345678901234567890
//0         10        20        30        40        50        60        70        80
    
	@ prow()+3,002 PSAY "_______________________________      ________________________________________"

	_qcar:=0
	_qcar:=len(alltrim(tmp1->nome))
	_nome:=""                
	_incesp:=""
	
	if (_qcar<39)
		_inc:=int((40-_qcar)/2)

		for _i:=1 to _inc
			_incesp=" "+_incesp
		next
		@ prow()+1,002 PSAY "Vitamedic Indústria. Farm. Ltda     "+_incesp+alltrim(tmp1->nome)	
	else
		@ prow()+1,002 PSAY "Vitamedic Indústria. Farm. Ltda     "+alltrim(tmp1->nome)	
	endif
	
	@ prow()+1,002 PSAY "          Empregador                                Empregado"

	tmp1->(dbskip())
	if  ! tmp1->(eof())
		@ 66,00 PSAY " "
		@ 00,00 PSAY " "
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
_cquery+=" RA_MAT MAT,"
_cquery+=" RA_NOME NOME,"
_cquery+=" X5_DESCRI NACIONA"
_cquery+=" FROM "
_cquery+=  retsqlname("SRA")+" SRA,"
_cquery+=  retsqlname("SX5")+" SX5"
_cquery+=" WHERE"
_cquery+="     SRA.D_E_L_E_T_<>'*'"
_cquery+=" AND SX5.D_E_L_E_T_<>'*'"
_cquery+=" AND RA_FILIAL='"+_cfilsra+"'"
_cquery+=" AND X5_FILIAL='"+_cfilsx5+"'"
_cquery+=" AND RA_MAT BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND RA_SITFOLH<>'D'"
_cquery+=" AND X5_TABELA='34'"
_cquery+=" AND X5_CHAVE=RA_NACIONA"
_cquery+=" ORDER BY"
_cquery+=" RA_NOME"

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
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


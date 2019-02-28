/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT226   ³ Autor ³ Gardenia Ilany        ³ Data ³ 22/09/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Contrato Plano de Saude - Unimed                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteração ³Alex Júnio de Miranda                     ³ Data ³ 27/01/06 ³±±
±±³		    ³Correção texto: inclusão de Nota para maio/06 e exclusão da ³±±
±±³          ³ cláusula 8, renumeração e alteração da cláusula 10.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function VIT226()
nordem   :=""
tamanho  :="M"
limite   :=120
titulo   :="CONTRATO PLANO DE SAUDE - UNIMED"
cdesc1   :="Este programa ira emitir o contrato de plano de saúde UNIMED"
cdesc2   :=" "
cdesc3   :=""
cstring  :="SRA"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT226"
wnrel    :="VIT226"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT226"
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
_cfilsxr:=xfilial("SRX")
sra->(dbsetorder(1))
srb->(dbsetorder(1))
srx->(dbsetorder(2))

processa({|| _geratmp()})

setprc(0,0)

@ 000,000 PSAY avalimp(limite)+chr(18)
	
setregua(sra->(lastrec()))

tmp1->(dbgotop())
while ! tmp1->(eof()) .and. lcontinua
	@ prow()+1,000 PSAY "               PLANO DE SAÚDE UNIMED - CONVÊNIO VITAMEDIC"
//	if sm0->m0_codigo=="01"
// 		@ prow()+6,010 PSAY "Empresa..: VITAPAN INDUSTRIA FARMACEUTICA LTDA."
//		@ prow()+1,010 PSAY "           Rua: VPR 01 Qd. 2-A Modulo 01 - DAIA"
//		@ prow()+1,010 PSAY "           75133/600 - Anapolis-GO"
//		@ prow()+1,010 PSAY "           CNPJ: 30.222.814/0001.31"
//	elseif sm0->m0_codigo=="03"	
// 		@ prow()+4,010 PSAY "Empresa..: FUNDAÇÃO CULTURAL VITAPAN."
//		@ prow()+1,010 PSAY "           Av.: Pedro Ludovico Lt.19/20 - Jd. Ana Paula"
//		@ prow()+1,010 PSAY "           75000/000 - Anapolis-GO"
//		@ prow()+1,010 PSAY "           CNPJ: 03.931.389/0001.87"
//	endif
	@ prow()+2,000 PSAY "Empregado: "+ tmp1->nome 
	@ prow()+1,000 PSAY "CTPS Nº  : "+tmp1->numcp+"/"+tmp1->sercp+"-"+tmp1->ufcp
	@ prow()+1,000 PSAY "CPF      : "+substr(tmp1->cic,1,3)+"."+substr(tmp1->cic,4,3)+"."+substr(tmp1->cic,7,3)+"-"+substr(tmp1->cic,10,2)

	@ prow()+2,000 PSAY "TIPO DE PLANO: Co-participativo onde o usuário contribui com 25% do valor da consulta - R$22,50"  //Valor alterado requerido em 28/04/2015 - Guilherme Teodoro.
	@ prow()+2,000 PSAY "                   Internação em quarto coletivo"
	@ prow()+2,000 PSAY "TAXA DE ADESÃO:                R$ "+transform(mv_par03,"@R 999,999.99")+" Por pessoa"
	@ prow()+1,000 PSAY "Contribuição do funcionário    R$ "+transform(mv_par04,"@R 999,999.99")+" Por funcionário"
	@ prow()+1,000 PSAY "                               R$ "+transform(mv_par05,"@R 999,999.99")+" Por dependente"

	@ prow()+2,000 PSAY "CONTRIBUIÇÃO MENSAL POR USUÁRIO (Funcionário ou dependente)"
//	srx->(dbseek("22"+"01"+strzero(val(tmp1->asmedic),2,0)))
	srx->(dbseek("22"+"01"))
	@ prow()+1,00 PSAY "Faixas Salariais             Participação por pessoa"
	while ! srx->(eof()) .and. lcontinua
		if substr(srx->rx_txt,1,1) <> "A"
			srx->(dbskip())
         loop
      endif
      _perdesc:= val(substr(srx->rx_txt,46,6))/100
		_valunimed:=val(substr(srx->rx_txt,27,6))
		@ prow()+1,000 PSAY substr(srx->rx_txt,3,20)
		@ prow(),040 PSAY _perdesc*_valunimed picture "@R 999,999.99" 
  		srx->(dbskip())
   end
   // inclusão em 27/01/06 - Alterações conforme Diretoria Administrativo-Financeira
	@ prow()+2,000 PSAY "NOTA: As alterações de faixa, bem como do valor,serão informadas em contra-cheque, devendo eventual discordância"
	@ prow()+1,000 PSAY "ser comunicada ao Departamento de Pessoal antes do próximo pagamento."
	@ prow()+2,000 PSAY "CLÁUSULAS"
	@ prow()+1,000 PSAY "01- A adesão no ato do contrato isenta de todas as carências abaixo, inclusive gestantes"
	@ prow()+1,000 PSAY "    em qualquer mês de gravidez, podendo utilizar de imediato todas as coberturas do plano."
	@ prow()+1,000 PSAY "02- As adesões posteriores estarão sujeitos às carências abaixo."
	@ prow()+1,000 PSAY "03- O plano contratado não possui nenhuma limitação de utilização (consultas,exames,internações)"
	@ prow()+1,000 PSAY "    dentro dos procedimentos médicos estabelecidos na lei que rege os planos de saúde."
	@ prow()+1,000 PSAY "04- O usuário irá receber a carteirinha UNIMED e o guia da rede credenciada."
	@ prow()+1,000 PSAY "05- A utilização da carteirinha por terceiros implica em ato grave e exclusão imediata do plano por parte da UNIMED."
   @ prow()+1,000 PSAY "06- A UNIMED oferece um benefício extra que é seguro assistencial, ou seja, em caso de falecimento"
   @ prow()+1,000 PSAY "    do titular, seus dependentes terão, sem ônus, a cobertura total do plano por um período a mais de 3 anos"
   @ prow()+1,000 PSAY "07- A adesão do plano é voluntária."
   @ prow()+1,000 PSAY "08- O reajuste dos valores contratados só poderá acontecer anualmente"
   @ prow()+1,000 PSAY "09- Estando o empregado de licença maternidade, auxílio doença, licença médica, atestado ou afastado por"
   @ prow()+1,000 PSAY "    doença médica, poderá utilizar o Plano de saúde UNIMED, entretanto, deverá dirigir-se à empresa e"
   @ prow()+1,000 PSAY "    pagar a sua cota parte do plano, bem como todas as consultas, no prazo máximo e improrrogável de "
   @ prow()+1,000 PSAY "    até o 15º dia referente ao mês subsequente, vez que, o Plano de Saúde é descontado em folha de "
   @ prow()+1,000 PSAY "    pagamento sendo que , caso o empregado não pague a sua cota parte, o Plano será CANCELADO "
   @ prow()+1,000 PSAY "    IMEDIATAMENTE,tanto o titular, quanto seus dependentes."
   @ prow()+1,000 PSAY "10- O Plano de Saúde será imediatamente cancelado por solicitação específica ou ainda por demissão devendo o empregado"
   @ prow()+1,000 PSAY "    devolver quando da assinatura do aviso prévio, a Carteira do Plano de Saúde do titular, bom como de seus dependentes."

   @ prow()+2,000 PSAY "CARÊNCIAS:"
   @ prow()+1,000 PSAY "Urgência e emergência                                                   24 horas"
   @ prow()+1,000 PSAY "Consultas e exames complementares                                       30 dias"
   @ prow()+1,000 PSAY "Guias de tratamento ambulatorial de urgência                           180 dias"
   @ prow()+1,000 PSAY "Exames especiais:ecocardiograma,ultra-sonografia,raio X c/ contraste   180 dias"
   @ prow()+1,000 PSAY "Internação clínico-cirúrgica                                           180 dias"
   @ prow()+1,000 PSAY "Ressonância magnética e exames sofisticados                            180 dias"
   @ prow()+1,000 PSAY "Parto normal e cezárea                                                 300 dias"
   @ prow()+1,000 PSAY "Tratamento de doenças pré-existentes                                   720 dias"

   @ prow()+2,000 PSAY "DESEJA ADERIR AO PLANO DE SAÚDE  OFERECIDO PELA VITAMEDIC? "
   @ prow()+1,000 PSAY "Assinale com um X a sua opção- assine e retorne ao RH"
   @ prow()+1,000 PSAY "SIM                                        (      )                NÃO (      )"
   @ prow()+1,000 PSAY "Somente para mim                           (      )"
   @ prow()+1,000 PSAY "Extensivo a  meus dependentes legais       (      )"
   if mv_par06 = 1
		srb->(dbsetorder(1))
		srb->(dbseek(_cfilsrb+tmp1->mat))
		while ! srb->(eof()) .and. tmp1->mat==srb->rb_mat
	 		if srb->rb_graupar="F"
	 			_graupar:="Filh"
	 		elseif srb->rb_graupar="C"		
	 		   _graupar:="Espos"
	      endif              
	      if srb->rb_sexo="M"
	      	_graupar:=_graupar+"o"
	      else
	      	_graupar:=_graupar+"a"
 	      endif	
			if srb->rb_graupar="F" .or.  srb->rb_graupar="C"
			   @ prow()+1,010 PSAY srb->rb_nome 
			   @ prow(),055 PSAY _graupar
			   @ prow(),073 PSAY srb->rb_dtnasc
//	 	   _totdepen+=1
			endif   
			srb->(dbskip())
		end
	endif   
   @ prow()+1,000 PSAY "Desejo aderir ao plano conforme opção acima e autorizo a empresa a efetuar o desconto equivalente a minha"
   @ prow()+1,000 PSAY "faixa salarial, referente a minha contribuição mensal como titular e/ou de meus dependentes."
//   @ prow()+2,000 PSAY "Nome legível:"
//   @ prow()+1,000 PSAY "Setor:"
   @ prow()+2,000 PSAY "Declaro para os devidos fins de direito que tenho ciência das cláusulas e condições constantes da aderência"
   @ prow()+1,000 PSAY "ao Plano de Saúde - UNIMED - Convênio Vitamedic, concordando com o disposto em linhas volvidas."
   @ prow()+2,000 PSAY "Anápolis, _____/_____/_____"
   @ prow()+2,000 PSAY "Assinatura:________________________________________"

	
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

incproc("Selecionando funcionários...")
_cquery:=" SELECT"
_cquery+=" RA_MAT MAT,RA_NOME NOME,RA_NUMCP NUMCP,RA_SERCP SERCP,RA_UFCP UFCP,"
_cquery+=" RA_ADMISSA ADMISSA,RA_CODFUNC CODFUNC,RA_CIC CIC"
_cquery+=" FROM "
_cquery+=  retsqlname("SRA")+" SRA"
_cquery+=" WHERE"
_cquery+="     SRA.D_E_L_E_T_<>'*'"
_cquery+=" AND RA_FILIAL='"+_cfilsra+"'"
_cquery+=" AND RA_SITFOLH<>'D'"
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
aadd(_agrpsx1,{cperg,"03","Taxa adesão empresa?","mv_ch3","N",15,2,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Taxa adesão func.  ?","mv_ch4","N",15,2,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Taxa adesão depend.?","mv_ch5","N",15,2,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Inclui dependentes ?","mv_ch6","N",01,0,0,"C",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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


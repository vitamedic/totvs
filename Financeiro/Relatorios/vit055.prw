/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT055   ³ Autor ³ Gardenia Ilany        ³ Data ³ 17/04/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Carta de Cobranca de Clientes com Titulos a Receber em     ³±±
±±³          ³ Atraso                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "topconn.ch"
#include "rwmake.ch"

user function VIT055()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="CARTA DE COBRANCA"
cdesc1   :="Este programa ira emitir a carta de cobranca para clientes com titulos"
cdesc2   :="a receber em atraso"
cdesc3   :=""
cstring  :="SE1"
areturn  :={"Zebrado",1,"Administracao",1,2,1,"",1}
nomeprog :="VIT055"
wnrel    :="VIT055"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT055"
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

_cfilsa1:=xfilial("SA1")
_cfilse1:=xfilial("SE1")
sa1->(dbsetorder(1))
se1->(dbsetorder(1))

processa({|| _geratmp()})

setprc(0,0)

if mv_par19==1
	@ 000,000 PSAY avalimp(limite)+chr(18)
	
	setregua(se1->(lastrec()))

	tmp1->(dbgotop())
	while ! tmp1->(eof()) .and.;
			lcontinua
		sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
		@ 010,010 PSAY alltrim(sm0->m0_cidcob)+", "+str(day(date()),2)+" de "+;
							mesextenso(month(date()))+" de "+str(year(date()),4)
		@ prow()+4,010 PSAY "A"
		@ prow()+2,010 PSAY sa1->a1_nome
		@ prow()+6,010 PSAY "Prezado cliente,"
		@ prow()+4,010 PSAY "     De conformidade com os nossos registros de contas a receber,não"
		@ prow()+1,010 PSAY "encontramos até presente data, o pagamento do(s) título(s) abaixo:"
		@ prow()+3,010 PSAY "Prf Numero P Tipo Emissão  Vencto.        Valor  A Receber Atraso Bco"
		_ntit    :=0
		_nvalor  :=0
		_ccliente:=tmp1->cliente
		_cloja   :=tmp1->loja               
		while ! tmp1->(eof()) .and.;
				tmp1->cliente==_ccliente .and.;
				tmp1->loja==_cloja
			incregua()
			_juros := 0          
			_juros1:= 0          
			_taxa := 0
			_saldo:=0
			_totjur:=0
			if prow() == 59
				eject
			endif	
			@ prow()+1,010 PSAY tmp1->prefixo
			@ prow(),014   PSAY tmp1->numero
			@ prow(),021   PSAY tmp1->parcela
			@ prow(),024   PSAY tmp1->tipo
			@ prow(),028   PSAY tmp1->emissao
			@ prow(),037   PSAY tmp1->vencto
			_atraso := ddatabase-tmp1->vencto
			if _atraso <=30
				_juros :=(tmp1->saldo*_atraso*0.27)/100
			else 
				_juros :=(tmp1->saldo*30*0.27)/100
				_saldo:=tmp1->saldo*((1+(0.27/100))^(_atraso-30))
				_juros1:=_saldo-tmp1->saldo
         endif  
         _totjur:=_juros+_juros1
			@ prow(),047   PSAY tmp1->valor picture "@E 999,999.99"
			@ prow(),058   PSAY tmp1->saldo+_totjur picture "@E 999,999.99"
			@ prow(),069   PSAY date()-tmp1->vencto picture "@E 999999"
			@ prow(),076   PSAY tmp1->portador
			_ntit++
			_nvalor+=tmp1->saldo+_totjur
			tmp1->(dbskip())
		end
		if _ntit>1
			@ prow()+1,034 PSAY str(_ntit,3)+" TITULOS"
			@ prow(),056   PSAY _nvalor picture "@E 9,999,999.99"
		endif
		@ prow()+3,010 PSAY "     Gostaríamos  de contar  com  sua atenção no sentido  de  quitar"
		@ prow()+1,010 PSAY "o(s) débito(s) em aberto, até o dia "+dtoc(mv_par18)+"."
		@ prow()+1,010 PSAY "     Após  esta  data, persistindo  a  pendência,  encaminharemos  o"
		@ prow()+1,010 PSAY "débito em atraso ao nosso Departamento Jurídico, para  que  o  mesmo"  
		@ prow()+1,010 PSAY "providencie a cobrança judicial, bem como  o registro da  ocorrência"
		@ prow()+1,010 PSAY "nos órgãos de proteção  ao crédito."
		@ prow()+1,010 PSAY "     Na  hipótese  do(s)  valor(es) acima  já ter(em) sido quitados,"
		@ prow()+1,010 PSAY " queira, por gentiliza, desconsiderar a presente comunicação."
		@ prow()+4,010 PSAY "     Atenciosamente,"
		@ prow()+4,010 PSAY replicate("_",40)
		@ prow()+1,010 PSAY sm0->m0_nomecom
		@ prow()+1,010 PSAY "Departamento de Crédito e Cobrança"
//		eject
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
	end
else
	@ 000,000 PSAY avalimp(132)
	
	setregua(sa1->(lastrec()))
	
	tmp1->(dbgotop())
	while ! tmp1->(eof()) .and.;
			lcontinua
		_aetiq:=array(5,2)
		for _i:=1 to 5
			for _j:=1 to 2
				_aetiq[_i,_j]:=""
			next
		next
		_i:=0
		while ! tmp1->(eof()) .and.;
				lcontinua .and.;
				_i<2
			incregua()
			sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
			_i++
			_aetiq[1,_i]:=sa1->a1_nome
			_aetiq[2,_i]:=sa1->a1_end
			_aetiq[3,_i]:=sa1->a1_bairro
			_aetiq[4,_i]:=alltrim(sa1->a1_mun)+" - "+sa1->a1_est
			_aetiq[5,_i]:=sa1->a1_cep
			tmp1->(dbskip())
		end
	   @ prow(),000   PSAY _aetiq[1,1]
	   @ prow(),058   PSAY _aetiq[1,2]
  	   @ prow()+1,000 PSAY _aetiq[2,1]
     	@ prow(),058   PSAY _aetiq[2,2]
  	   @ prow()+1,000 PSAY _aetiq[3,1]
     	@ prow(),058   PSAY _aetiq[3,2]
  	   @ prow()+1,000 PSAY _aetiq[4,1]
     	@ prow(),058   PSAY _aetiq[4,2]
  	   @ prow()+1,000 PSAY _aetiq[5,1] picture "@R 99999-999"
     	@ prow(),058   PSAY _aetiq[5,2] picture "@R 99999-999"
      @ prow()+2,000 PSAY ""
//		eject
		if labortprint
			@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
			lcontinua:=.f.
		endif
	end
endif

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

if mv_par19==1
	incproc("Selecionando titulos vencidos...")
	_cquery:=" SELECT"
	_cquery+=" E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_PREFIXO PREFIXO,E1_NUM NUMERO,"
	_cquery+=" E1_PARCELA PARCELA,E1_TIPO TIPO,E1_EMISSAO EMISSAO,"
	_cquery+=" E1_VENCTO VENCTO,E1_SALDO SALDO,E1_PORTADO PORTADOR,E1_VALOR VALOR,E1_JUROS JUROS"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SE1")+" SE1"
	_cquery+=" WHERE"
	_cquery+="     SE1.D_E_L_E_T_<>'*'"
	_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
	_cquery+=" AND E1_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par03+"'"
	_cquery+=" AND E1_LOJA BETWEEN '"+mv_par02+"' AND '"+mv_par04+"'"
	_cquery+=" AND E1_PREFIXO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" AND E1_NUM BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" AND E1_TIPO BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	_cquery+=" AND E1_PORTADO BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
	_cquery+=" AND E1_EMISSAO BETWEEN '"+dtos(mv_par13)+"' AND '"+dtos(mv_par14)+"'"
	_cquery+=" AND E1_VENCTO BETWEEN '"+dtos(mv_par15)+"' AND '"+dtos(mv_par16)+"'"
	
	if mv_par17==2
		_cquery+=" AND E1_SITUACA<>'2'"
	endif
	_cquery+=" AND E1_TIPO NOT IN ('RA ','NCC','PR ')"
	_cquery+=" AND SUBSTR(E1_TIPO,3,1)<>'-'"
	_cquery+=" AND E1_SALDO>0"
	_cquery+=" ORDER BY"
	_cquery+=" E1_CLIENTE,E1_LOJA,E1_VENCTO,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"

	_cquery:=changequery(_cquery)

	tcquery _cquery new alias "TMP1"
	tcsetfield("TMP1","EMISSAO","D")
	tcsetfield("TMP1","VENCTO" ,"D")
	tcsetfield("TMP1","SALDO"  ,"N",15,2)
	tcsetfield("TMP1","VALOR"  ,"N",15,2)
	tcsetfield("TMP1","JUROS"  ,"N",15,2)
else
	incproc("Selecionando clientes com titulos vencidos...")
	_cquery:=" SELECT"
	_cquery+=" E1_CLIENTE CLIENTE,E1_LOJA LOJA"
	_cquery+=" FROM "
	_cquery+=  retsqlname("SE1")+" SE1"
	_cquery+=" WHERE"
	_cquery+="     SE1.D_E_L_E_T_<>'*'"
	_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
	_cquery+=" AND E1_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par03+"'"
	_cquery+=" AND E1_LOJA BETWEEN '"+mv_par02+"' AND '"+mv_par04+"'"
	_cquery+=" AND E1_PREFIXO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	_cquery+=" AND E1_NUM BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	_cquery+=" AND E1_TIPO BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
	_cquery+=" AND E1_PORTADO BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
	_cquery+=" AND E1_EMISSAO BETWEEN '"+dtos(mv_par13)+"' AND '"+dtos(mv_par14)+"'"
	_cquery+=" AND E1_VENCTO BETWEEN '"+dtos(mv_par15)+"' AND '"+dtos(mv_par16)+"'"
	if mv_par17==2
		_cquery+=" AND E1_SITUACA<>'2'"
	endif
	_cquery+=" AND E1_TIPO NOT IN ('RA ','NCC','PR ')"
	_cquery+=" AND SUBSTR(E1_TIPO,3,1)<>'-'"
	_cquery+=" AND E1_SALDO>0"
	_cquery+=" GROUP BY"
	_cquery+=" E1_CLIENTE,E1_LOJA"
	_cquery+=" ORDER BY"
	_cquery+=" E1_CLIENTE,E1_LOJA"

	_cquery:=changequery(_cquery)

	tcquery _cquery new alias "TMP1"
endif
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do cliente         ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"02","Da loja            ?","mv_ch2","C",02,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Ate o cliente      ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"04","Ate a loja         ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do prefixo         ?","mv_ch5","C",03,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate o prefixo      ?","mv_ch6","C",03,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do titulo          ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o titulo       ?","mv_ch8","C",06,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do tipo            ?","mv_ch9","C",03,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"05 "})
aadd(_agrpsx1,{cperg,"10","Ate o tipo         ?","mv_chA","C",03,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"05 "})
aadd(_agrpsx1,{cperg,"11","Do banco           ?","mv_chB","C",03,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"BCO"})
aadd(_agrpsx1,{cperg,"12","Ate o banco        ?","mv_chC","C",03,0,0,"G",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"BCO"})
aadd(_agrpsx1,{cperg,"13","Da emissao         ?","mv_chD","D",08,0,0,"G",space(60),"mv_par13"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"14","Ate a emissao      ?","mv_chE","D",08,0,0,"G",space(60),"mv_par14"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"15","Do vencimento      ?","mv_chF","D",08,0,0,"G",space(60),"mv_par15"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"16","Ate o vencimento   ?","mv_chG","D",08,0,0,"G",space(60),"mv_par16"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"17","Impr.tit.em descont?","mv_chH","N",01,0,0,"C",space(60),"mv_par17"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"18","Data limite pagto. ?","mv_chI","D",08,0,0,"G",space(60),"mv_par18"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"19","Imprimir           ?","mv_chJ","N",01,0,0,"C",space(60),"mv_par17"       ,"Carta"          ,space(30),space(15),"Etiqueta"       ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
          xxxxxxxx, 99 de xxxxxxxxx de 9999
			 
			 
			 
			 A
			 
			 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
			 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
			 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
			 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
			 
			 
			 
			 Prezado cliente,
			 
			      Em nossos registros de contas a receber não  consta,  até  a
					
			 presente data, o pagamento do(s) seguinte(s) título(s):
			 
			 PRF NUMERO P TIPO EMISSÃO  VENCTO.               VALOR ATRASO BCO
			 XXX 999999 X  XXX 99/99/99 99/99/99 999.999.999.999,99 999999 999
			                         999 TITULOS 999.999.999.999,99
			 
			      Gostaríamos de contar com sua atenção no sentido  de  quitar
					
			 o débito em aberto, até o dia 99/99/99.
			 
			      Após esta data, persistindo a  pendência,  encaminharemos  o
			 
			 débito em atraso ao nosso Departamento Jurídico para  promover  a
			 
			 cobrança judicial, bem como o registro nos órgãos de proteção  ao
			 
			 crédito.
			 
			      Na hipótese dessa  firma  ter  liquidado  o  valor  indicado
					
			 acima, queira, por fineza, desconsiderar a presente comunicação.
					
			 
			 
			 
			 
			      Atenciosamente,
					
					
					
					________________________________________
					XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*/

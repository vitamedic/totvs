/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT028   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 13/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de Faturas                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit028()
nordem   :=""
tamanho  :="P"
limite   :=80
titulo   :="IMPRESSAO DE FATURAS"
cdesc1   :="Este programa ira emitir as faturas"
cdesc2   :=""
cdesc3   :=""
cstring  :="SE1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT028"
wnrel    :="VIT028"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT028"
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

//*******************************************
//Funcao rptdetail - impressao do relatorio
//*******************************************

static function rptdetail()
cbcont:=0
m_pag :=1
li    :=80
cbtxt :=space(10)

cabec1:=""
cabec2:=""

_cfilsa1:=xfilial("SA1")
_cfilse1:=xfilial("SE1")
_cfilsf2:=xfilial("SF2")
sa1->(dbsetorder(1))
se1->(dbsetorder(1))
sf2->(dbsetorder(1))

processa({|| _geratmp()})

setregua(se1->(lastrec()))

setprc(0,0)
@ 000,000 PSAY chr(18)

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
		lcontinua
	sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
	_cprefixo:=tmp1->prefixo
	_cnumero :=tmp1->numero
	_demissao :=tmp1->emissao
	_nvalor  :=0
	_aduplic :={}
	_anotas  :={}
	while ! tmp1->(eof()) .and.;
			tmp1->prefixo==_cprefixo .and.;
			tmp1->numero==_cnumero
		incregua()
		_nvalor+=tmp1->valor
		aadd(_aduplic,{tmp1->parcela,tmp1->vencto,tmp1->valor})
		
		_cquery:=" SELECT"
		_cquery+=" E1_PREFIXO PREFIXO,E1_NUM NUMERO,E1_PARCELA PARCELA,E1_TIPO TIPO"
		_cquery+=" FROM "
		_cquery+=  retsqlname("SE1")+" SE1"
		_cquery+=" WHERE"
		_cquery+="     SE1.D_E_L_E_T_=' '"
		_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
		_cquery+=" AND E1_FATPREF='"+tmp1->prefixo+"'"
		_cquery+=" AND E1_FATURA='"+tmp1->numero+"'"
		_cquery+=" AND E1_TIPOFAT='"+tmp1->tipo+"'"
	
		_cquery:=changequery(_cquery)
		tcquery _cquery new alias "TMP2"
		
		tmp2->(dbgotop())
		while ! tmp2->(eof())
			_i:=ascan(_anotas,{|x| x[1]==tmp2->numero})
			if _i==0
				sf2->(dbseek(_cfilsf2+tmp2->numero+tmp2->prefixo))
				aadd(_anotas,{tmp2->numero,sf2->f2_valfat})
			endif
			tmp2->(dbskip())
		end
		tmp2->(dbclosearea())
		tmp1->(dbskip())
	end
	_i:=1
	_cextenso:=extenso(_nvalor,.f.,1)
	@ prow(),000 PSAY   "--------------------------------------------------------------------------------"
	@ prow()+1,000 PSAY "|"
	@ prow(),002   PSAY sm0->m0_nomecom
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "|"
	@ prow(),002   PSAY left(alltrim(sm0->m0_endcob)+" "+alltrim(sm0->m0_compcob)+" - "+alltrim(sm0->m0_baircob),40)
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "|"
	@ prow(),002   PSAY alltrim(sm0->m0_cidcob)+" - "+sm0->m0_estcob+" CEP: "+transform(sm0->m0_cepcob,"@R 99999-999")
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "|"
	@ prow(),002   PSAY "CGC: "+transform(sm0->m0_cgc,"@R 99.999.999/9999-99")
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "|"
	@ prow(),002   PSAY "INSCR. ESTADUAL: "+sm0->m0_insc  + "                             Emissao: "+	dtoc(_demissao) 
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "|------------------------------------------------------------------------------|"
	@ prow()+1,000 PSAY "|          FATURA         | SACADO......:"
	@ prow(),042   PSAY left(sa1->a1_nome,36)
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "|-------------------------| ENDERECO....:"
	@ prow(),042   PSAY left(alltrim(sa1->a1_end)+" - "+alltrim(sa1->a1_bairro),36)
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "| NUMERO   |        VALOR | MUNICIPIO...:"
	@ prow(),042   PSAY alltrim(sa1->a1_mun)+" - "+sa1->a1_est+" CEP: "+transform(sa1->a1_cep,"@E 99999-999")
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "|----------+--------------| PRACA PAGTO.:"
	if empty(sa1->a1_munc)           
		@ prow(),042   PSAY alltrim(sa1->a1_mun)+" - "+sa1->a1_est
	else
		@ prow(),042   PSAY alltrim(sa1->a1_munc)+" - "+sa1->a1_estc
	endif
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "|"
	@ prow(),002   PSAY _cnumero
	@ prow(),011   PSAY "|"
	@ prow(),012   PSAY _nvalor picture "@E 999,999,999.99"
	@ prow(),026   PSAY "| CPF / CGC...:"
	@ prow(),042   PSAY sa1->a1_cgc picture "@R 99.999.999/9999-99"
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "|-------------------------| INSCR. EST..:"
	@ prow(),042   PSAY sa1->a1_inscr
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "| RELACAO DE NOTAS FISCAIS|----------------------------------------------------|"
	@ prow()+1,000 PSAY "|-------------------------|  VALOR  |"
	@ prow(),038   PSAY substr(_cextenso,1,40)
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "| NUMERO   |        VALOR |   POR   |"
	if len(alltrim(_cextenso))>40
		@ prow(),038   PSAY substr(_cextenso,41,40)
	endif
	@ prow(),079   PSAY "|"
	@ prow()+1,000 PSAY "|----------+--------------| EXTENSO |"
	if len(alltrim(_cextenso))>80
		@ prow(),038   PSAY substr(_cextenso,81,40)
	endif
	@ prow(),079   PSAY "|"
	_impnota()
	@ prow(),027   PSAY "----------------------------------------------------|"
	_impnota()
	@ prow(),027   PSAY " IMPORTANCIA DE SUA COMPRA DE MERCADORIAS E/OU SER- |"
	_impnota()
	@ prow(),027   PSAY " VICOS CONSTANTES DA(S) NOTA(S) A MARGEM  DISCRIMI- |"
	_impnota()
	@ prow(),027   PSAY " NADA(S) PARA CUJA COBERTURA  EMITIMOS  A  PRESENTE |"
	_impnota()
	@ prow(),027   PSAY " FATURA.                                            |"
	_impnota()
	@ prow(),027   PSAY "----------------------------------------------------|"
	_impnota()
	@ prow(),027   PSAY "                 DUPLICATAS EMITIDAS                |"
	_impnota()
	@ prow(),027   PSAY "----------------------------------------------------|"
	_impnota()
	@ prow(),027   PSAY "   LETRA   |    VENCIMENTO    |             VALOR   |"
	_impnota()
	@ prow(),027   PSAY "-----------+------------------+---------------------|"
	for _j:=1 to len(_aduplic)
		if _j==len(_aduplic) .and.;
			_i>len(_anotas)
			@ prow()+1,000 PSAY "|"
			@ prow(),002   PSAY "TOTAL"
			@ prow(),011   PSAY "|"
			@ prow(),012   PSAY _nvalor picture "@E 999,999,999.99"
			@ prow(),026   PSAY "|"
		else
			_impnota()
		endif
		@ prow(),032 PSAY _aduplic[_j,1]
		@ prow(),038 PSAY "|"
		@ prow(),044 PSAY _aduplic[_j,2]
		@ prow(),057 PSAY "|"
		@ prow(),062 PSAY _aduplic[_j,3] picture "@E 999,999,999.99"
		@ prow(),079 PSAY "|"
	next
	if _i<=len(_anotas)
		for _k:=_i to len(_anotas)
			_impnota()
			@ prow(),038 PSAY "|"
			@ prow(),057 PSAY "|"
			@ prow(),079 PSAY "|"
		next
		@ prow()+1,000 PSAY "|"
		@ prow(),002   PSAY "TOTAL"
		@ prow(),011   PSAY "|"
		@ prow(),012   PSAY _nvalor picture "@E 999,999,999.99"
		@ prow(),026   PSAY "|"
		@ prow(),038   PSAY "|"
		@ prow(),057   PSAY "|"
		@ prow(),079   PSAY "|"
	endif
	@ prow()+1,000 PSAY "--------------------------------------------------------------------------------"
	if prow()>32
		@ 066,000 PSAY " "
		setprc(0,0)
	else
		@ 033,000 PSAY " "
	endif
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end

tmp1->(dbclosearea())

if prow()<=32
	@ 066,000 PSAY " "
	setprc(0,0)
endif
set device to screen

setpgeject(.f.)

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

static function _impnota()
if _i<=len(_anotas)
	@ prow()+1,000 PSAY "|"
	@ prow(),002   PSAY _anotas[_i,1]
	@ prow(),011   PSAY "|"
	@ prow(),012   PSAY _anotas[_i,2] picture "@E 999,999,999.99"
	@ prow(),026   PSAY "|"
	_i++
else
	@ prow()+1,000 PSAY "|          |              |"
endif
return

static function _geratmp()
procregua(1)

incproc("Selecionando faturas...")
_cquery:=" SELECT"
_cquery+=" E1_PREFIXO PREFIXO,E1_NUM NUMERO,E1_PARCELA PARCELA,E1_TIPO TIPO,"
_cquery+=" E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_EMISSAO EMISSAO,E1_VENCTO VENCTO,"
_cquery+=" E1_VALOR VALOR"
_cquery+=" FROM "
_cquery+=  retsqlname("SE1")+" SE1"
_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_PREFIXO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND E1_NUM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND E1_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"'"
_cquery+=" AND E1_TIPO='FT '"
_cquery+=" ORDER BY E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
	
_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","VENCTO" ,"D")
tcsetfield("TMP1","VALOR"  ,"N",12,2)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do prefixo         ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate o prefixo      ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do numero          ?","mv_ch3","C",09,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate o numero       ?","mv_ch4","C",09,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da emissao         ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate a emissao      ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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
--------------------------------------------------------------------------------
| VITAPAN INDUSTRIA FARMACEUTICA LTDA.                                         |
| RUA VPR 01 QUADRA 2A MODULO 01 - DAIA                                        |
| ANAPOLIS - GO CEP: 99999-999                                                 |
| CGC: 99.999.999/9999-99                                                      |
| INSCR. ESTADUAL: XXXXXXXXXXXXXXXXXXXX                                        |
|------------------------------------------------------------------------------|
|          FATURA         | SACADO......: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |
|-------------------------| ENDERECO....: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |
| NUMERO |          VALOR | MUNICIPIO...: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |
|--------+----------------| PRACA PAGTO.: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |
| 999999 | 999.999.999,99 | CPF / CGC...: 99.999.999/9999-99                   |
|-------------------------| INSCR. EST..: XXXXXXXXXXXXXXXXXXXX                 |
| RELACAO DE NOTAS FISCAIS|----------------------------------------------------|
|-------------------------|  VALOR  | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |
| NUMERO |          VALOR |   POR   | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |
|--------+----------------| EXTENSO | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |
| 999999 | 999.999.999,99 |----------------------------------------------------|
| 999999 | 999.999.999,99 | IMPORTANCIA DE SUA COMPRA DE MERCADORIAS E/OU SER- |
| 999999 | 999.999.999,99 | VICOS CONSTANTES DA(S) NOTA(S) A MARGEM  DISCRIMI- |
| 999999 | 999.999.999,99 | NADA(S) PARA CUJA COBERTURA  EMITIMOS  A  PRESENTE |
| 999999 | 999.999.999,99 | FATURA.                                            |
| 999999 | 999.999.999,99 |----------------------------------------------------|
| 999999 | 999.999.999,99 |                 DUPLICATAS EMITIDAS                |
| 999999 | 999.999.999,99 |----------------------------------------------------|
| 999999 | 999.999.999,99 |   LETRA   |    VENCIMENTO    |             VALOR   |
| 999999 | 999.999.999,99 |-----------+------------------+---------------------|
| 999999 | 999.999.999,99 |     X     |     99/99/99     |    999.999.999,99   |
| 999999 | 999.999.999,99 |     X     |     99/99/99     |    999.999.999,99   |
| 999999 | 999.999.999,99 |     X     |     99/99/99     |    999.999.999,99   |
| 999999 | 999.999.999,99 |     X     |     99/99/99     |    999.999.999,99   |
| 999999 | 999.999.999,99 |     X     |     99/99/99     |    999.999.999,99   |
| 999999 | 999.999.999,99 |     X     |     99/99/99     |    999.999.999,99   |
| 999999 | 999.999.999,99 |     X     |     99/99/99     |    999.999.999,99   |
| 999999 | 999.999.999,99 |     X     |     99/99/99     |    999.999.999,99   |
| 999999 | 999.999.999,99 |     X     |     99/99/99     |    999.999.999,99   |
| 999999 | 999.999.999,99 |     X     |     99/99/99     |    999.999.999,99   |
--------------------------------------------------------------------------------
*/

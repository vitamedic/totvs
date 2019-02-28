/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT208   ³ Autor ³ Gardenia ILany          Data ³ 27/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao de Faturas e Notas                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


#include "rwmake.ch"
#include "topconn.ch"

user function VIT208()
nordem   :=""
tamanho  :="M"
limite   :=132
titulo   :="IMPRESSAO DE NOTAS /FATURAS A RECEBER "
cdesc1   :="Este programa ira emitir as faturas e as notas"
cdesc2   :=""
cdesc3   :=""
cstring  :="SE1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT208"
wnrel    :="VIT208"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT208"
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
li    :=132
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

//setprc(0,0)
//@ 000,000 PSAY avalimp(limite)
//@ 000,000 PSAY chr(18)

cabec1:="Periodo:"+dtoc(mv_par05)+ " a " +dtoc(mv_par06)
cabec2:="CLIENTE   NOME CLIENTE                             PRF FATURA EMISSAO         VALOR"
//CLIENTE   NOME CLIENTE                             PRF FATURA EMISSAO         VALOR
//999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX 999999 99/99/99 9.999.999,99
//TITULOS: XXX-999999-9 99/99/99 9.999.999,99 



setprc(0,0)
   

tmp1->(dbgotop())
while ! tmp1->(eof()) .and.;
	lcontinua
  	if prow()==0 .or. prow()>54
		cabec(titulo,cabec1,cabec2,wnrel,tamanho,18)
	endif
	sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
	_cprefixo:=tmp1->prefixo
	_cnumero :=tmp1->numero
	_demissao :=tmp1->emissao
	_nvalor  :=0
	_aduplic :={}
	_anotas  :={}
	_nlin:=0
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
		_cquery+="     SE1.D_E_L_E_T_<>'*'"
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
//999999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX 999999 99/99/99 9.999.999,99
	@ prow()+1,00   PSAY sa1->a1_cod+"-"+sa1->a1_loja+ " "+sa1->a1_nome
	@ prow(),51 PSAY _cprefixo
	@ prow(),55 PSAY _cnumero 
	@ prow(),62 PSAY _demissao
	@ prow(),71 PSAY _nvalor picture "@E 9,999,999.99"
	@ prow()+1,00 PSAY "PARCELAS:" 
	_ncol:=12
	_j2:=0
	for _j:=1 to len(_aduplic)
		@ prow(),_ncol PSAY _aduplic[_j,1]
		@ prow(),_ncol+2 PSAY _aduplic[_j,2]
		@ prow(),_ncol+14 PSAY _aduplic[_j,3] picture "@E 9,999,999.99"
		_ncol+=30
		if _j==3 .or. _j==_j2
			_j2:=_j+3
			_ncol:=12
			if  _j <> len(_aduplic)
				@ prow()+1,00 PSAY ' '
			endif	
		endif	
	next          
	@ prow()+1,00 PSAY "NOTAS...:" 
	_ncol:=12
	_j2:=0
	for _j:=1 to len(_anotas)
		@ prow(),_ncol PSAY _anotas[_j,1]
		@ prow(),_ncol+14 PSAY _anotas[_j,2] picture "@E 9,999,999.99"
		_ncol+=30
		if _j==3 .or. _j==_j2
			_j2:=_j+3
			_ncol:=12
			@ prow()+1,00 PSAY ' '
		endif	
	next       
	@ prow()+1,00 PSAY ' '
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end

tmp1->(dbclosearea())
set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
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
_cquery+=" AND E1_CLIENTE  BETWEEN '"+mv_par07+"' AND '"+mv_par09+"'"
_cquery+=" AND E1_LOJA  BETWEEN '"+mv_par08+"' AND '"+mv_par10+"'"
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
aadd(_agrpsx1,{cperg,"03","Do numero          ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate o numero       ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da emissao         ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate a emissao      ?","mv_ch6","D",08,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do cliente         ?","mv_ch7","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"08","Da loja            ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Ate cliente        ?","mv_ch9","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA1"})
aadd(_agrpsx1,{cperg,"10","Ate a loja         ?","mv_chA","C",02,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

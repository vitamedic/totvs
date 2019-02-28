/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT031   ³ Autor ³ Heraildo C. de Freitas³ Data ³ 21/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao dos Boletos                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit031()
cbtxt    :=""
cbcont   :=""
tamanho  :="P"
titulo   :="Boletos Bancarios"
cdesc1   :="Este programa ira emitir os boletos bancarios"
cdesc2   :="conforme parametros especificados pelo usuario."
cdesc3   :=""
cstring  :="SE1"
areturn  :={"Especial",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT031"
nlastkey :=0 
lcontinua:=.t.
wnrel    :="VIT031"+Alltrim(cusername)

cperg    :="PERGVIT031"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)
if lastkey()==27 .or. nlastkey==27
   return
endif
setdefault(areturn,cstring)
if lastkey()==27 .or. nlastkey==27
   return
endif

rptstatus({|| rptdetail()})
return

static function rptdetail()
_cfilsa1:=xfilial("SA1")
_cfilse1:=xfilial("SE1")
sa1->(dbsetorder(1))
se1->(dbsetorder(1))

processa({|| _geratmp()})

setregua(se1->(lastrec()))

setprc(0,0)

tmp1->(dbgotop())
while ! tmp1->(eof())
	incregua()
	sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))
	if mv_par09=="001" // BANCO DO BRASIL
		@ 000,000 PSAY chr(27)+chr(48)
		@ 000,000 PSAY chr(27)+"C"+chr(32)
		@ 000,000 PSAY chr(18)
		@ prow()+2,052 PSAY tmp1->vencto
		@ prow()+4,000 PSAY tmp1->emissao
		@ prow(),010   PSAY tmp1->prefixo+tmp1->numero+tmp1->parcela
		@ prow(),039   PSAY ddatabase
		@ prow()+2,050 PSAY tmp1->valor picture "@E 999,999,999.99"
		@ prow()+4,000 PSAY "Apos vencimento cobrar juros de 10% ao mes"
		@ prow()+2,000 PSAY "Nao receber o principal sem os encargos de mora"
		@ prow()+2,000 PSAY "Caso esta duplicata esteja paga, favor"
		@ prow()+1,000 PSAY "desconsiderar a mesma."
		@ prow()+3,005 PSAY tmp1->cliente+"/"+tmp1->loja+"-"+sa1->a1_nome
		@ prow()+1,005 PSAY sa1->a1_end
		@ prow()+1,005 PSAY sa1->a1_cep+" "+alltrim(sa1->a1_bairro)+" "+alltrim(sa1->a1_mun)+" "+sa1->a1_est
		@ prow()+1,010 PSAY sa1->a1_cgc picture if(len(alltrim(sa1->a1_cgc))==11,"@R 999.999.999-99","@R 99.999.999/9999-99")
		@ prow(),pcol() PSAY chr(27)+chr(50)
		@ prow(),pcol() PSAY chr(27)+"C"+chr(66)
		@ prow(),pcol() PSAY chr(27)+chr(64)
	endif
	eject
	tmp1->(dbskip())
end

set device to screen

tmp1->(dbclosearea())

if areturn[5]==1
   set printer tO 
   dbcommitall()
   ourspool(wnrel)
endif
ms_flush()
return

static function _geratmp()
procregua(1)

incproc("Selecionando titulos...")
_cquery:=" SELECT"
_cquery+=" E1_PREFIXO PREFIXO,E1_NUM NUMERO,E1_PARCELA PARCELA,E1_TIPO TIPO,"
_cquery+=" E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_EMISSAO EMISSAO,E1_VENCTO VENCTO,"
_cquery+=" E1_VALOR VALOR"
_cquery+=" FROM "
_cquery+=  retsqlname("SE1")+" SE1"
_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
_cquery+=" AND E1_PREFIXO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND E1_NUM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND E1_PARCELA BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" ORDER BY E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
	
_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"
tcsetfield("TMP1","EMISSAO","D")
tcsetfield("TMP1","VENCTO" ,"D")
tcsetfield("TMP1","VALOR"  ,"N",12,2)
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da emissao         ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a emissao      ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Do prefixo         ?","mv_ch3","C",03,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate o prefixo      ?","mv_ch4","C",03,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Do titulo          ?","mv_ch5","C",06,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate o titulo       ?","mv_ch6","C",06,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Da parcela         ?","mv_ch7","C",01,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate a parcela      ?","mv_ch8","C",01,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do banco           ?","mv_ch9","C",03,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"BCO"})
	
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

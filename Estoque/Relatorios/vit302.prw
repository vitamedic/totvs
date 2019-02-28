/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT302   ³ Autor ³ Alex Junio de Miranda ³ Data ³ 19/02/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao das Etiquetas de Entrada de Materiais por Lote   ³±±
±±³          ³ para Etiquetas com Identificacao de Quarentena (1 Coluna)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vit302()
nordem   :=""
tamanho  :="P"
limite   :=080
titulo   :="ETIQUETAS DE ENTRADA DE MATERIAIS POR LOTE - 01 COLUNA"
cdesc1   :="Este programa ira emitir as etiquetas de entrada de materiais por lote."
cdesc2   :="Etiquetas com identificacao de Quarentena em 01 coluna."
cdesc3   :=""
cstring  :="SD1"
areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog :="VIT302"
wnrel    :="VIT302"+Alltrim(cusername)
alinha   :={}
nlastkey :=0
lcontinua:=.t.

cperg:="PERGVIT302"
_pergsx1()
pergunte(cperg,.f.)

wnrel:=setprint(cstring,wnrel,cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.t.)

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

_cfilsb1:=xfilial("SB1")
_cfilsd1:=xfilial("SD1")
_cfilsb8:=xfilial("SB8")
sb1->(dbsetorder(1))
sd1->(dbsetorder(6))
sb8->(dbsetorder(3))

setregua(sd1->(lastrec()))

setprc(0,0)
@ 000,000 PSAY chr(18)
sd1->(dbseek(_cfilsd1+dtos(mv_par01),.t.))
et_1:=.t.

while ! sd1->(eof()) .and.;
		sd1->d1_filial==_cfilsd1 .and.;
		sd1->d1_dtdigit<=mv_par02 .and.;
		lcontinua
	incregua()
	if ! empty(sd1->d1_lotectl) .and.;
		sd1->d1_tipo=="N" .and.;
		sd1->d1_doc>=mv_par03 .and.;
		sd1->d1_doc<=mv_par04 .and.;
		sd1->d1_serie>=mv_par05 .and.;
		sd1->d1_serie<=mv_par06 .and.;
		sd1->d1_cod>=mv_par07 .and.;
		sd1->d1_cod<=mv_par08 .and.;
		sd1->d1_lotectl>=mv_par09 .and.;
		sd1->d1_lotectl<=mv_par10
		sd1->d1_numvol>0 
		
		sb1->(dbseek(_cfilsb1+sd1->d1_cod))          
		sb8->(dbseek(_cfilsb8+sd1->d1_cod+sb1->b1_locpad+sd1->d1_lotectl,.t.))		
		
		if sb1->b1_locpad="02"
			_clinha1:="MATERIA PRIMA"
		else
			_clinha1:="MATERIAL DE EMBALAGEM"
		endif                                 
		
		_clinha2:=alltrim(sd1->d1_cod)+"-"+substr(sb1->b1_desc,1,31)
		_clinha3:="Nota: "+alltrim(sd1->d1_doc)+     "        "+"Entrada:"+dtoc(sd1->d1_dtdigit) 
		_clinha4:="Lote: "+alltrim(sd1->d1_lotectl)+ "    "	 +"Fabricacao:"+dtoc(sd1->d1_dtfabr) 
		if mv_par11=2 
			_clinha5:="Validade: "+dtoc(sd1->d1_dtvalid)+ "  "     +"Reanalise.:"+dtoc(sd1->d1_dtvalid-180) 
			_nnumvol:=sd1->d1_numvol
		else
			_clinha5:="Validade:"+dtoc(sb8->b8_dtvalid)+ "  "+"Reanalise.:"+dtoc(sb8->b8_dtvalid-180) 
			_nnumvol:=mv_par12
		endif

		_i:=1
	
		while _i<=_nnumvol		
			if et_1
				et_1:=.f.
				@ prow()+3,000  PSAY ""
			else
				@ prow()+9,000  PSAY ""				
			endif			
	
			@ prow(),002    PSAY _clinha1			
			if(_i<=_nnumvol)
 			   @ prow(),030 PSAY strzero(_i,3,0)+"/"+strzero(_nnumvol,3,0)
			endif			                 			
	
			@ prow()+1,002  PSAY _clinha2
			@ prow()+1,002  PSAY ""
			@ prow()+1,002  PSAY _clinha3
			@ prow()+1,002  PSAY _clinha4
			@ prow()+1,002  PSAY _clinha5
			@ prow()+4,000  PSAY " "  
			_i++
		end
	endif
	sd1->(dbskip())
	if labortprint
		@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
		lcontinua:=.f.
	endif
end

set device to screen

if areturn[5]==1
	set print to
	dbcommitall()
	ourspool(wnrel)
endif
ms_flush()
return

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Da data            ?","mv_ch1","D",08,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Ate a data         ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"03","Da nota fiscal     ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"04","Ate a nota fiscal  ?","mv_ch4","C",06,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"05","Da serie           ?","mv_ch5","C",03,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"06","Ate a serie        ?","mv_ch6","C",03,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"07","Do produto         ?","mv_ch7","C",15,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"08","Ate o produto      ?","mv_ch8","C",15,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"09","Do lote            ?","mv_ch9","C",10,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate o lote         ?","mv_cha","C",10,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Revalidacao        ?","mv_chb","N",01,0,0,"C",space(60),"mv_par11"       ,"Sim"            ,space(30),space(15),"Nao"            ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Qtde.Etiqueta      ?","mv_chc","N",06,0,0,"C",space(60),"mv_par12"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
	
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

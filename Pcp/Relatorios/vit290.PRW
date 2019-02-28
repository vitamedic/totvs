#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VIT290   ³Autor ³ Aline B.Pereira       ³Data ³ 31/01/07   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ordem de Beneficiamento                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
user function Vit290(cOp,cItem)
titulo  := "ORDEM DE BENEFICIAMENTO"
cdesc1  := "Este programa ira emitir a ORDEM DE BENEFICIAMENTO"
cdesc2  := ""
cdesc3  := ""
tamanho := "G"
limite  := 132
cstring :="SC2"
areturn :={"Zebrado",1,"Administracao",2,2,1,"",1}
nomeprog:="VIT290"
aLinha  :={}
nlastkey:=0
lcontinua:=.t.

mpag := 0
_nqtdparc:=0
_cumemp:='  '
_cum := '  '
_cperg:="PERGVIT290"

_pergsx1()
pergunte(_cperg,.f.)
wnrel:="PERGVIT290"+Alltrim(cusername)

if cOp == Nil
	wnrel:=setprint(cstring,wnrel,_cperg,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)
Else
	mv_par01 := cOp
	mv_par02 := cOp
	mv_par03 := cItem
	wnrel:=setprint(cstring,wnrel,     ,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.t.,tamanho,"",.f.)
EndIf

if nlastkey==27
	set filter to
	return
endif

setdefault(areturn,cstring)

ntipo := if(areturn[4]==1,15,18)

if nlastkey==27
	set filter to
	return
endif

rptstatus({|| rptdetail()})
return

//*******************************************
//Funcao RptDetail - Impressao do Relatorio
//*******************************************
Static  Function RptDetail()
cbcont := 0
m_pag  := 1
li     := 132
cbtxt  := space(10)

_cfilsb1:=xfilial("SB1")
_cfilsc2:=xfilial("SC2")
_cfilsd4:=xfilial("SD4")
_cfilsg1:=xfilial("SG1")
_cfilsdc:=xfilial("SDC")
_cfilqdh:=xfilial("QDH")

sb1->(dbsetorder(1))
sd4->(dbsetorder(2))
sdc->(dbsetorder(2))
sc2->(dbsetorder(1))
sg1->(dbsetorder(1))
qdh->(dbsetorder(1))

sc2->(dbseek(_cfilsc2+mv_par01,.t.))

while c2_filial ==_cfilsc2 .and. c2_num >=mv_par01 .and. c2_num <=mv_par02 .and. !eof()
	if sc2->c2_item <> mv_par03
		sc2->(dbskip())
		loop
	endif
	sb1->(dbseek(_cfilsb1+sc2->c2_produto))
	_cproduto:=sc2->c2_produto
	_cdesc:=sb1->b1_desc
	_cdesccien:= sb1->b1_desccie
	_nprvalid:=sb1->b1_prvalid
	_cum:=sb1->b1_um
	_capres:= sb1->b1_apres
	cop:=sc2->c2_num+mv_par03
	qdh->(dbseek(_cfilqdh+"OP-"+substr(sb1->b1_cod,1,13)))
	_ddata:= ctod(space(08))
	
	While (qdh->qdh_filial == _cfilqdh .and. qdh->qdh_docto == "OP-"+substr(sb1->b1_cod,1,13) .and. !qdh->(EOF()))
		if  qdh->qdh_obsol <> "S" .and. !Empty(qdh->qdh_dtvig)
			_ddata := qdh->qdh_dtvig
			_crev  := qdh->qdh_rv
		endif
		qdh->(DBSkip())
	EndDo
	
	impmat() // imprime materias primas
	sc2->(reclock("SC2",.f.))
	sc2->(msunlock())
	sc2->(dbskip())
end

Set Device To Screen

If (aReturn[5]==1)
	Set Print to
	dbCommitall()
	ourspool(wnrel)
EndIf

MS_Flush()
Return

Static Function impmat()
sd4->(dbseek(_cfilsd4+cop,.t.))
mfirst := .t.
cab290()

sd4->(dbseek(_cfilsd4+cop,.t.))
//  I- SEPARAÇÃO E ENVIO "

@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "|  I- SEPARAÇÃO E ENVIO                                                                                                                 |"
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "| Codigo| Material                                |Endereco  |         Requerido|UM|Lote      | Qtde    |Separador|Conferente  |Data    |"
@ prow()+1,000 PSAY "|       |                                         |          |                  |  |          | Separada|         |            |        |"
@ prow()+1,000 PSAY "|-------|-----------------------------------------|----------|------------------|--|----------|---------|---------|------------|--------|"

while ! sd4->(eof()) .and. sd4->d4_filial==_cfilsd4 .and.;
	left(sd4->d4_op,8)==cop
	if !(sd4->d4_local $ "01#91#80")
		sb1->(dbseek(_cfilsb1+sd4->d4_cod))
		sdc->(dbseek(_cfilsdc+sd4->d4_cod+sd4->d4_local+sd4->d4_op+sd4->d4_trt+sd4->d4_lotectl))
		_nqtdparc:=_nqtdparc+sd4->d4_qtdeori
		_cumemp:=sb1->b1_um
		@ prow()+1, 000 PSAY "|"
		@ prow(),001 PSAY left(sd4->d4_cod,6)
		@ prow(),008 PSAY "|"
		@ prow(),010 PSAY sb1->b1_desc
		@ prow(),050 PSAY "|"
		@ prow(),051 PSAY substr(sdc->dc_localiz,1,10)
		@ prow(),061 PSAY "|"
		@ prow(),062 PSAY sd4->d4_qtdeori picture "@E 999,999,999.999999"
		@ prow(),080 PSAY "|"
		@ prow(),081 PSAY _cumemp
		@ prow(),083 PSAY "|"
		@ prow(),084 PSAY sd4->d4_lotectl
		@ prow(),094 PSAY "|         |         |            |        |"
		@ prow()+1,000 PSAY "|-------|-----------------------------------------|----------|------------------|--|----------|---------|---------|------------|--------|"
		if prow()> 60
			cab290()
		endif
	endif
	
	sd4->(dbskip())
end
If prow() > 46
	cab290()
	rodapg()
endif

// II - RECEBIMENTO E ENTRADA
if prow() >46
	cab290()
endif
@ prow()+3,000 PSAY "|---------------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "|  II- RECEBIMENTO E ENTRADA                                                                                                            |"
@ prow()+1,000 PSAY "|---------------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,000 PSAY "| Codigo| Material                                |Qtde.Teorica |UM|Lote      | Qtde    |UN|Responsavel                        |Data    |"
@ prow()+1,000 PSAY "|       |                                         |             |  |          | Recebida|  |                                   |        |"
@ prow()+1,000 PSAY "|-------|-----------------------------------------|-------------|--|----------|---------|--|-----------------------------------|--------|"

sb1->(dbseek(_cfilsb1+sd4->d4_cod))
@ prow()+1, 000 PSAY "|"
@ prow(),001 PSAY left(sc2->c2_produto,6)
@ prow(),008 PSAY "|"
@ prow(),010 PSAY _cdesc
@ prow(),050 PSAY "|"
@ prow(),051 PSAY  transform(sc2->c2_quant,"@E 999,999")
@ prow(),064 PSAY "|"
@ prow(),065 PSAY  _cum
@ prow(),067 PSAY "|"
@ prow(),078 PSAY "|         |  |                                   |        |"
@ prow()+1,000 PSAY "|-------|-----------------------------------------|-------------|--|----------|---------|--|-----------------------------------|--------|"

if prow()> 60 .and.! sd4->(eof())
	cab290()
endif

/*
while ! sd4->(eof()) .and. sd4->d4_filial==_cfilsd4 .and.;
left(sd4->d4_op,8)==cop
if !(sd4->d4_local $ "01#91#80")
sb1->(dbseek(_cfilsb1+sd4->d4_cod))
sdc->(dbseek(_cfilsdc+sd4->d4_cod+sd4->d4_local+sd4->d4_op+sd4->d4_trt+sd4->d4_lotectl))
_nqtdparc:=_nqtdparc+sd4->d4_qtdeori
_cumemp:=sb1->b1_um
@ prow()+1, 000 PSAY "|"
@ prow(),001 PSAY left(sc2->c2_produto,6)
@ prow(),008 PSAY "|"
@ prow(),010 PSAY _cdesc
@ prow(),050 PSAY "|"
@ prow(),051 PSAY  transform(sc2->c2_quant,"@E 999,999")
@ prow(),064 PSAY "|"
@ prow(),065 PSAY  _cum
@ prow(),067 PSAY "|"
@ prow(),078 PSAY "|         |  |                                   |        |"
@ prow()+1,000 PSAY "|-------|-----------------------------------------|-------------|--|----------|---------|--|-----------------------------------|--------|"

if prow()> 60 .and.! sd4->(eof())
cab290()
endif
endif
sd4->(dbskip())
end
*/
@ prow()+2,00 PSAY " Amostra para CQ: (  )Sim   (  )Nao     Enviada  por: ______________________  Data:___/___/___"
@ prow()+1,00 PSAY "                                                                                              "
@ prow()+1,00 PSAY "                                        Recebida por: ______________________  Data:___/___/___"

return

Static function rodapg()
@ prow()+1,000 PSAY "|-------|-----------------------------------------|----------|------------------|--|----------|---------|---------|------------|--------|"

@ prow()+1,00 PSAY "|----------------------------------------------------------------------------------------------------------------------------------------|"
@ prow()+1,00 PSAY "|                                                          |                           |                                                 |"
@ prow()+1,00 PSAY "|Remetido por:__________________________   Data:___/___/___|NF(s):____________________ | _______________________________________________ |"
@ prow()+1,00 PSAY "|                                                          |                           |                                                 |"
@ prow()+1,00 PSAY "|Separado por:__________________________   Data:___/___/___|__________________________ | _______________________________________________ |"
@ prow()+1,00 PSAY "|                                                          |                           |                                                 |"
@ prow()+1,00 PSAY "|Pesado por  :__________________________   Data:___/___/___|__________________________ | _______________________________________________ |"
@ prow()+1,00 PSAY "|                                                          |                           |  GQL                                            |"
@ prow()+1,00 PSAY "|                                                          |___________________________|_________________________________________________|"
@ prow()+1,00 PSAY "|Observacoes:______________________________________________________________________________________________ |"
@ prow()+1,00 PSAY "|                                                                                                           |"
@ prow()+1,00 PSAY "|___________________________________________________________________________________________________________|"
@ prow()+1,00 PSAY "|                                                                                                           |"
@ prow()+1,00 PSAY "|___________________________________________________________________________________________________________|"
return


Static function cab290()
if mfirst
	setprc(0,0)
	mpag:=1
	mfirst:=.f.
else
	mpag:=mpag+1
endif
@ 000,000 PSAY avalimp(132)
@ 000,000 PSAY ' '
@ prow()+1,000 PSAY replicate("_",132)
@ prow()+1,000 PSAY "Vitamedic Industria Farmaceutica Ltda."
@ prow()  ,123 PSAY "Pag.: "+strzero(mpag,3,0)
@ prow()+1,000 PSAY "Produto.: "+left(sc2->c2_produto,6)+"-"+_cdesc  + "   Lote Nº...: "+sc2->c2_lotectl  + "             Validade....: "+strzero((_nprvalid/365)*12,2,0) +" meses"
if Empty(_ddata)
	@ prow()+1,000 PSAY "D.Quimica: "+substr(_cdesccien,1,49)+"Revisao:                           Data Revisao:   /   /   "
else
	@ prow()+1,000 PSAY "D.Quimica: "+substr(_cdesccien,1,49)+"Revisao: "+_crev+"                       Data Revisao: "+dtoc(_ddata)
endif
@ prow()+1,000 PSAY "Apresent:"+substr(_capres,1,50) + "           Emissao OP: "+dtoc(sc2->c2_emissao) +"               Qtde.Teorica: "+ transform(sc2->c2_quant,"@E 999,999") +" "+ _cum
@ prow()+2,060 PSAY "ORDEM DE BENEFICIAMENTO"
@ prow()+1,000 PSAY replicate("_",132)
@ prow()+1,000 PSAY " "
return

/*
|---------------------------------------------------------------------------------------------|
|                                   REQUISICAO DE MATERIA PRIMA                               |
|---------------------------------------------------------------------------------------------|
| Codigo| Materia Prima                            |Endereco |Peso Balanca      |UM|Lote      |
|---------------------------------------------------------------------------------------------|
| 999999|-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |         |999.999.999,999999|xx |999999   |
|---------------------------------------------------------------------------------------------|
|                                                          |                                  |
|Remetido por:__________________________   Data:___/___/___|                                  |
|                                                          |                                  |
|Separado por:__________________________   Data:___/___/___|                                  |
|                                                          |                                  |
|Pesado por  :__________________________   Data:___/___/___|                                  |
|                                                          |__________________________________|
|Material recebido na producao                             |DCQ:                              |
|                                                          |                                  |
|Conferido por:_________________________   Data:___/___/___|__________________________________|
|                                                                                             |
|Observacoes:_________________________________________________________________________________|
|                                                                                             |
|_____________________________________________________________________________________________|
|                                                                                             |
|_____________________________________________________________________________________________|



|-------------------------------------------------------------------------------------------------------------------|
| 						    	      	REQUISICAO DE MATERIAL DE EMBALAGEM                                                |
|-------------------------------------------------------------------------------------------------------------------|        |
| Codigo| Material                                |Endereco |UM |Lote     |Separador          |Conferente  |Data    |
|-------------------------------------------------|---------|---|---------|-------------------|------------|--------|
| 999999|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |         |XX |999999   |                   |            |99/99/99|
|-------------------------------------------------------------------------------------------------------------------|        |



|---------------------------------------------------------------------------------------------|
|                                   CONFERENCIA DE PESAGEM DE MATERIA PRIMA                   |
|---------------------------------------------------------------------------------------------|
| Codigo| Materia Prima                            |Endereco |Peso Balanca      |UM |Lote     |
|---------------------------------------------------------------------------------------------|
| 999999|-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX |         |                  |xx |999999   |
|---------------------------------------------------------------------------------------------|


*/

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Da OP              ?","mv_ch1","C",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate a OP           ?","mv_ch2","C",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Item               ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

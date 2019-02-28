/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT311   ³ Autor ³ Heraildo C. Freitas   ³ Data ³ 25/04/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Etiquetas Avulsas para Inventario                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit311()
cperg:="PERGVIT311"
_pergsx1()
if pergunte(cperg,.t.)
 
	processa({|| imprime()})
	
endif
return()

static function imprime()
_cfilsb1:=xfilial("SB1")

_ccq:=getmv("MV_CQ")

procregua(0)

incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B1_COD,"
_cquery+=" B1_DESC,"
_cquery+=" B1_TIPO,"
_cquery+=" B1_GRUPO"

_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1"

_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_=' '"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"

_cquery+=" ORDER BY"
if mv_par08==1
	_cquery+=" B1_COD"
elseif mv_par08==2
	_cquery+=" B1_DESC,B1_COD"
elseif mv_par08==3
	_cquery+=" B1_TIPO,B1_DESC,B1_COD"
else
	_cquery+=" B1_GRUPO,B1_DESC,B1_COD"
endif

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
u_setfield("TMP1")

arial8 :=tfont():new("Arial",,8,,.f.)
arial8n:=tfont():new("Arial",,8,,.t.)

oprn:=tmsprinter():new()
oprn:setportrait()
oprn:setup()

_nform:=mv_par07

tmp1->(dbgotop())
while ! tmp1->(eof())
	
	incproc("Imprimindo...")
	
	_nform1   :=_nform
	_nform2   :=_nform+1
	_cproduto1:=tmp1->b1_cod
	tmp1->(dbskip())
	if ! tmp1->(eof())
		_cproduto2:=tmp1->b1_cod
		tmp1->(dbskip())
	else
		_cproduto2:=""
	endif
	
	oprn:startpage()
	
	for _ne:=1 to 2
		sb1->(dbsetorder(1))
		if _ne==1
			sb1->(dbseek(_cfilsb1+_cproduto1))
			_nc:=20
		else
			sb1->(dbseek(_cfilsb1+_cproduto2))
			_nc:=1220
		endif
		
		_nl:=20
		oprn:box(_nl,_nc,_nl+40,_nc+1120)
		_nl+=5
		oprn:say(_nl,_nc+410,"Cadastro",arial8n)
		_nl+=35
		oprn:box(_nl,_nc,_nl+120,_nc+1120)
		_nl+=5
		oprn:say(_nl,_nc+5,"Código: "+alltrim(sb1->b1_cod)+"   Tipo: "+sb1->b1_tipo+"   Grupo: "+sb1->b1_grupo+"   Unidade: "+sb1->b1_um,arial8n)
		_nl+=40
		oprn:say(_nl,_nc+5,"Descrição: "+alltrim(sb1->b1_desc),arial8n)
		_nl+=40
		oprn:say(_nl,_nc+5,"Endereço: ",arial8n)
	next
	_nl+=95
	
	for _ni:=3 to 1 step -1
		for _ne:=1 to 2
			sb1->(dbsetorder(1))
			if _ne==1
				sb1->(dbseek(_cfilsb1+_cproduto1))
				_nc:=20
			else
				sb1->(dbseek(_cfilsb1+_cproduto2))
				_nc:=1220
			endif
			
			_nla:=_nl
			oprn:box(_nla,_nc,_nla+40,_nc+1120)
			_nla+=5
			oprn:say(_nla,_nc+5,"Contagem: "+strzero(_ni,6),arial8n)
			oprn:say(_nla,_nc+1115,"Formulário: "+strzero(if(_ne==1,_nform1,_nform2),6),arial8n,,,,1)
			_nla+=35
			oprn:box(_nla,_nc,_nla+120,_nc+1120)
			_nla+=5
			oprn:say(_nla,_nc+5,"Código: "+alltrim(sb1->b1_cod)+"   Tipo: "+sb1->b1_tipo+"   Grupo: "+sb1->b1_grupo+"   Unidade: "+sb1->b1_um,arial8n)
			_nla+=40
			oprn:say(_nla,_nc+5,"Descrição: "+alltrim(sb1->b1_desc),arial8n)
			_nla+=40
			oprn:say(_nla,_nc+5,"Endereço: ",arial8n)
			_nla+=35
			
			for _nk:=1 to 16
				_nca:=_nc
				oprn:box(_nla,_nca,_nla+40,_nca+200)
				if _nk==1
					oprn:say(_nla+5,_nca+50,"Lote",arial8n)
				endif
				_nca+=200
				oprn:box(_nla,_nca,_nla+40,_nca+200)
				if _nk==1
					oprn:say(_nla+5,_nca+40,"Validade",arial8n)
				endif
				_nca+=200
				oprn:box(_nla,_nca,_nla+40,_nca+170)
				if _nk==1
					oprn:say(_nla+5,_nca+15,"Armazém",arial8n)
				endif
				_nca+=170
				oprn:box(_nla,_nca,_nla+40,_nca+550)
				if _nk==1
					oprn:say(_nla+5,_nca+150,"Quantidade",arial8n)
				endif
				_nla+=40
			next
			oprn:box(_nla,_nc,_nla+200,_nc+1120)
			_nla+=40
			oprn:say(_nla,_nc+5,"Quantidade apurada: ______________________________",arial8n)
			_nla+=80
			oprn:say(_nla,_nc+5,"_____________________________",arial8n)
			oprn:say(_nla,_nc+700,"_____________________",arial8n)
			_nla+=40
			oprn:say(_nla,_nc+5,"          Visto funcionário",arial8n)
			oprn:say(_nla,_nc+700,"     Grupo conferente",arial8n)
		next
		_nl+=(_nla-_nl)+100
	next
	
	_nform+=2
	
	oprn:endpage()
	
	tmp1->(dbskip())
end
tmp1->(dbclosearea())

oprn:preview()
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Do produto                   ?","mv_ch1","C",15,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"02","Ate o produto                ?","mv_ch2","C",15,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SB1"})
aadd(_agrpsx1,{cperg,"03","Do tipo                      ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"04","Ate o tipo                   ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"02 "})
aadd(_agrpsx1,{cperg,"05","Do grupo                     ?","mv_ch5","C",04,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"06","Ate o grupo                  ?","mv_ch6","C",04,0,0,"G",space(60),"mv_par06"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SBM"})
aadd(_agrpsx1,{cperg,"07","Numero do primeiro formulario?","mv_ch7","N",06,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ordem                        ?","mv_ch8","N",01,0,0,"C",space(60),"mv_par08"       ,"Codigo"         ,space(30),space(15),"Descricao"      ,space(30),space(15),"Tipo+Descricao" ,space(30),space(15),"Grupo+Descricao",space(30),space(15),space(15)        ,space(30),"   "})

for _ni:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_ni,1]+_agrpsx1[_ni,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_ni,01]
		sx1->x1_ordem  :=_agrpsx1[_ni,02]
		sx1->x1_pergunt:=_agrpsx1[_ni,03]
		sx1->x1_variavl:=_agrpsx1[_ni,04]
		sx1->x1_tipo   :=_agrpsx1[_ni,05]
		sx1->x1_tamanho:=_agrpsx1[_ni,06]
		sx1->x1_decimal:=_agrpsx1[_ni,07]
		sx1->x1_presel :=_agrpsx1[_ni,08]
		sx1->x1_gsc    :=_agrpsx1[_ni,09]
		sx1->x1_valid  :=_agrpsx1[_ni,10]
		sx1->x1_var01  :=_agrpsx1[_ni,11]
		sx1->x1_def01  :=_agrpsx1[_ni,12]
		sx1->x1_cnt01  :=_agrpsx1[_ni,13]
		sx1->x1_var02  :=_agrpsx1[_ni,14]
		sx1->x1_def02  :=_agrpsx1[_ni,15]
		sx1->x1_cnt02  :=_agrpsx1[_ni,16]
		sx1->x1_var03  :=_agrpsx1[_ni,17]
		sx1->x1_def03  :=_agrpsx1[_ni,18]
		sx1->x1_cnt03  :=_agrpsx1[_ni,19]
		sx1->x1_var04  :=_agrpsx1[_ni,20]
		sx1->x1_def04  :=_agrpsx1[_ni,21]
		sx1->x1_cnt04  :=_agrpsx1[_ni,22]
		sx1->x1_var05  :=_agrpsx1[_ni,23]
		sx1->x1_def05  :=_agrpsx1[_ni,24]
		sx1->x1_cnt05  :=_agrpsx1[_ni,25]
		sx1->x1_f3     :=_agrpsx1[_ni,26]
		sx1->(msunlock())
	endif
next
return()

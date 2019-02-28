/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT312   ³ Autor ³ Heraildo C. Freitas   ³ Data ³ 01/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Etiquetas em Branco para Inventario                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "rwmake.ch"
#include "topconn.ch"

user function vit312()
cperg:="PERGVIT312"
_pergsx1()
if pergunte(cperg,.t.)
	
	processa({|| imprime()})
	
endif
return()

static function imprime()
procregua(0)

arial8 :=tfont():new("Arial",,8,,.f.)
arial8n:=tfont():new("Arial",,8,,.t.)

oprn:=tmsprinter():new()
oprn:setportrait()
oprn:setup()

_nform:=mv_par02
_npaginas:=round(mv_par01/2,0)

for _np:=1 to _npaginas
	
	incproc("Imprimindo...")
	
	_nform1:=_nform
	_nform2:=_nform+1
	
	oprn:startpage()
	
	for _ne:=1 to 2
		if _ne==1
			_nc:=20
		else
			_nc:=1220
		endif
		
		_nl:=20
		oprn:box(_nl,_nc,_nl+40,_nc+1120)
		_nl+=5
		oprn:say(_nl,_nc+410,"Cadastro",arial8n)
		_nl+=35
		oprn:box(_nl,_nc,_nl+120,_nc+1120)
		_nl+=5
		oprn:say(_nl,_nc+5,"Código: ____________   Tipo: ____   Grupo: ________   Unidade: ____",arial8n)
		_nl+=40
		oprn:say(_nl,_nc+5,"Descrição: ______________________________",arial8n)
		_nl+=40
		oprn:say(_nl,_nc+5,"Endereço: ",arial8n)
	next
	_nl+=95
	
	for _ni:=3 to 1 step -1
		for _ne:=1 to 2
			if _ne==1
				_nc:=20
			else
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
			oprn:say(_nla,_nc+5,"Código: ____________   Tipo: ____   Grupo: ________   Unidade: ____",arial8n)
			_nla+=40
			oprn:say(_nla,_nc+5,"Descrição: ______________________________",arial8n)
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
	
next

oprn:preview()
return()

static function _pergsx1()
_agrpsx1:={}
aadd(_agrpsx1,{cperg,"01","Quantidade de etiquetas      ?","mv_ch1","N",06,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"02","Numero do primeiro formulario?","mv_ch2","N",06,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

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

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT310   ³ Autor ³ Heraildo C. Freitas   ³ Data ³ 25/04/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Etiquetas para Inventario                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit310()
cperg:="PERGVIT310"
_pergsx1()
if pergunte(cperg,.t.)

	processa({|| imprime()})
	
endif
return()

static function imprime()
_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsb8:=xfilial("SB8")

_ccq:=getmv("MV_CQ")

procregua(0)

incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B2_COD,"
_cquery+=" B1_DESC,"
_cquery+=" B2_LOCAL,"
_cquery+=" B1_TIPO,"
_cquery+=" B1_GRUPO,"
_cquery+=" B2_QATU"

_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SB2")+" SB2"

_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_=' '"
_cquery+=" AND SB2.D_E_L_E_T_=' '"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B2_FILIAL='"+_cfilsb2+"'"
_cquery+=" AND B2_COD=B1_COD"
_cquery+=" AND B2_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND B2_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND B2_LOCAL<>'"+_ccq+"'"
_cquery+=" AND B2_QATU<>0"
_cquery+=" AND B1_RASTRO<>'L'"

_cquery+=" ORDER BY"
if mv_par12==1
	_cquery+=" B2_COD,B2_LOCAL"
elseif mv_par12==2
	_cquery+=" B1_DESC,B2_COD,B2_LOCAL"
elseif mv_par12==3
	_cquery+=" B1_TIPO,B1_DESC,B2_COD,B2_LOCAL"
else
	_cquery+=" B1_GRUPO,B1_DESC,B2_COD,B2_LOCAL"
endif

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP1"
u_setfield("TMP1")

incproc("Selecionando produtos...")
_cquery:=" SELECT"
_cquery+=" B8_PRODUTO,"
_cquery+=" B1_DESC,"
_cquery+=" B8_LOCAL,"
_cquery+=" B8_LOTECTL,"
_cquery+=" B8_DTVALID,"
_cquery+=" B1_TIPO,"
_cquery+=" B1_GRUPO,"
_cquery+=" SUM(B8_SALDO) B8_SALDO"

_cquery+=" FROM "
_cquery+=  retsqlname("SB1")+" SB1,"
_cquery+=  retsqlname("SB8")+" SB8"

_cquery+=" WHERE"
_cquery+="     SB1.D_E_L_E_T_=' '"
_cquery+=" AND SB8.D_E_L_E_T_=' '"
_cquery+=" AND B1_FILIAL='"+_cfilsb1+"'"
_cquery+=" AND B8_FILIAL='"+_cfilsb8+"'"
_cquery+=" AND B8_PRODUTO=B1_COD"
_cquery+=" AND B8_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
_cquery+=" AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cquery+=" AND B1_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cquery+=" AND B8_LOCAL BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
_cquery+=" AND B8_LOTECTL BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
_cquery+=" AND B8_LOCAL<>'"+_ccq+"'"
_cquery+=" AND B8_SALDO<>0"
_cquery+=" AND B1_RASTRO='L'"

_cquery+=" GROUP BY"
_cquery+=" B8_PRODUTO,B1_DESC,B8_LOCAL,B8_LOTECTL,B8_DTVALID,B1_TIPO,B1_GRUPO"

_cquery+=" ORDER BY"
if mv_par12==1
	_cquery+=" B8_PRODUTO,B8_LOCAL,B8_LOTECTL"
elseif mv_par12==2
	_cquery+=" B1_DESC,B8_PRODUTO,B8_LOCAL,B8_LOTECTL"
elseif mv_par12==3
	_cquery+=" B1_TIPO,B1_DESC,B8_PRODUTO,B8_LOCAL,B8_LOTECTL"
else
	_cquery+=" B1_GRUPO,B1_DESC,B8_PRODUTO,B8_LOCAL,B8_LOTECTL"
endif

_cquery:=changequery(_cquery)

tcquery _cquery new alias "TMP2"
u_setfield("TMP2")

arial8 :=tfont():new("Arial",,8,,.f.)
arial8n:=tfont():new("Arial",,8,,.t.)

oprn:=tmsprinter():new()
oprn:setportrait()
oprn:setup()

_nform:=mv_par11

tmp1->(dbgotop())
while ! tmp1->(eof())
	
	incproc("Imprimindo...")
	
	_nform1   :=_nform
	_nform2   :=_nform+1
	_cproduto1:=""
	_cproduto2:=""
	_aarm1    :={}
	_aarm2    :={}
	for _ne:=1 to 2
		if _ne==1
			_cproduto1:=tmp1->b2_cod
		else
			_cproduto2:=tmp1->b2_cod
		endif
		
		_cproduto:=tmp1->b2_cod
		while ! tmp1->(eof()) .and.;
			tmp1->b2_cod==_cproduto
			
			if _ne==1
				aadd(_aarm1,tmp1->b2_local)
			else
				aadd(_aarm2,tmp1->b2_local)
			endif
			
			tmp1->(dbskip())
		end
	next
	
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
			
			_na:=1
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
				elseif _na<=len(if(_ne==1,_aarm1,_aarm2))
					oprn:say(_nla+5,_nca+60,if(_ne==1,_aarm1[_na],_aarm2[_na]),arial8n)
					_na++
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

tmp2->(dbgotop())
while ! tmp2->(eof())
	
	incproc("Imprimindo...")
	
	_nform1   :=_nform
	_nform2   :=_nform+1
	_cproduto1:=""
	_cproduto2:=""
	_alote1   :={}
	_alote2   :={}
	for _ne:=1 to 2
		if _ne==1
			_cproduto1:=tmp2->b8_produto
		else
			_cproduto2:=tmp2->b8_produto
		endif
		
		_cproduto:=tmp2->b8_produto
		while ! tmp2->(eof()) .and.;
			tmp2->b8_produto==_cproduto
			
			if _ne==1
				aadd(_alote1,{tmp2->b8_lotectl,tmp2->b8_dtvalid,tmp2->b8_local})
			else
				aadd(_alote2,{tmp2->b8_lotectl,tmp2->b8_dtvalid,tmp2->b8_local})
			endif
			
			tmp2->(dbskip())
		end
	next
	
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
			
			_na:=1
			for _nk:=1 to 16
				_nca:=_nc
				oprn:box(_nla,_nca,_nla+40,_nca+200)
				if _nk==1
					oprn:say(_nla+5,_nca+50,"Lote",arial8n)
				elseif _na<=len(if(_ne==1,_alote1,_alote2))
					oprn:say(_nla+5,_nca+10,if(_ne==1,_alote1[_na,1],_alote2[_na,1]),arial8n)
				endif
				_nca+=200
				oprn:box(_nla,_nca,_nla+40,_nca+200)
				if _nk==1
					oprn:say(_nla+5,_nca+40,"Validade",arial8n)
				elseif _na<=len(if(_ne==1,_alote1,_alote2))
					oprn:say(_nla+5,_nca+20,dtoc(if(_ne==1,_alote1[_na,2],_alote2[_na,2])),arial8n)
				endif
				_nca+=200
				oprn:box(_nla,_nca,_nla+40,_nca+170)
				if _nk==1
					oprn:say(_nla+5,_nca+15,"Armazém",arial8n)
				elseif _na<=len(if(_ne==1,_alote1,_alote2))
					oprn:say(_nla+5,_nca+60,if(_ne==1,_alote1[_na,3],_alote2[_na,3]),arial8n)
					_na++
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
	
	tmp2->(dbskip())
end
tmp2->(dbclosearea())

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
aadd(_agrpsx1,{cperg,"07","Do armazem                   ?","mv_ch7","C",02,0,0,"G",space(60),"mv_par07"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"08","Ate o armazem                ?","mv_ch8","C",02,0,0,"G",space(60),"mv_par08"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"09","Do lote                      ?","mv_ch9","C",10,0,0,"G",space(60),"mv_par09"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"10","Ate o lote                   ?","mv_cha","C",10,0,0,"G",space(60),"mv_par10"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"11","Numero do primeiro formulario?","mv_chb","N",06,0,0,"G",space(60),"mv_par11"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{cperg,"12","Ordem                        ?","mv_chc","N",01,0,0,"C",space(60),"mv_par12"       ,"Codigo"         ,space(30),space(15),"Descricao"      ,space(30),space(15),"Tipo+Descricao" ,space(30),space(15),"Grupo+Descricao",space(30),space(15),space(15)        ,space(30),"   "})

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

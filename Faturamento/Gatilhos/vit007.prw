/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT007   ³ Autor ³ Heraildo C. de Freitas³ Data ³10/01/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gatilho no Codigo do Produto e na Quantidade Vendida       ³±±
±±³          ³ na Digitacao  de Pedidos de Venda para Atualizar o Valor   ³±±
±±³          ³ do Desconto do Item                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

// GATILHO NO CODIGO DO PRODUTO
user function vit007a()

_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))

sb1->(dbseek(_cfilsb1+m->c6_produto))

_cfilda0:=xfilial("DA0")
da0->(dbsetorder(1))
da0->(dbseek(_cfilda0+m->c5_tabela))

_ndescavi:=0
if sb1->b1_promoc=="M"
	if m->c5_condpag$"536/607/608/836/860/861"   // A VISTA
		if da0->da0_status$"L/R"
			_ndescavi:=3
		else
			_ndescavi:=5
		endif
	endif
	if m->c5_descit>sb1->b1_descmax
		_ndescont:=sb1->b1_descmax
	else
		_ndescont:=m->c5_descit
	endif
else
	if m->c5_condpag$"536/607/608/836/860/861" // A VISTA
		if sb1->b1_promoc$"PF" .and.;
			m->c5_promoc=="S"
			_ndescavi:=3
		else
			if da0->da0_status$"L/R"
				_ndescavi:=3
			else
				_ndescavi:=5
			endif
		endif
	endif
	if sb1->b1_promoc$"PF" .and.;
		m->c5_promoc=="S"
		_ndescont:=sb1->b1_descmax
	else
		_ndescont:=m->c5_descit
	endif
endif
_npprunit :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRUNIT"})
_npqtdven :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_QTDVEN"})
_npprcven :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRCVEN"})
_npvalor  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_VALOR"})
_npdescont:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_DESCPR"})

_nprunit :=acols[n,_npprunit]
_nqtdven :=acols[n,_npqtdven]

if m->c5_licitac=="S"
	_npreco  :=round(_nprunit*(1-m->c5_desc1/100)*(1-m->c5_desc2/100)*(1-m->c5_desc3/100)*(1-m->c5_desc4/100),6)
	_nvaldesc:=round((_npreco*(_ndescont/100))*_nqtdven,2)
	_nprcven :=round(_npreco*(1-_ndescont/100),6)
else
	_npreco  :=round(_nprunit*(1-m->c5_desc1/100)*(1-m->c5_desc2/100)*(1-m->c5_desc3/100)*(1-m->c5_desc4/100),2)
	_nvaldesc:=round((_npreco*(_ndescont/100))*_nqtdven,2)
	_nprcven :=round(_npreco*(1-_ndescont/100),2)
endif
if _ndescavi>0
	_nvaldesc+=round((_nprcven*(_ndescavi/100))*_nqtdven,2)
	if m->c5_licitac=="S"
		_nprcven :=round(_nprcven*(1-_ndescavi/100),6)
	else
		_nprcven :=round(_nprcven*(1-_ndescavi/100),2)
	endif
	_ndescont:=round(((_npreco-_nprcven)/_npreco)*100,2)
	acols[n,_npdescont]:=_ndescont
endif
_nvalor  :=round(_nqtdven*_nprcven,2)

acols[n,_npprcven]:=_nprcven
acols[n,_npvalor] :=_nvalor

return(_nvaldesc)

// GATILHO NA QUANTIDADE VENDIDA
user function vit007b()

_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))

_npproduto:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRODUTO"})
_cproduto :=acols[n,_npproduto]

sb1->(dbseek(_cfilsb1+_cproduto))

_cfilda0:=xfilial("DA0")
da0->(dbsetorder(1))
da0->(dbseek(_cfilda0+m->c5_tabela))

_ndescavi:=0
if sb1->b1_promoc=="M"
	if m->c5_condpag$"536/607/608/836/860/861" // A VISTA
		//		if sb1->b1_apreven=="2"
		if da0->da0_status$"L/R"
			_ndescavi:=3
		else
			_ndescavi:=5
		endif
	endif
	if m->c5_descit>sb1->b1_descmax
		_ndescont:=sb1->b1_descmax
	else
		_ndescont:=m->c5_descit
	endif
else
	if m->c5_condpag$"536/607/608/836/860/861" // A VISTA
		if sb1->b1_promoc$"PF" .and.;
			m->c5_promoc=="S"
			_ndescavi:=3
		else
			//			if sb1->b1_apreven=="2"
			if da0->da0_status$"L/R"
				_ndescavi:=3
			else
				_ndescavi:=5
			endif
		endif
	endif
	if sb1->b1_promoc$"PF" .and.;
		m->c5_promoc=="S"
		_ndescont:=sb1->b1_descmax
	else
		_ndescont:=m->c5_descit
	endif
endif
_npprunit:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRUNIT"})
_npprcven:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRCVEN"})
_npvalor :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_VALOR"})
_npdescont:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_DESCPR"})

_nprunit:=acols[n,_npprunit]
_nqtdven:=m->c6_qtdven
if m->c5_licitac=="S"
	_npreco  :=round(_nprunit*(1-m->c5_desc1/100)*(1-m->c5_desc2/100)*(1-m->c5_desc3/100)*(1-m->c5_desc4/100),6)
	_nvaldesc:=round((_npreco*(_ndescont/100))*_nqtdven,2)
	_nprcven :=round(_npreco*(1-_ndescont/100),6)
else
	_npreco  :=round(_nprunit*(1-m->c5_desc1/100)*(1-m->c5_desc2/100)*(1-m->c5_desc3/100)*(1-m->c5_desc4/100),2)
	_nvaldesc:=round((_npreco*(_ndescont/100))*_nqtdven,2)
	_nprcven :=round(_npreco*(1-_ndescont/100),2)
endif
if _ndescavi>0
	_nvaldesc+=round((_nprcven*(_ndescavi/100))*_nqtdven,2)
	if m->c5_licitac=="S"
		_nprcven :=round(_nprcven*(1-_ndescavi/100),6)
	else
		_nprcven :=round(_nprcven*(1-_ndescavi/100),2)
	endif		
	_ndescont:=round(((_npreco-_nprcven)/_npreco)*100,2)
	acols[n,_npdescont]:=_ndescont
endif
_nvalor  :=round(_nqtdven*_nprcven,2)
acols[n,_npprcven]:=_nprcven
acols[n,_npvalor] :=_nvalor
return(_nvaldesc)



// GATILHO NA QUANTIDADE VENDIDA
user function vit007c()
_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))

_npproduto:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRODUTO"})
_cproduto :=acols[n,_npproduto]

sb1->(dbseek(_cfilsb1+_cproduto))

_cfilda0:=xfilial("DA0")
da0->(dbsetorder(1))
da0->(dbseek(_cfilda0+m->c5_tabela))
_ndescavi:=0
if sb1->b1_promoc=="M"
	if m->c5_condpag$"536/607/608/836/860/861"   // A VISTA
		if da0->da0_status$"L/R"
			_ndescavi:=3
		else
			_ndescavi:=5
		endif
	endif
	if m->c5_descit>sb1->b1_descmax
		_ndescont:=sb1->b1_descmax
	else
		_ndescont:=m->c5_descit
	endif
else
	if m->c5_condpag$"536/607/608/836/860/861" // A VISTA
		if sb1->b1_promoc$"PF" .and.;
			m->c5_promoc=="S"
			_ndescavi:=3
		else
			//			if sb1->b1_apreven=="2"
			if da0->da0_status$"L/R"
				_ndescavi:=3
			else
				_ndescavi:=5
			endif
		endif
	endif
	if sb1->b1_promoc$"PF" .and.;
		m->c5_promoc=="S"
		_ndescont:=sb1->b1_descmax
	else
		_ndescont:=m->c5_descit
	endif
endif

_npreco:=0
_nvalor:=0
_npprunit:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRUNIT"})
_npprcven:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRCVEN"})
_npvalor :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_VALOR"})


_nprunit:=acols[n,_npprunit]

if m->c5_licitac=="S"
	_npreco  :=round(_nprunit*(1-m->c5_desc1/100)*(1-m->c5_desc2/100)*(1-m->c5_desc3/100)*(1-m->c5_desc4/100),6)
	_nprcven :=round(_npreco*(1-_ndescont/100),6)
else
	_npreco  :=round(_nprunit*(1-m->c5_desc1/100)*(1-m->c5_desc2/100)*(1-m->c5_desc3/100)*(1-m->c5_desc4/100),2)
	_nprcven :=round(_npreco*(1-_ndescont/100),2)
endif
if _ndescavi>0
	if m->c5_licitac=="S"
		_nprcven :=round(_nprcven*(1-_ndescavi/100),6)
	else
		_nprcven :=round(_nprcven*(1-_ndescavi/100),2)
	endif
	_ndescont:=round(((_npreco-_nprcven)/_npreco)*100,2)
	acols[n,_npdescont]:=_ndescont
endif
acols[n,_npprcven]:=_nprcven
acols[n,_npvalor] :=_nvalor
return(_npreco)

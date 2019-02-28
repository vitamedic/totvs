/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT006   ³ Autor ³ Heraildo C. de Freitas³ Data ³10/01/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gatilho no Codigo do Produto e na Quantidade Vendida       ³±±
±±³          ³ na Digitacao de Pedidos de Venda para Atualizar o          ³±±
±±³          ³ Percentual de Desconto do Item                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
#include "rwmake.ch"
#include "topconn.ch"

// GATILHO NO CODIGO DO PRODUTO
user function vit006a()
_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))
sb1->(dbseek(_cfilsb1+m->c6_produto))
if sb1->b1_promoc=="M"
	if m->c5_descit>sb1->b1_descmax
		_ndescont:=sb1->b1_descmax
	else
		_ndescont:=m->c5_descit
	endif
else
	if sb1->b1_promoc$"PF" .and.;
		m->c5_promoc=="S"
			_ndescont:=sb1->b1_descmax	
	else
		_ndescont:=m->c5_descit
	endif
endif
return(_ndescont)

// GATILHO NA QUANTIDADE VENDIDA
user function vit006b()
_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))

_npproduto:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRODUTO"})
_cproduto :=acols[n,_npproduto]

sb1->(dbseek(_cfilsb1+_cproduto))
if sb1->b1_promoc=="M"
	if m->c5_descit>sb1->b1_descmax
		_ndescont:=sb1->b1_descmax
	else
		_ndescont:=m->c5_descit
	endif
else
	if sb1->b1_promoc$"PF" .and.;
		m->c5_promoc=="S"
		_ndescont:=sb1->b1_descmax
	else
		_ndescont:=m->c5_descit
	endif
endif
return(_ndescont)   


// GATILHO NA PORCENTAGEM C6_DESCPR / PARA CAIR NO PREÇO UNITARIO (CONTRA DOMINIO)
User Function vit006c()

Local _vlprc := 0
_npvlprod:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRUNIT"})
_npporc:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_DESCPR"})
_nvunit :=acols[n,_npvlprod]     
_nvldesc :=acols[n,_npporc] 


//If m->c5_desc1 > 0      //c5_prunit
	_vlprc := _nvunit - (_nvunit * m->c5_desc1/100)
//EndIf
If m->c5_desc2 > 0      //c5_prunit
	_vlprc := _vlprc - (_vlprc * m->c5_desc2/100)
EndIf
If m->c5_desc3 > 0      //c5_prunit
	_vlprc := _vlprc - (_vlprc * m->c5_desc3/100) 
EndIf
If _nvldesc > 0
	_vlprc := _vlprc - (_vlprc * _nvldesc/100) 
EndIf

return(_vlprc)    

// GATILHO NA PORCENTAGEM C6_DESCPR / PARA CAIR O VALOR DO PORCENTO  (CONTRA DOMINIO)
User Function vit006d()

Local _vlprc := 0 
_npvlprod :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRUNIT"}) 
_npporc :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_DESCPR"})
_nqtd :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_QTDVEN"})

_nvunit  :=acols[n,_npvlprod]  
_nvldesc :=acols[n,_npporc]
_nqtdvl :=acols[n,_nqtd]

//If m->c5_desc1 > 0      //c5_prunit
	_vlprc := _nvunit - (_nvunit * m->c5_desc1/100)
//EndIf
If m->c5_desc2 > 0      //c5_prunit
	_vlprc := _vlprc - (_vlprc * m->c5_desc2/100)
EndIf
If m->c5_desc3 > 0      //c5_prunit
	_vlprc := _vlprc - (_vlprc * m->c5_desc3/100) 
EndIf     

If _nvldesc > 0
   _vlprc := _nqtdvl*(_vlprc * _nvldesc/100)
EndIf

return(_vlprc)
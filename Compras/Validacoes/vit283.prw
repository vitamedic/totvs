/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT283   ³ Autor ³ Heraildo C. de Freitas    ³Data 23/11/06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Validacao na digitacao da quantidade da solicitacao de     ³±±
±±³          ³ compras para verificacao do estoque maximo para produtos   ³±±
±±³          ³ controlados pela Policia Federal                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#include "topconn.ch"

user function vit283()
_aarea:=getarea()

_lok:=.t.

_cfilsb1:=xfilial("SB1")
_cfilsb2:=xfilial("SB2")
_cfilsc1:=xfilial("SC1")
_cfilsc7:=xfilial("SC7")

_npproduto:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C1_PRODUTO"})
_cproduto :=acols[n,_npproduto]

sb1->(dbsetorder(1))
sb1->(dbseek(_cfilsb1+_cproduto))
if sb1->b1_emax>0
	_aheader:=aheader
	_acols  :=acols
	_n      :=n
	
	aheader:={}
	acols  :={}
	n      :=1
	
	aadd(aheader,{"Descricao" ,"B1_DESC" ,"@!"               ,40,0,"ALLWAYSTRUE()","û","C","SB1"})
	aadd(aheader,{"Armazem"   ,"B2_LOCAL","@!"               ,02,0,"ALLWAYSTRUE()","û","C","SB2"})
	aadd(aheader,{"Quantidade","C1_QUANT","@E 999,999,999.99",12,2,"ALLWAYSTRUE()","û","N","SB2"})
	
	nusado:=len(aheader)
	_ni:=1
	
	_nquant:=0
	
	// SALDO EM ESTOQUE
	sb2->(dbsetorder(1))
	sb2->(dbseek(_cfilsb2+_cproduto))
	while ! sb2->(eof()) .and.;
		sb2->b2_filial==_cfilsb2 .and.;
		sb2->b2_cod==_cproduto
		
		if sb2->b2_local<>"92" .and.;
			sb2->b2_qatu<>0
			
			aadd(acols,array(nusado+1))
			acols[_ni,1]       :="SALDO EM ESTOQUE"
			acols[_ni,2]       :=sb2->b2_local
			acols[_ni,3]       :=sb2->b2_qatu
			acols[_ni,nusado+1]:=.f.
			_ni++
			_nquant+=sb2->b2_qatu
		endif
		sb2->(dbskip())
	end
	
	// SOLICITACOES DE COMPRA
	_cquery:=" SELECT"
	_cquery+=" C1_LOCAL,"
	_cquery+=" SUM(C1_QUANT-C1_QUJE) C1_QUANT"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC1")+" SC1"
	_cquery+=" WHERE"
	_cquery+="     SC1.D_E_L_E_T_=' '"
	_cquery+=" AND C1_FILIAL='"+_cfilsc1+"'"
	_cquery+=" AND C1_PRODUTO='"+_cproduto+"'"
	_cquery+=" AND C1_RESIDUO=' '"
	_cquery+=" AND C1_NUM<>'"+ca110num+"'"
	
	_cquery+=" GROUP BY"
	_cquery+=" C1_LOCAL"
	
	_cquery+=" ORDER BY"
	_cquery+=" C1_LOCAL"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP1"
	u_setfield("TMP1")
	
	tmp1->(dbgotop())
	while ! tmp1->(eof())
		aadd(acols,array(nusado+1))
		acols[_ni,1]       :="SOLICITACOES DE COMPRA"
		acols[_ni,2]       :=tmp1->c1_local
		acols[_ni,3]       :=tmp1->c1_quant
		acols[_ni,nusado+1]:=.f.
		_ni++
		_nquant+=tmp1->c1_quant
		
		tmp1->(dbskip())
	end
	tmp1->(dbclosearea())
	
	// PEDIDOS DE COMPRA
	_cquery:=" SELECT"
	_cquery+=" C7_LOCAL,"
	_cquery+=" SUM(C7_QUANT-C7_QUJE) C7_QUANT"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("SC7")+" SC7"
	_cquery+=" WHERE"
	_cquery+="     SC7.D_E_L_E_T_=' '"
	_cquery+=" AND C7_FILIAL='"+_cfilsc7+"'"
	_cquery+=" AND C7_PRODUTO='"+_cproduto+"'"
	_cquery+=" AND C7_RESIDUO=' '"
	
	_cquery+=" GROUP BY"
	_cquery+=" C7_LOCAL"
	
	_cquery+=" ORDER BY"
	_cquery+=" C7_LOCAL"
	
	_cquery:=changequery(_cquery)
	
	tcquery _cquery new alias "TMP1"
	u_setfield("TMP1")
	
	tmp1->(dbgotop())
	while ! tmp1->(eof())
		aadd(acols,array(nusado+1))
		acols[_ni,1]       :="PEDIDOS DE COMPRA"
		acols[_ni,2]       :=tmp1->c7_local
		acols[_ni,3]       :=tmp1->c7_quant
		acols[_ni,nusado+1]:=.f.
		_ni++
		_nquant+=tmp1->c7_quant
		
		tmp1->(dbskip())
	end
	tmp1->(dbclosearea())
	
	if _nquant+m->c1_quant>sb1->b1_emax
		ctitulo:="Produtos com estoque máximo"
		nopca:=1
		nopcx:=2
		aaltera:={}
		abotoes:={}
		
		dbselectarea("SC1")
		
		define msdialog odlg2 title ctitulo pixel from 0,0 to 400,650 of omainwnd
		
		@ 015,005 say "Produto"
		@ 015,080 say alltrim(_cproduto)+" - "+alltrim(sb1->b1_desc)
		@ 025,005 say "Estoque máximo"
		@ 025,080 say transform(sb1->b1_emax,"@E 999,999,999.99")
		@ 035,005 say "Estoque atual"
		@ 035,080 say transform(_nquant,"@E 999,999,999.99")
		@ 045,005 say "Quantidade solicitada"
		@ 045,080 say transform(m->c1_quant,"@E 999,999,999.99")
		@ 055,005 say "Estoque após a solicitação"
		@ 055,080 say transform(_nquant+m->c1_quant,"@E 999,999,999.99")
		@ 065,005 say "Excedente"
		@ 065,080 say transform((_nquant+m->c1_quant)-sb1->b1_emax,"@E 999,999,999.99")
		
		ogetseg:=msgetdados():new(75,1,200,325,nopcx,"ALLWAYSTRUE()","ALLWAYSTRUE()","",.t.)
		
		activate msdialog odlg2 on init enchoicebar(odlg2,{|| nopca:=1,if(ogetseg:tudook(),odlg2:end(),nopca:=0)},{||odlg2:end()},,abotoes) centered
	endif
	aheader:=_aheader
	acols  :=_acols
	n      :=_n
endif
restarea(_aarea)
return(_lok)

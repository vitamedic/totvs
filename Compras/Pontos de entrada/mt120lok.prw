#include "rwmake.ch"

/*/{Protheus.doc} mt120lok
	Ponto de entrada para verificar se a Data de Entrega (faturamento) é maior ou igual a data atual.
@author Alex Júnio de Miranda
@since 16/03/2009
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function mt120lok()
	_lok:=.t.
	_npdelete:=len(aheader)+1

	_nordsa5:=sa5->(indexord())
	_nregsa5:=sa5->(recno())
	sa5->(dbsetorder(2))

	if ! acols[n,_npdelete]

		_npproduto	:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C7_PRODUTO"})
		_npitem		:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C7_ITEM"})
		_npdescri	:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C7_DESCRI"})
		_npquant	:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C7_QUANT"})
		_npum		:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C7_UM"})
		_npnumsc	:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C7_NUMSC"})
		_npdatprf	:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C7_DATPRF"})
		_npfornece  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C7_FORNECE"})
		_nploja     :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C7_LOJA"})
		_nXTRANSP   :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C7_XTRANSP"})
		_PosFabric 	:=AScan(aHeader,{|x| upper(alltrim(x[2])) == 'C7_XFABRIC'})
		_PosTransp 	:=AScan(aHeader,{|x| upper(alltrim(x[2])) == 'C7_XTRANSP'})

		_cXTRANSP   :=acols[n,_nXTRANSP]
		_cproduto 	:=acols[n,_npproduto]
		_citem    	:=acols[n,_npitem]
		_cdescri  	:=acols[n,_npdescri]
		_cquant   	:=acols[n,_npquant]
		_cum      	:=acols[n,_npum]
		_cnumsc   	:=acols[n,_npnumsc]
		_cdatprf  	:=acols[n,_npdatprf]
		_data		:=dA120Emis // variÃ¡vel do sistema com a data de emissÃ£o
		_quje		:=sc7->c7_quje
		_fornece    :=cA120Forn
		_loja		:=cA120Loj

		If _PosTransp > 0  
			If ! u_VIT443("C7_XTRANSP", acols[n,_PosTransp])
				sa5->(dbsetorder(_nordsa5))
				sa5->(dbgoto(_nregsa5))
				Return(.f.)
			EndIf
		EndIf 

		If _PosFabric > 0  
			If ! u_VIT443("C7_XFABRIC", acols[n,_PosFabric])
				sa5->(dbsetorder(_nordsa5))
				sa5->(dbgoto(_nregsa5))
				Return(.f.)
			EndIf
		EndIf 

		if _cdatprf<_data
			if _quje=0
				_lok:=.f.
				msginfo("A Data para PrevisÃ£o do Faturamento deve ser MAIOR ou IGUAL a Data de Emissao do Pedido!")
			endif
		endif
	
		sa5->(dbsetorder(2))
		if ! sa5->(dbseek(xfilial("SA5")+_cproduto+_fornece+_loja))
			_lok:=.f.
			msgstop("Produto nao encontrato na amarracao Produto x Fornecedor!")
		elseif (sa5->a5_situ$"D/E" .or.	sa5->a5_msblql=="1") .and.;
				sb1->b1_tipo$"MP/EE/EN"
			_lok:=.f.
			msgstop("Produto nao qualificado para este fornecedor! (Checar ProdutoxFornecedor)")
		endif

	endif

	sa5->(dbsetorder(_nordsa5))
	sa5->(dbgoto(_nregsa5))
return(_lok)

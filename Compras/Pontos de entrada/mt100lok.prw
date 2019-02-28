#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} mt100lok
	Ponto de entrada para verificar se a digitacao do pedido
	de compras e obrigatoria, de acordo com o cadastro do Produto
@author Heraildo C. de Freitas
@since 13/11/2001
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function mt100lok()

	LOCAL mTerc := GETMV("MV_XTESTER") //Parametro Retirar Tes de poder de terceiro na Valida��o de data de Validade
	_lok:=.t.
	_npdelete:=len(aheader)+1
	if ! acols[n,_npdelete]
		_cfilsb1:=xfilial("SB1")
		_cfilsf4:=xfilial("SF4")
		_cfilsc7:=xfilial("SC7")
		sb1->(dbsetorder(1))
		sf4->(dbsetorder(1))
		sc7->(dbsetorder(1))
		sm2->(dbsetorder(1))
	
		_npcod    :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_COD"})
		_nptes    :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_TES"})
		_nppedido :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_PEDIDO"})
		_npcc     :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_CC"})
		_nplotefor:=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_LOTEFOR"})
		_npdtvalid:=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_DTVALID"})
		_nprateio :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_RATEIO"})
		_npop     :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_OP"})
		_npnumvol :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_NUMVOL"})
		_npitemped:=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_ITEMPC"})
		_npquant  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_QUANT"})
		_npvalunit:=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_VUNIT"})
		_npvaltot :=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_TOTAL"})
		_npclasfis:=ascan(aheader,{|x| upper(alltrim(x[2]))=="D1_CLASFIS"})

		_ccod     :=acols[n,_npcod]
		_ctes     :=acols[n,_nptes]
		_cpedido  :=acols[n,_nppedido]
		_ccc      :=acols[n,_npcc]
		_clotefor :=acols[n,_nplotefor]
		_ddtvalid :=acols[n,_npdtvalid]
		_crateio  :=acols[n,_nprateio]
		_cop      :=acols[n,_npop]
		_nnumvol  :=acols[n,_npnumvol]
		_citemped :=acols[n,_npitemped]
		_cquant   :=acols[n,_npquant]
		_cvalunit :=acols[n,_npvalunit]
		_cvaltot  :=acols[n,_npvaltot]
		_csequen  :=""
		_cclasfis :=acols[n,_npclasfis]
	
		sb1->(dbseek(_cfilsb1+_ccod))
		sf4->(dbseek(_cfilsf4+_ctes))
		sc7->(dbseek(_cfilsc7+_cpedido+_citemped+_csequen))
	
	// Atualizacao da Classificao Fiscal pelo TES
		_cclasfis := sf4->f4_origem+sf4->f4_sittrib
		acols[n,_npclasfis]:= _cclasfis
	
		if substr(acols[n,_npclasfis],1,1)==" "
			_lok:=.f.
			msginfo("Checar Classificacao Fiscal do item! Campo origem em branco!")
		endif
	
		if sf4->f4_duplic=="S"
			if ctipo=="N"
				if sb1->b1_pcobrig=="S" .and.;
						empty(_cpedido)
					_lok:=.f.
					msginfo("Para este produto e obrigatória a digitação do pedido de compra!")
				endif
			endif
			if sb1->b1_estoque=="N" .and. _crateio<>"1" /*.and. !sb1->b1_grupo$("IN04/IN03") */
				if empty(_ccc)
					//_lok:=.f. pedido claudio comentar 
					//msginfo("Para este produto e obrigatória a digitação do centro de custo!") pedido claudio comentar 
				endif
			else
				if ! empty(_ccc)
					//_lok:=.f.pedido claudio comentar 
					//msginfo("O centro de custo deverá ser informado apenas no momento da requisição do produto!")pedido claudio comentar 
				endif
			endif
		endif
		if sf4->f4_estoque=="S" .and.;
				ctipo=="N"
			if sb1->b1_rastro=="L"
				if sb1->b1_tipo=="MP" .and.;
						empty(_clotefor)
					_lok:=.f.
					msginfo("Favor informar o lote do fornecedor!")
				endif
			if !_ctes $ mTerc    //N�o Validar Data de Validade quando for Poder de Terceiro
				if empty(_ddtvalid) .or. _ddtvalid<=ddatabase   
					_lok:=.f.
					msginfo("Favor verificar a data de validade!")
				endif
			endif // N�o Validar Data de Validade quando for Poder de Terceiro
				if empty(_nnumvol)
					_lok:=.f.
					msginfo("Favor informar o numero de volumes!")
				endif
			endif
		endif
		if sf4->f4_estoque=="S" .and.;
				sf4->f4_duplic=="S" .and.;
				ctipo=="N" .and.;
				sb1->b1_tipo=="BN"
			if empty(_cop)
				_lok:=.f.
				msginfo("Favor informar a ordem de produção!")
			endif
		else
			if ! empty(_cop)
				_lok:=.f.
				msginfo("Ordem de produção não deve ser informada!")
			endif
		endif
	
	// Verifica se o produto controla ou não estoque e não deixa entrar com a TES que não seja com o mesmo parâmetro
		if sf4->f4_estoque=="S" .and. sb1->b1_estoque=="N"
			_lok:=.f.
			msginfo("Este produto não controla estoque! Verifique a TES!")
		endif
	
	// Verifica se Vlr. Un. do item na NF excede a 5% de variação em relação ao Vlr. Un. do Pedido de Compras
		if sf4->f4_estoque=="S" .and.;
				sf4->f4_duplic=="S" .and.;
				ctipo=="N" .and.;
				sb1->b1_pcobrig=="S"
		
			_pcpreco:=0
			_cemissao:=dtoc(ddemissao)
		
			if sc7->c7_moeda==1
				_pcpreco:=sc7->c7_preco
			else
				if sm2->(dbseek(dtos(ddemissao)))
					if sc7->c7_moeda==2
						if sm2->m2_moeda2 = 0
							_lok:=.f.
							msginfo("Cotacao de moedas ( Dolar) do dia "+_cemissao+" nao foi informada. Contactar Depto. Suprimentos.")
						else
							_pcpreco:=sc7->c7_preco*sm2->m2_moeda2
						endif
					elseif sc7->c7_moeda=5
						if sm2->m2_moeda5 = 0
							_lok:=.f.
							msginfo("Cotacao de moedas ( Euro ) do dia "+_cemissao+" nao foi informada. Contactar Depto. Suprimentos.")
						else
							_pcpreco:=sc7->c7_preco*sm2->m2_moeda5
						endif
					endif
				else
					_lok:=.f.
					msginfo("Cotacao de moedas do dia "+_cemissao+" nao foi informada. Contactar Depto. Suprimentos.")
				endif
			endif
		
			_varac:=GETMV("MV_VITPCAC") //Parametro com % Permitido ACIMA do Valor do PC
			_varab:=GETMV("MV_VITPCAB") //Parametro com % Permitido ABAIXO do Valor do PC
		//		_valunitac:=_pcpreco+(_pcpreco*0.05)
			_valunitac:=_pcpreco+(_pcpreco*(_varac/100)) // variação de 5% acima
		//		_valunitab:=_pcpreco-(_pcpreco*0.05)
			_valunitab:=_pcpreco-(_pcpreco*(_varab/100)) // variação de 5% abaixo
		
			if (_cvalunit > _valunitac)
				_lok:=.f.
				msginfo("Valor Unitario ACIMA do % Permitido em relacao ao PC. Contactar Depto. Suprimentos.")
			elseif(_cvalunit < _valunitab)
				_lok:=.f.
				msginfo("Valor Unitario ABAIXO do % Permitido em relacao ao PC. Contactar Depto. Suprimentos.")
			endif
		endif

	// Valida Quantidade Permitida acima do PC - E-mail solicitação suprimentos 29/03/2011
		if sf4->f4_duplic=="S" .and.;
				ctipo=="N" .and.;
				sb1->b1_pcobrig=="S"
		
			_qtpend:= sc7->c7_quant - sc7->c7_quje // Quantidade pendente do pedido selecionado
			_qtpend:= _qtpend + (_qtpend * 0.1) // Quantidade pendente + 10% tolerância acima
		
			if _cquant > _qtpend
				_lok:=.f.
				msginfo("Quantidade informada ACIMA do % Permitido em relacao ao PC. Contactar Depto. Suprimentos.")
			endif
		endif

		//Henrique - Valida��o de Certificados dos Fornecedores, Fabricantes e Transportadoras 
		_PosFabric 	:=AScan(aHeader,{|x| upper(alltrim(x[2])) == 'D1_XFABRIC'})
		_PosTransp 	:=AScan(aHeader,{|x| upper(alltrim(x[2])) == 'D1_XTRANSP'})

		If _PosTransp > 0  
			If ! u_VIT619("D1_XTRANSP", acols[n,_PosTransp])
				Return(.f.)
			EndIf
		EndIf 

		If _PosFabric > 0  
			If ! u_VIT619("D1_XFABRIC", acols[n,_PosFabric])
				Return(.f.)
			EndIf
		EndIf 

	endif

return(_lok)
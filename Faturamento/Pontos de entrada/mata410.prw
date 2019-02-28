/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATA410  ³ Autor ³ Heraildo C. de Freitas³ DATA ³20/12/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada para Separacao do Pedido de Acordo com %  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function mata410()
if ! sc5->c5_tipo$"BD" .and.;
	inclui
	_cfilsa3:=xfilial("SA3")
	_cfilsb1:=xfilial("SB1")
	_cfilsc5:=xfilial("SC5")
	_cfilsc6:=xfilial("SC6")
	_cfilsf4:=xfilial("SF4")
	sa3->(dbsetorder(1))
	sb1->(dbsetorder(1))
	sc5->(dbsetorder(1))
	sc6->(dbsetorder(1))
	sf4->(dbsetorder(1))
	
    if sc5->c5_tabela<>'999'
		_nordsa3:=sa3->(indexord())
		_nregsa3:=sa3->(recno())
	
		sa3->(dbseek(_cfilsa3+sc5->c5_vend1))
		_cvend2:=sa3->a3_super
		_cvend3:=sa3->a3_geren
	
		sc5->(reclock("SC5",.f.))
		
		sa3->(dbseek(_cfilsa3+_cvend2))
		sc5->c5_vend2:=_cvend2
		sc5->c5_comis2:=sa3->a3_comis
		
		sa3->(dbseek(_cfilsa3+_cvend3))
		sc5->c5_vend3:=_cvend3
		sc5->c5_comis3:=sa3->a3_comis
		
		sc5->(msunlock())        
		
		
		sa3->(dbsetorder(_nordsa3))
		sa3->(dbgoto(_nregsa3)) 
	endif
	
	// GUARDA O NUMERO DO PEDIDO ATUAL
	_cnum:=sc5->c5_num
	
	if sc5->c5_percfat==100 // ALTERA O NUMERO DO PEDIDO
		_cnumr:=left(_cnum,5)+"R"
		sc6->(dbseek(_cfilsc6+_cnum))
		while ! sc6->(eof()) .and.;
				sc6->c6_num==_cnum
			sc6->(dbskip())
			_nregsc6:=sc6->(recno())
			sc6->(dbskip(-1))
			sb1->(dbseek(_cfilsb1+sc6->c6_produto))
			sc6->(reclock("SC6",.f.))
			sc6->c6_num:=_cnumr
			sc6->c6_tes:="900"
			if sc5->c5_desc3>0 .and.;
				sb1->b1_promoc<>"F"
				_nprcven :=round(sc6->c6_prunit*(1-sc5->c5_desc1/100)*(1-sc5->c5_desc2/100)*(1-sc5->c5_desc4/100),2)
				_nvaldesc:=round((_nprcven*(sc6->c6_descont/100))*sc6->c6_qtdven,2)
				_nprcven :=round(_nprcven*(1-sc6->c6_descont/100),2)
				sc6->c6_prcven :=_nprcven
				sc6->c6_valor  :=round(sc6->c6_qtdven*_nprcven,2)
				sc6->c6_valdesc:=_nvaldesc
			endif
			sc6->(msunlock())
			sc6->(dbgoto(_nregsc6))
		end
		sc5->(reclock("SC5",.f.))
		sc5->c5_num  :=_cnumr
		if sc5->c5_desc3>0 
			sc5->c5_desc3:=0
		endif
		sc5->(msunlock())
		msginfo("O numero do pedido foi alterado para "+_cnumr)
	elseif sc5->c5_percfat>0 // VERIFICA SE TEM %
		_cnumr:=left(_cnum,5)+"R"
		_lcab:=.f.
		// GRAVA OS ITENS DO PEDIDO
		sc6->(dbseek(_cfilsc6+_cnum))
		while ! sc6->(eof()) .and.;
				sc6->c6_num==_cnum
			sb1->(dbseek(_cfilsb1+sc6->c6_produto))
			// GRAVA O NUMERO DO REGISTRO ATUAL
			_nregsc6:=sc6->(recno())		
			// COPIA O REGISTRO ATUAL PARA UM VETOR
			_areg:=array(sc6->(fcount()))
			for _i:=1 to len(_areg)
				_areg[_i]:=sc6->(fieldget(_i))
			next
			_nqtdven:=sc6->c6_qtdven
			_nqtdfat:=int(sc6->c6_qtdven*(sc5->c5_percfat/100))
			if _nqtdven>0
				// GRAVA O NOVO REGISTRO
				_lcab:=.t.
				sc6->(reclock("SC6",.t.))
				for _i:=1 to len(_areg)
					if upper(alltrim(sc6->(fieldname(_i))))=="C6_NUM"
						sc6->c6_num:=_cnumr
					elseif upper(alltrim(sc6->(fieldname(_i))))=="C6_QTDVEN"
						sc6->c6_qtdven:=_nqtdfat
					elseif upper(alltrim(sc6->(fieldname(_i))))=="C6_UNSVEN"
						if _areg[_i]>0
							sc6->c6_unsven:=round(_areg[_i]/_nqtdven*sc6->c6_qtdven,2)
						endif
					elseif upper(alltrim(sc6->(fieldname(_i))))=="C6_TES"
						sc6->c6_tes:="900"
					else
						sc6->(fieldput(_i,_areg[_i]))
					endif
				next
				if sc5->c5_desc3>0 .and.;
					sb1->b1_promoc<>"F"
					_nprcven :=round(sc6->c6_prunit*(1-sc5->c5_desc1/100)*(1-sc5->c5_desc2/100)*(1-sc5->c5_desc4/100),2)
					_nvaldesc:=round((_nprcven*(sc6->c6_descont/100))*sc6->c6_qtdven,2)
					_nprcven :=round(_nprcven*(1-sc6->c6_descont/100),2)
					sc6->c6_prcven :=_nprcven
					sc6->c6_valor  :=round(sc6->c6_qtdven*_nprcven,2)
					sc6->c6_valdesc:=_nvaldesc				
				else
					_nprcven :=sc6->c6_prcven
					_nvaldesc:=round((_nprcven*(sc6->c6_descont/100))*sc6->c6_qtdven,2)
					sc6->c6_valor  :=round(sc6->c6_qtdven*_nprcven,2)
					sc6->c6_valdesc:=_nvaldesc
				endif
				sc6->(msunlock())
		
				// VOLTA AO REGISTRO ANTERIOR
				sc6->(dbgoto(_nregsc6))
     	
				// ALTERA O REGISTRO ATUAL
				sc6->(reclock("SC6",.f.))
				sc6->c6_qtdven-=_nqtdfat
				sc6->c6_valor :=round(sc6->c6_qtdven*sc6->c6_prcven,2)
				if sc6->c6_unsven>0
					sc6->c6_unsven:=round(sc6->c6_unsven/_nqtdven*sc6->c6_qtdven,2)
				endif
				if sc6->c6_valdesc>0
					sc6->c6_valdesc:=round(sc6->c6_valdesc/_nqtdven*sc6->c6_qtdven,2)
				endif
				sc6->(msunlock())
			endif
			sc6->(dbskip())
		end
		if _lcab
			// COPIA O PEDIDO ATUAL PARA UM VETOR
			_areg:=array(sc5->(fcount()))
			for _i:=1 to len(_areg)
				_areg[_i]:=sc5->(fieldget(_i))
			next
			// GRAVA O CABECALHO DO NOVO PEDIDO
			sc5->(reclock("SC5",.t.))
			for _i:=1 to len(_areg)
				if upper(alltrim(sc5->(fieldname(_i))))=="C5_NUM"
					sc5->c5_num:=_cnumr
				else
					sc5->(fieldput(_i,_areg[_i]))
				endif
			next
			if sc5->c5_desc3>0 
				sc5->c5_desc3:=0
			endif
			sc5->(msunlock())
			msginfo("Foi gerado o pedido "+_cnumr)
		endif
	endif
endif
return
#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} mt440gr
//Ponto de Entrada na Liberacao do Pedido de Vendas
@author Totvs
@since 04/01/2018
@version 1.0
@return Logico

@type function
/*/
user function mt440gr()
	Local _aItens 	:= {}
	Local _cItem  	:= ""
	Local _cProduto	:= ""
	Local _cLocal  	:= ""
	Local _cLoteCtl := ""
	return(.t.) //temporário

	if PARAMIXB[1] == 0
		return(.t.)
	endif

	_cfilsb1:=xfilial("SB1")
	_cfilsc6:=xfilial("SC6")
	_cfilsc9:=xfilial("SC9")
	_cfilsf4:=xfilial("SF4")
	sb1->(dbsetorder(1))
	sc6->(dbsetorder(1))
	sc9->(dbsetorder(1))
	sf4->(dbsetorder(1))

	_npitem   :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_ITEM"})
	_npproduto:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_PRODUTO"})
	_nplocal  :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_LOCAL"})
	_nptes    :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_TES"})
	_npqtdlib :=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_QTDLIB"})
	_npsldalib:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_SLDALIB"})
	_nplotectl:=ascan(aheader,{|x| upper(alltrim(x[2]))=="C6_LOTECTL"})

	for _i:=1 to len(acols)
		if _npsldalib==0
			_nsldalib:=0
			_lzera:=.f.
		else
			_nsldalib:=acols[_i,_npsldalib]
			_lzera:=.t.
		endif
		if _nsldalib==0 .and.;
		_lzera
			acols[_i,_npqtdlib]:=0
		else
			_ctes:=acols[_i,_nptes]
			_nqtdlib:=acols[_i,_npqtdlib]
			sf4->(dbseek(_cfilsf4+_ctes))
			if _nqtdlib>0 .and.;
			sf4->f4_estoque=="S"
				_citem   :=acols[_i,_npitem]
				_cproduto:=acols[_i,_npproduto]
				_clocal  :=acols[_i,_nplocal]

				if _nplotectl == 0
					_cLoteCtl := ""
				else
					_cLoteCtl := alltrim(acols[_i,_nplotectl])
				endif

				_cquery:=" SELECT"
				_cquery+=" SUM(C9_QTDLIB) AS QTDLIB"
				_cquery+=" FROM "
				_cquery+=  retsqlname("SC9")+" SC9"
				_cquery+=" WHERE"
				_cquery+="     SC9.D_E_L_E_T_<>'*'"
				_cquery+=" AND C9_FILIAL='"+_cfilsc9+"'"
				_cquery+=" AND C9_PRODUTO='"+_cproduto+"'"
				_cquery+=" AND C9_LOCAL='"+_clocal+"'"
				_cquery+=" AND C9_BLCRED='01'"

				_cquery:=changequery(_cquery)

				tcquery _cquery new alias "TMP1"

				sb1->(dbseek(_cfilsb1+_cproduto))

				if (sb1->b1_rastro=="L" .and. sb1->b1_localiz=="N")
					_cquery:=		 " SELECT SUM(QQ.SLDSB8-SB2.B2_XEMPWMS) AS SALDO"
					_cquery:=_cquery+" FROM "+retsqlname("SB2") + " SB2 "
					_cquery:=_cquery+" LEFT JOIN ( SELECT SUM(SB8.B8_SALDO-SB8.B8_EMPENHO) AS SLDSB8"
					_cquery:=_cquery+"             FROM "+retsqlname("SB8") + " SB8 "
					_cquery:=_cquery+"             WHERE SB8.B8_FILIAL   = '"+xfilial("SB8")+"'"
					_cquery:=_cquery+"               AND SB8.B8_PRODUTO  = SB2.B2_COD"
					_cquery:=_cquery+"               AND SB8.B8_LOCAL    = SB2.B2_LOCAL"
					if !empty(_cLoteCtl)
						_cquery:=_cquery+"               AND B8_LOTECTL		 =  '"+_cLoteCtl+"'"
					endif
					_cquery:=_cquery+"               AND SB8.D_E_L_E_T_  <> '*'"
					_cquery:=_cquery+"           ) QQ "
					_cquery:=_cquery+" WHERE SB2.B2_FILIAL	=  '"+xfilial("SB2")+"'"
					_cquery:=_cquery+"   AND SB2.B2_COD		=  '"+_cproduto+"'"
					_cquery:=_cquery+"   AND SB2.B2_LOCAL	=  '"+_clocal+"'"
					_cquery:=_cquery+"   AND SB2.D_E_L_E_T_ <> '*'"

					_cquery:=changequery(_cquery)

				elseif sb1->b1_localiz=="S"
					_cquery:=		  " SELECT SUM(BF_QUANT-BF_EMPENHO) AS SALDO"
					_cquery:=_cquery+" FROM "+retsqlname("SBF")
					_cquery:=_cquery+" WHERE BF_FILIAL='"+xfilial("SBF")+"'"
					_cquery:=_cquery+" AND D_E_L_E_T_<>'*'"
					_cquery:=_cquery+" AND BF_PRODUTO='"+_cproduto+"'"
					_cquery:=_cquery+" AND BF_LOCAL='"+_clocal+"'"

					_cquery:=changequery(_cquery)
				else
					_cquery:=		  " SELECT SUM(B2_QATU-B2_QEMP-B2_RESERVA-B2_XEMPWMS) AS SALDO"
					_cquery:=_cquery+" FROM "+retsqlname("SB2")
					_cquery:=_cquery+" WHERE B2_FILIAL='"+xfilial("SB2")+"'"
					_cquery:=_cquery+" AND D_E_L_E_T_<>'*'"
					_cquery:=_cquery+" AND B2_COD='"+_cproduto+"'"
					_cquery:=_cquery+" AND B2_LOCAL='"+_clocal+"'"

					_cquery:=changequery(_cquery)
				endif
				tcquery _cquery new alias "TMP2"

				sc6->(dbseek(_cfilsc6+m->c5_num+_citem))
				_ndispo:=tmp2->saldo-tmp1->qtdlib
				if _ndispo<=0
					acols[_i,_npqtdlib]:=0
				elseif _nqtdlib>_ndispo
					if _ndispo>=sc6->c6_qtdven-sc6->c6_qtdent
						acols[_i,_npqtdlib]:=sc6->c6_qtdven-sc6->c6_qtdent
					else
						acols[_i,_npqtdlib]:=_ndispo
					endif
				endif
				tmp1->(dbclosearea())
				tmp2->(dbclosearea())
				AAdd(_aItens, {_cItem, acols[_i,_npqtdlib]}  )
			endif
		endif
	next _i

	/* COMENTADO POR DANILO LOTE IMCOMPLETO
	dbSelectArea("SC9")
	dbSetOrder(1)
	//C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	for _i:=1 to len(_aItens)
		_cChave := xFilial("SC9")+SC5->C5_NUM+_aItens[_i,1]
		if dbSeek(_cChave)
			aSaldos := {}
			do while SC9->( !Eof() .and. C9_FILIAL+C9_PEDIDO+C9_ITEM == _cChave )
				if SC9->C9_BLEST <> '10' .and. SC9->C9_BLEST <> '  '
					AAdd(aSaldos, {SC9->C9_LOTECTL, "", "", "", SC9->C9_QTDLIB, 0, SC9->C9_DTVALID} )
				endif
				SC9->(dbSkip())
			enddo

			if Len(aSaldos) > 0 .and. dbSeek( xFilial("SC9")+SC5->C5_NUM+_aItens[_i,1])
				a450Grava(1,.t.,.t.,.f.,aSaldos,.t.)
			endif
		else
			u_VolCompletos(SC5->C5_NUM, _aItens[_i,1], _aItens[_i,2], aSaldos)
		endif
	next _i */

return(.t.)

/////////////////////////////////////////////////////////////
//////// FUNCAO PARA CONSULTAR OS VOLUMES INCOMPLETO	/////
/////////////////////////////////////////////////////////////
User Function VolCompletos(pNumPV, pItem, pQtdLib, aSaldos)

	Local lRet 			:= .t.
	Local cCodProduto 	:= ""

	Default aSaldos := {}

	dbSelectArea("SC6")
	dbSetOrder(1)
	if !MSSeek(XFilial("SC6")+pNumPV+pItem)
		Return( .f. )
	endif

	cCodProduto := SC6->C6_COD

	dbSelectArea("SF4")
	dbSetOrder(1)
	MsSeek(xFilial("SF4")+SC6->C6_TES)

	//////////////////////////////////////////////////////////////////////////////////
	///////////// QUERY DE CONSULTA DOS LOTES INCOMPLETOS DO PRODUTO /////////////////
	//////////////////////////////////////////////////////////////////////////////////
	cQry := " SELECT "                                                                                                                                                         + cPulaLinha
	cQry += " 	PRODUTO.B1_COD CODIGO, "                                                                                                                                       + cPulaLinha
	cQry += " 	PRODUTO.B1_TIPO TIPO, "                            																	                                           + cPulaLinha
	cQry += "   PRODUTO.B1_DESC DESCRICAO, "                              																					                   + cPulaLinha
	cQry += "   SALDO_LOTE.B8_LOTECTL LOTECTL, "																										                       + cPulaLinha
	cQry += "   SALDO_LOTE.B8_DTVALID DTVALID, "																										                       + cPulaLinha
	cQry += "   SALDO_LOTE.B8_SALDO SALDO, "																												                   + cPulaLinha
	cQry += "   SALDO_LOTE.B8_EMPENHO EMPENHO, "																												               + cPulaLinha
	cQry += "   (SALDO_LOTE.B8_SALDO - SALDO_LOTE.B8_EMPENHO) DISPONIVEL, "																					                   + cPulaLinha
	cQry += "   PRODUTO.B1_CXPAD QTDE_VOLUME, "																									                               + cPulaLinha
	cQry += "   ROUND((SALDO_LOTE.B8_SALDO - SALDO_LOTE.B8_EMPENHO) - Mod(SALDO_LOTE.B8_SALDO - SALDO_LOTE.B8_EMPENHO, PRODUTO.B1_CXPAD) /PRODUTO.B1_CXPAD,1)  QTD_VOLUMES, "  + cPulaLinha
	cQry += "   ((SB8.B8_SALDO - SB8.B8_EMPENHO) - Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, PRODUTO.B1_CXPAD)) / PRODUTO.B1_CXPAD VOL_INTEIROS, "		                               + cPulaLinha
	cQry += "   Mod(SB8.B8_SALDO - SB8.B8_EMPENHO, PRODUTO.B1_CXPAD) VOL_INCOMPLETOS "	                                                                                       + cPulaLinha
	cQry += " FROM "                                                                                                                                                           + cPulaLinha
	cQry += " " + RetSqlName("SB8") + " SALDO_LOTE "                                                                                                                           + cPulaLinha
	cQry += " INNER JOIN "                                                                                                                                                     + cPulaLinha
	cQry += " " + RetSqlName("SB1") + " PRODUTO " 																							                                   + cPulaLinha
	cQry += " ON SALDO_LOTE.D_E_L_E_T_ = ' ' "                                                                                                                                 + cPulaLinha
	cQry += " AND PRODUTO.D_E_L_E_T_ = ' ' "                                                                                                                                   + cPulaLinha
	cQry += " AND SALDO_LOTE.B8_FILIAL = PRODUTO.B1_COD "                                                                                                                      + cPulaLinha
	cQry += " WHERE "                                                                                                                                                          + cPulaLinha
	cQry += " 	PRODUTO.B1_FILIAL 			= '" + xFilial("SB1") + "' "												                                                       + cPulaLinha
	cQry += "   AND SALDO_LOTE.B8_FILIAL 	= '" + xFilial("SB8") + "' "                             					                                                       + cPulaLinha
	cQry += "   AND (SALDO_LOTE.B8_SALDO - SALDO_LOTE.B8_EMPENHO) > 0 "																                                           + cPulaLinha
	cQry += "   AND Mod(SALDO_LOTE.B8_SALDO - SALDO_LOTE.B8_EMPENHO, SB1.B1_CXPAD) <> 0 "																                       + cPulaLinha
	cQry += "   AND SB1.B1_TIPO IN ('PA', 'PN') "													                                                                           + cPulaLinha
	cQry += "   AND SB8.B8_PRODUTO = '" + pCodProduto + "' "												                                                                   + cPulaLinha
	cQry += " ORDER BY SB1.B1_COD,SB8.B8_DTVALID ASC " 																													       + cPulaLinha

	if Select("QSELOT") > 0
		QSELOT->( dbCloseArea() )
	endif

	pRecnos := u_CountRegs(cQry,"QSELOT")

	if QSELOT->(!Eof()) .and. pQtdLib > 0
		if QSELOT->QTDE_VOLUME > 0
			nQtdVol := QSELOT->QTDE_VOLUME
		else
			nQtdVol := 1
		endif

		aSaldos  := {}
		nQtdDisp := QSELOT->DISPONIVEL

		do while QSELOT->(!Eof()) .and. pQtdLib > 0

			nY := AScan(aSaldos, {|x| x[1] == QSELOT->LOTECTL})

			if nQtdDisp >= pQtdLib

				if nY > 0
					aSaldos[nY,5] += pQtdLib
				else
					AAdd(aSaldos, { QSELOT->LOTECTL, "", "", "", pQtdLib, 0, StoD(QSELOT->DTVALID) })
				endif

				exit

			elseif nQtdDisp >= nQtdVol

				nQtdDisp -= nQtdVol
				pQtdLib  -= nQtdVol

				if nY > 0
					aSaldos[nY,5] += nQtdVol
				else
					AAdd(aSaldos, { QSELOT->LOTECTL, "", "", "", nQtdVol, 0, StoD(QSELOT->DTVALID) })
				endif

			else
				QSELOT->(dbSkip())

				if QSELOT->(!Eof())
					nQtdDisp := QSELOT->DISPONIVEL
				endif

			endif

		enddo

		if Len(aSaldos) > 0
			dbSelectArea("SC9")
			dbSetOrder(1)
			dbSeek(XFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
			a450Grava(1,.f.,.t.,.f.,aSaldos,.t.)
		endif
	endif

Return(.t.)

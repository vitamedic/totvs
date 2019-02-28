#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} vit010
	Validacao do Codigo do Produto e na Quantidade a ser Produzida na Abertura de Ordens de Producao para nao 
	Permitir a Abertura de Ordens de Producao para Produtos Cujos Saldos dos Componentes Essenciais Sejam Insuficientes
@author Heraildo C. de Freitas
@since 28/01/02
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function vit010()
	_aarea:=getarea()
	_lok:=.t.
	if ! empty(m->c2_produto)
		if !empty(m->c2_produto) //Verificar se existe algum lote com saldo suficiente para atender o produto
			if !empty( cMsgErr := u_fVldSldPI(m->c2_produto) )
				msgStop(cMsgErr)
				return(.f.)

			endif
		endif

		_cfilsb1:=xfilial("SB1")
		_cfilsb2:=xfilial("SB2")
		_cfilsc2:=xfilial("SC2")
		_cfilsg1:=xfilial("SG1")
		_cfilsb8:=xfilial("SB8")

		sb8->(dbsetorder(1))
		sb1->(dbsetorder(1))
		sb1->(dbseek(_cfilsb1+m->c2_produto))
		sg1->(dbsetorder(1))

		if SB1->B1_TIPO == "PN" // Não avalia saldos para Nutracêuticos
			return .T.
		endif

		_resto:= mod(m->c2_quant,sb1->b1_qb)    //RETORNA O RESTO DA DIVISAO

		if sb1->b1_altestr=="S"
			_lok:=.f.
			msginfo("Nao e permitida a abertura de ordens de producao para este produto. Estrutura aberta!")

		elseif upper(alltrim(readvar()))=="M->C2_PRODUTO" .and.;
		! sg1->(dbseek(_cfilsg1+m->c2_produto))
			//	(! sb1->b1_tipo$"PA/PI/PS" .or. (sb1->b1_locpad<>"01" .and. sb1->b1_locpad<>"91" .and. sb1->b1_locpad<>"05"))

			_lok:=.f.
			msginfo("Nao e permitida a abertura de ordens de producao para este produto!")

		elseif (sb1->b1_grupo=="EN07" .or. sb1->b1_grupo=="EE05") .and. _resto<>0
			_lok:=.f.
			msginfo("Quantidade deve ser proporcional Ã  quantidade teÃ³rica de 01 lote!")

		elseif (sb1->b1_grupo=="EE02" .or. sb1->b1_grupo=="EE06") .and. m->c2_quant>15000 //Quantidade mÃ¡xima definida no chamado Ocomon nÂº 1289 (07/12/2011)
			_lok:=.f.
			msginfo("Quantidade deve ser no maximo 15.000!")
		else
			_nqtdprod:=if(m->c2_quant==0,sb1->b1_qb,m->c2_quant)
			_nqbop   :=sb1->b1_qb
			if _nqtdprod>0
				_cloccq :=getmv("MV_CQ")

				_aesttmp:={}
				aadd(_aesttmp,{"COMP"   ,"C",15,0})
				aadd(_aesttmp,{"DESC"   ,"C",40,0})
				aadd(_aesttmp,{"NECES"  ,"N",16,5})
				aadd(_aesttmp,{"SALDO"  ,"N",16,5})
				aadd(_aesttmp,{"QUARENT","N",16,5})
				aadd(_aesttmp,{"LOTE"	,"C",TamSX3("B8_LOTECTL")[1],0})
				//			aadd(_aesttmp,{"POTENC" ,"N",05,2})

				_carqtmp1:=criatrab(_aesttmp,.t.)
				dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)

				_aesttmp:={}
				aadd(_aesttmp,{"COMP" ,"C",15,0})
				aadd(_aesttmp,{"NECES","N",16,2})

				_carqtmp2:=criatrab(_aesttmp,.t.)

				dbusearea(.t.,,_carqtmp2,"TMP2",.f.,.f.)

				_cindtmp2:=criatrab(,.f.)
				_cchave  :="COMP"
				tmp2->(indregua("TMP2",_cindtmp2,_cchave,,,"Selecionando registros..."))

				_carqbat:="batch"+sm0->m0_codigo+"0.op"
				if file(_carqbat)
					_nordant:=sc2->(indexord())
					_nregant:=sc2->(recno())

					dbusearea(.t.,,_carqbat,"BATCH",.t.,.f.)

					batch->(dbgotop())
					while ! batch->(eof())
						MsgAlert(BATCH->OP + "-" + BATCH->OK + "-" + BATCH->OR + "-" + BATCH->USUARIO + "-" + BATCH->FUNNAME)
						sc2->(dbsetorder(1))
						sc2->(dbseek(_cfilsc2+substr(batch->op,3,11)))
						sb1->(dbsetorder(1))
						sb1->(dbseek(_cfilsb1+sc2->c2_produto))
						sg1->(dbsetorder(1))
						sg1->(dbseek(_cfilsg1+sc2->c2_produto))

						_nqbbat   :=sb1->b1_qb
						_nquantbat:=sc2->c2_quant
						while ! sg1->(eof()) .and.;
						sg1->g1_filial==_cfilsg1 .and.;
						sg1->g1_cod==sc2->c2_produto

							sb1->(dbsetorder(1))
							sb1->(dbseek(_cfilsb1+sg1->g1_comp))
							if .Not. (sb1->b1_tipo $ "BN/MO" .Or. AllTrim(sb1->b1_cod) $ GetMV("MV_PRODEXC"))
								_nneces:=(sg1->g1_quant/_nqbbat)*_nquantbat
								if ! tmp2->(dbseek(sg1->g1_comp))
									tmp2->(dbappend())
									tmp2->comp :=sg1->g1_comp
									tmp2->neces:=_nneces
									// tmp2->potenc:= sg1->g1_potenci
								else
									tmp2->neces+=_nneces
								endif
							endif
							sg1->(dbskip())
						end
						batch->(dbskip())
					end
					batch->(dbclosearea())
				endif

				dbselectarea("TMP1")

				_calcnec(m->c2_produto,_nqbop,_nqtdprod)

				tmp1->(dbgotop())
				if ! tmp1->(eof())
					_lok:=.f.

					_acampos:={}
					aadd(_acampos,{"COMP"   ,"Codigo"     ,                        ,15,0})
					aadd(_acampos,{"DESC"   ,"Descricao"  ,                        ,40,0})
					aadd(_acampos,{"NECES"  ,"Necessidade","@E 9,999,999,999.99999",16,5})
					aadd(_acampos,{"SALDO"  ,"Saldo"      ,"@E 9,999,999,999.99999",16,5})
					aadd(_acampos,{"QUARENT","Quarentena" ,"@E 9,999,999,999.99999",16,5})
					aadd(_acampos,{"LOTE"	,"Lote"		  ,						   ,TamSX3("B8_LOTECTL")[1],0})
					//				aadd(_acampos,{"POTENC" ,"Potencia"   ,"@E 9,999.99"           ,05,2})

					@ 000,000 to 280,600 dialog odlg1 title "Materiais com saldo insuficiente"
					@ 002,002 to 120,298 browse "TMP1" fields _acampos

					@ 125,250 bmpbutton type 1 action close(odlg1)

					activate dialog odlg1 centered
				endif
				_cindtmp2+=tmp2->(ordbagext())
				tmp1->(dbclosearea())
				tmp2->(dbclosearea())
				ferase(_carqtmp1+getdbextension())
				ferase(_carqtmp2+getdbextension())
				ferase(_cindtmp2)
			endif
		endif
	endif
	restarea(_aarea)
return(_lok)

static function _calcnec(_cproduto,_nqb,_nquant)
	Local cOpcn := ""

	sg1->(dbsetorder(1))
	sg1->(dbseek(_cfilsg1+_cproduto))
	while ! sg1->(eof()) .and.;
	sg1->g1_filial==_cfilsg1 .and.;
	sg1->g1_cod==_cproduto

		sb1->(dbsetorder(1))
		sb1->(dbseek(_cfilsb1+sg1->g1_comp))
		if .Not. (sb1->b1_tipo $ "BN/MO" .Or. AllTrim(sb1->b1_cod) $ GetMV("MV_PRODEXC"))

			_nneces:=(sg1->g1_quant/_nqb)*_nquant
			if ! tmp2->(dbseek(sg1->g1_comp))
				tmp2->(dbappend())
				tmp2->comp :=sg1->g1_comp
				tmp2->neces:=_nneces
				//tmp2->potenc:= sg1->g1_potenci
			else
				tmp2->neces+=_nneces
			endif
		endif
		sg1->(dbskip())
	end

	//-- Trata grupo de produtos opcionais
	cQry :=  "SELECT "
	cQry +=  "  SG1.G1_COMP                                         COMP, "
	cQry +=  "  SG1.G1_GROPC                                        GROPC, "
	cQry +=  "  SG1.G1_OPC                                          OPC, "
	cQry +=  "  SUM(SBF.BF_QUANT - SBF.BF_EMPENHO)                  SALDO "
	cQry +=  "FROM SG1010 SG1 "
	cQry +=  "  INNER JOIN SBF010 SBF ON SBF.BF_PRODUTO = SG1.G1_COMP AND SBF.D_E_L_E_T_ <> '*' "
	cQry +=  "WHERE SG1.D_E_L_E_T_ <> '*' "
	cQry +=  "      AND SG1.G1_FILIAL = '"+ xFilial("SG1") +"' "
	cQry +=  "      AND SG1.G1_COD = '"+ _cproduto +"' "
	cQry +=  "      AND SG1.G1_GROPC <> ' ' "
	cQry +=  "GROUP BY SG1.G1_COMP, SG1.G1_GROPC, SG1.G1_OPC "
	cQry +=  "ORDER BY SG1.G1_GROPC, SG1.G1_OPC "
	cQry := ChangeQuery(cQry)

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	TcQuery cQry New Alias "QRY"

	tmp2->(dbgotop())
	while ! tmp2->(eof())
		QRY->(dbgotop())
		while ! QRY->(eof())
			If tmp2->comp = QRY->COMP .And. QRY->SALDO >= tmp2->neces
				cOpcn += QRY->GROPC + "/"
			EndIf

			QRY->(DbSkip())
		EndDo

		tmp2->(DbSkip())
	EndDo

	tmp2->(dbgotop())
	while ! tmp2->(eof())
		sb1->(dbsetorder(1))
		sb1->(dbseek(_cfilsb1+tmp2->comp))

		if SB1->B1_TIPO <> "PI"

			sg1->(dbsetorder(2))
			If sg1->(dbseek(_cfilsg1+tmp2->comp+_cproduto))
				// Avalia se um dos produtos opcionais atende a requisicão
				If Empty(sg1->g1_comp) .Or. (!Empty(sg1->g1_comp) .And. !sg1->g1_gropc $ cOpcn)
					sb2->(dbsetorder(1))
					if sb2->(dbseek(_cfilsb2+tmp2->comp+sb1->b1_locpad))
						_nsaldo:= saldosb2() - SB2->B2_XEMPWMS
						if _nsaldo<0
							_nsaldo:=0
						endif
					else
						_nsaldo:=0
					endif
					if _nsaldo < tmp2->neces
						sb2->(dbsetorder(1))
						if sb2->(dbseek(_cfilsb2+tmp2->comp+_cloccq))
							_nquarent:=saldosb2()
							if _nquarent<0
								_nquarent:=0
							endif
						else
							_nquarent:=0
						endif
						tmp1->(dbappend())
						tmp1->comp   :=tmp2->comp
						tmp1->desc   :=sb1->b1_desc
						tmp1->neces  :=tmp2->neces
						tmp1->saldo  :=_nsaldo
						tmp1->quarent:=_nquarent
						tmp1->lote	 := ""
					EndIf
				EndIf
			endif

		else //PI

			//verifico se tem SB8 que atenda a necessidade
			_cquery:=" SELECT R_E_C_N_O_ RECNOB8, (B8_SALDO-B8_EMPENHO) SALDOB8 "
			_cquery+=" FROM " + retsqlname("SB8")+" SB8"
			_cquery+=" WHERE SB8.D_E_L_E_T_=' '"
			_cquery+=" AND B8_FILIAL='"+xFilial("SB8")+"'"
			_cquery+=" AND B8_PRODUTO='"+tmp2->comp+"'"
			_cquery+=" AND B8_LOCAL='"+sb1->b1_locpad+"'"
			_cquery+=" AND (B8_SALDO-B8_EMPENHO) > 0 "
			_cquery+="ORDER BY SALDOB8 DESC "

			_cquery:=changequery(_cquery)

			tcquery _cquery new alias "TMP3"

			tcsetfield("TMP3","SALDOB8","N",15,2)

			tmp3->(dbgotop())

			While tmp3->(!Eof())

				//se o saldo atende, ja saio do laço pq ta ok
				if tmp3->saldob8 >= tmp2->neces
					EXIT
				else

					SB8->(DbGoTo(tmp3->RECNOB8))

					//vejo saldo em quarentena
					sb8->(dbsetorder(3)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
					if sb8->(dbseek(xFilial("SB8")+tmp2->comp+_cloccq+SB8->B8_LOTECTL))
						_nquarent := SB8->(B8_SALDO-B8_EMPENHO)
						if _nquarent<0
							_nquarent:=0
						endif
					else
						_nquarent:=0
					endif

					SB8->(DbGoTo(tmp3->RECNOB8))

					tmp1->(dbappend())
					tmp1->comp   := tmp2->comp
					tmp1->desc   := sb1->b1_desc
					tmp1->neces  := tmp2->neces
					tmp1->saldo  := tmp3->saldob8
					tmp1->quarent:= _nquarent
					tmp1->lote	 := SB8->B8_LOTECTL

				endif

				tmp3->(dbSkip())
			enddo

			tmp3->(dbclosearea())
		endif

		tmp2->(dbskip())
	end
return

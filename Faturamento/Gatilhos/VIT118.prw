#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} VIT265

Gatilho para alimentar preço de lista com preço fábrica

Gatilho: SC6->C6_PRODUTO

@type  Function
@author André A. Alves
@since 12/11/2018
@version 1.0
@return nValor
/*/
User Function VIT118()
	Local nValor := 0

	_cfilsf4:=xfilial("SF4")
	sf4->(dbsetorder(1))
	if ! m->c5_tipo$"BD"
		_cfilsa1:=xfilial("SA1")
		_cfilsb1:=xfilial("SB1")
		_cfilz28:=xfilial("Z28")
		_cfilsx5:=xfilial("SX5")
		cProduto := aCols[n][2]
		sa1->(dbsetorder(1))
		sb1->(dbsetorder(1))
		z28->(dbsetorder(1))
		sx5->(dbsetorder(1))
		sa1->(dbseek(_cfilsa1+m->c5_cliente+m->c5_lojacli))			
		sb1->(dbseek(_cfilsb1+cProduto))
		If z28->(dbseek(_cfilz28+cProduto))
			If Alltrim(sb1->b1_categ) == "O"
				nValor := z28->z28_preco
			Else
				if sa1->a1_est=="MG" .OR. sa1->a1_est=="SP"
					If Alltrim(sb1->b1_tpprod) == "0" //Similar
						nValor := z28->z28_pfic18
					ElseIf Alltrim(sb1->b1_tpprod) == "1" // Generico
						nValor := z28->z28_pfic12
					EndIf
				else 
					//Z28_PFIC19, Z28_PFIC12, Z28_PFIC18, Z28_PFIC17, Z28_PFIC75, Z28_PFIC20
					If sx5->(dbseek(_cfilsx5+"Z4"+sa1->a1_est))

						//Stephen Noel de melo - 28/11/2018 - Tratar Zona Franca

						If !Empty(SA1->A1_SUFRAMA)
							If Alltrim(sx5->x5_descri) == "17" .and. SA1->A1_EST $ ("AC-RR")
								nValor := z28->Z28_PFZF17
							ElseIf Alltrim(sx5->x5_descri) == "17.5" .and. SA1->A1_EST = "RO"
								nValor := z28->Z28_PFZ175
							ElseIf Alltrim(sx5->x5_descri) == "18" .and. SA1->A1_EST $ ("AM-AP")
								nValor := z28->Z28_PFZF18
							EndIf
						Else
							If Alltrim(sx5->x5_descri) == "12"
								nValor := z28->z28_pfic12
							ElseIf Alltrim(sx5->x5_descri) == "17"
								nValor := z28->Z28_PFIC17
							ElseIf Alltrim(sx5->x5_descri) == "17.5"
								nValor := z28->Z28_PFIC75
							ElseIf Alltrim(sx5->x5_descri) == "18"
								nValor := z28->Z28_PFIC18
								//                    ElseIf Alltrim(sx5->x5_descri) == "16"
								//                      nValor := z28->Z28_PFIC17
							ElseIf Alltrim(sx5->x5_descri) == "20"
								nValor := z28->Z28_PFIC20
							EndIf
						EndIf
					EndIF
				endif
			EndIF
		EndIf
	endif
Return(nValor)
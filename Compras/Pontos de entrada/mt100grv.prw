#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} MT100GRV
Ponto de Entrada na Confirmacao de Gravacao do Documento
de Entrada

@author Alex Junio de Miranda
@since 01/04/11
@version 1.0

@type function
/*/
User Function MT100GRV()
	Local nI
	Local aItens     := {}
	Local lExp01 	 := PARAMIXB[1]
	Local nPosUM 	 := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_UM'})
	Local nPosNumPC  := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_PEDIDO'})
	Local nPosItemPC := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_ITEMPC'})
	Local nPosItem 	 := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_ITEM'})
	Local nPosProd   := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_COD'})
	Local nPosDesc   := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_DESCPRO'})
	Local nPosQuant  := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_QUANT'})
	Local nPosVUnit  := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_VUNIT'})
	Local nPosTotal  := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_TOTAL'})
	Local nPosLoteC  := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_LOTECTL'})
	Local nPosLoteF  := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_LOTEFOR'})
	Local nPosTrans  := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_XTRANSP'})
	Local nPosFabri  := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_XFABRIC'})
	Local nPosUserI  := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_USERLGI'})
	Local nPosUserA  := AScan(aHeader, {|x| alltrim(x[2]) == 'D1_USERLGA'})

	//if lExp01 //Se for exclusão não envia o WorkFlow
	//	Return(.t.)
	//endif

	if sm0->m0_codigo=="01"
		_aArea    	:= Getarea()
		_aAreaSB1 	:= SB1->(GetArea())
		_cFilSB1	:=	xfilial("SB1")

		for nI := 1 to Len(aCols)
			SB1->(dbsetorder(1))
			SB1->(dbseek(_cFilSB1+aCols[nI][nPosProd]))

			if SB1->( B1_TIPO $ '/MP/EE/EN/' )
				cUserLgi := Embaralha(SF1->F1_USERLGI, 1)
				cUserLga := Embaralha(SF1->F1_USERLGA, 1)

				AAdd(aItens, { 	aCols[nI][nPosItem] 													,;
				aCols[nI][nPosProd] 													,;
				aCols[nI][nPosDesc] 													,;
				aCols[nI][nPosUM] 														,;
				aCols[nI][nPosQuant]													,;
				aCols[nI][nPosLoteC]													,;
				aCols[nI][nPosLoteF]													,;
				aCols[nI][nPosNumPC]													,;
				aCols[nI][nPosItemPC]													,;
				aCols[nI][nPosTrans]													,;
				Posicione("SA4", 1, XFilial("SA4")+aCols[nI][nPosTrans], "A4_NOME")		,;
				aCols[nI][nPosFabri]													,;
				Posicione("Z55", 1, XFilial("Z55")+aCols[nI][nPosFabri], "Z55_NOME")    ,;
				cUserLgi                                                                ,;
				cUserLga                                                                })

			endif
		next nI

		SB1->(RestArea(_aAreaSB1))
		RestArea(_aArea)
	endif

	if Len(aItens) > 0
		u_Vit623(CNFISCAL , CSERIE , CA100FOR, CLOJA, aItens)
	endif

return( .t. )
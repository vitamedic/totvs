#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function MT103FIM()
	Local nOpcao := PARAMIXB[1] // Op��o Escolhida pelo usuario no aRotina
	Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a opera��o de grava��o da NFE
	Private _data := CTOD("    /    /   ")
	Private _doc  := ""
	Private _for  := ""
	Private _loja := ""
	Private _serie := ""

	//-- Corre��o tempor�ria devido a fonte anterior desatualizado (Nat� Santos - 20180201)
	PutMV("MV_DISTAUT","")

	If nConfirma == 1 .and. nOpcao == 3

		_doc   := sf1->f1_doc
		_serie := sf1->f1_serie
		_for   := sf1->f1_fornece
		_loja  := sf1->f1_loja
		_data  := sf1->f1_emissao

		If MsgYesNo("Deseja imprimir o EMS ? ","ATEN��O")

			Processa({|| U_vit425()})
		Else
			MSGINFO("O EMS n�o ser� impresso !!!")
		EndIf

	EndIf
Return 
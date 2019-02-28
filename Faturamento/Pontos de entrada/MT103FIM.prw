#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function MT103FIM()
	Local nOpcao := PARAMIXB[1] // Opção Escolhida pelo usuario no aRotina
	Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFE
	Private _data := CTOD("    /    /   ")
	Private _doc  := ""
	Private _for  := ""
	Private _loja := ""
	Private _serie := ""

	//-- Correção temporária devido a fonte anterior desatualizado (Natã Santos - 20180201)
	PutMV("MV_DISTAUT","")

	If nConfirma == 1 .and. nOpcao == 3

		_doc   := sf1->f1_doc
		_serie := sf1->f1_serie
		_for   := sf1->f1_fornece
		_loja  := sf1->f1_loja
		_data  := sf1->f1_emissao

		If MsgYesNo("Deseja imprimir o EMS ? ","ATENÇÃO")

			Processa({|| U_vit425()})
		Else
			MSGINFO("O EMS não será impresso !!!")
		EndIf

	EndIf
Return 
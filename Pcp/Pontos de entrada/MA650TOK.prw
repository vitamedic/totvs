#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"


/*/{Protheus.doc} MA650TOK
	PE -  No tudo OK da tela de inclus�o
	N�o permitir mais de uma OP por vez.
	garantir que somente uma OP seja inclu�da por vez, afim de
	garantir o saldo dos materiais para empenho 
@author Microsiga
@since 12/12/2017
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MA650TOK()

	Local MV_XESPOP := SuperGetMV("MV_XESPOP", .f., "N") //Trata copia das OP�s na explosao para o Evolutio
	Local lRet 		:= .t.

	If MV_XESPOP == "S" .and. Type("__nCtrOps") <> "U"
		If __nCtrOps > 0
			lRet := .f.
			MsgStop("N�o � permitido incluir mais de uma Ordem de Produ��o por vez" + CRLF + "Feche a tela para que os empenhos dos materiais seja garantidos.", "A t e n � � o")
		Else
			__nCtrOps++
		EndIf
	EndIf

Return( lRet )
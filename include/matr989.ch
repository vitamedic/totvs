#ifdef SPANISH
	#define STR0001 "Saldo en Proceso (Analitico)"
	#define STR0002 "Emision del Saldo en Proceso Analitico. Los valores totales se imprimiran de acuerdo con "
	#define STR0003 "requisiciones y devoluciones para orden de produccion que tiene saldo pendiente."
	#define STR0004 "Nota: Saldo en Proceso solamente en requisiciones manuales."
	#define STR0005 "CODIGO"
	#define STR0006 "UM"
	#define STR0007 "LOCAL"
	#define STR0008 "ORDEN"
	#define STR0009 "PRODUCCION"
	#define STR0010 "CANT. EN"
	#define STR0011 "VALOR EN"
	#define STR0012 "PROCESO"
	#define STR0013 "DESCRIPCION"
	#define STR0014 "TOTAL GENERAL"
	#define STR0015 "ATENCION"
	#define STR0016 "Al modificar el deposito, el costo medio unificado no se considerara."
	#define STR0017 "Confirma"
	#define STR0018 "Salir"
	#define STR0019 "TIPO"
	#define STR0020 "RE/DE"
#else
	#ifdef ENGLISH
		#define STR0001 "Processing Balance (Detailed)"
		#define STR0002 "Generation of detailed Process Balance. Total values will be printed according "
		#define STR0003 "to the requisitions and returns to the production order with pending balance."
		#define STR0004 "Note: Only processing balances in manual requisitions."
		#define STR0005 "CODE"
		#define STR0006 "MU"
		#define STR0007 "LOCATION"
		#define STR0008 "ORDER"
		#define STR0009 "PRODUCTION"
		#define STR0010 "QTY IN"
		#define STR0011 "VALUE IN"
		#define STR0012 "PROCESS"
		#define STR0013 "DESCRIPTION"
		#define STR0014 "GRAND TOTAL"
		#define STR0015 "ATTENTION"
		#define STR0016 "When changing the warehouse, the unified average cost will not be considered."
		#define STR0017 "Confirm"
		#define STR0018 "Quit"
		#define STR0019 "TYPE"
		#define STR0020 "REC/RET"
	#else
		Static STR0001 := "Saldo em Processo (Analitico)"
		Static STR0002 := "Emissäo do Saldo em Processo Analitico. Os valores totais serao impressos conforme "
		Static STR0003 := "requisições e devoluções para ordem de produção que possuem saldo em aberto."
		Static STR0004 := "Nota: Saldo em Processo somente em requisiçöes manuais."
		Static STR0005 := "CODIGO"
		Static STR0006 := "UM"
		Static STR0007 := "LOCAL"
		Static STR0008 := "ORDEM"
		Static STR0009 := "PRODUÇÃO"
		Static STR0010 := "QTDE EM"
		Static STR0011 := "VALOR EM"
		Static STR0012 := "PROCESSO"
		Static STR0013 := "DESCRIÇÃO"
		Static STR0014 := "TOTAL GERAL"
		Static STR0015 := "ATENÇÃO"
		Static STR0016 := "Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."
		#define STR0017  "Confirma"
		Static STR0018 := "Abandona"
		Static STR0019 := "TIPO"
		Static STR0020 := "RE/DE"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Saldo em processo (analitico)"
			STR0002 := "Emissão do saldo em processo analitico. os valores totais serão impressos conforme "
			STR0003 := "Requisições e devoluções para ordem de produção  que possuem saldo em aberto."
			STR0004 := "Nota: saldo em processo somente em requisições manuais."
			STR0005 := "Código"
			STR0006 := "Um"
			STR0007 := "Local"
			STR0008 := "Ordem"
			STR0009 := "Produção"
			STR0010 := "Qtde Em"
			STR0011 := "Valor Em"
			STR0012 := "Processo"
			STR0013 := "Descrição"
			STR0014 := "Total Crial"
			STR0015 := "Atenção"
			STR0016 := "Ao alterar o almoxarifado o custo médio unificado será desconsiderado."
			STR0018 := "Abandonar"
			STR0019 := "Tipo"
			STR0020 := "Re/de"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF

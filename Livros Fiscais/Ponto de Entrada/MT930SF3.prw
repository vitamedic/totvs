#INCLUDE "rwmake.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT930SF3  ³Autor ³ Edson Gomes Barbosa ³Data ³  26/11/04   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Ponto de Entrada para Alteraco do SF3 Colocando na Coluna  ³±±
±±³          ³ Obs.                                                       ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ MATA930 (Reprocessamento do Livro)                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function MT930SF3
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cString := ""
_nRecSF3  := SF3->(Recno())

if mv_par03==1 // Reprocessa entrada
	if !sf3->(dbseek(xfilial("SF3")+ma930grvq1->(dtos(f1_dtdigit)+f1_doc+f1_serie+f1_fornece+f1_loja)))
		Return()
	endif
	
	if alltrim(ma930grvq1->F1_ESPECIE)$"CTR/CTE"
		sf8->(dbSetOrder(3))
		//F8_FILIAL+F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN
		if sf8->(Dbseek(xFilial("SF8")+ma930grvq1->(f1_doc+f1_serie+f1_fornece+f1_loja)))
			cCondSF8:= "SF8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN) == '"+ma930grvq1->(f1_doc+f1_serie+f1_fornece+f1_loja)+"'"
			while !sf8->(eof()) .and. &cCondSF8
				//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
				_nSavRec  := SD1->(Recno())
				if sd1->(Dbseek(xFilial("SD1")+SF8->(f8_nforig+f8_serorig+f8_fornece+f8_loja)))
					cString:="REF NF "+SF8->F8_NFORIG+" ("+SD1->D1_CF+") "+dtoc(SD1->D1_DTDIGIT)
				endif
				sd1->(dbgoto(_nSavRec))
				sf8->(dbskip())
			end
		endif
		sf8->(dbSetOrder(1))
	else
		_nRecSD1  := SD1->(Recno())
		if sd1->(Dbseek(xFilial("SD1")+ma930grvq1->(f1_doc+f1_serie+f1_fornece+f1_loja)))
			do case
				case "104081"$SD1->D1_cod
					cString := "CONSTRUCAO - PORTARIA"
				case "104467"$SD1->D1_cod
					cString := "CONSTRUCAO - VESTIARIO"
				case "104427"$SD1->D1_cod
					cString := "CONSTRUCAO - ADM"
				case "103565"$SD1->D1_cod
					cString := "CONSTRUCAO - PRODUTO ACABADO"
				case "103850"$SD1->D1_cod
					cString := "CONSTRUCAO - SOLIDOS"
				case "104416"$SD1->D1_cod
					cString := "CONSTRUCAO - AMP. MANUTENCAO"
				case "104281"$SD1->D1_cod
					cString := "CONSTRUCAO - SEMI S./LIQUIDOS"
			endcase
		endif
		sd1->(dbgoto(_nRecSD1))
	endif
endif

if !empty(cString)
	RecLock("SF3",.F.)
	SF3->F3_OBSERV:=cString
	MsUnlock()
endif

sf3->(dbgoto(_nRecSF3))
return()

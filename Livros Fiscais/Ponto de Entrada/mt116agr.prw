#INCLUDE "rwmake.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT116AGR  ³Autor ³ Edson Gomes Barbosa ³Data ³  26/11/04   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Ponto de Entrada para Alteracao do SF3 Colocando na Coluna ³±±
±±³          ³ Obs.                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AP6 IDE                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function MT116AGR


Private cString := ""

SF8->(dbSetOrder(3))
If sf8->(Dbseek(xFilial("SF8")+sf1->(f1_doc+f1_serie+f1_fornece+f1_loja)))
	cCondSF8:= "SF8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN) == '"+sf1->(f1_doc+f1_serie+f1_fornece+f1_loja)+"'"
	While !sf8->(eof()) .and. &cCondSF8
		//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
   	_nSavRec  := SD1->(Recno())
  		If sd1->(Dbseek(xFilial("SD1")+SF8->(f8_nforig+f8_serorig+f8_fornece+f8_loja)))
        	cString:="REF NF "+SF8->F8_NFORIG+" ("+SD1->D1_CF+") "+dtoc(SD1->D1_DTDIGIT)	
		Endif
		SD1->(dBgoto(_nSavRec))
        sf8->(dbskip())
  	End
Endif	
SF8->(dbSetOrder(1))
If !Empty(cString)
	SF3->(RECLOCK("SF3",.f.))
	SF3->F3_OBSERV:=cString
	SF3->(MSUNLOCK())	
Endif
Return()
#INCLUDE "rwmake.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MT116AGR  矨utor � Edson Gomes Barbosa 矰ata �  26/11/04   潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Ponto de Entrada para Alteracao do SF3 Colocando na Coluna 潮�
北�          � Obs.                                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � AP6 IDE                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
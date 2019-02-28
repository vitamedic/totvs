#include 'protheus.ch'
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATA410  ³ Autor ³ Stephen Noel de Melo³   DATA ³21/07/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada Alimentar a nota com dados da pesagem     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function  SF2460I() 
	If sf2->f2_transp $ "000123/000124"	
		DbSelectArea("SF8")
		DbSetOrder(5) //F8_FILIAL+F8_TIPONF+F8_NFORIG+F8_SERORIG (INDICE 5 )
		If !DbSeek(xFilial("SF8")+"S"+_cdoc)
			RECLOCK("SF8",.T.)
			SF8->F8_FILIAL  	:= xFilial("SF8")
			SF8->F8_NFDIFRE    := sf2->f2_doc //cNumCte
			SF8->F8_SEDIFRE   	:= sf2->f2_serie //cSerieCte 
			SF8->F8_DTDIGIT  	:= dDatabase
			SF8->F8_TRANSP  	:= sf2->f2_transp  //TRANSPORTADOR
			SF8->F8_LOJTRAN    := "01" //cLojaFor	 
			SF8->F8_NFORIG  	:= sf2->f2_doc 	
			SF8->F8_SERORIG    := sf2->f2_serie
			SF8->F8_FORNECE  	:= sf2->f2_cliente
			SF8->F8_LOJA		:= sf2->f2_loja 
			SF8->F8_DTPREV  	:= dDatabase 
			SF8->F8_TPFRETE  	:= "FP" //Frete Proprio
			SF8->F8_TIPONF  	:= "S"
			MSUNLOCK() 
		EndIf
	EndIf
	DbSelectArea("SC5")
	sc5->(dbsetorder(1))
	If sc5->(dbseek(xFilial("SC5")+sd2->d2_pedido))
		sc5->(reclock("SC5",.f.))
		sc5->c5_transp:=sf2->f2_transp
		sc5->(msunlock())
	Endif
Return()

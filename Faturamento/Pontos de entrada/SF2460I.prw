#include 'protheus.ch'
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MATA410  � Autor � Stephen Noel de Melo�   DATA �21/07/2018潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de Entrada Alimentar a nota com dados da pesagem     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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

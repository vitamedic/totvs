/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VITPAG02  � Autor � Leonir Teodoro     � Data �  10/05/02  潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Converter Linha Digitavel do Titulo em Codigo de Barras.   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function VitPag02

Local _Linha   := ""
Local _Codigo  := ""
Local _Dv		:= ""
Local _Tot		:= 0
Local _Peso		:= 5
Local i

_Linha	:= AllTrim(M->E2_CODLIN)
//_cValor := SubStr(_linha,Len(_linha)-9,10)
//_nValor := val(_cValor)/100
//If _nValor <> SE2->E2_VALOR
//   _cErro := "Erro no valor do codigo de barra!!!" + Chr(13) + "(Valor Cod. = "+Alltrim(Str(_nValor))+ ") e (Valor Tit = "+Alltrim(Str(SE2->E2_VALOR))+")"
//   MsgAlert(_cErro)
//EndIf        


_Linha	+= Replicate("0",30)
_Codigo	:= Left(_Linha,4)  			// Banco e Moeda.
_Codigo 	+= SubStr(_Linha,33,15)  	//DV Codigo Barras + Fator Vencimento + Valor.
_Codigo 	+= SubStr(_Linha,5,5)	 	//Campo Livre Parte 1.
_Codigo 	+= SubStr(_Linha,11,10)	 	//Campo Livre Parte 2.
_Codigo 	+= SubStr(_Linha,22,10)	 	//Campo Livre Parte 3.


	// Valida o valor do codigo de barra
	// Analista: Nelson Henrique           

For i := 1 to 44
	If i <> 5
		If _Peso == 2
			_Peso := 9
		Else
			_Peso += -1
		EndIf
		_Tot 	+= Val(SubStr(_Codigo,i,1)) * _Peso
	EndIf
Next

_Dv := 11 - Int(_Tot%11)

If _Dv < 1 .or. _Dv > 9
	_Dv := 1
EndIf

//msgstop(StrZero(_Dv,1))
//msgstop(SubStr(_Codigo,5,1))
If StrZero(_Dv,1) <> SubStr(_Codigo,5,1)
	Alert("Codigo de Barras Invalido..." + Chr(13) + "Verifique a informa玢o digitada.")
//	_Codigo 	:= ""
EndIf

Return(_Codigo)

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  砎itPag03  � Autor � Leonir Teodoro     � Data �  17/05/02   潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Valida o C骴igo de Barras na Geracao do Arquivo de         潮�
北�          � Comunicacao Bancaria                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

Function U_VitPag03(_cTexto)
  Local _cRet
  Local _Codigo  := ""
  Local _Dv		:= ""
  Local _Tot		:= 0
  Local _Peso		:= 5
  Local i

	_Codigo	:= AllTrim(SE2->E2_CODBAR)   
   
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
	   
   If StrZero(_Dv,1) <> SubStr(_Codigo,5,1) .Or. Empty(_Codigo)
      Alert("Codigo de Barras Vazio ou Invalido no titulo "+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+" ." ;
            + Chr(13) + "Verifique este titulo e crie o arquivo novamente.")
   EndIf

   _cRet	:= _cTexto
   
 Return (_cRet)
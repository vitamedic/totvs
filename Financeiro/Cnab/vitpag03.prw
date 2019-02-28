/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VitPag03  ³ Autor ³ Leonir Teodoro     ³ Data ³  17/05/02   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Valida o Código de Barras na Geracao do Arquivo de         ³±±
±±³          ³ Comunicacao Bancaria                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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
#include "Protheus.ch"
#include "Rwmake.ch"
#include "Ap5Mail.ch"
#include "TopConn.ch"           

User Function MT116TOK()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÛÛÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿ÛÛ
ÛÛ³Programa  ³ MT116TOK    ³Autor ³ LUIZ FERNANDO SACRAMENTO FIUZA        ³ÛÛ
ÛÛÃÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ÛÛ
ÛÛ³Descricao ³ Ponto de entrada para inclusao de CTE manualmente rotina   ³ÛÛ
ÛÛ³          ³ MATA116 Validar Chave                                      ³ÛÛ
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitamedic SigaEst Versao 4.07 SQL          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/      

Local _uf := " "
Default cTipo		:= "N"
Private _aArea		:= GetArea()
Private _aArC7		:= SC7->(GetArea())
Private _aArF4		:= SF4->(GetArea())
Private _lRet		:= .T.
Private _cufo := posicione("SA2",1,xFilial("SA2")+CA100FOR+CLOJA,"A2_EST")

If AllTrim(CESPECIE) $ "SPED/CTE" // .AND. ALLTRIM(cFormul) <> "S" .AND. !ALLTRIM(cTipo) $ "C/I"  //.AND. ALLTRIM(cTipo)<> "I"  

    _cFornece	:= CA100FOR 
	_cLoja		:= CLOJA 
	_cSerie     := CSERIE
	_CHAVE := M->F1_CHVNFE
	msgalert(_cufo+"-"+CA100FOR+"-"+CLOJA)
	Do case
		case _cufo = "RO"
			_uf := "11"
		case _cufo = "AC"
			_uf := "12"
		case _cufo = "AM"
			_uf := "13"
		case _cufo = "RR"
			_uf := "14"
		case _cufo ="PA"
			_uf := "15"
		case _cufo ="AP"
			_uf := "16"
		case _cufo ="TO"
			_uf := "17"
		case _cufo ="MA"
			_uf := "21"
		case _cufo ="PI"
			_uf := "22"
		case _cufo ="CE"
			_uf := "23"
		case _cufo ="RN"
			_uf := "24"
		case _cufo ="PB"//CUFORIG
			_uf := "25"
		case _cufo ="PE"
			_uf := "26"
		case _cufo ="AL"
			_uf := "27"
		case _cufo ="SE"
			_uf := "28"
		case _cufo ="BA"
			_uf := "29"
		case _cufo ="MG"
			_uf := "31"
		case _cufo ="ES"
			_uf := "32"
		case _cufo ="RJ"
			_uf := "33"
		case _cufo ="SP"
			_uf := "35"
		case _cufo ="PR"
			_uf := "41"
		case _cufo ="SC"
			_uf := "42"
		case _cufo ="RS"
			_uf := "43"
		case _cufo ="MS"
			_uf := "50"
		case _cufo ="MT"
			_uf := "51"
		case _cufo ="GO"
			_uf := "52"
		case _cufo ="DF"
			_uf := "53"
	EndCase
	
	IF SUBSTR(_CHAVE,1,2) <> _uf     //VALIDA O UF COM A CHAVE
		MSGINFO("Estado incorreta conforme Chave")
		_lRet := .F.
	End
	
	IF SUBSTR(_CHAVE,26,9) <> CNFISCAL  //VALIDA A NOTA COM A CHAVE
		MSGINFO("Nota Fiscal incorreta conforme Chave")
		_lRet := .F.
	End
	
	IF AllTrim(cTipo) $ "BD"  
		
		_CNPJ:= POSICIONE("SA1",1,XFILIAL("SA1")+CA100FOR+CLOJA,"A1_CGC")
		IF SUBSTR(_CHAVE,7,14) <> "30222814000131"
			IF SUBSTR(_CHAVE,7,14) <> _CNPJ  //VALIDA O CNPJ COM A CHAVE
				MSGINFO("CNPJ incorreto conforme Chave")
				_lRet := .F.
			ENDIF
		End		
	ELSE		
		_CNPJ:= POSICIONE("SA2",1,XFILIAL("SA2")+_cFornece+_cLoja,"A2_CGC")
		
		IF SUBSTR(_CHAVE,7,14) <> _CNPJ  //VALIDA O CNPJ COM A CHAVE
			MSGINFO("CNPJ incorreto conforme Chave")
			_lRet := .F.
		End		
	ENDIF
		
	_DtEmis := AnoMes(DDEMISSAO)
	If SUBSTR(_DtEmis,3,4) <>  SUBSTR(_CHAVE,3,4) //Valida a data de emissão
		MSGINFO("Data de Emissão incorreta conforme Chave")
		_lRet := .F.
	End
	
	IF SUBSTR(_CHAVE,23,3) <> _cSerie  //VALIDA O CNPJ COM A CHAVE
		MSGINFO("Serie Incorreta conforme a Chave")
		_lRet := .F.
	End
	
ENDIF

RestArea(_aArF4)
RestArea(_aArC7)
RestArea(_aArea)
return(_lRet)

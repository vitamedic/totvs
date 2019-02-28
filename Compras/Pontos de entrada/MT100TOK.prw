#include "Protheus.ch"
#include "Rwmake.ch"
#include "Ap5Mail.ch"
#include "TopConn.ch"           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT100TOK ºAutor  ³  Ricardo Moreira   º Data ³  16/08/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Ponto de Entrada para validar a entrada da NF, conforme a  º±±
±±ºDesc.     ³ Chave de acesso da Nota de entrada.						  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gerbras Quimica Farmaceutica                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT100TOK()

Local _uf := " "
Default cTipo		:= "N"
Private nIRRF := MaFisRet(,"NF_VALIRR")      // Ricardo
Private _aArea		:= GetArea()
Private _aArC7		:= SC7->(GetArea())
Private _aArF4		:= SF4->(GetArea())
Private _lRet		:= .T.

//#####VALIDACAO DA CHAVE COM A NOTA 23/03/2016  - INICIO RICARDO MOREIRA

If AllTrim(CESPECIE) $ "SPED/CTE"  .AND. ALLTRIM(cFormul) <> "S" .AND. !ALLTRIM(cTipo) $ "C/I"  //.AND. ALLTRIM(cTipo)<> "I"  

    _cFornece	:= CA100FOR 
	_cLoja		:= CLOJA 
	_cSerie     := CSERIE
	 
	_CHAVE := M->F1_CHVNFE
	
	Do case
		case CUFORIG = "RO"
			_uf := "11"
		case CUFORIG = "AC"
			_uf := "12"
		case CUFORIG = "AM"
			_uf := "13"
		case CUFORIG = "RR"
			_uf := "14"
		case CUFORIG ="PA"
			_uf := "15"
		case CUFORIG ="AP"
			_uf := "16"
		case CUFORIG ="TO"
			_uf := "17"
		case CUFORIG ="MA"
			_uf := "21"
		case CUFORIG ="PI"
			_uf := "22"
		case CUFORIG ="CE"
			_uf := "23"
		case CUFORIG ="RN"
			_uf := "24"
		case CUFORIG ="PB"
			_uf := "25"
		case CUFORIG ="PE"
			_uf := "26"
		case CUFORIG ="AL"
			_uf := "27"
		case CUFORIG ="SE"
			_uf := "28"
		case CUFORIG ="BA"
			_uf := "29"
		case CUFORIG ="MG"
			_uf := "31"
		case CUFORIG ="ES"
			_uf := "32"
		case CUFORIG ="RJ"
			_uf := "33"
		case CUFORIG ="SP"
			_uf := "35"
		case CUFORIG ="PR"
			_uf := "41"
		case CUFORIG ="SC"
			_uf := "42"
		case CUFORIG ="RS"
			_uf := "43"
		case CUFORIG ="MS"
			_uf := "50"
		case CUFORIG ="MT"
			_uf := "51"
		case CUFORIG ="GO"
			_uf := "52"
		case CUFORIG ="DF"
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

//#####VALIDACAO DA CHAVE COM A NOTA 23/03/2016  - FIM RICARDO MOREIRA  

//Validação C.Custo 
//Claudio 27.08.18
if ('MATA103'$FUNNAME() .or. 'MATA116'$FUNNAME()) .and. !cTipo $ "D/"
  //Valida o preenchimento do C.Custo para TES Estoque="N" 
  lRet:=U_ValCCNF2(aCols,aBackColsSDE)  
endif

Return lRet

RestArea(_aArF4)
RestArea(_aArC7)
RestArea(_aArea)

Return(_lRet)

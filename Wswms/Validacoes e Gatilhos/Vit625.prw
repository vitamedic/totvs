#INCLUDE "Protheus.CH" 
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#INCLUDE "TBICONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} Vit625
Rotina Vit625
Validação dos tipos de produtos no cadastro de transportadoras

@author Henrique Corrêa
@since 03/07/2017
@version P11
@return Nil(nulo)
@history

/*/
//------------------------------------------------------------  
User Function Vit625(pCampo, pConteudo)
Local lRet 			:= .t.                
Local _Conteudo     := ""
Local nPos
Local cTipo

Default pCampo 		:= Upper(AllTrim(ReadVar()))
Default pConteudo 	:= &(pCampo)

if "A4_XTPPRDS" $ pCampo .and. !empty(pConteudo)
	_Conteudo := AllTrim(pConteudo)
	do while !empty(_Conteudo)
		nPos  := At(";", _Conteudo)
		
		if nPos == 0
			cTipo 		:= _Conteudo
			_Conteudo 	:= ""
		else
			cTipo 		:= Left(_Conteudo, nPos - 1)
			_Conteudo 	:= SubStr(_Conteudo, nPos+1)
		endif
		
		dbSelectArea("SX5")
		dbSetOrder(1)
		if !dbSeek(XFilial("SX5")+"02"+cTipo)
			msgStop("Tipo ("+cTipo+") não encontrado no cadastro...")
			lRet := .f.
			exit
		endif
	enddo
endif

Return(lRet)
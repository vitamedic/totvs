#INCLUDE "Protheus.CH" 
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#INCLUDE "TBICONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} Vit624
Rotina Vit623
Validação do certificano no cadastro de Produtos x Fornecedores

@author Henrique Corrêa
@since 30/06/2017
@version P11
@return Nil(nulo)
@history

/*/
//------------------------------------------------------------  
User Function Vit624()
Local lRet 		:= .t.
Local _Campo 	:= Upper(AllTrim(ReadVar()))
Local _Conteudo := &(_Campo)
Return(.t.) //Retirado temporáriamente
if SB1->B1_TIPO $ "/EE/EN/MP/PA/SL/EM/PN/IS/ES/PD/ED/ID/"
	if "A5_VALFORN" $ _Campo .and. empty(_Conteudo)
		msgStop("Validade do certificado obrigatório para o tipo do produto relacionado!!!")
		lRet := .f.
	elseif "A5_XCERT1" $ _Campo .and. empty(_Conteudo)
			msgStop("Certificado obrigatório para o tipo do produto relacionado!!!")
			lRet := .f.
	elseif "A5_XFAB1" $ _Campo .and. empty(_Conteudo)
			msgStop("Fabricante obrigatório para o tipo do produto relacionado!!!")
			lRet := .f.        
	elseif "A5_XFAB1" $ _Campo .and. ! ExistCPO("Z55")
			msgStop("Fabricante obrigatório para o tipo do produto relacionado!!!")
			lRet := .f.        
	endif
endif

Return(lRet)
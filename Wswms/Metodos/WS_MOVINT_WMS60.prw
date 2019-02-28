#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � UWSWMS60 �Autor  �Microsiga           � Data �  19/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Metodo WS para processamento do Empenho de OP (SD4, e SDC)  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function UWSWMSX(oDados, oRet)

	Local lOk 		:= .T.     
	Local lExiste 	:= .F.
	Local cMsgErr 	:= ""
	Local cCodProd 	:= ""
	Local cMsgPrd 	:= ""
	Local cArmazem 	:= ""
	Local cLoteCTL  := ""
	Local cOperacao := ""               
	Local nQuant    := 0
	
	Local cTipoMov   := ""
	Local cDocumento := ""
	Local cDocInvR   := ""
	Local cDocInvD   := ""
	
	Local nX := nY := nfor := 0
	
	Local lConsVenc  := GetMV('MV_LOTVENC')=='S'

	Private	lMsErroAuto := .F.
	
	oRet:SITUACAO := .t.
	oRet:MENSAGEM := ""
	
	if empty(oDados:cEmpresa)
		oDados:cEmpresa := "01"
		oDados:cParFil  := "01"
	endif                

	//se n�o foi configurado WS para ja vir logado na empresa e filial, fa�o cria��o do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U' 
		RpcSetType(3)
		lConect := RpcSetEnv(Fil_TpProd:cEmpresa, Fil_TpProd:cFilial)
		if !lConect
			cMsgErr := "N�o foi poss�vel conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif
	
	if lOk .AND. empty(oDados:TIPO_MOV)
		cMsgErr := "Informe o tipo de movimenta��o desejada." + CRLF + "(M)-Movimento interno ou (I)-Invent�rio"
		lOk := .F.
	
	elseif lOk .AND. !(oDados:TIPO_MOV $ ";M;I;")
			cMsgErr := "Informe o tipo de movimenta��o correto." + CRLF + "(M)-Movimento interno ou (I)-Invent�rio"
			lOk := .F.
	else
		cTipoMov  := oDados:TIPO_MOV
    endif

	if lOk .AND. cTipoMov == "M" .AND. !empty(oDados:NUM_OP)
		if empty(Posicione("SC2",1,xFilial("SC2")+alltrim(oDados:NUM_OP),"C2_NUM"))
			cMsgErr := "OP informada n�o foi localizada."
			lOk := .F.  
		elseif !empty(SC2->C2_DATRF)
				cMsgErr := "OP informada ja foi encerrada. A��o n�o permitida."
				lOk := .F.  
		endif
	endif
	
	if lOk .AND. cTipoMov == "M" .AND. !empty(oDados:CC)
		if empty(Posicione("CTT",1,xFilial("CTT")+alltrim(oDados:CC),"CTT_CUSTO"))
			cMsgErr := "Centro de Custo informado n�o foi localizado."
			lOk := .F.  
		elseif alltrim(CTT->CTT_BLOQ) == "1"
				cMsgErr := "Centro de Custo bloqueado. A��o n�o permitida."
				lOk := .F.  
		endif
	endif

	if lOk
		for nX := 1 to len(oDados:PRODUTOS)
			cMsgErr := VldProdutos(oDados:PRODUTOS[nX], nX)
			if !empty(cMsgErr)
				lOk := .F.
				exit
			endif
		next nX
	endif

	//se tudo ok, faz execautos
	if lOK
	    
		BeginTran()

        dbSelectArea("SD3")
        if cTipoMov == "I" 
			cDocumento  := "INVEN" + SubStr(DtoS(dDataBase),3)
        else
			cDocumento	:= IIf(Empty(cDocumento),NextNumero("SD3",2,"D3_DOC",.T.),cDocumento)
			cDocumento	:= A261RetINV(cDocumento)
        endif
        
		aMovs 		:= {}
		
		for nX := 1 to len(oDados:PRODUTOS)                         
		    nQuant    	:= oDados:PRODUTOS[nX]:QTD_DIF
			cCodProd 	:= PadR(oDados:PRODUTOS[nX]:CODIGO,TamSx3("B1_COD")[1])
		    cArmazem 	:= PadR(oDados:PRODUTOS[nX]:ARMAZEM,2)
			cLoteCTL    := PadR(oDados:PRODUTOS[nX]:LOTE,TamSx3("B8_LOTECTL")[1])
			cEndereco   := PadR(oDados:PRODUTOS[nX]:ENDERECO,TamSx3("B7_LOCALIZ")[1])
			cMsgPrd 	:= "Produto/Sequ�ncia ("+AllTrim(cCodProd)+"/"+StrZero(nX,4)+"), "
		    
		    if nQuant == 0
		    	loop
            elseif cTipoMov == "M"
		    		cOperacao   := "R"
		    		cCodTM      := SuperGetMV("MV_XWMSMVR", .f., "999") //514
		    elseif nQuant > 0
			    	cOperacao   := "D"
		    		cCodTM      := SuperGetMV("MV_XWMSIVD", .f., "499") //513
		    		cDocumento  += "D"
		    		
		    else
	    		cOperacao   := "R"
	    		cCodTM      := SuperGetMV("MV_XWMSIVR", .f., "999") //113
	    		cDocumento  += "R"
		    endif
            
			if ( nI := AScan(aMovs, {|x| x[1] == cOperacao}) ) == 0
				AAdd(aMovs, { cOperacao ,;
				              { { "D3_EMISSAO", dDataBase	},;
				                { "D3_TM"     , cCodTM 		} ;
				              } ,;
				              {} ;
				            } ;
				    )
				              
				nI := Len(aMovs)
			endif
			
			AAdd(aMovs[nI][3], {{ "D3_COD" 		, cCodProd 												, NIL},;
			                    { "D3_UM" 		, Posicione("SB1", 1, XFilial("SB1")+cCodProd, "B1_UM")	, NIL},;
			                    { "D3_QUANT" 	, nQuant 												, NIL},;
			                    { "D3_LOCAL" 	, cArmazem												, NIL},;
			                    { "D3_LOTECTL" 	, cLoteCTL  											, NIL},;
				                { "D3_LOCALIZ" 	, cEndereco  											, NIL},;
				                { "D3_DOC"    	, cDocumento  											, NIL}})
			
		next nX
		
		if lOk
			for nX := 1 to len(aMovs)                         
				lMsErroAuto := .F.

				aCab := {}
				aItens := {}             

				//aadd(aCab	, aMovs[nX][2])
				//aadd(aItens	, aMovs[nX][3])

				
				aCab := { {"D3_TM" 		, cCodTM 	, NIL},;
				          {"D3_EMISSAO" , ddatabase	, NIL}}
				
				_aItem	:=	{ 	{"D3_COD" 		, cCodProd 												, NIL},;
								{"D3_CC" 		, '29050101' 											, NIL},;
								{"D3_UM" 		, Posicione("SB1", 1, XFilial("SB1")+cCodProd, "B1_UM") , NIL},;
								{"D3_QUANT" 	, nQuant 												, NIL},;
								{"D3_LOCAL" 	, cArmazem 												, NIL},;
				                {"D3_LOCALIZ" 	, cEndereco 											, NIL},;
								{"D3_LOTECTL" 	, cLoteCTL 												, NIL}}
				
				aadd(aItens,_aitem)
				
				MSExecAuto({|x,y,z| MATA241(x,y,z)}, aCab, aItens,3)
				
				if lMsErroAuto    
					cMsgErr := MostraErro("\temp")
					cMsgErr := StrTran(cMsgErr, "<","|")
					cMsgErr := StrTran(cMsgErr, ">","|")
					lOk := .F.
					DisarmTransaction()
					exit  
				endif                                                                            
	
			next nX
		endif
		
		if lOk
			EndTran()

			if cTipoMov == "I"
				cMsgErr := "Invent�rio realizado com sucesso!."
			else
				cMsgErr := "Movimento interno realizado com sucesso!."
			endif
		endif
					
	endif
	
	oRet:SITUACAO := lOK
	oRet:MENSAGEM := cMsgErr

Return(.t.)

Static Function VldProdutos(oProduto, nSeq)
	
	Local cMsgErr 	:= ""
	Local cSeq 		:= "Seq.Prod.: " + cValToChar(nSeq)
	Local nQtdSoma 	:= 0
	Local cArmazem 	:= PadR(oProduto:ARMAZEM,TamSx3("BF_LOCAL")[1])
	Local cEndereco := PadR(oProduto:ENDERECO,TamSx3("BF_LOCALIZA")[1])
	Local nX
	
	if empty(oProduto:CODIGO)
		cMsgErr := "Informe o codigo do Produto." + cSeq
	elseif empty(Posicione("SB1",1,xFilial("SB1")+alltrim(oProduto:CODIGO),"B1_COD"))
		cMsgErr := "O Produto " + oProduto:CODIGO + " informado nao est� cadastrado." + cSeq
	elseif empty(cArmazem)
		cMsgErr := "Informe o Armazem."
	elseif empty(oProduto:LOTE)
		cMsgErr := "Informe o Lote do produto." + cSeq
	elseif empty(Posicione("SB8",3,xFilial("SB8")+PadR(oProduto:CODIGO,TamSx3("B1_COD")[1])+cArmazem+PadR(oProduto:LOTE,TamSx3("B8_LOTECTL")[1]),"B8_LOTECTL"))
		cMsgErr := "O Lote " + oProduto:LOTE + " informado nao est� cadastrado no armaz�m "+cArmazem+"." + cSeq
	elseif empty(alltrim(cEndereco))
		cMsgErr := "Informe o codigo do endereco, " + cSeq
	elseif empty(Posicione("SBE",1,xFilial("SBE")+cArmazem+cEndereco,"BE_LOCALIZ"))
		cMsgErr := "O Endere�o " + AllTrim(cEndereco) + " informado nao est� cadastrado, " + cSeq
	elseif SBE->BE_MSBLQL == '1'
		cMsgErr	+= "O Endere�o (" + AllTrim(cEndereco) + ") est� bloqueado."
	//elseif empty(oProduto:OPERACAO)
	//	cMsgErr := "Informe a opera��o (Devolu��o ou Requisi��o) � realizar para o produto." + cSeq
	//elseif !( oProduto:OPERACAO $ ";D;R;" )
	//	cMsgErr := "C�digo de opera��o errada, utilize (Devolu��o ou Requisi��o)." + cSeq
	elseif empty(oProduto:QTD_DIF)
		cMsgErr := "Informe a quantidade total para o produto " + oProduto:CODIGO + "." + cSeq
	endif

Return cMsgErr 

Static function ValDef(xValor, cTipo)
	
	Default xValor 	:= "" 
	Default cTipo 	:= "C"
	
	if valtype(xValor) <> cTipo
		if cTipo == "N"
			xValor := 0
		elseif cTipo == "L"
			xValor := .F.
		endif
	endif
	
Return xValor

User Function TMATA241()
Local _aCab1 := {}
Local _aItem := {}
Local _atotitem:={}
Local cCodigoTM:="500"
Local cCodProd:="100007 "
Local cUnid:="CX "

Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao

Private _acod:={"1","MP1"}
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST"

_aCab1 := { {"D3_TM" ,cCodigoTM , NIL},;
            {"D3_EMISSAO" ,ddatabase, NIL}}

_aItem	:=	{ 	{"D3_COD" 		,cCodProd ,NIL},;
				{"D3_UM" 		,cUnid ,NIL},;
				{"D3_QUANT" 	,11 ,NIL},;
				{"D3_LOCAL" 	,"01" ,NIL},;
				{"D3_LOTECTL" 	,"22968/C" ,NIL}}

aadd(_atotitem,_aitem)
MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)

If lMsErroAuto
Mostraerro()
DisarmTransaction()
break

EndIf

Return
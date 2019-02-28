#INCLUDE "PROTHEUS.CH"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥UWSFPW01  ∫Autor  ≥Microsiga           ∫ Data ≥  12/12/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Metodo WS para CRUD de Funcion·rios                         ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function UWSFPW01(cXml)

	Local lOk := .T.
	Local cRet 		:= ""  
	Local oXMLGet
	Local cMsgErr 	:= ""
	Local cMsgSuss 	:= ""
	Local cError   	:= ""
	Local cWarning 	:= ""	
	Local aSRA  	:= {}  
	Local cMatric	:= ""
	Local cMatOrig	:= ""
	PRIVATE lMsErroAuto := .F.
	
	//Gera o Objeto XML para manipulaÁ„o das informaÁıes
	oXMLGet := XmlParser( cXml, "_", @cError, @cWarning )
	
	If (oXMLGet == NIL ) 
		cMsgErr := "Falha ao gerar Objeto XML: "+cError+" / "+cWarning
		lOk := .F.
	Endif
	
	//Verifica se XML tem a Tag FUNCIONARIO, e passa a trabalhar com ela
	if lOk .AND. (oXMLGet:=XmlChildEx(oXMLGet,"_FUNCIONARIO")) == Nil
		cMsgErr := "Xml com montagem incorreta! Falta tag principal |FUNCIONARIO|"
		lOk := .F.
	endif 
	
	//Verifica se XML tem a Tag ENVIO, e passa a trabalhar com ela
	if lOk .AND. (oXMLGet := XmlChildEx(oXMLGet,"_ENVIO")) == Nil
		cMsgErr := "Xml com montagem incorreta! Falta tag de dados |ENVIO|"
		lOk := .F.
	endif
	
	//Verifica se XML tem a Tag EMPRESA
	if lOk .AND. Type("cEmpAnt")=='U' .AND. (XmlChildEx(oXMLGet,"_EMPRESA")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |EMPRESA|"
		lOk := .F.
	elseif lOk .AND. Type("cEmpAnt")=='U'
		if empty(oXMLGet:_EMPRESA:TEXT)
			cMsgErr := "Campo |EMPRESA| nao preenchido. Campo obrigatorio."
			lOk := .F.
		endif
	endif
	
	//Verifica se XML tem a Tag FILIAL
	if lOk .AND. Type("cFilAnt")=='U' .AND. (XmlChildEx(oXMLGet,"_FILIAL")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |FILIAL|"
		lOk := .F.
	elseif lOk .AND. Type("cFilAnt")=='U'
		if empty(oXMLGet:_FILIAL:TEXT)
			cMsgErr := "Campo |FILIAL| nao preenchido. Campo obrigatorio."
			lOk := .F.
		endif
	endif 

	//se n„o foi configurado WS para ja vir logado na empresa e filial, faÁo criaÁ„o do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U' 
		RpcSetType(3)
		lConect := RpcSetEnv(oXMLGet:_EMPRESA:TEXT, oXMLGet:_FILIAL:TEXT)
		if !lConect
			cMsgErr := "N„o foi possÌvel conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif
	
	//Verifica se XML tem a Tag MODO
	if lOk .AND. (XmlChildEx(oXMLGet,"_MODO")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |MODO|"
		lOk := .F.
	elseif lOk
		if empty(oXMLGet:_MODO:TEXT)
			cMsgErr := "Campo |MODO| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif !(Alltrim(oXMLGet:_MODO:TEXT) $ "IAE")
			cMsgErr := "Campo |MODO| nao preenchido corretamente. Sintaxe: I=inclusao;A=Alteracao;E=Exclusao ."
			lOk := .F.
		endif
	endif
	
	//Verifica se XML tem a Tag MATRICULA
	if lOk .AND. (XmlChildEx(oXMLGet,"_MATRICULA")==Nil)
		cMsgErr := "Xml com montagem incorreta! Falta tag |MATRICULA|"
		lOk := .F.
	elseif lOk
		if empty(oXMLGet:_MATRICULA:TEXT)
			cMsgErr := "Campo |MATRICULA| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif val(oXMLGet:_MATRICULA:TEXT) <= 0
			cMsgErr := "Campo |MATRICULA| nao preenchido corretamente. Deve ser maior que Zero."
			lOk := .F.
		else
			cMatOrig := oXMLGet:_MATRICULA:TEXT
			cMatric := StrZero(val(oXMLGet:_MATRICULA:TEXT), TamSx3("RA_MAT")[1])
		endif
	endif
	
	if lOk .AND. Alltrim(oXMLGet:_MODO:TEXT) <> "E" //se nao for exclusao)
	
		//Verifica se XML tem a Tag NOME
		if lOk .AND. (XmlChildEx(oXMLGet,"_NOME")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |NOME|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_NOME:TEXT)
				cMsgErr := "Campo |NOME| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag NOME
		if lOk .AND. (XmlChildEx(oXMLGet,"_NASCIMENTO")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |NASCIMENTO|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_NASCIMENTO:TEXT)
				cMsgErr := "Campo |NASCIMENTO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif empty(STOD(oXMLGet:_NASCIMENTO:TEXT))
				cMsgErr := "Campo |NASCIMENTO| no formato incorreto. Sintaxe: AAAAMMDD."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag CCUSTO
		if lOk .AND. (XmlChildEx(oXMLGet,"_CCUSTO")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |CCUSTO|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_CCUSTO:TEXT)
				cMsgErr := "Campo |CCUSTO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif !empty(oXMLGet:_CCUSTO:TEXT) .AND. empty(Posicione("CTT",1,xFilial("CTT")+Alltrim(oXMLGet:_CCUSTO:TEXT),"CTT_CUSTO"))
				cMsgErr := "Centro de Custo informado nao foi encontrado no cadastro."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag CPF
		if lOk .AND. (XmlChildEx(oXMLGet,"_CPF")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |CPF|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_CPF:TEXT)
				cMsgErr := "Campo |CPF| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag CPF
		if lOk .AND. (XmlChildEx(oXMLGet,"_PIS")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |PIS|"
			lOk := .F.
		elseif lOk
			//if empty(oXMLGet:_PIS:TEXT)
			//	cMsgErr := "Campo |PIS| nao preenchido. Campo obrigatorio."
			//	lOk := .F.
			//endif
		endif


		//Verifica se XML tem a Tag RG
		if lOk .AND. (XmlChildEx(oXMLGet,"_RG")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |RG|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_RG:TEXT)
				cMsgErr := "Campo |RG| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag RGUF
		/*if lOk .AND. (XmlChildEx(oXMLGet,"_RGUF")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |RGUF|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_RGUF:TEXT)
				cMsgErr := "Campo |RGUF| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag RGORG
		if lOk .AND. (XmlChildEx(oXMLGet,"_RGORG")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |RGORG|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_RGORG:TEXT)
				cMsgErr := "Campo |RGORG| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif*/
		
		//Verifica se XML tem a Tag ADMISSAO
		if lOk .AND. (XmlChildEx(oXMLGet,"_ADMISSAO")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |ADMISSAO|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_ADMISSAO:TEXT)
				cMsgErr := "Campo |ADMISSAO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif empty(STOD(oXMLGet:_ADMISSAO:TEXT))
				cMsgErr := "Campo |ADMISSAO| no formato incorreto. Sintaxe: AAAAMMDD."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag DEMISSAO
		if lOk .AND. (XmlChildEx(oXMLGet,"_DEMISSAO")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |DEMISSAO|"
			lOk := .F.
		elseif lOk
			if !empty(oXMLGet:_DEMISSAO:TEXT) .AND. empty(STOD(oXMLGet:_DEMISSAO:TEXT))
				cMsgErr := "Campo |DEMISSAO| no formato incorreto. Sintaxe: AAAAMMDD."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag TURNO
		if lOk .AND. (XmlChildEx(oXMLGet,"_TURNO")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |TURNO|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_TURNO:TEXT)
				cMsgErr := "Campo |TURNO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif !empty(oXMLGet:_TURNO:TEXT) .AND. empty(Posicione("SR6",1,xFilial("SR6")+Alltrim(oXMLGet:_TURNO:TEXT),"R6_TURNO"))
				cMsgErr := "Turno Trabalho informado nao foi encontrado no cadastro."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag HMES
		if lOk .AND. (XmlChildEx(oXMLGet,"_HMES")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |HMES|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_HMES:TEXT)
				cMsgErr := "Campo |HMES| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif empty(Val(oXMLGet:_HMES:TEXT))
				cMsgErr := "Campo |HMES| nao preenchido corretamente. Sintaxe: 999.99 (numerico)."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag HSEM
		if lOk .AND. (XmlChildEx(oXMLGet,"_HSEM")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |HSEM|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_HSEM:TEXT)
				cMsgErr := "Campo |HSEM| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif empty(Val(oXMLGet:_HSEM:TEXT))
				cMsgErr := "Campo |HSEM| nao preenchido corretamente. Sintaxe: 99.99 (numerico)."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag CARGO
		if lOk .AND. (XmlChildEx(oXMLGet,"_CARGO")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |CARGO|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_CARGO:TEXT)
				cMsgErr := "Campo |CARGO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			else
			    
			    //Verifica se XML tem a Tag DCARGO
				if lOk .AND. (XmlChildEx(oXMLGet,"_DCARGO")==Nil)
					cMsgErr := "Xml com montagem incorreta! Falta tag |DCARGO|"
					lOk := .F.
				elseif lOk
					if empty(oXMLGet:_DCARGO:TEXT)
						cMsgErr := "Campo |DCARGO| nao preenchido. Campo obrigatorio."
						lOk := .F.
					endif
				endif
			endif
		endif
		
		//Verifica se XML tem a Tag FUNCAO
		/*if lOk .AND. (XmlChildEx(oXMLGet,"_FUNCAO")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |FUNCAO|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_FUNCAO:TEXT)
				cMsgErr := "Campo |FUNCAO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			else
				//Verifica se XML tem a Tag DFUNCAO
				if lOk .AND. (XmlChildEx(oXMLGet,"_DFUNCAO")==Nil)
					cMsgErr := "Xml com montagem incorreta! Falta tag |DFUNCAO|"
					lOk := .F.
				elseif lOk
					if empty(oXMLGet:_DFUNCAO:TEXT)
						cMsgErr := "Campo |DFUNCAO| nao preenchido. Campo obrigatorio."
						lOk := .F.
					endif
				endif 
			endif
		endif*/

		//Verifica se XML tem a Tag CBO
		if lOk .AND. (XmlChildEx(oXMLGet,"_CBO")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |CBO|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_CBO:TEXT)
				cMsgErr := "Campo |CBO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif 
		
		//Verifica se XML tem a Tag TPPAG
		if lOk .AND. (XmlChildEx(oXMLGet,"_TPPAG")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |TPPAG|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_TPPAG:TEXT)
				cMsgErr := "Campo |TPPAG| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif !(Alltrim(oXMLGet:_TPPAG:TEXT) $ "MS")
				cMsgErr := "Campo |TPPAG| nao preenchido corretamente. Sintaxe: M=Mensal;S=Semanal ."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag CATEGORIA
		if lOk .AND. (XmlChildEx(oXMLGet,"_CATEGORIA")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |CATEGORIA|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_CATEGORIA:TEXT)
				cMsgErr := "Campo |CATEGORIA| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif !(Alltrim(oXMLGet:_CATEGORIA:TEXT) $ "MPE")
				cMsgErr := "Campo |CATEGORIA| nao preenchido corretamente. Sintaxe: M=Mensalista;P=Pro-labore;E=Estagi·rio ."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag SITUACAO
		if lOk .AND. (XmlChildEx(oXMLGet,"_SITUACAO")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |SITUACAO|"
			lOk := .F.
		elseif lOk
			if !empty(oXMLGet:_SITUACAO:TEXT) .AND. !(Alltrim(oXMLGet:_SITUACAO:TEXT) $ "ADFT")
				cMsgErr := "Campo |SITUACAO| nao preenchido corretamente. Sintaxe: |em branco|=Normal;A=Afastado;D=Demitido;F=FÈrias;T=Transferido."
				lOk := .F.
			endif
		endif
		
		//Verifica se XML tem a Tag BLOQUEADO
		if lOk .AND. (XmlChildEx(oXMLGet,"_BLOQUEADO")==Nil)
			cMsgErr := "Xml com montagem incorreta! Falta tag |BLOQUEADO|"
			lOk := .F.
		elseif lOk
			if empty(oXMLGet:_BLOQUEADO:TEXT)
				cMsgErr := "Campo |BLOQUEADO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif !(Alltrim(oXMLGet:_BLOQUEADO:TEXT) $ "12")
				cMsgErr := "Campo |BLOQUEADO| nao preenchido corretamente. Sintaxe: 1=Sim;2=N„o ."
				lOk := .F.
			endif
		endif
		
	endif
	
	if lOK
		
		BeginTran()
		
		if Alltrim(oXMLGet:_MODO:TEXT) <> "E" //se nao for exclusao
			//verifica se o cargo existe na tabela
			//Cargo no FPW È a FunÁ„o (SRJ) no Protheus
			DbSelectArea("SRJ")
			SRJ->(DbSetOrder(1)) //RJ_FILIAL+RJ_FUNCAO
			if SRJ->( ! DbSeek(xFilial("SRJ") + PadL(oXMLGet:_CARGO:TEXT, TamSx3("RJ_FUNCAO")[1], "0") ))
				//se nao existe, inclui
				if RecLock("SRJ", .T.)
					SRJ->RJ_FILIAL := xFilial("SRJ")
					SRJ->RJ_FUNCAO := PadL(oXMLGet:_CARGO:TEXT, TamSx3("RJ_FUNCAO")[1], "0")
					SRJ->RJ_DESC   := oXMLGet:_DCARGO:TEXT
					
					SRJ->(MsUnlock())
				else
					cMsgErr := "Nao foi possivel atualizar tabela de CARGO. Registro est· sendo utilizado por outro usuario."
					lOk := .F.
					DisarmTransaction()
				endif
			endif 

			//verifica se a funÁ„o existe na tabela
			//FunÁ„o no FPW È o Cargo (SQ3) no Protheus
			/*if lOk
				DbSelectArea("SQ3")
				SQ3->(DbSetOrder(1)) //Q3_FILIAL+Q3_CARGO+Q3_CC
				if SQ3->(DbSeek(xFilial("SQ3") + PadR(oXMLGet:_FUNCAO:TEXT, TamSx3("Q3_CARGO")[1]) ))
					//se existe, altera descriÁ„o
					if RecLock("SQ3", .F.)
						SQ3->Q3_DESCSUM := oXMLGet:_DFUNCAO:TEXT
						
						SQ3->(MsUnlock())
					else
						cMsgErr := "Nao foi possivel atualizar tabela de FUNCOES. Registro est· sendo utilizado por outro usuario."
						lOk := .F.
					endif
				else
					//se nao existe, inclui
					if RecLock("SQ3", .T.)
						SQ3->Q3_FILIAL := xFilial("SQ3")
						SQ3->Q3_CARGO  := PadR(oXMLGet:_FUNCAO:TEXT, TamSx3("Q3_CARGO")[1])
						SQ3->Q3_DESCSUM   := oXMLGet:_DFUNCAO:TEXT
						
						SQ3->(MsUnlock())
					else
						cMsgErr := "Nao foi possivel atualizar tabela de FUNCOES. Registro est· sendo utilizado por outro usuario."
						lOk := .F.
					endif
				endif 
			endif */			 

		endif
		
		if lOk
			aSRA   := {}
			aadd(aSRA,{"RA_FILIAL" 		,xFilial("SRA")						,Nil		})
			aadd(aSRA,{"RA_MAT" 		,cMatric							,Nil		})
			
			if Alltrim(oXMLGet:_MODO:TEXT) <> "E" //se nao for exclusao

				aadd(aSRA,{'RA_NOME'		,oXMLGet:_NOME:TEXT					,Nil		})
				aadd(aSRA,{'RA_NASC'	   	,STOD(oXMLGet:_NASCIMENTO:TEXT)		,Nil		})
				aadd(aSRA,{'RA_RACACOR'	   	,"9"							,Nil		})
				aadd(aSRA,{'RA_CC'	   		,oXMLGet:_CCUSTO:TEXT				,Nil		})
				aadd(aSRA,{'RA_CIC'			,StrZero(Val(oXMLGet:_CPF:TEXT),11)	,Nil		})
				
				If ! Empty(AllTrim(oXMLGet:_PIS:TEXT))
					aadd(aSRA,{'RA_PIS'			, oXMLGet:_PIS:TEXT	,Nil })
				EndIf
				
				aadd(aSRA,{'RA_RG'			,oXMLGet:_RG:TEXT					,Nil		})
				aadd(aSRA,{'RA_RGUF'		,oXMLGet:_RGUF:TEXT					,Nil		})
				aadd(aSRA,{'RA_RGORG'		,oXMLGet:_RGORG:TEXT				,Nil		})
				aadd(aSRA,{'RA_TITULOE'		,"0"							,Nil		})
				aadd(aSRA,{'RA_ADMISSA'		,STOD(oXMLGet:_ADMISSAO:TEXT)		,Nil		})
				if !empty(oXMLGet:_DEMISSAO:TEXT)
					aadd(aSRA,{'RA_DEMISSA'		,STOD(oXMLGet:_DEMISSAO:TEXT)	,Nil		})
				endif
				aadd(aSRA,{'RA_TNOTRAB'		,oXMLGet:_TURNO:TEXT								,Nil		})
				aadd(aSRA,{'RA_HRSMES'		,Val(oXMLGet:_HMES:TEXT)							,Nil		})
				aadd(aSRA,{'RA_HRSEMAN'		,Val(oXMLGet:_HSEM:TEXT)							,Nil		})
				aadd(aSRA,{'RA_CODFUNC'		,PadL(oXMLGet:_CARGO:TEXT, TamSx3("RJ_FUNCAO")[1], "0")	,Nil		})
				aadd(aSRA,{'RA_CARGO'		,"99999"									,Nil		})
				aadd(aSRA,{'RA_ADTPOSE'		,"***N**"									,Nil		})
				aadd(aSRA,{'RA_CBO'			,oXMLGet:_CBO:TEXT									,Nil		})
				aadd(aSRA,{'RA_TIPOPGT'		,oXMLGet:_TPPAG:TEXT								,Nil		})
				aadd(aSRA,{'RA_CATFUNC'		,oXMLGet:_CATEGORIA:TEXT							,Nil		})
				aadd(aSRA,{'RA_SITFOLH'		,oXMLGet:_SITUACAO:TEXT								,Nil		})
				aadd(aSRA,{'RA_CHAPA'		,Right(cMatric, TamSX3('RA_CHAPA')[1])				,Nil		})
				aadd(aSRA,{'RA_CEP'			,"0"										,Nil		})
				aadd(aSRA,{'RA_MSBLQL'		,oXMLGet:_BLOQUEADO:TEXT							,Nil		})
				aadd(aSRA,{'RA_REGRA'		,"05"										,Nil		})
				aadd(aSRA,{'RA_SEQTURN'		,"01"										,Nil		})
				
		    endif
			
			DbSelectArea("SRA")
			SRA->(DbSetOrder(1)) //RA_FILIAL+RA_MAT
	 		if SRA->(DbSeek(xFilial("SRA") + cMatric )) 
	 			if Alltrim(oXMLGet:_MODO:TEXT) <> "E" //se nao for exclusao
	 				//se alteraÁao, adiciono tags de necess·rias
	 				aadd(aSRA,{'RA_TIPOALT'		,"001"		,Nil		})
	 				aadd(aSRA,{'RA_DATAALT'		,dDataBase	,Nil		})
	 				
	 				MSExecAuto({|x,y,k,w| GPEA010(x,y,k,w)},NIL,NIL,aSRA,4) //alterar
	 				cMsgSuss := "Funcionario Alterado com Sucesso!"
	 			else
	 				//excluo os registros relacionados (prog.ferias)
	 				DbSelectArea("SRF")
	 				if SRF->(DbSeek(xFilial("SRF")+SRA->RA_MAT))
	 					While SRF->(!Eof()) .AND. SRF->(RF_FILIAL+RF_MAT) == xFilial("SRF")+SRA->RA_MAT
		 					if Reclock("SRF", .F.)
		 						SRF->(DbDelete())
		 						SRF->(MsUnlock())
		 					endif
	 						SRF->(DbSkip())
	 					enddo
	 				endif
	 			
	 				MSExecAuto({|x,y,k,w| GPEA010(x,y,k,w)},NIL,NIL,aSRA,5) //excluir
	 				cMsgSuss := "Funcionario Excluido com Sucesso!"
	 			endif
	 		elseif Alltrim(oXMLGet:_MODO:TEXT) <> "E" //inclusao
				MSExecAuto({|x,y,k,w| GPEA010(x,y,k,w)},NIL,NIL,aSRA,3) //incluir Registro
				cMsgSuss := "Funcionario Cadastrado com Sucesso!"
			else
				cMsgErr := "Nao foi possivel localizar funcionario de matricula "+Alltrim(oXMLGet:_MATRICULA:TEXT)+"."
				lOk := .F.
				DisarmTransaction()
			endif
			
			If lMsErroAuto 
				cMsgErr := MostraErro("\temp")
				cMsgErr := StrTran(cMsgErr, "<","|")
				cMsgErr := StrTran(cMsgErr, ">","|")
				if SubStr(cMsgErr,1,4)=="HELP"
					Conout(cMsgErr)
					nPos := AT("Tabela SRA", cMsgErr)
					if nPos > 0
						cMsgErr := SubStr(cMsgErr,1,nPos-1)
					endif
				endif
				lOk := .F.
				DisarmTransaction()				
			EndIf
			
			SRA->(MSUnlockAll())
		
		endif
		
		if lOk
			EndTran()
		endif
		
	endif

	cRet := U_UXmlTag("FUNCIONARIO", ;
				U_UXmlTag("RETORNO",  ;
					U_UXmlTag("MATRICULA", cMatOrig) + ;
					U_UXmlTag("SITUACAO", iif(lOk,"OK","ERRO")) + ;
					U_UXmlTag("MSG", iif(lOk,cMsgSuss,cMsgErr)) ;
				, .T.) ;
			, .T.)

Return cRet   

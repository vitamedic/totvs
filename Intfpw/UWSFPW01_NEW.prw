#INCLUDE "PROTHEUS.CH"
#INCLUDE "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UWSFPW01  ºAutor  ³Microsiga           º Data ³  12/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Metodo WS para CRUD de Funcionários                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UWSFPW1N(oDados, oRet)

	Local lOk 		:= .T.
	Local cMsgErr 	:= ""
	Local cMsgSuss 	:= ""
	Local aSRA  	:= {}  
	Local cMatric	:= ""
	Local cMatOrig	:= ""
	PRIVATE lMsErroAuto := .F.
	
	oRet:SITUACAO 	:= ""
	oRet:MSG	 	:= "" 
	
	conout("CADFUNC_NEW >> Validando Empresa/Filial") 
		
	if lOk .AND. Type("cEmpAnt")=='U'
		if empty(oDados:EMPRESA)
			cMsgErr := "Campo |EMPRESA| nao preenchido. Campo obrigatorio."
			lOk := .F.
		endif
	endif
	
	//Verifica FILIAL
	if lOk .AND. Type("cFilAnt")=='U'
		if empty(oDados:FILIAL)
			cMsgErr := "Campo |FILIAL| nao preenchido. Campo obrigatorio."
			lOk := .F.
		endif
	endif 

	//se não foi configurado WS para ja vir logado na empresa e filial, faço criação do ambiente.
	if Type("cEmpAnt")=='U' .OR. Type("cFilAnt")=='U' 
		RpcSetType(3)
		lConect := RpcSetEnv(oDados:EMPRESA, oDados:FILIAL)
		if !lConect
			cMsgErr := "Não foi possível conectar na Empresa/Filial informadas!"
			lOk := .F.
		endif
	endif
	
	conout("CADFUNC_NEW >> Validando MODO") 
	//Verifica  MODO
	if lOk
		if empty(oDados:MODO)
			cMsgErr := "Campo |MODO| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif !(Alltrim(oDados:MODO) $ "IAE")
			cMsgErr := "Campo |MODO| nao preenchido corretamente. Sintaxe: I=Inclusao;A=Alteracao;E=Exclusao ."
			lOk := .F.
		endif
	endif
	
	conout("CADFUNC_NEW >> Validando MATRICULA") 
	//Verifica  MATRICULA
	if lOk
		if empty(oDados:MATRICULA)
			cMsgErr := "Campo |MATRICULA| nao preenchido. Campo obrigatorio."
			lOk := .F.
		elseif val(oDados:MATRICULA) <= 0
			cMsgErr := "Campo |MATRICULA| nao preenchido corretamente. Deve ser maior que Zero."
			lOk := .F.
		else
			cMatOrig := oDados:MATRICULA
			cMatric := StrZero(val(oDados:MATRICULA), TamSx3("RA_MAT")[1])
			conout("CADFUNC_NEW >> Matricula encontrada: cMatric="+ cMatric + " cMatOrig="+cMatOrig )	
		endif
	endif
	
	if lOk .AND. Alltrim(oDados:MODO) <> "E" //se nao for exclusao)
	
		conout("CADFUNC_NEW >> Validando NOME") 
		//Verifica  NOME
		if lOk
			if empty(oDados:NOME)
				cMsgErr := "Campo |NOME| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando NASCIMENTO") 
		//Verifica  NASCIMENTO
		if lOk
			if empty(oDados:NASCIMENTO)
				cMsgErr := "Campo |NASCIMENTO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif empty(STOD(oDados:NASCIMENTO))
				cMsgErr := "Campo |NASCIMENTO| no formato incorreto. Sintaxe: AAAAMMDD."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando CCUSTO") 
		//Verifica  CCUSTO
		if lOk
			if empty(oDados:CCUSTO)
				cMsgErr := "Campo |CCUSTO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif !empty(oDados:CCUSTO) .AND. empty(Posicione("CTT",1,xFilial("CTT")+Alltrim(oDados:CCUSTO),"CTT_CUSTO"))
				cMsgErr := "Centro de Custo informado nao foi encontrado no cadastro."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando CPF") 
		//Verifica  CPF
		if lOk
			if empty(oDados:CPF)
				cMsgErr := "Campo |CPF| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif

		conout("CADFUNC_NEW >> Validando PIS") 
		//Verifica  PIS
		if lOk
			if empty(oDados:PIS)
				//cMsgErr := "Campo |CPF| nao preenchido. Campo obrigatorio."
				//lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando RG") 
		//Verifica  RG
		if lOk
			if empty(oDados:RG)
				cMsgErr := "Campo |RG| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif
		
		/*conout("CADFUNC_NEW >> Validando RGUF") 
		//Verifica  RGUF
		if lOk
			if empty(oDados:RGUF)
				cMsgErr := "Campo |RGUF| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando RGORG") 
		//Verifica  RGORG
		if lOk
			if empty(oDados:RGORG)
				cMsgErr := "Campo |RGORG| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif */
		
		conout("CADFUNC_NEW >> Validando ADMISSAO") 
		//Verifica  ADMISSAO
		if lOk
			if empty(oDados:ADMISSAO)
				cMsgErr := "Campo |ADMISSAO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif empty(STOD(oDados:ADMISSAO))
				cMsgErr := "Campo |ADMISSAO| no formato incorreto. Sintaxe: AAAAMMDD."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando DEMISSAO") 
		//Verifica  DEMISSAO
		if lOk
			if !empty(oDados:DEMISSAO) .AND. empty(STOD(oDados:DEMISSAO))
				cMsgErr := "Campo |DEMISSAO| no formato incorreto. Sintaxe: AAAAMMDD."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando TURNO") 
		//Verifica  TURNO
		if lOk
			if empty(oDados:TURNO)
				cMsgErr := "Campo |TURNO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif !empty(oDados:TURNO) .AND. empty(Posicione("SR6",1,xFilial("SR6")+Alltrim(oDados:TURNO),"R6_TURNO"))
				cMsgErr := "Turno Trabalho informado nao foi encontrado no cadastro."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando HMES") 
		//Verifica  HMES
		if lOk
			if empty(oDados:HMES)
				cMsgErr := "Campo |HMES| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif empty(Val(oDados:HMES))
				cMsgErr := "Campo |HMES| nao preenchido corretamente. Sintaxe: 999.99 (numerico)."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando HSEM") 
		//Verifica  HSEM
		if lOk
			if empty(oDados:HSEM)
				cMsgErr := "Campo |HSEM| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif empty(Val(oDados:HSEM))
				cMsgErr := "Campo |HSEM| nao preenchido corretamente. Sintaxe: 99.99 (numerico)."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando CARGO")
		//Verifica  CARGO
		if lOk
			if empty(oDados:CARGO)
				cMsgErr := "Campo |CARGO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			else
			    //Verifica  DCARGO
				if lOk
					if empty(oDados:DCARGO)
						cMsgErr := "Campo |DCARGO| nao preenchido. Campo obrigatorio."
						lOk := .F.
					endif
				endif
			endif
		endif
		
		//Verifica  FUNCAO
		/*if lOk
			if empty(oDados:FUNCAO)
				cMsgErr := "Campo |FUNCAO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			else
				//Verifica  DFUNCAO
				if lOk
					if empty(oDados:DFUNCAO)
						cMsgErr := "Campo |DFUNCAO| nao preenchido. Campo obrigatorio."
						lOk := .F.
					endif
				endif 
			endif
		endif*/
		
		conout("CADFUNC_NEW >> Validando CBO")
		//Verifica  CBO
		if lOk
			if empty(oDados:CBO)
				cMsgErr := "Campo |CBO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			endif
		endif 
		
		conout("CADFUNC_NEW >> Validando TPPAG")
		if lOk
			if empty(oDados:TPPAG)
				cMsgErr := "Campo |TPPAG| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif !(Alltrim(oDados:TPPAG) $ "MS")
				cMsgErr := "Campo |TPPAG| nao preenchido corretamente. Sintaxe: M=Mensal;S=Semanal ."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando CATEGORIA")
		//Verifica  CATEGORIA
		if lOk
			if empty(oDados:CATEGORIA)
				cMsgErr := "Campo |CATEGORIA| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif !(Alltrim(oDados:CATEGORIA) $ "MPE")
				cMsgErr := "Campo |CATEGORIA| nao preenchido corretamente. Sintaxe: M=Mensalista;P=Pro-labore;E=Estagiário ."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando SITUACAO")
		//Verifica  SITUACAO
		if lOk
			if !empty(oDados:SITUACAO) .AND. !(Alltrim(oDados:SITUACAO) $ "ADFT")
				cMsgErr := "Campo |SITUACAO| nao preenchido corretamente. Sintaxe: |em branco|=Normal;A=Afastado;D=Demitido;F=Férias;T=Transferido."
				lOk := .F.
			endif
		endif
		
		conout("CADFUNC_NEW >> Validando BLOQUEADO")
		//Verifica  BLOQUEADO
		if lOk
			if empty(oDados:BLOQUEADO)
				cMsgErr := "Campo |BLOQUEADO| nao preenchido. Campo obrigatorio."
				lOk := .F.
			elseif !(Alltrim(oDados:BLOQUEADO) $ "12")
				cMsgErr := "Campo |BLOQUEADO| nao preenchido corretamente. Sintaxe: 1=Sim;2=Não ."
				lOk := .F.
			endif
		endif
		
	endif
	
	if lOK
		
		conout("CADFUNC_NEW >> Iniciando gravação")	
		BeginTran()
		
		if Alltrim(oDados:MODO) <> "E" //se nao for exclusao
			//verifica se o cargo existe na tabela
			//Cargo no FPW é a Função (SRJ) no Protheus
			DbSelectArea("SRJ")
			SRJ->(DbSetOrder(1)) //RJ_FILIAL+RJ_FUNCAO
			if SRJ->( ! DbSeek(xFilial("SRJ") + PadL(oDados:CARGO, TamSx3("RJ_FUNCAO")[1], "0")) )
				conout("CADFUNC_NEW >> Incluindo SRJ")	
				//se nao existe, inclui
				if RecLock("SRJ", .T.)
					SRJ->RJ_FILIAL := xFilial("SRJ")
					SRJ->RJ_FUNCAO := PadL(oDados:CARGO, TamSx3("RJ_FUNCAO")[1], "0")
					SRJ->RJ_DESC   := oDados:DCARGO
					
					SRJ->(MsUnlock())
				else
					cMsgErr := "Nao foi possivel atualizar tabela de CARGO. Registro está sendo utilizado por outro usuario."
					lOk := .F.
					DisarmTransaction()
				endif
			/*else
				conout("CADFUNC_NEW >> Alterando SRJ")	
				//se nao existe, inclui
				if RecLock("SRJ", .F.)
					SRJ->RJ_FILIAL := xFilial("SRJ")
					SRJ->RJ_DESC   := oDados:DCARGO
					
					SRJ->(MsUnlock())
				else
					cMsgErr := "Nao foi possivel atualizar tabela de CARGO. Registro está sendo utilizado por outro usuario."
					lOk := .F.
					DisarmTransaction()
				endif*/

			endif 

			//verifica se a função existe na tabela
			//Função no FPW é o Cargo (SQ3) no Protheus
			/*
			if lOk
				DbSelectArea("SQ3")
				SQ3->(DbSetOrder(1)) //Q3_FILIAL+Q3_CARGO+Q3_CC
				if SQ3->(DbSeek(xFilial("SQ3") + PadR(oDados:FUNCAO, TamSx3("Q3_CARGO")[1]) ))
					//se existe, altera descrição
					if RecLock("SQ3", .F.)
						SQ3->Q3_DESCSUM := oDados:DFUNCAO
						
						SQ3->(MsUnlock())
					else
						cMsgErr := "Nao foi possivel atualizar tabela de FUNCOES. Registro está sendo utilizado por outro usuario."
						lOk := .F.
					endif
				else
					//se nao existe, inclui
					if RecLock("SQ3", .T.)
						SQ3->Q3_FILIAL := xFilial("SQ3")
						SQ3->Q3_CARGO  := PadR(oDados:FUNCAO, TamSx3("Q3_CARGO")[1])
						SQ3->Q3_DESCSUM   := oDados:DFUNCAO
						
						SQ3->(MsUnlock())
					else
						cMsgErr := "Nao foi possivel atualizar tabela de FUNCOES. Registro está sendo utilizado por outro usuario."
						lOk := .F.
					endif
				endif 
			endif*/			 
		endif
		
		if lOk
			conout("CADFUNC_NEW >> Iniciando montagem arrays execauto")	
			
			aSRA   := {}
			aadd(aSRA,{"RA_FILIAL" 		,xFilial("SRA")						,Nil		})
			aadd(aSRA,{"RA_MAT" 		,cMatric							,Nil		})
			
			if Alltrim(oDados:MODO) <> "E" //se nao for exclusao

				aadd(aSRA,{'RA_NOME'		,oDados:NOME					,Nil		})
				aadd(aSRA,{'RA_NASC'	   	,STOD(oDados:NASCIMENTO)		,Nil		})
				aadd(aSRA,{'RA_RACACOR'	   	,"9"							,Nil		})
				aadd(aSRA,{'RA_CC'	   		,oDados:CCUSTO					,Nil		})
				aadd(aSRA,{'RA_CIC'			,StrZero(Val(oDados:CPF),11)	,Nil		})
				
				If ! Empty(oDados:PIS)
					aadd(aSRA,{'RA_PIS'	, oDados:PIS, Nil })
				EndIf
				
				aadd(aSRA,{'RA_RG'			,oDados:RG						,Nil		})
				aadd(aSRA,{'RA_RGUF'		,oDados:RGUF					,Nil		})
				aadd(aSRA,{'RA_RGORG'		,oDados:RGORG					,Nil		})
				aadd(aSRA,{'RA_TITULOE'		,"0"							,Nil		})
				aadd(aSRA,{'RA_ADMISSA'		,STOD(oDados:ADMISSAO)			,Nil		})
				if !empty(oDados:DEMISSAO)
					aadd(aSRA,{'RA_DEMISSA'		,STOD(oDados:DEMISSAO)		,Nil		})
				endif
				aadd(aSRA,{'RA_TNOTRAB'		,oDados:TURNO								,Nil		})
				aadd(aSRA,{'RA_HRSMES'		,Val(oDados:HMES)							,Nil		})
				aadd(aSRA,{'RA_HRSEMAN'		,Val(oDados:HSEM)							,Nil		})
				aadd(aSRA,{'RA_CODFUNC'		,PadL(oDados:CARGO, TamSx3("RJ_FUNCAO")[1], "0")	,Nil		})
				aadd(aSRA,{'RA_CARGO'		,"99999"									,Nil		})
				aadd(aSRA,{'RA_ADTPOSE'		,"***N**"									,Nil		})
				aadd(aSRA,{'RA_CBO'			,oDados:CBO									,Nil		})
				aadd(aSRA,{'RA_TIPOPGT'		,oDados:TPPAG								,Nil		})
				aadd(aSRA,{'RA_CATFUNC'		,oDados:CATEGORIA							,Nil		})
				aadd(aSRA,{'RA_SITFOLH'		,oDados:SITUACAO							,Nil		})
				aadd(aSRA,{'RA_CHAPA'		,Right(cMatric, TamSX3('RA_CHAPA')[1])		,Nil		})
				aadd(aSRA,{'RA_CEP'			,"0"										,Nil		})
				aadd(aSRA,{'RA_MSBLQL'		,oDados:BLOQUEADO							,Nil		})
				aadd(aSRA,{'RA_REGRA'		,"05"										,Nil		})
				aadd(aSRA,{'RA_SEQTURN'		,"01"										,Nil		})
//stephen 05/07/2018				
				aadd(aSRA,{'RA_SEXO'		,"M"										,Nil		})
				aadd(aSRA,{'RA_GRINRAI'		,"55"										,Nil		})
				aadd(aSRA,{'RA_ESTCIVI'		,"S"										,Nil		})
				aadd(aSRA,{'RA_NUMCP'		,"00000000"									,Nil		})
				aadd(aSRA,{'RA_NACIONA'		,"10"   									,Nil		})
				aadd(aSRA,{'RA_SERCP'   	,"00000"   									,Nil		})
				aadd(aSRA,{'RA_NATURAL'   	,"GO"				     					,Nil		})
				aadd(aSRA,{'RA_ESTADO'   	,"GO"				     					,Nil		})
				aadd(aSRA,{'RA_CODMUN'   	,"01108"   									,Nil		})
				aadd(aSRA,{'RA_TIPOADM'   	,"9B"   									,Nil		})
				aadd(aSRA,{'RA_OPCAO'   	,date() + 30        						,Nil		})
				aadd(aSRA,{'RA_HOPARC'   	,"2"                						,Nil		})
				aadd(aSRA,{'RA_VIEMRAI'   	,"10"                						,Nil		})
				aadd(aSRA,{'RA_PROCES'   	,"00001"               						,Nil		})
				aadd(aSRA,{'RA_COMPSAB'   	,"1"                 						,Nil		})
		    endif
			
			conout("CADFUNC_NEW >> Executando EXECAUTO")	
			
			DbSelectArea("SRA")
			SRA->(DbSetOrder(1)) //RA_FILIAL+RA_MAT
	 		if SRA->(DbSeek(xFilial("SRA") + cMatric )) 
	 			if Alltrim(oDados:MODO) <> "E" //se nao for exclusao
	 				//se alteraçao, adiciono tags de necessárias
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
	 		elseif Alltrim(oDados:MODO) <> "E" //inclusao
				MSExecAuto({|x,y,k,w| GPEA010(x,y,k,w)},NIL,NIL,aSRA,3) //incluir Registro
				cMsgSuss := "Funcionario Cadastrado com Sucesso!"
			else
				cMsgErr := "Nao foi possivel localizar funcionario de matricula "+Alltrim(oDados:MATRICULA)+"."
				lOk := .F.
				DisarmTransaction()
			endif
			
			if lMsErroAuto 
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
			endif
			
			SRA->(MSUnlockAll())
		    
			conout("CADFUNC_NEW >> Finalizando processo!")	
		
		endif
		
		if lOk
			EndTran()
		endif
		
	endif
	
	conout("CADFUNC_NEW >> Montando dados Retorno!")
	
	oRet:MATRICULA 	:= cMatOrig
	oRet:SITUACAO 	:= iif(lOk,"OK","ERRO")
	oRet:MSG	 	:= iif(lOk,cMsgSuss,cMsgErr)
	
	conout("CADFUNC_NEW >> " + iif(lOk,cMsgSuss,cMsgErr) )
	
Return    

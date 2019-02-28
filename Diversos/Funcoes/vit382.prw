#Include "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "rwmake.ch"
#include 'Ap5Mail.ch'
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Programa  ³ Chamado TI³ Autor ³  André Almeida       ³Data ³ 26/02/10 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Descricao ³ Help Desk Tecnologia da Informação                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³ Versao    ³ 1.0                                                       ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function vit382()

	_dUsuario     := PSWRET()
	_nomeUsuario  := _dUsuario[1][4]
	_emailUsuario := _dUsuario[1][14]
	_dptUsuario	:= substr((_dUsuario[1][12]),1,3)
	_dptUsr2		:= substr((_dUsuario[1][12]),5,3)
	_histV2		:= " "
	_comp	  	    := .f. // valida o campo descrição no complemento, para nao ficar vazio.
	_aux		    := ""  // variavel auxiliar para identificar qual operação esta sendo feita nomento

	Private cCadastro := "Chamados TI"
	if _dptUsuario = "GTI"
		Private aRotina   := {	{"Pesquisar"     , "AxPesqui"     , 0, 1},;
			{"Visualizar"     , "U_Vfat()"     , 0, 2},; // Visualizar o Chamado
			{"Incluir"        , "U_Incluir() " , 0, 3},; // Incluir o Chamado
			{"Complementar"  , "U_alter()"    , 0, 4},; // A Função alterar refere ao Complemento do Chamado.
			{"Atender "       , "U_TiAnalise()"  , 0, 4},; // Atender o Chamado
			{"Finaliza Atend", "U_Solucao()"    , 0, 4},; // Propor uma Solução ao chamado, feito apos realizar o atendimento - Finaliza Atendimento
			{"Validar "      , "U_ValOk()"      , 0, 4},; // O Usuário Valida o chamado após ter uma solução proposta
			{"Encerrar"      , "U_TIEncerra()"  , 0, 4},; // Encerra o Chamado
			{"Cancelar"      , "U_TICancela()"  , 0, 4},; // Cancela o Chamado - Não está sendo usado
			{"Terceiro"      , "U_terceiro()"   , 0, 4},; // Altera o status colocando o chamado pendente com terceiros
			{"Legenda"       , "U_TILegenda()"  , 0, 2},;  // Legenda
			{"Problemas"     , "U_TIProb()"  , 0, 4},;		//Tipo de Problema
			{"Acerto Tempos", "U_TITempo()"  , 0, 4}}  // Acerta Tempos
	else 
		Private aRotina   := {	{"Pesquisar"     , "AxPesqui"     , 0, 1},;
			{"Visualizar"    , "U_Vfat()"     , 0, 2},; // Visualizar o Chamado
			{"Incluir"       , "U_Incluir() " , 0, 3},; // Incluir o Chamado
			{"Complementar"  , "U_alter()"    , 0, 4},; // A Função alterar refere ao Complemento do Chamado.
			{"Atender "      , "U_TiAnalise()"  , 0, 4},; // Atender o Chamado
			{"Finaliza Atend", "U_Solucao()"    , 0, 4},; // Propor uma Solução ao chamado, feito apos realizar o atendimento - Finaliza Atendimento
			{"Validar "      , "U_ValOk()"      , 0, 4},; // O Usuário Valida o chamado após ter uma solução proposta
			{"Encerrar"      , "U_TIEncerra()"  , 0, 4},; // Encerra o Chamado
			{"Cancelar"      , "U_TICancela()"  , 0, 4},; // Cancela o Chamado - Não está sendo usado
			{"Terceiro"      , "U_terceiro()"   , 0, 4},; // Altera o status colocando o chamado pendente com terceiros
			{"Legenda"       , "U_TILegenda()"  , 0, 2}}  // Legenda
	endif

	Private cAlias   := "Z38"
	Private aUsuario := {}

	aCores := {{"Z38->Z38_STATUS == '1'", "BR_VERDE"},; //Em Aberto
		{"Z38->Z38_STATUS == '2'", "BR_AMARELO"},;      //Em Atendimento
		{"Z38->Z38_STATUS == '3'", "BR_AZUL"},;			//Solução Proposta
		{"Z38->Z38_STATUS == '4'", "BR_BRANCO"},;		   //Solução Aceita
		{"Z38->Z38_STATUS == '5'", "BR_VERMELHO"},;		//Encerrado
		{"Z38->Z38_STATUS == '6'", "BR_PRETO"},;		   //Cancelado
		{"Z38->Z38_STATUS == '7'", "BR_PINK"},;			//Solução Recusada
		{"Z38->Z38_STATUS == '8'", "BR_CINZA"},;		   //Excluido
		{"Z38->Z38_STATUS == '9'", "BR_LARANJA"}}		   //Pendente com Terceiros

	Z38->(dbSetOrder(1))

	If _dptUsuario = "GTI"
		cExprFilTop := " "
	else
		if !empty(_dptUsr2)
			cExprFilTop := "Z38_DEPART IN ('"+_dptUsuario+"','"+_dptUsr2+"')"
		else
			cExprFilTop := "Z38_DEPART IN '"+_dptUsuario+"'"
		endif
	EndIf

	mBrowse(6, 1, 22, 105, cAlias, , , , , 2, aCores, , , , , , , , cExprFilTop)

	Return
/*
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri??o  ³ Exibe as legendas do browse.                                 ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±

/*/
User Function TILegenda()

	BrwLegenda(cCadastro, "Legenda", {	{"BR_VERDE"    , "Aguardando Análise"  },;
		{"BR_AMARELO " , "Em Atendimento pelo TI" },;
		{"BR_AZUL"     , "Solução Proposta, Aguardando retorno do usuário"},;
		{"BR_PINK"     , "Solução Recusada pelo Usuário"},;
		{"BR_BRANCO"   , "Validado pelo usuário"},;
		{"BR_VERMELHO" , "Chamado Encerrado" },;
		{"BR_LARANJA"  , "Chamado Pendente em Terceiros" },;
		{"BR_PRETO  "  , "Chamado Cancelado" }})
	Return

//****************************************** Incluir **************************************************************

User function incluir()

	_lDigita  := .t.
	_MailAcom := .t.
	_cStatus  := "1"
	_comp	   := .t.
	_aux	   := "1"

	Execblock("TELA",.F.,.F.)
	return


// ****************************************** Visualiza **************************************************************

User function Vfat()

	_lDigita  := .f.
	_MailAcom := .f.
	_aux	   := "2"

	Execblock("TELA",.F.,.F.)

	return

// ****************************************** Altera / Complementar **************************************************************

User function alter()

	_lDigita  := .f.
	_MailAcom := .t.
	_comp	  := .t.
	_aux      := "3"


	_cStatus  := z38->z38_status

	If !_dptUsuario = "GTI"
		if z38->z38_usuario <> _nomeUsuario
			Alert("Somente o Usuario" + Alltrim(z38->z38_usuario)+ "pode complemetar o Chamado")
			Return
		EndIf
	EndIf

	If Z38->Z38_STATUS $ ("4,5,6")
		MsgStop( "Operação Não Permitida - So poderá Complementar o chamado se o status estiver em analise ou com uma solução proposta! ")
	Else
		Execblock("TELA",.F.,.F.)
	EndIf

	return

// ****************************************** Alterar Status para serviço em terceiros *******************************************

User function terceiro()

	_lDigita  := .f.
	_MailAcom := .t.
	_comp	   := .t.
	_aux      := "9"

	If !_dptUsuario = "GTI"
		if z38->z38_usuario <> _nomeUsuario
			Alert("Somente o Usuario" + Alltrim(z38->z38_usuario)+ "pode Alterar o Status do Chamado")
			Return
		EndIf
	EndIf

	If !Z38->Z38_STATUS $ ("2,9")
		MsgStop( "Operação Não Permitida - So poderá emcaminhar o chamado a terceiro se estiver em atendimento! ")
	Else
		If Z38->Z38_STATUS == "2"
			_cStatus  := "9"
		Elseif Z38->Z38_STATUS == "9"
			_cStatus  := "2"
		endif
		Execblock("TELA",.F.,.F.)
	EndIf

	return

// ********************************************* Analisar / Atender o Chamado *****************************************************

User Function TiAnalise()
	Local lResp
	_cStatus  := "2"
	_aux      := "4"
	_cCodUsr	:= RETCODUSR()
	
	IF(SELECT("TMP1") > 0)
		TMP1->(DBCLOSEAREA())
	ENDIF
	_cquery:=" SELECT"
	_cquery+=" count(*) quant"
	
	_cquery+=" FROM "
	_cquery+=  retsqlname("Z38")+" Z38"
	_cquery+=" WHERE"
	_cquery+=" Z38.D_E_L_E_T_=' '"
	_cquery+=" AND z38_status ='2'"
	_cquery+=" AND z38_codana='"+_cCodUsr+"'"
	
	_cquery:=changequery(_cquery)
	tcquery _cquery new alias "TMP1"
	u_setfield("TMP1")
	
	if tmp1->quant >= 6                                                       //alterado p/ seis atendimentos limites, autorizado pela diretoria(Roldão) em 13/04/2015 - Guilherme Teodoro
		Alert("Somente podem ser atendidos 06 chamados consecutivamente!")    //alterado p/ seis atendimentos limites, autorizado pela diretoria(Roldão) em 13/04/2015 - Guilherme Teodoro
		return
	endif
	
	If !Z38->Z38_STATUS $ ("1,7")
		Alert("Chamado já se encontra em analise pelo Analista: " + Alltrim(z38->z38_respon))
		Return
	EndIf
	
	If z38->z38_status = "7" .and. Alltrim(_nomeUsuario) <> Alltrim(z38->z38_respon) 
		Alert("Somente o Analista " + Alltrim(z38->z38_respon)+" Pode atender este chamado!")
		Return
	Endif
	
	If !_dptUsuario = "GTI"
		Alert("Usuario não tem Permissão para realizar Atendimentos! ")
		Return
	EndIf
	
	lResp := MsgYesNo("Deseja realizar o atendimento deste Chamado? ")
	If lResp
		AnalisaCH()
	EndIf
Return

//********************************************* Solução / Finalizado o Atendimento ***********************************************************************

User Function Solucao()
	Local lResp

	_MailAcom := .t.
	_lDigita  := .f.
	_aux	   := "5"
	_cStatus  := "3"

	If !Z38->Z38_STATUS $ ("2")
		Alert("Chamado não se encotra em analise, ou aguardando uma solução! ")
		Return
	EndIf
	If !_dptUsuario = "GTI"
		Alert("Usuario não tem Permissão para propor a Solução do Chamado")
		Return
	EndIf

	lResp := MsgYesNo("Deseja propor uma solução para o Usuário? ")

	If lResp
		Execblock("TELA",.F.,.F.)
		U_TIProb()
	EndIf
Return

// *********************************************** Validação *********************************************************************

User Function Valok()
	Local lResp
	_MailAcom := .t.
	_lDigita  := .f.
	_cStatus  := "4"
	_end      := .f.
	_aux	   := "6"

	If Z38->Z38_STATUS $ ("5,6")
		Alert("O chamado cancelado ou encerrado!")
		Return
	EndIf

	if z38->z38_codusu <> RetCodUsr()
		Alert("Somente usuario que abriu o chamado pode Valida-lo !!!")
		Return
	endif

	If !Z38->Z38_STATUS $ ("3,4")
		Alert("O Somente Chamado no qual foi Proposto uma Solução pode ser Validado.")
		Return
	EndIf
	lResp := MsgYesNo("Confirma a VALIDAÇÃO do Chamado? se NAO você estará RECUSANDO a Solução.")

	If lResp
		RecLock("Z38", .F.)
		Z38->Z38_DTVAL  := date()
		Z38->Z38_HRVAL  := SubStr(Time(), 1, 5)
		Z38->Z38_STATUS := _cStatus
		z38->z38_temp4  := (date()-z38->z38_dtsolu)*24+(round(val(time())+(val(substr(time(),4,2))/60),2)-(val(z38->z38_hrsolu)+round(val((substr(z38->z38_hrsolu,4,2)))*100/60,0)/100))
		_histV			  := Alltrim(z38->z38_obs)
		_histV			  += chr(10)+chr(13)+chr(10)+chr(13)+"<br>"+replicate("-",110)+"<br>"+chr(10)+chr(13)+chr(10)+chr(13)
		_histV2		  := "O Chamado foi Validado pelo Usuário: "+_nomeUsuario+chr(10)+chr(13)
		_histV2		  += chr(10)+chr(13)+chr(10)+chr(13)+"Data: "+DTOC(date())+" Hora: "+time()+chr(10)+chr(13)
		_histV			  += _histV2
		z38->z38_obs    := _histV
		MsUnlock()
		_mNum	 		:= Z38->Z38_NUM
		_mStatus 		:= "Validação do Chamado"
		_mSituaCH 		:= "Chamado validado pelo cliente: "+_nomeUsuario
		_msg			:= z38->z38_obs
		_eMail()
	else
		_aux	  := "7"
		Execblock("TELA",.F.,.F.)
	EndIf

	if lResp
		lRespc := MsgYesNo("Você deve Encerrar o Chamado, deseja fazer isso Agora?  Deixe sua Sugestão!")
		if lRespc
			u_TIEncerra()
		else
			Alert("Você deve Encerrar o chamado, caso não queira fazer isso agora, deverá ser feito posteriormente.")
			return
		endif
	endif
Return

// *********************************************** Encerramento ******************************************************************

User Function TIEncerra()
	Local lResp
	_cStatus  := "5"
	_aux      := "7"

	If Z38->Z38_STATUS $("5,6")
		Alert("O chamado cancelado ou encerrado")
		return
	endif

	If !_dptUsuario = "GTI"
		If !Z38->Z38_STATUS $("4")
			Alert("O chamado so pode ser Encerrado caso ja esteja validado pelo Usuário")
			return
		endif
	EndIf

	lResp := MsgYesNo("Confirma Encerramento do Chamado?")
	if lResp
		RecLock("Z38", .F.)
		Z38->Z38_DTENC  := DATE()
		Z38->Z38_HRENC  := time()
		Z38->Z38_STATUS := _cStatus
		z38_temp3		 := (date()-z38->z38_dtaber)*24+(round(val(time())+(val(substr(time(),4,2))/60),2)-(val(z38->z38_hrsoli)+round(val((substr(z38->z38_hrsoli,4,2)))*100/60,0)/100))
		_histE			  := Alltrim(z38->z38_obs)
		_histE			  += chr(10)+chr(13)+chr(10)+chr(13)+"<br>"+replicate("-",110)+"<br>"+chr(10)+chr(13)+chr(10)+chr(13)
		_histE2		  := "O Chamado foi Encerrado pelo Usuário: "+_nomeUsuario
		_histE2		  += chr(10)+chr(13)+"Data: "+DTOC(date())+" Hora: "+time()+chr(10)+chr(13)
		_histE			  += _histE2
		z38->z38_obs    := _histE
		MsUnlock()
		_mNum	 		:= Z38->Z38_NUM
		_mStatus 		:= "Encerramento do Chamado "
		_mSituaCH 		:= "Chamado Encerrado !!!!"
		_msg			:= z38->z38_obs
		_eMail()
	EndIf

Return

// *********************************************** Cancelamento ******************************************************************

User Function TICancela()
	Local lResp
	_cStatus  := "6"
	_aux      := "8"

	If Z38->Z38_STATUS $ ("5,6")
		Alert(" Operação Não Permitida!")
		Return
	EndIf

	If !_dptUsuario = "GTI"
		Alert("Usuario não tem Permissão para cancelar o Chamado ")
		Return
	EndIf

	lResp := MsgYesNo("Confirma Cancelamento do Chamado?")
	If lResp
		RecLock("Z38", .F.)
		Z38->Z38_STATUS := _cStatus
		_histC			  := Alltrim(z38->z38_obs)
		_histC			  += chr(10)+chr(13)+chr(10)+chr(13)+"<br>"+replicate("-",110)+"<br>"+chr(10)+chr(13)+chr(10)+chr(13)
		_histC2		  := "O Chamado foi Cancelado pelo Usuário: "+_nomeUsuario
		_histC2		  += chr(10)+chr(13)+"Data: "+DTOC(date())+" Hora: "+time()+chr(10)+chr(13)
		_histC			  += _histC2
		z38->z38_obs    := _histC
		MsUnlock()

		_mNum	 		:= Z38->Z38_NUM
		_mStatus 		:= "Cancelamento do Chamado "
		_mSituaCH 		:= "Este Chamado foi cancelado não haverá mais nenhuma interação atravéz deste chamado."
		_msg			:= z38->z38_obs
		_eMail()
	EndIf
Return

User Function TELA()

//------------- VARIAVEIS --------------------------------------------

	PRIVATE aComboBx1        := {"1=Suporte","2=Implantação","3=Alteração","4=Reclamação","5=Duvidas","6=Proposta Mudança","7=Outras"} //Tipo Atendimento
	PRIVATE aComboBx2        := {"1=Aguardando Analise","2=Em Analise","3=Validação do Usuário","4= Validação Ok","5=Encerrado","6=Cancelado"} //Status do Chamado
	//PRIVATE aComboBx3        := {"1=Financeiro","2=Contabilidade","3=Custos","4=Marketing","5=Comercial","6=RH","7=Logistica","8=Manutenção","9=Garantia","10=Controle","11=Faturamento","12=Regulatórios","13=Desenvolvimento","14=Suprimentos","15=Seg. Trabalho","16=Diretoria","17=Produção","18=PCP","19=Almoxarifado"} //Departamento
	PRIVATE aComboBx4        := {"1=Sistema","2=Suporte Tecnico","3=Telefonia"} //Area de atendimento   //Retirada a opção 1=Sistema, inicio utilização 0800 // {"1=Sistema","2=Suporte Tecnico","3=Telefonia"} - Guilherme Teodoro 01/11/2016
	P1_cMemo	               := " "

//if _inclui = .t.
	if _aux = "1"

		PRIVATE P1_cProt         := GetSx8Num("Z38","Z38_NUM","Z38010")
		PRIVATE P1_cDpt          := _dptUsuario
		PRIVATE P1_cMod          := SPACE(10)
		PRIVATE P1_cCodCliente   := RETCODUSR()
		PRIVATE P1_cNomeCliente  := UsrFullName(RETCODUSR())
		PRIVATE P1_cMemo         := " "
		PRIVATE P2_cMemoH        := " "
		PRIVATE P1_nOcorrencia   := "1"
		PRIVATE P1_nSitCliente   := "1"
		PRIVATE P1_nArea         := "1"
		PRIVATE P1_cAtendente    := SPACE(06)
		PRIVATE P1_dData         := date()
		PRIVATE P1_cHora         := time()
		PRIVATE P1_cMail         := space(40)

	else

		P1_cProt 	      := Z38->Z38_NUM
		P1_cDpt	      := Z38->Z38_DEPART
		P1_cMod		  := Z38->Z38_PROGRA
		P1_cCodCliente  := Z38->Z38_CODUSU
		P1_cNomeCliente := Z38->Z38_USUARI
		P1_nOcorrencia  := Z38->Z38_OCORRE
		P1_nSitCliente  := Z38->Z38_STATUS
		P1_cAtendente   := Z38->Z38_RESPON
		P1_dData		  := Z38->Z38_DTABER
		P1_cHora        := Z38->Z38_HRSOLI
		P2_cMemoH 	      := Z38->Z38_OBS
		P1_nArea        := Z38->Z38_AREAAT
		P1_cMemo		  := " "
		P1_cMail		  := Z38->Z38_EMAIL2

	endif

//------------- objeto --------------------------------------------

	PRIVATE P1_oProt         := ""
	PRIVATE P1_oDpt          := ""
	PRIVATE P1_oMod        	 := ""
	PRIVATE P1_oCodCliente   := ""
	PRIVATE P1_oNomeCliente  := ""
	PRIVATE P1_oMemo         := ""
	PRIVATE P1_oMemoH        := ""
	PRIVATE P1_oOcorrencia   := ""
	PRIVATE P1_oSitCliente   := ""
	PRIVATE P1_oArea         := ""
	PRIVATE P1_oAtendente    := ""
	PRIVATE P1_oData         := ""
	PRIVATE P1_oMail         := ""

//-------objetos------------------------------------------------------

	PRIVATE P1_olabCodProto
	PRIVATE P1_oLabCodCli
	Private P1_oDepartamento
	Private P1_oProgram
	PRIVATE P1_oLabOcorr
	PRIVATE P1_oLabAtend
	PRIVATE P1_oLabData
	PRIVATE P1_oLabHora
	PRIVATE P1_oSitua
	PRIVATE P1_oAcomp
	PRIVATE P2_oPainelH

//---------- botões -------------------------------------------------

	PRIVATE P1_btINCLUIR
	PRIVATE P1_btEXCLUIR
	PRIVATE P1_btSAIR
	PRIVATE P1_btEnviar
	PRIVATE P1_oPanel1

//------------- variáveis lógicas -----------------------------------

	PRIVATE lPas1_incluir
	PRIVATE lPas1_gravar
	PRIVATE lPas1_cancelar
	PRIVATE lPas1_sair

//------------ botões -----------------------------------------------

	Static oDlg

//******************************************* TELA ****************************************************************************************

	PRIVATE oFont1 := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
	PRIVATE P1_imprime                                  //linha coluna
//  |    |
	DEFINE MSDIALOG oDlg TITLE "Chamado T.I" FROM 000, 000  TO 450, 820 COLORS 0, 16777215 PIXEL
	@ 001,001 FOLDER P1_imprime SIZE 550, 500 OF oDlg ITEMS "Atendimento T.I","Histórico do Chamado" COLORS 0, 16777215  	 PIXEL
// coluna linha
//    |     |
	@ 002, 001 MSPANEL P1_oPanel1 SIZE 380, 150 OF P1_imprime:aDialogs[1] COLORS 0, 16777215 RAISED
	@ 001, 000 SAY P1_olabCodProto  PROMPT "Código protocolo"       SIZE 040, 007 OF P1_oPanel1 FONT oFont1 COLORS 0, 16777215 		  PIXEL
	@ 001, 110 SAY P1_oDepartamento PROMPT "Departamento"           SIZE 040, 007 OF P1_oPanel1 FONT oFont1 COLORS 0, 16777215 		  PIXEL
	@ 001, 225 SAY P1_oProgram      PROMPT "Programa"         	    SIZE 040, 007 OF P1_oPanel1 FONT oFont1 COLORS 0, 16777215 		  PIXEL
	@ 016, 000 SAY P1_oLabCodCli    PROMPT "Código do usuário"      SIZE 049, 007 OF P1_oPanel1 FONT oFont1 COLORS 16711680, 16777215  PIXEL
	@ 031, 000 SAY P1_oLabOcorr     PROMPT "Ocorrência"             SIZE 033, 007 OF P1_oPanel1 FONT oFont1 COLORS 0, 16777215 		  PIXEL
	@ 045, 000 SAY P1_oLabSitCli    PROMPT "Status "                SIZE 046, 007 OF P1_oPanel1 FONT oFont1 COLORS 0, 16777215 		  PIXEL
	@ 060, 002 SAY P1_oLabAtend     PROMPT "Analista"               SIZE 040, 007 OF P1_oPanel1             COLORS 0, 16777215 		  PIXEL
	@ 078, 004 SAY P1_oArea         PROMPT "Area"                   SIZE 025, 007 OF P1_oPanel1 FONT oFont1 COLORS 0, 16777215 		  PIXEL
	@ 093, 004 SAY P1_oLabData      PROMPT "Data"                   SIZE 025, 007 OF P1_oPanel1 FONT oFont1 COLORS 0, 16777215 		  PIXEL
	@ 108, 005 SAY P1_oLabHora      PROMPT "Hora"                   SIZE 025, 007 OF P1_oPanel1 FONT oFont1 COLORS 0, 16777215 		  PIXEL
	@ 029, 165 SAY P1_oSitua        PROMPT "Descrever situação"     SIZE 100, 007 OF P1_oPanel1 FONT oFont1 COLORS 0, 16777215 		  PIXEL
	@ 132, 065 SAY P1_oAcomp        PROMPT "Acompanhar / E-mail"    SIZE 100, 007 OF P1_oPanel1 FONT oFont1 COLORS 0, 16777215 		  PIXEL
//----------------------------------------------------------------------------------------------------------------------------------------------
	@ 001, 047 MSGET 		P1_oProt              	VAR P1_cProt         	SIZE 	048, 010      OF   P1_oPanel1 COLORS 0, 16777215 READONLY      	WHEN _lDigita PIXEL
	If !_dptUsuario = "GTI"
		@ 001, 148 MSGET   	P1_oDpt              	VAR P1_cDpt           	SIZE   072, 010      OF   P1_oPanel1 COLORS 0, 16777215 READONLY	F3 "ZS" WHEN _lDigita PIXEL
	else
		@ 001, 148 MSGET   	P1_oDpt              	VAR P1_cDpt           	SIZE   072, 010      OF   P1_oPanel1 COLORS 0, 16777215 F3 "ZS" WHEN _lDigita PIXEL
	EndIf
	@ 001, 260 MSGET 		P1_oMod          	       VAR P1_cMod          	SIZE 	048, 010      OF   P1_oPanel1 COLORS 0, 16777215 			  		WHEN _lDigita PIXEL
	@ 015, 047 MSGET 		P1_oCodCliente        	VAR P1_cCodCliente   	SIZE 	050, 010      OF   P1_oPanel1 COLORS 0, 16777215 READONLY 	  	PIXEL
	@ 015, 109 MSGET 		P1_oNomeCliente       	VAR P1_cNomeCliente  	SIZE 	217, 010      OF   P1_oPanel1 COLORS 0, 16777215 READONLY 	  	PIXEL
	@ 029, 047 MSCOMBOBOX 	P1_oOcorrencia   		VAR P1_nOcorrencia   	ITEMS 	aComboBx1  	SIZE 072, 010   OF P1_oPanel1 COLORS 0, 16777215 	WHEN _lDigita PIXEL
	@ 043, 047 MSCOMBOBOX 	P1_oSitCliente   		VAR P1_nSitCliente   	ITEMS 	aComboBx2  	SIZE 072, 010   OF P1_oPanel1 COLORS 0, 16777215 	WHEN _lDigita PIXEL
	@ 058, 047 MSGET 		P1_oAtendente         	VAR P1_cAtendente    	SIZE 	038, 010      OF   P1_oPanel1 COLORS 0, 16777215 			  		WHEN _lDigita PIXEL
	@ 075, 047 MSCOMBOBOX 	P1_oArea         		VAR P1_nArea         	ITEMS 	aComboBx4  	SIZE 072, 010   OF P1_oPanel1 COLORS 0, 16777215 	PIXEL
	@ 091, 047 MSGET 		P1_odData             	VAR P1_dData         	SIZE 	035, 010      OF   P1_oPanel1 PICTURE "99/99/9999" COLORS 0, 16777215 READONLY     PIXEL
	@ 107, 048 MSGET 		P1_oHora              	VAR P1_cHora         	SIZE 	035, 010      OF   P1_oPanel1                      COLORS 0, 16777215 READONLY     PIXEL
	@ 043, 123 GET   		P1_oMemo              	VAR P1_cMemo             OF 	P1_oPanel1    MULTILINE       SIZE 200, 078 COLORS 0, 16777215 FONT oFont1 HSCROLL PIXEL valid _validadesc()
	@ 130, 123 MSGET   	P1_oMail                 VAR P1_cMail            SIZE 	106, 010      OF   P1_oPanel1 COLORS 0, 16777215 			  		WHEN _MailAcom   PIXEL valid _validacampo()
//----------------------------------------------------------------------------------------------------------------------------------------------

//if _altera = .t.
	if _aux = "1" .or. _aux = "3" .or. _aux = "5" .or. _aux = "7" .or. _aux = "9"

		@ 180, 010 BUTTON P1_btINCLUIR   PROMPT  "&Gravar"        SIZE 031, 015 OF P1_imprime:aDialogs[1] ACTION(_gravar()) WHEN lPas1_incluir   PIXEL
		@ 180, 050 BUTTON P1_btSAIR      PROMPT  "&Sair"          SIZE 031, 015 OF P1_imprime:aDialogs[1] ACTION(_sair())     WHEN lPas1_sair      PIXEL

	else

		@ 180, 010 BUTTON P1_btSAIR      PROMPT  "&Sair"          SIZE 031, 015 OF P1_imprime:aDialogs[1] ACTION(_sair())     WHEN lPas1_sair      PIXEL

	endif
//*********************************************************************************************************************************************************

//   PASTA 02----HISTÓRICO DO CHAMADO

	@ 002, 150 SAY P2_oPainelH   PROMPT "Histórico do Protocolo" SIZE 100,150 OF P1_imprime:aDialogs[2] COLORS 0, 16777215 PIXEL
	@ 010, 020 GET P2_oMemoH     VAR P2_cMemoH                   MULTILINE SIZE 350,180 OF P1_imprime:aDialogs[2] COLORS 0, 16777218 READONLY PIXEL

//*******************************************************************************************************************************************************

	ACTIVATE MSDIALOG oDlg CENTERED
Return

// Função que valida o campo e-mail  ********************************************************************************************************************

static function _validacampo
	_i := ";" $ P1_cMail

	if _i
		alert("So pode ser informado 1 (um) e-mail! ")
	endif

	if Alltrim(P1_cMail) = Alltrim(_emailUsuario)
		alert("Deve ser colocado um e-mail diferente do seu, este campo e para informar um e-mail de alguem que vai acompanhar o chamado. !!!")
		_i := .t.
	endif
return(!_i)

// Função que valida o campo descrição no complemento **************************************************************************************************

static function _validadesc
	local _r := .t.
	if _comp
		if empty(P1_cMemo)
			alert("Favor informar algo para descrição !!")
			_r := .f.
		endif
	endif
return(_r)
//******************************************************************************************************************************************************
///*** FUNÇÃO DO BOTÃO SAIR

STATIC FUNCTION _sair()
	RollBackSX8()
	oDlg:END()
	_end := .t.
	_comp:= .f.
	_aux := ""
RETURN
// ******************************************* Função Gravar *******************************************************************************************

static function _gravar

	if msgbox("Confirma a gravação?","Atenção","YESNO")

		if _comp
			if empty(P1_cMemo)
				alert("Favor informar algo para a descrição !!")
				return(.f.)
			endif
		endif

		if _aux = "1"
			reclock("Z38",.t.)
		else
			reclock("Z38",.f.)
		endif

		Z38->Z38_NUM    := P1_cProt           // PROTOCOLO DE ANTENDIMENTO
		Confirmsx8()
		if Z38->Z38_STATUS = "2" .and. _cStatus = "9"
			Z38->Z38_DTINI3 := date()
		elseif	Z38->Z38_STATUS = "9" .and. _cStatus = "2"
			Z38->Z38_DTFIM3 := date()
		endif
		Z38->Z38_DEPART := P1_cDpt            // DEPARTAMENTO
		Z38->Z38_PROGRA := P1_cMod            // PROGRAMA COM PROBLEMA
		Z38->Z38_CODUSU := P1_cCodCliente     // USUÁRIO QUE INCLUIU O CHAMADO
		Z38->Z38_USUARI := P1_cNomeCliente    // NOME DO USUÁRIO
		Z38->Z38_STATUS := _cStatus           // STATUS DO CHAMADO
		Z38->Z38_OCORRE := P1_nOcorrencia     // STATUS DO CHAMADO
		if empty(z38->z38_email)
			Z38->Z38_email  := Alltrim(_emailUsuario)      // e-mail do usuario que incluiu o chamado
		endif
		Z38->Z38_DTABER := P1_dData  		  //DATA DA INCLUSÃO DO CHAMADO
		Z38->Z38_HRSOLI := P1_cHora 		  // HORA DA INCLUSÃO DO CHAMADO
		Z38->Z38_AREAAT := P1_nArea			  // area de atendimento
		Z38->Z38_EMAIL2 := P1_cMail     	  // E-mail para acompanhamento do Chamado

		if empty(z38->z38_obs)
			_hist			:= Alltrim(P1_cMemo)+chr(10)+chr(13)+chr(13)+chr(10)
			_hist			+= chr(10)+chr(13)+chr(13)+chr(10)+"Data: "+DTOC(date())+"  Hora: "+time()+chr(10)+chr(13)+"Por: "+_nomeUsuario
			z38->z38_obs  := _hist
			z38_descri		:= substr(_hist,1,100)
		else
			_hist			:= Alltrim(z38->z38_obs)
			_hist			+= chr(10)+chr(13)+chr(10)+chr(13)+"<br>"+replicate("-",110)+"<br>"+chr(10)+chr(13)+chr(10)+chr(13)
			_hist2			:= Alltrim(P1_cMemo)+chr(10)+chr(13)+chr(10)+chr(13)
			if !empty(_histV2)
				_hist2		+= _histV2
			endif
			_hist2			+= chr(10)+chr(13)+"Data: "+DTOC(date())+" Hora: "+time()+chr(10)+chr(13)+"Por: "+_nomeUsuario
			_hist			+= _hist2
			z38->z38_obs    := _hist
		endif
		MsUnlock()

		if _aux = "1"
			_mNum		:= ""
			_mStatus 	:= "Abertura do Chamado "
			_mSituaCH	:=  "Chamado Incluído, Aguardando atendimento do TI "
			_msg		:= z38->z38_obs
			_mNum		:= z38->z38_num
		elseif _aux = "3"
			_mNum		:= z38->z38_num
			_mStatus 	:= "Complemento "
			_msg		:= Alltrim(z38->z38_obs)
			_mSituaCH 	:= "Houve uma interação no Chamado. "
			_end 		:= .f.
		elseif _aux = "5"
			RecLock("Z38", .F.)
			z38->z38_status  := _cStatus
			z38->z38_dtsoluc := date()
			z38->z38_hrsoluc := time()
			_Temp2 := z38_temp2
			z38->z38_temp2	:= (date()-z38->z38_dtatd)*24+(round(val(time())+(val(substr(time(),4,2))/60),2)-(val(z38->z38_hratd)+round(val((substr(z38->z38_hratd,4,2)))*100/60,0)/100))+_Temp2
			MsUnlock()
			_mNum	 		 := Z38->Z38_NUM
			_mStatus 		 := "Finalizado o Atendimento"
			_MSITUACH 		 := "Aguardando Posição do Usuario, dever validar ou regeitar a solução proposta! "
			_msg			 := z38->z38_obs
		elseif _aux = "7"
			RecLock("Z38", .F.)
			Z38->Z38_STATUS := "7"
			MsUnlock()
			_mNum	 		:= Z38->Z38_NUM
			_mStatus 		:= "Solução Recusada"
			_mSituaCH 		:= "Chamado Recusado pelo cliente: "+_nomeUsuario
			_msg			:= z38->z38_obs
			_histV2			:= "O Chamado foi Recusado pelo Usuário: "+_nomeUsuario
		elseif _aux = "9"
			_mNum	 		:= Z38->Z38_NUM
			_mStatus 		:= "Chamado pendente com Terceiros"
			_mSituaCH 		:= "Chamado Aguardando Retorno de Terceiros "
			_msg			:= z38->z38_obs
		endif
		_email()

		oDlg:END()
	endif
return


//*************************** Função Excluir ****************************************************************************************************

STATIC FUNCTION fP1_excluir

	If !_dptUsuario = "GTI"
		Alert("Usuario não tem Permissão para cancelar o Chamado ")
		Return
	EndIf

	if msgbox("Confirma a EXCLUSÃO?","Atenção","YESNO")

		reclock("Z38",.f.)

		Z38->D_E_L_E_T_  := "*"
		z38->z38_status  := "8"
		MsUnlock()

		_mNum	 		:= Z38->Z38_NUM
		_mStatus 		:= "Chamado Excluido "
		_mSituaCH 		:= "Este Chamado foi Excluido pelo Usuário"+_nomeUsuario
		_msg			:= z38->z38_obs
		_email()

		oDlg:END()
	endif
return()

//********************************************************* E-mail *****************************************************************************

Static Function _email()

	Local cAccount  := 'chamados'
	Local cEnvia    := 'helpdesk@vitamedic.ind.br'
	Local cServer   := '10.1.1.34'
	Local cPassword := '6Y6GFDcf3h'

	if Alltrim(_emailUsuario) = Alltrim(z38->z38_email)
		_para 			:= "ti@vitamedic.ind.br; "+Alltrim(_emailUsuario)+";"+Alltrim(z38->z38_email2)
	else
		_para 			:= "ti@vitamedic.ind.br; "+Alltrim(_emailUsuario)+";"+alltrim(z38->z38_email)+";"+Alltrim(z38->z38_email2)
	endif

	_paraA := " "

	cMsg := '</table>'
	cMsg += '<br><br>'
	cMsg += '<font face="Arial Black" size="4">  '+SM0->M0_NOME+ '</font> <br>'
	cMsg += '<br>'
	cMsg += '<font face="Arial" size="2"> '+ _mStatus  +' em '+dtoc(date())+ " às " + Time() + '     Por '+_nomeUsuario+ '</font> <br>'
	cMsg += '<br>'
	cMsg += '<font face="Arial" size="2"> '+_mSituaCH +' </font> <br>'
	cMsg += '<br>'
	cMsg += '<table border=1 width=700>'
	cMsg += '<tr>'
	cMsg += '<td rowspan=2 width=80>'+_msg+'</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '</table>'
	cMsg += '<br>'
	cMsg += '<font face="Arial" size="1"> Este e-mail foi gerado automaticamente pelo sistema, favor não responder.</b></font> <br>'
	cMsg += '</body>'
	cMsg += '</html>'

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	SEND MAIL FROM cEnvia TO _para SUBJECT 'CHAMADO T.I . Nº - '+_mNum+'  -  '+_mStatus+' - Aberto por: '+Alltrim(Z38->Z38_USUARI) BODY cMsg RESULT lEnviado

	_para := ""
return()

//********************************************************* Tela Analise *************************************************************************

static Function AnalisaCH

	_cData  := ctod("")
	_cHora  := space(5)
	_cStatus:= "2"

	Private lsair:= .F.

	oFnt3 := TFont():New( "Arial",08,16,,.T.)

//	@ 000,000 TO 200,500 DIALOG oTela TITLE OemToAnsi("Montar ordem de Estoque")

	DEFINE MSDIALOG oTela TITLE "Atendimento do Chamado" FROM 000,000 TO 180,280 PIXEL

	@ 005,035 Say "Previsão de Conclusão"    	COLOR  	CLR_HRED   	PIXEL OF 	oTela 		Font 	oFnt3
	@ 015,010 Say "Data"    					    PIXEL 	OF 	oTela 		Font 	oFnt3
	@ 015,040 Get _cData 						Size 	40,20  		Picture 	"999999"
	@ 030,010 Say "Hora"	 					    PIXEL 	OF 	oTela 		Font 	oFnt3
	@ 030,040 Get _cHora 						Size 	25,20 		   Picture 	"@R 99:99"

	@ 055,010 Button 			OemToAnsi("_Gravar") Size 		50,20 		Action 	GravProd()
	@ 055,070 Button 			OemToAnsi("_Sair") 	Size 		50,20 		Action 	(Close(oTela))

	ACTIVATE MSDIALOG oTela CENTERED


Return

static function GravProd

	if empty(_cData)
		Alert("Data não preenchida!!!")
		return()
	endif

	if empty(_cHora)
		Alert("Hora Não Preenchida!!!")
		return()
	endif

	reclock("Z38",.f.)
	Z38->Z38_STATUS := _cStatus
	z38->z38_codana := RETCODUSR()
	z38->z38_respon := _nomeUsuario
	_mNum   	      := Z38->Z38_NUM
	_mSituaCH 		  := "Em atendimento pelo Analista: "+_nomeUsuario
	_mStatus		  := "Chamado em Atendimento "
	z38->z38_dtprev := _cData
	z38->z38_horap  := _cHora
	z38->z38_dtatd  := date()
	z38->z38_hratd  := time()
	z38_temp1		:= (date()-z38->z38_dtabert)*24+(round(val(time())+(val(substr(time(),4,2))/60),2)-(val(z38->z38_hrsoli)+round(val((substr(z38->z38_hrsoli,4,2)))*100/60,0)/100))
	_cHora2		    := substr(_cHora,1,2)+":"+substr(_cHora,3,2)
	_histA			:= Alltrim(z38->z38_obs)
	_histA			+= chr(10)+chr(13)+chr(10)+chr(13)+"<br>"+replicate("-",110)+"<br>"+chr(10)+chr(13)+chr(10)+chr(13)
	_histA2		  := "Chamado em atendimento pelo Analista: "+_nomeUsuario+chr(10)+chr(13)
	_histA2		  += chr(10)+chr(13)+chr(10)+chr(13)+"Data: "+DTOC(date())+" Hora: "+time()+chr(10)+chr(13)
	_histA2		  += chr(10)+chr(13)+"Previsão de Conclusão do Antedimento: "+dtoc(_cData)+" Hora: "+_cHora2+chr(10)+chr(13)
	_histA			  += _histA2
	z38->z38_obs    := _histA
	_msg			  := z38->z38_obs
	MsUnlock()
	_email()
	P1_cProt:=" "
	oTela:END()

return

//********************************************************* Tela para acerto de tempo do chamado *************************************************************************

User Function TITempo

	_nTempo1 := z38->z38_temp1
	_nTempo2 := z38->z38_temp2
	_nTempo3 := z38->z38_temp3
	_nTempo4 := z38->z38_temp4

	Private lsair:= .F.

	oFnt3 := TFont():New( "Arial",08,16,,.T.)

	DEFINE MSDIALOG oTela TITLE "Acerta Tempos do Chamado" FROM 000,000 TO 200,300 PIXEL

	@ 005,035 Say "Acerto de Tempos do Chamado"    	COLOR  	CLR_HRED   	PIXEL OF 	oTela 		Font 	oFnt3
	@ 015,010 Say "Tempo 01 / Espera"				    	PIXEL 	OF 	oTela 		Font 	oFnt3
	@ 015,100 Get _nTempo1 									Size 	25,20  			Picture 	"999999.99"
	@ 030,010 Say "Tempo 02 / Atendimento"	 				PIXEL 	OF 	oTela 		Font 	oFnt3
	@ 030,100 Get _nTempo2 									Size 	25,20 		   	Picture 	"999999.99"
	@ 045,010 Say "Tempo 03 / Chamado"	 					PIXEL 	OF 	oTela 		Font 	oFnt3
	@ 045,100 Get _nTempo3 									Size 	25,20 		   	Picture 	"999999.99"
	@ 060,010 Say "Tempo 04 / Validação"	 				PIXEL 	OF 	oTela 		Font 	oFnt3
	@ 060,100 Get _nTempo4 									Size 	25,20 		   	Picture 	"999999.99"

	@ 075,010 Button 			OemToAnsi("_Gravar") 			Size 		30,20 		Action 	GravTemp()
	@ 075,050 Button 			OemToAnsi("_Sair") 			Size 		30,20 		Action 	(Close(oTela))
	@ 075,090 Button 			OemToAnsi("_Visualisar") 	Size 		30,20 		Action 	U_Vfat()

	ACTIVATE MSDIALOG oTela CENTERED


Return

static function GravTemp

	reclock("Z38",.f.)
	z38->z38_temp1 := _nTempo1
	z38->z38_temp2 := _nTempo2
	z38->z38_temp3 := _nTempo3
	z38->z38_temp4 := _nTempo4	
	MsUnlock()
	oTela:END()

return

//********************************************************* Tela para acerto de tempo do chamado *************************************************************************

User Function TIProb

	_cProb := z38->z38_modulo

	Private lsair:= .F.

	oFnt3 := TFont():New( "Arial",08,16,,.T.)

	DEFINE MSDIALOG oTela TITLE "Definição de um tipo de Problema para o Chamado" FROM 000,000 TO 200,400 PIXEL

	@ 005,035 Say "Defina um Problema para este Chamado"    	COLOR  	CLR_HRED   	PIXEL OF 	oTela 		Font 	oFnt3
	@ 015,010 Say "Problema:"						    		PIXEL 	OF 	oTela 		Font 	oFnt3
	@ 015,100 Get _cProb   										Size 	25,20 F3 "Z39"
	
	@ 075,010 Button 			OemToAnsi("_Gravar") 			Size 		30,20 		Action 	GravProb()
	@ 075,050 Button 			OemToAnsi("_Sair") 			Size 		30,20 		Action 	(Close(oTela))
	@ 075,090 Button 			OemToAnsi("_Visualisar") 	Size 		30,20 		Action 	U_Vfat()

	ACTIVATE MSDIALOG oTela CENTERED


Return

static function GravProb

	reclock("Z38",.f.)
	z38->z38_modulo := _cProb
	MsUnlock()
	oTela:END()

return
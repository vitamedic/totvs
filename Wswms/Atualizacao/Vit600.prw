#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "MSMGADD.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE nTRB  1
#DEFINE nIND1 2
#DEFINE nIND2 3
#DEFINE nIND3 3
#DEFINE nIND4 4

/*/{Protheus.doc} Vit600
Painel de Expedição
@author Microsiga
@since 05/04/17 
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function Vit600()
	Local _afields:={}
	Local oMarkPrivate

	aRotina := {}

	Private _aUsu  		:= PswRet(1)
	Private aTRB 		:= {}
	Private cMark		:=GetMark()
	Private aNumOS 		:= {}
	Private cChave 		:= Space(255)
	Private aLegenda	:= {}
	Private cFiltroTRB 	:= ""
	Private cCadastro 	:= "Painel de Faturamento"

	AAdd(aLegenda, {"BR_AZUL   "	, "A Liberar"		                    })
	AAdd(aLegenda, {"BR_AMARELO"	, "Apto a Separar"                 		})
	AAdd(aLegenda, {"BR_VERDE"   	, "Apto a faturar"                 		})
	AAdd(aLegenda, {"BR_VERMELHO"  	, "Faturado"                     		})

	aCores := {}
	aAdd(aCores,{"TRB->BLWMS = '01'"                        	, "BR_AZUL"	})
	aAdd(aCores,{"TRB->BLWMS = '02'"                        	, "BR_AMARELO"	})
	aAdd(aCores,{"TRB->BLWMS = '05' .and. TRB->BLEST = '  '" 	, "BR_VERDE"	    })
	aAdd(aCores,{"TRB->BLWMS = '05' .and. TRB->BLEST = '10'" 	, "BR_VERMELHO"    })

	aRotina   := {  { "Marcar Todos" 	, "u_Vit600M" 		, 0, 4},; //ok
	{ "Desmarcar Todos" , "u_Vit600D" 		, 0, 4},; //ok
	{ "Inverter Todos" 	, "u_Vit600A"		, 0, 4},; //ok
	{ "Legenda" 		, "u_Vit600L" 		, 0, 4},; //ok
	{ "Pesquisa" 		, "u_Vit600P"		, 0, 1},; //ok
	{ "Reprocessa" 		, "u_Vit600R"		, 0, 3},;
	{ "Lib.P/Separar"	, "u_Vit600S('1')"	, 0, 3},;
	{ "Lib.P/Faturar "  , "u_Vit600Z"	    , 0, 3},;
	{ "Aponta Peso/Vol"	, "u_Vit600V"		, 0, 3},;
	{ "Imprime OS" 		, "u_Vit600O"		, 0, 3},;
	{ "Retorna Pedido" 	, "u_Vit600E"		, 0, 3}}

	if !ValidPerg()
		Return()
	endif
	criatmp4()
	
	mv_par01 := DtoS(mv_par01)
	
	If !empty(tmp4->liber) .and. mv_par01 < tmp4->liber
		mv_par01 := tmp4->liber
	EndIf
	
	MsgRun("Criando estrutura e carregando dados no arquivo temporário...",,{|| aTRB := GeraTemp() } )

	AADD(_afields,{"OK"			,"", ""						})
	AADD(_afields,{"SEPARA"		,"", "Separado"				})
	AADD(_afields,{"APONTA"		,"", "Peso/vol"				})
	AADD(_afields,{"PEDIDO"		,"", "Pedido"				})
	AADD(_afields,{"AGREG"		,"", "Agrega"				})
	AADD(_afields,{"CLIENTE"	,"", "Cliente"				})
	AADD(_afields,{"LOJA"		,"", "Loja"					})
	AADD(_afields,{"ESTADO"		,"", "Estado"				})
	AADD(_afields,{"NOME"		,"", "Nome"					})
	AADD(_afields,{"PRECO"  	,"", "Valor"    			, "@E 999,999,999.99999999"})
	AADD(_afields,{"DESCO"		,"", "Desconto"		    	, "@E 999,999,999.99999999"})
	AADD(_afields,{"CONDPAG"	,"", "Cond Pag"				})
	AADD(_afields,{"DIFAL"		,"", "Difal"				})
	AADD(_afields,{"SUFRAMA"	,"", "Suframa"				})
	AADD(_afields,{"NFISCAL"	,"", "Nota fiscal"			})
	AADD(_afields,{"SERIENF"	,"", "Serie"				})
	AADD(_afields,{"MENPED" 	,"", "Mensagem do Pedido"	})
	AADD(_afields,{"DATALIB"	,"", "Empenho"				})
	AADD(_afields,{"DATASEP"	,"", "Dt Lib Sep"			})
	AADD(_afields,{"DATAFAT"	,"", "Dt Lib fat"			})


	dbSelectArea("TRB")
	dbSetOrder(nIND1)
	dbGoTop()

	MarkBrow( 'TRB', 'OK',,_afields,, cMark,'u_Vit600A()',,,,'u_Vit600F()',/*{|| u_Vit600A()}*/, cFiltroTRB, , aCores, , , ,.F.)

	FechaArqTemp()

Return()

User Function Vit600L()

	BrwLegenda(cCadastro, "Status do Item", aLegenda)

Return()

User Function Vit600R()
	Local oMark := GetMarkBrow()

	if !ValidPerg()
		Return()
	endif

	FechaArqTemp()

	MsgRun("Criando estrutura e carregando dados no arquivo temporário...",,{|| aTRB := GeraTemp() } )

	MarkBRefresh()

	// força o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()

Return()
/*/{Protheus.doc} Vit600a
@author Stephen Noel
@since 16/07/18 
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function Vit600B()

	Local oMark := GetMarkBrow()

	FechaArqTemp()

	MsgRun("Criando estrutura e carregando dados no arquivo temporário...",,{|| aTRB := GeraTemp() } )

	MarkBRefresh()

	// força o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()

Return()

//Excluir
User Function Vit600E()
	Local oMark := GetMarkBrow()
	Local lOk   := .f.
	Local _ped2 

	BeginTran()

	dbSelectArea('TRB')
	dbGotop()
	do while TRB->(!Eof())
		_ped2 = ' '
		if IsMark( 'OK', cMark )
			If TRB->BLEST <> '10'
				If MsgYesNo( 'Deseja devolver o Pedido '+ TRB->PEDIDO + 'Para o estagio anterior?', 'Exclusão de Pedido' )
					dbSelectArea("Z52")
					Z52->(dbSetOrder(1))
					Z52->(dbGoBottom())
					While Z52->(!Bof()) 
						IF alltrim(TRB->PEDIDO) = alltrim(Z52->Z52_PEDIDO)
							_ped2:= Z52->Z52_PEDIDO

							RecLock("Z52", .f.)
							Z52->Z52_USUE 	:= _aUsu[1][2]
							Z52->Z52_DTEXC 	:= DDataBase
							Z52->( MsUnLock() )
							Z52->( dbDelete() )
							Z52->( MsUnLock() )

							dbSelectArea("SC9")
							dbSetOrder(1)
							if ( lOk := dbSeek(XFilial("SC9")+Z52->Z52_PEDIDO+Z52->Z52_ITEM+Z52->Z52_SEQ+Z52->Z52_COD) .and. RecLock("SC9", .f.) )
								SC9->C9_XSTATUS := " "
								If Z52->Z52_BLWMS = "05"
									SC9->C9_BLWMS := "02"
								ElseIf Z52->Z52_BLWMS = "02"
									SC9->C9_BLWMS := "01"
								Else
									Alert("Pedido com este Status não pode ser excluido!")
									lOk:= .f.
								EndIf
								SC9->( MsUnLock() )
							endif
							if ( lOk := TRB->(RecLock("TRB", .f.)) )
								TRB->( dbDelete() )
								TRB->( MsUnLock() )
							else
								exit
							endif
						ENDIF
						Z52->(dbSkip(-1))
						if !empty(_ped2) .and. _ped2 <> Z52->Z52_PEDIDO
							EXIT
						EndIf
					EndDo
				Else //yesno
				EndIf //yesno
			Else
				Alert("Não é possivel Excluir o pedido "+ trb->pedido + " Pois já foi faturado!")
			EndIf
		endif
		dbSelectArea("TRB")
		dbSkip()
	enddo

	if !lOK
		DisarmTransaction()
		msgAlert("Ocorreu erro ao tentar excluír o pedido do painel de separação.")
	Else
		EndTran()
		msgAlert("Pedido excluído do painel de separação com sucesso.")
	endif
	u_vit600b()
Return()

User Function Vit600M()
	Local oMark := GetMarkBrow()
	DbSelectArea("TRB")
	DbGotop()
	do while !Eof()
		if RecLock( 'TRB', .F. )
			TRB->OK := cMark
			MsUnLock()
		endif
		dbSkip()
	enddo
	MarkBRefresh( )
	// força o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()
return

User Function Vit600D()
	Local oMark := GetMarkBrow()
	DbSelectArea("TRB")
	DbGotop()
	do while !Eof()
		if RecLock( 'TRB', .F. )
			TRB->OK := SPACE(2)
			MsUnLock()
		endif
		dbSkip()
	enddo
	MarkBRefresh()
	// força o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()
Return

// Grava marca no campo
User Function Vit600F()
	if IsMark( 'OK', cMark )
		RecLock( 'TRB', .F. )
		Replace OK With Space(2)
		MsUnLock()
	Else
		RecLock( 'TRB', .F. )
		Replace OK With cMark
		MsUnLock()
	endif
Return

// Grava marca em todos os registros validos
User Function Vit600A()
	Local oMark := GetMarkBrow()
	dbSelectArea('TRB')
	dbGotop()
	do while !Eof()
		u_Vit600F()
		dbSkip()
	enddo
	MarkBRefresh( )
	// força o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()
Return

/**************************/
Static Function ValidPerg()
	/**************************/
	Local aHelpPor := {}
	Local cPerg    := Pad("Vit600",10)

	PutSx1(cPerg,"01",OemToAnsi("Liberação De     ?"),"","","mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,{},{})
	PutSx1(cPerg,"02",OemToAnsi("Liberação Até    ?"),"","","mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,{},{})
	PutSx1(cPerg,"03",OemToAnsi("Pedido De        ?"),"","","mv_ch3","C",06,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,{},{})
	PutSx1(cPerg,"04",OemToAnsi("Pedido Até       ?"),"","","mv_ch4","C",06,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,{},{})
	PutSx1(cPerg,"05",OemToAnsi("Cliente De       ?"),"","","mv_ch5","C",06,0,0,"G","","SA1","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,{},{})
	PutSx1(cPerg,"06",OemToAnsi("Cliente Até      ?"),"","","mv_ch6","C",06,0,0,"G","","SA1","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,{},{})
	PutSx1(cPerg,"07",OemToAnsi("Status           ?"),"","","mv_ch7","N",01,0,0,"C","","","","S","mv_par07","Geral","","1","","A Liberar","","","Apto a Separar","","","Apto a Faturar","","","Faturado","","",aHelpPor,{},{})

Return(Pergunte(cPerg,.T.))

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Vt627Stats ³ Autor ³ Henrique Corrêa     ³ Data ³ 17/07/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Selecionar os Status das Ordens de Separação  			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Vt627Stats()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³           												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function Vt627Stats()
	Local MvPar
	Local l1Elem 	:= .F.
	Local cTitulo 	:="Status da Ordem de Separação"
	Local MvParDef	:="ABCDEFGHI" 

	Private aOpcoes	:={}

	cAlias 	:= Alias() 					// Salva Alias Anterior
	MvPar	:= &(Alltrim(ReadVar()))	// Carrega Nome da Variavel do Get em Questao
	mvRet	:= Alltrim(ReadVar())		// Iguala Nome da Variavel ao Nome variavel de Retorno


	aOpcoes :={;
	"A - A liberar",;
	"B - Apto a Separar",;
	"C - Apto a Faturar",;
	"D - Faturado";
	}

	IF f_Opcoes(@MvPar,cTitulo,aOpcoes,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
		&MvRet := MvPar										 // Devolve Resultado
	EndIF
	dbSelectArea(cAlias) 								 // Retorna Alias
Return(.T.)

Static Function GeraTemp()
	Local cQry   	:= ""
	Local aStru  	:= {}
	Local _cStatus 	:= ""
	Local _cBlEst   := ""
	Local _flag:= 0
	Local _pedido
	Local _nfisca
	Private _agreg


	if Select("TRB") > 0
		FechaArqTemp()
	endif

	//ª Estrutura da tabela temporaria
	AADD(aStru,{"OK"		,"C", 02, 0})
	AADD(aStru,{"SEPARA"	,"C", 02, 0})
	AADD(aStru,{"APONTA"	,"C", 02, 0})
	AADD(aStru,{"PEDIDO"	,"C", 06, 0})
	AADD(aStru,{"ITEM"		,"C", 02, 0})
	AADD(aStru,{"SEQ"		,"C", 02, 0})
	AADD(aStru,{"NUMOS"		,"C", 02, 0})
	AADD(aStru,{"LOCAL"		,"C", 02, 0})
	AADD(aStru,{"COD"		,"C", 15, 0})
	AADD(aStru,{"DESC"		,"C", 40, 0})
	AADD(aStru,{"UM"		,"C", 02, 0})
	AADD(aStru,{"LOTE"		,"C", 10, 0})
	AADD(aStru,{"DATAVAL"	,"C", 10, 0})
	AADD(aStru,{"DATALIB"	,"C", 10, 0})
	AADD(aStru,{"DATAFAT"	,"C", 10, 0})
	AADD(aStru,{"DATASEP"	,"C", 10, 0})
	AADD(aStru,{"QTDLIB"	,"N", 16, 5})
	AADD(aStru,{"CLIENTE"	,"C", 06, 0})
	AADD(aStru,{"LOJA"		,"C", 02, 0})
	AADD(aStru,{"ESTADO"	,"C", 02, 0})
	AADD(aStru,{"SUFRAMA"	,"C", 07, 0})
	AADD(aStru,{"DIFAL"	    ,"C", 05, 0})
	AADD(aStru,{"NOME"		,"C", 40, 0})
	AADD(aStru,{"STATUS"	,"C", 01, 0})
	AADD(aStru,{"BLEST"		,"C", 02, 0})
	AADD(aStru,{"BLCRED"	,"C", 02, 0})
	AADD(aStru,{"PRECO" 	,"N", 18, 8})
	AADD(aStru,{"DESCO"	    ,"N", 18, 8})
	AADD(aStru,{"CONDPAG"	,"C", 05, 0})
	AADD(aStru,{"BLWMS" 	,"C", 02, 0})
	AADD(aStru,{"AGREG"	    ,"C", 04, 0})
	AADD(aStru,{"NFISCAL" 	,"C", 09, 0})
	AADD(aStru,{"SERIENF"	,"C", 03, 0})
	AADD(aStru,{"MENPED"	,"C",100, 0})

	// Crio o arquivo de trabalho e os índices
	cArqTRB := CriaTrab( aStru, .T. )
	cInd1 := Left( cArqTRB, 7 ) + "1"
	cInd2 := Left( cArqTRB, 7 ) + "2"
	cInd3 := Left( cArqTRB, 7 ) + "3"
	cInd4 := Left( cArqTRB, 7 ) + "4"

	// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
	dbUseArea( .T., __LocalDriver, cArqTRB, "TRB", .F., .F. )

	// Criar os índices.
	IndRegua( "TRB", cInd1, "PEDIDO+ITEM+SEQ+NUMOS", , , "Criando índices (Pedido + Item + Seq. + Num. OS)...")
	IndRegua( "TRB", cInd2, "CLIENTE+LOJA+PEDIDO+ITEM+SEQ+NUMOS", , , "Criando índices (Cliente + Loja + Pedido + Item + Seq. + Num. OS)...")
	IndRegua( "TRB", cInd3, "DESC", , , "Criando índices (Descrição dos Produtos)...")
	IndRegua( "TRB", cInd4, "DATALIB", , , "Criando índices (Descrição por Data de Liberação)...")

	// Libera os índices.
	dbClearIndex()

	// Agrega a lista dos índices da tabela (arquivo).
	dbSetIndex( cInd1 + OrdBagExt() )
	dbSetIndex( cInd2 + OrdBagExt() )
	dbSetIndex( cInd3 + OrdBagExt() )
	dbSetIndex( cInd4 + OrdBagExt() )

	dbSetOrder(1)

	if !u_Vt600AtuZ52()
		msgAlert("Erro ao tentar limpar pedidos com liberação cancalada do painel de expedição.", "A t e n ç ã o")

	else
//	mv_par01 := DtoS(mv_par01)
	If !empty(tmp4->liber) .and. (mv_par01 < tmp4->liber)
		mv_par01 := tmp4->liber
	EndIf


		cQry :=        " SELECT Z52.Z52_PEDIDO "
		cQry += CRLF + "      , Z52.Z52_ITEM "
		cQry += CRLF + "      , Z52.Z52_SEQ "
		cQry += CRLF + "      , Z52.Z52_Local "
		cQry += CRLF + "      , Z52.Z52_COD "
		cQry += CRLF + "      , SB1.B1_DESC  "
		cQry += CRLF + "      , SB1.B1_UM "
		cQry += CRLF + "      , Z52.Z52_QTDLIB "
		cQry += CRLF + "      , Z52.Z52_CLIENT "
		cQry += CRLF + "      , Z52.Z52_LOJA "
		cQry += CRLF + "      , Z52.Z52_STATUS "
		cQry += CRLF + "      , Z52.Z52_DATALI "
		cQry += CRLF + "      , Z52.Z52_DTALT "
		cQry += CRLF + "      , Z52.Z52_DTEXC "
		cQry += CRLF + "      , Z52.Z52_BLEST "
		cQry += CRLF + "      , Z52.Z52_BLCRED "
		cQry += CRLF + "      , Z52.Z52_NUMOS "
		cQry += CRLF + "      , Z52.Z52_LOTECT "
		cQry += CRLF + "      , Z52.Z52_DTVALI "
		cQry += CRLF + "      , Z52.Z52_BLWMS "
		cQry += CRLF + "      , Z52.Z52_SEPARA "
		cQry += CRLF + "      , Z52.Z52_AGREG "
		cQry += CRLF + "      , SC5.C5_TIPO TIPO, "
		cQry += CRLF + "      CASE WHEN C5_TIPO <> 'B' THEN " 
		cQry += CRLF + "      (select(SA1.A1_NOME) from SA1010 SA1 WHERE SA1.A1_COD = Z52.Z52_CLIENT AND SA1.A1_LOJA = Z52.Z52_LOJA AND SA1.D_E_L_E_T_  = ' ') "
		cQry += CRLF + "      WHEN C5_TIPO = 'B' THEN "
		cQry += CRLF + "      (select(SA2.A2_NOME) from SA2010 SA2 WHERE SA2.A2_COD = Z52.Z52_CLIENT AND SA2.A2_LOJA = Z52.Z52_LOJA AND SA2.D_E_L_E_T_  = ' ') "
		cQry += CRLF + "      END NOME "
		cQry += CRLF + " FROM "+RetSqlName("Z52")+" Z52  "
		cQry += CRLF + " INNER JOIN "+RetSqlName("SB1")+" SB1 ON (SB1.B1_FILIAL       = '"+XFilial("SB1")+"' "
		cQry += CRLF + "                           AND SB1.B1_COD      = Z52.Z52_COD "
		cQry += CRLF + "                           AND SB1.D_E_L_E_T_  = ' '  "
		cQry += CRLF + "                          ) "
		cQry += CRLF + "INNER JOIN SC5010 SC5 ON (SC5.C5_FILIAL       = '01'"
		cQry += CRLF + "                   AND C5_NUM = Z52.Z52_PEDIDO "
		cQry += CRLF + "                   AND SC5.D_E_L_E_T_ = ' ')"
		cQry += CRLF + " WHERE Z52.Z52_FILIAL  = '"+XFilial("Z52")+"' "
		cQry += CRLF + "   AND Z52.D_E_L_E_T_  = ' ' "
		cQry += CRLF + "   AND Z52.Z52_BLEST   IN (' ', '10') "
		cQry += CRLF + "   AND Z52.Z52_BLCRED  IN (' ', '10') "

		if !empty(mv_par01) .and. !empty(mv_par02)
			cQry += CRLF + "   AND Z52.Z52_DATALI BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
		endif

		if !empty(mv_par03) .and. !empty(mv_par04)
			cQry += CRLF + "   AND Z52.Z52_PEDIDO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
		endif

		if !empty(mv_par05) .and. !empty(mv_par06)
			cQry += CRLF + "   AND Z52.Z52_CLIENT BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
		endif

		//1 - geral 2 - A liberar 3 - Apto a Separar 4 - Apto a Faturar 5 - Faturado
		If mv_par07 = 2
			cQry += CRLF + "   AND Z52.Z52_BLWMS = '01'"
		ElseIf mv_par07 = 3
			cQry += CRLF + "   AND Z52.Z52_BLWMS = '02'"
		ElseIf mv_par07 = 4
			cQry += CRLF + "   AND Z52.Z52_BLWMS = '05'"
			cQry += CRLF + "   AND Z52.Z52_BLEST = ' '"
		ElseIf mv_par07 = 5
			cQry += CRLF + "   AND Z52.Z52_BLWMS = '05'"
			cQry += CRLF + "   AND Z52.Z52_BLEST = '10'"
		EndIf


		if !empty(_cBlEst)
			cQry += CRLF + "   AND Z52.Z52_BLEST IN ("+_cBlEst+") "
		endif

		cQry += CRLF + " ORDER BY Z52.Z52_FILIAL "
		cQry += CRLF + "        , Z52.Z52_PEDIDO "
		cQry += CRLF + "        , Z52.Z52_AGREG "
		cQry += CRLF + "        , Z52.Z52_DATALI "
		cQry += CRLF + "        , Z52.Z52_NUMOS "
		cQry += CRLF + "        , Z52.Z52_ITEM  "
		cQry += CRLF + "        , Z52.Z52_SEQ  "
		cQry += CRLF + " "

		if Select("QZ52") > 0
			dbSelectArea("QZ52")
			dbCloseArea()
		endif

		TCQuery cQry New Alias "QZ52"

		memowrite("C:/Stephen/top15.txt",cqry)

		do while QZ52->( !Eof() )
			_pedido := QZ52->Z52_PEDIDO
			_agreg  := QZ52->Z52_AGREG 
			_datalib  := QZ52->Z52_DATALI
			IF QZ52->TIPO = "B"
				CRIATMP2()
			ELSE
				CRIATMP1()
			ENDIF
			DbSelectarea("TMP1")	
			_nfisca := TMP1->NFISCAL
			If _flag = 0
				dbSelectArea("TRB")
				if RecLock("TRB", .t.)

					TRB->NUMOS 		:= QZ52->Z52_NUMOS
					TRB->PEDIDO 	:= QZ52->Z52_PEDIDO
					TRB->ITEM 		:= QZ52->Z52_ITEM
					TRB->SEQ 		:= QZ52->Z52_SEQ
					TRB->Local 		:= QZ52->Z52_LOCAL
					TRB->COD 		:= QZ52->Z52_COD
					TRB->DESC 		:= QZ52->B1_DESC
					TRB->UM 		:= QZ52->B1_UM
					TRB->LOTE 		:= QZ52->Z52_LOTECT
					TRB->DATAVAL	:= DtoC(StoD(QZ52->Z52_DTVALI))
					TRB->DATALIB	:= DtoC(StoD(QZ52->Z52_DATALI))
					TRB->DATAFAT	:= DtoC(StoD(QZ52->Z52_DTEXC))
					TRB->DATASEP	:= DtoC(StoD(QZ52->Z52_DTALT))
					TRB->QTDLIB		:= QZ52->Z52_QTDLIB
					TRB->CLIENTE	:= QZ52->Z52_CLIENT
					TRB->LOJA 		:= QZ52->Z52_LOJA
					TRB->ESTADO		:= TMP1->ESTADO
					TRB->NOME 		:= QZ52->NOME
					TRB->STATUS 	:= QZ52->Z52_STATUS
					TRB->BLEST 		:= QZ52->Z52_BLEST
					TRB->BLCRED 	:= QZ52->Z52_BLCRED
					TRB->PRECO      := Round(TMP1->PRECO,2)
					TRB->DESCO      := TMP1->DESCO
					TRB->BLWMS      := QZ52->Z52_BLWMS
					TRB->CONDPAG    := TMP1->CONDPAG 
					TRB->NFISCAL    := TMP1->NFISCAL
					TRB->SERIENF    := TMP1->SERIENF
					TRB->SUFRAMA    := TMP1->SUFRAMA
					TRB->SEPARA		:= QZ52->Z52_SEPARA
					TRB->AGREG		:= QZ52->Z52_AGREG
					TRB->MENPED     := TMP1->MENPED

					IF TMP1->TIPO = "F" .AND. TMP1->ESTADO <>"GO"
						TRB->DIFAL := "DIFAL"
					ELSE
						TRB->DIFAL := " -- "
					ENDIF
					TRB->APONTA:= TMP1->DATALIB
					TRB->( MsUnLock() )
				endif
				QZ52->( dbSkip() )
				If _pedido = QZ52->Z52_PEDIDO .and. _agreg = QZ52->Z52_AGREG .AND. _nfisca = TMP1->NFISCAL//_datalib = QZ52->Z52_datali
					_flag := 1
				Else
					_flag := 0
				EndIf
			Else
				QZ52->( dbSkip() )
				If _pedido = QZ52->Z52_PEDIDO .and. _agreg = QZ52->Z52_AGREG .AND. _nfisca = TMP1->NFISCAL//_datalib = QZ52->Z52_datali
					_flag := 1
				Else
					_flag := 0
				EndIf
			EndIf
			TMP1->(DbCloseArea())
		enddo

		QZ52->( dbCloseArea() )

	endif

Return({cArqTRB, cInd1, cInd2, cInd3, cInd4})

Static Function FechaArqTemp()

	//Fecha a área
	TRB->(dbCloseArea())

	//Apaga o arquivo fisicamente
	FErase( aTRB[ nTRB ] + GetDbExtension())

	//Apaga os arquivos de índices fisicamente
	FErase( aTRB[ nIND1 ] + OrdBagExt())
	FErase( aTRB[ nIND2 ] + OrdBagExt())
	FErase( aTRB[ nIND3 ] + OrdBagExt())

Return()

User Function Vt600AtuZ52(pPedido, pItem, pSeq, pNumOS, pStatus)
	Local cQry   	:= ""
	Local cArSC9 	:= "QSC9" //GetNextAlias()
	Local aStru  	:= {}
	Local nRet   	:= 0
	Local _cStatus 	:= ""
	Local cDataLib  := SuperGetMV("MV_XDTLIBE", .f., "20180723")

	Default pPedido := ""
	Default pItem	:= ""
	Default pSeq	:= ""
	Default pNumOS  := ""
	Default pStatus := "5"

If Valtype(mv_par01) = "D"	
	mv_par01 := DtoS(mv_par01)
EndIf	
	If !empty(tmp4->liber) .and. mv_par01 < tmp4->liber
		mv_par01 := tmp4->liber
	EndIf

	cQry :=        " DELETE FROM "+RetSqlName("Z52")+" "
	cQry += CRLF + " WHERE Z52_FILIAL = '"+XFilial("Z52")+"' "
	cQry += CRLF + "   AND Z52_BLEST  <> '10' "
	cQry += CRLF + "   AND Z52_BLCRED <> '10' "
	cQry += CRLF + "   AND Z52_STATUS = '5' "
	cQry += CRLF + "   AND D_E_L_E_T_ = ' ' "
	cQry += CRLF + "   AND NOT EXISTS(SELECT * "
	cQry += CRLF + "                  FROM "+RetSqlName("SC9")+" SC9 "
	cQry += CRLF + "                  WHERE SC9.C9_FILIAL       = '"+XFilial("SC9")+"' "
	cQry += CRLF + "                    AND SC9.C9_PEDIDO       = Z52_PEDIDO "
	cQry += CRLF + "                    AND SC9.C9_ITEM         = Z52_ITEM "
	cQry += CRLF + "                    AND SC9.C9_SEQUEN       = Z52_SEQ "
	cQry += CRLF + "                    AND SC9.C9_Local        = Z52_Local "
	cQry += CRLF + "                    AND ((SC9.C9_BLEST   = ' ' OR (SC9.C9_BLEST  = '10' AND SC9.C9_DATALIB >= '"+mv_par01+"')) "
	cQry += CRLF + "                         AND (SC9.C9_BLCRED  = ' ' OR (SC9.C9_BLCRED = '10' AND SC9.C9_DATALIB >= '"+mv_par01+"')) "
	cQry += CRLF + "                        ) "
	cQry += CRLF + "                    AND SC9.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "                 ) "

	nRet := TCSqlExec(cQry)

		mv_par02 := DtoS(mv_par02)

	if nRet < 0
		msgAlert("Erro ao tentar limpar pedidos com liberação cancalada do painel de expedição.", "A t e n ç ã o")
	else

		//DANILO: atualizo status dos campos BLEST, pegando da SC9 para Z52
		cQry := " SELECT Z52.R_E_C_N_O_ RECZ52, C9_BLEST, C9_BLCRED, C9_BLWMS, C9_SEPARA, C9_DATALIB "
		cQry += " FROM "+RetSqlName("Z52")+" Z52 "
		cQry += " INNER JOIN "+RetSqlName("SC9")+" SC9 "
		cQry += " ON Z52.D_E_L_E_T_ = ' ' "
		cQry += " AND SC9.D_E_L_E_T_ = ' ' "
		cQry += " AND Z52_FILIAL = C9_FILIAL "
		cQry += " AND Z52_PEDIDO = C9_PEDIDO "
		cQry += " AND Z52_ITEM = C9_ITEM "
		cQry += " AND Z52_SEQ = C9_SEQUEN "
		cQry += " AND Z52_COD = C9_PRODUTO "
		cQry += " AND Z52_LOCAL = C9_LOCAL "
		cQry += " WHERE Z52_FILIAL = '"+XFilial("Z52")+"' "
		if !empty(mv_par01) .and. !empty(mv_par02)
			cQry += " AND SC9.C9_DATALIB BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
		endif
		//filtro por pedido
		if !Empty(MV_PAR04)
			cQry += " AND SC9.C9_PEDIDO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
		endif
		//filtro por cliente
		if !Empty( MV_PAR06 )
			cQry += " AND SC9.C9_CLIENTE BETWEEN '"+ MV_PAR05 +"' AND '" + MV_PAR06 + "'"
		endif
		if Select("QAUX") > 0
			QAUX->(dbCloseArea())
		endif
		TCQuery cQry New Alias "QAUX"
		memowrite("C:/Stephen/vit600.txt",cqry)
		while QAUX->( !Eof() )
			Z52->(DbGoTo(QAUX->RECZ52 ))
			Reclock("Z52", .F.)
			Z52->Z52_BLEST := QAUX->C9_BLEST
			Z52->Z52_BLCRED := QAUX->C9_BLCRED
			Z52->Z52_BLWMS := QAUX->C9_BLWMS
			Z52->Z52_SEPARA:= QAUX->C9_SEPARA
			Z52->Z52_DATALI:= StoD(QAUX->C9_DATALIB)
			Z52->(MsUnlock())
			QAUX->(DbSkip())
		enddo
		QAUX->(DbCloseArea())
		//FIM DANILO
		cQry :=        " SELECT SC9.* "
		cQry += CRLF + " FROM "+RetSqlName("SC9")+" SC9 "
		cQry += CRLF + " WHERE ((SC9.C9_FILIAL  = '"+XFilial("SC9")+"' "
		cQry += CRLF + "   AND (SC9.C9_BLEST    = ' ' OR (SC9.C9_BLEST  = '10' AND SC9.C9_DATALIB >= '"+cDataLib+"'))"
		cQry += CRLF + "   AND (SC9.C9_BLCRED   = ' ' OR (SC9.C9_BLCRED = '10' AND SC9.C9_DATALIB >= '"+cDataLib+"'))"
		cQry += CRLF + "   AND (SC9.C9_BLWMS <> ' ') "
		cQry += CRLF + "   AND SC9.D_E_L_E_T_   = ' ') "
		cQry += CRLF + "    OR (SC9.C9_PEDIDO   = '"+pPedido+"' AND SC9.C9_ITEM = '"+pItem+"' AND SC9.C9_SEQUEN = '"+pSeq+"')) "
		if !empty(mv_par01) .and. !empty(mv_par02)
			cQry += CRLF + "   AND SC9.C9_DATALIB BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
		endif
		//filtro por pedido
		if !Empty(MV_PAR04)
			cQry += CRLF + " AND SC9.C9_PEDIDO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
		endif
		//filtro por cliente
		if !Empty( MV_PAR06 )
			cQry += CRLF + " AND SC9.C9_CLIENTE BETWEEN '"+ MV_PAR05 +"' AND '" + MV_PAR06 + "'"
		endif
		cQry += CRLF + "   AND NOT EXISTS(SELECT * "
		cQry += CRLF + "                  FROM "+RetSqlName("Z52")+" Z52 "
		cQry += CRLF + "                  WHERE Z52.Z52_FILIAL = '"+XFilial("Z52")+"' "
		cQry += CRLF + "                    AND Z52.Z52_PEDIDO = SC9.C9_PEDIDO "
		cQry += CRLF + "                    AND Z52.Z52_ITEM   = SC9.C9_ITEM "
		cQry += CRLF + "                    AND Z52.Z52_SEQ    = SC9.C9_SEQUEN "
		cQry += CRLF + "                    AND Z52.Z52_Local  = SC9.C9_Local "
		cQry += CRLF + "                    AND Z52.D_E_L_E_T_ = ' ' "
		cQry += CRLF + "                 )"
		//		cQry += CRLF + " GROUP BY SC9->C9_DATALIB "

		if Select("QSC9") > 0
			dbSelectArea("QSC9")
			dbCloseArea()
		endif

		TCQuery cQry New Alias "QSC9"
		memowrite("C:/Stephen/QSC9.txt",cQry)

		do while QSC9->( !Eof() )
			dbSelectArea("Z52")
			if RecLock("Z52", .t.)

				Z52->Z52_FILIAL 	:= XFilial("Z52")
				Z52->Z52_PEDIDO 	:= QSC9->C9_PEDIDO
				Z52->Z52_ITEM 		:= QSC9->C9_ITEM
				Z52->Z52_SEQ 		:= QSC9->C9_SEQUEN
				Z52->Z52_LOCAL 		:= QSC9->C9_LOCAL
				Z52->Z52_COD 		:= QSC9->C9_PRODUTO
				Z52->Z52_CLIENT		:= QSC9->C9_CLIENTE
				Z52->Z52_LOJA 		:= QSC9->C9_LOJA
				Z52->Z52_LOTECT		:= QSC9->C9_LOTECTL
				Z52->Z52_DTVALI		:= StoD(QSC9->C9_DTVALID)
				Z52->Z52_DATALI		:= StoD(QSC9->C9_DATALIB)
				Z52->Z52_QTDLIB		:= QSC9->C9_QTDLIB
				Z52->Z52_BLEST 		:= QSC9->C9_BLEST
				Z52->Z52_BLCRED		:= QSC9->C9_BLCRED
				Z52->Z52_BLWMS      := QSC9->C9_BLWMS 
				Z52->Z52_STATUS 	:= pStatus
				Z52->Z52_AGREG      := QSC9->C9_AGREG 
				Z52->Z52_SEPARA     := QSC9->C9_SEPARA
				Z52->Z52_NUMOS      := Iif(empty(pNumOS), GeraNumOs(QSC9->C9_PEDIDO), pNumOS)
				Z52->Z52_USUI		:= _aUsu[1][2]
				Z52->Z52_DTINC		:= DDataBase

				Z52->( MsUnLock() )
			endif

			QSC9->( dbSkip() )
		enddo

		QSC9->( dbCloseArea() )

	endif

Return( nRet >= 0 )

//Libera pra Separar
User Function Vit600S(cOperacao)

	Local nI 		:= 0
	Local nY        := 0
	Local oMark 	:= GetMarkBrow()
	Local lOk   	:= .F.
	Local aPedidos 	:= {}
	Local _cStatus  := ""
	Local _ped1
	Local _cont

	Default cOperacao := "5"

	DbSelectArea('TRB')
	TRB->(DbGotop())

	//Begin Transaction

	While TRB->( !Eof() )

		_cont := 1
		//valido se o item esta marcado
		if IsMark( 'OK', cMark )
			If MsgYesNo( 'Deseja liberar o Pedido '+ TRB->PEDIDO + 'Para seraração?', 'Liberação de Pedido' )

				TRB->(RecLock("TRB", .f.))
				TRB->STATUS := cOperacao
				TRB->(MsUnLock())

				dbSelectArea("SC9")
				dbSetOrder(1)
				dbSeek(XFilial("SC9")+TRB->PEDIDO)
				WHILE SC9->(!EOF()) .AND. SC9->C9_PEDIDO = TRB->PEDIDO
					If SC9->C9_NFISCAL = TRB->NFISCAL
						RecLock("SC9", .f.)  
						SC9->C9_BLWMS := "02"
						SC9->( MsUnLock() )
					endif
					SC9->(DbSkip())
				End
				DbSelectArea("Z52")
				Z52->(DbSetOrder(1))
				Z52->(DbSeek("01"+ TRB->PEDIDO))
				While Z52->(!Eof()) .and. alltrim(TRB->PEDIDO) = alltrim(Z52->Z52_PEDIDO)
					If TRB->AGREG = Z52->Z52_AGREG
						RecLock("Z52", .f.)
						Z52->Z52_USUE 	:= _aUsu[1][2]
						Z52->Z52_DTALT 	:= DDataBase
						Z52->( MsUnLock() )
					EndIf
					Z52->(DbSkip())
				End
			Else 
			EndIf 	
		Endif
		dbSelectArea("TRB")
		TRB->( DbSkip() )
	EndDo

	u_vit600b()
Return()

//Imprime OS
User Function Vit600O()
	Local oMark := GetMarkBrow()
	Local _ped2:= " "
	Private _pedqry:=" "
	Private _libtrb
	Private _nfiscal
	dbSelectArea('TRB')
	dbGotop()
	do while !Eof()
		if IsMark( 'OK', cMark )
			_pedqry:= TRB->PEDIDO
			dbSelectArea("SC9")
			SC9->(dbSetOrder(1))
			SC9->(dbSeek(XFilial("SC9")+TRB->PEDIDO))
			WHILE SC9->(!eof()) .AND. SC9->C9_PEDIDO = TRB->PEDIDO
				IF SC9->c9_agreg = trb->agreg .and. sc9->c9_nfiscal = trb->nfiscal
					RecLock("SC9", .f.)
					SC9->C9_SEPARA := "OK"
					SC9->( MsUnLock() )
					_libtrb:= trb->datalib
					_nfiscal:= trb->nfiscal
					_agregu := trb->agreg
					u_vit600x()
				EndIf
				SC9->(DbSkip())
			END
			SC9->(DbCloseArea())
		EndIf	
		dbSelectArea('TRB')
		dbSkip()
	enddo
	u_vit600b()
Return()

Static Function GeraNumOs(pPedido)
	Local nY 		:= 0
	Local cQry      := ""
	Local cNumOS 	:= ""

	if ( nY := AScan(aNumOS, {|x| x[1] == pPedido}) ) > 0
		cNumOS := aNumOS[nY,2]
	else
		cQry :=        " SELECT Max(Z52_NUMOS) NUMOS "
		cQry += CRLF + " FROM " + RetSqlName("Z52")
		cQry += CRLF + " WHERE Z52_FILIAL = '"+XFilial("Z52")+"'"
		cQry += CRLF + "   AND Z52_PEDIDO = '"+pPedido+"'"
		cQry += CRLF + "   AND Z52_STATUS <> '1'"
		cQry += CRLF + "   AND D_E_L_E_T_ = ' '"
		if Select("QNUMOS") > 0
			QNUMOS->(dbCloseArea())
		endif
		TCQuery cQry New Alias "QNUMOS"
		if Eof() .or. Empty(QNUMOS->NUMOS)
			cNumOS := "00"
		else
			cNumOS := QNUMOS->NUMOS
		endif
		cNumOS := Soma1(cNumOS)
		AAdd(aNumOS, {pPedido, cNumOS})
		QNUMOS->(dbCloseArea())
	endif
Return( cNumOS )

//Troca de Lote
User Function Vit600T()
	Local oMark 	:= GetMarkBrow()
	Local aSDC  	:= {}
	Local aPedidos 	:= {}
	Local lOk   	:= .T.

	BeginTran()

	dbSelectArea('TRB')
	dbGotop()
	do while TRB->(!Eof())

		if TRB->( IsMark( 'OK', cMark ) )

			/*/
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
			±±³Fun‡„o    ³A450Grava ³ Rev.  ³ Eduardo Riera         ³ Data ³02.02.2002 ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³          ³Rotina de atualizacao da liberacao de credito                ³±±
			±±³          ³                                                             ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Parametros³ExpN1: 1 - Liberacao                                         ³±±
			±±³          ³       2 - Rejeicao                                          ³±±
			±±³          ³ExpL2: Indica uma Liberacao de Credito                       ³±±
			±±³          ³ExpL3: Indica uma liberacao de Estoque                       ³±±
			±±³          ³ExpL4: Indica se exibira o help da liberacao                 ³±±
			±±³          ³ExpA5: Saldo dos lotes a liberar                             ³±±
			±±³          ³ExpA6: Forca analise da liberacao de estoque                 ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Retorno   ³Nenhum                                                       ³±±
			±±³          ³                                                             ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Descri‡„o ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
			±±³          ³venda com base na tabela SC9.                                ³±±
			±±³          ³                                                             ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Uso       ³ Materiais                                                   ³±±
			±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
			/*/
			// a450Grava(nOpc,lAtuCred,lAtuEst,lHelp,aSaldos,lAvEst)
			// a450Grava(1,.f.,lAtuEst,.f.,aSaldos,lAvEst)


			/*
			ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
			±±ºPrograma  ³A410LibBen ºAutor  ³Andre Anjos         º Data ³  05/12/08   º±±
			±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
			±±ºDescricao ³ Libera o saldo empenhado para o item de PV referente a      º±±
			±±º			 ³ remessa de beneficiamento quando ha lote e;ou localizacao.  º±±
			±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
			±±ºParametro ³ nEvento: Evento que esta sendo processado.				   º±±
			±±º			 ³ 	1- Analise de saldo disponivel.							   º±±
			±±º			 ³ 	2- Estorno de liberacao.								   º±±
			±±º			 ³ cAlias: Alias onde se encontra o empenho.				   º±±
			±±º			 ³ nRecno: Recno do registro de empenho.					   º±±
			±±º			 ³ nQtd1: Quantidade a ser restaurada 1UM.					   º±±
			±±º			 ³ nQtd2: Quantidade a ser restaurada 2UM.					   º±±
			±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
			±±ºRetorno	 ³ nRet: Quantidade do empenho baixado.						   º±±
			±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
			±±ºUso       ³ FATXFUN                                   				   º±±
			±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
			A410LibBen(nEvento,cAlias,nRecno,nQtd1,nQtd2)
			*/

			aSDC := {}

			dbSelectArea("SDC")
			dbSetOrder(1)
			//DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
			dbSeek(XFilial("SDC")+TRB->COD+TRB->LOCAL+'SC6'+TRB->PEDIDO+TRB->ITEM+TRB->SEQ+TRB->LOTE)
			do while SDC->(!Eof() .and. DC_FILIAL = XFilial("SDC") .and. DC_PRODUTO = TRB->COD .and. DC_LOCAL = TRB->LOCAL .and. DC_ORIGEM = 'SC6' .and. ;
			DC_PEDIDO = TRB->PEDIDO  .and. DC_ITEM = TRB->ITEM .and. DC_SEQ = TRB->SEQ .and. DC_LOTECTL = TRB->LOTE )

				dbSelectArea("Z51")
				dbSetOrder(2)
				//Z51_FILIAL+Z51_PRODUT+Z51_LOCAL+Z51_ORIGEM+Z51_PEDIDO+Z51_ITEM+Z51_SEQ+Z51_LOTECT+Z51_NUMLOT+Z51_LOCALI+Z51_NUMSER

				if Z51->( RecLock("Z51", !dbSeek(SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI) ) ) )
					Z51->Z51_FILIAL 	:= SDC->DC_FILIAL
					Z51->Z51_ORIGEM    	:= SDC->DC_ORIGEM
					Z51->Z51_PRODUT		:= SDC->DC_PRODUTO
					Z51->Z51_LOCAL 		:= SDC->DC_LOCAL
					Z51->Z51_LOCALI    	:= SDC->DC_LOCALIZ
					Z51->Z51_NUMSER    	:= SDC->DC_NUMSERI
					Z51->Z51_LOTECT    	:= SDC->DC_LOTECTL
					Z51->Z51_NUMLOT    	:= SDC->DC_NUMLOTE
					Z51->Z51_QUANT     	:= SDC->DC_QUANT
					Z51->Z51_OP    		:= SDC->DC_OP
					Z51->Z51_TRT       	:= SDC->DC_TRT
					Z51->Z51_PEDIDO   	:= SDC->DC_PEDIDO
					Z51->Z51_ITEM      	:= SDC->DC_ITEM
					Z51->Z51_QTDORI    	:= SDC->DC_QTDORIG
					Z51->Z51_SEQ       	:= SDC->DC_SEQ
					Z51->Z51_QTSEGU    	:= SDC->DC_QTSEGUM
					Z51->Z51_ESTFIS    	:= SDC->DC_ESTFIS
					Z51->Z51_USERLI    	:= SDC->DC_USERLGI
					Z51->Z51_USERLA    	:= SDC->DC_USERLGA
					Z51->Z51_IDDCF    	:= SDC->DC_IDDCF

					Z51->( MsUnLock() )
				endif

				if ( i := AScan(aPedidos, {|x| x[1] == TRB->PEDIDO}) ) == 0
					AAdd(aPedidos, {TRB->PEDIDO, {TRB->ITEM}})
				else
					AAdd(aPedidos[i][2], TRB->ITEM)
				endif

				SDC->(dbSkip())
			enddo

			if ! lOk
				exit
			endif

		endif

		TRB->(dbSkip())
	enddo

	for i := 1 to len(aPedidos)

		Sleep( 20000 ) // Para o processamento por 20 segundos
		if ! ( lOk := u_Vit612(aPedidos[i][1], aPedidos[i][2]) )
			lOk  := .f.
			exit
		endif

	next i

	if lOk
		EndTran()
		msgAlert("Liberação executada com sucesso...")
	else
		msgAlert("Ocorreram problemas ao executar a Liberação...")
		DisarmTransaction()
	endif

	MarkBRefresh( )

	// força o posicionamento do browse no primeiro registro
	oMark:oBrowse:Gotop()

Return()

//Libera o faturamento
User Function Vit600Z()
	Local oMark := GetMarkBrow()
	Local lOk   := .f.
	Local _ped2

	BeginTran()

	dbSelectArea('TRB')
	dbGotop()
	do while TRB->(!Eof())

		if IsMark( 'OK', cMark )
			If MsgYesNo( 'Deseja liberar o Pedido '+ TRB->PEDIDO + 'Para Faturamento?', 'Liberação Faturamento' )
				_ped2:= ' '	
				If TRB->BLWMS = "02"

					dbSelectArea("Z52")
					dbSetOrder(1)
					Z52->(dbGoBottom())
					While Z52->(!Bof()) 
						If TRB->PEDIDO = Z52->Z52_PEDIDO 
							_ped2:= Z52->Z52_PEDIDO
							if !( lOk := RecLock("Z52", .f.) )
								exit
							endif

							dbSelectArea("SC9")
							dbSetOrder(1)
							if ( lOk := dbSeek(XFilial("SC9")+Z52->Z52_PEDIDO+Z52->Z52_ITEM+Z52->Z52_SEQ+Z52->Z52_COD) .and. RecLock("SC9", .f.) )
								SC9->C9_XSTATUS := "1"
								SC9->C9_BLWMS := "05"
								SC9->( MsUnLock() )
							else
								lOk := .f.
								exit
							endif

							Z52->Z52_STATUS	:= "6"
							Z52->Z52_USUE 	:= _aUsu[1][2]
							Z52->Z52_DTEXC 	:= DDataBase
							Z52->Z52_BLWMS := "05"
							Z52->( MsUnLock() )

							if ( lOk := TRB->(RecLock("TRB", .f.)) )
								TRB->( dbDelete() )
								TRB->( MsUnLock() )
							else
								lOk := .f.
								exit
							endif
						endif
						Z52->(DbSkip(-1))
						if !empty(_ped2) .and. _ped2 <> Z52->Z52_PEDIDO
							EXIT
						EndIf
					Enddo
				Else
					Alert("Somente pedido(s) 'Aptos a Separar' podem ser liberados!")
				EndIf
			EndIf
		Else //yesno
		EndIf //yesno
		dbSelectArea("TRB")
		TRB->(dbSkip())
	enddo

	if !lOK
		DisarmTransaction()
	Else
		EndTran()
		msgAlert("Pedido(s) reservados para faturamento com sucesso.")
	endif

	u_vit600b()
Return()

User Function Vit600P()
	Local oDlgPesq, oOrdem, oChave, oBtOk, oBtCan, oBtPar
	Local cOrdem
	Local aOrdens 	:= {}
	Local nOrdem 	:= 1
	Local nOpcao 	:= 0
	Local lExiste 	:= .f.

	AAdd( aOrdens, "Pedido + Item + Seq + Num. OS" )
	AAdd( aOrdens, "Cliente + Loja + Pedido + Item + Seq + Num. OS" )
	AAdd( aOrdens, "Descrição Produto" )
	AAdd( aOrdens, "Data de Liberação" )

	DEFINE MSDIALOG oDlgPesq TITLE "Pesquisa" FROM 00,00 TO 100,500 PIXEL
	@ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
	@ 020, 005 MSGET oChave VAR cChave SIZE 210,08 OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
	DEFINE SBUTTON oBtPar FROM 35,218 TYPE 5 WHEN .F. OF oDlgPesq PIXEL
	ACTIVATE MSDIALOG oDlgPesq CENTER

	if nOpcao == 1
		cChave := AllTrim(cChave)
		dbSelectArea("TRB")
		dbSetOrder(nOrdem)
		lExiste := dbSeek(cChave)
		if nOrdem == 1
			cFiltroTRB := "Z52_PEDIDO = '" + Left(cChave, TamSX3("Z52_PEDIDO")[1]) + "'"
		endif
		MarkBRefresh()
	endif
Return
/****************************************************************************************************************************/
Static Function criatmp1()
	Local _cQry
	_cQry := CRLF + " SELECT " 
	_cQry += CRLF + " SUM(SC9.C9_PRCVEN * SC9.C9_QTDLIB) PRECO, SUM((SC9.C9_PRCVEN * SC9.C9_QTDLIB) * (SC5.C5_PDESCAB/100)) DESCO "
	_cQry += CRLF + " ,SC5.C5_CONDPAG CONDPAG, SC9.C9_AGREG AGREG, SC9.C9_NFISCAL NFISCAL, SC9.C9_SERIENF SERIENF,"
	_cQry += CRLF + " SA1.A1_EST ESTADO, SA1.A1_SUFRAMA SUFRAMA, SA1.A1_TIPO TIPO, SC5.C5_MENPED MENPED, "
	_cQry += CRLF + " CASE "
	_cQry += CRLF + " WHEN SZ7.Z7_PEDIDO <>' ' THEN 'OK' "
	_cQry += CRLF + " END DATALIB " 
	_cQry += CRLF + " FROM SC9010 SC9 "
	_cQry += CRLF + " INNER JOIN SC5010 SC5 ON SC5.C5_NUM = C9_PEDIDO "
	_cQry += CRLF + " INNER JOIN SA1010 SA1 ON SA1.A1_COD = SC9.C9_CLIENTE AND SA1.A1_LOJA = SC9.C9_LOJA"
	_cQry += CRLF + " LEFT JOIN SZ7010 SZ7 ON SZ7.Z7_PEDIDO = SC9.C9_PEDIDO AND SC9.C9_AGREG = SZ7.Z7_AGREG AND SZ7.D_E_L_E_T_ = ' '"
	_cQry += CRLF + " WHERE SC9.D_E_L_E_T_ = ' '"
	_cQry += CRLF + " AND C9_PEDIDO = '"+ QZ52->Z52_PEDIDO+"'"
	_cQry += CRLF + " AND C9_DATALIB = '"+ QZ52->Z52_datali+"'"
	_cQry += CRLF + " AND C9_AGREG = '"+QZ52->Z52_agreg+"'"
	_cQry += CRLF + " AND SC9.D_E_L_E_T_ = ' '"
	_cQry += CRLF + " AND SC5.D_E_L_E_T_ = ' '"
	_cQry += CRLF + " AND SA1.D_E_L_E_T_ = ' '"
	_cQry += CRLF + " GROUP BY SC5.C5_NUM,SC5.C5_CONDPAG,SC9.C9_AGREG,SC9.C9_NFISCAL,SC9.C9_SERIENF,SA1.A1_EST,SA1.A1_SUFRAMA,SA1.A1_TIPO,SZ7.Z7_PEDIDO,SC5.C5_MENPED"

	if Select("TMP1") > 0
		TMP1->(dbCloseArea())
	endif

	TCQuery _cQry New Alias "TMP1"
	memowrite("C:/Stephen/tmp1vit600.txt",_cqry)
Return
/****************************************************************************************************************************/	
Static Function criatmp2()
	Local _cQry
	_cQry := CRLF + " SELECT " 
	_cQry += CRLF + " SUM(SC9.C9_PRCVEN * SC9.C9_QTDLIB) PRECO, SUM((SC9.C9_PRCVEN * SC9.C9_QTDLIB) * (SC5.C5_PDESCAB/100)) DESCO "
	_cQry += CRLF + " ,SC5.C5_CONDPAG CONDPAG, SC9.C9_AGREG AGREG, SC9.C9_NFISCAL NFISCAL, SC9.C9_SERIENF SERIENF"
	_cQry += CRLF + " ,SA2.A2_EST ESTADO,''  SUFRAMA, SA2.A2_TIPO TIPO, SC5.C5_MENPED MENPED, "
	_cQry += CRLF + " CASE "
	_cQry += CRLF + " WHEN SZ7.Z7_PEDIDO <>' ' THEN 'OK' "
	_cQry += CRLF + " END DATALIB " 
	_cQry += CRLF + " FROM SC9010 SC9 "
	_cQry += CRLF + " INNER JOIN SC5010 SC5 ON SC5.C5_NUM = C9_PEDIDO "
	_cQry += CRLF + " INNER JOIN SA2010 SA2 ON SA2.A2_COD = SC9.C9_CLIENTE AND SA2.A2_LOJA = SC9.C9_LOJA"
	_cQry += CRLF + " LEFT JOIN SZ7010 SZ7 ON SZ7.Z7_PEDIDO = SC9.C9_PEDIDO AND SC9.C9_AGREG = SZ7.Z7_AGREG AND SZ7.D_E_L_E_T_ = ' '"
	_cQry += CRLF + " WHERE SC9.D_E_L_E_T_ = ' '"
	_cQry += CRLF + " AND C9_PEDIDO = '"+ QZ52->Z52_PEDIDO+"'"
	_cQry += CRLF + " AND C9_DATALIB = '"+ QZ52->Z52_datali+"'"
	_cQry += CRLF + " AND C9_AGREG = '"+QZ52->Z52_agreg+"'"
	_cQry += CRLF + " AND SC9.D_E_L_E_T_ = ' '"
	_cQry += CRLF + " AND SC5.D_E_L_E_T_ = ' '"
	_cQry += CRLF + " AND SA2.D_E_L_E_T_ = ' '"
	_cQry += CRLF + " GROUP BY SC5.C5_NUM,SC5.C5_CONDPAG,SC9.C9_AGREG,SC9.C9_NFISCAL,SC9.C9_SERIENF,SA2.A2_EST,SA2.A2_TIPO,SZ7.Z7_PEDIDO,SC5.C5_MENPED"

	if Select("TMP1") > 0
		TMP1->(dbCloseArea())
	endif

	TCQuery _cQry New Alias "TMP1"
	memowrite("C:/Stephen/tmp2vit600.txt",_cqry)
Return
/****************************************************************************************************************************/	
//Aponta peso/volume das notas
User Function Vit600V()

	Local txt1 := 'Deseja apontar peso e volume do pedido: '
	Local txt2 :='Aponta Peso/Volume'
	Local nI 		:= 0
	Local nY        := 0
	Local oMark 	:= GetMarkBrow()
	Local lOk   	:= .F.
	Local aPedidos 	:= {}
	Local _cStatus  := ""
	Private _agreg 
	Private _cdoc
	Private _cserie
	Private _pedido
	Private _mtp	
	Private _ccliente:= ""
	Private _cloja:=""
	Private _cnomecli:=""
	Private _cidade:= ""
	Private _uf:= ""
	Private _ctransp := "      "
	Private _npesob:= 0
	Private _npesol:= 0
	Private _nvolume := 0
	Private _dtemb:= date()
	Private _hremb:= time()
	Private _libtran:= "S"                
	Private _ctranop:= "      "  
	Private _dtentr:= ""
	Private _entcid:= ""
	Private _obs:= ""
	Private dialog
	Private odlg
	Private bmpbutton
	Private _logg:="1"
	Private _pedi1
	Private _pedi2
	Private _pedqry
	Private pesbru:=0
	Private cxpad:=0
	Private _peso:=0
	Private _ncx:=0
	Private _npesobr:=0
	Private _npesolq:=0
	Private _mtp
	Private	_libtrb
	Private	_nfiscal
	Private	_agregu

	DbSelectArea('TRB')
	TRB->(DbGotop())
	While TRB->( !Eof() )
		//valido se o item esta marcado
		if IsMark( 'OK', cMark )
			_pedi1 := TRB->PEDIDO
			_pedi2 := TRB->PEDIDO
			_pedqry:= TRB->PEDIDO
			_cdoc := TRB->NFISCAL
			_cserie := TRB->SERIENF
			_pedido := TRB->PEDIDO	
			_ccliente:= TRB->CLIENTE
			_cloja:= TRB->LOJA
			_cnomecli:= TRB->NOME
			_flg:= 1
			_cidade:= POSICIONE( "SA1",1,xFilial("SA1")+TRB->CLIENTE+TRB->LOJA,"A1_MUN")
			_uf:= POSICIONE( "SA1",1,xFilial("SA1")+TRB->CLIENTE+TRB->LOJA,"A1_EST")
			_mtp:= trb->AGREG
			_libtrb:= trb->datalib
			_nfiscal:= trb->nfiscal
			_agregu := trb->agreg
			If TRB->BLWMS <> '01'
				If TRB->BLEST = '10' 
					If MsgYesNo("Pedido " + TRB->PEDIDO + "faturado, Informar transportadora opicional? ",txt2) 
						DbSelectArea("SF2")
						SF2->(DbSetOrder(1))
						IF dbSeek(xFilial("SF2") + TRB->NFISCAL + TRB->SERIENF+ TRB->CLIENTE + TRB->LOJA)  
							_ctransp :=sf2->f2_transp
							_npesob  :=sf2->f2_pbruto
							_npesol  :=sf2->f2_pliqui
							_nvolume :=sf2->f2_volume1
							_cdoc    :=sf2->f2_doc
							_cserie  :=sf2->f2_serie
							_ccliente:=sf2->f2_cliente
							_cloja   :=sf2->f2_loja
							_pedido  := TRB->PEDIDO 
							_dtentr  :=sf2->f2_dtentrg //Data de entrega 
							_entcid  :=sf2->f2_dtentcd //Data de entrega Cidade
							_ctranop :=sf2->f2_tranopc //Transp opcional
							_obs     :=sf2->f2_obstran //Obs Apontamento da Transportadora
							if empty(sf2->f2_dataemb)
								_dtemb	 := ddatabase
								_hremb	 :="18:30"
								_libtran :="S"
							else 
								_dtemb	 :=sf2->f2_dataemb
								_hremb	 :=sf2->f2_horaemb
								_libtran :=sf2->f2_libtran
							endif
							SF2->(DbCloseArea())

						EndIf 

						@ 000,000 to 450,450 dialog odlg title "Informe dados da nota fiscal"
						@ 005,005 say "Nota Fiscal"
						@ 005,045 say _cdoc
						@ 015,005 say "Serie"
						@ 015,045 say _cserie
						@ 025,005 say "Pedido"
						@ 025,045 say _pedido
						@ 035,005 say "Categoria: "
						If trb->agreg = "I"
							@ 035,045 say "Positiva"
						ElseIf trb->agreg = "N"
							@ 035,045 say "Negativa"
						EndIf
						@ 045,005 say "Cliente"
						@ 045,045 say _ccliente+"/"+_cloja+"-"+_cnomecli
						@ 055,005 say "Cidade/UF"
						@ 055,045 say alltrim(_cidade)+" / "+_uf
						@ 070,005 say "Transportadora"
						@ 070,045 get _ctransp picture "@!" size 35,9 When .F.
						@ 080,005 say "Peso bruto"
						@ 080,045 get _npesob  picture "@E 99,999.99" size 35,9 When .F.
						@ 090,005 say "Peso liquido"
						@ 090,045 get _npesol  picture "@E 999,999.99" size 35,9 When .F. 
						@ 100,005 say "Volumes"
						@ 100,045 get _nvolume picture "@E 999,999" size 20,9 When .F. 
						@ 110,005 say "Dt.Embarque"
						@ 110,045 get _dtemb picture "@E 99/99/999" size 45,9 When .F. 
						@ 120,005 say "Hr.Embarque"
						@ 120,045 get _hremb picture "99:99" size 20,9  When .F. 
						@ 130,005 say "Apontamento Liberado ?"
						@ 130,065 get _libtran picture "@!" size 15,9 When .F.                    
						@ 140,005 say "TranspOpcional"
						@ 140,045 get _ctranop picture "@!" size 35,9 valid _vtransp() f3 "SA4"  
						@ 150,005 say "Dt.Entregou"
						@ 150,045 get _dtentr size 45,9 
						@ 160,005 say "Cheg Cidade"
						@ 160,045 get _entcid size 45,9 
						@ 170,005 say "Obs. "
						@ 170,045 get _obs picture "@!" size 60,9
						@ 185,020 bmpbutton type 1 action _grava2()
						@ 185,055 bmpbutton type 2 action close(odlg)
						@ 185,090 get "Detalhes" size 0,0 f3 "Z52"
						activate dialog odlg centered
					EndIf
				EndIf
				If TRB->BLEST <> '10'
					dbSelectArea("SC9")
					SC9->(dbSetOrder(1))
					SC9->(dbSeek(XFilial("SC9")+TRB->PEDIDO))
					_npesob:=0
					_npesol:=0
					_flg := 1
					WHILE !SC9->(EOF()) .and. SC9->C9_PEDIDO = TRB->PEDIDO
						IF SC9->C9_AGREG = TRB->AGREG .and. DtoC(SC9->C9_DATALIB) = alltrim(TRB->DATALIB)
							DbSelectArea("SZ7")
							SZ7->(DbSetOrder(1))
							If SZ7->(DbSeek(Space(2)+_pedido+trb->agreg)) .and. TRB->NFISCAL = ' '
								If _flg=1
									Alert("Pedido já Apontado!")
								EndIf
								_flg:= 2
								_npesob:= SZ7->Z7_PBRUTO
								_npesol:= SZ7->Z7_PLIQUI
								_ctransp:= SZ7->Z7_TRANSP
								_nvolume:= SZ7->Z7_VOLUME1
								_dtemb:= SZ7->Z7_DATAEMB
								_hremb:= SZ7->Z7_HORAEMB
								_libtran:= SZ7->Z7_LIBTRAN
							Else
								pesbru:=POSICIONE("SB1", 1, xFilial("SB1") + SC9->C9_PRODUTO, "b1_pesbru")
								cxpad:= POSICIONE("SB1", 1, xFilial("SB1") + SC9->C9_PRODUTO, "b1_cxpad")
								_peso:=POSICIONE("SB1", 1, xFilial("SB1") + SC9->C9_PRODUTO, "b1_peso")
								if !empty(cxpad) .or. (cxpad > 0)
									_ncx:=int(SC9->c9_qtdlib/cxpad)
								else
									_ncx:=SC9->c9_qtdlib
								endif
								_npesob += _ncx*(pesbru*cxpad)      
								_npesol += _ncx*(_peso*cxpad)
								//								_nvolume += _ncx
							EndIf
							SZ7->(DbCloseArea())
						EndIf
						SC9->(DbSkip())
					End
					//					alert("trb->cod: " + trb->cod + " pesbru " + cvaltochar(pesbru) + " cxpad " + cvaltochar(cxpad) +" _peso " + cvaltochar(_peso) + " _ncx "+ cvaltochar(_ncx) +" _npesobr " + cvaltochar(_npesobr) + " _npesolq " + cvaltochar(_npesolq))
					If MsgYesNo( txt1 + TRB->PEDIDO + " ?", txt2 )
						@ 000,000 to 350,450 dialog odlg title "Informe dados da nota fiscal"
						@ 005,005 say "Pedido"
						@ 005,045 say _pedido
						@ 015,005 say "Categoria: "
						If trb->agreg = "I"
							@ 015,045 say "Positiva"
						ElseIf trb->agreg = "N"
							@ 015,045 say "Negativa"
						EndIf
						@ 025,005 say "Cliente"
						@ 025,045 say _ccliente+"/"+_cloja+"-"+_cnomecli
						@ 035,005 say "Cidade/UF"
						@ 035,045 say alltrim(_cidade)+" / "+_uf
						@ 050,005 say "Transportadora"
						@ 050,045 get _ctransp picture "@!" size 35,9 valid _vtransp() f3 "SA4"
						@ 060,005 say "Peso bruto"
						@ 060,045 get _npesob  picture "@E 99,999.99" size 35,9 valid _vtranop() 
						@ 070,005 say "Peso liquido"
						@ 070,045 get _npesol  picture "@E 999,999.99" size 35,9 valid _vtranop() 
						@ 080,005 say "Volumes"
						@ 080,045 get _nvolume picture "@E 999,999" size 20,9 valid _vtranop() 
						@ 090,005 say "Dt.Embarque"
						@ 090,045 get _dtemb picture "@E 99/99/999" size 45,9 valid _vtranop() 
						@ 100,005 say "Hr.Embarque"
						@ 100,045 get _hremb picture "99:99" size 20,9  valid _vtranop() 
						@ 110,005 say "Apontamento Liberado ?"
						@ 110,065 get _libtran picture "@!" size 15,9 valid _vtranop()                    
						@ 135,020 bmpbutton type 1 action _grava()
						@ 135,055 bmpbutton type 2 action close(odlg)
						@ 135,090 BUTTON "OS" SIZE 020, 011 PIXEL OF oDlg ACTION u_Vit600X()
						activate dialog odlg centered
					EndIf
				EndIf
			Else
				MSGINFO( "O pedido "+ TRB->PEDIDO +" Não Foi Liberado!", "NÃO LIBERADO" )
			EndIf
		EndIf
		dbSelectArea("TRB")
		TRB->( DbSkip() )
	EndDo
	u_vit600b()
Return()

static function _vtransp()
	_lok:=.t.
	//sf2->(dbsetorder(3))
	/*(DbSelectArea("SZB"))
	SZB->(DbSetOrder(3))
	if szb->(dbseek(space(2)+_ctransp+"S"+_uf))
	if existcpo("SA4",_ctransp) .and. VldCertificado()
	_lok:=.t.
	sa4->(dbseek(xFilial("SA4")+_ctransp)) 
	@ 070,085 say sa4->a4_nome
	//odlg:refresh()
	endif
	else
	if existcpo("SA4",_ctransp) .and. VldCertificado()
	_lok:=.t.
	sa4->(dbseek(xFilial("SA4")+_ctransp))
	@ 070,085 say sa4->a4_nome
	//odlg:refresh()
	endif
	endif*/
return(_lok)    
/****************************************************************************************************************************/	
Static Function VldCertificados()

	Local Certi1
	Local Datcer1
	Local Datcer2
	Local Datcer3
	Local Datcer4
	Local Datcer5

	Certi1 := POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XCERT1")
	Datcer1:= POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XDTCER1")
	Datcer2:= POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XDTCER2")
	Datcer3:= POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XDTCER3")
	Datcer4:= POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XDTCER4")
	Datcer5:= POSICIONE("SA4", 1, xFilial("SA4") + _ctransp, "A4_XDTCER5")
	If empty(Certi1)
		msgStop("Informe o 1o. certificado no cadastro da Transportadora!!!")
		Return(.f.)
	ElseIf Datcer1 < dDataBase
		msgStop("1o. Certificado da Transportadora está vencido!!!")
		Return(.f.)
	ElseIf !empty(Datcer2) .and. Datcer2 < dDataBase
		msgStop("2o. Certificado da Transportadora está vencido!!!")
		Return(.f.)
	ElseIf !empty(Datcer3) .and. Datcer3 < dDataBase
		msgStop("3o. Certificado da Transportadora está vencido!!!")
		Return(.f.)
	ElseIf !empty(Datcer4) .and. Datcer4 < dDataBase
		msgStop("4o. Certificado da Transportadora está vencido!!!")
		Return(.f.)
	ElseIf !empty(Datcer5) .and. Datcer5 < dDataBase
		msgStop("5o. Certificado da Transportadora está vencido!!!")
		Return(.f.)
	EndIf

Return(.t.)

//Valida  a transportadora opcional 
//Ricardo Moreira 31/10/2016

static function _vtranop()
	Local _lret:=.t.                

	//         000729 Julio Bustamante
	//         000020 Luciana Yoko
	//         000445  Ricardo 
	/*IF(sf2->f2_impres=="S") .and. !empty(sf2->f2_dtentrg) .and. !(cCodUser) $ ("000729/000020/000445") 
	_lret:=.f.
	EndIf*/          //verificar
return(_lret)
/****************************************************************************************************************************/	

static function _grava()
	Local _ped3
	Local _ped4
	Local _mtp
	sa4->(dbseek(xFilial("SA4")+_ctransp))

	if sa4->a4_tpfrete<>'C' 

		DbSelectArea("SZ7")
		SZ7->(DbSetOrder(1))
		If SZ7->(DbSeek(Space(2)+_pedido+trb->agreg))
			If MsgYesNo( 'Pedido '+ TRB->PEDIDO + "Lista "+ trb->agreg + ' já foi apontado, deseja alterar?', 'Aponta peso/volume' )
				SZ7->(reclock("SZ7",.F.))
				SZ7->Z7_AGREG  := trb->agreg
				SZ7->Z7_transp :=_ctransp
				SZ7->Z7_pbruto :=_npesob
				SZ7->Z7_pliqui :=_npesol
				SZ7->Z7_volume1:=_nvolume
				SZ7->Z7_libtran:=_libtran
				SZ7->Z7_dataemb:=_dtemb
				SZ7->Z7_horaemb:=_hremb 
				SZ7->Z7_PEDIDO :=_pedido
				SZ7->Z7_DATALIB:= SC9->C9_DATALIB
				//				SZ7->Z7_NFISCAL:= SC9->C9_NFISCAL 
				msunlock()
			EndIf
		Else
			SZ7->(reclock("SZ7",.T.))
			SZ7->Z7_AGREG  := trb->agreg
			SZ7->Z7_transp :=_ctransp
			SZ7->Z7_pbruto :=_npesob
			SZ7->Z7_pliqui :=_npesol
			SZ7->Z7_volume1:=_nvolume
			SZ7->Z7_libtran:=_libtran
			SZ7->Z7_dataemb:=_dtemb
			SZ7->Z7_horaemb:=_hremb 
			SZ7->Z7_PEDIDO :=_pedido
			SZ7->Z7_DATALIB:= SC9->C9_DATALIB
			//			SZ7->Z7_NFISCAL:= SC9->C9_NFISCAL
			msunlock() 
		EndIf		
		close(odlg)
	else 
		msgstop("Informado Codigo de Transportadora de Frete sobre Compras!")
	endif
return

static function _grava2()

	sa4->(dbseek(xFilial("SA4")+_ctransp))

	if sa4->a4_tpfrete<>'C' 

		DbSelectArea("SF2")
		SF2->(DbSetOrder(1))
		If (DbSeek(xFilial("SF2") +_CDOC+_CSERIE+_CCLIENTE+_CLOJA))
			SF2->(reclock("SF2",.f.))
			sf2->f2_dtentrg	:=  _dtentr   //Data de entrega 
			sf2->f2_dtentcd := 	_entcid  //Data de entrega Cidade
			sf2->f2_tranopc :=	_ctranop //Transp opcional 
			sf2->f2_obstran :=	_obs     //Obs Apontamento da Transportadora*/
			msunlock() 
		EndIf
		SF2->(DbCloseArea())
		close(odlg)
	else 
		msgstop("Informado Codigo de Transportadora de Frete sobre Compras!")
	endif
return

//Grava Separação
User Function Vit600C()
	Local oMark := GetMarkBrow()
	Local _ped2 

	dbSelectArea('TRB')
	dbGotop()
	do while TRB->(!Eof())
		_ped2 = ' '
		if IsMark( 'OK', cMark )
			If MsgYesNo( 'Deseja Separar o pedido '+ TRB->PEDIDO + '?', 'Separa Pedido' )
				dbSelectArea("Z52")
				Z52->(dbSetOrder(1))
				Z52->(dbGoBottom())
				While Z52->(!Bof()) 
					IF alltrim(TRB->PEDIDO) = alltrim(Z52->Z52_PEDIDO)
						_ped2:= Z52->Z52_PEDIDO
						IF Empty(Z52->Z52_SEPARA)
							RecLock("Z52", .f.)
							Z52->Z52_SEPARA 	:= "OK"
							Z52->( MsUnLock() )
						Else
							MsgInfo("Impossivel Separar,Este Pedido já foi Separado!","Pedido já separado")
						EndIf
					ENDIF
					Z52->(dbSkip(-1))
					if !empty(_ped2) .and. _ped2 <> Z52->Z52_PEDIDO
						EXIT
					EndIf
				EndDo
			Else //yesno
			EndIf //yesno
		endif
		dbSelectArea("TRB")
		dbSkip()
	enddo
	u_vit600b()
Return()
/****************************************************************************************************************************/
//Cancela Separação
User Function Vit600G()
	Local oMark := GetMarkBrow()
	Local _ped2 

	dbSelectArea('TRB')
	dbGotop()
	do while TRB->(!Eof())
		_ped2 = ' '
		if IsMark( 'OK', cMark )
			If MsgInfo( 'Deseja Cancelar Separação do pedido '+ TRB->PEDIDO + '?', 'Cancela Separação' )
				dbSelectArea("Z52")
				Z52->(dbSetOrder(1))
				Z52->(dbGoBottom())
				While Z52->(!Bof()) 
					IF alltrim(TRB->PEDIDO) = alltrim(Z52->Z52_PEDIDO) .and. trb->agreg = S52->z52_agreg
						_ped2:= Z52->Z52_PEDIDO
						IF !Empty(Z52->Z52_SEPARA)
							RecLock("Z52", .f.)
							Z52->Z52_SEPARA 	:= " "
							Z52->( MsUnLock() )
						Else
							MsgInfo("Este Pedido não foi Separado! Não é necessário cancelamento","Pedido não separado")
						EndIf
					ENDIF
					Z52->(dbSkip(-1))
					if !empty(_ped2) .and. _ped2 <> Z52->Z52_PEDIDO
						EXIT
					EndIf
				EndDo
			Else //yesno
			EndIf //yesno
		endif
		dbSelectArea("TRB")
		dbSkip()
	enddo
	u_vit600b()
	Return()

	/*

	±±³Descricao ³ Ordem de Separacao                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Especifico para Vitapan                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±³Versao    ³ 1.0                                                        ³±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	*/

	#include "topconn.ch"
	#include "rwmake.ch"

user function vit600x()

	Local _codtran
	tamanho  :="P"
	titulo   :="ORDEM DE SEPARACAO"
	cdesc1   :="Este programa ira emitir a ordem de separacao"
	cdesc2   :="em formato html"
	cdesc3   :=""
	cstring  :="SC9"
	areturn  :={"Zebrado",1,"Administracao",2,2,1,"",1}
	nomeprog :="VIT600x"
	wnrel    :="VIT600x"+Alltrim(cusername)
	alinha   :={}
	nlastkey :=0
	lcontinua:=.t.

	wnrel:=setprint(cstring,wnrel,,@titulo,cdesc1,cdesc2,cdesc3,.f.,"",.f.,tamanho,"",.f.)

	if nlastkey==27
		set filter to
		return
	endif

	setdefault(areturn,cstring)

	ntipo :=if(areturn[4]==1,15,18)

	if nlastkey==27
		set filter to
		return
	endif


	rptstatus({|| rptdetail()})
return

static function rptdetail()

	_cfilsa1:=xfilial("SA1")
	_cfilsa3:=xfilial("SA3")
	_cfilsa4:=xfilial("SA4")
	_cfilsb1:=xfilial("SB1")
	_cfilsc5:=xfilial("SC5")
	_cfilsc9:=xfilial("SC9")
	_cfilsdc:=xfilial("SDC")
	_cfilsb1:=xfilial("SB1")
	sa1->(dbsetorder(1))
	sa3->(dbsetorder(1))
	sa4->(dbsetorder(1))
	sb1->(dbsetorder(1))
	sc5->(dbsetorder(1))
	sc9->(dbsetorder(1))  
	sdc->(dbsetorder(1))
	sb1->(dbsetorder(1))

	_carqtmp1:=""
	_cindtmp11:=""
	_cindtmp12:=""
	IF EMPTY(_NFISCAL) 
		processa({|| _gera1()})
	else
		processa({|| _gera2()})
	endIf
	tmp1->(dbsetorder(2))

	setregua(tmp1->(lastrec()))

	_cMsg := ''
	_cMsg += '<html>'
	_cMsg += '<head>'
	_cMsg += '<title>Pr&eacute; Nota</title>'
	_cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
	_cMsg += '</head>'
	_cMsg += '<body>'         

	_item:=0


	tmp1->(dbgotop())
	while ! tmp1->(eof()) .and.;
	lcontinua
		incregua()
		_ccliente:=tmp1->cliente
		_cloja   :=tmp1->loja
		_ctabela :=tmp1->tabela
		_ccateg  :=tmp1->categ
		_apedido :={}
		_nregtmp1:=tmp1->(recno())

		while ! tmp1->(eof()) .and.;
		tmp1->cliente==_ccliente .and.;
		tmp1->loja==_cloja .and.;
		tmp1->tabela==_ctabela .and.;
		tmp1->categ==_ccateg
			_i:=ascan(_apedido,tmp1->pedido)
			if _i==0
				aadd(_apedido,tmp1->pedido)
			endif
			tmp1->(dbskip())
		end
		_apedidos:=asort(_apedido)
		tmp1->(dbgoto(_nregtmp1))            

		while ! tmp1->(eof()) .and.;
		tmp1->cliente==_ccliente .and.;
		tmp1->loja==_cloja .and.;
		tmp1->tabela==_ctabela .and.;
		tmp1->categ==_ccateg
			sc5->(dbseek(_cfilsc5+tmp1->pedido))
			sa4->(dbseek(_cfilsa4+sc5->c5_transp))
			sa3->(dbseek(_cfilsa3+sc5->c5_vend1))
			sa1->(dbseek(_cfilsa1+tmp1->cliente+tmp1->loja))

			if _item > 0

				_cMsg += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
				_cMsg += "<br clear=all style='page-break-before:always'>"
				_cMsg += '</span>'			
				_item := 0
			endif

			_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse: collapse">'
			_cMsg += '<tr><td width="175" valign="top">'
			_cMsg += '<table width="175" border="0" cellpadding="0" cellspacing="0">'
			_cMsg += '<tr><td><img align="top" width=129 height=41 src="file:\\10.1.1.24\remote\figuras\logo.jpg"></td></tr></table></td>'
			_cMsg += '<td width="400" valign="top"><p><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font><br />'
			_cMsg += '<font face=arial,verdana size=3><b><center>ORDEM DE SEPARA&Ccedil;&Atilde;O</center></b></font></p></td>'

			_ped:=""
			for _i:=1 to len(_apedidos)
				if _i==1
					_ped:=_apedidos[_i]
				else
					_ped+="/"+_apedidos[_i]
				endif
			next 

			_codtran:= posicione("SZ7",1, SPACE(2) + TMP1->PEDIDO + _ccateg,"Z7_TRANSP")               

			_cMsg += '<td width="187" valign="center"><font face=arial,verdana size=2><b><center>Pedido(s) nº '+_ped+' </center></b>'
			_cMsg += '<center>Emiss&atilde;o: '+dtoc(date())+' - '+left(time(),5)+'</center></font></td></tr></table><br />'

			_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" style="border-collapse:collapse" bordercolor="#000000">'
			_cMsg += '<tr height="30" valign="bottom">'
			//_cMsg += '	<td colspan="3"><p><font face="Arial, Verdana" size="2"><b>Transportadora: </b>'+sc5->c5_transp+' - '+sa4->a4_nome+'</font></p></td>' //Leandro 21/10/2016
			_cMsg += '	<td colspan="3"><p><font face="Arial, Verdana" size="2"><b>Transportadora:</b> '+ posicione("SA4",1, SPACE(2) +_codtran,"A4_NOME") +'</font></p></td>'
			_cMsg += '<tr>'
			_cMsg += '	<td colspan="3"><p><font face="Arial, Verdana" size="2"><b>Vendedor: </b>'+sc5->c5_vend1+' - '+sa3->a3_nome+'</font></p></td>'
			_cMsg += '<tr>'
			_cMsg += '	<td colspan="3"><p><font face="Arial, Verdana" size="2"><b>Cidade/UF: </b>'+alltrim(sa1->a1_mun)+' - '+sa1->a1_est+'</font></p></td>'
			_cMsg += '<tr height="30" valign="bottom">'
			_cMsg += '	<td colspan="2"><p><font face="Arial, Verdana" size="2"><b>Volumes: </b>'+ cValtoChar(posicione("SZ7",1, SPACE(2) + TMP1->PEDIDO + _ccateg,"Z7_VOLUME1")) +'</font></p></td>'
			_cMsg += '	<td width="258"><p><font face="Arial, Verdana" size="2"><b>Data Separa&ccedil;&atilde;o:'
			_cMsg += '    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/</b></font></p></td></tr>'
			_cMsg += '<tr height="30" valign="bottom">'
			_cMsg += '	<td width="256"><p><font face="Arial, Verdana" size="2"><b>Separador: </b></b></font></p></td>'
			_cMsg += '	<td width="256"><p><font face="Arial, Verdana" size="2"><b>Conferente: </b></font></p></td>'
			_cMsg += '	<td width="258"><p><font face="Arial, Verdana" size="2"><b>Respons&aacute;vel:</b></font></p></td></tr>'
			_cMsg += '<tr height="30" valign="middle">'
			_cMsg += '	<td width="256"><p><font face="Arial, Verdana" size="2"><b>Hor&aacute;rio:  </b>______:______&nbsp;&nbsp;&nbsp;______:______</font></p></td>'
			_cMsg += '	<td width="256"><p><font face="Arial, Verdana" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;______:______&nbsp;&nbsp;&nbsp;______:______</font></p></td>'
			_cMsg += '	<td width="258"><p><font face="Arial, Verdana" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;______:______&nbsp;&nbsp;&nbsp;______:______</font></p></td>'
			_cMsg += '</tr></table>'
			_cMsg += '<br />'

			_cMsg += '<table border=1 cellspacing=0 cellpadding=0 width=770 bordercolor="#000000" style="border-collapse:collapse">'
			_cMsg += '<tr height="25">'
			_cMsg += '	<td width="55"><p align="center"><font face="Arial, Verdana" size="1"><b>Endere&ccedil;o</b></font></p></td>'
			_cMsg += '	<td width="45"><p align="center"><font face="Arial, Verdana" size="1"><b>C&oacute;digo</b></font></p></td>'
			_cMsg += '    <td width="220"><p align="center"><font face="Arial, Verdana" size="1"><b>Produto</b></font></p></td>'
			_cMsg += '    <td width="45"><p align="center"><font face="Arial, Verdana" size="1"><b>Lote</b></font></p></td>'
			_cMsg += '    <td width="25"><p align="center"><font face="Arial, Verdana" size="1"><b>UM</b></font></p></td>'
			_cMsg += '    <td width="68"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Total</b></font></p></td>'
			_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Caixas</b></font></p></td>'
			_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>UN/Caixa</b></font></p></td>'
			_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Frac.</b></font></p></td>'
			_cMsg += '    <td width="30"><p align="center"><font face="Arial, Verdana" size="1"><b>Val.</b></font></p></td>'
			_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Sigla</b></font></p></td>'
			_cMsg += '    <td width="60"><p align="center"><font face="Arial, Verdana" size="1"><b>Separa&ccedil;&atilde;o</b></font></p></td>'

			_ntotqtd:=0
			_ntotcx :=0
			_ntotun :=0
			_npesobr :=0
			_npesolq :=0     

			while ! tmp1->(eof()) .and.;
			tmp1->cliente==_ccliente .and.;
			tmp1->loja==_cloja .and.;
			tmp1->tabela==_ctabela .and.;
			tmp1->categ==_ccateg
				_nqtd:=0
				_ncx :=0
				_nun :=0
				sb1->(dbseek(_cfilsb1+tmp1->produto))
				_cproduto:=tmp1->produto
				_clotectl:=tmp1->lotectl
				_clocaliz:=tmp1->localiz
				_dtvalid :=substr(dtoc(tmp1->dtvalid),4,2)+"/"+substr(dtoc(tmp1->dtvalid),7,4)

				while ! tmp1->(eof()) .and.;
				tmp1->cliente==_ccliente .and.;
				tmp1->loja==_cloja .and.;
				tmp1->tabela==_ctabela .and.;
				tmp1->categ==_ccateg .and.;
				tmp1->produto==_cproduto .and.;
				tmp1->lotectl==_clotectl .and.;
				tmp1->localiz==_clocaliz
					_nqtd+=tmp1->qtdlib
					tmp1->(dbskip())
				end

				if _item>35
					//Quebra página          
					_cMsg += '</table>'
					_cMsg += '<br />'

					_cMsg += "<span style='"+'font-size:11.0pt;line-height:115%;font-family:"Calibri","sans-serif"'+"'>"
					_cMsg += "<br clear=all style='page-break-before:always'>"
					_cMsg += '</span>'			
					_item := 0

					_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse: collapse">'
					_cMsg += '<tr><td width="175" valign="top">'
					_cMsg += '<table width="175" border="0" cellpadding="0" cellspacing="0">'
					_cMsg += '<tr><td><img align="top" width=129 height=41 src="file:\\srv-gti-24\remote\figuras\logo.jpg"></td></tr></table></td>'
					_cMsg += '<td width="400" valign="top"><p><font face="Arial, Helvetica, sans-serif" size="1">&nbsp;</font><br />'
					_cMsg += '<font face=arial,verdana size=3><b><center>ORDEM DE SEPARA&Ccedil;&Atilde;O</center></b></font></p></td>'

					_ped:=""
					for _i:=1 to len(_apedidos)
						if _i==1
							_ped:=_apedidos[_i]
						else
							_ped+="/"+_apedidos[_i]
						endif
					next                

					_cMsg += '<td width="187" valign="center"><font face=arial,verdana size=2><b><center>Pedido(s) nº '+_ped+' </center></b>
					_cMsg += '<center>Emiss&atilde;o: '+dtoc(date())+' - '+left(time(),5)+'</center></font></td></tr></table><br />                

					_cMsg += '<table border=1 cellspacing=0 cellpadding=0 width=770 bordercolor="#000000" style="border-collapse:collapse">'
					_cMsg += '<tr height="25">'
					_cMsg += '	<td width="60"><p align="center"><font face="Arial, Verdana" size="1"><b>Endere&ccedil;o</b></font></p></td>'
					_cMsg += '	<td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>C&oacute;digo</b></font></p></td>'
					_cMsg += '    <td width="220"><p align="center"><font face="Arial, Verdana" size="1"><b>Produto</b></font></p></td>'
					_cMsg += '    <td width="45"><p align="center"><font face="Arial, Verdana" size="1"><b>Lote</b></font></p></td>'
					_cMsg += '    <td width="25"><p align="center"><font face="Arial, Verdana" size="1"><b>UM</b></font></p></td>'
					_cMsg += '    <td width="68"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Total</b></font></p></td>'
					_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Caixas</b></font></p></td>'
					_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>UN/Caixa</b></font></p></td>'
					_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Qtd.Frac.</b></font></p></td>'
					_cMsg += '    <td width="30"><p align="center"><font face="Arial, Verdana" size="1"><b>Val.</b></font></p></td>'
					_cMsg += '    <td width="50"><p align="center"><font face="Arial, Verdana" size="1"><b>Sigla</b></font></p></td>'
					_cMsg += '    <td width="60"><p align="center"><font face="Arial, Verdana" size="1"><b>Separa&ccedil;&atilde;o</b></font></p></td>'

				endif

				if !empty(sb1->b1_cxpad) .or. (sb1->b1_cxpad > 0)
					_ncx+=int(_nqtd/sb1->b1_cxpad)
					_nun+=_nqtd%sb1->b1_cxpad
				else
					_ncx+=_nqtd
					_nun+=0
				endif

				_cMsg += '<tr height="20">'
				_cMsg += '	<td><p align="center"><font face="Arial, Verdana" size="1">'+left(_clocaliz,10)+'</font></p></td>'
				_cMsg += '	<td><p align="center"><font face="Arial, Verdana" size="1">'+left(_cproduto,6)+'</font></p></td>'
				_cMsg += '    <td><p align="left"><font face="Arial, Verdana" size="1">'+sb1->b1_desc+'</font></p></td>'
				_cMsg += '    <td><p align="center"><font face="Arial, Verdana" size="1">'+_clotectl+'</font></p></td>'
				_cMsg += '    <td><p align="center"><font face="Arial, Verdana" size="1">'+sb1->b1_um+'</font></p></td>'
				_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform((_nqtd),"@E 99,999,999.9999")+'&nbsp;</font></p></td>'
				_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform((_ncx),"@E 999,999")+'&nbsp;</font></p></td>'
				_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform((sb1->b1_cxpad),"@E 999")+'&nbsp;</font></p></td>'
				_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform((_nun),"@E 999,999")+'&nbsp;</font></p></td>'
				_cMsg += '    <td><p align="center"><font face="Arial, Verdana" size="1">'+_dtvalid+'</font></p></td>
				_cMsg += '    <td><p align="center"><font face="Arial, Verdana" size="1">'+sb1->b1_codres+'</font></p></td> 
				_cMsg += '    <td><p align="center"><font face="Arial, Verdana" size="1">&nbsp;</font></p></td>
				_cMsg += '</tr>

				_item++

				_npesobr += _ncx*(sb1->b1_pesbru*sb1->b1_cxpad)      
				_npesolq += _ncx*(sb1->b1_peso*sb1->b1_cxpad)      
				_ntotqtd+=_nqtd
				_ntotcx +=_ncx
				_ntotun +=_nun
				//				alert("produto "+_cproduto+" quantidade "+cvaltochar(_nqtd)+" conta "+ cvaltochar(_npesobr)+ ":="+ cvaltochar(_ncx)+"*"+cvaltochar(sb1->b1_pesbru)+ "*"+cvaltochar(sb1->b1_cxpad))				
				if labortprint
					@ prow()+2,000 PSAY "***** CANCELADO PELO OPERADOR *****"
					eject
					lcontinua:=.f.
				endif
			end


			_cMsg += '<tr height="25">'
			_cMsg += '	<td colspan="5"><p align="left"><font face="Arial, Verdana" size="1"> TOTAL </font></p></td>'
			_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform(_ntotqtd,"@E 99,999,999.9999")+'&nbsp;</font></p></td>'
			_cMsg += '    <td><p align="right"><font face="Arial, Verdana" size="1">'+Transform(_ntotcx,"@E 9,999,999")+'&nbsp;</font></p></td>'
			_cMsg += '    <td colspan="2"><p align="right"><font face="Arial, Verdana" size="1">'+Transform(_ntotun,"@E 9,999,999")+'&nbsp;</font></p></td>'
			_cMsg += '    <td colspan="3"><p align="right"><font face="Arial, Verdana" size="1">&nbsp;</font></p></td>'
			_cMsg += '</tr></table>'
			_cMsg += '<br />'

			/* Mensagens do Pedido */
			_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse:collapse">'
			_cMsg += '<tr>'
			_cMsg += '	<td width=769 valign="top">'
			_cMsg += '      <p><font face="Arial, Verdana" size="1"><b>Mensagens do Pedido</b></font>'
			_cMsg += '        <br />'
			_cMsg += '        <font face="Arial, Verdana" size="1">'+sc5->c5_menped+'</font>'
			_cMsg += '        <br />'
			_cMsg += '        <font face="Arial, Verdana" size="1">&nbsp;</font></p></td></tr></table>'
			_cMsg += '<br />'

			/* Totais Peso Bruto, Peso Líquido e Categoria */
			_cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="770" bordercolor="#000000" style="border-collapse:collapse">'
			_cMsg += '<tr>'
			_cMsg += '	<td width="256" bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="2">PESO BRUTO</font></b></center></td>'
			_cMsg += '    <td width="256" bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="2">PESO L&Iacute;QUIDO</font></b></center></td>'
			_cMsg += '    <td width="256" bgcolor="#D9D9D9"><center><b><font face="Arial, Verdana" size="2">CATEGORIA</font></b></center></td></tr>'
			_cMsg += '<tr height="30">'

			//			Alert("agreg: " + _ccateg + "peso: " + cValtochar(_npesobr) + "pedido: " + _ped)
			If _npesobr = 0
				_cMsg += '    <td align="center"><font face="Arial, Verdana" size="2">'+Transform(posicione("SZ7",1, SPACE(2) + _ped + _ccateg,"Z7_PBRUTO"),"@E 999,999.9999")+'</font></td>'
				_cMsg += '    <td align="center"><font face="Arial, Verdana" size="2">'+Transform(posicione("SZ7",1, SPACE(2) + _ped + _ccateg,"Z7_PLIQUI"),"@E 999,999.9999")+'</font></td>'
				_cMsg += '    <td align="center"><font face="Arial, Verdana" size="2">'+if(alltrim(_ccateg)=="N","Negativa",if(empty(alltrim(_ccateg))," - ","Positiva"))+'</font></td></tr></table>'
			Else
				_cMsg += '    <td align="center"><font face="Arial, Verdana" size="2">'+Transform(_npesobr,"@E 999,999.9999")+'</font></td>'
				_cMsg += '    <td align="center"><font face="Arial, Verdana" size="2">'+Transform(_npesolq,"@E 999,999.9999")+'</font></td>'
				_cMsg += '    <td align="center"><font face="Arial, Verdana" size="2">'+if(alltrim(_ccateg)=="N","Negativa",if(empty(alltrim(_ccateg))," - ","Positiva"))+'</font></td></tr></table>'
			EndIf
		end
	end                       

	//³ ENCERRA O CÓDIGO HTML

	_cMsg += '</body>'
	_cMsg += '</html>'

	//³ cria o arquivo em disco vit273.html e executa-o em seguida
	_carquivo:="C:\WINDOWS\TEMP\SEPARACAO.HTML"
	nHdl := fCreate(_carquivo)
	fWrite(nHdl,_cMsg,Len(_cMsg))
	fClose(nHdl)
	ExecArq(_carquivo)

	set device to screen

	_cext=tmp1->(ordbagext())
	tmp1->(dbclosearea())
	ferase(_carqtmp1+getdbextension())

	ferase(_cindtmp11+_cext)
	ferase(_cindtmp12+_cext)

	ms_flush()

return


static function _gera1()
	procregua(1)

	incproc("Selecionando pedidos...")

	_aestrut:={}
	aadd(_aestrut,{"CLIENTE"  ,"C",06,0})
	aadd(_aestrut,{"LOJA"     ,"C",02,0})
	aadd(_aestrut,{"TABELA"   ,"C",03,0})
	aadd(_aestrut,{"CATEG"    ,"C",01,0})
	aadd(_aestrut,{"DESCRICAO","C",40,0})
	aadd(_aestrut,{"PRODUTO"  ,"C",15,0})
	aadd(_aestrut,{"LOTECTL"  ,"C",10,0})
	aadd(_aestrut,{"LOCALIZ"  ,"C",15,0})
	aadd(_aestrut,{"PEDIDO"   ,"C",06,0})
	aadd(_aestrut,{"QTDLIB"   ,"N",16,6})
	aadd(_aestrut,{"DTVALID"   ,"D",06,0})
	aadd(_aestrut,{"AGREG"     ,"C",04,0})

	_carqtmp1:=criatrab(_aestrut,.t.)
	dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)

	_cindtmp11:=criatrab(,.f.)
	_cchave :='CLIENTE+LOJA+TABELA+CATEG+DESCRICAO+PRODUTO+LOTECTL+PEDIDO'
	tmp1->(indregua("TMP1",_cindtmp11,_cchave,,,"Selecionando registros..."))

	_cindtmp12:=criatrab(,.f.)
	_cchave  :="CLIENTE+LOJA+TABELA+CATEG+LOCALIZ+DESCRICAO+LOTECTL"
	tmp1->(indregua("TMP1",_cindtmp12,_cchave))

	tmp1->(dbclearind())
	tmp1->(dbsetindex(_cindtmp11))
	tmp1->(dbsetindex(_cindtmp12))

	tmp1->(dbsetorder(1))

	sc9->(dbseek(_cfilsc9+_pedqry,.t.))
	while sc9->(!eof()) .and. SC9->c9_pedido = _pedqry
		if  sc9->c9_nfiscal $ _nfiscal
			_cpedido:=sc9->c9_pedido
			sc5->(dbseek(_cfilsc5+_cpedido))
			if sc5->c5_tipo=="N"
				_nregsc9:=sc9->(recno())
				_lok:=.t.
				while ! sc9->(eof()) .and.;
				sc9->c9_filial==_cfilsc9 .and.;
				sc9->c9_pedido==_cpedido
					sc9->(dbskip())
				end
				if _lok
					sc9->(dbgoto(_nregsc9))
					while ! sc9->(eof()) .and.;
					sc9->c9_filial==_cfilsc9 .and.;
					sc9->c9_pedido==_cpedido
						sb1->(dbseek(_cfilsb1+sc9->c9_produto))
						if sb1->b1_localiz=='S'
							_cquery:= "SELECT "
							_cquery+= " DC_PRODUTO PRODUTO,"
							_cquery+= " DC_LOTECTL LOTECTL,"
							_cquery+= " DC_LOCALIZ LOCALIZ,"
							_cquery+= " DC_PEDIDO PEDIDO,"
							_cquery+= " DC_QUANT QUANT,"
							_cquery+= " DC_ITEM ITEM"
							_cquery+= " FROM "
							_cquery+= retsqlname("SDC")+" SDC"
							_cquery+= " WHERE"
							_cquery+= " SDC.D_E_L_E_T_=' '"
							_cquery+= " AND SDC.DC_PRODUTO='"+sc9->c9_produto+"'"
							_cquery+= " AND SDC.DC_PEDIDO='"+sc9->c9_pedido+"'"
							_cquery+= " AND SDC.DC_ITEM='"+sc9->c9_item+"'"
							_cquery+= " AND SDC.DC_LOTECTL='"+sc9->c9_lotectl+"'"
							_cquery+= " AND SDC.DC_QUANT>0"
							_cquery+= " AND SDC.DC_SEQ='"+sc9->c9_sequen+"'"
							_cquery+= " ORDER BY DC_PEDIDO, DC_PRODUTO, DC_LOTECTL, DC_LOCALIZ"

							_cquery:=changequery(_cquery)
							memowrite("C:/Stephen/qryrelato.txt",_cquery)
							tcquery _cquery new alias "TMP3"
							tmp3->(dbgotop())
							while ! tmp3->(eof())
								sb1->(dbseek(_cfilsb1+sc9->c9_produto))
								tmp1->(dbappend())
								tmp1->cliente  :=sc9->c9_cliente
								tmp1->loja     :=sc9->c9_loja
								tmp1->tabela   :=sc5->c5_tabela
								tmp1->categ    :=sc9->c9_agreg//:=if(sc5->c5_percfat==100," ",left(sb1->b1_categ,1))
								tmp1->descricao:=sb1->b1_desc   
								tmp1->dtvalid  :=sc9->c9_dtvalid
								tmp1->produto  :=sc9->c9_produto
								tmp1->lotectl  :=sc9->c9_lotectl
								tmp1->pedido   :=sc9->c9_pedido 
								tmp1->qtdlib   :=tmp3->quant
								tmp1->localiz  :=tmp3->localiz
								//								tmp1->agreg    :=sc9->c9_agreg

								tmp3->(dbskip())

							end
							tmp3->(dbclosearea())		
						else
							sb1->(dbseek(_cfilsb1+sc9->c9_produto))
							tmp1->(dbappend())
							tmp1->cliente  :=sc9->c9_cliente
							tmp1->loja     :=sc9->c9_loja
							tmp1->tabela   :=sc5->c5_tabela
							tmp1->categ    :=sc9->c9_agreg//:=if(sc5->c5_percfat==100," ",left(sb1->b1_categ,1))
							tmp1->descricao:=sb1->b1_desc   
							tmp1->dtvalid  :=sc9->c9_dtvalid
							tmp1->produto  :=sc9->c9_produto
							tmp1->lotectl  :=sc9->c9_lotectl
							tmp1->pedido   :=sc9->c9_pedido
							tmp1->qtdlib   :=sc9->c9_qtdlib
							tmp1->localiz  :=""      
						EndIf
						/*sc9->(reclock("SC9",.f.))
						sc9->c9_impsep :="S"
						sc9->c9_datasep:=ddatabase
						sc9->c9_horasep:=left(time(),5)
						sc9->c9_ususep :=cusername
						sc9->(msunlock())*/		               
						sc9->(dbskip())
					end
				endif
			else
				sc9->(dbskip())
			endif
		else
			sc9->(dbskip())
		endif
	end
return

static function _gera2()
	procregua(1)

	incproc("Selecionando pedidos...")

	_aestrut:={}
	aadd(_aestrut,{"CLIENTE"  ,"C",06,0})
	aadd(_aestrut,{"LOJA"     ,"C",02,0})
	aadd(_aestrut,{"TABELA"   ,"C",03,0})
	aadd(_aestrut,{"CATEG"    ,"C",01,0})
	aadd(_aestrut,{"DESCRICAO","C",40,0})
	aadd(_aestrut,{"PRODUTO"  ,"C",15,0})
	aadd(_aestrut,{"LOTECTL"  ,"C",10,0})
	aadd(_aestrut,{"LOCALIZ"  ,"C",15,0})
	aadd(_aestrut,{"PEDIDO"   ,"C",06,0})
	aadd(_aestrut,{"QTDLIB"   ,"N",16,6})
	aadd(_aestrut,{"DTVALID"   ,"D",06,0})
	aadd(_aestrut,{"AGREG"     ,"C",04,0})

	_carqtmp1:=criatrab(_aestrut,.t.)
	dbusearea(.t.,,_carqtmp1,"TMP1",.f.,.f.)

	_cindtmp11:=criatrab(,.f.)
	_cchave :='CLIENTE+LOJA+TABELA+CATEG+DESCRICAO+PRODUTO+LOTECTL+PEDIDO'
	tmp1->(indregua("TMP1",_cindtmp11,_cchave,,,"Selecionando registros..."))

	_cindtmp12:=criatrab(,.f.)
	_cchave  :="CLIENTE+LOJA+TABELA+CATEG+LOCALIZ+DESCRICAO+LOTECTL"
	tmp1->(indregua("TMP1",_cindtmp12,_cchave))

	tmp1->(dbclearind())
	tmp1->(dbsetindex(_cindtmp11))
	tmp1->(dbsetindex(_cindtmp12))

	tmp1->(dbsetorder(1))

	sc9->(dbseek(_cfilsc9+_pedqry,.t.))
	while sc9->(!eof()) .and. SC9->c9_pedido = _pedqry 
		if sc9->c9_nfiscal = _nfiscal .and. sc9->c9_agreg = _agregu
			_cpedido:=sc9->c9_pedido
			sc5->(dbseek(_cfilsc5+_cpedido))
			if sc5->c5_tipo=="N"
				_nregsc9:=sc9->(recno())
				_lok:=.t.
				while ! sc9->(eof()) .and.;
				sc9->c9_filial==_cfilsc9 .and.;
				sc9->c9_pedido==_cpedido
					sc9->(dbskip())
				end
				if _lok
					sc9->(dbgoto(_nregsc9))
					while ! sc9->(eof()) .and.;
					sc9->c9_filial==_cfilsc9 .and.;
					sc9->c9_pedido==_cpedido
						sb1->(dbseek(_cfilsb1+sc9->c9_produto))
						_cquery:= " SELECT " 
						_cquery+= " DB_PRODUTO PRODUTO, " 
						_cquery+= " SDB.DB_LOTECTL LOTETCL, " 
						_cquery+= " SDB.DB_LOCALIZ LOCALIZ, " 
						_cquery+= " SDB.DB_QUANT QUANT, "
						_cquery+= " SDB.DB_ITEM ITEM"
						_cquery+= " FROM SDB010 SDB "
						_cquery+= " WHERE SDB.D_E_L_E_T_ = ' ' "
						_cquery+= " AND SDB.DB_PRODUTO='"+sc9->c9_produto+"'" 
						_cquery+= " AND SDB.DB_LOCALIZ <> ' '" 
						_cquery+= " AND SDB.DB_LOTECTL='"+sc9->c9_lotectl+"'"
						_cquery+= " AND SDB.DB_DOC='"+_nfiscal+"'"
						_cquery+= " ORDER BY  DB_DOC, DB_PRODUTO, DB_LOTECTL, DB_LOCALIZ "

						_cquery:=changequery(_cquery)
						memowrite("C:/Stephen/qryrelato.txt",_cquery)
						tcquery _cquery new alias "TMP3"
						tmp3->(dbgotop())
						while ! tmp3->(eof())
							sb1->(dbseek(_cfilsb1+sc9->c9_produto))
							tmp1->(dbappend())
							tmp1->cliente  :=sc9->c9_cliente
							tmp1->loja     :=sc9->c9_loja
							tmp1->tabela   :=sc5->c5_tabela
							tmp1->categ    :=if(sc5->c5_percfat==100," ",left(sb1->b1_categ,1))
							tmp1->descricao:=sb1->b1_desc   
							tmp1->dtvalid  :=sc9->c9_dtvalid
							tmp1->produto  :=sc9->c9_produto
							tmp1->lotectl  :=sc9->c9_lotectl
							tmp1->pedido   :=sc9->c9_pedido 
							tmp1->qtdlib   :=tmp3->quant
							tmp1->localiz  :=tmp3->localiz
							tmp1->agreg    :=sc9->c9_agreg

							tmp3->(dbskip())

						end
						tmp3->(dbclosearea())		               
						sc9->(dbskip())
					end
				endif
			else
				sc9->(dbskip())
			endif
		else
			sc9->(dbskip())
		endif
	end
return
//***********************************************************************
Static Function ExecArq(_carquivo)
	//***********************************************************************
	LOCAL cDrive     := ""
	LOCAL cDir       := ""
	LOCAL cPathFile  := ""
	LOCAL cCompl     := ""
	LOCAL nRet       := 0

	//³ Retira a ultima barra invertida ( se houver )
	cPathFile := _carquivo

	SplitPath(cPathFile, @cDrive, @cDir )
	cDir := Alltrim(cDrive) + Alltrim(cDir)

	//³ Faz a chamada do aplicativo associado                                  ³
	nRet := ShellExecute( "Open", cPathFile,"",cDir, 1)

	If nRet <= 32
		cCompl := ""
		If nRet == 31
			cCompl := " Nao existe aplicativo associado a este tipo de arquivo!"
		EndIf
		Aviso( "Atencao !", "Nao foi possivel abrir o objeto '" + AllTrim(cPathFile) + "'!" + cCompl, { "Ok" }, 2 )
	EndIf

Return
//*********************************************************************************************************************/
Static Function criatmp4()

	_cQry4 := CRLF + " SELECT " 
	_cQry4 += CRLF + " sc9.C9_DATALIB liber " 
	_cQry4 += CRLF + " from sc9010 sc9 "
	_cQry4 += CRLF + " where sc9.D_E_L_E_T_ = ' '"
	_cQry4 += CRLF + " and sc9.C9_DATALIB > '20180701'"
if mv_par07 = 2	
	_cQry4 += CRLF + " and sc9.C9_BLWMS = '01'"
	_cQry4 += CRLF + " and sc9.C9_NFISCAL = ' '"
Elseif mv_par07 = 3	
	_cQry4 += CRLF + " and sc9.C9_BLWMS = '02'"
	_cQry4 += CRLF + " and sc9.C9_NFISCAL = ' '"
ElseIf mv_par07 = 4	
	_cQry4 += CRLF + " and sc9.C9_BLWMS = '05'"
	_cQry4 += CRLF + " and sc9.C9_NFISCAL = ' '"
ElseIf mv_par07 = 5	
	_cQry4 += CRLF + " and sc9.C9_BLWMS = '05'"
	_cQry4 += CRLF + " and sc9.C9_NFISCAL <> ' '"	
Endif	
	_cQry4 += CRLF + " and rownum = 1 "
	_cQry4 += CRLF + " order by sc9.C9_DATALIB "

	if Select("TMP4") > 0
		TMP4->(dbCloseArea())
	endif

	TCQuery _cQry4 New Alias "TMP4"
	memowrite("C:/Stephen/tmp4.txt",_cqry4)

Return


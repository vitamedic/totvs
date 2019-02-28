#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "MSMGADD.CH"

#DEFINE nTRB  1
#DEFINE nIND1 2
#DEFINE nIND2 3
#DEFINE nIND3 3

User Function Vit616()
Local _afields	:={}

Local oMarkPrivate

aRotina := {}

Private _aUsu  		:= PswRet(1)
Private aTRB 		:= {}
Private cMark		:= GetMark()
Private aNumOS 		:= {}
Private aIndex 		:= {}
Private cChave 		:= Space(255)
Private aSldSB8     := {}
Private aLegenda	:= {}
Private cFiltroTRB 	:= "B8_PRODUTO <> ' '"
Private cCadastro 	:= "Balanceamento de Empenhos"
Private bFiltraBrw  := { || FilBrowse( "TRB" , @aIndex , @cFiltroTRB ) } //Determina a Expressao do Filtro
Private _nRecnos    := 0

//Private cCadastro := "Exemplo de Filtro da mBrowse usando FilBrowse"


/*

    BR_AMARELO
    BR_AZUL
    BR_BRANCO
    BR_CINZA
    BR_LARANJA
    BR_MARROM
    BR_PINK
    BR_PRETO
    BR_VERDE
    BR_VERMELHO

*/

AAdd(aLegenda, {"BR_VERDE"	 , "Corrigir"		})
AAdd(aLegenda, {"BR_AMARELO" , "Nใo corrigir"	})

aCores := {}
aAdd(aCores,{"TRB->OK == '  '"	, "BR_VERDE"	})
aAdd(aCores,{"TRB->ok <> '  '"	, "BR_AMARELO"	})

aRotina   := {  { "Marcar Todos" 	, "u_Vit616M" 		, 0, 4},;
				{ "Desmarcar Todos" , "u_Vit616D" 		, 0, 4},;
				{ "Inverter Todos" 	, "u_Vit616A"		, 0, 4},;
				{ "Pesquisa" 		, "u_Vit616P"		, 0, 1},;
				{ "Reprocessa" 		, "u_Vit616R"		, 0, 3},;
				{ "Expedir\Faturar"	, "u_Vit616S('1')"	, 0, 3},;
				{ "Excluir Pedido" 	, "u_Vit616E"		, 0, 3},;
				{ "Reter"			, "u_Vit616S('5')"	, 0, 3},;
				{ "Gera\Limpa O.S."	, "u_Vit616O"		, 0, 3}}

				/*{ "Legenda" 		, "u_Vit616L" 		, 0, 4},;*/

aRotina   := {  { "Marcar Todos" 	, "u_Vit616M" 		, 0, 4},;
				{ "Desmarcar Todos" , "u_Vit616D" 		, 0, 4},;
				{ "Inverter Todos" 	, "u_Vit616A"		, 0, 4},;
				{ "Pesquisa" 		, "u_Vit616P"		, 0, 1},;
				{ "Reprocessa" 		, "u_Vit616R"		, 0, 3},;
				{ "Corrige" 		, "u_Vit616T0"		, 0, 3}}


if !ValidPerg()
	Return()
endif

//MsgRun("Criando estrutura e carregando dados no arquivo temporแrio...",,{|| aTRB := GeraTemp() } )
Processa( {|lEnd| aTRB := GeraTemp(@lEnd)}, "Aguarde...","Criando estrutura e carregando dados no arquivo temporแrio...", .T. )

AADD(_afields,{"OK"			,"", ""											})
AADD(_afields,{"B8_PRODUTO"	,"", "Produto"									})
AADD(_afields,{"DESC"		,"", "Descri็ใo"								})
AADD(_afields,{"UM"			,"", "UM"										})
AADD(_afields,{"B8_LOCAL"	,"", "Armaz้m"									})
AADD(_afields,{"B8_LOTECTL"	,"", "Lote"										})
AADD(_afields,{"DTVALB8"	,"", "Valid SB8"								})
AADD(_afields,{"DTVALD1"	,"", "Valid SD1"								})
AADD(_afields,{"DTVALC2"	,"", "Valid SC2"								})
AADD(_afields,{"SALDO"		,"", "Saldo SB8"		, "@E 99,999,999.99999"	})
AADD(_afields,{"EMPENHO"	,"", "Empenho SB8"		, "@E 99,999,999.99999"	})
AADD(_afields,{"SSBF"		,"", "Sld SBF"			, "@E 99,999,999.99999"	})
AADD(_afields,{"SSD4"		,"", "Sld SD4"			, "@E 99,999,999.99999"	})

dbSelectArea("TRB")
dbSetOrder(nIND1)
dbGoTop()

Eval( bFiltraBrw )    //Efetiva o Filtro antes da Chamada a mBrowse

MarkBrow( 'TRB', 'OK',,_afields,, cMark,'u_Vit616A()',,,,'u_Vit616F()',{|| u_Vit616A()}, cFiltroTRB, , aCores, , , ,.F.)

//EndFilBrw( "TRB" , @aIndex ) //Finaliza o Filtro

FechaArqTemp()

Return()

User Function Vit616L()

BrwLegenda(cCadastro, "Status do Item", aLegenda)

Return()

User Function Vit616R()
Local oMark := GetMarkBrow()

if !ValidPerg()
	Return()
endif

FechaArqTemp()

//MsgRun("Criando estrutura e carregando dados no arquivo temporแrio...",,{|| aTRB := GeraTemp() } )
Processa( {|lEnd| aTRB := GeraTemp(@lEnd)}, "Aguarde...","Criando estrutura e carregando dados no arquivo temporแrio...", .T. )

MarkBRefresh()

u_Vit616A()

// for็a o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()

Return()

User Function Vit616M()
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
// for็a o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
return                

User Function Vit616D()
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
// for็a o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
Return

// Grava marca no campo
User Function Vit616F()
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
User Function Vit616A()
Local oMark := GetMarkBrow()
dbSelectArea('TRB')
dbGotop()
do while !Eof()
	u_Vit616F()
	dbSkip()
enddo
MarkBRefresh( )
// for็a o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
Return

/**************************/
Static Function ValidPerg() 
/**************************/
Local aHelpPor := {}
Local cPerg    := "Vit616    "

PutSx1(cPerg,"01",OemToAnsi("Limite de Validade Lote ?"        ),"","","mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"02",OemToAnsi("Data de Fechamento ?"             ),"","","mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,{},{})

Return(Pergunte(cPerg,.T.))

Static Function GeraTemp(lEnd)
Local cQry   	:= ""
Local aStru  	:= {}
Local cDtLimite := DtoS(Iif(Empty(mv_Par01), dDataBase, mv_Par01))
Local cDtFecham := Iif(Empty(mv_Par02), GetMV("MV_ULMES"), DtoS(mv_Par02))

if Select("TRB") > 0
	FechaArqTemp()
endif

//ช Estrutura da tabela temporaria
AADD(aStru,{"OK"		,"C", 02, 0})
AADD(aStru,{"B8_PRODUTO","C", 15, 0})
AADD(aStru,{"DESC"		,"C", 40, 0})
AADD(aStru,{"UM"		,"C", 02, 0})
AADD(aStru,{"B8_LOTECTL","C", 10, 0})
AADD(aStru,{"SALDO"		,"N", 16, 5})
AADD(aStru,{"EMPENHO"	,"N", 16, 5})
AADD(aStru,{"B8_LOCAL"	,"C", 02, 0})
AADD(aStru,{"DTVALB8"	,"C", 10, 0})
AADD(aStru,{"DTVALD1"	,"C", 10, 0})
AADD(aStru,{"DTVALC2"	,"C", 10, 0})
AADD(aStru,{"SSBF"		,"N", 16, 5})
AADD(aStru,{"SSD4"		,"N", 16, 5})

// Crio o arquivo de trabalho e os ํndices
cArqTRB := CriaTrab( aStru, .T. )
cInd1 := Left( cArqTRB, 7 ) + "1"
cInd2 := Left( cArqTRB, 7 ) + "2"
cInd3 := Left( cArqTRB, 7 ) + "3"

// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
dbUseArea( .T., __LocalDriver, cArqTRB, "TRB", .F., .F. )

// Criar os ํndices.
IndRegua( "TRB", cInd1, "B8_PRODUTO+B8_LOTECTL+B8_LOCAL", , , "Criando ํndices (Produto + Lote + Armaz้m)...")
IndRegua( "TRB", cInd2, "B8_LOTECTL+B8_LOCAL+B8_PRODUTO", , , "Criando ํndices (Lote + Armaz้m + Produto)...")
IndRegua( "TRB", cInd3, "B8_LOCAL+B8_LOTECTL+B8_PRODUTO", , , "Criando ํndices (Armaz้m + Lote + Produto)...")

// Libera os ํndices.
dbClearIndex()

// Agrega a lista dos ํndices da tabela (arquivo).
dbSetIndex( cInd1 + OrdBagExt() )
dbSetIndex( cInd2 + OrdBagExt() )
dbSetIndex( cInd3 + OrdBagExt() )

dbSetOrder(1)

	aSldSB8 := {}
	if Select("QKAR") > 0
		dbSelectArea("QKAR")
		dbCloseArea()
	endif

	cQry :=        " SELECT QFIL.*, SB1.B1_DESC, SB1.B1_UM "
	cQry += CRLF + " FROM ( SELECT QQ.*, SB9.B9_CM1, SD1.D1_DTVALID, SC2.C2_DTVALID "
	cQry += CRLF + "        FROM ( SELECT Q.B8_FILIAL, Q.B8_LOCAL, Q.B8_PRODUTO, Q.B8_LOTECTL, Q.B8_DTVALID, Q.B8_SALDO, Q.B8_EMPENHO, SUM(Q.SSBF) SSBF, SUM(Q.SSD4) SSD4 "
	cQry += CRLF + "               FROM (  SELECT SB8.B8_FILIAL, SB8.B8_LOCAL, SB8.B8_PRODUTO, SB8.B8_LOTECTL, SB8.B8_DTVALID, SB8.B8_SALDO, SB8.B8_EMPENHO, SUM(SBF.BF_QUANT) SSBF, 0 SSD4 "
	cQry += CRLF + "                       FROM "+RetSqlName("SB8")+" SB8 "
	cQry += CRLF + "                       INNER JOIN "+RetSqlName("SBF")+" SBF ON (SBF.D_E_L_E_T_    = ' '  "
	cQry += CRLF + "                                         AND SBF.BF_FILIAL  = SB8.B8_FILIAL "
	cQry += CRLF + "                                         AND SBF.BF_LOCAL   = SB8.B8_LOCAL "
	cQry += CRLF + "                                         AND SBF.BF_PRODUTO = SB8.B8_PRODUTO "
	cQry += CRLF + "                                         AND SBF.BF_LOTECTL = SB8.B8_LOTECTL "
	cQry += CRLF + "                                         ) "
	cQry += CRLF + "                       WHERE SB8.D_E_L_E_T_ = ' '  "
	cQry += CRLF + "                         AND SB8.B8_LOCAL NOT IN ('12', '16', '17', '92', '95', '93') "
	cQry += CRLF + "                         AND SB8.B8_SALDO <> 0 "
	cQry += CRLF + "                         AND SB8.B8_DTVALID <= '"+cDtLimite+"'  "
	cQry += CRLF + "                       GROUP BY SB8.B8_FILIAL, SB8.B8_LOCAL, SB8.B8_PRODUTO, SB8.B8_LOTECTL, SB8.B8_DTVALID, SB8.B8_SALDO, SB8.B8_EMPENHO  "
	cQry += CRLF + "  "
	cQry += CRLF + "                UNION ALL "
	cQry += CRLF + "  "
	cQry += CRLF + "                SELECT SB8.B8_FILIAL, SB8.B8_LOCAL, SB8.B8_PRODUTO, SB8.B8_LOTECTL, SB8.B8_DTVALID, SB8.B8_SALDO, SB8.B8_EMPENHO, 0 SSBF, SUM(SD4.D4_QUANT) SSD4 "
	cQry += CRLF + "                FROM "+RetSqlName("SB8")+" SB8 "
	cQry += CRLF + "                INNER JOIN "+RetSqlName("SD4")+" SD4 ON (SD4.D_E_L_E_T_    = ' '  "
	cQry += CRLF + "                                         AND SD4.D4_FILIAL  = SB8.B8_FILIAL "
	cQry += CRLF + "                                         AND SD4.D4_LOCAL   = SB8.B8_LOCAL "
	cQry += CRLF + "                                         AND SD4.D4_COD     = SB8.B8_PRODUTO "
	cQry += CRLF + "                                         AND SD4.D4_LOTECTL = SB8.B8_LOTECTL "
	cQry += CRLF + "                                         ) "
	cQry += CRLF + "                WHERE SB8.D_E_L_E_T_ = ' '  "
	cQry += CRLF + "                  AND SB8.B8_LOCAL NOT IN ('12', '16', '17', '92', '95', '93') "
	cQry += CRLF + "                  AND SB8.B8_SALDO <> 0 "
	cQry += CRLF + "                  AND SB8.B8_DTVALID <= '"+cDtLimite+"' "
	cQry += CRLF + "                GROUP BY SB8.B8_FILIAL, SB8.B8_LOCAL, SB8.B8_PRODUTO, SB8.B8_LOTECTL, SB8.B8_DTVALID, SB8.B8_SALDO, SB8.B8_EMPENHO "
	cQry += CRLF + "        ) Q "
	cQry += CRLF + "        GROUP BY Q.B8_FILIAL, Q.B8_LOCAL, Q.B8_PRODUTO, Q.B8_LOTECTL, Q.B8_DTVALID, Q.B8_SALDO, Q.B8_EMPENHO "
	cQry += CRLF + "        HAVING SUM(Q.SSBF) <> 0 OR SUM(Q.SSD4)<> 0 "
	cQry += CRLF + "        ORDER BY Q.B8_FILIAL, Q.B8_LOCAL, Q.B8_PRODUTO, Q.B8_LOTECTL "
	cQry += CRLF + " ) QQ "
	cQry += CRLF + " LEFT JOIN "+RetSqlName("SB9")+" SB9 ON (SB9.B9_FILIAL = QQ.B8_FILIAL "
	cQry += CRLF + "                         AND SB9.B9_LOCAL = QQ.B8_LOCAL "
	cQry += CRLF + "                         AND SB9.B9_COD = QQ.B8_PRODUTO  "
	cQry += CRLF + "                         AND SB9.B9_DATA = '"+cDtFecham+"' "
	cQry += CRLF + "                         AND SB9.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "                         )  "
	cQry += CRLF + " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON (SD1.D_E_L_E_T_     = ' ' "
	cQry += CRLF + "                         AND SD1.D1_FILIAL  = QQ.B8_FILIAL "
	cQry += CRLF + "                         AND SD1.D1_COD     = QQ.B8_PRODUTO "
	cQry += CRLF + "                         --AND SD1.D1_LOCAL   = Q.B8_LOCAL "
	cQry += CRLF + "                         AND SD1.D1_LOTECTL = QQ.B8_LOTECTL ) "
	cQry += CRLF + " LEFT JOIN "+RetSqlName("SC2")+" SC2 ON (SC2.D_E_L_E_T_     = ' ' "
	cQry += CRLF + "                         AND SC2.C2_FILIAL  = QQ.B8_FILIAL "
	cQry += CRLF + "                         AND SC2.C2_PRODUTO = QQ.B8_PRODUTO "
	cQry += CRLF + "                         --AND SC2.C2_LOCAL   = Q.B8_LOCAL "
	cQry += CRLF + "                         AND SC2.C2_LOTECTL = QQ.B8_LOTECTL ) "
	cQry += CRLF + " ) QFIL  "
	cQry += CRLF + " INNER JOIN "+RetSqlName("SB1")+" SB1 ON (SB1.B1_FILIAL     = '"+XFilial("SB1")+"' "        
	cQry += CRLF + "                                         AND SB1.B1_COD     = QFIL.B8_PRODUTO "
	cQry += CRLF + "                                         AND SB1.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "                                         ) "
	cQry += CRLF + " INNER JOIN "+RetSqlName("SB8")+" QB8 ON (QB8.B8_FILIAL  = QFIL.B8_FILIAL "        
	cQry += CRLF + "                                         AND QB8.B8_PRODUTO = QFIL.B8_PRODUTO "
	cQry += CRLF + "                                         AND QB8.B8_LOCAL   = QFIL.B8_LOCAL "
	cQry += CRLF + "                                         AND QB8.B8_LOTECTL = QFIL.B8_LOTECTL "
	cQry += CRLF + "                                         AND QB8.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "                                         ) "
	cQry += CRLF + " ORDER BY 3,4,2  "
	
	MemoWrite("c:\temp\Vit616.sql",cQry)    

	_nRecnos := u_CountRegs(cQry,"QKAR")

	//SetRegua(_nRecnos)        
	ProcRegua(_nRecnos)
	
	do while QKAR->( !Eof() )
		//IncRegua()
		IncProc("Alimentando tabela temporแria...")
		if lEnd
			MsgInfo("Processamento interrompido.","Fim")
			exit
		endif
		
		if ( i := AScan(aSldSB8, {|x| x[1] == QKAR->B8_PRODUTO .and. x[2] == QKAR->B8_LOCAL} ) ) == 0
		
			AAdd(aSldSB8, {QKAR->B8_PRODUTO, QKAR->B8_LOCAL, ""})
			
		endif
		
		dbSelectArea("TRB")
		if RecLock("TRB", .t.)
			TRB->B8_PRODUTO	:= QKAR->B8_PRODUTO
			TRB->DESC 		:= QKAR->B1_DESC
			TRB->UM 		:= QKAR->B1_UM
			TRB->B8_LOTECTL	:= QKAR->B8_LOTECTL
			TRB->B8_LOCAL	:= QKAR->B8_LOCAL
			TRB->SALDO 		:= QKAR->B8_SALDO
			TRB->EMPENHO	:= QKAR->B8_EMPENHO
			TRB->DTVALB8	:= DtoC(StoD(QKAR->B8_DTVALID))
			TRB->DTVALD1	:= DtoC(StoD(QKAR->D1_DTVALID))
			TRB->DTVALC2	:= DtoC(StoD(QKAR->C2_DTVALID))
			TRB->SSBF		:= QKAR->SSBF
			TRB->SSD4		:= QKAR->SSD4
			
			TRB->( MsUnLock() )
	    endif
	    
		QKAR->( dbSkip() )
	enddo
	        
	QKAR->( dbCloseArea() )

Return({cArqTRB, cInd1, cInd2, cInd3})

Static Function FechaArqTemp()

	//Fecha a แrea
	TRB->(dbCloseArea())
	
	//Apaga o arquivo fisicamente
	FErase( aTRB[ nTRB ] + GetDbExtension())
	
	//Apaga os arquivos de ํndices fisicamente
	FErase( aTRB[ nIND1 ] + OrdBagExt())
	FErase( aTRB[ nIND2 ] + OrdBagExt())
	FErase( aTRB[ nIND3 ] + OrdBagExt())

Return()

//Troca de Lote
User Function Vit616T0()
	Processa( {|lEnd| u_Vit616T1(@lEnd)}, "Aguarde...","Corrigindo Tabelas...", .T. )
Return

User Function Vit616T1(lEnd)
Local oMark 	:= GetMarkBrow()

BeginTran()

ProcRegua( Iif(Type("_nRecnos") == "U", 0, _nRecnos) )

AEval(aSldSB8, {|x| x[3] := ""})

dbSelectArea('TRB')                     
dbSetOrder(1) // Ordernar por produto para aglutinar o saldo เ ser ajustado com o Kardex
dbGotop()
do while !Eof()
	if IsMark( 'OK', cMark )
		
		if ( i := AScan(aSldSB8, {|x| x[1] == TRB->B8_PRODUTO .and. x[2] == TRB->B8_LOCAL} ) ) > 0 
			aSldSB8[i,3] := "S"
		endif           
		
		IncProc("Processando corre็ใo dos saldos...")
		if lEnd
			MsgInfo("Processamento interrompido.","Fim")
			exit
		endif

		if TRB->SSD5 <> TRB->SALDO
			nSaldo := Round( TRB->SSD5 - TRB->SALDO , 5 )
		    
			if nSaldo <> 0
				ProcSD5(TRB->B8_PRODUTO, TRB->B8_LOCAL, nSaldo * (-1), TRB->B8_LOTECTL)
			endif
		endif
		
		if TRB->SSDB <> TRB->SALDO
			nSaldo := Round( TRB->SSDB - TRB->SALDO , 5 )
		    
			if nSaldo <> TRB->SSDA
				ProcSDB(TRB->B8_PRODUTO, TRB->B8_LOCAL, nSaldo * (-1), TRB->B8_LOTECTL, "TEMP")
			endif
		endif
		
		if TRB->SSD2SD3 <> TRB->SALDO
			nSaldo := Round( TRB->SSD2SD3 - TRB->SALDO , 5 )
		    
			ProcSD3(TRB->B8_PRODUTO, TRB->B8_LOCAL, nSaldo * (-1), TRB->B8_LOTECTL)
			
		endif

	endif

	dbSelectArea('TRB')                     
	dbSkip()
enddo

EndTran()

if ( nRet := TCSqlExec("Commit") ) < 0

	msgAlert("Erro ao tentar salvar as transa็๕es no banco de dados.", "A t e n ็ ใ o")

else
	
	for i := 1 to len(aSldSB8)
		if aSldSB8[i,3] == "S"
			nSaldo := 0

			if Select("QSLD") > 0
				dbSelectArea("QSLD")
				dbCloseArea()
			endif 
			
			cQry :=        " SELECT SUM(SB8.B8_SALDO) SALDO
			cQry += CRLF + " FROM "+RetSqlName("SB8")+" SB8 "
			cQry += CRLF + " WHERE B8_FILIAL  = '" + XFilial("SB8") + "'"
			cQry += CRLF + "   AND B8_PRODUTO = '" + aSldSB8[i,1] + "'"
			cQry += CRLF + "   AND B8_LOCAL   = '" + aSldSB8[i,2] + "'"
			cQry += CRLF + "   AND D_E_L_E_T_ = ' '"
	
			TCQuery cQry New Alias "QSLD"
			
			if QSLD->(!Eof())
				nSaldo := QSLD->SALDO
			endif
			
			QSLD->(dbCloseArea())
			
			nQtd := CalcEst(aSldSB8[i,1], aSldSB8[i,2], dDataBase+1)[1]
			
			if (nQtd - nSaldo) <> 0
				ProcSD3(aSldSB8[i,1], aSldSB8[i,2], ( nQtd - nSaldo ) * (-1), " ")
			endif                                                                                                 
		endif
	next i

endif
	
MarkBRefresh( )

// for็a o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()

msgAlert("Corre็ใo realizada com sucesso..")

Return()

/*****
*
* Fun็ใo para pesquisar dados no arquivo temporแrio.
*
*/
User Function Vit616P()
Local oDlgPesq, oOrdem, oChave, oBtOk, oBtCan, oBtPar, cOrdem
Local oMark     := GetMarkBrow()
Local aOrdens 	:= {}
Local aLens     := {}
Local nOrdem 	:= 1
Local nOpcao 	:= 0
Local lExiste 	:= .f.
Local nTamTotal := TamSX3("B8_LOCAL")[1] + TamSX3("B8_LOTECTL")[1] + TamSX3("B8_PRODUTO")[1]

AAdd( aOrdens, "Produto + Lote + Armaz้m" )
AAdd( aOrdens, "Lote + Armaz้m + Produto" )
AAdd( aOrdens, "Armaz้m + Lote + Produto" )

AAdd( aLens, {"B8_PRODUTO", "B8_LOTECTL", "B8_LOCAL"} )
AAdd( aLens, {"B8_LOTECTL", "B8_LOCAL", "B8_PRODUTO"} )
AAdd( aLens, {"B8_LOCAL", "B8_LOTECTL", "B8_PRODUTO"} )

cChave := Pad(cChave, nTamTotal)

DEFINE MSDIALOG oDlgPesq TITLE "Pesquisa" FROM 00,00 TO 100,500 PIXEL
  @ 005, 005 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdens SIZE 210,08 PIXEL OF oDlgPesq ON CHANGE nOrdem := oOrdem:nAt
  @ 020, 005 MSGET oChave VAR cChave SIZE 210,08 OF oDlgPesq PIXEL
  DEFINE SBUTTON oBtOk  FROM 05,218 TYPE 1 ACTION (nOpcao := 1, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
  DEFINE SBUTTON oBtCan FROM 20,218 TYPE 2 ACTION (nOpcao := 0, oDlgPesq:End()) ENABLE OF oDlgPesq PIXEL
  DEFINE SBUTTON oBtPar FROM 35,218 TYPE 5 WHEN .F. OF oDlgPesq PIXEL
ACTIVATE MSDIALOG oDlgPesq CENTER

if nOpcao == 1
  	cChave := Pad(AllTrim(cChave),nTamTotal)
  	
	Eval({|| nA := TamSX3(aLens[nOrdem][1])[1] 																							,;
	         nB := TamSX3(aLens[nOrdem][2])[1] 																							,;
	         nC := TamSX3(aLens[nOrdem][3])[1] 																							,;
	         cFiltroTRB := aLens[nOrdem][1] + " = '" + Left(cChave, nA) + "'" 												+;
	         Iif(empty(SubStr(cChave, nA+1, nB)), "", " .AND. " + aLens[nOrdem][2] + " = '" + SubStr(cChave, nA+1, nB) + "'" ) 			+;
	         Iif(empty(SubStr(cChave, nA+nB+1, nC)), "", " .AND. " + aLens[nOrdem][3] + " = '" + SubStr(cChave, nA+nB+1, nC) + "'" ) } 	)
	
	dbSelectArea("TRB")
	dbSetOrder(nOrdem)
	dbGoTop()
	lExiste := TRB->(MSSeek(Alltrim(cChave), .t.))
    
	//Eval( bFiltraBrw ) //Efetiva o Filtro antes da Chamada a mBrowse
	
else
  	cChave 		:= Space(nTamTotal)
	cFiltroTRB 	:= "B8_PRODUTO <> ' '"

 	//Eval( bFiltraBrw ) //Efetiva o Filtro antes da Chamada a mBrowse

endif

MarkBRefresh()

oMark:oBrowse:ResetLen()
oMark:oBrowse:GoTop()
oMark:oBrowse:Refresh()

Return

User Function MbrFEx2()

 Local oMark  := GetMarkBrow()
 Local aIndex := {}

 Private aRotina := {;
       { "Pesquisar" , "PesqBrw"  , 0 , 1 },;
       { "Visualizar" , "AxVisual" , 0 , 2 },;
       { "Incluir"  , "AxInclui" , 0 , 3 },;
       { "Alterar"  , "AxAltera" , 0 , 4 },;
       { "Excluir"  , "AxDeleta" , 0 , 5 };
      }

 Private bFiltraBrw := { || FilBrowse( "TRB" , @aIndex , @cFiltroTRB ) } //Determina a Expressao do Filtro

//Private cCadastro := "Exemplo de Filtro da mBrowse usando FilBrowse"

 Eval( bFiltraBrw )    //Efetiva o Filtro antes da Chamada a mBrowse

 //mBrowse( 6 , 1 , 22 , 75 , "SRA" )

 oMark:oBrowse:EndFilBrw( "TRB" , @aIndex ) //Finaliza o Filtro

Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCMOV    บAutor  ณMicrosiga           บ Data ณ  12/26/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ProcSD3(cProd, cAlmox, nQuant, cLoteCtl)

Local lRet       := .T.

RecLock('SD3',.T.)
Replace D3_FILIAL  With xFilial('SD3')
Replace D3_COD     With cProd
Replace D3_QUANT   With Abs(QtdComp(nQuant))
Replace D3_CF      With If(QtdComp(nQuant)<QtdComp(0),'RE0','DE0')
Replace D3_CHAVE   With If(QtdComp(nQuant)<QtdComp(0),'E0','E9')
Replace D3_LOCAL   With cAlmox
Replace D3_DOC     With 'ACERTO'
Replace D3_EMISSAO With dDataBase
Replace D3_UM      With SB1->B1_UM
Replace D3_GRUPO   With SB1->B1_GRUPO
Replace D3_NUMSEQ  With ProxNum()
Replace D3_QTSEGUM With ConvUm(cProd,Abs(QtdComp(nQuant)),0,2)
Replace D3_SEGUM   With SB1->B1_SEGUM
Replace D3_TM      With If(QtdComp(nQuant)<QtdComp(0),'999','499')
Replace D3_TIPO    With SB1->B1_TIPO
Replace D3_CONTA   With SB1->B1_CONTA
Replace D3_USUARIO With SubStr(cUsuario,7,15)
Replace D3_LOTECTL With cLoteCtl
Replace D3_LOCALIZ With ''
Replace D3_IDENT   With ''
Replace D3_DTVALID With CtoD('  /  /  ')
MsUnLock()

/*
dbSelectArea('SB2')
dbSetOrder(1)
If !MsSeek(xFilial('SB2')+cProd+cAlmox, .F.)
	CriaSB2(cProd, cAlmox)
EndIf
RecLock('SB2', .F.)
Replace B2_QATU With If(QtdComp(nQuant)<QtdComp(0),(B2_QATU-Abs(nQuant)),(B2_QATU+Abs(nQuant)))
MsUnlock()

If B2_QATU < 0
	MsgAlert("B2 Negativo !!!","IncMov")
Else
*/

//EndIf


Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCMOV    บAutor  ณMicrosiga           บ Data ณ  12/26/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ProcSD5(cProd, cAlmox, nQuant, cLoteCtl)

Local lRet       := .T.
Local aGravaSD5  := {}
Local nY         := 1
Local cSeekSB8   := ''
Local cNumLote   := ''
Local nResta     := 0

dbSelectArea('SB8')
dbSetOrder(3) //-- B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
If MsSeek(xFilial('SB8')+cProd+cAlmox+cLoteCtl+cNumLote, .F.)

	aAdd(aGravaSD5, {'SD5',;
		cProd,;
		cAlmox,;
		cLoteCtl,;
		cNumLote,;
		ProxNum(),;
		'ACERTO',;
		'UNI',;
		'',;
		If(QtdComp(nQuant)<QtdComp(0),'999','499'),;
		'',;
		'',;
		'',;
		Abs(QtdComp(nQuant)),;
		ConvUm(cProd,Abs(QtdComp(nQuant)),0,2),;
		dDataBase,;
		dDataBase+SB1->B1_PRVALID})
	
	GravaSD5(aGravaSD5[nY,01],;
		aGravaSD5[nY,02],;
		aGravaSD5[nY,03],;
		aGravaSD5[nY,04],;
		""/*If(!Empty(aGravaSD5[ny,05]),aGravaSD5[ny,05],NextLote(aGravaSD5[ny,02],"S"))*/,;
		aGravaSD5[nY,06],;
		aGravaSD5[nY,07],;
		aGravaSD5[nY,08],;
		aGravaSD5[nY,09],;
		aGravaSD5[nY,10],;
		aGravaSD5[nY,11],;
		aGravaSD5[nY,12],;
		aGravaSD5[nY,13],;
		aGravaSD5[nY,14],;
		aGravaSD5[nY,15],;
		aGravaSD5[nY,16],;
		aGravaSD5[nY,17])

EndIf

/*
nResta := Abs(nQuant)
dbSelectArea('SB8')
dbSetOrder(3) //-- B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
If MsSeek((cSeekSB8:=xFilial('SB8')+cProd+cAlmox+cLoteCtl)+cNumLote, .F.)
	Do While !Eof() .And. cSeekSB8 == B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL .And. nResta>0
		If QtdComp(nQuant) < QtdComp(0)
			If B8_SALDO > 0
				nResta := (nResta-If(B8_SALDO>=Abs(nQuant),Abs(nQuant),B8_SALDO))
				RecLock('SB8', .F.)
				Replace B8_SALDO With (B8_SALDO-If(B8_SALDO>=Abs(nQuant),Abs(nQuant),B8_SALDO))
				MsUnlock()
			EndIf
		Else
			nResta := (nResta-nQuant)
			RecLock('SB8', .F.)
			Replace B8_SALDO With (B8_SALDO+nQuant)
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
Else
	If QtdComp(nQuant) < QtdComp(0)
		MsgAlert("Registro no SB8 nao encontrado !!!","IncMov")
	Else
		MsgAlert("Sera criado um Registro no SB8...","IncMov")
		CriaLote('SD5',cProd,cAlmox,cLoteCtl,SD5->D5_NUMLOTE,'','','',If(QtdComp(nQuant)<QtdComp(0),'999','499'),'MI','',SD5->D5_NUMSEQ,SD5->D5_DOC,SD5->D5_SERIE,'',Abs(nQuant),ConvUm(cProd,Abs(QtdComp(nQuant)),0,2),dDataBase,CtoD('  /  /  '),.F.)
	EndIf
EndIf

If nResta < 0
	MsgAlert("B8 Negativo !!!","IncMov")
Else
*/

//EndIf


Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCMOV    บAutor  ณMicrosiga           บ Data ณ  12/26/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ProcSDB(cProd, cAlmox, nQuant, cLoteCtl, cLocaliz)

Local lRet       := .T.
Local aCriaSDB   := {}
Local nX         := 1

aAdd(aCriaSDB,{cProd,;
	cAlmox,;
	Abs(QtdComp(nQuant)),;
	cLocaliz,;
	'',;
	'ACERTO',;
	'UNI',;
	'',;
	'',;
	'',;
	'SDB',;
	dDataBase,;
	cLoteCtl,;
	'',;
	ProxNum(),;
	If(QtdComp(nQuant)<QtdComp(0),'999','499'),;
	'M',;
	StrZero(1,Len(SDB->DB_ITEM)),;
	.F.,;
	0,;
	0})

CriaSDB( aCriaSDB[nX,01],;
	aCriaSDB[nX,02],;
	aCriaSDB[nX,03],;
	aCriaSDB[nX,04],;
	aCriaSDB[nX,05],;
	aCriaSDB[nX,06],;
	aCriaSDB[nX,07],;
	aCriaSDB[nX,08],;
	aCriaSDB[nX,09],;
	aCriaSDB[nX,10],;
	aCriaSDB[nX,11],;
	aCriaSDB[nX,12],;
	aCriaSDB[nX,13],;
	aCriaSDB[nX,14],;
	aCriaSDB[nX,15],;
	aCriaSDB[nX,16],;
	aCriaSDB[nX,17],;
	aCriaSDB[nX,18],;
	aCriaSDB[nX,19],;
	aCriaSDB[nX,20],;
	aCriaSDB[nX,21])

Return(lRet)
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "MSMGADD.CH"

#DEFINE nTRB  1
#DEFINE nIND1 2
#DEFINE nIND2 3
#DEFINE nIND3 3

User Function Vit610()
Local _afields	:={}

Local oMarkPrivate

aRotina := {}

Private _aUsu  		:= PswRet(1)
Private aTRB 		:= {}
Private cMark		:=GetMark()
Private aNumOS 		:= {}
Private aIndex 		:= {}
Private cChave 		:= Space(255)
Private aSldSB8     := {}
Private aLegenda	:= {}
Private cFiltroTRB 	:= "B8_PRODUTO <> ' '"
Private cCadastro 	:= "Balanceamento de Itegridade do Kardex"
Private bFiltraBrw  := { || FilBrowse( "TRB" , @aIndex , @cFiltroTRB ) } //Determina a Expressao do Filtro
Private _nRecnos    := 0
//Private _DtInv      := "INV"+DtoS(dDataBase)

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
AAdd(aLegenda, {"BR_AMARELO" , "Não corrigir"	})

aCores := {}
aAdd(aCores,{"TRB->OK == '  '"	, "BR_VERDE"	})
aAdd(aCores,{"TRB->ok <> '  '"	, "BR_AMARELO"	})

aRotina   := {  { "Marcar Todos" 	, "u_Vit610M" 		, 0, 4},;
				{ "Desmarcar Todos" , "u_Vit610D" 		, 0, 4},;
				{ "Inverter Todos" 	, "u_Vit610A"		, 0, 4},;
				{ "Pesquisa" 		, "u_Vit610P"		, 0, 1},;
				{ "Reprocessa" 		, "u_Vit610R"		, 0, 3},;
				{ "Expedir\Faturar"	, "u_Vit610S('1')"	, 0, 3},;
				{ "Excluir Pedido" 	, "u_Vit610E"		, 0, 3},;
				{ "Reter"			, "u_Vit610S('5')"	, 0, 3},;
				{ "Gera\Limpa O.S."	, "u_Vit610O"		, 0, 3}}

				/*{ "Legenda" 		, "u_Vit610L" 		, 0, 4},;*/

aRotina   := {  { "Marcar Todos" 	, "u_Vit610M" 		, 0, 4},;
				{ "Desmarcar Todos" , "u_Vit610D" 		, 0, 4},;
				{ "Inverter Todos" 	, "u_Vit610A"		, 0, 4},;
				{ "Pesquisa" 		, "u_Vit610P"		, 0, 1},;
				{ "Reprocessa" 		, "u_Vit610R"		, 0, 3},;
				{ "Corrige" 		, "u_Vit610T0"		, 0, 3}}


if !ValidPerg()
	Return()
endif

//MsgRun("Criando estrutura e carregando dados no arquivo temporário...",,{|| aTRB := GeraTemp() } )
Processa( {|lEnd| aTRB := GeraTemp(@lEnd)}, "Aguarde...","Criando estrutura e carregando dados no arquivo temporário...", .T. )

AADD(_afields,{"OK"			,"", ""											})
AADD(_afields,{"B8_PRODUTO"	,"", "Produto"									})
AADD(_afields,{"DESC"		,"", "Descrição"								})
AADD(_afields,{"UM"			,"", "UM"										})
AADD(_afields,{"B8_LOCAL"	,"", "Armazém"									})
AADD(_afields,{"B8_LOTECTL"	,"", "Lote"										})
AADD(_afields,{"DTEMIS"		,"", "Data"										})
AADD(_afields,{"DTVALID"	,"", "Validade"									})
AADD(_afields,{"SALDO"		,"", "Saldo SB8"		, "@E 99,999,999.99999"	})
AADD(_afields,{"SSD2SD3"	,"", "Sld SD2-SD3"		, "@E 99,999,999.99999"	})
AADD(_afields,{"SSD5"		,"", "Sld SD5"			, "@E 99,999,999.99999"	})
AADD(_afields,{"SSDB"		,"", "Sld SDB"			, "@E 99,999,999.99999"	})
AADD(_afields,{"SSDA"		,"", "Sld SDA"			, "@E 99,999,999.99999"	})

dbSelectArea("TRB")
dbSetOrder(nIND1)
dbGoTop()

Eval( bFiltraBrw )    //Efetiva o Filtro antes da Chamada a mBrowse

MarkBrow( 'TRB', 'OK',,_afields,, cMark,'u_Vit610A()',,,,'u_Vit610F()',{|| u_Vit610A()}, cFiltroTRB, , aCores, , , ,.F.)

//EndFilBrw( "TRB" , @aIndex ) //Finaliza o Filtro

FechaArqTemp()

Return()

User Function Vit610L()

BrwLegenda(cCadastro, "Status do Item", aLegenda)

Return()

User Function Vit610R()
Local oMark := GetMarkBrow()

if !ValidPerg()
	Return()
endif

FechaArqTemp()

//MsgRun("Criando estrutura e carregando dados no arquivo temporário...",,{|| aTRB := GeraTemp() } )
Processa( {|lEnd| aTRB := GeraTemp(@lEnd)}, "Aguarde...","Criando estrutura e carregando dados no arquivo temporário...", .T. )

MarkBRefresh()

u_Vit610A()

// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()

Return()

User Function Vit610M()
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

User Function Vit610D()
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
User Function Vit610F()
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
User Function Vit610A()
Local oMark := GetMarkBrow()
dbSelectArea('TRB')
dbGotop()
do while !Eof()
	u_Vit610F()
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
Local cPerg    := "Vit610    "

PutSx1(cPerg,"01",OemToAnsi("Data De ?"                        ),"","","mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"02",OemToAnsi("Data Até ?"                       ),"","","mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"03",OemToAnsi("Produto de ?"                     ),"","","mv_ch3","C",15,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"04",OemToAnsi("Produto Até "                     ),"","","mv_ch4","C",15,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"05",OemToAnsi("Armazém De ?"                     ),"","","mv_ch5","C",02,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"06",OemToAnsi("Armazém Até ?"                    ),"","","mv_ch6","C",02,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"07",OemToAnsi("Tabela à comparar :"              ),"","","mv_ch7","N",01,0,0,"C","","","","","mv_par07","Geral","","","1","SD2 - SD3","","","SD5","","","SDB","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"08",OemToAnsi("Filtra Empenhos Desbalanceados ?" ),"","","mv_ch8","N",01,0,0,"C","","","","","mv_par08","Não","","","1","Sim","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"09",OemToAnsi("Limite de Validade Lote ?"        ),"","","mv_ch9","D",08,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"10",OemToAnsi("Data de Fechamento ?"             ),"","","mv_chA","D",08,0,0,"G","","","","","mv_par10","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"11",OemToAnsi("Lote de ?"                        ),"","","mv_chB","C",10,0,0,"G","","","","","mv_par11","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"12",OemToAnsi("Lote Até "                        ),"","","mv_chC","C",10,0,0,"G","","","","","mv_par12","","","","","","","","","","","","","","","","",aHelpPor,{},{})

Return(Pergunte(cPerg,.T.))

Static Function GeraTemp(lEnd)
Local cQry   	:= ""
Local aStru  	:= {}
Local cDtIni    := Iif(Empty(mv_Par01), "20080701", DtoS(mv_Par01))
Local cDtFim    := DtoS(Iif(Empty(mv_Par02), dDataBase, mv_Par02))
Local cDtLimite := DtoS(Iif(Empty(mv_Par09), dDataBase, mv_Par09))
Local cDtFecham := Iif(Empty(mv_Par10), GetMV("MV_ULMES"), DtoS(mv_Par10))
Local cLoteIni  := Pad(Iif(Empty(mv_Par11), "", mv_Par11), TamSX3("B8_LOTECTL")[1])
Local cLoteFim  := Pad(Iif(Empty(mv_Par12), "", mv_Par12), TamSX3("B8_LOTECTL")[1], "Z")

if Select("TRB") > 0
	FechaArqTemp()
endif

//ª Estrutura da tabela temporaria
AADD(aStru,{"OK"		,"C", 02, 0})
AADD(aStru,{"B8_PRODUTO","C", 15, 0})
AADD(aStru,{"DESC"		,"C", 40, 0})
AADD(aStru,{"UM"		,"C", 02, 0})
AADD(aStru,{"B8_LOTECTL","C", 10, 0})
AADD(aStru,{"SALDO"		,"N", 16, 5})
AADD(aStru,{"B8_LOCAL"	,"C", 02, 0})
AADD(aStru,{"DTEMIS"	,"C", 10, 0})
AADD(aStru,{"DTVALID"	,"C", 10, 0})
AADD(aStru,{"SSD2SD3"	,"N", 16, 5})
AADD(aStru,{"SSD5"		,"N", 16, 5})
AADD(aStru,{"SSDB"		,"N", 16, 5})
AADD(aStru,{"SSDA"		,"N", 16, 5})

// Crio o arquivo de trabalho e os índices
cArqTRB := CriaTrab( aStru, .T. )
cInd1 := Left( cArqTRB, 7 ) + "1"
cInd2 := Left( cArqTRB, 7 ) + "2"
cInd3 := Left( cArqTRB, 7 ) + "3"

// Acessar o arquivo e coloca-lo na lista de arquivos abertos.
dbUseArea( .T., __LocalDriver, cArqTRB, "TRB", .F., .F. )

// Criar os índices.
IndRegua( "TRB", cInd1, "B8_PRODUTO+B8_LOTECTL+B8_LOCAL", , , "Criando índices (Produto + Lote + Armazém)...")
IndRegua( "TRB", cInd2, "B8_LOTECTL+B8_LOCAL+B8_PRODUTO", , , "Criando índices (Lote + Armazém + Produto)...")
IndRegua( "TRB", cInd3, "B8_LOCAL+B8_LOTECTL+B8_PRODUTO", , , "Criando índices (Armazém + Lote + Produto)...")

// Libera os índices.
dbClearIndex()

// Agrega a lista dos índices da tabela (arquivo).
dbSetIndex( cInd1 + OrdBagExt() )
dbSetIndex( cInd2 + OrdBagExt() )
dbSetIndex( cInd3 + OrdBagExt() )

dbSetOrder(1)

	aSldSB8 := {}
	if Select("QKAR") > 0
		dbSelectArea("QKAR")
		dbCloseArea()
	endif

	cQry :=        " SELECT QB8.B8_PRODUTO, SB1.B1_DESC, SB1.B1_UM, QB8.B8_LOTECTL, QB8.B8_LOCAL, QB8.B8_DATA, QB8.B8_DTVALID, "
	cQry += CRLF + "      QB8.B8_SALDO,  "
	cQry += CRLF + "      QQQ.SSD1 SSD1,  "
	cQry += CRLF + "      QQQ.SSD2 SSD2,  "
	cQry += CRLF + "      QQQ.SSD3 SSD3,  "
	cQry += CRLF + "      (QQQ.SSD3-(QQQ.SSD2-QQQ.SSD1)) SD1_SD2_SD3, "
	cQry += CRLF + "      QQQ.SSD5, "
	cQry += CRLF + "      QQQ.SSDB, "
	cQry += CRLF + "      QQQ.SSDA  "
	
	if mv_Par08	== 2
		cQry += CRLF + " FROM ( "
		cQry += CRLF + " SELECT QQ.*, SB9.B9_CM1 "
		cQry += CRLF + " FROM ( SELECT Q.B8_FILIAL, Q.B8_LOCAL, Q.B8_PRODUTO, Q.B8_LOTECTL, Q.B8_DTVALID, Q.B8_SALDO, Q.B8_EMPENHO, SUM(Q.SSBF) SSBF, SUM(Q.SSD4) SSD4 "
		cQry += CRLF + "        FROM (  SELECT SB8.B8_FILIAL, SB8.B8_LOCAL, SB8.B8_PRODUTO, SB8.B8_LOTECTL, SB8.B8_DTVALID, SB8.B8_SALDO, SB8.B8_EMPENHO, SUM(SBF.BF_QUANT) SSBF, 0 SSD4 "
		cQry += CRLF + "                FROM "+RetSqlName("SB8")+" SB8 "
		cQry += CRLF + "                INNER JOIN "+RetSqlName("SBF")+" SBF ON (SBF.D_E_L_E_T_    = ' '  "
		cQry += CRLF + "                                         AND SBF.BF_FILIAL  = SB8.B8_FILIAL "
		cQry += CRLF + "                                         AND SBF.BF_LOCAL   = SB8.B8_LOCAL "
		cQry += CRLF + "                                         AND SBF.BF_PRODUTO = SB8.B8_PRODUTO "
		cQry += CRLF + "                                         AND SBF.BF_LOTECTL = SB8.B8_LOTECTL "
		cQry += CRLF + "                                         ) "
		cQry += CRLF + "                WHERE SB8.D_E_L_E_T_ = ' '  "
		cQry += CRLF + "                  AND SB8.B8_LOCAL NOT IN ('12', '16', '17', '92', '95', '93') "
		cQry += CRLF + "                  AND SB8.B8_LOTECTL BETWEEN '"+cLoteIni+"' AND '"+cLoteFim+"' "
		cQry += CRLF + "                  AND SB8.B8_SALDO <> 0 "
		cQry += CRLF + "                  AND SB8.B8_DTVALID <= '"+cDtLimite+"'  "
		cQry += CRLF + "                GROUP BY SB8.B8_FILIAL, SB8.B8_LOCAL, SB8.B8_PRODUTO, SB8.B8_LOTECTL, SB8.B8_DTVALID, SB8.B8_SALDO, SB8.B8_EMPENHO  "
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
		cQry += CRLF + "                  AND SB8.B8_LOTECTL BETWEEN '"+cLoteIni+"' AND '"+cLoteFim+"' "
		cQry += CRLF + "                  AND SB8.B8_SALDO <> 0 "
		cQry += CRLF + "                  AND SB8.B8_DTVALID <= '"+cDtLimite+"' "
		cQry += CRLF + "                GROUP BY SB8.B8_FILIAL, SB8.B8_LOCAL, SB8.B8_PRODUTO, SB8.B8_LOTECTL, SB8.B8_DTVALID, SB8.B8_SALDO, SB8.B8_EMPENHO "
		cQry += CRLF + "        ) Q "
		cQry += CRLF + "        GROUP BY Q.B8_FILIAL, Q.B8_LOCAL, Q.B8_PRODUTO, Q.B8_LOTECTL, Q.B8_DTVALID, Q.B8_SALDO, Q.B8_EMPENHO "
		cQry += CRLF + "        HAVING SUM(Q.SSBF) <> 0 OR SUM(Q.SSD4)<> 0 "
		cQry += CRLF + "        ORDER BY Q.B8_FILIAL, Q.B8_LOCAL, Q.B8_PRODUTO, Q.B8_LOTECTL "
		cQry += CRLF + " ) QQ "
		cQry += CRLF + " LEFT JOIN SB9010 SB9 ON (SB9.B9_FILIAL = QQ.B8_FILIAL "
		cQry += CRLF + "                         AND SB9.B9_LOCAL = QQ.B8_LOCAL "
		cQry += CRLF + "                         AND SB9.B9_COD = QQ.B8_PRODUTO  "
		cQry += CRLF + "                         AND SB9.B9_DATA = '"+cDtFecham+"' "
		cQry += CRLF + "                         AND SB9.D_E_L_E_T_ = ' ' "
		cQry += CRLF + "                         )  "
		cQry += CRLF + " ) QFIL  "
		cQry += CRLF + " INNER JOIN "+RetSqlName("SB8")+" QB8 ON (QB8.B8_FILIAL  = QFIL.B8_FILIAL "        
		cQry += CRLF + "                                         AND QB8.B8_PRODUTO = QFIL.B8_PRODUTO "
		cQry += CRLF + "                                         AND QB8.B8_LOCAL   = QFIL.B8_LOCAL "
		cQry += CRLF + "                                         AND QB8.B8_LOTECTL = QFIL.B8_LOTECTL "
		cQry += CRLF + "                                         AND QB8.D_E_L_E_T_ = ' ' "
		cQry += CRLF + "                                         ) "
	Else	
		cQry += CRLF + " FROM "+RetSqlName("SB8")+" QB8 "        
	endif                                                                             
	
	cQry += CRLF + " INNER JOIN "+RetSqlName("SB1")+" SB1 ON (SB1.B1_FILIAL      = '"+XFilial("SB1")+"' "
	cQry += CRLF + "                           AND SB1.B1_COD     = QB8.B8_PRODUTO "
	cQry += CRLF + "                           AND SB1.D_E_L_E_T_ = ' ') "
	cQry += CRLF + " INNER JOIN (SELECT QQ.B8_PRODUTO, QQ.B8_LOTECTL, QQ.B8_SALDO, QQ.B8_LOCAL, QQ.B8_DATA, QQ.B8_DTVALID,  "
	cQry += CRLF + "                    SUM(QQ.SSD3) SSD3, "
	cQry += CRLF + "                    SUM(QQ.SSD2) SSD2, "
	cQry += CRLF + "                    SUM(QQ.SSD1) SSD1, "
	cQry += CRLF + "                    SUM(QQ.SSD5) SSD5, "
	cQry += CRLF + "                    SUM(QQ.SSDB) SSDB, "
	cQry += CRLF + "                    SUM(QQ.SSDA) SSDA "
	cQry += CRLF + "             FROM ( "
	cQry += CRLF + "                    SELECT SB8.B8_PRODUTO, SB8.B8_LOTECTL,SB8.B8_SALDO,SB8.B8_LOCAL,SB8.B8_DATA,SB8.B8_DTVALID,  "
	cQry += CRLF + "                           COALESCE(SUM(CASE WHEN SD3.D3_TM = 'MAN' OR SD3.D3_TM < '500' THEN SD3.D3_QUANT ELSE SD3.D3_QUANT*-1 END) ,0) AS SSD3, "
	cQry += CRLF + "                           0 SSD2, "
	cQry += CRLF + "                           0 SSD1, "
	cQry += CRLF + "                           0 AS SSD5, "
	cQry += CRLF + "                           0 AS SSDB, "
	cQry += CRLF + "                           0 AS SSDA "
	cQry += CRLF + "                    FROM "+RetSqlName("SB8")+" SB8 "
	cQry += CRLF + "                    INNER JOIN "+RetSqlName("SD3")+" SD3 ON (SD3.D3_FILIAL      = '"+XFilial("SD3")+"' "
	cQry += CRLF + "                                              AND SD3.D3_COD     = SB8.B8_PRODUTO "
	cQry += CRLF + "                                              AND SD3.D3_LOTECTL = SB8.B8_LOTECTL "
	cQry += CRLF + "                                              AND SD3.D3_LOCAL   = SB8.B8_LOCAL "
	cQry += CRLF + "                                              AND SD3.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "                                              AND SD3.D3_ESTORNO <>'S' ) "
	
	
//	"
//	cQry += CRLF + "                                              AND SD3.D3_CF      NOT IN ('DE4', 'RE4')
	
	cQry += CRLF + "                    WHERE SB8.B8_FILIAL  = '"+Iif(mv_Par07<=2, XFilial("SB8"), "XX")+"' AND  "
	cQry += CRLF + "                          SB8.B8_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQry += CRLF + "                          SB8.B8_LOCAL   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND  "
	cQry += CRLF + "                          SB8.B8_LOTECTL BETWEEN '"+cLoteIni+"' AND '"+cLoteFim+"' AND "
	cQry += CRLF + "                          SB8.B8_DATA    BETWEEN '"+cDtIni+"' and '"+cDtFim+"' AND  "
	cQry += CRLF + "                          SB8.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "                    GROUP BY SB8.B8_PRODUTO, SB8.B8_LOTECTL,SB8.B8_SALDO,SB8.B8_LOCAL,SB8.B8_DATA,SB8.B8_DTVALID "
	cQry += CRLF + "                    HAVING COALESCE(SUM(CASE WHEN SD3.D3_TM = 'MAN' OR SD3.D3_TM < '500' THEN SD3.D3_QUANT ELSE SD3.D3_QUANT*-1 END) ,0) <> 0 "
	cQry += CRLF + "  "
	cQry += CRLF + "                    UNION ALL "
	cQry += CRLF + "  "
	cQry += CRLF + "                    SELECT SB8.B8_PRODUTO, SB8.B8_LOTECTL,SB8.B8_SALDO,SB8.B8_LOCAL,SB8.B8_DATA,SB8.B8_DTVALID,  "
	cQry += CRLF + "                           0 AS SSD3, "
	cQry += CRLF + "                           COALESCE(SUM(SD2.D2_QUANT),0) SSD2, "
	cQry += CRLF + "                           0 AS SSD1, "
	cQry += CRLF + "                           0 AS SSD5, "
	cQry += CRLF + "                           0 AS SSDB, "
	cQry += CRLF + "                           0 AS SSDA "
	cQry += CRLF + "                    FROM "+RetSqlName("SB8")+" SB8 "
	cQry += CRLF + "                    INNER JOIN "+RetSqlName("SD2")+" SD2 ON (SD2.D2_FILIAL      = '"+XFilial("SD2")+"' "
	cQry += CRLF + "                                              AND SD2.D2_COD     = SB8.B8_PRODUTO "
	cQry += CRLF + "                                              AND SD2.D2_LOCAL   = SB8.B8_LOCAL "
	cQry += CRLF + "                                              AND SD2.D2_LOTECTL = SB8.B8_LOTECTL "
	cQry += CRLF + "                                              AND SD2.D_E_L_E_T_ = ' ') "
	cQry += CRLF + "                    WHERE SB8.B8_FILIAL  = '"+Iif(mv_Par07<=2, XFilial("SB8"), "XX")+"' AND  "
	cQry += CRLF + "                          SB8.B8_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQry += CRLF + "                          SB8.B8_LOCAL   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND  "
	cQry += CRLF + "                          SB8.B8_LOTECTL BETWEEN '"+cLoteIni+"' AND '"+cLoteFim+"' AND "
	cQry += CRLF + "                          SB8.B8_DATA    BETWEEN '"+cDtIni+"' and '"+cDtFim+"' AND  "
	cQry += CRLF + "                          SB8.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "                    GROUP BY SB8.B8_PRODUTO, SB8.B8_LOTECTL,SB8.B8_SALDO,SB8.B8_LOCAL,SB8.B8_DATA,SB8.B8_DTVALID "
	cQry += CRLF + "                    HAVING COALESCE(SUM(SD2.D2_QUANT),0) <> 0 "
	cQry += CRLF + "  "
	cQry += CRLF + "                    UNION ALL "
	cQry += CRLF + "  "
	cQry += CRLF + "                    SELECT SB8.B8_PRODUTO, SB8.B8_LOTECTL,SB8.B8_SALDO,SB8.B8_LOCAL,SB8.B8_DATA,SB8.B8_DTVALID,  "
	cQry += CRLF + "                           0 AS SSD3, "
	cQry += CRLF + "                           0 AS SSD2, "
	cQry += CRLF + "                           COALESCE(SUM(SD1.D1_QUANT),0) SSD1, "
	cQry += CRLF + "                           0 AS SSD5, "
	cQry += CRLF + "                           0 AS SSDB, "
	cQry += CRLF + "                           0 AS SSDA "
	cQry += CRLF + "                    FROM "+RetSqlName("SB8")+" SB8 "
	cQry += CRLF + "                    INNER JOIN "+RetSqlName("SD1")+" SD1 ON (SD1.D1_FILIAL      = '"+XFilial("SD1")+"' "
	cQry += CRLF + "                                              AND SD1.D1_COD     = SB8.B8_PRODUTO "
	cQry += CRLF + "                                              AND SD1.D1_LOCAL   = SB8.B8_LOCAL "
	cQry += CRLF + "                                              AND SD1.D1_LOTECTL = SB8.B8_LOTECTL "
	cQry += CRLF + "                                              AND SD1.D_E_L_E_T_ = ' ') "
	cQry += CRLF + "                    WHERE SB8.B8_FILIAL  = '"+Iif(mv_Par07<=2, XFilial("SB8"), "XX")+"' AND  "
	cQry += CRLF + "                          SB8.B8_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQry += CRLF + "                          SB8.B8_LOCAL   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND  "
	cQry += CRLF + "                          SB8.B8_LOTECTL BETWEEN '"+cLoteIni+"' AND '"+cLoteFim+"' AND "
	cQry += CRLF + "                          SB8.B8_DATA    BETWEEN '"+cDtIni+"' and '"+cDtFim+"' AND  "
	cQry += CRLF + "                          SB8.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "                    GROUP BY SB8.B8_PRODUTO, SB8.B8_LOTECTL,SB8.B8_SALDO,SB8.B8_LOCAL,SB8.B8_DATA,SB8.B8_DTVALID "
	cQry += CRLF + "  "
	cQry += CRLF + "                    UNION ALL "
	cQry += CRLF + "  "
	cQry += CRLF + "                    SELECT SB8.B8_PRODUTO, SB8.B8_LOTECTL,SB8.B8_SALDO,SB8.B8_LOCAL,SB8.B8_DATA,SB8.B8_DTVALID,  "
	cQry += CRLF + "                           0 AS SSD3, "
	cQry += CRLF + "                           0 SSD2, "
	cQry += CRLF + "                           0 SSD1, "
	cQry += CRLF + "                           COALESCE(SUM(CASE WHEN SD5.D5_ORIGLAN = 'MAN' OR SD5.D5_ORIGLAN < '500' THEN SD5.D5_QUANT ELSE SD5.D5_QUANT*-1 END),0) AS SSD5, "
	cQry += CRLF + "                           0 AS SSDB, "
	cQry += CRLF + "                           0 AS SSDA "
	cQry += CRLF + "                    FROM "+RetSqlName("SB8")+" SB8 "
	cQry += CRLF + "                    INNER JOIN "+RetSqlName("SD5")+" SD5 ON (SD5.D5_FILIAL          = '"+XFilial("SD5")+"' "
	cQry += CRLF + "                                              AND SD5.D5_PRODUTO     = SB8.B8_PRODUTO "
	cQry += CRLF + "                                              AND SD5.D5_LOCAL       = SB8.B8_LOCAL "
	cQry += CRLF + "                                              AND SD5.D5_LOTECTL     = SB8.B8_LOTECTL "
	cQry += CRLF + "                                              AND SD5.D_E_L_E_T_ = ' ') "
	cQry += CRLF + "                    WHERE SB8.B8_FILIAL  = '"+Iif(mv_Par07=1 .or. mv_Par07=3, XFilial("SB8"), "XX")+"' AND  "
	cQry += CRLF + "                          SB8.B8_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQry += CRLF + "                          SB8.B8_LOCAL   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND  "
	cQry += CRLF + "                          SB8.B8_LOTECTL BETWEEN '"+cLoteIni+"' AND '"+cLoteFim+"' AND "
	cQry += CRLF + "                          SB8.B8_DATA    BETWEEN '"+cDtIni+"' and '"+cDtFim+"' AND  "
	cQry += CRLF + "                          SB8.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "                    GROUP BY SB8.B8_PRODUTO, SB8.B8_LOTECTL,SB8.B8_SALDO,SB8.B8_LOCAL,SB8.B8_DATA,SB8.B8_DTVALID "
	cQry += CRLF + "                    HAVING COALESCE(SUM(CASE WHEN SD5.D5_ORIGLAN = 'MAN' OR SD5.D5_ORIGLAN < '500' THEN SD5.D5_QUANT ELSE SD5.D5_QUANT*-1 END),0) <> 0 "
	cQry += CRLF + "  "
	cQry += CRLF + "                    UNION ALL "
	cQry += CRLF + "  "
	cQry += CRLF + "                    SELECT SB8.B8_PRODUTO, SB8.B8_LOTECTL,SB8.B8_SALDO,SB8.B8_LOCAL,SB8.B8_DATA,SB8.B8_DTVALID,  "
	cQry += CRLF + "                           0 AS SSD3, "
	cQry += CRLF + "                           0 SSD2, "
	cQry += CRLF + "                           0 SSD1, "
	cQry += CRLF + "                           0 SSD5, "
	cQry += CRLF + "                           COALESCE(SUM(CASE WHEN DB_TM = 'MAN' OR DB_TM < '500' THEN DB_QUANT ELSE DB_QUANT*-1 END),0) AS SSDB, "
	cQry += CRLF + "                           COALESCE(SUM(SDA.DA_SALDO),0) AS SSDA "
	cQry += CRLF + "                    FROM "+RetSqlName("SB8")+" SB8 "
	cQry += CRLF + "                    LEFT JOIN "+RetSqlName("SDB")+" SDB ON (SDB.DB_FILIAL      = '"+XFilial("SDB")+"' "
	cQry += CRLF + "                                             AND SDB.DB_PRODUTO = SB8.B8_PRODUTO "
	cQry += CRLF + "                                             AND SDB.DB_LOCAL   = SB8.B8_LOCAL "
	cQry += CRLF + "                                             AND SDB.DB_LOTECTL = SB8.B8_LOTECTL "
	cQry += CRLF + "                                             AND SDB.D_E_L_E_T_ = ' ')  "
	cQry += CRLF + "                    LEFT JOIN "+RetSqlName("SDA")+" SDA ON (SDA.DA_FILIAL      = '"+XFilial("SDA")+"' "
	cQry += CRLF + "                                             AND SDA.DA_PRODUTO = SB8.B8_PRODUTO "
	cQry += CRLF + "                                             AND SDA.DA_LOCAL   = SB8.B8_LOCAL "
	cQry += CRLF + "                                             AND SDA.DA_LOTECTL = SB8.B8_LOTECTL "
	cQry += CRLF + "                                             AND SDA.DA_SALDO   > 0 "
	cQry += CRLF + "                                             AND SDA.D_E_L_E_T_ = ' ')  "
	cQry += CRLF + "                    WHERE SB8.B8_FILIAL  = '"+Iif(mv_Par07=1 .or. mv_Par07=4, XFilial("SB8"), "XX")+"' AND  "
	cQry += CRLF + "                          SB8.B8_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQry += CRLF + "                          SB8.B8_LOCAL   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
	cQry += CRLF + "                          SB8.B8_LOTECTL BETWEEN '"+cLoteIni+"' AND '"+cLoteFim+"' AND "
	cQry += CRLF + "                          SB8.B8_DATA    BETWEEN '"+cDtIni+"' and '"+cDtFim+"' AND  "
	cQry += CRLF + "                          SB8.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "                    GROUP BY SB8.B8_PRODUTO, SB8.B8_LOTECTL,SB8.B8_SALDO,SB8.B8_LOCAL,SB8.B8_DATA,SB8.B8_DTVALID "
	cQry += CRLF + "                    HAVING COALESCE(SUM(CASE WHEN DB_TM = 'MAN' OR DB_TM < '500' THEN DB_QUANT ELSE DB_QUANT*-1 END),0) <> 0) QQ "
	cQry += CRLF + "  "
	cQry += CRLF + "                    GROUP BY QQ.B8_PRODUTO, QQ.B8_LOTECTL, QQ.B8_SALDO, QQ.B8_LOCAL, QQ.B8_DATA, QQ.B8_DTVALID "
	cQry += CRLF + "                  ) QQQ ON (QQQ.B8_PRODUTO     = QB8.B8_PRODUTO "
	cQry += CRLF + "                            AND QQQ.B8_LOTECTL = QB8.B8_LOTECTL "
	cQry += CRLF + "                            AND QQQ.B8_LOCAL   = QB8.B8_LOCAL) "
	cQry += CRLF + "  "
	cQry += CRLF + " WHERE QB8.B8_FILIAL  = '"+XFilial("SB8")+"' AND  "
	cQry += CRLF + "       QB8.B8_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQry += CRLF + "       QB8.B8_LOCAL   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
	cQry += CRLF + "       QB8.B8_LOTECTL BETWEEN '"+cLoteIni+"' AND '"+cLoteFim+"' AND "
	cQry += CRLF + "       QB8.B8_DATA    BETWEEN '"+cDtIni+"' and '"+cDtFim+"' AND "
	cQry += CRLF + "       QB8.D_E_L_E_T_ = ' ' AND  "
	
	if mv_par07 == 1
		cQry += CRLF + "       (QB8.B8_SALDO<>((QQQ.SSD3-(QQQ.SSD2-QQQ.SSD1))) OR QB8.B8_SALDO<>QQQ.SSD5 OR QB8.B8_SALDO<>QQQ.SSDB) "
	elseif mv_par07 <= 2
			cQry += CRLF + "       (QB8.B8_SALDO<>((QQQ.SSD3-(QQQ.SSD2-QQQ.SSD1)))) "
	elseif mv_par07 == 3
			cQry += CRLF + "       QB8.B8_SALDO<>QQQ.SSD5 "
	else
		cQry += CRLF + "       QB8.B8_SALDO<>QQQ.SSDB "
	endif
	
	cQry += CRLF + "  "
	cQry += CRLF + " ORDER BY 1,4,6  "
	
	MemoWrite("c:\temp\QryEstoque.sql",cQry)    

	//TCQuery cQry New Alias "QKAR"
	_nRecnos := u_CountRegs(cQry,"QKAR")

	//SetRegua(_nRecnos)        
	ProcRegua(_nRecnos)
	
	do while QKAR->( !Eof() )
		//IncRegua()
		IncProc("Alimentando tabela temporária...")
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
			TRB->DTEMIS		:= DtoC(StoD(QKAR->B8_DATA))
			TRB->DTVALID	:= DtoC(StoD(QKAR->B8_DTVALID))
			TRB->SSD2SD3	:= QKAR->SD1_SD2_SD3
			TRB->SSD5		:= QKAR->SSD5
			TRB->SSDB		:= QKAR->SSDB
			TRB->SSDA		:= QKAR->SSDA
			
			TRB->( MsUnLock() )
	    endif
	    
		QKAR->( dbSkip() )
	enddo
	        
	QKAR->( dbCloseArea() )

Return({cArqTRB, cInd1, cInd2, cInd3})

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

//Troca de Lote
User Function Vit610T0()
	Processa( {|lEnd| u_Vit610T1(@lEnd)}, "Aguarde...","Corrigindo Tabelas...", .T. )
Return

User Function Vit610T1(lEnd)
Local oMark 	:= GetMarkBrow()
Local lOk       := .t.

BeginTran()

ProcRegua( Iif(Type("_nRecnos") == "U", 0, _nRecnos) )

AEval(aSldSB8, {|x| x[3] := ""})

dbSelectArea('TRB')                     
dbSetOrder(1) // Ordernar por produto para aglutinar o saldo à ser ajustado com o Kardex
dbGotop()
do while !Eof()
	if IsMark( 'OK', cMark )
		
		IncProc("Processando correção dos saldos...")
		if lEnd
			MsgInfo("Processamento interrompido.","Fim")
			lOk := .f.
			exit
		endif

		if TRB->SALDO < 0
			TRB->(dbSkip())
			loop
		endif

		if ( i := AScan(aSldSB8, {|x| x[1] == TRB->B8_PRODUTO .and. x[2] == TRB->B8_LOCAL} ) ) > 0 
			aSldSB8[i,3] := "S"
		endif           
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		MsSeek(XFilial("SB1")+TRB->B8_PRODUTO)
		
		if TRB->SSD5 <> TRB->SALDO
			if TRB->SALDO == 0
				nSaldo := TRB->SSD5
			else
				nSaldo := Round( TRB->SSD5 - TRB->SALDO , 5 )
			endif
		    
			if nSaldo <> 0
				ProcSD5(TRB->B8_PRODUTO, TRB->B8_LOCAL, nSaldo * (-1), TRB->B8_LOTECTL)
			endif
		endif
		
		if TRB->SSDB <> TRB->SALDO
			if TRB->SALDO == 0
				nSaldo := TRB->SSDB 
			else
				nSaldo := Round( TRB->SSDB - TRB->SALDO , 5 )
			endif
		    
			if nSaldo <> TRB->SSDA
				ProcSDB(TRB->B8_PRODUTO, TRB->B8_LOCAL, nSaldo * (-1), TRB->B8_LOTECTL, "TEMP")
			endif
		endif
		
		if TRB->SSD2SD3 <> TRB->SALDO
			if TRB->SALDO == 0
				nSaldo := TRB->SSD2SD3
			else
				nSaldo := Round( TRB->SSD2SD3 - TRB->SALDO , 5 )
			endif
		    
			ProcSD3(TRB->B8_PRODUTO, TRB->B8_LOCAL, nSaldo * (-1), TRB->B8_LOTECTL)
		endif

		dbSelectArea('TRB')                     
		if RecLock('TRB', .f.)
			dbDelete()
			MsUnLock()
		endif
	endif

	dbSkip()
enddo

if lOk

	if ( nRet := TCSqlExec("Commit") ) < 0
		msgAlert("Erro ao tentar salvar as transações no banco de dados.", "A t e n ç ã o")
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
	
	EndTran()
else
	DisarmTransaction()
endif
	
MarkBRefresh( )

// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()

msgAlert("Correção realizada com sucesso..")

Return()

/*****
*
* Função para pesquisar dados no arquivo temporário.
*
*/
User Function Vit610P()
Local oDlgPesq, oOrdem, oChave, oBtOk, oBtCan, oBtPar, cOrdem
Local oMark     := GetMarkBrow()
Local aOrdens 	:= {}
Local aLens     := {}
Local nOrdem 	:= 1
Local nOpcao 	:= 0
Local lExiste 	:= .f.
Local nTamTotal := TamSX3("B8_LOCAL")[1] + TamSX3("B8_LOTECTL")[1] + TamSX3("B8_PRODUTO")[1]

AAdd( aOrdens, "Produto + Lote + Armazém" )
AAdd( aOrdens, "Lote + Armazém + Produto" )
AAdd( aOrdens, "Armazém + Lote + Produto" )

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

User Function MbrFEx1()

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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCMOV    ºAutor  ³Microsiga           º Data ³  12/26/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcSD3(cProd, cAlmox, nQuant, cLoteCtl)
Local aArSB8     := SB8->(GetArea())
Local lRet       := .T.
Local cDtValid   := CtoD('  /  /  ')
Local cNumLote   := ''

if !empty(cLoteCtl)
	dbSelectArea('SB8')
	dbSetOrder(3) //-- B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
	If MsSeek(xFilial('SB8')+cProd+cAlmox+cLoteCtl+cNumLote, .F.)
		cDtValid := SB8->B8_DTVALID
	EndIf
	RestArea(aArSB8)
endif

RecLock('SD3',.T.)
Replace D3_FILIAL  With xFilial('SD3')
Replace D3_COD     With cProd
Replace D3_QUANT   With Abs(QtdComp(nQuant))
Replace D3_CF      With If(QtdComp(nQuant)<QtdComp(0),'RE0','DE0')
Replace D3_CHAVE   With If(QtdComp(nQuant)<QtdComp(0),'E0','E9')
Replace D3_LOCAL   With cAlmox
Replace D3_DOC     With 'EQUALIZA'
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
Replace D3_DTVALID With cDtValid
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCMOV    ºAutor  ³Microsiga           º Data ³  12/26/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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
		'EQUALIZA',;
		'',;
		'',;
		If(QtdComp(nQuant)<QtdComp(0),'999','499'),;
		'',;
		'',;
		'',;
		Abs(QtdComp(nQuant)),;
		ConvUm(cProd,Abs(QtdComp(nQuant)),0,2),;
		dDataBase,;
		SB8->B8_DTVALID /*dDataBase+SB1->B1_PRVALID*/})
	
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCMOV    ºAutor  ³Microsiga           º Data ³  12/26/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcSDB(cProd, cAlmox, nQuant, cLoteCtl, cLocaliz)

Local lRet       := .T.
Local aCriaSDB   := {}
Local nX         := 1

aAdd(aCriaSDB,{cProd,;
	cAlmox,;
	Abs(QtdComp(nQuant)),;
	cLocaliz,;
	'',;
	'EQUALIZA',;
	'',;
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
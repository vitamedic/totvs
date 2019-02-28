#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MATU001
	Painel de Expedição
@author Microsiga
@since 28/05/2017
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

User Function MATU001()//Vit600()
Local _afields:={}
Local _carq
Local oMarkPrivate

aRotina := {}

Private cCadastro
Private cMark:=GetMark()

aCores := {}
aAdd(aCores,{"TRB->STATUS == '1'"							, "BR_VERDE"	})
aAdd(aCores,{"TRB->STATUS == '2' .and. TRB->BLEST = ' '"	, "BR_AMARELO"	})
aAdd(aCores,{"TRB->STATUS == '2' .and. TRB->BLEST = '10'"	, "BR_MARROM"	})
aAdd(aCores,{"TRB->STATUS == '3'"							, "BR_VERMELHO"	})
aAdd(aCores,{"TRB->STATUS == '4'"							, "BR_AZUL"		})

aRotina   := {  { "Marcar Todos" 	, "U_MARCAR" 	, 0, 4},;
				{ "Desmarcar Todos" , "U_DESMAR" 	, 0, 4},;
				{ "Inverter Todos" 	, "U_MARKALL" 	, 0, 4},;
				{ "Legenda" 		, "U_MATU001L" 	, 0, 4},;
				{ "Reprocessa" 		, "U_MATU001R"	, 0, 3},;
				{ "Troca Lote" 		, "U_MATU001T"	, 0, 3}}

cCadastro := "Painel de Expedição"

if !ValidPerg()
	Return()
endif

GeraTemp()

AADD(_afields,{"OK"			,"", ""						})
AADD(_afields,{"PEDIDO"		,"", "Pedido"				})
AADD(_afields,{"ITEM"		,"", "Item"					})
AADD(_afields,{"COD"		,"", "Código"				})
AADD(_afields,{"DESC"		,"", "Descrição do Produto"	})
AADD(_afields,{"UM"			,"", "UM"					})
AADD(_afields,{"DATALIB"	,"", "Liberação"			})
AADD(_afields,{"QTDLIB"		,"", "Quantidade"			})
AADD(_afields,{"CLIENTE"	,"", "Cliente"				})
AADD(_afields,{"LOJA"		,"", "Loja"					})
AADD(_afields,{"NOME"		,"", "Nome"					})

DbSelectArea("TRB")
DbGotop()

MarkBrow( 'TRB', 'OK',,_afields,, cMark,'u_MarkAll()',,,,'u_Mark()',{|| u_MarkAll()}, , , aCores, , , ,.F.)

DbCloseArea()

// apaga a tabela temporário
MsErase(_carq+GetDBExtension(),,"DBFCDX")

Return()

User Function MATU001L()
Local aLegenda := {}

AAdd(aLegenda, {"BR_VERDE"		, "Apto a Separar e Faturar"	})
AAdd(aLegenda, {"BR_AMARELO"	, "Separado e apto a Faturar"	})
AAdd(aLegenda, {"BR_VERMELHO"	, "Faturado e apto a Separar"	})
AAdd(aLegenda, {"BR_AZUL"		, "Trocar o Lote"				})
AAdd(aLegenda, {"BR_MARROM"		, "Separado e Faturado"			})

BrwLegenda(cCadastro, "Status do Item", aLegenda)

Return()

User Function MATU001R()
Local oMark := GetMarkBrow()

if !ValidPerg()
	Return()
endif

GeraTemp()

MarkBRefresh()

u_MarkAll()

// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()

Return()

//Troca Lote
User Function MATU001T()
Local oMark := GetMarkBrow()

dbSelectArea('TRB')
dbGotop()
While !Eof()

	If IsMark( 'OK', cMark )
		
	EndIf

	dbSkip()
EndDo

MarkBRefresh( )
// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()

Return()

User Function Marcar()
Local oMark := GetMarkBrow()
DbSelectArea("TRB")
DbGotop()
While !Eof()
	IF RecLock( 'TRB', .F. )
		TRB->OK := cMark
		MsUnLock()
	EndIf
	dbSkip()
Enddo
MarkBRefresh( )
// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
return                

User Function DesMar()
Local oMark := GetMarkBrow()
DbSelectArea("TRB")
DbGotop()
While !Eof()
	IF RecLock( 'TRB', .F. )
		TRB->OK := SPACE(2)
		MsUnLock()
	EndIf
	dbSkip()
Enddo
MarkBRefresh()
// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
Return

// Grava marca no campo
User Function Mark()
If IsMark( 'OK', cMark )
	RecLock( 'TRB', .F. )
	Replace OK With Space(2)
	MsUnLock()
Else
	RecLock( 'TRB', .F. )
	Replace OK With cMark
	MsUnLock()
EndIf
Return

// Grava marca em todos os registros validos
User Function MarkAll()
Local oMark := GetMarkBrow()
dbSelectArea('TRB')
dbGotop()
While !Eof()
	u_Mark()
	dbSkip()
EndDo
MarkBRefresh( )
// força o posicionamento do browse no primeiro registro
oMark:oBrowse:Gotop()
Return

/**************************/
Static Function ValidPerg() 
/**************************/
Local aHelpPor := {}
Local cPerg    := "MATU001A  "

PutSx1(cPerg,"01",OemToAnsi("Liberação De     ?"),"","","mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"02",OemToAnsi("Liberação Até    ?"),"","","mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"03",OemToAnsi("Pedido De        ?"),"","","mv_ch3","C",06,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"04",OemToAnsi("Pedido Até       ?"),"","","mv_ch4","C",06,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"05",OemToAnsi("Cliente De       ?"),"","","mv_ch5","C",06,0,0,"G","Vazio() .or. ExistCPO('SA1')","SA1","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"06",OemToAnsi("Cliente Até      ?"),"","","mv_ch6","C",06,0,0,"G","Vazio() .or. ExistCPO('SA1')","SA1","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,{},{})
PutSx1(cPerg,"07",OemToAnsi("Status           ?"),"","","mv_ch7","N",01,0,0,"C","","","","","mv_par07","Geral","","","1","Trocar Lote","","","Apto à Separar","","","Apto à Faturar","","","","","",aHelpPor,{},{})

Return(Pergunte(cPerg,.T.))

Static Function GeraTemp()
Local cQry   	:= ""
Local aStru  	:= {}
Local _cStatus 	:= ""

if Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
endif

//ª Estrutura da tabela temporaria
AADD(aStru,{"OK"		,"C", 02, 0})
AADD(aStru,{"PEDIDO"	,"C", 06, 0})
AADD(aStru,{"ITEM"		,"C", 02, 0})
AADD(aStru,{"COD"		,"C", 15, 0})
AADD(aStru,{"DESC"		,"C", 40, 0})
AADD(aStru,{"UM"		,"C", 02, 0})
AADD(aStru,{"DATALIB"	,"C", 10, 0})
AADD(aStru,{"QTDLIB"	,"N", 16, 5})
AADD(aStru,{"CLIENTE"	,"C", 06, 0})
AADD(aStru,{"LOJA"		,"C", 02, 0})
AADD(aStru,{"NOME"		,"C", 40, 0})
AADD(aStru,{"STATUS"	,"C", 01, 0})
AADD(aStru,{"BLEST"		,"C", 02, 0})
AADD(aStru,{"BLCRED"	,"C", 02, 0})

// cria a tabela temporária
_carq:="T_"+Criatrab(,.F.)
MsCreate(_carq,aStru,"DBFCDX")
Sleep(1000)

// atribui a tabela temporária ao alias TRB
dbUseArea(.T.,"DBFCDX",_cARq,"TRB",.T.,.F.)

if !AtuZ52()
	msgAlert("Erro ao tentar limpar pedidos com liberação cancalada do painel de expedição.", "A t e n ç ã o")

else
	if mv_par07 == 2 //Geral
		_cStatus := "'4'"
	elseif mv_par07 > 2 
			_cStatus := "'1'"
	endif
	
	cQry :=        " SELECT Z52.Z52_PEDIDO "
	cQry += CRLF + "      , Z52.Z52_ITEM "
	cQry += CRLF + "      , Z52.Z52_COD "
	cQry += CRLF + "      , SB1.B1_DESC  "
	cQry += CRLF + "      , SB1.B1_UM "
	cQry += CRLF + "      , Z52.Z52_QTDLIB "
	cQry += CRLF + "      , Z52.Z52_CLIENT "
	cQry += CRLF + "      , Z52.Z52_LOJA "
	cQry += CRLF + "      , SA1.A1_NOME "
	cQry += CRLF + "      , Z52.Z52_STATUS "
	cQry += CRLF + "      , Z52.Z52_DATALI "
	cQry += CRLF + "      , Z52.Z52_BLEST "
	cQry += CRLF + "      , Z52.Z52_BLCRED "
	cQry += CRLF + " FROM "+RetSqlName("Z52")+" Z52  "
	cQry += CRLF + " INNER JOIN "+RetSqlName("SA1")+" SA1 ON (SA1.A1_FILIAL       = '"+XFilial("SA1")+"' "
	cQry += CRLF + "                           AND SA1.A1_COD      = Z52.Z52_CLIENT "
	cQry += CRLF + "                           AND SA1.A1_LOJA     = Z52.Z52_LOJA "
	cQry += CRLF + "                           AND SA1.D_E_L_E_T_  = ' '  "
	cQry += CRLF + "                          ) "
	cQry += CRLF + " INNER JOIN "+RetSqlName("SB1")+" SB1 ON (SB1.B1_FILIAL       = '"+XFilial("SB1")+"' "
	cQry += CRLF + "                           AND SB1.B1_COD      = Z52.Z52_COD "
	cQry += CRLF + "                           AND SB1.D_E_L_E_T_  = ' '  "
	cQry += CRLF + "                          ) "
	cQry += CRLF + " WHERE Z52.Z52_FILIAL  = '"+XFilial("Z52")+"' "
	cQry += CRLF + "   AND Z52.D_E_L_E_T_  = ' ' "
	cQry += CRLF + "   AND Z52.Z52_BLEST   = ' ' "
	cQry += CRLF + "   AND Z52.Z52_BLCRED  = ' ' "
	
	if !empty(mv_par01) .and. !empty(mv_par02)
		cQry += CRLF + "   AND Z52.Z52_DATALI BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
	endif
	
	if !empty(_cStatus)
		cQry += CRLF + "   AND ( Z52.Z52_STATUS = ' ' 
		cQry += CRLF + "       OR Z52.Z52_STATUS IN ("+_cStatus+") "
		cQry += CRLF + "       ) "
	endif
		
	cQry += CRLF + " ORDER BY Z52.Z52_FILIAL "
	cQry += CRLF + "        , Z52.Z52_PEDIDO "
	cQry += CRLF + "        , Z52.Z52_ITEM  "
	cQry += CRLF + " "
	
	if Select("QZ52") > 0
		dbSelectArea("QZ52")
		dbCloseArea()
	endif

	TCQuery cQry New Alias "QZ52"
	
	do while QZ52->( !Eof() )
		dbSelectArea("TRB")
		if RecLock("TRB", .t.)

			TRB->PEDIDO 	:= QZ52->Z52_PEDIDO
			TRB->ITEM 		:= QZ52->Z52_ITEM
			TRB->COD 		:= QZ52->Z52_COD
			TRB->DESC 		:= QZ52->B1_DESC
			TRB->UM 		:= QZ52->B1_UM
			TRB->DATALIB	:= DtoC(StoD(QZ52->Z52_DATALI))
			TRB->QTDLIB		:= QZ52->Z52_QTDLIB
			TRB->CLIENTE	:= QZ52->Z52_CLIENT
			TRB->LOJA 		:= QZ52->Z52_LOJA
			TRB->NOME 		:= QZ52->A1_NOME
			TRB->STATUS 	:= QZ52->Z52_STATUS
			TRB->BLEST 		:= QZ52->Z52_BLEST
			TRB->BLCRED 	:= QZ52->Z52_BLCRED
			
			TRB->( MsUnLock() )
	    endif
	    
		QZ52->( dbSkip() )
	enddo
	        
	QZ52->( dbCloseArea() )
	
endif

Return()

Static Function AtuZ52()
Local cQry   	:= ""
Local cArSC9 	:= "QSC9" //GetNextAlias()
Local aStru  	:= {}
Local nRet   	:= 0
Local _cStatus 	:= ""               

cQry :=        " DELETE FROM "+RetSqlName("Z52")+" "
cQry += CRLF + " WHERE Z52_FILIAL = '"+XFilial("Z52")+"' "
cQry += CRLF + "   AND Z52_BLEST  <> '10' "
cQry += CRLF + "   AND Z52_BLCRED <> '10' "
cQry += CRLF + "   AND D_E_L_E_T_ = ' ' "
cQry += CRLF + "   AND NOT EXISTS(SELECT * "
cQry += CRLF + "                  FROM "+RetSqlName("SC9")+" SC9 "
cQry += CRLF + "                  WHERE SC9.C9_FILIAL  = "+XFilial("SC9")+" "
cQry += CRLF + "                    AND SC9.C9_PEDIDO  = Z52_PEDIDO "
cQry += CRLF + "                    AND SC9.C9_ITEM    = Z52_ITEM "
cQry += CRLF + "                    AND (SC9.C9_BLEST       = ' ' "
cQry += CRLF + "                         AND SC9.C9_BLCRED  = ' ' "
cQry += CRLF + "                        ) "
cQry += CRLF + "                    AND SC9.D_E_L_E_T_ = ' ' "
cQry += CRLF + "                 ) "

nRet := TCSqlExec(cQry)

if nRet < 0
	msgAlert("Erro ao tentar limpar pedidos com liberação cancalada do painel de expedição.", "A t e n ç ã o")

else
	cQry :=        " SELECT SC9.* "
	cQry += CRLF + " FROM "+RetSqlName("SC9")+" SC9 "
	cQry += CRLF + " WHERE SC9.C9_FILIAL  = "+XFilial("SC9")+" "
	cQry += CRLF + "   AND SC9.C9_BLEST   = ' ' "
	cQry += CRLF + "   AND SC9.C9_BLCRED  = ' ' "
	cQry += CRLF + "   AND SC9.D_E_L_E_T_ = ' ' "
	
	if !empty(mv_par01) .and. !empty(mv_par02)
		cQry += CRLF + "   AND SC9.C9_DATALIB BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
	endif
	
	cQry += CRLF + "   AND NOT EXISTS(SELECT * "
	cQry += CRLF + "                  FROM "+RetSqlName("Z52")+" Z52 "
    cQry += CRLF + "                  WHERE Z52.Z52_FILIAL = '"+XFilial("Z52")+"' "
    cQry += CRLF + "                    AND Z52.Z52_PEDIDO = SC9.C9_PEDIDO "
    cQry += CRLF + "                    AND Z52.Z52_ITEM   = SC9.C9_ITEM "
    cQry += CRLF + "                    AND Z52.Z52_BLEST  <> '10' "
    cQry += CRLF + "                    AND Z52.Z52_BLCRED <> '10' "
    cQry += CRLF + "                    AND Z52.D_E_L_E_T_ = ' ' "
    cQry += CRLF + "                 )"
	
	if Select("QSC9") > 0
		dbSelectArea("QSC9")
		dbCloseArea()
	endif

	TCQuery cQry New Alias "QSC9"
	
	do while QSC9->( !Eof() )
		dbSelectArea("Z52")
		if RecLock("Z52", .t.)

			Z52->Z52_FILIAL 	:= XFilial("Z52")
			Z52->Z52_PEDIDO 	:= QSC9->C9_PEDIDO
			Z52->Z52_ITEM 		:= QSC9->C9_ITEM
			Z52->Z52_COD 		:= QSC9->C9_PRODUTO
			Z52->Z52_CLIENT		:= QSC9->C9_CLIENTE
			Z52->Z52_LOJA 		:= QSC9->C9_LOJA
			Z52->Z52_DATALI		:= StoD(QSC9->C9_DATALIB)
			Z52->Z52_QTDLIB		:= QSC9->C9_QTDLIB
			Z52->Z52_BLEST 		:= QSC9->C9_BLEST
			Z52->Z52_BLCRED		:= QSC9->C9_BLCRED
			Z52->Z52_STATUS 	:= '1'
			
			Z52->( MsUnLock() )
	    endif
	    
		QSC9->( dbSkip() )
	enddo
	        
	QSC9->( dbCloseArea() )
	
endif
                   


Return( nRet >= 0 )
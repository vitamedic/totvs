#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
//#INCLUDE "FINA050N.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VIT423   บ Autor ณ Ricardo Fiuza's    บ Data ณ  20/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Solicita็ใo SOPAG                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Vitapan                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VIT423()

Private cString   := "Z42"
Private cCadastro := "Solicita็ใo de Pagamento - SOPAG"
Private nOpcA     := 1
Private _cPerg    := "VIT423    "
Private wVlTot    := 0
Private wNumItem  := 0
Private aAltEnchoice := {}
Private cSeqCv4   := ""

Private aRotina := {;
{"Pesquisar"   ,"AxPesqui"     ,0,1} ,;
{"Visualizar"  ,"U_Z42Tela(1)" ,0,2} ,;
{"Incluir"     ,"U_Z42Tela(2)" ,0,3} ,;
{"Alterar"     ,"U_Z42Tela(3)" ,0,4} ,;
{"Excluir"     ,"U_Z42Tela(4)" ,0,5} ,;
{"Gerar Titulo","U_FIN050INC()",0,6} ,;
{"Legenda"     ,"U_LegZ42()"   ,0,7} ,;
{"Imprimir"    ,"U_VIT424( )"   ,0,} }


// ZA7 - Rateio CC - Folha Pgto
//ZA7_FILIAL ,C,02      // Filial
//ZA7_COD    ,C,06      // Codigo Rateio
//ZA7_DESC   ,C,40      // Descri็ใo Rateio
//ZA7_MAT    ,C,06      // Matricula
//ZA7_CC     ,C,09      // Centro Custo
//ZA7_DATA   ,D,08      // Data
//ZA7_DOC    ,C,09      // Documento
//ZA7_VLTOT  ,N,14,2    // Valor Total
//ZA7_VLUNI  ,N,14,2    // Valor Unitario
//ZA7_INDICE ,N,09,2    // Indice

Private aCores :=  {{'EMPTY(Z42_FIN)', 'BR_VERDE'},;
{ 'Z42_FIN == "S" ', 'BR_VERMELHO'}}

dbSelectArea(cString )
dbSetOrder(1)

If !Alltrim(RETCODUSR()) $ getmv("mv_sopuser") //('000004','000504','000445')
   cFiltro:= "Z42_XUSER IN ('" +RETCODUSR()+ "') " 
   mBrowse( 6, 1, 22, 75, cString,,,,,,aCores,,,,,,,,cFiltro )  
Else
   mBrowse( 6, 1, 22, 75, cString,,,,,,aCores )
EndIF


Return


//Ricardo Moreira
//MOSTRAR A LEGENDA 23/06/15
User function LegZ42()

aLegenda := {{'BR_VERDE', "Nใo Financeiro"},;
{'BR_VERMELHO', "Financeiro"}}
BRWLEGENDA(cCadastro, "Legenda", aLegenda)
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ ZA7Tela  บAutor  ณRicardo Fiuza       บ Data ณ  01/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a tela Modelo 3                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Z42Tela(nOpc)



//Local nX, lRet   := ""
Private nX       := 0
Private lRet     := .T.
Private nOpcE    := 3, nOpcG := 3, N := 0
Private aHeader  := {}, aCols := {}, aCpo := {},aBtn := {}
Private oTela    := nil, oLBox1 := nil, cCod := ""
Private _cSop    := ""


//Private _cCodigo := ZA7->ZA7_COD

dbSelectArea(cString )
dbSetOrder(1)

DO CASE
	CASE nOpc == 1 ; nOpcE:=2 ; nOpcG:=2 // Visualiza
	CASE nOpc == 2 ; nOpcE:=3 ; nOpcG:=3 // Inclui
	CASE nOpc == 3 ; nOpcE:=3 ; nOpcG:=3 // Altera
	CASE nOpc == 4 ; nOpcE:=2 ; nOpcG:=2 // Exclui
ENDCASE


dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cString)
//campos que nao aparecem no acols, ou seja, nao aparecem para preenchimento nos itens
DO WHILE !SX3->( EOF() ) .And. SX3->X3_ARQUIVO == cString
	IF !X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. !(Trim(SX3->X3_CAMPO)$"Z42_FILIAL,Z42_NUM,Z42_EMISS,Z42_VENCIM,Z42_CODFOR,Z42_LOJA,Z42_NOMEFO,Z42_VALOR,Z42_HISTOR,Z42_OBS,Z42_TIPO,Z42_NATURE,Z42_RATEIO,Z42_ARQRAT,Z42_FIN,Z42_XUSER")
		//	IF cNivel >= SX3->X3_NIVEL .AND. !(Trim(SX3->X3_CAMPO)$"ZA7_FILIAL ,ZA7_COD,ZA7_DESC,ZA7_DATA")
		aAdd(aHeader,{allTrim(X3_TITULO), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT})
	ENDIF
	dbSkip()
ENDDO

regToMemory(cString,nOpc==2)

// nOpc for igual a 1 = Visualiza; 2 = Inclui; 3 = Altera; 4 = Exclui
If nOpc == 2 // Incluir
	
	
	aAdd(aCols,array(len(aHeader)+1))
	N := Len(aCols)
	
	FOR i := 1 to len(aHeader)
		aCols[1][i] := criaVar(aHeader[i][2])
	NEXT
	
	//	aCols[1][1] := "001"  // INICIA O ITEM COM 001
	
	aCols[1][len(aHeader)+1] := .F.
Else
  //*******************************************************************************
  // Bloqueia altera็ao das SOPAG com titulo Financeiro chamado 005922
  //*******************************************************************************
   DbSelectArea("SE2")
   DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
	IF nOpc == 3 .and. !EMPTY(Z42->Z42_FIN) .and. dbSeek(xFilial("SE2")+"SOP"+SUBSTR(M->Z42_NUM,2,10))
		MSGINFO("Nใo e Possivel Alterar SOPAG !" + Chr(13) + Chr(10) + "Solicite a exclusใo do tํtulo no Financeiro!","SOPAG -"+ M->Z42_NUM)
	 	SE2->(DBCLOSEAREA())
	 	return .f.
	ELSE
		Do While ! eof() .AND. Z42_FILIAL + Z42_NUM = xFilial("Z42") + M->Z42_NUM .AND. !EMPTY(Z42->Z42_FIN) .and. nOpc == 3
			recLock("Z42",.F.)
			Z42->Z42_FIN = ""
			msUnlock()
			dbSkip()
		ENDDO
		
	cCod := Z42->Z42_NUM
	DbSelectArea("Z42")
	DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
	dbSeek(xFilial("Z42")+cCod)
	n := 0
	DO WHILE !Z42->( EOF() ) .And. Z42->Z42_FILIAL+Z42->Z42_NUM == xFilial("Z42")+cCod
		aAdd(aCols,array(len(aHeader)+1))
		N++
		FOR i := 1 to len(aHeader)
			aCols[N][i] := IIF(aHeader[i][10]#"V",fieldGet(fieldPos(aHeader[i][2])),criaVar(aHeader[i][2],.T.))
		NEXT
		
		aCols[N][len(aHeader)+1] := .F.
		Z42->( dbSkip() )
	ENDDO
	
	Z42->(DbGoTop())
	Z42->(dbSeek(xFilial("Z42")+cCod) )
	Endif
	SE2->(DBCLOSEAREA())	
ENDIF

// aCpo : Recebe os campos que ficarao prontos para editar
//aAdd(aCpo,"Z42_DOC"	    )
aAdd(aCpo,"Z42_EMISSA"	)
aAdd(aCpo,"Z42_VENCIM" 	)
aAdd(aCpo,"Z42_CODFOR" 	)
aAdd(aCpo,"Z42_NOMEFO" 	)
aAdd(aCpo,"Z42_VALOR"   )
aAdd(aCpo,"Z42_HISTOR"  )
aAdd(aCpo,"Z42_OBS"     )
aAdd(aCpo,"Z42_TIPO"    )
aAdd(aCpo,"Z42_NATURE"  )
aAdd(aCpo,"Z42_RATEIO"  )

aAdd( aBtn, { 'COMPREL', {|| iif(Z42_RATEIO == 'S',U_ImpRat(),msgstop("Sopag sem Rateio")) }, 'Imp. Rateio', 'Imp. Rateio' } )
aAdd( aBtn, { 'COMPREL', {|| iif(Z42_RATEIO == 'S',U_RatVL(),msgstop("Sopag sem Rateio")) }, 'Alt. Rateio', 'Alt. Rateio' } )
//campos nao sao preenchidos na inclusao
//aAdd(aCpo,"Z7_DATAP"		)
//aAdd(aCpo,"Z7_RECEBEU"	)

n := 1 //linha 1 do acols

If nOpc == 2 .or. nOpc == 3// Inclui   //Altera
	aAltEnchoice := aClone(aCpo) //libera os campos do aCpo
EndIf
	//Elseif (Substr(embaralha(ZA7->Z7_USERLGI,1),1,15) == substr(cusuario,7,15)) //Se o usuario for o mesmo que incluiu o registro
	//Elseif (Substr(Z7_USERLGA,1,15) == substr(cusuario,7,15)) //Se o usuario for o mesmo que incluiu o registro
	//libera todos os campos que nao estao no item
	//aAltEnchoice := aClone(aCpo)
	//aAdd(aAltEnchoice,"Z7_DATAP")
	//aAdd(aAltEnchoice,"Z7_RECEBEU")
//Else //se for alteracao e o usuario nao e o dono do registro ele so altera os dois campos abaixo
	//aAltEnchoice := {"Z7_DATAP","Z7_RECEBEU"}     
	//aAltEnchoice := aClone(aCpo)
//EndIf

aSizeAut := msAdvSize()
aObjects := {}
aAdd( aObjects, { 315, 130, .T., .T. } )

aCordW := {aSizeAut[7], 000, aSizeAut[6], aSizeAut[5]}
nSizeHeader := 120 //110

//cria a tela

nOpcA := nOpc
_cSop := M->Z42_NUM // Op็ao de Impressao de rateio 20/03/2017
// Altera็ao de SOPAG com Rateio 
//if nOpc == 3 .and. Z42_RATEIO=="S" 
//	if !MSGYESNO("SOPAG com Rateio !!" + Chr(13) + Chr(10) + "Tem certeza que deseja alterar !?",_cSop + "- SOPAG COM RATEIO!")
//	 Return .F.
//	endif
//	u_RatVL()
//ENDIF
  
lRet := Modelo3("Cabecalho","Z42","Z42",aCpo,"u_ValZ42ok()","AllwaysTrue()",nOpcE,nOpcG,"AllwaysTrue()",,999, aAltEnchoice,,aBtn,aCordW,nSizeHeader)

If lRet
	DO CASE
		//======================================================================================================
		// INCLUI
		//======================================================================================================
		CASE nOpc == 2
			wVlTot   := 0
			
			FOR i := 1 TO len(aCols)
				IF !aCols[i][len(aHeader) + 1] //Nao deixa incluir mais itens do que a quantidade de campos no cabecalho							
					
					IF recLock("Z42",.T.)
						//Grava os campos que nao fazem parte do item
						Z42->Z42_FILIAL  := xFilial("Z42")
						Z42->Z42_NUM     := M->Z42_NUM
						Z42->Z42_EMISSA  := M->Z42_EMISSA
						Z42->Z42_VENCIM  := M->Z42_VENCIM
						Z42->Z42_CODFOR  := M->Z42_CODFOR
						Z42->Z42_LOJA    := M->Z42_LOJA
						Z42->Z42_NOMEFO  := M->Z42_NOMEFO
						Z42->Z42_VALOR   := M->Z42_VALOR
						Z42->Z42_HISTOR  := M->Z42_HISTOR
						Z42->Z42_OBS     := M->Z42_OBS
						Z42->Z42_TIPO    := M->Z42_TIPO
						Z42->Z42_NATURE  := M->Z42_NATURE
						Z42->Z42_RATEIO  := M->Z42_RATEIO
						Z42->Z42_ARQRAT  := xFilial("Z42")+DTOS(M->Z42_EMISSA)+M->Z42_NUM
					    Z42->Z42_XUSER   := RETCODUSR()                                                                                                                     	
						
						//Grava os campos que fazem parte do item
						FOR nX := 1 TO len(aHeader)
							fieldPut(fieldPos(allTrim(aHeader[nX][2])),aCols[i][nX])
							if allTrim(aHeader[nX][2]) = "Z42_VALORR"
								wVlTot := wVlTot + aCols[i][nX]
							endif
						NEXT
						Z42->( msUnlock() )
					ENDIF
				ENDIF
			NEXT
			
			wNumItem := 0
			DbSelectArea("Z42")
			DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
			dbSeek(xFilial("Z42")+M->Z42_NUM)
			Do While Z42->(!eof()) .AND. Z42_FILIAL + Z42_NUM = xFilial("Z42") + M->Z42_NUM
				wNumItem := wNumItem + 1
				recLock("Z42",.F.)
				Z42->Z42_ITEM    := strzero(wNumItem,4,0)
				Z42->Z42_VALOR   := wVlTot
				Z42->Z42_POR  := (Z42_VALORR / wVlTot) * 100
				msUnlock()
				dbSkip()
			ENDDO
			///ALTERAวรO RICARDO 16/06/2015 TELA PRA INCLUIR NA
			//If MsgYesNo("Deseja Gravar esse SOPAG no Contas a Pagar","ATENวรO")
			//  Processa({|| AddCPg()})
			//Else
			// MSGINFO("SOPAG nใo Inserido no Contas a Pagar")
			//EndIf
			
			//Grava o proximo numero do codigo
			//======================================================================================================
			// ALTERA
			//======================================================================================================
		CASE nOpc == 3
		BEGIN TRANSACTION
			// Deleta os registros existentes
			//_cQry := " DELETE FROM "+RetSQLName("ZA7")
			//_cQry += " WHERE ZA7_FILIAL  = '"+xFilial("ZA7")+"'"
			//_cQry += " AND ZA7_DOC = '" + M->ZA7_DOC+"'"
			//tcSQLExec(_cQry)
			//tcSQLExec("COMMIT")  // Oracle
			//sysrefresh()
			
			// Altera็ao de SOPAG com Rateio 
			if nOpc == 3 .and. m->Z42_RATEIO=="S" 
				//if !MSGYESNO("SOPAG com Rateio !!" + Chr(13) + Chr(10) + "Tem certeza que deseja alterar !?",_cSop + "- SOPAG COM RATEIO!")
				// Return .F.
				//endif
				u_RatVL()
			Endif
			DbSelectArea("Z42")
			DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
			dbSeek(xFilial("Z42")+M->Z42_NUM)
			Do While ! eof() .AND. alltrim(Z42_NUM) = alltrim(M->Z42_NUM)
				recLock("Z42",.F.)
				Z42->( dbDelete() )
				msUnlock()
				dbSkip()
			ENDDO
						
			wVlTot   := 0
			FOR i := 1 TO len(aCols)
				IF !aCols[i][len(aHeader) + 1]   // SE O REGISTRO DO ACOLS ESTA DELETADO NAO ENTRA
					wNumItem := wNumItem + 1
					aCols[i][1]  := strzero(wNumItem,4,0)
					recLock("Z42",.T.)
						//Cabecalho
						Z42->Z42_FILIAL  := xFilial("Z42")
						Z42->Z42_NUM     := M->Z42_NUM
						Z42->Z42_EMISSA  := M->Z42_EMISSA
						Z42->Z42_VENCIM  := M->Z42_VENCIM
						Z42->Z42_CODFOR  := M->Z42_CODFOR
						Z42->Z42_LOJA    := M->Z42_LOJA
						Z42->Z42_NOMEFO  := M->Z42_NOMEFO
						Z42->Z42_VALOR   := M->Z42_VALOR
						Z42->Z42_HISTOR  := M->Z42_HISTOR
						Z42->Z42_OBS     := M->Z42_OBS
						Z42->Z42_TIPO    := M->Z42_TIPO
						Z42->Z42_NATURE  := M->Z42_NATURE
						Z42->Z42_RATEIO  := M->Z42_RATEIO
						Z42->Z42_ARQRAT  := xFilial("Z42")+DTOS(M->Z42_EMISSA)+M->Z42_NUM
				       Z42->Z42_XUSER   := RETCODUSR()                                                                                                                     	
						//Itens
						FOR nX := 1 TO len(aHeader)
							fieldPut( fieldPos(  allTrim(aHeader[nX][2])) , aCols[i][nX] )
							if allTrim(aHeader[nX][2]) = "Z42_VALORR"
								wVlTot := wVlTot + aCols[i][nX]
							endif
						NEXT
						Z42->( msUnlock() )
					ENDIF
//				ENDIF
			NEXT
			
			wNumItem := 0
			DbSelectArea("Z42")
			DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
			dbSeek(xFilial("Z42")+M->Z42_NUM)
			Do While Z42->(!eof()) .AND. alltrim(Z42_NUM) = alltrim(M->Z42_NUM)
				wNumItem := wNumItem + 1
				recLock("Z42",.F.)
				Z42->Z42_ITEM    := strzero(wNumItem,4,0)
				Z42->Z42_VALOR  := wVlTot
				Z42->Z42_POR    := (Z42_VALORR / wVlTot) * 100	
				msUnlock()
				dbSkip()
			ENDDO
			END TRANSACTION
			//======================================================================================================
			// EXCLUI
			//======================================================================================================
		CASE nOpc == 4
			BEGIN TRANSACTION
			
			DbSelectArea("SE2")
			DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
			dbSeek(xFilial("SE2")+"SOP"+SUBSTR(M->Z42_NUM,2,10))
			Do While ! SE2->(eof()) .AND. E2_FILIAL +E2_PREFIXO+E2_NUM = xFilial("Z42")+"SOP"+SUBSTR(M->Z42_NUM,2,10)
				If SE2->E2_SALDO < M->Z42_VALOR
					MSGINFO("Titulo Baixado, SOPAG nใo pode ser excluํda!!!!")
					Return
				Else
					recLock("SE2",.F.)
					SE2->( dbDelete() )
					msUnlock()
					dbSkip()
				EndIf
			ENDDO
			
			DbSelectArea("CV4")
			DbSetOrder(1)
			dbSeek( xFilial("CV4") + DTOS(M->Z42_EMISSA) + substr(M->Z42_ARQRAT,11,10) )
			Do While ! CV4->(eof()) .AND. CV4_FILIAL = xFilial("CV4") .AND. CV4_DTSEQ = M->Z42_EMISSA .AND. CV4_SEQUEN = substr(M->Z42_ARQRAT,11,10)
				recLock("CV4",.F.)
				CV4->( dbDelete() )
				msUnlock()
				dbSkip()
			ENDDO
			
			DbSelectArea("Z42")
			DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
			dbSeek(xFilial("Z42")+M->Z42_NUM)
			Do While ! Z42->(eof()) .AND. Z42_FILIAL + Z42_NUM = xFilial("Z42") + M->Z42_NUM
				recLock("Z42",.F.)
				Z42->( dbDelete() )
				msUnlock()
				dbSkip()
			ENDDO
			
			END TRANSACTION
			
	ENDCASE
ENDIF

dbSelectArea("Z42")
dbSetOrder(1)

Return ()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Funcao para validacao dos imput dos itens                           |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function ValZ42ok()

Local lRet 		:= .t.
//Local nPosDesc  := 0
//Local nPos 		:= 0
/*
IF nOpcA  = 2 // INCLUSรO //aCols[i][nX]
	if aCols[i][nX] > 0 //.or.;
		MsgAlert("Por favor informar o Valor do Rateio !! ")
		lRet := .f.
	endif
Endif
*/

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ RICARDO FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO CHAMADA PELO SX3 DO CAMPO Z7_ITEM (SEQUENCIAL)      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FItemZ4(cCampo)

Local nPos := 0
Local nLin := N
Local cRet := ""

Default cCampo  := "Z42_ITEM"

cRet := StrZero(nLin , 3) //PREENCHE O VALOR DO ITEM

Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ RICARDO FIUZA                     16/06/2015               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ AddCPg - FUNCAO CHAMADA PARA ADD NA TABELA SE2             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FIN050INC()
Local aArray := {}
Local _doc   := Z42->Z42_NUM

Local nTotal		:=0
Local nHdlPrv		:=0
Local cArquivo

PRIVATE STRLCTPAD  := 0


PRIVATE lMsErroAuto := .F.

If EMPTY(Z42->Z42_FIN)
	
	aArray := { ;
	{ "E2_FILIAL"   , xFilial("Z42")    , NIL },;
	{ "E2_PREFIXO"  , "SOP"             , NIL },;
	{ "E2_NUM"      , substr(Z42->Z42_NUM,2,10), NIL },;
	{ "E2_TIPO"     , Z42->Z42_TIPO     , NIL },;
	{ "E2_NATUREZ"  , Z42->Z42_NATURE   , NIL },;
	{ "E2_FORNECE"  , Z42->Z42_CODFOR   , NIL },;
	{ "E2_LOJA"  	, Z42->Z42_LOJA     , NIL },;
	{ "E2_NOMFOR"   , Z42->Z42_NOMEFO   , NIL },;
	{ "E2_EMISSAO"  , Z42->Z42_EMISSA   , NIL },;
	{ "E2_VENCTO"   , Z42->Z42_VENCIM   , NIL },;
	{ "E2_VENCTO"   , Z42->Z42_VENCIM   , NIL },;
	{ "E2_VENCORI"  , Z42->Z42_VENCIM   , NIL },;
	{ "E2_CC"       , Z42->Z42_CCUSTO   , NIL },;
	{ "E2_RATEIO"   , Z42->Z42_RATEIO   , NIL },;
	{ "E2_ARQRAT"   , Z42->Z42_ARQRAT   , NIL },;
	{ "E2_ORIGEM"   , "FINA050"          , NIL },;
	{ "E2_VLCRUZ"   , Z42->Z42_VALOR    , NIL },;
	{ "E2_SALDO"    , Z42->Z42_VALOR    , NIL },;
	{ "E2_VALOR"    , Z42->Z42_VALOR    , NIL },;
	{ "E2_HIST"     , SUBSTR(Z42->Z42_HISTOR,1,25)    , NIL } } // GRAVAR HISTORICO NO TITULO FINANCEIRO POR KYONE CHAMADO 005922
	
	
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Altera็ใo, 5 - Exclusใo
	
	If lMsErroAuto
		MostraErro()
	Else
		
		// Roberto Fiuza 29/06/15 Rateio CC
		IF ! EMPTY(Z42->Z42_ARQRAT)
			DbSelectArea("SE2")
			DbSetOrder(1)  // Z42_FILIAL +  Z42_NUM
			dbSeek(xFilial("SE2")+"SOP"+SUBSTR(Z42->Z42_NUM,2,10))
			if ! eof()
				recLock("SE2",.F.)
				SE2->E2_ARQRAT := Z42->Z42_ARQRAT         
				SE2->E2_LA     := "S"
				msUnlock()
				IF VerPadrao("511")
					DbSelectArea("CV4")
					DbSetOrder(1)
					dbSeek( xFilial("CV4") + DTOS(Z42->Z42_EMISSA) + substr(Z42->Z42_ARQRAT,11,10) )
					Do While ! eof() .AND. CV4_FILIAL = xFilial("CV4") .AND. CV4_DTSEQ = Z42->Z42_EMISSA .AND. CV4_SEQUEN = substr(Z42->Z42_ARQRAT,11,10)
						VALOR   := CV4_VALOR
						DEBITO  := CV4_DEBITO
						CREDITO := CV4_CREDIT
						CUSTOC  := CV4_CCC
						CUSTOD  := CV4_CCD
						If nHdlPrv <= 0
							nHdlPrv:=HeadProva("008850","VIT423",Substr(cUsuario,7,6),@cArquivo)
						Endif
						nTotal+=DetProva(nHdlPrv,"511","VIT423","008850")
						DbSelectArea("CV4")
						dbSkip()
					ENDDO
				Endif
			Endif
			IF nTotal > 0
				RodaProva(nHdlPrv,nTotal)
				lDigita:=.T. // sempre mostra contabilizacao
				cA100Incl(cArquivo,nHdlPrv,3,"008850",lDigita,.F.)
			ENDIF
		ENDIF
		
		Alert("Tํtulo incluํdo com sucesso!")
	Endif
	
	While !Z42->(Eof()) .and. _doc == Z42->Z42_NUM
		recLock("Z42",.F.)
		Z42->Z42_FIN    := "S"
		//		Z42->Z42_ARQRAT := xFilial("Z42")+DTOS(Z42->Z42_EMISSA)+cSeqCv4
		msUnlock()
		Z42->(dbSkip())
	Enddo
	Z42->(DBCLOSEAREA())
	
ELSE
	Msginfo("Sopag ja inserido no financeiro")
EndIf

Return


///////////// TELA DO RATEIO ...... --- INICIO

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ RICARDO FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO CHAMADA PELO SX3 DO Z42_RATEIO   				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RatVL


Local btnCancelar
Local btnSalvar
Local grpSopag

Local lblLoja
Local lblNomeFor
Local lblSopag
Local lblValor           
Local lblVlTit

Local cxtLoja    := M->Z42_LOJA
Local cxtNomeFor := M->Z42_CODFOR +"/"+M->Z42_NOMEFO
Local cxtSopag   := M->Z42_NUM
Local cxtValor   := M->Z42_VALOR
Local cxtVlTit   := M->Z42_VALOR

Local txtLoja
Local txtNomeFor
Local txtSopag
Local txtValor
Local txtVlTit


Local i := 1

Private aHeaderEx	 := {}
private aColsEx      := {}
private aFieldFill   := {}
private aFields      := {}
private aAlterFields := {}
private grdDados     := {}
Private wContext  	 := " "
Private wCBox     	 := " "
Private wRelacao  	 := " " 
Private cxtVlRat     := 0 //:= M->Z42_VALOR 
Private txtVlRat
Private lblVlRat           

Static odlPrincipal

DEFINE MSDIALOG odlPrincipal TITLE "Rateio do Centro de Custo" FROM -049, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

@ 005, 000 GROUP grpSopag TO 70, 500 PROMPT "Dados do SOPAG" OF odlPrincipal COLOR 0, 16777215 PIXEL


@ 020, 010 SAY 		lblSopag 		PROMPT "SOPAG" 	    SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 			PIXEL
@ 018, 041 MSGET 	txtSopag 		VAR cxtSopag 		SIZE 055, 010 OF odlPrincipal COLORS 0, 16777215 READONLY 	PIXEL
@ 020, 194 SAY 		lblValor 		PROMPT "Valor" 	    SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 			PIXEL
@ 018, 215 MSGET 	txtValor	    VAR cxtValor 		SIZE 040, 010 OF odlPrincipal COLORS 0, 16777215 READONLY 	PIXEL  Picture "@E 999,999,999.99"
@ 038, 010 SAY 		lblNomeFor 		PROMPT "Fornecedor" SIZE 036, 007 OF odlPrincipal COLORS 0, 16777215 			PIXEL
@ 036, 041 MSGET 	txtNomeFor 		VAR cxtNomeFor 		SIZE 141, 010 OF odlPrincipal COLORS 0, 16777215 READONLY 	PIXEL
@ 038, 194 SAY 		lblLoja 		PROMPT "Loja" 		SIZE 025, 007 OF odlPrincipal COLORS 0, 16777215 			PIXEL
@ 036, 215 MSGET 	txtLoja 		VAR cxtLoja 		SIZE 033, 010 OF odlPrincipal COLORS 0, 16777215 READONLY 	PIXEL

DadosRt() 
//carregaGrid(strzero(i,8,0),cod,desc)

@ 235, 010 SAY 		lblVlTit 		PROMPT "Valor SOPAG:" 	    SIZE 045, 025 OF odlPrincipal COLORS   0, 16777215 		     	PIXEL
@ 235, 050 SAY 		txtVlTit 		VAR  cxtVlTit	    SIZE 035, 025 OF odlPrincipal COLORS   255, 16777215 		     	PIXEL Picture "@E 999,999,999.99"

@ 235, 194 SAY 		lblVlRat 		PROMPT "Valor Rateio:" 	    SIZE 045, 025 OF odlPrincipal COLORS   0, 16777215 		     	PIXEL
@ 235, 234 SAY 		txtVlRat 		VAR  cxtVlRat	    SIZE 035, 025 OF odlPrincipal COLORS   255, 16777215 		     	PIXEL Picture "@E 999,999,999.99"


@ 240, 400 BUTTON btnSalvar PROMPT "Salvar" SIZE 037, 012 OF odlPrincipal ACTION salvar() PIXEL
@ 240, 450 BUTTON btnCancelar PROMPT "Cancelar" SIZE 037, 012 OF odlPrincipal ACTION iif(MsgYesNo("Valores do Rateio nao foram Salvos !"+ chr(13)+"Deseja Cancelar ?" ,"Aten็ใo"),CLOSE(odlPrincipal),) PIXEL

ACTIVATE MSDIALOG odlPrincipal CENTERED

Return

////Cria a Grid

Static Function DadosRt()

private nX := 0

Static odlPrincipal

aFields := {"dbDebito","dbCredit","dbValor","dbCCDeb","dbCCCre"}

aAlterFields := {"dbDebito","dbCredit","dbValor","dbCCDeb","dbCCCre"}

AADD(aHeaderEx,{"Conta Debito"    	,"dbDebito"      ,"@!"          		, 15 ,0 , "ExistCpo('CT1')"       ,"๛"   ,"C", "CT1"  , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Conta Credit"    	,"dbCredit"      ,"@!"          		, 15 ,0 , "ExistCpo('CT1')"       ,"๛"   ,"C", "CT1"  , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"Valor"             ,"dbValor"       ,"@E 999,999,999.99" 	, 15 ,2 , "u_validar('dbValor')"  ,"๛"   ,"N", 	      , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"CC Debito"    		,"dbCCDeb"       ,"@!"          		, 12 ,0 , "ExistCpo('CTT')"       ,"๛"   ,"C", "CTT"  , wContext ,wCBox, wRelacao })
AADD(aHeaderEx,{"CC Credito"    	,"dbCCCre"       ,"@!"          		, 12 ,0 , "ExistCpo('CTT')"       ,"๛"   ,"C", "CTT"  , wContext ,wCBox, wRelacao })

//Limpa varivaeis da grid
aFieldFill := {}
aColsEx    := {}


//Preenche a Grid do Rateio quando tem dados
//*****************************************************************
// Quando existir rateio para o titulo mostrar na grid
//*****************************************************************
Dbselectarea("CV4")
dbsetorder(1)
if dbSeek( xFilial("CV4") + DTOS(M->Z42_EMISSA) + substr(M->Z42_ARQRAT,11,10) )
	Do While ! eof() .AND. CV4_FILIAL = xFilial("CV4") .AND. CV4_DTSEQ = M->Z42_EMISSA .AND. CV4_SEQUEN = substr(M->Z42_ARQRAT,11,10)
 		AADD(aColsEx,{alltrim(CV4->CV4_DEBITO),alltrim(CV4->CV4_CREDIT),CV4->CV4_VALOR,alltrim(CV4->CV4_CCD),alltrim(CV4->CV4_CCC),.F.})
 		cxtVlRat += CV4->CV4_VALOR
 		recLock("CV4",.F.)
//		CV4->( dbDelete())
		msUnlock()
 		dbSkip()
	ENDDO
Endif
dbclosearea()

//Chama fun็ใo para montar a grid
grdDados  := MsNewGetDados():New( 074, 003, 220, 500, GD_INSERT + GD_UPDATE + GD_DELETE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 9999, "AllwaysTrue", "", "AllwaysTrue", odlPrincipal, @aHeaderEx, @aColsEx)
Return



//-----------------------------------------------
//Fun็ใo para preencher grid na tela
//-----------------------------------------------
/*
static function carregaGrid(cod,desc)
Local cIRD 	:= space(22)
Local cDesc := POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD+SD1->D1_ITEM,"B1_DESC")
Local cCod  := POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD+SD1->D1_ITEM,"B1_COD")

for i:= 1 to cxtQuant //cxtItem
cIRD 	:= POSICIONE("SZ3",8,XFILIAL("SZ3")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_ITEM+SD1->D1_COD+CVALTOCHAR(STRZERO(I,4)),"Z3_COD")
gCodBar := IIF(cIRD <> " ", cIRD,space(22))
desc 	:= cDesc
cod  	:= cCod
//Aadd(aColsEx, {space(22),strzero(i,4,0),cod,desc,.F.})
wQtdAP 	:= IIF(cIRD <> " ",wQtdAP + 1,wQtdAP + 0)  // Contar a Quantidade de IRD jแ inserido
Aadd(aColsEx, {gCodBar,strzero(i,4,0),cod,desc,.F.})
grdDados:SetArray(aColsEx,.T.)
grdDados:Refresh()
next

return
*/

//-----------------------------------------------
//Fun็ใo para GRAVAR NA TABELA CV4
//-----------------------------------------------

Static Function salvar()

Local  _perc := 0

For i:= 1 to len(grddados:aCols)  
  	  If !(grdDados:aCols[i] [Len(aHeaderEx)+1])  //linha deletada 
         DbSelectArea("CV4")
	     DbSetOrder(1)	
	     _perc :=round((grdDados:aCols[i,3] *100)/M->Z42_VALOR,2)		   
			RECLOCK("CV4",.T.)
			CV4->CV4_FILIAL := xFilial("CV4")
			CV4->CV4_SEQUEN := M->Z42_NUM
			CV4->CV4_DTSEQ  := M->Z42_EMISSA
			CV4->CV4_DEBITO := grdDados:aCols[i,1]
			CV4->CV4_CREDIT := grdDados:aCols[i,2]
			CV4->CV4_PERCEN := _perc
			CV4->CV4_VALOR  := grdDados:aCols[i,3]
			CV4->CV4_HIST   := M->Z42_HISTOR
			CV4->CV4_CCC    := grdDados:aCols[i,5]
			CV4->CV4_CCD    := grdDados:aCols[i,4]
			CV4->CV4_ITSEQ  := STRZERO(i,6)	
			MSUNLOCK() 
	  EndIF
 Next i      
 
//MsgInfo("Registros inseridos com sucesso!!!")
_cSop := M->Z42_NUM
//odlPrincipal:End()
///ALTERAวรO RICARDO 16/06/2015 TELA PRA INCLUIR NA
If MsgYesNo("Deseja imprimir o Rateio ? ","ATENวรO")	
	Processa({|| U_ImpRat()})
Else
	//MSGINFO("Rateio nใo serแ impresso !!!")
EndIf
Close(odlPrincipal)
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ Ricardo FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO _pergsx1                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function _pergsx1()

_agrpsx1:={}

aadd(_agrpsx1,{_cperg,"01","Documento             ?","mv_ch1","C",09,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Data                  ?","mv_ch2","D",08,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Cod. Rateio           ?","mv_ch3","C",06,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"Z7 "})
aadd(_agrpsx1,{_cperg,"04","Valor                 ?","mv_ch4","N",14,2,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","NF                    ?","mv_ch5","C",10,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})

for _i:=1 to len(_agrpsx1)
	if ! sx1->(dbseek(_agrpsx1[_i,1]+_agrpsx1[_i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[_i,01]
		sx1->x1_ordem  :=_agrpsx1[_i,02]
		sx1->x1_pergunt:=_agrpsx1[_i,03]
		sx1->x1_variavl:=_agrpsx1[_i,04]
		sx1->x1_tipo   :=_agrpsx1[_i,05]
		sx1->x1_tamanho:=_agrpsx1[_i,06]
		sx1->x1_decimal:=_agrpsx1[_i,07]
		sx1->x1_presel :=_agrpsx1[_i,08]
		sx1->x1_gsc    :=_agrpsx1[_i,09]
		sx1->x1_valid  :=_agrpsx1[_i,10]
		sx1->x1_var01  :=_agrpsx1[_i,11]
		sx1->x1_def01  :=_agrpsx1[_i,12]
		sx1->x1_cnt01  :=_agrpsx1[_i,13]
		sx1->x1_var02  :=_agrpsx1[_i,14]
		sx1->x1_def02  :=_agrpsx1[_i,15]
		sx1->x1_cnt02  :=_agrpsx1[_i,16]
		sx1->x1_var03  :=_agrpsx1[_i,17]
		sx1->x1_def03  :=_agrpsx1[_i,18]
		sx1->x1_cnt03  :=_agrpsx1[_i,19]
		sx1->x1_var04  :=_agrpsx1[_i,20]
		sx1->x1_def04  :=_agrpsx1[_i,21]
		sx1->x1_cnt04  :=_agrpsx1[_i,22]
		sx1->x1_var05  :=_agrpsx1[_i,23]
		sx1->x1_def05  :=_agrpsx1[_i,24]
		sx1->x1_cnt05  :=_agrpsx1[_i,25]
		sx1->x1_f3     :=_agrpsx1[_i,26]
		sx1->(msunlock())
	endif
next
return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpRat   บ Autor ณ Ricardo Fiuza    บ Data ณ  13/08/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออฬออออออออออุออออออออออสอออออออฯออออนฑฑ
ฬออออออออออุออออออออออสอออออออฯออออออฑฑออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Rateio do Contas a PG						  บฑฑ
ฑฑบ          ณ                                              		      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's Informatica                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ImpRat()

Private cPerg       := PADR("IMPRAT",Len(SX1->X1_GRUPO))
//Chama relatorio personalizado
//ValidPerg()
//pergunte(cPerg,.F.)    // sem tela de pergunta

oReport := ReportDef() // Chama a funcao personalizado onde deve buscar as informacoes
oReport:PrintDialog()  // Cria a tela de parametros no modo personalizado apos buscar as informacoes

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ Ricardo Fiuza      บ Data ณ  28/07/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA funcao estatica ReportDef devera ser criada para todos os บฑฑ
ฑฑบ          ณrelatorios que poderao ser agendados pelo usuario.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef() //Cria o Cabe็alho em excel

Local oReport, oSection, oBreak

cTitulo := "Relatorio de Rateio Centro de Custo"

oReport  := TReport():New("IMPRAT",cTitulo,"IMPRAT",{|oReport| PrintReport(oReport)},cTitulo)
//oReport:SetLandscape() // Paisagem
oReport:SetPortrait() //Retrato
oSection := TRSection():New(oReport,"Relatorio de Rateio Centro de Custo",{""})

TRCell():New(oSection, "CEL01_FIL"        , "CV4", "Fil"                      ,PesqPict("CV4","CV4_FILIAL")  ,02                     , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL02_CCUSTO"     , "CV4", "Centro de Custo"          ,PesqPict("CV4","CV4_CCD")     ,10					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL03_CONTC"      , "CV4", "Conta Custo/Despesa"      ,PesqPict("CV4","CV4_DEBITO")  ,20					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL04_DESCC"      , "CV4", "Desc. Centro de Custo"    ,								 ,60					 , /*lPixel*/, /* Formula*/)
TRCell():New(oSection, "CEL05_VALOR"      , "CV4", "Valor"  	  		      ,PesqPict("CV4","CV4_VALOR")   ,14					 , /*lPixel*/, /* Formula*/)

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReportบAutor  ณ Roberto Fiuza     บ Data ณ  28/05/2013 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA funcao estatica PrintReport realiza a impressao do relato-บฑฑ
ฑฑบ          ณrio                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport(oReport)

Local oSection := oReport:Section(1)

Private aDados[5]
Private wLin      := 0
Private aDet      := {}
Private aTot      := {}
Private aPvTot    := {}
Private aDeTot    := {}
Private aBaTot    := {}


oSection:Cell("CEL01_FIL"    ):SetBlock( { || aDados[01]})
oSection:Cell("CEL02_CCUSTO" ):SetBlock( { || aDados[02]})
oSection:Cell("CEL03_CONTC"  ):SetBlock( { || aDados[03]})
oSection:Cell("CEL04_DESCC"  ):SetBlock( { || aDados[04]})
oSection:Cell("CEL05_VALOR"  ):SetBlock( { || aDados[05]})

oBreak := TRBreak():New(oSection,oSection:Cell("CEL01_FIL"),,.F.)
TRFunction():New(oSection:Cell("CEL05_VALOR"),"TOT","SUM"  ,oBreak,"","@E 999,999,999.99",,.F.,.F.)


oReport:IncMeter()
oReport:NoUserFilter()
oSection:Init()

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf
// mv_par09  //1=Cliente , 2=UF

_cQry := " "
_cQry += "SELECT CV4_FILIAL,CV4_CCD,CV4_SEQUEN, CV4_DEBITO, CV4_VALOR "
_cQry += "FROM " + retsqlname("CV4")+" CV4 "
_cQry += "WHERE CV4.D_E_L_E_T_ <> '*' "
_cQry += "AND   CV4.CV4_SEQUEN  = '" +_cSop + "' "

_cQry := ChangeQuery(_cQry)
TcQuery _cQry New Alias "TMP"

dbselectarea("TMP")
DBGOTOP()
DO WHILE ! EOF()
	
	If oReport:Cancel()
		Exit
	EndIf
	aDados[01] := TMP->CV4_FILIAL
	aDados[02] := TMP->CV4_CCD
	aDados[03] := TMP->CV4_DEBITO
	aDados[04] := Posicione("CTT",1,(xFilial("CTT")+TMP->CV4_CCD),"CTT_DESC01")
	aDados[05] := TMP->CV4_VALOR
	
	oSection:PrintLine()  // Imprime linha de detalhe
	
	aFill(aDados,nil)     // Limpa o array a dados
	
	dbselectarea("TMP")
	skip
ENDDO

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

oSection:Finish()
oReport:SkipLine()
oReport:IncMeter()
Return

//FIM FUNCOES PARA IMPRESSAO - EXCEL

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo    ณ RetFat   ณAutor ณ Ricardo Moreira        ณData ณ 14/01/15  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Funcao para retornar o Valor do FAtumento no periodo       ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

User Function RetFat()

local _nValor := 0

cQuery 	:= " select SUM(F2_VALBRUT) VALOR_BRUTO from  "
cQuery	+= retsqlname("SF2")+" SF2 "
cQuery  += "WHERE SF2.D_E_L_E_T_ <> '*' "
cQuery  += "AND   SF2.F2_TIPO = 'N' "
cQuery  += "AND   SF2.F2_DUPL <> ' ' "
cQuery  += "AND   SF2.F2_FILIAL  BETWEEN '" + mv_par01       + "' AND '" +      mv_par02  + "' "
cQuery  += "AND   SF2.F2_CLIENTE BETWEEN '" + mv_par03       + "' AND '" +      mv_par04  + "' "
cQuery  += "AND   SF2.F2_LOJA    BETWEEN '" + mv_par05       + "' AND '" +      mv_par06  + "' "
cQuery  += "AND   SF2.F2_EMISSAO BETWEEN '" + DTOS(mv_par07) + "' AND '" + DTOS(mv_par08) + "' "

cQuery :=changequery(cQuery)
MEMOWRIT("\sql\RetFat.sql",cQuery)
tcquery cQuery new alias "TMP3"
_nValor := tmp3->VALOR_BRUTO
TMP3->(DBCLOSEAREA())

return(_nValor)



/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun็ใo    ณ RetFat   ณAutor ณ Ricardo Moreira        ณData ณ 14/01/15  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Funcao para retornar o Valor do FAtumento no periodo,      ณฑฑ
ฑฑณ          ณ dentro por Estadoo                                         ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

User Function RetFatUF()

local _nValUF := 0

cQuery 	:= " select SUM(F2_VALBRUT) VALORUF from  "
cQuery	+= retsqlname("SF2")+" SF2 "
cQuery  += "WHERE SF2.D_E_L_E_T_ <> '*' "
cQuery  += "AND   SF2.F2_TIPO = 'N' "
cQuery  += "AND   SF2.F2_DUPL <> ' ' "
cQuery  += "AND   SF2.F2_EST = '"+ _cUF +"' "
cQuery  += "AND   SF2.F2_FILIAL  BETWEEN '" + mv_par01       + "' AND '" +      mv_par02  + "' "
cQuery  += "AND   SF2.F2_CLIENTE BETWEEN '" + mv_par03       + "' AND '" +      mv_par04  + "' "
cQuery  += "AND   SF2.F2_LOJA    BETWEEN '" + mv_par05       + "' AND '" +      mv_par06  + "' "
cQuery  += "AND   SF2.F2_EMISSAO BETWEEN '" + DTOS(mv_par07) + "' AND '" + DTOS(mv_par08) + "' "

cQuery :=changequery(cQuery)
MEMOWRIT("\sql\RetFat.sql",cQuery)
tcquery cQuery new alias "TMP4"
_nValUF := tmp4->VALORUF
TMP4->(DBCLOSEAREA())

return(_nValUF)

//Fun็ใo para somar o valor do rateio na grid
//21/07/2015

User Function validar(campo)   

Local nCont 
cxtVlRat := 0 
//Msginfo("TESTE")

grdDados:aCols[n][3] := &(ReadVar())   
 
For nCont := 1 TO len(grdDados:aCols)
   If !grdDados:aCols[nCont] [len(aHeader) + 1] 
       cxtVlRat += grdDados:aCols[nCont][3]
   EndIf
Next  

If cxtVlRat > M->Z42_VALOR 
   Msginfo("Valor Rateado maior do que o Valor do SOPAG !!!!") 
   Return .F.
EndIf         
txtVlRat:Refresh()    
    
Return .T.
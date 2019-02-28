#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VIT415   บ Autor ณ Roberto Fiuza      บ Data ณ  01/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rateio CC                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VIT415()

Private cString   := "ZA7"
Private cCadastro := "Cadastro Rateios CC"
Private nOpcA     := 1
Private _cPerg    := "VIT415    "
Private wVlTot    := 0 
Private wNumItem  := 0
Private aAltEnchoice := {}

Private aRotina := {;
{"Pesquisar" ,"AxPesqui"    ,0,1} ,;
{"Visualizar","U_ZA7Tela(1)",0,2} ,;
{"Incluir"   ,"U_ZA7Tela(2)",0,3} ,;
{"Alterar"   ,"U_ZA7Tela(3)",0,4} ,;
{"Excluir"   ,"U_ZA7Tela(4)",0,5} ,;
{"Gerar"     ,"U_GerarCC()" ,0,3} ,;
{"Imprimir"  ,"U_VIT416()"  ,0,7} }


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




dbSelectArea(cString )
dbSetOrder(1)

//Set filter to Z7_FILTRO = "P"
mBrowse( 6, 1, 22, 75, cString )
//Set filter to

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ ZA7Tela  บAutor  ณRoberto Fiuza       บ Data ณ  01/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a tela Modelo 3                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ZA7Tela(nOpc)

Local nX, lRet   := ""


Private nOpcE    := 3, nOpcG := 3, N := 0
Private aHeader  := {}, aCols := {}, aCpo := {}
Private oTela    := nil, oLBox1 := nil, cCod := ""
Private _cCodigo := ZA7->ZA7_COD

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
	IF !X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. !(Trim(SX3->X3_CAMPO)$"ZA7_FILIAL ,ZA7_COD,ZA7_DESC,ZA7_DATA,ZA7_NF")
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
	cCod := ZA7->ZA7_DOC
	DbSelectArea("ZA7")
	DbSetOrder(1)  // ZA7_FILIAL +  ZA7_DOC + ZA7_COD + DTOS(ZA7_DATA)
	dbSeek(xFilial("ZA7")+cCod)
	n := 0
	DO WHILE !ZA7->( EOF() ) .And. ZA7->ZA7_FILIAL+ZA7->ZA7_DOC == xFilial("ZA7")+cCod
		aAdd(aCols,array(len(aHeader)+1))
		N++
		FOR i := 1 to len(aHeader)
			aCols[N][i] := IIF(aHeader[i][10]#"V",fieldGet(fieldPos(aHeader[i][2])),criaVar(aHeader[i][2],.T.))
		NEXT
		
		aCols[N][len(aHeader)+1] := .F.
		ZA7->( dbSkip() )
	ENDDO
	
	ZA7->(DbGoTop())
	ZA7->(dbSeek(xFilial("ZA7")+cCod) )
ENDIF

// aCpo : Recebe os campos que ficarao prontos para editar
aAdd(aCpo,"ZA7_DOC"	    )
aAdd(aCpo,"ZA7_DATA"	)
aAdd(aCpo,"ZA7_COD" 	)
aAdd(aCpo,"ZA7_VLTOT" 	)
aAdd(aCpo,"ZA7_NF"   	)

//campos nao sao preenchidos na inclusao
//aAdd(aCpo,"Z7_DATAP"		)
//aAdd(aCpo,"Z7_RECEBEU"	)

n := 1 //linha 1 do acols

If nOpc == 2 // Inclui
	aAltEnchoice := aClone(aCpo) //libera os campos do aCpo
	//Elseif (Substr(embaralha(ZA7->Z7_USERLGI,1),1,15) == substr(cusuario,7,15)) //Se o usuario for o mesmo que incluiu o registro
	//Elseif (Substr(Z7_USERLGA,1,15) == substr(cusuario,7,15)) //Se o usuario for o mesmo que incluiu o registro
	//libera todos os campos que nao estao no item
	//aAltEnchoice := aClone(aCpo)
	//aAdd(aAltEnchoice,"Z7_DATAP")
	//aAdd(aAltEnchoice,"Z7_RECEBEU")
Else //se for alteracao e o usuario nao e o dono do registro ele so altera os dois campos abaixo
	//aAltEnchoice := {"Z7_DATAP","Z7_RECEBEU"}
EndIf

aSizeAut := msAdvSize()
aObjects := {}
aAdd( aObjects, { 315, 130, .T., .T. } )

aCordW := {aSizeAut[7], 000, aSizeAut[6], aSizeAut[5]}
nSizeHeader := 120 //110

//cria a tela

nOpcA := nOpc

lRet := Modelo3("Cabecalho","ZA7","ZA7",aCpo,"u_ValZA7ok()","AllwaysTrue()",nOpcE,nOpcG,"AllwaysTrue()",,999, aAltEnchoice,,,aCordW,nSizeHeader)

If lRet
	DO CASE
		//======================================================================================================
		// INCLUI
		//======================================================================================================
		CASE nOpc == 2                                 
		    wVlTot   := 0        
		    
			FOR i := 1 TO len(aCols)
				IF !aCols[i][len(aHeader) + 1] //Nao deixa incluir mais itens do que a quantidade de campos no cabecalho
					
					//IF EMPTY(aCols[i][02]) // se nao tem descricao do item, nao grava
					//	LOOP
					//ENDIF
					
					IF recLock("ZA7",.T.)
						//Grava os campos que nao fazem parte do item
						ZA7->ZA7_FILIAL  := xFilial("ZA7")
						ZA7->ZA7_COD     := M->ZA7_COD
						ZA7->ZA7_DESC    := M->ZA7_DESC
						ZA7->ZA7_DATA    := M->ZA7_DATA
						ZA7->ZA7_DOC     := M->ZA7_DOC               
						ZA7->ZA7_NF      := M->ZA7_NF

						//Grava os campos que fazem parte do item
						FOR nX := 1 TO len(aHeader)
							fieldPut(fieldPos(allTrim(aHeader[nX][2])),aCols[i][nX])
							if allTrim(aHeader[nX][2]) = "ZA7_VLUNI"
								wVlTot := wVlTot + aCols[i][nX]
							endif
						NEXT
						ZA7->( msUnlock() )
					ENDIF
				ENDIF
			NEXT
			               
			wNumItem := 0
			DbSelectArea("ZA7")
			DbSetOrder(1)  // ZA7_FILIAL +  ZA7_DOC + ZA7_COD + DTOS(ZA7_DATA)
			dbSeek(xFilial("ZA7")+M->ZA7_DOC)
			Do While ! eof() .AND. ZA7_FILIAL + ZA7_DOC = xFilial("ZA7") + M->ZA7_DOC
				wNumItem := wNumItem + 1
				recLock("ZA7",.F.)
				ZA7->ZA7_ITEM    := strzero(wNumItem,4,0)
				ZA7->ZA7_VLTOT   := wVlTot
				ZA7->ZA7_INDICE  := (ZA7_VLUNI / wVlTot) * 100
				msUnlock()
				dbSkip()
			ENDDO
			
			
			
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
			
			DbSelectArea("ZA7")
			DbSetOrder(1)  // ZA7_FILIAL +  ZA7_DOC + ZA7_COD + DTOS(ZA7_DATA)
			dbSeek(xFilial("ZA7")+M->ZA7_DOC)
			Do While ! eof() .AND. ZA7_FILIAL + ZA7_DOC = xFilial("ZA7") + M->ZA7_DOC
				recLock("ZA7",.F.)
				ZA7->( dbDelete() )
				msUnlock()
				dbSkip()
			ENDDO
			
			wVlTot   := 0
			FOR i := 1 TO len(aCols)
				IF !aCols[i][len(aHeader) + 1]   // SE O REGISTRO DO ACOLS ESTA DELETADO NAO ENTRA
					wNumItem := wNumItem + 1
					aCols[i][1]  := strzero(wNumItem,4,0)
					IF recLock("ZA7",.T.)
						//Cabecalho
						ZA7->ZA7_FILIAL  := xFilial("ZA7")
						ZA7->ZA7_COD     := M->ZA7_COD
						ZA7->ZA7_DESC    := M->ZA7_DESC
						ZA7->ZA7_DATA    := M->ZA7_DATA
						ZA7->ZA7_DOC     := M->ZA7_DOC
						ZA7->ZA7_NF      := M->ZA7_NF
						//Itens
						FOR nX := 1 TO len(aHeader)
							fieldPut( fieldPos(  allTrim(aHeader[nX][2])) , aCols[i][nX] )
							if allTrim(aHeader[nX][2]) = "ZA7_VLUNI"
								wVlTot := wVlTot + aCols[i][nX]
							endif
						NEXT
						ZA7->( msUnlock() )
					ENDIF
				ENDIF
			NEXT
			               
			wNumItem := 0 
			DbSelectArea("ZA7")
			DbSetOrder(1)  // ZA7_FILIAL +  ZA7_DOC + ZA7_COD + DTOS(ZA7_DATA)
			dbSeek(xFilial("ZA7")+M->ZA7_DOC)
			Do While ! eof() .AND. ZA7_FILIAL + ZA7_DOC = xFilial("ZA7") + M->ZA7_DOC
				wNumItem := wNumItem + 1
				recLock("ZA7",.F.)
				ZA7->ZA7_ITEM    := strzero(wNumItem,4,0)
				ZA7->ZA7_VLTOT   := wVlTot
				ZA7->ZA7_INDICE  := (ZA7_VLUNI / wVlTot) * 100
				msUnlock()
				dbSkip()
			ENDDO
			
			END TRANSACTION
			//======================================================================================================
			// EXCLUI
			//======================================================================================================
		CASE nOpc == 4
			BEGIN TRANSACTION
			DbSelectArea("ZA7")
			DbSetOrder(1)  // ZA7_FILIAL +  ZA7_DOC + ZA7_COD + DTOS(ZA7_DATA)
			dbSeek(xFilial("ZA7")+M->ZA7_DOC)
			Do While ! eof() .AND. ZA7_FILIAL + ZA7_DOC = xFilial("ZA7") + M->ZA7_DOC
				recLock("ZA7",.F.)
				ZA7->( dbDelete() )
				msUnlock()
				dbSkip()
			ENDDO
			END TRANSACTION
	ENDCASE
ENDIF

dbSelectArea("ZA7")
dbSetOrder(1)

Return ()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Funcao para validacao dos imput dos itens                           |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function ValZA7ok()

Local lRet 		:= .t.
Local nPosDesc  := 0
Local nPos 		:= 0

//IF nOpcA  = 3 // ALTERACAO
//	if alltrim(acols[n ,nPosDesc]) <> alltrim(ZA7->Z7_DESCRIC) //.or.;
//		MsgAlert("Voc๊s s๓ pode alterar os itens dos cadastros incluidos por voc๊. ")
//		lRet := .f.
//	endif
//Endif


Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ ROBERTO FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO CHAMADA PELO SX3 DO CAMPO Z7_ITEM (SEQUENCIAL)      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fInItemZ7(cCampo)

Local nPos := 0
Local nLin := N
Local cRet := ""

Default cCampo  := "Z7_ITEM"

cRet := StrZero(nLin , 3) //PREENCHE O VALOR DO ITEM

Return(cRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ ROBERTO FIUZA                                              บฑฑ
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



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ ROBERTO FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO GerarCC()                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GerarCC()


_pergsx1()

pergunte( _cPerg,.T. )

If ! MsgYesNo("Deseja gerar itens do Rateio ?")
	Return .t.
endif

processa({|| fZA7acols() })

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ ROBERTO FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO GERA ACOLS CONFORME DESPESA                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fZA7acols()


procregua(4)
incproc("Processando CC....")

// Deleta os registros existentes
//_cQry := " DELETE FROM "+RetSQLName("ZA7")
//_cQry += " WHERE ZA7_FILIAL  = '"+xFilial("ZA7")+"'"
//_cQry += " AND ZA7_DOC = '" + mv_par01+"'"
//tcSQLExec(_cQry)
//tcSQLExec("COMMIT")  // Oracle
//sysrefresh()


DbSelectArea("ZA7")
DbSetOrder(1)  // ZA7_FILIAL +  ZA7_DOC + ZA7_COD + DTOS(ZA7_DATA)
dbSeek(xFilial("ZA7")+mv_par01)
Do While ! eof() .AND. ZA7_FILIAL + ZA7_DOC = xFilial("ZA7") + mv_par01
	recLock("ZA7",.F.)
	ZA7->( dbDelete() )
	msUnlock()
	dbSkip()
ENDDO


dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+"Z7"+mv_par03)



if mv_par03     = "01    " //  CRACHAS
	fCracha()
elseif mv_par03 = "02    " //  PORTO PEREIRA
	fPortoP()
elseif mv_par03 = "03    " //  SEGURO DE VIDA
	fSegVida()
elseif mv_par03 = "04    " //  UNIMED
	fUnimed()
elseif mv_par03 = "05    " //  VALE CARD
	fValeCard()
elseif mv_par03 = "06    " //  TCA
	fVtTCA()
endif

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ ROBERTO FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO GERA RADEIO CRACHA                                  บฑฑ
ฑฑบ          ณ Deve informar valor unitario no parametro * qtd funcionarioบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCracha()

Local wTotG := 0
Local wItem := 1

DbSelectArea("SRA")
DbSetOrder(2)  // RA_FILIAL + RA_CC + RA_MAT
dbgotop()
Do While ! eof()
	
	IF ! RA_SITFOLH $ (" /F") // Ativo / Ferias
		SKIP
		LOOP
	ENDIF
	
	DbSelectArea("ZA7")
	recLock("ZA7",.T.)
	//Grava os campos Cabecalho
	ZA7->ZA7_FILIAL  := xFilial("ZA7")
	ZA7->ZA7_DOC     := mv_par01
	ZA7->ZA7_DATA    := mv_par02
	ZA7->ZA7_COD     := mv_par03
	ZA7->ZA7_DESC    := SX5->X5_DESCRI
	ZA7->ZA7_VLTOT   := 0
    ZA7->ZA7_NF      := mv_par05
	//Grava os campos Itens
	ZA7_ITEM         := STRZERO(wItem,4,0)
	ZA7_NOME         := SRA->RA_NOME
	ZA7_CCDESC       := Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT->CTT_DESC01")
	ZA7_OBS          := " "
	ZA7_MAT          := SRA->RA_MAT
	ZA7_CC           := SRA->RA_CC
	ZA7_VLUNI        := mv_par04
	ZA7_INDICE       := 0
	msUnlock()
	
	wTotG := wTotG + ZA7->ZA7_VLUNI
	wItem += 1
	DbSelectArea("SRA")
	skip
Enddo

DbSelectArea("ZA7")
DbSetOrder(1)  // ZA7_FILIAL +  ZA7_DOC + ZA7_COD + DTOS(ZA7_DATA)
dbSeek(xFilial("ZA7")+mv_par01)
Do While ! eof() .AND. ZA7_FILIAL + ZA7_DOC = xFilial("ZA7") + mv_par01
	recLock("ZA7",.F.)
	ZA7_INDICE       := (ZA7_VLUNI / wTotG) * 100
	ZA7->ZA7_VLTOT   := wTotG
	msUnlock()
	dbSkip()
ENDDO
Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ ROBERTO FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO GERA PORTO PEREIRA                                  บฑฑ
ฑฑบ          ณ Deve informar valor total da nf no parametro               บฑฑ
ฑฑบ          ณ 552','572' rateio pelo valor das verbas                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPortoP()

Local wTotG := mv_par04
Local wItem := 1


If Select("QSRC") > 0
	QSRC->(dbCloseArea())
EndIf

if Substr(dtos(mv_par02),1,6) = getmv("MV_FOLMES")
	wTabRC := retsqlname("SRC")
else
	wTabRC := "RC" + cEmpAnt + substr(strzero(year(mv_par02),4,0),3,2) + strzero(month(mv_par02),2,0)
endif

_cQry := " SELECT RC_CC,RC_MAT,SUM(RC_VALOR) AS VLPORTO  "
_cQry += " FROM " + wTabRC
_cQry += " WHERE D_E_L_E_T_ = ' '"
_cQry += " AND RC_FILIAL    = '" + XFILIAL("SRC")    + "' "
_cQry += " AND RC_PD IN ('552','572') "
_cQry += " GROUP BY RC_CC,RC_MAT "
_cQry += " ORDER BY RC_CC,RC_MAT "

_cQry := ChangeQuery(_cQry)

TcQuery _cQry New Alias "QSRC"


dbselectarea("QSRC")
DBGOTOP()
DO WHILE ! EOF()
	
	dbSelectArea("SRA")
    dbSetOrder(1)
    dbSeek( xFilial("SRA") + QSRC->RC_MAT )

	DbSelectArea("ZA7")         
	recLock("ZA7",.T.)
	//Grava os campos Cabecalho
	ZA7->ZA7_FILIAL  := xFilial("ZA7")
	ZA7->ZA7_DOC     := mv_par01
	ZA7->ZA7_DATA    := mv_par02
	ZA7->ZA7_COD     := mv_par03
	ZA7->ZA7_DESC    := SX5->X5_DESCRI
	ZA7->ZA7_VLTOT   := wTotG   
	ZA7->ZA7_NF      := mv_par05
	//Grava os campos Itens
	ZA7_ITEM         := STRZERO(wItem,4,0)
	ZA7_NOME         := SRA->RA_NOME
	ZA7_CCDESC       := Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT->CTT_DESC01")
	ZA7_OBS          := " "
	ZA7_MAT          := QSRC->RC_MAT
	ZA7_CC           := QSRC->RC_CC
	ZA7_VLUNI        := QSRC->VLPORTO
	ZA7_INDICE       := (ZA7_VLUNI / wTotG) * 100
	msUnlock()
	dbselectarea("QSRC")
	skip
enddo

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ ROBERTO FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rateio Seguro de Vida                                      บฑฑ
ฑฑบ          ณ Deve informar valor total da nf no parametro               บฑฑ
ฑฑบ          ณ indice por funcionario ativo                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fSegVida()

Local wQtdFunc := 0
Local wItem := 1

DbSelectArea("SRA")
DbSetOrder(2)  // RA_FILIAL + RA_CC + RA_MAT
dbgotop()
Do While ! eof()
	
	IF ! RA_SITFOLH $ (" /F") // Ativo / Ferias
		SKIP
		LOOP
	ENDIF
	
	DbSelectArea("ZA7")
	recLock("ZA7",.T.)
	//Grava os campos Cabecalho
	ZA7->ZA7_FILIAL  := xFilial("ZA7")
	ZA7->ZA7_DOC     := mv_par01
	ZA7->ZA7_DATA    := mv_par02
	ZA7->ZA7_COD     := mv_par03
	ZA7->ZA7_DESC    := SX5->X5_DESCRI
	ZA7->ZA7_VLTOT   := mv_par04
	ZA7->ZA7_NF      := mv_par05
	//Grava os campos Itens
	ZA7_ITEM         := STRZERO(wItem,4,0)
	ZA7_NOME         := SRA->RA_NOME
	ZA7_CCDESC       := Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT->CTT_DESC01")
	ZA7_OBS          := " "
	ZA7_MAT          := SRA->RA_MAT
	ZA7_CC           := SRA->RA_CC
	ZA7_VLUNI        := 0
	ZA7_INDICE       := 0
	msUnlock()
	
	wQtdFunc := wQtdFunc + 1
	wItem += 1
	
	DbSelectArea("SRA")
	skip
Enddo

DbSelectArea("ZA7")
DbSetOrder(1)  // ZA7_FILIAL +  ZA7_DOC + ZA7_COD + DTOS(ZA7_DATA)
dbSeek(xFilial("ZA7")+mv_par01)
Do While ! eof() .AND. ZA7_FILIAL + ZA7_DOC = xFilial("ZA7") + mv_par01
	recLock("ZA7",.F.)
	ZA7_VLUNI        := mv_par04   / wQtdFunc
	ZA7_INDICE       := (ZA7_VLUNI / mv_par04) * 100
	msUnlock()
	dbSkip()
ENDDO

Return .t.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ ROBERTO FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO GERA fUnimed                                        บฑฑ
ฑฑบ          ณ Deve informar valor total da nf no parametro               บฑฑ
ฑฑบ          ณ rateio pelo funcionario + seus dependentes                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fUnimed()

Local wTotG    := 0
Local wVlPlano := 0
Local wItem    := 1
Local wRbNome  := ""

DbSelectArea("SRA")
DbSetOrder(2)  // RA_FILIAL + RA_CC + RA_MAT
dbgotop()
Do While ! eof()
	
	IF ! RA_SITFOLH $ (" /F") // Ativo / Ferias
		SKIP
		LOOP
	ENDIF
	
	
	// *********************** FUNCIONARIO *******************************
	DbSelectArea("RHK")
	DbSetOrder(1)  // RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR
	if dbSeek(xFilial("RHK") + SRA->RA_MAT)
		
		DbSelectArea("RCC")
		DbSetOrder(1)  // RCC_FILIAL+RCC_CODIGO+RCC_FIL+RCC_CHAVE+RCC_SEQUEN
		dbSeek(xFilial("RCC") + "S008")
		do While ! eof() .and. RCC_FILIAL+RCC_CODIGO = xFilial("RCC") + "S008"
			if substr(RCC_CONTEU,1,2) = RHK->RHK_PLANO
				wVlPlano := val(substr(RCC_CONTEU,35,12))
				exit
			endif
			skip
		enddo
		
		DbSelectArea("ZA7")
		recLock("ZA7",.T.)
		//Grava os campos Cabecalho
		ZA7->ZA7_FILIAL  := xFilial("ZA7")
		ZA7->ZA7_DOC     := mv_par01
		ZA7->ZA7_DATA    := mv_par02
		ZA7->ZA7_COD     := mv_par03
		ZA7->ZA7_DESC    := SX5->X5_DESCRI
		ZA7->ZA7_VLTOT   := mv_par04
		ZA7->ZA7_NF      := mv_par05
		//Grava os campos Itens
		ZA7_ITEM         := STRZERO(wItem,4,0)
		ZA7_NOME         := SRA->RA_NOME
		ZA7_CCDESC       := Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT->CTT_DESC01")
		ZA7_OBS          := " "
		ZA7_MAT          := SRA->RA_MAT
		ZA7_CC           := SRA->RA_CC
		ZA7_VLUNI        := wVlPlano
		ZA7_INDICE       := (ZA7_VLUNI / mv_par04) * 100
		msUnlock()
		wTotG    := wTotG + wVlPlano
		wVlPlano := 0
		wItem += 1
		
		// *********************** DEPENDENTE *******************************
		
		DbSelectArea("RHL")
		DbSetOrder(1)  // RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO
		dbSeek(xFilial("RHL") + SRA->RA_MAT)
		do While ! eof() .and. RHL_FILIAL+RHL_MAT = xFilial("RHL") + SRA->RA_MAT
			
			DbSelectArea("RCC")
			DbSetOrder(1)  // RCC_FILIAL+RCC_CODIGO+RCC_FIL+RCC_CHAVE+RCC_SEQUEN
			dbSeek(xFilial("RCC") + "S008")
			do While ! eof() .and. RCC_FILIAL+RCC_CODIGO = xFilial("RCC") + "S008"
				if substr(RCC_CONTEU,1,2) = RHL->RHL_PLANO
					wVlPlano := val(substr(RCC_CONTEU,35,12))
					exit
				endif
				skip
			enddo
			
			wRbNome := ""
			DbSelectArea("SRB")
			DbSetOrder(1)  // RB_FILIAL + RB_MAT
			dbSeek(xFilial("SRB") + SRA->RA_MAT)
			do While ! eof() .and. RB_FILIAL + RB_MAT = xFilial("SRB") + SRA->RA_MAT
				if RB_COD = RHL->RHL_CODIGO
					wRbNome := RB_NOME
					exit
				endif
				skip
			enddo
			
			DbSelectArea("ZA7")
			recLock("ZA7",.T.)
			//Grava os campos Cabecalho
			ZA7->ZA7_FILIAL  := xFilial("ZA7")
			ZA7->ZA7_DOC     := mv_par01
			ZA7->ZA7_DATA    := mv_par02
			ZA7->ZA7_COD     := mv_par03
			ZA7->ZA7_DESC    := SX5->X5_DESCRI
			ZA7->ZA7_VLTOT   := mv_par04
			ZA7->ZA7_NF      := mv_par05
			//Grava os campos Itens
			ZA7_ITEM         := STRZERO(wItem,4,0)
			ZA7_NOME         := SRA->RA_NOME
			ZA7_CCDESC       := Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT->CTT_DESC01")
			ZA7_OBS          := wRbNome
			ZA7_MAT          := SRA->RA_MAT
			ZA7_CC           := SRA->RA_CC
			ZA7_VLUNI        := wVlPlano
			ZA7_INDICE       := (ZA7_VLUNI / mv_par04) * 100
			msUnlock()
			wTotG    := wTotG + wVlPlano
			wVlPlano := 0
			wItem += 1
			DbSelectArea("RHL")
			skip
		enddo
	endif
	
	DbSelectArea("SRA")
	skip
Enddo

DbSelectArea("ZA7")
DbSetOrder(1)  // ZA7_FILIAL +  ZA7_DOC + ZA7_COD + DTOS(ZA7_DATA)
dbSeek(xFilial("ZA7")+mv_par01)
Do While ! eof() .AND. ZA7_FILIAL + ZA7_DOC = xFilial("ZA7") + mv_par01
	recLock("ZA7",.F.)
	ZA7_INDICE       := (ZA7_VLUNI / wTotG) * 100
	ZA7->ZA7_VLTOT   := wTotG
	msUnlock()
	dbSkip()
ENDDO

Return .t.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ ROBERTO FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO GERA RADEIO VALE CARD                               บฑฑ
ฑฑบ          ณ Deve informar valor unitario no parametro * qtd funcionarioบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fValeCard()

Local wTotG := 0
Local wItem := 1

DbSelectArea("SRA")
DbSetOrder(2)  // RA_FILIAL + RA_CC + RA_MAT
dbgotop()
Do While ! eof()
	
	IF ! RA_SITFOLH $ (" /F") // Ativo / Ferias
		SKIP
		LOOP
	ENDIF
	
	DbSelectArea("ZA7")
	recLock("ZA7",.T.)
	//Grava os campos Cabecalho
	ZA7->ZA7_FILIAL  := xFilial("ZA7")
	ZA7->ZA7_DOC     := mv_par01
	ZA7->ZA7_DATA    := mv_par02
	ZA7->ZA7_COD     := mv_par03
	ZA7->ZA7_DESC    := SX5->X5_DESCRI
	ZA7->ZA7_VLTOT   := 0               
	ZA7->ZA7_NF      := mv_par05
	//Grava os campos Itens
	ZA7_ITEM         := STRZERO(wItem,4,0)
	ZA7_NOME         := SRA->RA_NOME
	ZA7_CCDESC       := Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT->CTT_DESC01")
	ZA7_OBS          := " "
	ZA7_MAT          := SRA->RA_MAT
	ZA7_CC           := SRA->RA_CC
	ZA7_VLUNI        := mv_par04
	ZA7_INDICE       := 0
	msUnlock()
	
	wTotG := wTotG + ZA7->ZA7_VLUNI
	wItem += 1
	
	DbSelectArea("SRA")
	skip
Enddo

DbSelectArea("ZA7")
DbSetOrder(1)  // ZA7_FILIAL +  ZA7_DOC + ZA7_COD + DTOS(ZA7_DATA)
dbSeek(xFilial("ZA7")+mv_par01)
Do While ! eof() .AND. ZA7_FILIAL + ZA7_DOC = xFilial("ZA7") + mv_par01
	recLock("ZA7",.F.)
	ZA7_INDICE       := (ZA7_VLUNI / wTotG) * 100
	ZA7->ZA7_VLTOT   := wTotG
	msUnlock()
	dbSkip()
ENDDO
Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบAUTOR     ณ ROBERTO FIUZA                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO GERA RADEIO TCA                                     บฑฑ
ฑฑบ          ณ Deve informar os dias uteis                                บฑฑ
ฑฑบ R0_QDIAINF = Qt. Vale Dia                                             บฑฑ
ฑฑบ mv_par04   = Dias uteis                                               บฑฑ
ฑฑบ RN_VUNIATU = Valor Unit                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fiuza's                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fVtTCA()

Local wTotG := 0
Local wItem := 1

DbSelectArea("SRA")
DbSetOrder(2)  // RA_FILIAL + RA_CC + RA_MAT
dbgotop()
Do While ! eof()
	
	IF ! RA_SITFOLH $ (" /F") // Ativo / Ferias
		SKIP
		LOOP
	ENDIF
	
	wValVT := 0
	DbSelectArea("SR0")
	DbSetOrder(1)  // R0_FILIAL+R0_MAT+R0_MEIO
	dbSeek( xFilial("SR0") + SRA->RA_MAT)
	do While ! eof() .and. R0_FILIAL+R0_MAT = xFilial("SR0") + SRA->RA_MAT
		DbSelectArea("SRN")
		DbSetOrder(1)  // RN_FILIAL+RN_COD
		dbSeek( xFilial("SRN") + SR0->R0_MEIO)
		wValVT := wValVT + (SR0->R0_QDIAINF * mv_par04 *  RN_VUNIATU )
		DbSelectArea("SR0")
		skip
	enddo
	
	// R0_QDIAINF = Qt. Vale Dia
	// mv_par04   = Dias uteis
	// RN_VUNIATU = Valor Unit
	
	
	if wValVT > 0
		DbSelectArea("ZA7")
		recLock("ZA7",.T.)
		//Grava os campos Cabecalho
		ZA7->ZA7_FILIAL  := xFilial("ZA7")
		ZA7->ZA7_DOC     := mv_par01
		ZA7->ZA7_DATA    := mv_par02
		ZA7->ZA7_COD     := mv_par03
		ZA7->ZA7_DESC    := SX5->X5_DESCRI
		ZA7->ZA7_VLTOT   := 0   
		ZA7->ZA7_NF      := mv_par05
		//Grava os campos Itens
		ZA7_ITEM         := STRZERO(wItem,4,0)
		ZA7_NOME         := SRA->RA_NOME
		ZA7_CCDESC       := Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT->CTT_DESC01")
		ZA7_OBS          := SUBSTR(SRN->RN_DESC,1,10) + " = "  + STRZERO(SR0->R0_QDIAINF,2,0) + " X "  + STRZERO(mv_par04,2,0) + " X "  + STR(SRN->RN_VUNIATU,7,2)
		ZA7_MAT          := SRA->RA_MAT
		ZA7_CC           := SRA->RA_CC
		ZA7_VLUNI        := wValVT
		ZA7_INDICE       := 0
		msUnlock()
		
		wTotG := wTotG + ZA7->ZA7_VLUNI
		wItem += 1
	endif
	
	DbSelectArea("SRA")
	skip
Enddo

DbSelectArea("ZA7")
DbSetOrder(1)  // ZA7_FILIAL +  ZA7_DOC + ZA7_COD + DTOS(ZA7_DATA)
dbSeek(xFilial("ZA7")+mv_par01)
Do While ! eof() .AND. ZA7_FILIAL + ZA7_DOC = xFilial("ZA7") + mv_par01
	recLock("ZA7",.F.)
	ZA7_INDICE       := (ZA7_VLUNI / wTotG) * 100
	ZA7->ZA7_VLTOT   := wTotG
	msUnlock()
	dbSkip()
ENDDO
Return .t.

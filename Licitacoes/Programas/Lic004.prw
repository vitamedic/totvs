#include "RWMAKE.CH"
#INCLUDE "COLORS.CH"

/*
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  Ё LIC004    ЁAutor  Ё Marcelo Myra      Ё Data Ё  08/19/02   Ё╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠ЁDescricao Ё Tela de Consulta de Estoque                                Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё AP6                                                        Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ЁVersao    Ё 1.0                                                        Ё╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
*/

User Function LIC004()

Local cProduto 	:= aCols[n][2]
Local cObs 		:= ""
Local oEstoque
Local oObs
Local nPProd 	:= 0
Local nPedVen	:= 0
Local nEmp		:= 0
Local nSalPedi	:= 0
Local nReserva	:= 0
Local nStok2	:= 0
Local cBitPro 	:= ""
Local oBitPro
Local cLocal 	:= ""
Local cPictSB2  := SPACE(12)
Local nPosAnt   := 0
Local cNomeAlter:= ""
Local cGrupo    := ""
Local nPLocal   := 0
Local lTMKMCA  	:= FindFunction("U_TMKMCA")
Local lTMKVCA  	:= FindFunction("U_TMKVCA")
Local nDisp		:= 0
Local nPRV1 	:= 0
Local nPRV2 	:= 0
Local nPRV3 	:= 0
Local nPRV4 	:= 0
Local nPRV5 	:= 0
Local nPRV6 	:= 0
Local nPRV7 	:= 0
Local cAtend    := ""
Local cCliente  := ""
Local cLoja     := ""
Local cCodCont  := ""
Local cCodOper  := ""
Local cEnt      := ""
Local cChave    := ""

nFolder:= 1
  
  If Empty( cProduto )
  	Help(" ",1,"SEM PRODUT" )
  	Return(.T.)
  Endif
  
  DbSelectarea( "SB1" )
  DbSetOrder(1)
  If DbSeek( xFilial("SB1") + cProduto )
  	cObs   := MSMM(SB1->B1_CODOBS,TamSx3("B1_OBS")[1])
  	cGrupo := SB1->B1_GRUPO
  	If Empty(cLocal)
  		cLocal := SB1->B1_LOCPAD
  	Endif
  	nPosAnt:= Recno()
 	
  	If DbSeek(xFilial("SB1")+SB1->B1_ALTER)
  		cNomeAlter := ALLTRIM(B1_ALTER + " - "+ ALLTRIM(B1_DESC))
  	Endif
  Endif
  
  DbSelectarea( "SB2" )
  DbSetorder(1)
  If DbSeek( xFilial("SB2") + cProduto + cLocal )
  	
  	nStok2  := B2_QATU
  	nPedVen := B2_QPEDVEN
  	nEmp    := B2_QEMP
  	nSalPedi:= B2_SALPEDI
  	nReserva:= B2_RESERVA
  	nDisp   := SaldoMov()
  Endif
  
  DbSelectarea( "SB9" )
  DbSeek( xFilial("SB9") + cProduto )
  
  DbSelectarea("SX3")
  DbSetorder(2)
  If DbSeek("B2_QATU")
  	cPictSB2 := X3_PICTURE
  Endif
  
  DbSelectarea("SX5")
  DbSetorder(1)
  If DbSeek(xFilial("SX5")+"03"+cGrupo)
  	cGrupo := X5DESCRI()
  Endif
  
  //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  //Ё Mostra dados do Produto.					                 Ё
  //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
  DEFINE MSDIALOG oEstoque FROM  23,181 TO 410,723 TITLE "Caracteristicas do produto" PIXEL
  	DbSelectarea("SB1")
  	DbGoto(nPosAnt)
  	//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  	//ЁDados das caracteristicas do produto                 Ё
  	//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
  	@ 06,02 TO 43,270 TITLE "Dados do Produto"
  	@ 13,04  SAY "C╒digo" SIZE  21,7
  	@ 13,29  SAY SB1->B1_COD SIZE  49,8 COLOR CLR_BLUE
  	
  	@ 13,80  SAY "Unidade" SIZE  20,7 
  	@ 13,102 SAY SB1->B1_UM SIZE  10,8  COLOR CLR_BLUE
  	
  	@ 13,115 SAY "Grupo" SIZE  18,7 
  	@ 13,135 SAY cGrupo SIZE 40,8  COLOR CLR_BLUE
  	
  	@ 13,155 SAY "Qtd. Embalagem" SIZE  70,7 
  	@ 13,225 SAY Transform(SB1->B1_QE,"@E 999,999,999") SIZE  35,7  COLOR CLR_BLUE
  	
  	@ 23, 4  SAY "Descri┤└o" SIZE  32, 7 
  	@ 23,33  SAY SB1->B1_DESC SIZE 140, 8  COLOR CLR_BLUE
  	
  	@ 23,155 SAY "Peso Liquido" SIZE  60,7  
  	@ 23,225 SAY Transform(SB1->B1_PESO,"@E 999,999,9999") SIZE  35,7  COLOR CLR_BLUE
  	
  	@ 33, 4  SAY "Produto Alternativo" SIZE  80,7 
  	@ 33,90  SAY cNomeAlterC SIZE 138, 8  COLOR CLR_BLUE
  	
  	cBitPro := SB1->B1_BITMAP
  	//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  	//ЁSaldo do estoque do produto                          Ё
  	//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
  	@ 45, 02 TO 85,155 TITLE "Estoque"  
  	
  	@ 51, 04 SAY "Ped. Abertos" SIZE  33, 7 
  	@ 51, 42 SAY Transform(nPedVen,cPictSB2) SIZE 40, 7  COLOR CLR_BLUE
  	
  	@ 61, 04 SAY "a Entrar" SIZE  33, 7 
  	@ 61, 42 SAY Transform(nSalPedi,"@E 999,999,999.99") SIZE 40, 7  COLOR CLR_BLUE
  	
  	@ 71, 04 SAY "Atual" SIZE  33, 7 
  	@ 71, 42 SAY Transform(nStok2,"@E 999,999,999.99") SIZE 40, 7  COLOR CLR_BLUE
  	
  	@ 51, 83 SAY "Empenho" SIZE  33, 7 
  	@ 51,110 SAY Transform(nEmp,"@E 999,999,999.99") SIZE 40, 7  COLOR CLR_BLUE
  	
  	@ 61, 83 SAY "Reservado" SIZE  33, 7 
  	@ 61,110 SAY Transform(nReserva,"@E 999,999,999.99") SIZE 40, 7  COLOR CLR_BLUE
  	
  	@ 71, 83 SAY "Dispon║vel" SIZE  33, 7 
  	@ 71,110 SAY Transform(nDisp,"@E 999,999,999.99") SIZE 40, 7  COLOR CLR_BLUE
  	
  	nPRV := {0,0,0,0,0,0,0}
    
  	DbSelectarea( "DA1" )
 	DbSetorder(2)
  	DbSeek( xFilial("DA1") + SB1->B1_COD )
  	_c := 1
  	while !DA1->(Eof()) .and. DA1->DA1_CODPRO==SB1->B1_COD .and. _c<=7
		nPRV[_c] := DA1->DA1_PRCVEN
		_c := _c + 1
  		DA1->(dbSkip())
  	Enddo
  	
  	//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  	//ЁTabela de preco do produto (SB1 e SB5)               Ё
  	//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
  	@ 45,157 TO 85,270 TITLE "Precos de Venda"
  	
  	@ 53,160 SAY OemToAnsi("1 -") SIZE 10, 7 
  	@ 53,165 SAY Transform(nPRV[1],"@E 9,999,999.99") SIZE 35, 7  COLOR CLR_BLUE
  	
  	@ 63,160 SAY OemToAnsi("2 -") SIZE 10, 7 
  	@ 63,165 SAY Transform(nPRV[2],"@E 9,999,999.99") SIZE 35, 7  COLOR CLR_BLUE
  	
  	@ 73,160 SAY OemToAnsi("3 -") SIZE 10, 7 
  	@ 73,165 SAY Transform(nPRV[3],"@E 9,999,999.99") SIZE 35, 7  COLOR CLR_BLUE
  	
  	@ 53,195 SAY OemToAnsi("4 -") SIZE 10, 7 
  	@ 53,200 SAY Transform(nPRV[4],"@E 9,999,999.99") SIZE 35, 7  COLOR CLR_BLUE
  	
  	@ 63,195 SAY OemToAnsi("5 -") SIZE 10, 7 
  	@ 63,200 SAY Transform(nPRV[5],"@E 9,999,999.99") SIZE 35, 7  COLOR CLR_BLUE
  	
  	@ 73,195 SAY OemToAnsi("6 -") SIZE 10, 7 
  	@ 73,200 SAY Transform(nPRV[6],"@E 9,999,999.99") SIZE 35, 7  COLOR CLR_BLUE
  	
  	@ 53,230 SAY OemToAnsi("7 -") SIZE 10, 7 
  	@ 53,235 SAY Transform(nPRV[7],"@E 9,999,999.99") SIZE 30, 7  COLOR CLR_BLUE
  	
  	//здддддддддддддддддддддддддддддддддддддддддддддддддддд©
  	//ЁCarrega a imagem do produto                         Ё
  	//юдддддддддддддддддддддддддддддддддддддддддддддддддддды
  	@ 87,02 TO 85,175 TITLE "Estoque" 
  	
  	@ 87,02 TO 170,105 TITLE "Foto" 
  	If Empty(SB1->B1_BITMAP)
 		@ 120,30 SAY "Foto n└o disponivel" SIZE 50,8 COLOR CLR_BLUE
  	Else
  		@ 95,04 REPOSITORY oBitPro OF oEstoque NOBORDER SIZE 99,70 PIXEL
  		Showbitmap(oBitPro,SB1->B1_BITMAP,"")
  		oBitPro:lStretch:=.T.
 		oBitPro:Refresh()
  	Endif
  	//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  	//ЁCarrega as observa┤ao sobre o produto B1_OBS         Ё
  	//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
  	@ 87,110 TO 170,270 TITLE "Observa┤oes"  
  	@ 93,115 GET cObs MEMO Size 150,70
  	
//  	DEFINE SBUTTON FROM 175,160 TYPE 11 ACTION TKDetalhes(nFolder) ENABLE OF oEstoque 
//  	DEFINE SBUTTON FROM 175,200 TYPE 15 ACTION TKVisuProd(cProduto,cLocal) ENABLE OF oEstoque //Visualiza
  	DEFINE SBUTTON FROM 175,240 TYPE 1  ACTION (oEstoque:End()) ENABLE OF oEstoque
  
	ACTIVATE MSDIALOG oEstoque CENTER
  
Return(.T.)


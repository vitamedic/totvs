#INCLUDE "Protheus.CH" 
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#INCLUDE "TBICONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} Vit605
Rotina Vit605
Relatório 

@author Danilo Brito
@since 17/05/2017
@version P11
@param Nao recebe parametros
@return Nil(nulo)
/*/
//------------------------------------------------------------  
User Function VIT605

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Variaveis de Tipos de fontes que podem ser utilizadas no relatório   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	Private oFont6		:= TFONT():New("ARIAL",6 ,6 ,,.F.,,,,,.F.,.F.) ///Fonte 6 Normal
	Private oFont6N 	:= TFONT():New("ARIAL",6 ,6 ,,.T.,,,,,.T.,.F.) ///Fonte 6 Negrito
	Private oFont8		:= TFONT():New("ARIAL",8 ,8 ,,.F.,,,,,.F.,.F.) ///Fonte 8 Normal
	Private oFont8N 	:= TFONT():New("ARIAL",8 ,8 ,,.T.,,,,,.F.,.F.) ///Fonte 8 Negrito
	Private oFont10 	:= TFONT():New("ARIAL",10,10,,.F.,,,,,.F.,.F.) ///Fonte 10 Normal
	Private oFont10S	:= TFONT():New("ARIAL",10,10,,.F.,,,,,.T.,.F.) ///Fonte 10 Sublinhando
	Private oFont10N 	:= TFONT():New("ARIAL",10,10,,.T.,,,,,.F.,.F.) ///Fonte 10 Negrito
	Private oFont12		:= TFONT():New("ARIAL",12,12,,.F.,,,,,.F.,.F.) ///Fonte 12 Normal
	Private oFont12NS	:= TFONT():New("ARIAL",12,12,,.T.,,,,,.T.,.F.) ///Fonte 12 Negrito e Sublinhado
	Private oFont12N	:= TFONT():New("ARIAL",12,12,,.T.,,,,,.F.,.F.) ///Fonte 12 Negrito 
	Private oFont13		:= TFONT():New("ARIAL",13,13,,.F.,,,,,.F.,.F.) ///Fonte 13 Normal
	Private oFont13NS	:= TFONT():New("ARIAL",13,13,,.T.,,,,,.T.,.F.) ///Fonte 13 Negrito e Sublinhado
	Private oFont13N	:= TFONT():New("ARIAL",13,13,,.T.,,,,,.F.,.F.) ///Fonte 13 Negrito
	Private oFont14		:= TFONT():New("ARIAL",14,14,,.F.,,,,,.F.,.F.) ///Fonte 14 Normal
	Private oFont14NS	:= TFONT():New("ARIAL",14,14,,.T.,,,,,.T.,.F.) ///Fonte 14 Negrito e Sublinhado
	Private oFont14N	:= TFONT():New("ARIAL",14,14,,.T.,,,,,.F.,.F.) ///Fonte 14 Negrito
	Private oFont15		:= TFONT():New("ARIAL",15,15,,.F.,,,,,.F.,.F.) ///Fonte 15 Normal
	Private oFont15NS	:= TFONT():New("ARIAL",15,15,,.T.,,,,,.T.,.F.) ///Fonte 15 Negrito e Sublinhado
	Private oFont15N	:= TFONT():New("ARIAL",15,15,,.T.,,,,,.F.,.F.) ///Fonte 15 Negrito
	Private oFont16 	:= TFONT():New("ARIAL",16,16,,.F.,,,,,.F.,.F.) ///Fonte 16 Normal
	Private oFont16N	:= TFONT():New("ARIAL",16,16,,.T.,,,,,.F.,.F.) ///Fonte 16 Negrito
	Private oFont16NS	:= TFONT():New("ARIAL",16,16,,.T.,,,,,.T.,.F.) ///Fonte 16 Negrito e Sublinhado
	Private oFont16I	:= TFONT():New("ARIAL",16,16,,.F.,,,,,.F.,.T.) ///Fonte 16 Itálico
	Private oFont20N	:= TFONT():New("ARIAL",20,20,,.T.,,,,,.F.,.F.) ///Fonte 20 Negrito
	Private oFont22N	:= TFONT():New("ARIAL",22,22,,.T.,,,,,.F.,.F.) ///Fonte 22 Negrito
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Variveis para impressão                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	Private cStartPath   
	Private nMargemL    := 100  
	Private nMargemR    := 2400 
	Private nMargemT	:= 100
	Private nMargemB	:= 3400
	Private nCenterPg	:= 1200
	Private nLin 		:= 0    
	Private oPrint		:= TMSPRINTER():New("")
	Private nPag		:= 0   
	Private cPerg 		:= "VIT605"   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define Tamanho do Papel                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	#define DMPAPER_A4 9 //Papel A4
	oPrint:setPaperSize( DMPAPER_A4 )	
	//TMSPrinter(): SetPaperSize ()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria as perguntas na SX1                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	AjustaSx1()
	if !pergunte(cPerg,.T.) //Chama a tela de parametros
		Return
	endif     
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Orientacao do papel (Retrato ou Paisagem)                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	oPrint:SetPortrait()///Define a orientacao da impressao como retrato
	//oPrint:SetLandscape() ///Define a orientacao da impressao como paisagem 
	         
	DbSelectArea("SC2")
	SC2->(DbSetOrder(1))
	if !SC2->(Dbseek(xFilial("SC2")+MV_PAR01))
		MsgInfo("Ordem de Produção nao encontrada.")
		Return
	endif
	
	DbSelectArea("SB1") 
	SB1->(DbSetOrder(1))
	SB1->(Dbseek(xFilial("SB1")+SC2->C2_PRODUTO))
		        
	oPrint:StartPage() // Inicia uma nova pagina
	
	nLin := nMargemT
	ImpRel()
	nLin:= (nMargemB/2) //meio padina
	oPrint:Say(nLin, nCenterPg, Replicate(" -",90) , oFont10	,,,,2)
	nLin += nMargemT
	ImpRel()

	oPrint:EndPage() //finaliza pagina
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pre-visualiza a impressão 				                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	oPrint:Preview()	

Return 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o cabeçalho principal 				                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ImpRel()
	
	Local nDiv1 := 550
	Local nDiv2 := 1100
	Local nDiv3 := 1500
	Local nDiv4 := 1900
	Local nHeight1 := 0    
	
	cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
	cStartPath += If(Right(cStartPath, 1) <> "/", "/", "") 

	nHeight1 := nLin+310
	oPrint:Box(nLin,nMargemL, nHeight1, nMargemR)
	oPrint:Line(nLin, nMargemL+nDiv1, nHeight1, nMargemL+nDiv1)
	
	nLin+=10
	oPrint:SayBitmap(nLin, nMargemL+10, cStartPath + "lgrl01.bmp", 522, 136) //Impressao da Logo
	oPrint:Say(nLin, nCenterPg+(nDiv1/2), "ORDEM DE PRODUÇÃO", oFont14N,,,,2)
	
	nLin+=65
	oPrint:Line(nLin, nMargemL+nDiv1, nLin, nMargemR) 
	
	nLin+=10
	oPrint:Say(nLin, nMargemL+nDiv1+10, "Produto:", oFont14)
	oPrint:Say(nLin, nMargemL+nDiv1+210, Alltrim(SC2->C2_PRODUTO) + " - " + Alltrim(SB1->B1_DESC), oFont15N)
	oPrint:Say(nLin+10, nMargemR-10, "Rev.: " + SC2->C2_REVISAO, oFont12,,,,1)
	
	nLin+=70
	oPrint:Line(nLin, nMargemL, nLin, nMargemR) 
	oPrint:Say(nLin+10, nMargemL+(nDiv1/2), Alltrim(Transform(SC2->C2_QUANT, "@E 9,999,999,999")) + " " + SC2->C2_UM , oFont15N,,,,2)
	oPrint:Say(nLin+10, nMargemL+nDiv1+((nDiv2-nDiv1)/2), Alltrim(Transform(ConvUm(SB1->B1_COD,SC2->C2_QUANT,0,2), "@E 9,999,999,999")) + " " + Alltrim(Posicione("SAH",1,xFilial("SAH")+SC2->C2_SEGUM,"AH_DESCPO")) , oFont15N,,,,2)
	oPrint:Line(nLin, nMargemL+nDiv2, nHeight1, nMargemL+nDiv2)
	oPrint:Say(nLin+10, nMargemL+nDiv2+((nDiv3-nDiv2)/2), SubStr(DTOC(SC2->C2_DATPRI),4) , oFont15N,,,,2)
	oPrint:Line(nLin, nMargemL+nDiv3, nHeight1, nMargemL+nDiv3)
	oPrint:Say(nLin+10, nMargemL+nDiv3+((nDiv4-nDiv3)/2), SubStr(DTOC(SC2->C2_DTVALID),4) , oFont15N,,,,2)
	oPrint:Line(nLin, nMargemL+nDiv4, nHeight1, nMargemL+nDiv4)
	oPrint:Say(nLin+10, nMargemL+nDiv4+((nMargemR-(nMargemL+nDiv4))/2), Alltrim(SC2->C2_LOTECTL) , oFont15N,,,,2)
	
	nLin+=80
	oPrint:Line(nLin, nMargemL, nLin, nMargemR) 
	oPrint:Say(nLin+10, nMargemL+(nDiv1/2), "Qtde.Teórica (caixas)" , oFont13,,,,2)
	oPrint:Say(nLin+10, nMargemL+nDiv1+((nDiv2-nDiv1)/2), "Qtde.Teórica (unidades)", oFont13,,,,2)
	oPrint:Say(nLin+10, nMargemL+nDiv2+((nDiv3-nDiv2)/2), "Fabricação", oFont13,,,,2)
	oPrint:Say(nLin+10, nMargemL+nDiv3+((nDiv4-nDiv3)/2), "Validade", oFont13,,,,2)
	oPrint:Say(nLin+10, nMargemL+nDiv4+((nMargemR-(nMargemL+nDiv4))/2), "Lote", oFont13,,,,2)
	
	nLin+=140
	nHeight1 := nLin+650
	oPrint:Box(nLin, nMargemL, nHeight1, nMargemR)
	nLin+=10
	oPrint:Say(nLin, nCenterPg, "INFORMAÇÕES GERAIS" , oFont10N,,,,2)
	nLin+=60
	oPrint:Line(nLin, nMargemL, nLin, nMargemR) 

	nLin:= nHeight1+40
	nHeight1 := nLin+80
	nDiv1 := 1300
	nDiv2 := 1800
	
	oPrint:Box(nLin, nMargemL, nHeight1, nMargemR)
	oPrint:Say(nLin+30, nMargemL+10, "Resp. Emissão:" , oFont10)
	oPrint:Line(nLin, nMargemL+nDiv1, nHeight1, nMargemL+nDiv1)
	oPrint:Say(nLin+30, nMargemL+nDiv1+20, "Data:_____/_____/_____" , oFont10)
	oPrint:Line(nLin, nMargemL+nDiv2, nHeight1, nMargemL+nDiv2)
	oPrint:Say(nLin+30, nMargemL+nDiv2+20, "Hora Início:_____:_____" , oFont10)
	
	nLin+= 120
	nHeight1 := nLin+80
	oPrint:Box(nLin, nMargemL, nHeight1, nMargemR)
	oPrint:Say(nLin+30, nMargemL+10, "Resp. Recebimento:" , oFont10)
	oPrint:Line(nLin, nMargemL+nDiv1, nHeight1, nMargemL+nDiv1)
	oPrint:Say(nLin+30, nMargemL+nDiv1+20, "Data:_____/_____/_____" , oFont10)
	oPrint:Line(nLin, nMargemL+nDiv2, nHeight1, nMargemL+nDiv2)
	oPrint:Say(nLin+30, nMargemL+nDiv2+20, "Hora Início:_____:_____" , oFont10)
	
Return  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza as peguntas na tabela SX1      	                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function AjustaSX1()

	Local aHelpPor	:= {"Informe o numero da ordem de produção."}
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {}
	
	PutSx1( cPerg, "01","Ordem Prod. ?","Ordem Prod. ?","Ordem Prod. ?","mv_ch1","C",11,0,0,"G","","SC2","","",;
		"mv_par01"," ","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)	 
	
Return 

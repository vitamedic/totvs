#Include 'Protheus.ch'
#Include 'Colors.ch'
#Include 'Tbiconn.ch'       
#include "fileio.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VIT425    º Autor ³ Leandro Fiuza    º Data ³  22/05/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍ¹±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ EMS - Entrada de Mercadoria / Serviços					  º±±
±±º          ³                                                  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitapan                                        			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VIT425()  //U_VIT425()
Local aArea   		:= GetArea()
Local aOrd  			:= {}
Local cDesc1 			:= "EMS - Entrada de Mercadoria / Serviços."
Local cDesc2 			:= ""
Local cDesc3 			:= ""

Private nRowProd     := 0
Private nomeprog 		:= "VITEMS"
//Private cPerg    		:= "MTR170"
Private cPerg    		:= "VIT425"                               
//aReturn[4] 1- Retrato, 2- Paisagem
//aReturn[5] 1- Em Disco, 2- Via Spool, 3- Direto na Porta, 4- Email
Private aReturn  		:= {"Zebrado", 1,"Administracao", 2, 1, 1, "",1 }	//"Zebrado"###"Administracao"
Private nTamanho		:= "G"
Private wnrel        := "VITEMS"            //Nome Default do relatorio em Disco
Private cString     	:= "SF1"
Private titulo  		:= "EMS - Entrada de Mercadoria / Serviços"
Private nPage			:= 1
Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
Private oFont6N 		:= TFONT():New("ARIAL",7,6,,.T.,,,,.T.,.F.) ///Fonte 6 Negrito
Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
Private oFont8N 		:= TFONT():New("ARIAL",8,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
Private oFont10    	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 10 Normal
Private oFont10S		:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.T.) ///Fonte 10 Sublinhando
Private oFont10N 		:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.F.) ///Fonte 10 Negrito
Private oFont12		:= TFONT():New("Courier new",12,12,,.F.,,,,.T.,.F.) ///Fonte 12 Normal
Private oFont12NS		:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.T.) ///Fonte 12 Negrito e Sublinhado
Private oFont12N		:= TFONT():New("Courier new",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito
Private oFont14		:= TFONT():New("Courier new",14,14,,.F.,,,,.T.,.F.) ///Fonte 14 Normal
Private oFont14NS		:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.T.) ///Fonte 14 Negrito e Sublinhado
Private oFont14N		:= TFONT():New("Courier new",14,14,,.T.,,,,.T.,.F.) ///Fonte 14 Negrito
Private oFont16  		:= TFONT():New("ARIAL",16,16,,.F.,,,,.T.,.F.) ///Fonte 16 Normal
Private oFont16N		:= TFONT():New("Courier new",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
Private oFont16NS		:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.T.) ///Fonte 16 Negrito e Sublinhado
Private oFont20N		:= TFONT():New("ARIAL",20,20,,.T.,,,,.T.,.F.) ///Fonte 20 Negrito
Private oFont22N		:= TFONT():New("ARIAL",22,22,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito
Private nLin 			:= 0
Private nLin2        := 0
Private nLin3			:= 0
Private Cont			:= 0
Private wTotal		:= 0
Private numRpa 		:= 0
Public _oPrint
Private cLogoD
Private cStartPath 	:= GETPVPROFSTRING(GETENVSERVER(),"StartPath","ERROR",GETADV97())

cStartPath += IF(RIGHT(cStartPath,1) <> "\","\","")
//   cLogoD     := cStartPath + "LGRL" + cFilAnt + ".IBMP"
cLogoD     :=  "LGRLM" + cEmpAnt+ ".BMP"
//	path += IF(RIGHT(path,1) <> "\","\","")

/*Ajusta impressão para não sair desconfigurada*/
MakeDir("C:\totvs")

nHandle := FCreate("C:\totvs\erases.bat") 

FWrite(nHandle, "DEL %TEMP% \*.ini /Q")  

fclose(nHandle)                 

shellExecute("Open", "C:\totvs\erases.bat", " /k dir", "C:\", 0 )


//Incluo/Altero as perguntas na tabela SX1
 //AjustaSX1(cPerg)    

//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
 Pergunte(cPerg,.T.)    
    
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,nTamanho )

nOrdem :=  aReturn[8]


//GeraX1(cPerg)
//IIf(Pergunte(cPerg, .T.,"Parametros do Relatório",.F.),Nil,Nil) //aBRE OS PARAMETROS DUAS VEZES
//	SetDefault(aReturn,cString,,,nTamanho,,)   ABRE A TELA DO DIRETORIO PRA SALVAR SE É PREVIEW NAÕ TEM NECESSIDADE

If nLastKey==27
	dbClearFilter()
	Return
Endif

//RptStatus({|lEnd| lPrint(@lEnd,wnRel)},Titulo)  // Chamada do Relatorio  
RptStatus({|lEnd| lPrint(@lEnd,wnRel)},Titulo)  // Chamada do Relatorio

If !Empty(aArea)                                                     
	RestArea(aArea)
	//aArea
EndIf
return nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Layout do Relatorio                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function lPrint(lEnd,WnRel)

oPrint := TMSPrinter():New()
//_oPrint:Setup()
//oPrint:SetPortrait()
oPrint:SetLandscape()

If oPrint:nLogPixelY() < 300
	MsgInfo("Impressora com baixa resolução o modo de compatibilidade será acionado!")
	oPrint:SetCurrentPrinterInUse()
EndIf
//Chama função para buscar dados
Dados()
If Select("TEMP") > 0
	//Posiciona no inicio do arquivo
	TEMP->(DbGoTop())
	//Chama função para imprimir dados
	getHeader(@nPage)
	//quebraDePg(@nLin,@nPage)
endif
//footer(@nLin) //Rodape
oPrint:EndPage()
//TMP->(DbCloseArea())
oPrint:Preview()
//Libera o arquivo do relatório
MS_FLUSH()
Return Nil                         



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho do relatorio                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function getHeader(nPage)

dbselectarea("TEMP")
IF EMPTY(TEMP->f1_doc)
  MSGSTOP("ERRO NOS PARAMETROS !")
  RETURN .F.
ENDIF
cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")
nLin+=100

nLin+=100

oPrint:SayBitmap(20, 10, cStartPath + cLogoD , 300, 220)	///Impressao da Logo
nLin+=-180

//oPrint:Say(nLin,350, (SM0->M0_NOMECOM), oFont12N) Leandro
oPrint:Say(nLin,350, "Vitamedic Indústria Farmacêutica Ltda.", oFont12N)
oPrint:Say(nLin, 1500, "EMS - Entrada de Mercadoria / Serviços.", oFont12N) 
oPrint:Say(nLin, 2600,DTOC(DDATABASE), oFont10)
oPrint:Say(nLin, 2800, TIME(), oFont10)

nLin+=50
//oPrint:Say(nLin,800, (SM0->M0_NOMECOM), oFont12N)
oPrint:Say(nLin,350, ALLTRIM(SM0->M0_ENDCOB), oFont10N)
oPrint:Say(nLin,1200, ALLTRIM(SM0->M0_CIDCOB) +"-"+ALLTRIM(SM0->M0_ESTCOB), oFont10N)
nLin+=50
oPrint:Say(nLin, 350, TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont10N)
oPrint:Say(nLin, 1000, "N° NF: " + TEMP->f1_doc , oFont10N)

//oPrint:Say(nLin, 1800, "Pedido: " + TEMP->d1_pedido , oFont10N) 
oPrint:Say(nLin, 2800, "Emissão da Nf: " + Dtoc(TEMP->emissao) , oFont10N)

nLin+=150
//-------------------------------------------------------------------------------------//
oPrint:Box(250,10,400,1400)
oPrint:Box(250,10,400,3350)
oPrint:Say(nLin,20, ALLTRIM(" Razão Social: "), oFont10n)
oPrint:Say(nLin,320, TEMP->a2_nome, oFont10n)
nLin+=40
oPrint:Say(nLin,20, ALLTRIM(" Cód.Forn.:"), oFont10n)
oPrint:Say(nLin,270,  TEMP->a2_cod, oFont10n)
nLin+=40
oPrint:Say(nLin,20, ALLTRIM(" Tel.:"), oFont10n)
oPrint:Say(nLin,80, "(" + ALLTRIM(TEMP->a2_ddd) +") "+ ALLTRIM(TEMP->a2_tel)+ "     " + "CEP:" + ALLTRIM(TEMP->a2_cep) +"     "+ "CPF/CNPJ:" + ALLTRIM(TEMP->a2_cgc), oFont10n)
nLin+=-80
oPrint:Say(nLin,1410, ("  Dados Bancarios"), oFont10n)
nLin+=40
oPrint:Say(nLin,1410, ("  Banco: "), oFont10n)
oPrint:Say(nLin,1550, TEMP->a2_banco + " - " + TEMP->A6_NOME, oFont10n)		 
nLin+=40
oPrint:Say(nLin,1410, ("  Agência: "), oFont10n)
oPrint:Say(nLin,1580, TEMP->a2_agencia + "                              Conta: " + TEMP->a2_numcon + "                              Operação: " + TEMP->A2_OPCONTA + "  ", oFont10n)
//-------------------------------------------------------------------------------------//
nLin+=60

oPrint:Box(450,10,400,3350)
oPrint:Box(450,10,400,150)
oPrint:Say(nLin,20, (" Mat. "), oFont10n)
oPrint:Box(450,10,400,1000)
oPrint:Say(nLin,160, (" Descrição Material "), oFont10n)
oPrint:Box(450,10,400,1580)
oPrint:Say(nLin,1010, (" Texto Pedido "), oFont10n)
oPrint:Box(450,10,400,1690)
oPrint:Say(nLin,1580, (" Unid. "), oFont10n)
oPrint:Box(450,10,400,1950)
oPrint:Say(nLin,1700, (" Qtd. "), oFont10n)
oPrint:Box(450,10,400,2200) 
oPrint:Say(nLin,1950, (" Preço "), oFont10n)
oPrint:Box(450,10,400,2420)
oPrint:Say(nLin,2210, (" Total "), oFont10n)
oPrint:Box(450,10,400,2590)
oPrint:Say(nLin,2430, (" C.Custo "), oFont10n)
oPrint:Box(450,10,400,2830)
oPrint:Say(nLin,2600, (" C.Contábil "), oFont10n)
oPrint:Box(450,10,400,2980)
oPrint:Say(nLin,2840, (" Pedido "), oFont10n)
oPrint:Box(450,10,400,3100)
oPrint:Say(nLin,2990, (" Solic. "), oFont10n)
oPrint:Box(450,10,400,3350)
oPrint:Say(nLin,3110, (" Resp. "), oFont10n)

//-------------------------------------------------------------------------------------//
DbSelectArea("TEMP")
DbGotop()
dbSelectArea("SD1")
dbSetOrder(3)              
dbSeek(xFilial("SD1")+TEMP->F1_EMISSAO+TEMP->F1_DOC+TEMP->F1_SERIE+TEMP->F1_FORNECE+TEMP->F1_LOJA)	

nLin+=40
		
While !Eof() .And. D1_FILIAL+DTOS(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == ;
					xFilial("SD1")+TEMP->F1_EMISSAO+TEMP->F1_DOC+TEMP->F1_SERIE+TEMP->F1_FORNECE+TEMP->F1_LOJA
		
	oPrint:Box(nLin,10,400,150)   //Mat.
	oPrint:Say(nLin,20  , SD1->d1_cod    , oFont8n)
	
	oPrint:Box(nLin,10,400,1000)  //Descrição Material
	oPrint:Say(nLin,160 , SD1->d1_descpro, oFont8n)
	
	BuscaObs(sd1->d1_cod,sd1->d1_pedido) // Função para retornar Obs do pedido.
		
	If temp3->c7_obs == ''
	oPrint:Box(nLin,10,400,1580)  //Texto Pedido
	oPrint:Say(nLin,1010,'', oFont8n)
	else
	oPrint:Box(nLin,10,400,1580)  //Texto Pedido
	oPrint:Say(nLin,1010,temp3->c7_obs, oFont8n)
	EndIf
	
	oPrint:Box(nLin,10,400,1690)   //Unid.
	oPrint:Say(nLin,1640, SD1->d1_um     , oFont8n)
	
	oPrint:Box(nLin,10,400,1950)  //Qtd.
	oPrint:Say(nLin,1750, TRANSFORM(SD1->d1_quant,"@E 999,999,999.99"), oFont8n)

	oPrint:Box(nLin,10,400,2200)  //Preço 
	oPrint:Say(nLin,2000, TRANSFORM(SD1->d1_vunit,"@E 999,999,999.999999"), oFont8n)
	
	oPrint:Box(nLin,10,400,2420) //Total
	oPrint:Say(nLin,2250, TRANSFORM(SD1->d1_total,"@E 999,999,999.99")  , oFont8n)
	
	If SD1->d1_cc = ''
		oPrint:Box(nLin,10,400,2590) // C.Custo
		oPrint:Say(nLin,2430, ' ' , oFont8n)
	Else
		oPrint:Box(nLin,10,400,2590) // C.Custo
		oPrint:Say(nLin,2430, SD1->d1_cc, oFont8n)
	EndIf
	
	If SD1->d1_conta = ''
		oPrint:Box(nLin,10,400,2830) //C.Contábil
		oPrint:Say(nLin,2600, ' '  , oFont8n)
	Else
		oPrint:Box(nLin,10,400,2830) //C.Contábil
		oPrint:Say(nLin,2600, SD1->d1_conta  , oFont8n)		
	EndIf                                              
	                   
	If sd1->d1_pedido = ''
		oPrint:Box(nLin,10,400,2980) //Pedido
		oPrint:Say(nLin,2840, ' '  , oFont8n)
	Else
		oPrint:Box(nLin,10,400,2980) //Pedido
		oPrint:Say(nLin,2840,sd1->d1_pedido, oFont8n)                     
	EndIf
	
	If temp->d1_pedido <> ' '

	 BuscaSol(sd1->d1_pedido) //Função para retornar numero do pedido.
	
	 If sd1->d1_pedido = ''
		oPrint:Box(nLin,10,400,3100) //Solicitação
		oPrint:Say(nLin,2990, ' '  , oFont8n)
	 Else
		oPrint:Box(nLin,10,400,3100) //Solicitação
		oPrint:Say(nLin,2990,temp1->c1_num, oFont8n)
	 EndIf
	
	 BuscaUser(sd1->d1_pedido) //Função para retornar responsavel pela solicitação de compra.
		
	 If sd1->d1_pedido = ''
		oPrint:Box(nLin,10,400,3350) //Solicitante
		oPrint:Say(nLin,3110, ' '  , oFont8n)
	 Else
		oPrint:Box(nLin,10,400,3350) //Solicitante
		oPrint:Say(nLin,3110,temp2->c1_solicit, oFont8n)
		dbSelectArea("SD1")
	 EndIf
	Else
	 dbSelectArea("SD1")
	EndIf  
   
	// Quebrando pagina.
	nRowProd += 1 

	If nRowProd > 30 
		oPrint:EndPage() 
		oPrint:StartPage()           
		nRowProd := 0
		nLin:= 0
	Endif
    
dbSkip()
	
	nLin := nLin + 40
	
ENDDO

oPrint:Box(nLin,10,400,150)   //Mat.
oPrint:Box(nLin,10,400,1000)  //Descrição Material
oPrint:Box(nLin,10,400,1580)  //Texto Pedido
oPrint:Box(nLin,10,400,1690)  //Unid.
oPrint:Box(nLin,10,400,1950)  //Qtd.
oPrint:Box(nLin,10,400,2200)  //Preço
oPrint:Box(nLin,10,400,2420)  //Total
oPrint:Box(nLin,10,400,2590)  // C.Custo
oPrint:Box(nLin,10,400,2830)  //C.Contábil
oPrint:Box(nLin,10,400,2980)  //Pedido
oPrint:Box(nLin,10,400,3100)  //Solicitante
oPrint:Box(nLin,10,400,3350)  //Solicitante


//-------------------------------------------------------------------------------------//
DbSelectarea("TEMP")
DbGotop()
DbSelectarea("SF1")
DbsetOrder(1) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
DbSeek(xFilial("SF1")+TEMP->F1_DOC+TEMP->F1_SERIE+TEMP->F1_FORNECE+TEMP->F1_LOJA)

nLin2 := nLin + 40       
nLin2+= 80

oPrint:Box(nLin2,10,nLin2,3350)
oPrint:Box(nLin2,10,nLin2-40,220)  //Base ICMS
oPrint:Box(nLin2,10,nLin2-40,630)  //f1_baseicm
oPrint:Box(nLin2,10,nLin2-40,860)  //Valor ICMS
oPrint:Box(nLin2,10,nLin2-40,1300) //f1_valicm
oPrint:Box(nLin2,10,nLin2-40,1650) //ICMS base Subst
oPrint:Box(nLin2,10,nLin2-40,2000)
oPrint:Box(nLin2,10,nLin2-40,2350) //ICMS Valor Subst
oPrint:Box(nLin2,10,nLin2-40,2800)
oPrint:Box(nLin2,10,nLin2-40,2950) //Total
oPrint:Box(nLin2,10,nLin2-40,3350)
nLin2+= -40
oPrint:Say(nLin2,20, ALLTRIM(" Base ICMS: "), oFont10n)
oPrint:Say(nLin2,350, TRANSFORM(SF1->f1_baseicm,"@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,660, ALLTRIM(" Valor ICMS: "), oFont10n)
oPrint:Say(nLin2,980, TRANSFORM(SF1->f1_valicm,"@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,1310, ALLTRIM(" ICMS base Subst.: "), oFont10n)
oPrint:Say(nLin2,1800, TRANSFORM(SF1->f1_bricms, "@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,2010, ALLTRIM(" ICMS Valor Subst.: "), oFont10n)
oPrint:Say(nLin2,2500, TRANSFORM(SF1->f1_icmsret, "@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,2830, ALLTRIM(" Total: "), oFont10n)
oPrint:Say(nLin2,3100, TRANSFORM(SF1->f1_valmerc,"@E 999,999,999.99"), oFont8n)

nLin2+= 80

oPrint:Box(nLin2,10,nLin2,3350)
oPrint:Box(nLin2,10,nLin2-40,220)  //Desconto
oPrint:Box(nLin2,10,nLin2-40,630)  //f1_descont
oPrint:Box(nLin2,10,nLin2-40,860)  //Outros
oPrint:Box(nLin2,10,nLin2-40,1300)
oPrint:Box(nLin2,10,nLin2-40,1650) //Valor IPI
oPrint:Box(nLin2,10,nLin2-40,2000)  //f1_valipi
oPrint:Box(nLin2,10,nLin2-40,2350) //NF Total
oPrint:Box(nLin2,10,nLin2-40,3350) //f1_valbrut
nLin2+= -40
oPrint:Say(nLin2,20,   ALLTRIM(" Desconto: "), oFont10n)
oPrint:Say(nLin2,350,  TRANSFORM(SF1->f1_descont,"@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,660,  ALLTRIM(" Outros: "), oFont10n)
oPrint:Say(nLin2,980,  TRANSFORM(SF1->f1_despesa,"@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,1310, ALLTRIM(" Valor IPI: "), oFont10n)
oPrint:Say(nLin2,1800, TRANSFORM(SF1->f1_valipi,"@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,2010, ALLTRIM(" NF Total: "), oFont10n)
oPrint:Say(nLin2,2500, TRANSFORM(SF1->f1_valbrut,"@E 999,999,999.99"), oFont8n)

nLin2+= 80

oPrint:Box(nLin2,10,nLin2,3350)
oPrint:Box(nLin2,10,nLin2-40,220)    //INSS
oPrint:Box(nLin2,10,nLin2-40,530)    //f1_inss
oPrint:Box(nLin2,10,nLin2-40,660)    //Cof
oPrint:Box(nLin2,10,nLin2-40,860)    //f1_valcofi
oPrint:Box(nLin2,10,nLin2-40,950)    //PIS
oPrint:Box(nLin2,10,nLin2-40,1200)   //f1_valpis
oPrint:Box(nLin2,10,nLin2-40,1300)   //IR
oPrint:Box(nLin2,10,nLin2-40,1650) 	//f1_irrf
oPrint:Box(nLin2,10,nLin2-40,1800)   //CSLL
oPrint:Box(nLin2,10,nLin2-40,2000) 	//f1_valcsll
oPrint:Box(nLin2,10,nLin2-40,2200)   //ISSQN
oPrint:Box(nLin2,10,nLin2-40,2550) 	//f1_iss
oPrint:Box(nLin2,10,nLin2-40,2800)   //C/ISS
oPrint:Box(nLin2,10,nLin2-40,3350) 	 //f1_iss
nLin2+= -40
oPrint:Say(nLin2,20,   ALLTRIM(" INSS: "), oFont10n)
oPrint:Say(nLin2,300,  TRANSFORM(SF1->f1_inss,"@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,570,  ALLTRIM(" Cof: "), oFont10n)
oPrint:Say(nLin2,700,  TRANSFORM(SF1-> f1_valcofi,"@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,870,  ALLTRIM(" PIS: "), oFont10n)
oPrint:Say(nLin2,999,  TRANSFORM(SF1->f1_valpis,"@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,1230, ALLTRIM(" IR: "), oFont10n)
oPrint:Say(nLin2,1350, TRANSFORM(SF1->f1_irrf,"@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,1670, ALLTRIM(" CSLL: "), oFont10n)
oPrint:Say(nLin2,1850, TRANSFORM(SF1->f1_valcsll,"@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,2050, ALLTRIM(" ISSQN: "), oFont10n)
oPrint:Say(nLin2,2300, TRANSFORM(SF1->f1_iss,"@E 999,999,999.99"), oFont8n)
oPrint:Say(nLin2,2600, ALLTRIM(" C/ISS: "), oFont10n)
oPrint:Say(nLin2,3000, TRANSFORM(SF1->f1_iss,"@E 999,999,999.99"), oFont8n)

//---------------------------------TITULOS----------------------------------------------------//

nLin2+= 80

oPrint:Box(nLin2,10,nLin2,3350)
oPrint:Box(nLin2,10,nLin2-40,220) //Parc
oPrint:Box(nLin2,10,nLin2-40,630) //f1_baseicm
oPrint:Box(nLin2,10,nLin2-40,860)  //Vencimento
oPrint:Box(nLin2,10,nLin2-40,1300) //Forma Pagto
oPrint:Box(nLin2,10,nLin2-40,1600) //Dta. Pagamento
oPrint:Box(nLin2,10,nLin2-40,2225) //Hist. N° Borderô/Banco/Doc.Crédigo
oPrint:Box(nLin2,10,nLin2-40,2500) //Valor Titulo
oPrint:Box(nLin2,10,nLin2-40,2800) //Valor Juros
oPrint:Box(nLin2,10,nLin2-40,3100) //Valor Pago
oPrint:Box(nLin2,10,nLin2-40,3350) //Visto

nLin2+= -40

oPrint:Say(nLin2,20, (" Parc. "), oFont10n)
oPrint:Say(nLin2,300, ALLTRIM(" N° do Título "), oFont10n)
oPrint:Say(nLin2,650, ALLTRIM(" Vencimento "), oFont10n)
oPrint:Say(nLin2,900, ALLTRIM(" Forma Pagto "), oFont10n)
oPrint:Say(nLin2,1310, ALLTRIM(" Dta. Pagamento "), oFont10n)
oPrint:Say(nLin2,1610, ALLTRIM(" Hist. N° Borderô/Banco/Doc.Crédito "), oFont10n)
oPrint:Say(nLin2,2230, ALLTRIM(" Valor Título "), oFont10n)
oPrint:Say(nLin2,2530, ALLTRIM(" Valor Juros "), oFont10n)
oPrint:Say(nLin2,2810, ALLTRIM(" Valor Pago "), oFont10n)
oPrint:Say(nLin2,3150, ALLTRIM(" Visto "), oFont10n)


DbSelectarea("TEMP")
DbGotop()
dbSelectArea("SE2")
dbSetOrder(6)
dbSeek(xFilial("SE2")+TEMP->F1_FORNECE+TEMP->F1_LOJA+TEMP->F1_SERIE+TEMP->F1_DOC)

nLin2+= 40            

If empty(E2_FATURA)       //Gera as condições quando foi criado uma Fatura

While !Eof() .And. E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM == ;
		xFilial("SE2")+TEMP->F1_FORNECE+TEMP->F1_LOJA+TEMP->F1_SERIE+TEMP->F1_DOC					

		oPrint:Box(nLin2,10,nLin2+40,220)   //Parcela
		oPrint:Say(nLin2,20  , SE2->e2_parcela    , oFont8n)
		
		oPrint:Box(nLin2,10,nLin2+40,630)   //N° do Titulo
		oPrint:Say(nLin2,300  , SE2->e2_num   , oFont8n)
		
		oPrint:Box(nLin2,10,nLin2+40,860)   //Vencimento
		oPrint:Say(nLin2,650  , DTOC(SE2->e2_vencrea)    , oFont8n)
	                                                          
		oPrint:Box(nLin2,10,nLin2+40,1300)   //Forma Pagto
		oPrint:Say(nLin2,900  , " "    , oFont8n)
		
		oPrint:Box(nLin2,10,nLin2+40,1600)   //Dta. Pagamento
		oPrint:Say(nLin2,1310  , " "    , oFont8n)          
		
		oPrint:Box(nLin2,10,nLin2+40,2225)   //Hist. N° Borderô/Banco/Doc.Crédito
		oPrint:Say(nLin2,1610  , " "    , oFont8n)
		
		oPrint:Box(nLin2,10,nLin2+40,2500)   //Valor Titulo
		oPrint:Say(nLin2,2320  , TRANSFORM(SE2->e2_valor,"@E 999,999,999.99")   , oFont8n)

		oPrint:Box(nLin2,10,nLin2+40,2800)   //Valor Juros
		oPrint:Say(nLin2,2620  , TRANSFORM(SE2->e2_juros,"@E 999,999,999.99")   , oFont8n)
		
		oPrint:Box(nLin2,10,nLin2+40,3100)   //Valor Pago
		oPrint:Say(nLin2,2810  , " "   , oFont8n)
		                                             
		oPrint:Box(nLin2,10,nLin2+40,3350)   //Visto
		oPrint:Say(nLin2,3150  , " "   , oFont8n)
	
	dbSkip() 
	
	nLin2 := nLin2 + 40
ENDDO
Else    //Gera as condições quando foi criado uma Fatura
dbSeek(xFilial("SE2")+TEMP->F1_FORNECE+TEMP->F1_LOJA+"TT "+TEMP->F1_DOC)
While !Eof() .And. E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM == ;
		xFilial("SE2")+TEMP->F1_FORNECE+TEMP->F1_LOJA+"TT "+TEMP->F1_DOC 
							

		oPrint:Box(nLin2,10,nLin2+40,220)   //Parcela
		oPrint:Say(nLin2,20  , SE2->e2_parcela    , oFont8n)
		
		oPrint:Box(nLin2,10,nLin2+40,630)   //N° do Titulo
		oPrint:Say(nLin2,300  , SE2->e2_num + " /TT"  , oFont8n)
		
		oPrint:Box(nLin2,10,nLin2+40,860)   //Vencimento
		oPrint:Say(nLin2,650  , DTOC(SE2->e2_vencrea)    , oFont8n)
	                                                          
		oPrint:Box(nLin2,10,nLin2+40,1300)   //Forma Pagto
		oPrint:Say(nLin2,900  , " "    , oFont8n)
		
		oPrint:Box(nLin2,10,nLin2+40,1600)   //Dta. Pagamento
		oPrint:Say(nLin2,1310  , " "    , oFont8n)          
		
		oPrint:Box(nLin2,10,nLin2+40,2225)   //Hist. N° Borderô/Banco/Doc.Crédito
		oPrint:Say(nLin2,1610  , " "    , oFont8n)
		
		oPrint:Box(nLin2,10,nLin2+40,2500)   //Valor Titulo
		oPrint:Say(nLin2,2320  , TRANSFORM(SE2->e2_valor,"@E 999,999,999.99")   , oFont8n)

		oPrint:Box(nLin2,10,nLin2+40,2800)   //Valor Juros
		oPrint:Say(nLin2,2620  , TRANSFORM(SE2->e2_juros,"@E 999,999,999.99")   , oFont8n)
		
		oPrint:Box(nLin2,10,nLin2+40,3100)   //Valor Pago
		oPrint:Say(nLin2,2810  , " "   , oFont8n)
		                                             
		oPrint:Box(nLin2,10,nLin2+40,3350)   //Visto
		oPrint:Say(nLin2,3150  , " "   , oFont8n)
	
	dbSkip() 
	
	nLin2 := nLin2 + 40
ENDDO

EndIf



nLin2+= -40

oPrint:Box(nLin2,10,nLin2+250,3350) //Observação

nLin2+= 60

oPrint:Say(nLin2,20, (" Observação "), oFont10n)

nLin2+= 190

oPrint:Box(nLin2,10,nLin2+250,3350) //Emitente
oPrint:Box(nLin2,10,nLin2+250,670) //Contabilidade
oPrint:Box(nLin2,10,nLin2+250,1340) //Gestor Área
oPrint:Box(nLin2,10,nLin2+250,2010) //Diretoria
oPrint:Box(nLin2,10,nLin2+250,2680) //Contas a Pagar

nLin2+= 60
                                                                        
oPrint:Say(nLin2+40,20,  (" Emitente:_______________________ "), oFont10n)
oPrint:Say(nLin2+150,20, (" Data:          /         /          "), oFont10n)

oPrint:Say(nLin2+40,680,  (" Contabilidade:___________________ "), oFont10n)
oPrint:Say(nLin2+150,680, (" Data:          /         /          "), oFont10n)

oPrint:Say(nLin2+40,1350,  (" Gestor Área:_____________________ "), oFont10n)
oPrint:Say(nLin2+150,1350, (" Data:          /         /          "), oFont10n)

oPrint:Say(nLin2+40,2020,  (" Contr./Diret.:_____________________ "), oFont10n)
oPrint:Say(nLin2+150,2020, (" Data:          /         /          "), oFont10n)

oPrint:Say(nLin2+40,2690,  (" Contas a Pagar:__________________ "), oFont10n)
oPrint:Say(nLin2+150,2690, (" Data:          /         /          "), oFont10n)


 //U_VIT425()
Return Nil
                                            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca dados para tabela tempora
//ria                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Dados()
Local pedido := ""                                
Local fatura := ""

If funname() == "MATA103"
mv_par01 := _doc
mv_par02 := _serie
mv_par03 := _for
mv_par04 := _loja 
mv_par05 := _data

/*
mv_par01 := _data
mv_par02 := _data
mv_par03 := _doc
mv_par04 := _doc       
*/
EndIf

// Retorna numero do Pedido
cQryP := "select d1_pedido,d1_fornece,d1_loja "
cQryP += "from "+RetSqlName("sd1")+ " sd1 "
cQryP += "where sd1.d_e_l_e_t_ = ' ' and d1_doc ='"+mv_par01+"' and d1_serie='"+mv_par02+"'"
cQryP += "and d1_emissao = '"+dtos(mv_par05)+"'""

Memowrite('C:\TOTVS\VITEMSP.txt', cQryp)

//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
IF Select("TEMPP") <> 0
	DbSelectArea("TEMPP")
	DbCloseArea()
ENDIF

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQryP)),"TEMPP",.T.,.T.)  

pedido := TEMPP-> d1_pedido

// Retorna numero da fatura
cQryF := "select e2_num "
cQryF += "from "+RetSqlName("se2")+ " se2 "
cQryF += "where se2.d_e_l_e_t_ = ' ' and e2_num ='"+mv_par01+"' and e2_prefixo ='"+mv_par02+"' and e2_emissao ='"+dtos(mv_par05)+"' "
cQryF += "and e2_baixa = ' ' and e2_saldo > 0 and e2_valliq = 0 "
cQryF += "and e2_fornece = '"+tempp->d1_fornece+"' and e2_loja = '"+tempp->d1_loja+"'"

Memowrite('C:\TOTVS\VITEMSF.txt', cQryF)

//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
IF Select("TEMPF") <> 0
	DbSelectArea("TEMPF")
	DbCloseArea()
ENDIF

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQryF)),"TEMPF",.T.,.T.)  

fatura := TEMPF->e2_num

// Retorna as informações para EMS
cQry := "select "
cQry += "f1_doc,f1_serie,f1_fornece,f1_loja,f1_tipo, d1_pedido,  to_date(f1_emissao, 'yyyy-mm-dd')emissao,f1_emissao, a2_cod, a2_nome, a2_ddd, a2_tel, a2_cep, a2_cgc,"
cQry += "a2_banco, a2_agencia, a2_numcon,a2_opconta,a6_nome,d1_filial,d1_doc,d1_serie,d1_fornece,d1_loja,d1_item,d1_cod, d1_descpro, d1_um, d1_quant, d1_vunit,D1_EMISSAO,"
cQry += "d1_total, d1_cc, d1_conta, d1_ordem, f1_baseicm, f1_valicm, f1_valbrut, f1_descont,"
cQry += "f1_valipi, f1_inss, f1_valcofi, f1_valpis, f1_valcsll, f1_iss, f1_irrf "

if fatura <> " "
cQry += ",e2_prefixo,e2_num,e2_parcela,e2_tipo,e2_fornece,e2_loja,e2_parcela, e2_vencto, e2_baixa, e2_valor, e2_juros, e2_vencrea"
EndIf

//cQry += "(select c1_user from "+ RetSqlName("sc1")+" sc1 where sc1.d_e_l_e_t_ = ' ' and c1_pedido = d1_pedido and c1_loja = d1_loja) usuario "

if pedido <> " "
cQry += ",c1_user "
EndIf

cQry += "from " + RetSqlName("sf1")+ " sf1 "
cQry += "inner join sd1010 sd1 on sd1.d_e_l_e_t_ = ' ' and d1_doc = f1_doc and d1_loja = f1_loja and d1_emissao = f1_emissao "
cQry += "inner join sa2010 sa2 on sa2.d_e_l_e_t_ = ' ' and a2_cod = f1_fornece and a2_loja = f1_loja "
cQry += "left join sa6010 sa6 on sa6.d_e_l_e_t_ = ' ' and a6_cod = a2_banco "

If fatura <> " "
cQry += "inner join se2010 se2 on se2.d_e_l_e_t_ = ' ' and e2_num = f1_doc and e2_loja = f1_loja "
EndIf

If pedido <> " "
cQry += "inner join sc7010 sc7 on sc7.d_e_l_e_t_ <> '*' and c7_num = d1_pedido and c7_produto = d1_cod and c7_fornece = d1_fornece and c7_loja = d1_loja "
cQry += "inner join sc1010 sc1 on sc1.d_e_l_e_t_ = ' ' and c1_num = C7_NUMSC "
//cQry += "inner join sc1010 sc1 on sc1.d_e_l_e_t_ = ' ' and c1_pedido = d1_pedido " /*and c1_fornece = d1_fornece */
//cQry +="inner join sc1010 sc1 on sc1.d_e_l_e_t_ = ' ' and c1_produto = d1_cod and c1_fornece = d1_fornece and c1_loja = d1_loja "
EndIf

//cQry += "where sf1.d_e_l_e_t_ = ' ' and f1_doc = '"+mv_par03+"' and f1_doc = '"+mv_par04+"' and f1_emissao between '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"'" 
cQry += "where sf1.d_e_l_e_t_ = ' ' and f1_doc = '"+mv_par01+"' and f1_serie = '"+mv_par02+"' and f1_fornece = '"+mv_par03+"' and f1_loja = '"+mv_par04+"' and f1_emissao = '"+dtos(mv_par05)+"'"
cQry += "group by "
cQry += "f1_doc,f1_serie,f1_fornece,f1_loja,f1_tipo,f1_emissao, a2_cod, a2_nome, a2_ddd, a2_tel, a2_cep,f1_valcsll, f1_iss, f1_irrf," 
cQry += "f1_baseicm, f1_valicm, f1_valbrut, f1_descont,f1_valipi, f1_inss, f1_valcofi, f1_valpis,"
cQry += "a2_cgc,a2_banco, a2_agencia, a2_numcon,a2_opconta,a6_nome,d1_filial,"
cQry += "d1_doc,d1_serie,d1_pedido,d1_fornece,d1_loja,d1_item,d1_cod, d1_descpro, d1_um, d1_quant, d1_vunit,D1_EMISSAO,d1_total,d1_cc, d1_conta, d1_ordem" 

if fatura <> " "
cQry+=",e2_prefixo,e2_num,e2_parcela,e2_tipo,e2_fornece,e2_loja,e2_parcela, e2_vencto, e2_baixa,e2_valor, e2_juros, e2_vencrea"
EndIf

If pedido <> " "
cQry += ",c1_user" 
EndIf

Memowrite('C:\TOTVS\VITEMS.txt', cQry)

//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
IF Select("TEMP") <> 0
	DbSelectArea("TEMP")
	DbCloseArea()
ENDIF

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TEMP",.T.,.T.)  

Return

// Retorna codigo do usuario
Static Function BuscaSol(pedido)                                      

cQry1:= "select c1_num "
cQry1+= "from " + RetSqlName("sc1") + " sc1 "
cQry1+= "where c1_pedido =('"+cvaltochar(pedido)+"') "
cQry1+= "group by c1_num"

MemoWrit('C:\TOTVS\VITEMS1.txt', cQry1)

//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
IF Select("TEMP1") <> 0
	DbSelectArea("TEMP1")
	DbCloseArea()
ENDIF

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry1)),"TEMP1",.T.,.T.)

Return

// Retorna nome do usuario
Static Function BuscaUser(pedido)                                      

cQry1:= "select c1_solicit "
cQry1+= "from " + RetSqlName("sc1") + " sc1 "
cQry1+= "where c1_pedido =('"+cvaltochar(pedido)+"') "
cQry1+= "group by c1_solicit"

MemoWrit('C:\TOTVS\VITEMS2.txt', cQry1)

//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
IF Select("TEMP2") <> 0
	DbSelectArea("TEMP2")
	DbCloseArea()
ENDIF

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry1)),"TEMP2",.T.,.T.)

Return

// Retorna obs do pedido
Static Function BuscaObs(produto,pedido)

cQry1:= "select c7_obs "
cQry1+= "from " + RetSqlname("sc7") + " sc7 " 
cQry1+= "where c7_num ='"+pedido+"'
cQry1+= "and c7_produto ='"+produto+"'
cQry1+= "group by c7_obs"

MemoWrit('C:\TOTVS\VITEMS3.txt', cQry1)

//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
IF Select("TEMP3") <> 0
	DbSelectArea("TEMP3")
	DbCloseArea()
ENDIF

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry1)),"TEMP3",.T.,.T.)

Return 

//static function ajustaSx1(cPerg)  
///	PutSx1(cPerg,"01","Nfe ?"        ,'','',"mv_ch1","C",TamSx3 ("F1_DOC")[1]      ,0,,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
//	PutSx1(cPerg,"02","Serie ?"      ,'','',"mv_ch2","C",TamSx3 ("F1_SERIE")[1]    ,0,,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
//	PutSx1(cPerg,"03","Fornecedor ?" ,'','',"mv_ch3","C",TamSx3 ("F1_FORNECE")[1]  ,0,,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
//	PutSx1(cPerg,"04","Loja ?"  	  ,'','',"mv_ch4","C",TamSx3 ("F1_LOJA")[1]    ,0,,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
//	PutSx1(cPerg,"05","Data DE ?"	  ,".",".","mv_ch5","D",08,0,0,"G","","","","",,"mv_par05","","","","","","","","","","","","","","","","")
//return

static function ajustaSx1(cPerg)
_agrpsx1:={}

aadd(_agrpsx1,{cperg,"01","Nfe         ?","mv_ch1","C",TamSx3 ("F1_DOC")[1],0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),""})
aadd(_agrpsx1,{cperg,"02","Serie       ?","mv_ch2","C",TamSx3 ("F1_SERIE")[1],0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),""})
aadd(_agrpsx1,{cperg,"03","Fornecedor  ?","mv_ch3","C",TamSx3 ("F1_FORNECE")[1],0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"SA2"})
aadd(_agrpsx1,{cperg,"04","Loja        ?","mv_ch4","C",TamSx3 ("F1_LOJA")[1],0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),""})
aadd(_agrpsx1,{cperg,"05","Data DE     ?","mv_ch5","D",08,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),""})

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
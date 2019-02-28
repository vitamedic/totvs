#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#include "TbiConn.ch"
#INCLUDE "TOTVS.CH"  

#DEFINE CRLF CHR(10)+CHR(13)
#DEFINE SW_HIDE             0 // Escondido

/*/{Protheus.doc} Vit622

MarkBrowse Impressão de etiquetas

@author Danilo Brito
@since 19/04/2017
@version P12
@param Nao recebe parametros
@return nulo
/*/
User Function Vit622()
        
    Local nX := 1
	Private cAlias 	  	:= "SC9"
	Private cCadastro 	:= "Imprimir Etiquetas NF"
	Private aRotina 	:= {} 
	Private aIndexSC9   := {}
	Private bFiltraBrw	:= {|| Nil }  
	Private aCampos		:= {}
	Private cCondicao 	:= ""
	Private cPerg 		:= "VIT622"   
	
	Private oFWFilter
	Private oMark 
		
	AjustaSX1()
	if !(Pergunte(cPerg,.T.))
		Alert("Cancelado pelo usuario!")
		return
	endif 
                 
	dbSelectArea("SC9")
	cCondicao := " !empty(C9_NFISCAL) "	
	cCondicao += " .AND. C9_PEDIDO >= '"+MV_PAR01+"' .AND. C9_PEDIDO <= '"+MV_PAR02+"'"
	cCondicao += " .AND. DTOS(C9_DATASEP) >= '"+DTOS(MV_PAR03)+"' .AND. DTOS(C9_DATASEP) <= '"+DTOS(MV_PAR04)+"'"
	cCondicao += " .AND. C9_NFISCAL >= '"+MV_PAR05+"' .AND. C9_NFISCAL <= '"+MV_PAR06+"'"
	cCondicao += " .AND. (C9_CLIENTE+C9_LOJA) >= '"+MV_PAR07+MV_PAR08+"' .AND. (C9_CLIENTE+C9_LOJA) <= '"+MV_PAR09+MV_PAR10+"' "
	
	//restauro filtro
	bCondMark := "{|| " + cCondicao + " }"
	SC9->(DbSetFilter(&bCondMark,cCondicao))
	SC9->(dbGoTop())

 	//Construcao do MarkBrowse
	oMark := FWMarkBrowse():NEW() 
	
	//Define a tabela do MarkBrowse
	oMark:SetAlias("SC9")   
	
	//Define o titulo do MarkBrowse
	oMark:SetDescription(cCadastro)
	
	//Define Menu
	//oMark:AddButton("Imp.Etiqueta", {|| U_Vit622A() }, Nil, 2, 0 )
	AADD(aRotina,{"Imp.Etiqueta","U_Vit622A()", 0,2})
	
	//Define o campo utilizado para a marcacao
	oMark:SetFieldMark("C9_OK")  
	
 	//Define o filtro a ser aplicado no MarkBrowse
	//oMark:SetFilterDefault(cCondicao)
	oMark:DisableFilter()
 	
 	//Ativa Browse
	oMark:Activate()               
	
	//Destroi a MarkBrowse
	oMark:DeActivate()
	
	SC9->(DbClearFilter())	
	SC9->(DbGotop())

Return
      
//Chama tela de impressao
User Function Vit622A()

	Local aRet := GetImpWindows(.F.)
	Local cImpPad := ""
	Private oDlg01
	
	if len(aRet) > 0
		cImpPad := aRet[1]
	endif
	
	DEFINE MSDIALOG oDlg01 TITLE "Etiqueta NF Cliente" FROM 000, 000  TO 200, 370 COLORS 0, 16777215 PIXEL
	
	    @ 015, 007 SAY "Este programa irá imprimir etiqueta da NF do cliente," SIZE 180, 007 OF oDlg01 COLORS 0, 16777215 PIXEL
	    @ 025, 007 SAY "considerando os itens marcados no browse." SIZE 142, 007 OF oDlg01 COLORS 0, 16777215 PIXEL  
	    
	    @ 044, 007 SAY "Impressora:" SIZE 047, 007 OF oDlg01 COLORS 0, 16777215 PIXEL
	    @ 053, 007 SAY cImpPad SIZE 200, 007 OF oDlg01 COLORS 0, 16777215 PIXEL
	    //@ 053, 040 MSCOMBOBOX oComboBo1 VAR nPortaImp ITEMS _aPorta SIZE 050, 010 OF oDlg01 COLORS 0, 16777215 PIXEL
	    
	    DEFINE SBUTTON oSButton1 FROM 077, 115 TYPE 01 OF oDlg01 ENABLE ACTION (DoImpMark(),oDlg01:End())
	    DEFINE SBUTTON oSButton2 FROM 077, 150 TYPE 02 OF oDlg01 ENABLE ACTION oDlg01:End()
	
	ACTIVATE MSDIALOG oDlg01 CENTERED
	
Return    

Static Function DoImpMark() 
	
	Local nTotVol, nVol
	Local lInvert := oMark:IsInvert()
	Local cMark := oMark:Mark()
	
	//filtro so marcados pra não precisar percorrer tudo
	dbSelectArea('SC9') 
	if lInvert                    
		cCondMark := "C9_OK <> '"+cMark+"'"
	else
		cCondMark := "C9_OK == '"+cMark+"'"
	endif
	cCondMark += " .AND. "+cCondicao
	bCondMark := "{|| " + cCondMark + " }"
	SC9->(DbSetFilter(&bCondMark,cCondMark))
	
	SC9->(dbGotop())
	while SC9->(!Eof())

		if oMark:IsMark()
			
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
			nTotVol := 1
			if SB1->B1_CXPAD > 0
		    	nTotVol := Ceiling(SC9->C9_QTDLIB / SB1->B1_CXPAD)
		    else
		    	nTotVol := 1
		    endif 
			
		    for nVol:=1 to nTotVol
				DoProcImp(nVol,nTotVol)
			next nVol
		endif
		
		SC9->(dbSkip())
	enddo
    
    //restauro filtro
	bCondMark := "{|| " + cCondicao + " }"
	SC9->(DbSetFilter(&bCondMark,cCondicao))
	SC9->(dbGoTop())
	
Return

//Faz a busca dos dados e chama impressão da etiqueta
Static Function DoProcImp(nVol,nTotVol)  
	
	Local cTemp := GetTempPath() //obtem pasta temp
	Local cStrRun := "START /MIN NOTEPAD /P "
	Local cFile := "etiq_nf"+Alltrim(SC9->C9_NFISCAL)+"_"+DTOS(dDataBase)+strtran(Time(),":","")
	
	//montando string de impressão
	cVar := ""
	cVar += "^XA "
	cVar += "^MMT "
	cVar += "^PW831 "
	cVar += "^LL0504 "
	cVar += "^LS0 "
	
	//Código
	cVar += "^FT25,31^A0N,17,24^FDCODIGO^FS "
	cVar += "^FT25,114^A0N,87,86^FD"+SC9->C9_PEDIDO+SC9->C9_SEQUEN+"^FS "
	
	//Lote
	cVar += "^FT515,32^A0N,17,24^FDLOTE^FS "
	cVar += "^FT533,61^A0N,25,40^FD"+Alltrim(SC9->C9_LOTECTL)+"^FS "
	
	//Quantidade
	cVar += "^FT515,91^A0N,17,24^FDQTDE^FS "
	if SC9->C9_QTDLIB > 9999
		cVar += "^FT526,120^A0N,27,33^FD"+cValToChar(INT(SC9->C9_QTDLIB))+"^FS "
	else
		cVar += "^FT526,120^A0N,27,33^FD"+STRZERO(SC9->C9_QTDLIB,4)+"^FS "
	endif
	
	//Volume B1_CXPAD
	cVar += "^FT676,92^A0N,17,24^FDVOLUME^FS "
	cVar += "^FT674,121^A0N,27,33^FD"+STRZERO(nVol,4)+"^FS "
	cVar += "^FT674,141^A0N,17,19^FD"+cValtoChar(nTotVol)+" VOLUMES"+"^FS "
	
	//Produto
	cVar += "^FT25,163^A0N,16,16^FDPRODUTO^FS "
	cVar += "^FT23,194^A0N,32,28"+CRLF+"^FD"+Alltrim(SC9->C9_PRODUTO)+" - "+Alltrim(SubStr(SB1->B1_DESC,1,38))+"^FS "
	
	//Endereço DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
	cVar += "^FT675,164^A0N,18,16^FDLOCAL^FS "
	cVar += "^FT675,197^A0N,28,28^FD"+Alltrim(Posicione("SDB",1,xFilial("SDB")+SC9->C9_PRODUTO+SC9->C9_LOCAL+SC9->C9_NUMSEQ+SC9->C9_NFISCAL+SC9->C9_SERIENF,"DB_LOCALIZ"))+"^FS "
	
	//Cliente
	Posicione("SA1",1,xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,"A1_COD")
	cVar += "^FT25,223^A0N,16,16^FDCLIENTE^FS "
	cVar += "^FT25,246^A0N,21,21"+CRLF+"^FD"+SC9->C9_CLIENTE+SC9->C9_LOJA+" - "+Alltrim(SA1->A1_NOME)+"^FS "
	cVar += "^FT25,282^A0N,21,21"+CRLF+"^FD"+Alltrim(SA1->A1_END)+"^FS "
	cVar += "^FT25,310^A0N,21,21"+CRLF+"^FD"+Alltrim(SA1->A1_CEP)+" "+Alltrim(SA1->A1_MUN)+"^FS "
	cVar += "^FT678,307^A0N,93,91^FD"+SA1->A1_EST+"^FS "
	
	//Transportadora F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	cTransp := Posicione("SF2",1,xFilial("SF2")+SC9->C9_NFISCAL+SC9->C9_SERIENF,"F2_TRANSP")
	cVar += "^FT25,334^A0N,16,16^FDTRANSPORTADORA^FS "
	cVar += "^FT25,364^A0N,32,28"+CRLF+"^FD"+Alltrim(Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NREDUZ"))+"^FS "
	
	//Nota Fiscal
	cVar += "^FT675,334^A0N,18,16^FD"+"NF"+"^FS "
	cVar += "^FT675,364^A0N,28,28^FD"+SC9->C9_NFISCAL+"^FS "
	
	//Qr Code
	cVar += "^FT380,146 "
	cVar += "^BQN,2,3 " + CRLF
	cVar += "^FDMM,A"+;
				"DOC:"+Alltrim(SC9->C9_NFISCAL)+ CRLF+;
				"SERIE:"+Alltrim(SC9->C9_SERIENF)+ CRLF+;
				"PROD:"+Alltrim(SC9->C9_PRODUTO)+ CRLF+;
				"LOTE:"+Alltrim(SC9->C9_LOTECTL)+ CRLF+;
				"VENC:"+DTOC(SC9->C9_DTVALID)+;
			"^FS "
	
	cVar += "^FO20,369^GB830,0,3^FS "
	cVar += "^FO20,314^GB830,0,3^FS "
	cVar += "^FO20,203^GB830,0,3^FS "
	cVar += "^FO20,143^GB830,0,3^FS "
	cVar += "^FO508,66^GB323,0,3^FS "
	cVar += "^FO504,0^GB0,143,4^FS "
	cVar += "^FO665,66^GB0,137,4^FS "
	cVar += "^FO665,314^GB0,55,4^FS "
	cVar += "^PQ^S17^,0,1,Y "
	
	cVar += "^XZ"  + CRLF
	     
	//gravo arquivo txt 
	MemoWrite(cTemp+cFile+".txt", cVar)

	if File(cTemp+cFile+".txt")
		
		//monto arquivo bat
		cStrRun += cTemp+cFile+".txt " + CRLF
		cStrRun += "TIMEOUT /T 20 " + CRLF
		cStrRun += "DEL " + cTemp+cFile+".txt " + CRLF
		cStrRun += "DEL " + cTemp+cFile+".bat " + CRLF
		
		//gravo arquivo bat 
   		MemoWrite(cTemp+cFile+".bat", cStrRun)
		
		if File(cTemp+cFile+".bat")
			
			//WaitRun(cTemp+cFile+".bat", SW_HIDE )
            ShellExecute("Open", cFile+".bat", "", cTemp, SW_HIDE )
            
            Sleep(1000) //espera 1 segundo
            
		  	//FErase(cTemp+cFile+".bat")
		else
			FErase(cTemp+cFile+".txt") 
			MsgInfo("Não foi possível gerar arquivo de impressão em " + cTemp)
		endif
	else
		MsgInfo("Não foi possível gerar arquivo de impressão em " + cTemp)
	endif
	
Return


//ajusta as perguntas
Static Function AjustaSX1()  // cria a tela de perguntas

	Local aHelpPor	:= {}
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {}	
	
	PutSx1(cPerg,"01","Pedido De?","Pedido De?","Pedido De?","mv_ch1","C",6,0,0,"G","","SC5","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	PutSx1(cPerg,"02","Pedido Ate?","Pedido Ate?","Pedido Ate?","mv_ch2","C",6,0,0,"G","","SC5","","","MV_PAR02","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

	PutSx1(cPerg,"03","Dt.Separacao De?","Dt.Separacao De","Dt.Separacao De","mv_ch3","D",8,0,0,"G","","","","","MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	PutSx1(cPerg,"04","Dt.Separacao Ate?","Dt.Separacao Ate","Dt.Separacao Ate","mv_ch4","D",8,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
    
	PutSx1(cPerg,"05","Nota Fiscal De?","Nota Fiscal De","Nota Fiscal De","mv_ch5","C",9,0,0,"G","","SF2","","","MV_PAR05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	PutSx1(cPerg,"06","Nota Fiscal Ate?","Nota Fiscal Ate","Nota Fiscal Ate","mv_ch6","C",9,0,0,"G","","SF2","","","MV_PAR06","","","","ZZZZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

	PutSx1(cPerg,"07","Cliente De?","Cliente De?","Cliente De?","mv_ch7","C",6,0,0,"G","","SA1","","","MV_PAR07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	PutSx1(cPerg,"08","Loja De?","Loja De","Loja De","mv_ch8","C",2,0,0,"G","","","","","MV_PAR08","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

	PutSx1(cPerg,"09","Cliente Ate?","Cliente Ate?","Cliente Ate?","mv_ch9","C",6,0,0,"G","","SA1","","","MV_PAR09","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	PutSx1(cPerg,"10","Loja Ate?","Loja Ate?","Loja Ate?","mv_ch10","C",2,0,0,"G","","","","","MV_PAR10","","","","ZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return() 
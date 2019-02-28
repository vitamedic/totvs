#Include 'Protheus.ch'
 /*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RelEmOp   º Autor ³ Ricardo Fiuza    º Data ³  09/01/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍ¹±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Adiantamento								  º±±
±±º          ³                                                  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Softech                                        			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                   

User Function VIT421()
	Local aArea   			:= GetArea()
	Local aOrd  			:= {}
	Local cDesc1 			:= "Este programa tem como objetivo imprimir o Adiantamento"
	Local cDesc2 			:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3 			:= ""
    
	Private nomeprog 		:= "VIT421"
	Private cPerg    		:= "VIT421"
//aReturn[4] 1- Retrato, 2- Paisagem
//aReturn[5] 1- Em Disco, 2- Via Spool, 3- Direto na Porta, 4- Email
	Private aReturn  		:= {"Zebrado", 1,"Administracao", 1, 1, "1", "",1 }	//"Zebrado"###"Administracao"
	Private nTamanho		:= "M"
	Private wnrel        	:= "VIT421"            //Nome Default do relatorio em Disco
	Private cString     	:= "Z41"
	Private titulo  := "Adiantamento"
	Private nPage			:= 1
	Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
	Private oFont6N 	:= TFONT():New("ARIAL",7,6,,.T.,,,,.T.,.F.) ///Fonte 6 Negrito
	Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
	Private oFont8N 	:= TFONT():New("ARIAL",8,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
	Private oFont10    	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 10 Normal
	Private oFont10S	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.T.) ///Fonte 10 Sublinhando
	Private oFont10N 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.F.) ///Fonte 10 Negrito
	Private oFont12		:= TFONT():New("Courier new",12,12,,.F.,,,,.T.,.F.) ///Fonte 12 Normal
	Private oFont12NS	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.T.) ///Fonte 12 Negrito e Sublinhado
	Private oFont12N	:= TFONT():New("Courier new",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito
	Private oFont14		:= TFONT():New("Courier new",14,14,,.F.,,,,.T.,.F.) ///Fonte 14 Normal
	Private oFont14NS	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.T.) ///Fonte 14 Negrito e Sublinhado
	Private oFont14N	:= TFONT():New("Courier new",14,14,,.T.,,,,.T.,.F.) ///Fonte 14 Negrito
	Private oFont16  	:= TFONT():New("ARIAL",16,16,,.F.,,,,.T.,.F.) ///Fonte 16 Normal
	Private oFont16N	:= TFONT():New("Courier new",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
	Private oFont16NS	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.T.) ///Fonte 16 Negrito e Sublinhado
	Private oFont20N	:= TFONT():New("ARIAL",20,20,,.T.,,,,.T.,.F.) ///Fonte 20 Negrito
	Private oFont22N	:= TFONT():New("ARIAL",22,22,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito
	Private nLin 			:= 0
	Private wTotal			:= 0
	Private numRpa := 0
	Public _oPrint                
	Private cLogoD
	Private  cStartPath := GETPVPROFSTRING(GETENVSERVER(),"StartPath","ERROR",GETADV97())
         cStartPath += IF(RIGHT(cStartPath,1) <> "\","\","")
	//   cLogoD     := cStartPath + "LGRL" + cFilAnt + ".IBMP"
         cLogoD     :=  "LGRLM" + cEmpAnt+ ".BMP"
   //	path += IF(RIGHT(path,1) <> "\","\","")

   	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho )

	nOrdem :=  aReturn[8]
	GeraX1(cPerg)
	//If(Pergunte(cPerg, .T.,"Parametros do Relatório",.F.),Nil,Nil) aBRE OS PARAMETROS DUAS VEZES
 	   //	SetDefault(aReturn,cString,,,nTamanho,,)   ABRE A TELA DO DIRETORIO PRA SALVAR SE É PREVIEW NAÕ TEM NECESSIDADE 
 		If nLastKey==27
			dbClearFilter()
		Return
		Endif
		RptStatus({|lEnd| lPrint(@lEnd,wnRel)},Titulo)  // Chamada do Relatorio
		If !Empty(aArea)
			RestArea(aArea)
			aArea
		EndIf
	return nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Layout do Relatorio                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	Static Function lPrint(lEnd,WnRel)

		oPrint := TMSPrinter():New()
		//_oPrint:Setup()
		oPrint:SetPortrait()
		If oPrint:nLogPixelY() < 300
			MsgInfo("Impressora com baixa resolução o modo de compatibilidade será acionado!")
			oPrint:SetCurrentPrinterInUse()
		EndIf
	//Chama função para buscar dados
		Dados()
		If Select("QZ41") > 0
		//Posiciona no inicio do arquivo
			QZ41->(DbGoTop())
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

		dbselectarea("QZ41")                                

  			cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
			cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")
   			nLin+=100
  					
   			//oPrint:Line(nLin,150,nLin,2000)
   			oPrint:SayBitmap(150, 260, cStartPath + cLogoD , 400, 220)	///Impressao da Logo   
			nLin+=50 
			//VITAMEDIC INDÚSTRIA FARMACEUTICA LTDA
			//oPrint:Say(nLin,700, (SM0->M0_NOMECOM), oFont12N)
			/* Leandro 18/11/2016
			oPrint:Say(nLin,700, "VITAMEDIC INDÚSTRIA FARMACÊUTICA LTDA", oFont12N)
			oPrint:Say(nLin, 1650,DTOC(DDATABASE), oFont10)
			oPrint:Say(nLin, 1850, TIME(), oFont10)   
			*/
			nLin+=50
			//oPrint:Say(nLin,800, (SM0->M0_NOMECOM), oFont12N)
			/*
			oPrint:Say(nLin,700, ALLTRIM(SM0->M0_ENDCOB), oFont10N)
			oPrint:Say(nLin,1650, ALLTRIM(SM0->M0_CIDCOB) +"-"+ALLTRIM(SM0->M0_ESTCOB), oFont10N)
			*/
			nLin+=50
			//oPrint:Say(nLin, 700, TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont10N)
			nLin+=100
			//oPrint:Box(550,150,450,2300) 
			//oPrint:Say(nLin,160, ("Empresa: "), oFont14)
			//oPrint:Say(nLin,900, "VITAMEDIC INDÚSTRIA FARMACÊUTICA LTDA", oFont12)
			oPrint:Say(nLin,900,SM0->M0_NOMECOM, oFont12)			
			oPrint:Box(450,150,650,1300)
			oPrint:Box(450,1300,650,1650)  
			oPrint:Box(450,1650,650,2300)
			nLin+=120
			oPrint:Say(nLin,600, ("ADIANTAMENTO"), oFont12)  
			oPrint:Say(nLin,1300, "Valor:", oFont12)   //250 
			oPrint:Say(nLin,1710,  TRANSFORM(QZ41->Z41_VALOR,"@E 999,999.99"), oFont12N)  
			nLin+=60
			oPrint:Say(nLin,1300, "Data:", oFont12)   //250    
			oPrint:Say(nLin,1800,CVALTOCHAR(STOD(QZ41->Z41_LIMITE)), oFont12N)  
			nLin+=60
			oPrint:Say(nLin,550, "Despesas Diversas", oFont12)   //250  
			oPrint:Say(nLin,1300, "Data Limite:", oFont12)   //250   
			oPrint:Say(nLin,1800,CVALTOCHAR(STOD(QZ41->Z41_LIMITE)+VAL(QZ41->Z41_DIASAD)), oFont12N)  
			//oPrint:Say(nLin,1820,QZ41->Z41_NUM, oFont14)   //500 
			nLin+=90 
			oPrint:Box(650,150,1250,2300)	
			
			oPrint:Say(nLin,180, ("Nome"), oFont12) 
			oPrint:Say(nLin,370, substr(QZ41->Z41_NOMEFO,1,38), oFont12N)
			oPrint:Say(nLin,1370,("Departamento"), oFont12)    
			oPrint:Say(nLin,1700, substr(QZ41->Z41_DEPAR,1,22), oFont12N)
			
			nLin+=50		            
			oPrint:Say(nLin,180, ("Função"), oFont12)  
			oPrint:Say(nLin,370, QZ41->Z41_FUNCAO, oFont12N) 
			oPrint:Say(nLin,1370,("Destino"), oFont12)
			oPrint:Say(nLin,1700, QZ41->Z41_DEST, oFont12N)  
			nLin+=50
			oPrint:Say(nLin,180,"Motivo", oFont12)   			                                          
			oPrint:Say(nLin,370, substr(QZ41->Z41_MOTIVO,1,38), oFont12N)                                              
			oPrint:Say(nLin,1370,"Adiantamento para "+ QZ41->Z41_DIASAD + " dias.", oFont12)   			                                          
			nLin+=50   
			oPrint:Say(nLin,180, ("Período"), oFont12) 
			oPrint:Say(nLin,370, QZ41->Z41_PERIOD, oFont12N)   
		 	nLin+=50
			oPrint:Say(nLin,180, ("Observações"), oFont12) 
			
			nLin+=130
				
			//oPrint:Say(nLin,210, ("Autorizo o desconto em folha de pagamento, caso não acerte até a data limite"), oFont12) 

			nLin+=100 
			oPrint:Say(nLin,250, ("_________________"), oFont12) 
			oPrint:Say(nLin,750, ("_________________"), oFont12) 
			oPrint:Say(nLin,1350,("________________"), oFont12) 
			oPrint:Say(nLin,1800,("_________________"), oFont12) 	  
		   
		 	nLin+=50 
			oPrint:Say(nLin,300, ("Requisitante"), oFont12) 			          
			oPrint:Say(nLin,800, ("Superior"), oFont12) 		
			oPrint:Say(nLin,1400,"Tesouraria", oFont12)   		    
			oPrint:Say(nLin,1850, ("Ger. Financeiro"), oFont12)    
			nLin+=70
		    
			oPrint:Box(1280,150,1600,2300)
			nLin+=70				
		
	   		oPrint:Say(nLin,900, ("LANÇAMENTO CONTÁBIL"), oFont12N)    
	   		nLin+=50			          
			oPrint:Say(nLin,880, ("Lançamento da Solicitação"), oFont12) 
			nLin+=50		
			oPrint:Say(nLin,180,"Fornecedor", oFont12)  
			oPrint:Say(nLin,460, QZ41->Z41_CODFOR+"/"+QZ41->Z41_LOJA+" - "+QZ41->Z41_NOMEFO, oFont12N)
			oPrint:Say(nLin,1750,"Documento", oFont12)  		    
			oPrint:Say(nLin,2000, QZ41->Z41_PA, oFont12N) 
			nLin+=70
			oPrint:Say(nLin,880, ("Lançamento do Adiantamento"), oFont12)
			nLin+=50	
			oPrint:Say(nLin,180, ("Conta de Debito"), oFont12)      
			oPrint:Say(nLin,580, alltrim(QZ41->Z41_DEBITO)+"   "+SUBSTR(QZ41->Z41_NOMDEBITO,1,29), oFont12N) 
			oPrint:Say(nLin,1750,"Natureza:", oFont12) 
			oPrint:Say(nLin,2000, QZ41->Z41_NATURE, oFont12N)  
			nLin+=80                        
				
			oPrint:Box(1630,150,1940,2300)
			nLin+=50				
		
	   		oPrint:Say(nLin,900, ("DADOS BANCÁRIOS"), oFont12N) 
	   	//	oPrint:Say(nLin,1650, ("Documento_______________"), oFont12N)    
	   		nLin+=65			          
			oPrint:Say(nLin,180, ("Nome"), oFont12)  
			oPrint:Say(nLin,400, QZ41->Z41_NOMEFO, oFont12) 
//			oPrint:Say(nLin,1650, ("Data ___________________"), oFont12) 
			nLin+=65		
			oPrint:Say(nLin,180,"Banco", oFont12)  
			_Banc :=Posicione("SA2",1,"  "+QZ41->Z41_CODFOR+QZ41->Z41_LOJA,"A2_BANCO")
	        _NomBanc :=Posicione("SA6",1,"  "+_Banc,"A6_NOME")			
			oPrint:Say(nLin,400, _Banc+ "-" + _NomBanc, oFont12) 
			oPrint:Say(nLin,1200, ("Ag."), oFont12)   
			_Agen :=Posicione("SA2",1,"  "+QZ41->Z41_CODFOR+QZ41->Z41_LOJA,"A2_AGENCIA")
			oPrint:Say(nLin,1400, _Agen, oFont12)
			//oPrint:Say(nLin,1650, ("___________________"), oFont12) 
			nLin+=65			
			oPrint:Say(nLin,180, ("C/C."), oFont12)
			_Ccrr :=Posicione("SA2",1,"  "+QZ41->Z41_CODFOR+QZ41->Z41_LOJA,"A2_NUMCON")
			oPrint:Say(nLin,400, _Ccrr, oFont12) 
		 	oPrint:Say(nLin,1200, ("CPF/CNPJ "), oFont12)
		 	_CNPJf :=Posicione("SA2",1,"  "+QZ41->Z41_CODFOR+QZ41->Z41_LOJA,"A2_CGC")
			oPrint:Say(nLin,1420, TRANSFORM(_CNPJf,"@R 99.999.999/9999-99"), oFont12) 
			nLin+=110	
			oPrint:Say(nLin,180, ("1ª via Financeiro"), oFont8)
			nLin+=30
			oPrint:Say(nLin,180, REPLICATE("-", 500), oFont8)   
			
			////######SEGUNDA FOLHA /////############### 
			nLin+=50
			oPrint:SayBitmap(2100, 260, cStartPath + cLogoD , 400, 220)	///Impressao da Logo   
			nLin+=50
			/* Leandro 18/11/2016
			oPrint:Say(nLin,700, "VITAMEDIC INDÚSTRIA FARMACÊUTICA LTDA", oFont12N)
			oPrint:Say(nLin, 1650,DTOC(DDATABASE), oFont10)
			oPrint:Say(nLin, 1850, TIME(), oFont10)   
			*/
			nLin+=50
			//oPrint:Say(nLin,800, (SM0->M0_NOMECOM), oFont12N)
			/* Leandro 18/11/2016
			oPrint:Say(nLin,700, ALLTRIM(SM0->M0_ENDCOB), oFont10N)
			oPrint:Say(nLin,1650, ALLTRIM(SM0->M0_CIDCOB) +"-"+ALLTRIM(SM0->M0_ESTCOB), oFont10N)
			*/
			nLin+=50
			//oPrint:Say(nLin, 700, TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont10N)
			nLin+=100 
			//oPrint:Box(550,150,450,2300) 
			//oPrint:Say(nLin,160, ("Empresa: "), oFont14)
			oPrint:Say(nLin,900,"VITAMEDIC INDÚSTRIA FARMACÊUTICA LTDA", oFont12)			
			oPrint:Box(2380,150,2580,1300)
			oPrint:Box(2380,1300,2580,1650)  
			oPrint:Box(2380,1650,2580,2300)
			nLin+=120
			oPrint:Say(nLin,600, ("ADIANTAMENTO"), oFont12)  
			oPrint:Say(nLin,1300, "Valor:", oFont12)   //250 
			oPrint:Say(nLin,1710,  TRANSFORM(QZ41->Z41_VALOR,"@E 999,999.99"), oFont12N)  
			nLin+=60
			oPrint:Say(nLin,1300, "Data:", oFont12)   //250    
			oPrint:Say(nLin,1800,CVALTOCHAR(STOD(QZ41->Z41_LIMITE)), oFont12N)  
			nLin+=60
			oPrint:Say(nLin,550, "Despesas Diversas", oFont12)   //250  
			oPrint:Say(nLin,1300, "Data Limite:", oFont12)   //250   
			oPrint:Say(nLin,1800,CVALTOCHAR(STOD(QZ41->Z41_LIMITE)+VAL(QZ41->Z41_DIASAD)), oFont12N)  
			//oPrint:Say(nLin,1820,QZ41->Z41_NUM, oFont14)   //500 
			nLin+=90 
			oPrint:Box(2580,150,3180,2300)	
			
			oPrint:Say(nLin,180, ("Nome"), oFont12) 
			oPrint:Say(nLin,370, substr(QZ41->Z41_NOMEFO,1,38), oFont12N)
			oPrint:Say(nLin,1370,("Departamento"), oFont12)    
			oPrint:Say(nLin,1700, substr(QZ41->Z41_DEPAR,1,22), oFont12N)
			
			nLin+=50		            
			oPrint:Say(nLin,180, ("Função"), oFont12)  
			oPrint:Say(nLin,370, QZ41->Z41_FUNCAO, oFont12N) 
			oPrint:Say(nLin,1370,("Destino"), oFont12)
			oPrint:Say(nLin,1700, QZ41->Z41_DEST, oFont12N)  
			nLin+=50
			oPrint:Say(nLin,180,"Motivo", oFont12)   			                                          
			oPrint:Say(nLin,370, substr(QZ41->Z41_MOTIVO,1,38), oFont12N)                                              
			oPrint:Say(nLin,1370,"Adiantamento para "+ QZ41->Z41_DIASAD + " dias.", oFont12)   			                                          
			nLin+=50   
			oPrint:Say(nLin,180, ("Período"), oFont12) 
			oPrint:Say(nLin,370, QZ41->Z41_PERIOD, oFont12N)   
		 	nLin+=50
			oPrint:Say(nLin,180, ("Observações"), oFont12) 
			
			nLin+=130
				
			//oPrint:Say(nLin,210, ("Autorizo o desconto em folha de pagamento, caso não acerte até a data limite"), oFont12) 

			nLin+=100 
			oPrint:Say(nLin,250, ("_________________"), oFont12) 
			oPrint:Say(nLin,750, ("_________________"), oFont12) 
			oPrint:Say(nLin,1350,("________________"), oFont12) 
			oPrint:Say(nLin,1800,("_________________"), oFont12) 	  
		   
		 	nLin+=50 
			oPrint:Say(nLin,300, ("Requisitante"), oFont12) 			          
			oPrint:Say(nLin,800, ("Superior"), oFont12) 		
			oPrint:Say(nLin,1400,"Tesouraria", oFont12)   		    
			oPrint:Say(nLin,1850, ("Ger. Financeiro"), oFont12)    
			nLin+=70
			/*
		    
			oPrint:Box(2900,150,3210,2300)
			nLin+=50				
		
	   		oPrint:Say(nLin,750, ("DADOS BANCÁRIOS"), oFont12N) 
	   	//	oPrint:Say(nLin,1650, ("Documento_______________"), oFont12N)    
	   		nLin+=65			          
			oPrint:Say(nLin,180, ("Nome"), oFont12)  
			oPrint:Say(nLin,400, ("__________________________________________"), oFont12) 
//			oPrint:Say(nLin,1650, ("Data ___________________"), oFont12) 
			nLin+=65		
			oPrint:Say(nLin,180,"Banco", oFont12)  
			oPrint:Say(nLin,400, ("_________________________"), oFont12) 
			oPrint:Say(nLin,1200, ("Ag."), oFont12)
			oPrint:Say(nLin,1400, ("________________________"), oFont12)
			//oPrint:Say(nLin,1650, ("___________________"), oFont12) 
			nLin+=65			
			oPrint:Say(nLin,180, ("C/C."), oFont12)
			oPrint:Say(nLin,400, (" _______________________"), oFont12) 
		 	oPrint:Say(nLin,1200, ("CPF/CNPJ "), oFont12)
			oPrint:Say(nLin,1400, (" _________________________________"), oFont12) 
			//oPrint:Say(nLin,1860, (" Tesouraria"), oFont12)   
			//oPrint:Say(nLin,180, ("___________________________________________"), oFont12)    
			//oPrint:Say(nLin,1900, (" Caixa"), oFont12) 
			*/
			nLin+=80
			oPrint:Say(nLin,195, ("2ª via Requisitante"), oFont8)
			//nLin+=50
			//oPrint:Say(nLin,180, REPLICATE("-", 2000), oFont8)   
						
			//SF2->(reclock("SF2",.f.))
			//SF2->F2_IMPRES:="S"
			//SF2->(msunlock())		
				
	    //	cQry += "SELECT Z41_PA,Z41_EMISS,Z41_LIMITE,Z41_CODFOR,Z41_LOJA,Z41_NOMEFO,Z41_DEBITO,Z41_DIASAD,Z41_VALOR,Z41_NOMDEB,Z41_MOTIVO,Z41_FUNCAO,UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(Z41_OBS, 4000,1)) Z41_OBS "    //UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(Z41_OBS, 4000,1)) Z41_OBS
	Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca dados para tabela temporaria                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	Static Function Dados()
//Verifica se o arquivo TMP está em uso
		If Select("QZ41") > 0; QZ41->(DbCloseArea()); EndIf
			cQry := " "
			cQry += "SELECT Z41_PA,Z41_EMISS,Z41_LIMITE,Z41_CODFOR,Z41_LOJA,Z41_NOMEFO,Z41_DEBITO,Z41_DIASAD,Z41_VALOR,Z41_NOMDEB,Z41_MOTIVO,Z41_FUNCAO,Z41_PERIOD,Z41_DEST,Z41_DEPAR,Z41_NATURE "    //UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(Z41_OBS, 4000,1)) Z41_OBS
			cQry += "FROM " + retsqlname("Z41")+" Z41 "
			cQry += "WHERE D_E_L_E_T_ <> '*' "
			cQry += "AND Z41_PA = '" + mv_par01 + "' "
		
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"QZ41",.T.,.T.)
		Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera perguntas SX1                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		Static Function geraX1()
			Local aArea    := GetArea()
			Local aRegs    := {}
			Local i	       := 0
			Local j        := 0
			Local aHelpPor := {}
			Local aHelpSpa := {}
			Local aHelpEng := {}

			cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

			aAdd(aRegs,{cPerg,"01","Documento         ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","Z41"})
		
			dbSelectArea("SX1")
			dbSetOrder(1)
			For i:=1 to Len(aRegs)
				If !dbSeek(cPerg+aRegs[i,2])
					RecLock("SX1",.T.)
					For j:=1 to FCount()
						If j <= Len(aRegs[i])
							FieldPut(j,aRegs[i,j])
						Endif
					Next
					MsUnlock()
				Endif
			Next
			RestArea(aArea)
		Return

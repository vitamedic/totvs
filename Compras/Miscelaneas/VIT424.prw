#Include 'Protheus.ch'
 /*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VIT424    º Autor ³ Ricardo Fiuza    º Data ³  09/01/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍ¹±±
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍ±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Este programa tem como objetivo imprimir o SOPAG  		  º±±
±±º          ³                                                  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Softech                                        			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                     

User Function VIT424( )
	Local aArea   			:= GetArea()
	Local aOrd  			:= {}
	Local cDesc1 			:= "Este programa tem como objetivo imprimir o SOPAG "
	Local cDesc2 			:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3 			:= "" 
   
	Private _obs  := " "  
	Private _hist := " "    
	Private nomeprog 		:= "VIT424"
	Private cPerg    		:= "VIT424"
//aReturn[4] 1- Retrato, 2- Paisagem
//aReturn[5] 1- Em Disco, 2- Via Spool, 3- Direto na Porta, 4- Email
	Private aReturn  		:= {"Zebrado", 1,"Administracao", 1, 1, "1", "",1 }	//"Zebrado"###"Administracao"
	Private nTamanho		:= "M"
	Private wnrel        	:= "VIT424"            //Nome Default do relatorio em Disco
	Private cString     	:= "Z42"
	Private titulo  := "Solicitação de Pagamento - SOPAG"
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
			//aArea
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
		If Select("QZ42") > 0
		//Posiciona no inicio do arquivo
			QZ42->(DbGoTop())
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

		dbselectarea("QZ42")                                

  			cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
			cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")
   			nLin+=100
  			 			
   			nLin+=100  
   			//oPrint:Line(nLin,150,nLin,2000)
   			oPrint:SayBitmap(150, 260, cStartPath + cLogoD , 400, 220)	///Impressao da Logo   
			nLin+=50
			oPrint:Say(nLin,700,"VITAMEDIC INDÚSTRIA FARMACÊUTICA LTDA", oFont12N)
			oPrint:Say(nLin, 1650,DTOC(DDATABASE), oFont10)
			oPrint:Say(nLin, 1850, TIME(), oFont10)
   
			nLin+=50
			//oPrint:Say(nLin,800, (SM0->M0_NOMECOM), oFont12N)
			oPrint:Say(nLin,700, ALLTRIM(SM0->M0_ENDCOB), oFont10N)
			oPrint:Say(nLin,1650, ALLTRIM(SM0->M0_CIDCOB) +"-"+ALLTRIM(SM0->M0_ESTCOB), oFont10N)
			nLin+=50
			oPrint:Say(nLin, 700, TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont10N)
			nLin+=150 
			oPrint:Box(550,150,450,2300) 
			oPrint:Say(nLin,160, ("Empresa: "), oFont14)
			oPrint:Say(nLin,500, SM0->M0_CODFIL+" - VITAMEDIC INDÚSTRIA FARMACÊUTICA LTDA", oFont14)			
			nLin+=100  
			oPrint:Box(700,150,600,1600)
			oPrint:Box(700,1600,600,2300) 
			nLin+=30
			oPrint:Say(nLin,160, ("SOPAG - Solicitação de Pagamento "), oFont14) 
			oPrint:Say(nLin,1620, "Número:", oFont14)   //250
			oPrint:Say(nLin,1820,QZ42->Z42_NUM, oFont14)   //500 
			nLin+=70 
			oPrint:Box(800,150,700,500) 
			nLin+=30
			oPrint:Say(nLin,180, ("Empresa"), oFont14) 
			oPrint:Box(800,500,700,850)  		            
			oPrint:Say(nLin,570, ("Divisão"), oFont14) 
			oPrint:Box(800,850,700,1600)
			oPrint:Say(nLin,930,"Emitente", oFont14)   			
			oPrint:Box(800,1600,700,1950)    
			oPrint:Say(nLin,1690, ("Emissão"), oFont14)    
			oPrint:Box(800,1950,700,2300)   	
			oPrint:Say(nLin,1990, ("Vencimento"), oFont14) 
			
			oPrint:Box(900,150,800,500)
			oPrint:Box(900,500,800,850) 
			oPrint:Box(900,850,800,1600)
			oPrint:Box(900,1600,800,1950)
			oPrint:Box(900,1950,800,2300)
			nLin+=100 
			
			oPrint:Say(nLin,300, SM0->M0_CODFIL, oFont14N)				
			oPrint:Say(nLin,600, SM0->M0_CODFIL, oFont14N)				
			oPrint:Say(nLin,1000,cusername, oFont14N)	
			oPrint:Say(nLin,1650,CVALTOCHAR(STOD(QZ42->Z42_EMISSA)), oFont14N)   //Z42_EMISSA,Z42_VENCIM
			oPrint:Say(nLin,1980,CVALTOCHAR(STOD(QZ42->Z42_VENCIM)), oFont14N)							
			oPrint:Box(1000,150,900,1750)
			oPrint:Box(1000,1750,900,2300)
			nLin+=100 
			oPrint:Say(nLin,900, ("Fornecedor"), oFont14)
			oPrint:Say(nLin,1950, ("Valor"), oFont14)  
			
			oPrint:Box(1100,150,1000,1750)
			oPrint:Box(1100,1750,1000,2300)  
			nLin+=100 
			oPrint:Say(nLin,160, QZ42->Z42_CODFOR+"/"+QZ42->Z42_LOJA+" - "+QZ42->Z42_NOMEFO, oFont14N)
			oPrint:Say(nLin,1650,  TRANSFORM(QZ42->Z42_VALOR,"@E 999,999,999,999.99"), oFont14N)  
			
			nLin+=100
			oPrint:Box(1200,150,1100,1000) 
			oPrint:Box(1200,1000,1100,1300) 
			oPrint:Box(1200,1300,1100,1650) 		
			oPrint:Box(1200,1650,1100,1950)
			oPrint:Box(1200,1950,1100,2300)  
			 
			oPrint:Say(nLin,500, ("Banco"), oFont14) 
			oPrint:Say(nLin,1070, ("Agência"), oFont14)
			oPrint:Say(nLin,1400,"Digito", oFont14)   
			oPrint:Say(nLin,1700, ("Operação"), oFont14)				  	
			oPrint:Say(nLin,2040, ("Conta"), oFont14)
			nLin+=100 
			 
			_Banc :=Posicione("SA2",1,"  "+QZ42->Z42_CODFOR+QZ42->Z42_LOJA,"A2_BANCO")
			oPrint:Say(nLin,500, _Banc, oFont12)			 		            
		
			_Agen :=Posicione("SA2",1,"  "+QZ42->Z42_CODFOR+QZ42->Z42_LOJA,"A2_AGENCIA")
			oPrint:Say(nLin,1080, _Agen, oFont12)	
		
			_Ccrr :=Posicione("SA2",1,"  "+QZ42->Z42_CODFOR+QZ42->Z42_LOJA,"A2_NUMCON")
			oPrint:Say(nLin,2000, _Ccrr, oFont12) 
			
			oPrint:Box(1300,150,1200,1000) 	
			oPrint:Box(1300,1000,1200,1300)		            	                
			oPrint:Box(1300,1300,1200,1650)		
			oPrint:Box(1300,1650,1200,1950)  
			oPrint:Box(1300,1950,1200,2300)   	
			oPrint:Box(1450,150,1350,2300) 			
		
			nLin+=150	
			oPrint:Say(nLin,870, ("Informações para Contabilização"), oFont14)
                     
   			nLin+=100           
            
   			oPrint:Box(1550,150,1450,600) 
			oPrint:Say(nLin,260, "Debitar", oFont14) 
			oPrint:Box(1550,600,1450,900)  		            
			oPrint:Say(nLin,650, "Ordem", oFont14) 
			oPrint:Box(1550,900,1450,1350)
			oPrint:Say(nLin,900,"Centro de Custo", oFont14)   			
			oPrint:Box(1550,1350,1450,1750)    
			oPrint:Say(nLin,1420, "Valor", oFont14)    
			oPrint:Box(1550,1750,1450,1950)   	
			oPrint:Say(nLin,1780, "%", oFont14)
			oPrint:Box(1550,1950,1450,2300)   	
			oPrint:Say(nLin,1980, "Visto", oFont14)     			
			
			nLrat := 0 
			nLRet := 0   
			nRetl := 0
            //Começar o While
	
			DO WHILE !QZ42->( EOF() ) .And. QZ42->Z42_FILIAL+QZ42->Z42_NUM == xFilial("Z42")+mv_par01
				nLin+=100				
		   		oPrint:Box(1650 + nLrat - nLRet ,150,1550 + nLrat - nLRet,600) 
				oPrint:Say(nLin,200, QZ42->Z42_DEBITO, oFont14N) 
				oPrint:Box(1650 + nLrat - nLRet,600,1550 + nLrat - nLRet,900)  		            
				//oPrint:Say(nLin,580," " , oFont14) 
				oPrint:Box(1650 + nLrat - nLRet,900,1550+ nLrat - nLRet,1350)
				oPrint:Say(nLin,980,QZ42->Z42_CCUSTO, oFont14N)   			
				oPrint:Box(1650 + nLrat - nLRet,1350,1550+ nLrat - nLRet,1750)    
				oPrint:Say(nLin,1210, TRANSFORM(QZ42->Z42_VALORR,"@E 999,999,999,999.99"), oFont14N)    
				oPrint:Box(1650+ nLrat - nLRet,1750,1550+ nLrat - nLRet,1950)   	
				oPrint:Say(nLin,1750, TRANSFORM(QZ42->Z42_POR,"@R 999.99"), oFont14N)
				oPrint:Box(1650+ nLrat - nLRet,1950,1550 + nLrat - nLRet,2300)   	
				//oPrint:Say(nLin,1900, (""), oFont14)  
			
				nLin+=100
			
			   	oPrint:Box(1750 + nLrat - nLRet,150,1650 + nLrat - nLRet,900) 
				oPrint:Say(nLin,200,SUBSTR(QZ42->Z42_NOMDEB,1,24), oFont12) 
			    oPrint:Box(1750 + nLrat - nLRet,900,1650 + nLrat - nLRet,1650)  		            
				oPrint:Say(nLin,910,SUBSTR(QZ42->Z42_NOMCC,1,24) , oFont12) 
			   	oPrint:Box(1750 + nLrat - nLRet,1650,1650 + nLrat - nLRet,2300)
				//oPrint:Say(nLin,950,QZ42->Z42_CCUSTO, oFont14)  
				nLrat := nLrat + 200 
				_hist := QZ42->Z42_HISTOR
				_obs  := QZ42->Z42_OBS
				                         
				
				If nLrat > 1000 // veja o tamanho adequado da página que este numero pode variar
					oPrint:EndPage() // Finaliza a página
					oPrint:StartPage()
				  	nLrat := 0 
				   	nLRet  := 1300 
				    nLin := 200
				   
				Endif
				QZ42->(dbSkip())
			ENDDO
			
				nLrat := nLrat - 200
			nLin+=100

           //Fim do While 
           	dbselectarea("QZ42")
//           	DbSeek( xFilial("QZ42")+ MV_PAR01)
	//		 If empty()                           
     //          MsgInfo("SOPAG Inexistente, por favor veririque parametro !!")			 
    //         Else  //Final()
               oPrint:Say(nLin,630, SUBSTR(_hist,1,60), oFont14N)
	//		 EndIf                               
			 
			oPrint:Box(1850 + nLrat - nLRet,150,1750 + nLrat - nLRet,2300) 
			oPrint:Say(nLin,160, ("Histórico Razão: "), oFont14)
			

			nLin+=200

			oPrint:Say(nLin,920, ("Observações"), oFont14) 
			nLin+=50
			
			 
			//oPrint:Say(nLin,200,substr(OemToAnsi(MemoLine(_obs),1,40),oFont14N))   
			//nLin+=50
			//oPrint:Say(nLin,200,substr(OemToAnsi(MemoLine(_obs),40,80),oFont14N))
				
			oPrint:Box(1950 + nLrat - nLRet,150,2400 + nLrat - nLRet,2300) 						
				
			
		    //MlCount() -> conta quantas linhas com até 70 caracteres o campo memo possui.
			//Memoline() -> le e retorna a linha com ate 70 caracteres dentro do loop.
            
	//	 	If empty(mv_par01)  
		//   		MsgInfo("SOPAG Inexistente, por favor veririque parametro !!")			 
        //    Else  //Final() 
				For nXi := 1 To MLCount(_obs,50)
     	   			If ! Empty(MLCount(_obs,50))
     		
         		 	If ! Empty(MemoLine(_obs,50,nXi))
               			oPrint:Say(nLin,200,OemToAnsi(MemoLine(_obs,50,nXi)),oFont14N)
               			nLin+=50 
               			nRetl+=50 
         		 	EndIf
     			EndIf
				Next nXi     
	//		EndIf

				nLin+=400 - nRetl
			oPrint:Box(2500 + nLrat - nLRet,150,2400 + nLrat - nLRet,520) 
			oPrint:Say(nLin,189, ("Solicitante"), oFont14) 
			oPrint:Box(2500 + nLrat - nLRet,520,2400 + nLrat - nLRet,900)  		            
			oPrint:Say(nLin,610, ("Gerência"), oFont14) 
			oPrint:Box(2500+ nLrat - nLRet,900 ,2400 + nLrat - nLRet,1280)
			oPrint:Say(nLin,925,"Contr./Diret.", oFont14)   			
			oPrint:Box(2500+ nLrat - nLRet,1280,2400 + nLrat - nLRet,1630)    
			oPrint:Say(nLin,1330, ("Financeiro"), oFont14)    
			oPrint:Box(2500+ nLrat - nLRet,1630,2400 + nLrat - nLRet,1980)   	
			oPrint:Say(nLin,1650, ("Cx.Cta.Pag"), oFont14)
			oPrint:Box(2500+ nLrat - nLRet,1980,2400 + nLrat - nLRet,2300)   	
			oPrint:Say(nLin,1990, ("Procurador"), oFont14)
			
			
			oPrint:Box(2600 + nLrat - nLRet,150,2500 + nLrat - nLRet,520) 		
			oPrint:Box(2600 + nLrat - nLRet,520,2500 + nLrat - nLRet,900)             		
			oPrint:Box(2600 + nLrat - nLRet,900,2500 + nLrat - nLRet,1280)		
			oPrint:Box(2600 + nLrat - nLRet,1280,2500 + nLrat - nLRet,1630)  		
			oPrint:Box(2600 + nLrat - nLRet,1630,2500 + nLrat - nLRet,1980)  	
			oPrint:Box(2600 + nLrat - nLRet,1980,2500 + nLrat - nLRet,2300)   	
			/*	
			
			SF2->(reclock("SF2",.f.))
			SF2->F2_IMPRES:="S"
			SF2->(msunlock())		
			*/	
	
	Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca dados para tabela temporaria                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	Static Function Dados()

//Verifica se o arquivo TMP está em uso
		If Select("QZ42") > 0; QZ42->(DbCloseArea()); EndIf
			cQry := "SELECT "
			cQry += "Z42_FILIAL,Z42_NUM,Z42_EMISSA,Z42_VENCIM,Z42_CODFOR,Z42_LOJA,Z42_NOMEFO,Z42_VALOR,Z42_ITEM,Z42_DEBITO,Z42_NOMDEB,Z42_CCUSTO,Z42_NOMCC,Z42_VALORR,Z42_HISTOR,Z42_POR,UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(Z42_OBS, 4000,1)) Z42_OBS "
			cQry += "FROM " + retsqlname("Z42")+" Z42 "
			cQry += "WHERE D_E_L_E_T_ <> '*' "
/*			If empty(mv_par01)
				cQry += "AND Z42_NUM = '" + mv_par01 + "' "
			Else */
				cQry += "AND Z42_NUM = '" + Z42->Z42_NUM + "' "
//			EndIf
			Memowrite('C:\stephen\vit424.txt', cQry)
			If !Alltrim(RETCODUSR()) $ getmv("mv_sopuser") //('000004','000504','000445')
			 cQry += "AND Z42_XUSER ='" +RETCODUSR()+ "' "
		    EndIf
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"QZ42",.T.,.T.)
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

			aAdd(aRegs,{cPerg,"01","Documento         ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","Z42"})
		
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

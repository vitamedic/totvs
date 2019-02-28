/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ VIT386   º Autor ³ Welinton Fernandes º Data ³  30/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importação de XML gerando uma pre-nota de entrada automati º±±
±±º          ³ camente
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³ 28/08/2013 - André Almeida Alves  - Rotina adequeda para   º±±
±±º          ³              atender a situação da Vitapan Industria Farm. º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#Include 'Protheus.ch'
#Include 'Totvs.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "XMLXFUN.CH"
#include "ap5mail.ch"
#INCLUDE "TBICONN.CH"
#include "fileio.ch"

User Function vit387()
	Private oLeXml
     
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Montagem da tela de processamento.                                  ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     
	@ 200,1 TO 380,380 DIALOG oLeXml TITLE OemToAnsi("Leitura dos Arquivos XML")
	@ 02,10 TO 080,190
	@ 10,018 Say " Este programa ira importar o conteudo dos arquivos XML´s,"
	@ 18,018 Say " da   pasta  padrao  definida  no   parametro  MV_IMPXML."
	@ 26,018 Say " Ao Final caso ocorra erros, será gerado um log no disco C:"
     
	@ 60,128 BMPBUTTON TYPE 01 ACTION Processa( {|| LEXML() } )
	@ 60,158 BMPBUTTON TYPE 02 ACTION Close(oLeXml)
     
	Activate Dialog oLeXml Centered
Return .t.

Static Function LEXML()

	Local cAREA := GETAREA()
    
	Private _nI, nTotItem
	Private _aItems
	Private oXML
    
	Private aReg        :={}
	Private _aItems     :={}
	Private aCabNE      :={}
	Private aItemNe     :={}
	Private _aNfSaida	   :={}
    
	Private nXmlStatus  	:= 0
	Private nTotItem    	:= 0
	Private nI          	:= 0
	Private nQtde       	:= 0
	Private nUnitar     	:= 0
	Private nTotal      	:= 0
    
	Private cItem       	:= ""
	Private cArqXml     	:= ""
	Private cCodEan     	:= ""
	Private cProduto    	:= ""
	Private cModelo     	:= ""
	Private cXml        	:= "" , oXml
	Private cNota       	:= ""
	Private cCnpjFor    	:= ""
	Private cCodFor     	:= ""
	Private cLojaFor    	:= ""
	Private cUm         	:= ""
	Private cNfOri      	:= ""
	Private cSeriOri    	:= ""
	Private _cLog       	:= ""
	Private cProduto    	:= ""
	Private cDescpr     	:= ""
	Private cMarca      	:= ""
	Private cSegum      	:= ""
	Private cCC         	:= ""
	Private cLocal      	:= ""
	Private cDtvalid    	:= ""
	Private lOkArquivo  	:= .f.
	Private lMSErroAuto	:= .F.
	Private lMSHelpAuto 	:= .F.
	Private cOutSaid		:= .f.   //Caso verdadeiro a NF de saida não e de vendas.
	Private cVendas      := .f.
	
	cFatura				:= SPACE(15)
	_msgX					:= ""
	_cTes                := ""
	_lCopi					:= .t.
	lLog 					:= .f.
	_cCombo				:= ""
	_nPesoCte				:= 0
	_cTipFrete				:= ""
	nValCarga				:= 0
	
	//Fecha a tela informativa de confirmacao da rotina
	Close(oLeXml)
	
    // carrega o array _aItems com os nomes de todos os arquivos do diretorio
	_cPath := GETMV("MV_IMPXML")
	aDIR(_cPath+"*.XML",_aITEMS)

	//Cria diretorio com nome da fatura para armazenar os arquivos XML.
	if !EXISTDIR("\cte\"+alltrim(cusername)+"-"+dtos(ddatabase)+"-"+strtran(time(),":",""))
		if MakeDir("\cte\"+alltrim(cusername)+"-"+dtos(ddatabase)+"-"+strtran(time(),":","")) <> 0
			Alert("Não foi possível criar o diretório: "+CURDIR()+"\cte\"+alltrim(cusername)+"-"+dtos(ddatabase)+"-"+strtran(time(),":","")+". Verifique! "+cValToChar(FError()))
			return()
		else
			_cDirFat	:= "\cte\"+alltrim(cusername)+"-"+dtos(ddatabase)+"-"+strtran(time(),":","")+"\"
		endif
	else
		Alert("Diretorio ja Existe.")
	endif
	
	// Processa todas as NFEs do Diretorio
	For nArqXml := 1 To Len(_aItems)
		
		_nPsCBcte	:= 0
		_nPsCte	:= 0
		_nVolCTe	:= 0
				
		incproc("Importando arquivo XML......")
		 
		lOkArquivo  := .f.
		aItemNe := {}
		MoveOK := MoveArq()
		If MoveOK
			// Capture o Nome do Arquivo em Formato XML	
			cArqXml := _cDirFat+_aItems[nArqXml]
	
			cError   := ""
			cWarning := ""
					
			//Gera o Objeto XML
			oXml := XmlParserFile( cArqXml, "_", @cError, @cWarning )
														
			// Verificacao se a leitura foi ok. -  0=OK, 1=Arquivo nao Encontrado, 2=Erro de Abertura, 3=Xml Invalido, -1= Erro no NOD
			nStatus := @cError
		Else
			MSGSTOP("Problemas para Copiar o Arquivo, Verifique!")
			return()
		Endif
					
		If !empty(nStatus)
			MSGSTOP("O Arquivo: " + cArqXml + " esta com Problemas.  ->  "+nStatus)
			_MsgInv := "O Arquivo: " + cArqXml + " esta com Problemas.  ->  "+nStatus
			_msgX	+= _MsgInv+CHR(13)+CHR(10)
			lLog := .t.
			_WriteLog(_MsgInv)
			lGrava := .F.
			incproc()
			Loop
		EndIf
		
		// Verificacao se O CTE e' para a empresa corrente
		cCnpjEmp := (oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT)
		If Alltrim(cCnpjEmp) <> Alltrim(SM0->M0_CGC)
			MSGSTOP("A NFE: "+ cArqXml + " não é Destinada Para esta Empresa Corrente: "+SM0->M0_CODIGO +"-"+SM0->M0_FILIAL+" "+SM0->M0_NOME)
			RESTAREA(cAREA)
		Return
		EndIf
		
		// Totais de Itens da NFE
		// Antes, verifico se os itens vem numa variavel tipo array ou nao 

		aNfsCte	:= XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE:_REM, "_INFNFE") 
		_cChDoc	:= "1" 
		cTpCte     := ""  //N-Normal C-Complementar A-Outros		
		
		if aNfsCte == nil
			aNfsCte	:= XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE:_REM, "_INFNF")
			_cChDoc	:= "2" //Xml utiliza numero e serie das notas.
		endif
		
		if XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE,"_INFCTENORM") <> nil .and. (oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TPCTE:TEXT)=="0" //XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IDE,"_TPCTE")=="0"  //(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TPCTE:TEXT)=="0"
			cTpCte := "N"
		else
			if XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE, "_INFCTECOMP") <> nil .and. XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IDE,"_TPCTE")=="2"//(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TPCTE:TEXT)=="2"
				cTpCte := "C"
			else
				cTpCte := "A"
			endif
		endif
		
	    
		
		if cTpCte == "N"
			aNfsCte	:= XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC, "_INFNFE")
			_cChDoc	:= "1"
		else	
			if cTpCte == "C"
				aNfsCte	:= XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTECOMP:_INFDOC, "_INFNFE")
			endif
		endif
		
		/*if aNfsCte == nil .and. XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE, "_INFCTENORM") <> nil	 
	   		aNfsCte	:= XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC, "_INFNFE")   //RICARDO FIUZAS  30/05/14
	   			if aNfsCte == nil	 
	   				aNfsCte	:= XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTECOMP:_INFDOC, "_INFNFE")   //RICARDO FIUZAS  30/05/14
	   			endif
	   		//infCteComp = tratar quando for cte complementar
	   		_cChDoc	:= "1" //Xml utiliza as chaves da NF
		endif*/                                  			
		
		If VALTYPE(aNfsCte) = "A"
			nTotItem 	:= len(aNfsCte)
		Else
			nTotItem := 1
			
		EndIf

		_aNfSaida	:=ARRAY(nTotItem,4)
		// Array para os Itens do CTe
		aItemNE:={} 				
		// Dados do Fornecedor 
	
		//	aCnpjCli	:= XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE:_REM, "_CNPJ")  
		//If aCnpjCli <> nil
		 
//***************************** Leandro 08/09/2016 ******************************************
		_cCnpjCli	:= XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE,"_DEST")  // "_RECEB"
		cClient     := ""
 	   	cLojaCli    := ""	    	
 
		If _cCnpjCli <> nil	
	   	  	cCnpjCli 	:= (oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT)
//			cClient     := Posicione("SF2",1,xFilial("SF2")+Alltrim(_aNfSaida[_nIa][2])+"2  ",'F2_CLIENTE')
// 	    	cLojaCli    := Posicione("SF2",1,xFilial("SF2")+Alltrim(_aNfSaida[_nIa][2])+"2  ",'F2_LOJA')
// 	    	if cClient == nil 	  
// 	    		cClient     := Posicione("SA1",3,xFilial("SA1")+cCnpjCli,'A1_COD')
// 	    		cLojaCli    := Posicione("SA1",3,xFilial("SA1")+cCnpjCli,'A1_LOJA')
// 	    	endif
 	    Else
 			cCnpjCli 	:= ""
//			cClient     := ""
// 	    	cLojaCli    := ""	    	
 	    EndIf	

//*************************************************************************************** 	      	
//		EndIf
		
		
		cCnpjFor 	:= (oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
		cFornece 	:= Posicione("SA2",3,xFilial("SA2")+cCnpjFor,'A2_COD')
		if empty(cFornece)
			msgstop("Fornecedor nao Cadastrado CNPJ:"+cCnpjFor + chr(13) + "Faça o cadastro  e tente novamente!!")
			return .f.
		endif
		cLojaFor 	:= Posicione("SA2",3,xFilial("SA2")+cCnpjFor,'A2_LOJA')
		cNumCte	:= Padl(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT,9,"0")
		//cTpCte		:= iif((oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TPCTE:TEXT)=="0","N",iif((oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TPCTE:TEXT)=="2","C","A"))          //diferenciar CTES de COMPLEMENTO 20/03/2017  Luiz Fiuza
		cSerieCte	:= Padl(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:TEXT,3,"0")   
//		if cTpCte == "N"
//		dPrevEnt    := STOD(STRTRAN((oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFMODAL:_RODO:_DPREV:TEXT),"-",""))
//		endif
		dEmissao	:= STOD(STRTRAN((oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT),"-",""))
		nValorUn	:= VAL((oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT))
		cChaveCte	:= (oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT)
		_cDest		:= (oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT)
		cSuframa	:= Posicione("SA1",3,xFilial("SA1")+(oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT),'A1_CALCSUF')
		nPerIcm		:= XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS, "_ICMS00")
		uforig		:= (oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFINI:TEXT)
		ufdest		:= (oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFFIM:TEXT)
		munorig		:= (oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNINI:TEXT)
		mundest		:= (oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNFIM:TEXT)
		munorig:= Substr(munorig,3,len(munorig))		
		mundest:= Substr(mundest,3,len(mundest))
		DocOrig()
		cOutSaid:= .f.
		For _nIa := 1 to len(_aNfSaida)
			DbSelectArea("SD2")
			DbSetOrder(3)
			If DbSeek(xFilial("SD2")+Alltrim(_aNfSaida[_nIa][2])+Alltrim(_aNfSaida[_nIa][1]))
				//while !eof .and. sd2->d2_doc == Alltrim(_aNfSaida[_nIa][2]) .and. sd2->d2_serie == Alltrim(_aNfSaida[_nIa][1])
					if !(sd2->d2_tp $ "PA/pa/PN/pn/PD/pd/PM/pm") // nao contido em PA/PN/PD/PM entao e outras saidas
						cOutSaid := .t.
					endif
					
				//	dbskip
				//end
			endif
		Next _nIa
		
	   /*if !cOutSaid //produto e pa ou pn ou pd  soluçao Luiz Fernando 11/04/2016 ainda nao aprovada
	   		if(_cDest = "GO" .or. cSuframa = "I" .or. nPerIcm == nil)
	   			nPerIcm	:= 0
				nBaseIcm	:= 0
				nValIcm	:= 0
				_cTes		:= "164"
			else
				if !( cSuframa = "I")
					nPerIcm	:= VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT))
					nBaseIcm 	:= VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT))
					nValIcm	:= VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT))
					_cTes		:= "163"
				endif
			endif
		else //produto diferente de pa ou pn ou pd
			nPerIcm	:= VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT))
			nBaseIcm	:= VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT))
			nValIcm	:= VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT))
			_cTes		:= "336"
		endif
		*/		
	   
//09/06/2017 (09:35) Raquel de Souza Nascimento - 136: 336 - Produto frete outras saidas 163 - Produto frete sobre vendas 164 - Venda a zona franca
	   if !cOutSaid // /*Ricardo 13/05/2014  nao for outras saidas
			if  cSuframa == "I" .or. _cDest = "GO" 
				nPerIcm	:= 0
				nBaseIcm	:= 0
				nValIcm	:= 0
				_cTes		:= "164"
			else
				///*Leandro 01-06-2016
				nPerIcm	:= XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS, "_ICMS00") 
				if nPerIcm == nil 
					nPerIcm	 := 0
					nBaseIcm := 0
					nValIcm	 := 0
					_cTes	 := "163"
				Else
					nPerIcm	 := VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT))
					nBaseIcm := VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT))
					nValIcm	 := VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT))
					_cTes	 := "163"
				endif
			endif
		endif //else
		
		
		if cOutSaid .and. empty(_cTes) ///*Leandro
			///*Leandro 01-06-2016
			//nPerIcm	:= XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS, "_ICMS00") 

			//	if nPerIcm == nil 
			//		nPerIcm	:= 0
			//		nBaseIcm 	:= 0
			//		nValIcm	:= 0
			//		_cTes	 	:= "164"
			//	Else
	 		//		nPerIcm	 := VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT))
			//		nBaseIcm 	 := VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT))
			//		nValIcm	 := VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT))
			//		_cTes	    := "163"
			//	endif
			//else
				///*Leandro 01-06-2016
				//6: qdo é frete outras saídas
//09/06/2017 (09:35) Raquel de Souza Nascimento - 136: 336 - Produto frete outras saidas 163 - Produto frete sobre vendas 164 - Venda a zona franca
				nPerIcm	:= XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS, "_ICMS00") 
	
				if nPerIcm == nil 
					nPerIcm	 := 0
					nBaseIcm := 0
					nValIcm	 := 0
					_cTes	 := "336"
				Else
					nPerIcm	:= VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT))
					nBaseIcm	:= VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT))
					nValIcm	:= VAL((oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT))
					_cTes		:= "336"
				endif
		endif
    	//endif// Fim se*/
        
	    //cOutSaid := .F. // Variavel inicializada mas fora do tempo de execução ficando como o valor
	                    // da ultima entrada de XML, sendo necessario inicia-lo ao fim da execução
	                    // e inicio da execução seguinte. 15/05/2014 - Ricardo Lima / Guilherme. 
	                    
         // Se tipo igual PA  devera ser tes 163  ou 164 se for Goias ou Suframa
         // Se tipo diferente PA devera ser tes 336
		          
		If (sd2->d2_tp $ "PA/pa/PN/pn/PD/pd/PM/pm") .and. _cTes = "336"
		    Msginfo("Tes incorreta, do conhecimento de frete"+cNumCte+" !")
		EndIf
		
		// Realiza a entrada do CTe utilizando a Rotina automática
		DbSelectArea("SF1")
		DbSetOrder(1)
		If !DbSeek(xFilial("SF1")+cNumCte+cSerieCte+cFornece+cLojaFor)
			lMSERROAUTO := .F.
			aCABEC	:= {}
			aITENS	:= {}
			aITENS2	:= {}
			
			AADD(aCABEC,{"F1_FILIAL"   ,xFILIAL("SF1"),nil})
			AADD(aCABEC,{"F1_TIPO"     ,"N",nil})
			AADD(aCABEC,{"F1_TPCTE"    ,cTpCte,nil})   // tipo de cte nao informado Luiz Fiuza 20/06/2017  N=Normal;C=Complem.Valores;A=Anula.Valores;S=Substituto                                                                         
			AADD(aCABEC,{"F1_FORMUL"   ,"N",nil})
			AADD(aCABEC,{"F1_DOC"      ,cNumCte,nil})
			AADD(aCABEC,{"F1_SERIE"    ,cSerieCte,nil})
			AADD(aCABEC,{"F1_EMISSAO"  ,dEmissao,nil})
			AADD(aCABEC,{"F1_FORNECE"  ,cFornece,Nil})
			AADD(aCABEC,{"F1_LOJA"     ,cLojaFor,nil})
			AADD(aCABEC,{"F1_ESPECIE"  ,"CTE",nil})
			AADD(aCABEC,{"F1_COND"     ,"001",nil})
			AADD(aCABEC,{"F1_BASEICM"  ,nBaseIcm,nil})
			AADD(aCABEC,{"F1_VALMERC"  ,nValorUn,nil})
			AADD(aCABEC,{"F1_VALBRUT"  ,nValorUn,nil})
			AADD(aCABEC,{"F1_VALICM"   ,nValIcm,nil})
			AADD(aCABEC,{"F1_CHVNFE"   ,cChaveCte,nil})
			AADD(aCABEC,{"F1_UFORITR"  ,uforig,nil})
			AADD(aCABEC,{"F1_UFDESTR"  ,ufdest,nil})
			AADD(aCABEC,{"F1_MUORITR"  ,munorig,nil})
			AADD(aCABEC,{"F1_MUDESTR"  ,mundest,nil})

			AADD(aCABEC,{"E2_NATUREZ"  ,"20109",nil})
			AADD(aITENS,{"D1_FILIAL"   ,xFILIAL("SD1"),NIL})
			AADD(aITENS,{"D1_ITEM"     ,"01  ",NIL})
			if cOutSaid
				AADD(aITENS,{"D1_COD"      ,"106714",NIL})
				AADD(aITENS,{"D1_DESCPRO"  ,"FRETES OUTRAS SAIDAS",nil})
			else
				AADD(aITENS,{"D1_COD"      ,"102595",NIL})
				AADD(aITENS,{"D1_DESCPRO"  ,"FRETE SOBRE VENDAS",nil})
			endif
			AADD(aITENS,{"D1_UM"       ,"UN",nil})
			AADD(aITENS,{"D1_QUANT"    ,1,nil})
			AADD(aITENS,{"D1_VUNIT"    ,nValorUn,nil})
		   //	AADD(aITENS,{"D1_TOTAL"    ,nValorUn,nil}) ricardo fiuza's estava dando o erro.
			AADD(aITENS,{"D1_TES"      ,_cTes,NIL})
			AADD(aITENS,{"D1_TIPO"     ,"N",nil})
			AADD(aITENS,{"D1_FORMUL"   ,"N",nil})
			AADD(aITENS,{"D1_EMISSAO"  ,dEmissao,nil})
			AADD(aITENS,{"D1_FORNECE"  ,cFornece,nil})
			AADD(aITENS,{"D1_LOJA"     ,cLojaFor,nil})
			AADD(aITENS,{"D1_CC"       ,"29050100 ",nil})
			AADD(aITENS,{"D1_PICM"     ,nPerIcm,nil})
			AADD(aITENS,{"D1_VALICM"   ,nValIcm,nil})
			AADD(aITENS,{"D1_BASEICM"  ,nBaseIcm,nil})
			AADD(aITENS2,aITENS)
			
			MSEXECAUTO({|X,Y,Z| MATA103(X,Y,Z)},aCABEC,aITENS2,3)

			if lMSERROAUTO
				MOSTRAERRO()
			Return()
			else
				amarra()
			endif
		else
			ApMsgInfo("CTe "+cNumCte+"ja existe no sistema!")
			_MsgInv := "CTe "+cNumCte+"ja existe no sistema!"
			_msgX	+= _MsgInv+CHR(13)+CHR(10)
			_WriteLog(_MsgInv)
		endif
		_MsgInv := "Processo de importação do CTe "+cNumCte+" concluído."+CHR(13)+CHR(10)+"********************************************************************************"+CHR(13)+CHR(10)
		_msgX	+= _MsgInv+CHR(13)+CHR(10)
		_WriteLog(_MsgInv)

		If lLog
			Alert("Processo de Importação finalizado com erros. O Historico encontra-se no Arquivo: "+_cPATH+ sm0->m0_codigo + "XML.LOG")
		Else
			if FeRase(_cPath+_aItems[nArqXml]) = 0
				_MsgInv := "O Arquivo:  "+_aItems[nArqXml]+" foi Apagado da pasta "+_cPath
				_msgX	+= _MsgInv+CHR(13)+CHR(10)
				_WriteLog(_MsgInv)
			else
				_MsgInv := "Arquivo:  "+_aItems[nArqXml]+" NÃO foi Apagado da pasta "+_cPath
				_msgX	+= _MsgInv+CHR(13)+CHR(10)
				_WriteLog(_MsgInv)
			endif
	
			ApMsgInfo("Processo de Importação finalizado.")
			_MsgInv := "Processo de Importação finalizado."
			_msgX	+= _MsgInv+CHR(13)+CHR(10)
			_WriteLog(_MsgInv)
		EndIf
		
		If PswSeek( cUsuario, .T. )
			_dUsr		:= PSWRET() // Retorna vetor com informações do usuário
			_nomUsr	:= _dUsr[1][4]
			_emailUsr 	:= _dUsr[1][14]
		else
			_nomUsr	:= "NDA"
			_emailUsr 	:= ""
		EndIf

		_cassunto	:= "Importação dos XML's dos CTe's - Fatura:  "+cFatura+_emailUsr
		_canexos	:= _cDirFat+"/"+Alltrim(cFatura)+"XML.LOG"
		_emailx()
	
	Next nArqXml
	RESTAREA(cAREA)
Return(aReg)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ _WriteLog ³Autor ³ Andre Almeida Alves   ³Data ³ 30/08/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Função para gravar os Log's de error.                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function _WriteLog(_MsgInv)
	_cLog +=_MsgInv+CHR(13)+CHR(10)
	Memowrite(_cDirFat+"/"+Alltrim(cFatura)+"XML.LOG",_cLog)
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ _emailx  ³Autor ³ Andre Almeida Alves    ³Data ³ 14/10/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Função para enviar e-mail com o resultado da importação.   ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function _emailX()

	Local cAccount  := 'Importação_CTe'
	Local cEnvia    := GetMv("MV_RELACNT")
	Local cServer   := GetMv("MV_RELSERV")
	Local cPassword := GetMv("MV_RELPSW")
	
//Private cPass     := GetMv("MV_RELPSW")
//Private cAccount  := GetMv("MV_RELACNT")
//Private cServer   := GetMv("MV_RELSERV")

	_para := "ti@vitamedic.ind.br; "+_emailUsr
	
	_cMsg := '</table>'
	_cMsg += '<br><br>'
	_cMsg += '<font face="Arial Black" size="4">  '+SM0->M0_NOME+ '</font> <br>'
	_cMsg += '<br>'
	_cMsg += '<font face="Arial" size="2"> Importação dos XML: em '+dtoc(date())+ " às " + Time() + '     Por '+alltrim(cusername)+ '</font> <br>'
	_cMsg += '<br>'
	_cMsg += '<font face="Arial" size="2"> Segue em anexo o LOG com as informações do processo de imoprtação do XML </font> <br>'
	_cMsg += '<br>'
	_cMsg += '<table border=1 width=700>'
	_cMsg += '<tr>'
	_cMsg += '<td rowspan=2 width=80>'+_msgX+'</td>'
	_cMsg += '</tr>'
	_cMsg += '<tr>'
	_cMsg += '</table>'
	_cMsg += '<br>'
	_cMsg += '<font face="Arial" size="1"> Este e-mail foi gerado automaticamente pelo sistema, favor não responder.</b></font> <br>'
	_cMsg += '</body>'
	_cMsg += '</html>'

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	SEND MAIL FROM cEnvia TO _para SUBJECT _cassunto BODY _cMsg RESULT lEnviado

	_para := ""
return()

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ Amarra   ³Autor ³ Andre Almeida Alves    ³Data ³ 14/10/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Função para amarrar as NF's transportadas ao CTe.          ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

static Function Amarra()

	
	_nPsLnf			:= 0
	_nPsBnf			:= 0
	_nVolNf			:= 0
	
	//Realiza a amarração do CTe com as NF's de Saida
	For _nI := 1 to len(_aNfSaida)
		DbSelectArea("SF2")
		DbSetOrder(1)
//		If DbSeek(xFilial("SF2")+Alltrim(_aNfSaida[_nI][2])+Alltrim(_aNfSaida[_nI][1])+"  ")
		If DbSeek(xFilial("SF2")+Alltrim(_aNfSaida[_nI][2])+"2  ")
		
			if len(_aNfSaida) > 1
				_nVal		:= (nValorUn/nValCarga)*sf2->f2_valbrut
				_nValICM	:= (_nVal*nPerIcm)/100
			else
				_nVal	:= nValorUn
				_nValIcm	:= nValIcm
			endif

			RECLOCK("SF2",.F.)
			sf2->f2_serfret	:= cSerieCte
			sf2->f2_numfret	:= cNumCte
			sf2->f2_vlfrete	:= _nVal
			sf2->f2_icmsfr	:= _nValICM
			sf2->f2_obsfr	:= _cTipFrete
			sf2->f2_tipfret	:= _cCombo
			MSUNLOCK()
			_nPsLnf			:= _nPsLnf+sf2->f2_pliqui
			_nPsBnf			:= _nPsBnf+sf2->f2_pbruto
			_nVolNf			:= _nVolNf+sf2->f2_volume1
			_MsgInv := "Realizada a amarração da NF:  "+_aNfSaida[_nI][2]+" ao CTe:  "+cNumCte
			_msgX	+= _MsgInv+CHR(13)+CHR(10)
			_WriteLog(_MsgInv)
		else
			_MsgInv := "Não foi localizada a NF:  "+_aNfSaida[_nI][2]+" do CTe:  "+cNumCte+". Não foi realizada a amarração dessta NF."
			_msgX	+= _MsgInv+CHR(13)+CHR(10)
			_WriteLog(_MsgInv)
			lLog := .t.
		endif  
		
	nSerie := _aNfSaida[_nI][1]
	nFOrig := _aNfSaida[_nI][2] //SF2->F2_DOC 
	cClient := _aNfSaida[_nI][3] //cLIENTE
	cLojaCli :=_aNfSaida[_nI][4] //LOJA
	
	   DbSelectArea("SF8")
   	   DbSetOrder(4) //F8_FILIAL+F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_NORIG (INDICE 4 )
	   If !DbSeek(xFilial("SF8")+"S"+cNumCte+cSerieCte+cFornece+nFOrig)
	      DbSetOrder(5) //F8_FILIAL+F8_TIPONF+F8_NFORIG+F8_SERORIG (INDICE 5 )
	   	  If !DbSeek(xFilial("SF8")+"S"+nFOrig)
     		 RECLOCK("SF8",.T.)
	   		 SF8->F8_FILIAL	  	:= xFilial("SF8")
			 SF8->F8_NFDIFRE  	:= cNumCte
			 SF8->F8_SEDIFRE   	:= cSerieCte 
	   		 SF8->F8_DTDIGIT  	:= dDatabase
	   		 SF8->F8_TRANSP  		:= cFornece  //TRANSPORTADOR
			 SF8->F8_LOJTRAN  	:= cLojaFor	 
	   		 SF8->F8_NFORIG  		:= nFOrig 	
	   		 SF8->F8_SERORIG    	:= nSerie
       	 SF8->F8_FORNECE  	:= cClient
			 SF8->F8_LOJA			:= cLojaCli 
//			 SF8->F8_DTPREV  		:= dPrevEnt 
   			 SF8->F8_TPFRETE  	:= "FN" //Frete Normal
			 SF8->F8_TIPONF  		:= "S"
   			 MSUNLOCK()	             
			 _MsgInv := "Realizada a gravação das informações auxiliares na tabela SF8 do CTe:  "+cNumCte
			 _msgX	+= _MsgInv+CHR(13)+CHR(10)
			 _WriteLog(_MsgInv)		
	   Else    
			 RECLOCK("SF8",.T.)
	   		 SF8->F8_FILIAL 	 	:= xFilial("SF8")
			 SF8->F8_NFDIFRE     := cNumCte
			 SF8->F8_SEDIFRE   	:= cSerieCte 
	   		 SF8->F8_DTDIGIT  	:= dDatabase
	   		 SF8->F8_TRANSP  		:= cFornece  //TRANSPORTADOR
			 SF8->F8_LOJTRAN   	:= cLojaFor	 
	   		 SF8->F8_NFORIG  		:= nFOrig 	
	   		 SF8->F8_SERORIG		:= "2"
       	 SF8->F8_FORNECE  	:= cClient
			 SF8->F8_LOJA			:= cLojaCli  
   			 //SF8->F8_TPFRTE  	:= "FN" //Frete Normal
//   			 SF8->F8_DTPREV	  	:= dPrevEnt
			 SF8->F8_TIPONF  		:= "S"
   			 MSUNLOCK()  
   			 
   			 ValExc()
   			 
	   		 _MsgInv := "Realizada a gravação das informações auxiliares na tabela SF8 do CTe:  "+cNumCte
	   		 _msgX	+= _MsgInv+CHR(13)+CHR(10)
	   		 _WriteLog(_MsgInv)
	  	  EndIf
	   EndIf   
	Next _nI

	// Grava a tabela auxiliar ZZX, com todas as NFEs Importadas.		    
	cArqTxt := cArqXml
	nHdl    := fOpen(cArqTxt,68)
        
	fSeek(nHdl,0,0)
	mZZxml := FREADSTR(NHDL,65000)
	//nFOrig := _aNfSaida[_nI][2] //SF2->F2_DOC
        
	DbSelectArea("ZZX")
	DbSetOrder(1)
	If !DbSeek(xFilial("ZZX")+cNumCte+cSerieCte+cFornece+cLojaFor)
		RECLOCK("ZZX",.T.)
		ZZX->ZZX_FILIAL  	:= xFilial("ZZX")
		ZZX->ZZX_NOTA    	:= cNumCte
		ZZX->ZZX_SERIE   	:= cSerieCte
		ZZX->ZZX_FORNEC  	:= cFornece
		ZZX->ZZX_LOJA    	:= cLojaFor
		ZZX->ZZX_EMISSA  	:= dEmissao
		ZZX->ZZX_VALOR   	:= nValorUn
		ZZX->ZZX_XML     	:= cChaveCte
		ZZX->ZZX_XML2     := mZZxml
		ZZX->ZZX_PSCTE	:= _nPesoCte
		ZZX->ZZX_VOLCTE	:= _nVolCTe
		ZZX->ZZX_PSLNFE	:= _nPsLnf
		ZZX->ZZX_PSBNFE	:= _nPsBnf
		ZZX->ZZX_VLCARGA	:= nValCarga
		ZZX->ZZX_VOLNFE 	:= _nVolNf
		ZZX->ZZX_PERCEN	:= (nValorUn/nValCarga)*100
		MSUNLOCK()
		_MsgInv := "Realizada a gravação das informações auxiliares na tabela ZZX do CTe:  "+cNumCte
		_msgX	+= _MsgInv+CHR(13)+CHR(10)
		_WriteLog(_MsgInv)
	EndIf			
	
return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ MoveArq  ³Autor ³ Andre Almeida Alves    ³Data ³ 16/10/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Função para mover os arquivos.                             ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function MoveArq()

	//Mover os arquivos para pasta com nome da Fatura
	if CPYT2S(_cPath+_aItems[nArqXml],_cDirFat,.T.)
		_MsgInv := "Arquivo:  "+_aItems[nArqXml]+" Copiado com sucesso para a pasta "+ _cDirFat
		_msgX	+= _MsgInv+CHR(13)+CHR(10)
		_WriteLog(_MsgInv)
	else
		_MsgInv := "Não foi possível copiar o Arquivo:  "+_aItems[nArqXml]+" para a pasta, "+ _cDirFat+"e o mesmo não será apagado da pasta "+_cPath
		_msgX	+= _MsgInv+CHR(13)+CHR(10)
		_lCopi	:= .f.
		_WriteLog(_MsgInv)
	endif
return(_lCopi)
//return(.t.)
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ MoveArq  ³Autor ³ Andre Almeida Alves    ³Data ³ 16/10/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Função para mover os arquivos.                             ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function DocOrig()

	cCompFret	:= XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_VPREST, "_COMP")	
	
	/*msginfo("mensagem de alerta")*/	
	if cCompFret == nil
		aTipFrete	:= " "
	else
		aTipFrete	:= (oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP)
	endif	
	
	if XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE, "_INFCTENORM") <> nil .and. (oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TPCTE:TEXT)=="0"
		cTpCte := "N"
	elseif XmlChildEx(oXml:_CTEPROC:_CTE:_INFCTE, "_INFCTECOMP") <> nil .and. (oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TPCTE:TEXT)=="2"
		cTpCte := "C"
	else
		cTpCte := "A"
	endif
	
	if cTpCte == "N"
		nValCarga	:= val(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_VCARGA:TEXT)
		aInfQ		:= (oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ)
	endif
	//ApMsgInfo("Gravação realizada com sucesso do CTe "+cNumCte)
	_MsgInv := "Gravação do CTe  "+cNumCte+"  realizada com sucesso."
	_msgX	+= _MsgInv+CHR(13)+CHR(10)
	_WriteLog(_MsgInv)

	// Realiza a amarração do CTe as notas informadas no XML
	if _cChDoc = "1"  //Pega o Numero da Nota pela Chave.
		if nTotItem = 1
			_aNfSaida[nTotItem][1]	:= substr(aNfsCte:_CHAVE:TEXT,25,1) //Serie da NF de Venda
			_aNfSaida[nTotItem][2]	:= substr(aNfsCte:_CHAVE:TEXT,26,9) //Numero da NF de Venda
			_aNfSaida[nTotItem][3]	:= Posicione("SF2",1,xFilial("SF2")+_aNfSaida[nTotItem][2]+_aNfSaida[nTotItem][1],'F2_CLIENTE') //cLIENTE
			_aNfSaida[nTotItem][4]	:= Posicione("SF2",1,xFilial("SF2")+_aNfSaida[nTotItem][2]+_aNfSaida[nTotItem][1],'F2_LOJA')//LOJA
		else
			For _nI := 1 to nTotItem
				_aNfSaida[_nI][1]		:= substr(aNfsCte[_nI]:_CHAVE:TEXT,25,1) //Serie da NF de Venda
				_aNfSaida[_nI][2]		:= substr(aNfsCte[_nI]:_CHAVE:TEXT,26,9) //Numero da NF de Venda
				_aNfSaida[_nI][3]		:= Posicione("SF2",1,xFilial("SF2")+_aNfSaida[_nI][2]+_aNfSaida[_nI][1],'F2_CLIENTE')//CLIENTE
				_aNfSaida[_nI][4]		:= Posicione("SF2",1,xFilial("SF2")+_aNfSaida[_nI][2]+_aNfSaida[_nI][1],'F2_LOJA')//LOJA
			Next _nI
		endif
	elseif _cChDoc = "2" //o Nodo do Objeto ja tras o numero da Nota e serie
		if nTotItem = 1
			_aNfSaida[nTotItem][1]	:= aNfsCte:_SERIE:TEXT+"  " //Serie da NF de Venda
			_aNfSaida[nTotItem][2]	:= "0000"+aNfsCte:_NDOC:TEXT //Numero da NF de Venda
			_aNfSaida[nTotItem][3]	:= Posicione("SF2",1,xFilial("SF2")+_aNfSaida[nTotItem][2]+_aNfSaida[nTotItem][1],'F2_CLIENTE')//CLIENTE
			_aNfSaida[nTotItem][4]	:= Posicione("SF2",1,xFilial("SF2")+_aNfSaida[nTotItem][2]+_aNfSaida[nTotItem][1],'F2_LOJA')//LOJA
		
		else
			For _nI := 1 to nTotItem
				_aNfSaida[_nI][1]		:= aNfsCte[_nI]:_SERIE:TEXT+"  " //Serie da NF de Venda
				_aNfSaida[_nI][2]		:= Padl(aNfsCte[_nI]:_NDOC:TEXT,9,"0") //Numero da NF de Venda
				_aNfSaida[_nI][3]		:= Posicione("SF2",1,xFilial("SF2")+_aNfSaida[_nI][2]+_aNfSaida[_nI][1],'F2_CLIENTE')//CLIENTE
				_aNfSaida[_nI][4]		:= Posicione("SF2",1,xFilial("SF2")+_aNfSaida[_nI][2]+_aNfSaida[_nI][1],'F2_LOJA')//LOJA
		
			Next _nI
		endif
	Endif 
	
	if valtype(aTipFrete) = "A"
		_nValFrete 	:= val(oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP[1]:_VCOMP:TEXT)
		_cTipFrete		:= (oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP[1]:_XNOME:TEXT)
	
		For _nl := 1 to len(aTipFrete)
			_nValAtu	:= val(oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP[_nl]:_VCOMP:TEXT)
			if _nValFrete < _nValAtu
				_nValFrete 	:= _nValAtu
				_cTipFrete	:= (oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP[_nl]:_XNOME:TEXT)
			endif
		next _nl
	elseif valtype(aTipFrete) = "C" .and. aTipFrete	== " "
		_nValFrete	:= val(oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VREC:TEXT)
		_cTipFrete	:= "FRETE VALOR"
	else
		_nValFrete	:= val(oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP:_VCOMP:TEXT)
		_cTipFrete	:= (oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP:_XNOME:TEXT)

	endif
	
	if valtype(aInfQ) = "A" .and. cTpCte == "N"
		For _n := 1 to len(aInfQ)
			if ("PESO") $ oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_TPMED:TEXT
				if !("CUBADO") $ oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_TPMED:TEXT
					_nPsCte := val(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_QCARGA:TEXT)
				elseif ("CUBADO") $ oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_TPMED:TEXT
					_nPsCBcte := val(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_QCARGA:TEXT)
				endif
			elseif ("VOLUMES") $ oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_TPMED:TEXT .OR. ("VOLUME") $ oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_TPMED:TEXT
				_nVolCTe := val(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_QCARGA:TEXT)
			elseif ("CAIXAS") $ oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_TPMED:TEXT .OR. ("CAIXA") $ oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_TPMED:TEXT
				_nVolCTe := val(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_QCARGA:TEXT)
			elseif ("UNIDADE") $ oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_TPMED:TEXT .OR. ("UNIDADES") $ oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_TPMED:TEXT
				_nVolCTe := val(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ[_n]:_QCARGA:TEXT)
			endif
		next _n
	endif
	
	_nPesoCte	:= iif(_nPsCBcte>_nPsCte,_nPsCBcte,_nPsCte)
	
	if ("PESO") $ _cTipFrete .OR. ("Peso") $ _cTipFrete .OR. ("peso") $ _cTipFrete
		_cCombo := "FP"
	elseif ("VALOR") $ _cTipFrete .or. ("Valor") $ _cTipFrete .or. ("valor") $ _cTipFrete
		_cCombo := "FV"
	else
		_cCombo := "OU"
	endif
return()      

//Abre a Tela quando ja tem a amarração de um Determinado conhecimento com uma nota de saída, para digitar o Tipo 
//de Frete (FN=Frete Normal, FD=Frete Devolução, FT=Frete Taxa)
//Ricardo Moreira
 

Static Function ValExc()

//Local lblCodMot
//Local lblDesMot
Local oSay1
Local oSButton1
//Local oSButton2 
PRIVATE aComboBo1       := {"FD=Frete Devolução","FT=Frete Taxa"} //Tipos de Frete
Private nComboBo1  := space(02)
//Private cblDescMot := space(30)  
Static oDlg
 
  DEFINE MSDIALOG oDlg TITLE "Tipo de Frete Transporte" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME
 
    @ 024, 014 SAY oSay1 PROMPT "Tipo:" SIZE 019, 007 OF oDlg COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 055, 154 TYPE 01 OF oDlg ENABLE ACTION GravTF() 
    //DEFINE SBUTTON oSButton2 FROM 065, 205 TYPE 02 OF oDlg ENABLE ACTION Canc() //oDlg:End()//Close()
    
    @ 023, 048 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS aComboBo1 SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL    
    //@ 033, 046 MSGET lblCodMot VAR cblCodMot SIZE 020, 010 OF oDlg COLORS 0, 16777215 F3 "XSC" PIXEL valid naovazio()// .and. VMotExSF2(cblOp)          
    //@ 033, 046 MSGET lblCodMot VAR cblCodMot SIZE 020, 010 OF oDlg COLORS 0, 16777215 F3 "XSC" PIXEL valid naovazio()// .and. VMotExSF2(cblOp)
    //@ 033, 081 MSGET lblDesMot VAR cblDescMot SIZE 150, 010 OF oDlg COLORS 0, 16777215 PIXEL  
 
  ACTIVATE MSDIALOG oDlg CENTERED
 
Return 

/* ##################################################################
Função:GravMt()      Data : 14/10/2015
Autor: Ricardo Fiuza's
Uso: Gravar o Codigo do Motivo da Exclusao na Tabela SF2
#####################################################################*/ 

Static Function GravTF()  

   If !empty(nComboBo1)
	 RecLock( "SF8" , .F. )		
	 	SF8->F8_TPFRETE := nComboBo1	 	
	 MsUnLock()	
	 oDlg:End()
   Else
     Msginfo("Favor Digitar o Tipo do Frete !!!!")
     lValido := .F.
   Endif 
   
Return 
 
 /* ##################################################################
Função:Canc()      Data : 25/10/2016
Autor: Ricardo Fiuza's
Uso: Valida para não deixar cancelar a tela sem preencher o tipo de Frete
#####################################################################*/ 
/*
Static Function Canc() 
 
If empty(nComboBo1)
	lValido := .F.
	Msginfo("Por favor Obrigatório informar o Tipo de Frete !!!!")
Else

	oDlg:End() 
	EndIf
Return 
 */

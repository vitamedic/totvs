#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"
#Include "AP5MAIL.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "MSMGADD.CH"

/*/{Protheus.doc} Vit611
	Exportar Arquivos para recuperação de registros
@author HENRIQUE CORREA
@since 06/06/2017
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function Vit611()
                            
if !ValidPerg()
	Return()
endif

Processa( {|lEnd| aTRB := GeraArqs(@lEnd)}, "Aguarde...","Gerando arquivos .csv das tabelas do projeto estoque...", .T. )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GeraArqs(lEnd)
Local oExcelApp
Local nTotRecs
   
Private _cArq   
Private nHdl    
Private cEOL    := CHR(13)+CHR(10)
Private _aPer := {}
	
  	MakeDir(mv_par01) // Cria um diretório na estacao 
	
	_cArq := Alltrim(mv_par01) + "\TAB_SC1.csv"
	
	processa({|| QrySC1(@nTotRecs)})
    
	if nTotRecs > 0  
		nHdl := fCreate(_cArq)
		If nHdl == -1
		    MsgAlert("O arquivo de nome "+_cArq+" nao pode ser criado! Verifique os parametros.", "Atencao!")
		    Return
		Endif
		
		//Cabeçalho da Planilha
		_aIts := { PADR("NUM SC",10),;
		           PADR("ITEM SC",10),;
		           PADR("PRODUTO",17),;
		           PADR("DESCRICAO",50),;
		           PADC("QUANTIDADE",18),;
		           PADC("U.M.",10),;
		           PADC("ARMAZEM",10),;
		           PADC("DT. EMISSAO",13),;
		           PADC("QTD. EM PED.",18),;
		           PADC("ELIMIN. RESID.",18),;
		           PADC("USUARIO SOLICITANTE",25),;
		           PADC("USUARIO INCLUSAO",25),;
		           PADC("RECNO",18),;
		           PADC("OK",6) }
	
	    cLin :=  u_HPreencheLinha(_aIts)
	    
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        //If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Return
	        //Endif
	    Endif
	
		ProcRegua(nTotRecs)
	
		QVIT611->(dbGoTop()) 
		do while QVIT611->(!Eof())
		 	IncProc( "Solicitação de Compra " + AllTrim(QVIT611->C1_NUM) + " Item " + AllTrim(QVIT611->C1_ITEM) )
			
			_aIts := { PADR(QVIT611->C1_NUM,10),;   
			           PADR(QVIT611->C1_ITEM,10),;
			           PADR(QVIT611->C1_PRODUTO,17),;
			           PADR(QVIT611->C1_DESCRI,50),;
			           PADR(transform(QVIT611->C1_QUANT, "@E 99,999,999,999.99"),18),;
			           PADR(QVIT611->C1_UM,10),;
			           PADR(QVIT611->C1_LOCAL,10),;
			           PADR(DtoC(StoD(QVIT611->C1_EMISSAO)),13),;
			           PADR(transform(QVIT611->C1_QUJE, "@E 99,999,999,999.99"),18),;
			           PADR(QVIT611->C1_RESIDUO,18),;
			           PADR(Alltrim(QVIT611->C1_SOLICIT),25),;
			           PADR(Alltrim(Embaralha(QVIT611->C1_USERLGI,1)),25),;
			           PADR(Alltrim(Str(QVIT611->R_E_C_N_O_)),18),;
			           PADR("",6) }
			
		   cLin :=  u_HPreencheLinha(_aIts)
			
		   If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		   		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		    		Exit
		    	Endif
		   Endif          
		   
			QVIT611->(dbSkip())
		enddo
		
		fClose(nHdl)
	endif
		
	_cArq := Alltrim(mv_par01) + "\TAB_SC7.csv"
	
	processa({|| QrySC7(@nTotRecs)})
    
	if nTotRecs > 0
		nHdl := fCreate(_cArq)
		If nHdl == -1
		    MsgAlert("O arquivo de nome "+_cArq+" nao pode ser criado! Verifique os parametros.", "Atencao!")
		    Return
		Endif
		
		//Cabeçalho da Planilha
		_aIts := { PADR("NUM PC",10),;
		           PADR("ITEM PC",10),;
		           PADR("NUM SC",10),;
		           PADR("ITEM SC",10),;
		           PADR("PRODUTO",17),;
		           PADR("DESCRICAO",50),;
		           PADC("QUANTIDADE",18),;
		           PADC("U.M.",10),;
		           PADC("DT. EMISSAO",13),;
		           PADC("DT. ENTREGUE",13),;
		           PADC("QTD. ENTREGUE",18),;
		           PADC("RESIDUO",18),;
		           PADC("RECNO",18),;
		           PADC("OK",6) }
	
	    cLin :=  u_HPreencheLinha(_aIts)
	    
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        //If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Return
	        //Endif
	    Endif
	
		ProcRegua(nTotRecs)
	
		QVIT611->(dbGoTop()) 
		do while QVIT611->(!Eof())
		 	IncProc( "Pedido de Compra " + AllTrim(QVIT611->C7_NUM) + " Item " + AllTrim(QVIT611->C7_ITEM) )
			
			_aIts := { PADR(QVIT611->C7_NUM,10),;   
			           PADR(QVIT611->C7_ITEM,10),;
			           PADR(QVIT611->C7_NUMSC,10),;
			           PADR(QVIT611->C7_ITEMSC,10),;
			           PADR(QVIT611->C7_PRODUTO,17),;
			           PADR(QVIT611->C7_DESCRI,50),;
			           PADR(transform(QVIT611->C7_QUANT, "@E 99,999,999,999.99"),18),;
			           PADR(QVIT611->C7_UM,10),;
			           PADR(DtoC(StoD(QVIT611->C7_EMISSAO)),13),;
			           PADR(DtoC(StoD(QVIT611->C7_DATPRF)),13),;
			           PADR(transform(QVIT611->C7_QUJE, "@E 99,999,999,999.99"),18),;
			           PADR(transform(QVIT611->C7_RESIDUO, "@E 99,999,999,999.99"),18),;
			           PADR(Alltrim(Str(QVIT611->R_E_C_N_O_)),18),;
			           PADR("",6) }
			
		   cLin :=  u_HPreencheLinha(_aIts)
			
		   If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		   		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		    		Exit
		    	Endif
		   Endif          
		   
			QVIT611->(dbSkip())
		enddo
		
		fClose(nHdl)
	endif

	_cArq := Alltrim(mv_par01) + "\TAB_SC2.csv"
	
	processa({|| QrySC2(@nTotRecs)})
    
	if nTotRecs > 0
		nHdl := fCreate(_cArq)
		If nHdl == -1
		    MsgAlert("O arquivo de nome "+_cArq+" nao pode ser criado! Verifique os parametros.", "Atencao!")
		    Return
		Endif
	
		//Cabeçalho da Planilha
		_aIts := { PADR("NUM OP",10),;
		           PADR("ITEM OP",10),;
		           PADR("SEQ. OP",10),;
		           PADR("PRODUTO",17),;
		           PADR("DESCRICAO",50),;
		           PADC("QUANTIDADE",18),;
		           PADC("U.M.",10),;
		           PADC("DT. EMISSAO",13),;
		           PADC("LOTE",15),;
		           PADC("ARMAZEM",10),;
		           PADC("DT. REAL FIM",15),;
		           PADC("QTD. PRODUZIDA",18),;
		           PADC("RECNO",18),;
		           PADC("OK",6) }
	
	    cLin :=  u_HPreencheLinha(_aIts)
	    
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        //If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Return
	        //Endif
	    Endif
	
		ProcRegua(nTotRecs)
	
		QVIT611->(dbGoTop()) 
		do while QVIT611->(!Eof())
		 	IncProc( "Ordem de Produção " + AllTrim(QVIT611->C2_NUM) + " Item " + AllTrim(QVIT611->C2_ITEM) + " Sequen. " + AllTrim(QVIT611->C2_SEQUEN) )
			
			_aIts := { PADR(QVIT611->C2_NUM,10),;   
			           PADR(QVIT611->C2_ITEM,10),;
			           PADR(QVIT611->C2_SEQUEN,10),;
			           PADR(QVIT611->C2_PRODUTO,17),;
			           PADR(QVIT611->B1_DESC,50),;
			           PADR(transform(QVIT611->C2_QUANT, "@E 99,999,999,999.99"),18),;
			           PADR(QVIT611->C2_UM,10),;
			           PADR(DtoC(StoD(QVIT611->C2_EMISSAO)),13),;
			           PADR(QVIT611->C2_LOTECTL,15),;
			           PADR(QVIT611->C2_LOCAL,10),;
			           PADR(DtoC(StoD(QVIT611->C2_DATRF)),13),;
			           PADR(transform(QVIT611->C2_QUJE, "@E 99,999,999,999.99"),18),;
			           PADR(Alltrim(Str(QVIT611->R_E_C_N_O_)),18),;
			           PADR("",6) }
			
		   cLin :=  u_HPreencheLinha(_aIts)
			
		   If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		   		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		    		Exit
		    	Endif
		   Endif          
		   
			QVIT611->(dbSkip())
		enddo
		
		fClose(nHdl)
	endif

	_cArq := Alltrim(mv_par01) + "\TAB_SDA.csv"
	
	processa({|| QrySDA(@nTotRecs)})
    
	if nTotRecs > 0
		nHdl := fCreate(_cArq)
		If nHdl == -1
		    MsgAlert("O arquivo de nome "+_cArq+" nao pode ser criado! Verifique os parametros.", "Atencao!")
		    Return
		Endif
	
		//Cabeçalho da Planilha
		_aIts := { PADR("PRODUTO",17),;
		           PADR("DESCRICAO",50),;
		           PADC("QTD. ORIGINAL",18),;
		           PADC("SALDO",18),;
		           PADC("DATA",13),;
		           PADC("LOTE",15),;
		           PADC("VALIDADE",13),;
		           PADC("ARMAZEM",10),;
		           PADC("DOCUMENTO",15),;
		           PADC("SERIE",7),;
		           PADR("USUARIO INCLUSAO",20),;
		           PADR("USUARIO ALTERACAO",20),;
		           PADC("RECNO",18),;
		           PADC("OK",6) }
	
	    cLin :=  u_HPreencheLinha(_aIts)
	    
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        //If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Return
	        //Endif
	    Endif
	
		ProcRegua(nTotRecs)
	
		QVIT611->(dbGoTop()) 
		do while QVIT611->(!Eof())
		 	IncProc( "Produto " + AllTrim(QVIT611->DA_PRODUTO) + " Lote " + AllTrim(QVIT611->DA_LOTECTL) + " Documento " + AllTrim(QVIT611->DA_DOC) + " Série " + AllTrim(QVIT611->DA_SERIE) )
			
			_aIts := { PADR(QVIT611->DA_PRODUTO,17),;
			           PADR(QVIT611->B1_DESC,50),;
			           PADR(transform(QVIT611->DA_QTDORI, "@E 99,999,999,999.99"),18),;
			           PADR(transform(QVIT611->DA_SALDO, "@E 99,999,999,999.99"),18),;
			           PADR(DtoC(StoD(QVIT611->DA_DATA)),13),;
			           PADR(QVIT611->DA_LOTECTL,15),;
			           PADR(DtoC(StoD(QVIT611->B8_DTVALID)),13),;
			           PADR(QVIT611->DA_LOCAL,10),;
			           PADR(QVIT611->DA_DOC,15),;
			           PADR(QVIT611->DA_SERIE,7),;
			           PADR(Embaralha(QVIT611->DA_USERLGI,1),20),;
			           PADR(Embaralha(QVIT611->DA_USERLGA,1),20),;
			           PADR(Alltrim(Str(QVIT611->R_E_C_N_O_)),18),;
			           PADR("",6) }
			
		   cLin :=  u_HPreencheLinha(_aIts)
			
		   If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		   		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		    		Exit
		    	Endif
		   Endif          
		   
			QVIT611->(dbSkip())
		enddo
		
		fClose(nHdl)
	endif

	_cArq := Alltrim(mv_par01) + "\TAB_SD4.csv"
	
	processa({|| QrySD4(@nTotRecs)})
    
	if nTotRecs > 0
		nHdl := fCreate(_cArq)
		If nHdl == -1
		    MsgAlert("O arquivo de nome "+_cArq+" nao pode ser criado! Verifique os parametros.", "Atencao!")
		    Return
		Endif
	
		//Cabeçalho da Planilha
		_aIts := { PADR("PRODUTO",17),;
		           PADR("DESCRICAO",50),;
		           PADR("COMPONENTE",17),;
		           PADR("DESCRICAO DO COMPONENTE",50),;
		           PADR("TP COMP.",10),;
		           PADR("OP",18),;
		           PADR("TRT",06),;
		           PADR("EMISSAO",18),;
		           PADR("DT. REAL FIM",18),;
		           PADR("ARMAZEM",10),;
		           PADR("LOTE",15),;
		           PADR("VALIDADE",17),;
		           PADC("DT EMPENHO",13),;
		           PADC("QTD. EMPENHO",18),;
		           PADC("SLD. EMPENHO",18),;
		           PADR("USUARIO INCLUSAO",20),;
		           PADR("USUARIO ALTERACAO",20),;
		           PADC("RECNO",18),;
		           PADC("OK",6) }
		           
	    cLin :=  u_HPreencheLinha(_aIts)
	    
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        //If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Return
	        //Endif
	    Endif
	
		ProcRegua(nTotRecs)
	
		QVIT611->(dbGoTop()) 
		do while QVIT611->(!Eof())
		 	IncProc( "Produto " + AllTrim(QVIT611->D4_PRODUTO) + " OP " + AllTrim(QVIT611->D4_OP) + " Lote " + AllTrim(QVIT611->D4_LOTECTL) )

			_aIts := { PADR(QVIT611->D4_PRODUTO,17),;
			           PADR(QVIT611->B1_DESC,50),;
			           PADR(QVIT611->D4_COD,17),;
			           PADR(QVIT611->DESCCOMP,50),;
			           PADR(QVIT611->TPCOMP,10),;
			           PADR(QVIT611->D4_OP,18),;
			           PADR(QVIT611->D4_TRT,6),;
			           PADR(DtoC(StoD(QVIT611->C2_EMISSAO)),18),;
			           PADR(DtoC(StoD(QVIT611->C2_DATRF)),18),;
			           PADR(QVIT611->D4_LOCAL,10),;
			           PADR(QVIT611->D4_LOTECTL,15),;
			           PADR(QVIT611->D4_DTVALID,15),;
			           PADR(DtoC(StoD(QVIT611->D4_DATA)),13),;
			           PADR(transform(QVIT611->D4_QTDEORI, "@E 99,999,999,999.99"),18),;
			           PADR(transform(QVIT611->D4_QUANT, "@E 99,999,999,999.99"),18),;
			           PADR(Embaralha(QVIT611->D4_USERLGI,1),20),;
			           PADR(Embaralha(QVIT611->D4_USERLGA,1),20),;
			           PADR(Alltrim(Str(QVIT611->R_E_C_N_O_)),18),;
			           PADR("",6) }
			
		   cLin :=  u_HPreencheLinha(_aIts)
			
		   If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		   		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		    		Exit
		    	Endif
		   Endif          
		   
			QVIT611->(dbSkip())
		enddo
		
		fClose(nHdl)
	endif

	_cArq := Alltrim(mv_par01) + "\TAB_SDD.csv"
	
	processa({|| QrySDD(@nTotRecs)})
    
	if nTotRecs > 0
		nHdl := fCreate(_cArq)
		If nHdl == -1
		    MsgAlert("O arquivo de nome "+_cArq+" nao pode ser criado! Verifique os parametros.", "Atencao!")
		    Return
		Endif
	
		//Cabeçalho da Planilha
		_aIts := { PADR("DOCUMENTO",12),;
		           PADR("PRODUTO",17),;
		           PADR("DESCRICAO",50),;
		           PADR("ARMAZEM",10),;
		           PADR("LOTE",15),;
		           PADR("VALIDADE",15),;
		           PADR("ENDERECO",15),;
		           PADR("NUM SERIE",20),;
		           PADC("QUANTIDADE",18),;
		           PADC("SALDO",18),;
		           PADC("QTD. ORIGEM",18),;
		           PADC("MOTIVO",08),;
		           PADC("OBSERVACAO",35),;
		           PADR("DT. LIBERACAO",15),;
		           PADR("DT. BLOQUEIO",15),;
		           PADR("USUARIO INCLUSAO",20),;
		           PADR("USUARIO ALTERACAO",20),;
		           PADC("RECNO",18),;
		           PADC("OK",6) }
		           
	    cLin :=  u_HPreencheLinha(_aIts)
	    
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        //If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Return
	        //Endif
	    Endif
	
		ProcRegua(nTotRecs)
	
		QVIT611->(dbGoTop()) 
		do while QVIT611->(!Eof())
		 	IncProc( " Doc. " + AllTrim(QVIT611->DD_DOC) + "Produto " + AllTrim(QVIT611->DD_PRODUTO) + " Lote " + AllTrim(QVIT611->DD_LOTECTL) )
			
			_aIts := { PADR(QVIT611->DD_DOC,18),;
			           PADR(QVIT611->DD_PRODUTO,17),;
			           PADR(QVIT611->B1_DESC,50),;
			           PADR(QVIT611->DD_LOCAL,10),;
			           PADR(QVIT611->DD_LOTECTL,15),;
			           PADR(DtoC(StoD(QVIT611->DD_DTVALID)),15),;
			           PADR(QVIT611->DD_LOCALIZ,15),;
			           PADR(QVIT611->DD_NUMSERI,20),;
			           PADR(transform(QVIT611->DD_QUANT, "@E 99,999,999,999.99"),18),;
			           PADR(transform(QVIT611->DD_SALDO, "@E 99,999,999,999.99"),18),;
			           PADR(transform(QVIT611->DD_QTDORIG, "@E 99,999,999,999.99"),18),;
			           PADR(QVIT611->DD_MOTIVO,08),;
			           PADR(QVIT611->DD_OBSERVA,35),;
			           PADR(DtoC(StoD(QVIT611->DD_DTLIB)),15),;
			           PADR(DtoC(StoD(QVIT611->DD_DTBLOQ)),15),;
			           PADR(Embaralha(QVIT611->DD_USERLGI,1),20),;
			           PADR(Embaralha(QVIT611->DD_USERLGA,1),20),;
			           PADR(Alltrim(Str(QVIT611->R_E_C_N_O_)),18),;
			           PADR("",6) }
			
		   cLin :=  u_HPreencheLinha(_aIts)
			
		   If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		   		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		    		Exit
		    	Endif
		   Endif          
		   
			QVIT611->(dbSkip())
		enddo
		
		fClose(nHdl)
	endif

	_cArq := Alltrim(mv_par01) + "\TAB_SC9.csv"
	
	processa({|| QrySC9(@nTotRecs)})
    
	if nTotRecs > 0
		nHdl := fCreate(_cArq)
		If nHdl == -1
		    MsgAlert("O arquivo de nome "+_cArq+" nao pode ser criado! Verifique os parametros.", "Atencao!")
		    Return
		Endif
	
		//Cabeçalho da Planilha
		_aIts := { PADR("PEDIDO",12),;
		           PADR("ITEM",7),;
		           PADR("SEQUENCIA",12),;
		           PADR("PRODUTO",17),;
		           PADR("DESCRICAO",50),;
		           PADR("ARMAZEM",10),;
		           PADR("LOTE",15),;
		           PADR("VALIDADE",17),;
		           PADR("DT. LIB.",13),;
		           PADC("QTD. LIBERADA",18),;
		           PADR("CLIENTE",10),;
		           PADR("LOJA",7),;
		           PADR("NOME CLIENTE",60),;
		           PADR("USUARIO INCLUSAO",20),;
		           PADR("USUARIO ALTERACAO",20),;
		           PADC("RECNO",18),;
		           PADC("OK",6) }

	    cLin :=  u_HPreencheLinha(_aIts)
	    
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        //If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Return
	        //Endif
	    Endif
	
		ProcRegua(nTotRecs)
	
		QVIT611->(dbGoTop()) 
		do while QVIT611->(!Eof())
		 	IncProc( " Pedido\Item " + AllTrim(QVIT611->C9_PEDIDO) + "\" + AllTrim(QVIT611->C9_ITEM) + "Produto " + AllTrim(QVIT611->C9_PRODUTO) + " Lote " + AllTrim(QVIT611->C9_LOTECTL) )
			
			_aIts := { PADR(QVIT611->C9_PEDIDO,18),;
			           PADR(QVIT611->C9_ITEM,18),;
			           PADR(QVIT611->C9_SEQUEN,18),;
			           PADR(QVIT611->C9_PRODUTO,17),;
			           PADR(QVIT611->B1_DESC,50),;
			           PADR(QVIT611->C9_LOCAL,10),;
			           PADR(QVIT611->C9_LOTECTL,15),;
			           PADR(DtoC(StoD(QVIT611->C9_DTVALID)),17),;
			           PADR(DtoC(StoD(QVIT611->C9_DATALIB)),13),;
			           PADR(transform(QVIT611->C9_QTDLIB, "@E 99,999,999,999.99"),18),;
			           PADR(QVIT611->C9_CLIENTE,10),;
			           PADR(QVIT611->C9_LOJA,7),;
			           PADR(QVIT611->A1_NOME,60),;
			           PADR(Embaralha(QVIT611->C9_USERLGI,1),20),;
			           PADR(Embaralha(QVIT611->C9_USERLGA,1),20),;
			           PADR(Alltrim(Str(QVIT611->R_E_C_N_O_)),18),;
			           PADR("",6) }
			
		   cLin :=  u_HPreencheLinha(_aIts)
			
		   If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		   		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		    		Exit
		    	Endif
		   Endif          
		   
			QVIT611->(dbSkip())
		enddo
		
		fClose(nHdl)
	endif

	_cArq := Alltrim(mv_par01) + "\TAB_SC6.csv"
	
	processa({|| QrySC6(@nTotRecs)})
    
	if nTotRecs > 0
		nHdl := fCreate(_cArq)
		If nHdl == -1
		    MsgAlert("O arquivo de nome "+_cArq+" nao pode ser criado! Verifique os parametros.", "Atencao!")
		    Return
		Endif
	
		//Cabeçalho da Planilha
		_aIts := { PADR("PEDIDO",12),;
		           PADR("ITEM",7),;
		           PADR("EMISSAO",13),;
		           PADR("PRODUTO",17),;
		           PADR("DESCRICAO",50),;
		           PADR("ARMAZEM",10),;
		           PADR("LOTE",17),;
		           PADR("VALIDADE",17),;
		           PADC("QUANTIDADE",18),;
		           PADC("QTD. EMPENHADA",18),;
		           PADR("CLIENTE",10),;
		           PADR("LOJA",7),;
		           PADR("NOME CLIENTE",60),;
		           PADR("USUARIO INCLUSAO",20),;
		           PADR("USUARIO ALTERACAO",20),;
		           PADC("RECNO",18),;
		           PADC("OK",6) }


	    cLin :=  u_HPreencheLinha(_aIts)
	    
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        //If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Return
	        //Endif
	    Endif
	
		ProcRegua(nTotRecs)
	
		QVIT611->(dbGoTop()) 
		do while QVIT611->(!Eof())
		 	IncProc( " Pedido\Item " + AllTrim(QVIT611->C6_NUM) + "\" + AllTrim(QVIT611->C6_ITEM) + "Produto " + AllTrim(QVIT611->C6_PRODUTO) )
			
			_aIts := { PADR(QVIT611->C6_NUM,18),;
			           PADR(QVIT611->C6_ITEM,18),;
			           PADR(DtoC(StoD(QVIT611->C5_EMISSAO)),13),;
			           PADR(QVIT611->C6_PRODUTO,17),;
			           PADR(QVIT611->B1_DESC,50),;
			           PADR(QVIT611->C6_LOCAL,10),;
			           PADR(QVIT611->C6_LOTECTL,17),;
			           PADR(DtoC(StoD(QVIT611->C6_DTVALID)),17),;
			           PADR(transform(QVIT611->C6_QTDVEN, "@E 99,999,999,999.99"),18),;
			           PADR(transform(QVIT611->C6_QTDRESE, "@E 99,999,999,999.99"),18),;
			           PADR(QVIT611->C6_CLI,10),;
			           PADR(QVIT611->C6_LOJA,7),;
			           PADR(QVIT611->A1_NOME,60),;
			           PADR(Embaralha(QVIT611->C6_USERLGI,1),20),;
			           PADR(Embaralha(QVIT611->C6_USERLGA,1),20),;
			           PADR(Alltrim(Str(QVIT611->R_E_C_N_O_)),18),;
			           PADR("",6) }
			
		   cLin :=  u_HPreencheLinha(_aIts)
			
		   If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		   		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		    		Exit
		    	Endif
		   Endif          
		   
			QVIT611->(dbSkip())
		enddo
		
		fClose(nHdl)
	endif

	Alert("Arquivos gerados com sucesso...")
	
	If ! ApOleClient( 'MsExcel' )
		MsgStop( "Microsoft Excel não instalado!")
	else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _cArq ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	endif
	
Return

Static Function QrySC1(pRecnos)
Local cQry

	IncProc("Solicitação de Compras...")

	cQry :=        " SELECT SC1.* "
	cQry += CRLF + " FROM " + retsqlname("SC1") + " SC1 "
	cQry += CRLF + " WHERE SC1.C1_FILIAL  = '"+XFilial("SC1")+"' "
	cQry += CRLF + "   AND SC1.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "   AND SC1.C1_QUANT   <> SC1.C1_QUJE "
	cQry += CRLF + " ORDER BY SC1.C1_NUM, SC1.C1_ITEM "

	if Select("QVIT611") > 0
		QVIT611->(dbCloseArea())
	endif

	MemoWrite("c:\Vit611.sql",cQry)
	
	pRecnos := u_CountRegs(cQry,"QVIT611")
	
return

Static Function QrySC7(pRecnos)
Local cQry

	IncProc("Pedidos de Compras...")

	cQry :=        " SELECT SC7.* "
	cQry += CRLF + " FROM " + retsqlname("SC7") + " SC7 "
	cQry += CRLF + " WHERE SC7.C7_FILIAL  = '"+XFilial("SC7")+"' "
	cQry += CRLF + "   AND SC7.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "   AND SC7.C7_QUJE    < SC7.C7_QUANT "
	cQry += CRLF + " ORDER BY SC7.C7_NUM, SC7.C7_ITEM "

	if Select("QVIT611") > 0
		QVIT611->(dbCloseArea())
	endif

	MemoWrite("c:\Vit611.sql",cQry)
	
	pRecnos := u_CountRegs(cQry,"QVIT611")
	
return

Static Function QrySC2(pRecnos)
Local cQry

	IncProc("Ordens de Produção...")

	cQry :=        " SELECT SB1.B1_DESC, SC2.* "
	cQry += CRLF + " FROM " + retsqlname("SC2") + " SC2 "
	cQry += CRLF + " INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' AND SB1.B1_COD = SC2.C2_PRODUTO AND SB1.D_E_L_E_T_ = ' ')"
	cQry += CRLF + " WHERE SC2.C2_FILIAL  = '"+XFilial("SC2")+"' "
	cQry += CRLF + "   AND SC2.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "   AND SC2.C2_DATRF   = ' ' "
	cQry += CRLF + " ORDER BY SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN "

	if Select("QVIT611") > 0
		QVIT611->(dbCloseArea())
	endif

	MemoWrite("c:\Vit611.sql",cQry)
	
	pRecnos := u_CountRegs(cQry,"QVIT611")
	
return

Static Function QrySDA(pRecnos)
Local cQry

	IncProc("Saldos à Endereçar...")

	cQry :=        " SELECT SB1.B1_DESC, SB8.B8_DTVALID, SDA.* "
	cQry += CRLF + " FROM " + retsqlname("SDA") + " SDA "
	cQry += CRLF + " INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' AND SB1.B1_COD = SDA.DA_PRODUTO AND SB1.D_E_L_E_T_ = ' ')"
	cQry += CRLF + " INNER JOIN " + retsqlname("SB8") + " SB8 ON (SB8.B8_FILIAL = '"+XFilial("SB8")+"' AND SB8.B8_PRODUTO = SDA.DA_PRODUTO AND SB8.B8_LOCAL = SDA.DA_LOCAL AND SB8.B8_LOTECTL = SDA.DA_LOTECTL AND SB8.B8_NUMLOTE = SDA.DA_NUMLOTE AND SB8.D_E_L_E_T_ = ' ')"
	cQry += CRLF + " WHERE SDA.DA_FILIAL  = '"+XFilial("SDA")+"' "
	cQry += CRLF + "   AND SDA.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "   AND SDA.DA_SALDO   <> 0 "
	cQry += CRLF + " ORDER BY SDA.DA_PRODUTO, SDA.DA_LOTECTL "

	if Select("QVIT611") > 0
		QVIT611->(dbCloseArea())
	endif

	MemoWrite("c:\Vit611.sql",cQry)
	
	pRecnos := u_CountRegs(cQry,"QVIT611")
	
return

Static Function QrySD4(pRecnos)
Local cQry

	IncProc("Ajustes de Empenho...")

	cQry :=        " SELECT SB1.B1_DESC, B1C.B1_DESC DESCCOMP, B1C.B1_TIPO TPCOMP, SC2.C2_EMISSAO, SC2.C2_DATPRI, SC2.C2_DATRF, SD4.* "
	cQry += CRLF + " FROM " + retsqlname("SD4") + " SD4 "
	cQry += CRLF + " LEFT JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' AND SB1.B1_COD = SD4.D4_PRODUTO AND SB1.D_E_L_E_T_ = ' ')"
	cQry += CRLF + " INNER JOIN " + retsqlname("SB1") + " B1C ON (B1C.B1_FILIAL = '"+XFilial("SB1")+"' AND B1C.B1_COD = SD4.D4_COD AND B1C.D_E_L_E_T_ = ' ')"
	cQry += CRLF + " INNER JOIN " + RetSqlName("SC2") + " SC2 ON (SC2.C2_FILIAL                                    = '" + xFilial("SC2") + "' "
	cQry += CRLF + "                                              AND (SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN) = SD4.D4_OP "
	cQry += CRLF + "                                              AND SC2.D_E_L_E_T_                               <> '*')"
	cQry += CRLF + " WHERE SD4.D4_FILIAL  = '"+XFilial("SD4")+"' "
	cQry += CRLF + "   AND SD4.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "   AND SD4.D4_QUANT   <> 0 "
	cQry += CRLF + " ORDER BY SD4.D4_PRODUTO, SD4.D4_LOTECTL "

	if Select("QVIT611") > 0
		QVIT611->(dbCloseArea())
	endif

	MemoWrite("c:\Vit611SD4.sql",cQry)
	
	pRecnos := u_CountRegs(cQry,"QVIT611")
	
return

Static Function QrySDD(pRecnos)
Local cQry

	IncProc("Bloqueio de Lotes...")

	cQry :=        " SELECT SB1.B1_DESC, SDD.* "
	cQry += CRLF + " FROM " + retsqlname("SDD") + " SDD "
	cQry += CRLF + " INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' AND SB1.B1_COD = SDD.DD_PRODUTO AND SB1.D_E_L_E_T_ = ' ')"
	cQry += CRLF + " WHERE SDD.DD_FILIAL  = '"+XFilial("SDD")+"' "
	cQry += CRLF + "   AND SDD.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "   AND SDD.DD_QUANT   <> 0 "
	cQry += CRLF + " ORDER BY SDD.DD_PRODUTO, SDD.DD_LOTECTL "

	if Select("QVIT611") > 0
		QVIT611->(dbCloseArea())
	endif

	MemoWrite("c:\Vit611.sql",cQry)
	
	pRecnos := u_CountRegs(cQry,"QVIT611")
	
return

Static Function QrySC9(pRecnos)
Local cQry

	IncProc("Pedidos Liberados...")

	cQry :=        " SELECT SB1.B1_DESC, SA1.A1_NOME, SC9.* "
	cQry += CRLF + " FROM " + retsqlname("SC9") + " SC9 "
	cQry += CRLF + " LEFT JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' AND SB1.B1_COD = SC9.C9_PRODUTO AND SB1.D_E_L_E_T_ = ' ')"
	cQry += CRLF + " LEFT JOIN " + retsqlname("SA1") + " SA1 ON (SA1.A1_FILIAL = '"+XFilial("SA1")+"' AND SA1.A1_COD = SC9.C9_CLIENTE AND SA1.A1_LOJA = SC9.C9_LOJA AND SA1.D_E_L_E_T_ = ' ')"
	cQry += CRLF + " WHERE SC9.C9_FILIAL  = '"+XFilial("SC9")+"' "
	cQry += CRLF + "   AND SC9.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "   AND SC9.C9_NFISCAL = ' ' "
	cQry += CRLF + " ORDER BY SC9.C9_PRODUTO, SC9.C9_LOTECTL "

	if Select("QVIT611") > 0
		QVIT611->(dbCloseArea())
	endif

	MemoWrite("c:\Vit611.sql",cQry)
	
	pRecnos := u_CountRegs(cQry,"QVIT611")
	
return

Static Function QrySC6(pRecnos)
Local cQry

	IncProc("Pedidos de Venda para Eliminar Resíduo...")

	cQry :=        " SELECT SB1.B1_DESC, SA1.A1_NOME, SC5.C5_EMISSAO, SC6.* "
	cQry += CRLF + " FROM " + retsqlname("SC6") + " SC6 "
	cQry += CRLF + " INNER JOIN " + retsqlname("SC5") + " SC5 ON (SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_ = ' ') "
	cQry += CRLF + " INNER JOIN " + retsqlname("SA1") + " SA1 ON (SA1.A1_FILIAL = '"+XFilial("SA1")+"' AND SA1.A1_COD = SC6.C6_CLI AND SA1.A1_LOJA = SC6.C6_LOJA AND SA1.D_E_L_E_T_ = ' ')"
	cQry += CRLF + " INNER JOIN " + retsqlname("SB1") + " SB1 ON (SB1.B1_FILIAL = '"+XFilial("SB1")+"' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ')"
	cQry += CRLF + " WHERE SC6.C6_FILIAL  = '"+XFilial("SC6")+"' "
	cQry += CRLF + "   AND SC6.D_E_L_E_T_ = ' ' "
	cQry += CRLF + "   AND SC6.C6_NOTA    = ' ' "
	cQry += CRLF + "   AND SC6.C6_BLQ     <> 'R' "
	cQry += CRLF + " ORDER BY SC6.C6_PRODUTO, SC6.C6_LOTECTL "

	if Select("QVIT611") > 0
		QVIT611->(dbCloseArea())
	endif

	MemoWrite("c:\Vit611.sql",cQry)
	
	pRecnos := u_CountRegs(cQry,"QVIT611")
	
return

/**************************/
Static Function ValidPerg() 
/**************************/
Local aHelpPor := {}
Local cPerg    := "Vit611    "

PutSx1(cPerg,"01",OemToAnsi("Pasta \ Diretório "),"","","mv_ch1","C",090,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,{},{})

Return(Pergunte(cPerg,.T.))
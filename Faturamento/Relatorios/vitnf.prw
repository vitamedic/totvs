#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

#IFNDEF WINDOWS
#DEFINE PSAY SAY
#ENDIF

User Function VITNF()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE,XDESPESA")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO,XTIPOPED")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XQTD_PRO,XQTD_QT,XPRE_UNI,XLOTE")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_UNIT")
SetPrvt("XDESCRICAO,XUNID_PRO,XUNID_PRO2,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XCOD_MENS,XMENSAGEM")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF,XLIMINAR")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO,XFORMULA")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB,_NCASAS,xTPCLIEN")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	#DEFINE PSAY SAY
#ENDIF
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NFISCAL ³ Autor ³ Marcos Simidu         ³ Data ³ 20/12/95  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Nota Fiscal de Entrada / Saida                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦ 
//¦ mv_par03             // Da Serie                             ¦ 
//¦ mv_par04             // Nota Fiscal de Entrada/Saida         ¦ 
//+--------------------------------------------------------------+
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="G" 
limite:=220
titulo :=PADC("Nota Fiscal - Nfiscal",74)
cDesc1 :=PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2 :=""
cDesc3 :=PADC("da Nfiscal",74)
cNatureza:="" 
aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="nfiscal" 
cPerg:="NFSIGW"
nLastKey:= 0 
lContinua := .T.
nLin:=0
wnrel    := "siganf"

//+-----------------------------------------------------------+
//¦ Tamanho do Formulario de Nota Fiscal (em Linhas)          ¦
//+-----------------------------------------------------------+

nTamNf:=100     // Apenas Informativo 

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
   Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦          
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

VerImp()       

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦ Inicio do Processamento da Nota Fiscal                       ¦
//¦                                                              ¦
//+--------------------------------------------------------------+
#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	RptStatus({|| Execute(RptDetail)})	
	Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	Function RptDetail
Static Function RptDetail()
#ENDIF

If mv_par04 == 2
   dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
   dbSetOrder(1)
   dbSeek(xFilial()+mv_par01+mv_par03,.t.)
   
   dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
   dbSetOrder(3)
   dbSeek(xFilial()+mv_par01+mv_par03)
   cPedant := SD2->D2_PEDIDO
Else
   dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
   DbSetOrder(1)
   dbSeek(xFilial()+mv_par01+mv_par03,.t.)

   dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
   dbSetOrder(3)
Endif

//+-----------------------------------------------------------+
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+
SetRegua(Val(mv_par02)-Val(mv_par01))
If mv_par04 == 2
   dbSelectArea("SF2")
   While !eof() .and. SF2->F2_DOC    <= mv_par02 .and. lContinua
       _npreco2 := 0
      If SF2->F2_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
         DbSkip()                    // do Parametro Informado !!!
         Loop
      Endif
		If SF2->F2_LIBTRAN #"S"    // Se o apontamento de peso e volume # "S"
											 // não emite nota !!!
         MSGINFO(SF2->F2_DOC+" esta nota não teve apontamento de volume e transportadora. Contate o setor de Transporte.")		             
         DbSkip()                    
         Loop
      Endif  

	#IFNDEF WINDOWS
	      IF LastKey()==286
	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
	         lContinua := .F.
	         Exit
	      Endif
	#ELSE
	      IF lAbortPrint
	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
	         lContinua := .F.
	         Exit
	      Endif
	#ENDIF

      nLinIni:=nLin                         // Linha Inicial da Impressao


      //+--------------------------------------------------------------+
      //¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
      //+--------------------------------------------------------------+

      // * Cabecalho da Nota Fiscal

      xNUM_NF     :=SF2->F2_DOC             // Numero
      xSERIE      :=SF2->F2_SERIE           // Serie
      xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
      xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
      if xTOT_FAT == 0
         xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE+SF2->F2_DESPESA
      endif
      xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
      xFRETE      :=SF2->F2_FRETE           // Frete
      xSEGURO     :=SF2->F2_SEGURO          // Seguro
      xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
      xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
      xBSICMRET   :=SF2->F2_BRICMS          // Base   do ICMS Retido
      xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
      xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido
      xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
      xDESPESA    :=SF2->F2_DESPESA         // Valor  das DESPESAS
      xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
      xVALOR_DESC :=SF2->F2_DESCONT         // Valor  da DESCONTO
      xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
      xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
      xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
      xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
      xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
      xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
      xVOLUME     :=SF2->F2_VOLUME1         // Volume 1 no Pedido

     
      dbSelectArea("SD2")                   // * Itens de Venda da N.F.
      dbSetOrder(3)
      dbSeek(xFilial()+xNUM_NF+xSERIE)

      
      cPedAtu := SD2->D2_PEDIDO
      cItemAtu := SD2->D2_ITEMPV

      xPED_VEND:={}                         // Numero do Pedido de Venda
      xITEM_PED:={}                         // Numero do Item do Pedido de Venda
      xNUM_NFDV:={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
      xPREF_DV :={}                         // Serie  quando houver devolucao
      xICMS    :={}                         // Porcentagem do ICMS
      xCOD_PRO :={}                         // Codigo  do Produto
      xQTD_PRO :={}                         // Peso/Quantidade do Produto
      xQTD_QT  :={}                         // Peso/Quantidade do Produto
      xUNID_PRO2:={}                         // Peso/Quantidade do Produto
      xPRE_UNI :={}                         // Preco Unitario de Venda
      xPRE_TAB :={}                         // Preco Unitario de Tabela
      xIPI     :={}                         // Porcentagem do IPI
      xVAL_IPI :={}                         // Valor do IPI
      xDESC    :={}                         // Desconto por Item
      xTOT     :={}                         // TOTAL S/ DESCONTO 
      xVAL_DESC:={}                         // Valor do Desconto
      xVAL_MERC:={}                         // Valor da Mercadoria
      xTES     :={}                         // TES
      xCF      :={}                         // Classificacao quanto natureza da Operacao
      xICMSOL  :={}                         // Base do ICMS Solidario
      xICM_PROD:={}                         // ICMS do Produto
      xLOTE    :={}                         // Lote do Produto
      xCOD_TRIB:={}                           // Codigo de Tributacao
      _nrepasse:=0
      _nprep   :=0
		_ndesczfr:=0
		_ntotal:=0   
      _nprec2:=0
      sc5->(dbsetorder(1))
      while !eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			 If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
        		 DbSkip()                   // do Parametro Informado !!!
	   	      Loop
			 Endif                 
			 dbSelectArea("SC5")
			 dbSetOrder(1)   			 
	 		 dbseek(xfilial("SC5")+sd2->d2_pedido)
      	 dbSelectArea("SB1")
			 dbSetOrder(1)   
          dbSeek(xFilial("SB1")+SD2->D2_COD)

         AADD(xPED_VEND ,SD2->D2_PEDIDO)
         AADD(xITEM_PED ,SD2->D2_ITEMPV)
         AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI)," ",SD2->D2_NFORI))
         AADD(xPREF_DV  ,SD2->D2_SERIORI)
         AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
         AADD(xCOD_PRO  ,SD2->D2_COD)
         AADD(xQTD_QT   ,SD2->D2_QUANT)     // Guarda as quant. da NF 
         _ncasas:=0
         if sc5->c5_desc3>0 
            _npreco := sd2->d2_prcven      
            _nquant := sd2->d2_quant         
//          _ncasas := if(empty(sc5->c5_numlic),2,6)
//	      	_npreco  :=round(_npreco/(1-sc5->c5_desc3/100),_ncasas)
	      	_npreco  :=round(_npreco/(1-sc5->c5_desc3/100),6)
	        	_ntotal  :=round(_nquant*_npreco,2)
	      	_npreco  :=round(_npreco,2)
   	    	_nprep   :=sc5->c5_desc3
	  	    	_nrepasse+=_ntotal-sd2->d2_total
	  	  	   if sd2->d2_desczfr>0
					_ntotal+=sd2->d2_desczfr
					_npreco:=round(_ntotal/_nquant,2)
					_ndesczfr+=sd2->d2_desczfr       
				endif                               
				if !empty(sc5->c5_numlic) .and. sc5->c5_licitac = "S"
		     		dbSelectArea("SZL")
					dbSetOrder(3)   
			  		dbSeek(xFilial("SZL")+sc5->c5_numlic)

 			  		if szl->zl_umprop =="2" 
  				  		_npreco := round(_npreco/sb1->b1_conv,6)
  				  		_nquant := sd2->d2_quant*sb1->b1_conv
  				  	endif	
			    endif
			    AADD(xPRE_UNI  ,_npreco)
			    AADD(xVAL_MERC ,_ntotal)
             AADD(xQTD_PRO  ,_nquant)     // Guarda as quant. da NF
//             
         elseif sc5->c5_cliente == "394700" // sc5->c5_desc3>0 
              _npreco := sd2->d2_prcven      
              _nquant := sd2->d2_quant         
//            _ncasas := if(empty(sc5->c5_numlic),2,6)
//  	      	_npreco  :=round(_npreco/(1-sc5->c5_desc3/100),_ncasas)
  	      	_npreco  :=round(_npreco/(1-sc5->c5_descit/100),6)
  	        	_ntotal  :=round(_nquant*_npreco,2)
  	      	_npreco  :=round(_npreco,2)
     	    	_nprep   :=sc5->c5_descit
  	  	    	_nrepasse+=_ntotal-sd2->d2_total
  	  	  	   if sd2->d2_desczfr>0
  					_ntotal+=sd2->d2_desczfr
  					_npreco:=round(_ntotal/_nquant,2)
  					_ndesczfr+=sd2->d2_desczfr       
				endif                               
				if !empty(sc5->c5_numlic) .and. sc5->c5_licitac = "S"
		     		dbSelectArea("SZL")
					dbSetOrder(3)   
			  		dbSeek(xFilial("SZL")+sc5->c5_numlic)

 			  		if szl->zl_umprop =="2" 
  				  		_npreco := round(_npreco/sb1->b1_conv,6)
  				  		_nquant := sd2->d2_quant*sb1->b1_conv
  				  	endif	
			    endif
			    AADD(xPRE_UNI  ,_npreco)
			    AADD(xVAL_MERC ,_ntotal)
			    AADD(xTOT,sd2->d2_quant*SD2->D2_PRUNIT)
             AADD(xQTD_PRO  ,_nquant)     // Guarda as quant. da NF
//
         else
			  if sd2->d2_desczfr>0                          
	           _npreco := sd2->d2_prcven       
				  _nzfr := 0
              _ncasas := if(empty(sc5->c5_numlic),2,6)
              _nquant := sd2->d2_quant
  				  _nzfr:=round(sd2->d2_desczfr/_nquant,_ncasas)
				  _npreco :=sd2->d2_prcven+_nzfr
				  _ntotal :=round(sd2->d2_total+sd2->d2_desczfr,_ncasas)
				  _ndesczfr+=sd2->d2_desczfr
   		  else                      
   			  _npreco:=sd2->d2_prcven
   			  _ntotal:=sd2->d2_total
				  _nquant := sd2->d2_quant   			  
        	  endif
			  if !empty(sc5->c5_numlic) .and. sc5->c5_licitac = "S"
  
		     		dbSelectArea("SZL")
					dbSetOrder(3)   
			  		dbSeek(xFilial("SZL")+sc5->c5_numlic)
			  		if szl->zl_umprop =="2" 		  			
				  		_npreco := _npreco/sb1->b1_conv
  				  		_nquant := sd2->d2_quant * sb1->b1_conv
  				  	endif	
			  endif                                 
			  
   	     AADD(xPRE_UNI  ,_npreco)
	        AADD(xVAL_MERC ,_ntotal)
           AADD(xQTD_PRO  ,_nquant)     // Guarda as quant. da NF
         endif
         AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
         AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
         AADD(xVAL_IPI  ,SD2->D2_VALIPI)
         AADD(xDESC     ,SD2->D2_DESC)
         AADD(xTES      ,SD2->D2_TES)
         AADD(xCF       ,SD2->D2_CF)
         AADD(xLOTE     ,SD2->D2_LOTECTL)
         AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
         AADD(xCOD_TRIB ,SD2->D2_CLASFIS)
         sd2->(dbskip())
      End

      dbSelectArea("SB1")                     // * Desc. Generica do Produto
      dbSetOrder(1)
      xPESO_PRO:={}                           // Peso Liquido
      xPESO_UNIT :={}                         // Peso Unitario do Produto
      xDESCRICAO :={}                         // Descricao do Produto
      xUNID_PRO:={}                           // Unidade do Produto
      xMEN_TRIB:={}                           // Mensagens de Tributacao
      xCOD_FIS :={}                           // Cogigo Fiscal
      xCLAS_FIS:={}                           // Classificacao Fiscal
      xMEN_POS :={}                           // Mensagem da Posicao IPI
      xISS     :={}                           // Aliquota de ISS
      xTIPO_PRO:={}                           // Tipo do Produto
      xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
      xCLFISCAL   :={}
      xPESO_LIQ := 0
      I:=1

      For I:=1 to Len(xCOD_PRO)
         dbSelectArea("SB1")                     // * Desc. Generica do Produto
      
         dbSetOrder(1)
         dbSeek(xFilial("SB1")+xCOD_PRO[I])
          AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_QT[I])
          xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
          AADD(xPESO_UNIT , SB1->B1_PESO)
          AADD(xDESCRICAO ,{SB1->B1_DESC,I})
          If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
             AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
          Endif

          npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)

//          if npElem == 0
             AADD(xCOD_FIS  ,SB1->B1_POSIPI)
//          endif

          npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)

          DO CASE
             CASE npElem == 1
                _CLASFIS := "A"

             CASE npElem == 2
                _CLASFIS := "B"

             CASE npElem == 3
                _CLASFIS := "C"

             CASE npElem == 4
                _CLASFIS := "D"

             CASE npElem == 5
                _CLASFIS := "E"

             CASE npElem == 6
                _CLASFIS := "F"

           ENDCASE
           nPteste := Ascan(xCLFISCAL,_CLASFIS)
           If nPteste == 0
              AADD(xCLFISCAL,_CLASFIS)
           Endif

//          AADD(xCOD_FIS ,_CLASFIS)
          If SB1->B1_ALIQISS > 0
             AADD(xISS ,SB1->B1_ALIQISS)
          Endif
          AADD(xTIPO_PRO ,SB1->B1_TIPO)
          AADD(xLUCRO    ,SB1->B1_PICMRET)


         //
         // Calculo do Peso Liquido da Nota Fiscal
         //

         xPESO_LIQUID:=0                                 // Peso Liquido da Nota Fiscal
         For j:=1 to Len(xPESO_PRO)
            xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[j]
         Next
      	 dbSelectArea("SZL")
			 dbSetOrder(3)   
			 dbSeek(xFilial("SZL")+sc5->c5_numlic)         
  			 if szl->zl_umprop =="2" 		  			
            AADD(xUNID_PRO ,SB1->B1_SEGUM)
          else                         
            AADD(xUNID_PRO ,SB1->B1_UM)
          endif  
         

      Next

      dbSelectArea("SC5")                            // * Pedidos de Venda
      dbSetOrder(1)

      xPED        := {}
      xPESO_BRUTO := 0
      xP_LIQ_PED  := 0

      For I:=1 to Len(xPED_VEND)

         dbSeek(xFilial()+xPED_VEND[I])

         If ASCAN(xPED,xPED_VEND[I])==0
            dbSeek(xFilial()+xPED_VEND[I])
            xCLIENTE    :=SC5->C5_CLIENTE            // Codigo do Cliente
            xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
            xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
            xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
            xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
            xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
            xTIPOPED    :=SC5->C5_TIPO
            
            xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
            xP_LIQ_PED  :=xP_LIQ_PED + SC5->C5_PESOL // Peso Liquido
            xCOD_VEND:= {SC5->C5_VEND1,;             // Codigo do Vendedor 1
                         SC5->C5_VEND2,;             // Codigo do Vendedor 2
                         SC5->C5_VEND3,;             // Codigo do Vendedor 3
                         SC5->C5_VEND4,;             // Codigo do Vendedor 4
                         SC5->C5_VEND5}              // Codigo do Vendedor 5
            xDESC_NF := {SC5->C5_DESC1,;             // Desconto Global 1
                         SC5->C5_DESC2,;             // Desconto Global 2
                         SC5->C5_DESC3,;             // Desconto Global 3
                         SC5->C5_DESC4}              // Desconto Global 4
            AADD(xPED,xPED_VEND[I])
         Endif

         If xP_LIQ_PED >0
            xPESO_LIQ := xP_LIQ_PED
         Endif

      Next

      //+---------------------------------------------+
      //¦ Pesquisa da Condicao de Pagto               ¦
      //+---------------------------------------------+
                                    

      dbSelectArea("SE4")                    // Condicao de Pagamento
      dbSetOrder(1)
      dbSeek(xFilial("SE4")+xCONDPAG)
      xDESC_PAG := SE4->E4_DESCRI

      dbSelectArea("SC6")                    // * Itens de Pedido de Venda
      dbSetOrder(1)
      xPED_CLI :={}                          // Numero de Pedido
      xDESC_PRO:={}                          // Descricao aux do produto
      J:=Len(xPED_VEND)
      For I:=1 to J
         dbSeek(xFilial()+xPED_VEND[I]+xITEM_PED[I])
         AADD(xPED_CLI ,SC6->C6_PEDCLI)
         AADD(xDESC_PRO,SC6->C6_DESCRI)
         AADD(xVAL_DESC,SC6->C6_VALDESC)
      Next

      If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'

         dbSelectArea("SA1")                // * Cadastro de Clientes
         dbSetOrder(1)
         dbSeek(xFilial()+xCLIENTE+xLOJA)
         xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
         xNOME_CLI:=SA1->A1_NOME            // Nome
         xEND_CLI :=SA1->A1_END             // Endereco
         xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
         xCEP_CLI :=SA1->A1_CEP             // CEP
         xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
         xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
         xMUN_CLI :=SA1->A1_MUN             // Municipio
         xEST_CLI :=SA1->A1_EST             // Estado
         xCGC_CLI :=SA1->A1_CGC             // CGC
         xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
         xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
         xTEL_CLI :=alltrim(sa1->a1_ddd)+" "+alltrim(SA1->A1_TEL)             // Telefone
         xFAX_CLI :=SA1->A1_FAX             // Fax
         xSUFRAMA :=SA1->A1_SUFRAMA            // Codigo Suframa
         xCALCSUF :=SA1->A1_CALCSUF            // Calcula Suframa
         xLIMINAR :=SA1->A1_LIMINAR            // Calcula Suframa
         xTPCLIEN := SA1->A1_TIPO // TIPO CLIENTE
         
         // Alteracao p/ Calculo de Suframa
         if !empty(xSUFRAMA) .and. xCALCSUF =="S"
            IF XTIPO == 'D' .OR. XTIPO == 'B'
               zFranca := .F.
            else
               zFranca := .T.
            endif
         Else
            zfranca:= .F.
         endif

      Else
         zFranca:=.F.
         dbSelectArea("SA2")                // * Cadastro de Fornecedores
         dbSetOrder(1)
         dbSeek(xFilial()+xCLIENTE+xLOJA)
         xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
         xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
         xEND_CLI :=SA2->A2_END             // Endereco
         xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
         xCEP_CLI :=SA2->A2_CEP             // CEP
         xCOB_CLI :=" "                      // Endereco de Cobranca
         xREC_CLI :=" "                      // Endereco de Entrega
         xMUN_CLI :=SA2->A2_MUN             // Municipio
         xEST_CLI :=SA2->A2_EST             // Estado
         xCGC_CLI :=SA2->A2_CGC             // CGC
         xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
         xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
         xTEL_CLI :=alltrim(sa2->a2_ddd)+" "+alltrim(SA2->A2_TEL)             // Telefone
         xFAX_CLI :=SA2->A2_FAX             // Fax
      Endif
      dbSelectArea("SA3")                   // * Cadastro de Vendedores
      dbSetOrder(1)
      xVENDEDOR:={}                         // Nome do Vendedor
      I:=1
      J:=Len(xCOD_VEND)
      For I:=1 to J
         dbSeek(xFilial()+xCOD_VEND[I])
         Aadd(xVENDEDOR,SA3->A3_NREDUZ)
      Next

      If xICMS_RET >0                          // Apenas se ICMS Retido > 0
         dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
         dbSetOrder(4)
         dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
         If Found()
            xBSICMRET:=F3_BASERET
         Else
            xBSICMRET:=0
         Endif
      Else
         xBSICMRET:=0
      Endif
      dbSelectArea("SA4")                   // * Transportadoras
      dbSetOrder(1)
      dbSeek(xFilial()+SF2->F2_TRANSP)
      xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
      xEND_TRANSP  :=SA4->A4_END            // Endereco
      xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
      xEST_TRANSP  :=SA4->A4_EST            // Estado
      xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
      xCGC_TRANSP  :=SA4->A4_CGC            // CGC
      xTEL_TRANSP  :=SA4->A4_TEL            // Fone

      dbSelectArea("SE1")                   // * Contas a Receber
      dbSetOrder(1)
      xPARC_DUP  :={}                       // Parcela
      xVENC_DUP  :={}                       // Vencimento
      xVALOR_DUP :={}                       // Valor
      xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas

      while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
         If !("NF" $ SE1->E1_TIPO)
            dbSkip()
            Loop
         Endif
         AADD(xPARC_DUP ,SE1->E1_PARCELA)
         AADD(xVENC_DUP ,SE1->E1_VENCTO)
         AADD(xVALOR_DUP,SE1->E1_VALOR)
         dbSkip()
      EndDo

      dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
      DbSetOrder(1)
      dbSeek(xFilial()+xTES[1])
      xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
      xFORMULA:=SF4->F4_FORMULA              // Obeservacao da TES

		sf2->(reclock("SF2",.f.))
		sf2->f2_impres:="S"
		sf2->(msunlock())
      Imprime()

      //+--------------------------------------------------------------+
      //¦ Termino da Impressao da Nota Fiscal                          ¦
      //+--------------------------------------------------------------+

      IncRegua()                    // Termometro de Impressao

      nLin:=0
      dbSelectArea("SF2")     
      dbSkip()                      // passa para a proxima Nota Fiscal

   EndDo
Else  // nota de entrada
      //+-----------------------------------------------------------+
      //¦ Inicializa  regua de impressao                            ¦
      //+-----------------------------------------------------------+
	SetRegua(Val(mv_par02)-Val(mv_par01))

   dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada

   dbSeek(xFilial()+mv_par01+mv_par03,.t.)

   While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua

      If SF1->F1_SERIE #mv_par03 .or. sf1->f1_formul<>"S"    // Se a Serie do Arquivo for Diferente
         DbSkip()                    // do Parametro Informado !!!
         Loop
      Endif

	#IFNDEF WINDOWS
	      IF LastKey()==286
	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
	         lContinua := .F.
	         Exit
	      Endif
	#ELSE
	      IF lAbortPrint
	         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
	         lContinua := .F.
	         Exit
	      Endif
	#ENDIF

      nLinIni:=nLin                         // Linha Inicial da Impressao

      //+--------------------------------------------------------------+
      //¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
      //+--------------------------------------------------------------+

      xNUM_NF     :=SF1->F1_DOC             // Numero
      xSERIE      :=SF1->F1_SERIE           // Serie
      xFORNECE    :=SF1->F1_FORNECE         // Cliente/Fornecedor
      xEMISSAO    :=SF1->F1_EMISSAO         // Data de Emissao
      xTOT_FAT    :=SF1->F1_VALBRUT         // Valor Bruto da Compra
      xLOJA       :=SF1->F1_LOJA            // Loja do Cliente
      xFRETE      :=SF1->F1_FRETE           // Frete
      xDESPESA     :=SF1->F1_DESPESA         // Despesa
      xSEGURO     :=SF1->F1_SEGURO         // Seguro
      xBASE_ICMS  :=SF1->F1_BASEICM         // Base   do ICMS
      xBASE_IPI   :=SF1->F1_BASEIPI         // Base   do IPI
      xBSICMRET   :=SF1->F1_BRICMS          // Base do ICMS Retido
      xVALOR_ICMS :=SF1->F1_VALICM          // Valor  do ICMS
      xICMS_RET   :=SF1->F1_ICMSRET         // Valor  do ICMS Retido
      xVALOR_IPI  :=SF1->F1_VALIPI          // Valor  do IPI
      xVALOR_MERC :=SF1->F1_VALMERC-SF1->F1_DESCONT         // Valor  da Mercadoria
      xNUM_DUPLIC :=SF1->F1_DUPL            // Numero da Duplicata
      xCOND_PAG   :=SF1->F1_COND            // Condicao de Pagamento
      xTIPO       :=SF1->F1_TIPO            // Tipo do Cliente
      _nrepasse:=0
		_nprep   :=0
		_ndesczfr:=0

      dbSelectArea("SD1")                   // * Itens da N.F. de Compra
      dbSetOrder(1)
      dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)

      cPedAtu := SD1->D1_PEDIDO
      cItemAtu:= SD1->D1_ITEMPC

      xPEDIDO  :={}                         // Numero do Pedido de Compra
      xITEM_PED:={}                         // Numero do Item do Pedido de Compra
      xNUM_NFDV:={}                         // Numero quando houver devolucao
      xPREF_DV :={}                         // Serie  quando houver devolucao
      xICMS    :={}                         // Porcentagem do ICMS
      xCOD_PRO :={}                         // Codigo  do Produto
      xQTD_PRO :={}                         // Peso/Quantidade do Produto
      xPRE_UNI :={}                         // Preco Unitario de Compra
      xIPI     :={}                         // Porcentagem do IPI
      xPESOPROD:={}                         // Peso do Produto
      xVAL_IPI :={}                         // Valor do IPI
      xDESC    :={}                         // Desconto por Item
      xVAL_DESC:={}                         // Valor do Desconto
      xVAL_MERC:={}                         // Valor da Mercadoria
      xTES     :={}                         // TES
      xCF      :={}                         // Classificacao quanto natureza da Operacao
      xICMSOL  :={}                         // Base do ICMS Solidario
      xICM_PROD:={}                         // ICMS do Produto
      xTOT     :={}                         // TOTAL S/ DESCONTO 
      xLOTE:={}                         // ICMS do Produto
      xCOD_TRIB:={}                           // Codigo de Tributacao
      xDESCRICAO:={}                           // Descricao do Produto		
		sd2->(dbsetorder(3))
		sc5->(dbsetorder(1))
		xpbruto:=0
		xvolume:=0
      while !eof() .and. SD1->D1_DOC==xNUM_NF
         If SD1->D1_SERIE #mv_par03 .or. sd1->d1_fornece<>xfornece .or. sd1->d1_loja<>xloja        // Se a Serie do Arquivo for Diferente
              DbSkip()                      // do Parametro Informado !!!
              Loop
         Endif
			
         AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
         AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
         AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI)," ",SD1->D1_NFORI))
         AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
         AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
         AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
         AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
			if sd1->d1_tipo=="D"
				sd2->(dbseek(xfilial("SD2")+sd1->d1_nfori+sd1->d1_seriori+sd1->d1_fornece+sd1->d1_loja+sd1->d1_cod+sd1->d1_itemori))
				sc5->(dbseek(xfilial("SC5")+sd2->d2_pedido))
         	_npreco  :=round(sd2->d2_prcven/(1-sc5->c5_desc3/100),6)
         	_ntotal  :=round(sd1->d1_quant*_npreco,2)
         	_nprep   :=sc5->c5_desc3
         	_nrepasse+=_ntotal-(sd1->d1_total-sd1->d1_valdesc)
	         AADD(xPRE_UNI  ,_npreco)
	         AADD(xVAL_MERC ,_ntotal)
			else
				AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
				AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
				_ntotal:=sd1->d1_total
			endif
         AADD(xIPI      ,SD1->D1_IPI)            // % IPI
         AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
         AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
         AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
         AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
         AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
         AADD(xCF       ,SD1->D1_LOTECTL)        // Codigo Fiscal
         AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
         AADD(xCOD_TRIB ,SD1->D1_CLASFIS)
//         AADD(xDESCRICAO ,Sd1->d1_DESCpro)
   
			aadd(xlote,sd1->d1_lotectl)
         xpbruto+=SD1->D1_PESO
         xvolume+=sd1->d1_numvol
         dbskip()
//     msgstop(SD1->D1_PESO)
//     msgstop(sd1->d1_numvol)
//     msgstop(SD1->D1_COD)
      End
      dbSelectArea("SB1")                     // * Desc. Generica do Produto
      dbSetOrder(1)
      xUNID_PRO:={}                           // Unidade do Produto
//      xDESC_PRO:={}                           // Descricao do Produto
      xMEN_POS :={}                           // Mensagem da Posicao IPI
      xDESCRICAO :={}                         // Descricao do Produto
      xMEN_TRIB:={}                           // Mensagens de Tributacao
      xCOD_FIS :={}                           // Cogigo Fiscal
      xCLAS_FIS:={}                           // Classificacao Fiscal
      xISS     :={}                           // Aliquota de ISS
      xTIPO_PRO:={}                           // Tipo do Produto
      xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
      xCLFISCAL   :={}
      xSUFRAMA :=" "
      xCALCSUF :=" "

      I:=1
      For I:=1 to Len(xCOD_PRO)

         dbSeek(xFilial()+xCOD_PRO[I])
         dbSelectArea("SB1")

//         AADD(xDESC_PRO ,SB1->B1_DESC)
         AADD(xUNID_PRO ,SB1->B1_UM)
         If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
            AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
         Endif
         AADD(xDESCRICAO ,{SB1->B1_DESC,I})
         AADD(xMEN_POS  ,SB1->B1_POSIPI)
         If SB1->B1_ALIQISS > 0
            AADD(xISS,SB1->B1_ALIQISS)
         Endif
         AADD(xTIPO_PRO ,SB1->B1_TIPO)
         AADD(xLUCRO    ,SB1->B1_PICMRET)

         npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)

//         if npElem == 0
            AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
//         endif
            AADD(xCOD_FIS  ,SB1->B1_POSIPI)
         npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)

         DO CASE
            CASE npElem == 1
               _CLASFIS := "A"

            CASE npElem == 2
               _CLASFIS := "B"

            CASE npElem == 3
               _CLASFIS := "C"

            CASE npElem == 4
               _CLASFIS := "D"

            CASE npElem == 5
               _CLASFIS := "E"

            CASE npElem == 6
               _CLASFIS := "F"

         EndCase
         nPteste := Ascan(xCLFISCAL,_CLASFIS)
         If nPteste == 0
            AADD(xCLFISCAL,_CLASFIS)
         Endif
//         AADD(xCOD_FIS ,_CLASFIS)

      Next

      //+---------------------------------------------+
      //¦ Pesquisa da Condicao de Pagto               ¦
      //+---------------------------------------------+

      dbSelectArea("SE4")                    // Condicao de Pagamento
      dbSetOrder(1)
      dbSeek(xFilial("SE4")+xCOND_PAG)
      xDESC_PAG := SE4->E4_DESCRI

      If xTIPO == "D"

         dbSelectArea("SA1")                // * Cadastro de Clientes
         dbSetOrder(1)
         dbSeek(xFilial()+xFORNECE+xloja)
         xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
         xNOME_CLI:=SA1->A1_NOME            // Nome
         xEND_CLI :=SA1->A1_END             // Endereco
         xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
         xCEP_CLI :=SA1->A1_CEP             // CEP
         xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
         xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
         xMUN_CLI :=SA1->A1_MUN             // Municipio
         xEST_CLI :=SA1->A1_EST             // Estado
         xCGC_CLI :=SA1->A1_CGC             // CGC
         xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
         xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
         xTEL_CLI :=alltrim(sa1->a1_ddd)+" "+alltrim(SA1->A1_TEL)             // Telefone
         xFAX_CLI :=SA1->A1_FAX             // Fax
         XLIMINAR := SA1->A1_LIMINAR
      Else

         dbSelectArea("SA2")                // * Cadastro de Fornecedores
         dbSetOrder(1)
         dbSeek(xFilial()+xFORNECE+xLOJA)
         xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
         xNOME_CLI:=SA2->A2_NOME               // Nome
         xEND_CLI :=SA2->A2_END                // Endereco
         xBAIRRO  :=SA2->A2_BAIRRO             // Bairro
         xCEP_CLI :=SA2->A2_CEP                // CEP
         xCOB_CLI :=" "                         // Endereco de Cobranca
         xREC_CLI :=" "                         // Endereco de Entrega
         xMUN_CLI :=SA2->A2_MUN                // Municipio
         xEST_CLI :=SA2->A2_EST                // Estado
         xCGC_CLI :=SA2->A2_CGC                // CGC
         xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
         xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
         xTEL_CLI :=alltrim(sa2->a2_ddd)+" "+alltrim(SA2->A2_TEL)                // Telefone
         xFAX     :=SA2->A2_FAX                // Fax

      EndIf

      dbSelectArea("SE1")                   // * Contas a Receber
      dbSetOrder(1)
      xPARC_DUP  :={}                       // Parcela
      xVENC_DUP  :={}                       // Vencimento
      xVALOR_DUP :={}                       // Valor
      xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas

      while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
         AADD(xPARC_DUP ,SE1->E1_PARCELA)
         AADD(xVENC_DUP ,SE1->E1_VENCTO)
         AADD(xVALOR_DUP,SE1->E1_VALOR)
         dbSkip()
      EndDo

      dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
      dbSetOrder(1)
      dbSeek(xFilial()+XTES[1])
      xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
      xFORMULA:=SF4->F4_FORMULA              // Natureza da Operacao


      xNOME_TRANSP :=" "           // Nome Transportadora
      xEND_TRANSP  :=" "           // Endereco
      xMUN_TRANSP  :=" "           // Municipio
      xEST_TRANSP  :=" "           // Estado
      xVIA_TRANSP  :=" "           // Via de Transporte
      xCGC_TRANSP  :=" "           // CGC
      xTEL_TRANSP  :=" "           // Fone
      xTPFRETE     :=" "           // Tipo de Frete
//      xVOLUME      := 0            // Volume
      xESPECIE     :=" "           // Especie
      xPESO_LIQ    := 0            // Peso Liquido
      xPESO_BRUTO  := 0            // Peso Bruto
      xCOD_MENS    :=" "           // Codigo da Mensagem
      xMENSAGEM    :=" "           // Mensagem da Nota
      xPESO_LIQUID :=" "


      Imprime()

      //+--------------------------------------------------------------+
      //¦ Termino da Impressao da Nota Fiscal                          ¦
      //+--------------------------------------------------------------+

      IncRegua()                    // Termometro de Impressao

      nLin:=0
      dbSelectArea("SF1")           
      dbSkip()                     // e passa para a proxima Nota Fiscal

   EndDo
Endif
//+--------------------------------------------------------------+
//¦                                                              ¦
//¦                      FIM DA IMPRESSAO                        ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Fechamento do Programa da Nota Fiscal                        ¦
//+--------------------------------------------------------------+

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()
//+--------------------------------------------------------------+
//¦ Fim do Programa                                              ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦                   FUNCOES ESPECIFICAS                        ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ VERIMP   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Verifica posicionamento de papel na Impressora             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function VerImp
Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2

   nOpc       := 1
	#IFNDEF WINDOWS
	   cCor       := "B/BG"
	#ENDIF

   While .T.

      SetPrc(0,0)
      dbCommitAll()
      @ nLin ,000 PSAY " "
      @ nLin ,004 PSAY "*"
      @ nLin ,022 PSAY "."
		#IFNDEF WINDOWS
	      Set Device to Screen
	      DrawAdvWindow(" Formulario ",10,25,14,56)
	      SetColor(cCor)
	      @ 12,27 Say "Formulario esta posicionado?"
	      nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC"," ",1)
			Set Device to Print
		#ELSE
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF

      Do Case
         Case nOpc==1
            lContinua:=.T.
            Exit
         Case nOpc==2
            Loop
         Case nOpc==3
            lContinua:=.F.
            Return
      EndCase
   End
Endif

Return

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPDET   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao de Linhas de Detalhe da Nota Fiscal              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function IMPDET
Static Function IMPDET()
I:=1
j:=1

//xdescsort:=asort(xdescricao,,,{|x,y| x[1]<y[1]})
xdescsort:=asort(xDESC_PRO,,,{|x,y| x[1]<y[1]})

For I:=1 to len(xdescsort)
	_npos:=xdescsort[i,2]
	@ nLin, 025  PSAY SUBSTR(xCOD_PRO[_npos],1,6)
	@ nLin, 034  PSAY xDESCSORT[I,1]
	@ nLin, 090  PSAY left(xLOTE[_npos],8)
	@ nLin, 098  PSAY xCOD_FIS[_npos]                             
	
	@ nLin, 108  PSAY xCOD_TRIB[_npos]
	@ nLin, 113  PSAY xUNID_PRO[_npos]
	if xtipoped <> "B" .and. xtipoped <> "D"
		@ nLin, 119  PSAY xQTD_PRO[_npos]               Picture"@E 99,999,999"
	else
		@ nLin, 116  PSAY xQTD_PRO[_npos]               Picture"@E 99,999,999.99"
	endif	
/*	if xEST_CLI == "CE" .and. xTPCLIEN <>"S"
	  _NTOT := 0
	  _NTOT := xPRE_TAB[_npos] * xQTD_PRO[_npos]
		@ nLin, 131  PSAY xPRE_TAB[_npos]               Picture"@E 999,999.999999"	
		@ nLin, 158  PSAY _NTOT                 Picture"@E 999,999.999999"	
   else*/
		@ nLin, 131  PSAY xPRE_UNI[_npos]               Picture"@E 999,999.999999"
		@ nLin, 158  PSAY xVAL_MERC[_npos]              Picture"@E 99,999,999.99"	
//	endif	
	@ nLin, 175  PSAY xICM_PROD[_npos]              Picture"99"
	nlin++
	j++
	if j==28
		@ 47, 025  PSAY "**************"  // Base do ICMS
		@ 47, 061  PSAY "**************"  // Valor do ICMS
		@ 47, 085  PSAY "**************"  // Base ICMS Ret.
		@ 47, 120  PSAY "**************"  // Valor  ICMS Ret.
		@ 47, 150  PSAY "**************"  // Valor Tot. Prod.
		
		@ 49, 025  PSAY "**************"  // Valor do Frete
		@ 49, 061  PSAY "**************"  // Valor Seguro
		@ 49, 120  PSAY "**************"  // Valor do IPI
		@ 49, 150  PSAY "CONTINUA"  // Valor Total NF

		@ 67, 155 PSAY chr(14)+xNUM_NF+chr(20)                   // Numero da Nota Fiscal

		@ 068, 000 PSAY chr(18)                   // Descompressao de Impressao
		@ 072,000  PSAY " "
		SetPrc(0,0)                              // (Zera o Formulario)
		cabnota()
		nLin := 17
		j:=1
	endif
Next
Return

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ DUPLIC   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao do Parcelamento das Duplicacatas                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Nfiscal                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+---------------------+
//¦ Inicio da Funcao    ¦
//+---------------------+

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function DUPLIC
Static Function DUPLIC()
@ nlin,25 PSAY "Vencimentos ("+xcond_pag+")"
nCol := 27
nAjuste := 0
For BB:= 1 to Len(xVALOR_DUP)
   If xDUPLICATAS==.T. .and. BB<=Len(xVALOR_DUP)
//      @ nLin, nCol + nAjuste      PSAY xNUM_DUPLIC + " " + xPARC_DUP[BB]
      @ nLin, nCol + 16 + nAjuste      PSAY xVENC_DUP[BB]
//      @ nLin, nCol + 31 + nAjuste PSAY xVALOR_DUP[BB] Picture("@E 9,999,999.99")
      nAjuste := nAjuste + 9
   Endif
Next
nlin++
@ nlin,025 PSAY "FAVOR CONFERIR A MERCADORIA, NAO ACEITAMOS RECLAMACOES POSTERIORES."
Return

//+---------------------+
//¦ Fim da Funcao       ¦
//+---------------------+

//+-------------------------------------+
//¦ Impressao do Cabecalho da N.F.      ¦
//+-------------------------------------+

Static Function cabnota()

@ 00, 000 PSAY Chr(15)                // Compressao de Impressao

If mv_par04 == 1
   @ 02, 139 PSAY "X"
Else
   @ 02, 122 PSAY "X"
Endif

@ 02, 162 PSAY chr(14)+xNUM_NF+chr(20)                   // Numero da Nota Fiscal
               // Numero da Nota Fiscal

@ 007, 025 PSAY xNATUREZA               // Texto da Natureza de Operacao
If mv_par04 == 1
    @ 007, 077 PSAY xCF[1] Picture PESQPICT("SD1","D1_CF") // Codigo da Natureza de Operacao
Else
    @ 007, 077 PSAY xCF[1] Picture PESQPICT("SD2","D2_CF") // Codigo da Natureza de Operacao
EndIf

@ 10, 025 PSAY xNOME_CLI              //Nome do Cliente

If !EMPTY(xCGC_CLI)                   // Se o C.G.C. do Cli/Forn nao for Vazio
   @ 10, 122 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
Else
   @ 10, 122 PSAY " "                // Caso seja vazio
Endif
@ 10, 162 PSAY xEMISSAO              // Data da Emissao do Documento

@ 12, 025 PSAY xEND_CLI                                 // Endereco
@ 12, 104 PSAY xBAIRRO                                  // Bairro
@ 12, 136 PSAY xCEP_CLI Picture"@R 99999-999"           // CEP
@ 12, 143 PSAY " "                                      // Reservado  p/Data Saida/Entrada

@ 14, 025 PSAY xMUN_CLI                               // Municipio
@ 14, 090 PSAY xTEL_CLI                               // Telefone/FAX
@ 14, 117 PSAY xEST_CLI                               // U.F.
@ 14, 122 PSAY xINSC_CLI                              // Insc. Estadual
@ 14, 160 PSAY " "                                    // Reservado p/Hora da Saida
return

//_____________________________________________________________________________
//¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
//¦¦+-----------------------------------------------------------------------+¦¦
//¦¦¦Funçào    ¦ IMPRIME  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
//¦¦+----------+------------------------------------------------------------¦¦¦
//¦¦¦Descriçào ¦ Imprime a Nota Fiscal de Entrada e de Saida                ¦¦¦
//¦¦+----------+------------------------------------------------------------¦¦¦
//¦¦¦Uso       ¦ Generico RDMAKE                                            ¦¦¦
//¦¦+-----------------------------------------------------------------------+¦¦
//¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> Function Imprime
Static Function Imprime()
//+--------------------------------------------------------------+
//¦                                                              ¦
//¦              IMPRESSAO DA N.F. DA Nfiscal                    ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

cabnota()

//+-------------------------------------+
//¦ Dados dos Produtos Vendidos         ¦
//+-------------------------------------+

nLin := 17

ImpDet()                 // Detalhe da NF
/*
if xEST_CLI == "CE" .and. (xTPCLIEN <>"S" .OR. xTPCLIEN <>"F")
	nlin++
  	@ nlin,131 PSAY "Desconto..................:"+;
  						 transform(xVALOR_DESC,"@E 99,999,999.99")
endif*/
if _nrepasse>0
	nlin++
  	@ nlin,131 PSAY "Desc. ref. repasse "+transform(_nprep,"@E 99.99")+"%: "+;
  						 transform(_nrepasse,"@E 99,999,999.99")						 
//	@ nlin,131 PSAY "Desc. ref. convenio 87/02 "+transform(_nprep,"@E 99.99")+"%: "+;
//					 transform(_nrepasse,"@E 99,999,999.99")

endif



if _ndesczfr>0
	nlin++
	@ nlin,131 PSAY "Desc. ref. SUFRAMA 12%:    "+transform(_ndesczfr,"@E 99,999,999.99")
	nlin++
	@ nlin,25  PSAY "DESC.SUFRAMA ART.VI INC.XVIII ANEXO IX DO RCTE DEC.4852/97 - COD.AGENFA ORIGEM 91200121."
endif
nlin++
If mv_par04==2
	if ! empty(xmensagem)
		@ nlin,25 PSAY substr(xmensagem,1,100)
		if !empty(substr(xmensagem,101,99))
   		 nlin++
  			@ nlin,25 PSAY substr(xmensagem,101,99)
  		endif	
	 nlin++
	endif

	If !Empty(xCOD_MENS)
		@ nLin,25 PSAY FORMULA(xCOD_MENS)
		nlin++
	Endif
Endif

if ! empty(xformula)
	@ nlin,25 PSAY FORMULA(xFORMULA)
	nlin++
endif
If !Empty(xLIMINAR)
	@ nLin,25 PSAY xLIMINAR
	nlin++
Endif
If !Empty(MV_PAR05)
	@ nLin,25 PSAY MV_PAR05
	nlin++
Endif
If !Empty(MV_PAR06)
	@ nLin,25 PSAY MV_PAR06
	nlin++
Endif
if sc5->c5_licitac =="S" .AND.  mv_par04 == 2
   if !empty(szl->zl_numedi)
  		nlin++
		@ nlin,025 PSAY "EDITAL: "+szl->zl_numedi
	endif	
	nlin++
	@ nlin,025 PSAY substr(szl->zl_obsnf,1,65)
	if !empty(substr(szl->zl_obsnf,66,65))
   	nlin++
		@ nlin,025 PSAY substr(szl->zl_obsnf,66,65)
	endif	
	if !empty(substr(szl->zl_obsnf,131,70))
   	nlin++
		@ nlin,025 PSAY substr(szl->zl_obsnf,131,70)
	endif	
	nlin++          
	@ nlin,025 PSAY "DADOS BANCARIOS: BANCO DO BRASIL - AGENCIA: 3388-X C/C: 6040-2"
endif                   


if Len(xNUM_NFDV) > 0  .and. !Empty(xNUM_NFDV[1])
   @ nlin,025 PSAY "Nota Fiscal Original No." + "  " + xNUM_NFDV[1] + "  " + xPREF_DV[1]
Endif


@ 47, 025  PSAY xBASE_ICMS  Picture "@E@Z 999,999,999.99"  // Base do ICMS
@ 47, 061  PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS
@ 47, 085  PSAY xBSICMRET   Picture "@E@Z 999,999,999.99"  // Base ICMS Ret.
@ 47, 120  PSAY xICMS_RET   Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.
@ 47, 150  PSAY xVALOR_MERC Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.

@ 49, 025  PSAY xFRETE      Picture "@E@Z 999,999,999.99"  // Valor do Frete
@ 49, 061  PSAY xDESPESA    Picture "@E@Z 999,999,999.99"  // Valor Despesa
@ 49, 085  PSAY xSEGURO     Picture "@E@Z 999,999,999.99"  // Valor Seguro
@ 49, 120  PSAY xVALOR_IPI  Picture "@E@Z 999,999,999.99"  // Valor do IPI
@ 49, 150  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Total NF


   //+------------------------------------+
   //¦ Impressao Dados da Transportadora  ¦
   //+------------------------------------+

@ 52, 025  PSAY xNOME_TRANSP                       // Nome da Transport.

If xTPFRETE=='F'                                   // Frete por conta do
   @ 52, 122 PSAY "2"                              // Emitente (1)
Else                                               //     ou
   @ 52, 122 PSAY "1"                              // Destinatario (2)
Endif

@ 52, 130 PSAY " "                                  // Res. p/Placa do Veiculo
@ 52, 131 PSAY " "                                  // Res. p/xEST_TRANSP                          // U.F.

If !EMPTY(xCGC_TRANSP)                              // Se C.G.C. Transportador nao for Vazio
   @ 52, 151 PSAY xCGC_TRANSP Picture"@R 99.999.999/9999-99"
Else
   @ 52, 151 PSAY " "                               // Caso seja vazio
Endif

@ 54, 025 PSAY xEND_TRANSP                          // Endereco Transp.
@ 54, 104 PSAY xMUN_TRANSP                          // Municipio
@ 54, 143 PSAY xEST_TRANSP                          // U.F.
@ 54, 151 PSAY " "                                  // Reservado p/Insc. Estad.


@ 56, 025 PSAY xVOLUME  Picture"@E@Z 999,999.99"             // Quant. Volumes
@ 56, 053 PSAY "CAIXAS/VOLUMES" Picture"@!"                          // Especie
@ 56, 052 PSAY " "                                           // Res para Marca
@ 56, 075 PSAY " "                                           // Res para Numero
@ 56, 131 PSAY xPBRUTO     Picture"@E@Z 999,999.99"      // Res para Peso Bruto
@ 56, 155 PSAY xPLIQUI    Picture"@E@Z 999,999.99"      // Res para Peso Liquido

If mv_par04 == 2
	@ 59,025 PSAY sa1->a1_cod+"/"+sa1->a1_loja
	@ 59,053 PSAY xped_vend[1]
	@ 59,090 PSAY xcod_vend[1]
	If _ndesczfr>0
	   @ 61,25 PSAY _ndesczfr picture "@E 999,999,999.99"
		@ 61,40 PSAY "Codigo SUFRAMA: "+xsuframa
	EndIf

   //+-------------------------------------+
   //¦ Impressao da Fatura/Duplicata       ¦
   //+-------------------------------------+

   nLin:=63
   BB:=1
   nCol := 25             //  duplicatas     IMPRIMIR NO CAMPO DE OBSERVACOES
   DUPLIC()

Endif

@ 67, 155 PSAY chr(14)+xNUM_NF+chr(20)                   // Numero da Nota Fiscal

@ 068, 000 PSAY chr(18)                   // Descompressao de Impressao
@ 072,000  PSAY " "
SetPrc(0,0)                              // (Zera o Formulario)
Return .t.

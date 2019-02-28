/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT100AGR ³ AUTOR ³ Heraildo C. de Freitas³ Data ³ 06/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada apos a gravacao da nota fiscal de entrada ³±±
±±³          ³ para solicitar a data de recebimento da nota fiscal        ³±±
±±³          ³ e preencher tabela CD7 para emissao NFe para Devolução     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
#INCLUDE "topconn.ch"

user function mt100agr() 

	Private wDocImp			:= SPACE(10)        // Doc. imp  -> CD5_CODIMP (CARACTER) 
	Private wDtRgDi			:= ctod("  /  /  ") //
	Private wDNunDi			:= SPACE(15)		// 
	Private wDtDi			:= ctod("  /  /  ") 
	Private wExp            := SPACE(8)
	Private wFab 			:= SPACE(8)
	Private wVBcImp         := 0 //SPACE(14)
	Private wDespAd			:= 0 //SPACE(14)
	Private wImpImp         := 0 //SPACE(14)                  
	Private wDescLoc		:= SPACE(40)
	Private wUfDesemb   	:= SPACE(02)  		
	Private wDtDesemb   	:= ctod("  /  /  ") 
	Private wVlrSisc        := 0 //SPACE(14) 
	Private wVia		   	:= SPACE(01)
	Private wVlrSeg         := 0 //SPACE(14) 
	Private wVlrARFM        := 0 //SPACE(14) 
	Private wVlrCapa        := 0 //SPACE(14) 
	Private wVlrTxCe        := 0 //SPACE(14) 
	Private wVlrHono        := 0 //SPACE(14) 
	Private wVlrArma        := 0 //SPACE(14) 
	Private wVlrLib	        := 0 //SPACE(14) 
	Private _lcontinua
	Private _cSerie         := SF1->F1_SERIE
	Private _cNota          := SF1->F1_DOC  
	Private _cFilial        := xFilial("SF1") 
	Private _item           := " "

	_cfilsf4:=xfilial("SF4")

	if inclui
		_drecbmto:=ctod("  /  /  ")
		_hrecbmto:=SPACE(6)  // Ricardo Fiuza's 10/03/2015
		_msgnf   :=SPACE(250)
		/* Inclusão de Dados na tabela CD7 - Complemento de Medicamento para NFe Devolução em Formulário Próprio*/

			_nordsb1:=sb1->(indexord())
			_nordsc5:=sc5->(indexord())
			_nordsd2:=sd2->(indexord())
			_nordda0:=da0->(indexord())
			_nordcd7:=cd7->(indexord())
			_nordF0A:=F0A->(indexord())
			_nordsc2:=sc2->(indexord())
			_nordcd5:=cd5->(indexord())

			_nregsb1:=sb1->(recno())
			_nregsc5:=sc5->(recno())
			_nregsd2:=sd2->(recno())
			_nregda0:=da0->(recno())
			_nregcd7:=cd7->(recno())
			_nregF0A:=F0A->(recno())
			_nregsc2:=sc2->(recno())
			_nregcd5:=cd5->(recno())

			_cfilsb1:=xfilial("SB1")
			_cfilsc5:=xfilial("SC5")
			_cfilsd2:=xfilial("SD2")
			_cfilcd7:=xfilial("CD7")
			_cfilF0A:=xfilial("F0A")
			_cfilda0:=xfilial("DA0")
			_cfilsc2:=xfilial("SC2")
			_cfilcd5:=xfilial("CD5")
			sb1->(dbsetorder(1))
			sc5->(dbsetorder(1))
			sd2->(dbsetorder(3))
			F0A->(dbsetorder(1))
			cd7->(dbsetorder(1)) //Filial + Tip.Movimento + Serie + Documento + Cliente + Loja + Item + Código
			sd2->(dbsetorder(3)) //Filial + Documento + Série + Cliente + Loja + Código + Item
			sb1->(dbsetorder(1)) //Filial + Codigo
			sc5->(dbsetorder(1)) //Filial + Num.Pedido
			da0->(dbsetorder(1)) //Filial + Código Tabela
			sc2->(dbsetorder(1)) //Filial + Num.OP + Item + Sequencia + Item Grade
			cd5->(dbsetorder(4)) //Filial + Numero NF + Serie NF + Fornecedor + Codigo loja

			_nota:=sf1->f1_doc
			_serie:=sf1->f1_serie
			
			Alert(sf1->f1_tipo+'-'+sf1->f1_formul)

			if sf1->f1_tipo=='D' .and. sf1->f1_formul=='S' // Notas de Devolução com faturamento próprio
			Alert("Esta é uma nota de devoução com formulario Proprio")
			processa({|| _cquery(_nota,_serie)})
			tmp1->(dbgotop())

			while ! tmp1->(eof())

				If tmp1->TIPO $ ("PA,PL") .AND. TMP1->TPPROD <> "6"

					cd7->(dbgobottom())
					dbselectarea("CD7")

					// Cria Array com todos os campos do CD7
					aCD7 := array(fCount())
					for i:=1 to FCount()
						aCD7[i] := fieldget(i)
					next

					RecLock("CD7",.t.)

					for i:=1 to FCount()
						fieldput(i,aCD7[i])
					next

					replace cd7_filial  with "01"
					replace cd7_tpmov   with "E"
					replace cd7_doc     with _nota
					replace cd7_serie   with _serie
					replace cd7_espec   with "SPED"
					replace cd7_clifor  with tmp1->fornece
					replace cd7_loja    with tmp1->loja
					replace cd7_item    with tmp1->item
					replace cd7_cod     with tmp1->cod
					replace cd7_lote    with tmp1->lotectl
					replace cd7_qtdlot  with tmp1->quant
					replace cd7_fabric  with tmp1->emissao
					replace cd7_valid   with tmp1->dtvalid
					replace cd7_codanv  with tmp1->anvisa

					if tmp1->grtrib=='001'
						replace cd7_refbas  with "3"
					else
						replace cd7_refbas  with "2"
					endif
					replace cd7_tpprod  with tmp1->tpprod
					replace cd7_preco   with tmp1->pmc

					MSUnlock()

					CD7->(dbclosearea())

					F0A->(dbgobottom())
					dbselectarea("F0A")

					// Cria Array com todos os campos do F0A
					aF0A := array(fCount())
					for i:=1 to FCount()
						aF0A[i] := fieldget(i)
					next

					RecLock("F0A",.t.)

					for i:=1 to FCount()
						fieldput(i,aF0A[i])
					next

					replace F0A_filial  with "01"
					replace F0A_tpmov   with "E"
					replace F0A_doc     with _nota
					replace F0A_serie   with _serie
					//					replace F0A_espec   with "SPED"
					replace F0A_clifor  with tmp1->fornece
					replace F0A_loja    with tmp1->loja
					replace F0A_item    with tmp1->item
					replace F0A_cod     with tmp1->cod
					replace F0A_lote    with tmp1->lotectl
					replace F0A_qtdlot  with tmp1->quant
					replace F0A_fabric  with tmp1->emissao
					replace F0A_valid   with tmp1->dtvalid
					//					replace F0A_preco   with tmp1->pmc

					MSUnlock()

					F0A->(dbclosearea())
				ElseIf TMP1->RASTRO = "L"
					F0A->(dbgobottom())
					dbselectarea("F0A")
					// Cria Array com todos os campos do F0A
					aF0A := array(fCount())
					for i:=1 to FCount()
						aF0A[i] := fieldget(i)
					next

					RecLock("F0A",.t.)

					for i:=1 to FCount()
						fieldput(i,aF0A[i])
					next

					replace F0A_filial  with "01"
					replace F0A_tpmov   with "E"
					replace F0A_doc     with _nota
					replace F0A_serie   with _serie
					//					replace F0A_espec   with "SPED"
					replace F0A_clifor  with tmp1->fornece
					replace F0A_loja    with tmp1->loja
					replace F0A_item    with tmp1->item
					replace F0A_cod     with tmp1->cod
					replace F0A_lote    with tmp1->lotectl
					replace F0A_qtdlot  with tmp1->quant
					replace F0A_fabric  with tmp1->emissao
					replace F0A_valid   with tmp1->dtvalid
					//					replace F0A_preco   with tmp1->pmc

					MSUnlock()

					F0A->(dbclosearea())
				EndIf
				tmp1->(dbskip())

			end
			tmp1->(dbclosearea())
		endif
		sb1->(dbsetorder(_nordsb1))
		sc5->(dbsetorder(_nordsc5))
		sd2->(dbsetorder(_nordsd2))
		da0->(dbsetorder(_nordda0))
		cd7->(dbsetorder(_nordcd7))
		f0A->(dbsetorder(_nordF0A))
		sc2->(dbsetorder(_nordsc2))

		sb1->(dbgoto(_nregsb1))
		sc5->(dbgoto(_nregsc5))
		sd2->(dbgoto(_nregsd2))
		da0->(dbgoto(_nregda0))
		cd7->(dbgoto(_nregcd7))
		F0A->(dbgoto(_nregF0A))
		sc2->(dbgoto(_nregsc2))


		if sf1->f1_tipo=='N' .and. sf1->f1_formul=='S' .and. sf1->f1_est='EX' // Notas de Importação com faturamento próprio

			_nordsd1:=sd1->(indexord())
			_nordcd7:=cd7->(indexord())
			_nordF0A:=F0A->(indexord())
			_nordcd5:=cd5->(indexord())

			_nregcd5:=cd5->(recno())
			_nregsd1:=sd1->(recno())
			_nregcd7:=cd7->(recno())
			_nregF0A:=F0A->(recno())

			_cfilsd1:=xfilial("SD1")
			_cfilcd7:=xfilial("CD7")
			_cfilcd5:=xfilial("CD5")

			cd5->(dbsetorder(4)) //Filial + Numero NF + Serie NF + Fornecedor + Codigo loja
			sd1->(dbsetorder(1)) //Filial + Documento + Serie + Forn/Cliente + Loja + Produto + Item NF           
			cd7->(dbsetorder(1)) //Filial + Tip.Movimento + Serie + Documento + Cliente + Loja + Item + Código
			F0A->(dbsetorder(1))

			_nota:=sf1->f1_doc
			_serie:=sf1->f1_serie

			processa({|| _cquer2(_nota,_serie)})
			tmp2->(dbgotop())

			// Tabela Complemento de Medicamentos - CD7
			_fornece:= tmp2->fornece
			_loja:= tmp2->loja

			while ! tmp2->(eof()) 

				msginfo("Por favor digite os dados do Produto: "+ TMP2->COD+"/"+TMP2->DESCPRO)

				//_item := tmp2->item  
				//_vII  :=tmp2->VlrII

				fTelCadDI()    //Mostra a Tela

				/////########################################Inicio 
				tmp2->(dbskip())

				//FIM ####################################### ATE AKI        
			end

			sd1->(dbsetorder(_nordsd1))
			cd7->(dbsetorder(_nordcd7))
			F0A->(dbsetorder(_nordF0A))
			cd5->(dbsetorder(_nordcd5))

			sd1->(dbgoto(_nregsd1))
			cd7->(dbgoto(_nregcd7))
			F0A->(dbgoto(_nregF0A))
			cd5->(dbgoto(_nregcd5))

			tmp2->(dbclosearea())

		elseif sf1->f1_tipo=='C' .and. sf1->f1_formul=='S' .and. sf1->f1_est='EX' // Notas Complementares de Importação com faturamento próprio

			_nordsd1:=sd1->(indexord())
			_nordcd5:=cd5->(indexord())

			_nregsd1:=sd1->(recno())
			_nregcd5:=cd5->(recno())

			_cfilsd1:=xfilial("SD1")
			_cfilcd5:=xfilial("CD5")

			sd1->(dbsetorder(1)) //Filial + Documento + Serie + Forn/Cliente + Loja + Produto + Item NF           
			cd5->(dbsetorder(1)) //Filial + Documento + Serie + Fornecedor + Doc_Importacao

			_nota:=sf1->f1_doc
			_serie:=sf1->f1_serie

			processa({|| _cquer3(_nota,_serie)})
			tmp3->(dbgotop()) 

			_fornece:= tmp3->fornece
			_loja:= tmp3->loja

			while ! tmp3->(eof())

				msginfo("Por favor digite os dados do Produto: "+ TMP3->COD+"/"+TMP3->DESCPRO)

				fTelCadCom() 

				MSUnlock()
				cd5->(dbclosearea())
				tmp3->(dbskip())
			end    

			cd5->(dbsetorder(_nordcd5))
			sd1->(dbsetorder(_nordsd1))

			sd1->(dbgoto(_nregsd1))
			cd5->(dbgoto(_nregcd5))

			tmp3->(dbclosearea())    
		endif

		//-- Não haverá mais endereçamento automático (Natã Santos - 20180201)
		//    putmv("MV_DISTAUT","98QUARENTENA") // Grava parâmetro para Endereçamento Automático
		//    putmv("MV_DISTAUT","") // Limpa parâmetro para Endereçamento Automático
		//FIM ####################################### ATE AKI
		_lcontinua:=.t.
		while _lcontinua
			@ 000,000 to 200,750 dialog odlg title "Data e hora de recebimento da nota fiscal Nº  "+sf1->f1_doc+"Série: "+sf1->f1_serie

			@ 010,020 say "Data de recebimento da nota fiscal"
			@ 010,110 get _drecbmto size 40,8 valid naovazio() .and. _drecbmto>=sf1->f1_emissao .and. _drecbmto<=sf1->f1_dtdigit

			@ 030,020 say "Hora de recebimento da nota fiscal"          //  Ricardo Fiuza's 10/03/2015
			@ 030,110 get _hrecbmto Picture "99:99" size 10,06 //valid naovazio()          //  Ricardo Fiuza's 10/03/2015 

			@ 050,020 say "Mensagem NF Emissao Propria"          //  Ricardo Fiuza's 10/03/2015
			@ 050,110 get _msgnf Picture "@!" size 260,250 //valid naovazio()          //  Ricardo Fiuza's 10/03/2015


			//@ 010,100 bmpbutton type 1 action _grava()
			@ 070,300 bmpbutton type 1 action _grava() 				//	Ricardo Fiuza's 10/03/2015

			activate dialog odlg centered
		end

	endif

	if sf1->f1_tipo=="N"

		_lcontinua:=.t.

		sd1->(dbsetorder(1))
		sd1->(dbseek(sf1->f1_filial+sf1->f1_doc+sf1->f1_serie+sf1->f1_fornece+sf1->f1_loja))
		while ! sd1->(eof()) .and.;
		sd1->d1_filial==sf1->f1_filial .and.;
		sd1->d1_doc==sf1->f1_doc .and.;
		sd1->d1_serie==sf1->f1_serie .and.;
		sd1->d1_fornece==sf1->f1_fornece .and.;
		sd1->d1_loja==sf1->f1_loja .and.;
		_lcontinua

			if ! empty(sd1->d1_lotectl) .and.;
			sd1->d1_tp$"MP/EE/EN"

				sf4->(dbsetorder(1))
				sf4->(dbseek(_cfilsf4+sd1->d1_tes))
				if sf4->f4_estoque=="S"

					// GRAVA CONTEUDO DAS VARIAVEIS MV_PAR
					_apar:={}
					for _ni:=1 to 40
						_cvar:="mv_par"+strzero(_ni,2)
						aadd(_apar,&_cvar)
					next                
					_aareasd1:=sd1->(getarea())
					if sd1->d1_tp=="MP" .and. sb1->b1_tipocq ="M"
						u_vit067(.t.)
						_lcontinua:=.f.
					else
						u_vit273(.t.)
					endif
					sd1->(restarea(_aareasd1))

					// RESTAURA CONTEUDO DAS VARIAVEIS MV_PAR
					for _ni:=1 to len(_apar)
						_cvar :="mv_par"+strzero(_ni,2)
						&_cvar:=_apar[_ni]
					next

				endif
			endif

			sd1->(dbskip())
		end
	endif

return()

static function _grava()

	cTime := TIME()

	sf1->(reclock("SF1",.f.))
	sf1->f1_recbmto:=_drecbmto                                

	If !empty(_msgnf) 		//    Ricardo Fiuza's 28/04/2015
		sf1->f1_mennf2 := _msgnf
	EndIf	  

	If !empty(_hrecbmto) 		//    Ricardo Fiuza's 10/03/2015
		sf1->f1_hora := _hrecbmto
	else
		sf1->f1_HORA := SUBSTR(cTime,1,5)
	EndIf	                        

	sf1->(msunlock())

	_lcontinua:=.f.
	close(odlg)
return()



/*BUSCA ITENS GRAVADOS NO SD2*/
static function _cquery(_nota,_serie)
	procregua(1)

	incproc("Selecionando Itens no SD2...")

	_cquery:=" SELECT "
	_cquery+=" D1_COD COD,"
	_cquery+=" B1_TIPO TIPO,"
	_cquery+=" D1_ITEM ITEM,"
	_cquery+=" B1_ANVISA ANVISA,"
	_cquery+=" B1_DESC DESCRI,"
	_cquery+=" B1_RASTRO RASTRO, "	
	_cquery+=" B1_TPPROD TPPROD,"
	_cquery+=" CAST((D2_PRUNIT/FATOR) AS NUMERIC(18,5)) PMC,"
	_cquery+=" B1_GRTRIB GRTRIB,"
	_cquery+=" D1_LOTECTL LOTECTL,"
	_cquery+=" EMISSAO,"
	_cquery+=" DTVALID,"
	_cquery+=" D2_EST EST,"
	_cquery+=" D2_PEDIDO PEDIDO,"
	_cquery+=" D2_PRUNIT PRUNIT,"
	_cquery+=" C5_TABELA TABELA,"
	_cquery+=" DA0_STATUS STATUS,"
	_cquery+=" D1_FORNECE FORNECE,"
	_cquery+=" D1_LOJA LOJA,"
	_cquery+=" D1_QUANT QUANT"
	_cquery+=" FROM ("
	_cquery+=" SELECT"
	_cquery+=" D1_COD,"
	_cquery+=" B1_TIPO,"
	_cquery+=" B1_RASTRO,"
	_cquery+=" B1_ANVISA, "
	_cquery+=" D1_ITEM,"
	_cquery+=" B1_DESC,"
	_cquery+=" B1_GRTRIB,"       
	_cquery+=" B1_TPPROD,"       
	_cquery+=" D1_LOTECTL,"
	_cquery+=" (SELECT DISTINCT(B8_DFABRIC) FROM SB8010 SB8 WHERE SB8.D_E_L_E_T_ = ' ' AND B8_PRODUTO = D1_COD AND SD1.D1_LOTECTL = SB8.B8_LOTECTL AND SD1.D1_LOCAL = SB8.B8_LOCAL) EMISSAO,"
	_cquery+=" SD2.D2_DTVALID DTVALID,"
	_cquery+=" D2_EST,"
	_cquery+=" D2_PEDIDO,"
	_cquery+=" D2_PRUNIT,"
	_cquery+=" C5_TABELA,"
	_cquery+=" DA0_STATUS,"
	_cquery+=" CASE "
	_cquery+=" WHEN B1_GRTRIB='001' THEN 0.7234"
	_cquery+=" WHEN (B1_GRTRIB='002' AND D2_EST='RJ') THEN 0.7523"
	_cquery+=" WHEN (B1_GRTRIB='002' AND (D2_EST='PR' OR (D2_EST='MG' AND B1_TPPROD='1'))) THEN 0.7499"
	_cquery+=" WHEN (B1_GRTRIB='002' AND D2_EST IN ('SP','MG')) THEN 0.7519"
	_cquery+=" WHEN (B1_GRTRIB='002' AND DA0_STATUS='Z') THEN 0.7234"
	_cquery+=" ELSE 0.7515"
	_cquery+=" END FATOR,"
	_cquery+=" D1_FORNECE,"
	_cquery+=" D1_LOJA,"
	_cquery+=" D1_QUANT"
	_cquery+=" FROM "
	_cquery+= retsqlname("SB1")+" SB1,"
	_cquery+= retsqlname("SD1")+" SD1,"
	_cquery+= retsqlname("SD2")+" SD2,"
	_cquery+= retsqlname("SC5")+" SC5,"
	_cquery+= retsqlname("DA0")+" DA0"
	_cquery+=" WHERE SB1.D_E_L_E_T_=' ' AND SD2.D_E_L_E_T_=' ' AND SC5.D_E_L_E_T_=' ' AND DA0.D_E_L_E_T_=' ' AND SD1.D_E_L_E_T_=' '"
	_cquery+=" AND D1_DOC='"+_nota+"'"
	_cquery+=" AND D1_SERIE='"+_serie+"'"
	_cquery+=" AND D1_COD=B1_COD"
	_cquery+=" AND D1_NFORI=D2_DOC"
	_cquery+=" AND D1_SERIORI=D2_SERIE"
	_cquery+=" AND D1_ITEMORI=D2_ITEM"
	_cquery+=" AND D2_PEDIDO=C5_NUM"
	_cquery+=" AND C5_TABELA=DA0_CODTAB"
	_cquery+=" AND D1_LOTECTL = SD2.D2_LOTECTL"
	_cquery+=" ORDER BY D1_ITEM)"
	_cquery+=" ORDER BY D1_ITEM"

	_cquery:=changequery(_cquery)
	tcquery _cquery new alias "TMP1"
	MEMOWRIT("C:/Stephen/mt100gr1.txt",_cquery)
	tcsetfield("TMP1","PMC","N",16,5)
	tcsetfield("TMP1","PRUNIT","N",16,5)
	tcsetfield("TMP1","QUANT","N",16,5)
	tcsetfield("TMP1","EMISSAO","D")
	tcsetfield("TMP1","DTVALID","D")

return()


/* NOTA FISCAL DE IMPORTAÇÃO - ITENS */

static function _cquer2(_nota,_serie)
	procregua(1)

	incproc("Selecionando Itens no SD1...")
	_cmed :=getmv("MV_MEDICA")
	_cmed := alltrim(_cmed)
	_cmedaux:="'"

	for _i:=1 to len(_cmed)
		if substr(_cmed,_i,1)="/"
			_cmedaux +=    "','"
		else
			_cmedaux +=    substr(_cmed,_i,1)
		endif
	next                        

	_cmedaux += "'"

	_cquer2:=" SELECT D1_FORNECE FORNECE,"
	_cquer2+=" B1_ANVISA ANVISA,"
	_cquer2+=" B1_RASTRO RASTRO ,"
	_cquer2+=" B1_TPPROD TPPROD ,"
	_cquer2+=" D1_LOJA LOJA,"
	_cquer2+=" D1_TP TIPO,"	
	_cquer2+=" D1_ITEM ITEM,"
	_cquer2+=" D1_COD COD,"
	_cquer2+=" D1_DESCPRO DESCPRO,"
	_cquer2+=" D1_LOTFABR LOTECTL,"
	_cquer2+=" D1_QUANT QUANT,"
	_cquer2+=" D1_VUNIT VALOR,"
	_cquer2+=" D1_II VLRII,"
	_cquer2+=" D1_DTFABR FAB,"
	_cquer2+=" D1_DTVALID DTVALID "
	_cquer2+=" FROM "
	_cquer2+= retsqlname("SD1")+" SD1 "
	_cquer2+=" inner join sb1010 sb1 on b1_cod = d1_cod and sb1.D_E_L_E_T_ = ' '"
	_cquer2+=" WHERE SD1.D_E_L_E_T_=' '"
	_cquer2+=" AND D1_DOC='"+_nota+"'"
	_cquer2+=" AND D1_SERIE='"+_serie+"'"
	_cquer2+=" AND D1_GRUPO IN ("+_cmedaux+")"
	_cquer2+=" ORDER BY D1_ITEM"

	_cquer2:=changequery(_cquer2)
	tcquery _cquer2 new alias "TMP2"
	MEMOWRIT("\sql\mt100gr2.sql",_cquer2)
	tcsetfield("TMP2","QUANT","N",13,2)
	tcsetfield("TMP2","FAB","D")
	tcsetfield("TMP2","DTVALID","D")

return()



/* NOTA FISCAL DE IMPORTAÇÃO - NF COMPLEMENTAR */

static function _cquer3(_nota,_serie)
	procregua(1)

	incproc("Selecionando Itens no SD1...")

	_cquer3:=" SELECT "
	_cquer3+=" D1_FORNECE FORNECE,"
	_cquer3+=" D1_LOJA LOJA,"
	_cquer3+=" D1_ITEM ITEM,"
	_cquer3+=" D1_COD COD,"
	_cquer3+=" D1_DESCPRO DESCPRO,"
	_cquer3+=" D1_LOTFABR LOTECTL," 
	_cquer3+=" D1_II VLRII,"
	_cquer3+=" D1_QUANT QUANT,"
	_cquer3+=" D1_DTFABR FAB,"
	_cquer3+=" D1_DTVALID DTVALID "
	_cquer3+=" FROM "
	_cquer3+= retsqlname("SD1")+" SD1 "
	_cquer3+=" WHERE SD1.D_E_L_E_T_=' '"
	_cquer3+=" AND D1_DOC='"+_nota+"'"
	_cquer3+=" AND D1_SERIE='"+_serie+"'"
	_cquer3+=" ORDER BY D1_ITEM"

	_cquer3:=changequery(_cquer3)
	tcquery _cquer3 new alias "TMP3"
	MEMOWRIT("\sql\mt100gr3.sql",_cquer3)
	tcsetfield("TMP3","QUANT","N",13,2)
	tcsetfield("TMP3","FAB","D")
	tcsetfield("TMP3","DTVALID","D")

return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao   ³ fDadosDI º Autor ³ Ricardo Fiuza    º Data ³  18/12/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dados da DI                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitapan                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
STATIC FUNCTION fTelCadDI()  

	/*
	Doc. imp  -> CD5_CODIMP (CARACTER)
	dt. reg. DI  -> CD5_DTRGDI (DATA) 
	***Tp. Doc. Imp -> CD5_TPIMP (0 OU 1) JOGAR DIRETO
	No. da DI/DA -> CD5_NDI  (CARACTER)
	Registro DI -> CD5_DTDI (DATA)
	Exportador -> CD5_CODEXP (F3)
	Fabricante -> CD5_CODFAB  (F3)

	Vlr BC Impor-> CD5_BCIMP (NUMERICO)
	Clr Desp Adu -> CD5_DSPAD (NUMERICO)
	Vlr Imp. Impo -> CD5_VLRII (NUMERICO)
	CD5_LOCAL ///NA CD5 SEMPRE É 1


	Desc. Local -> CD5_LOCDES    
	UF desembara-> CD5_UFDES
	Dt Desembar -> CD5_DTDES (DATA)
	*****loja exp. -> CD5_LOJEXP
	*****loja fab. -> CD5_LOJFAB
	Vlr. Siscomex.-> CD5_TXSISC (NUMERICO)
	*/

	@ 000,000 to 870,500 dialog odlg3 title "Dados da DI para NFe de Importação"

	@ 012,010 say "No. da DI/DA"
	@ 010,065 get wDNunDi 		Picture "999999999999999" 	   size 070,10  //Valid

	@ 032,010 say "Registro DI"
	@ 030,065 get wDtDi 		Picture "@d" 			       size 070,10

	@ 052,010 say "Exportador"
	@ 050,065 get wExp 	    	Picture "@!" 			       size 070,10  F3 "SA2I"

	@ 072,010 say "Fabricante"
	@ 070,065 get wFab 	     	Picture "@!" 			       size 070,10  F3 "SA2I"  

	@ 092,010 say "Vlr BC Impor"
	@ 090,065 get wVBcImp 		Picture "@E 999,999,999.99"	   size 070,10

	@ 112,010 say "Vlr Desp Adu"
	@ 110,065 get wDespAd 		Picture "@E 999,999,999.99"	   size 070,10   

	@ 132,010 say "Vlr Imp Impo"
	@ 130,065 get wImpImp 	    Picture "@E 999,999,999.99"    size 070,10 

	@ 152,010 say "Cidade Desembaraço"
	@ 150,065 get wDescLoc    	Picture "@!" 			       size 150,10

	@ 172,010 say "UF Desembaraço"
	@ 170,065 get wUfDesemb 	Picture "@!" 			       size 030,10

	@ 192,010 say "Data Desembaraço"                           
	@ 190,065 get wDtDesemb		Picture "@d" 			       size 070,10

	@ 212,010 say "Vlr. Siscomex"
	@ 210,065 get wVlrSisc		Picture "@E 999,999,999.99"    size 070,10

	@ 232,010 say "Vlr. Seguro"
	@ 230,065 get wVlrSeg		Picture "@E 999,999,999.99"    size 070,10

	@ 252,010 say "Vlr. AFRMM"
	@ 250,065 get wVlrARFM		Picture "@E 999,999,999.99"    size 070,10

	@ 272,010 say "Vlr. Capatazia"
	@ 270,065 get wVlrCapa		Picture "@E 999,999,999.99"    size 070,10

	@ 292,010 say "Vlr. TX CE"
	@ 290,065 get wVlrTxCe		Picture "@E 999,999,999.99"    size 070,10

	@ 312,010 say "Vlr. Honorarios"
	@ 310,065 get wVlrHono		Picture "@E 999,999,999.99"    size 070,10

	@ 332,010 say "Vlr. Armazenagem"
	@ 330,065 get wVlrArma		Picture "@E 999,999,999.99"    size 070,10

	@ 352,010 say "Vlr. Liberacao BL"
	@ 350,065 get wVlrLib		Picture "@E 999,999,999.99"    size 070,10

	@ 372,010 say "Via(1-Mar;4-Aereo)"
	@ 370,065 get wVia	  		Picture "@!" 			       size 015,10


	@ 392,200 bmpbutton type 1 action fGraDadosDI()

	Activate Dialog odlg3 Centered

Return  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao   ³fGraDadosDI º Autor ³ Ricardo Fiuza    º Data ³  18/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dados da DI                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bradel                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function fGraDadosDI() 

	If tmp2->TIPO $ ("PA,PL") .AND. TMP2->TPPROD <> "06"

		cd7->(dbgobottom())
		dbselectarea("CD7")

		// Cria Array com todos os campos do CD7
		aCD7 := array(fCount())
		for i:=1 to FCount()
			aCD7[i] := fieldget(i)
		next

		RecLock("CD7",.t.)

		for i:=1 to FCount()
			fieldput(i,aCD7[i])
		next

		replace cd7_filial  with _cfilcd7
		replace cd7_tpmov   with "E"
		replace cd7_doc     with _nota
		replace cd7_serie   with _serie
		replace cd7_espec   with "SPED"
		replace cd7_clifor  with tmp2->fornece
		replace cd7_loja    with tmp2->loja
		replace cd7_item    with tmp2->item
		replace cd7_cod     with tmp2->cod
		replace cd7_lote    with tmp2->lotectl
		replace cd7_qtdlot  with tmp2->quant
		replace cd7_fabric  with tmp2->fab
		replace cd7_valid   with tmp2->dtvalid
		replace cd7_codanv  with tmp2->anvisa


		replace cd7_refbas  with "2"
		replace cd7_tpprod  with "0"
		replace cd7_preco   with tmp2->valor

		MSUnlock()

		cd7->(dbclosearea())
	EndIf
	IF TMP2->RASTRO = "L"
		F0A->(dbgobottom())
		dbselectarea("F0A")
		// Cria Array com todos os campos do F0A
		aF0A := array(fCount())
		for i:=1 to FCount()
			aF0A[i] := fieldget(i)
		next
		RecLock("F0A",.t.)
		for i:=1 to FCount()
			fieldput(i,aF0A[i])
		next
		replace F0A_filial  with "01"
		replace F0A_tpmov   with "E"
		replace F0A_doc     with _nota
		replace F0A_serie   with _serie
		//	replace F0A_espec   with "SPED"
		replace F0A_clifor  with tmp2->fornece
		replace F0A_loja    with tmp2->loja
		replace F0A_item    with tmp2->item
		replace F0A_cod     with tmp2->cod
		replace F0A_lote    with tmp2->lotectl
		replace F0A_qtdlot  with tmp2->quant
		replace F0A_fabric  with tmp2->fab
		replace F0A_valid   with tmp2->dtvalid

		MSUnlock()

		F0A->(dbclosearea())	

		// Tabela de Complementos de Importação
		cd5->(dbgobottom())
		dbselectarea("CD5")

		// Cria Array com todos os campos do CD5
		aCD5 := array(fCount())
		for i:=1 to FCount()
			aCD5[i] := fieldget(i)
		next

		RecLock("CD5",.t.)

		for i:=1 to FCount()
			fieldput(i,aCD5[i])
		next               

		replace cd5_filial  with _cfilcd5
		replace cd5_doc     with _nota
		replace cd5_serie   with _serie
		replace cd5_espec   with "SPED"
		replace cd5_fornec  with _fornece
		replace cd5_loja    with _loja                 
		replace cd5_tpimp   with '0'                 
		replace cd5_docimp  with wDNunDi
		replace cd5_bspis   with 0
		replace cd5_alpis   with 0
		replace cd5_vlpis   with 0
		replace cd5_bscof   with 0
		replace cd5_alcof   with 0
		replace cd5_vlcof   with 0     
		replace cd5_dtrgdi  with wDtDi
		replace cd5_local   with "1" 
		replace cd5_ndi     with wDNunDi                 
		replace cd5_dtdi    with wDtDi
		replace cd5_codexp  with substr(wExp,1,6)
		replace cd5_lojexp  with substr(wExp,7,2)
		replace cd5_nadic   with "1"
		replace cd5_sqadic  with "3" 
		replace cd5_codfab  with substr(wFab,1,6)
		replace cd5_lojfab  with substr(wFab,7,2)
		replace cd5_bcimp   with wVBcImp
		replace cd5_dspad   with wDespAd
		replace cd5_vlrii   with tmp2->VLRII
		replace cd5_item    with tmp2->item                             
		replace cd5_locdes  with wDescLoc
		replace cd5_ufdes   with wUfDesemb
		replace cd5_dtdes   with wDtDesemb  
		replace cd5_vlseg   with wVlrSeg
		replace cd5_vlafrm  with wVlrARFM 
		replace cd5_vlafrmm with wVlrARFM
		replace cd5_vlcapa  with wVlrCapa
		replace cd5_vltxce  with wVlrTxCe
		replace cd5_vlhono  with wVlrHono
		replace cd5_vlarmz  with wVlrArma
		replace cd5_vllib   with wVlrLib
		replace cd5_txsisc  with wVlrSisc            
		replace cd5_vtrans  with wVia            
		replace cd5_interm  with "1"           
		//replace cd5_cnpjae  with alltrim(sm0->m0_cgc)            
		replace cd5_ufterc  with alltrim(sm0->m0_estcob)            
	EndIf


	MSUnlock()
	cd5->(dbclosearea())

	CLOSE(odlg3)
Return 

////////TELA DE COMPLEMENTO DE IMPORTAÇÃO


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao   ³ fDadosDI º Autor ³ Ricardo Fiuza    º Data ³  18/12/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dados da DI                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vitapan                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
STATIC FUNCTION fTelCadCom()  

	/*
	Doc. imp  -> CD5_CODIMP (CARACTER)
	dt. reg. DI  -> CD5_DTRGDI (DATA) 
	***Tp. Doc. Imp -> CD5_TPIMP (0 OU 1) JOGAR DIRETO
	No. da DI/DA -> CD5_NDI  (CARACTER)
	Registro DI -> CD5_DTDI (DATA)
	Exportador -> CD5_CODEXP (F3)
	Fabricante -> CD5_CODFAB  (F3)

	Vlr BC Impor-> CD5_BCIMP (NUMERICO)
	Clr Desp Adu -> CD5_DSPAD (NUMERICO)
	Vlr Imp. Impo -> CD5_VLRII (NUMERICO)
	CD5_LOCAL ///NA CD5 SEMPRE É 1


	Desc. Local -> CD5_LOCDES    
	UF desembara-> CD5_UFDES
	Dt Desembar -> CD5_DTDES (DATA)
	*****loja exp. -> CD5_LOJEXP
	*****loja fab. -> CD5_LOJFAB
	Vlr. Siscomex.-> CD5_TXSISC (NUMERICO)
	*/

	@ 000,000 to 870,500 dialog odlg9 title "Dados da DI para NFe de Importação"

	@ 012,010 say "No. da DI/DA"
	@ 010,065 get wDNunDi 		Picture "999999999999999" 	   size 070,10  //Valid

	@ 032,010 say "Registro DI"
	@ 030,065 get wDtDi 		Picture "@d" 			       size 070,10

	@ 052,010 say "Exportador"
	@ 050,065 get wExp 	    	Picture "@!" 			       size 070,10  F3 "SA2I"

	@ 072,010 say "Fabricante"
	@ 070,065 get wFab 	     	Picture "@!" 			       size 070,10  F3 "SA2I"  

	@ 092,010 say "Vlr BC Impor"
	@ 090,065 get wVBcImp 		Picture "@E 999,999,999.99"	   size 070,10

	@ 112,010 say "Vlr Desp Adu"
	@ 110,065 get wDespAd 		Picture "@E 999,999,999.99"	   size 070,10   

	@ 132,010 say "Vlr Imp Impo"
	@ 130,065 get wImpImp 	    Picture "@E 999,999,999.99"    size 070,10 

	@ 152,010 say "Cidade Desembaraço"
	@ 150,065 get wDescLoc    	Picture "@!" 			       size 150,10

	@ 172,010 say "UF Desembaraço"
	@ 170,065 get wUfDesemb 	Picture "@!" 			       size 030,10

	@ 192,010 say "Data Desembaraço"                           
	@ 190,065 get wDtDesemb		Picture "@d" 			       size 070,10

	@ 212,010 say "Vlr. Siscomex"
	@ 210,065 get wVlrSisc		Picture "@E 999,999,999.99"    size 070,10

	@ 232,010 say "Vlr. Seguro"
	@ 230,065 get wVlrSeg		Picture "@E 999,999,999.99"    size 070,10

	@ 252,010 say "Vlr. AFRMM"
	@ 250,065 get wVlrARFM		Picture "@E 999,999,999.99"    size 070,10

	@ 272,010 say "Vlr. Capatazia"
	@ 270,065 get wVlrCapa		Picture "@E 999,999,999.99"    size 070,10

	@ 292,010 say "Vlr. TX CE"
	@ 290,065 get wVlrTxCe		Picture "@E 999,999,999.99"    size 070,10

	@ 312,010 say "Vlr. Honorarios"
	@ 310,065 get wVlrHono		Picture "@E 999,999,999.99"    size 070,10

	@ 332,010 say "Vlr. Armazenagem"
	@ 330,065 get wVlrArma		Picture "@E 999,999,999.99"    size 070,10

	@ 352,010 say "Vlr. Liberacao BL"
	@ 350,065 get wVlrLib		Picture "@E 999,999,999.99"    size 070,10

	@ 372,010 say "Via(1-Mar;4-Aereo)"
	@ 370,065 get wVia	  		Picture "@!" 			       size 015,10


	@ 392,200 bmpbutton type 1 action fGraDadosCom()

	Activate Dialog odlg9 Centered

Return  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao   ³fGraDadosDI º Autor ³ Ricardo Fiuza    º Data ³  18/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dados da DI                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bradel                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function fGraDadosCom()  

	// Tabela de Complementos de Importação
	cd5->(dbgobottom())
	dbselectarea("CD5")

	// Cria Array com todos os campos do CD5
	aCD5 := array(fCount())
	for i:=1 to FCount()
		aCD5[i] := fieldget(i)
	next

	RecLock("CD5",.t.)

	for i:=1 to FCount()
		fieldput(i,aCD5[i])
	next               

	replace cd5_filial  with _cfilcd5
	replace cd5_doc     with _nota
	replace cd5_serie   with _serie
	replace cd5_espec   with "SPED"
	replace cd5_fornec  with _fornece
	replace cd5_loja    with _loja                 
	replace cd5_tpimp   with '0'                 
	replace cd5_docimp  with wDNunDi
	replace cd5_bspis   with 0
	replace cd5_alpis   with 0
	replace cd5_vlpis   with 0
	replace cd5_bscof   with 0
	replace cd5_alcof   with 0
	replace cd5_vlcof   with 0     
	replace cd5_dtrgdi  with wDtDi
	replace cd5_local   with "1" 
	replace cd5_ndi     with wDNunDi                 
	replace cd5_dtdi    with wDtDi
	replace cd5_codexp  with substr(wExp,1,6)
	replace cd5_lojexp  with substr(wExp,7,2)
	replace cd5_nadic   with "1"
	replace cd5_sqadic  with "3" 
	replace cd5_codfab  with substr(wFab,1,6)
	replace cd5_lojfab  with substr(wFab,7,2)
	replace cd5_bcimp   with wVBcImp
	replace cd5_dspad   with wDespAd
	replace cd5_vlrii   with tmp3->VLRII
	replace cd5_item    with tmp3->item                             
	replace cd5_locdes  with wDescLoc
	replace cd5_ufdes   with wUfDesemb
	replace cd5_dtdes   with wDtDesemb  
	replace cd5_vlseg   with wVlrSeg
	replace cd5_vlafrm  with wVlrARFM 
	replace cd5_vlafrmm with wVlrARFM
	replace cd5_vlcapa  with wVlrCapa
	replace cd5_vltxce  with wVlrTxCe
	replace cd5_vlhono  with wVlrHono
	replace cd5_vlarmz  with wVlrArma
	replace cd5_vllib   with wVlrLib
	replace cd5_txsisc  with wVlrSisc            
	replace cd5_vtrans  with wVia            
	replace cd5_interm  with "1"           
	//replace cd5_cnpjae  with alltrim(sm0->m0_cgc)            
	replace cd5_ufterc  with alltrim(sm0->m0_estcob)                        


	MSUnlock()
	cd5->(dbclosearea())

	CLOSE(odlg9)
	Return 
	if altera
		_drecbmto:=ctod("  /  /  ")
		_hrecbmto:=SPACE(6)  
		_msgnf   :=SPACE(250)


		if sf1->f1_tipo=='D' .and. sf1->f1_formul=='S' 

			_nordsb1:=sb1->(indexord())
			_nordsc5:=sc5->(indexord())
			_nordsd2:=sd2->(indexord())
			_nordda0:=da0->(indexord())
			_nordcd7:=cd7->(indexord())
			_nordF0A:=F0A->(indexord())
			_nordsc2:=sc2->(indexord())
			_nordcd5:=cd5->(indexord())

			_nregsb1:=sb1->(recno())
			_nregsc5:=sc5->(recno())
			_nregsd2:=sd2->(recno())
			_nregda0:=da0->(recno())
			_nregcd7:=cd7->(recno())
			_nregF0A:=F0A->(recno())
			_nregsc2:=sc2->(recno())
			_nregcd5:=cd5->(recno())

			_cfilsb1:=xfilial("SB1")
			_cfilsc5:=xfilial("SC5")
			_cfilsd2:=xfilial("SD2")
			_cfilcd7:=xfilial("CD7")
			_cfilF0A:=xfilial("F0A")
			_cfilda0:=xfilial("DA0")
			_cfilsc2:=xfilial("SC2")
			_cfilcd5:=xfilial("CD5")
			sb1->(dbsetorder(1))
			sc5->(dbsetorder(1))
			sd2->(dbsetorder(3))
			F0A->(dbsetorder(1))
			cd7->(dbsetorder(1)) //Filial + Tip.Movimento + Serie + Documento + Cliente + Loja + Item + Código
			sd2->(dbsetorder(3)) //Filial + Documento + Série + Cliente + Loja + Código + Item
			sb1->(dbsetorder(1)) //Filial + Codigo
			sc5->(dbsetorder(1)) //Filial + Num.Pedido
			da0->(dbsetorder(1)) //Filial + Código Tabela
			sc2->(dbsetorder(1)) //Filial + Num.OP + Item + Sequencia + Item Grade
			cd5->(dbsetorder(4)) //Filial + Numero NF + Serie NF + Fornecedor + Codigo loja

			_nota:=sf1->f1_doc
			_serie:=sf1->f1_serie

			processa({|| _cquery(_nota,_serie)})
			tmp1->(dbgotop())

			while ! tmp1->(eof())

				If tmp1->TIPO $ ("PA,PL") .AND. TMP1->TPPROD <> "6"

					cd7->(dbgobottom())
					dbselectarea("CD7")

					// Cria Array com todos os campos do CD7
					aCD7 := array(fCount())
					for i:=1 to FCount()
						aCD7[i] := fieldget(i)
					next

					RecLock("CD7",.t.)

					for i:=1 to FCount()
						fieldput(i,aCD7[i])
					next

					replace cd7_filial  with "01"
					replace cd7_tpmov   with "E"
					replace cd7_doc     with _nota
					replace cd7_serie   with _serie
					replace cd7_espec   with "SPED"
					replace cd7_clifor  with tmp1->fornece
					replace cd7_loja    with tmp1->loja
					replace cd7_item    with tmp1->item
					replace cd7_cod     with tmp1->cod
					replace cd7_lote    with tmp1->lotectl
					replace cd7_qtdlot  with tmp1->quant
					replace cd7_fabric  with tmp1->emissao
					replace cd7_valid   with tmp1->dtvalid
					replace cd7_codanv  with tmp1->anvisa

					if tmp1->grtrib=='001'
						replace cd7_refbas  with "3"
					else
						replace cd7_refbas  with "2"
					endif
					replace cd7_tpprod  with tmp1->tpprod
					replace cd7_preco   with tmp1->pmc

					MSUnlock()

					CD7->(dbclosearea())

					F0A->(dbgobottom())
					dbselectarea("F0A")

					// Cria Array com todos os campos do F0A
					aF0A := array(fCount())
					for i:=1 to FCount()
						aF0A[i] := fieldget(i)
					next

					RecLock("F0A",.t.)

					for i:=1 to FCount()
						fieldput(i,aF0A[i])
					next

					replace F0A_filial  with "01"
					replace F0A_tpmov   with "E"
					replace F0A_doc     with _nota
					replace F0A_serie   with _serie
					//					replace F0A_espec   with "SPED"
					replace F0A_clifor  with tmp1->fornece
					replace F0A_loja    with tmp1->loja
					replace F0A_item    with tmp1->item
					replace F0A_cod     with tmp1->cod
					replace F0A_lote    with tmp1->lotectl
					replace F0A_qtdlot  with tmp1->quant
					replace F0A_fabric  with tmp1->emissao
					replace F0A_valid   with tmp1->dtvalid
					//					replace F0A_preco   with tmp1->pmc

					MSUnlock()

					F0A->(dbclosearea())
				ElseIf TMP1->RASTRO = "L"
					F0A->(dbgobottom())
					dbselectarea("F0A")
					// Cria Array com todos os campos do F0A
					aF0A := array(fCount())
					for i:=1 to FCount()
						aF0A[i] := fieldget(i)
					next

					RecLock("F0A",.t.)

					for i:=1 to FCount()
						fieldput(i,aF0A[i])
					next

					replace F0A_filial  with "01"
					replace F0A_tpmov   with "E"
					replace F0A_doc     with _nota
					replace F0A_serie   with _serie
					//					replace F0A_espec   with "SPED"
					replace F0A_clifor  with tmp1->fornece
					replace F0A_loja    with tmp1->loja
					replace F0A_item    with tmp1->item
					replace F0A_cod     with tmp1->cod
					replace F0A_lote    with tmp1->lotectl
					replace F0A_qtdlot  with tmp1->quant
					replace F0A_fabric  with tmp1->emissao
					replace F0A_valid   with tmp1->dtvalid
					//					replace F0A_preco   with tmp1->pmc

					MSUnlock()

					F0A->(dbclosearea())
				EndIf
				tmp1->(dbskip())

			end
			tmp1->(dbclosearea())
		endif
	endif


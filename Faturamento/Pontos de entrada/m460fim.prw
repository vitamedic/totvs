#include "rwmake.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} m460fim

Este P.E. é chamado após a Gravacao da NF de Saida, e fora da transação.

@author Vitapan
@since 18/01/2018
@version 1.0
@return Nil

@type function
/*/
user function m460fim()

	Local  _vTransf := 0
	Local  _VDesc   := 0
	Local  cNota    := " "
	Local  cSerie   := " "
	Local _ArSD1    := SD1->(GetArea())
	Local _PEDC9 
	Local _AGREG

	//Hen 24/08
	dbSelectArea("SD1")
	_cfilsd1:=xfilial("SD1")
	_nordsd1:=sd1->(indexord())
	_nregsd1:=sd1->(recno())
	sd1->(dbOrderNickName("D1FABRIC")) //D1_FILIAL+D1_COD+D1_LOTECTL

	_nordsb1:=sb1->(indexord())
	_nordsc5:=sc5->(indexord())
	_nordsd2:=sd2->(indexord())
	_nordse1:=se1->(indexord())
	_nordda0:=da0->(indexord())
	_nordcd7:=cd7->(indexord())
	_nordsc2:=sc2->(indexord())
	_nordf0A:=f0A->(indexord())

	_nregsb1:=sb1->(recno())
	_nregsc5:=sc5->(recno())
	_nregsd2:=sd2->(recno())
	_nregse1:=se1->(recno())
	_nregda0:=da0->(recno())
	_nregcd7:=cd7->(recno())
	_nregsc2:=sc2->(recno())
	_nregf0A:= f0A->(recno())

	_cfilsb1:=xfilial("SB1")
	_cfilsc5:=xfilial("SC5")
	_cfilsd2:=xfilial("SD2")
	_cfilse1:=xfilial("SE1")
	sb1->(dbsetorder(1))
	sc5->(dbsetorder(1))
	sd2->(dbsetorder(3))
	se1->(dbsetorder(1))

	_ncx    :=0
	_cpedido:=space(6)

	sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie+sf2->f2_cliente+sf2->f2_loja))
	while ! sd2->(eof()) .and.;
	sd2->d2_filial==_cfilsd2 .and.;
	sd2->d2_doc==sf2->f2_doc
		if sd2->d2_serie==sf2->f2_serie .and.;
		sd2->d2_cliente==sf2->f2_cliente .and.;
		sd2->d2_loja==sf2->f2_loja
			sb1->(dbseek(_cfilsb1+sd2->d2_cod))
			_ncx+=int(sd2->d2_quant/sb1->b1_cxpad)
			_cpedido:=sd2->d2_pedido
		endif
		sd2->(dbskip())
	end
	if _ncx>0
	sf2->(reclock("SF2",.f.))
	sf2->f2_volume1:=_ncx
	sf2->(msunlock())
	endif
	if ! sf2->f2_tipo$"BD" .and.;
	sf2->f2_valfat>0
		sc5->(dbseek(_cfilsc5+_cpedido))
		se1->(dbseek(_cfilse1+sf2->f2_serie+sf2->f2_doc))
		while ! se1->(eof()) .and.;
		se1->e1_filial==_cfilse1 .and.;
		se1->e1_prefixo==sf2->f2_serie .and.;
		se1->e1_num==sf2->f2_doc
			if sf2->f2_icmsret>0 .and.;
			se1->e1_tipo=="NF " .and.;
			se1->e1_cliente==sf2->f2_cliente .and.;
			se1->e1_loja==sf2->f2_loja .and.;
			! se1->e1_parcela$"R/ "
				if se1->e1_parcela=="A"
					se1->(dbskip())
					_nproxreg:=se1->(recno())
					se1->(dbskip(-1))
					se1->(reclock("SE1",.f.))
					se1->e1_parcela:="R"
					se1->e1_valjur :=0
					se1->e1_comis1 :=0
					se1->e1_comis2 :=0
					se1->e1_comis3 :=0
					se1->e1_comis4 :=0
					se1->e1_comis5 :=0
					se1->e1_bascom1:=0
					se1->e1_bascom2:=0
					se1->e1_bascom3:=0
					se1->e1_bascom4:=0
					se1->e1_bascom5:=0
					se1->e1_valcom1:=0
					se1->e1_valcom2:=0
					se1->e1_valcom3:=0
					se1->e1_valcom4:=0
					se1->e1_valcom5:=0
					se1->(msunlock())
					se1->(dbgoto(_nproxreg))
				else
					se1->(reclock("SE1",.f.))
					se1->e1_parcela:=chr(asc(se1->e1_parcela)-1)
					se1->e1_valjur :=0
					se1->e1_comis1 :=sc5->c5_comis1
					se1->e1_comis2 :=sc5->c5_comis2
					se1->e1_comis3 :=sc5->c5_comis3
					se1->e1_comis4 :=sc5->c5_comis4
					se1->e1_comis5 :=sc5->c5_comis5
					se1->(msunlock())
					se1->(dbskip())
				endif
			elseif se1->e1_parcela<>"R"
				se1->(reclock("SE1",.f.))
				se1->e1_valjur :=0
				se1->e1_comis1 :=sc5->c5_comis1
				se1->e1_comis2 :=sc5->c5_comis2
				se1->e1_comis3 :=sc5->c5_comis3
				se1->e1_comis4 :=sc5->c5_comis4
				se1->e1_comis5 :=sc5->c5_comis5
				se1->(msunlock())
				se1->(dbskip())
			else
				se1->(dbskip())
			endif
		end
	endif

	_nota:=sf2->f2_doc
	_serie:=sf2->f2_serie

	if alltrim(sf2->f2_serie)<>"R"
		_cfilcd7:=xfilial("CD7")
		_cfilda0:=xfilial("DA0")
		_cfilsc2:=xfilial("SC2")
		_cfilf0A:=xfilial("F0A")
		_cfilsa1:=xfilial("SA1")

		cd7->(dbsetorder(1)) //Filial + Tip.Movimento + Serie + Documento + Cliente + Loja + Item + Código
		sd2->(dbsetorder(3)) //Filial + Documento + Série + Cliente + Loja + Código + Item
		sb1->(dbsetorder(1)) //Filial + Codigo
		sc5->(dbsetorder(1)) //Filial + Num.Pedido
		da0->(dbsetorder(1)) //Filial + Código Tabela
		sc2->(dbsetorder(1)) //Filial + Num.OP + Item + Sequencia + Item Grade
		f0A->(dbsetorder(1)) //Tipo Mov. + Série Nf + Doc. Fiscal + Cli/for + Loja + Num. Item + Cod.


		sd2->(dbseek(_cfilsd2+sf2->f2_doc+sf2->f2_serie+sf2->f2_cliente+sf2->f2_loja))
		while ! sd2->(eof()) .and.;
		sd2->d2_filial==_cfilsd2 .and.;
		sd2->d2_doc==sf2->f2_doc

			sb1->(dbseek(_cfilsb1+sd2->d2_cod))

			procregua(1)

			incproc("Selecionando Itens no SD2...")

			if sb1->b1_tipo$"PA/PL/MP/EE/EN/PN/PD/PM" .and.;   //ADICIONEI PN 18/07/2016  A PEDIDO GUILHERME 11:30
			!empty(sd2->d2_lotectl)

				if sb1->b1_tipo$"PA/PL/PN/EN/PD/PM" .and. SUBSTR(sd2->d2_lotectl,1,4) <> "AUTO"    //Alteração para itens de "EN" que foram produzidos internamente.

					/*BUSCA ITENS GRAVADOS NO SD2*/
					#IFDEF TOP
					lQuery  := .T.
					tmp1 := GetNextAlias()
					BeginSql Alias tmp1

						SELECT
						D2_COD COD,
						D2_ITEM ITEM,
						B1_TIPO TIPO,
						B1_APREVEN APREVEN,
						B1_RASTRO RASTRO,
						B1_CMED CMED,
						B1_DESC DESCRI,
						B1_TPPROD TPPROD,
						CAST((D2_PRUNIT/FATOR) AS NUMERIC(18,2)) PMC,
						B1_GRTRIB GRTRIB,
						B1_ANVISA ANVISA,
						D2_LOTECTL LOTECTL,
						C2_DATPRI EMISSAO,
						C2_DTVALID DTVALID,
						D2_EST EST,
						D2_PEDIDO PEDIDO,
						D2_PRUNIT PRUNIT,
//						C5_TABELA TABELA,
						A1_SUFRAMA SUFRAMA,
//						DA0_STATUS TABSTATUS,
						D2_CLIENTE CLIENTE,
						D2_LOJA LOJA,
						D2_QUANT QUANT
						FROM
						(SELECT
						D2_COD,
						D2_ITEM,
						B1_TIPO,
						B1_APREVEN,
						B1_CMED,
						B1_DESC,
						B1_RASTRO,
						B1_GRTRIB,
						B1_TPPROD,
						B1_ANVISA,
						D2_LOTECTL,
						C2_DATPRI,
						C2_DTVALID,
						D2_EST,
						D2_PEDIDO,
						D2_PRUNIT,
						A1_SUFRAMA,
//						C5_TABELA,
//						DA0_STATUS,
						CASE                              //Alteração das aliquotas conforme chamado 005717 (karla)
						WHEN  B1_GRTRIB='001' THEN 0.723358  // POSITIVA  0.7234
						WHEN (B1_GRTRIB='002' AND D2_EST='RJ') THEN 0.751296 //19% 0.7523
						WHEN (B1_GRTRIB='002' AND D2_EST='MG' AND B1_TPPROD='1') THEN 0.748624 //12% 0.7499
						WHEN (B1_GRTRIB='002' AND D2_EST IN ('RO')) THEN 0.750402   //novo a partir de 02/01/17
						WHEN (B1_GRTRIB='002' AND D2_EST IN ('SP','MG','PR','MA','PB','PE','RS','SE','PI','TO')) THEN 0.750577   //18%  07519
//						WHEN (B1_GRTRIB='002' AND D2_EST='AM' AND DA0_STATUS<>'Z') THEN 0.750577 //18% 0.7519
						WHEN (B1_GRTRIB='002' AND D2_EST='AM' AND A1_SUFRAMA=' ') THEN 0.750577 //18% 0.7519
						WHEN (B1_GRTRIB='002' AND D2_EST IN ('AC','RR','RO','AM','AP') AND A1_SUFRAMA<> '') THEN 0.723358 //ZONA FRANCA
//						WHEN (B1_GRTRIB='002' AND DA0_STATUS='Z') THEN 0.723358   //ZONA FRANCA    0.7234
						ELSE 0.750230 // 17%  0.7515
					END FATOR,
					D2_CLIENTE,
					D2_LOJA,
					D2_QUANT
					FROM
					%Table:SB1% SB1,
					%Table:SD2% SD2,
					%Table:SC5% SC5,
//					%Table:DA0% DA0,
					%Table:SA1% SA1,
					%Table:SC2% SC2
					WHERE SB1.%NotDel% AND SD2.%NotDel% AND SC5.%NotDel% AND SC2.%NotDel% //AND DA0.%NotDel%
					AND SB1.B1_FILIAL=%Exp:_cfilsb1%
					AND SD2.D2_FILIAL=%Exp:_cfilsd2%
					AND SC5.C5_FILIAL=%Exp:_cfilsc5%
//					AND DA0.DA0_FILIAL=%Exp:_cfilda0%
					AND SA1.A1_FILIAL=%Exp:_cfilsa1%
					AND SC2.C2_FILIAL=%Exp:_cfilsc2%
					AND D2_DOC=%Exp:_nota%
					AND D2_SERIE=%Exp:_serie%
					AND D2_COD=B1_COD
					AND D2_PEDIDO=C5_NUM
//					AND C5_TABELA=DA0_CODTAB
					AND D2_CLIENTE=A1_COD
					AND C2_LOTECTL=D2_LOTECTL
					AND D2_ITEM=%Exp:sd2->d2_item%
					ORDER BY D2_ITEM)
					ORDER BY D2_ITEM
				EndSql

				//Se não encontrar informações da procução do produto, procura nas entradas
				(tmp1)->(dbgotop())
				if (tmp1)->( Eof() .or. ( empty(LOTECTL) .and. empty(DTVALID) ) )
					(tmp1)->(dbCloseArea())

					lQuery  := .T.
					tmp1 := GetNextAlias()
					BeginSql Alias tmp1
						SELECT
						D2_COD COD,
						D2_ITEM ITEM,
						B1_TIPO TIPO,
						B1_APREVEN APREVEN,
						B1_CMED CMED,
						B1_RASTRO RASTRO,
						B1_DESC DESCRI,
						B1_TPPROD TPPROD,
						CAST((D2_PRUNIT/FATOR) AS NUMERIC(18,2)) PMC,
						B1_GRTRIB GRTRIB,
						B1_ANVISA ANVISA,
						D2_LOTECTL LOTECTL,
						D1_DTFABR EMISSAO,
						D1_DTVALID DTVALID,
						D2_EST EST,
						D2_PEDIDO PEDIDO,
						D2_PRUNIT PRUNIT,
//						C5_TABELA TABELA,
						A1_SUFRAMA SUFRAMA,
//						DA0_STATUS TABSTATUS,
						D2_CLIENTE CLIENTE,
						D2_LOJA LOJA,
						D2_QUANT QUANT
						FROM
						(SELECT
						D2_COD,
						D2_ITEM,
						B1_TIPO,
						B1_RASTRO,
						B1_APREVEN,
						B1_CMED,
						B1_DESC,
						B1_GRTRIB,
						B1_TPPROD,
						B1_ANVISA,
						D2_LOTECTL,
						D1_DTFABR,
						D1_DTVALID,
						D2_EST,
						D2_PEDIDO,
						D2_PRUNIT,
						A1_SUFRAMA,
//						C5_TABELA,
//						DA0_STATUS,
						CASE                              //AlteraÃ§Ã£o das aliquotas conforme chamado 005717 (karla)
						WHEN  B1_GRTRIB='001' THEN 0.723358  // POSITIVA  0.7234
						WHEN (B1_GRTRIB='002' AND D2_EST='RJ') THEN 0.751296 //19% 0.7523
						WHEN (B1_GRTRIB='002' AND D2_EST='MG' AND B1_TPPROD='1') THEN 0.748624 //12% 0.7499
						WHEN (B1_GRTRIB='002' AND D2_EST IN ('RO')) THEN 0.750402   //novo a partir de 02/01/17
						WHEN (B1_GRTRIB='002' AND D2_EST IN ('SP','MG','PR','MA','PB','PE','RS','SE','PI','TO')) THEN 0.750577   //18%  07519
//						WHEN (B1_GRTRIB='002' AND D2_EST='AM' AND DA0_STATUS<>'Z') THEN 0.750577 //18% 0.7519
						WHEN (B1_GRTRIB='002' AND D2_EST='AM' AND A1_SUFRAMA=' ') THEN 0.750577 //18% 0.7519
						WHEN (B1_GRTRIB='002' AND D2_EST IN ('AC','RR','RO','AM','AP') AND A1_SUFRAMA<> ' ') THEN 0.723358
//						WHEN (B1_GRTRIB='002' AND DA0_STATUS='Z') THEN 0.723358   //ZONA FRANCA    0.7234
						ELSE 0.750230 // 17%  0.7515
					END FATOR,
					D2_CLIENTE,
					D2_LOJA,
					D2_QUANT
					FROM
					%Table:SB1% SB1,
					%Table:SD2% SD2,
					%Table:SC5% SC5,
//					%Table:DA0% DA0,
					%Table:SA1% SA1,
					%Table:SD1% SD1
					WHERE SB1.%NotDel% AND SD2.%NotDel% AND SC5.%NotDel% AND SD1.%NotDel% //AND DA0.%NotDel%
					AND SB1.B1_FILIAL=%Exp:_cfilsb1%
					AND SD2.D2_FILIAL=%Exp:_cfilsd2%
					AND SC5.C5_FILIAL=%Exp:_cfilsc5%
//					AND DA0.DA0_FILIAL=%Exp:_cfilda0%
					AND SA1.A1_FILIAL=%Exp:_cfilsa1%
					AND SD1.D1_FILIAL=%Exp:_cfilsd1%
					AND D2_DOC=%Exp:_nota%
					AND D2_SERIE=%Exp:_serie%
					AND D2_COD=B1_COD
					AND D2_PEDIDO=C5_NUM
//					AND C5_TABELA=DA0_CODTAB
					AND D2_CLIENTE=A1_COD
					AND D1_COD=D2_COD
					AND D1_LOTECTL=D2_LOTECTL
					AND D2_ITEM=%Exp:sd2->d2_item%
					ORDER BY D2_ITEM)
					ORDER BY D2_ITEM
				EndSql
			endif

			#ENDIF
		else
			#IFDEF TOP
			lQuery  := .T.
			tmp1 := GetNextAlias()
			BeginSql Alias tmp1

				SELECT
				D2_COD COD,
				D2_ITEM ITEM,
				B1_DESC DESCRI,
				B1_TIPO TIPO,
				B1_RASTRO RASTRO,
				B1_APREVEN APREVEN,
				B1_CMED CMED,
				B1_ANVISA ANVISA,
				' ' TPPROD,
				0.00 PMC,
				' ' GRTRIB,
				D2_LOTECTL LOTECTL,
				D1_DTFABR EMISSAO,
				D1_DTVALID DTVALID,
				D2_EST EST,
				D2_PEDIDO PEDIDO,
				D2_PRUNIT PRUNIT,
				' ' TABELA,
				' ' TABSTATUS,
				D2_CLIENTE CLIENTE,
				D2_LOJA LOJA,
				D1_QUANT QUANT
				FROM (
				SELECT
				D2_COD,
				D2_ITEM,
				B1_TIPO,
				B1_RASTRO,
				B1_APREVEN,
				B1_CMED,
				B1_DESC,
				B1_ANVISA,
				D2_LOTECTL,
				D1_DTFABR,
				D1_DTVALID,
				D2_EST,
				D2_PEDIDO,
				D2_PRUNIT,
				D2_CLIENTE,
				D2_LOJA,
				D1_QUANT
				FROM
				%Table:SB1% SB1,
				%Table:SD2% SD2,
				%Table:SD1% SD1
				WHERE SB1.%NotDel% AND SD2.%NotDel% AND SD1.%NotDel%
				AND D2_DOC=%Exp:_nota%
				AND D2_SERIE=%Exp:_serie%
				AND D2_COD=B1_COD
				AND D1_LOTECTL=D2_LOTECTL
				AND D2_ITEM=%Exp:SD2->D2_ITEM%
				ORDER BY D2_ITEM)
				ORDER BY D2_ITEM
			EndSql

			#ENDIF
		endif

		// 02/02/2012 - Query processada por função alterado devido a erro no compilador - Alex
		// Função reescrita para comando BeginSql/EndSql

		//processa({|| _cquery(_nota,_serie,sd2->d2_item,sd2->d2_cod)})

			(tmp1)->(dbgotop())
			IF (TMP1)->TIPO $ ("PA/PL") .and. (TMP1)->TPPROD <> "6"
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
			replace cd7_tpmov   with "S"
			replace cd7_doc     with _nota
			replace cd7_serie   with _serie
			replace cd7_espec   with "SPED"
			replace cd7_clifor  with (tmp1)->cliente
			replace cd7_loja    with (tmp1)->loja
			replace cd7_item    with (tmp1)->item
			replace cd7_cod     with (tmp1)->cod
			replace cd7_lote    with (tmp1)->lotectl
			replace cd7_qtdlot  with (tmp1)->quant
			replace cd7_fabric  with stod((tmp1)->emissao)
			replace cd7_valid   with stod((tmp1)->dtvalid)
			replace cd7_codanv  with (tmp1)->anvisa

			if (tmp1)->grtrib=='001'
				replace cd7_refbas  with "3"
			elseif empty((tmp1)->grtrib)
				replace cd7_refbas  with " "
			else
				replace cd7_refbas  with "2"
			endif

			replace cd7_tpprod  with (tmp1)->tpprod
			//alterado a pedido da karla para zerar a CD7_preco desses produtos conforme a regra. 04/01/2016
			if (tmp1)->tipo $ ("PN/PD/PM")
				replace cd7_preco   with 0
			elseif (tmp1)->tipo $ ("PA/PL") .and. (tmp1)->apreven == '2'
				replace cd7_preco   with 0
			elseif (tmp1)->tipo $ ("PA/PL") .and. (tmp1)->apreven == '1' .and. (tmp1)->cmed == '2'
				replace cd7_preco   with 0
			else
				replace cd7_preco   with (tmp1)->pmc
			endif

			MSUnlock()

			cd7->(dbclosearea())
			
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

			replace f0A_filial  with _cfilf0A
			replace f0A_tpmov   with "S"
			replace f0A_doc     with _nota
			replace f0A_serie   with _serie
			//replace f0A_espec   with "SPED"
			replace f0A_clifor  with (tmp1)->cliente
			replace f0A_loja    with (tmp1)->loja
			replace f0A_item    with (tmp1)->item
			replace f0A_cod     with (tmp1)->cod
			replace f0A_lote    with (tmp1)->lotectl
			replace f0A_qtdlot  with (tmp1)->quant
			replace f0A_fabric  with stod((tmp1)->emissao)
			replace f0A_valid   with stod((tmp1)->dtvalid)
			if (tmp1)->tipo $ ("PN/PD/PM")
				replace F0A_preco   with 0
			elseif (tmp1)->tipo $ ("PA/PL") .and. (tmp1)->apreven == '2'
				replace F0A_preco   with 0
			elseif (tmp1)->tipo $ ("PA/PL") .and. (tmp1)->apreven == '1' .and. (tmp1)->cmed == '2'
				replace F0A_preco   with 0
			else
				replace F0A_preco   with (tmp1)->pmc
			endif

		ElseIf (TMP1)->RASTRO = "L"


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

			replace f0A_filial  with _cfilf0A
			replace f0A_tpmov   with "S"
			replace f0A_doc     with _nota
			replace f0A_serie   with _serie
			//replace f0A_espec   with "SPED"
			replace f0A_clifor  with (tmp1)->cliente
			replace f0A_loja    with (tmp1)->loja
			replace f0A_item    with (tmp1)->item
			replace f0A_cod     with (tmp1)->cod
			replace f0A_lote    with (tmp1)->lotectl
			replace f0A_qtdlot  with (tmp1)->quant
			replace f0A_fabric  with stod((tmp1)->emissao)
			replace f0A_valid   with stod((tmp1)->dtvalid)

			/*if (tmp1)->grtrib=='001'
				replace f0A_refbas  with "3"
			elseif empty((tmp1)->grtrib)
				replace f0A_refbas  with " "
			else
				replace f0A_refbas  with "2"
			endif*/

//			replace f0A_tpprod  with (tmp1)->tpprod
			//alterado a pedido da karla para zerar a f0A_preco desses produtos conforme a regra. 04/01/2016
			if (tmp1)->tipo $ ("PN/PD/PM")
				replace f0A_preco   with 0
			elseif (tmp1)->tipo $ ("PA/PL") .and. (tmp1)->apreven == '2'
				replace f0A_preco   with 0
			elseif (tmp1)->tipo $ ("PA/PL") .and. (tmp1)->apreven == '1' .and. (tmp1)->cmed == '2'
				replace f0A_preco   with 0
			else
				replace f0A_preco   with (tmp1)->pmc
			endif

			MSUnlock()

			f0A->(dbclosearea())
			EndIf

			(tmp1)->(dbclosearea())	

	endif
	sd2->(dbskip())
	end
	endif

	sb1->(dbsetorder(_nordsb1))
	sc5->(dbsetorder(_nordsc5))
	sd2->(dbsetorder(_nordsd2))
	se1->(dbsetorder(_nordse1))
	da0->(dbsetorder(_nordda0))
	cd7->(dbsetorder(_nordcd7))
	sc2->(dbsetorder(_nordsc2))
	f0A->(dbsetorder(_nordf0A))

	sb1->(dbgoto(_nregsb1))
	sc5->(dbgoto(_nregsc5))
	sd2->(dbgoto(_nregsd2))
	se1->(dbgoto(_nregse1))
	da0->(dbgoto(_nregda0))
	cd7->(dbgoto(_nregcd7))
	sc2->(dbgoto(_nregsc2))
	f0A->(dbgoto(_nregF0A))

	RestArea(_ArSD1)
	sd1->(dbsetorder(_nordsd1))
	sd1->(dbgoto(_nregsd1))

	//Ricardo Fiuza's
	/*     FOI TIRADO POR CAUSA DO PROJETO DESCONTO EM NF.... RICARDO MOREIRA 20/08/2015
	cNota   := SF2->F2_DOC
	cSerie  := SF2->F2_SERIE
	cFilial := SF2->F2_FILIAL

	SFT->(dbSetOrder(6))
	If (SFT->(dbSeek(xFilial("SFT")+"S"+cNota+cSerie)))
	While SFT->FT_FILIAL == cFilial .AND. SFT->FT_NFISCAL == cNota .AND. SFT->FT_SERIE == cSerie        //COLOCAR FILIAL E FIM DE ARQUIVO
	_vTransf := SFT->FT_VALCONT
	If alltrim(SFT->FT_CFOP) $ "5101/5102/6101/6102/6107/6109/6118/6119/7101"
	RecLock( "SFT" , .F. )
	SFT->FT_TOTAL   := _vTransf
	SFT->FT_DESCONT := _VDesc
	MsUnLock()
	EndIf
	SFT->(dbSkip())
	End
	EndIf
	*/

	cFilDes  := SF2->F2_FILIAL
	cDesNf   := SF2->F2_DOC
	cDesSer  := SF2->F2_SERIE
	cDesCli  := SF2->F2_CLIENTE
	cDesLj   := SF2->F2_LOJA

	//cDesPro  := SD2->D2_COD
	//cDesIt   := SD2->D2_ITEM

	_nprdesc := 0
	_nprcdesc:= 0
	_nqtdesc := 0
	_nVldesc := 0

	SD2->(dbSetOrder(3))  //D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE +D2_LOJA +D2_COD +D2_ITEM
	If (SD2->(dbSeek(xFilial("SD2")+cDesNf+cDesSer+cDesCli+cDesLj)))
		While SD2->D2_FILIAL == xFilial("SF2").AND. SD2->D2_DOC == cDesNf .AND. SD2->D2_SERIE == cDesSer  .AND. SD2->D2_CLIENTE == cDesCli  .AND. SD2->D2_LOJA == cDesLj  //.AND. SD2->D2_COD == cDesPro  .AND. SD2->D2_ITEM == cDesIt
			_nprdesc := SD2->D2_PRUNIT
			_nprcdesc:= SD2->D2_PRCVEN
			_nqtdesc := SD2->D2_QUANT
			_nVldesc := (_nprdesc - _nprcdesc)*_nqtdesc

			RecLock( "SD2" , .F. )
			SD2->D2_DESCVL   := _nVldesc
			SD2->D2_DECPR    := POSICIONE("SC6",1,XFILIAL("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD,"C6_DESCPR")
			MsUnLock()
			_nVldesc := 0
			SD2->(dbSkip())
		EndDo
	EndIf

	_PEDC9:= posicione("SC9",6,xfilial("SC9")+SF2->F2_SERIE+SF2->F2_DOC+SPACE(6)+SPACE(2),"SC9->C9_PEDIDO")
	_AGREG:= posicione("SC9",6,xfilial("SC9")+SF2->F2_SERIE+SF2->F2_DOC+SPACE(6)+SPACE(2),"SC9->C9_AGREG")
	DbSelectArea("SZ7")
	DbSetOrder(1)
	If DbSeek(Space(2)+_PEDC9+_AGREG)
		RecLock("SF2",.F.)
		sf2->f2_transp := SZ7->Z7_TRANSP
		sf2->f2_pbruto := SZ7->Z7_PBRUTO
		sf2->f2_pesfret:= SZ7->Z7_PBRUTO
		sf2->f2_pliqui := SZ7->Z7_PLIQUI
		sf2->f2_volume1:= SZ7->Z7_VOLUME1
		sf2->f2_libtran:= SZ7->Z7_libtran
		sf2->f2_dataemb:= SZ7->Z7_DATAEMB
		sf2->f2_horaemb:= SZ7->Z7_HORAEMB
		MsUnLock()
		RecLock("SZ7",.F.)
			SZ7->Z7_NFISCAL:= SF2->F2_DOC
			SZ7->( dbDelete() )
		MsUnLock()
	EndIf
	
	If AllTrim(SF2->F2_SERIE) $ GetMV("MV_ESPECIE")
		AutoNfeEnv(cEmpAnt, cFilAnt, "0", "1", SF2->F2_SERIE, SF2->F2_DOC, SF2->F2_DOC,"S")
	Endif

Return
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT383   ³Autor ³ André Almeida Alves     ³Data ³ 02/05/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina chamada pelo Ponto de Entrada Q215FIM onde e feita  ³±±
±±³          ³ a analise se exixte registro na tabela SD4 sem lote e rea- ³±±
±±³          ³ liza o apontamento utilizando o FEFO                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include 'Protheus.ch'
#include "rwmake.ch"
#include "tbiconn.ch"
#include "topconn.ch"

User Function vit383(_nQuantlib)

//Alimenta as variaveis com o conteudo dos paramentros disponibilizados pelo Ponto de Entrada
	cProd  := PARAMIXB[1]
	cRevpr := PARAMIXB[2]
	cForn  := PARAMIXB[3]
	cLjFor := PARAMIXB[4]
	cDtent := dtos(PARAMIXB[5])
	cLote  := PARAMIXB[6]
	cNtfis := PARAMIXB[7]
	cSerNF := PARAMIXB[8]
	cItNF  := PARAMIXB[9]
	cTpNF  := PARAMIXB[10]
	cOpc   := PARAMIXB[11]
	_lOk   := .T.

	alert ('O produto : '+cProd+' do Fornecedor : '+cForn+' Lote : '+cLote+' recebeu apontamentos de resultados Liberados teste: Quant: '+CVALTOCHAR(_nQuantlib))

//Obtem os empenhos que não posuem lotes.
	_cquery:=" select"
	_cquery+=" *"
	_cquery+=" from sd4010"
	_cquery+=" where d_e_l_e_t_ = ' '"
	_cquery+=" and d4_lotectl = ' '"
	_cquery+=" and d4_cod = '"+cProd+"'"
	_cquery+=" and d4_quant > 0"
	_cquery+=" order by d4_data"
	_cquery:=changequery(_cquery)
	tcquery _cquery new alias "TMP"

	while !tmp->(eof()) .and. _nQuantlib > 0
		if _nQuantlib >= sd4->d4_quant
			// Altera o empenho incluindo o Lote liberado pelo CQ
			if _lOk
				aVetor := {}
				nOpc   := 4
				lMsErroAuto := .F.
				alert("Altera"+CVALTOCHAR(_nQuantlib))
				aVetor:={{"D4_filial" ,tmp->d4_filial  ,Nil},; //COM O TAMANHO EXATO DO CAMPO
					{"D4_COD" ,cProd  	,Nil},;
					{"D4_LOCAL" ,tmp->d4_local  	,Nil},;
					{"D4_OP" ,tmp->d4_op		    ,Nil},;
					{"D4_SITUACA",TMP->D4_SITUACA, NIL},;
					{"D4_DATA" ,tmp->d4_data   		,Nil},;
					{"D4_QTDEORI",tmp->d4_qtdeori    ,Nil},;
					{"D4_QUANT" ,tmp->d4_quant      ,Nil},;
					{"D4_TRT",tmp->d4_trt           ,Nil},;
					{"D4_QTSEGUM",tmp->d4_qtsegum   ,Nil},;
					{"D4_LOTECTL",cLote   ,Nil},;
					{"D4_NUMLOTE",tmp->d4_numlote	,Nil},;
					{"D4_OPORIG",tmp->D4_OPORIG,Nil},;
					{"D4_ORDEM",tmp->D4_ORDEM,Nil},;
					{"D4_STATUS",tmp->D4_STATUS,Nil},;
					{"D4_SEQ",tmp->D4_SEQ,Nil},;
					{"D4_NUMPVBN",tmp->D4_NUMPVBN,Nil},;
					{"D4_ITEPVBN",tmp->D4_ITEPVBN,Nil},;
					{"D4_CODLAN",tmp->D4_CODLAN,Nil},;
					{"D4_CBTM",tmp->D4_CBTM,Nil}}
					
				MSExecAuto({|x,y| mata380(x,y)},aVetor,nOpc) //Alteração
				If lMsErroAuto
					Conout("Erro")
					MostraErro()
					_lOk := .F.
				Else
					Conout("Alterado")
					_nQuantlib := _nQuantlib - sd4->d4_quant
				Endif
			endif
		elseif _nQuantlib < sd4->d4_quant
			if _lOk
				// Exclui o registro para criar com a quantidade disponivel no Lote
				aVetor := {}
				nOpc   := 5
				lMsErroAuto := .F.
				alert("Excluido")
				aVetor:={{"D4_filial" ,tmp->d4_filial  ,Nil},; //COM O TAMANHO EXATO DO CAMPO
					{"D4_COD" ,cProd  	,Nil},;
					{"D4_LOCAL" ,tmp->d4_local  	,Nil},;
					{"D4_OP" ,tmp->d4_op		    ,Nil},;
					{"D4_DATA" ,tmp->d4_data   		,Nil},;
					{"D4_QTDEORI",tmp->d4_qtdeori    ,Nil},;
					{"D4_QUANT" ,tmp->d4_quant      ,Nil},;
					{"D4_TRT",tmp->d4_trt           ,Nil},;
					{"D4_QTSEGUM",tmp->d4_qtsegum   ,Nil}}

				MSExecAuto({|x,y| mata380(x,y)},aVetor,nOpc) //Alteração
				If lMsErroAuto
					Conout("Erro")
					MostraErro()
					_lOk := .F.
				Else
					Conout("Excluido")
				Endif
			endif
			if _lOk
				// Inclui o resgistro com a quantidade disponivel do lote
				aVetor := {}
				nOpc   := 3
				lMsErroAuto := .F.
				alert("Inlcuido Apos Excluir")
				aVetor:={{"D4_filial" ,tmp->d4_filial  ,Nil},; //COM O TAMANHO EXATO DO CAMPO
					{"D4_COD" ,cProd  	,Nil},;
					{"D4_LOCAL" ,tmp->d4_local  	,Nil},;
					{"D4_OP" ,tmp->d4_op		    ,Nil},;
					{"D4_DATA" ,tmp->d4_data   		,Nil},;
					{"D4_QTDEORI",_nQuantlib        ,Nil},;
					{"D4_QUANT" ,_nQuantlib         ,Nil},;
					{"D4_TRT",tmp->d4_trt           ,Nil},;
					{"D4_QTSEGUM",tmp->d4_qtsegum   ,Nil},;
					{"D4_POTENCI",tmp->d4_potenci   ,Nil},;
					{"D4_LOTECTL",cLote				,Nil}}

				MSExecAuto({|x,y| mata380(x,y)},aVetor,nOpc) //Alteração
				If lMsErroAuto
					Conout("Erro")
					MostraErro()
					_lOk := .F.
				Else
					Conout("Inlcuido Apos Excluir")
					_nQuantlib := _nQuantlib - sd4->d4_quant
				Endif
			endif
			if _lOk
				// Inclui o resgistro com a quantidade restante do empenho.
				aVetor := {}
				nOpc   := 3
				lMsErroAuto := .F.
				alert("Inlcuir com Lote em branco")
				aVetor:={{"D4_filial" ,tmp->d4_filial  ,Nil},; //COM O TAMANHO EXATO DO CAMPO
					{"D4_COD" ,cProd  	,Nil},;
					{"D4_LOCAL" ,tmp->d4_local  	,Nil},;
					{"D4_OP" ,tmp->d4_op		    ,Nil},;
					{"D4_DATA" ,tmp->d4_data   		,Nil},;
					{"D4_QTDEORI",_nQuantlib    ,Nil},;
					{"D4_QUANT" ,_nQuantlib      ,Nil},;
					{"D4_TRT",tmp->d4_trt           ,Nil},;
					{"D4_QTSEGUM",tmp->d4_qtsegum   ,Nil},;
					{"D4_LOTECTL","          "      ,Nil}}

				MSExecAuto({|x,y| mata380(x,y)},aVetor,nOpc) //Inclusão
				If lMsErroAuto
					Conout("Erro")
					MostraErro()
					_lOk := .F.
				Else
					Conout("Inlcuir com Lote em branco")
					_nQuantlib := 0
				Endif
			endif
		endif
		tmp->(dbskip())
	end
Return .T.

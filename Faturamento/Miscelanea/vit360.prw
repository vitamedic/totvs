/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT360   ³ Autor ³ Alex Júnio de Miranda ³ Data ³ 01/02/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Workflow Resultados Comerciais para Representantes         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"
//#include "dialog.ch"
#include "topconn.ch"
#include "tbiconn.ch"
//#include "tbicode.ch"
#INCLUDE "protheus.ch"

user function vit360()
//prepare environment empresa "01" filial "01" tables "SD2","SB1","SF2","SA3","SCT","DA0","SC5","SC6","SC9","SF4"

_cfilsd2:=xfilial("SD2")  // Itens NF Saída
_cfilsb1:=xfilial("SB1")  // Cadastro de Produtos
_cfilsf2:=xfilial("SF2")  // Cabeçalho NF Saída
_cfilsa3:=xfilial("SA3")  // Cadastro de Vendedores
_cfilsct:=xfilial("SCT")  // Cadastro de Metas
_cfilda0:=xfilial("DA0")  // Cabeçalho de Tabela de Preços
_cfilsc5:=xfilial("SC5")  // Pedidos de Venda - Cabeçalho
_cfilsc6:=xfilial("SC6")  // Pedidos de Venda - Itens
_cfilsc9:=xfilial("SC9")  // Pedidos de Venda - Itens Liberados
_cfilsf4:=xfilial("SF4")  // Cadastro de TES

sd2->(dbsetorder(1))
sb1->(dbsetorder(1))
sf2->(dbsetorder(1))
sa3->(dbsetorder(1))
sct->(dbsetorder(1))
da0->(dbsetorder(1))
sc5->(dbsetorder(1))
sc6->(dbsetorder(1))
sc9->(dbsetorder(1))
sf4->(dbsetorder(1))

if day(date())==01   //dia do mês 
	_cmesant:=""
	_canoant:=""

	if month(date())==01 //busca mês anterior
		_cmesant:="12"
		_canoant:=strzero(year(date())-1,4)
	else
		_cmesant:=strzero(month(date())-1,2)
		_canoant:=strzero(year(date()),4)
	endif

	_dataini:=ctod("01/"+_cmesant+"/"+_canoant)
	_datafim:=lastday(_dataini)
else
	_dataini:= firstday(date())
	_datafim:= lastday(date())
endif

_dtinipend:=firstday(_dataini-180)
_nrealiz:=0

#IFDEF TOP
	lQuery  := .T.
	tmp1 := GetNextAlias()
	BeginSql Alias tmp1
		SELECT
		SA3.A3_COD VEND1, SA3.A3_NOME NOMEVEND, SA3.A3_EMAIL EMAIL, SA3.A3_NREDUZ NREDUZ, SA3.A3_SUPER GERENTE, SB1.B1_APREVEN APREVEN, DA0.DA0_STATUS TABSTATUS, Sum(SD2.D2_TOTAL) TOTAL,
		COALESCE(SCT.CT_VALOR,0) METAVLR
		FROM  %Table:SA3% SA3
			LEFT JOIN %Table:SF2% SF2 ON (SF2.%NotDel% AND SF2.F2_FILIAL=%Exp:_cfilsf2% AND SF2.F2_VEND1=SA3.A3_COD AND SF2.F2_EMISSAO BETWEEN %Exp:dtos(_dataini)% AND %Exp:dtos(_datafim)%)
			LEFT JOIN %Table:SD2% SD2 ON (SD2.%NotDel% AND SD2.D2_FILIAL=%Exp:_cfilsd2% AND SF2.F2_DOC=SD2.D2_DOC AND SF2.F2_SERIE=SD2.D2_SERIE AND D2_TIPO IN ('N','C'))
			LEFT JOIN %Table:SF4% SF4 ON (SF4.%NotDel% AND SF4.F4_FILIAL=%Exp:_cfilsf4% AND SF4.F4_CODIGO=SD2.D2_TES AND SF4.F4_ESTOQUE='S' AND SF4.F4_DUPLIC='S')
			LEFT JOIN %Table:SB1% SB1 ON (SB1.%NotDel% AND SB1.B1_FILIAL=%Exp:_cfilsb1% AND SB1.B1_COD=SD2.D2_COD AND SB1.B1_TIPO IN ('PA','PL'))
			LEFT JOIN %Table:SCT% SCT ON (SCT.%NotDel% AND SCT.CT_FILIAL=%Exp:_cfilsct% AND SCT.CT_VEND=SA3.A3_COD AND SCT.CT_DATA BETWEEN %Exp:dtos(_dataini)% AND %Exp:dtos(_datafim)% AND SCT.CT_PRODUTO=' ')
			LEFT JOIN %Table:SC5% SC5 ON (SC5.%NotDel% AND SC5.C5_FILIAL=%Exp:_cfilsc5% AND SC5.C5_NUM=SD2.D2_PEDIDO)
			LEFT JOIN %Table:DA0% DA0 ON (DA0.%NotDel% AND DA0.DA0_FILIAL=%Exp:_cfilda0% AND DA0.DA0_CODTAB=SC5.C5_TABELA)
		WHERE
		SA3.%NotDel%
  		AND A3_FILIAL=%Exp:_cfilsa3%
  		AND SA3.A3_COD<='000999'
		AND SA3.A3_ATIVO<>'N'
		GROUP BY SA3.A3_COD, SA3.A3_NOME, SA3.A3_EMAIL, SA3.A3_NREDUZ, SA3.A3_SUPER, SB1.B1_APREVEN, DA0.DA0_STATUS, SCT.CT_VALOR
		ORDER BY SA3.A3_COD, SB1.B1_APREVEN
	EndSql

#ENDIF

(tmp1)->(dbgotop())

while !(tmp1)->(eof())

	_gerente:=""
	_emailger:=""

	_cpara:=""

	if ! empty((tmp1)->email)
		_cpara:=(tmp1)->email
	else
		_cpara:="report_comercial@vitamedic.ind.br"
	endif

	_gerente :=  (tmp1)->gerente

	if  ! empty(_gerente)
		sa3->(dbseek(_cfilsa3+_gerente))
		_emailger:=sa3->a3_email
	else
		_emailger:=""
	endif

	/* MONTAR CORPO DO E-MAIL*/
	if ! empty(_cpara)

		// BUSCA INFORMAÇÕES DE PENDÊNCIAS PARA O REPRESENTANTE
		#IFDEF TOP
			lQuery  := .T.
			tmp2 := GetNextAlias()
			BeginSql Alias tmp2
				SELECT
					Sum((QTDVEN-QTDENT-QTDLIB)*PRCVEN) VLRPEND
				FROM
				(SELECT
					SC5.C5_NUM NUM,
					SC5.C5_TIPO TIPO,
					SC5.C5_VEND1 VEND1,
					SA3.A3_NOME NOMEVEND,
					SC6.C6_ITEM ITEM,
					SC6.C6_PRODUTO CODIGO,
					SB1.B1_DESC DESC_PRODUTO,
					SC6.C6_QTDVEN QTDVEN,
					SC6.C6_QTDENT QTDENT,
					C6_PRCVEN PRCVEN,
					COALESCE(Sum(SC9.C9_QTDLIB),0) QTDLIB
				FROM %Table:SC5% SC5
					INNER JOIN %Table:SC6% SC6 ON (SC6.%NotDel% AND SC6.C6_FILIAL=%Exp:_cfilsc6% AND SC6.C6_NUM=SC5.C5_NUM AND SC6.C6_BLQ<>'R ' AND (C6_QTDVEN-C6_QTDENT)>0)
					INNER JOIN %Table:SF4% SF4 ON (SF4.%NotDel% AND SF4.F4_FILIAL=%Exp:_cfilsf4% AND SF4.F4_CODIGO=SC6.C6_TES AND SF4.F4_ESTOQUE='S' AND SF4.F4_DUPLIC='S')
					LEFT  JOIN %Table:SA3% SA3 ON (SA3.%NotDel% AND SA3.A3_FILIAL=%Exp:_cfilsa3% AND SA3.A3_COD=SC5.C5_VEND1)
					INNER JOIN %Table:SB1% SB1 ON (SB1.%NotDel% AND SB1.B1_FILIAL=%Exp:_cfilsb1% AND SB1.B1_COD=SC6.C6_PRODUTO)
					LEFT  JOIN %Table:SC9% SC9 ON (SC9.%NotDel% AND SC9.C9_FILIAL=%Exp:_cfilsc9% AND SC9.C9_PEDIDO=SC6.C6_NUM AND SC9.C9_ITEM=SC6.C6_ITEM AND SC9.C9_NFISCAL=' ' AND SC9.C9_BLCRED=' ' AND SC9.C9_BLEST=' ')
				WHERE SC5.%NotDel%
				AND SC5.C5_EMISSAO BETWEEN %Exp:dtos(_dtinipend)% AND %Exp:dtos(_datafim)%
				AND SubStr(SC5.C5_NUM,6,1)<>'R'
				AND SC5.C5_VEND1=%Exp:(tmp1)->vend1%
				GROUP BY SC5.C5_NUM, SC5.C5_TIPO, SC5.C5_VEND1, SA3.A3_NOME, SC6.C6_ITEM, SC6.C6_PRODUTO, SB1.B1_DESC, SC6.C6_QTDVEN, SC6.C6_QTDENT, SC6.C6_PRCVEN)
			EndSql

		#ENDIF

		(tmp2)->(dbgotop())

		oProcess := TWFProcess():New( "000007", "POSICAO FECHAMENTO" )

		oProcess:NewTask( "000001", "\workflow\fat_representante.htm" )

		oProcess:cSubject := "Vitapan - Informacoes do Fechamento: "+dtoc(_dataini)+" a "+dtoc(_datafim)

		oProcess:bReturn := ""

		oProcess:bTimeOut := {}

		oHTML := oProcess:oHTML

		oHTML:ValByName("DIA"    ,strzero(day(date()),2))
		oHTML:ValByName("MES"    ,mesextenso(date()))
		oHTML:ValByName("ANO"    ,strzero(year(date()),4))
		oHTML:ValByName("NREDUZ" ,alltrim((tmp1)->nreduz))
		oHTML:ValByName("FECHAM" ,mesextenso(_dataini)+"/"+strzero(year(_dataini),4))

		_representante:=(tmp1)->vend1
		_total:=0
		_meta:= (tmp1)->metavlr

		_ctabela:='<table width="400" border="1" cellpadding="0" cellspacing="0" bordercolor="#111111" style="border-collapse: collapse">'

	 	// Meta de Faturamento
		_ctabela+='<tr>'
		_ctabela+='<td width="400" colspan=2 align="left"><font size="2" face="Arial, Helvetica, sans-serif"><b>META</b></font></td></tr>'
		_ctabela+='<tr>'
		_ctabela+='<td width="250" align="left"><font size="2" face="Arial, Helvetica, sans-serif">'+mesextenso(_dataini)+"/"+strzero(year(_dataini),4)+'</font></td>'
		_ctabela+='<td width="150" align="right"><font size="2" face="Arial, Helvetica, sans-serif">'+alltrim(transform(_meta,"@E 999,999,999,999.99"))+'</font></td></tr>'
		_ctabela+='</table>'
		_ctabela+='<br><br>'

		// Faturamento realizado
		_ctabela+='<table width="400" border="1" cellpadding="0" cellspacing="0" bordercolor="#111111" style="border-collapse: collapse">'
		_ctabela+='<tr>'
		_ctabela+='<td width="400" colspan=2 align="left"><font size="2" face="Arial, Helvetica, sans-serif">FATURAMENTO (entre '+dtoc(_dataini)+' e '+dtoc(date()-1)+')</font></td></tr>'

		while ! (tmp1)->(eof()) .and.;
			(tmp1)->vend1==_representante

			if alltrim((tmp1)->tabstatus)=="L" .and. (tmp1)->apreven=="1" // Licitação Farma
					_ctabela+='<tr>'
					_ctabela+='<td width="250" align="left"><font size="2" face="Arial, Helvetica, sans-serif">Licita&ccedil;&atilde;o Farma</font></td>'
					_ctabela+='<td width="150" align="right"><font size="2" face="Arial, Helvetica, sans-serif">'+alltrim(transform((tmp1)->total,"@E 999,999,999,999.99"))+'</font></td>'
					_total+=(tmp1)->total

			elseif alltrim((tmp1)->tabstatus)=="L" .and. (tmp1)->apreven=="2" //Licitação Hospitalar
					_ctabela+='<tr>'
					_ctabela+='<td width="250" align="left"><font size="2" face="Arial, Helvetica, sans-serif">Licita&ccedil;&atilde;o Hospitalar</font></td>'
					_ctabela+='<td width="150" align="right"><font size="2" face="Arial, Helvetica, sans-serif">'+alltrim(transform((tmp1)->total,"@E 999,999,999,999.99"))+'</font></td>'
					_total+=(tmp1)->total

			elseif alltrim((tmp1)->tabstatus)=="Z" // Zona Franca de Manaus
				_ctabela+='<tr>'
				_ctabela+='<td width="250" align="left"><font size="2" face="Arial, Helvetica, sans-serif">Zona Franca de Manaus</font></td>'
				_ctabela+='<td width="150" align="right"><font size="2" face="Arial, Helvetica, sans-serif">'+alltrim(transform((tmp1)->total,"@E 999,999,999,999.99"))+'</font></td>'
				_total+=(tmp1)->total

			elseif empty((tmp1)->tabstatus) .and. (tmp1)->apreven=="1" // Farma
				_ctabela+='<tr>'
				_ctabela+='<td width="250" align="left"><font size="2" face="Arial, Helvetica, sans-serif">Farma</font></td>'
				_ctabela+='<td width="150" align="right"><font size="2" face="Arial, Helvetica, sans-serif">'+alltrim(transform((tmp1)->total,"@E 999,999,999,999.99"))+'</font></td>'
				_total+=(tmp1)->total
            endif

			(tmp1)->(dbskip())
		end

		_ctabela+='<tr>'
		_ctabela+='<td width="250" align="left"><font size="2" face="Arial, Helvetica, sans-serif"><b>TOTAL</b></font></td>'
		_ctabela+='<td width="150" align="right"><font size="2" face="Arial, Helvetica, sans-serif"><b>'+alltrim(transform(_total,"@E 999,999,999,999.99"))+'</b></font></td>'

		_nrealiz:= _meta - _total

		if _nrealiz>0
			_ctabela+='<tr>'

			if day(date())==01
				_ctabela+='<td width="250" align="left"><font size="2" face="Arial, Helvetica, sans-serif"><b>N&Atilde;O REALIZADO</b></font></td>'
			else
				_ctabela+='<td width="250" align="left"><font size="2" face="Arial, Helvetica, sans-serif"><b>A REALIZAR</b></font></td>'
			endif
			_ctabela+='<td width="150" align="right"><font size="2" face="Arial, Helvetica, sans-serif"><b>'+alltrim(transform((_nrealiz),"@E 999,999,999,999.99"))+'</b></font></td></tr>'
		endif

		_ctabela+='</table>'
		_ctabela+='<br>'

		aadd((oHtml:valByName("TB.FAT")),_ctabela)


		_ctabela:='<table width="400" border="1" cellpadding="0" cellspacing="0" bordercolor="#111111" style="border-collapse: collapse">'

		_ctabela+='<tr>'
		_ctabela+='<td width="250" align="left"><font size="2" face="Arial, Helvetica, sans-serif"><b>Pend&ecirc;ncia em Carteira</b></font></td>'
		_ctabela+='<td width="150" align="right"><font size="2" face="Arial, Helvetica, sans-serif"><b>'+alltrim(transform((tmp2)->vlrpend,"@E 999,999,999,999.99"))+'</b></font></td></tr>'

		_ctabela+='</table>'
		_ctabela+='<br><br>'

		oHTML:ValByName("META"   ,_ctabela)

		_crodape:='<table width="600" border="0">'
		_crodape+='<tr><td>
		_crodape+='<font size="2" face="Arial, Helvetica, sans-serif"><p align="justify">Para maiores informa&ccedil;&otilde;es, '
		_crodape+='solicitamos entrar em contato com a ger&ecirc;ncia regional.<br>'
		_crodape+='Este &eacute; um e-mail autom&aacute;tico, favor n&atilde;o responder.</p><br><br>'
		_crodape+='Atenciosamente,<br><br>'
		_crodape+='Depto. Comercial<br>'
		_crodape+='<a href="mailto:sac@vitamedic.ind.br">sac@vitamedic.ind.br</a><br></font></td></tr></table>'

		oHTML:ValByName("RODAPE",_crodape)

		oProcess:cto := _cpara // PARA

		if !empty(_emailger)
			oProcess:ccc := alltrim(_emailger)+";report_comercial@vitamedic.ind.br;report_ti@vitamedic.ind.br" // COM COPIA
		else
			oProcess:ccc := "report_comercial@vitamedic.ind.br;report_ti@vitamedic.ind.br" // COM COPIA
		endif

		oProcess:cbcc:= "report_ti@vitamedic.ind.br" // COM COPIA OCULTA

		oProcess:UserSiga := "__cuserid"

		RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'100001')

		oProcess:Start()
		wfsendmail()
	endif

	(tmp2)->(dbclosearea())

end

(tmp1)->(dbclosearea())

//reset environment
return
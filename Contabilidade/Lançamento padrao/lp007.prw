/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LP007    ³Autor  ³Heraildo C. Freitas º Data ³  01/03/07   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Retorna a conta contabil de debito no lancamento           ³±±
±±³          ³ padronizado de requisicao                                  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Uso       ³ LP 666/001                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function lp007()
cCCAdm:= '28000000/28000001/28010004/28020000/28030002/29050100/29050102/29050105/29050106/29050107/29050108/29050109/29050110/29050111'
_cconta:="INDEFINIDO TM "+sd3->d3_tm

if substr(sd3->d3_cc,1,1)$"6" 
	_cconta:="1308010223907" 
elseif substr(sd3->d3_cc,1,1)$"7" 
	_cconta:="2101130111229" 
elseif Alltrim(sd3->d3_cc)="99999999" 
	_cconta:="1306010322332" 
elseif sd3->d3_tm$"111" // ENT.ESTOQUE REAGENTES
	_cconta:="3501029918608"	
elseif sd3->d3_tm$"106/501"                // BONIFICACAO
	if substr(sb1->b1_categ,1,1)=="N" // LISTA NEGATIVA
		_cconta:="3401010113101"
	else
		_cconta:="3401011113301"
	endif
elseif sd3->d3_tm$"103/109/502/509"            // REQ./DEV. MAT. CONSUMO// REQ./DEV.P/DESENVOLVIMENTO/CQ
	if !Alltrim(sd3->d3_cc)$cCCAdm .and. substr(sd3->d3_cc,1,2)$"28/29" // INDUSTRIA
		if empty(sb1->b1_ctacus)
			_cconta:="B1_CTACUS "+sb1->b1_cod
		else
			_cconta:=sb1->b1_ctacus
		endif
	elseif substr(sd3->d3_cc,1,2)$"23" // DESPESA COMERCIAL
		if empty(sb1->b1_ctacom)
			_cconta:="B1_CTACOM "+sb1->b1_cod
		else
			_cconta:=sb1->b1_ctacom
		endif
	else // DESPESA ADMINISTRATIVA
		if empty(sb1->b1_ctades)
			_cconta:="B1_CTADES "+sb1->b1_cod
		else
			_cconta:=sb1->b1_ctades
		endif
	endif
elseif sd3->d3_tm$"505"            // REQ. BRINDES
	if empty(sb1->b1_ctacom)
		_cconta:="B1_CTACOM "+sb1->b1_cod
	else
		_cconta:=sb1->b1_ctacom
	endif
	//_cconta:="4102020616603" // Alterado em 26/12/11 por solicitação contabilidade.
elseif sd3->d3_tm$"102/104/105/504/506/508"        // REQ./ENT. PI / SAIDA POR AJUSTE - inventario
	if sb1->b1_tipo$"PA/PL"
		_cconta:="4102029916707"
	elseif sb1->b1_tipo$"MP/EE/EN/PI" .and. sd3->d3_cc<>"22000000"
		_cconta:="3501010116104"
	else
		_cconta:="4101029913614"
	endif
elseif sd3->d3_tm$"507"          // ENC.P/DESTRUICAO
	_cconta:="ENC. P/ DESTRUICAO"
//elseif sd3->d3_tm$"109/509"          // REQ./DEV.P/DESENVOLVIMENTO/CQ
//  _cconta:="3501029918608"
//	  
elseif sd3->d3_tm$"107/511"          // REQ.MAT.COMUNICACAO
	_cconta:="4101010110104"
elseif sd3->d3_tm$"980"				 // BAIXA VALOR DE FRETE NF DEVOLUÇÃO
	_cconta:="3501029918607"
/*	if sb1->b1_tipo$"MP"
		_cconta:="3501010116101"
	elseif sb1->b1_tipo$"EE"
		_cconta:="3501010116102"
	elseif sb1->b1_tipo$"EN"
		_cconta:="3501010116103"
	else         
		_cconta:="3501010216204"
	endif
*/
elseif sd3->d3_doc<>'INVENT   ' .and. substr(sd3->d3_doc,1,3)=='INV' .and. sd3->d3_cc="29000000"
	_cconta:="3501029918622"
elseif sd3->d3_localiz='02PESAGEM' .and. !sd3->d3_cf$'RE4/DE4/RE6/DE6' .and. sd3->d3_tm$'499/999' .and. sd3->d3_cc="29000000"
	_cconta:="3501029918622"
elseif sd3->d3_localiz='02PESAGEM' .and. !sd3->d3_cf$'RE4/DE4/RE6/DE6' .and. sd3->d3_tm$'499/999' .and. sd3->d3_cc<>"29000000"
	_cconta:="3501029918608"	
elseif sd3->d3_tm$"510"          // REQ.MAT.EMBALAGEM REPROCESSO
	_cconta:="4101029913623" 
endif                                                                                                  
     

return(_cconta)

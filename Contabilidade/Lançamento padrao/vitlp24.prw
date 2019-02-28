/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VITLP24   ³Autor  ³Heraildo C. Freitas º Data ³  27/11/03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a conta contabil de credito no lancamento          ³±±
±±³          ³ padronizado de devolucao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ LP 668/001                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Alteracao ³ 08/03/04 - Revisao para novo plano de contas               ³±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/



#include "rwmake.ch"

user function vitlp24()
Local _aarea:= getarea()
_cconta:="INDEF.  TM "+sd3->d3_tm
dbselectarea("SZA")
DbsetOrder(1)
If  sza->(dbseek(xFilial("SZA")+SD3->D3_GRUPO+substr(SD3->D3_CC,1,2)+SD3->D3_TM))
	_cConta :=  if(Empty(SZA->ZA_CONTA),"CTA SEM SZA "+SD3->D3_GRUPO,SZA->ZA_CONTA)  
Else
	if sd3->d3_tm$"102" // ENT.PRODUTO ACABADO
		_cconta:="CTA.CUSTO GRUPO "+SD3->D3_GRUPO
	elseif sd3->d3_tm$"103" // DEV. MAT. CONSUMO
		if substr(sd3->d3_cc,1,2)=="29" .or. substr(sd3->d3_cc,1,2)=="28"
			if empty(sb1->b1_ctacus)
				_cconta:="CTA.CUSTO GRUPO "+SD3->D3_GRUPO
			else
				_cconta:=sb1->b1_ctacus
			endif
		else
			if empty(sb1->b1_ctades)
				_cconta:="CTA.DESP.GRUPO "+SD3->D3_GRUPO
			else
				_cconta:=sb1->b1_ctades
			endif
		endif
	elseif sd3->d3_tm$"104/102/105" // ENTRADA POR AJUSTE - inventario
		if sb1->b1_tipo=="PA"
			_cconta:="4102029916707"
		elseif sb1->b1_tipo$"MP/EE/EN/PI" .and. sd3->d3_cc <> "22000000"
			_cconta:="3501010116104"
		else
			_cconta:="4101029913614"
		endif
	elseif sd3->d3_tm=="109"          // REQ.P/DESENVOLVIMENTO/CQ
		_cconta:="3501029918608"
	elseif sd3->d3_tm$"110"                // DEV. OP / REEMBALAGEM
		if sb1->b1_tipo=="MP"
			_cconta:="3501010116101"
		elseif sb1->b1_tipo=="EE"
			_cconta:="3501010116102"
		elseif sb1->b1_tipo=="EN"
			_cconta:="3501010116103"
		endif
	elseif sd3->d3_tm$"111" // ENT.ESTOQUE REAGENTES
		_cconta:="3501029918608"
	endif
Endif 
restarea(_aarea)
return(_cconta)
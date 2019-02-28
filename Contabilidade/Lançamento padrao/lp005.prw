/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LP005      ³ Autor ³ Heraildo C. Freitas ³ Data ³ 14/02/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a Conta Contabil de Debito para o Lancamento Padrao³±±
±±³          ³ de Compra                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function lp005(_ntipo)
_cconta:="INDEFINIDO"
if sf4->f4_estoque=="S" .and.;
	substr(sb1->b1_conta,1,6)<>"110212" .and.;
	sb1->b1_tipo<>"IN"
	
	_cconta:="ATUALIZA ESTOQUE"
elseif sf4->f4_estoque=="N"
	if _ntipo==2 // DEVOLUCAO DE COMPRA
		_aareasd1:=sd1->(getarea())
		
		_cfilsd1:=xfilial("SD1")
		
		sd1->(dbsetorder(1))
		sd1->(dbseek(_cfilsd1+sd2->d2_nfori+sd2->d2_seriori+sd2->d2_cliente+sd2->d2_local+sd2->d2_cod+sd2->d2_itemori))
	endif
	
	if substr(sd1->d1_cc,1,2)$"28/29"
		if empty(sb1->b1_ctacus)
			_cconta:="B1_CTACUS "+sb1->b1_cod
		else
			_cconta:=sb1->b1_ctacus
		endif
	elseif substr(sd1->d1_cc,1,2)$"20/21/22/24"
		if empty(sb1->b1_ctades)
			_cconta:="B1_CTADES "+sb1->b1_cod
		else
			_cconta:=sb1->b1_ctades
		endif
	elseif substr(sd1->d1_cc,1,2)$"23"
		if empty(sb1->b1_ctacom)
			_cconta:="B1_CTACOM "+sb1->b1_cod
		else
			_cconta:=sb1->b1_ctacom
		endif
	elseif substr(sd1->d1_cc,1,2)$"99"
		if empty(sb1->b1_conta)
			_cconta:="B1_CONTA "+sb1->b1_cod
		else
			_cconta:=sb1->b1_conta
		endif 
	elseif substr(sd1->d1_cc,1,1)$"7"  //Projetos
	    _cconta:="4101029913623"
	else	
		_cconta:="INDEFINIDO"
	endif
	
	if substr(_cconta,1,6)=="110212"
		_cconta:="NAO ATUALIZA ESTOQUE"
	endif
	
	if _ntipo==2 // DEVOLUCAO DE COMPRA
		sd1->(restarea(_aareasd1))
	endif
elseif empty(sb1->b1_conta)
	_cconta:="B1_CONTA "+sb1->b1_cod
else
	_cconta:=sb1->b1_conta
endif
return(_cconta)

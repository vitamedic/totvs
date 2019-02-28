/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LP004      ³ Autor ³ Heraildo C. Freitas ³ Data ³ 14/02/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna a Conta Contabil de Receita para o Lancamento      ³±±
±±³          ³ Padrao de Venda                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function lp004()
_cconta:="INDEFINIDO"
if sb1->b1_tipo=="PT"            // VENDA DE IMOBILIZADO
	_cconta:="4105010119102"
elseif (sb1->b1_tipo=="PA") .or. (sb1->b1_tipo=="PL")    // VENDA DE PRODUTO ACABADO
	if (left(sb1->b1_categ,1))=="N" .and. (left(sa1->a1_calcsuf,1))<>"S" .and. (left(sa1->a1_calcsuf,1))<>"I" // LISTA NEGATIVA E NAO E ZONA FRANCA
		if sa1->a1_tpemp$"MEF" .and. sa1->a1_est<>"GO"   // ORGAO PUBLICO INTERESTADUAL
			_cconta:="3101010110106"
		else
			_cconta:="3101010110101"
		endif
	elseif sa1->a1_tpemp$"MEF" .and. sa1->a1_est<>"GO"  // LISTA POSITIVA / ORGAO PUBLICO INTERESTADUAL
		_cconta:="3101010110107"
	elseif (left(sa1->a1_calcsuf,1))=="S" .or. (left(sa1->a1_calcsuf,1))=="I"
		_cconta:="3101010110108" // QUANDO FOR ZONA FRANCA
	else                         // LISTA POSITIVA
		_cconta:="3101010110102"
	endif
elseif sb1->b1_tipo=="IN"        // SERVICO DE INDUSTRIALIZACAO
	_cconta:="3101010210202"
elseif sb1->b1_tipo$"MP/EE/EN"   // VENDA DE MATERIA PRIMA OU EMBALAGEM
	_cconta:="3101010310301"
elseif sb1->b1_tipo=="PD"   // VENDA DE DERMOCOSMETICOS
	_cconta:="3101010410402"
elseif sb1->b1_tipo=="PM"   // VENDA DE PRODUTOS PARA SAUDE
	_cconta:="3101010310302"
elseif sb1->b1_tipo=="PN"   // VENDA DE PRODUTOS NUTRACEUTICOS
	_cconta:="3101010410401"
else                             // VENDA DE MATERIAIS
	_cconta:="INDEFINIDO"
endif
return(_cconta)

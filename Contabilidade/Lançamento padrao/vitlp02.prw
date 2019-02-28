/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITLP02  ³ Autor ³ Heraildo C. de Freitas³ Data ³16/04/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa para retornar a conta contabil de credito no      ³±±
±±³          ³ lancamento padronizado 650/01 na entrada de notas fiscais  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³ 08/03/04 - Revisao para novo plano de contas               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vitlp02()
_cconta:="INDEFINIDO"
if sf4->f4_tpmov=="8" // REMESSA PARA EMPRESTIMO
	_cconta:="2301010121223"
elseif sf4->f4_tpmov=="C" // RETORNO DE EMPRESTIMO
	_cconta:="1102130112901"
elseif sf4->f4_tpmov=="I" // REMESSA PARA INDUSTRIALIZACAO
	_cconta:="2301010221323"
elseif sf4->f4_tpmov=="J" // RETORNO DE INDUSTRIALIZACAO
	_cconta:="1401020525501"
elseif sf4->f4_tpmov=="A" // REMESSA PARA CONSERTO - DIVERSOS
	_cconta:="2301010321423"
elseif sf4->f4_tpmov=="E" // RETORNO DE CONSERTO
	_cconta:="1401020225201"
elseif sf4->f4_tpmov=="K" // REMESSA PARA DEMONSTRACAO
	_cconta:="2301010521623"
elseif sf4->f4_tpmov=="N" // RETORNO DE DEMONSTRACAO
	_cconta:="1401020425401"
elseif sf4->f4_tpmov=="2" // RETORNO DE EXPOSICAO
	_cconta:="1401020625601"
elseif sf4->f4_tpmov=="6" // RETORNO DE CONSERTO ME/MP
	_cconta:="1102130314102"
elseif sf4->f4_tpmov=="3" // AMOSTRA GRATIS
	_cconta:="4102020616604"
elseif sf4->f4_tpmov=="5" // SIMPLES REMESSA
	_cconta:="4102020616604"
elseif sf4->f4_tpmov=="7" // RETORNO DE INDUSTRIALIZACAO (OPERACAO TRIANGULAR)
	_cconta:="1401020525501"                                     
elseif sf4->f4_tpmov=="9" // COMPRA PARA ENTREGA FUTURA--PA 
	_cconta:="1102140617101"
elseif sf4->f4_tpmov=="L" // ENTRADA DE BEM COMODATO       
	_cconta:="2301010421523"
elseif sf4->f4_tpmov=="M" // RETORNO DE BEM COMODATO       
	_cconta:="1401020325301"
elseif sd1->d1_tipo=="D" // DEVOLUCAO
	if sf4->f4_duplic=="S" // DEVOLUCAO DE VENDA
		if empty(sa1->a1_conta)
			_cconta:="CONTA CLIENTE BRANCO"
		else
			_cconta:=sa1->a1_conta
		endif
	endif
elseif sf4->f4_duplic=="S" // GERA DUPLICATA
	if empty(sa2->a2_conta)
		_cconta:="CONTA FORNEC BRANCO"
	else
		_cconta:=sa2->a2_conta
	endif
endif
return(_cconta)

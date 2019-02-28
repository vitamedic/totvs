/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITLP01  ³ Autor ³ Heraildo C. de Freitas³ Data ³16/04/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa para retornar a conta contabil de debito no       ³±±
±±³          ³ lancamento padronizado 650/01 na entrada de notas fiscais  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³ 08/03/04 - Revisao para novo plano de contas               ³±±
±±³          ³ 27/05/04 - Tratar conta de produtos sem estoque            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

#include "rwmake.ch"

user function vitlp01()
Local _aarea:= getarea()
dbselectarea("SZA")
DbsetOrder(1)
_cconta:="INDEFINIDO"
if sf4->f4_atuatf=="S" //Ativo Fixo a Classificar
	_cconta:="1306010422401"
elseif sf4->f4_tpmov=="8" // REMESSA PARA EMPRESTIMO
   _cconta:=If(Empty(sb1->b1_conta),"Conta Prod Branco",sb1->b1_conta)
elseif sf4->f4_tpmov=="C" // RETORNO DE EMPRESTIMO
   _cconta:=If(Empty(sb1->b1_conta),"Conta Prod Branco",sb1->b1_conta)
elseif sf4->f4_tpmov=="I" // REMESSA PARA INDUSTRIALIZACAO
	_cconta:="1401010224201"
elseif sf4->f4_tpmov=="J" // RETORNO DE INDUSTRIALIZACAO
	_cconta:="2301020522600"
elseif sf4->f4_tpmov=="A" // REMESSA PARA CONSERTO -- diversos
	_cconta:="1401010324301"
elseif sf4->f4_tpmov=="E" // RETORNO DE CONSERTO
	_cconta:="2301020222323"
elseif sf4->f4_tpmov=="K" // REMESSA PARA DEMONSTRACAO
	_cconta:="1401010524501"
elseif sf4->f4_tpmov=="N" // RETORNO DE DEMONSTRACAO
	_cconta:="2301020422523"
elseif sf4->f4_tpmov=="2" // RETORNO DE EXPOSICAO
	_cconta:="2301020622700"
elseif sf4->f4_tpmov=="6" // RETORNO DE CONSERTO ME/MP
   _cconta:=If(Empty(sb1->b1_conta),"Conta Prod Branco",sb1->b1_conta)
elseif sf4->f4_tpmov=="H" .and. sf4->f4_estoque=="S"// COMPRA ME/MP-OPERACAO TRIANGULAR
	_cconta:="1401020525501"
elseif sf4->f4_tpmov=="H" .and. sf4->f4_estoque=="N"// COMPRA ME/MP-OPERACAO TRIANGULAR
	_cconta:="3401010213203"
elseif sf4->f4_tpmov="L" // ENTRADA DE BEM COMODATO           
	_cconta:="1401010424401"
elseif sf4->f4_tpmov="M" // RETORNO DE BEM COMODATO           
	_cconta:="2301020322423"
elseif sf4->f4_tpmov=="D" // SIMPLES FATURAMENTO - PAGAMENTO ANTECIPADO
	_cconta:="1102140617101"
elseif sf4->f4_tpmov=="Q" // FRETE S/ ATIVO FIXO                       
		if substr(sd1->d1_cc,1,2)=="29" .or. substr(sd1->d1_cc,1,2)=="28"   //industria
	      _cconta:="3501029918607"
      ElseIf substr(sd1->d1_cc,1,2)$"20_21_22_24"  //Administrativo
	      _cconta:="4101029913607"
      ElseIf substr(sd1->d1_cc,1,2)=="23"  //Comercial     
	      _cconta:="4102029916712"			                                 
		Else 
			_cconta:="TP MOV  "+SF4->F4_TPMOV
		Endif
elseif sd1->d1_tipo=="D" // DEVOLUCAO
	if sf4->f4_duplic=="S" // DEVOLUCAO DE VENDA
		if sb1->b1_tipo=="PA" // PRODUTO ACABADO
			if left(sb1->b1_categ,1)=="N" .and. da0->da0_status<>"Z" // LISTA NEGATIVA E NÃO É ZONA FRANCA
				_cconta:="3102040111101"
			else // LISTA POSITIVA
				_cconta:="3102040111102"
			endif
		else
			_cconta:="3102040311301"
		endif
	endif
elseif sf4->f4_estoque=="S" .and.;
	left(sb1->b1_conta,6)<>"110212" .and.;
	sb1->b1_tipo<>"IN"
	_cconta:="ATUALIZA ESTOQUE"
elseif sf4->f4_estoque=="N" 
    //.and. left(sb1->b1_conta,6)=="110212"
    If  sza->(dbseek(xFilial("SZA")+SB1->B1_GRUPO+substr(SD1->D1_CC,1,2)+"502"))
	     _cConta:=  if(Empty(SZA->ZA_CONTA),"CTA SEM SZA "+SD3->D3_GRUPO,SZA->ZA_CONTA)  
	 Else
		if substr(sd1->d1_cc,1,2)=="29" .or. substr(sd1->d1_cc,1,2)=="28"
			if empty(sb1->b1_ctacus)
				_cconta:="CTA.CUS PROD  "+SD1->D1_COD  
			else
				_cconta:=sb1->b1_ctacus
			endif
		else
			if empty(sb1->b1_ctades)
				_cconta:="CTA.CUS PROD  "+SD1->D1_COD  
			else
				_cconta:=sb1->b1_ctades
			endif
		endif
	Endif
elseif empty(sb1->b1_conta)
	_cconta:="CONTA PRODUTO BRANCO"
else
	_cconta:=sb1->b1_conta
endif
restarea(_aarea)
return(_cconta)
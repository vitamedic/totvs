#INCLUDE "Protheus.ch" 
#include "rwmake.ch" 
#INCLUDE "topconn.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao	 � M330FCC    � Autor � Heraildo C. Freitas � Data � 04/12/03   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de entrada para filtrar as contas a serem            潮�
北�          � consideradas para calculo da mao de obra no recalculo do   潮�
北�          � custo medio                                                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function m330fcc()
_calias:=paramixb
if _calias=="CQ3" 
	// Marcio David alterado em 04/07/2018 onde esta CQ3 estava CT2 tabela essa descontinuada no protheus 12            
	_cfiltro:="(CQ3.CQ3_CONTA BETWEEN '35010103' AND '35010103ZZZZZ' OR "+; //Mao de Obra
	          " CQ3.CQ3_CONTA BETWEEN '35020103' AND '35020103ZZZZZ' OR "+; //Mao de Obra
	          " CQ3.CQ3_CONTA BETWEEN '350102'   AND '350102ZZZZZZZ' OR "+; //GGF
	          " CQ3.CQ3_CONTA BETWEEN '35010102' AND '35010102ZZZZZ' OR "+; //Materiais Improdutivos 
  	          " CQ3.CQ3_CONTA BETWEEN '35010101' AND '35010101ZZZZZ' OR "+; //Materiais Produtivos  
	          " CQ3.CQ3_CONTA BETWEEN '35020101' AND '35020101ZZZZZ' OR "+; //Materiais Produtivos  
	          " CQ3.CQ3_CONTA BETWEEN '35020102' AND '35020102ZZZZZ' OR "+; //Materiais Improdutivos
	          " CQ3.CQ3_CONTA BETWEEN '350198'   AND '350198ZZZZZZZ' OR "+; //Recupera玢o de Custos 
	          " CQ3.CQ3_CONTA BETWEEN '350202'   AND '350202ZZZZZZZ')"      //GGF
else     
	// Marcio David alterado em 04/07/2018 onde esta CQ3 estava CT3 tabela essa descontinuada no protheus 12
	_cfiltro:="(CQ3.CQ3_CONTA BETWEEN '35010103' AND '35010103ZZZZZ' OR "+; //Mao de Obra
	          " CQ3.CQ3_CONTA BETWEEN '35020103' AND '35020103ZZZZZ' OR "+; //Mao de Obra
	          " CQ3.CQ3_CONTA BETWEEN '350102'   AND '350102ZZZZZZZ' OR "+; //GGF
	          " CQ3.CQ3_CONTA BETWEEN '35010102' AND '35010102ZZZZZ' OR "+; //Materiais Improdutivos 
	          " CQ3.CQ3_CONTA BETWEEN '35010101' AND '35010101ZZZZZ' OR "+; //Materiais Produtivos  
	          " CQ3.CQ3_CONTA BETWEEN '35020101' AND '35020101ZZZZZ' OR "+; //Materiais Produtivos  
	          " CQ3.CQ3_CONTA BETWEEN '35020102' AND '35020102ZZZZZ' OR "+; //Materiais Improdutivos
	          " CQ3.CQ3_CONTA BETWEEN '350198'   AND '350198ZZZZZZZ' OR "+; //Recupera玢o de Custos
	          " CQ3.CQ3_CONTA BETWEEN '350202'   AND '350202ZZZZZZZ')"      //GGF
endif   
return(_cfiltro) 

#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} A410CONS

SERVE P/INCLUIR BOTOES NA ENCHOICEBAR
� chamada no momento de montar a enchoicebar do 
pedido de vendas, e serve para incluir mais 
bot�es com rotinas de usu�rio.

@author gsamp
@since 12/07/2017
@version undefined

@type function
/*/
user function A410CONS()

	Local aMyButtons	:= {}
	
	Aadd(aMyButtons , {"VOLINC" ,{|| U_VIT628() },"Volumes Incompletos","Volumes Incompletos"} )
	
return ( aMyButtons )
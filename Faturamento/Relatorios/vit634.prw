#Include 'Protheus.ch'
#Include "Protheus.ch"
#INCLUDE "rwmake.ch"
#Include "ApWizard.ch"
#Include "Topconn.ch"            
#include "dialog.ch"
#include "topconn.ch"

/*/{Protheus.doc} vit365
	Impressao de Etiquetas de Volumes - Faturamento 
@author Alex Junio de Miranda
@since 14/06/11
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function vit634()
Local _cQuery := ""
Local _cporta  :="LPT1" 
     

if MsgYesNo("Deseja Imprimir a Etiqueta para Mala Direta?","ATENCAO","YESNO")

_cQuery := "SELECT A1_NOME NOME, A1_END ENDE,A1_BAIRRO BAIRRO, A1_MUN MUN, A1_EST ESTADO,A1_CEP CEP"  
_cQuery += " FROM SA1010 SA1"
_cQuery += " WHERE SA1.D_E_L_E_T_ = ' '"
_cQuery += " AND A1_ULTCOM >= '20170901'"
_cQuery += " AND A1_TIPOESP NOT IN ('G','O','P')"
//_cQuery += " AND ROWnum = 1 "

_cQuery := ChangeQuery(_cQuery)
TcQuery _cQuery New Alias "TMP1"
MemoWrite("C:\temp\mt100tok2.SQL",_cQuery)  
    
TMP1->( DbGotop() )
	       	
	mscbprinter("S600",_cporta,,62,.F.,,,,10240)
	mscbchkstatus(.f.)
while !tmp1->(eof())
		mscbbegin(1,6) 
			mscbsay(009,010,"Destinatario: ","N","0","050,035") // CODIGO DO CLIENTE/FORNECEDOR                                                                 
			mscbsay(009,018,tmp1->nome,"N","0","050,028") // NOME CLIENTE
			mscbsay(009,026,"End: " +tmp1->ende,"N","0","050,028") // ENDERECO CLIENTE
			mscbsay(009,033,"Bairro: "+ tmp1->BAIRRO,"N","0","050,028") // CIDADE
			mscbsay(009,040,"Cidade: "+ ALLTRIM(tmp1->MUN) + "-" + ALLTRIM(TMP1->ESTADO),"N","0","050,028") // CIDADE
			mscbsay(009,047,"Cep: "+Trans(TMP1->CEP,"@R 99999-999"),"N","0","050,028") // CEP
//			mscbsay(009,047,"Remetente: ","N","0","050,035") // Remetente
//			mscbsay(009,055,"VITAMEDIC IND. FARMACEUTICA LTDA","N","0","050,028") // TRANSPORTADORA
	
		mscbend()		
tmp1->(DbSkip())
end				
	mscbcloseprinter()	
	
Else
	Return
EndIf

Return


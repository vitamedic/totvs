#Include "PROTHEUS.CH"
#include "topconn.ch"   
#INCLUDE 'FWMVCDEF.CH' 

/*/{Protheus.doc} VIT018
	Cadastro de Fabricantes 
@author Henrique Correa
@since 23/06/2017
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function VIT018()
             
Local oBrowse
Private aRotina := {}

// crio o objeto do Browser
oBrowse := FWmBrowse():New()

// defino o Alias
oBrowse:SetAlias("Z55")

// informo a descri็ใo
oBrowse:SetDescription("Cadastro de Fabricantes")  

// crio as legendas 
oBrowse:AddLegend("Z55_STATUS == 'A'", "GREEN"	,	"Ativo")
oBrowse:AddLegend("Z55_STATUS == 'I'", "RED"	,	"Inativo")  

// ativo o browser
oBrowse:Activate()

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MenuDef บ Autor ณ Henrique Correa บ Data ณ 23/06/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que cria os menus									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Vitamedic                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MenuDef() 

Local aRotina := {}

ADD OPTION aRotina Title 'Pesquisar'   	Action 'PesqBrw'          	OPERATION 01 ACCESS 0
ADD OPTION aRotina Title 'Visualizar'  	Action 'VIEWDEF.VIT618' 	OPERATION 02 ACCESS 0
ADD OPTION aRotina Title 'Incluir'     	Action 'VIEWDEF.VIT618' 	OPERATION 03 ACCESS 0
ADD OPTION aRotina Title 'Alterar'     	Action 'VIEWDEF.VIT618' 	OPERATION 04 ACCESS 0
ADD OPTION aRotina Title 'Excluir'     	Action 'VIEWDEF.VIT618' 	OPERATION 05 ACCESS 0
ADD OPTION aRotina Title 'Imprimir'    	Action 'VIEWDEF.VIT618' 	OPERATION 08 ACCESS 0
ADD OPTION aRotina Title 'Copiar'      	Action 'VIEWDEF.VIT618' 	OPERATION 09 ACCESS 0  
ADD OPTION aRotina Title 'Legenda'     	Action 'U_VIT618L()'  		OPERATION 10 ACCESS 0    
ADD OPTION aRotina Title 'Importar'    	Action 'U_UCOM019()'  		OPERATION 11 ACCESS 0    

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ModelDef บ Autor ณ Henrique Correa บ Data ณ23/06/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que cria o objeto model							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Vitamedic                       		                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ModelDef()

Local oStruCab := FWFormStruct( 1, 'Z55', { |x| ALLTRIM(x) $ 'Z55_CODIGO, Z55_NOME' }, /*lViewUsado*/ )
Local oStruItm := FWFormStruct( 1, 'Z55', { |x| ! ALLTRIM(x) $ 'Z55_CODIGO, Z55_NOME' }, /*lViewUsado*/ ) 
//Local oStruU25 := FWFormStruct( 1, 'U25', /*bAvalCampo*/, /*lViewUsado*/ ) 
Local oModel

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'PCOM018', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

/////////////////////////  CABEวALHO - DADOS DO LAYOUT  ////////////////////////////

// Crio a Enchoice
oModel:AddFields( 'Z55MASTER', /*cOwner*/, oStruCab )

// Adiciona a chave primaria da tabela principal
oModel:SetPrimaryKey({ "Z55_FILIAL" , "Z55_CODIGO" })    

// Preencho a descri็ใo da entidade
oModel:GetModel('Z55MASTER'):SetDescription('Dados do Fornecedor:')

///////////////////////////  ITENS - CAMPOS DO PROSPECT  //////////////////////////////

// Crio a segunda Enchoice com o resto dos campos
oModel:AddField( 'Z55DETAIL', 'Z55MASTER', oStruItm, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )    

// Fa็o o relaciomaneto entre o cabe็alho e os itens
oModel:SetRelation( 'Z55DETAIL', { { 'Z55_FILIAL', 'xFilial( "Z55" )' } , { 'Z55_CODIGO', 'Z55_CODIGO' } } , U24->(IndexKey(1)) )  

// Seto a propriedade de nใo obrigatoriedade do preenchimento do grid
oModel:GetModel('Z55DETAIL'):SetOptional( .F. )     

// Preencho a descri็ใo da entidade
oModel:GetModel('Z55DETAIL'):SetDescription('Certificados:')      

// ///////////////////////////  ITENS - CAMPOS DA OAB  //////////////////////////////

// // Crio o grid
// oModel:AddGrid( 'U25DETAIL', 'Z55MASTER', oStruU25, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )    

// // Fa็o o relaciomaneto entre o cabe็alho e os itens
// oModel:SetRelation( 'U25DETAIL', { { 'U25_FILIAL', 'xFilial( "U25" )' } , { 'U25_CODIGO', 'Z55_CODIGO' } } , U25->(IndexKey(1)) )  

// // Seto a propriedade de nใo obrigatoriedade do preenchimento do grid
// oModel:GetModel('U25DETAIL'):SetOptional( .T. )     

// // Preencho a descri็ใo da entidade
// oModel:GetModel('U25DETAIL'):SetDescription('Detalhamento da OAB:') 

Return(oModel)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ViewDef บ Autor ณ Henrique Correa บ Data ณ 23/06/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que cria o objeto View							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Vitamedic                                           	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ViewDef()

Local oStruCab 	:= FWFormStruct(2,'Z55', { |x| ALLTRIM(x) $ 'Z55_CODIGO, Z55_NOME' })
Local oStruItm 	:= FWFormStruct(2,'Z55', { |x| ! ALLTRIM(x) $ 'Z55_CODIGO, Z55_NOME' }) 
// Local oStruU25 	:= FWFormStruct(2,'U25') 
Local oModel   	:= FWLoadModel('VIT618')
Local oView

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados serแ utilizado
oView:SetModel(oModel)

oView:AddField('VIEW_Z55C'	, oStruCab, 'Z55MASTER') // cria o cabe็alho
oView:AddField('VIEW_Z55I'	, oStruItm, 'Z55DETAIL') // Cria o grid
// oView:AddGrid('VIEW_U25'	, oStruU25, 'U25DETAIL') // Cria o grid

// Crio os Panel's horizontais 
oView:CreateHorizontalBox('PANEL_CABECALHO' , 30)
oView:CreateHorizontalBox('PANEL_ITENS'		, 70) 

// oView:CreateVerticalBox( 'ESQUERDA'		, 49 , 'PANEL_ITENS' )
// oView:CreateVerticalBox( 'SEPARADOR1'	, 02 , 'PANEL_ITENS' )
// oView:CreateVerticalBox( 'DIREITA'		, 49 , 'PANEL_ITENS' )   

// Relaciona o ID da View com os panel's
oView:SetOwnerView('VIEW_Z55C' , 'PANEL_CABECALHO')
oView:SetOwnerView('VIEW_Z55I' , 'PANEL_ITENS')  
// oView:SetOwnerView('VIEW_U25' , 'DIREITA')   

// Ligo a identificacao do componente
oView:EnableTitleView('VIEW_Z55C')
oView:EnableTitleView('VIEW_Z55I') 
// oView:EnableTitleView('VIEW_U25') 

// Define fechamento da tela ao confirmar a opera็ใo
oView:SetCloseOnOk({||.T.})

Return(oView)                         

/*/{Protheus.doc} VIT618L
	Legenda do browser
@author Henrique Correa
@since 23/06/2017
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function VIT618L()

BrwLegenda("Status do Layout","Legenda",{ {"BR_VERDE","Ativo"},{"BR_VERMELHO","Inativo"} })  

Return()                     
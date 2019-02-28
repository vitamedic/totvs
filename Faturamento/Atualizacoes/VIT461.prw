#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"

#DEFINE MODEL_OPERATION_VIEW 2
#DEFINE MODEL_OPERATION_INSERT 3
#DEFINE MODEL_OPERATION_UPDATE 4
#DEFINE MODEL_OPERATION_DELETE 5
#DEFINE MODEL_OPERATION_COPY 9
#DEFINE MODEL_OPERATION_IMPR 8

user function VIT461()

	Local aArea := GetArea()
	Local oBrowse:= FWMBrowse():New()
	Private cTitulo		:= OemtoAnsi("Preço por Produto")

	oBrowse:SetAlias("Z28") 
	oBrowse:AddLegend("Z28_STATUS == '1'","BR_VERDE","Ativa")
	oBrowse:AddLegend("Z28_STATUS == '2'","BR_VERMELHO","Inativa")
	oBrowse:SetDescription(cTitulo)
	oBrowse:Activate()
	oBrowse:SetMenuDef("VIT461")

Return

//-------------------------------------------------------------------
// Montar o menu Funcional
//-------------------------------------------------------------------
Static Function MenuDef()

	Local aRotina := {}
	ADD OPTION aRotina Title "Visualizar"			ACTION "VIEWDEF.VIT461"               OPERATION MODEL_OPERATION_VIEW		ACCESS 0
	ADD OPTION aRotina Title "Incluir" 				ACTION "VIEWDEF.VIT461"               OPERATION MODEL_OPERATION_INSERT		ACCESS 0
	ADD OPTION aRotina Title "Alterar" 				ACTION "VIEWDEF.VIT461"               OPERATION MODEL_OPERATION_UPDATE		ACCESS 0
	ADD OPTION aRotina Title "Excluir" 				ACTION "VIEWDEF.VIT461"               OPERATION MODEL_OPERATION_DELETE 		ACCESS 0
	ADD OPTION aRotina Title "Imprimir" 			ACTION "VIEWDEF.VIT461"               OPERATION MODEL_OPERATION_IMPR		ACCESS 0
	ADD OPTION aRotina Title "Copiar" 				ACTION "VIEWDEF.VIT461"               OPERATION MODEL_OPERATION_COPY	 	ACCESS 0	

Return aRotina

//-------------------------------------------------------------------
// Montar o 
//-------------------------------------------------------------------
Static Function ModelDef()

	Local oStr1:= FWFormModelStruct():New()//FWFormStruct( 1,"Z28") // Construção de uma estrutura de dados
	Local oModel:= MPFormModel():New("vit461m")//:= Nil
	
/*	oStr1:AddTable("   ",{" "}," ")
	oStr1:AddField("Descricao",;								// 	[01]  C   Titulo do campo
					 "Descricao",;								// 	[02]  C   ToolTip do campo
					 "Z28_DESCRI",;								// 	[03]  C   Id do Field
					 "C",;										// 	[04]  C   Tipo do campo
					 40,;										// 	[05]  N   Tamanho do campo
					 0,;										// 	[06]  N   Decimal do campo
					 Nil,;								    	// 	[07]  B   Code-block de validação do campo
					 Nil,;										// 	[08]  B   Code-block de validação When do campo
					 NIL,;										//	[09]  A   Lista de valores permitido do campo
					 .F.,;										//	[10]  L   Indica se o campo tem preenchimento obrigatório
					 NIL,;										//	[11]  B   Code-block de inicializacao do campo
					 .F.,;										//	[12]  L   Indica se trata-se de um campo chave
					 .T.,;										//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
					 .T.)										// 	[14]  L   Indica se o campo é virtual
*/					 										
	oStr1:= FWFormStruct( 1,"Z28")				 	
	oModel:addFields("M_Z28",/*cOwner*/,oStr1)
	oModel:SetPrimaryKey({"Z28_FILIAL","Z28_PROD"})
	oModel:getModel("M_Z28"):SetDescription (OemtoAnsi("Preço por Produto"))

Return oModel

//-------------------------------------------------------------------
// Montar o 
//-------------------------------------------------------------------
Static Function ViewDef()

	Local oModel := FWLoadModel("Vit461")
	Local oStr1 := FWFormViewStruct():New()
	Local oView := Nil
	Local cprod 
    
    oStr1:= FWFormStruct(2,"Z28")
/*    cprod := POSICIONE("SB1", 1, xFilial("SB1") + Z28_PROD, "B1_DESC")
    oStr1:AddField(	"Z28_DESCRI",;						// [01]  C   Nome do Campo
					"02",;							// [02]  C   Ordem
					"Descricao",;					// [03]  C   Titulo do campo	//"Parcela"
					"Descricao",;					// [04]  C   Descricao do campo	//"Parcela do Cronograma"
					"Descricao do Produto",;		// [05]  A   Array com Help
					"C",;							// [06]  C   Tipo do campo
					"@!",;							// [07]  C   Picture
					NIL,;							// [08]  B   Bloco de Picture Var
					NIL,;							// [09]  C   Consulta F3
					.T.,;							// [10]  L   Indica se o campo é alteravel
					NIL,;							// [11]  C   Pasta do campo
					NIL,;							// [12]  C   Agrupamento do campo
					NIL,;							// [13]  A   Lista de valores permitido do campo (Combo)
					NIL,;							// [14]  N   Tamanho maximo da maior opção do combo
					"teste",;							// [15]  C   Inicializador de Browse
					.T.,;							// [16]  L   Indica se o campo é virtual
					NIL,;							// [17]  C   Picture Variavel
					NIL)							// [18]  L   Indica pulo de linha após o campo
					*/
	oView:= FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("V_Z28", oStr1,"M_Z28"/*{|oModel| PreValida(oModel)}*/,/*{|oView| PosValida(oView)}*/ )
	oView:CreateHorizontalBox( "PAI", 100)
	oView:SetOwnerView("V_Z28","PAI")
	oView:EnableTitleView("V_Z28","Cadastro de Competencias")

Return oView

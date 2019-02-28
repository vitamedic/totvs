/*/{Protheus.doc} MA410COR
	Este ponto de entrada pertence à rotina de Pedidos de Venda, MATA410(). Usado, 
	em conjunto com o ponto MA410LEG, para alterar cores do “browse” do cadastro, 
	que representam o “status” do pedido.
@author Vitamedic
@since 28/05/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function MA410COR()
Local i
aCores := PARAMIXB           

if ( i := AScan(aCores, {|x| x[2] == 'BR_AMARELO'}) ) > 0
	aCores[i,1] := "(!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)) .Or. C5_XEMP='S'"
endif

Return(aCores)
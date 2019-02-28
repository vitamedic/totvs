#INCLUDE "PROTHEUS.CH"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ MT680GD3 ¦ Autor ¦ Claudio Ferreira      ¦ Data ¦ 16.02.17 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de entrada para alterar o Local da Perda para o      ¦¦¦
¦¦¦          ¦ Local padrão do produto produzido                          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Vitamedic                                                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
//Ponto de entrada criado para evitar residuos no CQ
User Function MT680GD3 
Local nRegD3 := SD3->(Recno())
if SD3->D3_CF=="PR0" .AND. SD3->D3_QUANT==0  //Ser apontamento só de perda, altera o local para o padrão da OP
	RecLock("SD3",.F.)
	Replace D3_LOCAL  With SC2->C2_LOCAL
	MsUnLock()
endif
SD3->(DbGoto(nRegD3))//Restaura D3 original
Return


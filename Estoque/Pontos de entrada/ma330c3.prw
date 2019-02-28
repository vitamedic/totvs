#INCLUDE "Protheus.ch" 
#include "rwmake.ch" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � MA330C3    � Autor � Claudio Ferreira    � Data � 19/08/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para valorizar o custo das DE0            ���
���            com estoque zerado na virada do m�s                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Especifico para VITAPAN at� resposta chamado THSDSP        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA330C3() 
Local aCusto := PARAMIXB
Local nValor := 0
If SD3->D3_CF = "DE0" .and. SD3->D3_CUSTO1=0
  nValor:=Posicione('SB2',1,xFilial('SB2')+SD3->(D3_COD+D3_LOCAL),'B2_CMFIM1')
  if nValor>0

	For ni:=1 to Len(aCusto)
		aCusto[ni]:= aCusto[ni] / SD3->D3_QUANT
	Next ni
  
    aCusto[1]:=nValor 

    GravaCusD3(aCusto,,,"330")
    For ni:=1 to Len(aCusto)
	  aCusto[ni]:= aCusto[ni] * SD3->D3_QUANT
    Next ni
    
  endif
EndIf	


Return aCusto

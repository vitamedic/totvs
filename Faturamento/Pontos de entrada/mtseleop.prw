/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MTSELEOP  �Autor  �Andr� Almeida Alves    � Data � 06/03/12���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para n�o Abilitar a Escolha de Opcional   ���
���          � na Digita��o do Pedido de Vendas.                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#include "topconn.ch"

User function MTSELEOP()

Local cRet 	 := ParamIxb[1]  //Conte�do a ser colocado no campo _OPC
Local cProd  := ParamIxb[2]  // C�digo do produto que est� sendo utilizado
Local cProg  := ParamIxb[3]  // Nome do programa que chamou a fun��o
Local lRet   := .T.

if cProg $ "MATA410"
	lRet := .f.
endif

Return lRet
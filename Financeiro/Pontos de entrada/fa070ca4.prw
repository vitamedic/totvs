/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ�
���Programa  � FA070CA4 � Autor � Heraildo C. de Freitas� Data � 01/09/05 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada no Cancelamento de Baixas a Receber para  ���
���          � Validar se a Baixa pode ser Cancelada Baseada no Parametro ���
���          � MV_DATAFIN                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/


/*
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. - CANCELA A BAIXA - .F. - N�O CANCELA A BAIXA          ���
�������������������������������������������������������������������������Ĵ��
*/

#include "rwmake.ch"

user function fa070ca4()
_lok:=.t.
if abaixase5[len(abaixase5),10]<=getmv("MV_DATAFIN")
	_lok:=.f.
	help(" ",1,"DTMOVFIN")
endif
return(_lok)
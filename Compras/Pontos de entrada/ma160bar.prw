/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MA160BAR � Autor � Heraildo C. de Freitas� DATA � 16/03/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada na analise das cotacoes de compras para   ���
���          � inclusao de um botao especifico para consulta do historico ���
���          � de compras do produto                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function ma160bar()
_abotao:={} 
aadd(_abotao,{"HISTORIC",{|| U_VIT262(sc8->c8_produto)},"Hist�rico"})
return(_abotao)

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT145   � Autor � Heraildo C. de Freitas� Data � 15/08/03 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao na Digitacao do Lote no Lancamento do Inventario ���
���          � para nao Permitir a Digitacao de Lotes Vencidos            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vit145()
_lok:=.t.
_nordsb8:=sb8->(indexord())
_nregsb8:=sb8->(recno())

_cfilsb8:=xfilial("SB8")
sb8->(dbsetorder(3))

sb8->(dbseek(_cfilsb8+m->b7_cod+m->b7_local+m->b7_lotectl))
if sb8->b8_dtvalid<m->b7_data
	_lok:=.f.
	msgstop("Lotes vencidos n�o podem ser inventariados!")
endif

sb8->(dbsetorder(_nordsb8))
sb8->(dbgoto(_nregsb8))
return(_lok)

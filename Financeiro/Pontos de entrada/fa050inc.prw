/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ�
���Programa  � FA050INC � Autor � Heraildo C. de Freitas� Data � 03/09/03 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada para Exigir a Digitacao do Centro de Custo���
���          � na Inclusao de Contas a Pagar                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function fa050inc()
_lok:=.t.
_cfilsed:=xfilial("SED")
sed->(dbsetorder(1))
sed->(dbseek(_cfilsed+m->e2_naturez))
if ! empty(sed->ed_codrat)
	if m->e2_rateio<>"S"
		_lok:=.f.
		msginfo("Favor informar o rateio!")
	endif
elseif sed->ed_ccobrig=="S" .and.;
	empty(m->e2_cc)
	_lok:=.f.
	msginfo("Favor informar o centro de custo!")
endif
return(_lok)
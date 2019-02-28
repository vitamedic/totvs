/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � LP002      � Autor � Heraildo C. Freitas � Data � 08/02/07 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna Valor ou Conta Contabil para o Lancamento Padrao   ���
���          � de Compensacao de Recebimento Antecipado                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� VL = Valor                                                 ���
���          � DB = Conta Debito                                          ���
���          � CR = Conta Credito                                         ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function lp002(_ctipo)
_aarea   :=getarea()
_aarease1:=se1->(getarea())
_aareased:=sed->(getarea())

_ret:=""

if _ctipo$"VL/DB"
	_ccond:='! SE1->E1_TIPO$"NCC/RA "'
else
	_ccond:='SE1->E1_TIPO$"NCC/RA "'
endif

if &_ccond
	se1->(dbsetorder(1))
	se1->(dbseek(xfilial("SE1")+left(se5->e5_documen,13)))
	sed->(dbsetorder(1))
	sed->(dbseek(xfilial("SED")+se1->e1_naturez))
endif

if _ctipo=="VL" // VALOR
	if se1->e1_origem<>"MATA100 "
		_ret:=se5->e5_valor
	endif
elseif _ctipo=="DB" // CONTA DEBITO
	_ret:="1102010900081"
elseif _ctipo=="CR" // CONTA CREDITO
	if se1->e1_tipo=="CH "
		_ret:="1101030211321"
	elseif ! empty(sed->ed_provis)
		_ret:=sed->ed_provis
	elseif empty(sa1->a1_conta)
		_ret:="A1_CONTA"
	else
		_ret:=sa1->a1_conta
	endif
endif

se1->(restarea(_aarease1))
sed->(restarea(_aareased))
restarea(_aarea)
return(_ret)

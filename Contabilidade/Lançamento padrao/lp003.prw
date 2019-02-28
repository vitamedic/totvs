/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � LP003      � Autor � Heraildo C. Freitas � Data � 08/02/07 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna Valor ou Conta Contabil para o Lancamento Padrao   ���
���          � de Compensacao de Pagamento Antecipado                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� VL = Valor                                                 ���
���          � DB = Conta Debito                                          ���
���          � CR = Conta Credito                                         ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function lp003(_ctipo)
_aarea   :=getarea()
_aarease2:=se2->(getarea())
_aareased:=sed->(getarea())

_ret:=""

if _ctipo$"VL/DB"
	_ccond:='! SE2->E2_TIPO$"NDF/PA "'
else
	_ccond:='SE2->E2_TIPO$"NDF/PA "'
endif

if &_ccond
	se2->(dbsetorder(1))
	se2->(dbseek(xfilial("SE2")+left(se5->e5_documen,13)+se5->e5_fornece+se5->e5_loja))
	sed->(dbsetorder(1))
	sed->(dbseek(xfilial("SED")+se2->e2_naturez))
endif

if _ctipo=="VL" // VALOR
	if se2->e2_origem<>"MATA460 "
		_ret:=se5->e5_valor
	endif
elseif _ctipo=="DB" // CONTA DEBITO
	if ! empty(sed->ed_provis)
		_ret:=sed->ed_provis
	elseif empty(sa2->a2_conta)
		_ret:="A2_CONTA"
	else
		_ret:=sa2->a2_conta
	endif
elseif _ctipo=="CR" // CONTA CREDITO
	if empty(sed->ed_provis)
		_ret:="ED_PROVIS"
	else
		_ret:=sed->ed_provis
	endif
endif

se2->(restarea(_aarease2))
sed->(restarea(_aareased))
restarea(_aarea)
return(_ret)

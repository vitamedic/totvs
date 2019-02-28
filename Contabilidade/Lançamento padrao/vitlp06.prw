/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VITLP06  � Autor � Heraildo C. de Freitas� Data � 17/05/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna a Conta Contabil no Lancamento Padronizado de Baixa���
���          � de Titulos a Pagar (530-01)                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vitlp06()
_cconta:="INDEFINIDO"
sed->(dbseek(xfilial("SED")+se2->e2_naturez))
if se2->e2_origem=="FINA050 " .or. empty(se2->e2_origem)
	if sed->ed_status=="1"
		if empty(sed->ed_provis)
			if empty(sa2->a2_conta)
				_cconta:="C.FORN.BRANCO"
			else
				_cconta:=sa2->a2_conta
			endif
		else
			_cconta:=sed->ed_provis
		endif
	else
		if empty(sed->ed_conta)
			_cconta:="C.DESP.BRANCO"
		else
			_cconta:=sed->ed_conta
		endif
	endif
else
	if empty(sa2->a2_conta) 
		if empty(sed->ed_conta)
		   _cconta:="C.FORN.BRANCO"
		else
			_cconta:=sed->ed_conta
		endif
	else
		_cconta:=sa2->a2_conta
	endif
endif
return(_cconta)
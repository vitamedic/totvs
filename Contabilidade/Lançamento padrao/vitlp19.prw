/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VITLP19  � Autor � Heraildo C. de Freitas� Data � 17/05/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna o Valor da Multa no Lancamento Padronizado de      ���
���          � Geracao de Cheques (590-04)                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vitlp19()
_nvalor:=0
if valor==0
	_lok:=.f.
	if se2->e2_origem=="FINA050 " .or. empty(se2->e2_origem)
		if sed->(dbseek(xfilial("SED")+se2->e2_naturez)) .and.;
			sed->ed_status$"13"
			_lok:=.t.
		endif
	else
		_lok:=.t.
	endif
	if _lok
		_nvalor:=se2->e2_multa
	endif
endif
return(_nvalor)
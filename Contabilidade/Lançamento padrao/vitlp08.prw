/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VITLP08  � Autor � Heraildo C. de Freitas� Data � 17/05/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna o Valor dos Juros no Lancamento Padronizado de     ���
���          � Baixa a Pagar (530-02)                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vitlp08()
_cfilsed:=xfilial("SED")
sed->(dbsetorder(1))
_nvalor:=0
if se5->e5_tipodoc<>"BA" .and.;
	se5->e5_motbx$"NOR/DEB" .and.;
	if(se2->e2_origem=="FINA050 " .or. empty(se2->e2_origem),sed->(dbseek(_cfilsed+se2->e2_naturez)) .and. sed->ed_status$"13",.t.) .and.;
	(! empty(se2->e2_numbco) .or. left(se5->e5_banco,2)=="CX" .or. se5->e5_motbx=="DEB")
	_nvalor:=se2->e2_juros
endif
return(_nvalor)
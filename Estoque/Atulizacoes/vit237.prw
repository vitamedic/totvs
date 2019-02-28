/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT237   � Autor � Aline B. Pereira      � Data � 05/07/05 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao no Centro de Custo da Requisicao ao Armazem      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vit237()
_cfilszh:=xfilial("SZH")
szh->(dbsetorder(1))
szh->(dbseek(_cfilszh+__cuserid))
_lok:=.f.
while ! szh->(eof()) .and.;
	szh->zh_filial==_cfilszh .and.;
	szh->zh_codusr==__cuserid .and.;
	!_lok
	
	_npos:=len(alltrim(szh->zh_cc))
	if alltrim(szh->zh_cc)==substr(m->cp_cc,1,_npos) .and.;
		szh->zh_tipo$"SA"
		_lok:=.t.
	endif
	szh->(dbskip())
end
if !_lok
	msginfo("Usuario sem autoriza��o para efetuar requisi��o deste centro de custo!")
endif
return(_lok)

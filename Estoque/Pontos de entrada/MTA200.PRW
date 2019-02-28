/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MTA200   � Autor � Edson G. Barbosa      � Data � 19/03/04 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada na Alteracao das Estruturas para          ���
���          � Verificar se e Permitida a Alteracao Conforme o Campo      ���
���          � B1_ALTESTR do Cadastro de Produtos                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function MTA200()  
if inclui
	return .t.
endif	
_lok:=.t.
_nordsb1:=sb1->(indexord())
_nregsb1:=sb1->(recno())
_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))
sb1->(dbseek(_cfilsb1+sg1->g1_cod))
if sb1->b1_altestr=="N" .or. (sb1->b1_altestr=="S" .and. sb1->b1_valestr < dDatabase)
	_lok:=.f.
	msginfo("Nao e permitida alteracao da estrutura deste produto!")
endif
sb1->(dbsetorder(_nordsb1))
sb1->(dbgoto(_nregsb1))
return(_lok)
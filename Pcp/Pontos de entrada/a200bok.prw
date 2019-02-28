/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � A200BOK   �Autor � Heraildo C. de Freitas �Data � 30/01/02 ���
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

user function a200bok()
if inclui
	return .t.
endif	
_aregs:=paramixb[1]
_ccod :=paramixb[2]
_lok:=.t.
_nordsb1:=sb1->(indexord())
_nregsb1:=sb1->(recno())
_cfilsb1:=xfilial("SB1")
sb1->(dbsetorder(1))
sb1->(dbseek(_cfilsb1+_ccod))      
if sb1->b1_altestr=="N" .or. (sb1->b1_altestr=="S" .and. sb1->b1_valestr < dDatabase)
	_lok:=.f.
	msginfo("Nao e permitida alteracao da estrutura deste produto!")
endif
sb1->(dbsetorder(_nordsb1))
sb1->(dbgoto(_nregsb1))
return(_lok)
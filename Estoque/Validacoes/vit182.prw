/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT182   � Autor � Edson Gomes Barbosa   � Data � 15/03/04 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao na Digitacao do Campo B1_ALTESTR                 ���
���          � para nao Permitir Colocar "S" QDO E1_VALESTR > DDATABASE   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

user function vit182()
_lok:=.t.

if m->b1_altestr=="S" .and. (empty(m->b1_valestr) .or. m->b1_valestr > dDatabase)
	_lok:=.f.
	msgstop("Data de validade para alterar estrutura Vencido, "+chr(13)+"verifique com Diretoria")
endif

return(_lok)

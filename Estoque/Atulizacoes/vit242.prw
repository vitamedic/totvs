/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT242   � Autor � Heraildo C. Freitas   � Data � 08/09/05 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Filtro na Chamada da Rotina de Solicitacoes ao Armazem     ���
���          � para Mostrar somente as Solicitacoes do Usuario Corrente   ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/


#include "rwmake.ch"

user function vit242()
_cfilscp:=xfilial("SCP")

scp->(dbsetfilter({|| cp_filial==_cfilscp .and. cp_solicit==cusername .and. cp_datalib==ctod('  /  /  ') .and. cp_quje==0},;
							"cp_filial==_cfilscp .and. cp_solicit==cusername .and. cp_datalib==ctod('  /  /  ') .and. cp_quje==0"))

mata105()

scp->(dbclearfil())
return
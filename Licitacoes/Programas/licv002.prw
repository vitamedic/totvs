/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � LICV002  � Autor � Heraildo C. de Freitas� Data �29/09/2003���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao no Representante na Inclusao de Propostas        ���
���          � para Atualizar os Dados de Comissao                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
user function licv002()       
_lok:=.t.    

_cfilsa3:=xfilial("SA3")

sa3->(dbsetorder(1))
sa3->(dbseek(_cfilsa3+m->zl_repres))
_nregsa3:=sa3->(recno())
m->zl_comis1:=sa3->a3_comis
_csuper:=sa3->a3_super
_cgeren:=sa3->a3_geren
sa3->(dbseek(_cfilsa3+_csuper))
m->zl_comis2:=sa3->a3_comis
sa3->(dbseek(_cfilsa3+_cgeren))
m->zl_comis3:=sa3->a3_comis
sa3->(dbgoto(_nregsa3)) 
return(_lok)
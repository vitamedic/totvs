#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT330   � Autor � Alex J�nio de Miranda � Data �04/11/2008���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna Numero Sequencial de Arquivo para Cnab Caixa       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/


user function vit330(_bco,_ag,_cta)

_cfilsee:=xfilial("SEE")
see->(dbsetorder(1))

see->(dbseek(_cfilsee+_bco+_ag+_cta+'002'))

_numseq:=val(see->ee_ultdsk)
_numseq++


see->(reclock("SEE",.f.))
see->ee_ultdsk:=strzero(_numseq,6)
see->(msunlock())

return(strzero(_numseq,6))
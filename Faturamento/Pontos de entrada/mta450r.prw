/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MTA450R  � Autor � Heraildo C. de Freitas    �Data 05/02/02���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada na Rejeicao da Liberacao de Credito do    ���
���          � Pedido de Venda para Rejeitar Todos os Itens               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

user function mta450r()
_nordsc9:=sc9->(indexord())
_nregsc9:=sc9->(recno())

_cpedido:=sc9->c9_pedido

_cfilsc9:=xfilial("SC9")
sc9->(dbsetorder(1))

sc9->(dbseek(_cfilsc9+_cpedido))
while ! sc9->(eof()) .and.;
		sc9->c9_filial==_cfilsc9 .and.;
		sc9->c9_pedido==_cpedido
	sc9->(reclock("SC9",.f.))
	sc9->c9_blcred:="09"
	sc9->(msunlock())
	sc9->(dbskip())
end
sc9->(dbsetorder(_nordsc9))
sc9->(dbgoto(_nregsc9))
return
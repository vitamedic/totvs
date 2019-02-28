/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT139   � Autor � Heraildo C. de Freitas� Data �23/06/2003���
�������������������������������������������������������������������������Ĵ��
���Descricao � Verifica se o Nivel do Usuario Permite Alteracao da        ���
���          � Comissao do Pedido de Vendas                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vit139()
_lok:=.t.
_cnome :=substr(cusuario,7,15)

psworder(2)

if pswseek(_cnome,.t.)
   _aret:=pswret(3)
   for _i:=1 to len(_aret[1])
	   _cmodulo:=substr(_aret[1,_i],1,2)
   	if _cmodulo=="05" // FATURAMENTO
		   _cnivel:=substr(_aret[1,_i],3,1)
		endif
	next
	if _cnivel<="5"
		_lok:=.f.
	endif
endif
return(_lok)
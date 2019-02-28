/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � LICGEN  � Autor �                       � Data �           ���
�������������������������������������������������������������������������Ĵ��
���Descricao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"


USER Function SalvaAmbiente(mArea)
Local x := 0
Local mAlias := {}
//���������������������������������������������������������������������Ŀ
//� Salvando ambiente antes de executar a funcao do usuario que altera ponteiro de tabelas
//�����������������������������������������������������������������������

AaDd(mAlias,{Alias(),IndexOrd(),Recno()})

For x := 1 to Len(mArea)
	DbSelectArea(mArea[x])
	AaDd(mAlias,{Alias(),IndexOrd(),Recno()})
next x


Return (mAlias)

//���������������������������������������������������������������������Ŀ
//� Restaurando o ambiente apos a execucao da funcao de usuario que altera ponteiros de tabelas
//�����������������������������������������������������������������������

USER Function VoltaAmbiente(mAlias)

Local x := 0

For x:= 1 to Len(mAlias)
	
	DbSelectArea(mAlias[x,1])
	DbSetOrder(mAlias[x,2])
	DbGoto(mAlias[x,3])
	
Next x

DbSelectArea(mAlias[1,1])
DbSetOrder(mAlias[1,2])
DbGoto(mAlias[1,3])



Return NIL


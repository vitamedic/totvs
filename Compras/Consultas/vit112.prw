#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 16/10/02

User Function vit112()        // incluido pelo assistente de conversao do AP6 IDE em 16/10/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CCADASTRO,AROTINA,")

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � VIT112   � Autor � Gardenia� Data � 16/10/02               ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Browse para consulta de clientes especifica                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

ccadastro:='Consulta Notas de entrada'
arotina:={{'Pesquisar','axpesqui',0,1},;
			 {'Notas   ','execblock("VIT112A")',0,2}} &&,;
//			 {'Notas fiscais','execblock("VIT112C")',0,2}}
dbselectarea("SB1")
dbsetorder(1)
dbgotop()
mbrowse(6,1,22,75,"SB1")
return

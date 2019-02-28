#include "rwmake.ch"


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � LIC001   �Autor  � Marcelo Myra       � Data �  08/19/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Propostas                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � AP6                                                        ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

User Function LIC001()

LOCAL aCORES  := {{'ZL_STATUS=="1" .and. (DDATABASE <= (ZL_DIASVAL+ZL_DTABER))',"ENABLE" },; 	
            	  {'ZL_STATUS=="2" .and. (DDATABASE <= (ZL_DIASVAL+ZL_DTABER))',"BR_AMARELO"},; 
            	  {'ZL_STATUS=="3" .and. (DDATABASE <= (ZL_DIASVAL+ZL_DTABER))',"BR_AZUL"},; 	
            	  {'ZL_STATUS=="4"',"DISABLE"},;
            	  {'ZL_STATUS<>"4" .and. (DDATABASE > (ZL_DIASVAL+ZL_DTABER))',"BR_PRETO"}}

	U_AxModelo3("SZL","SZM","ZL_NUMPRO","ZM_NUMPRO","ZM_CODPRO","Cadastro de Propostas","PVIAELN",aCores)


Return(.t.)
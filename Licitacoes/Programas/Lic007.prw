#include "rwmake.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LIC007    �Autor  �Marcelo Myra        � Data �  08/19/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Acompanhamento de Processos                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LIC007()

LOCAL aCORES  := {{'EMPTY(ZL_STATUS)',"BR_CINZA" },; 	
            	  {'ZL_STATUS=="1"',"BR_AZUL"},; 		 
            	  {'ZL_STATUS=="2"',"BR_AMARELO"},; 	// Processo iniciado (proposta encaminhada)
            	  {'ZL_STATUS=="3"',"DISABLE"},; 		// Grade de pre�os preenchida
            	  {'ZL_STATUS=="4"',"BR_LARANJA"},; 	// Grade de pre�os preenchida com empate
            	  {'ZL_STATUS=="5"',"ENABLE"}} 			// Processo finalizado (c/ou s/ itens fornecidos)


PRIVATE cCADASTRO 	:= "Acompanhamento de Processos de Licita��o"
PRIVATE	aRotina	:= {{ "Pesquisar","AxPesqui", 0 , 1},;
{ "Atualizar","U_Processo()", 0 , 2}}
            	     
// executa a mBrowse
dbSelectArea("SZL")
dbSetOrder(1)
mBrowse(6,01,22,75,"SZL",,,'SZL->ZL_STATUS#"1"',,,aCORES)

Return(.t.)


User function Processo()

return(.t.)

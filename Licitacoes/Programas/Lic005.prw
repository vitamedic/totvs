#include "rwmake.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LIC005    �Autor  �Marcelo Myra        � Data �  08/19/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Cadastro de Documentos                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LIC005()

LOCAL aCORES  := {{'ZO_DT_VENC < DDATABASE',"DISABLE" },;
            	  {'(ZO_DT_VENC - ZO_DIASALE) > DDATABASE' ,"ENABLE"},; 		
            	  {'(ZO_DT_VENC > DDATABASE) .AND. ((ZO_DT_VENC - ZO_DIASALE) <= DDATABASE)',"BR_AMARELO"}}

PRIVATE cCADASTRO 	:= "Cadastro de Documentos"

PRIVATE aRotina := {{ "Pesquisa","AxPesqui", 0 , 1},;
	      	{ "Visual","AxVisual", 0 , 2},;
    	  	{ "Inclui","AxInclui", 0 , 3},;
      		{ "Altera","AxAltera", 0 , 4, 20 },;
		    { "Exclui","AxDeleta", 0 , 5, 21 }}

// executa a mBrowse
dbSelectArea("SZO")
dbSetOrder(1)
mBrowse(6,01,22,75,"SZO",,,,,,aCORES)
		    
Return(nil)

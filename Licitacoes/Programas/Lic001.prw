#include "rwmake.ch"


/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � LIC001   矨utor  � Marcelo Myra       � Data �  08/19/02   潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北矰escricao � Cadastro de Propostas                                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � AP6                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function LIC001()

LOCAL aCORES  := {{'ZL_STATUS=="1" .and. (DDATABASE <= (ZL_DIASVAL+ZL_DTABER))',"ENABLE" },; 	
            	  {'ZL_STATUS=="2" .and. (DDATABASE <= (ZL_DIASVAL+ZL_DTABER))',"BR_AMARELO"},; 
            	  {'ZL_STATUS=="3" .and. (DDATABASE <= (ZL_DIASVAL+ZL_DTABER))',"BR_AZUL"},; 	
            	  {'ZL_STATUS=="4"',"DISABLE"},;
            	  {'ZL_STATUS<>"4" .and. (DDATABASE > (ZL_DIASVAL+ZL_DTABER))',"BR_PRETO"}}

	U_AxModelo3("SZL","SZM","ZL_NUMPRO","ZM_NUMPRO","ZM_CODPRO","Cadastro de Propostas","PVIAELN",aCores)


Return(.t.)
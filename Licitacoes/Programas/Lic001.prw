#include "rwmake.ch"


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ LIC001   ³Autor  ³ Marcelo Myra       ³ Data ³  08/19/02   ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Cadastro de Propostas                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AP6                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function LIC001()

LOCAL aCORES  := {{'ZL_STATUS=="1" .and. (DDATABASE <= (ZL_DIASVAL+ZL_DTABER))',"ENABLE" },; 	
            	  {'ZL_STATUS=="2" .and. (DDATABASE <= (ZL_DIASVAL+ZL_DTABER))',"BR_AMARELO"},; 
            	  {'ZL_STATUS=="3" .and. (DDATABASE <= (ZL_DIASVAL+ZL_DTABER))',"BR_AZUL"},; 	
            	  {'ZL_STATUS=="4"',"DISABLE"},;
            	  {'ZL_STATUS<>"4" .and. (DDATABASE > (ZL_DIASVAL+ZL_DTABER))',"BR_PRETO"}}

	U_AxModelo3("SZL","SZM","ZL_NUMPRO","ZM_NUMPRO","ZM_CODPRO","Cadastro de Propostas","PVIAELN",aCores)


Return(.t.)
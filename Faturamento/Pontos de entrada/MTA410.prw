#INCLUDE "PROTHEUS.CH"  				
#INCLUDE "COLORS.CH"	
#INCLUDE "TBICONN.CH"  

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MTA410 � Autor � Ricardo Moreira � Data �14/04/2016���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada para validar o item para que n�o coloque  ���
���          � o tipo de PN , junto com PA.				                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/
User Function MTA410()
     Local uRet := .T. //PN e PA    
/*     Local xProd := " " 
               
     For i:= 1 to Len(aCols)
         If !aCols[i,Len(aHeader)+1]     
            xProd += aCols[i,GdFieldPos("C6_TIPO",aHeader)]              
         EndIf        
     Next 
          
     If "PA" $ xProd .and. "PN" $ xProd
        uRet := .F.   
        Alert("N�o Permitido Produto Acabado com Produto Nutrac�utico.")       
     EndIf*/     
Return uRet
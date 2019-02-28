#INCLUDE "PROTHEUS.CH"  				
#INCLUDE "COLORS.CH"	
#INCLUDE "TBICONN.CH"  

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MTA410 � Autor � Ricardo Moreira �         Data �28/04/2016���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada para alterar a data de validade do PI     ���
���          � Entrada da OP.			                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/
                                      
User Function MTAGRSD4()
Local dVldt := CTOD("  /  /  ") 
Local aArea    := GetArea()

If SUBSTR(SD4->D4_COD,1,2) == "PI"
  dVldt   := SD4->D4_DTVALID  

  Dbselectarea("SC2")                                                      
  SC2->(reclock("SC2",.f.))
  SC2->C2_DTVALID:= dVldt
  SC2->(msunlock())

  RestArea(aArea)

EndIf

Return

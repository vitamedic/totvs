#INCLUDE "PROTHEUS.CH"  				
#INCLUDE "COLORS.CH"	
#INCLUDE "TBICONN.CH"  

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � MTA410 � Autor � Ricardo Moreira �         Data �28/04/2016潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Ponto de entrada para alterar a data de validade do PI     潮�
北�          � Entrada da OP.			                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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

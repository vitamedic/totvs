/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � Vit235  � Autor � Gardenia Ilany     � Data �  14/08/03    ���
�������������������������������������������������������������������������͹��
���Descricao � Trazer Total do Border�                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

Function U_vit235(_bordero)

#include "rwmake.ch"
#include "topconn.ch"

Local _aarea:= getarea()
Local _saldo 

//msgstop(_bordero)
_cfilse1:=xfilial("SE1")
_cquery:=" SELECT"
_cquery+=" SUM(E1_SALDO) SALDO"
_cquery+=" FROM "
_cquery+=" SE1010 SE1"
_cquery+=" WHERE"
_cquery+="     SE1.D_E_L_E_T_<>'*'"
_cquery+=" AND E1_FILIAL='"+_cfilse1+"'"
_cquery+=" AND E1_NUMBOR='"+_bordero+"'"


_cquery:=changequery(_cquery)
tcquery _cquery new alias "TMP1"

tmp1->(dbgotop())
_saldo:=tmp1->saldo

tmp1->(dbclosearea())
restarea(_aarea)             
Return (strzero(int(_saldo*100),15)                          )

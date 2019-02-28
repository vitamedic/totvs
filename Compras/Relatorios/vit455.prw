#include 'protheus.ch'
#include 'topconn.ch'
#include 'totvs.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � vit455   �Autor �                                          ���
�������������������������������������������������������������������������͹��
���Desc.     � Numera��o do PA customizado                                ���
�������������������������������������������������������������������������͹��
���Uso       � Compras                                                    ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � Stephen Noel de Melo Ribeiro                    ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VIT455()
Local _cquery
Local ProxN

_cquery:=" SELECT"
_cquery+=" MAX(Z41_PA) PROXNUM"
_cquery+=" FROM "
_cquery+=  retsqlname("Z41")+" Z41"
_cquery+=" where z41.D_E_L_E_T_ = ' ' "
_cquery:=changequery(_cquery)			
tcquery _cquery new alias "TMP1"

tmp1->(DbGoTop())
ProxN := SOMA1(TMP1->PROXNUM)
Tmp1->(DbCloseArea())

Return(ProxN)

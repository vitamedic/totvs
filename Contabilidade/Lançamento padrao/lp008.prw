/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP008     �Autor  � Totvs-GO           � Data �  27/06/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para retornar a conta por C.Custo                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � LP 666 - Invent�rio                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function lp008(cCusto)
_cconta:="INDEFINIDO TM "+sd3->d3_tm
if cCusto$"28000000/28000001/28010004/28020000/28030002/29050100/29050102/29050105/29050106" 
	_cconta:="4101029913614"
elseif substr(sd3->d3_cc,1,2)$"28/29" 
	_cconta:="3501029918622"
elseif substr(sd3->d3_cc,1,2)$"20/21/22/24" 
	_cconta:="4101029913614"
elseif substr(sd3->d3_cc,1,2)$"23" 
	_cconta:="4102029916719"
endif
return(_cconta)

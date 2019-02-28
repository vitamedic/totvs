/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT098   � Autor � Gardenia Ilany        � Data �26/08/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna Numero Sequencial para Utilizacao no Cnab do Rural ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vit098(_cNum)
static _nseq
static _cControle

if _nseq==nil
	_nseq:=1
else
	_nseq++
endif
if _cNum == "2"
	_cControle := _nseq
endif
if _cNum == "3"
	_cControle := _cControle+1
	return(strzero(_cControle,6))
endif
return(strzero(_nseq,6))
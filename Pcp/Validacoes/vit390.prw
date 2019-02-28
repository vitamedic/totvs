/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT390   � Autor � Andr� Almeida Alves   � Data � 19/12/13 ���
�������������������������������������������������������������������������Ĵ��
���          � Valida se o colaborador que esta realizando o apontamento  ���
���          � de Produ��o esta alocado ao centro de trabalho da fase     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"
#include "dialog.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#INCLUDE "protheus.ch"

User Function vit390()
	_lOk			:= .t.
	_dUsuario     := PSWRET()
	_cMatFunc		:= substr(_dUsuario[1][22],5,6)
	_cCCFunc		:= Posicione("SRA",1,xFilial("SRA")+_cMatFunc,'RA_CC')
	_cRoteiro		:= Posicione("SC2",1,xFilial("SC2")+Substr(m->h6_op,1,6),'C2_ROTEIRO')
	_cCTrab		:= Posicione("SG2",1,xFilial("SRA")+m->h6_produto+_cRoteiro+m->h6_operac,'G2_CTRAB')
	_cCCCTrab		:= Posicione("SHB",1,xFilial("SHB")+_cCTrab,'HB_CC')
	
	if !_cCCFunc $('29050000/22050000') .and. Substr(m->h6_op,1,6)>='030200'
		if _cCCFunc <> _cCCCTrab
			Alert("Voc� n�o pode realizar apontamentos para esta fase de Produ��o, Voc� so pode realizar apontamentos para seu centro de trabalho.")
			_lOk	:= .f.
		endif
	endif
Return(_lOk)
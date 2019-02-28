/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT390   � Autor � Andr� Almeida Alves   � Data � 19/12/13 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北�          � Valida se o colaborador que esta realizando o apontamento  潮�
北�          � de Produ玢o esta alocado ao centro de trabalho da fase     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
			Alert("Voc� n媜 pode realizar apontamentos para esta fase de Produ崑o, Voc� so pode realizar apontamentos para seu centro de trabalho.")
			_lOk	:= .f.
		endif
	endif
Return(_lOk)
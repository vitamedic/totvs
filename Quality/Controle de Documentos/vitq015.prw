/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � VITQ015   �Autor � Programacao Quality   �Data � 20/11/07  ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Valida Usuarios para Inclusao de Documentos no Modulo de   ���
��           � Controle de Documentos Somente por Usuarios da Garantia    ���
��           � da Qualidade.                                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/
#include "topconn.ch"
#include "rwmake.ch"    

User Function vitq015()

_lok := .f.
_nomeuser := substr(cusuario,7,15)
qaa->(dbsetorder(6))

if qaa->(dbseek(_nomeuser))
	if alltrim(qaa->qaa_cc) $"010128020000/010128020001"
		_lok:=.t.
	elseif (alltrim(qaa->qaa_cc)=='010128020002').and.(alltrim(m->qdh_codtp)=='PROT')
		_lok:=.t.
	else      
		msginfo('O Usuario(a): '+qaa->qaa_nome+', nao tem permissao para incluir documentos do tipo '+m->qdh_codtp)
		m->qdh_codtp:=""
		_lok:=.f.
	endif
endif
return(_lok)
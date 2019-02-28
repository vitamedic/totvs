/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT384   �Autor � Andr� Almeida Alves     �Data � 20/06/13 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gatilho para permitir altera��o da data de validade do     ���
���          � Produto na abertura da OP, porem somenete para os Produtos ���
���          � cujo constam no chamado 000436.                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/
//O Parametro MV_PRODBEN foi criado para Armazenar os c�digos dos Produtos
//que podem ter as datas de validade alteradas no momento da abertura da OP
//isto se d� devido ao Produto receber beneficiamento e a data de validade
//deve ser a mesma da MP.

#include "rwmake.ch"
#Include "Protheus.ch"

User Function vit384()

_cProd 		:= getmv("MV_PRODBEN")
_lRet 		:= .t.
_dDtVencLt	:= u_vit065()

if !Alltrim(m->c2_produto) $ _cProd .and.  _dDtVencLt <> m->c2_dtvalid
	Alert("N�o e permitido a altera��o da data de Validade para este Produto!")
	_lRet := .f.
endif
Return(_lRet)
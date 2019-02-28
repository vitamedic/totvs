/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT384   矨utor � Andr� Almeida Alves     矰ata � 20/06/13 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Gatilho para permitir altera玢o da data de validade do     潮�
北�          � Produto na abertura da OP, porem somenete para os Produtos 潮�
北�          � cujo constam no chamado 000436.                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
//O Parametro MV_PRODBEN foi criado para Armazenar os c骴igos dos Produtos
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
	Alert("N鉶 e permitido a altera玢o da data de Validade para este Produto!")
	_lRet := .f.
endif
Return(_lRet)
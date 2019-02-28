/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VIT384   ³Autor ³ André Almeida Alves     ³Data ³ 20/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gatilho para permitir alteração da data de validade do     ³±±
±±³          ³ Produto na abertura da OP, porem somenete para os Produtos ³±±
±±³          ³ cujo constam no chamado 000436.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
//O Parametro MV_PRODBEN foi criado para Armazenar os códigos dos Produtos
//que podem ter as datas de validade alteradas no momento da abertura da OP
//isto se dá devido ao Produto receber beneficiamento e a data de validade
//deve ser a mesma da MP.

#include "rwmake.ch"
#Include "Protheus.ch"

User Function vit384()

_cProd 		:= getmv("MV_PRODBEN")
_lRet 		:= .t.
_dDtVencLt	:= u_vit065()

if !Alltrim(m->c2_produto) $ _cProd .and.  _dDtVencLt <> m->c2_dtvalid
	Alert("Não e permitido a alteração da data de Validade para este Produto!")
	_lRet := .f.
endif
Return(_lRet)
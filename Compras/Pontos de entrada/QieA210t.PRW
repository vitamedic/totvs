#include "rwmake.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  砆IEA210T  � Autor  矻鷆ia Val閞ia       � Data �  07/08/04  潮�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯潮�
北矰esc.     � Ponto de entrda apos a grava玢o do QEK para Gravar         潮�
北�          � a data de validade do lote do Fornecedor                   潮�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯潮�
北砋so       � AP                                                         潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/
User Function QieA210t()

If empty(QEP->QEP_ERRO) // Verifico se n鉶 existiu nenhum inconsistencia entre a QIExProduto
	QEK->(RecLock("QEK",.f.) )
	QEK->QEK_OBS := DtoC(SD1->D1_DTVALID) // 
	QEK->(MsUnLock())
EndIf

Return(.t.)
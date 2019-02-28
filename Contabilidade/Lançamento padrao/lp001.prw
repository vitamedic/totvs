/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � LP001      � Autor � Heraildo C. Freitas � Data � 08/02/07 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna a Conta Contabil para os Lancamentos Padronizados  潮�
北�          � de Notas Fiscais de Entrada e Notas Fiscais de Saida       潮�
北�          � de Acordo com a Regra de Contabilizacao                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function lp001(_ctipo)
_cconta:=""

_cfilszq:=xfilial("SZQ")

_ccampo:="ZQ_"+upper(alltrim(_ctipo))
	
szq->(dbsetorder(3))
if szq->(dbseek(_cfilszq+sf4->f4_tpcont+sb1->b1_cod))
	_cconta:=szq->(fieldget(fieldpos(_ccampo)))
else
	szq->(dbsetorder(4))
	if szq->(dbseek(_cfilszq+sf4->f4_tpcont+sb1->b1_grupo))
		_cconta:=szq->(fieldget(fieldpos(_ccampo)))
	else
		szq->(dbsetorder(1))
		if szq->(dbseek(_cfilszq+sf4->f4_tpcont+sb1->b1_tipo))
			_cconta:=szq->(fieldget(fieldpos(_ccampo)))
		elseif szq->(dbseek(_cfilszq+sf4->f4_tpcont))
			_cconta:=szq->(fieldget(fieldpos(_ccampo)))
		endif
	endif
endif
_cconta:=&_cconta
if empty(_cconta)
	_cconta:="Tp."+sf4->f4_tpcont+" "+Alltrim(GetTit(_ccampo))+" INDEFINIDO"
endif
return(_cconta)


Static Function GetTit(cField)
Local aArea := GetArea()
Local cTitulo
dbSelectArea('SX3')
dbSetOrder(2)
If dbSeek( cField )   
  cTitulo := X3Titulo()
EndIf      
RestArea(aArea)
Return cTitulo




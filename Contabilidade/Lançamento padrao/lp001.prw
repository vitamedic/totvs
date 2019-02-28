/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � LP001      � Autor � Heraildo C. Freitas � Data � 08/02/07 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna a Conta Contabil para os Lancamentos Padronizados  ���
���          � de Notas Fiscais de Entrada e Notas Fiscais de Saida       ���
���          � de Acordo com a Regra de Contabilizacao                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
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




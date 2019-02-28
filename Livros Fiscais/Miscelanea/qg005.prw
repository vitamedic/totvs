/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � Qg005   � Autor �                       � Data �           ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Reordenacao dos Codigos dos Bens do CIAP (SF9)             ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/


#include "rwmake.ch"

user function qg005()
if msgyesno("Confirma reordena��o dos c�digos do CIAP?")
	processa({|| _atualiza()})
	msginfo("Reordena��o finalizada com sucesso!")
endif
return()

static function _atualiza()
_cfilsf9:=xfilial("SF9")

procregua(sf9->(lastrec()))

_ccodigo:="000001"

sf9->(dbsetorder(2))
sf9->(dbseek(_cfilsf9))
while ! sf9->(eof()) .and.;
	sf9->f9_filial==_cfilsf9
	
	incproc("Reordenando... "+dtoc(sf9->f9_dtentne))
	
	sf9->(reclock("SF9",.f.))
	sf9->f9_codigo:=_ccodigo
	sf9->(msunlock())
	
	_ccodigo:=soma1(_ccodigo,6)
	
	sf9->(dbskip())
end
return()
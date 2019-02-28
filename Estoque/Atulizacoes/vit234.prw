/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � VIT234   � Autor � Aline B. Pereira      � Data � 05/07/05 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao para Acesso do Usuario a Requisao AO ARMAZEM por ���
���          � Grupo de Produto.                                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Vitapan                                    ���
��������������������������������������������������������������������������ٱ�
���Versao    � 1.0                                                        ���
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"

user function vit234()
_cfilsb1:=xfilial("SB1")
_cfilszh:=xfilial("SZH")
sb1->(dbsetorder(1))
szh->(dbsetorder(1))

sb1->(dbseek(_cfilsb1+m->cp_produto)) 
szh->(dbseek(_cfilszh+__cuserid))
_lok:=.f.

while ! szh->(eof()) .and.;
	szh->zh_filial==_cfilszh .and.;
	szh->zh_codusr==__cuserid .and.;  
	!_lok              	

	if sb1->b1_grupo==szh->zh_grupo .and.;
		szh->zh_tipo$"SA"
		_lok:=.t.
	endif       
	szh->(dbskip())
end                                                                            
if !_lok
	msginfo("Usuario sem autoriza��o para efetuar requisi��o deste produto!")
endif		
return(_lok)

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VIT234   � Autor � Aline B. Pereira      � Data � 05/07/05 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Validacao para Acesso do Usuario a Requisao AO ARMAZEM por 潮�
北�          � Grupo de Produto.                                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
	msginfo("Usuario sem autoriza玢o para efetuar requisi玢o deste produto!")
endif		
return(_lok)

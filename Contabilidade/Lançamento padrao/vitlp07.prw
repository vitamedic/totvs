/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北砅rograma  � VITLP07  � Autor � Heraildo C. de Freitas� Data � 17/05/02 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Retorna o Valor do Lancamento Padronizado na Baixa de      潮�
北�          � Titulos a Pagar (530-01)                                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Especifico para Vitapan                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北砎ersao    � 1.0                                                        潮�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

#include "rwmake.ch"

user function vitlp07()
_cfilsed:=xfilial("SED")
sed->(dbsetorder(1))                                                                
_nvalor:=0
//if se5->e5_tipodoc<>"BA" .and.;
If	se5->e5_motbx$"NOR/DEB" .and.;
	if(se2->e2_origem=="FINA050 "  .or. empty(se2->e2_origem),sed->(dbseek(_cfilsed+se2->e2_naturez)) .and. sed->ed_status$"13",.t.) .and.;
	 (! empty(se2->e2_numbco) .or. left(se5->e5_banco,2)=="CX" .or. left(se5->e5_banco,3)=="VIT" .or. se5->e5_motbx=="DEB")
	_nvalor:=se2->e2_valliq-se2->e2_correc-se2->e2_juros-se2->e2_multa+se2->e2_descont

endif
return(_nvalor)
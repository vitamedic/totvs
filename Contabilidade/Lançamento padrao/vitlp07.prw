/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VITLP07  ³ Autor ³ Heraildo C. de Freitas³ Data ³ 17/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna o Valor do Lancamento Padronizado na Baixa de      ³±±
±±³          ³ Titulos a Pagar (530-01)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Vitapan                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Versao    ³ 1.0                                                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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